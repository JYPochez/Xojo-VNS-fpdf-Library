# HTML & Markdown Import Module (Premium)

**Status**: Available
**Price**: Part of Premium Bundle
**Flag**: `hasPremiumVNSHTMLModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create an `HTMLMarkdownModule` subfolder inside it. Drag the following files into that folder:

- `VNSPDFHTMLPremium.xojo_code`
- `VNSPDFHTMLRenderer.xojo_code`
- `VNSPDFHTMLTableRenderer.xojo_code`
- `VNSPDFHTMLToken.xojo_code`

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
hasPremiumVNSHTMLModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether HTML and Markdown import features (`LoadHTML()`, `LoadMarkdown()`) are available. If the flag is `False`, these methods will return an error message indicating the premium module is required.

---

## Overview

The HTML & Markdown Import Module adds `LoadHTML()` and `LoadMarkdown()` methods to VNSPDFDocument, converting HTML or Markdown content directly to PDF using existing FPDF rendering methods. Includes robust Word/Summernote HTML cleaning to handle real-world messy HTML input.

---

## File Structure

```
PDF_Library/Premium/HTMLMarkdownModule/
├── VNSPDFHTMLPremium.xojo_code        # Main module: LoadHTML(), LoadMarkdown(), HTML cleaning, Markdown parser
├── VNSPDFHTMLRenderer.xojo_code       # HTML tokenizer + rendering engine
├── VNSPDFHTMLTableRenderer.xojo_code  # Table/image rendering + CSS parsing helpers
└── VNSPDFHTMLToken.xojo_code          # Token class: type, tag, attributes, content
```

## Architecture

The module uses a **two-phase processing pipeline**:

1. **Phase 1 - Cleaning**: `SmartCleanHTML()` aggressively strips Word/Summernote artifacts (can reduce 578KB to 182KB = 68% reduction)
2. **Phase 2 - Parse & Render**: `ParseAndRenderHTML()` tokenizes cleaned HTML and renders to PDF

For Markdown: `MarkdownToHTML()` converts Markdown to HTML first, then follows the same pipeline.

---

## Class / Module Design

### VNSPDFHTMLPremium (Protected Module)

**Public entry points (called from VNSPDFDocument delegation):**

```xojo
Sub LoadHTML(doc As VNSPDFDocument, html As String, maxWidth As Double = 0, imageFolder As FolderItem = Nil)
Sub LoadMarkdown(doc As VNSPDFDocument, markdown As String, maxWidth As Double = 0, imageFolder As FolderItem = Nil)
```

**Configurable base font size**: Set the font on the document before calling `LoadHTML()` to control the base size. All CSS `em`/`%` font sizes, heading sizes, and line heights derive from this base:

```xojo
doc.SetFont("Helvetica", "", 9)  // 9pt base (default would be 12pt)
doc.LoadHTML(html, 0, imageFolder)
// p { font-size: 0.8em } = 7.2pt, h1 { font-size: 2em } = 18pt
```

**Merge Field Utilities (standalone, no VNSPDFDocument needed):**

```xojo
Function CollectMergeFields(htmlText As String) As String()
// Extracts unique merge field names from HTML content.
// Finds <span class="merge-field" data-field="..."> elements and {{ field.name }} patterns.
// Returns array of field names without delimiters, in order of appearance.

Function ApplyMergeValues(htmlText As String, dictValues As Dictionary) As String
// Replaces merge fields in HTML with values from a Dictionary.
// Handles <span class="merge-field"> elements and {{ field }} patterns.
// Preserves inline styles (font-weight, color, etc.) from merge field spans.
// Editor-only CSS (border-style, border) is stripped automatically.
// Values can be String or Picture (converted to base64 img tag).
// Multiple occurrences of the same field are replaced in order.

