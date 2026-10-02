# go-fpdf vs VNS PDF FREE Version - Feature Comparison

**Last Updated:** 2026-10-02
**VNS PDF Version:** 1.4 FREE (No Premium Modules)
**Platforms:** Desktop, Web, iOS, Console, **Android** (same `PDF_Library` source on all five)
**go-fpdf Reference:** v2.0+

---

## ⚠️ FREE VERSION LIMITATIONS

This document compares the **FREE version** of VNS PDF against go-fpdf. The FREE version does NOT include premium modules:

**What's NOT Available in FREE:**
- ❌ **RC4-128 encryption** (128-bit) - Requires premium Encryption module
- ❌ **AES encryption** (128/256-bit) - Requires premium Encryption module
- ❌ **PDF/A output intents** - Requires premium PDF/A module
- ❌ **iOS / Android compression and Flate import** - No system zlib on mobile: requires the premium Zlib module (pure Xojo)
- ✅ **Mobile compression with Premium** - Pure Xojo zlib implementation works on all platforms including iOS and Android
- ❌ **Table generation** - Requires premium Table module - **FULLY WORKING in Premium**
- ❌ **E-Invoice generation** - Requires premium E-Invoice module (Factur-X, ZUGFeRD, EN 16931, 3-level validation, barcodes)
- ❌ **HTML / Markdown import** - Requires premium HTML/Markdown module (`LoadHTML()`, `LoadMarkdown()`)
- ❌ **Decryption of encrypted source PDFs on import** - Not available yet (clear error since 1.4); planned: RC4 in FREE, AES with the Encryption module

**What IS Available in FREE:**
- ✅ **RC4-40 encryption** (40-bit) - DEPRECATED and WEAK, but available
- ✅ All core PDF features (text, graphics, images, fonts, links, etc.)
- ✅ Basic compression (FlateDecode/zlib via system libraries on Desktop/Web/Console; Windows needs `ZLIB1.DLL` next to the app; **iOS/Android need premium Zlib**)
- ✅ Full Unicode/TrueType font support, Arabic shaping, Hebrew and Arabic right-to-left display
- ✅ Color emoji (image-based), including skin-tone, ZWJ, flag and keycap sequences
- ✅ PDF import (pages as templates, PDF 1.5+ object streams, clone constructors)
- ✅ Document metadata, headers/footers, bookmarks

For premium features, see `FEATURE_COMPARISON_PREMIUM.md`.

**💡 Premium Modules Can Be Purchased Separately** - You don't need to buy all premium modules! Purchase only what you need:
- 🔐 **Encryption Module** - RC4-128, AES-128, AES-256, AES-GCM, PAdES-B-B digital signatures *(Ready)*
- 📊 **Table Module** - Professional table generation with headers, footers, pagination *(Ready)*
- 🗜️ **Zlib Module** - Pure Xojo compression for iOS support *(Ready)*
- 🔮 **PDF/A Module** - Archival compliance and ICC profiles *(Planned)*
- 🧾 **E-Invoice Module** - Factur-X/ZUGFeRD hybrid PDF/XML invoices, EN 16931 compliance, barcodes *(Ready)*
- 🌐 **HTML/Markdown Import Module** - `LoadHTML()` / `LoadMarkdown()` with CSS engine *(Ready)*

Mix and match based on your requirements!

---

## Legend
- ✅ **Implemented** - Feature fully working
- ⚠️ **Partially implemented** - Feature exists but incomplete
- ❌ **Not implemented** - Feature missing
- 🔒 **PREMIUM ONLY** - Requires premium module (not available in FREE)
- 🔄 **Different API/approach** - Implemented differently

---

## 1. Document Setup & Metadata

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Create document | New() | Constructor() | ✅ | Different syntax |
| Page orientation | AddPageFormat() | AddPage(orientation) | ✅ | |
| Page units | New(unit) | Constructor(unit) | ✅ | |
| Page format | New(format) | Constructor(pageFormat) | ✅ | |
| Set title | SetTitle() | SetTitle() | ✅ | UTF-16BE encoding |
| Set author | SetAuthor() | SetAuthor() | ✅ | UTF-16BE encoding |
| Set subject | SetSubject() | SetSubject() | ✅ | UTF-16BE encoding |
| Set keywords | SetKeywords() | SetKeywords() | ✅ | UTF-16BE encoding |
| Set creator | SetCreator() | SetCreator() | ✅ | UTF-16BE encoding |
| Set producer | SetProducer() | SetProducer() | ✅ | PDF producer metadata |
| Set language | SetLang() | SetLang() | ✅ | |
| XMP metadata | SetXmpMetadata() | SetXmpMetadata() | ✅ | XML-based metadata |
| Get XMP metadata | GetXmpMetadata() | GetXmpMetadata() | ✅ | Retrieve XMP metadata stream |
| Output intent | AddOutputIntent() | | 🔒 | **PREMIUM PDF/A MODULE REQUIRED** |
| Compression | SetCompression() | SetCompression() | ⚠️ | FlateDecode/zlib (Desktop/Web/Console via system libs; **iOS: requires premium Zlib module for pure Xojo compression**) |
| Get compression | GetCompression() | GetCompression() | ✅ | Returns compression state |

