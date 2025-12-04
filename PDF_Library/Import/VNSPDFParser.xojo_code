#tag Class
Protected Class VNSPDFParser
	#tag Property, Flags = &h21
		Private mPDFReader As VNSPDFReader
	#tag EndProperty

	#tag Method, Flags = &h0
		Sub SetPDFReader(reader As VNSPDFReader)
		  // Set the PDF reader for resolving indirect references
		  mPDFReader = reader
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParseIndirectObject(reader As VNSPDFStreamReader, offset As Int64) As VNSPDFType
		  // Parse an indirect object at the specified offset
		  // Format: "5 0 obj ... endobj"

		  // Seek to object offset
		  reader.Reset(offset)

		  Dim tokenizer As New VNSPDFTokenizer(reader)

		  // Read object number
		  Dim objNumToken As String = tokenizer.GetNextToken()
		  If objNumToken = "" Then
		    Return Nil
		  End If

		  // Read generation number
		  Dim genToken As String = tokenizer.GetNextToken()
		  If genToken = "" Then
		    Return Nil
		  End If

		  // Read "obj" keyword
		  Dim objKeyword As String = tokenizer.GetNextToken()
		  If objKeyword <> "obj" Then
		    Return Nil
		  End If

		  // Parse the object value
		  Dim valueToken As String = tokenizer.GetNextToken()
		  If valueToken = "" Then
		    Return Nil
		  End If

		  Dim valueObj As VNSPDFType

		  // Parse value based on token type
		  If valueToken = "[" Then
		    // Array
		    valueObj = VNSPDFArray.Parse(tokenizer)
		  ElseIf valueToken = "<<" Then
		    // Dictionary (possibly with stream)
		    valueObj = VNSPDFDictionary.Parse(tokenizer)

		    // Check for stream keyword after dictionary
		    Dim nextToken As String = tokenizer.GetNextToken()
		    If nextToken = "stream" Then
		      // This is a stream object
		      Dim streamObj As New VNSPDFStream
		      streamObj.dictionary = VNSPDFDictionary(valueObj)

		      // Read stream data
		      // Stream starts after "stream" keyword + newline
		      // and ends before "endstream" keyword

		      // IMPORTANT: Save reader position now, BEFORE resolving Length reference
		      // The Length might be an indirect reference which will move the reader position
		      Dim savedStreamPosition As Integer = reader.GetAbsolutePosition()

		      // Get Length from dictionary
		      Dim dict As Dictionary = streamObj.dictionary.value
		      Dim length As Integer = 0
		      If dict.HasKey("Length") Then
		        Dim lengthObj As VNSPDFType = dict.Value("Length")
		        If lengthObj IsA VNSPDFNumeric Then
		          Dim numVal As Double = VNSPDFNumeric(lengthObj).value
		          length = numVal
		        ElseIf lengthObj IsA VNSPDFIndirectObjectReference Then
		          // Length is an indirect reference - resolve it
		          Dim lengthRef As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(lengthObj)
		          If mPDFReader <> Nil Then
		            Dim resolvedLen As VNSPDFType = mPDFReader.GetObject(lengthRef.objectNumber)
		            If resolvedLen IsA VNSPDFNumeric Then
		              length = VNSPDFNumeric(resolvedLen).value
		            Else
		              System.DebugLog("VNSPDFParser: WARNING - Length ref " + Str(lengthRef.objectNumber) + " is not numeric!")
		              length = 0
		            End If
		          Else
		            System.DebugLog("VNSPDFParser: WARNING - Cannot resolve Length ref - no PDF reader set!")
		            length = 0
		          End If
		        End If
		      End If

		      // Restore reader position to right after "stream" keyword
		      // (Length resolution may have moved it)
		      reader.Reset(savedStreamPosition)

		      // Skip CR and/or LF after "stream" keyword
		      Dim b As Integer = reader.ReadByte()
		      If b = 13 Then  // CR
		        Dim nextByte As Integer = reader.ReadByte()
		        If nextByte <> 10 Then  // LF
		          // Only CR, push back next byte
		          Dim readerPos As Integer = reader.GetOffset()
		          reader.SetOffset(readerPos - 1)
		        End If
		      ElseIf b = 10 Then  // LF
		        // Just LF, continue
		      Else
		        // No CR/LF, push back
		        Dim readerPos As Integer = reader.GetOffset()
		        reader.SetOffset(readerPos - 1)
		      End If

		      // Read stream bytes
		      If length > 0 Then
		        Dim streamData As MemoryBlock = reader.ReadBytes(length)
		        streamObj.data = streamData
		      Else
		        // Initialize with empty MemoryBlock to avoid Nil reference
		        streamObj.data = New MemoryBlock(0)
		        System.DebugLog("VNSPDFParser: WARNING - Stream has length 0!")
		      End If

		      // Read "endstream" keyword
		      Dim endstreamToken As String = tokenizer.GetNextToken()
		      // Skip if not "endstream" - may need better error handling

		      valueObj = streamObj
		    Else
		      // Not a stream, push token back
		      tokenizer.PushBack(nextToken)
		    End If

		  ElseIf valueToken = "(" Then
		    // Literal string
		    Dim dummy As Integer = reader.ReadByte()  // Skip (
		    valueObj = VNSPDFString.Parse(reader)
		  ElseIf valueToken = "<" Then
		    // Hex string
		    Dim dummy As Integer = reader.ReadByte()  // Skip <
		    valueObj = VNSPDFHexString.Parse(reader)
		  ElseIf valueToken = "/" Then
		    // Name - read the name token
		    Dim nameToken As String = tokenizer.GetNextToken()
		    Dim nameObj As New VNSPDFName
		    nameObj.value = nameToken
		    valueObj = nameObj
		  ElseIf valueToken = "true" Or valueToken = "false" Then
		    // Boolean
		    valueObj = VNSPDFBoolean.Create(valueToken = "true")
		  ElseIf valueToken = "null" Then
		    // Null
		    valueObj = New VNSPDFNull
		  Else
		    // Number
		    valueObj = VNSPDFNumeric.Create(Val(valueToken))
		  End If

		  // Read "endobj" keyword
		  Dim endobjToken As String = tokenizer.GetNextToken()
		  // Skip validation for now

		  Return valueObj
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
