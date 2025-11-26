# Enumerations

## ePageFormat

**Location**: `VNSPDFModule`

Standard PDF page formats.

```xojo
Enum ePageFormat
    A3          // 297 x 420 mm
    A4          // 210 x 297 mm (most common)
    A5          // 148 x 210 mm
    Letter      // 8.5 x 11 inches (US standard)
    Legal       // 8.5 x 14 inches (US legal)
End Enum
```

**Usage**:
```xojo
Dim pdf As New VNSPDFDocument(, , VNSPDFModule.ePageFormat.Letter)
```

## ePageOrientation

**Location**: `VNSPDFModule`

Page orientation options.

```xojo
Enum ePageOrientation
    Portrait    // Vertical (height > width)
    Landscape   // Horizontal (width > height)
End Enum
```

**Usage**:
```xojo
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Landscape)
```

**Notes**:
- Portrait is the default orientation
- Landscape automatically swaps width and height dimensions

## ePageUnit

**Location**: `VNSPDFModule`

Unit of measurement for coordinates and dimensions.

```xojo
Enum ePageUnit
    Points       // 1/72 inch (PDF native unit)
    Millimeters  // mm (default, most common internationally)
    Centimeters  // cm
    Inches       // inches (US standard)
End Enum
```

**Usage**:
```xojo
Dim pdf As New VNSPDFDocument(, VNSPDFModule.ePageUnit.Inches)
```

**Conversion Factors**:
- 1 inch = 72 points
- 1 inch = 25.4 millimeters
- 1 inch = 2.54 centimeters
