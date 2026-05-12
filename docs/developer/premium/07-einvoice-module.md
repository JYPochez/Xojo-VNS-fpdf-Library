# VNSPDFEInvoicePremium Module

**Status**: ✅ Available
**Location**: `PDF_Library/Premium/EInvoiceModule/`
**Module Flag**: `hasPremiumVNSEInvoiceModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create an `EInvoiceModule` subfolder inside it. Drag the following files into that folder:

- `VNSPDFEInvoicePremium.xojo_code` — Main module (create, read, validate)
- `VNSPDFEInvoice.xojo_code` — Invoice data model
- `VNSPDFEInvoiceParty.xojo_code` — Seller/buyer party data model
- `VNSPDFEInvoiceLineItem.xojo_code` — Line item data model
- `VNSPDFEInvoiceAllowanceCharge.xojo_code` — Allowance/charge data model (BG-20/BG-21/BG-27/BG-28)
- `VNSPDFEInvoiceTaxBreakdown.xojo_code` — Tax breakdown data model
- `VNSPDFEInvoiceXMLGenerator.xojo_code` — CII XML generator (write direction)
- `VNSPDFEInvoiceXMLParser.xojo_code` — CII XML parser (read direction)
- `VNSPDFEInvoiceValidator.xojo_code` — Profile-aware validation

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
hasPremiumVNSEInvoiceModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether e-invoice features are available.

---

## Overview

The E-Invoice Premium Module provides full Factur-X and ZUGFeRD electronic invoicing capabilities for EU-compliant B2B invoicing. It supports both **creating** e-invoice PDFs with embedded CII XML and **reading** existing PDFs to extract and validate their e-invoice data.

### EU ViDA Mandate

The EU Value in Digital Age (ViDA) directive mandates structured electronic invoicing for B2B transactions starting 2026-2027. Factur-X (France/EU) and ZUGFeRD (Germany) are the primary hybrid PDF standards, combining human-readable PDF with machine-readable CII XML.

### Supported Standards

| Standard | Version | XML Format | Filename |
|----------|---------|------------|----------|
| Factur-X | 1.0 | UN/CEFACT CII | `factur-x.xml` |
| ZUGFeRD | 2.0 | UN/CEFACT CII | `zugferd-invoice.xml` |

### Conformance Profiles

| Profile | Level | Line Items | Description |
|---------|-------|------------|-------------|
| MINIMUM | 0 | No | Basic invoice identification only |
| BASIC WL | 1 | No | Without line items, payment details required |
| BASIC | 2 | Yes | Line items with product/quantity/price |
| EN 16931 | 3 | Yes | Full EU standard compliance (recommended) |
| EXTENDED | 4 | Yes | Additional fields beyond EN 16931 |

---

## Features

### Creating E-Invoice PDFs

- Generate Factur-X or ZUGFeRD compliant PDF/A-3b documents
- Embedded CII (CrossIndustryInvoice) XML per EN 16931
- Self-contained PDF/A-3b: sRGB ICC output intent, XMP metadata with extension schemas
- Profile-aware validation before generation (rejects invalid invoices)
- No dependency on the PDF/A premium module

### Reading E-Invoice PDFs (ReadEInvoice)

- Open any PDF file and check if it contains a valid Factur-X/ZUGFeRD e-invoice
- Extract embedded CII XML from PDF catalog structure
- Parse XML into structured invoice data model
- Validate against detected profile
- Return complete results as JSON with error codes and warnings
- Detect common XML format issues (comma decimals, invalid dates, wrong currency codes)
- **Digital signature detection**: find PDF signatures (PAdES), verify hash integrity, check certificate info
- Report signer name, reason, location, date, filter/subfilter, field name
- SHA-256 hash verification (signatureValid) and whole-file coverage check
- X.509 certificate subject/issuer extraction and self-signed detection

---

## Usage

### Creating a Factur-X Invoice

```xojo
// 1. Create invoice data (all precision defaults to 2 decimal places)
Dim invoice As New VNSPDFEInvoice
invoice.InvoiceNumber = "INV-2026-001"
invoice.InvoiceDate = New DateTime(2026, 2, 14)
invoice.DueDate = New DateTime(2026, 3, 14)
invoice.Currency = "EUR"
invoice.InvoiceTypeCode = "380"
invoice.BuyerReference = "PO-2026-042"
invoice.PaymentMeansCode = "30"
invoice.IBAN = "FR7630001007941234567890185"
invoice.BIC = "BNPAFRPP"

// 2. Set seller
Dim seller As New VNSPDFEInvoiceParty
seller.Name = "Acme Corp"
seller.VATNumber = "FR12345678901"
seller.AddressLine1 = "123 Main Street"
seller.City = "Paris"
seller.PostalCode = "75001"
seller.CountryCode = "FR"
invoice.Seller = seller

// 3. Set buyer
Dim buyer As New VNSPDFEInvoiceParty
buyer.Name = "Client Ltd"
buyer.VATNumber = "DE987654321"
buyer.AddressLine1 = "456 Oak Avenue"
buyer.City = "Berlin"
buyer.PostalCode = "10115"
buyer.CountryCode = "DE"
invoice.Buyer = buyer

// 4. Add line items
Dim item1 As New VNSPDFEInvoiceLineItem
item1.LineID = "1"
item1.ProductName = "Consulting Services"
item1.Quantity = 10
item1.UnitCode = "HUR"
item1.UnitPrice = 150.00
// NetAmount is auto-computed (Quantity x UnitPrice - allowances + charges) per EN 16931 BT-131
item1.TaxRate = 20.0
item1.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
invoice.AddLineItem(item1)

