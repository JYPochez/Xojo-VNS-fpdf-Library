# Testing

## Unit Test Template

```xojo
Sub TestDocumentCreation()
    Dim pdf As New VNSPDFDocument()

    // Test initial state
    Assert(pdf.PageCount = 0, "Initial page count should be 0")
    Assert(pdf.CurrentPageNumber = 0, "Initial page number should be 0")
    Assert(pdf.Error = "", "Should have no errors")

    // Test page addition
    pdf.AddPage()
    Assert(pdf.PageCount = 1, "Page count should be 1")
    Assert(pdf.CurrentPageNumber = 1, "Current page should be 1")

    // Test multiple pages
    pdf.AddPage()
    pdf.AddPage()
    Assert(pdf.PageCount = 3, "Page count should be 3")
    Assert(pdf.CurrentPageNumber = 3, "Current page should be 3")
End Sub
```