## 2. Page Management

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Add page | AddPage() | AddPage() | ✅ | |
| Add page with format | AddPageFormat() | AddPageFormat() | ✅ | Custom page dimensions |
| Set current page | SetPage() | SetPage() | ✅ | Navigate to existing page |
| Page count | PageCount() | PageCount() | ✅ | Returns total number of pages |
| Current page number | PageNo() | PageNo() | ✅ | Returns current page number |
| Page size | GetPageSize() | GetPageSize() | ✅ | Current page dimensions |
| Page size by number | PageSize() | PageSize() | ✅ | Specific page dimensions |
| Page boxes | SetPageBox() | SetPageBox() | ✅ | TrimBox, CropBox, BleedBox, ArtBox |
| Auto page break | SetAutoPageBreak() | SetAutoPageBreak() | ✅ | |
| Get auto page break | GetAutoPageBreak() | GetAutoPageBreak() | ✅ | Returns enable state and margin |
| Single page mode | | SetSinglePageMode() | ✅ | Render all content on one long page, no page breaks (v1.4) |
| Get single page mode | | GetSinglePageMode() | ✅ | Returns the single page mode flag (v1.4) |
| Finalize single page | | FinalizeSinglePage() | ✅ | Trim the page to the content height (v1.4) |

## 3. Margins & Positioning

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Set margins | SetMargins() | SetMargins() | ✅ | |
| Get margins | GetMargins() | GetMargins() | ✅ | Returns left, top, right, bottom |
| Left margin | SetLeftMargin() | SetLeftMargin() | ✅ | |
| Top margin | SetTopMargin() | SetTopMargin() | ✅ | |
| Right margin | SetRightMargin() | SetRightMargin() | ✅ | |
| Cell margin | SetCellMargin() | SetCellMargin() | ✅ | Horizontal padding inside cells |
| Get cell margin | GetCellMargin() | GetCellMargin() | ✅ | Returns cell margin value |
| Set X position | SetX() | SetX() | ✅ | |
| Set Y position | SetY() | SetY() | ✅ | |
| Set XY position | SetXY() | SetXY() | ✅ | |
| Get X position | GetX() | GetX() | ✅ | |
| Get Y position | GetY() | GetY() | ✅ | |
| Get XY position | GetXY() | GetXY() | ✅ | Returns Dictionary with x,y |
| Set home XY | SetHomeXY() | SetHomeXY() | ✅ | Sets position to top-left margins |
| Line break | Ln() | Ln() | ✅ | |

## 4. Fonts & Text

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Add font | AddFont() | | ❌ | Not implemented |
| Add UTF-8 font | AddUTF8Font() | AddUTF8Font() | ✅ | Full Unicode support |
| Add font from bytes | AddFontFromBytes() | | ❌ | Not implemented |
| Add UTF-8 font from bytes | AddUTF8FontFromBytes() | AddUTF8FontFromBytes() | ✅ | Load TrueType from MemoryBlock |
| Add font from reader | AddFontFromReader() | | ❌ | Not implemented |
| Set font | SetFont() | SetFont() | ✅ | |
| Get font family | GetFontFamily() | GetFontFamily() | ✅ | Returns current font family |
| Get font style | GetFontStyle() | GetFontStyle() | ✅ | Returns current font style |
| Set font style | SetFontStyle() | SetFontStyle() | ✅ | Change style without changing family/size |
| Set font size | SetFontSize() | SetFontSize() | ✅ | Change size without changing family/style |
| Set font unit size | SetFontUnitSize() | SetFontUnitSize() | ✅ | Set font size in user units |
| Get font size | GetFontSize() | GetFontSize() | ✅ | Returns ptSize and unitSize |
| Get font descriptor | GetFontDesc() | GetFontDesc() | ✅ | Returns Dictionary with metrics |
| Get font location | GetFontLocation() | GetFontLocation() | ✅ | Returns font directory path |
| Set font location | SetFontLocation() | SetFontLocation() | ✅ | Sets font directory path |
| Get/Set font loader | GetFontLoader/SetFontLoader | | ❌ | Not implemented |
| Get string width | GetStringWidth() | GetStringWidth() | ✅ | Supports UTF-8 fonts |
| Get symbol width | GetStringSymbolWidth() | GetStringSymbolWidth() | ✅ | Single character width |
| Text color | SetTextColor() | SetTextColor() | ✅ | |
| Get text color | GetTextColor() | GetTextColor() | ✅ | Returns RGB components |
| Word spacing | SetWordSpacing() | SetWordSpacing() | ✅ | Set spacing between words |
| Get word spacing | GetWordSpacing() | GetWordSpacing() | ✅ | Returns current word spacing |
| Text rendering mode | SetTextRenderingMode() | SetTextRenderingMode() | ✅ | 8 modes: fill, stroke, invisible, clip |
| Underline thickness | SetUnderlineThickness() | SetUnderlineThickness() | ✅ | Multiplier for underline thickness |
| Get underline thickness | GetUnderlineThickness() | GetUnderlineThickness() | ✅ | Returns thickness multiplier |
| Font subsetting | SubsetFont() | SetFontSubsetting(), GetFontSubsetting() | ✅ | Sparse glyph ID subsetting (98% size reduction) |
| RTL text | RTL() | RTL() | ✅ | Enable right-to-left text direction (flag only) |
| Hebrew right-to-left display | | Cell(), MultiCell(), GetStringWidth() | ✅ | Hebrew runs reversed automatically for display (v1.4) |
| LTR text | LTR() | LTR() | ✅ | Enable left-to-right text direction (default) |
| Arabic text shaping | | ShapeArabicText() | ✅ | Automatic contextual forms (isolated, initial, medial, final) with RTL reversal; brackets mirrored, digits kept left-to-right (v1.4) |

## 5. Text Output

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Simple text | Text() | Text() | ✅ | |
| Cell | Cell() | Cell() | ✅ | Full border support, fill, alignment, vertical alignment (`eVerticalAlignment`: Top, Middle, Bottom, Baseline) |
| Cell with format | CellFormat() | CellFormat() | ✅ | Wrapper for Cell() with explicit parameters |
| Formatted cell | Cellf() | Cellf() | ✅ | Printf-style formatting (%s, %d, %f) |
| Multi-cell | MultiCell() | MultiCell() | ✅ | Text wrapping with alignment |
| Write | Write() | Write() | ✅ | Flowing text with automatic wrapping |
| Formatted write | Writef() | Writef() | ✅ | Printf-style formatting in flowing text |
| Write link (string) | WriteLinkString() | WriteLinkString() | ✅ | Write text with clickable URL |
| Write link (ID) | WriteLinkID() | WriteLinkID() | ✅ | Write text with internal link ID |
| Write aligned | WriteAligned() | WriteAligned() | ✅ | Write with left/center/right alignment |
| Split lines | SplitLines() | SplitLines() | ✅ | Split text into lines that fit width |