// 5. Add line-level discount (10% volume discount on item1)
Dim lineDiscount As New VNSPDFEInvoiceAllowanceCharge
lineDiscount.IsCharge = False              // False = allowance (discount)
lineDiscount.Amount = 150.00               // 10% of 1500
lineDiscount.Percentage = 10.0
lineDiscount.BasisAmount = 1500.00
lineDiscount.Reason = "Volume discount"
lineDiscount.ReasonCode = "95"             // UNTDID 5189 code for discount
lineDiscount.TaxRate = 20.0
lineDiscount.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
item1.AddAllowanceCharge(lineDiscount)
// item1.NetAmount is now 1350.00 (1500 - 150)

// 6. Add document-level charge (shipping)
Dim shipping As New VNSPDFEInvoiceAllowanceCharge
shipping.IsCharge = True                   // True = charge (surcharge)
shipping.Amount = 25.00
shipping.Reason = "Shipping and handling"
shipping.ReasonCode = "FC"                 // UNTDID 7161 code for freight
shipping.TaxRate = 20.0
shipping.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
invoice.AddAllowanceCharge(shipping)

// 7. Add tax breakdown (adjusted for allowances/charges)
// Tax basis = LineTotalAmount(1350) - DocAllowances(0) + DocCharges(25) = 1375
Dim tax As New VNSPDFEInvoiceTaxBreakdown
tax.TaxableAmount = 1375.00
tax.TaxAmount = 275.00
tax.TaxRate = 20.0
tax.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
invoice.AddTaxBreakdown(tax)
// Totals are computed automatically:
// LineTotalAmount = 1350.00, TaxBasisTotalAmount = 1375.00
// GrandTotalAmount = 1375.00 + 275.00 = 1650.00

// 7. Create PDF and embed e-invoice
Dim pdf As New VNSPDFDocument
pdf.SetFont("Helvetica", "", 12)
pdf.Cell(0, 10, "Invoice INV-2026-001")
// ... add visual invoice layout ...

VNSPDFEInvoicePremium.CreateFacturXInvoice(pdf, invoice, _
    VNSPDFEInvoicePremium.eFacturXProfile.EN16931)

Dim outFile As FolderItem = SpecialFolder.Desktop.Child("invoice_facturx.pdf")
pdf.Save(outFile)
```

### Creating a ZUGFeRD Invoice

```xojo
// Same invoice data setup as above, then:
VNSPDFEInvoicePremium.CreateZUGFeRDInvoice(pdf, invoice, _
    VNSPDFEInvoicePremium.eFacturXProfile.EN16931)
```

### Reading an E-Invoice PDF

```xojo
// Read from file path
Dim result As JSONItem = VNSPDFEInvoicePremium.ReadEInvoice("/path/to/invoice.pdf")

// Or read from in-memory data
Dim pdfData As String = myBinaryStream.Read(myBinaryStream.Length)
Dim result As JSONItem = VNSPDFEInvoicePremium.ReadEInvoiceFromData(pdfData)

// Check result using type-safe enum keys
Dim k As VNSPDFEInvoicePremium.eInvoiceJSONKey  // shorthand alias

If result.Value(k.Valid.ToString) = True Then
  Dim invoiceJSON As JSONItem = result.Value(k.Invoice.ToString)
  Dim invoiceNumber As String = invoiceJSON.Value(k.InvoiceNumber.ToString)
  Dim grandTotal As String = invoiceJSON.Value(k.GrandTotalAmount.ToString)
  Dim standard As String = result.Value(k.Standard.ToString)   // "Factur-X" or "ZUGFeRD"
  Dim profile As String = result.Value(k.Profile.ToString)      // "EN 16931", etc.
  Dim warningCount As Integer = result.Value(k.WarningCount.ToString)
Else
  Dim errorCode As String = result.Value(k.ErrorCode.ToString)  // "EINV-001", etc.
  Dim errorMsg As String = result.Value(k.Error.ToString)
End If
```

### Reading Signature Info from E-Invoice PDFs

```xojo
Dim result As JSONItem = VNSPDFEInvoicePremium.ReadEInvoice("/path/to/signed_invoice.pdf")
Dim k As VNSPDFEInvoicePremium.eInvoiceJSONKey

Dim sigCount As Integer = result.Value(k.SignatureCount.ToString)
If sigCount > 0 Then
  Dim sigs As JSONItem = result.Value(k.Signatures.ToString)
  For i As Integer = 0 To sigs.Count - 1
    Dim sig As JSONItem = sigs.ChildAt(i)
    Dim signer As String = sig.Value(k.SignerName.ToString)
    Dim valid As Boolean = sig.Value(k.SignatureValid.ToString)
    Dim covers As Boolean = sig.Value(k.SignatureCoversWholeFile.ToString)
    Dim selfSigned As Boolean = sig.Value(k.SelfSigned.ToString)
    // Display or process signature info...
  Next
End If
```

### Checking Module Availability

```xojo
If hasPremiumVNSEInvoiceModule Then
  // E-Invoice features available
  VNSPDFEInvoicePremium.CreateFacturXInvoice(pdf, invoice, profile)
