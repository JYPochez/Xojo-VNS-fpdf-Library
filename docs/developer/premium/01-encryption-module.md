# VNSPDFEncryptionPremium Module

**Status**: ✅ Available
**Location**: `PDF_Library/Premium/EncryptionModule/VNSPDFEncryptionPremium.xojo_code`
**Module Flag**: `hasPremiumVNSEncryptionModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create an `EncryptionModule` subfolder inside it. Drag the following files into that folder:

- `VNSPDFEncryptionPremium.xojo_code`
- `VNSAESConstants.xojo_code`
- `VNSAESCore.xojo_code`
- `VNSAESTables.xojo_code`
- `VNSAESTest.xojo_code`

The EncryptionModule folder also contains 7 digital signature files for PAdES/XAdES signing support:

- `VNSASN1.xojo_code`
- `VNSX509Certificate.xojo_code`
- `VNSRSASigner.xojo_code`
- `VNSPKCS7Signer.xojo_code`
- `VNSPDFSignature.xojo_code`
- `VNSXMLCanonicalizer.xojo_code`
- `VNSXAdESSigner.xojo_code`

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
hasPremiumVNSEncryptionModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether premium encryption features (RC4-128, AES-128, AES-256) are available. If the flag is `False`, only the free RC4-40 encryption is available.

---

## Overview

The Premium Encryption module provides modern PDF encryption capabilities beyond the FREE version's basic RC4-40 support.

### Supported Encryption Standards

| Revision | Algorithm | Key Length | Hash | Status |
|----------|-----------|------------|------|--------|
| 2 (FREE) | RC4 | 40-bit | MD5 | ✅ Available in FREE |
| 3 | RC4 | 128-bit | MD5 (50 iterations) | ✅ PREMIUM |
| 4 | AES-CBC | 128-bit | MD5 (50 iterations) | ✅ PREMIUM |
| 5 | AES-CBC | 256-bit | SHA-256 | ✅ PREMIUM |
| 6 | AES-CBC | 256-bit | Algorithm 2.B (SHA-384/512) | ✅ PREMIUM |

---

## Features

### RC4-128 Encryption (Revision 3)

- 128-bit key length (vs 40-bit in FREE)
- 50-iteration MD5 key derivation for enhanced security
- Compatible with older PDF readers
- **Note**: Adobe Acrobat shows deprecation warnings for RC4

### AES-128 Encryption (Revision 4) - RECOMMENDED

- Industry standard AES-CBC encryption
- 128-bit key length
- No deprecation warnings in modern PDF readers
- Pure Xojo implementation (no external dependencies)
- Works on ALL platforms including iOS

### AES-256 Encryption (Revisions 5-6) - BEST

- Maximum security with 256-bit key length
- Revision 5: SHA-256 password hashing
- Revision 6: Algorithm 2.B with SHA-384/512
- Recommended for sensitive documents

---

## Usage

### Basic Usage

```xojo
// Create document
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Portrait, _
                              VNSPDFModule.ePageUnit.Millimeters, _
                              VNSPDFModule.ePageFormat.A4)

// Add content
pdf.SetFont("Helvetica", "", 12)
pdf.Cell(0, 10, "This document is encrypted with AES-128")

// Enable AES-128 encryption (RECOMMENDED)
pdf.SetProtection( _
    "userPassword", _    // Password to open document
    "ownerPassword", _   // Password for full access
    True, _              // Allow printing
    True, _              // Allow modifying
    True, _              // Allow copying
    True, _              // Allow annotations
    True, _              // Allow form filling
    True, _              // Allow extraction for accessibility
    True, _              // Allow page assembly
    True, _              // Allow high-quality printing
    VNSPDFModule.gkEncryptionAES128)  // Encryption type

// Save
Dim outFile As FolderItem = SpecialFolder.Desktop.Child("encrypted_aes128.pdf")
pdf.Save(outFile)
```

### Checking Module Availability

```xojo
If hasPremiumVNSEncryptionModule Then
    // Premium encryption available
    pdf.SetProtection(..., VNSPDFModule.gkEncryptionAES128)
