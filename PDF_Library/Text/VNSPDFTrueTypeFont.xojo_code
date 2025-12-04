#tag Class
Protected Class VNSPDFTrueTypeFont
	#tag Method, Flags = &h0
		Sub Constructor(fontData As String)
		  mFontData = fontData
		  mIsValid = False

		  // Parse TrueType font structure
		  If Not ParseFont() Then
		    Return
		  End If

		  mIsValid = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(fontData As MemoryBlock)
		  // iOS-specific constructor that accepts MemoryBlock directly
		  // This avoids String conversion which corrupts binary data on iOS

		  mFontDataMB = fontData
		  mFontData = "" // Keep empty - will use mFontDataMB on iOS
		  mIsValid = False

		  // Parse TrueType font structure
		  If Not ParseFont() Then
		    Return
		  End If

		  mIsValid = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCharWidth(charCode As Integer) As Double
		  // Map character to glyph
		  Dim glyphIndex As Integer = GetGlyphID(charCode)
		  
		  // Get glyph width
		  Dim width As Integer = 500 // Default width
		  
		  If mGlyphWidths.HasKey(Str(glyphIndex)) Then
		    width = mGlyphWidths.Value(Str(glyphIndex))
		  ElseIf mGlyphWidths.KeyCount > 0 Then
		    // Use last width if glyph index is out of range
		    width = mGlyphWidths.Value(Str(mNumOfLongHorMetrics - 1))
		  End If
		  
		  // Convert to PDF units (1000 units per em)
		  Return width * 1000.0 / mUnitsPerEm
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGlyphID(charCode As Integer) As Integer
		  // Map Unicode character code point to glyph index
		  If mCharToGlyph.HasKey(Str(charCode)) Then
		    Return mCharToGlyph.Value(Str(charCode))
		  Else
		    Return 0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseCmapTable() As Boolean
		  If Not mTables.HasKey("cmap") Then
		    Return False
		  End If

		  Dim tableInfo As Dictionary = mTables.Value("cmap")
		  Dim offset As Integer = tableInfo.Value("offset")

		  Dim mb As MemoryBlock = GetFontDataAsMemoryBlock()
		  If mb = Nil Then Return False
		  mb.LittleEndian = False // Big-endian

		  mCharToGlyph = New Dictionary

		  // Read cmap header (version at offset, numTables at offset+2)
		  Dim numTables As UInt16 = mb.UInt16Value(offset + 2)

		  // Look for cmap subtables - prefer Format 12 over Format 4
		  // Format 12: Platform 3 (Windows), Encoding 10 (Unicode full repertoire)
		  // Format 4: Platform 3 (Windows), Encoding 1 (Unicode BMP)
		  Dim format12Offset As Integer = -1
		  Dim format4Offset As Integer = -1

		  For i As Integer = 0 To numTables - 1
		    Dim entryOffset As Integer = offset + 4 + (i * 8)
		    Dim platformID As UInt16 = mb.UInt16Value(entryOffset)
		    Dim encodingID As UInt16 = mb.UInt16Value(entryOffset + 2)
		    Dim subtableOffset As UInt32 = mb.UInt32Value(entryOffset + 4)

		    // Platform 3 (Windows), Encoding 10 (Unicode full repertoire) - Format 12
		    If platformID = 3 And encodingID = 10 Then
		      format12Offset = offset + subtableOffset
		    End If

		    // Platform 3 (Windows), Encoding 1 (Unicode BMP) - Format 4
		    If platformID = 3 And encodingID = 1 Then
		      format4Offset = offset + subtableOffset
		    End If
		  Next

		  // Try Format 12 first (full Unicode support)
		  If format12Offset >= 0 Then
		    Dim format As UInt16 = mb.UInt16Value(format12Offset)
		    If format = 12 Then
		      If ParseCmapFormat12(mb, format12Offset) Then
		        Return True
		      End If
		    End If
		  End If

		  // Fall back to Format 4
		  If format4Offset >= 0 Then
		    Dim format As UInt16 = mb.UInt16Value(format4Offset)
		    If format = 4 Then
		      If ParseCmapFormat4(mb, format4Offset) Then
		        Return True
		      End If
		    End If
		  End If

		  // No suitable cmap found, create simple identity mapping
		  For i As Integer = 32 To 126 // ASCII printable
		    mCharToGlyph.Value(Str(i)) = i
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseCmapFormat4(mb As MemoryBlock, formatOffset As Integer) As Boolean
		  // Parse Format 4 cmap (segmented mapping for BMP)
		  // Read format 4 data
		  Dim segCount As UInt16 = mb.UInt16Value(formatOffset + 6) / 2

		  // Read arrays
		  Dim endCountOffset As Integer = formatOffset + 14
		  Dim startCountOffset As Integer = endCountOffset + (segCount * 2) + 2
		  Dim idDeltaOffset As Integer = startCountOffset + (segCount * 2)
		  Dim idRangeOffset As Integer = idDeltaOffset + (segCount * 2)

		  // Build character to glyph mapping
		  For seg As Integer = 0 To segCount - 1
		    Dim endCode As UInt16 = mb.UInt16Value(endCountOffset + (seg * 2))
		    Dim startCode As UInt16 = mb.UInt16Value(startCountOffset + (seg * 2))
		    Dim idDelta As Int16 = mb.Int16Value(idDeltaOffset + (seg * 2))
		    Dim idRangeOffsetValue As UInt16 = mb.UInt16Value(idRangeOffset + (seg * 2))

		    For c As Integer = startCode To endCode
		      Dim glyphIndex As Integer

		      If idRangeOffsetValue = 0 Then
		        glyphIndex = (c + idDelta) Mod 65536
		      Else
		        Dim glyphIndexOffset As Integer = idRangeOffset + (seg * 2) + idRangeOffsetValue + ((c - startCode) * 2)
		        glyphIndex = mb.UInt16Value(glyphIndexOffset)
		        If glyphIndex <> 0 Then
		          glyphIndex = (glyphIndex + idDelta) Mod 65536
		        End If
		      End If

		      mCharToGlyph.Value(Str(c)) = glyphIndex
		    Next
		  Next

		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseCmapFormat12(mb As MemoryBlock, formatOffset As Integer) As Boolean
		  // Parse Format 12 cmap (segmented coverage for full Unicode)
		  // Format 12 structure:
		  // - format: UInt16 (12)
		  // - reserved: UInt16
		  // - length: UInt32
		  // - language: UInt32
		  // - numGroups: UInt32
		  // - groups: array of (startCharCode: UInt32, endCharCode: UInt32, startGlyphID: UInt32)

		  Dim numGroups As UInt32 = mb.UInt32Value(formatOffset + 12)
		  Dim groupOffset As Integer = formatOffset + 16

		  For i As Integer = 0 To numGroups - 1
		    Dim grpOffset As Integer = groupOffset + (i * 12)
		    Dim startCharCode As UInt32 = mb.UInt32Value(grpOffset)
		    Dim endCharCode As UInt32 = mb.UInt32Value(grpOffset + 4)
		    Dim startGlyphID As UInt32 = mb.UInt32Value(grpOffset + 8)

		    // Build mapping for this range
		    For c As UInt32 = startCharCode To endCharCode
		      Dim glyphID As Integer = startGlyphID + (c - startCharCode)
		      mCharToGlyph.Value(Str(c)) = glyphID
		    Next
		  Next

		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseFont() As Boolean
		  // Check if we have font data (either String or MemoryBlock)
		  If mFontData = "" And mFontDataMB = Nil Then
		    Return False
		  End If

		  // Read table directory
		  Dim mb As MemoryBlock = GetFontDataAsMemoryBlock()
		  If mb = Nil Or mb.Size < 12 Then Return False
		  mb.LittleEndian = False // TrueType fonts use big-endian byte order
		  
		  // Check if this is a TrueType Collection (.ttc)
		  Dim ttcTag As String = mb.StringValue(0, 4)
		  Dim fontOffset As Integer = 0
		  
		  If ttcTag = "ttcf" Then
		    // This is a TrueType Collection - extract first font
		    Dim ttcVersion As UInt32 = mb.UInt32Value(4)
		    Dim numFonts As UInt32 = mb.UInt32Value(8)
		    
		    If numFonts > 0 Then
		      // Use first font in collection
		      fontOffset = mb.UInt32Value(12)
		    Else
		      Return False
		    End If
		  End If
		  
		  // Read offset table (at fontOffset for .ttc, at 0 for .ttf)
		  Dim version As UInt32 = mb.UInt32Value(fontOffset)
		  Dim numTables As UInt16 = mb.UInt16Value(fontOffset + 4)
		  
		  // Look for required tables: head, hhea, hmtx, maxp, name, post, cmap
		  mTables = New Dictionary
		  
		  Dim offset As Integer = fontOffset + 12 // Start after offset table
		  
		  For i As Integer = 0 To numTables - 1
		    If offset + 16 > mb.Size Then
		      Exit For
		    End If
		    
		    // Read table entry
		    Dim tag As String = mb.StringValue(offset, 4)
		    Dim checksum As UInt32 = mb.UInt32Value(offset + 4)
		    Dim tableOffset As UInt32 = mb.UInt32Value(offset + 8)
		    Dim tableLength As UInt32 = mb.UInt32Value(offset + 12)
		    
		    // Store table info (use absolute offset from start of file)
		    Dim tableInfo As New Dictionary
		    tableInfo.Value("offset") = tableOffset
		    tableInfo.Value("length") = tableLength
		    mTables.Value(tag) = tableInfo
		    
		    offset = offset + 16
		  Next
		  
		  // Parse essential tables
		  If Not ParseHeadTable() Then
		    Return False
		  End If

		  If Not ParseHheaTable() Then
		    Return False
		  End If

		  If Not ParseNameTable() Then
		    Return False
		  End If

		  If Not ParseMaxpTable() Then
		    Return False
		  End If

		  If Not ParseHmtxTable() Then
		    Return False
		  End If

		  If Not ParseCmapTable() Then
		    Return False
		  End If

		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseHeadTable() As Boolean
		  If Not mTables.HasKey("head") Then
		    Return False
		  End If
		  
		  Dim tableInfo As Dictionary = mTables.Value("head")
		  Dim offset As Integer = tableInfo.Value("offset")

		  Dim mb As MemoryBlock = GetFontDataAsMemoryBlock()
		  If mb = Nil Then Return False
		  mb.LittleEndian = False // Big-endian
		  
		  mUnitsPerEm = mb.UInt16Value(offset + 18)
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseHheaTable() As Boolean
		  If Not mTables.HasKey("hhea") Then
		    Return False
		  End If
		  
		  Dim tableInfo As Dictionary = mTables.Value("hhea")
		  Dim offset As Integer = tableInfo.Value("offset")

		  Dim mb As MemoryBlock = GetFontDataAsMemoryBlock()
		  If mb = Nil Then Return False
		  mb.LittleEndian = False // Big-endian
		  
		  mAscender = mb.Int16Value(offset + 4)
		  mDescender = mb.Int16Value(offset + 6)
		  mLineGap = mb.Int16Value(offset + 8)
		  mNumOfLongHorMetrics = mb.UInt16Value(offset + 34)
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseHmtxTable() As Boolean
		  If Not mTables.HasKey("hmtx") Then
		    Return False
		  End If

		  Dim tableInfo As Dictionary = mTables.Value("hmtx")
		  Dim offset As Integer = tableInfo.Value("offset")

		  Dim mb As MemoryBlock = GetFontDataAsMemoryBlock()
		  If mb = Nil Then
		    Return False
		  End If
		  mb.LittleEndian = False // Big-endian

		  // Store glyph widths
		  mGlyphWidths = New Dictionary

		  // Read horizontal metrics for each glyph
		  For i As Integer = 0 To mNumOfLongHorMetrics - 1
		    Dim pos As Integer = offset + (i * 4)
		    Dim advanceWidth As UInt16 = mb.UInt16Value(pos)
		    mGlyphWidths.Value(Str(i)) = advanceWidth
		  Next

		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseMaxpTable() As Boolean
		  If Not mTables.HasKey("maxp") Then
		    Return False
		  End If

		  Dim tableInfo As Dictionary = mTables.Value("maxp")
		  Dim offset As Integer = tableInfo.Value("offset")

		  Dim mb As MemoryBlock = GetFontDataAsMemoryBlock()
		  If mb = Nil Then
		    Return False
		  End If
		  mb.LittleEndian = False // Big-endian

		  mNumGlyphs = mb.UInt16Value(offset + 4)

		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseNameTable() As Boolean
		  If Not mTables.HasKey("name") Then
		    Return False
		  End If

		  Dim tableInfo As Dictionary = mTables.Value("name")
		  Dim offset As Integer = tableInfo.Value("offset")

		  Dim mb As MemoryBlock = GetFontDataAsMemoryBlock()
		  If mb = Nil Then
		    Return False
		  End If
		  mb.LittleEndian = False // Big-endian

		  Dim format As UInt16 = mb.UInt16Value(offset)
		  Dim count As UInt16 = mb.UInt16Value(offset + 2)
		  Dim stringOffset As UInt16 = mb.UInt16Value(offset + 4)

		  // Look for font name (nameID = 6, PostScript name)
		  // Try multiple platforms in order of preference:
		  // 1. Windows platform (platform=3, encoding=1) - most reliable for modern fonts
		  // 2. Mac platform (platform=1, encoding=0) - ASCII-compatible
		  Dim macName As String = ""
		  Dim winName As String = ""

		  For i As Integer = 0 To count - 1
		    Dim recordOffset As Integer = offset + 6 + (i * 12)

		    Dim platformID As UInt16 = mb.UInt16Value(recordOffset)
		    Dim encodingID As UInt16 = mb.UInt16Value(recordOffset + 2)
		    Dim languageID As UInt16 = mb.UInt16Value(recordOffset + 4)
		    Dim nameID As UInt16 = mb.UInt16Value(recordOffset + 6)
		    Dim length As UInt16 = mb.UInt16Value(recordOffset + 8)
		    Dim nameOffset As UInt16 = mb.UInt16Value(recordOffset + 10)

		    If nameID = 6 Then // PostScript name
		      Dim namePos As Integer = offset + stringOffset + nameOffset

		      If platformID = 1 And encodingID = 0 Then
		        // Mac Roman encoding (ASCII-compatible)
		        // Extract byte-by-byte to avoid iOS MemoryBlock.StringValue() crash on large buffers
		        Dim result As String = ""
		        For j As Integer = 0 To length - 1
		          Dim byteVal As UInt8 = mb.UInt8Value(namePos + j)
		          If byteVal > 0 Then
		            result = result + Chr(byteVal)
		          End If
		        Next
		        macName = result

		      ElseIf platformID = 3 And encodingID = 1 Then
		        // Windows Unicode (UTF-16BE)
		        // Decode UTF-16BE inline to avoid iOS MemoryBlock.StringValue() crash on large buffers
		        Dim result As String = ""
		        Dim numChars As Integer = length / 2
		        For j As Integer = 0 To numChars - 1
		          Dim charCode As UInt16 = mb.UInt16Value(namePos + (j * 2))
		          If charCode > 0 Then
		            result = result + Chr(charCode)
		          End If
		        Next
		        winName = result
		      End If
		    End If
		  Next

		  // PREFER Windows name over Mac name (Windows name is more reliable for modern fonts)
		  // Some fonts (like Arial.ttf) have "Helvetica" in Mac name but "ArialMT" in Windows name
		  If winName <> "" Then
		    mFontName = winName
		  ElseIf macName <> "" Then
		    mFontName = macName
		  Else
		    mFontName = "UnknownFont"
		  End If

		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E766572742066 6F6E742064617461207374 72696E6720746F204D656D6F 7279426C6F636B20736166656C 7920666F722062696E617279206F 70657261 74696F6E732E0A
		Private Function GetFontDataAsMemoryBlock() As MemoryBlock
		  // Convert font data string to MemoryBlock safely for binary operations
		  // Returns: MemoryBlock with font data, or Nil on error

		  // iOS: If loaded from MemoryBlock, return it directly
		  If mFontDataMB <> Nil Then
		    Return mFontDataMB
		  End If

		  If mFontData = "" Then
		    Return Nil
		  End If

		  #If TargetiOS Then
		    // iOS: mFontData has ISOLatin1 encoding (single-byte)
		    // Use Bytes property to get binary length
		    Dim dataLen As Integer = mFontData.Bytes
		    If dataLen = 0 Then
		      Return Nil
		    End If

		    Dim mb As New MemoryBlock(dataLen)
		    mb.StringValue(0, dataLen) = mFontData
		    Return mb
		  #Else
		    // Desktop/Console/Web: Use LenB for byte length
		    Dim dataLen As Integer = mFontData.Bytes
		    If dataLen = 0 Then
		      Return Nil
		    End If

		    Dim mb As New MemoryBlock(dataLen)
		    mb.StringValue(0, dataLen) = mFontData
		    Return mb
		  #EndIf
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFontName
			End Get
		#tag EndGetter
		FontName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mIsValid
			End Get
		#tag EndGetter
		IsValid As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAscender As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCharToGlyph As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDescender As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontData As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontDataMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGlyphWidths As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsValid As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineGap As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNumGlyphs As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNumOfLongHorMetrics As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTables As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUnitsPerEm As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mAscender
			End Get
		#tag EndGetter
		Ascent As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return 700 // Default cap height (70% of em)
			End Get
		#tag EndGetter
		CapHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mDescender
			End Get
		#tag EndGetter
		Descent As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return 32 // Symbolic font flag
			End Get
		#tag EndGetter
		Flags As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return 1000 // Default width for missing glyphs
			End Get
		#tag EndGetter
		MissingWidth As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return -100 // Default value
			End Get
		#tag EndGetter
		UnderlinePosition As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return 50 // Default value
			End Get
		#tag EndGetter
		UnderlineThickness As Integer
	#tag EndComputedProperty


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
		#tag ViewProperty
			Name="IsValid"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UnderlinePosition"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UnderlineThickness"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