End If
```

---

## ReadEInvoice JSON Output

### Conformant Invoice

```json
{
  "valid": true,
  "errorCode": "EINV-000",
  "error": "",
  "standard": "Factur-X",
  "profile": "EN 16931",
  "invoice": {
    "invoiceNumber": "INV-2026-001",
    "invoiceDate": "2026-02-14",
    "dueDate": "2026-03-14",
    "currency": "EUR",
    "invoiceTypeCode": "380",
    "buyerReference": "PO-2026-042",
    "paymentMeansCode": "30",
    "iban": "FR7630001007941234567890185",
    "bic": "BNPAFRPP",
    "paymentReference": "",
    "note": "",
    "seller": {
      "name": "Acme Corp",
      "vatNumber": "FR12345678901",
      "addressLine1": "123 Main Street",
      "city": "Paris",
      "postalCode": "75001",
      "countryCode": "FR"
    },
    "buyer": {
      "name": "Client Ltd",
      "vatNumber": "DE987654321",
      "addressLine1": "456 Oak Avenue",
      "city": "Berlin",
      "postalCode": "10115",
      "countryCode": "DE"
    },
    "lineItems": [
      {
        "lineID": "1",
        "productName": "Consulting Services",
        "quantity": 10.0,
        "unitCode": "HUR",
        "unitPrice": "150",
        "netAmount": "1500",
        "taxRate": "20",
        "taxCategoryCode": "S"
      }
    ],
    "taxBreakdowns": [
      {
        "taxableAmount": "1500",
        "taxAmount": "300",
        "taxRate": "20",
        "taxCategoryCode": "S"
      }
    ],
    "lineTotalAmount": "1500",
    "taxTotalAmount": "300",
    "grandTotalAmount": "1800"
  },
  "warnings": [],
  "warningCount": 0,
  "signatureCount": 1,
  "signatures": [
    {
      "signerName": "C=FR, O=VeryniceSW, CN=VNS PDF Test Signer",
      "signingReason": "E-Invoice Signing",
      "signingLocation": "Paris, France",
      "signingDate": "D:20260214120000+00'00'",
      "signatureFilter": "Adobe.PPKLite",
      "signatureSubFilter": "ETSI.CAdES.detached",
      "signatureFieldName": "Signature1",
      "signatureValid": true,
      "signatureCoversWholeFile": true,
      "certificateSubject": "C=FR, O=VeryniceSW, CN=VNS PDF Test Signer",
      "certificateIssuer": "C=FR, O=VeryniceSW, CN=VNS PDF Test Signer",
      "selfSigned": true
    }
  ]
}
```

### Non-Conformant Result

```json
{
  "valid": false,
  "errorCode": "EINV-002",
  "error": "EINV-002 No embedded XML attachment found",
  "standard": "",
  "profile": ""
}
```

---

## Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| EINV-000 | `kErrCodeNoError` | No error, invoice is conformant |
| EINV-001 | `kErrCodeInvalidPDF` | PDF failed to open or parse |
| EINV-002 | `kErrCodeNoXMLAttachment` | No embedded e-invoice XML found in PDF |
| EINV-003 | `kErrCodeXMLParseFailed` | CII XML content could not be parsed into invoice model |
| EINV-004 | `kErrCodeValidationFailed` | Invoice parsed but failed profile validation |
| EINV-005 | `kErrCodeZUGFeRD1Obsolete` | ZUGFeRD 1.0 detected (obsolete, unsupported) |

All error code constants are **Public** scope, accessible as `VNSPDFEInvoicePremium.kErrCodeNoError`, etc.

---

## XML Validation Warnings

ReadEInvoice performs additional XML-level format checks and returns warnings (non-blocking issues). Warnings are included in the JSON result even when `valid` is `true`.

### Numeric Format Warnings

| Code | Description |
|------|-------------|
| EINV-W01 | Comma used as decimal separator instead of dot (auto-corrected) |
| EINV-W02 | Thousand separator or spaces in number (auto-corrected) |
| EINV-W03 | Currency symbol embedded in numeric value (auto-corrected) |
| EINV-W04 | Value cannot be parsed as a valid number |

### Date Format Warnings

| Code | Description |
|------|-------------|
| EINV-W10 | Date format code is not 102 (YYYYMMDD) |
| EINV-W11 | Date contains separators, wrong length, or non-numeric characters |
| EINV-W12 | Date has invalid month, day, or unusual year |

### Code Validation Warnings

| Code | Description |
|------|-------------|
| EINV-W20 | Currency code is not 3 characters or not uppercase (ISO 4217) |
| EINV-W21 | Currency code is not a commonly used ISO 4217 currency |
| EINV-W22 | Country code is not 2 characters or not uppercase (ISO 3166-1) |

### Business Logic Warnings

| Code | Description |
|------|-------------|
| EINV-W30 | Invoice type code is not a recognized UN/CEFACT code |
| EINV-W31 | Negative due payable amount on a standard invoice (type 380) |
| EINV-W40 | Missing required CII XML structure element |

---

## API Reference

### VNSPDFEInvoicePremium (Main Module)

```xojo
// Create e-invoice PDFs
Sub CreateFacturXInvoice(doc As VNSPDFDocument, invoice As VNSPDFEInvoice, _
    profile As eFacturXProfile)
Sub CreateZUGFeRDInvoice(doc As VNSPDFDocument, invoice As VNSPDFEInvoice, _
    profile As eFacturXProfile)

// Read e-invoice PDFs
Function ReadEInvoice(filePath As String) As JSONItem
Function ReadEInvoiceFromData(pdfData As String) As JSONItem

// Utility
Function GetVersionString() As String

// Profile enum
Enum eFacturXProfile
  Minimum = 0
  BasicWL = 1
  Basic = 2
  EN16931 = 3
  Extended = 4
End Enum

