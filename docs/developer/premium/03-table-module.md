# VNSPDFTablePremium Module

**Status**: ✅ Available
**Location**: `PDF_Library/Premium/TableModule/VNSPDFTablePremium.xojo_code`
**Module Flag**: `hasPremiumVNSTableModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create a `TableModule` subfolder inside it. Drag the following files into that folder:

- `VNSPDFTablePremium.xojo_code`
- `VNSPDFTableAccumulator.xojo_code`
- `VNSPDFTableColumnCalc.xojo_code`
- `VNSPDFTableFooterConfig.xojo_code`
- `VNSPDFTableFooterStyle.xojo_code`

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
hasPremiumVNSTableModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether table generation features (SimpleTable, ImprovedTable, FancyTable) are available. If the flag is `False`, table methods will return an error message indicating the premium module is required.

---

## Overview

The Premium Table module provides professional table generation with automatic layout, styling, and multi-page pagination. It includes three table styles with increasing sophistication.

### Table Styles

| Style | Description | Best For |
|-------|-------------|----------|
| SimpleTable | Basic table with borders | Quick data display |
| ImprovedTable | Custom widths, auto-alignment | Reports with numbers |
| FancyTable | Colored headers, alternating rows | Professional documents |

---

## Features

### SimpleTable

- Equal-width columns
- Simple borders
- Basic text display
- Automatic column calculation

### ImprovedTable

- Custom column widths
- Automatic number alignment (right)
- Text alignment (left)
- Header row with bold text

### FancyTable

- Colored header background (customizable)
- Alternating row colors
- Professional appearance
- Full styling options

### Multi-Page Support

- **Automatic Page Breaks** - Tables flow naturally across pages
- **Header Repetition** - Headers automatically repeat on new pages
- **AcceptPageBreak Callback** - Uses PDF delegate system for seamless pagination
- **No Blank Pages** - Proper border handling prevents extra pages

---

## Usage

### SimpleTable

```xojo
// Create document
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                              VNSPDFModule.ePageUnit.Millimeters, _
                              VNSPDFModule.ePageFormat.A4)

// Create in-memory database with sample data
Dim db As New SQLiteDatabase
db.Connect()
db.ExecuteSQL("CREATE TABLE contacts (Name TEXT, City TEXT, Country TEXT)")
db.ExecuteSQL("INSERT INTO contacts VALUES ('John Smith', 'New York', 'USA')")
db.ExecuteSQL("INSERT INTO contacts VALUES ('Marie Dupont', 'Paris', 'France')")
db.ExecuteSQL("INSERT INTO contacts VALUES ('Hans Mueller', 'Berlin', 'Germany')")

// Query data as RowSet
Dim rs As RowSet = db.SelectSQL("SELECT * FROM contacts")

// Generate table (column names from RowSet become headers)
VNSPDFTablePremium.SimpleTable(pdf, rs, 40.0, 7.0)

pdf.Save(SpecialFolder.Desktop.Child("simple_table.pdf"))
```

### ImprovedTable with Custom Widths

```xojo
// Define column widths (must sum to table width or less)
Dim widths() As Double = Array(60.0, 50.0, 40.0, 40.0)

// Query data
Dim rs As RowSet = db.SelectSQL("SELECT Country, Capital, Area, Population FROM countries")

// Generate with custom widths
VNSPDFTablePremium.ImprovedTable(pdf, rs, widths, 7.0)
```

### FancyTable with Styling

```xojo
// Define column widths
Dim widths() As Double = Array(50.0, 40.0, 35.0, 35.0, 30.0)

// Query data
Dim rs As RowSet = db.SelectSQL("SELECT Product, Category, Price, Stock, Sales FROM products")

// Generate fancy table with professional styling
VNSPDFTablePremium.FancyTable(pdf, rs, widths, 7.0)
```

### Multi-Page Table with Header Repetition

```xojo
// Create table with many rows
db.ExecuteSQL("CREATE TABLE employees (Name TEXT, Dept TEXT, Salary REAL, Status TEXT)")
For i As Integer = 1 To 99
  db.ExecuteSQL("INSERT INTO employees VALUES ('Employee " + Str(i) + "', " + _
                "'Dept " + Str((i Mod 5) + 1) + "', " + _
                Str(30000 + i * 100) + ", 'Active')")
