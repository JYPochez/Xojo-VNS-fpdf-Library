# Usage Examples

## Table of Contents

- [Example 1: Basic Document Creation](#example-1-basic-document-creation)
- [Example 2: Multiple Pages with Different Sizes](#example-2-multiple-pages-with-different-sizes)
- [Example 3: Landscape Letter Size Document](#example-3-landscape-letter-size-document)
- [Example 4: Working with Page Information](#example-4-working-with-page-information)
- [Example 5: Error Handling Pattern](#example-5-error-handling-pattern)
- [Example 6: Unit Conversion](#example-6-unit-conversion)
- [Example 7: Image Embedding](#example-7-image-embedding)
- [Example 7b: Color Emoji](#example-7b-color-emoji)
- [Example 8: Gradient Fills](#example-8-gradient-fills)
- [Example 9: Clipping Paths](#example-9-clipping-paths)
- [Example 10: Gradients with Clipping](#example-10-gradients-with-clipping)
- [Example 11: Bezier Curves](#example-11-bezier-curves)
- [Example 12: Arrow Lines](#example-12-arrow-lines)
- [Example 17: Utility Methods and JSON Serialization](#example-17-utility-methods-and-json-serialization)
- [Example 20: PDF Import](#example-20-pdf-import)

---

## Example 1: Basic Document Creation

```xojo
// Create a simple A4 document
Dim pdf As New VNSPDFDocument()

// Add first page
pdf.AddPage()

// Check for errors
If pdf.Error <> "" Then
    MsgBox "Error creating PDF: " + pdf.Error
    Return
End If

// Document is ready for content
```

## Example 2: Multiple Pages with Different Sizes

```xojo
// Create document with default A4 size
Dim pdf As New VNSPDFDocument()

// Add first page (A4)
pdf.AddPage()

// Add more pages
pdf.AddPage()
pdf.AddPage()

// Check page count
MsgBox "Total pages: " + Str(pdf.PageCount)
```

## Example 3: Landscape Letter Size Document

```xojo
// Create landscape Letter-sized document with inch units
Dim pdf As New VNSPDFDocument( _
    VNSPDFModule.ePageOrientation.Landscape, _
    VNSPDFModule.ePageUnit.Inches, _
    VNSPDFModule.ePageFormat.Letter _
)

pdf.AddPage()

// Page dimensions are now 11 x 8.5 inches
```

## Example 4: Working with Page Information

```xojo
Dim pdf As New VNSPDFDocument()

// Add pages
pdf.AddPage()
pdf.AddPage()
pdf.AddPage()

// Get current page number
Dim currentPage As Integer = pdf.CurrentPageNumber
MsgBox "Currently on page: " + Str(currentPage)

// Get total page count
Dim totalPages As Integer = pdf.PageCount
MsgBox "Total pages: " + Str(totalPages)
```

## Example 5: Error Handling Pattern

```xojo
Dim pdf As New VNSPDFDocument()

pdf.AddPage()

// Perform various operations
// (future: pdf.SetFont, pdf.Cell, etc.)

// Check for accumulated errors
If pdf.Error <> "" Then
    // Handle error
    MsgBox "PDF Generation Error:" + EndOfLine + EndOfLine + pdf.Error
    Return
End If

// Continue with PDF output
// (future: pdf.Output())
```

## Example 6: Unit Conversion

```xojo
// Convert 210mm (A4 width) to different units
Dim widthMm As Double = 210

// To points
Dim widthPoints As Double = VNSPDFModule.ConvertToPoints(widthMm, VNSPDFModule.ePageUnit.Millimeters)
// Result: ~595.28 points

// To inches
Dim widthInches As Double = widthMm / VNSPDFModule.gkMillimetersPerInch
// Result: ~8.27 inches

// To centimeters
Dim widthCm As Double = widthMm / 10
// Result: 21 cm
```

## Example 7: Image Embedding

```xojo
// Create PDF with images
Dim pdf As New VNSPDFDocument()
pdf.AddPage()

// Title
pdf.SetFont("helvetica", "B", 16)
pdf.Cell(0, 10, "Image Support Examples", 0, 1, "C")
pdf.Ln(5)

// JPEG image with explicit dimensions
pdf.SetFont("helvetica", "B", 12)
pdf.Cell(0, 6, "JPEG Image:", 0, 1, "L")
pdf.Image("test.pdf.jpg", 20, 40, 80, 60)

// PNG image with auto-height (maintains aspect ratio)
pdf.Ln(70)
pdf.SetFont("helvetica", "B", 12)
pdf.Cell(0, 6, "PNG Image:", 0, 1, "L")
pdf.Image("test.png", 20, 120, 80, 0)  // Height calculated automatically

// Save PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("images.pdf")
pdf.SaveToFile(f)
```

**Notes**:
- Both JPEG and PNG formats supported
- Images maintain aspect ratio when width or height is 0
- Images are embedded once and reused if referenced multiple times
- Supports RGB, Grayscale, and CMYK color spaces

## Example 7b: Color Emoji

```xojo
// Create PDF with color emoji (Desktop only)
Dim pdf As New VNSPDFDocument()
pdf.AddPage()

// Title
pdf.SetFont("helvetica", "B", 16)
pdf.Cell(0, 10, "Color Emoji Examples", 0, 1, "C")
pdf.Ln(5)

// Single emoji with description
pdf.SetFont("helvetica", "", 10)
pdf.Cell(0, 6, "Single emoji (10mm size):", 0, 1)
pdf.Emoji("😀", 20, 35, 10)

// Multiple emoji in a row
pdf.Cell(0, 6, "Emoji row (8mm size):", 0, 1)
Dim x As Double = 20
pdf.Emoji("🎨", x, 55, 8)
pdf.Emoji("🚀", x + 10, 55, 8)
pdf.Emoji("💡", x + 20, 55, 8)
pdf.Emoji("⚡", x + 30, 55, 8)
pdf.Emoji("🌟", x + 40, 55, 8)

// Different sizes
pdf.Cell(0, 6, "Different sizes:", 0, 1)
pdf.Emoji("🎯", 20, 75, 5)   // 5mm
pdf.Emoji("🎯", 30, 75, 10)  // 10mm
pdf.Emoji("🎯", 45, 75, 15)  // 15mm

// Save PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("emoji_examples.pdf")
pdf.SaveToFile(f)
```

**Notes**:
- **Platform Support**: Desktop ✅ (working), iOS ⚠️ (planned), Web ⚠️ (planned), Console ❌ (never - no graphics)
- Console has no graphics rendering capability (no Picture/Canvas API)
- Automatically uses platform's native emoji font (Apple Color Emoji, Segoe UI Emoji, Noto Color Emoji)
- All rendering, PNG conversion, and temp file cleanup handled internally
- Size parameter uses document units (mm in this example)
- Cross-platform compatible - emoji render on macOS, Windows, Linux

## Example 8: Gradient Fills

```xojo
// Create PDF with gradient examples
Dim pdf As New VNSPDFDocument()
pdf.AddPage()

// Title
pdf.SetFont("helvetica", "B", 16)
pdf.Cell(0, 10, "Gradient Examples", 0, 1, "C")
pdf.Ln(5)

// Linear gradient - horizontal (red to blue)
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Horizontal Linear Gradient:", 0, 1)
pdf.LinearGradient(20, 30, 80, 30, 255, 0, 0, 0, 0, 255, 0, 0, 1, 0)
pdf.Ln(35)

// Linear gradient - vertical (yellow to green)
pdf.Cell(0, 6, "Vertical Linear Gradient:", 0, 1)
pdf.LinearGradient(20, 75, 80, 30, 255, 255, 0, 0, 255, 0, 0, 0, 0, 1)
pdf.Ln(35)

// Linear gradient - diagonal
pdf.Cell(0, 6, "Diagonal Linear Gradient:", 0, 1)
pdf.LinearGradient(20, 120, 80, 30, 255, 0, 255, 0, 255, 255, 0, 0, 1, 1)
pdf.Ln(35)

// Radial gradient - center (white to blue)
pdf.Cell(0, 6, "Center Radial Gradient:", 0, 1)
pdf.RadialGradient(20, 165, 80, 40, 255, 255, 255, 0, 0, 255, 0.5, 0.5, 0.5, 0.5, 0.5)
pdf.Ln(45)

// Radial gradient - off-center spotlight effect
pdf.Cell(0, 6, "Spotlight Radial Gradient:", 0, 1)
pdf.RadialGradient(20, 220, 80, 40, 255, 255, 200, 100, 100, 100, 0.3, 0.3, 0.7, 0.7, 0.6)

// Save PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("gradients.pdf")
pdf.SaveToFile(f)
```

**Notes**:
- Gradient coordinates are normalized (0.0 to 1.0) relative to the rectangle
- Linear gradients: (x1, y1, x2, y2) defines the gradient vector
  - (0, 0, 1, 0) = left to right
  - (0, 0, 0, 1) = top to bottom
  - (0, 0, 1, 1) = diagonal
- Radial gradients: (x1, y1) is inner circle center, (x2, y2) is outer circle center, r is outer radius
- Colors are RGB values (0-255)
- Uses PDF Type 2 (linear) and Type 3 (radial) shading patterns

## Example 9: Clipping Paths

```xojo
// Create PDF with clipping path examples
Dim pdf As New VNSPDFDocument()
pdf.AddPage()

// Title
pdf.SetFont("helvetica", "B", 16)
pdf.Cell(0, 10, "Clipping Path Examples", 0, 1, "C")
pdf.Ln(5)

// Rectangular clipping
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Rectangular Clipping:", 0, 1)
pdf.ClipRect(20, 30, 60, 40, True)  // With outline
pdf.SetFillColor(255, 100, 100)
pdf.Circle(50, 50, 30, "F")  // Circle clipped to rectangle
pdf.ClipEnd()
pdf.Ln(45)

// Circular clipping
pdf.SetFillColor(0, 0, 0)  // Reset to black for text
pdf.Cell(0, 6, "Circular Clipping:", 0, 1)
pdf.ClipCircle(50, 100, 25, True)  // With outline
pdf.SetFillColor(100, 100, 255)
pdf.Rect(25, 75, 50, 50, "F")  // Rectangle clipped to circle
pdf.ClipEnd()
pdf.Ln(50)

// Elliptical clipping
pdf.SetFillColor(0, 0, 0)
pdf.Cell(0, 6, "Elliptical Clipping:", 0, 1)
pdf.ClipEllipse(50, 165, 35, 20, False)  // No outline
pdf.SetFillColor(255, 200, 100)
pdf.Rect(15, 145, 70, 40, "F")  // Rectangle clipped to ellipse
pdf.ClipEnd()
pdf.Ln(45)

// Text clipping
pdf.Cell(0, 6, "Text Clipping:", 0, 1)
pdf.SetFont("helvetica", "B", 36)
pdf.ClipText(15, 235, "CLIP", True)  // With outline
pdf.SetFillColor(200, 0, 200)
Dim i As Integer
For i = 0 To 20
    pdf.SetLineWidth(1)
    pdf.SetDrawColor(255 - i * 10, 0, 255 - i * 10)
    pdf.Line(15, 200 + i * 4, 100, 200 + i * 4)
Next
pdf.ClipEnd()

// Save PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("clipping.pdf")
pdf.SaveToFile(f)
```

**Notes**:
- ClipEnd() must be called to restore graphics state after each clipping operation
- Clipping paths can be nested (call ClipEnd() for each level)
- outline parameter: True draws the clip region border, False makes it invisible
- All drawing operations after clipping are confined to the clipping region
- Uses PDF graphics state stack (q/Q operators)

## Example 10: Gradients with Clipping

```xojo
// Create PDF combining gradients and clipping paths
Dim pdf As New VNSPDFDocument()
pdf.AddPage()

// Title
pdf.SetFont("helvetica", "B", 16)
pdf.Cell(0, 10, "Gradients + Clipping", 0, 1, "C")
pdf.Ln(5)

// Circular clipping with linear gradient
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Circle with Linear Gradient:", 0, 1)
pdf.ClipCircle(50, 50, 25, True)
pdf.LinearGradient(25, 25, 50, 50, 255, 0, 0, 0, 0, 255, 0, 0, 1, 0)
pdf.ClipEnd()
pdf.Ln(55)

// Rounded rectangle with radial gradient
pdf.SetFillColor(0, 0, 0)
pdf.Cell(0, 6, "Rounded Rect with Radial Gradient:", 0, 1)
pdf.ClipRoundedRect(20, 90, 80, 40, 8, "1234", False)
pdf.RadialGradient(20, 90, 80, 40, 255, 255, 255, 100, 100, 255, 0.5, 0.5, 0.5, 0.5, 0.7)
pdf.ClipEnd()
pdf.Ln(45)

// Text with gradient fill
pdf.Cell(0, 6, "Text with Gradient Fill:", 0, 1)
pdf.SetFont("helvetica", "B", 48)
pdf.ClipText(20, 175, "PDF", True)
pdf.RadialGradient(20, 140, 100, 50, 255, 255, 100, 100, 100, 255, 0.3, 0.2, 0.7, 0.8, 0.6)
pdf.ClipEnd()
pdf.Ln(50)

// Nested clipping with gradient
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Nested Clipping:", 0, 1)
pdf.ClipRect(20, 200, 100, 60, False)
pdf.ClipCircle(70, 230, 35, False)
pdf.LinearGradient(20, 200, 100, 60, 255, 128, 0, 128, 0, 255, 0.3, 0, 0.7, 1)
pdf.ClipEnd()  // Exit circle clip
pdf.ClipEnd()  // Exit rectangle clip

// Save PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("gradients_clipping.pdf")
pdf.SaveToFile(f)
```

**Notes**:
- Gradients and clipping can be combined for sophisticated visual effects
- Clipping confines the gradient to a specific shape
- Nested clipping creates intersection regions (AND operation)
- Call ClipEnd() once for each clipping level
- Gradient coordinates remain normalized (0-1) relative to gradient rectangle
- Common use cases: circular photo frames, text effects, masked gradients

---

## Example 11: Bezier Curves

```xojo
// Create PDF demonstrating Bezier curves
Dim pdf As New VNSPDFDocument()
pdf.AddPage()

// Title
pdf.SetFont("helvetica", "B", 16)
pdf.Cell(0, 10, "Bezier Curves", 0, 1, "C")
pdf.Ln(5)

// Quadratic Bezier curves (one control point)
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Quadratic Bezier Curves:", 0, 1)
pdf.Ln(2)

// Simple S-curve
pdf.SetDrawColor(0, 128, 255)
pdf.SetLineWidth(1.5)
pdf.Curve(20, 35, 60, 20, 100, 35, "D")

// Upward curve
pdf.SetDrawColor(255, 0, 128)
pdf.Curve(20, 50, 60, 35, 100, 50, "D")

// Downward curve
pdf.SetDrawColor(0, 200, 0)
pdf.Curve(20, 65, 60, 80, 100, 65, "D")

// Cubic Bezier curves (two control points)
pdf.Ln(20)
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Cubic Bezier Curves:", 0, 1)
pdf.Ln(2)

// Complex S-curve
pdf.SetDrawColor(200, 0, 200)
pdf.SetLineWidth(2)
pdf.CurveBezierCubic(20, 95, 40, 80, 80, 110, 100, 95, "D")

// Wave pattern
pdf.SetDrawColor(0, 100, 200)
pdf.CurveBezierCubic(20, 115, 35, 105, 85, 125, 100, 115, "D")

// Filled Bezier curves
pdf.Ln(30)
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Filled Bezier Curves:", 0, 1)
pdf.Ln(2)

// Pink filled curve
pdf.SetFillColor(255, 200, 200)
pdf.SetDrawColor(200, 0, 0)
pdf.SetLineWidth(1)
pdf.CurveBezierCubic(20, 145, 40, 135, 60, 160, 80, 150, "DF")

// Light blue filled curve
pdf.SetFillColor(200, 220, 255)
pdf.SetDrawColor(0, 0, 200)
pdf.CurveBezierCubic(90, 150, 110, 140, 130, 165, 150, 155, "DF")

// Complex curved path
pdf.Ln(30)
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Complex Curved Path:", 0, 1)
pdf.Ln(2)

pdf.SetDrawColor(128, 0, 128)
pdf.SetLineWidth(2.5)
pdf.Curve(20, 185, 40, 175, 60, 185, "D")
pdf.Curve(60, 185, 80, 195, 100, 185, "D")
pdf.Curve(100, 185, 120, 175, 140, 185, "D")

// Save PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("bezier_curves.pdf")
pdf.SaveToFile(f)
```

**Notes**:
- Quadratic Bezier curves (Curve) use one control point for simpler curves
- Cubic Bezier curves (CurveBezierCubic) use two control points for more complex shapes
- All three styles work: "D" (draw only), "F" (fill only), "DF" (draw and fill)
- Curves can be chained together to create complex paths
- Control points determine the curve's shape and direction
- Filled curves create closed shapes by connecting endpoints

---

## Example 12: Arrow Lines

```xojo
// Create PDF demonstrating arrow lines
Dim pdf As New VNSPDFDocument()
pdf.AddPage()

// Title
pdf.SetFont("helvetica", "B", 16)
pdf.Cell(0, 10, "Arrow Lines", 0, 1, "C")
pdf.Ln(5)

// Basic arrows
pdf.SetFont("helvetica", "B", 10)
pdf.Cell(0, 6, "Basic Arrows:", 0, 1)
pdf.Ln(2)

// Right arrow (default)
pdf.SetDrawColor(0, 0, 0)
pdf.SetFillColor(0, 0, 0)
pdf.SetLineWidth(1)
pdf.Arrow(20, 30, 80, 30, False, True, 3)

// Left arrow
pdf.Arrow(100, 35, 160, 35, True, False, 3)

// Bidirectional arrow
pdf.Arrow(20, 45, 160, 45, True, True, 3)

// Different arrow sizes
pdf.Ln(20)
pdf.Cell(0, 6, "Different Arrow Sizes:", 0, 1)
pdf.Ln(2)

pdf.Arrow(20, 60, 120, 60, False, True, 2)   // Small
pdf.Arrow(20, 70, 120, 70, False, True, 4)   // Medium
pdf.Arrow(20, 80, 120, 80, False, True, 6)   // Large

// Colored arrows
pdf.Ln(25)
pdf.Cell(0, 6, "Colored Arrows:", 0, 1)
pdf.Ln(2)

pdf.SetDrawColor(255, 0, 0)
pdf.SetFillColor(255, 0, 0)
pdf.Arrow(20, 100, 80, 100, False, True, 3)

pdf.SetDrawColor(0, 150, 0)
pdf.SetFillColor(0, 150, 0)
pdf.Arrow(90, 105, 150, 105, False, True, 3)

pdf.SetDrawColor(0, 0, 255)
pdf.SetFillColor(0, 0, 255)
pdf.Arrow(20, 115, 150, 115, True, True, 3)

// Diagonal arrows
pdf.Ln(30)
pdf.Cell(0, 6, "Diagonal Arrows:", 0, 1)
pdf.Ln(2)

pdf.SetDrawColor(255, 100, 0)
pdf.SetFillColor(255, 100, 0)
pdf.Arrow(20, 135, 80, 165, False, True, 4)

pdf.SetDrawColor(0, 100, 255)
pdf.SetFillColor(0, 100, 255)
pdf.Arrow(120, 135, 60, 165, False, True, 4)

pdf.SetDrawColor(100, 0, 200)
pdf.SetFillColor(100, 0, 200)
pdf.Arrow(150, 140, 150, 170, False, True, 4)

// Arrows with line styles
pdf.Ln(50)
pdf.Cell(0, 6, "Arrows with Line Styles:", 0, 1)
pdf.Ln(2)

// Thick line
pdf.SetDrawColor(0, 0, 0)
pdf.SetFillColor(0, 0, 0)
pdf.SetLineWidth(3)
pdf.Arrow(20, 190, 80, 190, False, True, 5)

// Dashed arrow
pdf.SetLineWidth(1.5)
Dim dash() As Double = Array(5.0, 3.0)
pdf.SetDashPattern(dash, 0)
pdf.Arrow(90, 195, 150, 195, False, True, 3)

// Reset to solid
Dim solidDash() As Double
pdf.SetDashPattern(solidDash, 0)

// Radial pattern
pdf.Ln(25)
pdf.Cell(0, 6, "Radial Arrow Pattern:", 0, 1)
pdf.Ln(2)

Dim centerX As Double = 100
Dim centerY As Double = 235
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

// Save PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("arrow_lines.pdf")
pdf.SaveToFile(f)
```

**Notes**:
- Arrow() draws lines with optional arrowheads at start, end, or both
- Default: arrowhead at end only (startArrow=False, endArrow=True)
- Arrow size parameter controls arrowhead dimensions
- Line is automatically shortened to prevent visibility beyond arrowhead
- Works with all line styles (width, cap, dash patterns)
- Current draw color used for line, fill color for arrowheads
- Useful for diagrams, flowcharts, and directional indicators
- Arrowhead angle is fixed at 30 degrees for consistent appearance

---

## Example 17: Utility Methods and JSON Serialization

```xojo
// Create PDF demonstrating utility methods
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                               VNSPDFModule.ePageUnit.Millimeters, _
                               VNSPDFModule.ePageFormat.A4)
pdf.SetTitle("Example 17 - Utility Methods")
pdf.AddPage()

// Section 1: GetVersionString()
pdf.SetFont("helvetica", "B", 14)
pdf.Cell(0, 8, "1. GetVersionString()", 0, 1)
pdf.SetFont("helvetica", "", 11)
pdf.Cell(0, 7, "Version: " + pdf.GetVersionString(), 0, 1)
pdf.Ln(3)
// Output: "Version: VNS PDF 1.0.0"

// Section 2: GetConversionRatio()
pdf.SetFont("helvetica", "B", 14)
pdf.Cell(0, 8, "2. GetConversionRatio()", 0, 1)
pdf.SetFont("helvetica", "", 11)

Dim ratio As Double = pdf.GetConversionRatio()
pdf.Cell(0, 7, "Conversion ratio (user units to points): " + Format(ratio, "0.0000"), 0, 1)
pdf.Cell(0, 7, "This means 1 mm = " + Format(ratio, "0.0000") + " points", 0, 1)
pdf.Ln(3)
// For millimeters: shows 2.8346 (1 mm = 2.8346 points)

// Section 3: GetPageSizeStr()
pdf.SetFont("helvetica", "B", 14)
pdf.Cell(0, 8, "3. GetPageSizeStr()", 0, 1)
pdf.SetFont("helvetica", "", 11)

Dim a4Size As Pair = pdf.GetPageSizeStr("a4")
If a4Size <> Nil Then
  pdf.Cell(0, 7, "A4 size: " + Format(a4Size.Left, "0.00") + " x " + _
           Format(a4Size.Right, "0.00") + " mm", 0, 1)
End If

Dim letterSize As Pair = pdf.GetPageSizeStr("letter")
If letterSize <> Nil Then
  pdf.Cell(0, 7, "Letter size: " + Format(letterSize.Left, "0.00") + " x " + _
           Format(letterSize.Right, "0.00") + " mm", 0, 1)
End If

Dim a5Size As Pair = pdf.GetPageSizeStr("a5")
If a5Size <> Nil Then
  pdf.Cell(0, 7, "A5 size: " + Format(a5Size.Left, "0.00") + " x " + _
           Format(a5Size.Right, "0.00") + " mm", 0, 1)
End If
pdf.Ln(3)

// Section 4: RawWriteStr() - Draw red line with raw PDF commands
pdf.SetFont("helvetica", "B", 14)
pdf.Cell(0, 8, "4. RawWriteStr() - Raw PDF Commands", 0, 1)
pdf.SetFont("helvetica", "", 11)
pdf.Cell(0, 7, "A red horizontal line drawn using raw PDF operators:", 0, 1)
pdf.Ln(2)

// Get current position and page dimensions
Dim currentY As Double = pdf.GetY()
Dim pageW As Double
Dim pageH As Double
Call pdf.GetPageSize(pageW, pageH)

// Calculate Y coordinate in PDF points (measured from bottom)
Dim lineY As Double = (pageH - currentY - 5) * ratio

// Write raw PDF commands to draw a red line
Call pdf.RawWriteStr("q")  // Save graphics state
Call pdf.RawWriteStr("1 0 0 RG")  // Red stroke color (RGB: 1, 0, 0)
Call pdf.RawWriteStr("3 w")  // 3 point line width
Call pdf.RawWriteStr("50 " + Str(lineY) + " m")  // Move to (50, lineY)
Call pdf.RawWriteStr("250 " + Str(lineY) + " l")  // Line to (250, lineY)
Call pdf.RawWriteStr("S")  // Stroke the path
Call pdf.RawWriteStr("Q")  // Restore graphics state

pdf.Ln(8)

// Section 5: ToJSON() and FromJSON()
pdf.SetFont("helvetica", "B", 14)
pdf.Cell(0, 8, "5. ToJSON() / FromJSON()", 0, 1)
pdf.SetFont("helvetica", "", 11)
pdf.Cell(0, 7, "Serialize document state to/from JSON:", 0, 1)
pdf.Ln(2)

// Export current state to JSON
Dim jsonState As String = pdf.ToJSON(True)  // Pretty print
pdf.SetFont("courier", "", 8)
pdf.MultiCell(0, 4, "JSON excerpt (first 400 chars):" + EndOfLine + _
              Left(jsonState, 400) + "...", 0, "L", False)
pdf.Ln(3)

// Example: Save state to file
#If TargetDesktop Then
  Dim jsonFile As FolderItem = SpecialFolder.Desktop.Child("pdf_state.json")
  Try
    Dim stream As BinaryStream = BinaryStream.Create(jsonFile, True)
    stream.Write(jsonState)
    stream.Close()

    pdf.SetFont("helvetica", "", 11)
    pdf.Cell(0, 7, "JSON saved to: pdf_state.json", 0, 1)
  Catch e As IOException
    pdf.Cell(0, 7, "Error saving JSON: " + e.Message, 0, 1)
  End Try
#EndIf
pdf.Ln(3)

// Section 6: Close()
pdf.SetFont("helvetica", "B", 14)
pdf.Cell(0, 8, "6. Close()", 0, 1)
pdf.SetFont("helvetica", "", 11)
pdf.Cell(0, 7, "Validates clip/transform nesting before document completion.", 0, 1)
pdf.Cell(0, 7, "Called automatically by Output() and SaveToFile().", 0, 1)
pdf.Ln(3)

// Section 7: GetVersionString() in action
pdf.SetFont("helvetica", "B", 14)
pdf.Cell(0, 8, "7. Summary", 0, 1)
pdf.SetFont("helvetica", "", 11)
pdf.Cell(0, 7, "All utility methods demonstrated successfully!", 0, 1)
pdf.Cell(0, 7, "Generated by: " + pdf.GetVersionString(), 0, 1)

// Save the PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("example17_utilities.pdf")
pdf.SaveToFile(f)
```

**Notes**:
- **GetVersionString()**: Returns "VNS PDF " + version number (e.g., "VNS PDF 1.0.0")
- **GetConversionRatio()**: Returns scale factor from user units to points
  - For mm: 2.8346 (1 mm = 2.8346 points = 1/25.4 * 72)
  - For cm: 28.346
  - For inches: 72.0
  - For points: 1.0
- **GetPageSizeStr()**: Parses page size strings like "A4", "Letter", "A5", "A3", "Legal"
  - Returns Pair(width, height) in current document units
  - Returns Nil for invalid size strings
  - Case-insensitive
- **RawWriteStr()**: Writes raw PDF commands directly to current page buffer
  - Requires active page (mState = 2)
  - PDF coordinates: Y measured from bottom in points
  - Must convert user coordinates to PDF points
  - Use for advanced PDF operations not covered by standard API
  - Example operators: m (move), l (line), S (stroke), RG (stroke color), w (width), q (save state), Q (restore state)
- **Close()**: Validates document state before completion
  - Checks for unclosed clipping operations (mClipNest must be 0)
  - Called automatically by Output() and SaveToFile()
  - Sets mState to 1 (closed)
  - Creates first page if document is empty
- **ToJSON()**: Serializes document state to JSON string
  - Parameters: prettyPrint (Boolean) - formats JSON with indentation if True
  - Includes: metadata (title, author, subject, etc.), page configuration, current position, colors, fonts
  - Does NOT include: page content, embedded images, binary data
  - Useful for saving/restoring document configuration
  - Example use case: template systems, state persistence
- **FromJSON()**: Deserializes document state from JSON string
  - Restores metadata, page dimensions, colors, positions
  - Font objects and images must be re-added separately
  - Error handling: SetError() called on parse failure

---

## Example 20: PDF Import

**Purpose**: Import pages from existing PDF files as XObject templates

```xojo
// Create new document
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                              VNSPDFModule.ePageUnit.Millimeters, _
                              VNSPDFModule.ePageFormat.A4)

// Open source PDF
Dim sourcePDF As FolderItem = New FolderItem("/path/to/source.pdf", FolderItem.PathModes.Native)
If Not pdf.SetSourceFile(sourcePDF) Then
  MessageBox("Error: " + pdf.GetError())
  Return
End If

// Get page count
Dim pageCount As Integer = pdf.GetPageCount()

// Import all pages
Dim templates() As Integer
For i As Integer = 1 To pageCount
  Dim tplID As Integer = pdf.ImportPage(i)
  If tplID = 0 Then
    MessageBox("Failed to import page " + Str(i))
    Return
  End If
  templates.Add(tplID)
Next

// Create overview pages with 2x2 thumbnail grid
Dim thumbnailsPerPage As Integer = 4
For pageIdx As Integer = 0 To Ceiling(pageCount / thumbnailsPerPage) - 1
  pdf.AddPage()

  // Draw 2x2 grid
  Dim startIdx As Integer = pageIdx * thumbnailsPerPage
  For gridIdx As Integer = 0 To Min(3, pageCount - startIdx - 1)
    Dim tplIdx As Integer = startIdx + gridIdx
    Dim row As Integer = Floor(gridIdx / 2)
    Dim col As Integer = gridIdx Mod 2

    // Position and size for 2x2 grid
    Dim x As Double = col * 105 + 5
    Dim y As Double = row * 148.5 + 5

    // Place template (100mm width, auto height)
    pdf.UseTemplate(templates(tplIdx), x, y, 100, 0)

    // Draw border
    pdf.SetDrawColor(200, 200, 200)
    pdf.Rect(x, y, 100, 141, VNSPDFModule.eDrawStyle.Draw)

    // Add label
    pdf.SetFont("Helvetica", "", 8)
    pdf.Text(x + 2, y + 2, "Page " + Str(tplIdx + 1))
  Next
Next

// Save result
Dim output As FolderItem = SpecialFolder.Desktop.Child("example20_pdf_import.pdf")
pdf.SaveToFile(output)
```

**Key Methods**:

### SetSourceFile
```xojo
Function SetSourceFile(pdfFile As FolderItem) As Boolean
```
Opens a PDF file for importing. Must be called before ImportPage().

**Parameters**:
- `pdfFile`: FolderItem pointing to source PDF

**Returns**: True if successful, False on error (check with GetError())

---

### ImportPage
```xojo
Function ImportPage(pageNum As Integer) As Integer
```
Imports a page from the source PDF as an XObject Form template.

**Parameters**:
- `pageNum`: Page number to import (1-based index)

**Returns**: Template ID for use with UseTemplate(), or 0 on error

**Process**:
1. Validates page number
2. Extracts page content stream(s) and decompresses
3. Extracts page resources (fonts, images, XObjects)
4. Creates XObject Form dictionary with /BBox and /Resources
5. Assigns unique object ID
6. Returns template ID

---

### UseTemplate
```xojo
Sub UseTemplate(templateID As Integer, x As Double = 0, y As Double = 0, _
                w As Double = 0, h As Double = 0)
```
Places an imported template on the current page.

**Parameters**:
- `templateID`: Template ID returned by ImportPage()
- `x`, `y`: Position in user units (default: 0, 0)
- `w`, `h`: Size in user units (0 = auto-scale)

**Scaling Behavior**:
- `w = 0, h = 0`: Original page size
- `w > 0, h = 0`: Scale to width, maintain aspect ratio
- `w = 0, h > 0`: Scale to height, maintain aspect ratio
- `w > 0, h > 0`: Scale to exact dimensions

**PDF Commands Generated**:
```
q                           // Save graphics state
scaleX 0 0 scaleY x y cm   // Transform matrix
/XObjN Do                   // Draw XObject
Q                           // Restore graphics state
```

---

**Platform-Specific File Selection**:

**Desktop:**
```xojo
// Multi-location search
Dim sourcePath As String = FindPDFInProjectFolder()
If sourcePath = "" Then
  Dim dlg As OpenDialog
  dlg.Filter = "application/pdf"
  Dim f As FolderItem = dlg.ShowModal()
  If f <> Nil Then sourcePath = f.NativePath
End If
```

**iOS:**
```xojo
// Documents folder enumeration
Dim sourcePath As String = FindPDFInDocuments()
If sourcePath = "" Then
  MessageBox("Place PDF file in Documents folder via File Sharing")
End If
```

**Web:**
```xojo
// File upload dialog
Dim dialog As New WebDialogPDFUpload
If dialog.ShowModal() = dialog.OKButton Then
  Dim sourcePath As String = dialog.UploadedFile.Path
End If
```

**Console:**
```xojo
// Default path
Dim sourcePath As String = FindPDFInProjectFolder()
If sourcePath = "" Then
  Print("Error: Source PDF not found")
End If
```

**Notes**:
- **SetSourceFile()**: Opens PDF for importing, validates structure, builds page tree
- **ImportPage()**: Creates XObject Form from page content, copies all resources
- **UseTemplate()**: Places imported page with transformation matrix
- **Resource Tracking**: Automatically copies fonts, images, nested XObjects
- **Object ID Remapping**: Ensures no conflicts with target document objects
- **Stream Decompression**: Supports FlateDecode, LZWDecode, ASCII85Decode, ASCIIHexDecode
- **Premium Zlib**: Required for most modern PDFs (FlateDecode + PNG Predictors)
- **Complete Documentation**: See [Chapter 17: PDF Import](../developer/17-pdf-import.md)