## 6. Graphics Primitives

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Line | Line() | Line() | ✅ | |
| Rectangle | Rect() | Rect() | ✅ | |
| Rounded rectangle | RoundedRect() | RoundedRect() | ✅ | Selective corner rounding |
| Rounded rect ext | RoundedRectExt() | RoundedRectExt() | ✅ | Individual radius per corner |
| Circle | Circle() | Circle() | ✅ | |
| Ellipse | Ellipse() | Ellipse() | ✅ | |
| Arc | Arc() | Arc() | ✅ | Elliptical arcs with rotation |
| Polygon | Polygon() | Polygon() | ✅ | Multi-point polygon |
| Beziergon | Beziergon() | Beziergon() | ✅ | Closed shape with Bezier curves |
| Bezier curve | Curve() | Curve() | ✅ | Quadratic Bezier curves |
| Cubic curve | CurveCubic() | CurveCubic() | ✅ | Legacy wrapper with nonstandard parameter order |
| Cubic bezier curve | CurveBezierCubic() | CurveBezierCubic() | ✅ | Cubic Bezier curves |
| Arrow line | | Arrow() | ✅ | Lines with arrowheads (not in go-fpdf) |

## 7. Colors & Graphics State

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Draw color | SetDrawColor() | SetDrawColor() | ✅ | |
| Get draw color | GetDrawColor() | GetDrawColor() | ✅ | Returns RGB components |
| Fill color | SetFillColor() | SetFillColor() | ✅ | |
| Get fill color | GetFillColor() | GetFillColor() | ✅ | Returns RGB components |
| Line width | SetLineWidth() | SetLineWidth() | ✅ | |
| Get line width | GetLineWidth() | GetLineWidth() | ✅ | Returns current line width |
| Line cap style | SetLineCapStyle() | SetLineCapStyle() | ✅ | butt, round, square |
| Get line cap style | GetLineCapStyle() | GetLineCapStyle() | ✅ | Returns cap style string |
| Line join style | SetLineJoinStyle() | SetLineJoinStyle() | ✅ | miter, round, bevel |
| Get line join style | GetLineJoinStyle() | GetLineJoinStyle() | ✅ | Returns join style string |
| Dash pattern | SetDashPattern() | SetDashPattern() | ✅ | Custom dash array and phase |
| Alpha/transparency | SetAlpha() | SetAlpha() | ✅ | With 16 blend modes |
| Get alpha | GetAlpha() | GetAlpha() | ✅ | Returns current alpha value |
| Get blend mode | GetBlendMode() | GetBlendMode() | ✅ | Returns current blend mode |

## 8. Transformations

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Transform begin | TransformBegin() | TransformBegin() | ✅ | Start transformation context |
| Transform end | TransformEnd() | TransformEnd() | ✅ | End transformation context |
| Rotate | TransformRotate() | TransformRotate() | ✅ | Rotate text/graphics around point |
| Transform matrix | Transform() | Transform() | ✅ | Apply transformation matrix |
| Scale X | TransformScaleX() | TransformScaleX() | ✅ | Scale width only at point |
| Scale Y | TransformScaleY() | TransformScaleY() | ✅ | Scale height only at point |
| Scale XY | TransformScaleXY() | TransformScaleXY() | ✅ | Scale width & height equally |
| Scale | TransformScale() | TransformScale() | ✅ | Scale width & height at point |
| Mirror horizontal | TransformMirrorHorizontal() | TransformMirrorHorizontal() | ✅ | Flip horizontally at X axis |
| Mirror vertical | TransformMirrorVertical() | TransformMirrorVertical() | ✅ | Flip vertically at Y axis |
| Mirror point | TransformMirrorPoint() | TransformMirrorPoint() | ✅ | 180° flip at point |
| Mirror line | TransformMirrorLine() | TransformMirrorLine() | ✅ | Mirror along angled line |
| Translate X | TransformTranslateX() | TransformTranslateX() | ✅ | Translate along X axis |
| Translate Y | TransformTranslateY() | TransformTranslateY() | ✅ | Translate along Y axis |
| Translate | TransformTranslate() | TransformTranslate() | ✅ | Translate along both axes |
| Skew X | TransformSkewX() | TransformSkewX() | ✅ | Skew along X axis at point |
| Skew Y | TransformSkewY() | TransformSkewY() | ✅ | Skew along Y axis at point |
| Skew | TransformSkew() | TransformSkew() | ✅ | Skew along both axes at point |

## 9. Gradients

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Linear gradient | LinearGradient() | LinearGradient() | ✅ | Full PDF shading patterns |
| Radial gradient | RadialGradient() | RadialGradient() | ✅ | Dual-circle radial gradients |
| Multi-stop linear gradient | N/A | LinearGradientMultiStop() | ✅ | FunctionType 3 stitching for rainbow gradients |
| Brush-based gradients | N/A | VNSPDFGraphicsUTF.Brush | ✅ | LinearGradientBrush/RadialGradientBrush support |

