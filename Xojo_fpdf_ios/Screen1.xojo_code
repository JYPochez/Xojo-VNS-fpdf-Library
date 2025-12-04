#tag MobileScreen
Begin MobileScreen Screen1
   BackButtonCaption=   ""
   Compatibility   =   ""
   ControlCount    =   3
   Device = 7
   HasNavigationBar=   True
   LargeTitleDisplayMode=   2
   Left            =   0
   Orientation = 0
   ScaleFactor     =   0.0
   TabBarVisible   =   True
   TabIcon         =   0
   TintColor       =   
   Title           =   "Xojo FPDF Examples"
   Top             =   0
   Begin MobileSwitch SwitchDisplayPDF
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   SwitchDisplayPDF, 8, , 0, False, +1.00, 4, 1, 31, , True
      AutoLayout      =   SwitchDisplayPDF, 1, <Parent>, 1, False, +1.00, 4, 1, 20, , True
      AutoLayout      =   SwitchDisplayPDF, 2, <Parent>, 1, False, +1.00, 4, 1, 80, , True
      AutoLayout      =   SwitchDisplayPDF, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 10, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   31
      Left            =   20
      LockedInPosition=   False
      Scope           =   0
      TintColor       =   
      Top             =   75
      Value           =   True
      Visible         =   True
      Width           =   60
      _ClosingFired   =   False
   End
   Begin iOSMobileTable TableExamples
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowRefresh    =   False
      AllowSearch     =   False
      AutoLayout      =   TableExamples, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   TableExamples, 3, SwitchDisplayPDF, 4, False, +1.00, 4, 1, 10, , True
      AutoLayout      =   TableExamples, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   TableExamples, 4, txtOutput, 3, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      EditingEnabled  =   False
      EditingEnabled  =   False
      Enabled         =   True
      EstimatedRowHeight=   -1
      Format          =   0
      Height          =   546
      Left            =   0
      LockedInPosition=   False
      Scope           =   0
      SectionCount    =   0
      TintColor       =   
      Top             =   116
      Visible         =   True
      Width           =   375
      _ClosingFired   =   False
      _OpeningCompleted=   False
   End
   Begin MobileTextArea txtOutput
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   txtOutput, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtOutput, 4, <Parent>, 4, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtOutput, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtOutput, 8, , 0, False, +1.00, 4, 1, 150, , True
      BorderColor     =   
      BorderStyle     =   1
      Editable        =   False
      Height          =   150.0
      KeyboardType    =   0
      Left            =   0
      LockedInPosition=   False
      Scope           =   0
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c00000000
      TextFont        =   "System		12"
      TextSize        =   0
      Top             =   662
      Visible         =   True
      Width           =   375.0
   End
   Begin MobileLabel Label1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AutoLayout      =   Label1, 1, SwitchDisplayPDF, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   Label1, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   Label1, 8, , 0, False, +1.00, 4, 1, 30, , True
      AutoLayout      =   Label1, 4, SwitchDisplayPDF, 4, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   30
      Left            =   88
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   0
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Display Generated PDF"
      TextColor       =   &c000000
      TextFont        =   "System Bold		"
      TextSize        =   0
      TintColor       =   
      Top             =   76
      Visible         =   True
      Width           =   267
      _ClosingFired   =   False
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  // Create and assign the DataSource
		  mDataSource = New VNSExamplesDataSource
		  TableExamples.DataSource = mDataSource
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h21
		Private mDataSource As VNSExamplesDataSource
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedPDFPath As String
	#tag EndProperty


	#tag Method, Flags = &h21
		Private Function FindPDFInDocuments() As String
		  // Look for PDF files in Documents folder and return path to first one found
		  // iOS Note: Users must place PDF files in Documents folder via Finder (enable File Sharing)

		  Dim docsFolder As FolderItem = SpecialFolder.Documents

		  // Look for specific filename first: "import.pdf"
		  Dim importFile As FolderItem = docsFolder.Child("import.pdf")
		  If importFile <> Nil And importFile.Exists Then
		    Return importFile.NativePath
		  End If

		  // Search for any PDF file in Documents folder
		  Dim pdfFiles() As String
		  For Each item As FolderItem In docsFolder.Children
		    If item <> Nil And Not item.IsFolder Then
		      Dim fileName As String = item.Name
		      // Check if file ends with .pdf (case insensitive)
		      If fileName.Length > 4 Then
		        Dim ext As String = fileName.Right(4).Lowercase
		        If ext = ".pdf" Then
		          pdfFiles.Add(item.NativePath)
		        End If
		      End If
		    End If
		  Next

		  // Return first PDF found, or empty string if none
		  If pdfFiles.Count > 0 Then
		    Return pdfFiles(0)
		  Else
		    Return ""
		  End If

		End Function
	#tag EndMethod


