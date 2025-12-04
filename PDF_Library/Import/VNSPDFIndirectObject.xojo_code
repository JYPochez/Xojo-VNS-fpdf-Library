#tag Class
Protected Class VNSPDFIndirectObject
Inherits VNSPDFType
	#tag Method, Flags = &h1
		Shared Function Parse(tokenizer As VNSPDFTokenizer, objNum As Integer, gen As Integer) As VNSPDFIndirectObject
		  // Parse indirect object: 5 0 obj ... endobj
		  // Object number and generation are already read

		  // Skip "obj" keyword (should be next token)
		  Dim objToken As String = tokenizer.GetNextToken()
		  If objToken <> "obj" Then
		    // Error: expected "obj" keyword
		    Dim obj As New VNSPDFIndirectObject
		    obj.objectNumber = objNum
		    obj.generation = gen
		    obj.value = New VNSPDFNull
		    Return obj
		  End If

		  // Read the object value
		  Dim token As String = tokenizer.GetNextToken()
		  Dim objectValue As VNSPDFType

		  If token = "<<" Then
		    // Dictionary or stream
		    Dim dict As VNSPDFDictionary = VNSPDFDictionary.Parse(tokenizer)

		    // Check if it's followed by "stream"
		    Dim reader As VNSPDFStreamReader = tokenizer.GetReader()
		    Dim offset As Integer = reader.GetOffset()

		    // Skip whitespace
		    While True
		      Dim b As Integer = reader.ReadByte()
		      If b = -1 Then Exit While
		      Dim ch As String = Chr(b)
		      If ch <> " " And ch <> Chr(9) And ch <> Chr(10) And ch <> Chr(13) Then
		        reader.SetOffset(offset)
		        Exit While
		      End If
		      offset = reader.GetOffset()
		    Wend

		    Dim peekToken As String = tokenizer.GetNextToken()
		    If peekToken = "stream" Then
		      // It's a stream
		      tokenizer.PushBack(peekToken)
		      objectValue = VNSPDFStream.Parse(tokenizer, dict)
		    Else
		      // Just a dictionary
		      tokenizer.PushBack(peekToken)
		      objectValue = dict
		    End If
		  ElseIf token = "[" Then
		    // Array
		    objectValue = VNSPDFArray.Parse(tokenizer)
		  ElseIf token = "(" Then
		    // Literal string
		    Dim reader As VNSPDFStreamReader = tokenizer.GetReader()
		    Dim dummy As Integer = reader.ReadByte()  // Skip (
		    objectValue = VNSPDFString.Parse(reader)
		  ElseIf token = "<" Then
		    // Hex string
		    Dim reader As VNSPDFStreamReader = tokenizer.GetReader()
		    Dim dummy As Integer = reader.ReadByte()  // Skip <
		    objectValue = VNSPDFHexString.Parse(reader)
		  ElseIf token = "/" Then
		    // Name
		    Dim reader As VNSPDFStreamReader = tokenizer.GetReader()
		    objectValue = VNSPDFName.Parse(reader)
		  ElseIf token = "true" Or token = "false" Then
		    // Boolean
		    objectValue = VNSPDFBoolean.Create(token = "true")
		  ElseIf token = "null" Then
		    // Null
		    objectValue = New VNSPDFNull
		  Else
		    // Numeric
		    objectValue = VNSPDFNumeric.Create(Val(token))
		  End If

		  // Skip to "endobj" keyword
		  While True
		    Dim endToken As String = tokenizer.GetNextToken()
		    If endToken = "" Or endToken = "endobj" Then Exit While
		  Wend

		  Dim obj As New VNSPDFIndirectObject
		  obj.objectNumber = objNum
		  obj.generation = gen
		  obj.value = objectValue
		  Return obj
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		objectNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		generation As Integer
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
		#tag ViewProperty
			Name="objectNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="generation"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
