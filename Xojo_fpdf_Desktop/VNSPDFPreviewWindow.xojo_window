#tag DesktopWindow
Begin DesktopWindow VNSPDFPreviewWindow
   Backdrop        =   0
   BackgroundColor =   &cE8E8E8
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   True
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   750
   ImplicitInstance=   False
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   0
   MenuBarVisible  =   False
   MinimumHeight   =   450
   MinimumWidth    =   600
   Resizeable      =   True
   Title           =   "#kTitle"
   Type            =   1
   Visible         =   True
   Width           =   900
   Begin DesktopListBox lstThumbnails
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   False
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   1
      ColumnWidths    =   ""
      DefaultRowHeight=   140
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   False
      HasHeader       =   False
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   750
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      RequiresSelection=   True
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipThumbnails"
      Top             =   0
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   180
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin DesktopCanvas canvasPage
      AllowAutoDeactivate=   True
      AllowFocus      =   True
      AllowFocusRing  =   False
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   674
      Index           =   -2147483648
      Left            =   180
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   True
      Visible         =   True
      Width           =   704
   End
   Begin DesktopScrollBar scrVertical
      AllowAutoDeactivate=   True
      AllowFocus      =   True
      AllowLiveScrolling=   True
      Enabled         =   False
      Height          =   674
      Index           =   -2147483648
      Left            =   884
      LineStep        =   1
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MaximumValue    =   0
      MinimumValue    =   0
      PageStep        =   20
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   False
      Value           =   0
      Visible         =   True
      Width           =   16
   End
   Begin DesktopScrollBar scrHorizontal
      AllowAutoDeactivate=   True
      AllowFocus      =   True
      AllowLiveScrolling=   True
      Enabled         =   False
      Height          =   16
      Index           =   -2147483648
      Left            =   180
      LineStep        =   1
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      MaximumValue    =   0
      MinimumValue    =   0
      PageStep        =   20
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   674
      Transparent     =   False
      Value           =   0
      Visible         =   True
      Width           =   704
   End
   Begin DesktopButton btnPrevPage
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "<"
      Default         =   False
      Enabled         =   False
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   200
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipPrevPage"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin DesktopLabel lblPageInfo
      AllowAutoDeactivate=   True
      Bold            =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   245
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   ""
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   110
   End
   Begin DesktopButton btnNextPage
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   ">"
      Default         =   False
      Enabled         =   False
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   360
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipNextPage"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin DesktopButton btnZoomOut
      AllowAutoDeactivate=   True
      Bold            =   True
      Cancel          =   False
      Caption         =   "-"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   415
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipZoomOut"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   30
   End
   Begin DesktopLabel lblZoomLevel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   11.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   450
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "#kCaptionFit"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   "#kTooltipZoomLevel"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   45
   End
   Begin DesktopButton btnZoomIn
      AllowAutoDeactivate=   True
      Bold            =   True
      Cancel          =   False
      Caption         =   "+"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   500
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipZoomIn"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   30
   End
   Begin DesktopButton btnZoomFit
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "#kCaptionFit"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   535
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipZoomFit"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopButton btnSave
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "#kCaptionSave"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   620
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipSave"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   95
   End
   Begin DesktopButton btnPrint
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "#kCaptionPrint"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   720
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipPrint"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   85
   End
   Begin DesktopButton btnClose
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   True
      Caption         =   "#kCaptionClose"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   810
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#kTooltipClose"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopLabel lblInfo
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   11.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   190
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c808080
      Tooltip         =   ""
      Top             =   725
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   700
   End
   Begin Timer tmrRender
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   1
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin Timer tmrScrollAnimation
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   1
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Closing()
		  // Stop the background work and release the renderer and the cached pictures
		  tmrRender.RunMode = Timer.RunModes.Off
		  tmrScrollAnimation.RunMode = Timer.RunModes.Off
		  mPageCache = Nil
		  mPageCacheDensity = Nil
		  mThumbnailCache = Nil
		  mThumbnailRequests = Nil
		  mRenderer = Nil
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Zoom shortcuts (Cmd/Ctrl + - 0) and continuous-scroll navigation keys
		  Return HandlePreviewKey(key)
		End Function
	#tag EndEvent

	#tag Event
		Sub Resized()
		  // Re-layout at the new size (fit mode recomputes the zoom), keeping the top of the view in place
		  If mRenderer <> Nil And mTotalPages > 0 Then
		    ApplyZoom(canvasPage.Width \ 2, 0)
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  // Re-layout at the new size (fit mode recomputes the zoom), keeping the top of the view in place
		  If mRenderer <> Nil And mTotalPages > 0 Then
		    ApplyZoom(canvasPage.Width \ 2, 0)
		  End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21, Description = 4D6F7665732074686520706167652D6368616E6765207363726F6C6C20616E696D6174696F6E206F6E65206672616D652E0A
		Private Sub AdvanceScrollAnimation()
		  Var elapsedMs As Double = (System.Microseconds - mAnimationStartMicroseconds) / 1000.0
		  Var progress As Double = Min(1.0, elapsedMs / kScrollAnimationMs)
		  Var eased As Double = 1.0 - Pow(1.0 - progress, 3)
		  
		  mScrollY = mAnimationStartY + (mAnimationTargetY - mAnimationStartY) * eased
		  If progress >= 1.0 Then
		    mScrollY = mAnimationTargetY
		    tmrScrollAnimation.RunMode = Timer.RunModes.Off
		  End If
		  
		  ClampScroll()
		  UpdateScrollbars()
		  ScheduleRender(0)
		  canvasPage.Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656275696C647320746865206C61796F7574206174207468652063757272656E74207A6F6F6D2C206B656570696E672074686520706F696E7420756E6465722074686520616E63686F7220696E20706C6163652E0A
		Private Sub ApplyZoom(anchorX As Integer = -1, anchorY As Integer = -1)
		  // anchorX/anchorY are canvas coordinates; -1 means the centre of the view.
		  If mRenderer = Nil Or mTotalPages < 1 Then Return
		  If anchorX < 0 Then anchorX = canvasPage.Width \ 2
		  If anchorY < 0 Then anchorY = canvasPage.Height \ 2
		  
		  // Remember which point of which page is under the anchor, in the old layout
		  Var anchorPage As Integer = 0
		  Var fractionX As Double = 0.5
		  Var fractionY As Double = 0.0
		  Var hasAnchor As Boolean = CaptureAnchor(anchorX, anchorY, anchorPage, fractionX, fractionY)
		  
		  Var oldZoom As Double = mLayoutZoom
		  RebuildLayout()
		  
		  // Put the same page point back under the anchor
		  If hasAnchor Then
		    Var pageIndex As Integer = anchorPage - 1
		    Var pageW As Double = mPagePointWidths(pageIndex) * mLayoutZoom
		    Var pageH As Double = mPagePointHeights(pageIndex) * mLayoutZoom
		    Var pageLeft As Double = (LayoutWidth() - pageW) / 2.0
		    mScrollX = pageLeft + fractionX * pageW - anchorX
		    mScrollY = mPageTops(pageIndex) + fractionY * pageH - anchorY
		  End If
		  
		  ClampScroll()
		  UpdateScrollbars()
		  UpdateZoomLabel()
		  
		  // After a zoom change, wait until the zoom settles before re-rendering;
		  // meanwhile the old pictures are drawn scaled
		  If oldZoom <> mLayoutZoom Then
		    ScheduleRender(kRenderDebounceMs)
		  Else
		    ScheduleRender(0)
		  End If
		  canvasPage.Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206361636865642070696374757265206F6620612070616765206F72204E696C2E0A
		Private Function CachedPagePicture(pageNumber As Integer) As Picture
		  If mPageCache = Nil Or Not mPageCache.HasKey(pageNumber) Then Return Nil
		  Var cachedValue As Variant = mPageCache.Value(pageNumber)
		  If cachedValue IsA Picture Then Return Picture(cachedValue)
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865207A6F6F6D207468617420666974732074686520776964657374207061676520746F2074686520766965772077696474682E0A
		Private Function CalculateFitZoom() As Double
		  If mMaxPagePointWidth <= 0 Then Return 1.0
		  
		  Var availableW As Integer = canvasPage.Width - 2 * kDocumentMargin
		  If availableW < 10 Then availableW = 10
		  
		  Var zoom As Double = availableW / mMaxPagePointWidth
		  Return Max(kZoomMinimum, Min(kZoomMaximum, zoom))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 46696E647320746865207061676520756E64657220612063616E76617320706F696E7420616E64207468652072656C617469766520706F736974696F6E206F662074686520706F696E74206F6E2069742E0A
		Private Function CaptureAnchor(viewX As Integer, viewY As Integer, ByRef anchorPage As Integer, ByRef fractionX As Double, ByRef fractionY As Double) As Boolean
		  If mPageTops.Count = 0 Or mLayoutZoom <= 0 Then Return False
		  
		  Var docY As Double = mScrollY + viewY
		  Var pageIndex As Integer = PageIndexAtDocY(docY)
		  If pageIndex < 0 Then Return False
		  
		  Var pageW As Double = mPagePointWidths(pageIndex) * mLayoutZoom
		  Var pageH As Double = mPagePointHeights(pageIndex) * mLayoutZoom
		  If pageW <= 0 Or pageH <= 0 Then Return False
		  
		  Var pageLeft As Double = (LayoutWidth() - pageW) / 2.0
		  fractionX = (mScrollX + viewX - pageLeft) / pageW
		  fractionY = (docY - mPageTops(pageIndex)) / pageH
		  anchorPage = pageIndex + 1
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4B6565707320746865207363726F6C6C206F6666736574732077697468696E20746865207669727475616C20646F63756D656E742E0A
		Private Sub ClampScroll()
		  Var maxX As Double = Max(0.0, mDocWidth - canvasPage.Width)
		  Var maxY As Double = Max(0.0, mDocHeight - canvasPage.Height)
		  
		  mScrollX = Max(0.0, Min(mScrollX, maxX))
		  mScrollY = Max(0.0, Min(mScrollY, maxY))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565207768656E2074686520646F63756D656E74206973206C6172676572207468616E2074686520766965772E0A
		Private Function ContentOverflows() As Boolean
		  Return mDocWidth > canvasPage.Width Or mDocHeight > canvasPage.Height
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E64657273206F6E652070616765206F72206120666577207468756D626E61696C73207065722072656E6465722074696D6572207469636B2E0A
		Private Sub DoPendingRenderWork()
		  // Called by tmrRender. One page per tick keeps scrolling fluid.
		  If tmrRender.Period <> 1 Then tmrRender.Period = 1
		  
		  If mRenderer = Nil Or mPageTops.Count = 0 Then
		    tmrRender.RunMode = Timer.RunModes.Off
		    Return
		  End If
		  
		  Var nextPage As Integer = NextPageToRender()
		  If nextPage > 0 Then
		    RenderPageIntoCache(nextPage)
		    canvasPage.Refresh(False)
		    Return
		  End If
		  
		  // Pages are up to date: render the thumbnails that were painted as placeholders
		  If RenderPendingThumbnails() Then Return
		  
		  tmrRender.RunMode = Timer.RunModes.Off
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4472617773206F6E652070616765206F662074686520636F6E74696E756F757320766965772E0A
		Private Sub DrawPageSheet(g As Graphics, pageIndex As Integer)
		  Var pageW As Double = Round(mPagePointWidths(pageIndex) * mLayoutZoom)
		  Var pageH As Double = Round(mPagePointHeights(pageIndex) * mLayoutZoom)
		  Var drawX As Double = Round((LayoutWidth() - pageW) / 2.0 - mScrollX)
		  Var drawY As Double = Round(mPageTops(pageIndex) - mScrollY)
		  
		  // Soft shadow, then a white sheet
		  g.DrawingColor = &cB8B8B8
		  g.FillRectangle(drawX + 3, drawY + 3, pageW, pageH)
		  g.DrawingColor = &cFFFFFF
		  g.FillRectangle(drawX, drawY, pageW, pageH)
		  
		  // The cached picture may come from another zoom: it is drawn scaled until re-rendered
		  Var pagePic As Picture = CachedPagePicture(pageIndex + 1)
		  If pagePic <> Nil Then
		    g.DrawPicture(pagePic, drawX, drawY, pageW, pageH, 0, 0, pagePic.Width, pagePic.Height)
		  Else
		    g.DrawingColor = &cC8C8C8
		    g.FontSize = 12
		    g.Bold = False
		    Var pageLabel As String = kThumbnailFormat.ReplaceAll("<page>", Str(pageIndex + 1))
		    g.DrawText(pageLabel, drawX + (pageW - g.TextWidth(pageLabel)) / 2.0, drawY + pageH / 2.0)
		  End If
		  
		  g.DrawingColor = &c909090
		  g.DrawRectangle(drawX, drawY, pageW, pageH)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865207A6F6F6D20666163746F7220696E207573652E0A
		Private Function EffectiveZoom() As Double
		  If mZoomLevel <= 0.0 Then
		    Return CalculateFitZoom()
		  Else
		    Return mZoomLevel
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656D6F76657320746865206361636865642070616765732066617274686573742066726F6D2074686520766965772E0A
		Private Sub EvictPageCache()
		  // The visible pages and their direct neighbours are never evicted, so the
		  // render timer cannot render and evict the same page in a loop.
		  If mPageCache = Nil Then Return
		  
		  Var firstIndex As Integer
		  Var lastIndex As Integer
		  VisiblePageRange(firstIndex, lastIndex, 1)
		  Var centerPage As Double = (firstIndex + lastIndex) / 2.0 + 1.0
		  
		  Do
		    Var totalPixels As Double = 0
		    Var farthestPage As Integer = -1
		    Var farthestDistance As Double = -1
		    For Each entry As DictionaryEntry In mPageCache
		      Var pageNumber As Integer = entry.Key.IntegerValue
		      Var cachedValue As Variant = entry.Value
		      If cachedValue IsA Picture Then
		        Var cachedPic As Picture = Picture(cachedValue)
		        totalPixels = totalPixels + cachedPic.Width * cachedPic.Height
		      End If
		      If pageNumber - 1 < firstIndex Or pageNumber - 1 > lastIndex Then
		        Var distance As Double = Abs(pageNumber - centerPage)
		        If distance > farthestDistance Then
		          farthestDistance = distance
		          farthestPage = pageNumber
		        End If
		      End If
		    Next
		  
		    If mPageCache.KeyCount <= kMaxCachedPages And totalPixels <= kMaxCachedPagePixels Then Exit Do
		    If farthestPage < 0 Then Exit Do
		  
		    mPageCache.Remove(farthestPage)
		    If mPageCacheDensity.HasKey(farthestPage) Then mPageCacheDensity.Remove(farthestPage)
		  Loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656D6F7665732074686520636163686564207468756D626E61696C732066617274686573742066726F6D207468652076697369626C6520726F77732E0A
		Private Sub EvictThumbnailCache()
		  If mThumbnailCache = Nil Or mThumbnailCache.KeyCount <= kMaxCachedThumbnails Then Return
		  
		  Var centerRow As Double = lstThumbnails.ScrollPosition + VisibleThumbnailRows() / 2.0
		  Var cachedPages() As Integer
		  Var distances() As Double
		  For Each entry As DictionaryEntry In mThumbnailCache
		    Var pageNumber As Integer = entry.Key.IntegerValue
		    cachedPages.Add(pageNumber)
		    distances.Add(Abs(pageNumber - 1 - centerRow))
		  Next
		  
		  // Nearest first: everything after the first kMaxCachedThumbnails entries goes
		  distances.SortWith(cachedPages)
		  For i As Integer = cachedPages.LastIndex DownTo kMaxCachedThumbnails
		    mThumbnailCache.Remove(cachedPages(i))
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 48616E646C657320746865207A6F6F6D20616E64207363726F6C6C696E67206B6579732E0A
		Private Function HandlePreviewKey(key As String) As Boolean
		  If key = "" Then Return False
		  
		  If Keyboard.CommandKey Or Keyboard.ControlKey Then
		    Select Case key
		    Case "+", "="
		      // Zoom in (= is the unshifted + key on most keyboards)
		      ZoomBy(kZoomButtonFactor)
		      Return True
		    Case "-"
		      ZoomBy(1.0 / kZoomButtonFactor)
		      Return True
		    Case "0"
		      ZoomToFit()
		      Return True
		    End Select
		    Return False
		  End If
		  
		  If mPageTops.Count = 0 Then Return False
		  
		  // A screenful, keeping one arrow step of context
		  Var viewStep As Double = Max(kArrowScrollStep, canvasPage.Height - kArrowScrollStep)
		  
		  Select Case key.Asc
		  Case kKeyUpArrow
		    ScrollByDelta(0, -kArrowScrollStep)
		  Case kKeyDownArrow
		    ScrollByDelta(0, kArrowScrollStep)
		  Case kKeyLeftArrow
		    If mDocWidth > canvasPage.Width Then
		      ScrollByDelta(-kArrowScrollStep, 0)
		    ElseIf mCurrentPage > 1 Then
		      NavigateToPage(mCurrentPage - 1)
		    End If
		  Case kKeyRightArrow
		    If mDocWidth > canvasPage.Width Then
		      ScrollByDelta(kArrowScrollStep, 0)
		    ElseIf mCurrentPage < mTotalPages Then
		      NavigateToPage(mCurrentPage + 1)
		    End If
		  Case kKeyPageUp
		    ScrollByDelta(0, -viewStep)
		  Case kKeyPageDown
		    ScrollByDelta(0, viewStep)
		  Case kKeySpace
		    If Keyboard.ShiftKey Then
		      ScrollByDelta(0, -viewStep)
		    Else
		      ScrollByDelta(0, viewStep)
		    End If
		  Case kKeyHome
		    SetScrollPosition(mScrollX, 0)
		  Case kKeyEnd
		    SetScrollPosition(mScrollX, mDocHeight)
		  Else
		    Return False
		  End Select
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732074686520776964746820746865207061676573206172652063656E7472656420696E2E0A
		Private Function LayoutWidth() As Double
		  Return Max(mDocWidth, canvasPage.Width)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732061207265647563656420636F7079206F6620612070696374757265206D756368206C6172676572207468616E207265717565737465642E0A
		Private Function LimitPictureSize(source As Picture, pixelW As Integer, pixelH As Integer) As Picture
		  // Bounds the memory of the caches whatever pixel density the platform renderer returns.
		  If source = Nil Then Return Nil
		  If source.Width <= pixelW * 1.25 And source.Height <= pixelH * 1.25 Then Return source
		  
		  Var reduced As New Picture(pixelW, pixelH)
		  reduced.Graphics.DrawingColor = &cFFFFFF
		  reduced.Graphics.FillRectangle(0, 0, pixelW, pixelH)
		  reduced.Graphics.DrawPicture(source, 0, 0, pixelW, pixelH, 0, 0, source.Width, source.Height)
		  Return reduced
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4F70656E732074686520504446206461746120616E642070726570617265732074686520636F6E74696E756F757320766965772E0A
		Sub LoadPDF()
		  // Called by ShowPreview() AFTER mPDFData has been assigned.
		  
		  If mPDFData = "" Then Return
		  
		  // Update title
		  Self.Title = kTitleWithNameFormat.ReplaceAll("<name>", mSuggestedFilename)
		  
		  // Update info label with file size
		  Var sizeKB As Double = mPDFData.Bytes / 1024.0
		  If sizeKB < 1024 Then
		    lblInfo.Text = mSuggestedFilename + " (" + kFileSizeKBFormat.ReplaceAll("<size>", Format(sizeKB, "#,##0.0")) + ")"
		  Else
		    lblInfo.Text = mSuggestedFilename + " (" + kFileSizeMBFormat.ReplaceAll("<size>", Format(sizeKB / 1024.0, "#,##0.0")) + ")"
		  End If
		  
		  // Create the native PDF renderer
		  mRenderer = New VNSPDFPageRenderer(mPDFData)
		  mTotalPages = mRenderer.PageCount
		  
		  mPageCache = New Dictionary
		  mPageCacheDensity = New Dictionary
		  mThumbnailCache = New Dictionary
		  mThumbnailRequests = New Dictionary
		  
		  If mTotalPages = 0 Then
		    lblPageInfo.Text = kNoPages
		    btnPrevPage.Enabled = False
		    btnNextPage.Enabled = False
		    Return
		  End If
		  
		  ReadPageSizes()
		  
		  // Start in fit-width mode at the top of the document
		  mZoomLevel = 0.0
		  mScrollX = 0.0
		  mScrollY = 0.0
		  
		  // One empty row per page: each thumbnail is rendered when its row is first painted
		  lstThumbnails.RemoveAllRows()
		  For i As Integer = 1 To mTotalPages
		    lstThumbnails.AddRow("")
		  Next
		  
		  RebuildLayout()
		  ClampScroll()
		  UpdateScrollbars()
		  UpdateZoomLabel()
		  
		  // Render the first page now so the window opens with content; the others follow lazily
		  RenderPageIntoCache(1)
		  SetCurrentPage(1)
		  canvasPage.Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363726F6C6C7320746F2074686520746F70206F66206120706167652E0A
		Sub NavigateToPage(pageNumber As Integer)
		  If mRenderer = Nil Or mPageTops.Count = 0 Then Return
		  If pageNumber < 1 Or pageNumber > mTotalPages Then Return
		  
		  // The indicator follows the requested page at once, so repeated clicks step page by page
		  SetCurrentPage(pageNumber)
		  
		  Var targetY As Double = 0.0
		  If pageNumber > 1 Then targetY = mPageTops(pageNumber - 1) - kPageGap
		  ScrollToDocY(targetY, True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206E657874207061676520746F2072656E646572206F7220302E0A
		Private Function NextPageToRender() As Integer
		  Var firstIndex As Integer
		  Var lastIndex As Integer
		  VisiblePageRange(firstIndex, lastIndex)
		  If firstIndex < 0 Then Return 0
		  
		  For i As Integer = firstIndex To lastIndex
		    If PageNeedsRender(i + 1) Then Return i + 1
		  Next
		  
		  // Page numbers are 1-based: index firstIndex - 1 is page firstIndex
		  If firstIndex > 0 And PageNeedsRender(firstIndex) Then Return firstIndex
		  If lastIndex < mTotalPages - 1 And PageNeedsRender(lastIndex + 2) Then Return lastIndex + 2
		  
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732074686520696E646578206F66207468652070616765206174206120646F63756D656E74205920706F736974696F6E2E0A
		Private Function PageIndexAtDocY(docY As Double) As Integer
		  Var low As Integer = 0
		  Var high As Integer = mPageTops.LastIndex
		  If high < 0 Then Return -1
		  
		  // Binary search: thousands of pages stay instant
		  While low < high
		    Var middle As Integer = (low + high + 1) \ 2
		    If mPageTops(middle) <= docY Then
		      low = middle
		    Else
		      high = middle - 1
		    End If
		  Wend
		  
		  Return low
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565207768656E20612070616765206D7573742062652072656E6465726564206174207468652063757272656E742064656E736974792E0A
		Private Function PageNeedsRender(pageNumber As Integer) As Boolean
		  If mPageCache = Nil Or pageNumber < 1 Or pageNumber > mTotalPages Then Return False
		  If Not mPageCache.HasKey(pageNumber) Or Not mPageCacheDensity.HasKey(pageNumber) Then Return True
		  
		  Var cachedDensity As Double = mPageCacheDensity.Value(pageNumber).DoubleValue
		  Return Abs(cachedDensity - PageRenderDensity(pageNumber)) > 0.001
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732074686520706978656C732070657220706F696E7420746F2072656E646572206120706167652061742E0A
		Private Function PageRenderDensity(pageNumber As Integer) As Double
		  Var screenScale As Double = Self.ScaleFactor
		  If screenScale <= 0 Then screenScale = 1.0
		  
		  Var density As Double = mLayoutZoom * screenScale
		  Var pointArea As Double = mPagePointWidths(pageNumber - 1) * mPagePointHeights(pageNumber - 1)
		  If pointArea > 0 And pointArea * density * density > kMaxPagePixels Then
		    density = Sqrt(kMaxPagePixels / pointArea)
		  End If
		  
		  Return density
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656164732074686520706167652073697A657320696E2050444620706F696E74732E0A
		Private Sub ReadPageSizes()
		  mPagePointWidths.ResizeTo(mTotalPages - 1)
		  mPagePointHeights.ResizeTo(mTotalPages - 1)
		  mMaxPagePointWidth = 0
		  
		  For i As Integer = 0 To mTotalPages - 1
		    Var pageW As Double = mRenderer.GetPageWidth(i + 1)
		    Var pageH As Double = mRenderer.GetPageHeight(i + 1)
		    If pageW <= 0 Then pageW = kDefaultPageWidthPt
		    If pageH <= 0 Then pageH = kDefaultPageHeightPt
		    mPagePointWidths(i) = pageW
		    mPagePointHeights(i) = pageH
		    mMaxPagePointWidth = Max(mMaxPagePointWidth, pageW)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E7665727473206120776865656C206576656E7420696E746F2061207363726F6C6C2064697374616E636520696E20706F696E74732E0A
		Private Sub ReadWheelDeltas(deltaX As Integer, deltaY As Integer, ByRef scrollDX As Double, ByRef scrollDY As Double, ByRef isPrecise As Boolean)
		  // Positive values scroll toward the bottom / right of the document.
		  scrollDX = deltaX * kWheelLinePixels
		  scrollDY = deltaY * kWheelLinePixels
		  isPrecise = False
		  
		  #If TargetMacOS Then
		    // Xojo only gives whole lines; the current NSEvent has the pixel deltas of
		    // trackpads and Magic Mouse, momentum included, as Preview uses them.
		    Declare Function NSClassFromString Lib "Foundation" (className As CFStringRef) As Ptr
		    Declare Function sharedApplication Lib "AppKit" Selector "sharedApplication" (classRef As Ptr) As Ptr
		    Declare Function currentEvent Lib "AppKit" Selector "currentEvent" (appRef As Ptr) As Ptr
		    Declare Function eventType Lib "AppKit" Selector "type" (eventRef As Ptr) As Integer
		    Declare Function hasPreciseScrollingDeltas Lib "AppKit" Selector "hasPreciseScrollingDeltas" (eventRef As Ptr) As Boolean
		    Declare Function scrollingDeltaX Lib "AppKit" Selector "scrollingDeltaX" (eventRef As Ptr) As CGFloat
		    Declare Function scrollingDeltaY Lib "AppKit" Selector "scrollingDeltaY" (eventRef As Ptr) As CGFloat
		  
		    Var appRef As Ptr = sharedApplication(NSClassFromString("NSApplication"))
		    If appRef = Nil Then Return
		    Var eventRef As Ptr = currentEvent(appRef)
		    If eventRef = Nil Then Return
		    If eventType(eventRef) <> kNSEventTypeScrollWheel Then Return
		  
		    // NSEvent deltas give the content movement (positive = content moves down/right),
		    // already following the user's natural scrolling setting
		    Var nativeDX As Double = scrollingDeltaX(eventRef)
		    Var nativeDY As Double = scrollingDeltaY(eventRef)
		    If hasPreciseScrollingDeltas(eventRef) Then
		      isPrecise = True
		      scrollDX = -nativeDX
		      scrollDY = -nativeDY
		    Else
		      scrollDX = -nativeDX * kMacWheelLinePixels
		      scrollDY = -nativeDY * kMacWheelLinePixels
		    End If
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6D707574657320746865207061676520706F736974696F6E73206174207468652063757272656E74207A6F6F6D2E0A
		Private Sub RebuildLayout()
		  Var zoom As Double = EffectiveZoom()
		  mLayoutZoom = zoom
		  
		  mPageTops.ResizeTo(mTotalPages - 1)
		  Var y As Double = kDocumentMargin
		  Var widest As Double = 0
		  
		  For i As Integer = 0 To mTotalPages - 1
		    mPageTops(i) = y
		    y = y + mPagePointHeights(i) * zoom + kPageGap
		    widest = Max(widest, mPagePointWidths(i) * zoom)
		  Next
		  
		  mDocHeight = y - kPageGap + kDocumentMargin
		  mDocWidth = widest + 2 * kDocumentMargin
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E64657273206F6E65207061676520696E746F2074686520706167652063616368652E0A
		Private Sub RenderPageIntoCache(pageNumber As Integer)
		  If mRenderer = Nil Or mPageCache = Nil Then Return
		  If pageNumber < 1 Or pageNumber > mTotalPages Then Return
		  
		  Var density As Double = PageRenderDensity(pageNumber)
		  Var pixelW As Integer = Max(1, Ceiling(mPagePointWidths(pageNumber - 1) * density))
		  Var pixelH As Integer = Max(1, Ceiling(mPagePointHeights(pageNumber - 1) * density))
		  
		  Var rendered As Picture = RenderScaled(pageNumber, pixelW, pixelH)
		  
		  // A Nil result is cached too, so a failing page is not retried on every tick
		  mPageCache.Value(pageNumber) = rendered
		  mPageCacheDensity.Value(pageNumber) = density
		  EvictPageCache()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E6465727320746865207265717565737465642076697369626C65207468756D626E61696C732077697468696E20612074696D65206275646765742E0A
		Private Function RenderPendingThumbnails() As Boolean
		  If mThumbnailRequests = Nil Or mThumbnailRequests.KeyCount = 0 Then Return False
		  
		  Var firstRow As Integer = lstThumbnails.ScrollPosition
		  Var lastRow As Integer = firstRow + VisibleThumbnailRows()
		  Var startMicroseconds As Double = System.Microseconds
		  Var renderedAny As Boolean = False
		  
		  Var requestedPages() As Integer
		  For Each entry As DictionaryEntry In mThumbnailRequests
		    requestedPages.Add(entry.Key.IntegerValue)
		  Next
		  
		  For Each pageNumber As Integer In requestedPages
		    If pageNumber - 1 < firstRow Or pageNumber - 1 > lastRow Then
		      // Scrolled away: the row asks again when it is painted
		      mThumbnailRequests.Remove(pageNumber)
		      Continue
		    End If
		    If (System.Microseconds - startMicroseconds) / 1000.0 > kThumbnailBudgetMs Then Exit For
		    RenderThumbnailIntoCache(pageNumber)
		    mThumbnailRequests.Remove(pageNumber)
		    renderedAny = True
		  Next
		  
		  If renderedAny Then
		    EvictThumbnailCache()
		    lstThumbnails.Refresh(False)
		  End If
		  
		  Return mThumbnailRequests.KeyCount > 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E64657273206120706167652070696374757265206F66206120676976656E20706978656C2073697A652E0A
		Private Function RenderScaled(pageNumber As Integer, pixelW As Integer, pixelH As Integer) As Picture
		  // Some platform renderers return more pixels than requested (for example a
		  // Retina backing store). The ratio is learnt from the first result and the
		  // next requests are reduced accordingly; LimitPictureSize bounds the rest.
		  Var requestW As Integer = Max(1, Round(pixelW / mRendererOversample))
		  Var requestH As Integer = Max(1, Round(pixelH / mRendererOversample))
		  
		  Var rendered As Picture = mRenderer.RenderPage(pageNumber, requestW, requestH)
		  If rendered = Nil Then Return Nil
		  
		  Var ratio As Double = rendered.Width / requestW
		  If ratio > 1.25 Then mRendererOversample = mRendererOversample * ratio
		  
		  Return LimitPictureSize(rendered, pixelW, pixelH)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E64657273206F6E65207468756D626E61696C20696E746F20746865207468756D626E61696C2063616368652E0A
		Private Sub RenderThumbnailIntoCache(pageNumber As Integer)
		  If mRenderer = Nil Or mThumbnailCache = Nil Then Return
		  
		  Var drawW As Double
		  Var drawH As Double
		  ThumbnailDrawSize(pageNumber, drawW, drawH)
		  
		  Var screenScale As Double = Max(1.0, Self.ScaleFactor)
		  Var pixelW As Integer = Max(1, Ceiling(drawW * screenScale))
		  Var pixelH As Integer = Max(1, Ceiling(drawH * screenScale))
		  
		  // A Nil result is cached too: the row then keeps its blank sheet
		  mThumbnailCache.Value(pageNumber) = RenderScaled(pageNumber, pixelW, pixelH)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 537461727473207468652072656E6465722074696D65722C206F7074696F6E616C6C7920616674657220612064656C61792E0A
		Private Sub ScheduleRender(delayMs As Integer)
		  If delayMs > 0 Then
		    tmrRender.Period = delayMs
		    tmrRender.RunMode = Timer.RunModes.Multiple
		  ElseIf tmrRender.RunMode = Timer.RunModes.Off Then
		    tmrRender.Period = 1
		    tmrRender.RunMode = Timer.RunModes.Multiple
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5363726F6C6C7320746865207669657720627920612064697374616E636520696E20706F696E74732E0A
		Private Sub ScrollByDelta(deltaX As Double, deltaY As Double)
		  SetScrollPosition(mScrollX + deltaX, mScrollY + deltaY)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5363726F6C6C7320766572746963616C6C7920746F206120646F63756D656E7420706F736974696F6E2E0A
		Private Sub ScrollToDocY(targetY As Double, animate As Boolean)
		  Var maxY As Double = Max(0.0, mDocHeight - canvasPage.Height)
		  targetY = Max(0.0, Min(targetY, maxY))
		  StopScrollAnimation()
		  
		  // Far jumps are immediate: animating through hundreds of pages helps nobody
		  Var distance As Double = Abs(targetY - mScrollY)
		  If Not animate Or distance < 1 Or distance > canvasPage.Height * 3 Then
		    mScrollY = targetY
		    UpdateScrollbars()
		    ScheduleRender(0)
		    canvasPage.Refresh(False)
		    Return
		  End If
		  
		  mAnimationStartY = mScrollY
		  mAnimationTargetY = targetY
		  mAnimationStartMicroseconds = System.Microseconds
		  tmrScrollAnimation.Period = kAnimationFrameMs
		  tmrScrollAnimation.RunMode = Timer.RunModes.Multiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D616B657320612070616765207468652063757272656E7420706167652E0A
		Private Sub SetCurrentPage(pageNumber As Integer)
		  mCurrentPage = pageNumber
		  UpdatePageLabel()
		  btnPrevPage.Enabled = (mCurrentPage > 1)
		  btnNextPage.Enabled = (mCurrentPage < mTotalPages)
		  SyncThumbnailSelection()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D6F76657320746865207669657720746F2061207363726F6C6C20706F736974696F6E2063686F73656E2062792074686520757365722E0A
		Private Sub SetScrollPosition(newX As Double, newY As Double)
		  StopScrollAnimation()
		  mScrollX = newX
		  mScrollY = newY
		  ClampScroll()
		  UpdateScrollbars()
		  UpdateCurrentPageFromScroll()
		  ScheduleRender(0)
		  canvasPage.Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub ShowPreview(pdfData As String, suggestedFilename As String = "document.pdf", initialFolder As FolderItem = Nil)
		  // Create and show the preview window with the given PDF data.
		  // Uses native rendering (PDFKit on macOS, Windows.Data.Pdf on Windows, Poppler on Linux)
		  // to display pages in a Canvas with thumbnail navigation.
		  //
		  // Parameters:
		  //   pdfData - The raw PDF binary data (from VNSPDFDocument.Output())
		  //   suggestedFilename - Default filename for save dialog
		  //   initialFolder - Optional folder to start the save dialog in (contributed by Geoff Bridges)
		  
		  If pdfData = "" Then Return
		  
		  Dim w As New VNSPDFPreviewWindow
		  w.mPDFData = pdfData
		  w.mSuggestedFilename = suggestedFilename
		  w.mInitialSaveFolder = initialFolder
		  w.LoadPDF()
		  w.ShowModal()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53746F70732074686520706167652D6368616E6765207363726F6C6C20616E696D6174696F6E2E0A
		Private Sub StopScrollAnimation()
		  If tmrScrollAnimation.RunMode <> Timer.RunModes.Off Then
		    tmrScrollAnimation.RunMode = Timer.RunModes.Off
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53656C6563747320746865207468756D626E61696C206F66207468652063757272656E7420706167652E0A
		Private Sub SyncThumbnailSelection()
		  Var row As Integer = mCurrentPage - 1
		  If row < 0 Or row > lstThumbnails.LastRowIndex Then Return
		  
		  mSyncingThumbnailSelection = True
		  If lstThumbnails.SelectedRowIndex <> row Then lstThumbnails.SelectedRowIndex = row
		  
		  Var visibleRows As Integer = Max(1, lstThumbnails.Height \ lstThumbnails.DefaultRowHeight)
		  If row < lstThumbnails.ScrollPosition Then
		    lstThumbnails.ScrollPosition = row
		  ElseIf row >= lstThumbnails.ScrollPosition + visibleRows Then
		    lstThumbnails.ScrollPosition = row - visibleRows + 1
		  End If
		  mSyncingThumbnailSelection = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652073697A65206F662061207468756D626E61696C20696E20612063656C6C2E0A
		Private Sub ThumbnailDrawSize(pageNumber As Integer, ByRef drawW As Double, ByRef drawH As Double)
		  Var cellW As Integer = lstThumbnails.Width - kThumbnailScrollbarAllowance
		  Var availH As Integer = lstThumbnails.DefaultRowHeight - kThumbnailLabelHeight
		  
		  Var pageW As Double = mPagePointWidths(pageNumber - 1)
		  Var pageH As Double = mPagePointHeights(pageNumber - 1)
		  Var fitScale As Double = Min((cellW - 8) / pageW, (availH - 4) / pageH)
		  
		  drawW = Max(1.0, Round(pageW * fitScale))
		  drawH = Max(1.0, Round(pageH * fitScale))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D616B657320746865206D6F73742076697369626C652070616765207468652063757272656E7420706167652E0A
		Private Sub UpdateCurrentPageFromScroll()
		  If mPageTops.Count = 0 Then Return
		  
		  Var firstIndex As Integer
		  Var lastIndex As Integer
		  VisiblePageRange(firstIndex, lastIndex)
		  If firstIndex < 0 Then Return
		  
		  Var viewTop As Double = mScrollY
		  Var viewBottom As Double = mScrollY + canvasPage.Height
		  Var bestPage As Integer = firstIndex + 1
		  Var bestVisible As Double = -1
		  
		  For i As Integer = firstIndex To lastIndex
		    Var pageTop As Double = mPageTops(i)
		    Var pageBottom As Double = pageTop + mPagePointHeights(i) * mLayoutZoom
		    Var visibleH As Double = Min(pageBottom, viewBottom) - Max(pageTop, viewTop)
		    If visibleH > bestVisible + 0.5 Then
		      bestVisible = visibleH
		      bestPage = i + 1
		    End If
		  Next
		  
		  If bestPage <> mCurrentPage Then SetCurrentPage(bestPage)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5570646174657320746865207061676520696E64696361746F722E0A
		Private Sub UpdatePageLabel()
		  If mTotalPages > 0 Then
		    lblPageInfo.Text = kPageInfoFormat.ReplaceAll("<page>", Str(mCurrentPage)).ReplaceAll("<total>", Str(mTotalPages))
		  Else
		    lblPageInfo.Text = ""
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D61707320746865207363726F6C6C6261727320746F20746865207669727475616C20646F63756D656E742E0A
		Private Sub UpdateScrollbars()
		  // The guard stops the ValueChanged events raised here from scrolling again.
		  mSyncingScrollbars = True
		  
		  Var viewW As Integer = canvasPage.Width
		  Var viewH As Integer = canvasPage.Height
		  Var maxX As Integer = Max(0, Ceiling(mDocWidth - viewW))
		  Var maxY As Integer = Max(0, Ceiling(mDocHeight - viewH))
		  
		  If maxX > 0 Then
		    scrHorizontal.Enabled = True
		    scrHorizontal.MinimumValue = 0
		    scrHorizontal.MaximumValue = maxX
		    scrHorizontal.LineStep = kArrowScrollStep
		    scrHorizontal.PageStep = Max(1, viewW - kArrowScrollStep)
		    scrHorizontal.Value = Min(maxX, Round(mScrollX))
		  Else
		    scrHorizontal.Value = 0
		    scrHorizontal.Enabled = False
		  End If
		  
		  If maxY > 0 Then
		    scrVertical.Enabled = True
		    scrVertical.MinimumValue = 0
		    scrVertical.MaximumValue = maxY
		    scrVertical.LineStep = kArrowScrollStep
		    scrVertical.PageStep = Max(1, viewH - kArrowScrollStep)
		    scrVertical.Value = Min(maxY, Round(mScrollY))
		  Else
		    scrVertical.Value = 0
		    scrVertical.Enabled = False
		  End If
		  
		  mSyncingScrollbars = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 446973706C61797320746865207A6F6F6D2070657263656E746167652E0A
		Private Sub UpdateZoomLabel()
		  Var pct As Integer = Round(EffectiveZoom() * 100)
		  lblZoomLevel.Text = kZoomPercentFormat.ReplaceAll("<percent>", Str(pct))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652072616E6765206F6620706167657320696E74657273656374696E672074686520766965772E0A
		Private Sub VisiblePageRange(ByRef firstIndex As Integer, ByRef lastIndex As Integer, extraPages As Integer = 0)
		  firstIndex = PageIndexAtDocY(mScrollY)
		  If firstIndex < 0 Then
		    lastIndex = -1
		    Return
		  End If
		  
		  lastIndex = PageIndexAtDocY(mScrollY + canvasPage.Height)
		  firstIndex = Max(0, firstIndex - extraPages)
		  lastIndex = Min(mTotalPages - 1, lastIndex + extraPages)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206E756D626572206F662076697369626C65207468756D626E61696C20726F77732E0A
		Private Function VisibleThumbnailRows() As Integer
		  Return Max(1, lstThumbnails.Height \ lstThumbnails.DefaultRowHeight) + 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D756C7469706C69657320746865207A6F6F6D206279206120666163746F722E0A
		Private Sub ZoomBy(factor As Double, anchorX As Integer = -1, anchorY As Integer = -1)
		  ZoomToLevel(EffectiveZoom() * factor, anchorX, anchorY)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 537769746368657320746F206669742D7769647468206D6F64652E0A
		Private Sub ZoomToFit()
		  mZoomLevel = 0.0
		  ApplyZoom()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 536574732061206669786564207A6F6F6D206C6576656C2E0A
		Private Sub ZoomToLevel(newZoom As Double, anchorX As Integer = -1, anchorY As Integer = -1)
		  // anchorX/Y are canvas coordinates; -1 means the centre of the view.
		  mZoomLevel = Max(kZoomMinimum, Min(kZoomMaximum, newZoom))
		  ApplyZoom(anchorX, anchorY)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 53746172742074696D65206F6620746865207363726F6C6C20616E696D6174696F6E2E0A
		Private mAnimationStartMicroseconds As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5363726F6C6C20706F736974696F6E20617420746865207374617274206F662074686520616E696D6174696F6E2E0A
		Private mAnimationStartY As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5363726F6C6C20706F736974696F6E2074686520616E696D6174696F6E206D6F76657320746F2E0A
		Private mAnimationTargetY As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentPage As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 486569676874206F6620746865207669727475616C20646F63756D656E742E0A
		Private mDocHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5769647468206F6620746865207669727475616C20646F63756D656E742E0A
		Private mDocWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInitialSaveFolder As FolderItem = Nil
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsPanning As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5A6F6F6D206F66207468652063757272656E74206C61796F75742E0A
		Private mLayoutZoom As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5769647468206F662074686520776964657374207061676520696E20706F696E74732E0A
		Private mMaxPagePointWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 52656E64657265642070616765732062792070616765206E756D6265722E0A
		Private mPageCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 52656E6465722064656E73697479206F6620656163682063616368656420706167652E0A
		Private mPageCacheDensity As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 50616765206865696768747320696E20706F696E74732E0A
		Private mPagePointHeights() As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 506167652077696474687320696E20706F696E74732E0A
		Private mPagePointWidths() As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5061676520746F707320696E20746865207669727475616C20646F63756D656E742E0A
		Private mPageTops() As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPanStartScrollX As Double = 0.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPanStartScrollY As Double = 0.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPanStartX As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPanStartY As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		mPDFData As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRenderer As VNSPDFPageRenderer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 506978656C732072657475726E65642070657220706978656C20726571756573746564206279207468652072656E64657265722E0A
		Private mRendererOversample As Double = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollX As Double = 0.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollY As Double = 0.0
	#tag EndProperty

	#tag Property, Flags = &h0
		mSuggestedFilename As String = "document.pdf"
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565207768696C652074686520636F6465207365747320746865207363726F6C6C626172732E0A
		Private mSyncingScrollbars As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565207768696C652074686520636F64652073656C656374732061207468756D626E61696C2E0A
		Private mSyncingThumbnailSelection As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 52656E6465726564207468756D626E61696C732062792070616765206E756D6265722E0A
		Private mThumbnailCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468756D626E61696C732077616974696E6720746F2062652072656E64657265642E0A
		Private mThumbnailRequests As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTotalPages As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mZoomLevel As Double = 0.0
	#tag EndProperty


	#tag Constant, Name = kAnimationFrameMs, Type = Integer, Dynamic = False, Default = \"15", Scope = Private, Description = 506572696F64206F662074686520706167652D6368616E6765207363726F6C6C20616E696D6174696F6E2074696D65722E0A
	#tag EndConstant

	#tag Constant, Name = kArrowScrollStep, Type = Integer, Dynamic = False, Default = \"40", Scope = Private, Description = 44697374616E6365207363726F6C6C656420627920616E206172726F77206B6579206F722061207363726F6C6C626172206172726F772E0A
	#tag EndConstant

	#tag Constant, Name = kCaptionClose, Type = String, Dynamic = True, Default = \"Close", Scope = Private, Description = 43617074696F6E206F662074686520436C6F736520627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Fermer"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Schlie\xC3\x9Fen"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Chiudi"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Cerrar"
	#tag EndConstant

	#tag Constant, Name = kCaptionFit, Type = String, Dynamic = True, Default = \"Fit", Scope = Private, Description = 43617074696F6E206F66207468652046697420627574746F6E20616E6420696E697469616C207A6F6F6D206C6162656C20746578742E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Ajuster"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Einpassen"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Adatta"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Ajustar"
	#tag EndConstant

	#tag Constant, Name = kCaptionPrint, Type = String, Dynamic = True, Default = \"Print...", Scope = Private, Description = 43617074696F6E206F6620746865205072696E7420627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Imprimer\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Drucken\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Stampa\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Imprimir\xE2\x80\xA6"
	#tag EndConstant

	#tag Constant, Name = kCaptionSave, Type = String, Dynamic = True, Default = \"Save...", Scope = Private, Description = 43617074696F6E206F6620746865205361766520627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Enregistrer\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Sichern\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Salva\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Guardar\xE2\x80\xA6"
	#tag EndConstant

	#tag Constant, Name = kDefaultPageHeightPt, Type = Double, Dynamic = False, Default = \"841.89", Scope = Private, Description = 50616765206865696768742075736564207768656E207468652072656E6465726572207265706F727473206E6F6E6520284134292E0A
	#tag EndConstant

	#tag Constant, Name = kDefaultPageWidthPt, Type = Double, Dynamic = False, Default = \"595.28", Scope = Private, Description = 506167652077696474682075736564207768656E207468652072656E6465726572207265706F727473206E6F6E6520284134292E0A
	#tag EndConstant

	#tag Constant, Name = kDocumentMargin, Type = Integer, Dynamic = False, Default = \"16", Scope = Private, Description = 4D617267696E2061726F756E6420746865207061676573206F662074686520636F6E74696E756F757320766965772E0A
	#tag EndConstant

	#tag Constant, Name = kErrorSavingFormat, Type = String, Dynamic = True, Default = \"Error saving PDF: <error>", Scope = Private, Description = 4572726F72206D657373616765207768656E20736176696E67206661696C733B203C6572726F723E206973207265706C6163656420627920746865206572726F72206D6573736167652E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Erreur lors de l\xE2\x80\x99enregistrement du PDF\xC2\xA0: <error>"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Fehler beim Sichern des PDF: <error>"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Errore durante il salvataggio del PDF: <error>"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Error al guardar el PDF: <error>"
	#tag EndConstant

	#tag Constant, Name = kFileSizeKBFormat, Type = String, Dynamic = True, Default = \"<size> KB", Scope = Private, Description = 46696C652073697A6520696E206B696C6F62797465733B203C73697A653E206973207265706C6163656420627920746865206E756D6265722E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"<size>\xC2\xA0Ko"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"<size>\xC2\xA0KB"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"<size>\xC2\xA0KB"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"<size>\xC2\xA0KB"
	#tag EndConstant

	#tag Constant, Name = kFileSizeMBFormat, Type = String, Dynamic = True, Default = \"<size> MB", Scope = Private, Description = 46696C652073697A6520696E206D65676162797465733B203C73697A653E206973207265706C6163656420627920746865206E756D6265722E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"<size>\xC2\xA0Mo"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"<size>\xC2\xA0MB"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"<size>\xC2\xA0MB"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"<size>\xC2\xA0MB"
	#tag EndConstant

	#tag Constant, Name = kKeyDownArrow, Type = Integer, Dynamic = False, Default = \"31", Scope = Private, Description = 436F6465206F662074686520646F776E206172726F77206B65792E0A
	#tag EndConstant

	#tag Constant, Name = kKeyEnd, Type = Integer, Dynamic = False, Default = \"4", Scope = Private, Description = 436F6465206F662074686520456E64206B65792E0A
	#tag EndConstant

	#tag Constant, Name = kKeyHome, Type = Integer, Dynamic = False, Default = \"1", Scope = Private, Description = 436F6465206F662074686520486F6D65206B65792E0A
	#tag EndConstant

	#tag Constant, Name = kKeyLeftArrow, Type = Integer, Dynamic = False, Default = \"28", Scope = Private, Description = 436F6465206F6620746865206C656674206172726F77206B65792E0A
	#tag EndConstant

	#tag Constant, Name = kKeyPageDown, Type = Integer, Dynamic = False, Default = \"12", Scope = Private, Description = 436F6465206F6620746865205061676520446F776E206B65792E0A
	#tag EndConstant

	#tag Constant, Name = kKeyPageUp, Type = Integer, Dynamic = False, Default = \"11", Scope = Private, Description = 436F6465206F66207468652050616765205570206B65792E0A
	#tag EndConstant

	#tag Constant, Name = kKeyRightArrow, Type = Integer, Dynamic = False, Default = \"29", Scope = Private, Description = 436F6465206F6620746865207269676874206172726F77206B65792E0A
	#tag EndConstant

	#tag Constant, Name = kKeySpace, Type = Integer, Dynamic = False, Default = \"32", Scope = Private, Description = 436F6465206F6620746865207370616365206261722E0A
	#tag EndConstant

	#tag Constant, Name = kKeyUpArrow, Type = Integer, Dynamic = False, Default = \"30", Scope = Private, Description = 436F6465206F6620746865207570206172726F77206B65792E0A
	#tag EndConstant

	#tag Constant, Name = kLoading, Type = String, Dynamic = True, Default = \"Loading...", Scope = Private, Description = 43616E76617320706C616365686F6C646572207768696C652074686520706167652069732072656E646572696E672E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Chargement\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Wird geladen\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Caricamento\xE2\x80\xA6"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Cargando\xE2\x80\xA6"
	#tag EndConstant

	#tag Constant, Name = kMacWheelLinePixels, Type = Integer, Dynamic = False, Default = \"16", Scope = Private, Description = 506F696E7473207363726F6C6C656420706572206C696E6520666F72206120636C6173736963206D6F75736520776865656C206F6E206D61634F532E0A
	#tag EndConstant

	#tag Constant, Name = kMaxCachedPagePixels, Type = Integer, Dynamic = False, Default = \"80000000", Scope = Private, Description = 506978656C20627564676574206F66207468652070616765206361636865202861626F757420333230204D42292E0A
	#tag EndConstant

	#tag Constant, Name = kMaxCachedPages, Type = Integer, Dynamic = False, Default = \"12", Scope = Private, Description = 4D6178696D756D206E756D626572206F662072656E6465726564207061676573206B65707420696E2074686520706167652063616368652E0A
	#tag EndConstant

	#tag Constant, Name = kMaxCachedThumbnails, Type = Integer, Dynamic = False, Default = \"300", Scope = Private, Description = 4D6178696D756D206E756D626572206F662072656E6465726564207468756D626E61696C73206B65707420696E20746865207468756D626E61696C2063616368652E0A
	#tag EndConstant

	#tag Constant, Name = kMaxPagePixels, Type = Integer, Dynamic = False, Default = \"16000000", Scope = Private, Description = 4D6178696D756D206E756D626572206F6620706978656C73206F66206F6E652072656E646572656420706167653B20686967686572207A6F6F6D732072656E6465722061742061206C6F7765722064656E736974792E0A
	#tag EndConstant

	#tag Constant, Name = kNoPages, Type = String, Dynamic = True, Default = \"No pages", Scope = Private, Description = 5061676520696E64696361746F722074657874207768656E207468652050444620686173206E6F2070616765732E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Aucune page"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Keine Seiten"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Nessuna pagina"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Sin p\xC3\xA1ginas"
	#tag EndConstant

	#tag Constant, Name = kNoPDFForPrinting, Type = String, Dynamic = True, Default = \"No PDF available for printing.", Scope = Private, Description = 4D6573736167652073686F776E207768656E207468657265206973206E6F7468696E6720746F207072696E742E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Aucun PDF \xC3\xA0 imprimer."
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Kein PDF zum Drucken verf\xC3\xBCgbar."
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Nessun PDF disponibile per la stampa."
		#Tag Instance, Platform = Any, Language = es, Definition  = \"No hay ning\xC3\xBAn PDF disponible para imprimir."
	#tag EndConstant

	#tag Constant, Name = kNoPDFLoaded, Type = String, Dynamic = True, Default = \"No PDF loaded", Scope = Private, Description = 43616E76617320706C616365686F6C646572207768656E206E6F20504446206973206C6F616465642E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Aucun PDF charg\xC3\xA9"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Kein PDF geladen"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Nessun PDF caricato"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Ning\xC3\xBAn PDF cargado"
	#tag EndConstant

	#tag Constant, Name = kNSEventTypeScrollWheel, Type = Integer, Dynamic = False, Default = \"22", Scope = Private, Description = 56616C7565206F66204E534576656E74547970655363726F6C6C576865656C20696E204170704B69742E0A
	#tag EndConstant

	#tag Constant, Name = kPageGap, Type = Integer, Dynamic = False, Default = \"12", Scope = Private, Description = 476170206265747765656E2074776F207061676573206F662074686520636F6E74696E756F757320766965772E0A
	#tag EndConstant

	#tag Constant, Name = kPageInfoFormat, Type = String, Dynamic = True, Default = \"Page <page> / <total>", Scope = Private, Description = 5061676520696E64696361746F723B203C706167653E20616E64203C746F74616C3E20617265207265706C61636564206279206E756D626572732E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Page <page> / <total>"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Seite <page> / <total>"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Pagina <page> / <total>"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"P\xC3\xA1gina <page> / <total>"
	#tag EndConstant

	#tag Constant, Name = kPreciseZoomPerPixel, Type = Double, Dynamic = False, Default = \"1.01", Scope = Private, Description = 5A6F6F6D20666163746F722070657220706F696E74206F662070726563697365207363726F6C6C696E67207768696C6520436F6D6D616E64206F7220436F6E74726F6C2069732068656C642E0A
	#tag EndConstant

	#tag Constant, Name = kRenderDebounceMs, Type = Integer, Dynamic = False, Default = \"120", Scope = Private, Description = 44656C6179206265666F72652072652D72656E646572696E672061667465722061207A6F6F6D206F722073697A65206368616E67652E0A
	#tag EndConstant

	#tag Constant, Name = kSaveDialogTitle, Type = String, Dynamic = True, Default = \"Save PDF", Scope = Private, Description = 5469746C65206F662074686520736176652066696C65206469616C6F672E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Enregistrer le PDF"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"PDF sichern"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Salva PDF"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Guardar PDF"
	#tag EndConstant

	#tag Constant, Name = kScrollAnimationMs, Type = Integer, Dynamic = False, Default = \"180", Scope = Private, Description = 4475726174696F6E206F662074686520706167652D6368616E6765207363726F6C6C20616E696D6174696F6E2E0A
	#tag EndConstant

	#tag Constant, Name = kThumbnailBudgetMs, Type = Integer, Dynamic = False, Default = \"25", Scope = Private, Description = 54696D65207370656E742072656E646572696E67207468756D626E61696C73207065722072656E6465722074696D6572207469636B2E0A
	#tag EndConstant

	#tag Constant, Name = kThumbnailFormat, Type = String, Dynamic = True, Default = \"Page <page>", Scope = Private, Description = 5468756D626E61696C20706C616365686F6C646572206C6162656C3B203C706167653E206973207265706C61636564206279207468652070616765206E756D6265722E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Page <page>"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Seite <page>"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Pagina <page>"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"P\xC3\xA1gina <page>"
	#tag EndConstant

	#tag Constant, Name = kThumbnailLabelHeight, Type = Integer, Dynamic = False, Default = \"22", Scope = Private, Description = 486569676874206B6570742062656C6F772061207468756D626E61696C20666F72206974732070616765206E756D6265722E0A
	#tag EndConstant

	#tag Constant, Name = kThumbnailScrollbarAllowance, Type = Integer, Dynamic = False, Default = \"20", Scope = Private, Description = 5769647468206B657074206672656520666F7220746865207363726F6C6C626172206F6620746865207468756D626E61696C206C6973742E0A
	#tag EndConstant

	#tag Constant, Name = kTitle, Type = String, Dynamic = True, Default = \"PDF Preview", Scope = Private, Description = 5469746C65206F66207468652050444620707265766965772077696E646F772E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Aper\xC3\xA7u PDF"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"PDF-Vorschau"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Anteprima PDF"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Vista previa del PDF"
	#tag EndConstant

	#tag Constant, Name = kTitleWithNameFormat, Type = String, Dynamic = True, Default = \"PDF Preview - <name>", Scope = Private, Description = 57696E646F77207469746C6520776974682074686520646F63756D656E74206E616D653B203C6E616D653E206973207265706C61636564206279207468652066696C65206E616D652E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Aper\xC3\xA7u PDF - <name>"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"PDF-Vorschau - <name>"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Anteprima PDF - <name>"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Vista previa del PDF - <name>"
	#tag EndConstant

	#tag Constant, Name = kTooltipClose, Type = String, Dynamic = True, Default = \"Close this window", Scope = Private, Description = 546F6F6C746970206F662074686520436C6F736520627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Fermer cette fen\xC3\xAAtre"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Dieses Fenster schlie\xC3\x9Fen"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Chiudi questa finestra"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Cerrar esta ventana"
	#tag EndConstant

	#tag Constant, Name = kTooltipNextPage, Type = String, Dynamic = True, Default = \"Next page", Scope = Private, Description = 546F6F6C746970206F6620746865206E657874207061676520627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Page suivante"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"N\xC3\xA4chste Seite"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Pagina successiva"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"P\xC3\xA1gina siguiente"
	#tag EndConstant

	#tag Constant, Name = kTooltipPrevPage, Type = String, Dynamic = True, Default = \"Previous page", Scope = Private, Description = 546F6F6C746970206F66207468652070726576696F7573207061676520627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Page pr\xC3\xA9c\xC3\xA9dente"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Vorherige Seite"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Pagina precedente"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"P\xC3\xA1gina anterior"
	#tag EndConstant

	#tag Constant, Name = kTooltipPrint, Type = String, Dynamic = True, Default = \"Print the PDF document", Scope = Private, Description = 546F6F6C746970206F6620746865205072696E7420627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Imprimer le document PDF"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"PDF-Dokument drucken"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Stampa il documento PDF"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Imprimir el documento PDF"
	#tag EndConstant

	#tag Constant, Name = kTooltipSave, Type = String, Dynamic = True, Default = \"Save the PDF to a file", Scope = Private, Description = 546F6F6C746970206F6620746865205361766520627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Enregistrer le PDF dans un fichier"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"PDF in einer Datei sichern"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Salva il PDF in un file"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Guardar el PDF en un archivo"
	#tag EndConstant

	#tag Constant, Name = kTooltipThumbnails, Type = String, Dynamic = True, Default = \"Click a page thumbnail to navigate", Scope = Private, Description = 546F6F6C746970206F6620746865207468756D626E61696C206C6973742E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Cliquez sur une vignette pour afficher la page"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Klicken Sie auf eine Miniatur\x2C um die Seite anzuzeigen"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Fai clic su una miniatura per visualizzare la pagina"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Haga clic en una miniatura para ver la p\xC3\xA1gina"
	#tag EndConstant

	#tag Constant, Name = kTooltipZoomFit, Type = String, Dynamic = True, Default = \"Fit page width to window", Scope = Private, Description = 546F6F6C746970206F66207468652046697420627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Ajuster la largeur de la page \xC3\xA0 la fen\xC3\xAAtre"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Seitenbreite an Fenster anpassen"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Adatta la larghezza della pagina alla finestra"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Ajustar el ancho de la p\xC3\xA1gina a la ventana"
	#tag EndConstant

	#tag Constant, Name = kTooltipZoomIn, Type = String, Dynamic = True, Default = \"Zoom in", Scope = Private, Description = 546F6F6C746970206F6620746865207A6F6F6D20696E20627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Agrandir"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Vergr\xC3\xB6\xC3\x9Fern"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Ingrandisci"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Ampliar"
	#tag EndConstant

	#tag Constant, Name = kTooltipZoomLevel, Type = String, Dynamic = True, Default = \"Current zoom level", Scope = Private, Description = 546F6F6C746970206F6620746865207A6F6F6D206C6576656C206C6162656C2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Niveau de zoom actuel"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Aktuelle Zoomstufe"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Livello di zoom attuale"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Nivel de zoom actual"
	#tag EndConstant

	#tag Constant, Name = kTooltipZoomOut, Type = String, Dynamic = True, Default = \"Zoom out", Scope = Private, Description = 546F6F6C746970206F6620746865207A6F6F6D206F757420627574746F6E2E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"R\xC3\xA9duire"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Verkleinern"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"Riduci"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"Reducir"
	#tag EndConstant

	#tag Constant, Name = kWheelLinePixels, Type = Integer, Dynamic = False, Default = \"40", Scope = Private, Description = 506F696E7473207363726F6C6C65642070657220776865656C206C696E65207265706F7274656420627920586F6A6F2E0A
	#tag EndConstant

	#tag Constant, Name = kWheelZoomFactor, Type = Double, Dynamic = False, Default = \"1.1", Scope = Private, Description = 5A6F6F6D20666163746F722070657220776865656C206E6F746368207768696C6520436F6D6D616E64206F7220436F6E74726F6C2069732068656C642E0A
	#tag EndConstant

	#tag Constant, Name = kZoomButtonFactor, Type = Double, Dynamic = False, Default = \"1.25", Scope = Private, Description = 5A6F6F6D20666163746F72206F6620746865207A6F6F6D20627574746F6E7320616E64206B6579626F6172642073686F7274637574732E0A
	#tag EndConstant

	#tag Constant, Name = kZoomMaximum, Type = Double, Dynamic = False, Default = \"4", Scope = Private, Description = 48696768657374207A6F6F6D20666163746F722E0A
	#tag EndConstant

	#tag Constant, Name = kZoomMinimum, Type = Double, Dynamic = False, Default = \"0.25", Scope = Private, Description = 4C6F77657374207A6F6F6D20666163746F722E0A
	#tag EndConstant

	#tag Constant, Name = kZoomPercentFormat, Type = String, Dynamic = True, Default = \"<percent>%", Scope = Private, Description = 5A6F6F6D206C6576656C206C6162656C3B203C70657263656E743E206973207265706C6163656420627920746865207A6F6F6D2070657263656E746167652E0A
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"<percent>\xC2\xA0%"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"<percent>\xC2\xA0%"
		#Tag Instance, Platform = Any, Language = it, Definition  = \"<percent>%"
		#Tag Instance, Platform = Any, Language = es, Definition  = \"<percent>\xC2\xA0%"
	#tag EndConstant


#tag EndWindowCode

#tag Events lstThumbnails
	#tag Event
		Sub SelectionChanged()
		  // A click on a thumbnail scrolls the continuous view to that page.
		  // Selections made by the code while scrolling are ignored.
		  If mSyncingThumbnailSelection Then Return
		  If lstThumbnails.SelectedRowIndex >= 0 Then
		    NavigateToPage(lstThumbnails.SelectedRowIndex + 1)
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Function PaintCellText(g as Graphics, row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  // Thumbnail cell: page sheet centred with its page number below.
		  // Thumbnails are rendered lazily: a missing one is drawn as a blank sheet and
		  // queued for the render timer.
		  #Pragma Unused column
		  #Pragma Unused x
		  #Pragma Unused y
		  
		  If row < 0 Or row >= mTotalPages Or mPagePointWidths.Count < mTotalPages Then Return True
		  
		  Var pageNumber As Integer = row + 1
		  Var cellW As Integer = lstThumbnails.Width - kThumbnailScrollbarAllowance
		  Var cellH As Integer = lstThumbnails.DefaultRowHeight
		  Var availH As Integer = cellH - kThumbnailLabelHeight
		  
		  Var drawW As Double
		  Var drawH As Double
		  ThumbnailDrawSize(pageNumber, drawW, drawH)
		  Var drawX As Double = Round((cellW - drawW) / 2.0)
		  Var drawY As Double = Round((availH - drawH) / 2.0 + 2)
		  
		  // Drop shadow and blank sheet
		  g.DrawingColor = &cC0C0C0
		  g.FillRectangle(drawX + 2, drawY + 2, drawW, drawH)
		  g.DrawingColor = &cFFFFFF
		  g.FillRectangle(drawX, drawY, drawW, drawH)
		  
		  Var thumb As Picture
		  If mThumbnailCache <> Nil And mThumbnailCache.HasKey(pageNumber) Then
		    Var cachedValue As Variant = mThumbnailCache.Value(pageNumber)
		    If cachedValue IsA Picture Then thumb = Picture(cachedValue)
		  ElseIf mThumbnailRequests <> Nil Then
		    mThumbnailRequests.Value(pageNumber) = True
		    ScheduleRender(0)
		  End If
		  
		  If thumb <> Nil Then
		    g.DrawPicture(thumb, drawX, drawY, drawW, drawH, 0, 0, thumb.Width, thumb.Height)
		  End If
		  
		  // Border
		  g.DrawingColor = &cA0A0A0
		  g.DrawRectangle(drawX, drawY, drawW, drawH)
		  
		  // Page number below
		  g.DrawingColor = &c404040
		  g.FontSize = 9
		  g.Bold = False
		  Var pageText As String = Str(pageNumber)
		  g.DrawText(pageText, (cellW - g.TextWidth(pageText)) / 2, cellH - 6)
		  
		  Return True // We handled the painting
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events canvasPage
	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Same keys as the window when the canvas has the focus
		  Return HandlePreviewKey(key)
		End Function
	#tag EndEvent
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  // Begin drag panning when the document is larger than the view.
		  
		  If ContentOverflows() Then
		    StopScrollAnimation()
		    mIsPanning = True
		    mPanStartX = x
		    mPanStartY = y
		    mPanStartScrollX = mScrollX
		    mPanStartScrollY = mScrollY
		    Me.MouseCursor = System.Cursors.HandClosed
		  End If
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  // Pan the continuous view with the mouse.
		  
		  If mIsPanning Then
		    SetScrollPosition(mPanStartScrollX + (mPanStartX - x), mPanStartScrollY + (mPanStartY - y))
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  // End drag panning and restore cursor.
		  #Pragma Unused x
		  #Pragma Unused y
		  
		  If mIsPanning Then
		    mIsPanning = False
		    If ContentOverflows() Then
		      Me.MouseCursor = System.Cursors.HandOpen
		    Else
		      Me.MouseCursor = Nil
		    End If
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseWheel(x As Integer, y As Integer, deltaX As Integer, deltaY As Integer) As Boolean
		  // Smooth scrolling through the continuous document.
		  // Cmd/Ctrl + scroll = zoom around the cursor; Shift + scroll = horizontal.
		  // On macOS the precise trackpad deltas (with momentum) are used as is.
		  
		  Var scrollDX As Double
		  Var scrollDY As Double
		  Var isPrecise As Boolean
		  ReadWheelDeltas(deltaX, deltaY, scrollDX, scrollDY, isPrecise)
		  
		  If Keyboard.ControlKey Or Keyboard.CommandKey Then
		    Var factor As Double = 1.0
		    If isPrecise Then
		      factor = Pow(kPreciseZoomPerPixel, -scrollDY)
		    ElseIf scrollDY < 0 Then
		      factor = kWheelZoomFactor
		    ElseIf scrollDY > 0 Then
		      factor = 1.0 / kWheelZoomFactor
		    End If
		    If factor <> 1.0 Then ZoomBy(factor, x, y)
		    Return True
		  End If
		  
		  // Shift + vertical wheel scrolls horizontally (macOS already converts it)
		  If Keyboard.ShiftKey And scrollDX = 0 Then
		    scrollDX = scrollDY
		    scrollDY = 0
		  End If
		  
		  If scrollDX = 0 And scrollDY = 0 Then Return False
		  
		  ScrollByDelta(scrollDX, scrollDY)
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  // Draw the pages intersecting the view. Pages not rendered yet are drawn as
		  // white sheets and queued: the render timer fills them in one per tick.
		  #Pragma Unused areas
		  
		  // Background
		  g.DrawingColor = &cE0E0E0
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  If mRenderer = Nil Or mTotalPages = 0 Or mPageTops.Count = 0 Then
		    g.DrawingColor = &c808080
		    g.FontSize = 14
		    Var msg As String
		    If mTotalPages = 0 Then
		      msg = kNoPDFLoaded
		    Else
		      msg = kLoading
		    End If
		    g.DrawText(msg, (g.Width - g.TextWidth(msg)) / 2, g.Height / 2)
		    Return
		  End If
		  
		  Var firstIndex As Integer
		  Var lastIndex As Integer
		  VisiblePageRange(firstIndex, lastIndex)
		  For i As Integer = firstIndex To lastIndex
		    DrawPageSheet(g, i)
		  Next
		  
		  If NextPageToRender() > 0 Then ScheduleRender(0)
		  
		  // Hand cursor when the document can be dragged
		  If Not mIsPanning Then
		    If ContentOverflows() Then
		      Me.MouseCursor = System.Cursors.HandOpen
		    Else
		      Me.MouseCursor = Nil
		    End If
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events scrVertical
	#tag Event
		Sub ValueChanged()
		  // The user moved the vertical scrollbar
		  If mSyncingScrollbars Then Return
		  StopScrollAnimation()
		  mScrollY = scrVertical.Value
		  UpdateCurrentPageFromScroll()
		  ScheduleRender(0)
		  canvasPage.Refresh(False)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events scrHorizontal
	#tag Event
		Sub ValueChanged()
		  // The user moved the horizontal scrollbar
		  If mSyncingScrollbars Then Return
		  mScrollX = scrHorizontal.Value
		  canvasPage.Refresh(False)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnPrevPage
	#tag Event
		Sub Pressed()
		  If mCurrentPage > 1 Then
		    NavigateToPage(mCurrentPage - 1)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnNextPage
	#tag Event
		Sub Pressed()
		  If mCurrentPage < mTotalPages Then
		    NavigateToPage(mCurrentPage + 1)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnZoomOut
	#tag Event
		Sub Pressed()
		  // Zoom out, keeping the centre of the view in place
		  ZoomBy(1.0 / kZoomButtonFactor)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnZoomIn
	#tag Event
		Sub Pressed()
		  // Zoom in, keeping the centre of the view in place
		  ZoomBy(kZoomButtonFactor)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnZoomFit
	#tag Event
		Sub Pressed()
		  // Fit width: the widest page fills the width of the view
		  ZoomToFit()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnSave
	#tag Event
		Sub Pressed()
		  // Show save dialog
		  Dim dlg As New SaveFileDialog
		  dlg.Title = kSaveDialogTitle
		  dlg.SuggestedFileName = mSuggestedFilename
		  If mInitialSaveFolder <> Nil And mInitialSaveFolder.Exists Then
		    dlg.InitialFolder = mInitialSaveFolder
		  End If
		  
		  Dim targetFile As FolderItem = dlg.ShowModal()
		  
		  If targetFile <> Nil Then
		    // Ensure .pdf extension
		    If targetFile.Name.Right(4) <> ".pdf" Then
		      targetFile = targetFile.Parent.Child(targetFile.Name + ".pdf")
		    End If
		    
		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(targetFile, True)
		      stream.Write(mPDFData)
		      stream.Close()
		    Catch e As IOException
		      MessageBox(kErrorSavingFormat.ReplaceAll("<error>", e.Message))
		    End Try
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnPrint
	#tag Event
		Sub Pressed()
		  // Print the PDF using the native OS print dialog.
		  // Renders each PDF page as a bitmap and prints it via Xojo's printing API.
		  // This opens the standard system print dialog (macOS and Windows).
		  
		  If mPDFData = "" Or mRenderer = Nil Or mTotalPages = 0 Then
		    MessageBox(kNoPDFForPrinting)
		    Return
		  End If
		  
		  // Show the native print dialog
		  Dim ps As New PrinterSetup
		  Dim g As Graphics = ps.ShowPrinterDialog()
		  
		  If g = Nil Then
		    // User cancelled the print dialog
		    Return
		  End If
		  
		  // Determine the page range to print based on user selection.
		  // g.FirstPage and g.LastPage reflect the "From" and "To" fields
		  // of the print dialog. When "All" is selected, LastPage returns
		  // a very large value (2147483647 = max Int32).
		  Dim firstPage As Integer = g.FirstPage
		  Dim lastPage As Integer = g.LastPage
		  
		  // Handle "All pages" selection: clamp to actual document range
		  If firstPage < 1 Then firstPage = 1
		  If firstPage > mTotalPages Then firstPage = mTotalPages
		  If lastPage > mTotalPages Then lastPage = mTotalPages
		  If lastPage < firstPage Then lastPage = firstPage
		  
		  // Print only the selected page range
		  Dim isFirstPrintedPage As Boolean = True
		  For pageNum As Integer = firstPage To lastPage
		    // Add a new printer page for pages after the first printed page
		    If isFirstPrintedPage Then
		      isFirstPrintedPage = False
		    Else
		      g.NextPage()
		    End If
		    
		    // Get page dimensions in points
		    Dim pageW As Double = mRenderer.GetPageWidth(pageNum)
		    Dim pageH As Double = mRenderer.GetPageHeight(pageNum)
		    
		    If pageW <= 0 Then pageW = 595.28
		    If pageH <= 0 Then pageH = 841.89
		    
		    // Calculate the render size to fit the printable area
		    // g.Width and g.Height give the printable area in points
		    Dim scaleX As Double = g.Width / pageW
		    Dim scaleY As Double = g.Height / pageH
		    Dim scale As Double = Min(scaleX, scaleY)
		    
		    // Render at a resolution matching the print output
		    // Use 150 DPI minimum for good print quality
		    Dim renderW As Integer = CType(pageW * Max(scale, 150.0 / 72.0), Integer)
		    Dim renderH As Integer = CType(pageH * Max(scale, 150.0 / 72.0), Integer)
		    
		    If renderW < 1 Then renderW = 1
		    If renderH < 1 Then renderH = 1
		    
		    Dim pagePic As Picture = mRenderer.RenderPage(pageNum, renderW, renderH)
		    
		    If pagePic <> Nil Then
		      // Calculate centered position on the print page
		      Dim drawW As Integer = CType(pageW * scale, Integer)
		      Dim drawH As Integer = CType(pageH * scale, Integer)
		      Dim drawX As Integer = (g.Width - drawW) / 2
		      Dim drawY As Integer = (g.Height - drawH) / 2
		      
		      g.DrawPicture(pagePic, drawX, drawY, drawW, drawH, 0, 0, pagePic.Width, pagePic.Height)
		    End If
		  Next
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnClose
	#tag Event
		Sub Pressed()
		  Self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events tmrRender
	#tag Event
		Sub Action()
		  // Lazy rendering of pages and thumbnails, one small step per tick
		  DoPendingRenderWork()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events tmrScrollAnimation
	#tag Event
		Sub Action()
		  // One frame of the page-change scroll animation
		  AdvanceScrollAnimation()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="HasTitleBar"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="mPDFData"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="mSuggestedFilename"
		Visible=false
		Group="Behavior"
		InitialValue="document.pdf"
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
#tag EndViewBehavior
