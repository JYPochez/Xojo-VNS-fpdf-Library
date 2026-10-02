# Future Enhancements

## Implemented Features

✅ **Font Subsetting** - TrueType font optimization with sparse glyph IDs (v0.3.0)
✅ **Bezier Curves** - Quadratic and cubic Bezier curves (v0.7.0)
✅ **Polygon Drawing** - Arbitrary shapes with Point arrays (v0.7.0)
✅ **Arrow Lines** - Lines with arrowheads (v0.7.0)
✅ **PDF Import** - Import pages from existing PDFs as XObject templates (v1.0.0)
✅ **Arabic Text Shaping** - Automatic contextual forms for Arabic script (v1.0.0)
✅ **Premium Tables** - SimpleTable, ImprovedTable, FancyTable (v0.8.0)
✅ **Pure Xojo Zlib** - iOS compression support (v0.8.0)
✅ **AES Encryption** - AES-128/256 with pure Xojo implementation (v0.8.0)

### Font Subsetting Details

**Status**: ✅ **FULLY WORKING** (Implemented v0.3.0)

```xojo
// Font subsetting is automatic for TrueType fonts
pdf.AddUTF8Font("Arial", "", "/path/to/Arial.ttf")
pdf.SetFont("Arial", "", 12)
pdf.Cell(0, 10, "Only these glyphs are embedded: Hello World!")
```

**Implementation**:
- ✅ **VNSPDFTrueTypeFontSubsetter** class
- ✅ **SetFontSubsetting()** / **GetFontSubsetting()** methods
- ✅ **Sparse glyph ID subsetting** - Keeps original glyph IDs, no remapping
- ✅ **98% size reduction** - 23MB Arial Unicode font → ~500KB embedded subset
- ✅ Automatically enabled for all TrueType fonts

**How it Works**:
1. Tracks all glyphs used in document
2. Extracts only used glyphs from font file
3. Rebuilds TrueType tables (cmap, glyf, hmtx, loca, maxp, head, hhea, post)
4. Maintains original glyph IDs (no CID remapping needed)
5. Embeds subset font with Identity-H encoding

**Benefits**:
- Significantly smaller PDF files with TrueType fonts
- Faster PDF loading and rendering
- Maintains full Unicode support
- Works with fonts containing 50,000+ glyphs

---

## In Development

### Color Emoji Support (Full Implementation)
```xojo
// Support for color emoji fonts
// SBIX (Apple), COLR/CPAL (Microsoft), SVG-in-OpenType
pdf.AddEmojiFont("NotoColorEmoji.ttf")
pdf.Cell(40, 10, "Hello 👋 World 🌍", 0, 1, "L")
```

**Formats**:
- SBIX - Apple's bitmap emoji format
- COLR/CPAL - Microsoft's vector emoji format
- SVG-in-OpenType - SVG-based emoji

**Current Status**: Partial - Desktop and iOS working via platform graphics APIs, Web requires font file parsing

**Status**: 🔨 Estimated 15-21 hours for full SBIX/COLR/CPAL/CBDT/CBLC support

## Premium Modules - All Implemented ✅

### VNSPDFEncryptionPremium - AES Encryption
**Status**: ✅ **FULLY WORKING** (Implemented v0.8.0)
**Module Flag**: `hasPremiumVNSEncryptionModule`

```xojo
// AES-128 encryption
pdf.SetProtection("user", "owner", True, True, True, True, _
                  VNSPDFModule.gkEncryptionAES128)

// AES-256 encryption
pdf.SetProtection("user", "owner", True, True, True, True, _
                  VNSPDFModule.gkEncryptionAES256)
```

**Implemented**:
- ✅ Pure Xojo AES-128/256 using Rijndael algorithm (VNSAESCore)
- ✅ AES-CBC mode with proper IV generation
- ✅ AES-ECB mode for password entries
- ✅ All revisions working (RC4-40, RC4-128, AES-128, AES-256)
- ✅ Tested against Adobe Acrobat, Preview, Chrome

See [Chapter 16: Premium Modules](16-premium-modules.md) for details.

