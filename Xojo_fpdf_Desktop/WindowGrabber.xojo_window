#tag DesktopWindow
Begin DesktopWindow WindowGrabber
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   672
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "Grabber Browser"
   Type            =   0
   Visible         =   True
   Width           =   908
   Begin DesktopHTMLViewer MainHTMLViewer
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   430
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Renderer        =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   70
      Visible         =   True
      Width           =   908
   End
   Begin DesktopButton BtnBack
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "<"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   8
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   9
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   30
   End
   Begin DesktopButton BtnForward
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   ">"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   9
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   30
   End
   Begin DesktopTextField TFUrl
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   22
      Hint            =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   82
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   9
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   True
      Width           =   744
   End
   Begin DesktopButton BtnGo
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Go"
      Default         =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   838
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   9
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   50
   End
   Begin DesktopButton BtnScrapePDF
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Scrape to PDF"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   512
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   178
   End
   Begin DesktopTextArea TxtProgress
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   128
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   544
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   908
   End
   Begin Timer ContentTimer
      Enabled         =   False
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   3000
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin DesktopProgressBar PBGeneratepdf
      Active          =   False
      AllowAutoDeactivate=   True
      AllowTabStop    =   True
      Enabled         =   True
      Height          =   20
      Indeterminate   =   False
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   190
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      MaximumValue    =   100
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      Tooltip         =   ""
      Top             =   512
      Transparent     =   False
      Value           =   50.0
      Visible         =   True
      Width           =   698
      _mIndex         =   0
      _mInitialParent =   ""
      _mName          =   ""
      _mPanelIndex    =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  // Initialize with Apple GSX service manual site
		  TFUrl.Text = "https://gsx2.apple.com/"
		  UpdateNavigationButtons()
		  
		  // Initialize scraping properties
		  mTOCEntries = New Dictionary
		  mContentData = New Dictionary
		  mCurrentIndex = 0
		  mIsProcessing = False
		  mWaitingForContent = False
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AddImageToPDF(pdf As VNSPDFDocument, imageURL As String)
		  // Download image and add it to PDF
		  Try
		    // Use JavaScript to fetch image as base64
		    Dim js As String = _
		    "(async function() {" + _
		    "  try {" + _
		    "    const response = await fetch('" + imageURL + "');" + _
		    "    const blob = await response.blob();" + _
		    "    return new Promise((resolve) => {" + _
		    "      const reader = new FileReader();" + _
		    "      reader.onloadend = () => resolve(reader.result);" + _
		    "      reader.readAsDataURL(blob);" + _
		    "    });" + _
		    "  } catch(e) {" + _
		    "    return '';" + _
		    "  }" + _
		    "})();"
		    
		    Dim base64Data As String = MainHTMLViewer.ExecuteJavaScriptSync(js)
		    
		    If base64Data <> "" And base64Data.IndexOf("base64,") > 0 Then
		      // Extract base64 data (remove data:image/png;base64, prefix)
		      Dim prefixPos As Integer = base64Data.IndexOf("base64,")
		      Dim actualBase64 As String = base64Data.Middle(prefixPos + 7)
		      
		      // Decode base64
		      Dim imageData As MemoryBlock = DecodeBase64Data(actualBase64)
		      
		      If imageData <> Nil And imageData.Size > 0 Then
		        // Create a Picture from the data
		        Dim pic As Picture = Picture.FromData(imageData)
		        
		        If pic <> Nil Then
		          // Calculate dimensions to fit on page (max width 180mm)
		          Dim maxWidth As Double = 180
		          Dim imgWidth As Double = pic.Width * 0.264583 // Convert pixels to mm (96 DPI)
		          Dim imgHeight As Double = pic.Height * 0.264583
		          
		          If imgWidth > maxWidth Then
		            Dim scale As Double = maxWidth / imgWidth
		            imgWidth = maxWidth
		            imgHeight = imgHeight * scale
		          End If
		          
		          // Add image to PDF
		          pdf.ImageFromPicture(pic, pdf.GetX, pdf.GetY, imgWidth, imgHeight)
		          pdf.Ln(imgHeight + 5)
		          
		          System.DebugLog("AddImageToPDF: Added image " + imageURL)
		        End If
		      End If
		    End If
		    
		  Catch err As RuntimeException
		    System.DebugLog("AddImageToPDF: Error downloading " + imageURL + " - " + err.Message)
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddLogMessage(msg As String)
		  // Add message to progress log
		  TxtProgress.Text = TxtProgress.Text + msg + EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeBase64Data(base64String As String) As MemoryBlock
		  // Decode base64 string to MemoryBlock
		  Try
		    Dim cleaned As String = base64String.ReplaceAll(EndOfLine, "")
		    cleaned = cleaned.ReplaceAll(" ", "")
		    cleaned = cleaned.ReplaceAll(Chr(13), "")
		    cleaned = cleaned.ReplaceAll(Chr(10), "")
		    
		    // Use Xojo's built-in DecodeBase64 function
		    Return DecodeBase64(cleaned)
		    
		  Catch err As RuntimeException
		    System.DebugLog("DecodeBase64Data: Error - " + err.Message)
		    Return Nil
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ExtractTOCStructure()
		  // First extract the document title
		  Dim titleJS As String = _
		  "(function() {" + _
		  "  var titleElem = document.querySelector('.hierarchy_title');" + _
		  "  return titleElem ? titleElem.textContent.trim() : '';" + _
		  "})();"
		  
		  Dim docTitle As String = MainHTMLViewer.ExecuteJavaScriptSync(titleJS)
		  If docTitle <> "" Then
		    mManualTitle = docTitle
		    
		    // Remove everything after the last dash
		    Dim lastDashPos As Integer = FindLastIndexOf(mManualTitle, " - ")
		    If lastDashPos >= 0 Then
		      mManualTitle = mManualTitle.Left(lastDashPos).Trim
		    End If
		    
		    // Clean up filename - remove invalid characters
		    mManualTitle = mManualTitle.ReplaceAll("/", "-")
		    mManualTitle = mManualTitle.ReplaceAll(":", "-")
		    mManualTitle = mManualTitle.ReplaceAll("\", "-")
		    mManualTitle = mManualTitle.ReplaceAll("?", "-")
		    mManualTitle = mManualTitle.ReplaceAll("*", "-")
		    mManualTitle = mManualTitle.ReplaceAll("""", "-")
		    mManualTitle = mManualTitle.ReplaceAll("<", "-")
		    mManualTitle = mManualTitle.ReplaceAll(">", "-")
		    mManualTitle = mManualTitle.ReplaceAll("|", "-")
		    AddLogMessage("Document title: " + mManualTitle)
		  End If
		  
		  // Check if we can find the TOC container
		  Dim checkJS As String = _
		  "(function() {" + _
		  "  var tocContainer = document.querySelector('.service-guide__tree');" + _
		  "  var treeNodes = document.querySelectorAll('.el-tree-node');" + _
		  "  return JSON.stringify({" + _
		  "    hasTocContainer: tocContainer !== null," + _
		  "    nodeCount: treeNodes.length," + _
		  "    url: window.location.href" + _
		  "  });" + _
		  "})();"
		  
		  Dim checkResult As String = MainHTMLViewer.ExecuteJavaScriptSync(checkJS)
		  AddLogMessage("Page check: " + checkResult)
		  
		  // First, expand all collapsed TOC nodes to reveal the full tree
		  AddLogMessage("Expanding all TOC nodes...")
		  
		  // Debug: Check what expand icons exist and their classes
		  Dim debugJS As String = _
		  "(function() {" + _
		  "  var expandIcons = document.querySelectorAll('.el-tree-node__expand-icon');" + _
		  "  var info = [];" + _
		  "  for (var i = 0; i < expandIcons.length; i++) {" + _
		  "    var icon = expandIcons[i];" + _
		  "    info.push({" + _
		  "      index: i," + _
		  "      classes: icon.className," + _
		  "      isLeaf: icon.classList.contains('is-leaf')" + _
		  "    });" + _
		  "  }" + _
		  "  return JSON.stringify({totalIcons: expandIcons.length, icons: info});" + _
		  "})();"
		  
		  Dim debugResult As String = MainHTMLViewer.ExecuteJavaScriptSync(debugJS)
		  AddLogMessage("Expand icons found: " + debugResult)
		  
		  // Click all expand icons that don't have 'is-leaf' class
		  Dim expandJS As String = _
		  "(function() {" + _
		  "  var expandIcons = document.querySelectorAll('.el-tree-node__expand-icon');" + _
		  "  var clickedCount = 0;" + _
		  "  for (var i = 0; i < expandIcons.length; i++) {" + _
		  "    var icon = expandIcons[i];" + _
		  "    if (!icon.classList.contains('is-leaf')) {" + _
		  "      icon.click();" + _
		  "      clickedCount++;" + _
		  "    }" + _
		  "  }" + _
		  "  return clickedCount;" + _
		  "})();"
		  
		  Dim clickedCount As String = MainHTMLViewer.ExecuteJavaScriptSync(expandJS)
		  AddLogMessage("Clicked " + clickedCount + " expand icons")
		  
		  // Wait a moment for expansion animations to complete
		  Dim startTime As Double = System.Microseconds
		  While (System.Microseconds - startTime) < 1000000 // 1 second (increased from 500ms)
		    App.DoEvents()
		  Wend
		  
		  // Check how many nodes we have after expansion
		  Dim checkAfterJS As String = _
		  "(function() {" + _
		  "  var treeNodes = document.querySelectorAll('.el-tree-node');" + _
		  "  return treeNodes.length;" + _
		  "})();"
		  
		  Dim nodeCountAfter As String = MainHTMLViewer.ExecuteJavaScriptSync(checkAfterJS)
		  AddLogMessage("TOC nodes after expansion: " + nodeCountAfter)
		  
		  // Test simple JavaScript execution
		  Dim testJS As String = _
		  "(function() {" + _
		  "  var nodes = document.querySelectorAll('.el-tree-node');" + _
		  "  return 'Found ' + nodes.length + ' nodes';" + _
		  "})();"
		  
		  Dim testResult As String = MainHTMLViewer.ExecuteJavaScriptSync(testJS)
		  AddLogMessage("Simple test result: " + testResult)
		  
		  // Test JSON.stringify with a simple object
		  Dim jsonTestJS As String = _
		  "(function() {" + _
		  "  return JSON.stringify({test: 'hello', count: 42});" + _
		  "})();"
		  
		  Dim jsonTestResult As String = MainHTMLViewer.ExecuteJavaScriptSync(jsonTestJS)
		  AddLogMessage("JSON test result: " + jsonTestResult)
		  
		  // Extract TOC structure using JavaScript - with hierarchy levels
		  Dim js As String = _
		  "JSON.stringify((function() {" + _
		  "  var result = [];" + _
		  "  var nodes = document.querySelectorAll('.el-tree-node');" + _
		  "  for (var i = 0; i < nodes.length; i++) {" + _
		  "    var label = nodes[i].querySelector('.el-tree-node__label');" + _
		  "    if (label) {" + _
		  "      var expandIcon = nodes[i].querySelector('.el-tree-node__expand-icon');" + _
		  "      var level = 0;" + _
		  "      var parent = nodes[i].parentElement;" + _
		  "      while (parent && level < 10) {" + _
		  "        if (parent.classList && parent.classList.contains('el-tree-node')) { level++; }" + _
		  "        parent = parent.parentElement;" + _
		  "      }" + _
		  "      result.push({" + _
		  "        index: i," + _
		  "        dataKey: nodes[i].getAttribute('data-key') || '0'," + _
		  "        title: label.textContent || ''," + _
		  "        isLeaf: !expandIcon || expandIcon.classList.contains('is-leaf')," + _
		  "        level: level" + _
		  "      });" + _
		  "    }" + _
		  "  }" + _
		  "  return result;" + _
		  "})());"
		  
		  Dim jsonResult As String = MainHTMLViewer.ExecuteJavaScriptSync(js)
		  AddLogMessage("TOC extraction result length: " + Str(jsonResult.Length))
		  
		  If jsonResult.Length > 100 Then
		    AddLogMessage("First 100 chars: " + jsonResult.Left(100))
		  Else
		    AddLogMessage("Full result: " + jsonResult)
		  End If
		  
		  If jsonResult <> "" And jsonResult <> "[]" Then
		    ParseTOCStructure(jsonResult)
		  Else
		    AddLogMessage("Error: No TOC entries found (empty or [] returned).")
		    AddLogMessage("Make sure you navigate to a service manual page with a visible TOC tree first.")
		    mIsProcessing = False
		    BtnScrapePDF.Enabled = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindLastIndexOf(sourceString As String, searchString As String) As Integer
		  // Find the last occurrence of searchString in sourceString
		  // Returns -1 if not found
		  
		  Dim lastPos As Integer = -1
		  Dim currentPos As Integer = 0
		  
		  While True
		    currentPos = sourceString.IndexOf(currentPos, searchString)
		    If currentPos < 0 Then
		      Exit While
		    End If
		    lastPos = currentPos
		    currentPos = currentPos + 1
		  Wend
		  
		  Return lastPos
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GeneratePDF()
		  // Generate PDF from collected content
		  AddLogMessage("Generating PDF with wkhtmltopdf...")
		  
		  // Show and initialize progress bar
		  PBGeneratepdf.Visible = True
		  PBGeneratepdf.MaximumValue = mTOCKeys.LastIndex + 1
		  PBGeneratepdf.Value = 0
		  
		  // Build complete HTML document with all sections
		  Dim htmlDoc As String = "<!DOCTYPE html>" + EndOfLine
		  htmlDoc = htmlDoc + "<html lang=""fr"">" + EndOfLine
		  htmlDoc = htmlDoc + "<head>" + EndOfLine
		  htmlDoc = htmlDoc + "<meta charset=""UTF-8"">" + EndOfLine
		  htmlDoc = htmlDoc + "<title>" + mManualTitle + "</title>" + EndOfLine
		  htmlDoc = htmlDoc + "<style>" + EndOfLine
		  htmlDoc = htmlDoc + "body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }" + EndOfLine
		  htmlDoc = htmlDoc + "h1 { color: #333; border-bottom: 2px solid #0066cc; padding-bottom: 10px; page-break-before: always; font-size: 24px; }" + EndOfLine
		  htmlDoc = htmlDoc + "h1:first-of-type { page-break-before: avoid; }" + EndOfLine
		  htmlDoc = htmlDoc + "h2 { color: #444; border-bottom: 1px solid #0066cc; padding-bottom: 8px; margin-top: 20px; font-size: 20px; }" + EndOfLine
		  htmlDoc = htmlDoc + "h3 { color: #555; margin-top: 18px; font-size: 18px; }" + EndOfLine
		  htmlDoc = htmlDoc + "h4 { color: #666; margin-top: 16px; font-size: 16px; }" + EndOfLine
		  htmlDoc = htmlDoc + "h5 { color: #777; margin-top: 14px; font-size: 14px; }" + EndOfLine
		  htmlDoc = htmlDoc + "h6 { color: #888; margin-top: 12px; font-size: 13px; }" + EndOfLine
		  htmlDoc = htmlDoc + ".section-header { font-style: italic; color: #666; margin: 20px 0; }" + EndOfLine
		  htmlDoc = htmlDoc + "img { max-width: 100%; height: auto; display: block; margin: 10px 0; }" + EndOfLine
		  htmlDoc = htmlDoc + "table { border-collapse: collapse; width: 100%; margin: 10px 0; }" + EndOfLine
		  htmlDoc = htmlDoc + "th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }" + EndOfLine
		  htmlDoc = htmlDoc + "th { background-color: #f2f2f2; }" + EndOfLine
		  htmlDoc = htmlDoc + "</style>" + EndOfLine
		  htmlDoc = htmlDoc + "</head>" + EndOfLine
		  htmlDoc = htmlDoc + "<body>" + EndOfLine
		  htmlDoc = htmlDoc + "<h1 style=""page-break-before: avoid;"">" + mManualTitle + "</h1>" + EndOfLine
		  
		  // Add each section
		  For i As Integer = 0 To mTOCKeys.LastIndex
		    Dim key As String = mTOCKeys(i)
		    Dim entry As Dictionary = mTOCEntries.Value(key)
		    Dim isLeaf As Boolean = entry.Value("isLeaf")
		    
		    // Update progress bar
		    PBGeneratepdf.Value = i + 1
		    Dim title As String = entry.Value("title")
		    Dim level As Integer = entry.Value("level")
		    AddLogMessage("Adding section " + Str(i + 1) + "/" + Str(mTOCKeys.LastIndex + 1) + ": " + title)
		    App.DoEvents() // Keep UI responsive
		    
		    // Determine heading level (h1-h6, default to h1 if level > 6)
		    Dim headingLevel As Integer = Min(Max(level + 1, 1), 6)
		    Dim headingTag As String = "h" + Str(headingLevel)
		    
		    // Add content only for leaf nodes
		    If isLeaf Then
		      If mContentData.HasKey(key) Then
		        Dim jsonData As String = mContentData.Value(key)
		        
		        Try
		          // Parse JSON content
		          Dim json As New JSONItem(jsonData)
		          Dim htmlContent As String = json.Value("html")
		          
		          // Add HTML content with a heading for TOC navigation
		          // Add heading for bookmark/outline even if content has its own
		          htmlDoc = htmlDoc + "<div class=""section"">" + EndOfLine
		          htmlDoc = htmlDoc + "<" + headingTag + ">" + title + "</" + headingTag + ">" + EndOfLine
		          htmlDoc = htmlDoc + htmlContent + EndOfLine
		          htmlDoc = htmlDoc + "</div>" + EndOfLine
		          
		        Catch err As RuntimeException
		          htmlDoc = htmlDoc + "<div class=""section"">" + EndOfLine
		          htmlDoc = htmlDoc + "<" + headingTag + ">" + title + "</" + headingTag + ">" + EndOfLine
		          htmlDoc = htmlDoc + "<p><em>Error parsing content</em></p>" + EndOfLine
		          htmlDoc = htmlDoc + "</div>" + EndOfLine
		        End Try
		      Else
		        htmlDoc = htmlDoc + "<div class=""section"">" + EndOfLine
		        htmlDoc = htmlDoc + "<" + headingTag + ">" + title + "</" + headingTag + ">" + EndOfLine
		        htmlDoc = htmlDoc + "<p class=""section-header"">(No content available)</p>" + EndOfLine
		        htmlDoc = htmlDoc + "</div>" + EndOfLine
		      End If
		    Else
		      // Parent node - add header since no content
		      htmlDoc = htmlDoc + "<div class=""section"">" + EndOfLine
		      htmlDoc = htmlDoc + "<" + headingTag + ">" + title + "</" + headingTag + ">" + EndOfLine
		      htmlDoc = htmlDoc + "<p class=""section-header"">(Section)</p>" + EndOfLine
		      htmlDoc = htmlDoc + "</div>" + EndOfLine
		    End If
		  Next
		  
		  // Close HTML document
		  htmlDoc = htmlDoc + "</body>" + EndOfLine
		  htmlDoc = htmlDoc + "</html>" + EndOfLine
		  
		  // Save HTML to temp file
		  Dim tempFolder As FolderItem = SpecialFolder.Temporary
		  Dim htmlFile As FolderItem = tempFolder.Child("service_manual_" + Str(System.Microseconds) + ".html")
		  
		  Try
		    Dim tos As TextOutputStream = TextOutputStream.Create(htmlFile)
		    tos.Encoding = Encodings.UTF8
		    tos.Write(htmlDoc)
		    tos.Close
		    
		    AddLogMessage("HTML saved, converting to PDF...")
		    App.DoEvents()
		    
		    // Use wkhtmltopdf to convert HTML to PDF
		    Dim desktop As FolderItem = SpecialFolder.Desktop
		    Dim pdfFile As FolderItem = desktop.Child(mManualTitle + ".pdf")
		    
		    Dim cmd As String = "/usr/local/bin/wkhtmltopdf --enable-local-file-access --print-media-type --outline --outline-depth 6 """ + htmlFile.NativePath + """ """ + pdfFile.NativePath + """"
		    
		    Dim shell As New Shell
		    shell.Execute(cmd)
		    
		    Dim output As String = shell.ReadAll
		    Dim exitCode As Integer = shell.ExitCode
		    
		    If exitCode = 0 Then
		      AddLogMessage("PDF saved to: " + pdfFile.NativePath)
		      AddLogMessage("Scraping complete!")
		      
		      // Clean up temp HTML file
		      If htmlFile.Exists Then
		        htmlFile.Remove
		      End If
		    Else
		      AddLogMessage("Error converting to PDF (exit code: " + Str(exitCode) + ")")
		      If output <> "" Then
		        AddLogMessage("Output: " + output)
		      End If
		    End If
		    
		  Catch err As IOException
		    AddLogMessage("Error: " + err.Message)
		  End Try
		  
		  mIsProcessing = False
		  BtnScrapePDF.Enabled = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadURL(url As String)
		  // Load a URL in the HTML viewer
		  // Add https:// prefix if no protocol specified
		  
		  Dim finalURL As String = url.Trim
		  
		  If finalURL = "" Then
		    Return
		  End If
		  
		  // Check if URL has a protocol
		  If finalURL.IndexOf("://") < 0 And Not finalURL.BeginsWith("about:") Then
		    finalURL = "https://" + finalURL
		  End If
		  
		  // Load the URL
		  MainHTMLViewer.LoadURL(finalURL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseTOCStructure(jsonData As String)
		  // Parse TOC structure from JSON
		  Try
		    System.DebugLog("ParseTOCStructure: Parsing JSON with length = " + Str(jsonData.Length))
		    Dim json As New JSONItem(jsonData)
		    System.DebugLog("ParseTOCStructure: JSON array count = " + Str(json.Count))
		    
		    ReDim mTOCKeys(-1)
		    mTOCEntries.RemoveAll
		    mContentData.RemoveAll
		    
		    For i As Integer = 0 To json.Count - 1
		      Dim entry As JSONItem = json.ChildAt(i)
		      Dim dataKey As String = entry.Value("dataKey")
		      Dim title As String = entry.Value("title")
		      Dim index As Integer = entry.Value("index")
		      Dim isLeaf As Boolean = entry.Value("isLeaf")
		      Dim level As Integer = entry.Value("level")
		      
		      System.DebugLog("ParseTOCStructure: Entry " + Str(i) + ": dataKey=" + dataKey + ", title=" + title + ", isLeaf=" + Str(isLeaf) + ", level=" + Str(level))
		      
		      // Skip entries with empty titles
		      If title = "" Or title.Trim = "" Then
		        System.DebugLog("ParseTOCStructure: Skipping entry with empty title")
		        Continue
		      End If
		      
		      // Create entry dictionary
		      Dim entryDict As New Dictionary
		      entryDict.Value("dataKey") = dataKey
		      entryDict.Value("title") = title.Trim
		      entryDict.Value("level") = level
		      entryDict.Value("index") = index
		      entryDict.Value("isLeaf") = isLeaf
		      
		      // Use index as unique key (dataKey may be "0" for parent nodes)
		      Dim uniqueKey As String = Str(index)
		      mTOCEntries.Value(uniqueKey) = entryDict
		      mTOCKeys.Add(uniqueKey)
		      System.DebugLog("ParseTOCStructure: Added entry with key: " + uniqueKey)
		    Next
		    
		    System.DebugLog("ParseTOCStructure: Total entries added = " + Str(mTOCKeys.LastIndex + 1))
		    AddLogMessage("Found " + Str(mTOCKeys.LastIndex + 1) + " TOC entries")
		    
		    // Start processing entries
		    mCurrentIndex = -1
		    ProcessNextTOCEntry()
		    
		  Catch err As RuntimeException
		    System.DebugLog("ParseTOCStructure: Error - " + err.Message)
		    AddLogMessage("Error parsing TOC: " + err.Message)
		    mIsProcessing = False
		    BtnScrapePDF.Enabled = True
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessNextTOCEntry()
		  // Process next TOC entry (limit to first 5 for testing)
		  Const kMaxEntries As Integer = 5
		  
		  If mCurrentIndex >= mTOCKeys.LastIndex Or mCurrentIndex >= (kMaxEntries - 1) Then
		    // All entries processed (or reached limit), generate PDF
		    System.DebugLog("ProcessNextTOCEntry: Processed " + Str(mCurrentIndex + 1) + " entries, generating PDF")
		    GeneratePDF()
		    Return
		  End If
		  
		  mCurrentIndex = mCurrentIndex + 1
		  Dim key As String = mTOCKeys(mCurrentIndex)
		  Dim entry As Dictionary = mTOCEntries.Value(key)
		  Dim title As String = entry.Value("title")
		  Dim index As Integer = entry.Value("index")
		  
		  System.DebugLog("ProcessNextTOCEntry: Processing entry " + Str(mCurrentIndex + 1) + "/" + Str(mTOCKeys.LastIndex + 1) + ": " + title)
		  AddLogMessage("Processing: " + title + " (" + Str(mCurrentIndex + 1) + "/" + Str(mTOCKeys.LastIndex + 1) + ")")
		  
		  // Click on TOC entry using JavaScript
		  Dim js As String = _
		  "(function() {" + _
		  "  var nodes = document.querySelectorAll('.el-tree-node__label');" + _
		  "  if (nodes[" + Str(index) + "]) {" + _
		  "    nodes[" + Str(index) + "].click();" + _
		  "    return true;" + _
		  "  }" + _
		  "  return false;" + _
		  "})();"
		  
		  Dim clickResult As String = MainHTMLViewer.ExecuteJavaScriptSync(js)
		  System.DebugLog("ProcessNextTOCEntry: Click result = " + clickResult)
		  
		  // Wait for dynamic content to load using timer (since DocumentComplete doesn't fire for AJAX updates)
		  mWaitingForContent = True
		  ContentTimer.RunMode = Timer.RunModes.Single
		  ContentTimer.Enabled = True
		  System.DebugLog("ProcessNextTOCEntry: Started timer to extract content")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RemoveTagsWithContent(html As String, tagName As String) As String
		  // Remove tags and their entire content (for script, style, etc.)
		  Dim result As String = html
		  Dim openTag As String = "<" + tagName
		  Dim closeTag As String = "</" + tagName + ">"
		  
		  Dim maxIterations As Integer = 100
		  Dim iterations As Integer = 0
		  
		  While result.IndexOf(openTag) >= 0 And iterations < maxIterations
		    Dim startPos As Integer = result.IndexOf(openTag)
		    Dim remainder As String = result.Middle(startPos)
		    Dim endPos As Integer = remainder.IndexOf(closeTag)
		    
		    If endPos >= 0 Then
		      // Remove from opening tag to closing tag
		      Dim actualEndPos As Integer = startPos + endPos + closeTag.Length
		      result = result.Left(startPos) + result.Middle(actualEndPos)
		    Else
		      // No closing tag found, just remove opening tag
		      Exit While
		    End If
		    
		    iterations = iterations + 1
		  Wend
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StripHTMLTags(html As String) As String
		  // Simple HTML tag stripper - iteratively remove tags
		  Dim result As String = html
		  
		  // Remove script and style tags with their content first
		  result = RemoveTagsWithContent(result, "script")
		  result = RemoveTagsWithContent(result, "style")
		  
		  // Remove base64 image data (found in CSS and inline images)
		  Dim base64Pattern As String = "data:image/[^;]+;base64,[A-Za-z0-9+/=]+"
		  While result.IndexOf("data:image/") >= 0
		    Dim startPos As Integer = result.IndexOf("data:image/")
		    If startPos >= 0 Then
		      // Find the end of the base64 string (look for closing quote, paren, or space)
		      Dim endPos As Integer = startPos + 11
		      While endPos < result.Length
		        Dim ch As String = result.Middle(endPos, 1)
		        If ch = "'" Or ch = """" Or ch = ")" Or ch = " " Or ch = ">" Or ch = ";" Or ch = "}" Then
		          Exit While
		        End If
		        endPos = endPos + 1
		      Wend
		      result = result.Left(startPos) + result.Middle(endPos)
		    Else
		      Exit While
		    End If
		  Wend
		  
		  // Remove tags iteratively with safety counter
		  Dim maxIterations As Integer = 1000
		  Dim iterations As Integer = 0
		  Dim previousLength As Integer = -1
		  
		  While result.IndexOf("<") >= 0 And iterations < maxIterations
		    Dim startPos As Integer = result.IndexOf("<")
		    
		    // Search for > after the <
		    Dim remainder As String = result.Middle(startPos)
		    Dim endPosInRemainder As Integer = remainder.IndexOf(">")
		    
		    If endPosInRemainder >= 0 Then
		      // Remove this tag
		      Dim endPos As Integer = startPos + endPosInRemainder
		      result = result.Left(startPos) + " " + result.Middle(endPos + 1)
		    Else
		      // Malformed tag, just remove the <
		      result = result.Left(startPos) + result.Middle(startPos + 1)
		    End If
		    
		    iterations = iterations + 1
		    
		    // Safety check - if length isn't changing, break
		    If result.Length = previousLength Then
		      Exit While
		    End If
		    previousLength = result.Length
		  Wend
		  
		  // Decode HTML entities
		  result = result.ReplaceAll("&nbsp;", " ")
		  result = result.ReplaceAll("&lt;", "<")
		  result = result.ReplaceAll("&gt;", ">")
		  result = result.ReplaceAll("&amp;", "&")
		  result = result.ReplaceAll("&quot;", """")
		  result = result.ReplaceAll("&apos;", "'")
		  result = result.ReplaceAll("&eacute;", "é")
		  result = result.ReplaceAll("&egrave;", "è")
		  result = result.ReplaceAll("&agrave;", "à")
		  result = result.ReplaceAll("&ccedil;", "ç")
		  result = result.ReplaceAll("&euro;", "€")
		  
		  // Clean up whitespace
		  While result.IndexOf("  ") >= 0
		    result = result.ReplaceAll("  ", " ")
		  Wend
		  
		  // Clean up multiple newlines
		  While result.IndexOf(EndOfLine + EndOfLine + EndOfLine) >= 0
		    result = result.ReplaceAll(EndOfLine + EndOfLine + EndOfLine, EndOfLine + EndOfLine)
		  Wend
		  
		  Return result.Trim
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateNavigationButtons()
		  // Update back/forward button states based on browser history
		  BtnBack.Enabled = MainHTMLViewer.CanGoBack
		  BtnForward.Enabled = MainHTMLViewer.CanGoForward
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mContentData As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsProcessing As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mManualTitle As String = "Service_Manual"
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTOCEntries As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTOCKeys() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWaitingForContent As Boolean
	#tag EndProperty


#tag EndWindowCode

#tag Events MainHTMLViewer
	#tag Event
		Sub DocumentComplete(url as String)
		  System.DebugLog("DocumentComplete: URL = " + url)
		  System.DebugLog("DocumentComplete: mWaitingForContent = " + Str(mWaitingForContent) + ", mIsProcessing = " + Str(mIsProcessing))
		  
		  // Update URL field when page loads
		  TFUrl.Text = url
		  UpdateNavigationButtons()
		  
		  // If waiting for content after clicking TOC entry
		  If mWaitingForContent And mIsProcessing Then
		    System.DebugLog("DocumentComplete: Extracting content...")
		    mWaitingForContent = False
		    
		    // Extract content from current page
		    Dim js As String = _
		    "(function() {" + _
		    "  var contentDiv = document.querySelector('.svcgd__body__details');" + _
		    "  if (contentDiv) {" + _
		    "    return contentDiv.innerHTML;" + _
		    "  }" + _
		    "  return '';" + _
		    "})();"
		    
		    Dim content As String = MainHTMLViewer.ExecuteJavaScriptSync(js)
		    System.DebugLog("DocumentComplete: Content length = " + Str(content.Length))
		    
		    If content <> "" Then
		      // Store content for current TOC entry
		      Dim key As String = mTOCKeys(mCurrentIndex)
		      mContentData.Value(key) = content
		      System.DebugLog("DocumentComplete: Stored content for key: " + key)
		      
		      // Process next entry
		      ProcessNextTOCEntry()
		    Else
		      System.DebugLog("DocumentComplete: No content found, skipping to next entry")
		      AddLogMessage("Warning: No content found for entry")
		      // Skip to next entry anyway
		      ProcessNextTOCEntry()
		    End If
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BtnBack
	#tag Event
		Sub Pressed()
		  // Go back in browser history
		  If MainHTMLViewer.CanGoBack Then
		    MainHTMLViewer.GoBack()
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BtnForward
	#tag Event
		Sub Pressed()
		  // Go forward in browser history
		  If MainHTMLViewer.CanGoForward Then
		    MainHTMLViewer.GoForward()
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TFUrl
	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Load URL when user presses Enter
		  If key = Chr(13) Then
		    LoadURL(Me.Text)
		    Return True
		  End If
		  Return False
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events BtnGo
	#tag Event
		Sub Pressed()
		  // Load URL from text field
		  LoadURL(TFUrl.Text)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BtnScrapePDF
	#tag Event
		Sub Pressed()
		  // Start scraping process
		  If mIsProcessing Then Return
		  
		  mIsProcessing = True
		  BtnScrapePDF.Enabled = False
		  
		  // Show progress area
		  TxtProgress.Visible = True
		  TxtProgress.Text = ""
		  
		  // Resize browser to make room for progress
		  MainHTMLViewer.Height = 100
		  TxtProgress.Top = 110
		  TxtProgress.Height = Self.Height - 150
		  
		  AddLogMessage("Starting scrape process...")
		  AddLogMessage("Extracting TOC structure...")
		  
		  // Extract TOC structure from current page
		  ExtractTOCStructure()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ContentTimer
	#tag Event
		Sub Action()
		  System.DebugLog("ContentTimer.Action: Timer fired, extracting content...")
		  
		  If Not mIsProcessing Or Not mWaitingForContent Then
		    System.DebugLog("ContentTimer.Action: Not in correct state, ignoring")
		    Return
		  End If
		  
		  mWaitingForContent = False
		  
		  // Get current entry info
		  Dim key As String = mTOCKeys(mCurrentIndex)
		  Dim entry As Dictionary = mTOCEntries.Value(key)
		  Dim isLeaf As Boolean = entry.Value("isLeaf")
		  
		  // Only extract content for leaf nodes (parent nodes are just categories)
		  If isLeaf Then
		    // First, check what's on the page
		    Dim checkJS As String = _
		    "(function() {" + _
		    "  var checks = {" + _
		    "    hasDetails: document.querySelector('.svcgd__body__details') !== null," + _
		    "    hasContent: document.querySelector('.service-guide-content') !== null," + _
		    "    hasBodyClass: document.querySelector('[class*=body]') !== null," + _
		    "    classes: []" + _
		    "  };" + _
		    "  var allDivs = document.querySelectorAll('div[class]');" + _
		    "  for (var i = 0; i < Math.min(allDivs.length, 20); i++) {" + _
		    "    checks.classes.push(allDivs[i].className);" + _
		    "  }" + _
		    "  return JSON.stringify(checks);" + _
		    "})();"
		    
		    Dim checkResult As String = MainHTMLViewer.ExecuteJavaScriptSync(checkJS)
		    System.DebugLog("ContentTimer.Action: Page check = " + checkResult)
		    AddLogMessage("DOM Check: " + checkResult)
		    
		    // Extract content and images from current page with debugging
		    // First test: Just try to get the innerHTML
		    Dim testJS As String = _
		    "(function() {" + _
		    "  var contentDiv = document.querySelector('.svcgd__body__details');" + _
		    "  if (!contentDiv) return 'NO_DIV_FOUND';" + _
		    "  var html = contentDiv.innerHTML;" + _
		    "  if (!html) return 'DIV_EMPTY';" + _
		    "  return 'HTML_LEN:' + html.length;" + _
		    "})();"
		    
		    Dim testResult As String = MainHTMLViewer.ExecuteJavaScriptSync(testJS)
		    AddLogMessage("Test: " + testResult)
		    System.DebugLog("ContentTimer.Action: Test result = " + testResult)
		    
		    // Extract HTML content directly (no JSON wrapping to avoid size limits)
		    Dim htmlJS As String = _
		    "(function() {" + _
		    "  var contentDiv = document.querySelector('.svcgd__body__details');" + _
		    "  if (!contentDiv) return '';" + _
		    "  return contentDiv.innerHTML;" + _
		    "})();"
		    
		    Dim htmlContent As String = MainHTMLViewer.ExecuteJavaScriptSync(htmlJS)
		    AddLogMessage("HTML extracted: " + Str(htmlContent.Length) + " chars")
		    
		    // Extract images separately as JSON (much smaller)
		    Dim imagesJS As String = _
		    "(function() {" + _
		    "  try {" + _
		    "    var contentDiv = document.querySelector('.svcgd__body__details');" + _
		    "    if (!contentDiv) return '[]';" + _
		    "    " + _
		    "    var images = [];" + _
		    "    var imgs = contentDiv.querySelectorAll('img');" + _
		    "    " + _
		    "    for (var i = 0; i < imgs.length; i++) {" + _
		    "      var src = imgs[i].src;" + _
		    "      if (src && !src.startsWith('data:')) {" + _
		    "        images.push({" + _
		    "          'src': src," + _
		    "          'alt': imgs[i].alt || ''," + _
		    "          'width': imgs[i].width || 0," + _
		    "          'height': imgs[i].height || 0" + _
		    "        });" + _
		    "      }" + _
		    "    }" + _
		    "    " + _
		    "    return JSON.stringify(images);" + _
		    "  } catch(e) {" + _
		    "    return '[]';" + _
		    "  }" + _
		    "})();"
		    
		    Dim imagesJSON As String = MainHTMLViewer.ExecuteJavaScriptSync(imagesJS)
		    System.DebugLog("ContentTimer.Action: Images JSON = " + imagesJSON)
		    
		    // Build JSON structure in Xojo (avoids JavaScript size limits)
		    Dim jsonResult As String
		    If htmlContent.Length > 0 Then
		      Try
		        Dim result As New JSONItem
		        result.Value("html") = htmlContent
		        result.Value("images") = New JSONItem(imagesJSON)
		        jsonResult = result.ToString
		        AddLogMessage("JSON built: " + Str(jsonResult.Length) + " chars, " + imagesJSON + " images")
		      Catch err As RuntimeException
		        System.DebugLog("ContentTimer.Action: Error building JSON - " + err.Message)
		        AddLogMessage("ERROR: Failed to build JSON - " + err.Message)
		        jsonResult = ""
		      End Try
		    Else
		      AddLogMessage("No HTML content extracted")
		    End If
		    
		    If jsonResult.Length > 0 Then
		      // Store content for current TOC entry
		      mContentData.Value(key) = jsonResult
		      System.DebugLog("ContentTimer.Action: Stored content for key: " + key)
		    Else
		      System.DebugLog("ContentTimer.Action: No content found for leaf node")
		      AddLogMessage("Warning: No content found for entry")
		    End If
		  Else
		    System.DebugLog("ContentTimer.Action: Parent node - skipping content extraction")
		  End If
		  
		  // Process next entry
		  ProcessNextTOCEntry()
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
#tag EndViewBehavior
