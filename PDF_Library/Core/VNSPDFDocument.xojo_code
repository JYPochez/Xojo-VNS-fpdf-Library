#tag Class
Protected Class VNSPDFDocument
	#tag Method, Flags = &h21
		Private Sub AddCoreFont(family As String, style As String)
		  // Build font key
		  Dim fontKey As String = family + style
		  
		  // Assign font number
		  mFontNumber = mFontNumber + 1
		  
		  // Core fonts don't need embedding - they're built into PDF viewers
		  // Just register them in our fonts dictionary
		  Dim fontInfo As New Dictionary
		  fontInfo.Value("type") = "core"
		  fontInfo.Value("name") = GetCoreFontName(family, style)
		  fontInfo.Value("number") = mFontNumber // Font reference number (for /F1, /F2, etc.)
		  fontInfo.Value("up") = -100 // Underline position
		  fontInfo.Value("ut") = 50 // Underline thickness
		  
		  mFonts.Value(fontKey) = fontInfo
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 437265617465732061206E657720696E7465726E616C206C696E6B20706C616365686F6C6465722E0A
		Function AddLink() As Integer
		  // Create a new internal link placeholder
		  // Returns the link ID (index in mLinks array)
		  
		  // Initialize empty link destination
		  Dim linkDest As New Dictionary
		  linkDest.Value("page") = 0
		  linkDest.Value("y") = 0.0
		  
		  // Add to links array
		  mLinks.Add(linkDest)
		  
		  // Return index (0-based array, but we want 1-based IDs)
		  Return mLinks.LastIndex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320616E206F757470757420696E74656E7420666F72205044462F412F582F4520617263686976616C20636F6D706C69616E63652E0A
		Sub AddOutputIntent(subtype As String, outputCondition As String, info As String, iccProfile As MemoryBlock)
		  // Add an output intent to the document for archival compliance (PDF/A, PDF/X, PDF/E)
		  // subtype: Use constants VNSPDFModule.gkOutputIntentPDFX, gkOutputIntentPDFA1, or gkOutputIntentPDFE1
		  // outputCondition: Registry identifier (e.g., "sRGB IEC61966-2.1")
		  // info: Optional descriptive text
		  // iccProfile: Binary ICC color profile data
		  
		  // Check for errors first
		  If Err() Then Return
		  
		  // Check premium module requirement for PDF/A support
		  #If Not hasPremiumVNSPDFAModule Then
		    #Pragma Unused subtype
		    #Pragma Unused outputCondition
		    #Pragma Unused info
		    #Pragma Unused iccProfile
		    Call SetError("PDF/A output intents require premium PDF/A module. This feature is not available in the free version.")
		    Return
		  #EndIf
		  
		  // Delegate to premium PDF/A module
		  #If hasPremiumVNSPDFAModule Then
		    VNSPDFPDFAPremium.AddOutputIntent(Self, subtype, outputCondition, info, iccProfile)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612066726573682070616765206F6620746865207370656369666965642C206F722064656661756C742C206F7269656E746174696F6E2E0A
		Sub AddPage(orientation As VNSPDFModule.ePageOrientation = VNSPDFModule.ePageOrientation.Portrait)
		  // Adds a new page to the document
		  // orientation: Page orientation (Portrait or Landscape)

		  // If this is the first page, transition from state 1 to state 2
		  If mState = 1 Then
		    mState = 2
		  End If

		  // Save current graphics state before starting new page
		  If mPage > 0 Then
		    // Call footer callback before ending page
		    If mHasFooterFunc Or mHasFooterFuncLpi Then
		      CallFooter()
		    End If
		    // End current page buffer
		    mPages.Value(Str(mPage)) = mBuffer
		    mBuffer = ""
		  End If

		  // Increment page counter
		  mPage = mPage + 1

		  // Set page orientation
		  mCurOrientation = orientation

		  // Calculate page dimensions based on orientation
		  If mCurOrientation = VNSPDFModule.ePageOrientation.Portrait Then
		    mPageWidth = mDefPageSize.Left / mScaleFactor
		    mPageHeight = mDefPageSize.Right / mScaleFactor
		    mPageWidthPt = mDefPageSize.Left
		    mPageHeightPt = mDefPageSize.Right
		  Else
		    mPageWidth = mDefPageSize.Right / mScaleFactor
		    mPageHeight = mDefPageSize.Left / mScaleFactor
		    mPageWidthPt = mDefPageSize.Right
		    mPageHeightPt = mDefPageSize.Left
		  End If

		  // Store current page size
		  mCurPageSize = New Pair(mPageWidthPt, mPageHeightPt)

		  // Reset position to top-left margin
		  mCurrentX = mLeftMargin
		  mCurrentY = mTopMargin

		  // Initialize page buffer
		  mBuffer = ""

		  // Store page size info
		  mPageSizes.Value(Str(mPage)) = mCurPageSize

		  // Call header callback if set
		  If mHasHeaderFunc Then
		    CallHeader()
		  End If

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612066726573682070616765207769746820637573746F6D2064696D656E73696F6E7320616E64206F7269656E746174696F6E2E0A
		Sub AddPageFormat(orientationStr As String, width As Double, height As Double)
		  // Add a page with custom dimensions (not predefined formats)
		  // orientationStr: "P" (Portrait) or "L" (Landscape)
		  // width, height: Custom page dimensions in current units

		  // Determine page dimensions based on orientation
		  Dim pageW, pageH As Double
		  If orientationStr.Uppercase = "L" Then
		    // Landscape: swap width and height
		    pageW = height
		    pageH = width
		  Else
		    // Portrait: use as-is
		    pageW = width
		    pageH = height
		  End If

		  // If this is the first page, transition from state 1 to state 2
		  If mState = 1 Then
		    mState = 2
		  End If

		  // Save current graphics state before starting new page
		  If mPage > 0 Then
		    // Call footer callback before ending page
		    If mHasFooterFunc Or mHasFooterFuncLpi Then
		      CallFooter()
		    End If
		    // End current page buffer
		    mPages.Value(Str(mPage)) = mBuffer
		    mBuffer = ""
		  End If

		  // Increment page counter
		  mPage = mPage + 1

		  // Set custom page dimensions
		  mPageWidth = pageW
		  mPageHeight = pageH
		  mPageWidthPt = pageW * mScaleFactor
		  mPageHeightPt = pageH * mScaleFactor

		  // Determine orientation for this page
		  If pageW > pageH Then
		    mCurOrientation = VNSPDFModule.ePageOrientation.Landscape
		  Else
		    mCurOrientation = VNSPDFModule.ePageOrientation.Portrait
		  End If

		  // Store current page size
		  mCurPageSize = New Pair(mPageWidthPt, mPageHeightPt)

		  // Reset position to top-left margin
		  mCurrentX = mLeftMargin
		  mCurrentY = mTopMargin

		  // Initialize page buffer
		  mBuffer = ""

		  // Store custom page size info
		  mPageSizes.Value(Str(mPage)) = mCurPageSize

		  // Recalculate page break trigger if auto page break is enabled
		  If mAutoPageBreak Then
		    mPageBreakTrigger = mPageHeight - mBottomMargin
		  End If

		  // Call header callback if set
		  If mHasHeaderFunc Then
		    CallHeader()
		  End If

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4C6F616473206120547275655479706520666F6E7420666F722055544620737570706F72742E0A
		Sub AddUTF8Font(family As String, style As String = "", fontFilePath As String = "")
		  // Save original family name before normalization (needed for font file search)
		  Dim originalFamily As String = family.Trim

		  // Normalize family name
		  family = family.Lowercase.Trim
		  style = style.Uppercase.Trim

		  // Build font key
		  Dim fontKey As String = family + style

		  // Check if font already loaded
		  If mFonts.HasKey(fontKey) Then
		    Return
		  End If

		  // If no file path provided, search system font directories
		  If fontFilePath = "" Then
		    // Map style to suffix for font file search
		    Dim styleSuffix As String = ""
		    If style = "B" Then
		      styleSuffix = " Bold"
		    ElseIf style = "I" Then
		      styleSuffix = " Italic"
		    ElseIf style = "BI" Then
		      styleSuffix = " Bold Italic"
		    End If

		    fontFilePath = VNSPDFModule.FindSystemFontPath(originalFamily, styleSuffix)
		    If fontFilePath = "" Then
		      Dim errMsg As String = "AddUTF8Font: Font not found: " + originalFamily + " " + style + ". Provide a file path or install the font."
		      Call SetError(errMsg)
		      System.DebugLog(errMsg)
		      If VNSPDFModule.gkRaiseExceptionOnOutOfBounds Then
		        Dim ex As New RuntimeException
		        ex.Message = errMsg
		        Raise ex
		      End If
		      Return
		    End If
		  End If

		  // Try to load the font file
		  Try
		    Dim fontFile As FolderItem = New FolderItem(fontFilePath, FolderItem.PathModes.Native)
		    If Not fontFile.Exists Then
		      Dim errMsg As String = "AddUTF8Font: Font file not found: " + fontFilePath
		      Call SetError(errMsg)
		      System.DebugLog(errMsg)
		      If VNSPDFModule.gkRaiseExceptionOnOutOfBounds Then
		        Dim ex As New RuntimeException
		        ex.Message = errMsg
		        Raise ex
		      End If
		      Return
		    End If

		    // Read font file
		    Dim fontStream As BinaryStream = BinaryStream.Open(fontFile)
		    Dim fontData As String = fontStream.Read(fontStream.Length)
		    fontStream.Close()

		    // Parse TrueType font
		    Dim ttf As New VNSPDFTrueTypeFont(fontData)
		    If Not ttf.IsValid Then
		      Dim errMsg As String = "AddUTF8Font: Invalid TrueType font file: " + fontFilePath
		      Call SetError(errMsg)
		      System.DebugLog(errMsg)
		      If VNSPDFModule.gkRaiseExceptionOnOutOfBounds Then
		        Dim ex As New RuntimeException
		        ex.Message = errMsg
		        Raise ex
		      End If
		      Return
		    End If
		    
		    // Assign font number
		    mFontNumber = mFontNumber + 1
		    
		    // Store font information
		    Dim fontInfo As New Dictionary
		    fontInfo.Value("type") = "UTF8"  // Use UTF8 type for proper CID font support
		    fontInfo.Value("name") = ttf.FontName
		    fontInfo.Value("number") = mFontNumber
		    fontInfo.Value("file") = fontFilePath
		    fontInfo.Value("data") = fontData
		    fontInfo.Value("ttf") = ttf
		    fontInfo.Value("up") = ttf.UnderlinePosition
		    fontInfo.Value("ut") = ttf.UnderlineThickness
		    fontInfo.Value("subset") = New Dictionary // Characters used (for subsetting)
		    fontInfo.Value("usedRunes") = New Dictionary // Track used Unicode characters

		    mFonts.Value(fontKey) = fontInfo

		  Catch e As IOException
		    Call SetError("Error loading font file: " + e.Message)
		  Catch e As RuntimeException
		    Call SetError("Error loading font: " + e.Message)
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4C6F6164732061205554462D3820666F6E742066726F6D2061206279746520617272617920284D656D6F7279426C6F636B292E0A
		Sub AddUTF8FontFromBytes(family As String, style As String = "", fontBytes As MemoryBlock)
		  // Load a UTF-8 font from a byte array (MemoryBlock)
		  // This is especially useful for iOS where file system access is restricted
		  // or when embedding fonts as resources
		  //
		  // Parameters:
		  //   family - Font family name (e.g., "arial", "times")
		  //   style - Font style: "" (regular), "B" (bold), "I" (italic), "BI" (bold-italic)
		  //   fontBytes - MemoryBlock containing TrueType font data (.ttf file bytes)
		  //
		  // Example:
		  //   Dim fontData As MemoryBlock = LoadFontResource()
		  //   pdf.AddUTF8FontFromBytes("arial", "", fontData)
		  //   pdf.SetFont("arial", "", 12)
		  
		  // Normalize family name
		  family = family.Lowercase.Trim
		  style = style.Uppercase.Trim
		  
		  // Build font key
		  Dim fontKey As String = family + style
		  
		  // Check if font already loaded
		  If mFonts.HasKey(fontKey) Then
		    Return
		  End If
		  
		  // Check if font bytes are provided
		  If fontBytes = Nil Or fontBytes.Size = 0 Then
		    Call SetError("Font bytes required for UTF-8 font.")
		    Return
		  End If
		  
		  // Parse TrueType font
		  Try
		    #If TargetiOS Or TargetAndroid Then
		      // iOS: Create TrueType font directly from MemoryBlock
		      Dim ttf As New VNSPDFTrueTypeFont(fontBytes)
		    #Else
		      // Desktop/Console/Web: Convert to String first
		      Dim fontDataStr As String = fontBytes.StringValue(0, fontBytes.Size)
		      Dim ttf As New VNSPDFTrueTypeFont(fontDataStr)
		    #EndIf
		    If Not ttf.IsValid Then
		      Call SetError("Invalid TrueType font data for " + family + style)
		      Return
		    End If
		    
		    // Assign font number
		    mFontNumber = mFontNumber + 1
		    
		    // Store font information
		    Dim fontInfo As New Dictionary
		    fontInfo.Value("type") = "UTF8"  // Use UTF8 type for proper CID font support
		    fontInfo.Value("name") = ttf.FontName
		    fontInfo.Value("number") = mFontNumber
		    fontInfo.Value("file") = "(embedded)"  // Mark as embedded font
		    #If TargetiOS Or TargetAndroid Then
		      // iOS: Store MemoryBlock directly (no String conversion)
		      fontInfo.Value("data") = fontBytes
		    #Else
		      // Desktop/Console/Web: Store as String (reuse fontDataStr from above)
		      fontInfo.Value("data") = fontDataStr
		    #EndIf
		    fontInfo.Value("ttf") = ttf
		    fontInfo.Value("up") = ttf.UnderlinePosition
		    fontInfo.Value("ut") = ttf.UnderlineThickness
		    fontInfo.Value("subset") = New Dictionary // Characters used (for subsetting)
		    fontInfo.Value("usedRunes") = New Dictionary // Track used Unicode characters
		    
		    mFonts.Value(fontKey) = fontInfo
		    
		  Catch e As RuntimeException
		    Call SetError("Error loading font from bytes: " + e.Message)
		  End Try

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddXObject(name As String, content As String)
		  // Add an XObject to the current page's resources
		  // For Phase 6.2, we'll store XObjects in a dictionary
		  
		  // Initialize XObjects dictionaries if needed
		  If mXObjects = Nil Then
		    mXObjects = New Dictionary
		  End If
		  If mXObjectObjNums = Nil Then
		    mXObjectObjNums = New Dictionary
		  End If
		  
		  // Store the XObject content
		  mXObjects.Value(name) = content
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436865636b7320696620636f6f7264696e6174657320617265206f757473696465207061676520626f756e647320616e64206c6f67732061207761726e696e672e
		Private Sub CheckBounds(x As Double, y As Double, w As Double = 0, h As Double = 0, context As String = "")
		  // Check if coordinates are outside page bounds and log a warning
		  // x, y: Position in user units (mm by default)
		  // w, h: Width and height (optional)
		  // context: Description of what's being drawn (for the log message)

		  Dim isOutside As Boolean = False
		  Dim details As String = ""

		  // Check left boundary
		  If x < 0 Then
		    isOutside = True
		    details = details + "x=" + Str(x) + " < 0; "
		  End If

		  // Check right boundary
		  If x > mPageWidth Then
		    isOutside = True
		    details = details + "x=" + Str(x) + " > pageWidth=" + Str(mPageWidth) + "; "
		  End If

		  // Check top boundary
		  If y < 0 Then
		    isOutside = True
		    details = details + "y=" + Str(y) + " < 0; "
		  End If

		  // Check bottom boundary
		  If y > mPageHeight Then
		    isOutside = True
		    details = details + "y=" + Str(y) + " > pageHeight=" + Str(mPageHeight) + "; "
		  End If

		  // Check if element extends beyond right edge
		  If w > 0 And (x + w) > mPageWidth Then
		    isOutside = True
		    details = details + "x+w=" + Str(x + w) + " > pageWidth=" + Str(mPageWidth) + "; "
		  End If

		  // Check if element extends beyond bottom edge
		  If h > 0 And (y + h) > mPageHeight Then
		    isOutside = True
		    details = details + "y+h=" + Str(y + h) + " > pageHeight=" + Str(mPageHeight) + "; "
		  End If

		  If isOutside Then
		    Dim msg As String = "WARNING: " + context + " outside page bounds - " + details
		    System.DebugLog(msg)

		    // Optionally raise exception if enabled
		    If VNSPDFModule.gkRaiseExceptionOnOutOfBounds Then
		      Dim e As New RuntimeException
		      e.Message = msg
		      Raise e
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 446566696E657320616E20616C69617320666F7220746865206E756D626572206F662070616765732E0A
		Sub AliasNbPages(aliasStr As String = "")
		  // Define an alias for the total number of pages.
		  // The alias will be substituted with the actual page count when the PDF is closed.
		  // aliasStr: The text to be replaced (default: "{nb}")
		  //
		  // Example: AliasNbPages("{nb}")
		  // Then use "Page 1 of {nb}" in headers/footers, which will become "Page 1 of 5"
		  
		  If aliasStr = "" Then
		    aliasStr = "{nb}"
		  End If
		  
		  mAliasNbPagesStr = aliasStr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AllocateFontObjects()
		  // Font object numbers are now assigned at output time in PutUTF8Font/PutTrueTypeFont
		  // This avoids object number mismatches when extra objects (ICC profiles,
		  // XMP metadata, attachments) are added by Factur-X or other features
		  // No pre-allocation needed — kept as placeholder for compatibility
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320616E206172632063656E7465726564206174202878E280AC2C20792920776974682072616469692028727828686F72697A6F6E74616C29E280AC2C207279287665727469E280AC63616C2929E280AC2C20726F746174656420627920646567526F746174652C2066726F6D20646567537461727420746F20646567456E642E0A
		Sub Arc(x As Double, y As Double, rx As Double, ry As Double, degRotate As Double, degStart As Double, degEnd As Double, style As String = "D")
		  // Draws an arc centered at (x, y) with radii (rx, ry)
		  // degRotate: Rotation angle of the ellipse in degrees
		  // degStart: Starting angle in degrees
		  // degEnd: Ending angle in degrees
		  // style: "D" (draw), "F" (fill), or "FD"/"DF" (both)
		  
		  Call ArcPath(x, y, rx, ry, degRotate, degStart, degEnd, style, False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F726520696D706C656D656E746174696F6E20666F72206472617720696E672061726373207769746820E280AC6F7074696F6E616C20E280AC7061746820696E74656772617469E280AC6F6E2E0A
		Private Sub ArcPath(x As Double, y As Double, rx As Double, ry As Double, degRotate As Double, degStart As Double, degEnd As Double, style As String, path As Boolean)
		  // Core implementation for drawing arcs with optional path integration
		  // path: If True, integrates with existing path (for future use)
		  
		  Const Pi As Double = 3.14159265358979323846
		  
		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If
		  
		  // Transform coordinates to PDF space
		  Dim xK As Double = x * mScaleFactor
		  Dim yK As Double = (mPageHeight - y) * mScaleFactor
		  Dim rxK As Double = rx * mScaleFactor
		  Dim ryK As Double = ry * mScaleFactor
		  
		  // Calculate number of segments (at least 2, one per 60 degrees)
		  Dim segments As Integer = (degEnd - degStart) / 60
		  If segments < 2 Then
		    segments = 2
		  End If
		  
		  // Convert angles to radians
		  Dim angleStart As Double = degStart * Pi / 180.0
		  Dim angleEnd As Double = degEnd * Pi / 180.0
		  Dim angleTotal As Double = angleEnd - angleStart
		  Dim dt As Double = angleTotal / segments
		  Dim dtm As Double = dt / 3.0
		  
		  // Handle rotation if needed
		  If degRotate <> 0 Then
		    Dim a As Double = -degRotate * Pi / 180.0
		    Dim sinA As Double = Sin(a)
		    Dim cosA As Double = Cos(a)
		    Const prec As Integer = 5
		    
		    // Save graphics state and apply rotation matrix
		    Dim cmd As String = "q "
		    cmd = cmd + FormatPDF(cosA, prec) + " "
		    cmd = cmd + FormatPDF(-1 * sinA, prec) + " "
		    cmd = cmd + FormatPDF(sinA, prec) + " "
		    cmd = cmd + FormatPDF(cosA, prec) + " "
		    cmd = cmd + FormatPDF(xK, prec) + " "
		    cmd = cmd + FormatPDF(yK, prec) + " cm" + EndOfLine.UNIX
		    
		    mBuffer = mBuffer + cmd
		    
		    // Reset center to origin after rotation
		    xK = 0
		    yK = 0
		  End If
		  
		  // Calculate initial point
		  Dim t As Double = angleStart
		  Dim a0 As Double = xK + rxK * Cos(t)
		  Dim b0 As Double = yK + ryK * Sin(t)
		  Dim c0 As Double = -rxK * Sin(t)
		  Dim d0 As Double = ryK * Cos(t)
		  
		  Dim sx As Double = a0 / mScaleFactor
		  Dim sy As Double = mPageHeight - (b0 / mScaleFactor)
		  
		  If path Then
		    // For future path integration - would check if current position matches
		    // If mCurrentX <> sx Or mCurrentY <> sy Then
		    //   Call LineTo(sx, sy)
		    // End If
		  Else
		    Call PointTo(sx, sy)
		  End If
		  
		  // Draw arc segments using Bezier curves
		  For j As Integer = 1 To segments
		    t = (j * dt) + angleStart
		    Dim a1 As Double = xK + rxK * Cos(t)
		    Dim b1 As Double = yK + ryK * Sin(t)
		    Dim c1 As Double = -rxK * Sin(t)
		    Dim d1 As Double = ryK * Cos(t)
		    
		    Call CurveTo((a0 + (c0 * dtm)) / mScaleFactor, _
		    mPageHeight - ((b0 + (d0 * dtm)) / mScaleFactor), _
		    (a1 - (c1 * dtm)) / mScaleFactor, _
		    mPageHeight - ((b1 - (d1 * dtm)) / mScaleFactor), _
		    a1 / mScaleFactor, _
		    mPageHeight - (b1 / mScaleFactor))
		    
		    a0 = a1
		    b0 = b1
		    c0 = c1
		    d0 = d1
		    
		    If path Then
		      // For future path integration - update current position
		      // mCurrentX = a1 / mScaleFactor
		      // mCurrentY = mPageHeight - (b1 / mScaleFactor)
		    End If
		  Next
		  
		  // Apply fill/stroke operation if not part of a path
		  If Not path Then
		    Dim op As String = FillDrawOp(style)
		    mBuffer = mBuffer + op + EndOfLine.UNIX
		  End If
		  
		  // Restore graphics state if rotation was applied
		  If degRotate <> 0 Then
		    mBuffer = mBuffer + "Q" + EndOfLine.UNIX
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44726177732061206C696E65207769746820616E206172726F7768656164206174206F6E65206F7220626F746820656E64732E0A
		Sub Arrow(x1 As Double, y1 As Double, x2 As Double, y2 As Double, startArrow As Boolean = False, endArrow As Boolean = True, arrowSize As Double = 3.0)
		  // Draws a line with arrowhead(s)
		  // (x1, y1): Starting point
		  // (x2, y2): Ending point
		  // startArrow: Draw arrowhead at start point
		  // endArrow: Draw arrowhead at end point
		  // arrowSize: Size of arrowhead in user units
		  
		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If
		  
		  // Calculate angle of the line
		  Const Pi As Double = 3.14159265358979323846
		  Dim dx As Double = x2 - x1
		  Dim dy As Double = y2 - y1
		  Dim angle As Double
		  
		  If dx = 0 And dy = 0 Then
		    Return // No line, no arrow
		  End If
		  
		  angle = Atan2(dy, dx)
		  
		  // Calculate line length
		  Dim lineLength As Double = Sqrt(dx * dx + dy * dy)
		  
		  // Arrowhead angle (30 degrees = Pi/6)
		  Dim arrowAngle As Double = Pi / 6.0
		  
		  // Calculate how much to shorten the line (distance from tip to arrowhead base)
		  // Using cos(30°) ≈ 0.866 for the arrowhead depth
		  Dim arrowDepth As Double = arrowSize * 0.866
		  
		  // Calculate shortened line endpoints
		  Dim lineX1 As Double = x1
		  Dim lineY1 As Double = y1
		  Dim lineX2 As Double = x2
		  Dim lineY2 As Double = y2
		  
		  If endArrow And lineLength > arrowDepth Then
		    // Shorten line at end by moving x2, y2 back along the line
		    lineX2 = x2 - arrowDepth * Cos(angle)
		    lineY2 = y2 - arrowDepth * Sin(angle)
		  End If
		  
		  If startArrow And lineLength > arrowDepth Then
		    // Shorten line at start by moving x1, y1 forward along the line
		    lineX1 = x1 + arrowDepth * Cos(angle)
		    lineY1 = y1 + arrowDepth * Sin(angle)
		  End If
		  
		  // Draw the shortened main line
		  Call Line(lineX1, lineY1, lineX2, lineY2)
		  
		  // Draw arrowhead at end point
		  If endArrow Then
		    Dim ax1 As Double = x2 - arrowSize * Cos(angle - arrowAngle)
		    Dim ay1 As Double = y2 - arrowSize * Sin(angle - arrowAngle)
		    Dim ax2 As Double = x2 - arrowSize * Cos(angle + arrowAngle)
		    Dim ay2 As Double = y2 - arrowSize * Sin(angle + arrowAngle)
		    
		    // Draw filled triangle for arrowhead
		    Call PointTo(x2, y2)
		    Dim cmd As String
		    cmd = FormatPDF(ax1 * mScaleFactor, 5) + " " + FormatPDF((mPageHeight - ay1) * mScaleFactor, 5) + " l " + EndOfLine.UNIX
		    cmd = cmd + FormatPDF(ax2 * mScaleFactor, 5) + " " + FormatPDF((mPageHeight - ay2) * mScaleFactor, 5) + " l " + EndOfLine.UNIX
		    cmd = cmd + "h f" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		  
		  // Draw arrowhead at start point
		  If startArrow Then
		    Dim ax1 As Double = x1 + arrowSize * Cos(angle - arrowAngle)
		    Dim ay1 As Double = y1 + arrowSize * Sin(angle - arrowAngle)
		    Dim ax2 As Double = x1 + arrowSize * Cos(angle + arrowAngle)
		    Dim ay2 As Double = y1 + arrowSize * Sin(angle + arrowAngle)
		    
		    // Draw filled triangle for arrowhead
		    Call PointTo(x1, y1)
		    Dim cmd As String
		    cmd = FormatPDF(ax1 * mScaleFactor, 5) + " " + FormatPDF((mPageHeight - ay1) * mScaleFactor, 5) + " l " + EndOfLine.UNIX
		    cmd = cmd + FormatPDF(ax2 * mScaleFactor, 5) + " " + FormatPDF((mPageHeight - ay2) * mScaleFactor, 5) + " l " + EndOfLine.UNIX
		    cmd = cmd + "h f" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612063C3B46F736564207368617065207573696E672063756269632042C3A97A69657220637572766520736567E280AC6D656E74732E0A
		Sub Beziergon(points() As Pair, style As String = "D")
		  // Draws a closed figure using cubic Bézier curve segments
		  // The first point defines the starting point
		  // Each three following points (p1, p2, p3) represent a curve segment:
		  //   - p1, p2: control points for the Bézier curve
		  //   - p3: end point of the curve segment
		  // points: array of Pair objects (must have at least 4 points: start + 3 for first curve)
		  // style: "D" (draw), "F" (fill), or "FD"/"DF" (both)
		  
		  If Err() Then Return
		  If mPage = 0 Then
		    Call SetError("Cannot draw: no page added yet")
		    Return
		  End If
		  
		  If points.LastIndex < 3 Then
		    Call SetError("Beziergon requires at least 4 points (1 start + 3 per curve segment)")
		    Return
		  End If
		  
		  Dim k As Double = mScaleFactor
		  Dim h As Double = mPageHeight
		  
		  // Move to starting point
		  Dim pt As Pair = points(0)
		  Call PointTo(pt.Left, pt.Right)
		  
		  // Process curve segments (each segment uses 3 points)
		  Dim idx As Integer = 1
		  While idx + 2 <= points.LastIndex
		    Dim cx0 As Double = points(idx).Left
		    Dim cy0 As Double = points(idx).Right
		    Dim cx1 As Double = points(idx + 1).Left
		    Dim cy1 As Double = points(idx + 1).Right
		    Dim x1 As Double = points(idx + 2).Left
		    Dim y1 As Double = points(idx + 2).Right
		    
		    Call CurveTo(cx0, cy0, cx1, cy1, x1, y1)
		    
		    idx = idx + 3
		  Wend
		  
		  // Close and apply style
		  Dim op As String = FillDrawOp(style)
		  mBuffer = mBuffer + op + EndOfLine.UNIX
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BinaryToHex(data As String) As String
		  // Convert binary string to hexadecimal (uppercase)
		  Const kHexChars As String = "0123456789ABCDEF"
		  Dim result As String = ""
		  
		  #If TargetiOS Or TargetAndroid Then
		    For i As Integer = 0 To data.Length - 1
		      Dim b As Integer = data.Middle(i, 1).AscByte
		      result = result + kHexChars.Middle((b \ 16), 1)
		      result = result + kHexChars.Middle((b Mod 16), 1)
		    Next
		  #Else
		    For i As Integer = 0 To data.Length - 1
		      Dim b As Integer = data.Middle(i, 1).AscByte
		      result = result + kHexChars.Middle(b \ 16, 1)
		      result = result + kHexChars.Middle(b Mod 16, 1)
		    Next
		  #EndIf
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732061626F6F6B6D61726B207468617420697320646973706C6179656420696E2073696465626172206F75746C696E652E0A
		Sub Bookmark(txt As String, level As Integer, y As Double = -1)
		  // Add a bookmark/outline entry
		  // txt: Title of the bookmark
		  // level: Level in the outline tree (0 = top level, 1 = below, etc.)
		  // y: Vertical position on current page (-1 for current position)
		  
		  If mPage = 0 Then
		    Call SetError("Cannot create bookmark: no page added yet")
		    Return
		  End If
		  
		  // Use current position if y = -1
		  Dim destY As Double = y
		  If destY = -1 Then
		    destY = mCurrentY
		  End If
		  
		  // Check if current font is TrueType/UTF8
		  Dim bookmarkText As String = txt
		  If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		    Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		    If fontInfo.HasKey("type") And fontInfo.Value("type") = "UTF8" Then
		      // Convert to UTF-16BE for TrueType fonts
		      bookmarkText = UTF8ToUTF16BE(txt, True)
		    End If
		  End If
		  
		  // Create bookmark dictionary
		  Dim bookmark As New Dictionary
		  bookmark.Value("text") = bookmarkText
		  bookmark.Value("level") = level
		  bookmark.Value("y") = destY
		  bookmark.Value("p") = mPage
		  bookmark.Value("parent") = -1
		  bookmark.Value("first") = -1
		  bookmark.Value("last") = -1
		  bookmark.Value("next") = -1
		  bookmark.Value("prev") = -1
		  
		  // Add to outlines array
		  mOutlines.Add(bookmark)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50726F636573736573207065676E64696E6720544F4320656E747269657320616E6420637265617465732023626F6F6B6D61726B732E0A
		Private Sub ProcessPendingTOCEntries()
		  // Process all pending TOC entries and create bookmarks
		  // This is called during PDF output (CloseDocument) to handle TOC entries
		  // that reference pages created after AddTOCEntry() was called (Xojo behavior)

		  For Each entry As Dictionary In mPendingTOCEntries
		    Dim title As String = entry.Value("title")
		    Dim pageNumber As Integer = entry.Value("pageNumber")
		    Dim level As Integer = entry.Value("level")

		    // If pageNumber is 0, use current page
		    Dim targetPage As Integer = pageNumber
		    If targetPage = 0 Then
		      targetPage = mPage
		    End If

		    // Validate page number
		    If targetPage < 1 Or targetPage > PageCount Then
		      // Skip invalid page references
		      Continue
		    End If

		    // Create bookmark directly with target page (don't use SetPage at this point)
		    // Check if current font is TrueType/UTF8 for proper text encoding
		    Dim bookmarkText As String = title
		    If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		      Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		      If fontInfo.HasKey("type") And fontInfo.Value("type") = "UTF8" Then
		        // Convert to UTF-16BE for TrueType fonts
		        bookmarkText = UTF8ToUTF16BE(title, True)
		      End If
		    End If

		    // Create bookmark dictionary with target page
		    Dim bookmark As New Dictionary
		    bookmark.Value("text") = bookmarkText
		    bookmark.Value("level") = level
		    bookmark.Value("y") = 0  // Top of page
		    bookmark.Value("p") = targetPage  // Use target page directly
		    bookmark.Value("parent") = -1
		    bookmark.Value("first") = -1
		    bookmark.Value("last") = -1
		    bookmark.Value("next") = -1
		    bookmark.Value("prev") = -1

		    // Add to outlines array
		    mOutlines.Add(bookmark)
		  Next

		  // Clear pending entries after processing
		  Redim mPendingTOCEntries(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 43616C6C73207468652075736572277320666F6F7465722063616C6C6261636B2066756E6374696F6E2E0A
		Private Sub CallFooter()
		  // Call the footer callback function with this document instance
		  // Supports both standard footer and Lpi (last page indicator) variant
		  If Not mInHeaderFooter Then
		    mInHeaderFooter = True
		    
		    If mHasFooterFuncLpi Then
		      // Call Lpi variant with lastPage indicator
		      // Note: We don't know if this is the last page during rendering,
		      // so we pass False. CloseDocument() will call with True.
		      mFooterFuncLpi.Invoke(Self, False)
		    ElseIf mHasFooterFunc Then
		      // Call standard footer
		      mFooterFunc.Invoke(Self)
		    End If
		    
		    mInHeaderFooter = False
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 43616C6C73207468652075736572277320686561646572206164616C6C6261636B2066756E6374696F6E2E0A
		Private Sub CallHeader()
		  // Call the header callback function with this document instance
		  If mHasHeaderFunc And Not mInHeaderFooter Then
		    mInHeaderFooter = True
		    mHeaderFunc.Invoke(Self)
		    
		    // If homeMode is enabled, reset position to top-left margins
		    If mHeaderHomeMode Then
		      mCurrentX = mLeftMargin
		      mCurrentY = mTopMargin
		    End If
		    
		    mInHeaderFooter = False
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E7665727473206554657874416C69676E6D656E7420656E756D20746F20616C69676E6D656E7420737472696E6720284C2C20432C20522C204A292E
		Function AlignmentEnumToString(align As VNSPDFModule.eTextAlignment) As String
		  // Converts eTextAlignment enum to the alignment string used internally
		  Select Case align
		  Case VNSPDFModule.eTextAlignment.Left
		    Return "L"
		  Case VNSPDFModule.eTextAlignment.Center
		    Return "C"
		  Case VNSPDFModule.eTextAlignment.Right
		    Return "R"
		  Case VNSPDFModule.eTextAlignment.Justify
		    Return "J"
		  Else
		    Return "L"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E766572747320616C69676E6D656E7420737472696E6720284C2C20432C20522C204A2920746F206554657874416C69676E6D656E7420656E756D2E
		Function AlignmentStringToEnum(align As String) As VNSPDFModule.eTextAlignment
		  // Converts alignment string to eTextAlignment enum
		  Select Case align.Uppercase
		  Case "C"
		    Return VNSPDFModule.eTextAlignment.Center
		  Case "R"
		    Return VNSPDFModule.eTextAlignment.Right
		  Case "J"
		    Return VNSPDFModule.eTextAlignment.Justify
		  Else
		    Return VNSPDFModule.eTextAlignment.Left
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F75747075747320612063656C6C2028726563745C616E67756C617220617265612920776974682074657874C2B62E
		Sub Cell(w As Double, h As Double = 0, txt As String = "", border As Variant = 0, ln As Integer = 0, align As String = "", fill As Boolean = False, link As String = "", vAlign As VNSPDFModule.eVerticalAlignment = VNSPDFModule.eVerticalAlignment.Middle)
		  #Pragma Unused link
		  
		  // Check if page is active
		  If mPage = 0 Then
		    mError = mError + "Cannot output cell: no page added yet." + EndOfLine
		    Return
		  End If
		  
		  // Check if font is set
		  If mCurrentFont = "" And txt <> "" Then
		    mError = mError + "Cannot output cell: no font selected. Call SetFont first." + EndOfLine
		    Return
		  End If
		  
		  // Default height is current font size (convert from points to user units)
		  If h = 0 Then
		    h = mFontSize / mScaleFactor
		  End If
		  
		  // Width of 0 means extend to right margin
		  If w = 0 Then
		    w = mPageWidth - mRightMargin - mCurrentX
		  End If

		  CheckBounds(mCurrentX, mCurrentY, w, h, "Cell")

		  // Check for automatic page break
		  If mAutoPageBreak And Not mInHeaderFooter And Not mInAcceptPageBreak And (mCurrentY + h > mPageBreakTrigger) Then
		    // Add the new page first
		    AddPage(mCurOrientation)
		    
		    // Then call accept page break callback if set (on the new page)
		    If mAcceptPageBreakFunc <> Nil Then
		      mInAcceptPageBreak = True  // Prevent recursive calls
		      Call mAcceptPageBreakFunc.Invoke()
		      mInAcceptPageBreak = False
		    End If
		  End If
		  
		  Dim cmd As String = ""
		  
		  // Convert border parameter to string (matching go-fpdf)
		  Dim borderStr As String

		  // Handle numeric vs string border values (GB 12/03/26)
		  If border.IsNumeric Then
		    Try
		      Dim intVal As Integer = border.IntegerValue
		      borderStr = Str(intVal)
		    Catch
		      borderStr = ""
		    End Try
		  Else
		    Try
		      borderStr = border.StringValue
		    Catch
		      borderStr = ""
		    End Try
		  End If
		  
		  borderStr = borderStr.Uppercase.Trim
		  
		  // Draw filled rectangle or border (matching go-fpdf logic)
		  If h > 0 And (fill Or borderStr = "1") Then
		    // Output fill color BEFORE drawing rectangle if this cell has fill
		    If fill Then
		      Dim rFillPDF As Double = mFillColorR / 255.0
		      Dim gFillPDF As Double = mFillColorG / 255.0
		      Dim bFillPDF As Double = mFillColorB / 255.0
		      cmd = cmd + FormatPDF(rFillPDF, 3) + " " + FormatPDF(gFillPDF, 3) + " " + FormatPDF(bFillPDF, 3) + " rg" + EndOfLine.UNIX
		    End If
		    
		    Dim op As String
		    If fill Then
		      If borderStr = "1" Then
		        op = "B" // Both fill and stroke
		      Else
		        op = "f" // Fill only
		      End If
		    Else
		      op = "S" // Stroke only
		    End If
		    
		    cmd = cmd + FormatPDF(mCurrentX * mScaleFactor) + " "
		    cmd = cmd + FormatPDF((mPageHeight - mCurrentY) * mScaleFactor) + " "
		    cmd = cmd + FormatPDF(w * mScaleFactor) + " "
		    cmd = cmd + FormatPDF(-h * mScaleFactor) + " re " + op + " " + EndOfLine.UNIX
		  End If
		  
		  // Draw individual borders if borderStr is not "1" and not empty
		  If VNSPDFModule.StringLenB(borderStr) > 0 And borderStr <> "1" Then
		    Dim x As Double = mCurrentX
		    Dim y As Double = mCurrentY
		    
		    If borderStr.IndexOf("L") >= 0 Then
		      // Left border
		      cmd = cmd + FormatPDF(x * mScaleFactor) + " "
		      cmd = cmd + FormatPDF((mPageHeight - y) * mScaleFactor) + " m "
		      cmd = cmd + FormatPDF(x * mScaleFactor) + " "
		      cmd = cmd + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " l S " + EndOfLine.UNIX
		    End If
		    
		    If borderStr.IndexOf("T") >= 0 Then
		      // Top border
		      cmd = cmd + FormatPDF(x * mScaleFactor) + " "
		      cmd = cmd + FormatPDF((mPageHeight - y) * mScaleFactor) + " m "
		      cmd = cmd + FormatPDF((x + w) * mScaleFactor) + " "
		      cmd = cmd + FormatPDF((mPageHeight - y) * mScaleFactor) + " l S " + EndOfLine.UNIX
		    End If
		    
		    If borderStr.IndexOf("R") >= 0 Then
		      // Right border
		      cmd = cmd + FormatPDF((x + w) * mScaleFactor) + " "
		      cmd = cmd + FormatPDF((mPageHeight - y) * mScaleFactor) + " m "
		      cmd = cmd + FormatPDF((x + w) * mScaleFactor) + " "
		      cmd = cmd + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " l S " + EndOfLine.UNIX
		    End If
		    
		    If borderStr.IndexOf("B") >= 0 Then
		      // Bottom border
		      cmd = cmd + FormatPDF(x * mScaleFactor) + " "
		      cmd = cmd + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " m "
		      cmd = cmd + FormatPDF((x + w) * mScaleFactor) + " "
		      cmd = cmd + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " l S " + EndOfLine.UNIX
		    End If
		  End If
		  
		  // Output text if provided
		  If txt <> "" Then
		    // Truncate text if it's too wide for the cell
		    Dim availableWidth As Double = w - (2 * mCellMargin)
		    Dim strWidth As Double = GetStringWidth(txt)
		    Dim displayText As String = txt
		    
		    If strWidth > availableWidth Then
		      // Text is too wide - truncate with ellipsis
		      Dim ellipsis As String = "..."
		      Dim ellipsisWidth As Double = GetStringWidth(ellipsis)
		      Dim maxTextWidth As Double = availableWidth - ellipsisWidth
		      
		      // Find the longest substring that fits with ellipsis
		      Dim textLen As Integer = txt.Length
		      Dim truncatedText As String = txt
		      
		      While textLen > 0
		        truncatedText = txt.Left(textLen)
		        Dim truncatedWidth As Double = GetStringWidth(truncatedText)
		        If truncatedWidth <= maxTextWidth Then
		          // Found a length that fits - add ellipsis and exit
		          displayText = truncatedText + ellipsis
		          Exit While
		        End If
		        textLen = textLen - 1
		      Wend
		      
		    End If
		    
		    // Check if current font is UTF8
		    Dim isUTF8 As Boolean = False
		    Dim ttf As VNSPDFTrueTypeFont = Nil
		    Dim encodedText As String = ""
		    Dim glyphMapping As Dictionary = Nil  // Declare at outer scope
		    
		    If mFonts.HasKey(mCurrentFont) Then
		      Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		      If fontInfo.HasKey("type") And fontInfo.Value("type") = "UTF8" Then
		        isUTF8 = True
		        If fontInfo.HasKey("ttf") Then
		          ttf = fontInfo.Value("ttf")
		        End If
		        
		        // Get glyph mapping if font was subset
		        If fontInfo.HasKey("glyphMapping") Then
		          glyphMapping = fontInfo.Value("glyphMapping")
		        End If
		        
		        // Track used Unicode characters AFTER shaping
		        // Shape Arabic text first (converts to presentation forms)
		        Dim shapedText As String = ShapeArabicText(displayText)
		        
		        If fontInfo.HasKey("usedRunes") Then
		          Dim usedRunes As Dictionary = fontInfo.Value("usedRunes")
		          
		          // Convert shaped text to Unicode code points (handles multi-byte UTF-8)
		          Dim shapedCodePoints() As Integer = UTF8ToCodePoints(shapedText)
		          
		          For i As Integer = 0 To shapedCodePoints.LastIndex
		            Dim codePoint As Integer = shapedCodePoints(i)
		            usedRunes.Value(Str(codePoint)) = codePoint
		          Next
		        End If
		      End If
		    End If
		    
		    // Encode text based on font type
		    If isUTF8 And ttf <> Nil Then
		      // Use glyph ID encoding for UTF8 TrueType fonts (hex string format)
		      // Pass glyph mapping if font was subset
		      encodedText = EncodeTextForTrueType(displayText, ttf, glyphMapping)
		    Else
		      // Use standard PDF string escaping for core fonts
		      encodedText = "(" + EscapeText(displayText) + ")"
		    End If
		    
		    // Calculate text position based on alignment
		    Dim dx As Double = 0
		    align = align.Uppercase
		    
		    If align = "R" Then
		      // Right align
		      strWidth = GetStringWidth(displayText)
		      dx = w - strWidth - mCellMargin
		    ElseIf align = "C" Then
		      // Center align
		      strWidth = GetStringWidth(displayText)
		      dx = (w - strWidth) / 2
		    ElseIf align = "J" Then
		      // Justify: left-aligned position, word spacing calculated below
		      dx = mCellMargin
		    Else
		      // Left align (default)
		      dx = mCellMargin
		    End If
		    
		    Dim txtX As Double = (mCurrentX + dx) * mScaleFactor
		    // Calculate text Y position based on vertical alignment (GB 12/03/26)
		    Dim fontSizeInUserUnits As Double = mFontSize / mScaleFactor
		    Dim dy As Double

		    Select Case vAlign
		    Case VNSPDFModule.eVerticalAlignment.Top
		      dy = mCurrentY + fontSizeInUserUnits
		    Case VNSPDFModule.eVerticalAlignment.Bottom
		      dy = mCurrentY + h - 0.3 * fontSizeInUserUnits
		    Case VNSPDFModule.eVerticalAlignment.Baseline
		      dy = mCurrentY + h
		    Case Else // Middle (default)
		      dy = mCurrentY + (h - fontSizeInUserUnits) / 2.0 + 0.7 * fontSizeInUserUnits
		    End Select

		    Dim txtY As Double = (mPageHeight - dy) * mScaleFactor
		    
		    // Output text color command in the cmd string (not directly to buffer)
		    Dim rPDF As Double = mTextColorR / 255.0
		    Dim gPDF As Double = mTextColorG / 255.0
		    Dim bPDF As Double = mTextColorB / 255.0
		    cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " rg" + EndOfLine.UNIX

		    // Detect if we need simulated bold/italic for UTF-8 fonts without B/I variants
		    Dim simulateBold As Boolean = False
		    Dim simulateItalic As Boolean = False
		    If isUTF8 And mFontStyle <> "" Then
		      Dim styleNoDecor As String = mFontStyle.ReplaceAll("U", "").ReplaceAll("S", "")
		      If styleNoDecor.IndexOf("B") >= 0 Then simulateBold = True
		      If styleNoDecor.IndexOf("I") >= 0 Then simulateItalic = True
		    End If

		    // Simulated bold: set text rendering mode to 2 (fill + stroke) with thin stroke
		    If simulateBold Then
		      Dim boldStrokeWidth As Double = mFontSizePt * 0.05
		      cmd = cmd + FormatPDF(boldStrokeWidth) + " w " + EndOfLine.UNIX
		      cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " RG " + EndOfLine.UNIX
		      cmd = cmd + "2 Tr" + EndOfLine.UNIX
		    End If

		    cmd = cmd + "BT" + EndOfLine.UNIX

		    // Set font inside text object (REQUIRED in PDF)
		    If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		      Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		      Dim fontNum As Integer = fontInfo.Value("number")
		      cmd = cmd + "/F" + Str(fontNum) + " " + FormatPDF(mFontSizePt) + " Tf" + EndOfLine.UNIX
		    End If

		    // Justify alignment: calculate and set word spacing inside BT/ET
		    Dim justifyWordSpacing As Double = 0
		    If align = "J" And displayText.IndexOf(" ") >= 0 Then
		      Dim spaceCount As Integer = 0
		      For jIdx As Integer = 0 To displayText.Length - 1
		        If displayText.Middle(jIdx, 1) = " " Then spaceCount = spaceCount + 1
		      Next
		      If spaceCount > 0 Then
		        strWidth = GetStringWidth(displayText)
		        justifyWordSpacing = (w - 2 * mCellMargin - strWidth) / spaceCount
		        If justifyWordSpacing < 0 Then justifyWordSpacing = 0
		        cmd = cmd + FormatPDF(justifyWordSpacing * mScaleFactor) + " Tw" + EndOfLine.UNIX
		      End If
		    End If

		    // Apply text rise for subscript/superscript (always emit when dirty to ensure 0 Ts resets)
		    If mTextRiseDirty Then
		      cmd = cmd + FormatPDF(mTextRise) + " Ts" + EndOfLine.UNIX
		      If mTextRise = 0.0 Then mTextRiseDirty = False
		    End If

		    // Position text: use text matrix for simulated italic (shear), otherwise simple Td
		    If simulateItalic Then
		      Dim shear As Double = 0.21
		      cmd = cmd + "1 0 " + FormatPDF(shear) + " 1 " + FormatPDF(txtX) + " " + FormatPDF(txtY) + " Tm" + EndOfLine.UNIX
		    Else
		      cmd = cmd + FormatPDF(txtX) + " " + FormatPDF(txtY) + " Td" + EndOfLine.UNIX
		    End If
		    cmd = cmd + encodedText + " Tj" + EndOfLine.UNIX
		    cmd = cmd + "ET" + EndOfLine.UNIX

		    // Reset word spacing after justify
		    If justifyWordSpacing > 0 Then
		      cmd = cmd + "0 Tw" + EndOfLine.UNIX
		    End If

		    // Reset text rendering mode and restore stroke color/width after simulated bold
		    If simulateBold Then
		      cmd = cmd + "0 Tr" + EndOfLine.UNIX
		      // Restore stroke color to current draw color (simulated bold sets RG to text color)
		      Dim rDrawPDF As Double = mDrawColorR / 255.0
		      Dim gDrawPDF As Double = mDrawColorG / 255.0
		      Dim bDrawPDF As Double = mDrawColorB / 255.0
		      cmd = cmd + FormatPDF(rDrawPDF, 3) + " " + FormatPDF(gDrawPDF, 3) + " " + FormatPDF(bDrawPDF, 3) + " RG" + EndOfLine.UNIX
		      // Restore line width (simulated bold sets w to font stroke width)
		      cmd = cmd + FormatPDF(mLineWidth * mScaleFactor) + " w" + EndOfLine.UNIX
		    End If

		    // Draw underline if style contains "U"
		    If mFontStyle.IndexOf("U") >= 0 Then
		      If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		        Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		        
		        // Get underline position and thickness from font metrics
		        Dim up As Double = -100 // Default underline position
		        Dim ut As Double = 50   // Default underline thickness
		        
		        If fontInfo.HasKey("up") Then
		          up = fontInfo.Value("up")
		        End If
		        If fontInfo.HasKey("ut") Then
		          ut = fontInfo.Value("ut")
		        End If
		        
		        // Calculate underline position and thickness in user units
		        // up and ut are in font units (1000 units = 1 em)
		        Dim underlineOffset As Double = up * mFontSizePt / 1000.0
		        Dim underlineThickness As Double = ut * mFontSizePt / 1000.0 * mUnderlineThickness
		        
		        // Calculate underline Y position (in PDF coordinates)
		        Dim underlineY As Double = txtY + (underlineOffset * mScaleFactor)
		        
		        // Set line width for underline
		        cmd = cmd + FormatPDF(underlineThickness * mScaleFactor) + " w " + EndOfLine.UNIX
		        
		        // Set line color to text color
		        cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " RG " + EndOfLine.UNIX
		        
		        // Draw underline from start to end of text
		        Dim textWidth As Double = GetStringWidth(displayText) * mScaleFactor
		        cmd = cmd + FormatPDF(txtX) + " " + FormatPDF(underlineY) + " m " + EndOfLine.UNIX
		        cmd = cmd + FormatPDF(txtX + textWidth) + " " + FormatPDF(underlineY) + " l S " + EndOfLine.UNIX
		      End If
		    End If

		    // Draw strikethrough if style contains "S"
		    If mFontStyle.IndexOf("S") >= 0 Then
		      If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		        Dim stFontInfo As Dictionary = mFonts.Value(mCurrentFont)

		        // Get underline thickness for line weight (reuse font metric)
		        Dim stUt As Double = 50   // Default thickness
		        If stFontInfo.HasKey("ut") Then
		          stUt = stFontInfo.Value("ut")
		        End If

		        Dim stThickness As Double = stUt * mFontSizePt / 1000.0 * mUnderlineThickness

		        // Strikethrough Y = middle of text (approximately 30% of font size above baseline)
		        Dim stOffset As Double = 0.15 * mFontSizePt
		        Dim stY As Double = txtY + (stOffset * mScaleFactor)

		        // Set line width
		        cmd = cmd + FormatPDF(stThickness * mScaleFactor) + " w " + EndOfLine.UNIX

		        // Set line color to text color
		        cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " RG " + EndOfLine.UNIX

		        // Draw strikethrough line
		        Dim stTextWidth As Double = GetStringWidth(displayText) * mScaleFactor
		        cmd = cmd + FormatPDF(txtX) + " " + FormatPDF(stY) + " m " + EndOfLine.UNIX
		        cmd = cmd + FormatPDF(txtX + stTextWidth) + " " + FormatPDF(stY) + " l S " + EndOfLine.UNIX
		      End If
		    End If

		    // Restore fill color after text only if cell has fill
		    If fill Then
		      Dim rFillPDF As Double = mFillColorR / 255.0
		      Dim gFillPDF As Double = mFillColorG / 255.0
		      Dim bFillPDF As Double = mFillColorB / 255.0
		      cmd = cmd + FormatPDF(rFillPDF, 3) + " " + FormatPDF(gFillPDF, 3) + " " + FormatPDF(bFillPDF, 3) + " rg" + EndOfLine.UNIX
		    End If
		  End If

		  mBuffer = mBuffer + cmd
		  
		  // Update current position based on ln parameter
		  If ln = 0 Then
		    // Move to the right
		    mCurrentX = mCurrentX + w
		  ElseIf ln = 1 Then
		    // Go to beginning of next line
		    mCurrentX = mLeftMargin
		    mCurrentY = mCurrentY + h
		  ElseIf ln = 2 Then
		    // Go below (same X, next line Y)
		    mCurrentY = mCurrentY + h
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F75747075747320612063656C6C207769746820656E756D2D6261736564207465787420616C69676E6D656E742E2044656C65676174657320746F2043656C6C28292E
		Sub Cell(w As Double, h As Double, txt As String, border As Variant, ln As Integer, align As VNSPDFModule.eTextAlignment, fill As Boolean = False, link As String = "", vAlign As VNSPDFModule.eVerticalAlignment = VNSPDFModule.eVerticalAlignment.Middle)
		  // Enum overload for Cell() - converts alignment enum to string and delegates
		  Call Cell(w, h, txt, border, ln, AlignmentEnumToString(align), fill, link, vAlign)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F75747075747320612063656C6C2077697468207072696E74662D7374796C6520666F726D617474656420746578742E0A
		Sub Cellf(w As Double, h As Double, format As String, ParamArray args() As Variant)
		  // Output a cell with printf-style formatted text
		  // Convenience wrapper for Cell() that formats text using SprintfHelper
		  // Supports: %s (string), %d/%i (integer), %f (float), %.Nf (float with N decimals)
		  //
		  // Parameters:
		  //   w - Cell width (0 = extend to right margin)
		  //   h - Cell height
		  //   format - printf-style format string
		  //   args - Variable arguments to format
		  //
		  // Example:
		  //   pdf.Cellf(0, 10, "Page %d of %d", currentPage, totalPages)
		  //   pdf.Cellf(0, 10, "Price: $%.2f", 19.99)
		  
		  Dim formatted As String = VNSPDFModule.SprintfHelper(format, args)
		  Call Cell(w, h, formatted)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5772617070657220666F722043656C6C28292077697468206578706C6963697420706172616D65746572732E2043616C6C732043656C6C282920696E7465726E616C6C792E0A
		Sub CellFormat(w As Double, h As Double, txt As String, border As Variant, ln As Integer, align As String, fill As Boolean, link As String)
		  // Wrapper for Cell() with explicit parameters. Calls Cell() internally.
		  // This method exists for compatibility with go-fpdf's CellFormat()
		  // Parameters are identical to Cell() - simply calls Cell()
		  
		  Call Cell(w, h, txt, border, ln, align, fill, link)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5772617070657220666F722043656C6C466F726D61742829207769746820656E756D2D6261736564207465787420616C69676E6D656E742E
		Sub CellFormat(w As Double, h As Double, txt As String, border As Variant, ln As Integer, align As VNSPDFModule.eTextAlignment, fill As Boolean, link As String)
		  // Enum overload for CellFormat() - converts alignment enum to string and delegates
		  Call CellFormat(w, h, txt, border, ln, AlignmentEnumToString(align), fill, link)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4472617773206120636972636C652063656E7465726564206174202878E280AC2C20792920776974682072616469752072202E
		Sub Circle(x As Double, y As Double, r As Double, style As String = "D")
		  // A circle is just an ellipse with equal radii
		  Call Ellipse(x, y, r, r, style)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C65617273207468652063757272656E7420657272C3B672207374617465C2B72E
		Sub ClearError()
		  // Clear the current error state
		  // Use with care - errors usually indicate unrecoverable problems
		  mError = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4472617773206120427E7A6965E280AC7220637572766520617263E280AC20666F722072C3B76F756E64656420636F726E6572732E0A
		Private Sub ClipArc(x1 As Double, y1 As Double, x2 As Double, y2 As Double, x3 As Double, y3 As Double)
		  // Draw a Bezier curve arc (used for rounded corners)
		  
		  Dim k As Double = mScaleFactor
		  Dim h As Double = mPageHeight
		  
		  Call Put(FormatPDF(x1 * k) + " " + FormatPDF((h - y1) * k) + " " + _
		  FormatPDF(x2 * k) + " " + FormatPDF((h - y2) * k) + " " + _
		  FormatPDF(x3 * k) + " " + FormatPDF((h - y3) * k) + " c")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E7320612063697263756C617220636C697070696E67206F7065726174696F6E2E0A
		Sub ClipCircle(x As Double, y As Double, r As Double, outline As Boolean)
		  // ClipCircle begins a circular clipping operation.
		  // The circle is centered at (x, y) with radius r.
		  // outline: if true, draws the outline of the clipping circle
		  // Call ClipEnd() to restore unclipped operations.
		  
		  Call ClipEllipse(x, y, r, r, outline)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E7320616E20656C6C6970746963616C20636C697070696E67206F7065726174696F6E2E0A
		Sub ClipEllipse(x As Double, y As Double, rx As Double, ry As Double, outline As Boolean)
		  // ClipEllipse begins an elliptical clipping operation.
		  // The ellipse is centered at (x, y) with radii rx and ry.
		  // outline: if true, draws the outline of the clipping ellipse
		  // Call ClipEnd() to restore unclipped operations.

		  If Err() Then Return

		  mClipNest = mClipNest + 1
		  
		  Dim lx, ly As Double
		  lx = 4.0 / 3.0 * rx * (Sqrt(2.0) - 1.0)
		  ly = 4.0 / 3.0 * ry * (Sqrt(2.0) - 1.0)
		  
		  Dim k As Double = mScaleFactor
		  Dim h As Double = mPageHeight
		  
		  Call Put("q")
		  Call Put(FormatPDF((x + rx) * k) + " " + FormatPDF((h - y) * k) + " m")
		  Call ClipArc(x + rx, y - ly, x + lx, y - ry, x, y - ry)
		  Call ClipArc(x - lx, y - ry, x - rx, y - ly, x - rx, y)
		  Call ClipArc(x - rx, y + ly, x - lx, y + ry, x, y + ry)
		  Call ClipArc(x + lx, y + ry, x + rx, y + ly, x + rx, y)
		  Call Put("W " + If(outline, "S", "n"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E647320746865206C61737420636C697070696E67206F7065726174696F6E2E0A
		Sub ClipEnd()
		  // ClipEnd restores the previous clipping context.
		  // This must be called after each Clip*() operation.

		  If Err() Then Return

		  If mClipNest > 0 Then
		    mClipNest = mClipNest - 1
		    Call Put("Q")
		  Else
		    Call SetError("Error attempting to end clip operation out of sequence")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6970732064726177696E6720746F2061207072652D6275696C74207061746820636F6D6D616E6420737472696E672E2043616C6C20436C6970456E64282920746F20726573746F72652E
		Sub ClipPath(pathCommands As String, outline As Boolean)
		  // Clips drawing to a pre-built path command string.
		  // pathCommands: PDF path operators (m, l, c, re, h)
		  // outline: if True, draws the outline of the clipping path
		  // Call ClipEnd() to restore unclipped operations.

		  If Err() Then Return

		  mClipNest = mClipNest + 1
		  Call Put("q")
		  mBuffer = mBuffer + pathCommands
		  Call Put("W " + If(outline, "S", "n"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656E646572732061207072652D6275696C74207061746820636F6D6D616E6420737472696E6720776974682074686520737065636966696564207374796C652028443D647261772C20463D66696C6C2C2044463D626F7468292E
		Sub RenderPath(pathCommands As String, style As String = "D")
		  // Renders a pre-built path command string with the specified style.
		  // pathCommands: PDF path operators (m, l, c, re, h)
		  // style: "D" = draw (stroke), "F" = fill, "DF" or "FD" = fill and stroke

		  If Err() Then Return
		  If mPage = 0 Then
		    Call SetError("Cannot render path: no page added yet.")
		    Return
		  End If

		  Dim op As String
		  Dim styleUpper As String = style.Uppercase
		  If styleUpper = "F" Then
		    op = "f"
		  ElseIf styleUpper = "FD" Or styleUpper = "DF" Then
		    op = "B"
		  Else
		    op = "S"
		  End If

		  mBuffer = mBuffer + pathCommands + op + EndOfLine.UNIX
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E73206120706F6C79676F6E20636C697070696E67206F7065726174696F6E2E
		Sub ClipPolygon(points() As Pair, outline As Boolean)
		  // ClipPolygon begins a clipping operation within a polygon.
		  // points: array of Pair objects representing (x, y) coordinates
		  // outline: if true, draws the outline of the clipping polygon
		  // Call ClipEnd() to restore unclipped operations.
		  
		  If Err() Then Return
		  If points.LastIndex < 2 Then
		    Call SetError("ClipPolygon requires at least 3 points")
		    Return
		  End If
		  
		  mClipNest = mClipNest + 1
		  
		  Dim k As Double = mScaleFactor
		  Dim h As Double = mPageHeight
		  
		  Call Put("q")
		  
		  // Move to first point
		  Dim pt As Pair = points(0)
		  Call Put(FormatPDF(pt.Left * k) + " " + FormatPDF((h - pt.Right) * k) + " m")
		  
		  // Draw lines to subsequent points
		  For i As Integer = 1 To points.LastIndex
		    pt = points(i)
		    Call Put(FormatPDF(pt.Left * k) + " " + FormatPDF((h - pt.Right) * k) + " l")
		  Next
		  
		  // Close path and set clipping
		  Call Put("h W " + If(outline, "S", "n"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E7320612072656374616E67756C617220636C697070696E67206F7065726174696F6E2E
		Sub ClipRect(x As Double, y As Double, w As Double, h As Double, outline As Boolean)
		  // ClipRect begins a rectangular clipping operation.
		  // The rectangle is of width w and height h. Its upper left corner is positioned at point (x, y).
		  // outline: if true, draws the outline of the clipping rectangle
		  // Call ClipEnd() to restore unclipped operations.
		  
		  mClipNest = mClipNest + 1
		  Call Put("q " + FormatPDF(x * mScaleFactor) + " " + FormatPDF((mPageHeight - y) * mScaleFactor) + " " + FormatPDF(w * mScaleFactor) + " " + FormatPDF(-h * mScaleFactor) + " re W " + If(outline, "S", "n"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E73206120726F756E6465642072656374616E67756C617220636C697070696E67206F7065726174696F6E2E0A
		Sub ClipRoundedRect(x As Double, y As Double, w As Double, h As Double, r As Double, corners As String, outline As Boolean)
		  // ClipRoundedRect begins a rounded rectangular clipping operation.
		  // The rectangle is of width w and height h. Its upper left corner is positioned at point (x, y).
		  // r: corner radius
		  // corners: string specifying which corners to round ("1234" where 1=TL, 2=TR, 3=BR, 4=BL)
		  // outline: if true, draws the outline of the clipping rectangle
		  // Call ClipEnd() to restore unclipped operations.
		  
		  If Err() Then Return
		  
		  mClipNest = mClipNest + 1
		  
		  Dim myArc As Double = 4.0 / 3.0 * (Sqrt(2.0) - 1.0)
		  Call Put("q")
		  
		  // Build rounded rectangle path
		  Call Put(FormatPDF((x + r) * mScaleFactor) + " " + FormatPDF((mPageHeight - y) * mScaleFactor) + " m")
		  
		  Dim xc, yc As Double
		  xc = x + w - r
		  yc = y + r
		  Call Put(FormatPDF(xc * mScaleFactor) + " " + FormatPDF((mPageHeight - y) * mScaleFactor) + " l")
		  
		  If corners.IndexOf("2") >= 0 Then
		    Call ClipArc(xc + r * myArc, yc - r, xc + r, yc - r * myArc, xc + r, yc)
		  Else
		    Call Put(FormatPDF((x + w) * mScaleFactor) + " " + FormatPDF((mPageHeight - y) * mScaleFactor) + " l")
		  End If
		  
		  xc = x + w - r
		  yc = y + h - r
		  Call Put(FormatPDF((x + w) * mScaleFactor) + " " + FormatPDF((mPageHeight - yc) * mScaleFactor) + " l")
		  
		  If corners.IndexOf("3") >= 0 Then
		    Call ClipArc(xc + r, yc + r * myArc, xc + r * myArc, yc + r, xc, yc + r)
		  Else
		    Call Put(FormatPDF((x + w) * mScaleFactor) + " " + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " l")
		  End If
		  
		  xc = x + r
		  yc = y + h - r
		  Call Put(FormatPDF(xc * mScaleFactor) + " " + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " l")
		  
		  If corners.IndexOf("4") >= 0 Then
		    Call ClipArc(xc - r * myArc, yc + r, xc - r, yc + r * myArc, xc - r, yc)
		  Else
		    Call Put(FormatPDF(x * mScaleFactor) + " " + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " l")
		  End If
		  
		  xc = x + r
		  yc = y + r
		  Call Put(FormatPDF(x * mScaleFactor) + " " + FormatPDF((mPageHeight - yc) * mScaleFactor) + " l")
		  
		  If corners.IndexOf("1") >= 0 Then
		    Call ClipArc(xc - r, yc - r * myArc, xc - r * myArc, yc - r, xc, yc - r)
		  Else
		    Call Put(FormatPDF(x * mScaleFactor) + " " + FormatPDF((mPageHeight - y) * mScaleFactor) + " l")
		  End If
		  
		  Call Put("W " + If(outline, "S", "n"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E73206120726F756E6465642072656374616E67756C617220636C697070696E67206F7065726174696F6E207769746820646966666572656E7420726164696920666F72206561636820636F726E65722E0A
		Sub ClipRoundedRectExt(x As Double, y As Double, w As Double, h As Double, rTL As Double, rTR As Double, rBR As Double, rBL As Double, outline As Boolean)
		  // ClipRoundedRectExt begins a rounded rectangular clipping operation with different radius for each corner.
		  // The rectangle is of width w and height h. Its upper left corner is positioned at point (x, y).
		  // rTL, rTR, rBR, rBL: Radius for each corner (TL=top-left, TR=top-right, BR=bottom-right, BL=bottom-left)
		  // outline: if true, draws the outline of the clipping rectangle
		  // Call ClipEnd() to restore unclipped operations.
		  
		  If Err() Then Return
		  
		  mClipNest = mClipNest + 1
		  
		  // Build rounded rectangle path using shared helper
		  Call RoundedRectPath(x, y, w, h, rTL, rTR, rBR, rBL)
		  
		  // Apply clipping operation
		  Call Put("W " + If(outline, "S", "n"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E73206120636C697070696E67206F7065726174696F6E20636F6E73747261696E6564206279206120706174682E0A
		Sub ClipText(x As Double, y As Double, txt As String, outline As Boolean)
		  // ClipText begins a clipping operation in which rendering is confined to the character cell outlines of text.
		  // x, y: position where the text should be placed
		  // txt: the text to use for clipping
		  // outline: if true, draws the outline of the text
		  // Call ClipEnd() to restore unclipped operations.
		  
		  If Err() Then Return
		  
		  mClipNest = mClipNest + 1
		  
		  Call Put("q BT " + FormatPDF(x * mScaleFactor) + " " + FormatPDF((mPageHeight - y) * mScaleFactor) + " Td 7 Tr " + EscapeText(txt) + " Tj ET")
		  If outline Then
		    Call Put("0 Tr")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 56616C69646174657320636C69702F7472616E73666F726D206E657374696E6720616E6420636C6F7365732074680A
		Sub Close()
		  // Validates clip/transform nesting and closes the document.
		  // This is called automatically by Output() and SaveToFile().
		  
		  If Err() Then Return
		  
		  // Validate clip nesting
		  If mClipNest > 0 Then
		    Call SetError("Clip procedure must be explicitly ended")
		    Return
		  End If
		  
		  // If already closed, nothing to do
		  If mState = 3 Then Return
		  
		  // If no pages exist, add one
		  If mPages.KeyCount = 0 Then
		    AddPage(mDefOrientation)
		    If Err() Then Return
		  End If
		  
		  // Close page - state will be set to 3 by Output()
		  mState = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 46696E616C697A65732074686520504446206F75747075742062792077726974696E6720616C6C206F626A6563747320616E642063726F73732D7265666572656E6365207461626C652E0A
		Private Sub CloseDocument()
		  // Call footer callback for the last page before saving
		  If mPage > 0 Then
		    If mHasFooterFuncLpi And Not mInHeaderFooter Then
		      // Call Lpi footer with lastPage = True
		      mInHeaderFooter = True
		      mFooterFuncLpi.Invoke(Self, True)
		      mInHeaderFooter = False
		    ElseIf mHasFooterFunc Then
		      CallFooter()
		    End If
		  End If
		  
		  // Save current page buffer if exists
		  If mPage > 0 And mBuffer <> "" Then
		    mPages.Value(Str(mPage)) = mBuffer
		  End If
		  
		  // Build complete PDF structure
		  mBuffer = ""
		  mOffsets = New Dictionary
		  mObjectNumber = 1
		  
		  // PDF header
		  Call PutHeader()
		  
		  // Allocate object numbers for fonts BEFORE outputting pages
		  Call AllocateFontObjects()
		  
		  // CRITICAL: Generate encryption keys BEFORE outputting pages
		  // (Keys must exist before content streams are encrypted)
		  If mEncryption <> Nil Then
		    #If TargetiOS Or TargetAndroid Then
		      mFileID = Crypto.MD5(Str(System.Ticks) + mTitle + mAuthor)
		    #Else
		      mFileID = Crypto.MD5(Str(System.Microseconds) + mTitle + mAuthor)
		    #EndIf
		    mFileID = mFileID.DefineEncoding(Encodings.ASCII)
		    Call mEncryption.GenerateKeys(mFileID)
		  End If

		  // Replace aliases in page content BEFORE outputting pages
		  // If aliasNbPagesStr is set, register it with the page count
		  If mAliasNbPagesStr <> "" Then
		    Call RegisterAlias(mAliasNbPagesStr, Str(mPage))
		  End If
		  Call ReplaceAliases()

		  // Calculate attachment object offset for internal link calculations
		  mAttachmentObjectOffset = GetAttachmentObjectCount()

		  // Generate PDF objects in order: Attachments, Form Fields, Pages
		  // Objects 1 and 2 are reserved for Pages root and Resources
		  mObjectNumber = 3  // Start after reserved objects

		  // Embedded file attachments (must be before PutPages for annotation references)
		  Call PutAttachments()
		  Call PutAnnotationsAttachments()

		  // PDF Forms (AcroForms) - MUST generate BEFORE PutPages so widgets can be added to /Annots
		  #If hasPremiumVNSFormsModule Then
		    If mHasAcroForm Then
		      // Generate form field objects and track their references
		      Dim fieldRefs() As String = VNSPDFFormsPremium.PutFormFields(Self)
		      If fieldRefs.Count > 0 Then
		        // Store field refs for later AcroForm dictionary generation
		        mFormFieldRefs = fieldRefs
		      End If
		    End If
		  #EndIf

		  // Pages object (outputs object 1 = Pages root, and page objects)
		  // Pages reference "/Resources 2 0 R" (forward reference)
		  // mObjectNumber continues from where form fields left off
		  Call PutPages()

		  // Resources (outputs fonts, images, then object 2 = Resources dictionary)
		  Call PutResources()
		  
		  // Document info dictionary
		  Call PutInfo()
		  
		  // Output intent streams (ICC profiles for PDF/A compliance)
		  // MUST be called BEFORE PutCatalog
		  Call PutOutputIntentStreams()

		  // Process pending TOC entries (deferred bookmark creation, Xojo-compatible)
		  Call ProcessPendingTOCEntries()

		  // Bookmarks/Outlines (if any)
		  Call PutBookmarks()
		  
		  // Encryption dictionary (if encryption is enabled)
		  Call PutEncryption()
		  
		  // XMP metadata (if set)
		  Call PutXmpMetadata()

		  // PDF Forms (AcroForms) - generate AcroForm dictionary
		  #If hasPremiumVNSFormsModule Then
		    If mHasAcroForm And mFormFieldRefs.Count > 0 Then
		      // Form field objects were already generated before PutPages
		      // Now create the AcroForm dictionary referencing those fields
		      mAcroFormObjectNumber = VNSPDFFormsPremium.PutAcroForm(Self, mFormFieldRefs)
		    End If
		  #EndIf

		  // Catalog (document root)
		  Call PutCatalog()
		  
		  // Cross-reference table
		  Call PutXref()
		  
		  // Trailer
		  Call PutTrailer()
		  
		  // Mark document as closed
		  mState = 3
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CodePointsToUTF8(codePoints() As Integer) As String
		  // Convert array of Unicode code points back to UTF-8 string
		  // This is the inverse of UTF8ToCodePoints()
		  // Returns: UTF-8 encoded string
		  
		  Dim mb As New MemoryBlock(codePoints.Count * 4)  // Max 4 bytes per code point
		  Dim pos As Integer = 0
		  
		  For i As Integer = 0 To codePoints.LastIndex
		    Dim cp As Integer = codePoints(i)
		    
		    If cp < &h80 Then
		      // 1-byte sequence (0xxxxxxx)
		      mb.UInt8Value(pos) = cp
		      pos = pos + 1
		    ElseIf cp < &h800 Then
		      // 2-byte sequence (110xxxxx 10xxxxxx)
		      Dim byte1 As Integer = &hC0 Or Bitwise.ShiftRight(cp, 6)
		      Dim byte2 As Integer = &h80 Or (cp And &h3F)
		      mb.UInt8Value(pos) = byte1
		      mb.UInt8Value(pos + 1) = byte2
		      pos = pos + 2
		    ElseIf cp < &h10000 Then
		      // 3-byte sequence (1110xxxx 10xxxxxx 10xxxxxx)
		      Dim byte1 As Integer = &hE0 Or Bitwise.ShiftRight(cp, 12)
		      Dim shifted As Integer = Bitwise.ShiftRight(cp, 6)
		      Dim byte2 As Integer = &h80 Or (shifted And &h3F)
		      Dim byte3 As Integer = &h80 Or (cp And &h3F)
		      mb.UInt8Value(pos) = byte1
		      mb.UInt8Value(pos + 1) = byte2
		      mb.UInt8Value(pos + 2) = byte3
		      pos = pos + 3
		    Else
		      // 4-byte sequence (11110xxx 10xxxxxx 10xxxxxx 10xxxxxx)
		      Dim byte1 As Integer = &hF0 Or Bitwise.ShiftRight(cp, 18)
		      Dim shifted12 As Integer = Bitwise.ShiftRight(cp, 12)
		      Dim byte2 As Integer = &h80 Or (shifted12 And &h3F)
		      Dim shifted6 As Integer = Bitwise.ShiftRight(cp, 6)
		      Dim byte3 As Integer = &h80 Or (shifted6 And &h3F)
		      Dim byte4 As Integer = &h80 Or (cp And &h3F)
		      mb.UInt8Value(pos) = byte1
		      mb.UInt8Value(pos + 1) = byte2
		      mb.UInt8Value(pos + 2) = byte3
		      mb.UInt8Value(pos + 3) = byte4
		      pos = pos + 4
		    End If
		  Next
		  
		  Return mb.StringValue(0, pos)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44656661756C7420636F6E7374727563746F723A20506F7274726169742C204D696C6C696D65746572732C2041342E
		Sub Constructor()
		  // Default constructor: Portrait, Millimeters, A4
		  Constructor(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.A4)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E697469616C697A65732074686520504446206765706572617469696F6E20656E67696E6520776974682073706563696669656420756E69742C206F7269656E746174696F6E2C20616E642070616765206C61796F75742E0A
		Sub Constructor(orientation As VNSPDFModule.ePageOrientation, unit As VNSPDFModule.ePageUnit, pageFormat As VNSPDFModule.ePageFormat)
		  // Initialize state
		  mState = 0
		  mPage = 0
		  mObjectNumber = 3 // Start from 3 (objects 1-2 reserved for Pages root and Resources)
		  mBuffer = ""
		  mError = ""
		  
		  // Initialize collections
		  mPages = New Dictionary
		  mFonts = New Dictionary
		  mImages = New Dictionary
		  mImageIndex = New Dictionary
		  mPageSizes = New Dictionary
		  mPageLinks = New Dictionary
		  mPageAttachments = New Dictionary
		  mPageTextAnnotations = New Dictionary
		  mPageFormAnnotations = New Dictionary
		  mPageBoxes = New Dictionary
		  mDefPageBoxes = New Dictionary
		  mAliases = New Dictionary
		  mImportedPages = New Dictionary
		  mXObjects = New Dictionary
		  mXObjectObjNums = New Dictionary
		  
		  // Initialize empty gradient list
		  ReDim mGradientList(-1)
		  
		  // Initialize alias for page count (empty = not set)
		  mAliasNbPagesStr = ""
		  
		  // Store unit and calculate scale factor
		  mUnit = unit
		  Select Case mUnit
		  Case VNSPDFModule.ePageUnit.Points
		    mScaleFactor = 1.0
		  Case VNSPDFModule.ePageUnit.Millimeters
		    mScaleFactor = 72.0 / 25.4
		  Case VNSPDFModule.ePageUnit.Centimeters
		    mScaleFactor = 72.0 / 2.54
		  Case VNSPDFModule.ePageUnit.Inches
		    mScaleFactor = 72.0
		  Else
		    mScaleFactor = 72.0 / 25.4 // Default to millimeters
		  End Select
		  
		  // Store default orientation
		  mDefOrientation = orientation
		  mCurOrientation = orientation
		  
		  // Get page format dimensions (in points)
		  Dim pageDimensions As Pair = VNSPDFModule.GetPageFormatDimensions(pageFormat)
		  mDefPageSize = pageDimensions
		  mCurPageSize = pageDimensions
		  
		  // Calculate initial page dimensions in user units
		  If mCurOrientation = VNSPDFModule.ePageOrientation.Portrait Then
		    mPageWidth = mDefPageSize.Left / mScaleFactor
		    mPageHeight = mDefPageSize.Right / mScaleFactor
		    mPageWidthPt = mDefPageSize.Left
		    mPageHeightPt = mDefPageSize.Right
		  Else
		    mPageWidth = mDefPageSize.Right / mScaleFactor
		    mPageHeight = mDefPageSize.Left / mScaleFactor
		    mPageWidthPt = mDefPageSize.Right
		    mPageHeightPt = mDefPageSize.Left
		  End If
		  
		  // Set default margins (10mm or equivalent)
		  Dim defaultMargin As Double = 10.0 / 25.4 * 72.0 / mScaleFactor
		  mLeftMargin = defaultMargin
		  mTopMargin = defaultMargin
		  mRightMargin = defaultMargin
		  mBottomMargin = defaultMargin
		  
		  // Set initial position
		  mCurrentX = mLeftMargin
		  mCurrentY = mTopMargin
		  
		  // Cell margin (0.5mm or equivalent)
		  mCellMargin = 0.5 / 25.4 * 72.0 / mScaleFactor
		  
		  // Default line width (0.2mm or equivalent)
		  mLineWidth = 0.2 / 25.4 * 72.0 / mScaleFactor
		  
		  // Default line styles
		  mLineCapStyle = 0   // 0 = butt (default)
		  mLineJoinStyle = 0  // 0 = miter (default)
		  mDashPhase = 0.0    // No phase offset
		  ReDim mDashArray(-1) // Empty array = solid line
		  
		  // Auto page break enabled by default with 2cm margin
		  mAutoPageBreak = True
		  mPageBreakTrigger = mPageHeight - (20.0 / 25.4 * 72.0 / mScaleFactor)
		  
		  // Compression on by default (using VNSZlibModule)
		  mCompression = True
		  
		  // PDF version
		  mPDFVersion = "1.7"
		  
		  // Document metadata - set default producer
		  mProducer = "VNS PDF Library (Xojo)"
		  mTitle = ""
		  mAuthor = ""
		  mSubject = ""
		  mKeywords = ""
		  mCreator = ""
		  mLang = ""
		  
		  // Initialize font properties
		  mFontFamily = ""
		  mFontStyle = ""
		  mFontSize = 12.0 // Default 12pt
		  mFontSizePt = 12.0
		  mCurrentFont = ""
		  mFontNumber = 0 // Counter for font references (F1, F2, F3, etc.)
		  
		  // Alpha/transparency support
		  mAlpha = 1.0
		  mBlendMode = "Normal"
		  mBlendMap = New Dictionary
		  ReDim mBlendList(-1) // Start empty
		  // Add unused placeholder at index 0 (1-based indexing)
		  Dim placeholder As New VNSPDFBlendMode
		  mBlendList.Add(placeholder)
		  
		  // Document is now initialized
		  mState = 1

		  // Automatically add first page (Xojo PDFDocument compatibility)
		  // Skip for Custom format - caller will use AddPageFormat with specific dimensions
		  If pageFormat <> VNSPDFModule.ePageFormat.Custom Then
		    AddPage(mDefOrientation)
		  End If

		End Sub
	#tag EndMethod

#tag Method, Flags = &h0, Description = 436F6E7374727563746F722077697468207061676520666F726D61742028586F6A6F20504446446F63756D656E742E5061676553697A657320636F6D7061746962696C697479292E0A
	Sub Constructor(pageFormat As VNSPDFModule.ePageFormat)
	  // Constructor with page format (Xojo PDFDocument.PageSizes compatibility).
	  // Creates a portrait document in millimeters with the specified page format.
	  //
	  // Parameters:
	  //   pageFormat - Page format (A3, A4, A5, Letter, Legal, Custom)
	  //
	  // Example:
	  //   Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageFormat.A4)

	  Constructor(VNSPDFModule.ePageOrientation.Portrait, _
	              VNSPDFModule.ePageUnit.Millimeters, _
	              pageFormat)
	End Sub
#tag EndMethod

#tag Method, Flags = &h0, Description = 436F6E7374727563746F72207769746820637573746F6D20706167652064696D656E73696F6E73202877696474682C2068656967687420696E20706F696E7473292E0A
	Sub Constructor(width As Double, height As Double)
	  // Constructor with custom page dimensions (width, height in points).
	  // Creates a portrait document with custom page size.
	  //
	  // Parameters:
	  //   width - Page width in points (1 point = 1/72 inch)
	  //   height - Page height in points
	  //
	  // Example:
	  //   Dim pdf As New VNSPDFDocument(612.0, 792.0)  // US Letter in points

	  // Initialize with Custom format
	  Constructor(VNSPDFModule.ePageOrientation.Portrait, _
	              VNSPDFModule.ePageUnit.Points, _
	              VNSPDFModule.ePageFormat.Custom)

	  // Add first page with custom dimensions
	  AddPageFormat("P", width, height)
	End Sub
#tag EndMethod

#tag Method, Flags = &h0, Description = 436F6E7374727563746F722066726F6D204A534F4E2074656D706C6174652028586F6A6F20504446446F63756D656E742E54656D706C61746520636F6D7061746962696C697479292E0A
	Sub Constructor(json As JSONItem)
	  // Constructor from JSON template (Xojo PDFDocument.Template compatibility).
	  // Creates a document from a JSON template previously exported with Template().
	  //
	  // Parameters:
	  //   json - JSONItem containing document configuration
	  //
	  // Example:
	  //   Dim template As JSONItem = existingPDF.Template()
	  //   Dim newPDF As New VNSPDFDocument(template)

	  // Call default constructor first
	  Constructor()

	  // Restore state from JSON
	  FromJSON(json.ToString)
	End Sub
#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E7374727563746F722066726F6D20616E206578697374696E672050444620666F6C646572206974656D2E20496D706F72747320616C6C20706167657320617320746D706C617465732E
		Sub Constructor(sourcePDF As FolderItem)
		  // Constructor from an existing PDF file.
		  // Imports all pages as full-size templates, preserving original page dimensions.
		  //
		  // Parameters:
		  //   sourcePDF - FolderItem pointing to an existing PDF file
		  //
		  // Example:
		  //   Dim f As FolderItem = FolderItem.ShowOpenFileDialog("application/pdf")
		  //   Dim doc As New VNSPDFDocument(f)
		  //   // doc now contains all pages from the source PDF

		  // Initialize with Custom format (no auto-added first page)
		  Constructor(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.Custom)

		  If sourcePDF = Nil Or Not sourcePDF.Exists Then
		    SetError("Source PDF file not found.")
		    Return
		  End If

		  Dim srcPageCount As Integer = SetSourceFile(sourcePDF.NativePath)
		  If srcPageCount = 0 Or Err() Then
		    Return
		  End If

		  For i As Integer = 1 To srcPageCount
		    Dim templateID As Integer = ImportPage(i)
		    If Err() Then
		      ClearError
		      Continue
		    End If

		    // Get source page dimensions and add page with matching size
		    Dim srcW As Double = 0
		    Dim srcH As Double = 0
		    If GetImportedPageSize(templateID, srcW, srcH) Then
		      AddPageFormat("P", srcW, srcH)
		    Else
		      AddPage()
		    End If

		    UseTemplate(templateID, 0, 0, 0, 0)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E7374727563746F722066726F6D206578697374696E672050444620646174612028537472696E67292E20496D706F72747320616C6C207061676573
		Sub Constructor(pdfData As String, isPDFData As Boolean)
		  // Constructor from existing PDF data in memory.
		  // Imports all pages as full-size templates, preserving original page dimensions.
		  // The isPDFData parameter disambiguates from Constructor(json As String).
		  //
		  // Parameters:
		  //   pdfData - Raw PDF file contents as String
		  //   isPDFData - Must be True (disambiguator)
		  //
		  // Example:
		  //   Dim data As String = myBinaryStream.Read(myBinaryStream.Length)
		  //   Dim doc As New VNSPDFDocument(data, True)

		  #Pragma Unused isPDFData

		  // Initialize with Custom format (no auto-added first page)
		  Constructor(VNSPDFModule.ePageOrientation.Portrait, VNSPDFModule.ePageUnit.Millimeters, VNSPDFModule.ePageFormat.Custom)

		  If pdfData.Length = 0 Then
		    SetError("Empty PDF data.")
		    Return
		  End If

		  // Write to temp file — SetSourceFile requires a file path
		  Dim tempFolder As FolderItem = SpecialFolder.Temporary
		  If tempFolder = Nil Then
		    SetError("Cannot access temporary folder.")
		    Return
		  End If
		  #If TargetiOS Or TargetAndroid Then
		    Dim tempFile As FolderItem = tempFolder.Child("vnspdf_import_" + Str(System.Ticks) + ".pdf")
		  #Else
		    Dim tempFile As FolderItem = tempFolder.Child("vnspdf_import_" + Str(System.Microseconds) + ".pdf")
		  #EndIf

		  Dim bs As BinaryStream = BinaryStream.Create(tempFile, True)
		  If bs = Nil Then
		    SetError("Cannot create temporary file for PDF import.")
		    Return
		  End If
		  bs.Write(pdfData)
		  bs.Close

		  Dim srcPageCount As Integer = SetSourceFile(tempFile.NativePath)

		  If srcPageCount = 0 Or Err() Then
		    If tempFile.Exists Then tempFile.Remove
		    Return
		  End If

		  // Keep temp file alive — mSourceReader needs it until Output()/ToData()
		  mSourceTempFile = tempFile

		  For i As Integer = 1 To srcPageCount
		    Dim templateID As Integer = ImportPage(i)
		    If Err() Then
		      ClearError
		      Continue
		    End If

		    Dim srcW As Double = 0
		    Dim srcH As Double = 0
		    If GetImportedPageSize(templateID, srcW, srcH) Then
		      AddPageFormat("P", srcW, srcH)
		    Else
		      AddPage()
		    End If

		    UseTemplate(templateID, 0, 0, 0, 0)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  // Clean up temp file used for PDF import
		  If mSourceTempFile <> Nil And mSourceTempFile.Exists Then
		    mSourceTempFile.Remove
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CopyObjectFromSource(sourceObjNum As Integer) As Integer
		  // Copy an object from source PDF and prepare it for output
		  // Objects are stored and written during Output() in PutImportedObjects()
		  // sourceObjNum: Object number in source PDF
		  // Returns: New object number in output PDF (placeholder), or 0 on error
		  
		  // Initialize dictionaries if needed
		  If mImportedObjectMap = Nil Then
		    mImportedObjectMap = New Dictionary
		  End If
		  If mImportedObjects = Nil Then
		    mImportedObjects = New Dictionary
		  End If
		  
		  // Check if object already copied
		  Dim key As String = Str(sourceObjNum)
		  If mImportedObjectMap.HasKey(key) Then
		    Return mImportedObjectMap.Value(key)
		  End If

		  // Get object from source PDF
		  If mSourceReader = Nil Then
		    SetError("CopyObjectFromSource: mSourceReader is Nil")
		    Return 0
		  End If

		  Dim sourceObj As VNSPDFType = mSourceReader.GetObject(sourceObjNum)
		  If sourceObj = Nil Then
		    SetError("CopyObjectFromSource: Could not get source object " + Str(sourceObjNum))
		    Return 0
		  End If
		  
		  // System.DebugLog("CopyObjectFromSource: Got source object of type " + Introspection.GetType(sourceObj).Name)
		  
		  // Assign placeholder object number (will be finalized during Output())
		  // Use negative numbers to avoid conflicts with real object numbers
		  Dim placeholderNum As Integer = -(mImportedObjects.KeyCount + 1)
		  
		  // System.DebugLog("CopyObjectFromSource: Assigned placeholder " + Str(placeholderNum) + " for source obj " + Str(sourceObjNum))
		  
		  // Store mapping BEFORE serializing (to handle circular references)
		  mImportedObjectMap.Value(key) = placeholderNum
		  
		  // CRITICAL: Reserve the slot in mImportedObjects BEFORE serializing
		  // This ensures nested calls to CopyObjectFromSource get unique placeholders
		  // (because mImportedObjects.KeyCount will have increased)
		  mImportedObjects.Value(Str(placeholderNum)) = ""  // Placeholder, will be replaced
		  
		  // Serialize the object with recursive remapping
		  Dim objContent As String = SerializeObjectForCopy(sourceObj)
		  
		  // Store object content for later output
		  mImportedObjects.Value(Str(placeholderNum)) = objContent
		  
		  Return placeholderNum
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 43726561746573206120466F726D20584F626A6563742066726F6D20616E20696D706F7274656420706167652E0A
		Private Function CreateXObjectFromPage(importedPage As VNSPDFImportedPage, templateID As Integer) As String
		  // Creates a Form XObject from an imported page
		  // Returns: XObject name (e.g., "TPL1"), or empty string on error
		  
		  // Generate XObject name
		  Dim xobjName As String = "TPL" + Str(templateID)
		  
		  // Check if XObject already exists
		  If mXObjects <> Nil And mXObjects.HasKey(xobjName) Then
		    Return xobjName
		  End If
		  
		  // Get DECODED content stream (decompressed)
		  // This avoids LZWDecode issues - we'll re-compress with FlateDecode if available
		  // Some pages may have empty content (blank pages, form-only pages) — not an error
		  Dim decodedContent As String = importedPage.GetDecodedContents(mSourceReader)

		  // Check if decompression failed (e.g., ZLIB1.DLL missing on Windows)
		  If decodedContent = "" And importedPage.contents <> Nil Then
		    Dim streamError As String = importedPage.GetLastStreamError()
		    If streamError <> "" Then
		      Call SetError("PDF import: " + streamError)
		      Return ""
		    End If
		  End If
		  
		  // TEMP FIX: Disable compression for imported content
		  // Our pure Xojo deflate compression may not be fully compatible with Adobe Reader
		  // Store imported content uncompressed to avoid corruption
		  Dim streamData As String = decodedContent
		  Dim useFilter As String = ""
		  
		  // // Attempt compression (works on all platforms with premium zlib module)
		  // Dim compressed As String = VNSZlibModule.Compress(decodedContent)
		  // If compressed <> "" Then
		  //   // Add filter when compression is available (premium zlib works on all platforms)
		  //   #If TargetiOS Or TargetAndroid Then
		  //     If hasPremiumVNSZlibModule Then
		  //       useFilter = "FlateDecode"
		  //       streamData = compressed
		  //     End If
		  //   #Else
		  //     useFilter = "FlateDecode"
		  //     streamData = compressed
		  //   #EndIf
		  // End If
		  
		  // Create Form XObject dictionary
		  Dim xobjDict As String = "<< /Type /XObject" + EndOfLine
		  xobjDict = xobjDict + "   /Subtype /Form" + EndOfLine
		  xobjDict = xobjDict + "   /FormType 1" + EndOfLine
		  xobjDict = xobjDict + "   /BBox [0 0 " + FormatPDF(importedPage.width) + " " + FormatPDF(importedPage.height) + "]" + EndOfLine
		  
		  // Add Group dictionary if the imported page has one (for transparency blending)
		  If importedPage.pageDict <> Nil Then
		    Dim pageDict As Dictionary = importedPage.pageDict.value
		    If pageDict.HasKey("Group") Then
		      Dim groupObj As VNSPDFType = pageDict.Value("Group")
		      Dim groupStr As String = SerializeType(groupObj)
		      xobjDict = xobjDict + "   /Group " + groupStr + EndOfLine
		    End If
		  End If
		  
		  // Add Resources if the imported page has them
		  If importedPage.resources <> Nil Then
		    Dim resourcesStr As String = SerializeResources(importedPage.resources)
		    If resourcesStr <> "" Then
		      xobjDict = xobjDict + "   /Resources " + resourcesStr + EndOfLine
		    End If
		  End If
		  
		  // Add Filter if stream is compressed
		  If useFilter <> "" Then
		    xobjDict = xobjDict + "   /Filter /" + useFilter + EndOfLine
		  End If
		  
		  // Add stream length (streamData already set above)
		  xobjDict = xobjDict + "   /Length " + Str(streamData.Length) + EndOfLine
		  xobjDict = xobjDict + ">>" + EndOfLine
		  
		  // Build complete XObject
		  Dim xobjContent As String = xobjDict
		  xobjContent = xobjContent + "stream" + EndOfLine
		  xobjContent = xobjContent + streamData + EndOfLine
		  xobjContent = xobjContent + "endstream" + EndOfLine
		  
		  // Add XObject to document
		  Call AddXObject(xobjName, xobjContent)
		  
		  Return xobjName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44726177732061207175616472617469632042657A6965722063757276652077697468206F6E6520636F6E74726F6C20706F696E742E0A
		Sub Curve(x0 As Double, y0 As Double, cx As Double, cy As Double, x1 As Double, y1 As Double, style As String = "D")
		  // Draws a quadratic Bézier curve
		  // (x0, y0): Starting point
		  // (cx, cy): Control point
		  // (x1, y1): Ending point
		  // style: "D" (draw), "F" (fill), or "FD"/"DF" (both)
		  
		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If
		  
		  // Move to starting point
		  Call PointTo(x0, y0)
		  
		  // Transform control point and end point to PDF coordinates
		  Dim cxK As Double = cx * mScaleFactor
		  Dim cyK As Double = (mPageHeight - cy) * mScaleFactor
		  Dim x1K As Double = x1 * mScaleFactor
		  Dim y1K As Double = (mPageHeight - y1) * mScaleFactor
		  
		  // Output quadratic Bézier curve command (v operator)
		  Const prec As Integer = 5
		  Dim cmd As String = FormatPDF(cxK, prec) + " " + _
		  FormatPDF(cyK, prec) + " " + _
		  FormatPDF(x1K, prec) + " " + _
		  FormatPDF(y1K, prec) + " v " + _
		  FillDrawOp(style) + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		  
		  // Update current position
		  mCurrentX = x1
		  mCurrentY = y1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612063756269632042657A69657220637572766520776974682074776F20636F6E74726F6C20706F696E74732E0A
		Sub CurveBezierCubic(x0 As Double, y0 As Double, cx0 As Double, cy0 As Double, cx1 As Double, cy1 As Double, x1 As Double, y1 As Double, style As String = "D")
		  // Draws a cubic Bézier curve
		  // (x0, y0): Starting point
		  // (cx0, cy0): First control point
		  // (cx1, cy1): Second control point
		  // (x1, y1): Ending point
		  // style: "D" (draw), "F" (fill), or "FD"/"DF" (both)
		  //
		  // The curve starts at (x0, y0) and ends at (x1, y1).
		  // At the start point, the curve is tangent to the line from (x0, y0) to (cx0, cy0).
		  // At the end point, the curve is tangent to the line from (cx1, cy1) to (x1, y1).
		  
		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If
		  
		  // Move to starting point
		  Call PointTo(x0, y0)
		  
		  // Transform control points and end point to PDF coordinates
		  Dim cx0K As Double = cx0 * mScaleFactor
		  Dim cy0K As Double = (mPageHeight - cy0) * mScaleFactor
		  Dim cx1K As Double = cx1 * mScaleFactor
		  Dim cy1K As Double = (mPageHeight - cy1) * mScaleFactor
		  Dim x1K As Double = x1 * mScaleFactor
		  Dim y1K As Double = (mPageHeight - y1) * mScaleFactor
		  
		  // Output cubic Bézier curve command (c operator)
		  Const prec As Integer = 5
		  Dim cmd As String = FormatPDF(cx0K, prec) + " " + _
		  FormatPDF(cy0K, prec) + " " + _
		  FormatPDF(cx1K, prec) + " " + _
		  FormatPDF(cy1K, prec) + " " + _
		  FormatPDF(x1K, prec) + " " + _
		  FormatPDF(y1K, prec) + " c " + _
		  FillDrawOp(style) + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		  
		  // Update current position
		  mCurrentX = x1
		  mCurrentY = y1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4C6567616379207772617070657220666F7220437572766542657A696572437562696328292077697468206E6F6E7374616E6461726420636F6E74726F6C20706F696E74206F726465722E2055736520437572766542657A6965724375626963282920696E73746561642E0A
		Sub CurveCubic(x0 As Double, y0 As Double, cx0 As Double, cy0 As Double, x1 As Double, y1 As Double, cx1 As Double, cy1 As Double, style As String = "D")
		  // Legacy wrapper for CurveBezierCubic() with nonstandard control point order.
		  // Use CurveBezierCubic() instead.
		  //
		  // This method exists for backward compatibility with go-fpdf's CurveCubic()
		  // which has a nonstandard parameter order (end point before second control point).
		  //
		  // Parameter mapping:
		  //   CurveCubic(x0, y0, cx0, cy0, x1, y1, cx1, cy1, style)
		  //   -> CurveBezierCubic(x0, y0, cx0, cy0, cx1, cy1, x1, y1, style)
		  
		  Call CurveBezierCubic(x0, y0, cx0, cy0, cx1, cy1, x1, y1, style)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4F757470757473206120504446206375626963204265E280AC7A69657220637572766520636F6D6D616E642028632920666F72206472617720696E672063757276656420706174682073656720656D656E74732E0A
		Private Sub CurveTo(cx0 As Double, cy0 As Double, cx1 As Double, cy1 As Double, x As Double, y As Double)
		  // Outputs a PDF cubic Bezier curve command (c)
		  // cx0, cy0: First control point
		  // cx1, cy1: Second control point
		  // x, y: End point
		  
		  Const prec As Integer = 5
		  
		  Dim cmd As String
		  cmd = FormatPDF(cx0 * mScaleFactor, prec) + " "
		  cmd = cmd + FormatPDF((mPageHeight - cy0) * mScaleFactor, prec) + " "
		  cmd = cmd + FormatPDF(cx1 * mScaleFactor, prec) + " "
		  cmd = cmd + FormatPDF((mPageHeight - cy1) * mScaleFactor, prec) + " "
		  cmd = cmd + FormatPDF(x * mScaleFactor, prec) + " "
		  cmd = cmd + FormatPDF((mPageHeight - y) * mScaleFactor, prec) + " c" + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoesArabicLetterJoinToNext(cp As Integer) As Boolean
		  // Check if an Arabic letter joins to the following letter
		  // Some letters (like ا د ذ ر ز و) don't join to the next letter (right-joining only)
		  // Returns: True if letter joins to next, False if right-joining only
		  
		  // Non-joining letters (alef, dal, thal, ra, zain, waw, etc.)
		  Select Case cp
		  Case &h0622, &h0623, &h0624, &h0625, &h0626, &h0627  // Alef variants
		    Return False
		  Case &h062F, &h0630  // Dal, Thal
		    Return False
		  Case &h0631, &h0632  // Reh, Zain
		    Return False
		  Case &h0648  // Waw
		    Return False
		  Case &h0698, &h06A9, &h06AF  // Additional non-joiners
		    Return False
		  Else
		    // Most Arabic letters join to next
		    Return True
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4472617773206120656C6C697073652063656E7465726564206174202878E280AC2C20792920776974682068C3B76F72697A6F6E74616C207261646975732072782C20616E642076657274696361206C207261646975732072792E
		Sub Ellipse(x As Double, y As Double, rx As Double, ry As Double, style As String = "D")
		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If

		  // Check bounds using bounding box of ellipse
		  CheckBounds(x - rx, y - ry, rx * 2, ry * 2, "Ellipse")

		  // Determine draw operation
		  Dim op As String
		  Dim styleUpper As String = style.Uppercase
		  If styleUpper = "F" Then
		    op = "f"
		  ElseIf styleUpper = "FD" Or styleUpper = "DF" Then
		    op = "B"
		  Else
		    op = "S"
		  End If
		  
		  // Use Bézier curves to approximate ellipse
		  // Magic number for circle approximation: 4/3 * (sqrt(2) - 1)
		  Const kappa As Double = 0.5522847498
		  
		  Dim rxK As Double = rx * mScaleFactor
		  Dim ryK As Double = ry * mScaleFactor
		  Dim xK As Double = x * mScaleFactor
		  Dim yK As Double = (mPageHeight - y) * mScaleFactor
		  
		  Dim cmd As String
		  
		  // Move to starting point (right side of ellipse)
		  cmd = FormatPDF(xK + rxK) + " " + FormatPDF(yK) + " m" + EndOfLine.UNIX
		  
		  // Draw four Bézier curves for the ellipse
		  // Top right quadrant
		  cmd = cmd + FormatPDF(xK + rxK) + " " + FormatPDF(yK + ryK * kappa) + " "
		  cmd = cmd + FormatPDF(xK + rxK * kappa) + " " + FormatPDF(yK + ryK) + " "
		  cmd = cmd + FormatPDF(xK) + " " + FormatPDF(yK + ryK) + " c" + EndOfLine.UNIX
		  
		  // Top left quadrant
		  cmd = cmd + FormatPDF(xK - rxK * kappa) + " " + FormatPDF(yK + ryK) + " "
		  cmd = cmd + FormatPDF(xK - rxK) + " " + FormatPDF(yK + ryK * kappa) + " "
		  cmd = cmd + FormatPDF(xK - rxK) + " " + FormatPDF(yK) + " c" + EndOfLine.UNIX
		  
		  // Bottom left quadrant
		  cmd = cmd + FormatPDF(xK - rxK) + " " + FormatPDF(yK - ryK * kappa) + " "
		  cmd = cmd + FormatPDF(xK - rxK * kappa) + " " + FormatPDF(yK - ryK) + " "
		  cmd = cmd + FormatPDF(xK) + " " + FormatPDF(yK - ryK) + " c" + EndOfLine.UNIX
		  
		  // Bottom right quadrant
		  cmd = cmd + FormatPDF(xK + rxK * kappa) + " " + FormatPDF(yK - ryK) + " "
		  cmd = cmd + FormatPDF(xK + rxK) + " " + FormatPDF(yK - ryK * kappa) + " "
		  cmd = cmd + FormatPDF(xK + rxK) + " " + FormatPDF(yK) + " c" + EndOfLine.UNIX
		  
		  // Close path and apply operation
		  cmd = cmd + op + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320616E20656D6F6A6920746F207468652063757272656E7420706167652061742074686520737065636966696564206C6F636174696F6E20616E642073697A652E
		Sub Emoji(emojiChar As String, x As Double, y As Double, sizeInUserUnits As Double, bgColor As Color = &cFFFFFF)
		  // Add a color emoji to the current page at the specified position and size
		  // emojiChar: A single emoji character (e.g., "😀", "🎨", "🚀")
		  // x, y: Position in user units (mm/cm/inches/points depending on mUnit)
		  // sizeInUserUnits: Size of emoji in user units (width and height will be equal)
		  // bgColor: Background color for the emoji image (default white; use parent block bg for blending)
		  //
		  // Platform Support:
		  // - Desktop: ✅ Working (uses Picture/Graphics API with emoji font)
		  // - iOS: ✅ Working (uses native UIKit API)
		  // - Web: ✅ Working (uses Picture/Graphics API with emoji font - same as Desktop)
		  // - Console: ❌ Not supported (no graphics rendering capability)
		  //
		  // This method handles all the complexity of:
		  // - Rendering emoji using platform's native emoji font
		  // - Converting to image (PNG on Desktop, JPEG on iOS/Web)
		  // - Embedding in PDF
		  // - No temporary files needed (uses ImageFromPicture directly)
		  
		  #If TargetDesktop Or TargetiOS Or TargetAndroid Or TargetWeb Then
		    If mError <> "" Then
		      Return
		    End If
		    
		    // Convert size from user units to points for rendering
		    Dim sizeInPoints As Integer = sizeInUserUnits * mScaleFactor
		    
		    // Render emoji to Picture
		    Dim pic As Picture = VNSPDFModule.RenderEmojiToImage(emojiChar, sizeInPoints, Nil, bgColor)
		    
		    If pic = Nil Then
		      Call SetError("Failed to render emoji: " + emojiChar)
		      Return
		    End If
		    
		    // Embed image in PDF using ImageFromPicture
		    // Use unique imageKey to prevent caching/collision issues
		    Dim randomSuffix As Integer = Rnd * 999999
		    #If TargetiOS Or TargetAndroid Then
		      // iOS/Android: Use simple counter for uniqueness
		      Static emojiCounter As Integer = 0
		      emojiCounter = emojiCounter + 1
		      Dim imageKey As String = "emoji_" + Str(emojiCounter) + "_" + Str(randomSuffix)
		    #Else
		      // Desktop/Web/Console: Use Microseconds for uniqueness
		      Dim imageKey As String = "emoji_" + Str(System.Microseconds) + "_" + Str(randomSuffix)
		    #EndIf
		    
		    Call ImageFromPicture(pic, x, y, sizeInUserUnits, sizeInUserUnits, imageKey)
		    
		  #Else
		    // Console: Emoji not supported
		    #Pragma Unused emojiChar
		    #Pragma Unused x
		    #Pragma Unused y
		    #Pragma Unused sizeInUserUnits
		    Call SetError("Emoji rendering not supported on Console platform (no graphics API)")
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeMetadataString(txt As String) As String
		  // Encode metadata string - use UTF-16BE if contains non-ASCII characters
		  Dim needsUTF16 As Boolean = False
		  
		  // Check if string contains non-ASCII characters (API2)
		  For i As Integer = 0 To txt.Length - 1
		    Dim ch As String = txt.Middle(i, 1)  // API2: 0-based Middle()
		    Dim chMB As MemoryBlock = ch
		    If chMB.Byte(0) > 127 Then
		      needsUTF16 = True
		      Exit For
		    End If
		  Next
		  
		  If needsUTF16 Then
		    // Convert to UTF-16BE with BOM
		    Dim utf16 As String = UTF8ToUTF16BE(txt, True) // True = include BOM
		    // Escape and wrap in parentheses
		    Return "(" + EscapeBinaryText(utf16) + ")"
		  Else
		    // ASCII string - just escape and wrap
		    Dim escaped As String = txt.ReplaceAll("\", "\\")
		    escaped = escaped.ReplaceAll("(", "\(")
		    escaped = escaped.ReplaceAll(")", "\)")
		    Return "(" + escaped + ")"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeTextForTrueType(txt As String, ttf As VNSPDFTrueTypeFont, Optional glyphMapping As Dictionary = Nil) As String
		  // Convert UTF-8 text to glyph IDs for Identity-H encoded TrueType fonts
		  // Identity-H expects CIDs (character IDs) which map to glyph indices in the font
		  // glyphMapping: Optional dictionary for remapping glyph IDs (used with font subsetting)
		  // Note: Text should already be shaped if called from EncodeTextForCurrentFont

		  // Shape Arabic text if needed (converts to presentation forms)
		  // Safe to call on already-shaped text - presentation forms (FE70-FEFF) are left unchanged
		  Dim shapedText As String = ShapeArabicText(txt)

		  // Convert UTF-8 string to Unicode code points
		  Dim codePoints() As Integer = UTF8ToCodePoints(shapedText)
		  
		  // Convert Unicode code points to glyph IDs using font's cmap
		  Dim glyphMB As New MemoryBlock(codePoints.Count * 2) // 2 bytes per glyph ID
		  glyphMB.LittleEndian = False // Big-endian for PDF
		  
		  For i As Integer = 0 To codePoints.LastIndex
		    Dim unicode As Integer = codePoints(i)
		    Dim glyphID As Integer = ttf.GetGlyphID(unicode)
		    
		    // Remap glyph ID if font subsetting was used
		    If glyphMapping <> Nil And glyphMapping.HasKey(Str(glyphID)) Then
		      glyphID = glyphMapping.Value(Str(glyphID))
		    End If
		    
		    // Write glyph ID as 16-bit big-endian
		    glyphMB.UInt16Value(i * 2) = glyphID
		  Next
		  
		  // Convert to hex string format <XXXX...>
		  Dim hexStr As String = "<"
		  For i As Integer = 0 To glyphMB.Size - 1
		    Dim hexValue As String = Hex(glyphMB.Byte(i))
		    While VNSPDFModule.StringLenB(hexValue) < 2
		      hexValue = "0" + hexValue
		    Wend
		    hexStr = hexStr + hexValue
		  Next
		  hexStr = hexStr + ">"
		  
		  Return hexStr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncryptString(txt As String, objectNumber As Integer) As String
		  // Encrypt and hex-encode a PDF string for encrypted documents
		  // Returns hex-encoded encrypted string in <HEXSTRING> format
		  
		  If mEncryption = Nil Then
		    // No encryption - use standard encoding
		    Return EncodeMetadataString(txt)
		  End If
		  
		  // Convert text to UTF-16BE (same as metadata encoding)
		  Dim needsUTF16 As Boolean = False
		  
		  // Check if string contains non-ASCII characters
		  For i As Integer = 0 To txt.Length - 1
		    Dim ch As String = txt.Middle(i, 1)
		    Dim chMB As MemoryBlock = ch
		    If chMB.Byte(0) > 127 Then
		      needsUTF16 = True
		      Exit For
		    End If
		  Next
		  
		  Dim plaintext As String
		  If needsUTF16 Then
		    plaintext = UTF8ToUTF16BE(txt, True) // Include BOM
		  Else
		    plaintext = txt
		  End If
		  
		  // Encrypt the string
		  Dim encrypted As String = mEncryption.EncryptObject(plaintext, objectNumber, 0)
		  
		  // Hex-encode the encrypted bytes
		  Dim result As String = "<"
		  Dim j As Integer
		  
		  For j = 0 To encrypted.Length - 1
		    Dim byteStr As String = encrypted.MiddleBytes(j, 1)
		    Dim byteMB As MemoryBlock = byteStr
		    Dim b As Integer = byteMB.Byte(0)
		    Dim hexStr As String = "0" + Hex(b)
		    result = result + hexStr.Right(2)
		  Next
		  
		  result = result + ">"
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207472756520696620616E206572726F7220686173206F636375727265642E0A
		Function Err() As Boolean
		  // Returns true if an error has occurred
		  Return mError <> ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EscapeBinaryText(binaryStr As String) As String
		  // Escape special PDF characters in a binary string (UTF-16BE bytes)
		  // without interpreting bytes as characters
		  // Must escape: \ ( ) and potentially \r
		  
		  Dim mb As MemoryBlock = binaryStr.DefineEncoding(Nil)
		  Dim resultMB As New MemoryBlock(0)
		  Dim outPos As Integer = 0
		  
		  For i As Integer = 0 To mb.Size - 1
		    Dim b As Integer = mb.Byte(i)
		    
		    If b = &h5C Then // Backslash \
		      resultMB.Size = resultMB.Size + 2
		      resultMB.Byte(outPos) = &h5C // \
		      resultMB.Byte(outPos + 1) = &h5C // \
		      outPos = outPos + 2
		      
		    ElseIf b = &h28 Then // Left parenthesis (
		      resultMB.Size = resultMB.Size + 2
		      resultMB.Byte(outPos) = &h5C // \
		      resultMB.Byte(outPos + 1) = &h28 // (
		      outPos = outPos + 2
		      
		    ElseIf b = &h29 Then // Right parenthesis )
		      resultMB.Size = resultMB.Size + 2
		      resultMB.Byte(outPos) = &h5C // \
		      resultMB.Byte(outPos + 1) = &h29 // )
		      outPos = outPos + 2
		      
		    ElseIf b = &h0D Then // Carriage return \r
		      resultMB.Size = resultMB.Size + 2
		      resultMB.Byte(outPos) = &h5C // \
		      resultMB.Byte(outPos + 1) = &h72 // r
		      outPos = outPos + 2
		      
		    Else
		      // Regular byte - copy as-is
		      resultMB.Size = resultMB.Size + 1
		      resultMB.Byte(outPos) = b
		      outPos = outPos + 1
		    End If
		  Next
		  
		  // Return as binary string (no encoding)
		  Return resultMB.StringValue(0, resultMB.Size).DefineEncoding(Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EscapeText(txt As String) As String
		  // Escape special PDF characters: \ ( )
		  Dim result As String = txt
		  
		  // Escape backslash first
		  result = result.ReplaceAll("\", "\\")
		  
		  // Escape parentheses
		  result = result.ReplaceAll("(", "\(")
		  result = result.ReplaceAll(")", "\)")
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ExtractPNGIDAT(pngData As String) As String
		  // Extract and concatenate all IDAT chunks from PNG data
		  // PNG chunks: 4-byte length + 4-byte type + data + 4-byte CRC
		  
		  Dim result As String = ""
		  Dim pos As Integer = 8 // Skip PNG signature (bytes 0-7, 0-based indexing)
		  Dim dataLen As Integer = pngData.Bytes
		  
		  While pos < dataLen - 12 // Need at least 12 bytes for chunk header
		    // Read chunk length (4 bytes, big-endian)
		    If pos + 4 > dataLen Then Exit
		    
		    Dim chunkLen As Integer = pngData.MiddleBytes(pos, 1).AscByte * &h1000000 + _
		    pngData.MiddleBytes(pos + 1, 1).AscByte * &h10000 + _
		    pngData.MiddleBytes(pos + 2, 1).AscByte * &h100 + _
		    pngData.MiddleBytes(pos + 3, 1).AscByte
		    pos = pos + 4
		    
		    // Read chunk type (4 bytes, ASCII)
		    If pos + 4 > dataLen Then Exit
		    Dim chunkType As String = pngData.MiddleBytes(pos, 4)
		    pos = pos + 4
		    
		    // Check if this is an IDAT chunk
		    If chunkType = "IDAT" Then
		      // Extract chunk data
		      If pos + chunkLen > dataLen Then Exit
		      result = result + pngData.MiddleBytes(pos, chunkLen)
		    ElseIf chunkType = "IEND" Then
		      // End of PNG data
		      Exit
		    End If
		    
		    // Skip chunk data and CRC
		    pos = pos + chunkLen + 4 // +4 for CRC
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865205044462064726177696E67206F7065726174696F6E20666F72207468652067697665E280AC6E207374796C652E0A
		Private Function FillDrawOp(style As String) As String
		  // Returns the PDF drawing operation for the given style
		  // "F" = fill only, "D" = draw only, "FD"/"DF" = fill and draw
		  
		  Dim styleUpper As String = style.Uppercase
		  If styleUpper = "F" Then
		    Return "f"
		  ElseIf styleUpper = "FD" Or styleUpper = "DF" Then
		    Return "B"
		  Else
		    Return "S"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520637572726E7420666F6E742066616D696C792E0A
		Function FontFamily() As String
		  Return mFontFamily
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520637572726E7420666F6E742073697A6520696E20706F696E74732E0A
		Function FontSizePt() As Double
		  Return mFontSizePt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520637572726E7420666F6E74207374796C652E0A
		Function FontStyle() As String
		  Return mFontStyle
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FormatHelper(value As Double, formatStr As String) As String
		  // Helper function to format doubles (iOS doesn't have Format function)
		  // Handles decimal formatting
		  
		  // Count decimal places in format string
		  Dim dotPos As Integer = formatStr.IndexOf(".")
		  Dim decimals As Integer = 2 // Default
		  
		  If dotPos > 0 Then
		    decimals = VNSPDFModule.StringLenB(formatStr) - dotPos
		  End If
		  
		  // Round to desired decimal places
		  Dim multiplier As Double = 10 ^ decimals
		  Dim rounded As Double = Round(value * multiplier) / multiplier
		  
		  // Convert to string
		  Dim s As String = Str(rounded)
		  
		  // Ensure period as decimal separator
		  s = s.ReplaceAll(",", ".")
		  
		  // Add decimal places if needed
		  If s.IndexOf(".") < 0 Then
		    s = s + "."
		  End If
		  
		  Dim currentDecimals As Integer = VNSPDFModule.StringLenB(s) - s.IndexOf(".")
		  While currentDecimals < decimals
		    s = s + "0"
		    currentDecimals = currentDecimals + 1
		  Wend
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit))
		Private Function FormatHelper(value As Integer, formatStr As String) As String
		  // Helper function to format integers (iOS doesn't have Format function)
		  // Handles padding with zeros for fixed-width strings
		  // Excluded from Android: overload by numeric type not allowed

		  Dim s As String = Str(value)
		  Dim targetLen As Integer = VNSPDFModule.StringLenB(formatStr)

		  // Pad with leading zeros if needed
		  While VNSPDFModule.StringLenB(s) < targetLen
		    s = "0" + s
		  Wend

		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FormatHelperInt(value As Integer, formatStr As String) As String
		  // Android-safe version of FormatHelper for integers
		  // Used internally where Android compatibility is needed

		  Dim s As String = Str(value)
		  Dim targetLen As Integer = VNSPDFModule.StringLenB(formatStr)

		  // Pad with leading zeros if needed
		  While VNSPDFModule.StringLenB(s) < targetLen
		    s = "0" + s
		  Wend

		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 466f726d617473206120646f75626c652076616c756520666f7220504446206f7574707574207573696e6720706572696f6420617320646563696d616c20736570617261746f722e
		Function FormatPDF(value As Double, decimals As Integer = 2) As String
		  // Format number for PDF using period as decimal separator
		  // regardless of system locale
		  
		  // Build format string based on decimals
		  Dim formatStr As String
		  If decimals = 2 Then
		    formatStr = "0.00"
		  ElseIf decimals = 3 Then
		    formatStr = "0.000"
		  Else
		    formatStr = "0."
		    For i As Integer = 1 To decimals
		      formatStr = formatStr + "0"
		    Next
		  End If
		  
		  // Format the number using helper
		  Dim s As String = FormatHelper(value, formatStr)
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 446573657269616C697A657320646F63756D656E742073746174652066726F6D204A534F4E20737472696E672E0A
		Sub FromJSON(jsonStr As String)
		  // Deserializes document state from a JSON string.
		  // This restores document configuration and state, but not page content.
		  // jsonStr: JSON string created by ToJSON()
		  
		  Try
		    Dim state As Dictionary = ParseJSON(jsonStr)
		    
		    // Restore metadata
		    If state.HasKey("title") Then mTitle = state.Value("title")
		    If state.HasKey("author") Then mAuthor = state.Value("author")
		    If state.HasKey("subject") Then mSubject = state.Value("subject")
		    If state.HasKey("keywords") Then mKeywords = state.Value("keywords")
		    If state.HasKey("creator") Then mCreator = state.Value("creator")
		    If state.HasKey("lang") Then mLang = state.Value("lang")
		    
		    // Restore page configuration
		    If state.HasKey("pageWidth") Then mPageWidth = state.Value("pageWidth")
		    If state.HasKey("pageHeight") Then mPageHeight = state.Value("pageHeight")
		    If state.HasKey("leftMargin") Then mLeftMargin = state.Value("leftMargin")
		    If state.HasKey("topMargin") Then mTopMargin = state.Value("topMargin")
		    If state.HasKey("rightMargin") Then mRightMargin = state.Value("rightMargin")
		    If state.HasKey("pageBreakTrigger") Then mPageBreakTrigger = state.Value("pageBreakTrigger")
		    If state.HasKey("scaleFactor") Then mScaleFactor = state.Value("scaleFactor")
		    
		    // Restore current position
		    If state.HasKey("currentX") Then mCurrentX = state.Value("currentX")
		    If state.HasKey("currentY") Then mCurrentY = state.Value("currentY")
		    
		    // Restore font state
		    If state.HasKey("currentFont") Then mCurrentFont = state.Value("currentFont")
		    If state.HasKey("fontFamily") Then mFontFamily = state.Value("fontFamily")
		    If state.HasKey("fontStyle") Then mFontStyle = state.Value("fontStyle")
		    If state.HasKey("fontSizePt") Then mFontSizePt = state.Value("fontSizePt")
		    If state.HasKey("fontNumber") Then mFontNumber = state.Value("fontNumber")
		    
		    // Restore colors
		    If state.HasKey("drawColor") Then
		      Dim dc As Dictionary = state.Value("drawColor")
		      If dc.HasKey("r") And dc.HasKey("g") And dc.HasKey("b") Then
		        mDrawColorR = dc.Value("r")
		        mDrawColorG = dc.Value("g")
		        mDrawColorB = dc.Value("b")
		      End If
		    End If
		    
		    If state.HasKey("fillColor") Then
		      Dim fc As Dictionary = state.Value("fillColor")
		      If fc.HasKey("r") And fc.HasKey("g") And fc.HasKey("b") Then
		        mFillColorR = fc.Value("r")
		        mFillColorG = fc.Value("g")
		        mFillColorB = fc.Value("b")
		      End If
		    End If
		    
		    If state.HasKey("textColor") Then
		      Dim tc As Dictionary = state.Value("textColor")
		      If tc.HasKey("r") And tc.HasKey("g") And tc.HasKey("b") Then
		        mTextColorR = tc.Value("r")
		        mTextColorG = tc.Value("g")
		        mTextColorB = tc.Value("b")
		      End If
		    End If
		    
		    // Restore line properties
		    If state.HasKey("lineWidth") Then mLineWidth = state.Value("lineWidth")
		    
		    // Restore orientation
		    If state.HasKey("curOrientation") Then mCurOrientation = state.Value("curOrientation")
		    If state.HasKey("defOrientation") Then mDefOrientation = state.Value("defOrientation")
		    
		  Catch e As RuntimeException
		    Call SetError("FromJSON error: " + e.Message)
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420616C706861207472616E73706172656E63792076616C75652E0A
		Function GetAlpha() As Double
		  Return mAlpha
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetArabicPresentationForm(cp As Integer, position As Integer) As Integer
		  // Map base Arabic character to presentation form based on position
		  // position: 0=isolated, 1=initial, 2=final, 3=medial
		  // Returns: Unicode code point for presentation form
		  
		  // Arabic Presentation Forms-B mapping (partial - common letters)
		  // This is a simplified version - a complete implementation would use full Unicode data
		  
		  Select Case cp
		    // Beh (ب)
		  Case &h0628
		    Select Case position
		    Case 0
		      Return &hFE8F  // Isolated
		    Case 1
		      Return &hFE91  // Initial
		    Case 2
		      Return &hFE90  // Final
		    Case 3
		      Return &hFE92  // Medial
		    End Select
		    
		    // Teh (ت)
		  Case &h062A
		    Select Case position
		    Case 0
		      Return &hFE95  // Isolated
		    Case 1
		      Return &hFE97  // Initial
		    Case 2
		      Return &hFE96  // Final
		    Case 3
		      Return &hFE98  // Medial
		    End Select
		    
		    // Alef (ا) - doesn't join to next
		  Case &h0627
		    Select Case position
		    Case 0
		      Return &hFE8D  // Isolated
		    Case 2
		      Return &hFE8E  // Final
		    Else
		      Return &hFE8D    // Initial treated as isolated
		    End Select
		    
		    // Heh (ح)
		  Case &h062D
		    Select Case position
		    Case 0
		      Return &hFEA1  // Isolated
		    Case 1
		      Return &hFEA3  // Initial
		    Case 2
		      Return &hFEA2  // Final
		    Case 3
		      Return &hFEA4  // Medial
		    End Select
		    
		    // Meem (م)
		  Case &h0645
		    Select Case position
		    Case 0
		      Return &hFEE1  // Isolated
		    Case 1
		      Return &hFEE3  // Initial
		    Case 2
		      Return &hFEE2  // Final
		    Case 3
		      Return &hFEE4  // Medial
		    End Select
		    
		    // Reh (ر) - doesn't join to next
		  Case &h0631
		    Select Case position
		    Case 0
		      Return &hFEAD  // Isolated
		    Case 2
		      Return &hFEAE  // Final
		    Else
		      Return &hFEAD    // Initial treated as isolated
		    End Select
		    
		    // Lam (ل)
		  Case &h0644
		    Select Case position
		    Case 0
		      Return &hFEDD  // Isolated
		    Case 1
		      Return &hFEDF  // Initial
		    Case 2
		      Return &hFEDE  // Final
		    Case 3
		      Return &hFEE0  // Medial
		    End Select
		    
		    // Ain (ع)
		  Case &h0639
		    Select Case position
		    Case 0
		      Return &hFEC9  // Isolated
		    Case 1
		      Return &hFECB  // Initial
		    Case 2
		      Return &hFECA  // Final
		    Case 3
		      Return &hFECC  // Medial
		    End Select
		    
		    // Yeh (ي)
		  Case &h064A
		    Select Case position
		    Case 0
		      Return &hFEF1  // Isolated
		    Case 1
		      Return &hFEF3  // Initial
		    Case 2
		      Return &hFEF2  // Final
		    Case 3
		      Return &hFEF4  // Medial
		    End Select
		    
		    // Waw (و) - doesn't join to next
		  Case &h0648
		    Select Case position
		    Case 0
		      Return &hFEED  // Isolated
		    Case 2
		      Return &hFEEE  // Final
		    Else
		      Return &hFEED    // Initial treated as isolated
		    End Select
		    
		    // Dal (د) - doesn't join to next
		  Case &h062F
		    Select Case position
		    Case 0
		      Return &hFEA9  // Isolated
		    Case 2
		      Return &hFEAA  // Final
		    Else
		      Return &hFEA9    // Initial treated as isolated
		    End Select
		    
		    // Space and other non-letters
		  Case &h0020
		    Return &h0020  // Space stays as space
		    
		    // Add more letter mappings as needed...
		    // For unmapped letters, return the base character
		  Else
		    Return cp
		  End Select
		  
		  Return cp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206175746F2070616765206272656B2073657474696E677320286175746F2C206D617267696E292E0A
		Sub GetAutoPageBreak(ByRef auto As Boolean, ByRef margin As Double)
		  auto = mAutoPageBreak
		  margin = mBottomMargin
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420626C656E64206D6F64652E0A
		Function GetBlendMode() As String
		  Return mBlendMode
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E742063656C6C206D617267696E2E0A
		Function GetCellMargin() As Double
		  Return mCellMargin
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520636F6D7072657373696F6E207374617465
		Function GetCompression() As Boolean
		  // Returns true if stream compression is enabled
		  Return mCompression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520636F6E76657273696F6E20726174696F2066726F6D207573657220756E69747320746F20706F696E74732E0A
		Function GetConversionRatio() As Double
		  // Returns the conversion ratio from user units to points.
		  // This is the scale factor (k) used internally.
		  Return mScaleFactor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCoreFontName(family As String, style As String) As String
		  // Map to actual PDF core font names
		  // Note: Underline ("U") and Strikethrough ("S") are text decorations, not font variants
		  // Strip them before looking up the font name
		  Dim fontStyle As String = style.ReplaceAll("U", "").ReplaceAll("S", "")
		  
		  Select Case family
		  Case "helvetica", "arial"
		    If fontStyle = "" Then
		      Return "Helvetica"
		    ElseIf fontStyle = "B" Then
		      Return "Helvetica-Bold"
		    ElseIf fontStyle = "I" Then
		      Return "Helvetica-Oblique"
		    ElseIf fontStyle = "BI" Or fontStyle = "IB" Then
		      Return "Helvetica-BoldOblique"
		    End If
		    
		  Case "times"
		    If fontStyle = "" Then
		      Return "Times-Roman"
		    ElseIf fontStyle = "B" Then
		      Return "Times-Bold"
		    ElseIf fontStyle = "I" Then
		      Return "Times-Italic"
		    ElseIf fontStyle = "BI" Or fontStyle = "IB" Then
		      Return "Times-BoldItalic"
		    End If
		    
		  Case "courier"
		    If fontStyle = "" Then
		      Return "Courier"
		    ElseIf fontStyle = "B" Then
		      Return "Courier-Bold"
		    ElseIf fontStyle = "I" Then
		      Return "Courier-Oblique"
		    ElseIf fontStyle = "BI" Or fontStyle = "IB" Then
		      Return "Courier-BoldOblique"
		    End If
		    
		  Case "symbol"
		    Return "Symbol"
		    
		  Case "zapfdingbats"
		    Return "ZapfDingbats"
		  End Select
		  
		  Return "Helvetica" // Default
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732063757272656E7420646973706C6179206D6F646520617320612044696374696F6E6172792E0A
		Function GetDisplayMode() As Dictionary
		  // Returns current display mode settings
		  // Returns: Dictionary with keys "zoom" and "layout"
		  //
		  // Example:
		  //   Dim mode As Dictionary = pdf.GetDisplayMode()
		  //   Dim zoom As String = mode.Value("zoom")
		  //   Dim layout As String = mode.Value("layout")
		  
		  Dim result As New Dictionary
		  result.Value("zoom") = mZoomMode
		  result.Value("layout") = mLayoutMode
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E74206472617720636F6C6F72206173206120586F6A6F20436F6C6F72206F626A6563742E0A
		Function GetDrawColor() As Color
		  // Returns the current draw color as a Xojo Color object
		  //
		  // Example:
		  //   Dim currentColor As Color = pdf.GetDrawColor()
		  
		  Return Color.RGB(mDrawColorR, mDrawColorG, mDrawColorB)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E74206472617720636F6C6F722052474220636F6D706F6E656E74732028302D323535292E0A
		Sub GetDrawColor(ByRef r As Integer, ByRef g As Integer, ByRef b As Integer)
		  r = mDrawColorR
		  g = mDrawColorG
		  b = mDrawColorB
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206572726F72206D6573736167652C206F7220656D70747920737472696E67206966206E6F206572726F722E0A
		Function GetError() As String
		  // Returns the error message, or empty string if no error
		  Return mError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E742066696C6C20636F6C6F72206173206120586F6A6F20436F6C6F72206F626A6563742E0A
		Function GetFillColor() As Color
		  // Returns the current fill color as a Xojo Color object
		  //
		  // Example:
		  //   Dim currentColor As Color = pdf.GetFillColor()
		  
		  Return Color.RGB(mFillColorR, mFillColorG, mFillColorB)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E742066696C6C20636F6C6F722052474220636F6D706F6E656E74732028302D323535292E0A
		Sub GetFillColor(ByRef r As Integer, ByRef g As Integer, ByRef b As Integer)
		  r = mFillColorR
		  g = mFillColorG
		  b = mFillColorB
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320666F6E742064657363726970746F72206D65747269637320617320612044696374696F6E6172792E0A
		Function GetFontDesc(family As String = "", style As String = "") As Dictionary
		  // Returns font descriptor metrics for the specified font
		  // If family is empty, returns metrics for current font
		  //
		  // Returns Dictionary with keys:
		  //   Ascent (Integer) - Maximum height above baseline (positive)
		  //   Descent (Integer) - Maximum depth below baseline (negative)
		  //   CapHeight (Integer) - Height of flat capital letters
		  //   Flags (Integer) - Font characteristics (bit flags)
		  //   MissingWidth (Integer) - Default width for missing glyphs (1000 units)
		  //
		  // Example:
		  //   Dim desc As Dictionary = pdf.GetFontDesc("helvetica", "")
		  //   Dim ascent As Integer = desc.Value("Ascent")
		  
		  Dim result As New Dictionary
		  
		  // If no family specified, use current font
		  Dim fontKey As String
		  If family = "" Then
		    fontKey = mCurrentFont
		  Else
		    // Normalize family and style
		    family = family.Lowercase.Trim
		    style = style.Uppercase.Trim
		    fontKey = family + style
		  End If
		  
		  // Check if font exists
		  If Not mFonts.HasKey(fontKey) Then
		    // Return empty descriptor if font not found
		    result.Value("Ascent") = 0
		    result.Value("Descent") = 0
		    result.Value("CapHeight") = 0
		    result.Value("Flags") = 0
		    result.Value("MissingWidth") = 1000
		    Return result
		  End If
		  
		  Dim fontInfo As Dictionary = mFonts.Value(fontKey)
		  Dim fontType As String = fontInfo.Value("type")
		  
		  If fontType = "UTF8" Then
		    // TrueType font - get metrics from TTF object
		    If fontInfo.HasKey("ttf") Then
		      Dim ttf As VNSPDFTrueTypeFont = fontInfo.Value("ttf")
		      result.Value("Ascent") = ttf.Ascent
		      result.Value("Descent") = ttf.Descent
		      result.Value("CapHeight") = ttf.CapHeight
		      result.Value("Flags") = ttf.Flags
		      result.Value("MissingWidth") = ttf.MissingWidth
		    Else
		      // Fallback if no TTF object
		      result.Value("Ascent") = 750
		      result.Value("Descent") = -250
		      result.Value("CapHeight") = 700
		      result.Value("Flags") = 32 // Symbolic
		      result.Value("MissingWidth") = 1000
		    End If
		    
		  Else
		    // Core font - use standard metrics based on font family
		    Select Case fontKey
		    Case "courier", "courierB", "courierI", "courierBI"
		      result.Value("Ascent") = 629
		      result.Value("Descent") = -157
		      result.Value("CapHeight") = 562
		      result.Value("Flags") = 35 // FixedPitch + Symbolic
		      result.Value("MissingWidth") = 600
		      
		    Case "helvetica", "helveticaB", "helveticaI", "helveticaBI"
		      result.Value("Ascent") = 718
		      result.Value("Descent") = -207
		      result.Value("CapHeight") = 718
		      result.Value("Flags") = 32 // Symbolic
		      result.Value("MissingWidth") = 500
		      
		    Case "times", "timesB", "timesI", "timesBI"
		      result.Value("Ascent") = 683
		      result.Value("Descent") = -217
		      result.Value("CapHeight") = 662
		      result.Value("Flags") = 34 // Serif + Symbolic
		      result.Value("MissingWidth") = 500
		      
		    Case "symbol"
		      result.Value("Ascent") = 700
		      result.Value("Descent") = -200
		      result.Value("CapHeight") = 700
		      result.Value("Flags") = 32 // Symbolic
		      result.Value("MissingWidth") = 600
		      
		    Case "zapfdingbats"
		      result.Value("Ascent") = 750
		      result.Value("Descent") = -200
		      result.Value("CapHeight") = 750
		      result.Value("Flags") = 32 // Symbolic
		      result.Value("MissingWidth") = 600
		      
		    Else
		      // Unknown core font - use generic values
		      result.Value("Ascent") = 750
		      result.Value("Descent") = -250
		      result.Value("CapHeight") = 700
		      result.Value("Flags") = 32
		      result.Value("MissingWidth") = 600
		    End Select
		  End If
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420666F6E742066616D696C792E0A
		Function GetFontFamily() As String
		  Return mFontFamily
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420666F6E7420504446207265666572656E6365206C696B652046312E0A
		Function GetCurrentFontRef() As String
		  // Returns the font reference like "F1" for use in PDF commands
		  If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		    Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		    Return "F" + Str(fontInfo.Value("number"))
		  End If
		  Return "F1"  // Default fallback
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456e636f646573207465787420666f7220504446206f7574707574207573696e67207468652063757272656e7420666f6e7420656e636f64696e67202868657820666f72205554462d3820666f6e74732c20706172656e74686573657320666f7220636f726520666f6e7473292e
		Function EncodeTextForCurrentFont(txt As String) As String
		  // Encodes text for PDF output using the current font's encoding.
		  // For UTF-8 TrueType fonts, returns hex-encoded glyph IDs like <0048006F...>
		  // For core fonts, returns parentheses-escaped string like (Hello)

		  If mCurrentFont = "" Or txt = "" Then
		    Return "()"
		  End If

		  If Not mFonts.HasKey(mCurrentFont) Then
		    Return "(" + EscapeText(txt) + ")"
		  End If

		  Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		  Dim isUTF8 As Boolean
		  If fontInfo.HasKey("type") And fontInfo.Value("type") = "UTF8" Then isUTF8 = True

		  If isUTF8 And fontInfo.HasKey("ttf") Then
		    // Use glyph ID encoding for UTF8 TrueType fonts
		    Dim ttf As VNSPDFTrueTypeFont = fontInfo.Value("ttf")

		    // Shape Arabic text FIRST (converts to presentation forms)
		    // This must happen before registering code points for subsetting
		    Dim shapedText As String = ShapeArabicText(txt)

		    // IMPORTANT: Register SHAPED characters for font subsetting
		    // This ensures presentation form glyphs are included when font is subsetted
		    If fontInfo.HasKey("usedRunes") Then
		      Dim usedRunes As Dictionary = fontInfo.Value("usedRunes")
		      Dim codePoints() As Integer = UTF8ToCodePoints(shapedText)
		      For i As Integer = 0 To codePoints.LastIndex
		        Dim codePoint As Integer = codePoints(i)
		        usedRunes.Value(Str(codePoint)) = codePoint
		      Next
		    End If

		    Dim glyphMapping As Dictionary = Nil
		    If fontInfo.HasKey("glyphMapping") Then
		      glyphMapping = fontInfo.Value("glyphMapping")
		    End If
		    Return EncodeTextForTrueType(shapedText, ttf, glyphMapping)
		  Else
		    // Use standard PDF string escaping for core fonts
		    Return "(" + EscapeText(txt) + ")"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206C6F636174696F6E206F6620666F6E742066696C65732E0A
		Function GetFontLocation() As String
		  // GetFontLocation returns the directory path for font files.
		  // This path is used when loading fonts with AddFont() or AddUTF8Font().
		  // Returns empty string if no custom font location has been set.
		  
		  Return mFontPath
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520666F6E742073697A6520696E20706F696E747320616E64207573657220756E6974732E0A
		Sub GetFontSize(ByRef ptSize As Double, ByRef unitSize As Double)
		  ptSize = mFontSizePt
		  unitSize = mFontSize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420666F6E74207374796C652E0A
		Function GetFontStyle() As String
		  Return mFontStyle
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520666F6E742073756273657474696E672073746174652E0A
		Function GetFontSubsetting() As Boolean
		  // Returns true if font subsetting is enabled (default: true)
		  Return mEnableFontSubsetting
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLang() As String
		  // Returns the natural language of the document (e.g. "en-US", "de-CH", "fr-FR")
		  // Returns: Language code string, or empty string if not set
		  
		  Return mLang
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E74206C696E6520636170207374796C65206173206120737472696E672E0A
		Function GetLineCapStyle() As String
		  Select Case mLineCapStyle
		  Case 0
		    Return "butt"
		  Case 1
		    Return "round"
		  Case 2
		    Return "square"
		  Else
		    Return "butt"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E74206C696E65206A6F696E207374796C65206173206120737472696E672E0A
		Function GetLineJoinStyle() As String
		  Select Case mLineJoinStyle
		  Case 0
		    Return "miter"
		  Case 1
		    Return "round"
		  Case 2
		    Return "bevel"
		  Else
		    Return "miter"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E74206C696E652077696474682E0A
		Function GetLineWidth() As Double
		  Return mLineWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320616C6C206D617267696E7320286C6566742C20746F702C2072696768742C20626F74746F6D292E0A
		Sub GetMargins(ByRef left As Double, ByRef top As Double, ByRef right As Double, ByRef bottom As Double)
		  left = mLeftMargin
		  top = mTopMargin
		  right = mRightMargin
		  bottom = mBottomMargin
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206C656674206D617267696E20696E207363616C656420756E6974732E
		Function GetLeftMargin() As Double
		  Return mLeftMargin
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865207269676874206D617267696E20696E207363616C656420756E6974732E
		Function GetRightMargin() As Double
		  Return mRightMargin
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520746F70206D617267696E20696E207363616C656420756E6974732E
		Function GetTopMargin() As Double
		  Return mTopMargin
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520626F74746F6D206D617267696E20696E207363616C656420756E6974732E
		Function GetBottomMargin() As Double
		  Return mBottomMargin
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420706167652064696D656E73696F6E73202877696474682C20686569676874292E0A
		Sub GetPageSize(ByRef width As Double, ByRef height As Double)
		  width = mPageWidth
		  height = mPageHeight
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420706167652068656967687420696E207363616C656420756E6974732E0A
		Function GetPageHeight() As Double
		  Return mPageHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E74207061676520776964746820696E207363616C656420756E6974732E0A
		Function GetPageWidth() As Double
		  Return mPageWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420706167652078206F7269656E746174696F6E2E
		Function GetOrientation() As VNSPDFModule.ePageOrientation
		  Return mCurOrientation
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573206120706167652073697A6520737472696E67206C696B6520274134272C20274C65747465722720746F2064696D656E73696F6E732E0A
		Function GetPageSizeStr(sizeStr As String) As Pair
		  // Parses a page size string like "A4", "Letter", etc.
		  // Returns a Pair(width, height) in user units.
		  // Returns Nil if the size string is not recognized.
		  
		  sizeStr = sizeStr.Lowercase.Trim
		  
		  Dim sizeInPoints As Pair
		  
		  Select Case sizeStr
		  Case "a3"
		    sizeInPoints = New Pair(VNSPDFModule.gkA3Width, VNSPDFModule.gkA3Height)
		  Case "a4"
		    sizeInPoints = New Pair(VNSPDFModule.gkA4Width, VNSPDFModule.gkA4Height)
		  Case "a5"
		    sizeInPoints = New Pair(VNSPDFModule.gkA5Width, VNSPDFModule.gkA5Height)
		  Case "letter"
		    sizeInPoints = New Pair(VNSPDFModule.gkLetterWidth, VNSPDFModule.gkLetterHeight)
		  Case "legal"
		    sizeInPoints = New Pair(VNSPDFModule.gkLegalWidth, VNSPDFModule.gkLegalHeight)
		  Else
		    Call SetError("Unknown page size: " + sizeStr)
		    Return Nil
		  End Select
		  
		  // Convert from points to user units
		  Dim widthInUserUnits As Double = sizeInPoints.Left / mScaleFactor
		  Dim heightInUserUnits As Double = sizeInPoints.Right / mScaleFactor
		  
		  Return New Pair(widthInUserUnits, heightInUserUnits)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43616C63756C617465732074686520746F74616C20686569676874206F662061207465787420737472696E67207769746820776F7264207772617070696E67207573696E67206E61747572616C20666F6E74206865696768742E0A
		Function GetStringHeight(txt As String, maxWidth As Double) As Double
		  // Calculates the total height of a text string with word wrapping
		  // Uses natural font height (ascent + descent)
		  //
		  // Parameters:
		  //   txt - The text to measure
		  //   maxWidth - Maximum width before wrapping (0 = use page width to right margin)
		  //
		  // Returns: Total height in current user units (mm/inches/cm/points)
		  //
		  // Example:
		  //   Dim height As Double = pdf.GetStringHeight("Long text here...", 100)
		  //   If pdf.GetY() + height > pdf.GetPageHeight() - pdf.GetBottomMargin() Then
		  //     pdf.AddPage()  // Text won't fit, need new page
		  //   End If
		  
		  If mCurrentFont = "" Or txt = "" Then
		    Return 0
		  End If
		  
		  // Handle width of 0 (like MultiCell does)
		  Dim cellWidth As Double = maxWidth
		  If cellWidth = 0 Then
		    cellWidth = mPageWidth - mRightMargin - mCurrentX
		  End If
		  
		  // Account for cell margins (like MultiCell does)
		  Dim wMax As Double = cellWidth - 2 * mCellMargin
		  
		  // Split into lines using existing logic
		  Dim lines() As String = SplitTextToLines(txt, wMax)
		  Dim lineCount As Integer = lines.Count
		  
		  If lineCount = 0 Then
		    Return 0
		  End If
		  
		  // Get font metrics
		  Dim desc As Dictionary = GetFontDesc()
		  Dim ascent As Integer = desc.Value("Ascent")
		  Dim descent As Integer = desc.Value("Descent")
		  
		  // Calculate line height in points (natural font height)
		  Dim lineHeightPt As Double = (ascent - descent) * mFontSizePt / 1000.0
		  
		  // Convert to user units
		  Dim lineHeightUser As Double = lineHeightPt / mScaleFactor
		  
		  // Total height = number of lines × line height
		  Return lineCount * lineHeightUser
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43616C63756C617465732074686520746F74616C20686569676874206F662061207465787420737472696E67207769746820776F7264207772617070696E67207573696E6720737065636966696564206C696E65206865696768742E0A
		Function GetStringHeight(txt As String, maxWidth As Double, lineHeight As Double) As Double
		  // Calculates the total height of a text string with word wrapping
		  // Uses specified line height (matches MultiCell API)
		  //
		  // Parameters:
		  //   txt - The text to measure
		  //   maxWidth - Maximum width before wrapping (0 = use page width to right margin)
		  //   lineHeight - Line height in user units (same as MultiCell's h parameter)
		  //
		  // Returns: Total height in current user units (mm/inches/cm/points)
		  //
		  // Example:
		  //   // Calculate height for MultiCell before rendering
		  //   Dim height As Double = pdf.GetStringHeight("Long text...", 100, 5)
		  //   If pdf.GetY() + height > pdf.GetPageHeight() - pdf.GetBottomMargin() Then
		  //     pdf.AddPage()
		  //   End If
		  //   pdf.MultiCell(100, 5, "Long text...")  // Heights match exactly
		  
		  If mCurrentFont = "" Or txt = "" Then
		    Return 0
		  End If
		  
		  // Handle width of 0 (like MultiCell does)
		  Dim cellWidth As Double = maxWidth
		  If cellWidth = 0 Then
		    cellWidth = mPageWidth - mRightMargin - mCurrentX
		  End If
		  
		  // Account for cell margins (like MultiCell does)
		  Dim wMax As Double = cellWidth - 2 * mCellMargin
		  
		  // Split into lines using existing logic
		  Dim lines() As String = SplitTextToLines(txt, wMax)
		  Dim lineCount As Integer = lines.Count
		  
		  If lineCount = 0 Then
		    Return 0
		  End If
		  
		  // Total height = number of lines × specified line height
		  Return lineCount * lineHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 47657420776964746820666F72206120737065636966696320636861726163746572206F722073796D626F6C2E
		Function GetStringSymbolWidth(symbol As String) As Double
		  // Get the width of a specific character or symbol in current user units
		  // This is a convenience wrapper around GetStringWidth() for single characters
		  // symbol: A single character or symbol (e.g., "A", "😀", "€")
		  // Returns: Width in current user units (mm/cm/inches/points)
		  
		  Return GetStringWidth(symbol)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43616C63756C6174657320746865207769647468206F66206120737472696E6720696E2063757272656E7420666F6E742E0A
		Function GetStringWidth(s As String) As Double
		  If mCurrentFont = "" Or s = "" Then
		    Return 0
		  End If

		  If Not mFonts.HasKey(mCurrentFont) Then
		    SetError("Font '" + mCurrentFont + "' not loaded")
		    Return 0
		  End If

		  Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		  Dim fontType As String = fontInfo.Value("type")

		  If fontType = "TrueType" Or fontType = "UTF8" Then
		    // Use TrueType font metrics (UTF8 fonts are also TrueType)
		    Dim ttf As VNSPDFTrueTypeFont = fontInfo.Value("ttf")
		    Dim totalWidth As Double = 0

		    // Shape Arabic text before measuring so width matches rendered output
		    Dim shapedStr As String = ShapeArabicText(s)

		    // Decode UTF-8 string to Unicode code points
		    Dim codePoints() As Integer = UTF8ToCodePoints(shapedStr)

		    // Calculate width for each Unicode code point
		    For Each codePoint As Integer In codePoints
		      Dim charWidth As Double = ttf.GetCharWidth(codePoint)
		      totalWidth = totalWidth + charWidth
		    Next

		    // Convert from PDF units (1000 per em) to points, then to user units
		    // mFontSize is in points, result should be in user units
		    Dim widthInPoints As Double = totalWidth * mFontSize / 1000.0
		    Dim widthInUserUnits As Double = widthInPoints / mScaleFactor

		    Return widthInUserUnits

		  Else
		    // Use actual character widths from core font metrics
		    Dim totalWidth As Integer = 0
		    Dim sLen As Integer = s.Length
		    
		    For i As Integer = 0 To sLen - 1  // API2 uses 0-based indexing
		      Dim char As String = s.MiddleBytes(i, 1)
		      Dim charCode As Integer = Asc(char)
		      Dim charWidth As Integer = VNSPDFModule.GetCoreFontCharWidth(mCurrentFont, charCode)
		      totalWidth = totalWidth + charWidth
		    Next
		    
		    // Convert from glyph units (1/1000 em) to points, then to user units
		    // mFontSize is in points, result should be in user units
		    Dim widthInPoints As Double = totalWidth * mFontSize / 1000.0
		    Dim widthInUserUnits As Double = widthInPoints / mScaleFactor
		    
		    Return widthInUserUnits
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E74207465787420636F6C6F72206173206120586F6A6F20436F6C6F72206F626A6563742E0A
		Function GetTextColor() As Color
		  // Returns the current text color as a Xojo Color object
		  //
		  // Example:
		  //   Dim currentColor As Color = pdf.GetTextColor()
		  
		  Return Color.RGB(mTextColorR, mTextColorG, mTextColorB)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E74207465787420636F6C6F722052474220636F6D706F6E656E74732028302D323535292E0A
		Sub GetTextColor(ByRef r As Integer, ByRef g As Integer, ByRef b As Integer)
		  r = mTextColorR
		  g = mTextColorG
		  b = mTextColorB
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420756E6465726C696E6520746869636B6E6573732E0A
		Function GetUnderlineThickness() As Double
		  // GetUnderlineThickness returns the current underline thickness multiplier.
		  
		  Return mUnderlineThickness
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520564E5320504446206C6962726172792076657273696F6E20737472696E672E0A
		Function GetVersionString() As String
		  // Returns the VNS PDF library version string.
		  Return "VNS PDF " + VNSPDFModule.gkVersion
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732054727565206966207468652063757272656E7420666F6E742069732061205554463820547275655479706520666F6E74
		Function IsCurrentFontUTF8() As Boolean
		  // Returns True if the current font is a UTF8 TrueType font
		  // Used by HTML renderer to determine text encoding needs

		  If mCurrentFont = "" Then Return False
		  If Not mFonts.HasKey(mCurrentFont) Then Return False

		  Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		  Return fontInfo.HasKey("type") And fontInfo.Value("type") = "UTF8"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726e732054727565206966206120666f6e742066616d696c7920686173206265656e206c6f616465642028636f7265206f72205554462d38292e20436865636b7320626173652066616d696c79206e616d6520776974686f7574207374796c65207375666669782e
		Function HasFont(family As String) As Boolean
		  // Check if a font family has been loaded (core or UTF-8)
		  // Checks base family name (without style suffix)
		  Var key As String = family.Lowercase.Trim
		  If key = "" Then Return False
		  Return mFonts <> Nil And mFonts.HasKey(key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652063757272656E7420776F72642073706163696E672E0A
		Function GetWordSpacing() As Double
		  // GetWordSpacing returns the current word spacing value.
		  
		  Return mWordSpacing
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520637572726E742058206F736974696F6E2E
		Function GetX() As Double
		  Return mCurrentX
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520584D50206D657461646174612028584D4C2920737472696E672E0A
		Function GetXmpMetadata() As String
		  // Get the XMP (Extensible Metadata Platform) metadata
		  // Returns: XML string containing XMP metadata, or empty string if not set
		  
		  Return mXmpMetadata
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732063757272656E74205820616E64205920706F736974696F6E20617320612044696374696F6E6172792E0A
		Function GetXY() As Dictionary
		  // Returns current X and Y position as a Dictionary
		  // Returns: Dictionary with keys "x" and "y" containing current position in user units
		  //
		  // Example:
		  //   Dim pos As Dictionary = pdf.GetXY()
		  //   Dim x As Double = pos.Value("x")
		  //   Dim y As Double = pos.Value("y")
		  
		  Dim result As New Dictionary
		  result.Value("x") = mCurrentX
		  result.Value("y") = mCurrentY
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520637572726E742059206F736974696F6E2E
		Function GetY() As Double
		  Return mCurrentY
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Gradient(tp As Integer, r1 As Integer, g1 As Integer, b1 As Integer, r2 As Integer, g2 As Integer, b2 As Integer, x1 As Double, y1 As Double, x2 As Double, y2 As Double, r As Double)
		  Dim pos As Integer = mGradientList.LastIndex + 1
		  
		  // Create color strings
		  Dim clr1Str As String = FormatPDF(r1 / 255.0) + " " + FormatPDF(g1 / 255.0) + " " + FormatPDF(b1 / 255.0)
		  Dim clr2Str As String = FormatPDF(r2 / 255.0) + " " + FormatPDF(g2 / 255.0) + " " + FormatPDF(b2 / 255.0)
		  
		  // Create gradient record
		  Dim grad As New VNSPDFGradient
		  grad.tp = tp
		  grad.clr1Str = clr1Str
		  grad.clr2Str = clr2Str
		  grad.x1 = x1
		  grad.y1 = y1
		  grad.x2 = x2
		  grad.y2 = y2
		  grad.r = r
		  grad.objNum = 0
		  
		  mGradientList.Add(grad)
		  
		  // Output shading reference
		  Call Put("/Sh" + Str(pos) + " sh")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GradientClipEnd()
		  // Restore previous graphic state
		  Call Put("Q")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GradientTransformOnly(x As Double, y As Double, w As Double, h As Double)
		  // Set up transformation matrix for gradient WITHOUT adding a rectangular clip
		  // Use this when an external clip (ellipse, polygon, etc.) is already established
		  Call Put("q")
		  // Set up transformation matrix for gradient (maps 0-1 gradient coords to actual rect)
		  Call Put(FormatPDF(w * mScaleFactor) + " 0 0 " + FormatPDF(h * mScaleFactor) + " " + FormatPDF(x * mScaleFactor) + " " + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " cm")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GradientClipStart(x As Double, y As Double, w As Double, h As Double)
		  // Save current graphic state and set clipping area for gradient
		  Call Put("q")
		  Call Put(FormatPDF(x * mScaleFactor) + " " + FormatPDF((mPageHeight - y) * mScaleFactor) + " " + FormatPDF(w * mScaleFactor) + " " + FormatPDF(-h * mScaleFactor) + " re W n")
		  
		  // Set up transformation matrix for gradient
		  Call Put(FormatPDF(w * mScaleFactor) + " 0 0 " + FormatPDF(h * mScaleFactor) + " " + FormatPDF(x * mScaleFactor) + " " + FormatPDF((mPageHeight - (y + h)) * mScaleFactor) + " cm")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Image(imagePath As String, x As Double = 0, y As Double = 0, w As Double = 0, h As Double = 0, imageKey As String = "")
		  // Add an image to the current page
		  // If w and h are 0, image is shown at actual size
		  // If only w is specified, h is calculated proportionally
		  // If only h is specified, w is calculated proportionally
		  
		  If mError <> "" Then
		    Return
		  End If
		  
		  // Register image if not already registered
		  Dim key As String = imageKey
		  If key = "" Then
		    Dim f As FolderItem = New FolderItem(imagePath, FolderItem.PathModes.Native)
		    key = f.Name
		  End If
		  
		  If Not mImages.HasKey(key) Then
		    key = RegisterImage(imagePath, key)
		    If key = "" Then
		      Return // Error already set by RegisterImage
		    End If
		  End If
		  
		  Dim imageInfo As Dictionary = mImages.Value(key)
		  Dim imgWidth As Integer = imageInfo.Value("width")
		  Dim imgHeight As Integer = imageInfo.Value("height")
		  
		  // Calculate dimensions in user units
		  // PDF uses 72 DPI, convert image pixels to user units
		  Dim widthInPt As Double = imgWidth * 72.0 / 96.0 // Assume 96 DPI
		  Dim heightInPt As Double = imgHeight * 72.0 / 96.0
		  
		  // Convert to current page units
		  Dim imgW As Double = widthInPt / mScaleFactor
		  Dim imgH As Double = heightInPt / mScaleFactor
		  
		  // Handle dimension parameters
		  If w = 0 And h = 0 Then
		    // Use actual size
		    w = imgW
		    h = imgH
		  ElseIf h = 0 Then
		    // Calculate h from w (maintain aspect ratio)
		    h = w * imgHeight / imgWidth
		  ElseIf w = 0 Then
		    // Calculate w from h (maintain aspect ratio)
		    w = h * imgWidth / imgHeight
		  End If

		  CheckBounds(x, y, w, h, "Image")

		  // Convert coordinates to PDF points
		  Dim xPt As Double = x * mScaleFactor
		  Dim yPt As Double = (mPageHeight - y - h) * mScaleFactor // Y is bottom-up in PDF
		  Dim wPt As Double = w * mScaleFactor
		  Dim hPt As Double = h * mScaleFactor

		  // Add image to current page stream
		  Call Put("q") // Save graphics state
		  Call Put(FormatPDF(wPt) + " 0 0 " + FormatPDF(hPt) + " " + FormatPDF(xPt) + " " + FormatPDF(yPt) + " cm") // Transformation matrix
		  Call Put("/I" + Str(mImageIndex.Value(key)) + " Do") // Paint image
		  Call Put("Q") // Restore graphics state
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456D6265642061205069637475726520286472617768206772617068696373292061732061204E4720696D6167652E0A
		Sub ImageFromPicture(pic As Picture, x As Double = 0, y As Double = 0, w As Double = 0, h As Double = 0, Optional imageKey As String = "")
		  // Embed a Xojo Picture object (with drawn graphics) as a PNG image in the PDF
		  // pic: Picture object with Graphics that user has drawn on (lines, rectangles, arcs, text, etc.)
		  // x, y: Position in user units (default: 0, 0)
		  // w, h: Width and height in user units (if 0, use actual size or maintain aspect ratio)
		  // imageKey: Optional key for image reuse
		  
		  If Err() Then Return
		  
		  // Validate input
		  If pic = Nil Then
		    Call SetError("ImageFromPicture: Picture is Nil")
		    Return
		  End If
		  
		  // Convert Picture to image format
		  //
		  // PLATFORM-SPECIFIC IMAGE FORMAT SELECTION:
		  //
		  // iOS/Web/Windows/Linux: Use JPEG format
		  // macOS: Use PNG format
		  //
		  // WHY JPEG ON WINDOWS AND LINUX?
		  // Windows 11 and Linux (tested on Ubuntu 22.04 ARM64) have a bug where
		  // Picture.ToData(Picture.Formats.PNG) produces PNG data
		  // with an alpha channel (RGBA) that our PNG parser cannot properly embed in PDF.
		  // The PNG parser (VNSPDFImage.ParsePNG) reads the alpha channel info but doesn't
		  // strip the alpha bytes from the pixel data, causing a channel count mismatch:
		  //   - PDF declares: DeviceRGB (3 channels)
		  //   - PNG contains: RGBA (4 channels)
		  // This results in corrupted images (multi-colored noise) in the PDF.
		  //
		  // WHY NOT STRIP ALPHA FROM PNG?
		  // Manual alpha stripping requires:
		  //   1. Decompress PNG IDAT chunks (zlib)
		  //   2. Reverse PNG filtering on each scanline
		  //   3. Remove alpha byte from each pixel (RGBA -> RGB)
		  //   4. Reapply PNG filters
		  //   5. Recompress with zlib
		  //   6. Update IHDR chunk (color type 6->2 or 4->0)
		  //   7. Recalculate all CRC checksums
		  //   8. Rebuild PNG chunk structure
		  // This would require 200+ lines of complex, error-prone code.
		  //
		  // WHY NOT USE Picture(width, height, 24) TO REMOVE ALPHA?
		  // The Picture constructor with depth parameter (New Picture(w, h, depth)) that allows
		  // creating 24-bit RGB images without alpha is NOT SUPPORTED on iOS/mobile platforms.
		  // Since this library is cross-platform, we cannot use platform-specific APIs.
		  //
		  // WHY JPEG IS THE SOLUTION:
		  // JPEG format has no alpha channel by design - it's always RGB (3 channels).
		  // When Picture.ToData(Picture.Formats.JPEG) is called, Xojo automatically:
		  //   - Discards any alpha channel
		  //   - Produces clean RGB data
		  //   - Embeds perfectly in PDF with no channel mismatches
		  // At QualityHigh, JPEG compression is visually lossless for programmatically drawn
		  // graphics (lines, shapes, text) which is the primary use case for ImageFromPicture.
		  //
		  // CREDIT: Fix identified and tested by Geoff Bridges (Windows 11 user, Dec 2025)
		  //
		  // Always use JPEG: PNG from Picture.ToData produces RGBA (4 channels) on all platforms
		  // for programmatically-created pictures (New Picture(w,h)), but PDF expects RGB (3 channels).
		  // JPEG has no alpha channel by design, so Xojo auto-converts RGBA to RGB.
		  Dim imageData As MemoryBlock
		  Try
		    imageData = pic.ToData(Picture.Formats.JPEG, Picture.QualityHigh)
		  Catch e As RuntimeException
		    Call SetError("ImageFromPicture: Failed to convert Picture to JPEG - " + e.Message)
		    Return
		  End Try
		  
		  If imageData = Nil Or imageData.Size = 0 Then
		    Call SetError("ImageFromPicture: Picture conversion resulted in empty data")
		    Return
		  End If
		  
		  // Generate unique key if not provided
		  If imageKey = "" Then
		    Static pictureCounter As Integer = 0
		    pictureCounter = pictureCounter + 1
		    imageKey = "PictureGraphics" + Str(pictureCounter)
		  End If
		  
		  // Register the PNG image data
		  Dim key As String = RegisterImageFromBytes(imageData, imageKey)
		  If key = "" Then
		    Return // Error already set by RegisterImageFromBytes
		  End If
		  
		  // Get image dimensions
		  Dim imageInfo As Dictionary = mImages.Value(key)
		  Dim imgWidth As Integer = imageInfo.Value("width")
		  Dim imgHeight As Integer = imageInfo.Value("height")
		  
		  // Calculate dimensions in user units
		  // PDF uses 72 DPI, convert image pixels to user units
		  Dim widthInPt As Double = imgWidth * 72.0 / 96.0 // Assume 96 DPI
		  Dim heightInPt As Double = imgHeight * 72.0 / 96.0
		  
		  // Convert to current page units
		  Dim imgW As Double = widthInPt / mScaleFactor
		  Dim imgH As Double = heightInPt / mScaleFactor
		  
		  // Handle dimension parameters
		  If w = 0 And h = 0 Then
		    // Use actual size
		    w = imgW
		    h = imgH
		  ElseIf h = 0 Then
		    // Calculate h from w (maintain aspect ratio)
		    h = w * imgHeight / imgWidth
		  ElseIf w = 0 Then
		    // Calculate w from h (maintain aspect ratio)
		    w = h * imgWidth / imgHeight
		  End If
		  
		  // Convert coordinates to PDF points
		  Dim xPt As Double = x * mScaleFactor
		  Dim yPt As Double = (mPageHeight - y - h) * mScaleFactor // Y is bottom-up in PDF
		  Dim wPt As Double = w * mScaleFactor
		  Dim hPt As Double = h * mScaleFactor
		  
		  // Add image to current page stream
		  Call Put("q") // Save graphics state
		  Call Put(FormatPDF(wPt) + " 0 0 " + FormatPDF(hPt) + " " + FormatPDF(xPt) + " " + FormatPDF(yPt) + " cm") // Transformation matrix
		  Call Put("/I" + Str(mImageIndex.Value(key)) + " Do") // Paint image
		  Call Put("Q") // Restore graphics state
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit)), Description = 44726177206120515220436F6465206F6E20746865205044462070616765207573696E6720586F6A6F206275696C742D696E20426172636F646520636C6173732E204E6F7420617661696C61626C65206F6E20436F6E736F6C65206F7220416E64726F69642E
		Sub DrawQRCode(x As Double, y As Double, size As Double, value As String)
		  // Draw a QR Code on the PDF page using Xojo built-in Barcode class
		  // x, y: Position in user units
		  // size: Width and height of the QR code in user units
		  // value: The string to encode in the QR code
		  // Note: Not available on Console platform

		  If Err() Then Return

		  If value = "" Then
		    Call SetError("DrawQRCode: value cannot be empty")
		    Return
		  End If

		  // Generate QR code image using Xojo built-in Barcode class
		  // Use high resolution for print quality (approx 300 DPI at output size)
		  Dim pixelSize As Integer = Max(600, CType(size * 12, Integer))

		  Dim pic As Picture
		  Try
		    pic = Barcode.Image(value, pixelSize, pixelSize, Barcode.Types.QR)
		  Catch e As RuntimeException
		    Call SetError("DrawQRCode: " + e.Message)
		    Return
		  End Try

		  If pic = Nil Then
		    Call SetError("DrawQRCode: Failed to generate QR code image")
		    Return
		  End If

		  // Embed the barcode image in the PDF
		  Call ImageFromPicture(pic, x, y, size, size)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit)), Description = 44726177206120436F646531323820626172636F6465206F6E20746865205044462070616765207573696E6720586F6A6F206275696C742D696E20426172636F646520636C6173732E204E6F7420617661696C61626C65206F6E20436F6E736F6C65206F7220416E64726F69642E
		Sub DrawCode128(x As Double, y As Double, w As Double, h As Double, value As String)
		  // Draw a Code128 barcode on the PDF page using Xojo built-in Barcode class
		  // x, y: Position in user units
		  // w: Width of the barcode in user units
		  // h: Height of the barcode in user units
		  // value: The string to encode in the barcode
		  // Note: Not available on Console platform

		  If Err() Then Return

		  If value = "" Then
		    Call SetError("DrawCode128: value cannot be empty")
		    Return
		  End If

		  // Generate Code128 barcode image using Xojo built-in Barcode class
		  Dim pixelWidth As Integer = Max(800, CType(w * 12, Integer))
		  Dim pixelHeight As Integer = Max(300, CType(h * 12, Integer))

		  Dim pic As Picture
		  Try
		    pic = Barcode.Image(value, pixelWidth, pixelHeight, Barcode.Types.Bar128)
		  Catch e As RuntimeException
		    Call SetError("DrawCode128: " + e.Message)
		    Return
		  End Try

		  If pic = Nil Then
		    Call SetError("DrawCode128: Failed to generate Code128 barcode image")
		    Return
		  End If

		  // Embed the barcode image in the PDF
		  Call ImageFromPicture(pic, x, y, w, h)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41646420696D616765207769746820616476616E636564206F7074696F6E732044696374696F6E6172792E204F7074696F6E73206B6579733A20696D616765547970652028537472696E67292C20726561644470692028426F6F6C65616E292C20616C6C6F774E65676174697665506F736974696F6E2028426F6F6C65616E292E20536565205265676973746572496D6167654F7074696F6E7320666F722064657461696C732E0A
		Sub ImageOptions(imagePath As String, x As Double = 0, y As Double = 0, w As Double = 0, h As Double = 0, imageKey As String = "", options As Dictionary = Nil)
		  // Add image with advanced options Dictionary.
		  // Options keys: imageType (String), readDpi (Boolean), allowNegativePosition (Boolean)
		  // See RegisterImageOptions for details.
		  
		  If mError <> "" Then
		    Return
		  End If
		  
		  // Handle options - if Nil, fall back to standard Image()
		  If options = Nil Then
		    Call Image(imagePath, x, y, w, h, imageKey)
		    Return
		  End If
		  
		  // Register image with options if not already registered
		  Dim key As String = imageKey
		  If key = "" Then
		    Dim f As FolderItem = New FolderItem(imagePath, FolderItem.PathModes.Native)
		    key = f.Name
		  End If
		  
		  If Not mImages.HasKey(key) Then
		    key = RegisterImageOptions(imagePath, key, options)
		    If key = "" Then
		      Return // Error already set by RegisterImageOptions
		    End If
		  End If
		  
		  // Extract allowNegativePosition option (default: False)
		  Dim allowNegativePosition As Boolean = False
		  If options.HasKey("allowNegativePosition") Then
		    If options.Value("allowNegativePosition") = True Then allowNegativePosition = True
		  End If
		  
		  // Get image info
		  Dim imageInfo As Dictionary = mImages.Value(key)
		  Dim imgWidth As Integer = imageInfo.Value("width")
		  Dim imgHeight As Integer = imageInfo.Value("height")
		  
		  // Calculate dimensions in user units
		  // PDF uses 72 DPI, convert image pixels to user units
		  Dim widthInPt As Double = imgWidth * 72.0 / 96.0 // Assume 96 DPI
		  Dim heightInPt As Double = imgHeight * 72.0 / 96.0
		  
		  // Convert to current page units
		  Dim imgW As Double = widthInPt / mScaleFactor
		  Dim imgH As Double = heightInPt / mScaleFactor
		  
		  // Handle dimension parameters
		  If w = 0 And h = 0 Then
		    // Use actual size
		    w = imgW
		    h = imgH
		  ElseIf h = 0 Then
		    // Calculate h from w (maintain aspect ratio)
		    h = w * imgHeight / imgWidth
		  ElseIf w = 0 Then
		    // Calculate w from h (maintain aspect ratio)
		    w = h * imgWidth / imgHeight
		  End If
		  
		  // Convert coordinates to PDF points
		  // Respect allowNegativePosition flag
		  Dim xPt As Double
		  If allowNegativePosition Then
		    xPt = x * mScaleFactor // Allow negative X values
		  Else
		    xPt = x * mScaleFactor // Standard behavior
		  End If
		  
		  Dim yPt As Double = (mPageHeight - y - h) * mScaleFactor // Y is bottom-up in PDF
		  Dim wPt As Double = w * mScaleFactor
		  Dim hPt As Double = h * mScaleFactor
		  
		  // Add image to current page stream
		  Call Put("q") // Save graphics state
		  Call Put(FormatPDF(wPt) + " 0 0 " + FormatPDF(hPt) + " " + FormatPDF(xPt) + " " + FormatPDF(yPt) + " cm") // Transformation matrix
		  Call Put("/I" + Str(mImageIndex.Value(key)) + " Do") // Paint image
		  Call Put("Q") // Restore graphics state
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E76657274204D494D4520747970657320746F20696D6167652074797065206964656E746966696572732E0A
		Function ImageTypeFromMime(mimeStr As String) As String
		  // Convert MIME type string to image type identifier
		  // Returns: "jpg", "png", "gif", or empty string if unsupported
		  //
		  // Supported MIME types:
		  // - image/jpeg, image/jpg -> "jpg"
		  // - image/png -> "png"
		  // - image/gif -> "gif"
		  
		  Select Case mimeStr.Lowercase
		  Case "image/png"
		    Return "png"
		  Case "image/jpg", "image/jpeg"
		    Return "jpg"
		  Case "image/gif"
		    Return "gif"
		  Else
		    Call SetError("Unsupported image MIME type: " + mimeStr)
		    Return ""
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496D706F727473206120706167652066726F6D2074686520736F757263652050444620616E642072657475726E73206120746D706C617465204944420A
		Function ImportPage(pageNum As Integer) As Integer
		  // Import a specific page from the source PDF
		  // pageNum: Page number to import (1-based)
		  // Returns: Template ID for use with UseTemplate(), or 0 on error
		  
		  // Check for errors first
		  If Err() Then
		    Return 0
		  End If
		  
		  // Check if source PDF is open
		  If mSourceReader = Nil Then
		    Call SetError("No source PDF file opened. Call SetSourceFile() first.")
		    Return 0
		  End If
		  
		  // Get the page from source PDF (pages now accessed from pre-built list)
		  Dim importedPage As VNSPDFImportedPage = mSourceReader.GetPage(pageNum)
		  If importedPage = Nil Then
		    Call SetError("Failed to import page " + Str(pageNum) + " from source PDF")
		    Return 0
		  End If
		  
		  // Assign a template ID
		  Dim templateID As Integer = mNextTemplateID
		  mNextTemplateID = mNextTemplateID + 1
		  
		  // Store the imported page
		  mImportedPages.Value(Str(templateID)) = importedPage
		  
		  Return templateID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420666F722070726D696D756D206D6F64756C657320746F2061646420616E206F757470757420696E74656E742E0A
		Sub InternalAddOutputIntent(intent As VNSPDFOutputIntent)
		  // Internal method for premium modules to add an output intent directly
		  // This bypasses the premium module check since it's called from within the premium module
		  mOutputIntents.Add(intent)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420666F72207072656D69756D206D6F64756C657320746F20676574205044462076657273696F6E2E0A
		Function InternalGetPDFVersion() As String
		  // Internal method for premium modules to get current PDF version
		  Return mPDFVersion
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420666F722070726D696D756D206D6F64756C657320746F207365742050444620766572736E696F6E2E0A
		Sub InternalSetPDFVersion(version As String)
		  // Internal method for premium modules to set PDF version
		  // This is needed because some features require minimum PDF versions
		  mPDFVersion = version
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420666F72207072656D69756D206D6F64756C657320746F2061646420666F726D206669656C642E
		Sub InternalAddFormField(fieldData As Dictionary)
		  // Internal method for premium Forms module to add a form field
		  mFormFields.Add(fieldData)
		  mHasAcroForm = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F2067657420666F726D206669656C6420636F756E742E
		Function InternalGetFormFieldCount() As Integer
		  // Internal method to get count of form fields
		  Return mFormFields.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F206765742074686520666F726D206669656C647320617272C61792E
		Function InternalGetFormFields() As Dictionary()
		  // Internal method to get form fields array for PDF generation
		  Return mFormFields
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F20676574C70616765206865696768742C696E2070C6F696E74732E
		Function InternalGetPageHeightPt() As Double
		  // Internal method to get page height in points for coordinate conversion
		  Return mPageHeightPt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F20676574C7061676520C6F626A656374207265666572656E63652E
		Function InternalGetPageObjectRef(pageNum As Integer) As String
		  // Internal method to get page object reference for form field annotations
		  // Returns reference like "3 0 R" for the specified page number
		  // Pages start after attachments: 3 + mAttachmentObjectOffset + (pageNum - 1) * 2
		  Dim pageObjNum As Integer = 3 + mAttachmentObjectOffset + (pageNum - 1) * 2
		  Return Str(pageObjNum) + " 0 R"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F20C637265617465206E6577206F626A65637420616E642072657475726E2069747320C6E756D6265722E
		Function InternalNewObj() As Integer
		  // Internal method to create a new PDF object and return its number
		  // Used by premium modules to generate form field objects
		  Call NewObj()
		  Return mObjectNumber - 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F20C77726974652C746F205044462062756666C65722E
		Sub InternalPut(s As String)
		  // Internal method to write a line to the PDF buffer
		  // Used by premium modules for PDF generation
		  Call Put(s)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526573657276652061C6E206F626A656374206E756D62C65722077697468C6F757420777269746696E67207468C6520C6F626A656374C2E0A
		Function InternalReserveObjNum() As Integer
		  // Reserve an object number without writing the object header
		  // Used by premium modules when they need to reference an object before creating it
		  // Returns the reserved object number
		  Dim reserved As Integer = mObjectNumber
		  mObjectNumber = mObjectNumber + 1
		  Return reserved
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 577269746520C6120506466206F626A65637420C77697468206120666F726365C64206F626A656374206E756D6265722E
		Sub InternalNewObjAt(objNum As Integer)
		  // Create a new PDF object at a specific (reserved) object number
		  // Used by premium modules after reserving an object number
		  Call NewObj(objNum)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F2077726974C6520726177206461746120746F2050444620627566666572C2E
		Sub InternalPutRaw(s As String)
		  // Internal method to write raw data to PDF buffer (no newline)
		  // Used by premium modules for stream content
		  mBuffer = mBuffer + s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F2073657420416372C6F466F726D206F626A656374206E756D6265722E
		Sub InternalSetAcroFormObjectNumber(objNum As Integer)
		  // Internal method to set the AcroForm object number for catalog reference
		  mAcroFormObjectNumber = objNum
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F206368656B6B2069662C666F726D73206578697374C2E
		Function InternalHasAcroForm() As Boolean
		  // Internal method to check if document has form fields
		  Return mHasAcroForm
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F206765C74C416372C6F466F726D C6F626A656374C206E756D6265722E
		Function InternalGetAcroFormObjectNumber() As Integer
		  // Internal method to get AcroForm object number for catalog
		  Return mAcroFormObjectNumber
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7465726E616C206D6574686F6420746F2061646420666F726D206669656C6420616E6E6F746174696F6E207265666572656E636520746F206120706167652E0A
		Sub InternalAddFormAnnotation(pageNum As Integer, annotRef As String)
		  // Internal method to add form field annotation reference to a page
		  // Used by premium Forms module to track which annotations belong to which page
		  // annotRef: Object reference like "5 0 R"

		  Dim pageKey As String = Str(pageNum)

		  If Not mPageFormAnnotations.HasKey(pageKey) Then
		    Dim newArray() As String
		    newArray.Add(annotRef)
		    mPageFormAnnotations.Value(pageKey) = newArray
		  Else
		    Dim annots() As String = mPageFormAnnotations.Value(pageKey)
		    annots.Add(annotRef)
		    mPageFormAnnotations.Value(pageKey) = annots
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsArabicChar(cp As Integer) As Boolean
		  // Check if code point is an Arabic or Hebrew character (RTL languages)
		  // Hebrew: U+0590 to U+05FF
		  // Arabic: U+0600 to U+06FF
		  // Arabic Presentation Forms: U+FE70 to U+FEFF
		  Return (cp >= &h0590 And cp <= &h05FF) Or (cp >= &h0600 And cp <= &h06FF) Or (cp >= &hFE70 And cp <= &hFEFF)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsArabicLetter(cp As Integer) As Boolean
		  // Check if a code point is an Arabic letter that participates in joining
		  // Returns: True if Arabic letter, False otherwise
		  
		  // Main Arabic block (U+0600 to U+06FF)
		  If cp >= &h0621 And cp <= &h064A Then Return True  // Arabic letters
		  If cp >= &h0671 And cp <= &h06D3 Then Return True  // Extended Arabic
		  If cp >= &h06FA And cp <= &h06FC Then Return True  // Additional letters
		  
		  // Arabic Presentation Forms-B (already shaped - shouldn't need joining)
		  If cp >= &hFE70 And cp <= &hFEFF Then Return False
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsNeutralChar(cp As Integer) As Boolean
		  // Check if code point is a neutral character (space, punctuation, etc.)
		  // that should take directionality from context
		  // Space, tab, newline
		  If cp = &h0020 Or cp = &h0009 Or cp = &h000A Or cp = &h000D Then Return True
		  // Common punctuation that appears in mixed text
		  // Comma, period, colon, semicolon, exclamation, question
		  If cp = &h002C Or cp = &h002E Or cp = &h003A Or cp = &h003B Then Return True
		  If cp = &h0021 Or cp = &h003F Then Return True
		  // Arabic-specific punctuation
		  If cp >= &h060C And cp <= &h061F Then Return True  // Arabic comma, semicolon, question
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436865636B732069662050444620646F63756D656E7420697320696E20504446204120636F6D706C69616E6365206D6F64652E0A
		Function IsPDFAMode() As Boolean
		  // Check if document is in PDF/A compliance mode
		  // PDF/A mode is active when output intents have been added
		  // Returns: True if PDF/A mode is active, False otherwise
		  
		  Return mOutputIntents.Count > 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44726177732061206C696E652066726F6D20706F696E74202878312C2079312920746F202878322C207932292E0A
		Sub Line(x1 As Double, y1 As Double, x2 As Double, y2 As Double)
		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If

		  CheckBounds(x1, y1, 0, 0, "Line start")
		  CheckBounds(x2, y2, 0, 0, "Line end")

		  // Add PDF line drawing command to buffer
		  // Format: x1 y1 m x2 y2 l S
		  // m = move to, l = line to, S = stroke
		  Dim cmd As String
		  cmd = FormatPDF(x1 * mScaleFactor) + " "
		  cmd = cmd + FormatPDF((mPageHeight - y1) * mScaleFactor) + " m "
		  cmd = cmd + FormatPDF(x2 * mScaleFactor) + " "
		  cmd = cmd + FormatPDF((mPageHeight - y2) * mScaleFactor) + " l S" + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44726177732061206C696E656172206772616469656E74207573696E672074776F20586F6A6F20436F6C6F72206F626A656374732E0A
		Sub LinearGradient(x As Double, y As Double, w As Double, h As Double, c1 As Color, c2 As Color, x1 As Double, y1 As Double, x2 As Double, y2 As Double)
		  // Convenience overload that accepts two Xojo Color objects
		  // Extracts RGB components and calls LinearGradient(r1, g1, b1, r2, g2, b2)
		  //
		  // Parameters:
		  //   x, y: Upper left corner of the rectangle
		  //   w, h: Width and height of the rectangle
		  //   c1: Start color
		  //   c2: End color
		  //   x1, y1: Starting point of gradient vector (0.0 to 1.0)
		  //   x2, y2: Ending point of gradient vector (0.0 to 1.0)
		  //
		  // Example:
		  //   pdf.LinearGradient(10, 10, 100, 50, Color.Blue, Color.White, 0, 0, 1, 0)
		  
		  // API2: Color.Red/Green/Blue return 0-255 on all platforms
		  Dim r1 As Integer = c1.Red
		  Dim g1 As Integer = c1.Green
		  Dim b1 As Integer = c1.Blue
		  Dim r2 As Integer = c2.Red
		  Dim g2 As Integer = c2.Green
		  Dim b2 As Integer = c2.Blue

		  LinearGradient(x, y, w, h, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612072656374616E67756C617220617265612077697468206120626F7264657220616E642F6F722066696C6C2E0A
		Sub LinearGradient(x As Double, y As Double, w As Double, h As Double, r1 As Integer, g1 As Integer, b1 As Integer, r2 As Integer, g2 As Integer, b2 As Integer, x1 As Double, y1 As Double, x2 As Double, y2 As Double)
		  // LinearGradient draws a rectangular area with a blending of one color to another.
		  // The rectangle is of width w and height h. Its upper left corner is positioned at point (x, y).
		  // The blending is controlled with a gradient vector that uses normalized coordinates.
		  // In a linear gradient, blending occurs perpendicular to the vector.
		  // x1, y1, x2, y2: gradient vector coordinates (0.0 to 1.0)
		  
		  Call GradientClipStart(x, y, w, h)
		  Call Gradient(2, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2, 0)
		  Call GradientClipEnd()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LinearGradientInClip(x As Double, y As Double, w As Double, h As Double, c1 As Color, c2 As Color, x1 As Double, y1 As Double, x2 As Double, y2 As Double)
		  // Draw linear gradient using the CURRENT clip (no additional rectangular clip)
		  // Use this when an external clip path (ellipse, polygon, etc.) is already established
		  Dim r1 As Integer = c1.Red
		  Dim g1 As Integer = c1.Green
		  Dim b1 As Integer = c1.Blue
		  Dim r2 As Integer = c2.Red
		  Dim g2 As Integer = c2.Green
		  Dim b2 As Integer = c2.Blue

		  Call GradientTransformOnly(x, y, w, h)
		  Call Gradient(2, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2, 0)
		  Call GradientClipEnd()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612072656374616E67756C617220617265612077697468206D756C74692D73746F70206C696E656172206772616469656E742E
		Sub LinearGradientMultiStop(x As Double, y As Double, w As Double, h As Double, stops() As Pair, x1 As Double, y1 As Double, x2 As Double, y2 As Double)
		  // Draw a linear gradient with multiple color stops
		  // stops: Array of Pairs where Left = position (0.0-1.0), Right = Color
		  // x1, y1, x2, y2: gradient vector (normalized 0-1)

		  If stops.Count < 2 Then Return

		  Call GradientClipStart(x, y, w, h)
		  Call GradientMultiStop(2, stops, x1, y1, x2, y2, 0)
		  Call GradientClipEnd()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612072656374616E67756C617220617265612077697468206D756C74692D73746F70206C696E656172206772616469656E7420696E20616E2065787465726E616C20636C69702E
		Sub LinearGradientMultiStopInClip(x As Double, y As Double, w As Double, h As Double, stops() As Pair, x1 As Double, y1 As Double, x2 As Double, y2 As Double)
		  // Draw a linear gradient with multiple color stops using existing clip
		  // stops: Array of Pairs where Left = position (0.0-1.0), Right = Color

		  If stops.Count < 2 Then Return

		  Call GradientTransformOnly(x, y, w, h)
		  Call GradientMultiStop(2, stops, x1, y1, x2, y2, 0)
		  Call GradientClipEnd()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496E7465726E616C206D6574686F6420746F206372656174652061206D756C74692D73746F70206772616469656E742E
		Private Sub GradientMultiStop(tp As Integer, stops() As Pair, x1 As Double, y1 As Double, x2 As Double, y2 As Double, r As Double)
		  // Create a multi-stop gradient (uses FunctionType 3 stitching)
		  Dim pos As Integer = mGradientList.Count

		  // Create gradient record with color stops
		  Dim grad As New VNSPDFGradient
		  grad.tp = tp
		  grad.x1 = x1
		  grad.y1 = y1
		  grad.x2 = x2
		  grad.y2 = y2
		  grad.r = r
		  grad.objNum = 0

		  // Store color stops as Pairs of (position, colorString)
		  For i As Integer = 0 To stops.LastIndex
		    Dim stopPos As Double = stops(i).Left.DoubleValue
		    Dim stopColor As Color = stops(i).Right.ColorValue
		    Dim colorStr As String = FormatPDF(stopColor.Red / 255.0) + " " + FormatPDF(stopColor.Green / 255.0) + " " + FormatPDF(stopColor.Blue / 255.0)
		    grad.colorStops.Add(New Pair(stopPos, colorStr))
		  Next

		  // Also set clr1Str/clr2Str for compatibility (first and last colors)
		  If grad.colorStops.Count >= 1 Then
		    grad.clr1Str = grad.colorStops(0).Right.StringValue
		  End If
		  If grad.colorStops.Count >= 2 Then
		    grad.clr2Str = grad.colorStops(grad.colorStops.LastIndex).Right.StringValue
		  Else
		    grad.clr2Str = grad.clr1Str
		  End If

		  mGradientList.Add(grad)

		  // Output shading reference
		  Call Put("/Sh" + Str(pos) + " sh")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 507574732061206C696E6B206F6E20612072656374616E67756C617220617265612E0A
		Sub Link(x As Double, y As Double, w As Double, h As Double, linkID As Integer)
		  // Add an internal link area on the current page
		  // x, y: Top-left corner of the clickable rectangle (in user units)
		  // w, h: Width and height of the rectangle
		  // linkID: Link identifier returned by AddLink()
		  
		  If mPage = 0 Then
		    Call SetError("Cannot create link: no page added yet")
		    Return
		  End If
		  
		  // Create link dictionary
		  Dim linkArea As New Dictionary
		  linkArea.Value("x") = x * mScaleFactor
		  linkArea.Value("y") = y * mScaleFactor
		  linkArea.Value("w") = w * mScaleFactor
		  linkArea.Value("h") = h * mScaleFactor
		  linkArea.Value("link") = linkID
		  linkArea.Value("linkStr") = ""
		  
		  // Add to page links
		  Dim pageKey As String = Str(mPage)
		  
		  // Get existing array or create new one
		  Dim links() As Variant
		  If mPageLinks.HasKey(pageKey) Then
		    links = mPageLinks.Value(pageKey)
		  End If
		  
		  // Add item and store back
		  links.Add(linkArea)
		  mPageLinks.Value(pageKey) = links
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061206C696E6B20746F20616E2065787465726E616C2055524C2E20436F6D70617469626C65207769746820586F6A6F2773205044464469726563742E4164644C696E6B417265612E, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit))
		Sub AddLinkArea(url As String, x As Integer, y As Integer, width As Integer, height As Integer)
		  // Xojo PDFDocument.AddLinkArea compatible method (Integer overload, excluded from Android)
		  // Adds an external URL link to a specified rectangular area on the current page
		  // url: The URL to link to
		  // x, y: Top-left corner of the link area (in user units, Integer for Xojo compatibility)
		  // width, height: Dimensions of the link area

		  Dim xD As Double = x
		  Dim yD As Double = y
		  Dim wD As Double = width
		  Dim hD As Double = height
		  LinkString(xD, yD, wD, hD, url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061206C696E6B20746F20616E2065787465726E616C2055524C2E20436F6D70617469626C65207769746820586F6A6F2773205044464469726563742E4164644C696E6B417265612E
		Sub AddLinkArea(url As String, x As Double, y As Double, width As Double, height As Double)
		  // Xojo PDFDocument.AddLinkArea compatible method (Double overload)
		  // Adds an external URL link to a specified rectangular area on the current page
		  // url: The URL to link to
		  // x, y: Top-left corner of the link area (in user units)
		  // width, height: Dimensions of the link area

		  LinkString(x, y, width, height, url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726561746573206120636C69636B61626C652061726561206F6E207468652063757272656E7420706167652074686174206E617669676174657320746F20612074617267657420706167652E20436F6E76656E69656E6365207772617070657220666F72204164644C696E6B202B205365744C696E6B202B204C696E6B2E0A, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit))
		Sub AddGoToPageArea(page As Integer, x As Integer, y As Integer, width As Integer, height As Integer, targetY As Integer = 0)
		  // Creates a clickable area that navigates to a target page
		  // page: Target page number (1-based)
		  // x, y: Top-left corner of clickable area on current page (user units)
		  // width, height: Dimensions of clickable area
		  // targetY: Y position on target page (0 = top of page)

		  Dim linkID As Integer = AddLink()
		  Dim dTargetY As Double = targetY
		  Dim dX As Double = x
		  Dim dY As Double = y
		  Dim dW As Double = width
		  Dim dH As Double = height
		  SetLink(linkID, dTargetY, page)
		  Link(dX, dY, dW, dH, linkID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43726561746573206120636C69636B61626C652061726561206F6E207468652063757272656E7420706167652074686174206E617669676174657320746F20612074617267657420706167652E20436F6E76656E69656E6365207772617070657220666F72204164644C696E6B202B205365744C696E6B202B204C696E6B2E0A
		Sub AddGoToPageArea(page As Integer, x As Double, y As Double, width As Double, height As Double, targetY As Double = 0.0)
		  // Creates a clickable area that navigates to a target page (Double overload)
		  // page: Target page number (1-based)
		  // x, y: Top-left corner of clickable area on current page (user units)
		  // width, height: Dimensions of clickable area
		  // targetY: Y position on target page (0 = top of page)

		  Dim linkID As Integer = AddLink()
		  SetLink(linkID, targetY, page)
		  Link(x, y, width, height, linkID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2043726561746573206120636C69636B61626C6520617265612074686174206F70656E7320616E2065787465726E616C205044462066696C652E20436F6E76657274732066696C65207061746820746F2066696C653A2F2F2055524C206C696E6B2E0A, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit))
		Sub AddLinkToPDFArea(file As FolderItem, x As Integer, y As Integer, width As Integer, height As Integer)
		  // Xojo PDFDocument.AddLinkToPDFArea compatible method
		  // Creates a clickable area that opens an external PDF file
		  If file = Nil Or Not file.Exists Then
		    SetError("AddLinkToPDFArea: File does not exist")
		    Return
		  End If

		  Dim fileURL As String = "file://" + file.NativePath
		  Dim dX As Double = x
		  Dim dY As Double = y
		  Dim dW As Double = width
		  Dim dH As Double = height
		  LinkString(dX, dY, dW, dH, fileURL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2043726561746573206120636C69636B61626C6520617265612074686174206F70656E7320616E2065787465726E616C205044462066696C652E20436F6E76657274732066696C65207061746820746F2066696C653A2F2F2055524C206C696E6B2E0A
		Sub AddLinkToPDFArea(file As FolderItem, x As Double, y As Double, width As Double, height As Double)
		  // Xojo PDFDocument.AddLinkToPDFArea compatible method (Double overload)
		  // Creates a clickable area that opens an external PDF file
		  If file = Nil Or Not file.Exists Then
		    SetError("AddLinkToPDFArea: File does not exist")
		    Return
		  End If

		  Dim fileURL As String = "file://" + file.NativePath
		  LinkString(x, y, width, height, fileURL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 507574732061206C696E6B20746F20616E2065787465726E616C2055524C2E0A
		Sub LinkString(x As Double, y As Double, w As Double, h As Double, url As String)
		  // Add an external URL link area on the current page
		  // x, y: Top-left corner of the clickable rectangle (in user units)
		  // w, h: Width and height of the rectangle
		  // url: External URL to link to
		  
		  If mPage = 0 Then
		    Call SetError("Cannot create link: no page added yet")
		    Return
		  End If
		  
		  // Create link dictionary
		  Dim linkArea As New Dictionary
		  linkArea.Value("x") = x * mScaleFactor
		  linkArea.Value("y") = y * mScaleFactor
		  linkArea.Value("w") = w * mScaleFactor
		  linkArea.Value("h") = h * mScaleFactor
		  linkArea.Value("link") = 0
		  linkArea.Value("linkStr") = url
		  
		  // Add to page links
		  Dim pageKey As String = Str(mPage)
		  
		  // Get existing array or create new one
		  Dim links() As Variant
		  If mPageLinks.HasKey(pageKey) Then
		    links = mPageLinks.Value(pageKey)
		  End If
		  
		  // Add item and store back
		  links.Add(linkArea)
		  mPageLinks.Value(pageKey) = links
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E76657274732048544D4C20636F6E74656E7420746F205044462E20537570706F72747320706172616772617068732C20626F6C642C206974616C69632C20696D616765732C207461626C65732C206C697374732C2068656164696E67732E205265717569726573207072656D69756D2048544D4C2F4D61726B646F776E20496D706F7274206D6F64756C652E0A
		Sub LoadHTML(html As String, maxWidth As Double = 0, imageFolder As FolderItem = Nil)
		  // Convert HTML content to PDF using existing FPDF rendering methods
		  // html: HTML string to convert (supports Summernote/Word HTML with auto-cleaning)
		  // maxWidth: Maximum content width in user units (0 = use available page width)
		  // imageFolder: Folder containing images referenced by <img src="..."> (optional)

		  #If hasPremiumVNSHTMLModule Then
		    VNSPDFHTMLPremium.LoadHTML(Self, html, maxWidth, imageFolder)
		  #Else
		    #Pragma Unused html
		    #Pragma Unused maxWidth
		    #Pragma Unused imageFolder
		    SetError("LoadHTML requires the premium HTML/Markdown Import module.")
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E7665727473204D61726B646F776E20636F6E74656E7420746F205044462E20537570706F7274732068656164696E67732C20626F6C642C206974616C69632C206C697374732C20636F646520626C6F636B732C206C696E6B732C20696D616765732E205265717569726573207072656D69756D2048544D4C2F4D61726B646F776E20496D706F7274206D6F64756C652E0A
		Sub LoadMarkdown(markdown As String, maxWidth As Double = 0, imageFolder As FolderItem = Nil)
		  // Convert Markdown content to PDF using existing FPDF rendering methods
		  // markdown: Markdown string to convert
		  // maxWidth: Maximum content width in user units (0 = use available page width)
		  // imageFolder: Folder containing images referenced by ![](path) (optional)

		  #If hasPremiumVNSHTMLModule Then
		    VNSPDFHTMLPremium.LoadMarkdown(Self, markdown, maxWidth, imageFolder)
		  #Else
		    #Pragma Unused markdown
		    #Pragma Unused maxWidth
		    #Pragma Unused imageFolder
		    SetError("LoadMarkdown requires the premium HTML/Markdown Import module.")
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41646473206120646F63756D656E742D6C6576656C2066696C65206174746163686D656E7420746F20746865205044462E0A
		Sub AddAttachment(attachment As VNSPDFAttachment)
		  // Add a document-level file attachment to the PDF
		  // These attachments appear in the PDF reader's attachment panel
		  // attachment: A VNSPDFAttachment object with filename, content, and optional description

		  If attachment = Nil Then Return

		  mAttachments.Add(attachment)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473206D756C7469706C6520646F63756D656E742D6C6576656C206174746163686D656E7473206174206F6E63652E0A
		Sub SetAttachments(attachments() As VNSPDFAttachment)
		  // Set multiple document-level attachments at once
		  // This replaces any previously added attachments
		  // attachments: Array of VNSPDFAttachment objects

		  mAttachments = attachments
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612066696C65206174746163686D656E7420616E6E6F746174696F6E206F6E207468652063757272656E7420706167652E0A
		Sub AddAttachmentAnnotation(attachment As VNSPDFAttachment, x As Double, y As Double, w As Double, h As Double)
		  // Add a file attachment annotation on the current page
		  // This creates a clickable area that opens the attached file
		  // attachment: The VNSPDFAttachment to link to
		  // x, y: Top-left corner of the clickable rectangle (in user units)
		  // w, h: Width and height of the rectangle
		  // Note: No drawing is done - use Rect() or Cell() to indicate the link area

		  If attachment = Nil Then Return
		  If mPage = 0 Then
		    Call SetError("Cannot create attachment annotation: no page added yet")
		    Return
		  End If

		  CheckBounds(x, y, w, h, "AddAttachmentAnnotation")

		  // Create annotation dictionary with scaled coordinates
		  Dim annot As New Dictionary
		  annot.Value("attachment") = attachment
		  annot.Value("x") = x * mScaleFactor
		  annot.Value("y") = mPageHeightPt - y * mScaleFactor  // Convert to PDF coordinates
		  annot.Value("w") = w * mScaleFactor
		  annot.Value("h") = h * mScaleFactor

		  // Add to page attachments
		  Dim pageKey As String = Str(mPage)

		  // Get existing array or create new one
		  Dim annots() As Variant
		  If mPageAttachments.HasKey(pageKey) Then
		    annots = mPageAttachments.Value(pageKey)
		  End If

		  // Add item and store back
		  annots.Add(annot)
		  mPageAttachments.Value(pageKey) = annots
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061206669696C65206174746163686D656E7420616E6E6F746174696F6E2066726F6D206120466F6C6465724974656D2E20436F6D70617469626C65207769746820586F6A6F2773205044464469726563742E416464456D62656464656446696C652E, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit))
		Sub AddEmbeddedFile(file As FolderItem, x As Integer, y As Integer, width As Integer, height As Integer, description As String = "")
		  // Xojo PDFDocument.AddEmbeddedFile compatible method
		  // Adds a file attachment annotation on the current page from a FolderItem
		  // file: The file to embed
		  // x, y: Top-left corner of the clickable icon area (in user units, Integer for Xojo compatibility)
		  // width, height: Dimensions of the icon area
		  // description: Optional description for the attachment

		  If file = Nil Or Not file.Exists Then
		    SetError("AddEmbeddedFile: File does not exist")
		    Return
		  End If

		  // Read file content
		  Dim bs As BinaryStream = BinaryStream.Open(file, False)
		  If bs = Nil Then
		    SetError("AddEmbeddedFile: Cannot open file")
		    Return
		  End If

		  Dim content As String = bs.Read(bs.Length)
		  bs.Close

		  // Create attachment and add annotation
		  Dim attachment As New VNSPDFAttachment(file.Name, content, description)
		  Dim xD As Double = x
		  Dim yD As Double = y
		  Dim wD As Double = width
		  Dim hD As Double = height
		  AddAttachmentAnnotation(attachment, xD, yD, wD, hD)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061206669696C65206174746163686D656E7420616E6E6F746174696F6E2066726F6D206120466F6C6465724974656D2E20436F6D70617469626C65207769746820586F6A6F2773205044464469726563742E416464456D62656464656446696C652E
		Sub AddEmbeddedFile(file As FolderItem, x As Double, y As Double, width As Double, height As Double, description As String = "")
		  // Xojo PDFDocument.AddEmbeddedFile compatible method (Double overload)
		  // Adds a file attachment annotation on the current page from a FolderItem
		  // file: The file to embed
		  // x, y: Top-left corner of the clickable icon area (in user units)
		  // width, height: Dimensions of the icon area
		  // description: Optional description for the attachment

		  If file = Nil Or Not file.Exists Then
		    SetError("AddEmbeddedFile: File does not exist")
		    Return
		  End If

		  // Read file content
		  Dim bs As BinaryStream = BinaryStream.Open(file, False)
		  If bs = Nil Then
		    SetError("AddEmbeddedFile: Cannot open file")
		    Return
		  End If

		  Dim content As String = bs.Read(bs.Length)
		  bs.Close

		  // Create attachment and add annotation
		  Dim attachment As New VNSPDFAttachment(file.Name, content, description)
		  AddAttachmentAnnotation(attachment, x, y, width, height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20416464732061206D6F7669652066696C65206174746163686D656E7420616E6E6F746174696F6E2E20456D62656473207468652066696C6520616E642063726561746573206120636C69636B61626C6520616E6E6F746174696F6E2061726561206F6E207468652063757272656E7420706167652E2053616D6520617320416464456D62656464656446696C6520696E7465726E616C6C792E0A, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit))
		Sub AddEmbeddedMovie(file As FolderItem, x As Integer, y As Integer, width As Integer, height As Integer, description As String = "")
		  // Xojo PDFDocument.AddEmbeddedMovie compatible method
		  // PDF does not have native movie embedding - embeds as file attachment annotation
		  AddEmbeddedFile(file, x, y, width, height, description)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20416464732061206D6F7669652066696C65206174746163686D656E7420616E6E6F746174696F6E2E20456D62656473207468652066696C6520616E642063726561746573206120636C69636B61626C6520616E6E6F746174696F6E2061726561206F6E207468652063757272656E7420706167652E2053616D6520617320416464456D62656464656446696C6520696E7465726E616C6C792E0A
		Sub AddEmbeddedMovie(file As FolderItem, x As Double, y As Double, width As Double, height As Double, description As String = "")
		  // Xojo PDFDocument.AddEmbeddedMovie compatible method (Double overload)
		  // PDF does not have native movie embedding - embeds as file attachment annotation
		  AddEmbeddedFile(file, x, y, width, height, description)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2041646473206120736F756E642066696C65206174746163686D656E7420616E6E6F746174696F6E2E20456D62656473207468652066696C6520616E642063726561746573206120636C69636B61626C6520616E6E6F746174696F6E2061726561206F6E207468652063757272656E7420706167652E2053616D6520617320416464456D62656464656446696C6520696E7465726E616C6C792E0A, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit))
		Sub AddEmbeddedSound(file As FolderItem, x As Integer, y As Integer, width As Integer, height As Integer, description As String = "")
		  // Xojo PDFDocument.AddEmbeddedSound compatible method
		  // PDF does not have native sound embedding - embeds as file attachment annotation
		  AddEmbeddedFile(file, x, y, width, height, description)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2041646473206120736F756E642066696C65206174746163686D656E7420616E6E6F746174696F6E2E20456D62656473207468652066696C6520616E642063726561746573206120636C69636B61626C6520616E6E6F746174696F6E2061726561206F6E207468652063757272656E7420706167652E2053616D6520617320416464456D62656464656446696C6520696E7465726E616C6C792E0A
		Sub AddEmbeddedSound(file As FolderItem, x As Double, y As Double, width As Double, height As Double, description As String = "")
		  // Xojo PDFDocument.AddEmbeddedSound compatible method (Double overload)
		  // PDF does not have native sound embedding - embeds as file attachment annotation
		  AddEmbeddedFile(file, x, y, width, height, description)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612074657874206e6f746520616e6e6f746174696f6e2028737469636b79206e6f746529206f6e207468652063757272656e7420706167652e
		Sub AddTextAnnotation(message As String, x As Double, y As Double)
		  // Add a text annotation (sticky note/comment) on the current page
		  // This creates a clickable icon that shows the message in a popup
		  // message: The text to display when the annotation is clicked
		  // x, y: Position of the annotation icon (in user units)

		  If mPage = 0 Then
		    SetError("AddTextAnnotation: No page open")
		    Return
		  End If

		  CheckBounds(x, y, 0, 0, "AddTextAnnotation")

		  // Convert to PDF coordinates (points)
		  // mPageHeight is in user units (mm), so convert both to points
		  Dim xPt As Double = x * mScaleFactor
		  Dim yPt As Double = (mPageHeight - y) * mScaleFactor

		  // Create annotation dictionary
		  Dim annot As New Dictionary
		  annot.Value("message") = message
		  annot.Value("x") = xPt
		  annot.Value("y") = yPt

		  // Store for current page
		  Dim pageKey As String = Str(mPage)
		  Dim annots() As Variant
		  If mPageTextAnnotations.HasKey(pageKey) Then
		    annots = mPageTextAnnotations.Value(pageKey)
		  End If

		  annots.Add(annot)
		  mPageTextAnnotations.Value(pageKey) = annots
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061207465787420616E6E6F746174696F6E2028737469636B79206E6F746529206174207468652073706563696669656420636F6F7264696E617465732E20436F6D70617469626C65207769746820586F6A6F2773205044464469726563742E416464416E6E6F746174696F6E2E, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetiOS and (Target32Bit or Target64Bit))
		Sub AddAnnotation(message As String, x As Integer, y As Integer)
		  // Xojo PDFDocument.AddAnnotation compatible method
		  // Adds a widget to the current page at the coordinates passed that when clicked displays the message passed.
		  // message: The text to display when the annotation is clicked
		  // x, y: Position of the annotation icon (in user units, Integer for Xojo compatibility)

		  Dim xD As Double = x
		  Dim yD As Double = y
		  AddTextAnnotation(message, xD, yD)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061207465787420616E6E6F746174696F6E2028737469636B79206E6F746529206174207468652073706563696669656420636F6F7264696E617465732E20436F6D70617469626C65207769746820586F6A6F2773205044464469726563742E416464416E6E6F746174696F6E2E
		Sub AddAnnotation(message As String, x As Double, y As Double)
		  // Xojo PDFDocument.AddAnnotation compatible method (Double overload)
		  // Adds a widget to the current page at the coordinates passed that when clicked displays the message passed.
		  // message: The text to display when the annotation is clicked
		  // x, y: Position of the annotation icon (in user units)

		  AddTextAnnotation(message, x, y)
		End Sub
	#tag EndMethod

#tag Method, Flags = &h0, Description = 586F6A6F20504446446F63756D656E742E4164644C696E6520636F6D7061746962696C69747920777261707065722E2041646473206C696E6520746F2063757272656E7420706167652E0A
	Sub AddLine(x1 As Double, y1 As Double, x2 As Double, y2 As Double)
	  // Xojo PDFDocument.AddLine compatibility wrapper
	  // Note: Xojo's AddLine takes a PDFLine object, but for simplicity
	  // we provide a method that takes coordinates directly
	  //
	  // Parameters:
	  //   x1, y1 - Start point of line (in user units)
	  //   x2, y2 - End point of line (in user units)
	  //
	  // Example:
	  //   pdf.AddLine(10, 10, 100, 10)  // Horizontal line

	  Line(x1, y1, x2, y2)
	End Sub
#tag EndMethod

#tag Method, Flags = &h0, Description = 586F6A6F20504446446F63756D656E742E416464544F43456E74727920636F6D7061746962696C69747920777261707065722E204164647320626F6F6B6D61726B7320746F20646F63756D656E74206F75746C696E652E0A
	Sub AddTOCEntry(title As String, Optional pageNumber As Integer = 0, Optional level As Integer = 0)
	  // Xojo PDFDocument.AddTOCEntry compatibility wrapper
	  // Stores TOC entry for deferred bookmark creation (like Xojo does)
	  //
	  // Parameters:
	  //   title - Text to display in the bookmark
	  //   pageNumber - Page number to link to (0 = current page)
	  //   level - Hierarchy level (0 = top level, 1 = child, etc.)
	  //
	  // Example:
	  //   pdf.AddTOCEntry("Chapter 1", 1, 0)
	  //   pdf.AddTOCEntry("Section 1.1", 2, 1)
	  //
	  // Note: Bookmarks are created during PDF output, allowing TOC entries
	  // to reference pages that don't exist yet (Xojo-compatible behavior)

	  // Store the entry for deferred processing
	  Dim entry As New Dictionary
	  entry.Value("title") = title
	  entry.Value("pageNumber") = pageNumber
	  entry.Value("level") = level

	  mPendingTOCEntries.Add(entry)
	End Sub
#tag EndMethod

#tag Method, Flags = &h0, Description = 586F6A6F20504446446F63756D656E742E416464544F43456E74727920636F6D7061746962696C6974792E204163636570747320504446544F43456E747279206F626A656374732028506172616D4172726179292E0A
	Sub AddTOCEntry(ParamArray entries() As PDFTOCEntry)
	  // Xojo PDFDocument.AddTOCEntry full compatibility
	  // Accepts one or more PDFTOCEntry objects (Xojo's native class)
	  //
	  // Parameters:
	  //   entries - One or more PDFTOCEntry objects
	  //
	  // Example:
	  //   Dim entry1 As New PDFTOCEntry
	  //   entry1.Title = "Chapter 1"
	  //   entry1.Page = 1
	  //
	  //   Dim entry2 As New PDFTOCEntry
	  //   entry2.Title = "Section 1.1"
	  //   entry2.Page = 2
	  //
	  //   pdf.AddTOCEntry(entry1, entry2)
	  //
	  // Note: PDFTOCEntry uses Page property (not PageNumber), and hierarchy
	  // is managed through entry.AddEntry() method, not a Level property.

	  For Each entry As PDFTOCEntry In entries
	    If entry <> Nil Then
	      // Call the overloaded method with extracted properties
	      // IMPORTANT: PDFTOCEntry.Page is 0-based (pages 0, 1, 2...)
	      // but VNSPDFDocument uses 1-based pages (1, 2, 3...)
	      // Convert by adding 1
	      Dim page1Based As Integer = entry.Page + 1
	      AddTOCEntry(entry.Title, page1Based, 0)
	    End If
	  Next
	End Sub
#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F7574707574732061206C696E6520627265616B2E
		Sub Ln(h As Double = 0)
		  mCurrentX = mLeftMargin
		  If h = 0 Then
		    // Use font size in user units
		    mCurrentY = mCurrentY + (mFontSize / mScaleFactor)
		  Else
		    mCurrentY = mCurrentY + h
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E61626C6573206C6566742D746F2D72696768742074657874202864656661756C74292E
		Sub LTR()
		  // LTR enables left-to-right text direction (default mode).
		  // This is the standard text direction for most Western languages.
		  // Use this to reset text direction after using RTL().
		  
		  mIsRTL = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F7574707574732061206D756C74692D6C696E652063656C6C20776974682077C3B76F726420777261702E
		Sub MultiCell(w As Double, h As Double, txt As String, border As Variant = 0, align As String = "L", fill As Boolean = False)
		  // Check if page is active
		  If mPage = 0 Then
		    mError = mError + "Cannot output multicell: no page added yet." + EndOfLine
		    Return
		  End If
		  
		  // Check if font is set
		  If mCurrentFont = "" Then
		    mError = mError + "Cannot output multicell: no font selected. Call SetFont first." + EndOfLine
		    Return
		  End If
		  
		  // Width of 0 means extend to right margin
		  Dim cellWidth As Double = w
		  If cellWidth = 0 Then
		    cellWidth = mPageWidth - mRightMargin - mCurrentX
		  End If

		  CheckBounds(mCurrentX, mCurrentY, cellWidth, h, "MultiCell")

		  // Maximum width for text (accounting for margins)
		  Dim wMax As Double = cellWidth - 2 * mCellMargin

		  // Split text into lines - handle empty text (GB 12/03/26)
		  Dim lines() As String
		  If txt <> "" Then
		    lines = SplitTextToLines(txt, wMax)
		  Else
		    lines.Add("")
		  End If

		  // Parse border parameter using IsNumeric (GB 12/03/26)
		  Dim borderStr As String
		  Dim b, b2 As String
		  If border.IsNumeric Then
		    If border.IntegerValue = 1 Then
		      borderStr = "LTRB"
		      b = "LRT"
		      b2 = "LR"
		    Else
		      borderStr = ""
		      b = ""
		      b2 = ""
		    End If
		  Else
		    borderStr = border.StringValue.Uppercase
		    b = ""
		    If borderStr.IndexOf("L") >= 0 Then b = b + "L"
		    If borderStr.IndexOf("R") >= 0 Then b = b + "R"
		    If borderStr.IndexOf("T") >= 0 Then b = b + "T"
		    b2 = b.ReplaceAll("T", "")
		  End If
		  
		  // Output each line
		  For i As Integer = 0 To lines.LastIndex
		    // Determine border for this line
		    Dim currentBorder As String
		    If i = 0 And lines.Count = 1 Then
		      currentBorder = borderStr // Single line: output all borders (GB 15/12/25)
		    ElseIf i = 0 And lines.Count > 1 Then
		      currentBorder = b // First line of multi-line: top border (GB 15/12/25)
		    ElseIf i = lines.LastIndex Then
		      currentBorder = b2
		      If borderStr.IndexOf("B") >= 0 Then
		        currentBorder = currentBorder + "B" // Last line: bottom border
		      End If
		    Else
		      currentBorder = b2 // Middle lines: left and right borders only
		    End If

		    // Output the cell for this line
		    // ln=2 moves to left margin of next line, not continuation of current line (GB 14/12/25)
		    If align.Uppercase = "J" Then
		      // Justify: set word spacing for all lines except the last
		      If i < lines.LastIndex Then
		        Dim lineWidth As Double = GetStringWidth(lines(i))
		        Dim spaceCount As Integer = 0
		        Dim lineText As String = lines(i)
		        For ci As Integer = 0 To lineText.Length - 1
		          If lineText.Middle(ci, 1) = " " Then spaceCount = spaceCount + 1
		        Next
		        If spaceCount > 0 And lineWidth < wMax Then
		          Call SetWordSpacing((wMax - lineWidth) / spaceCount)
		        End If
		        Call Cell(cellWidth, h, lines(i), currentBorder, 2, "L", fill)
		        Call SetWordSpacing(0)
		      Else
		        // Last line: left-aligned, no extra spacing
		        Call Cell(cellWidth, h, lines(i), currentBorder, 2, "L", fill)
		      End If
		    Else
		      Call Cell(cellWidth, h, lines(i), currentBorder, 2, align, fill)
		    End If
		  Next

		  // Reset position to start of next line after MultiCell (GB 07/01/26)
		  mCurrentX = mLeftMargin
		  mCurrentY = mCurrentY + h

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F7574707574732061206D756C74692D6C696E652063656C6C207769746820656E756D2D6261736564207465787420616C69676E6D656E742E2044656C65676174657320746F204D756C746943656C6C28292E
		Sub MultiCell(w As Double, h As Double, txt As String, border As Variant, align As VNSPDFModule.eTextAlignment, fill As Boolean = False)
		  // Enum overload for MultiCell() - converts alignment enum to string and delegates
		  Call MultiCell(w, h, txt, border, AlignmentEnumToString(align), fill)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub NewObj(forcedObjNum As Integer = 0)
		  // Begin a new object
		  // If forcedObjNum is provided, use that object number (for Pages root = 1, Resources = 2)
		  // Otherwise auto-increment
		  Dim objNum As Integer
		  If forcedObjNum > 0 Then
		    objNum = forcedObjNum
		    If forcedObjNum >= mObjectNumber Then
		      mObjectNumber = forcedObjNum + 1
		    End If
		  Else
		    objNum = mObjectNumber
		    mObjectNumber = mObjectNumber + 1
		  End If
		  
		  mOffsets.Value(Str(objNum)) = VNSPDFModule.StringLenB(mBuffer)
		  Call Put(Str(objNum) + " 0 obj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207472756520696620616E206572726F7220686173206F636375727265642E0A
		Function Ok() As Boolean
		  // Returns true if no error has occurred
		  Return mError = ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 47656E6572617465732074686520636F6D706C6574652050444620646F63756D656E7420616E642072657475726E7320697420617320612062696E61727920737472696E672E0A
		Function Output() As String
		  // Check if document has any pages
		  If mPage = 0 Then
		    mError = "Cannot output PDF: no pages added to document."
		    Return ""
		  End If
		  
		  // Close document if not already closed
		  If mState < 3 Then
		    Call CloseDocument()
		  End If
		  
		  // Return the complete PDF buffer
		  Return mBuffer

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F757470757473207468652050444620646F63756D656E74206173206120737472696E6720616E6420636C6F7365732069742E20436F6D62696E6573204F7574707574282920616E6420436C6F7365282920696E20612073696E676C652063616C6C2E0A
		Function OutputAndClose() As String
		  // Outputs the PDF document as a string and closes it.
		  // Combines Output() and Close() in a single call.
		  // This is a convenience method matching go-fpdf's OutputAndClose().
		  //
		  // Returns: The complete PDF as a string, or empty string on error
		  //
		  // Example:
		  //   Dim pdfData As String = pdf.OutputAndClose()
		  //   If pdfData <> "" Then
		  //     // Save or process pdfData
		  //   End If

		  Dim result As String = Output()
		  Call Close()
		  Return result

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F75747075747320746865205044462064617368207061747465726E20636F6D6D616E642E
		Sub OutputDashPattern()
		  // Build dash pattern string: [dash1 gap1 dash2 gap2...] phase d
		  Dim cmd As String = "["
		  
		  For i As Integer = 0 To mDashArray.LastIndex
		    If i > 0 Then
		      cmd = cmd + " "
		    End If
		    cmd = cmd + FormatPDF(mDashArray(i))
		  Next
		  
		  cmd = cmd + "] " + FormatPDF(mDashPhase) + " d" + EndOfLine.UNIX
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OutputFontSelection()
		  // Output font selection command: /F1 12 Tf
		  If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		    Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		    Dim fontNum As Integer = fontInfo.Value("number")
		    Dim cmd As String = "/F" + Str(fontNum) + " " + FormatPDF(mFontSizePt) + " Tf" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OutputTextColor()
		  // Output text color command before text rendering: r g b rg
		  // Convert to PDF color space (0-1)
		  Dim rPDF As Double = mTextColorR / 255.0
		  Dim gPDF As Double = mTextColorG / 255.0
		  Dim bPDF As Double = mTextColorB / 255.0
		  
		  Dim cmd As String = FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " rg" + EndOfLine.UNIX
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206E756D626572206F66207061676573206F662074686520646F63756D656E742E0A
		Function PageCount() As Integer
		  // Return the total number of pages in the document
		  // Returns count of pages (1-based numbering)
		  // Note: mPages only contains flushed page buffers (previous pages).
		  // The current page is still in mBuffer until the next AddPage or Close.
		  // Use mPage which tracks the actual page count.

		  Return mPage
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520637572726E742070616765206E756D6265722E0A
		Function PageNo() As Integer
		  Return mPage
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732064696D656E73696F6E73206F66206120737065636966696320706167652062792070616765206E756D6265722E0A
		Function PageSize(pageNum As Integer, ByRef width As Double, ByRef height As Double) As Boolean
		  // Returns dimensions of a specific page by page number
		  // pageNum: Page number (1-based index)
		  // width, height: Output parameters for page dimensions
		  // Returns: True if page exists, False otherwise
		  
		  // Validate page number
		  If pageNum < 1 Or pageNum > mPages.KeyCount Then
		    Return False
		  End If
		  
		  // Check if this page has custom dimensions stored
		  Dim pageKey As String = Str(pageNum)
		  If mPageSizes.HasKey(pageKey) Then
		    // Retrieve custom page dimensions from dictionary
		    Dim pageSizePair As Pair = mPageSizes.Value(pageKey)
		    Dim widthPt As Double = pageSizePair.Left
		    Dim heightPt As Double = pageSizePair.Right
		    
		    // Convert from points to user units
		    width = widthPt / mScaleFactor
		    height = heightPt / mScaleFactor
		  Else
		    // Use default page dimensions (shouldn't happen, but fallback)
		    width = mDefPageSize.Left / mScaleFactor
		    height = mDefPageSize.Right / mScaleFactor
		  End If
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4F75747075747320612050444620706F696E74206D6F766520636F6D6D616E6420286D29207573656420666F722064726177696E672070617468732E0A
		Private Sub PointTo(x As Double, y As Double)
		  // Outputs a PDF point move command (m) at coordinates (x, y)
		  // Used as starting point for path drawing operations
		  
		  Dim cmd As String
		  cmd = FormatPDF(x * mScaleFactor, 2) + " "
		  cmd = cmd + FormatPDF((mPageHeight - y) * mScaleFactor, 2) + " m" + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4472617773206120706F6C79676F6E2077697468207374726169676874206C696E6573206265747765656E20706F696E74732E0A
		Sub Polygon(points() As Pair, style As String = "D")
		  // Draws a closed polygon with straight lines connecting the specified points
		  // points: array of Pair objects representing (x, y) coordinates
		  // style: "D" (draw), "F" (fill), or "FD"/"DF" (both)
		  
		  If Err() Then Return
		  If mPage = 0 Then
		    Call SetError("Cannot draw: no page added yet")
		    Return
		  End If
		  
		  If points.LastIndex < 2 Then
		    Call SetError("Polygon requires at least 3 points")
		    Return
		  End If
		  
		  // Determine draw operation
		  Dim op As String = FillDrawOp(style)
		  
		  Const prec As Integer = 5
		  Dim k As Double = mScaleFactor
		  Dim h As Double = mPageHeight
		  Dim cmd As String
		  
		  // Move to first point
		  Dim pt As Pair = points(0)
		  cmd = FormatPDF(pt.Left * k, prec) + " " + FormatPDF((h - pt.Right) * k, prec) + " m" + EndOfLine.UNIX
		  
		  // Draw lines to subsequent points
		  For i As Integer = 1 To points.LastIndex
		    pt = points(i)
		    cmd = cmd + FormatPDF(pt.Left * k, prec) + " " + FormatPDF((h - pt.Right) * k, prec) + " l" + EndOfLine.UNIX
		  Next
		  
		  // Close path and draw back to first point
		  pt = points(0)
		  cmd = cmd + FormatPDF(pt.Left * k, prec) + " " + FormatPDF((h - pt.Right) * k, prec) + " l" + EndOfLine.UNIX
		  cmd = cmd + op + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4472617773206120706F6C79676F6E207573696E672074686520706F696E74732070726F76696465642E
		Sub Polygon(points() As Point, style As String = "D")
		  // Draws a closed polygon using the provided points.
		  // Each Point contains X, Y coordinates in user units.
		  // style: "D" (draw outline), "F" (fill), "DF" or "FD" (both)
		  
		  If mPage = 0 Then
		    mError = mError + "Cannot draw polygon: no page added yet." + EndOfLine
		    Return
		  End If
		  
		  // Need at least 3 points to form a polygon
		  If points.Count < 3 Then
		    mError = mError + "Cannot draw polygon: need at least 3 points." + EndOfLine
		    Return
		  End If
		  
		  Dim cmd As String = ""
		  
		  // First point: move to
		  Dim firstX As Double = points(0).X
		  Dim firstY As Double = points(0).Y
		  cmd = FormatPDF(firstX * mScaleFactor) + " "
		  cmd = cmd + FormatPDF((mPageHeight - firstY) * mScaleFactor) + " m" + EndOfLine.UNIX
		  
		  // Subsequent points: line to
		  For i As Integer = 1 To points.LastIndex
		    Dim px As Double = points(i).X
		    Dim py As Double = points(i).Y
		    cmd = cmd + FormatPDF(px * mScaleFactor) + " "
		    cmd = cmd + FormatPDF((mPageHeight - py) * mScaleFactor) + " l" + EndOfLine.UNIX
		  Next
		  
		  // Apply style with proper path closing
		  // Use 'h' (closepath) combined with operators for proper line joins at all corners
		  // s = close and stroke, f = fill (auto-closes), b = close, fill and stroke
		  Dim styleUpper As String = style.Uppercase
		  Select Case styleUpper
		  Case "F"
		    cmd = cmd + "f" + EndOfLine.UNIX  // Fill only (implicitly closes path)
		  Case "DF", "FD"
		    cmd = cmd + "b" + EndOfLine.UNIX  // Close path, fill and stroke
		  Else
		    cmd = cmd + "s" + EndOfLine.UNIX  // Close path and stroke (default)
		  End Select
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Put(s As String)
		  mBuffer = mBuffer + s + EndOfLine.UNIX
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4F757470757473206772617068696373207374617465206F626A6563747320666F7220616C706861207472616E73706172656E6379206F7065726174696F6E732E0A
		Private Sub PutBlendModes()
		  // Output graphics state objects for alpha/transparency
		  Dim count As Integer = mBlendList.Count
		  
		  // Loop through blend list starting at index 1 (skip index 0 placeholder)
		  For j As Integer = 1 To count - 1
		    Dim bl As VNSPDFBlendMode = mBlendList(j)
		    
		    // Create new PDF object for this graphics state
		    Call NewObj()
		    bl.objNum = mObjectNumber
		    
		    // Output ExtGState dictionary
		    Call Put("<</Type /ExtGState /ca " + bl.fillStr + " /CA " + bl.strokeStr + " /BM /" + bl.modeStr + ">>")
		    Call Put("endobj")
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4F7574707574732074686520626F6F6B6D61726B2F6F75746C696E65207472656520746F2050444620636174616C6F672E0A
		Private Sub PutBookmarks()
		  // Output bookmark/outline tree structure
		  Dim nb As Integer = mOutlines.Count
		  If nb = 0 Then Return
		  
		  // Build tree structure (parent/prev/next/first/last)
		  Dim lru As New Dictionary // Last item at each level
		  Dim level As Integer = 0
		  
		  For i As Integer = 0 To mOutlines.LastIndex
		    Dim o As Dictionary = mOutlines(i)
		    Dim oLevel As Integer = o.Value("level")
		    
		    If oLevel > 0 Then
		      Dim parent As Integer = lru.Value(Str(oLevel - 1))
		      mOutlines(i).Value("parent") = parent
		      mOutlines(parent).Value("last") = i
		      If oLevel > level Then
		        mOutlines(parent).Value("first") = i
		      End If
		    Else
		      mOutlines(i).Value("parent") = nb
		    End If
		    
		    If oLevel <= level And i > 0 Then
		      Dim prev As Integer = lru.Value(Str(oLevel))
		      mOutlines(prev).Value("next") = i
		      mOutlines(i).Value("prev") = prev
		    End If
		    
		    lru.Value(Str(oLevel)) = i
		    level = oLevel
		  Next
		  
		  // Write outline objects
		  Dim nStart As Integer = mObjectNumber

		  For i As Integer = 0 To mOutlines.LastIndex
		    Dim o As Dictionary = mOutlines(i)
		    
		    Call NewObj()
		    Call Put("<</Title " + TextString(o.Value("text")))
		    Call Put("/Parent " + Str(nStart + o.Value("parent")) + " 0 R")
		    
		    If o.HasKey("prev") And o.Value("prev") <> -1 Then
		      Call Put("/Prev " + Str(nStart + o.Value("prev")) + " 0 R")
		    End If
		    
		    If o.HasKey("next") And o.Value("next") <> -1 Then
		      Call Put("/Next " + Str(nStart + o.Value("next")) + " 0 R")
		    End If
		    
		    If o.HasKey("first") And o.Value("first") <> -1 Then
		      Call Put("/First " + Str(nStart + o.Value("first")) + " 0 R")
		    End If
		    
		    If o.HasKey("last") And o.Value("last") <> -1 Then
		      Call Put("/Last " + Str(nStart + o.Value("last")) + " 0 R")
		    End If
		    
		    Dim destPage As Integer = o.Value("p")
		    Dim destY As Double = o.Value("y")
		    
		    // Calculate page object number (must match PutPages allocation)
		    // Includes attachment object offset
		    Dim pageObj As Integer = 3 + mAttachmentObjectOffset + (destPage - 1) * 2
		    
		    // Get page height in points for coordinate conversion
		    Dim h As Double
		    If mPageSizes.HasKey(Str(destPage)) Then
		      Dim size As Pair = mPageSizes.Value(Str(destPage))
		      h = size.Right
		    Else
		      h = mDefPageSize.Right
		    End If
		    
		    Call Put("/Dest [" + Str(pageObj) + " 0 R /XYZ 0 " + FormatPDF(h - destY * mScaleFactor) + " null]")
		    Call Put("/Count 0>>")
		    Call Put("endobj")
		  Next
		  
		  // Outline root object
		  Call NewObj()
		  mOutlineRoot = mObjectNumber - 1
		  
		  // Count top-level bookmarks
		  Dim cnt As Integer = 0
		  For i As Integer = 0 To mOutlines.LastIndex
		    If mOutlines(i).Value("level") = 0 Then cnt = cnt + 1
		  Next
		  
		  Call Put("<</Type /Outlines /First " + Str(nStart) + " 0 R")
		  Call Put("/Last " + Str(nStart + mOutlines.LastIndex) + " 0 R>>")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutCatalog()
		  // Output the Catalog dictionary (document root)
		  Call NewObj()
		  mCatalogObjectNumber = mObjectNumber - 1 // Save for trailer
		  Call Put("<<")
		  Call Put("/Type /Catalog")
		  Call Put("/Pages 1 0 R") // Pages root is object 1
		  
		  // Output intents (for PDF/A compliance)
		  Call PutOutputIntents()
		  
		  // XMP metadata (if set)
		  If mXmpObjectNumber > 0 Then
		    Call Put("/Metadata " + Str(mXmpObjectNumber) + " 0 R")
		  End If
		  
		  If mOutlines.Count > 0 Then
		    Call Put("/Outlines " + Str(mOutlineRoot) + " 0 R")
		    Call Put("/PageMode /UseOutlines")
		  End If
		  If mLang <> "" Then
		    Call Put("/Lang (" + mLang + ")")
		  End If

		  // Embedded files (document-level attachments)
		  If mAttachments.Count > 0 Then
		    Dim namesTree As String = GetEmbeddedFilesTree()
		    If namesTree <> "" Then
		      Call Put("/Names << /EmbeddedFiles " + namesTree + " >>")
		    End If

		    // PDF/A-3: Add /AF array for attachments with AFRelationship
		    Dim afRefs() As String
		    For i As Integer = 0 To mAttachments.LastIndex
		      Dim att As VNSPDFAttachment = mAttachments(i)
		      If att.AFRelationship <> "" And att.ObjectNumber > 0 Then
		        afRefs.Add(Str(att.ObjectNumber) + " 0 R")
		      End If
		    Next
		    If afRefs.Count > 0 Then
		      Call Put("/AF [" + String.FromArray(afRefs, " ") + "]")
		    End If
		  End If

		  // AcroForm (interactive forms) - reference if form fields exist
		  If mAcroFormObjectNumber > 0 Then
		    Call Put("/AcroForm " + Str(mAcroFormObjectNumber) + " 0 R")
		  End If

		  // Display mode (zoom and page layout) - contribution: Geoff Bridges
		  Call PutDisplayMode()

		  Call Put(">>")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4F757470757473207A6F6F6D20616E6420706167652F6C61796F757420646972656374697665732E2043616C6C65642066726F6D2050757443617461
		Private Sub PutDisplayMode()
		  // Outputs /OpenAction (zoom) and /PageLayout directives into the Catalog dictionary
		  // Called from PutCatalog. Contribution: Geoff Bridges

		  // Zoom mode -> /OpenAction
		  Select Case mZoomMode
		  Case "fullpage"
		    Call Put("/OpenAction [3 0 R /Fit]")
		  Case "fullwidth"
		    Call Put("/OpenAction [3 0 R /FitH null]")
		  Case "real"
		    Call Put("/OpenAction [3 0 R /XYZ null null 1]")
		  Case "default"
		    // No /OpenAction - let viewer use its default
		  Else
		    // Numeric zoom percentage (e.g. "75" -> 0.75, "200" -> 2.00)
		    If mZoomMode.IsNumeric Then
		      Dim zoomFactor As Double = CDbl(mZoomMode) / 100.0
		      Call Put("/OpenAction [3 0 R /XYZ null null " + FormatPDF(zoomFactor, 2) + "]")
		    End If
		  End Select

		  // Layout mode -> /PageLayout
		  Select Case mLayoutMode
		  Case "single", "SinglePage"
		    Call Put("/PageLayout /SinglePage")
		  Case "continuous", "OneColumn"
		    Call Put("/PageLayout /OneColumn")
		  Case "two", "TwoColumnLeft"
		    Call Put("/PageLayout /TwoColumnLeft")
		  Case "TwoColumnRight"
		    Call Put("/PageLayout /TwoColumnRight")
		  Case "TwoPageLeft"
		    Call Put("/PageLayout /TwoPageLeft")
		  Case "TwoPageRight"
		    Call Put("/PageLayout /TwoPageRight")
		  Case "default"
		    // No /PageLayout - let viewer use its default
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865202F4E616D6573207472656520737472696E6720666F7220656D6265646465642066696C657320636174616C6F6720656E7472792E0A
		Private Function GetEmbeddedFilesTree() As String
		  // Returns the /Names tree string for embedded files catalog entry
		  // Called from PutCatalog when there are document-level attachments

		  If mAttachments.Count = 0 Then Return ""

		  Dim names() As String
		  For i As Integer = 0 To mAttachments.LastIndex
		    Dim a As VNSPDFAttachment = mAttachments(i)
		    If a.ObjectNumber > 0 Then
		      names.Add("(" + a.Filename + ") " + Str(a.ObjectNumber) + " 0 R")
		    End If
		  Next

		  If names.Count = 0 Then Return ""

		  Return "<< /Names [" + String.FromArray(names, " ") + "] >>"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 456D6265647320612073696E676C65206174746163686D656E7420616E64207365747320697473206F626A6563744E756D6265722E0A
		Private Sub EmbedAttachment(a As VNSPDFAttachment)
		  // Embeds a single attachment and sets its objectNumber
		  // Called from PutAttachments and PutAnnotationsAttachments

		  If a = Nil Then Return
		  If a.ObjectNumber > 0 Then Return  // Already embedded

		  // Get content and checksum
		  Dim content As String = a.Content
		  Dim checksum As String = a.Checksum
		  Dim lenUncompressed As Integer = content.Bytes

		  // Compress content if compression is enabled
		  Dim compressed As String = content
		  Dim useCompression As Boolean = mCompression
		  If useCompression Then
		    Dim compressedData As String = VNSZlibModule.Compress(content)
		    If compressedData <> "" And compressedData.Bytes < lenUncompressed Then
		      compressed = compressedData
		    Else
		      useCompression = False
		    End If
		  End If
		  Dim lenCompressed As Integer = compressed.Bytes

		  // Write EmbeddedFile stream object
		  Call NewObj()
		  Dim streamObjNum As Integer = mObjectNumber - 1
		  Dim streamDict As String = "<< /Type /EmbeddedFile"
		  // PDF/A-3: Add /Subtype with MIME type when set
		  If a.MimeType <> "" Then
		    streamDict = streamDict + " /Subtype /" + a.MimeType.ReplaceAll("/", "#2F")
		  End If
		  streamDict = streamDict + " /Length " + Str(lenCompressed)
		  If useCompression Then
		    streamDict = streamDict + " /Filter /FlateDecode"
		  End If
		  // Build /Params dictionary
		  Dim paramsDict As String = " /Params << /CheckSum <" + checksum + "> /Size " + Str(lenUncompressed)
		  // PDF/A-3: Add /ModDate when MimeType is set (required for compliance)
		  If a.MimeType <> "" Then
		    Dim now As DateTime = DateTime.Now
		    Dim modDate As String = "D:" + now.Year.ToString("0000") + now.Month.ToString("00") + now.Day.ToString("00")
		    modDate = modDate + now.Hour.ToString("00") + now.Minute.ToString("00") + now.Second.ToString("00")
		    paramsDict = paramsDict + " /ModDate (" + modDate + ")"
		  End If
		  paramsDict = paramsDict + " >>"
		  streamDict = streamDict + paramsDict + " >>"
		  Call Put(streamDict)

		  // Write stream data
		  mBuffer = mBuffer + "stream" + EndOfLine.UNIX
		  mBuffer = mBuffer + compressed
		  mBuffer = mBuffer + EndOfLine.UNIX
		  Call Put("endstream")
		  Call Put("endobj")

		  // Write Filespec object
		  Call NewObj()
		  a.ObjectNumber = mObjectNumber - 1
		  Dim filespec As String = "<< /Type /Filespec /F (" + a.Filename + ") /UF " + TextString(UTF8ToUTF16BE(a.Filename, True))
		  filespec = filespec + " /EF << /F " + Str(streamObjNum) + " 0 R >>"
		  filespec = filespec + " /Desc " + TextString(UTF8ToUTF16BE(a.Description, True))
		  // PDF/A-3: Add /AFRelationship when set
		  If a.AFRelationship <> "" Then
		    filespec = filespec + " /AFRelationship /" + a.AFRelationship
		  End If
		  filespec = filespec + " >>"
		  Call Put(filespec)
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 456D6265647320616C6C20646F63756D656E742D6C6576656C206174746163686D656E74732E0A
		Private Sub PutAttachments()
		  // Embeds all document-level attachments
		  // Called from CloseDocument before PutCatalog

		  For i As Integer = 0 To mAttachments.LastIndex
		    Call EmbedAttachment(mAttachments(i))
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 43616C63756C6174657320746F74616C206E756D626572206F66206F626A6563747320726571756972656420666F7220616C6C206174746163686D656E74732E0A
		Private Function GetAttachmentObjectCount() As Integer
		  // Each attachment requires 2 objects: stream + filespec
		  // Count all unique attachments (document-level and page-level)

		  Dim count As Integer = 0

		  // Document-level attachments
		  count = count + mAttachments.Count * 2

		  // Page-level attachments (count unique only)
		  Dim counted As New Dictionary
		  For Each pageKey As Variant In mPageAttachments.Keys
		    Dim annots() As Variant = mPageAttachments.Value(pageKey)
		    For Each annotVar As Variant In annots
		      Dim annot As Dictionary = annotVar
		      Dim a As VNSPDFAttachment = annot.Value("attachment")
		      If a <> Nil And Not counted.HasKey(a) Then
		        count = count + 2
		        counted.Value(a) = True
		      End If
		    Next
		  Next

		  Return count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 456D6265647320616C6C20706167652D6C6576656C206174746163686D656E7420616E6E6F746174696F6E732E0A
		Private Sub PutAnnotationsAttachments()
		  // Embeds all page-level attachment annotations
		  // Called from CloseDocument before PutPages

		  // Collect all unique attachments from page annotations
		  Dim embedded As New Dictionary

		  For Each pageKey As Variant In mPageAttachments.Keys
		    Dim annots() As Variant = mPageAttachments.Value(pageKey)
		    For Each annotVar As Variant In annots
		      Dim annot As Dictionary = annotVar
		      Dim a As VNSPDFAttachment = annot.Value("attachment")
		      If a <> Nil And Not embedded.HasKey(a) Then
		        Call EmbedAttachment(a)
		        embedded.Value(a) = True
		      End If
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutEncryption()
		  // Output encryption dictionary if encryption is enabled
		  If mEncryption = Nil Then Return
		  
		  // Allocate object number for encryption dictionary
		  Call NewObj()
		  mEncryptionObjectNumber = mObjectNumber - 1
		  
		  // NOTE: Encryption keys were already generated BEFORE PutPages() was called
		  // (See Output() method where GenerateKeys() is called early)
		  // We just output the encryption dictionary here
		  
		  // Get the encryption dictionary from VNSPDFEncryption
		  Dim encDict As String = mEncryption.GetEncryptionDictionary()
		  
		  // Output encryption dictionary object
		  Call Put(encDict)
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutGradients()
		  // Output shading pattern objects for gradients
		  Dim count As Integer = mGradientList.Count

		  // Loop through all gradients starting at index 0
		  For j As Integer = 0 To count - 1
		    Dim gr As VNSPDFGradient = mGradientList(j)
		    Dim mainFuncObj As Integer = 0

		    // Check if this is a multi-stop gradient
		    If gr.colorStops.Count > 2 Then
		      // Multi-stop gradient: create FunctionType 3 (stitching function)
		      // First, create FunctionType 2 objects for each segment
		      Dim segmentFuncs() As Integer
		      For i As Integer = 0 To gr.colorStops.LastIndex - 1
		        Dim c0 As String = gr.colorStops(i).Right.StringValue
		        Dim c1 As String = gr.colorStops(i + 1).Right.StringValue
		        Call NewObj()
		        segmentFuncs.Add(mObjectNumber - 1)
		        Call Put("<</FunctionType 2 /Domain [0.0 1.0] /C0 [" + c0 + "] /C1 [" + c1 + "] /N 1>>")
		        Call Put("endobj")
		      Next

		      // Build bounds array (positions between 0 and 1 where segments meet)
		      Dim bounds As String = ""
		      For i As Integer = 1 To gr.colorStops.LastIndex - 1
		        If bounds <> "" Then bounds = bounds + " "
		        bounds = bounds + FormatPDF(gr.colorStops(i).Left.DoubleValue, 4)
		      Next

		      // Build functions reference array
		      Dim funcsRef As String = ""
		      For i As Integer = 0 To segmentFuncs.LastIndex
		        If funcsRef <> "" Then funcsRef = funcsRef + " "
		        funcsRef = funcsRef + Str(segmentFuncs(i)) + " 0 R"
		      Next

		      // Build encode array (0 1 for each segment)
		      Dim encode As String = ""
		      For i As Integer = 0 To segmentFuncs.LastIndex
		        If encode <> "" Then encode = encode + " "
		        encode = encode + "0 1"
		      Next

		      // Create stitching function (FunctionType 3)
		      Call NewObj()
		      mainFuncObj = mObjectNumber - 1
		      Call Put("<</FunctionType 3 /Domain [0 1] /Functions [" + funcsRef + "] /Bounds [" + bounds + "] /Encode [" + encode + "]>>")
		      Call Put("endobj")

		    Else
		      // Simple 2-color gradient: use FunctionType 2
		      If gr.tp = 2 Or gr.tp = 3 Then
		        Call NewObj()
		        mainFuncObj = mObjectNumber - 1
		        Call Put("<</FunctionType 2 /Domain [0.0 1.0] /C0 [" + gr.clr1Str + "] /C1 [" + gr.clr2Str + "] /N 1>>")
		        Call Put("endobj")
		      End If
		    End If

		    // Create shading object
		    Call NewObj()
		    Call Put("<</ShadingType " + Str(gr.tp) + " /ColorSpace /DeviceRGB")

		    If gr.tp = 2 Then
		      // Linear gradient: needs start and end coordinates
		      Dim coords As String = "/Coords [" + FormatPDF(gr.x1, 5) + " " + FormatPDF(gr.y1, 5) + " " + _
		      FormatPDF(gr.x2, 5) + " " + FormatPDF(gr.y2, 5) + "] /Function " + Str(mainFuncObj) + " 0 R /Extend [true true]>>"
		      Call Put(coords)
		    ElseIf gr.tp = 3 Then
		      // Radial gradient: needs two circles (start and end)
		      Dim coords As String = "/Coords [" + FormatPDF(gr.x1, 5) + " " + FormatPDF(gr.y1, 5) + " 0 " + _
		      FormatPDF(gr.x2, 5) + " " + FormatPDF(gr.y2, 5) + " " + FormatPDF(gr.r, 5) + _
		      "] /Function " + Str(mainFuncObj) + " 0 R /Extend [true true]>>"
		      Call Put(coords)
		    End If

		    Call Put("endobj")

		    // Store the shading object number in the gradient structure
		    gr.objNum = mObjectNumber - 1
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutHeader()
		  mBuffer = mBuffer + "%PDF-" + mPDFVersion + EndOfLine.UNIX
		  mBuffer = mBuffer + "%âãÏÓ" + EndOfLine.UNIX
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutImages()
		  // Output image XObjects

		  // Ensure object 2 is reserved for Resources dictionary
		  If mObjectNumber < 3 Then
		    mObjectNumber = 3
		  End If

		  // Image index is already assigned during RegisterImage()
		  For Each imageKey As Variant In mImages.Keys
		    Dim imageInfo As Dictionary = mImages.Value(imageKey)
		    Dim imageType As String = imageInfo.Value("type")
		    
		    If imageType = "jpeg" Then
		      Call PutJPEGImage(imageInfo)
		    ElseIf imageType = "png" Then
		      Call PutPNGImage(imageInfo)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutImportedObjects()
		  // Output imported PDF objects (fonts, resources, etc.)
		  // This is called during Output() to write objects that were copied from source PDF

		  If mImportedObjects = Nil Or mImportedObjects.KeyCount = 0 Then
		    Return
		  End If

		  // Ensure object 2 is reserved for Resources dictionary
		  If mObjectNumber < 3 Then
		    mObjectNumber = 3
		  End If

		  // First pass: Assign real object numbers to all placeholders
		  mPlaceholderToReal = New Dictionary
		  For Each placeholderKey As Variant In mImportedObjects.Keys
		    Dim placeholderNum As Integer = Val(placeholderKey.StringValue)
		    Dim realNum As Integer = mObjectNumber
		    mObjectNumber = mObjectNumber + 1
		    mPlaceholderToReal.Value(placeholderKey) = realNum
		  Next

		  // Update mImportedObjectMap to use real numbers
		  For Each sourceKey As Variant In mImportedObjectMap.Keys
		    Dim placeholderNum As Integer = mImportedObjectMap.Value(sourceKey)
		    If mPlaceholderToReal.HasKey(Str(placeholderNum)) Then
		      Dim realNum As Integer = mPlaceholderToReal.Value(Str(placeholderNum))
		      mImportedObjectMap.Value(sourceKey) = realNum
		    End If
		  Next

		  // Second pass: Output each object with placeholder references replaced
		  For Each placeholderKey As Variant In mImportedObjects.Keys
		    Dim objContent As String = mImportedObjects.Value(placeholderKey)
		    Dim realNum As Integer = mPlaceholderToReal.Value(placeholderKey)

		    // Replace all placeholder references in content with real references
		    For Each ph As Variant In mPlaceholderToReal.Keys
		      Dim phNum As Integer = Val(ph.StringValue)
		      Dim rNum As Integer = mPlaceholderToReal.Value(ph)
		      // Replace "placeholder 0 R" with "real 0 R"
		      objContent = objContent.ReplaceAll(Str(phNum) + " 0 R", Str(rNum) + " 0 R")
		    Next

		    // Write object
		    mOffsets.Value(Str(realNum)) = VNSPDFModule.StringLenB(mBuffer)
		    Call Put(Str(realNum) + " 0 obj")
		    Call Put(objContent)
		    Call Put("endobj")
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutInfo()
		  // Output document information dictionary
		  Call NewObj()
		  mInfoObjectNumber = mObjectNumber - 1 // Save for trailer
		  Call Put("<<")
		  
		  // Use encryption-aware string encoding if encryption is enabled
		  Dim infoObjNum As Integer = mInfoObjectNumber
		  
		  // Producer (always set)
		  If mProducer <> "" Then
		    Call Put("/Producer " + EncryptString(mProducer, infoObjNum))
		  End If
		  
		  // Title
		  If mTitle <> "" Then
		    Call Put("/Title " + EncryptString(mTitle, infoObjNum))
		  End If
		  
		  // Author
		  If mAuthor <> "" Then
		    Call Put("/Author " + EncryptString(mAuthor, infoObjNum))
		  End If
		  
		  // Subject
		  If mSubject <> "" Then
		    Call Put("/Subject " + EncryptString(mSubject, infoObjNum))
		  End If
		  
		  // Keywords
		  If mKeywords <> "" Then
		    Call Put("/Keywords " + EncryptString(mKeywords, infoObjNum))
		  End If
		  
		  // Creator
		  If mCreator <> "" Then
		    Call Put("/Creator " + EncryptString(mCreator, infoObjNum))
		  End If
		  
		  // Creation date (current date/time in PDF format)
		  Dim now As DateTime = DateTime.Now
		  Dim dateStr As String = "D:" + now.Year.ToString("0000") + _
		  now.Month.ToString("00") + now.Day.ToString("00") + _
		  now.Hour.ToString("00") + now.Minute.ToString("00") + now.Second.ToString("00")
		  
		  // Encrypt date strings if encryption is enabled
		  If mEncryption <> Nil Then
		    Call Put("/CreationDate " + EncryptString(dateStr, infoObjNum))
		    Call Put("/ModDate " + EncryptString(dateStr, infoObjNum))
		  Else
		    Call Put("/CreationDate (" + dateStr + ")")
		    Call Put("/ModDate (" + dateStr + ")")
		  End If
		  
		  Call Put(">>")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutJPEGImage(imageInfo As Dictionary)
		  // Output JPEG image as XObject
		  Call NewObj()
		  Dim imageObjNum As Integer = mObjectNumber - 1
		  imageInfo.Value("n") = imageObjNum
		  
		  Dim imageData As String = imageInfo.Value("data")
		  Dim width As Integer = imageInfo.Value("width")
		  Dim height As Integer = imageInfo.Value("height")
		  Dim colorSpace As String = imageInfo.Value("colorspace")
		  Dim bitsPerComponent As Integer = imageInfo.Value("bitspercomponent")
		  
		  // Apply encryption if enabled
		  If mEncryption <> Nil Then
		    imageData = mEncryption.EncryptObject(imageData, imageObjNum, 0)
		  End If
		  
		  Call Put("<<")
		  Call Put("/Type /XObject")
		  Call Put("/Subtype /Image")
		  Call Put("/Width " + Str(width))
		  Call Put("/Height " + Str(height))
		  Call Put("/ColorSpace /" + colorSpace)
		  Call Put("/BitsPerComponent " + Str(bitsPerComponent))
		  Call Put("/Filter /DCTDecode")
		  Call Put("/Length " + Str(VNSPDFModule.StringLenB(imageData)))
		  Call Put(">>")
		  Call Put("stream")
		  
		  // Output JPEG data (encrypted if encryption is enabled)
		  mBuffer = mBuffer + imageData
		  
		  Call Put("")
		  Call Put("endstream")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4F75747075747320746865206F757470757420696E74656E747320617272617920696E20746865206361746C6F672E0A
		Private Sub PutOutputIntents()
		  // Output the /OutputIntents array in the catalog dictionary
		  // Called INSIDE PutCatalog
		  // Follows go-fpdf pattern: fpdf.go lines 5191-5208
		  
		  // Check if there are any output intents
		  If mOutputIntents.Count = 0 Then Return
		  
		  Call Put("/OutputIntents [")
		  
		  // Output each output intent dictionary
		  For i As Integer = 0 To mOutputIntents.LastIndex
		    Dim intent As VNSPDFOutputIntent = mOutputIntents(i)
		    
		    // Build output intent dictionary
		    Dim intentDict As String = "<< /Type /OutputIntent"
		    intentDict = intentDict + " /S /" + intent.Subtype
		    intentDict = intentDict + " /OutputConditionIdentifier (" + intent.OutputCondition + ")"
		    
		    // Optional info field
		    If intent.Info <> "" Then
		      intentDict = intentDict + " /Info (" + intent.Info + ")"
		    End If
		    
		    // Reference to ICC profile stream object
		    Dim profileObjNum As Integer = mOutputIntentStartN + i
		    intentDict = intentDict + " /DestOutputProfile " + Str(profileObjNum) + " 0 R >>"
		    
		    Call Put(intentDict)
		  Next
		  
		  Call Put("]")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4F757470757473206F757470757420696E74656E742073747265616D206F626A656374732E0A
		Private Sub PutOutputIntentStreams()
		  // Output ICC profile stream objects for output intents
		  // Called BEFORE PutCatalog in CloseDocument
		  // Follows go-fpdf pattern: fpdf.go lines 5210-5226
		  
		  // Check if there are any output intents
		  If mOutputIntents.Count = 0 Then Return
		  
		  // Record starting object number for first output intent stream
		  mOutputIntentStartN = mObjectNumber
		  
		  // Output each ICC profile as a compressed stream
		  For i As Integer = 0 To mOutputIntents.LastIndex
		    Dim intent As VNSPDFOutputIntent = mOutputIntents(i)
		    
		    Call NewObj()
		    
		    // Compress ICC profile data
		    Dim profileData As String = intent.ICCProfile.StringValue(0, intent.ICCProfile.Size)
		    Dim compressedData As String = VNSZlibModule.Compress(profileData)
		    
		    // Output stream dictionary
		    Call Put("<<")
		    Call Put("/N 3") // Number of color components (RGB = 3)
		    Call Put("/Alternate /DeviceRGB") // Alternate color space
		    Call Put("/Length " + Str(VNSPDFModule.StringLenB(compressedData)))
		    // Add filter when compression is available (premium zlib works on all platforms)
		    #If TargetiOS Or TargetAndroid Then
		      If hasPremiumVNSZlibModule Then
		        Call Put("/Filter /FlateDecode")
		      End If
		    #Else
		      Call Put("/Filter /FlateDecode")
		    #EndIf
		    Call Put(">>")
		    
		    // Output compressed stream
		    mBuffer = mBuffer + "stream" + EndOfLine.UNIX
		    mBuffer = mBuffer + compressedData
		    mBuffer = mBuffer + EndOfLine.UNIX  // EOL before endstream (required for PDF/A)
		    Call Put("endstream")
		    Call Put("endobj")
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutPage(pageNum As Integer)
		  // NOTE: NewObj() has already been called in PutPages()
		  Call Put("<<")
		  Call Put("/Type /Page")
		  Call Put("/Parent 1 0 R") // Pages root is object 1
		  
		  // Get page size for this page
		  Dim w, h As Double
		  If mPageSizes.HasKey(Str(pageNum)) Then
		    Dim size As Pair = mPageSizes.Value(Str(pageNum))
		    w = size.Left
		    h = size.Right
		  Else
		    w = mDefPageSize.Left
		    h = mDefPageSize.Right
		  End If
		  
		  // In single-page mode, crop the MediaBox from the bottom to show only content
		  // Content was rendered at the top of the tall page (PDF Y near h)
		  // MediaBox [0 lly w h] shows from lly to h
		  If mSinglePageMediaBoxLly > 0 Then
		    Call Put("/MediaBox [0 " + FormatPDF(mSinglePageMediaBoxLly) + " " + FormatPDF(w) + " " + FormatPDF(h) + "]")
		  Else
		    Call Put("/MediaBox [0 0 " + FormatPDF(w) + " " + FormatPDF(h) + "]")
		  End If
		  
		  // Add page boxes if defined for this page (TrimBox, CropBox, BleedBox, ArtBox)
		  Dim pageKey As String = Str(pageNum)
		  If mPageBoxes.HasKey(pageKey) Then
		    Dim pageBoxDict As Dictionary = mPageBoxes.Value(pageKey)
		    
		    // Output each box type that's defined
		    For Each boxType As String In Array("TrimBox", "CropBox", "BleedBox", "ArtBox")
		      If pageBoxDict.HasKey(boxType) Then
		        Dim boxData As Dictionary = pageBoxDict.Value(boxType)
		        Dim boxX As Double = boxData.Value("x")
		        Dim boxY As Double = boxData.Value("y")
		        Dim boxWidth As Double = boxData.Value("width")
		        Dim boxHeight As Double = boxData.Value("height")
		        
		        // Output page box in PDF format: /BoxType [x y width height]
		        Call Put("/" + boxType + " [" + FormatPDF(boxX) + " " + FormatPDF(boxY) + " " + _
		        FormatPDF(boxWidth) + " " + FormatPDF(boxHeight) + "]")
		      End If
		    Next
		  End If
		  
		  // Reference the shared Resources dictionary (object 2)
		  Call Put("/Resources 2 0 R")
		  
		  // Add annotations (links, file attachments, text notes, form fields) if any exist for this page
		  // pageKey already declared above for page boxes
		  Dim hasLinks As Boolean = mPageLinks.HasKey(pageKey)
		  Dim hasAttachments As Boolean = mPageAttachments.HasKey(pageKey)
		  Dim hasTextAnnotations As Boolean = mPageTextAnnotations.HasKey(pageKey)
		  Dim hasFormAnnotations As Boolean = mPageFormAnnotations.HasKey(pageKey)

		  If hasLinks Or hasAttachments Or hasTextAnnotations Or hasFormAnnotations Then
		    Dim annotStr As String = "/Annots ["

		    // Add link annotations
		    If hasLinks Then
		      Dim links() As Variant = mPageLinks.Value(pageKey)
		      For Each linkVar As Variant In links
		        Dim link As Dictionary = linkVar
		        Dim x, y, wLink, hLink As Double
		        x = link.Value("x")
		        y = link.Value("y")
		        wLink = link.Value("w")
		        hLink = link.Value("h")

		        annotStr = annotStr + "<</Type /Annot /Subtype /Link"
		        annotStr = annotStr + " /Rect [" + FormatPDF(x) + " " + FormatPDF(h - y - hLink) + " "
		        annotStr = annotStr + FormatPDF(x + wLink) + " " + FormatPDF(h - y) + "]"
		        annotStr = annotStr + " /Border [0 0 0] "
		        annotStr = annotStr + "/F 4 "  // PDF/A: Print flag set, Hidden/Invisible/NoView unset

		        // Check if external URL (has linkStr) or internal link (has linkID)
		        Dim linkStr As String = link.Value("linkStr")
		        If linkStr <> "" Then
		          // External URL
		          annotStr = annotStr + "/A <</S /URI /URI " + TextString(linkStr) + ">>>>"
		        Else
		          // Internal link
		          Dim linkID As Integer = link.Value("link")
		          If linkID >= 0 And linkID <= mLinks.LastIndex Then
		            Dim dest As Dictionary = mLinks(linkID)
		            Dim destPage As Integer = dest.Value("page")
		            Dim destY As Double = dest.Value("y")

		            // Calculate page object number (assuming sequential allocation in PutPages)
		            // Includes attachment object offset
		            Dim pageObj As Integer = 3 + mAttachmentObjectOffset + (destPage - 1) * 2
		            annotStr = annotStr + "/Dest [" + Str(pageObj) + " 0 R /XYZ 0 "
		            annotStr = annotStr + FormatPDF(h - destY * mScaleFactor) + " null]>>"
		          End If
		        End If
		      Next
		    End If

		    // Add file attachment annotations
		    If hasAttachments Then
		      Dim annots() As Variant = mPageAttachments.Value(pageKey)
		      For Each annotVar As Variant In annots
		        Dim annot As Dictionary = annotVar
		        Dim a As VNSPDFAttachment = annot.Value("attachment")
		        If a <> Nil And a.ObjectNumber > 0 Then
		          Dim x1, y1, wAnnot, hAnnot As Double
		          x1 = annot.Value("x")
		          y1 = annot.Value("y")
		          wAnnot = annot.Value("w")
		          hAnnot = annot.Value("h")
		          Dim x2 As Double = x1 + wAnnot
		          Dim y2 As Double = y1 - hAnnot

		          // File attachment annotation - PDF readers use default icon (paperclip)
		          // /Rect format is [llx lly urx ury] - y2 is bottom (smaller), y1 is top (larger)
		          annotStr = annotStr + "<< /Type /Annot /Subtype /FileAttachment"
		          annotStr = annotStr + " /Rect [" + FormatPDF(x1) + " " + FormatPDF(y2) + " "
		          annotStr = annotStr + FormatPDF(x2) + " " + FormatPDF(y1) + "]"
		          annotStr = annotStr + " /Name /Paperclip"
		          annotStr = annotStr + " /Contents " + TextString(UTF8ToUTF16BE(a.Description, True))
		          annotStr = annotStr + " /T " + TextString(UTF8ToUTF16BE(a.Filename, True))
		          annotStr = annotStr + " /FS " + Str(a.ObjectNumber) + " 0 R >>"
		        End If
		      Next
		    End If

		    // Add text annotations (sticky notes/comments)
		    If hasTextAnnotations Then
		      Dim textAnnots() As Variant = mPageTextAnnotations.Value(pageKey)
		      For Each annotVar As Variant In textAnnots
		        Dim annot As Dictionary = annotVar
		        Dim message As String = annot.Value("message")
		        Dim xPt As Double = annot.Value("x")
		        Dim yPt As Double = annot.Value("y")

		        // Text annotation with Note icon (24x24 points default size)
		        annotStr = annotStr + "<< /Type /Annot /Subtype /Text"
		        annotStr = annotStr + " /Rect [" + FormatPDF(xPt) + " " + FormatPDF(yPt - 24) + " "
		        annotStr = annotStr + FormatPDF(xPt + 24) + " " + FormatPDF(yPt) + "]"
		        annotStr = annotStr + " /Name /Note"
		        annotStr = annotStr + " /Contents " + TextString(UTF8ToUTF16BE(message, True))
		        annotStr = annotStr + " /Open false >>"
		      Next
		    End If

		    // Add form field widget annotations
		    If hasFormAnnotations Then
		      Dim formAnnots() As String = mPageFormAnnotations.Value(pageKey)
		      For Each annotRef As String In formAnnots
		        annotStr = annotStr + " " + annotRef
		      Next
		    End If

		    annotStr = annotStr + "]"
		    Call Put(annotStr)
		  End If
		  
		  // Page content stream
		  Dim pageContent As String
		  If mPages.HasKey(Str(pageNum)) Then
		    pageContent = mPages.Value(Str(pageNum))
		  Else
		    pageContent = ""
		  End If
		  
		  Call Put("/Contents " + Str(mObjectNumber) + " 0 R")
		  Call Put(">>")
		  Call Put("endobj")
		  
		  // Content stream object
		  Call NewObj()
		  Dim contentObjNum As Integer = mObjectNumber - 1
		  Call Put("<<")
		  
		  // Prepare final stream data: COMPRESS FIRST, then encrypt
		  Dim finalStreamData As String = pageContent
		  
		  // Compress content FIRST if compression is enabled
		  Dim filterStr As String = ""
		  If mCompression Then
		    Dim compressedData As String = VNSZlibModule.Compress(finalStreamData)
		    If compressedData <> "" Then
		      // Add filter when compression is available (premium zlib works on all platforms)
		      #If TargetiOS Or TargetAndroid Then
		        If hasPremiumVNSZlibModule Then
		          filterStr = "/Filter /FlateDecode"
		        End If
		      #Else
		        filterStr = "/Filter /FlateDecode"
		      #EndIf
		      finalStreamData = compressedData
		    End If
		  End If
		  
		  // Apply encryption AFTER compression (encryption is outermost operation)
		  If mEncryption <> Nil Then
		    finalStreamData = mEncryption.EncryptObject(finalStreamData, contentObjNum, 0)
		  End If
		  
		  // Output stream dictionary
		  If filterStr <> "" Then
		    Call Put(filterStr)
		  End If
		  Call Put("/Length " + Str(VNSPDFModule.StringLenB(finalStreamData)))
		  Call Put(">>")
		  mBuffer = mBuffer + "stream" + EndOfLine.UNIX
		  mBuffer = mBuffer + finalStreamData
		  mBuffer = mBuffer + EndOfLine.UNIX  // EOL before endstream (required for PDF/A)
		  
		  Call Put("endstream")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutPages()
		  // Store page object numbers for the Kids array
		  Dim pageObjectNumbers() As Integer
		  ReDim pageObjectNumbers(mPage)
		  
		  // Get default page size in points (matching go-fpdf)
		  Dim wPt, hPt As Double
		  wPt = mDefPageSize.Left
		  hPt = mDefPageSize.Right

		  // NOTE: mObjectNumber is already positioned correctly after attachments and form fields
		  // Objects 1 and 2 are reserved for Pages root and Resources
		  // Attachments (if any) started at 3, then form fields, now pages continue from current position
		  // DO NOT reset mObjectNumber here or we'll overwrite form field objects!

		  // Individual page objects (and their content streams)
		  For pageNum As Integer = 1 To mPage
		    Call NewObj() // Page object
		    pageObjectNumbers(pageNum - 1) = mObjectNumber - 1
		    Call PutPage(pageNum)
		  Next
		  
		  // Pages root - FORCE this to be object 1 (matching go-fpdf)
		  // Write offset for object 1, then output the object manually
		  mOffsets.Value("1") = VNSPDFModule.StringLenB(mBuffer)
		  Call Put("1 0 obj")
		  Call Put("<<")
		  Call Put("/Type /Pages")
		  
		  // Kids array - references to all page objects
		  Dim kids As String = "/Kids ["
		  For i As Integer = 0 To mPage - 1
		    kids = kids + Str(pageObjectNumbers(i)) + " 0 R "
		  Next
		  kids = kids + "]"
		  Call Put(kids)
		  
		  Call Put("/Count " + Str(mPage))
		  // Default MediaBox on Pages root (matching go-fpdf line 4367)
		  Call Put("/MediaBox [0 0 " + FormatPDF(wPt) + " " + FormatPDF(hPt) + "]")
		  Call Put(">>")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutPNGImage(imageInfo As Dictionary)
		  // Output PNG image as XObject
		  // PNG images need special handling since they use deflate compression
		  Call NewObj()
		  Dim imageObjNum As Integer = mObjectNumber - 1
		  imageInfo.Value("n") = imageObjNum
		  
		  Dim imageData As String = imageInfo.Value("data")
		  Dim width As Integer = imageInfo.Value("width")
		  Dim height As Integer = imageInfo.Value("height")
		  Dim colorSpace As String = imageInfo.Value("colorspace")
		  Dim bitsPerComponent As Integer = imageInfo.Value("bitspercomponent")
		  
		  // Extract IDAT chunks from PNG data
		  Dim idatData As String = ExtractPNGIDAT(imageData)
		  
		  If idatData = "" Then
		    SetError("PutPNGImage: Failed to extract IDAT data")
		    Return
		  End If
		  
		  // Apply encryption if enabled
		  If mEncryption <> Nil Then
		    idatData = mEncryption.EncryptObject(idatData, imageObjNum, 0)
		  End If
		  
		  Call Put("<<")
		  Call Put("/Type /XObject")
		  Call Put("/Subtype /Image")
		  Call Put("/Width " + Str(width))
		  Call Put("/Height " + Str(height))
		  Call Put("/ColorSpace /" + colorSpace)
		  Call Put("/BitsPerComponent " + Str(bitsPerComponent))
		  Call Put("/Filter /FlateDecode")
		  Call Put("/Length " + Str(VNSPDFModule.StringLenB(idatData)))
		  
		  // PNG predictor (standard for PNG images)
		  Call Put("/DecodeParms <</Predictor 15 /Colors " + If(colorSpace = "DeviceRGB", "3", "1") + " /BitsPerComponent " + Str(bitsPerComponent) + " /Columns " + Str(width) + ">>")
		  
		  Call Put(">>")
		  Call Put("stream")
		  
		  // Output PNG IDAT data (encrypted and compressed)
		  mBuffer = mBuffer + idatData
		  
		  Call Put("")
		  Call Put("endstream")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutResourceDict()
		  // Output the shared Resources dictionary as object 2 (FORCED)
		  // This is referenced by all pages via "/Resources 2 0 R"
		  // Use NewObj(2) to properly track object number usage
		  Call NewObj(2)
		  Call Put("<<")
		  Call Put("/ProcSet [/PDF /Text /ImageB /ImageC /ImageI]")
		  
		  // Font resources
		  If mFonts.KeyCount > 0 Then
		    Call Put("/Font <<")
		    For Each fontKey As Variant In mFonts.Keys
		      Dim fontInfo As Dictionary = mFonts.Value(fontKey)
		      Dim fontNum As Integer = fontInfo.Value("number")
		      Dim fontType As String = fontInfo.Value("type")
		      
		      If fontType = "TrueType" Or fontType = "UTF8" Then
		        // Reference the TrueType or UTF8 font object
		        If fontInfo.HasKey("objNum") Then
		          Dim objNum As Integer = fontInfo.Value("objNum")
		          Call Put("/F" + Str(fontNum) + " " + Str(objNum) + " 0 R")
		        End If
		      Else
		        // Core fonts: inline definition (no object reference)
		        Dim fontName As String = fontInfo.Value("name")
		        Call Put("/F" + Str(fontNum) + " <<")
		        Call Put("/Type /Font")
		        Call Put("/Subtype /Type1")
		        Call Put("/BaseFont /" + fontName)
		        Call Put("/Encoding /WinAnsiEncoding")
		        Call Put(">>")
		      End If
		    Next
		    Call Put(">>")
		  End If
		  
		  // Image XObject resources + Imported Page XObjects
		  Dim hasXObjects As Boolean = (mImages.KeyCount > 0) Or (mXObjects <> Nil And mXObjects.KeyCount > 0)
		  If hasXObjects Then
		    Call Put("/XObject <<")
		    
		    // Add image XObjects
		    For Each imageKey As Variant In mImages.Keys
		      Dim imageInfo As Dictionary = mImages.Value(imageKey)
		      If imageInfo.HasKey("n") Then
		        Dim objNum As Integer = imageInfo.Value("n")
		        Dim imageIdx As Integer = mImageIndex.Value(imageKey)
		        Call Put("/I" + Str(imageIdx) + " " + Str(objNum) + " 0 R")
		      End If
		    Next
		    
		    // Add imported page XObjects
		    If mXObjectObjNums <> Nil And mXObjectObjNums.KeyCount > 0 Then
		      For Each xobjName As Variant In mXObjectObjNums.Keys
		        Dim objNum As Integer = mXObjectObjNums.Value(xobjName)
		        Call Put("/" + xobjName.StringValue + " " + Str(objNum) + " 0 R")
		      Next
		    End If
		    
		    Call Put(">>")
		  End If
		  
		  // ExtGState resources (transparency/blend modes)
		  Dim blendCount As Integer = mBlendList.Count
		  If blendCount > 1 Then
		    Call Put("/ExtGState <<")
		    For j As Integer = 1 To blendCount - 1
		      Call Put("/GS" + Str(j) + " " + Str(mBlendList(j).objNum) + " 0 R")
		    Next
		    Call Put(">>")
		  End If
		  
		  // Shading resources (gradients)
		  Dim gradientCount As Integer = mGradientList.Count
		  If gradientCount > 0 Then
		    Call Put("/Shading <<")
		    For j As Integer = 0 To gradientCount - 1
		      Call Put("/Sh" + Str(j) + " " + Str(mGradientList(j).objNum) + " 0 R")
		    Next
		    Call Put(">>")
		  End If
		  
		  Call Put(">>")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutResources()
		  // Output fonts first (assigns object numbers)
		  For Each fontKey As Variant In mFonts.Keys
		    Dim fontInfo As Dictionary = mFonts.Value(fontKey)
		    Dim fontType As String = fontInfo.Value("type")
		    
		    If fontType = "TrueType" Then
		      Call PutTrueTypeFont(fontInfo)
		    ElseIf fontType = "UTF8" Then
		      Call PutUTF8Font(fontInfo)
		    End If
		  Next
		  
		  // Output images second (assigns object numbers)
		  Call PutImages()
		  
		  // Output imported PDF objects (fonts, resources) BEFORE XObjects
		  Call PutImportedObjects()
		  
		  // Output imported page XObjects (assigns object numbers)
		  Call PutXObjects()
		  
		  // Blend modes (alpha/transparency)
		  Call PutBlendModes()
		  
		  // Gradients (shading patterns)
		  Call PutGradients()
		  
		  // Output Resources dictionary as object 2 (FORCED object number)
		  Call PutResourceDict()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutTrailer()
		  Call Put("trailer")
		  Call Put("<<")
		  Call Put("/Size " + Str(mObjectNumber))
		  Call Put("/Root " + Str(mCatalogObjectNumber) + " 0 R") // Reference the Catalog
		  If mInfoObjectNumber > 0 Then
		    Call Put("/Info " + Str(mInfoObjectNumber) + " 0 R")
		  End If
		  // Add encryption dictionary reference if encryption is enabled
		  If mEncryptionObjectNumber > 0 Then
		    Call Put("/Encrypt " + Str(mEncryptionObjectNumber) + " 0 R")
		  End If
		  
		  // Add file ID (required for encrypted PDFs, recommended for all)
		  // Use the same file ID that was used to generate encryption keys
		  Dim fileIDToUse As String
		  If mFileID <> "" Then
		    fileIDToUse = mFileID  // Use stored file ID from encryption
		  Else
		    // Generate file ID for non-encrypted PDFs
		    #If TargetiOS Or TargetAndroid Then
		      fileIDToUse = Crypto.MD5(Str(System.Ticks) + mTitle + mAuthor)
		    #Else
		      fileIDToUse = Crypto.MD5(Str(System.Microseconds) + mTitle + mAuthor)
		    #EndIf
		    fileIDToUse = fileIDToUse.DefineEncoding(Encodings.ASCII)
		  End If
		  
		  // Convert file ID to hex for PDF output
		  Dim fileIDHex As String = BinaryToHex(fileIDToUse)
		  Call Put("/ID [<" + fileIDHex + "> <" + fileIDHex + ">]")
		  
		  Call Put(">>")
		  Call Put("startxref")
		  Call Put(Str(mXrefOffset))
		  Call Put("%%EOF")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutTrueTypeFont(fontInfo As Dictionary)
		  // Store font object number
		  Dim fontObjNum As Integer = mObjectNumber
		  fontInfo.Value("objNum") = fontObjNum
		  
		  // Font dictionary
		  Call NewObj()
		  Call Put("<<")
		  Call Put("/Type /Font")
		  Call Put("/Subtype /TrueType")
		  Call Put("/BaseFont /" + fontInfo.Value("name"))
		  
		  // Font descriptor reference
		  Call Put("/FontDescriptor " + Str(mObjectNumber + 1) + " 0 R")
		  
		  // Encoding (for now, use WinAnsiEncoding for compatibility)
		  Call Put("/Encoding /WinAnsiEncoding")
		  
		  Call Put(">>")
		  Call Put("endobj")
		  
		  // Font descriptor
		  Call NewObj()
		  Dim ttf As VNSPDFTrueTypeFont = fontInfo.Value("ttf")
		  Call Put("<<")
		  Call Put("/Type /FontDescriptor")
		  Call Put("/FontName /" + fontInfo.Value("name"))
		  Call Put("/Flags 32") // Symbolic
		  Call Put("/FontBBox [-100 -200 1000 900]") // Approximate bounding box
		  Call Put("/ItalicAngle 0")
		  Call Put("/Ascent 800")
		  Call Put("/Descent -200")
		  Call Put("/CapHeight 700")
		  Call Put("/StemV 80")
		  
		  // Font file reference
		  Call Put("/FontFile2 " + Str(mObjectNumber + 1) + " 0 R")
		  
		  Call Put(">>")
		  Call Put("endobj")
		  
		  // Font file (embedded TrueType font data)
		  Call NewObj()
		  
		  // Get font data (MemoryBlock on iOS, String on Desktop)
		  Dim fontData As String
		  Dim fontDataSize As Integer
		  #If TargetiOS Or TargetAndroid Then
		    Dim fontMB As MemoryBlock = fontInfo.Value("data")
		    fontData = fontMB.StringValue(0, fontMB.Size).DefineEncoding(Encodings.ISOLatin1)
		    fontDataSize = fontMB.Size
		  #Else
		    fontData = fontInfo.Value("data")
		    fontDataSize = VNSPDFModule.StringLenB(fontData)
		  #EndIf
		  
		  Call Put("<<")
		  Call Put("/Length " + Str(fontDataSize))
		  Call Put("/Length1 " + Str(fontDataSize))
		  Call Put(">>")
		  mBuffer = mBuffer + "stream" + EndOfLine.UNIX
		  mBuffer = mBuffer + fontData
		  mBuffer = mBuffer + EndOfLine.UNIX  // EOL before endstream (required for PDF/A)
		  Call Put("endstream")
		  Call Put("endobj")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutUTF8Font(fontInfo As Dictionary)
		  // Output CID font for UTF-8/Unicode support (matching go-pdf)
		  // This creates a Type0 font with Identity-H encoding
		  
		  Dim fontName As String = fontInfo.Value("name")
		  
		  // Get font data (MemoryBlock on iOS, String on Desktop)
		  Dim fontData As String
		  #If TargetiOS Or TargetAndroid Then
		    Dim fontMB As MemoryBlock = fontInfo.Value("data")
		    fontData = fontMB.StringValue(0, fontMB.Size).DefineEncoding(Encodings.ISOLatin1)
		  #Else
		    fontData = fontInfo.Value("data")
		  #EndIf
		  
		  // Use current object number (not pre-allocated) and update fontInfo for cross-references
		  Dim type0ObjNum As Integer = mObjectNumber
		  fontInfo.Value("objNum") = type0ObjNum

		  // Calculate the other 5 object numbers (sequential from type0)
		  Dim cidFontObjNum As Integer = type0ObjNum + 1
		  Dim cidSystemInfoObjNum As Integer = type0ObjNum + 2
		  Dim fontDescriptorObjNum As Integer = type0ObjNum + 3
		  Dim fontFileObjNum As Integer = type0ObjNum + 4
		  Dim toUnicodeObjNum As Integer = type0ObjNum + 5
		  
		  // Type0 Font (Composite font with Identity-H encoding)
		  Call NewObj()
		  Call Put("<<")
		  Call Put("/Type /Font")
		  Call Put("/Subtype /Type0")
		  Call Put("/BaseFont /" + fontName)
		  Call Put("/Encoding /Identity-H")  // Key: UTF-16BE encoding
		  Call Put("/DescendantFonts [" + Str(cidFontObjNum) + " 0 R]")
		  Call Put("/ToUnicode " + Str(toUnicodeObjNum) + " 0 R")
		  Call Put(">>")
		  Call Put("endobj")
		  
		  // CIDFont (Descendant font)
		  Call NewObj()
		  Call Put("<<")
		  Call Put("/Type /Font")
		  Call Put("/Subtype /CIDFontType2")
		  Call Put("/BaseFont /" + fontName)
		  Call Put("/CIDSystemInfo " + Str(cidSystemInfoObjNum) + " 0 R")
		  Call Put("/FontDescriptor " + Str(fontDescriptorObjNum) + " 0 R")
		  Call Put("/CIDToGIDMap /Identity")  // Identity mapping: CID = GID
		  Call Put("/DW 1000")  // Default width
		  
		  // Build /W array with actual glyph widths for used characters
		  If fontInfo.HasKey("usedRunes") And fontInfo.HasKey("ttf") Then
		    Dim usedRunes As Dictionary = fontInfo.Value("usedRunes")
		    Dim ttf As VNSPDFTrueTypeFont = fontInfo.Value("ttf")
		    
		    If usedRunes.KeyCount > 0 Then
		      // Build widths array: /W [gid1 [width1] gid2 [width2] ...]
		      Dim widthsArray As String = "/W ["
		      
		      // Collect glyph ID → width mappings
		      Dim glyphWidths As New Dictionary
		      For Each key As Variant In usedRunes.Keys
		        Dim unicode As Integer = key.IntegerValue
		        Dim glyphID As Integer = ttf.GetGlyphID(unicode)
		        Dim width As Double = ttf.GetCharWidth(unicode)  // Width in 1000-unit scale
		        glyphWidths.Value(Str(glyphID)) = CType(width, Integer)
		      Next
		      
		      // Sort glyph IDs for more efficient PDF
		      Dim sortedGIDs() As Integer
		      For Each key As Variant In glyphWidths.Keys
		        sortedGIDs.Add(key.IntegerValue)
		      Next
		      sortedGIDs.Sort
		      
		      // Output widths for each glyph
		      For Each gid As Integer In sortedGIDs
		        Dim width As Integer = glyphWidths.Value(Str(gid))
		        widthsArray = widthsArray + Str(gid) + " [" + Str(width) + "] "
		      Next
		      
		      widthsArray = widthsArray + "]"
		      Call Put(widthsArray)
		    End If
		  End If
		  
		  Call Put(">>")
		  Call Put("endobj")
		  
		  // CIDSystemInfo
		  Call NewObj()
		  Call Put("<<")
		  Call Put("/Registry (Adobe)")
		  Call Put("/Ordering (Identity)")
		  Call Put("/Supplement 0")
		  Call Put(">>")
		  Call Put("endobj")
		  
		  // Font Descriptor
		  Call NewObj()
		  Dim ttf As VNSPDFTrueTypeFont = fontInfo.Value("ttf")
		  Call Put("<<")
		  Call Put("/Type /FontDescriptor")
		  Call Put("/FontName /" + fontName)
		  Call Put("/Flags 4")  // Symbolic (required for CID fonts with /Identity-H)
		  Call Put("/FontBBox [-100 -200 1000 900]")
		  Call Put("/ItalicAngle 0")
		  Call Put("/Ascent 800")
		  Call Put("/Descent -200")
		  Call Put("/CapHeight 700")
		  Call Put("/StemV 80")
		  Call Put("/FontFile2 " + Str(fontFileObjNum) + " 0 R")
		  Call Put(">>")
		  Call Put("endobj")
		  
		  // Font file (embedded TrueType font data - with optional subsetting)
		  Dim finalFontData As String = fontData
		  
		  // Apply font subsetting if enabled
		  If mEnableFontSubsetting And fontInfo.HasKey("usedRunes") Then
		    Dim usedRunes As Dictionary = fontInfo.Value("usedRunes")
		    
		    If usedRunes.KeyCount > 0 Then
		      // Collect used glyph IDs
		      Dim fontTTF As VNSPDFTrueTypeFont = fontInfo.Value("ttf")
		      Dim usedGlyphIDs() As Integer
		      
		      For Each key As Variant In usedRunes.Keys
		        Dim unicode As Integer = key.IntegerValue
		        Dim glyphID As Integer = fontTTF.GetGlyphID(unicode)
		        If usedGlyphIDs.IndexOf(glyphID) < 0 Then
		          usedGlyphIDs.Add(glyphID)
		        End If
		      Next
		      
		      // Create subset font
		      Dim subsetter As New VNSPDFTrueTypeFontSubsetter(fontData, usedGlyphIDs)
		      finalFontData = subsetter.CreateSubset()
		      
		      If finalFontData = "" Then
		        finalFontData = fontData  // Fallback to full font
		      Else
		        
		        // Store glyph mapping for text encoding
		        fontInfo.Value("glyphMapping") = subsetter.GetGlyphMapping()
		        fontInfo.Value("isSubset") = True
		      End If
		    End If
		  End If
		  
		  Call NewObj()
		  Call Put("<<")
		  Dim originalFontLen As Integer = VNSPDFModule.StringLenB(finalFontData)
		  // Compress font data if compression is enabled
		  Dim fontStreamData As String = finalFontData
		  Dim fontCompressed As Boolean = False
		  If mCompression Then
		    Dim compressedFont As String = VNSZlibModule.Compress(finalFontData)
		    If compressedFont <> "" And compressedFont.Bytes < originalFontLen Then
		      fontStreamData = compressedFont
		      fontCompressed = True
		    End If
		  End If
		  Call Put("/Length " + Str(VNSPDFModule.StringLenB(fontStreamData)))
		  Call Put("/Length1 " + Str(originalFontLen))
		  If fontCompressed Then
		    Call Put("/Filter /FlateDecode")
		  End If
		  Call Put(">>")
		  mBuffer = mBuffer + "stream" + EndOfLine.UNIX
		  mBuffer = mBuffer + fontStreamData
		  mBuffer = mBuffer + EndOfLine.UNIX  // EOL before endstream (required for PDF/A)
		  Call Put("endstream")
		  Call Put("endobj")
		  
		  // ToUnicode CMap (maps GID to Unicode for copy/paste support)
		  Call NewObj()
		  Dim toUnicode As String = "/CIDInit /ProcSet findresource begin" + EndOfLine.UNIX
		  toUnicode = toUnicode + "12 dict begin" + EndOfLine.UNIX
		  toUnicode = toUnicode + "begincmap" + EndOfLine.UNIX
		  toUnicode = toUnicode + "/CIDSystemInfo << /Registry (Adobe) /Ordering (UCS) /Supplement 0 >> def" + EndOfLine.UNIX
		  toUnicode = toUnicode + "/CMapName /Adobe-Identity-UCS def" + EndOfLine.UNIX
		  toUnicode = toUnicode + "/CMapType 2 def" + EndOfLine.UNIX
		  toUnicode = toUnicode + "1 begincodespacerange" + EndOfLine.UNIX
		  toUnicode = toUnicode + "<0000> <FFFF>" + EndOfLine.UNIX
		  toUnicode = toUnicode + "endcodespacerange" + EndOfLine.UNIX
		  
		  // Build GID → Unicode mapping from used characters
		  If fontInfo.HasKey("usedRunes") And fontInfo.HasKey("ttf") Then
		    Dim usedRunes As Dictionary = fontInfo.Value("usedRunes")
		    Dim fontTTF As VNSPDFTrueTypeFont = fontInfo.Value("ttf")
		    
		    If usedRunes.KeyCount > 0 Then
		      // Collect GID → Unicode mappings
		      Dim gidToUnicode As New Dictionary
		      For Each key As Variant In usedRunes.Keys
		        Dim unicode As Integer = key.IntegerValue
		        Dim glyphID As Integer = fontTTF.GetGlyphID(unicode)
		        
		        // Handle font subsetting glyph remapping
		        If fontInfo.HasKey("glyphMapping") Then
		          Dim glyphMapping As Dictionary = fontInfo.Value("glyphMapping")
		          If glyphMapping.HasKey(Str(glyphID)) Then
		            glyphID = glyphMapping.Value(Str(glyphID))
		          End If
		        End If
		        
		        gidToUnicode.Value(Str(glyphID)) = unicode
		      Next
		      
		      // Sort GIDs for PDF efficiency
		      Dim sortedGIDs() As Integer
		      For Each key As Variant In gidToUnicode.Keys
		        sortedGIDs.Add(key.IntegerValue)
		      Next
		      sortedGIDs.Sort
		      
		      // Output bfchar mapping (GID → Unicode)
		      toUnicode = toUnicode + Str(sortedGIDs.Count) + " beginbfchar" + EndOfLine.UNIX
		      For Each gid As Integer In sortedGIDs
		        Dim unicode As Integer = gidToUnicode.Value(Str(gid))
		        
		        // Format as 4-digit hex
		        Dim gidHex As String = Hex(gid)
		        While gidHex.Length < 4
		          gidHex = "0" + gidHex
		        Wend
		        
		        Dim unicodeHex As String = Hex(unicode)
		        While unicodeHex.Length < 4
		          unicodeHex = "0" + unicodeHex
		        Wend
		        
		        toUnicode = toUnicode + "<" + gidHex + "> <" + unicodeHex + ">" + EndOfLine.UNIX
		      Next
		      toUnicode = toUnicode + "endbfchar" + EndOfLine.UNIX
		    Else
		      // No used characters - use identity mapping as fallback
		      toUnicode = toUnicode + "1 beginbfrange" + EndOfLine.UNIX
		      toUnicode = toUnicode + "<0000> <FFFF> <0000>" + EndOfLine.UNIX
		      toUnicode = toUnicode + "endbfrange" + EndOfLine.UNIX
		    End If
		  Else
		    // No character usage data - use identity mapping as fallback
		    toUnicode = toUnicode + "1 beginbfrange" + EndOfLine.UNIX
		    toUnicode = toUnicode + "<0000> <FFFF> <0000>" + EndOfLine.UNIX
		    toUnicode = toUnicode + "endbfrange" + EndOfLine.UNIX
		  End If
		  
		  toUnicode = toUnicode + "endcmap" + EndOfLine.UNIX
		  toUnicode = toUnicode + "CMapName currentdict /CMap defineresource pop" + EndOfLine.UNIX
		  toUnicode = toUnicode + "end" + EndOfLine.UNIX
		  toUnicode = toUnicode + "end" + EndOfLine.UNIX
		  
		  Call Put("<<")
		  Call Put("/Length " + Str(VNSPDFModule.StringLenB(toUnicode)))
		  Call Put(">>")
		  mBuffer = mBuffer + "stream" + EndOfLine.UNIX
		  mBuffer = mBuffer + toUnicode
		  mBuffer = mBuffer + EndOfLine.UNIX  // EOL before endstream (required for PDF/A)
		  Call Put("endstream")
		  Call Put("endobj")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutXmpMetadata()
		  // Output XMP metadata stream if XMP metadata is set
		  If mXmpMetadata = "" Then Return
		  
		  // Allocate object number for XMP metadata stream
		  Call NewObj()
		  mXmpObjectNumber = mObjectNumber - 1
		  
		  // Output XMP metadata as a stream object
		  Dim xmpLength As Integer = VNSPDFModule.StringLenB(mXmpMetadata)
		  Call Put("<< /Type /Metadata /Subtype /XML /Length " + Str(xmpLength) + " >>")
		  
		  // Output stream content
		  mBuffer = mBuffer + "stream" + EndOfLine.UNIX
		  mBuffer = mBuffer + mXmpMetadata
		  mBuffer = mBuffer + EndOfLine.UNIX  // EOL before endstream (required for PDF/A)
		  
		  Call Put("endstream")
		  Call Put("endobj")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutXObjects()
		  // Output imported page XObjects as indirect objects
		  // Each XObject gets assigned an object number for reference in Resources

		  If mXObjects = Nil Or mXObjects.KeyCount = 0 Then
		    Return
		  End If

		  // Ensure object 2 is reserved for Resources dictionary
		  If mObjectNumber < 3 Then
		    mObjectNumber = 3
		  End If

		  For Each xobjName As Variant In mXObjects.Keys
		    Dim xobjContent As String = mXObjects.Value(xobjName)

		    // Replace placeholder references with real object numbers
		    If mPlaceholderToReal <> Nil And mPlaceholderToReal.KeyCount > 0 Then
		      For Each ph As Variant In mPlaceholderToReal.Keys
		        Dim phNum As Integer = Val(ph.StringValue)
		        Dim realNum As Integer = mPlaceholderToReal.Value(ph)
		        Dim searchStr As String = Str(phNum) + " 0 R"
		        Dim replaceStr As String = Str(realNum) + " 0 R"
		        xobjContent = xobjContent.ReplaceAll(searchStr, replaceStr)
		      Next
		    End If

		    // Create new object and store its number
		    Dim objNum As Integer = mObjectNumber
		    Call NewObj()

		    // Store object number in separate dictionary for later reference in Resources
		    mXObjectObjNums.Value(xobjName) = objNum

		    // Output the XObject content
		    Call Put(xobjContent)
		    Call Put("endobj")
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PutXref()
		  Dim xrefOffset As Integer = VNSPDFModule.StringLenB(mBuffer)
		  Call Put("xref")
		  Call Put("0 " + Str(mObjectNumber))
		  Call Put("0000000000 65535 f ")
		  
		  For i As Integer = 1 To mObjectNumber - 1
		    If mOffsets.HasKey(Str(i)) Then
		      Dim offset As Integer = mOffsets.Value(Str(i))
		      Call Put(FormatHelperInt(offset, "0000000000") + " 00000 n ")
		    End If
		  Next
		  
		  mXrefOffset = xrefOffset
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612072616469616C206772616469656E74207573696E672074776F20586F6A6F20436F6C6F72206F626A656374732E0A
		Sub RadialGradient(x As Double, y As Double, w As Double, h As Double, c1 As Color, c2 As Color, x1 As Double, y1 As Double, x2 As Double, y2 As Double, r As Double)
		  // Convenience overload that accepts two Xojo Color objects
		  // Extracts RGB components and calls RadialGradient(r1, g1, b1, r2, g2, b2)
		  //
		  // Parameters:
		  //   x, y: Upper left corner of the rectangle
		  //   w, h: Width and height of the rectangle
		  //   c1: Start color (center)
		  //   c2: End color (outer)
		  //   x1, y1: Center of starting circle (0.0 to 1.0)
		  //   x2, y2: Center of ending circle (0.0 to 1.0)
		  //   r: Radius of the ending circle (0.0 to 1.0)
		  //
		  // Example:
		  //   pdf.RadialGradient(10, 10, 100, 50, Color.Yellow, Color.Red, 0.5, 0.5, 0.5, 0.5, 0.5)
		  
		  // API2: Color.Red/Green/Blue return 0-255 on all platforms
		  Dim r1 As Integer = c1.Red
		  Dim g1 As Integer = c1.Green
		  Dim b1 As Integer = c1.Blue
		  Dim r2 As Integer = c2.Red
		  Dim g2 As Integer = c2.Green
		  Dim b2 As Integer = c2.Blue

		  RadialGradient(x, y, w, h, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2, r)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612072656374616E67756C617220617265612077697468206120626F7264657220616E642F6F722066696C6C2E0A
		Sub RadialGradient(x As Double, y As Double, w As Double, h As Double, r1 As Integer, g1 As Integer, b1 As Integer, r2 As Integer, g2 As Integer, b2 As Integer, x1 As Double, y1 As Double, x2 As Double, y2 As Double, r As Double)
		  // RadialGradient draws a rectangular area with a radial blending of one color to another.
		  // The rectangle is of width w and height h. Its upper left corner is positioned at point (x, y).
		  // The blending is controlled with two circles, each with a center point and radius.
		  // x1, y1: center of starting circle (0.0 to 1.0)
		  // x2, y2: center of ending circle (0.0 to 1.0)
		  // r: radius of the ending circle (0.0 to 1.0)
		  
		  Call GradientClipStart(x, y, w, h)
		  Call Gradient(3, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2, r)
		  Call GradientClipEnd()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RadialGradientInClip(x As Double, y As Double, w As Double, h As Double, c1 As Color, c2 As Color, x1 As Double, y1 As Double, x2 As Double, y2 As Double, r As Double)
		  // Draw radial gradient using the CURRENT clip (no additional rectangular clip)
		  // Use this when an external clip path (ellipse, polygon, etc.) is already established
		  Dim cr1 As Integer = c1.Red
		  Dim cg1 As Integer = c1.Green
		  Dim cb1 As Integer = c1.Blue
		  Dim cr2 As Integer = c2.Red
		  Dim cg2 As Integer = c2.Green
		  Dim cb2 As Integer = c2.Blue

		  Call GradientTransformOnly(x, y, w, h)
		  Call Gradient(3, cr1, cg1, cb1, cr2, cg2, cb2, x1, y1, x2, y2, r)
		  Call GradientClipEnd()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5772697465732072617720504446C3B620636F6E74656E74206469726563746C7920746F2063757272656E740A
		Sub RawWriteStr(str As String)
		  // Writes raw PDF content directly to the current page buffer.
		  // This is a low-level function for advanced PDF construction.
		  // An understanding of the PDF specification is required.
		  
		  If mState <> 2 Then
		    Call SetError("RawWriteStr requires an active page")
		    Return
		  End If
		  
		  If mPage = 0 Then
		    Call SetError("No page active for RawWriteStr")
		    Return
		  End If
		  
		  // Write directly to the current page buffer (same as all other drawing operations)
		  mBuffer = mBuffer + str + EndOfLine.UNIX
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206C656E677468206F66207468652063757272656E7420706167652062756666657220666F72206D61726B696E6720696E736572742D706F696E7473
		Function GetBufferLength() As Integer
		  // Returns the current length of the page content buffer.
		  // Used to mark positions for later content insertion via InsertInBuffer.
		  Return mBuffer.Length
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E736572747320726177205044462073747272696E6720617420612073617665642062756666657220706F736974696F6E
		Sub InsertInBuffer(position As Integer, content As String)
		  // Inserts raw PDF content at the specified byte position in the current page buffer.
		  // Used to draw background rects behind previously rendered text content.
		  If position < 0 Or position > mBuffer.Length Then Return
		  mBuffer = mBuffer.Left(position) + content + mBuffer.Middle(position)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E736572747320636F6E74656E7420696E746F20612073617665642070616765277320627566666572206174207468652073706563696669656420706F736974696F6E2E
		Sub InsertInSavedPage(pageNum As Integer, position As Integer, content As String)
		  // Inserts raw PDF content into a previously saved page's buffer.
		  // Used for cross-page block backgrounds: when a styled block spans pages,
		  // the background must be drawn on BOTH the original and continuation pages.
		  Var pageKey As String = Str(pageNum)
		  If Not mPages.HasKey(pageKey) Then Return
		  Var pageContent As String = mPages.Value(pageKey)
		  If position < 0 Or position > pageContent.Length Then position = 0
		  mPages.Value(pageKey) = pageContent.Left(position) + content + pageContent.Middle(position)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 457874726163747320616E642072656D6F76657320636F6E74656E742066726F6D20746865207370656369666965642062756666657220706F736974696F6E20746F20656E64
		Function ExtractBufferSince(position As Integer) As String
		  // Extracts content from position to end of buffer, removing it from the buffer.
		  // Used with InsertInBuffer to move PDF commands to an earlier position in the stream.
		  If position < 0 Or position >= mBuffer.Length Then Return ""
		  Var extracted As String = mBuffer.Middle(position)
		  mBuffer = mBuffer.Left(position)
		  Return extracted
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44726177732061207265637461676C652077697468206F707469C3B76E616C2066696C6C696E6720616E642F6F72206F75746C696E696E672E
		Sub Rect(x As Double, y As Double, w As Double, h As Double, style As String = "D")
		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If

		  CheckBounds(x, y, w, h, "Rect")

		  // Determine draw operation
		  // D or empty = Draw (stroke)
		  // F = Fill
		  // DF or FD = Draw and Fill
		  Dim op As String
		  Dim styleUpper As String = style.Uppercase
		  If styleUpper = "F" Then
		    op = "f"
		  ElseIf styleUpper = "FD" Or styleUpper = "DF" Then
		    op = "B"
		  Else
		    op = "S"
		  End If
		  
		  // Add PDF rectangle command to buffer
		  // Format: x y w h re op
		  // ALWAYS use Y-flip because user ALWAYS provides coordinates in user space (top-left origin)
		  Dim cmd As String
		  Dim yPDF As Double = (mPageHeight - y) * mScaleFactor
		  cmd = FormatPDF(x * mScaleFactor) + " "
		  cmd = cmd + FormatPDF(yPDF) + " "
		  cmd = cmd + FormatPDF(w * mScaleFactor) + " "
		  cmd = cmd + FormatPDF(-h * mScaleFactor) + " re " + op + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RectRaw(x As Double, y As Double, w As Double, h As Double, style As String = "D")
		  // Draw rectangle without Y-flip conversion - for use in transformation contexts
		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If

		  // Determine draw operation
		  // D or empty = Draw (stroke)
		  // F = Fill
		  // DF or FD = Draw and Fill
		  Dim op As String
		  Dim styleUpper As String = style.Uppercase
		  If styleUpper = "F" Then
		    op = "f"
		  ElseIf styleUpper = "FD" Or styleUpper = "DF" Then
		    op = "B"
		  Else
		    op = "S"
		  End If

		  // Add PDF rectangle command WITHOUT Y-flip conversion
		  // Format: x y w h re op
		  Dim cmd As String
		  cmd = FormatPDF(x * mScaleFactor) + " "
		  cmd = cmd + FormatPDF(y * mScaleFactor) + " "
		  cmd = cmd + FormatPDF(w * mScaleFactor) + " "
		  cmd = cmd + FormatPDF(h * mScaleFactor) + " re " + op + EndOfLine.UNIX

		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265676973746572732061207465787420616C69617320666F7220737562737469747574696F6E2E0A
		Sub RegisterAlias(alias As String, replacement As String)
		  // Register an alias for text substitution in PDF content.
		  // alias: The text to search for
		  // replacement: The text to replace it with
		  //
		  // Note: This is typically called internally by the library,
		  // but can be used directly for custom text replacements.
		  
		  mAliases.Value(alias) = replacement
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RegisterImage(imagePath As String, imageKey As String = "") As String
		  // Register an image for use in the PDF
		  // Returns the image key to use with Image() method
		  // If imageKey is empty, uses filename as key
		  
		  If mError <> "" Then
		    Return ""
		  End If
		  
		  // Create image object to parse the image file
		  Dim img As New VNSPDFImage(imagePath)
		  
		  If Not img.IsValid() Then
		    Call SetError("Image registration failed: " + img.GetError())
		    Return ""
		  End If
		  
		  // Use filename as key if not provided
		  If imageKey = "" Then
		    Dim f As FolderItem = New FolderItem(imagePath, FolderItem.PathModes.Native)
		    imageKey = f.Name
		  End If
		  
		  // Check if image already registered
		  If mImages.HasKey(imageKey) Then
		    Return imageKey
		  End If
		  
		  // Assign image index (sequential number starting at 1)
		  Dim imageIndex As Integer = mImages.KeyCount + 1
		  mImageIndex.Value(imageKey) = imageIndex
		  
		  // Store image information
		  Dim imageInfo As New Dictionary
		  imageInfo.Value("type") = img.GetImageType()
		  imageInfo.Value("width") = img.GetWidth()
		  imageInfo.Value("height") = img.GetHeight()
		  imageInfo.Value("colorspace") = img.GetColorSpace()
		  imageInfo.Value("bitspercomponent") = img.GetBitsPerComponent()
		  imageInfo.Value("data") = img.GetImageData()
		  imageInfo.Value("n") = 0 // Object number (assigned during output)
		  imageInfo.Value("i") = imageIndex // Image index for reference in page content
		  
		  mImages.Value(imageKey) = imageInfo
		  
		  Return imageKey
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656769737465722061204D656D6F7279426C6F636B20696D616765206461746120666F72207573652E0A
		Function RegisterImageFromBytes(imageData As MemoryBlock, imageKey As String = "") As String
		  // Register an image from MemoryBlock (PNG or JPEG data)
		  // Returns the image key to use with Image() method
		  // If imageKey is empty, generates a unique key
		  
		  If mError <> "" Then
		    Return ""
		  End If
		  
		  // Validate input
		  If imageData = Nil Or imageData.Size = 0 Then
		    Call SetError("RegisterImageFromBytes: Image data is empty")
		    Return ""
		  End If
		  
		  // Create image object to parse the image data
		  Dim img As New VNSPDFImage(imageData)
		  
		  If Not img.IsValid() Then
		    Call SetError("Image registration failed: " + img.GetError())
		    Return ""
		  End If
		  
		  // Generate unique key if not provided
		  If imageKey = "" Then
		    Static imageCounter As Integer = 0
		    imageCounter = imageCounter + 1
		    imageKey = "MemoryImage" + Str(imageCounter)
		  End If
		  
		  // Check if image already registered
		  If mImages.HasKey(imageKey) Then
		    Return imageKey
		  End If
		  
		  // Assign image index (sequential number starting at 1)
		  Dim imageIndex As Integer = mImages.KeyCount + 1
		  mImageIndex.Value(imageKey) = imageIndex
		  
		  // Store image information
		  Dim imageInfo As New Dictionary
		  imageInfo.Value("type") = img.GetImageType()
		  imageInfo.Value("width") = img.GetWidth()
		  imageInfo.Value("height") = img.GetHeight()
		  imageInfo.Value("colorspace") = img.GetColorSpace()
		  imageInfo.Value("bitspercomponent") = img.GetBitsPerComponent()
		  imageInfo.Value("data") = img.GetImageData()
		  imageInfo.Value("n") = 0 // Object number (assigned during output)
		  imageInfo.Value("i") = imageIndex // Image index for reference in page content
		  
		  mImages.Value(imageKey) = imageInfo

		  Return imageKey
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 47657420726567697374657265642069616D67652070697865486C2064696D656E73696F6E7320696E2075736572206E756E697473
		Function GetRegisteredImageSize(imageKey As String, ByRef w As Double, ByRef h As Double) As Boolean
		  // Returns the registered image dimensions in current user units (mm by default)
		  // Returns True if image found, False otherwise

		  If Not mImages.HasKey(imageKey) Then
		    w = 0
		    h = 0
		    Return False
		  End If

		  Dim imageInfo As Dictionary = mImages.Value(imageKey)
		  Dim pixelW As Integer = imageInfo.Value("width")
		  Dim pixelH As Integer = imageInfo.Value("height")

		  // Convert pixels to user units (same formula as Image method: assume 96 DPI)
		  w = (pixelW * 72.0 / 96.0) / mScaleFactor
		  h = (pixelH * 72.0 / 96.0) / mScaleFactor

		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526567697374657220696D6167652077697468206F7074696F6E732044696374696F6E6172792E0A
		Function RegisterImageOptions(imagePath As String, imageKey As String = "", options As Dictionary = Nil) As String
		  // Register an image with advanced options
		  // options Dictionary keys:
		  //   "imageType" (String): NOTE - Currently ignored, image type auto-detected from binary signature
		  //   "readDpi" (Boolean): Read DPI from image file (future feature, currently ignored)
		  //   "allowNegativePosition" (Boolean): Allow negative X positions (used by ImageOptions)
		  // Returns the image key to use with Image() or ImageOptions()
		  
		  // If no options provided, use standard RegisterImage
		  If options = Nil Then
		    Return RegisterImage(imagePath, imageKey)
		  End If
		  
		  If mError <> "" Then
		    Return ""
		  End If
		  
		  // Create image object (type auto-detected from file signature)
		  // Note: imageType option is ignored - VNSPDFImage auto-detects format
		  Dim img As New VNSPDFImage(imagePath)
		  
		  If Not img.IsValid() Then
		    Call SetError("Image registration failed: " + img.GetError())
		    Return ""
		  End If
		  
		  // Use filename as key if not provided
		  If imageKey = "" Then
		    Dim f As FolderItem = New FolderItem(imagePath, FolderItem.PathModes.Native)
		    imageKey = f.Name
		  End If
		  
		  // Check if image already registered
		  If mImages.HasKey(imageKey) Then
		    Return imageKey
		  End If
		  
		  // Assign image index
		  Dim imageIndex As Integer = mImages.KeyCount + 1
		  mImageIndex.Value(imageKey) = imageIndex
		  
		  // Store image information
		  Dim imageInfo As New Dictionary
		  imageInfo.Value("type") = img.GetImageType()
		  imageInfo.Value("width") = img.GetWidth()
		  imageInfo.Value("height") = img.GetHeight()
		  imageInfo.Value("colorspace") = img.GetColorSpace()
		  imageInfo.Value("bitspercomponent") = img.GetBitsPerComponent()
		  imageInfo.Value("data") = img.GetImageData()
		  imageInfo.Value("n") = 0
		  imageInfo.Value("i") = imageIndex
		  
		  mImages.Value(imageKey) = imageInfo
		  
		  Return imageKey
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526567697374657220696D6167652066726F6D2062797465732077697468206F7074696F6E732E0A
		Function RegisterImageOptionsReader(imageData As MemoryBlock, imageKey As String = "", options As Dictionary = Nil) As String
		  // Register an image from MemoryBlock with advanced options
		  // options Dictionary keys:
		  //   "imageType" (String): NOTE - Currently ignored, image type auto-detected from binary signature
		  //   "readDpi" (Boolean): Read DPI from image file (future feature, currently ignored)
		  //   "allowNegativePosition" (Boolean): Allow negative X positions (used by ImageOptions)
		  // Returns the image key to use with Image() or ImageOptions()
		  
		  // If no options provided, use standard RegisterImageFromBytes
		  If options = Nil Then
		    Return RegisterImageFromBytes(imageData, imageKey)
		  End If
		  
		  If mError <> "" Then
		    Return ""
		  End If
		  
		  // Validate input
		  If imageData = Nil Or imageData.Size = 0 Then
		    Call SetError("RegisterImageOptionsReader: Image data is empty")
		    Return ""
		  End If
		  
		  // Create image object (type auto-detected from data signature)
		  // Note: imageType option is ignored - VNSPDFImage auto-detects format
		  Dim img As New VNSPDFImage(imageData)
		  
		  If Not img.IsValid() Then
		    Call SetError("Image registration failed: " + img.GetError())
		    Return ""
		  End If
		  
		  // Generate unique key if not provided
		  If imageKey = "" Then
		    Static imageCounter As Integer = 0
		    imageCounter = imageCounter + 1
		    imageKey = "MemoryImage" + Str(imageCounter)
		  End If
		  
		  // Check if image already registered
		  If mImages.HasKey(imageKey) Then
		    Return imageKey
		  End If
		  
		  // Assign image index
		  Dim imageIndex As Integer = mImages.KeyCount + 1
		  mImageIndex.Value(imageKey) = imageIndex
		  
		  // Store image information
		  Dim imageInfo As New Dictionary
		  imageInfo.Value("type") = img.GetImageType()
		  imageInfo.Value("width") = img.GetWidth()
		  imageInfo.Value("height") = img.GetHeight()
		  imageInfo.Value("colorspace") = img.GetColorSpace()
		  imageInfo.Value("bitspercomponent") = img.GetBitsPerComponent()
		  imageInfo.Value("data") = img.GetImageData()
		  imageInfo.Value("n") = 0
		  imageInfo.Value("i") = imageIndex
		  
		  mImages.Value(imageKey) = imageInfo
		  
		  Return imageKey
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526567697374657220696D6167652066726F6D206279746573202864657072656361746564292E0A
		Function RegisterImageReader(imageData As MemoryBlock, imageType As String, imageKey As String = "") As String
		  // DEPRECATED: Use RegisterImageOptionsReader instead
		  // Register an image from MemoryBlock with explicit type
		  // imageType: "jpg", "png", or "gif"
		  // Returns the image key to use with Image()
		  
		  Dim options As New Dictionary
		  options.Value("imageType") = imageType
		  options.Value("readDpi") = False
		  
		  Return RegisterImageOptionsReader(imageData, imageKey, options)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265706C6163657320616C69617320737472696E677320696E20616C6C2070616765732E0A
		Sub ReplaceAliases()
		  // Replace all registered aliases in page content.
		  // Runs in two modes: UTF-8 (mode 0) and UTF-16BE (mode 1) for Unicode text.
		  
		  For mode As Integer = 0 To 1
		    // Iterate through all aliases
		    For Each key As Variant In mAliases.Keys
		      Dim alias As String = key
		      Dim replacement As String = mAliases.Value(alias)
		      
		      // Convert to UTF-16BE in mode 1 for Unicode text support
		      If mode = 1 Then
		        alias = UTF8ToUTF16BE(alias, False)
		        replacement = UTF8ToUTF16BE(replacement, False)
		      End If
		      
		      // Replace in all pages
		      For n As Integer = 1 To mPage
		        Dim pageKey As String = Str(n)
		        If mPages.HasKey(pageKey) Then
		          Dim pageContent As String = mPages.Value(pageKey)
		          
		          // Check if alias exists in page content
		          If pageContent.IndexOf(alias) >= 0 Then
		            // Replace all occurrences
		            pageContent = pageContent.ReplaceAll(alias, replacement)
		            mPages.Value(pageKey) = pageContent
		          End If
		        End If
		      Next
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReverseArabicRuns(codePoints() As Integer) As Integer()
		  // Reverse Arabic character runs for RTL rendering
		  // PDF renders text LTR, so we need to reverse Arabic text
		  // Keep Latin/numbers in original order (they're already LTR)
		  // Spaces between Arabic chars are included in the run and reversed
		  // Returns: Reversed array of code points
		  
		  Dim result() As Integer
		  
		  Dim arabicRun() As Integer
		  
		  For i As Integer = 0 To codePoints.LastIndex
		    Dim cp As Integer = codePoints(i)
		    
		    // Check if this is Arabic/RTL character
		    If IsArabicChar(cp) Then
		      // Add to Arabic run
		      arabicRun.Add(cp)
		    ElseIf IsNeutralChar(cp) And arabicRun.Count > 0 Then
		      // Neutral character (space, etc.) in an Arabic context
		      // Look ahead to see if more Arabic follows
		      Dim hasArabicAhead As Boolean = False
		      If i + 1 <= codePoints.LastIndex Then
		        Dim nextCP As Integer = codePoints(i + 1)
		        hasArabicAhead = IsArabicChar(nextCP)
		      End If
		      
		      If hasArabicAhead Then
		        // Include neutral char in Arabic run (will be reversed with the text)
		        arabicRun.Add(cp)
		      Else
		        // End of Arabic run - flush and add neutral char after
		        For j As Integer = arabicRun.Count - 1 DownTo 0
		          result.Add(arabicRun(j))
		        Next
		        ReDim arabicRun(-1)
		        result.Add(cp)
		      End If
		    Else
		      // Non-Arabic, non-neutral character - flush Arabic run if any
		      If arabicRun.Count > 0 Then
		        // Reverse the Arabic run and add to result
		        For j As Integer = arabicRun.Count - 1 DownTo 0
		          result.Add(arabicRun(j))
		        Next
		        ReDim arabicRun(-1)
		      End If
		      
		      // Add non-Arabic character as-is
		      result.Add(cp)
		    End If
		  Next
		  
		  // Flush remaining Arabic run
		  If arabicRun.Count > 0 Then
		    For j As Integer = arabicRun.Count - 1 DownTo 0
		      result.Add(arabicRun(j))
		    Next
		  End If
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612072656374616E676C652077697468206120726F756E64656420636F726E65722E0A
		Sub RoundedRect(x As Double, y As Double, w As Double, h As Double, r As Double, corners As String, style As String = "D")
		  // Draw a rectangle with rounded corners
		  // x, y: Top-left corner
		  // w, h: Width and height
		  // r: Corner radius
		  // corners: String with corner positions "1234" (1=TL, 2=TR, 3=BR, 4=BL)
		  // style: "D" (draw), "F" (fill), or "FD"/"DF" (both)
		  
		  Dim rTL, rTR, rBR, rBL As Double
		  
		  If corners.IndexOf("1") >= 0 Then rTL = r
		  If corners.IndexOf("2") >= 0 Then rTR = r
		  If corners.IndexOf("3") >= 0 Then rBR = r
		  If corners.IndexOf("4") >= 0 Then rBL = r
		  
		  Call RoundedRectExt(x, y, w, h, rTL, rTR, rBR, rBL, style)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612072656374616E676C6520776974682064696666657265E280AC6E7420726164697573E280AC20666F722065616368E280AC20636F726E65722E0A
		Sub RoundedRectExt(x As Double, y As Double, w As Double, h As Double, rTL As Double, rTR As Double, rBR As Double, rBL As Double, style As String = "D")
		  // Draw a rectangle with different radius for each corner
		  // rTL, rTR, rBR, rBL: Radius for each corner (TL=top-left, TR=top-right, BR=bottom-right, BL=bottom-left)

		  If mPage = 0 Then
		    mError = mError + "Cannot draw: no page added yet." + EndOfLine
		    Return
		  End If

		  Call RoundedRectPath(x, y, w, h, rTL, rTR, rBR, rBL)
		  Call Put(FillDrawOp(style))
		  Call Put("Q")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4275696C647320746865207061746820666F7220612072656374616E676C6520776974682072C3B76F756E64656420636F726E6572732E0A
		Private Sub RoundedRectPath(x As Double, y As Double, w As Double, h As Double, rTL As Double, rTR As Double, rBR As Double, rBL As Double)
		  // Build the path for a rounded rectangle
		  
		  Dim k As Double = mScaleFactor
		  Dim hp As Double = mPageHeight
		  Dim myArc As Double = (4.0 / 3.0) * (Sqrt(2.0) - 1.0)  // ≈ 0.5522847498
		  
		  // Start path at top-left, after the corner radius
		  Call Put("q " + FormatPDF((x + rTL) * k) + " " + FormatPDF((hp - y) * k) + " m")
		  
		  // Draw to top-right corner
		  Dim xc, yc As Double
		  xc = x + w - rTR
		  yc = y + rTR
		  Call Put(FormatPDF(xc * k) + " " + FormatPDF((hp - y) * k) + " l")
		  If rTR <> 0 Then
		    Call ClipArc(xc + rTR * myArc, yc - rTR, xc + rTR, yc - rTR * myArc, xc + rTR, yc)
		  End If
		  
		  // Draw to bottom-right corner
		  xc = x + w - rBR
		  yc = y + h - rBR
		  Call Put(FormatPDF((x + w) * k) + " " + FormatPDF((hp - yc) * k) + " l")
		  If rBR <> 0 Then
		    Call ClipArc(xc + rBR, yc + rBR * myArc, xc + rBR * myArc, yc + rBR, xc, yc + rBR)
		  End If
		  
		  // Draw to bottom-left corner
		  xc = x + rBL
		  yc = y + h - rBL
		  Call Put(FormatPDF(xc * k) + " " + FormatPDF((hp - (y + h)) * k) + " l")
		  If rBL <> 0 Then
		    Call ClipArc(xc - rBL * myArc, yc + rBL, xc - rBL, yc + rBL * myArc, xc - rBL, yc)
		  End If
		  
		  // Draw back to top-left corner
		  xc = x + rTL
		  yc = y + rTL
		  Call Put(FormatPDF(x * k) + " " + FormatPDF((hp - yc) * k) + " l")
		  If rTL <> 0 Then
		    Call ClipArc(xc - rTL, yc - rTL * myArc, xc - rTL * myArc, yc - rTL, xc, yc - rTL)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E61626C65732072696768742D746F2D6C65667420746578742E
		Sub RTL()
		  // RTL enables right-to-left text direction for languages like Arabic and Hebrew.
		  // This affects text positioning and alignment in subsequent text output operations.
		  // Note: Actual RTL text rendering (glyph reordering) requires additional implementation.
		  
		  mIsRTL = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53617665732074686520504446206F757470757420746F20612066696C652061742074686520737065636966696564206C6F636174696F6E2E0A
		Sub SaveToFile(path As String)
		  // Generate PDF output
		  Dim pdfData As String = Output()
		  
		  If pdfData = "" Then
		    Return // Error already set by Output()
		  End If
		  
		  // Save to file using FolderItem
		  Try
		    Dim f As FolderItem = New FolderItem(path, FolderItem.PathModes.Native)
		    Dim stream As TextOutputStream = TextOutputStream.Create(f)
		    stream.Write(pdfData)
		    stream.Close()
		  Catch e As IOException
		    mError = "Failed to save PDF file: " + e.Message
		  Catch e As RuntimeException
		    mError = "Failed to save PDF file: " + e.Message
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeObjectForCopy(obj As Variant) As String
		  // Serialize an object for copying, recursively remapping any nested indirect references
		  // This is similar to SerializeType() but handles more complex structures
		  // obj: Can be VNSPDFType or Variant containing VNSPDFType
		  
		  If obj IsA VNSPDFDictionary Then
		    Dim dict As Dictionary = VNSPDFDictionary(obj).value
		    Dim result As String = "<<" + EndOfLine
		    Dim keys() As Variant = dict.Keys
		    For Each key As Variant In keys
		      Dim keyStr As String = key.StringValue
		      result = result + "  /" + keyStr + " " + SerializeObjectForCopy(dict.Value(keyStr)) + EndOfLine
		    Next
		    result = result + ">>"
		    Return result
		    
		  ElseIf obj IsA VNSPDFArray Then
		    Dim arrayObj As VNSPDFArray = VNSPDFArray(obj)
		    Dim result As String = "["
		    // Get array with correct type (VNSPDFType, not Variant)
		    Dim arrValue() As VNSPDFType = arrayObj.value
		    // Iterate using For Each
		    Dim isFirst As Boolean = True
		    For Each item As VNSPDFType In arrValue
		      If Not isFirst Then result = result + " "
		      result = result + SerializeObjectForCopy(item)
		      isFirst = False
		    Next
		    result = result + "]"
		    Return result
		    
		  ElseIf obj IsA VNSPDFName Then
		    Return "/" + VNSPDFName(obj).value
		    
		  ElseIf obj IsA VNSPDFNumeric Then
		    // Format number properly for PDF - avoid scientific notation
		    Dim numValue As Double = VNSPDFNumeric(obj).value
		    // Check if it's effectively an integer
		    If Abs(numValue - Round(numValue)) < 0.0000001 Then
		      // Output as integer (no decimal point)
		      Return Str(CType(numValue, Int64))
		    Else
		      // Output as decimal with proper formatting (no scientific notation)
		      // Replace comma with period for locale-independence (PDF requires period)
		      Return FormatHelper(numValue, "-#########0.######").ReplaceAll(",", ".")
		    End If
		    
		  ElseIf obj IsA VNSPDFIndirectObjectReference Then
		    // RECURSIVELY copy referenced object and remap
		    Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(obj)
		    Dim newObjNum As Integer = CopyObjectFromSource(ref.objectNumber)
		    If newObjNum = 0 Then
		      // Failed to copy - return original reference
		      Return Str(ref.objectNumber) + " " + Str(ref.generation) + " R"
		    End If
		    Return Str(newObjNum) + " 0 R"
		    
		  ElseIf obj IsA VNSPDFString Then
		    // Literal string - escape special characters
		    Dim str As String = VNSPDFString(obj).value
		    str = str.ReplaceAll("\", "\\")
		    str = str.ReplaceAll("(", "\(")
		    str = str.ReplaceAll(")", "\)")
		    Return "(" + str + ")"
		    
		  ElseIf obj IsA VNSPDFBoolean Then
		    If VNSPDFBoolean(obj).value = True Then
		      Return "true"
		    Else
		      Return "false"
		    End If
		    
		  ElseIf obj IsA VNSPDFStream Then
		    // Serialize stream object (e.g., font programs, images)
		    Dim stream As VNSPDFStream = VNSPDFStream(obj)
		    
		    // Fix incomplete Group dictionaries in copied XObject Form streams
		    Dim streamDict As Dictionary = stream.dictionary.value
		    If streamDict.HasKey("Type") And streamDict.HasKey("Subtype") Then
		      Dim typeObj As VNSPDFType = streamDict.Value("Type")
		      Dim subtypeObj As VNSPDFType = streamDict.Value("Subtype")
		      If typeObj IsA VNSPDFName And subtypeObj IsA VNSPDFName Then
		        If VNSPDFName(typeObj).value = "XObject" And VNSPDFName(subtypeObj).value = "Form" Then
		          // This is a Form XObject - check for incomplete Group dictionary
		          If streamDict.HasKey("Group") Then
		            Dim groupObj As VNSPDFType = streamDict.Value("Group")
		            If groupObj IsA VNSPDFDictionary Then
		              Dim groupDict As Dictionary = VNSPDFDictionary(groupObj).value
		              // Check if Group dictionary is missing /CS (ColorSpace)
		              If Not groupDict.HasKey("CS") Then
		                // Add /CS /DeviceRGB to Group dictionary
		                Dim csName As New VNSPDFName
		                csName.value = "DeviceRGB"
		                groupDict.Value("CS") = csName
		              End If
		            End If
		          End If
		        End If
		      End If
		    End If
		    
		    // Check the /Length value in dictionary vs actual stream data size
		    Dim lengthDict As Dictionary = stream.dictionary.value
		    Dim declaredLength As Integer = -1
		    If lengthDict.HasKey("Length") Then
		      Dim lengthObj As VNSPDFType = lengthDict.Value("Length")
		      If lengthObj IsA VNSPDFNumeric Then
		        declaredLength = VNSPDFNumeric(lengthObj).value
		      End If
		    End If
		    Dim actualSize As Integer = stream.data.Size
		    #Pragma Unused actualSize
		    #Pragma Unused declaredLength
		    
		    // Serialize dictionary with recursive remapping
		    Dim result As String = SerializeObjectForCopy(stream.dictionary) + EndOfLine.UNIX
		    
		    // Add stream data - preserve binary bytes without encoding conversion
		    // CRITICAL: Define encoding as Nil BEFORE concatenation to prevent corruption
		    result = result.DefineEncoding(Nil)
		    
		    Dim streamKeyword As String = "stream"
		    streamKeyword = streamKeyword.DefineEncoding(Nil)
		    Dim lf As String = EndOfLine.UNIX
		    lf = lf.DefineEncoding(Nil)
		    result = result + streamKeyword + lf
		    
		    // Get stream data and skip leading newline if present
		    // Some source PDFs have newline after "stream" keyword that's part of the stream data
		    Dim streamDataOffset As Integer = 0
		    Dim streamDataSize As Integer = stream.data.Size
		    If streamDataSize > 0 Then
		      Dim firstByte As Integer = stream.data.UInt8Value(0)
		      If firstByte = 10 Or firstByte = 13 Then  // LF or CR
		        streamDataOffset = 1
		        streamDataSize = streamDataSize - 1
		      End If
		    End If
		    
		    Dim streamBytes As String = stream.data.StringValue(streamDataOffset, streamDataSize)
		    streamBytes = streamBytes.DefineEncoding(Nil)
		    result = result + streamBytes
		    
		    // PDF spec requires newline before "endstream" keyword
		    // This newline is NOT part of the stream data length
		    Dim lfBeforeEnd As String = EndOfLine.UNIX
		    lfBeforeEnd = lfBeforeEnd.DefineEncoding(Nil)
		    result = result + lfBeforeEnd
		    
		    Dim endstreamKeyword As String = "endstream"
		    endstreamKeyword = endstreamKeyword.DefineEncoding(Nil)
		    result = result + endstreamKeyword
		    
		    Return result
		    
		  Else
		    // Fallback - unknown type
		    Return ""
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeResources(resources As VNSPDFDictionary) As String
		  // Serialize a Resources dictionary to PDF format
		  // For Phase 6.2, we'll do a simple serialization
		  // TODO: Implement full object ID remapping for nested resources
		  
		  Dim dict As Dictionary = resources.value

		  If dict.KeyCount = 0 Then
		    Return ""
		  End If
		  
		  // Build resources dictionary
		  Dim result As String = "<<" + EndOfLine
		  
		  // Add each resource type
		  Dim keys() As Variant = dict.Keys
		  For Each key As Variant In keys
		    Dim keyStr As String = key.StringValue
		    result = result + "   /" + keyStr + " "
		    
		    Dim value As Variant = dict.Value(keyStr)
		    If value IsA VNSPDFType Then
		      Dim valueType As VNSPDFType = VNSPDFType(value)
		      Dim serialized As String = SerializeType(valueType)
		      result = result + serialized + EndOfLine
		    Else
		      result = result + "null" + EndOfLine
		    End If
		  Next

		  result = result + ">>"
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeType(obj As VNSPDFType) As String
		  // Serialize a PDF type to string format
		  // Simple implementation for Phase 6.2
		  
		  If obj IsA VNSPDFDictionary Then
		    Dim dict As Dictionary = VNSPDFDictionary(obj).value
		    Dim keys() As Variant = dict.Keys
		    Dim result As String = "<<"
		    For Each key As Variant In keys
		      Dim keyStr As String = key.StringValue
		      Dim valObj As VNSPDFType = dict.Value(keyStr)
		      Dim valStr As String = SerializeType(valObj)
		      result = result + " /" + keyStr + " " + valStr
		    Next
		    result = result + " >>"
		    Return result
		    
		  ElseIf obj IsA VNSPDFName Then
		    Return "/" + VNSPDFName(obj).value
		    
		  ElseIf obj IsA VNSPDFNumeric Then
		    // Format number properly for PDF - avoid scientific notation
		    Dim numVal As Double = VNSPDFNumeric(obj).value
		    // Check if it's effectively an integer
		    If Abs(numVal - Round(numVal)) < 0.0000001 Then
		      // Output as integer (no decimal point)
		      Return Str(CType(numVal, Int64))
		    Else
		      // Output as decimal with proper formatting (no scientific notation)
		      // Replace comma with period for locale-independence (PDF requires period)
		      Return FormatHelper(numVal, "-#########0.######").ReplaceAll(",", ".")
		    End If
		    
		  ElseIf obj IsA VNSPDFArray Then
		    // Serialize array: [item1 item2 item3]
		    Dim arr As VNSPDFArray = VNSPDFArray(obj)
		    Dim elements() As VNSPDFType = arr.value
		    Dim result As String = "["
		    For i As Integer = 0 To elements.LastIndex
		      If i > 0 Then result = result + " "
		      result = result + SerializeType(elements(i))
		    Next
		    result = result + "]"
		    Return result
		    
		  ElseIf obj IsA VNSPDFIndirectObjectReference Then
		    // REMAP indirect references by copying object from source to output
		    Dim ref As VNSPDFIndirectObjectReference = VNSPDFIndirectObjectReference(obj)
		    Dim newObjNum As Integer = CopyObjectFromSource(ref.objectNumber)
		    If newObjNum = 0 Then
		      // Failed to copy - keep original reference (fallback)
		      Return Str(ref.objectNumber) + " " + Str(ref.generation) + " R"
		    End If
		    Return Str(newObjNum) + " 0 R"

		  Else
		    // Fallback - unknown type
		    Return ""
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732063616C6C6261636B20666F7220637573746F6D2070616765206272652061636B206C6F6769632E0A
		Sub SetAcceptPageBreakFunc(acceptFunc As AcceptPageBreakDelegate)
		  // Set the callback function for custom page break logic
		  // The callback should return True to accept the page break, False to prevent it
		  //
		  // This allows custom logic to decide whether a page break should occur
		  // when automatic page breaking is triggered (e.g., by Cell() or MultiCell())
		  mAcceptPageBreakFunc = acceptFunc
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732074686520616C706861207472616E73706172656E63792076616C756520616E6420626C656E64206D6F646520666F72206772617068696373206F7065726174696F6E732E0A
		Sub SetAlpha(alpha As Double, blendMode As String = "")
		  // Check for existing error
		  If Err() Then
		    Return
		  End If
		  
		  // Validate blend mode
		  Dim validModes() As String = Array("Normal", "Multiply", "Screen", "Overlay", _
		  "Darken", "Lighten", "ColorDodge", "ColorBurn", "HardLight", "SoftLight", _
		  "Difference", "Exclusion", "Hue", "Saturation", "Color", "Luminosity")
		  
		  Dim modeStr As String
		  If blendMode = "" Then
		    modeStr = "Normal"
		  Else
		    modeStr = blendMode
		    Dim validMode As Boolean = False
		    For Each mode As String In validModes
		      If modeStr = mode Then
		        validMode = True
		        Exit
		      End If
		    Next
		    If Not validMode Then
		      Call SetError("Unrecognized blend mode: " + blendMode)
		      Return
		    End If
		  End If
		  
		  // Validate alpha value
		  If alpha < 0.0 Or alpha > 1.0 Then
		    Call SetError("Alpha value (0.0 - 1.0) is out of range: " + Str(alpha))
		    Return
		  End If
		  
		  // Store current alpha and blend mode
		  mAlpha = alpha
		  mBlendMode = modeStr
		  
		  // Create alphaStr with 3 decimals
		  Dim alphaStr As String = FormatPDF(alpha, 3)
		  
		  // Create key for blend map
		  Dim keyStr As String = alphaStr + " " + modeStr
		  
		  // Check if this blend mode already exists
		  Dim pos As Integer
		  If mBlendMap.HasKey(keyStr) Then
		    pos = mBlendMap.Value(keyStr)
		  Else
		    // Create new blend mode entry
		    pos = mBlendList.Count // at least 1 (index 0 is placeholder)
		    Dim bl As New VNSPDFBlendMode
		    bl.fillStr = alphaStr
		    bl.strokeStr = alphaStr
		    bl.modeStr = modeStr
		    bl.objNum = 0
		    mBlendList.Add(bl)
		    mBlendMap.Value(keyStr) = pos
		  End If
		  
		  // If we have blend modes and PDF version is too low, upgrade it
		  If mBlendMap.KeyCount > 0 And mPDFVersion < "1.4" Then
		    mPDFVersion = "1.4"
		  End If
		  
		  // Output graphics state command if page is active
		  If mPage > 0 Then
		    Dim cmd As String = "/GS" + Str(pos) + " gs" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732074686520646F63756D656E7420617574686F722E
		Sub SetAuthor(author As String)
		  // Set document author (will be UTF-16BE encoded if contains non-ASCII)
		  mAuthor = author
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E61626C6573206F722064697361626C657320636F6E74656E7420636F6D7072657373696F6E2E0A
		Sub SetAutoPageBreak(enable As Boolean, margin As Double = 0)
		  mAutoPageBreak = enable
		  
		  If margin > 0 Then
		    mBottomMargin = margin
		  End If
		  
		  // Calculate page break trigger position
		  mPageBreakTrigger = mPageHeight - mBottomMargin
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E61626C65732073696E676C652D70616765206D6F64653A20616C6C20636F6E74656E7420726E64657273206F6E206F6E65206C6F6E672070616765207769746820206E6F20627265616B732E2043616C6C20726967687420616674657220637265617465696E672074686520646F63756D656E742C206265666F72652072656E646572696E6720636F6E74656E742E
		Sub SetSinglePageMode(enable As Boolean)
		  // Enables single-page mode: all content on one long page with no breaks.
		  // Like a web page screenshot — no pagination.
		  // Call right after creating the document, before rendering content.
		  // After rendering, call FinalizeSinglePage() to trim the page to content height.
		  //
		  // Usage:
		  //   Dim pdf As New VNSPDFDocument
		  //   pdf.SetSinglePageMode(True)
		  //   VNSPDFHTMLPremium.LoadHTML(pdf, html)
		  //   pdf.FinalizeSinglePage()  // Trim page to actual content
		  //   pdf.Save(f)

		  mSinglePageMode = enable

		  If enable Then
		    // Set a very tall page (10 meters = 10000mm should be enough for any web page)
		    // Keep the current page width
		    Dim curWidth As Double = mPageWidth
		    If curWidth = 0 Then curWidth = 210  // Default A4 width

		    // Resize the current page to be very tall
		    mPageHeight = 10000
		    mPageHeightPt = mPageHeight * mScaleFactor
		    mCurPageSize = New Pair(mPageWidthPt, mPageHeightPt)
		    mPageSizes.Value(Str(mPage)) = mCurPageSize

		    // Disable auto page breaks
		    mAutoPageBreak = False
		    mPageBreakTrigger = mPageHeight  // No trigger
		    mBottomMargin = 10  // Keep some bottom margin for content
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207472756520696620696E2073696E676C652D70616765206D6F64652E
		Function GetSinglePageMode() As Boolean
		  Return mSinglePageMode
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416674657220736E676C652D70616765206D6F64652072656E646572696E672C207472696D207468652070616765206865696768742074206669742074686520616374756C20636F6E74656E742E
		Sub FinalizeSinglePage()
		  // After rendering content in single-page mode, crop the page to fit content.
		  // Content was rendered relative to a 10000mm tall page. We can't change the
		  // coordinate system after rendering, so instead we crop the MediaBox from
		  // the bottom — showing only the top portion where content lives.
		  //
		  // Must be called AFTER all content is rendered and BEFORE Save()/ToData().

		  If Not mSinglePageMode Then Return

		  // Content height = current Y position + bottom padding
		  Dim contentHeight As Double = mCurrentY + 10  // 10mm bottom padding

		  // The page is 10000mm tall. Content occupies the top contentHeight mm.
		  // In PDF coordinates (origin at bottom-left, Y up):
		  //   Content top is at PDF Y = pageH * sf (top of page)
		  //   Content bottom is at PDF Y = (pageH - contentHeight) * sf
		  // Set MediaBox lly to crop below the content
		  mSinglePageMediaBoxLly = (mPageHeight - contentHeight) * mScaleFactor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063656C6C206D617267696E2E2054686973206973207468652070616464696E6720286C65667420616E64207269676874292077697468696E2063656C6C7320286265666F726520616E64206166746572207468652074657874292E0A
		Sub SetCellMargin(margin As Double)
		  mCellMargin = margin

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E61626C6573206F722064697361626C657320636F6E74656E7420636F6D7072657373696F6E20696E2074686520504446206F75747075742E0A
		Sub SetCompression(enable As Boolean)
		  // Enable or disable stream compression (FlateDecode)
		  // Uses VNSZlibModule for zlib compression
		  mCompression = enable
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732074686520646F63756D656E742063726561746F722E
		Sub SetCreator(creator As String)
		  // Set document creator (application that created the original document)
		  // Will be UTF-16BE encoded if contains non-ASCII
		  mCreator = creator
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320746865206C696E652064617368207061747465726E2E
		Sub SetDashPattern(dashArray() As Double, dashPhase As Double)
		  // Store scaled dash array
		  ReDim mDashArray(-1)
		  For i As Integer = 0 To dashArray.LastIndex
		    mDashArray.Add(dashArray(i) * mScaleFactor)
		  Next
		  
		  // Store scaled dash phase
		  mDashPhase = dashPhase * mScaleFactor
		  
		  // Output dash pattern if page is active
		  If mPage > 0 Then
		    Call OutputDashPattern
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320646973706C6179206D6F646520666F72207A6F6F6D20616E64206C61796F75742E0A
		Sub SetDisplayMode(zoomStr As String, layoutStr As String = "default")
		  // Sets display mode for zoom and layout in PDF viewer
		  // zoomStr: "fullpage" (entire page), "fullwidth" (max width), "real" (100%),
		  //          "default" (viewer default), or a numeric string for zoom percentage (e.g. "75", "200")
		  // layoutStr: "single" (one page), "continuous" (continuous), "two" (two columns), "default" (viewer default)
		  //            Also accepts: "SinglePage", "OneColumn", "TwoColumnLeft", "TwoColumnRight",
		  //            "TwoPageLeft", "TwoPageRight"
		  //
		  // Example: SetDisplayMode("fullwidth", "continuous")
		  // Example: SetDisplayMode("75", "two")  // 75% zoom, two-column layout

		  // Check for errors first
		  If Err() Then Return

		  // Validate zoom mode (contribution: Geoff Bridges)
		  Select Case zoomStr
		  Case "fullpage", "fullwidth", "real", "default"
		    mZoomMode = zoomStr
		  Else
		    // Allow numeric zoom percentage (e.g. "75" for 75%, "200" for 200%)
		    If zoomStr.IsNumeric Then
		      mZoomMode = zoomStr
		    Else
		      Call SetError("Incorrect zoom display mode: " + zoomStr)
		      Return
		    End If
		  End Select

		  // Validate layout mode
		  Select Case layoutStr
		  Case "single", "continuous", "two", "default", "SinglePage", "OneColumn", _
		    "TwoColumnLeft", "TwoColumnRight", "TwoPageLeft", "TwoPageRight"
		    mLayoutMode = layoutStr
		  Else
		    Call SetError("Incorrect layout display mode: " + layoutStr)
		    Return
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652064726177696E6720636F6C6F72207573696E67206120586F6A6F20436F6C6F72206F626A6563742E0A
		Sub SetDrawColor(c As Color)
		  // Convenience overload that accepts a Xojo Color object
		  // Extracts RGB components and calls SetDrawColor(r, g, b)
		  //
		  // Example:
		  //   pdf.SetDrawColor(Color.Red)
		  //   pdf.SetDrawColor(&cFF8800)  // Orange
		  
		  Dim r As Integer = c.Red
		  Dim g As Integer = c.Green
		  Dim b As Integer = c.Blue

		  SetDrawColor(r, g, b)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652064726177696E6720636F6C6F7220696E205247422028302D323535292E0A
		Sub SetDrawColor(r As Integer, g As Integer, b As Integer)
		  // Clamp values to 0-255
		  r = Max(0, Min(255, r))
		  g = Max(0, Min(255, g))
		  b = Max(0, Min(255, b))
		  
		  // Convert to PDF color space (0-1)
		  Dim rPDF As Double = r / 255.0
		  Dim gPDF As Double = g / 255.0
		  Dim bPDF As Double = b / 255.0
		  
		  // Store draw color
		  mDrawColorR = r
		  mDrawColorG = g
		  mDrawColorB = b
		  
		  // Add PDF command to buffer if page is active
		  If mPage > 0 Then
		    Dim cmd As String = FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " RG" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E61626C6573204446207365637572697479207769746820612070726520636F6E6669677572656420656E6372797074696F6E206F626A6563742E0A
		Sub SetEncryption(encryption As VNSPDFEncryption)
		  // Enable PDF encryption using a pre-configured VNSPDFEncryption object
		  // This allows for more advanced configuration of encryption settings
		  
		  If mError <> "" Then Return
		  
		  mEncryption = encryption
		  
		  // Adjust PDF version based on encryption revision
		  Dim rev As Integer = encryption.Revision
		  If rev >= 5 And mPDFVersion < "1.7" Then
		    mPDFVersion = "1.7"
		  ElseIf rev = 4 And mPDFVersion < "1.6" Then
		    mPDFVersion = "1.6"
		  ElseIf rev >= 3 And mPDFVersion < "1.4" Then
		    mPDFVersion = "1.4"
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320616E20657272C3B672206D65737361676520746F2068616C7420504446206F656E65726174696F6E2E
		Sub SetError(errorMsg As String)
		  // Set error message to halt PDF generation
		  // Only sets error if no error already exists (first error wins)
		  If mError = "" And errorMsg <> "" Then
		    mError = errorMsg
		    // Log error to console for debugging
		    System.DebugLog("VNSPDFDocument Error: " + errorMsg)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320616E206572726F72206D657373616765207573696E67207072696E74662D7374796C6520666F726D617474696E672E204F6E6C792073657473206572726F72206966206E6F206572726F7220616C72656164792065786973747320286669727374206572726F722077696E73292E20537570706F7274733A2025732028737472696E67292C2025642F25692028696E7465676572292C2025662028666C6F6174292C20252E4E662028666C6F61742077697468204E20646563696D616C73292E0A
		Sub SetErrorf(format As String, ParamArray args() As Variant)
		  // Sets an error message using printf-style formatting.
		  // Only sets error if no error already exists (first error wins).
		  // Supports: %s (string), %d/%i (integer), %f (float), %.Nf (float with N decimals).
		  //
		  // Example:
		  //   pdf.SetErrorf("Invalid page number: %d", pageNum)
		  //   pdf.SetErrorf("Font '%s' not found at size %.1f", fontName, fontSize)

		  Dim formatted As String = VNSPDFModule.SprintfHelper(format, args)
		  Call SetError(formatted)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652066696C6C20636F6C6F72207573696E67206120586F6A6F20436F6C6F72206F626A6563742E0A
		Sub SetFillColor(c As Color)
		  // Convenience overload that accepts a Xojo Color object
		  // Extracts RGB components and calls SetFillColor(r, g, b)
		  //
		  // Example:
		  //   pdf.SetFillColor(Color.Blue)
		  //   pdf.SetFillColor(&cFFFF00)  // Yellow
		  
		  Dim r As Integer = c.Red
		  Dim g As Integer = c.Green
		  Dim b As Integer = c.Blue

		  SetFillColor(r, g, b)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652066696C6C20636F6C6F7220696E205247422028302D323535292E0A353529
		Sub SetFillColor(r As Integer, g As Integer, b As Integer)
		  // Clamp values to 0-255
		  r = Max(0, Min(255, r))
		  g = Max(0, Min(255, g))
		  b = Max(0, Min(255, b))
		  
		  // Convert to PDF color space (0-1)
		  Dim rPDF As Double = r / 255.0
		  Dim gPDF As Double = g / 255.0
		  Dim bPDF As Double = b / 255.0
		  
		  // Store fill color
		  mFillColorR = r
		  mFillColorG = g
		  mFillColorB = b
		  
		  // Add PDF command to buffer if page is active
		  // This is needed for Rect(), Circle(), and other graphics primitives
		  // Cell() will output its own fill color command as needed
		  If mPage > 0 Then
		    Dim cmd As String = FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " rg" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063757272656E7420666F6E7420666F722074657874206F75747075742E
		Sub SetFont(family As String, style As String = "", size As Double = 0.0)
		  // Normalize font family name (lowercase, no spaces)
		  family = family.Lowercase.Trim
		  
		  // If empty, keep current family
		  If family = "" Then
		    family = mFontFamily
		  End If
		  
		  // Normalize style
		  style = style.Uppercase.Trim
		  
		  // If size is 0, keep current size
		  If size = 0.0 Then
		    size = mFontSize
		  End If
		  
		  // Store font properties
		  mFontFamily = family
		  mFontStyle = style
		  mFontSize = size
		  mFontSizePt = size
		  
		  // Build font key (family + style)
		  Dim fontKey As String = family + style

		  // Check if font is already loaded
		  If Not mFonts.HasKey(fontKey) Then
		    // For UTF-8 fonts, try base font (without style) as fallback
		    // Many Unicode fonts don't have B/I/U variants - PDF viewers can synthesize them
		    If style <> "" And mFonts.HasKey(family) Then
		      Dim baseFontInfo As Dictionary = mFonts.Value(family)
		      If baseFontInfo.Value("type") = "UTF8" Then
		        // Use base UTF-8 font without style variant
		        fontKey = family
		      End If
		    End If
		  End If

		  // Check again if font is loaded (after potential fallback)
		  If Not mFonts.HasKey(fontKey) Then
		    // PDF/A compliance: All fonts must be embedded (core fonts not allowed)
		    If IsPDFAMode() Then
		      Dim ex As New RuntimeException
		      ex.Message = "PDF/A compliance violation: Core fonts are not allowed in PDF/A mode. " + _
		      "Font '" + family + "' must be embedded using AddUTF8Font() or AddUTF8FontFromBytes(). " + _
		      "PDF/A requires all fonts to be embedded for archival compliance."
		      Raise ex
		    End If

		    // For now, only support core fonts
		    // Core fonts: helvetica, times, courier, symbol, zapfdingbats
		    Select Case family
		    Case "helvetica", "arial"
		      Call AddCoreFont("helvetica", style)
		    Case "times"
		      Call AddCoreFont("times", style)
		    Case "courier"
		      Call AddCoreFont("courier", style)
		    Case "symbol"
		      Call AddCoreFont("symbol", "")
		    Case "zapfdingbats"
		      Call AddCoreFont("zapfdingbats", "")
		    Else
		      Call SetError("Unknown font family: " + family)
		      Return
		    End Select
		  End If

		  // Set current font
		  mCurrentFont = fontKey
		  
		  // If page is active, output font selection
		  If mPage > 0 Then
		    Call OutputFontSelection
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652066696C652073797374656D206C6F636174696F6E206F6620666F6E742066696C65732E
		Sub SetFontLocation(fontPath As String)
		  // SetFontLocation sets the directory path for font files.
		  // This path is used when loading fonts with AddFont() or AddUTF8Font().
		  // fontPath: Directory path containing font files (can be empty to use default)
		  
		  mFontPath = fontPath
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 446566696E6573207468652073697A65206F66207468652063757272656E7420666F6E7420696E20706F696E74732028312F373220696E6368292E
		Sub SetFontSize(size As Double)
		  // SetFontSize defines the size of the current font in points (1/72 inch).
		  // This allows changing font size without changing family or style.
		  
		  mFontSizePt = size
		  mFontSize = size
		  
		  // If page is active, output font selection with new size
		  If mPage > 0 Then
		    Call OutputFontSelection
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4368616E676573207468652063757272656E7420666F6E74207374796C6520776974686F7574206368616E67696E6720666F6E742066616D696C79206F722073697A652E
		Sub SetFontStyle(style As String)
		  // SetFontStyle changes the current font style without changing family or size.
		  // This is equivalent to SetFont(currentFamily, style, currentSize)
		  
		  Call SetFont(mFontFamily, style, mFontSizePt)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E61626C65206F722064697361626C6520666F6E742073756273657474696E6720666F7220547275655479706520666F6E74732E0A
		Sub SetFontSubsetting(enable As Boolean)
		  // Enable or disable TrueType font subsetting
		  // When enabled, only used glyphs are included in embedded fonts
		  // Expected file size reduction: 50-90% for large Unicode fonts
		  mEnableFontSubsetting = enable
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652073697A65206F66207468652063757272656E7420666F6E7420696E207573657220756E6974732E0A
		Sub SetFontUnitSize(size As Double)
		  // SetFontUnitSize defines the size of the current font in user units (mm/cm/inches).
		  // This allows changing font size without changing family or style.
		  // size: Font size in current document units (mm, cm, inches, or points)
		  
		  mFontSize = size
		  mFontSizePt = size * mScaleFactor  // Convert to points
		  
		  // If page is active, output font selection with new size
		  If mPage > 0 Then
		    Call OutputFontSelection
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063616C6C6261636B2066756E6374696F6E20666F72206175746F6D61746963206865616465722072656E646572696E672E205468652063616C6C6261636B2069732063616C6C6564206174207468652073746172742066206561636820706167652E0A
		Sub SetFooterFunc(footerFunc As HeaderFooterDelegate)
		  // Set the footer callback function
		  // The callback will receive this document instance as a parameter
		  // and can call drawing methods like SetFont(), Cell(), Line(), etc.
		  mFooterFunc = footerFunc
		  mHasFooterFunc = True

		  // Auto-detect footer height and adjust page break trigger
		  If mPage > 0 Then MeasureAndApplyFooterHeight()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473666F6F7465722066756E6374696F6E207769746820706167657320706572696E636820636F6E74726F6C2E0A
		Sub SetFooterFuncLpi(footerFunc As FooterDelegateLpi)
		  // Set the footer callback function with "last page indicator" (Lpi)
		  // The callback receives a Boolean parameter indicating if this is the last page
		  //
		  // This allows different footer content on the last page vs. other pages.
		  mFooterFuncLpi = footerFunc
		  mHasFooterFuncLpi = True
		  mHasFooterFunc = False  // Clear standard footer if Lpi version is set

		  // Auto-detect footer height and adjust page break trigger
		  If mPage > 0 Then MeasureAndApplyFooterHeight()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MeasureAndApplyFooterHeight()
		  // Dry-run the footer callback to measure its height, then adjust
		  // the page break trigger so data rows never overlap the footer.
		  // Saves rendering state, calls footer with tracking enabled,
		  // measures the Y position from the first SetY() call, then restores.

		  // Save state
		  Dim savedBuffer As String = mBuffer
		  Dim savedX As Double = mCurrentX
		  Dim savedY As Double = mCurrentY
		  Dim savedFontFamily As String = mFontFamily
		  Dim savedFontStyle As String = mFontStyle
		  Dim savedFontSize As Double = mFontSizePt

		  // Enable measurement tracking (SetY will record the first Y position)
		  mMeasuringFooter = True
		  mFooterMeasuredY = 0

		  // Run footer callback
		  mInHeaderFooter = True
		  If mHasFooterFuncLpi Then
		    mFooterFuncLpi.Invoke(Self, False)
		  ElseIf mHasFooterFunc Then
		    mFooterFunc.Invoke(Self)
		  End If
		  mInHeaderFooter = False
		  mMeasuringFooter = False

		  // Restore state and discard footer output
		  mBuffer = savedBuffer
		  mCurrentX = savedX
		  mCurrentY = savedY
		  Call SetFont(savedFontFamily, savedFontStyle, savedFontSize)

		  // Apply measured footer height
		  // mFooterMeasuredY = the Y from the footer's first SetY() call
		  // e.g. SetY(-20) on a 210mm page → mFooterMeasuredY = 190
		  // Footer margin = mPageHeight - mFooterMeasuredY = 20mm
		  If mFooterMeasuredY > 0 Then
		    Dim footerMargin As Double = mPageHeight - mFooterMeasuredY + 2.0
		    If footerMargin > mBottomMargin Then
		      mBottomMargin = footerMargin
		      mPageBreakTrigger = mPageHeight - mBottomMargin
		    End If
		  End If
		  mFooterMeasuredY = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063616C6C6261636B2066756E6374696F6E20666F72206175746F6D61746963206865616465722072656E646572696E672E205468652063616C6C6261636B2069732063616C6C656420617420746865207374617274206F66206561636820706167652E0A
		Sub SetHeaderFunc(headerFunc As HeaderFooterDelegate)
		  // Set the header callback function
		  // The callback will receive this document instance as a parameter
		  // and can call drawing methods like SetFont(), Cell(), etc.
		  //
		  // IMPORTANT: Call this BEFORE drawing any content. The constructor
		  // auto-adds page 1, and the header callback only fires on AddPage().
		  // If set before any drawing, the header is retroactively rendered on page 1.
		  mHeaderFunc = headerFunc
		  mHasHeaderFunc = True

		  // If page 1 already exists (auto-added by constructor) and nothing
		  // has been drawn yet, retroactively render the header on this page.
		  If mPage = 1 And mCurrentY = mTopMargin And mCurrentX = mLeftMargin Then
		    CallHeader()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473206865616465722066756E6374696F6E20776974682068696D6520706F736974696F6E20636F6E74726F6C2E0A
		Sub SetHeaderFuncMode(headerFunc As HeaderFooterDelegate, homeMode As Boolean)
		  // Set the header callback function with home position mode
		  // homeMode: If True, resets X/Y to top-left margins after header renders
		  //
		  // This is useful when header contains background elements (watermarks, etc.)
		  // and you want to ensure the normal content starts at the expected position.
		  mHeaderFunc = headerFunc
		  mHasHeaderFunc = True
		  mHeaderHomeMode = homeMode
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265676973746572206120637573746f6d2068616e646c657220666f7220616e2048544d4c207461672e2048616e646c65722069732063616c6c656420647572696e672072656e646572696e6720696e7374656164206f66206275696c742d696e206c6f6769632e
		Sub RegisterHTMLTagHandler(tagName As String, handler As HTMLTagHandlerDelegate)
		  Dim key As String = tagName.Lowercase
		  Dim idx As Integer = mHTMLTagHandlerNames.IndexOf(key)
		  If idx >= 0 Then
		    mHTMLTagHandlerDelegates(idx) = handler
		  Else
		    mHTMLTagHandlerNames.Add(key)
		    mHTMLTagHandlerDelegates.Add(handler)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656d6f766520612070726576696f75736c7920726567697374657265642048544d4c207461672068616e646c65722e
		Sub RemoveHTMLTagHandler(tagName As String)
		  Dim key As String = tagName.Lowercase
		  Dim idx As Integer = mHTMLTagHandlerNames.IndexOf(key)
		  If idx < 0 Then Return
		  mHTMLTagHandlerNames.RemoveAt(idx)
		  mHTMLTagHandlerDelegates.RemoveAt(idx)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656d6f766520616c6c20726567697374657265642048544d4c207461672068616e646c6572732e
		Sub RemoveAllHTMLTagHandlers()
		  mHTMLTagHandlerNames.RemoveAll
		  mHTMLTagHandlerDelegates.RemoveAll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436865636b206966206120637573746f6d2068616e646c6572206973207265676973746572656420666f722074686520676976656e2048544d4c20746167206e616d652e
		Function HasHTMLTagHandler(tagName As String) As Boolean
		  Return mHTMLTagHandlerNames.IndexOf(tagName.Lowercase) >= 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4765742074686520726567697374657265642068616e646c65722064656c656761746520666f722074686520676976656e2048544d4c20746167206e616d652e
		Function GetHTMLTagHandler(tagName As String) As HTMLTagHandlerDelegate
		  Dim key As String = tagName.Lowercase
		  Dim idx As Integer = mHTMLTagHandlerNames.IndexOf(key)
		  If idx >= 0 Then Return mHTMLTagHandlerDelegates(idx)
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265676973746572206120637573746f6d2068616e646c657220666f722061204d61726b646f776e206c696e65207072656669782e2048616e646c65722069732063616c6c656420647572696e67204d61726b646f776e2d746f2d48544d4c20636f6e76657273696f6e2e
		Sub RegisterMarkdownHandler(prefix As String, handler As MarkdownLineHandlerDelegate)
		  Dim idx As Integer = mMarkdownHandlerPrefixes.IndexOf(prefix)
		  If idx >= 0 Then
		    mMarkdownHandlerDelegates(idx) = handler
		  Else
		    mMarkdownHandlerPrefixes.Add(prefix)
		    mMarkdownHandlerDelegates.Add(handler)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656d6f766520612070726576696f75736c792072656769737465726564204d61726b646f776e206c696e652068616e646c65722e
		Sub RemoveMarkdownHandler(prefix As String)
		  Dim idx As Integer = mMarkdownHandlerPrefixes.IndexOf(prefix)
		  If idx < 0 Then Return
		  mMarkdownHandlerPrefixes.RemoveAt(idx)
		  mMarkdownHandlerDelegates.RemoveAt(idx)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656d6f766520616c6c2072656769737465726564204d61726b646f776e206c696e652068616e646c6572732e
		Sub RemoveAllMarkdownHandlers()
		  mMarkdownHandlerPrefixes.RemoveAll
		  mMarkdownHandlerDelegates.RemoveAll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 47657420746865206172726179206f66207265676973746572656420707265666978657320666f72204d61726b646f776e2068616e646c6572732e
		Function MarkdownHandlerPrefixes() As String()
		  Return mMarkdownHandlerPrefixes
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 47657420746865204d61726b646f776e2068616e646c657220666f72206120676976656e207072656669782e
		Function GetMarkdownHandler(prefix As String) As MarkdownLineHandlerDelegate
		  Dim idx As Integer = mMarkdownHandlerPrefixes.IndexOf(prefix)
		  If idx >= 0 Then Return mMarkdownHandlerDelegates(idx)
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063757272656E7420706F736974696F6E20746F20746865206C65667420616E6420746F70206D617267696E732028686F6D6520706F736974696F6E292E0A
		Sub SetHomeXY()
		  mCurrentY = mTopMargin
		  mCurrentX = mLeftMargin
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732074686520646F63756D656E74206B6579776F7264732E
		Sub SetKeywords(keywords As String)
		  // Set document keywords (space-delimited, e.g. "invoice August")
		  // Will be UTF-16BE encoded if contains non-ASCII
		  mKeywords = keywords
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320746865206C616E6775616765206F662074686520646F63756D656E742E
		Sub SetLang(lang As String)
		  // Set natural language of document (e.g. "en-US", "de-CH", "fr-FR")
		  mLang = lang
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652066756C6C206D617267696E7320696E206F6E652063616C6C2E0A
		Sub SetLeftMargin(margin As Double)
		  mLeftMargin = margin
		  
		  // Update current X position if on a page
		  If mPage > 0 And mCurrentX < mLeftMargin Then
		    mCurrentX = mLeftMargin
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320746865206C696E6520636170207374796C652028627574742C20726F756E642C20737175617265292E
		Sub SetLineCapStyle(style As String)
		  // Normalize style string
		  style = style.Lowercase.Trim
		  
		  // Convert style string to PDF integer value
		  Dim capStyle As Integer
		  Select Case style
		  Case "round"
		    capStyle = 1
		  Case "square"
		    capStyle = 2
		  Else  // "butt" or default
		    capStyle = 0
		  End Select
		  
		  mLineCapStyle = capStyle
		  
		  // Add PDF command to buffer if page is active
		  If mPage > 0 Then
		    Dim cmd As String = Str(mLineCapStyle) + " J" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320746865206C696E65206A6F696E207374796C6520286D697465722C20726F756E642C20626576656C292E
		Sub SetLineJoinStyle(style As String)
		  // Normalize style string
		  style = style.Lowercase.Trim
		  
		  // Convert style string to PDF integer value
		  Dim joinStyle As Integer
		  Select Case style
		  Case "round"
		    joinStyle = 1
		  Case "bevel"
		    joinStyle = 2
		  Else  // "miter" or default
		    joinStyle = 0
		  End Select
		  
		  mLineJoinStyle = joinStyle
		  
		  // Add PDF command to buffer if page is active
		  If mPage > 0 Then
		    Dim cmd As String = Str(mLineJoinStyle) + " j" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652077696474206F662064726177696E67206C696E65732E
		Sub SetLineWidth(width As Double)
		  mLineWidth = width
		  
		  // Add PDF command to buffer if page is active
		  If mPage > 0 Then
		    Dim cmd As String = FormatPDF(width * mScaleFactor) + " w" + EndOfLine.UNIX
		    mBuffer = mBuffer + cmd
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 446566696E657320746865207061676520616E6420706F736974696F6E20612F6E6B20706F696E747320746F2E0A
		Sub SetLink(linkID As Integer, y As Double = -1, pageNum As Integer = -1)
		  // Set the destination for an internal link
		  // linkID: The link identifier returned by AddLink()
		  // y: Vertical position on the destination page (-1 for current position)
		  // pageNum: Destination page number (-1 for current page)
		  
		  // Validate link ID
		  If linkID < 0 Or linkID > mLinks.LastIndex Then
		    Call SetError("Invalid link ID: " + Str(linkID))
		    Return
		  End If
		  
		  // Use current position if y = -1
		  Dim destY As Double = y
		  If destY = -1 Then
		    destY = mCurrentY
		  End If
		  
		  // Use current page if pageNum = -1
		  Dim destPage As Integer = pageNum
		  If destPage = -1 Then
		    destPage = mPage
		  End If
		  
		  // Update link destination
		  mLinks(linkID).Value("page") = destPage
		  mLinks(linkID).Value("y") = destY
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652066756C6C206D617267696E7320696E206F6E652063616C6C2E0A
		Sub SetMargins(left As Double, top As Double, right As Double = -1)
		  mLeftMargin = left
		  mTopMargin = top
		  
		  If right < 0 Then
		    mRightMargin = left
		  Else
		    mRightMargin = right
		  End If
		  
		  // Update current position if on a page
		  If mPage > 0 Then
		    If mCurrentX < mLeftMargin Then
		      mCurrentX = mLeftMargin
		    End If
		    If mCurrentY < mTopMargin Then
		      mCurrentY = mTopMargin
		    End If
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063757272656E742070616765206E756D6265722E0A
		Sub SetPage(pageNum As Integer)
		  // Set current page to specified page number
		  // pageNum: Page number to switch to (1-based, must be between 1 and PageCount)

		  If pageNum > 0 And pageNum <= mPages.KeyCount Then
		    If pageNum <> mPage Then
		      // Save current page buffer before switching
		      mPages.Value(Str(mPage)) = mBuffer
		      // Load target page buffer
		      mPage = pageNum
		      If mPages.HasKey(Str(mPage)) Then
		        mBuffer = mPages.Value(Str(mPage))
		      Else
		        mBuffer = ""
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207061676520626F7820666F722063757272656E7420616E64206675747572652070616765732E0A
		Sub SetPageBox(boxType As String, x As Double, y As Double, width As Double, height As Double)
		  // Sets the page box for the current page and any following pages
		  // boxType: "trim"/"trimbox", "crop"/"cropbox", "bleed"/"bleedbox", "art"/"artbox" (case insensitive)
		  // x, y: Coordinates of the box (in user units)
		  // width, height: Dimensions of the box (in user units)
		  //
		  // Page boxes define various boundaries for professional printing and display:
		  // - TrimBox: Final trimmed page dimensions after production
		  // - CropBox: Visible region when displayed/printed
		  // - BleedBox: Region including bleed margins for printing
		  // - ArtBox: Meaningful content area (excluding margins/white space)
		  
		  If Err() Then Return
		  
		  // Normalize box type to standard PDF names
		  Dim normalizedType As String
		  Select Case boxType.Lowercase
		  Case "trim", "trimbox"
		    normalizedType = "TrimBox"
		  Case "crop", "cropbox"
		    normalizedType = "CropBox"
		  Case "bleed", "bleedbox"
		    normalizedType = "BleedBox"
		  Case "art", "artbox"
		    normalizedType = "ArtBox"
		  Else
		    Call SetError(boxType + " is not a valid page box type (use trim, crop, bleed, or art)")
		    Return
		  End Select
		  
		  // Create box data dictionary with coordinates in PDF points
		  Dim boxData As New Dictionary
		  Dim k As Double = mScaleFactor
		  
		  // Store coordinates: convert to PDF points and adjust width/height to absolute coordinates
		  boxData.Value("x") = x * k
		  boxData.Value("y") = y * k
		  boxData.Value("width") = (width * k) + (x * k)    // Absolute right coordinate
		  boxData.Value("height") = (height * k) + (y * k)  // Absolute top coordinate
		  
		  // Store for current page if one exists
		  If mPage > 0 Then
		    Dim pageKey As String = Str(mPage)
		    
		    // Get or create page-specific boxes dictionary
		    Dim pageBoxDict As Dictionary
		    If mPageBoxes.HasKey(pageKey) Then
		      pageBoxDict = mPageBoxes.Value(pageKey)
		    Else
		      pageBoxDict = New Dictionary
		      mPageBoxes.Value(pageKey) = pageBoxDict
		    End If
		    
		    // Store box for this page
		    pageBoxDict.Value(normalizedType) = boxData
		  End If
		  
		  // Always update default boxes (applied to future pages)
		  mDefPageBoxes.Value(normalizedType) = boxData
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320746865205044462070726F6475636572206D657461646174612E0A
		Sub SetProducer(producer As String)
		  // Set PDF producer (application that generated the PDF)
		  // Will be UTF-16BE encoded if contains non-ASCII
		  mProducer = producer
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E61626C657320504446207365637572697479207769746820706173737764726473616E64207065726D697373696F6E732E0A
		Sub SetProtection(userPassword As String, ownerPassword As String = "", allowPrint As Boolean = True, allowModify As Boolean = True, allowCopy As Boolean = True, allowAnnotate As Boolean = True, allowFillForms As Boolean = True, allowExtract As Boolean = True, allowAssemble As Boolean = True, allowPrintHighQuality As Boolean = True, revision As Integer = VNSPDFModule.gkEncryptionAES128)
		  // Enable PDF encryption with granular permissions (all 8 PDF permission bits)
		  //
		  // userPassword: Password required to open the document (if non-empty)
		  // ownerPassword: Password to change permissions (defaults to userPassword if empty)
		  //
		  // Permissions (all default to True for maximum access):
		  //   allowPrint: Allow low-quality printing (Bit 3)
		  //   allowModify: Allow document modification (Bit 4)
		  //   allowCopy: Allow copying text and graphics (Bit 5)
		  //   allowAnnotate: Allow adding/modifying annotations and signatures (Bit 6)
		  //   allowFillForms: Allow filling in form fields (Bit 8, Revision 3+)
		  //   allowExtract: Allow text extraction for accessibility (Bit 9, Revision 3+)
		  //   allowAssemble: Allow page insertion/rotation/deletion (Bit 10, Revision 3+)
		  //   allowPrintHighQuality: Allow high-resolution printing (Bit 11, Revision 3+)
		  //
		  // revision: Encryption revision:
		  //   - VNSPDFModule.gkEncryptionRC4_40 (2) = 40-bit RC4 [FREE]
		  //   - VNSPDFModule.gkEncryptionRC4_128 (3) = 128-bit RC4 [PREMIUM]
		  //   - VNSPDFModule.gkEncryptionAES128 (4) = 128-bit AES [PREMIUM] (default)
		  //   - VNSPDFModule.gkEncryptionAES256 (5) = 256-bit AES [PREMIUM]
		  //   - VNSPDFModule.gkEncryptionAES256_PDF2 (6) = 256-bit AES PDF 2.0 [PREMIUM]
		  
		  If mError <> "" Then Return
		  
		  // Check premium module requirement for revisions 3-6
		  If revision >= 3 And revision <= 6 Then
		    #If Not hasPremiumVNSEncryptionModule Then
		      Call SetError("Encryption revisions 3-6 (RC4-128 and AES) require premium Encryption module. Only RC4-40 (revision 2) is available in free version.")
		      Return
		    #EndIf
		  End If
		  
		  // Create encryption object with specified revision
		  mEncryption = New VNSPDFEncryption(revision)
		  
		  // Set passwords (use same password for both if owner password not specified)
		  Dim owner As String = ownerPassword
		  If owner = "" Then
		    owner = userPassword
		  End If
		  Call mEncryption.SetPasswords(userPassword, owner)
		  
		  // Set permissions (all 8 bits)
		  Call mEncryption.SetPermissions(allowPrint, allowModify, allowCopy, allowAnnotate, allowFillForms, allowExtract, allowAssemble, allowPrintHighQuality)
		  
		  // PDF encryption requires minimum version 1.4 for AES, 1.5 for revision 3+
		  If revision >= VNSPDFModule.gkEncryptionAES256 And mPDFVersion < "1.7" Then
		    mPDFVersion = "1.7"
		  ElseIf revision = VNSPDFModule.gkEncryptionAES128 And mPDFVersion < "1.6" Then
		    mPDFVersion = "1.6"
		  ElseIf revision >= VNSPDFModule.gkEncryptionRC4_128 And mPDFVersion < "1.4" Then
		    mPDFVersion = "1.4"
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652066756C6C206D617267696E7320696E206F6E652063616C6C2E0A
		Sub SetRightMargin(margin As Double)
		  mRightMargin = margin
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F70656E732061205044462066696C6520666F7220696D706F7274696E672070616765732E0A
		Function SetSourceFile(path As String) As Integer
		  // Open a PDF file for importing pages
		  // path: Full path to the PDF file to import from
		  // Returns: Number of pages in the source PDF, or 0 on error
		  
		  // Check for errors first
		  If Err() Then Return 0
		  
		  // Create a new PDF reader
		  mSourceReader = New VNSPDFReader
		  
		  // Open the PDF file
		  If Not mSourceReader.OpenFile(path) Then
		    Call SetError("Failed to open PDF file: " + path)
		    mSourceReader = Nil
		    Return 0
		  End If
		  
		  // Clear object ID mapping for new source file
		  mImportedObjectMap = New Dictionary
		  
		  // Return page count
		  Return mSourceReader.GetPageCount()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732074686520646F63756D656E74207375626A6563742E
		Sub SetSubject(subject As String)
		  // Set document subject (will be UTF-16BE encoded if contains non-ASCII)
		  mSubject = subject
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320746865207465787420636F6C6F72207573696E67206120586F6A6F20436F6C6F72206F626A6563742E0A
		Sub SetTextColor(c As Color)
		  // Convenience overload that accepts a Xojo Color object
		  // Extracts RGB components and calls SetTextColor(r, g, b)
		  //
		  // Example:
		  //   pdf.SetTextColor(Color.Black)
		  //   pdf.SetTextColor(&c0000FF)  // Blue
		  
		  Dim r As Integer = c.Red
		  Dim g As Integer = c.Green
		  Dim b As Integer = c.Blue

		  SetTextColor(r, g, b)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652074657874206F6C6F7220666F722074657874206F75747075742E
		Sub SetTextColor(r As Integer, g As Integer, b As Integer)
		  // Clamp values to 0-255
		  r = Max(0, Min(255, r))
		  g = Max(0, Min(255, g))
		  b = Max(0, Min(255, b))
		  
		  // Store text color (will be applied before text output)
		  mTextColorR = r
		  mTextColorG = g
		  mTextColorB = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetTextRise(rise As Double)
		  // Sets the text rise in points for subscript (negative) or superscript (positive)
		  mTextRise = rise
		  If rise <> 0.0 Then mTextRiseDirty = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTextRise() As Double
		  // Returns the current text rise in points
		  Return mTextRise
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320746865207265686465726E67206D6F6465206F6620666F6C6C6F77696E6720746578742E
		Sub SetTextRenderingMode(mode As Integer)
		  // SetTextRenderingMode sets the rendering mode of following text.
		  // The mode can be as follows:
		  //  0: Fill text
		  //  1: Stroke text
		  //  2: Fill, then stroke text
		  //  3: Neither fill nor stroke text (invisible)
		  //  4: Fill text and add to path for clipping
		  //  5: Stroke text and add to path for clipping
		  //  6: Fill, then stroke text and add to path for clipping
		  //  7: Add text to path for clipping
		  
		  If mode >= 0 And mode <= 7 Then
		    If mPage > 0 Then
		      mBuffer = mBuffer + Str(mode) + " Tr" + EndOfLine.UNIX
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732074686520646F63756D656E74207469746C652E
		Sub SetTitle(title As String)
		  // Set document title (will be UTF-16BE encoded if contains non-ASCII)
		  mTitle = title
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20536176657320746865205044462066696C652E20416C69617320666F7220536176654E6F7446696C6528292E
		Sub Save(file As FolderItem)
		  // Xojo PDFDocument.Save compatible method
		  // Saves the PDF document to the specified file
		  If file <> Nil Then
		    SaveToFile(file.NativePath)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2052657475726E73207468652050444620636F6E74656E74206173204D656D6F7279426C6F636B2E20416C69617320666F72204F757470757428292E
		Function ToData() As MemoryBlock
		  // Xojo PDFDocument.ToData compatible method
		  // Returns the PDF content as a MemoryBlock
		  Dim content As String = Output()
		  Dim mb As New MemoryBlock(content.Bytes)
		  mb.StringValue(0, content.Bytes) = content
		  Return mb
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20416476616E63657320746F20746865206E65787420706167652E20416C69617320666F722041646450616765282E
		Sub NextPage()
		  // Xojo PDFDocument.NextPage compatible method
		  // Advances to the next page (creates new page)
		  AddPage(mDefOrientation)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20416476616E63657320746F206E65787420706167652077697468207370656369666965642064696D656E73696F6E732E
		Sub NextPage(width As Double, height As Double)
		  // Xojo PDFDocument.NextPage(w, h) compatible method
		  // Advances to the next page with specified dimensions (in points)
		  // Convert from points to current units
		  Dim wUser As Double = width / mScaleFactor
		  Dim hUser As Double = height / mScaleFactor
		  AddPageFormat("P", wUser, hUser)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20504446446F63756D656E742E416464466F6E747320636F6D70617469626C65206D6574686F64202D204C6F616420666F6E742066696C6520666F72207573652077697468207468652050444620646F63756D656E742E0A
		Sub AddFonts(f As FolderItem)
		  // Xojo PDFDocument.AddFonts compatible method
		  // Load font file (typically a .ttf file)
		  // Use filename without extension as font family name
		  If f = Nil Or Not f.Exists Then Return

		  Dim fontFamily As String = f.Name
		  // Strip extension
		  Dim parts() As String = fontFamily.Split(".")
		  If parts.Count > 1 Then
		    parts.RemoveAt(parts.LastIndex)
		    fontFamily = String.FromArray(parts, ".")
		  End If

		  // Add font with empty style (regular)
		  AddUTF8Font(fontFamily, "", f.NativePath)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20504446446F63756D656E742E436C656172436163686520636F6D70617469626C65206D6574686F64202D20436C6561722074656D706F7261727920666F6E742063616368652E0A
		Sub ClearCache()
		  // Xojo PDFDocument.ClearCache compatible method
		  // VNS PDF doesn't cache font files, so this is a no-op for compatibility
		  // Could be extended in future to clean up temp directories
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 586F6A6F20504446446F63756D656E742E54656D706C61746520636F6D70617469626C65206D6574686F64202D204578706F727420646F63756D656E7420636F6E66696775726174696F6E206173204A534F4E4974656D2074656D706C6174652E0A
		Function Template() As JSONItem
		  // Xojo PDFDocument.Template compatible method
		  // Export document configuration as JSONItem template
		  // Uses VNSPDFDocument.ToJSON() for serialization
		  Dim jsonStr As String = ToJSON(True) // Pretty print for readability

		  // Parse JSON string into JSONItem
		  Dim json As New JSONItem(jsonStr)
		  Return json
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652066756C6C206D617267696E7320696E206F6E652063616C6C2E0A
		Sub SetTopMargin(margin As Double)
		  mTopMargin = margin
		  
		  // Update current Y position if on a page
		  If mPage > 0 And mCurrentY < mTopMargin Then
		    mCurrentY = mTopMargin
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652074686963686E657373206F6620756E6465726C696E6520666F7220746578742E
		Sub SetUnderlineThickness(thickness As Double)
		  // SetUnderlineThickness accepts a multiplier for adjusting the text underline
		  // thickness, defaulting to 1. Values > 1 make underlines thicker, < 1 make them thinner.
		  
		  mUnderlineThickness = thickness
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207370616369676E67206265747765656E20776F726473206F6620666F6C6C6F77696E6720746578742E
		Sub SetWordSpacing(space As Double)
		  // SetWordSpacing sets spacing between words of following text.
		  // Space is specified in user units.
		  
		  mWordSpacing = space
		  
		  // Output word spacing command if page is active
		  If mPage > 0 Then
		    mBuffer = mBuffer + FormatPDF(space * mScaleFactor) + " Tw" + EndOfLine.UNIX
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063757272656E74205820706F736974696F6E206F6E2074686520706167652E0A
		Sub SetX(x As Double)
		  mCurrentX = x
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5365747320584D50206D657461646174612028584D4C2920666F722074686520646F63756D656E742E0A
		Sub SetXmpMetadata(xmpStream As String)
		  // Set XMP (Extensible Metadata Platform) metadata for the document
		  // xmpStream: XML string containing XMP metadata
		  // XMP is required for PDF/A compliance and provides advanced metadata support
		  //
		  // Example:
		  // Dim xmp As String = "<?xpacket begin="""" id=""""?>" + EndOfLine
		  // xmp = xmp + "<x:xmpmeta xmlns:x=""adobe:ns:meta/"">" + EndOfLine
		  // xmp = xmp + "  <rdf:RDF xmlns:rdf=""http://www.w3.org/1999/02/22-rdf-syntax-ns#"">" + EndOfLine
		  // xmp = xmp + "    <rdf:Description rdf:about="""" xmlns:dc=""http://purl.org/dc/elements/1.1/"">" + EndOfLine
		  // xmp = xmp + "      <dc:title><rdf:Alt><rdf:li xml:lang=""x-default"">Document Title</rdf:li></rdf:Alt></dc:title>" + EndOfLine
		  // xmp = xmp + "    </rdf:Description>" + EndOfLine
		  // xmp = xmp + "  </rdf:RDF>" + EndOfLine
		  // xmp = xmp + "</x:xmpmeta>" + EndOfLine
		  // xmp = xmp + "<?xpacket end=""w""?>"
		  // pdf.SetXmpMetadata(xmp)
		  
		  mXmpMetadata = xmpStream
		  
		  // XMP metadata requires PDF 1.4 or later
		  If mPDFVersion < "1.4" Then
		    mPDFVersion = "1.4"
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063757272656E7420582C5920706F736974696F6E206F6E2074686520706167652E0A
		Sub SetXY(x As Double, y As Double)
		  mCurrentX = x
		  mCurrentY = y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652063757272656E74205920706F736974696F6E206F6E2074686520706167652E0A
		Sub SetY(y As Double)
		  // Reset X to left margin
		  mCurrentX = mLeftMargin

		  // Handle negative values as distance from bottom
		  If y >= 0 Then
		    mCurrentY = y
		  Else
		    mCurrentY = mPageHeight + y
		  End If

		  // Track footer start Y during measurement
		  If mMeasuringFooter And mFooterMeasuredY = 0 Then
		    mFooterMeasuredY = mCurrentY
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ShapeArabicText(txt As String) As String
		  // Shape Arabic text by converting base Unicode characters to presentation forms
		  // This handles basic Arabic joining behavior for proper rendering
		  // Returns: Shaped text with Arabic presentation forms + reversed RTL text
		  
		  // Arabic Unicode ranges
		  Const kArabicStart = &h0600
		  Const kArabicEnd = &h06FF
		  Const kArabicPresentationFormsAStart = &hFB50
		  Const kArabicPresentationFormsAEnd = &hFDFF
		  Const kArabicPresentationFormsBStart = &hFE70
		  Const kArabicPresentationFormsBEnd = &hFEFF

		  // Check if text contains Arabic characters (base or presentation forms)
		  Dim hasArabic As Boolean = False
		  Dim codePoints() As Integer = UTF8ToCodePoints(txt)

		  For i As Integer = 0 To codePoints.LastIndex
		    Dim cp As Integer = codePoints(i)
		    If (cp >= kArabicStart And cp <= kArabicEnd) Or _
		      (cp >= kArabicPresentationFormsAStart And cp <= kArabicPresentationFormsAEnd) Or _
		      (cp >= kArabicPresentationFormsBStart And cp <= kArabicPresentationFormsBEnd) Then
		      hasArabic = True
		      Exit For i
		    End If
		  Next
		  
		  // If no Arabic, return original text
		  If Not hasArabic Then
		    Return txt
		  End If
		  
		  // Apply Arabic shaping (convert base letters to presentation forms)
		  Dim shaped() As Integer
		  
		  For i As Integer = 0 To codePoints.LastIndex
		    Dim cp As Integer = codePoints(i)
		    
		    // Check if this is an Arabic letter that needs shaping
		    If IsArabicLetter(cp) Then
		      // Determine position: 0=isolated, 1=initial, 2=final, 3=medial
		      Dim position As Integer = 0  // Default: isolated
		      
		      // Check if previous letter joins to this one
		      Dim hasJoiningPrev As Boolean = False
		      If i > 0 Then
		        Dim prevCP As Integer = codePoints(i - 1)
		        If IsArabicLetter(prevCP) And DoesArabicLetterJoinToNext(prevCP) Then
		          hasJoiningPrev = True
		        End If
		      End If
		      
		      // Check if this letter joins to next one
		      Dim hasJoiningNext As Boolean = False
		      If i < codePoints.Count - 1 Then
		        Dim nextCP As Integer = codePoints(i + 1)
		        If IsArabicLetter(nextCP) And DoesArabicLetterJoinToNext(cp) Then
		          hasJoiningNext = True
		        End If
		      End If
		      
		      // Determine position based on joining context
		      If hasJoiningPrev And hasJoiningNext Then
		        position = 3  // Medial
		      ElseIf hasJoiningPrev And Not hasJoiningNext Then
		        position = 2  // Final
		      ElseIf Not hasJoiningPrev And hasJoiningNext Then
		        position = 1  // Initial
		      Else
		        position = 0  // Isolated
		      End If
		      
		      // Get the appropriate presentation form
		      Dim shapedCP As Integer = GetArabicPresentationForm(cp, position)
		      shaped.Add(shapedCP)
		    Else
		      // Not an Arabic letter - keep as-is
		      shaped.Add(cp)
		    End If
		  Next
		  
		  // Reverse ONLY the Arabic runs for RTL visual display in PDF
		  // PDF renders LTR, so Arabic must be reversed for correct visual order
		  Dim reversed() As Integer

		  Dim i As Integer = 0
		  While i < shaped.Count
		    Dim cp As Integer = shaped(i)

		    // Check if this starts an Arabic run (including presentation forms)
		    If IsArabicCodePoint(cp) Then
		      // Find the end of this Arabic run
		      Dim runStart As Integer = i
		      Dim runEnd As Integer = i

		      While runEnd < shaped.Count
		        Dim nextCP As Integer = shaped(runEnd)
		        // Continue while Arabic, space, or punctuation/digits within Arabic text
		        If IsArabicCodePoint(nextCP) Or IsNeutralInArabicRun(nextCP) Then
		          runEnd = runEnd + 1
		        Else
		          Exit While
		        End If
		      Wend

		      // Trim trailing neutral characters (spaces, punctuation) from run end
		      // only when there is non-Arabic text following (prevents neutrals between
		      // Arabic and Latin from being reversed). When the run reaches the end of
		      // the string, keep all neutrals so brackets get properly mirrored.
		      If runEnd < shaped.Count Then
		        While runEnd > runStart + 1
		          Dim tailCP As Integer = shaped(runEnd - 1)
		          If Not IsArabicCodePoint(tailCP) Then
		            runEnd = runEnd - 1
		          Else
		            Exit While
		          End If
		        Wend
		      End If

		      // Reverse this entire Arabic run and mirror brackets
		      For j As Integer = runEnd - 1 DownTo runStart
		        reversed.Add(MirrorBracket(shaped(j)))
		      Next

		      i = runEnd  // Continue after this run
		    Else
		      // Non-Arabic character - keep as-is
		      reversed.Add(cp)
		      i = i + 1
		    End If
		  Wend
		  
		  // Convert code points back to UTF-8 string
		  Dim result As String = CodePointsToUTF8(reversed)
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsArabicCodePoint(cp As Integer) As Boolean
		  // Check if code point is in any Arabic range (base, extended, presentation forms)
		  Return (cp >= &h0600 And cp <= &h06FF) Or _
		    (cp >= &hFB50 And cp <= &hFDFF) Or _
		    (cp >= &hFE70 And cp <= &hFEFF)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsNeutralInArabicRun(cp As Integer) As Boolean
		  // Check if code point is neutral (can appear within an Arabic run)
		  // Includes spaces, common punctuation, digits, and math symbols
		  If cp = &h0020 Then Return True  // Space
		  If cp = &h00A0 Then Return True  // Non-breaking space
		  If cp >= &h0030 And cp <= &h0039 Then Return True  // ASCII digits 0-9
		  If cp >= &h0660 And cp <= &h0669 Then Return True  // Arabic-Indic digits
		  // Punctuation and brackets
		  Select Case cp
		  Case &h0028, &h0029  // ( )
		    Return True
		  Case &h005B, &h005D  // [ ]
		    Return True
		  Case &h007B, &h007D  // { }
		    Return True
		  Case &h00AB, &h00BB  // « »
		    Return True
		  Case &h2018, &h2019  // ' '
		    Return True
		  Case &h201C, &h201D  // " "
		    Return True
		  Case &h002C, &h002E  // , .
		    Return True
		  Case &h003A, &h003B  // : ;
		    Return True
		  Case &h0021, &h003F  // ! ?
		    Return True
		  Case &h002D, &h002F  // - /
		    Return True
		  Case &h060C  // Arabic comma
		    Return True
		  Case &h061B  // Arabic semicolon
		    Return True
		  Case &h061F  // Arabic question mark
		    Return True
		  End Select
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MirrorBracket(cp As Integer) As Integer
		  // Mirror bracket/parenthesis characters for RTL display
		  Select Case cp
		  Case &h0028  // ( → )
		    Return &h0029
		  Case &h0029  // ) → (
		    Return &h0028
		  Case &h005B  // [ → ]
		    Return &h005D
		  Case &h005D  // ] → [
		    Return &h005B
		  Case &h007B  // { → }
		    Return &h007D
		  Case &h007D  // } → {
		    Return &h007B
		  Case &h00AB  // « → »
		    Return &h00BB
		  Case &h00BB  // » → «
		    Return &h00AB
		  Case &h2018  // ' → '
		    Return &h2019
		  Case &h2019  // ' → '
		    Return &h2018
		  Case &h201C  // " → "
		    Return &h201D
		  Case &h201D  // " → "
		    Return &h201C
		  End Select
		  Return cp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53706C697473207465787420696E746F206C696E65732074686174206669742077697468696E207468652073706563696669656420776964746820696E207573657220756E6974732E0A
		Function SplitLines(txt As String, w As Double) As String()
		  // SplitLines splits text into lines that fit within the specified width.
		  // This is a public wrapper around the private SplitTextToLines method.
		  
		  Return SplitTextToLines(txt, w)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53706C69747320746578742069C3B76E746F206C696E65732074686174206669742077697468696E2074686520737065636966696564207769645468C2B62E
		Private Function SplitTextToLines(txt As String, maxWidth As Double) As String()
		  Dim lines() As String

		  // Handle newline characters (GB 08/12/24)
		  // Remove CR characters and split by LF
		  txt = txt.ReplaceAll(Chr(13), "")
		  Dim paragraphs() As String = txt.Split(Chr(10))

		  // Process each paragraph separately
		  For Each paragraph As String In paragraphs
		    Dim words() As String = paragraph.Split(" ")
		    Dim currentLine As String = ""

		    For Each word As String In words
		    Dim testLine As String
		    If currentLine = "" Then
		      testLine = word
		    Else
		      testLine = currentLine + " " + word
		    End If
		    
		    Dim lineWidth As Double = GetStringWidth(testLine)
		    
		    If lineWidth <= maxWidth Then
		      currentLine = testLine
		    Else
		      // Line is too long, save current line and start new one
		      If currentLine <> "" Then
		        lines.Add(currentLine)
		      End If
		      currentLine = word
		      
		      // Check if single word is too long
		      If GetStringWidth(word) > maxWidth Then
		        // Word is too long to fit, break it up
		        Dim chars() As String
		        #If TargetiOS Or TargetAndroid Then
		          Dim wordLen As Integer = word.Length
		          For i As Integer = 0 To wordLen - 1  // iOS: 0-based Middle()
		            chars.Add(word.Middle(i, 1))
		          Next
		        #Else
		          Dim wordLen As Integer = word.Length  // Use String.Length for character count
		          For i As Integer = 0 To wordLen - 1  // Desktop/Console/Web: 0-based Middle() (GB 08/12/24 - Fixed to start at 0)
		            chars.Add(word.Middle(i, 1))  // Middle() is UTF-8 safe
		          Next
		        #EndIf
		        
		        currentLine = ""
		        For Each ch As String In chars
		          If GetStringWidth(currentLine + ch) <= maxWidth Then
		            currentLine = currentLine + ch
		          Else
		            If currentLine <> "" Then
		              lines.Add(currentLine)
		            End If
		            currentLine = ch
		          End If
		        Next
		      End If
		    End If
		  Next

		  // Add remaining text from current paragraph
		  If currentLine <> "" Then
		    lines.Add(currentLine)
		  End If
		Next // paragraph

		Return lines
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F75747075747320746578742061742074686520737065636966696564206C6F636174696F6E2E
		Sub Text(x As Double, y As Double, txt As String)
		  // Check if page is active
		  If mPage = 0 Then
		    mError = mError + "Cannot output text: no page added yet." + EndOfLine
		    Return
		  End If

		  // Check if font is set
		  If mCurrentFont = "" Then
		    mError = mError + "Cannot output text: no font selected. Call SetFont first." + EndOfLine
		    Return
		  End If

		  CheckBounds(x, y, 0, 0, "Text")

		  // Check if current font is UTF8
		  Dim isUTF8 As Boolean = False
		  Dim ttf As VNSPDFTrueTypeFont = Nil
		  Dim encodedText As String = ""
		  Dim glyphMapping As Dictionary = Nil
		  
		  If mFonts.HasKey(mCurrentFont) Then
		    Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		    If fontInfo.HasKey("type") And fontInfo.Value("type") = "UTF8" Then
		      isUTF8 = True
		      If fontInfo.HasKey("ttf") Then
		        ttf = fontInfo.Value("ttf")
		      End If
		      
		      // Get glyph mapping if font was subset
		      If fontInfo.HasKey("glyphMapping") Then
		        glyphMapping = fontInfo.Value("glyphMapping")
		      End If
		      
		      // Track used Unicode characters AFTER shaping
		      // Shape Arabic text first (converts to presentation forms)
		      Dim shapedText As String = ShapeArabicText(txt)
		      
		      If fontInfo.HasKey("usedRunes") Then
		        Dim usedRunes As Dictionary = fontInfo.Value("usedRunes")
		        
		        // Convert shaped text to Unicode code points (handles multi-byte UTF-8)
		        Dim shapedCodePoints() As Integer = UTF8ToCodePoints(shapedText)
		        
		        For i As Integer = 0 To shapedCodePoints.LastIndex
		          Dim codePoint As Integer = shapedCodePoints(i)
		          usedRunes.Value(Str(codePoint)) = codePoint
		        Next
		      End If
		    End If
		  End If
		  
		  // Encode text based on font type
		  If isUTF8 And ttf <> Nil Then
		    // Use UTF-16BE encoding for UTF8 fonts with glyph mapping for subset fonts
		    encodedText = EncodeTextForTrueType(txt, ttf, glyphMapping)
		  Else
		    // Use standard PDF string escaping for core fonts
		    encodedText = "(" + EscapeText(txt) + ")"
		  End If
		  
		  // Convert coordinates to PDF space
		  // ALWAYS use Y-flip because user ALWAYS provides coordinates in user space (top-left origin)
		  Dim xPDF As Double = x * mScaleFactor
		  Dim yPDF As Double = (mPageHeight - y) * mScaleFactor

		  // Output text command
		  Dim cmd As String = ""
		  
		  // Output text color before text
		  Dim rPDF As Double = mTextColorR / 255.0
		  Dim gPDF As Double = mTextColorG / 255.0
		  Dim bPDF As Double = mTextColorB / 255.0
		  cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " rg" + EndOfLine.UNIX
		  
		  cmd = cmd + "BT" + EndOfLine.UNIX // Begin Text
		  
		  // Set font inside text object (REQUIRED in PDF)
		  If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		    Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		    Dim fontNum As Integer = fontInfo.Value("number")
		    cmd = cmd + "/F" + Str(fontNum) + " " + FormatPDF(mFontSizePt) + " Tf" + EndOfLine.UNIX
		  End If
		  
		  cmd = cmd + FormatPDF(xPDF) + " " + FormatPDF(yPDF) + " Td" + EndOfLine.UNIX // Text position
		  cmd = cmd + encodedText + " Tj" + EndOfLine.UNIX // Show text (hex for TrueType, escaped for core fonts)
		  cmd = cmd + "ET" + EndOfLine.UNIX // End Text
		  
		  // Draw underline if style contains "U"
		  If mFontStyle.IndexOf("U") >= 0 Then
		    If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		      Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		      
		      // Get underline position and thickness from font metrics
		      Dim up As Double = -100 // Default underline position
		      Dim ut As Double = 50   // Default underline thickness
		      
		      If fontInfo.HasKey("up") Then
		        up = fontInfo.Value("up")
		      End If
		      If fontInfo.HasKey("ut") Then
		        ut = fontInfo.Value("ut")
		      End If
		      
		      // Calculate underline position and thickness in user units
		      // up and ut are in font units (1000 units = 1 em)
		      Dim underlineOffset As Double = up * mFontSizePt / 1000.0
		      Dim underlineThickness As Double = ut * mFontSizePt / 1000.0 * mUnderlineThickness
		      
		      // Calculate underline Y position (in PDF coordinates)
		      Dim underlineY As Double = yPDF + (underlineOffset * mScaleFactor)
		      
		      // Set line width for underline
		      cmd = cmd + FormatPDF(underlineThickness * mScaleFactor) + " w " + EndOfLine.UNIX
		      
		      // Set line color to text color
		      cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " RG " + EndOfLine.UNIX
		      
		      // Draw underline from start to end of text
		      Dim textWidth As Double = GetStringWidth(txt) * mScaleFactor
		      cmd = cmd + FormatPDF(xPDF) + " " + FormatPDF(underlineY) + " m " + EndOfLine.UNIX
		      cmd = cmd + FormatPDF(xPDF + textWidth) + " " + FormatPDF(underlineY) + " l S " + EndOfLine.UNIX
		    End If
		  End If
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 466F726D61742061207465787420737472696E6720666F722050444620286573636170656420616E64207772617070656420696E20706172656E7468657365732920666F72206F75747075742E0A
		Sub TextRaw(x As Double, y As Double, txt As String)
		  // Output text at exact coordinates without Y-flip conversion.
		  // Used when inside transformation contexts where coordinates are already in transformed space.
		  // x, y: Coordinates in user units (no conversion applied)
		  
		  // Check if page is active
		  If mPage = 0 Then
		    mError = mError + "Cannot output text: no page added yet." + EndOfLine
		    Return
		  End If
		  
		  // Check if font is set
		  If mCurrentFont = "" Then
		    mError = mError + "Cannot output text: no font selected. Call SetFont first." + EndOfLine
		    Return
		  End If
		  
		  // Convert to PDF units WITHOUT Y-flip
		  Dim xPDF As Double = x * mScaleFactor
		  Dim yPDF As Double = y * mScaleFactor
		  
		  // Format text for PDF
		  Dim textStr As String = EscapeText(txt)
		  
		  // Output text command
		  Dim cmd As String = "BT" + EndOfLine.UNIX
		  cmd = cmd + FormatPDF(xPDF) + " " + FormatPDF(yPDF) + " Td" + EndOfLine.UNIX
		  cmd = cmd + "(" + textStr + ") Tj" + EndOfLine.UNIX
		  cmd = cmd + "ET" + EndOfLine.UNIX

		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod


	#tag Method, Flags = &h21, Description = 466F726D61742061207465787420737472696E6720666F722050444620286573636170656420616E64207772617070656420696E20706172656E7468657365732920666F72206F75747075742E0A
		Private Function TextString(txt As String) As String
		  // Format a text string for PDF output (wrapped in parentheses with escaping)
		  // This is used for PDF string literals in the document structure
		  // Returns: (escaped text)
		  
		  Return "(" + EscapeText(txt) + ")"
		End Function
	#tag EndMethod
	#tag Method, Flags = &h0, Description = 53657269616C697A657320646F63756D656E7420737461746520746F204A534F4E20737472696E672E0A
		Function ToJSON(prettyPrint As Boolean = False) As String
		  // Serializes the current document state to a JSON string.
		  // prettyPrint: If True, formats JSON with indentation for readability
		  // Returns: JSON string representation of the document state
		  
		  Dim state As New Dictionary
		  
		  // Basic metadata
		  state.Value("version") = VNSPDFModule.gkVersion
		  state.Value("title") = mTitle
		  state.Value("author") = mAuthor
		  state.Value("subject") = mSubject
		  state.Value("keywords") = mKeywords
		  state.Value("creator") = mCreator
		  state.Value("lang") = mLang
		  
		  // Page configuration
		  state.Value("pageWidth") = mPageWidth
		  state.Value("pageHeight") = mPageHeight
		  state.Value("leftMargin") = mLeftMargin
		  state.Value("topMargin") = mTopMargin
		  state.Value("rightMargin") = mRightMargin
		  state.Value("pageBreakTrigger") = mPageBreakTrigger
		  state.Value("scaleFactor") = mScaleFactor
		  state.Value("currentPage") = mPage
		  state.Value("pageCount") = mPages.KeyCount
		  
		  // Current state
		  state.Value("currentX") = mCurrentX
		  state.Value("currentY") = mCurrentY
		  state.Value("state") = mState
		  
		  // Font state (simple properties only, not full font objects)
		  state.Value("currentFont") = mCurrentFont
		  state.Value("fontFamily") = mFontFamily
		  state.Value("fontStyle") = mFontStyle
		  state.Value("fontSizePt") = mFontSizePt
		  state.Value("fontNumber") = mFontNumber
		  
		  // Colors
		  Dim drawColor As New Dictionary
		  drawColor.Value("r") = mDrawColorR
		  drawColor.Value("g") = mDrawColorG
		  drawColor.Value("b") = mDrawColorB
		  state.Value("drawColor") = drawColor
		  
		  Dim fillColor As New Dictionary
		  fillColor.Value("r") = mFillColorR
		  fillColor.Value("g") = mFillColorG
		  fillColor.Value("b") = mFillColorB
		  state.Value("fillColor") = fillColor
		  
		  Dim textColor As New Dictionary
		  textColor.Value("r") = mTextColorR
		  textColor.Value("g") = mTextColorG
		  textColor.Value("b") = mTextColorB
		  state.Value("textColor") = textColor
		  
		  // Line properties
		  state.Value("lineWidth") = mLineWidth
		  
		  // Orientation and format
		  state.Value("curOrientation") = mCurOrientation
		  state.Value("defOrientation") = mDefOrientation
		  
		  // Note: We don't serialize complex objects like fonts, images, pages content
		  // as those would be too large and contain binary data. This serializes
		  // the document configuration and current state only.
		  
		  Try
		    Return GenerateJSON(state, prettyPrint)
		  Catch e As RuntimeException
		    Call SetError("ToJSON error: " + e.Message)
		    Return "{}"
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4170706C6965732061207472616E73666F726D6174696F6E206D6174726978206469726563746C792E0A
		Sub Transform(a As Double, b As Double, c As Double, d As Double, e As Double, f As Double)
		  // Applies a transformation matrix to the current transformation matrix (CTM).
		  // Matrix format: [a b c d e f] represents transformation matrix:
		  //   | a  b  0 |
		  //   | c  d  0 |
		  //   | e  f  1 |
		  //
		  // Check if we have a page to draw on
		  If mPage = 0 Then Return

		  // Must be inside a transformation context
		  If mTransformNest = 0 Then
		    Call SetError("Transform must be called between TransformBegin() and TransformEnd()")
		    Return
		  End If
		  
		  // Output transformation matrix command (cm = concatenate matrix)
		  Dim cmd As String = FormatPDF(a, 6) + " " + _
		  FormatPDF(b, 6) + " " + _
		  FormatPDF(c, 6) + " " + _
		  FormatPDF(d, 6) + " " + _
		  FormatPDF(e, 6) + " " + _
		  FormatPDF(f, 6) + " cm" + EndOfLine.UNIX
		  
		  mBuffer = mBuffer + cmd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E732061207472616E73666F726D6174696F6E20636F6E746578742E0A
		Sub TransformBegin()
		  // Begins a transformation context for subsequent text, drawings and images.
		  // Typical usage:
		  //   TransformBegin()
		  //   TransformRotate(45, x, y)
		  //   Cell/Text/Line/etc...
		  //   TransformEnd()
		  //
		  // All transformation contexts must be properly ended with TransformEnd().

		  // Check if we have a page to draw on
		  If mPage = 0 Then Return

		  // Increment nesting level
		  mTransformNest = mTransformNest + 1
		  
		  // Output save graphics state command
		  mBuffer = mBuffer + "q" + EndOfLine.UNIX
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E6473206120657863697374696E67207472616E73666F726D6174696F6E20636F6E746578742E0A
		Sub TransformEnd()
		  // Ends a transformation context that was begun with TransformBegin().
		  // Restores the graphics state to before the transformation.

		  // Check if we have a page to draw on
		  If mPage = 0 Then Return

		  // Check for nesting errors
		  If mTransformNest > 0 Then
		    // Decrement nesting level
		    mTransformNest = mTransformNest - 1
		    
		    // Output restore graphics state command
		    mBuffer = mBuffer + "Q" + EndOfLine.UNIX
		  Else
		    Call SetError("TransformEnd() called without matching TransformBegin()")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4D6972726F727320686F72697A6F6E74616C6C79206174205820617869732E0A
		Sub TransformMirrorHorizontal(x As Double)
		  // Mirrors (flips) the following text, drawings and images horizontally.
		  // x: X-coordinate of the vertical axis of reflection in user units
		  //
		  // Example: TransformMirrorHorizontal(105) mirrors horizontally at page center (A4 width = 210mm)
		  
		  // Check for errors first
		  If Err() Then Return
		  
		  // Horizontal mirror: negative X scale, normal Y scale
		  // Uses current Y position as the point
		  Call TransformScale(-100, 100, x, mCurrentY)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4D6972726F727320616C6F6E67206C696E6520617420616E676C652E0A
		Sub TransformMirrorLine(angle As Double, x As Double, y As Double)
		  // Mirrors (flips) the following text, drawings and images along a line.
		  // angle: Angle of the mirror line in degrees, counter-clockwise from 3 o'clock
		  // (x, y): Point on the mirror line in user units
		  //
		  // Example: TransformMirrorLine(45, 105, 148.5) mirrors along 45° diagonal through center
		  
		  // Check for errors first
		  If Err() Then Return
		  
		  // Line mirror: horizontal flip + rotation
		  // Formula: Scale(-100, 100) at point, then Rotate(-2*(angle-90)) at point
		  Call TransformScale(-100, 100, x, y)
		  Call TransformRotate(-2 * (angle - 90), x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4D6972726F727320617420706F696E742028782C2079292E0A
		Sub TransformMirrorPoint(x As Double, y As Double)
		  // Mirrors (flips) the following text, drawings and images at a point.
		  // Creates a 180° rotation effect around the point (x, y).
		  // (x, y): Center point of mirroring in user units
		  //
		  // Example: TransformMirrorPoint(105, 148.5) mirrors at page center
		  
		  // Check for errors first
		  If Err() Then Return
		  
		  // Point mirror: negative X and Y scales (180° rotation effect)
		  Call TransformScale(-100, -100, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4D6972726F727320766572746963616C6C79206174205920617869732E0A
		Sub TransformMirrorVertical(y As Double)
		  // Mirrors (flips) the following text, drawings and images vertically.
		  // y: Y-coordinate of the horizontal axis of reflection in user units
		  //
		  // Example: TransformMirrorVertical(148.5) mirrors vertically at page center (A4 height = 297mm)
		  
		  // Check for errors first
		  If Err() Then Return
		  
		  // Vertical mirror: normal X scale, negative Y scale
		  // Uses current X position as the point
		  Call TransformScale(100, -100, mCurrentX, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526F74617465732074657874202F20677261706869637320636F756E7465722D636C6F636B77697365206172C3B36E6420612063656E74657220706F696E742E0A
		Sub TransformRotate(angle As Double, x As Double, y As Double)
		  // Rotates the following text, drawings and images around the center point (x, y).
		  // angle: Rotation angle in degrees, measured counter-clockwise from the 3 o'clock position
		  // (x, y): Center point of rotation in user units
		  //
		  // Example: TransformRotate(45, 100, 100) rotates 45° counter-clockwise around point (100, 100)

		  // Check if we have a page to draw on
		  If mPage = 0 Then Return

		  // Convert user coordinates to PDF coordinates
		  Dim yPDF As Double = (mPageHeight - y) * mScaleFactor
		  Dim xPDF As Double = x * mScaleFactor
		  
		  // Convert angle to radians
		  Const kPi As Double = 3.14159265358979323846
		  Dim angleRad As Double = angle * kPi / 180.0
		  
		  // Calculate transformation matrix components
		  // Rotation matrix around origin:
		  //   | cos(θ)  sin(θ) |
		  //   | -sin(θ) cos(θ) |
		  // Translation to rotate around (x,y):
		  //   tx = x + sin(θ)*y - cos(θ)*x
		  //   ty = y - cos(θ)*y - sin(θ)*x
		  
		  Dim cosAngle As Double = Cos(angleRad)
		  Dim sinAngle As Double = Sin(angleRad)
		  
		  Dim a As Double = cosAngle
		  Dim b As Double = sinAngle
		  Dim c As Double = -sinAngle
		  Dim d As Double = cosAngle
		  Dim e As Double = xPDF + sinAngle * yPDF - cosAngle * xPDF
		  Dim f As Double = yPDF - cosAngle * yPDF - sinAngle * xPDF
		  
		  // Apply transformation matrix
		  Call Transform(a, b, c, d, e, f)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616C6573207465787420616E6420677261706869637320617420706F696E742028782C2079292E0A
		Sub TransformScale(scaleWd As Double, scaleHt As Double, x As Double, y As Double)
		  // Scales the following text, drawings and images around the point (x, y).
		  // scaleWd: Width scaling factor in percent (100 = 100%, 50 = 50%, 200 = 200%)
		  // scaleHt: Height scaling factor in percent
		  // (x, y): Center point of scaling in user units
		  //
		  // Example: TransformScale(150, 75, 100, 100) scales 150% wide and 75% tall around point (100, 100)
		  
		  // Check for errors first
		  If Err() Then Return
		  
		  // Convert user coordinates to PDF coordinates
		  Dim yPDF As Double = (mPageHeight - y) * mScaleFactor
		  Dim xPDF As Double = x * mScaleFactor
		  
		  // Convert percentages to decimal (100% = 1.0)
		  Dim sw As Double = scaleWd / 100.0
		  Dim sh As Double = scaleHt / 100.0
		  
		  // Calculate transformation matrix components
		  // Scaling matrix around point (x,y):
		  //   | sw  0  |
		  //   | 0   sh |
		  // Translation: tx = x*(1-sw), ty = y*(1-sh)
		  
		  Dim a As Double = sw
		  Dim b As Double = 0
		  Dim c As Double = 0
		  Dim d As Double = sh
		  Dim e As Double = xPDF * (1 - sw)
		  Dim f As Double = yPDF * (1 - sh)
		  
		  // Apply transformation matrix
		  Call Transform(a, b, c, d, e, f)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616C6573207769647468206F6E6C7920617420706F696E742028782C2079292E0A
		Sub TransformScaleX(scaleWd As Double, x As Double, y As Double)
		  // Scales width only around the point (x, y).
		  // scaleWd: Width scaling factor in percent (100 = 100%, 50 = 50%, 200 = 200%)
		  // (x, y): Center point of scaling in user units
		  //
		  // Example: TransformScaleX(150, 100, 100) scales 150% wide only around point (100, 100)
		  
		  Call TransformScale(scaleWd, 100, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616C657320626F746820776964746820616E642068656967687420657175616C6C7920617420706F696E742028782C2079292E0A
		Sub TransformScaleXY(s As Double, x As Double, y As Double)
		  // Scales both width and height equally around the point (x, y).
		  // s: Scaling factor in percent (100 = 100%, 50 = 50%, 200 = 200%)
		  // (x, y): Center point of scaling in user units
		  //
		  // Example: TransformScaleXY(150, 100, 100) scales 150% in both directions around point (100, 100)
		  
		  Call TransformScale(s, s, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616C657320686569676874206F6E6C7920617420706F696E742028782C2079292E0A
		Sub TransformScaleY(scaleHt As Double, x As Double, y As Double)
		  // Scales height only around the point (x, y).
		  // scaleHt: Height scaling factor in percent (100 = 100%, 50 = 50%, 200 = 200%)
		  // (x, y): Center point of scaling in user units
		  //
		  // Example: TransformScaleY(75, 100, 100) scales 75% tall only around point (100, 100)
		  
		  Call TransformScale(100, scaleHt, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536B657773207465787420616E6420677261706869637320617420706F696E742028782C2079292E0A
		Sub TransformSkew(angleX As Double, angleY As Double, x As Double, y As Double)
		  // Skews the following text, drawings and images around the point (x, y).
		  // angleX: Skew angle along X axis in degrees
		  // angleY: Skew angle along Y axis in degrees
		  // (x, y): Center point of skewing in user units
		  //
		  // Example: TransformSkew(15, 0, 100, 100) skews 15° along X axis around point (100, 100)
		  
		  // Check for errors first
		  If Err() Then Return
		  
		  // Convert user coordinates to PDF coordinates
		  Dim yPDF As Double = (mPageHeight - y) * mScaleFactor
		  Dim xPDF As Double = x * mScaleFactor
		  
		  // Convert angles to radians and calculate tangents
		  Const kPi As Double = 3.14159265358979323846
		  Dim tanX As Double = Tan(angleX * kPi / 180.0)
		  Dim tanY As Double = Tan(angleY * kPi / 180.0)
		  
		  // Skew matrix:
		  //   | 1     tan(ay) |
		  //   | tan(ax)  1    |
		  // Translation: e = -tan(ax)*y, f = -tan(ay)*x
		  
		  Dim a As Double = 1
		  Dim b As Double = tanY
		  Dim c As Double = tanX
		  Dim d As Double = 1
		  Dim e As Double = -tanX * yPDF
		  Dim f As Double = -tanY * xPDF
		  
		  // Apply transformation matrix
		  Call Transform(a, b, c, d, e, f)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536B657773207465787420616E6420677261706869637320616C6F6E672058206178697320617420706F696E742028782C2079292E0A
		Sub TransformSkewX(angleX As Double, x As Double, y As Double)
		  // Skews the following text, drawings and images along X axis only around point (x, y).
		  // angleX: Skew angle along X axis in degrees
		  // (x, y): Center point of skewing in user units
		  //
		  // Example: TransformSkewX(15, 100, 100) skews 15° along X axis only
		  
		  Call TransformSkew(angleX, 0, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536B657773207465787420616E6420677261706869637320616C6F6E672059206178697320617420706F696E742028782C2079292E0A
		Sub TransformSkewY(angleY As Double, x As Double, y As Double)
		  // Skews the following text, drawings and images along Y axis only around point (x, y).
		  // angleY: Skew angle along Y axis in degrees
		  // (x, y): Center point of skewing in user units
		  //
		  // Example: TransformSkewY(15, 100, 100) skews 15° along Y axis only
		  
		  Call TransformSkew(0, angleY, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5472616E736C61746573207465787420616E642067726170686963732E0A
		Sub TransformTranslate(tx As Double, ty As Double)
		  // Translates (moves) the following text, drawings and images.
		  // tx: Translation distance along X axis in user units (positive = right)
		  // ty: Translation distance along Y axis in user units (positive = down)
		  //
		  // Example: TransformTranslate(10, 20) moves everything 10 units right and 20 units down
		  
		  // Check for errors first
		  If Err() Then Return
		  
		  // Convert user coordinates to PDF coordinates
		  // X translation: positive = right (same in both systems)
		  // Y translation: positive down in user coords = negative up in PDF coords
		  Dim txPDF As Double = tx * mScaleFactor
		  Dim tyPDF As Double = -ty * mScaleFactor
		  
		  // Translation matrix:
		  //   | 1  0 |
		  //   | 0  1 |
		  // Translation: e = tx, f = ty
		  
		  Dim a As Double = 1
		  Dim b As Double = 0
		  Dim c As Double = 0
		  Dim d As Double = 1
		  Dim e As Double = txPDF
		  Dim f As Double = tyPDF
		  
		  // Apply transformation matrix
		  Call Transform(a, b, c, d, e, f)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5472616E736C61746573207465787420616E6420677261706869637320616C6F6E67205820617869732E0A
		Sub TransformTranslateX(tx As Double)
		  // Translates (moves) the following text, drawings and images along X axis only.
		  // tx: Translation distance along X axis in user units (positive = right)
		  //
		  // Example: TransformTranslateX(10) moves everything 10 units right
		  
		  Call TransformTranslate(tx, 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5472616E736C61746573207465787420616E6420677261706869637320616C6F6E67205920617869732E0A
		Sub TransformTranslateY(ty As Double)
		  // Translates (moves) the following text, drawings and images along Y axis only.
		  // ty: Translation distance along Y axis in user units (positive = down)
		  //
		  // Example: TransformTranslateY(20) moves everything 20 units down
		  
		  Call TransformTranslate(0, ty)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506C6163657320616E20696D706F727465642050444620706167652061742074686520737065696669656420636F6F7264696E6174732E0A
		Sub UseTemplate(templateID As Integer, x As Double = 0, y As Double = 0, w As Double = 0, h As Double = 0)
		  // Place an imported PDF page at the specified coordinates
		  // templateID: Template ID returned by ImportPage()
		  // x, y: Position on current page (in user units)
		  // w, h: Width and height (0 = use original page size)
		  
		  // Check for errors first
		  If Err() Then
		    Return
		  End If
		  
		  // Check if template exists
		  Dim key As String = Str(templateID)
		  If Not mImportedPages.HasKey(key) Then
		    Call SetError("Template ID " + Str(templateID) + " not found. Call ImportPage() first.")
		    Return
		  End If
		  
		  // Get imported page
		  Dim importedPage As VNSPDFImportedPage = mImportedPages.Value(key)
		  
		  // Use original page dimensions if w or h not specified
		  If w = 0 And h = 0 Then
		    w = importedPage.width / mScaleFactor
		    h = importedPage.height / mScaleFactor
		  ElseIf w = 0 Then
		    w = h * importedPage.width / importedPage.height
		  ElseIf h = 0 Then
		    h = w * importedPage.height / importedPage.width
		  End If
		  
		  // Phase 6.2: Create XObject from imported page and place it
		  Dim xobjName As String = CreateXObjectFromPage(importedPage, templateID)
		  If xobjName = "" Then
		    Return  // Error already set
		  End If
		  
		  // Calculate transformation matrix to place XObject at (x, y) with size (w, h)
		  // PDF coordinates: (0,0) at bottom-left, y increases upward
		  // User coordinates: (0,0) at top-left, y increases downward
		  
		  // Scale factors
		  Dim scaleX As Double = w * mScaleFactor / importedPage.width
		  Dim scaleY As Double = h * mScaleFactor / importedPage.height
		  
		  // Transform to PDF coordinates
		  // Note: mPageHeight is in user units, so multiply by mScaleFactor to get points
		  Dim pdfX As Double = x * mScaleFactor
		  Dim pdfY As Double = (mPageHeight * mScaleFactor) - (y * mScaleFactor) - (h * mScaleFactor)
		  
		  // Build transformation matrix and place XObject
		  // Format: scaleX 0 0 scaleY tx ty cm
		  // Then: /XObjName Do
		  mBuffer = mBuffer + "q" + EndOfLine  // Save graphics state
		  mBuffer = mBuffer + FormatPDF(scaleX) + " 0 0 " + FormatPDF(scaleY) + " "
		  mBuffer = mBuffer + FormatPDF(pdfX) + " " + FormatPDF(pdfY) + " cm" + EndOfLine
		  mBuffer = mBuffer + "/" + xobjName + " Do" + EndOfLine
		  mBuffer = mBuffer + "Q" + EndOfLine  // Restore graphics state
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865207769647468202F2068656967687420286D6D2920666F7220616E20696D706F72746564207061676520746D706C617465
		Function GetImportedPageSize(templateID As Integer, ByRef widthMM As Double, ByRef heightMM As Double) As Boolean
		  // Returns the original page dimensions (in user units) for an imported page template.
		  // templateID: Template ID returned by ImportPage()
		  // widthMM, heightMM: Output parameters (in current user units, typically mm)
		  // Returns True if template found, False otherwise

		  Dim key As String = Str(templateID)
		  If Not mImportedPages.HasKey(key) Then
		    Return False
		  End If

		  Dim importedPage As VNSPDFImportedPage = mImportedPages.Value(key)
		  widthMM = importedPage.width / mScaleFactor
		  heightMM = importedPage.height / mScaleFactor
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4465636F646573205554463820737472696E6720696E746F20556E69636F646520636F646520706F696E74732E0A
		Private Function UTF8ToCodePoints(utf8String As String) As Integer()
		  // Decodes a UTF-8 string into an array of Unicode code points
		  Dim codePoints() As Integer

		  // CRITICAL: Ensure string has UTF-8 encoding before converting to MemoryBlock
		  // When String→MemoryBlock, bytes are written in the string's encoding.
		  // If encoding is Latin-1, characters > U+00FF are lost (replaced with ?).
		  // If encoding is Nil, raw internal bytes are used (usually UTF-8 in modern Xojo).
		  If utf8String.Encoding Is Nil Then
		    utf8String = utf8String.DefineEncoding(Encodings.UTF8)
		  ElseIf Not (utf8String.Encoding Is Encodings.UTF8) Then
		    utf8String = utf8String.ConvertEncoding(Encodings.UTF8)
		  End If

		  // Convert string to MemoryBlock for byte-level access
		  #If TargetiOS Or TargetAndroid Then
		    // iOS: Get UTF-8 bytes directly using Bytes property
		    // iOS strings are already UTF-8 internally
		    Dim byteCount As Integer = utf8String.Bytes
		    If byteCount = 0 Then
		      Return codePoints // Empty string
		    End If

		    Dim mb As New MemoryBlock(byteCount)
		    mb.StringValue(0, byteCount) = utf8String
		  #Else
		    // Desktop/Console/Web: Implicit conversion works
		    Dim mb As MemoryBlock = utf8String
		  #EndIf
		  
		  Dim i As Integer = 0
		  Dim len As Integer = mb.Size
		  
		  While i < len
		    Dim byte1 As Integer = mb.UInt8Value(i)
		    
		    If (byte1 And &hFF80) = 0 Then
		      // 1-byte sequence (ASCII): 0xxxxxxx
		      codePoints.Add(byte1)
		      i = i + 1
		      
		    ElseIf (byte1 And &hFFE0) = &hC0 Then
		      // 2-byte sequence: 110xxxxx 10xxxxxx
		      If i + 1 < len Then
		        Dim byte2 As Integer = mb.UInt8Value(i + 1)
		        Dim codePoint As Integer = ((byte1 And &h1F) * 64) + (byte2 And &h3F)
		        codePoints.Add(codePoint)
		        i = i + 2
		      Else
		        // Invalid sequence, skip
		        i = i + 1
		      End If
		      
		    ElseIf (byte1 And &hFFF0) = &hE0 Then
		      // 3-byte sequence: 1110xxxx 10xxxxxx 10xxxxxx
		      If i + 2 < len Then
		        Dim byte2 As Integer = mb.UInt8Value(i + 1)
		        Dim byte3 As Integer = mb.UInt8Value(i + 2)
		        Dim codePoint As Integer = ((byte1 And &h0F) * 4096) + ((byte2 And &h3F) * 64) + (byte3 And &h3F)
		        codePoints.Add(codePoint)
		        i = i + 3
		      Else
		        // Invalid sequence, skip
		        i = i + 1
		      End If
		      
		    ElseIf (byte1 And &hFFF8) = &hF0 Then
		      // 4-byte sequence: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
		      If i + 3 < len Then
		        Dim byte2 As Integer = mb.UInt8Value(i + 1)
		        Dim byte3 As Integer = mb.UInt8Value(i + 2)
		        Dim byte4 As Integer = mb.UInt8Value(i + 3)
		        Dim codePoint As Integer = ((byte1 And &h07) * 262144) + ((byte2 And &h3F) * 4096) + ((byte3 And &h3F) * 64) + (byte4 And &h3F)
		        codePoints.Add(codePoint)
		        i = i + 4
		      Else
		        // Invalid sequence, skip
		        i = i + 1
		      End If
		      
		    Else
		      // Invalid UTF-8 byte, skip
		      i = i + 1
		    End If
		  Wend
		  
		  Return codePoints
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function UTF8ToUTF16BE(txt As String, includeBOM As Boolean) As String
		  // Convert UTF-8 string to UTF-16BE (Big Endian) byte string
		  // Matching go-pdf/fpdf algorithm from util.go lines 79-115
		  // Returns a BINARY string (raw bytes, no encoding)
		  // NOTE: This function is used for metadata encoding, not for TrueType text rendering
		  
		  // Build result as MemoryBlock to avoid encoding issues
		  Dim resultMB As New MemoryBlock(0)
		  
		  // Add BOM if requested
		  If includeBOM Then
		    resultMB.Size = 2
		    resultMB.Byte(0) = &hFE
		    resultMB.Byte(1) = &hFF
		  End If
		  
		  // Convert text to UTF-8 bytes (Xojo strings are already UTF-8 internally)
		  // Access raw bytes directly from the string (matching go-fpdf: byte(s[i]))
		  Dim nbBytes As Integer = VNSPDFModule.StringLenB(txt)  // Length in BYTES, not characters
		  Dim i As Integer = 0
		  Dim outPos As Integer = resultMB.Size
		  
		  While i < nbBytes
		    Dim c1 As Integer = txt.MiddleBytes(i, 1).AscByte  // Get byte at position i
		    i = i + 1
		    
		    // Resize result buffer for 2 more bytes
		    resultMB.Size = resultMB.Size + 2
		    
		    If c1 >= 224 Then
		      // 3-byte UTF-8 character (0xE0-0xEF)
		      Dim c2 As Integer = txt.MiddleBytes(i, 1).AscByte
		      i = i + 1
		      Dim c3 As Integer = txt.MiddleBytes(i, 1).AscByte
		      i = i + 1
		      
		      // Convert to UTF-16BE (2 bytes)
		      resultMB.Byte(outPos) = ((c1 And &h0F) * 16) + ((c2 And &h3C) / 4)
		      resultMB.Byte(outPos + 1) = ((c2 And &h03) * 64) + (c3 And &h3F)
		      
		    ElseIf c1 >= 192 Then
		      // 2-byte UTF-8 character (0xC0-0xDF)
		      Dim c2 As Integer = txt.MiddleBytes(i, 1).AscByte
		      i = i + 1
		      
		      // Convert to UTF-16BE (2 bytes)
		      resultMB.Byte(outPos) = (c1 And &h1C) / 4
		      resultMB.Byte(outPos + 1) = ((c1 And &h03) * 64) + (c2 And &h3F)
		      
		    Else
		      // Single-byte character (ASCII 0x00-0x7F)
		      resultMB.Byte(outPos) = 0
		      resultMB.Byte(outPos + 1) = c1
		    End If
		    
		    outPos = outPos + 2
		  Wend
		  
		  // Convert MemoryBlock to binary string (no encoding)
		  Return resultMB.StringValue(0, resultMB.Size).DefineEncoding(Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F757470757473206C6C6F77696E6720746578742074686174207772617073206175746F6D61746963616C6C792E
		Sub Write(h As Double, txt As String, link As String = "")
		  #Pragma Unused link

		  // Check if page is active
		  If mPage = 0 Then
		    mError = mError + "Cannot write text: no page added yet." + EndOfLine
		    Return
		  End If

		  // Check if font is set
		  If mCurrentFont = "" Then
		    mError = mError + "Cannot write text: no font selected. Call SetFont first." + EndOfLine
		    Return
		  End If

		  // Ensure UTF-8 encoding for UTF-8 fonts before processing
		  If IsCurrentFontUTF8() Then
		    If txt.Encoding Is Nil Then
		      txt = txt.DefineEncoding(Encodings.UTF8)
		    ElseIf Not (txt.Encoding Is Encodings.UTF8) Then
		      txt = txt.ConvertEncoding(Encodings.UTF8)
		    End If
		  End If

		  // Handle newline characters in Write (GB 12/03/26)
		  txt = txt.ReplaceAll(Chr(13), "")
		  txt = txt.ReplaceAll(Chr(10), " " + Chr(10) + " ")

		  // Split text into words
		  Dim words() As String = txt.Split(" ")

		  For Each word As String In words
		    // Check for newline token (GB 12/03/26)
		    If word.IndexOf(Chr(10)) >= 0 Then
		      // Newline: move to next line
		      mCurrentX = mLeftMargin
		      mCurrentY = mCurrentY + h
		      // Check for automatic page break
		      If mAutoPageBreak And (mCurrentY + h > mPageBreakTrigger) Then
		        AddPage(mCurOrientation)
		      End If
		      Continue For
		    End If

		    Dim wordWidth As Double = GetStringWidth(word + " ")

		    If mCurrentX + wordWidth > mPageWidth - mRightMargin Then
		      // Word doesn't fit, go to next line
		      mCurrentX = mLeftMargin
		      mCurrentY = mCurrentY + h

		      // Check for automatic page break
		      If mAutoPageBreak And (mCurrentY + h > mPageBreakTrigger) Then
		        AddPage(mCurOrientation)
		      End If

		      // Check if word itself is wider than a full line - break it into chunks
		      Dim lineWidth As Double = mPageWidth - mLeftMargin - mRightMargin
		      If GetStringWidth(word) > lineWidth And word.Length > 1 Then
		        // Break the long word into chunks that fit on a line
		        Dim chunk As String = ""
		        For charIdx As Integer = 0 To word.Length - 1
		          Dim nextChar As String = word.Middle(charIdx, 1)
		          Dim testChunk As String = chunk + nextChar
		          If GetStringWidth(testChunk) > lineWidth And chunk <> "" Then
		            // Output current chunk (no trailing space - mid-word)
		            OutputWordInWrite(h, chunk, "")
		            // Move to next line
		            mCurrentX = mLeftMargin
		            mCurrentY = mCurrentY + h
		            If mAutoPageBreak And (mCurrentY + h > mPageBreakTrigger) Then
		              AddPage(mCurOrientation)
		            End If
		            chunk = nextChar
		          Else
		            chunk = testChunk
		          End If
		        Next
		        // Output the remaining chunk with trailing space (end of word)
		        If chunk <> "" Then
		          OutputWordInWrite(h, chunk, " ")
		        End If
		        Continue For
		      End If
		    End If

		    // Output the word with trailing space
		    OutputWordInWrite(h, word, " ")
		  Next

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4f757470757420776f726420696e205772697465
		Private Sub OutputWordInWrite(h As Double, word As String, suffix As String)
		  // Output a single word (plus suffix like trailing space) at current position
		  // This helper is used by Write() to render each word with full PDF commands
		  #Pragma Unused h

		  Dim wordWithSuffix As String = word + suffix
		  Dim wordWidth As Double = GetStringWidth(wordWithSuffix)

		  // Check if current font is UTF8
		  Dim isUTF8 As Boolean = False
		  Dim ttf As VNSPDFTrueTypeFont = Nil
		  Dim encodedText As String = ""
		  Dim glyphMapping As Dictionary = Nil

		  If mFonts.HasKey(mCurrentFont) Then
		    Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		    If fontInfo.HasKey("type") And fontInfo.Value("type") = "UTF8" Then
		      isUTF8 = True
		      If fontInfo.HasKey("ttf") Then
		        ttf = fontInfo.Value("ttf")
		      End If

		      If fontInfo.HasKey("glyphMapping") Then
		        glyphMapping = fontInfo.Value("glyphMapping")
		      End If

		      // Track used Unicode characters AFTER shaping
		      If fontInfo.HasKey("usedRunes") Then
		        Dim usedRunes As Dictionary = fontInfo.Value("usedRunes")
		        Dim shapedWord As String = ShapeArabicText(wordWithSuffix)
		        Dim shapedCodePoints() As Integer = UTF8ToCodePoints(shapedWord)
		        For i As Integer = 0 To shapedCodePoints.LastIndex
		          Dim codePoint As Integer = shapedCodePoints(i)
		          usedRunes.Value(Str(codePoint)) = codePoint
		        Next
		      End If
		    End If
		  End If

		  // Encode text based on font type
		  If isUTF8 And ttf <> Nil Then
		    encodedText = EncodeTextForTrueType(wordWithSuffix, ttf, glyphMapping)
		  Else
		    encodedText = "(" + EscapeText(wordWithSuffix) + ")"
		  End If

		  Dim txtX As Double = mCurrentX * mScaleFactor
		  Dim txtY As Double = (mPageHeight - mCurrentY) * mScaleFactor

		  Dim cmd As String = ""

		  // Output text color before text
		  Dim rPDF As Double = mTextColorR / 255.0
		  Dim gPDF As Double = mTextColorG / 255.0
		  Dim bPDF As Double = mTextColorB / 255.0
		  cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " rg" + EndOfLine.UNIX

		  // Detect if we need simulated bold/italic for UTF-8 fonts without B/I variants
		  Dim simulateBold As Boolean = False
		  Dim simulateItalic As Boolean = False
		  If isUTF8 And mFontStyle <> "" Then
		    Dim styleNoDecor As String = mFontStyle.ReplaceAll("U", "").ReplaceAll("S", "")
		    If styleNoDecor.IndexOf("B") >= 0 Then simulateBold = True
		    If styleNoDecor.IndexOf("I") >= 0 Then simulateItalic = True
		  End If

		  // Simulated bold: set text rendering mode to 2 (fill + stroke) with thin stroke
		  If simulateBold Then
		    Dim boldStrokeWidth As Double = mFontSizePt * 0.05
		    cmd = cmd + FormatPDF(boldStrokeWidth) + " w " + EndOfLine.UNIX
		    cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " RG " + EndOfLine.UNIX
		    cmd = cmd + "2 Tr" + EndOfLine.UNIX
		  End If

		  cmd = cmd + "BT" + EndOfLine.UNIX

		  // Set font inside text object (REQUIRED in PDF)
		  If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		    Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		    Dim fontNum As Integer = fontInfo.Value("number")
		    cmd = cmd + "/F" + Str(fontNum) + " " + FormatPDF(mFontSizePt) + " Tf" + EndOfLine.UNIX
		  End If

		  // Apply text rise for subscript/superscript
		  If mTextRiseDirty Then
		    cmd = cmd + FormatPDF(mTextRise) + " Ts" + EndOfLine.UNIX
		    If mTextRise = 0.0 Then mTextRiseDirty = False
		  End If

		  // Position text: use text matrix for simulated italic (shear), otherwise simple Td
		  If simulateItalic Then
		    Dim shear As Double = 0.21
		    cmd = cmd + "1 0 " + FormatPDF(shear) + " 1 " + FormatPDF(txtX) + " " + FormatPDF(txtY) + " Tm" + EndOfLine.UNIX
		  Else
		    cmd = cmd + FormatPDF(txtX) + " " + FormatPDF(txtY) + " Td" + EndOfLine.UNIX
		  End If
		  cmd = cmd + encodedText + " Tj" + EndOfLine.UNIX
		  cmd = cmd + "ET" + EndOfLine.UNIX

		  // Reset text rendering mode and restore stroke color/width after simulated bold
		  If simulateBold Then
		    cmd = cmd + "0 Tr" + EndOfLine.UNIX
		    // Restore stroke color to current draw color (simulated bold sets RG to text color)
		    Dim rDrawPDF As Double = mDrawColorR / 255.0
		    Dim gDrawPDF As Double = mDrawColorG / 255.0
		    Dim bDrawPDF As Double = mDrawColorB / 255.0
		    cmd = cmd + FormatPDF(rDrawPDF, 3) + " " + FormatPDF(gDrawPDF, 3) + " " + FormatPDF(bDrawPDF, 3) + " RG" + EndOfLine.UNIX
		    // Restore line width (simulated bold sets w to font stroke width)
		    cmd = cmd + FormatPDF(mLineWidth * mScaleFactor) + " w" + EndOfLine.UNIX
		  End If

		  // Draw underline if style contains "U"
		  If mFontStyle.IndexOf("U") >= 0 Then
		    If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		      Dim fontInfo As Dictionary = mFonts.Value(mCurrentFont)
		      Dim up As Double = -100
		      Dim ut As Double = 50
		      If fontInfo.HasKey("up") Then
		        up = fontInfo.Value("up")
		      End If
		      If fontInfo.HasKey("ut") Then
		        ut = fontInfo.Value("ut")
		      End If
		      Dim underlineOffset As Double = up * mFontSizePt / 1000.0
		      Dim underlineThickness As Double = ut * mFontSizePt / 1000.0 * mUnderlineThickness
		      Dim underlineY As Double = txtY + (underlineOffset * mScaleFactor)
		      cmd = cmd + FormatPDF(underlineThickness * mScaleFactor) + " w " + EndOfLine.UNIX
		      cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " RG " + EndOfLine.UNIX
		      cmd = cmd + FormatPDF(txtX) + " " + FormatPDF(underlineY) + " m " + EndOfLine.UNIX
		      cmd = cmd + FormatPDF(txtX + wordWidth * mScaleFactor) + " " + FormatPDF(underlineY) + " l S " + EndOfLine.UNIX
		    End If
		  End If

		  // Draw strikethrough if style contains "S"
		  If mFontStyle.IndexOf("S") >= 0 Then
		    If mCurrentFont <> "" And mFonts.HasKey(mCurrentFont) Then
		      Dim stFontInfo As Dictionary = mFonts.Value(mCurrentFont)
		      Dim stUt As Double = 50
		      If stFontInfo.HasKey("ut") Then
		        stUt = stFontInfo.Value("ut")
		      End If
		      Dim stThickness As Double = stUt * mFontSizePt / 1000.0 * mUnderlineThickness
		      Dim stOffset As Double = 0.15 * mFontSizePt
		      Dim stY As Double = txtY + (stOffset * mScaleFactor)
		      cmd = cmd + FormatPDF(stThickness * mScaleFactor) + " w " + EndOfLine.UNIX
		      cmd = cmd + FormatPDF(rPDF, 3) + " " + FormatPDF(gPDF, 3) + " " + FormatPDF(bPDF, 3) + " RG " + EndOfLine.UNIX
		      cmd = cmd + FormatPDF(txtX) + " " + FormatPDF(stY) + " m " + EndOfLine.UNIX
		      cmd = cmd + FormatPDF(txtX + wordWidth * mScaleFactor) + " " + FormatPDF(stY) + " l S " + EndOfLine.UNIX
		    End If
		  End If

		  mBuffer = mBuffer + cmd

		  // Update position
		  mCurrentX = mCurrentX + wordWidth
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 57726974657320746578742077697468206C65667420636D63656E7465722C206F7220726967687420616C69676E6D656E742E
		Sub WriteAligned(width As Double, lineHeight As Double, textStr As String, alignStr As String = "L")
		  // WriteAligned writes text with alignment support (Left, Center, Right).
		  // width: Width of the bounding box (0 = use page width minus margins)
		  // lineHeight: Line height in user units
		  // textStr: Text to write
		  // alignStr: "L" (left), "C" (center), or "R" (right)
		  
		  // Get page margins
		  Dim lMargin As Double = mLeftMargin
		  Dim rMargin As Double = mRightMargin
		  
		  // Calculate width if not specified
		  If width = 0 Then
		    width = mPageWidth - (lMargin + rMargin)
		  End If
		  
		  // Split text into lines that fit the width
		  Dim lines() As String = SplitTextToLines(textStr, width)
		  
		  // Process each line with alignment
		  For Each lineStr As String In lines
		    Dim lineWidth As Double = GetStringWidth(lineStr)
		    
		    // Apply alignment
		    Select Case alignStr.Uppercase
		    Case "C"  // Center
		      Call SetLeftMargin(lMargin + ((width - lineWidth) / 2))
		      Call Write(lineHeight, lineStr)
		      Call SetLeftMargin(lMargin)
		    Case "R"  // Right
		      Call SetLeftMargin(lMargin + (width - lineWidth))
		      Call Write(lineHeight, lineStr)
		      Call SetLeftMargin(lMargin)
		    Case "J"  // Justify
		      // Don't justify the last line - leave it left-aligned
		      If lineStr = lines(lines.LastIndex) Then
		        Call Write(lineHeight, lineStr)
		      Else
		        // Count spaces to distribute extra width evenly
		        Var spaceCount As Integer = 0
		        For ci As Integer = 0 To lineStr.Length - 1
		          If lineStr.Middle(ci, 1) = " " Then spaceCount = spaceCount + 1
		        Next
		        If spaceCount > 0 And lineWidth < width Then
		          Var extraSpacing As Double = (width - lineWidth) / spaceCount
		          Call SetWordSpacing(extraSpacing)
		          Call Write(lineHeight, lineStr)
		          Call SetWordSpacing(0)
		        Else
		          Call Write(lineHeight, lineStr)
		        End If
		      End If
		    Else  // Left (default)
		      Call Write(lineHeight, lineStr)
		    End Select

		    // Add line break
		    Call Ln(lineHeight)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5772697465732074657874207769746820656E756D2D626173656420616C69676E6D656E742E2044656C65676174657320746F205772697465416C69676E656428292E
		Sub WriteAligned(width As Double, lineHeight As Double, textStr As String, align As VNSPDFModule.eTextAlignment)
		  // Enum overload for WriteAligned() - converts alignment enum to string and delegates
		  Call WriteAligned(width, lineHeight, textStr, AlignmentEnumToString(align))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F75747075747320666C6F77696E67207465787420776974682070726E74662D7374796C6520666F726D617474696E672E
		Sub Writef(h As Double, format As String, ParamArray args() As Variant)
		  // Output flowing text with printf-style formatted text
		  // Convenience wrapper for Write() that formats text using SprintfHelper
		  // Supports: %s (string), %d/%i (integer), %f (float), %.Nf (float with N decimals)
		  //
		  // Parameters:
		  //   h - Line height
		  //   format - printf-style format string
		  //   args - Variable arguments to format
		  //
		  // Example:
		  //   pdf.Writef(5, "Total items: %d, Amount: $%.2f", itemCount, totalAmount)
		  
		  Dim formatted As String = VNSPDFModule.SprintfHelper(format, args)
		  Call Write(h, formatted)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5772697465732074657874207468617420636C69636B732061207765622055524C2E0A
		Sub WriteLinkID(h As Double, displayStr As String, linkID As Integer)
		  // WriteLinkID writes text that when clicked jumps to another location in the PDF.
		  // h: Line height in user units
		  // displayStr: Text to display
		  // linkID: Link identifier returned by AddLink()
		  
		  // Get text width for link area
		  Dim textWidth As Double = GetStringWidth(displayStr)
		  
		  // Store current position
		  Dim x As Double = mCurrentX
		  Dim y As Double = mCurrentY
		  
		  // Write the text
		  Call Write(h, displayStr)
		  
		  // Add link area over the text
		  Call Link(x, y, textWidth, h, linkID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5772697465732074657874207468617420636C69636B732061207765622055524C2E0A
		Sub WriteLinkString(h As Double, displayStr As String, targetStr As String)
		  // WriteLinkString writes text that when clicked opens a web URL.
		  // h: Line height in user units
		  // displayStr: Text to display
		  // targetStr: URL to link to
		  
		  // Get text width for link area
		  Dim textWidth As Double = GetStringWidth(displayStr)
		  
		  // Store current position
		  Dim x As Double = mCurrentX
		  Dim y As Double = mCurrentY
		  
		  // Write the text
		  Call Write(h, displayStr)
		  
		  // Add link area over the text
		  Call LinkString(x, y, textWidth, h, targetStr)
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mError
			End Get
		#tag EndGetter
		Error As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F7220736574732074686520646F63756D656E7420617574686F722E0A
		#tag Getter
			Get
			  Return mAuthor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mAuthor = value
			End Set
		#tag EndSetter
		Author As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F7220736574732074686520646F63756D656E74207469746C652E0A
		#tag Getter
			Get
			  Return mTitle
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTitle = value
			End Set
		#tag EndSetter
		Title As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F7220736574732074686520646F63756D656E74207375626A6563742E0A
		#tag Getter
			Get
			  Return mSubject
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSubject = value
			End Set
		#tag EndSetter
		Subject As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F7220736574732074686520646F63756D656E74206B6579776F7264732E0A
		#tag Getter
			Get
			  Return mKeywords
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mKeywords = value
			End Set
		#tag EndSetter
		Keywords As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F7220736574732074686520646F63756D656E742063726561746F722E0A
		#tag Getter
			Get
			  Return mCreator
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCreator = value
			End Set
		#tag EndSetter
		Creator As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F7220736574732074686520646F63756D656E74206C616E67756167652E0A
		#tag Getter
			Get
			  Return mLang
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mLang = value
			End Set
		#tag EndSetter
		Language As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F722073657473207768657468657220636F6D7072657373696F6E20697320656E61626C65642E0A
		#tag Getter
			Get
			  Return mCompression
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCompression = value
			End Set
		#tag EndSetter
		Compressed As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F7220736574732074686520637572 72656E742070616765206E756D6265722E0A
		#tag Getter
			Get
			  Return mPage
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Set current page (1-based index)
			  If value >= 1 And value <= PageCount() Then
			    SetPage(value)
			  End If
			End Set
		#tag EndSetter
		CurrentPage As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20476574732074686520706167652068656967687420696E20706F696E74732E0A
		#tag Getter
			Get
			  Return mPageHeightPt
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Xojo compatibility: Set page height in points for current page
			  mPageHeightPt = value
			  mPageHeight = value / mScaleFactor

			  // Update current page size
			  mCurPageSize = New Pair(mPageWidthPt, mPageHeightPt)

			  // Update page sizes dictionary if we're on a page
			  If mPage > 0 Then
			    mPageSizes.Value(Str(mPage)) = mCurPageSize
			  End If

			  // Update orientation based on new dimensions
			  If mPageWidthPt > mPageHeightPt Then
			    mCurOrientation = VNSPDFModule.ePageOrientation.Landscape
			  Else
			    mCurOrientation = VNSPDFModule.ePageOrientation.Portrait
			  End If
			End Set
		#tag EndSetter
		PageHeight As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20476574732F7365747320746865207061676520776964746820696E20706F696E74732E0A
		#tag Getter
			Get
			  Return mPageWidthPt
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Xojo compatibility: Set page width in points for current page
			  mPageWidthPt = value
			  mPageWidth = value / mScaleFactor

			  // Update current page size
			  mCurPageSize = New Pair(mPageWidthPt, mPageHeightPt)

			  // Update page sizes dictionary if we're on a page
			  If mPage > 0 Then
			    mPageSizes.Value(Str(mPage)) = mCurPageSize
			  End If

			  // Update orientation based on new dimensions
			  If mPageWidthPt > mPageHeightPt Then
			    mCurOrientation = VNSPDFModule.ePageOrientation.Landscape
			  Else
			    mCurOrientation = VNSPDFModule.ePageOrientation.Portrait
			  End If
			End Set
		#tag EndSetter
		PageWidth As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20476574732F7365747320776865746865722074686520637572726656E74207061676520697320696E206C616E647363617065206F7269656E746174696F6E2E0A
		#tag Getter
			Get
			  Return mPageWidthPt > mPageHeightPt
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Xojo compatibility: Set page orientation by swapping width/height if needed
			  Dim currentLandscape As Boolean = mPageWidthPt > mPageHeightPt

			  // Only swap if changing orientation
			  If value <> currentLandscape Then
			    // Swap width and height
			    Dim tempW As Double = mPageWidthPt
			    mPageWidthPt = mPageHeightPt
			    mPageHeightPt = tempW

			    tempW = mPageWidth
			    mPageWidth = mPageHeight
			    mPageHeight = tempW

			    // Update current page size
			    mCurPageSize = New Pair(mPageWidthPt, mPageHeightPt)

			    // Update page sizes dictionary if we're on a page
			    If mPage > 0 Then
			      mPageSizes.Value(Str(mPage)) = mCurPageSize
			    End If

			    // Update orientation
			    If value Then
			      mCurOrientation = VNSPDFModule.ePageOrientation.Landscape
			    Else
			      mCurOrientation = VNSPDFModule.ePageOrientation.Portrait
			    End If
			  End If
			End Set
		#tag EndSetter
		Landscape As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A2047657473206F72207365747320504446207065726D697373696F6E7320616E6420656E6372797074696F6E2E20416363657074732061205044465065726D697373696F6E73206F626A656374202873616D6520617320586F6A6F20504446446F63756D656E742E5065726D697373696F6E73292E2055736573204145532D3132382077697468207072656D69756D206D6F64756C652C205243342D343020776974686F75742E20466F7220616476616E63656420656E6372797074696F6E206F7074696F6E732C207573652053657450726F74656374696F6E282920696E73746561642E0A
		#tag Getter
			Get
			  Return mPermissionsObj
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Store the PDFPermissions object
			  mPermissionsObj = value

			  // Apply encryption using our SetProtection method
			  // Free version uses RC4-40 encryption (revision 2)
			  // Premium users who need AES-128 (like Xojo's native PDFDocument)
			  // should use SetProtection() directly with gkEncryptionAES128
			  If value <> Nil Then
			    // Determine encryption revision based on premium availability
			    Dim encRevision As Integer
			    #If hasPremiumVNSEncryptionModule Then
			      encRevision = VNSPDFModule.gkEncryptionAES128
			    #Else
			      encRevision = VNSPDFModule.gkEncryptionRC4_40
			    #EndIf

			    SetProtection( _
			      value.UserPassword, _
			      value.OwnerPassword, _
			      value.AllowPrinting, _
			      value.AllowModifyingContents, _
			      value.AllowCopyingContents, _
			      True, _
			      True, _
			      True, _
			      True, _
			      value.AllowPrinting, _
			      encRevision _
			    )
			  End If
			End Set
		#tag EndSetter
		Permissions As PDFPermissions
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 586F6A6F20636F6D7061746962696C6974793A20476574732074686520564E5350444647726170686963732077726170706572206F626A6563742E0A
		#tag Getter
			Get
			  // Lazy initialization of Graphics wrapper
			  If mGraphics = Nil Then
			    mGraphics = New VNSPDFGraphics(Self)
			  End If
			  Return mGraphics
			End Get
		#tag EndGetter
		Graphics As VNSPDFGraphics
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		mAcceptPageBreakFunc As AcceptPageBreakDelegate
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 416C6961732073756273746974757469C3B76E7320666F72207465787420726570C3AC616C6163656D656E7420696E2050444620636F6E74656E742E0A
		Private mAliases As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 416C69617320737472696E6720666F7220746F74616C206E756D626572206F66207061676573202864656661756C743A20227B6E627D22292E0A
		Private mAliasNbPagesStr As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 43757272656E7420616C706861207472616E73706172656E63792076616C75652028302E30202D20312E30292E0A
		Private mAlpha As Double = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAuthor As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAutoPageBreak As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5768656E20547275652C20746865205044462075736573206F6E65206C6F6E67207061676520776974686F757420627265616B7320286C696B6520612077656220706167652073637265656E73686F74292E0A
		Private mSinglePageMode As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4D65646961426F7820626F74746F6D206F666673657420666F722073696E676C652D70616765206D6F646520286372706F7320746F2066697420636F6E74656E74292E
		Private mSinglePageMediaBoxLly As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4172726179206F6620626C656E64206D6F6465206F626A65637473202831206261736564696E646578696E67292E0A
		Private mBlendList() As VNSPDFBlendMode
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4D61707320616C706861206B657920746F20626C656E64206C69737420696E6465782E0A
		Private mBlendMap As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 43757272656E7420626C656E64206D6F64652028652E672E2C20224E6F726D616C222C20224D756C7469706C7922292E0A
		Private mBlendMode As String = "Normal"
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBottomMargin As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBuffer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCatalogObjectNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCellMargin As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mClipNest As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCompression As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCreator As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurOrientation As VNSPDFModule.ePageOrientation
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurPageSize As Pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentFont As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mPage
			End Get
		#tag EndGetter
		Private mCurrentPageNumber As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCurrentX As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentY As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDashArray() As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDashPhase As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDefOrientation As VNSPDFModule.ePageOrientation
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 44656661756C7420706167652062C3B76573E280AC20666F72206E6577207061676573
		Private mDefPageBoxes As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDefPageSize As Pair
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 44726177696E6720636F6C6F7220426C7565206368616E6E656C2028302D323535290A
		Private mDrawColorB As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 44726177696E6720636F6C6F7220477265656E206368616E6E656C2028302D323535290A
		Private mDrawColorG As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 44726177696E6720636F6C6F7220526564206368616E6E656C2028302D323535290A
		Private mDrawColorR As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEnableFontSubsetting As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 456E6372797074696F6E206F626A65637420666F722070617373776F7264207072746563746564205044467320286F7074696F6E616C292E0A
		Private mEncryption As VNSPDFEncryption
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F626A656374206E756D62657220666F7220656E6372797074696F6E2064696374696F6E6172792E0A
		Private mEncryptionObjectNumber As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mError As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 46696C65204944207573656420666F7220656E6372797074696F6E20616E6420747261696C65722E0A
		Private mFileID As String = ""
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 46696C6C20636F6C6F7220426C7565206368616E6E656C2028302D323535290A
		Private mFillColorB As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 46696C6C20636F6C6F7220477265656E206368616E6E656C2028302D323535290A
		Private mFillColorG As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 46696C6C20636F6C6F7220526564206368616E6E656C2028302D323535290A
		Private mFillColorR As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontFamily As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontPath As String = ""
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFonts As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 564E5350444647726170686963732077726170706572206F626A65637420666F7220586F6A6F20636F6D7061746962696C6974792E0A
		Private mGraphics As VNSPDFGraphics
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontSize As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontSizePt As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontStyle As String
	#tag EndProperty

	#tag Property, Flags = &h0
		mFooterFunc As HeaderFooterDelegate
	#tag EndProperty

	#tag Property, Flags = &h0
		mFooterFuncLpi As FooterDelegateLpi
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGradientList() As VNSPDFGradient
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 547261636B73207768657468657220666F6F7465722064656C656761746520697320736574
		Private mHasFooterFunc As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 547261636B7320776865746865722074686520467069206C61737420706167652064656C6567617465206973207365742E0A
		Private mHasFooterFuncLpi As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 547261636B732077686574686572206865616465722064656C656761746520697320736574
		Private mHasHeaderFunc As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		mHeaderFunc As HeaderFooterDelegate
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5768657468657220746F20726573657420582F5920706F736974696F6E20616674657220686561646572
		Private mHeaderHomeMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHTMLTagHandlerNames() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHTMLTagHandlerDelegates() As HTMLTagHandlerDelegate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMarkdownHandlerPrefixes() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMarkdownHandlerDelegates() As MarkdownLineHandlerDelegate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImageIndex As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImages As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImportedObjectMap As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImportedObjects As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImportedPages As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInAcceptPageBreak As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInfoObjectNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInHeaderFooter As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMeasuringFooter As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFooterMeasuredY As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsRTL As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeywords As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLang As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLayoutMode As String = "default"
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLeftMargin As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineCapStyle As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineJoinStyle As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4172726179206F6620696E7465726E616C206C696E6B2064657374696E6174696F6E73202870616765206E756D6265722C207920706F736974696F6E292E0A
		Private mLinks() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNextTemplateID As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mObjectNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOffsets As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F626A656374206E756D62657220666F72206F75746C696E6520726F6F74206F626A6563742E0A
		Private mOutlineRoot As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4172726179206F6620626F6F6B6D61726B2F6F75746C696E6520656E74726965732E0A
		Private mOutlines() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 50656E64696E6720544F4320656E74726965732028646566657272656420756E74696C206F757470757429
		Private mPendingTOCEntries() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F757470757420696E74656E747320617272617920666F7220504446412F582F4520636F6D706C69616E63652E0A
		Private mOutputIntents() As VNSPDFOutputIntent
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 53746172746E6720696F626A656374206E756D626572206F6620666972737420696F757470757420696E74656E74207374726561642E0A
		Private mOutputIntentStartN As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPage As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5061676520626F78657320666F722065616368207061676520285472696D426F782C2043726F70426F782C20426C656564426F782C20417274426F78290A
		Private mPageBoxes As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageBreakTrigger As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageHeightPt As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 44696374696F6E617279206F662070616765206E756D626572202D3E206172726179206F66206C696E6B206172656173206F6E207468617420706167652E0A
		Private mPageLinks As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 44696374696F6E617279206F662070616765206E756D626572202D3E206172726179206F66206174746163686D656E7420616E6E6F746174696F6E732E0A
		Private mPageAttachments As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 44696374696f6e617279206f662070616765206e756d626572202d3e206172726179206f662074657874206e6f746520616e6e6f746174696f6e732e
		Private mPageTextAnnotations As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 446F63756D656E742D6C6576656C206174746163686D656E747320286E6F7420706167652D7370656369666963292E0A
		Private mAttachments() As VNSPDFAttachment
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F6666736574206164646564207768656E2063616C63756C6174696E6720706167652D6F626A656374206E756D6265727320746F206163636F756E7420666F72206174746163686D656E74206F626A656374732E0A
		Private mAttachmentObjectOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41727261792073746F72696E6720666F726D206669656C6420646174612028446963C74696F6E617279206F626A6563747329206578747261637465642066726F6D205044C46436F6E74726F6C20696E7374616E6365732E
		Private mFormFields() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 466C616720696E6469636174696E672069662074686520646F63756D656E7420636F6E7461696E73204163726F466F726D206669656C64732E
		Private mHasAcroForm As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 504446206F626A656374206E756D62657220666F7220746865204163726F466F726D206469637469C6F6E6172792E
		Private mAcroFormObjectNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54656D706F726172792073746F7261676520666F7220666F726D206669656C64207265666572656E63657320647572696E6720436C6F7365446F63756D656E7428292E0A
		Private mFormFieldRefs() As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 44696374696F6E617279206F662070616765206E756D626572202D3E206172726179206F6620666F726D206669656C6420616E6E6F746174696F6E207265666572656E636573202865672022352030205222292E0A
		Private mPageFormAnnotations As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPages As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageSizes As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageWidthPt As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPDFVersion As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPlaceholderToReal As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPermissionsObj As PDFPermissions
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mProducer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRightMargin As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScaleFactor As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSourceReader As VNSPDFReader = Nil
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSourceTempFile As FolderItem = Nil
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mState As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubject As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5465787420636F6C6F7220426C7565206368616E6E656C2028302D323535290A
		Private mTextColorB As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5465787420636F6C6F7220477265656E206368616E6E656C2028302D323535290A
		Private mTextColorG As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5465787420636F6C6F7220526564206368616E6E656C2028302D323535290A
		Private mTextColorR As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTitle As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTopMargin As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 547261636B73206E6573746564207472616E73666F726D6174696F6E20636F6E74657874732E0A
		Private mTransformNest As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUnderlineThickness As Double = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54657874207269736520696E20706F696E747320666F7220737562736372697074202D2F737570657273637269707420282B292072656E646572696E67
		Private mTextRise As Double = 0.0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 547275652069662074657874207269736520776173206576657220736574206E6F6E2D7A65726F2C20736F2077652065616C776179732065697420547320746F20726573657420746F2030
		Private mTextRiseDirty As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUnit As VNSPDFModule.ePageUnit
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWordSpacing As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 584D50206D657461646174612073747265616D2028584D4C292E0A
		Private mXmpMetadata As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4F626A656374206E756D626572206F6620584D50206D657461646174612073747265616D2E0A
		Private mXmpObjectNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mXObjectObjNums As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mXObjects As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mXrefOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mZoomMode As String = "default"
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mPage
			End Get
		#tag EndGetter
		PageCount As Integer
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
			Name="Error"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PageCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
