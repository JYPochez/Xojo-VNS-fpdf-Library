#tag Module
Protected Module VNSZlibModuleTest
	#tag Method, Flags = &h0
		Sub TestMemoryBlockCompress()
		  // Test if Xojo's MemoryBlock.Compress produces zlib-compatible format
		  
		  Dim testData As String = "Hello World! This is a test string for compression. " + _
		  "It needs to be long enough to actually compress well. " + _
		  "More text here to ensure we get good compression ratio."

		  // Convert string to MemoryBlock
		  Dim mb As MemoryBlock = testData
		  
		  Try
		    Dim compressed As MemoryBlock = mb.Compress
		    
		    If compressed <> Nil And compressed.Size > 0 Then
		      // Check first 2 bytes for zlib header
		      Dim byte1 As UInt8 = compressed.Byte(0)
		      Dim byte2 As UInt8 = compressed.Byte(1)
		      
		      Dim result As String = "MemoryBlock.Compress Test Results:" + EndOfLine
		      result = result + "Original size: " + testData.LenB.ToString + " bytes" + EndOfLine
		      result = result + "Compressed size: " + compressed.Size.ToString + " bytes" + EndOfLine
		      result = result + "Compression ratio: " + Format((1 - compressed.Size / testData.LenB) * 100, "0.0") + "%" + EndOfLine
		      result = result + EndOfLine
		      result = result + "First byte: 0x" + Hex(byte1) + EndOfLine
		      result = result + "Second byte: 0x" + Hex(byte2) + EndOfLine
		      result = result + EndOfLine
		      
		      // Check for zlib header (0x78 = CMF byte, various second bytes for compression level)
		      If byte1 = &h78 Then
		        result = result + "✓ ZLIB FORMAT DETECTED!" + EndOfLine
		        result = result + "  This appears to be zlib-compatible compression." + EndOfLine
		        result = result + "  Should work with PDF FlateDecode filter." + EndOfLine
		        
		        // Test decompression
		        Try
		          Dim decompressed As MemoryBlock = compressed.Decompress
		          Dim decompressedStr As String = decompressed.StringValue(0, decompressed.Size)
		          
		          If decompressedStr = testData Then
		            result = result + "✓ DECOMPRESSION SUCCESSFUL!" + EndOfLine
		            result = result + "  Round-trip compression/decompression works." + EndOfLine
		          Else
		            result = result + "✗ Decompression produced different data" + EndOfLine
		          End If
		        Catch err As RuntimeException
		          result = result + "✗ Decompression failed: " + err.Message + EndOfLine
		        End Try
		        
		      Else
		        result = result + "✗ NOT ZLIB FORMAT" + EndOfLine
		        result = result + "  Expected first byte 0x78, got 0x" + Hex(byte1) + EndOfLine
		        result = result + "  This will NOT work with PDF FlateDecode." + EndOfLine
		      End If
		      
		      #If TargetDesktop Then
		        MessageBox result
		      #Else
		        System.DebugLog result
		      #EndIf
		      
		    Else
		      #If TargetDesktop Then
		        MessageBox "Compression returned Nil or empty result"
		      #Else
		        System.DebugLog "Compression returned Nil or empty result"
		      #EndIf
		    End If
		    
		  Catch err As RuntimeException
		    #If TargetDesktop Then
		      MessageBox "Compression failed: " + err.Message
		    #Else
		      System.DebugLog "Compression failed: " + err.Message
		    #EndIf
		  End Try
		  
		End Sub
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
End Module
#tag EndModule