Function CollectAnchors(htmlText As String) As String()
// Extracts unique anchor names from HTML content.
// Finds <span class="anchor-field" data-anchor-name="..."> elements.
// Returns array of anchor names in order of appearance.
```

**HTML Cleaning Pipeline** (`SmartCleanHTML`):

```xojo
Protected Function SmartCleanHTML(html As String) As String
// Pipeline steps in order:
//   1. RemoveStyleBlocks - strip <style> and <script> blocks (OnlyOffice/Word artifacts)
//   2. ExtractImagesFromBinaryParagraphs - save img tags before removal
//   3. RemoveBinaryDataParagraphs - strip Word docData base64 blocks
//   4. PrependImages - re-insert extracted images
//   5. RemoveHTMLComments - strip <!-- CSS blocks --> from Word
//   6. StripMSOStyleProperties - remove mso-* CSS properties
//   7. StripWordCSSClasses - remove MsoNormal, MsoPapDefault, etc.
//   8. CleanStrayBRTags - normalize <br> variants
//   9. DecodeHTMLEntities - decode &nbsp; &lt; &gt; &amp; and numeric entities
//  10. NormalizeWhitespace - collapse multiple spaces/newlines
```

**Markdown Parser:**

```xojo
Protected Function MarkdownToHTML(markdown As String) As String
// Converts Markdown to HTML supporting:
//   # Heading 1 through ###### Heading 6
//   **bold**, *italic*, ~~strikethrough~~
//   `inline code` and ``` fenced code blocks ```
//   - unordered lists, 1. ordered lists
//   [link text](url)
//   ![alt text](image path or base64)
//   > blockquotes
//   --- horizontal rules
//   | col1 | col2 | tables with |---|---| separator
```

### VNSPDFHTMLRenderer (Protected Module)

**Main rendering engine:**

```xojo
Sub ParseAndRenderHTML(doc As VNSPDFDocument, html As String, maxWidth As Double = 0)
// Tokenizes HTML then iterates tokens rendering to PDF
// Handles: p, h1-h6, b/strong, i/em, u, s/del/strike, br, hr, img, table,
//          ul/ol/li, blockquote, code/pre, span, font, a, sub, sup
// Supports text-align: left, center, right, justify on <p>/<div>
// Simulated bold/italic for UTF-8 fonts without B/I variants
```

**HTML Tokenizer:**

```xojo
Function TokenizeHTML(html As String) As VNSPDFHTMLToken()
// Splits HTML into token sequence: open, close, text, self-closing
Sub ParseTagAndAttributes(tagContent As String, token As VNSPDFHTMLToken)
// Parses tag name and attribute key-value pairs
```

**Inline style support:**

```xojo
Protected Sub ApplyInlineStyle(doc As VNSPDFDocument, token As VNSPDFHTMLToken)
// Extracts and applies font-size, color, background-color, text-decoration from style attribute
```

### VNSPDFHTMLTableRenderer (Protected Module)

**Table rendering:**

```xojo
Protected Function ParseTable(tokens() As VNSPDFHTMLToken, ByRef idx As Integer, ...) As Dictionary()
// Parses <table> tokens into row/cell data structure
// Each row: Dictionary with "cells", "isHeader", "hidden" (display:none)
// Each cell: Dictionary with "content", "isHeader", "align", "colspan",
//   "widthPercent", "bold", "italic", "spanStyle", border info

Protected Sub RenderTable(doc As VNSPDFDocument, rows() As Dictionary, lineHeight As Double, drawBorders As Boolean = True)
// Renders parsed table with proportional column widths (from CSS/attribute percentages),
// colspan support, CSS class styles on cells, display:none row skipping,
// bold/italic from inline tags, CSS border styles (solid, dotted, dashed, double),
// border="0" suppresses default borders and header fill
```

**Table features:**
- Column width percentages from `style="width: 48%"`, `width` attribute, or CSS classes
- Colspan: `colspan="4"` spans cell across multiple column widths
- CSS class resolution: `.thCurrency`, `.tdText` etc. resolve text-align, width, borders
- `display:none` on `<tr>` skips entire row
- `border="0"` on `<table>` suppresses cell borders and header fill
- Bold/italic from `<b>`, `<strong>`, `<i>`, `<em>` inside cells
- CSS borders: `border-bottom: 1px dotted #CCCCCC` drawn with proper dash patterns
- Emoji in cells: inline emoji images with vertical centering (via `RenderCellWithEmoji`)
- Emoji in `<pre>` code blocks: rendered with `FlushTextWithEmoji`, no double line spacing
- Non-visual elements skipped: `<title>`, `<head>`, `<style>`, `<script>` content not rendered
- Layout table detection: single-column borderless tables render inner content as normal flow (float layout preserved)

**Image rendering:**

