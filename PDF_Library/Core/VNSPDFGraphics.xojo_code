#tag Class
Protected Class VNSPDFGraphics
	#tag Method, Flags = &h0, Description = 4164647320612074657874206E6F746520616E6E6F746174696F6E2028737469636B79206E6F746529206174207468652073706563696669656420706F736974696F6E2E
		Sub AddAnnotation(message As String, x As Double, y As Double)
		  // Add a text annotation (sticky note/comment) at the specified position
		  // Matches Xojo's PDFDocument.AddAnnotation signature
		  // message: The text to display when the annotation is clicked
		  // x, y: Position in points (top-left origin)
		  
		  // Convert from points to mm (VNSPDFDocument uses mm internally)
		  Dim xMm As Double = x * gkPointsToMM
		  Dim yMm As Double = y * gkPointsToMM
		  
		  // Call VNSPDFDocument.AddAnnotation for Xojo compatibility
		  mPDF.AddAnnotation(message, xMm, yMm)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612066696C65206174746163686D656E7420616E6E6F746174696F6E206174207468652073706563696669656420706F736974696F6E2E0A
		Sub AddAttachmentAnnotation(filename As String, content As String, x As Double, y As Double, w As Double, h As Double, description As String = "")
		  // Add a file attachment annotation at the specified position on the current page
		  // Creates a clickable area that opens the attached file when clicked
		  // filename: The displayed name of the file in PDF readers
		  // content: The file content as a string
		  // x, y: Position in points (top-left origin)
		  // w, h: Width and height of the clickable area
		  // description: Optional description
		  // Note: No drawing is done - use DrawRectangle() to indicate the link area
		  
		  // Convert from points to mm (VNSPDFDocument uses mm internally)
		  Dim xMm As Double = x * gkPointsToMM
		  Dim yMm As Double = y * gkPointsToMM
		  Dim wMm As Double = w * gkPointsToMM
		  Dim hMm As Double = h * gkPointsToMM
		  
		  Dim attachment As New VNSPDFAttachment(filename, content, description)
		  mPDF.AddAttachmentAnnotation(attachment, xMm, yMm, wMm, hMm)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41646473206120646F63756D656E742D6C6576656C20656D6265646465642066696C65206174746163686D656E742E0A
		Sub AddEmbeddedFile(filename As String, content As MemoryBlock, description As String = "")
		  // Add a document-level embedded file attachment
		  // filename: The displayed name of the file in PDF readers
		  // content: The file content as MemoryBlock
		  // description: Optional description
		  
		  Dim attachment As New VNSPDFAttachment(filename, content, description)
		  mPDF.AddAttachment(attachment)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41646473206120646F63756D656E742D6C6576656C20656D6265646465642066696C65206174746163686D656E742E0A
		Sub AddEmbeddedFile(filename As String, content As String, description As String = "")
		  // Add a document-level embedded file attachment
		  // filename: The displayed name of the file in PDF readers
		  // content: The file content as a string
		  // description: Optional description
		  
		  Dim attachment As New VNSPDFAttachment(filename, content, description)
		  mPDF.AddAttachment(attachment)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ApplyBrushToRect(x As Double, y As Double, width As Double, height As Double, inExternalClip As Boolean = False)
		  // Apply brush fill to a rectangular area (coordinates in points)
		  // inExternalClip: if True, uses InClip methods that don't add their own rectangular clip
		  //   (use when an external clip like ellipse or polygon is already established)
		  
		  If mBrush = Nil Then Return
		  
		  // Convert to mm for VNSPDFDocument
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim wMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim hMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  If mBrush IsA LinearGradientBrush Then
		    Dim lgb As LinearGradientBrush = mBrush
		    Dim stops() As Pair = lgb.GradientStops
		    
		    // Normalize gradient vector points
		    // Y is inverted because PDF coordinates have Y increasing upward
		    Dim x1 As Double = If(width > 0, lgb.StartPoint.X / width, 0)
		    Dim y1 As Double = If(height > 0, 1.0 - (lgb.StartPoint.Y / height), 1)
		    Dim x2 As Double = If(width > 0, lgb.EndPoint.X / width, 1)
		    Dim y2 As Double = If(height > 0, 1.0 - (lgb.EndPoint.Y / height), 0)
		    
		    If stops.Count > 2 Then
		      // Multi-stop gradient: use new method
		      If inExternalClip Then
		        mPDF.LinearGradientMultiStopInClip(xMM, yMM, wMM, hMM, stops, x1, y1, x2, y2)
		      Else
		        mPDF.LinearGradientMultiStop(xMM, yMM, wMM, hMM, stops, x1, y1, x2, y2)
		      End If
		    Else
		      // Simple 2-color gradient
		      Dim c1 As Color = Color.Black
		      Dim c2 As Color = Color.White
		      If stops.LastIndex >= 0 Then
		        c1 = stops(0).Right.ColorValue
		      End If
		      If stops.LastIndex >= 1 Then
		        c2 = stops(stops.LastIndex).Right.ColorValue
		      ElseIf stops.LastIndex = 0 Then
		        c2 = c1
		      End If
		      If inExternalClip Then
		        mPDF.LinearGradientInClip(xMM, yMM, wMM, hMM, c1, c2, x1, y1, x2, y2)
		      Else
		        mPDF.LinearGradient(xMM, yMM, wMM, hMM, c1, c2, x1, y1, x2, y2)
		      End If
		    End If
		    
		  ElseIf mBrush IsA RadialGradientBrush Then
		    Dim rgbBrush As RadialGradientBrush = mBrush
		    // Extract first and last colors from GradientStops
		    Dim stops() As Pair = rgbBrush.GradientStops
		    Dim c1 As Color = Color.White
		    Dim c2 As Color = Color.Black
		    If stops.LastIndex >= 0 Then
		      c1 = stops(0).Right.ColorValue
		    End If
		    If stops.LastIndex >= 1 Then
		      c2 = stops(stops.LastIndex).Right.ColorValue
		    ElseIf stops.LastIndex = 0 Then
		      c2 = c1
		    End If
		    // Normalize center point relative to fill area
		    // Y is inverted because PDF coordinates have Y increasing upward
		    Dim cx As Double = If(width > 0, rgbBrush.StartPoint.X / width, 0.5)
		    Dim cy As Double = If(height > 0, 1.0 - (rgbBrush.StartPoint.Y / height), 0.5)
		    // EndRadius in normalized units (relative to smaller dimension)
		    Dim r As Double = rgbBrush.EndRadius
		    If r <= 0 Then r = 0.5
		    Dim minDim As Double = Min(width, height)
		    If minDim > 0 Then r = r / minDim Else r = 0.5
		    If inExternalClip Then
		      mPDF.RadialGradientInClip(xMM, yMM, wMM, hMM, c1, c2, cx, cy, cx, cy, r)
		    Else
		      mPDF.RadialGradient(xMM, yMM, wMM, hMM, c1, c2, cx, cy, cx, cy, r)
		    End If
		    
		  ElseIf mBrush IsA PictureBrush Then
		    Dim pb As PictureBrush = mBrush
		    // PictureBrush tiles a picture to fill the area
		    If pb.Image <> Nil Then
		      ApplyPictureBrushToRect(pb, x, y, width, height)
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ApplyBrushWithClip(clipProc As Ptr, x As Double, y As Double, width As Double, height As Double)
		  // Generic brush application using clip-based approach
		  // clipProc would be a delegate to set up the clip, but Xojo doesn't support this easily
		  // So we use specific methods instead
		  #Pragma Unused clipProc
		  #Pragma Unused x
		  #Pragma Unused y
		  #Pragma Unused width
		  #Pragma Unused height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ApplyFontSettings()
		  // Apply current font settings to PDF
		  Dim style As String = ""
		  If mBold Then style = style + "B"
		  If mItalic Then style = style + "I"
		  If mUnderline Then style = style + "U"
		  
		  mPDF.SetFont(mFontName, style, mFontSize)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ApplyLineDash(values() As Double)
		  // Internal: Set line dash pattern (values in points)
		  // Pass empty array to reset to solid line
		  // Convert points to mm
		  Dim valuesMM() As Double
		  For i As Integer = 0 To values.LastIndex
		    valuesMM.Add(values(i) * VNSPDFModule.gkPointsToMM)
		  Next
		  
		  mPDF.SetDashPattern(valuesMM, mLineDashOffset * VNSPDFModule.gkPointsToMM)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ApplyPictureBrushToRect(pb As PictureBrush, x As Double, y As Double, width As Double, height As Double)
		  // Tile a picture to fill a rectangular area (coordinates in points)
		  Dim pic As Picture = pb.Image
		  If pic = Nil Then Return
		  
		  // Get picture dimensions in points
		  Dim picWidth As Double = pic.Width
		  Dim picHeight As Double = pic.Height
		  If picWidth <= 0 Or picHeight <= 0 Then Return
		  
		  // Calculate how many tiles we need
		  Dim tilesX As Integer = Ceiling(width / picWidth)
		  Dim tilesY As Integer = Ceiling(height / picHeight)
		  
		  // Get mode for tiling behavior
		  Dim brushMode As PictureBrush.Modes = pb.Mode
		  Dim useMirror As Boolean = (brushMode = PictureBrush.Modes.Mirror)
		  
		  // Convert to mm for clipping
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim wMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim hMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  // Clip to the fill area
		  mPDF.TransformBegin()
		  mPDF.ClipRect(xMM, yMM, wMM, hMM, False)
		  
		  // Draw tiles
		  For row As Integer = 0 To tilesY - 1
		    For col As Integer = 0 To tilesX - 1
		      Dim tileX As Double = x + (col * picWidth)
		      Dim tileY As Double = y + (row * picHeight)
		      
		      // Handle Mirror mode: alternate flipping both horizontally and vertically
		      Dim flipH As Boolean = False
		      Dim flipV As Boolean = False
		      
		      If useMirror Then
		        flipH = (col Mod 2 = 1)
		        flipV = (row Mod 2 = 1)
		      End If
		      
		      // Draw the tile (with optional flip via transform)
		      If flipH Or flipV Then
		        mPDF.TransformBegin()
		        Dim scaleX As Double = If(flipH, -1, 1)
		        Dim scaleY As Double = If(flipV, -1, 1)
		        Dim tileCenterX As Double = (tileX + picWidth / 2) * VNSPDFModule.gkPointsToMM
		        Dim tileCenterY As Double = (tileY + picHeight / 2) * VNSPDFModule.gkPointsToMM
		        mPDF.TransformScale(scaleX * 100, scaleY * 100, tileCenterX, tileCenterY)
		        mPDF.ImageFromPicture(pic, tileX * VNSPDFModule.gkPointsToMM, tileY * VNSPDFModule.gkPointsToMM, _
		        picWidth * VNSPDFModule.gkPointsToMM, picHeight * VNSPDFModule.gkPointsToMM)
		        mPDF.TransformEnd()
		      Else
		        mPDF.ImageFromPicture(pic, tileX * VNSPDFModule.gkPointsToMM, tileY * VNSPDFModule.gkPointsToMM, _
		        picWidth * VNSPDFModule.gkPointsToMM, picHeight * VNSPDFModule.gkPointsToMM)
		      End If
		    Next
		  Next
		  
		  mPDF.TransformEnd() // End clip
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearRectangle(x As Double, y As Double, width As Double, height As Double)
		  // Clear rectangle by filling with white (coordinates in points)
		  // Save current color
		  Dim savedR As Integer = mDrawingColorR
		  Dim savedG As Integer = mDrawingColorG
		  Dim savedB As Integer = mDrawingColorB
		  
		  // Set white fill
		  mPDF.SetFillColor(255, 255, 255)
		  
		  // Fill rectangle with white (no page breaks)
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  // Always use Rect with Y-flip (matching go-fpdf)
		  mPDF.Rect(xMM, yMM, widthMM, heightMM, "F")
		  
		  // Restore color
		  mPDF.SetFillColor(savedR, savedG, savedB)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearRectangle(r As Rect)
		  // Clear rectangle using Rect (coordinates in points)
		  ClearRectangle(r.Left, r.Top, r.Width, r.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6970732064726177696E6720746F20746865207370656369666965642072656374616E676C6520616E642072657475726E732074686973204772617068696373206F626A65637420666F7220636861696E696E672E0A
		Function Clip(x As Double, y As Double, width As Double, height As Double) As VNSPDFGraphics
		  // Clips drawing to the specified rectangle and returns this Graphics object.
		  // Unlike Xojo's Clip which returns a new Graphics object, this returns Self
		  // for method chaining. Call ClipEnd() when done to restore the clipping state.
		  //
		  // Example:
		  //   Dim clipped As VNSPDFGraphics = g.Clip(10, 10, 100, 50)
		  //   clipped.DrawText("Clipped text", 0, 20)
		  //   g.ClipEnd()
		  
		  ClipToRectangle(x, y, width, height)
		  Return Self
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 456E6473207468652063757272656E7420636C697070696E6720726567696F6E20616E6420726573746F726573207468652070726576696F75732073746174652E0A
		Sub ClipEnd()
		  // Ends the current clipping region and restores the previous state.
		  // Must be called after ClipToRectangle() to restore unclipped drawing.
		  
		  mPDF.ClipEnd()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6970732064726177696E6720746F207468652073706563696669656420706174682E2043616C6C20436C6970456E64282920746F20726573746F72652E0A
		Sub ClipToPath(path As GraphicsPath)
		  // Clips drawing to the specified GraphicsPath.
		  // Since GraphicsPath doesn't expose its internal points, we use its bounds rectangle.
		  // For more precise path clipping, use VNSPDFGraphicsPath instead.
		  // Call ClipEnd() to restore unclipped drawing.
		  
		  Dim bounds As Rect = path.Bounds
		  ClipToRectangle(bounds.Left, bounds.Top, bounds.Width, bounds.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6970732064726177696E6720746F207468652073706563696669656420706174682E2043616C6C20436C6970456E64282920746F20726573746F72652E0A
		Sub ClipToPath(path As VNSPDFGraphicsPath)
		  // Clips drawing to the specified VNSPDFGraphicsPath.
		  // Supports curves, arcs, rectangles - not just polygons.
		  // Call ClipEnd() to restore unclipped drawing.
		  
		  If path.IsEmpty Then Return
		  
		  Dim cmds As String = path.ToPDFCommands(mPDF)
		  mPDF.ClipPath(cmds, False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6970732064726177696E6720746F20746865207370656369666965642072656374616E676C652E2043616C6C20436C6970456E64282920746F20726573746F72652E0A
		Sub ClipToRectangle(x As Double, y As Double, width As Double, height As Double)
		  // Clips drawing to the specified rectangle. Call ClipEnd() to restore.
		  // Coordinates are in points (Xojo PDFGraphics convention).
		  //
		  // Example:
		  //   g.ClipToRectangle(10, 10, 100, 50)
		  //   g.DrawText("This text is clipped", 0, 20)
		  //   g.ClipEnd()
		  
		  // Convert points to mm for VNSPDFDocument
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim wMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim hMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  mPDF.ClipRect(xMM, yMM, wMM, hMM, False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(pdf As VNSPDFDocument)
		  // Initialize with reference to VNSPDFDocument
		  mPDF = pdf
		  
		  // Initialize default state
		  mFontName = "Helvetica"
		  mFontSize = 12
		  mBold = False
		  mItalic = False
		  mUnderline = False
		  mOutline = False
		  mDrawingColorR = 0
		  mDrawingColorG = 0
		  mDrawingColorB = 0
		  mPenSize = 0.5 // Default line width in points
		  
		  // Initialize state stack
		  ReDim mStateStack(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436865636B73206966207465787420636F6E7461696E7320434A4B20284368696E6573652C204A6170616E6573652C204B6F7265616E2920636861726163746572732E0A
		Private Function ContainsCJKCharacters(txt As String) As Boolean
		  // Checks if text contains CJK (Chinese, Japanese, Korean) characters
		  // that require character-based line breaking.
		  
		  For i As Integer = 0 To txt.Length - 1
		    Dim char As String = txt.Middle(i, 1)
		    Dim charCode As Integer = char.Asc
		    
		    // CJK character ranges:
		    // CJK Unified Ideographs: U+4E00 - U+9FFF
		    // CJK Unified Ideographs Extension A: U+3400 - U+4DBF
		    // Hiragana: U+3040 - U+309F
		    // Katakana: U+30A0 - U+30FF
		    // CJK Symbols and Punctuation: U+3000 - U+303F
		    // Hangul Syllables: U+AC00 - U+D7AF
		    
		    If (charCode >= &h4E00 And charCode <= &h9FFF) Or _
		      (charCode >= &h3400 And charCode <= &h4DBF) Or _
		      (charCode >= &h3040 And charCode <= &h309F) Or _
		      (charCode >= &h30A0 And charCode <= &h30FF) Or _
		      (charCode >= &h3000 And charCode <= &h303F) Or _
		      (charCode >= &hAC00 And charCode <= &hD7AF) Then
		      Return True
		    End If
		  Next
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawArcShapeObject(arc As ArcShape, deltaX As Double, deltaY As Double)
		  // ArcShape: Xojo interprets X,Y as TOP-LEFT corner of bounding box, not center
		  // This applies both standalone and inside Group2D
		  Dim rx As Double = (arc.Width / 2.0) * arc.Scale
		  Dim ry As Double = (arc.Height / 2.0) * arc.Scale
		  
		  // Convert from top-left to center: add rx to X, (ry-1) to Y
		  // The (ry - 1) adjustment matches Xojo's internal Y offset
		  Dim centerX As Double = arc.X + rx + deltaX
		  Dim centerY As Double = arc.Y + (ry - 1) + deltaY
		  
		  // Convert radians to degrees
		  Dim startAngle As Double = arc.StartAngle * 180 / 3.14159265
		  Dim endAngle As Double = (arc.StartAngle + arc.ArcAngle) * 180 / 3.14159265
		  Dim rotationDeg As Double = arc.Rotation * 180 / 3.14159265
		  
		  // Set colors
		  If arc.BorderOpacity > 0 And arc.BorderWidth > 0 Then
		    mPDF.SetDrawColor(arc.BorderColor.Red, arc.BorderColor.Green, arc.BorderColor.Blue)
		    // Scale by 0.5 to match Xojo PDFGraphics behavior
		    mPDF.SetLineWidth(arc.BorderWidth * 0.5 * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  // Draw arc: Arc(x, y, rx, ry, degRotate, degStart, degEnd, style)
		  mPDF.Arc(centerX * VNSPDFModule.gkPointsToMM, centerY * VNSPDFModule.gkPointsToMM, _
		  rx * VNSPDFModule.gkPointsToMM, ry * VNSPDFModule.gkPointsToMM, _
		  rotationDeg, startAngle, endAngle, "D")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawCurveShapeObject(curve As CurveShape, deltaX As Double, deltaY As Double)
		  // CurveShape: X,Y is start point, X2,Y2 is end point
		  // Order 1 = quadratic (1 control point), Order 2 = cubic (2 control points)
		  
		  Dim x1 As Double = (curve.X + deltaX) * VNSPDFModule.gkPointsToMM
		  Dim y1 As Double = (curve.Y + deltaY) * VNSPDFModule.gkPointsToMM
		  Dim x2 As Double = (curve.X2 + deltaX) * VNSPDFModule.gkPointsToMM
		  Dim y2 As Double = (curve.Y2 + deltaY) * VNSPDFModule.gkPointsToMM
		  
		  // Set line color and width
		  If curve.BorderOpacity > 0 And curve.BorderWidth > 0 Then
		    mPDF.SetDrawColor(curve.BorderColor.Red, curve.BorderColor.Green, curve.BorderColor.Blue)
		    // Scale by 0.5 to match Xojo PDFGraphics behavior
		    mPDF.SetLineWidth(curve.BorderWidth * 0.5 * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  If curve.Order = 1 Then
		    // Quadratic bezier - 1 control point
		    Dim cx As Double = (curve.ControlX(0) + deltaX) * VNSPDFModule.gkPointsToMM
		    Dim cy As Double = (curve.ControlY(0) + deltaY) * VNSPDFModule.gkPointsToMM
		    // Convert quadratic to cubic: CP1 = P0 + 2/3*(CP-P0), CP2 = P1 + 2/3*(CP-P1)
		    Dim cp1x As Double = x1 + 2.0/3.0 * (cx - x1)
		    Dim cp1y As Double = y1 + 2.0/3.0 * (cy - y1)
		    Dim cp2x As Double = x2 + 2.0/3.0 * (cx - x2)
		    Dim cp2y As Double = y2 + 2.0/3.0 * (cy - y2)
		    mPDF.CurveBezierCubic(x1, y1, cp1x, cp1y, cp2x, cp2y, x2, y2, "D")
		    
		  ElseIf curve.Order = 2 Then
		    // Cubic bezier - 2 control points
		    Dim cp1x As Double = (curve.ControlX(0) + deltaX) * VNSPDFModule.gkPointsToMM
		    Dim cp1y As Double = (curve.ControlY(0) + deltaY) * VNSPDFModule.gkPointsToMM
		    Dim cp2x As Double = (curve.ControlX(1) + deltaX) * VNSPDFModule.gkPointsToMM
		    Dim cp2y As Double = (curve.ControlY(1) + deltaY) * VNSPDFModule.gkPointsToMM
		    mPDF.CurveBezierCubic(x1, y1, cp1x, cp1y, cp2x, cp2y, x2, y2, "D")
		    
		  Else
		    // Order 0 = straight line
		    mPDF.Line(x1, y1, x2, y2)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawFigureShapeObject(fig As FigureShape, deltaX As Double, deltaY As Double)
		  // FigureShape is a collection of CurveShapes forming a closed polygon
		  If fig.Count = 0 Then Return
		  
		  // Handle rotation - each shape handles its own rotation
		  Dim applyRotation As Boolean = (fig.Rotation <> 0)
		  If applyRotation Then
		    mPDF.TransformBegin()
		    mPDF.TransformRotate(-fig.Rotation * 180 / 3.14159265, _
		    (fig.X + deltaX) * VNSPDFModule.gkPointsToMM, _
		    (fig.Y + deltaY) * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  // Set colors
		  Dim hasFill As Boolean = fig.FillOpacity > 0
		  Dim hasBorder As Boolean = fig.BorderWidth > 0
		  
		  If hasFill Then
		    mPDF.SetFillColor(fig.FillColor.Red, fig.FillColor.Green, fig.FillColor.Blue)
		  End If
		  If hasBorder Then
		    mPDF.SetDrawColor(fig.BorderColor.Red, fig.BorderColor.Green, fig.BorderColor.Blue)
		    // Scale by 0.5 to match Xojo PDFGraphics behavior
		    mPDF.SetLineWidth(fig.BorderWidth * 0.5 * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  // Build path from curves
		  // Each CurveShape in FigureShape connects to form a path
		  For i As Integer = 0 To fig.Count - 1
		    Dim curve As CurveShape = fig.CurveAt(i)
		    DrawCurveShapeObject(curve, deltaX + fig.X, deltaY + fig.Y)
		  Next
		  
		  If applyRotation Then
		    mPDF.TransformEnd()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawGroup2DObject(group As Group2D, deltaX As Double, deltaY As Double)
		  // Group2D: container for multiple Object2D objects
		  // X,Y is the group's anchor/center point
		  //
		  // IMPORTANT: Xojo handles rotated Group2D differently:
		  // - Xojo's group.Item(i) returns children with coordinates that INCLUDE the group transform
		  // - For rotated groups, children's X/Y properties are already the ROTATED positions
		  // - RectShape children have their Rotation property set to match group rotation
		  // - OvalShape children have pre-calculated rotated positions (no rotation needed)
		  //
		  // So we should NOT apply a group-wide rotation transform - it would double-transform!
		  // Instead, let each child handle its own rotation (RectShape) or use its
		  // pre-calculated position (OvalShape).
		  
		  // Store group info for child drawing
		  mInsideGroupTransform = (group.Rotation <> 0 Or group.Scale <> 1.0)
		  mInsideGroup = True
		  mGroupRotation = group.Rotation
		  mGroupX = group.X + deltaX
		  mGroupY = group.Y + deltaY
		  
		  // Only apply scale if present (rotation handled per-child)
		  Dim applyGroupScale As Boolean = (group.Scale <> 1.0)
		  If applyGroupScale Then
		    mPDF.TransformBegin()
		    Dim anchorX As Double = mGroupX * VNSPDFModule.gkPointsToMM
		    Dim anchorY As Double = mGroupY * VNSPDFModule.gkPointsToMM
		    mPDF.TransformScale(group.Scale, group.Scale, anchorX, anchorY)
		  End If
		  
		  // Draw all objects in the group
		  // Children's coordinates from group.Item(i) already include group transform
		  For i As Integer = 0 To group.Count - 1
		    Dim obj As Object2D = group.Item(i)
		    DrawObject(obj, deltaX, deltaY)
		  Next
		  
		  mInsideGroup = False
		  mInsideGroupTransform = False
		  mGroupRotation = 0
		  
		  If applyGroupScale Then
		    mPDF.TransformEnd()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawLine(x1 As Double, y1 As Double, x2 As Double, y2 As Double)
		  // Draw line (coordinates in points)
		  // Convert points to mm
		  Dim x1MM As Double = x1 * VNSPDFModule.gkPointsToMM
		  Dim y1MM As Double = y1 * VNSPDFModule.gkPointsToMM
		  Dim x2MM As Double = x2 * VNSPDFModule.gkPointsToMM
		  Dim y2MM As Double = y2 * VNSPDFModule.gkPointsToMM
		  
		  mPDF.Line(x1MM, y1MM, x2MM, y2MM)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)), Description = 447261777320616E204F626A65637432442073686170652061742074686520737065636966696564206F66667365742E20537570706F727473205265637453686170652C204F76616C53686170652C20526F756E645265637453686170652C2041726353686170652C20437572766553686170652C2046696775726553686170652C205465787453686170652C205069786D617053686170652C20616E642047726F757032442E0A
		Sub DrawObject(obj As Object2D, deltaX As Double = 0, deltaY As Double = 0)
		  // Draws an Object2D shape at the specified offset position.
		  // Coordinates are in points, matching Xojo's Graphics.DrawObject.
		  //
		  // IMPORTANT: Coordinate reference points differ by shape type:
		  // - RectShape, RoundRectShape, PixmapShape: X,Y is top-left corner
		  // - OvalShape, ArcShape: X,Y is CENTER
		  // - CurveShape: X,Y is start point
		  // - TextShape, FigureShape, Group2D: center/anchor point
		  
		  If obj = Nil Then Return
		  
		  // Note: Don't use SaveState/RestoreState here - each shape handler manages its own transforms
		  // Using SaveState/RestoreState causes nested TransformBegin/End which can cascade errors
		  
		  // Handle each Object2D subclass
		  // IMPORTANT: Check subclasses BEFORE parent classes!
		  // Hierarchy: Object2D > RectShape > OvalShape > ArcShape
		  //                     > RectShape > RoundRectShape
		  // Must check from most-derived to least-derived
		  If obj IsA ArcShape Then
		    // ArcShape extends OvalShape extends RectShape
		    DrawArcShapeObject(ArcShape(obj), deltaX, deltaY)
		    
		  ElseIf obj IsA OvalShape Then
		    // OvalShape extends RectShape
		    DrawOvalShapeObject(OvalShape(obj), deltaX, deltaY)
		    
		  ElseIf obj IsA RoundRectShape Then
		    // RoundRectShape extends RectShape
		    DrawRoundRectShapeObject(RoundRectShape(obj), deltaX, deltaY)
		    
		  ElseIf obj IsA RectShape Then
		    // Base rectangle shape
		    DrawRectShapeObject(RectShape(obj), deltaX, deltaY)
		    
		  ElseIf obj IsA CurveShape Then
		    DrawCurveShapeObject(CurveShape(obj), deltaX, deltaY)
		    
		  ElseIf obj IsA FigureShape Then
		    DrawFigureShapeObject(FigureShape(obj), deltaX, deltaY)
		    
		  ElseIf obj IsA TextShape Then
		    DrawTextShapeObject(TextShape(obj), deltaX, deltaY)
		    
		  ElseIf obj IsA PixmapShape Then
		    DrawPixmapShapeObject(PixmapShape(obj), deltaX, deltaY)
		    
		  ElseIf obj IsA Group2D Then
		    DrawGroup2DObject(Group2D(obj), deltaX, deltaY)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawOval(x As Double, y As Double, width As Double, height As Double)
		  // Draw outlined oval (coordinates in points)
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  // Calculate center and radii
		  Dim centerX As Double = xMM + (widthMM / 2.0)
		  Dim centerY As Double = yMM + (heightMM / 2.0)
		  Dim radiusX As Double = widthMM / 2.0
		  Dim radiusY As Double = heightMM / 2.0
		  
		  mPDF.Ellipse(centerX, centerY, radiusX, radiusY, "D")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawOvalShapeObject(oval As OvalShape, deltaX As Double, deltaY As Double)
		  // OvalShape: Xojo interprets X,Y as TOP-LEFT corner of bounding box, not center
		  // This applies both standalone and inside Group2D
		  Dim rx As Double = (oval.Width / 2.0) * oval.Scale
		  Dim ry As Double = (oval.Height / 2.0) * oval.Scale
		  
		  // Convert from top-left to center: add rx to X, (ry-1) to Y
		  // The (ry - 1) adjustment matches Xojo's internal Y offset
		  Dim centerX As Double = oval.X + rx + deltaX
		  Dim centerY As Double = oval.Y + (ry - 1) + deltaY
		  
		  // Handle rotation if needed (skip if inside group transform - group handles rotation)
		  Dim applyRotation As Boolean = (oval.Rotation <> 0) And Not mInsideGroupTransform
		  If applyRotation Then
		    mPDF.TransformBegin()
		    mPDF.TransformRotate(-oval.Rotation * 180 / 3.14159265, _
		    centerX * VNSPDFModule.gkPointsToMM, _
		    centerY * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  // Set colors
		  Dim hasFill As Boolean = oval.FillOpacity > 0
		  Dim hasBorder As Boolean = oval.BorderOpacity > 0 And oval.BorderWidth > 0
		  
		  If hasFill Then
		    mPDF.SetFillColor(oval.FillColor.Red, oval.FillColor.Green, oval.FillColor.Blue)
		  End If
		  If hasBorder Then
		    mPDF.SetDrawColor(oval.BorderColor.Red, oval.BorderColor.Green, oval.BorderColor.Blue)
		    // Scale by 0.5 to match Xojo PDFGraphics behavior
		    mPDF.SetLineWidth(oval.BorderWidth * 0.5 * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  // Draw style
		  Dim style As String = ""
		  If hasFill And hasBorder Then
		    style = "DF"
		  ElseIf hasFill Then
		    style = "F"
		  ElseIf hasBorder Then
		    style = "D"
		  Else
		    style = "D"
		  End If
		  
		  mPDF.Ellipse(centerX * VNSPDFModule.gkPointsToMM, centerY * VNSPDFModule.gkPointsToMM, _
		  rx * VNSPDFModule.gkPointsToMM, ry * VNSPDFModule.gkPointsToMM, style)
		  
		  If applyRotation Then
		    mPDF.TransformEnd()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawPath(path As GraphicsPath, autoClose As Boolean = False)
		  // Modern API2 wrapper: Draw outlined path
		  // autoClose: If True, automatically closes the path by connecting last point to first
		  // Note: GraphicsPath doesn't expose internal points, so we use bounds as fallback
		  // For proper polygon rendering, pair this with DrawPolygon() calls in production code
		  #Pragma Unused autoClose
		  
		  Dim bounds As Rect = path.Bounds
		  DrawRectangle(bounds.Left, bounds.Top, bounds.Width, bounds.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawPath(path As VNSPDFGraphicsPath, autoClose As Boolean = False)
		  // Draw outlined path using PDF path commands
		  // autoClose: If True, appends close-subpath operator before stroking
		  If path.IsEmpty Then Return
		  
		  Dim cmds As String = path.ToPDFCommands(mPDF)
		  If autoClose Then cmds = cmds + "h" + EndOfLine.UNIX
		  mPDF.RenderPath(cmds, "D")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawPicture(pic As Picture, x As Double, y As Double)
		  // Draw picture at position (coordinates in points)
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  
		  // Use picture's natural size
		  Dim widthMM As Double = pic.Width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = pic.Height * VNSPDFModule.gkPointsToMM
		  
		  mPDF.ImageFromPicture(pic, xMM, yMM, widthMM, heightMM)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawPicture(pic As Picture, x As Double, y As Double, destWidth As Double, destHeight As Double, sourceX As Double, sourceY As Double, sourceWidth As Double, sourceHeight As Double)
		  // Draw picture with scaling and cropping (coordinates in points)
		  // Note: VNS PDF doesn't support source cropping directly
		  // We'll ignore sourceX, sourceY, sourceWidth, sourceHeight for now
		  
		  #Pragma Unused sourceX
		  #Pragma Unused sourceY
		  #Pragma Unused sourceWidth
		  #Pragma Unused sourceHeight
		  
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim destWidthMM As Double = destWidth * VNSPDFModule.gkPointsToMM
		  Dim destHeightMM As Double = destHeight * VNSPDFModule.gkPointsToMM
		  
		  mPDF.ImageFromPicture(pic, xMM, yMM, destWidthMM, destHeightMM)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawPixmapShapeObject(pix As PixmapShape, deltaX As Double, deltaY As Double)
		  // PixmapShape: X,Y is top-left corner
		  If pix.Image = Nil Then Return
		  
		  Dim x As Double = pix.X + deltaX
		  Dim y As Double = pix.Y + deltaY
		  Dim w As Double = pix.Width * pix.Scale
		  Dim h As Double = pix.Height * pix.Scale
		  
		  // Handle rotation - each shape handles its own rotation
		  Dim applyRotation As Boolean = (pix.Rotation <> 0)
		  If applyRotation Then
		    mPDF.TransformBegin()
		    Dim centerX As Double = (x + w/2) * VNSPDFModule.gkPointsToMM
		    Dim centerY As Double = (y + h/2) * VNSPDFModule.gkPointsToMM
		    mPDF.TransformRotate(-pix.Rotation * 180 / 3.14159265, centerX, centerY)
		  End If
		  
		  // Draw the image
		  mPDF.ImageFromPicture(pix.Image, x * VNSPDFModule.gkPointsToMM, y * VNSPDFModule.gkPointsToMM, _
		  w * VNSPDFModule.gkPointsToMM, h * VNSPDFModule.gkPointsToMM)
		  
		  If applyRotation Then
		    mPDF.TransformEnd()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawPolygon(points() As Point)
		  // Draw outlined polygon from array of Point objects (coordinates in points)
		  If points.Count < 3 Then Return // Need at least 3 points
		  
		  // Convert points from points to millimeters
		  Dim mmPoints() As Point
		  For i As Integer = 0 To points.LastIndex
		    Dim mmPoint As New Point(points(i).X * VNSPDFModule.gkPointsToMM, points(i).Y * VNSPDFModule.gkPointsToMM)
		    mmPoints.Add(mmPoint)
		  Next
		  
		  mPDF.Polygon(mmPoints, "D")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRectangle(x As Double, y As Double, width As Double, height As Double)
		  // Draw outlined rectangle (coordinates in points)
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  // Always use Rect with Y-flip (matching go-fpdf)
		  mPDF.Rect(xMM, yMM, widthMM, heightMM, "D")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRectangle(r As Rect)
		  // Draw outlined rectangle using Rect (coordinates in points)
		  DrawRectangle(r.Left, r.Top, r.Width, r.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawRectShapeObject(rect As RectShape, deltaX As Double, deltaY As Double)
		  // RectShape: X,Y is top-left corner
		  Dim x As Double = rect.X + deltaX
		  Dim y As Double = rect.Y + deltaY
		  Dim w As Double = rect.Width * rect.Scale
		  Dim h As Double = rect.Height * rect.Scale
		  
		  // Set colors
		  Dim hasFill As Boolean = rect.FillOpacity > 0
		  Dim hasBorder As Boolean = rect.BorderOpacity > 0 And rect.BorderWidth > 0
		  
		  If hasFill Then
		    mPDF.SetFillColor(rect.FillColor.Red, rect.FillColor.Green, rect.FillColor.Blue)
		  End If
		  If hasBorder Then
		    mPDF.SetDrawColor(rect.BorderColor.Red, rect.BorderColor.Green, rect.BorderColor.Blue)
		    // Scale by 0.5 to match Xojo PDFGraphics behavior
		    mPDF.SetLineWidth(rect.BorderWidth * 0.5 * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  // Determine style operator
		  Dim styleOp As String = ""
		  If hasFill And hasBorder Then
		    styleOp = "B"  // Fill and stroke
		  ElseIf hasFill Then
		    styleOp = "f"  // Fill only
		  ElseIf hasBorder Then
		    styleOp = "S"  // Stroke only
		  Else
		    styleOp = "S"  // Default stroke
		  End If
		  
		  // Handle rotation - use Xojo's approach: Transform to position with rotation, draw at origin
		  Dim applyRotation As Boolean = (rect.Rotation <> 0)
		  If applyRotation Then
		    mPDF.TransformBegin()
		    
		    // Get page height for coordinate conversion
		    Dim pageHeight As Double = mPDF.GetPageHeight()  // in mm
		    Dim pageHeightPts As Double = pageHeight / VNSPDFModule.gkPointsToMM
		    
		    // Xojo approach: Transform translates to shape position, rotates, then draws at origin
		    // Translation: (x, pageHeight - y) in points (PDF coordinates)
		    Dim cosA As Double = Cos(rect.Rotation)
		    Dim sinA As Double = Sin(rect.Rotation)
		    
		    // Transform matrix: rotation around origin + translation to position
		    // In PDF, Y increases upward, so we flip Y
		    Dim tx As Double = x  // X position in points
		    Dim ty As Double = pageHeightPts - y  // Y in PDF coords (flipped)
		    
		    mPDF.Transform(cosA, -sinA, sinA, cosA, tx, ty)
		    
		    // Draw rect path at origin using raw PDF commands
		    // Xojo draws: (w, -h) -> (0, -h) -> (0, 0) -> (w, 0) -> close
		    Dim path As String = mPDF.FormatPDF(w) + " " + mPDF.FormatPDF(-h) + " m " + _
		    mPDF.FormatPDF(0) + " " + mPDF.FormatPDF(-h) + " l " + _
		    mPDF.FormatPDF(0) + " " + mPDF.FormatPDF(0) + " l " + _
		    mPDF.FormatPDF(w) + " " + mPDF.FormatPDF(0) + " l " + _
		    mPDF.FormatPDF(w) + " " + mPDF.FormatPDF(-h) + " l " + _
		    styleOp
		    mPDF.RawWriteStr(path)
		    
		    mPDF.TransformEnd()
		  Else
		    // No rotation - use standard Rect method
		    Dim style As String = ""
		    If hasFill And hasBorder Then
		      style = "DF"
		    ElseIf hasFill Then
		      style = "F"
		    ElseIf hasBorder Then
		      style = "D"
		    Else
		      style = "D"
		    End If
		    
		    mPDF.Rect(x * VNSPDFModule.gkPointsToMM, y * VNSPDFModule.gkPointsToMM, _
		    w * VNSPDFModule.gkPointsToMM, h * VNSPDFModule.gkPointsToMM, style)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRoundRectangle(x As Double, y As Double, width As Double, height As Double, cornerWidth As Double, cornerHeight As Double)
		  // Draw outlined rounded rectangle (coordinates in points)
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = height * VNSPDFModule.gkPointsToMM
		  // Use average of cornerWidth and cornerHeight as radius
		  Dim radiusMM As Double = ((cornerWidth + cornerHeight) / 2.0) * VNSPDFModule.gkPointsToMM
		  
		  mPDF.RoundedRect(xMM, yMM, widthMM, heightMM, radiusMM, "1111", "D")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRoundRectangle(r As Rect, cornerWidth As Double, cornerHeight As Double)
		  // Draw outlined rounded rectangle using Rect (coordinates in points)
		  DrawRoundRectangle(r.Left, r.Top, r.Width, r.Height, cornerWidth, cornerHeight)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawRoundRectShapeObject(rr As RoundRectShape, deltaX As Double, deltaY As Double)
		  // RoundRectShape: X,Y is top-left corner
		  Dim x As Double = rr.X + deltaX
		  Dim y As Double = rr.Y + deltaY
		  Dim w As Double = rr.Width * rr.Scale
		  Dim h As Double = rr.Height * rr.Scale
		  // CornerWidth/Height are DIAMETERS of the corner ellipse, so divide by 2 to get radius
		  Dim radius As Double = (rr.CornerWidth + rr.CornerHeight) / 4.0 * rr.Scale
		  
		  // Handle rotation if needed
		  // Since we don't apply group-wide rotation, each shape handles its own rotation
		  Dim applyRotation As Boolean = (rr.Rotation <> 0)
		  If applyRotation Then
		    mPDF.TransformBegin()
		    // Rotate around the shape's center
		    Dim centerX As Double = (x + w/2) * VNSPDFModule.gkPointsToMM
		    Dim centerY As Double = (y + h/2) * VNSPDFModule.gkPointsToMM
		    mPDF.TransformRotate(-rr.Rotation * 180 / 3.14159265, centerX, centerY)
		  End If
		  
		  // Set colors
		  Dim hasFill As Boolean = rr.FillOpacity > 0
		  Dim hasBorder As Boolean = rr.BorderOpacity > 0 And rr.BorderWidth > 0
		  
		  If hasFill Then
		    mPDF.SetFillColor(rr.FillColor.Red, rr.FillColor.Green, rr.FillColor.Blue)
		  End If
		  If hasBorder Then
		    mPDF.SetDrawColor(rr.BorderColor.Red, rr.BorderColor.Green, rr.BorderColor.Blue)
		    // Scale by 0.5 to match Xojo PDFGraphics behavior
		    mPDF.SetLineWidth(rr.BorderWidth * 0.5 * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  // Draw style
		  Dim style As String = ""
		  If hasFill And hasBorder Then
		    style = "DF"
		  ElseIf hasFill Then
		    style = "F"
		  ElseIf hasBorder Then
		    style = "D"
		  Else
		    style = "D"
		  End If
		  
		  mPDF.RoundedRect(x * VNSPDFModule.gkPointsToMM, y * VNSPDFModule.gkPointsToMM, _
		  w * VNSPDFModule.gkPointsToMM, h * VNSPDFModule.gkPointsToMM, _
		  radius * VNSPDFModule.gkPointsToMM, "1234", style)
		  
		  If applyRotation Then
		    mPDF.TransformEnd()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawText(str As String, x As Double, y As Double)
		  // Check if we have a pending rotation - use Tm approach like Xojo
		  If mHasPendingRotation Then
		    DrawTextWithRotation(str, x, y)
		    Return
		  End If
		  
		  // Draw text at position (coordinates in points)
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  
		  // Apply current font settings
		  ApplyFontSettings()
		  
		  // Use Text method for direct positioning
		  
		  // Always use Text with Y-flip (matching go-fpdf)
		  mPDF.Text(xMM, yMM, str)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawText(str As String, x As Double, y As Double, width As Double, condense As Boolean = False)
		  // Draw text with width limit (coordinates in points)
		  
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  
		  // Apply current font settings
		  ApplyFontSettings()
		  
		  If condense Then
		    // Calculate text width and scale factor
		    Dim textWidthMM As Double = mPDF.GetStringWidth(str)
		    
		    If textWidthMM > widthMM Then
		      // Text is wider than limit, apply horizontal scaling
		      Dim scaleFactor As Double = (widthMM / textWidthMM) * 100.0
		      
		      // Apply horizontal scaling using PDF Tz command
		      mPDF.RawWriteStr(Str(scaleFactor) + " Tz" + EndOfLine.UNIX)
		      
		      // Position and draw text
		      mPDF.Text(xMM, yMM, str)
		      
		      // Reset scaling to 100%
		      mPDF.RawWriteStr("100 Tz" + EndOfLine.UNIX)
		    Else
		      // Text fits, no scaling needed
		      mPDF.Text(xMM, yMM, str)
		    End If
		  Else
		    // No condensing, use Cell with width constraint (auto-truncates with ellipsis)
		    mPDF.SetXY(xMM, yMM)
		    mPDF.Cell(widthMM, 0, str, 0, 0)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 447261777320612074657874207370616E207769746820776F72642D7772617070696E6720616E6420616C69676E6D656E742E0A
		Sub DrawTextBlock(value As String, x As Double, y As Double, maxWidth As Double = -1.0, maxHeight As Double = -1.0, alignment As Integer = 0, truncateLastLine As Boolean = False)
		  // Draws a text span with word-wrapping and alignment.
		  // value: The text to draw
		  // x, y: Position in points (top-left corner of text block)
		  // maxWidth: Maximum width in points (-1 = page width)
		  // maxHeight: Maximum height in points (-1 = unlimited)
		  // alignment: 0=Left, 1=Center, 2=Right (matches TextAlignments enum)
		  // truncateLastLine: If True, adds ellipsis when text is truncated
		  
		  If value = "" Then Return
		  
		  // Apply current font settings
		  ApplyFontSettings()
		  
		  // Convert to mm for internal calculations
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  
		  // Calculate effective maxWidth
		  Dim maxWidthMM As Double
		  If maxWidth <= 0 Then
		    maxWidthMM = (mPDF.GetPageWidth - xMM)
		  Else
		    maxWidthMM = maxWidth * VNSPDFModule.gkPointsToMM
		  End If
		  
		  // Calculate line height (font size + 20% spacing)
		  Dim lineHeightPts As Double = mFontSize * 1.2
		  Dim lineHeightMM As Double = lineHeightPts * VNSPDFModule.gkPointsToMM
		  
		  // Convert maxHeight
		  Dim maxHeightMM As Double = -1
		  If maxHeight > 0 Then
		    maxHeightMM = maxHeight * VNSPDFModule.gkPointsToMM
		  End If
		  
		  // Split text into lines that fit within maxWidth
		  Dim lines() As String = SplitTextToLinesInternal(value, maxWidthMM)
		  
		  // Calculate how many lines we can draw
		  Dim maxLines As Integer = -1
		  If maxHeightMM > 0 Then
		    maxLines = Floor(maxHeightMM / lineHeightMM)
		    If maxLines < 1 Then maxLines = 1
		  End If
		  
		  // Draw each line
		  // Start at yMM + lineHeightMM because text is drawn at baseline (not top)
		  Dim currentY As Double = yMM + lineHeightMM
		  Dim lineCount As Integer = 0
		  
		  For i As Integer = 0 To lines.LastIndex
		    lineCount = lineCount + 1
		    
		    // Check if we've exceeded maxLines
		    If maxLines > 0 And lineCount > maxLines Then
		      Exit
		    End If
		    
		    Dim lineText As String = lines(i)
		    
		    // Check if this is the last visible line and we need to truncate
		    If truncateLastLine And maxLines > 0 And lineCount = maxLines And i < lines.LastIndex Then
		      // Truncate with ellipsis
		      lineText = TruncateWithEllipsis(lineText, maxWidthMM)
		    End If
		    
		    // Calculate X position based on alignment
		    Dim lineWidth As Double = mPDF.GetStringWidth(lineText)
		    Dim lineX As Double = xMM
		    
		    Select Case alignment
		    Case 1 // Center
		      lineX = xMM + (maxWidthMM - lineWidth) / 2.0
		    Case 2 // Right
		      lineX = xMM + maxWidthMM - lineWidth
		      // Case 0 // Left - default, no change
		    End Select
		    
		    // Draw the line
		    mPDF.Text(lineX, currentY, lineText)
		    
		    // Move to next line
		    currentY = currentY + lineHeightMM
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub DrawTextShapeObject(txt As TextShape, deltaX As Double, deltaY As Double)
		  // TextShape: text rendering with font settings
		  // TextShape X,Y represents the alignment anchor point, not top-left
		  // HorizontalAlignment: 0=left, 1=center, 2=right
		  
		  // Set font properties first (needed for width calculation)
		  Dim fontStyle As String = ""
		  If txt.Bold Then fontStyle = fontStyle + "B"
		  If txt.Italic Then fontStyle = fontStyle + "I"
		  If txt.Underline Then fontStyle = fontStyle + "U"
		  
		  mPDF.SetFont(txt.FontName, fontStyle, txt.FontSize * txt.Scale)
		  mPDF.SetTextColor(txt.FillColor.Red, txt.FillColor.Green, txt.FillColor.Blue)
		  
		  // Calculate text width for alignment
		  Dim textWidthMM As Double = mPDF.GetStringWidth(txt.Text)
		  Dim textWidthPts As Double = textWidthMM / VNSPDFModule.gkPointsToMM
		  
		  // Adjust X based on horizontal alignment
		  // HorizontalAlignment: 0=left (X is left edge), 1=center (X is center), 2=right (X is right edge)
		  Dim x As Double = txt.X + deltaX
		  Dim y As Double = txt.Y + deltaY
		  
		  Select Case txt.HorizontalAlignment
		  Case TextShape.Alignment.Center
		    x = x - (textWidthPts / 2.0)
		  Case TextShape.Alignment.Right
		    x = x - textWidthPts
		    // Case TextShape.Alignment.Left: No adjustment needed
		  End Select
		  
		  // Handle rotation - each shape handles its own rotation
		  Dim applyRotation As Boolean = (txt.Rotation <> 0)
		  If applyRotation Then
		    mPDF.TransformBegin()
		    // Rotate around the original anchor point (not the adjusted x)
		    mPDF.TransformRotate(-txt.Rotation * 180 / 3.14159265, _
		    (txt.X + deltaX) * VNSPDFModule.gkPointsToMM, _
		    y * VNSPDFModule.gkPointsToMM)
		  End If
		  
		  // Draw the text
		  mPDF.Text(x * VNSPDFModule.gkPointsToMM, y * VNSPDFModule.gkPointsToMM, txt.Text)
		  
		  If applyRotation Then
		    mPDF.TransformEnd()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTextWithRotation(str As String, x As Double, y As Double)
		  // Draw text with rotation using Text Matrix (Tm) approach.
		  // This method is called when mHasPendingRotation is True.
		  //
		  // IMPORTANT: The CTM from Translate uses relative offsets that don't work well
		  // with Tm absolute positioning. So we compute the absolute PDF position here
		  // using the stored translation values, and output Tm with that position.
		  
		  // Get page height for Y-flip
		  Dim pageHeightPts As Double = mPDF.GetPageHeight * mPDF.GetConversionRatio
		  
		  // Convert angle from degrees to radians
		  Const kPi As Double = 3.14159265358979323846
		  Dim radians As Double = mPendingRotationAngle * kPi / 180.0
		  
		  // Calculate rotation matrix components
		  Dim cosA As Double = Cos(radians)
		  Dim sinA As Double = Sin(radians)
		  
		  // Compute absolute user position (translation + local offset)
		  Dim userX As Double = x
		  Dim userY As Double = y
		  If mHasTranslation Then
		    userX = userX + mTranslateX
		    userY = userY + mTranslateY
		  End If
		  
		  // Convert to PDF coordinates (Y-flip)
		  Dim pdfX As Double = userX
		  Dim pdfY As Double = pageHeightPts - userY
		  
		  // Build PDF commands - position directly in Tm
		  // Since we're using absolute positioning in Tm, we need to cancel the CTM
		  // transformation from Translate by outputting an inverse cm first
		  Dim cmd As String = ""
		  
		  // Cancel the CTM translation if there was one
		  // This outputs cm with inverse translation so that our absolute Tm positioning works
		  If mHasTranslation Then
		    // Convert stored translation to PDF units (same as in Translate method)
		    Dim xMM As Double = mTranslateX * VNSPDFModule.gkPointsToMM
		    Dim yMM As Double = mTranslateY * VNSPDFModule.gkPointsToMM
		    Dim invXPDF As Double = -xMM * mPDF.GetConversionRatio  // Inverse X
		    Dim invYPDF As Double = yMM * mPDF.GetConversionRatio   // Inverse Y (was negated in Translate)
		    cmd = cmd + "1 0 0 1 " + mPDF.FormatPDF(invXPDF) + " " + mPDF.FormatPDF(invYPDF) + " cm" + EndOfLine.UNIX
		  End If
		  
		  // Begin text object
		  cmd = cmd + "BT" + EndOfLine.UNIX
		  
		  // Set font
		  ApplyFontSettings()
		  cmd = cmd + "/" + mPDF.GetCurrentFontRef + " " + mPDF.FormatPDF(mFontSize) + " Tf" + EndOfLine.UNIX
		  
		  // Text matrix with rotation AND absolute position: [cos -sin sin cos tx ty]
		  Dim negSinA As Double = -sinA
		  cmd = cmd + mPDF.FormatPDF(cosA, 3) + " " + mPDF.FormatPDF(negSinA, 3) + " " + mPDF.FormatPDF(sinA, 3) + " " + mPDF.FormatPDF(cosA, 3) + " " + mPDF.FormatPDF(pdfX) + " " + mPDF.FormatPDF(pdfY) + " Tm" + EndOfLine.UNIX
		  
		  // Set text color (3 decimal places for colors)
		  Dim r As Double = mDrawingColorR / 255.0
		  Dim g As Double = mDrawingColorG / 255.0
		  Dim b As Double = mDrawingColorB / 255.0
		  cmd = cmd + mPDF.FormatPDF(r, 3) + " " + mPDF.FormatPDF(g, 3) + " " + mPDF.FormatPDF(b, 3) + " rg" + EndOfLine.UNIX
		  
		  // Character spacing
		  cmd = cmd + "0 Tc"
		  
		  // Encode text using current font's encoding (hex for UTF-8, parentheses for core)
		  Dim encodedText As String = mPDF.EncodeTextForCurrentFont(str)
		  cmd = cmd + encodedText + " Tj" + EndOfLine.UNIX
		  
		  // End text object
		  cmd = cmd + "ET" + EndOfLine.UNIX
		  
		  // Output to PDF
		  mPDF.RawWriteStr(cmd)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillOval(x As Double, y As Double, width As Double, height As Double)
		  // Draw filled oval (coordinates in points)
		  // If Brush is set, use clip-based gradient/pattern fill
		  
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  // Calculate center and radii
		  Dim centerX As Double = xMM + (widthMM / 2.0)
		  Dim centerY As Double = yMM + (heightMM / 2.0)
		  Dim radiusX As Double = widthMM / 2.0
		  Dim radiusY As Double = heightMM / 2.0
		  
		  If HasBrush() Then
		    // Clip to ellipse and apply brush (use InClip methods since we have external clip)
		    mPDF.ClipEllipse(centerX, centerY, radiusX, radiusY, False)
		    ApplyBrushToRect(x, y, width, height, True)
		    mPDF.ClipEnd()
		    Return
		  End If
		  
		  // Solid color fill
		  mPDF.Ellipse(centerX, centerY, radiusX, radiusY, "F")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillPath(path As GraphicsPath, autoClose As Boolean = False)
		  // Modern API2 wrapper: Draw filled path
		  // autoClose: If True, automatically closes the path by connecting last point to first
		  // Note: GraphicsPath doesn't expose internal points, so we use bounds as fallback
		  // For proper polygon rendering, pair this with FillPolygon() calls in production code
		  #Pragma Unused autoClose
		  
		  Dim bounds As Rect = path.Bounds
		  FillRectangle(bounds.Left, bounds.Top, bounds.Width, bounds.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillPath(path As VNSPDFGraphicsPath, autoClose As Boolean = False)
		  // Fill path using PDF path commands
		  // autoClose: If True, appends close-subpath operator before filling
		  If path.IsEmpty Then Return
		  
		  Dim cmds As String = path.ToPDFCommands(mPDF)
		  If autoClose Then cmds = cmds + "h" + EndOfLine.UNIX
		  mPDF.RenderPath(cmds, "F")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillPolygon(points() As Point)
		  // Draw filled polygon from array of Point objects (coordinates in points)
		  // If Brush is set, use clip-based gradient/pattern fill
		  If points.Count < 3 Then Return // Need at least 3 points
		  
		  If HasBrush() Then
		    // Calculate bounding box of polygon (in points)
		    Dim minX As Double = points(0).X
		    Dim maxX As Double = points(0).X
		    Dim minY As Double = points(0).Y
		    Dim maxY As Double = points(0).Y
		    For i As Integer = 1 To points.LastIndex
		      If points(i).X < minX Then minX = points(i).X
		      If points(i).X > maxX Then maxX = points(i).X
		      If points(i).Y < minY Then minY = points(i).Y
		      If points(i).Y > maxY Then maxY = points(i).Y
		    Next
		    
		    // Convert to mm Pairs for ClipPolygon (expects Pair array)
		    Dim mmPairs() As Pair
		    For i As Integer = 0 To points.LastIndex
		      mmPairs.Add(points(i).X * VNSPDFModule.gkPointsToMM : points(i).Y * VNSPDFModule.gkPointsToMM)
		    Next
		    
		    // Clip to polygon and apply brush (use InClip methods since we have external clip)
		    mPDF.ClipPolygon(mmPairs, False)
		    ApplyBrushToRect(minX, minY, maxX - minX, maxY - minY, True)
		    mPDF.ClipEnd()
		    Return
		  End If
		  
		  // Solid color fill - convert points to mm Point array
		  Dim mmPoints() As Point
		  For i As Integer = 0 To points.LastIndex
		    Dim mmPoint As New Point(points(i).X * VNSPDFModule.gkPointsToMM, points(i).Y * VNSPDFModule.gkPointsToMM)
		    mmPoints.Add(mmPoint)
		  Next
		  mPDF.Polygon(mmPoints, "F")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillRectangle(x As Double, y As Double, width As Double, height As Double)
		  // Draw filled rectangle (coordinates in points)
		  // If Brush is set, use gradient/pattern fill instead of solid color
		  
		  If HasBrush() Then
		    ApplyBrushToRect(x, y, width, height)
		    Return
		  End If
		  
		  // Solid color fill
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  // Draw filled rectangle (no page breaks)
		  // Always use Rect with Y-flip (matching go-fpdf)
		  mPDF.Rect(xMM, yMM, widthMM, heightMM, "F")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillRectangle(r As Rect)
		  // Draw filled rectangle using Rect (coordinates in points)
		  FillRectangle(r.Left, r.Top, r.Width, r.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillRoundRectangle(x As Double, y As Double, width As Double, height As Double, cornerWidth As Double, cornerHeight As Double)
		  // Draw filled rounded rectangle (coordinates in points)
		  // If Brush is set, use clip-based gradient/pattern fill
		  
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = height * VNSPDFModule.gkPointsToMM
		  // Use average of cornerWidth and cornerHeight as radius
		  Dim radiusMM As Double = ((cornerWidth + cornerHeight) / 2.0) * VNSPDFModule.gkPointsToMM
		  
		  If HasBrush() Then
		    // Clip to rounded rectangle and apply brush (use InClip methods since we have external clip)
		    mPDF.ClipRoundedRect(xMM, yMM, widthMM, heightMM, radiusMM, "1111", False)
		    ApplyBrushToRect(x, y, width, height, True)
		    mPDF.ClipEnd()
		    Return
		  End If
		  
		  // Solid color fill
		  mPDF.RoundedRect(xMM, yMM, widthMM, heightMM, radiusMM, "1111", "F")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillRoundRectangle(r As Rect, cornerWidth As Double, cornerHeight As Double)
		  // Draw filled rounded rectangle using Rect (coordinates in points)
		  FillRoundRectangle(r.Left, r.Top, r.Width, r.Height, cornerWidth, cornerHeight)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HasBrush() As Boolean
		  // Returns True if a brush is set (not Nil)
		  Return mBrush <> Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextPage()
		  // Add new page with same dimensions as current page
		  mPDF.AddPage()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextPage(width As Double, height As Double)
		  // Add new page with custom dimensions (in points)
		  // Converts points to mm and uses AddPageFormat for custom page sizes
		  
		  // Convert points to millimeters
		  Dim widthMM As Double = width * VNSPDFModule.gkPointsToMM
		  Dim heightMM As Double = height * VNSPDFModule.gkPointsToMM
		  
		  // Determine orientation based on dimensions
		  Dim orientation As String
		  If widthMM > heightMM Then
		    orientation = "L"  // Landscape
		  Else
		    orientation = "P"  // Portrait
		  End If
		  
		  // Add page with custom format
		  mPDF.AddPageFormat(orientation, widthMM, heightMM)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetState()
		  // Reset graphics state to defaults
		  mFontName = "Helvetica"
		  mFontSize = 12
		  mBold = False
		  mItalic = False
		  mUnderline = False
		  mOutline = False
		  mDrawingColorR = 0
		  mDrawingColorG = 0
		  mDrawingColorB = 0
		  mPenSize = 0.5
		  mCharacterSpacing = 0
		  mLineCap = Graphics.LineCapTypes.Butt
		  mLineJoin = Graphics.LineJoinTypes.Miter
		  mMiterLimit = 10.0
		  mBrush = Nil
		  
		  // Apply to PDF
		  ApplyFontSettings()
		  mPDF.SetDrawColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
		  mPDF.SetFillColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
		  mPDF.SetTextColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
		  mPDF.SetLineWidth(mPenSize * VNSPDFModule.gkPointsToMM)
		  mPDF.SetLineCapStyle("butt")
		  mPDF.SetLineJoinStyle("miter")
		  mPDF.RawWriteStr("0 Tc" + EndOfLine.UNIX) // Reset character spacing
		  mPDF.RawWriteStr("10 M" + EndOfLine.UNIX) // Reset miter limit
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RestoreState()
		  // Restore graphics state from stack
		  
		  If mStateStack.Count > 0 Then
		    // Restore transformation matrix in PDF first
		    mPDF.TransformEnd()
		    
		    Dim state As Dictionary = mStateStack(mStateStack.Count - 1)
		    mStateStack.RemoveAt(mStateStack.Count - 1)
		    
		    
		    // Check if we've exited all transformations
		    If mStateStack.Count = 0 Then mInTransform = False
		    // Restore state
		    mFontName = state.Value("fontName")
		    mFontSize = state.Value("fontSize")
		    If state.Value("bold") = True Then mBold = True Else mBold = False
		    If state.Value("italic") = True Then mItalic = True Else mItalic = False
		    If state.Value("underline") = True Then mUnderline = True Else mUnderline = False
		    If state.Value("outline") = True Then mOutline = True Else mOutline = False
		    mDrawingColorR = state.Value("colorR")
		    mDrawingColorG = state.Value("colorG")
		    mDrawingColorB = state.Value("colorB")
		    mPenSize = state.Value("penSize")
		    mCharacterSpacing = state.Value("characterSpacing")
		    mLineCap = state.Value("lineCap")
		    mLineJoin = state.Value("lineJoin")
		    mMiterLimit = state.Value("miterLimit")
		    
		    // Apply to PDF
		    ApplyFontSettings()
		    mPDF.SetDrawColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
		    mPDF.SetFillColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
		    mPDF.SetTextColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
		    mPDF.SetLineWidth(mPenSize * VNSPDFModule.gkPointsToMM)
		    
		    // Restore line styling
		    CharacterSpacing = mCharacterSpacing // Use property setter
		    LineCap = mLineCap
		    LineJoin = mLineJoin
		    MiterLimit = mMiterLimit
		    
		    // Clear any pending rotation (Tm approach)
		    mHasPendingRotation = False
		    mPendingRotationAngle = 0
		    
		    // Clear translation tracking
		    mHasTranslation = False
		    mTranslateX = 0
		    mTranslateY = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526F7461746520677261706869637320636F6F7264696E6174652073797374656D2061726F756E642063757272656E7420706F736974696F6E2E20416E676C6520696E20646567726565732E20466F7220586F6A6F20504446477261706869637320636F6D7061746962696C6974792E0A
		Sub Rotate(angle As Double)
		  // Rotate graphics coordinate system around origin of current coordinate system. Angle in degrees. For Xojo PDFGraphics compatibility.
		  // This is the Xojo-compatible single-parameter version that rotates around the origin of the transformed coordinate system.
		  //
		  // NEW APPROACH: Use Text Matrix (Tm) like Xojo does, instead of CTM transformation.
		  // This produces output more similar to Xojo's native PDF generation.
		  // The rotation is stored and applied when drawing text via Tm command.
		  
		  // Store the rotation angle for later use in DrawText
		  mPendingRotationAngle = angle
		  mHasPendingRotation = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526F7461746520677261706869637320636F6F7264696E6174652073797374656D2061726F756E64206120706F696E742E20416E676C6520696E20646567726565732E0A
		Sub Rotate(angle As Double, x As Double, y As Double)
		  // Rotate graphics coordinate system around a point. Angle in degrees.
		  // Wraps TransformRotate with coordinate conversion
		  
		  // Convert points to mm
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  
		  mPDF.TransformRotate(angle, xMM, yMM)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveState()
		  // Save current graphics state to stack
		  
		  mInTransform = True // Now in transformation context
		  Dim state As New Dictionary
		  state.Value("fontName") = mFontName
		  state.Value("fontSize") = mFontSize
		  state.Value("bold") = mBold
		  state.Value("italic") = mItalic
		  state.Value("underline") = mUnderline
		  state.Value("outline") = mOutline
		  state.Value("colorR") = mDrawingColorR
		  state.Value("colorG") = mDrawingColorG
		  state.Value("colorB") = mDrawingColorB
		  state.Value("penSize") = mPenSize
		  state.Value("characterSpacing") = mCharacterSpacing
		  state.Value("lineCap") = mLineCap
		  state.Value("lineJoin") = mLineJoin
		  state.Value("miterLimit") = mMiterLimit
		  
		  mStateStack.Add(state)
		  
		  // Also save transformation matrix in PDF
		  mPDF.TransformBegin()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616C6520677261706869637320636F6F7264696E6174652073797374656D2E205772617073205472616E73666F726D5363616C652E0A
		Sub Scale(scaleX As Double, scaleY As Double)
		  // Scale graphics coordinate system. Wraps TransformScale.
		  // scaleX, scaleY: Scale factors (1.0 = 100%, 2.0 = 200%, 0.5 = 50%)
		  
		  // Use current position for scale origin
		  Dim xMM As Double = mPDF.GetX()
		  Dim yMM As Double = mPDF.GetY()
		  
		  // Convert scale factors to percentages for PDF (100 = 100%)
		  Dim scaleXPercent As Double = scaleX * 100.0
		  Dim scaleYPercent As Double = scaleY * 100.0
		  
		  mPDF.TransformScale(scaleXPercent, scaleYPercent, xMM, yMM)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53706C697473207465787420696E746F206C696E657320746861742066697420776974686968206D617857696474682E0A
		Private Function SplitTextToLinesInternal(txt As String, maxWidthMM As Double) As String()
		  // Splits text into lines that fit within maxWidth (in mm).
		  // Handles word wrapping and explicit line breaks.
		  // For CJK text, uses character-based line breaking.
		  
		  Dim result() As String
		  
		  // First split by explicit line breaks
		  Dim paragraphs() As String = txt.Split(EndOfLine)
		  
		  For Each para As String In paragraphs
		    If para = "" Then
		      result.Add("")
		      Continue
		    End If
		    
		    // Check if paragraph contains CJK characters (needs character-based wrapping)
		    Dim useCJKWrapping As Boolean = ContainsCJKCharacters(para)
		    
		    If Not useCJKWrapping And para.IndexOf(" ") >= 0 Then
		      // Word-based wrapping for languages with spaces (non-CJK)
		      Dim words() As String = para.Split(" ")
		      Dim currentLine As String = ""
		      
		      For Each word As String In words
		        If word = "" Then Continue
		        
		        Dim testLine As String
		        If currentLine = "" Then
		          testLine = word
		        Else
		          testLine = currentLine + " " + word
		        End If
		        
		        Dim lineWidth As Double = mPDF.GetStringWidth(testLine)
		        
		        If lineWidth <= maxWidthMM Or currentLine = "" Then
		          // Word fits or it's the first word (must include even if too long)
		          currentLine = testLine
		        Else
		          // Word doesn't fit, save current line and start new one
		          result.Add(currentLine)
		          currentLine = word
		        End If
		      Next
		      
		      // Add the last line of this paragraph
		      If currentLine <> "" Then
		        result.Add(currentLine)
		      End If
		    Else
		      // Character-based wrapping for CJK and other non-spaced text
		      Dim currentLine As String = ""
		      
		      // Convert to array of characters for proper Unicode handling
		      Dim chars() As String
		      For i As Integer = 0 To para.Length - 1
		        chars.Add(para.Middle(i, 1))
		      Next
		      
		      For Each char As String In chars
		        Dim testLine As String = currentLine + char
		        Dim lineWidth As Double = mPDF.GetStringWidth(testLine)
		        
		        If lineWidth <= maxWidthMM Or currentLine = "" Then
		          // Character fits or it's the first character
		          currentLine = testLine
		        Else
		          // Character doesn't fit, save current line and start new one
		          result.Add(currentLine)
		          currentLine = char
		        End If
		      Next
		      
		      // Add the last line of this paragraph
		      If currentLine <> "" Then
		        result.Add(currentLine)
		      End If
		    End If
		  Next
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652073697A6520612074657874207370616E20776F756C64206F636375707920696620647261776E207769746820447261775465787420546578747464426C6F636B2E0A
		Function TextBlockSize(value As String, maxWidth As Double = -1.0, maxHeight As Double = -1.0, alignment As Integer = 0, truncateLastLine As Boolean = False) As Size
		  // Returns the size a text span would occupy if drawn with DrawTextBlock.
		  // value: The text to measure
		  // maxWidth: Maximum width in points (-1 = page width)
		  // maxHeight: Maximum height in points (-1 = unlimited)
		  // alignment: 0=Left, 1=Center, 2=Right (not used for size calculation)
		  // truncateLastLine: If True, considers ellipsis truncation
		  
		  #Pragma Unused alignment
		  #Pragma Unused truncateLastLine
		  
		  If value = "" Then
		    Return New Size(0, 0)
		  End If
		  
		  // Apply current font settings for accurate measurement
		  ApplyFontSettings()
		  
		  // Calculate effective maxWidth in mm
		  Dim maxWidthMM As Double
		  If maxWidth <= 0 Then
		    // Use a very large width if not specified
		    maxWidthMM = mPDF.GetPageWidth
		  Else
		    maxWidthMM = maxWidth * VNSPDFModule.gkPointsToMM
		  End If
		  
		  // Calculate line height (font size + 20% spacing)
		  Dim lineHeightPts As Double = mFontSize * 1.2
		  
		  // Split text into lines
		  Dim lines() As String = SplitTextToLinesInternal(value, maxWidthMM)
		  
		  // Calculate how many lines fit in maxHeight
		  Dim lineCount As Integer = lines.Count
		  If maxHeight > 0 Then
		    Dim lineHeightMM As Double = lineHeightPts * VNSPDFModule.gkPointsToMM
		    Dim maxHeightMM As Double = maxHeight * VNSPDFModule.gkPointsToMM
		    Dim maxLines As Integer = Floor(maxHeightMM / lineHeightMM)
		    If maxLines < 1 Then maxLines = 1
		    If lineCount > maxLines Then lineCount = maxLines
		  End If
		  
		  // Calculate actual width (widest line)
		  Dim actualWidthMM As Double = 0
		  For i As Integer = 0 To Min(lineCount - 1, lines.LastIndex)
		    Dim lineWidth As Double = mPDF.GetStringWidth(lines(i))
		    If lineWidth > actualWidthMM Then actualWidthMM = lineWidth
		  Next
		  
		  // Convert to points
		  Dim actualWidthPts As Double = actualWidthMM * VNSPDFModule.gkMMToPoints
		  Dim actualHeightPts As Double = lineCount * lineHeightPts
		  
		  Return New Size(actualWidthPts, actualHeightPts)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextHeight() As Double
		  // Return current font height in points
		  // VNS PDF uses font size as height
		  Return mFontSize
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextHeight(text As String, wrapWidth As Double) As Double
		  // Return multi-line text height in points
		  // Calculate number of lines needed for text within wrapWidth
		  
		  If text = "" Or wrapWidth <= 0 Then
		    Return mFontSize
		  End If
		  
		  // Apply current font settings for accurate width measurement
		  ApplyFontSettings()
		  
		  // Convert wrapWidth from points to mm for VNS PDF
		  Dim wrapWidthMM As Double = wrapWidth * VNSPDFModule.gkPointsToMM
		  
		  // Split text into words
		  Dim words() As String = text.Split(" ")
		  Dim lineCount As Integer = 1
		  Dim currentLineWidth As Double = 0
		  Dim spaceWidth As Double = mPDF.GetStringWidth(" ")
		  
		  For i As Integer = 0 To words.LastIndex
		    Dim word As String = words(i)
		    Dim wordWidth As Double = mPDF.GetStringWidth(word)
		    
		    // Check if adding this word would exceed wrap width
		    Dim testWidth As Double
		    If currentLineWidth = 0 Then
		      testWidth = wordWidth
		    Else
		      testWidth = currentLineWidth + spaceWidth + wordWidth
		    End If
		    
		    If testWidth > wrapWidthMM And currentLineWidth > 0 Then
		      // Word doesn't fit, start new line
		      lineCount = lineCount + 1
		      currentLineWidth = wordWidth
		    Else
		      // Word fits, add to current line
		      currentLineWidth = testWidth
		    End If
		  Next
		  
		  // Return total height (lines * font size with 20% line spacing)
		  Return lineCount * mFontSize * 1.2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextWidth(text As String) As Double
		  // Return text width in points
		  // Apply current font settings first
		  ApplyFontSettings()
		  
		  // Get width from PDF (returns in mm)
		  Dim widthMM As Double = mPDF.GetStringWidth(text)
		  
		  // Convert mm to points
		  Return widthMM * VNSPDFModule.gkMMToPoints
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4170706C7920726177203244207472616E73666F726D6174696F6E206D617472697820746F2067726170686963732E0A
		Sub Transform(m11 As Double, m12 As Double, m21 As Double, m22 As Double, dx As Double, dy As Double)
		  // Apply raw 2D transformation matrix to graphics.
		  // m11, m12, m21, m22: Matrix components for scaling/rotation/shearing
		  // dx, dy: Translation offsets (in points, converted to mm)
		  
		  // Convert translation from points to mm
		  Dim dxMM As Double = dx * VNSPDFModule.gkPointsToMM
		  Dim dyMM As Double = dy * VNSPDFModule.gkPointsToMM
		  
		  mPDF.Transform(m11, m12, m21, m22, dxMM, dyMM)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5472616E736C61746520677261706869637320636F6F7264696E6174652073797374656D20627920782C2079206F6666736574732E205772617073205472616E73666F726D5472616E736C6174652E0A
		Sub Translate(x As Double, y As Double)
		  // Translate graphics coordinate system by x, y offsets (in points).
		  // This is a RELATIVE translation - subsequent drawing operations
		  // will be offset by (x, y) in user space coordinates.
		  
		  // Convert points to millimeters for VNSPDFDocument
		  Dim xMM As Double = x * VNSPDFModule.gkPointsToMM
		  Dim yMM As Double = y * VNSPDFModule.gkPointsToMM
		  
		  // Convert to PDF units
		  // X stays the same, Y is negated (user Y-down -> PDF Y-up)
		  Dim xPDF As Double = xMM * mPDF.GetConversionRatio
		  Dim yPDF As Double = -yMM * mPDF.GetConversionRatio
		  
		  // Store translation for use by DrawTextWithRotation
		  mTranslateX = x
		  mTranslateY = y
		  mHasTranslation = True
		  
		  // Apply translation matrix: [1 0 0 1 tx ty]
		  mPDF.Transform(1, 0, 0, 1, xPDF, yPDF)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5472756E636174657320746578742077697468206520656C6C697073697320746F2066697420776974686968206D617857696474682E0A
		Private Function TruncateWithEllipsis(txt As String, maxWidthMM As Double) As String
		  // Truncates text with ellipsis to fit within maxWidth (in mm).
		  
		  Const kEllipsis As String = "..."
		  Dim ellipsisWidth As Double = mPDF.GetStringWidth(kEllipsis)
		  
		  // If text already fits, return as-is
		  If mPDF.GetStringWidth(txt) <= maxWidthMM Then
		    Return txt
		  End If
		  
		  // Binary search for the right truncation point
		  Dim targetWidth As Double = maxWidthMM - ellipsisWidth
		  If targetWidth <= 0 Then Return kEllipsis
		  
		  // Start from the end and work backwards
		  Dim len As Integer = txt.Length
		  For i As Integer = len - 1 DownTo 1
		    Dim truncated As String = txt.Left(i)
		    If mPDF.GetStringWidth(truncated) <= targetWidth Then
		      Return truncated + kEllipsis
		    End If
		  Next
		  
		  Return kEllipsis
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBold
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mBold = value
			  ApplyFontSettings()
			End Set
		#tag EndSetter
		Bold As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBrush
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Accept LinearGradientBrush, RadialGradientBrush, PictureBrush, or Nil
			  mBrush = value
			End Set
		#tag EndSetter
		Brush As Variant
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mCharacterSpacing
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCharacterSpacing = value
			  // Character spacing in PDF uses "Tc" command
			  // Convert from points (Xojo) to mm (VNS PDF coordinates)
			  Dim spacingMM As Double = value * VNSPDFModule.gkPointsToMM
			  mPDF.RawWriteStr(Str(spacingMM, "0.###") + " Tc" + EndOfLine.UNIX)
			End Set
		#tag EndSetter
		CharacterSpacing As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Return current drawing color
			  Return Color.RGB(mDrawingColorR, mDrawingColorG, mDrawingColorB)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Extract RGB components
			  mDrawingColorR = value.Red
			  mDrawingColorG = value.Green
			  mDrawingColorB = value.Blue
			  
			  // Apply to PDF (affects lines, borders, and text)
			  mPDF.SetDrawColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
			  mPDF.SetFillColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
			  mPDF.SetTextColor(mDrawingColorR, mDrawingColorG, mDrawingColorB)
			End Set
		#tag EndSetter
		DrawingColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Try to get actual font ascent from font descriptor
			  Dim fontDesc As Dictionary = mPDF.GetFontDesc(mFontName)
			  If fontDesc <> Nil And fontDesc.HasKey("Ascent") Then
			    // Ascent is in font units (typically 1000 units = 1 em)
			    // Convert to points: ascent * fontSize / 1000
			    Dim ascentUnits As Double = fontDesc.Value("Ascent")
			    Return ascentUnits * mFontSize / 1000.0
			  End If
			  // Fallback: approximate as 80% of font size
			  Return mFontSize * 0.8
			End Get
		#tag EndGetter
		FontAscent As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFontName
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFontName = value
			  ApplyFontSettings()
			End Set
		#tag EndSetter
		FontName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFontSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFontSize = value
			  ApplyFontSettings()
			End Set
		#tag EndSetter
		FontSize As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // VNS PDF always uses points
			  // Return 0 which corresponds to FontUnits.Point
			  Return 0
			End Get
		#tag EndGetter
		FontUnit As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Return page height in points
			  Dim w As Double
			  Dim h As Double
			  mPDF.GetPageSize(w, h)
			  
			  // Convert mm to points
			  Return h * VNSPDFModule.gkMMToPoints
			End Get
		#tag EndGetter
		Height As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mItalic
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mItalic = value
			  ApplyFontSettings()
			End Set
		#tag EndSetter
		Italic As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mLineCap
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mLineCap = value
			  // Map enum to string: Butt, Round, Square
			  Dim styleStr As String
			  Select Case value
			  Case Graphics.LineCapTypes.Round
			    styleStr = "round"
			  Case Graphics.LineCapTypes.Square
			    styleStr = "square"
			  Else
			    styleStr = "butt"
			  End Select
			  mPDF.SetLineCapStyle(styleStr)
			End Set
		#tag EndSetter
		LineCap As Graphics.LineCapTypes
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Return current dash pattern or Nil if solid line
			  If mLineDashPattern.Count = 0 Then
			    Return Nil
			  End If
			  Return mLineDashPattern
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Accept array of Double or Nil to reset to solid line
			  // Usage: g.LineDash = Array(5.0, 5.0) or g.LineDash = Nil
			  If value = Nil Then
			    // Reset to solid line
			    Dim empty() As Double
			    mLineDashPattern = empty
			    ApplyLineDash(empty)
			  Else
			    // Value should be an array of Double
			    Dim arr() As Double = value
			    mLineDashPattern = arr
			    ApplyLineDash(arr)
			  End If
			End Set
		#tag EndSetter
		LineDash As Variant
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mLineDashOffset
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mLineDashOffset = value
			  // Re-apply dash pattern with new offset
			  If mLineDashPattern.Count > 0 Then
			    ApplyLineDash(mLineDashPattern)
			  End If
			End Set
		#tag EndSetter
		LineDashOffset As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mLineJoin
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mLineJoin = value
			  // Map enum to string: Miter, Round, Bevel
			  Dim styleStr As String
			  Select Case value
			  Case Graphics.LineJoinTypes.Round
			    styleStr = "round"
			  Case Graphics.LineJoinTypes.Bevel
			    styleStr = "bevel"
			  Else
			    styleStr = "miter"
			  End Select
			  mPDF.SetLineJoinStyle(styleStr)
			End Set
		#tag EndSetter
		LineJoin As Graphics.LineJoinTypes
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBold As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBrush As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCharacterSpacing As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDrawingColorB As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDrawingColorG As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDrawingColorR As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontSize As Single
	#tag EndProperty

	#tag Property, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private mGroupRotation As Double
	#tag EndProperty

	#tag Property, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private mGroupX As Double
	#tag EndProperty

	#tag Property, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private mGroupY As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5472616306B7320609662077650277265200696E61200726F7460174696F6E020636F60E74657874020666F70220546D2006170707026F61636802E0
		Private mHasPendingRotation As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHasTranslation As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private mInsideGroup As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private mInsideGroupTransform As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInTransform As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mItalic As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mMiterLimit
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMiterLimit = value
			  // Miter limit uses "M" command in PDF
			  mPDF.RawWriteStr(Str(value, "0.###") + " M" + EndOfLine.UNIX)
			End Set
		#tag EndSetter
		MiterLimit As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mLineCap As Graphics.LineCapTypes = Graphics.LineCapTypes.Butt
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineDashOffset As Double = 0.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineDashPattern() As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineJoin As Graphics.LineJoinTypes = Graphics.LineJoinTypes.Miter
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMiterLimit As Double = 10.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOutline As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPDF As VNSPDFDocument
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 53746F720657320704686520700656E646096E67207206F7461704696F6E200616E6760C6520696E02064656077265657302E0
		Private mPendingRotationAngle As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPenSize As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStateStack() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTranslateX As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTranslateY As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUnderline As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mOutline
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Note: Outline rendering not supported in PDF
			  // Property provided for API compatibility only
			  mOutline = value
			End Set
		#tag EndSetter
		Outline As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mPenSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPenSize = value
			  // Convert points to mm for VNS PDF
			  mPDF.SetLineWidth(mPenSize * VNSPDFModule.gkPointsToMM)
			End Set
		#tag EndSetter
		PenSize As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mUnderline
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mUnderline = value
			  ApplyFontSettings()
			End Set
		#tag EndSetter
		Underline As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Return page width in points
			  Dim w As Double
			  Dim h As Double
			  mPDF.GetPageSize(w, h)
			  
			  // Convert mm to points
			  Return w * VNSPDFModule.gkMMToPoints
			End Get
		#tag EndGetter
		Width As Double
	#tag EndComputedProperty


	#tag Enum, Name = LineCapTypes, Type = Integer, Flags = &h0
		Butt = 0
		  Round = 1
		Square = 2
	#tag EndEnum

	#tag Enum, Name = LineJoinTypes, Type = Integer, Flags = &h0
		Miter = 0
		  Round = 1
		Bevel = 2
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
		#tag ViewProperty
			Name="FontName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PenSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontAscent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DrawingColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontUnit"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Outline"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CharacterSpacing"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineCap"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Graphics.LineCapTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Butt"
				"1 - Round"
				"2 - Square"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineJoin"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Graphics.LineJoinTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Miter"
				"1 - Bevel"
				"2 - Round"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="MiterLimit"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineDashOffset"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
