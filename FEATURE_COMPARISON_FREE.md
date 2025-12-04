# go-fpdf vs VNS PDF FREE Version - Feature Comparison

**Last Updated:** 2025-11-28
**VNS PDF Version:** 1.0.0 FREE (No Premium Modules)
**go-fpdf Reference:** v2.0+

---

## ⚠️ FREE VERSION LIMITATIONS

This document compares the **FREE version** of VNS PDF against go-fpdf. The FREE version does NOT include premium modules:

**What's NOT Available in FREE:**
- ❌ **RC4-128 encryption** (128-bit) - Requires premium Encryption module
- ❌ **AES encryption** (128/256-bit) - Requires premium Encryption module
- ❌ **PDF/A output intents** - Requires premium PDF/A module
- ❌ **iOS compression** - Blocked in FREE version, requires premium Zlib module for pure Xojo implementation
- ✅ **iOS compression with Premium** - Pure Xojo zlib implementation works on all platforms including iOS
- ❌ **Table generation** - Requires premium Table module - **FULLY WORKING in Premium**
- ❌ **E-Invoice generation** - Requires premium E-Invoice module - **PLANNED** (Factur-X, ZUGFeRD, EN 16931)

**What IS Available in FREE:**
- ✅ **RC4-40 encryption** (40-bit) - DEPRECATED and WEAK, but available
- ✅ All core PDF features (text, graphics, images, fonts, links, etc.)
- ✅ Basic compression (FlateDecode/zlib on Desktop/Web/Console only; **iOS blocked**)
- ✅ Full Unicode/TrueType font support
- ✅ Document metadata, headers/footers, bookmarks

For premium features, see `FEATURE_COMPARISON_PREMIUM.md`.

**💡 Premium Modules Can Be Purchased Separately** - You don't need to buy all premium modules! Purchase only what you need:
- 🔐 **Encryption Module** - RC4-128, AES-128, AES-256 encryption *(Ready)*
- 📊 **Table Module** - Professional table generation with headers, footers, pagination *(Ready)*
- 🗜️ **Zlib Module** - Pure Xojo compression for iOS support *(Ready)*
- 🔮 **PDF/A Module** - Archival compliance and ICC profiles *(Planned)*
- 🧾 **E-Invoice Module** - Factur-X/ZUGFeRD hybrid PDF/XML invoices, EN 16931 compliance *(Planned)*

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
| Set producer | SetProducer() | | ⚠️ | Auto-set in Constructor |
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
| Get XY position | GetXY() | | ⚠️ | Separate GetX/GetY |
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
| LTR text | LTR() | LTR() | ✅ | Enable left-to-right text direction (default) |
| Arabic text shaping | | ShapeArabicText() | ✅ | Automatic contextual forms (isolated, initial, medial, final) with RTL reversal |

## 5. Text Output

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Simple text | Text() | Text() | ✅ | |
| Cell | Cell() | Cell() | ✅ | Full border support, fill, alignment |
| Cell with format | CellFormat() | | ⚠️ | Part of Cell() |
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
| Cubic curve | CurveCubic() | | 🔄 | Use CurveBezierCubic() instead |
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

## 8. Gradients

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Linear gradient | LinearGradient() | LinearGradient() | ✅ | Full PDF shading patterns |
| Radial gradient | RadialGradient() | RadialGradient() | ✅ | Dual-circle radial gradients |

## 9. Clipping

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

