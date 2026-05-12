# VNSPDFAPremium Module

**Status**: 🔔 Coming Soon (Q2 2026)
**Location**: `PDF_Library/Premium/VNSPDFAPremium.xojo_code`
**Module Flag**: `hasPremiumVNSPDFAModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create a `PDFAModule` subfolder inside it. Drag the following file into that folder:

- `VNSPDFPDFAPremium.xojo_code`

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
hasPremiumVNSPDFAModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether PDF/A compliance features (ICC color profile embedding) are available. If the flag is `False`, PDF/A-related methods will not be functional.

---

## Overview

The Premium PDF/A module provides ICC color profile embedding for creating archival-quality PDF documents compliant with PDF/A standards.

### Supported Standards

| Standard | Use Case | ICC Profile |
|----------|----------|-------------|
| PDF/A-1 | Long-term archival | sRGB IEC61966-2.1 |
| PDF/X | Print production | CMYK profiles |
| PDF/E-1 | Engineering documents | sRGB |

---

## What is PDF/A?

PDF/A is an ISO-standardized version of PDF designed for long-term preservation of electronic documents. Key requirements:

- **Self-contained** - All fonts embedded
- **Color managed** - ICC profiles define color space
- **No external dependencies** - No linked content
- **Metadata** - XMP metadata required
- **No encryption** - Content must be accessible

---

## Features

### ICC Color Profile Embedding

- Automatic sRGB profile detection on macOS
- Manual profile specification from any file
- Proper Output Intent dictionary structure
- Support for RGB and CMYK profiles

### Output Intent Types

```xojo
// Available in VNSPDFModule:
gkOutputIntentPDFA1   // "GTS_PDFA1" - PDF/A-1 archival
gkOutputIntentPDFX    // "GTS_PDFX"  - PDF/X print production
gkOutputIntentPDFE1   // "GTS_PDFE1" - PDF/E engineering
```

---

## Usage

### Basic PDF/A Creation

```xojo
// Create document
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                              VNSPDFModule.ePageUnit.Millimeters, _
                              VNSPDFModule.ePageFormat.A4)

// Add required metadata for PDF/A
pdf.SetTitle("Archival Document")
pdf.SetAuthor("Document Author")
pdf.SetSubject("PDF/A Compliant Document")
pdf.SetCreator("VNS PDF Library")

// Add content
pdf.SetFont("Helvetica", "", 12)
pdf.Cell(0, 10, "This is a PDF/A compliant document.")

// Add ICC profile for PDF/A compliance
Dim iccPath As String = FindSRGBProfile()
If iccPath <> "" Then
  // Read the ICC profile file into a MemoryBlock
  Dim iccFile As FolderItem = New FolderItem(iccPath, FolderItem.PathModes.Native)
  Dim bs As BinaryStream = BinaryStream.Open(iccFile)
  Dim iccProfile As MemoryBlock = bs.Read(bs.Length)
  bs.Close

  pdf.AddOutputIntent( _
    VNSPDFModule.gkOutputIntentPDFA1, _  // Subtype
    "sRGB IEC61966-2.1", _                // Output condition
    "sRGB", _                             // Info
    iccProfile)                           // ICC profile data (MemoryBlock)
End If

Dim outFile As FolderItem = SpecialFolder.Desktop.Child("archival_document.pdf")
pdf.Save(outFile)
```

### Finding sRGB Profile on macOS

```xojo
Function FindSRGBProfile() As String
  // Check common locations
  Dim paths() As String

  // User's Desktop (manual placement)
  paths.Add(SpecialFolder.Desktop.Child("sRGB.icc").NativePath)

  // macOS system profiles
  paths.Add("/System/Library/ColorSync/Profiles/sRGB Profile.icc")

  // Adobe profiles (if installed)
  paths.Add("/Library/Application Support/Adobe/Color/Profiles/sRGB Color Space Profile.icm")

  For Each path As String In paths
    Dim f As FolderItem = New FolderItem(path, FolderItem.PathModes.Native)
    If f <> Nil And f.Exists Then
      Return path
    End If
  Next

  Return ""  // Not found
End Function
```

### Checking Module Availability

```xojo
If hasPremiumVNSPDFAModule Then
  // PDF/A features available
  pdf.AddOutputIntent(...)
Else
  // Create standard PDF (not PDF/A compliant)
End If
```

---

## API Reference

### AddOutputIntent

```xojo
Sub AddOutputIntent(subtype As String, _
                    outputCondition As String, _
                    info As String, _
                    iccProfile As MemoryBlock)
```

**Parameters**:
- `subtype` - Output intent type (use `gkOutputIntent*` constants)
- `outputCondition` - Name of the output condition (e.g., `"sRGB IEC61966-2.1"`)
- `info` - Additional information string
- `iccProfile` - ICC profile binary data as `MemoryBlock` (load from disk with `BinaryStream.Open(file).Read(bs.Length)`)

---

## Implementation Details

### PDF Structure

The Output Intent is added to the PDF catalog:

```
% Catalog dictionary
<< /Type /Catalog
   /Pages 2 0 R
   /OutputIntents [ 3 0 R ]
>>

% Output Intent dictionary
<< /Type /OutputIntent
   /S /GTS_PDFA1
   /OutputCondition (sRGB IEC61966-2.1)
   /Info (sRGB)
   /DestOutputProfile 4 0 R
>>

% ICC Profile stream
<< /N 3
   /Length 3144
   /Filter /FlateDecode
