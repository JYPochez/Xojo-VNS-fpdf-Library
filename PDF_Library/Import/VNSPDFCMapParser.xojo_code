#tag Class
Protected Class VNSPDFCMapParser
	#tag Method, Flags = &h21
		Private Sub ParseBfchar(section As String, mapping As Dictionary)
		  // Parse bfchar section: <CID><Unicode>
		  // Format can be with or without spaces: <0056><0053> or <0056> <0053>
		  // Example: <0056><0053> means CID 0x56 → Unicode 0x53
		  
		  Dim lines() As String = section.Split(EndOfLine.UNIX)
		  For Each line As String In lines
		    line = line.Trim
		    If line = "" Then Continue
		    
		    // Extract all <XXXX> tokens from the line
		    Dim hexValues() As String
		    Dim pos As Integer = 0
		    While pos < line.Length
		      Dim openBracket As Integer = line.IndexOf(pos, "<")
		      If openBracket = -1 Then Exit While
		      
		      Dim closeBracket As Integer = line.IndexOf(openBracket, ">")
		      If closeBracket = -1 Then Exit While
		      
		      // Extract hex value between brackets
		      Dim hexValue As String = line.Middle(openBracket + 1, closeBracket - openBracket - 1)
		      hexValues.Add(hexValue)
		      
		      pos = closeBracket + 1
		    Wend
		    
		    // Need at least 2 hex values: cid, unicode
		    If hexValues.Count < 2 Then Continue
		    
		    Dim cidHex As String = hexValues(0)
		    Dim unicodeHex As String = hexValues(1)
		    
		    // Convert hex to integers
		    Dim cid As Integer = Val("&h" + cidHex)
		    Dim unicode As Integer = Val("&h" + unicodeHex)
		    
		    mapping.Value(cid) = unicode
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseBfrange(section As String, mapping As Dictionary)
		  // Parse bfrange section: <CID_start><CID_end><Unicode_start>
		  // Format can be with or without spaces: <0020><007E><0020> or <0020> <007E> <0020>
		  // Example: <0020><007E><0020> means CIDs 0x20-0x7E map to Unicode 0x20-0x7E
		  
		  Dim lines() As String = section.Split(EndOfLine.UNIX)
		  
		  For Each line As String In lines
		    line = line.Trim
		    If line = "" Then Continue
		    
		    // Extract all <XXXX> tokens from the line
		    Dim hexValues() As String
		    Dim pos As Integer = 0
		    While pos < line.Length
		      Dim openBracket As Integer = line.IndexOf(pos, "<")
		      If openBracket = -1 Then Exit While
		      
		      Dim closeBracket As Integer = line.IndexOf(openBracket, ">")
		      If closeBracket = -1 Then Exit While
		      
		      // Extract hex value between brackets
		      Dim hexValue As String = line.Middle(openBracket + 1, closeBracket - openBracket - 1)
		      hexValues.Add(hexValue)
		      
		      pos = closeBracket + 1
		    Wend
		    
		    // Need at least 3 hex values: cidStart, cidEnd, unicodeStart
		    If hexValues.Count < 3 Then Continue
		    
		    Dim cidStartHex As String = hexValues(0)
		    Dim cidEndHex As String = hexValues(1)
		    Dim unicodeStartHex As String = hexValues(2)
		    
		    // Convert hex to integers
		    Dim cidStart As Integer = Val("&h" + cidStartHex)
		    Dim cidEnd As Integer = Val("&h" + cidEndHex)
		    Dim unicodeStart As Integer = Val("&h" + unicodeStartHex)
		    
		    // Map the range
		    For cid As Integer = cidStart To cidEnd
		      Dim unicode As Integer = unicodeStart + (cid - cidStart)
		      mapping.Value(cid) = unicode
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParseCMap(cmapContent As String) As Dictionary
		  // Parse ToUnicode CMap and return CID → Unicode mapping dictionary
		  // Returns Nil if parsing fails
		  
		  Dim mapping As New Dictionary
		  
		  // Find and parse bfchar sections
		  Dim bfcharStart As Integer = cmapContent.IndexOf("beginbfchar")
		  
		  While bfcharStart > -1
		    Dim bfcharEnd As Integer = cmapContent.IndexOf(bfcharStart, "endbfchar")
		    If bfcharEnd = -1 Then Exit While
		    
		    Dim section As String = cmapContent.Middle(bfcharStart + 11, bfcharEnd - bfcharStart - 11)
		    Call ParseBfchar(section, mapping)
		    
		    bfcharStart = cmapContent.IndexOf(bfcharEnd, "beginbfchar")
		  Wend
		  
		  // Find and parse bfrange sections
		  Dim bfrangeStart As Integer = cmapContent.IndexOf("beginbfrange")
		  
		  While bfrangeStart > -1
		    Dim bfrangeEnd As Integer = cmapContent.IndexOf(bfrangeStart, "endbfrange")
		    If bfrangeEnd = -1 Then Exit While
		    
		    Dim section As String = cmapContent.Middle(bfrangeStart + 12, bfrangeEnd - bfrangeStart - 12)
		    Call ParseBfrange(section, mapping)
		    
		    bfrangeStart = cmapContent.IndexOf(bfrangeEnd, "beginbfrange")
		  Wend
		  
		  System.DebugLog("ParseCMap: Total mappings parsed = " + Str(mapping.KeyCount))
		  
		  Return mapping
		End Function
	#tag EndMethod


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