// Tax category codes (UNTDID 5305)
Enum eTaxCategoryCode
  StandardRate = 0       // "S" - Standard VAT rate
  ZeroRated = 1          // "Z" - Zero-rated goods/services
  Exempt = 2             // "E" - VAT exempt
  ReverseCharge = 3      // "AE" - Reverse charge (B2B cross-border)
  IntraCommunitySupply = 4  // "K" - Intra-community supply (EU)
  ExportOutsideEU = 5    // "G" - Export outside EU (free of VAT)
  OutsideScopeOfVAT = 6  // "O" - Outside scope of VAT
  CanaryIslandsTax = 7   // "L" - Canary Islands IGIC tax
  CeutaMelillaTax = 8    // "M" - Ceuta and Melilla IPSI tax
End Enum

// Enum extension methods (defined in VNSPDFEInvoicePremium module scope)

// eInvoiceJSONKey — type-safe JSON key access for ReadEInvoice results
Enum eInvoiceJSONKey
  // Result-level keys (0-7)
  Valid = 0, ErrorCode = 1, Error = 2, Standard = 3, Profile = 4
  Invoice = 5, Warnings = 6, WarningCount = 7
  // Invoice-level keys (10-27)
  InvoiceNumber = 10, InvoiceDate = 11, DueDate = 12, Currency = 13
  InvoiceTypeCode = 14, BuyerReference = 15, PaymentMeansCode = 16
  IBAN = 17, BIC = 18, PaymentReference = 19, Note = 20, Seller = 21
  Buyer = 22, LineItems = 23, TaxBreakdowns = 24, LineTotalAmount = 25
  TaxTotalAmount = 26, GrandTotalAmount = 27
  // Party-level keys (30-40)
  Name = 30, VATNumber = 31, LegalRegistrationID = 32, AddressLine1 = 33
  AddressLine2 = 34, City = 35, PostalCode = 36, CountryCode = 37
  ContactName = 38, ContactEmail = 39, ContactPhone = 40
  // Line item-level keys (50-58)
  LineID = 50, ProductName = 51, ProductDescription = 52, Quantity = 53
  UnitCode = 54, UnitPrice = 55, NetAmount = 56, TaxRate = 57
  TaxCategoryCode = 58
  // Tax breakdown-level keys (60-61)
  TaxableAmount = 60, TaxAmount = 61
  // Signature-level keys (70-83)
  Signatures = 70, SignatureCount = 71, SignerName = 72, SigningReason = 73
  SigningLocation = 74, SigningDate = 75, SignatureFilter = 76
  SignatureSubFilter = 77, SignatureCoversWholeFile = 78
  SignatureFieldName = 79, SignatureValid = 80, SelfSigned = 81
  CertificateSubject = 82, CertificateIssuer = 83
End Enum
Function ToString(Extends key As eInvoiceJSONKey) As String    // enum → JSON key string
Function ToEInvoiceJSONKey(Extends key As String) As eInvoiceJSONKey  // JSON key string → enum

// eTaxCategoryCode — UNTDID 5305 VAT category codes
Function ToString(Extends code As eTaxCategoryCode) As String   // enum → XML code ("S", "AE", etc.)
Function ToTaxCategory(Extends code As String) As eTaxCategoryCode  // XML code → enum

// eFacturXProfile — conformance profile conversion
Function ToString(Extends profile As eFacturXProfile) As String  // enum → conformance level string
Function ToFacturXProfile(Extends profile As String) As eFacturXProfile  // string → enum

// Error code constants (Public)
Const kErrCodeNoError = "EINV-000"
Const kErrCodeInvalidPDF = "EINV-001"
Const kErrCodeNoXMLAttachment = "EINV-002"
Const kErrCodeXMLParseFailed = "EINV-003"
Const kErrCodeValidationFailed = "EINV-004"
Const kErrCodeZUGFeRD1Obsolete = "EINV-005"

// Standard filenames (Public)
Const kFacturXFilename = "factur-x.xml"
Const kZUGFeRDFilename = "zugferd-invoice.xml"
```

### VNSPDFEInvoice (Data Model)

```xojo
// Invoice identification
Property InvoiceNumber As String
Property InvoiceDate As DateTime
Property DueDate As DateTime
Property InvoiceTypeCode As String       // "380" = Invoice, "381" = Credit note
Property Currency As String              // ISO 4217 (e.g. "EUR")

// References
Property BuyerReference As String
Property PaymentReference As String
Property Note As String

// Payment
Property PaymentMeansCode As String      // "30" = Credit transfer, "42" = Payment to bank account
Property IBAN As String
Property BIC As String

// Parties
Property Seller As VNSPDFEInvoiceParty
Property Buyer As VNSPDFEInvoiceParty

// Totals
Function LineTotalAmount() As Double         // Sum of line net amounts
Function AllowanceTotalAmount() As Double    // Sum of doc-level allowances (BT-107)
Function ChargeTotalAmount() As Double       // Sum of doc-level charges (BT-108)
Function TaxBasisTotalAmount() As Double     // LineTotalAmount - Allowances + Charges (BT-109)
Function TaxTotalAmount() As Double
Function GrandTotalAmount() As Double        // TaxBasisTotalAmount + TaxTotalAmount