### VNSPDFZlibPremium - iOS Compression
**Status**: ✅ **FULLY WORKING** (Implemented v0.8.0)
**Module Flag**: `hasPremiumVNSZlibModule`

```xojo
// Enable compression on iOS
#If TargetiOS Then
    If hasPremiumVNSZlibModule Then
        pdf.SetCompression(True)  // Uses pure Xojo zlib
    Else
        // iOS compression blocked in FREE version
    End If
#EndIf
```

**Implemented**:
- ✅ Core DEFLATE algorithm (VNSZlibPremiumDeflate)
  - LZ77 sliding window compression with hash chains
  - Huffman tree generation (static and dynamic)
  - Bitstream encoding with RFC 1951 compliance
  - Adler-32 checksum
- ✅ Full inflate/deflate round-trip verified
- ✅ PNG Predictor reversal (Predictors 2, 10-15) for PDF Import
- ✅ Works on ALL platforms including iOS

See [Chapter 16: Premium Modules](16-premium-modules.md) for details.

### VNSPDFTablePremium - High-Level Table API
**Status**: ✅ **FULLY WORKING** (Implemented v0.8.0)
**Module Flag**: `hasPremiumVNSTableModule`

```xojo
// High-level declarative table API
If hasPremiumVNSTableModule Then
    // SimpleTable - Basic table with equal-width columns
    VNSPDFTablePremium.SimpleTable(pdf, headers, data, width)

    // ImprovedTable - Custom column widths and auto number alignment
    VNSPDFTablePremium.ImprovedTable(pdf, headers, data, widths)

    // FancyTable - Professional styling with colors and pagination
    VNSPDFTablePremium.FancyTable(pdf, headers, data, widths, repeatHeaders)
End If
```

**Implemented**:
- ✅ Three table styles (SimpleTable, ImprovedTable, FancyTable)
- ✅ SQLite in-memory databases with RowSet for data handling
- ✅ Automatic column sizing and text alignment
- ✅ Header row styling with custom colors
- ✅ Alternating row colors (FancyTable)
- ✅ Page break handling with header repetition
- ✅ Footer support with grand/intermediate totals
- ✅ Column calculations (SUM, AVG, COUNT, MIN, MAX)
- ✅ Multi-page tables (tested with 99-row tables)

See [Chapter 16: Premium Modules](16-premium-modules.md) and Example 19 for details.

## Planned Features (FREE Version)

### ~~Document Protection/Encryption~~ ✅ **FULLY IMPLEMENTED**

**Status**:
- ✅ **RC4-40 (Revision 2)** - FREE version (40-bit, deprecated)
- ✅ **RC4-128 (Revision 3)** - Premium Encryption module
- ✅ **AES-128 (Revision 4)** - Premium Encryption module (pure Xojo AES)
- ✅ **AES-256 (Revisions 5-6)** - Premium Encryption module (pure Xojo AES)
- ✅ User and owner passwords
- ✅ Granular permissions (print, copy, modify, annotate)
- ✅ Object-level encryption
- ✅ PDF version auto-upgrade

All encryption revisions are production-ready. AES implemented via pure Xojo Rijndael algorithm (VNSAESCore), bypassing Xojo Crypto API limitations.

### Import of Encrypted PDFs (planned after 1.4)

**Status**: 📋 Planned. Since 1.4, importing an encrypted PDF stops with a clear error
("Encrypted PDF: importing encrypted PDF files is not supported yet…") instead of a zlib error.

Many older PDFs are encrypted only to set permissions, with an **empty user password**
(e.g. Acrobat Distiller 3.0, RC4 40-bit), so viewers open them silently. Import will
decrypt them the same way: empty user password first, then an optional password.

**Free / Premium split** (mirrors writing: RC4 free, AES premium):

| Source encryption | Code needed | Version |
|---|---|---|
| RC4 40-bit (R2), RC4 128-bit (R3, R4 `/V2`) | RC4 + MD5 key derivation, already in core `VNSPDFEncryption` | **Free** |
| AES-128 (R4 `/AESV2`) | `VNSAESCore.DecryptCBC` | **Premium** (Encryption module) |
| AES-256 (R5, R6) | AES + `SHA256`/`SHA384`/`SHA512`, `ComputeHashR6` | **Premium** (Encryption module) |

