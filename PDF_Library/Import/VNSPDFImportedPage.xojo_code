#tag Class
Protected Class VNSPDFImportedPage
	#tag Method, Flags = &h0
		Function GetRawContents(reader As VNSPDFReader, ByRef filter As String) As String
		  // Get RAW (possibly compressed) page content stream(s) without decompression
		  // filter: Output parameter - returns filter name (e.g., "FlateDecode") or empty string
		  // Returns: Concatenated raw content, or empty string if none

		  filter = ""

		  If contents = Nil Then
		    System.DebugLog("GetRawContents: ERROR - contents is Nil")
		    Return ""
		  End If

		  Dim result As String = ""

		  // Resolve indirect reference if needed
		  Dim contentObj As VNSPDFType = contents

		  If contentObj IsA VNSPDFIndirectObjectReference Then
		    Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(contentObj)
		    contentObj = reader.GetObject(ref.objectNumber)
		    If contentObj = Nil Then
		      System.DebugLog("GetRawContents: ERROR - Failed to resolve indirect reference!")
		      Return ""
		    End If
		  End If

		  // Handle single stream
		  If contentObj IsA VNSPDFStream Then
		    Dim stream As VNSPDFStream = VNSPDFStream(contentObj)

		    // Get filter name from stream dictionary
		    Dim streamDict As Dictionary = stream.dictionary.value
		    If streamDict.HasKey("Filter") Then
		      Dim filterObj As VNSPDFType = streamDict.Value("Filter")
		      If filterObj IsA VNSPDFName Then
		        filter = VNSPDFName(filterObj).value
		      End If
		    End If

		    // Get RAW data (compressed)
		    result = stream.data.StringValue(0, stream.data.Size)

		  // Handle array of streams
		  ElseIf contentObj IsA VNSPDFArray Then
		    Dim arr As VNSPDFArray = VNSPDFArray(contentObj)
		    Dim arrValue() As Variant = arr.value

		    For Each item As Variant In arrValue
		      If item IsA VNSPDFIndirectObjectReference Then
		        Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(item)
		        Dim streamObj As VNSPDFType = reader.GetObject(ref.objectNumber)
		        If streamObj IsA VNSPDFStream Then
		          Dim stream As VNSPDFStream = VNSPDFStream(streamObj)

		          // Get filter from first stream only
		          If filter = "" Then
		            Dim streamDict As Dictionary = stream.dictionary.value
		            If streamDict.HasKey("Filter") Then
		              Dim filterObj As VNSPDFType = streamDict.Value("Filter")
		              If filterObj IsA VNSPDFName Then
		                filter = VNSPDFName(filterObj).value
		              End If
		            End If
		          End If

		          Dim streamData As String = stream.data.StringValue(0, stream.data.Size)
		          result = result + streamData
		        Else
		          System.DebugLog("GetRawContents: Array item is not a stream: " + Introspection.GetType(streamObj).Name)
		        End If
		      ElseIf item IsA VNSPDFStream Then
		        Dim stream As VNSPDFStream = VNSPDFStream(item)

		        // Get filter from first stream only
		        If filter = "" Then
		          Dim streamDict As Dictionary = stream.dictionary.value
		          If streamDict.HasKey("Filter") Then
		            Dim filterObj As VNSPDFType = streamDict.Value("Filter")
		            If filterObj IsA VNSPDFName Then
		              filter = VNSPDFName(filterObj).value
		            End If
		          End If
		        End If

		        Dim streamData As String = stream.data.StringValue(0, stream.data.Size)
		        result = result + streamData
		      End If
		    Next
		  Else
		    System.DebugLog("GetRawContents: ERROR - contentObj is neither stream nor array: " + Introspection.GetType(contentObj).Name)
		  End If

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetDecodedContents(reader As VNSPDFReader) As String
		  // Get decoded page content stream(s)
		  // Returns: Concatenated decoded content, or empty string if none

		  If contents = Nil Then
		    System.DebugLog("GetDecodedContents: ERROR - contents is Nil")
		    Return ""
		  End If

		  Dim result As String = ""

		  // Resolve indirect reference if needed
		  Dim contentObj As VNSPDFType = contents

		  If contentObj IsA VNSPDFIndirectObjectReference Then
		    Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(contentObj)
		    contentObj = reader.GetObject(ref.objectNumber)
		    If contentObj = Nil Then
		      System.DebugLog("GetDecodedContents: ERROR - Failed to resolve indirect reference!")
		      Return ""
		    End If
		  End If

		  // Handle single stream
		  If contentObj IsA VNSPDFStream Then
		    Dim stream As VNSPDFStream = VNSPDFStream(contentObj)
		    result = stream.GetDecodedData()

		  // Handle array of streams
		  ElseIf contentObj IsA VNSPDFArray Then
		    Dim arr As VNSPDFArray = VNSPDFArray(contentObj)
		    Dim arrValue() As Variant = arr.value

		    For Each item As Variant In arrValue
		      If item IsA VNSPDFIndirectObjectReference Then
		        Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(item)
		        Dim streamObj As VNSPDFType = reader.GetObject(ref.objectNumber)
		        If streamObj IsA VNSPDFStream Then
		          Dim stream As VNSPDFStream = VNSPDFStream(streamObj)
		          Dim streamData As String = stream.GetDecodedData()
		          result = result + streamData
		        Else
		          System.DebugLog("GetDecodedContents: Array item is not a stream: " + Introspection.GetType(streamObj).Name)
		        End If
		      ElseIf item IsA VNSPDFStream Then
		        Dim stream As VNSPDFStream = VNSPDFStream(item)
		        Dim streamData As String = stream.GetDecodedData()
		        result = result + streamData
		      End If
		    Next
		  Else
		    System.DebugLog("GetDecodedContents: ERROR - contentObj is neither stream nor array: " + Introspection.GetType(contentObj).Name)
		  End If

		  Return result
		End Function
	#tag EndMethod

	#tag Property, Flags = &h0
		pageDict As VNSPDFDictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		pageNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		width As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		height As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		resources As VNSPDFDictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		contents As VNSPDFType
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
			Name="pageNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="width"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="height"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