// Collections
Sub AddLineItem(item As VNSPDFEInvoiceLineItem)
Sub AddTaxBreakdown(tb As VNSPDFEInvoiceTaxBreakdown)
Sub AddAllowanceCharge(ac As VNSPDFEInvoiceAllowanceCharge)
Function LineItems() As VNSPDFEInvoiceLineItem()
Function TaxBreakdowns() As VNSPDFEInvoiceTaxBreakdown()
Function AllowancesCharges() As VNSPDFEInvoiceAllowanceCharge()
```

---

## EN 16931 Property Reference

All properties below map to EN 16931:2017 business terms (BT). Cardinality: **M** = Mandatory, **C** = Conditional, **O** = Optional.

### VNSPDFEInvoice — Invoice Header

| Property | BT | M/C/O | Type | Description | Example |
|----------|-----|-------|------|-------------|---------|
| `InvoiceNumber` | BT-1 | **M** | String | Unique sequential invoice identifier | `"INV-2026-0042"` |
| `InvoiceDate` | BT-2 | **M** | DateTime | Invoice issue date | `DateTime.Now` |
| `InvoiceTypeCode` | BT-3 | **M** | String | UNTDID 1001 code: 380=Invoice, 381=Credit note, 389=Self-billed | `"380"` |
| `Currency` | BT-5 | **M** | String | ISO 4217 currency code | `"EUR"` |
| `DueDate` | BT-9 | O | DateTime | Payment due date | `New DateTime(2026, 4, 30)` |
| `BuyerReference` | BT-10 | **C** | String | Buyer's reference or PO number. Mandatory in France B2G and EN 16931 profile | `"PO-2026-1234"` |
| `ProjectReference` | BT-11 | O | String | Project reference for project billing | `"PROJ-2026-007"` |
| `ContractReference` | BT-12 | O | String | Contract reference number | `"CONTRACT-2025-100"` |
| `PurchaseOrderReference` | BT-13 | O | String | Buyer's purchase order number | `"PO-98765"` |
| `PaymentTerms` | BT-20 | O | String | Payment terms description text | `"Net 30 days, 2% discount if paid within 10 days"` |
| `PrecedingInvoiceNumber` | BT-25 | O | String | Original invoice number (for credit notes) | `"INV-2026-0038"` |
| `PrecedingInvoiceDate` | BT-26 | O | DateTime | Original invoice date | `New DateTime(2026, 1, 15)` |
| `InvoicePeriodStart` | BT-73 | O | DateTime | Invoicing period start date (for service invoices) | `New DateTime(2026, 1, 1)` |
| `InvoicePeriodEnd` | BT-74 | O | DateTime | Invoicing period end date | `New DateTime(2026, 3, 31)` |
| `Seller` | BG-4 | **M** | Party | Seller party (see below) | |
| `Buyer` | BG-7 | **M** | Party | Buyer party (see below) | |
| `DeliveryDate` | BT-72 | O | DateTime | Actual delivery date | `DateTime.Now` |
| `DeliveryLocationID` | BT-71 | O | String | Deliver-to location identifier (GLN, etc.) | `"7300010000001"` |
| `DeliveryAddress` | BG-15 | O | Party | Deliver-to address (when different from buyer) | |

**Payment (BG-16/BG-17):**

| Property | BT | M/C/O | Type | Description | Example |
|----------|-----|-------|------|-------------|---------|
| `PaymentMeansCode` | BT-81 | **M** | String | UNTDID 4461: 30=Credit transfer, 58=SEPA, 48=Bank card | `"30"` |
| `PaymentReference` | BT-83 | O | String | Remittance information / structured reference | `"INV-2026-0042"` |
| `IBAN` | BT-84 | **C** | String | Payment account IBAN. Required for credit transfer (code 30/58) | `"FR7630006000011234567890189"` |
| `BIC` | BT-86 | O | String | BIC/SWIFT code of the bank | `"BNPAFRPPXXX"` |

**Payee (BG-10) — when payment goes to a different entity than seller:**

| Property | BT | M/C/O | Type | Description | Example |
|----------|-----|-------|------|-------------|---------|
| `PayeeName` | BT-59 | **M** if payee | String | Payee name (mandatory if BG-10 is used) | `"Collection Agency Ltd"` |
| `PayeeIdentifier` | BT-60 | O | String | Payee identifier | `"COLL-001"` |
| `PayeeLegalRegistrationID` | BT-61 | O | String | Payee legal registration ID | `"HRB 98765"` |

**CII XML decimal precision (constructor or properties):**

```xojo
// Default: all 2 decimal places
Dim invoice As New VNSPDFEInvoice

// Custom precision: amounts=2, prices=5, quantities=3, percents=2
Dim invoice As New VNSPDFEInvoice(2, 5, 3, 2)

