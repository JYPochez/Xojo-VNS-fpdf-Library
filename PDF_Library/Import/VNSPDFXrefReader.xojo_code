#tag Class
Protected Class VNSPDFXrefReader
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

	#tag Method, Flags = &h0
		Function FindStartXrefOffsetPublic(reader As VNSPDFStreamReader) As Integer
		  // Public wrapper for FindStartXrefOffset (for testing)
		  Return FindStartXrefOffset(reader)
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

	#tag Method, Flags = &h0
		Function Parse(reader As VNSPDFStreamReader) As VNSPDFCrossReference
		  // Parse the cross-reference table from a PDF file
		  // Supports both traditional xref tables and xref streams (PDF 1.5+)
		  // Follows /Prev chains to merge incremental updates
		  // Returns VNSPDFCrossReference with all entries and trailer
		  
		  // Step 1: Find startxref offset (points to the LAST xref table/stream)
		  Dim xrefOffset As Integer = FindStartXrefOffset(reader)
		  If xrefOffset = -1 Then
		    Return Nil
		  End If
		  
		  // Step 2: Parse xref at offset (tries traditional table first, then xref stream)
		  Dim xref As VNSPDFCrossReference = ParseXrefAtOffset(reader, xrefOffset)
		  If xref = Nil Then
		    Return Nil
		  End If
		  
		  // Step 3: Follow /Prev chain to read earlier xref tables/streams
		  // The most recent xref (parsed first) takes priority over older ones
		  Dim maxPrevChain As Integer = 20
		  Dim prevCount As Integer = 0
		  
		  If xref.trailer <> Nil Then
		    Dim trailerDict As Dictionary = xref.trailer.value
		    Dim prevKey As String = "Prev"
		    If Not trailerDict.HasKey(prevKey) Then prevKey = "/Prev"
		    
		    While trailerDict.HasKey(prevKey) And prevCount < maxPrevChain
		      prevCount = prevCount + 1
		      Dim prevObj As VNSPDFType
		      Dim prevRaw As Object = trailerDict.Value(prevKey)
		      If prevRaw IsA VNSPDFType Then
		        prevObj = VNSPDFType(prevRaw)
		      Else
		        Exit While
		      End If
		      
		      If Not (prevObj IsA VNSPDFNumeric) Then Exit While
		      
		      Dim prevOffset As Integer = CType(VNSPDFNumeric(prevObj).value, Integer)
		      If prevOffset <= 0 Then Exit While
		      
		      // Parse the previous xref (could be table or stream)
		      Dim prevXref As VNSPDFCrossReference = ParseXrefAtOffset(reader, prevOffset)
		      If prevXref = Nil Then Exit While
		      
		      // Merge entries: only add entries NOT already in the main xref
		      // (newer entries take priority over older ones)
		      If prevXref.trailer <> Nil Then
		        Dim prevTrailerDict As Dictionary = prevXref.trailer.value
		        
		        // Get Size from previous trailer to know which objects to check
		        Dim sizeKey As String = "Size"
		        If Not prevTrailerDict.HasKey(sizeKey) Then sizeKey = "/Size"
		        Dim prevSize As Integer = 0
		        If prevTrailerDict.HasKey(sizeKey) Then
		          Dim sizeObj As VNSPDFType
		          Dim sizeRaw As Object = prevTrailerDict.Value(sizeKey)
		          If sizeRaw IsA VNSPDFType Then
		            sizeObj = VNSPDFType(sizeRaw)
		            If sizeObj IsA VNSPDFNumeric Then
		              prevSize = CType(VNSPDFNumeric(sizeObj).value, Integer)
		            End If
		          End If
		        End If
		        
		        // Merge entries from previous xref that are not in the current one
		        For objNum As Integer = 0 To prevSize - 1
		          If xref.GetEntry(objNum) = Nil Then
		            Dim prevEntry As VNSPDFXrefEntry = prevXref.GetEntry(objNum)
		            If prevEntry <> Nil Then
		              xref.SetEntry(objNum, prevEntry)
		            End If
		          End If
		        Next
		        
		        // Check for another /Prev in this older trailer
		        trailerDict = prevTrailerDict
		      Else
		        Exit While
		      End If
		    Wend
		  End If
		  
		  Return xref
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseXrefAtOffset(reader As VNSPDFStreamReader, offset As Integer) As VNSPDFCrossReference
		  // Try to parse xref at the given offset
		  // First tries traditional xref table, then xref stream (PDF 1.5+)
		  // Returns VNSPDFCrossReference or Nil on failure
		  
		  // Try traditional xref table first
		  reader.Reset(offset)
		  Dim xref As VNSPDFCrossReference = ParseXrefTable(reader)
		  If xref <> Nil Then
		    Return xref
		  End If
		  
		  // Traditional table failed - try xref stream
		  reader.Reset(offset)
		  xref = ParseXrefStream(reader)
		  Return xref
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

	#tag Method, Flags = &h21
		Private Function ParseXrefStream(reader As VNSPDFStreamReader) As VNSPDFCrossReference
		  // Parse cross-reference stream (PDF 1.5+)
		  // Format: N 0 obj << /Type /XRef /Size S /W [w1 w2 w3] /Filter ... >> stream...endstream endobj
		  // The stream dictionary serves as the trailer (contains /Root, /Info, /Size, etc.)
		  // The stream data contains the xref entries in binary format
		  
		  Dim tokenizer As New VNSPDFTokenizer(reader)
		  
		  // Read object header: objNum gen "obj"
		  Dim objNumToken As String = tokenizer.GetNextToken()
		  If Not IsNumericVNS(objNumToken) Then Return Nil
		  
		  Dim genToken As String = tokenizer.GetNextToken()
		  If Not IsNumericVNS(genToken) Then Return Nil
		  
		  Dim objToken As String = tokenizer.GetNextToken()
		  If objToken <> "obj" Then Return Nil
		  
		  // Read dictionary start "<<"
		  Dim dictStart As String = tokenizer.GetNextToken()
		  If dictStart <> "<<" Then Return Nil
		  
		  // Parse the stream dictionary
		  Dim streamDict As VNSPDFDictionary = VNSPDFDictionary.Parse(tokenizer)
		  If streamDict = Nil Then Return Nil
		  
		  Dim dictValue As Dictionary = streamDict.value
		  
		  // Verify this is an xref stream (/Type /XRef)
		  Dim typeKey As String = "Type"
		  If Not dictValue.HasKey(typeKey) Then typeKey = "/Type"
		  If dictValue.HasKey(typeKey) Then
		    Dim typeObj As VNSPDFType
		    Dim typeRaw As Object = dictValue.Value(typeKey)
		    If typeRaw IsA VNSPDFType Then
		      typeObj = VNSPDFType(typeRaw)
		      If typeObj IsA VNSPDFName Then
		        If VNSPDFName(typeObj).value <> "XRef" Then Return Nil
		      End If
		    End If
		  End If
		  
		  // Extract /Size (total number of objects)
		  Dim sizeKey As String = "Size"
		  If Not dictValue.HasKey(sizeKey) Then sizeKey = "/Size"
		  Dim totalSize As Integer = 0
		  If dictValue.HasKey(sizeKey) Then
		    Dim sizeRaw2 As Object = dictValue.Value(sizeKey)
		    If sizeRaw2 IsA VNSPDFNumeric Then
		      totalSize = CType(VNSPDFNumeric(sizeRaw2).value, Integer)
		    End If
		  End If
		  If totalSize <= 0 Then Return Nil
		  
		  // Extract /W array (field widths: [type_width offset_width gen_width])
		  Dim wKey As String = "W"
		  If Not dictValue.HasKey(wKey) Then wKey = "/W"
		  If Not dictValue.HasKey(wKey) Then Return Nil
		  
		  Dim wArray() As VNSPDFType
		  Dim wObj As Object = dictValue.Value(wKey)
		  If wObj IsA VNSPDFArray Then
		    wArray = VNSPDFArray(wObj).value
		  End If
		  If wArray.LastIndex < 2 Then Return Nil
		  
		  Dim w1 As Integer = 0
		  Dim w2 As Integer = 0
		  Dim w3 As Integer = 0
		  If wArray(0) IsA VNSPDFNumeric Then w1 = CType(VNSPDFNumeric(wArray(0)).value, Integer)
		  If wArray(1) IsA VNSPDFNumeric Then w2 = CType(VNSPDFNumeric(wArray(1)).value, Integer)
		  If wArray(2) IsA VNSPDFNumeric Then w3 = CType(VNSPDFNumeric(wArray(2)).value, Integer)
		  
		  Dim entryWidth As Integer = w1 + w2 + w3
		  If entryWidth <= 0 Then Return Nil
		  
		  // Extract /Index array (subsection ranges, default is [0 Size])
		  Dim indexKey As String = "Index"
		  If Not dictValue.HasKey(indexKey) Then indexKey = "/Index"
		  
		  Dim indexPairs() As Integer
		  Dim idxObj As Object
		  If dictValue.HasKey(indexKey) Then idxObj = dictValue.Value(indexKey)
		  If idxObj IsA VNSPDFArray Then
		    Dim idxArray() As VNSPDFType = VNSPDFArray(idxObj).value
		    For Each elem As VNSPDFType In idxArray
		      If elem IsA VNSPDFNumeric Then
		        indexPairs.Add(CType(VNSPDFNumeric(elem).value, Integer))
		      End If
		    Next
		  End If
		  // Default: [0 Size]
		  If indexPairs.LastIndex < 1 Then
		    indexPairs.Add(0)
		    indexPairs.Add(totalSize)
		  End If
		  
		  // Read and decode the stream data using existing VNSPDFStream infrastructure
		  Dim pdfStream As VNSPDFStream = VNSPDFStream.Parse(tokenizer, streamDict)
		  If pdfStream = Nil Then Return Nil
		  
		  Dim decodedData As String = pdfStream.GetDecodedData()
		  If decodedData = "" Then Return Nil
		  
		  // Parse xref entries from decoded data
		  Dim xref As New VNSPDFCrossReference
		  
		  // The stream dictionary doubles as the trailer
		  xref.trailer = streamDict
		  
		  Dim dataPos As Integer = 0
		  Dim pairIdx As Integer = 0
		  
		  While pairIdx < indexPairs.LastIndex
		    Dim startObj As Integer = indexPairs(pairIdx)
		    Dim count As Integer = indexPairs(pairIdx + 1)
		    pairIdx = pairIdx + 2
		    
		    For i As Integer = 0 To count - 1
		      If dataPos + entryWidth > decodedData.Length Then Exit For i
		      
		      // Read field 1: type (default 1 if w1=0)
		      Dim entryType As Integer = 1
		      If w1 > 0 Then
		        entryType = ReadBigEndianUInt(decodedData, dataPos, w1)
		        dataPos = dataPos + w1
		      End If
		      
		      // Read field 2: depends on type
		      Dim field2 As Integer = 0
		      If w2 > 0 Then
		        field2 = ReadBigEndianUInt(decodedData, dataPos, w2)
		        dataPos = dataPos + w2
		      End If
		      
		      // Read field 3: depends on type
		      Dim field3 As Integer = 0
		      If w3 > 0 Then
		        field3 = ReadBigEndianUInt(decodedData, dataPos, w3)
		        dataPos = dataPos + w3
		      End If
		      
		      Dim entry As New VNSPDFXrefEntry
		      
		      Select Case entryType
		      Case 0
		        // Free object: field2=next free obj, field3=generation
		        entry.offset = 0
		        entry.generation = field3
		        entry.inUse = False
		        
		      Case 1
		        // In-use object: field2=byte offset, field3=generation
		        entry.offset = field2
		        entry.generation = field3
		        entry.inUse = True
		        
		      Case 2
		        // Compressed object in object stream: field2=stream obj number, field3=index
		        entry.offset = 0
		        entry.generation = 0
		        entry.inUse = True
		        entry.compressedInStream = field2
		        entry.streamIndex = field3
		        
		      Else
		        // Unknown type, skip
		        entry.inUse = False
		      End Select
		      
		      xref.SetEntry(startObj + i, entry)
		    Next
		  Wend
		  
		  Return xref
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
		Private Function ReadBigEndianUInt(data As String, position As Integer, width As Integer) As Integer
		  // Read a big-endian unsigned integer of variable width (1-4 bytes) from string data
		  // PDF xref streams store multi-byte values in big-endian format
		  
		  Dim result As Integer = 0
		  For i As Integer = 0 To width - 1
		    If position + i >= data.Length Then Exit For i
		    Dim byteVal As Integer = Asc(data.Middle(position + i, 1))
		    result = Bitwise.ShiftLeft(result, 8) Or byteVal
		  Next
		  Return result
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
