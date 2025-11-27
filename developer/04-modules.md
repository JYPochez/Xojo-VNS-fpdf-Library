# Modules

## Table of Contents

- [VNSPDFModule](#vnspdfmodule)
  - [Global Constants](#global-constants)
    - [Page Format Dimensions](#page-format-dimensions)
    - [Unit Conversion Factors](#unit-conversion-factors)
  - [Utility Methods](#utility-methods)
    - [GetPageFormatDimensions](#getpageformatdimensions)
    - [ConvertToPoints](#converttopoints)
    - [ConvertFromPoints](#convertfrompoints)
- [Graphics State Classes](#graphics-state-classes)
  - [VNSPDFBlendMode](#vnspdfblendmode)
    - [Properties](#properties)
    - [Usage](#usage)
- [Media Classes](#media-classes)
  - [VNSPDFImage](#vnspdfimage)
    - [Constructor](#constructor)
    - [Methods](#methods)

---

## VNSPDFModule

**Location**: `PDF_Library/VNSPDFModule.xojo_code`

Global module containing constants, enumerations, and utility functions.

### Global Constants

#### Page Format Dimensions

```xojo
Const gkA3Width As Double = 297    // mm
Const gkA3Height As Double = 420   // mm
Const gkA4Width As Double = 210    // mm
Const gkA4Height As Double = 297   // mm
Const gkA5Width As Double = 148    // mm
Const gkA5Height As Double = 210   // mm
Const gkLetterWidth As Double = 8.5    // inches
Const gkLetterHeight As Double = 11    // inches
Const gkLegalWidth As Double = 8.5     // inches
Const gkLegalHeight As Double = 14     // inches
```

#### Unit Conversion Factors

```xojo
Const gkPointsPerInch As Double = 72.0
Const gkMillimetersPerInch As Double = 25.4
Const gkCentimetersPerInch As Double = 2.54
```

### Utility Methods

#### GetPageFormatDimensions
```xojo
Function GetPageFormatDimensions(format As ePageFormat) As Pair
```

**Parameters**:
- `format` - Page format enum value

**Returns**: Pair with X (width) and Y (height) in the format's native units

**Description**: Returns the dimensions for standard page formats.

**Example**:
```xojo
Dim dimensions As Pair = VNSPDFModule.GetPageFormatDimensions(VNSPDFModule.ePageFormat.A4)
Dim width As Double = dimensions.Left   // 210 mm
Dim height As Double = dimensions.Right  // 297 mm
```

#### ConvertToPoints
```xojo
Function ConvertToPoints(value As Double, unit As ePageUnit) As Double
```

**Parameters**:
- `value` - Value to convert
- `unit` - Source unit

**Returns**: Value converted to points (1/72 inch)

**Description**: Converts from any supported unit to PDF points.

**Example**:
```xojo
Dim mmValue As Double = 210  // A4 width in mm
Dim pointsValue As Double = VNSPDFModule.ConvertToPoints(mmValue, VNSPDFModule.ePageUnit.Millimeters)
// Result: ~595.28 points
```

#### ConvertFromPoints
```xojo
Function ConvertFromPoints(points As Double, unit As ePageUnit) As Double
```

**Parameters**:
- `points` - Value in points
- `unit` - Target unit

**Returns**: Value converted to specified unit

**Description**: Converts from PDF points to any supported unit.

**Example**:
```xojo
Dim points As Double = 595.28
Dim mm As Double = VNSPDFModule.ConvertFromPoints(points, VNSPDFModule.ePageUnit.Millimeters)
// Result: ~210 mm
```

## Graphics State Classes

### VNSPDFBlendMode

**Location**: `PDF_Library/Core/VNSPDFBlendMode.xojo_code`

Data structure for managing transparency and blend mode graphics state objects in PDF documents.

#### Properties

##### fillStr (Public)
```xojo
Public fillStr As String
```

Alpha value for fill operations as formatted PDF string (e.g., "0.5" for 50% opacity).

##### strokeStr (Public)
```xojo
Public strokeStr As String
```

Alpha value for stroke operations as formatted PDF string.

##### modeStr (Public)
```xojo
Public modeStr As String
```

Blend mode name (e.g., "Normal", "Multiply", "Screen", "Overlay").

##### objNum (Public)
```xojo
Public objNum As Integer = 0
```

PDF object number for this ExtGState resource. Used for referencing in page resources.

#### Usage

This class is used internally by VNSPDFDocument to manage transparency states. Users typically don't interact with this class directly - instead, use the `SetAlpha()` method on VNSPDFDocument.

**Internal Example** (from VNSPDFDocument):
```xojo
Dim bl As New VNSPDFBlendMode
bl.fillStr = "0.7"
bl.strokeStr = "0.7"
bl.modeStr = "Multiply"
bl.objNum = 15  // Assigned during PDF object creation

// Later used to generate PDF ExtGState dictionary:
// 15 0 obj
// <</Type /ExtGState /ca 0.7 /CA 0.7 /BM /Multiply>>
// endobj
```

**Notes**:
- Each unique combination of alpha and blend mode creates one VNSPDFBlendMode instance
- Instances are reused when same transparency/blend combination is requested
- PDF 1.4+ required for transparency support

## Media Classes

### VNSPDFImage

**Location**: `PDF_Library/Media/VNSPDFImage.xojo_code`

Image parser and metadata extractor for JPEG and PNG files.

#### Constructor

```xojo
Sub Constructor(imageFilePath As String)
```

**Parameters**:
- `imageFilePath` - Path to JPEG or PNG image file

**Description**: Loads and parses an image file, extracting dimensions, color space, and format information.

**Example**:
```xojo
Dim img As New VNSPDFImage("/path/to/photo.jpg")

If img.IsValid() Then
    Dim width As Integer = img.GetWidth()
    Dim height As Integer = img.GetHeight()
Else
    MsgBox "Image error: " + img.GetError()
End If
```

#### Methods

##### IsValid
```xojo
Function IsValid() As Boolean
```

**Returns**: True if image was loaded and parsed successfully

##### GetWidth
```xojo
Function GetWidth() As Integer
```

**Returns**: Image width in pixels

##### GetHeight
```xojo
Function GetHeight() As Integer
```

**Returns**: Image height in pixels

##### GetImageType
```xojo
Function GetImageType() As String
```

**Returns**: Image type ("jpeg" or "png")

##### GetColorSpace
```xojo
Function GetColorSpace() As String
```

**Returns**: PDF color space ("DeviceRGB", "DeviceGray", "DeviceCMYK")

##### GetBitsPerComponent
```xojo
Function GetBitsPerComponent() As Integer
```

**Returns**: Bits per color component (typically 8)

##### GetImageData
```xojo
Function GetImageData() As String
```

**Returns**: Raw image data as binary string

##### GetError
```xojo
Function GetError() As String
```

**Returns**: Error message if image loading failed, empty string otherwise

**Notes**:
- Automatically detects image format from file signature
- Supports JPEG (baseline, progressive)
- Supports PNG (non-interlaced, most color types)
- PNG alpha channel and indexed color supported
- CMYK JPEG images supported

---

## Premium Modules

**Location**: `PDF_Library/Premium/`

Premium modules extend the FREE version with advanced features that require a separate license.

### Module Overview

| Module | File | Status | Description |
|--------|------|--------|-------------|
| **Encryption** | VNSPDFEncryptionPremium.xojo_code | ✅ Partial | RC4-128 (✅ working), AES (🔨 stubs) |
| **PDF/A** | VNSPDFPDFAPremium.xojo_code | ✅ Complete | Output Intent + ICC profiles |
| **Zlib** | VNSPDFZlibPremium.xojo_code | 🔨 Planned | iOS compression support |
| **Table** | VNSPDFTablePremium.xojo_code | 🔨 Planned | High-level table API |

### Module Flags

Premium module availability is controlled by Boolean constants in `VNSPDFModule.xojo_code`:

```xojo
// Module availability flags (lines 806-815)
Public Const hasPremiumEncryptionModule As Boolean = False  // RC4-128 + AES
Public Const hasPremiumPDFAModule As Boolean = False        // PDF/A output intents
Public Const hasPremiumZlibModule As Boolean = False        // iOS compression
Public Const hasPremiumTableModule As Boolean = False       // Table generation
```

To enable a premium module:
1. Purchase the module license
2. Add the premium module file to your project
3. Set the corresponding flag to `True`
4. Rebuild your project

### VNSPDFEncryptionPremium

**Module Flag**: `hasPremiumEncryptionModule`

Provides enhanced encryption beyond the FREE version's RC4-40:

**Features**:
- ✅ **RC4-128 encryption** - 128-bit RC4 with 50-iteration key derivation (fully working)
- 🔨 **AES-128 encryption** - 128-bit AES-CBC (stub ready, needs implementation)
- 🔨 **AES-256 encryption** - 256-bit AES-CBC (stub ready, needs implementation)

**Usage Example**:
```xojo
If VNSPDFModule.hasPremiumEncryptionModule Then
    // Use RC4-128 (premium)
    pdf.SetProtection("user", "owner", True, True, True, True, _
                      VNSPDFModule.gkEncryptionRC4_128)
Else
    // Fallback to RC4-40 (free)
    pdf.SetProtection("user", "owner", True, True, True, True, _
                      VNSPDFModule.gkEncryptionRC4_40)
End If
```

### VNSPDFPDFAPremium

**Module Flag**: `hasPremiumPDFAModule`

Provides PDF/A archival compliance features:

**Features**:
- ✅ **Output Intent** - Specify color reproduction characteristics
- ✅ **ICC Color Profiles** - Embed color profiles for consistency
- ✅ **Automatic sRGB Detection** - Finds system color profiles (macOS)

**Usage Example**:
```xojo
If VNSPDFModule.hasPremiumPDFAModule Then
    // Load ICC profile
    Dim iccProfile As MemoryBlock = LoadICCProfile()

    // Add output intent for PDF/A
    pdf.AddOutputIntent(VNSPDFModule.gkOutputIntentPDFA1, _
                        "sRGB IEC61966-2.1", _
                        "sRGB color space", _
                        iccProfile)
End If
```

### VNSPDFZlibPremium (Planned)

**Module Flag**: `hasPremiumZlibModule`

Will provide pure Xojo zlib compression for iOS support:

**Planned Features**:
- 🔨 **iOS compression** - Pure Xojo DEFLATE implementation
- 🔨 **Custom compression levels** - Balance speed vs size (1-9)
- 🔨 **Compression statistics** - Track compression ratios

**Current Status**: Structure ready, estimated 33-42 hours for implementation

### VNSPDFTablePremium (Planned)

**Module Flag**: `hasPremiumTableModule`

Will provide high-level declarative table API:

**Planned Features**:
- 🔨 **Auto column sizing** - Content-based width calculation
- 🔨 **Auto header styling** - Bold headers with background colors
- 🔨 **Auto alternating rows** - Zebra striping for readability
- 🔨 **Auto page breaks** - Tables continue on next page with headers
- 🔨 **Column/row spanning** - Merge cells across columns/rows

**Current Status**: Structure ready, estimated 30-37 hours for implementation

### Detailed Documentation

For comprehensive documentation on premium modules, including:
- Installation instructions
- Feature comparisons (FREE vs PREMIUM)
- Implementation details
- Code examples
- Troubleshooting

See **[Chapter 16: Premium Modules](16-premium-modules.md)**