// Or set via properties after construction
invoice.PricePrecision = 4
```

| Property | Default | Max (EN 16931) | Description |
|----------|---------|----------------|-------------|
| `AmountPrecision` | 2 | 2 | Monetary amounts (BT-131, BT-116, etc.) |
| `PricePrecision` | 2 | 8 | Unit prices (BT-146, BT-148) |
| `QuantityPrecision` | 2 | 6 | Quantities (BT-129) |
| `PercentPrecision` | 2 | 4 | Tax rates, allowance percentages |

Trailing zeros are trimmed when precision > 2, keeping a minimum of 2 decimal places (e.g., `0.00250` with precision 5 outputs `"0.0025"`, `20.00` with precision 4 outputs `"20.00"`).

**Computed totals (read-only):**

| Method | BT | Description |
|--------|-----|-------------|
| `LineTotalAmount()` | BT-106 | Sum of all line net amounts |
| `AllowanceTotalAmount()` | BT-107 | Sum of document-level allowances |
| `ChargeTotalAmount()` | BT-108 | Sum of document-level charges |
| `TaxBasisTotalAmount()` | BT-109 | = LineTotalAmount - AllowanceTotalAmount + ChargeTotalAmount |
| `TaxTotalAmount()` | BT-110 | Sum of all tax breakdown amounts |
| `GrandTotalAmount()` | BT-112 | = TaxBasisTotalAmount + TaxTotalAmount |

**Collections:**

```xojo
Sub AddLineItem(item As VNSPDFEInvoiceLineItem)       // At least one required
Sub AddTaxBreakdown(tb As VNSPDFEInvoiceTaxBreakdown)  // At least one required
Sub AddAllowanceCharge(ac As VNSPDFEInvoiceAllowanceCharge)  // Document-level
Sub AddNote(content As String, subjectCode As String = "")   // BT-22 + BT-21
```

### VNSPDFEInvoiceParty — Seller/Buyer/Delivery Address

Used for BG-4 (Seller), BG-7 (Buyer), and BG-15 (Delivery address).

| Property | BT (Seller/Buyer) | M/C/O | Type | Description | Example |
|----------|-------------------|-------|------|-------------|---------|
| `Name` | BT-27 / BT-44 | **M** | String | Legal name of the party | `"VeryNiceSW SARL"` |
| `VATNumber` | BT-31 / BT-48 | **C** | String | VAT identifier with country prefix. Required if VAT applies | `"FR12345678901"` |
| `LegalRegistrationID` | BT-30 / BT-47 | O | String | Legal registration (SIREN, HRB, etc.) | `"123456789"` |
| `LegalRegistrationScheme` | BT-30-1 | O | String | Scheme ID for legal registration (0002=SIREN, 0106=KvK) | `"0002"` |
| `AddressLine1` | BT-35 / BT-50 | O | String | Street address line 1 | `"42 Rue de la Paix"` |
| `AddressLine2` | BT-36 / BT-51 | O | String | Street address line 2 | `"Building B, 3rd floor"` |
| `City` | BT-37 / BT-52 | O | String | City name | `"Paris"` |
| `PostalCode` | BT-38 / BT-53 | O | String | Postal/ZIP code | `"75002"` |
| `CountryCode` | BT-40 / BT-55 | **M** | String | ISO 3166-1 alpha-2 country code | `"FR"` |
| `ContactName` | BT-41 / BT-56 | O | String | Contact person name | `"Jean-Yves Pochez"` |
| `ContactEmail` | BT-43 / BT-58 | O | String | Contact email address | `"contact@verynicesw.com"` |
| `ContactPhone` | BT-42 / BT-57 | O | String | Contact telephone number | `"+33 1 42 00 00 00"` |
| `ElectronicAddress` | BT-34 / BT-49 | **M** | String | Electronic address for e-invoicing | `"contact@verynicesw.com"` |
| `ElectronicAddressScheme` | BT-34-1 | **M** | String | Scheme ID: EM=email, 0201=IT Codice | `"EM"` |

### VNSPDFEInvoiceLineItem — Invoice Line (BG-25)

| Property | BT | M/C/O | Type | Description | Example |
|----------|-----|-------|------|-------------|---------|
| `LineID` | BT-126 | **M** | String | Unique line identifier within the invoice | `"1"` |
| `ProductName` | BT-153 | **M** | String | Item name | `"Consulting Services"` |
| `ProductDescription` | BT-154 | O | String | Item description | `"Senior developer, React migration"` |
| `Quantity` | BT-129 | **M** | Double | Invoiced quantity | `10.0` |
| `UnitCode` | BT-130 | **M** | String | UN/ECE Rec 20 unit code: C62=unit, HUR=hour, KGM=kg, MTR=meter, LTR=liter, DAY=day | `"HUR"` |
| `UnitPrice` | BT-146 | **M** | Double | Item net price (after any price-level discount) | `150.00` |
| `GrossPrice` | BT-148 | O | Double | Item gross price before price-level allowances. Set to 0 to omit | `200.00` |
| `TaxRate` | BT-152 | **C** | Double | VAT rate percentage. Required when TaxCategoryCode = S | `20.0` |
| `TaxCategoryCode` | BT-151 | **M** | Enum | VAT category (see codes below) | `.StandardRate` |
| `SellerItemID` | BT-155 | O | String | Seller's item identifier (SKU, article number) | `"LIB-DESK-001"` |
| `StandardItemID` | BT-157 | O | String | Standard item identifier (GTIN, EAN, ISBN) | `"4012345678901"` |
| `StandardItemSchemeID` | BT-157-1 | O | String | Scheme: 0160=GTIN, 0088=EAN | `"0160"` |
| `LinePeriodStart` | BT-134 | O | DateTime | Service period start for this line | `New DateTime(2026, 3, 1)` |
| `LinePeriodEnd` | BT-135 | O | DateTime | Service period end for this line | `New DateTime(2026, 3, 31)` |

**Computed:**

| Method | BT | Description |
|--------|-----|-------------|
| `NetAmount()` | BT-131 | = Quantity x UnitPrice - line allowances + line charges |
| `AllowanceTotalAmount()` | | Sum of line-level allowance amounts |
| `ChargeTotalAmount()` | | Sum of line-level charge amounts |

### VNSPDFEInvoiceAllowanceCharge — Allowance or Charge

Used for document-level (BG-20/BG-21) and line-level (BG-27/BG-28).

| Property | BT (doc/line) | M/C/O | Type | Description | Example |
|----------|--------------|-------|------|-------------|---------|
| `IsCharge` | | **M** | Boolean | `False` = allowance (discount), `True` = charge (surcharge) | `False` |
| `Amount` | BT-92/BT-136 | **M** | Double | Actual allowance/charge amount (always positive) | `150.00` |
| `BasisAmount` | BT-93/BT-137 | O | Double | Base amount for percentage calculation | `1500.00` |
| `Percentage` | BT-94/BT-138 | **C** | Double | Percentage. Required if BasisAmount is given | `10.0` |
| `Reason` | BT-97/BT-139 | O | String | Text reason. At least one of Reason or ReasonCode required (doc-level) | `"Volume discount"` |
| `ReasonCode` | BT-98/BT-140 | **C** | String | UNTDID 5189 (allowances) or 7161 (charges). See codes below | `"95"` |
| `TaxCategoryCode` | BT-95 | **M** (doc) | Enum | VAT category. Required for document-level, inherited for line-level | `.StandardRate` |
| `TaxRate` | BT-96 | **C** (doc) | Double | VAT rate. Required for document-level when category = S | `20.0` |

**Common allowance reason codes (UNTDID 5189):** 41=Bonus, 42=Special agreement, 60=Manufacturer discount, 62=Trade discount, 63=Early payment, 64=Volume discount, 65=Retailing, 66=Standard, 67=Contract, 95=Discount, 100=Special rebate, 104=Freight charge reduction

**Common charge reason codes (UNTDID 7161):** AAA=Advertising, ABL=Packing, ADR=Dangerous goods, FC=Freight, FI=Financing, IN=Insurance, MAC=Minimum order charge, TAE=Environmental tax

### VNSPDFEInvoiceTaxBreakdown — VAT Breakdown (BG-23)

At least one required. One per unique combination of tax category + rate.

| Property | BT | M/C/O | Type | Description | Example |
|----------|-----|-------|------|-------------|---------|
| `TaxableAmount` | BT-117 | **M** | Double | Taxable base = sum of line nets + doc charges - doc allowances at this rate | `1375.00` |
| `TaxAmount` | BT-116 | **M** | Double | VAT amount = TaxableAmount x TaxRate / 100 | `275.00` |
| `TaxRate` | BT-119 | **C** | Double | VAT rate percentage. Required when category = S | `20.0` |
| `TaxCategoryCode` | BT-118 | **M** | Enum | VAT category code | `.StandardRate` |

### VAT Category Codes (eTaxCategoryCode)

| Code | Enum Value | Meaning |
|------|-----------|---------|
| S | `.StandardRate` | Standard rate (default) |
| Z | `.ZeroRated` | Zero rated goods |
| E | `.Exempt` | VAT exempt |
| AE | `.ReverseCharge` | Reverse charge (buyer pays VAT) |
| K | `.IntraCommunitySupply` | Intra-community supply (EU B2B) |
| G | `.ExportOutsideEU` | Export outside EU |
| O | `.OutsideScopeOfVAT` | Outside scope of VAT |
| L | `.CanaryIslandsTax` | Canary Islands general tax (IGIC) |
| M | `.CeutaMelillaTax` | Ceuta and Melilla tax (IPSI) |

### VNSPDFEInvoiceXMLParser

```xojo
// Parse CII XML into data model
Function ParseCII(xmlContent As String) As VNSPDFEInvoice

