#tag Class
Protected Class VNSPDFStreamReader
	#tag Method, Flags = &h0
		Sub Constructor(file As FolderItem)
		  // Constructor for file-based reading
		  mStream = BinaryStream.Open(file)
		  mFileSize = file.Length
		  mIsMemory = False

		  // Allocate initial buffer (8KB)
		  mBuffer = New MemoryBlock(gkInitialBufferSize)

		  // API2: Read as String (binary data), then copy to buffer
		  Dim data As String = mStream.Read(gkInitialBufferSize)
		  mBufferLength = data.Bytes
		  For i As Integer = 0 To mBufferLength - 1
		    mBuffer.UInt8Value(i) = data.MiddleBytes(i, 1).AscByte
		  Next

		  mOffset = 0
		  mTotalBytesRead = mBufferLength
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(data As MemoryBlock)
		  // Constructor for memory-based reading
		  mIsMemory = True
		  mBuffer = data
		  mBufferLength = data.Size
		  mFileSize = data.Size
		  mOffset = 0
		  mTotalBytesRead = data.Size
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  // Clean up resources
		  If mStream <> Nil Then
		    mStream.Close()
		    mStream = Nil
		  End If

		  mBuffer = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBuffer(ensureContent As Boolean = True) As MemoryBlock
		  // Get current buffer
		  If ensureContent Then
		    Dim dummy As Boolean = EnsureContent()
		  End If

		  Return mBuffer
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBufferLength() As Integer
		  // Get current buffer length
		  Return mBufferLength
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFileSize() As Integer
		  // Get total file size
		  Return mFileSize
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetOffset() As Integer
		  // Get current offset in buffer
		  Return mOffset
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAbsolutePosition() As Integer
		  // Get absolute position in file (not buffer-relative)
		  If mIsMemory Then
		    Return mOffset
		  Else
		    // Buffer starts at: (total bytes read) - (current buffer length)
		    // Absolute position = buffer start + offset within buffer
		    Dim bufferStart As Integer = mTotalBytesRead - mBufferLength
		    Return bufferStart + mOffset
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IncreaseBuffer(Optional size As Integer = 1024) As Boolean
		  // Increase buffer size by reading more data
		  // Returns True if more data was read, False if EOF

		  If mIsMemory Then
		    // Cannot expand memory buffer
		    Return False
		  End If

		  If mStream = Nil Or mStream.EndOfFile Then
		    Return False
		  End If

		  // Calculate new buffer size
		  Dim newSize As Integer = mBufferLength + size
		  Dim newBuffer As New MemoryBlock(newSize)

		  // Copy existing data
		  For i As Integer = 0 To mBufferLength - 1
		    newBuffer.UInt8Value(i) = mBuffer.UInt8Value(i)
		  Next

		  // Read more data
		  Dim bytesToRead As Integer = Min(size, mFileSize - mTotalBytesRead)
		  If bytesToRead <= 0 Then
		    Return False
		  End If

		  // API2: Read as String (binary data), then copy to buffer
		  Dim data As String = mStream.Read(bytesToRead)
		  Dim bytesRead As Integer = data.Bytes

		  If bytesRead > 0 Then
		    // Copy to buffer at offset
		    For i As Integer = 0 To bytesRead - 1
		      newBuffer.UInt8Value(mBufferLength + i) = data.MiddleBytes(i, 1).AscByte
		    Next

		    mBufferLength = mBufferLength + bytesRead
		    mTotalBytesRead = mTotalBytesRead + bytesRead
		    mBuffer = newBuffer
		    Return True
		  Else
		    Return False
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsEOF() As Boolean
		  // Check if at end of file
		  If mIsMemory Then
		    Return mOffset >= mBufferLength
		  Else
		    Return mOffset >= mBufferLength And (mStream = Nil Or mStream.EndOfFile)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadBytes(length As Integer) As MemoryBlock
		  // Read specified number of bytes from stream
		  Dim data As New MemoryBlock(length)

		  For i As Integer = 0 To length - 1
		    Dim b As Integer = ReadByte()
		    If b = -1 Then
		      // EOF reached - return partial data
		      Dim partial As New MemoryBlock(i)
		      For j As Integer = 0 To i - 1
		        partial.UInt8Value(j) = data.UInt8Value(j)
		      Next
		      Return partial
		    End If
		    data.UInt8Value(i) = b
		  Next

		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadByte() As Integer
		  // Read single byte and advance offset
		  // Returns -1 if EOF

		  If mOffset >= mBufferLength Then
		    If Not IncreaseBuffer() Then
		      Return -1
		    End If
		  End If

		  Dim b As Integer = mBuffer.UInt8Value(mOffset)
		  mOffset = mOffset + 1
		  Return b
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadLine() As String
		  // Read line until CR/LF
		  Dim result As String = ""
		  Dim b As Integer

		  While True
		    b = ReadByte()
		    If b = -1 Or b = 10 Or b = 13 Then
		      // EOF or line feed or carriage return
		      Exit While
		    End If

		    result = result + Chr(b)
		  Wend

		  // Skip additional CR/LF characters
		  If b = 13 Then
		    Dim nextByte As Integer
		    nextByte = ReadByte()
		    If nextByte <> 10 Then
		      // Not LF, push back
		      If mOffset > 0 Then
		        mOffset = mOffset - 1
		      End If
		    End If
		  End If

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset(position As Integer)
		  // Reset to specific file position
		  If mIsMemory Then
		    // Memory: just set offset
		    mOffset = Min(position, mBufferLength)
		  Else
		    // File: seek and reload buffer
		    If mStream <> Nil Then
		      mStream.BytePosition = position

		      // API2: Read as String (binary data), then copy to buffer
		      Dim data As String = mStream.Read(gkInitialBufferSize)
		      mBufferLength = data.Bytes
		      For i As Integer = 0 To mBufferLength - 1
		        mBuffer.UInt8Value(i) = data.MiddleBytes(i, 1).AscByte
		      Next

		      mOffset = 0
		      mTotalBytesRead = position + mBufferLength
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetOffset(offset As Integer)
		  // Set offset within current buffer
		  If offset >= 0 And offset <= mBufferLength Then
		    mOffset = offset
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EnsureContent() As Boolean
		  // Ensure there's content at current offset
		  If mOffset >= mBufferLength Then
		    Return IncreaseBuffer()
		  End If

		  Return True
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBuffer As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBufferLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFileSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsMemory As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStream As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTotalBytesRead As Integer
	#tag EndProperty


	#tag Constant, Name = gkInitialBufferSize, Type = Double, Dynamic = False, Default = \"8192", Scope = Private
	#tag EndConstant


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
