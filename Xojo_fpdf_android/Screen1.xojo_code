#tag MobileScreen
Begin MobileScreen Screen1
   BackgroundColor =   
   Compatibility   =   ""
   Device          =   1
   HasBackButton   =   False
   HasNavigationBar=   True
   Modal           =   False
   NavigationBarColor=   
   NavigationBarTextColor=   
   Orientation     =   0
   SupportedOrientation=   0
   Title           =   "#kScreenTitle"
   Begin MobileSwitch SwitchOpenPDF
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Enabled         =   True
      Height          =   30
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      ThumbColor      =   
      TintColor       =   
      Top             =   20
      Value           =   True
      Visible         =   True
      Width           =   52
   End
   Begin MobileLabel LabelOpenPDF
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AdjustTextSizeToFit=   False
      Alignment       =   0
      Enabled         =   True
      Height          =   30
      Left            =   80
      LineBreakMode   =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Scope           =   2
      Text            =   "#kOpenPDFLabel"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      Top             =   20
      Visible         =   True
      Width           =   260
   End
   Begin AndroidMobileTable TableExamples
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Enabled         =   True
      HasHeader       =   False
      Header          =   ""
      Height          =   330
      InitialValue    =   ""
      LastAddedRowIndex=   0
      LastRowIndex    =   0
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RowCount        =   0
      Scope           =   2
      ScrollPosition  =   0
      SelectedRowIndex=   -1
      SelectedRowText =   ""
      SeparatorColor  =   &c000000
      SeparatorThickness=   0
      Top             =   60
      Visible         =   True
      Width           =   320
   End
   Begin MobileTextArea TextOutput
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AllowSpellChecking=   False
      BorderStyle     =   2
      Enabled         =   True
      Height          =   200
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      ReadOnly        =   True
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   ""
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   
      Top             =   400
      Visible         =   True
      Width           =   320
   End
   Begin MobileSharingPanel SharingPanelPDF
      Height          =   32
      Left            =   100
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Scope           =   2
      Top             =   110
      Width           =   32
   End
End
#tag EndMobileScreen

