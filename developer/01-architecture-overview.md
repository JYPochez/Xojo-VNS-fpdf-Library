# Architecture Overview

The Xojo FPDF library follows a modular architecture with clear separation of concerns:

```
PDF_Library/
├── VNSPDFModule              # Global utilities and constants
├── Core/
│   └── VNSPDFDocument        # Main PDF document management (all operations)
├── Import/                    # PDF Import system (v1.0.0)
│   ├── VNSPDFReader          # PDF parser and page extractor
│   ├── VNSPDFParser          # Object parsing and type system
│   ├── VNSPDFTokenizer       # Lexical analysis
│   ├── VNSPDFStreamReader    # Binary stream handling
│   ├── VNSPDFStreamDecoder   # Stream decompression
│   ├── VNSPDFLZWDecoder      # LZW decompression
│   └── VNSPDFType classes    # 12 PDF type classes (Null, Boolean, Numeric, String, etc.)
└── Premium/                   # Premium modules (optional, require license)
    ├── VNSPDFEncryptionPremium   # RC4-128 + AES-128/256 encryption (✅ WORKING)
    ├── VNSPDFPDFAPremium         # PDF/A output intents (✅ WORKING)
    ├── VNSPDFZlibPremium         # Pure Xojo zlib for iOS (✅ WORKING)
    └── VNSPDFTablePremium        # Table generation (✅ WORKING)
```

## FREE vs PREMIUM Versions

The library is available in two configurations:

### FREE Version
- **Core PDF features**: All text, graphics, images, fonts, links, bookmarks
- **PDF Import**: Import pages from existing PDFs as XObject templates (✅ v1.0.0)
- **Basic encryption**: RC4-40 (40-bit, DEPRECATED)
- **Basic compression**: FlateDecode/zlib on Desktop/Web/Console (iOS blocked)
- **Platform support**: Desktop, Web, iOS, Console
- **License**: Open-source MIT license

### PREMIUM Version (Requires License)
- **All FREE features** plus:
- **Enhanced encryption**: RC4-128, AES-128, AES-256 (✅ FULLY WORKING)
- **PDF/A compliance**: Output Intent + ICC color profiles (✅ FULLY WORKING)
- **iOS compression**: Pure Xojo zlib implementation (✅ FULLY WORKING)
- **PNG Predictor reversal**: Required for importing modern PDFs (✅ FULLY WORKING)
- **Table generation**: SimpleTable, ImprovedTable, FancyTable with pagination (✅ FULLY WORKING)
- **License**: Commercial (contact for pricing)

See [Chapter 16: Premium Modules](16-premium-modules.md) for detailed information.

## Supported Platforms

The library supports all major Xojo platforms:

- **Desktop** - Windows, macOS, Linux applications
- **Web** - Server-side PDF generation for web apps
- **iOS** - Native iOS mobile applications
- **Console** - Command-line utilities and server processes

## Design Principles

1. **VNS Prefix**: All classes use the `VNS` prefix to avoid conflicts with Xojo framework classes
2. **Shared Code**: Maximum code reuse between all platform targets
3. **Error Accumulation**: Errors are accumulated rather than thrown, allowing operations to continue
4. **Immutable Configuration**: Core document settings (unit, orientation, format) are set at initialization
5. **Platform Abstraction**: Platform-specific code is isolated using conditional compilation
