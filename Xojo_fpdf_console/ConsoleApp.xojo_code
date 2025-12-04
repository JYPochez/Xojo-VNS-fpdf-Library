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
		  Print("  21. Test Zlib")
		  Print("      Premium pure Xojo compression tests")
		  Print("")
		  Print("  22. Test AES")
		  Print("      Premium pure Xojo encryption tests")
		  Print("")
		  Print("  0. Exit")
		  Print("")

		  While True
		    StdOut.Write("Enter example number (0-22): ")
		    Dim input As String = Input

		    Select Case input.Trim
		    Case "0"
		      Print("")
		      Print("Goodbye!")
		      Return 0

		    Case "1"
		      GenerateExample(1)

		    Case "2"
		      GenerateExample(2)

		    Case "3"
		      GenerateExample(3)

		    Case "4"
		      GenerateExample(4)

		    Case "5"
		      GenerateExample(5)

		    Case "6"
		      GenerateExample(6)

		    Case "7"
		      GenerateExample(7)

		    Case "8"
		      GenerateExample(8)

		    Case "9"
		      GenerateExample(9)

		    Case "10"
		      GenerateExample(10)

		    Case "11"
		      GenerateExample(11)

		    Case "12"
		      GenerateExample(12)

		    Case "13"
		      GenerateExample(13)

		    Case "14"
		      GenerateExample(14)

		    Case "15"
		      GenerateExample(15)

		    Case "16"
		      GenerateExample(16)

		    Case "17"
		      GenerateExample(17)

		    Case "18"
		      GenerateExample(18)

		    Case "19"
		      GenerateExample(19)

		    Case "20"
		      GenerateExample(20)

		    Case "21"
		      RunTest("Zlib")

		    Case "22"
		      RunTest("AES")

		    Else
		      Print("Invalid choice. Please enter 0-22.")
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
		  Else
		    Print("Invalid example number")
		    Return
		  End Select

		  // Display status messages
		  Print(result.Value("status").StringValue)

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

End Class
#tag EndClass
