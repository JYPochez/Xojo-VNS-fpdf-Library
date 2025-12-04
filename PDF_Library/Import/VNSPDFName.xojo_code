#tag Class
Protected Class VNSPDFName
Inherits VNSPDFType
	#tag Method, Flags = &h1
		Shared Function Parse(reader As VNSPDFStreamReader) As VNSPDFName
		  // Parse name from stream: /Type or /PageSize or /Name#20With#20Spaces
		  // Names start with / and can contain #xx hex escapes

		  Dim result As String = ""

		  While True
		    Dim b As Integer = reader.ReadByte()
		    If b = -1 Then Exit While

		    Dim ch As String = Chr(b)

		    // Name ends at delimiter or whitespace
		    If ch = "/" Or ch = "[" Or ch = "]" Or ch = "(" Or ch = ")" Or _
		      ch = "<" Or ch = ">" Or ch = "{" Or ch = "}" Or _
		      ch = " " Or ch = Chr(9) Or ch = Chr(10) Or ch = Chr(13) Then
		      // Push back delimiter/whitespace
		      Dim offset As Integer = reader.GetOffset()
		      reader.SetOffset(offset - 1)
		      Exit While
		    End If

		    // Handle hex escape #xx
		    If ch = "#" Then
		      Dim hex1 As Integer = reader.ReadByte()
		      Dim hex2 As Integer = reader.ReadByte()
		      If hex1 <> -1 And hex2 <> -1 Then
		        Dim hexStr As String = Chr(hex1) + Chr(hex2)
		        Dim decimal As Integer = Val("&h" + hexStr)
		        result = result + Chr(decimal)
		      End If
		    Else
		      result = result + ch
		    End If
		  Wend

		  Dim obj As New VNSPDFName
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