Next

Dim rs As RowSet = db.SelectSQL("SELECT * FROM employees")
Dim widths() As Double = Array(50.0, 30.0, 35.0, 25.0)

// Headers repeat automatically on each page
VNSPDFTablePremium.FancyTable(pdf, rs, widths, 7.0, True)  // True = repeatHeaders
```

---

## API Reference

### SimpleTable

```xojo
Sub SimpleTable(doc As VNSPDFDocument, _
                rs As RowSet, _
                cellWidth As Double, _
                cellHeight As Double, _
                repeatHeaders As Boolean = True, _
                footerConfig As VNSPDFTableFooterConfig = Nil)
```

**Parameters**:
- `doc` - The PDF document to add table to
- `rs` - RowSet from database query (column names become headers)
- `cellWidth` - Width of each column (equal widths)
- `cellHeight` - Height of each row
- `repeatHeaders` - If True, headers repeat on page breaks (default: True)
- `footerConfig` - Optional footer configuration for totals/subtotals

### ImprovedTable

```xojo
Sub ImprovedTable(doc As VNSPDFDocument, _
                  rs As RowSet, _
                  columnWidths() As Double, _
                  cellHeight As Double, _
                  repeatHeaders As Boolean = True, _
                  footerConfig As VNSPDFTableFooterConfig = Nil)
```

**Parameters**:
- `doc` - The PDF document
- `rs` - RowSet from database query
- `columnWidths` - Array of column widths (in user units)
- `cellHeight` - Height of each row
- `repeatHeaders` - Header repetition flag
- `footerConfig` - Optional footer configuration

### FancyTable

```xojo
Sub FancyTable(doc As VNSPDFDocument, _
               rs As RowSet, _
               columnWidths() As Double, _
               cellHeight As Double, _
               repeatHeaders As Boolean = True, _
               footerConfig As VNSPDFTableFooterConfig = Nil)
```

**Parameters**:
- `doc` - The PDF document
- `rs` - RowSet from database query
- `columnWidths` - Array of column widths
- `cellHeight` - Height of each row
- `repeatHeaders` - Header repetition flag
- `footerConfig` - Optional VNSPDFTableFooterConfig for totals (SUM, AVG, COUNT, MIN, MAX)

---

## Implementation Details

### AcceptPageBreak Callback

The table module uses `SetAcceptPageBreakFunc` to intercept page breaks and redraw headers:

```xojo
// Store table state for callback
mTableState = New Dictionary
mTableState.Value("headers") = headers
mTableState.Value("widths") = widths
mTableState.Value("pdf") = pdf

// Set callback
pdf.SetAcceptPageBreakFunc(AddressOf TablePageBreakCallback)

// Callback implementation
Function TablePageBreakCallback(doc As VNSPDFDocument) As Boolean
  // Add new page
  doc.AddPage()

  // Redraw headers
  DrawTableHeaders(doc, mTableState)

  // Return False = we handled page break
  Return False
End Function
```

### Border Handling for Multi-Page

To prevent blank pages at the end of tables, borders are drawn using `Line()` instead of `Cell()` with border parameter:

```xojo
// Draw bottom border with Line (doesn't trigger page break)
pdf.Line(startX, currentY, startX + totalWidth, currentY)

// NOT: Cell(0, rowHeight, "", "T", 1)  // This can trigger unwanted page break
```

### Row Height Calculation

Row heights are calculated based on font size:

```xojo
Const kRowHeight As Double = 7.0  // Base row height in mm
Const kHeaderHeight As Double = 8.0  // Slightly taller headers
```

### Column Width Distribution

For SimpleTable, widths are calculated automatically:

```xojo
Dim tableWidth As Double = pdf.GetPageWidth() - pdf.GetLeftMargin() - pdf.GetRightMargin()
Dim colWidth As Double = tableWidth / headers.Count
```

---

## Database Integration

Tables work directly with Xojo database RowSets - no manual data conversion needed:

### SQLite Example

```xojo
// Create in-memory database
Dim db As New SQLiteDatabase
db.Connect()

