#tag Class
Protected Class VNSPDFXrefReader
	#tag Method, Flags = &h0
		Function Parse(reader As VNSPDFStreamReader) As VNSPDFCrossReference
		  // Parse the cross-reference table from a PDF file
		  // Returns VNSPDFCrossReference with all entries and trailer

		  // Step 1: Find startxref offset
		  Dim xrefOffset As Integer = FindStartXrefOffset(reader)
		  If xrefOffset = -1 Then
		    Return Nil
		  End If

		  // Step 2: Seek to xref table
		  reader.Reset(xrefOffset)

		  // Step 3: Parse xref table
		  Dim xref As VNSPDFCrossReference = ParseXrefTable(reader)

		  Return xref
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindStartXrefOffsetPublic(reader As VNSPDFStreamReader) As Integer
		  // Public wrapper for FindStartXrefOffset (for testing)
		  Return FindStartXrefOffset(reader)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindStartXrefOffset(reader As VNSPDFStreamReader) As Integer
		  // Scan backwards from end of file to find "startxref" keyword
		  // Returns byte offset of xref table, or -1 if not found

		  Dim fileSize As Integer = reader.GetFileSize()
		  Dim searchSize As Integer = Min(1024, fileSize)  // Last 1KB
		  Dim startPos As Integer = fileSize - searchSize

		  // Read last portion of file
		  reader.Reset(startPos)
		  Dim buffer As MemoryBlock = reader.GetBuffer(True)
		  Dim bufLen As Integer = reader.GetBufferLength()

		  // Convert to string for searching
		  Dim content As String = ""
		  For i As Integer = 0 To bufLen - 1
		    content = content + Chr(buffer.UInt8Value(i))
		  Next

		  // Find "startxref" keyword
		  Dim pos As Integer = content.IndexOf("startxref")
		  If pos = -1 Then
		    Return -1
		  End If

		  // Read the offset value after "startxref"
		  Dim offsetStr As String = ""
		  Dim idx As Integer = pos + 9  // Length of "startxref"

		  // Skip whitespace
		  While idx < content.Length
		    Dim ch As String = content.Middle(idx, 1)
		    If ch <> " " And ch <> Chr(9) And ch <> Chr(10) And ch <> Chr(13) Then
		      Exit While
		    End If
		    idx = idx + 1
		  Wend

		  // Read digits
		  While idx < content.Length
		    Dim ch As String = content.Middle(idx, 1)
		    Dim code As Integer = ch.Asc
		    If code >= 48 And code <= 57 Then  // 0-9
		      offsetStr = offsetStr + ch
		    Else
		      Exit While
		    End If
		    idx = idx + 1
		  Wend

		  If offsetStr = "" Then
		    Return -1
		  End If

		  Return Val(offsetStr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseXrefTable(reader As VNSPDFStreamReader) As VNSPDFCrossReference
		  // Parse xref table at current position
		  // Format:
		  //   xref
		  //   0 6
		  //   0000000000 65535 f
		  //   0000000018 00000 n
		  //   ...
		  //   trailer
		  //   << /Size 6 /Root 1 0 R >>

		  Dim xref As New VNSPDFCrossReference
		  Dim tokenizer As New VNSPDFTokenizer(reader)

		  // Read "xref" keyword
		  Dim token As String = tokenizer.GetNextToken()

		  If token <> "xref" Then
		    Return Nil
		  End If


		  // Parse xref subsections
		  Dim subsectionCount As Integer = 0
		  Dim maxSubsections As Integer = 100  // Reduced safety limit
		  Dim totalEntriesRead As Integer = 0
		  Dim maxTotalEntries As Integer = 10000  // Prevent reading too many entries


		  While subsectionCount < maxSubsections And totalEntriesRead < maxTotalEntries
		    // Read start object number
		    Dim startToken As String = tokenizer.GetNextToken()

		    // Check for end conditions first
		    If startToken = "" Then
		      Exit While
		    End If

		    If startToken = "trailer" Then
		      tokenizer.PushBack(startToken)
		      Exit While
		    End If

		    // Validate that startToken is a number
		    If Not IsNumericVNS(startToken) Then
		      // Not a subsection header, assume we're done
		      tokenizer.PushBack(startToken)
		      Exit While
		    End If

		    Dim startNum As Integer = Val(startToken)

		    // Read count
		    Dim countToken As String = tokenizer.GetNextToken()

		    If countToken = "" Then
		      Exit While
		    End If

		    If Not IsNumericVNS(countToken) Then
		      // Invalid count, exit
		      Exit While
		    End If

		    Dim count As Integer = Val(countToken)

		    // Validate count is reasonable
		    If count <= 0 Or count > 10000 Then
		      // Invalid count, exit
		      Exit While
		    End If

		    // Parse entries in this subsection
		    Dim entriesReadThisSubsection As Integer = 0
		    For i As Integer = 0 To count - 1
		      Dim entry As VNSPDFXrefEntry = ParseXrefEntry(tokenizer)
		      If entry <> Nil Then
		        xref.SetEntry(startNum + i, entry)
		        entriesReadThisSubsection = entriesReadThisSubsection + 1
		      Else
		        // Failed to read entry, stop
		        Exit For i
		      End If
		    Next

		    totalEntriesRead = totalEntriesRead + entriesReadThisSubsection
		    subsectionCount = subsectionCount + 1

		    // Safety check: if we didn't read any entries, something is wrong
		    If entriesReadThisSubsection = 0 Then
		      Exit While
		    End If
		  Wend


		  // Parse trailer dictionary
		  Dim trailerToken As String = tokenizer.GetNextToken()

		  If trailerToken = "trailer" Then
		    // Next token should be "<<"
		    Dim dictStart As String = tokenizer.GetNextToken()

		    If dictStart = "<<" Then
		      Dim trailerDict As VNSPDFDictionary = VNSPDFDictionary.Parse(tokenizer)

		      If trailerDict <> Nil Then
		        xref.trailer = trailerDict
		      Else
		      End If
		    Else
		    End If
		  Else
		  End If

		  Return xref
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsNumericVNS(s As String) As Boolean
		  // Check if string contains only digits (and optionally leading minus/plus or decimal point)
		  // Safe custom implementation to avoid any API changes
		  If s = "" Then Return False

		  Dim hasDigit As Boolean = False
		  Dim hasDecimal As Boolean = False

		  For i As Integer = 0 To s.Length - 1
		    Dim ch As String = s.Middle(i, 1)
		    Dim code As Integer = ch.Asc

		    If code >= 48 And code <= 57 Then  // 0-9
		      hasDigit = True
		    ElseIf ch = "." Then
		      If hasDecimal Then Return False  // Multiple decimals
		      hasDecimal = True
		    ElseIf ch = "-" Or ch = "+" Then
		      If i <> 0 Then Return False  // Sign must be first character
		    Else
		      Return False  // Invalid character
		    End If
		  Next

		  Return hasDigit  // Must have at least one digit
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseXrefEntry(tokenizer As VNSPDFTokenizer) As VNSPDFXrefEntry
		  // Parse single xref entry
		  // Format: "0000000018 00000 n" or "0000000000 65535 f"

		  // Read offset (10 digits)
		  Dim offsetToken As String = tokenizer.GetNextToken()
		  If offsetToken = "" Then
		    Return Nil
		  End If

		  // Read generation (5 digits)
		  Dim genToken As String = tokenizer.GetNextToken()
		  If genToken = "" Then
		    Return Nil
		  End If

		  // Read type (n or f)
		  Dim typeToken As String = tokenizer.GetNextToken()
		  If typeToken = "" Then
		    Return Nil
		  End If

		  Dim entry As New VNSPDFXrefEntry
		  entry.offset = Val(offsetToken)
		  entry.generation = Val(genToken)
		  entry.inUse = (typeToken = "n")  // "n" = in use, "f" = free

		  Return entry
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