## 10. Clipping

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Clip rectangle | ClipRect() | ClipRect() | ✅ | Rectangular clipping paths |
| Clip text | ClipText() | ClipText() | ✅ | Text-shaped clipping paths |
| Clip rounded rect | ClipRoundedRect() | ClipRoundedRect() | ✅ | Rounded rectangle clipping |
| Clip rounded rect ext | ClipRoundedRectExt() | ClipRoundedRectExt() | ✅ | Individual radius per corner |
| Clip ellipse | ClipEllipse() | ClipEllipse() | ✅ | Elliptical clipping paths |
| Clip circle | ClipCircle() | ClipCircle() | ✅ | Circular clipping paths |
| Clip polygon | ClipPolygon() | ClipPolygon() | ✅ | Multi-point polygon clipping |
| End clipping | ClipEnd() | ClipEnd() | ✅ | Restores graphics state |

## 11. Images

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Add image | Image() | Image() | ✅ | JPEG (DCTDecode) and PNG (FlateDecode) - All platforms ✅ |
| Image from Picture | | ImageFromPicture() | ✅ | Embed Xojo Picture objects - JPEG on all platforms (no alpha channel issues) |
| Image with options | ImageOptions() | ImageOptions() | ✅ | Dictionary-based options (imageType, readDpi, allowNegativePosition) |
| Register image | RegisterImage() | RegisterImage() | ✅ | Pre-register images for reuse |
| Register from bytes | RegisterImageFromBytes() | RegisterImageFromBytes() | ✅ | Register from MemoryBlock (PNG/JPEG) |
| Register image options | RegisterImageOptions() | RegisterImageOptions() | ✅ | Pre-register with options Dictionary |
| Register from reader | RegisterImageReader() | RegisterImageReader() | ✅ | DEPRECATED wrapper for RegisterImageOptionsReader() |
| Register with options | RegisterImageOptionsReader() | RegisterImageOptionsReader() | ✅ | Pre-register from MemoryBlock with options |
| Get image info | GetImageInfo() | | ✅ | Via VNSPDFImage class methods |
| Image type from MIME | ImageTypeFromMime() | ImageTypeFromMime() | ✅ | Converts MIME strings to types |
| Color emoji | | Emoji() | ✅ | Desktop ✅, iOS ✅ (UIKit), Android ✅ (Noto Color Emoji), Web ✅ (sbix / CBDT / COLR font parsing), Console ❌ (no graphics). Skin-tone, ZWJ, flag and keycap sequences drawn as one emoji (v1.4) |

**iOS Image Support Notes**:
- ✅ **All image features working on iOS** - Fixed RGBA→RGB conversion issue
- iOS uses JPEG format internally for `ImageFromPicture()` to avoid alpha channel issues
- Bundled images: Use `SpecialFolder.Resource(filename)` + `Picture.Open()`
- Charts: Use `chart.ToPicture()` + `ImageFromPicture()` - works correctly on iOS
- JPEG format automatically strips alpha channel (RGBA→RGB conversion)
- ✅ **Color emoji rendering working on iOS** - Uses native UIKit (UILabel + Apple Color Emoji font)
- Emoji rendered to UIImage, converted to PNG data, then to Picture via `Picture.FromData()`
- Proper memory management: UIImage→PNG NSData→MemoryBlock→Picture (avoids ARC issues)

**Android Notes** (v1.4):
- ✅ **All FREE examples run on Android** (demo app `Xojo_fpdf_android`, same example list as iOS)
- Bundled files (fonts, data) need a **Copy Files build step to the Resources folder, placed before the Build step**; `SpecialFolder.Resource()` raises an exception for a missing name
- Color emoji drawn with the system Noto Color Emoji font
- Large fonts are slow to read in a debug build on the emulator (23 MB Arial Unicode: ~25 s)

**iOS Font Loading Notes**:
- ✅ **TrueType font parsing working on iOS** - Fixed MemoryBlock.StringValue() crash
- iOS crashes when using `MemoryBlock.StringValue(position, length)` on large buffers (>20MB) at high offsets
- Solution: Byte-by-byte extraction using `UInt8Value()` for ASCII strings and `UInt16Value()` for UTF-16BE strings
- Performance impact: Negligible (only 42 bytes total extracted for font name parsing)
- Successfully loads 23MB font files (Arial Unicode) with 98% subsetting reduction

## 12. Links & Bookmarks

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Add link | AddLink() | AddLink() | ✅ | Returns linkID for internal links |
| Set link | SetLink() | SetLink() | ✅ | Define link destination |
| Link area | Link() | Link() | ✅ | Create clickable area for internal links |
| Link string | LinkString() | LinkString() | ✅ | Create clickable area for external URLs |
| Bookmark | Bookmark() | Bookmark() | ✅ | Hierarchical outline/sidebar navigation |
| Alias nb pages | AliasNbPages() | AliasNbPages() | ✅ | Text substitution for page count |

## 13. Headers & Footers

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Set header function | SetHeaderFunc() | SetHeaderFunc() | ✅ | VNSPDFModule.HeaderFooterDelegate |
| Set header with mode | SetHeaderFuncMode() | SetHeaderFuncMode() | ✅ | With homeMode to reset X/Y |
| Set footer function | SetFooterFunc() | SetFooterFunc() | ✅ | VNSPDFModule.HeaderFooterDelegate |
| Set footer with LPI | SetFooterFuncLpi() | SetFooterFuncLpi() | ✅ | With lastPage indicator |
| Automatic footer height | | (automatic) | ✅ | Footer callbacks are measured; no manual bottom margin needed (v1.4) |
| Header on page 1 | | SetHeaderFunc() | ✅ | Header also drawn on the already-open first page (v1.4) |
| Accept page break func | SetAcceptPageBreakFunc() | SetAcceptPageBreakFunc() | ✅ | Custom page break logic callback |
| Get page number | PageNo() | PageNo() | ✅ | For use in callbacks |
| Get font family | | FontFamily() | ✅ | For state management in callbacks |
| Get font style | | FontStyle() | ✅ | For state management in callbacks |
| Get font size | | FontSizePt() | ✅ | For state management in callbacks |

