#tag WebPage
Begin WebPage WebPageMain
   AllowTabOrderWrap=   True
   Compatibility   =   ""
   ControlCount    =   0
   ControlID       =   ""
   CSSClasses      =   ""
   Enabled         =   False
   Height          =   700
   ImplicitInstance=   True
   Index           =   -2147483648
   Indicator       =   0
   IsImplicitInstance=   False
   LayoutDirection =   0
   LayoutType      =   0
   Left            =   0
   LockBottom      =   False
   LockHorizontal  =   False
   LockLeft        =   True
   LockRight       =   False
   LockTop         =   True
   LockVertical    =   False
   MinimumHeight   =   700
   MinimumWidth    =   900
   PanelIndex      =   0
   ScaleFactor     =   0.0
   TabIndex        =   0
   Title           =   "Xojo FPDF Web Examples"
   Top             =   0
   Visible         =   True
   Width           =   900
   _ImplicitInstance=   False
   _mDesignHeight  =   0
   _mDesignWidth   =   0
   _mName          =   ""
   _mPanelIndex    =   -1
   Begin WebListBox lstExamples
      AllowAutoDisable=   "False"
      AllowInlineEditing=   "False"
      AllowRowActions =   "False"
      AllowRowDragReorder=   "False"
      AllowRowEditing =   "False"
      AllowRowReordering=   False
      ColumnCount     =   2
      ColumnWidths    =   "150,*"
      ControlID       =   ""
      CSSClasses      =   ""
      DefaultRowHeight=   30
      Enabled         =   True
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   True
      HeaderHeight    =   0
      Height          =   430
      HighlightSortedColumn=   True
      Index           =   -2147483648
      Indicator       =   0
      InitialValue    =   ""
      LastAddedRowIndex=   0
      LastColumnIndex =   0
      LastColumnSortDirection=   "0"
      LastRowIndex    =   0
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      LockVertical    =   False
      NoRowsMessage   =   ""
      PanelIndex      =   0
      ProcessingMessage=   ""
      RowCount        =   0
      RowSelectionType=   1
      Scope           =   0
      SearchCriteria  =   ""
      SelectedRowColor=   &c0272D300
      SelectedRowIndex=   0
      SelectionEndColumn=   "0"
      SelectionEndRow =   "0"
      SelectionStartColumn=   "0"
      SelectionStartRow=   "0"
      TabIndex        =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Visible         =   True
      Width           =   860
      _mPanelIndex    =   -1
   End
   Begin WebButton btnRunExample
      AllowAutoDisable=   False
      Cancel          =   False
      Caption         =   "Run Example"
      ControlID       =   ""
      CSSClasses      =   ""
      Default         =   True
      Enabled         =   True
      Height          =   38
      Index           =   -2147483648
      Indicator       =   0
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      LockVertical    =   False
      Outlined        =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   1
      TabStop         =   True
      Tooltip         =   ""
      Top             =   462
      Visible         =   True
      Width           =   860
      _mPanelIndex    =   -1
   End
   Begin WebTextArea txtOutput
      AllowAutoDisable=   "False"
      AllowInlineEditing=   "False"
      AllowReturnKey  =   True
      AllowSpellChecking=   True
      AllowStyledText =   "False"
      AllowTabs       =   "False"
      Bold            =   "False"
      Caption         =   ""
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      FontSize        =   "0.0"
      Height          =   174
      Hint            =   ""
      HorizontalAlignment=   "0"
      Index           =   -2147483648
      Indicator       =   0
      Italic          =   "False"
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      LockVertical    =   False
      MaximumCharactersAllowed=   0
      Multiline       =   "True"
      PanelIndex      =   0
      ReadOnly        =   True
      Scope           =   0
      TabIndex        =   2
      TabStop         =   True
      Text            =   "Output messages will appear here..."
      TextAlignment   =   0
      TextColor       =   "&c00000000"
      Tooltip         =   ""
      Top             =   506
      Underline       =   "False"
      Visible         =   True
      Width           =   860
      _mPanelIndex    =   -1
   End
End
#tag EndWebPage

