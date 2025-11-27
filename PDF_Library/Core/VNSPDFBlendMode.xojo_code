#tag Class
Protected Class VNSPDFBlendMode
	#tag Property, Flags = &h0, Description = 416C706861207661C75652066F72206669C6C206F7065726174696F6E732028652E672E2C2022302E35303022292E0
		fillStr As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 426C656E64206D6F6465206E616D652028652E672E2C20224E6F726D616C22292E0A
		modeStr As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 504446206F626A656374206E756D62657220666F722074686973206772617068696373207374617465206F626A6563742E0A
		objNum As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416C706861207661C75652066F72207374726F6B65206F7065726174696F6E732028652E672E2C2022302E35303022292E0A
		strokeStr As String
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
			Name="fillStr"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strokeStr"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="modeStr"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="objNum"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
