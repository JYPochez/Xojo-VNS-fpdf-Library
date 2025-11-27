#tag Class
Protected Class VNSPDFOutputIntent
	#tag Method, Flags = &h0, Description = 496E697469616C697A6573206120504446206F757470757420696E74656E74206F626A6563742E0A
		Sub Constructor(subtype As String, outputCondition As String, info As String, iccProfile As MemoryBlock)
		  // Initialize output intent with specified parameters
		  mSubtype = subtype
		  mOutputCondition = outputCondition
		  mInfo = info
		  
		  If iccProfile <> Nil Then
		    mICCProfile = iccProfile
		  Else
		    mICCProfile = New MemoryBlock(0)
		  End If
		End Sub
	#tag EndMethod


	#tag Note, Name = Class Description
		Represents a PDF output intent for archival compliance (PDF/A, PDF/X, PDF/E).
		Output intents specify the color rendering characteristics for the document.
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0, Description = 5265747572737320746865204943432070726F66696C652064617461206173204D656D6F7279426C6F636B2E0A
		#tag Getter
			Get
			  Return mICCProfile
			End Get
		#tag EndGetter
		ICCProfile As MemoryBlock
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 526574F72E7320746865206F7074696F6E616C20696E666F726D6174696F6E616C20746578742E0A
		#tag Getter
			Get
			  Return mInfo
			End Get
		#tag EndGetter
		Info As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 4943432070726F66696C652062696E617279206461746120666F7220636F6C6F722072656E646572696E672E0A
		Private mICCProfile As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F7074696F6E616C20696E666F726D6174696F6E616C2074657874206465736372696269676720746865206F757470757420696E74656E742E0A
		Private mInfo As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F757470757420636F6E646974696F6E206964656E746966696572207374726E672E0A
		Private mOutputCondition As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F757470757420696E74656E74207375627479706520287375636820617320475453005044465820666F7220504446582C20475453005044464131206F7220504446412D31292E0A
		Private mSubtype As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5265747572E73207468652006F757470757420636F6E646974696F6E206964656E7469666965722E0A
		#tag Getter
			Get
			  Return mOutputCondition
			End Get
		#tag EndGetter
		OutputCondition As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520696E74656E74207375627479706520287375636820617320475453005044465829290A
		#tag Getter
			Get
			  Return mSubtype
			End Get
		#tag EndGetter
		Subtype As String
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
			Name="Info"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OutputCondition"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Subtype"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