#tag WindowCode
	#tag Event
		Sub Shown()
		  // Initialize output
		  txtOutput.Text = "Xojo FPDF Library - Web Examples" + EndOfLine
		  txtOutput.Text = txtOutput.Text + "Select an example from the list and click 'Run Example'." + EndOfLine + EndOfLine
		  
		  // Set up listbox headers
		  lstExamples.HeaderAt(0) = "Example"
		  lstExamples.HeaderAt(1) = "Description"
		  
		  // Populate examples list
		  lstExamples.AddRow("Example 1", "Simple shapes: Lines, rectangles, circles")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample1

		  lstExamples.AddRow("Example 2", "Text layouts: Cell, MultiCell, Write methods")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample2

		  lstExamples.AddRow("Example 3", "Multiple pages with various shapes")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample3

		  lstExamples.AddRow("Example 4", "Line widths and styles")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample4

		  lstExamples.AddRow("Example 5", "UTF-8 & TrueType fonts")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample5
		  
		  lstExamples.AddRow("Example 6", "Text measurement: GetStringWidth()")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample6

		  lstExamples.AddRow("Example 7", "Document metadata")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample7

		  lstExamples.AddRow("Example 8", "Error handling: Ok/Err/GetError")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample8

		  lstExamples.AddRow("Example 9", "Image support: JPEG, PNG, programmatic graphics")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample9

		  lstExamples.AddRow("Example 10", "Header/Footer callbacks")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample10

		  lstExamples.AddRow("Example 11", "Links and bookmarks")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample11

		  lstExamples.AddRow("Example 12", "Custom page formats")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample12
		  
		  lstExamples.AddRow("Example 13", "PDF/A compliance")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample13

		  lstExamples.AddRow("Example 14", "Document encryption")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample14

		  lstExamples.AddRow("Example 15", "Watermark header")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample15

		  lstExamples.AddRow("Example 16", "Formatting features")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample16

		  lstExamples.AddRow("Example 17", "Utility methods")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample17

		  lstExamples.AddRow("Example 18", "Plugin architecture")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample18
		  
		  lstExamples.AddRow("Example 19", "Table generation")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample19

		  lstExamples.AddRow("Example 20", "PDF import: Import pages from existing PDFs")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample20

		  lstExamples.AddRow("Example 21", "UTF-8 text: All Google Translate languages")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample21

		  lstExamples.AddRow("Example 22", "UTF Compatibility Wrapper: PDFDocument comparison")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample22

		  lstExamples.AddRow("Example 23", "File Attachments: Document-level and page annotations")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample23

		  lstExamples.AddRow("Example 24", "PDF Forms: All 9 control types (Premium)")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample24

		  lstExamples.AddRow("Example 26", "Bug Tests: Geoff Bridges Windows bug report tests")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample26

		  lstExamples.AddRow("Example 27", "HTML Import: Convert HTML file to PDF (Premium)")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample27

		  lstExamples.AddRow("Example 28", "Markdown Import: Convert Markdown file to PDF (Premium)")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample28

		  lstExamples.AddRow("Example 29", "GraphicsPath: Curves, arcs, round rectangles, clipping")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample29

		  lstExamples.AddRow("Example 30", "E-Invoice: Factur-X/ZUGFeRD compliant PDF (Premium)")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample30

		  lstExamples.AddRow("Example 31", "E-Invoice Checker: Open PDF to check Factur-X/ZUGFeRD conformity (Premium)")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample31

		  lstExamples.AddRow("Example 32", "Digital Signatures: PAdES-B-B PDF signing + XAdES-BES XML signing (Premium)")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample32

		  lstExamples.AddRow("Example 33", "Barcodes: QR Code, Code 128, EAN-13, Code 39, ITF, Codabar, PDF417, DataMatrix")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample33

		  lstExamples.AddRow("Test Zlib", "Premium pure Xojo compression tests")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kTestZlib

		  lstExamples.AddRow("Test AES", "Premium pure Xojo encryption tests")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kTestAES
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub GenerateExample1()
		  txtOutput.Text = txtOutput.Text + "Generating Example 1: Simple shapes..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample1()
		    
		    // Display status
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    // Save PDF if generated successfully
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample10()
		  txtOutput.Text = txtOutput.Text + "Generating Example 10: Header/Footer..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample10()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample11()
		  txtOutput.Text = txtOutput.Text + "Generating Example 11: Links and Bookmarks..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample11()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample12()
		  txtOutput.Text = txtOutput.Text + "Generating Example 12: Custom Page Formats..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample12()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample13()
		  txtOutput.Text = txtOutput.Text + "Generating Example 13: PDF/A Compliance..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample13()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample14()
		  txtOutput.Text = txtOutput.Text + "Generating Example 14: Document Encryption..." + EndOfLine
		  txtOutput.Text = txtOutput.Text + "Opening security settings dialog..." + EndOfLine + EndOfLine
		  
		  // Show security configuration dialog
		  SecurityDialog = New WebDialogSecurity
		  AddHandler SecurityDialog.Dismissed, AddressOf HandleSecurityDialogDismissed
		  SecurityDialog.Show()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample15()
		  txtOutput.Text = txtOutput.Text + "Generating Example 15: Watermark Header..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample15()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample16()
		  txtOutput.Text = txtOutput.Text + "Generating Example 16: Formatting Features..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample16()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample17()
		  txtOutput.Text = txtOutput.Text + "Generating Example 17: Utility Methods..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample17()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample18()
		  txtOutput.Text = txtOutput.Text + "Generating Example 18: Plugin Architecture..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample18()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample19()
		  txtOutput.Text = txtOutput.Text + "Generating Example 19: Table Generation..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample19()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample2()
		  txtOutput.Text = txtOutput.Text + "Generating Example 2: Text Layouts..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample2()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample20()
		  txtOutput.Text = txtOutput.Text + "Generating Example 20: PDF Import..." + EndOfLine
		  txtOutput.Text = txtOutput.Text + "Opening file upload dialog..." + EndOfLine + EndOfLine
		  
		  // Show PDF upload dialog
		  UploadDialog = New WebDialogPDFUpload
		  AddHandler UploadDialog.Dismissed, AddressOf HandlePDFUploadDismissed
		  UploadDialog.Show()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample27()
		  txtOutput.Text = txtOutput.Text + "Generating Example 27: HTML Import..." + EndOfLine
		  txtOutput.Text = txtOutput.Text + "Opening file upload dialog..." + EndOfLine + EndOfLine

		  // Show text file upload dialog for HTML
		  TextUploadDialog = New WebDialogTextUpload
		  mPendingTextUploadExample = 27
		  AddHandler TextUploadDialog.Dismissed, AddressOf HandleTextUploadDismissed
		  TextUploadDialog.Show()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample28()
		  txtOutput.Text = txtOutput.Text + "Generating Example 28: Markdown Import..." + EndOfLine
		  txtOutput.Text = txtOutput.Text + "Opening file upload dialog..." + EndOfLine + EndOfLine

		  // Show text file upload dialog for Markdown
		  TextUploadDialog = New WebDialogTextUpload
		  mPendingTextUploadExample = 28
		  AddHandler TextUploadDialog.Dismissed, AddressOf HandleTextUploadDismissed
		  TextUploadDialog.Show()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample21()
		  // Example 21: UTF-8 text all Google languages
		  txtOutput.Text = txtOutput.Text + "Generating Example 21: UTF-8 Text All Languages..." + EndOfLine

		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample21()
		  txtOutput.Text = txtOutput.Text + result.Value("output")

		  Dim passed As Boolean = result.Value("passed")
		  If passed Then
		    Dim pdf As VNSPDFDocument = result.Value("pdf")
		    Dim pdfData As String = pdf.Output()

		    // Web: Return PDF as download
		    Dim mb As New MemoryBlock(pdfData.LenB)
		    mb.StringValue(0, pdfData.LenB) = pdfData

		    // Trigger download
		    Dim downloadFile As New WebFile
		    downloadFile.Data = mb
		    downloadFile.MIMEType = "application/pdf"
		    downloadFile.ForceDownload = True
		    downloadFile.Filename = "example21_all_languages.pdf"

		    txtOutput.Text = txtOutput.Text + EndOfLine + "PDF generated successfully!" + EndOfLine
		    txtOutput.Text = txtOutput.Text + "Downloading: example21_all_languages.pdf" + EndOfLine
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample22()
		  txtOutput.Text = txtOutput.Text + "Generating Example 22: UTF Compatibility Wrapper..." + EndOfLine

		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample22()

		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue

		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf").StringValue
		      Dim filename As String = result.Value("filename").StringValue

		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename

		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample23()
		  txtOutput.Text = txtOutput.Text + "Generating Example 23: File Attachments..." + EndOfLine

		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample23()

		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue

		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf").StringValue
		      Dim filename As String = result.Value("filename").StringValue

		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename

		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample24()
		  txtOutput.Text = txtOutput.Text + "Generating Example 24: PDF Forms (Premium)..." + EndOfLine

		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample24()

		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue

		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf").StringValue
		      Dim filename As String = result.Value("filename").StringValue

		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename

		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample26()
		  // Call shared module function - Bug Tests
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample26_BugTests()

		  // Display message (contains all status info)
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If

		  // Prepare PDF for download if generated successfully
		  If result.HasKey("success") And result.Value("success").BooleanValue And result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue

		    PDFFile = New WebFile
		    PDFFile.Data = pdfData
		    PDFFile.MIMEType = "application/pdf"
		    PDFFile.ForceDownload = False
		    PDFFile.Filename = filename

		    txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		    Call PDFFile.Download
		  Else
		    txtOutput.Text = txtOutput.Text + "Test generation failed." + EndOfLine
		  End If

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample29()
		  // Call shared module function - GraphicsPath Features
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample29()

		  // Display message
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If

		  // Prepare PDF for download if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue

		    PDFFile = New WebFile
		    PDFFile.Data = pdfData
		    PDFFile.MIMEType = "application/pdf"
		    PDFFile.ForceDownload = False
		    PDFFile.Filename = filename

		    txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		    Call PDFFile.Download
		  End If

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample30()
		  // Call shared module function - E-Invoice (Factur-X/ZUGFeRD)
		  // TODO: Add WebDialog for country code selection
		  Dim countryCode As String = "FR"
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample30(countryCode)

		  // Display message
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If

		  // Prepare PDF for download if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue

		    PDFFile = New WebFile
		    PDFFile.Data = pdfData
		    PDFFile.MIMEType = "application/pdf"
		    PDFFile.ForceDownload = False
		    PDFFile.Filename = filename

		    txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		    Call PDFFile.Download
		  End If

		  // Download credit note if generated
		  If result.HasKey("pdf2") Then
		    Dim pdfData2 As String = result.Value("pdf2").StringValue
		    Dim filename2 As String = result.Value("filename2").StringValue
		    Dim creditFile As New WebFile
		    creditFile.Data = pdfData2
		    creditFile.MIMEType = "application/pdf"
		    creditFile.ForceDownload = False
		    creditFile.Filename = filename2
		    txtOutput.Text = txtOutput.Text + "Credit note will be downloaded." + EndOfLine
		    Call creditFile.Download
		  End If

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample32_Web()
		  // Call shared module function - Digital Signatures (PAdES + XAdES)
		  // TODO: Add WebDialog for country code selection
		  Dim countryCode As String = "FR"
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample32(countryCode)

		  // Display message
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If

		  // Prepare PDF for download if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue

		    PDFFile = New WebFile
		    PDFFile.Data = pdfData
		    PDFFile.MIMEType = "application/pdf"
		    PDFFile.ForceDownload = False
		    PDFFile.Filename = filename

		    txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		    Call PDFFile.Download
		  End If

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample33_Web()
		  // Call shared module function - Barcodes
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample33_Barcodes()

		  // Display message
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If

		  // Prepare PDF for download if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue

		    PDFFile = New WebFile
		    PDFFile.Data = pdfData
		    PDFFile.MIMEType = "application/pdf"
		    PDFFile.ForceDownload = False
		    PDFFile.Filename = filename

		    txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		    Call PDFFile.Download
		  End If

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample31()
		  txtOutput.Text = txtOutput.Text + "Example 31: E-Invoice Checker..." + EndOfLine
		  txtOutput.Text = txtOutput.Text + "Opening file upload dialog..." + EndOfLine + EndOfLine

		  // Show PDF upload dialog for e-invoice checking
		  UploadDialog = New WebDialogPDFUpload
		  AddHandler UploadDialog.Dismissed, AddressOf HandleEInvoiceCheckDismissed
		  UploadDialog.Show()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunTestZlib()
		  // Run Zlib premium compression tests
		  txtOutput.Text = txtOutput.Text + "Running Zlib Premium Tests..." + EndOfLine + EndOfLine

		  Dim result As Dictionary = VNSPDFExamplesModule.TestZlib()
		  txtOutput.Text = txtOutput.Text + result.Value("output")

		  Dim passed As Boolean = result.Value("passed")
		  If passed Then
		    txtOutput.Text = txtOutput.Text + EndOfLine + "ALL ZLIB TESTS PASSED!" + EndOfLine
		  Else
		    txtOutput.Text = txtOutput.Text + EndOfLine + "SOME ZLIB TESTS FAILED!" + EndOfLine
		  End If

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunTestAES()
		  // Run AES premium encryption tests
		  txtOutput.Text = txtOutput.Text + "Running AES Premium Tests..." + EndOfLine + EndOfLine

		  Dim result As Dictionary = VNSPDFExamplesModule.TestAES()
		  txtOutput.Text = txtOutput.Text + result.Value("output")

		  Dim passed As Boolean = result.Value("passed")
		  If passed Then
		    txtOutput.Text = txtOutput.Text + EndOfLine + "ALL AES TESTS PASSED!" + EndOfLine
		  Else
		    txtOutput.Text = txtOutput.Text + EndOfLine + "SOME AES TESTS FAILED!" + EndOfLine
		  End If

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample3()
		  txtOutput.Text = txtOutput.Text + "Generating Example 3: Multiple Pages..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample3()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample4()
		  txtOutput.Text = txtOutput.Text + "Generating Example 4: Line Widths..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample4()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample5()
		  txtOutput.Text = txtOutput.Text + "Generating Example 5: UTF-8 & TrueType Fonts..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample5()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample6()
		  txtOutput.Text = txtOutput.Text + "Generating Example 6: Text Measurement..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample6()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample7()
		  txtOutput.Text = txtOutput.Text + "Generating Example 7: Document Metadata..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample7()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample8()
		  txtOutput.Text = txtOutput.Text + "Generating Example 8: Error Handling..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample8()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample9()
		  txtOutput.Text = txtOutput.Text + "Generating Example 9: Image Support..." + EndOfLine
		  
		  Try
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample9()
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandlePDFUploadDismissed(dialog As WebDialog)
		  #Pragma Unused dialog

		  // Check if user cancelled
		  If UploadDialog.UserCancelled Then
		    txtOutput.Text = txtOutput.Text + "Example 20: Cancelled by user." + EndOfLine + EndOfLine
		    Return
		  End If
		  
		  txtOutput.Text = txtOutput.Text + "Generating Example 20: PDF Import from uploaded file..." + EndOfLine
		  
		  Try
		    // Call with the uploaded PDF path
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample20(UploadDialog.UploadedFilePath)
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleTextUploadDismissed(dialog As WebDialog)
		  #Pragma Unused dialog

		  // Check if user cancelled
		  If TextUploadDialog.UserCancelled Then
		    If mPendingTextUploadExample = 27 Then
		      txtOutput.Text = txtOutput.Text + "Example 27: Cancelled by user." + EndOfLine + EndOfLine
		    Else
		      txtOutput.Text = txtOutput.Text + "Example 28: Cancelled by user." + EndOfLine + EndOfLine
		    End If
		    Return
		  End If

		  // Read text content from uploaded file path
		  Dim fileContent As String
		  Try
		    Dim f As New FolderItem(TextUploadDialog.UploadedFilePath)
		    Dim tis As TextInputStream = TextInputStream.Open(f)
		    tis.Encoding = Encodings.UTF8
		    fileContent = tis.ReadAll()
		    tis.Close()
		  Catch e As IOException
		    txtOutput.Text = txtOutput.Text + "Error reading uploaded file: " + e.Message + EndOfLine + EndOfLine
		    Return
		  End Try

		  Try
		    Dim result As Dictionary

		    If mPendingTextUploadExample = 27 Then
		      txtOutput.Text = txtOutput.Text + "Generating Example 27: HTML Import from uploaded file..." + EndOfLine
		      result = VNSPDFExamplesModule.GenerateExample27_HTMLImport(fileContent)
		    Else
		      txtOutput.Text = txtOutput.Text + "Generating Example 28: Markdown Import from uploaded file..." + EndOfLine
		      result = VNSPDFExamplesModule.GenerateExample28_MarkdownImport(fileContent)
		    End If

		    txtOutput.Text = txtOutput.Text + result.Value("message")

		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")

		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename

		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleEInvoiceCheckDismissed(dialog As WebDialog)
		  #Pragma Unused dialog

		  // Check if user cancelled
		  If UploadDialog.UserCancelled Then
		    txtOutput.Text = txtOutput.Text + "Example 31: Cancelled by user." + EndOfLine + EndOfLine
		    Return
		  End If

		  Try
		    // Read PDF data from uploaded file
		    Dim f As New FolderItem(UploadDialog.UploadedFilePath)
		    Dim bis As BinaryStream = BinaryStream.Open(f)
		    Dim pdfData As String = bis.Read(bis.Length)
		    bis.Close()

		    txtOutput.Text = txtOutput.Text + "Checking uploaded PDF for e-invoice conformity..." + EndOfLine

		    // Call the checker method with PDF data
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample31_CheckEInvoice(pdfData)

		    // Display the results
		    If result.HasKey("message") Then
		      txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		    End If

		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleSecurityDialogDismissed(dialog As WebDialog)
		  #Pragma Unused dialog

		  // Check if user cancelled
		  If SecurityDialog.UserCancelled Then
		    txtOutput.Text = txtOutput.Text + "Example 14: Cancelled by user." + EndOfLine + EndOfLine
		    Return
		  End If
		  
		  Try
		    // Get security settings from dialog
		    Dim revision As Integer = SecurityDialog.EncryptionRevision
		    Dim userPassword As String = SecurityDialog.UserPassword
		    Dim ownerPassword As String = SecurityDialog.OwnerPassword
		    Dim allowPrint As Boolean = SecurityDialog.AllowPrint
		    Dim allowModify As Boolean = SecurityDialog.AllowModify
		    Dim allowCopy As Boolean = SecurityDialog.AllowCopy
		    Dim allowAnnotate As Boolean = SecurityDialog.AllowAnnotations
		    Dim allowFillForms As Boolean = SecurityDialog.AllowFillForms
		    Dim allowExtract As Boolean = SecurityDialog.AllowExtract
		    Dim allowAssemble As Boolean = SecurityDialog.AllowAssemble
		    Dim allowPrintHighQuality As Boolean = SecurityDialog.AllowPrintHighQuality
		    
		    // Call example with user-configured settings
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample14(revision, userPassword, ownerPassword, _
		    allowPrint, allowModify, allowCopy, allowAnnotate, allowFillForms, allowExtract, allowAssemble, allowPrintHighQuality)
		    
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      
		      PDFFile = New WebFile
		      PDFFile.Data = pdfData
		      PDFFile.MIMEType = "application/pdf"
		      PDFFile.ForceDownload = False
		      PDFFile.Filename = filename
		      
		      txtOutput.Text = txtOutput.Text + "Success! PDF will be downloaded." + EndOfLine
		      Call PDFFile.Download
		    End If
		  Catch e As RuntimeException
		    txtOutput.Text = txtOutput.Text + "Error: " + e.Message + EndOfLine
		  End Try
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private PDFFile As WebFile
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SecurityDialog As WebDialogSecurity
	#tag EndProperty

	#tag Property, Flags = &h21
		Private UploadDialog As WebDialogPDFUpload
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TextUploadDialog As WebDialogTextUpload
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPendingTextUploadExample As Integer
	#tag EndProperty