// Create table and insert data
db.ExecuteSQL("CREATE TABLE employees (Name TEXT, Department TEXT, Salary REAL)")
db.ExecuteSQL("INSERT INTO employees VALUES ('John Smith', 'Engineering', 75000)")
db.ExecuteSQL("INSERT INTO employees VALUES ('Marie Dupont', 'Marketing', 68000)")
// ... more inserts

// Query data - column names become table headers automatically
Dim rs As RowSet = db.SelectSQL("SELECT Name, Department, Salary FROM employees ORDER BY Name")

// Generate table directly from RowSet
Dim widths() As Double = Array(60.0, 50.0, 40.0)
VNSPDFTablePremium.FancyTable(pdf, rs, widths, 7.0)
```

---

## Styling Examples

### Custom Styling

FancyTable uses blue headers and alternating gray rows by default. Header and row colors are customizable through the table module's styling options.

---

## Best Practices

1. **Column Widths** - Ensure widths sum fits within page margins
2. **Data Formatting** - Format numbers before adding to data array
3. **Long Text** - Text will be truncated to fit column width
4. **Page Margins** - Account for margins when calculating table width
5. **Header Repetition** - Enable for tables likely to span pages

---

## Manual Table API (v2.0)

Build tables manually without a database RowSet. Define columns, add header rows with colspan merging, add data rows as string arrays, and configure footers with manual text or automatic calculations.

### Additional Files

When using manual tables, add these files alongside the existing table module files:

- `VNSPDFManualTable.xojo_code` - Main builder class
- `VNSPDFManualTableColumn.xojo_code` - Column definition
- `VNSPDFManualTableHeaderCell.xojo_code` - Header cell with colspan
- `VNSPDFManualTableFooterCell.xojo_code` - Footer cell with auto-calc

### Quick Start

```xojo
// Create manual table
Dim table As New VNSPDFManualTable(6.0)

// Define columns with alignment
table.AddColumn("Product", 60.0, VNSPDFModule.eColumnAlignment.Left)
table.AddColumn("Qty", 25.0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Price", 30.0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Total", 35.0, VNSPDFModule.eColumnAlignment.Right)

// Add data rows
table.AddRow(Array("Software License", "3", "599.99", "1799.97"))
table.AddRow(Array("Support Contract", "1", "2500.00", "2500.00"))

// Footer with auto-sum on Total column
Dim footer() As VNSPDFManualTableFooterCell
footer.Add(New VNSPDFManualTableFooterCell("TOTAL", 3, VNSPDFModule.eColumnAlignment.Left))
footer.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 3, 1, ""))
table.SetFooterCells(footer)

// Render
table.Render(pdf)
```

### Merged Headers (Colspan)

```xojo
Dim table As New VNSPDFManualTable(6.0)
table.AddColumn("Region", 30.0)
table.AddColumn("Q1", 25.0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Q2", 25.0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Q3", 25.0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Q4", 25.0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Total", 30.0, VNSPDFModule.eColumnAlignment.Right)

// Group header with colspan=4 spanning Q1-Q4
Dim groupRow() As VNSPDFManualTableHeaderCell
groupRow.Add(New VNSPDFManualTableHeaderCell("", 1))
groupRow.Add(New VNSPDFManualTableHeaderCell("Quarterly Revenue", 4))
groupRow.Add(New VNSPDFManualTableHeaderCell("", 1))
table.AddHeaderRow(groupRow)

// Detail header row
Dim detailRow() As VNSPDFManualTableHeaderCell
detailRow.Add(New VNSPDFManualTableHeaderCell("Region", 1))
detailRow.Add(New VNSPDFManualTableHeaderCell("Q1", 1))
// ... etc
table.AddHeaderRow(detailRow)
```

### Pictures and Barcodes in Cells

```xojo
// QR code in data cell (row 0, column 2)
table.SetCellBarcode(0, 2, VNSPDFModule.eBarcodeType.QRCode, "https://example.com")

// Code128 barcode in data cell
table.SetCellBarcode(0, 3, VNSPDFModule.eBarcodeType.Code128, "ABC-12345")

