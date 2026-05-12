#tag Module
Protected Module VNSZlibModule
	#tag Method, Flags = &h1
		Protected Function Compress(input as String) As String
		  mLastErrorCode = 0
		  
		  #If Not TargetiOS And Not TargetAndroid Then
		    // Native-first strategy: try system zlib, fall back to premium pure Xojo
		    // zlib uses uLongf (unsigned long) for sizes:
		    // macOS/Linux LP64: unsigned long = 8 bytes -> UInt64
		    // Windows LLP64: unsigned long = 4 bytes -> UInt32
		    Try
		      #If TargetWindows Then
		        soft declare function zlibcompress lib kZlibPath alias "compress" (dest as Ptr, ByRef destLen as UInt32, source as Ptr, sourceLen as UInt32) as Int32
		      #Else
		        soft declare function zlibcompress lib kZlibPath alias "compress" (dest as Ptr, ByRef destLen as UInt64, source as Ptr, sourceLen as UInt64) as Int32
		      #EndIf
		      
		      // Convert string to MemoryBlock to preserve binary data (CString truncates at null bytes)
		      Dim inputMB As New MemoryBlock(input.Bytes)
		      inputMB.StringValue(0, input.Bytes) = input
		      
		      Dim output As New MemoryBlock(12 + 1.002*input.Bytes)
		      #If TargetWindows Then
		        Dim outputSize As UInt32 = output.Size
		      #Else
		        Dim outputSize As UInt64 = output.Size
		      #EndIf
		      
		      mLastErrorCode = zlibcompress(output, outputSize, inputMB, input.Bytes)
		      If mLastErrorCode = 0 Then
		        Return output.StringValue(0, outputSize)
		      End If
		      // Native zlib returned error - fall through to premium fallback
		      
		    Catch e As RuntimeException
		      // Native zlib not available (e.g. ZLIB1.DLL missing on Windows)
		      // Fall through to premium pure Xojo fallback
		      mLastErrorCode = kZ_ERRNO
		      #If TargetWindows Then
		        System.DebugLog("VNSZlibModule: ZLIB1.DLL not found. Place ZLIB1.DLL next to your .exe or use the premium Zlib module.")
		      #EndIf
		    End Try

		    // Fallback: use premium pure Xojo compression if available
		    #If hasPremiumVNSZlibModule Then
		      Return CompressWithPremium(input)
		    #Else
		      // No compression available - return empty to signal failure
		      Return ""
		    #EndIf
		    
		  #Else
		    // iOS/Android: Declares to system libraries blocked by sandboxing
		    // Use pure Xojo implementation if premium zlib module is available
		    #If hasPremiumVNSZlibModule Then
		      Return CompressWithPremium(input)
		    #Else
		      // No compression available - PDFs remain valid but larger
		      mLastErrorCode = 0
		      Return input
		    #EndIf
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CompressWithPremium(input As String) As String
		  // Pure Xojo compression fallback (premium module)
		  #If hasPremiumVNSZlibModule Then
		    Dim deflater As New VNSZlibPremiumDeflate
		    // Use fast compression (level 1) for large data to avoid slow hash chain lookups
		    Const kFastCompressionThreshold As Integer = 102400 // 100KB
		    If input.Bytes > kFastCompressionThreshold Then
		      deflater.SetLevel(1)
		    End If
		    Dim result As MemoryBlock = deflater.CompressString(input)
		    If result <> Nil And result.Size > 0 Then
		      Return result.StringValue(0, result.Size)
		    Else
		      mLastErrorCode = kZ_MEM_ERROR
		      Return ""
		    End If
		  #Else
		    #Pragma Unused input
		    mLastErrorCode = kZ_MEM_ERROR
		    Return ""
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Uncompress(input as String, bufferSize as Integer = 0) As String
		  mLastErrorCode = 0
		  
		  #If Not TargetiOS And Not TargetAndroid Then
		    // Native-first strategy: try system zlib, fall back to premium pure Xojo
		    Try
		      Dim localBufferSize As Integer = bufferSize
		      If localBufferSize = 0 Then
		        localBufferSize = 4*input.Bytes
		      End If
		      
		      // Convert string to MemoryBlock to preserve binary data (CString truncates at null bytes)
		      Dim inputMB As New MemoryBlock(input.Bytes)
		      inputMB.StringValue(0, input.Bytes) = input
		      
		      Do
		        #If TargetWindows Then
		          soft declare function zlibuncompress lib kZlibPath alias "uncompress" (dest as Ptr, ByRef destLen as UInt32, source as Ptr, sourceLen as UInt32) as Int32
		        #Else
		          soft declare function zlibuncompress lib kZlibPath alias "uncompress" (dest as Ptr, ByRef destLen as UInt64, source as Ptr, sourceLen as UInt64) as Int32
		        #EndIf
		        
		        Dim m As New MemoryBlock(localBufferSize)
		        #If TargetWindows Then
		          Dim destLength As UInt32 = m.Size
		        #Else
		          Dim destLength As UInt64 = m.Size
		        #EndIf
		        mLastErrorCode = zlibuncompress(m, destLength, inputMB, input.Bytes)
		        If mLastErrorCode = 0 Then
		          Return m.StringValue(0, destLength)
		        ElseIf mLastErrorCode = kZ_BUF_ERROR Then
		          localBufferSize = localBufferSize + localBufferSize
		        Else
		          // Native zlib returned error - fall through to premium fallback
		          Exit
		        End If
		      Loop
		      
		    Catch e As RuntimeException
		      // Native zlib not available (e.g. ZLIB1.DLL missing on Windows)
		      // Fall through to premium pure Xojo fallback
		      mLastErrorCode = kZ_ERRNO
		      #If TargetWindows Then
		        System.DebugLog("VNSZlibModule: ZLIB1.DLL not found. Place ZLIB1.DLL next to your .exe or use the premium Zlib module.")
		      #EndIf
		    End Try

		    // Fallback: use premium pure Xojo decompression if available
		    #If hasPremiumVNSZlibModule Then
		      Return UncompressWithPremium(input)
		    #Else
		      // No decompression available
		      Return ""
		    #EndIf
		    
		  #Else
		    // iOS/Android: Declares to system libraries blocked by sandboxing
		    #Pragma Unused bufferSize
		    #If hasPremiumVNSZlibModule Then
		      Return UncompressWithPremium(input)
		    #Else
		      // No decompression available - return input as-is
		      mLastErrorCode = 0
		      Return input
		    #EndIf
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function UncompressWithPremium(input As String) As String
		  // Pure Xojo decompression fallback (premium module)
		  #If hasPremiumVNSZlibModule Then
		    Dim inflater As New VNSZlibPremiumInflate
		    Dim inputSize As Integer = input.Bytes
		    Dim inputMB As New MemoryBlock(inputSize)
		    inputMB.StringValue(0, inputSize) = input
		    Dim result As String = inflater.DecompressString(inputMB)
		    If result <> "" Then
		      Return result
		    Else
		      Dim errMsg As String = inflater.GetError()
		      If errMsg <> "" Then
		        mLastErrorCode = kZ_DATA_ERROR
		      Else
		        mLastErrorCode = kZ_MEM_ERROR
		      End If
		      Return ""
		    End If
		  #Else
		    #Pragma Unused input
		    mLastErrorCode = kZ_MEM_ERROR
		    Return ""
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Version() As String
		  // Check if pure Xojo zlib module is available (premium feature)
		  If hasPremiumVNSZlibModule Then
		    Return "1.3.1 (Pure Xojo - Compress + Decompress)"
		  End If
		  
		  #If Not TargetiOS And Not TargetAndroid Then
		    soft declare function zlibVersion lib kZlibPath () as Ptr
		    
		    dim p as MemoryBlock = zlibVersion
		    if p <> nil then
		      return p.CString(0)
		    else
		      return ""
		    end if
		  #Else
		    // iOS/Android without premium: Compression disabled due to sandboxing restrictions
		    return "Compression disabled (Mobile)"
		  #EndIf
		End Function
	#tag EndMethod


	#tag Note, Name = Documentation
		VNSZlibModule
		
		Xojo wrapper for the zlib compression library.
		
		Based on zlib_rb by charles@declareSub.com (http://www.declareSub.com)
		Renamed to VNSZlibModule for VNS PDF Library
		
		PLATFORM SUPPORT:
		
		FREE VERSION:
		- Desktop (Mac/Linux): Uses system zlib via Declares
		- Windows: Requires ZLIB1.DLL alongside app (not included with Windows)
		- iOS: COMPRESSION DISABLED - iOS sandboxing blocks Declares to system libraries
		- PDFs generated without zlib will be larger but remain valid
		
		PREMIUM VERSION (with hasPremiumVNSZlibModule = True):
		- Native-first strategy: tries system zlib first, falls back to pure Xojo
		- ALL PLATFORMS: Works without any external DLL dependencies
		- Full compression AND decompression support on iOS!
		- Windows: No ZLIB1.DLL needed - pure Xojo fallback handles everything
		- No external dependencies
		- Based on zlib 1.3.1 official source code
		- Uses VNSZlibPremiumDeflate for compression (deflate algorithm)
		- Uses VNSZlibPremiumInflate for decompression (inflate algorithm)
		
		--------------------------------------------------------
		
		Compress and Uncompress provide in-memory compression of Xojo strings.
		
		Using Compress is simple:
		  Dim output As String = VNSZlibModule.Compress(input)
		
		Using Uncompress is slightly more complicated. The length of the uncompressed
		string is not stored in the compressed string. Uncompress uses a simple strategy to
		guess the amount of buffer space needed to uncompress the input. If you happen to know the
		size of the uncompressed data in bytes, you can pass it to Uncompress in the optional second
		parameter to possibly speed things up a bit.
		
		  Dim output As String = VNSZlibModule.Uncompress(input)
		  Dim output As String = VNSZlibModule.Uncompress(input, 740526)
		
		The Version function returns the version of zlib.
		
		LastErrorCode contains the last error code returned by a zlib function.
		
		Error codes for Compress:  kZ_OK = no error, kZ_MEM_ERROR = not enough memory, kZ_BUF_ERROR = buffer too small.
		
		Error codes for Uncompress: kZ_OK = no error, kZ_MEM_ERROR = not enough memory, kZ_DATA_ERROR = corrupted data.
		
		ENABLING PREMIUM ZLIB:
		Set hasPremiumVNSZlibModule = True to enable pure Xojo compression/decompression.
		This is part of the premium VNS PDF Library package.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLastErrorCode
			End Get
		#tag EndGetter
		LastErrorCode As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mLastErrorCode As Integer
	#tag EndProperty


	#tag Constant, Name = kZlibPath, Type = String, Dynamic = False, Default = \"", Scope = Private
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"/usr/lib/libz.dylib"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"ZLIB1.DLL"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"/usr/lib/libz.so.1"
	#tag EndConstant

	#tag Constant, Name = kZ_BUF_ERROR, Type = Double, Dynamic = False, Default = \"-5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kZ_DATA_ERROR, Type = Double, Dynamic = False, Default = \"-3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kZ_ERRNO, Type = Double, Dynamic = False, Default = \"-1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kZ_MEM_ERROR, Type = Double, Dynamic = False, Default = \"-4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kZ_OK, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kZ_STREAM_ERROR, Type = Double, Dynamic = False, Default = \"-2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kZ_VERSION_ERROR, Type = Double, Dynamic = False, Default = \"-6", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastErrorCode"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Name"
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
