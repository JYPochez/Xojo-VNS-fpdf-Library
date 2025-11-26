# Future Enhancements

## In Development

### Font Subsetting for TrueType Fonts
```xojo
// Reduce PDF file size by embedding only used glyphs
// instead of entire font file
pdf.AddUTF8Font("arial", "", "Arial.ttf", True)  // subsetting enabled
```

**Benefits**:
- Significantly smaller PDF files with TrueType fonts
- Only glyphs actually used are embedded
- Maintains full Unicode support

### Color Emoji Support
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

### Bezier Curves and Polygons
```xojo
// Cubic Bezier curves
pdf.CurveTo(x1, y1, x2, y2, x3, y3, x4, y4)

// Polygons with arbitrary points
Dim points() As Pair
points.Append(New Pair(10, 10))
points.Append(New Pair(50, 20))
points.Append(New Pair(40, 60))
pdf.Polygon(points, "DF")
```

**Use Cases**:
- Complex vector graphics
- Custom shapes and paths
- Smooth curves for illustrations

## Premium Module Roadmap

### VNSPDFEncryptionPremium - AES Encryption
**Status**: 🔨 **Stubs Ready** (Estimated: 12-14 hours)
**Module Flag**: `kHasEncryptionModule`

```xojo
// AES-128 encryption (when implemented)
pdf.SetProtection("user", "owner", True, True, True, True, _
                  VNSPDFModule.gkEncryptionAES128)

// AES-256 encryption (when implemented)
pdf.SetProtection("user", "owner", True, True, True, True, _
                  VNSPDFModule.gkEncryptionAES256)
```

**Required Work**:
- Implement pure Xojo AES-128/256 using Rijndael algorithm
- Implement AES-CBC mode with proper IV generation
- Implement AES-ECB mode for password entries
- Test against PDF reader compatibility

**Blockers**:
- Xojo Crypto.AES uses PKCS7 padding for encryption but not decryption
- PDF spec requires consistent padding on both operations
- Solution: Pure Xojo implementation without Crypto module

See [Chapter 16: Premium Modules](16-premium-modules.md#aes-encryption-stubs) for details.

### VNSPDFZlibPremium - iOS Compression
**Status**: 🔨 **Planned** (Estimated: 33-42 hours)
**Module Flag**: `kHasZlibModule`

```xojo
// Enable compression on iOS (when implemented)
#If TargetiOS Then
    If VNSPDFModule.kHasZlibModule Then
        pdf.SetCompression(True)  // Uses pure Xojo zlib
    Else
        // iOS compression blocked in FREE version
    End If
#EndIf
```

**Implementation Plan**:
- Phase 1: Core DEFLATE algorithm (20-25 hours)
  - LZ77 sliding window compression
  - Huffman tree generation
  - Bitstream encoding
  - Adler-32 checksum
- Phase 2: Optimization (8-10 hours)
  - Variable compression levels (1-9)
  - Memory optimization
  - Compression statistics
- Phase 3: Testing (5-7 hours)
  - Cross-platform validation
  - Compression ratio benchmarks
  - PDF reader compatibility

See [Chapter 16: Premium Modules](16-premium-modules.md#vnspdfzlibpremium) for details.

### VNSPDFTablePremium - High-Level Table API
**Status**: 🔨 **Planned** (Estimated: 30-37 hours)
**Module Flag**: `kHasTableModule`

```xojo
// High-level declarative table API (when implemented)
If VNSPDFModule.kHasTableModule Then
    Dim table As VNSPDFTable = VNSPDFTablePremium.CreateTable(pdf)
    table.AddColumn("Name", 0, "L")      // Auto-width
    table.AddColumn("Email", 0, "L")
    table.AddColumn("Phone", 0, "R")
    table.AddRow("John Doe", "john@example.com", "555-1234")
    table.AddRow("Jane Smith", "jane@example.com", "555-5678")
    table.SetHeaderBackgroundColor(51, 102, 153)
    table.SetAlternateRowColor(240, 240, 240)
    table.Render()  // Auto page breaks with header repetition
End If
```

**Implementation Plan**:
- Phase 1: Core Table (15-18 hours)
  - VNSPDFTable class
  - Auto-width calculation
  - Basic rendering
  - Header row styling
- Phase 2: Advanced Features (10-12 hours)
  - Alternating row colors
  - Page break handling
  - Column/row spanning
  - Custom cell formatters
- Phase 3: Polish (5-7 hours)
  - Border customization
  - Padding/spacing controls
  - Performance optimization

**Features**:
- Automatic column sizing
- Header rows with styling
- Cell borders and padding
- Alternating row colors
- Page breaks within tables
- Column spanning

See [Chapter 16: Premium Modules](16-premium-modules.md#vnspdftablepremium) for details.

## Planned Features (FREE Version)

### ~~Document Protection/Encryption~~ ✅ **IMPLEMENTED (RC4-128)**
```xojo
// Password protection and permissions (RC4-128 - WORKING!)
pdf.SetProtection("userpass", "ownerpass", True, False, False, True, 3)

// Advanced configuration
Dim enc As New VNSPDFEncryption(3)  // Revision 3 (RC4-128)
enc.SetPasswords("user123", "owner456")
enc.SetPermissions(True, False, True, True)
pdf.SetEncryption(enc)
```

**Status**:
- ✅ **RC4-128 (Revision 3) - WORKING** - Production-ready
- ❌ **AES-128/256 (Revisions 4-6)** - Blocked by Xojo Crypto API PKCS7 padding limitation
- ✅ User and owner passwords
- ✅ Granular permissions (print, copy, modify, annotate)
- ✅ Object-level encryption
- ✅ PDF version auto-upgrade

**Future Work**:
- AES encryption when Xojo Crypto API allows disabling PKCS7 padding
- Or implement custom AES without Xojo Crypto module

## Lower Priority Features

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
- Form fields (text, checkbox, radio, dropdown)
- Annotations (notes, highlights, stamps)
- Digital signatures
- Attachments

### Performance Optimizations
- Streaming output for very large PDFs
- Incremental PDF generation
- Memory-mapped file handling
- Multi-threaded rendering
