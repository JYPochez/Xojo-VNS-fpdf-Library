#tag Class
Protected Class VNSPDFGraphicsPath
	#tag Method, Flags = &h0, Description = 4164647320616E20617263206F66206120636972636C6520746F2074686520706174682E
		Sub AddArc(x As Double, y As Double, radius As Double, startRadian As Double, endRadian As Double, counterClockwise As Boolean = False)
		  // Add an arc of a circle centered at (x, y) with given radius
		  // startRadian, endRadian: start and end angles in radians (0 = right, Pi/2 = down)
		  // counterClockwise: direction of arc sweep
		  
		  Const kPi As Double = 3.14159265358979
		  Const kTwoPi As Double = 6.28318530717959
		  Const kKappa As Double = 0.5522847498
		  
		  // Normalize angles
		  Dim startAngle As Double = startRadian
		  Dim endAngle As Double = endRadian
		  
		  If counterClockwise Then
		    // Swap direction
		    If endAngle >= startAngle Then
		      endAngle = endAngle - kTwoPi
		    End If
		  Else
		    If endAngle <= startAngle Then
		      endAngle = endAngle + kTwoPi
		    End If
		  End If
		  
		  // Calculate arc start point
		  Dim arcStartX As Double = x + radius * Cos(startAngle)
		  Dim arcStartY As Double = y + radius * Sin(startAngle)
		  
		  // If path is non-empty, add implicit line to arc start
		  If mSegments.Count > 0 Then
		    AddLineToPoint(arcStartX, arcStartY)
		  Else
		    MoveToPoint(arcStartX, arcStartY)
		  End If
		  
		  // Split arc into segments of max 60 degrees (Pi/3 radians)
		  Dim totalAngle As Double = endAngle - startAngle
		  Dim segmentCount As Integer = Ceiling(Abs(totalAngle) / (kPi / 3.0))
		  If segmentCount < 1 Then segmentCount = 1
		  
		  Dim anglePerSegment As Double = totalAngle / segmentCount
		  
		  Dim currentAngle As Double = startAngle
		  
		  For i As Integer = 1 To segmentCount
		    Dim nextAngle As Double = currentAngle + anglePerSegment
		    
		    // Approximate arc segment with cubic Bezier
		    // Using the formula: alpha = 4/3 * tan(angle/4)
		    Dim halfAngle As Double = anglePerSegment / 2.0
		    Dim alpha As Double = 4.0 / 3.0 * Tan(halfAngle / 2.0)
		    
		    Dim cosStart As Double = Cos(currentAngle)
		    Dim sinStart As Double = Sin(currentAngle)
		    Dim cosEnd As Double = Cos(nextAngle)
		    Dim sinEnd As Double = Sin(nextAngle)
		    
		    // Control point 1
		    Dim cp1x As Double = x + radius * (cosStart - alpha * sinStart)
		    Dim cp1y As Double = y + radius * (sinStart + alpha * cosStart)
		    
		    // Control point 2
		    Dim cp2x As Double = x + radius * (cosEnd + alpha * sinEnd)
		    Dim cp2y As Double = y + radius * (sinEnd - alpha * cosEnd)
		    
		    // End point
		    Dim endX As Double = x + radius * cosEnd
		    Dim endY As Double = y + radius * sinEnd
		    
		    AddCurveToPoint(cp1x, cp1y, cp2x, cp2y, endX, endY)
		    
		    currentAngle = nextAngle
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddArcCorner(cx As Double, cy As Double, rx As Double, ry As Double, startAngle As Double, endAngle As Double)
		  // Helper: Add an elliptical arc corner as a single cubic Bezier
		  // Used by AddRoundRectangle for corner arcs
		  
		  Dim halfAngle As Double = (endAngle - startAngle) / 2.0
		  Dim alpha As Double = 4.0 / 3.0 * Tan(halfAngle / 2.0)
		  
		  Dim cosStart As Double = Cos(startAngle)
		  Dim sinStart As Double = Sin(startAngle)
		  Dim cosEnd As Double = Cos(endAngle)
		  Dim sinEnd As Double = Sin(endAngle)
		  
		  // Control point 1
		  Dim cp1x As Double = cx + rx * cosStart - rx * alpha * sinStart
		  Dim cp1y As Double = cy + ry * sinStart + ry * alpha * cosStart
		  
		  // Control point 2
		  Dim cp2x As Double = cx + rx * cosEnd + rx * alpha * sinEnd
		  Dim cp2y As Double = cy + ry * sinEnd - ry * alpha * cosEnd
		  
		  // End point
		  Dim endX As Double = cx + rx * cosEnd
		  Dim endY As Double = cy + ry * sinEnd
		  
		  AddCurveToPoint(cp1x, cp1y, cp2x, cp2y, endX, endY)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612063756269632042657A6965722063757276652066726F6D207468652063757272656E7420706F696E742E
		Sub AddCurveToPoint(cp1x As Double, cp1y As Double, cp2x As Double, cp2y As Double, x As Double, y As Double)
		  // Add a cubic Bezier curve from the current point to (x, y)
		  // cp1x, cp1y: first control point
		  // cp2x, cp2y: second control point
		  Dim seg As New VNSPDFPathSegment(VNSPDFModule.ePathSegmentType.CubicBezierTo, x, y, cp1x, cp1y, cp2x, cp2y)
		  mSegments.Add(seg)
		  
		  // Update bounds with control points and endpoint
		  UpdateBounds(cp1x, cp1y)
		  UpdateBounds(cp2x, cp2y)
		  UpdateBounds(x, y)
		  
		  mCurrentPoint = New Point(x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061206C696E652066726F6D207468652063757272656E7420706F696E7420746F207468652073706563696669656420706F696E742E
		Sub AddLineToPoint(x As Double, y As Double)
		  // Add a line from the current point to the specified point
		  Dim seg As New VNSPDFPathSegment(VNSPDFModule.ePathSegmentType.LineTo, x, y)
		  mSegments.Add(seg)
		  mCurrentPoint = New Point(x, y)
		  UpdateBounds(x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061207175616472617469632042657A6965722063757276652066726F6D207468652063757272656E7420706F696E742E
		Sub AddQuadraticCurveToPoint(cpX As Double, cpY As Double, x As Double, y As Double)
		  // Add a quadratic Bezier curve from the current point to (x, y)
		  // cpX, cpY: control point
		  // Stored as QuadraticBezierTo; converted to cubic in ToPDFCommands
		  Dim seg As New VNSPDFPathSegment(VNSPDFModule.ePathSegmentType.QuadraticBezierTo, x, y, cpX, cpY)
		  mSegments.Add(seg)
		  
		  UpdateBounds(cpX, cpY)
		  UpdateBounds(x, y)
		  
		  mCurrentPoint = New Point(x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612072656374616E676C6520746F2074686520706174682E
		Sub AddRectangle(x As Double, y As Double, w As Double, h As Double)
		  // Add a rectangle to the path
		  // Uses a dedicated Rectangle segment for efficient PDF output (re operator)
		  Dim seg As New VNSPDFPathSegment(VNSPDFModule.ePathSegmentType.Rectangle, x, y, 0, 0, w, h)
		  mSegments.Add(seg)
		  
		  UpdateBounds(x, y)
		  UpdateBounds(x + w, y + h)
		  
		  mCurrentPoint = New Point(x, y)
		  mStartPoint = New Point(x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320612072656374616E676C652066726F6D20612052656374206F626A6563742E
		Sub AddRectangle(r As Rect)
		  // Add a rectangle from a Rect object
		  AddRectangle(r.Left, r.Top, r.Width, r.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41646473206120726F756E6465642072656374616E676C6520746F2074686520706174682E
		Sub AddRoundRectangle(x As Double, y As Double, w As Double, h As Double, cornerW As Double, cornerH As Double)
		  // Add a rounded rectangle to the path
		  // cornerW, cornerH: horizontal and vertical corner radii
		  
		  Const kPi As Double = 3.14159265358979
		  Const kHalfPi As Double = 1.5707963267949
		  
		  // Clamp corner radii to half of dimensions
		  Dim rw As Double = Min(cornerW, w / 2.0)
		  Dim rh As Double = Min(cornerH, h / 2.0)
		  
		  // Start at top-left after corner
		  MoveToPoint(x + rw, y)
		  
		  // Top edge
		  AddLineToPoint(x + w - rw, y)
		  
		  // Top-right corner (arc from 3Pi/2 to 0, i.e. -Pi/2 to 0)
		  If rw > 0 And rh > 0 Then
		    AddArcCorner(x + w - rw, y + rh, rw, rh, -kHalfPi, 0)
		  End If
		  
		  // Right edge
		  AddLineToPoint(x + w, y + h - rh)
		  
		  // Bottom-right corner
		  If rw > 0 And rh > 0 Then
		    AddArcCorner(x + w - rw, y + h - rh, rw, rh, 0, kHalfPi)
		  End If
		  
		  // Bottom edge
		  AddLineToPoint(x + rw, y + h)
		  
		  // Bottom-left corner
		  If rw > 0 And rh > 0 Then
		    AddArcCorner(x + rw, y + h - rh, rw, rh, kHalfPi, kPi)
		  End If
		  
		  // Left edge
		  AddLineToPoint(x, y + rh)
		  
		  // Top-left corner
		  If rw > 0 And rh > 0 Then
		    AddArcCorner(x + rw, y + rh, rw, rh, kPi, kPi + kHalfPi)
		  End If
		  
		  CloseSubpath()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41646473206120726F756E6465642072656374616E676C652066726F6D20612052656374206F626A6563742E
		Sub AddRoundRectangle(r As Rect, cornerW As Double, cornerH As Double)
		  // Add a rounded rectangle from a Rect object
		  AddRoundRectangle(r.Left, r.Top, r.Width, r.Height, cornerW, cornerH)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520626F756E64696E672072656374616E676C65206F662074686520706174682E
		Function Bounds() As Rect
		  // Return the bounding rectangle of the path
		  If Not mHasPoints Then
		    Return New Rect(0, 0, 0, 0)
		  End If
		  Return New Rect(mMinX, mMinY, mMaxX - mMinX, mMaxY - mMinY)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6F736573207468652063757272656E74207375627061746820627920616464696E672061206C696E65206261636B20746F2074686520737461727420706F696E742E
		Sub CloseSubpath()
		  // Close the current subpath by connecting back to its start point
		  Dim seg As New VNSPDFPathSegment(VNSPDFModule.ePathSegmentType.CloseSubpath)
		  mSegments.Add(seg)
		  
		  If mStartPoint <> Nil Then
		    mCurrentPoint = New Point(mStartPoint.X, mStartPoint.Y)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize empty path
		  mCurrentPoint = New Point(0, 0)
		  mStartPoint = New Point(0, 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320547275652069662074686520706F696E7420697320696E7369646520746865207061746820286576656E2D6F64642072756C65292E
		Function Contains(x As Double, y As Double) As Boolean
		  // Point-in-path test using ray casting (even-odd rule)
		  Dim pts() As Point = FlattenToPoints()
		  If pts.Count < 3 Then Return False
		  
		  Dim inside As Boolean = False
		  Dim n As Integer = pts.Count
		  Dim j As Integer = n - 1
		  
		  For i As Integer = 0 To n - 1
		    Dim xi As Double = pts(i).X
		    Dim yi As Double = pts(i).Y
		    Dim xj As Double = pts(j).X
		    Dim yj As Double = pts(j).Y
		    
		    If ((yi > y) <> (yj > y)) And (x < (xj - xi) * (y - yi) / (yj - yi) + xi) Then
		      inside = Not inside
		    End If
		    
		    j = i
		  Next
		  
		  Return inside
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320547275652069662074686520506F696E7420697320696E736964652074686520706174682E
		Function Contains(pt As Point) As Boolean
		  Return Contains(pt.X, pt.Y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53616D706C65732063757276657320696E746F206C696E65207365676D656E747320666F72206869742074657374696E6720616E64206261636B7761726420636F6D7061746962696C6974792E
		Private Function FlattenToPoints() As Point()
		  // Flatten all segments to an array of Point objects
		  // Curves are sampled into approximately 10 points each
		  
		  Dim pts() As Point
		  Dim curX As Double = 0
		  Dim curY As Double = 0
		  
		  Const kSamples As Integer = 10
		  
		  For i As Integer = 0 To mSegments.LastIndex
		    Dim seg As VNSPDFPathSegment = mSegments(i)
		    
		    Select Case seg.mSegmentType
		    Case VNSPDFModule.ePathSegmentType.MoveTo
		      pts.Add(New Point(seg.mX, seg.mY))
		      curX = seg.mX
		      curY = seg.mY
		      
		    Case VNSPDFModule.ePathSegmentType.LineTo
		      pts.Add(New Point(seg.mX, seg.mY))
		      curX = seg.mX
		      curY = seg.mY
		      
		    Case VNSPDFModule.ePathSegmentType.CubicBezierTo
		      SampleCubicBezier(curX, curY, seg.mCp1X, seg.mCp1Y, seg.mCp2X, seg.mCp2Y, seg.mX, seg.mY, kSamples, pts)
		      curX = seg.mX
		      curY = seg.mY
		      
		    Case VNSPDFModule.ePathSegmentType.QuadraticBezierTo
		      SampleQuadraticBezier(curX, curY, seg.mCp1X, seg.mCp1Y, seg.mX, seg.mY, kSamples, pts)
		      curX = seg.mX
		      curY = seg.mY
		      
		    Case VNSPDFModule.ePathSegmentType.CloseSubpath
		      // Add start point to close
		      If pts.Count > 0 Then
		        pts.Add(New Point(pts(0).X, pts(0).Y))
		      End If
		      
		    Case VNSPDFModule.ePathSegmentType.Rectangle
		      // Rectangle: add 4 corners
		      Dim rx As Double = seg.mX
		      Dim ry As Double = seg.mY
		      Dim rw As Double = seg.mCp2X
		      Dim rh As Double = seg.mCp2Y
		      pts.Add(New Point(rx, ry))
		      pts.Add(New Point(rx + rw, ry))
		      pts.Add(New Point(rx + rw, ry + rh))
		      pts.Add(New Point(rx, ry + rh))
		      pts.Add(New Point(rx, ry))
		      curX = rx
		      curY = ry
		      
		    End Select
		  Next
		  
		  Return pts
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320666C617474656E656420706F696E747320666F72206261636B7761726420636F6D7061746962696C6974792E20437572766573206172652073616D706C65642E
		Function GetPoints() As Point()
		  // Return flattened points for backward compatibility
		  // Curves are sampled into ~10 points each
		  Return FlattenToPoints()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206172726179206F662070617468207365676D656E74732E
		Function GetSegments() As VNSPDFPathSegment()
		  // Return the array of path segments
		  Return mSegments
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73204E696C2028636F6D7061746962696C697479207769746820586F6A6F20477261706869637350617468292E
		Function Handle() As Ptr
		  // Compatibility with Xojo GraphicsPath - returns Nil for PDF paths
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73205472756520696620746865207061746820686173206E6F207365676D656E74732E
		Function IsEmpty() As Boolean
		  Return mSegments.Count = 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73205472756520696620746865207061746820697320612073696E676C652072656374616E676C652E
		Function IsRectangle() As Boolean
		  // Check if this path consists of exactly one Rectangle segment
		  If mSegments.Count <> 1 Then Return False
		  Return mSegments(0).mSegmentType = VNSPDFModule.ePathSegmentType.Rectangle
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4D6F76657320746F206120706F696E7420776974686F75742064726177696E672E
		Sub MoveToPoint(x As Double, y As Double)
		  // Move to a point without drawing
		  Dim seg As New VNSPDFPathSegment(VNSPDFModule.ePathSegmentType.MoveTo, x, y)
		  mSegments.Add(seg)
		  mCurrentPoint = New Point(x, y)
		  mStartPoint = New Point(x, y)
		  UpdateBounds(x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53616D706C657320612063756269632042657A69657220637572766520696E746F206C696E65207365676D656E74732E
		Private Sub SampleCubicBezier(x0 As Double, y0 As Double, cp1x As Double, cp1y As Double, cp2x As Double, cp2y As Double, x3 As Double, y3 As Double, numSamples As Integer, pts() As Point)
		  // Sample a cubic Bezier curve into line segments
		  For j As Integer = 1 To numSamples
		    Dim t As Double = j / numSamples
		    Dim u As Double = 1.0 - t
		    
		    Dim px As Double = u * u * u * x0 + 3 * u * u * t * cp1x + 3 * u * t * t * cp2x + t * t * t * x3
		    Dim py As Double = u * u * u * y0 + 3 * u * u * t * cp1y + 3 * u * t * t * cp2y + t * t * t * y3
		    
		    pts.Add(New Point(px, py))
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53616D706C65732061207175616472617469632042657A69657220637572766520696E746F206C696E65207365676D656E74732E
		Private Sub SampleQuadraticBezier(x0 As Double, y0 As Double, cpx As Double, cpy As Double, x2 As Double, y2 As Double, numSamples As Integer, pts() As Point)
		  // Sample a quadratic Bezier curve into line segments
		  For j As Integer = 1 To numSamples
		    Dim t As Double = j / numSamples
		    Dim u As Double = 1.0 - t
		    
		    Dim px As Double = u * u * x0 + 2 * u * t * cpx + t * t * x2
		    Dim py As Double = u * u * y0 + 2 * u * t * cpy + t * t * y2
		    
		    pts.Add(New Point(px, py))
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 47656E657261746573205044462064726177696E6720636F6D6D616E647320666F72207468697320706174682E
		Function ToPDFCommands(doc As VNSPDFDocument) As String
		  // Generate PDF path drawing commands
		  // Converts path coordinates (in points) to PDF coordinates
		  // Points -> mm -> scaled PDF units with Y-flip
		  
		  Dim k As Double = doc.GetConversionRatio()
		  Dim h As Double = doc.GetPageHeight()
		  Dim cmd As String = ""
		  Dim lf As String = EndOfLine.UNIX
		  
		  // Track current point for quadratic-to-cubic conversion
		  Dim curX As Double = 0
		  Dim curY As Double = 0
		  
		  For i As Integer = 0 To mSegments.LastIndex
		    Dim seg As VNSPDFPathSegment = mSegments(i)
		    
		    Select Case seg.mSegmentType
		    Case VNSPDFModule.ePathSegmentType.MoveTo
		      // Convert points to mm, then to PDF coordinates
		      Dim pdfX As Double = seg.mX * VNSPDFModule.gkPointsToMM * k
		      Dim pdfY As Double = (h - seg.mY * VNSPDFModule.gkPointsToMM) * k
		      cmd = cmd + doc.FormatPDF(pdfX) + " " + doc.FormatPDF(pdfY) + " m" + lf
		      curX = seg.mX
		      curY = seg.mY
		      
		    Case VNSPDFModule.ePathSegmentType.LineTo
		      Dim pdfX As Double = seg.mX * VNSPDFModule.gkPointsToMM * k
		      Dim pdfY As Double = (h - seg.mY * VNSPDFModule.gkPointsToMM) * k
		      cmd = cmd + doc.FormatPDF(pdfX) + " " + doc.FormatPDF(pdfY) + " l" + lf
		      curX = seg.mX
		      curY = seg.mY
		      
		    Case VNSPDFModule.ePathSegmentType.CubicBezierTo
		      Dim cp1X As Double = seg.mCp1X * VNSPDFModule.gkPointsToMM * k
		      Dim cp1Y As Double = (h - seg.mCp1Y * VNSPDFModule.gkPointsToMM) * k
		      Dim cp2X As Double = seg.mCp2X * VNSPDFModule.gkPointsToMM * k
		      Dim cp2Y As Double = (h - seg.mCp2Y * VNSPDFModule.gkPointsToMM) * k
		      Dim pdfX As Double = seg.mX * VNSPDFModule.gkPointsToMM * k
		      Dim pdfY As Double = (h - seg.mY * VNSPDFModule.gkPointsToMM) * k
		      cmd = cmd + doc.FormatPDF(cp1X) + " " + doc.FormatPDF(cp1Y) + " "
		      cmd = cmd + doc.FormatPDF(cp2X) + " " + doc.FormatPDF(cp2Y) + " "
		      cmd = cmd + doc.FormatPDF(pdfX) + " " + doc.FormatPDF(pdfY) + " c" + lf
		      curX = seg.mX
		      curY = seg.mY
		      
		    Case VNSPDFModule.ePathSegmentType.QuadraticBezierTo
		      // Convert quadratic to cubic Bezier
		      // cp1 = start + 2/3 * (qcp - start)
		      // cp2 = end + 2/3 * (qcp - end)
		      Dim qcpX As Double = seg.mCp1X
		      Dim qcpY As Double = seg.mCp1Y
		      
		      Dim c1x As Double = curX + 2.0 / 3.0 * (qcpX - curX)
		      Dim c1y As Double = curY + 2.0 / 3.0 * (qcpY - curY)
		      Dim c2x As Double = seg.mX + 2.0 / 3.0 * (qcpX - seg.mX)
		      Dim c2y As Double = seg.mY + 2.0 / 3.0 * (qcpY - seg.mY)
		      
		      Dim cp1X As Double = c1x * VNSPDFModule.gkPointsToMM * k
		      Dim cp1Y As Double = (h - c1y * VNSPDFModule.gkPointsToMM) * k
		      Dim cp2X As Double = c2x * VNSPDFModule.gkPointsToMM * k
		      Dim cp2Y As Double = (h - c2y * VNSPDFModule.gkPointsToMM) * k
		      Dim pdfX As Double = seg.mX * VNSPDFModule.gkPointsToMM * k
		      Dim pdfY As Double = (h - seg.mY * VNSPDFModule.gkPointsToMM) * k
		      cmd = cmd + doc.FormatPDF(cp1X) + " " + doc.FormatPDF(cp1Y) + " "
		      cmd = cmd + doc.FormatPDF(cp2X) + " " + doc.FormatPDF(cp2Y) + " "
		      cmd = cmd + doc.FormatPDF(pdfX) + " " + doc.FormatPDF(pdfY) + " c" + lf
		      curX = seg.mX
		      curY = seg.mY
		      
		    Case VNSPDFModule.ePathSegmentType.CloseSubpath
		      cmd = cmd + "h" + lf
		      
		    Case VNSPDFModule.ePathSegmentType.Rectangle
		      // Rectangle: x, y is top-left; mCp2X = width, mCp2Y = height
		      Dim pdfX As Double = seg.mX * VNSPDFModule.gkPointsToMM * k
		      Dim pdfY As Double = (h - seg.mY * VNSPDFModule.gkPointsToMM) * k
		      Dim pdfW As Double = seg.mCp2X * VNSPDFModule.gkPointsToMM * k
		      Dim pdfH As Double = -seg.mCp2Y * VNSPDFModule.gkPointsToMM * k
		      cmd = cmd + doc.FormatPDF(pdfX) + " " + doc.FormatPDF(pdfY) + " "
		      cmd = cmd + doc.FormatPDF(pdfW) + " " + doc.FormatPDF(pdfH) + " re" + lf
		      curX = seg.mX
		      curY = seg.mY
		      
		    End Select
		  Next
		  
		  Return cmd
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 557064617465732074686520626F756E64696E6720626F7820776974682061206E657720706F696E742E
		Private Sub UpdateBounds(x As Double, y As Double)
		  // Update bounding box with a new point
		  If Not mHasPoints Then
		    mMinX = x
		    mMinY = y
		    mMaxX = x
		    mMaxY = y
		    mHasPoints = True
		  Else
		    If x < mMinX Then mMinX = x
		    If y < mMinY Then mMinY = y
		    If x > mMaxX Then mMaxX = x
		    If y > mMaxY Then mMaxY = y
		  End If
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 5468652063757272656E7420706F696E74206F662074686520706174682E
		#tag Getter
			Get
			  Return mCurrentPoint
			End Get
		#tag EndGetter
		CurrentPoint As Point
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 43757272656E742064726177696E6720706F736974696F6E2E
		Private mCurrentPoint As Point
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5768657468657220616E7920706F696E74732068617665206265656E2061646465642028666F7220626F756E647320696E697469616C697A6174696F6E292E
		Private mHasPoints As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4D6178696D756D205820666F7220626F756E64696E6720626F782E
		Private mMaxX As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4D6178696D756D205920666F7220626F756E64696E6720626F782E
		Private mMaxY As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4D696E696D756D205820666F7220626F756E64696E6720626F782E
		Private mMinX As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4D696E696D756D205920666F7220626F756E64696E6720626F782E
		Private mMinY As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4172726179206F662070617468207365676D656E74732E
		Private mSegments() As VNSPDFPathSegment
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 537461727420706F696E74206F662063757272656E7420737562706174682028666F7220436C6F736553756270617468292E
		Private mStartPoint As Point
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
