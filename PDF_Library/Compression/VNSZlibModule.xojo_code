#tag Module
Protected Module VNSZlibModule
	#tag Method, Flags = &h0
		Function Compress(input as String) As String
		  mLastErrorCode = 0

		  // Check if pure Xojo zlib module is available (premium feature)
		  // This enables compression on iOS and removes dependency on system zlib
		  #If VNSPDFModule.hasPremiumZlibModule Then
		    // Use pure Xojo implementation (works on ALL platforms including iOS)
		    Dim deflater As New VNSZlibPremiumDeflate
		    Dim result As MemoryBlock = deflater.CompressString(input)
		    If result <> Nil And result.Size > 0 Then
		      Return result.StringValue(0, result.Size)
		    Else
		      mLastErrorCode = kZ_MEM_ERROR
		      Return ""
		    End If
		  #EndIf

		  #If Not TargetiOS Then
		    soft declare function zlibcompress lib kZlibPath alias "compress" (dest as Ptr, ByRef destLen as Uint32, source as CString, sourceLen as UInt32) as Integer

		    dim output as new MemoryBlock(12 + 1.002*input.Bytes)
		    dim outputSize as UInt32 = output.Size

		    mLastErrorCode = zlibcompress(output, outputSize, input, input.Bytes)
		    if mLastErrorCode = 0 then
		      return output.StringValue(0, outputSize)
		    else
		      return ""
		    end if
		  #Else
		    // iOS: Declares to system libraries blocked by sandboxing
		    // Return uncompressed data - PDFs remain valid but larger
		    mLastErrorCode = 0
		    return input
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Uncompress(input as String, bufferSize as Integer = 0) As String
		  mLastErrorCode = 0

		  // Check if pure Xojo zlib module is available (premium feature)
		  // This enables decompression on iOS and removes dependency on system zlib
		  #If VNSPDFModule.hasPremiumZlibModule Then
		    // Use pure Xojo implementation (works on ALL platforms including iOS)
		    Dim inflater As New VNSZlibPremiumInflate

		    // Convert input string to MemoryBlock
		    #If TargetiOS Then
		      Dim inputSize As Integer = input.Bytes
		    #Else
		      Dim inputSize As Integer = input.Bytes
		    #EndIf

		    Dim inputMB As New MemoryBlock(inputSize)
		    inputMB.StringValue(0, inputSize) = input

		    Dim result As String = inflater.DecompressString(inputMB)
		    If result <> "" Then
		      Return result
		    Else
		      // Get error message for debugging
		      Dim errMsg As String = inflater.GetError()
		      If errMsg <> "" Then
		        mLastErrorCode = kZ_DATA_ERROR
		      Else
		        mLastErrorCode = kZ_MEM_ERROR
		      End If
		      Return ""
		    End If
		  #EndIf

		  #If Not TargetiOS Then
		    #Pragma Unused bufferSize

		    Dim localBufferSize As Integer = bufferSize
		    if localBufferSize = 0 then
		      localBufferSize = 4*input.Bytes
		    end if

		    do
		      soft declare function zlibuncompress lib kZlibPath alias "uncompress" (dest as Ptr, ByRef destLen as UInt32, source as CString, sourceLen as Uint32) as Integer

		      dim m as new MemoryBlock(localBufferSize)
		      dim destLength as UInt32 = m.Size
		      mLastErrorCode = zlibuncompress(m, destLength, input, input.Bytes)
		      if mLastErrorCode = 0 then
		        return m.StringValue(0, destLength)
		      elseIf mLastErrorCode = kZ_BUF_ERROR then
		        localBufferSize = localBufferSize + localBufferSize
		      else
		        return ""
		      end if
		    loop
		  #Else
		    #Pragma Unused bufferSize
		    // iOS without premium: Decompression not available
		    // This should not be called if compression is disabled
		    mLastErrorCode = 0
		    return input
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Version() As String
		  // Check if pure Xojo zlib module is available (premium feature)
		  If VNSPDFModule.hasPremiumZlibModule Then
		    Return "1.3.1 (Pure Xojo - Compress + Decompress)"
		  End If

		  #If Not TargetiOS Then
		    soft declare function zlibVersion lib kZlibPath () as Ptr

		    dim p as MemoryBlock = zlibVersion
		    if p <> nil then
		      return p.CString(0)
		    else
		      return ""
		    end if
		  #Else
		    // iOS without premium: Compression disabled due to sandboxing restrictions
		    return "Compression disabled (iOS)"
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
		- Desktop (Mac/Windows/Linux): Uses system zlib via Declares
		- iOS: COMPRESSION DISABLED - iOS sandboxing blocks Declares to system libraries
		- PDFs generated on iOS will be larger but remain valid

		PREMIUM VERSION (with VNSPDFModule.hasPremiumZlibModule = True):
		- ALL PLATFORMS: Uses pure Xojo zlib implementation
		- Full compression AND decompression support on iOS!
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
		Set VNSPDFModule.hasPremiumZlibModule = True to enable pure Xojo compression/decompression.
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