```xojo
Protected Sub RenderImage(doc As VNSPDFDocument, token As VNSPDFHTMLToken, maxWidth As Double, lineHeight As Double)
// Handles base64 data: URIs, HTTP(S) URLs, and local file paths
// URLs downloaded via URLConnection.SendSync with 30s timeout
// Local files resolved from imageFolder (FolderItem) passed to LoadHTML()
// Image cache prevents re-downloading same URL within a single LoadHTML() call
// Uses native Xojo image decoding for reliable cross-platform rendering
// Respects width/height attributes; defaults to actual pixel size at 96 DPI
```

**CSS helpers:**

```xojo
Protected Function ParseCSSColor(colorStr As String) As Color
// Handles: #RRGGBB, #RGB, rgb(r,g,b), named colors (50+ color names)

Protected Function ParseStyleAttribute(styleStr As String) As Dictionary
// Parses CSS style string into key-value Dictionary

Protected Function MapCSSFontFamily(cssFontFamily As String) As String
// Maps CSS font names to PDF core fonts (Arial->Helvetica, etc.)

Protected Function ParseCSSFontSize(sizeStr As String, currentSize As Double) As Double
// Parses pt, px, em, %, and named sizes (small, medium, large, etc.)

Protected Function ParseHTMLFontSize(sizeLevel As Integer, currentSize As Double) As Double
// Converts HTML <font size="1-7"> to point sizes
```

### VNSPDFHTMLToken (Class)

```xojo
Class VNSPDFHTMLToken
  Property TokenType As String    // "open", "close", "text", "self-closing" (read-only computed)
  Property Tag As String          // "p", "b", "img", "table", "h1", etc.
  Property TagAttributes As Dictionary  // src, style, class, href, etc.
  Property Content As String      // Text content for text nodes
End Class
```

---

## Integration with Free Library

### VNSPDFDocument delegation (in free library)

```xojo
Sub LoadHTML(html As String, maxWidth As Double = 0)
  #If hasPremiumVNSHTMLModule Then
    VNSPDFHTMLPremium.LoadHTML(Self, html, maxWidth)
  #Else
    SetError("LoadHTML requires the premium HTML/Markdown Import module.")
  #EndIf
End Sub

Sub LoadMarkdown(markdown As String, maxWidth As Double = 0)
  #If hasPremiumVNSHTMLModule Then
    VNSPDFHTMLPremium.LoadMarkdown(Self, markdown, maxWidth)
  #Else
    SetError("LoadMarkdown requires the premium HTML/Markdown Import module.")
  #EndIf
End Sub
```

### VNSPDFModule constant

```xojo
Public Const hasPremiumVNSHTMLModule As Boolean = False  // Set to True when module installed
```

---

## Supported HTML Tags

| Tag | Rendering |
|-----|-----------|
| `<p>`, `<div>` | Block with `text-align` support: left, center, right, justify, full block-level CSS |
| `<h1>` - `<h6>` | `SetFont()` with scaled size + bold + `MultiCell()` |
| `<b>`, `<strong>` | `SetFont(family, "B", size)` |
| `<i>`, `<em>` | `SetFont(family, "I", size)` |
| `<u>` | `SetFont(family, "U", size)` |
| `<s>`, `<del>`, `<strike>` | Strikethrough via `SetFont(family, "S", size)` |
| `<span>` | Inline formatting via style attribute |
| `<font>` | Legacy font size/color/face support |
| `<br>` | Line break via `Ln()` |
| `<hr>` | `Line()` across page width |
| `<img>` | JPEG conversion via `Picture.FromData()` + `RegisterImageFromBytes()` (handles RGBA PNGs) |
| `<table>`, `<tr>`, `<td>`, `<th>` | Equal-width columns via `Cell()`, header row with gray fill, cell text-align from `<td>` or inner `<p>` |
| `<ul>`, `<ol>`, `<li>` | Bullet/number prefix + `Cell()` |
| `<blockquote>` | Gray left border bar (per-page for multi-page), indented italic gray text |
| `<code>`, `<pre>` | Monospace font (Courier), gray background per line with multi-page support |
| `<a href>` | Rendered text (link styling) |
| `<sub>`, `<sup>` | Subscript/superscript via PDF text rise (`Ts` operator) |

