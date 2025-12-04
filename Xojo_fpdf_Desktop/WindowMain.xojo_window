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
      Caption         =   "Run Example"
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
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   462
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   860
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
      Height          =   174
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
      Top             =   506
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
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
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample1
		  
		  lstExamples.AddRow("Example 2", "Text layouts: Cell, MultiCell, Write methods")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample2
		  
		  lstExamples.AddRow("Example 3", "Multiple pages with various shapes")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample3

		  lstExamples.AddRow("Example 4", "Line widths and styles")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample4

		  lstExamples.AddRow("Example 5", "UTF-8 & TrueType fonts")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample5

		  lstExamples.AddRow("Example 5 (Xojo)", "TrueType font with Xojo font path")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample5Xojo

		  lstExamples.AddRow("Example 6", "Text measurement: GetStringWidth()")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample6
		  
		  lstExamples.AddRow("Example 7", "Document metadata")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample7

		  lstExamples.AddRow("Example 8", "Error handling: Ok/Err/GetError")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample8

		  lstExamples.AddRow("Example 9", "Image support: JPEG, PNG, programmatic graphics")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample9

		  lstExamples.AddRow("Example 10", "Header/Footer callbacks")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample10

		  lstExamples.AddRow("Example 11", "Links and bookmarks")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample11

		  lstExamples.AddRow("Example 12", "Custom page formats")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample12
		  
		  lstExamples.AddRow("Example 13", "PDF/A compliance")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample13

		  lstExamples.AddRow("Example 14", "Document encryption")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample14

		  lstExamples.AddRow("Example 15", "Watermark header")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample15

		  lstExamples.AddRow("Example 16", "Formatting features")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample16

		  lstExamples.AddRow("Example 17", "Utility methods")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample17

		  lstExamples.AddRow("Example 18", "Plugin architecture")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample18
		  
		  lstExamples.AddRow("Example 19", "Table generation")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample19

		  lstExamples.AddRow("Example 20", "PDF import: Import pages from existing PDFs")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kExample20

		  lstExamples.AddRow("Test Zlib", "Premium pure Xojo compression tests")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kTestZlib

		  lstExamples.AddRow("Test AES", "Premium pure Xojo encryption tests")
		  lstExamples.CellTagAt(lstExamples.LastAddedRowIndex, 0) = kTestAES
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub GenerateExample1()
		  // Use shared examples module
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample1()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("status").StringValue
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		    txtOutput.Text = txtOutput.Text + result.Value("status")
		    
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample3()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		Private Sub GenerateExample4()
		  // Call shared module function
		  Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample4()
		  
		  // Display status
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  txtOutput.Text = txtOutput.Text + result.Value("status")
		  
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
		  Case kExample1
		    GenerateExample1()
		  Case kExample2
		    GenerateExample2()
		  Case kExample3
		    GenerateExample3()
		  Case kExample4
		    GenerateExample4()
		  Case kExample5
		    GenerateExample5()
		  Case kExample5Xojo  // Example 5 Xojo variant
		    GenerateExample5Xojo()
		  Case kExample6
		    GenerateExample6()
		  Case kExample7
		    GenerateExample7()
		  Case kExample8
		    GenerateExample8()
		  Case kExample9
		    GenerateExample9()
		  Case kExample10
		    GenerateExample10()
		  Case kExample11
		    GenerateExample11()
		  Case kExample12
		    GenerateExample12()
		  Case kExample13
		    GenerateExample13()
		  Case kExample14
		    GenerateExample14Interactive()
		  Case kExample15
		    GenerateExample15()
		  Case kExample16
		    GenerateExample16()
		  Case kExample17
		    GenerateExample17()
		  Case kExample18
		    GenerateExample18()
		  Case kExample19
		    GenerateExample19()
		  Case kExample20
		    GenerateExample20()
		  Case kTestZlib
		    RunTestZlib()
		  Case kTestAES
		    RunTestAES()
		  Else
		    txtOutput.Text = txtOutput.Text + "Unknown example number: " + exampleNum.StringValue + EndOfLine
		  End Select
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

	#tag Constant, Name = kExample5Xojo, Type = Double, Dynamic = False, Default = \"51", Scope = Private
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
