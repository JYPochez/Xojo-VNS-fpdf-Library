#tag Class
Protected Class VNSPDFImage
	#tag Method, Flags = &h0
		Sub Constructor(imageFilePath As String)
		  // Load image from file path
		  mFilePath = imageFilePath

		  Dim f As FolderItem = New FolderItem(imageFilePath, FolderItem.PathModes.Native)

		  If Not f.Exists Then
		    mError = "Image file not found: " + imageFilePath
		    Return
		  End If

		  // Read image data
		  Try
		    Dim stream As BinaryStream = BinaryStream.Open(f)
		    mImageData = stream.Read(stream.Length)
		    stream.Close()
		  Catch e As IOException
		    mError = "Error reading image file: " + e.Message
		    Return
		  End Try

		  // Detect image type from file signature
		  DetectImageType()

		  // Parse image based on type
		  If mImageType = "jpeg" Then
		    ParseJPEG()
		  ElseIf mImageType = "png" Then
		    ParsePNG()
		  Else
		    // DetectImageType() already set a detailed error message
		    If mError = "" Then
		      mError = "Unsupported image format"
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(imageData As MemoryBlock)
		  // Load image from MemoryBlock (e.g., from Picture.ToData())
		  // This constructor is used for programmatically generated images
		  mFilePath = "" // No file path for memory-based images

		  If imageData = Nil Or imageData.Size = 0 Then
		    mError = "Image data is empty"
		    Return
		  End If

		  // Convert MemoryBlock to String for internal storage
		  mImageData = imageData.StringValue(0, imageData.Size)

		  // Detect image type from data signature
		  DetectImageType()

		  // Parse image based on type
		  If mImageType = "jpeg" Then
		    ParseJPEG()
		  ElseIf mImageType = "png" Then
		    ParsePNG()
		  Else
		    // DetectImageType() already set a detailed error message
		    If mError = "" Then
		      mError = "Unsupported image format"
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DetectImageType()
		  // Check file signature to detect image type
		  If mImageData.Bytes < 4 Then
		    mError = "Image file too small"
		    Return
		  End If
		  
		  // Skip leading null bytes (0x00 only) that might be in the file
		  // API2: MiddleBytes() is 0-based - first byte is numbered 0
		  Dim offset As Integer = 0
		  While offset < mImageData.Bytes And mImageData.MiddleBytes(offset, 1).AscByte = 0
		    offset = offset + 1
		  Wend
		  
		  // Trim leading null bytes if needed
		  If offset > 0 And offset < mImageData.Bytes Then
		    mImageData = mImageData.MiddleBytes(offset)
		  End If
		  
		  If mImageData.Bytes < 8 Then
		    mError = "Image file too small after trimming"
		    Return
		  End If
		  
		  // Get first 8 bytes for signature detection (for error reporting)
		  Dim sig As String = ""
		  For i As Integer = 0 To Min(7, mImageData.Bytes - 1)
		    Dim b As Integer = mImageData.MiddleBytes(i, 1).AscByte
		    sig = sig + b.ToHex(2) + " "
		  Next
		  
		  // JPEG: FF D8 FF (bytes 0, 1, 2)
		  If mImageData.MiddleBytes(0, 1).AscByte = &hFF And _
		    mImageData.MiddleBytes(1, 1).AscByte = &hD8 And _
		    mImageData.MiddleBytes(2, 1).AscByte = &hFF Then
		    mImageType = "jpeg"
		    Return
		  End If
		  
		  // PNG: 89 50 4E 47 0D 0A 1A 0A (bytes 0-3)
		  If mImageData.Bytes >= 8 Then
		    If mImageData.MiddleBytes(0, 1).AscByte = &h89 And _
		      mImageData.MiddleBytes(1, 1).AscByte = &h50 And _
		      mImageData.MiddleBytes(2, 1).AscByte = &h4E And _
		      mImageData.MiddleBytes(3, 1).AscByte = &h47 Then
		      mImageType = "png"
		      Return
		    End If
		  End If
		  
		  mImageType = "unknown"
		  mError = "Unsupported image format (signature: " + sig.Trim + ")"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBitsPerComponent() As Integer
		  Return mBitsPerComponent
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetColorSpace() As String
		  Return mColorSpace
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetError() As String
		  Return mError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetHeight() As Integer
		  Return mHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetImageData() As String
		  Return mImageData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetImageType() As String
		  Return mImageType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetWidth() As Integer
		  Return mWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsValid() As Boolean
		  Return mError = "" And mWidth > 0 And mHeight > 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseJPEG()
		  // Parse JPEG header to extract dimensions and color info
		  // JPEG format: Markers are 0xFF followed by marker type
		  // SOI: 0xFFD8 (Start of Image)
		  // SOF0: 0xFFC0 (Start of Frame - Baseline DCT)
		  
		  Dim pos As Integer = 0 // 0-based indexing
		  Dim dataLen As Integer = mImageData.Bytes
		  
		  // Verify SOI marker (0xFFD8) at bytes 0 and 1
		  If dataLen < 2 Or mImageData.MiddleBytes(0, 1).AscByte <> &hFF Or mImageData.MiddleBytes(1, 1).AscByte <> &hD8 Then
		    mError = "Invalid JPEG: Missing SOI marker"
		    Return
		  End If
		  
		  pos = 2 // Skip SOI (bytes 0 and 1)
		  
		  // Scan for SOF0 marker (0xFFC0)
		  While pos < dataLen
		    // Find next marker (0xFF)
		    If mImageData.MiddleBytes(pos, 1).AscByte = &hFF Then
		      Dim marker As Integer = mImageData.MiddleBytes(pos + 1, 1).AscByte
		      
		      // Skip padding bytes (0xFF 0xFF)
		      If marker = &hFF Then
		        pos = pos + 1
		        Continue
		      End If
		      
		      // Skip markers without data (0x00)
		      If marker = &h00 Then
		        pos = pos + 2
		        Continue
		      End If
		      
		      // Check if this is SOF0 (0xC0), SOF1 (0xC1), or SOF2 (0xC2)
		      If marker >= &hC0 And marker <= &hC2 Then
		        // Found Start of Frame marker
		        pos = pos + 2 // Skip marker
		        
		        If pos + 7 > dataLen Then
		          mError = "Truncated JPEG: SOF segment too short"
		          Return
		        End If
		        
		        // Read segment length (big endian)
		        Dim segmentLength As Integer = mImageData.MiddleBytes(pos, 1).AscByte * 256 + mImageData.MiddleBytes(pos + 1, 1).AscByte
		        pos = pos + 2
		        
		        // Read bits per sample
		        mBitsPerComponent = mImageData.MiddleBytes(pos, 1).AscByte
		        pos = pos + 1
		        
		        // Read height (big endian)
		        mHeight = mImageData.MiddleBytes(pos, 1).AscByte * 256 + mImageData.MiddleBytes(pos + 1, 1).AscByte
		        pos = pos + 2
		        
		        // Read width (big endian)
		        mWidth = mImageData.MiddleBytes(pos, 1).AscByte * 256 + mImageData.MiddleBytes(pos + 1, 1).AscByte
		        pos = pos + 2
		        
		        // Read number of components
		        Dim numComponents As Integer = mImageData.MiddleBytes(pos, 1).AscByte
		        
		        // Determine color space
		        Select Case numComponents
		        Case 1
		          mColorSpace = "DeviceGray"
		        Case 3
		          mColorSpace = "DeviceRGB"
		        Case 4
		          mColorSpace = "DeviceCMYK"
		        Else
		          mError = "Unsupported JPEG color space: " + Str(numComponents) + " components"
		          Return
		        End Select
		        
		        // Success
		        Return
		      End If
		      
		      // For other markers, skip their data segment
		      pos = pos + 2 // Skip marker
		      
		      If pos + 1 >= dataLen Then
		        Exit
		      End If
		      
		      // Read segment length (big endian)
		      Dim segLen As Integer = mImageData.MiddleBytes(pos, 1).AscByte * 256 + mImageData.MiddleBytes(pos + 1, 1).AscByte
		      pos = pos + segLen // Skip segment data (length includes the 2 length bytes)
		    Else
		      pos = pos + 1
		    End If
		  Wend
		  
		  mError = "JPEG: SOF marker not found"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParsePNG()
		  // Parse PNG header to extract dimensions and color info
		  // PNG format: 8-byte signature followed by chunks
		  // Each chunk: 4-byte length + 4-byte type + data + 4-byte CRC
		  // IHDR chunk (must be first) contains image metadata
		  
		  Dim dataLen As Integer = mImageData.Bytes
		  
		  // Verify PNG signature (8 bytes: 89 50 4E 47 0D 0A 1A 0A)
		  If dataLen < 8 Then
		    mError = "Invalid PNG: File too small"
		    Return
		  End If
		  
		  If mImageData.MiddleBytes(0, 1).AscByte <> &h89 Or _
		    mImageData.MiddleBytes(1, 1).AscByte <> &h50 Or _
		    mImageData.MiddleBytes(2, 1).AscByte <> &h4E Or _
		    mImageData.MiddleBytes(3, 1).AscByte <> &h47 Then
		    mError = "Invalid PNG: Missing PNG signature"
		    Return
		  End If
		  
		  Dim pos As Integer = 8 // Skip signature (bytes 0-7)
		  
		  // Read IHDR chunk (must be first chunk)
		  If pos + 8 > dataLen Then
		    mError = "Invalid PNG: Missing IHDR chunk"
		    Return
		  End If
		  
		  // Read chunk length (4 bytes, big-endian)
		  Dim chunkLen As Integer = mImageData.MiddleBytes(pos, 1).AscByte * &h1000000 + _
		  mImageData.MiddleBytes(pos + 1, 1).AscByte * &h10000 + _
		  mImageData.MiddleBytes(pos + 2, 1).AscByte * &h100 + _
		  mImageData.MiddleBytes(pos + 3, 1).AscByte
		  pos = pos + 4
		  
		  // Read chunk type (4 bytes, ASCII)
		  Dim chunkType As String = mImageData.MiddleBytes(pos, 4)
		  pos = pos + 4
		  
		  If chunkType <> "IHDR" Then
		    mError = "Invalid PNG: First chunk is not IHDR"
		    Return
		  End If
		  
		  If chunkLen <> 13 Then
		    mError = "Invalid PNG: IHDR chunk has wrong length"
		    Return
		  End If
		  
		  If pos + 13 > dataLen Then
		    mError = "Truncated PNG: IHDR data incomplete"
		    Return
		  End If
		  
		  // Read IHDR data (13 bytes)
		  // Width (4 bytes, big-endian)
		  mWidth = mImageData.MiddleBytes(pos, 1).AscByte * &h1000000 + _
		  mImageData.MiddleBytes(pos + 1, 1).AscByte * &h10000 + _
		  mImageData.MiddleBytes(pos + 2, 1).AscByte * &h100 + _
		  mImageData.MiddleBytes(pos + 3, 1).AscByte
		  pos = pos + 4
		  
		  // Height (4 bytes, big-endian)
		  mHeight = mImageData.MiddleBytes(pos, 1).AscByte * &h1000000 + _
		  mImageData.MiddleBytes(pos + 1, 1).AscByte * &h10000 + _
		  mImageData.MiddleBytes(pos + 2, 1).AscByte * &h100 + _
		  mImageData.MiddleBytes(pos + 3, 1).AscByte
		  pos = pos + 4
		  
		  // Bit depth (1 byte)
		  mBitsPerComponent = mImageData.MiddleBytes(pos, 1).AscByte
		  pos = pos + 1
		  
		  // Color type (1 byte)
		  Dim colorType As Integer = mImageData.MiddleBytes(pos, 1).AscByte
		  pos = pos + 1
		  
		  // Determine color space from color type
		  Select Case colorType
		  Case 0 // Grayscale
		    mColorSpace = "DeviceGray"
		  Case 2 // RGB
		    mColorSpace = "DeviceRGB"
		  Case 3 // Indexed (palette)
		    mColorSpace = "Indexed"
		  Case 4 // Grayscale + Alpha
		    mColorSpace = "DeviceGray" // Alpha will be handled separately
		  Case 6 // RGBA
		    mColorSpace = "DeviceRGB" // Alpha will be handled separately
		  Else
		    mError = "Unsupported PNG color type: " + Str(colorType)
		    Return
		  End Select

		  // Compression method (1 byte, must be 0)
		  Dim compression As Integer = mImageData.MiddleBytes(pos, 1).AscByte
		  pos = pos + 1
		  
		  If compression <> 0 Then
		    mError = "Unsupported PNG compression method: " + Str(compression)
		    Return
		  End If
		  
		  // Filter method (1 byte, must be 0)
		  Dim filter As Integer = mImageData.MiddleBytes(pos, 1).AscByte
		  pos = pos + 1
		  
		  If filter <> 0 Then
		    mError = "Unsupported PNG filter method: " + Str(filter)
		    Return
		  End If
		  
		  // Interlace method (1 byte, 0=none, 1=Adam7)
		  Dim interlace As Integer = mImageData.MiddleBytes(pos, 1).AscByte
		  
		  // For now, we support non-interlaced images
		  If interlace <> 0 Then
		    mError = "Interlaced PNG not yet supported"
		    Return
		  End If
		  
		  // Success - we've extracted the basic PNG metadata
		  // Note: Full PNG embedding support requires decompressing and re-encoding
		  // For now, this allows the image to be registered
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBitsPerComponent As Integer = 8
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mColorSpace As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mError As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFilePath As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImageData As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImageType As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWidth As Integer
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
