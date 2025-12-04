#tag Class
Protected Class VNSPDFStream
Inherits VNSPDFType
	#tag Method, Flags = &h0
		Function GetDecodedData() As String
		  // Get stream data decoded based on Filter in dictionary
		  // Returns: Decoded string data, or raw data if no filter
		  // Caches decoded result to avoid re-decompression

		  // Return cached decoded data if available
		  If mDecodedData <> "" Then
		    Return mDecodedData
		  End If

		  // Check if stream has a Filter
		  Dim dictValue As Dictionary = dictionary.value
		  If Not dictValue.HasKey("Filter") Then
		    // No filter - return raw data as string
		    mDecodedData = data.StringValue(0, data.Size)
		    Return mDecodedData
		  End If

		  // Get filter name
		  Dim filterObj As VNSPDFType = dictValue.Value("Filter")
		  Dim filterName As String = ""
		  If filterObj IsA VNSPDFName Then
		    filterName = VNSPDFName(filterObj).value
		  End If

		  If filterName = "" Then
		    // No valid filter name - return raw data
		    mDecodedData = data.StringValue(0, data.Size)
		    Return mDecodedData
		  End If

		  // Get decode parameters (DecodeParms) if present
		  Dim decodeParms As Dictionary = Nil
		  If dictValue.HasKey("DecodeParms") Or dictValue.HasKey("/DecodeParms") Then
		    Dim key As String = If(dictValue.HasKey("DecodeParms"), "DecodeParms", "/DecodeParms")
		    Dim decodeParmsObj As VNSPDFType = dictValue.Value(key)
		    If decodeParmsObj IsA VNSPDFDictionary Then
		      decodeParms = VNSPDFDictionary(decodeParmsObj).value
		      System.DebugLog("VNSPDFStream.GetDecodedData: Found DecodeParms")
		    End If
		  End If

		  // Decode using VNSPDFStreamDecoder
		  System.DebugLog("VNSPDFStream.GetDecodedData: Decoding with filter = " + filterName)
		  Dim decoder As New VNSPDFStreamDecoder
		  mDecodedData = decoder.DecodeStream(data, filterName, decodeParms)

		  If decoder.GetError() <> "" Then
		    // Decompression failed - return empty string
		    System.DebugLog("VNSPDFStream.GetDecodedData: ERROR - " + decoder.GetError())
		    mDecodedData = ""
		  Else
		    System.DebugLog("VNSPDFStream.GetDecodedData: Success, decoded length = " + Str(mDecodedData.Length))
		  End If

		  Return mDecodedData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Shared Function Parse(tokenizer As VNSPDFTokenizer, dict As VNSPDFDictionary) As VNSPDFStream
		  // Parse stream from: << /Length 123 >> stream...binary data...endstream
		  // Dictionary is already parsed, now read the stream data

		  System.DebugLog("*** VNSPDFStream.Parse: CALLED ***")

		  Dim reader As VNSPDFStreamReader = tokenizer.GetReader()

		  // Skip to "stream" keyword (should be next token)
		  Dim streamToken As String = tokenizer.GetNextToken()
		  If streamToken <> "stream" Then
		    // Error: expected "stream" keyword
		    Dim obj As New VNSPDFStream
		    obj.dictionary = dict
		    obj.data = New MemoryBlock(0)
		    Return obj
		  End If

		  // Skip CR and/or LF after "stream"
		  System.DebugLog("VNSPDFStream.Parse: Reader offset after 'stream' token = " + Str(reader.GetOffset()))
		  Dim b As Integer = reader.ReadByte()
		  System.DebugLog("VNSPDFStream.Parse: Byte after 'stream' = 0x" + Hex(b) + " (" + If(b = 10, "LF", If(b = 13, "CR", "other")) + ")")
		  If b = 13 Then  // CR
		    Dim nextByte As Integer = reader.ReadByte()
		    If nextByte <> 10 Then  // LF
		      // Only CR, push back next byte
		      Dim offset As Integer = reader.GetOffset()
		      reader.SetOffset(offset - 1)
		    End If
		  ElseIf b = 10 Then  // LF
		    // Just LF, continue
		  Else
		    // No CR/LF, push back
		    Dim offset As Integer = reader.GetOffset()
		    reader.SetOffset(offset - 1)
		  End If
		  System.DebugLog("VNSPDFStream.Parse: Reader offset before reading stream data = " + Str(reader.GetOffset()))

		  // Get stream length from dictionary
		  Dim dictValue As Dictionary = dict.value
		  Dim length As Integer = 0
		  If dictValue.HasKey("Length") Then
		    Dim lengthObj As VNSPDFType = dictValue.Value("Length")
		    System.DebugLog("VNSPDFStream.Parse: lengthObj type = " + Introspection.GetType(lengthObj).Name)
		    If lengthObj IsA VNSPDFNumeric Then
		      length = VNSPDFNumeric(lengthObj).value
		      System.DebugLog("VNSPDFStream.Parse: Stream length (direct) = " + Str(length))
		    Else
		      System.DebugLog("VNSPDFStream.Parse: Length is not VNSPDFNumeric - might be indirect reference")
		    End If
		  End If

		  // Read stream data
		  Dim streamData As New MemoryBlock(length)
		  For i As Integer = 0 To length - 1
		    Dim dataByte As Integer = reader.ReadByte()
		    If dataByte = -1 Then Exit For i
		    streamData.UInt8Value(i) = dataByte
		  Next

		  // Debug: Log first 4 bytes of stream data
		  If streamData.Size >= 4 Then
		    Dim debugBytes As String = ""
		    For i As Integer = 0 To 3
		      debugBytes = debugBytes + Hex(streamData.UInt8Value(i)) + " "
		    Next
		    System.DebugLog("VNSPDFStream.Parse: First 4 bytes of stream data = " + debugBytes)
		  End If

		  // Skip to "endstream" keyword
		  While True
		    Dim token As String = tokenizer.GetNextToken()
		    If token = "" Or token = "endstream" Then Exit While
		  Wend

		  Dim obj As New VNSPDFStream
		  obj.dictionary = dict
		  obj.data = streamData
		  Return obj
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		dictionary As VNSPDFDictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		data As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDecodedData As String = ""
	#tag EndProperty


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
