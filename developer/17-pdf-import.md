# 17. PDF Import

**Status:** ✅ Fully Implemented (v1.0.0)
**Module:** VNSPDFReader (Import/), VNSPDFDocument (Core/)
**Example:** Example 20

---

## Overview

VNS PDF includes a complete PDF parser that allows importing pages from existing PDF files and using them as XObject Form templates in new documents. This is equivalent to go-fpdf's gofpdi contrib package, but implemented as a pure Xojo solution with no external dependencies.

**Key Capabilities:**
- Import pages from multi-page PDF files
- Use imported pages as templates with scaling and positioning
- Automatic resource dependency tracking (fonts, images, XObjects)
- Support for nested XObjects (pages referencing other XObjects)
- Stream decompression (FlateDecode, LZWDecode, ASCII85Decode, ASCIIHexDecode)
- Premium Zlib module adds PNG Predictor support for modern PDFs

---

## Architecture

### Core Components

```
PDF_Library/Import/
├── VNSPDFReader.xojo_code           # Main PDF parser and page extractor
├── VNSPDFParser.xojo_code           # Object parsing and type system
├── VNSPDFTokenizer.xojo_code        # Lexical analysis of PDF syntax
├── VNSPDFStreamReader.xojo_code     # Binary stream handling with position tracking
├── VNSPDFStreamDecoder.xojo_code    # Stream decompression (FlateDecode/LZW)
├── VNSPDFLZWDecoder.xojo_code       # Pure Xojo LZW implementation
└── VNSPDFType (subclasses)          # 12 PDF type classes
    ├── VNSPDFNull.xojo_code
    ├── VNSPDFBoolean.xojo_code
    ├── VNSPDFNumeric.xojo_code
    ├── VNSPDFString.xojo_code
    ├── VNSPDFName.xojo_code
    ├── VNSPDFArray.xojo_code
    ├── VNSPDFDictionary.xojo_code
    ├── VNSPDFStream.xojo_code
    ├── VNSPDFReference.xojo_code
    ├── VNSPDFHexString.xojo_code
    ├── VNSPDFOperator.xojo_code
    └── VNSPDFReal.xojo_code
```

### Class Hierarchy

```
VNSPDFReader (Main entry point)
├── VNSPDFStreamReader (Binary I/O with position tracking)
├── VNSPDFTokenizer (Lexical analysis)
└── VNSPDFParser (Object parsing)
    └── VNSPDFType (Base class for all PDF types)
        ├── VNSPDFNull, VNSPDFBoolean, VNSPDFNumeric...
        ├── VNSPDFStream (with VNSPDFStreamDecoder)
        └── VNSPDFDictionary (with nested type support)
```

---

## Usage

### Basic Import

```xojo
// Create new document
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                              VNSPDFModule.ePageUnit.Millimeters, _
                              VNSPDFModule.ePageFormat.A4)

// Open source PDF
Dim sourcePDF As FolderItem = New FolderItem("/path/to/source.pdf", FolderItem.PathModes.Native)
Call pdf.SetSourceFile(sourcePDF)

// Import specific pages
Dim tpl1 As Integer = pdf.ImportPage(1)  // Import page 1
Dim tpl2 As Integer = pdf.ImportPage(2)  // Import page 2

// Use imported pages as templates
pdf.AddPage()
pdf.UseTemplate(tpl1, 0, 0, 210, 297)  // Full A4 page

pdf.AddPage()
pdf.UseTemplate(tpl2, 10, 10, 100, 0)  // 100mm width, auto height

// Save result
Dim output As FolderItem = SpecialFolder.Desktop.Child("output.pdf")
Call pdf.SaveToFile(output)
```

### Advanced Usage - Multiple Source Files

