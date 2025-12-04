# Core Classes

## Table of Contents

- [VNSPDFDocument](#vnspdf-document)
  - [Constructor](#constructor)
  - [Properties](#properties)
    - [CurrentPageNumber](#currentpagenumber-read-only)
    - [Error](#error-read-only)
    - [PageCount](#pagecount-read-only)
  - [Methods](#methods)
    - [Page Management](#addpage)
    - [Error Management](#seterror)
    - [Font & Text](#setfont)
    - [Text Output](#cell)
    - [Graphics Primitives](#line)
    - [Colors](#settextcolor)
    - [Line Styles](#setlinewidth)
    - [Advanced Graphics](#roundedrect)
    - [Gradients](#lineargradient)
    - [Clipping Paths](#cliprect)
    - [Output](#savetofile)
    - [Images](#image)
- [VNSPDFGradient](#vnspdfgradient)

---

## VNSPDFDocument

**Location**: `PDF_Library/Core/VNSPDFDocument.xojo_code`

The main class for creating and managing PDF documents.

### Constructor

```xojo
Sub Constructor(orientation As VNSPDFModule.ePageOrientation = VNSPDFModule.ePageOrientation.Portrait,
                unit As VNSPDFModule.ePageUnit = VNSPDFModule.ePageUnit.Millimeters,
                pageFormat As VNSPDFModule.ePageFormat = VNSPDFModule.ePageFormat.A4)
```

**Parameters**:
- `orientation` - Page orientation (Portrait or Landscape). Default: Portrait
- `unit` - Unit of measurement for coordinates. Default: Millimeters
- `pageFormat` - Standard page format. Default: A4

**Description**: Creates a new PDF document with specified settings. All pages added to this document will use these settings unless overridden.

**Example**:
```xojo
// Create A4 portrait document in millimeters
Dim pdf As New VNSPDFDocument()

// Create Letter landscape document in inches
Dim pdf2 As New VNSPDFDocument( _
    VNSPDFModule.ePageOrientation.Landscape, _
    VNSPDFModule.ePageUnit.Inches, _
    VNSPDFModule.ePageFormat.Letter _
)
```

### Properties

#### CurrentPageNumber (Read-Only)
```xojo
Property CurrentPageNumber As Integer
```
Returns the current page number (1-based). Returns 0 if no pages exist.

**Example**:
```xojo
Dim pageNum As Integer = pdf.CurrentPageNumber
```

#### Error (Read-Only)
```xojo
Property Error As String
```
Returns the accumulated error message(s). Empty string if no errors.

**Example**:
```xojo
If pdf.Error <> "" Then
    MsgBox "PDF Error: " + pdf.Error
End If
```

#### PageCount (Read-Only)
```xojo
Property PageCount As Integer
```
Returns the total number of pages in the document.

**Example**:
```xojo
Dim totalPages As Integer = pdf.PageCount
```

### Methods

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Page Management</h2>

##### AddPage
```xojo
Sub AddPage()
```

**Description**: Adds a new page to the document using the default format and orientation specified in the constructor.

**Example**:
```xojo
pdf.AddPage()  // Adds page with default settings
```

**Notes**:
- Automatically increments page counter
- Sets current page to the newly added page
- Initializes page content stream

##### SetPage
```xojo
Sub SetPage(pageNum As Integer)
```

**Parameters**:
- `pageNum` - Page number to navigate to (1-based)

**Description**: Navigates to an existing page for adding content. Allows adding content to earlier pages after creating multiple pages.

**Example**:
```xojo
pdf.AddPage()  // Page 1
pdf.AddPage()  // Page 2
pdf.AddPage()  // Page 3

// Go back to page 1 to add footer
pdf.SetPage(1)
pdf.SetFont("helvetica", "", 10)
pdf.Text(100, 280, "Page 1 of 3")

// Continue on page 3
pdf.SetPage(3)
```

**Notes**:
- Page numbers are 1-based
- Commonly used for adding page numbers after all pages are created
- Useful for headers/footers that reference total page count

##### PageNo
```xojo
Function PageNo() As Integer
```

**Returns**: Current page number (1-based)

**Description**: Returns the current page number. Often used in header/footer callbacks.

**Example**:
```xojo
Dim currentPage As Integer = pdf.PageNo()
pdf.Text(100, 10, "Page " + Str(currentPage))
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Error Management</h2>

##### SetError
```xojo
Sub SetError(errMsg As String)
```

**Parameters**:
- `errMsg` - Error message to accumulate

**Description**: Internal method for accumulating error messages. Multiple errors are concatenated with line breaks.

**Example** (internal use):
```xojo
SetError("Font not found: Helvetica-Bold")
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Font & Text</h2>

##### SetFont
```xojo
Sub SetFont(family As String, style As String = "", size As Double = 0)
```

**Parameters**:
- `family` - Font family name ("helvetica", "times", "courier", "symbol", "zapfdingbats")
- `style` - Font style: "" (regular), "B" (bold), "I" (italic), "BI" (bold italic)
- `size` - Font size in points (default: 12)

**Description**: Sets the font for subsequent text operations.

**Example**:
```xojo
pdf.SetFont("helvetica", "B", 16)  // Bold Helvetica 16pt
pdf.SetFont("times", "", 12)       // Regular Times 12pt
```

**Notes**:
- Core PDF fonts are always available
- Size remains unchanged if set to 0
- Font must be set before outputting text

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Text Output</h2>

##### Cell
```xojo
Sub Cell(w As Double, h As Double = 0, txt As String = "", border As Variant = 0,
         ln As Integer = 0, align As String = "", fill As Boolean = False, link As String = "")
```

**Parameters**:
- `w` - Cell width (0 = extend to right margin)
- `h` - Cell height
- `txt` - Text to display
- `border` - Border style: 0 (none), 1 (all), or "LTRB" combination
- `ln` - Line behavior: 0 (right), 1 (next line), 2 (below)
- `align` - Text alignment: "L" (left), "C" (center), "R" (right)
- `fill` - Fill cell with current fill color
- `link` - URL for hyperlink (future)

**Description**: Outputs a cell (rectangular area) with optional text, borders, and fill.

**Example**:
```xojo
pdf.Cell(40, 10, "Hello", 1, 0, "L")        // Cell with border, move right
pdf.Cell(60, 10, "World", 1, 1, "C", True)  // Filled cell, go to next line
```

**Notes**:
- Text automatically truncated with ellipsis if too wide
- Supports left, center, and right alignment
- Border can be individual sides: "L" (left), "T" (top), "R" (right), "B" (bottom)

##### MultiCell
```xojo
Sub MultiCell(w As Double, h As Double, txt As String, border As Variant = 0,
              align As String = "L", fill As Boolean = False)
```

**Parameters**:
- `w` - Cell width (0 = extend to right margin)
- `h` - Line height for each text line
- `txt` - Text to display (will be wrapped)
- `border` - Border style: 0 (none), 1 (all), or "LTRB" combination
- `align` - Text alignment: "L" (left), "C" (center), "R" (right)
- `fill` - Fill cells with current fill color

**Description**: Outputs text with automatic word wrapping over multiple lines.

**Example**:
```xojo
pdf.MultiCell(100, 6, "This is a long paragraph that will wrap automatically.", 1, "L")
```

**Notes**:
- Automatically splits text to fit within width
- Each line respects specified alignment
- Advances cursor to next line after completion

##### Write
```xojo
Sub Write(h As Double, txt As String, link As String = "")
```

**Parameters**:
- `h` - Line height
- `txt` - Text to output
- `link` - URL for hyperlink (future)

**Description**: Outputs flowing text that wraps automatically at right margin.

**Example**:
```xojo
pdf.Write(5, "The Write method outputs flowing text that automatically wraps.")
```

**Notes**:
- Text flows continuously from current position
- Wraps at right margin
- Ideal for paragraph text with mixed formatting

##### Text
```xojo
Sub Text(x As Double, y As Double, txt As String)
```

**Parameters**:
- `x` - X coordinate
- `y` - Y coordinate
- `txt` - Text to display

**Description**: Outputs text at a specific position without affecting current position.

**Example**:
```xojo
pdf.Text(50, 100, "Positioned text")
```

**Notes**:
- Does not move current position
- Useful for headers, labels, and overlays
- No automatic wrapping

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Graphics Primitives</h2>

##### Line
```xojo
Sub Line(x1 As Double, y1 As Double, x2 As Double, y2 As Double)
```

**Parameters**:
- `x1, y1` - Starting point coordinates
- `x2, y2` - Ending point coordinates

**Description**: Draws a line from point (x1,y1) to point (x2,y2).

**Example**:
```xojo
pdf.Line(10, 10, 100, 10)  // Horizontal line
```

##### Rect
```xojo
Sub Rect(x As Double, y As Double, w As Double, h As Double, style As String = "")
```

**Parameters**:
- `x, y` - Top-left corner coordinates
- `w` - Rectangle width
- `h` - Rectangle height
- `style` - Drawing style: "D" (draw), "F" (fill), "DF" or "FD" (both)

**Description**: Draws a rectangle.

**Example**:
```xojo
pdf.Rect(50, 50, 100, 60, "D")   // Draw outline only
pdf.Rect(50, 50, 100, 60, "F")   // Fill only
pdf.Rect(50, 50, 100, 60, "DF")  // Draw and fill
```

##### Circle
```xojo
Sub Circle(x As Double, y As Double, r As Double, style As String = "D")
```

**Parameters**:
- `x, y` - Center coordinates
- `r` - Radius
- `style` - Drawing style: "D" (draw), "F" (fill), "DF" or "FD" (both)

**Description**: Draws a circle using Bézier curves.

**Example**:
```xojo
pdf.Circle(100, 100, 30, "D")   // Circle outline
pdf.Circle(100, 100, 30, "DF")  // Filled circle with outline
```

##### Ln
```xojo
Sub Ln(h As Double = 0)
```

**Parameters**:
- `h` - Height to move down (0 = current font size)

**Description**: Performs a line break, moving cursor to left margin and down.

**Example**:
```xojo
pdf.Ln()     // Line break with font size
pdf.Ln(10)   // Line break with custom height
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Colors</h2>

##### SetTextColor
```xojo
Sub SetTextColor(r As Integer, g As Integer, b As Integer)
```

**Parameters**:
- `r` - Red component (0-255)
- `g` - Green component (0-255)
- `b` - Blue component (0-255)

**Description**: Sets the color for text output.

**Example**:
```xojo
pdf.SetTextColor(255, 0, 0)  // Red text
```

##### SetFillColor
```xojo
Sub SetFillColor(r As Integer, g As Integer, b As Integer)
```

**Parameters**:
- `r` - Red component (0-255)
- `g` - Green component (0-255)
- `b` - Blue component (0-255)

**Description**: Sets the color for filled shapes and cells.

**Example**:
```xojo
pdf.SetFillColor(200, 220, 255)  // Light blue fill
```

##### SetDrawColor
```xojo
Sub SetDrawColor(r As Integer, g As Integer, b As Integer)
```

**Parameters**:
- `r` - Red component (0-255)
- `g` - Green component (0-255)
- `b` - Blue component (0-255)

**Description**: Sets the color for lines and shape outlines.

**Example**:
```xojo
pdf.SetDrawColor(0, 0, 0)  // Black lines
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Line Styles</h2>

##### SetLineWidth
```xojo
Sub SetLineWidth(width As Double)
```

**Parameters**:
- `width` - Line width in user units

**Description**: Sets the width for line drawing operations.

**Example**:
```xojo
pdf.SetLineWidth(0.5)  // Thin line
pdf.SetLineWidth(3)    // Thick line
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Advanced Graphics</h2>

##### RoundedRect
```xojo
Sub RoundedRect(x As Double, y As Double, w As Double, h As Double, r As Double, corners As String, style As String)
```

**Parameters**:
- `x, y` - Top-left corner coordinates
- `w` - Rectangle width
- `h` - Rectangle height
- `r` - Corner radius
- `corners` - Which corners to round: "1234" (1=TL, 2=TR, 3=BR, 4=BL)
- `style` - Drawing style: "D" (draw), "F" (fill), "DF" or "FD" (both)

**Description**: Draws a rectangle with selectively rounded corners using Bezier curve approximation.

**Example**:
```xojo
// All corners rounded
pdf.RoundedRect(20, 20, 100, 60, 10, "1234", "D")

// Only top corners rounded
pdf.RoundedRect(20, 100, 100, 60, 10, "12", "DF")

// Only left corners rounded
pdf.RoundedRect(20, 180, 100, 60, 10, "14", "F")
```

**Notes**:
- Corner selection uses string "1234" where each digit represents a corner
- 1 = Top-Left, 2 = Top-Right, 3 = Bottom-Right, 4 = Bottom-Left
- Any combination can be specified (e.g., "13" for diagonal corners)
- Uses Bezier curves for smooth rendering

##### RoundedRectExt
```xojo
Sub RoundedRectExt(x As Double, y As Double, w As Double, h As Double, rTL As Double, rTR As Double, rBR As Double, rBL As Double, style As String)
```

**Parameters**:
- `x, y` - Top-left corner coordinates
- `w` - Rectangle width
- `h` - Rectangle height
- `rTL` - Top-left corner radius
- `rTR` - Top-right corner radius
- `rBR` - Bottom-right corner radius
- `rBL` - Bottom-left corner radius
- `style` - Drawing style: "D" (draw), "F" (fill), "DF" or "FD" (both)

**Description**: Draws a rectangle with individually specified corner radii for asymmetric rounding.

**Example**:
```xojo
// Different radius for each corner
pdf.RoundedRectExt(20, 20, 100, 60, 15, 5, 15, 5, "DF")

// Only some corners rounded (set others to 0)
pdf.RoundedRectExt(20, 100, 100, 60, 10, 10, 0, 0, "D")
```

**Notes**:
- Allows complete control over each corner's radius
- Set radius to 0 for square corner
- Useful for complex UI elements

##### Arc
```xojo
Sub Arc(x As Double, y As Double, rx As Double, ry As Double, degRotate As Double, degStart As Double, degEnd As Double, style As String)
```

**Parameters**:
- `x, y` - Arc center coordinates
- `rx` - Horizontal radius
- `ry` - Vertical radius
- `degRotate` - Rotation angle in degrees (rotates entire arc)
- `degStart` - Start angle in degrees (0 = 3 o'clock position)
- `degEnd` - End angle in degrees
- `style` - Drawing style: "D" (draw), "F" (fill), "DF" or "FD" (both)

**Description**: Draws an elliptical arc with optional rotation. Automatically segments for smooth curves.

**Example**:
```xojo
// Quarter circle
pdf.Arc(50, 50, 30, 30, 0, 0, 90, "D")

// Half ellipse (horizontal)
pdf.Arc(100, 50, 40, 20, 0, 0, 180, "D")

// Rotated arc
pdf.Arc(150, 50, 30, 15, 45, 0, 180, "DF")

// Pie slice
pdf.Arc(50, 120, 25, 25, 0, 45, 135, "F")
```

**Notes**:
- Angles in degrees (0-360)
- Circular arcs: use same value for rx and ry
- Elliptical arcs: use different rx and ry values
- Rotation applies to entire arc (useful for tilted ellipses)
- Automatically segments into Bezier curves for smooth rendering

##### Curve
```xojo
Sub Curve(x0 As Double, y0 As Double, cx As Double, cy As Double, x1 As Double, y1 As Double, style As String = "D")
```

**Parameters**:
- `x0, y0` - Starting point coordinates
- `cx, cy` - Control point coordinates
- `x1, y1` - Ending point coordinates
- `style` - Drawing style: "D" (draw), "F" (fill), "DF" or "FD" (both)

**Description**: Draws a quadratic Bezier curve with one control point.

**Example**:
```xojo
// Simple S-curve
pdf.Curve(10, 50, 50, 30, 90, 50, "D")

// Filled curved shape
pdf.SetFillColor(200, 220, 255)
pdf.SetDrawColor(0, 0, 200)
pdf.Curve(10, 70, 50, 60, 90, 70, "DF")
```

**Notes**:
- Quadratic Bezier has one control point affecting the curve
- The curve starts at (x0, y0) and ends at (x1, y1)
- The curve is tangent to the line from start to control point at the start
- The curve is tangent to the line from control point to end at the end
- Uses PDF 'v' operator for quadratic Bezier curves

##### CurveBezierCubic
```xojo
Sub CurveBezierCubic(x0 As Double, y0 As Double, cx0 As Double, cy0 As Double, cx1 As Double, cy1 As Double, x1 As Double, y1 As Double, style As String = "D")
```

**Parameters**:
- `x0, y0` - Starting point coordinates
- `cx0, cy0` - First control point coordinates
- `cx1, cy1` - Second control point coordinates
- `x1, y1` - Ending point coordinates
- `style` - Drawing style: "D" (draw), "F" (fill), "DF" or "FD" (both)

**Description**: Draws a cubic Bezier curve with two control points for more complex curves.

**Example**:
```xojo
// Complex S-curve
pdf.CurveBezierCubic(10, 90, 30, 75, 60, 105, 90, 90, "D")

// Filled wavy shape
pdf.SetFillColor(255, 200, 200)
pdf.SetDrawColor(200, 0, 0)
pdf.CurveBezierCubic(10, 110, 30, 100, 60, 120, 90, 110, "DF")
```

**Notes**:
- Cubic Bezier provides more control with two control points
- The curve starts at (x0, y0) and ends at (x1, y1)
- At start point, curve is tangent to line from (x0, y0) to (cx0, cy0)
- At end point, curve is tangent to line from (cx1, cy1) to (x1, y1)
- Uses PDF 'c' operator for cubic Bezier curves
- More flexible than quadratic curves for complex shapes

##### Arrow
```xojo
Sub Arrow(x1 As Double, y1 As Double, x2 As Double, y2 As Double, startArrow As Boolean = False, endArrow As Boolean = True, arrowSize As Double = 3.0)
```

**Parameters**:
- `x1, y1` - Starting point coordinates
- `x2, y2` - Ending point coordinates
- `startArrow` - Draw arrowhead at start point (default: False)
- `endArrow` - Draw arrowhead at end point (default: True)
- `arrowSize` - Arrowhead size in user units (default: 3.0)

**Description**: Draws a line with arrowhead(s) at one or both ends. Automatically shortens the line to prevent visibility beyond the arrowhead.

**Example**:
```xojo
// Simple arrow (end only)
pdf.Arrow(20, 130, 80, 130, False, True, 3)

// Bidirectional arrow
pdf.SetDrawColor(255, 0, 0)
pdf.SetFillColor(255, 0, 0)
pdf.Arrow(20, 145, 80, 145, True, True, 3)

// Diagonal arrow with larger head
pdf.SetDrawColor(0, 0, 255)
pdf.SetFillColor(0, 0, 255)
pdf.Arrow(20, 160, 60, 180, False, True, 5)
```

**Notes**:
- Arrowhead angle is 30 degrees (Pi/6)
- Line is automatically shortened to prevent visibility beyond arrowhead
- Arrowhead depth calculated using cos(30°) ≈ 0.866
- Arrowheads are filled triangles using current fill color
- Works with all line styles (width, cap, dash patterns)
- Current draw color is used for line, current fill color for arrowheads

##### Polygon

```xojo
Sub Polygon(points() As Point, style As String = "D")
```

**Parameters**:
- `points` - Array of Point objects defining the polygon vertices
- `style` - Drawing style: "D" (outline), "F" (fill), "DF"/"FD" (both)

**Description**: Draws a closed polygon using the provided array of Point objects. The path is automatically closed and properly handles line joins at all corners.

**Example**:
```xojo
// Triangle (outline only)
Dim triangle() As Point
triangle.Add(New Point(30, 80))
triangle.Add(New Point(60, 80))
triangle.Add(New Point(45, 60))
pdf.SetDrawColor(255, 0, 0)
pdf.Polygon(triangle, "D")

// Pentagon (filled)
Dim pentagon() As Point
pentagon.Add(New Point(80, 80))
pentagon.Add(New Point(100, 75))
pentagon.Add(New Point(95, 55))
pentagon.Add(New Point(70, 55))
pentagon.Add(New Point(65, 75))
pdf.SetFillColor(0, 200, 100)
pdf.Polygon(pentagon, "F")

// Hexagon (filled and outlined)
Dim hexagon() As Point
hexagon.Add(New Point(120, 80))
hexagon.Add(New Point(140, 75))
hexagon.Add(New Point(140, 60))
hexagon.Add(New Point(120, 55))
hexagon.Add(New Point(100, 60))
hexagon.Add(New Point(100, 75))
pdf.SetDrawColor(0, 0, 128)
pdf.SetFillColor(200, 220, 255)
pdf.SetLineWidth(2)
pdf.Polygon(hexagon, "DF")
```

**Notes**:
- Requires minimum of 3 points to form a polygon
- Uses PDF `s` (close and stroke) and `b` (close, fill and stroke) operators for proper line joins
- Works with all line styles (width, cap, join, dash patterns)
- Line join style affects corner appearance (miter, round, bevel)
- Cross-platform compatible (Desktop, Web, iOS, Console)

##### SetAlpha
```xojo
Sub SetAlpha(alpha As Double, blendMode As String = "")
```

**Parameters**:
- `alpha` - Transparency level (0.0 = fully transparent, 1.0 = fully opaque)
- `blendMode` - Blend mode (default: "Normal")

**Description**: Sets transparency and blend mode for subsequent drawing operations.

**Supported Blend Modes**:
- Normal, Multiply, Screen, Overlay
- Darken, Lighten, ColorDodge, ColorBurn
- HardLight, SoftLight, Difference, Exclusion
- Hue, Saturation, Color, Luminosity

**Example**:
```xojo
// Opaque red rectangle
pdf.SetAlpha(1.0, "Normal")
pdf.SetFillColor(255, 0, 0)
pdf.Rect(20, 20, 60, 40, "F")

// Semi-transparent green rectangle (overlapping)
pdf.SetAlpha(0.5, "Normal")
pdf.SetFillColor(0, 255, 0)
pdf.Rect(40, 30, 60, 40, "F")

// Multiply blend mode
pdf.SetAlpha(0.7, "Multiply")
pdf.SetFillColor(0, 0, 255)
pdf.Rect(60, 40, 60, 40, "F")

// Reset to opaque
pdf.SetAlpha(1.0, "Normal")
```

**Notes**:
- Requires PDF 1.4 or later (automatically set)
- Affects both fill and stroke operations
- Blend modes control how overlapping colors interact
- Performance impact increases with transparency

##### GetAlpha
```xojo
Function GetAlpha() As Double
```

**Returns**: Current alpha transparency value (0.0 - 1.0)

**Description**: Returns the current transparency level.

**Example**:
```xojo
Dim currentAlpha As Double = pdf.GetAlpha()
If currentAlpha < 1.0 Then
    // Transparency is active
End If
```

##### GetBlendMode
```xojo
Function GetBlendMode() As String
```

**Returns**: Current blend mode name

**Description**: Returns the current blend mode.

**Example**:
```xojo
Dim mode As String = pdf.GetBlendMode()
// Returns: "Normal", "Multiply", "Screen", etc.
```

---

#### Gradients
```xojo
Sub SetDashPattern(dashArray() As Double, dashPhase As Double)
```

**Parameters**:
- `dashArray` - Array of dash and gap lengths (in user units)
- `dashPhase` - Offset into dash pattern to start (default: 0)

**Description**: Sets a custom dash pattern for line drawing.

**Example**:
```xojo
// Simple dash: 5 on, 3 off
Dim dash1() As Double = Array(5.0, 3.0)
pdf.SetDashPattern(dash1, 0)
pdf.Line(20, 50, 170, 50)

// Complex pattern: 10 on, 2 off, 2 on, 2 off
Dim dash2() As Double = Array(10.0, 2.0, 2.0, 2.0)
pdf.SetDashPattern(dash2, 0)
pdf.Line(20, 70, 170, 70)

// Dotted line
Dim dots() As Double = Array(1.0, 2.0)
pdf.SetDashPattern(dots, 0)
pdf.Line(20, 90, 170, 90)

// Reset to solid line
Dim solid() As Double
pdf.SetDashPattern(solid, 0)
```

**Notes**:
- Array alternates between dash length and gap length
- Empty array resets to solid line
- Phase parameter shifts pattern start point
- Pattern repeats along entire line

##### SetAlpha
```xojo
Sub SetAlpha(alpha As Double, blendMode As String = "")
```

**Parameters**:
- `alpha` - Transparency level (0.0 = fully transparent, 1.0 = fully opaque)
- `blendMode` - Blend mode (default: "Normal")

**Description**: Sets transparency and blend mode for subsequent drawing operations.

**Supported Blend Modes**:
- Normal, Multiply, Screen, Overlay
- Darken, Lighten, ColorDodge, ColorBurn
- HardLight, SoftLight, Difference, Exclusion
- Hue, Saturation, Color, Luminosity

**Example**:
```xojo
// Opaque red rectangle
pdf.SetAlpha(1.0, "Normal")
pdf.SetFillColor(255, 0, 0)
pdf.Rect(20, 20, 60, 40, "F")

// Semi-transparent green rectangle (overlapping)
pdf.SetAlpha(0.5, "Normal")
pdf.SetFillColor(0, 255, 0)
pdf.Rect(40, 30, 60, 40, "F")

// Multiply blend mode
pdf.SetAlpha(0.7, "Multiply")
pdf.SetFillColor(0, 0, 255)
pdf.Rect(60, 40, 60, 40, "F")

// Reset to opaque
pdf.SetAlpha(1.0, "Normal")
```

**Notes**:
- Requires PDF 1.4 or later (automatically set)
- Affects both fill and stroke operations
- Blend modes control how overlapping colors interact
- Performance impact increases with transparency

##### GetAlpha
```xojo
Function GetAlpha() As Double
```

**Returns**: Current alpha transparency value (0.0 - 1.0)

**Description**: Returns the current transparency level.

**Example**:
```xojo
Dim currentAlpha As Double = pdf.GetAlpha()
If currentAlpha < 1.0 Then
    // Transparency is active
End If
```

##### GetBlendMode
```xojo
Function GetBlendMode() As String
```

**Returns**: Current blend mode name

**Description**: Returns the current blend mode.

**Example**:
```xojo
Dim mode As String = pdf.GetBlendMode()
// Returns: "Normal", "Multiply", "Screen", etc.
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Gradients</h2>

##### LinearGradient
```xojo
Sub LinearGradient(x As Double, y As Double, w As Double, h As Double, r1 As Integer, g1 As Integer, b1 As Integer, r2 As Integer, g2 As Integer, b2 As Integer, x1 As Double, y1 As Double, x2 As Double, y2 As Double)
```

**Parameters**:
- `x, y` - Rectangle position (top-left corner)
- `w, h` - Rectangle dimensions
- `r1, g1, b1` - Start color RGB values (0-255)
- `r2, g2, b2` - End color RGB values (0-255)
- `x1, y1` - Gradient start point (normalized 0-1)
- `x2, y2` - Gradient end point (normalized 0-1)

**Description**: Fills a rectangle with a linear gradient using PDF shading patterns.

**Gradient Vector Examples**:
- `(0, 0, 1, 0)` - Left to right
- `(0, 0, 0, 1)` - Top to bottom
- `(0, 0, 1, 1)` - Diagonal top-left to bottom-right
- `(0.5, 0, 0.5, 1)` - Vertical centered

**Example**:
```xojo
// Horizontal gradient (red to blue)
pdf.LinearGradient(20, 20, 80, 40, 255, 0, 0, 0, 0, 255, 0, 0, 1, 0)

// Vertical gradient (yellow to green)
pdf.LinearGradient(20, 80, 80, 40, 255, 255, 0, 0, 255, 0, 0, 0, 0, 1)

// Diagonal gradient
pdf.LinearGradient(20, 140, 80, 40, 255, 0, 255, 0, 255, 255, 0, 0, 1, 1)
```

**Notes**:
- Uses PDF Type 2 shading patterns
- Gradient vectors use normalized coordinates (0.0 to 1.0)
- Colors interpolated automatically by PDF viewer
- Coordinates are relative to the rectangle

##### RadialGradient
```xojo
Sub RadialGradient(x As Double, y As Double, w As Double, h As Double, r1 As Integer, g1 As Integer, b1 As Integer, r2 As Integer, g2 As Integer, b2 As Integer, x1 As Double, y1 As Double, x2 As Double, y2 As Double, r As Double)
```

**Parameters**:
- `x, y` - Rectangle position (top-left corner)
- `w, h` - Rectangle dimensions
- `r1, g1, b1` - Inner color RGB values (0-255)
- `r2, g2, b2` - Outer color RGB values (0-255)
- `x1, y1` - Inner circle center (normalized 0-1)
- `x2, y2` - Outer circle center (normalized 0-1)
- `r` - Outer circle radius (normalized 0-1)

**Description**: Fills a rectangle with a radial gradient using PDF dual-circle shading patterns.

**Example**:
```xojo
// Center radial gradient (white to blue)
pdf.RadialGradient(20, 20, 80, 60, 255, 255, 255, 0, 0, 255, 0.5, 0.5, 0.5, 0.5, 0.5)

// Off-center radial gradient
pdf.RadialGradient(20, 100, 80, 60, 255, 200, 0, 200, 0, 255, 0.3, 0.3, 0.7, 0.7, 0.6)

// Spotlight effect (different inner and outer centers)
pdf.RadialGradient(20, 180, 80, 60, 255, 255, 200, 100, 100, 100, 0.3, 0.2, 0.7, 0.8, 0.7)
```

**Notes**:
- Uses PDF Type 3 shading patterns
- Coordinates are normalized relative to rectangle (0.0 to 1.0)
- Creates smooth color transition from inner to outer circle
- Inner and outer circles can have different centers for asymmetric effects

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Clipping Paths</h2>

##### ClipRect
```xojo
Sub ClipRect(x As Double, y As Double, w As Double, h As Double, outline As Boolean)
```

**Parameters**:
- `x, y` - Rectangle position (top-left corner)
- `w, h` - Rectangle dimensions
- `outline` - Draw rectangle outline (true) or invisible clip (false)

**Description**: Creates a rectangular clipping path. All subsequent drawing operations are confined within this rectangle until ClipEnd() is called.

**Example**:
```xojo
// Create invisible clipping region
pdf.ClipRect(20, 20, 100, 80, False)

// Draw circle (only visible inside clip region)
pdf.SetFillColor(255, 0, 0)
pdf.Circle(70, 60, 50, "F")

// Restore graphics state
pdf.ClipEnd()
```

**Notes**:
- Clipping paths can be nested (call ClipEnd() for each clip)
- Outline parameter draws the clip region border
- Graphics state saved automatically with 'q' operator

##### ClipCircle
```xojo
Sub ClipCircle(x As Double, y As Double, r As Double, outline As Boolean)
```

**Parameters**:
- `x, y` - Circle center coordinates
- `r` - Circle radius
- `outline` - Draw circle outline (true) or invisible clip (false)

**Description**: Creates a circular clipping path.

**Example**:
```xojo
// Circular photo frame effect
pdf.ClipCircle(100, 100, 40, True)
pdf.Image("photo.jpg", 60, 60, 80, 80)
pdf.ClipEnd()
```

##### ClipEllipse
```xojo
Sub ClipEllipse(x As Double, y As Double, rx As Double, ry As Double, outline As Boolean)
```

**Parameters**:
- `x, y` - Ellipse center coordinates
- `rx` - Horizontal radius
- `ry` - Vertical radius
- `outline` - Draw ellipse outline (true) or invisible clip (false)

**Description**: Creates an elliptical clipping path using Bezier curve approximation.

**Example**:
```xojo
// Elliptical gradient clipping
pdf.ClipEllipse(100, 100, 60, 40, False)
pdf.LinearGradient(40, 60, 120, 80, 255, 200, 0, 0, 100, 200, 0, 0, 1, 1)
pdf.ClipEnd()
```

##### ClipText
```xojo
Sub ClipText(x As Double, y As Double, txt As String, outline As Boolean)
```

**Parameters**:
- `x, y` - Text baseline position
- `txt` - Text string to use as clipping shape
- `outline` - Draw text outline (true) or invisible clip (false)

**Description**: Creates a text-shaped clipping path. Uses current font and size.

**Example**:
```xojo
// Text with gradient fill
pdf.SetFont("helvetica", "B", 48)
pdf.ClipText(20, 80, "XOJO", True)
pdf.LinearGradient(20, 40, 120, 50, 255, 0, 255, 0, 255, 255, 0, 0, 1, 1)
pdf.ClipEnd()
```

**Notes**:
- Uses PDF text rendering mode 7 (clip)
- Font must be set before calling ClipText()
- Outline mode uses rendering mode 1 for visible text

##### ClipRoundedRect
```xojo
Sub ClipRoundedRect(x As Double, y As Double, w As Double, h As Double, r As Double, corners As String, outline As Boolean)
```

**Parameters**:
- `x, y` - Rectangle position (top-left corner)
- `w, h` - Rectangle dimensions
- `r` - Corner radius
- `corners` - Which corners to round (e.g., "1234" or "13")
- `outline` - Draw outline (true) or invisible clip (false)

**Description**: Creates a rounded rectangle clipping path with selective corner rounding.

**Corner Numbering**:
- "1" = Top-left
- "2" = Top-right
- "3" = Bottom-right
- "4" = Bottom-left

**Example**:
```xojo
// Rounded rectangle with all corners
pdf.ClipRoundedRect(20, 20, 100, 60, 10, "1234", False)
pdf.RadialGradient(20, 20, 100, 60, 255, 255, 255, 100, 100, 255, 0.5, 0.5, 0.5, 0.5, 0.7)
pdf.ClipEnd()

// Only round top corners
pdf.ClipRoundedRect(20, 100, 100, 60, 10, "12", True)
pdf.SetFillColor(200, 200, 255)
pdf.Rect(20, 100, 100, 60, "F")
pdf.ClipEnd()
```

##### ClipPolygon
```xojo
Sub ClipPolygon(points() As Pair, outline As Boolean)
```

**Parameters**:
- `points` - Array of Pair objects with x, y coordinates
- `outline` - Draw polygon outline (true) or invisible clip (false)

**Description**: Creates a polygon clipping path from multiple points.

**Example**:
```xojo
// Star-shaped clipping
Dim points() As Pair
points.Append(New Pair(100, 20))
points.Append(New Pair(110, 60))
points.Append(New Pair(150, 70))
points.Append(New Pair(120, 100))
points.Append(New Pair(130, 140))
points.Append(New Pair(100, 120))
points.Append(New Pair(70, 140))
points.Append(New Pair(80, 100))
points.Append(New Pair(50, 70))
points.Append(New Pair(90, 60))

pdf.ClipPolygon(points, False)
pdf.RadialGradient(50, 20, 100, 120, 255, 255, 0, 255, 100, 0, 0.5, 0.3, 0.5, 0.7, 0.5)
pdf.ClipEnd()
```

**Notes**:
- Minimum 3 points required for valid polygon
- Automatically closes path (connects last to first point)
- Uses Pair objects for coordinate storage

##### ClipEnd
```xojo
Sub ClipEnd()
```

**Description**: Ends the current clipping path and restores the previous graphics state. Must be called once for each clipping operation.

**Example**:
```xojo
// Nested clipping
pdf.ClipRect(20, 20, 150, 150, False)
pdf.ClipCircle(95, 95, 60, False)
// ... drawing operations confined to rect AND circle intersection ...
pdf.ClipEnd()  // Exit circle clip
pdf.ClipEnd()  // Exit rect clip
```

**Notes**:
- Restores graphics state with 'Q' operator
- Decrements internal clipping nest counter
- Safe to call even without active clipping (no effect)
- Clipping paths can be nested up to PDF viewer limits

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Output</h2>

##### SaveToFile
```xojo
Sub SaveToFile(f As FolderItem)
```

**Parameters**:
- `f` - FolderItem for output file

**Description**: Generates and saves the PDF to a file.

**Example**:
```xojo
Dim f As FolderItem = SpecialFolder.Desktop.Child("output.pdf")
pdf.SaveToFile(f)
```

##### GetBytes
```xojo
Function GetBytes() As String
```

**Returns**: PDF document as binary string

**Description**: Generates and returns the PDF as a binary string for custom handling.

**Example**:
```xojo
Dim pdfData As String = pdf.GetBytes()
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Images</h2>

##### Image
```xojo
Sub Image(imageFilePath As String, x As Double, y As Double, w As Double, h As Double)
```

**Parameters**:
- `imageFilePath` - Path to image file (JPEG or PNG)
- `x` - X coordinate of top-left corner
- `y` - Y coordinate of top-left corner
- `w` - Image width (0 = auto-calculate from height)
- `h` - Image height (0 = auto-calculate from width)

**Description**: Embeds and displays a JPEG or PNG image in the PDF. Images are automatically registered and can be reused multiple times.

**Example**:
```xojo
// Display image with explicit dimensions
pdf.Image("photo.jpg", 10, 20, 100, 75)

// Auto-calculate height from width (maintains aspect ratio)
pdf.Image("photo.jpg", 10, 20, 100, 0)

// Auto-calculate width from height
pdf.Image("photo.jpg", 10, 20, 0, 75)
```

**Notes**:
- Supports JPEG and PNG formats
- Images are embedded once and can be reused
- Auto-dimension calculation maintains aspect ratio
- Images are stored as XObject resources

##### Emoji
```xojo
Sub Emoji(emojiChar As String, x As Double, y As Double, sizeInUserUnits As Double)
```

**Parameters**:
- `emojiChar` - A single emoji character (e.g., "😀", "🎨", "🚀")
- `x` - X coordinate of emoji position
- `y` - Y coordinate of emoji position
- `sizeInUserUnits` - Size of emoji in current units (mm/cm/inches/points)

**Description**: Adds a color emoji to the PDF at the specified position. The emoji is rendered using the platform's native emoji font (Apple Color Emoji on macOS, Segoe UI Emoji on Windows, Noto Color Emoji on Linux), converted to a PNG image, and embedded in the PDF. All temporary files and conversions are handled automatically.

**Example**:
```xojo
// Add emoji at position with 10mm size
pdf.Emoji("😀", 20, 30, 10)

// Add multiple emoji in a row
Dim x As Double = 20
pdf.Emoji("🎨", x, 40, 8)
pdf.Emoji("🚀", x + 10, 40, 8)
pdf.Emoji("💡", x + 20, 40, 8)
```

**Notes**:
- **Platform Support**: Desktop ✅, iOS planned ⚠️, Web planned ⚠️, Console never ❌
- Console platform has no graphics rendering capability (no Picture/Canvas API)
- Desktop/iOS/Web use OS's native emoji font (Apple Color Emoji, Segoe UI Emoji, Noto Color Emoji)
- Automatic temp file management with unique filenames
- Size parameter uses document units (same as SetFont size)
- No manual Picture/Graphics API calls required
- Platform emoji fonts provide full color rendering

##### RegisterImage
```xojo
Sub RegisterImage(imagePath As String, imageKey As String)
```

**Parameters**:
- `imagePath` - Path to image file
- `imageKey` - Unique key for referencing this image

**Description**: Pre-registers an image without displaying it. Useful for optimizing multi-use images.

**Example**:
```xojo
// Register logo once
pdf.RegisterImage("logo.png", "company_logo")

// Use multiple times with Image()
pdf.Image("logo.png", 10, 10, 30, 0)  // Header
pdf.Image("logo.png", 10, 270, 30, 0) // Footer
```

**Notes**:
- Images are automatically registered on first use
- Explicit registration can improve performance
- Same image used multiple times only stored once

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Security & Encryption</h2>

##### SetProtection
```xojo
Sub SetProtection(userPassword As String, ownerPassword As String = "", allowPrint As Boolean = True, allowModify As Boolean = True, allowCopy As Boolean = True, allowAnnotations As Boolean = True, revision As Integer = 3)
```

**Parameters**:
- `userPassword` - Password required to open the document (empty = no user password)
- `ownerPassword` - Password to change permissions (defaults to userPassword if empty)
- `allowPrint` - Allow printing the document
- `allowModify` - Allow document modification
- `allowCopy` - Allow text/graphics copying
- `allowAnnotations` - Allow annotations and form field entries
- `revision` - Encryption revision (2=40-bit RC4, 3=128-bit RC4, 4=128-bit AES, 5=256-bit AES, 6=256-bit AES PDF 2.0)

**Description**: Enables PDF encryption with password protection and permission restrictions.

**Example**:
```xojo
// RC4-128 encryption with user password only
pdf.SetProtection("secret123", "", True, False, False, False, 3)

// AES-128 encryption with both passwords
pdf.SetProtection("userpass", "ownerpass", True, False, True, True, 4)

// Full restrictions (no password required to open)
pdf.SetProtection("", "ownerpass", False, False, False, False, 3)
```

**Notes**:
- **Revision 3 (RC4-128) recommended** - Works reliably in all PDF viewers
- **Revisions 4-6 (AES)** - Currently not working due to Xojo Crypto API PKCS7 padding limitation
- User password restricts document opening
- Owner password allows changing permissions
- Automatically upgrades PDF version (1.4+ for Revision 3, 1.6+ for Revision 4, 1.7+ for Revision 5-6)
- Adobe Acrobat shows warning for deprecated RC4 (expected behavior)

##### SetEncryption
```xojo
Sub SetEncryption(encryption As VNSPDFEncryption)
```

**Parameters**:
- `encryption` - Pre-configured VNSPDFEncryption object

**Description**: Enables PDF encryption using a pre-configured VNSPDFEncryption object for advanced control.

**Example**:
```xojo
// Advanced encryption configuration
Dim enc As New VNSPDFEncryption(3)  // Revision 3
enc.SetPasswords("user123", "owner456")
enc.SetPermissions(True, False, True, True)  // Print and copy allowed
pdf.SetEncryption(enc)
```

**Notes**:
- Allows more granular permission control
- Use SetProtection() for simple cases
- PDF version automatically upgraded based on revision

##### GetVersionString
```xojo
Function GetVersionString() As String
```

**Returns**: Version string in format "VNS PDF x.x.x"

**Description**: Returns the VNS PDF library version string.

**Example**:
```xojo
Dim version As String = pdf.GetVersionString()
// Returns: "VNS PDF 1.0.0"
```

##### GetConversionRatio
```xojo
Function GetConversionRatio() As Double
```

**Returns**: Scale factor from user units to points

**Description**: Returns the conversion ratio (k) used to convert user units (mm/cm/inches) to PDF points.

**Example**:
```xojo
Dim ratio As Double = pdf.GetConversionRatio()
// For mm: returns 2.8346 (1 mm = 2.8346 points)
// For cm: returns 28.346
// For inches: returns 72.0
```

**Notes**:
- Essential for raw PDF commands that require point coordinates
- Used internally for all coordinate conversions

##### GetPageSizeStr
```xojo
Function GetPageSizeStr(sizeStr As String) As Pair
```

**Parameters**:
- `sizeStr` - Page size string ("A4", "Letter", "A5", "A3", "Legal")

**Returns**: Pair(width, height) in user units, or Nil if invalid

**Description**: Parses a page size string and returns dimensions in current user units.

**Example**:
```xojo
Dim a4Size As Pair = pdf.GetPageSizeStr("a4")
If a4Size <> Nil Then
  Dim width As Double = a4Size.Left   // 210.00 mm
  Dim height As Double = a4Size.Right // 297.00 mm
End If
```

**Notes**:
- Case-insensitive ("A4", "a4", "A4" all work)
- Returns dimensions in current user units (mm/cm/inches/points)
- Sets error if size string not recognized

##### RawWriteStr
```xojo
Sub RawWriteStr(str As String)
```

**Parameters**:
- `str` - Raw PDF command string

**Description**: Writes raw PDF commands directly to the current page buffer. This is a low-level function for advanced PDF construction requiring direct access to PDF operators.

**Example**:
```xojo
// Draw a red line using raw PDF commands
Call pdf.RawWriteStr("q")              // Save graphics state
Call pdf.RawWriteStr("1 0 0 RG")       // Red stroke color
Call pdf.RawWriteStr("3 w")            // 3 point line width
Call pdf.RawWriteStr("50 400 m")       // Move to (50, 400) in PDF points
Call pdf.RawWriteStr("250 400 l")      // Line to (250, 400)
Call pdf.RawWriteStr("S")              // Stroke
Call pdf.RawWriteStr("Q")              // Restore graphics state
```

**Notes**:
- Requires understanding of PDF specification
- Coordinates must be in PDF points (use GetConversionRatio() to convert)
- Y coordinates measured from bottom of page
- Writes to mBuffer (current page working buffer)
- Sets error if no page is active

##### Close
```xojo
Sub Close()
```

**Description**: Validates clip/transform nesting and closes the document. Automatically called by Output() and SaveToFile().

**Example**:
```xojo
// Explicit close (usually not needed)
pdf.Close()
If pdf.Err() Then
  MessageBox pdf.GetError()
End If
```

**Notes**:
- Checks for unclosed clip operations
- Called automatically by output methods
- Sets error if clip nesting invalid
- Adds empty page if document has no pages

##### ToJSON
```xojo
Function ToJSON(prettyPrint As Boolean = False) As String
```

**Parameters**:
- `prettyPrint` - If True, formats JSON with indentation for readability

**Returns**: JSON string representation of document state

**Description**: Serializes the current document configuration and state (metadata, page settings, position, colors, fonts) to a JSON string. Does not include page content or binary data.

**Example**:
```xojo
// Get JSON representation
Dim jsonState As String = pdf.ToJSON(True)  // Pretty-printed
// Save to file
Dim f As FolderItem = SpecialFolder.Desktop.Child("doc_state.json")
Dim stream As TextOutputStream = TextOutputStream.Create(f)
stream.Write(jsonState)
stream.Close()
```

**JSON Structure**:
```json
{
  "version": "1.0.0",
  "title": "My Document",
  "author": "John Doe",
  "pageWidth": 210.00,
  "pageHeight": 297.00,
  "currentX": 10.0,
  "currentY": 20.0,
  "drawColor": {"r": 0, "g": 0, "b": 0},
  "fillColor": {"r": 255, "g": 255, "b": 255},
  "textColor": {"r": 0, "g": 0, "b": 0},
  ...
}
```

**Notes**:
- Captures document configuration, not content
- Useful for saving/restoring document settings
- Page content and binary data (fonts, images) not serialized

##### FromJSON
```xojo
Sub FromJSON(jsonStr As String)
```

**Parameters**:
- `jsonStr` - JSON string created by ToJSON()

**Description**: Deserializes document state from a JSON string, restoring metadata, page configuration, position, colors, and font settings.

**Example**:
```xojo
// Restore document state
Dim f As FolderItem = SpecialFolder.Desktop.Child("doc_state.json")
Dim stream As TextInputStream = TextInputStream.Open(f)
Dim jsonState As String = stream.ReadAll()
stream.Close()

pdf.FromJSON(jsonState)
If pdf.Err() Then
  MessageBox "Failed to restore state: " + pdf.GetError()
End If
```

**Notes**:
- Restores configuration only, not page content
- Sets error if JSON parsing fails
- Use with ToJSON() for state persistence
- Font objects and images must be re-added separately

---

## VNSPDFGradient

**Location**: `PDF_Library/Core/VNSPDFGradient.xojo_code`

Internal class for storing gradient shading pattern data. Used by LinearGradient() and RadialGradient() methods.

### Properties

#### tp
```xojo
Property tp As Integer
```
Gradient type:
- `2` = Linear gradient (Type 2 shading)
- `3` = Radial gradient (Type 3 shading)

#### clr1Str
```xojo
Property clr1Str As String
```
Start/inner color representation (e.g., "0.5 0 0" for RGB).

#### clr2Str
```xojo
Property clr2Str As String
```
End/outer color representation (e.g., "0 0 1" for RGB).

#### x1, y1
```xojo
Property x1 As Double
Property y1 As Double
```
Starting point coordinates (normalized 0-1) or inner circle center for radial gradients.

#### x2, y2
```xojo
Property x2 As Double
Property y2 As Double
```
Ending point coordinates (normalized 0-1) or outer circle center for radial gradients.

#### r
```xojo
Property r As Double
```
Outer circle radius for radial gradients (normalized 0-1). Not used for linear gradients.

#### objNum
```xojo
Property objNum As Integer = 0
```
PDF object number assigned to this gradient shading pattern during PDF generation.

### Notes

- This class is **internal** and should not be instantiated directly by users
- Gradient objects are created automatically by LinearGradient() and RadialGradient() methods
- Gradient data is stored in the document's gradient list (mGradientList array)
- PDF output generated during PutGradients() phase
- Each gradient becomes a PDF shading pattern resource
- Coordinates are normalized (0.0 to 1.0) relative to the gradient rectangle

---

## VNSPDFEncryption

**Location**: `PDF_Library/Core/VNSPDFEncryption.xojo_code`

Handles PDF encryption and security with password protection and permission restrictions.

### Constructor

```xojo
Sub Constructor(revision As Integer = 3)
```

**Parameters**:
- `revision` - Encryption revision (2, 3, 4, 5, or 6). Default: 3 (RC4-128)

**Encryption Revisions**:
- **Revision 2**: 40-bit RC4 (DEPRECATED - insecure)
- **Revision 3**: 128-bit RC4 (RECOMMENDED - works reliably)
- **Revision 4**: 128-bit AES-CBC (PDF 1.6) - Not working due to Xojo limitation
- **Revision 5**: 256-bit AES-CBC (PDF 1.7 Ext 3) - Not working due to Xojo limitation
- **Revision 6**: 256-bit AES-CBC (PDF 2.0) - Not working due to Xojo limitation

**Description**: Creates an encryption object with specified security level.

**Example**:
```xojo
// Recommended: RC4-128 encryption
Dim enc As New VNSPDFEncryption(3)

// Legacy: 40-bit RC4 (not recommended)
Dim enc2 As New VNSPDFEncryption(2)
```

### Methods

##### SetPasswords
```xojo
Sub SetPasswords(userPassword As String, ownerPassword As String)
```

**Parameters**:
- `userPassword` - Password to open the document (empty = no password required)
- `ownerPassword` - Password to change permissions

**Description**: Sets the user and owner passwords for the encrypted document.

**Example**:
```xojo
enc.SetPasswords("user123", "owner456")
enc.SetPasswords("", "owner456")  // No user password, owner password only
```

**Notes**:
- User password restricts opening the document
- Owner password allows changing permissions
- Both can be the same for simple use cases

##### SetPermissions
```xojo
Sub SetPermissions(allowPrint As Boolean, allowModify As Boolean, allowCopy As Boolean, allowAnnotations As Boolean)
```

**Parameters**:
- `allowPrint` - Allow printing the document
- `allowModify` - Allow content modification
- `allowCopy` - Allow text/graphics copying
- `allowAnnotations` - Allow annotations and form filling

**Description**: Sets permission flags for the encrypted document.

**Example**:
```xojo
// Read-only with printing
enc.SetPermissions(True, False, False, False)

// Full restrictions
enc.SetPermissions(False, False, False, False)

// Print and copy only
enc.SetPermissions(True, False, True, False)
```

##### GenerateKeys
```xojo
Sub GenerateKeys(fileID As String)
```

**Parameters**:
- `fileID` - PDF file ID (MD5 hash) used in key derivation

**Description**: Generates encryption keys and password entries. Called internally by VNSPDFDocument before outputting pages.

**Example** (internal use):
```xojo
// Called by VNSPDFDocument.Output()
enc.GenerateKeys(mFileID)
```

##### EncryptObject
```xojo
Function EncryptObject(plaintext As String, objectNumber As Integer, generationNumber As Integer) As String
```

**Parameters**:
- `plaintext` - Unencrypted data to encrypt
- `objectNumber` - PDF object number
- `generationNumber` - PDF generation number (usually 0)

**Returns**: Encrypted data as binary string

**Description**: Encrypts a PDF object using object-specific encryption keys.

**Example** (internal use):
```xojo
// Called by VNSPDFDocument for each stream/string object
Dim encrypted As String = enc.EncryptObject(streamData, objectNum, 0)
```

**Notes**:
- Each PDF object encrypted with unique key (derived from object number)
- RC4: Stream cipher encryption
- AES: Block cipher with random IV and PKCS7 padding

##### GetEncryptionDictionary
```xojo
Function GetEncryptionDictionary() As String
```

**Returns**: PDF encryption dictionary string

**Description**: Generates the PDF encryption dictionary for the document trailer.

**Example** (internal use):
```xojo
// Called by VNSPDFDocument.PutEncryption()
Dim encDict As String = enc.GetEncryptionDictionary()
```

**Dictionary Contents**:
- `/Filter /Standard` - Standard security handler
- `/V` - Version number (1, 2, 4, or 5)
- `/R` - Revision number (2, 3, 4, 5, or 6)
- `/O` - Owner password entry (32 or 48 bytes)
- `/U` - User password entry (32 or 48 bytes)
- `/P` - Permission flags integer
- `/Length` - Key length in bits (40, 128, or 256)
- `/CF`, `/StmF`, `/StrF` - Crypt filters (for AES)

### Properties

#### Revision (Read-Only)
```xojo
Property Revision As Integer
```
Returns the encryption revision (2, 3, 4, 5, or 6).

#### Algorithm (Read-Only)
```xojo
Property Algorithm As String
```
Returns the encryption algorithm name ("RC4-40", "RC4-128", "AES-128", "AES-256").

#### Encrypted (Read-Only)
```xojo
Property Encrypted As Boolean
```
Returns true if encryption keys have been generated.

### Implementation Details

**Key Derivation** (Revision 3):
1. Pad user password to 32 bytes with PDF standard padding
2. Concatenate: padded password + owner entry + permissions + file ID
3. MD5 hash the concatenation
4. Iterate 50 times: hash = MD5(hash[0:keyLength])
5. First 16 bytes = encryption key

**Password Entry Computation** (Revision 3):
1. Encrypt standard padding with user password-derived key
2. Iterate 20 times with modified keys (key XOR iteration byte)
3. Result: 32-byte owner entry and user entry

**Object Encryption**:
1. Derive object key: MD5(base key + object# + generation#)
2. RC4: Encrypt with object key
3. AES: Generate random 16-byte IV, encrypt with PKCS7 padding, prepend IV

**Permission Flags**:
- Bit 3 (0x004): Print
- Bit 4 (0x008): Modify content
- Bit 5 (0x010): Copy text/graphics
- Bit 6 (0x020): Add/modify annotations
- Bit 9 (0x100): Fill forms
- Bit 10 (0x200): Extract for accessibility
- Bit 11 (0x400): Assemble document
- Bit 12 (0x800): High-quality print

### Known Limitations

**AES Encryption (Revisions 4-6)**:
- Xojo's `Crypto.AESEncrypt` always adds PKCS7 padding
- Cannot be disabled via API parameters
- Results in password entries growing from 32 bytes to 672+ bytes
- PDF viewers reject oversized password entries
- **Workaround**: Use Revision 3 (RC4-128) which works reliably

**Security Considerations**:
- RC4 is deprecated but still widely supported
- Adobe Acrobat shows warning for RC4 (expected behavior)
- For maximum security, AES-256 would be preferred (pending Xojo API fix)
- File ID must be random/unique for security (uses Microseconds + metadata)

### Notes

- **UPDATE v1.0.0**: All encryption revisions now fully working via pure Xojo AES implementation
- AES-128 (Revision 4) and AES-256 (Revisions 5-6) production-ready
- Permission restrictions enforced by PDF viewers
- Compatible with PDF/A when properly declared in XMP metadata

---

## 📥 PDF Import Classes

### VNSPDFReader

**Purpose**: Main PDF parser for importing pages from existing PDF files.

**Location**: `PDF_Library/Import/VNSPDFReader.xojo_code`

#### Constructor
```xojo
Sub Constructor()
```
Creates a new PDF reader instance.

#### OpenFile
```xojo
Function OpenFile(pdfFile As FolderItem) As Boolean
```
Opens and parses a PDF file.

**Process**:
1. Reads entire file into MemoryBlock
2. Locates and parses cross-reference table (xref)
3. Reads trailer to find document catalog
4. Traverses page tree to build page list

**Returns**: True if successful, False on error

**Example**:
```xojo
Dim reader As New VNSPDFReader
Dim pdfFile As FolderItem = New FolderItem("/path/to/file.pdf", FolderItem.PathModes.Native)
If reader.OpenFile(pdfFile) Then
  Dim pageCount As Integer = reader.GetPageCount()
  MessageBox("PDF has " + Str(pageCount) + " pages")
End If
```

#### GetPageCount
```xojo
Function GetPageCount() As Integer
```
Returns the number of pages in the opened PDF.

**Returns**: Page count, or 0 if no PDF is loaded

#### GetPage
```xojo
Function GetPage(pageNum As Integer) As VNSPDFImportedPage
```
Extracts a specific page with all its resources.

**Parameters**:
- `pageNum`: Page number (1-based)

**Returns**: VNSPDFImportedPage object, or Nil on error

**VNSPDFImportedPage Properties**:
- `PageNumber As Integer` - Original page number
- `MediaBox As Dictionary` - Page dimensions (X, Y, Width, Height)
- `Contents As String` - Decompressed page content stream
- `Resources As VNSPDFDictionary` - Fonts, images, XObjects
- `XObjectForm As Dictionary` - XObject Form structure for embedding

---

### VNSPDFParser

**Purpose**: Parses PDF objects and builds type system.

**Location**: `PDF_Library/Import/VNSPDFParser.xojo_code`

**Key Methods**:
- `ParseIndirectObject(objNum, offset)` - Parse object at byte offset
- `ParseValue()` - Parse PDF value (null, boolean, number, string, name, array, dict, stream, reference)
- `ResolveReference(ref)` - Dereference indirect object references

---

### VNSPDFTokenizer

**Purpose**: Lexical analysis of PDF syntax.

**Location**: `PDF_Library/Import/VNSPDFTokenizer.xojo_code`

**Token Types**:
- Null (`null`)
- Boolean (`true`, `false`)
- Numeric (integer and real numbers)
- String (literal strings in parentheses)
- Hex String (hexadecimal strings in angle brackets)
- Name (names with forward slash prefix)
- Array (`[` ... `]`)
- Dictionary (`<<` ... `>>`)
- Stream (`stream` ... `endstream`)
- Reference (`R` keyword)
- Operator (PDF operators like `Do`, `cm`, `Tf`)

---

### VNSPDFStreamReader

**Purpose**: Binary stream handling with position tracking.

**Location**: `PDF_Library/Import/VNSPDFStreamReader.xojo_code`

**Key Methods**:
- `ReadByte()` - Read single byte
- `ReadBytes(count)` - Read multiple bytes
- `PeekByte()` - Look at next byte without advancing
- `GetPosition()` - Get current position
- `SetPosition(pos)` - Jump to position
- `SkipWhitespace()` - Skip whitespace characters

---

### VNSPDFStreamDecoder

**Purpose**: Decompress PDF streams.

**Location**: `PDF_Library/Import/VNSPDFStreamDecoder.xojo_code`

**Supported Filters**:
- **FlateDecode** - zlib/deflate compression (via system libs or Premium Zlib)
- **FlateDecode + PNG Predictors** - Requires Premium Zlib module
- **LZWDecode** - Legacy LZW compression (VNSPDFLZWDecoder)
- **ASCII85Decode** - Base-85 encoding
- **ASCIIHexDecode** - Hexadecimal encoding
- **DCTDecode** - JPEG (pass-through, no decompression)

**Key Method**:
```xojo
Function Decode(streamData As String, filters As VNSPDFArray, _
                decodeParms As VNSPDFArray) As String
```

---

### VNSPDFType (Base Class)

**Purpose**: Base class for all PDF type objects.

**Location**: `PDF_Library/Import/VNSPDFType.xojo_code`

**Subclasses** (12 types):
1. **VNSPDFNull** - Null value
2. **VNSPDFBoolean** - True/false
3. **VNSPDFNumeric** - Integer numbers
4. **VNSPDFReal** - Real (floating-point) numbers
5. **VNSPDFString** - Literal strings
6. **VNSPDFHexString** - Hexadecimal strings
7. **VNSPDFName** - PDF names (e.g., `/Type`, `/Pages`)
8. **VNSPDFArray** - Arrays of PDF objects
9. **VNSPDFDictionary** - Key-value dictionaries
10. **VNSPDFStream** - Binary data streams
11. **VNSPDFReference** - Indirect object references
12. **VNSPDFOperator** - PDF operators

**Common Methods**:
- `GetType() As String` - Returns type name
- `Serialize() As String` - Converts to PDF syntax
- `ToXojo() As Variant` - Converts to Xojo native type

---

### Usage Example

```xojo
// Import page from existing PDF
Dim pdf As New VNSPDFDocument()

// Set source file
Dim sourceFile As FolderItem = New FolderItem("/path/to/source.pdf", FolderItem.PathModes.Native)
Call pdf.SetSourceFile(sourceFile)

// Import first page
Dim templateID As Integer = pdf.ImportPage(1)

// Use as template
pdf.AddPage()
pdf.UseTemplate(templateID, 0, 0, 210, 297)  // Full A4 page

// Save result
Dim output As String = pdf.Output()
```

For complete documentation, see [Chapter 17: PDF Import](17-pdf-import.md).
