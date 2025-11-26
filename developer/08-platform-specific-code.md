# Platform-Specific Code

## Conditional Compilation

Use Xojo's conditional compilation for platform-specific code:

```xojo
#If TargetDesktop Then
    // Desktop-specific code
    Dim f As FolderItem = GetFolderItem("")

#ElseIf TargetWeb Then
    // Web-specific code
    Dim wf As New WebFile

#ElseIf TargetIOS Then
    // iOS-specific code
    Dim data As MemoryBlock

#ElseIf TargetConsole Then
    // Console-specific code
    Print("Generating PDF...")

#EndIf
```

## File I/O Abstraction

When implementing file operations (future), abstract platform differences:

```xojo
Function SavePDF(data As MemoryBlock, filename As String) As Boolean
    #If TargetDesktop Then
        Dim f As FolderItem = GetFolderItem(filename)
        Dim stream As BinaryStream = BinaryStream.Create(f, True)
        stream.Write(data)
        stream.Close()
        Return True

    #ElseIf TargetWeb Then
        // Return data for download
        Dim wf As New WebFile
        wf.Data = data
        wf.MIMEType = "application/pdf"
        wf.ForceDownload = True
        ShowURL(wf.URL)
        Return True

    #ElseIf TargetIOS Then
        // Save to app documents folder
        Dim docFolder As FolderItem = SpecialFolder.Documents
        Dim f As FolderItem = docFolder.Child(filename)
        Dim stream As BinaryStream = BinaryStream.Create(f, True)
        stream.Write(data)
        stream.Close()
        Return True

    #ElseIf TargetConsole Then
        // Write to current directory
        Dim f As FolderItem = GetFolderItem(filename)
        Dim stream As BinaryStream = BinaryStream.Create(f, True)
        stream.Write(data)
        stream.Close()
        Print("PDF saved to: " + filename)
        Return True

    #EndIf
End Function
```

## Platform Detection

```xojo
Function IsDesktop() As Boolean
    #If TargetDesktop Then
        Return True
    #Else
        Return False
    #EndIf
End Function

Function IsWeb() As Boolean
    #If TargetWeb Then
        Return True
    #Else
        Return False
    #EndIf
End Function

Function IsIOS() As Boolean
    #If TargetIOS Then
        Return True
    #Else
        Return False
    #EndIf
End Function

Function IsConsole() As Boolean
    #If TargetConsole Then
        Return True
    #Else
        Return False
    #EndIf
End Function
```
