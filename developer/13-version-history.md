# Xojo FPDF - Version History

## Version 1.0.0 (December 2025) - Current Release

**PDF Import & Arabic Text Shaping**
- PDF Import: Full parser with XObject template support, multi-page extraction, resource copying, nested XObjects
- Arabic text shaping: Automatic contextual forms (isolated, initial, medial, final), proper RTL rendering for all Arabic-script languages

## Version 0.9.0 (November 2025)

**API2 Compliance & iOS Optimization**
- Complete API2 migration: All deprecated methods replaced (96.8% warning reduction from 95 to 3)
- iOS string handling: Proper 0-based indexing, byte-by-byte MemoryBlock extraction for large buffers

## Version 0.8.0 (November 2025)

**Premium Modules**
- Table generation: SimpleTable, ImprovedTable, FancyTable with automatic pagination, header repetition, footer calculations
- Pure Xojo zlib: iOS compression support bypassing sandboxing, PNG Predictor reversal for PDF Import

## Version 0.7.0 (November 2025)

**Advanced Graphics**
- Bezier curves: Quadratic and cubic curves for smooth paths
- Polygon drawing: Arbitrary shapes with Point arrays, arrow lines with configurable arrowheads

## Version 0.6.0 (November 2025)

**Security & Compliance**
- Document encryption: RC4-40/128, AES-128/256 with granular permission control (8 permission flags)
- PDF/A compliance: ICC color profile embedding with automatic sRGB detection

## Version 0.5.0 (November 2025)

**Document Features**
- Stream compression: FlateDecode/zlib with 27-60% file size reduction
- Headers/footers: Automatic callbacks with page count substitution, last page indicator, home mode for watermarks

## Version 0.4.0 (November 2025)

**Images & Media**
- JPEG/PNG support: RGB, Grayscale, CMYK color spaces with DCTDecode and FlateDecode filters
- Programmatic graphics: ImageFromPicture() embeds drawn Picture objects (Desktop/Web platforms)

## Version 0.3.0 (November 2025)

**Text & Fonts**
- UTF-8/TrueType fonts: Full Unicode support with automatic font subsetting, Identity-H encoding
- Text measurement: GetStringWidth(), GetFontDesc() with font metrics, Printf-style formatting (Cellf, Writef)

## Version 0.2.0 (November 2025)

**Platform Expansion**
- iOS project: Touch-based interface, Documents folder file management, specialized string handling
- Console project: Interactive menu with all examples, Desktop file I/O compatibility

## Version 0.1.0 (November 2025)

**Initial Release**
- Core PDF generation: Document initialization, page management, coordinate systems, unit conversion
- Desktop & Web projects: Shared PDF_Library folder, platform-specific file I/O, 5 basic examples

---

**Current Status (v1.0.0)**:
- ✅ 20 working examples across 4 platforms (Desktop, Web, iOS, Console)
- ✅ 100% Open Source (MIT License) with full source code
- ✅ Premium modules available separately (Tables, Zlib, Encryption)
- ✅ Production-ready with comprehensive feature set