// Picture in data cell
table.SetCellPicture(0, 1, myPicture, 1.0, 1.0)
```

Barcodes use premium VNSPDFBarcode (vector) when the E-Invoice module is available, otherwise fall back to Xojo's built-in Barcode class (raster) for QR and Code128 on Desktop/Web/iOS.

### VNSPDFManualTable Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| mCellHeight | Double | 6.0 | Height of data rows |
| mHeaderHeight | Double | 7.0 | Height of header rows |
| mRepeatHeaders | Boolean | True | Repeat headers on page breaks |
| mAlternateRowColors | Boolean | True | Alternate row background colors |
| mAlternateColor1 | Color | White | First alternating color |
| mAlternateColor2 | Color | Light gray | Second alternating color |
| mHeaderFillColor | Color | RGB(41,128,185) | Header background color |
| mHeaderTextColor | Color | RGB(255,255,255) | Header text color |
| mHeaderBorderColor | Color | RGB(52,73,94) | Header border/separator color |
| mBorderColor | Color | Black | Border color for data rows, footer, and bottom border |
| mBorderWidth | Double | 0.2 | Border line width in mm for all cell borders (headers, data, footer) |
| mBorderStyle | String | "1" | Default cell border style ("1"=all, "0"=none, "LTRB"=specific sides) |
| mDrawBottomBorder | Boolean | True | Draw bottom border line |
| mDecimalSeparator | String | System locale | Decimal separator for footer calculations |
| mThousandsSeparator | String | System locale | Thousands separator for footer calculations |
| mFooterDecimals | Integer | 2 | Number of decimal places for footer calculations |
| mSubtotalFillColor | Color | RGB(220,220,220) | Background color for subtotal rows |
| mSubtotalTextColor | Color | RGB(0,0,0) | Text color for subtotal rows |
| mSubtotalFontStyle | String | "B" | Font style for subtotal rows (e.g. "B" for bold) |
| mAutoRowHeight | Boolean | False | Auto-calculate row height from cell content (word-wrap instead of truncate) |
| mCellPadding | Double | -1 | Horizontal cell padding on both sides (-1 = use document default) |
| mRowPaddingTop | Double | 0 | Vertical padding above data row text |
| mRowPaddingBottom | Double | 0 | Vertical padding below data row text |
| mHeaderPaddingTop | Double | 1.0 | Vertical padding above header text (mm) |
| mHeaderPaddingBottom | Double | 1.0 | Vertical padding below header text (mm) |
| mHeaderVerticalAlignment | eVerticalAlignment | Top | Vertical alignment of header text: Top, Middle, Bottom |

### VNSPDFManualTable Methods

| Method | Description |
|--------|-------------|
| AddColumn(text, width, alignment) | Add a column definition (width=0 for auto-width) |
| AddColumn(col) | Add a VNSPDFManualTableColumn object |
| AddHeaderRow(cells()) | Add a header row with colspan support |
| AddRow(values()) | Add a data row as string array |
| AddSubtotalRow(values()) | Add a subtotal row (styled distinctly, excluded from footer calculations) |
| IsSubtotalRow(rowIdx) | Returns True if the row at the given index is a subtotal row |
| SetFooterCells(cells()) | Set footer cells |
| SetCellStyle(row, col, fontFamily, fontStyle, fontSize, textColor) | Per-cell font/color override (priority: cell > column > default) |
| SetCellBorder(row, col, borderString) | Per-cell border override ("1", "0", "LTRB"). Priority: cell > row > column > table |
| SetRowBorder(row, borderString) | Per-row border override. Priority: row > column > table |
| SetCellPadding(row, col, left, right, top, bottom) | Per-cell padding override. Values < 0 = use column/table default |
| SetCellPicture(row, col, pic, padX, padY) | Picture in data cell |
| SetCellBarcode(row, col, type, value, padX, padY) | Barcode in data cell |
| SetHeaderCellPicture(hdrRow, col, pic, padX, padY) | Picture in header cell |
| SetFooterCellPicture(col, pic, padX, padY) | Picture in footer cell |
| SetFooterCellBarcode(col, type, value, padX, padY) | Barcode in footer cell |
| Render(doc) | Render the table into the PDF |

### VNSPDFManualTableColumn Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| mHeaderText | String | "" | Column header text |
| mWidth | Double | 0.0 | Column width in user units (0 = auto-width) |
| mAlignment | eColumnAlignment | Left | Data cell alignment |
| mHeaderAlignment | Integer | -1 | Header horizontal alignment override (-1 = use mAlignment) |
| mHeaderVerticalAlignment | Integer | -1 | Header vertical alignment override (-1 = use table default). 0=Top, 1=Middle, 2=Bottom |
| mFontFamily | String | "" | Column font family override (empty = use table default) |
| mFontStyle | String | "" | Column font style override |
| mFontSize | Double | 0.0 | Column font size override (0 = use table default) |
| mTextColor | Color | Black | Column text color |
| mCellPaddingTop | Double | -1 | Per-column vertical top padding override (-1 = use table mRowPaddingTop) |
| mCellPaddingBottom | Double | -1 | Per-column vertical bottom padding override (-1 = use table mRowPaddingBottom) |
| mFillColor | Color | White | Column fill color |
| mUseFill | Boolean | False | Use column fill color |
| mHeaderFillColor | Color | - | Per-column header background color (requires mUseHeaderFillColor = True) |
| mUseHeaderFillColor | Boolean | False | Use per-column header fill color |
| mHeaderTextColor | Color | - | Per-column header text color (requires mUseHeaderTextColor = True) |
| mUseHeaderTextColor | Boolean | False | Use per-column header text color |
| mBorderStyle | String | "" | Per-column border override (empty = use table default, "1"=all, "0"=none, "LTRB") |

### Header Word Wrap & Vertical Alignment

Column headers automatically word-wrap when text exceeds the column width. The header row height auto-expands to fit the tallest header text, with font-based line spacing (1.2x leading).

```xojo
// Center all headers vertically
table.mHeaderVerticalAlignment = VNSPDFModule.eVerticalAlignment.Middle

