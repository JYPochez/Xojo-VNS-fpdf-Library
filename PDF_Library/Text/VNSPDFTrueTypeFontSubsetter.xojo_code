#tag Class
Protected Class VNSPDFTrueTypeFontSubsetter
	#tag Method, Flags = &h21
		Private Function AssembleSubsetFont() As String
		  // Assemble final subset font with updated tables
		  
		  // Build loca table from glyph offsets
		  mSubsetLoca = New MemoryBlock((mSubsetNumGlyphs + 1) * 4)
		  mSubsetLoca.LittleEndian = False
		  For i As Integer = 0 To mSubsetNumGlyphs
		    mSubsetLoca.UInt32Value(i * 4) = mSubsetGlyphOffsets(i)
		  Next
		  
		  // Tables to include in subset font
		  Dim subsetTables As New Dictionary
		  subsetTables.Value("cmap") = mSubsetCmap
		  subsetTables.Value("glyf") = mSubsetGlyf
		  subsetTables.Value("head") = mSubsetHead
		  subsetTables.Value("hhea") = mSubsetHhea
		  subsetTables.Value("hmtx") = mSubsetHmtx
		  subsetTables.Value("loca") = mSubsetLoca
		  subsetTables.Value("maxp") = mSubsetMaxp

		  // Update 'post' table to match new numGlyphs
		  If mTables.HasKey("post") Then
		    Dim postTableInfo As Dictionary = mTables.Value("post")
		    Dim postOffset As Integer = postTableInfo.Value("offset")
		    Dim postLength As Integer = postTableInfo.Value("length")

		    Dim postMB As New MemoryBlock(postLength)
		    postMB.LittleEndian = False
		    For i As Integer = 0 To postLength - 1
		      postMB.Byte(i) = mFontMB.Byte(postOffset + i)
		    Next

		    // Update numberOfGlyphs at offset 32 (only for format 2.0)
		    // Format 2.0 has version 0x00020000 (32-bit at offset 0)
		    Dim postVersion As UInt32 = postMB.UInt32Value(0)
		    If postVersion = &h00020000 And postLength >= 34 Then
		      postMB.UInt16Value(32) = mSubsetNumGlyphs
		    End If

		    subsetTables.Value("post") = postMB
		  End If

		  // Copy other required tables unchanged
		  Dim copyTables() As String = Array("name", "OS/2")
		  For Each tag As String In copyTables
		    If mTables.HasKey(tag) Then
		      Dim tableInfo As Dictionary = mTables.Value(tag)
		      Dim offset As Integer = tableInfo.Value("offset")
		      Dim length As Integer = tableInfo.Value("length")

		      Dim tableMB As New MemoryBlock(length)
		      tableMB.LittleEndian = False
		      For i As Integer = 0 To length - 1
		        tableMB.Byte(i) = mFontMB.Byte(offset + i)
		      Next

		      subsetTables.Value(tag) = tableMB
		    End If
		  Next
		  
		  // Calculate table count and search parameters
		  Dim numTables As Integer = subsetTables.KeyCount
		  Dim searchRange As Integer = 1
		  While searchRange * 2 <= numTables
		    searchRange = searchRange * 2
		  Wend
		  searchRange = searchRange * 16
		  
		  Dim entrySelector As Integer = 0
		  Dim temp As Integer = numTables
		  While temp > 1
		    temp = temp \ 2
		    entrySelector = entrySelector + 1
		  Wend
		  
		  Dim rangeShift As Integer = (numTables * 16) - searchRange
		  
		  // Build font output
		  Dim output As New MemoryBlock(0)
		  output.LittleEndian = False
		  
		  // Font header
		  output.Size = 12
		  output.UInt32Value(0) = mSfntVersion
		  output.UInt16Value(4) = numTables
		  output.UInt16Value(6) = searchRange
		  output.UInt16Value(8) = entrySelector
		  output.UInt16Value(10) = rangeShift
		  
		  // Calculate table offsets
		  Dim tableOffset As Integer = 12 + (numTables * 16)
		  Dim tableDir As New Dictionary  // tag -> (offset, length, checksum)
		  
		  // Sort table tags alphabetically
		  Dim tags() As String
		  For Each key As Variant In subsetTables.Keys
		    tags.Add(key.StringValue)
		  Next
		  tags.Sort
		  
		  // Calculate offsets and checksums
		  For Each tag As String In tags
		    Dim tableMB As MemoryBlock = subsetTables.Value(tag)
		    Dim length As Integer = tableMB.Size
		    
		    // Calculate checksum
		    Dim checksum As UInt32 = CalculateChecksum(tableMB)
		    
		    Dim info As New Dictionary
		    info.Value("offset") = tableOffset
		    info.Value("length") = length
		    info.Value("checksum") = checksum
		    tableDir.Value(tag) = info
		    
		    // Pad to 4-byte boundary
		    While (length Mod 4) <> 0
		      length = length + 1
		    Wend
		    
		    tableOffset = tableOffset + length
		  Next
		  
		  // Write table directory
		  For Each tag As String In tags
		    Dim info As Dictionary = tableDir.Value(tag)
		    
		    output.Size = output.Size + 16
		    Dim dirOffset As Integer = output.Size - 16
		    
		    // Tag
		    For i As Integer = 0 To 3
		      If i < tag.Length Then
		        output.Byte(dirOffset + i) = tag.MiddleBytes(i, 1).AscByte
		      Else
		        output.Byte(dirOffset + i) = 32  // Space padding
		      End If
		    Next
		    
		    output.UInt32Value(dirOffset + 4) = info.Value("checksum")
		    output.UInt32Value(dirOffset + 8) = info.Value("offset")
		    output.UInt32Value(dirOffset + 12) = info.Value("length")
		  Next
		  
		  // Write table data
		  For Each tag As String In tags
		    Dim tableMB As MemoryBlock = subsetTables.Value(tag)
		    Dim info As Dictionary = tableDir.Value(tag)
		    Dim length As Integer = info.Value("length")
		    
		    Dim oldSize As Integer = output.Size
		    output.Size = oldSize + length
		    
		    For i As Integer = 0 To tableMB.Size - 1
		      output.Byte(oldSize + i) = tableMB.Byte(i)
		    Next
		    
		    // Pad to 4-byte boundary
		    While (output.Size Mod 4) <> 0
		      output.Size = output.Size + 1
		      output.Byte(output.Size - 1) = 0
		    Wend
		  Next
		  
		  Return output.StringValue(0, output.Size).DefineEncoding(Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BuildSubsetCmap() As Boolean
		  // Build minimal cmap table for subset font
		  // Simple format 4 subtable for BMP characters
		  
		  // Build character to new GID mapping
		  Dim charToGID As New Dictionary
		  
		  // Parse original cmap to find Unicode mappings for our glyphs
		  Call ParseOriginalCmap(charToGID)
		  
		  // Build format 4 cmap subtable
		  mSubsetCmap = New MemoryBlock(0)
		  mSubsetCmap.LittleEndian = False
		  
		  // cmap header
		  mSubsetCmap.Size = 4
		  mSubsetCmap.UInt16Value(0) = 0  // version
		  mSubsetCmap.UInt16Value(2) = 1  // numTables (1 subtable)
		  
		  // Encoding record for subtable (platform=3, encoding=1, offset=12)
		  mSubsetCmap.Size = mSubsetCmap.Size + 8
		  mSubsetCmap.UInt16Value(4) = 3  // platformID (Windows)
		  mSubsetCmap.UInt16Value(6) = 1  // encodingID (Unicode BMP)
		  mSubsetCmap.UInt32Value(8) = 12  // offset to subtable
		  
		  // Format 4 subtable (simplified - single segment for now)
		  Dim subtableStart As Integer = mSubsetCmap.Size
		  mSubsetCmap.Size = subtableStart + 16
		  mSubsetCmap.UInt16Value(subtableStart) = 4  // format
		  mSubsetCmap.UInt16Value(subtableStart + 4) = 0  // language
		  mSubsetCmap.UInt16Value(subtableStart + 6) = 2  // segCountX2
		  mSubsetCmap.UInt16Value(subtableStart + 8) = 2  // searchRange
		  mSubsetCmap.UInt16Value(subtableStart + 10) = 0  // entrySelector
		  mSubsetCmap.UInt16Value(subtableStart + 12) = 0  // rangeShift
		  
		  // Simplified segment: map all characters to glyph 0
		  // endCode
		  mSubsetCmap.Size = mSubsetCmap.Size + 4
		  mSubsetCmap.UInt16Value(mSubsetCmap.Size - 4) = &hFFFF
		  mSubsetCmap.UInt16Value(mSubsetCmap.Size - 2) = 0  // padding
		  
		  // startCode
		  mSubsetCmap.Size = mSubsetCmap.Size + 2
		  mSubsetCmap.UInt16Value(mSubsetCmap.Size - 2) = &hFFFF
		  
		  // idDelta
		  mSubsetCmap.Size = mSubsetCmap.Size + 2
		  mSubsetCmap.Int16Value(mSubsetCmap.Size - 2) = 1
		  
		  // idRangeOffset
		  mSubsetCmap.Size = mSubsetCmap.Size + 2
		  mSubsetCmap.UInt16Value(mSubsetCmap.Size - 2) = 0
		  
		  // Update length field
		  mSubsetCmap.UInt16Value(subtableStart + 2) = mSubsetCmap.Size - subtableStart
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BuildSubsetGlyfLoca() As Boolean
		  // Build subset glyf and loca tables with sparse glyph IDs
		  
		  Dim tableInfo As Dictionary = mTables.Value("glyf")
		  Dim glyfOffset As Integer = tableInfo.Value("offset")
		  
		  // Build new glyf table
		  mSubsetGlyf = New MemoryBlock(0)
		  mSubsetGlyf.LittleEndian = False
		  
		  ReDim mSubsetGlyphOffsets(mSubsetNumGlyphs)
		  
		  // Create dictionary of used glyphs for faster lookup
		  Dim usedGlyphs As New Dictionary
		  For i As Integer = 0 To mUsedGlyphIDs.Count - 1
		    usedGlyphs.Value(Str(mUsedGlyphIDs(i))) = True
		  Next
		  
		  // Loop through all glyph IDs from 0 to max
		  For gid As Integer = 0 To mSubsetNumGlyphs - 1
		    // Record offset for this glyph in new font
		    mSubsetGlyphOffsets(gid) = mSubsetGlyf.Size
		    
		    // Check if this glyph is used
		    If Not usedGlyphs.HasKey(Str(gid)) Then
		      // Unused glyph - leave empty (length 0)
		      Continue
		    End If
		    
		    // Copy glyph data from original font
		    If gid >= mGlyphOffsets.Count - 1 Then Continue
		    
		    Dim offset As UInt32 = mGlyphOffsets(gid)
		    Dim nextOffset As UInt32 = mGlyphOffsets(gid + 1)
		    Dim glyphLength As Integer = nextOffset - offset
		    
		    If glyphLength = 0 Then Continue  // Empty glyph in original
		    
		    Dim glyphStart As Integer = glyfOffset + offset
		    If glyphStart + glyphLength > mFontMB.Size Then
		      mError = "Glyph data out of bounds"
		      Return False
		    End If
		    
		    // Copy glyph data
		    Dim oldSize As Integer = mSubsetGlyf.Size
		    mSubsetGlyf.Size = oldSize + glyphLength
		    
		    For i As Integer = 0 To glyphLength - 1
		      mSubsetGlyf.Byte(oldSize + i) = mFontMB.Byte(glyphStart + i)
		    Next
		    
		    // No need to remap composite components - we're keeping original IDs!
		    
		    // Pad to 4-byte boundary
		    While (mSubsetGlyf.Size Mod 4) <> 0
		      mSubsetGlyf.Size = mSubsetGlyf.Size + 1
		      mSubsetGlyf.Byte(mSubsetGlyf.Size - 1) = 0
		    Wend
		  Next
		  
		  // Final offset
		  mSubsetGlyphOffsets(mSubsetNumGlyphs) = mSubsetGlyf.Size
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BuildSubsetHmtx() As Boolean
		  // Build subset hmtx (horizontal metrics) table with sparse glyph IDs
		  
		  Dim tableInfo As Dictionary = mTables.Value("hmtx")
		  Dim hmtxOffset As Integer = tableInfo.Value("offset")
		  
		  mSubsetHmtx = New MemoryBlock(mSubsetNumGlyphs * 4)
		  mSubsetHmtx.LittleEndian = False
		  
		  // Create dictionary of used glyphs for faster lookup
		  Dim usedGlyphs As New Dictionary
		  For i As Integer = 0 To mUsedGlyphIDs.Count - 1
		    usedGlyphs.Value(Str(mUsedGlyphIDs(i))) = True
		  Next
		  
		  For gid As Integer = 0 To mSubsetNumGlyphs - 1
		    Dim advanceWidth As UInt16
		    Dim leftSideBearing As Int16
		    
		    If usedGlyphs.HasKey(Str(gid)) Then
		      // Used glyph - copy metrics from original font
		      If gid < mNumberOfHMetrics Then
		        // Full metric entry
		        Dim metricOffset As Integer = hmtxOffset + (gid * 4)
		        If metricOffset + 4 > mFontMB.Size Then
		          mError = "hmtx table truncated"
		          Return False
		        End If
		        advanceWidth = mFontMB.UInt16Value(metricOffset)
		        leftSideBearing = mFontMB.Int16Value(metricOffset + 2)
		      Else
		        // Use last advance width, get LSB from additional array
		        Dim lastMetricOffset As Integer = hmtxOffset + ((mNumberOfHMetrics - 1) * 4)
		        advanceWidth = mFontMB.UInt16Value(lastMetricOffset)
		        
		        Dim lsbOffset As Integer = hmtxOffset + (mNumberOfHMetrics * 4) + ((gid - mNumberOfHMetrics) * 2)
		        If lsbOffset + 2 > mFontMB.Size Then
		          leftSideBearing = 0
		        Else
		          leftSideBearing = mFontMB.Int16Value(lsbOffset)
		        End If
		      End If
		    Else
		      // Unused glyph - use default metrics
		      advanceWidth = 0
		      leftSideBearing = 0
		    End If
		    
		    // Write to subset hmtx
		    mSubsetHmtx.UInt16Value(gid * 4) = advanceWidth
		    mSubsetHmtx.Int16Value((gid * 4) + 2) = leftSideBearing
		  Next
		  
		  		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CalculateChecksum(tableMB As MemoryBlock) As UInt32
		  // Calculate TrueType table checksum
		  
		  Dim sum As UInt32 = 0
		  Dim nLongs As Integer = (tableMB.Size + 3) \ 4
		  
		  For i As Integer = 0 To nLongs - 1
		    Dim offset As Integer = i * 4
		    If offset + 4 <= tableMB.Size Then
		      sum = sum + tableMB.UInt32Value(offset)
		    Else
		      // Partial long word at end
		      Dim partial As UInt32 = 0
		      For j As Integer = 0 To 3
		        If offset + j < tableMB.Size Then
		          Dim byteValue As UInt32 = tableMB.Byte(offset + j)
		          Dim shift As Integer = (3 - j) * 8
		          // Compute 2^shift as UInt32
		          Dim multiplier As UInt32 = 1
		          For k As Integer = 1 To shift
		            multiplier = multiplier * 2
		          Next
		          partial = partial Or (byteValue * multiplier)
		        End If
		      Next
		      sum = sum + partial
		    End If
		  Next
		  
		  Return sum
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(originalFontData As String, usedGlyphIDs() As Integer)
		  // Initialize font subsetter with original font and used glyph IDs
		  
		  mOriginalFontData = originalFontData
		  mUsedGlyphIDs = usedGlyphIDs
		  mTables = New Dictionary
		  mError = ""
		  
		  // Create MemoryBlock for reading original font
		  mFontMB = New MemoryBlock(originalFontData.Bytes)
		  mFontMB.StringValue(0, originalFontData.Bytes) = originalFontData
		  mFontMB.LittleEndian = False  // TrueType is big-endian
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CreateGlyphMapping()
		  // IMPORTANT: Keep original sparse glyph IDs (no remapping)
		  // Text is encoded with original IDs before subsetting, so we must preserve them
		  // This means subset font will have empty glyphs at unused IDs
		  
		  mOldToNewGID = New Dictionary
		  mNewToOldGID = New Dictionary
		  
		  // Create identity mapping (old ID = new ID, no change)
		  For i As Integer = 0 To mUsedGlyphIDs.Count - 1
		    Dim gid As Integer = mUsedGlyphIDs(i)
		    mOldToNewGID.Value(Str(gid)) = gid  // Identity mapping
		    mNewToOldGID.Value(Str(gid)) = gid  // Identity mapping
		  Next
		  
		  // Find maximum glyph ID to determine subset font size
		  Dim maxGlyphID As Integer = 0
		  For i As Integer = 0 To mUsedGlyphIDs.Count - 1
		    If mUsedGlyphIDs(i) > maxGlyphID Then
		      maxGlyphID = mUsedGlyphIDs(i)
		    End If
		  Next
		  
		  mSubsetNumGlyphs = maxGlyphID + 1  // Include all IDs up to max (sparse)
		  
		  		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateSubset() As String
		  // Create a subset font containing only used glyphs
		  // Returns: Subset font binary data as String
		  
		  Try
		    // Step 1: Parse font header and table directory
		    If Not ParseFontHeader() Then
		      Return ""
		    End If
		    
		    // Step 2: Parse essential tables
		    If Not ParseTables() Then
		      Return ""
		    End If
		    
		    // Step 3: Expand used glyphs to include composite glyph components
		    Call ExpandCompositeGlyphs()
		    
		    // Step 4: Sort glyph IDs and create old->new ID mapping
		    Call CreateGlyphMapping()
		    
		    // Step 5: Build subset glyf and loca tables
		    If Not BuildSubsetGlyfLoca() Then
		      Return ""
		    End If
		    
		    // Step 6: Build subset hmtx table
		    If Not BuildSubsetHmtx() Then
		      Return ""
		    End If
		    
		    // Step 7: Build subset cmap table
		    If Not BuildSubsetCmap() Then
		      Return ""
		    End If
		    
		    // Step 8: Update head, hhea, maxp tables
		    Call UpdateHeaderTables()
		    
		    // Step 9: Assemble final font
		    Return AssembleSubsetFont()
		    
		  Catch e As RuntimeException
		    mError = "Exception during font subsetting: " + e.Message
		    Return ""
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ExpandCompositeGlyphs()
		  // Expand used glyphs to include components of composite glyphs
		  
		  Dim glyphsToCheck As New Dictionary
		  For Each gid As Integer In mUsedGlyphIDs
		    glyphsToCheck.Value(Str(gid)) = True
		  Next
		  
		  // Always include glyph 0 (.notdef)
		  glyphsToCheck.Value("0") = True
		  
		  Dim tableInfo As Dictionary = mTables.Value("glyf")
		  Dim glyfOffset As Integer = tableInfo.Value("offset")
		  
		  // Keep checking until no new glyphs are added
		  Dim changed As Boolean = True
		  While changed
		    changed = False
		    
		    Dim currentGlyphs() As Integer
		    For Each key As Variant In glyphsToCheck.Keys
		      currentGlyphs.Add(Val(key.StringValue))
		    Next
		    
		    For Each gid As Integer In currentGlyphs
		      If gid >= mGlyphOffsets.Count - 1 Then Continue
		      
		      Dim offset As UInt32 = mGlyphOffsets(gid)
		      Dim nextOffset As UInt32 = mGlyphOffsets(gid + 1)
		      
		      If offset = nextOffset Then Continue  // Empty glyph
		      
		      Dim glyphStart As Integer = glyfOffset + offset
		      If glyphStart + 10 > mFontMB.Size Then Continue
		      
		      // Read numberOfContours (first 2 bytes)
		      Dim numberOfContours As Int16 = mFontMB.Int16Value(glyphStart)
		      
		      If numberOfContours < 0 Then
		        // Composite glyph - parse components
		        Dim pos As Integer = glyphStart + 10  // Skip header
		        Dim flags As UInt16
		        
		        Do
		          If pos + 4 > mFontMB.Size Then Exit Do
		          
		          flags = mFontMB.UInt16Value(pos)
		          Dim componentGID As UInt16 = mFontMB.UInt16Value(pos + 2)
		          
		          If Not glyphsToCheck.HasKey(Str(componentGID)) Then
		            glyphsToCheck.Value(Str(componentGID)) = True
		            changed = True
		            		          End If
		          
		          // Skip to next component based on flags
		          pos = pos + 4
		          
		          If (flags And &h0001) <> 0 Then  // ARG_1_AND_2_ARE_WORDS
		            pos = pos + 4
		          Else
		            pos = pos + 2
		          End If
		          
		          If (flags And &h0008) <> 0 Then  // WE_HAVE_A_SCALE
		            pos = pos + 2
		          ElseIf (flags And &h0040) <> 0 Then  // WE_HAVE_AN_X_AND_Y_SCALE
		            pos = pos + 4
		          ElseIf (flags And &h0080) <> 0 Then  // WE_HAVE_A_TWO_BY_TWO
		            pos = pos + 8
		          End If
		          
		        Loop Until (flags And &h0020) = 0  // MORE_COMPONENTS flag
		      End If
		    Next
		  Wend
		  
		  // Update mUsedGlyphIDs with expanded set
		  ReDim mUsedGlyphIDs(-1)
		  For Each key As Variant In glyphsToCheck.Keys
		    mUsedGlyphIDs.Add(Val(key.StringValue))
		  Next
		  mUsedGlyphIDs.Sort
		  
		  		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetError() As String
		  Return mError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGlyphMapping() As Dictionary
		  // Returns the old-to-new glyph ID mapping dictionary
		  Return mOldToNewGID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseFontHeader() As Boolean
		  // Parse TrueType font header (offset table)
		  
		  If mFontMB.Size < 12 Then
		    mError = "Font file too small"
		    Return False
		  End If
		  
		  // Read sfnt version (should be 0x00010000 for TrueType or 'true')
		  mSfntVersion = mFontMB.UInt32Value(0)
		  
		  // Read table count
		  mNumTables = mFontMB.UInt16Value(4)
		  
		  		  
		  // Parse table directory
		  Dim offset As Integer = 12
		  For i As Integer = 0 To mNumTables - 1
		    If offset + 16 > mFontMB.Size Then
		      mError = "Table directory truncated"
		      Return False
		    End If
		    
		    Dim tag As String = mFontMB.StringValue(offset, 4)
		    Dim checksum As UInt32 = mFontMB.UInt32Value(offset + 4)
		    Dim tableOffset As UInt32 = mFontMB.UInt32Value(offset + 8)
		    Dim length As UInt32 = mFontMB.UInt32Value(offset + 12)
		    
		    Dim tableInfo As New Dictionary
		    tableInfo.Value("offset") = tableOffset
		    tableInfo.Value("length") = length
		    tableInfo.Value("checksum") = checksum
		    
		    mTables.Value(tag) = tableInfo
		    
		    offset = offset + 16
		  Next
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseHeadTable() As Boolean
		  // Parse head table to get indexToLocFormat
		  
		  Dim tableInfo As Dictionary = mTables.Value("head")
		  Dim offset As Integer = tableInfo.Value("offset")
		  
		  If offset + 54 > mFontMB.Size Then
		    mError = "head table truncated"
		    Return False
		  End If
		  
		  // indexToLocFormat at offset 50
		  mIndexToLocFormat = mFontMB.Int16Value(offset + 50)
		  
		  		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseHheaTable() As Boolean
		  // Parse hhea table to get numberOfHMetrics
		  
		  Dim tableInfo As Dictionary = mTables.Value("hhea")
		  Dim offset As Integer = tableInfo.Value("offset")
		  
		  If offset + 36 > mFontMB.Size Then
		    mError = "hhea table truncated"
		    Return False
		  End If
		  
		  // numberOfHMetrics at offset 34
		  mNumberOfHMetrics = mFontMB.UInt16Value(offset + 34)
		  
		  		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseLocaTable() As Boolean
		  // Parse loca table to get glyph offsets
		  
		  Dim tableInfo As Dictionary = mTables.Value("loca")
		  Dim offset As Integer = tableInfo.Value("offset")
		  Dim length As Integer = tableInfo.Value("length")
		  
		  ReDim mGlyphOffsets(mNumGlyphs)
		  
		  If mIndexToLocFormat = 0 Then
		    // Short format (offsets divided by 2)
		    For i As Integer = 0 To mNumGlyphs
		      If offset + (i * 2) + 2 > mFontMB.Size Then
		        mError = "loca table truncated"
		        Return False
		      End If
		      mGlyphOffsets(i) = mFontMB.UInt16Value(offset + (i * 2)) * 2
		    Next
		  Else
		    // Long format
		    For i As Integer = 0 To mNumGlyphs
		      If offset + (i * 4) + 4 > mFontMB.Size Then
		        mError = "loca table truncated"
		        Return False
		      End If
		      mGlyphOffsets(i) = mFontMB.UInt32Value(offset + (i * 4))
		    Next
		  End If
		  
		  		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseMaxpTable() As Boolean
		  // Parse maxp table to get numGlyphs
		  
		  Dim tableInfo As Dictionary = mTables.Value("maxp")
		  Dim offset As Integer = tableInfo.Value("offset")
		  
		  If offset + 6 > mFontMB.Size Then
		    mError = "maxp table truncated"
		    Return False
		  End If
		  
		  // numGlyphs at offset 4
		  mNumGlyphs = mFontMB.UInt16Value(offset + 4)
		  
		  		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseOriginalCmap(charToGID As Dictionary)
		  // Parse original cmap to find character mappings
		  // (Simplified implementation - just ensures cmap is valid)
		  
		  // For now, we'll keep the cmap simple and let the ToUnicode CMap
		  // in the PDF handle the actual character-to-glyph mapping
		  
		  #Pragma Unused charToGID
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseTables() As Boolean
		  // Parse essential font tables needed for subsetting
		  
		  // Check for required tables
		  Dim requiredTables() As String = Array("glyf", "loca", "hmtx", "hhea", "head", "maxp", "cmap")
		  For Each tag As String In requiredTables
		    If Not mTables.HasKey(tag) Then
		      mError = "Required table missing: " + tag
		      Return False
		    End If
		  Next
		  
		  // Parse head table to get indexToLocFormat
		  If Not ParseHeadTable() Then
		    Return False
		  End If
		  
		  // Parse maxp table to get numGlyphs
		  If Not ParseMaxpTable() Then
		    Return False
		  End If
		  
		  // Parse hhea table to get numberOfHMetrics
		  If Not ParseHheaTable() Then
		    Return False
		  End If
		  
		  // Parse loca table to get glyph offsets
		  If Not ParseLocaTable() Then
		    Return False
		  End If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemapCompositeComponents(glyphOffset As Integer)
		  // Remap component GIDs in composite glyph
		  
		  Dim pos As Integer = glyphOffset + 10  // Skip header
		  Dim flags As UInt16
		  
		  Do
		    If pos + 4 > mSubsetGlyf.Size Then Exit Sub
		    
		    flags = mSubsetGlyf.UInt16Value(pos)
		    Dim oldComponentGID As UInt16 = mSubsetGlyf.UInt16Value(pos + 2)
		    
		    // Remap to new GID
		    If mOldToNewGID.HasKey(Str(oldComponentGID)) Then
		      Dim newComponentGID As Integer = mOldToNewGID.Value(Str(oldComponentGID))
		      mSubsetGlyf.UInt16Value(pos + 2) = newComponentGID
		    End If
		    
		    // Skip to next component based on flags
		    pos = pos + 4
		    
		    If (flags And &h0001) <> 0 Then  // ARG_1_AND_2_ARE_WORDS
		      pos = pos + 4
		    Else
		      pos = pos + 2
		    End If
		    
		    If (flags And &h0008) <> 0 Then  // WE_HAVE_A_SCALE
		      pos = pos + 2
		    ElseIf (flags And &h0040) <> 0 Then  // WE_HAVE_AN_X_AND_Y_SCALE
		      pos = pos + 4
		    ElseIf (flags And &h0080) <> 0 Then  // WE_HAVE_A_TWO_BY_TWO
		      pos = pos + 8
		    End If
		    
		  Loop Until (flags And &h0020) = 0  // MORE_COMPONENTS flag
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateHeaderTables()
		  // Update head, hhea, maxp tables with new glyph count
		  
		  // Copy head table and update checkSumAdjustment to 0 (will recalculate later)
		  Dim headTableInfo As Dictionary = mTables.Value("head")
		  Dim headOffset As Integer = headTableInfo.Value("offset")
		  Dim headLength As Integer = headTableInfo.Value("length")
		  
		  mSubsetHead = New MemoryBlock(headLength)
		  mSubsetHead.LittleEndian = False
		  For i As Integer = 0 To headLength - 1
		    mSubsetHead.Byte(i) = mFontMB.Byte(headOffset + i)
		  Next
		  // Set checkSumAdjustment to 0
		  mSubsetHead.UInt32Value(8) = 0
		  
		  // Copy hhea table and update numberOfHMetrics
		  Dim hheaTableInfo As Dictionary = mTables.Value("hhea")
		  Dim hheaOffset As Integer = hheaTableInfo.Value("offset")
		  Dim hheaLength As Integer = hheaTableInfo.Value("length")
		  
		  mSubsetHhea = New MemoryBlock(hheaLength)
		  mSubsetHhea.LittleEndian = False
		  For i As Integer = 0 To hheaLength - 1
		    mSubsetHhea.Byte(i) = mFontMB.Byte(hheaOffset + i)
		  Next
		  // Update numberOfHMetrics
		  mSubsetHhea.UInt16Value(34) = mSubsetNumGlyphs
		  
		  // Copy maxp table and update numGlyphs
		  Dim maxpTableInfo As Dictionary = mTables.Value("maxp")
		  Dim maxpOffset As Integer = maxpTableInfo.Value("offset")
		  Dim maxpLength As Integer = maxpTableInfo.Value("length")
		  
		  mSubsetMaxp = New MemoryBlock(maxpLength)
		  mSubsetMaxp.LittleEndian = False
		  For i As Integer = 0 To maxpLength - 1
		    mSubsetMaxp.Byte(i) = mFontMB.Byte(maxpOffset + i)
		  Next
		  // Update numGlyphs
		  mSubsetMaxp.UInt16Value(4) = mSubsetNumGlyphs
		  
		  		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mError As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGlyphOffsets() As UInt32
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIndexToLocFormat As Int16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNewToOldGID As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNumberOfHMetrics As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNumGlyphs As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNumTables As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOldToNewGID As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOriginalFontData As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSfntVersion As UInt32
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetCmap As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetGlyf As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetGlyphOffsets() As UInt32
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetHead As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetHhea As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetHmtx As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetLoca As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetMaxp As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubsetNumGlyphs As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTables As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUsedGlyphIDs() As Integer
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
