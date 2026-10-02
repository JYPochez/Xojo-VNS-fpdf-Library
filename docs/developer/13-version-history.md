# Xojo FPDF - Version History

## Version 1.4 (October 2026) - Current Release

**Tested with Xojo 2026r2.1 API2** (earlier API2 versions should work)

- Table border customization: `mBorderColor` (default black), `mBorderWidth` (default 0.2mm), per-column `mBorderStyle`, per-row `SetRowBorder()`, per-cell `SetCellBorder()` with cascade priority: cell > row > column > table
- Cell vertical alignment (v1.3 Geoff Bridges): `eVerticalAlignment.Top/Middle/Bottom/Baseline` in Cell() method
- Border.IsNumeric fix (v1.3): Cell/MultiCell border parameter accepts both numeric and string values
- Empty MultiCell borders (v1.3): Single empty-text MultiCell now draws correct borders
- Write() linebreaks (v1.3): Explicit chr(10) linebreaks now work inside Write() calls
- Preview save folder (v1.3 Geoff Bridges): `ShowPreview(doc, initialFolder)` parameter for default save location
- ToUnicode CMap fix: code points above U+FFFF (emoji) written as UTF-16BE surrogate pairs instead of invalid odd-length hex (which crashed macOS Preview), `.notdef` no longer mapped, `bfchar` blocks limited to 100 entries
- Hebrew is now reversed for display like Arabic, and digit sequences keep left-to-right order inside Hebrew/Arabic text (`2026` no longer shown as `6202`)
- Emoji: multi-code-point sequences (skin tones, ZWJ, flags, keycaps) render as one image; Desktop emoji images use 8% padding instead of 30% so emoji match the text size
- HTML/Markdown Import: entities decoded exactly once (`&amp;amp;` renders as `&amp;`), Hebrew/Arabic paragraphs laid out in browser (bidi) order with emoji, word-wrap and baseline alignment

## Version 1.3 (March 2026)

**Xojo 2025r3.1 API2**

- SetDisplayMode now outputs to PDF: Added `PutDisplayMode()` to write `/OpenAction` and `/PageLayout` to catalog. Numeric zoom percentages supported (e.g. "75", "200"). Contribution: Geoff Bridges
- Color object overloads fixed: `SetTextColor(Color)`, `SetFillColor(Color)`, `SetDrawColor(Color)` and `Get*Color() As Color` were broken on API2 (always returned black due to API1-era `\ 256` conversion). Fixed by using Color components directly
- Get*Color methods documented: Both Color-returning and ByRef overloads for GetTextColor, GetFillColor, GetDrawColor
- Example 2 section 9: Color object overload visual tests with roundtrip PASS/FAIL verification
- HTML/Markdown Import: Block-level CSS (`width`, `max-width`, `margin`, `padding`, `border`, `line-height`, `display`, `text-transform`), `<style>` block parsing, merge fields, external image support, ~5x faster tokenizer
- Forms Module Phase 1: Button actions, checkbox appearance, all 9 control types
- Zlib: Native-first compression strategy, hash chain optimization, static Huffman table fix
- PDF Import: Array content streams, double indirect references, empty content tolerance
- Per-project premium constants (moved from shared VNSPDFModule to per-project files)

## Version 1.1.1 (February 2026)

**Xojo 2025r3.1 API2**

- Permissions property: Xojo-compatible `PDFPermissions` support (AES-128 with premium, RC4-40 without)
- iOS compilation: Fixed Object2D method exclusion using CompatibilityFlags

## Version 1.0.2 (January 2026)

**Critical Bug Fixes (January 2026)**
- MultiCell single-line bottom border: Fixed missing bottom border on single-line cells (all platforms)
- SplitTextToLines character loss: Fixed first character missing in wrapped words (Desktop/Web/Console 0-based indexing)
- MultiCell newline handling: Added proper CRLF and LF support for paragraph breaks
- MultiCell positioning: Fixed incorrect X/Y position after MultiCell completion
- ImageFromPicture PNG corruption: Fixed Windows/Linux RGBA→RGB mismatch by forcing JPEG format (QualityHigh)
- Example 26: Cross-platform bug testing suite (macOS/Windows/Linux verification)

**File Attachments (January 2026)**
- Document-level attachments: EmbeddedFiles name tree with file specifications
- Page-level annotation attachments: FileAttachment annotations with icon support
- Full E-Invoice/Factur-X readiness: PDF/A-3 hybrid PDF/XML support
- Example 23: Document and page-level attachment demonstrations

**Xojo PDFDocument Compatibility (December 2025)**
- VNSPDFGraphics wrapper: Full Xojo PDFGraphics API compatibility (DrawText, DrawLine, FillRectangle, etc.)
- Drop-in replacement: VNSPDFDocument works as Xojo PDFDocument with advanced features
- Example 22: Side-by-side comparison of Xojo PDFDocument vs VNSPDFDocument

## Version 1.0.1 (January 2026)

**Transformations & Image Options**
- Transformation methods: TransformBegin/End for graphics state management, TransformRotate for rotation around a point
- Matrix transformations: Transform() for raw 2D transformation matrix application
- Mirror transformations: MirrorHorizontal, MirrorVertical, MirrorPoint, MirrorLine for flipping graphics
- Example 21: All 18 transformation methods demonstration
- ImageOptions(): Dictionary-based options for advanced image placement (imageType, readDpi, allowNegativePosition)

## Version 1.0.0 (December 2025)

**PDF Import & Arabic Text Shaping**
- PDF Import: Full parser with XObject template support, multi-page extraction, resource copying, nested XObjects
- Arabic text shaping: Automatic contextual forms (isolated, initial, medial, final), proper RTL rendering for all Arabic-script languages
- Example 20: PDF Import with XObject templates

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

**Current Status (v1.3)**:
- 33 working examples across 4 platforms (Desktop, Web, iOS, Console)
- 100% Open Source core with full source code
- Premium modules available (each €50): Encryption, Table, Zlib, E-Invoice (includes Barcodes), HTML/Markdown Import, Digital Signatures
- In development: PDF/A, Forms (82% complete)
- Bundle pricing: Buy 2 Get 1 Free = €100
- Production-ready with comprehensive feature set
- Xojo PDFDocument compatibility: Drop-in replacement with advanced features
- Xojo 2025r3.1 API2
