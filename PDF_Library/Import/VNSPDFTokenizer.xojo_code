#tag Class
Protected Class VNSPDFTokenizer
	#tag Method, Flags = &h0
		Sub ClearStack()
		  // Clear the token pushback stack
		  ReDim mStack(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(reader As VNSPDFStreamReader)
		  // Constructor
		  mStreamReader = reader
		  ReDim mStack(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetNextToken() As String
		  // Get next token from stream
		  // Returns empty string if EOF

		  // Check stack first (pushed-back tokens)
		  If mStack.Count > 0 Then
		    Dim token As String = mStack(mStack.LastIndex)
		    mStack.RemoveAt(mStack.LastIndex)
		    Return token
		  End If

		  Dim b As Integer = mStreamReader.ReadByte()
		  If b = -1 Then Return ""

		  Dim ch As String = Chr(b)

		  // Skip whitespace
		  If IsWhitespace(ch) Then
		    If Not LeapWhiteSpaces() Then Return ""
		    b = mStreamReader.ReadByte()
		    If b = -1 Then Return ""
		    ch = Chr(b)
		  End If

		  // Check for two-character delimiters: << and >>
		  If ch = "<" Or ch = ">" Then
		    Dim offset As Integer = mStreamReader.GetOffset()
		    Dim nextByte As Integer = mStreamReader.ReadByte()
		    If nextByte <> -1 Then
		      Dim nextCh As String = Chr(nextByte)
		      If (ch = "<" And nextCh = "<") Or (ch = ">" And nextCh = ">") Then
		        Return ch + nextCh  // Return "<<" or ">>"
		      Else
		        mStreamReader.SetOffset(offset)  // Push back
		      End If
		    End If
		    Return ch  // Single < or >
		  End If

		  // Single-character delimiters
		  Select Case ch
		  Case "/", "[", "]", "(", ")", "{", "}"
		    Return ch

		  Case "%"
		    // Comment - skip to end of line
		    Dim line As String = mStreamReader.ReadLine()
		    Return GetNextToken()  // Recurse for next real token
		  End Select

		  // Multi-character token (keyword, number, name)
		  Dim token As String = ch
		  While True
		    Dim offset As Integer = mStreamReader.GetOffset()
		    b = mStreamReader.ReadByte()
		    If b = -1 Then Exit

		    ch = Chr(b)
		    If IsDelimiter(ch) Or IsWhitespace(ch) Then
		      // Push back delimiter/whitespace
		      mStreamReader.SetOffset(offset)
		      Exit
		    End If

		    token = token + ch
		  Wend

		  Return token
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetReader() As VNSPDFStreamReader
		  // Get the stream reader (alias for GetStreamReader)
		  Return mStreamReader
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStreamReader() As VNSPDFStreamReader
		  // Get the stream reader
		  Return mStreamReader
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LeapWhiteSpaces() As Boolean
		  // Skip over whitespace characters
		  // Returns False if EOF, True if content found

		  Dim b As Integer
		  While True
		    b = mStreamReader.ReadByte()
		    If b = -1 Then Return False

		    If Not IsWhitespace(Chr(b)) Then
		      // Found non-whitespace, push back
		      Dim offset As Integer = mStreamReader.GetOffset()
		      If offset > 0 Then
		        mStreamReader.SetOffset(offset - 1)
		      End If
		      Return True
		    End If
		  Wend

		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PushBack(token As String)
		  // Push token back onto stack for re-reading (alias for PushStack)
		  mStack.Add(token)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PushStack(token As String)
		  // Push token back onto stack for re-reading
		  mStack.Add(token)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsDelimiter(ch As String) As Boolean
		  // Check if character/string is a PDF delimiter
		  Select Case ch
		  Case "(", ")", "<", ">", "<<", ">>", "[", "]", "{", "}", "/", "%"
		    Return True
		  Else
		    Return False
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsWhitespace(ch As String) As Boolean
		  // Check if character is PDF whitespace
		  // PDF whitespace: NULL (0), HT (9), LF (10), FF (12), CR (13), SPACE (32)

		  Dim code As Integer = Asc(ch)
		  Select Case code
		  Case 0, 9, 10, 12, 13, 32
		    Return True
		  Else
		    Return False
		  End Select
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mStack() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStreamReader As VNSPDFStreamReader
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
