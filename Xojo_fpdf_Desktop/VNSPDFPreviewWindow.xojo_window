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
   Title           =   "PDF Preview"
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
      Tooltip         =   "Click a page thumbnail to navigate"
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
      AllowLiveScrolling=   False
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
      AllowLiveScrolling=   False
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
      Tooltip         =   "Previous page"
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
      Width           =   100
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
      Left            =   350
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
      Tooltip         =   "Next page"
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
      Left            =   420
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
      Tooltip         =   "Zoom out"
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
      Left            =   455
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
      Text            =   "Fit"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   "Current zoom level"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   60
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
      Left            =   520
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
      Tooltip         =   "Zoom in"
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
      Caption         =   "Fit"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   555
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
      Tooltip         =   "Fit page to window"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   50
   End
   Begin DesktopButton btnSave
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Save..."
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   640
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
      Tooltip         =   "Save the PDF to a file"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopButton btnPrint
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Print..."
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   725
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
      Tooltip         =   "Print the PDF document"
      Top             =   700
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopButton btnClose
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   True
      Caption         =   "Close"
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
      Tooltip         =   "Close this window"
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
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Closing()
		  // Release the renderer to free native resources
		  mRenderer = Nil
		  mCurrentPagePicture = Nil
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Handle zoom keyboard shortcuts: Cmd/Ctrl + / - / 0
		  If Keyboard.CommandKey Or Keyboard.ControlKey Then
		    Select Case key
		    Case "+", "="
		      // Zoom in (= key produces + with Shift on most keyboards)
		      Dim currentZoom As Double = EffectiveZoom()
		      Dim newZoom As Double = currentZoom * 1.25
		      If newZoom > 4.0 Then newZoom = 4.0
		      ZoomToLevel(newZoom)
		      Return True
		    Case "-"
		      // Zoom out
		      Dim currentZoom2 As Double = EffectiveZoom()
		      Dim newZoom2 As Double = currentZoom2 / 1.25
		      If newZoom2 < 0.25 Then newZoom2 = 0.25
		      ZoomToLevel(newZoom2)
		      Return True
		    Case "0"
		      // Fit to page
		      mZoomLevel = 0.0
		      mScrollX = 0.0
		      mScrollY = 0.0
		      ApplyZoom()
		      Return True
		    End Select
		  End If
		  Return False
		End Function
	#tag EndEvent

	#tag Event
		Sub Resized()
		  // When the window is resized, re-render the current page at new dimensions
		  If mRenderer <> Nil And mCurrentPage > 0 And mCurrentPage <= mTotalPages Then
		    ApplyZoom()
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  // When the window is resized, re-render the current page at new dimensions
		  If mRenderer <> Nil And mCurrentPage > 0 And mCurrentPage <= mTotalPages Then
		    ApplyZoom()
		  End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub ApplyZoom()
		  // Re-render the current page at the current zoom level,
		  // update scrollbars, zoom label, and refresh the canvas.
		  
		  If mRenderer = Nil Or mCurrentPage < 1 Or mCurrentPage > mTotalPages Then Return
		  
		  Dim zoom As Double = EffectiveZoom()
		  Dim pageW As Double = mRenderer.GetPageWidth(mCurrentPage)
		  Dim pageH As Double = mRenderer.GetPageHeight(mCurrentPage)
		  
		  If pageW <= 0 Then pageW = 595.28
		  If pageH <= 0 Then pageH = 841.89
		  
		  // Compute pixel size of the zoomed page
		  Dim renderW As Integer = Max(1, CType(pageW * zoom, Integer))
		  Dim renderH As Integer = Max(1, CType(pageH * zoom, Integer))
		  
		  // Render the page at the zoomed size
		  mCurrentPagePicture = mRenderer.RenderPage(mCurrentPage, renderW, renderH)
		  
		  // Update scrollbar ranges
		  UpdateScrollbars()
		  
		  // Clamp scroll position
		  ClampScroll()
		  
		  // Update zoom label
		  UpdateZoomLabel()
		  
		  // Refresh canvas
		  canvasPage.Refresh()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CalculateFitZoom() As Double
		  // Calculate the zoom level that makes the current page fit entirely
		  // within the canvas viewport (with 10px margin on each side).
		  
		  If mRenderer = Nil Or mCurrentPage < 1 Then Return 1.0
		  
		  Dim pageW As Double = mRenderer.GetPageWidth(mCurrentPage)
		  Dim pageH As Double = mRenderer.GetPageHeight(mCurrentPage)
		  
		  If pageW <= 0 Then pageW = 595.28
		  If pageH <= 0 Then pageH = 841.89
		  
		  Dim cw As Integer = canvasPage.Width - 20
		  Dim ch As Integer = canvasPage.Height - 20
		  
		  If cw < 10 Then cw = 10
		  If ch < 10 Then ch = 10
		  
		  Dim scaleX As Double = cw / pageW
		  Dim scaleY As Double = ch / pageH
		  
		  Return Min(scaleX, scaleY)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClampScroll()
		  // Ensure scroll offsets stay within valid bounds.
		  
		  If mCurrentPagePicture = Nil Then
		    mScrollX = 0.0
		    mScrollY = 0.0
		    Return
		  End If
		  
		  Dim maxX As Double = Max(0, mCurrentPagePicture.Width - canvasPage.Width)
		  Dim maxY As Double = Max(0, mCurrentPagePicture.Height - canvasPage.Height)
		  
		  If mScrollX < 0 Then mScrollX = 0
		  If mScrollX > maxX Then mScrollX = maxX
		  If mScrollY < 0 Then mScrollY = 0
		  If mScrollY > maxY Then mScrollY = maxY
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EffectiveZoom() As Double
		  // Return the actual zoom factor to use for rendering.
		  // If mZoomLevel = 0.0, we're in "Fit" mode and calculate dynamically.
		  // Otherwise, use the fixed zoom level.
		  
		  If mZoomLevel <= 0.0 Then
		    Return CalculateFitZoom()
		  Else
		    Return mZoomLevel
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadPDF()
		  // Initialize the PDF renderer and populate the thumbnail list.
		  // Called by ShowPreview() AFTER mPDFData has been assigned.
		  
		  If mPDFData = "" Then Return
		  
		  // Update title
		  Self.Title = "PDF Preview - " + mSuggestedFilename
		  
		  // Update info label with file size
		  Dim sizeKB As Double = mPDFData.Bytes / 1024.0
		  If sizeKB < 1024 Then
		    lblInfo.Text = mSuggestedFilename + " (" + Format(sizeKB, "#,##0.0") + " KB)"
		  Else
		    lblInfo.Text = mSuggestedFilename + " (" + Format(sizeKB / 1024.0, "#,##0.0") + " MB)"
		  End If
		  
		  // Create the native PDF renderer
		  mRenderer = New VNSPDFPageRenderer(mPDFData)
		  mTotalPages = mRenderer.PageCount
		  
		  If mTotalPages = 0 Then
		    lblPageInfo.Text = "No pages"
		    Return
		  End If
		  
		  // Initialize zoom to Fit mode
		  mZoomLevel = 0.0
		  mScrollX = 0.0
		  mScrollY = 0.0
		  
		  // Populate thumbnail list
		  lstThumbnails.RemoveAllRows()
		  For i As Integer = 1 To mTotalPages
		    lstThumbnails.AddRow("")
		    // Render thumbnail and store in RowTag for PaintCellText to use
		    Dim thumb As Picture = mRenderer.RenderThumbnail(i, 100)
		    lstThumbnails.RowTagAt(lstThumbnails.LastAddedRowIndex) = thumb
		  Next
		  
		  // Navigate to first page
		  NavigateToPage(1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NavigateToPage(pageNumber As Integer)
		  // Navigate to the specified page: render it at the current zoom level,
		  // update the canvas, label, and thumbnail selection.
		  
		  If mRenderer = Nil Then Return
		  If pageNumber < 1 Or pageNumber > mTotalPages Then Return
		  
		  mCurrentPage = pageNumber
		  
		  // Reset scroll position for new page
		  mScrollX = 0.0
		  mScrollY = 0.0
		  
		  // Render at current zoom
		  ApplyZoom()
		  
		  // Update UI
		  UpdatePageLabel()
		  
		  // Select corresponding thumbnail row (avoid re-triggering SelectionChanged)
		  If lstThumbnails.SelectedRowIndex <> mCurrentPage - 1 Then
		    lstThumbnails.SelectedRowIndex = mCurrentPage - 1
		    // Scroll to make selected row visible
		    lstThumbnails.ScrollPosition = Max(0, mCurrentPage - 3)
		  End If
		  
		  // Enable/disable navigation buttons
		  btnPrevPage.Enabled = (mCurrentPage > 1)
		  btnNextPage.Enabled = (mCurrentPage < mTotalPages)
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

	#tag Method, Flags = &h21
		Private Sub UpdatePageLabel()
		  // Update the page indicator label.
		  
		  If mTotalPages > 0 Then
		    lblPageInfo.Text = "Page " + Str(mCurrentPage) + " / " + Str(mTotalPages)
		  Else
		    lblPageInfo.Text = ""
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateScrollbars()
		  // Configure scrollbar ranges based on zoomed content size vs. canvas viewport.
		  
		  If mCurrentPagePicture = Nil Then
		    scrHorizontal.Enabled = False
		    scrVertical.Enabled = False
		    Return
		  End If
		  
		  Dim contentW As Integer = mCurrentPagePicture.Width
		  Dim contentH As Integer = mCurrentPagePicture.Height
		  Dim viewW As Integer = canvasPage.Width
		  Dim viewH As Integer = canvasPage.Height
		  
		  // Horizontal scrollbar
		  If contentW > viewW Then
		    scrHorizontal.Enabled = True
		    scrHorizontal.MinimumValue = 0
		    scrHorizontal.MaximumValue = contentW - viewW
		    scrHorizontal.PageStep = viewW
		    scrHorizontal.Value = CType(mScrollX, Integer)
		  Else
		    scrHorizontal.Enabled = False
		    scrHorizontal.Value = 0
		    mScrollX = 0
		  End If
		  
		  // Vertical scrollbar
		  If contentH > viewH Then
		    scrVertical.Enabled = True
		    scrVertical.MinimumValue = 0
		    scrVertical.MaximumValue = contentH - viewH
		    scrVertical.PageStep = viewH
		    scrVertical.Value = CType(mScrollY, Integer)
		  Else
		    scrVertical.Enabled = False
		    scrVertical.Value = 0
		    mScrollY = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateZoomLabel()
		  // Display the current zoom percentage in the zoom label.
		  
		  Dim zoom As Double = EffectiveZoom()
		  Dim pct As Integer = CType(zoom * 100, Integer)
		  
		  If mZoomLevel <= 0.0 Then
		    lblZoomLevel.Text = Str(pct) + "%"
		  Else
		    lblZoomLevel.Text = Str(pct) + "%"
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ZoomToLevel(newZoom As Double, anchorX As Integer = -1, anchorY As Integer = -1)
		  // Set zoom level with optional anchor point for zoom-to-cursor behavior.
		  // anchorX/Y are canvas-local coordinates; if >= 0, the content under the
		  // cursor stays at the same screen position after zoom.
		  
		  // Clamp zoom range: 25% to 400%
		  If newZoom < 0.25 Then newZoom = 0.25
		  If newZoom > 4.0 Then newZoom = 4.0
		  
		  Dim oldZoom As Double = EffectiveZoom()
		  mZoomLevel = newZoom
		  
		  // If anchor is specified, adjust scroll to keep that point stationary
		  If anchorX >= 0 And anchorY >= 0 And oldZoom > 0 Then
		    // Point in content under the cursor before zoom
		    Dim contentX As Double = mScrollX + anchorX
		    Dim contentY As Double = mScrollY + anchorY
		    // Scale that point to the new zoom
		    Dim ratio As Double = newZoom / oldZoom
		    Dim newContentX As Double = contentX * ratio
		    Dim newContentY As Double = contentY * ratio
		    // New scroll so the same content point remains under the cursor
		    mScrollX = newContentX - anchorX
		    mScrollY = newContentY - anchorY
		  End If
		  
		  ApplyZoom()
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCurrentPage As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentPagePicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInitialSaveFolder As FolderItem = Nil
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsPanning As Boolean = False
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

	#tag Property, Flags = &h21
		Private mScrollX As Double = 0.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollY As Double = 0.0
	#tag EndProperty

	#tag Property, Flags = &h0
		mSuggestedFilename As String = "document.pdf"
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTotalPages As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mZoomLevel As Double = 0.0
	#tag EndProperty


#tag EndWindowCode

#tag Events lstThumbnails
	#tag Event
		Sub SelectionChanged()
		  // When user clicks a thumbnail, navigate to that page
		  If lstThumbnails.SelectedRowIndex >= 0 Then
		    Dim newPage As Integer = lstThumbnails.SelectedRowIndex + 1
		    If newPage <> mCurrentPage And newPage >= 1 And newPage <= mTotalPages Then
		      NavigateToPage(newPage)
		    End If
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Function PaintCellText(g as Graphics, row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  // Custom drawing for thumbnail cells: centered page image + page number below.
		  #Pragma Unused column
		  #Pragma Unused x
		  #Pragma Unused y
		  
		  Dim cellW As Integer = lstThumbnails.Width - 20  // account for scrollbar
		  Dim cellH As Integer = lstThumbnails.DefaultRowHeight
		  
		  // Get thumbnail from RowTag
		  Dim thumb As Picture
		  If row <= lstThumbnails.LastRowIndex And lstThumbnails.RowTagAt(row) IsA Picture Then
		    thumb = Picture(lstThumbnails.RowTagAt(row))
		  End If
		  
		  If thumb <> Nil Then
		    // Calculate centered position with room for page number
		    Dim availH As Integer = cellH - 22  // leave space for page number text
		    Dim scale As Double = Min(cellW / thumb.Width, availH / thumb.Height)
		    If scale > 1.0 Then scale = 1.0 // don't upscale
		    
		    Dim drawW As Integer = Max(1, CType(thumb.Width * scale, Integer))
		    Dim drawH As Integer = Max(1, CType(thumb.Height * scale, Integer))
		    Dim drawX As Integer = (cellW - drawW) / 2
		    Dim drawY As Integer = (availH - drawH) / 2 + 2
		    
		    // Draw drop shadow
		    g.DrawingColor = &cC0C0C0
		    g.FillRectangle(drawX + 2, drawY + 2, drawW, drawH)
		    
		    // Draw thumbnail
		    g.DrawPicture(thumb, drawX, drawY, drawW, drawH, 0, 0, thumb.Width, thumb.Height)
		    
		    // Draw border
		    g.DrawingColor = &cA0A0A0
		    g.DrawRectangle(drawX, drawY, drawW, drawH)
		    
		    // Draw page number below
		    g.DrawingColor = &c404040
		    g.FontSize = 9
		    g.Bold = False
		    Dim pageText As String = Str(row + 1)
		    g.DrawText(pageText, (cellW - g.TextWidth(pageText)) / 2, cellH - 6)
		  Else
		    // Placeholder when no thumbnail available
		    g.DrawingColor = &c808080
		    g.FontSize = 10
		    g.Bold = False
		    Dim txt As String = "Page " + Str(row + 1)
		    g.DrawText(txt, (cellW - g.TextWidth(txt)) / 2, cellH / 2)
		  End If
		  
		  Return True // We handled the painting
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events canvasPage
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  // Begin drag panning when content is larger than the canvas viewport.
		  
		  If mCurrentPagePicture <> Nil Then
		    If mCurrentPagePicture.Width > canvasPage.Width Or mCurrentPagePicture.Height > canvasPage.Height Then
		      mIsPanning = True
		      mPanStartX = x
		      mPanStartY = y
		      mPanStartScrollX = mScrollX
		      mPanStartScrollY = mScrollY
		      Me.MouseCursor = System.Cursors.HandClosed
		    End If
		  End If
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  // Update scroll position during drag panning.
		  
		  If mIsPanning Then
		    Dim dx As Integer = mPanStartX - x
		    Dim dy As Integer = mPanStartY - y
		    mScrollX = mPanStartScrollX + dx
		    mScrollY = mPanStartScrollY + dy
		    ClampScroll()
		    UpdateScrollbars()
		    canvasPage.Refresh()
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
		    // Restore cursor based on whether content overflows
		    If mCurrentPagePicture <> Nil And (mCurrentPagePicture.Width > canvasPage.Width Or mCurrentPagePicture.Height > canvasPage.Height) Then
		      Me.MouseCursor = System.Cursors.HandOpen
		    Else
		      Me.MouseCursor = Nil
		    End If
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseWheel(x As Integer, y As Integer, deltaX As Integer, deltaY As Integer) As Boolean
		  // Handle mouse wheel for zoom and scrolling.
		  // Ctrl/Cmd + scroll = zoom in/out centered on cursor position.
		  // Plain scroll = vertical panning.
		  // Shift + scroll = horizontal panning.
		  #Pragma Unused y
		  
		  // Check for zoom gesture (Ctrl on Windows, Cmd on macOS)
		  If Keyboard.ControlKey Or Keyboard.CommandKey Then
		    Dim currentZoom As Double = EffectiveZoom()
		    Dim factor As Double = 1.0
		    
		    If deltaY < 0 Then
		      factor = 1.1  // Zoom in ~10% per tick
		    ElseIf deltaY > 0 Then
		      factor = 1.0 / 1.1  // Zoom out ~10% per tick
		    End If
		    
		    If factor <> 1.0 Then
		      Dim newZoom As Double = currentZoom * factor
		      ZoomToLevel(newZoom, x, y)
		    End If
		    Return True
		  End If
		  
		  // Shift + scroll = horizontal panning
		  If Keyboard.ShiftKey And deltaY <> 0 Then
		    mScrollX = mScrollX + (deltaY * 40)
		    ClampScroll()
		    UpdateScrollbars()
		    canvasPage.Refresh()
		    Return True
		  End If
		  
		  // Plain scroll = vertical panning
		  If deltaY <> 0 Then
		    mScrollY = mScrollY + (deltaY * 40)
		    ClampScroll()
		    UpdateScrollbars()
		    canvasPage.Refresh()
		    Return True
		  End If
		  
		  // Horizontal scroll (e.g. from trackpad)
		  If deltaX <> 0 Then
		    mScrollX = mScrollX + (deltaX * 40)
		    ClampScroll()
		    UpdateScrollbars()
		    canvasPage.Refresh()
		    Return True
		  End If
		  
		  Return False
		End Function
	#tag EndEvent
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  // Draw the current page in the canvas.
		  // When zoomed to fit or smaller: center the page with shadow and border.
		  // When zoomed larger than the canvas: show the visible portion based on scroll offsets.
		  #Pragma Unused areas
		  
		  // Background
		  g.DrawingColor = &cE0E0E0
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  If mCurrentPagePicture = Nil Then
		    // Loading placeholder
		    g.DrawingColor = &c808080
		    g.FontSize = 14
		    Dim msg As String
		    If mTotalPages = 0 Then
		      msg = "No PDF loaded"
		    Else
		      msg = "Loading..."
		    End If
		    g.DrawText(msg, (g.Width - g.TextWidth(msg)) / 2, g.Height / 2)
		    Return
		  End If
		  
		  Dim picW As Integer = mCurrentPagePicture.Width
		  Dim picH As Integer = mCurrentPagePicture.Height
		  
		  // Determine draw position and source clipping
		  Dim drawX As Integer = 0
		  Dim drawY As Integer = 0
		  Dim srcX As Integer = 0
		  Dim srcY As Integer = 0
		  Dim drawW As Integer = picW
		  Dim drawH As Integer = picH
		  
		  Dim fitsH As Boolean = (picW <= g.Width)
		  Dim fitsV As Boolean = (picH <= g.Height)
		  
		  If fitsH Then
		    // Center horizontally
		    drawX = (g.Width - picW) / 2
		    drawW = picW
		  Else
		    // Clip using horizontal scroll offset
		    srcX = CType(mScrollX, Integer)
		    If srcX < 0 Then srcX = 0
		    If srcX > picW - g.Width Then srcX = picW - g.Width
		    drawW = Min(picW - srcX, g.Width)
		    drawX = 0
		  End If
		  
		  If fitsV Then
		    // Center vertically
		    drawY = (g.Height - picH) / 2
		    drawH = picH
		  Else
		    // Clip using vertical scroll offset
		    srcY = CType(mScrollY, Integer)
		    If srcY < 0 Then srcY = 0
		    If srcY > picH - g.Height Then srcY = picH - g.Height
		    drawH = Min(picH - srcY, g.Height)
		    drawY = 0
		  End If
		  
		  // Draw drop shadow (only when page fits in canvas)
		  If fitsH And fitsV Then
		    g.DrawingColor = &cB0B0B0
		    g.FillRectangle(drawX + 4, drawY + 4, drawW, drawH)
		  End If
		  
		  // Draw the visible portion of the page
		  g.DrawPicture(mCurrentPagePicture, drawX, drawY, drawW, drawH, srcX, srcY, drawW, drawH)
		  
		  // Draw page border
		  g.DrawingColor = &c909090
		  If fitsH And fitsV Then
		    g.DrawRectangle(drawX, drawY, drawW, drawH)
		  Else
		    // Draw border around the visible area
		    g.DrawRectangle(drawX, drawY, drawW, drawH)
		  End If
		  
		  // Update cursor based on whether content overflows
		  If Not mIsPanning Then
		    If Not fitsH Or Not fitsV Then
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
		  // Synchronize vertical scroll position with scrollbar value
		  mScrollY = scrVertical.Value
		  canvasPage.Refresh()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events scrHorizontal
	#tag Event
		Sub ValueChanged()
		  // Synchronize horizontal scroll position with scrollbar value
		  mScrollX = scrHorizontal.Value
		  canvasPage.Refresh()
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
		  // Zoom out by factor 1.25x
		  Dim currentZoom As Double = EffectiveZoom()
		  Dim newZoom As Double = currentZoom / 1.25
		  If newZoom < 0.25 Then newZoom = 0.25
		  ZoomToLevel(newZoom)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnZoomIn
	#tag Event
		Sub Pressed()
		  // Zoom in by factor 1.25x
		  Dim currentZoom As Double = EffectiveZoom()
		  Dim newZoom As Double = currentZoom * 1.25
		  If newZoom > 4.0 Then newZoom = 4.0
		  ZoomToLevel(newZoom)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnZoomFit
	#tag Event
		Sub Pressed()
		  // Reset to Fit mode: page fits entirely in the canvas
		  mZoomLevel = 0.0
		  mScrollX = 0.0
		  mScrollY = 0.0
		  ApplyZoom()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnSave
	#tag Event
		Sub Pressed()
		  // Show save dialog
		  Dim dlg As New SaveFileDialog
		  dlg.Title = "Save PDF"
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
		      MessageBox("Error saving PDF: " + e.Message)
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
		    MessageBox("No PDF available for printing.")
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