Else
    // Fallback to FREE version (RC4-40)
    pdf.SetProtection(..., VNSPDFModule.gkEncryptionRC4_40)
End If
```

### Encryption Constants

```xojo
// Available in VNSPDFModule:
gkEncryptionRC4_40    // FREE - Revision 2 (WEAK)
gkEncryptionRC4_128   // PREMIUM - Revision 3
gkEncryptionAES128   // PREMIUM - Revision 4 (RECOMMENDED)
gkEncryptionAES256   // PREMIUM - Revisions 5-6 (BEST)
```

---

## API Reference

### Module Functions (VNSPDFEncryptionPremium)

```xojo
// RC4 encryption
Function EncryptRC4(data As String, key As String) As String

// AES-CBC encryption (no padding - data must be block-aligned)
Function EncryptAESCBCNoPadding(data As String, key As String, iv As String) As String

// SHA hashing (only SHA384 is public; SHA256 and SHA512 are internal helpers)
Function SHA384(data As String) As String

// Algorithm 2.B for Revision 6
Function ComputeHashR6(password As String, salt As String, userKey As String) As String

// Helpers
Function GenerateRandomIV() As String
Function PKCS7Pad(data As String, blockSize As Integer) As String
Function GetVersionString() As String
```

### VNSAESCore Class (Direct AES Operations)

```xojo
// Constructor - key length: 16 (AES-128), 24 (AES-192), or 32 (AES-256)
Sub Constructor(keyLength As Integer)
Sub SetKey(key As String)

// ECB Mode (Electronic Codebook)
Function EncryptECB(plaintext As String) As String
Function DecryptECB(ciphertext As String) As String

// CBC Mode (Cipher Block Chaining)
Sub SetIV(iv As String)
Function EncryptCBC(plaintext As String, iv As String) As String
Function DecryptCBC(ciphertext As String, iv As String) As String

// GCM Mode (Galois/Counter Mode - Authenticated Encryption)
Function EncryptGCM(plaintext As String, iv As String, aad As String, ByRef tag As String) As String
Function DecryptGCM(ciphertext As String, iv As String, aad As String, tag As String) As String

// PKCS7 Padding Helpers (for CBC mode)
Function PKCS7Pad(data As String) As String
Function PKCS7Unpad(data As String) As String

// Single Block Encryption
Function EncryptBlock(block As String) As String

// Error Handling
Function Ok() As Boolean
Function GetError() As VNSAESConstants.eAESError
```

### VNSAESConstants

```xojo
// Key lengths
kAESKeyLength128 = 16
kAESKeyLength192 = 24
kAESKeyLength256 = 32
kAESBlockLength = 16
kAESGCMIVLength = 12    // Standard GCM IV size
kAESGCMTagLength = 16   // Authentication tag size (128 bits)

// Modes
Enum eAESMode: ECB, CBC, GCM

// Error codes
Enum eAESError: None, InvalidKeyLength, InvalidBlockSize, InvalidIV,
                EncryptionFailed, DecryptionFailed, AuthenticationFailed,
                InvalidTagLength, InvalidPadding
