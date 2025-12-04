#tag Class
Protected Class VNSPDFReader
	#tag Method, Flags = &h0
		Function OpenFile(filePath As String) As Boolean
		  // Open a PDF file for reading
		  mError = ""

		  Dim file As FolderItem = New FolderItem(filePath, FolderItem.PathModes.Native)
		  If Not file.Exists Then
		    mError = "File does not exist: " + filePath
		    Return False
		  End If

		  mReader = New VNSPDFStreamReader(file)

		  // Parse cross-reference table
		  Dim xrefReader As New VNSPDFXrefReader
		  mXref = xrefReader.Parse(mReader)
		  If mXref = Nil Then
		    mError = "Failed to parse cross-reference table"
		    Return False
		  End If

		  // Get catalog from trailer
		  If mXref.trailer = Nil Then
		    mError = "Cross-reference table has no trailer"
		    Return False
		  End If

		  Dim trailerDict As Dictionary = mXref.trailer.value

		  // Debug: List all keys in trailer dictionary
		  Dim keys() As Variant = trailerDict.Keys
		  Dim keyList As String = ""
		  For i As Integer = 0 To keys.LastIndex
		    If keyList <> "" Then keyList = keyList + " | "
		    Dim keyStr As String = keys(i).StringValue
		    keyList = keyList + "[" + Str(i) + "]='" + keyStr + "'(len=" + Str(keyStr.Length) + ")"
		  Next

		  // Try both "Root" and "/Root" key formats
		  Dim rootKey As String = ""
		  If trailerDict.HasKey("Root") Then
		    rootKey = "Root"
		  ElseIf trailerDict.HasKey("/Root") Then
		    rootKey = "/Root"
		  Else
		    mError = "Trailer dictionary missing /Root entry. Found keys: " + keyList + " (count=" + Str(keys.Count) + ")"
		    Return False
		  End If

		  // Root is an indirect reference to the catalog
		  Dim rootRef As VNSPDFType = trailerDict.Value(rootKey)
		  If Not (rootRef IsA VNSPDFIndirectObjectReference) Then
		    mError = "Trailer /Root is not an indirect reference"
		    Return False
		  End If

		  // Parse catalog object
		  Dim catalogRef As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(rootRef)
		  Dim catalogOffset As Int64 = mXref.GetObjectOffset(catalogRef.objectNumber)
		  If catalogOffset = -1 Then
		    mError = "Cannot find catalog object offset in xref table"
		    Return False
		  End If

		  Dim parser As New VNSPDFParser
		  parser.SetPDFReader(Self)  // Enable indirect reference resolution for stream Length
		  Dim catalogObj As VNSPDFType = parser.ParseIndirectObject(mReader, catalogOffset)
		  If Not (catalogObj IsA VNSPDFDictionary) Then
		    mError = "Catalog object is not a dictionary"
		    Return False
		  End If

		  mCatalog = VNSPDFDictionary(catalogObj)

		  // Build complete page list in visual order
		  // Get Pages dictionary from catalog
		  Dim catalogDict As Dictionary = mCatalog.value
		  If catalogDict.HasKey("Pages") Then
		    Dim pagesRef As VNSPDFType = catalogDict.Value("Pages")
		    If pagesRef IsA VNSPDFIndirectObjectReference Then
		      // Parse Pages object
		      Dim pagesRefObj As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(pagesRef)
		      Dim pagesOffset As Int64 = mXref.GetObjectOffset(pagesRefObj.objectNumber)
		      If pagesOffset <> -1 Then
		        Dim pagesObj As VNSPDFType = parser.ParseIndirectObject(mReader, pagesOffset)
		        If pagesObj IsA VNSPDFDictionary Then
		          // Build the page list
		          BuildPageList(VNSPDFDictionary(pagesObj))
		        End If
		      End If
		    End If
		  End If

		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetError() As String
		  // Get last error message
		  Return mError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetObject(objectNumber As Integer) As VNSPDFType
		  // Get a PDF object by its object number
		  // objectNumber: The object number to retrieve
		  // Returns: The parsed PDF object, or Nil if not found

		  // Get offset from cross-reference table
		  Dim offset As Int64 = mXref.GetObjectOffset(objectNumber)
		  If offset = -1 Then
		    Return Nil
		  End If

		  // Parse the object at this offset
		  Dim parser As New VNSPDFParser
		  parser.SetPDFReader(Self)  // Enable indirect reference resolution for stream Length
		  Dim obj As VNSPDFType = parser.ParseIndirectObject(mReader, offset)

		  Return obj
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPageCount() As Integer
		  // Get the number of pages in the PDF
		  // Returns the count from the pre-built page list

		  Return mPageList.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPage(pageNum As Integer) As VNSPDFImportedPage
		  // Get a specific page (1-based) from the pre-built page list
		  // This ensures pages are returned in visual order

		  // Validate page number
		  If pageNum < 1 Or pageNum > mPageList.Count Then
		    System.DebugLog("GetPage: ERROR - Page number out of range!")
		    Return Nil
		  End If

		  // Get page dictionary from list (convert 1-based to 0-based index)
		  Dim pageDict As VNSPDFDictionary = mPageList(pageNum - 1)
		  If pageDict = Nil Then
		    System.DebugLog("GetPage: ERROR - Page dictionary is Nil!")
		    Return Nil
		  End If

		  // Create VNSPDFImportedPage object
		  Dim page As New VNSPDFImportedPage
		  page.pageDict = pageDict
		  page.pageNumber = pageNum

		  // Extract page properties
		  Dim dict As Dictionary = pageDict.value

		  // Get MediaBox for page dimensions
		  If dict.HasKey("MediaBox") Then
		    Dim mediaBox As VNSPDFType = dict.Value("MediaBox")
		    If mediaBox IsA VNSPDFArray Then
		      Dim boxArray As VNSPDFArray = VNSPDFArray(mediaBox)
		      Dim boxValues() As VNSPDFType = boxArray.value
		      If boxValues.Count >= 4 Then
		        Dim x1, y1, x2, y2 As Double
		        If boxValues(0) IsA VNSPDFNumeric Then x1 = VNSPDFNumeric(boxValues(0)).value
		        If boxValues(1) IsA VNSPDFNumeric Then y1 = VNSPDFNumeric(boxValues(1)).value
		        If boxValues(2) IsA VNSPDFNumeric Then x2 = VNSPDFNumeric(boxValues(2)).value
		        If boxValues(3) IsA VNSPDFNumeric Then y2 = VNSPDFNumeric(boxValues(3)).value
		        page.width = x2 - x1
		        page.height = y2 - y1
		      End If
		    End If
		  End If

		  // Get Resources
		  If dict.HasKey("Resources") Then
		    Dim resourcesObj As VNSPDFType = dict.Value("Resources")
		    If resourcesObj IsA VNSPDFDictionary Then
		      page.resources = VNSPDFDictionary(resourcesObj)
		    ElseIf resourcesObj IsA VNSPDFIndirectObjectReference Then
		      // Resolve indirect reference
		      Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(resourcesObj)
		      Dim offset As Int64 = mXref.GetObjectOffset(ref.objectNumber)
		      If offset <> -1 Then
		        Dim parser As New VNSPDFParser
		        Dim resObj As VNSPDFType = parser.ParseIndirectObject(mReader, offset)
		        If resObj IsA VNSPDFDictionary Then
		          page.resources = VNSPDFDictionary(resObj)
		        End If
		      End If
		    End If
		  End If

		  // Get Contents
		  If dict.HasKey("Contents") Then
		    page.contents = dict.Value("Contents")
		  End If

		  Return page
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindPageInTree(pagesDict As VNSPDFDictionary, pageNum As Integer, inheritedMediaBox As VNSPDFArray = Nil) As VNSPDFDictionary
		  // Navigate the page tree to find a specific page
		  // PDF page tree is hierarchical - Pages nodes contain Kids arrays
		  // inheritedMediaBox: MediaBox from parent Pages node (inherited if page doesn't have one)

		  Dim dict As Dictionary = pagesDict.value

		  // Check if this Pages/Page node has its own MediaBox
		  Dim currentMediaBox As VNSPDFArray = inheritedMediaBox
		  If dict.HasKey("MediaBox") Then
		    Dim mediaBoxObj As VNSPDFType = dict.Value("MediaBox")
		    If mediaBoxObj IsA VNSPDFArray Then
		      currentMediaBox = VNSPDFArray(mediaBoxObj)
		    End If
		  End If

		  // Check if this is a Page leaf node
		  If dict.HasKey("Type") Then
		    Dim typeObj As VNSPDFType = dict.Value("Type")
		    If typeObj IsA VNSPDFName Then
		      Dim typeName As String = VNSPDFName(typeObj).value
		      If typeName = "Page" Then
		        // This is a page leaf - check if it's the one we want
		        // For now, we'll assume linear traversal
		        mCurrentPageIndex = mCurrentPageIndex + 1
		        If mCurrentPageIndex = pageNum Then
		          // If this page doesn't have MediaBox, inherit from parent
		          If Not dict.HasKey("MediaBox") And currentMediaBox <> Nil Then
		            dict.Value("MediaBox") = currentMediaBox
		          End If
		          Return pagesDict
		        Else
		          Return Nil
		        End If
		      End If
		    End If
		  End If

		  // This is a Pages intermediate node - traverse Kids
		  If Not dict.HasKey("Kids") Then
		    Return Nil
		  End If

		  Dim kidsObj As VNSPDFType = dict.Value("Kids")
		  If Not (kidsObj IsA VNSPDFArray) Then
		    Return Nil
		  End If

		  Dim kidsArray As VNSPDFArray = VNSPDFArray(kidsObj)
		  Dim kids() As VNSPDFType = kidsArray.value

		  Dim parser As New VNSPDFParser

		  For i As Integer = 0 To kids.LastIndex
		    Dim kidRef As VNSPDFType = kids(i)
		    If kidRef IsA VNSPDFIndirectObjectReference Then
		      Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(kidRef)
		      Dim offset As Int64 = mXref.GetObjectOffset(ref.objectNumber)
		      If offset <> -1 Then
		        Dim kidObj As VNSPDFType = parser.ParseIndirectObject(mReader, offset)
		        If kidObj IsA VNSPDFDictionary Then
		          Dim result As VNSPDFDictionary = FindPageInTree(VNSPDFDictionary(kidObj), pageNum, currentMediaBox)
		          If result <> Nil Then
		            Return result
		          End If
		        End If
		      End If
		    End If
		  Next

		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetPageIndex()
		  // Reset page traversal counter
		  mCurrentPageIndex = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BuildPageList(pagesDict As VNSPDFDictionary, inheritedMediaBox As VNSPDFArray = Nil)
		  // Build a complete list of all pages in visual (tree) order
		  // This is called once during OpenFile() to build mPageList()

		  Dim dict As Dictionary = pagesDict.value

		  // Check if this Pages/Page node has its own MediaBox
		  Dim currentMediaBox As VNSPDFArray = inheritedMediaBox
		  If dict.HasKey("MediaBox") Then
		    Dim mediaBoxObj As VNSPDFType = dict.Value("MediaBox")
		    If mediaBoxObj IsA VNSPDFArray Then
		      currentMediaBox = VNSPDFArray(mediaBoxObj)
		    End If
		  End If

		  // Check if this is a Page leaf node
		  If dict.HasKey("Type") Then
		    Dim typeObj As VNSPDFType = dict.Value("Type")
		    If typeObj IsA VNSPDFName Then
		      Dim typeName As String = VNSPDFName(typeObj).value
		      If typeName = "Page" Then
		        // This is a page leaf - add it to our list
		        // If this page doesn't have MediaBox, inherit from parent
		        If Not dict.HasKey("MediaBox") And currentMediaBox <> Nil Then
		          dict.Value("MediaBox") = currentMediaBox
		        End If
		        Dim pageIndex As Integer = mPageList.Count + 1

		        // DEBUG: Try to extract first text content to identify this page
		        Dim pageID As String = "Page " + Str(pageIndex)
		        Try
		          If dict.HasKey("Contents") Then
		            Dim contentsObj As VNSPDFType = dict.Value("Contents")
		            If contentsObj IsA VNSPDFIndirectObjectReference Then
		              Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(contentsObj)
		              pageID = pageID + " (Contents Obj #" + Str(ref.objectNumber) + ")"
		            End If
		          End If
		        Catch
		        End Try

		        mPageList.Add(pagesDict)
		        Return
		      End If
		    End If
		  End If

		  // This is a Pages intermediate node - traverse Kids
		  If Not dict.HasKey("Kids") Then
		    Return
		  End If

		  Dim kidsObj As VNSPDFType = dict.Value("Kids")
		  If Not (kidsObj IsA VNSPDFArray) Then
		    Return
		  End If

		  Dim kidsArray As VNSPDFArray = VNSPDFArray(kidsObj)
		  Dim kids() As VNSPDFType = kidsArray.value

		  Dim parser As New VNSPDFParser

		  For i As Integer = 0 To kids.LastIndex
		    Dim kidRef As VNSPDFType = kids(i)
		    If kidRef IsA VNSPDFIndirectObjectReference Then
		      Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(kidRef)
		      Dim offset As Int64 = mXref.GetObjectOffset(ref.objectNumber)
		      If offset <> -1 Then
		        Dim kidObj As VNSPDFType = parser.ParseIndirectObject(mReader, offset)
		        If kidObj IsA VNSPDFDictionary Then
		          BuildPageList(VNSPDFDictionary(kidObj), currentMediaBox)
		        End If
		      End If
		    End If
		  Next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mReader As VNSPDFStreamReader
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mXref As VNSPDFCrossReference
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCatalog As VNSPDFDictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentPageIndex As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mError As String = ""
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageList() As VNSPDFDictionary
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
