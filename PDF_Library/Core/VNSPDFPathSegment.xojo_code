#tag Class
Protected Class VNSPDFPathSegment
	#tag Method, Flags = &h0
		Sub Constructor(segType As VNSPDFModule.ePathSegmentType, x As Double = 0, y As Double = 0, cp1x As Double = 0, cp1y As Double = 0, cp2x As Double = 0, cp2y As Double = 0)
		  // Initialize segment with all parameters
		  mSegmentType = segType
		  mX = x
		  mY = y
		  mCp1X = cp1x
		  mCp1Y = cp1y
		  mCp2X = cp2x
		  mCp2Y = cp2y
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 466972737420636F6E74726F6C20706F696E742058202863756269632042657A696572292E
		mCp1X As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 466972737420636F6E74726F6C20706F696E742059202863756269632042657A696572292E
		mCp1Y As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5365636F6E6420636F6E74726F6C20706F696E742058202863756269632042657A69657229206F72207769647468202872656374616E676C65292E
		mCp2X As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5365636F6E6420636F6E74726F6C20706F696E742059202863756269632042657A69657229206F7220686569676874202872656374616E676C65292E
		mCp2Y As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074797065206F662074686973207365676D656E7420284D6F7665546F2C204C696E65546F2C20437562696342657A696572546F2C206574632E292E
		mSegmentType As VNSPDFModule.ePathSegmentType
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 456E6420706F696E74205820636F6F7264696E6174652E
		mX As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 456E6420706F696E74205920636F6F7264696E6174652E
		mY As Double = 0
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
			Name="mSegmentType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="VNSPDFModule.ePathSegmentType"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mX"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mY"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mCp1X"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mCp1Y"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mCp2X"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mCp2Y"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
