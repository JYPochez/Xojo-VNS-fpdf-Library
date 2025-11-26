# Internal Architecture Details

## Memory Management

- **Dictionaries**: Used for collections (pages, fonts, images) - O(1) lookup
- **MemoryBlocks**: Used for binary data (future: font files, compressed streams)
- **Strings**: Used for PDF content streams

## Page Storage

Pages are stored in a Dictionary with string keys:

```xojo
Private mPages As Dictionary

// Adding a page
mPages.Value(Str(mPageNumber)) = pageContent

// Retrieving a page
Dim content As String = mPages.Value(Str(pageNumber))
```

## State Machine

Document state is tracked internally:

```xojo
Private mState As Integer
// 0 = Nothing created yet
// 1 = Document open
// 2 = Page open
// 3 = Document closed
```

## Buffer Management

Content is built in a string buffer:

```xojo
Private mBuffer As String

Sub Append(content As String)
    mBuffer = mBuffer + content
End Sub
```