>>
stream
... compressed ICC profile data ...
endstream
```

### ICC Profile Structure

The `/N` entry specifies the number of color components:
- `/N 3` - RGB profile (3 components)
- `/N 4` - CMYK profile (4 components)
- `/N 1` - Grayscale profile (1 component)

### Compression

ICC profiles are automatically compressed using FlateDecode when available, reducing file size by 50-70%.

---

## PDF/A Compliance Checklist

For full PDF/A-1b compliance, ensure:

1. ✅ **Output Intent** - ICC profile embedded (this module)
2. ✅ **Fonts** - All fonts embedded (use TrueType/UTF-8 fonts)
3. ✅ **Metadata** - Title, Author, Subject set
4. ⚠️ **XMP Metadata** - Currently not generated (planned enhancement)
5. ✅ **No Encryption** - PDF/A documents must not be encrypted
6. ✅ **No External References** - All content self-contained

### Current Limitations

- XMP metadata packet not yet generated
- PDF/A version identifier not added to file header
- Full validation requires external PDF/A validator tool

---

## Color Management

### sRGB vs CMYK

| Color Space | Use Case | Profile Type |
|-------------|----------|--------------|
| sRGB | Screen display, web | RGB (N=3) |
| Adobe RGB | Photography | RGB (N=3) |
| FOGRA39 | European print | CMYK (N=4) |
| SWOP | US print | CMYK (N=4) |

### Color Accuracy Demo

Example 13 demonstrates color management with sRGB profile:

```xojo
// Draw color swatches with exact sRGB values
pdf.SetFillColor(255, 0, 0)    // Pure red
pdf.Rect(x, y, 30, 15, VNSPDFModule.eDrawStyle.Fill)

pdf.SetFillColor(0, 255, 0)    // Pure green
pdf.Rect(x+35, y, 30, 15, VNSPDFModule.eDrawStyle.Fill)

pdf.SetFillColor(0, 0, 255)    // Pure blue
pdf.Rect(x+70, y, 30, 15, VNSPDFModule.eDrawStyle.Fill)
```

With ICC profile embedded, these colors will display consistently across different viewers and devices.

---

## Example

### Example 13: PDF/A Document

```xojo
Sub GenerateExample13_PDFA(pdf As VNSPDFDocument)
  // Title
  pdf.SetFont("Helvetica", "B", 16)
  pdf.Cell(0, 10, "Example 13: PDF/A Compliance", 0, 1, "C")

  // Set metadata (required for PDF/A)
  pdf.SetTitle("PDF/A Example Document")
  pdf.SetAuthor("VNS PDF Library")
  pdf.SetSubject("Demonstrating PDF/A output intent")

  // Add content
  pdf.SetFont("Helvetica", "", 11)
  pdf.Ln(10)
  pdf.MultiCell(0, 6, "This document includes an ICC color profile " + _
    "for PDF/A-1 compliance. The sRGB profile ensures consistent " + _
    "color reproduction across different viewers and devices.")

  // Find and embed ICC profile
  Dim iccPath As String = FindSRGBProfile()
  If iccPath <> "" Then
    Dim iccFile As FolderItem = New FolderItem(iccPath, FolderItem.PathModes.Native)
    Dim bs As BinaryStream = BinaryStream.Open(iccFile)
    Dim iccProfile As MemoryBlock = bs.Read(bs.Length)
    bs.Close

    pdf.AddOutputIntent( _
      VNSPDFModule.gkOutputIntentPDFA1, _
      "sRGB IEC61966-2.1", _
      "sRGB", _
      iccProfile)

    pdf.Ln(10)
    pdf.SetTextColor(0, 128, 0)
    pdf.Cell(0, 6, "ICC Profile: Embedded successfully", 0, 1)
  Else
    pdf.Ln(10)
    pdf.SetTextColor(200, 0, 0)
    pdf.MultiCell(0, 6, "ICC Profile: Not found. Place sRGB.icc " + _
      "on Desktop or ensure macOS system profile is accessible.")
  End If

  // Color swatches demonstrating managed colors
  pdf.Ln(10)
  pdf.SetTextColor(0, 0, 0)
  pdf.Cell(0, 6, "Color Swatches (sRGB managed):", 0, 1)

  Dim startX As Double = pdf.GetX()
  Dim startY As Double = pdf.GetY() + 5

  // Red
  pdf.SetFillColor(255, 0, 0)
  pdf.Rect(startX, startY, 25, 12, VNSPDFModule.eDrawStyle.Fill)

  // Green
  pdf.SetFillColor(0, 255, 0)
  pdf.Rect(startX + 30, startY, 25, 12, VNSPDFModule.eDrawStyle.Fill)

  // Blue
  pdf.SetFillColor(0, 0, 255)
  pdf.Rect(startX + 60, startY, 25, 12, VNSPDFModule.eDrawStyle.Fill)
End Sub
```

---

## Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| Desktop | ✅ | Full support with system profiles |
| Web | ✅ | Requires profile in accessible location |
| iOS | ✅ | Bundle profile with app resources |
| Console | ✅ | Full support |

---

## Resources

### ICC Profile Sources

- **macOS**: `/System/Library/ColorSync/Profiles/`
- **Windows**: `C:\Windows\System32\spool\drivers\color\`
- **ICC.org**: https://www.color.org/profiles.xalter

### PDF/A Validators

- Adobe Acrobat Pro (Preflight)
- veraPDF (open source)
- PDF-Tools (online validators)

---

*Last Updated: 2026-01-26*