**Emoji support**: Emoji characters in text are automatically detected and rendered as inline images, interleaved with surrounding text. Emoji underlines are preserved inside links.

## Supported CSS Properties

### Inline CSS (via `style=""` attribute)
| Property | Support |
|----------|---------|
| `font-family` | Maps to PDF core fonts (Arial->Helvetica, etc.) |
| `font-size` | pt, px, em, %, named sizes (small, medium, large) |
| `font-weight` | bold |
| `font-style` | italic |
| `color` | #RRGGBB, #RGB, rgb(r,g,b), 50+ named colors |
| `background-color` | Cell/block background fill |
| `text-decoration` | underline, line-through |
| `text-align` | left, center, right, justify |

### Block-Level CSS (via `style=""` or `<style>` blocks)
| Property | Support |
|----------|---------|
| `width`, `max-width` | px, %, constrains block content area |
| `margin` | Shorthand (1-4 values) and individual sides. `margin: 0 auto` centering with `max-width` |
| `padding` | Shorthand (1-4 values) and individual sides. Font-metrics-based vertical centering |
| `border` | `border: 1px solid #333` shorthand, individual sides (top, right, bottom, left). Styles: `solid`, `dotted`, `dashed`, `double`. Width keywords `thin`/`medium`/`thick` supported. `border: medium;` without style correctly renders no border. |
| `float` | `left`, `right` — floated blocks render side-by-side with specified width |
| `clear` | `both`, `left`, `right` — ends float context, moves Y past active floats |
| `background-color` | Block-level background fill behind content and borders |
| `line-height` | Unitless multiplier, px, normal |
| `display` | `none` to hide elements |
| `text-transform` | `uppercase`, `lowercase`, `capitalize` |

### CSS Box Model Rendering
Block-level elements with borders, backgrounds, or padding render a complete CSS box model:
- **Background**: Filled rectangle behind all content, inserted before borders in PDF stream
- **Borders**: All 4 sides drawn independently with individual color, width, and style (solid, dotted, dashed, double)
- **Padding**: Controls visual space between content and borders using font metrics (ascent/descent from `GetFontDesc()`) for precise vertical centering
- **Margin collapsing**: Last child trailing gap collapsed inside styled parent blocks
- **Centered blocks**: `margin: 0 auto` with `max-width` properly centers the box and constrains text wrapping
- **Nested boxes**: Full push/pop state management for arbitrarily nested styled blocks
- **Inline spans in tables**: `<span>` with CSS class styling (color, background-color, font-weight, font-size) rendered in table cells

### CSS Custom Properties (Variables)

CSS custom properties defined in `:root` blocks are fully supported:

```html
<style>
:root {
  --primary-color: #333333;
  --bg-color: #f5f5f5;
  --font-size: 100%;
}
</style>
<div style="color: var(--primary-color); background-color: var(--bg-color)">
  Styled with CSS variables
</div>
```

**Features:**
- `:root { --name: value; }` parsed and stored in internal dictionary
- `var(--name)` resolved in any `style` attribute or `<style>` block value
- `var(--name, fallback)` with fallback when variable is undefined
- Nested `var()` references supported (up to 20 iterations to prevent infinite loops)
- Multiple `:root` blocks supported — later blocks override earlier values (useful for theme overrides)
- `@media (prefers-color-scheme: dark)` blocks are skipped (light mode rendering only)
- Variables work in all CSS contexts: inline `style=""`, class rules in `<style>`, and shorthand properties

**Resolution process:**
1. `ParseCSSVariables()` extracts all `:root` blocks from `<style>` tags, skipping `@media` blocks
2. `ResolveCSSVariables()` replaces `var(--name)` references in any style string
3. Resolution happens BEFORE property parsing, so variables work with any CSS property

**Supported selector types:**

| Selector | Example | Supported |
|----------|---------|-----------|
| Universal | `* { ... }` | Yes (lowest specificity) |
| Class | `.content { ... }` | Yes |
| Element | `p { ... }` | Yes |
| Element.class | `div.card { ... }` | Yes |
| ID | `#header { ... }` | Yes |
| Comma-separated | `.card, .url-card { ... }` | Yes |
| `:root` | `:root { --var: value }` | Yes (variables only) |
| Descendant | `.card a { ... }` | No |
| Child/sibling | `.row > .block`, `.block + .next` | No |
| Pseudo-class | `:hover`, `:first-child` | No |
| Attribute | `[type="text"]` | No |