// Override a specific column to bottom-align
col.mHeaderVerticalAlignment = CType(VNSPDFModule.eVerticalAlignment.Bottom, Integer)

// Adjust vertical padding
table.mHeaderPaddingTop = 2.0
table.mHeaderPaddingBottom = 2.0

// Customize header colors (table-level)
table.mHeaderFillColor = Color.RGB(0, 100, 0)     // Dark green
table.mHeaderTextColor = Color.RGB(255, 255, 200)  // Light yellow
table.mHeaderBorderColor = Color.RGB(0, 50, 0)     // Darker green

// Per-column header color override
col.mHeaderFillColor = Color.RGB(200, 0, 0)  // Red for this column
col.mUseHeaderFillColor = True
col.mHeaderTextColor = Color.RGB(255, 255, 255)
col.mUseHeaderTextColor = True
```

### Auto Column Width

Set column width to `0` to auto-fill remaining page width. Multiple auto-width columns share the space equally.

```xojo
// First column fixed at 30mm, other 3 share the remaining width
table.AddColumn("ID", 30.0, VNSPDFModule.eColumnAlignment.Left)
table.AddColumn("Name", 0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Source", 0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Rating", 0, VNSPDFModule.eColumnAlignment.Right)
```

### Auto Row Height

Set `mAutoRowHeight = True` to word-wrap cell content instead of truncating. Row height is calculated from the tallest cell.

```xojo
Dim table As New VNSPDFManualTable(6.0)
table.mAutoRowHeight = True
// mCellHeight becomes the line height within cells and minimum row height
```

### Header Alignment

By default, header cells use the same alignment as data cells (`mAlignment`). Override per-column with `mHeaderAlignment`:

```xojo
// Header and data both right-aligned (default behavior)
table.AddColumn("Amount", 40.0, VNSPDFModule.eColumnAlignment.Right)

// Header centered, data right-aligned
Dim col As New VNSPDFManualTableColumn("Amount", 40.0, VNSPDFModule.eColumnAlignment.Right)
col.mHeaderAlignment = Integer(VNSPDFModule.eColumnAlignment.Center)
table.AddColumn(col)
```

### Cell Padding

Set `mCellPadding` on the table for global padding, or per-column via `VNSPDFManualTableColumn.mCellPadding`. Padding insets text on **both sides** of each cell while keeping the cell background and border at full column width. Column padding overrides table padding.

```xojo
// Global: 2mm padding on all cells
table.mCellPadding = 2.0