## 14. Templates & Objects

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Import objects | ImportObjects() | | ❌ | Not implemented |
| Import object positions | ImportObjPos() | | ❌ | Not implemented |
| Use imported template | UseImportedTemplate() | | ❌ | Not implemented |
| Import templates | ImportTemplates() | | ❌ | Not implemented |

## 15. Output & Display

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Output to writer | Output() | Output() | ✅ | Returns string |
| Output and close | OutputAndClose() | OutputAndClose() | ✅ | Combines Output() and Close() |
| Output file and close | OutputFileAndClose() | | ⚠️ | SaveToFile() |
| Display mode | SetDisplayMode() | SetDisplayMode() | ✅ | Set zoom and layout mode |
| Get display mode | GetDisplayMode() | GetDisplayMode() | ✅ | Returns Dictionary with zoom, layout |

## 16. Security & Encryption (FREE VERSION)

### go-fpdf Security Implementation
**go-fpdf has very limited security support:**
- **Only 40-bit RC4 encryption** (PDF Security Revision 2)
- **Deprecated and insecure** - RC4 is cryptographically broken
- **No AES support** - Cannot use modern encryption

### VNS PDF FREE Security Implementation

⚠️ **FREE VERSION LIMITATION: Only RC4-40 (40-bit) encryption is available.**

All stronger encryption requires the **premium Encryption module**:
- 🔒 RC4-128 (128-bit) - **PREMIUM ONLY**
- 🔒 AES-128 (128-bit) - **PREMIUM ONLY**
- 🔒 AES-256 (256-bit) - **PREMIUM ONLY**

| Feature | go-fpdf | VNS PDF FREE | Status | Notes |
|---------|---------|--------------|--------|-------|
| **Encryption Algorithms** | | | | |
| 40-bit RC4 (Revision 2) | ✅ | ✅ | ✅ | DEPRECATED and WEAK - **WORKING** |
| 128-bit RC4 (Revision 3) | ❌ | | 🔒 | **PREMIUM ENCRYPTION MODULE** |
| 128-bit AES-CBC (Revision 4) | ❌ | | 🔒 | **PREMIUM ENCRYPTION MODULE** |
| 256-bit AES-CBC (Revision 5) | ❌ | | 🔒 | **PREMIUM ENCRYPTION MODULE** |
| 256-bit AES-CBC (Revision 6) | ❌ | | 🔒 | **PREMIUM ENCRYPTION MODULE** |
| **Key Derivation** | | | | |
| MD5 hashing | ✅ | ✅ | ✅ | Revision 2 only |
| SHA-256 hashing | ❌ | | 🔒 | **PREMIUM ENCRYPTION MODULE** |
| SHA-512 hashing | ❌ | | 🔒 | **PREMIUM ENCRYPTION MODULE** |
| Iterative hashing (50 iterations) | ❌ | | 🔒 | **PREMIUM ENCRYPTION MODULE** |
| **Password System** | | | | |
| User password (open document) | ✅ | ✅ | ✅ | Restricts document opening |
| Owner password (permissions) | ✅ | ✅ | ✅ | Controls editing permissions |
| PDF standard padding | ✅ | ✅ | ✅ | 32-byte password padding |
| **Permissions (Granular Control)** | | | | |
| Print permission (low quality) | ✅ | ✅ | ✅ | Allow/deny low-quality printing (Bit 3) |
| Modify permission | ✅ | ✅ | ✅ | Allow/deny content modification (Bit 4) |
| Copy permission | ✅ | ✅ | ✅ | Allow/deny text/graphics copying (Bit 5) |
| Annotations permission | ✅ | ✅ | ✅ | Allow/deny annotations/signatures (Bit 6) |
| Fill forms permission | ❌ | ✅ | ✅ | Allow/deny form filling (Bit 8, Rev 3+) |
| Extract for accessibility | ❌ | ✅ | ✅ | Allow/deny content extraction (Bit 9, Rev 3+) |
| Assemble permission | ❌ | ✅ | ✅ | Allow/deny page insert/rotate/delete (Bit 10, Rev 3+) |
| High quality print permission | ❌ | ✅ | ✅ | Allow/deny high-res printing (Bit 11, Rev 3+) |
| **API Methods** | | | | |
| SetProtection() | ✅ | ✅ | ✅ | Set passwords and permissions (RC4-40 only) |
| SetEncryption() | ❌ | ✅ | ✅ | Set encryption revision (RC4-40 only in FREE) |
| EncryptObject() | ❌ | ✅ | ✅ | Low-level object encryption |
| GetEncryptionDictionary() | ❌ | ✅ | ✅ | Generate encryption dictionary |
| IsEncrypted() | ❌ | ✅ | ✅ | Check encryption status |
| GetRevision() | ❌ | ✅ | ✅ | Query encryption revision |
| GetAlgorithm() | ❌ | ✅ | ✅ | Query encryption algorithm |

**FREE VERSION Security Verdict**: ⚠️ **RC4-40 ONLY (DEPRECATED)** - Only 40-bit RC4 encryption available, which is cryptographically broken and unsuitable for protecting sensitive documents. For stronger encryption, upgrade to the premium Encryption module.

## 17. Table Generation

⚠️ **Table generation requires the premium Table module (not available in FREE version).**

The FREE version requires manual table creation using Cell() calls, similar to go-fpdf.

| Feature | go-fpdf | VNS PDF FREE | Status | Notes |
|---------|---------|--------------|--------|-------|
| High-level table API | ❌ | | 🔒 | **PREMIUM TABLE MODULE** |
| Table helper class | ❌ | | 🔒 | **PREMIUM TABLE MODULE** |
| Auto column sizing | ❌ | | 🔒 | **PREMIUM TABLE MODULE** |
| Auto header styling | ❌ | | 🔒 | **PREMIUM TABLE MODULE** |
| Auto alternating rows | ❌ | | 🔒 | **PREMIUM TABLE MODULE** |
| Auto page breaks | ❌ | | 🔒 | **PREMIUM TABLE MODULE** |