```

---

## Implementation Details

### Key Derivation (RC4-128)

1. Pad passwords to 32 bytes using PDF standard padding
2. Compute owner entry using MD5 with 50 iterations
3. Compute encryption key using MD5 with 50 iterations
4. Each object gets unique key based on object number

### AES Implementation

- Based on Tiny AES-C reference implementation + NIST SP 800-38D (GCM)
- Pure Xojo code - no Declares required
- Works on all platforms including iOS
- Avoids Xojo Crypto.AES PKCS7 padding issues
- **ECB**: Electronic Codebook (encrypt/decrypt individual blocks)
- **CBC**: Cipher Block Chaining (encrypt/decrypt with IV, PKCS7 padding helpers)
- **GCM**: Galois/Counter Mode (authenticated encryption with AAD, 128-bit tag)
- Full inverse cipher: InvSubBytes, InvShiftRows, InvMixColumns (FIPS 197)
- GF(2^128) multiplication for GHASH (NIST SP 800-38D)
- Constant-time tag comparison for GCM decryption (timing-attack resistant)

### Algorithm 2.B (Revision 6)

- Uses SHA-256 for initial hash
- Iterative hashing with SHA-256/384/512 mixing
- 64+ iterations based on last hash byte
- AES-CBC key unwrapping

---

## Digital Signatures (PAdES-B-B & XAdES-BES)

The Encryption Premium Module also provides digital signature capabilities for PDF documents and XML invoice data.

### PAdES-B-B (PDF Signing)

Signs the entire PDF binary with a CMS/PKCS#7 detached signature per ETSI EN 319 142-1:

```xojo
// Generate RSA key pair (2048-bit)
Dim privateKey As MemoryBlock
Dim publicKey As MemoryBlock
Crypto.RSAGenerateKeyPair(2048, privateKey, publicKey)
Dim privateKeyHex As String = VNSASN1.BytesToHex(privateKey)

// Build or load X.509 certificate
Dim cert As VNSX509Certificate = BuildTestCertificate(privateKeyHex, publicKeyHex)

// Create PDF content
Dim pdf As New VNSPDFDocument(...)
// ... add content ...
Dim pdfData As String = pdf.Output()

// Sign the PDF with PAdES-B-B
Dim signedPdf As String = VNSPDFSignature.SignPDF( _
    pdfData, cert, privateKeyHex, _
    "Invoice authenticity", "Paris, France")
```

### XAdES-BES (XML Signing)

Signs CII XML invoice data before embedding in PDF, per ETSI EN 319 132-1:

```xojo
Dim signedXML As String = VNSXAdESSigner.SignXML(xml, cert, privateKeyHex)
```

### Implementation Details

- **Pure Xojo**: No OpenSSL or external dependencies - works on all platforms including iOS
- **RSA PKCS#1 v1.5**: sha256WithRSAEncryption (OID 1.2.840.113549.1.1.11)
- **CRT optimization**: Chinese Remainder Theorem for ~12x faster 2048-bit RSA signing
- **Self-verify**: Automatic verification after each signature with naive modpow fallback
- **CMS structure**: RFC 5652 SignedData with signed attributes (contentType, signingTime, messageDigest, signing-certificate-v2)
- **ByteRange**: ISO 32000-2 compliant incremental update with /Sig dictionary and /AcroForm

### New Module Files

| File | Description |
|------|-------------|
| `VNSASN1.xojo_code` | ASN.1 DER encoder/decoder |
| `VNSX509Certificate.xojo_code` | X.509 certificate parser |
| `VNSRSASigner.xojo_code` | Pure Xojo RSA PKCS#1 v1.5 with CRT |
| `VNSPKCS7Signer.xojo_code` | CMS/PKCS#7 SignedData builder |
| `VNSPDFSignature.xojo_code` | PAdES PDF-level signature integration |
| `VNSXMLCanonicalizer.xojo_code` | W3C XML Canonicalization (C14N) |
| `VNSXAdESSigner.xojo_code` | XAdES-BES XML signature builder |

---

## Security Recommendations

1. **Use AES-128 or AES-256** - RC4 is deprecated
2. **Use strong passwords** - Mix upper/lower/numbers/symbols
3. **Different user/owner passwords** - For different access levels
4. **Restrict permissions appropriately** - Only enable what's needed

---

## Compatibility

| PDF Reader | RC4-40 | RC4-128 | AES-128 | AES-256 |
|------------|--------|---------|---------|---------|
| Adobe Acrobat | ✅ | ✅⚠️ | ✅ | ✅ |
| Preview (macOS) | ✅ | ✅ | ✅ | ✅ |
| Chrome PDF | ✅ | ✅ | ✅ | ✅ |
| Firefox PDF | ✅ | ✅ | ✅ | ✅ |

⚠️ = Shows deprecation warning

---

*Last Updated: 2026-02-14*