// Detect standard/profile from XML content
Function DetectStandard(xmlContent As String, xmlFilename As String = "") As String   // "Factur-X", "ZUGFeRD", or "XRechnung"
Function DetectProfile(xmlContent As String) As String     // "EN 16931", "BASIC", "EXTENDED", etc.

// Serialize invoice to JSON
Function InvoiceToJSON(invoice As VNSPDFEInvoice) As JSONItem

// XML validation
Function ValidateXMLContent(xmlContent As String) As String()

// Warnings management
Function GetWarnings() As String()
Sub ClearWarnings()
```

### VNSPDFEInvoiceValidator

```xojo
// Validate invoice against profile requirements with optional country-specific rules
// Returns array of error messages (empty = valid)
// countryCode: 2-letter ISO 3166-1 code (auto-detected from seller if empty)
Function Validate(invoice As VNSPDFEInvoice, _
    profile As VNSPDFEInvoicePremium.eFacturXProfile, _
    countryCode As String = "") As String()
```

### VNSPDFEInvoiceValidatorCodes

Code list validation: invoice type codes (UNTDID 1001), ISO 4217 currencies, ISO 3166-1 countries, UNCL 4461 payment means, and VAT category rules (BR-S, BR-Z, BR-E, BR-AE, BR-IC, BR-G, BR-O).

### VNSPDFEInvoiceValidatorCountry

Country-specific rules: France (BR-FR), Germany (BR-DE), Italy (BR-IT), Netherlands (BR-NL). Auto-dispatched based on seller country code.

### VNSPDFEInvoiceXMLGenerator

```xojo
// Generate CII XML from invoice data model
Function GenerateCII(invoice As VNSPDFEInvoice, _
    profile As VNSPDFEInvoicePremium.eFacturXProfile, _
    isZUGFeRD As Boolean) As String