## 18. PDF Import (NEW in v1.0.0, extended in v1.4)

✅ **PDF Import is FULLY IMPLEMENTED - All phases complete (Example 20 working)**

ℹ️ **When the premium Zlib module is needed for import**: on **iOS and Android** (no system zlib), for streams stored as **raw DEFLATE** (no zlib header), and on **Windows when `ZLIB1.DLL` is not shipped** with the app. PNG/TIFF predictors are decoded in the FREE version.

| Feature | go-fpdf | VNS PDF FREE | Status | Notes |
|---------|---------|--------------|--------|-------|
| **File Parsing** | | | | |
| Open PDF file | ❌ | ✅ | ✅ | VNSPDFReader.OpenFile() |
| Parse cross-reference table | ❌ | ✅ | ✅ | VNSPDFXrefReader |
| Parse PDF objects | ❌ | ✅ | ✅ | 12 PDF type classes (VNSPDFType subclasses) |
| Navigate page tree | ❌ | ✅ | ✅ | Hierarchical page tree support |
| PDF 1.5+ xref & object streams | ❌ | ✅ | ✅ | Cross-reference streams and object streams (macOS Quartz, wkhtmltopdf, invoice tools) (v1.4) |
| Clone constructors | ❌ | New VNSPDFDocument(folderItem) / (pdfData, True) | ✅ | All pages imported at their original size (v1.4) |
| Imported page size | ❌ | GetImportedPageSize() | ✅ | Original dimensions of an imported template (v1.4) |
| Encrypted source PDFs | ❌ | | ❌ | Clear error since v1.4; decryption planned (RC4 FREE, AES premium) |
| **Page Extraction** | | | | |
| Get page count | ❌ | ✅ | ✅ | VNSPDFReader.GetPageCount() |
| Extract page | ❌ | ✅ | ✅ | VNSPDFReader.GetPage(pageNum) returns VNSPDFImportedPage |
| MediaBox inheritance | ❌ | ✅ | ✅ | Correct page dimensions from parent nodes |
| Extract resources | ❌ | ✅ | ✅ | Fonts, images, XObjects with dependency tracking |
| Extract contents | ❌ | ✅ | ✅ | Page content streams |
| **Stream Decompression** | | | | |
| FlateDecode (basic) | ❌ | ✅ | ✅ | Simple deflate/inflate via system libs (Desktop/Web/Console only) |
| FlateDecode with PNG/TIFF Predictors | ❌ | ✅ | ✅ | Predictor 2 and 10-15 decoded in FREE (system zlib on Desktop/Web/Console) |
| Raw DEFLATE / mobile Flate | ❌ | | 🔒 | **PREMIUM ZLIB MODULE REQUIRED** - pure Xojo inflate (iOS, Android, raw DEFLATE streams) |
| LZWDecode | ❌ | ✅ | ✅ | VNSPDFLZWDecoder for legacy PDFs |
| ASCII85Decode | ❌ | ✅ | ✅ | Base-85 decoding |
| ASCIIHexDecode | ❌ | ✅ | ✅ | Hexadecimal decoding |
| **Document Integration** | | | | |
| Import page as XObject | ❌ | ✅ | ✅ | VNSPDFDocument.ImportPage() |
| Use imported template | ❌ | ✅ | ✅ | VNSPDFDocument.UseTemplate() with scaling/positioning |
| Object ID remapping | ❌ | ✅ | ✅ | Automatic unique object numbering |
| Resource copying | ❌ | ✅ | ✅ | Fonts, images, XObjects copied with dependencies |
| Nested XObject support | ❌ | ✅ | ✅ | Pages referencing other XObjects work correctly |

**Current Status (ALL PHASES COMPLETE):**
- ✅ Can open and parse PDF files with full xref table support
- ✅ Can extract page count and page information with MediaBox inheritance
- ✅ Stream decompression working (FlateDecode basic, LZWDecode, ASCII85Decode, ASCIIHexDecode)
- ✅ Full integration with VNSPDFDocument via ImportPage() and UseTemplate()
- ✅ Example 20 demonstrates 4-page PDF import with 2x2 miniature grid
- ✅ PNG/TIFF predictors decoded in FREE; premium Zlib only for mobile, raw DEFLATE, or Windows without `ZLIB1.DLL`
- ❌ Encrypted source PDFs: clear error (decryption planned)

**Platform-Specific File Selection (Example 20):**
- **Desktop**: Multi-location search for `pdf_examples/example12_custom_formats.pdf`
  - Searches: CurrentWorkingDirectory, App.ExecutableFile.Parent, parent folders
  - Falls back to OpenDialog if not found
- **Console**: Same multi-location search as Desktop
  - Uses default path if file exists, shows error if missing
- **iOS**: Documents folder enumeration via `FindPDFInDocuments()`
  - Looks for "import.pdf" (preferred filename)
  - Falls back to first .pdf file found in Documents folder
  - Shows instructions for File Sharing if no PDF found
  - Users place PDF files via macOS Finder (File Sharing enabled in project)
- **Web**: PDF upload dialog via WebDialogPDFUpload
  - User must upload PDF file from browser
  - Temporary file path passed to GenerateExample20()
- **Result Dictionary**: All platforms return `result.Value("pdf") = pdfBytes` for display

**When Premium Zlib is Required for Import:**
- **iOS and Android**: no system zlib can be called from a sandboxed mobile app, so every FlateDecode stream needs the pure Xojo inflater
- **Raw DEFLATE streams** (no zlib header, produced by some generators): the system zlib rejects them; the premium module decodes them
- **Windows without `ZLIB1.DLL`**: Windows ships no zlib; place `ZLIB1.DLL` next to the app (free) or use the premium module
- PNG/TIFF predictor reversal (Predictors 2, 10-15) is part of the FREE decoder