#tag ScreenCode
	#tag Method, Flags = &h21
		Private Function FindPDFInDocuments() As FolderItem
		  // Example 20 source: "import.pdf" in Documents, otherwise the first .pdf found there
		  Var docsFolder As FolderItem = SpecialFolder.Documents
		  Var importFile As FolderItem = docsFolder.Child(kImportFileName)
		  If importFile <> Nil Then
		    If importFile.Exists Then Return importFile
		  End If
		  For Each item As FolderItem In docsFolder.Children
		    If item <> Nil Then
		      If Not item.IsFolder And item.Name.Lowercase.EndsWith(kPDFExtension) Then Return item
		    End If
		  Next
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GenerateExampleResult(exampleNumber As Integer) As Dictionary
		  // Same dispatch as the iOS demo app (Xojo_fpdf_ios/Screen1)
		  Select Case exampleNumber
		  Case VNSPDFExamplesModule.kExample1
		    Return VNSPDFExamplesModule.GenerateExample1()
		  Case VNSPDFExamplesModule.kExample2
		    Return VNSPDFExamplesModule.GenerateExample2()
		  Case VNSPDFExamplesModule.kExample3
		    Return VNSPDFExamplesModule.GenerateExample3()
		  Case VNSPDFExamplesModule.kExample4
		    Return VNSPDFExamplesModule.GenerateExample4()
		  Case VNSPDFExamplesModule.kExample5
		    Return VNSPDFExamplesModule.GenerateExample5()
		  Case VNSPDFExamplesModule.kExample6
		    Return VNSPDFExamplesModule.GenerateExample6()
		  Case VNSPDFExamplesModule.kExample7
		    Return VNSPDFExamplesModule.GenerateExample7()
		  Case VNSPDFExamplesModule.kExample8
		    Return VNSPDFExamplesModule.GenerateExample8()
		  Case VNSPDFExamplesModule.kExample9
		    Return VNSPDFExamplesModule.GenerateExample9()
		  Case VNSPDFExamplesModule.kExample10
		    Return VNSPDFExamplesModule.GenerateExample10()
		  Case VNSPDFExamplesModule.kExample11
		    Return VNSPDFExamplesModule.GenerateExample11()
		  Case VNSPDFExamplesModule.kExample12
		    Return VNSPDFExamplesModule.GenerateExample12()
		  Case VNSPDFExamplesModule.kExample13
		    Return VNSPDFExamplesModule.GenerateExample13()
		  Case VNSPDFExamplesModule.kExample14
		    // RC4-40 (revision 2) is available in the free version
		    Return VNSPDFExamplesModule.GenerateExample14(VNSPDFModule.gkEncryptionRC4_40, kUserPassword, kOwnerPassword, True, True, True, True, True, True, True, True)
		  Case VNSPDFExamplesModule.kExample15
		    Return VNSPDFExamplesModule.GenerateExample15()
		  Case VNSPDFExamplesModule.kExample16
		    Return VNSPDFExamplesModule.GenerateExample16()
		  Case VNSPDFExamplesModule.kExample17
		    Return VNSPDFExamplesModule.GenerateExample17()
		  Case VNSPDFExamplesModule.kExample18
		    Return VNSPDFExamplesModule.GenerateExample18()
		  Case VNSPDFExamplesModule.kExample19
		    Return VNSPDFExamplesModule.GenerateExample19()
		  Case VNSPDFExamplesModule.kExample20
		    Return GenerateImportExample()
		  Case VNSPDFExamplesModule.kExample21
		    Return VNSPDFExamplesModule.GenerateExample21()
		  Case VNSPDFExamplesModule.kExample22
		    Return VNSPDFExamplesModule.GenerateExample22()
		  Case VNSPDFExamplesModule.kExample23
		    Return VNSPDFExamplesModule.GenerateExample23()
		  Case VNSPDFExamplesModule.kExample24
		    Return VNSPDFExamplesModule.GenerateExample24()
		  Case VNSPDFExamplesModule.kExample26
		    Return VNSPDFExamplesModule.GenerateExample26_BugTests()
		  Case VNSPDFExamplesModule.kExample27
		    Return VNSPDFExamplesModule.GenerateExample27_HTMLImport(kSampleHTML)
		  Case VNSPDFExamplesModule.kExample28
		    Return VNSPDFExamplesModule.GenerateExample28_MarkdownImport(kSampleMarkdown)
		  Case VNSPDFExamplesModule.kExample29
		    Return VNSPDFExamplesModule.GenerateExample29()
		  Case VNSPDFExamplesModule.kExample30
		    Return VNSPDFExamplesModule.GenerateExample30(kCountryCode)
		  Case VNSPDFExamplesModule.kExample31
		    Return VNSPDFExamplesModule.GenerateExample31_CheckEInvoice(ReadDocumentFile(kEInvoiceFileName))
		  Case VNSPDFExamplesModule.kExample32
		    Return VNSPDFExamplesModule.GenerateExample32(kCountryCode)
		  Case VNSPDFExamplesModule.kExample33
		    Return VNSPDFExamplesModule.GenerateExample33_Barcodes()
		  Case VNSPDFExamplesModule.kTestZlib
		    Return VNSPDFExamplesModule.TestZlib()
		  Case VNSPDFExamplesModule.kTestAES
		    Return VNSPDFExamplesModule.TestAES()
		  End Select
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GenerateImportExample() As Dictionary
		  // Example 20 (PDF Import) needs a source PDF in the app Documents folder
		  Var sourceFile As FolderItem = FindPDFInDocuments()
		  If sourceFile = Nil Then
		    Var info As New Dictionary
		    info.Value(kKeyMessage) = kMsgNoImportPDF + SpecialFolder.Documents.NativePath
		    Return info
		  End If
		  Var result As Dictionary = VNSPDFExamplesModule.GenerateExample20(sourceFile.NativePath)
		  If result <> Nil Then
		    If result.HasKey(kKeyMessage) Then
		      result.Value(kKeyMessage) = kMsgUsingSource + sourceFile.Name + EndOfLine + EndOfLine + result.Value(kKeyMessage).StringValue
		    End If
		  End If
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PopulateExamples()
		  // One row per example; the row tag holds the example constant used by the dispatcher
		  Var exampleTitles() As String = kExampleTitles.Split(&u0A)
		  Var exampleCodes() As Integer
		  exampleCodes.Add(VNSPDFExamplesModule.kExample1)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample2)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample3)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample4)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample5)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample6)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample7)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample8)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample9)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample10)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample11)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample12)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample13)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample14)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample15)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample16)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample17)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample18)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample19)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample20)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample21)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample22)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample23)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample24)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample26)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample27)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample28)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample29)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample30)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample31)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample32)
		  exampleCodes.Add(VNSPDFExamplesModule.kExample33)
		  exampleCodes.Add(VNSPDFExamplesModule.kTestZlib)
		  exampleCodes.Add(VNSPDFExamplesModule.kTestAES)
		  TableExamples.RemoveAllRows
		  For i As Integer = 0 To exampleTitles.LastIndex
		    TableExamples.AddRow(exampleTitles(i))
		    TableExamples.RowTagAt(TableExamples.LastAddedRowIndex) = exampleCodes(i)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReadDocumentFile(fileName As String) As String
		  // Contents of a file in the app Documents folder, or "" if it does not exist
		  Var docFile As FolderItem = SpecialFolder.Documents.Child(fileName)
		  If docFile = Nil Then Return ""
		  If Not docFile.Exists Then Return ""
		  Var stream As BinaryStream = BinaryStream.Open(docFile)
		  Var data As String = stream.Read(stream.Length)
		  stream.Close
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunExample(exampleNumber As Integer)
		  Var result As Dictionary = GenerateExampleResult(exampleNumber)
		  If exampleNumber = VNSPDFExamplesModule.kTestZlib Or exampleNumber = VNSPDFExamplesModule.kTestAES Then
		    TextOutput.Text = TestReport(result)
		    Return
		  End If
		  
		  Var msg As String
		  If result = Nil Then
		    ShowOutput(kMsgExampleNil.ReplaceAll(kPlaceholder, exampleNumber.ToString) + EndOfLine)
		    Return
		  End If
		  If Not result.HasKey(kKeyMessage) Then
		    msg = kMsgNoMessage + EndOfLine
		  Else
		    msg = result.Value(kKeyMessage).StringValue
		  End If
		  If result.HasKey(kKeyError) Then
		    msg = msg + kMsgErrorPrefix + result.Value(kKeyError).StringValue + EndOfLine
		  End If
		  
		  Var pdfFile As FolderItem
		  If result.HasKey(kKeyPDF) Then
		    pdfFile = SaveResultFile(result.Value(kKeyPDF).StringValue, result.Value(kKeyFilename).StringValue, kMsgPDFSaved, kMsgSaveError, msg)
		  End If
		  If result.HasKey(kKeyPDF2) Then
		    Call SaveResultFile(result.Value(kKeyPDF2).StringValue, result.Value(kKeyFilename2).StringValue, kMsgCreditSaved, kMsgCreditSaveError, msg)
		  End If
		  ShowOutput(msg + EndOfLine)
		  
		  // Android has no in-app PDF viewer: the sharing panel offers "Open with" any PDF app
		  If pdfFile <> Nil And SwitchOpenPDF.Value Then
		    SharingPanelPDF.ShareFile(pdfFile, Self)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SaveResultFile(data As String, fileName As String, savedLabel As String, errorLabel As String, ByRef msg As String) As FolderItem
		  // Writes one generated file to the app Documents folder and appends the outcome to msg
		  If data.Bytes = 0 Then msg = msg + kMsgEmptyPDF + EndOfLine
		  Try
		    Var outFile As FolderItem = SpecialFolder.Documents.Child(fileName)
		    Var stream As BinaryStream = BinaryStream.Create(outFile, True)
		    stream.Write(data)
		    stream.Close
		    msg = msg + savedLabel + outFile.NativePath + EndOfLine
		    msg = msg + kMsgFileSize.ReplaceAll(kPlaceholder, data.Bytes.ToString) + EndOfLine
		    Return outFile
		  Catch e As IOException
		    msg = msg + errorLabel + e.Message + EndOfLine
		  End Try
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ShowOutput(msg As String)
		  TextOutput.Text = msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestReport(result As Dictionary) As String
		  // TestZlib / TestAES return "passed" (Boolean) and "output" (String) instead of a PDF
		  If result = Nil Then Return kMsgTestNil + EndOfLine
		  Var report As String = result.Value(kKeyOutput).StringValue + EndOfLine
		  If result.Value(kKeyPassed).BooleanValue Then
		    report = report + kMsgTestsPassed + EndOfLine
		  Else
		    report = report + kMsgTestsFailed + EndOfLine
		  End If
		  Return report
		End Function
	#tag EndMethod


	#tag Constant, Name = kScreenTitle, Type = String, Dynamic = False, Default = \"Xojo FPDF Examples", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOpenPDFLabel, Type = String, Dynamic = False, Default = \"Open PDF after generating", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleTitles, Type = String, Dynamic = False, Default = \"Example 1: Simple Shapes\nExample 2: Text Layouts\nExample 3: Multiple Pages\nExample 4: Line Widths\nExample 5: UTF-8 & TrueType Fonts\nExample 6: Text Measurement\nExample 7: Document Metadata\nExample 8: Error Handling\nExample 9: Image Support (JPEG)\nExample 10: Header/Footer Callbacks\nExample 11: Links and Bookmarks\nExample 12: Custom Page Formats\nExample 13: PDF/A Compliance\nExample 14: Document Encryption\nExample 15: Watermark Header\nExample 16: Formatting Features\nExample 17: Utility Methods\nExample 18: Plugin Architecture\nExample 19: Table Generation\nExample 20: PDF Import\nExample 21: UTF-8 All Languages\nExample 22: UTF Compatibility Wrapper\nExample 23: File Attachments\nExample 24: PDF Forms (Premium)\nExample 26: Bug Tests\nExample 27: HTML Import (Premium)\nExample 28: Markdown Import (Premium)\nExample 29: GraphicsPath\nExample 30: E-Invoice (Premium)\nExample 31: E-Invoice Checker (Premium)\nExample 32: Digital Signatures (Premium)\nExample 33: Barcodes\nTest Zlib: Premium Compression\nTest AES: Premium Encryption", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSampleHTML, Type = String, Dynamic = False, Default = \"<h1>HTML Import Test</h1><p>This is a <b>bold</b> and <i>italic</i> test from Android.</p><h2>Features</h2><ul><li>Headings</li><li>Bold and italic</li><li>Lists</li><li>Links</li></ul><p>Visit <a href\x3D\"https://www.verynicesw.fr\">VeryNiceSW</a> for more info.</p><table border\x3D\"1\"><tr><th>Item</th><th>Price</th></tr><tr><td>Widget</td><td>9.99</td></tr><tr><td>Gadget</td><td>19.99</td></tr></table>", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSampleMarkdown, Type = String, Dynamic = False, Default = \"# Markdown Import Test\n\nThis is a **bold** and *italic* test from Android.\n\n## Features\n\n- Headings\n- Bold and italic\n- Lists\n- Code blocks\n\n```\nDim pdf As New VNSPDFDocument\npdf.LoadMarkdown(content)\n```\n\n| Column A | Column B |\n|----------|----------|\n| Cell 1   | Cell 2   |\n| Cell 3   | Cell 4   |\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCountryCode, Type = String, Dynamic = False, Default = \"FR", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kUserPassword, Type = String, Dynamic = False, Default = \"user123", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOwnerPassword, Type = String, Dynamic = False, Default = \"owner456", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kImportFileName, Type = String, Dynamic = False, Default = \"import.pdf", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPDFExtension, Type = String, Dynamic = False, Default = \".pdf", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kEInvoiceFileName, Type = String, Dynamic = False, Default = \"example30_einvoice_facturx_fr.pdf", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPlaceholder, Type = String, Dynamic = False, Default = \"<n>", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kKeyMessage, Type = String, Dynamic = False, Default = \"message", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kKeyError, Type = String, Dynamic = False, Default = \"error", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kKeyPDF, Type = String, Dynamic = False, Default = \"pdf", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kKeyFilename, Type = String, Dynamic = False, Default = \"filename", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kKeyPDF2, Type = String, Dynamic = False, Default = \"pdf2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kKeyFilename2, Type = String, Dynamic = False, Default = \"filename2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kKeyPassed, Type = String, Dynamic = False, Default = \"passed", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kKeyOutput, Type = String, Dynamic = False, Default = \"output", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgNoImportPDF, Type = String, Dynamic = False, Default = \"No PDF file found in the app Documents folder.\n\nTo use Example 20 (PDF Import)\x2C copy a PDF (named import.pdf\x2C or any .pdf) into:\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgUsingSource, Type = String, Dynamic = False, Default = \"Using source PDF: ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgExampleNil, Type = String, Dynamic = False, Default = \"ERROR: Example <n> returned Nil", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgNoMessage, Type = String, Dynamic = False, Default = \"ERROR: Result has no message", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgErrorPrefix, Type = String, Dynamic = False, Default = \"ERROR: ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgEmptyPDF, Type = String, Dynamic = False, Default = \"WARNING: PDF data is empty (0 bytes)!", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgPDFSaved, Type = String, Dynamic = False, Default = \"PDF saved: ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgFileSize, Type = String, Dynamic = False, Default = \"File size: <n> bytes", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgSaveError, Type = String, Dynamic = False, Default = \"Error saving file: ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgCreditSaved, Type = String, Dynamic = False, Default = \"Credit note saved: ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgCreditSaveError, Type = String, Dynamic = False, Default = \"Error saving credit note: ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgTestNil, Type = String, Dynamic = False, Default = \"ERROR: Test returned Nil", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgTestsPassed, Type = String, Dynamic = False, Default = \"ALL TESTS PASSED!", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMsgTestsFailed, Type = String, Dynamic = False, Default = \"SOME TESTS FAILED!", Scope = Private
	#tag EndConstant


#tag EndScreenCode

#tag Events TableExamples
	#tag Event
		Sub Opening()
		  // Fill the list here, not in the screen Opening: on Android layout controls
		  // are not initialized yet when the screen Opening event fires
		  PopulateExamples()
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged()
		  If Me.SelectedRowIndex < 0 Then Return
		  RunExample(Me.RowTagAt(Me.SelectedRowIndex).IntegerValue)
		End Sub
	#tag EndEvent
#tag EndEvents


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
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
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
		Name="HasNavigationBar"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Modal"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="NavigationBarHeight"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackButton"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
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
	#tag ViewProperty
		Name="LastControlIndex"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="ColorGroup"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="NavigationBarColor"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="ColorGroup"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="NavigationBarTextColor"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="ColorGroup"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
