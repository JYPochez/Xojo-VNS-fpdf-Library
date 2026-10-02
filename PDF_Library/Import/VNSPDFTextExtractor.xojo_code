#tag Class
Protected Class VNSPDFTextExtractor
	#tag Method, Flags = &h21, Description = 4465636F646520612050444620737472696E67206C69746572616C2E
		Private Function DecodeString(pdfString As String) As String
		  // Decode PDF string literal: (text) -> text
		  // Also handles hex strings: <hexdigits> -> text (UTF-16BE)
		  // Handles escape sequences
		  
		  // Handle hex strings: <hexdigits>
		  If pdfString.Left(1) = "<" And pdfString.Right(1) = ">" Then
		    Dim hexContent As String = pdfString.Middle(1, pdfString.Length - 2)
		    Dim result As String = ""
		    Dim i As Integer = 0
		    
		    // Use ToUnicode CMap if available
		    If mCurrentCMap <> Nil Then
		      While i < hexContent.Length - 3  // Need at least 4 hex digits (2 bytes)
		        Dim hexPair1 As String = hexContent.Middle(i, 2)
		        Dim hexPair2 As String = hexContent.Middle(i + 2, 2)
		        Dim byte1 As Integer = Val("&h" + hexPair1)
		        Dim byte2 As Integer = Val("&h" + hexPair2)
		        // CID is the 2-byte value
		        Dim cid As Integer = byte1 * 256 + byte2
		        
		        // Look up CID in CMap
		        If mCurrentCMap.HasKey(cid) Then
		          Dim unicode As Integer = mCurrentCMap.Value(cid)
		          If unicode > 0 Then
		            result = result + UnicodeToString(unicode)
		          Else
		            // Unicode code point is 0 - this shouldn't happen
		            System.DebugLog("WARNING: CID " + Str(cid) + " mapped to unicode=0")
		            result = result + "?"
		          End If
		        Else
		          // CID not in CMap - fallback to direct UTF-16BE
		          System.DebugLog("WARNING: CID " + Str(cid) + " not in CMap, using direct")
		          If cid > 0 Then
		            result = result + UnicodeToString(cid)
		          End If
		        End If
		        
		        i = i + 4  // Move to next 2-byte character
		      Wend
		    Else
		      // No CMap - use direct UTF-16BE encoding
		      While i < hexContent.Length - 3  // Need at least 4 hex digits (2 bytes)
		        Dim hexPair1 As String = hexContent.Middle(i, 2)
		        Dim hexPair2 As String = hexContent.Middle(i + 2, 2)
		        Dim byte1 As Integer = Val("&h" + hexPair1)
		        Dim byte2 As Integer = Val("&h" + hexPair2)
		        Dim unicodeValue As Integer = byte1 * 256 + byte2
		        If unicodeValue > 0 Then
		          result = result + UnicodeToString(unicodeValue)
		        End If
		        i = i + 4  // Move to next 2-byte character
		      Wend
		    End If
		    
		    Return result
		  End If
		  
		  // Handle literal strings: (text)
		  If pdfString.Left(1) <> "(" Or pdfString.Right(1) <> ")" Then
		    Return ""
		  End If
		  
		  // Extract content between parentheses
		  Dim content As String = pdfString.Middle(1, pdfString.Length - 2)
		  
		  // Process escape sequences
		  Dim result As String = ""
		  Dim i As Integer = 0
		  
		  While i < content.Length
		    Dim ch As String = content.Middle(i, 1)
		    
		    If ch = "\" And i + 1 < content.Length Then
		      Dim nextCh As String = content.Middle(i + 1, 1)
		      Select Case nextCh
		      Case "n"
		        result = result + &u000A
		        i = i + 2
		      Case "r"
		        result = result + &u000D
		        i = i + 2
		      Case "t"
		        result = result + &u0009
		        i = i + 2
		      Case "b"
		        result = result + &u0008
		        i = i + 2
		      Case "f"
		        result = result + &u000C
		        i = i + 2
		      Case "("
		        result = result + "("
		        i = i + 2
		      Case ")"
		        result = result + ")"
		        i = i + 2
		      Case "\"
		        result = result + "\"
		        i = i + 2
		      Else
		        // Unknown escape - keep as is
		        result = result + ch
		        i = i + 1
		      End Select
		    Else
		      result = result + ch
		      i = i + 1
		    End If
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 457874726163742074657874207769746820666F6E7420616E6420706F736974696F6E20696E666F726D6174696F6E2066726F6D20612070616765
		Function ExtractText(page As VNSPDFImportedPage, reader As VNSPDFReader) As VNSPDFTextBlock()
		  // Extract text blocks with font and position information from a page
		  // Returns: Array of VNSPDFTextBlock objects containing text, font, size, and position
		  
		  mBlocks.RemoveAll()
		  mCurrentFont = ""
		  mCurrentFontSize = 0.0
		  mCurrentX = 0.0
		  mCurrentY = 0.0
		  mTextMatrixScale = 1.0
		  mCTMScale = 1.0
		  mCurrentCMap = Nil
		  
		  // Store reader reference for XObject lookups
		  mReader = reader
		  
		  // Get decoded content stream
		  Dim contentStream As String = page.GetDecodedContents(reader)
		  If contentStream = "" Then
		    Return mBlocks
		  End If
		  
		  // Get resources dictionary for font lookup and XObject resolution
		  mResources = page.resources
		  
		  // Parse content stream
		  ParseContentStream(contentStream)
		  
		  Return mBlocks
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436865636B206966206368617261637465722069732064656C696D69746572
		Private Function IsDelimiter(ch As String) As Boolean
		  // Check if character is PDF delimiter
		  Return ch = "(" Or ch = ")" Or ch = "<" Or ch = ">" Or ch = "[" Or ch = "]" Or ch = "{" Or ch = "}" Or ch = "/" Or ch = "%"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436865636B20696620746F6B656E206973206120504446206F70657261746F722E
		Private Function IsOperator(token As String) As Boolean
		  // Check if token is a PDF operator (not a number or name)
		  // Operators are alphabetic strings (Tf, Tm, Tj, etc.)
		  
		  If token = "" Then Return False
		  // Names (/), strings ((), arrays ([), and hex strings (<) are operands, not operators
		  If token.Left(1) = "/" Or token.Left(1) = "(" Or token.Left(1) = "[" Or token.Left(1) = "<" Then Return False
		  
		  // Check if it's a number
		  Dim firstChar As String = token.Left(1)
		  If (firstChar >= "0" And firstChar <= "9") Or firstChar = "-" Or firstChar = "." Or firstChar = "+" Then
		    Return False
		  End If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436865636B206966206368617261637465722069732077686974657370616365
		Private Function IsWhitespace(ch As String) As Boolean
		  // Check if character is PDF whitespace
		  Return ch = " " Or ch = &u0009 Or ch = &u000A Or ch = &u000C Or ch = &u000D Or ch = &u0000
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4C6F616420546F556E69636F6465204D61702066726F6D20666F6E742072657365756E6365
		Private Function LoadToUnicodeCMap(fontName As String) As Dictionary
		  // Load ToUnicode CMap for a font from page resources
		  // Returns: Dictionary mapping CID → Unicode, or Nil if not available
		  
		  If mResources = Nil Or mReader = Nil Then Return Nil
		  
		  // Get Font dictionary from resources
		  Dim resourcesDict As Dictionary = mResources.value
		  If Not resourcesDict.HasKey("Font") Then Return Nil
		  
		  Dim fontObj As VNSPDFType = resourcesDict.Value("Font")
		  If fontObj Is Nil Or Not (fontObj IsA VNSPDFDictionary) Then Return Nil
		  
		  Dim fontsDict As Dictionary = VNSPDFDictionary(fontObj).value
		  
		  // Strip leading slash from font name if present (PDF names can have /Name format)
		  Dim lookupName As String = fontName
		  If lookupName.Left(1) = "/" Then
		    lookupName = lookupName.Middle(1)
		  End If
		  
		  If Not fontsDict.HasKey(lookupName) Then Return Nil
		  
		  // Get the specific font
		  Dim fontRefObj As VNSPDFType = fontsDict.Value(lookupName)
		  If fontRefObj = Nil Then Return Nil
		  
		  // Resolve indirect reference if needed
		  Dim fontDict As Dictionary
		  If fontRefObj IsA VNSPDFIndirectObjectReference Then
		    Dim fontIndirect As VNSPDFType = mReader.GetObject(VNSPDFIndirectObjectReference(fontRefObj).objectNumber)
		    If fontIndirect = Nil Or Not (fontIndirect IsA VNSPDFDictionary) Then Return Nil
		    fontDict = VNSPDFDictionary(fontIndirect).value
		  ElseIf fontRefObj IsA VNSPDFDictionary Then
		    fontDict = VNSPDFDictionary(fontRefObj).value
		  Else
		    Return Nil
		  End If
		  
		  // Check if font has ToUnicode entry
		  If Not fontDict.HasKey("ToUnicode") Then Return Nil
		  
		  Dim toUnicodeObj As VNSPDFType = fontDict.Value("ToUnicode")
		  If toUnicodeObj = Nil Then Return Nil
		  
		  // Resolve ToUnicode stream reference
		  Dim toUnicodeStream As VNSPDFStream
		  If toUnicodeObj IsA VNSPDFIndirectObjectReference Then
		    Dim streamIndirect As VNSPDFType = mReader.GetObject(VNSPDFIndirectObjectReference(toUnicodeObj).objectNumber)
		    If streamIndirect = Nil Or Not (streamIndirect IsA VNSPDFStream) Then Return Nil
		    toUnicodeStream = VNSPDFStream(streamIndirect)
		  ElseIf toUnicodeObj IsA VNSPDFStream Then
		    toUnicodeStream = VNSPDFStream(toUnicodeObj)
		  Else
		    Return Nil
		  End If
		  
		  // Decode the CMap stream
		  Dim cmapContent As String = toUnicodeStream.GetDecodedData()
		  If cmapContent = "" Then Return Nil
		  
		  // Parse the CMap
		  Dim parser As New VNSPDFCMapParser
		  Dim mapping As Dictionary = parser.ParseCMap(cmapContent)
		  
		  Return mapping
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273652074686520636F6E74656E742073747265616D20616E6420657874726163742074657874206F70657261746F7273
		Private Sub ParseContentStream(content As String)
		  // Parse PDF content stream and extract text operators
		  // Handles: Tf (set font), Tm/Td (position), Tj/TJ/' (text)
		  
		  Dim pos As Integer = 0
		  Dim contentLen As Integer = content.Length
		  Dim stack() As String  // Operand stack
		  
		  While pos < contentLen
		    // Skip whitespace
		    While pos < contentLen And IsWhitespace(content.Middle(pos, 1))
		      pos = pos + 1
		    Wend
		    
		    If pos >= contentLen Then Exit While
		    
		    // Read next token
		    Dim token As String = ReadToken(content, pos)
		    If token = "" Then Exit While
		    
		    // Check if this is an operator (ends parsing operands)
		    If IsOperator(token) Then
		      ProcessOperator(token, stack)
		      stack.RemoveAll()
		    Else
		      // It's an operand - push to stack
		      stack.Add(token)
		    End If
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736520746578742061727261792066726F6D20544A206F70657261746F722E
		Private Function ParseTextArray(arrayStr As String) As String
		  // Parse text array from TJ operator: [(string) num (string) ...] TJ
		  // Concatenate all text strings, ignoring positioning numbers
		  
		  If arrayStr.Left(1) <> "[" Or arrayStr.Right(1) <> "]" Then
		    Return ""
		  End If
		  
		  Dim content As String = arrayStr.Middle(1, arrayStr.Length - 2).Trim
		  Dim result As String = ""
		  Dim pos As Integer = 0
		  
		  While pos < content.Length
		    // Skip whitespace
		    While pos < content.Length And IsWhitespace(content.Middle(pos, 1))
		      pos = pos + 1
		    Wend
		    
		    If pos >= content.Length Then Exit While
		    
		    Dim ch As String = content.Middle(pos, 1)
		    
		    If ch = "(" Then
		      // Read string
		      Dim pdfString As String = ReadString(content, pos)
		      result = result + DecodeString(pdfString)
		    ElseIf ch = "<" Then
		      // Read hex string
		      Dim hexString As String = ReadHexString(content, pos)
		      // TODO: decode hex string if needed
		    Else
		      // It's a number (positioning adjustment) - skip it
		      While pos < content.Length And Not IsWhitespace(content.Middle(pos, 1)) And content.Middle(pos, 1) <> "(" And content.Middle(pos, 1) <> "<"
		        pos = pos + 1
		      Wend
		    End If
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50726F63657373206120504446206F70657261746F72207769746820697473206F706572616E64732E
		Private Sub ProcessOperator(op As String, operands() As String)
		  // Process PDF operator with its operands
		  
		  Select Case op
		  Case "Do"
		    // Invoke XObject: /Name Do
		    // TEMPORARILY DISABLED: XObject processing is very slow because
		    // resolving indirect references loads entire image streams (1-2MB each)
		    // just to check the subtype. For TOC detection, we only need text
		    // from the page content streams, not from XObjects.
		    // TODO: Optimize by reading just the dictionary without stream data
		    // (XObject processing skipped)
		  Case "cm"
		    // Modify CTM (Current Transformation Matrix): a b c d e f cm
		    // This scales/rotates/translates the entire coordinate system
		    If operands.Count >= 6 Then
		      Dim ctmD As Double = Val(operands(3))  // d = vertical scale
		      If ctmD <> 0 Then  // Avoid division by zero, negative means flip
		        mCTMScale = Abs(ctmD)
		      End If
		    End If
		    
		  Case "Tf"
		    // Set font: /FontName size Tf
		    If operands.Count >= 2 Then
		      mCurrentFont = operands(0)  // Font name (e.g., /F1)
		      mCurrentFontSize = Val(operands(1))
		      
		      // Load ToUnicode CMap for this font (if available)
		      mCurrentCMap = LoadToUnicodeCMap(operands(0))
		    End If
		    
		  Case "Tm"
		    // Set text matrix: a b c d e f Tm
		    // a,d = horizontal/vertical scale; b,c = skew; e,f = translation (x,y)
		    If operands.Count >= 6 Then
		      mTextMatrixScale = Val(operands(3))  // d = vertical scale
		      mCurrentX = Val(operands(4))         // e = x position
		      mCurrentY = Val(operands(5))         // f = y position
		    End If
		    
		  Case "Td", "TD"
		    // Move text position: tx ty Td
		    If operands.Count >= 2 Then
		      mCurrentX = mCurrentX + Val(operands(0))
		      mCurrentY = mCurrentY + Val(operands(1))
		    End If
		    
		  Case "Tj"
		    // Show text: (string) Tj
		    If operands.Count >= 1 Then
		      Dim text As String = DecodeString(operands(0))
		      If text <> "" Then
		        Dim block As New VNSPDFTextBlock
		        block.text = text
		        block.fontName = mCurrentFont
		        block.fontSize = mCurrentFontSize * mTextMatrixScale * mCTMScale  // Apply both CTM and text matrix scales
		        block.x = mCurrentX
		        block.y = mCurrentY
		        mBlocks.Add(block)
		      End If
		    Else
		      System.DebugLog("Tj operator: ERROR - no operands!")
		    End If
		    
		  Case "TJ"
		    // Show text with positioning: [(string) num ...] TJ
		    If operands.Count >= 1 Then
		      Dim arrayContent As String = operands(0)
		      If arrayContent.Left(1) = "[" And arrayContent.Right(1) = "]" Then
		        // Parse array content
		        Dim text As String = ParseTextArray(arrayContent)
		        If text <> "" Then
		          Dim block As New VNSPDFTextBlock
		          block.text = text
		          block.fontName = mCurrentFont
		          block.fontSize = mCurrentFontSize * mTextMatrixScale * mCTMScale  // Apply both scales
		          block.x = mCurrentX
		          block.y = mCurrentY
		          mBlocks.Add(block)
		        End If
		      End If
		    End If
		    
		  Case "'"
		    // Move to next line and show text: (string) '
		    If operands.Count >= 1 Then
		      // ' is equivalent to: T* (string) Tj
		      mCurrentY = mCurrentY - (mCurrentFontSize * mTextMatrixScale * mCTMScale)  // Line height with scales
		      Dim text As String = DecodeString(operands(0))
		      If text <> "" Then
		        Dim block As New VNSPDFTextBlock
		        block.text = text
		        block.fontName = mCurrentFont
		        block.fontSize = mCurrentFontSize * mTextMatrixScale * mCTMScale  // Apply both scales
		        block.x = mCurrentX
		        block.y = mCurrentY
		        mBlocks.Add(block)
		      End If
		    End If
		    
		  Case """"
		    // Set word and char spacing, move to next line, show text: aw ac (string) "
		    If operands.Count >= 3 Then
		      mCurrentY = mCurrentY - (mCurrentFontSize * mTextMatrixScale * mCTMScale)  // Line height with scales
		      Dim text As String = DecodeString(operands(2))
		      If text <> "" Then
		        Dim block As New VNSPDFTextBlock
		        block.text = text
		        block.fontName = mCurrentFont
		        block.fontSize = mCurrentFontSize * mTextMatrixScale * mCTMScale  // Apply both scales
		        block.x = mCurrentX
		        block.y = mCurrentY
		        mBlocks.Add(block)
		      End If
		    End If
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656164206120504446206172726179205B2E2E2E5D0A
		Private Function ReadArray(content As String, ByRef pos As Integer) As String
		  // Read PDF array: [...]
		  
		  Dim result As String = "["
		  pos = pos + 1  // Skip opening [
		  
		  Dim depth As Integer = 1
		  
		  While pos < content.Length And depth > 0
		    Dim ch As String = content.Middle(pos, 1)
		    result = result + ch
		    pos = pos + 1
		    
		    If ch = "[" Then
		      depth = depth + 1
		    ElseIf ch = "]" Then
		      depth = depth - 1
		    End If
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5265616420612068657820737472696E67203C6865786469676974733E2E
		Private Function ReadHexString(content As String, ByRef pos As Integer) As String
		  // Read PDF hex string: <hexdigits>
		  
		  Dim result As String = "<"
		  pos = pos + 1  // Skip opening <
		  
		  While pos < content.Length
		    Dim ch As String = content.Middle(pos, 1)
		    result = result + ch
		    pos = pos + 1
		    
		    If ch = ">" Then Exit While
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656164206120504446206E616D65202F6E616D652E
		Private Function ReadName(content As String, ByRef pos As Integer) As String
		  // Read PDF name: /name
		  
		  Dim result As String = "/"
		  pos = pos + 1  // Skip /
		  
		  While pos < content.Length
		    Dim ch As String = content.Middle(pos, 1)
		    If IsWhitespace(ch) Or IsDelimiter(ch) Then Exit While
		    result = result + ch
		    pos = pos + 1
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 526561642061206E756D626572206F72206F70657261746F720A
		Private Function ReadNumberOrOperator(content As String, ByRef pos As Integer) As String
		  // Read number (123, -45.6) or operator (Tj, Tm, etc.)
		  
		  Dim result As String = ""
		  
		  While pos < content.Length
		    Dim ch As String = content.Middle(pos, 1)
		    If IsWhitespace(ch) Or IsDelimiter(ch) Then Exit While
		    result = result + ch
		    pos = pos + 1
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656164206120737472696E67206C69746572616C2028706172656E74686573697A65642074657874292E
		Private Function ReadString(content As String, ByRef pos As Integer) As String
		  // Read PDF string literal: (text)
		  // Handles escaped characters and nested parentheses
		  
		  Dim result As String = "("
		  pos = pos + 1  // Skip opening (
		  
		  Dim depth As Integer = 1
		  Dim escaped As Boolean = False
		  
		  While pos < content.Length And depth > 0
		    Dim ch As String = content.Middle(pos, 1)
		    result = result + ch
		    pos = pos + 1
		    
		    If escaped Then
		      escaped = False
		    ElseIf ch = "\" Then
		      escaped = True
		    ElseIf ch = "(" Then
		      depth = depth + 1
		    ElseIf ch = ")" Then
		      depth = depth - 1
		    End If
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5265616420746865206E65787420746F6B656E2066726F6D2074686520636F6E74656E742073747265616D2E
		Private Function ReadToken(content As String, ByRef pos As Integer) As String
		  // Read next token from content stream
		  // Updates pos to point after the token
		  // Handles: numbers, names, strings, arrays, operators
		  
		  Dim contentLen As Integer = content.Length
		  If pos >= contentLen Then Return ""
		  
		  Dim ch As String = content.Middle(pos, 1)
		  
		  // String literal (text)
		  If ch = "(" Then
		    Return ReadString(content, pos)
		  End If
		  
		  // Hex string
		  If ch = "<" And pos + 1 < contentLen And content.Middle(pos + 1, 1) <> "<" Then
		    Return ReadHexString(content, pos)
		  End If
		  
		  // Array
		  If ch = "[" Then
		    Return ReadArray(content, pos)
		  End If
		  
		  // Name
		  If ch = "/" Then
		    Return ReadName(content, pos)
		  End If
		  
		  // Comment - skip to end of line and recursively get next token
		  If ch = "%" Then
		    pos = pos + 1  // Skip %
		    // Skip to end of line (CR or LF)
		    While pos < contentLen
		      ch = content.Middle(pos, 1)
		      If ch = &u000A Or ch = &u000D Then  // LF or CR
		        pos = pos + 1
		        // Skip additional CR/LF
		        If pos < contentLen Then
		          Dim nextCh As String = content.Middle(pos, 1)
		          If (ch = &u000D And nextCh = &u000A) Or (ch = &u000A And nextCh = &u000D) Then
		            pos = pos + 1
		          End If
		        End If
		        Exit While
		      End If
		      pos = pos + 1
		    Wend
		    // Recursively get next token (skip the comment)
		    Return ReadToken(content, pos)
		  End If
		  
		  // Number or operator
		  Return ReadNumberOrOperator(content, pos)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E7665727420556E69636F646520636F646520706F696E7420746F205554462D3820737472696E672E
		Private Function UnicodeToString(codePoint As Integer) As String
		  // Convert Unicode code point to UTF-8 string
		  // Handles all Unicode characters including accented characters, emoji, etc.
		  
		  If codePoint <= 0 Then Return ""
		  
		  // Encode Unicode code point as UTF-8 bytes in MemoryBlock
		  Dim mb As MemoryBlock
		  
		  If codePoint <= &h7F Then
		    // 1-byte UTF-8: 0xxxxxxx
		    mb = New MemoryBlock(1)
		    mb.UInt8Value(0) = codePoint
		  ElseIf codePoint <= &h7FF Then
		    // 2-byte UTF-8: 110xxxxx 10xxxxxx
		    mb = New MemoryBlock(2)
		    mb.UInt8Value(0) = &hC0 + (codePoint \ 64)
		    mb.UInt8Value(1) = &h80 + (codePoint Mod 64)
		  ElseIf codePoint <= &hFFFF Then
		    // 3-byte UTF-8: 1110xxxx 10xxxxxx 10xxxxxx
		    mb = New MemoryBlock(3)
		    mb.UInt8Value(0) = &hE0 + (codePoint \ 4096)
		    mb.UInt8Value(1) = &h80 + ((codePoint \ 64) Mod 64)
		    mb.UInt8Value(2) = &h80 + (codePoint Mod 64)
		  Else
		    // 4-byte UTF-8: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
		    mb = New MemoryBlock(4)
		    mb.UInt8Value(0) = &hF0 + (codePoint \ 262144)
		    mb.UInt8Value(1) = &h80 + ((codePoint \ 4096) Mod 64)
		    mb.UInt8Value(2) = &h80 + ((codePoint \ 64) Mod 64)
		    mb.UInt8Value(3) = &h80 + (codePoint Mod 64)
		  End If
		  
		  // Create string from UTF-8 bytes
		  Dim s As String = mb
		  s = s.DefineEncoding(Encodings.UTF8)
		  Return s
		End Function
	#tag EndMethod


	#tag Note, Name = About
		VNSPDFTextExtractor - Extract text with font and position information from PDF pages
		
		This class parses PDF content streams to extract text along with font and positioning
		information. This enables better TOC detection by analyzing font sizes and styles.
		
		Supported operators:
		- Tf: Set font and size
		- Tm, Td, TD: Text positioning
		- Tj, TJ, ', ": Text showing operators
		
	#tag EndNote


	#tag Property, Flags = &h21, Description = 4172726179206F6620657874726163746564207465787420626C6F636B732E
		Private mBlocks() As VNSPDFTextBlock
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 566572746963616C207363616C652066726F6D2043544D2028636D206F70657261746F72292E
		Private mCTMScale As Double = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546F556E69636F6465204D61702066726F6D2043494420746F20556E69636F646520666F722063757272656E7420666F6E740A
		Private mCurrentCMap As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 43757272656E7420666F6E74206E616D652028652E672E202F4631292E
		Private mCurrentFont As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 43757272656E7420666F6E742073697A6520696E20706F696E74730A
		Private mCurrentFontSize As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 43757272656E74205820706F736974696F6E20696E207573657220756E6974732E
		Private mCurrentX As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 43757272656E7420592D706F736974696F6E20696E207573657220756E6974730A
		Private mCurrentY As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 526561646572207265666572656E636520666F72206C6F6F6B696E67207570206F626A656374732E
		Private mReader As VNSPDFReader
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5265736F75726365732064696374696F6E6172792066726F6D2070616765
		Private mResources As VNSPDFDictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 566572746963616C207363616C652066726F6D2074657874206D61747269782028546D292E
		Private mTextMatrixScale As Double = 1.0
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