## 19. Error Handling & Debugging

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Check OK | Ok() | Ok() | ✅ | Returns true if no error |
| Check error | Err() | Err() | ✅ | Returns true if error |
| Get error | Error() | GetError() | ✅ | Different name |
| Set error | SetError() | SetError() | ✅ | First error wins |
| Set error formatted | SetErrorf() | SetErrorf() | ✅ | Printf-style formatting (%s, %d, %f) |
| Clear error | ClearError() | ClearError() | ✅ | Resets error state |
| Bounds checking | N/A | CheckBounds() | ✅ | Warns when drawing outside page bounds |
| Raise on out-of-bounds | N/A | gkRaiseExceptionOnOutOfBounds | ✅ | Optional exception on bounds violation |

**Bounds Checking:**
- `CheckBounds()` is called internally by drawing methods (Rect, Line, Ellipse, Image, Text, Cell, MultiCell, AddTextAnnotation, AddAttachmentAnnotation)
- Logs warning to console via `System.DebugLog` when content is placed outside page dimensions
- Set `VNSPDFModule.gkRaiseExceptionOnOutOfBounds = True` to raise `RuntimeException` instead of just logging

## 20. Utilities

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Get conversion ratio | GetConversionRatio() | GetConversionRatio() | ✅ | Returns scale factor |
| Get page size string | GetPageSizeStr() | GetPageSizeStr() | ✅ | Parses size strings |
| Close document | Close() | Close() | ✅ | Validates clip nesting |
| String representation | String() | GetVersionString() | ✅ | Returns version string |
| Raw write string | RawWriteStr() | RawWriteStr() | ✅ | Write raw PDF commands |
| JSON serialization | N/A | ToJSON() | ✅ | Serialize document state |
| JSON deserialization | N/A | FromJSON() | ✅ | Deserialize document state |

## 21. PDFGraphics Compatibility Wrapper (NEW in v1.0.0)

✅ **VNSPDFGraphicsUTF - Full Xojo PDFGraphics API Compatibility**

The VNSPDFGraphicsUTF wrapper class provides a drop-in replacement for Xojo's native PDFGraphics class, allowing the same code to work with both VNS PDF and Xojo's built-in PDF generation.

| Feature | Xojo PDFGraphics | VNSPDFGraphicsUTF | Status | Notes |
|---------|-----------------|-------------------|--------|-------|
| **Properties** | | | | |
| Bold, Italic, Underline | ✅ | ✅ | ✅ | Font styling |
| FontName, FontSize | ✅ | ✅ | ✅ | Font properties |
| DrawingColor | ✅ | ✅ | ✅ | Sets draw, fill, text color |
| PenSize | ✅ | ✅ | ✅ | Line width |
| LineCap, LineJoin | ✅ | ✅ | ✅ | Uses Xojo's Graphics.LineCapTypes/LineJoinTypes enums! |
| LineDash | ✅ | ✅ | ✅ | Identical syntax: `= Array(...)` or `= Nil` |
| CharacterSpacing | ✅ | ✅ | ✅ | Letter spacing |
| Width, Height | ✅ | ✅ | ✅ | Page dimensions (read-only) |
| **Drawing Methods** | | | | |
| DrawLine | ✅ | ✅ | ✅ | Line drawing |
| DrawRectangle, FillRectangle | ✅ | ✅ | ✅ | Rectangle drawing |
| DrawOval, FillOval | ✅ | ✅ | ✅ | Ellipse drawing |
| DrawRoundRectangle, FillRoundRectangle | ✅ | ✅ | ✅ | Rounded rectangles |
| DrawPolygon, FillPolygon | ✅ | ✅ | ✅ | Polygon drawing |
| DrawPath, FillPath | ✅ | ✅ | ✅ | GraphicsPath support with autoClose parameter |
| DrawPicture | ✅ | ✅ | ✅ | Image rendering |
| **Text Methods** | | | | |
| DrawText | ✅ | ✅ | ✅ | With rotation support |
| DrawTextBlock | ✅ | ✅ | ✅ | Word-wrap, alignment, CJK support |
| TextWidth, TextHeight | ✅ | ✅ | ✅ | Text measurement |
| TextBlockSize | ✅ | ✅ | ✅ | Block size calculation |
| **Object2D Support** | | | | |
| DrawObject (RectShape) | ✅ | ✅ | ✅ | With rotation via Transform |
| DrawObject (OvalShape) | ✅ | ✅ | ✅ | Correct bounding box |
| DrawObject (RoundRectShape) | ✅ | ✅ | ✅ | Correct corner radius |
| DrawObject (ArcShape) | ✅ | ✅ | ✅ | Arc rendering |
| DrawObject (CurveShape) | ✅ | ✅ | ✅ | Bezier curves |
| DrawObject (FigureShape) | ✅ | ✅ | ✅ | Complex paths |
| DrawObject (TextShape) | ✅ | ✅ | ✅ | With HorizontalAlignment |
| DrawObject (PixmapShape) | ✅ | ✅ | ✅ | Image shapes |
| DrawObject (Group2D) | ✅ | ✅ | ✅ | With rotation support |
| **Transformations** | | | | |
| Rotate | ✅ | ✅ | ✅ | Both angle and angle+point variants |
| Translate | ✅ | ✅ | ✅ | Position offset |
| Scale | ✅ | ✅ | ✅ | Size scaling |
| Transform | ✅ | ✅ | ✅ | Raw matrix |
| **State Management** | | | | |
| SaveState, RestoreState | ✅ | ✅ | ✅ | Graphics state stack |
| ResetState | ✅ | ✅ | ✅ | Reset to defaults |
| **Clipping** | | | | |
| Clip, ClipToRectangle | ✅ | ✅ | ✅ | Rectangular clipping |
| ClipToPath | ✅ | ✅ | ✅ | Path-based clipping |
| ClipEnd | ✅ | ✅ | ✅ | End clipping region |
| **Navigation** | | | | |
| NextPage | ✅ | ✅ | ✅ | Add page with optional dimensions |
| **Extensions (VNS Only)** | | | | |
| AddAnnotation | N/A | ✅ | ✅ | Text annotations (sticky notes) |
| AddEmbeddedFile | N/A | ✅ | ✅ | Document-level attachments |
| AddAttachmentAnnotation | N/A | ✅ | ✅ | Page annotation attachments |
| Full UTF-8/Unicode | Limited | ✅ | ✅ | Arabic, Chinese, Japanese, Korean |