A free user opening an AES-encrypted source gets "AES-encrypted PDF: import requires the
premium Encryption module". Public-key encryption (`/Filter /Adobe.PubSec`) stays unsupported
(clear error).

**Work items:**
- **D1** `VNSPDFReader`: read `/Encrypt` (`/V`, `/R`, `/Length`, `/O`, `/U`, `/P`, `/CF`
  `/StmF` `/StrF`, `/OE` `/UE` `/Perms`, `/EncryptMetadata`) and the first `/ID`.
- **D2** New `VNSPDFDecryptor`: authenticate the user password and derive the file key
  (R2–R4: Algorithms 2, 6, 7 of ISO 32000; R5–R6: Algorithm 2.A).
- **D3** `VNSPDFStream.GetDecodedData`: decrypt each stream **before** its filters, with the
  object number/generation (container stream number for objects inside object streams);
  skip the xref stream, and metadata when `/EncryptMetadata false`.
- **D4** `VNSPDFString` / `VNSPDFHexString`: decrypt strings (annotations, form fields,
  metadata); never the strings of the `/Encrypt` dictionary itself.
- **D5** API: `SetSourceFile(path, password = "")` and password overloads of the import
  constructors; clear errors for wrong password / unsupported revision / AES without premium.
- **D6** Tests: RC4-40 (`5525.pdf` datasheet, Acrobat Distiller 3.0), RC4-128 and AES-128
  files produced by the library itself, AES-256 R5/R6 (premium); unencrypted import must
  stay unchanged on Desktop, Web, iOS, Console and Android.

## Lower Priority Features

### JSON-PDF Conversion
**Status**: 📋 **Planned** (Estimated: 40-50 hours)

```xojo
// Convert PDF to JSON representation
Dim jsonData As String = pdf.ToJSON(prettyPrint := True)

// Reconstruct PDF from JSON
Dim pdf2 As New VNSPDFDocument()
Call pdf2.FromJSON(jsonData)
Call pdf2.Output()  // Generates identical PDF
```

**Implementation Plan**:
- Phase 1: Page Content Serialization (15-20 hours)
  - Serialize all page content streams (text, graphics, images)
  - Encode binary data (images, fonts) as Base64
  - Preserve exact positioning and styling
  - Handle special characters and encodings
- Phase 2: Resource Serialization (10-12 hours)
  - Fonts (TrueType, core fonts)
  - Images (JPEG, PNG with color spaces)
  - Links and bookmarks
  - Form fields and annotations
- Phase 3: Deserialization (10-12 hours)
  - Parse JSON and reconstruct PDF objects
  - Decode Base64 data
  - Rebuild page streams
  - Restore all resources
- Phase 4: Validation & Testing (5-6 hours)
  - Round-trip testing (PDF → JSON → PDF)
  - Binary comparison of original vs reconstructed
  - Edge cases and error handling

**Use Cases**:
- PDF archiving and versioning
- PDF transformation pipelines
- Web-based PDF editing
- PDF debugging and inspection
- Cross-platform PDF exchange

**Current Status**:
- ✅ Basic document configuration serialization (ToJSON/FromJSON for metadata only)
- ❌ Full page content serialization not implemented

### Advanced Text Features
- Text rotation at arbitrary angles
- Vertical text (top-to-bottom)
- Text paths (text following curves)
- Advanced kerning controls

### Graphics Enhancements
- ~~Gradient fills (linear, radial)~~ ✅ **IMPLEMENTED**
- Pattern fills
- ~~Clipping paths~~ ✅ **IMPLEMENTED**
- Image masks

### Document Features
- ~~Annotations~~ ✅ **IMPLEMENTED** - AddAnnotation, AddTextAnnotation
- ~~Attachments~~ ✅ **IMPLEMENTED** - AddAttachment, AddAttachmentAnnotation (E-Invoice/Factur-X ready)
- ~~Form fields~~ ✅ **IMPLEMENTED** (Premium Forms module - coming soon)
- Digital signatures

### Performance Optimizations
- Streaming output for very large PDFs
- Incremental PDF generation
- Memory-mapped file handling
- Multi-threaded rendering