## 10. Images

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Add image | Image() | Image() | ✅ | JPEG (DCTDecode) and PNG (FlateDecode) - All platforms ✅ |
| Image from Picture | | ImageFromPicture() | ✅ | Embed Xojo Picture objects - **Desktop: PNG, iOS: JPEG** |
| Image with options | ImageOptions() | | ❌ | Not implemented |
| Register image | RegisterImage() | RegisterImage() | ✅ | Pre-register images for reuse |
| Register from bytes | RegisterImageFromBytes() | RegisterImageFromBytes() | ✅ | Register from MemoryBlock (PNG/JPEG) |
| Register image options | RegisterImageOptions() | | ❌ | Not implemented |
| Register from reader | RegisterImageReader() | | ❌ | Not implemented |
| Register with options | RegisterImageOptionsReader() | | ❌ | Not implemented |
| Get image info | GetImageInfo() | | ✅ | Via VNSPDFImage class methods |
| Image type from MIME | ImageTypeFromMime() | ImageTypeFromMime() | ✅ | Converts MIME strings to types |
| Color emoji | | Emoji() | ⚠️ | Desktop ✅, iOS ✅ (UIKit), **Web ❌ (not yet implemented - see docs/EMOJI_FONT_PARSING.md)**, Console ❌ |

**iOS Image Support Notes**:
- ✅ **All image features working on iOS** - Fixed RGBA→RGB conversion issue
- iOS uses JPEG format internally for `ImageFromPicture()` to avoid alpha channel issues
- Bundled images: Use `SpecialFolder.Resource(filename)` + `Picture.Open()`
- Charts: Use `chart.ToPicture()` + `ImageFromPicture()` - works correctly on iOS
- JPEG format automatically strips alpha channel (RGBA→RGB conversion)
- ✅ **Color emoji rendering working on iOS** - Uses native UIKit (UILabel + Apple Color Emoji font)
- Emoji rendered to UIImage, converted to PNG data, then to Picture via `Picture.FromData()`
- Proper memory management: UIImage→PNG NSData→MemoryBlock→Picture (avoids ARC issues)

**iOS Font Loading Notes**:
- ✅ **TrueType font parsing working on iOS** - Fixed MemoryBlock.StringValue() crash
- iOS crashes when using `MemoryBlock.StringValue(position, length)` on large buffers (>20MB) at high offsets
- Solution: Byte-by-byte extraction using `UInt8Value()` for ASCII strings and `UInt16Value()` for UTF-16BE strings
- Performance impact: Negligible (only 42 bytes total extracted for font name parsing)
- Successfully loads 23MB font files (Arial Unicode) with 98% subsetting reduction

## 11. Links & Bookmarks

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Add link | AddLink() | AddLink() | ✅ | Returns linkID for internal links |
| Set link | SetLink() | SetLink() | ✅ | Define link destination |
| Link area | Link() | Link() | ✅ | Create clickable area for internal links |
| Link string | LinkString() | LinkString() | ✅ | Create clickable area for external URLs |
| Bookmark | Bookmark() | Bookmark() | ✅ | Hierarchical outline/sidebar navigation |
| Alias nb pages | AliasNbPages() | AliasNbPages() | ✅ | Text substitution for page count |

## 12. Headers & Footers

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Set header function | SetHeaderFunc() | SetHeaderFunc() | ✅ | VNSPDFModule.HeaderFooterDelegate |
| Set header with mode | SetHeaderFuncMode() | SetHeaderFuncMode() | ✅ | With homeMode to reset X/Y |
| Set footer function | SetFooterFunc() | SetFooterFunc() | ✅ | VNSPDFModule.HeaderFooterDelegate |
| Set footer with LPI | SetFooterFuncLpi() | SetFooterFuncLpi() | ✅ | With lastPage indicator |
| Accept page break func | SetAcceptPageBreakFunc() | SetAcceptPageBreakFunc() | ✅ | Custom page break logic callback |
| Get page number | PageNo() | PageNo() | ✅ | For use in callbacks |
| Get font family | | FontFamily() | ✅ | For state management in callbacks |
| Get font style | | FontStyle() | ✅ | For state management in callbacks |
| Get font size | | FontSizePt() | ✅ | For state management in callbacks |

