# Premium Modules Documentation

This folder contains detailed documentation for each premium module in the VNS PDF Library.

## Module Index

| Module | File | Status | Description |
|--------|------|--------|-------------|
| **Encryption** | [01-encryption-module.md](01-encryption-module.md) | ✅ Available (€50) | AES-128/256, RC4-128 encryption |
| **Zlib** | [02-zlib-module.md](02-zlib-module.md) | ✅ Available (€50) | Pure Xojo compression for iOS |
| **Tables** | [03-table-module.md](03-table-module.md) | ✅ Available (€50) | Professional table generation |
| **PDF/A** | [04-pdfa-module.md](04-pdfa-module.md) | 🔔 Coming Soon (Q2 2026) | ICC profiles for archival PDFs |
| **Forms** | 05-forms-module.md | 🔔 Coming Soon (Q2-Q3 2026) | Interactive PDF AcroForms |
| **HTML/Markdown** | [05-html-markdown-module.md](05-html-markdown-module.md) | ✅ Available (€50) | HTML and Markdown to PDF conversion |
| **E-Invoice** | [07-einvoice-module.md](07-einvoice-module.md) | ✅ Available (€50) | Factur-X/ZUGFeRD create + read + validate |
| **Peppol** | [08-peppol-module.md](08-peppol-module.md) | ✅ Included with E-Invoice | Peppol network send/receive (Storecove) |

## Quick Start

### Checking Module Availability

```xojo
// Each module has a corresponding flag in VNSPDFModule:
If hasPremiumVNSEncryptionModule Then
  // AES-128/256 and RC4-128 available
End If

If hasPremiumVNSZlibModule Then
  // Pure Xojo compression available (iOS support)
End If

If hasPremiumVNSTableModule Then
  // SimpleTable, ImprovedTable, FancyTable available
End If

If hasPremiumVNSPDFAModule Then
  // AddOutputIntent for PDF/A compliance available
End If

If hasPremiumVNSEInvoiceModule Then
  // Factur-X/ZUGFeRD create and read available
End If
```

### Installing Premium Modules

1. Add the module file to `PDF_Library/Premium/` folder
2. Add entry to all `.xojo_project` files
3. Set the corresponding `kHas*Module` flag to `True` in VNSPDFModule

## Module Dependencies

```
VNSPDFDocument (Core)
├── VNSPDFModule (Constants, Enums, Utilities)
├── VNSZlibModule (Wrapper)
│   └── VNSZlibPremiumDeflate (PREMIUM)
│   └── VNSZlibPremiumInflate (PREMIUM)
├── VNSPDFEncryptionPremium (PREMIUM)
├── VNSPDFTablePremium (PREMIUM)
├── VNSPDFAPremium (PREMIUM)
└── VNSPDFEInvoicePremium (PREMIUM)
    └── VNSPDFPeppol (PREMIUM — Peppol network integration)
```

## See Also

- [Premium Modules Overview](../16-premium-modules.md) - High-level architecture
- [Feature Comparison (Premium)](../../FEATURE_COMPARISON_PREMIUM.md) - Full feature list
- [Feature Comparison (Free)](../../FEATURE_COMPARISON_FREE.md) - Free version capabilities

---

*Last Updated: 2026-04-07*