```xojo
Dim pdf As New VNSPDFDocument()

// Import from first PDF
Dim source1 As FolderItem = New FolderItem("/path/to/invoice.pdf", FolderItem.PathModes.Native)
Call pdf.SetSourceFile(source1)
Dim invoicePage As Integer = pdf.ImportPage(1)

// Import from second PDF
Dim source2 As FolderItem = New FolderItem("/path/to/logo.pdf", FolderItem.PathModes.Native)
Call pdf.SetSourceFile(source2)
Dim logoPage As Integer = pdf.ImportPage(1)

// Combine templates on new page
pdf.AddPage()
pdf.UseTemplate(invoicePage, 0, 0, 210, 297)  // Background
pdf.UseTemplate(logoPage, 150, 10, 40, 20)    // Logo overlay
```

### Platform-Specific File Selection

**Desktop:**
```xojo
// Multi-location search
Dim sourcePath As String = FindPDFInProjectFolder()
If sourcePath = "" Then
  // Fall back to file picker
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
  // Show instructions for File Sharing
  MessageBox("Place PDF file in Documents folder via iTunes File Sharing")
End If
```

**Web:**
```xojo
// File upload dialog
Dim dialog As New WebDialogPDFUpload
If dialog.ShowModal() = dialog.OKButton Then
  Dim uploadedFile As WebFile = dialog.UploadedFile
  Dim sourcePath As String = uploadedFile.Path
End If
```

**Console:**
```xojo
// Default path or error
Dim sourcePath As String = FindPDFInProjectFolder()
If sourcePath = "" Then
  Print("Error: Source PDF not found")
End If
```

---

## Technical Details

### PDF Parsing Process

1. **Cross-Reference Table (xref) Parsing**
   - Locates xref table at end of PDF file
   - Builds map of object IDs to byte offsets
   - Supports both traditional xref and compressed xref streams

2. **Document Catalog Resolution**
   - Reads trailer dictionary to find /Root (catalog)
   - Resolves catalog object to get document structure

3. **Page Tree Traversal**
   - Navigates hierarchical page tree (/Pages nodes)
   - Handles MediaBox inheritance from parent nodes
   - Builds flat list of all pages with correct dimensions

4. **Page Content Extraction**
   - Extracts /Contents stream(s) for requested page
   - Decompresses streams using appropriate filters
   - Handles multiple content streams (array of streams)

5. **Resource Dependency Tracking**
   - Identifies all resources referenced by page (/Resources dictionary)
   - Recursively copies fonts, images, XObjects
   - Resolves indirect references to ensure complete resource set

6. **XObject Form Creation**
   - Wraps page content in XObject Form structure
   - Sets /BBox (bounding box) from page MediaBox
   - Includes /Resources dictionary with all dependencies
   - Assigns unique object ID in target document

### Stream Decompression Support

| Filter | Implementation | Platforms | Notes |
|--------|---------------|-----------|-------|
| **FlateDecode (basic)** | System zlib via Declares | Desktop, Web, Console | Simple deflate without predictors |
| **FlateDecode + Predictors** | VNSZlibPremium (Pure Xojo) | ALL platforms (Premium) | PNG Predictors 2, 10-15 |
| **LZWDecode** | VNSPDFLZWDecoder (Pure Xojo) | ALL platforms | Legacy PDFs |
| **ASCII85Decode** | Base-85 decoder | ALL platforms | Text-based encoding |
| **ASCIIHexDecode** | Hexadecimal decoder | ALL platforms | Simple hex decoding |
| **DCTDecode** | Pass-through | ALL platforms | JPEG images (no decompression needed) |

**Why Premium Zlib is Often Required:**
- Most modern PDFs use **FlateDecode with PNG Predictors** (Predictor 15) for efficient compression
- Used for: Images, large content streams, embedded fonts, ICC profiles
- FREE version: Basic FlateDecode only (simple deflate without predictor transformations)
- **Premium zlib module**: Full PNG Predictor support with reversal algorithms

Real-world example from PDF:
```
/Filter /FlateDecode
/DecodeParms << /Predictor 15 /Colors 3 /Columns 1859 >>
```

Without premium zlib: Can parse PDF structure but **cannot decompress predictor-encoded streams**

### Object ID Remapping

