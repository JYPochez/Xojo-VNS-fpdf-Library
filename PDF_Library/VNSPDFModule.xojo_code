#tag Module
Protected Module VNSPDFModule
	#tag DelegateDeclaration, Flags = &h0
		Delegate Function AcceptPageBreakDelegate() As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h1, Description = 436F6E76657274732063656E74696D657465727320746F20706F696E74732E0A
		Protected Function CentimetersToPoints(cm As Double) As Double
		  Return cm * gkPointsPerCentimeter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 526563757273697665207365617263682066726F6D206120726F6F74206469726563746F727920666F722066696C6573206D61746368696E6720616E79206F662074686520676976656E2066696C656E616D6573
		Private Function FindFontInDirectoryRecursive(dirPath As String, fileNames() As String, depth As Integer) As String
		  // Recursively searches a directory for font files matching the given filenames
		  // Returns the full native path if found, empty string if not
		  
		  Const kMaxDepth As Integer = 4
		  If depth > kMaxDepth Then Return ""
		  
		  Try
		    Dim dir As FolderItem = New FolderItem(dirPath, FolderItem.PathModes.Native)
		    If dir = Nil Or Not dir.Exists Or Not dir.IsFolder Then Return ""
		    
		    // First check for matching files directly in this directory
		    For Each fn As String In fileNames
		      Dim fontFile As FolderItem = dir.Child(fn)
		      If fontFile <> Nil And fontFile.Exists And Not fontFile.IsFolder Then
		        Return fontFile.NativePath
		      End If
		    Next
		    
		    // Then recurse into subdirectories
		    Dim childCount As Integer = dir.Count
		    For i As Integer = 1 To childCount
		      Try
		        Dim child As FolderItem = dir.ChildAt(i - 1)
		        If child <> Nil And child.Exists And child.IsFolder Then
		          Dim result As String = FindFontInDirectoryRecursive(child.NativePath, fileNames, depth + 1)
		          If result <> "" Then Return result
		        End If
		      Catch innerErr As RuntimeException
		        Continue
		      End Try
		    Next
		    
		  Catch e As RuntimeException
		    // Skip inaccessible directories
		  End Try
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536561726368657320706C6174666F726D2D737065636966696320666F6E74206469726563746F7269657320726563757273697665206C7920666F72206120547275655479706520666F6E742066696C65
		Function FindSystemFontPath(fontName As String, styleSuffix As String = "") As String
		  // Searches platform-specific font directories recursively for a TrueType font file
		  // fontName: the font name (e.g. "Verdana", "Georgia")
		  // styleSuffix: "" for regular, " Bold", " Italic", " Bold Italic"
		  // Returns the full native path if found, empty string if not
		  //
		  // Example usage:
		  //   Dim path As String = VNSPDFModule.FindSystemFontPath("Verdana")
		  //   If path <> "" Then pdf.AddUTF8Font("verdana", "", path)
		  //
		  // This is called automatically by AddUTF8Font when no file path is provided.
		  
		  // Build cache key
		  If mSystemFontCache = Nil Then mSystemFontCache = New Dictionary
		  Dim cacheKey As String = fontName + "|" + styleSuffix
		  If mSystemFontCache.HasKey(cacheKey) Then
		    Return mSystemFontCache.Value(cacheKey)
		  End If
		  
		  // Build filenames to search for (.ttf and .ttc variants)
		  Dim fileNames() As String
		  Dim baseName As String
		  If styleSuffix <> "" Then
		    baseName = fontName + styleSuffix
		  Else
		    baseName = fontName
		  End If
		  fileNames.Add(baseName + ".ttf")
		  fileNames.Add(baseName + ".ttc")
		  // Also try lowercase variants (common on Linux)
		  Dim lowerBase As String = baseName.Lowercase
		  If lowerBase <> baseName Then
		    fileNames.Add(lowerBase + ".ttf")
		    fileNames.Add(lowerBase + ".ttc")
		  End If
		  
		  // Platform-specific font directories (searched recursively)
		  Dim searchDirs() As String
		  
		  #If TargetiOS Or TargetAndroid Then
		    // iOS: no system font directories to search
		    // Fonts must be bundled with the app
		  #ElseIf TargetMacOS Then
		    searchDirs.Add("/System/Library/Fonts/Supplemental")
		    searchDirs.Add("/System/Library/Fonts")
		    searchDirs.Add("/Library/Fonts")
		    Dim userHome As String = SpecialFolder.UserHome.NativePath
		    If userHome.Right(1) = "/" Then userHome = userHome.Left(userHome.Length - 1)
		    searchDirs.Add(userHome + "/Library/Fonts")
		  #ElseIf TargetWindows Then
		    searchDirs.Add("C:\Windows\Fonts")
		    Dim userHome As String = SpecialFolder.UserHome.NativePath
		    If userHome.Right(1) = "\" Then userHome = userHome.Left(userHome.Length - 1)
		    searchDirs.Add(userHome + "\AppData\Local\Microsoft\Windows\Fonts")
		  #ElseIf TargetLinux Then
		    searchDirs.Add("/usr/share/fonts")
		    searchDirs.Add("/usr/local/share/fonts")
		    Dim userHome As String = SpecialFolder.UserHome.NativePath
		    If userHome.Right(1) = "/" Then userHome = userHome.Left(userHome.Length - 1)
		    searchDirs.Add(userHome + "/.fonts")
		    searchDirs.Add(userHome + "/.local/share/fonts")
		  #EndIf
		  
		  // Look the candidate filenames up in the one-time font-file index
		  // (built by walking searchDirs once). Avoids re-walking the whole
		  // font tree on every call — critical when probing hundreds of fonts
		  // (e.g. a font-picker UI).
		  EnsureSystemFontIndex(searchDirs)
		  For Each fn As String In fileNames
		    Dim k As String = fn.Lowercase
		    If mSystemFontIndex.HasKey(k) Then
		      Dim result As String = mSystemFontIndex.Value(k).StringValue
		      mSystemFontCache.Value(cacheKey) = result
		      Return result
		    End If
		  Next

		  // Not found - cache the miss
		  mSystemFontCache.Value(cacheKey) = ""
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EnsureSystemFontIndex(searchDirs() As String)
		  // Build, once, a map of every font filename (lowercased) -> full
		  // native path across the search directories. Subsequent
		  // FindSystemFontPath calls are O(1) lookups instead of full tree
		  // walks. Rebuilt only when nil.
		  If mSystemFontIndex <> Nil Then Return
		  mSystemFontIndex = New Dictionary
		  For Each d As String In searchDirs
		    Try
		      IndexFontDir(New FolderItem(d, FolderItem.PathModes.Native), 0)
		    Catch e As RuntimeException
		    End Try
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub IndexFontDir(dir As FolderItem, depth As Integer)
		  // Recursively add every file in `dir` to mSystemFontIndex keyed by
		  // lowercased filename. First entry for a name wins (search-dir order).
		  Const kMaxDepth As Integer = 4
		  If dir = Nil Or Not dir.Exists Or Not dir.IsFolder Or depth > kMaxDepth Then Return
		  Dim childCount As Integer = dir.Count
		  For i As Integer = 1 To childCount
		    Try
		      Dim child As FolderItem = dir.ChildAt(i - 1)
		      If child = Nil Or Not child.Exists Then Continue
		      If child.IsFolder Then
		        IndexFontDir(child, depth + 1)
		      Else
		        Dim key As String = child.Name.Lowercase
		        If Not mSystemFontIndex.HasKey(key) Then mSystemFontIndex.Value(key) = child.NativePath
		      End If
		    Catch innerErr As RuntimeException
		      Continue
		    End Try
		  Next
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub FooterDelegateLpi(doc As VNSPDFDocument, lastPage As Boolean)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D20666F726D61742068656C7065722E0A
		Protected Function FormatHelper(value As Double, format As String) As String
		  // Cross-platform format helper
		  // iOS: Use Str() with manual formatting (API2 doesn't have Format)
		  // Desktop: Use Format() function (API1)
		  
		  #If TargetiOS Or TargetAndroid Then
		    // Simple formatting for iOS - handle common cases
		    If format = "0" Then
		      // Integer format - no decimals, avoid scientific notation
		      If value >= 0 Then
		        Dim temp As Double = value + 0.5
		        Return Str(Floor(temp))
		      Else
		        Dim temp As Double = value - 0.5
		        Return Str(Ceiling(temp))
		      End If
		      
		    ElseIf format = "0.##" Then
		      // Optional decimals format (up to 2)
		      // Remove trailing zeros and decimal point if integer
		      Dim rounded As Double = Round(value * 100) / 100
		      Dim result As String = Str(rounded)
		      
		      // Remove scientific notation if present
		      If result.IndexOf("e") > 0 Or result.IndexOf("E") > 0 Then
		        // Convert to proper format
		        If rounded = Floor(rounded) Then
		          Dim temp As Double = rounded + 0.5
		          Return Str(Floor(temp))
		        Else
		          // Has decimals - format manually
		          Dim absVal As Double = Abs(rounded)
		          Dim intPart As Integer = Floor(absVal)
		          Dim decPart As Double = Abs(rounded) - intPart
		          Dim decStr As String = Str(Round(decPart * 100))
		          If decStr.Length = 1 Then decStr = "0" + decStr
		          result = Str(intPart) + "." + decStr
		          If rounded < 0 Then result = "-" + result
		        End If
		      End If
		      
		      Return result
		      
		    ElseIf format = "0.00" Or format = "0.0000" Then
		      Dim decimals As Integer
		      If format = "0.00" Then
		        decimals = 2
		      Else
		        decimals = 4
		      End If
		      
		      // Round to specified decimals
		      Dim multiplier As Double = 10 ^ decimals
		      Dim rounded As Double = Round(value * multiplier) / multiplier
		      
		      // Convert to string
		      Dim result As String = Str(rounded)
		      
		      // Ensure decimal point exists
		      Dim dotPos As Integer = result.IndexOf(".")
		      If dotPos = -1 Then
		        result = result + "."
		        dotPos = result.Length - 1
		      End If
		      
		      // Pad with zeros to desired length
		      Dim currentDecimals As Integer = result.Length - dotPos - 1
		      While currentDecimals < decimals
		        result = result + "0"
		        currentDecimals = currentDecimals + 1
		      Wend
		      
		      Return result
		    Else
		      // Fallback for other formats
		      Return Str(value)
		    End If
		  #Else
		    Return Format(value, format)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 476574206368617261637465722077696474682066726F6D20636F726520666F6E74206D6574726963732028696E20676C79706820756E697473292E0A
		Protected Function GetCoreFontCharWidth(fontKey As String, charCode As Integer) As Integer
		  // Returns character width in glyph units (1/1000 of em)
		  // Font metrics from go-fpdf font_embed
		  
		  If charCode < 0 Or charCode > 255 Then
		    Return 500 // Default width for out of range characters
		  End If
		  
		  Select Case fontKey
		  Case "courier", "courierB", "courierI", "courierBI"
		    // Courier is monospaced - all characters are 600 units wide
		    Return 600
		    
		  Case "helvetica"
		    Dim widths() As Integer = GetHelveticaWidths()
		    Return widths(charCode)
		    
		  Case "helveticaB"
		    Dim widths() As Integer = GetHelveticaBoldWidths()
		    Return widths(charCode)
		    
		  Case "helveticaI"
		    Dim widths() As Integer = GetHelveticaItalicWidths()
		    Return widths(charCode)
		    
		  Case "helveticaBI"
		    Dim widths() As Integer = GetHelveticaBoldItalicWidths()
		    Return widths(charCode)
		    
		  Case "times"
		    Dim widths() As Integer = GetTimesWidths()
		    Return widths(charCode)
		    
		  Case "timesB"
		    Dim widths() As Integer = GetTimesBoldWidths()
		    Return widths(charCode)
		    
		  Case "timesI"
		    Dim widths() As Integer = GetTimesItalicWidths()
		    Return widths(charCode)
		    
		  Case "timesBI"
		    Dim widths() As Integer = GetTimesBoldItalicWidths()
		    Return widths(charCode)
		    
		  Else
		    // Default to 500 for unknown fonts
		    Return 500
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetHelveticaBoldItalicWidths() As Integer()
		  Static cachedWidths() As Integer
		  If cachedWidths.Count = 0 Then
		    cachedWidths = ParseFontMetrics(kHelveticaBoldJSON) // Same as bold
		  End If
		  Return cachedWidths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetHelveticaBoldWidths() As Integer()
		  Static cachedWidths() As Integer
		  If cachedWidths.Count = 0 Then
		    cachedWidths = ParseFontMetrics(kHelveticaBoldJSON)
		  End If
		  Return cachedWidths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetHelveticaItalicWidths() As Integer()
		  Static cachedWidths() As Integer
		  If cachedWidths.Count = 0 Then
		    cachedWidths = ParseFontMetrics(kHelveticaJSON) // Same as regular Helvetica
		  End If
		  Return cachedWidths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetHelveticaWidths() As Integer()
		  Static cachedWidths() As Integer
		  If cachedWidths.Count = 0 Then
		    cachedWidths = ParseFontMetrics(kHelveticaJSON)
		  End If
		  Return cachedWidths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D206D6963726F7365636F6E64732068656C7065722E0A
		Protected Function GetMicroseconds() As Int64
		  // Cross-platform microseconds helper
		  // iOS: Use System.Microseconds (API2)
		  // Desktop: Use Microseconds function (API1)
		  
		  Return System.Microseconds
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E7320706167652064696D656E73696F6E7320666F7220676976656E20666F726D617420617320506169722E0A
		Protected Function GetPageFormatDimensions(format As ePageFormat) As Pair
		  Select Case format
		  Case ePageFormat.A3
		    Return New Pair(gkA3Width, gkA3Height)
		  Case ePageFormat.A4
		    Return New Pair(gkA4Width, gkA4Height)
		  Case ePageFormat.A5
		    Return New Pair(gkA5Width, gkA5Height)
		  Case ePageFormat.Letter
		    Return New Pair(gkLetterWidth, gkLetterHeight)
		  Case ePageFormat.Legal
		    Return New Pair(gkLegalWidth, gkLegalHeight)
		  Else
		    // Default to A4
		    Return New Pair(gkA4Width, gkA4Height)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTimesBoldItalicWidths() As Integer()
		  Static cachedWidths() As Integer
		  If cachedWidths.Count = 0 Then
		    cachedWidths = ParseFontMetrics(kTimesJSON) // For simplicity, use same
		  End If
		  Return cachedWidths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTimesBoldWidths() As Integer()
		  Static cachedWidths() As Integer
		  If cachedWidths.Count = 0 Then
		    cachedWidths = ParseFontMetrics(kTimesJSON) // For simplicity, use same
		  End If
		  Return cachedWidths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTimesItalicWidths() As Integer()
		  Static cachedWidths() As Integer
		  If cachedWidths.Count = 0 Then
		    cachedWidths = ParseFontMetrics(kTimesJSON) // For simplicity, use same
		  End If
		  Return cachedWidths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTimesWidths() As Integer()
		  Static cachedWidths() As Integer
		  If cachedWidths.Count = 0 Then
		    cachedWidths = ParseFontMetrics(kTimesJSON)
		  End If
		  Return cachedWidths
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub HeaderFooterDelegate(doc As VNSPDFDocument)
	#tag EndDelegateDeclaration

	#tag DelegateDeclaration, Flags = &h0, Description = 48544D4C207461672068616E646C65723A2063616C6C6564207768656E206120726567697374657265642074616720697320656E636F756E746572656420647572696E672072656E646572696E67
		Delegate Sub HTMLTagHandlerDelegate(doc As VNSPDFDocument, token As Object, isClosing As Boolean)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h1, Description = 4368656620696620556E69636F646520636F646520706F696E7420697320616E20656D6F6A692E0A
		Protected Function IsEmoji(codePoint As UInt32) As Boolean
		  // Check if Unicode code point represents an emoji character
		  // Based on Unicode 15.0 emoji ranges (2023)
		  
		  // Emoticons (U+1F600 to U+1F64F)
		  If codePoint >= &h1F600 And codePoint <= &h1F64F Then Return True
		  
		  // Miscellaneous Symbols and Pictographs (U+1F300 to U+1F5FF)
		  If codePoint >= &h1F300 And codePoint <= &h1F5FF Then Return True
		  
		  // Transport and Map Symbols (U+1F680 to U+1F6FF)
		  If codePoint >= &h1F680 And codePoint <= &h1F6FF Then Return True
		  
		  // Supplemental Symbols and Pictographs (U+1F900 to U+1F9FF)
		  If codePoint >= &h1F900 And codePoint <= &h1F9FF Then Return True
		  
		  // Symbols and Pictographs Extended-A (U+1FA00 to U+1FA6F)
		  If codePoint >= &h1FA00 And codePoint <= &h1FA6F Then Return True
		  
		  // Additional emoji ranges
		  // Dingbats (U+2700 to U+27BF)
		  If codePoint >= &h2700 And codePoint <= &h27BF Then Return True
		  
		  // Miscellaneous Symbols (U+2600 to U+26FF)
		  If codePoint >= &h2600 And codePoint <= &h26FF Then Return True
		  
		  // Enclosed Alphanumeric Supplement (U+1F100 to U+1F1FF) - includes flags
		  If codePoint >= &h1F100 And codePoint <= &h1F1FF Then Return True
		  
		  // Miscellaneous Symbols and Arrows (U+2B00 to U+2BFF)
		  If codePoint >= &h2B00 And codePoint <= &h2BFF Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732054727565207768656E2061206772617068656D6520636C757374657220286F6E6520656C656D656E74206F6620537472696E672E436861726163746572732920697320616E20656D6F6A692C20696E636C7564696E6720736B696E2D746F6E652C205A574A2C20666C616720616E64206B65796361702073657175656E6365732E
		Protected Function IsEmojiCluster(cluster As String) As Boolean
		  // cluster is one element of String.Characters, so multi-code-point emoji such as
		  // skin tones and ZWJ sequences (e.g. woman + skin tone + ZWJ + laptop), flags and
		  // keycaps arrive whole and can be drawn as a single glyph by the OS emoji font.
		  // The first code point decides for ordinary emoji; U+FE0F (emoji presentation)
		  // or U+20E3 (combining keycap) also marks text-default symbols such as 1️⃣ or ©️.
		  If cluster = "" Then Return False
		  If IsEmoji(cluster.Asc) Then Return True
		  Return cluster.IndexOf(&uFE0F, ComparisonOptions.CaseSensitive) >= 0 _
		  Or cluster.IndexOf(&u20E3, ComparisonOptions.CaseSensitive) >= 0
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0, Description = 4D61726B646F776E206C696E652068616E646C65723A2063616C6C6564207768656E206120726567697374657265642070726566697820697320666F756E64206174206C696E652073746172742E2052657475726E732048544D4C20737472696E6720746F20696E736572742E
		Delegate Function MarkdownLineHandlerDelegate(doc As VNSPDFDocument, line As String) As String
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h1, Description = 436F6E7665727473206D696C6C696D657465727320746F20706F696E74732E0A
		Protected Function MillimetersToPoints(mm As Double) As Double
		  Return mm * gkPointsPerMillimeter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E7665727473207061676520666F726D617420656E756D20746F20737472696E672E0A
		Protected Function PageFormatToString(format As ePageFormat) As String
		  Select Case format
		  Case ePageFormat.A3
		    Return "A3"
		  Case ePageFormat.A4
		    Return "A4"
		  Case ePageFormat.A5
		    Return "A5"
		  Case ePageFormat.Letter
		    Return "Letter"
		  Case ePageFormat.Legal
		    Return "Legal"
		  Case ePageFormat.Custom
		    Return "Custom"
		  Else
		    Return "Unknown"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E76657274732070616765206F7269656E746174696F6E20656E756D20746F20737472696E672E0A
		Protected Function PageOrientationToString(orientation As ePageOrientation) As String
		  Select Case orientation
		  Case ePageOrientation.Portrait
		    Return "Portrait"
		  Case ePageOrientation.Landscape
		    Return "Landscape"
		  Else
		    Return "Unknown"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E7665727473207061676520756E697420656E756D20746F20737472696E672E0A
		Protected Function PageUnitToString(unit As ePageUnit) As String
		  Select Case unit
		  Case ePageUnit.Points
		    Return "Points"
		  Case ePageUnit.Millimeters
		    Return "Millimeters"
		  Case ePageUnit.Centimeters
		    Return "Centimeters"
		  Case ePageUnit.Inches
		    Return "Inches"
		  Else
		    Return "Unknown"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736520666F6E74206D6574726963732066726F6D204A534F4E2E0A
		Private Function ParseFontMetrics(jsonData As String) As Integer()
		  // Parse JSON font metrics from go-fpdf format
		  // Returns character widths array
		  
		  Dim widths(255) As Integer
		  
		  Try
		    // Find the "Cw" array in JSON
		    Dim cwPos As Integer = jsonData.IndexOf("""Cw"":[")
		    If cwPos < 0 Then
		      // Default to 500 for all characters if parsing fails
		      For i As Integer = 0 To 255
		        widths(i) = 500
		      Next
		      Return widths
		    End If
		    
		    // Extract the array content
		    Dim startPos As Integer = cwPos + 6 // Position after "Cw":[
		    
		    // API2 compatible: search for ] in the remainder of the string
		    Dim remainder As String = jsonData.Middle(startPos)
		    Dim endPosInRemainder As Integer = remainder.IndexOf("]")
		    
		    If endPosInRemainder < 0 Then
		      // Malformed JSON, use defaults
		      For i As Integer = 0 To 255
		        widths(i) = 500
		      Next
		      Return widths
		    End If
		    
		    // Calculate actual end position
		    Dim arrayStr As String = remainder.Left(endPosInRemainder)
		    
		    // Parse comma-separated values
		    Dim parts() As String = arrayStr.Split(",")
		    For i As Integer = 0 To Min(255, parts.LastIndex)
		      widths(i) = Val(parts(i).Trim)
		    Next
		    
		  Catch
		    // Default to 500 for all characters if parsing fails
		    For i As Integer = 0 To 255
		      widths(i) = 500
		    Next
		  End Try
		  
		  Return widths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E766572747320706F696E747320746F2063656E74696D65746572732E0A
		Protected Function PointsToCentimeters(points As Double) As Double
		  Return points / gkPointsPerCentimeter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E766572747320706F696E747320746F20696E636865732E0A
		Protected Function PointsToInches(points As Double) As Double
		  Return points / gkPointsPerInch
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E766572747320706F696E747320746F206D696C6C696D65746572732E0A
		Protected Function PointsToMillimeters(points As Double) As Double
		  Return points / gkPointsPerMillimeter
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0, Description = 50726F677265737320757064617465206465656761746520666F72206C6F6E672D72756E6E696E67206F7065726174696F6E732E0A
		Delegate Sub ProgressDelegate(percentage As Double)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h1, Description = 457874726163747320504E4720656D6F6A6920696D61676520646174612066726F6D20616E205342495820666F6E742066696C6520666F722074686520676976656E20636F6465706F696E7420616E642073697A652E0A
		Protected Function ExtractEmojiPNG_SBIX(fontFilePath As String, emojiCodePoint As UInt32, desiredSize As Integer) As MemoryBlock
		  // Extracts PNG bitmap data for an emoji from an SBIX (Standard Bitmap Graphics) font table.
		  // Parses TTC/TrueType font, locates cmap and sbix tables, finds the glyph for the
		  // codepoint, and returns the raw PNG data from the best-matching strike size.
		  // Returns Nil on any failure (file not found, table missing, glyph not found).

		  // Check cache first
		  Dim cacheKey As String = fontFilePath + ":" + Str(emojiCodePoint) + ":" + Str(desiredSize)
		  If mSBIXCache <> Nil And mSBIXCache.HasKey(cacheKey) Then
		    Return MemoryBlock(mSBIXCache.Value(cacheKey))
		  End If

		  // Use cached font data if same file, otherwise read and cache
		  Dim mb As MemoryBlock
		  Dim cmapOffset As UInt32
		  Dim cmapLength As UInt32
		  Dim sbixOffset As UInt32
		  Dim sbixLength As UInt32
		  Dim maxpOffset As UInt32

		  If mSBIXFontMB <> Nil And mSBIXFontPath = fontFilePath And mSBIXTableInfo <> Nil Then
		    // Reuse cached font data and table info
		    mb = mSBIXFontMB
		    cmapOffset = mSBIXTableInfo.Value("cmapOffset")
		    cmapLength = mSBIXTableInfo.Value("cmapLength")
		    sbixOffset = mSBIXTableInfo.Value("sbixOffset")
		    sbixLength = mSBIXTableInfo.Value("sbixLength")
		    maxpOffset = mSBIXTableInfo.Value("maxpOffset")
		  Else
		    // Read and parse font file, then cache
		    Dim f As FolderItem = New FolderItem(fontFilePath, FolderItem.PathModes.Native)
		    If f = Nil Or Not f.Exists Then Return Nil

		    Dim bs As BinaryStream
		    Try
		      bs = BinaryStream.Open(f, False)
		    Catch e As IOException
		      Return Nil
		    End Try

		    Dim fontFileSize As Integer = bs.Length
		    If fontFileSize < 12 Then
		      bs.Close
		      Return Nil
		    End If

		    mb = bs.Read(fontFileSize)
		    bs.Close
		    mb.LittleEndian = False

		    // Determine font offset (handle TTC collections)
		    Dim fontOffset As UInt32 = 0
		    If mb.StringValue(0, 4) = "ttcf" Then
		      If mb.UInt32Value(8) < 1 Then Return Nil
		      fontOffset = mb.UInt32Value(12)
		      If fontOffset >= mb.Size Then Return Nil
		    End If

		    // Read table directory
		    If fontOffset + 12 > mb.Size Then Return Nil
		    Dim numTables As UInt16 = mb.UInt16Value(fontOffset + 4)
		    Dim tableRecordStart As UInt32 = fontOffset + 12
		    If tableRecordStart + (numTables * 16) > mb.Size Then Return Nil

		    cmapOffset = 0
		    cmapLength = 0
		    sbixOffset = 0
		    sbixLength = 0
		    maxpOffset = 0

		    Dim i As Integer
		    For i = 0 To numTables - 1
		      Dim recOffset As UInt32 = tableRecordStart + (i * 16)
		      Dim tableTag As String = mb.StringValue(recOffset, 4)
		      If tableTag = "cmap" Then
		        cmapOffset = mb.UInt32Value(recOffset + 8)
		        cmapLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "sbix" Then
		        sbixOffset = mb.UInt32Value(recOffset + 8)
		        sbixLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "maxp" Then
		        maxpOffset = mb.UInt32Value(recOffset + 8)
		      End If
		    Next

		    If cmapOffset = 0 Or sbixOffset = 0 Then Return Nil

		    // Cache everything for next call
		    mSBIXFontMB = mb
		    mSBIXFontPath = fontFilePath
		    mSBIXTableInfo = New Dictionary
		    mSBIXTableInfo.Value("cmapOffset") = cmapOffset
		    mSBIXTableInfo.Value("cmapLength") = cmapLength
		    mSBIXTableInfo.Value("sbixOffset") = sbixOffset
		    mSBIXTableInfo.Value("sbixLength") = sbixLength
		    mSBIXTableInfo.Value("maxpOffset") = maxpOffset
		  End If

		  // Get numGlyphs from maxp table
		  Dim numGlyphs As UInt32 = 0
		  If maxpOffset > 0 And maxpOffset + 6 <= mb.Size Then
		    numGlyphs = mb.UInt16Value(maxpOffset + 4)
		  End If
		  If numGlyphs = 0 Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: Cannot determine numGlyphs from maxp table")
		    Return Nil
		  End If

		  // Look up glyph ID from cmap
		  Dim glyphID As Integer = GetGlyphIDFromCmap(mb, cmapOffset, cmapLength, emojiCodePoint)
		  If glyphID <= 0 Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: Glyph not found for codepoint " + Str(emojiCodePoint))
		    Return Nil
		  End If

		  // Parse sbix table
		  If sbixOffset + 8 > mb.Size Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: sbix header out of bounds")
		    Return Nil
		  End If

		  // sbix header: version(UInt16) + flags(UInt16) + numStrikes(UInt32)
		  Dim numStrikes As UInt32 = mb.UInt32Value(sbixOffset + 4)
		  If numStrikes = 0 Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: No strikes in sbix table")
		    Return Nil
		  End If

		  // Strike offset array starts at sbixOffset + 8
		  Dim strikeOffsetsStart As UInt32 = sbixOffset + 8
		  If strikeOffsetsStart + (numStrikes * 4) > mb.Size Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: Strike offsets array out of bounds")
		    Return Nil
		  End If

		  // Find the strike with ppem closest to desiredSize
		  Dim bestStrikeIdx As Integer = -1
		  Dim bestPpem As Integer = 0
		  Dim bestDiff As Integer = 2147483647  // Max Int32

		  Dim i As Integer
		  For i = 0 To numStrikes - 1
		    Dim strikeRelOffset As UInt32 = mb.UInt32Value(strikeOffsetsStart + (i * 4))
		    Dim strikeAbsOffset As UInt32 = sbixOffset + strikeRelOffset

		    If strikeAbsOffset + 4 > mb.Size Then Continue

		    Dim ppem As UInt16 = mb.UInt16Value(strikeAbsOffset)
		    Dim diff As Integer = Abs(ppem - desiredSize)

		    If diff < bestDiff Then
		      bestDiff = diff
		      bestPpem = ppem
		      bestStrikeIdx = i
		    End If
		  Next

		  If bestStrikeIdx < 0 Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: No valid strike found")
		    Return Nil
		  End If

		  // Read glyph data from the best strike
		  Dim bestStrikeRelOffset As UInt32 = mb.UInt32Value(strikeOffsetsStart + (bestStrikeIdx * 4))
		  Dim bestStrikeAbsOffset As UInt32 = sbixOffset + bestStrikeRelOffset

		  // Strike structure: ppem(UInt16) + ppi(UInt16) + glyphDataOffsets[numGlyphs+1] as UInt32
		  Dim glyphDataOffsetsStart As UInt32 = bestStrikeAbsOffset + 4

		  // Need glyphID and glyphID+1 offsets
		  If glyphID >= numGlyphs Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: glyphID " + Str(glyphID) + " >= numGlyphs " + Str(numGlyphs))
		    Return Nil
		  End If

		  Dim offsetEntryPos As UInt32 = glyphDataOffsetsStart + (glyphID * 4)
		  Dim nextOffsetEntryPos As UInt32 = glyphDataOffsetsStart + ((glyphID + 1) * 4)

		  If nextOffsetEntryPos + 4 > mb.Size Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: Glyph offset entries out of bounds")
		    Return Nil
		  End If

		  Dim glyphDataRelOffset As UInt32 = mb.UInt32Value(offsetEntryPos)
		  Dim nextGlyphDataRelOffset As UInt32 = mb.UInt32Value(nextOffsetEntryPos)

		  // Both offsets are relative to the strike start
		  Dim glyphDataAbsOffset As UInt32 = bestStrikeAbsOffset + glyphDataRelOffset
		  Dim dataLength As Integer = nextGlyphDataRelOffset - glyphDataRelOffset

		  If dataLength <= 8 Then
		    // No image data (8-byte glyph header only, or empty)
		    System.DebugLog("ExtractEmojiPNG_SBIX: No image data for glyphID " + Str(glyphID) + " (ppem=" + Str(bestPpem) + ")")
		    Return Nil
		  End If

		  // Glyph data: originOffsetX(Int16) + originOffsetY(Int16) + graphicType(4 bytes) + image data
		  Const kGlyphHeaderSize As Integer = 8

		  If glyphDataAbsOffset + kGlyphHeaderSize > mb.Size Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: Glyph header out of bounds")
		    Return Nil
		  End If

		  Dim graphicType As String = mb.StringValue(glyphDataAbsOffset + 4, 4)
		  If graphicType <> "png " Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: Graphic type is not PNG: " + graphicType)
		    Return Nil
		  End If

		  Dim pngDataOffset As UInt32 = glyphDataAbsOffset + kGlyphHeaderSize
		  Dim pngDataLength As Integer = dataLength - kGlyphHeaderSize

		  If pngDataOffset + pngDataLength > mb.Size Then
		    System.DebugLog("ExtractEmojiPNG_SBIX: PNG data extends beyond file")
		    Return Nil
		  End If

		  // Extract the PNG data
		  Dim pngData As New MemoryBlock(pngDataLength)
		  pngData.StringValue(0, pngDataLength) = mb.StringValue(pngDataOffset, pngDataLength)

		  // Store in cache
		  If mSBIXCache = Nil Then
		    mSBIXCache = New Dictionary
		  End If
		  mSBIXCache.Value(cacheKey) = pngData

		  Return pngData

		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4C6F6F6B73207570206120676C7970682049442066726F6D206120636D6170207461626C6520666F722074686520676976656E20556E69636F646520636F6465706F696E742E0A
		Private Function GetGlyphIDFromCmap(mb As MemoryBlock, cmapOffset As UInt32, cmapLength As UInt32, codePoint As UInt32) As Integer
		  // Parses the cmap table to find a Format 12 segmented coverage subtable,
		  // then looks up the glyph ID for the given Unicode codepoint.
		  // Returns the glyph ID (>0) on success, or -1 if not found.
		  #Pragma Unused cmapLength

		  Dim fileSize As Integer = mb.Size

		  If cmapOffset + 4 > mb.Size Then Return -1

		  Dim numSubtables As UInt16 = mb.UInt16Value(cmapOffset + 2)

		  // Each encoding record is 8 bytes: platformID(UInt16) + encodingID(UInt16) + subtableOffset(UInt32)
		  Dim recordsStart As UInt32 = cmapOffset + 4

		  If recordsStart + (numSubtables * 8) > mb.Size Then Return -1

		  // Look for Format 12 subtable
		  // Prefer: platform 3 encoding 10 (Windows UCS-4) or platform 0 encoding 4 (Unicode full)
		  Dim format12Offset As UInt32 = 0

		  Dim i As Integer
		  For i = 0 To numSubtables - 1
		    Dim recPos As UInt32 = recordsStart + (i * 8)
		    Dim platformID As UInt16 = mb.UInt16Value(recPos)
		    Dim encodingID As UInt16 = mb.UInt16Value(recPos + 2)
		    Dim subtableRelOffset As UInt32 = mb.UInt32Value(recPos + 4)
		    Dim subtableAbsOffset As UInt32 = cmapOffset + subtableRelOffset

		    // Check if this is a Format 12 subtable
		    If subtableAbsOffset + 2 > mb.Size Then Continue

		    Dim format As UInt16 = mb.UInt16Value(subtableAbsOffset)

		    If format = 12 Then
		      // Accept platform 3 encoding 10, or platform 0 encoding 4
		      If (platformID = 3 And encodingID = 10) Or (platformID = 0 And encodingID = 4) Then
		        format12Offset = subtableAbsOffset
		        Exit  // Use first matching Format 12
		      End If
		      // Also accept any Format 12 as fallback
		      If format12Offset = 0 Then
		        format12Offset = subtableAbsOffset
		      End If
		    End If
		  Next

		  If format12Offset = 0 Then
		    System.DebugLog("GetGlyphIDFromCmap: No Format 12 subtable found")
		    Return -1
		  End If

		  // Parse Format 12 subtable
		  // Structure: format(UInt16) + reserved(UInt16) + length(UInt32) + language(UInt32) + numGroups(UInt32)
		  // Then numGroups sequential map groups of 12 bytes each
		  Const kFormat12HeaderSize As Integer = 16

		  If format12Offset + kFormat12HeaderSize > mb.Size Then
		    System.DebugLog("GetGlyphIDFromCmap: Format 12 header out of bounds")
		    Return -1
		  End If

		  Dim numGroups As UInt32 = mb.UInt32Value(format12Offset + 12)
		  Dim groupsStart As UInt32 = format12Offset + kFormat12HeaderSize

		  If groupsStart + (numGroups * 12) > mb.Size Then
		    System.DebugLog("GetGlyphIDFromCmap: Format 12 groups extend beyond file")
		    Return -1
		  End If

		  // Binary search through the groups for the codepoint
		  Dim lo As Integer = 0
		  Dim hi As Integer = numGroups - 1

		  While lo <= hi
		    Dim mid As Integer = lo + Bitwise.ShiftRight(hi - lo, 1)
		    Dim groupPos As UInt32 = groupsStart + (mid * 12)

		    Dim startCharCode As UInt32 = mb.UInt32Value(groupPos)
		    Dim endCharCode As UInt32 = mb.UInt32Value(groupPos + 4)
		    Dim startGlyphID As UInt32 = mb.UInt32Value(groupPos + 8)

		    If codePoint < startCharCode Then
		      hi = mid - 1
		    ElseIf codePoint > endCharCode Then
		      lo = mid + 1
		    Else
		      // Found: glyphID = startGlyphID + (codePoint - startCharCode)
		      Return startGlyphID + (codePoint - startCharCode)
		    End If
		  Wend

		  Return -1

		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 457874726163747320504E4720656D6F6A6920696D61676520646174612066726F6D206120434244542F43424C4320666F6E742066696C6520666F722074686520676976656E20636F6465706F696E7420616E642073697A652E0A
		Protected Function ExtractEmojiPNG_CBDT(fontFilePath As String, emojiCodePoint As UInt32, desiredSize As Integer) As MemoryBlock
		  // Extracts PNG bitmap data for an emoji from a CBDT/CBLC (Color Bitmap Data Table) font.
		  // Used primarily on Linux with NotoColorEmoji.ttf.
		  // Parses CBLC table to locate bitmap strike and glyph index, then reads PNG from CBDT.
		  // Returns Nil on any failure (file not found, table missing, glyph not found).

		  // Check cache first
		  Dim cacheKey As String = fontFilePath + ":" + Str(emojiCodePoint) + ":" + Str(desiredSize)
		  If mSBIXCache <> Nil And mSBIXCache.HasKey(cacheKey) Then
		    Return MemoryBlock(mSBIXCache.Value(cacheKey))
		  End If

		  // Use cached font data if same file, otherwise read and cache
		  Dim mb As MemoryBlock
		  Dim cmapOffset As UInt32
		  Dim cmapLength As UInt32
		  Dim cblcOffset As UInt32
		  Dim cblcLength As UInt32
		  Dim cbdtOffset As UInt32
		  Dim cbdtLength As UInt32
		  Dim maxpOffset As UInt32

		  If mSBIXFontMB <> Nil And mSBIXFontPath = fontFilePath And mSBIXTableInfo <> Nil Then
		    // Reuse cached font data and table info
		    mb = mSBIXFontMB
		    If Not mSBIXTableInfo.HasKey("cblcOffset") Then
		      // Cached font was parsed for a different table set, re-parse
		      mSBIXFontMB = Nil
		      mSBIXFontPath = ""
		      mSBIXTableInfo = Nil
		    Else
		      cmapOffset = mSBIXTableInfo.Value("cmapOffset")
		      cmapLength = mSBIXTableInfo.Value("cmapLength")
		      cblcOffset = mSBIXTableInfo.Value("cblcOffset")
		      cblcLength = mSBIXTableInfo.Value("cblcLength")
		      cbdtOffset = mSBIXTableInfo.Value("cbdtOffset")
		      cbdtLength = mSBIXTableInfo.Value("cbdtLength")
		      maxpOffset = mSBIXTableInfo.Value("maxpOffset")
		    End If
		  End If

		  If mSBIXFontMB = Nil Or mSBIXFontPath <> fontFilePath Or mSBIXTableInfo = Nil Then
		    // Read and parse font file, then cache
		    Dim f As FolderItem = New FolderItem(fontFilePath, FolderItem.PathModes.Native)
		    If f = Nil Or Not f.Exists Then Return Nil

		    Dim bs As BinaryStream
		    Try
		      bs = BinaryStream.Open(f, False)
		    Catch e As IOException
		      Return Nil
		    End Try

		    Dim fontFileSize As Integer = bs.Length
		    If fontFileSize < 12 Then
		      bs.Close
		      Return Nil
		    End If

		    mb = bs.Read(fontFileSize)
		    bs.Close
		    mb.LittleEndian = False

		    // NotoColorEmoji.ttf is standard TTF (not TTC), but handle TTC just in case
		    Dim fontOffset As UInt32 = 0
		    If mb.StringValue(0, 4) = "ttcf" Then
		      If mb.UInt32Value(8) < 1 Then Return Nil
		      fontOffset = mb.UInt32Value(12)
		      If fontOffset >= mb.Size Then Return Nil
		    End If

		    // Read table directory
		    If fontOffset + 12 > mb.Size Then Return Nil
		    Dim numTables As UInt16 = mb.UInt16Value(fontOffset + 4)
		    Dim tableRecordStart As UInt32 = fontOffset + 12
		    If tableRecordStart + (numTables * 16) > mb.Size Then Return Nil

		    cmapOffset = 0
		    cmapLength = 0
		    cblcOffset = 0
		    cblcLength = 0
		    cbdtOffset = 0
		    cbdtLength = 0
		    maxpOffset = 0

		    Dim i As Integer
		    For i = 0 To numTables - 1
		      Dim recOffset As UInt32 = tableRecordStart + (i * 16)
		      Dim tableTag As String = mb.StringValue(recOffset, 4)
		      If tableTag = "cmap" Then
		        cmapOffset = mb.UInt32Value(recOffset + 8)
		        cmapLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "CBLC" Then
		        cblcOffset = mb.UInt32Value(recOffset + 8)
		        cblcLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "CBDT" Then
		        cbdtOffset = mb.UInt32Value(recOffset + 8)
		        cbdtLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "maxp" Then
		        maxpOffset = mb.UInt32Value(recOffset + 8)
		      End If
		    Next

		    If cmapOffset = 0 Or cblcOffset = 0 Or cbdtOffset = 0 Then
		      System.DebugLog("ExtractEmojiPNG_CBDT: Required tables missing (cmap/CBLC/CBDT)")
		      Return Nil
		    End If

		    // Cache everything for next call
		    mSBIXFontMB = mb
		    mSBIXFontPath = fontFilePath
		    mSBIXTableInfo = New Dictionary
		    mSBIXTableInfo.Value("cmapOffset") = cmapOffset
		    mSBIXTableInfo.Value("cmapLength") = cmapLength
		    mSBIXTableInfo.Value("cblcOffset") = cblcOffset
		    mSBIXTableInfo.Value("cblcLength") = cblcLength
		    mSBIXTableInfo.Value("cbdtOffset") = cbdtOffset
		    mSBIXTableInfo.Value("cbdtLength") = cbdtLength
		    mSBIXTableInfo.Value("maxpOffset") = maxpOffset
		  End If

		  // Get numGlyphs from maxp table
		  Dim numGlyphs As UInt32 = 0
		  If maxpOffset > 0 And maxpOffset + 6 <= mb.Size Then
		    numGlyphs = mb.UInt16Value(maxpOffset + 4)
		  End If
		  If numGlyphs = 0 Then
		    System.DebugLog("ExtractEmojiPNG_CBDT: Cannot determine numGlyphs from maxp table")
		    Return Nil
		  End If

		  // Look up glyph ID from cmap
		  Dim glyphID As Integer = GetGlyphIDFromCmap(mb, cmapOffset, cmapLength, emojiCodePoint)
		  If glyphID <= 0 Then
		    System.DebugLog("ExtractEmojiPNG_CBDT: Glyph not found for codepoint " + Str(emojiCodePoint))
		    Return Nil
		  End If

		  // Parse CBLC table header
		  // Header: majorVersion(UInt16) + minorVersion(UInt16) + numSizes(UInt32)
		  Const kCBLCHeaderSize As Integer = 8
		  If cblcOffset + kCBLCHeaderSize > mb.Size Then
		    System.DebugLog("ExtractEmojiPNG_CBDT: CBLC header out of bounds")
		    Return Nil
		  End If

		  Dim numSizes As UInt32 = mb.UInt32Value(cblcOffset + 4)
		  If numSizes = 0 Then
		    System.DebugLog("ExtractEmojiPNG_CBDT: No BitmapSize records in CBLC")
		    Return Nil
		  End If

		  // BitmapSize record is 48 bytes each, starts after header
		  Const kBitmapSizeRecordSize As Integer = 48
		  Dim bitmapSizesStart As UInt32 = cblcOffset + kCBLCHeaderSize
		  If bitmapSizesStart + (numSizes * kBitmapSizeRecordSize) > mb.Size Then
		    System.DebugLog("ExtractEmojiPNG_CBDT: BitmapSize records out of bounds")
		    Return Nil
		  End If

		  // Find best BitmapSize that contains our glyphID
		  Dim bestSizeIdx As Integer = -1
		  Dim bestPpem As Integer = 0
		  Dim bestDiff As Integer = 2147483647
		  Dim bestIndexSubTableArrayOffset As UInt32 = 0
		  Dim bestNumberOfIndexSubTables As UInt32 = 0

		  Dim sIdx As Integer
		  For sIdx = 0 To numSizes - 1
		    Dim sizeRecPos As UInt32 = bitmapSizesStart + (sIdx * kBitmapSizeRecordSize)

		    // BitmapSize record layout:
		    // 0: indexSubTableArrayOffset(UInt32)
		    // 4: indexTablesSize(UInt32)
		    // 8: numberOfIndexSubTables(UInt32)
		    // 12: colorRef(UInt32)
		    // 16: SbitLineMetrics hori (12 bytes)
		    // 28: SbitLineMetrics vert (12 bytes)
		    // 40: startGlyphIndex(UInt16)
		    // 42: endGlyphIndex(UInt16)
		    // 44: ppemX(UInt8)
		    // 45: ppemY(UInt8)
		    // 46: bitDepth(UInt8)
		    // 47: flags(Int8)

		    Dim startGlyphIndex As UInt16 = mb.UInt16Value(sizeRecPos + 40)
		    Dim endGlyphIndex As UInt16 = mb.UInt16Value(sizeRecPos + 42)
		    Dim ppemX As UInt8 = mb.UInt8Value(sizeRecPos + 44)

		    // Check if our glyph is in range
		    If glyphID >= startGlyphIndex And glyphID <= endGlyphIndex Then
		      Dim diff As Integer = Abs(ppemX - desiredSize)
		      If diff < bestDiff Then
		        bestDiff = diff
		        bestPpem = ppemX
		        bestSizeIdx = sIdx
		        bestIndexSubTableArrayOffset = mb.UInt32Value(sizeRecPos + 0)
		        bestNumberOfIndexSubTables = mb.UInt32Value(sizeRecPos + 8)
		      End If
		    End If
		  Next

		  If bestSizeIdx < 0 Then
		    System.DebugLog("ExtractEmojiPNG_CBDT: No BitmapSize contains glyphID " + Str(glyphID))
		    Return Nil
		  End If

		  // Scan IndexSubTableArray to find the sub-table containing our glyphID
		  // IndexSubTableArray entries are 8 bytes each:
		  // firstGlyphIndex(UInt16) + lastGlyphIndex(UInt16) + additionalOffsetToIndexSubtable(UInt32)
		  // The offset is relative to indexSubTableArrayOffset
		  Dim indexArrayAbsOffset As UInt32 = cblcOffset + bestIndexSubTableArrayOffset

		  Const kIndexSubTableArrayEntrySize As Integer = 8
		  If indexArrayAbsOffset + (bestNumberOfIndexSubTables * kIndexSubTableArrayEntrySize) > mb.Size Then
		    System.DebugLog("ExtractEmojiPNG_CBDT: IndexSubTableArray out of bounds")
		    Return Nil
		  End If

		  Dim foundSubTable As Boolean = False
		  Dim subTableFirstGlyph As UInt16 = 0
		  Dim subTableIndexFormat As UInt16 = 0
		  Dim subTableImageFormat As UInt16 = 0
		  Dim subTableImageDataOffset As UInt32 = 0

		  Dim stIdx As Integer
		  For stIdx = 0 To bestNumberOfIndexSubTables - 1
		    Dim entryPos As UInt32 = indexArrayAbsOffset + (stIdx * kIndexSubTableArrayEntrySize)
		    Dim firstGlyph As UInt16 = mb.UInt16Value(entryPos)
		    Dim lastGlyph As UInt16 = mb.UInt16Value(entryPos + 2)

		    If glyphID >= firstGlyph And glyphID <= lastGlyph Then
		      // Found the sub-table containing our glyph
		      Dim additionalOffset As UInt32 = mb.UInt32Value(entryPos + 4)
		      Dim subTableAbsOffset As UInt32 = indexArrayAbsOffset + additionalOffset

		      // IndexSubTable header: indexFormat(UInt16) + imageFormat(UInt16) + imageDataOffset(UInt32)
		      Const kIndexSubTableHeaderSize As Integer = 8
		      If subTableAbsOffset + kIndexSubTableHeaderSize > mb.Size Then
		        System.DebugLog("ExtractEmojiPNG_CBDT: IndexSubTable header out of bounds")
		        Return Nil
		      End If

		      subTableFirstGlyph = firstGlyph
		      subTableIndexFormat = mb.UInt16Value(subTableAbsOffset)
		      subTableImageFormat = mb.UInt16Value(subTableAbsOffset + 2)
		      subTableImageDataOffset = mb.UInt32Value(subTableAbsOffset + 4)

		      // For indexFormat 1: array of UInt32 sbiOffsets follows header
		      // sbiOffset[glyphID - firstGlyph] and sbiOffset[glyphID - firstGlyph + 1]
		      If subTableIndexFormat = 1 Then
		        Dim glyphIndex As Integer = glyphID - subTableFirstGlyph
		        Dim offsetArrayStart As UInt32 = subTableAbsOffset + kIndexSubTableHeaderSize
		        Dim offsetPos As UInt32 = offsetArrayStart + (glyphIndex * 4)
		        Dim nextOffsetPos As UInt32 = offsetArrayStart + ((glyphIndex + 1) * 4)

		        If nextOffsetPos + 4 > mb.Size Then
		          System.DebugLog("ExtractEmojiPNG_CBDT: IndexFormat1 offset entries out of bounds")
		          Return Nil
		        End If

		        Dim sbiOffset As UInt32 = mb.UInt32Value(offsetPos)
		        Dim sbiNextOffset As UInt32 = mb.UInt32Value(nextOffsetPos)

		        // Calculate absolute position in CBDT
		        Dim glyphDataAbsPos As UInt32 = cbdtOffset + subTableImageDataOffset + sbiOffset
		        Dim glyphDataLen As Integer = sbiNextOffset - sbiOffset

		        If glyphDataLen <= 0 Then
		          System.DebugLog("ExtractEmojiPNG_CBDT: No data for glyphID " + Str(glyphID) + " (ppem=" + Str(bestPpem) + ")")
		          Return Nil
		        End If

		        If glyphDataAbsPos + glyphDataLen > mb.Size Then
		          System.DebugLog("ExtractEmojiPNG_CBDT: Glyph data extends beyond file")
		          Return Nil
		        End If

		        // Extract PNG based on imageFormat
		        Dim pngData As MemoryBlock = ExtractPNGFromCBDTRecord(mb, glyphDataAbsPos, glyphDataLen, subTableImageFormat)
		        If pngData <> Nil Then
		          // Cache it
		          If mSBIXCache = Nil Then
		            mSBIXCache = New Dictionary
		          End If
		          mSBIXCache.Value(cacheKey) = pngData
		          Return pngData
		        End If
		        Return Nil

		      Else
		        System.DebugLog("ExtractEmojiPNG_CBDT: Unsupported indexFormat " + Str(subTableIndexFormat))
		        Return Nil
		      End If
		    End If
		  Next

		  System.DebugLog("ExtractEmojiPNG_CBDT: No IndexSubTable found for glyphID " + Str(glyphID))
		  Return Nil

		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 457874726163747320504E4720646174612066726F6D2061204342445420676C7970682064617461207265636F7264206261736564206F6E20696D61676520666F726D61742E0A
		Private Function ExtractPNGFromCBDTRecord(mb As MemoryBlock, dataPos As UInt32, dataLen As Integer, imageFormat As UInt16) As MemoryBlock
		  // Extracts the PNG payload from a CBDT glyph data record.
		  // Handles imageFormat 17 (SmallGlyphMetrics + PNG) and 18 (BigGlyphMetrics + PNG).
		  // Returns the raw PNG MemoryBlock or Nil if format is unsupported.

		  Dim metricsSize As Integer = 0

		  If imageFormat = 17 Then
		    // SmallGlyphMetrics: height(1) + width(1) + bearingX(1) + bearingY(1) + advance(1) = 5 bytes
		    metricsSize = 5
		  ElseIf imageFormat = 18 Then
		    // BigGlyphMetrics: height(1) + width(1) + horiBearingX(1) + horiBearingY(1) + horiAdvance(1)
		    //   + vertBearingX(1) + vertBearingY(1) + vertAdvance(1) = 8 bytes
		    metricsSize = 8
		  Else
		    System.DebugLog("ExtractPNGFromCBDTRecord: Unsupported imageFormat " + Str(imageFormat))
		    Return Nil
		  End If

		  // After metrics: dataLen(UInt32) + PNG data
		  Const kDataLenFieldSize As Integer = 4
		  Dim minRecordSize As Integer = metricsSize + kDataLenFieldSize

		  If dataLen < minRecordSize Then
		    System.DebugLog("ExtractPNGFromCBDTRecord: Record too small for format " + Str(imageFormat))
		    Return Nil
		  End If

		  Dim pngLenPos As UInt32 = dataPos + metricsSize
		  If pngLenPos + kDataLenFieldSize > mb.Size Then
		    System.DebugLog("ExtractPNGFromCBDTRecord: PNG length field out of bounds")
		    Return Nil
		  End If

		  Dim pngLen As UInt32 = mb.UInt32Value(pngLenPos)
		  Dim pngStart As UInt32 = pngLenPos + kDataLenFieldSize

		  If pngLen = 0 Then
		    System.DebugLog("ExtractPNGFromCBDTRecord: PNG data length is zero")
		    Return Nil
		  End If

		  If pngStart + pngLen > mb.Size Then
		    System.DebugLog("ExtractPNGFromCBDTRecord: PNG data extends beyond file")
		    Return Nil
		  End If

		  // Extract the PNG data
		  Dim pngData As New MemoryBlock(pngLen)
		  pngData.StringValue(0, pngLen) = mb.StringValue(pngStart, pngLen)

		  Return pngData

		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 526173746572697A657320616E20656D6F6A692066726F6D206120434F4C522F4350414C20766563746F7220666F6E742066696C6520666F722074686520676976656E20636F6465706F696E7420616E642073697A652E0A
		Protected Function RasterizeEmoji_COLR(fontFilePath As String, emojiCodePoint As UInt32, desiredSize As Integer) As Picture
		  // Rasterizes an emoji from a COLR/CPAL (Color Layers) vector font.
		  // Used primarily on Windows with seguiemj.ttf.
		  // Strategy: Try platform Graphics API first (works on Windows), fall back to
		  // parsed COLR layer data for simplified rendering.
		  // Returns Nil on any failure.

		  // Check cache first
		  Dim cacheKey As String = "colr:" + fontFilePath + ":" + Str(emojiCodePoint) + ":" + Str(desiredSize)
		  If mCOLRCache <> Nil And mCOLRCache.HasKey(cacheKey) Then
		    Return Picture(mCOLRCache.Value(cacheKey))
		  End If

		  // Strategy 1: Try rendering via platform Graphics API
		  // On Windows, the Graphics API can often render color emoji natively
		  Dim apiResult As Picture = RasterizeEmoji_COLR_GraphicsAPI(emojiCodePoint, desiredSize)
		  If apiResult <> Nil Then
		    If mCOLRCache = Nil Then
		      mCOLRCache = New Dictionary
		    End If
		    mCOLRCache.Value(cacheKey) = apiResult
		    Return apiResult
		  End If

		  // Strategy 2: Parse COLR/CPAL tables and render simplified layers
		  Dim colrResult As Picture = RasterizeEmoji_COLR_Parsed(fontFilePath, emojiCodePoint, desiredSize)
		  If colrResult <> Nil Then
		    If mCOLRCache = Nil Then
		      mCOLRCache = New Dictionary
		    End If
		    mCOLRCache.Value(cacheKey) = colrResult
		    Return colrResult
		  End If

		  Return Nil

		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 547269657320746F2072656E64657220616E20656D6F6A69207573696E672074686520706C6174666F726D20477261706869637320415049206469726563746C792E0A
		Private Function RasterizeEmoji_COLR_GraphicsAPI(emojiCodePoint As UInt32, desiredSize As Integer) As Picture
		  // Attempts to render an emoji using the platform Graphics API.
		  // On Windows, DrawText with the emoji font may produce colored output.
		  // Returns Nil if the emoji cannot be rendered (zero width or blank).

		  #If TargetDesktop Then
		    Try
		      Dim emojiChar As String = Text.FromUnicodeCodepoint(emojiCodePoint)

		      // Create a test picture to measure the emoji
		      Dim scaleFactor As Integer = 2
		      Dim picSize As Integer = desiredSize * scaleFactor
		      If picSize < 16 Then picSize = 16

		      Dim pic As New Picture(picSize, picSize)
		      Dim g As Graphics = pic.Graphics

		      // Try with the emoji font
		      #If TargetWindows Then
		        g.FontName = "Segoe UI Emoji"
		      #Else
		        // Unlikely to reach here for COLR on non-Windows, but try anyway
		        g.FontName = "Apple Color Emoji"
		      #EndIf

		      g.FontSize = desiredSize

		      // Check if the font can render this character
		      Dim tw As Double = g.TextWidth(emojiChar)
		      If tw <= 0 Then Return Nil

		      // Draw the emoji centered
		      Dim drawX As Double = (picSize - tw) / 2
		      Dim drawY As Double = g.FontAscent + ((picSize - g.TextHeight) / 2)

		      // Fill background with white
		      g.DrawingColor = Color.White
		      g.FillRectangle(0, 0, picSize, picSize)

		      // Draw the emoji
		      g.DrawingColor = Color.Black
		      g.DrawText(emojiChar, drawX, drawY)

		      // Check if the result is not blank (all white)
		      // Sample a few pixels near center to see if anything was drawn
		      Dim rgbPic As RGBSurface = pic.RGBSurface
		      If rgbPic = Nil Then Return Nil

		      Dim centerX As Integer = picSize \ 2
		      Dim centerY As Integer = picSize \ 2
		      Dim hasContent As Boolean = False

		      // Sample a grid of points around center
		      Dim sx As Integer
		      Dim sy As Integer
		      For sx = centerX - (picSize \ 4) To centerX + (picSize \ 4) Step 2
		        For sy = centerY - (picSize \ 4) To centerY + (picSize \ 4) Step 2
		          If sx >= 0 And sx < picSize And sy >= 0 And sy < picSize Then
		            Dim c As Color = rgbPic.Pixel(sx, sy)
		            If c.Red <> 255 Or c.Green <> 255 Or c.Blue <> 255 Then
		              hasContent = True
		              Exit
		            End If
		          End If
		        Next
		        If hasContent Then Exit
		      Next

		      If Not hasContent Then Return Nil

		      // Crop to the desired size
		      If picSize <> desiredSize Then
		        Dim result As New Picture(desiredSize, desiredSize)
		        Dim rg As Graphics = result.Graphics
		        rg.DrawPicture(pic, 0, 0, desiredSize, desiredSize, 0, 0, picSize, picSize)
		        Return result
		      End If

		      Return pic

		    Catch e As RuntimeException
		      System.DebugLog("RasterizeEmoji_COLR_GraphicsAPI: Exception: " + e.Message)
		      Return Nil
		    End Try
		  #Else
		    #Pragma Unused emojiCodePoint
		    #Pragma Unused desiredSize
		    Return Nil
		  #EndIf

		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320434F4C522F4350414C207461626C657320616E642072656E6465727320656D6F6A69206C617965727320746F20612050696374757265206F626A6563742E0A
		Private Function RasterizeEmoji_COLR_Parsed(fontFilePath As String, emojiCodePoint As UInt32, desiredSize As Integer) As Picture
		  // Parses COLR/CPAL tables from font file to render a simplified emoji.
		  // Reads layer glyphs and their palette colors, then draws colored bounding
		  // boxes for each layer as an approximation.
		  // Returns Nil on any failure.

		  // Use cached font data if same file, otherwise read and cache
		  Dim mb As MemoryBlock
		  Dim cmapOffset As UInt32
		  Dim cmapLength As UInt32
		  Dim colrOffset As UInt32
		  Dim colrLength As UInt32
		  Dim cpalOffset As UInt32
		  Dim cpalLength As UInt32
		  Dim glyfOffset As UInt32
		  Dim glyfLength As UInt32
		  Dim locaOffset As UInt32
		  Dim locaLength As UInt32
		  Dim headOffset As UInt32
		  Dim maxpOffset As UInt32

		  If mSBIXFontMB <> Nil And mSBIXFontPath = fontFilePath And mSBIXTableInfo <> Nil Then
		    If Not mSBIXTableInfo.HasKey("colrOffset") Then
		      // Cached font was parsed for a different table set, re-parse
		      mSBIXFontMB = Nil
		      mSBIXFontPath = ""
		      mSBIXTableInfo = Nil
		    Else
		      mb = mSBIXFontMB
		      cmapOffset = mSBIXTableInfo.Value("cmapOffset")
		      cmapLength = mSBIXTableInfo.Value("cmapLength")
		      colrOffset = mSBIXTableInfo.Value("colrOffset")
		      colrLength = mSBIXTableInfo.Value("colrLength")
		      cpalOffset = mSBIXTableInfo.Value("cpalOffset")
		      cpalLength = mSBIXTableInfo.Value("cpalLength")
		      glyfOffset = mSBIXTableInfo.Value("glyfOffset")
		      glyfLength = mSBIXTableInfo.Value("glyfLength")
		      locaOffset = mSBIXTableInfo.Value("locaOffset")
		      locaLength = mSBIXTableInfo.Value("locaLength")
		      headOffset = mSBIXTableInfo.Value("headOffset")
		      maxpOffset = mSBIXTableInfo.Value("maxpOffset")
		    End If
		  End If

		  If mSBIXFontMB = Nil Or mSBIXFontPath <> fontFilePath Or mSBIXTableInfo = Nil Then
		    // Read and parse font file, then cache
		    Dim f As FolderItem = New FolderItem(fontFilePath, FolderItem.PathModes.Native)
		    If f = Nil Or Not f.Exists Then Return Nil

		    Dim bs As BinaryStream
		    Try
		      bs = BinaryStream.Open(f, False)
		    Catch e As IOException
		      Return Nil
		    End Try

		    Dim fontFileSize As Integer = bs.Length
		    If fontFileSize < 12 Then
		      bs.Close
		      Return Nil
		    End If

		    mb = bs.Read(fontFileSize)
		    bs.Close
		    mb.LittleEndian = False

		    // Handle TTC collections
		    Dim fontOffset As UInt32 = 0
		    If mb.StringValue(0, 4) = "ttcf" Then
		      If mb.UInt32Value(8) < 1 Then Return Nil
		      fontOffset = mb.UInt32Value(12)
		      If fontOffset >= mb.Size Then Return Nil
		    End If

		    // Read table directory
		    If fontOffset + 12 > mb.Size Then Return Nil
		    Dim numTables As UInt16 = mb.UInt16Value(fontOffset + 4)
		    Dim tableRecordStart As UInt32 = fontOffset + 12
		    If tableRecordStart + (numTables * 16) > mb.Size Then Return Nil

		    cmapOffset = 0
		    cmapLength = 0
		    colrOffset = 0
		    colrLength = 0
		    cpalOffset = 0
		    cpalLength = 0
		    glyfOffset = 0
		    glyfLength = 0
		    locaOffset = 0
		    locaLength = 0
		    headOffset = 0
		    maxpOffset = 0

		    Dim i As Integer
		    For i = 0 To numTables - 1
		      Dim recOffset As UInt32 = tableRecordStart + (i * 16)
		      Dim tableTag As String = mb.StringValue(recOffset, 4)
		      If tableTag = "cmap" Then
		        cmapOffset = mb.UInt32Value(recOffset + 8)
		        cmapLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "COLR" Then
		        colrOffset = mb.UInt32Value(recOffset + 8)
		        colrLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "CPAL" Then
		        cpalOffset = mb.UInt32Value(recOffset + 8)
		        cpalLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "glyf" Then
		        glyfOffset = mb.UInt32Value(recOffset + 8)
		        glyfLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "loca" Then
		        locaOffset = mb.UInt32Value(recOffset + 8)
		        locaLength = mb.UInt32Value(recOffset + 12)
		      ElseIf tableTag = "head" Then
		        headOffset = mb.UInt32Value(recOffset + 8)
		      ElseIf tableTag = "maxp" Then
		        maxpOffset = mb.UInt32Value(recOffset + 8)
		      End If
		    Next

		    If cmapOffset = 0 Or colrOffset = 0 Or cpalOffset = 0 Then
		      System.DebugLog("RasterizeEmoji_COLR_Parsed: Required tables missing (cmap/COLR/CPAL)")
		      Return Nil
		    End If

		    // Cache everything for next call
		    mSBIXFontMB = mb
		    mSBIXFontPath = fontFilePath
		    mSBIXTableInfo = New Dictionary
		    mSBIXTableInfo.Value("cmapOffset") = cmapOffset
		    mSBIXTableInfo.Value("cmapLength") = cmapLength
		    mSBIXTableInfo.Value("colrOffset") = colrOffset
		    mSBIXTableInfo.Value("colrLength") = colrLength
		    mSBIXTableInfo.Value("cpalOffset") = cpalOffset
		    mSBIXTableInfo.Value("cpalLength") = cpalLength
		    mSBIXTableInfo.Value("glyfOffset") = glyfOffset
		    mSBIXTableInfo.Value("glyfLength") = glyfLength
		    mSBIXTableInfo.Value("locaOffset") = locaOffset
		    mSBIXTableInfo.Value("locaLength") = locaLength
		    mSBIXTableInfo.Value("headOffset") = headOffset
		    mSBIXTableInfo.Value("maxpOffset") = maxpOffset
		  End If

		  // Look up glyph ID from cmap
		  Dim glyphID As Integer = GetGlyphIDFromCmap(mb, cmapOffset, cmapLength, emojiCodePoint)
		  If glyphID <= 0 Then
		    System.DebugLog("RasterizeEmoji_COLR_Parsed: Glyph not found for codepoint " + Str(emojiCodePoint))
		    Return Nil
		  End If

		  // Parse COLR table header
		  // version(UInt16) + numBaseGlyphRecords(UInt16) + baseGlyphRecordsOffset(UInt32)
		  // + layerRecordsOffset(UInt32) + numLayerRecords(UInt16)
		  Const kCOLRHeaderSize As Integer = 14
		  If colrOffset + kCOLRHeaderSize > mb.Size Then
		    System.DebugLog("RasterizeEmoji_COLR_Parsed: COLR header out of bounds")
		    Return Nil
		  End If

		  Dim numBaseGlyphRecords As UInt16 = mb.UInt16Value(colrOffset + 2)
		  Dim baseGlyphRecordsOff As UInt32 = mb.UInt32Value(colrOffset + 4)
		  Dim layerRecordsOff As UInt32 = mb.UInt32Value(colrOffset + 8)
		  Dim numLayerRecords As UInt16 = mb.UInt16Value(colrOffset + 12)

		  Dim baseGlyphAbsOff As UInt32 = colrOffset + baseGlyphRecordsOff
		  Dim layerAbsOff As UInt32 = colrOffset + layerRecordsOff

		  // Find our glyphID in BaseGlyphRecords using binary search
		  // BaseGlyphRecord: glyphID(UInt16) + firstLayerIndex(UInt16) + numLayers(UInt16) = 6 bytes
		  Const kBaseGlyphRecordSize As Integer = 6
		  If baseGlyphAbsOff + (numBaseGlyphRecords * kBaseGlyphRecordSize) > mb.Size Then
		    System.DebugLog("RasterizeEmoji_COLR_Parsed: BaseGlyphRecords out of bounds")
		    Return Nil
		  End If

		  Dim firstLayerIndex As Integer = -1
		  Dim numLayers As Integer = 0

		  // Binary search (BaseGlyphRecords are sorted by glyphID)
		  Dim lo As Integer = 0
		  Dim hi As Integer = numBaseGlyphRecords - 1
		  While lo <= hi
		    Dim mid As Integer = lo + Bitwise.ShiftRight(hi - lo, 1)
		    Dim recPos As UInt32 = baseGlyphAbsOff + (mid * kBaseGlyphRecordSize)
		    Dim recGlyphID As UInt16 = mb.UInt16Value(recPos)

		    If glyphID < recGlyphID Then
		      hi = mid - 1
		    ElseIf glyphID > recGlyphID Then
		      lo = mid + 1
		    Else
		      firstLayerIndex = mb.UInt16Value(recPos + 2)
		      numLayers = mb.UInt16Value(recPos + 4)
		      Exit
		    End If
		  Wend

		  If firstLayerIndex < 0 Or numLayers = 0 Then
		    System.DebugLog("RasterizeEmoji_COLR_Parsed: glyphID " + Str(glyphID) + " not found in BaseGlyphRecords")
		    Return Nil
		  End If

		  // Validate layer records range
		  Const kLayerRecordSize As Integer = 4
		  If layerAbsOff + ((firstLayerIndex + numLayers) * kLayerRecordSize) > mb.Size Then
		    System.DebugLog("RasterizeEmoji_COLR_Parsed: LayerRecords out of bounds")
		    Return Nil
		  End If

		  // Parse CPAL table to get color palette
		  // version(UInt16) + numPaletteEntries(UInt16) + numPalettes(UInt16)
		  // + numColorRecords(UInt16) + colorRecordsArrayOffset(UInt32)
		  Const kCPALHeaderSize As Integer = 12
		  If cpalOffset + kCPALHeaderSize > mb.Size Then
		    System.DebugLog("RasterizeEmoji_COLR_Parsed: CPAL header out of bounds")
		    Return Nil
		  End If

		  Dim numColorRecords As UInt16 = mb.UInt16Value(cpalOffset + 6)
		  Dim colorRecordsArrayOff As UInt32 = mb.UInt32Value(cpalOffset + 8)
		  Dim colorRecordsAbsOff As UInt32 = cpalOffset + colorRecordsArrayOff

		  // Each ColorRecord is 4 bytes: blue(UInt8) + green(UInt8) + red(UInt8) + alpha(UInt8)
		  Const kColorRecordSize As Integer = 4
		  If colorRecordsAbsOff + (numColorRecords * kColorRecordSize) > mb.Size Then
		    System.DebugLog("RasterizeEmoji_COLR_Parsed: ColorRecords out of bounds")
		    Return Nil
		  End If

		  // Get indexToLocFormat from head table to know how to read loca
		  Dim indexToLocFormat As Integer = 0
		  If headOffset > 0 And headOffset + 54 <= mb.Size Then
		    indexToLocFormat = mb.Int16Value(headOffset + 50)
		  End If

		  // Get numGlyphs from maxp
		  Dim numGlyphs As UInt32 = 0
		  If maxpOffset > 0 And maxpOffset + 6 <= mb.Size Then
		    numGlyphs = mb.UInt16Value(maxpOffset + 4)
		  End If

		  // Get unitsPerEm from head table for scaling
		  Dim unitsPerEm As Double = 2048.0
		  If headOffset > 0 And headOffset + 20 <= mb.Size Then
		    unitsPerEm = mb.UInt16Value(headOffset + 18)
		    If unitsPerEm = 0 Then unitsPerEm = 2048.0
		  End If

		  Dim scaleFactor As Double = desiredSize / unitsPerEm

		  // Create the result picture
		  Dim pic As New Picture(desiredSize, desiredSize)
		  Dim g As Graphics = pic.Graphics

		  // Fill background with white
		  g.DrawingColor = Color.White
		  g.FillRectangle(0, 0, desiredSize, desiredSize)

		  // Render each layer
		  Dim layerIdx As Integer
		  For layerIdx = 0 To numLayers - 1
		    Dim layerRecPos As UInt32 = layerAbsOff + ((firstLayerIndex + layerIdx) * kLayerRecordSize)
		    Dim layerGlyphID As UInt16 = mb.UInt16Value(layerRecPos)
		    Dim paletteIndex As UInt16 = mb.UInt16Value(layerRecPos + 2)

		    // Get color from CPAL (special value 0xFFFF means use foreground color)
		    Dim layerColor As Color
		    If paletteIndex = &hFFFF Then
		      layerColor = Color.Black
		    ElseIf paletteIndex < numColorRecords Then
		      Dim colorRecPos As UInt32 = colorRecordsAbsOff + (paletteIndex * kColorRecordSize)
		      Dim cBlue As UInt8 = mb.UInt8Value(colorRecPos)
		      Dim cGreen As UInt8 = mb.UInt8Value(colorRecPos + 1)
		      Dim cRed As UInt8 = mb.UInt8Value(colorRecPos + 2)
		      // alpha at colorRecPos + 3, we ignore transparency for simplified rendering
		      layerColor = Color.RGB(cRed, cGreen, cBlue)
		    Else
		      layerColor = Color.Black
		    End If

		    // Get glyph bounding box from glyf table via loca
		    If glyfOffset = 0 Or locaOffset = 0 Or numGlyphs = 0 Then Continue
		    If layerGlyphID >= numGlyphs Then Continue

		    Dim glyphOff As UInt32 = 0
		    Dim nextGlyphOff As UInt32 = 0

		    If indexToLocFormat = 0 Then
		      // Short format: offsets are UInt16, multiply by 2
		      Dim locaPos As UInt32 = locaOffset + (layerGlyphID * 2)
		      If locaPos + 4 > mb.Size Then Continue
		      glyphOff = mb.UInt16Value(locaPos) * 2
		      nextGlyphOff = mb.UInt16Value(locaPos + 2) * 2
		    Else
		      // Long format: offsets are UInt32
		      Dim locaPos As UInt32 = locaOffset + (layerGlyphID * 4)
		      If locaPos + 8 > mb.Size Then Continue
		      glyphOff = mb.UInt32Value(locaPos + 0)
		      nextGlyphOff = mb.UInt32Value(locaPos + 4)
		    End If

		    // Skip empty glyphs (e.g., space)
		    If glyphOff = nextGlyphOff Then Continue

		    Dim glyphAbsOff As UInt32 = glyfOffset + glyphOff
		    // Glyph header: numberOfContours(Int16) + xMin(Int16) + yMin(Int16) + xMax(Int16) + yMax(Int16)
		    Const kGlyphHeaderSize As Integer = 10
		    If glyphAbsOff + kGlyphHeaderSize > mb.Size Then Continue

		    Dim xMin As Integer = mb.Int16Value(glyphAbsOff + 2)
		    Dim yMin As Integer = mb.Int16Value(glyphAbsOff + 4)
		    Dim xMax As Integer = mb.Int16Value(glyphAbsOff + 6)
		    Dim yMax As Integer = mb.Int16Value(glyphAbsOff + 8)

		    // Scale to pixel coordinates
		    Dim pxLeft As Double = xMin * scaleFactor
		    Dim pxRight As Double = xMax * scaleFactor
		    Dim pxTop As Double = desiredSize - (yMax * scaleFactor)
		    Dim pxBottom As Double = desiredSize - (yMin * scaleFactor)

		    Dim rectW As Double = pxRight - pxLeft
		    Dim rectH As Double = pxBottom - pxTop

		    If rectW > 0 And rectH > 0 Then
		      g.DrawingColor = layerColor
		      g.FillRectangle(pxLeft, pxTop, rectW, rectH)
		    End If
		  Next

		  Return pic

		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52656E64657220656D6F6A69206173206120636F6C6F7220696D616765207573696E6720706C6174666F726D277320656D6F6A6920666F6E742E0A
		Protected Function RenderEmojiToImage(emojiChar As String, sizeInPoints As Integer, webSession As Variant = Nil, bgColor As Color = &cFFFFFF) As Picture
		  #Pragma Unused webSession
		  // Render an emoji character to a color image using platform's emoji font
		  // Returns a Picture that can be saved and embedded in PDF
		  // Supported on Desktop, iOS, and Web platforms
		  //
		  // Parameters:
		  // - emojiChar: Single emoji character to render
		  // - sizeInPoints: Size in points (pixels) for the rendered image
		  // - webSession: (Web only) WebSession object required for JavaScript execution (pass Session from WebPage)
		  
		  #If TargetDesktop Then
		    // Desktop: Use Picture/Graphics API
		    // Create a Picture large enough for the emoji with extra padding
		    // Use 4x size to ensure no cropping
		    Dim scaleFactor As Integer = 4
		    Dim basePicSize As Integer = sizeInPoints * scaleFactor
		    // 8% padding on all sides: the emoji glyph is about one em tall and barely
		    // exceeds it, so this avoids cropping while the glyph still fills ~85% of the
		    // image (30% padding made emoji look half the size of the surrounding text)
		    Dim padding As Integer = basePicSize * 0.08
		    Dim picSize As Integer = basePicSize + (padding * 2)
		    
		    Dim pic As New Picture(picSize, picSize)
		    Dim g As Graphics = pic.Graphics
		    
		    // Clear background (not transparent - JPEG has no alpha channel)
		    // Uses bgColor to match the parent block's background for seamless blending
		    g.DrawingColor = bgColor
		    g.FillRectangle(0, 0, picSize, picSize)
		    
		    // Set emoji font
		    #If TargetMacOS Then
		      g.FontName = "Apple Color Emoji"
		    #ElseIf TargetWindows Then
		      g.FontName = "Segoe UI Emoji"
		    #ElseIf TargetLinux Then
		      g.FontName = "Noto Color Emoji"
		    #EndIf
		    
		    g.FontSize = sizeInPoints * scaleFactor
		    g.DrawingColor = &c000000  // Black for fallback
		    
		    // Center the emoji in the padded picture
		    Dim textWidth As Double = g.TextWidth(emojiChar)
		    Dim x As Integer = (picSize - textWidth) / 2
		    Dim y As Integer = padding + g.FontAscent + (basePicSize - g.TextHeight) / 2
		    
		    g.DrawText(emojiChar, x, y)
		    
		    Return pic
		    
		  #ElseIf TargetiOS Then
		    // iOS: Use native iOS declares to render emoji (Picture.Graphics not available on iOS)
		    // Create a UIImage with emoji text rendered using UIKit
		    
		    Dim scaleFactor As Integer = 4
		    Dim basePicSize As Integer = sizeInPoints * scaleFactor
		    Dim padding As Integer = basePicSize * 0.3  // 30% padding on all sides
		    Dim picSize As Integer = basePicSize + (padding * 2)
		    
		    // iOS Declares for emoji rendering
		    Declare Function NSClassFromString Lib "Foundation" (classname As CFStringRef) As Ptr
		    Declare Function alloc Lib "Foundation" Selector "alloc" (classRef As Ptr) As Ptr
		    Declare Function initWithFrame Lib "UIKit" Selector "initWithFrame:" (obj As Ptr, x As CGFloat, y As CGFloat, w As CGFloat, h As CGFloat) As Ptr
		    Declare Sub setText Lib "UIKit" Selector "setText:" (obj As Ptr, text As CFStringRef)
		    Declare Sub setFont Lib "UIKit" Selector "setFont:" (obj As Ptr, font As Ptr)
		    Declare Function systemFontOfSize Lib "UIKit" Selector "systemFontOfSize:" (classRef As Ptr, size As CGFloat) As Ptr
		    Declare Sub setTextAlignment Lib "UIKit" Selector "setTextAlignment:" (obj As Ptr, alignment As Integer)
		    Declare Sub setBackgroundColor Lib "UIKit" Selector "setBackgroundColor:" (obj As Ptr, color As Ptr)
		    Declare Function colorWithRGBA Lib "UIKit" Selector "colorWithRed:green:blue:alpha:" (classRef As Ptr, red As CGFloat, green As CGFloat, blue As CGFloat, alpha As CGFloat) As Ptr
		    Declare Sub UIGraphicsBeginImageContextWithOptions Lib "UIKit" (size_width As CGFloat, size_height As CGFloat, opaque As Boolean, scale As CGFloat)
		    Declare Function layer Lib "UIKit" Selector "layer" (obj As Ptr) As Ptr
		    Declare Sub renderInContext Lib "QuartzCore" Selector "renderInContext:" (obj As Ptr, context As Ptr)
		    Declare Function UIGraphicsGetCurrentContext Lib "UIKit" () As Ptr
		    Declare Function UIGraphicsGetImageFromCurrentImageContext Lib "UIKit" () As Ptr
		    Declare Sub UIGraphicsEndImageContext Lib "UIKit" ()
		    
		    // Create UILabel
		    Dim UILabelClass As Ptr = NSClassFromString("UILabel")
		    Dim label As Ptr = alloc(UILabelClass)
		    label = initWithFrame(label, 0, 0, picSize, picSize)
		    
		    // Set emoji text
		    Call setText(label, emojiChar)
		    
		    // Set font (Apple Color Emoji font is used automatically for emoji)
		    Dim UIFontClass As Ptr = NSClassFromString("UIFont")
		    Dim fontSize As CGFloat = sizeInPoints * scaleFactor
		    Dim font As Ptr = systemFontOfSize(UIFontClass, fontSize)
		    Call setFont(label, font)
		    
		    // Center text alignment (1 = NSTextAlignmentCenter)
		    Call setTextAlignment(label, 1)
		    
		    // Background = bgColor (parent block background), so the JPEG emoji blends in
		    Dim UIColorClass As Ptr = NSClassFromString("UIColor")
		    Dim labelBackground As Ptr = colorWithRGBA(UIColorClass, bgColor.Red / 255.0, bgColor.Green / 255.0, bgColor.Blue / 255.0, 1.0)
		    Call setBackgroundColor(label, labelBackground)
		    
		    // Render to image
		    Call UIGraphicsBeginImageContextWithOptions(picSize, picSize, False, 0.0)
		    Dim context As Ptr = UIGraphicsGetCurrentContext()
		    Dim labelLayer As Ptr = layer(label)
		    Call renderInContext(labelLayer, context)
		    Dim uiImage As Ptr = UIGraphicsGetImageFromCurrentImageContext()
		    Call UIGraphicsEndImageContext()
		    
		    // Convert UIImage to image data, then to Xojo Picture
		    // This properly retains the image data (Picture.FromHandle doesn't work reliably)
		    If uiImage <> Nil Then
		      // Declare for converting UIImage to PNG data
		      Declare Function UIImagePNGRepresentation Lib "UIKit" (image As Ptr) As Ptr
		      Declare Function NSDataGetLength Lib "Foundation" Selector "length" (obj As Ptr) As Integer
		      Declare Sub NSDataGetBytes Lib "Foundation" Selector "getBytes:length:" (obj As Ptr, buffer As Ptr, length As Integer)
		      
		      // Get PNG data from UIImage
		      Dim pngData As Ptr = UIImagePNGRepresentation(uiImage)
		      If pngData = Nil Then
		        Return Nil
		      End If
		      
		      // Get data length
		      Dim dataLength As Integer = NSDataGetLength(pngData)
		      If dataLength = 0 Then
		        Return Nil
		      End If
		      
		      // Copy data to MemoryBlock
		      Dim mb As New MemoryBlock(dataLength)
		      Call NSDataGetBytes(pngData, mb, dataLength)
		      
		      // Convert to Picture
		      Dim pic As Picture = Picture.FromData(mb)
		      Return pic
		    Else
		      Return Nil
		    End If
		    
		  #ElseIf TargetAndroid Then
		    // Android: draw with the system font. Android's text renderer falls back to the
		    // Noto Color Emoji font for emoji, so no font name is needed (Graphics.FontName
		    // and FontAscent are not supported on Android: use Graphics.Font / Font.Ascent).
		    Dim scaleFactor As Integer = 4
		    Dim basePicSize As Integer = sizeInPoints * scaleFactor
		    Dim padding As Integer = basePicSize * 0.08  // Same 8% padding as Desktop
		    Dim picSize As Integer = basePicSize + (padding * 2)
		    
		    Dim pic As New Picture(picSize, picSize)
		    Dim g As Graphics = pic.Graphics
		    
		    // Background = parent block color (JPEG has no alpha channel)
		    g.DrawingColor = bgColor
		    g.FillRectangle(0, 0, picSize, picSize)
		    
		    g.Font = Font.SystemFont(basePicSize)
		    // Android's emoji font has a different advance width than Apple Color Emoji at the
		    // same size: rescale from the measured advance. The visible glyph is ~87% of the
		    // advance, so an advance of 1.12 x base gives a glyph of ~0.97 x base (~85% of the
		    // padded image), the same proportion as the Desktop rendering (measured 2026-10-02)
		    Dim measuredWidth As Double = g.TextWidth(emojiChar)
		    If measuredWidth > 0 Then
		      g.Font = Font.SystemFont(basePicSize * (basePicSize * 1.12) / measuredWidth)
		    End If
		    g.DrawingColor = &c000000  // Black for any non-color fallback glyph
		    
		    // Center the glyph from its advance width (TextWidth is in drawing units; Font.Ascent
		    // is not, and pushed the glyph ~15% too low, clipping its bottom). The baseline sits
		    // 0.341 x advance below the image center: measured on the emulator so the visible
		    // glyph has equal top/bottom margins (Noto Color Emoji metrics alone gave 0.276,
		    // which left it 14 px too high in a 231 px image).
		    Dim advanceWidth As Double = g.TextWidth(emojiChar)
		    Dim x As Double = (picSize - advanceWidth) / 2
		    Dim y As Double = picSize / 2 + advanceWidth * 0.341
		    g.DrawText(emojiChar, x, y)
		    
		    Return pic
		    
		  #ElseIf TargetWeb Then
		    // Web: Extract PNG from emoji font file (SBIX format on macOS)
		    // Graphics API cannot access emoji fonts on Web servers, so we parse the font directly
		    #Pragma Unused webSession

		    // Find emoji font file path
		    Dim fontPath As String = ""
		    #If TargetMacOS Then
		      Dim paths() As String
		      paths.Add("/System/Library/Fonts/Apple Color Emoji.ttc")
		      paths.Add("/Library/Fonts/Apple Color Emoji.ttc")
		      paths.Add("/System/Library/Fonts/AppleColorEmoji.ttc")
		      For Each path As String In paths
		        Dim fontFile As New FolderItem(path, FolderItem.PathModes.Native)
		        If fontFile <> Nil And fontFile.Exists Then
		          fontPath = path
		          Exit For
		        End If
		      Next
		    #ElseIf TargetLinux Then
		      // Linux: Noto Color Emoji (CBDT/CBLC format)
		      Dim linuxPaths() As String
		      linuxPaths.Add("/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf")
		      linuxPaths.Add("/usr/share/fonts/noto-emoji/NotoColorEmoji.ttf")
		      linuxPaths.Add("/usr/share/fonts/google-noto-emoji/NotoColorEmoji.ttf")
		      linuxPaths.Add("/usr/share/fonts/truetype/noto-color-emoji/NotoColorEmoji.ttf")
		      For Each lpath As String In linuxPaths
		        Dim lf As New FolderItem(lpath, FolderItem.PathModes.Native)
		        If lf <> Nil And lf.Exists Then
		          fontPath = lpath
		          Exit For
		        End If
		      Next
		    #ElseIf TargetWindows Then
		      // Windows: Segoe UI Emoji (COLR/CPAL format)
		      fontPath = "C:\Windows\Fonts\seguiemj.ttf"
		      Dim wf As New FolderItem(fontPath, FolderItem.PathModes.Native)
		      If wf = Nil Or Not wf.Exists Then fontPath = ""
		    #EndIf

		    If fontPath = "" Then Return Nil

		    // Get emoji Unicode codepoint
		    Dim emojiStr As String = emojiChar.DefineEncoding(Encodings.UTF8)
		    Dim cp As UInt32 = Asc(emojiStr)

		    // Extract emoji image using platform-appropriate method
		    Dim pngData As MemoryBlock
		    #If TargetMacOS Then
		      // macOS: SBIX table (PNG extraction)
		      pngData = ExtractEmojiPNG_SBIX(fontPath, cp, sizeInPoints)
		    #ElseIf TargetLinux Then
		      // Linux: CBDT/CBLC table (PNG extraction)
		      pngData = ExtractEmojiPNG_CBDT(fontPath, cp, sizeInPoints)
		    #ElseIf TargetWindows Then
		      // Windows: COLR/CPAL table (vector rasterization — returns Picture directly)
		      Dim colrPic As Picture = RasterizeEmoji_COLR(fontPath, cp, sizeInPoints)
		      If colrPic <> Nil Then Return colrPic
		      Return Nil
		    #EndIf

		    If pngData = Nil Then Return Nil

		    // Convert PNG to Picture and composite onto white background
		    // (SBIX PNGs have transparency which becomes black when converted to JPEG for PDF)
		    Dim emojiPic As Picture = Picture.FromData(pngData)
		    If emojiPic = Nil Then Return Nil

		    // Create white background at desired size with padding
		    Dim scaleFactor As Integer = 4
		    Dim basePicSize As Integer = sizeInPoints * scaleFactor
		    Dim padding As Integer = basePicSize * 0.15
		    Dim picSize As Integer = basePicSize + (padding * 2)

		    Dim result As New Picture(picSize, picSize)
		    Dim g As Graphics = result.Graphics
		    If g = Nil Then Return emojiPic

		    // Fill white background
		    g.DrawingColor = &cFFFFFF
		    g.FillRectangle(0, 0, picSize, picSize)

		    // Draw emoji centered on white background
		    Dim drawX As Integer = (picSize - basePicSize) / 2
		    Dim drawY As Integer = (picSize - basePicSize) / 2
		    g.DrawPicture(emojiPic, drawX, drawY, basePicSize, basePicSize, 0, 0, emojiPic.Width, emojiPic.Height)

		    Return result
		    
		  #Else
		    // Console has no graphics rendering capability
		    #Pragma Unused emojiChar
		    #Pragma Unused sizeInPoints
		    Return Nil
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 50726F7669646573206261736963207072696E74662D7374796C6520666F726D617474696E6720666F722043656C6C6628292F5772697465662829206D6574686F64732E0A
		Protected Function SprintfHelper(format As String, args() As Variant) As String
		  // Basic printf-style string formatting
		  // Supports: %s (string), %d/%i (integer), %f (float), %.Nf (float with N decimals), %% (escaped %)
		  // Example: SprintfHelper("Hello %s, value: %.2f", "World", 3.14159) → "Hello World, value: 3.14"
		  
		  Dim result As String = ""
		  Dim argIndex As Integer = 0
		  Dim i As Integer = 0
		  
		  #If TargetiOS Or TargetAndroid Then
		    // iOS: 0-based string indexing
		    While i < format.Length
		      If format.Middle(i, 1) = "%" And i + 1 < format.Length Then
		        Dim nextChar As String = format.Middle(i + 1, 1)
		        
		        If nextChar = "%" Then
		          // Escaped percent
		          result = result + "%"
		          i = i + 2
		          
		        ElseIf nextChar = "s" Then
		          // String
		          If argIndex <= args.LastIndex Then
		            result = result + args(argIndex).StringValue
		            argIndex = argIndex + 1
		          End If
		          i = i + 2
		          
		        ElseIf nextChar = "d" Or nextChar = "i" Then
		          // Integer
		          If argIndex <= args.LastIndex Then
		            result = result + Str(args(argIndex).IntegerValue)
		            argIndex = argIndex + 1
		          End If
		          i = i + 2
		          
		        ElseIf nextChar = "f" Or nextChar = "." Then
		          // Float (with optional precision)
		          Dim precision As Integer = 6  // Default precision
		          Dim consumed As Integer = 2   // %f consumes 2 characters
		          
		          If nextChar = "." Then
		            // Parse precision: %.2f, %.4f, etc.
		            Dim j As Integer = i + 2
		            Dim precStr As String = ""
		            While j < format.Length
		              Dim ch As String = format.Middle(j, 1)
		              If ch >= "0" And ch <= "9" Then
		                precStr = precStr + ch
		                j = j + 1
		              ElseIf ch = "f" Then
		                j = j + 1
		                Exit While
		              Else
		                Exit While
		              End If
		            Wend
		            
		            If precStr <> "" Then
		              precision = Val(precStr)
		            End If
		            consumed = j - i
		          End If
		          
		          If argIndex <= args.LastIndex Then
		            Dim value As Double = args(argIndex).DoubleValue
		            
		            // Format with specified precision using FormatHelper() to avoid scientific notation
		            // Build format string like "0.00" for 2 decimals
		            Dim formatStr As String = "0"
		            If precision > 0 Then
		              formatStr = formatStr + "."
		              For p As Integer = 1 To precision
		                formatStr = formatStr + "0"
		              Next
		            End If
		            
		            Dim formatted As String = FormatHelper(value, formatStr)
		            
		            result = result + formatted
		            argIndex = argIndex + 1
		          End If
		          i = i + consumed
		          
		        Else
		          // Unknown specifier - just copy
		          result = result + format.Middle(i, 1)
		          i = i + 1
		        End If
		      Else
		        // Regular character
		        result = result + format.Middle(i, 1)
		        i = i + 1
		      End If
		    Wend
		  #Else
		    // Desktop/Web/Console: 1-based string indexing
		    While i < format.Length
		      If format.Middle(i, 1) = "%" And i + 1 < format.Length Then
		        Dim nextChar As String = format.Middle(i + 1, 1)
		        
		        If nextChar = "%" Then
		          // Escaped percent
		          result = result + "%"
		          i = i + 2
		          
		        ElseIf nextChar = "s" Then
		          // String
		          If argIndex <= args.LastIndex Then
		            result = result + args(argIndex).StringValue
		            argIndex = argIndex + 1
		          End If
		          i = i + 2
		          
		        ElseIf nextChar = "d" Or nextChar = "i" Then
		          // Integer
		          If argIndex <= args.LastIndex Then
		            result = result + Str(args(argIndex).IntegerValue)
		            argIndex = argIndex + 1
		          End If
		          i = i + 2
		          
		        ElseIf nextChar = "f" Or nextChar = "." Then
		          // Float (with optional precision)
		          Dim precision As Integer = 6  // Default precision
		          Dim consumed As Integer = 2   // %f consumes 2 characters
		          
		          If nextChar = "." Then
		            // Parse precision: %.2f, %.4f, etc.
		            Dim j As Integer = i + 2
		            Dim precStr As String = ""
		            While j < format.Length
		              Dim ch As String = format.Middle(j, 1)
		              If ch >= "0" And ch <= "9" Then
		                precStr = precStr + ch
		                j = j + 1
		              ElseIf ch = "f" Then
		                j = j + 1
		                Exit While
		              Else
		                Exit While
		              End If
		            Wend
		            
		            If precStr <> "" Then
		              precision = Val(precStr)
		            End If
		            consumed = j - i
		          End If
		          
		          If argIndex <= args.LastIndex Then
		            Dim value As Double = args(argIndex).DoubleValue
		            // Build format string with repeated zeros
		            Dim zeros As String = ""
		            For k As Integer = 1 To precision
		              zeros = zeros + "0"
		            Next
		            result = result + FormatHelper(value, "0." + zeros)
		            argIndex = argIndex + 1
		          End If
		          i = i + consumed
		          
		        Else
		          // Unknown specifier - just copy
		          result = result + format.Middle(i, 1)
		          i = i + 1
		        End If
		      Else
		        // Regular character
		        result = result + format.Middle(i, 1)
		        i = i + 1
		      End If
		    Wend
		  #EndIf
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D206279746520746F20696E74656765722068656C7065722E
		Protected Function StringAscB(s As String) As Integer
		  // Cross-platform byte to integer helper
		  // iOS: Use .AscByte (API2)
		  // Desktop: Use AscB() function (API1)
		  
		  #If TargetiOS Or TargetAndroid Then
		    If s.Length > 0 Then
		      Return s.MiddleBytes(0, 1).AscByte
		    Else
		      Return 0
		    End If
		  #Else
		    Return s.AscByte()
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D20696E746567657220746F206279746520737472696E672068656C7065722E0A
		Protected Function StringChrB(byteValue As Integer) As String
		  // Cross-platform integer to byte string helper
		  // iOS: Use MemoryBlock (ChrB doesn't exist in API2)
		  // Desktop: Use ChrB() function (API1)
		  
		  #If TargetiOS Or TargetAndroid Then
		    Dim mb As New MemoryBlock(1)
		    mb.Byte(0) = byteValue
		    Return mb.StringValue(0, 1)
		  #Else
		    Return String.ChrByte(byteValue)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D206C6566742062797465732068656C7065722E0A
		Protected Function StringLeftB(s As String, numBytes As Integer) As String
		  // Cross-platform left bytes helper
		  // iOS: Use .LeftBytes() (API2)
		  // Desktop: Use LeftB() function (API1)
		  
		  Return s.LeftBytes(numBytes)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D20737562737472696E67206C656E6774682068656C7065722E0A
		Protected Function StringLen(s As String) As Integer
		  // Cross-platform string length helper
		  // iOS: Use .Length property (API2)
		  // Desktop: Use Len() function (API1)
		  
		  Return s.Length
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D2062797465206C656E6774682068656C7065722E0A
		Protected Function StringLenB(s As String) As Integer
		  // Cross-platform byte length helper
		  // iOS: Use .Bytes property (API2)
		  // Desktop: Use LenB() function (API1)
		  
		  Return s.Bytes
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D206D69642062797465732068656C7065722E0A
		Protected Function StringMidB(s As String, start As Integer, length As Integer) As String
		  // Cross-platform middle bytes helper
		  // iOS: Use .MiddleBytes() with 0-based index (API2)
		  // Desktop: Use MidB() with 1-based index (API1)
		  
		  #If TargetiOS Or TargetAndroid Then
		    Return s.MiddleBytes(start - 1, length)  // Convert to 0-based
		  #Else
		    Return s.MiddleBytes(start - 1, length)  // Convert to 0-based
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 43726F73732D706C6174666F726D2072696768742062797465732068656C7065722E0A
		Protected Function StringRightB(s As String, numBytes As Integer) As String
		  // Cross-platform right bytes helper
		  // iOS: Use .RightBytes() (API2)
		  // Desktop: Use RightB() function (API1)
		  
		  Return s.RightBytes(numBytes)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E76657274732055544638206279746573206174206F666673657420746F20556E69636F646520636F646520706F696E742E0A
		Protected Function UTF8ToCodePoint(utf8Str As String, offset As Integer, ByRef bytesRead As Integer) As UInt32
		  // Convert UTF-8 byte sequence to Unicode code point
		  // offset: byte position in string (0-based for all platforms)
		  // bytesRead: output parameter indicating how many bytes were consumed
		  // Returns: Unicode code point (supports up to 4-byte sequences including emoji)
		  
		  If offset < 0 Or offset >= utf8Str.Bytes Then
		    bytesRead = 0
		    Return 0
		  End If
		  
		  Dim firstByte As UInt8 = Asc(utf8Str.MiddleBytes(offset, 1))
		  
		  If (firstByte And &hF8) = &hF0 Then
		    // 4-byte UTF-8 sequence (0xF0-0xF7) - emoji and supplementary characters
		    If offset + 3 >= utf8Str.Bytes Then
		      bytesRead = 0
		      Return 0
		    End If
		    
		    Dim b1 As Integer = firstByte Mod 8
		    Dim b2 As Integer = Asc(utf8Str.MiddleBytes(offset + 1, 1)) Mod 64
		    Dim b3 As Integer = Asc(utf8Str.MiddleBytes(offset + 2, 1)) Mod 64
		    Dim b4 As Integer = Asc(utf8Str.MiddleBytes(offset + 3, 1)) Mod 64
		    bytesRead = 4
		    Return (b1 * &h40000) + (b2 * &h1000) + (b3 * &h40) + b4

		  ElseIf (firstByte And &hF0) = &hE0 Then
		    // 3-byte UTF-8 sequence (0xE0-0xEF)
		    If offset + 2 >= utf8Str.Bytes Then
		      bytesRead = 0
		      Return 0
		    End If

		    Dim b1 As Integer = firstByte Mod 16
		    Dim b2 As Integer = Asc(utf8Str.MiddleBytes(offset + 1, 1)) Mod 64
		    Dim b3 As Integer = Asc(utf8Str.MiddleBytes(offset + 2, 1)) Mod 64
		    bytesRead = 3
		    Return (b1 * &h1000) + (b2 * &h40) + b3

		  ElseIf (firstByte And &hE0) = &hC0 Then
		    // 2-byte UTF-8 sequence (0xC0-0xDF)
		    If offset + 1 >= utf8Str.Bytes Then
		      bytesRead = 0
		      Return 0
		    End If

		    Dim b1 As Integer = firstByte Mod 32
		    Dim b2 As Integer = Asc(utf8Str.MiddleBytes(offset + 1, 1)) Mod 64
		    bytesRead = 2
		    Return (b1 * &h40) + b2
		    
		  Else
		    // 1-byte sequence (ASCII 0x00-0x7F)
		    bytesRead = 1
		    Return firstByte
		  End If
		End Function
	#tag EndMethod


	#tag Note, Name = Module Description
		Global constants, enumerations, and utility methods for PDF generation.
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private mSBIXCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSBIXFontMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSBIXFontPath As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSBIXTableInfo As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCOLRCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSystemFontCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSystemFontIndex As Dictionary
	#tag EndProperty


	#tag Constant, Name = gkA3Height, Type = Double, Dynamic = False, Default = \"1190.55", Scope = Public, Description = 41332048656967687420696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkA3Width, Type = Double, Dynamic = False, Default = \"841.89", Scope = Public, Description = 413320576964746820696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkA4Height, Type = Double, Dynamic = False, Default = \"841.89", Scope = Public, Description = 41342048656967687420696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkA4Width, Type = Double, Dynamic = False, Default = \"595.28", Scope = Public, Description = 413420576964746820696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkA5Height, Type = Double, Dynamic = False, Default = \"595.28", Scope = Public, Description = 41352048656967687420696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkA5Width, Type = Double, Dynamic = False, Default = \"419.53", Scope = Public, Description = 413520576964746820696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkDefaultCompression, Type = Boolean, Dynamic = False, Default = \"True", Scope = Public, Description = 44656661756C7420636F6D7072657373696F6E2073657474696E672E0A
	#tag EndConstant

	#tag Constant, Name = gkDefaultMargin, Type = Double, Dynamic = False, Default = \"28.35", Scope = Public, Description = 44656661756C74206D617267696E20696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkDefaultPageFormat, Type = String, Dynamic = False, Default = \"A4", Scope = Public, Description = 44656661756C7420706167652073697A6520666F726D61742E0A
	#tag EndConstant

	#tag Constant, Name = gkDefaultPageOrientation, Type = String, Dynamic = False, Default = \"Portrait", Scope = Public, Description = 44656661756C7420706167652073697A65206F7269656E746174696F6E2E0A
	#tag EndConstant

	#tag Constant, Name = gkDefaultPageUnit, Type = String, Dynamic = False, Default = \"Millimeters", Scope = Public, Description = 44656661756C74206D6561737572656D656E7420756E69742E0A
	#tag EndConstant

	#tag Constant, Name = gkEncryptionAES128, Type = Integer, Dynamic = False, Default = \"4", Scope = Public, Description = 456E6372797074696F6E207265766973696F6E20343A204145532D313238202831323820626974204145532C205052454D49554D206D6F64756C65207265717569726564292E0A
	#tag EndConstant

	#tag Constant, Name = gkEncryptionAES256, Type = Integer, Dynamic = False, Default = \"5", Scope = Public, Description = 456E6372797074696F6E207265766973696F6E20353A204145532D323536202832353620626974204145532C205052454D49554D206D6F64756C65207265717569726564292E0A
	#tag EndConstant

	#tag Constant, Name = gkEncryptionAES256_PDF2, Type = Integer, Dynamic = False, Default = \"6", Scope = Public, Description = 456E6372797074696F6E207265766973696F6E20363A204145532D3235362050444620322E30202832353620626974204145532C205052454D49554D206D6F64756C65207265717569726564292E0A
	#tag EndConstant

	#tag Constant, Name = gkEncryptionRC4_128, Type = Integer, Dynamic = False, Default = \"3", Scope = Public, Description = 456E6372797074696F6E207265766973696F6E20333A205243342D3132382028313238206269742C205052454D49554D206D6F64756C65207265717569726564292E0A
	#tag EndConstant

	#tag Constant, Name = gkEncryptionRC4_40, Type = Integer, Dynamic = False, Default = \"2", Scope = Public, Description = 456E6372797074696F6E207265766973696F6E20323A205243342D34302028343020626974292C20465245452076657273696F6E2E0A
	#tag EndConstant

	#tag Constant, Name = gkErrBarcodeNotAvailable, Type = String, Dynamic = False, Default = \"Barcode generation not available on this platform", Scope = Public, Description = 4572726F72206D657373616765207768656E20626172636F64652067656E65726174696F6E206973206E6F7420617661696C61626C65206F6E207468652063757272656E7420706C6174666F726D2E
	#tag EndConstant

	#tag Constant, Name = gkLegalHeight, Type = Double, Dynamic = False, Default = \"1008", Scope = Public, Description = 4C6567616C2048656967687420696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkLegalWidth, Type = Double, Dynamic = False, Default = \"612", Scope = Public, Description = 4C6567616C20576964746820696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkLetterHeight, Type = Double, Dynamic = False, Default = \"792", Scope = Public, Description = 4C65747465722048656967687420696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkLetterWidth, Type = Double, Dynamic = False, Default = \"612", Scope = Public, Description = 4C657474657220576964746820696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkMMToPoints, Type = Double, Dynamic = False, Default = \"2.83464567", Scope = Public, Description = 436F6E76657273696F6E20666163746F7220666F72206D696C6C696D657465727320746F20706F696E74732028616C696173206F6620676B506F696E74735065724D696C6C696D65746572292E0A
	#tag EndConstant

	#tag Constant, Name = gkOutputIntentPDFA1, Type = String, Dynamic = False, Default = \"GTS_PDFA1", Scope = Public, Description = 4F757470757420696E74656E74207375627479706520666F7220504446412D312E0A
	#tag EndConstant

	#tag Constant, Name = gkOutputIntentPDFE1, Type = String, Dynamic = False, Default = \"GTS_PDFE1", Scope = Public, Description = 4F757470757420696E74656E74207375627479706520666F7220504446452D312E0A
	#tag EndConstant

	#tag Constant, Name = gkOutputIntentPDFX, Type = String, Dynamic = False, Default = \"GTS_PDFX", Scope = Public, Description = 4F757470757420696E74656E74207375627479706520666F7220504446582E0A
	#tag EndConstant

	#tag Constant, Name = gkPointsPerCentimeter, Type = Double, Dynamic = False, Default = \"28.3464567", Scope = Public, Description = 436F6E76657273696F6E20666163746F7220666F722063656E74696D6574657273206F20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkPointsPerInch, Type = Double, Dynamic = False, Default = \"72", Scope = Public, Description = 436F6E76657273696F6E20666163746F7220666F7220696E6368657320746F20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkPointsPerMillimeter, Type = Double, Dynamic = False, Default = \"2.83464567", Scope = Public, Description = 436F6E76657273696F6E20666163746F7220666F72206D696C6C696D657465727320746F20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkPointsToMM, Type = Double, Dynamic = False, Default = \"0.352778", Scope = Public, Description = 436F6E76657273696F6E20666163746F7220666F7220706F696E747320746F206D696C6C696D65746572732E
	#tag EndConstant

	#tag Constant, Name = gkRaiseExceptionOnOutOfBounds, Type = Boolean, Dynamic = False, Default = \"False", Scope = Public, Description = 496620747275652C20726169736573204F75744F66426F756E6473457863657074696F6E207768656E2064726177696E67206F757473696465207061676520626F756E64732E2044656661756C742069732066616C736520286F6E6C79206C6F6773207761726E696E67292E
	#tag EndConstant

	#tag Constant, Name = gkVersion, Type = String, Dynamic = False, Default = \"1.4", Scope = Public, Description = 564E5320504446204C6962726172792076657273696F6E20737472696E672E0A
	#tag EndConstant

	#tag Constant, Name = kHelveticaBoldJSON, Type = String, Dynamic = False, Default = \"{\"Tp\":\"Core\"\x2C\"Name\":\"Helvetica-Bold\"\x2C\"Up\":-100\x2C\"Ut\":50\x2C\"Cw\":[278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C333\x2C474\x2C556\x2C556\x2C889\x2C722\x2C238\x2C333\x2C333\x2C389\x2C584\x2C278\x2C333\x2C278\x2C278\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C333\x2C333\x2C584\x2C584\x2C584\x2C611\x2C975\x2C722\x2C722\x2C722\x2C722\x2C667\x2C611\x2C778\x2C722\x2C278\x2C556\x2C722\x2C611\x2C833\x2C722\x2C778\x2C667\x2C778\x2C722\x2C667\x2C611\x2C722\x2C667\x2C944\x2C667\x2C667\x2C611\x2C333\x2C278\x2C333\x2C584\x2C556\x2C333\x2C556\x2C611\x2C556\x2C611\x2C556\x2C333\x2C611\x2C611\x2C278\x2C278\x2C556\x2C278\x2C889\x2C611\x2C611\x2C611\x2C611\x2C389\x2C556\x2C333\x2C611\x2C556\x2C778\x2C556\x2C556\x2C500\x2C389\x2C280\x2C389\x2C584\x2C350\x2C556\x2C350\x2C278\x2C556\x2C500\x2C1000\x2C556\x2C556\x2C333\x2C1000\x2C667\x2C333\x2C1000\x2C350\x2C611\x2C350\x2C350\x2C278\x2C278\x2C500\x2C500\x2C350\x2C556\x2C1000\x2C333\x2C1000\x2C556\x2C333\x2C944\x2C350\x2C500\x2C667\x2C278\x2C333\x2C556\x2C556\x2C556\x2C556\x2C280\x2C556\x2C333\x2C737\x2C370\x2C556\x2C584\x2C333\x2C737\x2C333\x2C400\x2C584\x2C333\x2C333\x2C333\x2C611\x2C556\x2C278\x2C333\x2C333\x2C365\x2C556\x2C834\x2C834\x2C834\x2C611\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C1000\x2C722\x2C667\x2C667\x2C667\x2C667\x2C278\x2C278\x2C278\x2C278\x2C722\x2C722\x2C778\x2C778\x2C778\x2C778\x2C778\x2C584\x2C778\x2C722\x2C722\x2C722\x2C722\x2C667\x2C667\x2C611\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C889\x2C556\x2C556\x2C556\x2C556\x2C556\x2C278\x2C278\x2C278\x2C278\x2C611\x2C611\x2C611\x2C611\x2C611\x2C611\x2C611\x2C584\x2C611\x2C611\x2C611\x2C611\x2C611\x2C556\x2C611\x2C556]}", Scope = Private, Description = 48656C7665746963612D426F6C64206D6574726963732066726F6D20676F2D66706466
	#tag EndConstant

	#tag Constant, Name = kHelveticaJSON, Type = String, Dynamic = False, Default = \"{\"Tp\":\"Core\"\x2C\"Name\":\"Helvetica\"\x2C\"Up\":-100\x2C\"Ut\":50\x2C\"Cw\":[278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C355\x2C556\x2C556\x2C889\x2C667\x2C191\x2C333\x2C333\x2C389\x2C584\x2C278\x2C333\x2C278\x2C278\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C278\x2C278\x2C584\x2C584\x2C584\x2C556\x2C1015\x2C667\x2C667\x2C722\x2C722\x2C667\x2C611\x2C778\x2C722\x2C278\x2C500\x2C667\x2C556\x2C833\x2C722\x2C778\x2C667\x2C778\x2C722\x2C667\x2C611\x2C722\x2C667\x2C944\x2C667\x2C667\x2C611\x2C278\x2C278\x2C278\x2C469\x2C556\x2C333\x2C556\x2C556\x2C500\x2C556\x2C556\x2C278\x2C556\x2C556\x2C222\x2C222\x2C500\x2C222\x2C833\x2C556\x2C556\x2C556\x2C556\x2C333\x2C500\x2C278\x2C556\x2C500\x2C722\x2C500\x2C500\x2C500\x2C334\x2C260\x2C334\x2C584\x2C350\x2C556\x2C350\x2C222\x2C556\x2C333\x2C1000\x2C556\x2C556\x2C333\x2C1000\x2C667\x2C333\x2C1000\x2C350\x2C611\x2C350\x2C350\x2C222\x2C222\x2C333\x2C333\x2C350\x2C556\x2C1000\x2C333\x2C1000\x2C500\x2C333\x2C944\x2C350\x2C500\x2C667\x2C278\x2C333\x2C556\x2C556\x2C556\x2C556\x2C260\x2C556\x2C333\x2C737\x2C370\x2C556\x2C584\x2C333\x2C737\x2C333\x2C400\x2C584\x2C333\x2C333\x2C333\x2C556\x2C537\x2C278\x2C333\x2C333\x2C365\x2C556\x2C834\x2C834\x2C834\x2C611\x2C667\x2C667\x2C667\x2C667\x2C667\x2C667\x2C1000\x2C722\x2C667\x2C667\x2C667\x2C667\x2C278\x2C278\x2C278\x2C278\x2C722\x2C722\x2C778\x2C778\x2C778\x2C778\x2C778\x2C584\x2C778\x2C722\x2C722\x2C722\x2C722\x2C667\x2C667\x2C611\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C889\x2C500\x2C556\x2C556\x2C556\x2C556\x2C278\x2C278\x2C278\x2C278\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C584\x2C611\x2C556\x2C556\x2C556\x2C556\x2C500\x2C556\x2C500]}", Scope = Private, Description = 48656C766574696361206D6574726963732066726F6D20676F2D66706466
	#tag EndConstant

	#tag Constant, Name = kTimesJSON, Type = String, Dynamic = False, Default = \"{\"Tp\":\"Core\"\x2C\"Name\":\"Times-Roman\"\x2C\"Up\":-100\x2C\"Ut\":50\x2C\"Cw\":[250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C333\x2C408\x2C500\x2C500\x2C833\x2C778\x2C180\x2C333\x2C333\x2C500\x2C564\x2C250\x2C333\x2C250\x2C278\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C278\x2C278\x2C564\x2C564\x2C564\x2C444\x2C921\x2C722\x2C667\x2C667\x2C722\x2C611\x2C556\x2C722\x2C722\x2C333\x2C389\x2C722\x2C611\x2C889\x2C722\x2C722\x2C556\x2C722\x2C667\x2C556\x2C611\x2C722\x2C722\x2C944\x2C722\x2C722\x2C611\x2C333\x2C278\x2C333\x2C469\x2C500\x2C333\x2C444\x2C500\x2C444\x2C500\x2C444\x2C333\x2C500\x2C500\x2C278\x2C278\x2C500\x2C278\x2C778\x2C500\x2C500\x2C500\x2C500\x2C333\x2C389\x2C278\x2C500\x2C500\x2C722\x2C500\x2C500\x2C444\x2C480\x2C200\x2C480\x2C541\x2C350\x2C500\x2C350\x2C333\x2C500\x2C444\x2C1000\x2C500\x2C500\x2C333\x2C1000\x2C556\x2C333\x2C889\x2C350\x2C611\x2C350\x2C350\x2C333\x2C333\x2C444\x2C444\x2C350\x2C500\x2C1000\x2C333\x2C980\x2C389\x2C333\x2C722\x2C350\x2C444\x2C722\x2C250\x2C333\x2C500\x2C500\x2C500\x2C500\x2C200\x2C500\x2C333\x2C760\x2C276\x2C500\x2C564\x2C333\x2C760\x2C333\x2C400\x2C564\x2C300\x2C300\x2C333\x2C500\x2C453\x2C250\x2C333\x2C300\x2C310\x2C500\x2C750\x2C750\x2C750\x2C444\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C889\x2C667\x2C611\x2C611\x2C611\x2C611\x2C333\x2C333\x2C333\x2C333\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C564\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C556\x2C500\x2C444\x2C444\x2C444\x2C444\x2C444\x2C444\x2C667\x2C444\x2C444\x2C444\x2C444\x2C444\x2C278\x2C278\x2C278\x2C278\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C564\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500]}", Scope = Private, Description = 54696D65732D526F6D616E206D6574726963732066726F6D20676F2D66706466
	#tag EndConstant


	#tag Enum, Name = eBarcodeType, Type = Integer, Flags = &h0, Description = 426172636F646520747970657320737570706F7274656420627920746865207072656D69756D20626172636F6465206D6F64756C652E
		QRCode = 0
		  Code128 = 1
		  EAN13 = 2
		  EAN8 = 3
		  UPCA = 4
		  Code39 = 5
		  ITF = 6
		  Codabar = 7
		  DataMatrix = 8
		PDF417 = 9
	#tag EndEnum

	#tag Enum, Name = eColumnAlignment, Type = Integer, Flags = &h0, Description = 436F6C756D6E20616C69676E6D656E74206F7074696F6E733A204C6566742C2043656E7465722C2052696768742E
		Left = 0
		  Center = 1
		Right = 2
	#tag EndEnum

	#tag Enum, Name = eVerticalAlignment, Type = Integer, Flags = &h0
		Top = 0
		  Middle = 1
		Bottom = 2
		Baseline = 3
	#tag EndEnum

	#tag Enum, Name = eFooterCalcType, Type = Integer, Flags = &h0, Description = 466F6F7465722063616C63756C6174696F6E2074797065733A204E6F6E652C2053756D2C20417665726167652C204D696E696D756D2C204D6178696D756D2C20436F756E742E
		None = 0
		  Sum = 1
		  Average = 2
		  Minimum = 3
		  Maximum = 4
		Count = 5
	#tag EndEnum

	#tag Enum, Name = ePageFormat, Type = Integer, Flags = &h0
		A3 = 0
		  A4 = 1
		  A5 = 2
		  Letter = 3
		  Legal = 4
		Custom = 5
	#tag EndEnum

	#tag Enum, Name = ePageOrientation, Type = Integer, Flags = &h0
		Portrait = 0
		Landscape = 1
	#tag EndEnum

	#tag Enum, Name = ePageUnit, Type = Integer, Flags = &h0
		Points = 0
		  Millimeters = 1
		  Centimeters = 2
		Inches = 3
	#tag EndEnum

	#tag Enum, Name = ePathSegmentType, Type = Integer, Flags = &h0, Description = 50617468207365676D656E7420747970657320666F7220564E535044464772617068696373506174682E
		MoveTo = 0
		  LineTo = 1
		  CubicBezierTo = 2
		  QuadraticBezierTo = 3
		  CloseSubpath = 4
		Rectangle = 5
	#tag EndEnum

	#tag Enum, Name = eTextAlignment, Type = Integer, Flags = &h0, Description = 5465787420616C69676E6D656E74206F7074696F6E733A204C6566742C2043656E7465722C2052696768742C204A7573746966792E
		Left = 0
		  Center = 1
		  Right = 2
		Justify = 3
	#tag EndEnum


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
End Module
#tag EndModule
