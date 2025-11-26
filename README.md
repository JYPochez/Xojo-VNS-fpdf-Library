Overview

Xojo_fpdf is a pure Xojo implementation for creating PDF documents programmatically. It is based on the excellent [go-pdf/fpdf](https://codeberg.org/go-pdf/fpdf) library and the original [PHP FPDF](http://www.fpdf.org/) library.

## Features

- **Cross-Platform**: Works with Xojo Desktop, Web, iOS, and Console applications
- **Pure Xojo**: No external dependencies or plugins required
- **Shared Codebase**: Maximum code reuse between all platform targets
- **Core PDF Fonts**: Built-in support for standard PDF fonts (Helvetica, Times, Courier, etc.)
- **TrueType Fonts**: Full Unicode support with UTF-8 encoding and proper glyph spacing
- **Font Subsetting**: Automatic TrueType font optimization (98% size reduction, sparse glyph IDs)
- **Emoji Support**: Color emoji rendering with cross-platform compatibility (image-based)
- **Page Management**: Easy page creation and manipulation
- **Custom Page Sizes**: Support for standard sizes (A4, Letter, Legal, etc.) and custom dimensions
- **Flexible Units**: Work in millimeters, centimeters, inches, or points
- **Portrait/Landscape**: Automatic handling of page orientation
- **Gradients**: Linear and radial gradients with PDF shading patterns
- **Clipping Paths**: Rectangular, circular, elliptical, polygon, and text clipping with nesting support
- **Bezier Curves**: Quadratic and cubic Bezier curves for smooth curved paths
- **Arrows**: Lines with arrowheads at start, end, or both ends
- **Polygons**: Arbitrary polygon shapes from Point arrays (triangles, pentagons, stars, etc.)
- **Error Accumulation**: Graceful error handling without interrupting workflow

- Basic Example

```xojo
// Create a new PDF document (A4, Portrait, Millimeters)
Dim pdf As New VNSPDFDocument()

// Add a page
pdf.AddPage()

// Set font
pdf.SetFont("helvetica", "B", 16)

// Add a cell with text
pdf.Cell(0, 10, "Hello World!", 1, 1, "C")

// Add more content
pdf.SetFont("helvetica", "", 12)
pdf.MultiCell(0, 6, "This is a longer paragraph that demonstrates the MultiCell method with automatic text wrapping.", 1, "L")

// Save the PDF
Dim f As FolderItem = SpecialFolder.Desktop.Child("output.pdf")
pdf.SaveToFile(f)
```