### `<style>` Block Support
CSS rules from `<style>` tags in the HTML `<head>` are extracted and applied:
- Class selectors (`.myclass { ... }`)
- Element selectors (`p { ... }`)
- Element.class selectors (`div.card { ... }`)
- ID selectors (`#header { ... }`)
- Comma-separated selectors (`.card, .url-card { ... }`)
- Merges with inline `style=""` attributes (inline takes precedence)
- `!important` suffix is stripped automatically

## Supported Markdown Syntax

| Syntax | HTML Output |
|--------|-------------|
| `# Heading` through `######` | `<h1>` - `<h6>` |
| `**bold**` | `<b>` |
| `*italic*` | `<i>` |
| `~~strikethrough~~` | `<s>` |
| `` `code` `` | `<code>` |
| ```` ``` code block ``` ```` | `<pre><code>` |
| `- item` | `<ul><li>` |
| `1. item` | `<ol><li>` |
| `[text](url)` | `<a href>` |
| `![alt](src)` | `<img>` |
| `> quote` | `<blockquote>` |
| `---` | `<hr>` |
| `\| col \| col \|` | `<table>` |

---

## Font Mapping

| CSS Font | PDF Font |
|----------|----------|
| Helvetica, sans-serif | Helvetica (core PDF font) |
| Times, serif | Times (core PDF font) |
| Courier, monospace | Courier (core PDF font) |
| Arial, Verdana, Georgia, Trebuchet MS, Palatino, etc. | Auto-loaded from system TrueType fonts |
| Any font not found on system | Falls back to nearest core font (sans-serif→Helvetica, serif→Times, monospace→Courier) |
| Custom TrueType | Used directly if pre-loaded via `AddUTF8Font` |

---

## Usage Examples

### HTML Import (Example 27)
```xojo
Var pdf As New VNSPDFDocument
pdf.SetFont("Helvetica", "", 10)

// Load from file - auto-cleans Word/Summernote HTML
Var htmlContent As String = myFolderItem.Read
pdf.LoadHTML(htmlContent)

pdf.Save(outputFile)
```

### Markdown Import (Example 28)
```xojo
Var pdf As New VNSPDFDocument
pdf.SetFont("Helvetica", "", 10)

Var md As String = "# Report" + EndOfLine + _
  "This is **bold** and *italic*." + EndOfLine + _
  "" + EndOfLine + _
  "| Column A | Column B |" + EndOfLine + _
  "|----------|----------|" + EndOfLine + _
  "| Value 1  | Value 2  |"

pdf.LoadMarkdown(md)
pdf.Save(outputFile)
```

### Merge Fields: Collect and Replace

Merge fields are placeholders in HTML that can be replaced with dynamic values. Two formats are supported:
- **Summernote span elements**: `<span class="merge-field" data-field="customer.name">{{customer.name}}</span>`
- **Template syntax**: `{{customer.name}}`

#### Collecting Merge Fields

```xojo
Var html As String = "<p>Dear <span class=""merge-field"" data-field=""customer.name"">{{customer.name}}</span>,</p>" + _
  "<p>Your order {{order.id}} totals {{order.total}}.</p>"

Var fields() As String = VNSPDFHTMLPremium.CollectMergeFields(html)
// fields = ["customer.name", "order.id", "order.total"]
```

#### Replacing Merge Fields with Values

```xojo
Var dict As New Dictionary
dict.Value("customer.name") = "John Doe"
dict.Value("order.id") = "ORD-2026-001"
dict.Value("order.total") = "149.99 EUR"

Var mergedHTML As String = VNSPDFHTMLPremium.ApplyMergeValues(html, dict)
// Result: <p>Dear John Doe,</p><p>Your order ORD-2026-001 totals 149.99 EUR.</p>
```

#### Using Pictures as Merge Values (e.g. Signatures)

```xojo
Var dict As New Dictionary
dict.Value("customer.name") = "John Doe"
dict.Value("customer.signature") = mySignaturePicture  // Xojo Picture object

Var mergedHTML As String = VNSPDFHTMLPremium.ApplyMergeValues(html, dict)
// Picture values are converted to <img src="data:image/png;base64,..." /> tags
```