// Per-column: 4mm padding on "Source" column only
Dim colSource As New VNSPDFManualTableColumn("Source", 0, VNSPDFModule.eColumnAlignment.Right)
colSource.mCellPadding = 4.0
table.AddColumn(colSource)
```

Priority: column `mCellPadding` > table `mCellPadding` > document default (~0.28mm).

### Row Vertical Padding

Control vertical spacing above/below data row text. Negative values tighten spacing.

```xojo
// Tighter row spacing (reduce 0.5mm from default)
table.mRowPaddingTop = -0.5
table.mRowPaddingBottom = -0.5

// Looser row spacing
table.mRowPaddingTop = 1.5
table.mRowPaddingBottom = 1.0

// Per-column vertical padding override
col.mCellPaddingTop = 2.0    // -1 = use table default
col.mCellPaddingBottom = 0.5
```

### Per-Cell Padding Override

Override padding on individual cells (highest priority in the cascade):

```xojo
// Make a specific cell tighter
table.SetCellPadding(rowIdx, colIdx, 1.0, 1.0, 0.0, 0.0)
// Parameters: row, col, left, right, top, bottom
// Values < 0 = use column/table default
```

Priority: per-cell `SetCellPadding` > column `mCellPadding`/`mCellPaddingTop`/`mCellPaddingBottom` > table `mCellPadding`/`mRowPaddingTop`/`mRowPaddingBottom` > document default.

### Border Customization

Control border appearance at four levels: table, column, row, and cell.

**Border color and width** (applies to all borders):

```xojo
// Fine black borders (default)
table.mBorderColor = Color.RGB(0, 0, 0)
table.mBorderWidth = 0.1  // Very fine (default 0.2mm)

// Header borders can use a different color
table.mHeaderBorderColor = Color.RGB(0, 0, 0)
```

**Border style** controls which sides are drawn. Use `"1"` for all four sides, `"0"` for none, or any combination of `L` (left), `T` (top), `R` (right), `B` (bottom):

```xojo
// Table-level default: all borders
table.mBorderStyle = "1"

// Column-level override: only left and right borders
Dim col As New VNSPDFManualTableColumn("Notes", 0, VNSPDFModule.eColumnAlignment.Left)
col.mBorderStyle = "LR"
table.AddColumn(col)

// Row-level override: no borders on row 5
table.SetRowBorder(5, "0")

// Cell-level override: only bottom border on specific cell
table.SetCellBorder(2, 3, "B")
```

**Priority**: cell > row > column > table. If a cell has a `SetCellBorder` override, it takes precedence over everything. If not, the row override is checked, then the column, then the table default.

### Automatic Footer Height Detection

When using `SetFooterFunc()` or `SetFooterFuncLpi()`, the page break trigger is automatically adjusted to leave room for the footer. The library dry-runs the footer callback once to measure its height (detecting the first `SetY()` call), then sets the bottom margin accordingly. No need to manually call `SetAutoPageBreak(True, margin)`.

```xojo
pdf.SetFooterFuncLpi(AddressOf AddFooter) // Auto-detects footer height
// No SetAutoPageBreak needed — the page break trigger adjusts automatically
```

### Footer Auto-Calculations

VNSPDFManualTableFooterCell supports two constructors:

```xojo
// Manual text
New VNSPDFManualTableFooterCell("TOTAL", colspan, alignment)

// Auto-calculation using eFooterCalcType enum
New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, columnIndex, colspan, formatTemplate, alignment)
```

The format template supports placeholders: `{value}`, `{sum}`, `{avg}`, `{min}`, `{max}`, `{count}`.

### Subtotals

Insert inline subtotal rows between groups of data. Subtotal rows are styled with a distinct background color and font, and are automatically excluded from footer auto-calculations to prevent double-counting.

```xojo
Dim table As New VNSPDFManualTable(6.0)
table.AddColumn("Region", 35.0, VNSPDFModule.eColumnAlignment.Left)
table.AddColumn("Product", 50.0, VNSPDFModule.eColumnAlignment.Left)
table.AddColumn("Qty", 25.0, VNSPDFModule.eColumnAlignment.Right)
table.AddColumn("Total", 35.0, VNSPDFModule.eColumnAlignment.Right)