**Implementation Notes:**
- RectShape rotation uses Xojo's Transform approach (transform to position, draw at origin)
- Group2D children have pre-calculated rotated positions - no group-wide transform needed
- TextShape respects HorizontalAlignment (Left/Center/Right)
- OvalShape X,Y interpreted as top-left of bounding box
- RoundRectShape corner radius divided by 4 to match Xojo
- BorderWidth scaled by 0.5 to match Xojo PDFGraphics rendering

**Usage Example:**
```xojo
// Same code works with both Xojo PDFGraphics and VNSPDFGraphicsUTF
Dim g As Graphics  // or VNSPDFGraphicsUTF
g.DrawingColor = Color.Blue
g.FillRectangle(100, 100, 200, 50)
g.DrawText("Hello World", 100, 200)
g.DrawObject(myRectShape, 0, 0)

// Line styling - IDENTICAL syntax!
g.LineCap = Graphics.LineCapTypes.Round
g.LineJoin = Graphics.LineJoinTypes.Bevel
g.LineDash = Array(5.0, 5.0)  // Dashed line
g.LineDash = Nil              // Reset to solid
```

---

## Summary Statistics (FREE VERSION)

### Overall Implementation Status

| Category | Total Features | Implemented | Partial | Premium Only | Not Implemented | % Complete |
|----------|---------------|-------------|---------|--------------|-----------------|-----------|
| Document Setup | 15 | 14 | 0 | 1 | 0 | 93.3% |
| Page Management | 13 | 13 | 0 | 0 | 0 | 100.0% |
| Margins & Position | 15 | 15 | 0 | 0 | 0 | 100.0% |
| Fonts & Text | 29 | 25 | 0 | 0 | 4 | 86.2% |
| Text Output | 11 | 11 | 0 | 0 | 0 | 100.0% |
| Graphics Primitives | 13 | 13 | 0 | 0 | 0 | 100.0% |
| Colors & Graphics | 14 | 14 | 0 | 0 | 0 | 100.0% |
| Transformations | 18 | 18 | 0 | 0 | 0 | 100.0% |
| Gradients | 4 | 4 | 0 | 0 | 0 | 100.0% |
| Clipping | 8 | 8 | 0 | 0 | 0 | 100.0% |
| Images | 9 | 9 | 0 | 0 | 0 | 100.0% |
| Links & Bookmarks | 6 | 6 | 0 | 0 | 0 | 100.0% |
| Headers & Footers | 11 | 11 | 0 | 0 | 0 | 100.0% |
| Templates | 4 | 0 | 0 | 0 | 4 | 0.0% |
| Output & Display | 5 | 3 | 1 | 0 | 1 | 80.0% |
| Security | 40 | 16 | 0 | 24 | 0 | 40.0% |
| Table Generation | 6 | 0 | 0 | 6 | 0 | 0.0% |
| PDF Import | 24 | 22 | 0 | 1 | 1 | 91.7% |
| Error Handling | 6 | 5 | 0 | 0 | 1 | 83.3% |
| Utilities | 7 | 7 | 0 | 0 | 0 | 100.0% |
| PDFGraphics Wrapper | 41 | 41 | 0 | 0 | 0 | 100.0% |
| **TOTAL** | **299** | **255** | **1** | **32** | **12** | **85.3%** |

### Completion Summary (Excluding Premium Features)
- **Fully Implemented:** 95.5% (255/267 non-premium features)
- **Partially Implemented:** 0.4% (1/267)
- **Not Implemented:** 4.5% (12/267)
- **Premium Only:** 32 features require premium modules

---

## Upgrade to Premium for:

- 🔒 **Complete Encryption Suite** - RC4-128, AES-128, AES-256 (Revisions 2-6, Algorithm 2.B) - **ALL FULLY WORKING**
- 🔒 **PDF/A Output Intents** - ICC color profiles for archival compliance - **MINIMAL (5-10% complete, no validation)**
- 🔒 **Table Generation** - High-level automatic table API (premium Table module) - **FULLY WORKING**
- 🔒 **iOS / Android Compression** - Pure Xojo zlib implementation (premium Zlib module - **FULLY WORKING**)
- 🔒 **E-Invoice Generation** - Factur-X/ZUGFeRD hybrid PDF/XML invoices, EN 16931 compliance, 3-level validation, barcodes - **FULLY WORKING**
- 🔒 **HTML / Markdown Import** - `LoadHTML()` / `LoadMarkdown()` with CSS engine - **FULLY WORKING**

**💡 Each premium module can be purchased separately** - You only pay for the features you need! Buy individual modules (Encryption, Table, Zlib, PDF/A, E-Invoice, HTML/Markdown) based on your specific requirements.

See `FEATURE_COMPARISON_PREMIUM.md` for complete premium feature list.

---

*Last Updated: 2026-10-02*
*VNS PDF FREE Version 1.4 - Desktop | Web | iOS | Console | Android*
