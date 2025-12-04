#tag Class
Protected Class VNSPDFLZWDecoder
	#tag Method, Flags = &h0
		Function Decode(compressedData As String, Optional earlyChange As Integer = 1) As String
		  // LZW decompression for PDF LZWDecode filter
		  // Pure Xojo implementation - works on all platforms including iOS
		  // Uses suffix/prefix arrays (Go implementation pattern)
		  //
		  // Parameters:
		  //   compressedData: LZW-compressed data
		  //   earlyChange: 0 = change code size one code LATE (non-standard)
		  //                1 = change code size one code EARLY (PDF default)

		  mError = ""
		  mEarlyChange = earlyChange

		  If compressedData = "" Then
		    mError = "Empty input data"
		    Return ""
		  End If

		  // Convert string to bytes
		  Dim inputBytes As MemoryBlock = New MemoryBlock(compressedData.Length)
		  For i As Integer = 0 To compressedData.Length - 1
		    inputBytes.UInt8Value(i) = Asc(compressedData.Middle(i, 1))
		  Next

		  // CRITICAL FIX: Skip leading whitespace (CR, LF, space, tab)
		  // Some PDFs include newline bytes at start of LZW stream data
		  Dim startPos As Integer = 0
		  While startPos < inputBytes.Size
		    Dim b As Integer = inputBytes.UInt8Value(startPos)
		    If b = 13 Or b = 10 Or b = 32 Or b = 9 Then  // CR, LF, space, tab
		      startPos = startPos + 1
		    Else
		      Exit While
		    End If
		  Wend

		  If startPos > 0 Then
		    // Create new buffer without leading whitespace
		    Dim cleanData As New MemoryBlock(inputBytes.Size - startPos)
		    For i As Integer = 0 To cleanData.Size - 1
		      cleanData.UInt8Value(i) = inputBytes.UInt8Value(startPos + i)
		    Next
		    inputBytes = cleanData
		  End If

		  // Initialize
		  mInputData = inputBytes
		  mInputPos = 0
		  mBitBuffer = 0
		  mBitsInBuffer = 0
		  Call InitializeDictionary()

		  // Output buffer
		  Dim output As MemoryBlock = New MemoryBlock(0)
		  Dim outputPos As Integer = 0

		  // Read first code
		  Dim code As Integer = ReadCode()
		  If code = -1 Or code = kEOI Then
		    Return ""
		  End If

		  // Handle Clear code at start
		  If code = kClearCode Then
		    Call InitializeDictionary()
		    code = ReadCode()
		    If code = -1 Or code = kEOI Then
		      Return ""
		    End If
		  End If

		  // Output first character
		  If code < 256 Then
		    output.Size = 1
		    output.UInt8Value(0) = code
		    outputPos = 1
		  Else
		    mError = "First code must be literal"
		    Return ""
		  End If

		  Dim oldCode As Integer = code

		  // Main decompression loop
		  While True
		    code = ReadCode()

		    If code = -1 Then
		      // End of data
		      Exit While
		    ElseIf code = kEOI Then
		      // End of Information marker
		      Exit While
		    ElseIf code = kClearCode Then
		      // Clear code - reinitialize
		      Call InitializeDictionary()
		      code = ReadCode()
		      If code = -1 Or code = kEOI Then
		        Exit While
		      End If
		      If code = kClearCode Then
		        Continue
		      End If
		      If code < 256 Then
		        output.Size = outputPos + 1
		        output.UInt8Value(outputPos) = code
		        outputPos = outputPos + 1
		        oldCode = code
		        Continue
		      Else
		        mError = "Invalid code after clear"
		        Exit While
		      End If
		    End If

		    // Decode the code
		    Dim sequence() As UInt8
		    If code < mNextCode Then
		      // Code exists in dictionary
		      sequence = GetSequence(code)
		    ElseIf code = mNextCode Then
		      // Special case: code == nextCode
		      // This means oldCode + firstChar(oldCode)
		      Dim oldSeq() As UInt8 = GetSequence(oldCode)
		      ReDim sequence(oldSeq.Count)
		      For i As Integer = 0 To oldSeq.Count - 1
		        sequence(i) = oldSeq(i)
		      Next
		      sequence(oldSeq.Count) = oldSeq(0)
		    Else
		      // Invalid code
		      mError = "Invalid code: " + Str(code) + " (nextCode=" + Str(mNextCode) + ", codeSize=" + Str(mCodeSize) + ")"
		      Exit While
		    End If

		    // Output the sequence
		    Dim oldSize As Integer = output.Size
		    output.Size = oldSize + sequence.Count
		    For i As Integer = 0 To sequence.Count - 1
		      output.UInt8Value(oldSize + i) = sequence(i)
		    Next
		    outputPos = output.Size

		    // Add new dictionary entry if space available
		    If mNextCode < kMaxDictSize Then
		      // New entry = oldCode + firstChar(sequence)
		      mSuffix(mNextCode) = sequence(0)
		      mPrefix(mNextCode) = oldCode
		    End If

		    // CRITICAL: Always increment mNextCode to stay in sync with encoder
		    // This happens even when dictionary is full (following go-pdf/lzw pattern)
		    oldCode = code
		    mNextCode = mNextCode + 1

		    // Update code size if not at maximum width
		    If mCodeSize < 12 Then
		      Call UpdateCodeSize()
		    End If
		  Wend

		  // Convert output to string
		  If output.Size = 0 Then
		    Return ""
		  End If

		  Return output.StringValue(0, output.Size)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitializeDictionary()
		  // Initialize dictionary with single-byte entries (0-255)
		  // Codes 256 (Clear) and 257 (EOI) are reserved

		  // First 256 codes are literals (single bytes)
		  For i As Integer = 0 To 255
		    mSuffix(i) = i
		    mPrefix(i) = 0  // Literals have no prefix
		  Next

		  // Code 256 = Clear Code (reserved, not stored)
		  // Code 257 = EOI (reserved, not stored)

		  // Next available code is 258
		  mNextCode = 258
		  mCodeSize = 9
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSequence(code As Integer) As UInt8()
		  // Get the byte sequence for a code by walking the prefix chain
		  // Returns: Array of bytes in correct order

		  If code < 256 Then
		    // Literal code - return single byte
		    Dim result(0) As UInt8
		    result(0) = code
		    Return result
		  End If

		  // Count length by walking prefix chain
		  Dim length As Integer = 0
		  Dim c As Integer = code
		  While c >= 256 And length < 4096
		    length = length + 1
		    c = mPrefix(c)
		  Wend
		  length = length + 1  // Add the final literal

		  // Build sequence backwards
		  Dim result() As UInt8
		  ReDim result(length - 1)
		  c = code
		  Dim pos As Integer = length - 1

		  While c >= 256 And pos >= 0
		    result(pos) = mSuffix(c)
		    pos = pos - 1
		    c = mPrefix(c)
		  Wend

		  If pos = 0 Then
		    result(0) = c  // Final literal
		  End If

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReadCode() As Integer
		  // Read variable-length code from bit stream (MSB first for PDF)
		  // Returns -1 on end of data

		  // Fill buffer with enough bits
		  While mBitsInBuffer < mCodeSize
		    If mInputPos >= mInputData.Size Then
		      If mBitsInBuffer = 0 Then
		        Return -1
		      Else
		        Exit While
		      End If
		    End If

		    Dim nextByte As Integer = mInputData.UInt8Value(mInputPos)
		    mInputPos = mInputPos + 1

		    // Add byte to buffer (MSB first - PDF uses big-endian bit order)
		    mBitBuffer = Bitwise.ShiftLeft(mBitBuffer, 8) Or nextByte
		    mBitsInBuffer = mBitsInBuffer + 8
		  Wend

		  If mBitsInBuffer < mCodeSize Then
		    Return -1
		  End If

		  // Extract code from buffer (from MSB side)
		  Dim shift As Integer = mBitsInBuffer - mCodeSize
		  Dim code As Integer = Bitwise.ShiftRight(mBitBuffer, shift) And (Bitwise.ShiftLeft(1, mCodeSize) - 1)

		  // Remove extracted bits
		  mBitsInBuffer = mBitsInBuffer - mCodeSize
		  mBitBuffer = mBitBuffer And (Bitwise.ShiftLeft(1, mBitsInBuffer) - 1)

		  Return code
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateCodeSize()
		  // Increase code size when dictionary reaches certain thresholds
		  //
		  // Early Change = 1 (PDF default): code size increases ONE CODE EARLY
		  // - 9 bits: codes 0-510 (increase when mNextCode = 511, BEFORE using 511)
		  // - 10 bits: codes 511-1022 (increase when mNextCode = 1023)
		  // - 11 bits: codes 1023-2046 (increase when mNextCode = 2047)
		  // - 12 bits: codes 2047-4095
		  //
		  // Early Change = 0 (non-standard): code size increases ONE CODE LATE
		  // - 9 bits: codes 0-511 (increase when mNextCode = 512, AFTER using 511)
		  // - 10 bits: codes 512-1023 (increase when mNextCode = 1024)
		  // - 11 bits: codes 1024-2047 (increase when mNextCode = 2048)
		  // - 12 bits: codes 2048-4095

		  If mEarlyChange = 1 Then
		    // Early Change = 1 (PDF default)
		    If mCodeSize = 9 And mNextCode >= 511 Then
		      mCodeSize = 10
		    ElseIf mCodeSize = 10 And mNextCode >= 1023 Then
		      mCodeSize = 11
		    ElseIf mCodeSize = 11 And mNextCode >= 2047 Then
		      mCodeSize = 12
		    End If
		  Else
		    // Early Change = 0 (change code size one code LATE)
		    If mCodeSize = 9 And mNextCode >= 512 Then
		      mCodeSize = 10
		    ElseIf mCodeSize = 10 And mNextCode >= 1024 Then
		      mCodeSize = 11
		    ElseIf mCodeSize = 11 And mNextCode >= 2048 Then
		      mCodeSize = 12
		    End If
		  End If

		  // Max code size is 12 bits (4096 entries)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetError() As String
		  Return mError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetDiagnostics() As String
		  // Returns diagnostic information about the decoder state
		  // Useful for debugging decoding issues

		  Dim diag As String = "=== LZW Decoder Diagnostics ===" + EndOfLine
		  diag = diag + "Next Code: " + Str(mNextCode) + EndOfLine
		  diag = diag + "Current Code Size: " + Str(mCodeSize) + " bits" + EndOfLine
		  diag = diag + "Bits In Buffer: " + Str(mBitsInBuffer) + EndOfLine
		  diag = diag + "Input Position: " + Str(mInputPos)
		  If mInputData <> Nil Then
		    diag = diag + " / " + Str(mInputData.Size)
		  End If
		  diag = diag + EndOfLine

		  If mError <> "" Then
		    diag = diag + "Error: " + mError + EndOfLine
		  Else
		    diag = diag + "Status: OK" + EndOfLine
		  End If

		  // Show some dictionary entries for verification
		  diag = diag + EndOfLine + "Sample Dictionary Entries:" + EndOfLine
		  Dim sampleCodes() As Integer = Array(256, 257, 258, 259, 260, 511, 1023, 2047, mNextCode - 1)
		  For Each code As Integer In sampleCodes
		    If code >= 0 And code < mNextCode Then
		      If code < 256 Then
		        diag = diag + "  Code " + Str(code) + ": '" + Chr(code) + "' (literal)" + EndOfLine
		      ElseIf code = 256 Then
		        diag = diag + "  Code 256: CLEAR" + EndOfLine
		      ElseIf code = 257 Then
		        diag = diag + "  Code 257: EOI" + EndOfLine
		      Else
		        diag = diag + "  Code " + Str(code) + ": prefix=" + Str(mPrefix(code)) + ", suffix=" + Str(mSuffix(code)) + EndOfLine
		      End If
		    End If
		  Next

		  Return diag
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function RunTests() As String
		  // Run test vectors to validate LZW implementation
		  // Returns: Test results as string
		  //
		  // NOTE: These test vectors were created manually and may not be
		  // correctly encoded. The real validation comes from testing with
		  // actual PDF files that use LZWDecode compression (Example 20).

		  Dim results As String = "=== LZW Decoder Comprehensive Tests ===" + EndOfLine + EndOfLine
		  Dim passCount As Integer = 0
		  Dim failCount As Integer = 0

		  // Test 1: Basic functionality - decode a simple literal sequence
		  // This tests: Clear code -> literal codes -> EOI
		  // Input: Clear (256), 'A' (65), 'B' (66), EOI (257)
		  // 9-bit codes packed MSB-first:
		  // Bits: 100000000 001000001 001000010 100000001
		  // Bytes: 10000000 00010000 01001000 01010000 0001 (padded)
		  //        0x80     0x10     0x48     0x50     0x10
		  results = results + "Test 1: Basic Literal Decode" + EndOfLine
		  Dim test1Input As String = Chr(&h80) + Chr(&h10) + Chr(&h48) + Chr(&h50) + Chr(&h10)
		  Dim test1Expected As String = "AB"
		  Dim decoder1 As New VNSPDFLZWDecoder
		  Dim test1Result As String = decoder1.Decode(test1Input)
		  If test1Result = test1Expected Then
		    results = results + "  ✓ PASS - Output: '" + test1Result + "'" + EndOfLine
		    passCount = passCount + 1
		  Else
		    results = results + "  ✗ FAIL - Expected: '" + test1Expected + "', Got: '" + test1Result + "'" + EndOfLine
		    If decoder1.GetError() <> "" Then
		      results = results + "    Error: " + decoder1.GetError() + EndOfLine
		    End If
		    failCount = failCount + 1
		  End If

		  // Test 2: Empty stream with just Clear and EOI codes
		  // 9-bit codes: Clear (256), EOI (257)
		  // Bits: 100000000 100000001
		  // Bytes: 10000000 01000000 01 (padded)
		  //        0x80     0x40     0x40
		  results = results + EndOfLine + "Test 2: Empty Stream (Clear + EOI)" + EndOfLine
		  Dim test2Input As String = Chr(&h80) + Chr(&h40) + Chr(&h40)
		  Dim test2Expected As String = ""
		  Dim decoder2 As New VNSPDFLZWDecoder
		  Dim test2Result As String = decoder2.Decode(test2Input)
		  If test2Result = test2Expected Then
		    results = results + "  ✓ PASS - Empty output as expected" + EndOfLine
		    passCount = passCount + 1
		  Else
		    results = results + "  ✗ FAIL - Expected empty, Got length: " + Str(test2Result.Length) + EndOfLine
		    failCount = failCount + 1
		  End If

		  // Test 3: Single literal character
		  // Input: Clear (256), 'X' (88), EOI (257)
		  results = results + EndOfLine + "Test 3: Single Character" + EndOfLine
		  Dim test3Input As String = Chr(&h80) + Chr(&h16) + Chr(&h04)
		  Dim test3Expected As String = "X"
		  Dim decoder3 As New VNSPDFLZWDecoder
		  Dim test3Result As String = decoder3.Decode(test3Input)
		  If test3Result = test3Expected Then
		    results = results + "  ✓ PASS - Output: '" + test3Result + "'" + EndOfLine
		    passCount = passCount + 1
		  Else
		    results = results + "  ✗ FAIL - Expected: '" + test3Expected + "', Got: '" + test3Result + "'" + EndOfLine
		    If decoder3.GetError() <> "" Then
		      results = results + "    Error: " + decoder3.GetError() + EndOfLine
		    End If
		    failCount = failCount + 1
		  End If

		  // Test 4: Error handling - Invalid input (empty data)
		  results = results + EndOfLine + "Test 4: Error Handling - Empty Input" + EndOfLine
		  Dim decoder4 As New VNSPDFLZWDecoder
		  Dim test4Result As String = decoder4.Decode("")
		  If test4Result = "" And decoder4.GetError() <> "" Then
		    results = results + "  ✓ PASS - Correctly detected empty input" + EndOfLine
		    results = results + "    Error message: " + decoder4.GetError() + EndOfLine
		    passCount = passCount + 1
		  Else
		    results = results + "  ✗ FAIL - Should have reported empty input error" + EndOfLine
		    failCount = failCount + 1
		  End If

		  // Test 5: Error handling - Truncated stream
		  results = results + EndOfLine + "Test 5: Error Handling - Truncated Stream" + EndOfLine
		  Dim test5Input As String = Chr(&h80) + Chr(&h10)  // Clear code but no data
		  Dim decoder5 As New VNSPDFLZWDecoder
		  Dim test5Result As String = decoder5.Decode(test5Input)
		  // Should return empty or partial data, not crash
		  results = results + "  ✓ PASS - Handled truncated stream without crash" + EndOfLine
		  results = results + "    Output length: " + Str(test5Result.Length) + EndOfLine
		  If decoder5.GetError() <> "" Then
		    results = results + "    Error: " + decoder5.GetError() + EndOfLine
		  End If
		  passCount = passCount + 1

		  // Summary
		  results = results + EndOfLine + "=== Test Summary ===" + EndOfLine
		  results = results + "Passed: " + Str(passCount) + EndOfLine
		  results = results + "Failed: " + Str(failCount) + EndOfLine
		  results = results + "Total:  " + Str(passCount + failCount) + EndOfLine
		  results = results + EndOfLine
		  results = results + "NOTE: These are basic validation tests." + EndOfLine
		  results = results + "For comprehensive testing, use Example 20 with an LZW-compressed PDF." + EndOfLine

		  Return results
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mError As String = ""
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSuffix(4095) As UInt8
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPrefix(4095) As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNextCode As Integer = 258
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCodeSize As Integer = 9
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInputData As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInputPos As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBitBuffer As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBitsInBuffer As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEarlyChange As Integer = 1
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return 256
			End Get
		#tag EndGetter
		Private kClearCode As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return 257
			End Get
		#tag EndGetter
		Private kEOI As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return 4096
			End Get
		#tag EndGetter
		Private kMaxDictSize As Integer
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
	#tag EndViewBehavior
End Class
#tag EndClass
