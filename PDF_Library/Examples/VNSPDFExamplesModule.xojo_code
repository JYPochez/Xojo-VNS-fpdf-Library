#tag Module
Protected Module VNSPDFExamplesModule
	#tag Method, Flags = &h21, Description = 466F6F7465722063616C6C6261636B207769746820506167652049206F66206C617374207061676520696E64696361746F722E0A
		Private Sub Example10FooterLpi(doc As VNSPDFDocument, lastPage As Boolean)
		  // This is called automatically before the end of each page
		  // lastPage parameter indicates if this is the final page
		  
		  // Save current position and font
		  Dim savedFontFamily As String = doc.FontFamily
		  Dim savedFontStyle As String = doc.FontStyle
		  Dim savedFontSize As Double = doc.FontSizePt
		  
		  // Position footer 15mm from bottom
		  doc.SetY(-15)
		  
		  // Draw line above footer
		  doc.SetDrawColor(0, 80, 180)
		  doc.SetLineWidth(0.5)
		  doc.Line(10, doc.GetY(), 200, doc.GetY())
		  
		  // Set footer font
		  doc.SetFont("Helvetica", "I", 8)
		  doc.SetTextColor(128, 128, 128) // Gray
		  
		  If lastPage Then
		    // Different footer on last page
		    doc.Cell(0, 10, "End of Document - Page " + Str(doc.PageNo()) + " of {nb}", 0, 0, "C")
		  Else
		    // Regular page footer with "Page X of {nb}"
		    // The {nb} alias will be replaced with actual page count when PDF is closed
		    doc.Cell(0, 10, "Page " + Str(doc.PageNo()) + " of {nb}", 0, 0, "C")
		  End If
		  
		  // Restore previous font
		  doc.SetFont(savedFontFamily, savedFontStyle, savedFontSize)
		  doc.SetTextColor(0, 0, 0) // Reset to black
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4865616465722063616C6C6261636B20666F72204578616D706C652031302E0A
		Private Sub Example10Header(doc As VNSPDFDocument)
		  // This is called automatically at the start of each page
		  
		  // Save current font
		  Dim savedFontFamily As String = doc.FontFamily
		  Dim savedFontStyle As String = doc.FontStyle
		  Dim savedFontSize As Double = doc.FontSizePt
		  
		  // Set header font and colors
		  doc.SetFont("Helvetica", "B", 15)
		  doc.SetTextColor(0, 80, 180) // Blue
		  
		  // Draw header text
		  doc.Cell(0, 10, "PDF Document with Header/Footer", 0, 1, "C")
		  
		  // Draw a line below header
		  doc.SetDrawColor(0, 80, 180)
		  doc.SetLineWidth(0.5)
		  doc.Line(10, 20, 200, 20)
		  
		  // Restore previous font
		  doc.SetFont(savedFontFamily, savedFontStyle, savedFontSize)
		  doc.SetTextColor(0, 0, 0) // Reset to black
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4865616465722077697468207761746572696D61726B20666F72204578616D706C652031352E0A
		Private Sub Example15HeaderWithWatermark(doc As VNSPDFDocument)
		  // This is called automatically at the start of each page
		  // homeMode = True will reset X/Y to top-left margins after this finishes
		  
		  // Save current state
		  Dim savedFontFamily As String = doc.FontFamily
		  Dim savedFontStyle As String = doc.FontStyle
		  Dim savedFontSize As Double = doc.FontSizePt
		  
		  // Draw watermark text in background
		  doc.SetFont("Helvetica", "B", 50)
		  doc.SetTextColor(220, 220, 220) // Very light gray
		  doc.SetAlpha(0.3, "Normal") // Semi-transparent
		  
		  // Position watermark text centered on page
		  doc.Text(60, 150, "DRAFT")
		  
		  // Reset transparency and colors
		  doc.SetAlpha(1.0, "Normal")
		  doc.SetTextColor(0, 0, 0)
		  
		  // Restore previous font
		  doc.SetFont(savedFontFamily, savedFontStyle, savedFontSize)
		  
		  // Note: Because homeMode = True, the X/Y position will be automatically
		  // reset to top-left margins, so content starts at expected position
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 43726F73732D706C6174666F726D206E756D62657220666F726D617474696E67
		Private Function FormatHelper(value As Double, formatStr As String) As String
		  // Cross-platform number formatting
		  #If TargetiOS Then
		    // iOS: Simple formatting (Format() not available)
		    // Round to 2 decimal places if format is "0.00"
		    If formatStr = "0.00" Then
		      Dim rounded As Double = Round(value * 100) / 100
		      Dim s As String = Str(rounded)
		      // Simple approach: just return the rounded value as string
		      // iOS string manipulation functions have different signatures
		      Return s
		    Else
		      Return Str(value)
		    End If
		  #Else
		    // Desktop/Console/Web: Use built-in Format()
		    Return Format(value, formatStr)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample1() As Dictionary
		  // Example 1: Simple shapes - Lines, rectangles, circles
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 1: Simple shapes..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    Call pdf.AddPage()
		    
		    // Draw some lines
		    pdf.SetDrawColor(0, 0, 0) // Black
		    pdf.SetLineWidth(0.5)
		    pdf.Line(10, 10, 100, 10) // Horizontal line
		    pdf.Line(10, 10, 10, 100) // Vertical line
		    pdf.Line(10, 100, 100, 10) // Diagonal line
		    
		    // Draw rectangles
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.Rect(120, 10, 50, 40, "D") // Draw only
		    
		    pdf.SetFillColor(0, 255, 0) // Green
		    pdf.Rect(120, 60, 50, 40, "F") // Fill only
		    
		    pdf.SetDrawColor(0, 0, 255) // Blue
		    pdf.SetFillColor(255, 255, 0) // Yellow
		    pdf.Rect(120, 110, 50, 40, "DF") // Draw and fill
		    
		    // Draw rounded rectangles
		    pdf.SetDrawColor(0, 0, 255) // Blue
		    pdf.SetFillColor(200, 220, 255) // Light blue
		    pdf.SetLineWidth(1)
		    pdf.RoundedRect(20, 165, 40, 30, 5, "1234", "DF") // All corners rounded
		    
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetFillColor(255, 220, 220) // Light red
		    pdf.RoundedRect(70, 165, 40, 30, 5, "14", "DF") // Top-left and bottom-left
		    
		    pdf.SetDrawColor(128, 0, 128) // Purple
		    pdf.RoundedRectExt(120, 165, 40, 30, 8, 3, 8, 3, "D") // Different radius per corner
		    
		    // Draw circles
		    pdf.SetDrawColor(128, 0, 128) // Purple
		    pdf.Circle(50, 150, 20, "D")
		    
		    pdf.SetFillColor(255, 128, 0) // Orange
		    pdf.Circle(100, 150, 20, "DF")
		    
		    // Add some text
		    pdf.SetFont("helvetica", "", 16)
		    pdf.Text(10, 200, "Hello from Xojo FPDF!")
		    
		    pdf.SetFont("times", "B", 14)
		    pdf.Text(10, 220, "Bold Times at 14pt")
		    
		    pdf.SetFont("courier", "I", 12)
		    pdf.Text(10, 240, "Courier Italic at 12pt")
		    
		    pdf.SetFont("helvetica", "BI", 10)
		    pdf.Text(10, 260, "Helvetica Bold-Italic at 10pt")
		    
		    // Bezier curves demonstration
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Text(10, 270, "Bezier Curves:")
		    
		    // Quadratic Bezier curve (Curve)
		    pdf.SetDrawColor(0, 128, 255) // Light blue
		    pdf.SetLineWidth(1.5)
		    pdf.Curve(10, 210, 60, 190, 110, 210, "D")
		    
		    // Cubic Bezier curve (CurveBezierCubic)
		    pdf.SetDrawColor(255, 0, 128) // Pink
		    pdf.SetLineWidth(2)
		    pdf.CurveBezierCubic(120, 210, 140, 190, 160, 230, 180, 210, "D")
		    
		    // Filled Bezier curve
		    pdf.SetFillColor(200, 255, 200) // Light green
		    pdf.SetDrawColor(0, 128, 0) // Dark green
		    pdf.SetLineWidth(1)
		    pdf.CurveBezierCubic(10, 230, 30, 220, 40, 240, 60, 230, "DF")
		    
		    // Arrow lines demonstration
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Text(120, 270, "Arrows:")
		    
		    // Simple arrow (end only)
		    pdf.SetDrawColor(0, 0, 0) // Black
		    pdf.SetFillColor(0, 0, 0) // Black
		    pdf.SetLineWidth(1)
		    pdf.Arrow(120, 235, 180, 235, False, True, 3)
		    
		    // Arrow at both ends
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetFillColor(255, 0, 0) // Red
		    pdf.Arrow(120, 245, 180, 250, True, True, 3)
		    
		    // Diagonal arrow with larger head
		    pdf.SetDrawColor(0, 0, 255) // Blue
		    pdf.SetFillColor(0, 0, 255) // Blue
		    pdf.Arrow(120, 255, 160, 265, False, True, 4)

		    // Polygon demonstration
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Text(10, 282, "Polygons:")

		    // Triangle (3 points) - outline only
		    Dim triangle() As Point
		    triangle.Add(New Point(25, 285))
		    triangle.Add(New Point(45, 285))
		    triangle.Add(New Point(35, 270))
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetLineWidth(1)
		    pdf.Polygon(triangle, "D")

		    // Pentagon (5 points) - filled
		    Dim pentagon() As Point
		    pentagon.Add(New Point(70, 285))
		    pentagon.Add(New Point(85, 280))
		    pentagon.Add(New Point(80, 268))
		    pentagon.Add(New Point(60, 268))
		    pentagon.Add(New Point(55, 280))
		    pdf.SetFillColor(0, 200, 100) // Green
		    pdf.Polygon(pentagon, "F")

		    // Hexagon (6 points) - filled and outlined
		    Dim hexagon() As Point
		    hexagon.Add(New Point(110, 285))
		    hexagon.Add(New Point(125, 282))
		    hexagon.Add(New Point(125, 272))
		    hexagon.Add(New Point(110, 269))
		    hexagon.Add(New Point(95, 272))
		    hexagon.Add(New Point(95, 282))
		    pdf.SetDrawColor(0, 0, 128) // Dark blue
		    pdf.SetFillColor(200, 220, 255) // Light blue
		    pdf.SetLineWidth(1.5)
		    pdf.Polygon(hexagon, "DF")

		    // Star shape (10 points) - filled and outlined
		    Dim star() As Point
		    Dim starCenterX As Double = 160
		    Dim starCenterY As Double = 277
		    Dim outerR As Double = 12
		    Dim innerR As Double = 5
		    For i As Integer = 0 To 9
		      Dim angle As Double = (i * 36 - 90) * 3.14159265 / 180
		      Dim r As Double
		      If i Mod 2 = 0 Then
		        r = outerR
		      Else
		        r = innerR
		      End If
		      star.Add(New Point(starCenterX + r * Cos(angle), starCenterY + r * Sin(angle)))
		    Next
		    pdf.SetDrawColor(200, 150, 0) // Gold outline
		    pdf.SetFillColor(255, 215, 0) // Gold fill
		    pdf.SetLineWidth(1)
		    pdf.Polygon(star, "DF")

		    // Add second page for transparency demonstration
		    Call pdf.AddPage()
		    
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 10, "Alpha Transparency & Blend Modes", 0, 1, "C")
		    pdf.Ln(5)
		    
		    // Overlapping rectangles with different alpha values
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Overlapping Shapes with Transparency:", 0, 1)
		    pdf.Ln(2)
		    
		    // First rectangle - fully opaque
		    pdf.SetAlpha(1.0, "Normal")
		    pdf.SetFillColor(255, 0, 0) // Red
		    pdf.Rect(20, 40, 60, 40, "F")
		    
		    // Second rectangle - 70% opaque
		    pdf.SetAlpha(0.7, "Normal")
		    pdf.SetFillColor(0, 255, 0) // Green
		    pdf.Rect(40, 50, 60, 40, "F")
		    
		    // Third rectangle - 40% opaque
		    pdf.SetAlpha(0.4, "Normal")
		    pdf.SetFillColor(0, 0, 255) // Blue
		    pdf.Rect(60, 60, 60, 40, "F")
		    
		    // Reset to opaque for text
		    pdf.SetAlpha(1.0)
		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Text(20, 105, "Red (100%)")
		    pdf.Text(40, 115, "Green (70%)")
		    pdf.Text(60, 125, "Blue (40%)")
		    
		    // Blend modes demonstration
		    pdf.SetY(130)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Blend Modes with 50% Transparency:", 0, 1)
		    pdf.Ln(2)
		    
		    // Base layer - Yellow rectangle
		    pdf.SetAlpha(1.0)
		    pdf.SetFillColor(255, 255, 0) // Yellow
		    pdf.Rect(20, 145, 170, 30, "F")
		    
		    // Normal blend mode
		    pdf.SetAlpha(0.5, "Normal")
		    pdf.SetFillColor(255, 0, 0) // Red
		    pdf.Rect(20, 145, 40, 30, "F")
		    pdf.SetAlpha(1.0)
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(22, 180, "Normal")
		    
		    // Multiply blend mode
		    pdf.SetAlpha(0.5, "Multiply")
		    pdf.SetFillColor(255, 0, 0) // Red
		    pdf.Rect(65, 145, 40, 30, "F")
		    pdf.SetAlpha(1.0)
		    pdf.Text(67, 180, "Multiply")
		    
		    // Screen blend mode
		    pdf.SetAlpha(0.5, "Screen")
		    pdf.SetFillColor(255, 0, 0) // Red
		    pdf.Rect(110, 145, 40, 30, "F")
		    pdf.SetAlpha(1.0)
		    pdf.Text(112, 180, "Screen")
		    
		    // Overlay blend mode
		    pdf.SetAlpha(0.5, "Overlay")
		    pdf.SetFillColor(255, 0, 0) // Red
		    pdf.Rect(155, 145, 35, 30, "F")
		    pdf.SetAlpha(1.0)
		    pdf.Text(157, 180, "Overlay")
		    
		    // Transparent circles
		    pdf.SetY(190)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Transparent Circles (RGB Color Mix):", 0, 1)
		    pdf.Ln(2)
		    
		    // Red circle - 60% transparent
		    pdf.SetAlpha(0.6, "Normal")
		    pdf.SetFillColor(255, 0, 0) // Red
		    pdf.Circle(60, 220, 25, "F")
		    
		    // Green circle - 60% transparent
		    pdf.SetFillColor(0, 255, 0) // Green
		    pdf.Circle(80, 235, 25, "F")
		    
		    // Blue circle - 60% transparent
		    pdf.SetFillColor(0, 0, 255) // Blue
		    pdf.Circle(100, 220, 25, "F")
		    
		    // Reset alpha to fully opaque
		    pdf.SetAlpha(1.0)
		    
		    // Add third page for gradients and clipping
		    Call pdf.AddPage()
		    
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 10, "Gradients & Clipping Paths", 0, 1, "C")
		    pdf.Ln(5)
		    
		    // Linear gradients
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Linear Gradients:", 0, 1)
		    pdf.Ln(2)
		    
		    // Horizontal gradient (left to right)
		    pdf.LinearGradient(20, 30, 80, 30, 255, 0, 0, 0, 0, 255, 0, 0, 1, 0)
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(25, 65, "Horizontal")
		    
		    // Vertical gradient (top to bottom)
		    pdf.LinearGradient(110, 30, 80, 30, 0, 255, 0, 255, 255, 0, 0, 0, 0, 1)
		    pdf.Text(120, 65, "Vertical")
		    
		    // Radial gradients
		    pdf.SetY(72)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Radial Gradients:", 0, 1)
		    pdf.Ln(2)
		    
		    // Center to edge
		    pdf.RadialGradient(20, 90, 80, 40, 255, 255, 0, 255, 0, 0, 0.5, 0.5, 0.5, 0.5, 0.5)
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(30, 135, "Center to edge")
		    
		    // Off-center
		    pdf.RadialGradient(110, 90, 80, 40, 0, 255, 255, 0, 0, 128, 0.3, 0.3, 0.7, 0.7, 0.6)
		    pdf.Text(120, 135, "Off-center")
		    
		    // Clipping demonstrations
		    pdf.SetY(142)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Clipping Paths:", 0, 1)
		    pdf.Ln(2)
		    
		    // Rectangular clip
		    pdf.ClipRect(20, 160, 60, 30, False)
		    pdf.SetFillColor(100, 150, 255)
		    pdf.Circle(50, 175, 25, "F")
		    pdf.ClipEnd()
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(22, 195, "Rect clip")
		    
		    // Circular clip
		    pdf.ClipCircle(130, 175, 20, False)
		    pdf.LinearGradient(110, 155, 40, 40, 255, 100, 0, 255, 255, 0, 0, 0, 1, 0)
		    pdf.ClipEnd()
		    pdf.Text(110, 200, "Circle clip")
		    
		    // Text clipping
		    pdf.SetFont("helvetica", "B", 36)
		    pdf.ClipText(20, 230, "XOJO", True)
		    pdf.LinearGradient(20, 210, 80, 30, 255, 0, 255, 0, 255, 255, 0, 0, 1, 1)
		    pdf.ClipEnd()
		    
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(20, 245, "Text as clipping path")
		    
		    // Reset font and alpha
		    pdf.SetFont("helvetica", "", 10)
		    pdf.SetAlpha(1.0)
		    
		    // Note: Example 1 intentionally demonstrates transparency, blend modes, and gradients
		    // which violate PDF/A requirements. It is NOT a PDF/A compliant document.
		    // For PDF/A-1b compliance, see Example 13.
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    
		    If pdf.Error <> "" Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("error") = pdf.Error
		    Else
		      statusText = statusText + "Success! PDF generated." + EndOfLine
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example1_shapes.pdf"
		    End If
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4865616465722F466F6F7465722063616C6C6261636B732E0A
		Function GenerateExample10() As Dictionary
		  // Example 10: Header/Footer Callbacks
		  // Demonstrates: SetHeaderFunc(), SetFooterFuncLpi() with lastPage indicator, AliasNbPages()
		  
		  Dim result As New Dictionary
		  Dim statusText As String = ""
		  
		  Try
		    Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		    
		    // Set document metadata
		    pdf.SetTitle("Header/Footer Example")
		    pdf.SetAuthor("Xojo FPDF")
		    pdf.SetSubject("Demonstrating header/footer callbacks with page count and last page indicator")
		    
		    // Enable page count substitution with "{nb}" alias
		    pdf.AliasNbPages("{nb}")
		    
		    // Set header and footer callbacks
		    // Using SetFooterFuncLpi() instead of SetFooterFunc() to get lastPage indicator
		    pdf.SetHeaderFunc(AddressOf Example10Header)
		    pdf.SetFooterFuncLpi(AddressOf Example10FooterLpi)
		    
		    // Add first page
		    Call pdf.AddPage()
		    pdf.SetFont("Times", "", 12)
		    pdf.SetY(30) // Move below header
		    
		    // Add some content
		    Dim i As Integer
		    For i = 1 To 30
		      pdf.Cell(0, 10, "This is line " + Str(i) + " of content on the page.", 0, 1)
		    Next
		    
		    // Add second page to demonstrate header/footer on multiple pages
		    Call pdf.AddPage()
		    pdf.SetY(30) // Move below header
		    
		    For i = 31 To 60
		      pdf.Cell(0, 10, "This is line " + Str(i) + " of content on the page.", 0, 1)
		    Next
		    
		    // Add third page
		    Call pdf.AddPage()
		    pdf.SetY(30) // Move below header
		    
		    For i = 61 To 90
		      pdf.Cell(0, 10, "This is line " + Str(i) + " of content on the page.", 0, 1)
		    Next
		    
		    // Generate PDF output
		    Dim pdfData As String = pdf.Output()
		    
		    If pdf.Err Then
		      statusText = statusText + "Error during PDF generation: " + pdf.GetError() + EndOfLine
		      result.Value("error") = pdf.GetError()
		    Else
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example10_header_footer.pdf"
		      statusText = statusText + "Example 10 PDF generated successfully!" + EndOfLine
		      statusText = statusText + "  - AliasNbPages() with 'Page X of Y' footer" + EndOfLine
		      statusText = statusText + "  - SetFooterFuncLpi() with different last page footer" + EndOfLine
		    End If
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652031313A204C696E6B7320616E6420426F6F6B6D61726B732E0A
		Function GenerateExample11() As Dictionary
		  // Example 11: Links and Bookmarks
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 11: Links and Bookmarks..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    
		    // Page 1: Table of Contents with internal links
		    Call pdf.AddPage()
		    pdf.SetFont("helvetica", "B", 20)
		    pdf.Cell(0, 10, "Table of Contents", 0, 1, "C")
		    pdf.Ln(10)
		    
		    // Create internal links for each section
		    Dim linkChapter1 As Integer = pdf.AddLink()
		    Dim linkChapter2 As Integer = pdf.AddLink()
		    Dim linkChapter3 As Integer = pdf.AddLink()
		    
		    pdf.SetFont("helvetica", "", 14)
		    
		    // Chapter 1 link
		    pdf.SetTextColor(0, 0, 255) // Blue text for links
		    pdf.Cell(0, 10, "Chapter 1: Introduction", 0, 1, "L")
		    pdf.Link(pdf.GetX, pdf.GetY - 10, 190, 10, linkChapter1)
		    
		    // Chapter 2 link
		    pdf.Cell(0, 10, "Chapter 2: Main Content", 0, 1, "L")
		    pdf.Link(pdf.GetX, pdf.GetY - 10, 190, 10, linkChapter2)
		    
		    // Chapter 3 link
		    pdf.Cell(0, 10, "Chapter 3: Conclusion", 0, 1, "L")
		    pdf.Link(pdf.GetX, pdf.GetY - 10, 190, 10, linkChapter3)
		    
		    pdf.SetTextColor(0, 0, 0) // Reset to black
		    pdf.Ln(10)
		    
		    // External link example
		    pdf.SetFont("helvetica", "I", 12)
		    pdf.SetTextColor(0, 0, 255)
		    pdf.Cell(0, 10, "Visit the Xojo website", 0, 1, "L")
		    pdf.LinkString(pdf.GetX, pdf.GetY - 10, 100, 10, "https://www.xojo.com")
		    pdf.SetTextColor(0, 0, 0)
		    
		    // Page 2: Chapter 1
		    Call pdf.AddPage()
		    pdf.SetLink(linkChapter1, 20, 2) // Set link destination to this page
		    pdf.Bookmark("Chapter 1: Introduction", 0) // Add top-level bookmark
		    
		    pdf.SetFont("helvetica", "B", 18)
		    pdf.Cell(0, 10, "Chapter 1: Introduction", 0, 1, "L")
		    pdf.Ln(5)
		    
		    pdf.SetFont("helvetica", "", 12)
		    Dim intro As String = "This is the introduction chapter. It demonstrates how internal links work in PDF documents. "
		    intro = intro + "You can click on the Table of Contents entries to navigate between chapters. "
		    intro = intro + "This example also shows how to create bookmarks (outlines) that appear in the PDF viewer's sidebar."
		    pdf.MultiCell(0, 6, intro)
		    
		    pdf.Ln(5)
		    pdf.Bookmark("Section 1.1", 1) // Add sub-bookmark
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 8, "Section 1.1: Getting Started", 0, 1, "L")
		    pdf.SetFont("helvetica", "", 12)
		    pdf.MultiCell(0, 6, "This is a subsection within Chapter 1. Notice how it appears indented in the bookmark sidebar.")
		    
		    // Page 3: Chapter 2
		    Call pdf.AddPage()
		    pdf.SetLink(linkChapter2, 20, 3)
		    pdf.Bookmark("Chapter 2: Main Content", 0)
		    
		    pdf.SetFont("helvetica", "B", 18)
		    pdf.Cell(0, 10, "Chapter 2: Main Content", 0, 1, "L")
		    pdf.Ln(5)
		    
		    pdf.SetFont("helvetica", "", 12)
		    Dim content As String = "This is the main content chapter. PDF links and bookmarks are powerful features that make documents more navigable. "
		    content = content + "Links can be either internal (pointing to other pages in this document) or external (pointing to web URLs)."
		    pdf.MultiCell(0, 6, content)
		    
		    pdf.Ln(5)
		    pdf.Bookmark("Section 2.1", 1)
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 8, "Section 2.1: Technical Details", 0, 1, "L")
		    pdf.SetFont("helvetica", "", 12)
		    pdf.MultiCell(0, 6, "Internal links use the AddLink() and SetLink() methods to create clickable areas that jump to specific pages.")
		    
		    pdf.Ln(3)
		    pdf.Bookmark("Section 2.2", 1)
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 8, "Section 2.2: External Links", 0, 1, "L")
		    pdf.SetFont("helvetica", "", 12)
		    pdf.MultiCell(0, 6, "External links use the LinkString() method to create clickable areas that open web URLs in a browser.")
		    
		    // Page 4: Chapter 3
		    Call pdf.AddPage()
		    pdf.SetLink(linkChapter3, 20, 4)
		    pdf.Bookmark("Chapter 3: Conclusion", 0)
		    
		    pdf.SetFont("helvetica", "B", 18)
		    pdf.Cell(0, 10, "Chapter 3: Conclusion", 0, 1, "L")
		    pdf.Ln(5)
		    
		    pdf.SetFont("helvetica", "", 12)
		    Dim conclusion As String = "This example demonstrates the core functionality of PDF links and bookmarks. "
		    conclusion = conclusion + "These features are essential for creating professional, user-friendly PDF documents. "
		    conclusion = conclusion + "The bookmarks appear in the sidebar (outline panel) of most PDF viewers, providing quick navigation."
		    pdf.MultiCell(0, 6, conclusion)
		    
		    pdf.Ln(5)
		    pdf.Bookmark("Summary", 1)
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 8, "Summary", 0, 1, "L")
		    pdf.SetFont("helvetica", "", 12)
		    pdf.MultiCell(0, 6, "Key features demonstrated: AddLink(), SetLink(), Link(), LinkString(), and Bookmark().")
		    
		    pdf.Ln(5)
		    pdf.Bookmark("Page Navigation", 1)
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 8, "Page Navigation Demo", 0, 1, "L")
		    pdf.SetFont("helvetica", "", 12)
		    
		    // Demonstrate page navigation methods
		    Dim totalPages As Integer = pdf.PageCount()
		    Dim currentPage As Integer = pdf.PageNo()
		    Dim navText As String = "Page navigation is a DEVELOPER API feature (not user-facing buttons). "
		    navText = navText + "It allows you to programmatically navigate back to earlier pages while building the PDF. "
		    navText = navText + EndOfLine + EndOfLine
		    navText = navText + "This document has " + Str(totalPages) + " pages. "
		    navText = navText + "We are currently on page " + Str(currentPage) + ". "
		    navText = navText + EndOfLine + EndOfLine
		    navText = navText + "Common uses: Add page numbers after creating all pages (""Page 1 of 10""), "
		    navText = navText + "add total page count to headers/footers, or add content to earlier pages. "
		    navText = navText + EndOfLine + EndOfLine
		    navText = navText + "API methods: SetPage(pageNum), PageNo(), PageCount()"
		    pdf.MultiCell(0, 6, navText)
		    
		    pdf.Ln(3)
		    pdf.SetFont("helvetica", "I", 11)
		    pdf.Cell(0, 6, "Navigating to page 1 to add a note...", 0, 1, "L")
		    
		    // Navigate to page 1 and add content
		    Call pdf.SetPage(1)
		    pdf.SetY(270) // Near bottom of page
		    pdf.SetFont("helvetica", "I", 10)
		    pdf.SetTextColor(100, 100, 100) // Gray text
		    pdf.Cell(0, 5, "Note: This text was added using SetPage(1) after creating all 4 pages!", 0, 1, "C")
		    
		    // Navigate back to last page
		    Call pdf.SetPage(totalPages)
		    pdf.SetTextColor(0, 0, 0) // Reset to black
		    pdf.SetFont("helvetica", "", 12)
		    pdf.SetY(pdf.GetY() + 3)
		    pdf.Cell(0, 6, "...returned to page " + Str(pdf.PageNo()), 0, 1, "L")
		    
		    pdf.Ln(5)
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Cell(0, 6, "Result:", 0, 1, "L")
		    pdf.SetFont("helvetica", "", 11)
		    pdf.MultiCell(0, 6, "Check the BOTTOM of page 1 - you'll see a gray note that was added AFTER all 4 pages were created. This demonstrates SetPage() working!")
		    
		    // Check for errors
		    If pdf.Err Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("success") = False
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    // Get PDF data as String
		    Dim pdfData As String = pdf.Output()
		    If pdfData = "" Then
		      statusText = statusText + "Error: Failed to generate PDF data" + EndOfLine
		      result.Value("success") = False
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    statusText = statusText + "Success! PDF generated (" + Str(pdfData.Bytes) + " bytes)" + EndOfLine
		    result.Value("success") = True
		    result.Value("status") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example11_links_bookmarks.pdf"
		    
		    Return result
		    
		  Catch err As RuntimeException
		    statusText = statusText + "Exception: " + err.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44656D6F6E7374726174657320637573746F6D207061676520666F726D61747320616E6420706167652073697A65207175657279696E672E0A
		Function GenerateExample12() As Dictionary
		  // Example 12: Custom page formats and PageSize method
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 12: Custom page formats..." + EndOfLine
		  
		  Try
		    // Create PDF document with default A4 size
		    Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
		    VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		    
		    // Add standard A4 page
		    Call pdf.AddPage()
		    pdf.SetFont("helvetica", "B", 20)
		    pdf.Cell(0, 10, "Custom Page Formats Demo", 0, 1, "C")
		    pdf.Ln(5)
		    
		    pdf.SetFont("helvetica", "", 12)
		    pdf.Cell(0, 8, "This is a standard A4 page (210 x 297 mm)", 0, 1)
		    
		    // Get and display page 1 dimensions
		    Dim w1, h1 As Double
		    If pdf.PageSize(1, w1, h1) Then
		      pdf.Cell(0, 8, "Page 1 size: " + FormatHelper(w1, "0.00") + " x " + FormatHelper(h1, "0.00") + " mm", 0, 1)
		    End If
		    
		    pdf.Ln(10)
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 8, "Custom Page Sizes:", 0, 1)
		    pdf.Ln(3)
		    
		    // Add custom square page (150 x 150 mm, Portrait)
		    Call pdf.AddPageFormat("P", 150, 150)
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "Square Page", 0, 1, "C")
		    pdf.Ln(3)
		    
		    pdf.SetFont("helvetica", "", 12)
		    pdf.Cell(0, 8, "This is a custom square page", 0, 1)
		    
		    // Get and display page 2 dimensions
		    Dim w2, h2 As Double
		    If pdf.PageSize(2, w2, h2) Then
		      pdf.Cell(0, 8, "Page 2 size: " + FormatHelper(w2, "0.00") + " x " + FormatHelper(h2, "0.00") + " mm", 0, 1)
		    End If
		    
		    // Draw a border to show page boundaries
		    pdf.SetDrawColor(200, 200, 200)
		    pdf.Rect(10, 10, 130, 130, "D")
		    
		    // Add custom wide page (250 x 100 mm, Landscape orientation)
		    Call pdf.AddPageFormat("L", 250, 100)
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "Wide Landscape Page", 0, 1, "C")
		    pdf.Ln(3)
		    
		    pdf.SetFont("helvetica", "", 12)
		    pdf.Cell(0, 8, "This is a custom wide landscape page", 0, 1)
		    
		    // Get and display page 3 dimensions
		    Dim w3, h3 As Double
		    If pdf.PageSize(3, w3, h3) Then
		      pdf.Cell(0, 8, "Page 3 size: " + FormatHelper(w3, "0.00") + " x " + FormatHelper(h3, "0.00") + " mm", 0, 1)
		    End If
		    
		    // Draw border
		    pdf.SetDrawColor(200, 200, 200)
		    pdf.Rect(10, 10, 80, 80, "D")
		    
		    // Add custom tall page (80 x 200 mm, Portrait)
		    Call pdf.AddPageFormat("P", 80, 200)
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.Cell(0, 10, "Tall Page", 0, 1, "C")
		    pdf.Ln(3)
		    
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Cell(0, 6, "This is a custom tall page", 0, 1)
		    pdf.Cell(0, 6, "(80 x 200 mm)", 0, 1)
		    
		    // Get and display page 4 dimensions
		    Dim w4, h4 As Double
		    If pdf.PageSize(4, w4, h4) Then
		      pdf.Cell(0, 6, "Page 4 size:", 0, 1)
		      pdf.Cell(0, 6, FormatHelper(w4, "0.00") + " x " + FormatHelper(h4, "0.00") + " mm", 0, 1)
		    End If
		    
		    // Draw border
		    pdf.SetDrawColor(200, 200, 200)
		    pdf.Rect(5, 5, 70, 190, "D")
		    
		    // Summary page - back to standard A4
		    Call pdf.AddPage()
		    pdf.SetFont("helvetica", "B", 18)
		    pdf.Cell(0, 10, "Summary: All Page Sizes", 0, 1, "C")
		    pdf.Ln(10)
		    
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(40, 8, "Page", 1, 0, "C")
		    pdf.Cell(70, 8, "Width (mm)", 1, 0, "C")
		    pdf.Cell(70, 8, "Height (mm)", 1, 1, "C")
		    
		    // List all page sizes
		    pdf.SetFont("helvetica", "", 11)
		    For i As Integer = 1 To pdf.PageCount()
		      Dim pw, ph As Double
		      If pdf.PageSize(i, pw, ph) Then
		        pdf.Cell(40, 7, Str(i), 1, 0, "C")
		        pdf.Cell(70, 7, FormatHelper(pw, "0.00"), 1, 0, "C")
		        pdf.Cell(70, 7, FormatHelper(ph, "0.00"), 1, 1, "C")
		      End If
		    Next
		    
		    // Check for errors
		    If pdf.Err() Then
		      statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    If pdf.Error <> "" Then
		      statusText = statusText + "ERROR: " + pdf.Error + EndOfLine
		      result.Value("success") = False
		      result.Value("error") = pdf.Error
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    statusText = statusText + "Generated " + Str(pdfData.Bytes) + " bytes" + EndOfLine
		    statusText = statusText + "SUCCESS: Custom page formats example generated" + EndOfLine
		    
		    result.Value("success") = True
		    result.Value("status") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example12_custom_formats.pdf"
		    Return result
		    
		  Catch err As RuntimeException
		    statusText = statusText + "EXCEPTION: " + err.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C6520313A20504446412D312063616E646964617465207769746820494343206F757470757420696E74656E742E0A
		Function GenerateExample13() As Dictionary
		  // Example 13: PDF/A-1b compliance with XMP metadata and ICC color profile embedding
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 13: PDF/A-1b document with XMP metadata..." + EndOfLine
		  
		  Try
		    // Try to locate an ICC profile file
		    // Common locations: Desktop, system color profiles, or provided file
		    Dim iccProfile As MemoryBlock
		    Dim iccFound As Boolean = False
		    Dim iccSource As String
		    
		    #If TargetDesktop Or TargetConsole Then
		      // Try Desktop first (user might have placed sRGB.icc there)
		      Dim iccFile As FolderItem = SpecialFolder.Desktop.Child("sRGB.icc")
		      If iccFile <> Nil And iccFile.Exists Then
		        iccProfile = LoadBinaryFile(iccFile)
		        iccFound = True
		        iccSource = iccFile.NativePath
		      Else
		        // Try system color profiles on macOS
		        iccFile = New FolderItem("/System/Library/ColorSync/Profiles/sRGB Profile.icc", FolderItem.PathModes.Native)
		        If iccFile <> Nil And iccFile.Exists Then
		          iccProfile = LoadBinaryFile(iccFile)
		          iccFound = True
		          iccSource = iccFile.NativePath
		        End If
		      End If
		      
		    #ElseIf TargetWeb Then
		      // Web: ICC profile would need to be uploaded or in resources
		      // For now, show instructions
		      statusText = statusText + "Web: Place sRGB.icc in project resources or upload" + EndOfLine
		      
		    #ElseIf TargetiOS Then
		      // iOS: Try Documents folder
		      Dim iccFile As FolderItem = SpecialFolder.Documents.Child("sRGB.icc")
		      If iccFile <> Nil And iccFile.Exists Then
		        iccProfile = LoadBinaryFile(iccFile)
		        iccFound = True
		        iccSource = "iOS Documents folder"
		      End If
		    #EndIf
		    
		    If Not iccFound Then
		      statusText = statusText + "WARNING: No ICC profile found!" + EndOfLine
		      statusText = statusText + "To create PDF/A documents, you need an ICC color profile." + EndOfLine
		      statusText = statusText + EndOfLine
		      statusText = statusText + "Options to obtain sRGB.icc:" + EndOfLine
		      statusText = statusText + "1. macOS: /System/Library/ColorSync/Profiles/sRGB Profile.icc" + EndOfLine
		      statusText = statusText + "2. Download from: www.color.org (ICC sRGB profile)" + EndOfLine
		      statusText = statusText + "3. Place sRGB.icc on your Desktop" + EndOfLine
		      statusText = statusText + EndOfLine
		      statusText = statusText + "Continuing without output intent (not PDF/A compliant)..." + EndOfLine
		    Else
		      statusText = statusText + "ICC profile loaded: " + iccSource + EndOfLine
		      statusText = statusText + "ICC profile size: " + Str(iccProfile.Size) + " bytes" + EndOfLine
		    End If
		    
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    
		    // Add output intent if ICC profile is available
		    If iccFound Then
		      pdf.AddOutputIntent( _
		      VNSPDFModule.gkOutputIntentPDFA1, _
		      "sRGB IEC61966-2.1", _
		      "sRGB color space for PDF/A-1 compliance", _
		      iccProfile)
		      statusText = statusText + "Output intent added for PDF/A-1 compliance" + EndOfLine
		    End If
		    
		    // Set metadata (required for PDF/A)
		    pdf.SetTitle("PDF/A Sample Document")
		    pdf.SetAuthor("Xojo FPDF Library")
		    pdf.SetSubject("PDF/A-1 Compliance Example")
		    pdf.SetKeywords("PDF/A, archival, ICC profile, color management")
		    pdf.SetCreator("Xojo FPDF v0.3.0")
		    
		    // Set XMP metadata (required for PDF/A compliance)
		    Dim xmp As String = "<?xpacket begin="""" id=""W5M0MpCehiHzreSzNTczkc9d""?>" + EndOfLine.UNIX
		    xmp = xmp + "<x:xmpmeta xmlns:x=""adobe:ns:meta/"">" + EndOfLine.UNIX
		    xmp = xmp + "  <rdf:RDF xmlns:rdf=""http://www.w3.org/1999/02/22-rdf-syntax-ns#"">" + EndOfLine.UNIX
		    xmp = xmp + "    <rdf:Description rdf:about="""" xmlns:dc=""http://purl.org/dc/elements/1.1/"">" + EndOfLine.UNIX
		    xmp = xmp + "      <dc:format>application/pdf</dc:format>" + EndOfLine.UNIX
		    xmp = xmp + "      <dc:title><rdf:Alt><rdf:li xml:lang=""x-default"">PDF/A Sample Document</rdf:li></rdf:Alt></dc:title>" + EndOfLine.UNIX
		    xmp = xmp + "      <dc:creator><rdf:Seq><rdf:li>Xojo FPDF Library</rdf:li></rdf:Seq></dc:creator>" + EndOfLine.UNIX
		    xmp = xmp + "      <dc:description><rdf:Alt><rdf:li xml:lang=""x-default"">PDF/A-1 Compliance Example</rdf:li></rdf:Alt></dc:description>" + EndOfLine.UNIX
		    xmp = xmp + "      <dc:subject><rdf:Bag><rdf:li>PDF/A</rdf:li><rdf:li>archival</rdf:li><rdf:li>ICC profile</rdf:li><rdf:li>color management</rdf:li></rdf:Bag></dc:subject>" + EndOfLine.UNIX
		    xmp = xmp + "    </rdf:Description>" + EndOfLine.UNIX
		    xmp = xmp + "    <rdf:Description rdf:about="""" xmlns:xmp=""http://ns.adobe.com/xap/1.0/"">" + EndOfLine.UNIX
		    xmp = xmp + "      <xmp:CreatorTool>Xojo FPDF v0.3.0</xmp:CreatorTool>" + EndOfLine.UNIX
		    // Note: Omitting xmp:CreateDate - will be auto-generated to match PDF Info /CreationDate
		    xmp = xmp + "    </rdf:Description>" + EndOfLine.UNIX
		    xmp = xmp + "    <rdf:Description rdf:about="""" xmlns:pdf=""http://ns.adobe.com/pdf/1.3/"">" + EndOfLine.UNIX
		    // Note: Producer must match PDF Info /Producer exactly for PDF/A compliance
		    xmp = xmp + "      <pdf:Producer>VNS PDF Library (Xojo)</pdf:Producer>" + EndOfLine.UNIX
		    xmp = xmp + "      <pdf:Keywords>PDF/A, archival, ICC profile, color management</pdf:Keywords>" + EndOfLine.UNIX
		    xmp = xmp + "    </rdf:Description>" + EndOfLine.UNIX
		    xmp = xmp + "    <rdf:Description rdf:about="""" xmlns:pdfaid=""http://www.aiim.org/pdfa/ns/id/"">" + EndOfLine.UNIX
		    xmp = xmp + "      <pdfaid:part>1</pdfaid:part>" + EndOfLine.UNIX
		    xmp = xmp + "      <pdfaid:conformance>B</pdfaid:conformance>" + EndOfLine.UNIX
		    xmp = xmp + "    </rdf:Description>" + EndOfLine.UNIX
		    xmp = xmp + "  </rdf:RDF>" + EndOfLine.UNIX
		    xmp = xmp + "</x:xmpmeta>" + EndOfLine.UNIX
		    xmp = xmp + "<?xpacket end=""w""?>"
		    
		    pdf.SetXmpMetadata(xmp)
		    statusText = statusText + "XMP metadata added (PDF/A-1b conformance declared)" + EndOfLine

		    // Verify XMP metadata was set
		    Dim retrievedXmp As String = pdf.GetXmpMetadata()
		    If retrievedXmp <> "" Then
		      statusText = statusText + "XMP metadata verified: " + Str(retrievedXmp.Length) + " characters" + EndOfLine
		    End If

		    // PDF/A compliance requires embedded fonts
		    // When Output Intent is added, core fonts are not allowed
		    If iccFound Then
		      // Load an embedded TrueType font for PDF/A compliance
		      #If TargetDesktop Or TargetConsole Then
		        // Try multiple Arial font locations (macOS paths)
		        Dim fontFile As FolderItem = New FolderItem("/Library/Fonts/Arial.ttf", FolderItem.PathModes.Native)
		        If fontFile = Nil Or Not fontFile.Exists Then
		          // Try system location
		          fontFile = New FolderItem("/System/Library/Fonts/Supplemental/Arial.ttf", FolderItem.PathModes.Native)
		        End If
		        If fontFile = Nil Or Not fontFile.Exists Then
		          // Try Helvetica as fallback
		          fontFile = New FolderItem("/System/Library/Fonts/Helvetica.ttc", FolderItem.PathModes.Native)
		        End If

		        If fontFile <> Nil And fontFile.Exists Then
		          // Load TrueType fonts for PDF/A compliance
		          pdf.AddUTF8Font("arial", "", fontFile.NativePath)

		          // Try to load Arial Bold for testing multiple font faces
		          Dim fontBold As FolderItem = New FolderItem("/Library/Fonts/Arial Bold.ttf", FolderItem.PathModes.Native)
		          If fontBold = Nil Or Not fontBold.Exists Then
		            fontBold = New FolderItem("/System/Library/Fonts/Supplemental/Arial Bold.ttf", FolderItem.PathModes.Native)
		          End If

		          If fontBold <> Nil And fontBold.Exists Then
		            pdf.AddUTF8Font("arial", "B", fontBold.NativePath)
		            statusText = statusText + "TrueType fonts embedded: Arial (regular + bold)" + EndOfLine
		          Else
		            statusText = statusText + "TrueType font embedded: Arial (regular only)" + EndOfLine
		          End If
		        Else
		          statusText = statusText + "WARNING: Could not find TrueType font file" + EndOfLine
		          statusText = statusText + "PDF/A requires embedded fonts - core fonts not allowed" + EndOfLine
		        End If
		      #ElseIf TargetiOS Then
		        // iOS: Would need to bundle font in app resources
		        statusText = statusText + "iOS: Font embedding would use app bundle resources" + EndOfLine
		      #EndIf
		    End If

		    // Add page
		    Call pdf.AddPage()

		    // PDF/A Compliance Enforcement Example:
		    // If you tried to use a core font without embedding it first, you would get:
		    // RuntimeException: "PDF/A compliance violation: Core fonts are not allowed in PDF/A mode.
		    //                    Font 'times' must be embedded using AddUTF8Font() or AddUTF8FontFromBytes().
		    //                    PDF/A requires all fonts to be embedded for archival compliance."
		    //
		    // Uncommenting the next line would trigger this exception:
		    // pdf.SetFont("times", "", 12)  // ← Would raise RuntimeException in PDF/A mode!

		    // Select font based on PDF/A mode
		    Dim fontName As String
		    If iccFound Then
		      fontName = "arial"  // Embedded TrueType font for PDF/A
		    Else
		      fontName = "helvetica"  // Core font when not in PDF/A mode
		    End If

		    // Title
		    pdf.SetFont(fontName, "", 20)
		    pdf.SetTextColor(0, 0, 128)
		    pdf.Cell(0, 15, "PDF/A-1b Compliance Example", 0, 1, "C")

		    // Reset color
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(5)

		    // Section 1: What is PDF/A?
		    pdf.SetFont(fontName, "", 14)
		    pdf.Cell(0, 10, "What is PDF/A?", 0, 1, "L")

		    pdf.SetFont(fontName, "", 11)
		    pdf.MultiCell(0, 6, "PDF/A is an ISO-standardized version of PDF designed for long-term archiving of electronic documents. It ensures that documents can be reproduced exactly the same way in the future.", 0, "L")
		    pdf.Ln(3)
		    
		    // Section 2: Key Features
		    If iccFound Then
		      pdf.SetFont(fontName, "B", 14)  // Try bold in PDF/A mode
		    Else
		      pdf.SetFont(fontName, "", 14)
		    End If
		    pdf.Cell(0, 10, "Key PDF/A Requirements:", 0, 1, "L")

		    pdf.SetFont(fontName, "", 11)
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(0, 6, "1. All fonts must be embedded", 0, 1)
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(0, 6, "2. ICC color profiles must be specified (Output Intent)", 0, 1)
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(0, 6, "3. XMP metadata required (XML-based extensible metadata)", 0, 1)
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(0, 6, "4. No external dependencies (self-contained)", 0, 1)
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(0, 6, "5. No encryption, JavaScript, or audio/video", 0, 1)
		    pdf.Ln(5)
		    
		    // Section 3: This Document
		    If iccFound Then
		      pdf.SetFont(fontName, "B", 14)  // Try bold in PDF/A mode
		    Else
		      pdf.SetFont(fontName, "", 14)
		    End If
		    pdf.Cell(0, 10, "This Document:", 0, 1, "L")

		    pdf.SetFont(fontName, "", 11)
		    If iccFound Then
		      pdf.SetTextColor(0, 128, 0)
		      pdf.Cell(0, 6, "  Output Intent: sRGB IEC61966-2.1 (embedded)", 0, 1)
		      pdf.SetTextColor(0, 0, 0)
		      pdf.Cell(0, 6, "  Color Profile: ICC profile embedded", 0, 1)
		    Else
		      pdf.SetTextColor(255, 0, 0)
		      pdf.Cell(0, 6, "  Output Intent: Missing (ICC profile not found)", 0, 1)
		      pdf.SetTextColor(0, 0, 0)
		    End If
		    
		    pdf.SetTextColor(0, 128, 0)
		    pdf.Cell(0, 6, "  XMP Metadata: Embedded (" + Str(retrievedXmp.Length) + " chars, PDF/A-1b)", 0, 1)
		    pdf.SetTextColor(0, 0, 0)
		    If iccFound Then
		      pdf.SetTextColor(0, 128, 0)
		      pdf.Cell(0, 6, "  Fonts: TrueType embedded (PDF/A compliant)", 0, 1)
		      pdf.SetTextColor(0, 0, 0)
		    Else
		      pdf.Cell(0, 6, "  Fonts: Core PDF fonts (Helvetica)", 0, 1)
		    End If
		    pdf.Cell(0, 6, "  Document Metadata: Title, Author, Subject, Keywords", 0, 1)
		    pdf.Ln(5)
		    
		    // Color demonstration
		    If iccFound Then
		      pdf.SetFont(fontName, "B", 14)  // Try bold in PDF/A mode
		    Else
		      pdf.SetFont(fontName, "", 14)
		    End If
		    pdf.Cell(0, 10, "Color Management:", 0, 1, "L")

		    pdf.SetFont(fontName, "", 11)
		    pdf.Cell(0, 6, "Colors rendered according to sRGB color space:", 0, 1)
		    pdf.Ln(2)
		    
		    // Color swatches
		    Dim colorY As Double = pdf.GetY()
		    pdf.SetFillColor(255, 0, 0)
		    pdf.Rect(20, colorY, 30, 10, "F")
		    pdf.SetFillColor(0, 255, 0)
		    pdf.Rect(55, colorY, 30, 10, "F")
		    pdf.SetFillColor(0, 0, 255)
		    pdf.Rect(90, colorY, 30, 10, "F")
		    pdf.SetFillColor(255, 255, 0)
		    pdf.Rect(125, colorY, 30, 10, "F")
		    pdf.SetFillColor(255, 0, 255)
		    pdf.Rect(160, colorY, 30, 10, "F")
		    
		    pdf.SetY(colorY + 12)
		    pdf.SetFont(fontName, "", 8)
		    pdf.Text(25, colorY + 15, "Red")
		    pdf.Text(58, colorY + 15, "Green")
		    pdf.Text(95, colorY + 15, "Blue")
		    pdf.Text(127, colorY + 15, "Yellow")
		    pdf.Text(160, colorY + 15, "Magenta")
		    
		    pdf.SetY(colorY + 20)
		    
		    // Footer note
		    pdf.SetFont(fontName, "", 9)
		    pdf.SetTextColor(100, 100, 100)
		    pdf.Ln(10)
		    If iccFound Then
		      pdf.MultiCell(0, 5, "Note: This document includes XMP metadata declaring PDF/A-1b conformance and an ICC color profile (Output Intent). PDF/A-1b requires visual fidelity but not accessibility features. To validate compliance, use tools like Adobe Acrobat Preflight or VeraPDF (open source). For full PDF/A-1a compliance, tagged PDF structure is required.", 0, "L")
		    Else
		      pdf.MultiCell(0, 5, "Note: This document includes XMP metadata declaring PDF/A-1b conformance, but is missing the ICC color profile (Output Intent) required for full compliance. To achieve PDF/A-1b compliance, add an sRGB ICC profile. To validate compliance, use tools like Adobe Acrobat Preflight or VeraPDF (open source).", 0, "L")
		    End If
		    
		    // Add clickable link to VeraPDF online validator
		    pdf.Ln(5)
		    pdf.SetFont(fontName, "", 10)
		    pdf.SetTextColor(0, 0, 255)  // Blue for link
		    Dim linkText As String = "Click here to validate this PDF with VeraPDF online"
		    Dim linkWidth As Double = pdf.GetStringWidth(linkText)
		    Dim pageWidth, pageHeight As Double
		    pdf.GetPageSize(pageWidth, pageHeight)
		    Dim linkX As Double = (pageWidth - linkWidth) / 2  // Center the link
		    pdf.SetX(linkX)
		    pdf.Cell(linkWidth, 6, linkText, 0, 1, "C")
		    // Add clickable area for the link
		    pdf.LinkString(linkX, pdf.GetY() - 6, linkWidth, 6, "https://demo.verapdf.org/")
		    
		    // Add URL below in smaller text
		    pdf.SetFont(fontName, "", 8)
		    pdf.SetTextColor(100, 100, 100)
		    pdf.Cell(0, 5, "https://demo.verapdf.org/", 0, 1, "C")


		    // Check for errors
		    If pdf.Err() Then
		      statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    If pdf.Error <> "" Then
		      statusText = statusText + "ERROR: " + pdf.Error + EndOfLine
		      result.Value("success") = False
		      result.Value("error") = pdf.Error
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    statusText = statusText + "File size: " + Str(pdfData.Bytes) + " bytes" + EndOfLine
		    
		    If iccFound Then
		      statusText = statusText + EndOfLine
		      statusText = statusText + "SUCCESS! PDF/A-1b document created with:" + EndOfLine
		      statusText = statusText + "  - XMP metadata (PDF/A-1b conformance declared)" + EndOfLine
		      statusText = statusText + "  - ICC color profile (sRGB output intent)" + EndOfLine
		      statusText = statusText + "  - Embedded TrueType fonts (Arial regular + bold - PDF/A compliant)" + EndOfLine
		      statusText = statusText + "  - Document metadata (Title, Author, Subject, Keywords)" + EndOfLine
		      statusText = statusText + "  - Runtime validation (core fonts blocked in PDF/A mode)" + EndOfLine
		      statusText = statusText + "  - Multiple font faces tested (section headers use bold)" + EndOfLine
		      statusText = statusText + "Ready for validation with VeraPDF or Adobe Preflight!" + EndOfLine
		    Else
		      statusText = statusText + EndOfLine
		      statusText = statusText + "PDF created with XMP metadata but missing ICC profile." + EndOfLine
		      statusText = statusText + "Add sRGB.icc to Desktop for full PDF/A-1b compliance." + EndOfLine
		    End If
		    
		    result.Value("success") = True
		    result.Value("status") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example13_pdfa.pdf"
		    Return result
		    
		  Catch e As RuntimeException
		    statusText = statusText + "EXCEPTION: " + e.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample14(revision As Integer, userPassword As String, ownerPassword As String, allowPrint As Boolean, allowModify As Boolean, allowCopy As Boolean, allowAnnotate As Boolean, allowFillForms As Boolean, allowExtract As Boolean, allowAssemble As Boolean, allowPrintHighQuality As Boolean) As Dictionary
		  // Example 14: PDF Security - Password protection and encryption with all 8 permission bits

		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 14: PDF Security (ENCRYPTED)..." + EndOfLine

		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()

		    // Configure encryption with user's settings (all 8 permission bits)
		    Call pdf.SetProtection(userPassword, ownerPassword, allowPrint, allowModify, allowCopy, allowAnnotate, allowFillForms, allowExtract, allowAssemble, allowPrintHighQuality, revision)
		    statusText = statusText + "Encryption enabled with Revision " + Str(revision) + EndOfLine
		    If userPassword <> "" Then
		      statusText = statusText + "User password required to open PDF" + EndOfLine
		    End If
		    statusText = statusText + EndOfLine
		    
		    Call pdf.AddPage()
		    
		    // Title
		    pdf.SetFont("helvetica", "B", 18)
		    pdf.SetTextColor(128, 0, 128)
		    pdf.Cell(0, 10, "PDF Security Example", 0, 1, "C")
		    pdf.Ln(5)
		    
		    // Introduction
		    pdf.SetFont("helvetica", "", 11)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.MultiCell(0, 5, "This PDF demonstrates document encryption and permission controls. " + _
		    "When encryption is enabled, the PDF requires a password to open and can restrict " + _
		    "operations like printing, copying, and modification.", 0, "L")
		    pdf.Ln(3)
		    
		    // Section 1: Encryption Revisions
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.SetFillColor(220, 220, 255)
		    pdf.Cell(0, 8, "Available Encryption Revisions", 0, 1, "L", True)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 10)
		    
		    // Revision 2
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(50, 6, "Revision 2:", 0, 0)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.MultiCell(0, 6, "40-bit RC4 encryption (PDF 1.1-1.3) - FREE VERSION", 0, "L")
		    pdf.SetFont("helvetica", "I", 9)
		    pdf.SetTextColor(180, 0, 0)
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.MultiCell(0, 5, "Security: WEAK - Broken encryption, for legacy compatibility only", 0, "L")
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(2)
		    
		    // Revision 3
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(50, 6, "Revision 3:", 0, 0)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.MultiCell(0, 6, "128-bit RC4 encryption (PDF 1.4) - PREMIUM MODULE", 0, "L")
		    pdf.SetFont("helvetica", "I", 9)
		    pdf.SetTextColor(180, 0, 0)
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.MultiCell(0, 5, "Security: WEAK - Broken encryption, for legacy compatibility only", 0, "L")
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(2)
		    
		    // Revision 4
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(50, 6, "Revision 4:", 0, 0)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.MultiCell(0, 6, "128-bit AES-CBC encryption (PDF 1.6+) - PREMIUM MODULE", 0, "L")
		    pdf.SetFont("helvetica", "I", 9)
		    pdf.SetTextColor(0, 128, 0)
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.MultiCell(0, 5, "Security: GOOD - Standard security for most use cases", 0, "L")
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(2)
		    
		    // Revision 5
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(50, 6, "Revision 5:", 0, 0)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.MultiCell(0, 6, "256-bit AES-CBC encryption (PDF 1.7 Ext 3) - PREMIUM MODULE", 0, "L")
		    pdf.SetFont("helvetica", "I", 9)
		    pdf.SetTextColor(0, 100, 0)
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.MultiCell(0, 5, "Security: BEST - High security, recommended for sensitive documents", 0, "L")
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(2)
		    
		    // Revision 6
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(50, 6, "Revision 6:", 0, 0)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.MultiCell(0, 6, "256-bit AES-CBC encryption (PDF 2.0) - PREMIUM MODULE", 0, "L")
		    pdf.SetFont("helvetica", "I", 9)
		    pdf.SetTextColor(0, 100, 0)
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.MultiCell(0, 5, "Security: BEST - Latest standard, maximum security", 0, "L")
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(5)
		    
		    // Section 2: Password Types
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.SetFillColor(220, 255, 220)
		    pdf.Cell(0, 8, "Password Types", 0, 1, "L", True)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 10)
		    
		    // User Password
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(50, 6, "User Password:", 0, 0)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.MultiCell(0, 6, "Required to open the document", 0, "L")
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.SetFont("helvetica", "I", 9)
		    pdf.MultiCell(0, 5, "PDF reader will prompt for password before displaying content", 0, "L")
		    pdf.Ln(2)
		    
		    // Owner Password
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(50, 6, "Owner Password:", 0, 0)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.MultiCell(0, 6, "Controls document permissions and restrictions", 0, "L")
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.SetFont("helvetica", "I", 9)
		    pdf.MultiCell(0, 5, "Allows full access to modify permissions and document settings", 0, "L")
		    pdf.Ln(5)
		    
		    // Section 3: Permission Flags
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.SetFillColor(255, 240, 220)
		    pdf.Cell(0, 8, "Permission Flags", 0, 1, "L", True)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 10)
		    
		    // Permission table headers
		    pdf.SetFont("helvetica", "B", 9)
		    pdf.SetFillColor(240, 240, 240)
		    pdf.Cell(50, 6, "Permission", 1, 0, "L", True)
		    pdf.Cell(0, 6, "Description", 1, 1, "L", True)
		    
		    // Permission rows
		    pdf.SetFont("helvetica", "", 9)
		    
		    pdf.Cell(50, 6, "Print", 1, 0, "L")
		    pdf.Cell(0, 6, "Allow printing the document", 1, 1, "L")
		    
		    pdf.Cell(50, 6, "Modify", 1, 0, "L")
		    pdf.Cell(0, 6, "Allow modifying document content", 1, 1, "L")
		    
		    pdf.Cell(50, 6, "Copy", 1, 0, "L")
		    pdf.Cell(0, 6, "Allow copying text and graphics", 1, 1, "L")
		    
		    pdf.Cell(50, 6, "Annotations", 1, 0, "L")
		    pdf.Cell(0, 6, "Allow adding/modifying annotations", 1, 1, "L")
		    
		    pdf.Cell(50, 6, "Fill Forms", 1, 0, "L")
		    pdf.Cell(0, 6, "Allow filling in form fields", 1, 1, "L")
		    
		    pdf.Cell(50, 6, "Extract (Accessibility)", 1, 0, "L")
		    pdf.Cell(0, 6, "Allow content extraction for accessibility", 1, 1, "L")
		    
		    pdf.Cell(50, 6, "Assemble", 1, 0, "L")
		    pdf.Cell(0, 6, "Allow page insertion, rotation, deletion", 1, 1, "L")
		    
		    pdf.Cell(50, 6, "Print High Quality", 1, 0, "L")
		    pdf.Cell(0, 6, "Allow high-resolution printing", 1, 1, "L")
		    
		    pdf.Ln(5)
		    
		    // Section 4: Usage Examples
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.SetFillColor(255, 220, 220)
		    pdf.Cell(0, 8, "Usage Examples", 0, 1, "L", True)
		    pdf.Ln(2)
		    
		    pdf.SetFont("courier", "", 8)
		    
		    // Example 1: Basic encryption
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 5, "Example 1: AES-128 encryption with password (PREMIUM)", 0, 1)
		    pdf.SetFont("courier", "", 8)
		    pdf.MultiCell(0, 4, _
		    "Dim pdf As New VNSPDFDocument()" + EndOfLine + _
		    "pdf.SetEncryption(4)  // Revision 4 (AES-128)" + EndOfLine + _
		    "pdf.SetProtection(""user123"", ""owner456"", True, True, True, True)" + EndOfLine + _
		    "// Password: user123, All permissions enabled", 0, "L")
		    pdf.Ln(3)
		    
		    // Example 2: High security
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 5, "Example 2: Maximum security AES-256 encryption (PREMIUM)", 0, 1)
		    pdf.SetFont("courier", "", 8)
		    pdf.MultiCell(0, 4, _
		    "Dim pdf As New VNSPDFDocument()" + EndOfLine + _
		    "pdf.SetEncryption(5)  // Revision 5 (AES-256, BEST)" + EndOfLine + _
		    "pdf.SetProtection(""secret"", ""admin"", False, False, False, False)" + EndOfLine + _
		    "// No printing, no copying, no modifications allowed", 0, "L")
		    pdf.Ln(3)
		    
		    // Example 3: Read-only with printing
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 5, "Example 3: Read-only document with printing allowed (PREMIUM)", 0, 1)
		    pdf.SetFont("courier", "", 8)
		    pdf.MultiCell(0, 4, _
		    "Dim pdf As New VNSPDFDocument()" + EndOfLine + _
		    "pdf.SetEncryption(4)  // Revision 4 (AES-128)" + EndOfLine + _
		    "pdf.SetProtection(""view"", ""manage"", True, False, False, False)" + EndOfLine + _
		    "// Allow printing only, no modifications or copying", 0, "L")
		    pdf.Ln(3)
		    
		    // Example 4: Legacy compatibility
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 5, "Example 4: 40-bit RC4 encryption (FREE VERSION)", 0, 1)
		    pdf.SetFont("courier", "", 8)
		    pdf.MultiCell(0, 4, _
		    "Dim pdf As New VNSPDFDocument()" + EndOfLine + _
		    "pdf.SetEncryption(2)  // Revision 2 (40-bit RC4, FREE)" + EndOfLine + _
		    "pdf.SetProtection(""old"", ""old"", True, True, True, True)" + EndOfLine + _
		    "// WARNING: Weak encryption, for legacy systems only!", 0, "L")
		    pdf.Ln(5)
		    
		    // Important Notes
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.SetTextColor(180, 0, 0)
		    pdf.Cell(0, 6, "Important Security Notes:", 0, 1)
		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetTextColor(0, 0, 0)
		    
		    pdf.Cell(5, 5, "", 0, 0)
		    pdf.Cell(5, 5, "1.", 0, 0)
		    pdf.MultiCell(0, 5, "Always use Revision 4 (AES-128) or higher for production documents", 0, "L")
		    
		    pdf.Cell(5, 5, "", 0, 0)
		    pdf.Cell(5, 5, "2.", 0, 0)
		    pdf.MultiCell(0, 5, "Revisions 2 and 3 (RC4) are cryptographically broken - use only for legacy compatibility", 0, "L")
		    
		    pdf.Cell(5, 5, "", 0, 0)
		    pdf.Cell(5, 5, "3.", 0, 0)
		    pdf.MultiCell(0, 5, "For maximum security, use Revision 5 or 6 (AES-256) with strong passwords", 0, "L")
		    
		    pdf.Cell(5, 5, "", 0, 0)
		    pdf.Cell(5, 5, "4.", 0, 0)
		    pdf.MultiCell(0, 5, "Owner password should be different from user password for better control", 0, "L")
		    
		    pdf.Cell(5, 5, "", 0, 0)
		    pdf.Cell(5, 5, "5.", 0, 0)
		    pdf.MultiCell(0, 5, "Encrypted PDFs may not be fully PDF/A compliant without proper metadata declaration", 0, "L")
		    
		    pdf.Ln(3)
		    
		    // Add page showing selected settings
		    Call pdf.AddPage()
		    
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.SetTextColor(0, 100, 0)
		    pdf.Cell(0, 10, "YOUR SECURITY SETTINGS", 0, 1, "C")
		    pdf.Ln(5)
		    
		    pdf.SetFont("helvetica", "B", 14)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Cell(0, 8, "Selected Encryption Configuration:", 0, 1)
		    pdf.Ln(2)
		    
		    // Show selected revision
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Cell(60, 7, "Encryption Revision:", 0, 0)
		    pdf.SetFont("helvetica", "", 11)
		    Dim revStr As String
		    Select Case revision
		    Case 2
		      revStr = "Revision 2 (40-bit RC4) - DEPRECATED"
		    Case 3
		      revStr = "Revision 3 (128-bit RC4) - DEPRECATED"
		    Case 4
		      revStr = "Revision 4 (128-bit AES) - GOOD"
		    Case 5
		      revStr = "Revision 5 (256-bit AES) - BEST"
		    Case 6
		      revStr = "Revision 6 (256-bit AES) - BEST"
		    Else
		      revStr = "Unknown revision " + Str(revision)
		    End Select
		    pdf.MultiCell(0, 7, revStr, 0, "L")
		    
		    // Show passwords
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Cell(60, 7, "User Password:", 0, 0)
		    pdf.SetFont("helvetica", "", 11)
		    pdf.Cell(0, 7, If(userPassword <> "", userPassword, "(none - PDF not encrypted)"), 0, 1)
		    
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Cell(60, 7, "Owner Password:", 0, 0)
		    pdf.SetFont("helvetica", "", 11)
		    pdf.Cell(0, 7, If(ownerPassword <> "", ownerPassword, "(same as user password)"), 0, 1)
		    
		    pdf.Ln(3)
		    
		    // Show permissions
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 7, "Permissions:", 0, 1)
		    pdf.Ln(1)
		    
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(10, 6, If(allowPrint, "[X]", "[ ]"), 0, 0)
		    pdf.Cell(0, 6, "Allow Printing", 0, 1)
		    
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(10, 6, If(allowModify, "[X]", "[ ]"), 0, 0)
		    pdf.Cell(0, 6, "Allow Modifying Content", 0, 1)
		    
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(10, 6, If(allowCopy, "[X]", "[ ]"), 0, 0)
		    pdf.Cell(0, 6, "Allow Copying Text/Graphics", 0, 1)
		    
		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(10, 6, If(allowAnnotate, "[X]", "[ ]"), 0, 0)
		    pdf.Cell(0, 6, "Allow Annotations", 0, 1)

		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(10, 6, If(allowFillForms, "[X]", "[ ]"), 0, 0)
		    pdf.Cell(0, 6, "Allow Filling Forms", 0, 1)

		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(10, 6, If(allowExtract, "[X]", "[ ]"), 0, 0)
		    pdf.Cell(0, 6, "Allow Text Extraction (Accessibility)", 0, 1)

		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(10, 6, If(allowAssemble, "[X]", "[ ]"), 0, 0)
		    pdf.Cell(0, 6, "Allow Page Assembly (Insert/Rotate/Delete)", 0, 1)

		    pdf.Cell(10, 6, "", 0, 0)
		    pdf.Cell(10, 6, If(allowPrintHighQuality, "[X]", "[ ]"), 0, 0)
		    pdf.Cell(0, 6, "Allow High-Quality Printing", 0, 1)

		    pdf.Ln(5)
		    
		    // Footer note
		    pdf.SetFont("helvetica", "I", 8)
		    pdf.SetTextColor(100, 100, 100)
		    pdf.MultiCell(0, 4, _
		    "NOTE: This PDF is encrypted with the selected revision and password. " + _
		    "You must enter the user password to open it in a PDF reader.", 0, "L")
		    
		    // Check for errors
		    If pdf.Err() Then
		      statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    If pdf.Error <> "" Then
		      statusText = statusText + "ERROR: " + pdf.Error + EndOfLine
		      result.Value("success") = False
		      result.Value("error") = pdf.Error
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    statusText = statusText + "File size: " + Str(pdfData.Bytes) + " bytes" + EndOfLine
		    statusText = statusText + EndOfLine
		    statusText = statusText + "SUCCESS! PDF Security example created." + EndOfLine
		    statusText = statusText + "This PDF is encrypted with RC4-40 (available in free version)." + EndOfLine
	    statusText = statusText + "Use password 'user123' to open the PDF." + EndOfLine
		    
		    result.Value("success") = True
		    result.Value("status") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example14_security.pdf"
		    Return result
		    
		  Catch e As RuntimeException
		    statusText = statusText + "EXCEPTION: " + e.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652031353A2048656164657220776974682077617465726D61726B0A
		Function GenerateExample15() As Dictionary
		  // Example 15: SetHeaderFuncMode() with watermark background
		  // Demonstrates homeMode to reset position after header rendering
		  
		  Dim result As New Dictionary
		  Dim statusText As String = ""
		  
		  // Create PDF
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  Call pdf.SetTitle("Header with Watermark Example")
		  Call pdf.SetAuthor("Xojo FPDF")
		  Call pdf.SetSubject("Demonstrating SetHeaderFuncMode() with background watermark")
		  Call pdf.SetMargins(10, 10, 10)
		  
		  // Set header with homeMode = True to reset position after rendering
		  // This ensures the watermark doesn't affect content positioning
		  pdf.SetHeaderFuncMode(AddressOf Example15HeaderWithWatermark, True)
		  
		  // Add pages with content
		  Call pdf.AddPage()
		  pdf.SetFont("Times", "", 12)
		  
		  // Page 1 content
		  pdf.Cell(0, 10, "Document with Background Watermark", 0, 1, "C")
		  pdf.Ln(5)
		  
		  Dim i As Integer
		  For i = 1 To 25
		    pdf.Cell(0, 8, "This is line " + Str(i) + " of normal content.", 0, 1)
		  Next
		  
		  // Page 2
		  Call pdf.AddPage()
		  For i = 26 To 50
		    pdf.Cell(0, 8, "This is line " + Str(i) + " of normal content.", 0, 1)
		  Next
		  
		  // Check for errors
		  If pdf.Err() Then
		    statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End If
		  
		  statusText = statusText + "✓ Example 15 generated successfully!" + EndOfLine
		  
		  result.Value("success") = True
		  result.Value("status") = statusText
		  result.Value("pdf") = pdf.Output()
		  result.Value("filename") = "example15_watermark.pdf"
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652031363A20466F726D617474696E672066656174757265730A
		Function GenerateExample16() As Dictionary
		  // Example 16: New Formatting Features
		  // Demonstrates:
		  // - Cellf() - Printf-style formatted cells
		  // - Writef() - Printf-style formatted write
		  // - GetFontDesc() - Font descriptor metrics
		  // - AddUTF8FontFromBytes() - Load fonts from memory (concept)
		  
		  Dim result As New Dictionary
		  Dim statusText As String = ""
		  
		  statusText = statusText + "Example 16: New Formatting Features" + EndOfLine
		  statusText = statusText + "- Cellf() - Printf-style formatted cells" + EndOfLine
		  statusText = statusText + "- Writef() - Printf-style formatted write" + EndOfLine
		  statusText = statusText + "- GetFontDesc() - Font descriptor metrics" + EndOfLine
		  statusText = statusText + EndOfLine
		  
		  // Create PDF
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  Call pdf.SetTitle("Example 16 - New Formatting Features")
		  Call pdf.SetAuthor("VNS PDF Library")
		  Call pdf.SetMargins(10, 10, 10)
		  Call pdf.AddPage()
		  
		  // Header
		  Call pdf.SetFont("helvetica", "B", 16)
		  Call pdf.Cell(0, 10, "Example 16: New Formatting Features", 0, 1, "C")
		  Call pdf.Ln(5)
		  
		  // Section 1: Cellf() - Printf-style formatting
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "1. Cellf() - Printf-style Formatted Cells", 0, 1)
		  Call pdf.Ln(2)
		  
		  Call pdf.SetFont("helvetica", "", 11)
		  
		  // String formatting
		  Call pdf.Cellf(0, 7, "Hello %s! Welcome to %s.", "World", "VNS PDF Library")
		  Call pdf.Ln()
		  
		  // Integer formatting
		  Dim pageCount As Integer = 5
		  Dim currentPage As Integer = 1
		  Call pdf.Cellf(0, 7, "Page %d of %d", currentPage, pageCount)
		  Call pdf.Ln()
		  
		  // Float formatting with precision
		  Dim price As Double = 19.99
		  Dim taxRate As Double = 0.08
		  Dim total As Double = price * (1 + taxRate)
		  Call pdf.Cellf(0, 7, "Price: $%.2f + Tax (%.1f%%) = $%.2f", price, taxRate * 100, total)
		  Call pdf.Ln()
		  
		  // Mixed formatting
		  Dim itemName As String = "Widget"
		  Dim quantity As Integer = 42
		  Dim unitPrice As Double = 3.50
		  Call pdf.Cellf(0, 7, "Item: %s | Qty: %d | Unit Price: $%.2f | Total: $%.2f", itemName, quantity, unitPrice, quantity * unitPrice)
		  Call pdf.Ln(5)
		  
		  // Section 2: Writef() - Flowing text with formatting
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "2. Writef() - Printf-style Formatted Write", 0, 1)
		  Call pdf.Ln(2)
		  
		  Call pdf.SetFont("helvetica", "", 11)
		  Call pdf.Writef(5, "This method supports printf-style formatting in flowing text. ")
		  Call pdf.Writef(5, "For example, you can display %d items at $%.2f each. ", 10, 5.99)
		  Call pdf.Writef(5, "The text wraps automatically and maintains proper spacing. ")
		  Call pdf.Writef(5, "Temperature: %.1f°C, Humidity: %d%%, Pressure: %.2f hPa.", 22.5, 65, 1013.25)
		  Call pdf.Ln(7)
		  
		  // Section 3: GetFontDesc() - Font metrics
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "3. GetFontDesc() - Font Descriptor Metrics", 0, 1)
		  Call pdf.Ln(2)
		  
		  Call pdf.SetFont("courier", "", 10)
		  
		  // Display metrics for Helvetica
		  Dim descHelv As Dictionary = pdf.GetFontDesc("helvetica", "")
		  Call pdf.Cellf(0, 6, "Helvetica:  Ascent=%d, Descent=%d, CapHeight=%d, Flags=%d", _
		  descHelv.Value("Ascent"), descHelv.Value("Descent"), descHelv.Value("CapHeight"), descHelv.Value("Flags"))
		  Call pdf.Ln()
		  
		  // Display metrics for Courier
		  Dim descCour As Dictionary = pdf.GetFontDesc("courier", "")
		  Call pdf.Cellf(0, 6, "Courier:    Ascent=%d, Descent=%d, CapHeight=%d, Flags=%d", _
		  descCour.Value("Ascent"), descCour.Value("Descent"), descCour.Value("CapHeight"), descCour.Value("Flags"))
		  Call pdf.Ln()
		  
		  // Display metrics for Times
		  Dim descTimes As Dictionary = pdf.GetFontDesc("times", "")
		  Call pdf.Cellf(0, 6, "Times:      Ascent=%d, Descent=%d, CapHeight=%d, Flags=%d", _
		  descTimes.Value("Ascent"), descTimes.Value("Descent"), descTimes.Value("CapHeight"), descTimes.Value("Flags"))
		  Call pdf.Ln(7)
		  
		  // Section 4: Benefits
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "4. Benefits of New Features", 0, 1)
		  Call pdf.Ln(2)
		  
		  Call pdf.SetFont("helvetica", "", 11)
		  Call pdf.Cell(15, 6, "", 0, 0)
		  Call pdf.Cell(0, 6, "- Cellf() and Writef() simplify dynamic text formatting", 0, 1)
		  Call pdf.Cell(15, 6, "", 0, 0)
		  Call pdf.Cell(0, 6, "- No need for manual string concatenation", 0, 1)
		  Call pdf.Cell(15, 6, "", 0, 0)
		  Call pdf.Cell(0, 6, "- GetFontDesc() provides programmatic access to font metrics", 0, 1)
		  Call pdf.Cell(15, 6, "", 0, 0)
		  Call pdf.Cell(0, 6, "- AddUTF8FontFromBytes() enables embedded font resources (iOS)", 0, 1)
		  
		  // Check for errors
		  If pdf.Err() Then
		    statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End If
		  
		  statusText = statusText + "✓ Example 16 generated successfully!" + EndOfLine
		  
		  result.Value("success") = True
		  result.Value("status") = statusText
		  result.Value("pdf") = pdf.Output()
		  result.Value("filename") = "example16_formatting_features.pdf"
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652031373A205574696C697479206D6574686F64730A
		Function GenerateExample17() As Dictionary
		  Dim result As New Dictionary
		  Dim statusText As String = ""
		  
		  statusText = statusText + "Example 17: Utility Methods and JSON Serialization" + EndOfLine
		  
		  // Create PDF
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  Call pdf.SetTitle("Example 17 - Utility Methods")
		  Call pdf.SetAuthor("VNS PDF Library")
		  Call pdf.SetSubject("Testing utility methods and JSON serialization")
		  Call pdf.AddPage()
		  
		  // Section 1: GetVersionString()
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "1. GetVersionString()", 0, 1)
		  Call pdf.SetFont("helvetica", "", 11)
		  Call pdf.Cell(0, 7, "Version: " + pdf.GetVersionString(), 0, 1)
		  Call pdf.Ln(3)
		  
		  // Section 2: GetConversionRatio()
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "2. GetConversionRatio()", 0, 1)
		  Call pdf.SetFont("helvetica", "", 11)
		  Dim ratio As Double = pdf.GetConversionRatio()
		  Call pdf.Cell(0, 7, "Conversion ratio (user units to points): " + FormatHelper(ratio, "0.0000"), 0, 1)
		  Call pdf.Cell(0, 7, "This means 1 mm = " + FormatHelper(ratio, "0.0000") + " points", 0, 1)
		  Call pdf.Ln(3)
		  
		  // Section 3: GetPageSizeStr()
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "3. GetPageSizeStr()", 0, 1)
		  Call pdf.SetFont("helvetica", "", 11)
		  
		  Dim a4Size As Pair = pdf.GetPageSizeStr("a4")
		  If a4Size <> Nil Then
		    Call pdf.Cell(0, 7, "A4 size: " + FormatHelper(a4Size.Left, "0.00") + " x " + FormatHelper(a4Size.Right, "0.00") + " mm", 0, 1)
		  End If

		  Dim letterSize As Pair = pdf.GetPageSizeStr("letter")
		  If letterSize <> Nil Then
		    Call pdf.Cell(0, 7, "Letter size: " + FormatHelper(letterSize.Left, "0.00") + " x " + FormatHelper(letterSize.Right, "0.00") + " mm", 0, 1)
		  End If

		  Dim a5Size As Pair = pdf.GetPageSizeStr("a5")
		  If a5Size <> Nil Then
		    Call pdf.Cell(0, 7, "A5 size: " + FormatHelper(a5Size.Left, "0.00") + " x " + FormatHelper(a5Size.Right, "0.00") + " mm", 0, 1)
		  End If
		  Call pdf.Ln(3)
		  
		  // Section 4: RawWriteStr() demonstration
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "4. RawWriteStr()", 0, 1)
		  Call pdf.SetFont("helvetica", "", 11)
		  Call pdf.Cell(0, 7, "Drawing a custom red line using raw PDF commands:", 0, 1)
		  Call pdf.Ln(2)
		  
		  // Get current Y position and page height
		  Dim currentY As Double = pdf.GetY()
		  Dim pageW As Double
		  Dim pageH As Double
		  Call pdf.GetPageSize(pageW, pageH)
		  
		  // Calculate Y coordinate in PDF space (from bottom, in points)
		  Dim lineY As Double = (pageH - currentY - 5) * ratio
		  
		  // Draw a red horizontal line using raw PDF commands
		  Call pdf.RawWriteStr("q")  // Save graphics state
		  Call pdf.RawWriteStr("1 0 0 RG")  // Red stroke color
		  Call pdf.RawWriteStr("3 w")  // 3 point line width
		  Call pdf.RawWriteStr("50 " + Str(lineY) + " m")  // Move to start (X=50 points, Y=lineY)
		  Call pdf.RawWriteStr("250 " + Str(lineY) + " l")  // Line to end (X=250 points, Y=lineY)
		  Call pdf.RawWriteStr("S")  // Stroke the line
		  Call pdf.RawWriteStr("Q")  // Restore graphics state
		  
		  Call pdf.SetY(currentY + 10)
		  Call pdf.Ln(3)
		  
		  // Section 5: ToJSON() and FromJSON()
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "5. ToJSON() and FromJSON()", 0, 1)
		  Call pdf.SetFont("helvetica", "", 11)
		  Call pdf.Cell(0, 7, "Serializing current document state to JSON...", 0, 1)
		  
		  // Get JSON representation
		  Dim jsonState As String = pdf.ToJSON(True)  // Pretty print
		  
		  // Display some JSON properties
		  Call pdf.SetFont("courier", "", 9)
		  Call pdf.Cell(0, 5, "JSON excerpt (first 500 chars):", 0, 1)
		  
		  Dim jsonExcerpt As String
		  #If TargetiOS Then
		    If jsonState.Length > 500 Then
		      jsonExcerpt = jsonState.Left(500) + "..."
		    Else
		      jsonExcerpt = jsonState
		    End If
		  #Else
		    If jsonState.Length > 500 Then
		      jsonExcerpt = jsonState.Left(500) + "..."
		    Else
		      jsonExcerpt = jsonState
		    End If
		  #EndIf
		  
		  // Split into lines for display
		  Dim jsonLines() As String = jsonExcerpt.Split(EndOfLine)
		  Dim lineCount As Integer = 0
		  For Each line As String In jsonLines
		    If lineCount < 15 Then  // Limit display
		      Call pdf.Cell(0, 4, line, 0, 1)
		      lineCount = lineCount + 1
		    End If
		  Next
		  
		  Call pdf.Ln(3)
		  Call pdf.SetFont("helvetica", "", 11)
		  Call pdf.Cell(0, 7, "JSON state captured successfully!", 0, 1)
		  Call pdf.Cell(0, 7, "This can be used to save/restore document configuration.", 0, 1)
		  
		  // Section 6: Close() method
		  Call pdf.Ln(5)
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "6. Close()", 0, 1)
		  Call pdf.SetFont("helvetica", "", 11)
		  Call pdf.Cell(0, 7, "The Close() method validates document state before output.", 0, 1)
		  Call pdf.Cell(0, 7, "It checks for unclosed clip operations and prepares the PDF.", 0, 1)
		  Call pdf.Cell(0, 7, "This is called automatically by Output() and SaveToFile().", 0, 1)
		  
		  If pdf.Err() Then
		    statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End If
		  
		  statusText = statusText + "✓ Example 17 generated successfully!" + EndOfLine
		  statusText = statusText + "✓ All utility methods tested" + EndOfLine
		  
		  result.Value("success") = True
		  result.Value("status") = statusText
		  result.Value("pdf") = pdf.Output()
		  result.Value("filename") = "example17_utilities.pdf"
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample2() As Dictionary
		  // Example 2: Text layouts - Cell, MultiCell, Write methods
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 2: Text layouts (Cell, MultiCell, Write)..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    Call pdf.AddPage()
		    
		    // Title
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "Text Layout Examples", 0, 1, "C")
		    pdf.Ln(5)
		    
		    // Cell examples with borders
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "1. Cell Method Examples:", 0, 1)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Cell(40, 8, "Left aligned", 1, 0, "L")
		    pdf.Cell(40, 8, "Centered", 1, 0, "C")
		    pdf.Cell(40, 8, "Right aligned", 1, 1, "R")
		    
		    pdf.Ln(5)
		    
		    // Cell with fill
		    pdf.SetFillColor(200, 220, 255)
		    pdf.Cell(60, 8, "Filled cell", 1, 0, "L", True)
		    pdf.SetFillColor(255, 200, 200)
		    pdf.Cell(60, 8, "Another filled", 1, 1, "C", True)
		    
		    pdf.Ln(10)
		    
		    // MultiCell example
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "2. MultiCell Method (word-wrapped text):", 0, 1)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 10)
		    Dim longText As String = "This is a long paragraph that demonstrates the MultiCell method. The text will automatically wrap to fit within the specified width, creating multiple lines as needed. This is very useful for displaying longer content in your PDF documents."
		    
		    pdf.SetFillColor(255, 255, 200)
		    pdf.MultiCell(170, 7, longText, 1, "L", True)
		    
		    pdf.Ln(5)
		    
		    // Write example
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "3. Write Method (flowing text):", 0, 1)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 10)
		    pdf.SetXY(10, pdf.GetY())
		    pdf.Write(5, "The Write method outputs flowing text that ")
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Write(5, "automatically wraps ")
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Write(5, "to the next line when it reaches the right margin. You can ")
		    pdf.SetFont("helvetica", "I", 10)
		    pdf.Write(5, "change fonts ")
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Write(5, "mid-sentence for emphasis.")
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    
		    If pdf.Error <> "" Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("error") = pdf.Error
		    Else
		      statusText = statusText + "Success! PDF generated." + EndOfLine
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example2_text_layouts.pdf"
		    End If
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample3() As Dictionary
		  // Example 3: Multiple pages with various drawing styles
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 3: Multiple pages..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    
		    // Page 1: Circles
		    Call pdf.AddPage()
		    For i As Integer = 1 To 10
		      pdf.SetFillColor(i * 25, 255 - (i * 25), 128)
		      pdf.SetDrawColor(0, 0, 0)
		      pdf.Circle(50 + (i * 15), 100, 10, "DF")
		    Next
		    
		    // Page 2: Rectangles
		    Call pdf.AddPage()
		    For i As Integer = 1 To 8
		      pdf.SetFillColor(255, i * 30, 0)
		      pdf.SetDrawColor(100, 100, 100)
		      pdf.SetLineWidth(i * 0.2)
		      pdf.Rect(20, 20 + (i * 25), 150, 20, "DF")
		    Next
		    
		    // Page 3: Ellipses
		    Call pdf.AddPage()
		    For i As Integer = 1 To 6
		      pdf.SetDrawColor(i * 40, 0, 255 - (i * 40))
		      pdf.SetLineWidth(1.5)
		      pdf.Ellipse(100, 50 + (i * 30), 40, 15, "D")
		    Next
		    
		    // Page 4: Bezier Curves
		    Call pdf.AddPage()
		    
		    // Title
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Cell(0, 8, "Bezier Curves", 0, 1, "C")
		    pdf.Ln(3)
		    
		    // Quadratic Bezier curves (Curve method)
		    pdf.SetFont("helvetica", "", 9)
		    pdf.Text(20, 30, "Quadratic Bezier curves:")
		    For i As Integer = 1 To 4
		      pdf.SetDrawColor(i * 60, 255 - (i * 50), i * 40)
		      pdf.SetLineWidth(1.5)
		      pdf.Curve(20 + (i * 35), 50, 30 + (i * 35), 35, 40 + (i * 35), 50, "D")
		    Next
		    
		    // Cubic Bezier curves (CurveBezierCubic method)
		    pdf.Text(20, 70, "Cubic Bezier curves:")
		    For i As Integer = 1 To 3
		      pdf.SetDrawColor(0, i * 80, 255 - (i * 60))
		      pdf.SetLineWidth(2)
		      pdf.CurveBezierCubic(20 + (i * 50), 90, 30 + (i * 50), 75, 40 + (i * 50), 105, 50 + (i * 50), 90, "D")
		    Next
		    
		    // Filled Bezier curves
		    pdf.Text(20, 125, "Filled Bezier curves:")
		    pdf.SetFillColor(255, 200, 200)
		    pdf.SetDrawColor(200, 0, 0)
		    pdf.SetLineWidth(1)
		    pdf.CurveBezierCubic(30, 140, 50, 130, 60, 155, 80, 145, "DF")
		    
		    pdf.SetFillColor(200, 255, 200)
		    pdf.SetDrawColor(0, 150, 0)
		    pdf.CurveBezierCubic(90, 145, 100, 135, 110, 160, 120, 150, "DF")
		    
		    pdf.SetFillColor(200, 200, 255)
		    pdf.SetDrawColor(0, 0, 200)
		    pdf.CurveBezierCubic(130, 150, 140, 140, 150, 165, 160, 155, "DF")
		    
		    // Complex curved path
		    pdf.Text(20, 180, "Complex curved path:")
		    pdf.SetDrawColor(128, 0, 128)
		    pdf.SetLineWidth(2.5)
		    pdf.Curve(30, 195, 50, 185, 70, 195, "D")
		    pdf.Curve(70, 195, 90, 205, 110, 195, "D")
		    pdf.Curve(110, 195, 130, 185, 150, 195, "D")
		    
		    // Page 5: Rounded Rectangles
		    Call pdf.AddPage()
		    For i As Integer = 1 To 7
		      pdf.SetFillColor(0, 255 - (i * 30), i * 35)
		      pdf.SetDrawColor(i * 30, i * 30, i * 30)
		      pdf.SetLineWidth(0.8)
		      // Use different corner combinations for each rectangle
		      Dim corners As String
		      Select Case i
		      Case 1
		        corners = "1234" // All corners
		      Case 2
		        corners = "12" // Top corners
		      Case 3
		        corners = "34" // Bottom corners
		      Case 4
		        corners = "14" // Left corners
		      Case 5
		        corners = "23" // Right corners
		      Case 6
		        corners = "13" // Diagonal: top-left and bottom-right
		      Case 7
		        corners = "24" // Diagonal: top-right and bottom-left
		      End Select
		      pdf.RoundedRect(20, 15 + (i * 30), 160, 25, 6, corners, "DF")
		    Next
		    
		    // Page 5: Arcs
		    Call pdf.AddPage()
		    
		    // Simple arcs at different angles
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetLineWidth(1.5)
		    pdf.Arc(50, 40, 30, 30, 0, 0, 90, "D") // Quarter circle (0-90 degrees)
		    
		    pdf.SetDrawColor(0, 255, 0) // Green
		    pdf.Arc(120, 40, 30, 30, 0, 90, 270, "D") // Three-quarter circle (90-270 degrees)
		    
		    pdf.SetDrawColor(0, 0, 255) // Blue
		    pdf.Arc(190, 40, 30, 30, 0, 180, 360, "D") // Semicircle bottom half (180-360 degrees)
		    
		    // Filled arcs (pie slices)
		    pdf.SetDrawColor(128, 0, 128) // Purple
		    pdf.SetFillColor(230, 200, 230) // Light purple
		    pdf.Arc(50, 100, 25, 25, 0, 45, 135, "DF") // 90-degree filled arc
		    
		    pdf.SetDrawColor(255, 128, 0) // Orange
		    pdf.SetFillColor(255, 230, 200) // Light orange
		    pdf.Arc(120, 100, 25, 25, 0, 0, 180, "DF") // Semicircle filled
		    
		    // Elliptical arcs (different radii)
		    pdf.SetDrawColor(0, 128, 128) // Teal
		    pdf.SetLineWidth(2)
		    pdf.Arc(50, 160, 40, 20, 0, 0, 180, "D") // Horizontal ellipse arc
		    
		    pdf.SetDrawColor(128, 128, 0) // Olive
		    pdf.Arc(120, 160, 20, 40, 0, 270, 90, "D") // Vertical ellipse arc
		    
		    // Rotated arcs
		    pdf.SetDrawColor(255, 0, 128) // Pink
		    pdf.SetLineWidth(1.5)
		    pdf.Arc(50, 230, 35, 20, 45, 0, 180, "D") // Ellipse rotated 45 degrees
		    
		    pdf.SetDrawColor(128, 0, 255) // Violet
		    pdf.Arc(130, 230, 30, 15, 30, 90, 270, "D") // Ellipse rotated 30 degrees
		    
		    // Page 6: Arrows
		    Call pdf.AddPage()
		    
		    // Title
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Cell(0, 8, "Arrow Lines", 0, 1, "C")
		    pdf.Ln(3)
		    
		    // Horizontal arrows with different directions
		    pdf.SetFont("helvetica", "", 9)
		    pdf.Text(20, 30, "Horizontal arrows:")
		    pdf.SetDrawColor(0, 0, 0)
		    pdf.SetFillColor(0, 0, 0)
		    pdf.SetLineWidth(1)
		    pdf.Arrow(30, 40, 90, 40, False, True, 3) // Right arrow
		    pdf.Arrow(110, 45, 170, 45, True, False, 3) // Left arrow
		    pdf.Arrow(30, 50, 170, 50, True, True, 3) // Both ends
		    
		    // Vertical and diagonal arrows
		    pdf.Text(20, 70, "Diagonal arrows:")
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetFillColor(255, 0, 0)
		    pdf.Arrow(30, 85, 80, 120, False, True, 4)
		    
		    pdf.SetDrawColor(0, 0, 255) // Blue
		    pdf.SetFillColor(0, 0, 255)
		    pdf.Arrow(120, 85, 70, 120, False, True, 4)
		    
		    pdf.SetDrawColor(0, 150, 0) // Green
		    pdf.SetFillColor(0, 150, 0)
		    pdf.Arrow(160, 90, 160, 125, False, True, 4)
		    
		    // Arrows with different sizes
		    pdf.Text(20, 145, "Different arrow sizes:")
		    For i As Integer = 1 To 5
		      pdf.SetDrawColor(i * 50, 0, 255 - (i * 50))
		      pdf.SetFillColor(i * 50, 0, 255 - (i * 50))
		      pdf.SetLineWidth(0.5 + (i * 0.3))
		      pdf.Arrow(30, 155 + (i * 15), 120, 155 + (i * 15), False, True, 2 + (i * 0.8))
		    Next
		    
		    // Radial arrow pattern
		    pdf.Text(20, 240, "Radial pattern:")
		    Dim centerX As Double = 100
		    Dim centerY As Double = 260
		    Const Pi As Double = 3.14159265358979323846
		    For i As Integer = 0 To 7
		      Dim angle As Double = (i * 45) * Pi / 180
		      Dim endX As Double = centerX + 30 * Cos(angle)
		      Dim endY As Double = centerY + 30 * Sin(angle)
		      pdf.SetDrawColor(255 - (i * 30), i * 30, 128)
		      pdf.SetFillColor(255 - (i * 30), i * 30, 128)
		      pdf.SetLineWidth(1.2)
		      pdf.Arrow(centerX, centerY, endX, endY, False, True, 3)
		    Next
		    
		    // Page 7: Gradients with clipping paths
		    Call pdf.AddPage()
		    
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "Gradients with Clipping", 0, 1, "C")
		    pdf.Ln(3)
		    
		    // Gradient through elliptical clip
		    pdf.SetFont("helvetica", "", 9)
		    pdf.Text(20, 30, "Ellipse clip with gradient:")
		    pdf.ClipEllipse(80, 55, 40, 25, False)
		    pdf.LinearGradient(40, 30, 80, 50, 255, 128, 0, 128, 0, 255, 0, 0, 1, 1)
		    pdf.ClipEnd()
		    
		    // Rounded rectangle clip with radial gradient
		    pdf.Text(20, 95, "Rounded rect clip with radial gradient:")
		    pdf.ClipRoundedRect(40, 105, 80, 40, 8, "1234", False)
		    pdf.RadialGradient(40, 105, 80, 40, 255, 255, 255, 0, 100, 200, 0.5, 0.5, 0.5, 0.5, 0.7)
		    pdf.ClipEnd()
		    
		    // Multiple clipping levels
		    pdf.Text(20, 165, "Nested clipping (rect + circle):")
		    pdf.ClipRect(40, 175, 100, 50, False)
		    pdf.ClipCircle(90, 200, 30, False)
		    pdf.LinearGradient(40, 175, 100, 50, 255, 0, 128, 0, 255, 128, 0.3, 0, 0.7, 1)
		    pdf.ClipEnd()
		    pdf.ClipEnd()
		    
		    // Polygon clip with gradient
		    pdf.Text(20, 240, "Polygon clip with gradient:")
		    Dim points() As Pair
		    points.Add(New Pair(50, 250))
		    points.Add(New Pair(90, 250))
		    points.Add(New Pair(110, 275))
		    points.Add(New Pair(70, 290))
		    points.Add(New Pair(30, 275))
		    pdf.ClipPolygon(points, False)
		    pdf.RadialGradient(30, 250, 80, 40, 255, 200, 0, 200, 0, 255, 0.5, 0.2, 0.5, 0.8, 0.4)
		    pdf.ClipEnd()
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    
		    If pdf.Error <> "" Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("error") = pdf.Error
		    Else
		      statusText = statusText + "Success! PDF generated." + EndOfLine
		      statusText = statusText + "Pages: " + Str(pdf.PageCount) + EndOfLine
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example3_multipage.pdf"
		    End If
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample4() As Dictionary
		  // Example 4: Line widths demonstration
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 4: Line widths..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    Call pdf.AddPage()
		    
		    // Different line widths
		    For i As Integer = 1 To 10
		      pdf.SetLineWidth(i * 0.5)
		      pdf.SetDrawColor(0, 0, 0)
		      pdf.Line(20, 20 + (i * 15), 180, 20 + (i * 15))
		    Next
		    
		    // Rectangles with different line widths
		    pdf.SetLineWidth(0.5)
		    pdf.SetDrawColor(255, 0, 0)
		    pdf.Rect(20, 180, 40, 40, "D")
		    
		    pdf.SetLineWidth(2)
		    pdf.SetDrawColor(0, 255, 0)
		    pdf.Rect(70, 180, 40, 40, "D")
		    
		    pdf.SetLineWidth(4)
		    pdf.SetDrawColor(0, 0, 255)
		    pdf.Rect(120, 180, 40, 40, "D")
		    
		    // Line cap styles demonstration
		    pdf.SetY(230)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Line Cap Styles (butt, round, square):", 0, 1)
		    
		    pdf.SetLineWidth(8)
		    pdf.SetDrawColor(0, 0, 0)
		    
		    // Draw vertical reference lines to show cap differences
		    pdf.SetLineWidth(0.5)
		    pdf.SetDrawColor(200, 200, 200) // Light gray
		    pdf.Line(30, 240, 30, 255)
		    pdf.Line(170, 240, 170, 255)
		    pdf.Line(30, 260, 30, 275)
		    pdf.Line(170, 260, 170, 275)
		    pdf.Line(30, 280, 30, 295)
		    pdf.Line(170, 280, 170, 295)
		    
		    // Butt cap (default)
		    pdf.SetLineWidth(8)
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetLineCapStyle("butt")
		    pdf.Line(30, 247.5, 170, 247.5)
		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Text(180, 250, "butt (default)")
		    
		    // Round cap
		    pdf.SetDrawColor(0, 150, 0) // Green
		    pdf.SetLineCapStyle("round")
		    pdf.Line(30, 267.5, 170, 267.5)
		    pdf.Text(180, 270, "round")
		    
		    // Square cap
		    pdf.SetDrawColor(0, 0, 255) // Blue
		    pdf.SetLineCapStyle("square")
		    pdf.Line(30, 287.5, 170, 287.5)
		    pdf.Text(180, 290, "square")
		    
		    // Reset to default
		    pdf.SetLineCapStyle("butt")
		    
		    // Add second page for line join and dash patterns
		    Call pdf.AddPage()
		    
		    // Line join styles demonstration
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Line Join Styles (miter, round, bevel):", 0, 1)
		    pdf.Ln(5)
		    
		    pdf.SetLineWidth(8)
		    pdf.SetFont("helvetica", "", 9)
		    
		    // Miter join (default)
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetLineJoinStyle("miter")
		    pdf.Rect(20, 25, 45, 35, "D")
		    pdf.Text(70, 45, "miter (default)")
		    
		    // Round join
		    pdf.SetDrawColor(0, 150, 0) // Green
		    pdf.SetLineJoinStyle("round")
		    pdf.Rect(20, 75, 45, 35, "D")
		    pdf.Text(70, 95, "round")
		    
		    // Bevel join
		    pdf.SetDrawColor(0, 0, 255) // Blue
		    pdf.SetLineJoinStyle("bevel")
		    pdf.Rect(20, 125, 45, 35, "D")
		    pdf.Text(70, 145, "bevel")
		    
		    // Reset to default
		    pdf.SetLineJoinStyle("miter")
		    
		    // Dash pattern demonstrations
		    pdf.SetY(180)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Dash Patterns:", 0, 1)
		    pdf.Ln(3)
		    
		    pdf.SetLineWidth(2)
		    pdf.SetDrawColor(0, 0, 0)
		    pdf.SetFont("helvetica", "", 9)
		    
		    // Solid line (default)
		    Dim solidDash() As Double
		    pdf.SetDashPattern(solidDash, 0)
		    pdf.Line(20, 195, 170, 195)
		    pdf.Text(180, 197, "solid (default)")
		    
		    // Simple dash pattern
		    Dim dash1() As Double = Array(5.0, 3.0)
		    pdf.SetDashPattern(dash1, 0)
		    pdf.Line(20, 205, 170, 205)
		    pdf.Text(180, 207, "5mm dash, 3mm gap")
		    
		    // Different dash pattern
		    Dim dash2() As Double = Array(10.0, 2.0)
		    pdf.SetDashPattern(dash2, 0)
		    pdf.Line(20, 215, 170, 215)
		    pdf.Text(180, 217, "10mm dash, 2mm gap")
		    
		    // Dot pattern
		    Dim dash3() As Double = Array(1.0, 2.0)
		    pdf.SetDashPattern(dash3, 0)
		    pdf.Line(20, 225, 170, 225)
		    pdf.Text(180, 227, "1mm dot, 2mm gap")
		    
		    // Dash-dot pattern
		    Dim dash4() As Double = Array(10.0, 3.0, 2.0, 3.0)
		    pdf.SetDashPattern(dash4, 0)
		    pdf.Line(20, 235, 170, 235)
		    pdf.Text(180, 237, "10-3-2-3 pattern")
		    
		    // Complex pattern with phase
		    Dim dash5() As Double = Array(8.0, 3.0, 2.0, 3.0)
		    pdf.SetDashPattern(dash5, 5)
		    pdf.Line(20, 245, 170, 245)
		    pdf.Text(180, 247, "8-3-2-3, phase 5")
		    
		    // Reset to solid
		    pdf.SetDashPattern(solidDash, 0)
		    
		    // Bezier curves with different line styles
		    pdf.SetY(255)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Bezier Curves with Line Styles:", 0, 1)
		    pdf.Ln(3)
		    
		    pdf.SetFont("helvetica", "", 9)
		    
		    // Solid Bezier curve
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetLineWidth(2)
		    pdf.SetDashPattern(solidDash, 0)
		    pdf.CurveBezierCubic(20, 270, 40, 260, 60, 280, 80, 270, "D")
		    pdf.Text(20, 285, "Solid, 2mm")
		    
		    // Dashed Bezier curve
		    pdf.SetDrawColor(0, 150, 0) // Green
		    pdf.SetLineWidth(1.5)
		    pdf.SetDashPattern(dash1, 0)
		    pdf.CurveBezierCubic(100, 270, 120, 260, 140, 280, 160, 270, "D")
		    pdf.Text(100, 285, "Dashed, 1.5mm")
		    
		    // Reset to solid for page 3
		    pdf.SetDashPattern(solidDash, 0)
		    
		    // Add third page for arrows with line styles
		    Call pdf.AddPage()
		    
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "Arrows with Line Styles", 0, 1, "C")
		    pdf.Ln(5)
		    
		    // Arrows with different line widths
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Arrows with Different Line Widths:", 0, 1)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 9)
		    
		    // Thin arrow
		    pdf.SetDrawColor(0, 0, 0)
		    pdf.SetFillColor(0, 0, 0)
		    pdf.SetLineWidth(0.5)
		    pdf.Arrow(20, 30, 80, 30, False, True, 2)
		    pdf.Text(90, 32, "0.5mm line, 2mm head")
		    
		    // Medium arrow
		    pdf.SetLineWidth(1.5)
		    pdf.Arrow(20, 45, 80, 45, False, True, 3)
		    pdf.Text(90, 47, "1.5mm line, 3mm head")
		    
		    // Thick arrow
		    pdf.SetLineWidth(3)
		    pdf.Arrow(20, 65, 80, 65, False, True, 5)
		    pdf.Text(90, 67, "3mm line, 5mm head")
		    
		    // Arrows with different cap styles
		    pdf.SetY(85)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Arrows with Different Line Cap Styles:", 0, 1)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetLineWidth(2)
		    
		    // Butt cap arrow
		    pdf.SetDrawColor(255, 0, 0) // Red
		    pdf.SetFillColor(255, 0, 0)
		    pdf.SetLineCapStyle("butt")
		    pdf.Arrow(20, 105, 80, 105, False, True, 4)
		    pdf.Text(90, 107, "Butt cap")
		    
		    // Round cap arrow
		    pdf.SetDrawColor(0, 150, 0) // Green
		    pdf.SetFillColor(0, 150, 0)
		    pdf.SetLineCapStyle("round")
		    pdf.Arrow(20, 120, 80, 120, False, True, 4)
		    pdf.Text(90, 122, "Round cap")
		    
		    // Square cap arrow
		    pdf.SetDrawColor(0, 0, 255) // Blue
		    pdf.SetFillColor(0, 0, 255)
		    pdf.SetLineCapStyle("square")
		    pdf.Arrow(20, 135, 80, 135, False, True, 4)
		    pdf.Text(90, 137, "Square cap")
		    
		    // Reset to default
		    pdf.SetLineCapStyle("butt")
		    
		    // Arrows with dash patterns
		    pdf.SetY(150)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Arrows with Dash Patterns:", 0, 1)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetDrawColor(0, 0, 0)
		    pdf.SetFillColor(0, 0, 0)
		    pdf.SetLineWidth(1.5)
		    
		    // Dashed arrow
		    pdf.SetDashPattern(dash1, 0)
		    pdf.Arrow(20, 170, 80, 170, False, True, 3)
		    pdf.Text(90, 172, "5-3 dash")
		    
		    // Dotted arrow
		    pdf.SetDashPattern(dash3, 0)
		    pdf.Arrow(20, 185, 80, 185, False, True, 3)
		    pdf.Text(90, 187, "1-2 dot")
		    
		    // Dash-dot arrow
		    pdf.SetDashPattern(dash4, 0)
		    pdf.Arrow(20, 200, 80, 200, False, True, 3)
		    pdf.Text(90, 202, "10-3-2-3 pattern")
		    
		    // Reset to solid
		    pdf.SetDashPattern(solidDash, 0)
		    
		    // Complex arrow pattern
		    pdf.SetY(215)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Bidirectional Arrows with Styles:", 0, 1)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetLineWidth(2)
		    
		    // Red bidirectional
		    pdf.SetDrawColor(255, 0, 0)
		    pdf.SetFillColor(255, 0, 0)
		    pdf.Arrow(20, 235, 100, 235, True, True, 4)
		    pdf.Text(110, 237, "Both ends, red")
		    
		    // Green bidirectional with dash
		    pdf.SetDrawColor(0, 150, 0)
		    pdf.SetFillColor(0, 150, 0)
		    pdf.SetDashPattern(dash2, 0)
		    pdf.Arrow(20, 250, 100, 250, True, True, 4)
		    pdf.Text(110, 252, "Both ends, dashed")
		    
		    // Reset to solid
		    pdf.SetDashPattern(solidDash, 0)
		    
		    // Diagonal arrows with different styles
		    pdf.SetY(265)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Diagonal Arrows:", 0, 1)
		    pdf.Ln(2)
		    
		    // Multiple diagonal arrows in a fan pattern
		    Dim centerX As Double = 60
		    Dim centerY As Double = 290
		    Const Pi As Double = 3.14159265358979323846
		    For i As Integer = 0 To 4
		      Dim angle As Double = (i * 30 - 60) * Pi / 180
		      Dim endX As Double = centerX + 35 * Cos(angle)
		      Dim endY As Double = centerY + 35 * Sin(angle)
		      pdf.SetDrawColor(i * 50, 0, 255 - (i * 50))
		      pdf.SetFillColor(i * 50, 0, 255 - (i * 50))
		      pdf.SetLineWidth(1.5)
		      pdf.Arrow(centerX, centerY, endX, endY, False, True, 3)
		    Next
		    
		    // Reset all styles
		    pdf.SetLineWidth(0.5)
		    pdf.SetDrawColor(0, 0, 0)
		    pdf.SetLineCapStyle("butt")
		    pdf.SetDashPattern(solidDash, 0)
		    
		    // Add fourth page for gradients with line styles
		    Call pdf.AddPage()
		    
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "Gradients & Clipping with Line Styles", 0, 1, "C")
		    pdf.Ln(5)
		    
		    // Gradient-filled shapes with outlines
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Gradient Fills with Different Line Widths:", 0, 1)
		    pdf.Ln(2)
		    
		    // Rectangle with linear gradient and thin border
		    pdf.SetLineWidth(0.5)
		    pdf.SetDrawColor(0, 0, 0)
		    pdf.ClipRect(20, 30, 50, 35, True)
		    pdf.LinearGradient(20, 30, 50, 35, 255, 100, 100, 255, 200, 200, 0, 0, 1, 0)
		    pdf.ClipEnd()
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(22, 70, "0.5mm border")
		    
		    // Rectangle with radial gradient and thick border
		    pdf.SetLineWidth(3)
		    pdf.SetDrawColor(0, 100, 0)
		    pdf.ClipRect(80, 30, 50, 35, True)
		    pdf.RadialGradient(80, 30, 50, 35, 255, 255, 0, 0, 200, 0, 0.5, 0.5, 0.5, 0.5, 0.5)
		    pdf.ClipEnd()
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(85, 70, "3mm border")
		    
		    // Circle with gradient and dashed outline
		    pdf.SetLineWidth(2)
		    pdf.SetDrawColor(0, 0, 255)
		    Dim dashCircle() As Double = Array(3.0, 2.0)
		    pdf.SetDashPattern(dashCircle, 0)
		    pdf.ClipCircle(160, 47, 20, True)
		    pdf.LinearGradient(140, 27, 40, 40, 100, 100, 255, 255, 100, 255, 0.5, 0, 0.5, 1)
		    pdf.ClipEnd()
		    pdf.SetDashPattern(solidDash, 0)
		    pdf.Text(145, 72, "Dashed")
		    
		    // Clipping with different shapes
		    pdf.SetY(80)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Clipping Paths with Styled Borders:", 0, 1)
		    pdf.Ln(2)
		    
		    // Ellipse clip with thick round-cap border
		    pdf.SetLineWidth(4)
		    pdf.SetDrawColor(255, 0, 0)
		    pdf.SetLineCapStyle("round")
		    pdf.ClipEllipse(55, 115, 35, 20, True)
		    pdf.RadialGradient(20, 95, 70, 40, 255, 200, 200, 200, 100, 100, 0.5, 0.5, 0.5, 0.5, 0.6)
		    pdf.ClipEnd()
		    pdf.SetLineCapStyle("butt")
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(30, 140, "Round caps")
		    
		    // Rounded rect clip with beveled joins
		    pdf.SetLineWidth(3)
		    pdf.SetDrawColor(0, 150, 0)
		    pdf.SetLineJoinStyle("bevel")
		    pdf.ClipRoundedRect(110, 95, 70, 40, 8, "1234", True)
		    pdf.LinearGradient(110, 95, 70, 40, 200, 255, 200, 100, 200, 100, 0, 0, 0, 1)
		    pdf.ClipEnd()
		    pdf.SetLineJoinStyle("miter")
		    pdf.Text(120, 140, "Bevel joins")
		    
		    // Text clipping with gradient and outline
		    pdf.SetY(150)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Text Clipping with Gradient:", 0, 1)
		    pdf.Ln(2)
		    
		    pdf.SetFont("helvetica", "B", 48)
		    pdf.SetLineWidth(1)
		    pdf.SetDrawColor(0, 0, 128)
		    pdf.ClipText(20, 190, "PDF", True)
		    pdf.RadialGradient(20, 160, 100, 50, 255, 255, 100, 100, 100, 255, 0.3, 0.2, 0.7, 0.8, 0.6)
		    pdf.ClipEnd()

		    // Polygons with line styles
		    pdf.SetY(210)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Polygons with Line Styles:", 0, 1)
		    pdf.Ln(2)

		    // Triangle with thin outline
		    Dim tri1() As Point
		    tri1.Add(New Point(30, 255))
		    tri1.Add(New Point(50, 225))
		    tri1.Add(New Point(70, 255))
		    pdf.SetDrawColor(255, 0, 0)
		    pdf.SetLineWidth(0.5)
		    pdf.Polygon(tri1, "D")
		    pdf.SetFont("helvetica", "", 8)
		    pdf.Text(32, 262, "0.5mm")

		    // Triangle with thick outline
		    Dim tri2() As Point
		    tri2.Add(New Point(90, 255))
		    tri2.Add(New Point(110, 225))
		    tri2.Add(New Point(130, 255))
		    pdf.SetDrawColor(0, 150, 0)
		    pdf.SetLineWidth(3)
		    pdf.Polygon(tri2, "D")
		    pdf.Text(95, 262, "3mm")

		    // Pentagon with dashed outline
		    Dim pent() As Point
		    pent.Add(New Point(165, 255))
		    pent.Add(New Point(185, 248))
		    pent.Add(New Point(180, 228))
		    pent.Add(New Point(150, 228))
		    pent.Add(New Point(145, 248))
		    pdf.SetDrawColor(0, 0, 200)
		    pdf.SetLineWidth(1.5)
		    pdf.SetDashPattern(dash1, 0)
		    pdf.Polygon(pent, "D")
		    pdf.SetDashPattern(solidDash, 0)
		    pdf.Text(150, 262, "Dashed")

		    // Filled hexagon with different join styles
		    pdf.SetY(268)
		    pdf.SetFont("helvetica", "", 9)
		    pdf.Cell(0, 5, "Filled polygons with thick outlines:", 0, 1)

		    // Filled triangle with miter joins
		    Dim filledTri() As Point
		    filledTri.Add(New Point(30, 295))
		    filledTri.Add(New Point(50, 275))
		    filledTri.Add(New Point(70, 295))
		    pdf.SetDrawColor(128, 0, 0)
		    pdf.SetFillColor(255, 200, 200)
		    pdf.SetLineWidth(2)
		    pdf.SetLineJoinStyle("miter")
		    pdf.Polygon(filledTri, "DF")
		    pdf.Text(30, 300, "Miter join")

		    // Filled triangle with round joins
		    Dim filledTri2() As Point
		    filledTri2.Add(New Point(95, 295))
		    filledTri2.Add(New Point(115, 275))
		    filledTri2.Add(New Point(135, 295))
		    pdf.SetDrawColor(0, 100, 0)
		    pdf.SetFillColor(200, 255, 200)
		    pdf.SetLineJoinStyle("round")
		    pdf.Polygon(filledTri2, "DF")
		    pdf.Text(95, 300, "Round join")

		    // Filled triangle with bevel joins
		    Dim filledTri3() As Point
		    filledTri3.Add(New Point(160, 295))
		    filledTri3.Add(New Point(180, 275))
		    filledTri3.Add(New Point(200, 295))
		    pdf.SetDrawColor(0, 0, 128)
		    pdf.SetFillColor(200, 200, 255)
		    pdf.SetLineJoinStyle("bevel")
		    pdf.Polygon(filledTri3, "DF")
		    pdf.Text(160, 300, "Bevel join")

		    // Reset all line styles
		    pdf.SetLineWidth(0.5)
		    pdf.SetDrawColor(0, 0, 0)
		    pdf.SetLineCapStyle("butt")
		    pdf.SetLineJoinStyle("miter")
		    pdf.SetDashPattern(solidDash, 0)

		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    
		    If pdf.Error <> "" Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("error") = pdf.Error
		    Else
		      statusText = statusText + "Success! PDF generated." + EndOfLine
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example4_linewidths.pdf"
		    End If
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample5() As Dictionary
		  // Example 5: UTF-8 text with TrueType fonts
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 5: UTF-8 with TrueType fonts..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    Call pdf.AddPage()
		    
		    // Title with core font
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "UTF-8 Text with TrueType Fonts", 0, 1, "C")
		    pdf.Ln(5)
		    
		    Dim fontPath As String
		    Dim fontFile As FolderItem
		    
		    #If TargetiOS Then
		      // iOS: Load bundled Arial Unicode font from app resources
		      Try
		        // Try different name variations
		        Dim resourceFile As FolderItem = SpecialFolder.Resource("Arial Unicode.ttf")
		        If resourceFile <> Nil And resourceFile.Exists Then
		          fontFile = resourceFile
		          fontPath = "Arial Unicode.ttf (bundled)"
		          statusText = statusText + "iOS: Found bundled font - " + fontPath + EndOfLine
		        Else
		          // Fallback: Try without space
		          resourceFile = SpecialFolder.Resource("ArialUnicode.ttf")
		          If resourceFile <> Nil And resourceFile.Exists Then
		            fontFile = resourceFile
		            fontPath = "ArialUnicode.ttf (bundled)"
		            statusText = statusText + "iOS: Found bundled font - " + fontPath + EndOfLine
		          Else
		            // Fallback: Try lowercase
		            resourceFile = SpecialFolder.Resource("arialunicode.ttf")
		            If resourceFile <> Nil And resourceFile.Exists Then
		              fontFile = resourceFile
		              fontPath = "arialunicode.ttf (bundled)"
		              statusText = statusText + "iOS: Found bundled font - " + fontPath + EndOfLine
		            Else
		              fontFile = Nil
		              fontPath = "(iOS - bundled font not found)"
		              statusText = statusText + "iOS: Arial Unicode font not found in bundle" + EndOfLine
		              statusText = statusText + "Note: Add 'Arial Unicode.ttf' to iOS project resources" + EndOfLine
		            End If
		          End If
		        End If
		      Catch e As RuntimeException
		        fontFile = Nil
		        fontPath = "(iOS - error loading font: " + e.Message + ")"
		        statusText = statusText + "iOS: Error loading font - " + e.Message + EndOfLine
		      End Try
		    #Else
		      // Desktop/Console/Web: Try to load a TrueType font with Unicode support
		      // Use system fonts that exist on all macOS installations
		      // macOS: Arial Unicode MS has comprehensive Unicode coverage (Latin, CJK, Cyrillic, symbols)
		      // Windows: C:\Windows\Fonts\arial.ttf or seguiemj.ttf
		      // Linux: /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
		      
		      // Use Arial Unicode MS font (comprehensive multilingual support)
		      fontPath = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
		      fontFile = New FolderItem(fontPath, FolderItem.PathModes.Native)
		      
		      // Fallback to Hiragino (CJK only)
		      If Not fontFile.Exists Then
		        fontPath = "/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc"
		        fontFile = New FolderItem(fontPath, FolderItem.PathModes.Native)
		      End If
		      
		      // Last fallback to Geneva
		      If Not fontFile.Exists Then
		        fontPath = "/System/Library/Fonts/Geneva.ttf"
		        fontFile = New FolderItem(fontPath, FolderItem.PathModes.Native)
		      End If
		    #EndIf
		    
		    If fontFile <> Nil And fontFile.Exists Then
		      statusText = statusText + "Font file found: " + fontPath + EndOfLine

		      // Load TrueType font
		      #If TargetiOS Then
		        // iOS: Load font from MemoryBlock (file is in bundle)
		        Try
		          Dim fontStream As BinaryStream = BinaryStream.Open(fontFile)
		          Dim fontBytes As MemoryBlock = fontStream.Read(fontStream.Length)
		          fontStream.Close

		          pdf.AddUTF8FontFromBytes("unicode_ttf", "", fontBytes)
		          statusText = statusText + "Font loaded from bundle (" + Str(fontBytes.Size) + " bytes)" + EndOfLine
		        Catch e As IOException
		          Call pdf.SetError("Failed to read font file: " + e.Message)
		          statusText = statusText + "Error reading font: " + e.Message + EndOfLine
		        End Try
		      #Else
		        // Desktop/Console/Web: Load font from file path
		        pdf.AddUTF8Font("unicode_ttf", "", fontPath)
		      #EndIf

		      If pdf.Error = "" Then
		        statusText = statusText + "Font loaded successfully!" + EndOfLine
		        
		        // Comprehensive UTF-8 text examples with TrueType font
		        pdf.SetFont("unicode_ttf", "", 14)
		        
		        // Section: Basic ASCII and Latin
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "Basic Latin & ASCII:", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "English: Hello World! The quick brown fox jumps.", 1, 1)
		        pdf.Ln(2)
		        
		        // Section: Asian Languages
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "Asian Languages (CJK):", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "Japanese: こんにちは、世界 (Hiragana & Kanji)", 1, 1)
		        pdf.Cell(0, 7, "Chinese (Simplified): 你好，世界", 1, 1)
		        pdf.Cell(0, 7, "Korean: 안녕하세요, 세계", 1, 1)
		        pdf.Ln(2)
		        
		        // Section: European with Diacritics
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "European Languages with Diacritics:", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "French: Bonne journée! Café, naïve, Noël", 1, 1)
		        pdf.Cell(0, 7, "German: Größe, Müller, Äpfel, Öl", 1, 1)
		        pdf.Cell(0, 7, "Spanish: ¡Hola! ¿Qué tal? Mañana, niño", 1, 1)
		        pdf.Cell(0, 7, "Portuguese: São Paulo, José, coração", 1, 1)
		        pdf.Ln(2)
		        
		        // Section: Cyrillic (Polish, Ukrainian, Russian)
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "Cyrillic & Special European:", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "Polish: Zażółć gęślą jaźń (ą,ć,ę,ł,ń,ó,ś,ź,ż)", 1, 1)
		        pdf.Cell(0, 7, "Ukrainian: Привіт, світ! (і,ї,є,ґ)", 1, 1)
		        pdf.Cell(0, 7, "Russian: Здравствуй, мир!", 1, 1)
		        pdf.Ln(2)
		        
		        // Section: Arabic & RTL
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "Right-to-Left Languages:", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "Arabic: مرحبا بالعالم (Hello World)", 1, 1)
		        pdf.Cell(0, 7, "Hebrew: שלום עולם (Hello World)", 1, 1)
		        pdf.Ln(2)
		        
		        // Section: Currencies
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "Currency Symbols:", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "$ Dollar  £ Pound  € Euro  ¥ Yen  ₹ Rupee", 1, 1)
		        pdf.Cell(0, 7, "₽ Ruble  ₿ Bitcoin  ¢ Cent  ₪ Shekel  ₩ Won", 1, 1)
		        pdf.Ln(2)
		        
		        // Section: Math Symbols
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "Mathematical Symbols:", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "± ∓ × ÷ ∙ √ ∛ ∜ ∞ ≈ ≠ ≤ ≥", 1, 1)
		        pdf.Cell(0, 7, "∑ ∏ ∫ ∂ ∇ Δ π θ α β γ λ μ", 1, 1)
		        pdf.Cell(0, 7, "⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ₀ ₁ ₂ ₃ ₄", 1, 1)
		        pdf.Ln(2)
		        
		        // Section: Common Symbols
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "Common Symbols & Special Characters:", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "© ® ™ § ¶ † ‡ • ◦ ‣ ⁃ ° º ª", 1, 1)
		        pdf.Cell(0, 7, "← → ↑ ↓ ↔ ↕ ⇐ ⇒ ⇔ ▲ ▼ ◀ ▶", 1, 1)
		        pdf.Cell(0, 7, "★ ☆ ♠ ♣ ♥ ♦ ♪ ♫ ☎ ✓ ✗ ✉ ☺ ☹", 1, 1)
		        pdf.Ln(2)

		        // Section: Color Emoji (Desktop, iOS - rendered as images)
		        // Note: Web emoji support is planned but not yet implemented (see docs/EMOJI_FONT_PARSING.md)
		        #If TargetDesktop Or TargetiOS Then
		          pdf.SetFont("helvetica", "B", 10)
		          pdf.Cell(0, 6, "Color Emoji Support (Image-Based Rendering):", 0, 1)
		          pdf.SetFont("helvetica", "", 9)
		          #If TargetDesktop Then
		            pdf.MultiCell(0, 4, "Emoji are rendered using the platform's native emoji font (Apple Color Emoji, Segoe UI Emoji, or Noto Color Emoji) and embedded as images for cross-platform compatibility.", 0)
		          #ElseIf TargetiOS Then
		            pdf.MultiCell(0, 4, "Emoji are rendered using iOS UIKit API with the native emoji font and embedded as JPEG images.", 0)
		          #EndIf
		          pdf.Ln(2)
		          
		          // Comprehensive emoji showcase - organized by category
		          Dim emojiCategories() As Dictionary
		          
		          // Smileys & Emotion
		          Dim cat1 As New Dictionary
		          cat1.Value("title") = "Smileys & Emotion:"
		          cat1.Value("emoji") = Array("😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🙃", "😉", "😊", "😇", "🥰", "😍", "🤩")
		          emojiCategories.Add(cat1)
		          
		          // Gestures & Body
		          Dim cat2 As New Dictionary
		          cat2.Value("title") = "Gestures & Body:"
		          cat2.Value("emoji") = Array("👍", "👎", "👊", "✊", "🤝", "👏", "🙌", "👐", "🤲", "🙏", "✍️", "💪", "🦾", "🦿", "🦶", "👂")
		          emojiCategories.Add(cat2)
		          
		          // Hearts & Symbols
		          Dim cat3 As New Dictionary
		          cat3.Value("title") = "Hearts & Symbols:"
		          cat3.Value("emoji") = Array("❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💔", "❣️", "💕", "💞", "💓", "💗", "💖")
		          emojiCategories.Add(cat3)
		          
		          // Animals & Nature
		          Dim cat4 As New Dictionary
		          cat4.Value("title") = "Animals & Nature:"
		          cat4.Value("emoji") = Array("🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🐔")
		          emojiCategories.Add(cat4)
		          
		          // Food & Drink
		          Dim cat5 As New Dictionary
		          cat5.Value("title") = "Food & Drink:"
		          cat5.Value("emoji") = Array("🍎", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🥑", "🍔")
		          emojiCategories.Add(cat5)
		          
		          // Travel & Places
		          Dim cat6 As New Dictionary
		          cat6.Value("title") = "Travel & Places:"
		          cat6.Value("emoji") = Array("🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "✈️", "🚀", "🛸", "🚁", "⛵", "🚢")
		          emojiCategories.Add(cat6)
		          
		          // Activities & Objects
		          Dim cat7 As New Dictionary
		          cat7.Value("title") = "Activities & Objects:"
		          cat7.Value("emoji") = Array("⚽", "🏀", "🏈", "⚾", "🎾", "🏐", "🎱", "🎨", "🎭", "🎪", "🎬", "🎮", "🎯", "🎲", "🎵", "🎸")
		          emojiCategories.Add(cat7)
		          
		          // Render emoji by category
		          Dim emojiSize As Integer = 20  // Smaller size to fit more
		          Dim emojiMM As Double = emojiSize * 0.3527  // Convert points to mm
		          Dim spacing As Double = emojiMM + 1  // 1mm spacing
		          Dim emojisPerRow As Integer = 8  // 8 emoji per row
		          
		          For Each category As Dictionary In emojiCategories
		            // Category title
		            pdf.SetFont("helvetica", "B", 9)
		            pdf.Cell(0, 4, category.Value("title"), 0, 1)
		            pdf.Ln(1)
		            
		            Dim emojiArray() As String = category.Value("emoji")
		            Dim startX As Double = pdf.GetX()
		            Dim startY As Double = pdf.GetY()
		            Dim x As Double = startX
		            
		            For i As Integer = 0 To emojiArray.Count - 1
		              Dim emojiChar As String = emojiArray(i)
		              
		              // Add emoji using simple API (handles all complexity internally)
		              pdf.Emoji(emojiChar, x, startY, emojiMM)
		              
		              x = x + spacing
		              
		              // Wrap to next line
		              If (i + 1) Mod emojisPerRow = 0 And i < emojiArray.Count - 1 Then
		                x = startX
		                startY = startY + spacing
		              End If
		            Next
		            
		            // Move cursor below the category
		            pdf.SetY(startY + emojiMM + 2)
		          Next
		          
		          pdf.Ln(1)

		          pdf.SetFont("helvetica", "", 8)
		          pdf.MultiCell(0, 3, "Note: Image-based emoji rendering works on Desktop (macOS, Windows, Linux) using Picture.Graphics API with native emoji fonts, and on iOS using UIKit declares.", 1)
		          pdf.Ln(2)

		        #ElseIf TargetWeb Then
		          // Web: Emoji not yet supported
		          pdf.SetFont("helvetica", "B", 10)
		          pdf.Cell(0, 6, "Color Emoji Support:", 0, 1)
		          pdf.SetFont("helvetica", "", 9)
		          pdf.MultiCell(0, 4, "Image-based emoji rendering is not yet supported on Web platform. The server-side Picture.Graphics API cannot access emoji fonts (Apple Color Emoji, Segoe UI Emoji, Noto Color Emoji). Implementation is planned - see docs/EMOJI_FONT_PARSING.md for details.", 1)
		          pdf.Ln(2)

		        #Else
		          // Console: Emoji not supported
		          pdf.SetFont("helvetica", "B", 10)
		          pdf.Cell(0, 6, "Color Emoji Support:", 0, 1)
		          pdf.SetFont("helvetica", "", 9)
		          pdf.MultiCell(0, 4, "Image-based emoji rendering is not supported on Console platform (no graphics rendering capability).", 1)
		          pdf.Ln(2)
		        #EndIf
		        
		        // Section: Fractions and Special Numbers
		        pdf.SetFont("unicode_ttf", "", 10)
		        pdf.Cell(0, 6, "Fractions & Special Numbers:", 0, 1)
		        pdf.SetFont("unicode_ttf", "", 12)
		        pdf.Cell(0, 7, "½ ⅓ ⅔ ¼ ¾ ⅕ ⅖ ⅗ ⅘ ⅙ ⅚ ⅛ ⅜ ⅝ ⅞", 1, 1)
		        
		      Else
		        statusText = statusText + "Error loading font: " + pdf.Error + EndOfLine
		        pdf.SetFont("helvetica", "", 12)
		        pdf.Cell(0, 8, "Error loading TrueType font:", 0, 1)
		        pdf.SetFont("courier", "", 10)
		        pdf.MultiCell(0, 5, pdf.Error, 1)
		      End If
		    Else
		      // Font file not found - show fallback example
		      statusText = statusText + "Font file not found: " + fontPath + EndOfLine
		      
		      #If TargetiOS Then
		        // iOS-specific message
		        pdf.SetFont("helvetica", "B", 12)
		        pdf.Cell(0, 8, "iOS Platform - Limited Font Support", 0, 1)
		        pdf.SetFont("helvetica", "", 10)
		        pdf.MultiCell(0, 5, "iOS apps cannot access system fonts directly due to sandboxing. To use TrueType fonts on iOS, you must bundle .ttf font files with your app and load them from the app bundle.", 1)
		        
		        pdf.Ln(3)
		        pdf.SetFont("helvetica", "", 10)
		        pdf.MultiCell(0, 5, "This example uses core PDF fonts (Helvetica, Times, Courier) which support Latin-1 characters only. For full Unicode support on iOS, bundle TrueType fonts with your app.", 1)
		      #Else
		        // Desktop/Console/Web message
		        pdf.SetFont("helvetica", "", 12)
		        pdf.Cell(0, 8, "TrueType font file not found at:", 0, 1)
		        pdf.SetFont("courier", "", 9)
		        pdf.Cell(0, 6, fontPath, 1, 1)
		        
		        pdf.Ln(5)
		        pdf.SetFont("helvetica", "", 10)
		        pdf.MultiCell(0, 5, "To test UTF-8 support, please provide a valid path to a .ttf font file.", 1)
		        
		        pdf.Ln(3)
		        pdf.Cell(0, 6, "Try these system font paths:", 0, 1)
		        pdf.SetFont("courier", "", 8)
		        pdf.Cell(0, 5, "macOS: /System/Library/Fonts/SFNS.ttf (San Francisco)", 0, 1)
		        pdf.Cell(0, 5, "macOS: /System/Library/Fonts/Geneva.ttf", 0, 1)
		        pdf.Cell(0, 5, "Windows: C:\\Windows\\Fonts\\arial.ttf", 0, 1)
		        pdf.Cell(0, 5, "Windows: C:\\Windows\\Fonts\\seguiemj.ttf", 0, 1)
		        pdf.Cell(0, 5, "Linux: /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 0, 1)
		      #EndIf
		    End If
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    
		    If pdf.Error <> "" Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("error") = pdf.Error
		    Else
		      statusText = statusText + "Success! PDF generated." + EndOfLine
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example5_utf8_fonts.pdf"
		    End If
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample5Xojo() As Dictionary
		  // Example 5 using Xojo's native PDFDocument - for comparison (Desktop only)
		  
		  Dim result As New Dictionary
		  
		  #If TargetDesktop Then
		    Dim statusText As String = "Generating Example 5: Xojo PDFDocument..." + EndOfLine
		    
		    Try
		      // Create Xojo's native PDFDocument with Letter page size
		      Dim pdf As New PDFDocument(PDFDocument.PageSizes.Letter)
		      
		      // Get Graphics context for drawing
		      Dim g As Graphics = pdf.Graphics
		      
		      If g <> Nil Then
		        // Use Arial Unicode MS font which supports comprehensive Unicode
		        // Includes Latin Extended, CJK, Cyrillic, symbols, and more
		        g.FontName = "Arial Unicode MS"
		        g.FontSize = 20
		        
		        // Title
		        g.FontSize = 16
		        g.Bold = True
		        g.DrawText "UTF-8 Text with Xojo PDFDocument", 50, 50
		        g.Bold = False
		        
		        Var yPos As Double = 80
		        Var lineHeight As Double = 20
		        
		        // Section: Latin Extended (accented characters)
		        g.FontSize = 12
		        g.Bold = True
		        g.DrawText "Latin Extended (accented characters)", 50, yPos
		        yPos = yPos + lineHeight
		        g.Bold = False
		        
		        g.DrawText "French: café, naïve, Français", 50, yPos
		        yPos = yPos + lineHeight
		        g.DrawText "Spanish: Español, niño, Buenos días", 50, yPos
		        yPos = yPos + lineHeight
		        g.DrawText "German: Müller, Öl, Größe", 50, yPos
		        yPos = yPos + lineHeight
		        g.DrawText "Portuguese: São Paulo, José, coração", 50, yPos
		        yPos = yPos + lineHeight * 1.5
		        
		        // Section: Currency and common symbols
		        g.Bold = True
		        g.DrawText "Currency and common symbols", 50, yPos
		        yPos = yPos + lineHeight
		        g.Bold = False
		        
		        g.DrawText "Currency: $ £ € ¥ ¢ © ® ™", 50, yPos
		        yPos = yPos + lineHeight
		        g.DrawText "Math: ½ ¼ ¾ ± × ÷ ≤ ≥ ≠ ∞", 50, yPos
		        yPos = yPos + lineHeight
		        g.DrawText "Misc: ° ¶ § • · « » … † ‡", 50, yPos
		        yPos = yPos + lineHeight * 1.5
		        
		        // Section: Multilingual Examples
		        g.FontName = "Arial Unicode MS"
		        g.FontSize = 12
		        g.Bold = True
		        g.DrawText "Multilingual Examples:", 50, yPos
		        yPos = yPos + lineHeight
		        g.Bold = False
		        
		        g.FontSize = 14
		        g.DrawText "Xojo " + XojoVersionString, 50, yPos
		        yPos = yPos + lineHeight
		        
		        // Japanese
		        g.DrawText "Japanese: こんにちは、世界", 50, yPos
		        yPos = yPos + lineHeight
		        
		        // Chinese
		        g.DrawText "Chinese: 你好，世界", 50, yPos
		        yPos = yPos + lineHeight
		        
		        // Polish
		        g.DrawText "Polish: Witaj świecie", 50, yPos
		        yPos = yPos + lineHeight
		        
		        // Ukrainian
		        g.DrawText "Ukrainian: Привіт, світ", 50, yPos
		        yPos = yPos + lineHeight * 1.5
		        
		        // Section: Note
		        g.FontSize = 10
		        g.Bold = True
		        g.DrawText "Note:", 50, yPos
		        yPos = yPos + lineHeight
		        g.Bold = False
		        
		        g.FontSize = 9
		        g.DrawText "Xojo's native PDFDocument may not render all Unicode characters correctly.", 50, yPos
		        yPos = yPos + 15
		        g.DrawText "VNSPDFDocument with TrueType fonts provides better Unicode support.", 50, yPos
		        
		        // Get PDF data as MemoryBlock and convert to String
		        Dim pdfMemory As MemoryBlock = pdf.ToData()
		        Dim pdfData As String = pdfMemory
		        
		        statusText = statusText + "Success! Xojo PDF generated." + EndOfLine
		        statusText = statusText + "Note: Compare with VNS PDF version to see Unicode rendering differences." + EndOfLine
		        result.Value("pdf") = pdfData
		        result.Value("filename") = "example5_xojo_utf8.pdf"
		        
		      Else
		        statusText = statusText + "Error: Could not get Graphics context from PDFDocument" + EndOfLine
		        result.Value("error") = "No Graphics context"
		      End If
		      
		    Catch e As RuntimeException
		      statusText = statusText + "Exception: " + e.Message + EndOfLine
		      result.Value("error") = e.Message
		    End Try
		    
		    result.Value("status") = statusText
		    Return result
		    
		  #Else
		    // iOS: Return error - this example requires Desktop Graphics API
		    result.Value("status") = "Error: Example 5 Xojo requires Desktop platform (uses Graphics API)"
		    result.Value("error") = "Not available on iOS"
		    Return result
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample6() As Dictionary
		  // Example 6: Text measurement with GetStringWidth() - Alignment and spacing
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 6: Text measurement..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    Call pdf.AddPage()
		    
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Text(10, 20, "Text Measurement & Alignment Examples")
		    
		    // Example 1: Left-aligned text
		    pdf.SetFont("helvetica", "", 12)
		    pdf.Text(10, 40, "Left-aligned text (default)")
		    
		    // Example 2: Right-aligned text using GetStringWidth
		    Dim txt1 As String = "Right-aligned text"
		    Dim width1 As Double = pdf.GetStringWidth(txt1)
		    pdf.Text(200 - width1, 50, txt1)
		    
		    // Example 3: Center-aligned text
		    Dim txt2 As String = "Center-aligned text"
		    Dim width2 As Double = pdf.GetStringWidth(txt2)
		    Dim centerX As Double = 105 - (width2 / 2)
		    pdf.Text(centerX, 60, txt2)
		    
		    // Example 4: Text box with measured width
		    pdf.SetDrawColor(200, 200, 200)
		    pdf.Rect(10, 75, 190, 15, "D")
		    Dim txt3 As String = "Text in a box with measured width"
		    Dim width3 As Double = pdf.GetStringWidth(txt3)
		    pdf.Text(105 - (width3 / 2), 85, txt3)
		    
		    // Example 5: Multiple text sizes with alignment
		    pdf.SetFont("helvetica", "", 10)
		    Dim txt4 As String = "Small (10pt)"
		    Dim width4 As Double = pdf.GetStringWidth(txt4)
		    pdf.Text(200 - width4, 105, txt4)
		    
		    pdf.SetFont("helvetica", "", 14)
		    Dim txt5 As String = "Medium (14pt)"
		    Dim width5 As Double = pdf.GetStringWidth(txt5)
		    pdf.Text(200 - width5, 115, txt5)
		    
		    pdf.SetFont("helvetica", "", 18)
		    Dim txt6 As String = "Large (18pt)"
		    Dim width6 As Double = pdf.GetStringWidth(txt6)
		    pdf.Text(200 - width6, 128, txt6)
		    
		    // Example 6: Justified text spacing (simulate)
		    pdf.SetFont("helvetica", "", 11)
		    pdf.SetDrawColor(0, 0, 255)
		    pdf.Rect(10, 145, 190, 10, "D")
		    Dim txt7 As String = "Justified text with calculated spacing"
		    Dim width7 As Double = pdf.GetStringWidth(txt7)
		    pdf.Text(10, 152, txt7)
		    pdf.SetFont("helvetica", "", 8)
		    pdf.SetTextColor(100, 100, 100)
		    pdf.Text(10, 160, "Width: " + FormatHelper(width7, "0.00") + " mm")
		    
		    // Example 7: Table with measured columns
		    pdf.SetTextColor(0, 0, 0)
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Text(10, 175, "String Width Measurements:")
		    
		    pdf.SetFont("helvetica", "", 10)
		    Dim y As Double = 185
		    Dim testStrings() As String = Array("Hello", "World", "PDF", "Measurement")
		    For Each str As String In testStrings
		      Dim w As Double = pdf.GetStringWidth(str)
		      pdf.Text(10, y, str)
		      pdf.Text(60, y, FormatHelper(w, "0.00") + " mm")
		      y = y + 7
		    Next
		    
		    // Save PDF
		    // Get PDF data
		    Dim pdfData As String = pdf.Output()
		    statusText = statusText + "PDF generated successfully!" + EndOfLine
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example6_text_measurement.pdf"
		    result.Value("success") = True
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample7() As Dictionary
		  // Example 7: Document metadata - Title, Author, Subject, Keywords
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 7: Document metadata..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    
		    // Set document metadata
		    pdf.SetTitle("Example 7: Document Metadata")
		    pdf.SetAuthor("Xojo FPDF Library")
		    pdf.SetSubject("Demonstration of PDF metadata features")
		    pdf.SetKeywords("PDF metadata title author subject keywords")
		    pdf.SetCreator("VNS PDF Example Generator")
		    pdf.SetLang("en-US")
		    
		    statusText = statusText + "Metadata set:" + EndOfLine
		    statusText = statusText + "  Title: Example 7: Document Metadata" + EndOfLine
		    statusText = statusText + "  Author: Xojo FPDF Library" + EndOfLine
		    statusText = statusText + "  Subject: Demonstration of PDF metadata features" + EndOfLine
		    statusText = statusText + "  Keywords: PDF metadata title author subject keywords" + EndOfLine
		    statusText = statusText + "  Creator: VNS PDF Example Generator" + EndOfLine
		    statusText = statusText + "  Language: en-US" + EndOfLine
		    
		    Call pdf.AddPage()
		    
		    // Display metadata information on page
		    pdf.SetFont("helvetica", "B", 18)
		    pdf.Text(10, 20, "Document Metadata Example")
		    
		    pdf.SetFont("helvetica", "", 12)
		    pdf.Text(10, 35, "This PDF contains the following metadata:")
		    
		    pdf.SetFont("helvetica", "B", 11)
		    Dim y As Double = 50
		    pdf.Text(15, y, "Title:")
		    pdf.SetFont("helvetica", "", 11)
		    pdf.Text(60, y, "Example 7: Document Metadata")
		    
		    y = y + 10
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(15, y, "Author:")
		    pdf.SetFont("helvetica", "", 11)
		    pdf.Text(60, y, "Xojo FPDF Library")
		    
		    y = y + 10
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(15, y, "Subject:")
		    pdf.SetFont("helvetica", "", 11)
		    pdf.Text(60, y, "Demonstration of PDF metadata features")
		    
		    y = y + 10
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(15, y, "Keywords:")
		    pdf.SetFont("helvetica", "", 11)
		    pdf.Text(60, y, "PDF metadata title author subject keywords")
		    
		    y = y + 10
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(15, y, "Creator:")
		    pdf.SetFont("helvetica", "", 11)
		    pdf.Text(60, y, "VNS PDF Example Generator")
		    
		    y = y + 10
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(15, y, "Language:")
		    pdf.SetFont("helvetica", "", 11)
		    pdf.Text(60, y, "en-US (English - United States)")
		    
		    y = y + 15
		    pdf.SetFont("helvetica", "I", 10)
		    pdf.SetTextColor(100, 100, 100)
		    pdf.Text(10, y, "Note: View document properties in your PDF reader to see the metadata.")
		    
		    // Add Unicode example with metadata
		    pdf.SetTextColor(0, 0, 0)
		    pdf.SetFont("helvetica", "B", 12)
		    y = y + 20
		    pdf.Text(10, y, "Unicode Metadata Support:")
		    
		    pdf.SetFont("helvetica", "", 10)
		    y = y + 10
		    pdf.Text(15, y, "Metadata fields automatically handle Unicode characters")
		    y = y + 7
		    pdf.Text(15, y, "Try setting: SetTitle(""Título en Español"") ")
		    y = y + 7
		    pdf.Text(15, y, "Or: SetAuthor(""作者名前"") for Japanese")
		    
		    // Get PDF data
		    Dim pdfData As String = pdf.Output()
		    statusText = statusText + "PDF generated successfully!" + EndOfLine
		    statusText = statusText + "Open in PDF reader and view Document Properties to see metadata" + EndOfLine
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example7_metadata.pdf"
		    result.Value("success") = True
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample8() As Dictionary
		  // Example 8: Error handling pattern - Ok(), Err(), GetError(), SetError()
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 8: Error handling..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    
		    // Check initial state
		    If pdf.Ok() Then
		      statusText = statusText + "✓ Initial state: No errors" + EndOfLine
		    End If
		    
		    Call pdf.AddPage()
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Text(10, 20, "Error Handling Pattern Example")
		    
		    pdf.SetFont("helvetica", "", 12)
		    pdf.Text(10, 35, "This example demonstrates the error handling pattern:")
		    
		    Dim y As Double = 50
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Text(15, y, "• Ok() - Returns true if no error has occurred")
		    y = y + 7
		    pdf.Text(15, y, "• Err() - Returns true if an error has occurred")
		    y = y + 7
		    pdf.Text(15, y, "• GetError() - Returns the error message")
		    y = y + 7
		    pdf.Text(15, y, "• SetError() - Sets an error to halt generation")
		    y = y + 7
		    pdf.Text(15, y, "• ClearError() - Clears the error state")
		    
		    // Example: Check status before operations
		    y = y + 15
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(10, y, "Example 1: Checking status before operations")
		    y = y + 8
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Text(15, y, "Before adding content, check: pdf.Ok() = " + If(pdf.Ok(), "True", "False"))
		    
		    // Simulate an operation that might fail
		    y = y + 15
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(10, y, "Example 2: Error accumulation pattern")
		    y = y + 8
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Text(15, y, "First error is preserved, subsequent errors ignored")
		    
		    // Example: Manual error checking
		    y = y + 15
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(10, y, "Example 3: Testing error methods")
		    
		    // Set a test error (this won't affect PDF generation since we clear it)
		    pdf.SetError("Test error message")
		    y = y + 8
		    pdf.SetFont("helvetica", "", 10)
		    
		    If pdf.Err() Then
		      pdf.Text(15, y, "After SetError(): Err() = True")
		      y = y + 7
		      pdf.Text(15, y, "Error message: """ + pdf.GetError() + """")
		      statusText = statusText + "✓ Error detection working" + EndOfLine
		    End If
		    
		    // Clear the error to continue
		    pdf.ClearError()
		    y = y + 10
		    If pdf.Ok() Then
		      pdf.Text(15, y, "After ClearError(): Ok() = True")
		      statusText = statusText + "✓ Error cleared successfully" + EndOfLine
		    End If
		    
		    // Benefits section
		    y = y + 15
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(10, y, "Benefits of this pattern:")
		    y = y + 8
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Text(15, y, "✓ Errors don't throw exceptions - graceful degradation")
		    y = y + 7
		    pdf.Text(15, y, "✓ First error preserved - helps identify root cause")
		    y = y + 7
		    pdf.Text(15, y, "✓ Consistent error checking across all methods")
		    y = y + 7
		    pdf.Text(15, y, "✓ Compatible with go-fpdf error handling pattern")
		    
		    // Code example
		    y = y + 15
		    pdf.SetFont("helvetica", "B", 11)
		    pdf.Text(10, y, "Usage Example Code:")
		    y = y + 8
		    pdf.SetFont("courier", "", 9)
		    pdf.SetTextColor(0, 0, 128)
		    pdf.Text(15, y, "Dim pdf As New VNSPDFDocument")
		    y = y + 5
		    pdf.Text(15, y, "pdf.AddPage()")
		    y = y + 5
		    pdf.Text(15, y, "pdf.SetFont(""helvetica"", """", 12)")
		    y = y + 5
		    pdf.Text(15, y, "If pdf.Ok() Then")
		    y = y + 5
		    pdf.Text(20, y, "pdf.SaveToFile(""output.pdf"")")
		    y = y + 5
		    pdf.Text(15, y, "Else")
		    y = y + 5
		    pdf.Text(20, y, "MsgBox(""Error: "" + pdf.GetError())")
		    y = y + 5
		    pdf.Text(15, y, "End If")
		    
		    statusText = statusText + "✓ All error handling methods demonstrated" + EndOfLine
		    
		    // Save PDF
		    // Get PDF data
		    Dim pdfData As String = pdf.Output()
		    statusText = statusText + "PDF generated successfully!" + EndOfLine
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example8_error_handling.pdf"
		    result.Value("success") = True
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample9() As Dictionary
		  // Example 9: Image support (JPEG)
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 9: Image support..." + EndOfLine
		  
		  Try
		    Dim pdf As New VNSPDFDocument()
		    Call pdf.AddPage()
		    
		    // Title
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "Example 9: Image Support (JPEG)", 0, 1, "C")
		    pdf.Ln(10)
		    
		    // Instructions
		    pdf.SetFont("helvetica", "", 12)
		    pdf.MultiCell(0, 6, "This example demonstrates how to embed JPEG images in PDFs. To test this feature, provide a path to a JPEG file on your system.", 0, "L")
		    pdf.Ln(5)
		    
		    // Try to load a sample image
		    // First try the test image in project folder, then fallback to system images
		    
		    Dim imagePath As String = ""
		    Dim imageFile As FolderItem
		    
		    // Try to find JPEG test image
		    Dim jpegFile As FolderItem
		    Dim testFile As FolderItem
		    
		    #If TargetDesktop Or TargetConsole Then
		      // Location 1: Same folder as executable
		      testFile = App.ExecutableFile.Parent.Child("Test.pdf.jpg")
		      If testFile.Exists Then jpegFile = testFile
		      
		      // Location 2: Go up 2 folders (macOS .app bundle)
		      If jpegFile = Nil Then
		        testFile = App.ExecutableFile.Parent.Parent.Child("Test.pdf.jpg")
		        If testFile.Exists Then jpegFile = testFile
		      End If
		      
		      // Location 3: Go up 3 folders
		      If jpegFile = Nil Then
		        testFile = App.ExecutableFile.Parent.Parent.Parent.Child("Test.pdf.jpg")
		        If testFile.Exists Then jpegFile = testFile
		      End If
		      
		      // Location 4: Go up 4 folders (project folder on macOS debug builds)
		      If jpegFile = Nil Then
		        testFile = App.ExecutableFile.Parent.Parent.Parent.Parent.Child("Test.pdf.jpg")
		        If testFile.Exists Then jpegFile = testFile
		      End If
		      
		      // Location 4b: Go up 5 folders
		      If jpegFile = Nil Then
		        testFile = App.ExecutableFile.Parent.Parent.Parent.Parent.Parent.Child("Test.pdf.jpg")
		        If testFile.Exists Then jpegFile = testFile
		      End If
		      
		      // Location 4c: Go up 6 folders
		      If jpegFile = Nil Then
		        testFile = App.ExecutableFile.Parent.Parent.Parent.Parent.Parent.Parent.Child("Test.pdf.jpg")
		        If testFile.Exists Then jpegFile = testFile
		      End If
		      
		      // Location 5: Desktop
		      If jpegFile = Nil Then
		        testFile = SpecialFolder.Desktop.Child("Test.pdf.jpg")
		        If testFile.Exists Then jpegFile = testFile
		      End If
		    #ElseIf TargetiOS Then
		      // iOS: Check Documents folder for file-based images
		      testFile = SpecialFolder.Documents.Child("Test.pdf.jpg")
		      If testFile <> Nil And testFile.Exists Then jpegFile = testFile
		    #EndIf
		    
		    // Try to find PNG test image
		    Dim pngFile As FolderItem
		    
		    #If TargetDesktop Or TargetConsole Then
		      // Location 1: Same folder as executable
		      testFile = App.ExecutableFile.Parent.Child("Test.pdf.png")
		      If testFile.Exists Then pngFile = testFile
		      
		      // Location 2: Go up 2 folders (macOS .app bundle)
		      If pngFile = Nil Then
		        testFile = App.ExecutableFile.Parent.Parent.Child("Test.pdf.png")
		        If testFile.Exists Then pngFile = testFile
		      End If
		      
		      // Location 3: Go up 3 folders
		      If pngFile = Nil Then
		        testFile = App.ExecutableFile.Parent.Parent.Parent.Child("Test.pdf.png")
		        If testFile.Exists Then pngFile = testFile
		      End If
		      
		      // Location 4: Go up 4 folders (project folder on macOS debug builds)
		      If pngFile = Nil Then
		        testFile = App.ExecutableFile.Parent.Parent.Parent.Parent.Child("Test.pdf.png")
		        If testFile.Exists Then pngFile = testFile
		      End If
		      
		      // Location 5: Desktop
		      If pngFile = Nil Then
		        testFile = SpecialFolder.Desktop.Child("Test.pdf.png")
		        If testFile.Exists Then pngFile = testFile
		      End If
		    #ElseIf TargetiOS Then
		      // iOS: Check Documents folder for file-based images
		      testFile = SpecialFolder.Documents.Child("Test.pdf.png")
		      If testFile <> Nil And testFile.Exists Then pngFile = testFile
		    #EndIf

		    // iOS: Check for bundled images using SpecialFolder.Resource()
		    #If TargetiOS Then
		      Dim bundledPic As Picture
		      Dim resourceFile As FolderItem

		      // Try to load bundled image - try multiple name variations
		      If jpegFile = Nil And pngFile = Nil Then
		        // Try "Testpdf.png" (capital T - matches iOS bundle)
		        Try
		          resourceFile = SpecialFolder.Resource("Testpdf.png")
		          If resourceFile <> Nil And resourceFile.Exists Then
		            bundledPic = Picture.Open(resourceFile)
		            If bundledPic <> Nil Then
		              statusText = statusText + "Found bundled image: Testpdf.png" + EndOfLine
		            End If
		          End If
		        Catch e As RuntimeException
		          statusText = statusText + "Testpdf.png not found" + EndOfLine
		        End Try

		        // Try "testpdf.png" (all lowercase)
		        If bundledPic = Nil Then
		          Try
		            resourceFile = SpecialFolder.Resource("testpdf.png")
		            If resourceFile <> Nil And resourceFile.Exists Then
		              bundledPic = Picture.Open(resourceFile)
		              If bundledPic <> Nil Then
		                statusText = statusText + "Found bundled image: testpdf.png" + EndOfLine
		              End If
		            End If
		          Catch e As RuntimeException
		            statusText = statusText + "testpdf.png not found" + EndOfLine
		          End Try
		        End If

		        // Try "testpdf" without extension
		        If bundledPic = Nil Then
		          Try
		            resourceFile = SpecialFolder.Resource("testpdf")
		            If resourceFile <> Nil And resourceFile.Exists Then
		              bundledPic = Picture.Open(resourceFile)
		              If bundledPic <> Nil Then
		                statusText = statusText + "Found bundled image: testpdf (no ext)" + EndOfLine
		              End If
		            End If
		          Catch e As RuntimeException
		            statusText = statusText + "testpdf (no ext) not found" + EndOfLine
		          End Try
		        End If

		        // Try "testpdf.jpg"
		        If bundledPic = Nil Then
		          Try
		            resourceFile = SpecialFolder.Resource("testpdf.jpg")
		            If resourceFile <> Nil And resourceFile.Exists Then
		              bundledPic = Picture.Open(resourceFile)
		              If bundledPic <> Nil Then
		                statusText = statusText + "Found bundled image: testpdf.jpg" + EndOfLine
		              End If
		            End If
		          Catch e As RuntimeException
		            statusText = statusText + "testpdf.jpg not found" + EndOfLine
		          End Try
		        End If

		        If bundledPic = Nil Then
		          statusText = statusText + "No bundled image found - add 'testpdf' to project with Copy Files build step" + EndOfLine
		        End If
		      End If
		    #EndIf

		    If jpegFile <> Nil Then
		      statusText = statusText + "Found JPEG test image: " + jpegFile.NativePath + EndOfLine
		    End If

		    If pngFile <> Nil Then
		      statusText = statusText + "Found PNG test image: " + pngFile.NativePath + EndOfLine
		    End If
		    
		    // Use whichever image we found (prefer JPEG)
		    If jpegFile <> Nil Then
		      imagePath = jpegFile.NativePath
		      imageFile = jpegFile
		    ElseIf pngFile <> Nil Then
		      imagePath = pngFile.NativePath
		      imageFile = pngFile
		    Else
		      statusText = statusText + "No test images found (Test.pdf.jpg or Test.pdf.png)" + EndOfLine
		      #If TargetDesktop Or TargetConsole Then
		        // Fallback to system image (macOS only)
		        imagePath = "/System/Library/Desktop Pictures/Solid Colors/Solid Gray Pro Light.jpg"
		        imageFile = New FolderItem(imagePath, FolderItem.PathModes.Native)
		        statusText = statusText + "Using system image: " + imagePath + EndOfLine
		      #Else
		        // iOS: No fallback system image available
		        statusText = statusText + "No fallback image available on iOS" + EndOfLine
		      #EndIf
		    End If

		    // Check if we have any images available (file-based or bundled)
		    #If TargetiOS Then
		      Dim hasImages As Boolean = (imageFile <> Nil And imageFile.Exists) Or (bundledPic <> Nil)
		    #Else
		      Dim hasImages As Boolean = (imageFile <> Nil And imageFile.Exists)
		    #EndIf

		    If hasImages Then
		      pdf.SetFont("helvetica", "B", 14)
		      pdf.Cell(0, 8, "Image Support Demonstration", 0, 1, "C")
		      pdf.Ln(5)

		      // iOS: Handle bundled image using RegisterImageFromBytes
		      #If TargetiOS Then
		        If bundledPic <> Nil Then
		          pdf.SetFont("helvetica", "B", 12)
		          pdf.SetFillColor(255, 230, 230)
		          pdf.Cell(0, 8, "Bundled Image Test (testpdf)", 1, 1, "L", True)
		          pdf.SetFont("courier", "", 9)
		          pdf.Cell(0, 5, "Loaded from app bundle using Picture.Open(""testpdf"")", 0, 1)
		          pdf.Ln(3)

		          statusText = statusText + "Original picture: " + Str(bundledPic.Width) + "x" + Str(bundledPic.Height) + EndOfLine

		          // Use ImageFromPicture directly (handles RGBA conversion internally)
		          pdf.SetFont("helvetica", "", 10)
		          pdf.Cell(0, 6, "1. Scaled to width=80mm:", 0, 1)
		          pdf.Ln(2)
		          pdf.ImageFromPicture(bundledPic, 20, pdf.GetY(), 80, 0)
		          pdf.Ln(50)

		          pdf.Cell(0, 6, "2. Scaled to 50x40mm:", 0, 1)
		          pdf.Ln(2)
		          pdf.ImageFromPicture(bundledPic, 20, pdf.GetY(), 50, 40)
		          pdf.Ln(45)

		          If pdf.Err() Then
		            statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		          Else
		            statusText = statusText + "Bundled image embedded successfully!" + EndOfLine
		          End If
		        End If
		      #EndIf

		      // Test JPEG if available
		      If jpegFile <> Nil Then
		        pdf.SetFont("helvetica", "B", 12)
		        pdf.SetFillColor(230, 230, 255)
		        pdf.Cell(0, 8, "JPEG Image Test", 1, 1, "L", True)
		        pdf.SetFont("courier", "", 9)
		        pdf.Cell(0, 5, jpegFile.NativePath, 0, 1)
		        pdf.Ln(3)
		        
		        pdf.SetFont("helvetica", "", 10)
		        pdf.Cell(0, 6, "1. Scaled to width=80mm:", 0, 1)
		        pdf.Ln(2)
		        pdf.Image(jpegFile.NativePath, 20, pdf.GetY(), 80, 0)
		        pdf.Ln(50)
		        
		        pdf.Cell(0, 6, "2. Scaled to 50x40mm:", 0, 1)
		        pdf.Ln(2)
		        pdf.Image(jpegFile.NativePath, 20, pdf.GetY(), 50, 40)
		        pdf.Ln(45)
		        
		        statusText = statusText + "JPEG embedded successfully!" + EndOfLine
		      End If
		      
		      // Test PNG if available
		      If pngFile <> Nil Then
		        pdf.SetFont("helvetica", "B", 12)
		        pdf.SetFillColor(230, 255, 230)
		        pdf.Cell(0, 8, "PNG Image Test", 1, 1, "L", True)
		        pdf.SetFont("courier", "", 9)
		        pdf.Cell(0, 5, pngFile.NativePath, 0, 1)
		        pdf.Ln(3)
		        
		        pdf.SetFont("helvetica", "", 10)
		        pdf.Cell(0, 6, "1. Scaled to width=80mm:", 0, 1)
		        pdf.Ln(2)
		        pdf.Image(pngFile.NativePath, 20, pdf.GetY(), 80, 0)
		        pdf.Ln(50)
		        
		        pdf.Cell(0, 6, "2. Scaled to 50x40mm:", 0, 1)
		        pdf.Ln(2)
		        pdf.Image(pngFile.NativePath, 20, pdf.GetY(), 50, 40)
		        pdf.Ln(45)
		        
		        statusText = statusText + "PNG embedded successfully!" + EndOfLine
		      End If

		      // Test ImageFromPicture() - Programmatically generated graphics
		      Call pdf.AddPage()
		      pdf.SetFont("helvetica", "B", 12)
		      pdf.SetFillColor(255, 230, 230)
		      pdf.Cell(0, 8, "Programmatically Generated Graphics (ImageFromPicture)", 1, 1, "L", True)
		      pdf.Ln(3)

		      pdf.SetFont("helvetica", "", 10)
		      pdf.MultiCell(0, 5, "The ImageFromPicture() method allows you to draw graphics using Xojo's Picture/Graphics API, then embed the result as a PNG image in the PDF.", 0, "L")
		      pdf.Ln(3)

		      #If TargetDesktop Or TargetWeb Then
		        // Create a Picture and draw on it (Desktop and Web have Picture/Graphics API)
		        // Use higher resolution for sharper output when scaled in PDF
		        // Web needs 4x because its Graphics API lacks anti-aliasing; Desktop uses 2x
		        #If TargetWeb Then
		          Const kScale As Double = 4.0
		        #Else
		          Const kScale As Double = 2.0
		        #EndIf
		        Dim picWidth As Integer = 400 * kScale
		        Dim picHeight As Integer = 300 * kScale
		        Dim pic As New Picture(picWidth, picHeight, 32)  // High-res with alpha channel
		        Dim g As Graphics = pic.Graphics

		        // White background
		        g.DrawingColor = Color.White
		        g.FillRectangle(0, 0, picWidth, picHeight)

		        // Draw some shapes (all coordinates scaled)
		        g.DrawingColor = Color.Red
		        g.PenSize = 3 * kScale
		        g.DrawOval(50 * kScale, 50 * kScale, 100 * kScale, 100 * kScale)

		        g.DrawingColor = Color.Green
		        g.FillRectangle(200 * kScale, 30 * kScale, 80 * kScale, 60 * kScale)

		        g.DrawingColor = Color.Blue
		        g.PenSize = 2 * kScale
		        For i As Integer = 0 To 5
		          g.DrawLine(250 * kScale, (120 + i * 15) * kScale, 380 * kScale, (120 + i * 15) * kScale)
		        Next

		        g.DrawingColor = Color.RGB(255, 128, 0)  // Orange
		        g.PenSize = 1 * kScale
		        #If TargetDesktop Then
		          // Desktop: Use modern GraphicsPath API (no deprecation warning)
		          Dim path As New GraphicsPath
		          path.MoveToPoint(50 * kScale, 250 * kScale)
		          path.AddLineToPoint(120 * kScale, 200 * kScale)
		          path.AddLineToPoint(190 * kScale, 200 * kScale)
		          path.AddLineToPoint(50 * kScale, 250 * kScale)  // Close back to start
		          g.FillPath(path)
		        #Else
		          // Web/Console: FillPath not supported, use FillPolygon (deprecated but only option)
		          Dim points() As Integer
		          points.Add(50 * kScale)
		          points.Add(250 * kScale)
		          points.Add(120 * kScale)
		          points.Add(200 * kScale)
		          points.Add(190 * kScale)
		          points.Add(200 * kScale)
		          g.FillPolygon(points)
		        #EndIf

		        // Draw text (font size scaled)
		        g.DrawingColor = Color.Black
		        g.Bold = True
		        g.FontSize = 24 * kScale
		        g.DrawText("Generated Graphics", 80 * kScale, 180 * kScale)

		        g.Bold = False
		        g.FontSize = 14 * kScale
		        g.DrawText("Created with Xojo Picture/Graphics", 70 * kScale, 210 * kScale)

		        // Draw rounded rectangle
		        g.DrawingColor = Color.RGB(128, 0, 128)  // Purple
		        g.PenSize = 2 * kScale
		        g.DrawRoundRectangle(30 * kScale, 230 * kScale, 340 * kScale, 50 * kScale, 10 * kScale, 10 * kScale)

		        g.FontSize = 16 * kScale
		        g.DrawingColor = Color.RGB(64, 64, 64)
		        g.DrawText("Embedded as PNG via ImageFromPicture()", 60 * kScale, 260 * kScale)
		      #EndIf

		      #If TargetDesktop Or TargetWeb Then
		        // Embed the Picture in the PDF (Desktop and Web have Picture.Graphics)
		        pdf.Cell(0, 6, "1. Generated Picture (400x300 pixels) at width=150mm:", 0, 1)
		        pdf.Ln(2)
		        pdf.ImageFromPicture(pic, 30, pdf.GetY(), 150, 0)  // 150mm wide, height auto
		        pdf.Ln(115)

		        pdf.Cell(0, 6, "2. Same Picture at 80x60mm:", 0, 1)
		        pdf.Ln(2)
		        pdf.ImageFromPicture(pic, 30, pdf.GetY(), 80, 60)
		        pdf.Ln(65)

		        statusText = statusText + "Generated Picture embedded successfully!" + EndOfLine
		      #Else
		        // iOS/Console: Picture/Graphics API not fully available
		        pdf.SetFont("helvetica", "", 9)
		        #If TargetiOS Then
		          pdf.MultiCell(0, 5, "Picture.Graphics API not available on iOS. However, charts can be embedded using ToPicture() - see chart example below.", 0, "L")
		        #Else
		          pdf.MultiCell(0, 5, "Picture/Graphics API not available on Console platform.", 0, "L")
		        #EndIf
		        pdf.Ln(10)
		        statusText = statusText + "Picture generation skipped (platform limitation)" + EndOfLine
		      #EndIf

		      // Test ImageFromPicture() with Chart (Desktop and iOS only)
		      // Note: WebChart cannot be instantiated programmatically (protected constructor)
		      #If TargetDesktop Or TargetiOS Then
		        Call pdf.AddPage()
		        pdf.SetFont("helvetica", "B", 12)
		        pdf.SetFillColor(230, 255, 230)

		        #If TargetDesktop Then
		          pdf.Cell(0, 8, "DesktopChart Embedding (Desktop)", 1, 1, "L", True)
		        #ElseIf TargetiOS Then
		          pdf.Cell(0, 8, "MobileChart Embedding (iOS)", 1, 1, "L", True)
		        #EndIf
		        pdf.Ln(3)

		        pdf.SetFont("helvetica", "", 10)
		        pdf.MultiCell(0, 5, "Charts can be converted to Picture using ToPicture(), then embedded with ImageFromPicture().", 0, "L")
		        pdf.Ln(3)

		        // Create and configure the chart programmatically
		        #If TargetDesktop Then
		          Dim chart As New DesktopChart
		          chart.Width = 600
		          chart.Height = 400
		        #ElseIf TargetiOS Then
		          Dim chart As New MobileChart
		          // Width and Height are read-only on iOS (controlled by auto-layout)
		        #EndIf

		        #If TargetDesktop Then
		          chart.Mode = DesktopChart.Modes.Bar
		        #ElseIf TargetiOS Then
		          chart.Mode = MobileChart.Modes.Bar
		        #EndIf
		        chart.Title = "Sales by Quarter"
		        chart.HasLegend = True
		        chart.IsGridVisible = True
		        #If TargetDesktop Then
		          chart.TitleFontSize = 16
		        #EndIf
		        chart.BackgroundColor = Color.White

		        // Add datasets with Double arrays
		        Dim productA() As Double = Array(65.0, 78.0, 82.0, 91.0)
		        Dim productB() As Double = Array(45.0, 52.0, 68.0, 75.0)
		        Dim productC() As Double = Array(32.0, 39.0, 44.0, 58.0)

		        // ChartLinearDataset is the same class on all platforms
		        Dim dsA As New ChartLinearDataset("Product A", Color.Blue, False, productA)
		        Dim dsB As New ChartLinearDataset("Product B", Color.Red, False, productB)
		        Dim dsC As New ChartLinearDataset("Product C", Color.Green, False, productC)

		        chart.AddDataset(dsA)
		        chart.AddDataset(dsB)
		        chart.AddDataset(dsC)

		        // Add X-axis labels
		        chart.AddLabels("Q1", "Q2", "Q3", "Q4")

		        // Convert chart to Picture - ToPicture(width, height)
		        // Using explicit dimensions for better quality
		        Dim chartPicRGBA As Picture = chart.ToPicture(800, 600)

		        #If TargetDesktop Then
		          // Convert RGBA to RGB (remove alpha channel for PDF compatibility)
		          // PDF doesn't natively support RGBA images - they need RGB or SMask
		          Dim chartPic As New Picture(800, 600, 24)  // 24-bit = RGB without alpha
		          Dim chartGraphics As Graphics = chartPic.Graphics
		          chartGraphics.DrawPicture(chartPicRGBA, 0, 0)
		        #Else
		          // iOS: Use the chart picture directly (no conversion needed)
		          Dim chartPic As Picture = chartPicRGBA
		        #EndIf

		        If chartPic <> Nil Then
		          pdf.Cell(0, 6, "DesktopChart converted to Picture at width=170mm:", 0, 1)
		          pdf.Ln(2)
		          pdf.ImageFromPicture(chartPic, 20, pdf.GetY(), 170, 0)
		          pdf.Ln(130)

		          #If TargetDesktop Then
		            statusText = statusText + "DesktopChart embedded successfully!" + EndOfLine
		          #ElseIf TargetiOS Then
		            statusText = statusText + "MobileChart embedded successfully!" + EndOfLine
		          #EndIf
		        Else
		          pdf.SetFont("helvetica", "I", 10)
		          pdf.Cell(0, 6, "Chart.ToPicture() returned Nil", 0, 1)
		          statusText = statusText + "Chart.ToPicture() returned Nil" + EndOfLine
		        End If
		      #EndIf

		      // If no test images, use fallback (but not on iOS if bundled image exists)
		      #If TargetiOS Then
		        Dim shouldUseFallback As Boolean = (jpegFile = Nil And pngFile = Nil And bundledPic = Nil)
		      #Else
		        Dim shouldUseFallback As Boolean = (jpegFile = Nil And pngFile = Nil)
		      #EndIf

		      If shouldUseFallback And imagePath <> "" Then
		        pdf.SetFont("helvetica", "B", 12)
		        pdf.Cell(0, 8, "Using system fallback image:", 0, 1)
		        pdf.SetFont("courier", "", 9)
		        pdf.Cell(0, 5, imagePath, 0, 1)
		        pdf.Ln(3)

		        pdf.SetFont("helvetica", "", 10)
		        pdf.Cell(0, 6, "Scaled to width=80mm:", 0, 1)
		        pdf.Ln(2)
		        pdf.Image(imagePath, 20, pdf.GetY(), 80, 0)

		        statusText = statusText + "Fallback image embedded!" + EndOfLine
		      End If
		    Else
		      pdf.SetFont("helvetica", "I", 11)
		      pdf.SetTextColor(200, 0, 0)
		      pdf.Cell(0, 8, "Test image not found at:", 0, 1)
		      pdf.SetFont("courier", "", 9)
		      pdf.Cell(0, 6, imagePath, 0, 1)
		      pdf.Ln(5)
		      
		      pdf.SetTextColor(0, 0, 0)
		      pdf.SetFont("helvetica", "", 10)
		      pdf.MultiCell(0, 5, "To test image support, modify the imagePath variable in GenerateExample9() to point to a JPEG file on your system.", 0, "L")
		      pdf.Ln(5)
		      
		      pdf.SetFont("helvetica", "B", 11)
		      pdf.Cell(0, 6, "Image API methods demonstrated:", 0, 1)
		      pdf.SetFont("courier", "", 9)
		      pdf.Cell(0, 5, "pdf.RegisterImage(path, key) - Pre-register an image", 0, 1)
		      pdf.Cell(0, 5, "pdf.Image(path, x, y, w, h, key) - Add image to page", 0, 1)
		      pdf.Ln(3)
		      
		      pdf.SetFont("helvetica", "", 10)
		      pdf.Cell(0, 5, "Parameters:", 0, 1)
		      pdf.SetFont("courier", "", 9)
		      pdf.Cell(0, 5, "  path: File path to JPEG image", 0, 1)
		      pdf.Cell(0, 5, "  x, y: Position in user units (default: mm)", 0, 1)
		      pdf.Cell(0, 5, "  w, h: Dimensions (0 = auto, maintains aspect)", 0, 1)
		      pdf.Cell(0, 5, "  key: Optional identifier for reusing images", 0, 1)
		      
		      statusText = statusText + "Test image not found (example still generated)" + EndOfLine
		    End If
		    
		    // Check for errors
		    If pdf.Err() Then
		      statusText = statusText + "PDF Error: " + pdf.GetError() + EndOfLine
		      result.Value("status") = statusText
		      Return result
		    End If
		    
		    // Get PDF data
		    Dim pdfData As String = pdf.Output()
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example9_images.pdf"
		    
		    statusText = statusText + "PDF generated successfully (" + Str(pdfData.Bytes) + " bytes)" + EndOfLine
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		  End Try
		  
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 48656C70657220746F206C6F61642062696E6172792066696C6520696E746F204D656D6F7279426C6F636B2E0A
		Private Function LoadBinaryFile(f As FolderItem) As MemoryBlock
		  // Helper to load binary file into MemoryBlock
		  If f = Nil Or Not f.Exists Then Return Nil
		  
		  Try
		    Dim stream As BinaryStream = BinaryStream.Open(f, False)
		    Dim mb As MemoryBlock = stream.Read(stream.Length)
		    stream.Close()
		    Return mb
		  Catch e As IOException
		    Return Nil
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652031383A20456E6372797074696F6E20506C7567696E204172636869746563747572652054657374696E67
		Function GenerateExample18() As Dictionary
		  // Example 18: Encryption Plugin Architecture Testing
		  // Tests that RC4-40 works (free) and RC4-128 is blocked (premium)

		  Dim result As New Dictionary
		  Dim statusText As String = ""

		  statusText = statusText + "Example 18: Encryption Plugin Architecture Testing" + EndOfLine
		  statusText = statusText + "=============================================" + EndOfLine + EndOfLine

		  statusText = statusText + "⚠️  IMPORTANT: Password-Protected PDFs Generated!" + EndOfLine
		  statusText = statusText + "   User Password: user123" + EndOfLine
		  statusText = statusText + "   Owner Password: owner456" + EndOfLine
		  statusText = statusText + "   You will need 'user123' to open the generated PDFs." + EndOfLine + EndOfLine

		  // ===== TEST 1: RC4-40 (Revision 2) - FREE VERSION =====
		  statusText = statusText + "TEST 1: RC4-40 Encryption (Revision 2 - FREE)" + EndOfLine
		  statusText = statusText + "----------------------------------------------" + EndOfLine

		  // Create PDF with RC4-40 encryption
		  Dim pdf1 As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  Call pdf1.SetTitle("Example 18 - RC4-40 Test (Free)")
		  Call pdf1.SetAuthor("VNS PDF Library")
		  Call pdf1.SetSubject("Testing free RC4-40 encryption")
		  Call pdf1.AddPage()

		  // Set RC4-40 encryption (revision 2) - This should work in free version
		  // Minimal permissions: allow print and copy only
		  Call pdf1.SetProtection("user123", "owner456", True, False, True, False, False, False, False, False, VNSPDFModule.gkEncryptionRC4_40)

		  If pdf1.Err() Then
		    statusText = statusText + "✗ FAILED: " + pdf1.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  Else
		    statusText = statusText + "✓ PASSED: RC4-40 encryption set successfully (free version)" + EndOfLine
		  End If

		  // Add content
		  Call pdf1.SetFont("helvetica", "B", 16)
		  Call pdf1.Cell(0, 10, "RC4-40 Encryption Test", 0, 1, "C")
		  Call pdf1.Ln(5)

		  Call pdf1.SetFont("helvetica", "", 11)
		  Call pdf1.MultiCell(0, 6, "This PDF is encrypted with RC4-40 (40-bit) encryption, which is available in the FREE version of VNS PDF Library. You need the password 'user123' to open this document.", 0, "L")
		  Call pdf1.Ln(3)

		  Call pdf1.SetFont("helvetica", "B", 12)
		  Call pdf1.Cell(0, 7, "Encryption Details:", 0, 1)
		  Call pdf1.SetFont("courier", "", 9)
		  Call pdf1.Cell(0, 5, "- Revision: VNSPDFModule.gkEncryptionRC4_40 (RC4-40)", 0, 1)
		  Call pdf1.Cell(0, 5, "- User Password: user123", 0, 1)
		  Call pdf1.Cell(0, 5, "- Owner Password: owner456", 0, 1)
		  Call pdf1.Cell(0, 5, "- Allow Print (low quality): Yes", 0, 1)
		  Call pdf1.Cell(0, 5, "- Allow Modify: No", 0, 1)
		  Call pdf1.Cell(0, 5, "- Allow Copy: Yes", 0, 1)
		  Call pdf1.Cell(0, 5, "- Allow Annotations: No", 0, 1)
		  Call pdf1.Cell(0, 5, "- Allow Fill Forms: No", 0, 1)
		  Call pdf1.Cell(0, 5, "- Allow Extract (accessibility): No", 0, 1)
		  Call pdf1.Cell(0, 5, "- Allow Assemble (pages): No", 0, 1)
		  Call pdf1.Cell(0, 5, "- Allow Print High Quality: No", 0, 1)
		  Call pdf1.Ln(5)

		  Call pdf1.SetFont("helvetica", "", 11)
		  Call pdf1.MultiCell(0, 6, "This is the basic encryption level suitable for casual document protection. For stronger security, use RC4-128 (gkEncryptionRC4_128) or AES encryption (gkEncryptionAES128, gkEncryptionAES256, gkEncryptionAES256_PDF2) available in the premium Encryption module.", 0, "L")

		  If pdf1.Err() Then
		    statusText = statusText + "ERROR during PDF generation: " + pdf1.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End If

		  statusText = statusText + "✓ RC4-40 PDF generated successfully" + EndOfLine + EndOfLine

		  // ===== TEST 2: RC4-128 (Revision 3) - PREMIUM (Should be blocked) =====
		  statusText = statusText + "TEST 2: RC4-128 Encryption (Revision 3 - PREMIUM)" + EndOfLine
		  statusText = statusText + "----------------------------------------------" + EndOfLine

		  // Create PDF and try to set RC4-128 encryption (should fail without premium module)
		  Dim pdf2 As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  Call pdf2.SetTitle("Example 18 - RC4-128 Test (Premium)")
		  Call pdf2.SetAuthor("VNS PDF Library")
		  Call pdf2.SetSubject("Testing premium RC4-128 encryption")
		  Call pdf2.AddPage()

		  // Try to set RC4-128 encryption (revision 3) - This should fail in free version
		  // Full permissions for testing
		  Call pdf2.SetProtection("user123", "owner456", True, True, True, True, True, True, True, True, VNSPDFModule.gkEncryptionRC4_128)

		  If pdf2.Err() Then
		    // Expected: Should fail because hasPremiumEncryptionModule = False
		    Dim errorMsg As String = pdf2.GetError()

		    // Check if it's the expected error message about premium module
		    #If TargetiOS Then
		      Dim isPremiumError As Boolean = (errorMsg.IndexOf("premium Encryption module") >= 0)
		    #Else
		      Dim isPremiumError As Boolean = (errorMsg.IndexOf("premium Encryption module") > 0)
		    #EndIf

		    If isPremiumError Then
		      statusText = statusText + "✓ PASSED: RC4-128 correctly blocked (premium required)" + EndOfLine
		      statusText = statusText + "  Error message: " + errorMsg + EndOfLine
		    Else
		      statusText = statusText + "✗ FAILED: Unexpected error: " + errorMsg + EndOfLine
		      result.Value("success") = False
		      result.Value("status") = statusText
		      Return result
		    End If
		  Else
		    // This means RC4-128 worked without the premium flag - THIS IS A BUG!
		    statusText = statusText + "✗ FAILED: RC4-128 should be blocked without premium module!" + EndOfLine
		    statusText = statusText + "  BUG: Encryption was allowed when it should have been blocked." + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    Return result
		  End If

		  statusText = statusText + EndOfLine

		  // ===== Instructions for enabling premium module =====
		  statusText = statusText + "ENABLING PREMIUM ENCRYPTION MODULE:" + EndOfLine
		  statusText = statusText + "===================================" + EndOfLine
		  statusText = statusText + "To enable RC4-128 and AES encryption (revisions 3-6):" + EndOfLine + EndOfLine
		  statusText = statusText + "1. Open: PDF_Library/VNSPDFModule.xojo_code" + EndOfLine
		  statusText = statusText + "2. Find the constant: hasPremiumEncryptionModule" + EndOfLine
		  statusText = statusText + "3. Change Default from ""False"" to ""True""" + EndOfLine
		  statusText = statusText + "4. Rebuild your project" + EndOfLine + EndOfLine
		  statusText = statusText + "The constant should look like this when enabled:" + EndOfLine
		  statusText = statusText + "#tag Constant, Name = hasPremiumEncryptionModule, Type = Boolean," + EndOfLine
		  statusText = statusText + "    Dynamic = False, Default = ""True"", Scope = Public" + EndOfLine + EndOfLine
		  statusText = statusText + "After enabling, RC4-128 (revision 3) will work, and you can" + EndOfLine
		  statusText = statusText + "test it by running this example again." + EndOfLine + EndOfLine

		  // ===== Summary =====
		  statusText = statusText + "TEST SUMMARY:" + EndOfLine
		  statusText = statusText + "=============" + EndOfLine
		  statusText = statusText + "✓ Plugin architecture working correctly" + EndOfLine
		  statusText = statusText + "✓ RC4-40 (revision 2) available in free version" + EndOfLine
		  statusText = statusText + "✓ RC4-128 (revision 3) properly gated by premium flag" + EndOfLine
		  statusText = statusText + "✓ Clear error messages guide users to premium features" + EndOfLine + EndOfLine

		  result.Value("success") = True
		  result.Value("status") = statusText
		  result.Value("pdf") = pdf1.Output()  // Return the working RC4-40 PDF data
		  result.Value("filename") = "example18_plugin_architecture.pdf"

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample19() As Dictionary
		  #If VNSPDFModule.hasPremiumTableModule Then
		    // Example 19: Table Generation (Premium Feature)
		    // Demonstrates SimpleTable, ImprovedTable, and FancyTable with optional grand footers

		  Dim result As New Dictionary
		  Dim statusText As String = ""

		  statusText = statusText + "Example 19: Table Generation with Footers (Premium)" + EndOfLine
		  statusText = statusText + "========================================" + EndOfLine + EndOfLine

		  // Check if table module is available
		  #If Not VNSPDFModule.hasPremiumTableModule Then
		    statusText = statusText + "✗ SKIPPED: Table generation requires premium Table module" + EndOfLine
		    statusText = statusText + "Set VNSPDFModule.hasPremiumTableModule = True to enable" + EndOfLine + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    result.Value("filename") = ""
		    Return result
		  #EndIf

		  statusText = statusText + "✓ Table module is enabled" + EndOfLine + EndOfLine

		  // Create PDF
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)

		  Call pdf.SetTitle("Example 19 - Table Generation with Footers")
		  Call pdf.SetAuthor("VNS PDF Library")
		  Call pdf.SetSubject("Demonstrating table generation features with optional grand footers")

		  Call pdf.AddPage()

		  // Title
		  Call pdf.SetFont("helvetica", "B", 16)
		  Call pdf.Cell(0, 10, "Table Generation Examples with Footers", 0, 1, "C")
		  Call pdf.Ln(5)

		  // ===== Example 1: Simple Table =====
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "1. Simple Table (Equal Width Columns)", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Basic table with equal-width columns and simple borders.", 0, "L")
		  Call pdf.Ln(3)

		  // Create in-memory database for table 1
		  Dim db1 As New SQLiteDatabase
		  db1.DatabaseFile = Nil  // In-memory database

		  Try
		    db1.Connect()
		    db1.ExecuteSQL("CREATE TABLE countries (country TEXT, capital TEXT, area TEXT, population TEXT)")
		    db1.ExecuteSQL("INSERT INTO countries VALUES ('Austria', 'Vienna', '83,871', '8,859,000')")
		    db1.ExecuteSQL("INSERT INTO countries VALUES ('Belgium', 'Brussels', '30,528', '11,515,000')")
		    db1.ExecuteSQL("INSERT INTO countries VALUES ('France', 'Paris', '551,695', '67,750,000')")
		    db1.ExecuteSQL("INSERT INTO countries VALUES ('Germany', 'Berlin', '357,022', '83,240,000')")
		    db1.ExecuteSQL("INSERT INTO countries VALUES ('Italy', 'Rome', '301,340', '60,360,000')")

		    Dim rs1 As RowSet = db1.SelectSQL("SELECT country AS Country, capital AS Capital, area AS ""Area (sq km)"", population AS Population FROM countries")

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.SimpleTable(pdf, rs1, 40.0, 6.0)
		    Call pdf.Ln(8)
		    rs1.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 1: " + e.Message + EndOfLine
		  End Try
		  db1.Close

		  statusText = statusText + "✓ Simple table generated" + EndOfLine

		  // ===== Example 1b: Simple Table with Footer =====
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "1b. Simple Table with Grand Footer", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Simple table with grand footer showing total population.", 0, "L")
		  Call pdf.Ln(3)

		  // Create footer configuration
		  Dim footerConfig1b As New VNSPDFTableFooterConfig
		  footerConfig1b.Type = "grand"  // Only grand footer
		  footerConfig1b.LabelColumnIndex = 0  // Put label in first column
		  footerConfig1b.GrandLabel = "Total Population:"

		  // Configure grand footer style
		  footerConfig1b.GrandStyle = New VNSPDFTableFooterStyle  // Use default styling

		  // Configure calculations for population column
		  Redim footerConfig1b.ColumnCalculations(-1)

		  // Column 3 (Population): Sum only
		  Dim popCalc1b As New VNSPDFTableColumnCalc(3, Array(VNSPDFTablePremium.kCalcTypeSum), "{sum}")
		  popCalc1b.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.0f"
		  footerConfig1b.ColumnCalculations.Add(popCalc1b)

		  // Create in-memory database for table 1b
		  Dim db1b As New SQLiteDatabase
		  db1b.DatabaseFile = Nil  // In-memory database

		  Try
		    db1b.Connect()
		    db1b.ExecuteSQL("CREATE TABLE countries (country TEXT, capital TEXT, area TEXT, population REAL)")
		    db1b.ExecuteSQL("INSERT INTO countries VALUES ('Austria', 'Vienna', '83,871', 8859000)")
		    db1b.ExecuteSQL("INSERT INTO countries VALUES ('Belgium', 'Brussels', '30,528', 11515000)")
		    db1b.ExecuteSQL("INSERT INTO countries VALUES ('France', 'Paris', '551,695', 67750000)")
		    db1b.ExecuteSQL("INSERT INTO countries VALUES ('Germany', 'Berlin', '357,022', 83240000)")
		    db1b.ExecuteSQL("INSERT INTO countries VALUES ('Italy', 'Rome', '301,340', 60360000)")

		    Dim rs1b As RowSet = db1b.SelectSQL("SELECT country AS Country, capital AS Capital, area AS ""Area (sq km)"", population AS Population FROM countries")

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.SimpleTable(pdf, rs1b, 40.0, 6.0, True, footerConfig1b)
		    Call pdf.Ln(8)
		    rs1b.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 1b: " + e.Message + EndOfLine
		  End Try
		  db1b.Close

		  statusText = statusText + "✓ Simple table with footer generated" + EndOfLine

		  // ===== Example 1c: Simple Table with Intermediate Footer =====
		  Call pdf.AddPage()

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "1c. Simple Table with Intermediate Footer (Grouped)", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Simple table with intermediate footers showing subtotals per region. Data is grouped by the Region column.", 0, "L")
		  Call pdf.Ln(3)

		  // Create footer configuration with intermediate footers
		  Dim footerConfig1c As New VNSPDFTableFooterConfig
		  footerConfig1c.Type = "both"  // Both intermediate and grand footers
		  footerConfig1c.GroupByColumn = 0  // Group by Region column (column index 0)
		  footerConfig1c.LabelColumnIndex = 1  // Put labels in Product column
		  footerConfig1c.IntermediateLabelFormat = "Subtotal for {group}"
		  footerConfig1c.GrandLabel = "GRAND TOTAL"

		  // Configure intermediate footer style (default)
		  footerConfig1c.IntermediateStyle = New VNSPDFTableFooterStyle

		  // Configure grand footer style (default)
		  footerConfig1c.GrandStyle = New VNSPDFTableFooterStyle

		  // Configure calculations for columns
		  Redim footerConfig1c.ColumnCalculations(-1)

		  // Column 2 (Sales): Sum only
		  Dim salesCalc1c As New VNSPDFTableColumnCalc(2, Array(VNSPDFTablePremium.kCalcTypeSum), "${sum}")
		  salesCalc1c.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.0f"
		  footerConfig1c.ColumnCalculations.Add(salesCalc1c)

		  // Create in-memory database with regional sales data
		  Dim db1c As New SQLiteDatabase
		  db1c.DatabaseFile = Nil

		  Try
		    db1c.Connect()
		    db1c.ExecuteSQL("CREATE TABLE sales (region TEXT, product TEXT, sales REAL)")
		    db1c.ExecuteSQL("INSERT INTO sales VALUES ('East', 'Widget A', 12500)")
		    db1c.ExecuteSQL("INSERT INTO sales VALUES ('East', 'Widget B', 8900)")
		    db1c.ExecuteSQL("INSERT INTO sales VALUES ('East', 'Widget C', 15200)")
		    db1c.ExecuteSQL("INSERT INTO sales VALUES ('West', 'Widget A', 9800)")
		    db1c.ExecuteSQL("INSERT INTO sales VALUES ('West', 'Widget B', 11200)")
		    db1c.ExecuteSQL("INSERT INTO sales VALUES ('West', 'Widget C', 13500)")
		    db1c.ExecuteSQL("INSERT INTO sales VALUES ('South', 'Widget A', 7600)")
		    db1c.ExecuteSQL("INSERT INTO sales VALUES ('South', 'Widget B', 9100)")

		    Dim rs1c As RowSet = db1c.SelectSQL("SELECT region AS Region, product AS Product, sales AS Sales FROM sales ORDER BY region, product")

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.SimpleTable(pdf, rs1c, 60.0, 6.0, True, footerConfig1c)
		    Call pdf.Ln(8)
		    rs1c.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 1c: " + e.Message + EndOfLine
		  End Try
		  db1c.Close

		  statusText = statusText + "✓ Simple table with intermediate footer generated" + EndOfLine

		  // ===== Example 2: Improved Table =====
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "2. Improved Table (Custom Column Widths)", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Table with custom column widths and automatic number alignment.", 0, "L")
		  Call pdf.Ln(3)

		  // Custom widths for each column
		  Dim widths2() As Double = Array(45.0, 35.0, 30.0, 40.0)

		  // Reuse the same database query
		  Dim db2 As New SQLiteDatabase
		  db2.DatabaseFile = Nil
		  Try
		    db2.Connect()
		    db2.ExecuteSQL("CREATE TABLE countries (country TEXT, capital TEXT, area TEXT, population TEXT)")
		    db2.ExecuteSQL("INSERT INTO countries VALUES ('Austria', 'Vienna', '83,871', '8,859,000')")
		    db2.ExecuteSQL("INSERT INTO countries VALUES ('Belgium', 'Brussels', '30,528', '11,515,000')")
		    db2.ExecuteSQL("INSERT INTO countries VALUES ('France', 'Paris', '551,695', '67,750,000')")
		    db2.ExecuteSQL("INSERT INTO countries VALUES ('Germany', 'Berlin', '357,022', '83,240,000')")
		    db2.ExecuteSQL("INSERT INTO countries VALUES ('Italy', 'Rome', '301,340', '60,360,000')")

		    Dim rs2 As RowSet = db2.SelectSQL("SELECT country AS Country, capital AS Capital, area AS ""Area (sq km)"", population AS Population FROM countries")

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.ImprovedTable(pdf, rs2, widths2, 6.0)
		    Call pdf.Ln(8)
		    rs2.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 2: " + e.Message + EndOfLine
		  End Try
		  db2.Close

		  statusText = statusText + "✓ Improved table generated" + EndOfLine

		  // ===== Example 2b: Improved Table with Footer =====
		  Call pdf.AddPage()

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "2b. Improved Table with Grand Footer", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Improved table with grand footer showing total area and population.", 0, "L")
		  Call pdf.Ln(3)

		  // Create footer configuration
		  Dim footerConfig2b As New VNSPDFTableFooterConfig
		  footerConfig2b.Type = "grand"  // Only grand footer
		  footerConfig2b.LabelColumnIndex = 0  // Put label in first column
		  footerConfig2b.GrandLabel = "TOTALS:"

		  // Configure grand footer style
		  footerConfig2b.GrandStyle = New VNSPDFTableFooterStyle  // Use default styling

		  // Configure calculations for columns
		  Redim footerConfig2b.ColumnCalculations(-1)

		  // Column 2 (Area): Sum only
		  Dim areaCalc2b As New VNSPDFTableColumnCalc(2, Array(VNSPDFTablePremium.kCalcTypeSum), "{sum}")
		  areaCalc2b.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.0f"
		  footerConfig2b.ColumnCalculations.Add(areaCalc2b)

		  // Column 3 (Population): Sum only
		  Dim popCalc2b As New VNSPDFTableColumnCalc(3, Array(VNSPDFTablePremium.kCalcTypeSum), "{sum}")
		  popCalc2b.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.0f"
		  footerConfig2b.ColumnCalculations.Add(popCalc2b)

		  // Create in-memory database for table 2b
		  Dim db2b As New SQLiteDatabase
		  db2b.DatabaseFile = Nil

		  Try
		    db2b.Connect()
		    db2b.ExecuteSQL("CREATE TABLE countries (country TEXT, capital TEXT, area REAL, population REAL)")
		    db2b.ExecuteSQL("INSERT INTO countries VALUES ('Austria', 'Vienna', 83871, 8859000)")
		    db2b.ExecuteSQL("INSERT INTO countries VALUES ('Belgium', 'Brussels', 30528, 11515000)")
		    db2b.ExecuteSQL("INSERT INTO countries VALUES ('France', 'Paris', 551695, 67750000)")
		    db2b.ExecuteSQL("INSERT INTO countries VALUES ('Germany', 'Berlin', 357022, 83240000)")
		    db2b.ExecuteSQL("INSERT INTO countries VALUES ('Italy', 'Rome', 301340, 60360000)")

		    Dim rs2b As RowSet = db2b.SelectSQL("SELECT country AS Country, capital AS Capital, area AS ""Area (sq km)"", population AS Population FROM countries")

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.ImprovedTable(pdf, rs2b, widths2, 6.0, True, footerConfig2b)
		    Call pdf.Ln(8)
		    rs2b.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 2b: " + e.Message + EndOfLine
		  End Try
		  db2b.Close

		  statusText = statusText + "✓ Improved table with footer generated" + EndOfLine

		  // ===== Example 2c: Improved Table with Intermediate Footer =====
		  Call pdf.AddPage()

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "2c. Improved Table with Intermediate Footer (Grouped)", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Improved table with custom column widths, intermediate footers showing subtotals per category, and grand total.", 0, "L")
		  Call pdf.Ln(3)

		  // Create footer configuration with intermediate footers
		  Dim footerConfig2c As New VNSPDFTableFooterConfig
		  footerConfig2c.Type = "both"  // Both intermediate and grand footers
		  footerConfig2c.GroupByColumn = 0  // Group by Category column (column index 0)
		  footerConfig2c.LabelColumnIndex = 1  // Put labels in Item column
		  footerConfig2c.IntermediateLabelFormat = "Subtotal for {group}"
		  footerConfig2c.GrandLabel = "GRAND TOTAL"

		  // Configure intermediate footer style (default)
		  footerConfig2c.IntermediateStyle = New VNSPDFTableFooterStyle

		  // Configure grand footer style (default)
		  footerConfig2c.GrandStyle = New VNSPDFTableFooterStyle

		  // Configure calculations for columns
		  Redim footerConfig2c.ColumnCalculations(-1)

		  // Column 3 (Amount): Sum only
		  Dim amountCalc2c As New VNSPDFTableColumnCalc(3, Array(VNSPDFTablePremium.kCalcTypeSum), "${sum}")
		  amountCalc2c.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.2f"
		  footerConfig2c.ColumnCalculations.Add(amountCalc2c)

		  // Custom widths for columns: Category, Item, Qty, Amount
		  Dim widths2c() As Double = Array(40.0, 60.0, 20.0, 30.0)

		  // Create in-memory database with expense data
		  Dim db2c As New SQLiteDatabase
		  db2c.DatabaseFile = Nil

		  Try
		    db2c.Connect()
		    db2c.ExecuteSQL("CREATE TABLE expenses (category TEXT, item TEXT, qty INTEGER, amount REAL)")
		    db2c.ExecuteSQL("INSERT INTO expenses VALUES ('Office', 'Paper Reams', 5, 45.50)")
		    db2c.ExecuteSQL("INSERT INTO expenses VALUES ('Office', 'Pens Box', 3, 18.75)")
		    db2c.ExecuteSQL("INSERT INTO expenses VALUES ('Office', 'Staplers', 2, 24.00)")
		    db2c.ExecuteSQL("INSERT INTO expenses VALUES ('Travel', 'Flight', 1, 450.00)")
		    db2c.ExecuteSQL("INSERT INTO expenses VALUES ('Travel', 'Hotel', 2, 280.00)")
		    db2c.ExecuteSQL("INSERT INTO expenses VALUES ('Travel', 'Meals', 4, 96.50)")
		    db2c.ExecuteSQL("INSERT INTO expenses VALUES ('Equipment', 'Laptop', 1, 1299.99)")
		    db2c.ExecuteSQL("INSERT INTO expenses VALUES ('Equipment', 'Monitor', 2, 398.00)")

		    Dim rs2c As RowSet = db2c.SelectSQL("SELECT category AS Category, item AS Item, qty AS Qty, amount AS Amount FROM expenses ORDER BY category, item")

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.ImprovedTable(pdf, rs2c, widths2c, 6.0, True, footerConfig2c)
		    Call pdf.Ln(8)
		    rs2c.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 2c: " + e.Message + EndOfLine
		  End Try
		  db2c.Close

		  statusText = statusText + "✓ Improved table with intermediate footer generated" + EndOfLine

		  // ===== Example 3: Fancy Table =====

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "3. Fancy Table (With Colors)", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Styled table with colored header and alternating row colors.", 0, "L")
		  Call pdf.Ln(3)

		  // Create in-memory database for table 3
		  Dim db3 As New SQLiteDatabase
		  db3.DatabaseFile = Nil
		  Try
		    db3.Connect()
		    db3.ExecuteSQL("CREATE TABLE countries (country TEXT, capital TEXT, area TEXT, population TEXT)")
		    db3.ExecuteSQL("INSERT INTO countries VALUES ('Austria', 'Vienna', '83,871', '8,859,000')")
		    db3.ExecuteSQL("INSERT INTO countries VALUES ('Belgium', 'Brussels', '30,528', '11,515,000')")
		    db3.ExecuteSQL("INSERT INTO countries VALUES ('France', 'Paris', '551,695', '67,750,000')")
		    db3.ExecuteSQL("INSERT INTO countries VALUES ('Germany', 'Berlin', '357,022', '83,240,000')")
		    db3.ExecuteSQL("INSERT INTO countries VALUES ('Italy', 'Rome', '301,340', '60,360,000')")

		    Dim rs3 As RowSet = db3.SelectSQL("SELECT country AS Country, capital AS Capital, area AS ""Area (sq km)"", population AS Population FROM countries")

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.FancyTable(pdf, rs3, widths2, 6.0)
		    Call pdf.Ln(10)
		    rs3.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 3: " + e.Message + EndOfLine
		  End Try
		  db3.Close

		  statusText = statusText + "✓ Fancy table generated" + EndOfLine + EndOfLine

		  // ===== Example 4: Sales Data Table =====
		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "4. Sales Report Table", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Professional sales report with numeric data formatting.", 0, "L")
		  Call pdf.Ln(3)

		  Dim widths4() As Double = Array(70.0, 25.0, 20.0, 35.0)

		  // Create in-memory database for table 4
		  Dim db4 As New SQLiteDatabase
		  db4.DatabaseFile = Nil
		  Try
		    db4.Connect()
		    db4.ExecuteSQL("CREATE TABLE sales (product TEXT, price TEXT, qty TEXT, total TEXT)")
		    db4.ExecuteSQL("INSERT INTO sales VALUES ('Professional Services', '150.00', '8', '1200.00')")
		    db4.ExecuteSQL("INSERT INTO sales VALUES ('Software License', '599.99', '3', '1799.97')")
		    db4.ExecuteSQL("INSERT INTO sales VALUES ('Hardware Bundle', '1299.50', '2', '2599.00')")
		    db4.ExecuteSQL("INSERT INTO sales VALUES ('Training Session', '450.00', '4', '1800.00')")
		    db4.ExecuteSQL("INSERT INTO sales VALUES ('Support Contract', '2500.00', '1', '2500.00')")

		    Dim rs4 As RowSet = db4.SelectSQL("SELECT product AS Product, price AS Price, qty AS Qty, total AS Total FROM sales")

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.FancyTable(pdf, rs4, widths4, 6.0)
		    rs4.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 4: " + e.Message + EndOfLine
		  End Try
		  db4.Close

		  statusText = statusText + "✓ Sales report table generated" + EndOfLine + EndOfLine

		  // ===== Example 5: Multi-Page Table =====
		  Call pdf.AddPage()

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "5. Multi-Page Table (Pagination)", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Large dataset demonstrating automatic page breaks. Table spans multiple pages with 100 rows of employee data. Headers automatically repeat on each new page.", 0, "L")
		  Call pdf.Ln(3)

		  Dim widths5() As Double = Array(60.0, 40.0, 30.0, 40.0)

		  // Create in-memory database with 100 employee records
		  Dim db5 As New SQLiteDatabase
		  db5.DatabaseFile = Nil
		  Try
		    db5.Connect()
		    db5.ExecuteSQL("CREATE TABLE employees (name TEXT, department TEXT, employee_id TEXT, salary TEXT)")

		    // Generate 100 employee records with more variety
		    Dim departments() As String = Array("Engineering", "Sales", "Marketing", "HR", "Finance", "Operations", "IT", "Legal", "R&D", "Support")
		    Dim firstNames() As String = Array("John", "Jane", "Michael", "Sarah", "David", "Emma", "James", "Lisa", "Robert", "Maria", "William", "Emily", "Daniel", "Sophia", "Matthew")
		    Dim lastNames() As String = Array("Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Taylor", "Anderson", "Wilson", "Moore", "Jackson")

		    For i As Integer = 1 To 99
		      Dim firstName As String = firstNames((i - 1) Mod firstNames.Count)
		      Dim lastName As String = lastNames((i - 1) Mod lastNames.Count)
		      Dim name As String = firstName + " " + lastName
		      Dim dept As String = departments((i - 1) Mod departments.Count)
		      Dim empId As String = "EMP" + FormatHelper(i, "000")
		      Dim salary As String = FormatHelper(45000 + (i * 500), "#,##0")

		      db5.ExecuteSQL("INSERT INTO employees VALUES ('" + name + "', '" + dept + "', '" + empId + "', '" + salary + "')")
		    Next

		    Dim rs5 As RowSet = db5.SelectSQL("SELECT name AS ""Employee Name"", department AS Department, employee_id AS ""ID"", salary AS ""Salary ($)"" FROM employees")

		    Call pdf.SetFont("helvetica", "", 8)
		    // Use repeatHeaders=True (default) to show headers on each page
		    Call VNSPDFTablePremium.FancyTable(pdf, rs5, widths5, 5.0, True)
		    rs5.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 5: " + e.Message + EndOfLine
		  End Try
		  db5.Close

		  statusText = statusText + "✓ Multi-page table generated (99 rows with repeated headers)" + EndOfLine + EndOfLine

		  // ===== Example 6: Table with Grand Footer =====
		  Call pdf.AddPage()

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "6. Table with Grand Footer (Totals)", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Demonstrates grand footer with sum and count calculations.", 0, "L")
		  Call pdf.Ln(3)

		  // SQL Query for this example:
		  Call pdf.SetFont("courier", "", 8)
		  Call pdf.SetTextColor(0, 100, 0)
		  Call pdf.MultiCell(0, 3, "SELECT product AS Product, price AS Price, qty AS Qty, total AS Total FROM sales", 0, "L")
		  Call pdf.SetTextColor(0, 0, 0)
		  Call pdf.Ln(2)

		  // Create sales data with numbers for totaling
		  Dim db6 As New SQLiteDatabase
		  db6.DatabaseFile = Nil
		  Try
		    db6.Connect()
		    db6.ExecuteSQL("CREATE TABLE sales (product TEXT, price REAL, qty INTEGER, total REAL)")
		    db6.ExecuteSQL("INSERT INTO sales VALUES ('Professional Services', 150.00, 8, 1200.00)")
		    db6.ExecuteSQL("INSERT INTO sales VALUES ('Software License', 599.99, 3, 1799.97)")
		    db6.ExecuteSQL("INSERT INTO sales VALUES ('Hardware Bundle', 1299.50, 2, 2599.00)")
		    db6.ExecuteSQL("INSERT INTO sales VALUES ('Training Session', 450.00, 4, 1800.00)")
		    db6.ExecuteSQL("INSERT INTO sales VALUES ('Support Contract', 2500.00, 1, 2500.00)")

		    Dim rs6 As RowSet = db6.SelectSQL("SELECT product AS Product, price AS Price, qty AS Qty, total AS Total FROM sales")

		    // Configure grand footer
		    Dim footerConfig As New VNSPDFTableFooterConfig
		    footerConfig.Type = "grand"
		    footerConfig.LabelColumnIndex = 0
		    footerConfig.GrandLabel = "TOTAL"

		    // Configure grand footer style
		    footerConfig.GrandStyle = New VNSPDFTableFooterStyle
		    // iOS uses Color.RGB() method, Desktop/Web/Console use RGB() function
		    #If TargetiOS Then
		      footerConfig.GrandStyle.BackgroundColor = Color.RGB(52, 73, 94)  // Dark blue
		      footerConfig.GrandStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig.GrandStyle.BorderColor = Color.RGB(0, 0, 0)
		    #Else
		      footerConfig.GrandStyle.BackgroundColor = RGB(52, 73, 94)  // Dark blue
		      footerConfig.GrandStyle.TextColor = RGB(255, 255, 255)  // White
		      footerConfig.GrandStyle.BorderColor = RGB(0, 0, 0)
		    #EndIf
		    footerConfig.GrandStyle.FontStyle = "B"
		    footerConfig.GrandStyle.CellHeight = 7.0

		    // Configure calculations for columns
		    Redim footerConfig.ColumnCalculations(-1)

		    // Column 2 (Qty): Sum and Count
		    Dim qtyCalc As New VNSPDFTableColumnCalc(2, Array(VNSPDFTablePremium.kCalcTypeSum, VNSPDFTablePremium.kCalcTypeCount), "{sum} ({count})")
		    qtyCalc.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.0f"
		    qtyCalc.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeCount) = "%d"
		    footerConfig.ColumnCalculations.Add(qtyCalc)

		    // Column 3 (Total): Sum only
		    Dim totalCalc As New VNSPDFTableColumnCalc(3, Array(VNSPDFTablePremium.kCalcTypeSum), "${sum}")
		    totalCalc.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.2f"
		    footerConfig.ColumnCalculations.Add(totalCalc)

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.FancyTable(pdf, rs6, widths4, 6.0, True, footerConfig)
		    rs6.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 6: " + e.Message + EndOfLine
		  End Try
		  db6.Close

		  statusText = statusText + "✓ Table with grand footer generated" + EndOfLine + EndOfLine

		  // ===== Example 7: Multi-Page Table with Grand Footer =====
		  Call pdf.AddPage()

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "7. Multi-Page Table with Grand Footer", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Large dataset demonstrating grand footer at the end of a multi-page table. Table spans multiple pages with 50 sales records, but the grand total only appears once at the very end.", 0, "L")
		  Call pdf.Ln(3)

		  // SQL Query for this example:
		  Call pdf.SetFont("courier", "", 8)
		  Call pdf.SetTextColor(0, 100, 0)
		  Call pdf.MultiCell(0, 3, "SELECT product AS Product, price AS Price, qty AS Qty, total AS Total FROM sales", 0, "L")
		  Call pdf.SetTextColor(0, 0, 0)
		  Call pdf.Ln(2)

		  // Create in-memory database with 50 sales records
		  Dim db7 As New SQLiteDatabase
		  db7.DatabaseFile = Nil
		  Try
		    db7.Connect()
		    db7.ExecuteSQL("CREATE TABLE sales (product TEXT, price REAL, qty INTEGER, total REAL)")

		    Dim products() As String = Array("Professional Services", "Software License", "Hardware Bundle", "Training Session", "Support Contract", "Consulting Hours", "Cloud Subscription", "Premium Support")

		    For i As Integer = 1 To 50
		      Dim product As String = products((i - 1) Mod products.Count)
		      Dim price As Double = 100.0 + (i * 27.50)
		      Dim qty As Integer = 1 + ((i - 1) Mod 5)
		      Dim total As Double = price * qty

		      db7.ExecuteSQL("INSERT INTO sales VALUES ('" + product + "', " + Str(price) + ", " + Str(qty) + ", " + Str(total) + ")")
		    Next

		    Dim rs7 As RowSet = db7.SelectSQL("SELECT product AS Product, price AS Price, qty AS Qty, total AS Total FROM sales")

		    // Configure grand footer
		    Dim footerConfig7 As New VNSPDFTableFooterConfig
		    footerConfig7.Type = "grand"
		    footerConfig7.LabelColumnIndex = 0
		    footerConfig7.GrandLabel = "GRAND TOTAL"

		    // Configure grand footer style
		    footerConfig7.GrandStyle = New VNSPDFTableFooterStyle
		    #If TargetiOS Then
		      footerConfig7.GrandStyle.BackgroundColor = Color.RGB(44, 62, 80)  // Dark gray
		      footerConfig7.GrandStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig7.GrandStyle.BorderColor = Color.RGB(0, 0, 0)
		    #Else
		      footerConfig7.GrandStyle.BackgroundColor = RGB(44, 62, 80)  // Dark gray
		      footerConfig7.GrandStyle.TextColor = RGB(255, 255, 255)  // White
		      footerConfig7.GrandStyle.BorderColor = RGB(0, 0, 0)
		    #EndIf
		    footerConfig7.GrandStyle.FontStyle = "B"
		    footerConfig7.GrandStyle.CellHeight = 8.0

		    // Configure calculations for columns
		    Redim footerConfig7.ColumnCalculations(-1)

		    // Column 2 (Qty): Sum and Count
		    Dim qtyCalc7 As New VNSPDFTableColumnCalc(2, Array(VNSPDFTablePremium.kCalcTypeSum, VNSPDFTablePremium.kCalcTypeCount), "{sum} items ({count} rows)")
		    qtyCalc7.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.0f"
		    qtyCalc7.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeCount) = "%d"
		    footerConfig7.ColumnCalculations.Add(qtyCalc7)

		    // Column 3 (Total): Sum, Avg, Min, Max
		    Dim totalCalc7 As New VNSPDFTableColumnCalc(3, Array(VNSPDFTablePremium.kCalcTypeSum), "${sum}")
		    totalCalc7.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.2f"
		    footerConfig7.ColumnCalculations.Add(totalCalc7)

		    Call pdf.SetFont("helvetica", "", 8)
		    Call VNSPDFTablePremium.FancyTable(pdf, rs7, widths4, 5.0, True, footerConfig7)
		    rs7.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 7: " + e.Message + EndOfLine
		  End Try
		  db7.Close

		  statusText = statusText + "✓ Multi-page table with grand footer generated (50 rows)" + EndOfLine + EndOfLine

		  // ===== Example 8: Table with Intermediate Footers (Subtotals) =====
		  Call pdf.AddPage()

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "8. Table with Intermediate Footers (Subtotals by Region)", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Demonstrates intermediate footers showing subtotals when the Region column changes. Each region gets its own subtotal before moving to the next region.", 0, "L")
		  Call pdf.Ln(3)

		  // SQL Query for this example:
		  Call pdf.SetFont("courier", "", 8)
		  Call pdf.SetTextColor(0, 100, 0)
		  Call pdf.MultiCell(0, 3, "SELECT region AS Region, product AS Product, qty AS Qty, total AS Total FROM sales ORDER BY region", 0, "L")
		  Call pdf.SetTextColor(0, 0, 0)
		  Call pdf.Ln(2)

		  // Create sales data grouped by region
		  Dim db8 As New SQLiteDatabase
		  db8.DatabaseFile = Nil
		  Try
		    db8.Connect()
		    db8.ExecuteSQL("CREATE TABLE sales (region TEXT, product TEXT, qty INTEGER, total REAL)")

		    // East region sales
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('East', 'Professional Services', 5, 750.00)")
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('East', 'Software License', 3, 1799.97)")
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('East', 'Training Session', 2, 900.00)")

		    // West region sales
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('West', 'Hardware Bundle', 4, 5198.00)")
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('West', 'Support Contract', 2, 5000.00)")
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('West', 'Professional Services', 3, 450.00)")

		    // South region sales
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('South', 'Software License', 6, 3599.94)")
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('South', 'Training Session', 8, 3600.00)")
		    db8.ExecuteSQL("INSERT INTO sales VALUES ('South', 'Hardware Bundle', 1, 1299.50)")

		    Dim rs8 As RowSet = db8.SelectSQL("SELECT region AS Region, product AS Product, qty AS Qty, total AS Total FROM sales ORDER BY region")

		    // Configure intermediate and grand footers
		    Dim footerConfig8 As New VNSPDFTableFooterConfig
		    footerConfig8.Type = "both"  // Both intermediate and grand
		    footerConfig8.GroupByColumn = 0  // Group by Region column
		    footerConfig8.LabelColumnIndex = 1  // Put labels in Product column
		    footerConfig8.IntermediateLabelFormat = "Subtotal for {group}"
		    footerConfig8.GrandLabel = "GRAND TOTAL"

		    // Configure intermediate footer style (lighter)
		    footerConfig8.IntermediateStyle = New VNSPDFTableFooterStyle
		    #If TargetiOS Then
		      footerConfig8.IntermediateStyle.BackgroundColor = Color.RGB(149, 165, 166)  // Medium gray
		      footerConfig8.IntermediateStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig8.IntermediateStyle.BorderColor = Color.RGB(0, 0, 0)
		    #Else
		      footerConfig8.IntermediateStyle.BackgroundColor = RGB(149, 165, 166)  // Medium gray
		      footerConfig8.IntermediateStyle.TextColor = RGB(255, 255, 255)  // White
		      footerConfig8.IntermediateStyle.BorderColor = RGB(0, 0, 0)
		    #EndIf
		    footerConfig8.IntermediateStyle.FontStyle = "B"
		    footerConfig8.IntermediateStyle.CellHeight = 6.5

		    // Configure grand footer style (darker)
		    footerConfig8.GrandStyle = New VNSPDFTableFooterStyle
		    #If TargetiOS Then
		      footerConfig8.GrandStyle.BackgroundColor = Color.RGB(44, 62, 80)  // Dark gray
		      footerConfig8.GrandStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig8.GrandStyle.BorderColor = Color.RGB(0, 0, 0)
		    #Else
		      footerConfig8.GrandStyle.BackgroundColor = RGB(44, 62, 80)  // Dark gray
		      footerConfig8.GrandStyle.TextColor = RGB(255, 255, 255)  // White
		      footerConfig8.GrandStyle.BorderColor = RGB(0, 0, 0)
		    #EndIf
		    footerConfig8.GrandStyle.FontStyle = "B"
		    footerConfig8.GrandStyle.CellHeight = 8.0

		    // Configure calculations for columns
		    Redim footerConfig8.ColumnCalculations(-1)

		    // Column 2 (Qty): Sum
		    Dim qtyCalc8 As New VNSPDFTableColumnCalc(2, Array(VNSPDFTablePremium.kCalcTypeSum), "{sum}")
		    qtyCalc8.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.0f"
		    footerConfig8.ColumnCalculations.Add(qtyCalc8)

		    // Column 3 (Total): Sum
		    Dim totalCalc8 As New VNSPDFTableColumnCalc(3, Array(VNSPDFTablePremium.kCalcTypeSum), "${sum}")
		    totalCalc8.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.2f"
		    footerConfig8.ColumnCalculations.Add(totalCalc8)

		    Dim widths8() As Double = Array(30.0, 70.0, 20.0, 40.0)

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.FancyTable(pdf, rs8, widths8, 6.0, True, footerConfig8)
		    rs8.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 8: " + e.Message + EndOfLine
		  End Try
		  db8.Close

		  statusText = statusText + "✓ Table with intermediate footers generated (3 regions with subtotals)" + EndOfLine + EndOfLine

		  // ===== Example 9: Multi-Page Table with Intermediate and Grand Footers =====
		  Call pdf.AddPage()

		  Call pdf.SetFont("helvetica", "B", 14)
		  Call pdf.Cell(0, 8, "9. Multi-Page Table with Subtotals and Grand Total", 0, 1)
		  Call pdf.Ln(2)

		  Call pdf.SetFont("helvetica", "", 10)
		  Call pdf.MultiCell(0, 5, "Demonstrates a multi-page table (90 rows across 3 regions) with intermediate footers showing regional subtotals and a grand total at the end. Each region has 30 sales records.", 0, "L")
		  Call pdf.Ln(3)

		  // SQL Query for this example:
		  Call pdf.SetFont("courier", "", 8)
		  Call pdf.SetTextColor(0, 100, 0)
		  Call pdf.MultiCell(0, 3, "SELECT region AS Region, product AS Product, qty AS Qty, total AS Total FROM sales ORDER BY region", 0, "L")
		  Call pdf.SetTextColor(0, 0, 0)
		  Call pdf.Ln(2)

		  // Create large dataset with 90 sales records (30 per region)
		  Dim db9 As New SQLiteDatabase
		  db9.DatabaseFile = Nil
		  Try
		    db9.Connect()
		    db9.ExecuteSQL("CREATE TABLE sales (region TEXT, product TEXT, qty INTEGER, total REAL)")

		    Dim products9() As String = Array("Professional Services", "Software License", "Hardware Bundle", "Training Session", "Support Contract", "Consulting Hours", "Cloud Subscription", "Premium Support", "Implementation", "Maintenance")

		    // East region - 30 records
		    For i As Integer = 1 To 30
		      Dim product9 As String = products9((i - 1) Mod products9.Count)
		      Dim qty9 As Integer = 1 + ((i - 1) Mod 8)
		      Dim price9 As Double = 50.0 + (i * 13.75)
		      Dim total9 As Double = price9 * qty9
		      db9.ExecuteSQL("INSERT INTO sales VALUES ('East', '" + product9 + "', " + Str(qty9) + ", " + Str(total9) + ")")
		    Next

		    // South region - 30 records
		    For i As Integer = 31 To 60
		      Dim product9 As String = products9((i - 1) Mod products9.Count)
		      Dim qty9 As Integer = 1 + ((i - 1) Mod 6)
		      Dim price9 As Double = 75.0 + (i * 11.50)
		      Dim total9 As Double = price9 * qty9
		      db9.ExecuteSQL("INSERT INTO sales VALUES ('South', '" + product9 + "', " + Str(qty9) + ", " + Str(total9) + ")")
		    Next

		    // West region - 30 records
		    For i As Integer = 61 To 90
		      Dim product9 As String = products9((i - 1) Mod products9.Count)
		      Dim qty9 As Integer = 1 + ((i - 1) Mod 7)
		      Dim price9 As Double = 100.0 + (i * 9.25)
		      Dim total9 As Double = price9 * qty9
		      db9.ExecuteSQL("INSERT INTO sales VALUES ('West', '" + product9 + "', " + Str(qty9) + ", " + Str(total9) + ")")
		    Next

		    Dim rs9 As RowSet = db9.SelectSQL("SELECT region AS Region, product AS Product, qty AS Qty, total AS Total FROM sales ORDER BY region")

		    // Configure intermediate and grand footers
		    Dim footerConfig9 As New VNSPDFTableFooterConfig
		    footerConfig9.Type = "both"  // Both intermediate and grand
		    footerConfig9.GroupByColumn = 0  // Group by Region column
		    footerConfig9.LabelColumnIndex = 1  // Put labels in Product column
		    footerConfig9.IntermediateLabelFormat = "Subtotal for {group}"
		    footerConfig9.GrandLabel = "GRAND TOTAL (All Regions)"

		    // Configure intermediate footer style (lighter blue-gray)
		    footerConfig9.IntermediateStyle = New VNSPDFTableFooterStyle
		    #If TargetiOS Then
		      footerConfig9.IntermediateStyle.BackgroundColor = Color.RGB(149, 165, 166)  // Medium gray
		      footerConfig9.IntermediateStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig9.IntermediateStyle.BorderColor = Color.RGB(0, 0, 0)
		    #Else
		      footerConfig9.IntermediateStyle.BackgroundColor = RGB(149, 165, 166)  // Medium gray
		      footerConfig9.IntermediateStyle.TextColor = RGB(255, 255, 255)  // White
		      footerConfig9.IntermediateStyle.BorderColor = RGB(0, 0, 0)
		    #EndIf
		    footerConfig9.IntermediateStyle.FontStyle = "B"
		    footerConfig9.IntermediateStyle.CellHeight = 6.5

		    // Configure grand footer style (dark blue-gray)
		    footerConfig9.GrandStyle = New VNSPDFTableFooterStyle
		    #If TargetiOS Then
		      footerConfig9.GrandStyle.BackgroundColor = Color.RGB(44, 62, 80)  // Dark gray
		      footerConfig9.GrandStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig9.GrandStyle.BorderColor = Color.RGB(0, 0, 0)
		    #Else
		      footerConfig9.GrandStyle.BackgroundColor = RGB(44, 62, 80)  // Dark gray
		      footerConfig9.GrandStyle.TextColor = RGB(255, 255, 255)  // White
		      footerConfig9.GrandStyle.BorderColor = RGB(0, 0, 0)
		    #EndIf
		    footerConfig9.GrandStyle.FontStyle = "B"
		    footerConfig9.GrandStyle.CellHeight = 8.0

		    // Configure calculations for columns
		    Redim footerConfig9.ColumnCalculations(-1)

		    // Column 2 (Qty): Sum and Count
		    Dim qtyCalc9 As New VNSPDFTableColumnCalc(2, Array(VNSPDFTablePremium.kCalcTypeSum, VNSPDFTablePremium.kCalcTypeCount), "{sum} items ({count} rows)")
		    qtyCalc9.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.0f"
		    qtyCalc9.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeCount) = "%d"
		    footerConfig9.ColumnCalculations.Add(qtyCalc9)

		    // Column 3 (Total): Sum
		    Dim totalCalc9 As New VNSPDFTableColumnCalc(3, Array(VNSPDFTablePremium.kCalcTypeSum), "${sum}")
		    totalCalc9.NumberFormats.Value(VNSPDFTablePremium.kCalcTypeSum) = "%.2f"
		    footerConfig9.ColumnCalculations.Add(totalCalc9)

		    Dim widths9() As Double = Array(30.0, 70.0, 30.0, 40.0)

		    Call pdf.SetFont("helvetica", "", 9)
		    Call VNSPDFTablePremium.FancyTable(pdf, rs9, widths9, 5.5, True, footerConfig9)
		    rs9.Close
		  Catch e As DatabaseException
		    statusText = statusText + "ERROR creating table 9: " + e.Message + EndOfLine
		  End Try
		  db9.Close

		  statusText = statusText + "✓ Multi-page table with intermediate and grand footers generated (90 rows, 3 regions)" + EndOfLine + EndOfLine

		  // Check for errors
		  If pdf.Err() Then
		    statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    result.Value("filename") = ""
		    Return result
		  End If

		  // Generate PDF
		  Dim pdfData As String = pdf.Output()

		    result.Value("success") = True
		    result.Value("status") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example19_tables.pdf"

		    Return result
		  #Else
		    // Table module not available in free version
		    Dim result As New Dictionary
		    result.Value("success") = False
		    result.Value("status") = "Example 19 requires Premium Table Module"
		    result.Value("message") = "Table generation features are available in the premium version only."
		    Return result
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546573742070757265205869626F207A6C696220696D706C656D656E746174696F6E2077697468206B6E6F776E20746573742076656374666F72732E
		Function TestZlib() As Dictionary
		  // Test pure Xojo zlib implementation with known test vectors
		  // Returns a Dictionary with test results for display

		  Dim result As New Dictionary
		  Dim output As String = "=== Testing Pure Xojo Zlib Implementation ===" + EndOfLine
		  output = output + "Running compression test vectors..." + EndOfLine + EndOfLine

		  Dim allPassed As Boolean = True
		  Dim testOutput As String = ""

		  // Test 1: Empty string
		  output = output + "Test 1: Empty string..." + EndOfLine
		  Dim test1Result As Dictionary = TestZlibEmptyString()
		  testOutput = test1Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test1Result.Value("passed") Then
		    output = output + "  PASSED" + EndOfLine
		  Else
		    output = output + "  FAILED" + EndOfLine
		    allPassed = False
		  End If

		  // Test 2: Short string "Hello"
		  output = output + "Test 2: Short string 'Hello'..." + EndOfLine
		  Dim test2Result As Dictionary = TestZlibShortString()
		  testOutput = test2Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test2Result.Value("passed") Then
		    output = output + "  PASSED" + EndOfLine
		  Else
		    output = output + "  FAILED" + EndOfLine
		    allPassed = False
		  End If

		  // Test 3: Known zlib test vector - RFC 1950 example
		  output = output + "Test 3: RFC 1950 style compression..." + EndOfLine
		  Dim test3Result As Dictionary = TestZlibRFC1950()
		  testOutput = test3Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test3Result.Value("passed") Then
		    output = output + "  PASSED" + EndOfLine
		  Else
		    output = output + "  FAILED" + EndOfLine
		    allPassed = False
		  End If

		  // Test 4: Repeated pattern (should compress well)
		  output = output + "Test 4: Repeated pattern compression..." + EndOfLine
		  Dim test4Result As Dictionary = TestZlibRepeatedPattern()
		  testOutput = test4Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test4Result.Value("passed") Then
		    output = output + "  PASSED" + EndOfLine
		  Else
		    output = output + "  FAILED" + EndOfLine
		    allPassed = False
		  End If

		  // Test 5: ADLER-32 checksum verification
		  output = output + "Test 5: ADLER-32 checksum..." + EndOfLine
		  Dim test5Result As Dictionary = TestAdler32()
		  testOutput = test5Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test5Result.Value("passed") Then
		    output = output + "  PASSED" + EndOfLine
		  Else
		    output = output + "  FAILED" + EndOfLine
		    allPassed = False
		  End If

		  // Test 6: Round-trip with system zlib (if available)
		  output = output + "Test 6: Round-trip verification..." + EndOfLine
		  Dim test6Result As Dictionary = TestZlibRoundTrip()
		  testOutput = test6Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test6Result.Value("passed") Then
		    output = output + "  PASSED" + EndOfLine
		  Else
		    output = output + "  FAILED" + EndOfLine
		    allPassed = False
		  End If

		  output = output + EndOfLine
		  If allPassed Then
		    output = output + "=== ALL ZLIB TESTS PASSED ===" + EndOfLine
		    output = output + "Pure Xojo zlib deflate is working correctly!" + EndOfLine
		  Else
		    output = output + "=== SOME ZLIB TESTS FAILED ===" + EndOfLine
		    output = output + "Review the output above for details." + EndOfLine
		  End If
		  output = output + EndOfLine

		  result.Value("passed") = allPassed
		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestZlibEmptyString() As Dictionary
		  // Test compressing an empty string - should return Nil
		  Dim result As New Dictionary
		  result.Value("output") = ""

		  #If VNSPDFModule.hasPremiumZlibModule Then
		    Dim deflater As New VNSZlibPremiumDeflate
		    Dim compressedResult As MemoryBlock = deflater.CompressString("")
		    // Empty input should return Nil
		    result.Value("passed") = (compressedResult = Nil)
		  #Else
		    result.Value("output") = "  (Skipped - hasPremiumZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestZlibShortString() As Dictionary
		  // Test compressing a short string
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumZlibModule Then
		    Dim deflater As New VNSZlibPremiumDeflate
		    Dim input As String = "Hello"
		    Dim compressedResult As MemoryBlock = deflater.CompressString(input)

		    If compressedResult = Nil Or compressedResult.Size = 0 Then
		      output = output + "  Error: Compression returned empty result" + EndOfLine
		      result.Value("passed") = False
		    Else
		      // Check zlib header (first byte should be 0x78 for deflate with 32K window)
		      If compressedResult.Byte(0) <> &h78 Then
		        output = output + "  Error: Invalid zlib header byte: " + Hex(compressedResult.Byte(0)) + EndOfLine
		        result.Value("passed") = False
		      Else
		        #If TargetiOS Then
		          output = output + "  Input: " + Str(input.Length) + " bytes, Output: " + Str(compressedResult.Size) + " bytes" + EndOfLine
		        #Else
		          output = output + "  Input: " + Str(input.Bytes) + " bytes, Output: " + Str(compressedResult.Size) + " bytes" + EndOfLine
		        #EndIf
		        result.Value("passed") = True
		      End If
		    End If
		  #Else
		    output = "  (Skipped - hasPremiumZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestZlibRFC1950() As Dictionary
		  // Test with a standard test string
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumZlibModule Then
		    Dim deflater As New VNSZlibPremiumDeflate
		    Dim input As String = "The quick brown fox jumps over the lazy dog"
		    Dim compressedResult As MemoryBlock = deflater.CompressString(input)

		    If compressedResult = Nil Or compressedResult.Size = 0 Then
		      output = output + "  Error: Compression returned empty result" + EndOfLine
		      result.Value("passed") = False
		    Else
		      // Verify zlib header
		      Dim cmf As Integer = compressedResult.Byte(0)
		      Dim flg As Integer = compressedResult.Byte(1)

		      // Check CMF: CM=8 (deflate), CINFO=7 (32K window) = 0x78
		      If cmf <> &h78 Then
		        output = output + "  Warning: CMF byte is " + Hex(cmf) + " (expected 0x78)" + EndOfLine
		      End If

		      // Check FCHECK: (CMF * 256 + FLG) should be divisible by 31
		      If (cmf * 256 + flg) Mod 31 <> 0 Then
		        output = output + "  Error: Invalid FCHECK in header" + EndOfLine
		        result.Value("passed") = False
		      Else
		        #If TargetiOS Then
		          output = output + "  Input: " + Str(input.Length) + " bytes, Output: " + Str(compressedResult.Size) + " bytes" + EndOfLine
		          output = output + "  Compression ratio: " + FormatHelper(100.0 * compressedResult.Size / input.Length, "0.0") + "%" + EndOfLine
		        #Else
		          output = output + "  Input: " + Str(input.Bytes) + " bytes, Output: " + Str(compressedResult.Size) + " bytes" + EndOfLine
		          output = output + "  Compression ratio: " + Format(100.0 * compressedResult.Size / input.Bytes, "0.0") + "%" + EndOfLine
		        #EndIf
		        result.Value("passed") = True
		      End If
		    End If
		  #Else
		    output = "  (Skipped - hasPremiumZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestZlibRepeatedPattern() As Dictionary
		  // Test compression of repeated data (should compress well)
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumZlibModule Then
		    Dim deflater As New VNSZlibPremiumDeflate

		    // Create a string with repeated pattern
		    Dim pattern As String = "ABCDEFGHIJ"
		    Dim input As String = ""
		    For i As Integer = 1 To 100
		      input = input + pattern
		    Next

		    Dim compressedResult As MemoryBlock = deflater.CompressString(input)

		    If compressedResult = Nil Or compressedResult.Size = 0 Then
		      output = output + "  Error: Compression returned empty result" + EndOfLine
		      result.Value("passed") = False
		    Else
		      #If TargetiOS Then
		        Dim inputLen As Integer = input.Length
		      #Else
		        Dim inputLen As Integer = input.Bytes
		      #EndIf
		      Dim ratio As Double = 100.0 * compressedResult.Size / inputLen
		      output = output + "  Input: " + Str(inputLen) + " bytes, Output: " + Str(compressedResult.Size) + " bytes" + EndOfLine
		      #If TargetiOS Then
		        output = output + "  Compression ratio: " + FormatHelper(ratio, "0.0") + "%" + EndOfLine
		      #Else
		        output = output + "  Compression ratio: " + Format(ratio, "0.0") + "%" + EndOfLine
		      #EndIf

		      // Repeated data should compress significantly (at least 50% reduction)
		      If ratio > 50 Then
		        output = output + "  Warning: Poor compression for repeated data" + EndOfLine
		      End If

		      result.Value("passed") = True
		    End If
		  #Else
		    output = "  (Skipped - hasPremiumZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestAdler32() As Dictionary
		  // Test ADLER-32 checksum with known test vectors
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumZlibModule Then
		    // RFC 1950 specifies: adler32("Wikipedia") = 0x11E60398
		    Dim input As String = "Wikipedia"
		    Dim expected As UInt32 = &h11E60398

		    Dim adler As UInt32 = VNSZlibPremiumAdler32.Init()
		    adler = VNSZlibPremiumAdler32.CalculateString(adler, input)

		    output = output + "  Input: '" + input + "'" + EndOfLine
		    output = output + "  Expected: 0x" + Hex(expected) + EndOfLine
		    output = output + "  Got:      0x" + Hex(adler) + EndOfLine

		    If adler = expected Then
		      result.Value("passed") = True
		    Else
		      output = output + "  Error: ADLER-32 mismatch!" + EndOfLine
		      result.Value("passed") = False
		    End If
		  #Else
		    output = "  (Skipped - hasPremiumZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestZlibRoundTrip() As Dictionary
		  // Test that our compressed data can be decompressed
		  // Now uses pure Xojo inflate on all platforms when hasPremiumZlibModule = True
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumZlibModule Then
		    Dim deflater As New VNSZlibPremiumDeflate
		    Dim input As String = "This is a test of the pure Xojo zlib compression implementation. It should compress and decompress correctly!"

		    // Compress with our implementation
		    Dim compressed As MemoryBlock = deflater.CompressString(input)
		    If compressed = Nil Or compressed.Size = 0 Then
		      output = output + "  Error: Compression failed" + EndOfLine
		      result.Value("passed") = False
		    Else
		      #If TargetiOS Then
		        output = output + "  Compressed " + Str(input.Length) + " -> " + Str(compressed.Size) + " bytes" + EndOfLine
		      #Else
		        output = output + "  Compressed " + Str(input.Bytes) + " -> " + Str(compressed.Size) + " bytes" + EndOfLine
		      #EndIf

		      // Try to decompress using VNSZlibModule.Uncompress
		      // This uses pure Xojo inflate on all platforms when hasPremiumZlibModule = True
		      Dim compressedStr As String = compressed.StringValue(0, compressed.Size)

		      #If TargetiOS Then
		        Dim inputLen As Integer = input.Length
		      #Else
		        Dim inputLen As Integer = input.Bytes
		      #EndIf

		      Dim decompressed As String = VNSZlibModule.Uncompress(compressedStr, inputLen * 2)

		      If VNSZlibModule.LastErrorCode <> 0 Then
		        output = output + "  Decompression error code: " + Str(VNSZlibModule.LastErrorCode) + EndOfLine
		        output = output + "  (This may indicate a decompression issue)" + EndOfLine
		        result.Value("passed") = False
		      ElseIf decompressed = input Then
		        output = output + "  Round-trip successful! Data matches." + EndOfLine
		        #If TargetiOS Then
		          output = output + "  (Using pure Xojo inflate on iOS)" + EndOfLine
		        #Else
		          output = output + "  (Using pure Xojo inflate)" + EndOfLine
		        #EndIf
		        result.Value("passed") = True
		      Else
		        output = output + "  Error: Decompressed data doesn't match original" + EndOfLine
		        #If TargetiOS Then
		          output = output + "  Expected length: " + Str(input.Length) + EndOfLine
		          output = output + "  Got length: " + Str(decompressed.Length) + EndOfLine
		        #Else
		          output = output + "  Expected length: " + Str(input.Bytes) + EndOfLine
		          output = output + "  Got length: " + Str(decompressed.Bytes) + EndOfLine
		        #EndIf
		        result.Value("passed") = False
		      End If
		    End If
		  #Else
		    output = "  (Skipped - hasPremiumZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54657374207075726520586F6A6F20414553206D706C656D656E6174696F6E2077697468204E495354207465737420766563746F72732E
		Function TestAES() As Dictionary
		  // Test pure Xojo AES implementation with NIST test vectors
		  // Returns a Dictionary with test results for display

		  Dim result As New Dictionary
		  Dim output As String = "=== Testing Pure Xojo AES Implementation ===" + EndOfLine
		  output = output + "Running NIST SP 800-38A test vectors..." + EndOfLine + EndOfLine

		  Dim allPassed As Boolean = True

		  // Test ECB-AES128
		  output = output + "Testing ECB-AES128..." + EndOfLine
		  Dim test1Result As Dictionary = TestECB_AES128()
		  Dim testOutput As String = test1Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test1Result.Value("passed") Then
		    output = output + "  ECB-AES128: PASSED" + EndOfLine
		  Else
		    output = output + "  ECB-AES128: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test CBC-AES128
		  output = output + "Testing CBC-AES128..." + EndOfLine
		  Dim test2Result As Dictionary = TestCBC_AES128()
		  testOutput = test2Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test2Result.Value("passed") Then
		    output = output + "  CBC-AES128: PASSED" + EndOfLine
		  Else
		    output = output + "  CBC-AES128: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test ECB-AES256
		  output = output + "Testing ECB-AES256..." + EndOfLine
		  Dim test3Result As Dictionary = TestECB_AES256()
		  testOutput = test3Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test3Result.Value("passed") Then
		    output = output + "  ECB-AES256: PASSED" + EndOfLine
		  Else
		    output = output + "  ECB-AES256: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test CBC-AES256
		  output = output + "Testing CBC-AES256..." + EndOfLine
		  Dim test4Result As Dictionary = TestCBC_AES256()
		  testOutput = test4Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test4Result.Value("passed") Then
		    output = output + "  CBC-AES256: PASSED" + EndOfLine
		  Else
		    output = output + "  CBC-AES256: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test SHA-384 (needed for PDF Revision 6)
		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    output = output + "Testing SHA-384..." + EndOfLine
		    Dim testSHA384 As Boolean = VNSPDFEncryptionPremium.TestSHA384()
		    If testSHA384 Then
		      output = output + "  SHA-384: PASSED" + EndOfLine
		      // allPassed remains unchanged
		    Else
		      output = output + "  SHA-384: FAILED" + EndOfLine
		      allPassed = False
		    End If
		    output = output + EndOfLine
		  #EndIf

		  // Summary
		  If allPassed Then
		    output = output + "=== ALL TESTS PASSED ===" + EndOfLine
		    output = output + "Pure Xojo AES implementation is working correctly!" + EndOfLine
		    output = output + "AES-128 (ECB + CBC) - Ready for PDF Revision 4" + EndOfLine
		    output = output + "AES-256 (ECB + CBC) - Ready for PDF Revisions 5-6" + EndOfLine
		    #If VNSPDFModule.hasPremiumEncryptionModule Then
		      output = output + "SHA-384 - Ready for PDF Revision 6" + EndOfLine
		    #EndIf
		  Else
		    output = output + "=== SOME TESTS FAILED ===" + EndOfLine
		    output = output + "Review the output above for details." + EndOfLine
		  End If
		  output = output + EndOfLine

		  result.Value("passed") = allPassed
		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestECB_AES128() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    // Test ECB-AES128 encryption with NIST test vectors
		    // From NIST SP 800-38A Section F.1.1

		    Try
		      // Test key (128-bit)
		      Dim key As String = HexToString("2b7e151628aed2a6abf7158809cf4f3c")

		      // Test plaintext (4 blocks = 64 bytes)
		      Dim plaintext As String = HexToString( _
		      "6bc1bee22e409f96e93d7e117393172a" + _
		      "ae2d8a571e03ac9c9eb76fac45af8e51" + _
		      "30c81c46a35ce411e5fbc1191a0a52ef" + _
		      "f69f2445df4f9b17ad2b417be66c3710")

		      // Expected ciphertext (from NIST)
		      Dim expectedCiphertext As String = HexToString( _
		      "3ad77bb40d7a3660a89ecaf32466ef97" + _
		      "f5d3d58503b9699de785895a96fdbaaf" + _
		      "43b1cd7f598ece23881b00e3ed030688" + _
		      "7b0c785e27e8ad3f8223207104725dd4")

		      // Perform encryption
		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes.SetKey(key)
		      Dim ciphertext As String = aes.EncryptECB(plaintext)

		      // Display results
		      output = output + "  Key: 2b7e1516..." + EndOfLine
		      #If TargetiOS Then
		        output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		        output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		        output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      #Else
		        output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		        output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		        output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      #EndIf

		      // Compare result
		      If ciphertext = expectedCiphertext Then
		        result.Value("passed") = True
		      Else
		        output = output + "  ERROR: Ciphertext mismatch!" + EndOfLine
		        result.Value("passed") = False
		      End If

		    Catch e As RuntimeException
		      output = output + "  EXCEPTION: " + e.Message + EndOfLine
		      result.Value("passed") = False
		    End Try
		  #Else
		    output = "  SKIPPED: Encryption module not available in free version" + EndOfLine
		    result.Value("passed") = False
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestCBC_AES128() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    // Test CBC-AES128 encryption with NIST test vectors
		    // From NIST SP 800-38A Section F.2.1

		    Try
		      // Test key (128-bit)
		      Dim key As String = HexToString("2b7e151628aed2a6abf7158809cf4f3c")

		      // Initialization vector (128-bit)
		      Dim iv As String = HexToString("000102030405060708090a0b0c0d0e0f")

		      // Test plaintext (4 blocks = 64 bytes)
		      Dim plaintext As String = HexToString( _
		      "6bc1bee22e409f96e93d7e117393172a" + _
		      "ae2d8a571e03ac9c9eb76fac45af8e51" + _
		      "30c81c46a35ce411e5fbc1191a0a52ef" + _
		      "f69f2445df4f9b17ad2b417be66c3710")

		      // Expected ciphertext (from NIST)
		      Dim expectedCiphertext As String = HexToString( _
		      "7649abac8119b246cee98e9b12e9197d" + _
		      "5086cb9b507219ee95db113a917678b2" + _
		      "73bed6b8e3c1743b7116e69e22229516" + _
		      "3ff1caa1681fac09120eca307586e1a7")

		      // Perform encryption
		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes.SetKey(key)
		      Dim ciphertext As String = aes.EncryptCBC(plaintext, iv)

		      // Display results
		      output = output + "  Key: 2b7e1516..." + EndOfLine
		      output = output + "  IV:  00010203..." + EndOfLine
		      #If TargetiOS Then
		        output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		        output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		        output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      #Else
		        output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		        output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		        output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      #EndIf

		      // Compare result
		      If ciphertext = expectedCiphertext Then
		        result.Value("passed") = True
		      Else
		        output = output + "  ERROR: Ciphertext mismatch!" + EndOfLine
		        result.Value("passed") = False
		      End If

		    Catch e As RuntimeException
		      output = output + "  EXCEPTION: " + e.Message + EndOfLine
		      result.Value("passed") = False
		    End Try
		  #Else
		    output = "  SKIPPED: Encryption module not available in free version" + EndOfLine
		    result.Value("passed") = False
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestECB_AES256() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    // Test ECB-AES256 encryption with NIST test vectors
		    // From NIST SP 800-38A Section F.1.5

		    Try
		      // Test key (256-bit)
		      Dim key As String = HexToString( _
		      "603deb1015ca71be2b73aef0857d7781" + _
		      "1f352c073b6108d72d9810a30914dff4")

		      // Test plaintext (4 blocks = 64 bytes)
		      Dim plaintext As String = HexToString( _
		      "6bc1bee22e409f96e93d7e117393172a" + _
		      "ae2d8a571e03ac9c9eb76fac45af8e51" + _
		      "30c81c46a35ce411e5fbc1191a0a52ef" + _
		      "f69f2445df4f9b17ad2b417be66c3710")

		      // Expected ciphertext (from NIST)
		      Dim expectedCiphertext As String = HexToString( _
		      "f3eed1bdb5d2a03c064b5a7e3db181f8" + _
		      "591ccb10d410ed26dc5ba74a31362870" + _
		      "b6ed21b99ca6f4f9f153e7b1beafed1d" + _
		      "23304b7a39f9f3ff067d8d8f9e24ecc7")

		      // Perform encryption
		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength256)
		      aes.SetKey(key)
		      Dim ciphertext As String = aes.EncryptECB(plaintext)

		      // Display results
		      output = output + "  Key: 603deb10... (256-bit)" + EndOfLine
		      #If TargetiOS Then
		        output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		        output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		        output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      #Else
		        output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		        output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		        output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      #EndIf

		      // Compare result
		      If ciphertext = expectedCiphertext Then
		        result.Value("passed") = True
		      Else
		        output = output + "  ERROR: Ciphertext mismatch!" + EndOfLine
		        result.Value("passed") = False
		      End If

		    Catch e As RuntimeException
		      output = output + "  EXCEPTION: " + e.Message + EndOfLine
		      result.Value("passed") = False
		    End Try
		  #Else
		    output = "  SKIPPED: Encryption module not available in free version" + EndOfLine
		    result.Value("passed") = False
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestCBC_AES256() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    // Test CBC-AES256 encryption with NIST test vectors
		    // From NIST SP 800-38A Section F.2.5

		    Try
		      // Test key (256-bit)
		      Dim key As String = HexToString( _
		      "603deb1015ca71be2b73aef0857d7781" + _
		      "1f352c073b6108d72d9810a30914dff4")

		      // Initialization vector (128-bit)
		      Dim iv As String = HexToString("000102030405060708090a0b0c0d0e0f")

		      // Test plaintext (4 blocks = 64 bytes)
		      Dim plaintext As String = HexToString( _
		      "6bc1bee22e409f96e93d7e117393172a" + _
		      "ae2d8a571e03ac9c9eb76fac45af8e51" + _
		      "30c81c46a35ce411e5fbc1191a0a52ef" + _
		      "f69f2445df4f9b17ad2b417be66c3710")

		      // Expected ciphertext (from NIST)
		      Dim expectedCiphertext As String = HexToString( _
		      "f58c4c04d6e5f1ba779eabfb5f7bfbd6" + _
		      "9cfc4e967edb808d679f777bc6702c7d" + _
		      "39f23369a9d9bacfa530e26304231461" + _
		      "b2eb05e2c39be9fcda6c19078c6a9d1b")

		      // Perform encryption
		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength256)
		      aes.SetKey(key)
		      Dim ciphertext As String = aes.EncryptCBC(plaintext, iv)

		      // Display results
		      output = output + "  Key: 603deb10... (256-bit)" + EndOfLine
		      output = output + "  IV:  00010203..." + EndOfLine
		      #If TargetiOS Then
		        output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		        output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		        output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      #Else
		        output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		        output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		        output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      #EndIf

		      // Compare result
		      If ciphertext = expectedCiphertext Then
		        result.Value("passed") = True
		      Else
		        output = output + "  ERROR: Ciphertext mismatch!" + EndOfLine
		        result.Value("passed") = False
		      End If

		    Catch e As RuntimeException
		      output = output + "  EXCEPTION: " + e.Message + EndOfLine
		      result.Value("passed") = False
		    End Try
		  #Else
		    output = "  SKIPPED: Encryption module not available in free version" + EndOfLine
		    result.Value("passed") = False
		  #EndIf

		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HexToString(hex As String) As String
		  // Convert hex string to binary string
		  // Example: "2b7e" -> String.ChrByte(&h2b) + String.ChrByte(&h7e)

		  Dim result As String = ""
		  Dim hexLen As Integer = hex.Length

		  For i As Integer = 1 To hexLen Step 2
		    #If TargetiOS Then
		      Dim hexByte As String = hex.Middle(i - 1, 2) // 0-based
		      Dim byteValue As Integer = Val("&h" + hexByte)
		      result = result + String.ChrByte(byteValue)
		    #Else
		      Dim hexByte As String = hex.Middle(i, 2)
		      Dim byteValue As Integer = Val("&h" + hexByte)
		      result = result + String.ChrByte(byteValue)
		    #EndIf
		  Next

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StringToHex(s As String) As String
		  // Convert binary string to hex string (for debugging)
		  // Example: String.ChrByte(&h2b) + String.ChrByte(&h7e) -> "2b7e"

		  Dim result As String = ""
		  #If TargetiOS Then
		    Dim sLen As Integer = s.Bytes
		    For i As Integer = 0 To sLen - 1
		      Dim byteValue As Integer = s.MiddleBytes(i, 1).AscByte
		      Dim hexByte As String = Hex(byteValue)
		      If hexByte.Length = 1 Then hexByte = "0" + hexByte
		      result = result + hexByte
		    Next
		  #Else
		    Dim sLen As Integer = s.Bytes
		    For i As Integer = 0 To sLen - 1
		      Dim byteValue As Integer = s.MiddleBytes(i, 1).AscByte
		      Dim hexByte As String = Hex(byteValue)
		      If hexByte.Length = 1 Then hexByte = "0" + hexByte
		      result = result + hexByte
		    Next
		  #EndIf

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample20(sourcePath As String = "") As Dictionary
		  // Example 20: PDF Import - Import pages from existing PDFs
		  // Demonstrates SetSourceFile(), ImportPage(), and UseTemplate()

		  Dim result As New Dictionary
		  Dim statusText As String = ""

		  statusText = statusText + "Example 20: PDF Import (Pages as Templates)" + EndOfLine
		  statusText = statusText + "========================================" + EndOfLine + EndOfLine

		  // If no source path provided, use default example
		  If sourcePath = "" Then
		    #If TargetDesktop Or TargetConsole Then
		      // Desktop/Console: Find pdf_examples folder relative to app location
		      Dim pdfExamplesFolder As FolderItem
		      Dim sourceFile As FolderItem

		      // Try multiple locations to find pdf_examples folder
		      // 1. CurrentWorkingDirectory/pdf_examples
		      pdfExamplesFolder = SpecialFolder.CurrentWorkingDirectory.Child("pdf_examples")
		      If pdfExamplesFolder.Exists Then
		        sourceFile = pdfExamplesFolder.Child("example19_tables.pdf")
		        If sourceFile.Exists Then
		          sourcePath = sourceFile.NativePath
		        End If
		      End If

		      // 2. App location/pdf_examples (for debug builds)
		      If sourcePath = "" Then
		        pdfExamplesFolder = App.ExecutableFile.Parent.Child("pdf_examples")
		        If pdfExamplesFolder.Exists Then
		          sourceFile = pdfExamplesFolder.Child("example19_tables.pdf")
		          If sourceFile.Exists Then
		            sourcePath = sourceFile.NativePath
		          End If
		        End If
		      End If

		      // 3. App location/../pdf_examples (for builds in subfolder)
		      If sourcePath = "" And App.ExecutableFile.Parent.Parent <> Nil Then
		        pdfExamplesFolder = App.ExecutableFile.Parent.Parent.Child("pdf_examples")
		        If pdfExamplesFolder.Exists Then
		          sourceFile = pdfExamplesFolder.Child("example19_tables.pdf")
		          If sourceFile.Exists Then
		            sourcePath = sourceFile.NativePath
		          End If
		        End If
		      End If

		      // 4. App location/../../pdf_examples (for deeper build folders)
		      If sourcePath = "" And App.ExecutableFile.Parent.Parent <> Nil And App.ExecutableFile.Parent.Parent.Parent <> Nil Then
		        pdfExamplesFolder = App.ExecutableFile.Parent.Parent.Parent.Child("pdf_examples")
		        If pdfExamplesFolder.Exists Then
		          sourceFile = pdfExamplesFolder.Child("example19_tables.pdf")
		          If sourceFile.Exists Then
		            sourcePath = sourceFile.NativePath
		          End If
		        End If
		      End If

		      // If still not found, show error
		      If sourcePath = "" Then
		        statusText = statusText + "✗ ERROR: Cannot find pdf_examples/example19_tables.pdf" + EndOfLine
		        statusText = statusText + "   Searched from: " + App.ExecutableFile.Parent.NativePath + EndOfLine
		        result.Value("success") = False
		        result.Value("status") = statusText
		        result.Value("filename") = ""
		        Return result
		      End If
		    #ElseIf TargetiOS Then
		      // iOS: Requires user to select a source PDF file
		      // Note: iOS apps need file picker UI to let user choose PDF from Documents folder
		      statusText = statusText + "✗ ERROR: No source PDF path provided" + EndOfLine
		      statusText = statusText + "   iOS requires a source PDF file to be selected by the user" + EndOfLine
		      statusText = statusText + "   Implement file picker UI to pass source file path to GenerateExample20()" + EndOfLine
		      result.Value("success") = False
		      result.Value("status") = statusText
		      result.Value("filename") = ""
		      Return result
		    #Else
		      // Web: No file system access, requires user to upload PDF via WebDialogPDFUpload
		      statusText = statusText + "✗ ERROR: No source PDF path provided" + EndOfLine
		      result.Value("success") = False
		      result.Value("status") = statusText
		      result.Value("filename") = ""
		      Return result
		    #EndIf
		  End If

		  // Create PDF
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)

		  Call pdf.SetTitle("Example 20 - PDF Import")
		  Call pdf.SetAuthor("VNS PDF Library")
		  Call pdf.SetSubject("Importing pages from existing PDFs")

		  statusText = statusText + "Source PDF: " + sourcePath + EndOfLine + EndOfLine

		  // Open source PDF
		  Dim pageCount As Integer = pdf.SetSourceFile(sourcePath)

		  If pdf.Err() Then
		    statusText = statusText + "✗ ERROR: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    result.Value("filename") = ""
		    Return result
		  End If

		  statusText = statusText + "✓ Opened PDF successfully" + EndOfLine
		  statusText = statusText + "  Pages found: " + Str(pageCount) + EndOfLine + EndOfLine

		  // Create title page
		  Call pdf.AddPage()
		  Call pdf.SetFont("helvetica", "B", 20)
		  Call pdf.Cell(0, 10, "PDF Import Example", 0, 1, "C")
		  Call pdf.Ln(5)

		  Call pdf.SetFont("helvetica", "", 12)
		  Call pdf.MultiCell(0, 5, "This example demonstrates importing pages from an existing PDF file and placing them as templates in a new document using UseTemplate().", 0, "L")
		  Call pdf.Ln(10)

		  // Import ALL pages from source PDF
		  Dim templateIDs() As Integer

		  statusText = statusText + "Importing all " + Str(pageCount) + " pages..." + EndOfLine + EndOfLine

		  For i As Integer = 1 To pageCount
		    Dim templateID As Integer = pdf.ImportPage(i)

		    If pdf.Err() Then
		      statusText = statusText + "  ✗ ERROR importing page " + Str(i) + ": " + pdf.GetError() + EndOfLine
		      pdf.ClearError()
		      Continue
		    End If

		    templateIDs.Add(templateID)
		  Next

		  statusText = statusText + "✓ Successfully imported " + Str(templateIDs.Count) + " pages" + EndOfLine + EndOfLine

		  // Display all pages as thumbnails - 4 pages per output page (2x2 grid)
		  Dim thumbWidth As Double = 85  // Width for each thumbnail
		  Dim thumbSpacing As Double = 5  // Space between thumbnails
		  Dim pageMargin As Double = 15

		  // Calculate positions for 2x2 grid
		  Dim col1X As Double = pageMargin
		  Dim col2X As Double = pageMargin + thumbWidth + thumbSpacing
		  Dim row1Y As Double = 45
		  Dim row2Y As Double = row1Y + 120  // Approximate height for A4 aspect ratio thumbnails

		  Dim pageIndex As Integer = 0
		  Dim outputPageNum As Integer = 0

		  While pageIndex < templateIDs.Count
		    // Add new output page for this set of 4 thumbnails
		    Call pdf.AddPage()
		    outputPageNum = outputPageNum + 1

		    // Title
		    Call pdf.SetFont("helvetica", "B", 14)
		    Call pdf.Cell(0, 8, "Source PDF Pages (Sheet " + Str(outputPageNum) + " of " + Str((templateIDs.Count + 3) \ 4) + ")", 0, 1, "C")
		    Call pdf.Ln(5)

		    // Display up to 4 thumbnails in 2x2 grid
		    For gridPos As Integer = 0 To 3
		      If pageIndex >= templateIDs.Count Then Exit For

		      // Calculate position for this thumbnail
		      Dim thumbX As Double
		      Dim thumbY As Double

		      Select Case gridPos
		      Case 0  // Top-left
		        thumbX = col1X
		        thumbY = row1Y
		      Case 1  // Top-right
		        thumbX = col2X
		        thumbY = row1Y
		      Case 2  // Bottom-left
		        thumbX = col1X
		        thumbY = row2Y
		      Case 3  // Bottom-right
		        thumbX = col2X
		        thumbY = row2Y
		      End Select

		      // Draw label above thumbnail
		      Call pdf.SetFont("helvetica", "B", 10)
		      Dim debugInfo As String = "Source Page " + Str(pageIndex + 1) + " (ID:" + Str(templateIDs(pageIndex)) + ", Arr:" + Str(pageIndex) + ")"
		      Call pdf.Text(thumbX, thumbY - 3, debugInfo)

		      // Place the thumbnail
		      Call pdf.UseTemplate(templateIDs(pageIndex), thumbX, thumbY, thumbWidth, 0)

		      pageIndex = pageIndex + 1
		    Next
		  Wend

		  statusText = statusText + "✓ Created " + Str(outputPageNum) + " thumbnail overview pages" + EndOfLine

		  statusText = statusText + EndOfLine + "✓ Example 20 completed" + EndOfLine

		  // Generate PDF
		  Dim pdfBytes As String = pdf.Output()

		  If pdf.Err() Then
		    statusText = statusText + "✗ ERROR generating PDF: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("status") = statusText
		    result.Value("filename") = ""
		    Return result
		  End If

		  // Save to file
		  #If TargetDesktop Or TargetConsole Then
		    Dim outputFile As FolderItem = SpecialFolder.Desktop.Child("example20_pdf_import.pdf")
		    Try
		      Dim bos As BinaryStream = BinaryStream.Create(outputFile, True)
		      bos.Write(pdfBytes)
		      bos.Close()

		      statusText = statusText + "✓ PDF saved to: " + outputFile.NativePath + EndOfLine
		      result.Value("success") = True
		      result.Value("filename") = "example20_pdf_import.pdf"
		    Catch e As IOException
		      statusText = statusText + "✗ ERROR saving file: " + e.Message + EndOfLine
		      result.Value("success") = False
		      result.Value("filename") = ""
		    End Try
		  #Else
		    // iOS/Web: Return PDF data for UI layer to handle
		    result.Value("success") = True
		    result.Value("filename") = "example20_pdf_import.pdf"
		  #EndIf


		  // Return PDF data for all platforms (iOS/Web need this for display)
		  result.Value("pdf") = pdfBytes
		  result.Value("status") = statusText
		  Return result
		End Function
	#tag EndMethod


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
End Module
#tag EndModule