#### Full Workflow: Collect, Merge, Render to PDF

```xojo
// 1. Load HTML template (e.g. from Summernote editor or file)
Var templateHTML As String = myTemplateFile.Read

// 2. See what fields the template needs
Var fields() As String = VNSPDFHTMLPremium.CollectMergeFields(templateHTML)
// fields = ["customer.name", "customer.email", "invoice.total", "customer.signature"]

// 3. Build values dictionary (e.g. from database)
Var dict As New Dictionary
dict.Value("customer.name") = customerRow.Column("name").StringValue
dict.Value("customer.email") = customerRow.Column("email").StringValue
dict.Value("invoice.total") = Format(invoiceTotal, "#,##0.00") + " EUR"
dict.Value("customer.signature") = signaturePicture

// 4. Apply merge values
Var mergedHTML As String = VNSPDFHTMLPremium.ApplyMergeValues(templateHTML, dict)

// 5. Render to PDF
Var pdf As New VNSPDFDocument
pdf.SetFont("Helvetica", "", 10)
pdf.LoadHTML(mergedHTML)
pdf.Save(outputFile)
```

#### Collecting Anchor Names

```xojo
Var anchors() As String = VNSPDFHTMLPremium.CollectAnchors(html)
// Returns: ["section1", "chapter2", "appendix"]
```

All merge field and anchor utilities are **standalone methods** — they work on any HTML string, no VNSPDFDocument needed. Use them independently for HTML processing, then optionally render to PDF.

---

## Word/Summernote HTML Cleaning

The `SmartCleanHTML` pipeline handles real-world messy HTML from Microsoft Word and Summernote editors:

| Step | What | Impact |
|------|------|--------|
| Extract Images | Save `<img>` tags from binary paragraphs before removal | Preserves embedded images |
| Remove Binary Data | Strip `<p class="docData;...">` base64 blocks | 66% of file size (biggest impact) |
| Prepend Images | Re-insert extracted images at document start | Images available for rendering |
| Remove Comments | Strip `<!-- CSS blocks -->` from Word | 11 KB typical |
| Strip MSO Styles | Remove `mso-*` CSS properties from inline styles | Cleaner CSS |
| Strip Word Classes | Remove `MsoNormal`, `MsoPapDefault`, etc. | Cleaner HTML |
| Clean BR Tags | Normalize `<br>` variants | Consistent line breaks |
| Decode Entities | Convert `&nbsp;`, `&lt;`, `&gt;`, `&amp;`, numeric entities | Proper text |
| Normalize Whitespace | Collapse multiple spaces/newlines | 5 KB typical |

---

## Custom Tag Handlers (HTML)

Register custom delegates to intercept any HTML tag during rendering. Custom handlers are checked **before** built-in tag logic, so you can override built-in tags or handle entirely custom tags.

### API

```xojo
// Register a handler for a tag name (case-insensitive)
pdf.RegisterHTMLTagHandler(tagName As String, handler As VNSPDFModule.HTMLTagHandlerDelegate)

// Remove a specific handler
pdf.RemoveHTMLTagHandler(tagName As String)

// Remove all handlers
pdf.RemoveAllHTMLTagHandlers()

// Check if a handler exists (used internally)
pdf.HasHTMLTagHandler(tagName As String) As Boolean

// Get the handler delegate (used internally)
pdf.GetHTMLTagHandler(tagName As String) As VNSPDFModule.HTMLTagHandlerDelegate
```

### Handler Delegate Signature

```xojo
Delegate Sub HTMLTagHandlerDelegate(doc As VNSPDFDocument, token As VNSPDFHTMLToken, isClosing As Boolean)
```

- `doc`: The document being rendered into
- `token`: The HTML token with `.Tag`, `.TagAttributes`, `.Content`
- `isClosing`: `True` for closing tags (`</tag>`), `False` for opening/self-closing tags

### Example: Custom HTML Tag

```xojo
// Register before calling LoadHTML
pdf.RegisterHTMLTagHandler("company-header", AddressOf CompanyHeaderHandler)
pdf.LoadHTML("<company-header>ACME Corp</company-header><p>Hello world</p>")

Sub CompanyHeaderHandler(doc As VNSPDFDocument, token As VNSPDFHTMLToken, isClosing As Boolean)
  If Not isClosing Then
    doc.SetFont("Helvetica", "B", 20)
    doc.SetTextColor(Color.RGB(0, 0, 128))
  Else
    doc.Ln(8)
    doc.SetFont("Helvetica", "", 10)
    doc.SetTextColor(Color.RGB(0, 0, 0))
  End If
End Sub
```

