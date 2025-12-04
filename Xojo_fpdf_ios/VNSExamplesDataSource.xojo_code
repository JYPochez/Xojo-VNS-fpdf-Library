#tag Class
Protected Class VNSExamplesDataSource
Implements iOSMobileTableDataSource
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize example titles
		  mExampleTitles.Add("Example 1: Simple Shapes")
		  mExampleTitles.Add("Example 2: Text Layouts")
		  mExampleTitles.Add("Example 3: Multiple Pages")
		  mExampleTitles.Add("Example 4: Line Widths")
		  mExampleTitles.Add("Example 5: UTF-8 & TrueType Fonts")
		  mExampleTitles.Add("Example 6: Text Measurement")
		  mExampleTitles.Add("Example 7: Document Metadata")
		  mExampleTitles.Add("Example 8: Error Handling")
		  mExampleTitles.Add("Example 9: Image Support (JPEG)")
		  mExampleTitles.Add("Example 10: Header/Footer Callbacks")
		  mExampleTitles.Add("Example 11: Links and Bookmarks")
		  mExampleTitles.Add("Example 12: Custom Page Formats")
		  mExampleTitles.Add("Example 13: PDF/A Compliance")
		  mExampleTitles.Add("Example 14: Document Encryption")
		  mExampleTitles.Add("Example 15: Watermark Header")
		  mExampleTitles.Add("Example 16: Formatting Features")
		  mExampleTitles.Add("Example 17: Utility Methods")
		  mExampleTitles.Add("Example 18: Plugin Architecture")
		  mExampleTitles.Add("Example 19: Table Generation")
		  mExampleTitles.Add("Example 20: PDF Import")
		  mExampleTitles.Add("Test Zlib: Premium Compression")
		  mExampleTitles.Add("Test AES: Premium Encryption")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowCount(table As iOSMobileTable, section As Integer) As Integer
		  // Return number of rows for the section
		  #Pragma Unused table
		  #Pragma Unused section
		  
		  Return mExampleTitles.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowData(table As iOSMobileTable, section As Integer, row As Integer) As MobileTableCellData
		  // Provide data for each cell
		  #Pragma Unused section
		  
		  If row >= 0 And row < mExampleTitles.Count Then
		    Dim cell As MobileTableCellData = table.CreateCell(mExampleTitles(row))
		    cell.AccessoryType = MobileTableCellData.AccessoryTypes.Disclosure
		    Return cell
		  Else
		    Return table.CreateCell("")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SectionCount(table As iOSMobileTable) As Integer
		  // Return total number of sections (just 1 for our examples)
		  #Pragma Unused table
		  
		  Return 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SectionTitle(table As iOSMobileTable, section As Integer) As String
		  // Return section title
		  #Pragma Unused table
		  #Pragma Unused section
		  
		  Return ""
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mExampleTitles() As String
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
