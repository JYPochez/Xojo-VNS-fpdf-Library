#tag Class
Protected Class VNSPDFAttachment
	#tag Method, Flags = &h0, Description = 52657475726E7320746865204D443520636865636B73756D206F662074686520636F6E74656E7420617320686578207374722E0A
		Function Checksum() As String
		  // Return the MD5 checksum of the content as hex string
		  // Used in PDF EmbeddedFile stream for integrity verification
		  
		  If mContent = "" Then Return ""
		  
		  Dim md5Hash As String = Crypto.MD5(mContent)
		  
		  // Convert to hex string
		  Dim result As String = ""
		  For i As Integer = 0 To md5Hash.Bytes - 1
		    Dim b As Integer = md5Hash.Middle(i, 1).Asc
		    Dim hexByte As String = "0" + Hex(b)
		    result = result + hexByte.Right(2)
		  Next
		  
		  Return result.Lowercase
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726561746573206120564E53504446417474616368656D656E742066726F6D2061204D656D6F7279426C6F636B2E0A
		Sub Constructor(filename As String, content As MemoryBlock, description As String = "")
		  // Create attachment from MemoryBlock content
		  // filename: The displayed name of the attachment in PDF readers
		  // content: The file content as MemoryBlock
		  // description: Optional description shown in PDF readers
		  
		  mFilename = filename
		  If content <> Nil Then
		    mContent = content.StringValue(0, content.Size)
		  Else
		    mContent = ""
		  End If
		  mDescription = description
		  mObjectNumber = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726561746573206120564E53504446417474616368656D656E742066726F6D206120737472696E672E0A
		Sub Constructor(filename As String, content As String, description As String = "")
		  // Create attachment from string content
		  // filename: The displayed name of the attachment in PDF readers
		  // content: The file content as a string
		  // description: Optional description shown in PDF readers
		  
		  mFilename = filename
		  mContent = content
		  mDescription = description
		  mObjectNumber = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726561746573206120564E535044464174746163686D656E742077697468204D494D45207479706520616E642041462072656C6174696F6E7368697020666F72205044462F412D332E
		Sub Constructor(filename As String, content As String, description As String, mimeType As String, afRelationship As String)
		  // Create attachment with PDF/A-3 metadata
		  // filename: The displayed name of the attachment in PDF readers
		  // content: The file content as a string
		  // description: Description shown in PDF readers
		  // mimeType: MIME type (e.g. "application/xml")
		  // afRelationship: AF relationship (e.g. "Data", "Source", "Alternative")
		  
		  mFilename = filename
		  mContent = content
		  mDescription = description
		  mMimeType = mimeType
		  mAFRelationship = afRelationship
		  mObjectNumber = 0
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 41462072656C6174696F6E73686970207479706520666F72205044462F412D332028652E672E20446174612C20536F757263652C20416C7465726E6174697665292E
		#tag Getter
			Get
			  Return mAFRelationship
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mAFRelationship = value
			End Set
		#tag EndSetter
		AFRelationship As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520636F6E74656E74206F66207468652061747461636865642066696C652E0A
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
		Content As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 4F7074696F6E616C206465736372697074696F6E20666F722074686520617474616368656D656E742E0A
		#tag Getter
			Get
			  Return mDescription
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mDescription = value
			End Set
		#tag EndSetter
		Description As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520646973706C61796564206E616D65206F662074686520617474616368656D656E7420696E20504446207265616465722E0A
		#tag Getter
			Get
			  Return mFilename
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFilename = value
			End Set
		#tag EndSetter
		Filename As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 41462072656C6174696F6E73686970207479706520666F72205044462F412D332E
		Private mAFRelationship As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520636F6E74656E74206F66207468652061747461636865642066696C652E0A
		Private mContent As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F7074696F6E616C206465736372697074696F6E20666F722074686520617474616368656D656E742E0A
		Private mDescription As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520646973706C61796564206E616D65206F662074686520617474616368656D656E7420696E20504446207265616465722E0A
		Private mFilename As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 4D494D45207479706520666F72205044462F412D3320656D6265646465642066696C652028652E672E206170706C69636174696F6E2F786D6C292E
		#tag Getter
			Get
			  Return mMimeType
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMimeType = value
			End Set
		#tag EndSetter
		MimeType As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 4D494D45207479706520666F72205044462F412D3320656D6265646465642066696C652E
		Private mMimeType As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 496E7465726E616C206F626A656374206E756D62657220616674657220656D62656464696E67202830206966206E6F7420656D62656464656420796574292E0A
		Private mObjectNumber As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 496E7465726E616C206F626A656374206E756D62657220616674657220656D62656464696E67202830206966206E6F7420656D62656464656420796574292E0A
		#tag Getter
			Get
			  Return mObjectNumber
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mObjectNumber = value
			End Set
		#tag EndSetter
		ObjectNumber As Integer
	#tag EndComputedProperty


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
			Name="Content"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Description"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Filename"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ObjectNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AFRelationship"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MimeType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