### Example: Override a Built-in Tag

```xojo
// Override <h1> to use a custom font and color
pdf.RegisterHTMLTagHandler("h1", AddressOf CustomH1Handler)
```

---

## Custom Line Handlers (Markdown)

Register custom delegates to intercept Markdown lines that match a given prefix. Custom handlers are checked **before** built-in Markdown patterns (headings, lists, etc.), so custom syntax takes priority.

### API

```xojo
// Register a handler for a line prefix
pdf.RegisterMarkdownHandler(prefix As String, handler As VNSPDFModule.MarkdownLineHandlerDelegate)

// Remove a specific handler
pdf.RemoveMarkdownHandler(prefix As String)

// Remove all handlers
pdf.RemoveAllMarkdownHandlers()
```

### Handler Delegate Signature

```xojo
Delegate Function MarkdownLineHandlerDelegate(doc As VNSPDFDocument, line As String) As String
```

- `doc`: The document (for accessing document state or custom properties)
- `line`: The full trimmed Markdown line
- **Returns**: HTML string to insert, or `""` to skip the line

### Example: Warning Blocks

```xojo
pdf.RegisterMarkdownHandler(":::warning", AddressOf WarningBlockHandler)
pdf.LoadMarkdown("# Report" + Chr(10) + ":::warning This needs review")

Function WarningBlockHandler(doc As VNSPDFDocument, line As String) As String
  Var text As String = line.Middle(11)  // skip ":::warning "
  Return "<p><b>WARNING:</b> " + text + "</p>"
End Function
```

### Example: Variable Substitution

```xojo
pdf.RegisterMarkdownHandler("{{var:", AddressOf VariableHandler)
pdf.LoadMarkdown("Company: {{var:company_name}}")

Function VariableHandler(doc As VNSPDFDocument, line As String) As String
  Var varName As String = line.Middle(6, line.Length - 8)  // extract between {{var: and }}
  Select Case varName
  Case "company_name"
    Return "<b>ACME Corporation</b>"
  End Select
  Return ""
End Function
```

---

## Dependencies

- **No external dependencies** - Pure Xojo implementation
- **Required**: VNSPDFDocument (free library core)
- **Optional**: Premium Zlib Module for compressed output on iOS

---

## Block Spacing Model

The renderer uses a CSS-like spacing model with font-metrics-based calculations for precise control over vertical spacing between elements.

### Visual Offset (Top of Styled Blocks)
When a block has a visual boundary (border or background), text is shifted down by the font descent metric:
- `fontSize_mm * (|Descent| / 1000)` — derived from `GetFontDesc()`
- For Helvetica (Descent=-250): `fontSize_mm * 0.25`
- Provides breathing room between the block boundary and the first text line

### Trailing Gap Collapsing
Child div's line advance (`mLineHeight`) is tracked as `mLastTrailingGap`. Parent blocks collapse this with their own `padding-bottom`:
- `max(trailingGap, paddingBottom)` — similar to CSS margin collapsing
- Prevents double-spacing between child content and parent padding
- Nested divs preserve the trailing gap for their parent to collapse

### Margin-Bottom Minimum
CSS `margin-bottom` values are enforced with a minimum of `1.5 * mLineHeight`:
- Approximates browser CSS margin collapsing where adjacent `<p>` default `margin-top: 1em` merges with the preceding block's `margin-bottom`
- Ensures consistent visual spacing between block elements and following paragraphs

---

## Known Limitations

- Table rowspan is not supported (colspan works)
- Images from file paths must be accessible at render time
- CSS `float: right` positions content but does not wrap non-floated content around it
- CSS `position` (absolute, relative, fixed) is not supported
- Single-column borderless tables are auto-detected as layout wrappers (inner content flows normally); nested multi-column tables inside layout wrappers render correctly as grids
- CSS `height` property parsed but not enforced (used for `position: absolute` layout hacks)
- `<font>` tag support is legacy (prefer `<span style="...">`)
