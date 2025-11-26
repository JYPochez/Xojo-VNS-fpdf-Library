# Error Handling

## Table of Contents

- [Error Accumulation Pattern](#error-accumulation-pattern)
  - [How It Works](#how-it-works)
  - [Benefits](#benefits)
  - [Example Pattern](#example-pattern)
  - [Best Practices](#best-practices)

---

## Error Accumulation Pattern

The library uses an error accumulation pattern rather than throwing exceptions. This allows operations to continue and collect multiple errors.

### How It Works

1. Operations that encounter errors call `SetError()`
2. Error messages are concatenated with line breaks
3. Calling code checks the `Error` property after operations
4. Empty string means no errors occurred

### Benefits

- Non-blocking: Code continues executing
- Multiple errors collected in one pass
- Suitable for batch operations
- Clean error reporting

### Example Pattern

```xojo
Sub GenerateReport()
    Dim pdf As New VNSPDFDocument()

    pdf.AddPage()
    // (future operations)

    // Check for errors at logical checkpoints
    If pdf.Error <> "" Then
        LogError("PDF generation failed: " + pdf.Error)
        Return
    End If

    // Continue processing
End Sub
```

### Best Practices

1. **Check Early**: Check for errors after initialization
2. **Check Often**: Check after groups of related operations
3. **Check Before Output**: Always check before generating final output
4. **Log Details**: Include error details in logs for debugging
5. **User-Friendly Messages**: Show simplified messages to users, log full details
