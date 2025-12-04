# Premium Modules

## Table of Contents

- [Overview](#overview)
- [Module Architecture](#module-architecture)
- [Module Flags](#module-flags)
- [VNSPDFEncryptionPremium](#vnspdfencryptionpremium)
  - [RC4-128 Encryption](#rc4-128-encryption)
  - [AES Encryption (Stubs)](#aes-encryption-stubs)
  - [Implementation Details](#implementation-details)
- [VNSPDFPDFAPremium](#vnspdfpdfapremium)
  - [Output Intent Support](#output-intent-support)
  - [ICC Color Profiles](#icc-color-profiles)
  - [PDF/A Compliance](#pdfa-compliance)
- [VNSPDFZlibPremium](#vnspdfzlibpremium)
  - [Pure Xojo Compression](#pure-xojo-compression)
  - [iOS Support](#ios-support)
  - [Roadmap](#zlib-roadmap)
- [VNSPDFTablePremium](#vnspdftablepremium)
  - [High-Level Table API](#high-level-table-api)
  - [Auto-Layout Features](#auto-layout-features)
  - [Roadmap](#table-roadmap)
- [Installing Premium Modules](#installing-premium-modules)
- [Version Comparison](#version-comparison)

---

## Overview

The VNS PDF library offers **premium modules** that extend the core FREE functionality with advanced features. Premium modules are:

- **Optional**: Core library works without them (with reduced functionality)
- **Plug-and-play**: Enable by setting module flags to `True`
- **Segregated**: Code is in `PDF_Library/Premium/` folder
- **Gated**: Features check module flags before executing

**Premium modules are NOT included in the FREE version** and require a separate license.

### Module Status Summary

| Module | Status | Features | FREE Version | PREMIUM Version |
|--------|--------|----------|--------------|-----------------|
| **Encryption** | ✅ Complete | RC4-128, AES-128, AES-256 | RC4-40 only | RC4-40 + RC4-128 + AES-128 + AES-256 (✅ all working) |
| **PDF/A** | ✅ Complete | Output Intent, ICC profiles | ❌ Not available | ✅ Fully working |
| **Zlib** | ✅ Complete | Pure Xojo deflate/inflate | Desktop/Web/Console only | **All platforms including iOS** (✅ fully working) |
| **Table** | ✅ Complete | SimpleTable, ImprovedTable, FancyTable | Manual Cell() calls | High-level API (✅ fully working) |

---

## Module Architecture

Premium modules follow a consistent architecture pattern:

```
PDF_Library/
├── Premium/
│   ├── VNSPDFEncryptionPremium.xojo_code    # RC4-128 + AES-128/256 encryption (✅ complete)
│   ├── VNSPDFPDFAPremium.xojo_code          # PDF/A output intents (✅ complete)
│   ├── VNSPDFTablePremium.xojo_code         # Table generation (✅ complete)
│   └── README.md                             # Premium module documentation
├── Compression/
│   ├── VNSZlibModule.xojo_code              # Main zlib interface
│   ├── VNSZlibPremiumDeflate.xojo_code      # Pure Xojo compression (✅ complete)
│   ├── VNSZlibPremiumInflate.xojo_code      # Pure Xojo decompression (✅ complete)
│   └── VNSZlibPremiumTrees.xojo_code        # Huffman trees for zlib
└── VNSPDFModule.xojo_code                    # Module flags defined here
```

### Design Principles

1. **Module Flags**: Boolean constants control feature availability
2. **Conditional Compilation**: `#If VNSPDFModule.kHasXxxModule` gates premium code
3. **Delegation Pattern**: Core classes delegate to premium modules when available
4. **Error Messages**: Clear messages when premium features are accessed without modules
5. **Zero Impact**: Premium modules don't affect FREE version when flags are `False`

---

## Module Flags

Module availability is controlled by Boolean constants in `VNSPDFModule.xojo_code`:

```xojo
// Module availability flags (lines 806-815)
Public Const hasPremiumEncryptionModule As Boolean = False  // RC4-128 + AES encryption
Public Const hasPremiumPDFAModule As Boolean = False        // PDF/A output intents
Public Const hasPremiumZlibModule As Boolean = False        // iOS compression
Public Const hasPremiumTableModule As Boolean = False       // Table generation
```

### Setting Module Flags

To enable a premium module:

1. **Purchase the module license**
2. **Add the premium module file** to your project
3. **Set the corresponding flag to `True`** in `VNSPDFModule.xojo_code`
4. **Rebuild your project**

**Example** (enabling Encryption module):
```xojo
// Change from:
Public Const hasPremiumEncryptionModule As Boolean = False

// To:
Public Const hasPremiumEncryptionModule As Boolean = True
```

### Checking Module Availability at Runtime

```xojo
If VNSPDFModule.hasPremiumEncryptionModule Then
    // Use premium encryption features
    pdf.SetProtection("user123", "owner456", True, True, True, True, _
                      VNSPDFModule.gkEncryptionRC4_128)
Else
    // Fallback to FREE version (RC4-40 only)
    pdf.SetProtection("user123", "owner456", True, True, True, True, _
                      VNSPDFModule.gkEncryptionRC4_40)
End If
```

---

## VNSPDFEncryptionPremium

**Location**: `PDF_Library/Premium/VNSPDFEncryptionPremium.xojo_code`
**Module Flag**: `VNSPDFModule.hasPremiumEncryptionModule`
**Status**: ✅ **Complete** - All encryption algorithms fully working

### Features

The premium Encryption module extends the FREE version (RC4-40 only) with:

- ✅ **RC4-128** (128-bit encryption, Revision 3) - **FULLY WORKING**
- ✅ **AES-128** (128-bit AES-CBC, Revision 4) - **FULLY WORKING** (pure Xojo AES)
- ✅ **AES-256** (256-bit AES-CBC, Revision 5) - **FULLY WORKING** (SHA-256)
- ✅ **AES-256** (256-bit AES-CBC, Revision 6) - **FULLY WORKING** (Algorithm 2.B with SHA-384/512)

### RC4-128 Encryption

**Working Features:**
- 50-iteration MD5 key derivation (enhanced security vs RC4-40)
- Full permission control (8 permission flags)
- User and owner password support
- Object-level encryption with unique keys per object

**Example:**
```xojo
// Check if premium Encryption module is available
If Not VNSPDFModule.hasPremiumEncryptionModule Then
    MsgBox "RC4-128 encryption requires premium Encryption module"
    Return
End If

// Create document
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                              VNSPDFModule.ePageUnit.Millimeters, _
                              VNSPDFModule.ePageFormat.A4)

// Add content
pdf.AddPage()
pdf.SetFont("Helvetica", "", 12)
pdf.Cell(0, 10, "This document uses RC4-128 encryption")

// Enable RC4-128 encryption
pdf.SetProtection("userpass", "ownerpass", True, True, True, True, _
                  VNSPDFModule.gkEncryptionRC4_128)

// Save
pdf.SaveToFile("encrypted_rc4_128.pdf")
```

### AES Encryption

**Status**: ✅ **Fully Working**

The module provides complete AES encryption using pure Xojo implementation:

```xojo
Module VNSPDFEncryptionPremium
    // AES-CBC encryption (Revision 4-6) - ✅ FULLY WORKING
    Function EncryptAESCBCNoPadding(data As String, key As String, iv As String) As String
        // Pure Xojo AES-CBC implementation (based on Tiny AES-C)
        // Works on ALL platforms including iOS (no Declares needed)
    End Function

    // SHA-256 hashing (Revision 5) - ✅ FULLY WORKING
    Function SHA256(data As String) As String
        // Pure Xojo SHA-256 implementation
    End Function

    // SHA-384 hashing (Revision 6) - ✅ FULLY WORKING
    Function SHA384(data As String) As String
        // Pure Xojo SHA-384 implementation
    End Function

    // SHA-512 hashing (Revision 6) - ✅ FULLY WORKING
    Function SHA512(data As String) As String
        // Pure Xojo SHA-512 implementation
    End Function

    // Algorithm 2.B iterative hashing (Revision 6) - ✅ FULLY WORKING
    Function ComputeHashR6(pwd As String, salt As String, userKey As String) As String
        // 64+ iterations with SHA-256/384/512 mixing
    End Function

    // Generate random initialization vector - ✅ FULLY WORKING
    Function GenerateRandomIV() As String
        // Uses Crypto.GenerateRandomBytes()
    End Function

    // PKCS7 padding helper - ✅ FULLY WORKING
    Function PKCS7Pad(data As String, blockSize As Integer) As String
        // Proper padding for AES blocks
    End Function
End Module
```

**Pure Xojo AES Implementation:**
- Based on Tiny AES-C reference implementation
- Works on ALL platforms including iOS (no Declares required)
- Avoids Xojo Crypto.AES PKCS7 padding issues
- No warnings in Adobe Acrobat (unlike RC4)

### Implementation Details

#### Encryption Revisions

| Revision | Algorithm | Key Length | Hash Algorithm | Status |
|----------|-----------|------------|----------------|--------|
| 2 (FREE) | RC4 | 40-bit | MD5 (no iterations) | ✅ Working |
| 3 (PREMIUM) | RC4 | 128-bit | MD5 (50 iterations) | ✅ Working |
| 4 (PREMIUM) | AES-CBC | 128-bit | MD5 (50 iterations) | ✅ Working |
| 5 (PREMIUM) | AES-CBC | 256-bit | SHA-256 | ✅ Working |
| 6 (PREMIUM) | AES-CBC | 256-bit | Algorithm 2.B (SHA-384/512) | ✅ Working |

#### Key Derivation Process (RC4-128)

```xojo
// 1. Pad passwords to 32 bytes using PDF standard padding string
userPadded = PadPassword(userPassword)
ownerPadded = PadPassword(ownerPassword)

// 2. Compute owner entry (O)
hash = MD5(ownerPadded)
For i = 1 To 50
    hash = MD5(hash)  // 50 iterations for revision 3
Next
ownerEntry = EncryptRC4(userPadded, hash.LeftBytes(16))

// 3. Compute encryption key
hashInput = userPadded + ownerEntry + permissions + fileID
hash = MD5(hashInput)
For i = 1 To 50
    hash = MD5(hash.LeftBytes(16))  // 50 iterations
Next
encryptionKey = hash.LeftBytes(16)  // 128-bit key

// 4. Encrypt each object with unique key
For Each object
    objectKey = MD5(encryptionKey + objectNumber + generation)
    encryptedData = EncryptRC4(objectData, objectKey)
Next
```

#### Module Structure

```xojo
Module VNSPDFEncryptionPremium
    // Core RC4-128 encryption (✅ WORKING)
    Function EncryptRC4(data As String, key As String) As String
    Function SetupRC4State(key As String) As UInt8()
    Function RC4Transform(data As String, state() As UInt8) As String

    // AES encryption (✅ ALL WORKING - Pure Xojo implementation)
    Function EncryptAESCBCNoPadding(data As String, key As String, iv As String) As String
    Function GenerateRandomIV() As String
    Function PKCS7Pad(data As String, blockSize As Integer) As String

    // SHA hashing (✅ ALL WORKING - Pure Xojo implementation)
    Function SHA256(data As String) As String
    Function SHA384(data As String) As String
    Function SHA512(data As String) As String

    // Algorithm 2.B for Revision 6 (✅ WORKING)
    Function ComputeHashR6(pwd As String, salt As String, userKey As String) As String

    // Utility
    Function GetVersionString() As String
End Module
```

#### Error Handling

When premium features are accessed without the module:

```xojo
// In VNSPDFDocument.SetProtection()
If revision >= 3 And revision <= 6 Then
    #If Not VNSPDFModule.hasPremiumEncryptionModule Then
        Call SetError("Encryption revisions 3-6 (RC4-128 and AES) require " + _
                      "premium Encryption module. Only RC4-40 (revision 2) " + _
                      "is available in free version.")
        Return
    #EndIf
End If
```

---

## VNSPDFPDFAPremium

**Location**: `PDF_Library/Premium/VNSPDFPDFAPremium.xojo_code`
**Module Flag**: `VNSPDFModule.hasPremiumPDFAModule`
**Status**: ✅ **Complete** - Fully working

### Features

The premium PDF/A module provides full support for archival-quality PDF documents:

- ✅ **Output Intent** embedding
- ✅ **ICC color profile** support
- ✅ **Automatic sRGB profile detection** on macOS
- ✅ **PDF/A-1b compliance** (approaching full compliance)

### Output Intent Support

Output intents specify the intended color reproduction characteristics for archival documents.

**Supported Subtypes:**
- `VNSPDFModule.gkOutputIntentPDFA1` - PDF/A-1 archival documents
- `VNSPDFModule.gkOutputIntentPDFX` - PDF/X prepress documents
- `VNSPDFModule.gkOutputIntentPDFE1` - PDF/E engineering documents

**Example:**
```xojo
// Check if premium PDF/A module is available
If Not VNSPDFModule.hasPremiumPDFAModule Then
    MsgBox "PDF/A features require premium PDF/A module"
    Return
End If

// Create document
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                              VNSPDFModule.ePageUnit.Millimeters, _
                              VNSPDFModule.ePageFormat.A4)

// Load ICC profile
Dim iccProfile As MemoryBlock
Dim profilePath As String = "/System/Library/ColorSync/Profiles/sRGB Profile.icc"
Dim f As FolderItem = New FolderItem(profilePath, FolderItem.PathModes.Native)
If f <> Nil And f.Exists Then
    Dim stream As BinaryStream = BinaryStream.Open(f)
    iccProfile = stream.Read(stream.Length)
    stream.Close()
End If

// Add output intent
pdf.AddOutputIntent(VNSPDFModule.gkOutputIntentPDFA1, _
                    "sRGB IEC61966-2.1", _
                    "sRGB color space for archival", _
                    iccProfile)

// Add content with color calibration
pdf.AddPage()
pdf.SetFont("Helvetica", "", 12)
pdf.Cell(0, 10, "This is a PDF/A-1b compliant document")

// Set XMP metadata (recommended for PDF/A)
pdf.SetXmpMetadata("<?xml version=""1.0""?>...")

// Save
pdf.SaveToFile("pdfa_document.pdf")
```

### ICC Color Profiles

ICC (International Color Consortium) profiles ensure consistent color reproduction across devices and software.

**Automatic Profile Detection (macOS):**
```xojo
// VNSPDFPDFAPremium automatically searches for sRGB profiles:
// 1. Desktop/sRGB.icc
// 2. /System/Library/ColorSync/Profiles/sRGB Profile.icc
// 3. /Library/ColorSync/Profiles/sRGB Profile.icc
// 4. /System/Library/ColorSync/Profiles/Generic RGB Profile.icc
```

**Manual Profile Loading:**
```xojo
Dim iccProfile As MemoryBlock
Dim f As FolderItem = New FolderItem("/path/to/AdobeRGB1998.icc")
If f <> Nil And f.Exists Then
    Dim stream As BinaryStream = BinaryStream.Open(f)
    iccProfile = stream.Read(stream.Length)
    stream.Close()

    pdf.AddOutputIntent(VNSPDFModule.gkOutputIntentPDFA1, _
                        "Adobe RGB (1998)", _
                        "Wide gamut color space", _
                        iccProfile)
End If
```

### PDF/A Compliance

The premium PDF/A module helps achieve **PDF/A-1b compliance**:

**Implemented Requirements:**
- ✅ Output Intent with ICC profile
- ✅ XMP metadata embedding
- ✅ UTF-16BE text encoding
- ✅ All fonts embedded (TrueType fonts)
- ✅ No encryption (PDF/A forbids encryption)
- ✅ Predictable structure (no dynamic content)

**Not Yet Implemented (PDF/A-1a requirements):**
- ❌ Tagged PDF structure
- ❌ Document structure tree
- ❌ Accessibility annotations
- ❌ Role mapping

**Validation:**
Use external tools to validate PDF/A compliance:
- Adobe Acrobat Preflight
- VeraPDF (free, open-source)
- PDF/A Validator

**Implementation Details:**

```xojo
Module VNSPDFPDFAPremium
    // Add output intent to document
    Sub AddOutputIntent(doc As VNSPDFDocument, subtype As String, _
                        outputCondition As String, info As String, _
                        iccProfile As MemoryBlock)
        // 1. Generate ICC profile stream object
        Dim profileObj As Integer = doc.NewObj()
        doc.PutStream("<<" + EndOfLine + _
                      "/N 3" + EndOfLine + _  // RGB = 3 components
                      "/Length " + Str(iccProfile.Size) + EndOfLine + _
                      ">>", iccProfile.StringValue(0, iccProfile.Size))

        // 2. Store output intent data in document
        doc.mOutputIntentSubtype = subtype
        doc.mOutputIntentCondition = outputCondition
        doc.mOutputIntentInfo = info
        doc.mOutputIntentDestProfile = profileObj

        // 3. Output intent will be added to catalog during PDF finalization
    End Sub

    // Search for sRGB ICC profile on system (macOS)
    Function FindSystemSRGBProfile() As MemoryBlock
        Dim paths() As String
        paths.Add("Desktop/sRGB.icc")
        paths.Add("/System/Library/ColorSync/Profiles/sRGB Profile.icc")
        paths.Add("/Library/ColorSync/Profiles/sRGB Profile.icc")
        paths.Add("/System/Library/ColorSync/Profiles/Generic RGB Profile.icc")

        For Each path As String In paths
            Dim f As FolderItem = New FolderItem(path, FolderItem.PathModes.Native)
            If f <> Nil And f.Exists Then
                Dim stream As BinaryStream = BinaryStream.Open(f)
                Dim profile As MemoryBlock = stream.Read(stream.Length)
                stream.Close()
                Return profile
            End If
        Next

        Return Nil  // No profile found
    End Function
End Module
```

---

## VNSZlibPremium (Compression Module)

**Location**: `PDF_Library/Compression/VNSZlibPremiumDeflate.xojo_code` and `VNSZlibPremiumInflate.xojo_code`
**Module Flag**: `VNSPDFModule.hasPremiumZlibModule`
**Status**: ✅ **Complete** - Full compression and decompression working on ALL platforms

### Features

The premium Zlib module provides:

- ✅ **iOS compression** - Pure Xojo zlib implementation (bypasses iOS sandboxing)
- ✅ **Deflate compression** - Full RFC 1951 compliant implementation
- ✅ **Inflate decompression** - Full RFC 1951 compliant implementation
- ✅ **Round-trip verification** - Compress then decompress produces identical data

### Pure Xojo Compression

**Why Pure Xojo?**
- iOS sandboxing blocks `Declare` to system libraries (no native zlib access)
- Desktop/Web/Console can use system zlib via `Declare`
- Pure Xojo implementation enables cross-platform consistency
- Based on zlib 1.3.1 official source code

**Implementation:**
```xojo
// VNSZlibPremiumDeflate - Compression
Class VNSZlibPremiumDeflate
    // Compress string to MemoryBlock (✅ WORKING)
    Function CompressString(input As String) As MemoryBlock
        // Full DEFLATE algorithm (RFC 1951)
        // - LZ77 sliding window compression
        // - Static and dynamic Huffman coding
        // - Proper zlib header (CMF/FLG)
        // - Adler-32 checksum
    End Function
End Class

// VNSZlibPremiumInflate - Decompression
Class VNSZlibPremiumInflate
    // Decompress MemoryBlock to string (✅ WORKING)
    Function DecompressString(input As MemoryBlock) As String
        // Full INFLATE algorithm (RFC 1951)
        // - Static and dynamic Huffman decoding
        // - LZ77 length/distance decompression
        // - Checksum verification
    End Function
End Class

// VNSZlibPremiumTrees - Huffman trees
Module VNSZlibPremiumTrees
    // Pre-computed static Huffman trees (✅ WORKING)
    Function GetStaticLTree(index As Integer) As Pair
    Function GetStaticDTree(index As Integer) As Pair
End Module
```

### iOS Support

When `hasPremiumZlibModule = True`, iOS uses pure Xojo compression:

```xojo
// In VNSZlibModule.Compress()
If VNSPDFModule.hasPremiumZlibModule Then
    // Use pure Xojo implementation (works on ALL platforms including iOS)
    Dim deflater As New VNSZlibPremiumDeflate
    Dim result As MemoryBlock = deflater.CompressString(input)
    Return result.StringValue(0, result.Size)
End If

// In VNSPDFDocument - FlateDecode filter is now added on iOS
#If TargetiOS Then
    If VNSPDFModule.hasPremiumZlibModule Then
        filterStr = "/Filter /FlateDecode"  // ✅ Now included on iOS!
    End If
#Else
    filterStr = "/Filter /FlateDecode"
#EndIf
```

### Zlib Module Complete

**All phases completed:**
- ✅ Core DEFLATE compression (LZ77 + Huffman)
- ✅ Core INFLATE decompression
- ✅ Static Huffman trees with direct lookups
- ✅ Adler-32 checksums
- ✅ Cross-platform testing (Desktop, Web, iOS, Console)
- ✅ Round-trip verification tests passing

---

## VNSPDFTablePremium

**Location**: `PDF_Library/Premium/VNSPDFTablePremium.xojo_code`
**Module Flag**: `VNSPDFModule.hasPremiumTableModule`
**Status**: ✅ **Complete** - Full table generation working

### Features

The premium Table module provides a **high-level declarative API** for table generation:

- ✅ **SimpleTable()** - Equal-width columns, basic styling
- ✅ **ImprovedTable()** - Custom column widths, auto number alignment
- ✅ **FancyTable()** - Professional styling with colored headers and zebra rows
- ✅ **Auto page breaks** - Tables continue on next page with repeated headers
- ✅ **Footer rows** - Grand totals and intermediate subtotals
- ✅ **Column calculations** - SUM, AVG, COUNT, MIN, MAX

### High-Level Table API

**Working API:**
```xojo
Module VNSPDFTablePremium
    // Simple table with equal-width columns (✅ WORKING)
    Sub SimpleTable(pdf As VNSPDFDocument, rs As RowSet, columnHeaders() As String, _
                    repeatHeaders As Boolean = True)

    // Improved table with custom widths and auto alignment (✅ WORKING)
    Sub ImprovedTable(pdf As VNSPDFDocument, rs As RowSet, columnHeaders() As String, _
                      columnWidths() As Double, repeatHeaders As Boolean = True)

    // Fancy table with professional styling (✅ WORKING)
    Sub FancyTable(pdf As VNSPDFDocument, rs As RowSet, columnHeaders() As String, _
                   columnWidths() As Double, repeatHeaders As Boolean = True)
End Module
```

### Example Usage

```xojo
// Check if premium Table module is available
If Not VNSPDFModule.hasPremiumTableModule Then
    MsgBox "Table features require premium Table module"
    Return
End If

// Create document
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                              VNSPDFModule.ePageUnit.Millimeters, _
                              VNSPDFModule.ePageFormat.A4)
pdf.AddPage()

// Create in-memory SQLite database with sample data
Dim db As New SQLiteDatabase
db.Connect()
db.ExecuteSQL("CREATE TABLE data (Country TEXT, Capital TEXT, Area TEXT)")
db.ExecuteSQL("INSERT INTO data VALUES ('Austria', 'Vienna', '83,879')")
db.ExecuteSQL("INSERT INTO data VALUES ('Belgium', 'Brussels', '30,528')")
db.ExecuteSQL("INSERT INTO data VALUES ('Denmark', 'Copenhagen', '43,094')")

// Get data as RowSet
Dim rs As RowSet = db.SelectSQL("SELECT * FROM data")

// Define columns
Dim headers() As String = Array("Country", "Capital", "Area (sq km)")
Dim widths() As Double = Array(40.0, 35.0, 45.0)

// Render FancyTable with professional styling
VNSPDFTablePremium.FancyTable(pdf, rs, headers, widths, True)

// Save
pdf.SaveToFile("table_example.pdf")
```

### Table Module Complete

**All features implemented:**
- ✅ SimpleTable() - Equal-width columns
- ✅ ImprovedTable() - Custom widths with auto number alignment
- ✅ FancyTable() - Blue headers, alternating gray rows
- ✅ Header repetition on page breaks via AcceptPageBreakFunc callback
- ✅ Footer rows (grand totals and intermediate subtotals)
- ✅ Column calculations (SUM, AVG, COUNT, MIN, MAX)
- ✅ SQLite RowSet-based data handling
- ✅ Multi-page pagination tested with 99-row tables

---

## Installing Premium Modules

### Step 1: Purchase License

Contact VNS Software to purchase premium module licenses:
- Individual modules available separately
- Bundle pricing for multiple modules
- Enterprise licensing available

### Step 2: Add Premium Module Files

1. **Locate the premium module file** (e.g., `VNSPDFEncryptionPremium.xojo_code`)
2. **Copy to** `PDF_Library/Premium/` folder
3. **Add to Xojo project**:
   - Open your Xojo project
   - Right-click on `PDF_Library/Premium` folder in Navigator
   - Select "Add File..."
   - Choose the premium module file

### Step 3: Enable Module Flag

1. **Open** `PDF_Library/VNSPDFModule.xojo_code`
2. **Find the module flag** (lines 806-815)
3. **Change from `False` to `True`**:

```xojo
// Before:
Public Const hasPremiumEncryptionModule As Boolean = False

// After:
Public Const hasPremiumEncryptionModule As Boolean = True
```

4. **Save the file**

### Step 4: Rebuild Project

1. **Clean build folder** (optional but recommended)
2. **Build project** for your target platform
3. **Test premium features** to verify installation

### Step 5: Verify Installation

```xojo
// Check module availability at runtime
If VNSPDFModule.hasPremiumEncryptionModule Then
    MsgBox "Encryption module installed: RC4-128 + AES available"
Else
    MsgBox "Encryption module NOT installed: Only RC4-40 available"
End If

If VNSPDFModule.hasPremiumPDFAModule Then
    MsgBox "PDF/A module installed: Output Intent support available"
Else
    MsgBox "PDF/A module NOT installed"
End If

If VNSPDFModule.hasPremiumZlibModule Then
    MsgBox "Zlib module installed: iOS compression available"
Else
    MsgBox "Zlib module NOT installed"
End If

If VNSPDFModule.hasPremiumTableModule Then
    MsgBox "Table module installed: High-level table API available"
Else
    MsgBox "Table module NOT installed"
End If
```

---

## Version Comparison

### FREE vs PREMIUM Feature Matrix

| Feature Category | FREE Version | PREMIUM Version |
|------------------|--------------|-----------------|
| **Encryption** | RC4-40 (40-bit) | RC4-40 + RC4-128 + AES-128 + AES-256 (✅ all working) |
| **PDF/A Compliance** | ❌ Not available | ✅ Output Intent + ICC profiles |
| **Compression** | Desktop/Web/Console only | **All platforms including iOS** (✅ fully working) |
| **Table Generation** | Manual Cell() calls | SimpleTable + ImprovedTable + FancyTable (✅ fully working) |
| **Total Features** | 177 features (75.0%) | 249 features (86.3%) |

### Security Comparison

| Encryption Type | FREE | PREMIUM |
|----------------|------|---------|
| RC4-40 (40-bit) | ✅ Working | ✅ Working |
| RC4-128 (128-bit) | ❌ Blocked | ✅ Working |
| AES-128 (128-bit) | ❌ Blocked | ✅ Working |
| AES-256 R5 (256-bit) | ❌ Blocked | ✅ Working |
| AES-256 R6 (256-bit) | ❌ Blocked | ✅ Working |
| **Strength** | WEAK (deprecated) | STRONG (256-bit AES) |

### Module Completion Summary

| Module | Status | Features |
|--------|--------|----------|
| **Encryption** | ✅ Complete | RC4-128, AES-128, AES-256 R5/R6, SHA-256/384/512, Algorithm 2.B |
| **PDF/A** | ✅ Complete | Output Intent, ICC profiles |
| **Zlib** | ✅ Complete | Pure Xojo deflate/inflate, iOS support |
| **Table** | ✅ Complete | SimpleTable, ImprovedTable, FancyTable, footers, calculations |
| **Total** | ✅ 100% complete | All premium modules fully working |

---

## Best Practices

### 1. Always Check Module Availability

```xojo
// GOOD: Check before using premium features
If VNSPDFModule.hasPremiumEncryptionModule Then
    pdf.SetProtection("user", "owner", True, True, True, True, _
                      VNSPDFModule.gkEncryptionRC4_128)
Else
    // Provide fallback or user message
    MsgBox "RC4-128 encryption requires premium module"
    pdf.SetProtection("user", "owner", True, True, True, True, _
                      VNSPDFModule.gkEncryptionRC4_40)
End If

// BAD: Use premium features without checking
pdf.SetProtection("user", "owner", True, True, True, True, _
                  VNSPDFModule.gkEncryptionRC4_128)
// Will fail with error if module not installed
```

### 2. Handle Module Absence Gracefully

```xojo
// Provide meaningful user feedback
If Not VNSPDFModule.hasPremiumPDFAModule Then
    Dim msg As String = "PDF/A archival features require the premium PDF/A module. " + _
                        "Contact VNS Software for licensing information."
    MsgBox msg
    Return
End If
```

### 3. Document Module Requirements

In your application's README or documentation:

```markdown
## Requirements

This application uses the VNS PDF library with the following premium modules:
- **Encryption Module**: Required for RC4-128 and AES encryption
- **PDF/A Module**: Required for archival PDF generation

To enable these features:
1. Purchase module licenses from VNS Software
2. Install module files to `PDF_Library/Premium/`
3. Set module flags to `True` in `VNSPDFModule.xojo_code`
```

### 4. Version Control Best Practices

**DO commit:**
- ✅ Module flag settings (for your team)
- ✅ Premium module files (if licensed for team)
- ✅ Documentation of premium feature usage

**DO NOT commit:**
- ❌ Premium module files (if not licensed for all team members)
- ❌ License keys or sensitive information

### 5. Testing with Premium Modules

Create test projects for both FREE and PREMIUM configurations:

```
MyApp/
├── MyApp_Free.xojo_project         # kHasXxxModule = False
├── MyApp_Premium.xojo_project      # kHasXxxModule = True
└── PDF_Library/
    ├── Core/
    ├── Premium/                     # Only included in Premium project
    └── VNSPDFModule.xojo_code       # Different flags per project
```

---

## Troubleshooting

### "Premium feature requires module" Error

**Problem**: Error message when using premium features

**Solutions**:
1. **Check module flag**: Verify `kHasXxxModule = True` in VNSPDFModule.xojo_code
2. **Check file inclusion**: Ensure premium module file is added to project
3. **Rebuild project**: Clean build folder and rebuild
4. **Verify license**: Ensure you have valid license for the module

### Module Not Detected at Runtime

**Problem**: `VNSPDFModule.kHasXxxModule` returns `False` despite setting to `True`

**Solutions**:
1. **Check syntax**: Ensure no typos in constant name
2. **Check file save**: Verify VNSPDFModule.xojo_code was saved after editing
3. **Check build**: Ensure you rebuilt project after changing flag
4. **Check target**: Verify correct project file (not a copy with old settings)

### Compilation Errors After Adding Module

**Problem**: Build fails after adding premium module file

**Solutions**:
1. **Check Xojo version**: Ensure compatibility with Xojo 2025r2.1+
2. **Check file encoding**: Ensure .xojo_code file is valid UTF-8
3. **Check dependencies**: Ensure VNSPDFModule and core classes are included
4. **Check API2**: Ensure project uses API2 (not API1)

---

**Last Updated**: 2025-11-26
**VNS PDF Version**: 1.0.0
**Premium Modules**: Encryption (✅ Complete), PDF/A (✅ Complete), Zlib (✅ Complete), Table (✅ Complete)