#tag EndWindowCode

#tag Events TableExamples
	#tag Event
		Sub SelectionChanged(section As Integer, row As Integer)
		  #Pragma Unused section
		  
		  // Call appropriate GenerateExampleN() based on row (row is 0-based)
		  Dim exampleNumber As Integer = row + 1
		  Dim result As Dictionary
		  
		  Select Case exampleNumber
		  Case kExample1
		    result = VNSPDFExamplesModule.GenerateExample1()
		  Case kExample2
		    result = VNSPDFExamplesModule.GenerateExample2()
		  Case kExample3
		    result = VNSPDFExamplesModule.GenerateExample3()
		  Case kExample4
		    result = VNSPDFExamplesModule.GenerateExample4()
		  Case kExample5
		    result = VNSPDFExamplesModule.GenerateExample5()
		  Case kExample6
		    result = VNSPDFExamplesModule.GenerateExample6()
		  Case kExample7
		    result = VNSPDFExamplesModule.GenerateExample7()
		  Case kExample8
		    result = VNSPDFExamplesModule.GenerateExample8()
		  Case kExample9
		    result = VNSPDFExamplesModule.GenerateExample9()
		  Case kExample10
		    result = VNSPDFExamplesModule.GenerateExample10()
		  Case kExample11
		    result = VNSPDFExamplesModule.GenerateExample11()
		  Case kExample12
		    result = VNSPDFExamplesModule.GenerateExample12()
		  Case kExample13
		    result = VNSPDFExamplesModule.GenerateExample13()
		  Case kExample14
		    // Use RC4-40 (revision 2) which is available in FREE version
		    result = VNSPDFExamplesModule.GenerateExample14(VNSPDFModule.gkEncryptionRC4_40, "user123", "owner456", True, True, True, True, True, True, True, True)
		  Case kExample15
		    result = VNSPDFExamplesModule.GenerateExample15()
		  Case kExample16
		    result = VNSPDFExamplesModule.GenerateExample16()
		  Case kExample17
		    result = VNSPDFExamplesModule.GenerateExample17()
		  Case kExample18
		    result = VNSPDFExamplesModule.GenerateExample18()
		  Case kExample19
		    result = VNSPDFExamplesModule.GenerateExample19()
		  Case kExample20
		    // Example 20: PDF Import - look for PDF in Documents folder
		    Dim sourcePath As String = FindPDFInDocuments()
		    If sourcePath = "" Then
		      // No PDF found - show instructions
		      Dim msg As String = "No PDF files found in Documents folder." + EndOfLine + EndOfLine
		      msg = msg + "To use Example 20 (PDF Import):" + EndOfLine
		      msg = msg + "1. Enable File Sharing in Build Settings" + EndOfLine
		      msg = msg + "2. Deploy app to device" + EndOfLine
		      msg = msg + "3. Connect device via USB" + EndOfLine
		      msg = msg + "4. Open Finder and select device" + EndOfLine
		      msg = msg + "5. Click Files button, find this app" + EndOfLine
		      msg = msg + "6. Add a PDF file (name it 'import.pdf' or any .pdf)"
		      txtOutput.Text = msg.ToText
		      Return
		    End If

		    // Show which source PDF is being used
		    Dim sourceFile As FolderItem = New FolderItem(sourcePath, FolderItem.PathModes.Native)
		    Dim sourceInfo As String = "Using source PDF: " + sourceFile.Name + EndOfLine + EndOfLine

		    result = VNSPDFExamplesModule.GenerateExample20(sourcePath)

		    // Prepend source info to status message
		    If result <> Nil And result.HasKey("status") Then
		      result.Value("status") = sourceInfo + result.Value("status")
		    End If
		  Case kTestZlib
		    // Test Zlib - special test, not a PDF example
		    result = VNSPDFExamplesModule.TestZlib()
		  Case kTestAES
		    // Test AES - special test, not a PDF example
		    result = VNSPDFExamplesModule.TestAES()
		  End Select

		  // Build output message
		  Dim msg As String

		  // Handle test results (different format than PDF examples)
		  If exampleNumber >= 21 Then
		    // TestZlib and TestAES return "passed" (Boolean) and "output" (String)
		    If result = Nil Then
		      msg = "ERROR: Test returned Nil" + EndOfLine
		    Else
		      Dim passed As Boolean = result.Value("passed")
		      Dim output As String = result.Value("output")
		      msg = output
		      If passed Then
		        msg = msg + EndOfLine + "ALL TESTS PASSED!" + EndOfLine
		      Else
		        msg = msg + EndOfLine + "SOME TESTS FAILED!" + EndOfLine
		      End If
		    End If
		    // MobileTextArea.Text accepts String directly
		    txtOutput.Text = msg
		    Return
		  End If
		  
		  // Check if result is nil
		  If result = Nil Then
		    msg = "ERROR: Example " + Str(exampleNumber) + " returned Nil" + EndOfLine
		  ElseIf Not result.HasKey("status") Then
		    msg = "ERROR: Result has no 'status' key" + EndOfLine
		  Else
		    msg = result.Value("status")
		    
		    // Check if there's an error in the result
		    If result.HasKey("error") Then
		      msg = msg + "ERROR: " + result.Value("error") + EndOfLine
		    End If
		  End If
		  
		  // Save PDF if successful
		  Dim pdfFile As FolderItem
		  If result <> Nil And result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    
		    // Check if PDF data is empty
		    #If TargetiOS Then
		      Dim pdfSize As Integer = VNSPDFModule.StringLenB(pdfData)
		    #Else
		      Dim pdfSize As Integer = pdfData.LenB
		    #EndIf
		    
		    If pdfSize = 0 Then
		      msg = msg + "WARNING: PDF data is empty (0 bytes)!" + EndOfLine
		    End If
		    
		    Try
		      // Save to Documents folder on iOS
		      Dim docsFolder As FolderItem = SpecialFolder.Documents
		      pdfFile = docsFolder.Child(filename)
		      
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      
		      msg = msg + "PDF saved: " + pdfFile.NativePath + EndOfLine
		      msg = msg + "File size: " + Str(pdfSize) + " bytes" + EndOfLine
		      
		      // Display PDF if switch is ON
		      If SwitchDisplayPDF.Value Then
		        Dim pdfScreen As New PDFViewerScreen
		        pdfScreen.PDFFile = pdfFile
		        pdfScreen.Title = "Example " + Str(exampleNumber)
		        pdfScreen.Show(Self)
		      End If
		      
		    Catch e As IOException
		      msg = msg + "Error saving file: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  msg = msg + EndOfLine

		  // MobileTextArea.Text accepts String directly
		  txtOutput.Text = msg
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Constants
	#tag Constant, Name = kExample1, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample2, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample3, Type = Double, Dynamic = False, Default = \"3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample4, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample5, Type = Double, Dynamic = False, Default = \"5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample6, Type = Double, Dynamic = False, Default = \"6", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample7, Type = Double, Dynamic = False, Default = \"7", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample8, Type = Double, Dynamic = False, Default = \"8", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample9, Type = Double, Dynamic = False, Default = \"9", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample10, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample11, Type = Double, Dynamic = False, Default = \"11", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample12, Type = Double, Dynamic = False, Default = \"12", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample13, Type = Double, Dynamic = False, Default = \"13", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample14, Type = Double, Dynamic = False, Default = \"14", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample15, Type = Double, Dynamic = False, Default = \"15", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample16, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample17, Type = Double, Dynamic = False, Default = \"17", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample18, Type = Double, Dynamic = False, Default = \"18", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample19, Type = Double, Dynamic = False, Default = \"19", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExample20, Type = Double, Dynamic = False, Default = \"20", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTestZlib, Type = Double, Dynamic = False, Default = \"21", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTestAES, Type = Double, Dynamic = False, Default = \"22", Scope = Private
	#tag EndConstant

#tag EndConstants
#tag ViewBehavior
	#tag ViewProperty
		Name="Index"
		Visible=true
		Group="ID"
		InitialValue="-2147483648"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
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
		Name="BackButtonCaption"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasNavigationBar"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIcon"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Behavior"
		InitialValue="Untitled"
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LargeTitleDisplayMode"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="MobileScreen.LargeTitleDisplayModes"
		EditorType="Enum"
		#tag EnumValues
			"0 - Automatic"
			"1 - Always"
			"2 - Never"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabBarVisible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TintColor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="ColorGroup"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ScaleFactor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Double"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
