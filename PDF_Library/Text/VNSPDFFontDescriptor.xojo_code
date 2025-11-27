#tag Class
Protected Class VNSPDFFontDescriptor
	#tag Method, Flags = &h0, Description = 496E697469616C697A65732061206E657720666F6E742064657363726970746F722E
		Sub Constructor(ascent As Integer, descent As Integer, capHeight As Integer, flags As Integer, fontBBox As String, italicAngle As Integer, stemV As Integer)
		  mAscent = ascent
		  mDescent = descent
		  mCapHeight = capHeight
		  mFlags = flags
		  mFontBBox = fontBBox
		  mItalicAngle = italicAngle
		  mStemV = stemV
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206D6178696D756D2068656967687420616273206F766520746865206261736520696E2074686973206D6F6E742E
		Ascent As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652076657274696361206F6F7264696E617465206F66207468652074206F66206361702065747465727320666F6D20746865206261736520286578616D7065202248292E
		CapHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206D6178696D756D206465707468206265736F7720746865206261736520696E2074686973206D6F6E742E
		Descent As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4120636F6C6C656374696F6E206F6620666C616773206465666E696E672076617269206368617261637465726973746963732E
		Flags As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 466F6E7420626F756E64696E6720626F782028582C20592C20582C2059292E
		FontBBox As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 497461C3AD6320616E676520696E20646567726565732E
		ItalicAngle As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mAscent
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mAscent = value
			End Set
		#tag EndSetter
		Private mAscent As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mCapHeight
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCapHeight = value
			End Set
		#tag EndSetter
		Private mCapHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mDescent
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mDescent = value
			End Set
		#tag EndSetter
		Private mDescent As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mFlags
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFlags = value
			End Set
		#tag EndSetter
		Private mFlags As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mFontBBox
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFontBBox = value
			End Set
		#tag EndSetter
		Private mFontBBox As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mItalicAngle
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mItalicAngle = value
			End Set
		#tag EndSetter
		Private mItalicAngle As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mStemV
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mStemV = value
			End Set
		#tag EndSetter
		Private mStemV As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865207468696B6E657373206F662074686520646F6D696E616E74207665727469C3A16C20737472656B65732E
		StemV As Integer
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
			Name="Ascent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Descent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CapHeight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Flags"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontBBox"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ItalicAngle"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StemV"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