When importing pages, all object IDs must be remapped to avoid conflicts with the target document's existing objects:

```xojo
// Original source PDF
1 0 obj <</Type /Catalog>>
2 0 obj <</Type /Pages>>
3 0 obj <</Type /Page>>

// Target document already has objects 1-50
// Imported objects are remapped: 3 → 51, references updated
51 0 obj <</Type /Page>>  // Was 3 0 obj in source
```

**Implementation:**
- `mImportedObjectMap As Dictionary` tracks `sourceObjID → targetObjID`
- All indirect references are updated during serialization
- Object placeholder system resolves forward references

### Nested XObject Support

Imported pages may reference other XObjects (forms, images):

```
Page content stream:
  /XObj1 Do    ← References another XObject

Resources dictionary:
  /XObject << /XObj1 4 0 R >>  ← Points to object 4
```

**Solution:** Recursive resource copying ensures all dependencies are included.

### Leading Newline Handling

**Critical Fix (Commit 3cfb04f):**

PDF streams can have a newline immediately after the `stream` keyword:
```
stream\n
<binary data>
endstream
```

This newline is NOT part of the stream data and must be skipped, otherwise:
- FlateDecode/zlib fails with "invalid header" error
- Stream decompression returns empty data
- Pages appear blank or corrupted

**Implementation:**
```xojo
// VNSPDFParser - Skip optional newline after 'stream' keyword
If reader.PeekByte() = 10 Then  // \n
  Call reader.ReadByte()  // Skip it
ElseIf reader.PeekByte() = 13 Then  // \r
  Call reader.ReadByte()  // Skip it
  If reader.PeekByte() = 10 Then  // \r\n
    Call reader.ReadByte()  // Skip second byte
  End If
End If

// Now read actual stream data
Dim streamData As String = reader.ReadBytes(length)
```

---

## API Reference

### VNSPDFDocument Methods

#### SetSourceFile()
```xojo
Function SetSourceFile(pdfFile As FolderItem) As Boolean
```
Opens a PDF file for importing. Must be called before ImportPage().

**Parameters:**
- `pdfFile`: FolderItem pointing to source PDF file

**Returns:** True if successful, False on error (check with GetError())

**Example:**
```xojo
Dim source As FolderItem = New FolderItem("/path/to/source.pdf", FolderItem.PathModes.Native)
If Not pdf.SetSourceFile(source) Then
  MessageBox("Error: " + pdf.GetError())
End If
```

---

#### ImportPage()
```xojo
Function ImportPage(pageNum As Integer) As Integer
```
Imports a page from the source PDF as an XObject Form template.

**Parameters:**
- `pageNum`: Page number to import (1-based index)

**Returns:** Template ID for use with UseTemplate(), or 0 on error

**Implementation:**
1. Validates page number is within range
2. Extracts page content stream(s) and decompresses
3. Extracts page resources (fonts, images, XObjects)
4. Creates XObject Form dictionary with /BBox and /Resources
5. Assigns unique object ID and stores in mImportedTemplates
6. Returns template ID

**Example:**
```xojo
Dim tplID As Integer = pdf.ImportPage(1)
If tplID = 0 Then
  MessageBox("Import failed: " + pdf.GetError())
End If
```

---

#### UseTemplate()
```xojo
Sub UseTemplate(templateID As Integer, x As Double = 0, y As Double = 0, _
                w As Double = 0, h As Double = 0)
```
Places an imported template on the current page.

**Parameters:**
- `templateID`: Template ID returned by ImportPage()
- `x`, `y`: Position in user units (default: 0, 0)
- `w`, `h`: Size in user units (0 = auto-scale, default: full page)

**Scaling Behavior:**
- If `w = 0` and `h = 0`: Use original page size
- If `w > 0` and `h = 0`: Scale to width, maintain aspect ratio
- If `w = 0` and `h > 0`: Scale to height, maintain aspect ratio
- If `w > 0` and `h > 0`: Scale to exact dimensions (may distort)

