#tag Class
Protected Class VNSPDFCrossReference
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize empty xref table
		  mEntries = New Dictionary
		  trailer = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetEntry(objectNumber As Integer) As VNSPDFXrefEntry
		  // Get xref entry for object ID
		  If mEntries.HasKey(objectNumber) Then
		    Return mEntries.Value(objectNumber)
		  Else
		    Return Nil
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetObjectOffset(objectNumber As Integer) As Int64
		  // Get byte offset for object ID
		  // Returns -1 for free objects or compressed objects (type 2 in xref streams)
		  Dim entry As VNSPDFXrefEntry = GetEntry(objectNumber)
		  If entry <> Nil And entry.inUse And entry.compressedInStream = -1 Then
		    Return entry.offset
		  Else
		    Return -1
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetEntry(objectNumber As Integer, entry As VNSPDFXrefEntry)
		  // Add/update xref entry
		  mEntries.Value(objectNumber) = entry
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mEntries As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		trailer As VNSPDFDictionary
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