## 13. Templates & Objects

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Import objects | ImportObjects() | | ❌ | Not implemented |
| Import object positions | ImportObjPos() | | ❌ | Not implemented |
| Use imported template | UseImportedTemplate() | | ❌ | Not implemented |
| Import templates | ImportTemplates() | | ❌ | Not implemented |

## 14. Output & Display

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Output to writer | Output() | Output() | ✅ | Returns string |
| Output and close | OutputAndClose() | | ❌ | Not implemented |
| Output file and close | OutputFileAndClose() | | ⚠️ | SaveToFile() |
| Display mode | SetDisplayMode() | | ❌ | Not implemented |
| Get display mode | GetDisplayMode() | | ❌ | Not implemented |

## 15. Security & Encryption (FREE VERSION)

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

## 16. Table Generation

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

## 17. PDF Import (NEW in v1.0.0)

✅ **PDF Import is FULLY IMPLEMENTED - All phases complete (Example 20 working)**

⚠️ **IMPORTANT: Most PDFs require premium Zlib module for import** - PDFs using FlateDecode with PNG predictors (very common) need advanced decompression that only the premium zlib module provides.

| Feature | go-fpdf | VNS PDF FREE | Status | Notes |
|---------|---------|--------------|--------|-------|
| **File Parsing** | | | | |
| Open PDF file | ❌ | ✅ | ✅ | VNSPDFReader.OpenFile() |
| Parse cross-reference table | ❌ | ✅ | ✅ | VNSPDFXrefReader |
| Parse PDF objects | ❌ | ✅ | ✅ | 12 PDF type classes (VNSPDFType subclasses) |
| Navigate page tree | ❌ | ✅ | ✅ | Hierarchical page tree support |
| **Page Extraction** | | | | |
| Get page count | ❌ | ✅ | ✅ | VNSPDFReader.GetPageCount() |
| Extract page | ❌ | ✅ | ✅ | VNSPDFReader.GetPage(pageNum) returns VNSPDFImportedPage |
| MediaBox inheritance | ❌ | ✅ | ✅ | Correct page dimensions from parent nodes |
| Extract resources | ❌ | ✅ | ✅ | Fonts, images, XObjects with dependency tracking |
| Extract contents | ❌ | ✅ | ✅ | Page content streams |
| **Stream Decompression** | | | | |
| FlateDecode (basic) | ❌ | ✅ | ✅ | Simple deflate/inflate via system libs (Desktop/Web/Console only) |
| FlateDecode with PNG Predictors | ❌ | | 🔒 | **PREMIUM ZLIB MODULE REQUIRED** - Predictor 2, 10-15 support |
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
- ⚠️ **Most PDFs need premium Zlib** - PDFs with FlateDecode+Predictors require premium module

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

**Why Premium Zlib is Often Required:**
- Most modern PDFs use **FlateDecode with PNG Predictors** (Predictor 15) for images and large content streams
- FREE version only supports basic FlateDecode (simple deflate without predictors)
- Premium zlib module adds **PNG Predictor reversal** (Predictors 2, 10-15) needed for advanced compression
- Without premium zlib: Can parse PDF structure but **cannot decompress predictor-encoded streams**
- Example: `/Filter /FlateDecode /DecodeParms << /Predictor 15 /Colors 3 /Columns 1859 >>` requires premium

## 18. Error Handling

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Check OK | Ok() | Ok() | ✅ | Returns true if no error |
| Check error | Err() | Err() | ✅ | Returns true if error |
| Get error | Error() | GetError() | ✅ | Different name |
| Set error | SetError() | SetError() | ✅ | First error wins |
| Set error formatted | SetErrorf() | | ❌ | Not implemented |
| Clear error | ClearError() | ClearError() | ✅ | Resets error state |

## 19. Utilities

