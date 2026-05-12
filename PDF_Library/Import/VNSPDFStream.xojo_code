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
		    End If
		  End If
		  
		  // Decode using VNSPDFStreamDecoder
		  Dim decoder As New VNSPDFStreamDecoder
		  mDecodedData = decoder.DecodeStream(data, filterName, decodeParms)
		  
		  If decoder.GetError() <> "" Then
		    // Decompression failed - store error for upstream reporting
		    mLastError = decoder.GetError()
		    mDecodedData = ""
		  End If
		  
		  Return mDecodedData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Parse(tokenizer As VNSPDFTokenizer, dict As VNSPDFDictionary) As VNSPDFStream
		  // Parse stream from: << /Length 123 >> stream...binary data...endstream
		  // Dictionary is already parsed, now read the stream data
		  
		  Dim reader As VNSPDFStreamReader = tokenizer.GetReader()
		  
		  // Skip to "stream" keyword (should be next token)
		  Dim streamToken As String = tokenizer.GetNextToken()
		  If streamToken <> "stream" Then
		    Dim obj As New VNSPDFStream
		    obj.dictionary = dict
		    obj.data = New MemoryBlock(0)
		    Return obj
		  End If
		  
		  // Skip CR and/or LF after "stream"
		  Dim b As Integer = reader.ReadByte()
		  If b = 13 Then  // CR
		    Dim nextByte As Integer = reader.ReadByte()
		    If nextByte <> 10 Then  // LF
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
		  
		  // Get stream length from dictionary
		  Dim dictValue As Dictionary = dict.value
		  Dim length As Integer = 0
		  If dictValue.HasKey("Length") Then
		    Dim lengthObj As VNSPDFType = dictValue.Value("Length")
		    If lengthObj IsA VNSPDFNumeric Then
		      length = VNSPDFNumeric(lengthObj).value
		    End If
		  End If
		  
		  // Read stream data
		  Dim streamData As New MemoryBlock(length)
		  For i As Integer = 0 To length - 1
		    Dim dataByte As Integer = reader.ReadByte()
		    If dataByte = -1 Then Exit For i
		    streamData.UInt8Value(i) = dataByte
		  Next
		  
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
		data As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		dictionary As VNSPDFDictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDecodedData As String = ""
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastError As String = ""
	#tag EndProperty

	#tag Method, Flags = &h0
		Function GetLastError() As String
		  Return mLastError
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
