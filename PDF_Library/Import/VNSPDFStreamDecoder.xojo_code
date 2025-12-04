#tag Class
Protected Class VNSPDFStreamDecoder
	#tag Method, Flags = &h0
		Function DecodeStream(streamData As MemoryBlock, filterName As String, decodeParms As Dictionary = Nil) As String
		  // Decode a PDF stream based on the filter name
		  // filterName: Filter type (FlateDecode, ASCII85Decode, ASCIIHexDecode)
		  // decodeParms: Optional decode parameters dictionary (for predictor filters, etc.)
		  // Returns: Decoded string, or empty string on error

		  mError = ""

		  If streamData = Nil Or streamData.Size = 0 Then
		    mError = "Empty stream data"
		    Return ""
		  End If

		  Dim result As String
		  Select Case filterName
		  Case "FlateDecode", "/FlateDecode"
		    // Pass MemoryBlock directly to avoid binary data corruption
		    result = DecodeFlateDecode(streamData)

		  Case "LZWDecode", "/LZWDecode"
		    // For text-based encoding, convert to string
		    Dim compressedData As String = streamData.StringValue(0, streamData.Size)
		    result = DecodeLZW(compressedData)

		  Case "ASCII85Decode", "/ASCII85Decode"
		    // For text-based encoding, convert to string
		    Dim compressedData As String = streamData.StringValue(0, streamData.Size)
		    result = DecodeASCII85(compressedData)

		  Case "ASCIIHexDecode", "/ASCIIHexDecode"
		    // For text-based encoding, convert to string
		    Dim compressedData As String = streamData.StringValue(0, streamData.Size)
		    result = DecodeASCIIHex(compressedData)

		  Else
		    mError = "Unsupported filter: " + filterName
		    Return ""
		  End Select

		  // Apply predictor filter if specified in DecodeParms
		  If result <> "" And decodeParms <> Nil Then
		    result = ApplyPredictor(result, decodeParms)
		  End If

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeFlateDecode(compressedData As MemoryBlock) As String
		  // Decode FlateDecode (zlib/deflate) compressed stream
		  // This is the most common compression filter in PDF files
		  // PDF can use either zlib format (with header) or raw DEFLATE
		  // Check first two bytes to determine format

		  If compressedData = Nil Or compressedData.Size < 2 Then
		    mError = "FlateDecode: Data too short"
		    Return ""
		  End If

		  // Check for zlib header (0x78 followed by 0x01, 0x5E, 0x9C, or 0xDA)
		  // Read directly from MemoryBlock to avoid string encoding issues
		  Dim byte1 As Integer = compressedData.UInt8Value(0)
		  Dim byte2 As Integer = compressedData.UInt8Value(1)

		  Dim hasZlibHeader As Boolean = False
		  If byte1 = &h78 Then  // First byte indicates zlib
		    If byte2 = &h01 Or byte2 = &h5E Or byte2 = &h9C Or byte2 = &hDA Then
		      hasZlibHeader = True
		    End If
		  End If

		  Dim result As String

		  If hasZlibHeader Then
		    // Standard zlib format - use VNSZlibModule.Uncompress
		    // Convert MemoryBlock to String for system zlib
		    Dim zlibData As String = compressedData.StringValue(0, compressedData.Size)
		    result = VNSZlibModule.Uncompress(zlibData)
		    If VNSZlibModule.LastErrorCode <> VNSZlibModule.kZ_OK Then
		      mError = "FlateDecode error (zlib): " + Str(VNSZlibModule.LastErrorCode)
		      Return ""
		    End If
		  Else
		    // Raw DEFLATE format (no zlib wrapper) - common in PDF files
		    #If VNSPDFModule.hasPremiumZlibModule Then
		      // Use Premium pure Xojo raw DEFLATE decompressor
		      Dim inflater As New VNSZlibPremiumInflate
		      result = inflater.DecompressRawDeflate(compressedData)

		      If result = "" Then
		        mError = "FlateDecode error: Raw DEFLATE decompression failed (Premium module)"
		        Return ""
		      End If
		    #Else
		      // Premium module not available
		      mError = "FlateDecode error: PDF uses raw DEFLATE format. This requires the Premium Zlib module. Set VNSPDFModule.hasPremiumZlibModule = True to enable."
		      Return ""
		    #EndIf
		  End If

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeLZW(compressedData As String) As String
		  // Decode LZWDecode compressed stream
		  // Uses pure Xojo LZW implementation for cross-platform compatibility
		  //
		  // NOTE: Trying EarlyChange=0 first as some PDF generators use this non-standard setting
		  // PDF spec default is EarlyChange=1, but we should read DecodeParms to be sure
		  // TODO: Read /DecodeParms dictionary to get correct EarlyChange value

		  // Try EarlyChange=0 first (non-standard, but some PDFs use it)
		  Dim decoder As New VNSPDFLZWDecoder
		  Dim result As String = decoder.Decode(compressedData, 0)  // EarlyChange=0

		  If decoder.GetError() <> "" Then
		    // EarlyChange=0 failed, try EarlyChange=1 (PDF default)
		    Dim decoder2 As New VNSPDFLZWDecoder
		    result = decoder2.Decode(compressedData, 1)  // EarlyChange=1

		    If decoder2.GetError() <> "" Then
		      mError = "LZWDecode error: " + decoder2.GetError()
		      Return ""
		    End If
		  End If

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeASCII85(encodedData As String) As String
		  // Decode ASCII85 (Base85) encoded stream
		  // Format: Encodes 4 bytes as 5 ASCII characters (z is shorthand for 0000)
		  // Delimited by <~ at start and ~> at end

		  Dim cleanData As String = encodedData.Trim

		  // Remove <~ prefix and ~> suffix if present
		  If cleanData.Left(2) = "<~" Then
		    cleanData = cleanData.Middle(2, cleanData.Length - 2)
		  End If
		  If cleanData.Right(2) = "~>" Then
		    cleanData = cleanData.Left(cleanData.Length - 2)
		  End If

		  // Remove whitespace (newlines, spaces, tabs)
		  cleanData = cleanData.ReplaceAll(Chr(13), "")
		  cleanData = cleanData.ReplaceAll(Chr(10), "")
		  cleanData = cleanData.ReplaceAll(Chr(9), "")
		  cleanData = cleanData.ReplaceAll(" ", "")

		  Dim result As MemoryBlock = New MemoryBlock(0)
		  Dim i As Integer = 0
		  Dim dataLen As Integer = cleanData.Length

		  While i < dataLen
		    Dim c As String = cleanData.Middle(i, 1)

		    If c = "z" Then
		      // Special case: z represents four 0x00 bytes
		      result.Size = result.Size + 4
		      result.UInt8Value(result.Size - 4) = 0
		      result.UInt8Value(result.Size - 3) = 0
		      result.UInt8Value(result.Size - 2) = 0
		      result.UInt8Value(result.Size - 1) = 0
		      i = i + 1
		    Else
		      // Normal case: decode 5 ASCII85 chars to 4 bytes
		      Dim value As UInt32 = 0
		      Dim count As Integer = 0

		      For j As Integer = 0 To 4
		        If i + j >= dataLen Then
		          Exit For j
		        End If

		        Dim ch As String = cleanData.Middle(i + j, 1)
		        Dim chVal As Integer = Asc(ch)

		        If chVal >= 33 And chVal <= 117 Then  // '!' to 'u'
		          value = value * 85 + (chVal - 33)
		          count = count + 1
		        End If
		      Next

		      If count > 0 Then
		        // Pad value if we have less than 5 characters
		        For j As Integer = count To 4
		          value = value * 85 + 84  // Pad with 'u' (84 = 117 - 33)
		        Next

		        // Extract 4 bytes from UInt32 (big-endian)
		        Dim numBytes As Integer = count - 1
		        If numBytes > 0 Then
		          Dim oldSize As Integer = result.Size
		          result.Size = oldSize + numBytes
		          result.UInt8Value(oldSize) = Bitwise.ShiftRight(value, 24) And &hFF
		          If numBytes > 1 Then
		            result.UInt8Value(oldSize + 1) = Bitwise.ShiftRight(value, 16) And &hFF
		          End If
		          If numBytes > 2 Then
		            result.UInt8Value(oldSize + 2) = Bitwise.ShiftRight(value, 8) And &hFF
		          End If
		          If numBytes > 3 Then
		            result.UInt8Value(oldSize + 3) = value And &hFF
		          End If
		        End If
		      End If

		      i = i + count
		    End If
		  Wend

		  If result.Size = 0 Then
		    mError = "ASCII85Decode: No data decoded"
		    Return ""
		  End If

		  Return result.StringValue(0, result.Size)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeASCIIHex(encodedData As String) As String
		  // Decode ASCIIHex encoded stream
		  // Format: Each byte encoded as 2 hex digits, delimited by >

		  Dim cleanData As String = encodedData.Trim

		  // Remove > terminator if present
		  If cleanData.Right(1) = ">" Then
		    cleanData = cleanData.Left(cleanData.Length - 1)
		  End If

		  // Remove whitespace
		  cleanData = cleanData.ReplaceAll(Chr(13), "")
		  cleanData = cleanData.ReplaceAll(Chr(10), "")
		  cleanData = cleanData.ReplaceAll(Chr(9), "")
		  cleanData = cleanData.ReplaceAll(" ", "")

		  Dim result As MemoryBlock = New MemoryBlock(cleanData.Length / 2)
		  Dim resultIndex As Integer = 0

		  Dim i As Integer = 0
		  While i < cleanData.Length
		    // Get two hex digits
		    Dim hexPair As String
		    If i + 1 < cleanData.Length Then
		      hexPair = cleanData.Middle(i, 2)
		    Else
		      // Odd number of hex digits - pad with 0
		      hexPair = cleanData.Middle(i, 1) + "0"
		    End If

		    // Convert hex to byte
		    Dim byteVal As Integer = 0
		    Try
		      byteVal = Val("&h" + hexPair)
		      result.UInt8Value(resultIndex) = byteVal
		      resultIndex = resultIndex + 1
		    Catch
		      mError = "ASCIIHexDecode: Invalid hex data at position " + Str(i)
		      Return ""
		    End Try

		    i = i + 2
		  Wend

		  If resultIndex = 0 Then
		    mError = "ASCIIHexDecode: No data decoded"
		    Return ""
		  End If

		  // Trim result to actual size
		  Dim finalResult As New MemoryBlock(resultIndex)
		  For j As Integer = 0 To resultIndex - 1
		    finalResult.UInt8Value(j) = result.UInt8Value(j)
		  Next

		  Return finalResult.StringValue(0, resultIndex)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetError() As String
		  // Get last error message
		  Return mError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ApplyPredictor(data As String, decodeParms As Dictionary) As String
		  // Apply predictor filter to decoded data based on DecodeParms
		  // PDF spec: Predictors 10-15 are PNG predictors
		  // Returns: Data with predictor applied, or original data if no predictor

		  // Get predictor value (default = 1 = no prediction)
		  Dim predictor As Integer = 1
		  If decodeParms.HasKey("Predictor") Or decodeParms.HasKey("/Predictor") Then
		    Dim key As String = If(decodeParms.HasKey("Predictor"), "Predictor", "/Predictor")
		    Dim predObj As Variant = decodeParms.Value(key)
		    If predObj IsA VNSPDFNumeric Then
		      predictor = VNSPDFNumeric(predObj).value
		    ElseIf predObj.Type = Variant.TypeInt32 Or predObj.Type = Variant.TypeInt64 Then
		      predictor = predObj
		    End If
		  End If

		  // No prediction needed
		  If predictor < 10 Then
		    Return data
		  End If

		  // Get other decode parameters
		  Dim columns As Integer = 1
		  Dim colors As Integer = 1
		  Dim bitsPerComponent As Integer = 8

		  If decodeParms.HasKey("Columns") Or decodeParms.HasKey("/Columns") Then
		    Dim key As String = If(decodeParms.HasKey("Columns"), "Columns", "/Columns")
		    Dim colObj As Variant = decodeParms.Value(key)
		    If colObj IsA VNSPDFNumeric Then
		      columns = VNSPDFNumeric(colObj).value
		    ElseIf colObj.Type = Variant.TypeInt32 Or colObj.Type = Variant.TypeInt64 Then
		      columns = colObj
		    End If
		  End If

		  If decodeParms.HasKey("Colors") Or decodeParms.HasKey("/Colors") Then
		    Dim key As String = If(decodeParms.HasKey("Colors"), "Colors", "/Colors")
		    Dim colorObj As Variant = decodeParms.Value(key)
		    If colorObj IsA VNSPDFNumeric Then
		      colors = VNSPDFNumeric(colorObj).value
		    ElseIf colorObj.Type = Variant.TypeInt32 Or colorObj.Type = Variant.TypeInt64 Then
		      colors = colorObj
		    End If
		  End If

		  If decodeParms.HasKey("BitsPerComponent") Or decodeParms.HasKey("/BitsPerComponent") Then
		    Dim key As String = If(decodeParms.HasKey("BitsPerComponent"), "BitsPerComponent", "/BitsPerComponent")
		    Dim bpcObj As Variant = decodeParms.Value(key)
		    If bpcObj IsA VNSPDFNumeric Then
		      bitsPerComponent = VNSPDFNumeric(bpcObj).value
		    ElseIf bpcObj.Type = Variant.TypeInt32 Or bpcObj.Type = Variant.TypeInt64 Then
		      bitsPerComponent = bpcObj
		    End If
		  End If

		  // Apply PNG predictor (predictors 10-15)
		  If predictor >= 10 And predictor <= 15 Then
		    Return ApplyPNGPredictor(data, columns, colors, bitsPerComponent)
		  End If

		  // TIFF Predictor 2 (not commonly used in PDFs, but included for completeness)
		  If predictor = 2 Then
		    Return ApplyTIFFPredictor(data, columns, colors, bitsPerComponent)
		  End If

		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ApplyPNGPredictor(data As String, columns As Integer, colors As Integer, bitsPerComponent As Integer) As String
		  // Apply PNG predictor filter to decoded data
		  // PNG predictors work on rows of data
		  // Each row starts with a predictor type byte (0-4), followed by the pixel data
		  //
		  // Predictor types:
		  //   0 = None (no prediction)
		  //   1 = Sub (use byte to the left)
		  //   2 = Up (use byte above)
		  //   3 = Average (use average of left and above)
		  //   4 = Paeth (use Paeth predictor)

		  // Calculate bytes per pixel and bytes per row
		  Dim bytesPerPixel As Integer = (colors * bitsPerComponent + 7) \ 8
		  Dim rowBytes As Integer = (columns * colors * bitsPerComponent + 7) \ 8
		  Dim rowStride As Integer = rowBytes + 1  // +1 for predictor type byte

		  // Validate data size
		  Dim expectedSize As Integer = (data.Length \ rowStride) * rowStride
		  If data.Length < rowStride Then
		    mError = "PNG Predictor: Data too small for specified parameters"
		    Return data
		  End If

		  // Prepare output buffer
		  Dim output As New MemoryBlock(data.Length - (data.Length \ rowStride))
		  Dim outputPos As Integer = 0

		  // Process each row
		  Dim inputPos As Integer = 0
		  Dim prevRow() As Integer
		  ReDim prevRow(rowBytes - 1)

		  While inputPos < data.Length
		    // Check if we have enough data for a complete row
		    If inputPos + rowStride > data.Length Then
		      Exit While
		    End If

		    // Get predictor type for this row
		    Dim predictorType As Integer = Asc(data.Middle(inputPos, 1))
		    inputPos = inputPos + 1

		    // Decode the row based on predictor type
		    Dim currRow() As Integer
		    ReDim currRow(rowBytes - 1)

		    For i As Integer = 0 To rowBytes - 1
		      Dim rawByte As Integer = Asc(data.Middle(inputPos + i, 1))
		      Dim leftByte As Integer = If(i >= bytesPerPixel, currRow(i - bytesPerPixel), 0)
		      Dim upByte As Integer = prevRow(i)
		      Dim upLeftByte As Integer = If(i >= bytesPerPixel, prevRow(i - bytesPerPixel), 0)

		      Dim decoded As Integer
		      Select Case predictorType
		      Case 0  // None
		        decoded = rawByte

		      Case 1  // Sub
		        decoded = (rawByte + leftByte) And &hFF

		      Case 2  // Up
		        decoded = (rawByte + upByte) And &hFF

		      Case 3  // Average
		        decoded = (rawByte + ((leftByte + upByte) \ 2)) And &hFF

		      Case 4  // Paeth
		        decoded = (rawByte + PaethPredictor(leftByte, upByte, upLeftByte)) And &hFF

		      Else
		        decoded = rawByte
		      End Select

		      currRow(i) = decoded
		      output.UInt8Value(outputPos) = decoded
		      outputPos = outputPos + 1
		    Next

		    // Move to next row
		    inputPos = inputPos + rowBytes
		    prevRow = currRow
		  Wend

		  // Return decoded data as string
		  Return output.StringValue(0, outputPos)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PaethPredictor(a As Integer, b As Integer, c As Integer) As Integer
		  // Paeth predictor algorithm (from PNG spec)
		  // a = left, b = above, c = upper left
		  // Returns the value (a, b, or c) that is closest to p = a + b - c

		  Dim p As Integer = a + b - c
		  Dim pa As Integer = Abs(p - a)
		  Dim pb As Integer = Abs(p - b)
		  Dim pc As Integer = Abs(p - c)

		  If pa <= pb And pa <= pc Then
		    Return a
		  ElseIf pb <= pc Then
		    Return b
		  Else
		    Return c
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ApplyTIFFPredictor(data As String, columns As Integer, colors As Integer, bitsPerComponent As Integer) As String
		  // Apply TIFF Predictor 2 to decoded data
		  // TIFF Predictor 2: Each byte is the difference from the previous byte
		  // This is rarely used in PDFs but included for completeness

		  Dim bytesPerPixel As Integer = (colors * bitsPerComponent + 7) \ 8
		  Dim rowBytes As Integer = (columns * colors * bitsPerComponent + 7) \ 8

		  Dim output As New MemoryBlock(data.Length)
		  Dim pos As Integer = 0

		  While pos < data.Length
		    Dim rowEnd As Integer = Min(pos + rowBytes, data.Length)

		    For i As Integer = pos To rowEnd - 1
		      Dim rawByte As Integer = Asc(data.Middle(i, 1))
		      Dim leftByte As Integer = If(i - pos >= bytesPerPixel, output.UInt8Value(i - bytesPerPixel), 0)
		      output.UInt8Value(i) = (rawByte + leftByte) And &hFF
		    Next

		    pos = rowEnd
		  Wend

		  Return output.StringValue(0, data.Length)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mError As String = ""
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