#tag EndWindowCode

#tag Events btnRunExample
	#tag Event
		Sub Pressed()
		  // Check if a row is selected
		  If lstExamples.SelectedRowIndex < 0 Then
		    txtOutput.Text = txtOutput.Text + "Please select an example from the list." + EndOfLine
		    Return
		  End If
		  
		  // Get the example number from the row tag
		  Dim exampleNum As Variant = lstExamples.CellTagAt(lstExamples.SelectedRowIndex, 0)
		  
		  If exampleNum = Nil Then
		    txtOutput.Text = txtOutput.Text + "Error: Invalid example selection." + EndOfLine
		    Return
		  End If
		  
		  // Call the appropriate GenerateExample method
		  Select Case exampleNum
		  Case VNSPDFExamplesModule.kExample1
		    GenerateExample1()
		  Case VNSPDFExamplesModule.kExample2
		    GenerateExample2()
		  Case VNSPDFExamplesModule.kExample3
		    GenerateExample3()
		  Case VNSPDFExamplesModule.kExample4
		    GenerateExample4()
		  Case VNSPDFExamplesModule.kExample5
		    GenerateExample5()
		  Case VNSPDFExamplesModule.kExample6
		    GenerateExample6()
		  Case VNSPDFExamplesModule.kExample7
		    GenerateExample7()
		  Case VNSPDFExamplesModule.kExample8
		    GenerateExample8()
		  Case VNSPDFExamplesModule.kExample9
		    GenerateExample9()
		  Case VNSPDFExamplesModule.kExample10
		    GenerateExample10()
		  Case VNSPDFExamplesModule.kExample11
		    GenerateExample11()
		  Case VNSPDFExamplesModule.kExample12
		    GenerateExample12()
		  Case VNSPDFExamplesModule.kExample13
		    GenerateExample13()
		  Case VNSPDFExamplesModule.kExample14
		    GenerateExample14()
		  Case VNSPDFExamplesModule.kExample15
		    GenerateExample15()
		  Case VNSPDFExamplesModule.kExample16
		    GenerateExample16()
		  Case VNSPDFExamplesModule.kExample17
		    GenerateExample17()
		  Case VNSPDFExamplesModule.kExample18
		    GenerateExample18()
		  Case VNSPDFExamplesModule.kExample19
		    GenerateExample19()
		  Case VNSPDFExamplesModule.kExample20
		    GenerateExample20()
		  Case VNSPDFExamplesModule.kExample21
		    GenerateExample21()
		  Case VNSPDFExamplesModule.kExample22
		    GenerateExample22()
		  Case VNSPDFExamplesModule.kExample23
		    GenerateExample23()
		  Case VNSPDFExamplesModule.kExample24
		    GenerateExample24()
		  Case VNSPDFExamplesModule.kExample26
		    GenerateExample26()
		  Case VNSPDFExamplesModule.kExample27
		    GenerateExample27()
		  Case VNSPDFExamplesModule.kExample28
		    GenerateExample28()
		  Case VNSPDFExamplesModule.kExample29
		    GenerateExample29()
		  Case VNSPDFExamplesModule.kExample30
		    GenerateExample30()
		  Case VNSPDFExamplesModule.kExample31
		    GenerateExample31()
		  Case VNSPDFExamplesModule.kExample32
		    GenerateExample32_Web()
		  Case VNSPDFExamplesModule.kExample33
		    GenerateExample33_Web()
		  Case VNSPDFExamplesModule.kTestZlib
		    RunTestZlib()
		  Case VNSPDFExamplesModule.kTestAES
		    RunTestAES()
		  Else
		    txtOutput.Text = txtOutput.Text + "Unknown example number: " + exampleNum.StringValue + EndOfLine
		  End Select
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="_ImplicitInstance"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="PanelIndex"
		Visible=false
		Group="Behavior"
		InitialValue=""
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
		Name="_mPanelIndex"
		Visible=false
		Group="Behavior"
		InitialValue="-1"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ControlID"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Index"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Left"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockHorizontal"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockLeft"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockVertical"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Behavior"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Behavior"
		InitialValue="600"
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
		Name="Title"
		Visible=true
		Group="Behavior"
		InitialValue="Untitled"
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mDesignHeight"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mDesignWidth"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mName"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="IsImplicitInstance"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowTabOrderWrap"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Visual Controls"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Indicator"
		Visible=false
		Group="Visual Controls"
		InitialValue=""
		Type="WebUIControl.Indicators"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Primary"
			"2 - Secondary"
			"3 - Success"
			"4 - Danger"
			"5 - Warning"
			"6 - Info"
			"7 - Light"
			"8 - Dark"
			"9 - Link"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="LayoutType"
		Visible=true
		Group="View"
		InitialValue="LayoutTypes.Fixed"
		Type="LayoutTypes"
		EditorType="Enum"
		#tag EnumValues
			"0 - Fixed"
			"1 - Flex"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="LayoutDirection"
		Visible=true
		Group="View"
		InitialValue="LayoutDirections.LeftToRight"
		Type="LayoutDirections"
		EditorType="Enum"
		#tag EnumValues
			"0 - LeftToRight"
			"1 - RightToLeft"
			"2 - TopToBottom"
			"3 - BottomToTop"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="ScaleFactor"
		Visible=false
		Group="Behavior"
		InitialValue="1.0"
		Type="Double"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
