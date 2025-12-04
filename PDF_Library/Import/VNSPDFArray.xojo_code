#tag Class
Protected Class VNSPDFArray
Inherits VNSPDFType
	#tag Method, Flags = &h1
		Shared Function Parse(tokenizer As VNSPDFTokenizer) As VNSPDFArray
		  // Parse array from stream: [1 2 3] or [/Type /Page]
		  // Array elements can be any PDF type

		  Dim elements() As VNSPDFType
		  Dim loopCount As Integer = 0
		  Dim maxLoops As Integer = 1000

		  While loopCount < maxLoops
		    loopCount = loopCount + 1

		    Dim token As String = tokenizer.GetNextToken()

		    If token = "" Or token = "]" Then

		      Exit While
		    End If

		    // Parse element based on token type
		    If token = "[" Then
		      // Nested array
		      elements.Add(VNSPDFArray.Parse(tokenizer))
		    ElseIf token = "<<" Then
		      // Dictionary
		      elements.Add(VNSPDFDictionary.Parse(tokenizer))
		    ElseIf token = "(" Then
		      // Literal string
		      Dim reader As VNSPDFStreamReader = tokenizer.GetReader()
		      elements.Add(VNSPDFString.Parse(reader))
		    ElseIf token = "<" Then
		      // Hex string
		      Dim reader As VNSPDFStreamReader = tokenizer.GetReader()
		      elements.Add(VNSPDFHexString.Parse(reader))
		    ElseIf token = "/" Then
		      // Name - read the name token
		      Dim nameToken As String = tokenizer.GetNextToken()

		      If nameToken = "" Or nameToken = "]" Then
		        // Unexpected end
		        tokenizer.PushBack(nameToken)
		        Exit While
		      End If
		      Dim nameObj As New VNSPDFName
		      nameObj.value = nameToken
		      elements.Add(nameObj)
		    ElseIf token = "true" Or token = "false" Then
		      // Boolean
		      elements.Add(VNSPDFBoolean.Create(token = "true"))
		    ElseIf token = "null" Then
		      // Null
		      elements.Add(New VNSPDFNull)
		    Else
		      // Check if it's a number or indirect reference
		      Dim nextToken As String = tokenizer.GetNextToken()
		      Dim thirdToken As String = tokenizer.GetNextToken()
		      
		      If thirdToken = "R" Then
		        // Indirect reference: "token nextToken R" = "12 0 R"
		        Dim ref As New VNSPDFIndirectObjectReference
		        ref.objectNumber = Val(token)
		        ref.generation = Val(nextToken)
		        elements.Add(ref)
		      Else
		        // Just a number - push back the tokens we speculatively read
		        If thirdToken <> "" Then tokenizer.PushBack(thirdToken)
		        If nextToken <> "" Then tokenizer.PushBack(nextToken)
		        elements.Add(VNSPDFNumeric.Create(Val(token)))
		      End If
		    End If

		  Wend



		  Dim obj As New VNSPDFArray
		  obj.value = elements
		  Return obj
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