| Feature | go-fpdf Method | VNS PDF FREE | Status | Notes |
|---------|---------------|--------------|--------|-------|
| Get conversion ratio | GetConversionRatio() | GetConversionRatio() | ✅ | Returns scale factor |
| Get page size string | GetPageSizeStr() | GetPageSizeStr() | ✅ | Parses size strings |
| Close document | Close() | Close() | ✅ | Validates clip nesting |
| String representation | String() | GetVersionString() | ✅ | Returns version string |
| Raw write string | RawWriteStr() | RawWriteStr() | ✅ | Write raw PDF commands |
| JSON serialization | N/A | ToJSON() | ✅ | Serialize document state |
| JSON deserialization | N/A | FromJSON() | ✅ | Deserialize document state |

---

## Summary Statistics (FREE VERSION)

### Overall Implementation Status

| Category | Total Features | Implemented | Partial | Premium Only | Not Implemented | % Complete |
|----------|---------------|-------------|---------|--------------|-----------------|-----------|
| Document Setup | 15 | 13 | 1 | 1 | 0 | 86.7% |
| Page Management | 10 | 10 | 0 | 0 | 0 | 100.0% |
| Margins & Position | 15 | 14 | 1 | 0 | 0 | 93.3% |
| Fonts & Text | 28 | 24 | 0 | 0 | 4 | 85.7% |
| Text Output | 11 | 10 | 0 | 0 | 1 | 90.9% |
| Graphics Primitives | 13 | 12 | 0 | 0 | 1 | 92.3% |
| Colors & Graphics | 14 | 14 | 0 | 0 | 0 | 100.0% |
| Gradients | 2 | 2 | 0 | 0 | 0 | 100.0% |
| Clipping | 8 | 8 | 0 | 0 | 0 | 100.0% |
| Images | 9 | 5 | 0 | 0 | 4 | 55.6% |
| Links & Bookmarks | 6 | 6 | 0 | 0 | 0 | 100.0% |
| Headers & Footers | 9 | 9 | 0 | 0 | 0 | 100.0% |
| Templates | 4 | 0 | 0 | 0 | 4 | 0.0% |
| Output & Display | 5 | 1 | 1 | 0 | 3 | 40.0% |
| Security | 40 | 16 | 0 | 24 | 0 | 40.0% |
| Table Generation | 6 | 0 | 0 | 6 | 0 | 0.0% |
| PDF Import | 19 | 18 | 0 | 1 | 0 | 94.7% |
| Error Handling | 6 | 5 | 0 | 0 | 1 | 83.3% |
| Utilities | 7 | 7 | 0 | 0 | 0 | 100.0% |
| **TOTAL** | **227** | **174** | **3** | **32** | **19** | **76.7%** |

### Completion Summary (Excluding Premium Features)
- **Fully Implemented:** 89.2% (174/195 non-premium features)
- **Partially Implemented:** 1.5% (3/195)
- **Not Implemented:** 9.2% (18/195)
- **Premium Only:** 32 features require premium modules

---

## Upgrade to Premium for:

- 🔒 **Complete Encryption Suite** - RC4-128, AES-128, AES-256 (Revisions 2-6, Algorithm 2.B) - **ALL FULLY WORKING**
- 🔒 **PDF/A Output Intents** - ICC color profiles for archival compliance - **MINIMAL (5-10% complete, no validation)**
- 🔒 **Table Generation** - High-level automatic table API (premium Table module) - **FULLY WORKING**
- 🔒 **iOS Compression** - Pure Xojo zlib implementation (premium Zlib module - **FULLY WORKING**)
- 🔒 **E-Invoice Generation** - Factur-X/ZUGFeRD hybrid PDF/XML invoices, EN 16931 compliance - **PLANNED**

**💡 Each premium module can be purchased separately** - You only pay for the features you need! Buy individual modules (Encryption, Table, Zlib, PDF/A, E-Invoice) based on your specific requirements.

See `FEATURE_COMPARISON_PREMIUM.md` for complete premium feature list.

---

*Last Updated: 2025-11-28*
*VNS PDF FREE Version 1.0.0*