**PDF Commands Generated:**
```
q                           // Save graphics state
scaleX 0 0 scaleY x y cm   // Transform matrix (scale + translate)
/XObjN Do                   // Draw XObject
Q                           // Restore graphics state
```

**Example:**
```xojo
// Full page background
pdf.UseTemplate(tplID, 0, 0, 210, 297)

// Thumbnail (100mm width, auto height)
pdf.UseTemplate(tplID, 10, 10, 100, 0)

// Original size at custom position
pdf.UseTemplate(tplID, 50, 50, 0, 0)
```

---

### VNSPDFReader Class

#### Constructor
```xojo
Sub Constructor()
```
Creates a new PDF reader instance. Call OpenFile() to load a PDF.

---

#### OpenFile()
```xojo
Function OpenFile(pdfFile As FolderItem) As Boolean
```
Opens and parses a PDF file.

**Process:**
1. Reads entire file into MemoryBlock
2. Locates and parses xref table
3. Reads trailer to find document catalog
4. Traverses page tree to build page list
5. Stores page information for later extraction

**Returns:** True if successful, False on error

---

#### GetPageCount()
```xojo
Function GetPageCount() As Integer
```
Returns the number of pages in the opened PDF.

**Returns:** Page count, or 0 if no PDF is loaded

---

#### GetPage()
```xojo
Function GetPage(pageNum As Integer) As VNSPDFImportedPage
```
Extracts a specific page with all its resources.

**Parameters:**
- `pageNum`: Page number (1-based)

**Returns:** VNSPDFImportedPage object with content and resources, or Nil on error

**VNSPDFImportedPage Properties:**
- `PageNumber As Integer` - Original page number
- `MediaBox As Dictionary` - Page dimensions (X, Y, Width, Height)
- `Contents As String` - Decompressed page content stream
- `Resources As VNSPDFDictionary` - Fonts, images, XObjects
- `XObjectForm As Dictionary` - XObject Form structure for embedding

---

## Performance Considerations

### Memory Usage

**Large PDFs:**
- Entire source PDF is loaded into memory (MemoryBlock)
- Each imported page stores decompressed content stream
- Resource dictionaries are duplicated for each imported page

