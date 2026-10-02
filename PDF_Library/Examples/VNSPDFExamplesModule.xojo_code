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
		  // Demonstrates ALL 18 transformation methods with 10 visual examples

		  // Save current state
		  Dim savedFontFamily As String = doc.FontFamily
		  Dim savedFontStyle As String = doc.FontStyle
		  Dim savedFontSize As Double = doc.FontSizePt

		  // Calculate center of A4 page (210mm x 297mm)
		  Dim centerX As Double = 105.0
		  Dim centerY As Double = 148.5

		  // Example 1: ROTATED watermark (center diagonal)
		  doc.SetFont("Helvetica", "B", 50)
		  doc.SetTextColor(220, 220, 220) // Very light gray
		  doc.SetAlpha(0.3, "Normal")

		  doc.TransformBegin()
		  doc.TransformRotate(45, centerX, centerY) // 45° rotation
		  doc.Text(60, 150, "DRAFT")
		  doc.TransformEnd()

		  // Example 2: SCALED watermark (top left - 150% size)
		  doc.SetFont("Helvetica", "B", 20)
		  doc.SetTextColor(200, 220, 255) // Light blue
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformScale(150, 150, 30, 40) // Scale 150% at position
		  doc.Text(20, 40, "SCALED")
		  doc.TransformEnd()

		  // Example 3: SKEWED watermark (top right - italic effect)
		  doc.SetFont("Helvetica", "B", 20)
		  doc.SetTextColor(255, 220, 200) // Light orange
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformSkewX(15, 160, 40) // 15° skew creates italic effect
		  doc.Text(150, 40, "SKEWED")
		  doc.TransformEnd()

		  // Example 4: TRANSLATED watermark (bottom left)
		  doc.SetFont("Helvetica", "B", 20)
		  doc.SetTextColor(220, 255, 200) // Light green
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformTranslate(10, 5) // Shift 10mm right, 5mm down
		  doc.Text(10, 270, "MOVED")
		  doc.TransformEnd()

		  // Example 5: COMBINED transformations (bottom right - rotated + scaled)
		  doc.SetFont("Helvetica", "B", 15)
		  doc.SetTextColor(255, 200, 255) // Light purple
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformRotate(-15, 170, 270) // Rotate -15°
		  doc.TransformScale(120, 120, 170, 270) // Scale 120%
		  doc.Text(155, 270, "COMBO")
		  doc.TransformEnd()

		  // Example 6: Condensed text (scale X only - bottom center)
		  doc.SetFont("Helvetica", "B", 20)
		  doc.SetTextColor(255, 255, 200) // Light yellow
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformScaleX(70, 85, 270) // Condense to 70% width
		  doc.Text(60, 270, "CONDENSED")
		  doc.TransformEnd()

		  // Example 7: MIRROR HORIZONTAL (left side - flipped horizontally)
		  doc.SetFont("Helvetica", "B", 18)
		  doc.SetTextColor(200, 255, 255) // Light cyan
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformMirrorHorizontal(30) // Mirror at X=30
		  doc.Text(20, 100, "H-MIRROR")
		  doc.TransformEnd()

		  // Example 8: MIRROR VERTICAL (right side - flipped vertically)
		  doc.SetFont("Helvetica", "B", 18)
		  doc.SetTextColor(255, 200, 255) // Light magenta
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformMirrorVertical(100) // Mirror at Y=100
		  doc.Text(170, 90, "V-FLIP")
		  doc.TransformEnd()

		  // Example 9: MIRROR POINT (middle - 180° flip)
		  doc.SetFont("Helvetica", "B", 18)
		  doc.SetTextColor(255, 230, 200) // Light peach
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformMirrorPoint(centerX, centerY) // Mirror at page center
		  doc.Text(95, 140, "180°")
		  doc.TransformEnd()

		  // Example 10: MIRROR LINE (diagonal mirror along 30° line)
		  doc.SetFont("Helvetica", "B", 18)
		  doc.SetTextColor(230, 255, 200) // Light lime
		  doc.SetAlpha(0.25, "Normal")

		  doc.TransformBegin()
		  doc.TransformMirrorLine(30, 50, 200) // Mirror along 30° line through (50, 200)
		  doc.Text(40, 200, "LINE-30°")
		  doc.TransformEnd()

		  // Reset transparency and colors
		  doc.SetAlpha(1.0, "Normal")
		  doc.SetTextColor(0, 0, 0)

		  // Restore previous font
		  doc.SetFont(savedFontFamily, savedFontStyle, savedFontSize)

		  // Note: Because homeMode = True, the X/Y position will be automatically
		  // reset to top-left margins, so content starts at expected position
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320696E737472756374696F6E7320666F7220656E61626C696E672070726D69756D206D6F64756C65732E
		Private Function GetPremiumEnablingInstructions(constantNames() As String) As String
		  // Returns standardized instructions for enabling premium modules
		  // constantNames: array of constant names to enable (e.g., "hasPremiumVNSEncryptionModule")

		  Dim kInstructionHeader As String = "ENABLING PREMIUM MODULE"
		  If constantNames.LastIndex > 0 Then kInstructionHeader = kInstructionHeader + "S"
		  kInstructionHeader = kInstructionHeader + ":"

		  Dim txt As String = kInstructionHeader + EndOfLine
		  txt = txt + "========================" + EndOfLine
		  txt = txt + "1. Open your project's Premium Constants module" + EndOfLine
		  txt = txt + "   (e.g. Xojo_fpdf_premium_Premium_Constants.xojo_code)" + EndOfLine

		  For i As Integer = 0 To constantNames.LastIndex
		    txt = txt + Str(i + 2) + ". Set " + constantNames(i) + " = True" + EndOfLine
		  Next

		  txt = txt + Str(constantNames.LastIndex + 3) + ". Rebuild your project" + EndOfLine

		  Return txt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d2048544d4c207461672068616e646c657220666f7220636f6d70616e792d6865616465722e2052656e64657273206c61726765206e6176792d626c756520626f6c642068656164696e672e
		Private Sub HandleCompanyHeader(doc As VNSPDFDocument, token As Object, isClosing As Boolean)
		  If Not isClosing Then
		    // Opening: set large navy-blue bold font
		    // Text content between open/close tags will be rendered by the normal text pipeline
		    doc.Ln(4)
		    doc.SetFont("Helvetica", "B", 20)
		    doc.SetTextColor(0, 0, 128)
		  Else
		    // Closing: restore normal formatting
		    doc.Ln(8)
		    doc.SetFont("Helvetica", "", 11)
		    doc.SetTextColor(0, 0, 0)
		  End If
		  #Pragma Unused token
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d2048544d4c207461672068616e646c657220666f7220616c6572742d626f782e2052656e6465727320636f6c6f72656420616c65727420776974682074797065206174747269627574652e
		Private Sub HandleAlertBox(doc As VNSPDFDocument, token As Object, isClosing As Boolean)
		  If Not isClosing Then
		    // Opening: set colored text and write prefix based on type attribute
		    // Text content between open/close tags will be rendered by the normal text pipeline
		    Dim alertType As String = ""
		    #If hasPremiumVNSHTMLModule Then
		      Dim htmlToken As VNSPDFHTMLToken = VNSPDFHTMLToken(token)
		      If htmlToken.TagAttributes <> Nil And htmlToken.TagAttributes.HasKey("type") Then
		        alertType = htmlToken.TagAttributes.Value("type")
		      End If
		    #EndIf

		    Dim prefix As String
		    Select Case alertType
		    Case "warning"
		      doc.SetTextColor(133, 100, 4)
		      prefix = "WARNING: "
		    Case "error"
		      doc.SetTextColor(114, 28, 36)
		      prefix = "ERROR: "
		    Case "info"
		      doc.SetTextColor(12, 84, 96)
		      prefix = "INFO: "
		    Else
		      doc.SetTextColor(80, 80, 80)
		      prefix = "NOTE: "
		    End Select

		    doc.Ln(3)
		    doc.SetFont("Helvetica", "B", 10)
		    doc.Write(5, prefix)
		    doc.SetFont("Helvetica", "", 10)
		  Else
		    // Closing: restore normal formatting
		    doc.Ln(5)
		    doc.SetFont("Helvetica", "", 11)
		    doc.SetTextColor(0, 0, 0)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d2048544d4c207461672068616e646c657220666f7220706167652d627265616b2e20466f726365732061206e65772050444620706167652e
		Private Sub HandlePageBreak(doc As VNSPDFDocument, token As Object, isClosing As Boolean)
		  // Self-closing tag: force a new page
		  If Not isClosing Then
		    doc.AddPage
		  End If
		  #Pragma Unused token
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d2048544d4c207461672068616e646c657220666f7220686967686c696768742e2052656e64657273207465787420776974682079656c6c6f77206261636b67726f756e642e
		Private Sub HandleHighlight(doc As VNSPDFDocument, token As Object, isClosing As Boolean)
		  If Not isClosing Then
		    // Opening: set yellow fill for background highlight effect
		    doc.SetFillColor(255, 255, 0)
		    doc.SetFont("Helvetica", "B", doc.FontSizePt)
		  Else
		    // Closing: restore normal
		    doc.SetFillColor(255, 255, 255)
		    doc.SetFont("Helvetica", "", doc.FontSizePt)
		  End If
		  #Pragma Unused token
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d2048544d4c207461672068616e646c657220666f72207369676e61747572652d6c696e652e2052656e64657273207369676e6174757265206c696e652077697468206c6162656c2e
		Private Sub HandleSignatureLine(doc As VNSPDFDocument, token As Object, isClosing As Boolean)
		  // Self-closing tag: render a signature line with label
		  If Not isClosing Then
		    Dim label As String = ""
		    #If hasPremiumVNSHTMLModule Then
		      Dim htmlToken As VNSPDFHTMLToken = VNSPDFHTMLToken(token)
		      If htmlToken.TagAttributes <> Nil And htmlToken.TagAttributes.HasKey("label") Then
		        label = htmlToken.TagAttributes.Value("label")
		      End If
		    #EndIf

		    doc.Ln(10)
		    Dim leftM As Double
		    Dim topM As Double
		    Dim rightM As Double
		    Dim bottomM As Double
		    doc.GetMargins(leftM, topM, rightM, bottomM)
		    Dim x As Double = doc.GetX
		    Dim y As Double = doc.GetY
		    Dim lineW As Double = 60.0
		    doc.SetDrawColor(0, 0, 0)
		    doc.SetLineWidth(0.3)
		    doc.Line(x, y, x + lineW, y)
		    doc.Ln(1)
		    doc.SetFont("Helvetica", "I", 8)
		    doc.SetTextColor(100, 100, 100)
		    doc.Cell(lineW, 4, label, "", 1, "L", False)
		    doc.SetFont("Helvetica", "", 11)
		    doc.SetTextColor(0, 0, 0)
		    doc.Ln(3)

		    #Pragma Unused leftM
		    #Pragma Unused topM
		    #Pragma Unused rightM
		    #Pragma Unused bottomM
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d204d61726b646f776e2068616e646c657220666f72203a3a3a7761726e696e67207072656669782e2052657475726e732079656c6c6f77207761726e696e672048544d4c20626c6f636b2e
		Private Function HandleMdWarning(doc As VNSPDFDocument, line As String) As String
		  // :::warning <text> -> yellow warning box HTML
		  Dim text As String = line.Middle(10).Trim
		  #Pragma Unused doc
		  Return "<p style=""color:#856404""><b>WARNING:</b> " + text + "</p>"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d204d61726b646f776e2068616e646c657220666f72203a3a3a696e666f207072656669782e2052657475726e7320626c756520696e666f2048544d4c20626c6f636b2e
		Private Function HandleMdInfo(doc As VNSPDFDocument, line As String) As String
		  // :::info <text> -> blue info box HTML
		  Dim text As String = line.Middle(7).Trim
		  #Pragma Unused doc
		  Return "<p style=""color:#0c5460""><b>INFO:</b> " + text + "</p>"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d204d61726b646f776e2068616e646c657220666f72203a3a3a6572726f72207072656669782e2052657475726e7320726564206572726f722048544d4c20626c6f636b2e
		Private Function HandleMdError(doc As VNSPDFDocument, line As String) As String
		  // :::error <text> -> red error box HTML
		  Dim text As String = line.Middle(8).Trim
		  #Pragma Unused doc
		  Return "<p style=""color:#721c24""><b>ERROR:</b> " + text + "</p>"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d204d61726b646f776e2068616e646c657220666f72207661726961626c6520737562737469747574696f6e2e2052657475726e73207265736f6c766564207661726961626c652076616c75652e
		Private Function HandleMdVariable(doc As VNSPDFDocument, line As String) As String
		  #Pragma Unused doc
		  // {{var:variable_name}} -> resolved variable value
		  // Extract variable name between {{var: and }}
		  Dim varName As String = ""
		  Dim startPos As Integer = line.IndexOf("{{var:")
		  If startPos >= 0 Then
		    Dim endPos As Integer = line.IndexOf(startPos, "}}")
		    If endPos > startPos Then
		      varName = line.Middle(startPos + 6, endPos - startPos - 6)
		    End If
		  End If

		  Select Case varName
		  Case "company_name"
		    Return "<b>VNS PDF Library</b>"
		  Case "company_address"
		    Return "<i>123 Innovation Street, Tech City</i>"
		  Case "current_year"
		    Return "<b>2026</b>"
		  Case "contact_email"
		    Return "<a href=""mailto:support@example.com"">support@example.com</a>"
		  Else
		    Return "<i>[Unknown variable: " + varName + "]</i>"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d204d61726b646f776e2068616e646c657220666f72204040706167652d627265616b2e2052657475726e73207061676520627265616b206d61726b65722e
		Private Function HandleMdPageBreak(doc As VNSPDFDocument, line As String) As String
		  // @@page-break -> add a new page directly
		  doc.AddPage
		  #Pragma Unused line
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437573746f6d204d61726b646f776e2068616e646c657220666f72203d3d3d20747269706c6520657175616c732e2052657475726e7320637573746f6d20686f72697a6f6e74616c2072756c652e
		Private Function HandleMdHRule(doc As VNSPDFDocument, line As String) As String
		  // === -> custom double-line horizontal rule
		  #Pragma Unused doc
		  #Pragma Unused line
		  Return "<hr><hr>"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 43726F73732D706C6174666F726D206E756D62657220666F726D617474696E67
		Private Function FormatHelper(value As Double, formatStr As String) As String
		  // Cross-platform number formatting
		  #If TargetiOS Or TargetAndroid Then
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
		    // Create PDF document (first page added automatically)
		    Dim pdf As New VNSPDFDocument()

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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		  
		  result.Value("message") = statusText
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
		    // Use Custom format (no auto-page) so we can set header/footer callbacks first
		    Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.Custom)

		    // Set document metadata using Xojo-compatible property syntax
		    pdf.Title = "Header/Footer Example"
		    pdf.Author = "Xojo FPDF"
		    pdf.Subject = "Demonstrating header/footer callbacks with page count and last page indicator"

		    // Enable page count substitution with "{nb}" alias
		    pdf.AliasNbPages("{nb}")

		    // Set header and footer callbacks
		    // Using SetFooterFuncLpi() instead of SetFooterFunc() to get lastPage indicator
		    pdf.SetHeaderFunc(AddressOf Example10Header)
		    pdf.SetFooterFuncLpi(AddressOf Example10FooterLpi)

		    // Add first page with A4 dimensions (210 x 297 mm)
		    pdf.AddPageFormat("P", 210, 297)
		    pdf.SetFont("Times", "", 12)
		    pdf.SetY(30) // Move below header
		    
		    // Add some content
		    Dim i As Integer
		    For i = 1 To 30
		      pdf.Cell(0, 10, "This is line " + Str(i) + " of content on the page.", 0, 1)
		    Next
		    
		    // Add second page to demonstrate header/footer on multiple pages
		    pdf.AddPage()
		    pdf.SetY(30) // Move below header
		    
		    For i = 31 To 60
		      pdf.Cell(0, 10, "This is line " + Str(i) + " of content on the page.", 0, 1)
		    Next
		    
		    // Add third page
		    pdf.AddPage()
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
		  
		  result.Value("message") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652031313A204C696E6B7320616E6420426F6F6B6D61726B732E0A
		Function GenerateExample11() As Dictionary
		  // Example 11: Links and Bookmarks
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 11: Links and Bookmarks..." + EndOfLine
		  
		  Try
		    // Create PDF document (first page added automatically)
		    Dim pdf As New VNSPDFDocument()

		    // Page 1: Table of Contents with internal links
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
		    pdf.AddPage()
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
		    pdf.AddPage()
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
		    pdf.AddPage()
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
		      result.Value("message") = statusText
		      Return result
		    End If
		    
		    // Get PDF data as String
		    Dim pdfData As String = pdf.Output()
		    If pdfData = "" Then
		      statusText = statusText + "Error: Failed to generate PDF data" + EndOfLine
		      result.Value("success") = False
		      result.Value("message") = statusText
		      Return result
		    End If
		    
		    statusText = statusText + "Success! PDF generated (" + Str(pdfData.Bytes) + " bytes)" + EndOfLine
		    result.Value("success") = True
		    result.Value("message") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example11_links_bookmarks.pdf"
		    
		    Return result
		    
		  Catch err As RuntimeException
		    statusText = statusText + "Exception: " + err.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
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

		    // First page added automatically by constructor
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
		    pdf.AddPageFormat("P", 150, 150)
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
		    pdf.AddPageFormat("L", 250, 100)
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
		    pdf.AddPageFormat("P", 80, 200)
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
		    pdf.AddPage()
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
		      result.Value("message") = statusText
		      Return result
		    End If
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    If pdf.Error <> "" Then
		      statusText = statusText + "ERROR: " + pdf.Error + EndOfLine
		      result.Value("success") = False
		      result.Value("error") = pdf.Error
		      result.Value("message") = statusText
		      Return result
		    End If
		    
		    statusText = statusText + "Generated " + Str(pdfData.Bytes) + " bytes" + EndOfLine
		    statusText = statusText + "SUCCESS: Custom page formats example generated" + EndOfLine
		    
		    result.Value("success") = True
		    result.Value("message") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example12_custom_formats.pdf"
		    Return result
		    
		  Catch err As RuntimeException
		    statusText = statusText + "EXCEPTION: " + err.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
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
		    
		    // Set metadata (required for PDF/A) using Xojo-compatible property syntax
		    pdf.Title = "PDF/A Sample Document"
		    pdf.Author = "Xojo FPDF Library"
		    pdf.Subject = "PDF/A-1 Compliance Example"
		    pdf.Keywords = "PDF/A, archival, ICC profile, color management"
		    pdf.Creator = "Xojo FPDF v0.3.0"
		    
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

		    // First page already added by constructor
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
		      result.Value("message") = statusText
		      Return result
		    End If
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    If pdf.Error <> "" Then
		      statusText = statusText + "ERROR: " + pdf.Error + EndOfLine
		      result.Value("success") = False
		      result.Value("error") = pdf.Error
		      result.Value("message") = statusText
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
		    result.Value("message") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example13_pdfa.pdf"
		    Return result
		    
		  Catch e As RuntimeException
		    statusText = statusText + "EXCEPTION: " + e.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
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

		    // First page already added by constructor
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
		    pdf.AddPage()
		    
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
		      result.Value("message") = statusText
		      Return result
		    End If
		    
		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    If pdf.Error <> "" Then
		      statusText = statusText + "ERROR: " + pdf.Error + EndOfLine
		      result.Value("success") = False
		      result.Value("error") = pdf.Error
		      result.Value("message") = statusText
		      Return result
		    End If
		    
		    statusText = statusText + "File size: " + Str(pdfData.Bytes) + " bytes" + EndOfLine
		    statusText = statusText + EndOfLine
		    statusText = statusText + "SUCCESS! PDF Security example created." + EndOfLine
		    statusText = statusText + "This PDF is encrypted with RC4-40 (available in free version)." + EndOfLine
		    statusText = statusText + "Use password 'user123' to open the PDF." + EndOfLine
		    
		    result.Value("success") = True
		    result.Value("message") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example14_security.pdf"
		    Return result
		    
		  Catch e As RuntimeException
		    statusText = statusText + "EXCEPTION: " + e.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    Return result
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652031353A2048656164657220776974682077617465726D61726B0A
		Function GenerateExample15() As Dictionary
		  // Example 15: Complete Transformation Suite (18 methods)
		  // Shows 10 different transformation watermarks on each page:
		  // 1. TransformRotate() - 45° diagonal "DRAFT"
		  // 2. TransformScale() - 150% enlarged "SCALED"
		  // 3. TransformSkewX() - 15° italic-style "SKEWED"
		  // 4. TransformTranslate() - Shifted "MOVED"
		  // 5. Combined Rotate+Scale - "COMBO"
		  // 6. TransformScaleX() - Condensed 70% width "CONDENSED"
		  // 7. TransformMirrorHorizontal() - Flipped "H-MIRROR"
		  // 8. TransformMirrorVertical() - Flipped "V-FLIP"
		  // 9. TransformMirrorPoint() - 180° "180°"
		  // 10. TransformMirrorLine() - Diagonal mirror "LINE-30°"

		  Dim result As New Dictionary
		  Dim statusText As String = ""

		  // Create PDF with Custom format (no auto-page) so we can set header callback first
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.Custom)
		  pdf.Title = "Complete Transformation Suite"
		  pdf.Author = "Xojo FPDF"
		  pdf.Subject = "Demonstrates all 18 transformation methods: Rotate, Scale, Translate, Skew, Mirror"
		  pdf.SetMargins(10, 10, 10)

		  // Set header with homeMode = True to reset position after rendering
		  // This ensures the watermark doesn't affect content positioning
		  pdf.SetHeaderFuncMode(AddressOf Example15HeaderWithWatermark, True)

		  // Add first page with A4 dimensions (210 x 297 mm)
		  pdf.AddPageFormat("P", 210, 297)
		  pdf.SetFont("Times", "", 12)
		  
		  // Page 1 content
		  pdf.Cell(0, 10, "Document with Background Watermark", 0, 1, "C")
		  pdf.Ln(5)
		  
		  Dim i As Integer
		  For i = 1 To 25
		    pdf.Cell(0, 8, "This is line " + Str(i) + " of normal content.", 0, 1)
		  Next
		  
		  // Page 2
		  pdf.AddPage()
		  For i = 26 To 50
		    pdf.Cell(0, 8, "This is line " + Str(i) + " of normal content.", 0, 1)
		  Next
		  
		  // Check for errors
		  If pdf.Err() Then
		    statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    Return result
		  End If
		  
		  statusText = statusText + "✓ Example 15 generated successfully!" + EndOfLine
		  statusText = statusText + "  - 10 transformation examples on each page" + EndOfLine
		  statusText = statusText + "  - All 18 methods: Rotate, Scale, Translate, Skew, Mirror" + EndOfLine
		  
		  result.Value("success") = True
		  result.Value("message") = statusText
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
		  
		  // Create PDF with Xojo-compatible property syntax
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  pdf.Title = "Example 16 - New Formatting Features"
		  pdf.Author = "VNS PDF Library"
		  Call pdf.SetMargins(10, 10, 10)

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
		    result.Value("message") = statusText
		    Return result
		  End If
		  
		  statusText = statusText + "✓ Example 16 generated successfully!" + EndOfLine
		  
		  result.Value("success") = True
		  result.Value("message") = statusText
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
		  
		  // Create PDF with Xojo-compatible property syntax
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  pdf.Title = "Example 17 - Utility Methods"
		  pdf.Author = "VNS PDF Library"
		  pdf.Subject = "Testing utility methods and JSON serialization"

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
		  If jsonState.Length > 500 Then
		    jsonExcerpt = jsonState.Left(500) + "..."
		  Else
		    jsonExcerpt = jsonState
		  End If
		  
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
		    result.Value("message") = statusText
		    Return result
		  End If
		  
		  statusText = statusText + "✓ Example 17 generated successfully!" + EndOfLine
		  statusText = statusText + "✓ All utility methods tested" + EndOfLine
		  
		  result.Value("success") = True
		  result.Value("message") = statusText
		  result.Value("pdf") = pdf.Output()
		  result.Value("filename") = "example17_utilities.pdf"
		  
		  Return result
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
		  
		  // Create PDF with RC4-40 encryption using Xojo-compatible property syntax
		  Dim pdf1 As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  pdf1.Title = "Example 18 - RC4-40 Test (Free)"
		  pdf1.Author = "VNS PDF Library"
		  pdf1.Subject = "Testing free RC4-40 encryption"

		  // Set RC4-40 encryption (revision 2) - This should work in free version
		  // Minimal permissions: allow print and copy only
		  Call pdf1.SetProtection("user123", "owner456", True, False, True, False, False, False, False, False, VNSPDFModule.gkEncryptionRC4_40)
		  
		  If pdf1.Err() Then
		    statusText = statusText + "✗ FAILED: " + pdf1.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
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
		    result.Value("message") = statusText
		    Return result
		  End If
		  
		  statusText = statusText + "✓ RC4-40 PDF generated successfully" + EndOfLine + EndOfLine
		  
		  // ===== TEST 2: RC4-128 (Revision 3) - PREMIUM (Should be blocked) =====
		  statusText = statusText + "TEST 2: RC4-128 Encryption (Revision 3 - PREMIUM)" + EndOfLine
		  statusText = statusText + "----------------------------------------------" + EndOfLine
		  
		  // Create PDF and try to set RC4-128 encryption (should fail without premium module)
		  Dim pdf2 As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		  pdf2.Title = "Example 18 - RC4-128 Test (Premium)"
		  pdf2.Author = "VNS PDF Library"
		  pdf2.Subject = "Testing premium RC4-128 encryption"

		  // Try to set RC4-128 encryption (revision 3) - This should fail in free version
		  // Full permissions for testing
		  Call pdf2.SetProtection("user123", "owner456", True, True, True, True, True, True, True, True, VNSPDFModule.gkEncryptionRC4_128)
		  
		  If pdf2.Err() Then
		    // Expected: Should fail because hasPremiumVNSEncryptionModule = False
		    Dim errorMsg As String = pdf2.GetError()
		    
		    // Check if it's the expected error message about premium module
		    #If TargetiOS Or TargetAndroid Then
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
		      result.Value("message") = statusText
		      Return result
		    End If
		  Else
		    // This means RC4-128 worked without the premium flag - THIS IS A BUG!
		    statusText = statusText + "✗ FAILED: RC4-128 should be blocked without premium module!" + EndOfLine
		    statusText = statusText + "  BUG: Encryption was allowed when it should have been blocked." + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    Return result
		  End If
		  
		  statusText = statusText + EndOfLine
		  
		  // ===== Instructions for enabling premium module =====
		  statusText = statusText + GetPremiumEnablingInstructions(Array("hasPremiumVNSEncryptionModule")) + EndOfLine
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
		  result.Value("message") = statusText
		  result.Value("pdf") = pdf1.Output()  // Return the working RC4-40 PDF data
		  result.Value("filename") = "example18_plugin_architecture.pdf"
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample19() As Dictionary
		  #If hasPremiumVNSTableModule Then
		    // Example 19: Table Generation (Premium Feature)
		    // Demonstrates SimpleTable, ImprovedTable, and FancyTable with optional grand footers
		    
		    Dim result As New Dictionary
		    Dim statusText As String = ""
		    
		    statusText = statusText + "Example 19: Table Generation with Footers (Premium)" + EndOfLine
		    statusText = statusText + "========================================" + EndOfLine + EndOfLine
		    
		    // Check if table module is available
		    #If Not hasPremiumVNSTableModule Then
		      statusText = statusText + "✗ SKIPPED: Table generation requires premium Table module." + EndOfLine + EndOfLine
		      statusText = statusText + GetPremiumEnablingInstructions(Array("hasPremiumVNSTableModule")) + EndOfLine
		      result.Value("success") = False
		      result.Value("message") = statusText
		      result.Value("filename") = ""
		      Return result
		    #EndIf
		    
		    statusText = statusText + "✓ Table module is enabled" + EndOfLine + EndOfLine
		    
		    // Create PDF with Xojo-compatible property syntax
		    // First page is added automatically by constructor
		    Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)

		    pdf.Title = "Example 19 - Table Generation with Footers"
		    pdf.Author = "VNS PDF Library"
		    pdf.Subject = "Demonstrating table generation features with optional grand footers"

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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		      footerConfig.GrandStyle.BackgroundColor = Color.RGB(52, 73, 94)  // Dark blue
		      footerConfig.GrandStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig.GrandStyle.BorderColor = Color.RGB(0, 0, 0)
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
		    pdf.AddPage()
		    
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
		      footerConfig7.GrandStyle.BackgroundColor = Color.RGB(44, 62, 80)  // Dark gray
		      footerConfig7.GrandStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig7.GrandStyle.BorderColor = Color.RGB(0, 0, 0)
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
		    pdf.AddPage()
		    
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
		      footerConfig8.IntermediateStyle.BackgroundColor = Color.RGB(149, 165, 166)  // Medium gray
		      footerConfig8.IntermediateStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig8.IntermediateStyle.BorderColor = Color.RGB(0, 0, 0)
		      footerConfig8.IntermediateStyle.FontStyle = "B"
		      footerConfig8.IntermediateStyle.CellHeight = 6.5
		      
		      // Configure grand footer style (darker)
		      footerConfig8.GrandStyle = New VNSPDFTableFooterStyle
		      footerConfig8.GrandStyle.BackgroundColor = Color.RGB(44, 62, 80)  // Dark gray
		      footerConfig8.GrandStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig8.GrandStyle.BorderColor = Color.RGB(0, 0, 0)
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
		    pdf.AddPage()
		    
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
		      footerConfig9.IntermediateStyle.BackgroundColor = Color.RGB(149, 165, 166)  // Medium gray
		      footerConfig9.IntermediateStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig9.IntermediateStyle.BorderColor = Color.RGB(0, 0, 0)
		      footerConfig9.IntermediateStyle.FontStyle = "B"
		      footerConfig9.IntermediateStyle.CellHeight = 6.5
		      
		      // Configure grand footer style (dark blue-gray)
		      footerConfig9.GrandStyle = New VNSPDFTableFooterStyle
		      footerConfig9.GrandStyle.BackgroundColor = Color.RGB(44, 62, 80)  // Dark gray
		      footerConfig9.GrandStyle.TextColor = Color.RGB(255, 255, 255)  // White
		      footerConfig9.GrandStyle.BorderColor = Color.RGB(0, 0, 0)
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

		    // ===== Example 10: Basic Manual Table =====
		    pdf.AddPage()

		    Call pdf.SetFont("helvetica", "B", 14)
		    Call pdf.Cell(0, 8, "10. Basic Manual Table (No Database)", 0, 1)
		    Call pdf.Ln(2)

		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.MultiCell(0, 5, "Manual table built with AddColumn/AddRow - no RowSet needed. Footer with auto-sum calculation.", 0, "L")
		    Call pdf.Ln(3)

		    Dim manualTable1 As New VNSPDFManualTable(6.0)
		    manualTable1.AddColumn("Product", 60.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable1.AddColumn("Category", 40.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable1.AddColumn("Qty", 25.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable1.AddColumn("Unit Price", 30.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable1.AddColumn("Total", 35.0, VNSPDFModule.eColumnAlignment.Right)

		    manualTable1.AddRow(Array("Professional Services", "Consulting", "8", "150.00", "1200.00"))
		    manualTable1.AddRow(Array("Software License", "Software", "3", "599.99", "1799.97"))
		    manualTable1.AddRow(Array("Hardware Bundle", "Hardware", "2", "1299.50", "2599.00"))
		    manualTable1.AddRow(Array("Training Session", "Education", "4", "450.00", "1800.00"))
		    manualTable1.AddRow(Array("Support Contract", "Services", "1", "2500.00", "2500.00"))
		    manualTable1.AddRow(Array("Cloud Subscription", "Software", "12", "99.00", "1188.00"))
		    manualTable1.AddRow(Array("Premium Support", "Services", "2", "750.00", "1500.00"))

		    // Footer with auto-sum on Qty and Total columns
		    Dim footer1() As VNSPDFManualTableFooterCell
		    footer1.Add(New VNSPDFManualTableFooterCell("TOTALS", 2, VNSPDFModule.eColumnAlignment.Left))
		    footer1.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 2, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer1.Add(New VNSPDFManualTableFooterCell("", 1, VNSPDFModule.eColumnAlignment.Left))
		    footer1.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 4, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    manualTable1.SetFooterCells(footer1)

		    Call pdf.SetFont("helvetica", "", 9)
		    manualTable1.Render(pdf)
		    Call pdf.Ln(5)

		    statusText = statusText + "✓ Basic manual table generated" + EndOfLine

		    // ===== Example 11: Merged Headers (Colspan) =====
		    pdf.AddPage()

		    Call pdf.SetFont("helvetica", "B", 14)
		    Call pdf.Cell(0, 8, "11. Merged Headers with Colspan", 0, 1)
		    Call pdf.Ln(2)

		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.MultiCell(0, 5, "Multi-row header with colspan to group related columns. First row has merged cells, second row shows individual column names.", 0, "L")
		    Call pdf.Ln(3)

		    Dim manualTable2 As New VNSPDFManualTable(6.0)
		    manualTable2.AddColumn("Region", 30.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable2.AddColumn("Q1", 25.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable2.AddColumn("Q2", 25.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable2.AddColumn("Q3", 25.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable2.AddColumn("Q4", 25.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable2.AddColumn("Total", 30.0, VNSPDFModule.eColumnAlignment.Right)

		    // Group header row with colspan
		    Dim headerRow1() As VNSPDFManualTableHeaderCell
		    headerRow1.Add(New VNSPDFManualTableHeaderCell("", 1))
		    headerRow1.Add(New VNSPDFManualTableHeaderCell("Quarterly Revenue", 4))
		    headerRow1.Add(New VNSPDFManualTableHeaderCell("", 1))
		    manualTable2.AddHeaderRow(headerRow1)

		    // Detail header row (auto-generated from column names when not added)
		    // But we add it explicitly to show the pattern
		    Dim headerRow2() As VNSPDFManualTableHeaderCell
		    headerRow2.Add(New VNSPDFManualTableHeaderCell("Region", 1))
		    headerRow2.Add(New VNSPDFManualTableHeaderCell("Q1", 1))
		    headerRow2.Add(New VNSPDFManualTableHeaderCell("Q2", 1))
		    headerRow2.Add(New VNSPDFManualTableHeaderCell("Q3", 1))
		    headerRow2.Add(New VNSPDFManualTableHeaderCell("Q4", 1))
		    headerRow2.Add(New VNSPDFManualTableHeaderCell("Total", 1))
		    manualTable2.AddHeaderRow(headerRow2)

		    manualTable2.AddRow(Array("North", "12500", "15200", "13800", "18500", "60000"))
		    manualTable2.AddRow(Array("South", "9800", "11500", "10200", "14300", "45800"))
		    manualTable2.AddRow(Array("East", "15100", "16800", "14500", "19200", "65600"))
		    manualTable2.AddRow(Array("West", "11200", "13400", "12100", "16700", "53400"))

		    // Footer with sum
		    Dim footer2() As VNSPDFManualTableFooterCell
		    footer2.Add(New VNSPDFManualTableFooterCell("TOTAL", 1, VNSPDFModule.eColumnAlignment.Left))
		    footer2.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 1, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer2.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 2, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer2.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 3, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer2.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 4, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer2.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 5, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    manualTable2.SetFooterCells(footer2)

		    Call pdf.SetFont("helvetica", "", 9)
		    manualTable2.Render(pdf)
		    Call pdf.Ln(5)

		    statusText = statusText + "✓ Merged headers table generated" + EndOfLine

		    // ===== Example 12: Unicode Text in Manual Table =====
		    pdf.AddPage()

		    Call pdf.SetFont("helvetica", "B", 14)
		    Call pdf.Cell(0, 8, "12. Unicode Text in Manual Table", 0, 1)
		    Call pdf.Ln(2)

		    // Load a Unicode TrueType font for both Part A and Part B
		    // Core fonts (Helvetica) cannot render accented/Unicode characters correctly
		    Dim utf8FontLoaded As Boolean = False
		    #If TargetMacOS Then
		      Dim utf8FontPath As String = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
		      Dim utf8FontFile As FolderItem = New FolderItem(utf8FontPath, FolderItem.PathModes.Native)
		      If utf8FontFile <> Nil And utf8FontFile.Exists Then
		        pdf.AddUTF8Font("unicode_tbl", "", utf8FontPath)
		        If pdf.Ok Then utf8FontLoaded = True
		      End If
		    #ElseIf TargetWindows Then
		      Dim utf8FontPath As String = "C:\Windows\Fonts\arialuni.ttf"
		      Dim utf8FontFile As FolderItem = New FolderItem(utf8FontPath, FolderItem.PathModes.Native)
		      If utf8FontFile <> Nil And utf8FontFile.Exists Then
		        pdf.AddUTF8Font("unicode_tbl", "", utf8FontPath)
		        If pdf.Ok Then utf8FontLoaded = True
		      End If
		    #ElseIf TargetLinux Then
		      Dim utf8FontPath As String = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
		      Dim utf8FontFile As FolderItem = New FolderItem(utf8FontPath, FolderItem.PathModes.Native)
		      If utf8FontFile <> Nil And utf8FontFile.Exists Then
		        pdf.AddUTF8Font("unicode_tbl", "", utf8FontPath)
		        If pdf.Ok Then utf8FontLoaded = True
		      End If
		    #ElseIf TargetiOS Then
		      Try
		        Dim fontRes12 As FolderItem = SpecialFolder.Resource("Arial Unicode.ttf")
		        If fontRes12 <> Nil And fontRes12.Exists Then
		          Dim bs12 As BinaryStream = BinaryStream.Open(fontRes12)
		          Dim fd12 As String = bs12.Read(bs12.Length)
		          bs12.Close()
		          Dim mb12 As New MemoryBlock(fd12.Bytes)
		          mb12.StringValue(0, fd12.Bytes) = fd12
		          pdf.AddUTF8FontFromBytes("unicode_tbl", "", mb12)
		          If pdf.Ok Then utf8FontLoaded = True
		        Else
		          fontRes12 = SpecialFolder.Resource("ArialUnicode.ttf")
		          If fontRes12 <> Nil And fontRes12.Exists Then
		            Dim bs12b As BinaryStream = BinaryStream.Open(fontRes12)
		            Dim fd12b As String = bs12b.Read(bs12b.Length)
		            bs12b.Close()
		            Dim mb12b As New MemoryBlock(fd12b.Bytes)
		            mb12b.StringValue(0, fd12b.Bytes) = fd12b
		            pdf.AddUTF8FontFromBytes("unicode_tbl", "", mb12b)
		            If pdf.Ok Then utf8FontLoaded = True
		          End If
		        End If
		      Catch e As RuntimeException
		        // Font resource not found on iOS
		      End Try
		    #EndIf

		    If Not utf8FontLoaded Then
		      Call pdf.SetFont("helvetica", "I", 10)
		      Call pdf.Cell(0, 6, "Note: Unicode TrueType font not found. This example requires Arial Unicode or similar.", 0, 1)
		      Call pdf.Ln(5)
		      statusText = statusText + "✓ Unicode text table skipped (no UTF-8 font)" + EndOfLine
		    Else

		    // --- Part A: Accented European characters ---
		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.MultiCell(0, 5, "Part A: Accented European characters using TrueType UTF-8 font.", 0, "L")
		    Call pdf.Ln(3)

		    Dim manualTable3 As New VNSPDFManualTable(6.0)
		    manualTable3.AddColumn("Pays / Country", 40.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable3.AddColumn("Capitale / Capital", 40.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable3.AddColumn("Sp" + Chr(233) + "cialit" + Chr(233), 50.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable3.AddColumn("Population", 30.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable3.AddColumn("Devise", 30.0, VNSPDFModule.eColumnAlignment.Left)

		    manualTable3.AddRow(Array("France", "Paris", "Cr" + Chr(232) + "me br" + Chr(251) + "l" + Chr(233) + "e", "67.750.000", "EUR"))
		    manualTable3.AddRow(Array("Espa" + Chr(241) + "a", "Madrid", "Pa" + Chr(235) + "lla", "47.420.000", "EUR"))
		    manualTable3.AddRow(Array("Deutschland", "M" + Chr(252) + "nchen", "Gem" + Chr(252) + "tlichkeit", "83.240.000", "EUR"))
		    manualTable3.AddRow(Array("Italia", "Roma", "Tiramis" + Chr(249), "60.360.000", "EUR"))
		    manualTable3.AddRow(Array("Suisse / Schweiz", "Gen" + Chr(232) + "ve / Z" + Chr(252) + "rich", "R" + Chr(246) + "sti", "8.859.000", "CHF"))
		    manualTable3.AddRow(Array("Sverige", "Malm" + Chr(246), "K" + Chr(246) + "ttbullar", "10.380.000", "SEK"))
		    manualTable3.AddRow(Array("Portugal", "Lisboa", "Past" + Chr(233) + "is de Bel" + Chr(233) + "m", "10.300.000", "EUR"))
		    manualTable3.AddRow(Array("Belgique", "Bruxelles", "Gaufres Li" + Chr(233) + "geoises", "11.515.000", "EUR"))

		    Call pdf.SetFont("unicode_tbl", "", 9)
		    manualTable3.Render(pdf)
		    Call pdf.Ln(8)

		    // --- Part B: Multilingual table (Arabic, Japanese, Chinese, Korean) ---
		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.MultiCell(0, 5, "Part B: Multilingual text (Arabic, Japanese, Chinese, Korean) using TrueType UTF-8 font.", 0, "L")
		    Call pdf.Ln(3)

		    Dim manualTable3b As New VNSPDFManualTable(7.0)
		    manualTable3b.AddColumn("Language", 35.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable3b.AddColumn("Hello", 45.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable3b.AddColumn("Thank You", 50.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable3b.AddColumn("Country", 40.0, VNSPDFModule.eColumnAlignment.Left)

		    manualTable3b.AddRow(Array("Arabic", Chr(&h0645) + Chr(&h0631) + Chr(&h062D) + Chr(&h0628) + Chr(&h0627), Chr(&h0634) + Chr(&h0643) + Chr(&h0631) + Chr(&h0627) + Chr(&h064B), Chr(&h0645) + Chr(&h0635) + Chr(&h0631)))
		    manualTable3b.AddRow(Array("Japanese", Chr(&h3053) + Chr(&h3093) + Chr(&h306B) + Chr(&h3061) + Chr(&h306F), Chr(&h3042) + Chr(&h308A) + Chr(&h304C) + Chr(&h3068) + Chr(&h3046), Chr(&h65E5) + Chr(&h672C)))
		    manualTable3b.AddRow(Array("Chinese", Chr(&h4F60) + Chr(&h597D), Chr(&h8C22) + Chr(&h8C22), Chr(&h4E2D) + Chr(&h56FD)))
		    manualTable3b.AddRow(Array("Korean", Chr(&hC548) + Chr(&hB155) + Chr(&hD558) + Chr(&hC138) + Chr(&hC694), Chr(&hAC10) + Chr(&hC0AC) + Chr(&hD569) + Chr(&hB2C8) + Chr(&hB2E4), Chr(&hD55C) + Chr(&hAD6D)))
		    manualTable3b.AddRow(Array("Greek", Chr(&h0393) + Chr(&h03B5) + Chr(&h03B9) + Chr(&h03B1) + " " + Chr(&h03C3) + Chr(&h03BF) + Chr(&h03C5), Chr(&h0395) + Chr(&h03C5) + Chr(&h03C7) + Chr(&h03B1) + Chr(&h03C1) + Chr(&h03B9) + Chr(&h03C3) + Chr(&h03C4) + Chr(&h03CE), Chr(&h0395) + Chr(&h03BB) + Chr(&h03BB) + Chr(&h03AC) + Chr(&h03B4) + Chr(&h03B1)))
		    manualTable3b.AddRow(Array("Russian", Chr(&h041F) + Chr(&h0440) + Chr(&h0438) + Chr(&h0432) + Chr(&h0435) + Chr(&h0442), Chr(&h0421) + Chr(&h043F) + Chr(&h0430) + Chr(&h0441) + Chr(&h0438) + Chr(&h0431) + Chr(&h043E), Chr(&h0420) + Chr(&h043E) + Chr(&h0441) + Chr(&h0441) + Chr(&h0438) + Chr(&h044F)))
		    manualTable3b.AddRow(Array("Hindi", Chr(&h0928) + Chr(&h092E) + Chr(&h0938) + Chr(&h094D) + Chr(&h0924) + Chr(&h0947), Chr(&h0927) + Chr(&h0928) + Chr(&h094D) + Chr(&h092F) + Chr(&h0935) + Chr(&h093E) + Chr(&h0926), Chr(&h092D) + Chr(&h093E) + Chr(&h0930) + Chr(&h0924)))

		    Call pdf.SetFont("unicode_tbl", "", 9)
		    manualTable3b.Render(pdf)

		    End If // utf8FontLoaded

		    Call pdf.Ln(5)
		    statusText = statusText + "✓ Unicode text table generated" + EndOfLine

		    // ===== Example 13: Pictures and Barcodes in Cells =====
		    #If hasPremiumVNSEInvoiceModule Then
		      pdf.AddPage()

		      Call pdf.SetFont("helvetica", "B", 14)
		      Call pdf.Cell(0, 8, "13. Barcodes in Table Cells", 0, 1)
		      Call pdf.Ln(2)

		      Call pdf.SetFont("helvetica", "", 10)
		      Call pdf.MultiCell(0, 5, "Table cells can contain various barcode types via SetCellBarcode(). QR Code and Code128 are free (Xojo core Barcode class). All other types (EAN-13, EAN-8, Code 39, ITF, Codabar, DataMatrix, PDF417) require the premium E-Invoice module for vector rendering.", 0, "L")
		      Call pdf.Ln(3)

		      Dim manualTable4 As New VNSPDFManualTable(14.0)
		      manualTable4.AddColumn("Barcode Type", 35.0, VNSPDFModule.eColumnAlignment.Left)
		      manualTable4.AddColumn("Value", 40.0, VNSPDFModule.eColumnAlignment.Left)
		      manualTable4.AddColumn("Rendered", 55.0, VNSPDFModule.eColumnAlignment.Center)
		      manualTable4.AddColumn("2D Code", 30.0, VNSPDFModule.eColumnAlignment.Center)

		      // Row 0: Code128 + QR (FREE)
		      manualTable4.AddRow(Array("Code 128 (Free)", "VNS-PDF-001", "", ""))
		      manualTable4.SetCellStyle(0, 0, "", "B", 0, Color.RGB(0, 128, 0))
		      manualTable4.SetCellBarcode(0, 2, VNSPDFModule.eBarcodeType.Code128, "VNS-PDF-001", 2.0, 2.0)
		      manualTable4.SetCellBarcode(0, 3, VNSPDFModule.eBarcodeType.QRCode, "VNS-PDF-001", 1.0, 1.0)

		      // Row 1: QR Code (FREE)
		      manualTable4.AddRow(Array("QR Code (Free)", "https://vnspdf.com", "", ""))
		      manualTable4.SetCellStyle(1, 0, "", "B", 0, Color.RGB(0, 128, 0))
		      manualTable4.SetCellBarcode(1, 2, VNSPDFModule.eBarcodeType.QRCode, "https://vnspdf.com", 1.0, 1.0)
		      manualTable4.SetCellBarcode(1, 3, VNSPDFModule.eBarcodeType.DataMatrix, "vnspdf.com", 1.0, 1.0)

		      // Row 2: EAN-13 (PREMIUM)
		      manualTable4.AddRow(Array("EAN-13 (Premium)", "5901234123457", "", ""))
		      manualTable4.SetCellStyle(2, 0, "", "B", 0, Color.RGB(192, 0, 0))
		      manualTable4.SetCellBarcode(2, 2, VNSPDFModule.eBarcodeType.EAN13, "5901234123457", 2.0, 1.0)
		      manualTable4.SetCellBarcode(2, 3, VNSPDFModule.eBarcodeType.QRCode, "5901234123457", 1.0, 1.0)

		      // Row 3: Code 39 (PREMIUM)
		      manualTable4.AddRow(Array("Code 39 (Premium)", "HELLO-39", "", ""))
		      manualTable4.SetCellStyle(3, 0, "", "B", 0, Color.RGB(192, 0, 0))
		      manualTable4.SetCellBarcode(3, 2, VNSPDFModule.eBarcodeType.Code39, "HELLO-39", 2.0, 2.0)
		      manualTable4.SetCellBarcode(3, 3, VNSPDFModule.eBarcodeType.DataMatrix, "HELLO39", 1.0, 1.0)

		      // Row 4: EAN-8 (PREMIUM)
		      manualTable4.AddRow(Array("EAN-8 (Premium)", "96385074", "", ""))
		      manualTable4.SetCellStyle(4, 0, "", "B", 0, Color.RGB(192, 0, 0))
		      manualTable4.SetCellBarcode(4, 2, VNSPDFModule.eBarcodeType.EAN8, "96385074", 2.0, 1.0)
		      manualTable4.SetCellBarcode(4, 3, VNSPDFModule.eBarcodeType.DataMatrix, "96385074", 1.0, 1.0)

		      // Row 5: ITF (PREMIUM)
		      manualTable4.AddRow(Array("ITF (Premium)", "1234567890", "", ""))
		      manualTable4.SetCellStyle(5, 0, "", "B", 0, Color.RGB(192, 0, 0))
		      manualTable4.SetCellBarcode(5, 2, VNSPDFModule.eBarcodeType.ITF, "1234567890", 2.0, 2.0)
		      manualTable4.SetCellBarcode(5, 3, VNSPDFModule.eBarcodeType.QRCode, "ITF:1234567890", 1.0, 1.0)

		      // Row 6: Codabar (PREMIUM)
		      manualTable4.AddRow(Array("Codabar (Premium)", "A12345B", "", ""))
		      manualTable4.SetCellStyle(6, 0, "", "B", 0, Color.RGB(192, 0, 0))
		      manualTable4.SetCellBarcode(6, 2, VNSPDFModule.eBarcodeType.Codabar, "A12345B", 2.0, 2.0)
		      manualTable4.SetCellBarcode(6, 3, VNSPDFModule.eBarcodeType.QRCode, "A12345B", 1.0, 1.0)

		      // Row 7: DataMatrix (PREMIUM)
		      manualTable4.AddRow(Array("DataMatrix (Premium)", "DM-TEST-42", "", ""))
		      manualTable4.SetCellStyle(7, 0, "", "B", 0, Color.RGB(192, 0, 0))
		      manualTable4.SetCellBarcode(7, 2, VNSPDFModule.eBarcodeType.DataMatrix, "DM-TEST-42", 1.0, 1.0)
		      manualTable4.SetCellBarcode(7, 3, VNSPDFModule.eBarcodeType.QRCode, "DM-TEST-42", 1.0, 1.0)

		      manualTable4.mAlternateRowColors = True
		      manualTable4.mBorderStyle = "1"

		      Call pdf.SetFont("helvetica", "", 8)
		      manualTable4.Render(pdf)
		      Call pdf.Ln(5)

		      statusText = statusText + "✓ Barcodes table generated (Code128, EAN-13, Code39, EAN-8, ITF, Codabar, QR, DataMatrix)" + EndOfLine
		    #Else
		      statusText = statusText + "✗ SKIPPED: Barcodes in table cells requires premium E-Invoice/Barcode module." + EndOfLine
		      statusText = statusText + GetPremiumEnablingInstructions(Array("hasPremiumVNSEInvoiceModule")) + EndOfLine
		    #EndIf

		    // ===== Example 14: Multi-Page Manual Table =====
		    pdf.AddPage()

		    Call pdf.SetFont("helvetica", "B", 14)
		    Call pdf.Cell(0, 8, "14. Multi-Page Manual Table with Repeated Headers", 0, 1)
		    Call pdf.Ln(2)

		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.MultiCell(0, 5, "40 rows of data trigger page breaks. Merged headers repeat on each new page.", 0, "L")
		    Call pdf.Ln(3)

		    Dim manualTable5 As New VNSPDFManualTable(6.0)
		    manualTable5.AddColumn("ID", 12.0, VNSPDFModule.eColumnAlignment.Center)
		    manualTable5.AddColumn("Product", 48.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable5.AddColumn("Q1", 24.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable5.AddColumn("Q2", 24.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable5.AddColumn("Q3", 24.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable5.AddColumn("Q4", 24.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable5.AddColumn("Total", 30.0, VNSPDFModule.eColumnAlignment.Right)

		    // Multi-row header with colspan
		    Dim hdr5Row1() As VNSPDFManualTableHeaderCell
		    hdr5Row1.Add(New VNSPDFManualTableHeaderCell("", 1))
		    hdr5Row1.Add(New VNSPDFManualTableHeaderCell("", 1))
		    hdr5Row1.Add(New VNSPDFManualTableHeaderCell("Quarterly Sales", 4))
		    hdr5Row1.Add(New VNSPDFManualTableHeaderCell("", 1))
		    manualTable5.AddHeaderRow(hdr5Row1)

		    Dim hdr5Row2() As VNSPDFManualTableHeaderCell
		    hdr5Row2.Add(New VNSPDFManualTableHeaderCell("ID", 1))
		    hdr5Row2.Add(New VNSPDFManualTableHeaderCell("Product", 1))
		    hdr5Row2.Add(New VNSPDFManualTableHeaderCell("Q1", 1))
		    hdr5Row2.Add(New VNSPDFManualTableHeaderCell("Q2", 1))
		    hdr5Row2.Add(New VNSPDFManualTableHeaderCell("Q3", 1))
		    hdr5Row2.Add(New VNSPDFManualTableHeaderCell("Q4", 1))
		    hdr5Row2.Add(New VNSPDFManualTableHeaderCell("Total", 1))
		    manualTable5.AddHeaderRow(hdr5Row2)

		    // Generate 40 rows of data
		    Dim prodNames() As String = Array("Professional Services", "Software License", "Hardware Bundle", "Training Session", "Support Contract", "Consulting Hours", "Cloud Subscription", "Premium Support")
		    For rowNum As Integer = 1 To 40
		      Dim prodName As String = prodNames((rowNum - 1) Mod prodNames.Count)
		      Dim q1 As Double = 100 + (rowNum * 27.5)
		      Dim q2 As Double = 120 + (rowNum * 22.3)
		      Dim q3 As Double = 90 + (rowNum * 31.1)
		      Dim q4 As Double = 150 + (rowNum * 19.7)
		      Dim rowTotal As Double = q1 + q2 + q3 + q4
		      manualTable5.AddRow(Array(Str(rowNum), prodName, VNSPDFModule.FormatHelper(q1, "0.00"), VNSPDFModule.FormatHelper(q2, "0.00"), VNSPDFModule.FormatHelper(q3, "0.00"), VNSPDFModule.FormatHelper(q4, "0.00"), VNSPDFModule.FormatHelper(rowTotal, "0.00")))
		    Next

		    // Footer with sums
		    Dim footer5() As VNSPDFManualTableFooterCell
		    footer5.Add(New VNSPDFManualTableFooterCell("", 1, VNSPDFModule.eColumnAlignment.Left))
		    footer5.Add(New VNSPDFManualTableFooterCell("TOTALS", 1, VNSPDFModule.eColumnAlignment.Left))
		    footer5.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 2, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer5.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 3, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer5.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 4, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer5.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 5, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer5.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 6, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    manualTable5.SetFooterCells(footer5)

		    Call pdf.SetFont("helvetica", "", 8)
		    manualTable5.Render(pdf)
		    Call pdf.Ln(5)

		    statusText = statusText + "✓ Multi-page manual table with repeated merged headers generated (40 rows)" + EndOfLine + EndOfLine

		    // ===== Example 15: Manual Table with Subtotal Rows =====
		    pdf.AddPage()

		    Call pdf.SetFont("helvetica", "B", 14)
		    Call pdf.Cell(0, 8, "15. Manual Table with Subtotal Rows", 0, 1)
		    Call pdf.Ln(2)

		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.MultiCell(0, 5, "Regional sales report with inline subtotal rows per region. Subtotals are styled with gray background and bold text. Grand total footer uses auto-sum and skips subtotal rows to avoid double-counting.", 0, "L")
		    Call pdf.Ln(3)

		    Dim manualTable6 As New VNSPDFManualTable(6.0)
		    manualTable6.AddColumn("Region", 35.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable6.AddColumn("Product", 50.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable6.AddColumn("Qty", 25.0, VNSPDFModule.eColumnAlignment.Right)
		    manualTable6.AddColumn("Total", 35.0, VNSPDFModule.eColumnAlignment.Right)

		    // East region
		    manualTable6.AddRow(Array("East", "Professional Services", "4", "1,199.96"))
		    manualTable6.AddRow(Array("East", "Software License", "3", "1,499.97"))
		    manualTable6.AddRow(Array("East", "Training Session", "3", "750.00"))
		    manualTable6.AddSubtotalRow(Array("", "Subtotal East", "10", "3,449.93"))

		    // South region
		    manualTable6.AddRow(Array("South", "Hardware Bundle", "2", "3,998.00"))
		    manualTable6.AddRow(Array("South", "Support Contract", "5", "2,500.00"))
		    manualTable6.AddRow(Array("South", "Consulting Hours", "8", "1,600.00"))
		    manualTable6.AddSubtotalRow(Array("", "Subtotal South", "15", "8,098.00"))

		    // West region
		    manualTable6.AddRow(Array("West", "Cloud Subscription", "12", "2,388.00"))
		    manualTable6.AddRow(Array("West", "Premium Support", "4", "3,996.00"))
		    manualTable6.AddRow(Array("West", "Implementation", "1", "5,000.00"))
		    manualTable6.AddSubtotalRow(Array("", "Subtotal West", "17", "11,384.00"))

		    // Footer with auto-sum (skips subtotal rows)
		    Dim footer6() As VNSPDFManualTableFooterCell
		    footer6.Add(New VNSPDFManualTableFooterCell("", 1, VNSPDFModule.eColumnAlignment.Left))
		    footer6.Add(New VNSPDFManualTableFooterCell("GRAND TOTAL", 1, VNSPDFModule.eColumnAlignment.Left))
		    footer6.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 2, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    footer6.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 3, 1, "", VNSPDFModule.eColumnAlignment.Right))
		    manualTable6.SetFooterCells(footer6)

		    Call pdf.SetFont("helvetica", "", 8)
		    manualTable6.Render(pdf)
		    Call pdf.Ln(5)

		    statusText = statusText + "✓ Manual table with subtotal rows generated (3 regions with subtotals + grand total)" + EndOfLine + EndOfLine

		    // ===== Example 16: Manual Table with Per-Cell Style Overrides =====
		    pdf.AddPage()

		    Call pdf.SetFont("helvetica", "B", 14)
		    Call pdf.Cell(0, 8, "16. Per-Cell Style Overrides + Mixed Fonts", 0, 1)
		    Call pdf.Ln(2)

		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.MultiCell(0, 5, "Product catalog demonstrating per-cell styling via SetCellStyle(). Each cell can have its own font family (Helvetica, Times, Courier), style (bold, italic), size, and color. Priority: cell override > column override > table default.", 0, "L")
		    Call pdf.Ln(3)

		    Dim manualTable7 As New VNSPDFManualTable(7.0)
		    manualTable7.AddColumn("Product", 55.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable7.AddColumn("Category", 30.0, VNSPDFModule.eColumnAlignment.Left)
		    manualTable7.AddColumn("Status", 28.0, VNSPDFModule.eColumnAlignment.Center)
		    manualTable7.AddColumn("Price", 32.0, VNSPDFModule.eColumnAlignment.Right)

		    // Row 0 - SALE item: red bold status, red courier price, italic times product
		    manualTable7.AddRow(Array("Wireless Noise-Cancel Headphones", "Electronics", "SALE", "79.99"))
		    manualTable7.SetCellStyle(0, 0, "times", "I", 9)
		    manualTable7.SetCellStyle(0, 2, "helvetica", "B", 9, Color.RGB(192, 0, 0))
		    manualTable7.SetCellStyle(0, 3, "courier", "B", 8, Color.RGB(192, 0, 0))

		    // Row 1 - In Stock: green status, gray italic origin
		    manualTable7.AddRow(Array("Ergonomic Split Keyboard", "Peripherals", "In Stock", "249.00"))
		    manualTable7.SetCellStyle(1, 0, "times", "", 9)
		    manualTable7.SetCellStyle(1, 1, "helvetica", "I", 8, Color.RGB(80, 80, 80))
		    manualTable7.SetCellStyle(1, 2, "helvetica", "", 9, Color.RGB(0, 128, 0))
		    manualTable7.SetCellStyle(1, 3, "courier", "", 8)

		    // Row 2 - Featured product: bold italic blue product name
		    manualTable7.AddRow(Array("Ultra Wide 34-inch Monitor", "Displays", "In Stock", "599.00"))
		    manualTable7.SetCellStyle(2, 0, "times", "BI", 10, Color.RGB(0, 0, 160))
		    manualTable7.SetCellStyle(2, 2, "helvetica", "B", 9, Color.RGB(0, 128, 0))
		    manualTable7.SetCellStyle(2, 3, "courier", "B", 8)

		    // Row 3 - Ended: gray italic status, gray price
		    manualTable7.AddRow(Array("USB-C Multiport Hub Pro", "Accessories", "Ended", "39.99"))
		    manualTable7.SetCellStyle(3, 0, "times", "", 9)
		    manualTable7.SetCellStyle(3, 2, "helvetica", "I", 8, Color.RGB(128, 128, 128))
		    manualTable7.SetCellStyle(3, 3, "courier", "", 8, Color.RGB(128, 128, 128))

		    // Row 4 - SALE: bigger bold times product, red status + price
		    manualTable7.AddRow(Array("Mechanical Gaming Mouse", "Peripherals", "SALE", "29.99"))
		    manualTable7.SetCellStyle(4, 0, "times", "B", 10)
		    manualTable7.SetCellStyle(4, 2, "helvetica", "B", 9, Color.RGB(192, 0, 0))
		    manualTable7.SetCellStyle(4, 3, "courier", "B", 8, Color.RGB(192, 0, 0))

		    // Row 5 - In Stock: courier product name (monospace look), green status
		    manualTable7.AddRow(Array("Adjustable Laptop Stand", "Furniture", "In Stock", "89.00"))
		    manualTable7.SetCellStyle(5, 0, "courier", "", 8)
		    manualTable7.SetCellStyle(5, 1, "times", "I", 9, Color.RGB(0, 90, 140))
		    manualTable7.SetCellStyle(5, 2, "helvetica", "", 9, Color.RGB(0, 128, 0))
		    manualTable7.SetCellStyle(5, 3, "courier", "", 8)

		    // Row 6 - Ended: all gray italic
		    manualTable7.AddRow(Array("4K Webcam with Ring Light", "Electronics", "Ended", "129.00"))
		    manualTable7.SetCellStyle(6, 0, "times", "I", 9, Color.RGB(128, 128, 128))
		    manualTable7.SetCellStyle(6, 1, "helvetica", "I", 8, Color.RGB(128, 128, 128))
		    manualTable7.SetCellStyle(6, 2, "helvetica", "I", 8, Color.RGB(128, 128, 128))
		    manualTable7.SetCellStyle(6, 3, "courier", "", 8, Color.RGB(128, 128, 128))

		    // Row 7 - SALE: large bold helvetica product, blue category, big red price
		    manualTable7.AddRow(Array("LED Desk Lamp Dimmable", "Lighting", "SALE", "24.99"))
		    manualTable7.SetCellStyle(7, 0, "helvetica", "B", 10)
		    manualTable7.SetCellStyle(7, 1, "times", "", 8, Color.RGB(0, 90, 140))
		    manualTable7.SetCellStyle(7, 2, "helvetica", "B", 10, Color.RGB(192, 0, 0))
		    manualTable7.SetCellStyle(7, 3, "courier", "B", 9, Color.RGB(192, 0, 0))

		    // Row 8 - In Stock: no cell overrides (uses table defaults to show contrast)
		    manualTable7.AddRow(Array("Thunderbolt Docking Station", "Accessories", "In Stock", "189.00"))

		    // Row 9 - In Stock: times italic blue product, different font size
		    manualTable7.AddRow(Array("Premium Bluetooth Speaker", "Audio", "In Stock", "149.00"))
		    manualTable7.SetCellStyle(9, 0, "times", "I", 10, Color.RGB(0, 0, 160))
		    manualTable7.SetCellStyle(9, 2, "helvetica", "", 9, Color.RGB(0, 128, 0))
		    manualTable7.SetCellStyle(9, 3, "courier", "", 8)

		    Call pdf.SetFont("helvetica", "", 8)
		    manualTable7.Render(pdf)
		    Call pdf.Ln(5)

		    Call pdf.SetFont("helvetica", "I", 8)
		    Call pdf.SetTextColor(100, 100, 100)
		    Call pdf.Cell(0, 5, "Row 8 has no cell overrides (table defaults) - compare with styled rows above.", 0, 1)
		    Call pdf.Cell(0, 5, "Fonts: Times (elegant), Helvetica (clean), Courier (monospace prices). Colors: red=sale, green=stock, gray=ended.", 0, 1)
		    Call pdf.SetTextColor(0, 0, 0)

		    statusText = statusText + "✓ Per-cell style overrides with mixed fonts (10 products, 3 font families)" + EndOfLine + EndOfLine

		    // Check for errors
		    If pdf.Err() Then
		      statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		      result.Value("message") = statusText
		      result.Value("filename") = ""
		      Return result
		    End If

		    // Generate PDF
		    Dim pdfData As String = pdf.Output()
		    
		    result.Value("success") = True
		    result.Value("message") = statusText
		    result.Value("pdf") = pdfData
		    result.Value("filename") = "example19_tables.pdf"
		    
		    Return result
		  #Else
		    // Table module not available in free version
		    Dim result As New Dictionary
		    result.Value("success") = False
		    result.Value("message") = "Example 19 requires Premium Table Module." + EndOfLine + EndOfLine + GetPremiumEnablingInstructions(Array("hasPremiumVNSTableModule"))
		    Return result
		  #EndIf
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

		    pdf.Ln(15)

		    // Font Families Comparison
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "4. Font Families Comparison:", 0, 1)
		    pdf.Ln(2)

		    // Helvetica (sans-serif)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Cell(0, 6, "Helvetica: The quick brown fox jumps over the lazy dog. 0123456789", 0, 1)
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 6, "Helvetica Bold: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.SetFont("helvetica", "I", 10)
		    pdf.Cell(0, 6, "Helvetica Italic: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.SetFont("helvetica", "BI", 10)
		    pdf.Cell(0, 6, "Helvetica Bold Italic: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.Ln(3)

		    // Times (serif)
		    pdf.SetFont("times", "", 10)
		    pdf.Cell(0, 6, "Times: The quick brown fox jumps over the lazy dog. 0123456789", 0, 1)
		    pdf.SetFont("times", "B", 10)
		    pdf.Cell(0, 6, "Times Bold: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.SetFont("times", "I", 10)
		    pdf.Cell(0, 6, "Times Italic: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.SetFont("times", "BI", 10)
		    pdf.Cell(0, 6, "Times Bold Italic: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.Ln(3)

		    // Courier (monospace)
		    pdf.SetFont("courier", "", 10)
		    pdf.Cell(0, 6, "Courier: The quick brown fox jumps over the lazy dog. 0123456789", 0, 1)
		    pdf.SetFont("courier", "B", 10)
		    pdf.Cell(0, 6, "Courier Bold: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.SetFont("courier", "I", 10)
		    pdf.Cell(0, 6, "Courier Italic: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.SetFont("courier", "BI", 10)
		    pdf.Cell(0, 6, "Courier Bold Italic: The quick brown fox jumps over the lazy dog.", 0, 1)
		    pdf.Ln(3)

		    // Font size comparison
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Ln(5)
		    pdf.Cell(0, 8, "5. Font Size Comparison:", 0, 1)
		    pdf.Ln(2)

		    pdf.SetFont("helvetica", "", 8)
		    pdf.Cell(0, 5, "8pt: Small text for footnotes or fine print.", 0, 1)
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Cell(0, 6, "10pt: Standard body text size for documents.", 0, 1)
		    pdf.SetFont("helvetica", "", 12)
		    pdf.Cell(0, 7, "12pt: Slightly larger body text.", 0, 1)
		    pdf.SetFont("helvetica", "", 14)
		    pdf.Cell(0, 8, "14pt: Sub-heading size text.", 0, 1)
		    pdf.SetFont("helvetica", "B", 18)
		    pdf.Cell(0, 10, "18pt: Section heading size.", 0, 1)
		    pdf.SetFont("helvetica", "B", 24)
		    pdf.Cell(0, 13, "24pt: Title size text.", 0, 1)

		    // Mixed fonts in flowing text
		    pdf.Ln(5)
		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "6. Mixed Fonts in Flowing Text:", 0, 1)
		    pdf.Ln(2)

		    pdf.SetFont("helvetica", "", 10)
		    pdf.Write(6, "This sentence starts in Helvetica, then switches to ")
		    pdf.SetFont("times", "I", 10)
		    pdf.Write(6, "Times Italic for emphasis")
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Write(6, ", then to ")
		    pdf.SetFont("courier", "", 10)
		    pdf.Write(6, "Courier for code")
		    pdf.SetFont("helvetica", "", 10)
		    pdf.Write(6, ", and back to Helvetica. Each PDF core font has a distinct look.")

		    // ---- Section 7: TrueType System Fonts ----
		    pdf.AddPage()
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "Text Layout Examples (continued)", 0, 1, "C")
		    pdf.Ln(5)

		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "7. TrueType System Fonts:", 0, 1)
		    pdf.Ln(2)

		    pdf.SetFont("helvetica", "", 9)
		    pdf.Cell(0, 6, "Loading TrueType fonts from system directories (platform-specific paths).", 0, 1)
		    pdf.Ln(3)

		    // Define font candidates per platform
		    // Each entry: font family name, display label, file path
		    Dim ttfFonts() As String
		    Dim ttfLabels() As String
		    Dim ttfPaths() As String

		    #If TargetiOS Or TargetAndroid Then
		      // iOS: bundled fonts only - skip TrueType section
		      pdf.SetFont("helvetica", "I", 10)
		      pdf.Cell(0, 6, "iOS: TrueType fonts must be bundled with the app. See Example 5.", 0, 1)

		    #ElseIf TargetWindows Then
		      ttfFonts.Add("Arial")
		      ttfLabels.Add("Arial (sans-serif)")
		      ttfPaths.Add("C:\Windows\Fonts\arial.ttf")

		      ttfFonts.Add("Georgia")
		      ttfLabels.Add("Georgia (serif)")
		      ttfPaths.Add("C:\Windows\Fonts\georgia.ttf")

		      ttfFonts.Add("Verdana")
		      ttfLabels.Add("Verdana (sans-serif)")
		      ttfPaths.Add("C:\Windows\Fonts\verdana.ttf")

		      ttfFonts.Add("Trebuchet MS")
		      ttfLabels.Add("Trebuchet MS (sans-serif)")
		      ttfPaths.Add("C:\Windows\Fonts\trebuc.ttf")

		      ttfFonts.Add("Segoe UI")
		      ttfLabels.Add("Segoe UI (sans-serif)")
		      ttfPaths.Add("C:\Windows\Fonts\segoeui.ttf")

		    #ElseIf TargetLinux Then
		      ttfFonts.Add("DejaVu Sans")
		      ttfLabels.Add("DejaVu Sans (sans-serif)")
		      ttfPaths.Add("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")

		      ttfFonts.Add("DejaVu Serif")
		      ttfLabels.Add("DejaVu Serif (serif)")
		      ttfPaths.Add("/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf")

		      ttfFonts.Add("Liberation Sans")
		      ttfLabels.Add("Liberation Sans (sans-serif)")
		      ttfPaths.Add("/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf")

		      ttfFonts.Add("Liberation Serif")
		      ttfLabels.Add("Liberation Serif (serif)")
		      ttfPaths.Add("/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf")

		    #Else
		      // macOS
		      ttfFonts.Add("Arial")
		      ttfLabels.Add("Arial (sans-serif)")
		      ttfPaths.Add("/System/Library/Fonts/Supplemental/Arial.ttf")

		      ttfFonts.Add("Georgia")
		      ttfLabels.Add("Georgia (serif)")
		      ttfPaths.Add("/System/Library/Fonts/Supplemental/Georgia.ttf")

		      ttfFonts.Add("Verdana")
		      ttfLabels.Add("Verdana (sans-serif)")
		      ttfPaths.Add("/System/Library/Fonts/Supplemental/Verdana.ttf")

		      ttfFonts.Add("Trebuchet MS")
		      ttfLabels.Add("Trebuchet MS (sans-serif)")
		      ttfPaths.Add("/System/Library/Fonts/Supplemental/Trebuchet MS.ttf")

		      ttfFonts.Add("Palatino")
		      ttfLabels.Add("Palatino (serif)")
		      ttfPaths.Add("/System/Library/Fonts/Palatino.ttc")

		    #EndIf

		    #If Not TargetiOS And Not TargetAndroid Then
		      Dim kTestPhrase As String = "The quick brown fox jumps over the lazy dog. 0123456789"

		      For i As Integer = 0 To ttfFonts.LastIndex
		        Dim ttfName As String = ttfFonts(i)
		        Dim ttfLabel As String = ttfLabels(i)
		        Dim ttfPath As String = ttfPaths(i)

		        Dim ttfFile As FolderItem = New FolderItem(ttfPath, FolderItem.PathModes.Native)
		        If ttfFile <> Nil And ttfFile.Exists Then
		          // Use unique internal name to avoid conflicts with core fonts
		          Dim internalName As String = "ttf_" + ttfName.Lowercase.ReplaceAll(" ", "_")
		          pdf.AddUTF8Font(internalName, "", ttfPath)

		          If pdf.Ok Then
		            pdf.SetFont(internalName, "", 10)
		            Dim testWidth As Double = pdf.GetStringWidth("A")
		            If testWidth > 0 Then
		              pdf.Cell(0, 6, ttfLabel + ": " + kTestPhrase, 0, 1)
		              statusText = statusText + "TrueType loaded: " + ttfLabel + EndOfLine
		            Else
		              pdf.SetFont("helvetica", "", 10)
		              pdf.SetTextColor(180, 0, 0)
		              pdf.Cell(0, 6, ttfLabel + ": loaded but glyphs not rendering (width=0)", 0, 1)
		              pdf.SetTextColor(0, 0, 0)
		              statusText = statusText + "TrueType broken: " + ttfLabel + EndOfLine
		            End If
		          Else
		            pdf.SetFont("helvetica", "", 10)
		            pdf.SetTextColor(180, 0, 0)
		            pdf.Cell(0, 6, ttfLabel + ": load error - " + pdf.GetError, 0, 1)
		            pdf.SetTextColor(0, 0, 0)
		            pdf.ClearError
		            statusText = statusText + "TrueType error: " + ttfLabel + EndOfLine
		          End If
		        Else
		          pdf.SetFont("helvetica", "I", 10)
		          pdf.SetTextColor(128, 128, 128)
		          pdf.Cell(0, 6, ttfLabel + ": not found at " + ttfPath, 0, 1)
		          pdf.SetTextColor(0, 0, 0)
		          statusText = statusText + "TrueType not found: " + ttfLabel + EndOfLine
		        End If
		      Next

		      // Summary
		      pdf.Ln(5)
		      pdf.SetFont("helvetica", "I", 9)
		      pdf.SetTextColor(100, 100, 100)
		      pdf.Cell(0, 5, "Note: TrueType fonts are loaded via AddUTF8Font() from platform-specific paths.", 0, 1)
		      pdf.Cell(0, 5, "Fonts that fail to render fall back to core PDF equivalents in HTML import.", 0, 1)
		      pdf.SetTextColor(0, 0, 0)
		    #EndIf

		    // ---- Section 8: Justified Text ----
		    pdf.AddPage()
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "Text Layout Examples (continued)", 0, 1, "C")
		    pdf.Ln(5)

		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "8. Justified Text (align ""J""):", 0, 1)
		    pdf.Ln(2)

		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetTextColor(100, 100, 100)
		    pdf.Cell(0, 5, "The ""J"" alignment distributes words evenly across the full width using PDF Tw (word spacing).", 0, 1)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(3)

		    // 8a. Cell with Justify
		    Dim kCellJustifyLabel As String = "8a. Cell with Justify alignment:"
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 7, kCellJustifyLabel, 0, 1)
		    pdf.Ln(1)

		    pdf.SetFont("helvetica", "", 10)
		    Dim kCellJustifyText As String = "This single line of text is justified across the full page width using Cell align J."
		    pdf.Cell(0, 7, kCellJustifyText, 1, 1, "J")
		    pdf.Ln(3)

		    // 8b. MultiCell with Justify
		    Dim kMultiCellJustifyLabel As String = "8b. MultiCell with Justify alignment:"
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 7, kMultiCellJustifyLabel, 0, 1)
		    pdf.Ln(1)

		    pdf.SetFont("helvetica", "", 10)
		    Dim kJustifyParagraph As String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
		    pdf.SetFillColor(245, 245, 255)
		    pdf.MultiCell(190, 6, kJustifyParagraph, 1, "J", True)
		    pdf.Ln(3)

		    // 8c. Comparison: Left vs Justify
		    Dim kComparisonLabel As String = "8c. Left-aligned vs Justified comparison:"
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 7, kComparisonLabel, 0, 1)
		    pdf.Ln(1)

		    Dim kCompareText As String = "This paragraph demonstrates the visual difference between left-aligned and justified text in PDF documents. Notice how justified text creates even margins on both sides, giving a more formal and polished appearance."

		    // Left-aligned
		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetFillColor(255, 245, 235)
		    pdf.Cell(90, 5, "Left-aligned (L):", 0, 1)
		    pdf.MultiCell(90, 5, kCompareText, 1, "L", True)
		    pdf.Ln(3)

		    // Justified
		    pdf.SetFillColor(235, 245, 255)
		    pdf.Cell(90, 5, "Justified (J):", 0, 1)
		    pdf.MultiCell(90, 5, kCompareText, 1, "J", True)
		    pdf.Ln(3)

		    // 8d. WriteAligned with Justify
		    Dim kWriteAlignedLabel As String = "8d. WriteAligned with Justify alignment:"
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 7, kWriteAlignedLabel, 0, 1)
		    pdf.Ln(1)

		    pdf.SetFont("helvetica", "", 10)
		    Dim kWriteAlignedText As String = "WriteAligned also supports justify mode. Each line except the last is evenly spaced across the specified width using the PDF Tw word spacing operator."
		    pdf.WriteAligned(190, 6, kWriteAlignedText, "J")
		    pdf.Ln(5)

		    pdf.SetFont("helvetica", "I", 9)
		    pdf.SetTextColor(100, 100, 100)
		    pdf.Cell(0, 5, "Note: The last line of justified text is always left-aligned, following standard typographic convention.", 0, 1)
		    pdf.SetTextColor(0, 0, 0)

		    // ---- Section 9: Color Object Overloads ----
		    pdf.AddPage()
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "Text Layout Examples (continued)", 0, 1, "C")
		    pdf.Ln(5)

		    pdf.SetFont("helvetica", "B", 12)
		    pdf.Cell(0, 8, "9. Color Object Overloads (Set/Get Color with Xojo Color):", 0, 1)
		    pdf.Ln(2)

		    pdf.SetFont("helvetica", "", 9)
		    pdf.SetTextColor(100, 100, 100)
		    pdf.Cell(0, 5, "Tests SetTextColor(Color), SetFillColor(Color), SetDrawColor(Color) and their Get counterparts.", 0, 1)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(3)

		    // 9a. SetTextColor with Color object
		    Dim kColorTestLabel9a As String = "9a. SetTextColor(Color) - text should appear in distinct colors:"
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 7, kColorTestLabel9a, 0, 1)
		    pdf.Ln(1)

		    pdf.SetFont("helvetica", "", 11)
		    pdf.SetTextColor(Color.RGB(255, 0, 0))
		    pdf.Cell(0, 7, "This text should be RED (255, 0, 0)", 0, 1)
		    pdf.SetTextColor(Color.RGB(0, 128, 0))
		    pdf.Cell(0, 7, "This text should be GREEN (0, 128, 0)", 0, 1)
		    pdf.SetTextColor(Color.RGB(0, 0, 255))
		    pdf.Cell(0, 7, "This text should be BLUE (0, 0, 255)", 0, 1)
		    pdf.SetTextColor(Color.RGB(255, 128, 0))
		    pdf.Cell(0, 7, "This text should be ORANGE (255, 128, 0)", 0, 1)
		    pdf.SetTextColor(Color.RGB(128, 0, 128))
		    pdf.Cell(0, 7, "This text should be PURPLE (128, 0, 128)", 0, 1)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(3)

		    // 9b. SetFillColor with Color object
		    Dim kColorTestLabel9b As String = "9b. SetFillColor(Color) - cells should have colored backgrounds:"
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 7, kColorTestLabel9b, 0, 1)
		    pdf.Ln(1)

		    pdf.SetFont("helvetica", "", 10)
		    pdf.SetFillColor(Color.RGB(255, 200, 200))
		    pdf.Cell(60, 7, "Light Red fill", 1, 0, "C", True)
		    pdf.SetFillColor(Color.RGB(200, 255, 200))
		    pdf.Cell(60, 7, "Light Green fill", 1, 0, "C", True)
		    pdf.SetFillColor(Color.RGB(200, 200, 255))
		    pdf.Cell(60, 7, "Light Blue fill", 1, 1, "C", True)
		    pdf.SetFillColor(Color.RGB(255, 255, 200))
		    pdf.Cell(60, 7, "Light Yellow fill", 1, 0, "C", True)
		    pdf.SetFillColor(Color.RGB(255, 200, 255))
		    pdf.Cell(60, 7, "Light Magenta fill", 1, 0, "C", True)
		    pdf.SetFillColor(Color.RGB(200, 255, 255))
		    pdf.Cell(60, 7, "Light Cyan fill", 1, 1, "C", True)
		    pdf.Ln(3)

		    // 9c. SetDrawColor with Color object
		    Dim kColorTestLabel9c As String = "9c. SetDrawColor(Color) - borders should appear in distinct colors:"
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 7, kColorTestLabel9c, 0, 1)
		    pdf.Ln(1)

		    pdf.SetFont("helvetica", "", 10)
		    pdf.SetLineWidth(1.0)
		    pdf.SetDrawColor(Color.RGB(255, 0, 0))
		    pdf.Rect(10, pdf.GetY, 40, 12, "D")
		    pdf.SetXY(12, pdf.GetY + 2)
		    pdf.Cell(36, 8, "Red border", 0, 0)

		    pdf.SetDrawColor(Color.RGB(0, 128, 0))
		    pdf.Rect(55, pdf.GetY - 2, 40, 12, "D")
		    pdf.SetXY(57, pdf.GetY - 2)
		    pdf.Cell(36, 8, "Green border", 0, 0)

		    pdf.SetDrawColor(Color.RGB(0, 0, 255))
		    pdf.Rect(100, pdf.GetY, 40, 12, "D")
		    pdf.SetXY(102, pdf.GetY)
		    pdf.Cell(36, 8, "Blue border", 0, 0)

		    pdf.SetDrawColor(0, 0, 0)
		    pdf.SetLineWidth(0.2)
		    pdf.SetY(pdf.GetY + 15)
		    pdf.Ln(3)

		    // 9d. GetTextColor / GetFillColor / GetDrawColor roundtrip test
		    Dim kColorTestLabel9d As String = "9d. Get*Color() roundtrip - set a Color, get it back, verify match:"
		    pdf.SetFont("helvetica", "B", 10)
		    pdf.Cell(0, 7, kColorTestLabel9d, 0, 1)
		    pdf.Ln(1)

		    pdf.SetFont("helvetica", "", 10)

		    // Test GetTextColor roundtrip
		    pdf.SetTextColor(Color.RGB(200, 50, 100))
		    Dim gotTextColor As Color = pdf.GetTextColor
		    Dim kTextColorPass As String = "GetTextColor: Set (200, 50, 100) -> Got (" + Str(gotTextColor.Red) + ", " + Str(gotTextColor.Green) + ", " + Str(gotTextColor.Blue) + ")"
		    If gotTextColor.Red = 200 And gotTextColor.Green = 50 And gotTextColor.Blue = 100 Then
		      pdf.SetTextColor(0, 128, 0)
		      pdf.Cell(0, 7, kTextColorPass + " PASS", 0, 1)
		    Else
		      pdf.SetTextColor(255, 0, 0)
		      pdf.Cell(0, 7, kTextColorPass + " FAIL", 0, 1)
		    End If

		    // Test GetFillColor roundtrip
		    pdf.SetTextColor(0, 0, 0)
		    pdf.SetFillColor(Color.RGB(50, 150, 250))
		    Dim gotFillColor As Color = pdf.GetFillColor
		    Dim kFillColorPass As String = "GetFillColor: Set (50, 150, 250) -> Got (" + Str(gotFillColor.Red) + ", " + Str(gotFillColor.Green) + ", " + Str(gotFillColor.Blue) + ")"
		    If gotFillColor.Red = 50 And gotFillColor.Green = 150 And gotFillColor.Blue = 250 Then
		      pdf.SetTextColor(0, 128, 0)
		      pdf.Cell(0, 7, kFillColorPass + " PASS", 0, 1)
		    Else
		      pdf.SetTextColor(255, 0, 0)
		      pdf.Cell(0, 7, kFillColorPass + " FAIL", 0, 1)
		    End If

		    // Test GetDrawColor roundtrip
		    pdf.SetTextColor(0, 0, 0)
		    pdf.SetDrawColor(Color.RGB(100, 200, 75))
		    Dim gotDrawColor As Color = pdf.GetDrawColor
		    Dim kDrawColorPass As String = "GetDrawColor: Set (100, 200, 75) -> Got (" + Str(gotDrawColor.Red) + ", " + Str(gotDrawColor.Green) + ", " + Str(gotDrawColor.Blue) + ")"
		    If gotDrawColor.Red = 100 And gotDrawColor.Green = 200 And gotDrawColor.Blue = 75 Then
		      pdf.SetTextColor(0, 128, 0)
		      pdf.Cell(0, 7, kDrawColorPass + " PASS", 0, 1)
		    Else
		      pdf.SetTextColor(255, 0, 0)
		      pdf.Cell(0, 7, kDrawColorPass + " FAIL", 0, 1)
		    End If

		    // Reset colors
		    pdf.SetTextColor(0, 0, 0)
		    pdf.SetFillColor(255, 255, 255)
		    pdf.SetDrawColor(0, 0, 0)

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
		  
		  result.Value("message") = statusText
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
		        result.Value("message") = statusText
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
		      result.Value("message") = statusText
		      result.Value("filename") = ""
		      Return result
		    #Else
		      // Web: No file system access, requires user to upload PDF via WebDialogPDFUpload
		      statusText = statusText + "✗ ERROR: No source PDF path provided" + EndOfLine
		      result.Value("success") = False
		      result.Value("message") = statusText
		      result.Value("filename") = ""
		      Return result
		    #EndIf
		  End If
		  
		  // Create PDF with Xojo-compatible property syntax
		  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)

		  pdf.Title = "Example 20 - PDF Import"
		  pdf.Author = "VNS PDF Library"
		  pdf.Subject = "Importing pages from existing PDFs"

		  statusText = statusText + "Source PDF: " + sourcePath + EndOfLine + EndOfLine
		  
		  // Open source PDF
		  Dim pageCount As Integer = pdf.SetSourceFile(sourcePath)
		  
		  If pdf.Err() Then
		    statusText = statusText + "✗ ERROR: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    result.Value("filename") = ""
		    Return result
		  End If
		  
		  statusText = statusText + "✓ Opened PDF successfully" + EndOfLine
		  statusText = statusText + "  Pages found: " + Str(pageCount) + EndOfLine + EndOfLine

		  // Title page (first page already added by constructor)
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
		    pdf.AddPage()
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
		    result.Value("message") = statusText
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
		  result.Value("message") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample21() As Dictionary
		  // Example 21: UTF-8 text with all Google Translate languages
		  // suggested and started by Martin Trippensee
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 21: UTF-8 Text all Google Translate languages..." + EndOfLine
		  statusText = statusText + "Tests all languages supported by Google Translate..." + EndOfLine
		  
		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument()
		    
		    // Title with core font
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "UTF-8 Text all Google Translate languages", 0, 1, "C")
		    pdf.Ln(5)
		    
		    Dim fontPath As String
		    Dim fontFile As FolderItem
		    Dim fontLoaded As Boolean = False
		    
		    #If TargetDesktop Or TargetConsole Or TargetWeb Then
		      // Desktop/Console/Web: Load Arial Unicode MS (excellent Unicode coverage)
		      // Note: Arial Unicode MS has very good coverage for most languages
		      // Some rare scripts (Ethiopic, Myanmar, Thaana, Canadian Aboriginal, Khmer,
		      // Meetei Mayek, N'Ko, Ol Chiki, Sinhala, Tifinagh) may lack glyphs
		      
		      // Use Arial Unicode MS (system font with excellent coverage)
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
		      
		      If fontFile <> Nil And fontFile.Exists Then
		        statusText = statusText + "Font file found: " + fontPath + EndOfLine
		        
		        // Load TrueType font from file path
		        pdf.AddUTF8Font("unicode_ttf", "", fontPath)
		        
		        If pdf.Error = "" Then
		          statusText = statusText + "Font loaded successfully!" + EndOfLine
		          fontLoaded = True
		        Else
		          statusText = statusText + "Error loading font: " + pdf.Error + EndOfLine
		        End If
		      Else
		        statusText = statusText + "Font file not found: " + fontPath + EndOfLine
		      End If
		      
		    #ElseIf TargetiOS Then
		      // iOS: Load font from bundled resources
		      Dim fontResource As FolderItem
		      Try
		        fontResource = SpecialFolder.Resource("ArialUnicode.ttf")
		        If fontResource <> Nil And fontResource.Exists Then
		          statusText = statusText + "Font resource found: ArialUnicode.ttf" + EndOfLine
		          
		          // Load font from file
		          Dim fontStream As BinaryStream = BinaryStream.Open(fontResource)
		          Dim fontData As String = fontStream.Read(fontStream.Length)
		          fontStream.Close()
		          
		          // Convert String to MemoryBlock for AddUTF8FontFromBytes
		          Dim fontMB As New MemoryBlock(fontData.Bytes)
		          fontMB.StringValue(0, fontData.Bytes) = fontData
		          
		          pdf.AddUTF8FontFromBytes("unicode_ttf", "", fontMB)
		          
		          If pdf.Error = "" Then
		            statusText = statusText + "Font loaded successfully!" + EndOfLine
		            fontLoaded = True
		          Else
		            statusText = statusText + "Error loading font: " + pdf.Error + EndOfLine
		          End If
		        Else
		          statusText = statusText + "Font resource not found: ArialUnicode.ttf" + EndOfLine
		        End If
		      Catch e As RuntimeException
		        statusText = statusText + "Error loading font resource: " + e.Message + EndOfLine
		      End Try
		    #EndIf
		    
		    If fontLoaded Then
		      // Comprehensive UTF-8 text examples with TrueType font
		      pdf.SetFont("unicode_ttf", "", 12)
		      
		      // Split language test constant by EndOfLine
		      Dim languages() As String = gkLanguageTest.ToArray(EndOfLine)
		      
		      For Each lang As String In languages
		        pdf.Cell(0, 7, lang, 1, 1)
		        pdf.Ln(2)
		      Next
		      
		    Else
		      // Font file/resource not found - show fallback message
		      pdf.SetFont("helvetica", "", 12)
		      pdf.Cell(0, 8, "TrueType font file not found", 0, 1)
		      pdf.Ln(5)
		      
		      pdf.SetFont("helvetica", "B", 10)
		      pdf.Cell(0, 5, "For complete Unicode coverage (all 250+ languages):", 0, 1)
		      pdf.SetFont("helvetica", "", 9)
		      pdf.MultiCell(0, 5, "Install Arial Unicode MS or download Noto Sans from https://fonts.google.com/noto", 0)
		      
		      #If TargetDesktop Or TargetConsole Or TargetWeb Then
		        pdf.Ln(3)
		        pdf.SetFont("helvetica", "", 9)
		        pdf.Cell(0, 5, "Or try these system font paths (limited coverage):", 0, 1)
		        pdf.SetFont("courier", "", 7)
		        pdf.Cell(0, 4, "macOS: /System/Library/Fonts/Supplemental/Arial Unicode.ttf", 0, 1)
		        pdf.Cell(0, 4, "macOS: /System/Library/Fonts/Geneva.ttf", 0, 1)
		        pdf.Cell(0, 4, "Windows: C:\\Windows\\Fonts\\arial.ttf", 0, 1)
		        pdf.Cell(0, 4, "Windows: C:\\Windows\\Fonts\\seguiemj.ttf", 0, 1)
		        pdf.Cell(0, 4, "Linux: /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 0, 1)
		      #ElseIf TargetiOS Then
		        pdf.Ln(3)
		        pdf.Cell(0, 6, "iOS Instructions:", 0, 1)
		        pdf.SetFont("courier", "", 8)
		        pdf.Cell(0, 5, "Add ArialUnicode.ttf to Resources folder in Xojo project", 0, 1)
		      #EndIf
		    End If
		    
		    // Generate PDF
		    Dim pdfBytes As String = pdf.Output()
		    
		    If pdf.Error <> "" Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("error") = pdf.Error
		    Else
		      statusText = statusText + "Success! PDF generated." + EndOfLine
		      result.Value("pdf") = pdfBytes
		      result.Value("filename") = "example21_all_languages.pdf"
		      result.Value("passed") = True
		    End If
		    
		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		    result.Value("passed") = False
		  End Try
		  
		  result.Value("message") = statusText
		  result.Value("output") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample22() As Dictionary
		  // Example 22: VNS PDF Graphics Demonstration
		  // Compares Xojo's native PDFDocument (limited Unicode) with VNSPDFDocument (full Unicode)
		  // Demonstrates underline support, font style combinations, and Phase 6 features
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 22: VNS PDF Graphics..." + EndOfLine
		  statusText = statusText + "Demonstrates font styles, Unicode support, and Phase 6 features..." + EndOfLine
		  
		  #If TargetDesktop Then
		    // This example only works on Desktop (Xojo PDFDocument is Desktop-only)
		    Try
		      // --- PART 1: Native Xojo PDFDocument (LIMITED UNICODE) ---
		      statusText = statusText + EndOfLine + "Creating PDF with Xojo PDFDocument (limited Unicode)..." + EndOfLine
		      
		      Dim pdf1 As New PDFDocument(PDFDocument.PageSizes.A4)
		      pdf1.Title = "Xojo PDFDocument - Limited Unicode"
		      pdf1.Author = "VNS PDF Examples"

		      Dim g1 As Graphics = pdf1.Graphics

		      // Add TOC entries
		      Dim toc1 As New PDFTOCEntry
		      toc1.Title = "1. Xojo PDFDocument - Unicode & Font Styles"
		      toc1.Page = 1
		      pdf1.AddTOCEntry(toc1)

		      Dim toc2 As New PDFTOCEntry
		      toc2.Title = "2. Xojo PDFDocument - Advanced Features"
		      toc2.Page = 2
		      pdf1.AddTOCEntry(toc2)

		      Dim toc3 As New PDFTOCEntry
		      toc3.Title = "3. Xojo PDFDocument - Clipping Methods Demo"
		      toc3.Page = 3
		      pdf1.AddTOCEntry(toc3)

		      Dim toc4 As New PDFTOCEntry
		      toc4.Title = "4. Xojo PDFDocument - DrawObject Demo"
		      toc4.Page = 4
		      pdf1.AddTOCEntry(toc4)

		      Dim toc5 As New PDFTOCEntry
		      toc5.Title = "5. Xojo PDFDocument - Brush Demo"
		      toc5.Page = 5
		      pdf1.AddTOCEntry(toc5)

		      // Header
		      g1.FontName = "Helvetica"
		      g1.FontSize = 16
		      g1.Bold = True
		      g1.DrawingColor = &c000000
		      g1.DrawText("Xojo PDFDocument (Native)", 72, 72)
		      
		      // Description
		      g1.FontSize = 10
		      g1.Bold = False
		      g1.DrawText("Limited Unicode support - many scripts will show as squares", 72, 92)
		      
		      // Unicode Test - will show missing glyphs for many scripts
		      g1.FontSize = 11
		      Dim yPos As Double = 120
		      
		      g1.DrawText("English: Hello World", 72, yPos)
		      yPos = yPos + 20
		      g1.DrawText("Chinese: 你好世界", 72, yPos)
		      yPos = yPos + 20
		      g1.DrawText("Arabic: مرحبا بالعالم", 72, yPos)
		      yPos = yPos + 20
		      g1.DrawText("Hindi: नमस्ते दुनिया", 72, yPos)
		      yPos = yPos + 20
		      g1.DrawText("Thai: สวัสดีชาวโลก", 72, yPos)
		      yPos = yPos + 20
		      g1.DrawText("Hebrew: שלום עולם", 72, yPos)
		      yPos = yPos + 20
		      g1.DrawText("Japanese: こんにちは世界", 72, yPos)
		      yPos = yPos + 20
		      g1.DrawText("Korean: 안녕하세요 세계", 72, yPos)
		      yPos = yPos + 20
		      g1.DrawText("Greek: Γεια σου κόσμε", 72, yPos)
		      
		      // Font style demonstrations
		      yPos = yPos + 30
		      g1.FontName = "Helvetica"
		      g1.FontSize = 12
		      g1.DrawingColor = &c000000
		      
		      // Plain
		      g1.Bold = False
		      g1.Italic = False
		      g1.Underline = False
		      g1.DrawText("Plain text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Bold
		      g1.Bold = True
		      g1.Italic = False
		      g1.Underline = False
		      g1.DrawText("Bold text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Italic
		      g1.Bold = False
		      g1.Italic = True
		      g1.Underline = False
		      g1.DrawText("Italic text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Bold + Italic
		      g1.Bold = True
		      g1.Italic = True
		      g1.Underline = False
		      g1.DrawText("Bold + Italic text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Underline
		      g1.Bold = False
		      g1.Italic = False
		      g1.Underline = True
		      g1.DrawText("Underlined text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Bold + Underline
		      g1.Bold = True
		      g1.Italic = False
		      g1.Underline = True
		      g1.DrawText("Bold + Underlined text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Italic + Underline
		      g1.Bold = False
		      g1.Italic = True
		      g1.Underline = True
		      g1.DrawText("Italic + Underlined text", 72, yPos)
		      yPos = yPos + 18
		      
		      // All three
		      g1.Bold = True
		      g1.Italic = True
		      g1.Underline = True
		      g1.DrawText("Bold + Italic + Underlined text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Graphics features
		      yPos = yPos + 15
		      g1.Bold = False
		      g1.Italic = False
		      g1.Underline = False
		      g1.DrawingColor = &cFF0000
		      g1.FillRectangle(72, yPos, 100, 30)
		      g1.DrawingColor = &c0000FF
		      g1.DrawOval(180, yPos, 50, 30)
		      
		      // PHASE 6 FEATURES - Line Cap Styles
		      yPos = yPos + 50
		      g1.DrawingColor = &c000000
		      g1.FontSize = 10
		      g1.Bold = True
		      g1.Italic = False
		      g1.Underline = False
		      g1.DrawText("Phase 6 Features:", 72, yPos)
		      yPos = yPos + 20
		      
		      g1.Bold = False
		      g1.FontSize = 8
		      g1.DrawText("Line Cap Styles:", 72, yPos)
		      yPos = yPos + 12
		      
		      // Butt cap (0)
		      g1.PenSize = 8
		      g1.LineCap = Graphics.LineCapTypes.Butt
		      g1.DrawLine(72, yPos, 150, yPos)
		      g1.PenSize = 1
		      g1.DrawingColor = &cFF0000
		      g1.DrawLine(72, yPos - 10, 72, yPos + 10)
		      g1.DrawLine(150, yPos - 10, 150, yPos + 10)
		      g1.DrawingColor = &c000000
		      g1.DrawText("Butt (0)", 160, yPos + 3)
		      yPos = yPos + 18
		      
		      // Round cap (1)
		      g1.PenSize = 8
		      g1.LineCap = Graphics.LineCapTypes.Round
		      g1.DrawLine(72, yPos, 150, yPos)
		      g1.PenSize = 1
		      g1.DrawingColor = &cFF0000
		      g1.DrawLine(72, yPos - 10, 72, yPos + 10)
		      g1.DrawLine(150, yPos - 10, 150, yPos + 10)
		      g1.DrawingColor = &c000000
		      g1.DrawText("Round (1)", 160, yPos + 3)
		      yPos = yPos + 18
		      
		      // Square cap (2)
		      g1.PenSize = 8
		      g1.LineCap = Graphics.LineCapTypes.Square
		      g1.DrawLine(72, yPos, 150, yPos)
		      g1.PenSize = 1
		      g1.DrawingColor = &cFF0000
		      g1.DrawLine(72, yPos - 10, 72, yPos + 10)
		      g1.DrawLine(150, yPos - 10, 150, yPos + 10)
		      g1.DrawingColor = &c000000
		      g1.DrawText("Square (2)", 160, yPos + 3)
		      yPos = yPos + 20
		      
		      // Line Join Styles
		      g1.DrawText("Line Join Styles:", 72, yPos)
		      yPos = yPos + 12
		      
		      // Miter join (0)
		      g1.PenSize = 4
		      g1.LineJoin = Graphics.LineJoinTypes.Miter
		      Dim pts1(5) As Integer
		      pts1(0) = 72
		      pts1(1) = yPos + 15
		      pts1(2) = 100
		      pts1(3) = yPos
		      pts1(4) = 128
		      pts1(5) = yPos + 15
		      Dim path1 As New GraphicsPath
		      path1.MoveToPoint(pts1(0), pts1(1))
		      path1.AddLineToPoint(pts1(2), pts1(3))
		      path1.AddLineToPoint(pts1(4), pts1(5))
		      g1.DrawPath(path1)
		      g1.PenSize = 1
		      g1.DrawText("Miter (0)", 140, yPos + 8)
		      yPos = yPos + 20
		      
		      // Round join (1)
		      g1.PenSize = 4
		      g1.LineJoin = Graphics.LineJoinTypes.Round
		      Dim pts2(5) As Integer
		      pts2(0) = 72
		      pts2(1) = yPos + 15
		      pts2(2) = 100
		      pts2(3) = yPos
		      pts2(4) = 128
		      pts2(5) = yPos + 15
		      Dim path2 As New GraphicsPath
		      path2.MoveToPoint(pts2(0), pts2(1))
		      path2.AddLineToPoint(pts2(2), pts2(3))
		      path2.AddLineToPoint(pts2(4), pts2(5))
		      g1.DrawPath(path2)
		      g1.PenSize = 1
		      g1.DrawText("Round (1)", 140, yPos + 8)
		      yPos = yPos + 20
		      
		      // Bevel join (2)
		      g1.PenSize = 4
		      g1.LineJoin = Graphics.LineJoinTypes.Bevel
		      Dim pts3(5) As Integer
		      pts3(0) = 72
		      pts3(1) = yPos + 15
		      pts3(2) = 100
		      pts3(3) = yPos
		      pts3(4) = 128
		      pts3(5) = yPos + 15
		      Dim path3 As New GraphicsPath
		      path3.MoveToPoint(pts3(0), pts3(1))
		      path3.AddLineToPoint(pts3(2), pts3(3))
		      path3.AddLineToPoint(pts3(4), pts3(5))
		      g1.DrawPath(path3)
		      g1.PenSize = 1
		      g1.DrawText("Bevel (2)", 140, yPos + 8)
		      yPos = yPos + 20
		      
		      // Dashed Lines
		      g1.DrawText("Dashed Lines (LineDash):", 72, yPos)
		      yPos = yPos + 12
		      
		      g1.PenSize = 2
		      g1.LineJoin = Graphics.LineJoinTypes.Miter
		      g1.LineCap = Graphics.LineCapTypes.Butt
		      
		      g1.LineDash = Array(5.0, 5.0)
		      g1.DrawLine(72, yPos, 200, yPos)
		      g1.PenSize = 1
		      g1.DrawText("[5, 5]", 210, yPos + 3)
		      yPos = yPos + 12
		      
		      g1.LineDash = Array(10.0, 3.0)
		      g1.PenSize = 2
		      g1.DrawLine(72, yPos, 200, yPos)
		      g1.PenSize = 1
		      g1.DrawText("[10, 3]", 210, yPos + 3)
		      yPos = yPos + 12
		      
		      g1.LineDash = Array(8.0, 3.0, 2.0, 3.0)
		      g1.PenSize = 2
		      g1.DrawLine(72, yPos, 200, yPos)
		      g1.PenSize = 1
		      g1.DrawText("[8, 3, 2, 3]", 210, yPos + 3)
		      
		      // Reset to solid line
		      g1.LineDash = Nil
		      yPos = yPos + 20
		      
		      // Character Spacing
		      g1.DrawText("Character Spacing:", 72, yPos)
		      yPos = yPos + 12
		      
		      g1.FontSize = 10
		      g1.CharacterSpacing = 0
		      g1.DrawText("Normal spacing (0)", 72, yPos)
		      yPos = yPos + 15
		      
		      g1.CharacterSpacing = 2
		      g1.DrawText("Wide spacing (2)", 72, yPos)
		      yPos = yPos + 15
		      
		      g1.CharacterSpacing = 5
		      g1.DrawText("Very wide (5)", 72, yPos)
		      g1.CharacterSpacing = 0
		      yPos = yPos + 20
		      
		      // Polygons
		      g1.FontSize = 8
		      g1.DrawText("Polygons (autoClose=True):", 72, yPos)
		      yPos = yPos + 12

		      // Draw triangle (outline) - using autoClose instead of manual close
		      g1.DrawingColor = &c0000FF
		      Dim trianglePath As New GraphicsPath
		      trianglePath.MoveToPoint(80, yPos + 20)
		      trianglePath.AddLineToPoint(110, yPos)
		      trianglePath.AddLineToPoint(140, yPos + 20)
		      // No manual close needed - autoClose handles it!
		      g1.DrawPath(trianglePath, True)  // autoClose = True

		      // Fill pentagon - using autoClose instead of manual close
		      g1.DrawingColor = &cFF9900
		      Dim pentagonPath As New GraphicsPath
		      pentagonPath.MoveToPoint(170, yPos + 5)
		      pentagonPath.AddLineToPoint(190, yPos + 10)
		      pentagonPath.AddLineToPoint(185, yPos + 22)
		      pentagonPath.AddLineToPoint(155, yPos + 22)
		      pentagonPath.AddLineToPoint(150, yPos + 10)
		      // No manual close needed - autoClose handles it!
		      g1.FillPath(pentagonPath, True)  // autoClose = True
		      yPos = yPos + 30
		      
		      // ClearRectangle demonstration
		      g1.DrawingColor = &c000000
		      g1.DrawText("ClearRectangle:", 72, yPos)
		      yPos = yPos + 12
		      
		      g1.DrawingColor = &c00CC00
		      g1.FillRectangle(72, yPos, 100, 25)
		      g1.ClearRectangle(90, yPos + 5, 40, 15)
		      g1.DrawingColor = &c000000
		      g1.DrawText("(cleared area)", 180, yPos + 12)
		      
		      g1.DrawingColor = &c000000
		      g1.FontSize = 9
		      g1.Italic = True
		      g1.Underline = False
		      g1.DrawText("Note: Missing glyphs show as squares □", 72, yPos + 40)

		      // --- PAGE 2: Advanced Features (Native Xojo PDFDocument) ---
		      g1.NextPage()
		      yPos = 72

		      g1.FontName = "Helvetica"
		      g1.FontSize = 16
		      g1.Bold = True
		      g1.Italic = False
		      g1.Underline = False
		      g1.DrawText("Advanced Features", 72, yPos)
		      yPos = yPos + 25

		      g1.DrawingColor = &c000000
		      g1.FontSize = 10
		      g1.Bold = False

		      // Feature 1: TextHeight with wrapWidth
		      g1.FontSize = 11
		      g1.Bold = True
		      g1.DrawText("1. TextHeight(text, wrapWidth) - Multi-line Height", 72, yPos)
		      yPos = yPos + 15

		      g1.FontSize = 9
		      g1.Bold = False
		      Dim longText1 As String = "This is a long text that will wrap across multiple lines when constrained to a specific width. The TextHeight method calculates how tall the wrapped text will be."
		      Dim wrapWidth1 As Double = 300 // points
		      Dim calculatedHeight1 As Double = g1.TextHeight(longText1, wrapWidth1)

		      g1.DrawText("Text: " + Chr(34) + longText1 + Chr(34), 72, yPos, 450)
		      yPos = yPos + 12
		      g1.DrawText("Wrap width: " + Str(wrapWidth1) + " points", 72, yPos)
		      yPos = yPos + 12
		      g1.DrawText("Calculated height: " + Format(calculatedHeight1, "0.0") + " points", 72, yPos)
		      yPos = yPos + 12

		      // Draw box showing the calculated dimensions
		      g1.DrawingColor = &cCCCCCC
		      g1.DrawRectangle(72, yPos, wrapWidth1, calculatedHeight1)

		      // Draw the wrapped text inside the box (manually wrap like VNS wrapper)
		      g1.DrawingColor = &c000000
		      Dim boxStartY1 As Double = yPos
		      Dim boxX1 As Double = 72
		      Dim words1() As String = longText1.Split(" ")
		      Dim currentLineY1 As Double = boxStartY1 + g1.FontSize * 1.2
		      Dim currentLine1 As String = ""

		      For i As Integer = 0 To words1.LastIndex
		        Dim testLine1 As String
		        If currentLine1 = "" Then
		          testLine1 = words1(i)
		        Else
		          testLine1 = currentLine1 + " " + words1(i)
		        End If

		        Dim testWidth1 As Double = g1.TextWidth(testLine1)

		        If testWidth1 > wrapWidth1 And currentLine1 <> "" Then
		          g1.DrawText(currentLine1, boxX1 + 3, currentLineY1)
		          currentLineY1 = currentLineY1 + g1.FontSize * 1.2
		          currentLine1 = words1(i)
		        Else
		          currentLine1 = testLine1
		        End If
		      Next

		      If currentLine1 <> "" Then
		        g1.DrawText(currentLine1, boxX1 + 3, currentLineY1)
		      End If

		      yPos = yPos + calculatedHeight1 + 15

		      // Feature 2: DrawText with condense parameter
		      g1.FontSize = 11
		      g1.Bold = True
		      g1.DrawText("2. DrawText(text, x, y, width, condense=True) - Horizontal Scaling", 72, yPos)
		      yPos = yPos + 15

		      g1.FontSize = 9
		      g1.Bold = False
		      Dim testText1 As String = "This text is too wide for the box!"

		      g1.DrawText("Without condense (truncated):", 72, yPos)
		      yPos = yPos + 12
		      g1.DrawingColor = &cCCCCCC
		      g1.DrawRectangle(72, yPos, 150, 15)
		      g1.DrawingColor = &c000000
		      g1.DrawText(testText1, 72, yPos + 3, 150, False)
		      yPos = yPos + 18

		      g1.DrawText("With condense=True (scaled to fit):", 72, yPos)
		      yPos = yPos + 12
		      g1.DrawingColor = &cCCCCCC
		      g1.DrawRectangle(72, yPos, 150, 15)
		      g1.DrawingColor = &c000000
		      g1.DrawText(testText1, 72, yPos + 3, 150, True)
		      yPos = yPos + 25

		      // Feature 3: Font Properties
		      g1.FontSize = 11
		      g1.Bold = True
		      g1.DrawText("3. Font Properties - Individual Font Settings", 72, yPos)
		      yPos = yPos + 15

		      g1.FontSize = 10
		      g1.Bold = False
		      g1.DrawText("Current FontName: " + g1.FontName, 72, yPos)
		      yPos = yPos + 12
		      g1.DrawText("Current FontSize: " + Str(g1.FontSize), 72, yPos)
		      yPos = yPos + 12

		      g1.FontName = "Times"
		      g1.FontSize = 14
		      g1.Bold = True
		      g1.Italic = True
		      g1.DrawText("Times 14pt Bold Italic", 72, yPos)
		      yPos = yPos + 15

		      g1.FontName = "Helvetica"
		      g1.FontSize = 10
		      g1.Bold = False
		      g1.Italic = False
		      g1.DrawText("Back to Helvetica 10pt normal", 72, yPos)
		      yPos = yPos + 25

		      // Feature 4: Transformation Methods (Rotate, Translate)
		      g1.FontSize = 11
		      g1.Bold = True
		      g1.DrawText("4. Transformation Methods - Rotate & Translate (NEW!)", 72, yPos)
		      yPos = yPos + 15

		      g1.FontSize = 9
		      g1.Bold = False

		      // Demonstrate Translate
		      g1.DrawText("Translate(x, y) - Shift coordinate system:", 72, yPos)
		      yPos = yPos + 15

		      // Draw reference rectangle
		      g1.DrawingColor = &cCCCCCC
		      g1.DrawRectangle(72, yPos, 60, 40)
		      g1.DrawingColor = &c000000
		      g1.FontSize = 7
		      g1.DrawText("Origin", 80, yPos + 20)

		      // Apply translation and draw translated rectangle
		      g1.SaveState()
		      g1.Translate(100, 0) // Shift 100 points right
		      g1.DrawingColor = &c0000FF
		      g1.DrawRectangle(72, yPos, 60, 40)
		      g1.DrawingColor = &c000000
		      g1.DrawText("Translated", 75, yPos + 20)
		      g1.RestoreState()

		      yPos = yPos + 50

		      // Demonstrate Rotate
		      g1.FontSize = 9
		      g1.DrawText("Rotate(angle) - Rotate around current position:", 72, yPos)
		      yPos = yPos + 15

		      // Draw reference text
		      g1.DrawingColor = &cCCCCCC
		      g1.DrawText("Normal", 100, yPos + 20)

		      // Apply rotation and draw rotated text
		      g1.SaveState()
		      g1.Translate(250, yPos + 20) // Move to rotation point
		      g1.Rotate(45) // Rotate 45 degrees
		      g1.DrawingColor = &cFF0000
		      g1.DrawText("Rotated 45°", 0, 0)
		      g1.RestoreState()

		      // Rotated Chinese text (30 degrees)
		      g1.SaveState()
		      g1.Translate(380, yPos + 20)
		      g1.Rotate(30)
		      g1.DrawingColor = &c0000FF
		      g1.DrawText("中文旋转", 0, 0)
		      g1.RestoreState()

		      // Rotated Arabic text (45 degrees)
		      g1.SaveState()
		      g1.Translate(500, yPos + 20)
		      g1.Rotate(45)
		      g1.DrawingColor = &c008000  // Green
		      g1.DrawText("مرحبا", 0, 0)
		      g1.RestoreState()

		      yPos = yPos + 40
		      g1.DrawingColor = &c000000

		      // Feature 5: DrawTextBlock - NOT available on Desktop PDFGraphics
		      // Xojo's PDFGraphics.DrawTextBlock is Android-only (not Desktop)
		      // VNSPDFGraphics provides DrawTextBlock on ALL platforms!
		      g1.FontSize = 11
		      g1.Bold = True
		      g1.Italic = False
		      g1.Underline = False
		      g1.DrawText("5. DrawTextBlock - Word-wrap with Alignment", 72, yPos)
		      yPos = yPos + 18

		      g1.FontSize = 9
		      g1.Bold = False
		      g1.DrawingColor = &cFF0000
		      g1.DrawText("NOT AVAILABLE: Xojo PDFGraphics.DrawTextBlock is Android-only", 72, yPos)
		      yPos = yPos + 15
		      g1.DrawingColor = &c000000
		      g1.DrawText("See VNSPDFGraphics for Desktop DrawTextBlock support!", 72, yPos)
		      yPos = yPos + 25

		      // Add a sticky note annotation (Xojo native)
		      pdf1.AddAnnotation("This is a sticky note from Xojo's native PDFDocument.AddAnnotation method.", 400, 72)

		      // ========== PAGE 3: Clipping Methods Demo (Xojo Native) ==========
		      g1.NextPage()
		      yPos = 72

		      g1.Bold = True
		      g1.FontSize = 16
		      g1.DrawingColor = &c000080
		      g1.DrawText("6. Clipping Methods Demo (Xojo Native)", 72, yPos)
		      g1.Bold = False
		      yPos = yPos + 30

		      // Demo 1: Clip() function - the recommended way in Xojo
		      g1.FontSize = 10
		      g1.DrawingColor = &c000000
		      g1.DrawText("Clip() function - Returns new Graphics for clipped region:", 72, yPos)
		      yPos = yPos + 15

		      // Draw background rectangle to show clip area
		      g1.DrawingColor = &cEEEEEE
		      g1.FillRectangle(72, yPos, 280, 50)
		      g1.DrawingColor = &c000000
		      g1.DrawRectangle(72, yPos, 280, 50)

		      // Use Clip() which returns a new Graphics object in Xojo
		      // IMPORTANT: Coordinates are RELATIVE to clip origin (0,0 = top-left of clip)
		      Dim clippedXojo1 As Graphics = g1.Clip(72, yPos, 280, 50)
		      clippedXojo1.DrawingColor = &c0000FF
		      clippedXojo1.FontSize = 11
		      clippedXojo1.DrawText("English: Hello World - clipped text that extends beyond boundary", 3, 15)
		      clippedXojo1.DrawText("Second line also clipped to the rectangle region boundary here", 3, 32)
		      yPos = yPos + 65

		      // Demo 2: Another Clip() with different content
		      g1.DrawingColor = &c000000
		      g1.FontSize = 10
		      g1.DrawText("Another Clip() region - each returns independent Graphics:", 72, yPos)
		      yPos = yPos + 15

		      g1.DrawingColor = &cFFEEEE
		      g1.FillRectangle(72, yPos, 250, 50)
		      g1.DrawingColor = &c000000
		      g1.DrawRectangle(72, yPos, 250, 50)

		      // Coordinates relative to clip origin (0,0)
		      Dim clippedXojo2 As Graphics = g1.Clip(72, yPos, 250, 50)
		      clippedXojo2.DrawingColor = &cFF0000
		      clippedXojo2.FontSize = 12
		      clippedXojo2.DrawText("Clipped via Clip() function call - text extends past edge", 3, 18)
		      clippedXojo2.DrawText("Also clipped - cut off at edge boundary on the right side", 3, 36)
		      yPos = yPos + 65

		      // Demo 3: Shapes clipped
		      g1.DrawingColor = &c000000
		      g1.FontSize = 10
		      g1.DrawText("Clipped shapes - oval extends beyond clip boundary:", 72, yPos)
		      yPos = yPos + 15

		      g1.DrawingColor = &cEEFFEE
		      g1.FillRectangle(72, yPos, 120, 60)
		      g1.DrawingColor = &c000000
		      g1.DrawRectangle(72, yPos, 120, 60)

		      // Coordinates relative to clip origin - oval at (-20, -10) extends outside
		      Dim clippedXojo3 As Graphics = g1.Clip(72, yPos, 120, 60)
		      clippedXojo3.DrawingColor = &c00AA00
		      clippedXojo3.FillOval(-20, -10, 100, 80)  // Oval extends beyond clip
		      clippedXojo3.DrawingColor = &c000000
		      clippedXojo3.FontSize = 9
		      clippedXojo3.DrawText("Clipped oval", 15, 35)
		      yPos = yPos + 75

		      // Note about limitations
		      g1.DrawingColor = &c000000
		      g1.FontSize = 10
		      g1.DrawText("Xojo Clipping Limitations:", 72, yPos)
		      yPos = yPos + 15
		      g1.FontSize = 9
		      g1.DrawingColor = &c666666
		      g1.DrawText("- ClipToRectangle has no ClipEnd - clip persists on page", 72, yPos)
		      yPos = yPos + 12
		      g1.DrawText("- Clip() returns new Graphics - use this for multiple clips", 72, yPos)
		      yPos = yPos + 12
		      g1.DrawText("- ClipToPath limited - GraphicsPath doesn't expose points", 72, yPos)
		      yPos = yPos + 12
		      g1.DrawText("- VNSPDFGraphics provides ClipEnd() and polygon clipping", 72, yPos)
		      yPos = yPos + 25

		      // Summary
		      g1.FontSize = 8
		      g1.Italic = True
		      g1.DrawingColor = &c008000
		      g1.DrawText("Xojo clipping: Clip(), ClipToPath(), ClipToRectangle() - No ClipEnd() method", 72, yPos)
		      g1.Italic = False

		      // ========== PAGE 4: DrawObject Demo (Xojo Native) ==========
		      g1.NextPage()
		      yPos = 72

		      g1.FontName = "Helvetica"
		      g1.Bold = True
		      g1.FontSize = 16
		      g1.DrawingColor = &c000080
		      g1.DrawText("7. DrawObject Demo (Xojo Native)", 72, yPos)
		      g1.Bold = False
		      yPos = yPos + 30

		      g1.FontSize = 10
		      g1.DrawingColor = &c000000
		      g1.DrawText("DrawObject renders Object2D shapes (RectShape, OvalShape, etc.)", 72, yPos)
		      yPos = yPos + 25

		      // Demo 1: RectShape
		      g1.DrawText("RectShape - filled rectangle with border:", 72, yPos)
		      yPos = yPos + 15

		      Dim xRectShape As New RectShape
		      xRectShape.X = 72
		      xRectShape.Y = yPos
		      xRectShape.Width = 80
		      xRectShape.Height = 40
		      xRectShape.FillColor = Color.RGB(100, 150, 255)
		      xRectShape.FillOpacity = 100
		      xRectShape.BorderColor = Color.RGB(0, 0, 128)
		      xRectShape.BorderWidth = 2
		      xRectShape.BorderOpacity = 100
		      g1.DrawObject(xRectShape, 0, 0)

		      // RectShape with rotation (45 degrees)
		      Dim xRectRotated As New RectShape
		      xRectRotated.X = 200
		      xRectRotated.Y = yPos
		      xRectRotated.Width = 60
		      xRectRotated.Height = 30
		      xRectRotated.FillColor = Color.RGB(255, 200, 100)
		      xRectRotated.FillOpacity = 100
		      xRectRotated.BorderColor = Color.RGB(200, 100, 0)
		      xRectRotated.BorderWidth = 2
		      xRectRotated.BorderOpacity = 100
		      xRectRotated.Rotation = 0.785398  // 45 degrees in radians
		      g1.DrawObject(xRectRotated, 0, 0)

		      g1.DrawingColor = &c000000
		      g1.DrawText("Rotated 45°", 270, yPos + 20)
		      yPos = yPos + 55

		      // Demo 2: OvalShape
		      g1.DrawText("OvalShape - circle and ellipse (X,Y is CENTER):", 72, yPos)
		      yPos = yPos + 15

		      Dim xOvalShape As New OvalShape
		      xOvalShape.X = 120  // Center X
		      xOvalShape.Y = yPos + 25  // Center Y
		      xOvalShape.Width = 50
		      xOvalShape.Height = 50
		      xOvalShape.FillColor = Color.RGB(100, 200, 100)
		      xOvalShape.FillOpacity = 100
		      xOvalShape.BorderColor = Color.RGB(0, 100, 0)
		      xOvalShape.BorderWidth = 2
		      xOvalShape.BorderOpacity = 100
		      g1.DrawObject(xOvalShape, 0, 0)

		      Dim xEllipseShape As New OvalShape
		      xEllipseShape.X = 220
		      xEllipseShape.Y = yPos + 25
		      xEllipseShape.Width = 80
		      xEllipseShape.Height = 40
		      xEllipseShape.FillColor = Color.RGB(255, 150, 150)
		      xEllipseShape.FillOpacity = 100
		      xEllipseShape.BorderColor = Color.RGB(200, 0, 0)
		      xEllipseShape.BorderWidth = 2
		      xEllipseShape.BorderOpacity = 100
		      g1.DrawObject(xEllipseShape, 0, 0)
		      yPos = yPos + 60

		      // Demo 3: RoundRectShape
		      g1.DrawText("RoundRectShape - rounded corners (radius 15):", 72, yPos)
		      yPos = yPos + 15

		      Dim xRoundRect As New RoundRectShape
		      xRoundRect.X = 72
		      xRoundRect.Y = yPos
		      xRoundRect.Width = 100
		      xRoundRect.Height = 50
		      xRoundRect.CornerWidth = 15
		      xRoundRect.CornerHeight = 15
		      xRoundRect.FillColor = Color.RGB(200, 200, 255)
		      xRoundRect.FillOpacity = 100
		      xRoundRect.BorderColor = Color.RGB(100, 100, 200)
		      xRoundRect.BorderWidth = 2
		      xRoundRect.BorderOpacity = 100
		      g1.DrawObject(xRoundRect, 0, 0)

		      // Second RoundRectShape with larger radius
		      Dim xRoundRect2 As New RoundRectShape
		      xRoundRect2.X = 200
		      xRoundRect2.Y = yPos
		      xRoundRect2.Width = 80
		      xRoundRect2.Height = 50
		      xRoundRect2.CornerWidth = 25
		      xRoundRect2.CornerHeight = 25
		      xRoundRect2.FillColor = Color.RGB(255, 220, 200)
		      xRoundRect2.FillOpacity = 100
		      xRoundRect2.BorderColor = Color.RGB(200, 100, 50)
		      xRoundRect2.BorderWidth = 2
		      xRoundRect2.BorderOpacity = 100
		      g1.DrawObject(xRoundRect2, 0, 0)

		      g1.DrawingColor = &c000000
		      g1.DrawText("radius 25", 215, yPos + 30)
		      yPos = yPos + 65

		      // Demo 4: CurveShape (Bezier)
		      g1.DrawText("CurveShape - quadratic bezier curve:", 72, yPos)
		      yPos = yPos + 15

		      Dim xCurveShape As New CurveShape
		      xCurveShape.X = 72
		      xCurveShape.Y = yPos + 30
		      xCurveShape.X2 = 200
		      xCurveShape.Y2 = yPos + 30
		      xCurveShape.Order = 1  // Quadratic
		      xCurveShape.ControlX(0) = 136
		      xCurveShape.ControlY(0) = yPos - 20
		      xCurveShape.BorderColor = Color.RGB(200, 0, 200)
		      xCurveShape.BorderWidth = 3
		      xCurveShape.BorderOpacity = 100
		      g1.DrawObject(xCurveShape, 0, 0)
		      yPos = yPos + 45

		      // Demo 5: TextShape (Xojo native - limited UTF-8 support)
		      g1.DrawText("TextShape - styled text (Xojo native):", 72, yPos)
		      yPos = yPos + 15

		      Dim xTextShape As New TextShape
		      xTextShape.Text = "Hello TextShape!"
		      xTextShape.X = 72
		      xTextShape.Y = yPos + 12
		      xTextShape.FontName = "Helvetica"
		      xTextShape.FontSize = 12
		      xTextShape.Bold = True
		      xTextShape.FillColor = Color.RGB(0, 100, 0)
		      g1.DrawObject(xTextShape, 0, 0)

		      // UTF-8 TextShape (Chinese) - may not display correctly in native PDF
		      Dim xTextChinese As New TextShape
		      xTextChinese.Text = "中文: 你好世界"
		      xTextChinese.X = 72
		      xTextChinese.Y = yPos + 28
		      xTextChinese.FontName = "Helvetica"
		      xTextChinese.FontSize = 11
		      xTextChinese.FillColor = Color.RGB(0, 0, 150)
		      g1.DrawObject(xTextChinese, 0, 0)

		      // UTF-8 TextShape (Japanese)
		      Dim xTextJapanese As New TextShape
		      xTextJapanese.Text = "日本語: こんにちは"
		      xTextJapanese.X = 72
		      xTextJapanese.Y = yPos + 44
		      xTextJapanese.FontName = "Helvetica"
		      xTextJapanese.FontSize = 11
		      xTextJapanese.FillColor = Color.RGB(150, 0, 150)
		      g1.DrawObject(xTextJapanese, 0, 0)

		      // UTF-8 TextShape (Korean)
		      Dim xTextKorean As New TextShape
		      xTextKorean.Text = "한국어: 안녕하세요"
		      xTextKorean.X = 72
		      xTextKorean.Y = yPos + 60
		      xTextKorean.FontName = "Helvetica"
		      xTextKorean.FontSize = 11
		      xTextKorean.FillColor = Color.RGB(0, 150, 150)
		      g1.DrawObject(xTextKorean, 0, 0)

		      // UTF-8 TextShape (Arabic)
		      Dim xTextArabic As New TextShape
		      xTextArabic.Text = "العربية: مرحبا"
		      xTextArabic.X = 72
		      xTextArabic.Y = yPos + 76
		      xTextArabic.FontName = "Helvetica"
		      xTextArabic.FontSize = 11
		      xTextArabic.FillColor = Color.RGB(150, 100, 0)
		      g1.DrawObject(xTextArabic, 0, 0)

		      // Rotated text (45 degrees)
		      Dim xTextRotated As New TextShape
		      xTextRotated.Text = "Rotated 45°"
		      xTextRotated.X = 280
		      xTextRotated.Y = yPos + 20
		      xTextRotated.FontName = "Helvetica"
		      xTextRotated.FontSize = 12
		      xTextRotated.Bold = True
		      xTextRotated.FillColor = Color.RGB(200, 0, 0)
		      xTextRotated.Rotation = 0.785398  // 45 degrees in radians
		      g1.DrawObject(xTextRotated, 0, 0)

		      // Rotated UTF-8 text (Chinese 45 degrees)
		      Dim xTextRotatedChinese As New TextShape
		      xTextRotatedChinese.Text = "旋转中文 45°"
		      xTextRotatedChinese.X = 380
		      xTextRotatedChinese.Y = yPos + 20
		      xTextRotatedChinese.FontName = "Helvetica"
		      xTextRotatedChinese.FontSize = 12
		      xTextRotatedChinese.FillColor = Color.RGB(0, 100, 200)
		      xTextRotatedChinese.Rotation = 0.785398  // 45 degrees in radians
		      g1.DrawObject(xTextRotatedChinese, 0, 0)

		      // Rotated UTF-8 text (Japanese -30 degrees)
		      Dim xTextRotatedJapanese As New TextShape
		      xTextRotatedJapanese.Text = "回転テキスト"
		      xTextRotatedJapanese.X = 480
		      xTextRotatedJapanese.Y = yPos + 50
		      xTextRotatedJapanese.FontName = "Helvetica"
		      xTextRotatedJapanese.FontSize = 11
		      xTextRotatedJapanese.FillColor = Color.RGB(200, 0, 150)
		      xTextRotatedJapanese.Rotation = -0.523599  // -30 degrees in radians
		      g1.DrawObject(xTextRotatedJapanese, 0, 0)
		      yPos = yPos + 95

		      // Demo 6: Group2D
		      g1.DrawText("Group2D - multiple shapes as one unit:", 72, yPos)
		      yPos = yPos + 15

		      Dim xGroup As New Group2D

		      // Add rect to group
		      Dim xGroupRect As New RectShape
		      xGroupRect.X = 0
		      xGroupRect.Y = 0
		      xGroupRect.Width = 40
		      xGroupRect.Height = 30
		      xGroupRect.FillColor = Color.RGB(255, 255, 0)
		      xGroupRect.FillOpacity = 100
		      xGroupRect.BorderColor = Color.RGB(200, 200, 0)
		      xGroupRect.BorderWidth = 1
		      xGroupRect.BorderOpacity = 100
		      xGroup.AddObject(xGroupRect)

		      // Add oval to group
		      Dim xGroupOval As New OvalShape
		      xGroupOval.X = 50
		      xGroupOval.Y = 15
		      xGroupOval.Width = 30
		      xGroupOval.Height = 30
		      xGroupOval.FillColor = Color.RGB(0, 255, 255)
		      xGroupOval.FillOpacity = 100
		      xGroupOval.BorderColor = Color.RGB(0, 150, 150)
		      xGroupOval.BorderWidth = 1
		      xGroupOval.BorderOpacity = 100
		      xGroup.AddObject(xGroupOval)

		      xGroup.X = 72
		      xGroup.Y = yPos
		      g1.DrawObject(xGroup, 0, 0)

		      // Rotated group (45 degrees)
		      Dim xGroupRotated As New Group2D

		      Dim xGrRect As New RectShape
		      xGrRect.X = 0
		      xGrRect.Y = 0
		      xGrRect.Width = 40
		      xGrRect.Height = 30
		      xGrRect.FillColor = Color.RGB(200, 255, 200)
		      xGrRect.FillOpacity = 100
		      xGrRect.BorderColor = Color.RGB(0, 150, 0)
		      xGrRect.BorderWidth = 1
		      xGrRect.BorderOpacity = 100
		      xGroupRotated.AddObject(xGrRect)

		      Dim xGrOval As New OvalShape
		      xGrOval.X = 50
		      xGrOval.Y = 15
		      xGrOval.Width = 30
		      xGrOval.Height = 30
		      xGrOval.FillColor = Color.RGB(255, 200, 255)
		      xGrOval.FillOpacity = 100
		      xGrOval.BorderColor = Color.RGB(150, 0, 150)
		      xGrOval.BorderWidth = 1
		      xGrOval.BorderOpacity = 100
		      xGroupRotated.AddObject(xGrOval)

		      xGroupRotated.X = 220
		      xGroupRotated.Y = yPos + 15
		      xGroupRotated.Rotation = 0.785398  // 45 degrees
		      g1.DrawObject(xGroupRotated, 0, 0)

		      g1.DrawingColor = &c000000
		      g1.DrawText("Group rotated 45°", 300, yPos + 20)
		      yPos = yPos + 50

		      // Summary
		      g1.FontSize = 8
		      g1.Italic = True
		      g1.DrawingColor = &c008000
		      g1.DrawText("DrawObject supports: RectShape, OvalShape, RoundRectShape, ArcShape, CurveShape, FigureShape, TextShape, PixmapShape, Group2D", 72, yPos)
		      g1.Italic = False

		      // ========== PAGE 5: Brush Demo (Xojo Native) ==========
		      g1.NextPage()
		      yPos = 72

		      g1.FontName = "Helvetica"
		      g1.Bold = True
		      g1.FontSize = 16
		      g1.DrawingColor = &c000080
		      g1.DrawText("8. Brush Demo (Xojo Native)", 72, yPos)
		      g1.Bold = False
		      yPos = yPos + 30

		      g1.FontSize = 10
		      g1.DrawingColor = &c000000
		      g1.DrawText("Graphics.Brush property supports LinearGradientBrush, RadialGradientBrush, and PictureBrush", 72, yPos)
		      yPos = yPos + 25

		      // Demo 1: LinearGradientBrush - Rectangle
		      g1.DrawText("LinearGradientBrush - Horizontal gradient (red to blue):", 72, yPos)
		      yPos = yPos + 15

		      Dim lgb1 As New LinearGradientBrush
		      lgb1.StartPoint = New Point(0, 0)
		      lgb1.EndPoint = New Point(200, 0)
		      lgb1.GradientStops.Add(New Pair(0.0, Color.RGB(255, 0, 0)))
		      lgb1.GradientStops.Add(New Pair(1.0, Color.RGB(0, 0, 255)))
		      g1.Brush = lgb1
		      g1.FillRectangle(72, yPos, 200, 50)
		      g1.Brush = Nil
		      yPos = yPos + 65

		      // Demo 2: LinearGradientBrush - Diagonal
		      g1.DrawingColor = &c000000
		      g1.DrawText("LinearGradientBrush - Diagonal gradient (green to yellow):", 72, yPos)
		      yPos = yPos + 15

		      Dim lgb2 As New LinearGradientBrush
		      lgb2.StartPoint = New Point(0, 0)
		      lgb2.EndPoint = New Point(200, 60)
		      lgb2.GradientStops.Add(New Pair(0.0, Color.RGB(0, 200, 0)))
		      lgb2.GradientStops.Add(New Pair(1.0, Color.RGB(255, 255, 0)))
		      g1.Brush = lgb2
		      g1.FillRectangle(72, yPos, 200, 60)
		      g1.Brush = Nil
		      yPos = yPos + 75

		      // Demo 3: LinearGradientBrush - Multi-stop
		      g1.DrawingColor = &c000000
		      g1.DrawText("LinearGradientBrush - Multi-stop rainbow:", 72, yPos)
		      yPos = yPos + 15

		      Dim lgb3 As New LinearGradientBrush
		      lgb3.StartPoint = New Point(0, 0)
		      lgb3.EndPoint = New Point(300, 0)
		      lgb3.GradientStops.Add(New Pair(0.0, Color.RGB(255, 0, 0)))
		      lgb3.GradientStops.Add(New Pair(0.25, Color.RGB(255, 255, 0)))
		      lgb3.GradientStops.Add(New Pair(0.5, Color.RGB(0, 255, 0)))
		      lgb3.GradientStops.Add(New Pair(0.75, Color.RGB(0, 255, 255)))
		      lgb3.GradientStops.Add(New Pair(1.0, Color.RGB(0, 0, 255)))
		      g1.Brush = lgb3
		      g1.FillRectangle(72, yPos, 300, 40)
		      g1.Brush = Nil
		      yPos = yPos + 55

		      // Demo 4: LinearGradientBrush on Oval
		      g1.DrawingColor = &c000000
		      g1.DrawText("LinearGradientBrush on FillOval:", 72, yPos)
		      yPos = yPos + 15

		      Dim lgb4 As New LinearGradientBrush
		      lgb4.StartPoint = New Point(0, 0)
		      lgb4.EndPoint = New Point(120, 60)
		      lgb4.GradientStops.Add(New Pair(0.0, Color.RGB(255, 100, 200)))
		      lgb4.GradientStops.Add(New Pair(1.0, Color.RGB(100, 200, 255)))
		      g1.Brush = lgb4
		      g1.FillOval(72, yPos, 120, 60)
		      g1.Brush = Nil
		      yPos = yPos + 75

		      // Demo 5: RadialGradientBrush - Basic
		      g1.DrawingColor = &c000000
		      g1.DrawText("RadialGradientBrush - Center to edge (white to purple):", 72, yPos)
		      yPos = yPos + 15

		      Dim rgb1 As New RadialGradientBrush
		      rgb1.StartPoint = New Point(75, 40)
		      rgb1.EndPoint = New Point(75, 40)
		      rgb1.StartRadius = 0
		      rgb1.EndRadius = 80
		      rgb1.GradientStops.Add(New Pair(0.0, Color.RGB(255, 255, 255)))
		      rgb1.GradientStops.Add(New Pair(1.0, Color.RGB(128, 0, 255)))
		      g1.Brush = rgb1
		      g1.FillRectangle(72, yPos, 150, 80)
		      g1.Brush = Nil
		      yPos = yPos + 95

		      // Demo 6: RadialGradientBrush on Oval
		      g1.DrawingColor = &c000000
		      g1.DrawText("RadialGradientBrush on FillOval:", 72, yPos)
		      yPos = yPos + 15

		      Dim rgb2 As New RadialGradientBrush
		      rgb2.StartPoint = New Point(60, 30)
		      rgb2.EndPoint = New Point(60, 30)
		      rgb2.StartRadius = 0
		      rgb2.EndRadius = 60
		      rgb2.GradientStops.Add(New Pair(0.0, Color.RGB(255, 255, 200)))
		      rgb2.GradientStops.Add(New Pair(1.0, Color.RGB(255, 100, 0)))
		      g1.Brush = rgb2
		      g1.FillOval(72, yPos, 120, 60)
		      g1.Brush = Nil
		      yPos = yPos + 75

		      // Summary
		      g1.FontSize = 8
		      g1.Italic = True
		      g1.DrawingColor = &c008000
		      g1.DrawText("Brush property: LinearGradientBrush, RadialGradientBrush, PictureBrush (Tile/Mirror modes)", 72, yPos)
		      g1.Italic = False

		      // Save first PDF
		      Dim desktop As FolderItem = SpecialFolder.Desktop
		      Dim file1 As FolderItem = desktop.Child("example22_xojo_pdfdocument.pdf")
		      pdf1.Save(file1)
		      
		      statusText = statusText + "✓ Xojo PDFDocument saved: " + file1.NativePath + EndOfLine

		      // --- PART 2: VNSPDFDocument (FULL UNICODE) ---
		      statusText = statusText + EndOfLine + "Creating PDF with VNSPDFDocument (full Unicode)..." + EndOfLine

		      // IDENTICAL CODE - just different constructor!
		      Dim pdf2 As New VNSPDFDocument()  // Default is A4, Portrait, Millimeters
		      pdf2.Title = "VNSPDFDocument - Full Unicode"
		      pdf2.Author = "VNS PDF Examples"

		      Dim g2 As VNSPDFGraphics = pdf2.Graphics

		      // Add TOC entries
		      Dim toc6 As New PDFTOCEntry
		      toc6.Title = "1. VNSPDFDocument - Unicode & Font Styles"
		      toc6.Page = 1
		      pdf2.AddTOCEntry(toc6)

		      Dim toc7 As New PDFTOCEntry
		      toc7.Title = "2. VNSPDFDocument - Advanced Features"
		      toc7.Page = 2
		      pdf2.AddTOCEntry(toc7)

		      Dim toc8 As New PDFTOCEntry
		      toc8.Title = "3. VNSPDFDocument - Clipping Methods Demo"
		      toc8.Page = 3
		      pdf2.AddTOCEntry(toc8)

		      Dim toc9 As New PDFTOCEntry
		      toc9.Title = "4. VNSPDFDocument - DrawObject Demo"
		      toc9.Page = 4
		      pdf2.AddTOCEntry(toc9)

		      Dim toc10 As New PDFTOCEntry
		      toc10.Title = "5. VNSPDFDocument - Brush Demo"
		      toc10.Page = 5
		      pdf2.AddTOCEntry(toc10)

		      // Header
		      g2.FontName = "Helvetica"
		      g2.FontSize = 16
		      g2.Bold = True
		      g2.DrawingColor = &c000000
		      g2.DrawText("VNSPDFDocument", 72, 72)
		      
		      // Description
		      g2.FontSize = 10
		      g2.Bold = False
		      g2.DrawText("Full Unicode support - all scripts display correctly", 72, 92)
		      
		      // Load TrueType font for full Unicode support
		      Dim fontPath As String = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
		      Dim fontFile As FolderItem = New FolderItem(fontPath, FolderItem.PathModes.Native)
		      
		      If fontFile.Exists Then
		        // Add the font directly to VNSPDFDocument
		        pdf2.AddUTF8Font("unicode", "", fontPath)
		        g2.FontName = "unicode"
		        statusText = statusText + "✓ Loaded Arial Unicode MS for full Unicode support" + EndOfLine
		      Else
		        statusText = statusText + "⚠ Arial Unicode MS not found - using Helvetica" + EndOfLine
		      End If
		      
		      // Unicode Test - SAME CODE AS ABOVE, will show ALL characters correctly
		      g2.FontSize = 11
		      yPos = 120
		      
		      g2.DrawText("English: Hello World", 72, yPos)
		      yPos = yPos + 20
		      g2.DrawText("Chinese: 你好世界", 72, yPos)
		      yPos = yPos + 20
		      g2.DrawText("Arabic: مرحبا بالعالم", 72, yPos)
		      yPos = yPos + 20
		      g2.DrawText("Hindi: नमस्ते दुनिया", 72, yPos)
		      yPos = yPos + 20
		      g2.DrawText("Thai: สวัสดีชาวโลก", 72, yPos)
		      yPos = yPos + 20
		      g2.DrawText("Hebrew: שלום עולם", 72, yPos)
		      yPos = yPos + 20
		      g2.DrawText("Japanese: こんにちは世界", 72, yPos)
		      yPos = yPos + 20
		      g2.DrawText("Korean: 안녕하세요 세계", 72, yPos)
		      yPos = yPos + 20
		      g2.DrawText("Greek: Γεια σου κόσμε", 72, yPos)
		      
		      // Font style demonstrations - IDENTICAL CODE
		      yPos = yPos + 30
		      g2.FontName = "Helvetica"
		      g2.FontSize = 12
		      g2.DrawingColor = &c000000
		      
		      // Plain
		      g2.Bold = False
		      g2.Italic = False
		      g2.Underline = False
		      g2.DrawText("Plain text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Bold
		      g2.Bold = True
		      g2.Italic = False
		      g2.Underline = False
		      g2.DrawText("Bold text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Italic
		      g2.Bold = False
		      g2.Italic = True
		      g2.Underline = False
		      g2.DrawText("Italic text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Bold + Italic
		      g2.Bold = True
		      g2.Italic = True
		      g2.Underline = False
		      g2.DrawText("Bold + Italic text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Underline
		      g2.Bold = False
		      g2.Italic = False
		      g2.Underline = True
		      g2.DrawText("Underlined text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Bold + Underline
		      g2.Bold = True
		      g2.Italic = False
		      g2.Underline = True
		      g2.DrawText("Bold + Underlined text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Italic + Underline
		      g2.Bold = False
		      g2.Italic = True
		      g2.Underline = True
		      g2.DrawText("Italic + Underlined text", 72, yPos)
		      yPos = yPos + 18
		      
		      // All three
		      g2.Bold = True
		      g2.Italic = True
		      g2.Underline = True
		      g2.DrawText("Bold + Italic + Underlined text", 72, yPos)
		      yPos = yPos + 18
		      
		      // Note: TrueType fonts (like Arial Unicode MS) don't support bold/italic
		      // unless you have separate font files (Arial Bold.ttf, Arial Italic.ttf, etc.)
		      // Underline works because it's a decoration, not a font variant
		      
		      // Graphics features - IDENTICAL CODE
		      yPos = yPos + 15
		      g2.Bold = False
		      g2.Italic = False
		      g2.Underline = False
		      g2.DrawingColor = &cFF0000
		      g2.FillRectangle(72, yPos, 100, 30)
		      g2.DrawingColor = &c0000FF
		      g2.DrawOval(180, yPos, 50, 30)
		      
		      // PHASE 6 FEATURES - Line Cap Styles
		      yPos = yPos + 50
		      g2.DrawingColor = &c000000
		      g2.FontSize = 10
		      g2.Bold = True
		      g2.Italic = False
		      g2.Underline = False
		      g2.DrawText("Phase 6 Features:", 72, yPos)
		      yPos = yPos + 20
		      
		      g2.Bold = False
		      g2.FontSize = 8
		      g2.DrawText("Line Cap Styles:", 72, yPos)
		      yPos = yPos + 12
		      
		      // Butt cap (0)
		      g2.PenSize = 8
		      g2.LineCap = Graphics.LineCapTypes.Butt
		      g2.DrawLine(72, yPos, 150, yPos)
		      g2.PenSize = 1
		      g2.DrawingColor = &cFF0000
		      g2.DrawLine(72, yPos - 10, 72, yPos + 10)
		      g2.DrawLine(150, yPos - 10, 150, yPos + 10)
		      g2.DrawingColor = &c000000
		      g2.DrawText("Butt (0)", 160, yPos + 3)
		      yPos = yPos + 18

		      // Round cap (1)
		      g2.PenSize = 8
		      g2.LineCap = Graphics.LineCapTypes.Round
		      g2.DrawLine(72, yPos, 150, yPos)
		      g2.PenSize = 1
		      g2.DrawingColor = &cFF0000
		      g2.DrawLine(72, yPos - 10, 72, yPos + 10)
		      g2.DrawLine(150, yPos - 10, 150, yPos + 10)
		      g2.DrawingColor = &c000000
		      g2.DrawText("Round (1)", 160, yPos + 3)
		      yPos = yPos + 18

		      // Square cap (2)
		      g2.PenSize = 8
		      g2.LineCap = Graphics.LineCapTypes.Square
		      g2.DrawLine(72, yPos, 150, yPos)
		      g2.PenSize = 1
		      g2.DrawingColor = &cFF0000
		      g2.DrawLine(72, yPos - 10, 72, yPos + 10)
		      g2.DrawLine(150, yPos - 10, 150, yPos + 10)
		      g2.DrawingColor = &c000000
		      g2.DrawText("Square (2)", 160, yPos + 3)
		      yPos = yPos + 20

		      // Line Join Styles
		      g2.DrawText("Line Join Styles:", 72, yPos)
		      yPos = yPos + 12

		      // Miter join (0) - using Xojo's Graphics.LineJoinTypes (same values!)
		      g2.PenSize = 4
		      g2.LineJoin = Graphics.LineJoinTypes.Miter
		      Dim pts1b(5) As Integer
		      pts1b(0) = 72
		      pts1b(1) = yPos + 15
		      pts1b(2) = 100
		      pts1b(3) = yPos
		      pts1b(4) = 128
		      pts1b(5) = yPos + 15
		      Dim path1b As New VNSPDFGraphicsPath
		      path1b.MoveToPoint(pts1b(0), pts1b(1))
		      path1b.AddLineToPoint(pts1b(2), pts1b(3))
		      path1b.AddLineToPoint(pts1b(4), pts1b(5))
		      g2.DrawPath(path1b)
		      g2.PenSize = 1
		      g2.DrawText("Miter (0)", 140, yPos + 8)
		      yPos = yPos + 20

		      // Round join (1) - using Xojo's Graphics.LineJoinTypes (same values!)
		      g2.PenSize = 4
		      g2.LineJoin = Graphics.LineJoinTypes.Round
		      Dim pts2b(5) As Integer
		      pts2b(0) = 72
		      pts2b(1) = yPos + 15
		      pts2b(2) = 100
		      pts2b(3) = yPos
		      pts2b(4) = 128
		      pts2b(5) = yPos + 15
		      Dim path2b As New VNSPDFGraphicsPath
		      path2b.MoveToPoint(pts2b(0), pts2b(1))
		      path2b.AddLineToPoint(pts2b(2), pts2b(3))
		      path2b.AddLineToPoint(pts2b(4), pts2b(5))
		      g2.DrawPath(path2b)
		      g2.PenSize = 1
		      g2.DrawText("Round (1)", 140, yPos + 8)
		      yPos = yPos + 20

		      // Bevel join (2) - using Xojo's Graphics.LineJoinTypes (same values!)
		      g2.PenSize = 4
		      g2.LineJoin = Graphics.LineJoinTypes.Bevel
		      Dim pts3b(5) As Integer
		      pts3b(0) = 72
		      pts3b(1) = yPos + 15
		      pts3b(2) = 100
		      pts3b(3) = yPos
		      pts3b(4) = 128
		      pts3b(5) = yPos + 15
		      Dim path3b As New VNSPDFGraphicsPath
		      path3b.MoveToPoint(pts3b(0), pts3b(1))
		      path3b.AddLineToPoint(pts3b(2), pts3b(3))
		      path3b.AddLineToPoint(pts3b(4), pts3b(5))
		      g2.DrawPath(path3b)
		      g2.PenSize = 1
		      g2.DrawText("Bevel (2)", 140, yPos + 8)
		      yPos = yPos + 20

		      // Dashed Lines
		      g2.DrawText("Dashed Lines (LineDash):", 72, yPos)
		      yPos = yPos + 12

		      g2.PenSize = 2
		      g2.LineJoin = Graphics.LineJoinTypes.Miter
		      g2.LineCap = Graphics.LineCapTypes.Butt

		      g2.LineDash = Array(5.0, 5.0)
		      g2.DrawLine(72, yPos, 200, yPos)
		      g2.PenSize = 1
		      g2.DrawText("[5, 5]", 210, yPos + 3)
		      yPos = yPos + 12

		      g2.LineDash = Array(10.0, 3.0)
		      g2.PenSize = 2
		      g2.DrawLine(72, yPos, 200, yPos)
		      g2.PenSize = 1
		      g2.DrawText("[10, 3]", 210, yPos + 3)
		      yPos = yPos + 12

		      g2.LineDash = Array(8.0, 3.0, 2.0, 3.0)
		      g2.PenSize = 2
		      g2.DrawLine(72, yPos, 200, yPos)
		      g2.PenSize = 1
		      g2.DrawText("[8, 3, 2, 3]", 210, yPos + 3)

		      // Reset to solid line
		      g2.LineDash = Nil
		      yPos = yPos + 20
		      
		      // Character Spacing
		      g2.DrawText("Character Spacing:", 72, yPos)
		      yPos = yPos + 12
		      
		      g2.FontSize = 10
		      g2.CharacterSpacing = 0
		      g2.DrawText("Normal spacing (0)", 72, yPos)
		      yPos = yPos + 15
		      
		      g2.CharacterSpacing = 2
		      g2.DrawText("Wide spacing (2)", 72, yPos)
		      yPos = yPos + 15
		      
		      g2.CharacterSpacing = 5
		      g2.DrawText("Very wide (5)", 72, yPos)
		      g2.CharacterSpacing = 0
		      yPos = yPos + 20
		      
		      // Polygons
		      g2.FontSize = 8
		      g2.DrawText("Polygons (autoClose=True):", 72, yPos)
		      yPos = yPos + 12

		      // Draw triangle (outline) - using autoClose instead of manual close
		      g2.DrawingColor = &c0000FF
		      Dim trianglePathb As New VNSPDFGraphicsPath
		      trianglePathb.MoveToPoint(80, yPos + 20)
		      trianglePathb.AddLineToPoint(110, yPos)
		      trianglePathb.AddLineToPoint(140, yPos + 20)
		      // No manual close needed - autoClose handles it!
		      g2.DrawPath(trianglePathb, True)  // autoClose = True

		      // Fill pentagon - using autoClose instead of manual close
		      g2.DrawingColor = &cFF9900
		      Dim pentagonPathb As New VNSPDFGraphicsPath
		      pentagonPathb.MoveToPoint(170, yPos + 5)
		      pentagonPathb.AddLineToPoint(190, yPos + 10)
		      pentagonPathb.AddLineToPoint(185, yPos + 22)
		      pentagonPathb.AddLineToPoint(155, yPos + 22)
		      pentagonPathb.AddLineToPoint(150, yPos + 10)
		      // No manual close needed - autoClose handles it!
		      g2.FillPath(pentagonPathb, True)  // autoClose = True
		      yPos = yPos + 30
		      
		      // ClearRectangle demonstration
		      g2.DrawingColor = &c000000
		      g2.DrawText("ClearRectangle:", 72, yPos)
		      yPos = yPos + 12
		      
		      g2.DrawingColor = &c00CC00
		      g2.FillRectangle(72, yPos, 100, 25)
		      g2.ClearRectangle(90, yPos + 5, 40, 15)
		      g2.DrawingColor = &c000000
		      g2.DrawText("(cleared area)", 180, yPos + 12)
		      
		      // --- ADVANCED FEATURE DEMONSTRATIONS ---
		      g2.NextPage()
		      yPos = 72

		      // Page Header
		      g2.DrawingColor = &c0000FF
		      g2.FontName = "Helvetica"
		      g2.FontSize = 16
		      g2.Bold = True
		      g2.Italic = False
		      g2.Underline = False
		      g2.DrawText("Advanced Features", 72, yPos)
		      yPos = yPos + 25

		      g2.DrawingColor = &c000000
		      g2.FontSize = 10
		      g2.Bold = False

		      // Feature 1: TextHeight with wrapWidth
		      g2.FontSize = 11
		      g2.Bold = True
		      g2.DrawText("1. TextHeight(text, wrapWidth) - Multi-line Height", 72, yPos)
		      yPos = yPos + 15

		      g2.FontSize = 9
		      g2.Bold = False
		      Dim longText As String = "This is a long text that will wrap across multiple lines when constrained to a specific width. The TextHeight method calculates how tall the wrapped text will be."
		      Dim wrapWidth As Double = 300 // points
		      Dim calculatedHeight As Double = g2.TextHeight(longText, wrapWidth)

		      g2.DrawText("Text: " + Chr(34) + longText + Chr(34), 72, yPos)
		      yPos = yPos + 12
		      g2.DrawText("Wrap width: " + Str(wrapWidth) + " points", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawText("Calculated height: " + Format(calculatedHeight, "0.0") + " points", 72, yPos)
		      yPos = yPos + 12

		      // Draw box showing the calculated dimensions
		      g2.DrawingColor = &cCCCCCC
		      g2.DrawRectangle(72, yPos, wrapWidth, calculatedHeight)

		      // Draw the wrapped text inside the box
		      g2.DrawingColor = &c000000
		      Dim boxStartY As Double = yPos
		      Dim boxX As Double = 72

		      // Manually wrap and draw text (simulate what TextHeight calculates)
		      Dim words() As String = longText.Split(" ")
		      Dim currentLineY As Double = boxStartY + g2.FontSize * 1.2 // First line position
		      Dim currentLine As String = ""

		      For i As Integer = 0 To words.LastIndex
		        Dim testLine As String
		        If currentLine = "" Then
		          testLine = words(i)
		        Else
		          testLine = currentLine + " " + words(i)
		        End If

		        Dim testWidth As Double = g2.TextWidth(testLine)

		        If testWidth > wrapWidth And currentLine <> "" Then
		          // Line is too long, draw current line and start new one
		          g2.DrawText(currentLine, boxX + 3, currentLineY)
		          currentLineY = currentLineY + g2.FontSize * 1.2
		          currentLine = words(i)
		        Else
		          currentLine = testLine
		        End If
		      Next

		      // Draw last line
		      If currentLine <> "" Then
		        g2.DrawText(currentLine, boxX + 3, currentLineY)
		      End If

		      yPos = yPos + calculatedHeight + 15

		      // Feature 2: DrawText with condense parameter
		      g2.FontSize = 11
		      g2.Bold = True
		      g2.DrawText("2. DrawText(text, x, y, width, condense=True) - Horizontal Scaling", 72, yPos)
		      yPos = yPos + 15

		      g2.FontSize = 9
		      g2.Bold = False
		      Dim testText As String = "This text is too wide for the box!"

		      g2.DrawText("Without condense (truncated):", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 150, 15)
		      g2.DrawingColor = &c000000
		      g2.DrawText(testText, 72, yPos + 3, 150, False)
		      yPos = yPos + 20

		      g2.DrawText("With condense=True (scaled to fit):", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 150, 15)
		      g2.DrawingColor = &c000000
		      g2.DrawText(testText, 72, yPos + 3, 150, True)
		      yPos = yPos + 25

		      // Feature 3: Font Properties (FontName, FontSize, Bold, Italic)
		      g2.FontSize = 11
		      g2.Bold = True
		      g2.DrawText("3. Font Properties - Individual Font Settings", 72, yPos)
		      yPos = yPos + 15

		      g2.FontSize = 10
		      g2.Bold = False
		      g2.DrawText("Current FontName: " + g2.FontName, 72, yPos)
		      yPos = yPos + 12
		      g2.DrawText("Current FontSize: " + Str(g2.FontSize), 72, yPos)
		      yPos = yPos + 12

		      // Demonstrate changing font properties
		      g2.FontName = "Times"
		      g2.FontSize = 14
		      g2.Bold = True
		      g2.Italic = True
		      g2.DrawText("Times 14pt Bold Italic", 72, yPos)
		      yPos = yPos + 15

		      // Reset to normal
		      g2.FontName = "Helvetica"
		      g2.FontSize = 10
		      g2.Bold = False
		      g2.Italic = False
		      g2.DrawText("Back to Helvetica 10pt normal", 72, yPos)
		      yPos = yPos + 20

		      // Feature 4: Transformation Methods (Rotate, Translate)
		      g2.FontSize = 11
		      g2.Bold = True
		      g2.DrawText("4. Transformation Methods - Rotate & Translate (NEW!)", 72, yPos)
		      yPos = yPos + 15

		      g2.FontSize = 9
		      g2.Bold = False

		      // Demonstrate Translate
		      g2.DrawText("Translate(x, y) - Shift coordinate system:", 72, yPos)
		      yPos = yPos + 15

		      // Draw reference rectangle
		      g2.DrawingColor = &cCCCCCC
		      g2.DrawRectangle(72, yPos, 60, 40)
		      g2.DrawingColor = &c000000
		      g2.FontSize = 7
		      g2.DrawText("Origin", 80, yPos + 20)

		      // Apply translation and draw translated rectangle
		      g2.SaveState()
		      g2.Translate(100, 0) // Shift 100 points right
		      g2.DrawingColor = &c0000FF
		      g2.DrawRectangle(72, yPos, 60, 40)
		      g2.DrawingColor = &c000000
		      g2.DrawText("Translated", 75, yPos + 20)
		      g2.RestoreState()

		      yPos = yPos + 50

		      // Demonstrate Rotate
		      g2.FontSize = 9
		      g2.DrawText("Rotate(angle) - Rotate around current position:", 72, yPos)
		      yPos = yPos + 15

		      // Draw reference text
		      g2.DrawingColor = &cCCCCCC
		      g2.DrawText("Normal", 100, yPos + 20)

		      // Apply rotation and draw rotated text
		      g2.SaveState()
		      g2.Translate(250, yPos + 20) // Move to rotation point
		      g2.Rotate(45) // Rotate 45 degrees
		      g2.DrawingColor = &cFF0000
		      g2.DrawText("Rotated 45°", 0, 0)
		      g2.RestoreState()

		      // Rotated Chinese text (30 degrees) - need UTF-8 font for Chinese
		      g2.SaveState()
		      g2.Translate(380, yPos + 20)
		      g2.Rotate(30)
		      g2.DrawingColor = &c0000FF
		      g2.FontName = "unicode"  // Switch to UTF-8 font for Chinese characters
		      g2.DrawText("中文旋转", 0, 0)  // Characters registered for font subsetting
		      g2.RestoreState()

		      // Rotated Arabic text (45 degrees) - RTL script
		      g2.SaveState()
		      g2.Translate(500, yPos + 20)
		      g2.Rotate(45)
		      g2.DrawingColor = &c008000  // Green
		      g2.FontName = "unicode"  // Keep UTF-8 font for Arabic
		      g2.DrawText("مرحبا", 0, 0)  // "Hello" in Arabic
		      g2.RestoreState()

		      yPos = yPos + 40
		      g2.DrawingColor = &c000000

		      // Feature 5: DrawTextBlock - Multi-line text with word-wrap and alignment
		      g2.FontSize = 11
		      g2.Bold = True
		      g2.Italic = False
		      g2.Underline = False
		      g2.FontName = "Helvetica"
		      g2.DrawText("5. DrawTextBlock - Word-wrap with Alignment (NEW!)", 72, yPos)
		      yPos = yPos + 18

		      g2.FontSize = 9
		      g2.Bold = False

		      // English text - Left aligned
		      g2.DrawText("English (Left):", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 200, 36)
		      g2.DrawingColor = &c000000
		      g2.DrawTextBlock("The quick brown fox jumps over the lazy dog. This demonstrates word-wrapping in a constrained area.", 72, yPos, 200, 36, 0, False)
		      yPos = yPos + 42

		      // English text - Center aligned
		      g2.DrawText("English (Center):", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 200, 36)
		      g2.DrawingColor = &c000000
		      g2.DrawTextBlock("Centered multi-line text with word-wrapping enabled.", 72, yPos, 200, 36, 1, False)
		      yPos = yPos + 42

		      // English text - Right aligned with truncation
		      g2.DrawText("English (Right + Truncate):", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 200, 24)
		      g2.DrawingColor = &c000000
		      g2.DrawTextBlock("This is a very long text that will be truncated with ellipsis because it exceeds the maximum height.", 72, yPos, 200, 24, 2, True)
		      yPos = yPos + 30

		      // Japanese text with Unicode font
		      g2.DrawText("Japanese (Center):", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 200, 36)
		      g2.DrawingColor = &c000000
		      g2.FontName = "unicode"  // Switch to UTF-8 font for Japanese
		      g2.DrawTextBlock("日本語テキストのワードラップテストです。複数行にわたって表示されます。", 72, yPos, 200, 36, 1, False)
		      yPos = yPos + 42

		      // Hebrew text (RTL) with Unicode font
		      g2.DrawText("Hebrew (Right):", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 200, 36)
		      g2.DrawingColor = &c000000
		      g2.DrawTextBlock("זהו טקסט בעברית לבדיקת גלישת שורות. הטקסט אמור להיות מיושר לימין.", 72, yPos, 200, 36, 2, False)
		      yPos = yPos + 45

		      // Arabic text (RTL) with Unicode font
		      g2.DrawText("Arabic (Right):", 72, yPos)
		      yPos = yPos + 12
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 200, 36)
		      g2.DrawingColor = &c000000
		      g2.DrawTextBlock("هذا نص عربي لاختبار التفاف الكلمات. يجب أن يظهر بشكل صحيح.", 72, yPos, 200, 36, 2, False)
		      yPos = yPos + 45

		      g2.FontName = "Helvetica"
		      g2.FontSize = 8
		      g2.Italic = True
		      g2.DrawingColor = &c008000
		      g2.DrawText("Full Unicode support - Japanese, Hebrew and Arabic display correctly!", 72, yPos)
		      g2.Italic = False
		      g2.DrawingColor = &c000000

		      // Add a sticky note annotation (VNS - matches Xojo API)
		      g2.AddAnnotation("This is a sticky note from VNSPDFGraphics.AddAnnotation method.", 400, 72)

		      // ========== PAGE 2: Clipping Methods Demo ==========
		      g2.NextPage()
		      yPos = 72

		      g2.FontName = "Helvetica"
		      g2.Bold = True
		      g2.FontSize = 16
		      g2.DrawingColor = &c000080
		      g2.DrawText("6. Clipping Methods Demo (NEW!)", 72, yPos)
		      g2.Bold = False
		      yPos = yPos + 30

		      // Demo 1: ClipToRectangle with UTF-8 text
		      g2.FontName = "Helvetica"
		      g2.FontSize = 10
		      g2.DrawingColor = &c000000
		      g2.DrawText("ClipToRectangle - Text clipped to rectangle:", 72, yPos)
		      yPos = yPos + 15

		      // Draw a gray background rectangle to show clip area
		      g2.DrawingColor = &cEEEEEE
		      g2.FillRectangle(72, yPos, 180, 50)
		      g2.DrawingColor = &c000000
		      g2.DrawRectangle(72, yPos, 180, 50)

		      // Clip and draw UTF-8 text - set unicode font for CJK support
		      g2.ClipToRectangle(72, yPos, 180, 50)
		      g2.FontName = "unicode"
		      g2.DrawingColor = &c0000FF
		      g2.FontSize = 11
		      g2.DrawText("English: Hello World - clipped text extends beyond", 75, yPos + 15)
		      g2.DrawText("中文: 你好世界 - 这段中文文本超出剪裁区域", 75, yPos + 32)
		      g2.DrawText("日本語: こんにちは世界 - クリッピング領域", 75, yPos + 49)
		      g2.ClipEnd()
		      yPos = yPos + 65

		      // Demo 2: Clip function (returns Self for chaining)
		      g2.FontName = "Helvetica"
		      g2.DrawingColor = &c000000
		      g2.FontSize = 10
		      g2.DrawText("Clip() function - Returns Self for method chaining:", 72, yPos)
		      yPos = yPos + 15

		      g2.DrawingColor = &cFFEEEE
		      g2.FillRectangle(72, yPos, 150, 55)
		      g2.DrawingColor = &c000000
		      g2.DrawRectangle(72, yPos, 150, 55)

		      // Use Clip() which returns Self - set unicode font for Arabic
		      Dim clipped As VNSPDFGraphics = g2.Clip(72, yPos, 150, 55)
		      clipped.FontName = "unicode"
		      clipped.DrawingColor = &cFF0000
		      clipped.FontSize = 11
		      clipped.DrawText("Clipped via Clip() function call", 75, yPos + 15)
		      clipped.DrawText("العربية: مرحبا بالعالم - نص مقطوع", 75, yPos + 32)
		      clipped.DrawText("Also clipped - cut off at edge", 75, yPos + 49)
		      g2.ClipEnd()
		      yPos = yPos + 70

		      // Demo 3: ClipToPath with VNSPDFGraphicsPath (polygon clipping)
		      g2.DrawingColor = &c000000
		      g2.FontSize = 10
		      g2.DrawText("ClipToPath(VNSPDFGraphicsPath) - Polygon clipping:", 72, yPos)
		      yPos = yPos + 15

		      // Create a triangular path for clipping
		      Dim clipTriangle As New VNSPDFGraphicsPath
		      clipTriangle.MoveToPoint(72, yPos + 60)      // Bottom left
		      clipTriangle.AddLineToPoint(147, yPos)       // Top center
		      clipTriangle.AddLineToPoint(222, yPos + 60)  // Bottom right

		      // Draw the triangle outline first (before clipping)
		      g2.DrawingColor = &cCCCCCC
		      Dim triPoints() As Point
		      triPoints.Add(New Point(72, yPos + 60))
		      triPoints.Add(New Point(147, yPos))
		      triPoints.Add(New Point(222, yPos + 60))
		      g2.FillPolygon(triPoints)
		      g2.DrawingColor = &c000000
		      g2.DrawPolygon(triPoints)

		      // Clip to the triangle and draw content
		      g2.ClipToPath(clipTriangle)
		      g2.DrawingColor = &c008000
		      g2.FontSize = 9
		      // Draw multiple lines of text - only parts inside triangle will show
		      For i As Integer = 0 To 6
		        g2.DrawText("Text line " + Str(i) + " - Only visible inside the triangular clipping region!", 75, yPos + 5 + (i * 10))
		      Next
		      g2.ClipEnd()
		      yPos = yPos + 75

		      // Demo 4: Nested clipping
		      g2.DrawingColor = &c000000
		      g2.FontSize = 10
		      g2.DrawText("Nested Clipping - Multiple clip regions:", 72, yPos)
		      yPos = yPos + 15

		      // Outer clip region
		      g2.DrawingColor = &cEEFFEE
		      g2.FillRectangle(72, yPos, 200, 60)
		      g2.DrawingColor = &c008000
		      g2.DrawRectangle(72, yPos, 200, 60)

		      g2.ClipToRectangle(72, yPos, 200, 60)
		      g2.DrawingColor = &c008000
		      g2.DrawText("Outer clipping region (200x60)", 75, yPos + 12)

		      // Inner clip region (nested)
		      g2.DrawingColor = &cFFEEEE
		      g2.FillRectangle(100, yPos + 20, 100, 30)
		      g2.DrawingColor = &cFF0000
		      g2.DrawRectangle(100, yPos + 20, 100, 30)

		      g2.ClipToRectangle(100, yPos + 20, 100, 30)
		      g2.DrawingColor = &cFF0000
		      g2.DrawText("Inner nested clip - This very long text is doubly clipped!", 102, yPos + 38)
		      g2.ClipEnd()  // End inner clip

		      g2.ClipEnd()  // End outer clip
		      yPos = yPos + 80

		      // Summary
		      g2.FontSize = 8
		      g2.Italic = True
		      g2.DrawingColor = &c008000
		      g2.DrawText("All clipping methods now implemented: Clip(), ClipToPath(), ClipToRectangle(), ClipEnd()", 72, yPos)
		      g2.Italic = False

		      // ========== PAGE 4: DrawObject Demo ==========
		      g2.NextPage()
		      yPos = 72

		      g2.FontName = "Helvetica"
		      g2.Bold = True
		      g2.FontSize = 16
		      g2.DrawingColor = &c000080
		      g2.DrawText("7. DrawObject Demo (NEW!)", 72, yPos)
		      g2.Bold = False
		      yPos = yPos + 30

		      g2.FontSize = 10
		      g2.DrawingColor = &c000000
		      g2.DrawText("DrawObject renders Object2D shapes (RectShape, OvalShape, etc.)", 72, yPos)
		      yPos = yPos + 25

		      // Demo 1: RectShape
		      g2.DrawText("RectShape - filled rectangle with border:", 72, yPos)
		      yPos = yPos + 15

		      Dim rectShape As New RectShape
		      rectShape.X = 72
		      rectShape.Y = yPos
		      rectShape.Width = 80
		      rectShape.Height = 40
		      rectShape.FillColor = Color.RGB(100, 150, 255)
		      rectShape.FillOpacity = 100
		      rectShape.BorderColor = Color.RGB(0, 0, 128)
		      rectShape.BorderWidth = 2
		      rectShape.BorderOpacity = 100
		      g2.DrawObject(rectShape)

		      // RectShape with rotation (45 degrees = π/4 ≈ 0.785 radians)
		      Dim rectRotated As New RectShape
		      rectRotated.X = 200
		      rectRotated.Y = yPos
		      rectRotated.Width = 60
		      rectRotated.Height = 30
		      rectRotated.FillColor = Color.RGB(255, 200, 100)
		      rectRotated.FillOpacity = 100
		      rectRotated.BorderColor = Color.RGB(200, 100, 0)
		      rectRotated.BorderWidth = 2
		      rectRotated.BorderOpacity = 100
		      rectRotated.Rotation = 0.785398  // 45 degrees in radians
		      g2.DrawObject(rectRotated)

		      g2.DrawingColor = &c000000
		      g2.DrawText("Rotated 45°", 270, yPos + 20)
		      yPos = yPos + 55

		      // Demo 2: OvalShape
		      g2.DrawText("OvalShape - circle and ellipse (X,Y is CENTER):", 72, yPos)
		      yPos = yPos + 15

		      Dim ovalShape As New OvalShape
		      ovalShape.X = 120  // Center X
		      ovalShape.Y = yPos + 25  // Center Y
		      ovalShape.Width = 50
		      ovalShape.Height = 50
		      ovalShape.FillColor = Color.RGB(100, 200, 100)
		      ovalShape.FillOpacity = 100
		      ovalShape.BorderColor = Color.RGB(0, 100, 0)
		      ovalShape.BorderWidth = 2
		      ovalShape.BorderOpacity = 100
		      g2.DrawObject(ovalShape)

		      Dim ellipseShape As New OvalShape
		      ellipseShape.X = 220
		      ellipseShape.Y = yPos + 25
		      ellipseShape.Width = 80
		      ellipseShape.Height = 40
		      ellipseShape.FillColor = Color.RGB(255, 150, 150)
		      ellipseShape.FillOpacity = 100
		      ellipseShape.BorderColor = Color.RGB(200, 0, 0)
		      ellipseShape.BorderWidth = 2
		      ellipseShape.BorderOpacity = 100
		      g2.DrawObject(ellipseShape)
		      yPos = yPos + 60

		      // Demo 3: RoundRectShape
		      g2.DrawText("RoundRectShape - rounded corners (radius 15):", 72, yPos)
		      yPos = yPos + 15

		      Dim roundRect As New RoundRectShape
		      roundRect.X = 72
		      roundRect.Y = yPos
		      roundRect.Width = 100
		      roundRect.Height = 50
		      roundRect.CornerWidth = 15
		      roundRect.CornerHeight = 15
		      roundRect.FillColor = Color.RGB(200, 200, 255)
		      roundRect.FillOpacity = 100
		      roundRect.BorderColor = Color.RGB(100, 100, 200)
		      roundRect.BorderWidth = 2
		      roundRect.BorderOpacity = 100
		      g2.DrawObject(roundRect)

		      // Second RoundRectShape with larger radius
		      Dim roundRect2 As New RoundRectShape
		      roundRect2.X = 200
		      roundRect2.Y = yPos
		      roundRect2.Width = 80
		      roundRect2.Height = 50
		      roundRect2.CornerWidth = 25
		      roundRect2.CornerHeight = 25
		      roundRect2.FillColor = Color.RGB(255, 220, 200)
		      roundRect2.FillOpacity = 100
		      roundRect2.BorderColor = Color.RGB(200, 100, 50)
		      roundRect2.BorderWidth = 2
		      roundRect2.BorderOpacity = 100
		      g2.DrawObject(roundRect2)

		      g2.DrawingColor = &c000000
		      g2.DrawText("radius 25", 215, yPos + 30)
		      yPos = yPos + 65

		      // Demo 4: CurveShape (Bezier)
		      g2.DrawText("CurveShape - quadratic bezier curve:", 72, yPos)
		      yPos = yPos + 15

		      Dim curveShape As New CurveShape
		      curveShape.X = 72
		      curveShape.Y = yPos + 30
		      curveShape.X2 = 200
		      curveShape.Y2 = yPos + 30
		      curveShape.Order = 1  // Quadratic
		      curveShape.ControlX(0) = 136
		      curveShape.ControlY(0) = yPos - 20
		      curveShape.BorderColor = Color.RGB(200, 0, 200)
		      curveShape.BorderWidth = 3
		      curveShape.BorderOpacity = 100
		      g2.DrawObject(curveShape)
		      yPos = yPos + 45

		      // Demo 5: TextShape with UTF-8 support
		      g2.DrawText("TextShape - styled text with full UTF-8 support:", 72, yPos)
		      yPos = yPos + 15

		      Dim textShape As New TextShape
		      textShape.Text = "Hello TextShape!"
		      textShape.X = 72
		      textShape.Y = yPos + 12
		      textShape.FontName = "Helvetica"
		      textShape.FontSize = 12
		      textShape.Bold = True
		      textShape.FillColor = Color.RGB(0, 100, 0)
		      g2.DrawObject(textShape)

		      // UTF-8 TextShape (Chinese)
		      Dim textChinese As New TextShape
		      textChinese.Text = "中文: 你好世界"
		      textChinese.X = 72
		      textChinese.Y = yPos + 28
		      textChinese.FontName = "unicode"
		      textChinese.FontSize = 11
		      textChinese.FillColor = Color.RGB(0, 0, 150)
		      g2.DrawObject(textChinese)

		      // UTF-8 TextShape (Japanese)
		      Dim textJapanese As New TextShape
		      textJapanese.Text = "日本語: こんにちは"
		      textJapanese.X = 72
		      textJapanese.Y = yPos + 44
		      textJapanese.FontName = "unicode"
		      textJapanese.FontSize = 11
		      textJapanese.FillColor = Color.RGB(150, 0, 150)
		      g2.DrawObject(textJapanese)

		      // UTF-8 TextShape (Korean)
		      Dim textKorean As New TextShape
		      textKorean.Text = "한국어: 안녕하세요"
		      textKorean.X = 72
		      textKorean.Y = yPos + 60
		      textKorean.FontName = "unicode"
		      textKorean.FontSize = 11
		      textKorean.FillColor = Color.RGB(0, 150, 150)
		      g2.DrawObject(textKorean)

		      // UTF-8 TextShape (Arabic)
		      Dim textArabic As New TextShape
		      textArabic.Text = "العربية: مرحبا"
		      textArabic.X = 72
		      textArabic.Y = yPos + 76
		      textArabic.FontName = "unicode"
		      textArabic.FontSize = 11
		      textArabic.FillColor = Color.RGB(150, 100, 0)
		      g2.DrawObject(textArabic)

		      // Rotated text (45 degrees)
		      Dim textRotated As New TextShape
		      textRotated.Text = "Rotated 45°"
		      textRotated.X = 280
		      textRotated.Y = yPos + 20
		      textRotated.FontName = "Helvetica"
		      textRotated.FontSize = 12
		      textRotated.Bold = True
		      textRotated.FillColor = Color.RGB(200, 0, 0)
		      textRotated.Rotation = 0.785398  // 45 degrees in radians
		      g2.DrawObject(textRotated)

		      // Rotated UTF-8 text (Chinese 45 degrees)
		      Dim textRotatedChinese As New TextShape
		      textRotatedChinese.Text = "旋转中文 45°"
		      textRotatedChinese.X = 380
		      textRotatedChinese.Y = yPos + 20
		      textRotatedChinese.FontName = "unicode"
		      textRotatedChinese.FontSize = 12
		      textRotatedChinese.FillColor = Color.RGB(0, 100, 200)
		      textRotatedChinese.Rotation = 0.785398  // 45 degrees in radians
		      g2.DrawObject(textRotatedChinese)

		      // Rotated UTF-8 text (Japanese -30 degrees)
		      Dim textRotatedJapanese As New TextShape
		      textRotatedJapanese.Text = "回転テキスト"
		      textRotatedJapanese.X = 480
		      textRotatedJapanese.Y = yPos + 50
		      textRotatedJapanese.FontName = "unicode"
		      textRotatedJapanese.FontSize = 11
		      textRotatedJapanese.FillColor = Color.RGB(200, 0, 150)
		      textRotatedJapanese.Rotation = -0.523599  // -30 degrees in radians
		      g2.DrawObject(textRotatedJapanese)
		      yPos = yPos + 95

		      // Demo 6: Group2D
		      g2.DrawText("Group2D - multiple shapes as one unit:", 72, yPos)
		      yPos = yPos + 15

		      Dim group As New Group2D

		      // Add rect to group
		      Dim groupRect As New RectShape
		      groupRect.X = 0
		      groupRect.Y = 0
		      groupRect.Width = 40
		      groupRect.Height = 30
		      groupRect.FillColor = Color.RGB(255, 255, 0)
		      groupRect.FillOpacity = 100
		      groupRect.BorderColor = Color.RGB(200, 200, 0)
		      groupRect.BorderWidth = 1
		      groupRect.BorderOpacity = 100
		      group.AddObject(groupRect)

		      // Add oval to group
		      Dim groupOval As New OvalShape
		      groupOval.X = 50
		      groupOval.Y = 15
		      groupOval.Width = 30
		      groupOval.Height = 30
		      groupOval.FillColor = Color.RGB(0, 255, 255)
		      groupOval.FillOpacity = 100
		      groupOval.BorderColor = Color.RGB(0, 150, 150)
		      groupOval.BorderWidth = 1
		      groupOval.BorderOpacity = 100
		      group.AddObject(groupOval)

		      group.X = 72
		      group.Y = yPos
		      g2.DrawObject(group)

		      // Rotated group
		      Dim groupRotated As New Group2D

		      Dim grRect As New RectShape
		      grRect.X = 0
		      grRect.Y = 0
		      grRect.Width = 40
		      grRect.Height = 30
		      grRect.FillColor = Color.RGB(200, 255, 200)
		      grRect.FillOpacity = 100
		      grRect.BorderColor = Color.RGB(0, 150, 0)
		      grRect.BorderWidth = 1
		      grRect.BorderOpacity = 100
		      groupRotated.AddObject(grRect)

		      Dim grOval As New OvalShape
		      grOval.X = 50
		      grOval.Y = 15
		      grOval.Width = 30
		      grOval.Height = 30
		      grOval.FillColor = Color.RGB(255, 200, 255)
		      grOval.FillOpacity = 100
		      grOval.BorderColor = Color.RGB(150, 0, 150)
		      grOval.BorderWidth = 1
		      grOval.BorderOpacity = 100
		      groupRotated.AddObject(grOval)

		      groupRotated.X = 220
		      groupRotated.Y = yPos + 15
		      groupRotated.Rotation = 0.785398  // 45 degrees
		      g2.DrawObject(groupRotated)

		      g2.DrawingColor = &c000000
		      g2.DrawText("Group rotated 45°", 300, yPos + 20)
		      yPos = yPos + 50

		      // Summary
		      g2.FontSize = 8
		      g2.Italic = True
		      g2.DrawingColor = &c008000
		      g2.DrawText("DrawObject supports: RectShape, OvalShape, RoundRectShape, ArcShape, CurveShape, FigureShape, TextShape, PixmapShape, Group2D", 72, yPos)
		      g2.Italic = False

		      // ========== PAGE 5: Brush Demo (VNS Wrapper) ==========
		      g2.NextPage()
		      yPos = 72

		      g2.FontName = "Helvetica"
		      g2.Bold = True
		      g2.FontSize = 16
		      g2.DrawingColor = &c000080
		      g2.DrawText("8. Brush Demo (VNS Wrapper)", 72, yPos)
		      g2.Bold = False
		      yPos = yPos + 30

		      g2.FontSize = 10
		      g2.DrawingColor = &c000000
		      g2.DrawText("VNSPDFGraphics.Brush supports LinearGradientBrush, RadialGradientBrush, and PictureBrush", 72, yPos)
		      yPos = yPos + 25

		      // Demo 1: LinearGradientBrush - Rectangle
		      g2.DrawText("LinearGradientBrush - Horizontal gradient (red to blue):", 72, yPos)
		      yPos = yPos + 15

		      Dim lgbV1 As New LinearGradientBrush
		      lgbV1.StartPoint = New Point(0, 0)
		      lgbV1.EndPoint = New Point(200, 0)
		      lgbV1.GradientStops.Add(New Pair(0.0, Color.RGB(255, 0, 0)))
		      lgbV1.GradientStops.Add(New Pair(1.0, Color.RGB(0, 0, 255)))
		      g2.Brush = lgbV1
		      g2.FillRectangle(72, yPos, 200, 50)
		      g2.Brush = Nil
		      yPos = yPos + 65

		      // Demo 2: LinearGradientBrush - Diagonal
		      g2.DrawingColor = &c000000
		      g2.DrawText("LinearGradientBrush - Diagonal gradient (green to yellow):", 72, yPos)
		      yPos = yPos + 15

		      Dim lgbV2 As New LinearGradientBrush
		      lgbV2.StartPoint = New Point(0, 0)
		      lgbV2.EndPoint = New Point(200, 60)
		      lgbV2.GradientStops.Add(New Pair(0.0, Color.RGB(0, 200, 0)))
		      lgbV2.GradientStops.Add(New Pair(1.0, Color.RGB(255, 255, 0)))
		      g2.Brush = lgbV2
		      g2.FillRectangle(72, yPos, 200, 60)
		      g2.Brush = Nil
		      yPos = yPos + 75

		      // Demo 3: LinearGradientBrush - Multi-stop
		      g2.DrawingColor = &c000000
		      g2.DrawText("LinearGradientBrush - Multi-stop rainbow:", 72, yPos)
		      yPos = yPos + 15

		      Dim lgbV3 As New LinearGradientBrush
		      lgbV3.StartPoint = New Point(0, 0)
		      lgbV3.EndPoint = New Point(300, 0)
		      lgbV3.GradientStops.Add(New Pair(0.0, Color.RGB(255, 0, 0)))
		      lgbV3.GradientStops.Add(New Pair(0.25, Color.RGB(255, 255, 0)))
		      lgbV3.GradientStops.Add(New Pair(0.5, Color.RGB(0, 255, 0)))
		      lgbV3.GradientStops.Add(New Pair(0.75, Color.RGB(0, 255, 255)))
		      lgbV3.GradientStops.Add(New Pair(1.0, Color.RGB(0, 0, 255)))
		      g2.Brush = lgbV3
		      g2.FillRectangle(72, yPos, 300, 40)
		      g2.Brush = Nil
		      yPos = yPos + 55

		      // Demo 4: LinearGradientBrush on Oval
		      g2.DrawingColor = &c000000
		      g2.DrawText("LinearGradientBrush on FillOval:", 72, yPos)
		      yPos = yPos + 15

		      Dim lgbV4 As New LinearGradientBrush
		      lgbV4.StartPoint = New Point(0, 0)
		      lgbV4.EndPoint = New Point(120, 60)
		      lgbV4.GradientStops.Add(New Pair(0.0, Color.RGB(255, 100, 200)))
		      lgbV4.GradientStops.Add(New Pair(1.0, Color.RGB(100, 200, 255)))
		      g2.Brush = lgbV4
		      g2.FillOval(72, yPos, 120, 60)
		      g2.Brush = Nil
		      yPos = yPos + 75

		      // Demo 5: RadialGradientBrush - Basic
		      g2.DrawingColor = &c000000
		      g2.DrawText("RadialGradientBrush - Center to edge (white to purple):", 72, yPos)
		      yPos = yPos + 15

		      Dim rgbV1 As New RadialGradientBrush
		      rgbV1.StartPoint = New Point(75, 40)
		      rgbV1.EndPoint = New Point(75, 40)
		      rgbV1.StartRadius = 0
		      rgbV1.EndRadius = 80
		      rgbV1.GradientStops.Add(New Pair(0.0, Color.RGB(255, 255, 255)))
		      rgbV1.GradientStops.Add(New Pair(1.0, Color.RGB(128, 0, 255)))
		      g2.Brush = rgbV1
		      g2.FillRectangle(72, yPos, 150, 80)
		      g2.Brush = Nil
		      yPos = yPos + 95

		      // Demo 6: RadialGradientBrush on Oval
		      g2.DrawingColor = &c000000
		      g2.DrawText("RadialGradientBrush on FillOval:", 72, yPos)
		      yPos = yPos + 15

		      Dim rgbV2 As New RadialGradientBrush
		      rgbV2.StartPoint = New Point(60, 30)
		      rgbV2.EndPoint = New Point(60, 30)
		      rgbV2.StartRadius = 0
		      rgbV2.EndRadius = 60
		      rgbV2.GradientStops.Add(New Pair(0.0, Color.RGB(255, 255, 200)))
		      rgbV2.GradientStops.Add(New Pair(1.0, Color.RGB(255, 100, 0)))
		      g2.Brush = rgbV2
		      g2.FillOval(72, yPos, 120, 60)
		      g2.Brush = Nil
		      yPos = yPos + 75

		      // Summary
		      g2.FontSize = 8
		      g2.Italic = True
		      g2.DrawingColor = &c008000
		      g2.DrawText("Brush property: LinearGradientBrush, RadialGradientBrush, PictureBrush (Tile/Mirror modes)", 72, yPos)
		      g2.Italic = False

		      // Save second PDF
		      Dim file2 As FolderItem = desktop.Child("example22_vnspdf_wrapper.pdf")
		      pdf2.Save(file2)

		      statusText = statusText + "✓ VNSPDFDocument saved: " + file2.NativePath + EndOfLine
		      
		      // Success summary
		      statusText = statusText + EndOfLine + "SUCCESS! Compare the two PDFs:" + EndOfLine
		      statusText = statusText + "1. example22_xojo_pdfdocument.pdf - Native Xojo (missing glyphs)" + EndOfLine
		      statusText = statusText + "2. example22_vnspdf_wrapper.pdf - VNS Wrapper (full Unicode)" + EndOfLine
		      statusText = statusText + EndOfLine + "Features demonstrated:" + EndOfLine
		      statusText = statusText + "✓ Underline support" + EndOfLine
		      statusText = statusText + "✓ Font style combinations (Bold, Italic, Underline)" + EndOfLine
		      statusText = statusText + "✓ Unicode text rendering" + EndOfLine
		      statusText = statusText + "✓ Graphics primitives (rectangles, ovals)" + EndOfLine
		      statusText = statusText + "✓ Line Cap/Join styles (Butt, Round, Square, Miter, Bevel)" + EndOfLine
		      statusText = statusText + "✓ Dashed lines and character spacing" + EndOfLine
		      statusText = statusText + "✓ Polygon drawing (DrawPolygon, FillPolygon)" + EndOfLine
		      statusText = statusText + "✓ ClearRectangle method" + EndOfLine
		      statusText = statusText + EndOfLine + "Phase 6 Features (NEW - Page 2!):" + EndOfLine
		      statusText = statusText + "✓ TextHeight(text, wrapWidth) - Multi-line height calculation" + EndOfLine
		      statusText = statusText + "✓ DrawText condense parameter - Horizontal text scaling" + EndOfLine
		      statusText = statusText + "✓ Font properties - FontName, FontSize, Bold, Italic" + EndOfLine
		      statusText = statusText + "✓ Template() & Constructor(JSONItem) - Serialization" + EndOfLine
		      statusText = statusText + "✓ Transformation methods - Rotate(angle), Translate(x, y) with UTF-8 text" + EndOfLine
		      statusText = statusText + "✓ Outline property - API compatibility" + EndOfLine
		      statusText = statusText + "✓ DrawTextBlock - Word-wrap with alignment (Left/Center/Right)" + EndOfLine
		      statusText = statusText + "✓ TextBlockSize - Calculate text block dimensions" + EndOfLine
		      statusText = statusText + "✓ Clipping methods - Clip(), ClipToPath(), ClipToRectangle(), ClipEnd()" + EndOfLine
		      statusText = statusText + "✓ Polygon clipping - ClipToPath(VNSPDFGraphicsPath)" + EndOfLine
		      statusText = statusText + "✓ Brush property - LinearGradientBrush, RadialGradientBrush, PictureBrush" + EndOfLine
		      statusText = statusText + EndOfLine + "API Coverage: 91.8% (56 of 61 PDFGraphics features)" + EndOfLine
		      
		      result.Value("pdf") = pdf2.ToData() // Return the VNS wrapper PDF
		      result.Value("filename") = "example22_vnspdf_wrapper.pdf"
		      result.Value("passed") = True
		      
		    Catch e As RuntimeException
		      statusText = statusText + "Exception: " + e.Message + EndOfLine
		      result.Value("error") = e.Message
		      result.Value("passed") = False
		    End Try
		    
		  #Else
		    // Not Desktop - PDFDocument is not available
		    statusText = statusText + "Example 22 is Desktop-only (requires Xojo PDFDocument)" + EndOfLine
		    statusText = statusText + "Current platform does not support this example." + EndOfLine
		    result.Value("passed") = False
		  #EndIf
		  
		  result.Value("message") = statusText
		  result.Value("output") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample23() As Dictionary
		  // Example 23: File Attachments - Document-level and page-level attachment annotations
		  // Demonstrates embedding files in PDF and creating clickable attachment areas

		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 23: File Attachments..." + EndOfLine

		  Try
		    // Create PDF document with Xojo-compatible property syntax
		    // First page is added automatically by constructor
		    Dim pdf As New VNSPDFDocument()
		    pdf.Title = "File Attachments Example"
		    pdf.Author = "VNS PDF Examples"
		    pdf.Subject = "Demonstrates file attachment features"

		    // Title
		    pdf.SetFont("Helvetica", "B", 18)
		    pdf.Cell(0, 12, "PDF File Attachments", 0, 1, "C")
		    pdf.Ln(5)

		    // Introduction
		    pdf.SetFont("Helvetica", "", 11)
		    pdf.MultiCell(0, 6, "This example demonstrates embedding files into a PDF document. " + _
		      "PDF attachments can be accessed from the PDF reader's attachment panel or via clickable annotations on the page.", 0, "L")
		    pdf.Ln(8)

		    // Section 1: Document-level attachments
		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "1. Document-Level Attachments", 0, 1)
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.MultiCell(0, 5, "These attachments appear in the PDF reader's attachment panel (sidebar). " + _
		      "They are accessible from any page.", 0, "L")
		    pdf.Ln(3)

		    // Create sample text file attachment
		    Dim txtContent As String = "This is a sample text file embedded in the PDF." + EndOfLine
		    txtContent = txtContent + "Created by VNS PDF Library." + EndOfLine
		    txtContent = txtContent + "Date: " + DateTime.Now.ToString + EndOfLine

		    Dim attachment1 As New VNSPDFAttachment("sample.txt", txtContent, "A simple text file")
		    pdf.AddAttachment(attachment1)
		    statusText = statusText + "Added document-level attachment: sample.txt" + EndOfLine

		    // Create sample XML file attachment (useful for e-invoices)
		    Dim xmlContent As String = "<?xml version=""1.0"" encoding=""UTF-8""?>" + EndOfLine
		    xmlContent = xmlContent + "<invoice>" + EndOfLine
		    xmlContent = xmlContent + "  <number>INV-2025-001</number>" + EndOfLine
		    xmlContent = xmlContent + "  <date>2025-12-11</date>" + EndOfLine
		    xmlContent = xmlContent + "  <total currency=""EUR"">1234.56</total>" + EndOfLine
		    xmlContent = xmlContent + "</invoice>" + EndOfLine

		    Dim attachment2 As New VNSPDFAttachment("invoice.xml", xmlContent, "Invoice data in XML format")
		    pdf.AddAttachment(attachment2)
		    statusText = statusText + "Added document-level attachment: invoice.xml" + EndOfLine

		    // List the attachments
		    pdf.SetFont("Helvetica", "I", 10)
		    pdf.Cell(0, 5, "Attached files (check your PDF reader's attachment panel):", 0, 1)
		    pdf.SetFont("Courier", "", 9)
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.Cell(0, 5, "- sample.txt (text file)", 0, 1)
		    pdf.Cell(10, 5, "", 0, 0)
		    pdf.Cell(0, 5, "- invoice.xml (XML invoice data)", 0, 1)
		    pdf.Ln(8)

		    // Section 2: Page-level attachment annotations
		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "2. Attachment Annotations", 0, 1)
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.MultiCell(0, 5, "These are clickable areas on the page that link to embedded files. " + _
		      "Click the icon below to open the attached file.", 0, "L")
		    pdf.Ln(5)

		    // Draw a clickable area for attachment annotation
		    Dim annotX As Double = 20
		    Dim annotY As Double = pdf.GetY()
		    Dim annotW As Double = 30
		    Dim annotH As Double = 10

		    // Draw a rectangle to indicate the attachment area
		    pdf.SetFillColor(240, 240, 255)
		    pdf.SetDrawColor(0, 0, 200)
		    pdf.Rect(annotX, annotY, annotW, annotH, "FD")

		    // Add attachment annotation
		    Dim annotContent As String = "Click here to open this attached note." + EndOfLine
		    annotContent = annotContent + "This is a page-level attachment annotation."
		    Dim attachment3 As New VNSPDFAttachment("note.txt", annotContent, "Click to open note")
		    pdf.AddAttachmentAnnotation(attachment3, annotX, annotY, annotW, annotH)
		    statusText = statusText + "Added attachment annotation at (" + Str(annotX) + ", " + Str(annotY) + ")" + EndOfLine

		    // Label for the annotation
		    pdf.SetXY(annotX + annotW + 5, annotY + 3)
		    pdf.SetFont("Helvetica", "I", 9)
		    pdf.Cell(0, 5, "<- Click this area to open attached file", 0, 1)

		    pdf.Ln(15)

		    // Section 3: Text Annotations (sticky notes)
		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "3. Text Annotations (Sticky Notes)", 0, 1)
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.MultiCell(0, 5, "Text annotations are clickable note icons that display a popup message when clicked. " + _
		      "Compatible with Xojo's PDFDocument.AddAnnotation method.", 0, "L")
		    pdf.Ln(5)

		    // Add text annotation examples
		    Dim noteY As Double = pdf.GetY()
		    pdf.AddTextAnnotation("This is a simple sticky note.", 10, noteY)
		    pdf.Cell(0, 6, "          <- Click the note icon to see the message", 0, 1)
		    statusText = statusText + "Added text annotation at (10, " + Str(noteY) + ")" + EndOfLine

		    pdf.Ln(3)
		    noteY = pdf.GetY()
		    pdf.AddTextAnnotation("Multi-line note:" + Chr(10) + "Line 1" + Chr(10) + "Line 2" + Chr(10) + "Line 3", 10, noteY)
		    pdf.Cell(0, 6, "          <- Multi-line note with line breaks", 0, 1)
		    statusText = statusText + "Added multi-line text annotation" + EndOfLine

		    pdf.Ln(15)

		    // Section 4: Use cases
		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "4. Common Use Cases", 0, 1)
		    pdf.SetFont("Helvetica", "", 10)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "E-Invoicing (Factur-X / ZUGFeRD):", 0, 1)
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.MultiCell(0, 5, "Embed structured XML invoice data inside human-readable PDF invoices. " + _
		      "The XML can be extracted by accounting software for automated processing.", 0, "L")
		    pdf.Ln(3)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "Document Archives:", 0, 1)
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.MultiCell(0, 5, "Attach source files, spreadsheets, or related documents to a PDF report " + _
		      "for complete document packages.", 0, "L")
		    pdf.Ln(3)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "Digital Signatures:", 0, 1)
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.MultiCell(0, 5, "Attach signature certificates or validation data to signed PDF documents.", 0, "L")

		    // Generate PDF output
		    Dim pdfData As String = pdf.Output()

		    If pdf.Ok Then
		      statusText = statusText + "Example 23 completed successfully!" + EndOfLine
		      statusText = statusText + "PDF generated (" + Str(pdfData.Bytes) + " bytes)" + EndOfLine
		      result.Value("success") = True
		      result.Value("passed") = True
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example23_attachments.pdf"
		    Else
		      statusText = statusText + "Error: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		      result.Value("passed") = False
		    End If

		  Catch ex As RuntimeException
		    statusText = statusText + "Exception: " + ex.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("passed") = False
		  End Try

		  result.Value("message") = statusText
		  result.Value("output") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample24() As Dictionary
		  // Example 24: PDF Forms Comparison - Xojo native vs VNS
		  // Generates TWO PDFs side-by-side for comparison:
		  // 1. example24_xojo_pdfdocument.pdf - Native Xojo PDFDocument with forms
		  // 2. example24_vnspdf.pdf - VNS implementation with forms
		  //
		  // Demonstrates migration ease and feature parity
		  // REQUIRES: Premium Forms Module (hasPremiumVNSFormsModule = True)

		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 24: PDF Forms Comparison..." + EndOfLine

		  #If Not hasPremiumVNSFormsModule Then
		    statusText = statusText + "PDF Forms require the Premium Forms Module." + EndOfLine + EndOfLine
		    statusText = statusText + GetPremiumEnablingInstructions(Array("hasPremiumVNSFormsModule")) + EndOfLine
		    result.Value("success") = False
		    result.Value("passed") = False
		    result.Value("message") = statusText
		    result.Value("output") = statusText
		    Return result
		  #EndIf

		  #If hasPremiumVNSFormsModule Then
		    #If TargetDesktop Then
		      // ============================================================
		      // PART 1: Generate PDF using native Xojo PDFDocument
		      // ============================================================
		      statusText = statusText + "Desktop platform detected - generating Xojo native PDF..." + EndOfLine
		      Try
		        statusText = statusText + "Creating PDF with native Xojo PDFDocument..." + EndOfLine

		        Dim xojoPDF As New PDFDocument
		        // Note: Xojo PDFDocument automatically creates first page

		        // Title
		        Dim g As Graphics = xojoPDF.Graphics
		        g.Bold = True
		        g.FontSize = 20
		        g.DrawText("PDF Forms - Xojo Native", 150, 50)
		        g.Bold = False
		        g.FontSize = 10
		        g.DrawText("Generated with Xojo PDFDocument", 180, 65)

		        // Form controls
		        Dim y As Integer = 100

		        // Text field
		        g.DrawText("Name:", 50, y)
		        Dim tf1 As New PDFTextField(1, 120, y - 15, 150, 20, "name")
		        tf1.Text = "John Doe"
		        xojoPDF.AddControl(tf1)
		        y = y + 30

		        // Email field
		        g.DrawText("Email:", 50, y)
		        Dim tf2 As New PDFTextField(1, 120, y - 15, 150, 20, "email")
		        tf2.Text = "john@example.com"
		        xojoPDF.AddControl(tf2)
		        y = y + 30

		        // Password field
		        g.DrawText("Password:", 50, y)
		        Dim tf3 As New PDFTextField(1, 120, y - 15, 150, 20, "password")
		        tf3.Password = True
		        xojoPDF.AddControl(tf3)
		        y = y + 40

		        // Checkbox
		        Dim cb1 As New PDFCheckBox(1, 50, y - 15, 15, 15, "newsletter")
		        cb1.Value = True
		        xojoPDF.AddControl(cb1)
		        g.DrawText("Subscribe to newsletter", 75, y)
		        y = y + 30

		        // Radio buttons
		        g.DrawText("Contact method:", 50, y)
		        y = y + 20
		        Dim rb1 As New PDFRadioButton(1, 50, y - 15, 15, 15, "contact", "email")
		        rb1.Value = True
		        xojoPDF.AddControl(rb1)
		        g.DrawText("Email", 75, y)
		        y = y + 20
		        Dim rb2 As New PDFRadioButton(1, 50, y - 15, 15, 15, "contact", "phone")
		        xojoPDF.AddControl(rb2)
		        g.DrawText("Phone", 75, y)
		        y = y + 40

		        // Combo box
		        g.DrawText("Country:", 50, y)
		        Dim cb2 As New PDFComboBox(1, 120, y - 15, 150, 20, "country", "France", "Germany", "United Kingdom", "United States")
		        cb2.SelectedRowIndex = 0
		        xojoPDF.AddControl(cb2)
		        y = y + 30

		        // List box
		        g.DrawText("Interests:", 50, y)
		        Dim lbVals() As String = Array("Technology", "Science", "Arts", "Sports")
		        Dim lb1 As New PDFListBox(1, 120, y - 15, 150, 60, "interests", lbVals)
		        lb1.SelectedRowIndex = 1
		        xojoPDF.AddControl(lb1)
		        y = y + 70

		        // Popup menu
		        g.DrawText("Priority:", 50, y)
		        Dim pm1 As New PDFPopupMenu(1, 120, y - 15, 150, 20, "priority", "Low", "Normal", "High", "Critical")
		        pm1.SelectedRowIndex = 1
		        xojoPDF.AddControl(pm1)
		        y = y + 30

		        // Text area
		        g.DrawText("Comments:", 50, y)
		        Dim ta1 As New PDFTextArea(1, 50, y + 10, 300, 80, "comments")
		        ta1.Text = "Enter your comments here..."
		        xojoPDF.AddControl(ta1)
		        y = y + 100

		        // Signature field
		        g.DrawText("Signature:", 50, y)
		        Dim sig1 As New PDFSignature(1, 50, y + 10, 150, 40, "signature1")
		        xojoPDF.AddControl(sig1)
		        y = y + 60

		        // Buttons
		        Dim resetBtn As New PDFButton(1, 50, y, 70, 22, "resetBtn", "Reset")
		        xojoPDF.AddControl(resetBtn)

		        Dim submitBtn As New PDFButton(1, 130, y, 70, 22, "submitBtn", "Submit")
		        submitBtn.Action = PDFButton.Actions.SendForm
		        submitBtn.URL = "https://httpbin.org/post"
		        xojoPDF.AddControl(submitBtn)

		        Dim urlBtn As New PDFButton(1, 210, y, 85, 22, "urlBtn", "Visit Website")
		        urlBtn.URL = "https://example.com"
		        xojoPDF.AddControl(urlBtn)

		        // Save native Xojo PDF to Desktop
		        Dim desktop As FolderItem = SpecialFolder.Desktop
		        Dim file1 As FolderItem = desktop.Child("example24_xojo_pdfdocument.pdf")
		        xojoPDF.Save(file1)
		        statusText = statusText + "✓ Native Xojo PDF saved: " + file1.NativePath + EndOfLine

		      Catch ex As RuntimeException
		        statusText = statusText + "⚠ Xojo PDFDocument exception: " + ex.Message + EndOfLine
		      End Try
		    #Else
		      statusText = statusText + "Xojo PDFDocument skipped (Desktop only)" + EndOfLine
		    #EndIf

		    // ============================================================
		    // PART 2: Generate equivalent PDF using VNS
		    // ============================================================
		    Try
		      statusText = statusText + "Creating PDF with VNS..." + EndOfLine

		      Dim pdf As New VNSPDFDocument()
		      pdf.Title = "PDF Forms - VNS Implementation"
		      pdf.Author = "VNS PDF Examples"
		      pdf.Subject = "Demonstrates PDF form controls with VNS"

		      // Title
		      pdf.SetFont("Helvetica", "B", 20)
		      pdf.SetXY(10, 17)
		      pdf.Cell(0, 10, "PDF Forms - VNS Implementation", 0, 1, "C")
		      pdf.SetFont("Helvetica", "", 10)
		      pdf.SetXY(10, 23)
		      pdf.Cell(0, 6, "Generated with VNSPDFDocument", 0, 1, "C")
		      // Form controls (matching Xojo native layout)
		      pdf.SetFont("Helvetica", "", 10)
		      Dim vY As Double = 35

		      // Name field
		      pdf.SetXY(17, vY)
		      pdf.Cell(25, 6, "Name:", 0, 0)
		      Dim vnsName As New PDFTextField(1, CType(pdf.GetX() * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(53 * 2.83, Integer), CType(7 * 2.83, Integer), "name")
		      vnsName.Text = "John Doe"
		      vnsName.FontSize = 10
		      pdf.AddControl(vnsName)
		      statusText = statusText + "✓ Added text field: name" + EndOfLine
		      vY = vY + 11

		      // Email field
		      pdf.SetXY(17, vY)
		      pdf.Cell(25, 6, "Email:", 0, 0)
		      Dim vnsEmail As New PDFTextField(1, CType(pdf.GetX() * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(53 * 2.83, Integer), CType(7 * 2.83, Integer), "email")
		      vnsEmail.Text = "john@example.com"
		      vnsEmail.FontSize = 10
		      pdf.AddControl(vnsEmail)
		      statusText = statusText + "✓ Added text field: email" + EndOfLine
		      vY = vY + 11

		      // Password field
		      pdf.SetXY(17, vY)
		      pdf.Cell(25, 6, "Password:", 0, 0)
		      Dim vnsPwd As New PDFTextField(1, CType(pdf.GetX() * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(53 * 2.83, Integer), CType(7 * 2.83, Integer), "password")
		      vnsPwd.Password = True
		      vnsPwd.FontSize = 10
		      pdf.AddControl(vnsPwd)
		      statusText = statusText + "✓ Added password field" + EndOfLine
		      vY = vY + 14

		      // Checkbox
		      Dim vnsCb As New PDFCheckBox(1, CType(17.7 * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(5 * 2.83, Integer), CType(5 * 2.83, Integer), "newsletter")
		      vnsCb.Value = True
		      pdf.AddControl(vnsCb)
		      pdf.SetXY(26, vY)
		      pdf.Cell(0, 6, "Subscribe to newsletter", 0, 1)
		      statusText = statusText + "✓ Added checkbox" + EndOfLine
		      vY = vY + 11

		      // Radio buttons
		      pdf.SetXY(17, vY)
		      pdf.Cell(0, 6, "Contact method:", 0, 1)
		      vY = vY + 7

		      Dim vnsRb1 As New PDFRadioButton(1, CType(17.7 * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(5 * 2.83, Integer), CType(5 * 2.83, Integer), "contact", "email")
		      vnsRb1.Value = True
		      pdf.AddControl(vnsRb1)
		      pdf.SetXY(26, vY)
		      pdf.Cell(0, 6, "Email", 0, 1)
		      vY = vY + 7

		      Dim vnsRb2 As New PDFRadioButton(1, CType(17.7 * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(5 * 2.83, Integer), CType(5 * 2.83, Integer), "contact", "phone")
		      pdf.AddControl(vnsRb2)
		      pdf.SetXY(26, vY)
		      pdf.Cell(0, 6, "Phone", 0, 1)
		      statusText = statusText + "✓ Added radio buttons" + EndOfLine
		      vY = vY + 14

		      // Combo box
		      pdf.SetXY(17, vY)
		      pdf.Cell(25, 6, "Country:", 0, 0)
		      Dim vnsCombo As New PDFComboBox(1, CType(pdf.GetX() * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(53 * 2.83, Integer), CType(7 * 2.83, Integer), "country", "France", "Germany", "United Kingdom", "United States")
		      vnsCombo.SelectedRowIndex = 0
		      pdf.AddControl(vnsCombo)
		      statusText = statusText + "✓ Added combo box" + EndOfLine
		      vY = vY + 11

		      // List box
		      pdf.SetXY(17, vY)
		      pdf.Cell(25, 6, "Interests:", 0, 0)
		      Dim lbValues() As String = Array("Technology", "Science", "Arts", "Sports")
		      Dim vnsLb As New PDFListBox(1, CType(pdf.GetX() * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(53 * 2.83, Integer), CType(21 * 2.83, Integer), "interests", lbValues)
		      vnsLb.SelectedRowIndex = 1
		      pdf.AddControl(vnsLb)
		      statusText = statusText + "✓ Added list box" + EndOfLine
		      vY = vY + 25

		      // Popup menu
		      pdf.SetXY(17, vY)
		      pdf.Cell(25, 6, "Priority:", 0, 0)
		      Dim vnsPm As New PDFPopupMenu(1, CType(pdf.GetX() * 2.83, Integer), CType((vY - 0.5) * 2.83, Integer), CType(53 * 2.83, Integer), CType(7 * 2.83, Integer), "priority", "Low", "Normal", "High", "Critical")
		      vnsPm.SelectedRowIndex = 1
		      pdf.AddControl(vnsPm)
		      statusText = statusText + "✓ Added popup menu" + EndOfLine
		      vY = vY + 11

		      // Text area
		      pdf.SetXY(17, vY)
		      pdf.Cell(0, 6, "Comments:", 0, 1)
		      Dim vnsTa As New PDFTextArea(1, CType(17.7 * 2.83, Integer), CType((vY + 3.5) * 2.83, Integer), CType(106 * 2.83, Integer), CType(28 * 2.83, Integer), "comments")
		      vnsTa.Text = "Enter your comments here..."
		      vnsTa.FontSize = 10
		      pdf.AddControl(vnsTa)
		      statusText = statusText + "✓ Added text area" + EndOfLine
		      vY = vY + 35

		      // Signature field placeholder
		      pdf.SetXY(17, vY)
		      pdf.Cell(0, 6, "Signature:", 0, 1)
		      Dim vnsSig As New PDFSignature(1, CType(17.7 * 2.83, Integer), CType((vY + 3.5) * 2.83, Integer), CType(53 * 2.83, Integer), CType(14 * 2.83, Integer), "signature1")
		      pdf.AddControl(vnsSig)
		      statusText = statusText + "✓ Added signature field" + EndOfLine
		      vY = vY + 22

		      // Push buttons with different actions
		      // Reset button (clears all form fields) - Action defaults to ResetForm
		      Dim vnsResetBtn As New PDFButton(1, CType(17.7 * 2.83, Integer), CType(vY * 2.83, Integer), CType(25 * 2.83, Integer), CType(8 * 2.83, Integer), "resetBtn", "Reset")
		      pdf.AddControl(vnsResetBtn)
		      statusText = statusText + "✓ Added reset button (ResetForm action)" + EndOfLine

		      // Submit button (sends form data to URL)
		      Dim vnsSubmitBtn As New PDFButton(1, CType(47 * 2.83, Integer), CType(vY * 2.83, Integer), CType(25 * 2.83, Integer), CType(8 * 2.83, Integer), "submitBtn", "Submit")
		      vnsSubmitBtn.Action = PDFButton.Actions.SendForm
		      vnsSubmitBtn.URL = "https://httpbin.org/post"
		      pdf.AddControl(vnsSubmitBtn)
		      statusText = statusText + "✓ Added submit button (SendForm action)" + EndOfLine

		      // URL button (opens link in browser)
		      Dim vnsUrlBtn As New PDFButton(1, CType(76 * 2.83, Integer), CType(vY * 2.83, Integer), CType(30 * 2.83, Integer), CType(8 * 2.83, Integer), "urlBtn", "Visit Website")
		      vnsUrlBtn.URL = "https://example.com"
		      pdf.AddControl(vnsUrlBtn)
		      statusText = statusText + "✓ Added URL button (URI action)" + EndOfLine

		      // Save VNS PDF
		      Dim pdfData As String = pdf.Output()

		      If pdf.Ok Then
		        #If TargetDesktop Then
		          Dim vnsDesktop As FolderItem = SpecialFolder.Desktop
		          Dim file2 As FolderItem = vnsDesktop.Child("example24_vnspdf.pdf")
		          Call pdf.SaveToFile(file2.NativePath)
		          statusText = statusText + "✓ VNS PDF saved: " + file2.NativePath + EndOfLine
		        #EndIf

		        // Success summary
		        statusText = statusText + EndOfLine + "SUCCESS! Compare the two PDFs:" + EndOfLine
		        statusText = statusText + "1. example24_xojo_pdfdocument.pdf - Native Xojo" + EndOfLine
		        statusText = statusText + "2. example24_vnspdf.pdf - VNS Implementation" + EndOfLine
		        statusText = statusText + EndOfLine + "Form Controls Demonstrated:" + EndOfLine
		        statusText = statusText + "✓ PDFTextField - Text input with default values" + EndOfLine
		        statusText = statusText + "✓ PDFTextField (Password) - Masked input" + EndOfLine
		        statusText = statusText + "✓ PDFCheckBox - Boolean selection" + EndOfLine
		        statusText = statusText + "✓ PDFRadioButton - Grouped selection" + EndOfLine
		        statusText = statusText + "✓ PDFTextArea - Multi-line text input" + EndOfLine
		        statusText = statusText + EndOfLine + "Demonstrates:" + EndOfLine
		        statusText = statusText + "✓ Migration ease from Xojo PDFDocument to VNS" + EndOfLine
		        statusText = statusText + "✓ Identical API for both implementations" + EndOfLine
		        statusText = statusText + "✓ Appearance stream generation for Acrobat compatibility" + EndOfLine

		        result.Value("success") = True
		        result.Value("passed") = True
		        result.Value("pdf") = pdfData
		        result.Value("filename") = "example24_vnspdf.pdf"
		      Else
		        statusText = statusText + "Error: " + pdf.GetError() + EndOfLine
		        result.Value("success") = False
		        result.Value("passed") = False
		      End If

		    Catch ex As RuntimeException
		      statusText = statusText + "Exception: " + ex.Message + EndOfLine
		      result.Value("success") = False
		      result.Value("passed") = False
		    End Try
		  #EndIf

		  result.Value("message") = statusText
		  result.Value("output") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample3() As Dictionary
		  // Example 3: Multiple pages with various drawing styles
		  
		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 3: Multiple pages..." + EndOfLine
		  
		  Try
		    // Create PDF document (first page added automatically)
		    Dim pdf As New VNSPDFDocument()

		    // Page 1: Circles (already added by constructor)
		    For i As Integer = 1 To 10
		      pdf.SetFillColor(i * 25, 255 - (i * 25), 128)
		      pdf.SetDrawColor(0, 0, 0)
		      pdf.Circle(50 + (i * 15), 100, 10, "DF")
		    Next
		    
		    // Page 2: Rectangles
		    pdf.AddPage()
		    For i As Integer = 1 To 8
		      pdf.SetFillColor(255, i * 30, 0)
		      pdf.SetDrawColor(100, 100, 100)
		      pdf.SetLineWidth(i * 0.2)
		      pdf.Rect(20, 20 + (i * 25), 150, 20, "DF")
		    Next
		    
		    // Page 3: Ellipses
		    pdf.AddPage()
		    For i As Integer = 1 To 6
		      pdf.SetDrawColor(i * 40, 0, 255 - (i * 40))
		      pdf.SetLineWidth(1.5)
		      pdf.Ellipse(100, 50 + (i * 30), 40, 15, "D")
		    Next
		    
		    // Page 4: Bezier Curves
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		  
		  result.Value("message") = statusText
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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		    pdf.AddPage()
		    
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
		  
		  result.Value("message") = statusText
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

		    // Disable compression on Linux/Windows where system zlib may not be available
		    // The Premium Zlib module (pure Xojo) handles this properly for all platforms
		    #If TargetLinux Or TargetWindows Then
		      pdf.Compressed = False
		    #EndIf

		    // Title with core font
		    pdf.SetFont("helvetica", "B", 16)
		    pdf.Cell(0, 10, "UTF-8 Text with TrueType Fonts", 0, 1, "C")
		    pdf.Ln(5)
		    
		    Dim fontPath As String
		    Dim fontFile As FolderItem
		    
		    #If TargetiOS Or TargetAndroid Then
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
		    #ElseIf TargetWindows Then
		      // Windows: Try common system fonts with Unicode support
		      fontPath = "C:\Windows\Fonts\arial.ttf"
		      fontFile = New FolderItem(fontPath, FolderItem.PathModes.Native)

		      If fontFile = Nil Or Not fontFile.Exists Then
		        fontPath = "C:\Windows\Fonts\segoeui.ttf"
		        fontFile = New FolderItem(fontPath, FolderItem.PathModes.Native)
		      End If

		    #ElseIf TargetLinux Then
		      // Linux: Try common system fonts (DejaVu, Liberation, FreeFonts)
		      fontPath = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
		      fontFile = New FolderItem(fontPath, FolderItem.PathModes.Native)

		      If fontFile = Nil Or Not fontFile.Exists Then
		        fontPath = "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"
		        fontFile = New FolderItem(fontPath, FolderItem.PathModes.Native)
		      End If

		      If fontFile = Nil Or Not fontFile.Exists Then
		        fontPath = "/usr/share/fonts/truetype/freefont/FreeSans.ttf"
		        fontFile = New FolderItem(fontPath, FolderItem.PathModes.Native)
		      End If

		    #Else
		      // macOS: Try system fonts with Unicode support
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
		      #If TargetiOS Or TargetAndroid Then
		        // iOS: Load font from MemoryBlock (file is in bundle)
		        Try
		          #If TargetAndroid Then
		            // Read the font from a regular file in Caches: reading it straight from the app
		            // resource (inside the APK) is 2.5x slower on Android (measured 64 s vs 26 s)
		            Dim cachedFont As FolderItem = SpecialFolder.Caches.Child(fontFile.Name)
		            If Not cachedFont.Exists Then fontFile.CopyTo(cachedFont)
		            fontFile = cachedFont
		          #EndIf
		          Dim fontStream As BinaryStream = BinaryStream.Open(fontFile)
		          #If TargetAndroid Then
		            // Read in 1 MB chunks into a preallocated MemoryBlock rather than one Read()
		            // of the whole 23 MB font
		            Dim fontLength As Integer = fontStream.Length
		            Dim fontBytes As New MemoryBlock(fontLength)
		            Dim readOffset As Integer = 0
		            While readOffset < fontLength
		              Dim chunkSize As Integer = 1048576
		              If fontLength - readOffset < chunkSize Then chunkSize = fontLength - readOffset
		              Dim chunk As String = fontStream.Read(chunkSize)
		              If chunk.Bytes = 0 Then Exit While
		              fontBytes.StringValue(readOffset, chunk.Bytes) = chunk
		              readOffset = readOffset + chunk.Bytes
		            Wend
		          #Else
		            Dim fontBytes As MemoryBlock = fontStream.Read(fontStream.Length)
		          #EndIf
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
		        pdf.Cell(0, 7, "$ Dollar  £ Pound  € Euro  ¥ Yen  ¢ Cent", 1, 1)
		        pdf.Cell(0, 7, "₪ Shekel  ₩ Won  ₦ Naira  ƒ Florin  ₡ Colón", 1, 1)
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
		        
		        // Section: Color Emoji (Desktop, iOS, Web - rendered as images)
		        #If TargetDesktop Or TargetiOS Or TargetAndroid Or TargetWeb Then
		          pdf.SetFont("helvetica", "B", 10)
		          pdf.Cell(0, 6, "Color Emoji Support (Image-Based Rendering):", 0, 1)
		          pdf.SetFont("helvetica", "", 9)
		          #If TargetDesktop Then
		            pdf.MultiCell(0, 4, "Emoji are rendered using the platform's native emoji font (Apple Color Emoji, Segoe UI Emoji, or Noto Color Emoji) and embedded as images for cross-platform compatibility.", 0)
		          #ElseIf TargetiOS Then
		            pdf.MultiCell(0, 4, "Emoji are rendered using iOS UIKit API with the native emoji font and embedded as JPEG images.", 0)
		          #ElseIf TargetWeb Then
		            pdf.MultiCell(0, 4, "Emoji are rendered by parsing the SBIX table from Apple Color Emoji.ttc and extracting embedded PNG images (macOS Web servers).", 0)
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
		            
		            For i As Integer = 0 To emojiArray.LastIndex
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
		      
		      #If TargetiOS Or TargetAndroid Then
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
		  
		  result.Value("message") = statusText
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
		    
		    result.Value("message") = statusText
		    Return result
		    
		  #Else
		    // iOS: Return error - this example requires Desktop Graphics API
		    result.Value("message") = "Error: Example 5 Xojo requires Desktop platform (uses Graphics API)"
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
		  
		  result.Value("message") = statusText
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
		    
		    // Set document metadata using Xojo-compatible property syntax
		    pdf.Title = "Example 7: Document Metadata"
		    pdf.Author = "Xojo FPDF Library"
		    pdf.Subject = "Demonstration of PDF metadata features"
		    pdf.Keywords = "PDF metadata title author subject keywords"
		    pdf.Creator = "VNS PDF Example Generator"
		    pdf.Language = "en-US"
		    
		    statusText = statusText + "Metadata set:" + EndOfLine
		    statusText = statusText + "  Title: Example 7: Document Metadata" + EndOfLine
		    statusText = statusText + "  Author: Xojo FPDF Library" + EndOfLine
		    statusText = statusText + "  Subject: Demonstration of PDF metadata features" + EndOfLine
		    statusText = statusText + "  Keywords: PDF metadata title author subject keywords" + EndOfLine
		    statusText = statusText + "  Creator: VNS PDF Example Generator" + EndOfLine
		    statusText = statusText + "  Language: en-US" + EndOfLine

		    // First page already added by constructor
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
		  
		  result.Value("message") = statusText
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

		    // First page already added by constructor
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
		  
		  result.Value("message") = statusText
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
		    #If TargetiOS Or TargetAndroid Then
		      // The Testpdf image item is compiled into the mobile apps: use it directly.
		      // On Android, SpecialFolder.Resource() raises for a missing name, so the
		      // file lookups below are only a fallback.
		      Dim bundledPic As Picture = Testpdf
		      Dim resourceFile As FolderItem
		      
		      // Try to load bundled image - try multiple name variations
		      If jpegFile = Nil And pngFile = Nil And bundledPic = Nil Then
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
		    // Nested If instead of "imageFile <> Nil And imageFile.Exists": the Android
		    // transpiler turns that expression into an infix call on a nullable value
		    Dim hasImages As Boolean = False
		    If imageFile <> Nil Then
		      If imageFile.Exists Then hasImages = True
		    End If
		    #If TargetiOS Or TargetAndroid Then
		      If bundledPic <> Nil Then hasImages = True
		    #EndIf
		    
		    If hasImages Then
		      pdf.SetFont("helvetica", "B", 14)
		      pdf.Cell(0, 8, "Image Support Demonstration", 0, 1, "C")
		      pdf.Ln(5)
		      
		      // iOS: Handle bundled image using RegisterImageFromBytes
		      #If TargetiOS Or TargetAndroid Then
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
		      pdf.AddPage()
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
		        Dim pic As New Picture(picWidth, picHeight)  // High-res
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
		        #If TargetiOS Or TargetAndroid Then
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
		        // Note: MobileChart not available on Android in Xojo 2025r3
		        pdf.AddPage()
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
		          Dim chartPic As New Picture(800, 600)  // RGB without alpha
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
		      #If TargetiOS Or TargetAndroid Then
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
		      result.Value("message") = statusText
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
		  
		  result.Value("message") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HexToString(hex As String) As String
		  // Convert hex string to binary string
		  // Example: "2b7e" -> String.ChrByte(&h2b) + String.ChrByte(&h7e)
		  
		  Dim result As String = ""
		  Dim hexLen As Integer = hex.Length
		  
		  For i As Integer = 0 To hexLen - 1 Step 2
		    Dim hexByte As String = hex.Middle(i, 2)  // API2 Middle is 0-based on all platforms
		    Dim byteValue As Integer = Val("&h" + hexByte)
		    result = result + String.ChrByte(byteValue)
		  Next
		  
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

	#tag Method, Flags = &h21
		Private Function StringToHex(s As String) As String
		  // Convert binary string to hex string (for debugging)
		  // Example: String.ChrByte(&h2b) + String.ChrByte(&h7e) -> "2b7e"
		  
		  Dim result As String = ""
		  Dim sLen As Integer = s.Bytes
		  For i As Integer = 0 To sLen - 1
		    Dim byteValue As Integer = s.MiddleBytes(i, 1).AscByte
		    Dim hexByte As String = Hex(byteValue)
		    If hexByte.Length = 1 Then hexByte = "0" + hexByte
		    result = result + hexByte
		  Next
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestAdler32() As Dictionary
		  // Test ADLER-32 checksum with known test vectors
		  Dim result As New Dictionary
		  Dim output As String = ""
		  
		  #If hasPremiumVNSZlibModule Then
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
		    output = "  (Skipped - hasPremiumVNSZlibModule = False)" + EndOfLine
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
		  output = output + "Running NIST SP 800-38A + 800-38D test vectors..." + EndOfLine + EndOfLine
		  
		  Dim allPassed As Boolean = True
		  
		  // Test ECB-AES128
		  output = output + "Testing ECB-AES128..." + EndOfLine
		  Dim test1Result As Dictionary = TestECB_AES128()
		  Dim testOutput As String = test1Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test1Result.Value("passed") = True Then
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
		  If test2Result.Value("passed") = True Then
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
		  If test3Result.Value("passed") = True Then
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
		  If test4Result.Value("passed") = True Then
		    output = output + "  CBC-AES256: PASSED" + EndOfLine
		  Else
		    output = output + "  CBC-AES256: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine
		  
		  // Test ECB-AES128 Decrypt
		  output = output + "Testing ECB-AES128 Decrypt..." + EndOfLine
		  Dim test5Result As Dictionary = TestDecryptECB_AES128()
		  testOutput = test5Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test5Result.Value("passed") = True Then
		    output = output + "  ECB-AES128 Decrypt: PASSED" + EndOfLine
		  Else
		    output = output + "  ECB-AES128 Decrypt: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test CBC-AES128 Decrypt
		  output = output + "Testing CBC-AES128 Decrypt..." + EndOfLine
		  Dim test6Result As Dictionary = TestDecryptCBC_AES128()
		  testOutput = test6Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test6Result.Value("passed") = True Then
		    output = output + "  CBC-AES128 Decrypt: PASSED" + EndOfLine
		  Else
		    output = output + "  CBC-AES128 Decrypt: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test CBC-AES256 PKCS7 Roundtrip
		  output = output + "Testing CBC-AES256 PKCS7 Roundtrip..." + EndOfLine
		  Dim test7Result As Dictionary = TestCBC_AES256_PKCS7()
		  testOutput = test7Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test7Result.Value("passed") = True Then
		    output = output + "  CBC-AES256 PKCS7: PASSED" + EndOfLine
		  Else
		    output = output + "  CBC-AES256 PKCS7: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test GCM-AES128 (NIST SP 800-38D)
		  output = output + "Testing GCM-AES128 (NIST SP 800-38D)..." + EndOfLine
		  Dim test8Result As Dictionary = TestGCM_AES128()
		  testOutput = test8Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test8Result.Value("passed") = True Then
		    output = output + "  GCM-AES128: PASSED" + EndOfLine
		  Else
		    output = output + "  GCM-AES128: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test GCM Decrypt + Authentication
		  output = output + "Testing GCM Decrypt + Auth..." + EndOfLine
		  Dim test9Result As Dictionary = TestGCM_Decrypt()
		  testOutput = test9Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test9Result.Value("passed") = True Then
		    output = output + "  GCM Decrypt: PASSED" + EndOfLine
		  Else
		    output = output + "  GCM Decrypt: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test GCM Authentication Failure
		  output = output + "Testing GCM Auth Failure..." + EndOfLine
		  Dim test10Result As Dictionary = TestGCM_AuthFail()
		  testOutput = test10Result.Value("output")
		  If testOutput <> "" Then output = output + testOutput
		  If test10Result.Value("passed") = True Then
		    output = output + "  GCM Auth Fail: PASSED" + EndOfLine
		  Else
		    output = output + "  GCM Auth Fail: FAILED" + EndOfLine
		    allPassed = False
		  End If
		  output = output + EndOfLine

		  // Test SHA-384 (needed for PDF Revision 6)
		  #If hasPremiumVNSEncryptionModule Then
		    output = output + "Testing SHA-384..." + EndOfLine
		    Dim testSHA384 As Boolean = VNSPDFEncryptionPremium.TestSHA384()
		    If testSHA384 Then
		      output = output + "  SHA-384: PASSED" + EndOfLine
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
		    output = output + "AES-128 (ECB + CBC encrypt/decrypt) - Ready for PDF Revision 4" + EndOfLine
		    output = output + "AES-256 (ECB + CBC encrypt/decrypt) - Ready for PDF Revisions 5-6" + EndOfLine
		    output = output + "AES-GCM (authenticated encrypt/decrypt) - Ready for general use" + EndOfLine
		    #If hasPremiumVNSEncryptionModule Then
		      output = output + "SHA-384 - Ready for PDF Revision 6" + EndOfLine
		    #EndIf
		  Else
		    output = output + "=== SOME TESTS FAILED ===" + EndOfLine
		    output = output + "Review the output above for details." + EndOfLine
		  End If
		  output = output + EndOfLine
		  
		  result.Value("passed") = allPassed
		  // Ensure output is UTF-8 (binary operations in tests can strip encoding)
		  result.Value("output") = output.DefineEncoding(Encodings.UTF8)
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestCBC_AES128() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""
		  
		  #If hasPremiumVNSEncryptionModule Then
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
		      output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		      output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		      output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      
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
		  
		  #If hasPremiumVNSEncryptionModule Then
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
		      output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		      output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		      output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      
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
		Private Function TestECB_AES128() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""
		  
		  #If hasPremiumVNSEncryptionModule Then
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
		      output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		      output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		      output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      
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
		  
		  #If hasPremiumVNSEncryptionModule Then
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
		      output = output + "  Input:    " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		      output = output + "  Expected: " + StringToHex(expectedCiphertext).Left(32) + "..." + EndOfLine
		      output = output + "  Got:      " + StringToHex(ciphertext).Left(32) + "..." + EndOfLine
		      
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
		Private Function TestDecryptECB_AES128() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If hasPremiumVNSEncryptionModule Then
		    Try
		      Dim key As String = HexToString("2b7e151628aed2a6abf7158809cf4f3c")

		      Dim ciphertext As String = HexToString( _
		      "3ad77bb40d7a3660a89ecaf32466ef97" + _
		      "f5d3d58503b9699de785895a96fdbaaf" + _
		      "43b1cd7f598ece23881b00e3ed030688" + _
		      "7b0c785e27e8ad3f8223207104725dd4")

		      Dim expectedPlaintext As String = HexToString( _
		      "6bc1bee22e409f96e93d7e117393172a" + _
		      "ae2d8a571e03ac9c9eb76fac45af8e51" + _
		      "30c81c46a35ce411e5fbc1191a0a52ef" + _
		      "f69f2445df4f9b17ad2b417be66c3710")

		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes.SetKey(key)
		      Dim plaintext As String = aes.DecryptECB(ciphertext)

		      output = output + "  Decrypted: " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		      output = output + "  Expected:  " + StringToHex(expectedPlaintext).Left(32) + "..." + EndOfLine

		      result.Value("passed") = (plaintext = expectedPlaintext)
		      If plaintext <> expectedPlaintext Then
		        output = output + "  ERROR: Plaintext mismatch!" + EndOfLine
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
		Private Function TestDecryptCBC_AES128() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If hasPremiumVNSEncryptionModule Then
		    Try
		      Dim key As String = HexToString("2b7e151628aed2a6abf7158809cf4f3c")
		      Dim iv As String = HexToString("000102030405060708090a0b0c0d0e0f")

		      Dim ciphertext As String = HexToString( _
		      "7649abac8119b246cee98e9b12e9197d" + _
		      "5086cb9b507219ee95db113a917678b2" + _
		      "73bed6b8e3c1743b7116e69e22229516" + _
		      "3ff1caa1681fac09120eca307586e1a7")

		      Dim expectedPlaintext As String = HexToString( _
		      "6bc1bee22e409f96e93d7e117393172a" + _
		      "ae2d8a571e03ac9c9eb76fac45af8e51" + _
		      "30c81c46a35ce411e5fbc1191a0a52ef" + _
		      "f69f2445df4f9b17ad2b417be66c3710")

		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes.SetKey(key)
		      Dim plaintext As String = aes.DecryptCBC(ciphertext, iv)

		      output = output + "  Decrypted: " + StringToHex(plaintext).Left(32) + "..." + EndOfLine
		      output = output + "  Expected:  " + StringToHex(expectedPlaintext).Left(32) + "..." + EndOfLine

		      result.Value("passed") = (plaintext = expectedPlaintext)
		      If plaintext <> expectedPlaintext Then
		        output = output + "  ERROR: Plaintext mismatch!" + EndOfLine
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
		Private Function TestCBC_AES256_PKCS7() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If hasPremiumVNSEncryptionModule Then
		    Try
		      Dim key As String = HexToString("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4")
		      Dim iv As String = HexToString("000102030405060708090a0b0c0d0e0f")
		      Dim plaintext As String = "Hello, AES-256-CBC with PKCS7!"

		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength256)
		      aes.SetKey(key)

		      Dim padded As String = aes.PKCS7Pad(plaintext)
		      Dim ciphertext As String = aes.EncryptCBC(padded, iv)
		      Dim decrypted As String = aes.DecryptCBC(ciphertext, iv)
		      Dim unpadded As String = aes.PKCS7Unpad(decrypted)
		      // DefineEncoding: DecryptCBC returns binary string, must convert to UTF-8 for display
		      unpadded = unpadded.DefineEncoding(Encodings.UTF8)

		      output = output + "  Original:  " + plaintext + EndOfLine
		      output = output + "  Roundtrip: " + unpadded + EndOfLine

		      result.Value("passed") = (unpadded = plaintext And aes.Ok)
		      If unpadded <> plaintext Then
		        output = output + "  ERROR: Roundtrip mismatch!" + EndOfLine
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
		Private Function TestGCM_AES128() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If hasPremiumVNSEncryptionModule Then
		    Try
		      // NIST SP 800-38D Test Case 2
		      Dim key As String = HexToString("00000000000000000000000000000000")
		      Dim iv As String = HexToString("000000000000000000000000")
		      Dim pt As String = HexToString("00000000000000000000000000000000")
		      Dim expectedCT As String = HexToString("0388dace60b6a392f328c2b971b2fe78")
		      Dim expectedTag As String = HexToString("ab6e47d42cec13bdf53a67b21257bddf")

		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes.SetKey(key)

		      Dim tag As String
		      Dim ct As String = aes.EncryptGCM(pt, iv, "", tag)

		      output = output + "  Test Case 2 (zero key, zero IV, zero PT):" + EndOfLine
		      output = output + "  CT Expected: " + StringToHex(expectedCT) + EndOfLine
		      output = output + "  CT Got:      " + StringToHex(ct) + EndOfLine
		      output = output + "  Tag Expected: " + StringToHex(expectedTag) + EndOfLine
		      output = output + "  Tag Got:      " + StringToHex(tag) + EndOfLine

		      Dim passed As Boolean = (ct = expectedCT And tag = expectedTag)

		      // NIST Test Case 4 (with AAD)
		      Dim key4 As String = HexToString("feffe9928665731c6d6a8f9467308308")
		      Dim iv4 As String = HexToString("cafebabefacedbaddecaf888")
		      Dim aad4 As String = HexToString("feedfacedeadbeeffeedfacedeadbeefabaddad2")
		      Dim pt4 As String = HexToString( _
		      "d9313225f88406e5a55909c5aff5269a" + _
		      "86a7a9531534f7da2e4c303d8a318a72" + _
		      "1c3c0c95956809532fcf0e2449a6b525" + _
		      "b16aedf5aa0de657ba637b39")
		      Dim expectedTag4 As String = HexToString("5bc94fbc3221a5db94fae95ae7121a47")

		      Dim aes4 As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes4.SetKey(key4)
		      Dim tag4 As String
		      Dim ct4 As String = aes4.EncryptGCM(pt4, iv4, aad4, tag4)

		      output = output + "  Test Case 4 (with AAD, 60-byte PT):" + EndOfLine
		      output = output + "  Tag Expected: " + StringToHex(expectedTag4) + EndOfLine
		      output = output + "  Tag Got:      " + StringToHex(tag4) + EndOfLine

		      If tag4 <> expectedTag4 Then passed = False

		      result.Value("passed") = passed
		      If Not passed Then
		        output = output + "  ERROR: GCM test vectors mismatch!" + EndOfLine
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
		Private Function TestGCM_Decrypt() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If hasPremiumVNSEncryptionModule Then
		    Try
		      Dim key As String = HexToString("feffe9928665731c6d6a8f9467308308")
		      Dim iv As String = HexToString("cafebabefacedbaddecaf888")
		      Dim aad As String = HexToString("feedfacedeadbeeffeedfacedeadbeefabaddad2")
		      Dim pt As String = HexToString( _
		      "d9313225f88406e5a55909c5aff5269a" + _
		      "86a7a9531534f7da2e4c303d8a318a72" + _
		      "1c3c0c95956809532fcf0e2449a6b525" + _
		      "b16aedf5aa0de657ba637b39")

		      // Encrypt
		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes.SetKey(key)
		      Dim tag As String
		      Dim ct As String = aes.EncryptGCM(pt, iv, aad, tag)

		      // Decrypt
		      Dim aes2 As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes2.SetKey(key)
		      Dim decrypted As String = aes2.DecryptGCM(ct, iv, aad, tag)

		      output = output + "  Encrypt then decrypt roundtrip with AAD" + EndOfLine
		      output = output + "  Match: " + Str(decrypted = pt) + EndOfLine

		      result.Value("passed") = (decrypted = pt And aes2.Ok)
		      If decrypted <> pt Then
		        output = output + "  ERROR: GCM roundtrip mismatch!" + EndOfLine
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
		Private Function TestGCM_AuthFail() As Dictionary
		  Dim result As New Dictionary
		  Dim output As String = ""

		  #If hasPremiumVNSEncryptionModule Then
		    Try
		      Dim key As String = HexToString("00000000000000000000000000000000")
		      Dim iv As String = HexToString("000000000000000000000000")
		      Dim pt As String = HexToString("00000000000000000000000000000000")

		      Dim aes As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes.SetKey(key)
		      Dim tag As String
		      Dim ct As String = aes.EncryptGCM(pt, iv, "", tag)

		      // Tamper with tag
		      Dim badTag As String = VNSPDFModule.StringChrB(VNSPDFModule.StringAscB(VNSPDFModule.StringMidB(tag, 1, 1)) Xor &hFF)
		      badTag = badTag + VNSPDFModule.StringMidB(tag, 2, VNSPDFModule.StringLenB(tag) - 1)

		      // Decrypt with tampered tag should fail
		      Dim aes2 As New VNSAESCore(VNSAESConstants.kAESKeyLength128)
		      aes2.SetKey(key)
		      Call aes2.DecryptGCM(ct, iv, "", badTag)

		      Dim authFailed As Boolean = (aes2.GetError = VNSAESConstants.eAESError.AuthenticationFailed)
		      output = output + "  Tampered tag detected: " + Str(authFailed) + EndOfLine

		      result.Value("passed") = authFailed

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
		  If test1Result.Value("passed") = True Then
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
		  If test2Result.Value("passed") = True Then
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
		  If test3Result.Value("passed") = True Then
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
		  If test4Result.Value("passed") = True Then
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
		  If test5Result.Value("passed") = True Then
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
		  If test6Result.Value("passed") = True Then
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
		  
		  #If hasPremiumVNSZlibModule Then
		    Dim deflater As New VNSZlibPremiumDeflate
		    Dim compressedResult As MemoryBlock = deflater.CompressString("")
		    // Empty input should return Nil
		    result.Value("passed") = (compressedResult = Nil)
		  #Else
		    result.Value("output") = "  (Skipped - hasPremiumVNSZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestZlibRepeatedPattern() As Dictionary
		  // Test compression of repeated data (should compress well)
		  Dim result As New Dictionary
		  Dim output As String = ""
		  
		  #If hasPremiumVNSZlibModule Then
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
		      #If TargetiOS Or TargetAndroid Then
		        Dim inputLen As Integer = input.Length
		      #Else
		        Dim inputLen As Integer = input.Bytes
		      #EndIf
		      Dim ratio As Double = 100.0 * compressedResult.Size / inputLen
		      output = output + "  Input: " + Str(inputLen) + " bytes, Output: " + Str(compressedResult.Size) + " bytes" + EndOfLine
		      #If TargetiOS Or TargetAndroid Then
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
		    output = "  (Skipped - hasPremiumVNSZlibModule = False)" + EndOfLine
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
		  
		  #If hasPremiumVNSZlibModule Then
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
		        #If TargetiOS Or TargetAndroid Then
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
		    output = "  (Skipped - hasPremiumVNSZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf
		  
		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestZlibRoundTrip() As Dictionary
		  // Test that our compressed data can be decompressed
		  // Now uses pure Xojo inflate on all platforms when hasPremiumVNSZlibModule = True
		  Dim result As New Dictionary
		  Dim output As String = ""
		  
		  #If hasPremiumVNSZlibModule Then
		    Dim deflater As New VNSZlibPremiumDeflate
		    Dim input As String = "This is a test of the pure Xojo zlib compression implementation. It should compress and decompress correctly!"
		    
		    // Compress with our implementation
		    Dim compressed As MemoryBlock = deflater.CompressString(input)
		    If compressed = Nil Or compressed.Size = 0 Then
		      output = output + "  Error: Compression failed" + EndOfLine
		      result.Value("passed") = False
		    Else
		      #If TargetiOS Or TargetAndroid Then
		        output = output + "  Compressed " + Str(input.Length) + " -> " + Str(compressed.Size) + " bytes" + EndOfLine
		      #Else
		        output = output + "  Compressed " + Str(input.Bytes) + " -> " + Str(compressed.Size) + " bytes" + EndOfLine
		      #EndIf
		      
		      // Try to decompress using VNSZlibModule.Uncompress
		      // This uses pure Xojo inflate on all platforms when hasPremiumVNSZlibModule = True
		      Dim compressedStr As String = compressed.StringValue(0, compressed.Size)
		      
		      #If TargetiOS Or TargetAndroid Then
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
		        #If TargetiOS Or TargetAndroid Then
		          output = output + "  (Using pure Xojo inflate on iOS)" + EndOfLine
		        #Else
		          output = output + "  (Using pure Xojo inflate)" + EndOfLine
		        #EndIf
		        result.Value("passed") = True
		      Else
		        output = output + "  Error: Decompressed data doesn't match original" + EndOfLine
		        #If TargetiOS Or TargetAndroid Then
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
		    output = "  (Skipped - hasPremiumVNSZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf
		  
		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestZlibShortString() As Dictionary
		  // Test compressing a short string
		  Dim result As New Dictionary
		  Dim output As String = ""
		  
		  #If hasPremiumVNSZlibModule Then
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
		        #If TargetiOS Or TargetAndroid Then
		          output = output + "  Input: " + Str(input.Length) + " bytes, Output: " + Str(compressedResult.Size) + " bytes" + EndOfLine
		        #Else
		          output = output + "  Input: " + Str(input.Bytes) + " bytes, Output: " + Str(compressedResult.Size) + " bytes" + EndOfLine
		        #EndIf
		        result.Value("passed") = True
		      End If
		    End If
		  #Else
		    output = "  (Skipped - hasPremiumVNSZlibModule = False)" + EndOfLine
		    result.Value("passed") = True
		  #EndIf
		  
		  result.Value("output") = output
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateExample25(sourcePath As String = "") As Dictionary
		  // Example 25: Automatic TOC Generation
		  // Analyzes a PDF without TOC, detects chapter headings, and generates a new PDF with working TOC
		  //
		  // This example demonstrates:
		  // - PDF text extraction using pdftotext
		  // - Automatic heading detection using pattern matching
		  // - PDF import using SetSourceFile() and ImportPage()
		  // - TOC generation using AddTOCEntry()
		  //
		  // Platform: Desktop/Console only (requires Shell access)

		  Dim result As New Dictionary
		  Dim statusText As String = ""

		  statusText = statusText + "Example 25: Automatic TOC Generation" + EndOfLine
		  statusText = statusText + "========================================" + EndOfLine + EndOfLine

		  #If Not (TargetDesktop Or TargetConsole) Then
		    statusText = statusText + "✗ ERROR: This example requires Desktop or Console target" + EndOfLine
		    statusText = statusText + "   (Shell access needed for pdftotext)" + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    result.Value("filename") = ""
		    Return result
		  #EndIf

		  // Check if source path provided
		  If sourcePath = "" Then
		    statusText = statusText + "✗ ERROR: No source PDF path provided" + EndOfLine
		    statusText = statusText + EndOfLine
		    statusText = statusText + "Usage:" + EndOfLine
		    statusText = statusText + "  GenerateExample25(""/path/to/source.pdf"")" + EndOfLine
		    statusText = statusText + EndOfLine
		    statusText = statusText + "This example will:" + EndOfLine
		    statusText = statusText + "  1. Extract text from the source PDF" + EndOfLine
		    statusText = statusText + "  2. Detect chapter headings automatically" + EndOfLine
		    statusText = statusText + "  3. Import all pages from the source" + EndOfLine
		    statusText = statusText + "  4. Generate a new PDF with working TOC" + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    result.Value("filename") = ""
		    Return result
		  End If

		  // Check if source file exists
		  Dim sourceFile As FolderItem = New FolderItem(sourcePath, FolderItem.PathModes.Native)
		  If Not sourceFile.Exists Then
		    statusText = statusText + "✗ ERROR: Source PDF not found: " + sourcePath + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    result.Value("filename") = ""
		    Return result
		  End If

		  statusText = statusText + "Source PDF: " + sourceFile.Name + EndOfLine
		  statusText = statusText + "Path: " + sourcePath + EndOfLine + EndOfLine

		  // Step 1: Detect TOC entries by analyzing PDF text
		  statusText = statusText + "Step 1: Detecting chapter headings..." + EndOfLine

		  Dim tocEntries() As Dictionary = DetectTOCEntries(sourcePath, statusText)

		  If tocEntries.Count = 0 Then
		    statusText = statusText + "✗ WARNING: No headings detected" + EndOfLine
		    statusText = statusText + "   The PDF may not have a clear heading structure" + EndOfLine
		    statusText = statusText + "   or pdftotext is not installed" + EndOfLine
		  Else
		    statusText = statusText + "✓ Detected " + Str(tocEntries.Count) + " potential chapters" + EndOfLine + EndOfLine

		    statusText = statusText + "Detected TOC entries:" + EndOfLine
		    For Each entry As Dictionary In tocEntries
		      statusText = statusText + "  Page " + FormatHelper(entry.Value("page"), "###") + ": " + entry.Value("title") + EndOfLine
		    Next
		    statusText = statusText + EndOfLine
		  End If

		  // Step 2: Create new PDF with TOC
		  statusText = statusText + "Step 2: Creating PDF with TOC..." + EndOfLine

		  Dim pdf As New VNSPDFDocument()
		  pdf.Title = "TOC Enhanced - " + sourceFile.Name
		  pdf.Author = "VNS PDF Library - Example 25"
		  pdf.Subject = "Automatically generated table of contents"

		  // Import source PDF
		  Dim pageCount As Integer = pdf.SetSourceFile(sourcePath)

		  If pdf.Err() Then
		    statusText = statusText + "✗ ERROR: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    result.Value("filename") = ""
		    Return result
		  End If

		  statusText = statusText + "✓ Opened source PDF (" + Str(pageCount) + " pages)" + EndOfLine

		  // Add TOC entries BEFORE importing pages (deferred TOC processing)
		  If tocEntries.Count > 0 Then
		    statusText = statusText + "✓ Adding " + Str(tocEntries.Count) + " TOC entries..." + EndOfLine
		    For Each entry As Dictionary In tocEntries
		      Dim pageNum As Integer = entry.Value("page")
		      Dim title As String = entry.Value("title")

		      // Add TOC entry (will be processed during PDF output)
		      Call pdf.AddTOCEntry(title, pageNum, 0)
		    Next
		  End If

		  // Import all pages
		  statusText = statusText + "✓ Importing all pages..." + EndOfLine

		  For i As Integer = 1 To pageCount
		    Dim templateID As Integer = pdf.ImportPage(i)

		    If pdf.Err() Then
		      statusText = statusText + "  ✗ ERROR importing page " + Str(i) + ": " + pdf.GetError() + EndOfLine
		      pdf.ClearError()
		      Continue
		    End If

		    // Add a new page and place the imported template
		    Call pdf.AddPage()
		    Call pdf.UseTemplate(templateID, 0, 0, pdf.PageWidth, pdf.PageHeight)
		  Next

		  statusText = statusText + "✓ All pages imported successfully" + EndOfLine + EndOfLine

		  // Save result
		  #If TargetiOS Or TargetAndroid Then
		    Dim desktop As FolderItem = SpecialFolder.Documents
		  #Else
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		  #EndIf
		  Dim outputName As String = sourceFile.Name
		  If outputName.EndsWith(".pdf") Then
		    outputName = outputName.Left(outputName.Length - 4) + "_with_toc.pdf"
		  Else
		    outputName = outputName + "_with_toc.pdf"
		  End If

		  Dim outputFile As FolderItem = desktop.Child(outputName)
		  Call pdf.Save(outputFile)

		  If pdf.Err() Then
		    statusText = statusText + "✗ ERROR saving PDF: " + pdf.GetError() + EndOfLine
		    result.Value("success") = False
		    result.Value("message") = statusText
		    result.Value("filename") = ""
		    Return result
		  End If

		  statusText = statusText + "✓ PDF saved successfully!" + EndOfLine
		  statusText = statusText + "  Output: " + outputFile.NativePath + EndOfLine

		  result.Value("success") = True
		  result.Value("message") = statusText
		  result.Value("filename") = outputFile.NativePath
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Function DetectTOCEntries(pdfPath As String, ByRef statusText As String, Optional thresholdMultiplier As Double = 1.10, Optional progressCallback As ProgressDelegate = Nil) As Dictionary()
		  // Detect TOC entries by analyzing PDF text structure with font information
		  // Returns array of Dictionary with "page" (Integer), "title" (String), and "level" (Integer) keys
		  // thresholdMultiplier: Multiplier of average font size for heading detection (default 1.10 = 10% larger, range 0.5 to 2.0)
		  // progressCallback: Optional callback for progress updates (0.0 to 100.0)

		  System.DebugLog("=== DetectTOCEntries START ===")
		  System.DebugLog("PDF Path: " + pdfPath)
		  System.DebugLog("Threshold multiplier: " + Str(thresholdMultiplier))

		  Dim entries() As Dictionary

		  // Open PDF file for reading
		  Dim reader As New VNSPDFReader
		  If Not reader.OpenFile(pdfPath) Then
		    System.DebugLog("ERROR: Failed to open PDF: " + reader.GetError())
		    statusText = statusText + "  ⚠ Failed to open PDF: " + reader.GetError() + EndOfLine
		    Return entries
		  End If

		  Dim pageCount As Integer = reader.GetPageCount()
		  System.DebugLog("PDF has " + Str(pageCount) + " pages")
		  statusText = statusText + "  PDF has " + Str(pageCount) + " pages" + EndOfLine

		  // Scan all pages
		  Dim maxPages As Integer = pageCount
		  System.DebugLog("Analyzing all " + Str(maxPages) + " pages...")

		  // First pass: Analyze all pages to determine average font size
		  Dim fontSizes() As Double
		  For pageNum As Integer = 1 To maxPages
		    Dim page As VNSPDFImportedPage = reader.GetPage(pageNum)
		    If page <> Nil Then
		      Dim extractor As New VNSPDFTextExtractor
		      Dim blocks() As VNSPDFTextBlock = extractor.ExtractText(page, reader)

		      For Each block As VNSPDFTextBlock In blocks
		        If block.fontSize > 0 Then
		          fontSizes.Add(block.fontSize)
		        End If
		      Next
		    End If

		    // Report progress (first pass is 0% to 50%)
		    If progressCallback <> Nil Then
		      Dim percentage As Double = (pageNum / maxPages) * 50.0
		      progressCallback.Invoke(percentage)
		    End If

		    If pageNum Mod 25 = 0 Then
		      System.DebugLog("  ... analyzed " + Str(pageNum) + " pages for font sizes")
		    End If
		  Next

		  // Calculate average and threshold for heading detection
		  Dim avgFontSize As Double = 10.0  // Default
		  If fontSizes.Count > 0 Then
		    Dim total As Double = 0
		    For Each size As Double In fontSizes
		      total = total + size
		    Next
		    avgFontSize = total / fontSizes.Count
		  End If

		  Dim headingThreshold As Double = avgFontSize * thresholdMultiplier
		  System.DebugLog("Average font size: " + Str(avgFontSize) + " pt")
		  System.DebugLog("Heading threshold: " + Str(headingThreshold) + " pt (" + Str((thresholdMultiplier - 1.0) * 100) + "% above average)")

		  // Second pass: Detect headings based on font size
		  System.DebugLog("Starting heading detection...")
		  statusText = statusText + "  Detecting headings by font size..." + EndOfLine

		  For pageNum As Integer = 1 To maxPages
		    Dim page As VNSPDFImportedPage = reader.GetPage(pageNum)
		    If page = Nil Then Continue

		    Dim extractor As New VNSPDFTextExtractor
		    Dim blocks() As VNSPDFTextBlock = extractor.ExtractText(page, reader)

		    // Look for text blocks with large font size (likely headings)
		    // Only examine blocks in upper part of page (first 150 points from top)
		    For Each block As VNSPDFTextBlock In blocks
		      // Check if font size is above threshold
		      If block.fontSize < headingThreshold Then Continue

		      // NOTE: Y position filtering disabled because many PDFs don't use Tm operators,
		      // resulting in all blocks having Y=0. Font size alone is sufficient for heading detection.

		      Dim text As String = block.text.Trim
		      If text = "" Or text.Length < 3 Or text.Length > 150 Then Continue

		      // Filter numbered list items (single numbers like "1.")
		      If text.Length < 4 And text.IndexOf(".") > 0 Then
		        Dim beforeDot As String = text.Left(text.IndexOf("."))
		        Dim isNumber As Boolean = True
		        For k As Integer = 0 To beforeDot.Length - 1
		          If Not (beforeDot.Middle(k, 1) >= "0" And beforeDot.Middle(k, 1) <= "9") Then
		            isNumber = False
		            Exit For k
		          End If
		        Next
		        If isNumber Then Continue
		      End If

		      // Filter instruction steps starting with numbers
		      If text.Length > 3 And text.Middle(0, 1) >= "0" And text.Middle(0, 1) <= "9" Then
		        If text.Middle(1, 2) = ". " Or text.Length > 2 And text.Middle(2, 2) = ". " Then
		          Continue
		        End If
		      End If

		      // Determine level based on font size relative to threshold
		      // Very large font = level 0 (main chapter), slightly large = level 1 (sub-chapter)
		      Dim level As Integer = 0
		      If block.fontSize < headingThreshold * 1.3 Then
		        level = 1  // Sub-chapter
		      End If

		      // Add entry
		      Dim entry As New Dictionary
		      entry.Value("page") = pageNum
		      entry.Value("title") = text
		      entry.Value("level") = level
		      entry.Value("fontSize") = block.fontSize
		      entries.Add(entry)

		      System.DebugLog("FOUND Page " + Str(pageNum) + " [Level " + Str(level) + ", " + Str(block.fontSize) + "pt]: " + text)
		      statusText = statusText + "  Page " + Str(pageNum) + " [L" + Str(level) + "]: " + text + EndOfLine
		    Next

		    // Report progress (second pass is 50% to 100%)
		    If progressCallback <> Nil Then
		      Dim percentage As Double = 50.0 + (pageNum / maxPages) * 50.0
		      progressCallback.Invoke(percentage)
		    End If

		    If pageNum Mod 25 = 0 Then
		      System.DebugLog("  ... scanned " + Str(pageNum) + " pages so far, " + Str(entries.Count) + " headings found")
		    End If
		  Next

		  System.DebugLog("=== FINAL RESULTS ===")
		  System.DebugLog("Total headings found: " + Str(entries.Count))
		  System.DebugLog("=== DetectTOCEntries END ===")

		  statusText = statusText + EndOfLine + "  Total: " + Str(entries.Count) + " potential headings found" + EndOfLine

		  Return entries
		End Function
	#tag EndMethod


	#tag Method, Flags = &h0
		Function GenerateExample26_BugTests() As Dictionary
		  // Example 26: Bug Testing - Tests for issues reported by Geoff Bridges (Windows user)
		  // Tests: MultiCell borders, newline handling, SplitTextToLines first character, ImageFromPicture PNG/JPEG

		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 26: Bug Tests..." + EndOfLine
		  statusText = statusText + "Testing platform-specific issues reported on Windows..." + EndOfLine

		  Try
		    Dim pdf As New VNSPDFDocument()
		    pdf.Compressed = False // Disable compression for free version (no ZLIB1.DLL on Windows)
		    pdf.Title = "Bug Tests - Geoff Bridges Report"
		    pdf.Author = "VNS PDF Test Suite"
		    pdf.Subject = "Tests for MultiCell, SplitTextToLines, and ImageFromPicture issues"

		    // Title
		    pdf.SetFont("Helvetica", "B", 18)
		    pdf.Cell(0, 12, "Bug Test Suite - Geoff Bridges Report", 0, 1, "C")
		    pdf.Ln(5)

		    #If TargetWindows Then
		      pdf.SetFont("Helvetica", "I", 10)
		      pdf.SetTextColor(255, 0, 0) // Red on Windows
		      pdf.Cell(0, 6, "Running on WINDOWS - Original bug platform", 0, 1, "C")
		    #ElseIf TargetMacOS Then
		      pdf.SetFont("Helvetica", "I", 10)
		      pdf.SetTextColor(0, 128, 0) // Green on macOS
		      pdf.Cell(0, 6, "Running on macOS - Testing cross-platform behavior", 0, 1, "C")
		    #ElseIf TargetLinux Then
		      pdf.SetFont("Helvetica", "I", 10)
		      pdf.SetTextColor(0, 0, 255) // Blue on Linux
		      pdf.Cell(0, 6, "Running on LINUX - Testing cross-platform behavior", 0, 1, "C")
		    #Else
		      pdf.SetFont("Helvetica", "I", 10)
		      pdf.SetTextColor(128, 128, 128) // Gray on other
		      pdf.Cell(0, 6, "Running on UNKNOWN platform", 0, 1, "C")
		    #EndIf
		    pdf.SetTextColor(0, 0, 0) // Reset to black
		    pdf.Ln(10)

		    // ========== TEST 1: MultiCell Border Rendering ==========
		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "Test 1: MultiCell Border Rendering (ENHANCED)", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 10)
		    pdf.Cell(0, 6, "Issue: Bottom borders missing on single-line MultiCell with borders=1", 0, 1, "L")
		    pdf.Cell(0, 6, "Expected: All borders (top, left, right, bottom) should be visible", 0, 1, "L")
		    pdf.Ln(4)

		    // Test 1a: Single line with border=1 - LARGER and MORE VISIBLE
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "1a. Single-line MultiCell with border=1:", 0, 1, "L")
		    pdf.SetFont("Helvetica", "I", 9)
		    pdf.SetTextColor(255, 0, 0) // Red warning
		    pdf.Cell(0, 5, ">>> If BOTTOM border is missing below, the bug exists on this platform <<<", 0, 1, "L")
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 12)
		    pdf.SetFillColor(255, 255, 200) // Yellow background for visibility
		    pdf.SetLineWidth(0.5) // Thicker line for visibility
		    pdf.MultiCell(150, 15, "SINGLE LINE TEXT - Check all 4 borders", 1, "C", True)
		    pdf.SetLineWidth(0.2) // Reset

		    pdf.Ln(6)

		    // Test 1b: Visual comparison - draw what it SHOULD look like
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "1b. Reference: What it SHOULD look like (Cell with border=1):", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 12)
		    pdf.SetFillColor(200, 255, 200) // Green background
		    pdf.SetLineWidth(0.5)
		    pdf.Cell(150, 15, "REFERENCE - All 4 borders visible", 1, 1, "C", True)
		    pdf.SetLineWidth(0.2)

		    pdf.Ln(6)

		    // Test 1c: Side-by-side comparison
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "1c. Side-by-side: MultiCell (LEFT) vs Cell (RIGHT):", 0, 1, "L")
		    pdf.Ln(2)

		    Dim xStart As Double = pdf.GetX()
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.SetFillColor(255, 200, 200) // Light red
		    pdf.SetLineWidth(0.5)
		    pdf.MultiCell(70, 12, "MultiCell", 1, "C", True)

		    Dim yAfterMultiCell As Double = pdf.GetY()
		    pdf.SetXY(xStart + 80, yAfterMultiCell - 12) // Position for side-by-side
		    pdf.SetFillColor(200, 255, 200) // Light green
		    pdf.Cell(70, 12, "Cell (reference)", 1, 1, "C", True)
		    pdf.SetLineWidth(0.2)

		    pdf.SetY(yAfterMultiCell)
		    pdf.Ln(2)
		    pdf.SetFont("Helvetica", "I", 9)
		    pdf.SetTextColor(0, 0, 255)
		    pdf.Cell(0, 5, "If left box is missing bottom border, bug confirmed!", 0, 1, "L")
		    pdf.SetTextColor(0, 0, 0)

		    pdf.Ln(6)

		    // Test 1d: Multi-line with border=1 (should have borders around entire block)
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "1d. Multi-line MultiCell with border=1 (for comparison):", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.SetFillColor(240, 255, 240)
		    pdf.SetLineWidth(0.5)
		    pdf.MultiCell(150, 8, "This is a longer text that will wrap to multiple lines to test border rendering on multi-line cells.", 1, "L", True)
		    pdf.SetLineWidth(0.2)

		    pdf.Ln(10)

		    // ========== TEST 2: MultiCell Newline Handling ==========
		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "Test 2: MultiCell Newline Character Handling", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 10)
		    pdf.Cell(0, 6, "Issue: Explicit newlines (chr(10)) not respected, CRLF not handled", 0, 1, "L")
		    pdf.Cell(0, 6, "Expected: Three lines with explicit line breaks preserved", 0, 1, "L")
		    pdf.Ln(4)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "2a. MultiCell with explicit newlines:", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.SetFillColor(255, 255, 240)

		    // Text with explicit newlines (LF only)
		    Dim textWithNewlines As String = "First line" + Chr(10) + "Second line" + Chr(10) + "Third line"
		    pdf.MultiCell(100, 6, textWithNewlines, 1, "L", True)

		    pdf.Ln(4)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "2b. MultiCell with CRLF (Windows-style):", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.SetFillColor(240, 255, 255)

		    // Text with CRLF (carriage return + line feed)
		    Dim textWithCRLF As String = "First line" + Chr(13) + Chr(10) + "Second line" + Chr(13) + Chr(10) + "Third line"
		    pdf.MultiCell(100, 6, textWithCRLF, 1, "L", True)

		    pdf.Ln(10)

		    // ========== TEST 3: SplitTextToLines First Character Bug ==========
		    pdf.AddPage()

		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "Test 3: SplitTextToLines First Character Bug", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 10)
		    pdf.Cell(0, 6, "Issue: For loop starts at 1 instead of 0, missing first character of long words", 0, 1, "L")
		    pdf.Cell(0, 6, "Expected: Long word should break with ALL characters visible (starting with 'X')", 0, 1, "L")
		    pdf.Ln(4)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "3a. Very long word starting with 'X' (should see X at start):", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.SetFillColor(255, 240, 255)

		    // Create a word that's definitely too long for the cell width (50mm)
		    Dim longWord As String = "Xylophonemanufacturersassociationinternationalsymposium"
		    pdf.MultiCell(50, 6, longWord, 1, "L", True)

		    pdf.Ln(4)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "3b. Very long word starting with 'A' (should see A at start):", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.SetFillColor(240, 255, 240)

		    Dim longWord2 As String = "Antidisestablishmentarianismphilosophicalperspectives"
		    pdf.MultiCell(50, 6, longWord2, 1, "L", True)

		    pdf.Ln(4)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "3c. Very long word starting with 'Z' (should see Z at start):", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.SetFillColor(240, 240, 255)

		    Dim longWord3 As String = "Zylophonemechanicalengineeringspecificationdocument"
		    pdf.MultiCell(50, 6, longWord3, 1, "L", True)

		    pdf.Ln(10)

		    // ========== TEST 4: ImageFromPicture PNG vs JPEG ==========
		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "Test 4: ImageFromPicture Format Support", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 10)
		    pdf.Cell(0, 6, "Issue: PNG format fails on Windows 11, JPEG works", 0, 1, "L")
		    pdf.Cell(0, 6, "Expected: Both images should be visible and identical", 0, 1, "L")
		    pdf.Ln(4)

		    // Create a test Picture with drawn graphics
		    Dim testPic As New Picture(100, 100)
		    Dim g As Graphics = testPic.Graphics

		    // Draw test pattern
		    g.DrawingColor = Color.RGB(255, 200, 200)
		    g.FillRectangle(0, 0, 100, 100)
		    g.DrawingColor = Color.RGB(255, 0, 0)
		    g.PenSize = 3
		    g.DrawRectangle(5, 5, 90, 90)
		    g.DrawLine(10, 10, 90, 90)
		    g.DrawLine(90, 10, 10, 90)
		    g.DrawingColor = Color.RGB(0, 0, 255)
		    g.FillOval(30, 30, 40, 40)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "4a. Current platform default (PNG on Desktop/Linux, JPEG on iOS/Web):", 0, 1, "L")

		    Try
		      pdf.ImageFromPicture(testPic, pdf.GetX(), pdf.GetY(), 40, 40, "testDefault")
		      pdf.Ln(45)
		      pdf.SetTextColor(0, 128, 0)
		      pdf.Cell(0, 6, "SUCCESS: ImageFromPicture worked with platform default", 0, 1, "L")
		    Catch e As RuntimeException
		      pdf.Ln(10)
		      pdf.SetTextColor(255, 0, 0)
		      pdf.Cell(0, 6, "FAILED: ImageFromPicture error - " + e.Message, 0, 1, "L")
		    End Try
		    pdf.SetTextColor(0, 0, 0)

		    pdf.Ln(4)

		    // Platform info
		    pdf.SetFont("Helvetica", "I", 9)
		    pdf.SetTextColor(128, 128, 128)
		    #If TargetWindows Then
		      pdf.Cell(0, 5, "Windows: Should use JPEG (PNG reported broken on Win11)", 0, 1, "L")
		    #ElseIf TargetiOS Or TargetWeb Then
		      pdf.Cell(0, 5, "iOS/Web: Uses JPEG (RGBA issue workaround)", 0, 1, "L")
		    #Else
		      pdf.Cell(0, 5, "Desktop/Linux: Uses PNG (lossless)", 0, 1, "L")
		    #EndIf
		    pdf.SetTextColor(0, 0, 0)

		    pdf.Ln(10)

		    // ========== TEST 5: MultiCell Positioning Bug ==========
		    pdf.AddPage()

		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 8, "Test 5: MultiCell Positioning After Call", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 10)
		    pdf.Cell(0, 6, "Issue: Cell(ln=1) moves to left margin of NEXT line instead of below current cell", 0, 1, "L")
		    pdf.Cell(0, 6, "Expected: Next text should appear directly below MultiCell, not offset", 0, 1, "L")
		    pdf.Ln(4)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "5a. MultiCell followed by regular Cell:", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 10)

		    // Draw vertical line to show alignment
		    Dim startX As Double = pdf.GetX()
		    Dim startY As Double = pdf.GetY()
		    pdf.SetDrawColor(200, 200, 200)
		    pdf.Line(startX, startY, startX, startY + 60)
		    pdf.SetDrawColor(0, 0, 0)

		    pdf.SetFillColor(240, 240, 255)
		    pdf.MultiCell(100, 6, "MultiCell text here" + Chr(10) + "Second line", 1, "L", True)

		    // This should be directly below, aligned with left edge of MultiCell
		    pdf.SetFillColor(255, 240, 240)
		    pdf.Cell(100, 6, "Cell after MultiCell (should align)", 1, 1, "L", True)

		    pdf.Ln(4)
		    pdf.SetFont("Helvetica", "I", 9)
		    pdf.SetTextColor(128, 128, 128)
		    pdf.Cell(0, 5, "Gray vertical line shows expected left alignment", 0, 1, "L")
		    pdf.Cell(0, 5, "If second box is offset right, bug exists on this platform", 0, 1, "L")
		    pdf.SetTextColor(0, 0, 0)

		    pdf.Ln(10)

		    // ========== Summary Page ==========
		    pdf.AddPage()

		    pdf.SetFont("Helvetica", "B", 16)
		    pdf.Cell(0, 10, "Test Results Summary", 0, 1, "C")
		    pdf.Ln(8)

		    pdf.SetFont("Helvetica", "", 10)
		    pdf.Cell(0, 6, "Visual Inspection Required:", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 9)
		    pdf.Cell(10, 5, "", 0, 0, "L")
		    pdf.Cell(0, 5, "1. Check Test 1: All single-line MultiCells should have complete borders (especially bottom)", 0, 1, "L")

		    pdf.Cell(10, 5, "", 0, 0, "L")
		    pdf.Cell(0, 5, "2. Check Test 2: Newline characters should create actual line breaks", 0, 1, "L")

		    pdf.Cell(10, 5, "", 0, 0, "L")
		    pdf.Cell(0, 5, "3. Check Test 3: Long words should start with X, A, Z (not missing first char)", 0, 1, "L")

		    pdf.Cell(10, 5, "", 0, 0, "L")
		    pdf.Cell(0, 5, "4. Check Test 4: Image should be visible (red square, blue circle)", 0, 1, "L")

		    pdf.Cell(10, 5, "", 0, 0, "L")
		    pdf.Cell(0, 5, "5. Check Test 5: Second cell should align with MultiCell left edge", 0, 1, "L")

		    pdf.Ln(10)

		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "Platform Information:", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 9)

		    #If TargetWindows Then
		      pdf.Cell(0, 5, "Platform: Windows (original bug reports)", 0, 1, "L")
		    #ElseIf TargetMacOS Then
		      pdf.Cell(0, 5, "Platform: macOS (testing cross-platform)", 0, 1, "L")
		    #ElseIf TargetLinux Then
		      pdf.Cell(0, 5, "Platform: Linux (testing cross-platform)", 0, 1, "L")
		    #Else
		      pdf.Cell(0, 5, "Platform: Other/Unknown", 0, 1, "L")
		    #EndIf

		    pdf.Cell(0, 5, "Xojo Version: 2025r3.1 API2", 0, 1, "L")
		    pdf.Cell(0, 5, "Report Source: Geoff Bridges (Windows 11 user)", 0, 1, "L")

		    // ========== Section: Geoff v1.3 Fixes ==========
		    pdf.AddPage()
		    pdf.SetFont("Helvetica", "B", 14)
		    pdf.Cell(0, 10, "Geoff v1.3 Fixes", 0, 1, "L")
		    pdf.Ln(2)

		    // --- Test: Cell Vertical Alignment ---
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "Test: Cell Vertical Alignment (vAlign parameter)", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 9)
		    pdf.Cell(0, 5, "Four cells with 20mm height, same text, different vertical alignment:", 0, 1, "L")
		    pdf.Ln(2)

		    Dim cellW As Double = 45
		    Dim cellH As Double = 20
		    pdf.SetFont("Helvetica", "", 8)

		    // Top aligned
		    pdf.Cell(cellW, cellH, "Top aligned", 1, 0, "L", False, "", VNSPDFModule.eVerticalAlignment.Top)
		    // Middle aligned (default)
		    pdf.Cell(cellW, cellH, "Middle aligned", 1, 0, "L", False, "", VNSPDFModule.eVerticalAlignment.Middle)
		    // Bottom aligned
		    pdf.Cell(cellW, cellH, "Bottom aligned", 1, 0, "L", False, "", VNSPDFModule.eVerticalAlignment.Bottom)
		    // Baseline aligned
		    pdf.Cell(cellW, cellH, "Baseline aligned", 1, 0, "L", False, "", VNSPDFModule.eVerticalAlignment.Baseline)
		    pdf.Ln(cellH + 2)

		    pdf.SetFont("Helvetica", "", 8)
		    pdf.Cell(0, 4, "Expected: text at top/middle/bottom/baseline of each cell", 0, 1, "L")
		    pdf.Ln(4)

		    // --- Test: Empty Cell with Borders ---
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "Test: Empty MultiCell with Borders", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 9)
		    pdf.Cell(0, 5, "Empty MultiCell with border=1 should draw borders (was missing before fix):", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.MultiCell(80, 10, "", 1, "L")
		    pdf.SetFont("Helvetica", "", 8)
		    pdf.Cell(0, 4, "Expected: empty rectangle with border above", 0, 1, "L")
		    pdf.Ln(4)

		    // --- Test: Write with Linebreaks ---
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "Test: Write() with Linebreak Characters", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 9)
		    pdf.Cell(0, 5, "Write() should respect Chr(10) newline characters:", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 10)
		    pdf.Write(5, "Line one" + Chr(10) + "Line two" + Chr(10) + "Line three")
		    pdf.Ln(8)

		    pdf.SetFont("Helvetica", "", 8)
		    pdf.Cell(0, 4, "Expected: three separate lines above", 0, 1, "L")
		    pdf.Ln(4)

		    // --- Test: Border.IsNumeric ---
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "Test: Border Variant Type Handling", 0, 1, "L")
		    pdf.SetFont("Helvetica", "", 9)
		    pdf.Cell(0, 5, "Cell with border=1 (Integer), border=""1"" (String), border=""LR"" (String):", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 10)
		    pdf.Cell(60, 8, "border=1 (Integer)", 1, 0, "L")
		    pdf.Cell(60, 8, "border=""1"" (String)", "1", 0, "L")
		    pdf.Cell(60, 8, "border=""LR"" (sides)", "LR", 1, "L")
		    pdf.Ln(2)
		    pdf.SetFont("Helvetica", "", 8)
		    pdf.Cell(0, 4, "Expected: all three cells have visible borders", 0, 1, "L")
		    pdf.Ln(4)

		    // --- Test: Vertical Alignment with different content ---
		    pdf.SetFont("Helvetica", "B", 10)
		    pdf.Cell(0, 6, "Test: Mixed Vertical Alignment in Row", 0, 1, "L")
		    pdf.Ln(2)

		    pdf.SetFont("Helvetica", "", 10)
		    cellH = 15
		    pdf.Cell(45, cellH, "Header (Top)", 1, 0, "C", True, "", VNSPDFModule.eVerticalAlignment.Top)
		    pdf.Cell(45, cellH, "Value (Middle)", 1, 0, "C", False, "", VNSPDFModule.eVerticalAlignment.Middle)
		    pdf.Cell(45, cellH, "Footer (Bottom)", 1, 0, "C", False, "", VNSPDFModule.eVerticalAlignment.Bottom)
		    pdf.Cell(45, cellH, "Base (Baseline)", 1, 0, "C", False, "", VNSPDFModule.eVerticalAlignment.Baseline)
		    pdf.Ln(cellH + 2)

		    // Generate output
		    If Not pdf.Ok() Then
		      statusText = statusText + "ERROR: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		      result.Value("message") = statusText
		      Return result
		    End If

		    // Get PDF data
		    Dim pdfData As String = pdf.ToData()

		    If Not pdf.Ok() Then
		      statusText = statusText + "ERROR generating PDF: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		    Else
		      statusText = statusText + "SUCCESS: PDF generated" + EndOfLine
		      statusText = statusText + EndOfLine
		      statusText = statusText + "VISUAL INSPECTION REQUIRED:" + EndOfLine
		      statusText = statusText + "  1. Single-line MultiCell borders (especially bottom)" + EndOfLine
		      statusText = statusText + "  2. Newline character preservation" + EndOfLine
		      statusText = statusText + "  3. First character of long words (X, A, Z)" + EndOfLine
		      statusText = statusText + "  4. Image visibility" + EndOfLine
		      statusText = statusText + "  5. MultiCell positioning alignment" + EndOfLine
		      statusText = statusText + "  6. Cell vertical alignment (Top/Middle/Bottom/Baseline)" + EndOfLine
		      statusText = statusText + "  7. Empty MultiCell with borders" + EndOfLine
		      statusText = statusText + "  8. Write() linebreak characters" + EndOfLine
		      statusText = statusText + "  9. Border variant type handling" + EndOfLine
		      result.Value("success") = True
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example26_bug_tests.pdf"
		    End If

		  Catch e As RuntimeException
		    statusText = statusText + "EXCEPTION: " + e.Message + EndOfLine
		    result.Value("success") = False
		  End Try

		  result.Value("message") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652032373A2048544D4C20496D706F72742E2054616B65732048544D4C20636F6E74656E7420737472696E6720616E6420636F6E766572747320746F20504446207573696E67204C6F616448544D4C28292E2052657475726E732044696374696F6E6172792077697468207374617475732C2070646620646174612C20616E642066696C656E616D652E
		Function GenerateExample27_HTMLImport(htmlContent As String, imageFolder As FolderItem = Nil) As Dictionary
		  // Example 27: HTML Import - Convert HTML content to PDF
		  // Demonstrates LoadHTML() from the premium HTML/Markdown Import module

		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 27: HTML Import..." + EndOfLine

		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		    pdf.Title = "Example 27 - HTML Import"
		    pdf.Author = "VNS PDF Library"
		    pdf.Subject = "Converting HTML to PDF"

		    // Load UTF-8 font for full Unicode/emoji support
		    #If Not TargetiOS And Not TargetAndroid Then
		      Dim fontPath27 As String = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
		      Dim fontFile27 As New FolderItem(fontPath27, FolderItem.PathModes.Native)
		      If fontFile27.Exists Then
		        pdf.AddUTF8Font("ArialUnicode", "", fontPath27)
		        pdf.SetFont("ArialUnicode", "", 11)
		      Else
		        pdf.SetFont("Helvetica", "", 11)
		      End If
		    #Else
		      Try
		        Dim fontRes27 As FolderItem = SpecialFolder.Resource("Arial Unicode.ttf")
		        If fontRes27 = Nil Then fontRes27 = SpecialFolder.Resource("ArialUnicode.ttf")
		        If fontRes27 <> Nil And fontRes27.Exists Then
		          Dim bs27 As BinaryStream = BinaryStream.Open(fontRes27)
		          Dim fd27 As String = bs27.Read(bs27.Length)
		          bs27.Close()
		          Dim mb27 As New MemoryBlock(fd27.Bytes)
		          mb27.StringValue(0, fd27.Bytes) = fd27
		          pdf.AddUTF8FontFromBytes("ArialUnicode", "", mb27)
		          pdf.SetFont("ArialUnicode", "", 11)
		        Else
		          pdf.SetFont("Helvetica", "", 11)
		        End If
		      Catch e As RuntimeException
		        pdf.SetFont("Helvetica", "", 11)
		      End Try
		    #EndIf

		    // Register custom HTML tag handlers (demonstrates the custom tag handler system)
		    pdf.RegisterHTMLTagHandler("company-header", AddressOf HandleCompanyHeader)
		    pdf.RegisterHTMLTagHandler("alert-box", AddressOf HandleAlertBox)
		    pdf.RegisterHTMLTagHandler("page-break", AddressOf HandlePageBreak)
		    pdf.RegisterHTMLTagHandler("highlight", AddressOf HandleHighlight)
		    pdf.RegisterHTMLTagHandler("signature-line", AddressOf HandleSignatureLine)

		    // Call LoadHTML with the provided content and optional image folder
		    pdf.LoadHTML(htmlContent, 0, imageFolder)

		    If pdf.Ok Then
		      // Generate PDF output
		      Dim pdfData As String = pdf.Output()

		      If pdf.Ok Then
		        statusText = statusText + "Example 27 completed successfully!" + EndOfLine
		        statusText = statusText + "PDF generated (" + Str(pdfData.Bytes) + " bytes)" + EndOfLine
		        result.Value("success") = True
		        result.Value("passed") = True
		        result.Value("pdf") = pdfData
		        result.Value("filename") = "example27_html_import.pdf"
		      Else
		        statusText = statusText + "Error generating PDF: " + pdf.GetError() + EndOfLine
		        result.Value("success") = False
		        result.Value("passed") = False
		      End If
		    Else
		      statusText = statusText + "LoadHTML error: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		      result.Value("passed") = False
		    End If

		  Catch ex As RuntimeException
		    statusText = statusText + "Exception: " + ex.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("passed") = False
		  End Try

		  result.Value("message") = statusText
		  result.Value("output") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652032383A204D61726B646F776E20496D706F72742E2054616B6573204D61726B646F776E20636F6E74656E7420737472696E6720616E6420636F6E766572747320746F20504446207573696E67204C6F61644D61726B646F776E28292E2052657475726E732044696374696F6E6172792077697468207374617475732C2070646620646174612C20616E642066696C656E616D652E
		Function GenerateExample28_MarkdownImport(mdContent As String) As Dictionary
		  // Example 28: Markdown Import - Convert Markdown content to PDF
		  // Demonstrates LoadMarkdown() from the premium HTML/Markdown Import module

		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 28: Markdown Import..." + EndOfLine

		  Try
		    // Create PDF document
		    Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		    pdf.Title = "Example 28 - Markdown Import"
		    pdf.Author = "VNS PDF Library"
		    pdf.Subject = "Converting Markdown to PDF"

		    // Load UTF-8 font for full Unicode/emoji support
		    #If Not TargetiOS And Not TargetAndroid Then
		      Dim fontPath28 As String = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
		      Dim fontFile28 As New FolderItem(fontPath28, FolderItem.PathModes.Native)
		      If fontFile28.Exists Then
		        pdf.AddUTF8Font("ArialUnicode", "", fontPath28)
		        pdf.SetFont("ArialUnicode", "", 11)
		      Else
		        pdf.SetFont("Helvetica", "", 11)
		      End If
		    #Else
		      Try
		        Dim fontRes28 As FolderItem = SpecialFolder.Resource("Arial Unicode.ttf")
		        If fontRes28 = Nil Then fontRes28 = SpecialFolder.Resource("ArialUnicode.ttf")
		        If fontRes28 <> Nil And fontRes28.Exists Then
		          Dim bs28 As BinaryStream = BinaryStream.Open(fontRes28)
		          Dim fd28 As String = bs28.Read(bs28.Length)
		          bs28.Close()
		          Dim mb28 As New MemoryBlock(fd28.Bytes)
		          mb28.StringValue(0, fd28.Bytes) = fd28
		          pdf.AddUTF8FontFromBytes("ArialUnicode", "", mb28)
		          pdf.SetFont("ArialUnicode", "", 11)
		        Else
		          pdf.SetFont("Helvetica", "", 11)
		        End If
		      Catch e As RuntimeException
		        pdf.SetFont("Helvetica", "", 11)
		      End Try
		    #EndIf

		    // Register custom Markdown line handlers (demonstrates the custom handler system)
		    pdf.RegisterMarkdownHandler(":::warning", AddressOf HandleMdWarning)
		    pdf.RegisterMarkdownHandler(":::info", AddressOf HandleMdInfo)
		    pdf.RegisterMarkdownHandler(":::error", AddressOf HandleMdError)
		    pdf.RegisterMarkdownHandler("{{var:", AddressOf HandleMdVariable)
		    pdf.RegisterMarkdownHandler("@@page-break", AddressOf HandleMdPageBreak)
		    pdf.RegisterMarkdownHandler("===", AddressOf HandleMdHRule)

		    // Call LoadMarkdown with the provided content
		    pdf.LoadMarkdown(mdContent)

		    If pdf.Ok Then
		      // Generate PDF output
		      Dim pdfData As String = pdf.Output()

		      If pdf.Ok Then
		        statusText = statusText + "Example 28 completed successfully!" + EndOfLine
		        statusText = statusText + "PDF generated (" + Str(pdfData.Bytes) + " bytes)" + EndOfLine
		        result.Value("success") = True
		        result.Value("passed") = True
		        result.Value("pdf") = pdfData
		        result.Value("filename") = "example28_markdown_import.pdf"
		      Else
		        statusText = statusText + "Error generating PDF: " + pdf.GetError() + EndOfLine
		        result.Value("success") = False
		        result.Value("passed") = False
		      End If
		    Else
		      statusText = statusText + "LoadMarkdown error: " + pdf.GetError() + EndOfLine
		      result.Value("success") = False
		      result.Value("passed") = False
		    End If

		  Catch ex As RuntimeException
		    statusText = statusText + "Exception: " + ex.Message + EndOfLine
		    result.Value("success") = False
		    result.Value("passed") = False
		  End Try

		  result.Value("message") = statusText
		  result.Value("output") = statusText
		  Return result
		End Function
	#tag EndMethod


	#tag Method, Flags = &h0, Description = 4578616D706C652032393A204772617068696373506174682046656174757265732E2044656D6F6E7374726174657320616C6C206E657720564E53504446477261706869637350617468206361706162696C697469657320696E636C7564696E67206375727665732C20617263732C2072656374616E676C65732C20726F756E642072656374616E676C65732C20636C697070696E672C20616E64206869742074657374696E672E
		Function GenerateExample29() As Dictionary
		  // Example 29: GraphicsPath Features
		  // Demonstrates all new VNSPDFGraphicsPath capabilities

		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 29: GraphicsPath Features..." + EndOfLine

		  Try
		    Dim pdf As New VNSPDFDocument()
		    pdf.Title = "Example 29 - GraphicsPath Features"
		    pdf.Author = "VNS PDF Examples"

		    Dim g As VNSPDFGraphics = pdf.Graphics

		    // ========== PAGE 1: Basic Path Shapes ==========
		    g.FontName = "Helvetica"
		    g.FontSize = 16
		    g.Bold = True
		    g.DrawingColor = &c000066
		    g.DrawText("Page 1: Basic Path Shapes", 72, 50)

		    g.FontSize = 10
		    g.Bold = False
		    g.DrawingColor = &c333333
		    g.DrawText("Demonstrates AddRectangle, AddRoundRectangle, CloseSubpath, and basic path operations", 72, 70)

		    // --- Rectangle via AddRectangle (drawn) ---
		    g.DrawingColor = &c0000CC
		    g.PenSize = 2
		    Dim rectPath As New VNSPDFGraphicsPath
		    rectPath.AddRectangle(72, 100, 150, 80)
		    g.DrawPath(rectPath)

		    g.FontSize = 9
		    g.DrawingColor = &c000000
		    g.DrawText("AddRectangle (stroked)", 72, 195)

		    // --- Rectangle via AddRectangle (filled) ---
		    g.DrawingColor = &cCCDDFF
		    Dim rectFillPath As New VNSPDFGraphicsPath
		    rectFillPath.AddRectangle(260, 100, 150, 80)
		    g.FillPath(rectFillPath)

		    g.DrawingColor = &c000000
		    g.DrawText("AddRectangle (filled)", 260, 195)

		    // --- Rectangle from Rect object ---
		    g.DrawingColor = &c009900
		    g.PenSize = 1.5
		    Dim rectObj As New Rect(450, 100, 100, 80)
		    Dim rectObjPath As New VNSPDFGraphicsPath
		    rectObjPath.AddRectangle(rectObj)
		    g.DrawPath(rectObjPath)

		    g.DrawingColor = &c000000
		    g.DrawText("AddRectangle(Rect)", 450, 195)

		    // --- Triangle via MoveToPoint/AddLineToPoint + CloseSubpath ---
		    g.DrawingColor = &cCC0000
		    g.PenSize = 2
		    Dim triPath As New VNSPDFGraphicsPath
		    triPath.MoveToPoint(147, 230)
		    triPath.AddLineToPoint(72, 340)
		    triPath.AddLineToPoint(222, 340)
		    triPath.CloseSubpath()
		    g.DrawPath(triPath)

		    g.DrawingColor = &c000000
		    g.DrawText("Triangle (CloseSubpath)", 72, 355)

		    // --- Filled pentagon ---
		    g.DrawingColor = &cFF9900
		    Dim pentPath As New VNSPDFGraphicsPath
		    Const kPi As Double = 3.14159265358979
		    Dim cx As Double = 350
		    Dim cy As Double = 285
		    Dim r As Double = 55
		    For i As Integer = 0 To 4
		      Dim angle As Double = -kPi / 2 + i * 2 * kPi / 5
		      Dim px As Double = cx + r * Cos(angle)
		      Dim py As Double = cy + r * Sin(angle)
		      If i = 0 Then
		        pentPath.MoveToPoint(px, py)
		      Else
		        pentPath.AddLineToPoint(px, py)
		      End If
		    Next
		    pentPath.CloseSubpath()
		    g.FillPath(pentPath)

		    g.DrawingColor = &c000000
		    g.DrawText("Filled Pentagon", 310, 355)

		    // --- Round Rectangle (drawn) ---
		    g.DrawingColor = &c6600CC
		    g.PenSize = 2
		    Dim rrPath As New VNSPDFGraphicsPath
		    rrPath.AddRoundRectangle(72, 380, 180, 90, 15, 15)
		    g.DrawPath(rrPath)

		    g.DrawingColor = &c000000
		    g.DrawText("AddRoundRectangle (stroked)", 72, 485)

		    // --- Round Rectangle (filled) ---
		    g.DrawingColor = &cDDCCFF
		    Dim rrFillPath As New VNSPDFGraphicsPath
		    rrFillPath.AddRoundRectangle(290, 380, 180, 90, 20, 20)
		    g.FillPath(rrFillPath)

		    g.DrawingColor = &c000000
		    g.DrawText("AddRoundRectangle (filled)", 290, 485)

		    // --- IsEmpty / IsRectangle info ---
		    g.FontSize = 9
		    g.DrawingColor = &c666666
		    Dim emptyPath As New VNSPDFGraphicsPath
		    g.DrawText("IsEmpty (new path): " + Str(emptyPath.IsEmpty), 72, 520)
		    g.DrawText("IsRectangle (rectPath): " + Str(rectPath.IsRectangle), 72, 535)
		    g.DrawText("IsRectangle (triPath): " + Str(triPath.IsRectangle), 72, 550)

		    // Bounds info
		    Dim triBounds As Rect = triPath.Bounds
		    g.DrawText("Triangle Bounds: x=" + Str(triBounds.Left) + " y=" + Str(triBounds.Top) + " w=" + Str(triBounds.Width) + " h=" + Str(triBounds.Height), 72, 565)

		    statusText = statusText + "Page 1: Basic Path Shapes completed." + EndOfLine

		    // ========== PAGE 2: Curves ==========
		    g.NextPage()

		    g.FontName = "Helvetica"
		    g.FontSize = 16
		    g.Bold = True
		    g.DrawingColor = &c000066
		    g.DrawText("Page 2: Curves", 72, 50)

		    g.FontSize = 10
		    g.Bold = False
		    g.DrawingColor = &c333333
		    g.DrawText("Demonstrates AddCurveToPoint (cubic) and AddQuadraticCurveToPoint", 72, 70)

		    // --- Cubic Bezier curve ---
		    g.DrawingColor = &c0000FF
		    g.PenSize = 2.5
		    Dim cubicPath As New VNSPDFGraphicsPath
		    cubicPath.MoveToPoint(72, 150)
		    cubicPath.AddCurveToPoint(72, 80, 272, 80, 272, 150)
		    g.DrawPath(cubicPath)

		    // Draw control points as dots
		    g.DrawingColor = &cFF0000
		    g.PenSize = 1
		    g.FillOval(72 - 3, 80 - 3, 6, 6)
		    g.FillOval(272 - 3, 80 - 3, 6, 6)

		    // Dashed lines to control points
		    g.DrawingColor = &cCCCCCC
		    g.DrawLine(72, 150, 72, 80)
		    g.DrawLine(272, 150, 272, 80)

		    g.DrawingColor = &c000000
		    g.FontSize = 9
		    g.DrawText("Cubic Bezier (AddCurveToPoint) - red dots = control points", 72, 170)

		    // --- Quadratic Bezier curve ---
		    g.DrawingColor = &c009900
		    g.PenSize = 2.5
		    Dim quadPath As New VNSPDFGraphicsPath
		    quadPath.MoveToPoint(72, 280)
		    quadPath.AddQuadraticCurveToPoint(200, 190, 350, 280)
		    g.DrawPath(quadPath)

		    // Draw control point
		    g.DrawingColor = &cFF0000
		    g.PenSize = 1
		    g.FillOval(200 - 3, 190 - 3, 6, 6)

		    // Dashed lines to control point
		    g.DrawingColor = &cCCCCCC
		    g.DrawLine(72, 280, 200, 190)
		    g.DrawLine(350, 280, 200, 190)

		    g.DrawingColor = &c000000
		    g.DrawText("Quadratic Bezier (AddQuadraticCurveToPoint) - red dot = control point", 72, 300)

		    // --- S-curve: two cubic Beziers combined ---
		    g.DrawingColor = &cCC6600
		    g.PenSize = 3
		    Dim sCurvePath As New VNSPDFGraphicsPath
		    sCurvePath.MoveToPoint(72, 400)
		    sCurvePath.AddCurveToPoint(150, 340, 200, 340, 250, 400)
		    sCurvePath.AddCurveToPoint(300, 460, 350, 460, 430, 400)
		    g.DrawPath(sCurvePath)

		    g.DrawingColor = &c000000
		    g.DrawText("S-curve (two cubic Beziers combined)", 72, 480)

		    // --- Filled cubic Bezier shape ---
		    g.DrawingColor = &cFFDDDD
		    Dim filledCurve As New VNSPDFGraphicsPath
		    filledCurve.MoveToPoint(72, 580)
		    filledCurve.AddCurveToPoint(120, 500, 250, 500, 300, 580)
		    filledCurve.CloseSubpath()
		    g.FillPath(filledCurve)

		    g.DrawingColor = &cCC0000
		    g.PenSize = 1
		    g.DrawPath(filledCurve)

		    g.DrawingColor = &c000000
		    g.DrawText("Filled cubic Bezier shape (with CloseSubpath)", 72, 600)

		    statusText = statusText + "Page 2: Curves completed." + EndOfLine

		    // ========== PAGE 3: Arcs ==========
		    g.NextPage()

		    g.FontName = "Helvetica"
		    g.FontSize = 16
		    g.Bold = True
		    g.DrawingColor = &c000066
		    g.DrawText("Page 3: Arcs", 72, 50)

		    g.FontSize = 10
		    g.Bold = False
		    g.DrawingColor = &c333333
		    g.DrawText("Demonstrates AddArc with various angles and directions", 72, 70)

		    Const kTwoPi As Double = 6.28318530717959
		    Const kHalfPi As Double = 1.5707963267949

		    // --- Full circle arc ---
		    g.DrawingColor = &c0000CC
		    g.PenSize = 2
		    Dim fullCircle As New VNSPDFGraphicsPath
		    fullCircle.AddArc(150, 180, 50, 0, kTwoPi)
		    g.DrawPath(fullCircle)

		    g.DrawingColor = &c000000
		    g.FontSize = 9
		    g.DrawText("Full circle (0 to 2Pi)", 100, 245)

		    // --- Half circle arc ---
		    g.DrawingColor = &c009900
		    g.PenSize = 2
		    Dim halfCircle As New VNSPDFGraphicsPath
		    halfCircle.AddArc(350, 180, 50, 0, kPi)
		    g.DrawPath(halfCircle)

		    g.DrawingColor = &c000000
		    g.DrawText("Half circle (0 to Pi)", 300, 245)

		    // --- Quarter arc ---
		    g.DrawingColor = &cCC6600
		    g.PenSize = 3
		    Dim quarterArc As New VNSPDFGraphicsPath
		    quarterArc.AddArc(150, 350, 50, 0, kHalfPi)
		    g.DrawPath(quarterArc)

		    g.DrawingColor = &c000000
		    g.DrawText("Quarter arc (0 to Pi/2)", 100, 420)

		    // --- Counterclockwise arc ---
		    g.DrawingColor = &c990099
		    g.PenSize = 2
		    Dim ccwArc As New VNSPDFGraphicsPath
		    ccwArc.AddArc(350, 350, 50, 0, kPi, True)
		    g.DrawPath(ccwArc)

		    g.DrawingColor = &c000000
		    g.DrawText("Counterclockwise arc", 300, 420)

		    // --- Pac-Man shape (arc with lines to center) ---
		    g.DrawingColor = &cFFCC00
		    Dim pacman As New VNSPDFGraphicsPath
		    Dim pacCenterX As Double = 250
		    Dim pacCenterY As Double = 530
		    Dim pacRadius As Double = 50
		    Dim mouthAngle As Double = kPi / 6 // 30 degrees

		    pacman.MoveToPoint(pacCenterX, pacCenterY)
		    pacman.AddLineToPoint(pacCenterX + pacRadius * Cos(mouthAngle), pacCenterY + pacRadius * Sin(mouthAngle))
		    pacman.AddArc(pacCenterX, pacCenterY, pacRadius, mouthAngle, kTwoPi - mouthAngle)
		    pacman.CloseSubpath()
		    g.FillPath(pacman)

		    // Eye
		    g.DrawingColor = &c000000
		    g.FillOval(pacCenterX + 10, pacCenterY - 25, 8, 8)

		    g.DrawText("Pac-Man shape (arc + lines)", 200, 600)

		    statusText = statusText + "Page 3: Arcs completed." + EndOfLine

		    // ========== PAGE 4: Round Rectangles Gallery ==========
		    g.NextPage()

		    g.FontName = "Helvetica"
		    g.FontSize = 16
		    g.Bold = True
		    g.DrawingColor = &c000066
		    g.DrawText("Page 4: Round Rectangles Gallery", 72, 50)

		    g.FontSize = 10
		    g.Bold = False
		    g.DrawingColor = &c333333
		    g.DrawText("Various corner radii, asymmetric corners, filled vs outlined", 72, 70)

		    // Small corner radius
		    g.DrawingColor = &c0000CC
		    g.PenSize = 1.5
		    Dim rr1 As New VNSPDFGraphicsPath
		    rr1.AddRoundRectangle(72, 100, 140, 80, 5, 5)
		    g.DrawPath(rr1)
		    g.DrawingColor = &c000000
		    g.FontSize = 9
		    g.DrawText("cornerW=5, cornerH=5", 72, 195)

		    // Medium corner radius
		    g.DrawingColor = &c009900
		    Dim rr2 As New VNSPDFGraphicsPath
		    rr2.AddRoundRectangle(240, 100, 140, 80, 15, 15)
		    g.DrawPath(rr2)
		    g.DrawingColor = &c000000
		    g.DrawText("cornerW=15, cornerH=15", 240, 195)

		    // Large corner radius (pill shape)
		    g.DrawingColor = &cCC0000
		    Dim rr3 As New VNSPDFGraphicsPath
		    rr3.AddRoundRectangle(410, 100, 140, 80, 40, 40)
		    g.DrawPath(rr3)
		    g.DrawingColor = &c000000
		    g.DrawText("cornerW=40, cornerH=40", 410, 195)

		    // Asymmetric corners (wide)
		    g.DrawingColor = &cDDEEFF
		    Dim rr4 As New VNSPDFGraphicsPath
		    rr4.AddRoundRectangle(72, 230, 140, 80, 30, 10)
		    g.FillPath(rr4)
		    g.DrawingColor = &c0066CC
		    g.DrawPath(rr4)
		    g.DrawingColor = &c000000
		    g.DrawText("cornerW=30, cornerH=10", 72, 325)

		    // Asymmetric corners (tall)
		    g.DrawingColor = &cFFEEDD
		    Dim rr5 As New VNSPDFGraphicsPath
		    rr5.AddRoundRectangle(240, 230, 140, 80, 10, 30)
		    g.FillPath(rr5)
		    g.DrawingColor = &cCC6600
		    g.DrawPath(rr5)
		    g.DrawingColor = &c000000
		    g.DrawText("cornerW=10, cornerH=30", 240, 325)

		    // Full stadium shape
		    g.DrawingColor = &cDDFFDD
		    Dim rr6 As New VNSPDFGraphicsPath
		    rr6.AddRoundRectangle(410, 230, 140, 80, 70, 40)
		    g.FillPath(rr6)
		    g.DrawingColor = &c006600
		    g.DrawPath(rr6)
		    g.DrawingColor = &c000000
		    g.DrawText("Stadium (clamped)", 410, 325)

		    // Filled with different colors
		    Dim colors() As Color
		    colors.Add(&cFF6666)
		    colors.Add(&c66FF66)
		    colors.Add(&c6666FF)
		    colors.Add(&cFFFF66)

		    Dim rrX As Double = 72
		    For ci As Integer = 0 To 3
		      g.DrawingColor = colors(ci)
		      Dim rrC As New VNSPDFGraphicsPath
		      rrC.AddRoundRectangle(rrX, 370, 110, 60, 12, 12)
		      g.FillPath(rrC)
		      rrX = rrX + 130
		    Next

		    g.DrawingColor = &c000000
		    g.DrawText("Filled round rectangles in various colors", 72, 445)

		    // Round rectangle from Rect object
		    g.DrawingColor = &c990099
		    g.PenSize = 2
		    Dim rrRect As New Rect(72, 480, 200, 60)
		    Dim rrFromRect As New VNSPDFGraphicsPath
		    rrFromRect.AddRoundRectangle(rrRect, 15, 15)
		    g.DrawPath(rrFromRect)

		    g.DrawingColor = &c000000
		    g.DrawText("AddRoundRectangle(Rect, 15, 15)", 72, 555)

		    statusText = statusText + "Page 4: Round Rectangles Gallery completed." + EndOfLine

		    // ========== PAGE 5: Complex Paths ==========
		    g.NextPage()

		    g.FontName = "Helvetica"
		    g.FontSize = 16
		    g.Bold = True
		    g.DrawingColor = &c000066
		    g.DrawText("Page 5: Complex Paths", 72, 50)

		    g.FontSize = 10
		    g.Bold = False
		    g.DrawingColor = &c333333
		    g.DrawText("Clipping, combined paths, Bounds visualization, and Contains hit testing", 72, 70)

		    // --- Star shape ---
		    g.DrawingColor = &cFF9900
		    Dim starPath As New VNSPDFGraphicsPath
		    Dim starCX As Double = 150
		    Dim starCY As Double = 180
		    Dim outerR As Double = 60
		    Dim innerR As Double = 25

		    For si As Integer = 0 To 9
		      Dim starAngle As Double = -kPi / 2 + si * kPi / 5
		      Dim starR As Double
		      If si Mod 2 = 0 Then
		        starR = outerR
		      Else
		        starR = innerR
		      End If
		      Dim sx As Double = starCX + starR * Cos(starAngle)
		      Dim sy As Double = starCY + starR * Sin(starAngle)
		      If si = 0 Then
		        starPath.MoveToPoint(sx, sy)
		      Else
		        starPath.AddLineToPoint(sx, sy)
		      End If
		    Next
		    starPath.CloseSubpath()
		    g.FillPath(starPath)

		    g.DrawingColor = &c000000
		    g.FontSize = 9
		    g.DrawText("Star shape (10-point polygon)", 90, 260)

		    // --- Bounds visualization ---
		    Dim starBounds As Rect = starPath.Bounds
		    g.DrawingColor = &cFF0000
		    g.PenSize = 0.5
		    g.DrawRectangle(starBounds.Left, starBounds.Top, starBounds.Width, starBounds.Height)

		    g.DrawingColor = &cCC0000
		    g.DrawText("Red rect = Bounds()", 90, 275)

		    // --- Clipping with round rect ---
		    g.DrawingColor = &c000000
		    g.FontSize = 10
		    g.DrawText("Clipping demo: text clipped to round rectangle", 300, 110)

		    Dim clipRR As New VNSPDFGraphicsPath
		    clipRR.AddRoundRectangle(300, 120, 220, 100, 20, 20)

		    // Draw clip outline first
		    g.DrawingColor = &cCCCCCC
		    g.PenSize = 1
		    g.DrawPath(clipRR)

		    // Clip and draw text inside
		    g.ClipToPath(clipRR)

		    g.FontSize = 12
		    g.DrawingColor = &c0000CC
		    Dim clipY As Double = 140
		    For li As Integer = 1 To 8
		      g.DrawText("Line " + Str(li) + ": This text is clipped to the rounded rectangle path boundary", 305, clipY)
		      clipY = clipY + 15
		    Next

		    g.ClipEnd()

		    // --- Contains() hit testing demo ---
		    g.DrawingColor = &c000000
		    g.FontSize = 10
		    g.DrawText("Contains() hit testing:", 72, 320)

		    // Draw a filled circle path
		    Dim hitCircle As New VNSPDFGraphicsPath
		    hitCircle.AddArc(200, 400, 50, 0, kTwoPi)

		    g.DrawingColor = &cDDDDFF
		    g.FillPath(hitCircle)
		    g.DrawingColor = &c0000CC
		    g.PenSize = 1
		    g.DrawPath(hitCircle)

		    // Test points
		    Dim testPoints() As Point
		    testPoints.Add(New Point(200, 400))  // Center - inside
		    testPoints.Add(New Point(200, 345))  // Top edge - inside
		    testPoints.Add(New Point(200, 340))  // Just above - outside
		    testPoints.Add(New Point(100, 400))  // Far left - outside

		    g.FontSize = 8
		    For ti As Integer = 0 To testPoints.LastIndex
		      Dim tp As Point = testPoints(ti)
		      Dim isInside As Boolean = hitCircle.Contains(tp)
		      If isInside Then
		        g.DrawingColor = &c00CC00
		        g.FillOval(tp.X - 4, tp.Y - 4, 8, 8)
		      Else
		        g.DrawingColor = &cCC0000
		        g.FillOval(tp.X - 4, tp.Y - 4, 8, 8)
		      End If
		      g.DrawingColor = &c000000
		      g.DrawText("(" + Str(tp.X) + "," + Str(tp.Y) + ") = " + Str(isInside), tp.X + 8, tp.Y + 4)
		    Next

		    g.DrawingColor = &c000000
		    g.FontSize = 9
		    g.DrawText("Green dots = inside, Red dots = outside (even-odd rule)", 72, 470)

		    // --- Combined path: curve + line ---
		    g.DrawingColor = &c990099
		    g.PenSize = 2
		    Dim combinedPath As New VNSPDFGraphicsPath
		    combinedPath.MoveToPoint(72, 550)
		    combinedPath.AddCurveToPoint(130, 490, 230, 490, 290, 550)
		    combinedPath.AddLineToPoint(290, 600)
		    combinedPath.AddCurveToPoint(230, 640, 130, 640, 72, 600)
		    combinedPath.CloseSubpath()
		    g.FillPath(combinedPath)

		    g.DrawingColor = &c660066
		    g.DrawPath(combinedPath)

		    g.DrawingColor = &c000000
		    g.FontSize = 9
		    g.DrawText("Combined path: curves + lines + CloseSubpath", 72, 660)

		    statusText = statusText + "Page 5: Complex Paths completed." + EndOfLine

		    // ========== PAGE 6: Backward Compatibility ==========
		    g.NextPage()

		    g.FontName = "Helvetica"
		    g.FontSize = 16
		    g.Bold = True
		    g.DrawingColor = &c000066
		    g.DrawText("Page 6: Backward Compatibility", 72, 50)

		    g.FontSize = 10
		    g.Bold = False
		    g.DrawingColor = &c333333
		    g.DrawText("Existing MoveToPoint/AddLineToPoint still works identically", 72, 70)

		    // --- Triangle (same as Example 22 style) ---
		    g.DrawingColor = &cCC0000
		    g.PenSize = 2
		    Dim oldTriPath As New VNSPDFGraphicsPath
		    oldTriPath.MoveToPoint(150, 120)
		    oldTriPath.AddLineToPoint(72, 250)
		    oldTriPath.AddLineToPoint(228, 250)
		    g.DrawPath(oldTriPath, True) // autoClose = true

		    g.DrawingColor = &c000000
		    g.FontSize = 9
		    g.DrawText("Triangle (autoClose=True)", 72, 270)

		    // --- Pentagon using old API (same code pattern as Example 22) ---
		    g.DrawingColor = &c0066FF
		    Dim oldPentPath As New VNSPDFGraphicsPath
		    Dim pcx As Double = 400
		    Dim pcy As Double = 185
		    Dim pr As Double = 65
		    For pi As Integer = 0 To 4
		      Dim pa As Double = -kPi / 2 + pi * 2 * kPi / 5
		      Dim ppx As Double = pcx + pr * Cos(pa)
		      Dim ppy As Double = pcy + pr * Sin(pa)
		      If pi = 0 Then
		        oldPentPath.MoveToPoint(ppx, ppy)
		      Else
		        oldPentPath.AddLineToPoint(ppx, ppy)
		      End If
		    Next
		    g.DrawPath(oldPentPath, True)

		    g.DrawingColor = &c000000
		    g.DrawText("Pentagon (old API, autoClose=True)", 340, 270)

		    // --- GetPoints() backward compat test ---
		    g.DrawingColor = &c000000
		    g.FontSize = 10
		    g.DrawText("GetPoints() backward compatibility:", 72, 310)

		    // Create a path with curves and verify GetPoints returns sampled points
		    Dim curvedPath As New VNSPDFGraphicsPath
		    curvedPath.MoveToPoint(100, 350)
		    curvedPath.AddCurveToPoint(150, 300, 250, 300, 300, 350)
		    curvedPath.AddLineToPoint(300, 400)
		    curvedPath.AddLineToPoint(100, 400)
		    curvedPath.CloseSubpath()

		    Dim flatPts() As Point = curvedPath.GetPoints()
		    g.FontSize = 9
		    g.DrawText("Path with cubic curve + 2 lines + close -> GetPoints returns " + Str(flatPts.Count) + " points", 72, 330)

		    // Draw the path using old polygon method (via GetPoints) to show it works
		    g.DrawingColor = &c00CC66
		    g.PenSize = 1.5
		    If flatPts.Count > 1 Then
		      For fi As Integer = 0 To flatPts.LastIndex - 1
		        g.DrawLine(flatPts(fi).X, flatPts(fi).Y, flatPts(fi + 1).X, flatPts(fi + 1).Y)
		      Next
		    End If

		    // Also draw using new ToPDFCommands for comparison
		    g.DrawingColor = &cCCCCCC
		    g.PenSize = 0.5
		    g.DrawPath(curvedPath)

		    g.DrawingColor = &c000000
		    g.DrawText("Green = GetPoints() polygon, Gray = native PDF curves", 72, 420)

		    // --- GetSegments() test ---
		    Dim segs() As VNSPDFPathSegment = curvedPath.GetSegments()
		    g.DrawText("GetSegments() returns " + Str(segs.Count) + " segments for same path", 72, 445)

		    // Handle() test
		    g.DrawText("Handle() returns Nil: " + Str(curvedPath.Handle = Nil), 72, 465)

		    statusText = statusText + "Page 6: Backward Compatibility completed." + EndOfLine

		    // Generate PDF
		    Dim pdfData As String = pdf.Output()

		    If pdf.Error <> "" Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("error") = pdf.Error
		    Else
		      statusText = statusText + "Success! PDF generated with 6 pages." + EndOfLine
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example29_graphicspath.pdf"
		    End If

		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try

		  result.Value("message") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4578616D706C652033303A20452D496E766F69636520284661637475722D582F5A55474665524429202D205072656D69756D
		Function GenerateExample30(countryCode As String) As Dictionary
		  #If hasPremiumVNSEInvoiceModule Then
		    // Example 30: E-Invoice (Factur-X/ZUGFeRD)
		    // Demonstrates creating a PDF/A-3b compliant invoice with embedded CII XML
		    // countryCode: 2-letter ISO country code of the seller (FR, DE, IT, ES, etc.)

		    Dim result As New Dictionary
		    Dim statusText As String = ""

		    statusText = statusText + "Example 30: E-Invoice (Factur-X/ZUGFeRD) - Country: " + countryCode + EndOfLine
		    statusText = statusText + "==========================================" + EndOfLine + EndOfLine

		    // --- Build invoice data model ---
		    statusText = statusText + "Step 1: Building invoice data model..." + EndOfLine

		    Dim invoice As New VNSPDFEInvoice
		    invoice.InvoiceNumber = "INV-2026-0042"
		    invoice.InvoiceDate = DateTime.Now
		    invoice.DueDate = DateTime.Now
		    invoice.DeliveryDate = DateTime.Now
		    invoice.Currency = "EUR"
		    invoice.InvoiceTypeCode = VNSPDFEInvoicePremium.eInvoiceTypeCode.Invoice.ToString
		    invoice.BuyerReference = "PO-2026-1234"
		    invoice.PaymentMeansCode = VNSPDFEInvoicePremium.ePaymentMeansCode.CreditTransfer.ToString
		    invoice.PaymentReference = "INV-2026-0042"
		    invoice.PurchaseOrderReference = "PO-2026-1234"
		    invoice.ContractReference = "CONTRACT-2025-100"
		    invoice.ProjectReference = "PROJ-2026-007"
		    invoice.PaymentTerms = "Net 30 days. 2% discount if paid within 10 days."
		    invoice.InvoicePeriodStart = New DateTime(2026, 3, 1)
		    invoice.InvoicePeriodEnd = New DateTime(2026, 3, 31)

		    // Seller and buyer data based on country
		    Dim seller As New VNSPDFEInvoiceParty
		    Dim buyer As New VNSPDFEInvoiceParty

		    Select Case countryCode
		    Case "FR"
		      // France: SIREN required, electronic address, French notes
		      invoice.IBAN = "FR7630006000011234567890189"
		      invoice.BIC = "BNPAFRPPXXX"

		      seller.Name = "VeryNiceSW SARL"
		      seller.VATNumber = "FR12345678901"
		      seller.LegalRegistrationID = "123456789"
		      seller.LegalRegistrationScheme = "0002"
		      seller.ElectronicAddress = "contact@verynicesw.com"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "42 Rue de la Paix"
		      seller.City = "Paris"
		      seller.PostalCode = "75002"
		      seller.CountryCode = "FR"
		      seller.ContactName = "Jean-Yves Pochez"
		      seller.ContactEmail = "contact@verynicesw.com"
		      seller.ContactPhone = "+33 1 42 00 00 00"

		      buyer.Name = "Acme GmbH"
		      buyer.VATNumber = "DE987654321"
		      buyer.ElectronicAddress = "hans@acme.de"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "10 Friedrichstrasse"
		      buyer.City = "Berlin"
		      buyer.PostalCode = "10117"
		      buyer.CountryCode = "DE"
		      buyer.ContactName = "Hans Mueller"
		      buyer.ContactEmail = "hans@acme.de"

		      // French-specific notes with subject codes
		      // BR-FR-05: AAB note (discount/early payment terms) is mandatory in France
		      invoice.AddNote("Pas d'escompte pour paiement anticipe.", "AAB")
		      invoice.AddNote("Late payment penalties: 3x the legal interest rate.", "PMD")
		      invoice.AddNote("Recovery costs for unpaid invoices: 40 EUR.", "PMT")

		    Case "DE"
		      // Germany: Leitweg-ID, XRechnung
		      invoice.IBAN = "DE89370400440532013000"
		      invoice.BIC = "COBADEFFXXX"

		      seller.Name = "Muster GmbH"
		      seller.VATNumber = "DE123456789"
		      seller.LegalRegistrationID = "HRB 12345"
		      seller.LegalRegistrationScheme = "0002"
		      seller.ElectronicAddress = "info@muster.de"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "15 Hauptstrasse"
		      seller.City = "Munich"
		      seller.PostalCode = "80331"
		      seller.CountryCode = "DE"
		      seller.ContactName = "Klaus Schmidt"
		      seller.ContactEmail = "info@muster.de"
		      seller.ContactPhone = "+49 89 1234567"

		      buyer.Name = "Buyer SA"
		      buyer.VATNumber = "FR98765432101"
		      buyer.ElectronicAddress = "buyer@example.fr"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "5 Avenue des Champs"
		      buyer.City = "Lyon"
		      buyer.PostalCode = "69001"
		      buyer.CountryCode = "FR"
		      buyer.ContactName = "Pierre Dupont"
		      buyer.ContactEmail = "buyer@example.fr"

		      invoice.AddNote("Thank you for your business!")

		    Case "IT"
		      // Italy: Codice Destinatario / PEC
		      invoice.IBAN = "IT60X0542811101000000123456"
		      invoice.BIC = "BLOPIT22XXX"

		      seller.Name = "Esempio SRL"
		      seller.VATNumber = "IT01234567890"
		      seller.LegalRegistrationID = "01234567890"
		      seller.LegalRegistrationScheme = "0210"
		      seller.ElectronicAddress = "ABCDEFG"
		      seller.ElectronicAddressScheme = "0201"
		      seller.AddressLine1 = "Via Roma 10"
		      seller.City = "Rome"
		      seller.PostalCode = "00100"
		      seller.CountryCode = "IT"
		      seller.ContactName = "Marco Rossi"
		      seller.ContactEmail = "info@esempio.it"
		      seller.ContactPhone = "+39 06 1234567"

		      buyer.Name = "Comprador SL"
		      buyer.VATNumber = "ESB12345678"
		      buyer.ElectronicAddress = "comprador@example.es"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "Calle Mayor 20"
		      buyer.City = "Madrid"
		      buyer.PostalCode = "28001"
		      buyer.CountryCode = "ES"
		      buyer.ContactName = "Carlos Garcia"
		      buyer.ContactEmail = "comprador@example.es"

		      invoice.AddNote("Thank you for your business!")

		    Case "ES"
		      // Spain
		      invoice.IBAN = "ES9121000418450200051332"
		      invoice.BIC = "CABORAESXXX"

		      seller.Name = "Vendedor SL"
		      seller.VATNumber = "ESA12345678"
		      seller.LegalRegistrationID = "A12345678"
		      seller.LegalRegistrationScheme = "0002"
		      seller.ElectronicAddress = "info@vendedor.es"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "Calle Gran Via 30"
		      seller.City = "Barcelona"
		      seller.PostalCode = "08001"
		      seller.CountryCode = "ES"
		      seller.ContactName = "Maria Lopez"
		      seller.ContactEmail = "info@vendedor.es"
		      seller.ContactPhone = "+34 93 1234567"

		      buyer.Name = "Koper BV"
		      buyer.VATNumber = "NL123456789B01"
		      buyer.ElectronicAddress = "koper@example.nl"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "Keizersgracht 100"
		      buyer.City = "Amsterdam"
		      buyer.PostalCode = "1015AA"
		      buyer.CountryCode = "NL"
		      buyer.ContactName = "Jan de Vries"
		      buyer.ContactEmail = "koper@example.nl"

		      invoice.AddNote("Thank you for your business!")

		    Case "BE"
		      // Belgium
		      invoice.IBAN = "BE68539007547034"
		      invoice.BIC = "BBRUBEBB"

		      seller.Name = "Verkoper NV"
		      seller.VATNumber = "BE0123456789"
		      seller.LegalRegistrationID = "0123456789"
		      seller.LegalRegistrationScheme = "0208"
		      seller.ElectronicAddress = "info@verkoper.be"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "Rue de la Loi 50"
		      seller.City = "Brussels"
		      seller.PostalCode = "1000"
		      seller.CountryCode = "BE"
		      seller.ContactName = "Luc Peeters"
		      seller.ContactEmail = "info@verkoper.be"
		      seller.ContactPhone = "+32 2 1234567"

		      buyer.Name = "Kaeufer AG"
		      buyer.VATNumber = "ATU12345678"
		      buyer.ElectronicAddress = "kaeufer@example.at"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "Mariahilfer Strasse 40"
		      buyer.City = "Vienna"
		      buyer.PostalCode = "1060"
		      buyer.CountryCode = "AT"
		      buyer.ContactName = "Franz Huber"
		      buyer.ContactEmail = "kaeufer@example.at"

		      invoice.AddNote("Thank you for your business!")

		    Case "NL"
		      // Netherlands
		      invoice.IBAN = "NL91ABNA0417164300"
		      invoice.BIC = "ABNANL2A"

		      seller.Name = "Verkoper BV"
		      seller.VATNumber = "NL123456789B01"
		      seller.LegalRegistrationID = "12345678"
		      seller.LegalRegistrationScheme = "0106"
		      seller.ElectronicAddress = "info@verkoper.nl"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "Herengracht 200"
		      seller.City = "Amsterdam"
		      seller.PostalCode = "1016BS"
		      seller.CountryCode = "NL"
		      seller.ContactName = "Pieter Jansen"
		      seller.ContactEmail = "info@verkoper.nl"
		      seller.ContactPhone = "+31 20 1234567"

		      buyer.Name = "Acheteur SARL"
		      buyer.VATNumber = "FR98765432101"
		      buyer.ElectronicAddress = "acheteur@example.fr"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "12 Rue de Rivoli"
		      buyer.City = "Paris"
		      buyer.PostalCode = "75001"
		      buyer.CountryCode = "FR"
		      buyer.ContactName = "Marie Martin"
		      buyer.ContactEmail = "acheteur@example.fr"

		      invoice.AddNote("Thank you for your business!")

		    Else
		      // Generic / other country
		      invoice.IBAN = "GB29NWBK60161331926819"
		      invoice.BIC = "NWBKGB2L"

		      seller.Name = "Generic Seller Ltd"
		      seller.VATNumber = countryCode + "123456789"
		      seller.ElectronicAddress = "seller@example.com"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "1 Main Street"
		      seller.City = "Capital City"
		      seller.PostalCode = "10000"
		      seller.CountryCode = countryCode
		      seller.ContactName = "John Doe"
		      seller.ContactEmail = "seller@example.com"
		      seller.ContactPhone = "+1 555 1234567"

		      buyer.Name = "Generic Buyer Inc"
		      buyer.VATNumber = "US987654321"
		      buyer.ElectronicAddress = "buyer@example.com"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "2 Commerce Ave"
		      buyer.City = "Trade City"
		      buyer.PostalCode = "20000"
		      buyer.CountryCode = "US"
		      buyer.ContactName = "Jane Smith"
		      buyer.ContactEmail = "buyer@example.com"

		      invoice.AddNote("Thank you for your business!")

		    End Select

		    invoice.Seller = seller
		    invoice.Buyer = buyer

		    // Line items
		    Dim item1 As New VNSPDFEInvoiceLineItem
		    item1.LineID = "1"
		    item1.ProductName = "VNS PDF Library - Desktop License"
		    item1.ProductDescription = "Pure Xojo PDF generation library, desktop platform"
		    item1.Quantity = 2
		    item1.UnitCode = VNSPDFEInvoicePremium.eUnitCode.Unit.ToString
		    item1.UnitPrice = 50.00
		    item1.TaxRate = 20.0
		    item1.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    item1.SellerItemID = "LIB-DESK-001"
		    item1.StandardItemID = "4012345678901"
		    item1.StandardItemSchemeID = "0160"
		    item1.LinePeriodStart = New DateTime(2026, 3, 1)
		    item1.LinePeriodEnd = New DateTime(2026, 3, 31)
		    invoice.AddLineItem(item1)

		    Dim item2 As New VNSPDFEInvoiceLineItem
		    item2.LineID = "2"
		    item2.ProductName = "Premium Encryption Module"
		    item2.ProductDescription = "AES-256/128 encryption with granular permissions"
		    item2.Quantity = 2
		    item2.UnitCode = VNSPDFEInvoicePremium.eUnitCode.Unit.ToString
		    item2.UnitPrice = 50.00
		    item2.TaxRate = 20.0
		    item2.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    item2.SellerItemID = "MOD-ENCRYPT-001"
		    invoice.AddLineItem(item2)

		    Dim item3 As New VNSPDFEInvoiceLineItem
		    item3.LineID = "3"
		    item3.ProductName = "Premium E-Invoice Module"
		    item3.ProductDescription = "Factur-X/ZUGFeRD e-invoicing with CII XML"
		    item3.Quantity = 2
		    item3.UnitCode = VNSPDFEInvoicePremium.eUnitCode.Unit.ToString
		    item3.UnitPrice = 50.00
		    item3.TaxRate = 20.0
		    item3.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    item3.SellerItemID = "MOD-EINV-001"
		    invoice.AddLineItem(item3)

		    // --- Line-level allowances/charges ---

		    // Item 1: 10% volume discount (2 x 50 = 100, discount = 10, net = 90)
		    Dim lineDiscount1 As New VNSPDFEInvoiceAllowanceCharge
		    lineDiscount1.IsCharge = False
		    lineDiscount1.Amount = 10.00
		    lineDiscount1.BasisAmount = 100.00
		    lineDiscount1.Percentage = 10.0
		    lineDiscount1.Reason = "Volume discount"
		    lineDiscount1.ReasonCode = VNSPDFEInvoicePremium.eAllowanceReasonCode.Discount.ToString
		    lineDiscount1.TaxRate = 20.0
		    lineDiscount1.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    item1.AddAllowanceCharge(lineDiscount1)

		    // Item 2: fixed 5 EUR loyalty discount (2 x 50 = 100, discount = 5, net = 95)
		    Dim lineDiscount2 As New VNSPDFEInvoiceAllowanceCharge
		    lineDiscount2.IsCharge = False
		    lineDiscount2.Amount = 5.00
		    lineDiscount2.Reason = "Loyalty discount"
		    lineDiscount2.ReasonCode = VNSPDFEInvoicePremium.eAllowanceReasonCode.SpecialRebate.ToString
		    lineDiscount2.TaxRate = 20.0
		    lineDiscount2.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    item2.AddAllowanceCharge(lineDiscount2)

		    // Item 3: 8 EUR rush delivery surcharge (2 x 50 = 100, charge = 8, net = 108)
		    Dim lineCharge3 As New VNSPDFEInvoiceAllowanceCharge
		    lineCharge3.IsCharge = True
		    lineCharge3.Amount = 8.00
		    lineCharge3.Reason = "Rush delivery surcharge"
		    lineCharge3.ReasonCode = VNSPDFEInvoicePremium.eChargeReasonCode.Advertising.ToString
		    lineCharge3.TaxRate = 20.0
		    lineCharge3.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    item3.AddAllowanceCharge(lineCharge3)

		    // --- Document-level allowances/charges ---

		    // Early payment discount
		    Dim docDiscount As New VNSPDFEInvoiceAllowanceCharge
		    docDiscount.IsCharge = False
		    docDiscount.Amount = 15.00
		    docDiscount.Reason = "Early payment discount (2%)"
		    docDiscount.ReasonCode = VNSPDFEInvoicePremium.eAllowanceReasonCode.Retailing.ToString
		    docDiscount.TaxRate = 20.0
		    docDiscount.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    invoice.AddAllowanceCharge(docDiscount)

		    // Shipping and handling charge
		    Dim docCharge As New VNSPDFEInvoiceAllowanceCharge
		    docCharge.IsCharge = True
		    docCharge.Amount = 5.00
		    docCharge.Reason = "Shipping and handling"
		    docCharge.ReasonCode = VNSPDFEInvoicePremium.eChargeReasonCode.Freight.ToString
		    docCharge.TaxRate = 20.0
		    docCharge.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    invoice.AddAllowanceCharge(docCharge)

		    // Tax breakdown (adjusted for all allowances/charges)
		    // Item 1: 2x50 - 10 = 90
		    // Item 2: 2x50 - 5 = 95
		    // Item 3: 2x50 + 8 = 108
		    // Line total: 90 + 95 + 108 = 293
		    // Doc allowance: -15, Doc charge: +5
		    // Tax basis: 293 - 15 + 5 = 283
		    // Tax: 283 x 20% = 56.60
		    Dim tax1 As New VNSPDFEInvoiceTaxBreakdown
		    tax1.TaxableAmount = 283.00
		    tax1.TaxAmount = 56.60
		    tax1.TaxRate = 20.0
		    tax1.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    invoice.AddTaxBreakdown(tax1)

		    statusText = statusText + "  Invoice: " + invoice.InvoiceNumber + EndOfLine
		    statusText = statusText + "  Seller: " + seller.Name + " (" + seller.VATNumber + ")" + EndOfLine
		    statusText = statusText + "  Buyer: " + buyer.Name + " (" + buyer.VATNumber + ")" + EndOfLine
		    statusText = statusText + "  Line items: " + Str(invoice.LineItems.Count) + EndOfLine
		    statusText = statusText + "  Line total: " + FormatHelper(invoice.LineTotalAmount, "###,##0.00") + " EUR" + EndOfLine
		    statusText = statusText + "  Doc allowances: -" + FormatHelper(invoice.AllowanceTotalAmount, "###,##0.00") + " EUR" + EndOfLine
		    statusText = statusText + "  Doc charges: +" + FormatHelper(invoice.ChargeTotalAmount, "###,##0.00") + " EUR" + EndOfLine
		    statusText = statusText + "  Tax basis: " + FormatHelper(invoice.TaxBasisTotalAmount, "###,##0.00") + " EUR" + EndOfLine
		    statusText = statusText + "  Tax total: " + FormatHelper(invoice.TaxTotalAmount, "###,##0.00") + " EUR" + EndOfLine
		    statusText = statusText + "  Grand total: " + FormatHelper(invoice.GrandTotalAmount, "###,##0.00") + " EUR" + EndOfLine + EndOfLine

		    // --- Validate invoice ---
		    statusText = statusText + "Step 2: Validating invoice (EN 16931 profile)..." + EndOfLine

		    Dim errors() As String = VNSPDFEInvoiceValidator.Validate(invoice, VNSPDFEInvoicePremium.eFacturXProfile.EN16931)
		    If errors.Count > 0 Then
		      statusText = statusText + "  Validation errors:" + EndOfLine
		      For i As Integer = 0 To errors.LastIndex
		        statusText = statusText + "    - " + errors(i) + EndOfLine
		      Next
		      result.Value("error") = "Validation failed"
		      result.Value("message") = statusText
		      Return result
		    Else
		      statusText = statusText + "  Validation passed!" + EndOfLine + EndOfLine
		    End If

		    // --- Generate CII XML preview ---
		    statusText = statusText + "Step 3: Generating CII XML..." + EndOfLine

		    Dim ciiXml As String = VNSPDFEInvoiceXMLGenerator.GenerateCII(invoice, VNSPDFEInvoicePremium.eFacturXProfile.EN16931, False)
		    statusText = statusText + "  XML length: " + Str(ciiXml.Length) + " bytes" + EndOfLine

		    // Validate XML element ordering
		    Dim xmlWarnings() As String = VNSPDFEInvoiceXMLParser.ValidateXMLContent(ciiXml)
		    Dim orderErrors As Integer = 0
		    For i As Integer = 0 To xmlWarnings.LastIndex
		      If xmlWarnings(i).BeginsWith("EINV-E50") Then
		        statusText = statusText + "  ORDER ERROR: " + xmlWarnings(i) + EndOfLine
		        orderErrors = orderErrors + 1
		      End If
		    Next
		    If orderErrors = 0 Then
		      statusText = statusText + "  XML element order: OK" + EndOfLine
		    End If
		    statusText = statusText + EndOfLine

		    // --- Create PDF with visual invoice ---
		    statusText = statusText + "Step 4: Creating PDF with visual invoice layout..." + EndOfLine

		    Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		    pdf.Title = "Example 30 - Factur-X E-Invoice"
		    pdf.Author = "VNS PDF Library"
		    pdf.Subject = "Factur-X EN 16931 compliant e-invoice"

		    // PDF/A-3 requires all fonts embedded — register TrueType fonts
		    // Use Arial (separate .ttf files for each style, available on all platforms)
		    Dim arialPath As String = VNSPDFModule.FindSystemFontPath("Arial", "")
		    Dim arialBoldPath As String = VNSPDFModule.FindSystemFontPath("Arial", " Bold")
		    Dim arialItalicPath As String = VNSPDFModule.FindSystemFontPath("Arial", " Italic")
		    statusText = statusText + "  Font paths:" + EndOfLine
		    statusText = statusText + "    Arial: " + If(arialPath <> "", arialPath, "NOT FOUND") + EndOfLine
		    statusText = statusText + "    Arial Bold: " + If(arialBoldPath <> "", arialBoldPath, "NOT FOUND") + EndOfLine
		    statusText = statusText + "    Arial Italic: " + If(arialItalicPath <> "", arialItalicPath, "NOT FOUND") + EndOfLine
		    pdf.AddUTF8Font("helvetica", "", arialPath)
		    pdf.AddUTF8Font("helvetica", "B", arialBoldPath)
		    pdf.AddUTF8Font("helvetica", "I", arialItalicPath)
		    If Not pdf.Ok Then
		      statusText = statusText + "  WARNING: Font loading error: " + pdf.GetError + EndOfLine
		      pdf.ClearError()
		    End If

		    // --- Page 1: Invoice layout ---
		    Call pdf.SetFont("helvetica", "B", 20)
		    Call pdf.Cell(0, 12, "INVOICE", 0, 1, "R")
		    Call pdf.Ln(2)

		    // Invoice info line
		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.Cell(95, 6, "Invoice No: " + invoice.InvoiceNumber, 0, 0)
		    Call pdf.Cell(95, 6, "Date: " + Str(invoice.InvoiceDate.Year) + "-" + invoice.InvoiceDate.Month.ToString("00") + "-" + invoice.InvoiceDate.Day.ToString("00"), 0, 1, "R")
		    Call pdf.Cell(95, 6, "Buyer Ref: " + invoice.BuyerReference, 0, 0)
		    Call pdf.Cell(95, 6, "Due: " + Str(invoice.DueDate.Year) + "-" + invoice.DueDate.Month.ToString("00") + "-" + invoice.DueDate.Day.ToString("00"), 0, 1, "R")
		    If invoice.PurchaseOrderReference <> "" Then
		      Call pdf.Cell(95, 6, "PO: " + invoice.PurchaseOrderReference, 0, 0)
		    End If
		    If invoice.ContractReference <> "" Then
		      Call pdf.Cell(95, 6, "Contract: " + invoice.ContractReference, 0, 1, "R")
		    End If
		    If invoice.InvoicePeriodStart <> Nil And invoice.InvoicePeriodEnd <> Nil Then
		      Call pdf.Cell(190, 6, "Period: " + Str(invoice.InvoicePeriodStart.Year) + "-" + invoice.InvoicePeriodStart.Month.ToString("00") + "-" + invoice.InvoicePeriodStart.Day.ToString("00") + " to " + Str(invoice.InvoicePeriodEnd.Year) + "-" + invoice.InvoicePeriodEnd.Month.ToString("00") + "-" + invoice.InvoicePeriodEnd.Day.ToString("00"), 0, 1)
		    End If
		    Call pdf.Ln(4)

		    // Seller and Buyer boxes side by side
		    Dim yParties As Double = pdf.GetY()

		    // Seller box
		    Call pdf.SetFont("helvetica", "B", 11)
		    Call pdf.Cell(90, 7, "FROM (Seller)", 0, 1)
		    Call pdf.SetFont("helvetica", "", 9)
		    Call pdf.Cell(90, 5, seller.Name, 0, 1)
		    Call pdf.Cell(90, 5, seller.AddressLine1, 0, 1)
		    Call pdf.Cell(90, 5, seller.PostalCode + " " + seller.City + ", " + seller.CountryCode, 0, 1)
		    Call pdf.Cell(90, 5, "VAT: " + seller.VATNumber, 0, 1)
		    Call pdf.Cell(90, 5, seller.ContactEmail, 0, 1)

		    Dim yAfterSeller As Double = pdf.GetY()

		    // Buyer box (positioned to the right)
		    Call pdf.SetY(yParties)
		    Call pdf.SetX(110)
		    Call pdf.SetFont("helvetica", "B", 11)
		    Call pdf.Cell(90, 7, "TO (Buyer)", 0, 1)
		    Call pdf.SetX(110)
		    Call pdf.SetFont("helvetica", "", 9)
		    Call pdf.Cell(90, 5, buyer.Name, 0, 1)
		    Call pdf.SetX(110)
		    Call pdf.Cell(90, 5, buyer.AddressLine1, 0, 1)
		    Call pdf.SetX(110)
		    Call pdf.Cell(90, 5, buyer.PostalCode + " " + buyer.City + ", " + buyer.CountryCode, 0, 1)
		    Call pdf.SetX(110)
		    Call pdf.Cell(90, 5, "VAT: " + buyer.VATNumber, 0, 1)
		    Call pdf.SetX(110)
		    Call pdf.Cell(90, 5, buyer.ContactEmail, 0, 1)

		    // Move below whichever was taller
		    If pdf.GetY() > yAfterSeller Then
		      Call pdf.Ln(8)
		    Else
		      Call pdf.SetY(yAfterSeller + 8)
		    End If

		    // Line items table header
		    Call pdf.SetFont("helvetica", "B", 9)
		    Call pdf.SetFillColor(220, 220, 220)
		    Call pdf.Cell(10, 7, "#", 1, 0, "C", True)
		    Call pdf.Cell(70, 7, "Description", 1, 0, "L", True)
		    Call pdf.Cell(20, 7, "Qty", 1, 0, "C", True)
		    Call pdf.Cell(25, 7, "Unit Price", 1, 0, "R", True)
		    Call pdf.Cell(20, 7, "VAT %", 1, 0, "C", True)
		    Call pdf.Cell(30, 7, "Net Amount", 1, 0, "R", True)
		    Call pdf.Ln(7)

		    // Line items
		    Call pdf.SetFont("helvetica", "", 9)
		    Dim items() As VNSPDFEInvoiceLineItem = invoice.LineItems
		    For i As Integer = 0 To items.LastIndex
		      Dim li As VNSPDFEInvoiceLineItem = items(i)
		      Call pdf.Cell(10, 6, li.LineID, 1, 0, "C")
		      Call pdf.Cell(70, 6, li.ProductName, 1, 0, "L")
		      Call pdf.Cell(20, 6, FormatHelper(li.Quantity, "0.##"), 1, 0, "C")
		      Call pdf.Cell(25, 6, FormatHelper(li.UnitPrice, "0.00"), 1, 0, "R")
		      Call pdf.Cell(20, 6, FormatHelper(li.TaxRate, "0.0") + "%", 1, 0, "C")
		      Call pdf.Cell(30, 6, FormatHelper(li.NetAmount, "###,##0.00"), 1, 0, "R")
		      Call pdf.Ln(6)

		      // Show line-level allowances/charges as indented sub-rows
		      Dim lineACs() As VNSPDFEInvoiceAllowanceCharge = li.AllowancesCharges
		      If lineACs.Count > 0 Then
		        Call pdf.SetFont("helvetica", "I", 8)
		        pdf.SetTextColor(100, 100, 100)
		        For ai As Integer = 0 To lineACs.LastIndex
		          Dim ac As VNSPDFEInvoiceAllowanceCharge = lineACs(ai)
		          Dim acLabel As String
		          If ac.IsCharge Then
		            acLabel = "  + Charge: "
		          Else
		            acLabel = "  - Allowance: "
		          End If
		          acLabel = acLabel + ac.Reason
		          If ac.Percentage > 0 Then acLabel = acLabel + " (" + FormatHelper(ac.Percentage, "0.#") + "%)"
		          Dim acAmt As String
		          If ac.IsCharge Then
		            acAmt = "+" + FormatHelper(ac.Amount, "0.00")
		          Else
		            acAmt = "-" + FormatHelper(ac.Amount, "0.00")
		          End If
		          Call pdf.Cell(10, 5, "", 0, 0)
		          Call pdf.Cell(115, 5, acLabel, 0, 0, "L")
		          Call pdf.Cell(30, 5, acAmt, 0, 0, "R")
		          Call pdf.Ln(5)
		        Next
		        Call pdf.SetFont("helvetica", "", 9)
		        pdf.SetTextColor(0, 0, 0)
		      End If
		    Next

		    // Totals
		    Call pdf.Ln(3)
		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.Cell(145, 6, "Subtotal (excl. VAT):", 0, 0, "R")
		    Call pdf.Cell(30, 6, FormatHelper(invoice.LineTotalAmount, "###,##0.00") + " EUR", 0, 1, "R")

		    // Document-level allowances/charges
		    Dim docACs() As VNSPDFEInvoiceAllowanceCharge = invoice.AllowancesCharges
		    If docACs.Count > 0 Then
		      For i As Integer = 0 To docACs.LastIndex
		        Dim ac As VNSPDFEInvoiceAllowanceCharge = docACs(i)
		        Dim acLabel As String
		        If ac.IsCharge Then
		          acLabel = "Charge: " + ac.Reason
		        Else
		          acLabel = "Allowance: " + ac.Reason
		        End If
		        Dim acAmt As String
		        If ac.IsCharge Then
		          acAmt = "+" + FormatHelper(ac.Amount, "###,##0.00") + " EUR"
		        Else
		          acAmt = "-" + FormatHelper(ac.Amount, "###,##0.00") + " EUR"
		        End If
		        Call pdf.Cell(145, 6, acLabel + ":", 0, 0, "R")
		        Call pdf.Cell(30, 6, acAmt, 0, 1, "R")
		      Next
		    End If

		    // Show tax basis if different from line total (allowances/charges present)
		    If invoice.AllowanceTotalAmount > 0 Or invoice.ChargeTotalAmount > 0 Then
		      Call pdf.Cell(145, 6, "Tax basis:", 0, 0, "R")
		      Call pdf.Cell(30, 6, FormatHelper(invoice.TaxBasisTotalAmount, "###,##0.00") + " EUR", 0, 1, "R")
		    End If

		    Call pdf.Cell(145, 6, "VAT (20.0%):", 0, 0, "R")
		    Call pdf.Cell(30, 6, FormatHelper(invoice.TaxTotalAmount, "###,##0.00") + " EUR", 0, 1, "R")

		    Call pdf.SetFont("helvetica", "B", 11)
		    Call pdf.Cell(145, 8, "TOTAL:", 0, 0, "R")
		    Call pdf.Cell(30, 8, FormatHelper(invoice.GrandTotalAmount, "###,##0.00") + " EUR", 0, 1, "R")

		    // Payment info
		    Call pdf.Ln(6)
		    Call pdf.SetDrawColor(200, 200, 200)
		    pdf.Line(pdf.GetX(), pdf.GetY(), pdf.GetX() + 175, pdf.GetY())
		    Call pdf.Ln(3)

		    Call pdf.SetFont("helvetica", "B", 10)
		    Call pdf.Cell(0, 6, "Payment Information", 0, 1)
		    Call pdf.SetFont("helvetica", "", 9)
		    Call pdf.Cell(0, 5, "IBAN: " + invoice.IBAN, 0, 1)
		    Call pdf.Cell(0, 5, "BIC: " + invoice.BIC, 0, 1)
		    Call pdf.Cell(0, 5, "Reference: " + invoice.PaymentReference, 0, 1)
		    If invoice.PaymentTerms <> "" Then
		      Call pdf.Cell(0, 5, "Terms: " + invoice.PaymentTerms, 0, 1)
		    End If
		    Call pdf.Ln(3)
		    Call pdf.SetFont("helvetica", "I", 9)
		    Dim invoiceNotes() As Dictionary = invoice.Notes
		    For i As Integer = 0 To invoiceNotes.LastIndex
		      Call pdf.Cell(0, 5, invoiceNotes(i).Value("content").StringValue, 0, 1)
		    Next

		    // Factur-X badge
		    Call pdf.Ln(8)
		    Call pdf.SetFont("helvetica", "B", 8)
		    Call pdf.SetTextColor(100, 100, 100)
		    Call pdf.Cell(0, 5, "This invoice is Factur-X EN 16931 compliant (PDF/A-3b with embedded CII XML)", 0, 1, "C")
		    Call pdf.Cell(0, 5, "Conforms to " + EInvoiceNormForCountry(countryCode), 0, 1, "C")
		    Call pdf.SetTextColor(0, 0, 0)

		    If pdf.Err() Then
		      statusText = statusText + "  Error creating PDF: " + pdf.GetError() + EndOfLine
		      result.Value("error") = pdf.GetError()
		      result.Value("message") = statusText
		      Return result
		    End If

		    statusText = statusText + "  Visual invoice layout created." + EndOfLine + EndOfLine

		    // --- Apply Factur-X e-invoice ---
		    statusText = statusText + "Step 5: Applying Factur-X compliance..." + EndOfLine
		    statusText = statusText + "  - Embedding CII XML as factur-x.xml" + EndOfLine
		    statusText = statusText + "  - Setting PDF/A-3b XMP metadata" + EndOfLine
		    statusText = statusText + "  - Adding sRGB ICC output intent" + EndOfLine
		    statusText = statusText + "  - Setting PDF version 1.7" + EndOfLine

		    VNSPDFEInvoicePremium.CreateFacturXInvoice(pdf, invoice, VNSPDFEInvoicePremium.eFacturXProfile.EN16931)

		    If pdf.Err() Then
		      statusText = statusText + "  Error: " + pdf.GetError() + EndOfLine
		      result.Value("error") = pdf.GetError()
		      result.Value("message") = statusText
		      Return result
		    End If

		    statusText = statusText + "  Factur-X compliance applied successfully!" + EndOfLine + EndOfLine

		    // --- Output ---
		    Dim pdfData As String = pdf.Output()

		    If pdf.Err() Then
		      statusText = statusText + "Error: " + pdf.GetError() + EndOfLine
		      result.Value("error") = pdf.GetError()
		    Else
		      statusText = statusText + "Success! Factur-X e-invoice PDF generated." + EndOfLine
		      statusText = statusText + "PDF size: " + Str(pdfData.Length) + " bytes" + EndOfLine + EndOfLine
		      statusText = statusText + "PDF STRUCTURE HIGHLIGHTS:" + EndOfLine
		      statusText = statusText + "  - /AF array in catalog (associated files)" + EndOfLine
		      statusText = statusText + "  - /AFRelationship /Data on file attachment" + EndOfLine
		      statusText = statusText + "  - /Subtype /application#2Fxml on embedded stream" + EndOfLine
		      statusText = statusText + "  - XMP: pdfaid:part=3, pdfaid:conformance=B" + EndOfLine
		      statusText = statusText + "  - XMP: Factur-X extension schema (fx:ConformanceLevel=EN 16931)" + EndOfLine
		      statusText = statusText + "  - sRGB ICC profile in OutputIntent" + EndOfLine
		      statusText = statusText + "  - factur-x.xml embedded as attachment" + EndOfLine
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example30_einvoice_facturx_" + countryCode.Lowercase + ".pdf"

		      // --- Generate credit note referencing this invoice ---
		      statusText = statusText + EndOfLine + "Step 6: Generating credit note..." + EndOfLine

		      Dim creditNote As New VNSPDFEInvoice
		      creditNote.InvoiceNumber = "CN-2026-0042"
		      creditNote.InvoiceTypeCode = VNSPDFEInvoicePremium.eInvoiceTypeCode.CreditNote.ToString
		      creditNote.InvoiceDate = DateTime.Now
		      creditNote.DueDate = DateTime.Now
		      creditNote.DeliveryDate = DateTime.Now
		      creditNote.Currency = "EUR"
		      creditNote.BuyerReference = invoice.BuyerReference
		      creditNote.PaymentMeansCode = "30"
		      creditNote.PaymentReference = "CN-2026-0042"
		      creditNote.IBAN = invoice.IBAN
		      creditNote.BIC = invoice.BIC
		      creditNote.PrecedingInvoiceNumber = invoice.InvoiceNumber
		      creditNote.PrecedingInvoiceDate = invoice.InvoiceDate
		      creditNote.PaymentTerms = "Credit applied to account"
		      creditNote.Seller = invoice.Seller
		      creditNote.Buyer = invoice.Buyer

		      // Credit note line: partial refund on item 1
		      Dim cnItem As New VNSPDFEInvoiceLineItem
		      cnItem.LineID = "1"
		      cnItem.ProductName = "VNS PDF Library - Desktop License (return)"
		      cnItem.ProductDescription = "Partial refund: 1 of 2 licenses returned"
		      cnItem.Quantity = 1
		      cnItem.UnitCode = VNSPDFEInvoicePremium.eUnitCode.Unit.ToString
		      cnItem.UnitPrice = 50.00
		      cnItem.TaxRate = 20.0
		      cnItem.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		      creditNote.AddLineItem(cnItem)

		      // Tax breakdown for credit note
		      Dim cnTax As New VNSPDFEInvoiceTaxBreakdown
		      cnTax.TaxableAmount = 50.00
		      cnTax.TaxAmount = 10.00
		      cnTax.TaxRate = 20.0
		      cnTax.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		      creditNote.AddTaxBreakdown(cnTax)

		      // Add French mandatory notes if FR (BR-FR-05)
		      If countryCode = "FR" Then
		        creditNote.AddNote("Avoir suite a retour partiel.", "AAB")
		        creditNote.AddNote("Late payment penalties: 3x the legal interest rate.", "PMD")
		        creditNote.AddNote("Recovery costs for unpaid invoices: 40 EUR.", "PMT")
		      End If

		      // Validate credit note
		      Dim cnErrors() As String = VNSPDFEInvoiceValidator.Validate(creditNote, VNSPDFEInvoicePremium.eFacturXProfile.EN16931)
		      If cnErrors.Count > 0 Then
		        statusText = statusText + "  Credit note validation errors:" + EndOfLine
		        For i As Integer = 0 To cnErrors.LastIndex
		          statusText = statusText + "    - " + cnErrors(i) + EndOfLine
		        Next
		      Else
		        statusText = statusText + "  Credit note validation passed!" + EndOfLine
		      End If

		      // Show credit note settlement XML for debugging
		      Dim cnXml As String = VNSPDFEInvoiceXMLGenerator.GenerateCII(creditNote, VNSPDFEInvoicePremium.eFacturXProfile.EN16931, False)
		      Dim settlStart As Integer = cnXml.IndexOf("ApplicableHeaderTradeSettlement")
		      If settlStart >= 0 Then
		        Dim settlSnippet As String = cnXml.Middle(settlStart - 5, 800)
		        statusText = statusText + "  Settlement XML:" + EndOfLine + settlSnippet + EndOfLine + "..." + EndOfLine
		      End If

		      // Create credit note PDF
		      Dim cnPdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		      cnPdf.Title = "Credit Note CN-2026-0042"
		      cnPdf.Author = "VNS PDF Library"

		      // Embed Arial for PDF/A-3
		      cnPdf.AddUTF8Font("helvetica", "", VNSPDFModule.FindSystemFontPath("Arial", ""))
		      cnPdf.AddUTF8Font("helvetica", "B", VNSPDFModule.FindSystemFontPath("Arial", " Bold"))
		      cnPdf.AddUTF8Font("helvetica", "I", VNSPDFModule.FindSystemFontPath("Arial", " Italic"))

		      // Simple credit note layout
		      Call cnPdf.SetFont("helvetica", "B", 20)
		      Call cnPdf.Cell(0, 12, "CREDIT NOTE", 0, 1, "R")
		      Call cnPdf.SetFont("helvetica", "", 10)
		      Call cnPdf.Cell(95, 6, "Credit Note No: " + creditNote.InvoiceNumber, 0, 0)
		      Call cnPdf.Cell(95, 6, "Date: " + Str(creditNote.InvoiceDate.Year) + "-" + creditNote.InvoiceDate.Month.ToString("00") + "-" + creditNote.InvoiceDate.Day.ToString("00"), 0, 1, "R")
		      Call cnPdf.Cell(190, 6, "References invoice: " + creditNote.PrecedingInvoiceNumber, 0, 1)
		      Call cnPdf.Ln(4)

		      Call cnPdf.SetFont("helvetica", "B", 11)
		      Call cnPdf.Cell(90, 7, "FROM: " + seller.Name, 0, 0)
		      Call cnPdf.Cell(90, 7, "TO: " + buyer.Name, 0, 1)
		      Call cnPdf.Ln(6)

		      // Line items table
		      Call cnPdf.SetFont("helvetica", "B", 9)
		      Call cnPdf.SetFillColor(220, 220, 220)
		      Call cnPdf.Cell(10, 7, "#", 1, 0, "C", True)
		      Call cnPdf.Cell(80, 7, "Description", 1, 0, "L", True)
		      Call cnPdf.Cell(20, 7, "Qty", 1, 0, "C", True)
		      Call cnPdf.Cell(25, 7, "Price", 1, 0, "R", True)
		      Call cnPdf.Cell(20, 7, "VAT%", 1, 0, "C", True)
		      Call cnPdf.Cell(30, 7, "Amount", 1, 0, "R", True)
		      Call cnPdf.Ln(7)

		      Call cnPdf.SetFont("helvetica", "", 9)
		      Call cnPdf.Cell(10, 6, "1", 1, 0, "C")
		      Call cnPdf.Cell(80, 6, cnItem.ProductName, 1, 0, "L")
		      Call cnPdf.Cell(20, 6, "1", 1, 0, "C")
		      Call cnPdf.Cell(25, 6, "50.00", 1, 0, "R")
		      Call cnPdf.Cell(20, 6, "20.0%", 1, 0, "C")
		      Call cnPdf.Cell(30, 6, "50.00", 1, 0, "R")
		      Call cnPdf.Ln(6)

		      Call cnPdf.Ln(3)
		      Call cnPdf.SetFont("helvetica", "", 10)
		      Call cnPdf.Cell(145, 6, "Subtotal:", 0, 0, "R")
		      Call cnPdf.Cell(30, 6, "50.00 EUR", 0, 1, "R")
		      Call cnPdf.Cell(145, 6, "VAT (20.0%):", 0, 0, "R")
		      Call cnPdf.Cell(30, 6, "10.00 EUR", 0, 1, "R")
		      Call cnPdf.SetFont("helvetica", "B", 11)
		      Call cnPdf.Cell(145, 8, "CREDIT TOTAL:", 0, 0, "R")
		      Call cnPdf.Cell(30, 8, "60.00 EUR", 0, 1, "R")

		      Call cnPdf.Ln(8)
		      Call cnPdf.SetFont("helvetica", "B", 8)
		      cnPdf.SetTextColor(100, 100, 100)
		      Call cnPdf.Cell(0, 5, "This credit note is Factur-X EN 16931 compliant (PDF/A-3b with embedded CII XML)", 0, 1, "C")
		      cnPdf.SetTextColor(0, 0, 0)

		      // Apply Factur-X compliance
		      VNSPDFEInvoicePremium.CreateFacturXInvoice(cnPdf, creditNote, VNSPDFEInvoicePremium.eFacturXProfile.EN16931)

		      Dim cnData As String = cnPdf.Output()
		      If cnData <> "" Then
		        result.Value("pdf2") = cnData
		        result.Value("filename2") = "example30_creditnote_facturx_" + countryCode.Lowercase + ".pdf"
		        statusText = statusText + "  Credit note PDF size: " + Str(cnData.Length) + " bytes" + EndOfLine
		      End If
		    End If

		    // --- Generate precision test invoice (small prices x large quantities) ---
		    statusText = statusText + EndOfLine + "Step 7: Generating precision test invoice..." + EndOfLine

		    Dim precInv As New VNSPDFEInvoice(2, 5, 3, 2)
		    precInv.InvoiceNumber = "INV-2026-PREC"
		    precInv.InvoiceDate = DateTime.Now
		    precInv.DueDate = DateTime.Now
		    precInv.DeliveryDate = DateTime.Now
		    precInv.Currency = "EUR"
		    precInv.InvoiceTypeCode = "380"
		    precInv.BuyerReference = "PO-PRECISION-TEST"
		    precInv.PaymentMeansCode = "30"
		    precInv.PaymentReference = "INV-2026-PREC"
		    precInv.IBAN = invoice.IBAN
		    precInv.BIC = invoice.BIC
		    precInv.PaymentTerms = "Net 30 days"
		    precInv.Seller = invoice.Seller
		    precInv.Buyer = invoice.Buyer

		    If countryCode = "FR" Then
		      precInv.AddNote("Pas d'escompte pour paiement anticipe.", "AAB")
		      precInv.AddNote("Late payment penalties: 3x the legal interest rate.", "PMD")
		      precInv.AddNote("Recovery costs for unpaid invoices: 40 EUR.", "PMT")
		    End If

		    // Line 1: Small unit price x large quantity
		    // 0.00250 EUR x 10000 = 25.00 EUR
		    Dim precItem1 As New VNSPDFEInvoiceLineItem
		    precItem1.LineID = "1"
		    precItem1.ProductName = "Micro-component (small price x large qty)"
		    precItem1.ProductDescription = "Unit price 0.00250 EUR x 10000 units = 25.00 EUR"
		    precItem1.Quantity = 10000
		    precItem1.UnitPrice = 0.0025
		    precItem1.TaxRate = 20.0
		    precItem1.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    precInv.AddLineItem(precItem1)

		    // Line 2: Fractional quantity
		    // 150.00 EUR x 1.500 kg = 225.00 EUR
		    Dim precItem2 As New VNSPDFEInvoiceLineItem
		    precItem2.LineID = "2"
		    precItem2.ProductName = "Bulk material sold by weight"
		    precItem2.ProductDescription = "150.00 EUR/kg x 1.500 kg"
		    precItem2.Quantity = 1.5
		    precItem2.UnitCode = VNSPDFEInvoicePremium.eUnitCode.Kilogram.ToString
		    precItem2.UnitPrice = 150.00
		    precItem2.TaxRate = 20.0
		    precItem2.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    precInv.AddLineItem(precItem2)

		    // Line 3: Very small price with allowance -> negative net
		    // 0.01000 EUR x 500 = 5.00, allowance 10.00 -> net = -5.00 EUR
		    Dim precItem3 As New VNSPDFEInvoiceLineItem
		    precItem3.LineID = "3"
		    precItem3.ProductName = "Sample items (net negative after discount)"
		    precItem3.ProductDescription = "0.01 EUR x 500 = 5.00, minus 10.00 discount = -5.00"
		    precItem3.Quantity = 500
		    precItem3.UnitPrice = 0.01
		    precItem3.TaxRate = 20.0
		    precItem3.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    precInv.AddLineItem(precItem3)
		    Dim precDiscount As New VNSPDFEInvoiceAllowanceCharge
		    precDiscount.IsCharge = False
		    precDiscount.Amount = 10.00
		    precDiscount.Reason = "Promotional discount exceeding line value"
		    precDiscount.TaxRate = 20.0
		    precDiscount.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    precItem3.AddAllowanceCharge(precDiscount)

		    // Tax breakdown: sum of lines = 25.00 + 225.00 + (-5.00) = 245.00
		    // VAT = 245.00 * 20% = 49.00
		    Dim precTax As New VNSPDFEInvoiceTaxBreakdown
		    precTax.TaxableAmount = 245.00
		    precTax.TaxAmount = 49.00
		    precTax.TaxRate = 20.0
		    precTax.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    precInv.AddTaxBreakdown(precTax)

		    statusText = statusText + "  Precision settings: amounts=" + Str(precInv.AmountPrecision)
		    statusText = statusText + ", prices=" + Str(precInv.PricePrecision)
		    statusText = statusText + ", quantities=" + Str(precInv.QuantityPrecision)
		    statusText = statusText + ", percents=" + Str(precInv.PercentPrecision) + EndOfLine
		    statusText = statusText + "  Line 1: 0.00250 x 10000 = " + Str(precItem1.NetAmount, "0.00") + EndOfLine
		    statusText = statusText + "  Line 2: 149.99 x 1.500 = " + Str(precItem2.NetAmount, "0.00") + EndOfLine
		    statusText = statusText + "  Line 3: 0.01 x 500 - 10.00 = " + Str(precItem3.NetAmount, "0.00") + EndOfLine
		    statusText = statusText + "  Line total: " + Str(precInv.LineTotalAmount, "0.00") + EndOfLine
		    statusText = statusText + "  Grand total: " + Str(precInv.GrandTotalAmount, "0.00") + " EUR" + EndOfLine

		    // Validate
		    Dim precErrors() As String = VNSPDFEInvoiceValidator.Validate(precInv, VNSPDFEInvoicePremium.eFacturXProfile.EN16931)
		    If precErrors.Count > 0 Then
		      statusText = statusText + "  Validation errors:" + EndOfLine
		      For i As Integer = 0 To precErrors.LastIndex
		        statusText = statusText + "    - " + precErrors(i) + EndOfLine
		      Next
		    Else
		      statusText = statusText + "  Validation passed!" + EndOfLine
		    End If

		    // Generate PDF
		    Dim precPdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		    precPdf.Title = "Precision Test Invoice INV-2026-PREC"
		    precPdf.Author = "VNS PDF Library"

		    precPdf.AddUTF8Font("helvetica", "", VNSPDFModule.FindSystemFontPath("Arial", ""))
		    precPdf.AddUTF8Font("helvetica", "B", VNSPDFModule.FindSystemFontPath("Arial", " Bold"))
		    precPdf.AddUTF8Font("helvetica", "I", VNSPDFModule.FindSystemFontPath("Arial", " Italic"))

		    Call precPdf.SetFont("helvetica", "B", 20)
		    Call precPdf.Cell(0, 12, "PRECISION TEST INVOICE", 0, 1, "R")
		    Call precPdf.SetFont("helvetica", "", 10)
		    Call precPdf.Cell(95, 6, "Invoice No: " + precInv.InvoiceNumber, 0, 0)
		    Call precPdf.Cell(95, 6, "Date: " + Str(precInv.InvoiceDate.Year) + "-" + precInv.InvoiceDate.Month.ToString("00") + "-" + precInv.InvoiceDate.Day.ToString("00"), 0, 1, "R")
		    Call precPdf.Cell(190, 6, "Precision: prices=" + Str(precInv.PricePrecision) + " qty=" + Str(precInv.QuantityPrecision), 0, 1)
		    Call precPdf.Ln(4)

		    Call precPdf.SetFont("helvetica", "B", 11)
		    Call precPdf.Cell(90, 7, "FROM: " + seller.Name, 0, 0)
		    Call precPdf.Cell(90, 7, "TO: " + buyer.Name, 0, 1)
		    Call precPdf.Ln(6)

		    // Table header
		    Call precPdf.SetFont("helvetica", "B", 9)
		    Call precPdf.SetFillColor(220, 220, 220)
		    Call precPdf.Cell(10, 7, "#", 1, 0, "C", True)
		    Call precPdf.Cell(60, 7, "Description", 1, 0, "L", True)
		    Call precPdf.Cell(25, 7, "Qty", 1, 0, "R", True)
		    Call precPdf.Cell(30, 7, "Unit Price", 1, 0, "R", True)
		    Call precPdf.Cell(20, 7, "VAT%", 1, 0, "C", True)
		    Call precPdf.Cell(30, 7, "Net Amount", 1, 0, "R", True)
		    Call precPdf.Ln(7)

		    Call precPdf.SetFont("helvetica", "", 9)
		    // Line 1
		    Call precPdf.Cell(10, 6, "1", 1, 0, "C")
		    Call precPdf.Cell(60, 6, precItem1.ProductName, 1, 0, "L")
		    Call precPdf.Cell(25, 6, Str(precItem1.Quantity, "#,##0.###"), 1, 0, "R")
		    Call precPdf.Cell(30, 6, Str(precItem1.UnitPrice, "0.00000"), 1, 0, "R")
		    Call precPdf.Cell(20, 6, "20%", 1, 0, "C")
		    Call precPdf.Cell(30, 6, Str(precItem1.NetAmount, "0.00"), 1, 0, "R")
		    Call precPdf.Ln(6)
		    // Line 2
		    Call precPdf.Cell(10, 6, "2", 1, 0, "C")
		    Call precPdf.Cell(60, 6, precItem2.ProductName, 1, 0, "L")
		    Call precPdf.Cell(25, 6, Str(precItem2.Quantity, "#,##0.###"), 1, 0, "R")
		    Call precPdf.Cell(30, 6, Str(precItem2.UnitPrice, "0.00"), 1, 0, "R")
		    Call precPdf.Cell(20, 6, "20%", 1, 0, "C")
		    Call precPdf.Cell(30, 6, Str(precItem2.NetAmount, "0.00"), 1, 0, "R")
		    Call precPdf.Ln(6)
		    // Line 3 (negative net)
		    Call precPdf.Cell(10, 6, "3", 1, 0, "C")
		    Call precPdf.Cell(60, 6, precItem3.ProductName, 1, 0, "L")
		    Call precPdf.Cell(25, 6, Str(precItem3.Quantity, "#,##0.###"), 1, 0, "R")
		    Call precPdf.Cell(30, 6, Str(precItem3.UnitPrice, "0.00000"), 1, 0, "R")
		    Call precPdf.Cell(20, 6, "20%", 1, 0, "C")
		    Call precPdf.Cell(30, 6, Str(precItem3.NetAmount, "0.00"), 1, 0, "R")
		    Call precPdf.Ln(6)

		    Call precPdf.Ln(3)
		    Call precPdf.SetFont("helvetica", "", 10)
		    Call precPdf.Cell(145, 6, "Line Total:", 0, 0, "R")
		    Call precPdf.Cell(30, 6, Str(precInv.LineTotalAmount, "0.00") + " EUR", 0, 1, "R")
		    Call precPdf.Cell(145, 6, "VAT (20%):", 0, 0, "R")
		    Call precPdf.Cell(30, 6, Str(precInv.TaxTotalAmount, "0.00") + " EUR", 0, 1, "R")
		    Call precPdf.SetFont("helvetica", "B", 11)
		    Call precPdf.Cell(145, 8, "GRAND TOTAL:", 0, 0, "R")
		    Call precPdf.Cell(30, 8, Str(precInv.GrandTotalAmount, "0.00") + " EUR", 0, 1, "R")

		    Call precPdf.Ln(8)
		    Call precPdf.SetFont("helvetica", "B", 8)
		    precPdf.SetTextColor(100, 100, 100)
		    Call precPdf.Cell(0, 5, "Precision test: Factur-X EN 16931 compliant (prices 5 decimals, quantities 3 decimals)", 0, 1, "C")
		    precPdf.SetTextColor(0, 0, 0)

		    VNSPDFEInvoicePremium.CreateFacturXInvoice(precPdf, precInv, VNSPDFEInvoicePremium.eFacturXProfile.EN16931)

		    Dim precData As String = precPdf.Output()
		    If precData <> "" Then
		      result.Value("pdf3") = precData
		      result.Value("filename3") = "example30_precision_facturx_" + countryCode.Lowercase + ".pdf"
		      statusText = statusText + "  Precision test PDF size: " + Str(precData.Length) + " bytes" + EndOfLine
		    End If

		    result.Value("message") = statusText
		    Return result

		  #Else
		    // Premium module not enabled
		    Dim result As New Dictionary
		    Dim statusText As String = ""

		    statusText = statusText + "Example 30: E-Invoice (Factur-X/ZUGFeRD)" + EndOfLine
		    statusText = statusText + "==========================================" + EndOfLine + EndOfLine

		    statusText = statusText + "This example requires the premium E-Invoice module." + EndOfLine + EndOfLine
		    statusText = statusText + GetPremiumEnablingInstructions(Array("hasPremiumVNSEInvoiceModule")) + EndOfLine

		    statusText = statusText + "FEATURES:" + EndOfLine
		    statusText = statusText + "  - Factur-X and ZUGFeRD compliant e-invoicing" + EndOfLine
		    statusText = statusText + "  - CII (CrossIndustryInvoice) XML generation" + EndOfLine
		    statusText = statusText + "  - PDF/A-3b compliance (self-contained)" + EndOfLine
		    statusText = statusText + "  - 5 profiles: MINIMUM, BASIC WL, BASIC, EN 16931, EXTENDED" + EndOfLine
		    statusText = statusText + "  - Profile-aware validation with BT references" + EndOfLine
		    statusText = statusText + "  - sRGB ICC output intent" + EndOfLine
		    statusText = statusText + "  - No dependency on the PDF/A premium module" + EndOfLine + EndOfLine

		    statusText = statusText + "EU ViDA mandates Factur-X/ZUGFeRD for B2B invoicing." + EndOfLine

		    result.Value("message") = statusText
		    result.Value("error") = "Premium E-Invoice module not enabled"
		    Return result
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436865636B20612050444620666F72204661637475722D582F5A55474665524420652D696E766F69636520636F6E666F726D6974792E2052657475726E732044696374696F6E6172792077697468204A534F4E20726573756C742E
		Function GenerateExample31_CheckEInvoice(pdfData As String) As Dictionary
		  #If hasPremiumVNSEInvoiceModule Then
		    // Example 31: E-Invoice PDF Checker
		    // Reads an existing PDF and checks for Factur-X/ZUGFeRD conformity

		    Dim result As New Dictionary
		    Dim statusText As String = ""

		    statusText = statusText + "Example 31: E-Invoice PDF Checker" + EndOfLine
		    statusText = statusText + "==================================" + EndOfLine + EndOfLine

		    If pdfData = "" Then
		      statusText = statusText + "No PDF data provided." + EndOfLine
		      result.Value("message") = statusText
		      result.Value("error") = "No PDF data provided"
		      Return result
		    End If

		    statusText = statusText + "Reading PDF (" + Str(pdfData.Bytes) + " bytes)..." + EndOfLine

		    // Call the ReadEInvoiceFromData method
		    Dim jsonResult As JSONItem = VNSPDFEInvoicePremium.ReadEInvoiceFromData(pdfData)

		    If jsonResult = Nil Then
		      statusText = statusText + "Error: ReadEInvoiceFromData returned Nil" + EndOfLine
		      result.Value("message") = statusText
		      result.Value("error") = "ReadEInvoiceFromData returned Nil"
		      Return result
		    End If

		    // Format the JSON result nicely
		    Dim isValid As Boolean = False
		    Dim kValid As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Valid.ToString
		    If jsonResult.HasKey(kValid) Then
		      isValid = jsonResult.Value(kValid)
		    End If

		    If isValid Then
		      statusText = statusText + "VALID e-invoice found!" + EndOfLine + EndOfLine

		      Dim standard As String = ""
		      Dim kStandard As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Standard.ToString
		      If jsonResult.HasKey(kStandard) Then standard = jsonResult.Value(kStandard)
		      Dim profile As String = ""
		      Dim kProfile As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Profile.ToString
		      If jsonResult.HasKey(kProfile) Then profile = jsonResult.Value(kProfile)

		      statusText = statusText + "Standard: " + standard + EndOfLine
		      statusText = statusText + "Profile:  " + profile + EndOfLine + EndOfLine

		      // Extract invoice details
		      Dim kInvoice As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Invoice.ToString
		      If jsonResult.HasKey(kInvoice) Then
		        Dim inv As JSONItem = jsonResult.Value(kInvoice)

		        Dim kInvNum As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.InvoiceNumber.ToString
		        If inv.HasKey(kInvNum) Then
		          statusText = statusText + "Invoice Number: " + inv.Value(kInvNum).StringValue + EndOfLine
		        End If
		        Dim kInvDate As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.InvoiceDate.ToString
		        If inv.HasKey(kInvDate) Then
		          statusText = statusText + "Invoice Date:   " + inv.Value(kInvDate).StringValue + EndOfLine
		        End If
		        Dim kCurrency As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Currency.ToString
		        If inv.HasKey(kCurrency) Then
		          statusText = statusText + "Currency:       " + inv.Value(kCurrency).StringValue + EndOfLine
		        End If

		        // Seller
		        Dim kSeller As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Seller.ToString
		        If inv.HasKey(kSeller) Then
		          Dim seller As JSONItem = inv.Value(kSeller)
		          Dim kName As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Name.ToString
		          Dim kVAT As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.VATNumber.ToString
		          Dim kCity As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.City.ToString
		          Dim kCountry As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.CountryCode.ToString
		          statusText = statusText + EndOfLine + "Seller:" + EndOfLine
		          If seller.HasKey(kName) Then statusText = statusText + "  Name:    " + seller.Value(kName).StringValue + EndOfLine
		          If seller.HasKey(kVAT) Then statusText = statusText + "  VAT:     " + seller.Value(kVAT).StringValue + EndOfLine
		          If seller.HasKey(kCity) Then statusText = statusText + "  City:    " + seller.Value(kCity).StringValue + EndOfLine
		          If seller.HasKey(kCountry) Then statusText = statusText + "  Country: " + seller.Value(kCountry).StringValue + EndOfLine
		        End If

		        // Buyer
		        Dim kBuyer As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Buyer.ToString
		        If inv.HasKey(kBuyer) Then
		          Dim buyer As JSONItem = inv.Value(kBuyer)
		          Dim kName As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Name.ToString
		          Dim kVAT As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.VATNumber.ToString
		          Dim kCity As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.City.ToString
		          Dim kCountry As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.CountryCode.ToString
		          statusText = statusText + EndOfLine + "Buyer:" + EndOfLine
		          If buyer.HasKey(kName) Then statusText = statusText + "  Name:    " + buyer.Value(kName).StringValue + EndOfLine
		          If buyer.HasKey(kVAT) Then statusText = statusText + "  VAT:     " + buyer.Value(kVAT).StringValue + EndOfLine
		          If buyer.HasKey(kCity) Then statusText = statusText + "  City:    " + buyer.Value(kCity).StringValue + EndOfLine
		          If buyer.HasKey(kCountry) Then statusText = statusText + "  Country: " + buyer.Value(kCountry).StringValue + EndOfLine
		        End If

		        // Line items
		        Dim kLineItems As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.LineItems.ToString
		        If inv.HasKey(kLineItems) Then
		          Dim items As JSONItem = inv.Value(kLineItems)
		          statusText = statusText + EndOfLine + "Line Items (" + Str(items.Count) + "):" + EndOfLine
		          Dim kLineID As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.LineID.ToString
		          Dim kProdName As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.ProductName.ToString
		          Dim kQty As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Quantity.ToString
		          Dim kPrice As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.UnitPrice.ToString
		          Dim kNet As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.NetAmount.ToString
		          For i As Integer = 0 To items.Count - 1
		            Dim item As JSONItem = items.ChildAt(i)
		            Dim lineID As String = ""
		            If item.HasKey(kLineID) Then lineID = item.Value(kLineID).StringValue
		            Dim prodName As String = ""
		            If item.HasKey(kProdName) Then prodName = item.Value(kProdName).StringValue
		            Dim qty As Double = 0
		            If item.HasKey(kQty) Then qty = item.Value(kQty)
		            Dim price As Double = 0
		            If item.HasKey(kPrice) Then price = item.Value(kPrice)
		            Dim net As Double = 0
		            If item.HasKey(kNet) Then net = item.Value(kNet)
		            statusText = statusText + "  " + lineID + ": " + prodName + " (qty=" + Str(qty, "0.00") + " x " + Str(price, "0.00") + " = " + Str(net, "0.00") + ")" + EndOfLine

		            // Line-level allowances/charges
		            Dim kACs As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.AllowancesCharges.ToString
		            If item.HasKey(kACs) Then
		              Dim lineACs As JSONItem = item.Value(kACs)
		              For ai As Integer = 0 To lineACs.Count - 1
		                Dim acItem As JSONItem = lineACs.ChildAt(ai)
		                Dim acType As String
		                If acItem.Value(VNSPDFEInvoicePremium.eInvoiceJSONKey.IsCharge.ToString) Then
		                  acType = "Charge"
		                Else
		                  acType = "Allowance"
		                End If
		                Dim acAmt As String = acItem.Value(VNSPDFEInvoicePremium.eInvoiceJSONKey.Amount.ToString).StringValue
		                Dim acReason As String = ""
		                Dim kReason As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Reason.ToString
		                If acItem.HasKey(kReason) Then acReason = acItem.Value(kReason).StringValue
		                Dim acPctStr As String = ""
		                Dim kPct As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Percentage.ToString
		                If acItem.HasKey(kPct) Then acPctStr = " (" + acItem.Value(kPct).StringValue + "%)"
		                statusText = statusText + "       " + acType + ": " + acAmt + acPctStr
		                If acReason <> "" Then statusText = statusText + " - " + acReason
		                statusText = statusText + EndOfLine
		              Next
		            End If
		          Next
		        End If

		        // Document-level allowances/charges
		        Dim kDocACs As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.AllowancesCharges.ToString
		        If inv.HasKey(kDocACs) Then
		          Dim docACs As JSONItem = inv.Value(kDocACs)
		          statusText = statusText + EndOfLine + "Document Allowances/Charges (" + Str(docACs.Count) + "):" + EndOfLine
		          For i As Integer = 0 To docACs.Count - 1
		            Dim acItem As JSONItem = docACs.ChildAt(i)
		            Dim acType As String
		            If acItem.Value(VNSPDFEInvoicePremium.eInvoiceJSONKey.IsCharge.ToString) Then
		              acType = "Charge"
		            Else
		              acType = "Allowance"
		            End If
		            Dim acAmt As String = acItem.Value(VNSPDFEInvoicePremium.eInvoiceJSONKey.Amount.ToString).StringValue
		            Dim acReason As String = ""
		            Dim kReason As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Reason.ToString
		            If acItem.HasKey(kReason) Then acReason = acItem.Value(kReason).StringValue
		            statusText = statusText + "  " + acType + ": " + acAmt
		            If acReason <> "" Then statusText = statusText + " - " + acReason
		            statusText = statusText + EndOfLine
		          Next
		        End If

		        // Totals
		        statusText = statusText + EndOfLine + "Totals:" + EndOfLine
		        Dim kLineTotal As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.LineTotalAmount.ToString
		        If inv.HasKey(kLineTotal) Then
		          statusText = statusText + "  Line Total:      " + Str(inv.Value(kLineTotal).DoubleValue, "0.00") + EndOfLine
		        End If
		        Dim kAllowTotal As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.AllowanceTotalAmount.ToString
		        If inv.HasKey(kAllowTotal) Then
		          statusText = statusText + "  Allowances:     -" + Str(inv.Value(kAllowTotal).DoubleValue, "0.00") + EndOfLine
		        End If
		        Dim kChargeTotal As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.ChargeTotalAmount.ToString
		        If inv.HasKey(kChargeTotal) Then
		          statusText = statusText + "  Charges:        +" + Str(inv.Value(kChargeTotal).DoubleValue, "0.00") + EndOfLine
		        End If
		        Dim kTaxBasis As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.TaxBasisTotalAmount.ToString
		        If inv.HasKey(kTaxBasis) Then
		          statusText = statusText + "  Tax Basis:       " + Str(inv.Value(kTaxBasis).DoubleValue, "0.00") + EndOfLine
		        End If
		        Dim kTaxTotal As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.TaxTotalAmount.ToString
		        If inv.HasKey(kTaxTotal) Then
		          statusText = statusText + "  Tax Total:       " + Str(inv.Value(kTaxTotal).DoubleValue, "0.00") + EndOfLine
		        End If
		        Dim kGrandTotal As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.GrandTotalAmount.ToString
		        If inv.HasKey(kGrandTotal) Then
		          statusText = statusText + "  Grand Total:     " + Str(inv.Value(kGrandTotal).DoubleValue, "0.00") + EndOfLine
		        End If
		      End If

		      // Validate XML element ordering
		      If jsonResult.HasKey("rawXML") Then
		        Dim rawXML As String = jsonResult.Value("rawXML").StringValue
		        Dim xmlWarnings() As String = VNSPDFEInvoiceXMLParser.ValidateXMLContent(rawXML)
		        Dim orderErrors As Integer = 0
		        For i As Integer = 0 To xmlWarnings.LastIndex
		          If xmlWarnings(i).BeginsWith("EINV-E50") Then
		            statusText = statusText + EndOfLine + "XML ORDER ERROR: " + xmlWarnings(i) + EndOfLine
		            orderErrors = orderErrors + 1
		          End If
		        Next
		        If orderErrors = 0 Then
		          statusText = statusText + EndOfLine + "XML element order: OK" + EndOfLine
		        End If
		      End If

		    Else
		      statusText = statusText + "NOT a valid e-invoice." + EndOfLine + EndOfLine
		      Dim errMsg As String = ""
		      Dim kError As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Error.ToString
		      If jsonResult.HasKey(kError) Then errMsg = jsonResult.Value(kError)
		      statusText = statusText + "Reason: " + errMsg + EndOfLine
		    End If

		    // Display signature information (available for both valid and invalid invoices)
		    Dim kSigCount As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SignatureCount.ToString
		    If jsonResult.HasKey(kSigCount) Then
		      Dim sigCount As Integer = jsonResult.Value(kSigCount)
		      statusText = statusText + EndOfLine + "Digital Signatures: " + Str(sigCount) + EndOfLine
		      statusText = statusText + "-------------------" + EndOfLine

		      If sigCount > 0 Then
		        Dim kSigs As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.Signatures.ToString
		        If jsonResult.HasKey(kSigs) Then
		          Dim sigs As JSONItem = jsonResult.Value(kSigs)
		          Dim kSignerName As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SignerName.ToString
		          Dim kSigningReason As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SigningReason.ToString
		          Dim kSigningLocation As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SigningLocation.ToString
		          Dim kSigningDate As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SigningDate.ToString
		          Dim kSigFilter As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SignatureFilter.ToString
		          Dim kSigSubFilter As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SignatureSubFilter.ToString
		          Dim kSigFieldName As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SignatureFieldName.ToString
		          Dim kSigValid As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SignatureValid.ToString
		          Dim kSigCovers As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SignatureCoversWholeFile.ToString
		          Dim kSelfSigned As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.SelfSigned.ToString
		          Dim kCertSubject As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.CertificateSubject.ToString
		          Dim kCertIssuer As String = VNSPDFEInvoicePremium.eInvoiceJSONKey.CertificateIssuer.ToString

		          For si As Integer = 0 To sigs.Count - 1
		            Dim sig As JSONItem = sigs.ChildAt(si)
		            statusText = statusText + EndOfLine + "  Signature " + Str(si + 1) + ":" + EndOfLine

		            If sig.HasKey(kSignerName) Then
		              statusText = statusText + "    Signer:       " + sig.Value(kSignerName).StringValue + EndOfLine
		            End If
		            If sig.HasKey(kSigningReason) Then
		              Dim reason As String = sig.Value(kSigningReason).StringValue
		              If reason <> "" Then statusText = statusText + "    Reason:       " + reason + EndOfLine
		            End If
		            If sig.HasKey(kSigningLocation) Then
		              Dim loc As String = sig.Value(kSigningLocation).StringValue
		              If loc <> "" Then statusText = statusText + "    Location:     " + loc + EndOfLine
		            End If
		            If sig.HasKey(kSigningDate) Then
		              Dim dt As String = sig.Value(kSigningDate).StringValue
		              If dt <> "" Then statusText = statusText + "    Date:         " + dt + EndOfLine
		            End If
		            If sig.HasKey(kSigFilter) Then
		              statusText = statusText + "    Filter:       " + sig.Value(kSigFilter).StringValue + EndOfLine
		            End If
		            If sig.HasKey(kSigSubFilter) Then
		              statusText = statusText + "    SubFilter:    " + sig.Value(kSigSubFilter).StringValue + EndOfLine
		            End If
		            If sig.HasKey(kSigFieldName) Then
		              Dim fn As String = sig.Value(kSigFieldName).StringValue
		              If fn <> "" Then statusText = statusText + "    Field Name:   " + fn + EndOfLine
		            End If
		            If sig.HasKey(kSigValid) Then
		              If sig.Value(kSigValid) Then
		                statusText = statusText + "    Hash Valid:   YES (integrity verified)" + EndOfLine
		              Else
		                statusText = statusText + "    Hash Valid:   NO (file may be tampered)" + EndOfLine
		              End If
		            End If
		            If sig.HasKey(kSigCovers) Then
		              If sig.Value(kSigCovers) Then
		                statusText = statusText + "    Coverage:     Whole file" + EndOfLine
		              Else
		                statusText = statusText + "    Coverage:     Partial" + EndOfLine
		              End If
		            End If
		            If sig.HasKey(kCertSubject) Then
		              Dim subj As String = sig.Value(kCertSubject).StringValue
		              If subj <> "" Then statusText = statusText + "    Cert Subject: " + subj + EndOfLine
		            End If
		            If sig.HasKey(kCertIssuer) Then
		              Dim iss As String = sig.Value(kCertIssuer).StringValue
		              If iss <> "" Then statusText = statusText + "    Cert Issuer:  " + iss + EndOfLine
		            End If
		            If sig.HasKey(kSelfSigned) Then
		              If sig.Value(kSelfSigned) Then
		                statusText = statusText + "    Self-Signed:  YES" + EndOfLine
		              Else
		                statusText = statusText + "    Self-Signed:  NO (issued by CA)" + EndOfLine
		              End If
		            End If
		          Next
		        End If
		      Else
		        statusText = statusText + "  No digital signatures found." + EndOfLine
		      End If
		    End If

		    statusText = statusText + EndOfLine + "--- Raw JSON ---" + EndOfLine
		    statusText = statusText + jsonResult.ToString + EndOfLine

		    result.Value("message") = statusText
		    Return result

		  #Else
		    // Premium module not enabled
		    Dim result As New Dictionary
		    Dim statusText As String = ""
		    statusText = statusText + "Example 31: E-Invoice PDF Checker" + EndOfLine
		    statusText = statusText + "==================================" + EndOfLine + EndOfLine
		    statusText = statusText + "This example requires the Premium E-Invoice Module." + EndOfLine + EndOfLine
		    statusText = statusText + "The E-Invoice Checker reads existing PDF files and checks" + EndOfLine
		    statusText = statusText + "if they contain valid Factur-X/ZUGFeRD e-invoices." + EndOfLine + EndOfLine
		    statusText = statusText + "Features:" + EndOfLine
		    statusText = statusText + "  - Detect embedded CII XML attachments" + EndOfLine
		    statusText = statusText + "  - Identify standard (Factur-X/ZUGFeRD)" + EndOfLine
		    statusText = statusText + "  - Detect conformance profile" + EndOfLine
		    statusText = statusText + "  - Parse and validate invoice data" + EndOfLine
		    statusText = statusText + "  - Return structured JSON result" + EndOfLine

		    result.Value("message") = statusText
		    result.Value("error") = "Premium E-Invoice module not enabled"
		    Return result
		  #EndIf
		End Function
	#tag EndMethod


	#tag Method, Flags = &h0, Description = 4578616D706C652033323A204469676974616C205369676E61747572657320285041644553202B20584164455329202D205072656D69756D
		Function GenerateExample32(countryCode As String) As Dictionary
		  #If hasPremiumVNSEncryptionModule And hasPremiumVNSEInvoiceModule Then
		    // Example 32: Digital Signatures (PAdES-B-B + XAdES-BES)
		    // Demonstrates signing a Factur-X PDF with PAdES and XAdES
		    // countryCode: 2-letter ISO country code of the seller

		    Dim result As New Dictionary
		    Dim statusText As String = ""

		    statusText = statusText + "Example 32: Digital Signatures (PAdES + XAdES) - Country: " + countryCode + EndOfLine
		    statusText = statusText + "================================================" + EndOfLine + EndOfLine

		    // --- Step 1: Generate RSA key pair for testing ---
		    statusText = statusText + "Step 1: Generating RSA 2048-bit test key pair..." + EndOfLine

		    Dim privateKeyHex As String
		    Dim publicKeyHex As String

		    If Not Crypto.RSAGenerateKeyPair(2048, privateKeyHex, publicKeyHex) Then
		      statusText = statusText + "  ERROR: Failed to generate RSA key pair" + EndOfLine
		      result.Value("message") = statusText
		      result.Value("error") = "RSA key generation failed"
		      Return result
		    End If

		    statusText = statusText + "  RSA key pair generated successfully." + EndOfLine
		    statusText = statusText + "  Private key: " + Str(privateKeyHex.Length / 2) + " bytes" + EndOfLine
		    statusText = statusText + "  Public key:  " + Str(publicKeyHex.Length / 2) + " bytes" + EndOfLine + EndOfLine

		    // --- Step 2: Create a self-signed X.509 test certificate ---
		    statusText = statusText + "Step 2: Building self-signed X.509 test certificate..." + EndOfLine

		    // Build a minimal self-signed certificate using VNSASN1
		    Dim certDER As MemoryBlock = BuildTestCertificate(privateKeyHex, publicKeyHex)
		    If certDER Is Nil Or certDER.Size = 0 Then
		      statusText = statusText + "  ERROR: Failed to build test certificate" + EndOfLine
		      result.Value("message") = statusText
		      result.Value("error") = "Certificate generation failed"
		      Return result
		    End If

		    Dim cert As New VNSX509Certificate(certDER)
		    statusText = statusText + "  Certificate created (" + Str(certDER.Size) + " bytes DER)" + EndOfLine
		    statusText = statusText + "  Subject: " + cert.Subject + EndOfLine
		    statusText = statusText + "  Issuer:  " + cert.Issuer + EndOfLine
		    statusText = statusText + "  Valid:   " + If(cert.IsValid, "Yes", "No - " + cert.ParseError) + EndOfLine
		    statusText = statusText + "  IssuerDER: " + If(cert.IssuerDER <> Nil, Str(cert.IssuerDER.Size) + " bytes", "NIL") + EndOfLine
		    statusText = statusText + "  SerialNum: " + If(cert.SerialNumberBytes <> Nil, Str(cert.SerialNumberBytes.Size) + " bytes", "NIL") + EndOfLine

		    statusText = statusText + EndOfLine

		    // --- Step 3: Create a Factur-X invoice PDF ---
		    statusText = statusText + "Step 3: Creating Factur-X e-invoice PDF..." + EndOfLine

		    Dim invoice As New VNSPDFEInvoice
		    invoice.InvoiceNumber = "INV-2026-SIG-001"
		    invoice.InvoiceDate = DateTime.Now
		    invoice.DueDate = DateTime.Now
		    invoice.DeliveryDate = DateTime.Now
		    invoice.Currency = "EUR"
		    invoice.InvoiceTypeCode = "380"
		    invoice.BuyerReference = "PO-SIG-TEST"
		    invoice.PaymentMeansCode = "30"
		    invoice.PaymentReference = "INV-2026-SIG-001"

		    // Seller and buyer based on country
		    Dim seller As New VNSPDFEInvoiceParty
		    Dim buyer As New VNSPDFEInvoiceParty

		    Select Case countryCode
		    Case "FR"
		      invoice.IBAN = "FR7630006000011234567890189"
		      invoice.BIC = "BNPAFRPPXXX"
		      seller.Name = "VeryNiceSW SARL"
		      seller.VATNumber = "FR12345678901"
		      seller.LegalRegistrationID = "123456789"
		      seller.LegalRegistrationScheme = "0002"
		      seller.ElectronicAddress = "contact@verynicesw.com"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "42 Rue de la Paix"
		      seller.City = "Paris"
		      seller.PostalCode = "75002"
		      seller.CountryCode = "FR"
		      seller.ContactName = "Jean-Yves Pochez"
		      seller.ContactEmail = "contact@verynicesw.com"
		      buyer.Name = "Digital Trust AG"
		      buyer.VATNumber = "DE123456789"
		      buyer.ElectronicAddress = "trust@digitaltrust.ch"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "5 Bahnhofstrasse"
		      buyer.City = "Zurich"
		      buyer.PostalCode = "8001"
		      buyer.CountryCode = "CH"
		      invoice.AddNote("Digitally signed invoice - PAdES + XAdES test")
		      // BR-FR-05: AAB note (discount/early payment terms) is mandatory in France
		      invoice.AddNote("Pas d'escompte pour paiement anticipe.", "AAB")
		      invoice.AddNote("Late payment penalties: 3x the legal interest rate.", "PMD")
		      invoice.AddNote("Recovery costs for unpaid invoices: 40 EUR.", "PMT")

		    Case "DE"
		      invoice.IBAN = "DE89370400440532013000"
		      invoice.BIC = "COBADEFFXXX"
		      seller.Name = "Muster GmbH"
		      seller.VATNumber = "DE123456789"
		      seller.LegalRegistrationID = "HRB 12345"
		      seller.LegalRegistrationScheme = "0002"
		      seller.ElectronicAddress = "info@muster.de"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "15 Hauptstrasse"
		      seller.City = "Munich"
		      seller.PostalCode = "80331"
		      seller.CountryCode = "DE"
		      seller.ContactName = "Klaus Schmidt"
		      seller.ContactEmail = "info@muster.de"
		      buyer.Name = "Digital Trust AG"
		      buyer.VATNumber = "CHE123456789"
		      buyer.ElectronicAddress = "trust@digitaltrust.ch"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "5 Bahnhofstrasse"
		      buyer.City = "Zurich"
		      buyer.PostalCode = "8001"
		      buyer.CountryCode = "CH"
		      invoice.AddNote("Digitally signed invoice - PAdES + XAdES test")

		    Else
		      // Generic country
		      invoice.IBAN = "GB29NWBK60161331926819"
		      invoice.BIC = "NWBKGB2L"
		      seller.Name = "Seller Company"
		      seller.VATNumber = countryCode + "123456789"
		      seller.ElectronicAddress = "seller@example.com"
		      seller.ElectronicAddressScheme = "EM"
		      seller.AddressLine1 = "1 Main Street"
		      seller.City = "Capital City"
		      seller.PostalCode = "10000"
		      seller.CountryCode = countryCode
		      seller.ContactName = "John Doe"
		      seller.ContactEmail = "seller@example.com"
		      buyer.Name = "Digital Trust AG"
		      buyer.VATNumber = "CH123456789"
		      buyer.ElectronicAddress = "trust@digitaltrust.ch"
		      buyer.ElectronicAddressScheme = "EM"
		      buyer.AddressLine1 = "5 Bahnhofstrasse"
		      buyer.City = "Zurich"
		      buyer.PostalCode = "8001"
		      buyer.CountryCode = "CH"
		      invoice.AddNote("Digitally signed invoice - PAdES + XAdES test")

		    End Select

		    invoice.Seller = seller
		    invoice.Buyer = buyer

		    // Line items
		    Dim item1 As New VNSPDFEInvoiceLineItem
		    item1.LineID = "1"
		    item1.ProductName = "PDF Library - Encryption Premium Module"
		    item1.Quantity = 1.0
		    item1.UnitPrice = 50.0
		    item1.TaxRate = 20.0
		    item1.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    item1.UnitCode = "C62"
		    invoice.AddLineItem(item1)

		    Dim item2 As New VNSPDFEInvoiceLineItem
		    item2.LineID = "2"
		    item2.ProductName = "PDF Library - E-Invoice Premium Module"
		    item2.Quantity = 1.0
		    item2.UnitPrice = 50.0
		    item2.TaxRate = 20.0
		    item2.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    item2.UnitCode = "C62"
		    invoice.AddLineItem(item2)

		    // Tax breakdown
		    Dim tax As New VNSPDFEInvoiceTaxBreakdown
		    tax.TaxRate = 20.0
		    tax.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
		    tax.TaxableAmount = 100.0
		    tax.TaxAmount = 20.0
		    invoice.AddTaxBreakdown(tax)

		    // Create PDF with visual layout
		    Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)

		    Call pdf.SetFont("helvetica", "B", 16)
		    Call pdf.SetTextColor(0, 51, 102)
		    Call pdf.Cell(0, 12, "DIGITALLY SIGNED INVOICE", 0, 1, "C")
		    Call pdf.Ln(2)

		    Call pdf.SetFont("helvetica", "", 9)
		    Call pdf.SetTextColor(100, 100, 100)
		    Call pdf.Cell(0, 5, "PAdES-B-B (PDF) + XAdES-BES (XML) Digital Signatures Demo", 0, 1, "C")
		    Call pdf.Ln(8)

		    // Invoice details
		    Call pdf.SetTextColor(0, 0, 0)
		    Call pdf.SetFont("helvetica", "B", 10)
		    Call pdf.Cell(40, 6, "Invoice #:", 0, 0)
		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.Cell(0, 6, invoice.InvoiceNumber, 0, 1)

		    Call pdf.SetFont("helvetica", "B", 10)
		    Call pdf.Cell(40, 6, "Date:", 0, 0)
		    Call pdf.SetFont("helvetica", "", 10)
		    Dim now As DateTime = DateTime.Now
		    Call pdf.Cell(0, 6, Str(now.Year) + "-" + Str(now.Month) + "-" + Str(now.Day), 0, 1)
		    Call pdf.Ln(4)

		    // Parties
		    Call pdf.SetFont("helvetica", "B", 10)
		    Call pdf.Cell(90, 6, "FROM: " + seller.Name, 0, 0)
		    Call pdf.Cell(90, 6, "TO: " + buyer.Name, 0, 1)
		    Call pdf.SetFont("helvetica", "", 9)
		    Call pdf.Cell(90, 5, seller.AddressLine1 + ", " + seller.City, 0, 0)
		    Call pdf.Cell(90, 5, buyer.AddressLine1 + ", " + buyer.City, 0, 1)
		    Call pdf.Cell(90, 5, "VAT: " + seller.VATNumber, 0, 0)
		    Call pdf.Cell(90, 5, "VAT: " + buyer.VATNumber, 0, 1)
		    Call pdf.Ln(8)

		    // Line items table
		    Call pdf.SetFont("helvetica", "B", 9)
		    Call pdf.SetFillColor(0, 51, 102)
		    Call pdf.SetTextColor(255, 255, 255)
		    Call pdf.Cell(90, 7, "  Product", 1, 0, "L", True)
		    Call pdf.Cell(20, 7, "Qty", 1, 0, "C", True)
		    Call pdf.Cell(30, 7, "Unit Price", 1, 0, "R", True)
		    Call pdf.Cell(20, 7, "Tax %", 1, 0, "C", True)
		    Call pdf.Cell(30, 7, "Total", 1, 0, "R", True)
		    Call pdf.Ln(7)

		    Call pdf.SetFont("helvetica", "", 9)
		    Call pdf.SetTextColor(0, 0, 0)

		    Dim allItems() As VNSPDFEInvoiceLineItem = invoice.LineItems
		    For i As Integer = 0 To allItems.LastIndex
		      Dim item As VNSPDFEInvoiceLineItem = allItems(i)
		      Call pdf.Cell(90, 6, "  " + item.ProductName, 1, 0, "L")
		      Call pdf.Cell(20, 6, FormatHelper(item.Quantity, "0.##"), 1, 0, "C")
		      Call pdf.Cell(30, 6, FormatHelper(item.UnitPrice, "0.00"), 1, 0, "R")
		      Call pdf.Cell(20, 6, FormatHelper(item.TaxRate, "0.0") + "%", 1, 0, "C")
		      Call pdf.Cell(30, 6, FormatHelper(item.Quantity * item.UnitPrice, "###,##0.00"), 1, 0, "R")
		      Call pdf.Ln(6)
		    Next

		    Call pdf.Ln(3)
		    Call pdf.SetFont("helvetica", "", 10)
		    Call pdf.Cell(160, 6, "Subtotal:", 0, 0, "R")
		    Call pdf.Cell(30, 6, FormatHelper(invoice.LineTotalAmount, "###,##0.00") + " EUR", 0, 0, "R")
		    Call pdf.Ln(6)
		    Call pdf.Cell(160, 6, "VAT (20%):", 0, 0, "R")
		    Call pdf.Cell(30, 6, FormatHelper(invoice.TaxTotalAmount, "###,##0.00") + " EUR", 0, 0, "R")
		    Call pdf.Ln(6)
		    Call pdf.SetFont("helvetica", "B", 11)
		    Call pdf.Cell(160, 8, "TOTAL:", 0, 0, "R")
		    Call pdf.Cell(30, 8, FormatHelper(invoice.GrandTotalAmount, "###,##0.00") + " EUR", 0, 0, "R")
		    Call pdf.Ln(8)

		    // Signature info box
		    Call pdf.Ln(10)
		    Call pdf.SetDrawColor(0, 128, 0)
		    Call pdf.SetFillColor(240, 255, 240)
		    Call pdf.Rect(pdf.GetX(), pdf.GetY(), 190, 30, "FD")
		    Call pdf.SetFont("helvetica", "B", 10)
		    Call pdf.SetTextColor(0, 100, 0)
		    Call pdf.Cell(0, 8, "  DIGITAL SIGNATURE INFORMATION", 0, 1)
		    Call pdf.SetFont("helvetica", "", 8)
		    Call pdf.Cell(0, 5, "  This PDF is signed with PAdES-B-B (PKCS#7 detached signature)", 0, 1)
		    Call pdf.Cell(0, 5, "  The embedded CII XML is signed with XAdES-BES (enveloped XML signature)", 0, 1)
		    Call pdf.Cell(0, 5, "  Signer: VNS PDF Test Signer | Algorithm: RSA-SHA256 | Key: 2048-bit", 0, 1)
		    Call pdf.SetTextColor(0, 0, 0)
		    Call pdf.Ln(4)
		    Call pdf.SetFont("helvetica", "B", 8)
		    Call pdf.SetTextColor(100, 100, 100)
		    Call pdf.Cell(0, 5, "This invoice is Factur-X EN 16931 compliant (PDF/A-3b with embedded CII XML)", 0, 1, "C")
		    Call pdf.Cell(0, 5, "Conforms to " + EInvoiceNormForCountry(countryCode), 0, 1, "C")
		    Call pdf.SetTextColor(0, 0, 0)

		    If pdf.Err() Then
		      statusText = statusText + "  Error creating PDF: " + pdf.GetError() + EndOfLine
		      result.Value("error") = pdf.GetError()
		      result.Value("message") = statusText
		      Return result
		    End If

		    statusText = statusText + "  Visual invoice layout created." + EndOfLine + EndOfLine

		    // --- Step 4: Apply Factur-X compliance ---
		    statusText = statusText + "Step 4: Applying Factur-X compliance..." + EndOfLine

		    VNSPDFEInvoicePremium.CreateFacturXInvoice(pdf, invoice, VNSPDFEInvoicePremium.eFacturXProfile.EN16931)

		    If pdf.Err() Then
		      statusText = statusText + "  Error: " + pdf.GetError() + EndOfLine
		      result.Value("error") = pdf.GetError()
		      result.Value("message") = statusText
		      Return result
		    End If

		    statusText = statusText + "  Factur-X EN 16931 compliance applied." + EndOfLine + EndOfLine

		    // --- Step 5: Generate unsigned PDF ---
		    statusText = statusText + "Step 5: Generating PDF output..." + EndOfLine
		    Dim pdfData As String = pdf.Output()

		    If pdf.Err() Then
		      statusText = statusText + "  Error: " + pdf.GetError() + EndOfLine
		      result.Value("error") = pdf.GetError()
		      result.Value("message") = statusText
		      Return result
		    End If

		    statusText = statusText + "  Unsigned PDF: " + Str(pdfData.Length) + " bytes" + EndOfLine + EndOfLine

		    // --- Step 6: Sign PDF with PAdES-B-B ---
		    statusText = statusText + "Step 6: Signing PDF with PAdES-B-B..." + EndOfLine
		    statusText = statusText + "  Algorithm: sha256WithRSAEncryption (PKCS#1 v1.5)" + EndOfLine
		    statusText = statusText + "  CMS structure: PKCS#7 detached SignedData" + EndOfLine

		    Dim signedPdf As String = VNSPDFSignature.SignPDF(pdfData, cert, privateKeyHex, _
		      "Invoice authenticity and integrity", "Paris, France")

		    If signedPdf = "" Then
		      statusText = statusText + "  WARNING: PAdES signing returned empty result." + EndOfLine
		      statusText = statusText + "  This may be due to RSA key format issues." + EndOfLine
		      statusText = statusText + "  Using unsigned PDF for output." + EndOfLine + EndOfLine
		      // Fall back to unsigned PDF
		      signedPdf = pdfData
		    Else
		      statusText = statusText + "  PAdES-B-B signature applied!" + EndOfLine
		      statusText = statusText + "  Signed PDF: " + Str(signedPdf.Length) + " bytes" + EndOfLine
		      statusText = statusText + "  Size increase: " + Str(signedPdf.Length - pdfData.Length) + " bytes (signature overhead)" + EndOfLine + EndOfLine

		      // Verify signature structure
		      If signedPdf.IndexOf("/Type /Sig") >= 0 Then
		        statusText = statusText + "  STRUCTURE CHECK:" + EndOfLine
		        statusText = statusText + "    /Type /Sig dictionary: PRESENT" + EndOfLine
		        statusText = statusText + "    /Filter /Adobe.PPKLite: " + If(signedPdf.IndexOf("/Adobe.PPKLite") >= 0, "PRESENT", "MISSING") + EndOfLine
		        statusText = statusText + "    /SubFilter /adbe.pkcs7.detached: " + If(signedPdf.IndexOf("/adbe.pkcs7.detached") >= 0, "PRESENT", "MISSING") + EndOfLine
		        statusText = statusText + "    /ByteRange: " + If(signedPdf.IndexOf("/ByteRange") >= 0, "PRESENT", "MISSING") + EndOfLine
		        statusText = statusText + "    /AcroForm /SigFlags: " + If(signedPdf.IndexOf("/SigFlags 3") >= 0, "PRESENT", "MISSING") + EndOfLine

		        // Extract and display ByteRange values
		        Dim brPos As Integer = signedPdf.IndexOf("/ByteRange [")
		        If brPos >= 0 Then
		          Dim brEnd As Integer = signedPdf.IndexOf(brPos, "]")
		          If brEnd >= 0 Then
		            Dim brValue As String = signedPdf.Middle(brPos, brEnd - brPos + 1).DefineEncoding(Encodings.UTF8)
		            statusText = statusText + "    ByteRange value: " + brValue + EndOfLine
		          End If
		        End If
		      End If
		      statusText = statusText + EndOfLine
		    End If

		    // --- Step 7: XAdES-BES XML signing demo ---
		    statusText = statusText + "Step 7: XAdES-BES XML signing demo..." + EndOfLine

		    // Create a sample CII XML to sign
		    Dim sampleXML As String = "<?xml version=""1.0"" encoding=""UTF-8""?>" + Chr(10)
		    sampleXML = sampleXML + "<rsm:CrossIndustryInvoice xmlns:rsm=""urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"">" + Chr(10)
		    sampleXML = sampleXML + "  <rsm:ExchangedDocumentContext>" + Chr(10)
		    sampleXML = sampleXML + "    <ram:GuidelineSpecifiedDocumentContextParameter xmlns:ram=""urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"">" + Chr(10)
		    sampleXML = sampleXML + "      <ram:ID>urn:cen.eu:en16931:2017</ram:ID>" + Chr(10)
		    sampleXML = sampleXML + "    </ram:GuidelineSpecifiedDocumentContextParameter>" + Chr(10)
		    sampleXML = sampleXML + "  </rsm:ExchangedDocumentContext>" + Chr(10)
		    sampleXML = sampleXML + "</rsm:CrossIndustryInvoice>"

		    Dim signedXML As String = VNSXAdESSigner.SignXML(sampleXML, cert, privateKeyHex)

		    If signedXML = "" Then
		      statusText = statusText + "  WARNING: XAdES signing returned empty result." + EndOfLine
		      statusText = statusText + "  This may be due to RSA key format issues." + EndOfLine + EndOfLine
		    Else
		      statusText = statusText + "  XAdES-BES signature applied!" + EndOfLine
		      statusText = statusText + "  Original XML:  " + Str(sampleXML.Length) + " bytes" + EndOfLine
		      statusText = statusText + "  Signed XML:    " + Str(signedXML.Length) + " bytes" + EndOfLine + EndOfLine

		      // Verify signature elements
		      statusText = statusText + "  VERIFICATION:" + EndOfLine
		      statusText = statusText + "    ds:Signature element: " + If(signedXML.IndexOf("<ds:Signature") >= 0, "PRESENT", "MISSING") + EndOfLine
		      statusText = statusText + "    ds:SignedInfo: " + If(signedXML.IndexOf("<ds:SignedInfo") >= 0, "PRESENT", "MISSING") + EndOfLine
		      statusText = statusText + "    ds:SignatureValue: " + If(signedXML.IndexOf("<ds:SignatureValue>") >= 0, "PRESENT", "MISSING") + EndOfLine
		      statusText = statusText + "    ds:X509Certificate: " + If(signedXML.IndexOf("<ds:X509Certificate>") >= 0, "PRESENT", "MISSING") + EndOfLine
		      statusText = statusText + "    xades:SignedProperties: " + If(signedXML.IndexOf("<xades:SignedProperties") >= 0, "PRESENT", "MISSING") + EndOfLine
		      statusText = statusText + "    xades:SigningCertificate: " + If(signedXML.IndexOf("<xades:SigningCertificate>") >= 0, "PRESENT", "MISSING") + EndOfLine
		      statusText = statusText + EndOfLine
		    End If

		    // --- Summary ---
		    statusText = statusText + "SUMMARY" + EndOfLine
		    statusText = statusText + "=======" + EndOfLine
		    statusText = statusText + "PAdES-B-B: Signs the entire PDF binary (PKCS#7 detached)" + EndOfLine
		    statusText = statusText + "  -> Proves the PDF document has not been tampered with" + EndOfLine
		    statusText = statusText + "  -> Verifiable in Adobe Acrobat Reader signature panel" + EndOfLine + EndOfLine
		    statusText = statusText + "XAdES-BES: Signs the embedded CII XML (enveloped signature)" + EndOfLine
		    statusText = statusText + "  -> Proves the invoice data has not been tampered with" + EndOfLine
		    statusText = statusText + "  -> Verifiable with xmlsec1 or similar XML signature tools" + EndOfLine + EndOfLine
		    statusText = statusText + "NOTE: This demo uses a self-signed test certificate." + EndOfLine
		    statusText = statusText + "For production use, provide a CA-issued certificate" + EndOfLine
		    statusText = statusText + "or a qualified certificate (QES) for legal compliance." + EndOfLine

		    result.Value("pdf") = signedPdf
		    result.Value("filename") = "example32_digital_signatures_" + countryCode.Lowercase + ".pdf"
		    result.Value("message") = statusText
		    Return result

		  #ElseIf hasPremiumVNSEncryptionModule Then
		    // Only encryption module - no e-invoice
		    Dim result As New Dictionary
		    Dim statusText As String = ""
		    statusText = statusText + "Example 32: Digital Signatures (PAdES + XAdES)" + EndOfLine
		    statusText = statusText + "================================================" + EndOfLine + EndOfLine
		    statusText = statusText + "This example requires both premium modules:" + EndOfLine
		    statusText = statusText + "  - Encryption Module (for PAdES/XAdES signing)" + EndOfLine
		    statusText = statusText + "  - E-Invoice Module (for Factur-X PDF generation)" + EndOfLine + EndOfLine
		    statusText = statusText + "The Encryption Module is enabled but E-Invoice Module is not." + EndOfLine + EndOfLine
		    statusText = statusText + GetPremiumEnablingInstructions(Array("hasPremiumVNSEInvoiceModule")) + EndOfLine
		    result.Value("message") = statusText
		    result.Value("error") = "Premium E-Invoice module not enabled"
		    Return result

		  #Else
		    // No premium modules
		    Dim result As New Dictionary
		    Dim statusText As String = ""
		    statusText = statusText + "Example 32: Digital Signatures (PAdES + XAdES)" + EndOfLine
		    statusText = statusText + "================================================" + EndOfLine + EndOfLine
		    statusText = statusText + "This example requires the premium Encryption and E-Invoice modules." + EndOfLine + EndOfLine
		    statusText = statusText + "DIGITAL SIGNATURES OVERVIEW:" + EndOfLine
		    statusText = statusText + "=============================" + EndOfLine
		    statusText = statusText + "PAdES-B-B (PDF Advanced Electronic Signatures):" + EndOfLine
		    statusText = statusText + "  - Signs the entire PDF binary with PKCS#7/CMS" + EndOfLine
		    statusText = statusText + "  - Proves the PDF has not been tampered with" + EndOfLine
		    statusText = statusText + "  - Verified in Adobe Acrobat Reader" + EndOfLine + EndOfLine
		    statusText = statusText + "XAdES-BES (XML Advanced Electronic Signatures):" + EndOfLine
		    statusText = statusText + "  - Signs the embedded CII XML invoice data" + EndOfLine
		    statusText = statusText + "  - Proves the invoice data has not been tampered with" + EndOfLine
		    statusText = statusText + "  - Includes SigningCertificate in signed properties" + EndOfLine + EndOfLine
		    statusText = statusText + GetPremiumEnablingInstructions(Array("hasPremiumVNSEncryptionModule", "hasPremiumVNSEInvoiceModule")) + EndOfLine
		    result.Value("message") = statusText
		    result.Value("error") = "Premium modules not enabled"
		    Return result
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4275696C64206120736B656C6574616C2073656C662D7369676E656420582E353039207465737420636572746966696361746520666F722064656D6F20707572706F7365732E
		Private Function BuildTestCertificate(privateKeyHex As String, publicKeyHex As String) As MemoryBlock
		  #If hasPremiumVNSEncryptionModule Then
		  // Build a minimal self-signed X.509 certificate for testing
		  // This is NOT a production-quality certificate generator
		  // For production, use openssl or a CA-issued certificate

		  // TBSCertificate structure:
		  // SEQUENCE {
		  //   [0] version (v3 = 2)
		  //   serialNumber INTEGER
		  //   signature AlgorithmIdentifier (sha256WithRSAEncryption)
		  //   issuer Name
		  //   validity { notBefore, notAfter }
		  //   subject Name
		  //   subjectPublicKeyInfo
		  // }

		  // Version [0] EXPLICIT INTEGER 2 (v3)
		  Dim versionInt As MemoryBlock = VNSASN1.EncodeInteger(2)
		  Dim version As MemoryBlock = VNSASN1.EncodeContextTag(0, versionInt)

		  // Serial number - random 8 bytes
		  Dim serialMB As New MemoryBlock(8)
		  For i As Integer = 0 To 7
		    serialMB.Byte(i) = CType(Rnd * 256, Byte)
		  Next
		  serialMB.Byte(0) = serialMB.Byte(0) And &h7F  // Ensure positive
		  If serialMB.Byte(0) = 0 Then serialMB.Byte(0) = 1
		  Dim serialNumber As MemoryBlock = VNSASN1.EncodeIntegerFromBytes(serialMB)

		  // Signature algorithm: sha256WithRSAEncryption (PKCS#1 v1.5)
		  // OID: 1.2.840.113549.1.1.11, parameters NULL
		  Dim rsaSha256OID As MemoryBlock = VNSASN1.EncodeOID("1.2.840.113549.1.1.11")
		  Dim nullParam As MemoryBlock = VNSASN1.EncodeNull()
		  Dim signatureAlg As MemoryBlock = VNSASN1.EncodeSequence( _
		    VNSASN1.ConcatMemoryBlocks(rsaSha256OID, nullParam))

		  // Issuer and Subject: CN=VNS PDF Test Signer, O=VeryniceSW, C=FR
		  Dim issuerSubject As MemoryBlock = BuildX509Name("VNS PDF Test Signer", "VeryniceSW", "FR")

		  // Validity: now to now + 10 years
		  Dim now As DateTime = DateTime.Now
		  Dim notBeforeTime As MemoryBlock = VNSASN1.EncodeUTCTime(now)
		  // Create a date 10 years from now
		  Dim futureDate As New DateTime(now.Year + 10, now.Month, now.Day, now.Hour, now.Minute, now.Second)
		  Dim notAfterTime As MemoryBlock = VNSASN1.EncodeUTCTime(futureDate)
		  Dim validity As MemoryBlock = VNSASN1.EncodeSequence( _
		    VNSASN1.ConcatMemoryBlocks(notBeforeTime, notAfterTime))

		  // SubjectPublicKeyInfo - use the hex public key from Crypto
		  Dim pubKeyBytes As MemoryBlock = VNSASN1.HexToBytes(publicKeyHex)
		  // The public key from Crypto.RSAGenerateKeyPair is already DER-encoded SPKI
		  // Wrap it as-is since it's already a valid SubjectPublicKeyInfo

		  // Build TBSCertificate
		  Dim tbsContent As MemoryBlock = VNSASN1.ConcatMemoryBlocks( _
		    version, serialNumber, signatureAlg, issuerSubject, validity, issuerSubject, pubKeyBytes)
		  Dim tbsCertificate As MemoryBlock = VNSASN1.EncodeSequence(tbsContent)

		  // Sign the TBSCertificate using pure Xojo PKCS#1 v1.5
		  // VNSRSASigner.SignPKCS1v15 hashes with SHA-256 internally
		  Dim keyDER As MemoryBlock = VNSASN1.HexToBytes(privateKeyHex)
		  Dim tbsSignature As MemoryBlock = VNSRSASigner.SignPKCS1v15(tbsCertificate, keyDER)

		  If tbsSignature Is Nil Then
		    // RSA signing failed
		    Return Nil
		  End If

		  // Build complete certificate
		  Dim signatureBitString As MemoryBlock = VNSASN1.EncodeBitString(tbsSignature)
		  Dim certContent As MemoryBlock = VNSASN1.ConcatMemoryBlocks( _
		    tbsCertificate, signatureAlg, signatureBitString)

		  Return VNSASN1.EncodeSequence(certContent)
		  #Else
		    #Pragma Unused privateKeyHex
		    #Pragma Unused publicKeyHex
		    Return Nil
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BuildX509Name(commonName As String, organization As String, country As String) As MemoryBlock
		  #If hasPremiumVNSEncryptionModule Then
		  // Build an X.509 Name: SEQUENCE of SET of SEQUENCE of { OID, value }

		  // CN (2.5.4.3)
		  Dim cnOID As MemoryBlock = VNSASN1.EncodeOID("2.5.4.3")
		  Dim cnValue As MemoryBlock = VNSASN1.EncodeUTF8String(commonName)
		  Dim cnAttr As MemoryBlock = VNSASN1.EncodeSequence(VNSASN1.ConcatMemoryBlocks(cnOID, cnValue))
		  Dim cnSet As MemoryBlock = VNSASN1.EncodeSet(cnAttr)

		  // O (2.5.4.10)
		  Dim oOID As MemoryBlock = VNSASN1.EncodeOID("2.5.4.10")
		  Dim oValue As MemoryBlock = VNSASN1.EncodeUTF8String(organization)
		  Dim oAttr As MemoryBlock = VNSASN1.EncodeSequence(VNSASN1.ConcatMemoryBlocks(oOID, oValue))
		  Dim oSet As MemoryBlock = VNSASN1.EncodeSet(oAttr)

		  // C (2.5.4.6)
		  Dim cOID As MemoryBlock = VNSASN1.EncodeOID("2.5.4.6")
		  Dim cValue As MemoryBlock = VNSASN1.EncodePrintableString(country)
		  Dim cAttr As MemoryBlock = VNSASN1.EncodeSequence(VNSASN1.ConcatMemoryBlocks(cOID, cValue))
		  Dim cSet As MemoryBlock = VNSASN1.EncodeSet(cAttr)

		  Return VNSASN1.EncodeSequence(VNSASN1.ConcatMemoryBlocks(cSet, oSet, cnSet))
		  #Else
		    #Pragma Unused commonName
		    #Pragma Unused organization
		    #Pragma Unused country
		    Return Nil
		  #EndIf
		End Function
	#tag EndMethod


	#tag Method, Flags = &h0, Description = 4578616D706C652033333A20426172636F646573202D20515220436F64652C20436F64653132382C2045414E2D31332C2045414E2D382C205550432D412C20436F64652033392C204954462C20436F64616261722C20446174614D61747269782C20504446343137
		Function GenerateExample33_Barcodes() As Dictionary
		  // Example 33: Barcodes
		  // Demonstrates free QR/Code128 (Xojo built-in) and premium barcode types

		  Dim result As New Dictionary
		  Dim statusText As String = "Generating Example 33: Barcodes..." + EndOfLine

		  Try
		    Dim pdf As New VNSPDFDocument()
		    pdf.Title = "Example 33 - Barcodes"
		    pdf.Author = "VNS PDF Examples"
		    pdf.SetFont("Helvetica", "", 16)

		    // ========== PAGE 1: Free Barcodes (Xojo built-in) ==========
		    pdf.SetTextColor(0, 0, 102)
		    pdf.Cell(0, 10, "Page 1: Free Barcodes (Xojo Built-in)", 0, 2, "L")
		    pdf.SetFont("Helvetica", "", 10)
		    pdf.SetTextColor(51, 51, 51)
		    pdf.Cell(0, 6, "Uses Xojo Barcode.Image() - Desktop, Web, iOS only (not Console)", 0, 2, "L")
		    pdf.Ln(5)

		    // QR Code
		    pdf.SetFont("Helvetica", "B", 12)
		    pdf.SetTextColor(0, 0, 0)
		    pdf.Cell(0, 8, "QR Code", 0, 2, "L")
		    pdf.SetFont("Helvetica", "", 9)
		    pdf.Cell(0, 5, "Value: https://verynice.software", 0, 2, "L")

		    #If TargetDesktop Or TargetWeb Or TargetiOS Then
		      pdf.DrawQRCode(pdf.GetX(), pdf.GetY() + 2, 40, "https://verynice.software")
		      If pdf.Err() Then
		        statusText = statusText + "DrawQRCode error: " + pdf.GetError() + EndOfLine
		        pdf.ClearError()
		      Else
		        statusText = statusText + "QR Code drawn successfully" + EndOfLine
		      End If
		    #Else
		      pdf.Cell(0, 8, "[QR Code: Xojo Barcode class not available on Console - use premium VNSPDFBarcode module]", 0, 2, "L")
		    #EndIf

		    pdf.SetY(pdf.GetY() + 45)

		    // Code128
		    pdf.SetFont("Helvetica", "B", 12)
		    pdf.Cell(0, 8, "Code 128", 0, 2, "L")
		    pdf.SetFont("Helvetica", "", 9)
		    pdf.Cell(0, 5, "Value: VNS-PDF-2026", 0, 2, "L")

		    #If TargetDesktop Or TargetWeb Or TargetiOS Then
		      pdf.DrawCode128(pdf.GetX(), pdf.GetY() + 2, 80, 25, "VNS-PDF-2026")
		      If pdf.Err() Then
		        statusText = statusText + "DrawCode128 error: " + pdf.GetError() + EndOfLine
		        pdf.ClearError()
		      Else
		        statusText = statusText + "Code128 drawn successfully" + EndOfLine
		      End If
		    #Else
		      pdf.Cell(0, 8, "[Code128: Xojo Barcode class not available on Console - use premium VNSPDFBarcode module]", 0, 2, "L")
		    #EndIf

		    // ========== PAGE 2: Premium 1D Barcodes ==========
		    #If hasPremiumVNSEInvoiceModule Then
		      Dim leftM As Double = pdf.GetLeftMargin()

		      pdf.AddPage()
		      pdf.SetFont("Helvetica", "", 16)
		      pdf.SetTextColor(0, 0, 102)
		      pdf.Cell(0, 10, "Page 2: Premium 1D Barcodes (Pure Xojo)", 0, 2, "L")
		      pdf.SetFont("Helvetica", "", 10)
		      pdf.SetTextColor(51, 51, 51)
		      pdf.Cell(0, 6, "Works on all platforms including Console - part of E-Invoice premium module", 0, 2, "L")
		      pdf.Ln(5)

		      // EAN-13
		      pdf.SetFont("Helvetica", "B", 11)
		      pdf.SetTextColor(0, 0, 0)
		      pdf.Cell(90, 7, "EAN-13: 4006381333931", 0, 0, "L")
		      pdf.Cell(0, 7, "EAN-8: 96385074", 0, 2, "L")
		      pdf.SetX(leftM)

		      Dim ean13Y As Double = pdf.GetY()
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.EAN13, leftM, ean13Y, 60, 25, "4006381333931")
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.EAN8, leftM + 90, ean13Y, 50, 25, "96385074")

		      pdf.SetY(ean13Y + 30)

		      // UPC-A
		      pdf.SetFont("Helvetica", "B", 11)
		      pdf.Cell(90, 7, "UPC-A: 012345678905", 0, 0, "L")
		      pdf.Cell(0, 7, "Code 39: HELLO-2026", 0, 2, "L")
		      pdf.SetX(leftM)

		      Dim upcY As Double = pdf.GetY()
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.UPCA, leftM, upcY, 60, 25, "012345678905")
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.Code39, leftM + 90, upcY, 80, 25, "HELLO-2026")

		      pdf.SetY(upcY + 30)

		      // ITF and Codabar
		      pdf.SetFont("Helvetica", "B", 11)
		      pdf.Cell(90, 7, "ITF: 1234567890", 0, 0, "L")
		      pdf.Cell(0, 7, "Codabar: 31117013206375", 0, 2, "L")
		      pdf.SetX(leftM)

		      Dim itfY As Double = pdf.GetY()
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.ITF, leftM, itfY, 60, 25, "1234567890")
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.Codabar, leftM + 90, itfY, 80, 25, "31117013206375")

		      // Pure Xojo QR and Code128 (works on Console too)
		      pdf.SetY(itfY + 35)
		      pdf.SetFont("Helvetica", "B", 11)
		      pdf.Cell(90, 7, "QR Code (Pure Xojo)", 0, 0, "L")
		      pdf.Cell(0, 7, "Code128 (Pure Xojo)", 0, 2, "L")
		      pdf.SetX(leftM)

		      Dim pureY As Double = pdf.GetY()
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.QRCode, leftM, pureY, 35, 35, "https://verynice.software")
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.Code128, leftM + 90, pureY, 80, 25, "VNS-PREMIUM-2026")

		      // Xojo Core QR and Code128 (built-in Barcode class - Desktop, Web, iOS only)
		      #If TargetDesktop Or TargetWeb Or TargetiOS Then
		        pdf.SetY(pureY + 40)
		        pdf.SetFont("Helvetica", "B", 11)
		        pdf.Cell(90, 7, "QR Code (Xojo Core)", 0, 0, "L")
		        pdf.Cell(0, 7, "Code128 (Xojo Core)", 0, 2, "L")
		        pdf.SetX(leftM)

		        Dim coreY As Double = pdf.GetY()
		        pdf.DrawQRCode(leftM, coreY, 35, "https://verynice.software")
		        If pdf.Err() Then
		          statusText = statusText + "Core QR error: " + pdf.GetError() + EndOfLine
		          pdf.ClearError()
		        End If
		        pdf.DrawCode128(leftM + 90, coreY, 80, 25, "VNS-PREMIUM-2026")
		        If pdf.Err() Then
		          statusText = statusText + "Core Code128 error: " + pdf.GetError() + EndOfLine
		          pdf.ClearError()
		        End If
		      #EndIf

		      statusText = statusText + "Premium 1D barcodes drawn successfully" + EndOfLine

		      // ========== PAGE 3: Premium 2D Barcodes ==========
		      pdf.AddPage()
		      pdf.SetFont("Helvetica", "", 16)
		      pdf.SetTextColor(0, 0, 102)
		      pdf.Cell(0, 10, "Page 3: Premium 2D Barcodes (Pure Xojo)", 0, 2, "L")
		      pdf.SetFont("Helvetica", "", 10)
		      pdf.SetTextColor(51, 51, 51)
		      pdf.Cell(0, 6, "DataMatrix and PDF417 - works on all platforms", 0, 2, "L")
		      pdf.Ln(5)

		      // DataMatrix
		      pdf.SetFont("Helvetica", "B", 11)
		      pdf.SetTextColor(0, 0, 0)
		      pdf.Cell(0, 7, "DataMatrix: VNSTEST123", 0, 2, "L")

		      Dim dmY As Double = pdf.GetY()
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.DataMatrix, leftM, dmY + 2, 35, 35, "VNSTEST123")

		      pdf.SetY(dmY + 42)

		      // PDF417
		      pdf.SetFont("Helvetica", "B", 11)
		      pdf.Cell(0, 7, "PDF417: VNS PDF Library - Barcode Module", 0, 2, "L")

		      Dim pdf417Y As Double = pdf.GetY()
		      VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.PDF417, leftM, pdf417Y + 2, 120, 40, "VNS PDF Library - Barcode Module")

		      statusText = statusText + "Premium 2D barcodes drawn successfully" + EndOfLine

		      // ========== PAGE 4: Barcodes in Table Cells ==========
		      pdf.AddPage()
		      pdf.SetFont("Helvetica", "", 16)
		      pdf.SetTextColor(0, 0, 102)
		      pdf.Cell(0, 10, "Page 4: Barcodes in Table Cells", 0, 2, "L")
		      pdf.SetFont("Helvetica", "", 10)
		      pdf.SetTextColor(51, 51, 51)
		      pdf.Cell(0, 6, "Product table with embedded QR codes and EAN-13 barcodes", 0, 2, "L")
		      pdf.Ln(5)

		      // Table header
		      pdf.SetFont("Helvetica", "B", 10)
		      pdf.SetFillColor(200, 220, 255)
		      pdf.SetTextColor(0, 0, 0)
		      pdf.Cell(50, 8, "Product", 1, 0, "C", True)
		      pdf.Cell(40, 8, "SKU", 1, 0, "C", True)
		      pdf.Cell(35, 8, "QR Code", 1, 0, "C", True)
		      pdf.Cell(55, 8, "EAN-13", 1, 2, "C", True)
		      pdf.SetX(leftM)

		      // Table rows with barcodes
		      Dim products() As String = Array("Widget A", "Gadget B", "Module C")
		      Dim skus() As String = Array("WID-001", "GAD-002", "MOD-003")
		      Dim eans() As String = Array("4006381333931", "5901234123457", "8710398512345")
		      Dim rowHeight As Double = 22

		      pdf.SetFont("Helvetica", "", 9)
		      For i As Integer = 0 To 2
		        Dim rowY As Double = pdf.GetY()
		        Dim rowX As Double = leftM

		        pdf.Cell(50, rowHeight, products(i), 1, 0, "L")
		        pdf.Cell(40, rowHeight, skus(i), 1, 0, "C")
		        pdf.Cell(35, rowHeight, "", 1, 0, "C") // Empty cell for QR
		        pdf.Cell(55, rowHeight, "", 1, 2, "C") // Empty cell for EAN
		        pdf.SetX(leftM)

		        // Draw QR code in the QR cell
		        VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.QRCode, rowX + 93, rowY + 1, 18, 18, skus(i))
		        // Draw EAN-13 in the EAN cell
		        VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.EAN13, rowX + 127, rowY + 2, 50, 18, eans(i))
		      Next

		      statusText = statusText + "Barcodes in table cells drawn successfully" + EndOfLine
		    #Else
		      statusText = statusText + "Premium barcode types require E-Invoice module" + EndOfLine
		    #EndIf

		    // Generate PDF
		    Dim pdfData As String = pdf.Output()

		    If pdf.Error <> "" Then
		      statusText = statusText + "Error: " + pdf.Error + EndOfLine
		      result.Value("error") = pdf.Error
		    Else
		      Dim pageCount As Integer = 1
		      #If hasPremiumVNSEInvoiceModule Then
		        pageCount = 4
		      #EndIf
		      statusText = statusText + "Success! PDF generated with " + Str(pageCount) + " pages." + EndOfLine
		      result.Value("pdf") = pdfData
		      result.Value("filename") = "example33_barcodes.pdf"
		    End If

		  Catch e As RuntimeException
		    statusText = statusText + "Exception: " + e.Message + EndOfLine
		    result.Value("error") = e.Message
		  End Try

		  result.Value("message") = statusText
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E7320746865206E616D65206F662074686520652D696E766F696365206E6F726D20666F72206120676976656E20636F756E74727920636F64652E
		Protected Function EInvoiceNormForCountry(countryCode As String) As String
		  Select Case countryCode.Uppercase
		  Case "FR"
		    Return "Factur-X (FNFE-MPE) French e-invoicing norms"
		  Case "DE"
		    Return "XRechnung (KoSIT) German e-invoicing norms"
		  Case "IT"
		    Return "FatturaPA / CIUS-IT (AgID) Italian e-invoicing norms"
		  Case "NL"
		    Return "NLCIUS Dutch e-invoicing norms"
		  Case "ES"
		    Return "FacturaE Spanish e-invoicing norms"
		  Case "BE"
		    Return "e-FFF / UBL.BE Belgian e-invoicing norms"
		  Case "AT"
		    Return "ebInterface Austrian e-invoicing norms"
		  Case "PT"
		    Return "CIUS-PT Portuguese e-invoicing norms"
		  Else
		    Return "EN 16931 European e-invoicing standard"
		  End Select
		End Function
	#tag EndMethod


	#tag Constant, Name = gkLanguageTest, Type = String, Dynamic = False, Default = \"Abkhaz: \xD0\x91\xD0\xB7\xD0\xB8\xD0\xB0 \xD0\xB7\xD0\xB1\xD0\xB0\xD1\x88\xD0\xB0\nAcehnese: Salam dunia\nAcholi: Oyaa lobo\nAfar: Salaam duniya\nAfrikaans: Hallo W\xC3\xAAreld\nAlbanian: P\xC3\xABrsh\xC3\xABndetje Bot\xC3\xAB\nAlur: Ot lobo\nAmharic: \xE1\x88\xB0\xE1\x88\x8B\xE1\x88\x9D \xE1\x88\x8D\xE1\x8B\x91\xE1\x88\x8D\nArabic: \xD9\x85\xD8\xB1\xD8\xAD\xD8\xA8\xD8\xA7 \xD8\xA8\xD8\xA7\xD9\x84\xD8\xB9\xD8\xA7\xD9\x84\xD9\x85\nArmenian: \xD4\xB2\xD5\xA1\xD6\x80\xD5\xA5\xD6\x82 \xD5\xA1\xD5\xB7\xD5\xAD\xD5\xA1\xD6\x80\xD5\xB0\nAzerbaijani: Salam d\xC3\xBCnya\nAssamese: \xE0\xA6\xA8\xE0\xA6\xAE\xE0\xA6\xB8\xE0\xA7\x8D\xE0\xA6\x95\xE0\xA6\xBE\xE0\xA7\xB0 \xE0\xA6\xAA\xE0\xA7\x83\xE0\xA6\xA5\xE0\xA6\xBF\xE0\xA7\xB1\xE0\xA7\x80\nAwadhi: \xE0\xA4\xAA\xE0\xA5\x8D\xE0\xA4\xB0\xE0\xA4\xA3\xE0\xA4\xBE\xE0\xA4\xAE \xE0\xA4\xA6\xE0\xA5\x81\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xAF\xE0\xA4\xBE\nAvar: \xD0\xA1\xD0\xB0\xD0\xBB\xD0\xB0\xD0\xBC \xD0\xB4\xD1\x83\xD0\xBD\xD1\x8F\xD0\xBB\nAymara: Kamisaraki uraqpach\nBalinese: Halo jagat\nBambara: Aw ni tile di\xC9\xB2\xC9\x9B\nBaoul\xC3\xA9: Ilafia n\'goua\nBashkir: \xD0\xA1\xD3\x99\xD0\xBB\xD3\x99\xD0\xBC \xD0\xB4\xD0\xBE\xD0\xBD\xD1\x8A\xD1\x8F\nBasque: Kaixo Mundua\nBelarusian: \xD0\x9F\xD1\x80\xD1\x8B\xD0\xB2\xD1\x96\xD1\x82\xD0\xB0\xD0\xBD\xD0\xBD\xD0\xB5 \xD1\x81\xD0\xB2\xD0\xB5\xD1\x82\nBaluchi: \xD8\xB3\xD9\x84\xD8\xA7\xD9\x85 \xD8\xAF\xD9\x86\xDB\x8C\xD8\xA7\nBemba: Mwaiseni panshi\nBengali: \xE0\xA6\xB9\xE0\xA7\x8D\xE0\xA6\xAF\xE0\xA6\xBE\xE0\xA6\xB2\xE0\xA7\x8B \xE0\xA6\xAC\xE0\xA6\xBF\xE0\xA6\xB6\xE0\xA7\x8D\xE0\xA6\xAC\nBetawi: Halo dunia\nBhojpuri: \xE0\xA4\xAA\xE0\xA5\x8D\xE0\xA4\xB0\xE0\xA4\xA3\xE0\xA4\xBE\xE0\xA4\xAE \xE0\xA4\xA6\xE0\xA5\x81\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xAF\xE0\xA4\xBE\nBikol: Kumusta mundo\nBurmese: \xE1\x80\x99\xE1\x80\x84\xE1\x80\xBA\xE1\x80\xB9\xE1\x80\x82\xE1\x80\x9C\xE1\x80\xAC\xE1\x80\x95\xE1\x80\xAB\xE1\x80\x80\xE1\x80\x99\xE1\x80\xB9\xE1\x80\x98\xE1\x80\xAC\xE1\x80\x9C\xE1\x80\xB1\xE1\x80\xAC\xE1\x80\x80\nBosnian: Zdravo svijete\nBreton: Demat bed\nBulgarian: \xD0\x97\xD0\xB4\xD1\x80\xD0\xB0\xD0\xB2\xD0\xB5\xD0\xB9 \xD1\x81\xD0\xB2\xD1\x8F\xD1\x82\nBuryat: \xD0\xA1\xD0\xB0\xD0\xB9\xD0\xBD \xD0\xB1\xD0\xB0\xD0\xB9\xD0\xBD\xD0\xB0 \xD1\x83\xD1\x83 \xD0\xB4\xD1\x8D\xD0\xBB\xD1\x85\xD1\x8D\xD0\xB9\nCebuano: Kumusta kalibutan\nChamorro: H\xC3\xA5fa adai t\xC3\xA5no\'\nChichewa: Moni dziko lapansi\nChinese (Traditional): \xE4\xBD\xA0\xE5\xA5\xBD\xE4\xB8\x96\xE7\x95\x8C\nChinese (Simplified): \xE4\xBD\xA0\xE5\xA5\xBD\xE4\xB8\x96\xE7\x95\x8C\nChuukese: Ran annim fonufan\nDanish: Hej Verden\nDari: \xD8\xB3\xD9\x84\xD8\xA7\xD9\x85 \xD8\xAF\xD9\x86\xDB\x8C\xD8\xA7\nGerman: Hallo Welt\nDhivehi: \xDE\x80\xDE\xA6\xDE\x8D\xDE\xAF \xDE\x8B\xDE\xAA\xDE\x82\xDE\xA8\xDE\x94\xDE\xAC\nDinka: Kudual alethe\nDyula: I ni tile di\xC9\xB2\xC9\x9B\nDogri: \xE0\xA4\xA8\xE0\xA4\xAE\xE0\xA4\xB8\xE0\xA5\x8D\xE0\xA4\x95\xE0\xA4\xBE\xE0\xA4\xB0 \xE0\xA4\xA6\xE0\xA5\x81\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xAF\xE0\xA4\xBE\nDombe: Mhoro nyika\nDzongkha: \xE0\xBD\x80\xE0\xBD\xB4\xE0\xBC\x8B\xE0\xBD\x9F\xE0\xBD\xB4\xE0\xBD\x82\xE0\xBC\x8B \xE0\xBD\xA0\xE0\xBD\x9B\xE0\xBD\x98\xE0\xBC\x8B\xE0\xBD\x82\xE0\xBE\xB3\xE0\xBD\xB2\xE0\xBD\x84\nEnglish: Hello World\nEsperanto: Saluton Mondo\nEstonian: Tere maailm\nEwe: Mawu\xC9\x96e\xC9\x96e xexeame\nFaroese: Hall\xC3\xB3 heimur\nFijian: Bula vuravura\nFilipino: Kamusta mundo\nFinnish: Hei maailma\nFon: K\xC3\xBA n\'d\xC3\xA9\nFrench: Bonjour le monde\nFrench (Canada): Bonjour le monde\nFrisian: Hallo wr\xC3\xA2ld\nFula: Jam \xC9\x97u\xC9\x97al\nFriulian: Mandi mond\nGa: M\xC3\xAD\xC9\x96ek\xC3\xBA xexeame\nGalician: Ola mundo\nGeorgian: \xE1\x83\x92\xE1\x83\x90\xE1\x83\x9B\xE1\x83\x90\xE1\x83\xA0\xE1\x83\xAF\xE1\x83\x9D\xE1\x83\x91\xE1\x83\x90 \xE1\x83\x9B\xE1\x83\xA1\xE1\x83\x9D\xE1\x83\xA4\xE1\x83\x9A\xE1\x83\x98\xE1\x83\x9D\nGreek: \xCE\x93\xCE\xB5\xCE\xB9\xCE\xB1 \xCF\x83\xCE\xBF\xCF\x85 \xCE\xBA\xCF\x8C\xCF\x83\xCE\xBC\xCE\xB5\nGuarani: Mba\'\xC3\xA9ichapa ko yvy\nGujarati: \xE0\xAA\xB9\xE0\xAB\x87\xE0\xAA\xB2\xE0\xAB\x8B \xE0\xAA\xB5\xE0\xAA\xBF\xE0\xAA\xB6\xE0\xAB\x8D\xE0\xAA\xB5\nHaitian Creole: Bonjou mond\nHakha Chin: Chibai van\nHausa: Sannu duniya\nHawaiian: Aloha honua\nHebrew: \xD7\xA9\xD7\x9C\xD7\x95\xD7\x9D \xD7\xA2\xD7\x95\xD7\x9C\xD7\x9D\nHiligaynon: Kumusta kalibutan\nHindi: \xE0\xA4\xA8\xE0\xA4\xAE\xE0\xA4\xB8\xE0\xA5\x8D\xE0\xA4\xA4\xE0\xA5\x87 \xE0\xA4\xA6\xE0\xA5\x81\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xAF\xE0\xA4\xBE\nHmong: Nyob zoo ntiaj teb\nIban: Hai dunya\nIgbo: Ndewo \xE1\xBB\xA5wa\nIlocano: Kumusta lubong\nIndonesian: Halo Dunia\nInuktitut (Latin): Ullaakkut maligaq\nInuktitut (Syllabics): \xE1\x90\x85\xE1\x93\xAA\xE1\x93\x9B\xE1\x92\x83\xE1\x91\xAF\xE1\x91\xA6 \xE1\x92\xAA\xE1\x93\x95\xE1\x92\x90\xE1\x96\x85\nIrish: Dia dhuit domhan\nIcelandic: Hall\xC3\xB3 heimur\nItalian: Ciao mondo\nYakut: \xD0\x94\xD0\xBE\xD1\x80\xD0\xBE\xD0\xBE\xD0\xB1\xD0\xBE \xD0\xB0\xD0\xB0\xD0\xBD \xD0\xB4\xD0\xBE\xD0\xB9\xD0\xB4\xD1\x83\nJamaican Patois: Wah gwaan worl\nJapanese: \xE3\x81\x93\xE3\x82\x93\xE3\x81\xAB\xE3\x81\xA1\xE3\x81\xAF\xE4\xB8\x96\xE7\x95\x8C\nJavanese: Halo donya\nYiddish: \xD7\x94\xD7\xA2\xD7\x9C\xD7\x90 \xD7\x95\xD7\x95\xD7\xA2\xD7\x9C\xD7\x98\nJingpo: Chyeju gam\nGreenlandic: Aluu sila\nKannada: \xE0\xB2\xB9\xE0\xB2\xB2\xE0\xB3\x8B \xE0\xB2\x9C\xE0\xB2\x97\xE0\xB2\xA4\xE0\xB3\x8D\xE0\xB2\xA4\xE0\xB3\x81\nCantonese: \xE4\xBD\xA0\xE5\xA5\xBD\xE4\xB8\x96\xE7\x95\x8C\nKanuri: Sanni duniya\nKapampangan: Kumusta yatu\nKaro Batak: Horas donya\nKazakh: \xD0\xA1\xD3\x99\xD0\xBB\xD0\xB5\xD0\xBC \xD3\x99\xD0\xBB\xD0\xB5\xD0\xBC\nCatalan: Hola m\xC3\xB3n\nKekchi: Us li ruchich\xCB\x88och\nKhasi: Khublei sorkar\nKhmer: \xE1\x9E\x87\xE1\x9F\x86\xE1\x9E\x9A\xE1\x9E\xB6\xE1\x9E\x94\xE1\x9E\x9F\xE1\x9E\xBD\xE1\x9E\x9A\xE1\x9E\x96\xE1\x9E\xB7\xE1\x9E\x97\xE1\x9E\x96\xE1\x9E\x9B\xE1\x9F\x84\xE1\x9E\x80\nKiga: Oraire ensi\nKikongo: Mbote nza\nKinyarwanda: Muraho isi\nKyrgyz: \xD0\xA1\xD0\xB0\xD0\xBB\xD0\xB0\xD0\xBC \xD0\xB4\xD2\xAF\xD0\xB9\xD0\xBD\xD3\xA9\nKirundi: Bwakeye isi\nKituba: Mbote nza\nKokborok: Neokhai longbar\nKomi: \xD0\x92\xD0\xB8\xD0\xB4\xD0\xB7\xD0\xB0 \xD0\xBE\xD0\xBB\xD0\xB0\xD0\xBD \xD0\xBC\xD0\xB8\xD1\x80\nKonkani: \xE0\xA4\xB9\xE0\xA5\x85\xE0\xA4\xB2\xE0\xA5\x8B \xE0\xA4\xB8\xE0\xA4\x82\xE0\xA4\xB8\xE0\xA4\xBE\xE0\xA4\xB0\nKorean: \xEC\x95\x88\xEB\x85\x95\xED\x95\x98\xEC\x84\xB8\xEC\x9A\x94 \xEC\x84\xB8\xEA\xB3\x84\nCorsican: Bonghjornu mondu\nMauritian Creole: Bonzour lemonn\nCrimean Tatar (Cyrillic): \xD0\xA1\xD0\xB5\xD0\xBB\xD1\x8F\xD0\xBC \xD0\xB4\xD1\x8E\xD0\xBD\xD1\x8C\xD1\x8F\nCrimean Tatar (Latin): Sel\xC3\xA2m d\xC3\xBCnya\nKrio: Kush\xC9\x9B w\xC9\x94l\nCroatian: Pozdrav svijete\nKurdish (Kurmanji): Silav c\xC3\xAEhan\nKurdish (Sorani): \xD8\xB3\xDA\xB5\xD8\xA7\xD9\x88 \xD8\xAC\xDB\x8C\xD9\x87\xD8\xA7\xD9\x86\nLao: \xE0\xBA\xAA\xE0\xBA\xB0\xE0\xBA\x9A\xE0\xBA\xB2\xE0\xBA\x8D\xE0\xBA\x94\xE0\xBA\xB5\xE0\xBB\x82\xE0\xBA\xA5\xE0\xBA\x81\nLatin: Salve munde\nLatgalian: Vasals pasaule\nLatvian: Sveika pasaule\nLigurian: \xC3\x87ao mondo\nLimburgish: Hallo werreld\nLingala: Mbote mokili\nLithuanian: Sveikas pasauli\nLombard: Ciau mund\nLuganda: Nkulamusizza ensi\nLuo: Misawa piny\nLuxembourgish: Moien Welt\nMadurese: Halo donya\nMaithili: \xE0\xA4\xA8\xE0\xA4\xAE\xE0\xA4\xB8\xE0\xA5\x8D\xE0\xA4\x95\xE0\xA4\xBE\xE0\xA4\xB0 \xE0\xA4\xA6\xE0\xA5\x81\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xAF\xE0\xA4\xBE\nMakassarese: Halo dunia\nMalagasy: Salama tontolo\nMalay (Jawi): \xD9\x87\xD8\xA7\xD9\x84\xD9\x88 \xD8\xAF\xD9\x86\xD9\x8A\xD8\xA7\nMalayalam: \xE0\xB4\xB9\xE0\xB4\xB2\xE0\xB5\x8B \xE0\xB4\xB2\xE0\xB5\x8B\xE0\xB4\x95\xE0\xB4\x82\nMalay: Hello dunia\nMaltese: Bongu dinja\nMam: K\'ulaj tx\xCA\xBCotx\xCA\xBC\nManx: Hallo seihll\nMaori: Kia ora ao\nMarathi: \xE0\xA4\xA8\xE0\xA4\xAE\xE0\xA4\xB8\xE0\xA5\x8D\xE0\xA4\x95\xE0\xA4\xBE\xE0\xA4\xB0 \xE0\xA4\x9C\xE0\xA4\x97\nMarshallese: Yokwe aolep\nMarwari: \xE0\xA4\xA8\xE0\xA4\xAE\xE0\xA4\xB8\xE0\xA5\x8D\xE0\xA4\x95\xE0\xA4\xBE\xE0\xA4\xB0 \xE0\xA4\xA6\xE0\xA5\x81\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xAF\xE0\xA4\xBE\nYucatec Maya: Ma\'alob k\'iin y\xC3\xB3ok\'ol kaab\nMacedonian: \xD0\x97\xD0\xB4\xD1\x80\xD0\xB0\xD0\xB2\xD0\xBE \xD1\x81\xD0\xB2\xD0\xB5\xD1\x82\xD1\x83\nMeiteilon: \xEA\xAF\x8D\xEA\xAF\xA6\xEA\xAF\x82\xEA\xAF\xA3 \xEA\xAF\x83\xEA\xAF\xA5\xEA\xAF\x82\xEA\xAF\xA6\xEA\xAF\x9D\nMinangkabau: Halo dunia\nMizo: Chibai vantlang\nMongolian: \xD0\xA1\xD0\xB0\xD0\xB9\xD0\xBD \xD1\x83\xD1\x83 \xD0\xB4\xD1\x8D\xD0\xBB\xD1\x85\xD0\xB8\xD0\xB9\nN\'Ko: \xDF\x8C \xDF\xA3\xDF\x8C\xDF\xAB \xDF\x9B\xDF\x8F \xDF\x98\xDF\x8E\xDF\xA2\xDF\x8A\xDF\xAB\nNahuatl (Eastern Huasteca): Pia cemanahuac\nNdau: Mhoro nyika\nSouthern Ndebele: Sawubona mhlaba\nNepalbhasa: \xE0\xA4\x9C\xE0\xA4\xAF \xE0\xA4\x9C\xE0\xA4\x97\xE0\xA4\xA4\nNepali: \xE0\xA4\xA8\xE0\xA4\xAE\xE0\xA4\xB8\xE0\xA5\x8D\xE0\xA4\xA4\xE0\xA5\x87 \xE0\xA4\xB8\xE0\xA4\x82\xE0\xA4\xB8\xE0\xA4\xBE\xE0\xA4\xB0\nDutch: Hallo wereld\nNorthern Sotho: Thobela lefase\nNorwegian: Hei verden\nNuer: Mal n\xC9\x9B piny\nOdia: \xE0\xAC\xA8\xE0\xAC\xAE\xE0\xAC\xB8\xE0\xAD\x8D\xE0\xAC\x95\xE0\xAC\xBE\xE0\xAC\xB0 \xE0\xAC\xAC\xE0\xAC\xBF\xE0\xAC\xB6\xE0\xAD\x8D\xE0\xAD\xB1\nOccitan: Adiu mond\nOromo: Akkam addunyaa\nOssetian: \xD0\xA1\xD0\xB0\xD0\xBB\xD0\xB0\xD0\xBC \xD0\xB4\xD1\x83\xD0\xBD\xD0\xB5\nPangasinan: Maabig mundo\nPunjabi (Gurmukhi): \xE0\xA8\xB8\xE0\xA8\xA4 \xE0\xA8\xB8\xE0\xA9\x8D\xE0\xA8\xB0\xE0\xA9\x80 \xE0\xA8\x85\xE0\xA8\x95\xE0\xA8\xBE\xE0\xA8\xB2 \xE0\xA8\xA6\xE0\xA9\x81\xE0\xA8\xA8\xE0\xA9\x80\xE0\xA8\x86\xE0\xA8\x82\nPunjabi (Shahmukhi): \xDB\x81\xDB\x8C\xD9\x84\xD9\x88 \xD8\xAF\xD9\x86\xDB\x8C\xD8\xA7\nPapiamento: Bon bini mundo\nPashto: \xD8\xB3\xD9\x84\xD8\xA7\xD9\x85 \xD9\x86\xDA\x93\xDB\x8D\nPersian: \xD8\xB3\xD9\x84\xD8\xA7\xD9\x85 \xD8\xAF\xD9\x86\xDB\x8C\xD8\xA7\nPolish: Witaj \xC5\x9Bwiecie\nPortuguese (Brazil): Ol\xC3\xA1 Mundo\nPortuguese (Portugal): Ol\xC3\xA1 Mundo\nQuechua: Allinllachu kay pacha\nHunsrik: Hallo Welt\nRomani: Latcho dives luma\nRomanian: Salut lume\nRussian: \xD0\x9F\xD1\x80\xD0\xB8\xD0\xB2\xD0\xB5\xD1\x82 \xD0\xBC\xD0\xB8\xD1\x80\nNorthern Sami: Bures m\xC3\xA1ilbmi\nSamoan: Talofa lalolagi\nSango: Bala \xC3\xA2la\nSanskrit: \xE0\xA4\xA8\xE0\xA4\xAE\xE0\xA4\xB8\xE0\xA5\x8D\xE0\xA4\xA4\xE0\xA5\x87 \xE0\xA4\x9C\xE0\xA4\x97\xE0\xA4\xA4\xE0\xA5\x8D\nSantali (Latin): Johar dishom\nSantali (Ol Chiki): \xE1\xB1\xA1\xE1\xB1\x9A\xE1\xB1\xA6\xE1\xB1\x9F\xE1\xB1\xA8 \xE1\xB1\xAB\xE1\xB1\xA4\xE1\xB1\xA5\xE1\xB1\x9A\xE1\xB1\xA2\nSilesian: Witej \xC5\x9Bwiycie\nScottish Gaelic: Hal\xC3\xB2 saoghal\nSwedish: Hej v\xC3\xA4rlden\nSerbian: \xD0\x97\xD0\xB4\xD1\x80\xD0\xB0\xD0\xB2\xD0\xBE \xD1\x81\xD0\xB2\xD0\xB5\xD1\x82\xD0\xB5\nSesotho: Lumela lefatshe\nSetswana: Dumela lefatshe\nSeychellois Creole: Bonzour lemonn\nShan: \xE1\x82\x81\xE1\x82\x83\xE1\x82\x87\xE1\x80\x9C\xE1\x80\xB0\xE1\x80\x9D\xE1\x80\xBA\xE1\x82\x87\xE1\x80\x9C\xE1\x80\xB0\xE1\x80\x84\xE1\x80\xBA\xE1\x82\x87\nShona: Mhoro nyika\nSimalungun: Horas dunia\nSindhi: \xD9\x87\xD9\x8A\xD9\x84\xD9\x88 \xD8\xAF\xD9\x86\xD9\x8A\xD8\xA7\nSinhala: \xE0\xB7\x84\xE0\xB7\x99\xE0\xB6\xBD\xE0\xB7\x9D \xE0\xB6\xBD\xE0\xB7\x9D\xE0\xB6\x9A\xE0\xB6\xBA\nSwati: Sawubona lizwe\nSicilian: Ciau munnu\nSlovak: Ahoj svet\nSlovenian: Pozdravljeni svet\nSomali: Salaam adduunka\nSpanish: Hola Mundo\nSundanese: Halo dunya\nSusu: I kuma dunuya\nSwahili: Habari dunia\nTajik: \xD0\xA1\xD0\xB0\xD0\xBB\xD0\xBE\xD0\xBC \xD2\xB7\xD0\xB0\xD2\xB3\xD0\xBE\xD0\xBD\nTahitian: Ia ora na te ao\nTamazight: Azul ama\xE1\xB8\x8Dal\nTamazight (Tifinagh): \xE2\xB4\xB0\xE2\xB5\xA3\xE2\xB5\x93\xE2\xB5\x8D \xE2\xB4\xB0\xE2\xB5\x8E\xE2\xB4\xB0\xE2\xB4\xB9\xE2\xB4\xB0\xE2\xB5\x8D\nTamil: \xE0\xAE\xB5\xE0\xAE\xA3\xE0\xAE\x95\xE0\xAF\x8D\xE0\xAE\x95\xE0\xAE\xAE\xE0\xAF\x8D \xE0\xAE\x89\xE0\xAE\xB2\xE0\xAE\x95\xE0\xAE\xAE\xE0\xAF\x8D\nTatar: \xD0\xA1\xD3\x99\xD0\xBB\xD0\xB0\xD0\xBC \xD0\xB4\xD3\xA9\xD0\xBD\xD1\x8C\xD1\x8F\nTelugu: \xE0\xB0\xB9\xE0\xB0\xB2\xE0\xB1\x8B \xE0\xB0\xAA\xE0\xB1\x8D\xE0\xB0\xB0\xE0\xB0\xAA\xE0\xB0\x82\xE0\xB0\x9A\xE0\xB0\x82\nTetum: Bondia mundu\nThai: \xE0\xB8\xAA\xE0\xB8\xA7\xE0\xB8\xB1\xE0\xB8\xAA\xE0\xB8\x94\xE0\xB8\xB5\xE0\xB8\x8A\xE0\xB8\xB2\xE0\xB8\xA7\xE0\xB9\x82\xE0\xB8\xA5\xE0\xB8\x81\nTibetan: \xE0\xBD\x96\xE0\xBD\x80\xE0\xBE\xB2\xE0\xBC\x8B\xE0\xBD\xA4\xE0\xBD\xB2\xE0\xBD\xA6\xE0\xBC\x8B\xE0\xBD\x96\xE0\xBD\x91\xE0\xBD\xBA\xE0\xBC\x8B\xE0\xBD\xA3\xE0\xBD\xBA\xE0\xBD\x82\xE0\xBD\xA6\xE0\xBC\x8B\xE0\xBD\xA0\xE0\xBD\x9B\xE0\xBD\x98\xE0\xBC\x8B\xE0\xBD\x82\xE0\xBE\xB3\xE0\xBD\xB2\xE0\xBD\x84\nTigrinya: \xE1\x88\xB0\xE1\x88\x8B\xE1\x88\x9D \xE1\x8B\x93\xE1\x88\x88\xE1\x88\x9D\nTiv: Msugh u sha\nToba Batak: Horas dunia\nTok Pisin: Gude wol\nTongan: M\xC4\x81l\xC5\x8D m\xC4\x81mani\nCzech: Ahoj sv\xC4\x9Bte\nChechen: \xD0\x9C\xD0\xB0\xD1\x80\xD1\x88\xD0\xB0\xD0\xBB\xD0\xBB\xD0\xB0 \xD0\xB4\xD1\x83\xD1\x8C\xD0\xBD\xD0\xB5\nTshiluba: Muoyo wa mu nsi\nChuvash: \xD0\xA1\xD0\xB0\xD0\xBB\xD0\xB0\xD0\xBC \xD1\x82\xD3\x97\xD0\xBD\xD1\x87\xD0\xB5\nTsonga: Avuxeni misava\nTulu: \xE0\xB2\xB9\xE0\xB2\xB2\xE0\xB3\x8B \xE0\xB2\xAA\xE0\xB3\x8D\xE0\xB2\xB0\xE0\xB2\xAA\xE0\xB2\x82\xE0\xB2\x9A\nTumbuka: Moni chilambo\nTurkish: Merhaba D\xC3\xBCnya\nTurkmen: Salam d\xC3\xBCn\xC3\xBD\xC3\xA4\nTuvan: \xD0\xAD\xD0\xBA\xD0\xB8\xD0\xB8 \xD0\xB4\xD0\xB5\xD0\xBB\xD0\xB5\xD0\xB3\xD0\xB5\xD0\xB9\nTwi: Maaky\xC9\x9B ewiase\nUdmurt: \xD0\xA3\xD0\xBC\xD0\xBE\xD0\xB9 \xD0\xB4\xD1\x83\xD0\xBD\xD0\xBD\xD0\xB5\xD0\xB5\nUyghur: \xD8\xB3\xD8\xA7\xD9\x84\xD8\xA7\xD9\x85 \xD8\xAF\xDB\x87\xD9\x86\xD9\x8A\xD8\xA7\nUkrainian: \xD0\x9F\xD1\x80\xD0\xB8\xD0\xB2\xD1\x96\xD1\x82 \xD1\x81\xD0\xB2\xD1\x96\xD1\x82\nHungarian: Hell\xC3\xB3 vil\xC3\xA1g\nUrdu: \xDB\x81\xDB\x8C\xD9\x84\xD9\x88 \xD8\xAF\xD9\x86\xDB\x8C\xD8\xA7\nUzbek: Salom dunyo\nVenda: Ndaa mashango\nVenetian: Ciao mondo\nVietnamese: Xin ch\xC3\xA0o th\xE1\xBA\xBF gi\xE1\xBB\x9Bi\nWelsh: Helo byd\nWaray: Kumusta kalibutan\nMeadow Mari: \xD0\xA1\xD0\xB0\xD0\xBB\xD0\xB0\xD0\xBC \xD1\x82\xD3\xB1\xD0\xBD\xD1\x8F\nWolof: Salaam \xC3\xA0dduna\nXhosa: Molo lizwe\nYoruba: P\xE1\xBA\xB9l\xE1\xBA\xB9 o aiye\nZapotec: Napa ti guiexh\nZulu: Sawubona mhlaba", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample1, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample2, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample3, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample4, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample5, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample6, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample7, Type = Double, Dynamic = False, Default = \"7", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample8, Type = Double, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample9, Type = Double, Dynamic = False, Default = \"9", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample10, Type = Double, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample11, Type = Double, Dynamic = False, Default = \"11", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample12, Type = Double, Dynamic = False, Default = \"12", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample13, Type = Double, Dynamic = False, Default = \"13", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample14, Type = Double, Dynamic = False, Default = \"14", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample15, Type = Double, Dynamic = False, Default = \"15", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample16, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample17, Type = Double, Dynamic = False, Default = \"17", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample18, Type = Double, Dynamic = False, Default = \"18", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample19, Type = Double, Dynamic = False, Default = \"19", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample20, Type = Double, Dynamic = False, Default = \"20", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample21, Type = Double, Dynamic = False, Default = \"21", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample22, Type = Double, Dynamic = False, Default = \"22", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample23, Type = Double, Dynamic = False, Default = \"23", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample24, Type = Double, Dynamic = False, Default = \"24", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample26, Type = Double, Dynamic = False, Default = \"26", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample27, Type = Double, Dynamic = False, Default = \"27", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample28, Type = Double, Dynamic = False, Default = \"28", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample29, Type = Double, Dynamic = False, Default = \"29", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample30, Type = Double, Dynamic = False, Default = \"30", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample31, Type = Double, Dynamic = False, Default = \"31", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample32, Type = Double, Dynamic = False, Default = \"32", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample33, Type = Double, Dynamic = False, Default = \"33", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExample5Xojo, Type = Double, Dynamic = False, Default = \"51", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kTestZlib, Type = Double, Dynamic = False, Default = \"100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kTestAES, Type = Double, Dynamic = False, Default = \"101", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kEInvoiceCountryPrompt, Type = String, Dynamic = False, Default = \"Enter seller country code (2 letters):\x0AFR - France\x0ADE - Germany\x0AIT - Italy\x0AES - Spain\x0ABE - Belgium\x0ANL - Netherlands\x0AAT - Austria\x0APT - Portugal\x0AOther - Any 2-letter ISO code", Scope = Public, Description = 537570706f7274656420652d696e766f69636520636f756e74727920636f6465732077697468206465736372697074696f6e7320666f7220757365722070726f6d70742e
	#tag EndConstant


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
