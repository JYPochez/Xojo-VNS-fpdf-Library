#tag Class
Protected Class VNSPDFString
Inherits VNSPDFType
	#tag Method, Flags = &h1
		Shared Function Parse(reader As VNSPDFStreamReader) As VNSPDFString
		  // Parse literal string from stream: (Hello World) or (nested \(parens\))
		  // Handles escape sequences: \n, \r, \t, \(, \), \\, \ddd (octal)

		  Dim result As String = ""
		  Dim parentheses As Integer = 1  // Track nested parentheses
		  Dim escaped As Boolean = False

		  While True
		    Dim b As Integer = reader.ReadByte()
		    If b = -1 Then Exit While

		    Dim ch As String = Chr(b)

		    If escaped Then
		      // Handle escape sequences
		      Select Case ch
		      Case "n"
		        result = result + Chr(10)  // Line feed
		      Case "r"
		        result = result + Chr(13)  // Carriage return
		      Case "t"
		        result = result + Chr(9)   // Tab
		      Case "b"
		        result = result + Chr(8)   // Backspace
		      Case "f"
		        result = result + Chr(12)  // Form feed
		      Case "(", ")", "\"
		        result = result + ch       // Literal character
		      Case "0", "1", "2", "3", "4", "5", "6", "7"
		        // Octal escape sequence \ddd (1-3 digits)
		        Dim octal As String = ch
		        For i As Integer = 1 To 2
		          Dim nextByte As Integer = reader.ReadByte()
		          If nextByte >= 48 And nextByte <= 55 Then  // '0' to '7'
		            octal = octal + Chr(nextByte)
		          Else
		            // Not an octal digit, push back
		            If nextByte <> -1 Then
		              Dim offset As Integer = reader.GetOffset()
		              reader.SetOffset(offset - 1)
		            End If
		            Exit For i
		          End If
		        Next

		        // Convert octal to decimal
		        Dim decimal As Integer = 0
		        For i As Integer = 0 To octal.Length - 1
		          decimal = decimal * 8 + (octal.Middle(i, 1).Asc - 48)
		        Next
		        result = result + Chr(decimal)
		      Else
		        // Unknown escape, treat as literal
		        result = result + ch
		      End Select
		      escaped = False
		    Else
		      Select Case ch
		      Case "\"
		        escaped = True
		      Case "("
		        parentheses = parentheses + 1
		        result = result + ch
		      Case ")"
		        parentheses = parentheses - 1
		        If parentheses = 0 Then Exit While  // End of string
		        result = result + ch
		      Else
		        result = result + ch
		      End Select
		    End If
		  Wend

		  Dim obj As New VNSPDFString
		  obj.value = result
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
