#tag Class
Protected Class VNSPDFFont
	#tag Method, Flags = &h0, Description = 496E697469616C697A65732061206E657720666F6E742E
		Sub Constructor(familyName As String, style As String, descriptor As VNSPDFFontDescriptor, widths() As Integer)
		  mFamilyName = familyName
		  mStyle = style
		  mDescriptor = descriptor
		  mEncoding = "cp1252"
		  mEmbedded = False
		  mSubsetted = False
		  
		  // Copy character widths (must be exactly 256 values)
		  If widths.Ubound = 255 Then
		    For i As Integer = 0 To 255
		      mCharWidths(i) = widths(i)
		    Next
		  Else
		    // Initialize with default width if invalid
		    Dim defaultWidth As Integer = 500
		    For i As Integer = 0 To 255
		      mCharWidths(i) = defaultWidth
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652077696474206F66206120737065636966696564206368617261637465722E
		Function GetCharWidth(charCode As Integer) As Integer
		  If charCode >= 0 And charCode <= 255 Then
		    Return mCharWidths(charCode)
		  Else
		    Return 0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520776964746820206120737472696E6720617420746865207370656369C3AD6564206F6E742073697A652E
		Function GetStringWidth(text As String, fontSize As Double) As Double
		  Dim totalWidth As Integer = 0
		  Dim textLen As Integer = LenB(text)
		  
		  For i As Integer = 1 To textLen
		    Dim char As String = text.Middle(i, 1)
		    Dim charCode As Integer = Asc(char)
		    If charCode >= 0 And charCode <= 255 Then
		      totalWidth = totalWidth + mCharWidths(charCode)
		    End If
		  Next
		  
		  // Convert from character units (1/1000 em) to points
		  Return (totalWidth * fontSize) / 1000.0
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 466F6E742064657363726970746F7220636F6E7461696E696E67206D6574726963732E
		Descriptor As VNSPDFFontDescriptor
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 576865746865722074686520666F6E7420697320656D6E6465647420696E2074686520504446
		Embedded As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 456E636F64696E67206E616D652028652E672C20E2809C6370313235E2809D292E
		Encoding As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 466F6E742066616D696C79206E616D652028652E672C20E2809C48656C76657469E2809D292E
		FamilyName As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 46756C6C20666F6E74206E616D65206C696E657220666F6E742066616D696C7920616E64207374796C652028652E672C20E2809C48656C76657469612D426FE2809D292E
		FullName As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4368617261637465722077696474687320666F7220616C6C203235362063686172616374657273202830E280933235352920696E20313030306D20656D2E
		Private mCharWidths(255) As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mDescriptor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mDescriptor = value
			End Set
		#tag EndSetter
		Private mDescriptor As VNSPDFFontDescriptor
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mEmbedded
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mEmbedded = value
			End Set
		#tag EndSetter
		Private mEmbedded As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mEncoding
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mEncoding = value
			End Set
		#tag EndSetter
		Private mEncoding As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mFamilyName
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFamilyName = value
			End Set
		#tag EndSetter
		Private mFamilyName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If mStyle = "" Or mStyle = "Regular" Then
			    Return mFamilyName
			  Else
			    Return mFamilyName + "-" + mStyle
			  End If
			End Get
		#tag EndGetter
		Private mFullName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mStyle
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mStyle = value
			End Set
		#tag EndSetter
		Private mStyle As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mSubsetted
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSubsetted = value
			End Set
		#tag EndSetter
		Private mSubsetted As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 466F6E74207374796C652028652E672C20E2809C42E2809D20666F7220426F6C642C20E2809C49E2809D20666F7220497461C3AD632C2065746329
		Style As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5768657468657220746865206F6E7420697320736C757366E2809A69642028E2809A6C79207573656420636861726163E2809A6572732920666F7220656D62656464696E672E
		Subsetted As Boolean
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
			Name="FamilyName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Style"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FullName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Encoding"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Embedded"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Subsetted"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
