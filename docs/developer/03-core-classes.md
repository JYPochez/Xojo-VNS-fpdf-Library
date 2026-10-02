# Core Classes

## Table of Contents

- [VNSPDFDocument](#vnspdf-document)
  - [Constructor](#constructor)
  - [Properties](#properties)
    - [CurrentPage](#currentpage-read-only)
    - [Error](#error-read-only)
    - [PageCount](#pagecount-read-only)
  - [Methods](#methods)
    - [Page Management](#addpage)
    - [Error Management](#seterror)
    - [Font & Text](#setfont)
    - [Text Output](#cell)
    - [Position & Margins](#setxy)
    - [Links & Bookmarks](#addlink)
    - [Annotations & Attachments](#addattachment)
    - [Graphics Primitives](#line)
    - [Colors](#settextcolor)
    - [Line Styles](#setlinewidth)
    - [Advanced Graphics](#roundedrect)
    - [Transparency & Blend Modes](#setalpha)
    - [Transformations](#transformbegin)
    - [Gradients](#lineargradient)
    - [Clipping Paths](#cliprect)
    - [Path Rendering](#renderpath)
    - [Images & Barcodes](#image)
    - [Metadata](#settitle)
    - [Header/Footer Callbacks](#setheaderfunc)
    - [Page Control](#setautopagebreak)
    - [HTML/Markdown Import (Premium)](#loadhtml)
    - [Buffer Manipulation](#rawwritestr)
    - [Output & Serialization](#savetofile)
    - [Utility](#getversionstring)
  - [Private Methods (Internal)](#private-methods-internal)
- [VNSPDFPathSegment](#vnspdfpathsegment)
- [VNSPDFGraphicsPath](#vnspdfgraphicspath)
- [VNSPDFGradient](#vnspdfgradient)

---

## VNSPDFDocument

**Location**: `PDF_Library/Core/VNSPDFDocument.xojo_code`

The main class for creating and managing PDF documents.

### Constructor

VNSPDFDocument has five constructor overloads:

##### Constructor() (No Arguments)
```xojo
Sub Constructor()
```
Creates a new PDF document with default settings (Portrait, Millimeters, A4). Internally calls the 3-argument constructor.

##### Constructor(orientation, unit, pageFormat)
```xojo
Sub Constructor(orientation As VNSPDFModule.ePageOrientation, unit As VNSPDFModule.ePageUnit, pageFormat As VNSPDFModule.ePageFormat)
```

**Parameters**:
- `orientation` - Page orientation (Portrait or Landscape)
- `unit` - Unit of measurement for coordinates
- `pageFormat` - Standard page format (A3, A4, A5, Letter, Legal)

**Description**: Creates a new PDF document with specified settings. All pages added to this document will use these settings unless overridden. The first page is auto-added -- do NOT call AddPage after constructor.

##### Constructor(pageFormat)
```xojo
Sub Constructor(pageFormat As VNSPDFModule.ePageFormat)
```

**Parameters**:
- `pageFormat` - Standard page format (uses Portrait, Millimeters as defaults)

##### Constructor(width, height)
```xojo
Sub Constructor(width As Double, height As Double)
```

**Parameters**:
- `width` - Custom page width in millimeters
- `height` - Custom page height in millimeters

**Description**: Creates a document with custom page dimensions (Portrait, Millimeters).

##### Constructor(json)
```xojo
Sub Constructor(json As JSONItem)
```

**Parameters**:
- `json` - JSONItem containing serialized document state (from ToJSON)

**Description**: Restores a document from a JSON configuration.

**Example**:
```xojo
// Default A4 portrait document
Dim pdf As New VNSPDFDocument()

// Letter landscape document in inches
Dim pdf2 As New VNSPDFDocument( _
    VNSPDFModule.ePageOrientation.Landscape, _
    VNSPDFModule.ePageUnit.Inches, _
    VNSPDFModule.ePageFormat.Letter _
)

// Quick A5 document
Dim pdf3 As New VNSPDFDocument(VNSPDFModule.ePageFormat.A5)

// Custom size (200x300mm)
Dim pdf4 As New VNSPDFDocument(200, 300)
```

### Properties

#### CurrentPage (Read-Only)
```xojo
Property CurrentPage As Integer
```
Returns the current page number (1-based). Returns 0 if no pages exist.

**Example**:
```xojo
Dim pageNum As Integer = pdf.CurrentPage
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

**Preferred Error Checking Methods**:
- `Ok() As Boolean` - Returns True if no errors
- `Err() As Boolean` - Returns True if errors exist
- `GetError() As String` - Returns error message string

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
Sub AddPage(orientation As VNSPDFModule.ePageOrientation = VNSPDFModule.ePageOrientation.Portrait)
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

##### AddUTF8Font
```xojo
Sub AddUTF8Font(family As String, style As String = "", fontFilePath As String = "")
```

**Description**: Loads a TrueType font for UTF-8 support. If `fontFilePath` is empty, auto-searches system font directories.

**Example**:
```xojo
pdf.AddUTF8Font("DejaVu", "", "/path/to/DejaVuSans.ttf")
pdf.AddUTF8Font("DejaVu", "B", "/path/to/DejaVuSans-Bold.ttf")

// Auto-search system fonts
pdf.AddUTF8Font("Arial", "", "")
```

##### AddUTF8FontFromBytes
```xojo
Sub AddUTF8FontFromBytes(family As String, style As String = "", fontBytes As MemoryBlock)
```

**Description**: Loads a UTF-8 font from a MemoryBlock (byte array) instead of a file path.

##### HasFont
```xojo
Function HasFont(family As String) As Boolean
```

**Returns**: True if the font family is registered (core or UTF-8).

##### SetFontStyle
```xojo
Sub SetFontStyle(style As String)
```

**Description**: Changes font style ("", "B", "I", "BI") without changing family or size.

##### GetFontStyle
```xojo
Function GetFontStyle() As String
```

**Returns**: Current font style string ("", "B", "I", "BI").

##### GetFontFamily
```xojo
Function GetFontFamily() As String
```

**Returns**: Current font family name.

##### SetFontLocation
```xojo
Sub SetFontLocation(fontPath As String)
```

**Description**: Sets the base directory for font file searches.

##### GetFontLocation
```xojo
Function GetFontLocation() As String
```

**Returns**: Current font search directory path.

##### SetFontSubsetting
```xojo
Sub SetFontSubsetting(enable As Boolean)
```

**Description**: Enables/disables font subsetting for UTF-8 fonts (embeds only used glyphs to reduce file size).

##### GetFontSubsetting
```xojo
Function GetFontSubsetting() As Boolean
```

**Returns**: Whether font subsetting is enabled.

##### SetFontSize
```xojo
Sub SetFontSize(size As Double)
```

**Description**: Changes font size in points without changing family or style.

##### GetFontSize
```xojo
Sub GetFontSize(ByRef ptSize As Double, ByRef unitSize As Double)
```

**Description**: Returns current font size in both points and user units via ByRef parameters.

##### SetFontUnitSize
```xojo
Sub SetFontUnitSize(size As Double)
```

**Description**: Sets font size in current user units (mm/cm/inches) instead of points.

##### GetFontDesc
```xojo
Function GetFontDesc(family As String = "", style As String = "") As Dictionary
```

**Returns**: Font descriptor dictionary with metrics (Ascent, Descent, CapHeight, etc.). Empty family/style uses current font.

##### FontFamily / FontSizePt / FontStyle
```xojo
Function FontFamily() As String
Function FontSizePt() As Double
Function FontStyle() As String
```

**Description**: Convenience read-only accessors for header/footer callbacks.

##### GetStringWidth
```xojo
Function GetStringWidth(s As String) As Double
```

**Returns**: Width of the string in current user units using the current font.

##### GetStringHeight
```xojo
Function GetStringHeight(txt As String, maxWidth As Double) As Double
Function GetStringHeight(txt As String, maxWidth As Double, lineHeight As Double) As Double
```

**Returns**: Height of text when word-wrapped to maxWidth, using current font (or explicit lineHeight).

##### GetStringSymbolWidth
```xojo
Function GetStringSymbolWidth(symbol As String) As Double
```

**Returns**: Width of a single character/symbol in current user units.

##### IsCurrentFontUTF8
```xojo
Function IsCurrentFontUTF8() As Boolean
```

**Returns**: True if the currently selected font is a UTF-8 TrueType font.

##### SetUnderlineThickness / GetUnderlineThickness
```xojo
Sub SetUnderlineThickness(thickness As Double)
Function GetUnderlineThickness() As Double
```

**Description**: Gets/sets the underline thickness for text rendering.

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

##### CellFormat
```xojo
Sub CellFormat(w As Double, h As Double, txt As String, border As Variant,
               ln As Integer, align As String, fill As Boolean, link As String)
```

**Parameters**: Identical to Cell() method

**Description**: Wrapper for Cell() with explicit parameters. Exists for compatibility with go-fpdf's CellFormat() method. Simply calls Cell() internally with all parameters passed through.

**Example**:
```xojo
// These two calls are identical:
pdf.CellFormat(40, 10, "Text", 1, 0, "L", False, "")
pdf.Cell(40, 10, "Text", 1, 0, "L", False, "")
```

**Notes**:
- Use Cell() directly - it has the same signature
- CellFormat() exists only for go-fpdf API compatibility

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

##### Writef
```xojo
Sub Writef(h As Double, format As String, ParamArray args() As Variant)
```

**Description**: Printf-style Write. Formats the string using the format template and arguments, then outputs as flowing text.

**Example**:
```xojo
pdf.Writef(5, "Total: %d items at $%.2f each", count, price)
```

##### WriteLinkID
```xojo
Sub WriteLinkID(h As Double, displayStr As String, linkID As Integer)
```

**Description**: Outputs flowing text with an internal link (created by AddLink).

##### WriteLinkString
```xojo
Sub WriteLinkString(h As Double, displayStr As String, targetStr As String)
```

**Description**: Outputs flowing text with an external URL link.

**Example**:
```xojo
pdf.WriteLinkString(5, "Visit our website", "https://example.com")
```

##### WriteAligned
```xojo
Sub WriteAligned(width As Double, lineHeight As Double, textStr As String, alignStr As String = "L")
Sub WriteAligned(width As Double, lineHeight As Double, textStr As String, align As VNSPDFModule.eTextAlignment)
```

**Description**: Outputs word-wrapped text with specified alignment (L/C/R/J). Similar to MultiCell but uses Write-style flowing output.

##### Cellf
```xojo
Sub Cellf(w As Double, h As Double, format As String, ParamArray args() As Variant)
```

**Description**: Printf-style Cell. Formats the string using the format template and arguments.

**Example**:
```xojo
pdf.Cellf(50, 10, "Page %d of %d", currentPage, totalPages)
```

##### SetWordSpacing / GetWordSpacing
```xojo
Sub SetWordSpacing(space As Double)
Function GetWordSpacing() As Double
```

**Description**: Gets/sets extra word spacing for justified text (in user units).

##### SetTextRise / GetTextRise
```xojo
Sub SetTextRise(rise As Double)
Function GetTextRise() As Double
```

**Description**: Gets/sets vertical text displacement (positive = superscript, negative = subscript).

##### SetTextRenderingMode
```xojo
Sub SetTextRenderingMode(mode As Integer)
```

**Description**: Sets PDF text rendering mode (0=fill, 1=stroke, 2=fill+stroke, 3=invisible, 4-7=clip variants).

##### RTL / LTR
```xojo
Sub RTL()
Sub LTR()
```

**Description**: Switches text direction to Right-to-Left (for Arabic/Hebrew) or back to Left-to-Right.

Independently of `RTL()`, `Cell()`, `MultiCell()` and `GetStringWidth()` prepare Hebrew and Arabic text for display automatically: Arabic letters get their contextual (joined) forms, Hebrew and Arabic runs are reversed for left-to-right PDF output, brackets inside a run are mirrored, and digit sequences such as `2026` or `15.01.24` keep their left-to-right order.

##### SplitLines
```xojo
Function SplitLines(txt As String, w As Double) As String()
```

**Returns**: Array of lines that result from word-wrapping `txt` to fit within width `w`.

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

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Position & Margins</h2>

##### SetXY
```xojo
Sub SetXY(x As Double, y As Double)
```

**Description**: Sets both X and Y position simultaneously.

##### SetX / SetY
```xojo
Sub SetX(x As Double)
Sub SetY(y As Double)
```

**Description**: Sets the X or Y position independently.

##### GetX / GetY / GetXY
```xojo
Function GetX() As Double
Function GetY() As Double
Function GetXY() As Dictionary
```

**Description**: Returns current position. GetXY returns a Dictionary with keys "x" and "y".

##### SetHomeXY
```xojo
Sub SetHomeXY()
```

**Description**: Resets position to the top-left (left margin, top margin). Called automatically by AddPage.

##### SetMargins
```xojo
Sub SetMargins(left As Double, top As Double, right As Double = -1)
```

**Description**: Sets left, top, and optionally right margin. Right defaults to same as left if -1.

##### GetMargins
```xojo
Sub GetMargins(ByRef left As Double, ByRef top As Double, ByRef right As Double, ByRef bottom As Double)
```

**Description**: Returns all four margins via ByRef parameters.

##### SetLeftMargin / SetRightMargin / SetTopMargin
```xojo
Sub SetLeftMargin(margin As Double)
Sub SetRightMargin(margin As Double)
Sub SetTopMargin(margin As Double)
```

##### GetLeftMargin / GetRightMargin / GetTopMargin / GetBottomMargin
```xojo
Function GetLeftMargin() As Double
Function GetRightMargin() As Double
Function GetTopMargin() As Double
Function GetBottomMargin() As Double
```

##### SetCellMargin / GetCellMargin
```xojo
Sub SetCellMargin(margin As Double)
Function GetCellMargin() As Double
```

**Description**: Gets/sets the internal cell margin (padding between cell border and text).

##### Ln
```xojo
Sub Ln(h As Double = 0)
```

**Description**: Performs a line break, moving cursor to left margin and down by h (or current font size if h=0).

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Links & Bookmarks</h2>

##### AddLink
```xojo
Function AddLink() As Integer
```

**Returns**: A link ID placeholder. Use SetLink to define its destination later.

**Example**:
```xojo
Dim linkID As Integer = pdf.AddLink()
// ... later on target page:
pdf.SetLink(linkID, 50, 2)  // Link points to y=50 on page 2
```

##### SetLink
```xojo
Sub SetLink(linkID As Integer, y As Double = -1, pageNum As Integer = -1)
```

**Description**: Defines the destination for a previously created internal link.

##### Link
```xojo
Sub Link(x As Double, y As Double, w As Double, h As Double, linkID As Integer)
```

**Description**: Creates a clickable rectangular area that jumps to an internal link destination.

##### LinkString
```xojo
Sub LinkString(x As Double, y As Double, w As Double, h As Double, url As String)
```

**Description**: Creates a clickable rectangular area that opens an external URL.

##### AddLinkArea
```xojo
Sub AddLinkArea(url As String, x As Integer, y As Integer, width As Integer, height As Integer)
Sub AddLinkArea(url As String, x As Double, y As Double, width As Double, height As Double)
```

**Description**: Adds a URL link annotation area on the current page (Integer or Double overload).

##### AddGoToPageArea
```xojo
Sub AddGoToPageArea(page As Integer, x As Integer, y As Integer, width As Integer, height As Integer, targetY As Integer = 0)
Sub AddGoToPageArea(page As Integer, x As Double, y As Double, width As Double, height As Double, targetY As Double = 0.0)
```

**Description**: Adds a clickable area that navigates to a specific page within the PDF.

##### AddLinkToPDFArea
```xojo
Sub AddLinkToPDFArea(file As FolderItem, x As Integer, y As Integer, width As Integer, height As Integer)
Sub AddLinkToPDFArea(file As FolderItem, x As Double, y As Double, width As Double, height As Double)
```

**Description**: Adds a clickable area that opens an external PDF file.

##### Bookmark
```xojo
Sub Bookmark(txt As String, level As Integer, y As Double = -1)
```

**Description**: Adds a bookmark (outline entry) at the current position. Level 0 = top-level, 1+ = sub-levels.

**Example**:
```xojo
pdf.Bookmark("Chapter 1", 0)
pdf.Bookmark("Section 1.1", 1)
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Annotations & Attachments</h2>

##### AddAnnotation
```xojo
Sub AddAnnotation(message As String, x As Integer, y As Integer)
Sub AddAnnotation(message As String, x As Double, y As Double)
```

**Description**: Adds a text annotation (sticky note) at the specified position. Xojo PDFGraphics-compatible.

##### AddTextAnnotation
```xojo
Sub AddTextAnnotation(message As String, x As Double, y As Double)
```

**Description**: Adds a text annotation (sticky note icon) at the specified position.

##### AddAttachment
```xojo
Sub AddAttachment(attachment As VNSPDFAttachment)
```

**Description**: Adds a document-level file attachment (appears in PDF attachments panel).

##### SetAttachments
```xojo
Sub SetAttachments(attachments() As VNSPDFAttachment)
```

**Description**: Replaces the entire document-level attachment list.

##### AddAttachmentAnnotation
```xojo
Sub AddAttachmentAnnotation(attachment As VNSPDFAttachment, x As Double, y As Double, w As Double, h As Double)
```

**Description**: Adds a page-level attachment annotation (clickable icon on page).

##### AddEmbeddedFile
```xojo
Sub AddEmbeddedFile(file As FolderItem, x As Integer, y As Integer, width As Integer, height As Integer, description As String = "")
Sub AddEmbeddedFile(file As FolderItem, x As Double, y As Double, width As Double, height As Double, description As String = "")
```

**Description**: Embeds a file and creates a clickable annotation on the page. Xojo PDFDocument-compatible.

##### AddEmbeddedMovie / AddEmbeddedSound
```xojo
Sub AddEmbeddedMovie(file As FolderItem, x As Integer, y As Integer, width As Integer, height As Integer, description As String = "")
Sub AddEmbeddedSound(file As FolderItem, x As Integer, y As Integer, width As Integer, height As Integer, description As String = "")
```

**Description**: Xojo PDFDocument-compatible methods for embedding movie/sound files. Both delegate to AddEmbeddedFile internally.

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

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Colors</h2>

##### SetTextColor
```xojo
Sub SetTextColor(r As Integer, g As Integer, b As Integer)
Sub SetTextColor(c As Color)
```

**Parameters**:
- `r` - Red component (0-255)
- `g` - Green component (0-255)
- `b` - Blue component (0-255)
- `c` - Xojo Color object (API2, 0-255 components)

**Description**: Sets the color for text output. Accepts either RGB integers or a Xojo Color object.

**Example**:
```xojo
pdf.SetTextColor(255, 0, 0)           // Red text (integer overload)
pdf.SetTextColor(Color.RGB(255, 0, 0)) // Red text (Color overload)
```

##### GetTextColor
```xojo
Function GetTextColor() As Color
Sub GetTextColor(ByRef r As Integer, ByRef g As Integer, ByRef b As Integer)
```

**Description**: Returns the current text color as a Xojo Color object or as ByRef RGB integers (0-255).

**Example**:
```xojo
Dim c As Color = pdf.GetTextColor()
// or
Dim r, g, b As Integer
pdf.GetTextColor(r, g, b)
```

##### SetFillColor
```xojo
Sub SetFillColor(r As Integer, g As Integer, b As Integer)
Sub SetFillColor(c As Color)
```

**Parameters**:
- `r` - Red component (0-255)
- `g` - Green component (0-255)
- `b` - Blue component (0-255)
- `c` - Xojo Color object (API2, 0-255 components)

**Description**: Sets the color for filled shapes and cells. Accepts either RGB integers or a Xojo Color object.

**Example**:
```xojo
pdf.SetFillColor(200, 220, 255)              // Light blue fill
pdf.SetFillColor(Color.RGB(200, 220, 255))   // Same with Color object
```

##### GetFillColor
```xojo
Function GetFillColor() As Color
Sub GetFillColor(ByRef r As Integer, ByRef g As Integer, ByRef b As Integer)
```

**Description**: Returns the current fill color as a Xojo Color object or as ByRef RGB integers (0-255).

##### SetDrawColor
```xojo
Sub SetDrawColor(r As Integer, g As Integer, b As Integer)
Sub SetDrawColor(c As Color)
```

**Parameters**:
- `r` - Red component (0-255)
- `g` - Green component (0-255)
- `b` - Blue component (0-255)
- `c` - Xojo Color object (API2, 0-255 components)

**Description**: Sets the color for lines and shape outlines. Accepts either RGB integers or a Xojo Color object.

**Example**:
```xojo
pdf.SetDrawColor(0, 0, 0)            // Black lines
pdf.SetDrawColor(Color.RGB(255, 0, 0)) // Red lines
```

##### GetDrawColor
```xojo
Function GetDrawColor() As Color
Sub GetDrawColor(ByRef r As Integer, ByRef g As Integer, ByRef b As Integer)
```

**Description**: Returns the current draw color as a Xojo Color object or as ByRef RGB integers (0-255).

##### SetDisplayMode
```xojo
Sub SetDisplayMode(zoomStr As String, layoutStr As String = "default")
```

**Parameters**:
- `zoomStr` - Zoom mode: `"fullpage"`, `"fullwidth"`, `"real"` (100%), `"default"`, or a numeric percentage string (e.g. `"75"`, `"200"`)
- `layoutStr` - Page layout: `"single"` / `"SinglePage"`, `"continuous"` / `"OneColumn"`, `"two"` / `"TwoColumnLeft"`, `"TwoColumnRight"`, `"TwoPageLeft"`, `"TwoPageRight"`, `"default"`

**Description**: Sets advisory display directives for the PDF viewer. Controls both initial zoom level and page layout. Directives are written to the PDF catalog as `/OpenAction` and `/PageLayout` entries. Contribution: Geoff Bridges.

**Example**:
```xojo
pdf.SetDisplayMode("fullwidth", "continuous")  // Max width, continuous scroll
pdf.SetDisplayMode("75", "two")                // 75% zoom, two-column layout
pdf.SetDisplayMode("real")                     // 100% zoom, default layout
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

##### GetLineWidth
```xojo
Function GetLineWidth() As Double
```

**Returns**: Current line width in user units.

##### SetLineCapStyle
```xojo
Sub SetLineCapStyle(style As String)
```

**Description**: Sets line cap style: "butt" (default), "round", or "square".

##### GetLineCapStyle
```xojo
Function GetLineCapStyle() As String
```

##### SetLineJoinStyle
```xojo
Sub SetLineJoinStyle(style As String)
```

**Description**: Sets line join style: "miter" (default), "round", or "bevel".

##### GetLineJoinStyle
```xojo
Function GetLineJoinStyle() As String
```

##### SetDashPattern
```xojo
Sub SetDashPattern(dashArray() As Double, dashPhase As Double)
```

**Description**: Sets a custom dash pattern for line drawing. Empty array resets to solid line.

**Example**:
```xojo
// Simple dash: 5 on, 3 off
Dim dash() As Double = Array(5.0, 3.0)
pdf.SetDashPattern(dash, 0)

// Reset to solid
Dim solid() As Double
pdf.SetDashPattern(solid, 0)
```

##### Ellipse
```xojo
Sub Ellipse(x As Double, y As Double, rx As Double, ry As Double, style As String = "D")
```

**Description**: Draws an ellipse centered at (x, y) with horizontal radius rx and vertical radius ry.

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

##### CurveCubic
```xojo
Sub CurveCubic(x0 As Double, y0 As Double, cx0 As Double, cy0 As Double, x1 As Double, y1 As Double, cx1 As Double, cy1 As Double, style As String = "D")
```

**Parameters**:
- `x0, y0` - Starting point coordinates
- `cx0, cy0` - First control point coordinates
- `x1, y1` - Ending point coordinates (NOTE: before second control point)
- `cx1, cy1` - Second control point coordinates (NOTE: after end point)
- `style` - Drawing style: "D" (draw), "F" (fill), "DF" or "FD" (both)

**Description**: Legacy wrapper for CurveBezierCubic() with nonstandard control point order. Exists for backward compatibility with go-fpdf. **Use CurveBezierCubic() instead.**

**Parameter Mapping**:
```xojo
// CurveCubic parameter order (nonstandard):
CurveCubic(x0, y0, cx0, cy0, x1, y1, cx1, cy1, style)

// Internally calls CurveBezierCubic (standard order):
CurveBezierCubic(x0, y0, cx0, cy0, cx1, cy1, x1, y1, style)
```

**Example**:
```xojo
// These two calls produce the same curve:
pdf.CurveCubic(10, 90, 30, 75, 90, 90, 60, 105, "D")
pdf.CurveBezierCubic(10, 90, 30, 75, 60, 105, 90, 90, "D")
```

**Notes**:
- **Deprecated**: Use CurveBezierCubic() for new code
- Parameter order is nonstandard (end point before second control point)
- Maintained only for go-fpdf compatibility
- Internally just reorders parameters and calls CurveBezierCubic()

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

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Transparency & Blend Modes</h2>

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

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Transformations</h2>

##### TransformBegin
```xojo
Sub TransformBegin()
```

**Description**: Begins a transformation context by saving the current graphics state. All subsequent transformations will affect drawing operations until `TransformEnd()` is called.

**Example**:
```xojo
pdf.TransformBegin()
pdf.TransformRotate(45, 100, 100)  // Rotate 45° around point (100, 100)
pdf.Text(100, 100, "Rotated Text")
pdf.TransformEnd()
```

---

##### TransformEnd
```xojo
Sub TransformEnd()
```

**Description**: Ends a transformation context and restores the previous graphics state. Must be called after `TransformBegin()` to properly balance the graphics state stack.

**Important**: Every `TransformBegin()` must have a matching `TransformEnd()`. Unbalanced calls will cause PDF rendering errors.

**Example**:
```xojo
pdf.TransformBegin()
// ... transformation and drawing code ...
pdf.TransformEnd()
```

---

##### TransformRotate
```xojo
Sub TransformRotate(angle As Double, x As Double, y As Double)
```

**Parameters**:
- `angle` - Rotation angle in degrees, measured counter-clockwise from the 3 o'clock position
- `x, y` - Center point of rotation in user units

**Description**: Rotates subsequent text and graphics around the specified center point. The rotation is applied within the current transformation context created by `TransformBegin()`.

**Example**:
```xojo
// Rotate watermark text 45° diagonally
pdf.TransformBegin()
pdf.TransformRotate(45, 105, 148.5)  // Center of A4 page
pdf.SetFont("Helvetica", "B", 50)
pdf.SetTextColor(220, 220, 220)
pdf.Text(60, 150, "DRAFT")
pdf.TransformEnd()
```

---

##### Transform
```xojo
Sub Transform(a As Double, b As Double, c As Double, d As Double, e As Double, f As Double)
```

**Parameters**:
- `a, b, c, d, e, f` - Components of the 2D transformation matrix

**Description**: Applies a raw 2D transformation matrix to the current transformation matrix (CTM). The matrix is represented as:
```
| a  b  0 |
| c  d  0 |
| e  f  1 |
```

This method is for advanced users who need precise control over transformations. For common operations like rotation, use `TransformRotate()` instead.

**Must be called between `TransformBegin()` and `TransformEnd()`.**

**Example**:
```xojo
// Custom transformation matrix
pdf.TransformBegin()
pdf.Transform(1.0, 0.0, 0.0, 1.0, 50.0, 50.0)  // Translate by (50, 50)
pdf.Text(0, 0, "Translated Text")
pdf.TransformEnd()
```

##### TransformMirrorHorizontal
```xojo
Sub TransformMirrorHorizontal(x As Double)
```
**Description**: Mirrors subsequent drawing horizontally around the vertical line at x.

##### TransformMirrorVertical
```xojo
Sub TransformMirrorVertical(y As Double)
```
**Description**: Mirrors subsequent drawing vertically around the horizontal line at y.

##### TransformMirrorPoint
```xojo
Sub TransformMirrorPoint(x As Double, y As Double)
```
**Description**: Mirrors subsequent drawing around a point (180-degree rotation).

##### TransformMirrorLine
```xojo
Sub TransformMirrorLine(angle As Double, x As Double, y As Double)
```
**Description**: Mirrors subsequent drawing around an arbitrary line through (x, y) at the given angle.

##### TransformScale / TransformScaleX / TransformScaleY / TransformScaleXY
```xojo
Sub TransformScale(scaleWd As Double, scaleHt As Double, x As Double, y As Double)
Sub TransformScaleX(scaleWd As Double, x As Double, y As Double)
Sub TransformScaleY(scaleHt As Double, x As Double, y As Double)
Sub TransformScaleXY(s As Double, x As Double, y As Double)
```
**Description**: Scales subsequent drawing around point (x, y). Values are percentages (100 = no change). TransformScaleXY applies uniform scaling.

##### TransformSkew / TransformSkewX / TransformSkewY
```xojo
Sub TransformSkew(angleX As Double, angleY As Double, x As Double, y As Double)
Sub TransformSkewX(angleX As Double, x As Double, y As Double)
Sub TransformSkewY(angleY As Double, x As Double, y As Double)
```
**Description**: Skews subsequent drawing by the given angles (in degrees) around point (x, y).

##### TransformTranslate / TransformTranslateX / TransformTranslateY
```xojo
Sub TransformTranslate(tx As Double, ty As Double)
Sub TransformTranslateX(tx As Double)
Sub TransformTranslateY(ty As Double)
```
**Description**: Translates (moves) subsequent drawing by the given offset in user units.

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

##### LinearGradientMultiStop
```xojo
Sub LinearGradientMultiStop(x As Double, y As Double, w As Double, h As Double, stops() As Pair, x1 As Double, y1 As Double, x2 As Double, y2 As Double)
```

**Parameters**:
- `x, y` - Rectangle position (top-left corner)
- `w, h` - Rectangle dimensions
- `stops` - Array of Pairs where Left = position (0.0-1.0), Right = Color
- `x1, y1` - Gradient start point (normalized 0-1)
- `x2, y2` - Gradient end point (normalized 0-1)

**Description**: Fills a rectangle with a multi-stop linear gradient using PDF FunctionType 3 (stitching function). Supports any number of color stops for complex gradients like rainbows.

**Example**:
```xojo
// Rainbow gradient (horizontal)
Dim stops() As Pair
stops.Add(0.0 : Color.Red)
stops.Add(0.25 : Color.Yellow)
stops.Add(0.5 : Color.Green)
stops.Add(0.75 : Color.Cyan)
stops.Add(1.0 : Color.Blue)
pdf.LinearGradientMultiStop(20, 20, 160, 40, stops, 0, 0, 1, 0)

// Vertical multi-stop gradient
Dim vStops() As Pair
vStops.Add(0.0 : Color.White)
vStops.Add(0.5 : Color.Gray)
vStops.Add(1.0 : Color.Black)
pdf.LinearGradientMultiStop(20, 80, 160, 40, vStops, 0, 0, 0, 1)
```

**Notes**:
- Uses PDF FunctionType 3 (stitching function) for multiple color segments
- Each segment uses FunctionType 2 for smooth interpolation
- Stops array must have at least 2 entries
- Position values should be sorted from 0.0 to 1.0
- Works with clipping paths for shaped gradients

##### LinearGradientMultiStopInClip
```xojo
Sub LinearGradientMultiStopInClip(x As Double, y As Double, w As Double, h As Double, stops() As Pair, x1 As Double, y1 As Double, x2 As Double, y2 As Double)
```

Same as LinearGradientMultiStop but for use within an existing clipping path (e.g., ellipse or polygon). Does not create its own rectangular clip.

**Example**:
```xojo
// Rainbow ellipse
pdf.ClipEllipse(100, 100, 80, 50, True)
Dim stops() As Pair
stops.Add(0.0 : Color.Red)
stops.Add(0.5 : Color.Green)
stops.Add(1.0 : Color.Blue)
pdf.LinearGradientMultiStopInClip(20, 50, 160, 100, stops, 0, 0, 1, 1)
pdf.ClipEnd()
```

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

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Path Rendering</h2>

##### RenderPath
```xojo
Sub RenderPath(pathCommands As String, style As String = "D")
```

**Parameters**:
- `pathCommands` - PDF path commands string (generated by `VNSPDFGraphicsPath.ToPDFCommands`)
- `style` - Drawing style: `"D"` (stroke), `"F"` (fill), `"DF"` or `"FD"` (fill and stroke)

**Description**: Appends pre-built PDF path commands to the page content stream and applies the specified drawing style operator (`S` for stroke, `f` for fill, `B` for fill+stroke). Typically used with `VNSPDFGraphicsPath.ToPDFCommands()` to render complex paths containing curves, arcs, and mixed segments.

**Example**:
```xojo
Dim path As New VNSPDFGraphicsPath
path.MoveToPoint(50, 50)
path.AddCurveToPoint(80, 20, 120, 80, 150, 50)
path.CloseSubpath()

Dim cmds As String = path.ToPDFCommands(pdf)
pdf.RenderPath(cmds, "DF")  // Fill and stroke
```

**Notes**:
- Path commands must be valid PDF path operators (`m`, `l`, `c`, `re`, `h`)
- Sets error if no page exists
- See [19-graphicspath.md](19-graphicspath.md) for full `VNSPDFGraphicsPath` documentation

##### ClipPath
```xojo
Sub ClipPath(pathCommands As String, outline As Boolean)
```

**Parameters**:
- `pathCommands` - PDF path commands string (generated by `VNSPDFGraphicsPath.ToPDFCommands`)
- `outline` - If True, draws the clipping path outline; if False, invisible clip

**Description**: Establishes a clipping region from pre-built PDF path commands. Content drawn after this call is confined to the path shape. Supports curves, arcs, round rectangles, and any path type. Must be paired with `ClipEnd()` to restore the previous graphics state.

**Example**:
```xojo
// Clip to a round rectangle
Dim clipPath As New VNSPDFGraphicsPath
clipPath.AddRoundRectangle(20, 20, 160, 100, 15, 15)

Dim cmds As String = clipPath.ToPDFCommands(pdf)
pdf.ClipPath(cmds, False)

// Draw content inside the clipped region
pdf.SetFillColor(100, 149, 237)
pdf.Rect(0, 0, 200, 150, "F")

pdf.ClipEnd()
```

**Notes**:
- Saves graphics state (`q` operator) and increments clip nest counter
- Uses even-odd clipping rule (`W*`)
- Must call `ClipEnd()` to restore state
- Can be nested with other clipping operations
- See [19-graphicspath.md](19-graphicspath.md) for full path API

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Images & Barcodes</h2>

##### Image
```xojo
Sub Image(imagePath As String, x As Double = 0, y As Double = 0, w As Double = 0, h As Double = 0, imageKey As String = "")
```

**Parameters**:
- `imagePath` - Path to image file (JPEG or PNG)
- `x` - X coordinate of top-left corner (default: 0)
- `y` - Y coordinate of top-left corner (default: 0)
- `w` - Image width (0 = auto-calculate from height) (default: 0)
- `h` - Image height (0 = auto-calculate from width) (default: 0)
- `imageKey` - Optional key for image reuse. If empty, imagePath is used as key. (default: "")

**Description**: Embeds and displays a JPEG or PNG image in the PDF. Images are automatically registered and can be reused multiple times.

**Example**:
```xojo
// Display image with explicit dimensions
pdf.Image("photo.jpg", 10, 20, 100, 75)

// Auto-calculate height from width (maintains aspect ratio)
pdf.Image("photo.jpg", 10, 20, 100, 0)

// Reuse same image with a key
pdf.Image("photo.jpg", 10, 20, 50, 0, "logo")
pdf.Image("photo.jpg", 150, 20, 50, 0, "logo")  // Same embedded data
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
- `emojiChar` - One emoji, which may be a multi-code-point sequence: skin tone ("👍🏽"), ZWJ sequence ("👩🏽‍💻", "👨‍👩‍👧‍👦"), flag ("🇫🇷") or keycap ("1️⃣"). Pass the whole sequence in one call; the OS emoji font draws it as a single glyph
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
- The emoji glyph fills about 85% of `sizeInUserUnits` on Desktop (8% padding on each side of the rendered image; it was 30% before September 2026, which drew emoji at roughly half the requested size)
- `VNSPDFModule.IsEmojiCluster(cluster)` tells whether one element of `String.Characters` is an emoji, including skin-tone, ZWJ, flag and keycap sequences
- No manual Picture/Graphics API calls required
- Platform emoji fonts provide full color rendering

##### RegisterImage
```xojo
Function RegisterImage(imagePath As String, imageKey As String = "") As String
```

**Parameters**:
- `imagePath` - Path to image file
- `imageKey` - Optional unique key (auto-generated from path if empty)

**Returns**: The image key used for registration.

**Description**: Pre-registers an image without displaying it. Returns the key that can be used with Image() for efficient reuse.

**Example**:
```xojo
// Register logo once
Dim key As String = pdf.RegisterImage("logo.png", "company_logo")

// Use multiple times with Image()
pdf.Image("logo.png", 10, 10, 30, 0, "company_logo")
pdf.Image("logo.png", 10, 270, 30, 0, "company_logo")
```

##### RegisterImageFromBytes
```xojo
Function RegisterImageFromBytes(imageData As MemoryBlock, imageKey As String = "") As String
```

**Returns**: The image key used for registration.

**Description**: Pre-registers an image from a MemoryBlock (binary data) without displaying it.

##### GetRegisteredImageSize
```xojo
Function GetRegisteredImageSize(imageKey As String, ByRef w As Double, ByRef h As Double) As Boolean
```

**Returns**: True if the image was found. Width and height returned via ByRef in user units.

##### ImageOptions
```xojo
Sub ImageOptions(imagePath As String, x As Double, y As Double, w As Double, h As Double, imageKey As String, options As Dictionary)
```

**Parameters**:
- `imagePath` - Path to image file
- `x, y` - Position in user units
- `w, h` - Width and height (0 = auto-calculate)
- `imageKey` - Optional unique key for referencing
- `options` - Dictionary with keys:
  - "imageType" (String): Currently ignored - auto-detection used
  - "readDpi" (Boolean): Future feature, currently ignored
  - "allowNegativePosition" (Boolean): Allow negative X coordinates

**Description**: Add image with advanced options Dictionary for fine-tuned control. Note: imageType auto-detected from binary signature.

**Example**:
```xojo
// Allow negative X position (advanced use case)
Dim opts As New Dictionary
opts.Value("allowNegativePosition") = True
pdf.ImageOptions("overlay.png", -10, 50, 80, 0, "", opts)
```

##### RegisterImageOptions
```xojo
Function RegisterImageOptions(imagePath As String, imageKey As String, options As Dictionary) As String
```

**Parameters**:
- `imagePath` - Path to image file
- `imageKey` - Optional unique key (auto-generated if empty)
- `options` - Dictionary with same keys as ImageOptions

**Description**: Pre-register an image with advanced options.

**Returns**: The image key used for registration

**Example**:
```xojo
// Note: options currently only used for future features
// Image type is auto-detected from binary signature
Dim key As String = pdf.RegisterImageOptions("graphic.png", "my_graphic", Nil)
```

##### RegisterImageOptionsReader
```xojo
Function RegisterImageOptionsReader(imageData As MemoryBlock, imageKey As String, options As Dictionary) As String
```

**Parameters**:
- `imageData` - MemoryBlock containing image bytes
- `imageKey` - Optional unique key
- `options` - Dictionary with same keys as ImageOptions

**Description**: Pre-register an image from MemoryBlock with options.

**Returns**: The image key used for registration

##### RegisterImageReader (DEPRECATED)
```xojo
Function RegisterImageReader(imageData As MemoryBlock, imageType As String, imageKey As String) As String
```

**Status**: DEPRECATED - Use RegisterImageOptionsReader() instead

**Description**: Legacy wrapper for backward compatibility. Internally calls RegisterImageOptionsReader().

##### ImageFromPicture
```xojo
Sub ImageFromPicture(pic As Picture, x As Double = 0, y As Double = 0, w As Double = 0, h As Double = 0, Optional imageKey As String = "")
```

**Description**: Embeds a Xojo Picture object as a JPEG image in the PDF. Useful for programmatically-generated graphics (charts, barcodes, etc.).

**Example**:
```xojo
Dim pic As New Picture(200, 100)
Dim g As Graphics = pic.Graphics
g.DrawingColor = Color.RGB(255, 0, 0)
g.FillRectangle(0, 0, 200, 100)
pdf.ImageFromPicture(pic, 20, 50, 80, 40)
```

##### DrawQRCode (Free)
```xojo
Sub DrawQRCode(x As Double, y As Double, size As Double, value As String)
```

**Description**: Draws a QR code at the specified position. Included free in the core library.

**Example**:
```xojo
pdf.DrawQRCode(20, 50, 40, "https://example.com")
```

##### DrawCode128 (Free)
```xojo
Sub DrawCode128(x As Double, y As Double, w As Double, h As Double, value As String)
```

**Description**: Draws a Code 128 barcode at the specified position. Included free in the core library.

**Example**:
```xojo
pdf.DrawCode128(20, 100, 80, 20, "ABC-12345")
```

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Metadata</h2>

##### SetTitle / SetAuthor / SetSubject / SetKeywords / SetCreator
```xojo
Sub SetTitle(title As String)
Sub SetAuthor(author As String)
Sub SetSubject(subject As String)
Sub SetKeywords(keywords As String)
Sub SetCreator(creator As String)
```

**Description**: Sets PDF document metadata. Also available as computed properties (Title, Author, Subject, Keywords, Creator) for Xojo PDFDocument compatibility.

##### SetLang / GetLang
```xojo
Sub SetLang(lang As String)
Function GetLang() As String
```

**Description**: Gets/sets the document language tag (e.g., "en", "fr", "de"). Written to the PDF catalog.

##### SetProducer
```xojo
Sub SetProducer(producer As String)
```

**Description**: Sets the PDF Producer metadata field.

##### SetXmpMetadata / GetXmpMetadata
```xojo
Sub SetXmpMetadata(xmpStream As String)
Function GetXmpMetadata() As String
```

**Description**: Gets/sets raw XMP metadata XML stream for PDF/A compliance.

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Header/Footer Callbacks</h2>

##### SetHeaderFunc
```xojo
Sub SetHeaderFunc(headerFunc As VNSPDFModule.HeaderFooterDelegate)
```

**Description**: Sets a delegate to be called at the top of each new page.

**Example**:
```xojo
pdf.SetHeaderFunc(AddressOf MyHeader)

Sub MyHeader(doc As VNSPDFDocument)
  doc.SetFont("helvetica", "B", 12)
  doc.Cell(0, 10, "My Document", 0, 0, "C")
  doc.Ln(15)
End Sub
```

##### SetHeaderFuncMode
```xojo
Sub SetHeaderFuncMode(headerFunc As VNSPDFModule.HeaderFooterDelegate, homeMode As Boolean)
```

**Description**: Like SetHeaderFunc, but with homeMode flag. If True, resets position to home after header.

##### SetFooterFunc
```xojo
Sub SetFooterFunc(footerFunc As VNSPDFModule.HeaderFooterDelegate)
```

**Description**: Sets a delegate to be called at the bottom of each page.

##### SetFooterFuncLpi
```xojo
Sub SetFooterFuncLpi(footerFunc As VNSPDFModule.FooterDelegateLpi)
```

**Description**: Sets a footer delegate that receives the last page indicator (Boolean parameter).

##### SetAcceptPageBreakFunc
```xojo
Sub SetAcceptPageBreakFunc(acceptFunc As VNSPDFModule.AcceptPageBreakDelegate)
```

**Description**: Sets a delegate called during automatic page breaks. Return False to prevent the break.

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Page Control</h2>

##### SetAutoPageBreak / GetAutoPageBreak
```xojo
Sub SetAutoPageBreak(enable As Boolean, margin As Double = 0)
Sub GetAutoPageBreak(ByRef auto As Boolean, ByRef margin As Double)
```

**Description**: Enables/disables automatic page breaks and sets the bottom margin trigger distance.

##### SetCompression / GetCompression
```xojo
Sub SetCompression(enable As Boolean)
Function GetCompression() As Boolean
```

**Description**: Enables/disables stream compression (FlateDecode). Also available as the `Compressed` computed property for Xojo compatibility.

##### AliasNbPages
```xojo
Sub AliasNbPages(aliasStr As String = "")
```

**Description**: Sets the alias string for total page count (default: "{nb}"). Used with header/footer callbacks to display "Page X of Y".

##### RegisterAlias
```xojo
Sub RegisterAlias(alias As String, replacement As String)
```

**Description**: Registers a custom text alias that will be replaced in all page content when the document is finalized.

##### ReplaceAliases
```xojo
Sub ReplaceAliases()
```

**Description**: Processes all registered aliases (including {nb}) and replaces them in page content. Called automatically by Output/Save.

##### NextPage
```xojo
Sub NextPage()
Sub NextPage(width As Double, height As Double)
```

**Description**: Advances to the next page. Xojo PDFDocument-compatible method. The overload with dimensions creates a page with custom size.

##### SetPageBox
```xojo
Sub SetPageBox(boxType As String, x As Double, y As Double, width As Double, height As Double)
```

**Description**: Sets a PDF page box (MediaBox, CropBox, BleedBox, TrimBox, ArtBox) for the current page.

##### AddPageFormat
```xojo
Sub AddPageFormat(orientationStr As String, width As Double, height As Double)
```

**Description**: Adds a new page with custom dimensions and orientation string ("P" or "L").

##### GetPageSize / GetPageHeight / GetPageWidth
```xojo
Sub GetPageSize(ByRef width As Double, ByRef height As Double)
Function GetPageHeight() As Double
Function GetPageWidth() As Double
```

**Description**: Returns page dimensions in user units.

##### PageSize
```xojo
Function PageSize(pageNum As Integer, ByRef width As Double, ByRef height As Double) As Boolean
```

**Returns**: True if page exists. Dimensions returned via ByRef.

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">HTML/Markdown Import (Premium)</h2>

##### LoadHTML
```xojo
Sub LoadHTML(html As String, maxWidth As Double = 0, imageFolder As FolderItem = Nil)
```

**Description**: Converts HTML content to PDF. Supports headings, paragraphs, lists, tables, images, links, inline styles, and more. Requires the Premium HTML/Markdown Import module.

**Example**:
```xojo
pdf.LoadHTML("<h1>Title</h1><p>Hello <b>world</b>!</p>")
```

##### LoadMarkdown
```xojo
Sub LoadMarkdown(markdown As String, maxWidth As Double = 0, imageFolder As FolderItem = Nil)
```

**Description**: Converts Markdown content to PDF. Supports headings, bold, italic, lists, code blocks, tables, images, and links. Requires the Premium HTML/Markdown Import module.

##### HTML Tag Handlers (Custom Extensions)
```xojo
Sub RegisterHTMLTagHandler(tagName As String, handler As VNSPDFModule.HTMLTagHandlerDelegate)
Sub RemoveHTMLTagHandler(tagName As String)
Sub RemoveAllHTMLTagHandlers()
Function HasHTMLTagHandler(tagName As String) As Boolean
Function GetHTMLTagHandler(tagName As String) As VNSPDFModule.HTMLTagHandlerDelegate
```

**Description**: Register custom handlers for HTML tags to extend LoadHTML behavior.

##### Markdown Line Handlers (Custom Extensions)
```xojo
Sub RegisterMarkdownHandler(prefix As String, handler As VNSPDFModule.MarkdownLineHandlerDelegate)
Sub RemoveMarkdownHandler(prefix As String)
Sub RemoveAllMarkdownHandlers()
Function MarkdownLineHandlers() As Dictionary
```

**Description**: Register custom handlers for Markdown line prefixes.

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Buffer Manipulation</h2>

##### RawWriteStr
```xojo
Sub RawWriteStr(str As String)
```

**Description**: Writes raw PDF commands directly to the current page buffer. Low-level function for advanced PDF construction.

##### GetBufferLength
```xojo
Function GetBufferLength() As Integer
```

**Returns**: Current length of the page content buffer.

##### InsertInBuffer
```xojo
Sub InsertInBuffer(position As Integer, content As String)
```

**Description**: Inserts content at a specific position in the page buffer.

##### ExtractBufferSince
```xojo
Function ExtractBufferSince(position As Integer) As String
```

**Returns**: Content from the specified position to the end of the buffer.

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Security & Encryption</h2>

##### SetProtection
```xojo
Sub SetProtection(userPassword As String, ownerPassword As String = "", _
    allowPrint As Boolean = True, allowModify As Boolean = True, _
    allowCopy As Boolean = True, allowAnnotate As Boolean = True, _
    allowFillForms As Boolean = True, allowExtract As Boolean = True, _
    allowAssemble As Boolean = True, allowPrintHighQuality As Boolean = True, _
    revision As Integer = VNSPDFModule.gkEncryptionAES128)
```

**Parameters**:
- `userPassword` - Password required to open the document (empty = no user password)
- `ownerPassword` - Password to change permissions (defaults to userPassword if empty)
- `allowPrint` - Allow printing the document
- `allowModify` - Allow document modification
- `allowCopy` - Allow text/graphics copying
- `allowAnnotate` - Allow annotations and form field entries
- `allowFillForms` - Allow filling form fields
- `allowExtract` - Allow content extraction for accessibility
- `allowAssemble` - Allow document assembly
- `allowPrintHighQuality` - Allow high-quality printing
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
- **All revisions working** via Premium Encryption module's pure Xojo AES implementation
- **Revision 3 (RC4-128)** - Works with free version
- **Revisions 4-6 (AES)** - Require Premium Encryption module (EUR 50)
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

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Output & Serialization</h2>

##### Save
```xojo
Sub Save(file As FolderItem)
```

**Description**: Generates and saves the PDF to a file. Xojo PDFDocument-compatible method.

**Example**:
```xojo
Dim f As FolderItem = SpecialFolder.Desktop.Child("output.pdf")
pdf.Save(f)
```

##### SaveToFile
```xojo
Sub SaveToFile(path As String)
```

**Description**: Generates and saves the PDF to a file using a String path.

##### ToData
```xojo
Function ToData() As MemoryBlock
```

**Returns**: PDF document as MemoryBlock. Xojo PDFDocument-compatible method.

##### Output
```xojo
Function Output() As String
```

**Returns**: PDF document as binary String for custom handling.

##### OutputAndClose
```xojo
Function OutputAndClose() As String
```

**Returns**: PDF document as binary String, then closes the document. Convenience method combining Output() + Close().

##### Close
```xojo
Sub Close()
```

**Description**: Validates clip/transform nesting and closes the document. Automatically called by Output() and SaveToFile().

##### ToJSON
```xojo
Function ToJSON(prettyPrint As Boolean = False) As String
```

**Returns**: JSON string representation of document state (metadata, settings, position, colors). Does not include page content or binary data.

##### FromJSON
```xojo
Sub FromJSON(jsonStr As String)
```

**Description**: Restores document configuration from a JSON string created by ToJSON().

##### Template
```xojo
Function Template() As JSONItem
```

**Returns**: JSONItem template of the document configuration. Xojo PDFDocument-compatible.

##### AddFonts
```xojo
Sub AddFonts(f As FolderItem)
```

**Description**: Adds font files from a folder. Xojo PDFDocument-compatible.

##### ClearCache
```xojo
Sub ClearCache()
```

**Description**: Clears internal caches. Xojo PDFDocument-compatible.

---

<h2 align="center" style="background-color: #f0f0f0; padding: 10px;">Utility</h2>

##### GetVersionString
```xojo
Function GetVersionString() As String
```

**Returns**: Version string (e.g., "VNS PDF 1.3.0").

##### GetConversionRatio
```xojo
Function GetConversionRatio() As Double
```

**Returns**: Scale factor from user units to PDF points (e.g., 2.8346 for mm, 72.0 for inches).

##### GetPageSizeStr
```xojo
Function GetPageSizeStr(sizeStr As String) As Pair
```

**Returns**: Pair(width, height) in user units for the given page size string ("A4", "Letter", etc.). Nil if invalid.

##### FormatPDF
```xojo
Function FormatPDF(value As Double, decimals As Integer = 2) As String
```

**Returns**: Number formatted for PDF stream output (locale-independent, always uses period as decimal separator).

##### IsPDFAMode
```xojo
Function IsPDFAMode() As Boolean
```

**Returns**: True if a PDF/A output intent has been added.

##### SetSourceFile
```xojo
Function SetSourceFile(path As String) As Integer
```

**Returns**: Number of pages in the source PDF. Used for PDF Import (sets up VNSPDFReader).

##### ImportPage
```xojo
Function ImportPage(pageNum As Integer) As Integer
```

**Returns**: Template ID for the imported page, usable with UseTemplate().

##### UseTemplate
```xojo
Sub UseTemplate(templateID As Integer, x As Double = 0, y As Double = 0, w As Double = 0, h As Double = 0)
```

**Description**: Draws an imported page template at the specified position and size.

##### AddOutputIntent
```xojo
Sub AddOutputIntent(subtype As String, outputCondition As String, info As String, iccProfile As MemoryBlock)
```

**Description**: Adds a PDF/A output intent with ICC color profile for archival compliance.

##### Beziergon
```xojo
Sub Beziergon(points() As Pair, style As String = "D")
```

**Description**: Draws a closed shape using cubic Bezier curves through a series of control points.

##### AddLine (Xojo PDFDocument compatibility)
```xojo
Sub AddLine(x1 As Double, y1 As Double, x2 As Double, y2 As Double)
```

**Description**: Xojo PDFDocument-compatible method. Internally calls Line().

##### AddTOCEntry (Xojo PDFDocument compatibility)
```xojo
Sub AddTOCEntry(title As String, Optional pageNumber As Integer = 0, Optional level As Integer = 0)
Sub AddTOCEntry(ParamArray entries() As PDFTOCEntry)
```

**Description**: Xojo PDFDocument-compatible methods for adding table of contents entries (delegates to Bookmark internally).

---

### Private Methods (Internal)

The following private methods are internal to VNSPDFDocument. They are not intended for external use, but are documented here for developers extending or debugging the library.

#### PDF Object Output

| Method | Signature | Description |
|--------|-----------|-------------|
| `Put` | `Private Sub Put(s As String)` | Appends a string to the PDF output buffer |
| `NewObj` | `Private Sub NewObj(forcedObjNum As Integer = 0)` | Creates a new PDF object and registers its byte offset |
| `PutHeader` | `Private Sub PutHeader()` | Writes the %PDF-x.x header |
| `PutPages` | `Private Sub PutPages()` | Outputs all page objects and their content streams |
| `PutPage` | `Private Sub PutPage(pageNum As Integer)` | Outputs a single page object |
| `PutResources` | `Private Sub PutResources()` | Outputs all PDF resources (fonts, images, gradients, etc.) |
| `PutResourceDict` | `Private Sub PutResourceDict()` | Builds the resource dictionary for each page |
| `PutCatalog` | `Private Sub PutCatalog()` | Outputs the document catalog object |
| `PutDisplayMode` | `Private Sub PutDisplayMode()` | Outputs initial view settings (zoom, layout) |
| `PutInfo` | `Private Sub PutInfo()` | Outputs document metadata (Title, Author, etc.) |
| `PutTrailer` | `Private Sub PutTrailer()` | Outputs the PDF trailer and cross-reference table |
| `PutXref` | `Private Sub PutXref()` | Outputs the cross-reference table |

#### Font Internals

| Method | Signature | Description |
|--------|-----------|-------------|
| `AddCoreFont` | `Private Sub AddCoreFont(family As String, style As String)` | Registers a core PDF font (Helvetica, Times, Courier) |
| `PutTrueTypeFont` | `Private Sub PutTrueTypeFont(fontInfo As Dictionary)` | Embeds a TrueType font object |
| `PutUTF8Font` | `Private Sub PutUTF8Font(fontInfo As Dictionary)` | Embeds a UTF-8 font with subsetting and CIDFont objects |
| `AllocateFontObjects` | `Private Sub AllocateFontObjects()` | Pre-allocates object numbers for all registered fonts |

#### Image Internals

| Method | Signature | Description |
|--------|-----------|-------------|
| `PutImages` | `Private Sub PutImages()` | Outputs all registered images as PDF XObject streams |
| `PutJPEGImage` | `Private Sub PutJPEGImage(imageInfo As Dictionary)` | Outputs a JPEG image stream |
| `PutPNGImage` | `Private Sub PutPNGImage(imageInfo As Dictionary)` | Outputs a PNG image stream (extracts IDAT, handles alpha) |
| `ExtractPNGIDAT` | `Private Function ExtractPNGIDAT(pngData As String) As String` | Extracts raw IDAT data from PNG binary |

#### Text Internals

| Method | Signature | Description |
|--------|-----------|-------------|
| `SplitTextToLines` | `Private Function SplitTextToLines(txt As String, maxWidth As Double) As String()` | Word-wraps text to fit within maxWidth |
| `OutputWordInWrite` | `Private Sub OutputWordInWrite(h As Double, word As String, suffix As String)` | Outputs a single word during Write() flow |
| `EscapeText` | `Private Function EscapeText(txt As String) As String` | Escapes special PDF characters in text strings |
| `TextString` | `Private Function TextString(txt As String) As String` | Wraps text in PDF string delimiters with escaping |
| `UTF8ToUTF16BE` | `Private Function UTF8ToUTF16BE(txt As String, includeBOM As Boolean) As String` | Converts UTF-8 string to UTF-16BE encoding |
| `UTF8ToCodePoints` | `Private Function UTF8ToCodePoints(utf8String As String) As Integer()` | Converts UTF-8 to array of Unicode code points |
| `ShapeArabicText` | `Private Function ShapeArabicText(txt As String) As String` | Applies Arabic presentation forms for cursive rendering |

#### Color & Graphics Internals

| Method | Signature | Description |
|--------|-----------|-------------|
| `FillDrawOp` | `Private Function FillDrawOp(style As String) As String` | Converts style string ("D","F","DF") to PDF operator |
| `Gradient` | `Private Sub Gradient(tp As Integer, r1..., x1..., r As Double)` | Core gradient output (linear/radial) |
| `GradientMultiStop` | `Private Sub GradientMultiStop(tp As Integer, stops()..., r As Double)` | Multi-stop gradient with stitching functions |
| `PutGradients` | `Private Sub PutGradients()` | Outputs all gradient shading pattern objects |
| `PutBlendModes` | `Private Sub PutBlendModes()` | Outputs transparency blend mode ExtGState objects |

#### Encryption Internals

| Method | Signature | Description |
|--------|-----------|-------------|
| `EncryptString` | `Private Function EncryptString(txt As String, objectNumber As Integer) As String` | Encrypts a string using the current encryption key |
| `PutEncryption` | `Private Sub PutEncryption()` | Outputs the encryption dictionary object |

#### Bookmark & Attachment Internals

| Method | Signature | Description |
|--------|-----------|-------------|
| `PutBookmarks` | `Private Sub PutBookmarks()` | Outputs bookmark (outline) objects |
| `PutAttachments` | `Private Sub PutAttachments()` | Outputs document-level file attachment objects |
| `PutAnnotationsAttachments` | `Private Sub PutAnnotationsAttachments()` | Outputs page-level attachment annotations |
| `EmbedAttachment` | `Private Sub EmbedAttachment(a As VNSPDFAttachment)` | Embeds a single attachment as a PDF stream |

#### Other Internals

| Method | Signature | Description |
|--------|-----------|-------------|
| `CloseDocument` | `Private Sub CloseDocument()` | Finalizes and outputs the complete PDF structure |
| `CheckBounds` | `Private Sub CheckBounds(x, y, w, h, context As String)` | Logs warning if coordinates are outside page bounds |
| `OutputFontSelection` | `Private Sub OutputFontSelection()` | Writes font selection command to page stream |
| `OutputTextColor` | `Private Sub OutputTextColor()` | Writes text color command to page stream |
| `OutputDashPattern` | `Sub OutputDashPattern()` | Writes dash pattern command to page stream |
| `PutOutputIntents` | `Private Sub PutOutputIntents()` | Outputs PDF/A output intent objects |
| `PutXmpMetadata` | `Private Sub PutXmpMetadata()` | Outputs XMP metadata stream |
| `PutXObjects` | `Private Sub PutXObjects()` | Outputs imported page XObject templates |
| `PutImportedObjects` | `Private Sub PutImportedObjects()` | Outputs objects from imported PDFs |
| `RoundedRectPath` | `Private Sub RoundedRectPath(x, y, w, h, rTL, rTR, rBR, rBL)` | Builds rounded rectangle path commands |
| `CurveTo` | `Private Sub CurveTo(cx0, cy0, cx1, cy1, x, y)` | Appends a cubic Bezier curve to current path |
| `PointTo` | `Private Sub PointTo(x, y)` | Appends a moveTo command to current path |
| `CallHeader` | `Private Sub CallHeader()` | Invokes the header callback delegate |
| `CallFooter` | `Private Sub CallFooter()` | Invokes the footer callback delegate |

---

## VNSPDFPathSegment

**Location**: `PDF_Library/Core/VNSPDFPathSegment.xojo_code`

Data class representing a single segment in a `VNSPDFGraphicsPath`. Each segment has a type and up to 6 coordinate values depending on the segment type.

### Constructor

```xojo
Sub Constructor(segType As VNSPDFModule.ePathSegmentType,
                x As Double = 0, y As Double = 0,
                cp1x As Double = 0, cp1y As Double = 0,
                cp2x As Double = 0, cp2y As Double = 0)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `mSegmentType` | `ePathSegmentType` | Segment type (MoveTo, LineTo, CubicBezierTo, etc.) |
| `mX` | `Double` | Target X coordinate |
| `mY` | `Double` | Target Y coordinate |
| `mCp1X` | `Double` | First control point X (cubic/quadratic Bezier) |
| `mCp1Y` | `Double` | First control point Y (cubic/quadratic Bezier) |
| `mCp2X` | `Double` | Second control point X (cubic Bezier) / Width (rectangle) |
| `mCp2Y` | `Double` | Second control point Y (cubic Bezier) / Height (rectangle) |

**Notes**:
- All coordinates are in the document's current unit (typically millimeters)
- For `Rectangle` segments, `mX/mY` is the top-left corner, `mCp2X` is width, `mCp2Y` is height
- For `CloseSubpath` segments, all coordinate values are ignored
- See [05-enumerations.md](05-enumerations.md) for `ePathSegmentType` values

---

## VNSPDFGraphicsPath

**Location**: `PDF_Library/Core/VNSPDFGraphicsPath.xojo_code`

A Xojo `GraphicsPath`-compatible class for building complex vector paths with lines, curves, arcs, rectangles, and round rectangles. Paths can be rendered, filled, or used as clipping regions via `VNSPDFGraphics` or directly through `VNSPDFDocument.RenderPath`/`ClipPath`.

For comprehensive documentation including all methods, usage examples, arc mathematics, and Xojo compatibility tables, see **[19-graphicspath.md](19-graphicspath.md)**.

### Key Methods Summary

| Method | Description |
|--------|-------------|
| `MoveToPoint(x, y)` | Move to point without drawing |
| `AddLineToPoint(x, y)` | Straight line to point |
| `AddCurveToPoint(cp1x, cp1y, cp2x, cp2y, x, y)` | Cubic Bezier curve |
| `AddQuadraticCurveToPoint(cpX, cpY, x, y)` | Quadratic Bezier curve |
| `AddArc(x, y, radius, startRadian, endRadian, ccw)` | Circular arc |
| `AddRectangle(x, y, w, h)` | Axis-aligned rectangle |
| `AddRoundRectangle(x, y, w, h, cornerW, cornerH)` | Rounded rectangle |
| `CloseSubpath()` | Close current subpath |
| `ToPDFCommands(doc) As String` | Generate PDF path operators |
| `Bounds() As Rect` | Bounding box of entire path |
| `Contains(x, y) As Boolean` | Point-in-path hit testing |
| `IsEmpty As Boolean` | True if no segments |
| `IsRectangle As Boolean` | True if path is a single rectangle |
| `GetSegments() As VNSPDFPathSegment()` | Get all segments |
| `GetPoints() As Point()` | Flattened points (backward compat) |

### Integration with VNSPDFGraphics

```xojo
Dim g As VNSPDFGraphics = pdf.Graphics

Dim path As New VNSPDFGraphicsPath
path.AddRoundRectangle(10, 10, 80, 50, 8, 8)

g.DrawPath(path)       // Stroke outline
g.FillPath(path)       // Fill interior
g.ClipToPath(path)     // Use as clipping region
```

### Direct Integration with VNSPDFDocument

```xojo
Dim path As New VNSPDFGraphicsPath
path.MoveToPoint(50, 50)
path.AddCurveToPoint(80, 20, 120, 80, 150, 50)

Dim cmds As String = path.ToPDFCommands(pdf)
pdf.RenderPath(cmds, "DF")   // Fill and stroke
pdf.ClipPath(cmds, False)    // Use as clip region
```

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

#### colorStops
```xojo
Property colorStops() As Pair
```
Array of color stops for multi-stop gradients. Each Pair contains:
- `Left` - Position along gradient (0.0-1.0) as Double
- `Right` - Color string in PDF format (e.g., "1 0 0" for red)

Used by LinearGradientMultiStop() for FunctionType 3 stitching functions.

### Notes

- This class is **internal** and should not be instantiated directly by users
- Gradient objects are created automatically by LinearGradient(), RadialGradient(), and LinearGradientMultiStop() methods
- Gradient data is stored in the document's gradient list (mGradientList array)
- PDF output generated during PutGradients() phase
- Each gradient becomes a PDF shading pattern resource
- Coordinates are normalized (0.0 to 1.0) relative to the gradient rectangle
- Multi-stop gradients use FunctionType 3 (stitching) with FunctionType 2 segments

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
- **Revision 3**: 128-bit RC4 (RECOMMENDED - works with free version)
- **Revision 4**: 128-bit AES-CBC (PDF 1.6) - Requires Premium Encryption module
- **Revision 5**: 256-bit AES-CBC (PDF 1.7 Ext 3) - Requires Premium Encryption module
- **Revision 6**: 256-bit AES-CBC (PDF 2.0) - Requires Premium Encryption module

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

### Premium Encryption Module

**AES Encryption (Revisions 4-6)**:
- All AES revisions now fully working via Premium Encryption module
- Pure Xojo AES-CBC implementation with proper PKCS7 padding control
- **Revision 4**: 128-bit AES (PDF 1.6)
- **Revision 5**: 256-bit AES (PDF 1.7 Extension Level 3)
- **Revision 6**: 256-bit AES (PDF 2.0)
- Available as premium add-on module (EUR 50)

**Security Considerations**:
- RC4 is deprecated but still widely supported (free version)
- Adobe Acrobat shows warning for RC4 (expected behavior)
- For maximum security, use AES-256 (Revisions 5-6) with Premium Encryption module
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

**Subclasses** (10 types):
1. **VNSPDFNull** - Null value
2. **VNSPDFBoolean** - True/false
3. **VNSPDFNumeric** - Integer and real numbers (handles both)
4. **VNSPDFString** - Literal strings
5. **VNSPDFHexString** - Hexadecimal strings
6. **VNSPDFName** - PDF names (e.g., `/Type`, `/Pages`)
7. **VNSPDFArray** - Arrays of PDF objects
8. **VNSPDFDictionary** - Key-value dictionaries
9. **VNSPDFStream** - Binary data streams
10. **VNSPDFIndirectObjectReference** - Indirect object references

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
