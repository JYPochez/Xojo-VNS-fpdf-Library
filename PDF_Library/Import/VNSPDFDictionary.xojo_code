#tag Class
Protected Class VNSPDFDictionary
Inherits VNSPDFType
	#tag Method, Flags = &h1
		Shared Function Parse(tokenizer As VNSPDFTokenizer) As VNSPDFDictionary
		  // Parse dictionary from stream: << /Key /Value /Key2 123 >>
		  // Dictionary is key-value pairs where keys are names

		  Dim dict As New Dictionary
		  Dim loopCount As Integer = 0
		  Dim maxLoops As Integer = 100  // Safety limit - reduced from 1000
		  Dim reader As VNSPDFStreamReader = tokenizer.GetReader()

		  While loopCount < maxLoops
		    loopCount = loopCount + 1

		    Dim token As String = tokenizer.GetNextToken()


		    If token = "" Or token = ">>" Then

		      Exit While
		    End If

		    // Key must be a name (starts with /)
		    If token <> "/" Then

		      // Not a name, might be end of dict
		      tokenizer.PushBack(token)
		      Exit While  // Changed from Continue to Exit While to prevent infinite loop
		    End If

		    // Read the key name (next token after "/")
		    Dim key As String = tokenizer.GetNextToken()

		    If key = "" Then Exit While

		    // Read the value
		    Dim valueToken As String = tokenizer.GetNextToken()

		    If valueToken = "" Then Exit While

		    Dim valueObj As VNSPDFType

		    // Parse value based on token type
		    If valueToken = "[" Then
		      // Array
		      valueObj = VNSPDFArray.Parse(tokenizer)
		    ElseIf valueToken = "<<" Then
		      // Nested dictionary
		      valueObj = VNSPDFDictionary.Parse(tokenizer)
		    ElseIf valueToken = "(" Then
		      // Literal string
		      Dim dummy As Integer = reader.ReadByte()  // Skip (
		      valueObj = VNSPDFString.Parse(reader)
		    ElseIf valueToken = "<" Then
		      // Check if it's << (already handled) or hex string
		      Dim nextChar As String = tokenizer.GetNextToken()
		      If nextChar = "<" Then
		        // It's a dictionary
		        valueObj = VNSPDFDictionary.Parse(tokenizer)
		      Else
		        // It's a hex string
		        tokenizer.PushBack(nextChar)
		        Dim dummy As Integer = reader.ReadByte()  // Skip <
		        valueObj = VNSPDFHexString.Parse(reader)
		      End If
		    ElseIf valueToken = "/" Then
		      // Name - read the name token
		      Dim nameToken As String = tokenizer.GetNextToken()
		      If nameToken = "" Or nameToken = ">>" Then
		        // Unexpected end of dictionary
		        tokenizer.PushBack(nameToken)
		        Exit While
		      End If
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
		      // Check if it's a number or indirect reference
		      Dim nextToken As String = tokenizer.GetNextToken()
		      Dim thirdToken As String = tokenizer.GetNextToken()
		      If thirdToken = "R" Then
		        // Indirect reference: 5 0 R
		        Dim ref As New VNSPDFIndirectObjectReference
		        ref.objectNumber = Val(valueToken)
		        ref.generation = Val(nextToken)
		        valueObj = ref
		      Else
		        // Just a number
		        tokenizer.PushBack(thirdToken)
		        tokenizer.PushBack(nextToken)
		        valueObj = VNSPDFNumeric.Create(Val(valueToken))
		      End If
		    End If

		    // Only add to dictionary if we successfully parsed a value
		    If valueObj <> Nil Then
		      dict.Value(key) = valueObj

		    Else

		      // Failed to parse value, exit to prevent infinite loop
		      Exit While
		    End If
		  Wend



		  Dim obj As New VNSPDFDictionary
		  obj.value = dict
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
