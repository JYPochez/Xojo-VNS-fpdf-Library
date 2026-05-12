#tag DesktopWindow
Begin DesktopWindow WindowMain
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   700
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   1603346431
   MenuBarVisible  =   False
   MinimumHeight   =   400
   MinimumWidth    =   700
   Resizeable      =   True
   Title           =   "Xojo FPDF Examples"
   Type            =   0
   Visible         =   True
   Width           =   900
   Begin DesktopListBox lstExamples
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   False
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   2
      ColumnWidths    =   "150,*"
      DefaultRowHeight=   26
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   430
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   860
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin DesktopButton btnRunExample
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Run Example (Save to Desktop)"
      Default         =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   32
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Generate the PDF and save it to the Desktop"
      Top             =   462
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   420
   End
   Begin DesktopButton btnPreviewExample
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Preview Example"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   32
      Index           =   -2147483648
      Italic          =   False
      Left            =   460
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Generate the PDF and show a preview with Save/Print options"
      Top             =   462
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   420
   End
   Begin DesktopTextArea txtOutput
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   156
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Output messages will appear here..."
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   518
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   860
   End
   Begin DesktopCanvas SplitterHandle
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   False
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   8
      Index           =   -2147483648
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   False
      Tooltip         =   "Drag to resize"
      Top             =   499
      Transparent     =   False
      Visible         =   True
      Width           =   860
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  // Initialize output
		  txtOutput.Text = "Xojo FPDF Library - Examples" + EndOfLine
		  txtOutput.Text = txtOutput.Text + "Select an example from the list and click 'Run Example'." + EndOfLine + EndOfLine
		  
		  // Set up listbox headers
		  //lstExamples.ColumnTypeAt(0) = DesktopListBox.CellTypes.TextField
		  //lstExamples.ColumnTypeAt(1) = DesktopListBox.CellTypes.TextField
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
		  
		  lstExamples.AddRow("Example 5 (Xojo)", "TrueType font with Xojo font path")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = VNSPDFExamplesModule.kExample5Xojo
		  
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
		  // Use shared examples module
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample1()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  
		  // Save to file if successful
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		    stream.Write(pdfData)
		    stream.Close()
		    
		    txtOutput.Text = txtOutput.Text + "Saved to: " + pdfFile.NativePath + EndOfLine
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample10()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample10()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample11()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample11()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample12()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample12()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample13()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample13()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample14Interactive()
		  // Show security configuration dialog
		  Dim dlg As New SecurityDialog
		  dlg.ShowModal()
		  
		  If Not dlg.UserCancelled Then
		    // Get security settings from dialog
		    Dim revision As Integer = dlg.EncryptionRevision
		    Dim userPassword As String = dlg.UserPassword
		    Dim ownerPassword As String = dlg.OwnerPassword
		    Dim allowPrint As Boolean = dlg.AllowPrint
		    Dim allowModify As Boolean = dlg.AllowModify
		    Dim allowCopy As Boolean = dlg.AllowCopy
		    Dim allowAnnotate As Boolean = dlg.AllowAnnotations
		    Dim allowFillForms As Boolean = dlg.AllowFillForms
		    Dim allowExtract As Boolean = dlg.AllowExtract
		    Dim allowAssemble As Boolean = dlg.AllowAssemble
		    Dim allowPrintHighQuality As Boolean = dlg.AllowPrintHighQuality
		    
		    txtOutput.Text = txtOutput.Text + "Generating encrypted PDF..." + EndOfLine
		    txtOutput.Text = txtOutput.Text + "Encryption: Revision " + Str(revision) + EndOfLine
		    txtOutput.Text = txtOutput.Text + "User Password: " + If(userPassword <> "", "***", "(none)") + EndOfLine
		    txtOutput.Text = txtOutput.Text + "Permissions: Print=" + Str(allowPrint) + ", Modify=" + Str(allowModify) + _
		    ", Copy=" + Str(allowCopy) + ", Annotate=" + Str(allowAnnotate) + EndOfLine
		    txtOutput.Text = txtOutput.Text + "  FillForms=" + Str(allowFillForms) + ", Extract=" + Str(allowExtract) + _
		    ", Assemble=" + Str(allowAssemble) + ", PrintHQ=" + Str(allowPrintHighQuality) + EndOfLine
		    txtOutput.Text = txtOutput.Text + EndOfLine
		    
		    // Call shared module function with all 8 permission parameters
		    Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample14(revision, userPassword, ownerPassword, _
		    allowPrint, allowModify, allowCopy, allowAnnotate, allowFillForms, allowExtract, allowAssemble, allowPrintHighQuality)
		    
		    // Display status
		    txtOutput.Text = txtOutput.Text + result.Value("message")
		    
		    // Save PDF if generated successfully
		    If result.HasKey("pdf") Then
		      Dim pdfData As String = result.Value("pdf")
		      Dim filename As String = result.Value("filename")
		      Dim desktop As FolderItem = SpecialFolder.Desktop
		      Dim pdfFile As FolderItem = desktop.Child(filename)
		      
		      Try
		        Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		        stream.Write(pdfData)
		        stream.Close()
		        txtOutput.Text = txtOutput.Text + "Success! Encrypted PDF saved to: " + pdfFile.NativePath + EndOfLine
		        If userPassword <> "" Then
		          txtOutput.Text = txtOutput.Text + "Password required to open: " + userPassword + EndOfLine
		        End If
		      Catch e As IOException
		        txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		      End Try
		    End If
		    
		    txtOutput.Text = txtOutput.Text + EndOfLine
		  Else
		    txtOutput.Text = txtOutput.Text + "Example 14 cancelled by user" + EndOfLine + EndOfLine
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample15()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample15()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample16()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample16()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample17()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample17()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample18()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample18()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample19()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample19()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample2()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample2()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample20()
		  // Show file picker to choose source PDF
		  Dim dlg As New OpenFileDialog
		  dlg.Title = "Choose PDF file to import"
		  dlg.Filter = "PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*"
		  
		  Dim selectedFile As FolderItem = dlg.ShowModal()
		  If selectedFile = Nil Then
		    txtOutput.Text = txtOutput.Text + "Example 20: Cancelled - No PDF selected" + EndOfLine + EndOfLine
		    Return
		  End If
		  
		  // Call shared module function with selected file
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample20(selectedFile.NativePath)
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample21()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample21()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample22()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample22()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Note: Example 22 generates TWO PDFs (native Xojo and wrapper)
		  // Both are saved by the shared module function
		  // No need to save here as they're already saved to Desktop
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample23()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample23()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample24()
		  // Call shared module function - PDF Forms (Premium)
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample24()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
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
		  
		  // Save PDF to desktop if generated successfully
		  If result.HasKey("success") And result.Value("success").BooleanValue And result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + EndOfLine
		      txtOutput.Text = txtOutput.Text + "PDF saved to Desktop: " + pdfFile.NativePath + EndOfLine
		      txtOutput.Text = txtOutput.Text + "This test verifies bugs reported by Geoff Bridges (Windows 11 user)." + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF to desktop: " + e.Message + EndOfLine
		    End Try
		  Else
		    txtOutput.Text = txtOutput.Text + "Test generation failed." + EndOfLine
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample27()
		  // Show file picker to choose HTML file
		  Dim dlg As New OpenFileDialog
		  dlg.Title = "Choose HTML file to import"
		  dlg.Filter = "HTML Files (*.html;*.htm)|*.html;*.htm|All Files (*.*)|*.*"
		  
		  Dim selectedFile As FolderItem = dlg.ShowModal()
		  If selectedFile = Nil Then
		    txtOutput.Text = txtOutput.Text + "Example 27: Cancelled - No HTML file selected" + EndOfLine + EndOfLine
		    Return
		  End If
		  
		  // Read file content
		  Dim htmlContent As String
		  Try
		    Dim tis As TextInputStream = TextInputStream.Open(selectedFile)
		    tis.Encoding = Encodings.UTF8
		    htmlContent = tis.ReadAll()
		    tis.Close()
		  Catch e As IOException
		    txtOutput.Text = txtOutput.Text + "Error reading file: " + e.Message + EndOfLine + EndOfLine
		    Return
		  End Try
		  
		  // Call shared module function with file content and image folder
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample27_HTMLImport(htmlContent, selectedFile.Parent)
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample28()
		  // Show file picker to choose Markdown file
		  Dim dlg As New OpenFileDialog
		  dlg.Title = "Choose Markdown file to import"
		  dlg.Filter = "Markdown Files (*.md;*.markdown)|*.md;*.markdown|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
		  
		  Dim selectedFile As FolderItem = dlg.ShowModal()
		  If selectedFile = Nil Then
		    txtOutput.Text = txtOutput.Text + "Example 28: Cancelled - No Markdown file selected" + EndOfLine + EndOfLine
		    Return
		  End If
		  
		  // Read file content
		  Dim mdContent As String
		  Try
		    Dim tis As TextInputStream = TextInputStream.Open(selectedFile)
		    tis.Encoding = Encodings.UTF8
		    mdContent = tis.ReadAll()
		    tis.Close()
		  Catch e As IOException
		    txtOutput.Text = txtOutput.Text + "Error reading file: " + e.Message + EndOfLine + EndOfLine
		    Return
		  End Try
		  
		  // Call shared module function with file content
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample28_MarkdownImport(mdContent)
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample29()
		  // Call shared module function - GraphicsPath Features
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample29()
		  
		  // Display status
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If
		  
		  // Save PDF to desktop if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "PDF saved to Desktop: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF to desktop: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample3()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample3()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample30()
		  // Show country selection dialog
		  Dim dlg As New VNSCountryDialog
		  dlg.ShowModal(Self)
		  If dlg.Cancelled Then Return
		  Dim countryCode As String = dlg.SelectedCountryCode
		  
		  // Call shared module function - E-Invoice (Factur-X/ZUGFeRD)
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample30(countryCode)
		  
		  // Display status
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If
		  
		  // Save PDF to desktop if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "PDF saved to Desktop: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF to desktop: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  // Save second PDF (credit note) if generated
		  If result.HasKey("pdf2") Then
		    Dim pdfData2 As String = result.Value("pdf2").StringValue
		    Dim filename2 As String = result.Value("filename2").StringValue
		    Dim desktop2 As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile2 As FolderItem = desktop2.Child(filename2)
		    Try
		      Dim stream2 As BinaryStream = BinaryStream.Create(pdfFile2, True)
		      stream2.Write(pdfData2)
		      stream2.Close()
		      txtOutput.Text = txtOutput.Text + "Credit note saved to Desktop: " + pdfFile2.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving credit note: " + e.Message + EndOfLine
		    End Try
		  End If

		  // Save third PDF (precision test) if generated
		  If result.HasKey("pdf3") Then
		    Dim pdfData3 As String = result.Value("pdf3").StringValue
		    Dim filename3 As String = result.Value("filename3").StringValue
		    Dim desktop3 As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile3 As FolderItem = desktop3.Child(filename3)
		    Try
		      Dim stream3 As BinaryStream = BinaryStream.Create(pdfFile3, True)
		      stream3.Write(pdfData3)
		      stream3.Close()
		      txtOutput.Text = txtOutput.Text + "Precision test saved to Desktop: " + pdfFile3.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving precision test: " + e.Message + EndOfLine
		    End Try
		  End If

		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample31()
		  // Open file dialog for PDF
		  Dim dlg As New OpenFileDialog
		  dlg.Title = "Select a PDF file to check for e-invoice conformity"
		  dlg.Filter = "PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*"
		  
		  Dim f As FolderItem = dlg.ShowModal(Self)
		  If f = Nil Or Not f.Exists Then
		    txtOutput.Text = txtOutput.Text + "Example 31: No file selected." + EndOfLine + EndOfLine
		    Return
		  End If
		  
		  // Read PDF data
		  Dim pdfData As String
		  Try
		    Dim bs As BinaryStream = BinaryStream.Open(f)
		    pdfData = bs.Read(bs.Length)
		    bs.Close()
		  Catch e As IOException
		    txtOutput.Text = txtOutput.Text + "Error reading PDF file: " + e.Message + EndOfLine + EndOfLine
		    Return
		  End Try
		  
		  // Call shared module function to check e-invoice conformity
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample31_CheckEInvoice(pdfData)
		  
		  // Display results
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample32_Desktop()
		  // Show country selection dialog
		  Dim dlg As New VNSCountryDialog
		  dlg.ShowModal(Self)
		  If dlg.Cancelled Then Return
		  Dim countryCode As String = dlg.SelectedCountryCode
		  
		  // Call shared module function - Digital Signatures (PAdES + XAdES)
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample32(countryCode)
		  
		  // Display status
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If
		  
		  // Save PDF to desktop if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "PDF saved to Desktop: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF to desktop: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample33_Desktop()
		  // Call shared module function - Barcodes
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample33_Barcodes()
		  
		  // Display status
		  If result.HasKey("message") Then
		    txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		  End If
		  
		  // Save PDF to desktop if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "PDF saved to Desktop: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF to desktop: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample4()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample4()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample5()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample5()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample5Xojo()
		  // This example uses Xojo's font path
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample5Xojo()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample6()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample6()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample7()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample7()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample8()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample8()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GenerateExample9()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample9()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("message")
		  
		  // Save PDF if generated successfully
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(filename)
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      txtOutput.Text = txtOutput.Text + "Success! PDF saved to: " + pdfFile.NativePath + EndOfLine
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error saving PDF: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PreviewExample()
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
		  
		  Dim result As Dictionary
		  
		  Select Case exampleNum
		  Case VNSPDFExamplesModule.kExample1
		    result = VNSPDFExamplesModule.GenerateExample1()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample2
		    result = VNSPDFExamplesModule.GenerateExample2()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample3
		    result = VNSPDFExamplesModule.GenerateExample3()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample4
		    result = VNSPDFExamplesModule.GenerateExample4()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample5
		    result = VNSPDFExamplesModule.GenerateExample5()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample5Xojo
		    result = VNSPDFExamplesModule.GenerateExample5Xojo()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample6
		    result = VNSPDFExamplesModule.GenerateExample6()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample7
		    result = VNSPDFExamplesModule.GenerateExample7()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample8
		    result = VNSPDFExamplesModule.GenerateExample8()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample9
		    result = VNSPDFExamplesModule.GenerateExample9()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample10
		    result = VNSPDFExamplesModule.GenerateExample10()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample11
		    result = VNSPDFExamplesModule.GenerateExample11()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample12
		    result = VNSPDFExamplesModule.GenerateExample12()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample13
		    result = VNSPDFExamplesModule.GenerateExample13()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample14
		    // Encryption example - needs interactive dialog first
		    Dim dlg As New SecurityDialog
		    dlg.ShowModal()
		    
		    If Not dlg.UserCancelled Then
		      result = VNSPDFExamplesModule.GenerateExample14( _
		      dlg.EncryptionRevision, dlg.UserPassword, dlg.OwnerPassword, _
		      dlg.AllowPrint, dlg.AllowModify, dlg.AllowCopy, dlg.AllowAnnotations, _
		      dlg.AllowFillForms, dlg.AllowExtract, dlg.AllowAssemble, dlg.AllowPrintHighQuality)
		      ShowPreviewForResult(result)
		    Else
		      txtOutput.Text = txtOutput.Text + "Example 14 cancelled by user" + EndOfLine + EndOfLine
		    End If
		    
		  Case VNSPDFExamplesModule.kExample15
		    result = VNSPDFExamplesModule.GenerateExample15()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample16
		    result = VNSPDFExamplesModule.GenerateExample16()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample17
		    result = VNSPDFExamplesModule.GenerateExample17()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample18
		    result = VNSPDFExamplesModule.GenerateExample18()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample19
		    result = VNSPDFExamplesModule.GenerateExample19()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample20
		    // PDF import - needs file picker
		    Dim dlgOpen As New OpenFileDialog
		    dlgOpen.Title = "Choose PDF file to import"
		    dlgOpen.Filter = "PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*"
		    
		    Dim selectedFile As FolderItem = dlgOpen.ShowModal()
		    If selectedFile = Nil Then
		      txtOutput.Text = txtOutput.Text + "Example 20: Cancelled - No PDF selected" + EndOfLine + EndOfLine
		      Return
		    End If
		    
		    result = VNSPDFExamplesModule.GenerateExample20(selectedFile.NativePath)
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample21
		    result = VNSPDFExamplesModule.GenerateExample21()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample22
		    result = VNSPDFExamplesModule.GenerateExample22()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample23
		    result = VNSPDFExamplesModule.GenerateExample23()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample24
		    result = VNSPDFExamplesModule.GenerateExample24()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample26
		    result = VNSPDFExamplesModule.GenerateExample26_BugTests()
		    If result.HasKey("message") Then
		      txtOutput.Text = txtOutput.Text + result.Value("message").StringValue
		    End If
		    If result.HasKey("success") And result.Value("success").BooleanValue And result.HasKey("pdf") Then
		      ShowPreviewForResult(result)
		    End If
		    
		  Case VNSPDFExamplesModule.kExample27
		    // HTML Import - needs file picker
		    Dim dlgHtml As New OpenFileDialog
		    dlgHtml.Title = "Choose HTML file to import"
		    dlgHtml.Filter = "HTML Files (*.html;*.htm)|*.html;*.htm|All Files (*.*)|*.*"
		    
		    Dim htmlFile As FolderItem = dlgHtml.ShowModal()
		    If htmlFile = Nil Then
		      txtOutput.Text = txtOutput.Text + "Example 27: Cancelled - No HTML file selected" + EndOfLine + EndOfLine
		      Return
		    End If
		    
		    Dim htmlContent As String
		    Try
		      Dim tis As TextInputStream = TextInputStream.Open(htmlFile)
		      tis.Encoding = Encodings.UTF8
		      htmlContent = tis.ReadAll()
		      tis.Close()
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error reading file: " + e.Message + EndOfLine + EndOfLine
		      Return
		    End Try
		    
		    result = VNSPDFExamplesModule.GenerateExample27_HTMLImport(htmlContent, htmlFile.Parent)
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample28
		    // Markdown Import - needs file picker
		    Dim dlgMd As New OpenFileDialog
		    dlgMd.Title = "Choose Markdown file to import"
		    dlgMd.Filter = "Markdown Files (*.md;*.markdown)|*.md;*.markdown|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
		    
		    Dim mdFile As FolderItem = dlgMd.ShowModal()
		    If mdFile = Nil Then
		      txtOutput.Text = txtOutput.Text + "Example 28: Cancelled - No Markdown file selected" + EndOfLine + EndOfLine
		      Return
		    End If
		    
		    Dim mdContent As String
		    Try
		      Dim tisMd As TextInputStream = TextInputStream.Open(mdFile)
		      tisMd.Encoding = Encodings.UTF8
		      mdContent = tisMd.ReadAll()
		      tisMd.Close()
		    Catch e As IOException
		      txtOutput.Text = txtOutput.Text + "Error reading file: " + e.Message + EndOfLine + EndOfLine
		      Return
		    End Try
		    
		    result = VNSPDFExamplesModule.GenerateExample28_MarkdownImport(mdContent)
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample29
		    result = VNSPDFExamplesModule.GenerateExample29()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kExample30
		    Dim dlg30 As New VNSCountryDialog
		    dlg30.ShowModal(Self)
		    If Not dlg30.Cancelled Then
		      result = VNSPDFExamplesModule.GenerateExample30(dlg30.SelectedCountryCode)
		      ShowPreviewForResult(result)
		    End If
		    
		  Case VNSPDFExamplesModule.kExample31
		    GenerateExample31()
		    Return  // No PDF to preview - this example just checks an existing PDF
		    
		  Case VNSPDFExamplesModule.kExample32
		    Dim dlg32 As New VNSCountryDialog
		    dlg32.ShowModal(Self)
		    If Not dlg32.Cancelled Then
		      result = VNSPDFExamplesModule.GenerateExample32(dlg32.SelectedCountryCode)
		      ShowPreviewForResult(result)
		    End If
		    
		  Case VNSPDFExamplesModule.kExample33
		    result = VNSPDFExamplesModule.GenerateExample33_Barcodes()
		    ShowPreviewForResult(result)
		    
		  Case VNSPDFExamplesModule.kTestZlib
		    RunTestZlib()
		    txtOutput.Text = txtOutput.Text + "(Tests have no PDF to preview)" + EndOfLine + EndOfLine
		    
		  Case VNSPDFExamplesModule.kTestAES
		    RunTestAES()
		    txtOutput.Text = txtOutput.Text + "(Tests have no PDF to preview)" + EndOfLine + EndOfLine
		    
		  Else
		    txtOutput.Text = txtOutput.Text + "Unknown example number: " + exampleNum.StringValue + EndOfLine
		  End Select
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
		Private Sub ShowPreviewForResult(result As Dictionary)
		  // Helper: shows a preview window for a generated PDF result dictionary
		  // The dictionary must contain "pdf" and "filename" keys
		  
		  If result = Nil Then Return
		  
		  // Display status
		  If result.HasKey("status") Then
		    txtOutput.Text = txtOutput.Text + result.Value("status").StringValue
		  End If
		  
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = "document.pdf"
		    If result.HasKey("filename") Then
		      filename = result.Value("filename").StringValue
		    End If
		    
		    txtOutput.Text = txtOutput.Text + "Opening preview for: " + filename + EndOfLine
		    
		    // Show in preview window
		    VNSPDFPreviewWindow.ShowPreview(pdfData, filename)
		  Else
		    If result.HasKey("message") Then
		      txtOutput.Text = txtOutput.Text + result.Value("message").StringValue + EndOfLine
		    Else
		      txtOutput.Text = txtOutput.Text + "No PDF data generated." + EndOfLine
		    End If
		  End If
		  
		  txtOutput.Text = txtOutput.Text + EndOfLine
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mSplitterDragging As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSplitterDragStartY As Integer
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
		  Case VNSPDFExamplesModule.kExample5Xojo  // Example 5 Xojo variant
		    GenerateExample5Xojo()
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
		    GenerateExample14Interactive()
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
		    GenerateExample32_Desktop()
		  Case VNSPDFExamplesModule.kExample33
		    GenerateExample33_Desktop()
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
#tag Events btnPreviewExample
	#tag Event
		Sub Pressed()
		  PreviewExample()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SplitterHandle
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas
		  // Draw a subtle splitter bar with grip lines
		  g.DrawingColor = Color.RGB(200, 200, 200)
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  // Draw 3 grip dots in center
		  g.DrawingColor = Color.RGB(140, 140, 140)
		  Dim cx As Integer = g.Width / 2
		  Dim cy As Integer = (g.Height - 4) / 2
		  g.FillOval(cx - 20, cy, 4, 4)
		  g.FillOval(cx - 4, cy, 4, 4)
		  g.FillOval(cx + 12, cy, 4, 4)
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #Pragma Unused x
		  #Pragma Unused y
		  mSplitterDragging = True
		  mSplitterDragStartY = System.MouseY
		  Me.MouseCursor = System.Cursors.SplitterNorthSouth
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  #Pragma Unused x
		  #Pragma Unused y
		  If Not mSplitterDragging Then Return
		  
		  Dim currentY As Integer = System.MouseY
		  Dim delta As Integer = currentY - mSplitterDragStartY
		  If delta = 0 Then Return
		  
		  // Calculate new positions
		  Dim newListHeight As Integer = lstExamples.Height + delta
		  Dim newOutputTop As Integer = txtOutput.Top + delta
		  
		  // Enforce minimums
		  If newListHeight < 100 Then Return
		  If Self.Height - newOutputTop - 20 < 60 Then Return
		  
		  // Resize list
		  lstExamples.Height = newListHeight
		  
		  // Move buttons
		  btnRunExample.Top = btnRunExample.Top + delta
		  btnPreviewExample.Top = btnPreviewExample.Top + delta
		  
		  // Move splitter
		  SplitterHandle.Top = SplitterHandle.Top + delta
		  
		  // Resize output
		  txtOutput.Top = newOutputTop
		  txtOutput.Height = txtOutput.Height - delta
		  
		  mSplitterDragStartY = currentY
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  #Pragma Unused x
		  #Pragma Unused y
		  mSplitterDragging = False
		  Me.MouseCursor = System.Cursors.SplitterNorthSouth
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  Me.MouseCursor = System.Cursors.SplitterNorthSouth
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  Me.MouseCursor = Nil
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="HasTitleBar"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
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
		Name="Interfaces"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
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
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
