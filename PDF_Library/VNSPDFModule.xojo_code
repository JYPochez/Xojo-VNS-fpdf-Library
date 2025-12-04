#tag Module
Protected Module VNSPDFModule
	#tag DelegateDeclaration, Flags = &h0
		Delegate Function AcceptPageBreakDelegate() As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0, Description = 436F6E76657274732063656E74696D657465727320746F20706F696E74732E0A
		Function CentimetersToPoints(cm As Double) As Double
		  Return cm * gkPointsPerCentimeter
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub FooterDelegateLpi(doc As VNSPDFDocument, lastPage As Boolean)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D20666F726D6174206865C6C7065722
		Function FormatHelper(value As Double, format As String) As String
		  // Cross-platform format helper
		  // iOS: Use Str() with manual formatting (API2 doesn't have Format)
		  // Desktop: Use Format() function (API1)
		  
		  #If TargetiOS Then
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

	#tag Method, Flags = &h0, Description = 476574206368617261637465722077696474682066726F6D20636F72652066F6E74206D6574726963732028696E20676C797068207761697473292
		Function GetCoreFontCharWidth(fontKey As String, charCode As Integer) As Integer
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
		  Return ParseFontMetrics(kHelveticaBoldJSON) // Same as bold
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetHelveticaBoldWidths() As Integer()
		  Return ParseFontMetrics(kHelveticaBoldJSON)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetHelveticaItalicWidths() As Integer()
		  Return ParseFontMetrics(kHelveticaJSON) // Same as regular Helvetica
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetHelveticaWidths() As Integer()
		  Return ParseFontMetrics(kHelveticaJSON)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D206D696372F73656F6E6473206865C6C7065722E
		Function GetMicroseconds() As Int64
		  // Cross-platform microseconds helper
		  // iOS: Use System.Microseconds (API2)
		  // Desktop: Use Microseconds function (API1)
		  
		  #If TargetiOS Then
		    Return System.Microseconds
		  #Else
		    Return System.Microseconds
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320706167652064696D656E73696F6E7320666F7220676976656E20666F726D617420617320506169722E0A
		Function GetPageFormatDimensions(format As ePageFormat) As Pair
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
		  Return ParseFontMetrics(kTimesJSON) // For simplicity, use same
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTimesBoldWidths() As Integer()
		  Return ParseFontMetrics(kTimesJSON) // For simplicity, use same
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTimesItalicWidths() As Integer()
		  Return ParseFontMetrics(kTimesJSON) // For simplicity, use same
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTimesWidths() As Integer()
		  Return ParseFontMetrics(kTimesJSON)
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub HeaderFooterDelegate(doc As VNSPDFDocument)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0, Description = 4368656620696620556E69636F646520636F646520706F696E7420697320616E20656D6F6A692E0A
		Function IsEmoji(codePoint As UInt32) As Boolean
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

	#tag Method, Flags = &h0, Description = 436F6E7665727473206D696C6C696D657465727320746F20706F696E74732E0A
		Function MillimetersToPoints(mm As Double) As Double
		  Return mm * gkPointsPerMillimeter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E7665727473207061676520666F726D617420656E756D20746F20737472696E672E0A
		Function PageFormatToString(format As ePageFormat) As String
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

	#tag Method, Flags = &h0, Description = 436F6E76657274732070616765206F7269656E746174696F6E20656E756D20746F20737472696E672E0A
		Function PageOrientationToString(orientation As ePageOrientation) As String
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

	#tag Method, Flags = &h0, Description = 436F6E7665727473207061676520756E697420656E756D20746F20737472696E672E0A
		Function PageUnitToString(unit As ePageUnit) As String
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

	#tag Method, Flags = &h21, Description = 50617273652066F6E74206D6574726963732066726F6D204A534F4
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
		    Dim endPos As Integer = jsonData.IndexOf(startPos, "]")
		    
		    // Calculate length and extract substring using string method
		    Dim arrayLength As Integer = endPos - startPos
		    Dim arrayStr As String = jsonData.Middle(startPos, arrayLength)
		    
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

	#tag Method, Flags = &h0, Description = 436F6E766572747320706F696E747320746F2063656E74696D65746572732E0A
		Function PointsToCentimeters(points As Double) As Double
		  Return points / gkPointsPerCentimeter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E766572747320706F696E747320746F20696E636865732E0A
		Function PointsToInches(points As Double) As Double
		  Return points / gkPointsPerInch
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E766572747320706F696E747320746F206D696C6C696D65746572732E0A
		Function PointsToMillimeters(points As Double) As Double
		  Return points / gkPointsPerMillimeter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656E64657220656D6F6A69206173206120636F6C6F7220696D6167652075736E6720706C6174666F726D277320656D6F6A6920666F6E742E0A
		Function RenderEmojiToImage(emojiChar As String, sizeInPoints As Integer, webSession As Variant = Nil) As Picture
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
		    Dim padding As Integer = basePicSize * 0.3  // 30% padding on all sides
		    Dim picSize As Integer = basePicSize + (padding * 2)
		    
		    Dim pic As New Picture(picSize, picSize, 32)
		    Dim g As Graphics = pic.Graphics
		    
		    // Clear background to white (not transparent - some emoji have transparency)
		    g.DrawingColor = &cFFFFFF
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
		    Declare Function whiteColor Lib "UIKit" Selector "whiteColor" (classRef As Ptr) As Ptr
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
		    
		    // Set white background
		    Dim UIColorClass As Ptr = NSClassFromString("UIColor")
		    Dim bgColor As Ptr = whiteColor(UIColorClass)
		    Call setBackgroundColor(label, bgColor)
		    
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
		    
		  #ElseIf TargetWeb Then
		    // Web: Use Picture/Graphics API - same approach as Desktop
		    #Pragma Unused webSession
		    
		    // Create a Picture large enough for the emoji with extra padding
		    // Use 4x size like Desktop to ensure no cropping
		    Dim scaleFactor As Integer = 4
		    Dim basePicSize As Integer = sizeInPoints * scaleFactor
		    Dim padding As Integer = basePicSize * 0.3  // 30% padding on all sides
		    Dim picSize As Integer = basePicSize + (padding * 2)
		    
		    // IMPORTANT: 32-bit depth required for emoji color
		    Dim pic As New Picture(picSize, picSize, 32)
		    Dim g As Graphics = pic.Graphics
		    
		    If g = Nil Then
		      System.DebugLog("  ✗ Picture.Graphics is Nil on Web")
		      Return Nil
		    End If
		    
		    System.DebugLog("  ✓ Picture.Graphics is available")
		    
		    // Clear background to white (not transparent - some emoji have transparency)
		    g.DrawingColor = &cFFFFFF
		    g.FillRectangle(0, 0, picSize, picSize)
		    
		    // Try to find emoji font file directly
		    System.DebugLog("  Attempting to locate emoji font file...")
		    
		    Dim fontPath As String
		    Dim fontFile As FolderItem
		    
		    #If TargetMacOS Then
		      // Try common macOS emoji font locations
		      Dim paths() As String
		      paths.Add("/System/Library/Fonts/Apple Color Emoji.ttc")
		      paths.Add("/Library/Fonts/Apple Color Emoji.ttc")
		      paths.Add("/System/Library/Fonts/AppleColorEmoji.ttc")
		      
		      For Each path As String In paths
		        fontFile = New FolderItem(path, FolderItem.PathModes.Native)
		        If fontFile <> Nil And fontFile.Exists Then
		          fontPath = path
		          System.DebugLog("  ✓ Found emoji font: " + fontPath)
		          System.DebugLog("  File size: " + Str(fontFile.Length) + " bytes")
		          Exit For
		        End If
		      Next
		    #EndIf
		    
		    If fontPath = "" Then
		      System.DebugLog("  ✗ Could not find emoji font file")
		      Return Nil
		    End If
		    
		    // Now try different approaches to use this font with Graphics API
		    g.FontSize = sizeInPoints * scaleFactor
		    g.DrawingColor = &c000000
		    
		    System.DebugLog("  Test 1: Try using full font file path")
		    g.FontName = fontPath
		    Dim test1Width As Double = g.TextWidth(emojiChar)
		    System.DebugLog("    TextFont = '" + g.FontName + "'")
		    System.DebugLog("    TextWidth = " + Str(test1Width))
		    
		    System.DebugLog("  Test 2: Try using just font filename")
		    g.FontName = "Apple Color Emoji.ttc"
		    Dim test2Width As Double = g.TextWidth(emojiChar)
		    System.DebugLog("    TextFont = '" + g.FontName + "'")
		    System.DebugLog("    TextWidth = " + Str(test2Width))
		    
		    System.DebugLog("  Test 3: Try using font name without extension")
		    g.FontName = "Apple Color Emoji"
		    Dim test3Width As Double = g.TextWidth(emojiChar)
		    System.DebugLog("    TextFont = '" + g.FontName + "'")
		    System.DebugLog("    TextWidth = " + Str(test3Width))
		    
		    // Use the best result
		    Dim textWidth As Double = test1Width
		    If test2Width > 0 Then textWidth = test2Width
		    If test3Width > 0 Then textWidth = test3Width
		    
		    If textWidth = 0 Then
		      System.DebugLog("  ✗ TextWidth returns 0 - emoji font not available to Graphics API on Web")
		      Return Nil
		    End If
		    
		    // Calculate centered position
		    Dim x As Integer = (picSize - textWidth) / 2
		    Dim y As Integer = padding + g.FontAscent + (basePicSize - g.TextHeight) / 2
		    
		    System.DebugLog("  Drawing at x=" + Str(x) + ", y=" + Str(y))
		    g.DrawText(emojiChar, x, y)
		    
		    System.DebugLog("  ✓ Picture.Graphics emoji rendering complete")
		    Return pic
		    
		  #Else
		    // Console has no graphics rendering capability
		    #Pragma Unused emojiChar
		    #Pragma Unused sizeInPoints
		    Return Nil
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 50726F76696465732062617369632070726E7467662D7374796C6520666F726D617474696E6720666F722043656C6C6628292F5772697465662829206D6574686F64732E
		Function SprintfHelper(format As String, args() As Variant) As String
		  // Basic printf-style string formatting
		  // Supports: %s (string), %d/%i (integer), %f (float), %.Nf (float with N decimals), %% (escaped %)
		  // Example: SprintfHelper("Hello %s, value: %.2f", "World", 3.14159) → "Hello World, value: 3.14"
		  
		  Dim result As String = ""
		  Dim argIndex As Integer = 0
		  Dim i As Integer = 0
		  
		  #If TargetiOS Then
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

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D206279746520746F20696E74656765722068656C7065722E
		Function StringAscB(s As String) As Integer
		  // Cross-platform byte to integer helper
		  // iOS: Use .AscByte (API2)
		  // Desktop: Use AscB() function (API1)
		  
		  #If TargetiOS Then
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

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D20696E746567657220746F206279746520737472696E67206865C6C7065722
		Function StringChrB(byteValue As Integer) As String
		  // Cross-platform integer to byte string helper
		  // iOS: Use MemoryBlock (ChrB doesn't exist in API2)
		  // Desktop: Use ChrB() function (API1)
		  
		  #If TargetiOS Then
		    Dim mb As New MemoryBlock(1)
		    mb.Byte(0) = byteValue
		    Return mb.StringValue(0, 1)
		  #Else
		    Return String.ChrByte(byteValue)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D206C656674206279746573206865C6C7065722
		Function StringLeftB(s As String, numBytes As Integer) As String
		  // Cross-platform left bytes helper
		  // iOS: Use .LeftBytes() (API2)
		  // Desktop: Use LeftB() function (API1)
		  
		  #If TargetiOS Then
		    Return s.LeftBytes(numBytes)
		  #Else
		    Return s.LeftBytes(numBytes)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D2073626769676E67206C656E6774682068656C7065722E
		Function StringLen(s As String) As Integer
		  // Cross-platform string length helper
		  // iOS: Use .Length property (API2)
		  // Desktop: Use Len() function (API1)
		  
		  #If TargetiOS Then
		    Return s.Length
		  #Else
		    Return s.Length
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D206279746520C6C656E677468206865C6C706572
		Function StringLenB(s As String) As Integer
		  // Cross-platform byte length helper
		  // iOS: Use .Bytes property (API2)
		  // Desktop: Use LenB() function (API1)
		  
		  #If TargetiOS Then
		    Return s.Bytes
		  #Else
		    Return s.Bytes
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D206D6964206279746573206865C6C7065722
		Function StringMidB(s As String, start As Integer, length As Integer) As String
		  // Cross-platform middle bytes helper
		  // iOS: Use .MiddleBytes() with 0-based index (API2)
		  // Desktop: Use MidB() with 1-based index (API1)
		  
		  #If TargetiOS Then
		    Return s.MiddleBytes(start - 1, length)  // Convert to 0-based
		  #Else
		    Return s.MiddleBytes(start, length)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726F73732D706C6174666F726D207269676874206279746573206865C6C7065722
		Function StringRightB(s As String, numBytes As Integer) As String
		  // Cross-platform right bytes helper
		  // iOS: Use .RightBytes() (API2)
		  // Desktop: Use RightB() function (API1)
		  
		  #If TargetiOS Then
		    Return s.RightBytes(numBytes)
		  #Else
		    Return s.RightBytes(numBytes)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E76657274732055544638206279746573206174206F666673657420746F20556E69636F646520636F646520706F696E742E0A
		Function UTF8ToCodePoint(utf8Str As String, offset As Integer, ByRef bytesRead As Integer) As UInt32
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
		    
		    Dim b1 As UInt32 = firstByte And &h07
		    Dim b2 As UInt32 = Asc(utf8Str.MiddleBytes(offset + 1, 1)) And &h3F
		    Dim b3 As UInt32 = Asc(utf8Str.MiddleBytes(offset + 2, 1)) And &h3F
		    Dim b4 As UInt32 = Asc(utf8Str.MiddleBytes(offset + 3, 1)) And &h3F
		    bytesRead = 4
		    Return (b1 * &h40000) Or (b2 * &h1000) Or (b3 * &h40) Or b4
		    
		  ElseIf (firstByte And &hF0) = &hE0 Then
		    // 3-byte UTF-8 sequence (0xE0-0xEF)
		    If offset + 2 >= utf8Str.Bytes Then
		      bytesRead = 0
		      Return 0
		    End If
		    
		    Dim b1 As UInt32 = firstByte And &h0F
		    Dim b2 As UInt32 = Asc(utf8Str.MiddleBytes(offset + 1, 1)) And &h3F
		    Dim b3 As UInt32 = Asc(utf8Str.MiddleBytes(offset + 2, 1)) And &h3F
		    bytesRead = 3
		    Return (b1 * &h1000) Or (b2 * &h40) Or b3
		    
		  ElseIf (firstByte And &hE0) = &hC0 Then
		    // 2-byte UTF-8 sequence (0xC0-0xDF)
		    If offset + 1 >= utf8Str.Bytes Then
		      bytesRead = 0
		      Return 0
		    End If
		    
		    Dim b1 As UInt32 = firstByte And &h1F
		    Dim b2 As UInt32 = Asc(utf8Str.MiddleBytes(offset + 1, 1)) And &h3F
		    bytesRead = 2
		    Return (b1 * &h40) Or b2
		    
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


	#tag Constant, Name = gkA3Height, Type = Double, Dynamic = False, Default = \"1190.55", Scope = Public, Description = 41332048656967687420696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkA3Width, Type = Double, Dynamic = False, Default = \"841.89", Scope = Public, Description = 4133205769647468206E20706F696E74732E0A
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

	#tag Constant, Name = gkEncryptionAES128, Type = Integer, Dynamic = False, Default = \"4", Scope = Public, Description = 454E6372797074696F6E20726576697369CF6E20343A204145532D31323820283132382062697420E2A0C2A0414553C2A02C2050524D494D20E2A0C2A06D6F64756C652072657175697265642902E0
	#tag EndConstant

	#tag Constant, Name = gkEncryptionAES256, Type = Integer, Dynamic = False, Default = \"5", Scope = Public, Description = 454E6372797074696F6E20726576697369CF6E20353A204145532D323536202832353620626974204145532C2050524D494D206D6F64756C652072657175697265642902E0
	#tag EndConstant

	#tag Constant, Name = gkEncryptionAES256_PDF2, Type = Integer, Dynamic = False, Default = \"6", Scope = Public, Description = 454E6372797074696F6E20726576697369CF6E20363A204145532D3235362050444620322E30202832353620626974204145532C2050524D494D206D6F64756C652072657175697265642902E0
	#tag EndConstant

	#tag Constant, Name = gkEncryptionRC4_128, Type = Integer, Dynamic = False, Default = \"3", Scope = Public, Description = 454E6372797074696F6E20726576697369CF6E20333A20524334C2D3132382028313238206269742C2050524D494D20E2A0C2A06D6F64756C652072657175697265642092E0A
	#tag EndConstant

	#tag Constant, Name = gkEncryptionRC4_40, Type = Integer, Dynamic = False, Default = \"2", Scope = Public, Description = 454E6372797074696F6E20726576697369CF6E20323A20524334C2D34302028343020626974292C2046524545207665727369CF6E2E0
	#tag EndConstant

	#tag Constant, Name = gkLegalHeight, Type = Double, Dynamic = False, Default = \"1008", Scope = Public, Description = 4C6567616C2048656967687420696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkLegalWidth, Type = Double, Dynamic = False, Default = \"612", Scope = Public, Description = 4C6567616C20576964746820696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkLetterHeight, Type = Double, Dynamic = False, Default = \"792", Scope = Public, Description = 4C65747465722048656967687420696E20706F696E74732E0A
	#tag EndConstant

	#tag Constant, Name = gkLetterWidth, Type = Double, Dynamic = False, Default = \"612", Scope = Public, Description = 4C657474657220576964746820696E20706F696E74732E0A
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

	#tag Constant, Name = gkVersion, Type = String, Dynamic = False, Default = \"0.3.0", Scope = Public, Description = 564E5320504446204C6962726172792076657273696F6E20737472696E672E0A
	#tag EndConstant

	#tag Constant, Name = hasPremiumEncryptionModule, Type = Boolean, Dynamic = False, Default = \"false", Scope = Public, Description = 5072656D69756D206D6F64756C653A20524334EFBFBD1323EFBFBD0C2B020414553206EFBFBD3727EFBFBD0746EFBFBD6E2E204365742074782054727565207768656E20696E7374616C6C65642E0A
	#tag EndConstant

	#tag Constant, Name = hasPremiumPDFAModule, Type = Boolean, Dynamic = False, Default = \"false", Scope = Public, Description = 5072656D69756D206D6F64756C653A2050444620412F41636F6D706C69616E63652E204365742074EFBFBD54727565207768656E20696E7374616C6C65642E0A
	#tag EndConstant

	#tag Constant, Name = hasPremiumTableModule, Type = Boolean, Dynamic = False, Default = \"false", Scope = Public, Description = 5072656D69756D206D6F64756C653A205461626C652067656E65726174696F6E2E205365742074EFBFBD54727565207768656E20696E7374616C6C65642E0A
	#tag EndConstant

	#tag Constant, Name = hasPremiumZlibModule, Type = Boolean, Dynamic = False, Default = \"false", Scope = Public, Description = 5072656D69756D206D6F64756C653A2050757265205861EFBFBDEFBFBDEFBFBDEFBFBDC6962C2A0636EFBFBDEFBFBD26573736EFBFBDEFBFBDEFBFBD04365742074CEFBFBD472756520776EFBFBD56EFBFBDEFBFBDEFBFBD4616EFBFBD564202EFBFBDEFBFBDEFBFBD3C2A0C2A0656EFBFBD26EFBFBD32EFBFBDEFBFBD
	#tag EndConstant

	#tag Constant, Name = kHelveticaBoldJSON, Type = String, Dynamic = False, Default = \"{\"Tp\":\"Core\"\x2C\"Name\":\"Helvetica-Bold\"\x2C\"Up\":-100\x2C\"Ut\":50\x2C\"Cw\":[278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C333\x2C474\x2C556\x2C556\x2C889\x2C722\x2C238\x2C333\x2C333\x2C389\x2C584\x2C278\x2C333\x2C278\x2C278\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C333\x2C333\x2C584\x2C584\x2C584\x2C611\x2C975\x2C722\x2C722\x2C722\x2C722\x2C667\x2C611\x2C778\x2C722\x2C278\x2C556\x2C722\x2C611\x2C833\x2C722\x2C778\x2C667\x2C778\x2C722\x2C667\x2C611\x2C722\x2C667\x2C944\x2C667\x2C667\x2C611\x2C333\x2C278\x2C333\x2C584\x2C556\x2C333\x2C556\x2C611\x2C556\x2C611\x2C556\x2C333\x2C611\x2C611\x2C278\x2C278\x2C556\x2C278\x2C889\x2C611\x2C611\x2C611\x2C611\x2C389\x2C556\x2C333\x2C611\x2C556\x2C778\x2C556\x2C556\x2C500\x2C389\x2C280\x2C389\x2C584\x2C350\x2C556\x2C350\x2C278\x2C556\x2C500\x2C1000\x2C556\x2C556\x2C333\x2C1000\x2C667\x2C333\x2C1000\x2C350\x2C611\x2C350\x2C350\x2C278\x2C278\x2C500\x2C500\x2C350\x2C556\x2C1000\x2C333\x2C1000\x2C556\x2C333\x2C944\x2C350\x2C500\x2C667\x2C278\x2C333\x2C556\x2C556\x2C556\x2C556\x2C280\x2C556\x2C333\x2C737\x2C370\x2C556\x2C584\x2C333\x2C737\x2C333\x2C400\x2C584\x2C333\x2C333\x2C333\x2C611\x2C556\x2C278\x2C333\x2C333\x2C365\x2C556\x2C834\x2C834\x2C834\x2C611\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C1000\x2C722\x2C667\x2C667\x2C667\x2C667\x2C278\x2C278\x2C278\x2C278\x2C722\x2C722\x2C778\x2C778\x2C778\x2C778\x2C778\x2C584\x2C778\x2C722\x2C722\x2C722\x2C722\x2C667\x2C667\x2C611\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C889\x2C556\x2C556\x2C556\x2C556\x2C556\x2C278\x2C278\x2C278\x2C278\x2C611\x2C611\x2C611\x2C611\x2C611\x2C611\x2C611\x2C584\x2C611\x2C611\x2C611\x2C611\x2C611\x2C556\x2C611\x2C556]}", Scope = Private, Description = 48656C7665746963612D426F6C64206D6574726963732066726F6D20676F2D66706466
	#tag EndConstant

	#tag Constant, Name = kHelveticaJSON, Type = String, Dynamic = False, Default = \"{\"Tp\":\"Core\"\x2C\"Name\":\"Helvetica\"\x2C\"Up\":-100\x2C\"Ut\":50\x2C\"Cw\":[278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C278\x2C355\x2C556\x2C556\x2C889\x2C667\x2C191\x2C333\x2C333\x2C389\x2C584\x2C278\x2C333\x2C278\x2C278\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C278\x2C278\x2C584\x2C584\x2C584\x2C556\x2C1015\x2C667\x2C667\x2C722\x2C722\x2C667\x2C611\x2C778\x2C722\x2C278\x2C500\x2C667\x2C556\x2C833\x2C722\x2C778\x2C667\x2C778\x2C722\x2C667\x2C611\x2C722\x2C667\x2C944\x2C667\x2C667\x2C611\x2C278\x2C278\x2C278\x2C469\x2C556\x2C333\x2C556\x2C556\x2C500\x2C556\x2C556\x2C278\x2C556\x2C556\x2C222\x2C222\x2C500\x2C222\x2C833\x2C556\x2C556\x2C556\x2C556\x2C333\x2C500\x2C278\x2C556\x2C500\x2C722\x2C500\x2C500\x2C500\x2C334\x2C260\x2C334\x2C584\x2C350\x2C556\x2C350\x2C222\x2C556\x2C333\x2C1000\x2C556\x2C556\x2C333\x2C1000\x2C667\x2C333\x2C1000\x2C350\x2C611\x2C350\x2C350\x2C222\x2C222\x2C333\x2C333\x2C350\x2C556\x2C1000\x2C333\x2C1000\x2C500\x2C333\x2C944\x2C350\x2C500\x2C667\x2C278\x2C333\x2C556\x2C556\x2C556\x2C556\x2C260\x2C556\x2C333\x2C737\x2C370\x2C556\x2C584\x2C333\x2C737\x2C333\x2C400\x2C584\x2C333\x2C333\x2C333\x2C556\x2C537\x2C278\x2C333\x2C333\x2C365\x2C556\x2C834\x2C834\x2C834\x2C611\x2C667\x2C667\x2C667\x2C667\x2C667\x2C667\x2C1000\x2C722\x2C667\x2C667\x2C667\x2C667\x2C278\x2C278\x2C278\x2C278\x2C722\x2C722\x2C778\x2C778\x2C778\x2C778\x2C778\x2C584\x2C778\x2C722\x2C722\x2C722\x2C722\x2C667\x2C667\x2C611\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C889\x2C500\x2C556\x2C556\x2C556\x2C556\x2C278\x2C278\x2C278\x2C278\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C556\x2C584\x2C611\x2C556\x2C556\x2C556\x2C556\x2C500\x2C556\x2C500]}", Scope = Private, Description = 48656C766574696361206D6574726963732066726F6D20676F2D66706466
	#tag EndConstant

	#tag Constant, Name = kTimesJSON, Type = String, Dynamic = False, Default = \"{\"Tp\":\"Core\"\x2C\"Name\":\"Times-Roman\"\x2C\"Up\":-100\x2C\"Ut\":50\x2C\"Cw\":[250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C250\x2C333\x2C408\x2C500\x2C500\x2C833\x2C778\x2C180\x2C333\x2C333\x2C500\x2C564\x2C250\x2C333\x2C250\x2C278\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C278\x2C278\x2C564\x2C564\x2C564\x2C444\x2C921\x2C722\x2C667\x2C667\x2C722\x2C611\x2C556\x2C722\x2C722\x2C333\x2C389\x2C722\x2C611\x2C889\x2C722\x2C722\x2C556\x2C722\x2C667\x2C556\x2C611\x2C722\x2C722\x2C944\x2C722\x2C722\x2C611\x2C333\x2C278\x2C333\x2C469\x2C500\x2C333\x2C444\x2C500\x2C444\x2C500\x2C444\x2C333\x2C500\x2C500\x2C278\x2C278\x2C500\x2C278\x2C778\x2C500\x2C500\x2C500\x2C500\x2C333\x2C389\x2C278\x2C500\x2C500\x2C722\x2C500\x2C500\x2C444\x2C480\x2C200\x2C480\x2C541\x2C350\x2C500\x2C350\x2C333\x2C500\x2C444\x2C1000\x2C500\x2C500\x2C333\x2C1000\x2C556\x2C333\x2C889\x2C350\x2C611\x2C350\x2C350\x2C333\x2C333\x2C444\x2C444\x2C350\x2C500\x2C1000\x2C333\x2C980\x2C389\x2C333\x2C722\x2C350\x2C444\x2C722\x2C250\x2C333\x2C500\x2C500\x2C500\x2C500\x2C200\x2C500\x2C333\x2C760\x2C276\x2C500\x2C564\x2C333\x2C760\x2C333\x2C400\x2C564\x2C300\x2C300\x2C333\x2C500\x2C453\x2C250\x2C333\x2C300\x2C310\x2C500\x2C750\x2C750\x2C750\x2C444\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C889\x2C667\x2C611\x2C611\x2C611\x2C611\x2C333\x2C333\x2C333\x2C333\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C564\x2C722\x2C722\x2C722\x2C722\x2C722\x2C722\x2C556\x2C500\x2C444\x2C444\x2C444\x2C444\x2C444\x2C444\x2C667\x2C444\x2C444\x2C444\x2C444\x2C444\x2C278\x2C278\x2C278\x2C278\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C564\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500\x2C500]}", Scope = Private, Description = 54696D65732D526F6D616E206D6574726963732066726F6D20676F2D66706466
	#tag EndConstant


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
