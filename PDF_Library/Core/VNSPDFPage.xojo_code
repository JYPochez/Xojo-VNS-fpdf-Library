#tag Class
Protected Class VNSPDFPage
	#tag Method, Flags = &h0, Description = 41646473206120636C69636B61626C65206C696E6B20746F20746865207061676520616E642072657475726E73207468652073657175656E7469616C206C696E6B2049442E0A
		Function AddLink(x As Double, y As Double, width As Double, height As Double, url As String) As Integer
		  Var linkDict As New Dictionary
		  linkDict.Value("x") = x
		  linkDict.Value("y") = y
		  linkDict.Value("width") = width
		  linkDict.Value("height") = height
		  linkDict.Value("url") = url
		  
		  mLinks.Add(linkDict)
		  
		  Return mLinks.LastIndex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41707065656473206E657720636F6E74656E7420746F20746865207061676520636F6E74656E742073747265616D2E0A
		Sub AppendContent(content As String)
		  mContent = mContent + content
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6561727320616C6C20636F6E74656E742066726F6D207468652070616765207374726561612E0A
		Sub ClearContent()
		  mContent = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E697469616C697A657320612050444650616765206F626A6563742077697468207061676520706172616D65746572732E0A
		Sub Constructor(pageNumber As Integer, width As Double, height As Double, orientation As VNSPDFModule.ePageOrientation)
		  mPageNumber = pageNumber
		  mWidth = width
		  mHeight = height
		  mOrientation = orientation
		  mContent = ""
		  mRotation = 0
		  
		  mMediaBox = "0 0 " + Str(mWidth) + " " + Str(mHeight)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520746F74616C206C656E677468206F66207468652070616765636F6E74656E742073747265616D2E0A
		Function GetContentLength() As Integer
		  Return mContent.Length
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520504446204D65646961426F7820737472696E6720666F72207468697320706167652E0A
		Function GetMediaBox() As String
		  Return mMediaBox
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652070616765206F726174696F6E20616E676C652076616C696461746564746F20302C2039302C203138302C206F7220323730206465677265732E0A
		Sub SetRotation(angle As Integer)
		  Select Case angle
		  Case 0, 90, 180, 270
		    mRotation = angle
		  Else
		    Raise New InvalidArgumentException("Rotation angle must be 0, 90, 180, or 270 degrees")
		  End Select
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAnnotations() As Variant
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mContent
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mContent = value
			End Set
		#tag EndSetter
		Private mContent As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLinks() As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMediaBox As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOrientation As VNSPDFModule.ePageOrientation
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageNumber As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mRotation
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  SetRotation(value)
			End Set
		#tag EndSetter
		Private mRotation As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mWidth As Double
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
	#tag EndViewBehavior
End Class
#tag EndClass
