#tag Class
Protected Class VNSPDFHexString
Inherits VNSPDFType
	#tag Method, Flags = &h1
		Shared Function Parse(reader As VNSPDFStreamReader) As VNSPDFHexString
		  // Parse hex string from stream: <48656C6C6F>
		  // Converts hex pairs to binary string
		  // Whitespace is ignored

		  Dim hexStr As String = ""

		  While True
		    Dim b As Integer = reader.ReadByte()
		    If b = -1 Then Exit While

		    Dim ch As String = Chr(b)
		    If ch = ">" Then Exit While

		    // Ignore whitespace
		    If ch <> " " And ch <> Chr(9) And ch <> Chr(10) And ch <> Chr(13) Then
		      hexStr = hexStr + ch
		    End If
		  Wend

		  // Convert hex to binary string
		  Dim result As String = ""
		  For i As Integer = 0 To hexStr.Length - 1 Step 2
		    Dim hex As String
		    If i + 1 < hexStr.Length Then
		      hex = hexStr.Middle(i, 2)
		    Else
		      // Odd length - pad with 0
		      hex = hexStr.Middle(i, 1) + "0"
		    End If

		    // Convert hex pair to byte
		    Dim decimal As Integer = Val("&h" + hex)
		    result = result + Chr(decimal)
		  Next

		  Dim obj As New VNSPDFHexString
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