**Optimization Strategies:**
1. Import only needed pages (don't import all pages if you only use a few)
2. Close source PDF after importing (clear mPDFReader reference)
3. Share resources between pages when possible (future enhancement)

### Parsing Performance

**Typical Performance:**
- Small PDF (1-5 pages, <1MB): <100ms parsing time
- Medium PDF (10-50 pages, 1-5MB): 200-500ms
- Large PDF (100+ pages, >10MB): 1-2 seconds

**Bottlenecks:**
1. File I/O (loading entire PDF into memory)
2. Stream decompression (especially PNG Predictors)
3. Page tree traversal for large documents

**Optimization Tips:**
- Use Premium Zlib module for faster decompression
- Cache imported templates if reusing same source PDF
- Consider background thread for large imports (future)

---

## Platform Considerations

### iOS Limitations

**String Operations:**
- iOS uses 0-based indexing (`String.Middle(0, 1)` for first character)
- Use conditional compilation for string operations

**File Access:**
- No `ShowOpenFileDialog` - use Documents folder enumeration
- Requires File Sharing enabled in project settings
- Users place PDFs via macOS Finder or iTunes

**Memory Constraints:**
- Avoid `MemoryBlock.StringValue()` on large buffers (>20MB)
- Use byte-by-byte extraction instead: `UInt8Value()`, `UInt16Value()`

### Web Platform

**File Upload Required:**
- No local file system access
- Must use WebDialog with file upload control
- Temporary file path valid only during request

**Stream Decompression:**
- FlateDecode works via system zlib Declares
- Premium Zlib module provides pure Xojo alternative

### Console Platform

**No Interactive File Picker:**
- Must specify source PDF path programmatically
- Use default path search or command-line argument

---

## Limitations

### What's NOT Supported

1. **Programmatic Templates** (go-fpdf's CreateTemplate with callback)
   - Can only import from existing PDFs, not create templates from drawing commands
   - Workaround: Generate temporary PDF and import it

2. **Form Field Preservation**
   - Interactive form fields are lost when importing (converted to static content)
   - Annotations and comments are not preserved

3. **Encrypted PDFs**
   - Cannot import from password-protected PDFs
   - Must decrypt PDF first using external tool

4. **Incremental Updates**
   - Only supports single-revision PDFs
   - Incremental updates (appended changes) may not be fully parsed

5. **Compressed Object Streams**
   - Object streams (/ObjStm) not yet supported
   - Most PDFs don't use this feature (PDF 1.5+)

6. **Exotic Filters**
   - JPXDecode (JPEG2000), JBIG2Decode not supported
   - Rare in typical PDFs

### Known Issues

1. **Large File Memory Usage**
   - Entire PDF loaded into memory
   - May cause issues with multi-GB PDFs

2. **Complex Page Trees**
   - Very deep page tree hierarchies (>10 levels) may be slow
   - Rare in practice

3. **Damaged PDFs**
   - Strict parser may fail on malformed PDFs
   - Some PDF readers are more forgiving

---

## Testing

### Unit Tests

**Test Coverage:**
- ✅ VNSPDFTokenizer: Token extraction (names, numbers, strings, arrays, dicts)
- ✅ VNSPDFParser: Object parsing and type system
- ✅ VNSPDFStreamDecoder: FlateDecode, LZWDecode, ASCII85Decode
- ✅ VNSPDFReader: Page extraction and resource tracking
- ⚠️ Integration tests: Manual testing via Example 20

**Test PDFs:**
- `pdf_examples/example12_custom_formats.pdf` - Multi-page with custom formats
- `pdf_examples/example19_tables.pdf` - Large PDF with tables (99 rows)

### Manual Testing Checklist

- [ ] Import single page from 1-page PDF
- [ ] Import multiple pages from multi-page PDF
- [ ] Import with nested XObjects (page referencing another XObject)
- [ ] Import with FlateDecode streams (basic)
- [ ] Import with FlateDecode+Predictors (Premium Zlib required)
- [ ] Import with LZWDecode streams (legacy PDFs)
- [ ] Import and scale to different sizes
- [ ] Import from multiple source PDFs in same document
- [ ] Import on all 4 platforms (Desktop, Web, iOS, Console)

---

## Future Enhancements

### Planned Features

1. **Encrypted PDF Support**
   - Decrypt password-protected PDFs before importing
   - Support standard PDF encryption (RC4, AES)

2. **Form Field Extraction**
   - Preserve interactive form fields when importing
   - Convert fields to editable state in target document

3. **Annotation Preservation**
   - Copy comments, highlights, and annotations
   - Maintain annotation positions and properties

4. **Compressed Object Streams**
   - Support PDF 1.5+ compressed object streams (/ObjStm)
   - Reduce memory usage for large PDFs

5. **Incremental Update Support**
   - Parse PDFs with multiple revisions
   - Extract latest version of modified objects

6. **Programmatic Templates** (go-fpdf compatibility)
   - CreateTemplate() with callback function
   - Record drawing commands into reusable template
   - Use case: Complex headers/footers drawn programmatically

---

## Troubleshooting

### Common Errors

#### "Cannot open PDF file"
**Cause:** File not found or invalid path
**Solution:** Verify FolderItem.Exists before calling SetSourceFile()

#### "Invalid PDF header"
**Cause:** File is not a PDF or is corrupted
**Solution:** Check file starts with `%PDF-1.` using text editor

#### "Page N not found"
**Cause:** Requested page number exceeds page count
**Solution:** Call GetPageCount() first, validate page number

#### "Stream decompression failed"
**Cause:** Unsupported filter or corrupted stream data
**Solution:** Check error message for filter name, may need Premium Zlib

#### "Template ID not found"
**Cause:** Calling UseTemplate() with invalid template ID
**Solution:** Check ImportPage() returned non-zero value

#### "Blank page after import"
**Cause:** Stream decompression silently failed (predictor required)
**Solution:** Enable Premium Zlib module for PNG Predictor support

### Debug Logging

Enable debug output with conditional compilation:

```xojo
#If DebugBuild Then
  System.DebugLog("VNSPDFReader: Parsing page " + Str(pageNum))
  System.DebugLog("  MediaBox: " + Str(width) + " x " + Str(height))
  System.DebugLog("  Content length: " + Str(content.Bytes) + " bytes")
#EndIf
```

---

## Example: Complete Workflow

```xojo
// Example 20: PDF Import Demonstration
Function GenerateExample20(sourcePath As String) As Dictionary
  Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                                VNSPDFModule.ePageUnit.Millimeters, _
                                VNSPDFModule.ePageFormat.A4)

  // Open source PDF
  Dim sourceFile As FolderItem = New FolderItem(sourcePath, FolderItem.PathModes.Native)
  If Not pdf.SetSourceFile(sourceFile) Then
    Return ErrorResult("Failed to open source PDF: " + pdf.GetError())
  End If

  // Get page count
  Dim pageCount As Integer = pdf.GetPageCount()
  If pageCount = 0 Then
    Return ErrorResult("No pages found in source PDF")
  End If

  // Import all pages
  Dim templates() As Integer
  For i As Integer = 1 To pageCount
    Dim tplID As Integer = pdf.ImportPage(i)
    If tplID = 0 Then
      Return ErrorResult("Failed to import page " + Str(i) + ": " + pdf.GetError())
    End If
    templates.Add(tplID)
  Next

  // Create overview pages with 2x2 grid of thumbnails
  Dim thumbnailsPerPage As Integer = 4
  Dim numOverviewPages As Integer = Ceiling(pageCount / thumbnailsPerPage)

  For pageIdx As Integer = 0 To numOverviewPages - 1
    pdf.AddPage()

    // Draw 2x2 grid
    Dim startIdx As Integer = pageIdx * thumbnailsPerPage
    Dim endIdx As Integer = Min(startIdx + thumbnailsPerPage - 1, pageCount - 1)

    For gridIdx As Integer = 0 To Min(3, endIdx - startIdx)
      Dim tplIdx As Integer = startIdx + gridIdx
      Dim row As Integer = Floor(gridIdx / 2)
      Dim col As Integer = gridIdx Mod 2

      // Position: (col * 105 + 5, row * 148.5 + 5)
      // Size: 100mm x 141mm (A4 proportions)
      Dim x As Double = col * 105 + 5
      Dim y As Double = row * 148.5 + 5

      pdf.UseTemplate(templates(tplIdx), x, y, 100, 0)  // Auto height

      // Draw border and label
      pdf.SetDrawColor(200, 200, 200)
      pdf.Rect(x, y, 100, 141, VNSPDFModule.eDrawStyle.Draw)
      pdf.SetFont("Helvetica", "", 8)
      pdf.Text(x + 2, y + 2, "Page " + Str(tplIdx + 1))
    Next
  Next

  // Generate PDF
  Dim pdfBytes As String = pdf.Output()
  If Not pdf.Ok() Then
    Return ErrorResult("PDF generation failed: " + pdf.GetError())
  End If

  // Return success
  Dim result As New Dictionary
  result.Value("success") = True
  result.Value("pdf") = pdfBytes
  result.Value("filename") = "example20_pdf_import.pdf"
  result.Value("status") = "✓ Imported " + Str(pageCount) + " pages" + EndOfLine + _
                           "✓ Created " + Str(numOverviewPages) + " thumbnail overview pages"
  Return result
End Function
```

---

## See Also

- **Example 20**: Complete PDF Import demonstration with thumbnail grid
- **VNSPDFReader API**: Full API reference in 03-core-classes.md
- **Premium Zlib Module**: PNG Predictor support in 16-premium-modules.md
- **Platform-Specific Code**: File selection patterns in 08-platform-specific-code.md

---

*Last Updated: December 2025*
*VNS PDF v1.0.0*