// Data rows for East region
table.AddRow(Array("East", "Professional Services", "4", "1,199.96"))
table.AddRow(Array("East", "Software License", "3", "1,499.97"))
table.AddSubtotalRow(Array("", "Subtotal East", "7", "2,699.93"))

// Data rows for West region
table.AddRow(Array("West", "Cloud Subscription", "12", "2,388.00"))
table.AddRow(Array("West", "Premium Support", "4", "3,996.00"))
table.AddSubtotalRow(Array("", "Subtotal West", "16", "6,384.00"))

// Footer with auto-sum (subtotal rows are excluded automatically)
Dim footer() As VNSPDFManualTableFooterCell
footer.Add(New VNSPDFManualTableFooterCell("", 1, VNSPDFModule.eColumnAlignment.Left))
footer.Add(New VNSPDFManualTableFooterCell("GRAND TOTAL", 1, VNSPDFModule.eColumnAlignment.Left))
footer.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 2, 1, "", VNSPDFModule.eColumnAlignment.Right))
footer.Add(New VNSPDFManualTableFooterCell(VNSPDFModule.eFooterCalcType.Sum, 3, 1, "", VNSPDFModule.eColumnAlignment.Right))
table.SetFooterCells(footer)

// Optional: customize subtotal styling
table.mSubtotalFillColor = Color.RGB(220, 220, 220)  // light gray (default)
table.mSubtotalTextColor = Color.RGB(0, 0, 0)        // black (default)
table.mSubtotalFontStyle = "B"                        // bold (default)

table.Render(pdf)
```

### Per-Cell Style Overrides

Override font family, style, size, and text color on individual cells. Cell overrides take priority over column defaults. Empty string or zero values fall back to column/table defaults. Black text color (`Color.RGB(0,0,0)`) means "use default".

```xojo
Dim table As New VNSPDFManualTable(6.0)
table.AddColumn("Product", 50.0, VNSPDFModule.eColumnAlignment.Left)
table.AddColumn("Status", 30.0, VNSPDFModule.eColumnAlignment.Center)
table.AddColumn("Price", 30.0, VNSPDFModule.eColumnAlignment.Right)

table.AddRow(Array("Wireless Headphones", "SALE", "79.99"))
// Red bold "SALE" text
table.SetCellStyle(0, 1, "", "B", 0, Color.RGB(192, 0, 0))
// Red price for sale items
table.SetCellStyle(0, 2, "", "", 0, Color.RGB(192, 0, 0))

table.AddRow(Array("Ergonomic Keyboard", "In Stock", "149.00"))
// Green "In Stock" text
table.SetCellStyle(1, 1, "", "", 0, Color.RGB(0, 128, 0))

table.Render(pdf)
```

### eFooterCalcType Enum

Located in `VNSPDFModule`:

```xojo
VNSPDFModule.eFooterCalcType.None     // No calculation
VNSPDFModule.eFooterCalcType.Sum      // Sum of column values
VNSPDFModule.eFooterCalcType.Average  // Average of column values
VNSPDFModule.eFooterCalcType.Minimum  // Minimum value in column
VNSPDFModule.eFooterCalcType.Maximum  // Maximum value in column
VNSPDFModule.eFooterCalcType.Count    // Count of rows
```

### eColumnAlignment Enum

Located in `VNSPDFModule`:

```xojo
VNSPDFModule.eColumnAlignment.Left    // "L"
VNSPDFModule.eColumnAlignment.Center  // "C"
VNSPDFModule.eColumnAlignment.Right   // "R"
```

---

## Compatibility

| Platform | Status |
|----------|--------|
| Desktop | ✅ Working |
| Web | ✅ Working |
| iOS | ✅ Working |
| Console | ✅ Working |

---

*Last Updated: 2026-03-11*
