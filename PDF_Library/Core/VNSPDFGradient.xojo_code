#tag Class
Protected Class VNSPDFGradient
	#tag Property, Flags = &h0, Description = 537461727420636F6C6F7220726570726573656E746174696F6E2028652E672E2C2022302E352030203022292E0A
		clr1Str As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 456E6420636F6C6F7220726570726573656E746174696F6E2028652E672E2C2022302030203122292E0A
		clr2Str As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4172726179206F6620636F6C6F722073746F707320666F72206D756C74692D73746F70206772616469656E74732E20456163682050616972206973202870657263656E74416C6F6E674772616469656E742C20636F6C6F72537472696E67292E
		colorStops() As Pair
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 504446206F626A656374206E756D62657220666F722074686973206772616469656E74207061747465726E2E0A
		objNum As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 526164697573206F6620656E64696E6720636972636C652028666F722072616469616C206772616469656E7473206F6E6C79292E0A
		r As Double
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4772616469656E74207479706520283220666F72206C696E6561722C203320666F722072616469616C292E0A
		tp As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5820636F6F7264696E617465206F66207374617274696E6720706F696E7420286E6F726D616C697A65642C20302D31292E
		x1 As Double
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5820636F6F7264696E617465206F6620656E64696E6720706F696E7420286E6F726D616C697A65642C20302D31292E
		x2 As Double
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5920636F6F7264696E617465206F66207374617274696E6720706F696E7420286E6F726D616C697A65642C20302D31292E
		y1 As Double
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5920636F6F7264696E617465206F6620656E64696E6720706F696E7420286E6F726D616C697A65642C20302D31292E
		y2 As Double
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
			Name="tp"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="clr1Str"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="clr2Str"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="x1"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="y1"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="x2"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="y2"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="r"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="objNum"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
