#tag Class
Protected Class ConsoleApp
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  #Pragma Unused args

		  Print(RepeatString("=", 60))
		  Print("Xojo FPDF Console Application")
		  Print("PDF Generation Examples")
		  Print(RepeatString("=", 60))
		  Print("")

		  // Display menu
		  Print("Available Examples:")
		  Print("")
		  Print("  1. Simple Shapes")
		  Print("     Lines, rectangles, circles with colors")
		  Print("")
		  Print("  2. Text Layouts")
		  Print("     Cell, MultiCell, and Write methods with alignment")
		  Print("")
		  Print("  3. Multiple Pages")
		  Print("     3 pages with circles, rectangles, and ellipses")
		  Print("")
		  Print("  4. Line Widths")
		  Print("     Demonstration of different line widths and styles")
		  Print("")
		  Print("  5. UTF-8 & TrueType Fonts")
		  Print("     TrueType font loading (requires Arial.ttf)")
		  Print("")
		  Print("  6. Text Measurement")
		  Print("     GetStringWidth() for alignment")
		  Print("")
		  Print("  7. Document Metadata")
		  Print("     Title, Author, Subject, Keywords")
		  Print("")
		  Print("  8. Error Handling")
		  Print("     Ok(), Err(), GetError(), SetError(), ClearError()")
		  Print("")
		  Print("  9. Image Support (JPEG)")
		  Print("     JPEG image embedding with DCTDecode filter")
		  Print("")
		  Print("  10. Header/Footer Callbacks")
		  Print("      Automatic headers and footers on every page")
		  Print("")
		  Print("  11. Links and Bookmarks")
		  Print("      Internal links and document bookmarks")
		  Print("")
		  Print("  12. Custom Page Formats")
		  Print("      AddPageFormat() with custom dimensions")
		  Print("")
		  Print("  13. PDF/A Compliance")
		  Print("      ICC color profile embedding for archival PDFs")
		  Print("")
		  Print("  14. Document Encryption")
		  Print("      Password protection and permission restrictions")
		  Print("")
		  Print("  15. Watermark Header")
		  Print("      SetHeaderFuncMode() with background watermark")
		  Print("")
		  Print("  16. Formatting Features")
		  Print("      Printf-style text formatting and font metrics")
		  Print("")
		  Print("  17. Utility Methods")
		  Print("      Version info, conversions, JSON serialization")
		  Print("")
		  Print("  18. Plugin Architecture")
		  Print("      Testing encryption module separation")
		  Print("")
		  Print("  19. Table Generation")
		  Print("      SimpleTable, ImprovedTable, FancyTable (Premium)")
		  Print("")
		  Print("  20. PDF Import")
		  Print("      Import pages from existing PDFs as templates")
		  Print("")
		  Print("  21. UTF-8 All Languages")
		  Print("      All Google Translate supported languages")
		  Print("")
		  Print("  22. UTF Compatibility Wrapper")
		  Print("      VNSPDFGraphicsUTF PDFDocument comparison")
		  Print("")
		  Print("  23. File Attachments")
		  Print("      Document-level and page annotation attachments")
		  Print("")
		  Print("  24. PDF Forms (Premium)")
		  Print("      All 9 control types: TextField, TextArea, CheckBox, etc.")
		  Print("")
		  Print("  25. Test Zlib")
		  Print("      Premium pure Xojo compression tests")
		  Print("")
		  Print("  26. Test AES")
		  Print("      Premium pure Xojo encryption tests")
		  Print("")
		  Print("  29. GraphicsPath")
		  Print("      Curves, arcs, round rectangles, clipping")
		  Print("")
		  Print("  30. E-Invoice (Premium)")
		  Print("      Factur-X/ZUGFeRD compliant PDF with CII XML")
		  Print("")
		  Print("  31. E-Invoice Checker (Premium)")
		  Print("      Check PDF for e-invoice conformity")
		  Print("")
		  Print("  32. Digital Signatures (Premium)")
		  Print("      PAdES-B-B PDF signing + XAdES-BES XML signing")
		  Print("")
		  Print("  33. Barcodes")
		  Print("      QR Code, Code 128, EAN-13, Code 39, ITF, Codabar, PDF417, DataMatrix")
		  Print("")
		  Print("  0. Exit")
		  Print("")

		  While True
		    StdOut.Write("Enter example number (0-32): ")
		    Dim input As String = Input
		    Dim choice As Integer = Val(input.Trim)

		    Select Case choice
		    Case 0
		      Print("")
		      Print("Goodbye!")
		      Return 0

		    Case VNSPDFExamplesModule.kExample1
		      GenerateExample(VNSPDFExamplesModule.kExample1)

		    Case VNSPDFExamplesModule.kExample2
		      GenerateExample(VNSPDFExamplesModule.kExample2)

		    Case VNSPDFExamplesModule.kExample3
		      GenerateExample(VNSPDFExamplesModule.kExample3)

		    Case VNSPDFExamplesModule.kExample4
		      GenerateExample(VNSPDFExamplesModule.kExample4)

		    Case VNSPDFExamplesModule.kExample5
		      GenerateExample(VNSPDFExamplesModule.kExample5)

		    Case VNSPDFExamplesModule.kExample6
		      GenerateExample(VNSPDFExamplesModule.kExample6)

		    Case VNSPDFExamplesModule.kExample7
		      GenerateExample(VNSPDFExamplesModule.kExample7)

		    Case VNSPDFExamplesModule.kExample8
		      GenerateExample(VNSPDFExamplesModule.kExample8)

		    Case VNSPDFExamplesModule.kExample9
		      GenerateExample(VNSPDFExamplesModule.kExample9)

		    Case VNSPDFExamplesModule.kExample10
		      GenerateExample(VNSPDFExamplesModule.kExample10)

		    Case VNSPDFExamplesModule.kExample11
		      GenerateExample(VNSPDFExamplesModule.kExample11)

		    Case VNSPDFExamplesModule.kExample12
		      GenerateExample(VNSPDFExamplesModule.kExample12)

		    Case VNSPDFExamplesModule.kExample13
		      GenerateExample(VNSPDFExamplesModule.kExample13)

		    Case VNSPDFExamplesModule.kExample14
		      GenerateExample(VNSPDFExamplesModule.kExample14)

		    Case VNSPDFExamplesModule.kExample15
		      GenerateExample(VNSPDFExamplesModule.kExample15)

		    Case VNSPDFExamplesModule.kExample16
		      GenerateExample(VNSPDFExamplesModule.kExample16)

		    Case VNSPDFExamplesModule.kExample17
		      GenerateExample(VNSPDFExamplesModule.kExample17)

		    Case VNSPDFExamplesModule.kExample18
		      GenerateExample(VNSPDFExamplesModule.kExample18)

		    Case VNSPDFExamplesModule.kExample19
		      GenerateExample(VNSPDFExamplesModule.kExample19)

		    Case VNSPDFExamplesModule.kExample20
		      GenerateExample(VNSPDFExamplesModule.kExample20)

		    Case VNSPDFExamplesModule.kExample21
		      GenerateExample(VNSPDFExamplesModule.kExample21)

		    Case VNSPDFExamplesModule.kExample22
		      GenerateExample(VNSPDFExamplesModule.kExample22)

		    Case VNSPDFExamplesModule.kExample23
		      GenerateExample(VNSPDFExamplesModule.kExample23)

		    Case VNSPDFExamplesModule.kExample24
		      GenerateExample(VNSPDFExamplesModule.kExample24)

		    Case VNSPDFExamplesModule.kExample26
		      GenerateExample(VNSPDFExamplesModule.kExample26)

		    Case VNSPDFExamplesModule.kExample29
		      GenerateExample(VNSPDFExamplesModule.kExample29)

		    Case VNSPDFExamplesModule.kExample30
		      GenerateExample(VNSPDFExamplesModule.kExample30)

		    Case VNSPDFExamplesModule.kExample31
		      GenerateExample(VNSPDFExamplesModule.kExample31)

		    Case VNSPDFExamplesModule.kExample32
		      GenerateExample(VNSPDFExamplesModule.kExample32)

		    Case VNSPDFExamplesModule.kExample33
		      GenerateExample(VNSPDFExamplesModule.kExample33)

		    Case VNSPDFExamplesModule.kTestZlib
		      RunTest("Zlib")

		    Case VNSPDFExamplesModule.kTestAES
		      RunTest("AES")

		    Else
		      Print("Invalid choice. Please enter 0-32.")
		      Print("")
		    End Select
		  Wend

		  Return 0
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub GenerateExample(exampleNum As Integer)
		  Print("")
		  Print(RepeatString("-", 60))

		  Dim result As Dictionary

		  // Call the appropriate example from shared module
		  Select Case exampleNum
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
		    // Example 14: Document Encryption (use RC4-40 which is available in FREE version)
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
		    // Example 20: PDF Import - uses default path to example19
		    result = VNSPDFExamplesModule.GenerateExample20("")
		  Case kExample21
		    result = VNSPDFExamplesModule.GenerateExample21()
		  Case kExample22
		    result = VNSPDFExamplesModule.GenerateExample22()
		  Case kExample23
		    result = VNSPDFExamplesModule.GenerateExample23()
		  Case kExample24
		    result = VNSPDFExamplesModule.GenerateExample24()
		  Case kExample26
		    result = VNSPDFExamplesModule.GenerateExample26_BugTests()
		  Case kExample29
		    result = VNSPDFExamplesModule.GenerateExample29()
		  Case kExample30
		    Print(VNSPDFExamplesModule.kEInvoiceCountryPrompt)
		    Dim cc30 As String = Input.Trim.Uppercase
		    If cc30 = "" Then cc30 = "FR"
		    result = VNSPDFExamplesModule.GenerateExample30(cc30)
		  Case kExample32
		    Print(VNSPDFExamplesModule.kEInvoiceCountryPrompt)
		    Dim cc32 As String = Input.Trim.Uppercase
		    If cc32 = "" Then cc32 = "FR"
		    result = VNSPDFExamplesModule.GenerateExample32(cc32)
		  Case kExample33
		    result = VNSPDFExamplesModule.GenerateExample33_Barcodes()
		  Case kExample31
		    // E-Invoice Checker - read PDF file
		    Print("Enter path to PDF file (or press Enter for default example30 PDF):")
		    Dim pdfPath As String = Input
		    If pdfPath = "" Then
		      Dim desktop As FolderItem = SpecialFolder.Desktop
		      pdfPath = desktop.Child("example30_einvoice.pdf").NativePath
		    End If
		    Dim pdfFile As FolderItem = New FolderItem(pdfPath, FolderItem.PathModes.Native)
		    If pdfFile = Nil Or Not pdfFile.Exists Then
		      Print("File not found: " + pdfPath)
		      Print("")
		      Return
		    Else
		      Dim bs As BinaryStream = BinaryStream.Open(pdfFile)
		      Dim pdfData As String = bs.Read(bs.Length)
		      bs.Close
		      result = VNSPDFExamplesModule.GenerateExample31_CheckEInvoice(pdfData)
		    End If
		  Else
		    Print("Invalid example number")
		    Return
		  End Select

		  // Display status messages
		  Print(result.Value("message").StringValue)

		  // Save PDF if successful
		  If result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf").StringValue
		    Dim filename As String = result.Value("filename").StringValue

		    Try
		      // Save to desktop
		      Dim desktop As FolderItem = SpecialFolder.Desktop
		      Dim f As FolderItem = desktop.Child(filename)
		      Dim stream As BinaryStream = BinaryStream.Create(f, True)
		      stream.Write(pdfData)
		      stream.Close()

		      Print("PDF saved: " + f.NativePath)
		      Print("File size: " + Str(pdfData.Bytes) + " bytes")

		    Catch e As IOException
		      Print("Error saving file: " + e.Message)
		    End Try
		  End If

		  // Save credit note if generated
		  If result.HasKey("pdf2") Then
		    Dim pdfData2 As String = result.Value("pdf2").StringValue
		    Dim filename2 As String = result.Value("filename2").StringValue
		    Try
		      Dim desktop2 As FolderItem = SpecialFolder.Desktop
		      Dim f2 As FolderItem = desktop2.Child(filename2)
		      Dim stream2 As BinaryStream = BinaryStream.Create(f2, True)
		      stream2.Write(pdfData2)
		      stream2.Close()
		      Print("Credit note saved: " + f2.NativePath)
		    Catch e As IOException
		      Print("Error saving credit note: " + e.Message)
		    End Try
		  End If

		  Print(RepeatString("-", 60))
		  Print("")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RepeatString(s As String, count As Integer) As String
		  // Helper method to repeat a string n times
		  Dim result As String = ""
		  For i As Integer = 1 To count
		    result = result + s
		  Next
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunTest(testName As String)
		  Print("")
		  Print(RepeatString("-", 60))
		  Print("Running " + testName + " Premium Tests...")
		  Print("")

		  Dim result As Dictionary

		  // Call the appropriate test from shared module
		  Select Case testName
		  Case "Zlib"
		    result = VNSPDFExamplesModule.TestZlib()
		  Case "AES"
		    result = VNSPDFExamplesModule.TestAES()
		  Else
		    Print("Unknown test: " + testName)
		    Return
		  End Select

		  // Display test results
		  Dim passed As Boolean = result.Value("passed")
		  Dim output As String = result.Value("output")

		  Print(output)

		  If passed Then
		    Print("")
		    Print("ALL " + testName.Uppercase + " TESTS PASSED!")
		  Else
		    Print("")
		    Print("SOME " + testName.Uppercase + " TESTS FAILED!")
		  End If

		  Print(RepeatString("-", 60))
		  Print("")
		End Sub
	#tag EndMethod


End Class
#tag EndClass