// XML utility
Function XmlEscape(text As String) As String
```

---

## Validation Rules by Profile

### MINIMUM (all profiles)

- BT-1: Invoice number is required
- BT-2: Invoice issue date is required
- BT-3: Invoice type code is required
- BT-5: Currency code is required (3 characters, ISO 4217)
- BG-4: Seller party is required (BT-27: name, BT-40: country code)
- BG-7: Buyer party is required (BT-44: name, BT-55: country code)
- BG-23: At least one tax breakdown is required

### BASIC WL (adds to MINIMUM)

- BT-81: Payment means code is required
- BT-31: Seller VAT number required when VAT applies

### BASIC (adds to BASIC WL)

- BG-25: At least one line item is required
- BT-126: Line ID is required for each line item
- BT-153: Product name is required for each line item
- BT-129: Quantity must be positive

### EN 16931 (adds to BASIC)

- BT-10: Buyer reference is required
- BR-CO-10: Sum of line totals must equal sum of tax basis amounts

---

## Tax Category Codes (UNTDID 5305)

The `eTaxCategoryCode` enum represents VAT category codes from the UN/EDIFACT Data Element 5305 standard, used in Factur-X/ZUGFeRD invoices for both line items and tax breakdowns.

| Enum Value | XML Code | Description | When to Use |
|------------|----------|-------------|-------------|
| `StandardRate` | S | Standard VAT rate | Most common — goods/services subject to normal VAT (e.g. 20% FR, 19% DE) |
| `ZeroRated` | Z | Zero-rated | Taxable but rate is 0% (e.g. UK zero-rated food, children's clothing) |
| `Exempt` | E | VAT exempt | Exempt by law (e.g. medical, education, insurance) |
| `ReverseCharge` | AE | Reverse charge | B2B cross-border within EU — buyer self-assesses VAT |
| `IntraCommunitySupply` | K | Intra-community supply | Supply of goods between EU member states |
| `ExportOutsideEU` | G | Export outside EU | Goods exported outside EU — free of VAT |
| `OutsideScopeOfVAT` | O | Outside scope of VAT | Transaction not subject to VAT at all |
| `CanaryIslandsTax` | L | Canary Islands tax | IGIC tax (Impuesto General Indirecto Canario) |
| `CeutaMelillaTax` | M | Ceuta and Melilla tax | IPSI tax (Impuesto sobre la Producción, los Servicios y la Importación) |

### Usage Example

```xojo
// Set tax category on a line item
Dim item As New VNSPDFEInvoiceLineItem
item.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
item.TaxRate = 20.0

// Set tax category on a tax breakdown
Dim tax As New VNSPDFEInvoiceTaxBreakdown
tax.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
tax.TaxRate = 20.0

// Convert enum to XML string code using extension method
Dim code As String = VNSPDFEInvoicePremium.eTaxCategoryCode.ReverseCharge.ToString
// Returns "AE"

// Convert XML string code to enum using extension method
Dim enumVal As VNSPDFEInvoicePremium.eTaxCategoryCode = "AE".ToTaxCategory
// Returns eTaxCategoryCode.ReverseCharge

// Profile enum to string conversion
Dim profileStr As String = VNSPDFEInvoicePremium.eFacturXProfile.EN16931.ToString
// Returns "EN 16931"

// String to profile enum conversion
Dim profileEnum As VNSPDFEInvoicePremium.eFacturXProfile = "EN 16931".ToFacturXProfile
// Returns eFacturXProfile.EN16931
```

### Common Scenarios

- **Domestic B2B invoice**: Use `StandardRate` with your country's VAT rate
- **Export to non-EU country**: Use `ExportOutsideEU` with rate 0.0
- **EU cross-border B2B**: Use `ReverseCharge` with rate 0.0 (buyer accounts for VAT)
- **EU intra-community goods**: Use `IntraCommunitySupply` with rate 0.0
- **Medical/education services**: Use `Exempt` with rate 0.0

---

## Implementation Details

### PDF/A-3b Compliance

CreateFacturXInvoice and CreateZUGFeRDInvoice automatically handle:

1. Embedded CII XML as PDF file attachment with `/AFRelationship /Data`
2. XMP metadata with PDF/A-3b identification (`pdfaid:part=3, conformance=B`)
3. Factur-X or ZUGFeRD extension schema in XMP
4. sRGB ICC output intent (minimal 392-byte profile, self-contained)
5. PDF version set to 1.7

### ReadEInvoice PDF Navigation

The reader navigates the PDF catalog structure:

```
Catalog
  └── /Names
       └── /EmbeddedFiles
            └── /Names array
                 └── [filename, filespec_ref, ...]
                      └── filespec /EF /F → stream → decode → XML
```

Recognized filenames: `factur-x.xml`, `zugferd-invoice.xml`, `xrechnung.xml`

### CII XML Parser

The parser handles both namespaced (`rsm:`, `ram:`, `udt:`) and non-namespaced tag formats. Numeric values with format errors (commas, thousand separators, currency symbols) are auto-corrected during parsing with warnings.

---

## Compatibility

| PDF Reader | Create | Read |
|------------|--------|------|
| Adobe Acrobat | ✅ Full | ✅ Full |
| Preview (macOS) | ✅ Visual | N/A |
| Mustang (Java) | ✅ Tested | ✅ Tested |
| Ghostscript | ✅ Visual | N/A |

---

## Platform Support

| Platform | Create | Read | Notes |
|----------|--------|------|-------|
| Desktop (macOS/Windows/Linux) | ✅ | ✅ | Full support |
| Web | ✅ | ✅ | Full support |
| Console | ✅ | ✅ | Full support |
| iOS | ✅ | ✅ | Requires Premium Zlib for compression |

---

## Examples

- **Example 30**: Creates a Factur-X EN 16931 invoice with visual layout and embedded CII XML
- **Example 31**: Opens any PDF file and checks for Factur-X/ZUGFeRD conformity, displays invoice data as JSON

---

*Last Updated: 2026-02-14* (signature detection added)
