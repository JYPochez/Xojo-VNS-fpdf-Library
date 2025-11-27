#tag Class
Protected Class VNSPDFEncryption
	#tag Method, Flags = &h21
		Private Function ComputeEncryptionKey(userPadded As String, ownerEntry As String, permissions As Integer, fileID As String) As String
		  // Compute the file encryption key according to PDF specification
		  Dim hashInput As String
		  
		  // Build hash input: padded user password + owner entry + permissions + file ID
		  hashInput = userPadded + ownerEntry
		  
		  // Add permissions as 4 bytes (little-endian) - use MemoryBlock for binary
		  Dim mb1 As New MemoryBlock(1)
		  mb1.Byte(0) = permissions And &hFF
		  hashInput = hashInput + mb1.StringValue(0, 1)
		  
		  Dim mb2 As New MemoryBlock(1)
		  mb2.Byte(0) = (permissions And &hFF00) \ &h100
		  hashInput = hashInput + mb2.StringValue(0, 1)
		  
		  Dim mb3 As New MemoryBlock(1)
		  mb3.Byte(0) = (permissions And &hFF0000) \ &h10000
		  hashInput = hashInput + mb3.StringValue(0, 1)
		  
		  Dim mb4 As New MemoryBlock(1)
		  mb4.Byte(0) = (permissions And &hFF000000) \ &h1000000
		  hashInput = hashInput + mb4.StringValue(0, 1)
		  
		  // Add file ID
		  hashInput = hashInput + fileID
		  
		  // Hash it (mark all crypto outputs as ASCII immediately to prevent UTF-8 corruption)
		  Dim hash As String
		  Dim tempHash As String
		  
		  System.DebugLog "  ComputeEncryptionKey - hashInput.LenB: " + Str(VNSPDFModule.StringLenB(hashInput))
		  
		  If mRevision >= VNSPDFModule.gkEncryptionAES256 Then
		    tempHash = Crypto.SHA2_256(hashInput)
		    System.DebugLog "  ComputeEncryptionKey - IMMEDIATELY after SHA256, tempHash.LenB: " + Str(VNSPDFModule.StringLenB(tempHash))
		    hash = tempHash.DefineEncoding(Encodings.ASCII)
		    System.DebugLog "  ComputeEncryptionKey - After DefineEncoding, hash.LenB: " + Str(VNSPDFModule.StringLenB(hash))
		    If mRevision = VNSPDFModule.gkEncryptionAES256_PDF2 Then
		      tempHash = Crypto.SHA2_512(hashInput)
		      hash = tempHash.DefineEncoding(Encodings.ASCII)
		    End If
		  Else
		    tempHash = Crypto.MD5(hashInput)
		    System.DebugLog "  ComputeEncryptionKey - IMMEDIATELY after MD5, tempHash.LenB: " + Str(VNSPDFModule.StringLenB(tempHash)) + " (should be 16)"
		    hash = tempHash.DefineEncoding(Encodings.ASCII)
		    System.DebugLog "  ComputeEncryptionKey - After DefineEncoding, hash.LenB: " + Str(VNSPDFModule.StringLenB(hash))
		    
		    // For revision 3+, do 50 iterations
		    If mRevision >= VNSPDFModule.gkEncryptionRC4_128 Then
		      Dim i As Integer
		      For i = 1 To 50
		        tempHash = Crypto.MD5(hash.LeftBytes(mKeyLength))
		        hash = tempHash.DefineEncoding(Encodings.ASCII)
		      Next
		      System.DebugLog "  ComputeEncryptionKey - After 50 iterations, hash.LenB: " + Str(VNSPDFModule.StringLenB(hash))
		    End If
		  End If
		  
		  // Return key of appropriate length (already ASCII-encoded)
		  Dim result As String = hash.LeftBytes(mKeyLength)
		  System.DebugLog "  ComputeEncryptionKey - Final result.LenB: " + Str(VNSPDFModule.StringLenB(result)) + " (requested " + Str(mKeyLength) + ")"
		  Dim finalResult As String = result.DefineEncoding(Encodings.ASCII)
		  System.DebugLog "  ComputeEncryptionKey - After final DefineEncoding: " + Str(VNSPDFModule.StringLenB(finalResult))
		  System.DebugLog "  ComputeEncryptionKey - Final key HEX: " + ToHex(finalResult)
		  Return finalResult
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ComputeOwnerEntry(ownerPadded As String, userPadded As String) As String
		  // Compute the owner password entry (O) according to PDF specification
		  Dim hash As String
		  Dim tempHash As String

		  System.DebugLog "=== ComputeOwnerEntry START (Revision " + Str(mRevision) + ") ==="

		  If mRevision >= VNSPDFModule.gkEncryptionAES256 Then
		    // Revision 5-6: New algorithm with SHA-256/SHA-512 and salts

		    // Generate random 8-byte salts
		    Dim validationSalt As MemoryBlock = Crypto.GenerateRandomBytes(8)
		    mOwnerValidationSalt = validationSalt.StringValue(0, 8).DefineEncoding(Encodings.ASCII)

		    Dim keySalt As MemoryBlock = Crypto.GenerateRandomBytes(8)
		    mOwnerKeySalt = keySalt.StringValue(0, 8).DefineEncoding(Encodings.ASCII)

		    System.DebugLog "  Owner Validation Salt HEX: " + ToHex(mOwnerValidationSalt)
		    System.DebugLog "  Owner Key Salt HEX: " + ToHex(mOwnerKeySalt)

		    // Get UTF-8 encoded owner password
		    Dim ownerPasswordUTF8 As String = mOwnerPassword.DefineEncoding(Encodings.UTF8)
		    System.DebugLog "  Owner password UTF-8 length: " + Str(VNSPDFModule.StringLenB(ownerPasswordUTF8)) + " bytes"

		    // Compute hash for validation
		    // CRITICAL: Include U entry (first 48 bytes) in hash input!

		    If mRevision = 5 Then
		      // Revision 5: SHA-256(password + validation salt + U[0:48])
		      Dim hashInput As String = ownerPasswordUTF8 + mOwnerValidationSalt + mUserEntry.LeftBytes(48)
		      Dim hashMB As MemoryBlock = Crypto.SHA2_256(hashInput)
		      hash = hashMB.StringValue(0, hashMB.Size).DefineEncoding(Encodings.ASCII)
		      System.DebugLog "  Using SHA-256 for validation hash"
		    Else
		      // Revision 6: Use Algorithm 2.B (iterative AES-based hashing)
		      #If VNSPDFModule.hasPremiumEncryptionModule Then
		        hash = VNSPDFEncryptionPremium.ComputeHashR6(ownerPasswordUTF8, mOwnerValidationSalt, mUserEntry.LeftBytes(48))
		        System.DebugLog "  Using Algorithm 2.B (R6) for validation hash"
		      #Else
		        Raise New RuntimeException("Revision 6 requires premium Encryption module")
		      #EndIf
		    End If

		    System.DebugLog "  Validation hash HEX: " + ToHex(hash)

		    // O entry = hash (32 bytes) + validation salt (8 bytes) + key salt (8 bytes) = 48 bytes
		    Dim result As String = hash + mOwnerValidationSalt + mOwnerKeySalt
		    System.DebugLog "  Final O entry length: " + Str(VNSPDFModule.StringLenB(result)) + " bytes (should be 48)"
		    System.DebugLog "  Final O entry HEX: " + ToHex(result)
		    System.DebugLog "=== ComputeOwnerEntry END ==="
		    Return result
		  Else
		    // Revision 2-4: Use MD5 (mark as ASCII immediately)
		    tempHash = Crypto.MD5(ownerPadded)
		    hash = tempHash.DefineEncoding(Encodings.ASCII)

		    // For revision 3+, do 50 iterations
		    If mRevision >= VNSPDFModule.gkEncryptionRC4_128 Then
		      Dim i As Integer
		      For i = 1 To 50
		        tempHash = Crypto.MD5(hash)
		        hash = tempHash.DefineEncoding(Encodings.ASCII)
		      Next
		    End If
		  End If

		  // Extract key (already ASCII-encoded)
		  Dim encKey As String = hash.LeftBytes(mKeyLength)
		  encKey = encKey.DefineEncoding(Encodings.ASCII)

		  System.DebugLog "  encKey.LenB: " + Str(VNSPDFModule.StringLenB(encKey))
		  System.DebugLog "  encKey HEX: " + ToHex(encKey)

		  // Encrypt user password with owner key
		  Dim encrypted As String
		  If mRevision >= 5 Then
		    // Revision 5/6: Use AES for password entries (no iterations)
		    System.DebugLog "  About to EncryptAESPassword (iteration 0)"
		    encrypted = EncryptAESPassword(userPadded, encKey)
		    System.DebugLog "  After EncryptAESPassword: encrypted.LenB = " + Str(VNSPDFModule.StringLenB(encrypted))
		  Else
		    // Revision 2-4: Use RC4 for password entries
		    encrypted = EncryptRC4(userPadded, encKey)
		  End If

		  // For revision 3-4, do 19 additional iterations with modified keys
		  // CRITICAL: Revision 4 still uses RC4 for password entries, just like Revision 3!
		  // AES in Revision 4 is ONLY for content streams, NOT for password validation
		  If mRevision >= 3 And mRevision <= 4 Then
		    Dim i As Integer
		    For i = 1 To 19
		      Dim newKey As String = ModifyKey(encKey, i)
		      encrypted = EncryptRC4(encrypted, newKey)
		    Next
		  End If

		  System.DebugLog "  Final encrypted.LenB: " + Str(VNSPDFModule.StringLenB(encrypted))
		  System.DebugLog "  Final encrypted HEX: " + ToHex(encrypted)
		  System.DebugLog "=== ComputeOwnerEntry END ==="

		  Return encrypted
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ComputeUserEntry(encryptionKey As String, fileID As String) As String
		  // Compute the user password entry (U) according to PDF specification
		  If mRevision >= 5 Then
		    // Revision 5-6: New algorithm with SHA-256/SHA-512 and salts
		    System.DebugLog "=== ComputeUserEntry START (Revision " + Str(mRevision) + ") ==="

		    // Generate random 8-byte salts
		    Dim validationSalt As MemoryBlock = Crypto.GenerateRandomBytes(8)
		    mUserValidationSalt = validationSalt.StringValue(0, 8).DefineEncoding(Encodings.ASCII)

		    Dim keySalt As MemoryBlock = Crypto.GenerateRandomBytes(8)
		    mUserKeySalt = keySalt.StringValue(0, 8).DefineEncoding(Encodings.ASCII)

		    System.DebugLog "  User Validation Salt HEX: " + ToHex(mUserValidationSalt)
		    System.DebugLog "  User Key Salt HEX: " + ToHex(mUserKeySalt)

		    // Get UTF-8 encoded user password
		    Dim userPasswordUTF8 As String = mUserPassword.DefineEncoding(Encodings.UTF8)
		    System.DebugLog "  User password UTF-8 length: " + Str(VNSPDFModule.StringLenB(userPasswordUTF8)) + " bytes"

		    // Compute hash for validation
		    Dim hash As String

		    If mRevision = 5 Then
		      // Revision 5: SHA-256(password + validation salt)
		      Dim hashInput As String = userPasswordUTF8 + mUserValidationSalt
		      Dim hashMB As MemoryBlock = Crypto.SHA2_256(hashInput)
		      hash = hashMB.StringValue(0, hashMB.Size).DefineEncoding(Encodings.ASCII)
		      System.DebugLog "  Using SHA-256 for validation hash"
		    Else
		      // Revision 6: Use Algorithm 2.B (iterative AES-based hashing)
		      #If VNSPDFModule.hasPremiumEncryptionModule Then
		        hash = VNSPDFEncryptionPremium.ComputeHashR6(userPasswordUTF8, mUserValidationSalt, "")
		        System.DebugLog "  Using Algorithm 2.B (R6) for validation hash"
		      #Else
		        Raise New RuntimeException("Revision 6 requires premium Encryption module")
		      #EndIf
		    End If

		    System.DebugLog "  Validation hash HEX: " + ToHex(hash)

		    // U entry = hash (32 bytes) + validation salt (8 bytes) + key salt (8 bytes) = 48 bytes
		    Dim result As String = hash + mUserValidationSalt + mUserKeySalt
		    System.DebugLog "  Final U entry length: " + Str(VNSPDFModule.StringLenB(result)) + " bytes (should be 48)"
		    System.DebugLog "  Final U entry HEX: " + ToHex(result)
		    System.DebugLog "=== ComputeUserEntry END ==="

		    Return result
		  ElseIf mRevision >= VNSPDFModule.gkEncryptionRC4_128 Then
		    // Revision 3-4: MD5 hash of padding + file ID (mark as ASCII)
		    System.DebugLog "=== ComputeUserEntry START (Revision " + Str(mRevision) + ") ==="
		    System.DebugLog "  encryptionKey.LenB: " + Str(VNSPDFModule.StringLenB(encryptionKey))
		    System.DebugLog "  encryptionKey HEX: " + ToHex(encryptionKey)
		    System.DebugLog "  fileID.LenB: " + Str(VNSPDFModule.StringLenB(fileID))
		    System.DebugLog "  fileID HEX: " + ToHex(fileID)
		    Dim tempHash As String = Crypto.MD5(kPaddingString + fileID)
		    Dim hash As String = tempHash.DefineEncoding(Encodings.ASCII)
		    System.DebugLog "  hash (MD5 of padding+fileID).LenB: " + Str(VNSPDFModule.StringLenB(hash))
		    System.DebugLog "  hash HEX: " + ToHex(hash)
		    Dim encrypted As String

		    // Revision 3-4: Use RC4-128 with 20 iterations (1 + 19)
		    // CRITICAL: Revision 4 still uses RC4 for password entries!
		    // AES in Revision 4 is ONLY for content streams, NOT for password validation
		    System.DebugLog "  Encrypting with RC4 (20 iterations for Revision 3-4)..."
		    encrypted = EncryptRC4(hash, encryptionKey)

		    // Do 19 additional iterations with modified keys
		    Dim i As Integer
		    For i = 1 To 19
		      Dim newKey As String = ModifyKey(encryptionKey, i)
		      encrypted = EncryptRC4(encrypted, newKey)
		    Next
		    System.DebugLog "  encrypted.LenB: " + Str(VNSPDFModule.StringLenB(encrypted))
		    System.DebugLog "  encrypted HEX: " + ToHex(encrypted)

		    // Pad to 32 bytes with random data
		    Dim randomBytes As MemoryBlock = Crypto.GenerateRandomBytes(16)
		    Dim result As String = encrypted + randomBytes.StringValue(0, randomBytes.Size)
		    System.DebugLog "  Final U entry.LenB: " + Str(VNSPDFModule.StringLenB(result))
		    System.DebugLog "  Final U entry HEX: " + ToHex(result)
		    System.DebugLog "=== ComputeUserEntry END ==="
		    Return result
		  Else
		    // Revision 2: Simply encrypt padding string
		    Return EncryptRC4(kPaddingString, encryptionKey)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ComputeOwnerEncryptionEntry(fileEncryptionKey As String) As String
		#Pragma Unused fileEncryptionKey
		  // Compute the OE (owner encryption) entry for Revision 5-6
		  // OE = AES-256-CBC(file encryption key, key derived from owner password)

		  System.DebugLog "=== ComputeOwnerEncryptionEntry START ==="

		  // Use the key salt that was generated in ComputeOwnerEntry()
		  System.DebugLog "  Owner Key Salt HEX: " + ToHex(mOwnerKeySalt)

		  // Get UTF-8 encoded owner password
		  Dim ownerPasswordUTF8 As String = mOwnerPassword.DefineEncoding(Encodings.UTF8)

		  // Compute intermediate hash for key derivation
		  // Use U entry (first 48 bytes) in the hash input
		  Dim intermediateHash As String

		  If mRevision = 5 Then
		    // Revision 5: SHA-256
		    Dim hashInput As String = ownerPasswordUTF8 + mOwnerKeySalt + mUserEntry.LeftBytes(48)
		    Dim hashMB As MemoryBlock = Crypto.SHA2_256(hashInput)
		    intermediateHash = hashMB.StringValue(0, hashMB.Size).DefineEncoding(Encodings.ASCII)
		  Else
		    // Revision 6: Use Algorithm 2.B (iterative AES-based hashing)
		    #If VNSPDFModule.hasPremiumEncryptionModule Then
		      intermediateHash = VNSPDFEncryptionPremium.ComputeHashR6(ownerPasswordUTF8, mOwnerKeySalt, mUserEntry.LeftBytes(48))
		    #Else
		      Raise New RuntimeException("Revision 6 requires premium Encryption module")
		    #EndIf
		  End If

		  System.DebugLog "  Intermediate hash HEX: " + ToHex(intermediateHash)

		  // Encrypt the file encryption key with AES-256 CBC using zero IV
		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    Dim zeroIVMB As New MemoryBlock(16)
		    Dim i As Integer
		    For i = 0 To 15
		      zeroIVMB.Byte(i) = 0
		    Next
		    Dim zeroIV As String = zeroIVMB.StringValue(0, 16).DefineEncoding(Encodings.ASCII)
		    Dim oe As String = VNSPDFEncryptionPremium.EncryptAESCBCNoPadding(fileEncryptionKey, intermediateHash, zeroIV)
		    System.DebugLog "  OE entry length: " + Str(VNSPDFModule.StringLenB(oe)) + " bytes"
		    System.DebugLog "=== ComputeOwnerEncryptionEntry END ==="
		    Return oe
		  #Else
		    Raise New RuntimeException("AES-256 encryption requires premium Encryption module")
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ComputeUserEncryptionEntry(fileEncryptionKey As String) As String
		#Pragma Unused fileEncryptionKey
		  // Compute the UE (user encryption) entry for Revision 5-6
		  // UE = AES-256-CBC(file encryption key, key derived from user password)

		  System.DebugLog "=== ComputeUserEncryptionEntry START ==="

		  // Use the key salt that was generated in ComputeUserEntry()
		  System.DebugLog "  User Key Salt HEX: " + ToHex(mUserKeySalt)

		  // Get UTF-8 encoded user password
		  Dim userPasswordUTF8 As String = mUserPassword.DefineEncoding(Encodings.UTF8)

		  // Compute intermediate hash for key derivation
		  Dim intermediateHash As String

		  If mRevision = 5 Then
		    // Revision 5: SHA-256
		    Dim hashInput As String = userPasswordUTF8 + mUserKeySalt
		    Dim hashMB As MemoryBlock = Crypto.SHA2_256(hashInput)
		    intermediateHash = hashMB.StringValue(0, hashMB.Size).DefineEncoding(Encodings.ASCII)
		  Else
		    // Revision 6: Use Algorithm 2.B (iterative AES-based hashing)
		    #If VNSPDFModule.hasPremiumEncryptionModule Then
		      intermediateHash = VNSPDFEncryptionPremium.ComputeHashR6(userPasswordUTF8, mUserKeySalt, "")
		    #Else
		      Raise New RuntimeException("Revision 6 requires premium Encryption module")
		    #EndIf
		  End If

		  System.DebugLog "  Intermediate hash HEX: " + ToHex(intermediateHash)

		  // Encrypt the file encryption key with AES-256 CBC using zero IV
		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    Dim zeroIVMB As New MemoryBlock(16)
		    Dim i As Integer
		    For i = 0 To 15
		      zeroIVMB.Byte(i) = 0
		    Next
		    Dim zeroIV As String = zeroIVMB.StringValue(0, 16).DefineEncoding(Encodings.ASCII)
		    Dim ue As String = VNSPDFEncryptionPremium.EncryptAESCBCNoPadding(fileEncryptionKey, intermediateHash, zeroIV)
		    System.DebugLog "  UE entry length: " + Str(VNSPDFModule.StringLenB(ue)) + " bytes"
		    System.DebugLog "=== ComputeUserEncryptionEntry END ==="
		    Return ue
		  #Else
		    Raise New RuntimeException("AES-256 encryption requires premium Encryption module")
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ComputePermsEntry() As String
		  // Compute the Perms entry for Revision 5-6
		  // Perms = AES-256-ECB(P (4 bytes) + 0xFFFFFFFF (4 bytes) + "Tadb" (4 bytes), file encryption key)[0:16]

		  System.DebugLog "=== ComputePermsEntry START ==="

		  // Build 16-byte input: permissions (4 bytes, little-endian) + 0xFFFFFFFF (4 bytes) + "Tadb" (4 bytes)
		  Dim permsInput As String = ""

		  // Add permissions as 4 bytes (little-endian)
		  Dim mb1 As New MemoryBlock(1)
		  mb1.Byte(0) = mPermissions And &hFF
		  permsInput = permsInput + mb1.StringValue(0, 1)

		  Dim mb2 As New MemoryBlock(1)
		  mb2.Byte(0) = (mPermissions And &hFF00) \ &h100
		  permsInput = permsInput + mb2.StringValue(0, 1)

		  Dim mb3 As New MemoryBlock(1)
		  mb3.Byte(0) = (mPermissions And &hFF0000) \ &h10000
		  permsInput = permsInput + mb3.StringValue(0, 1)

		  Dim mb4 As New MemoryBlock(1)
		  mb4.Byte(0) = (mPermissions And &hFF000000) \ &h1000000
		  permsInput = permsInput + mb4.StringValue(0, 1)

		  // Add 0xFFFFFFFF (4 bytes)
		  Dim ffMB As New MemoryBlock(4)
		  ffMB.Byte(0) = &hFF
		  ffMB.Byte(1) = &hFF
		  ffMB.Byte(2) = &hFF
		  ffMB.Byte(3) = &hFF
		  permsInput = permsInput + ffMB.StringValue(0, 4)

		  // Add "Tadb" (4 bytes)
		  permsInput = permsInput + "Tadb"

		  // Add 4 random bytes to make it 16 bytes total
		  Dim randomBytes As MemoryBlock = Crypto.GenerateRandomBytes(4)
		  permsInput = permsInput + randomBytes.StringValue(0, 4)

		  permsInput = permsInput.DefineEncoding(Encodings.ASCII)
		  System.DebugLog "  Perms input (16 bytes) HEX: " + ToHex(permsInput)

		  // Encrypt with AES-256-ECB (no padding needed, exactly 16 bytes)
		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    Dim perms As String = VNSPDFEncryptionPremium.EncryptAESECB(permsInput, mEncryptionKey)
		    System.DebugLog "  Perms entry (16 bytes) HEX: " + ToHex(perms)
		    System.DebugLog "=== ComputePermsEntry END ==="
		    Return perms
		  #Else
		    Raise New RuntimeException("AES-256 encryption requires premium Encryption module")
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(revision As Integer)
		  // Initialize encryption with specified revision
		  // Revision 2: 40-bit RC4 (PDF 1.1-1.3) - DEPRECATED
		  // Revision 3: 128-bit RC4 (PDF 1.4) - DEPRECATED
		  // Revision 4: 128-bit AES (PDF 1.6+) - GOOD
		  // Revision 5: 256-bit AES (PDF 1.7 Extension Level 3) - BEST
		  // Revision 6: 256-bit AES (PDF 2.0) - BEST
		  
		  mRevision = revision
		  
		  Select Case revision
		  Case 2
		    mKeyLength = 5  // 40-bit
		    mAlgorithm = "RC4"
		  Case 3
		    mKeyLength = 16  // 128-bit
		    mAlgorithm = "RC4"
		  Case 4
		    mKeyLength = 16  // 128-bit
		    mAlgorithm = "AES-128"
		  Case 5, 6
		    mKeyLength = 32  // 256-bit
		    mAlgorithm = "AES-256"
		  Else
		    Raise New RuntimeException("Invalid encryption revision: " + Str(revision))
		  End Select
		  
		  mPermissions = -1  // All permissions by default
		  mEncrypted = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncryptAES(data As String, key As String) As String
		  // Encrypt data using AES in CBC mode
		  // Delegate to premium module which uses pure Xojo AES implementation

		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    // Generate random IV (16 bytes for AES)
		    Dim iv As String = VNSPDFEncryptionPremium.GenerateRandomIV()

		    System.DebugLog "EncryptAES - Input data.LenB: " + Str(VNSPDFModule.StringLenB(data))
		    System.DebugLog "EncryptAES - Input key.LenB: " + Str(VNSPDFModule.StringLenB(key))
		    System.DebugLog "EncryptAES - IV.LenB: " + Str(VNSPDFModule.StringLenB(iv))

		    // Premium module enabled - use pure Xojo AES-CBC (with automatic PKCS7 padding)
		    Dim encrypted As String = VNSPDFEncryptionPremium.EncryptAESCBC(data, key, iv)

		    System.DebugLog "EncryptAES - Encrypted.LenB: " + Str(VNSPDFModule.StringLenB(encrypted))

		    // Return IV + encrypted data (IV is needed for decryption)
		    Dim result As String = iv + encrypted
		    Return result.DefineEncoding(Encodings.ASCII)
		  #Else
		    #Pragma Unused data
		    #Pragma Unused key
		    // This should never happen because SetProtection() gates revision 4+
		    // But if it does, fail safely
		    Raise New RuntimeException("AES encryption requires premium Encryption module")
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncryptAESPassword(data As String, key As String) As String
		  // Encrypt password entries using AES-ECB mode WITHOUT padding
		  // Delegate to premium module which uses pure Xojo AES implementation
		  // This solves the Xojo Crypto.AESEncrypt() PKCS7 padding issue

		  // Verify data size is multiple of 16 bytes (AES block size)
		  If VNSPDFModule.StringLenB(data) Mod 16 <> 0 Then
		    System.DebugLog "EncryptAESPassword - ERROR: Data size not multiple of 16: " + Str(VNSPDFModule.StringLenB(data))
		    Return ""
		  End If

		  #If VNSPDFModule.hasPremiumEncryptionModule Then
		    // Premium module enabled - use pure Xojo AES-ECB (no PKCS7 padding issues!)
		    System.DebugLog "EncryptAESPassword - Using premium EncryptAESECB (input: " + Str(VNSPDFModule.StringLenB(data)) + " bytes)"
		    Dim encrypted As String = VNSPDFEncryptionPremium.EncryptAESECB(data, key)
		    System.DebugLog "EncryptAESPassword - Output: " + Str(VNSPDFModule.StringLenB(encrypted)) + " bytes"
		    Return encrypted
		  #Else
		    #Pragma Unused data
		    #Pragma Unused key
		    // This should never happen because SetProtection() gates revision 4+
		    // But if it does, fail safely
		    Raise New RuntimeException("AES encryption requires premium Encryption module")
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptObject(plaintext As String, objectNumber As Integer, generationNumber As Integer) As String
		  // Encrypt a PDF object (string or stream)
		  If Not mEncrypted Then
		    Return plaintext
		  End If

		  System.DebugLog "=== EncryptObject START ==="
		  System.DebugLog "  Revision: " + Str(mRevision)
		  System.DebugLog "  Object #: " + Str(objectNumber)
		  System.DebugLog "  Plaintext length: " + Str(VNSPDFModule.StringLenB(plaintext)) + " bytes"

		  // CRITICAL: Revisions 5-6 use file encryption key DIRECTLY (no per-object key derivation!)
		  If mRevision >= 5 Then
		    System.DebugLog "  Using file encryption key directly (Revision 5-6)"
		    System.DebugLog "  File encryption key length: " + Str(VNSPDFModule.StringLenB(mEncryptionKey)) + " bytes"
		    Dim encrypted As String = EncryptAES(plaintext, mEncryptionKey)
		    System.DebugLog "  Encrypted length: " + Str(VNSPDFModule.StringLenB(encrypted)) + " bytes"
		    System.DebugLog "=== EncryptObject END ==="
		    Return encrypted
		  End If

		  // Revisions 2-4: Compute object-specific encryption key
		  Dim objectKey As String = mEncryptionKey

		  // Append object number (3 bytes) and generation number (2 bytes) - use MemoryBlock for binary
		  Dim objByte1 As New MemoryBlock(1)
		  objByte1.Byte(0) = objectNumber And &hFF
		  objectKey = objectKey + objByte1.StringValue(0, 1)

		  Dim objByte2 As New MemoryBlock(1)
		  objByte2.Byte(0) = (objectNumber And &hFF00) \ &h100
		  objectKey = objectKey + objByte2.StringValue(0, 1)

		  Dim objByte3 As New MemoryBlock(1)
		  objByte3.Byte(0) = (objectNumber And &hFF0000) \ &h10000
		  objectKey = objectKey + objByte3.StringValue(0, 1)

		  Dim genByte1 As New MemoryBlock(1)
		  genByte1.Byte(0) = generationNumber And &hFF
		  objectKey = objectKey + genByte1.StringValue(0, 1)

		  Dim genByte2 As New MemoryBlock(1)
		  genByte2.Byte(0) = (generationNumber And &hFF00) \ &h100
		  objectKey = objectKey + genByte2.StringValue(0, 1)

		  // For AES (Revision 4), append "sAlT" (literal string)
		  If mRevision >= 4 Then
		    objectKey = objectKey + "sAlT"
		  End If

		  // Hash to get final key (mark as ASCII immediately)
		  Dim finalKey As String
		  Dim tempHash As String = Crypto.MD5(objectKey)
		  Dim hash As String = tempHash.DefineEncoding(Encodings.ASCII)
		  Dim result As String = hash.LeftBytes(Min(mKeyLength + 5, 16))
		  finalKey = result.DefineEncoding(Encodings.ASCII)

		  System.DebugLog "  Using per-object key (Revision 2-4)"
		  System.DebugLog "  Final key length: " + Str(VNSPDFModule.StringLenB(finalKey)) + " bytes"

		  // Encrypt based on algorithm
		  Dim encrypted As String
		  If mRevision >= 4 Then
		    encrypted = EncryptAES(plaintext, finalKey)
		  Else
		    encrypted = EncryptRC4(plaintext, finalKey)
		  End If

		  System.DebugLog "  Encrypted length: " + Str(VNSPDFModule.StringLenB(encrypted)) + " bytes"
		  System.DebugLog "=== EncryptObject END ==="
		  Return encrypted
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncryptRC4(data As String, key As String) As String
		  // Encrypt data using RC4 stream cipher
		  // For revision 2 (40-bit RC4): Use local implementation (FREE)
		  // For revision 3+ (128-bit RC4): Delegate to premium module (PREMIUM)

		  // Check if this is revision 3+ RC4-128 (requires premium module)
		  If mRevision >= 3 Then
		    #If VNSPDFModule.hasPremiumEncryptionModule Then
		      // Premium module enabled - use premium RC4-128 implementation
		      Return VNSPDFEncryptionPremium.EncryptRC4(data, key)
		    #Else
		      #Pragma Unused data
		      #Pragma Unused key
		      // This should never happen because SetProtection() gates revision 3+
		      // But if it does, fail safely
		      Raise New RuntimeException("RC4-128 encryption requires premium Encryption module")
		    #EndIf
		  End If

		  // Revision 2 (RC4-40) - FREE VERSION implementation
		  // RC4 implementation for PDF (simple stream cipher)
		  // CRITICAL: Use MemoryBlock for binary bytes to avoid UTF-8 expansion of bytes > 127

		  // CRITICAL: Mark inputs as ASCII to ensure byte-level operations work correctly
		  Dim dataBinary As String = data.DefineEncoding(Encodings.ASCII)
		  Dim keyBinary As String = key.DefineEncoding(Encodings.ASCII)

		  // Initialize S-box
		  Dim s(256) As Integer
		  Dim i As Integer
		  For i = 0 To 255
		    s(i) = i
		  Next

		  // Key scheduling algorithm (KSA)
		  Dim j As Integer = 0
		  Dim keyLen As Integer = VNSPDFModule.StringLenB(keyBinary)
		  For i = 0 To 255
		    Dim keyByteStr As String = keyBinary.MiddleBytes(i Mod keyLen, 1)
		    Dim keyByteMB As MemoryBlock = keyByteStr
		    j = (j + s(i) + keyByteMB.Byte(0)) Mod 256
		    // Swap s(i) and s(j)
		    Dim temp As Integer = s(i)
		    s(i) = s(j)
		    s(j) = temp
		  Next

		  // Pseudo-random generation algorithm (PRGA)
		  Dim result As String = ""
		  i = 0
		  j = 0
		  Dim k As Integer
		  For k = 0 To VNSPDFModule.StringLenB(dataBinary) - 1
		    i = (i + 1) Mod 256
		    j = (j + s(i)) Mod 256
		    // Swap s(i) and s(j)
		    Dim temp As Integer = s(i)
		    s(i) = s(j)
		    s(j) = temp
		    Dim keyByte As Integer = s((s(i) + s(j)) Mod 256)
		    // Get data byte using MiddleBytes (0-based) and MemoryBlock
		    Dim dataByteStr As String = dataBinary.MiddleBytes(k, 1)
		    Dim dataByteMB As MemoryBlock = dataByteStr
		    Dim xorResult As Integer = dataByteMB.Byte(0) Xor keyByte
		    // Use MemoryBlock for binary byte (no UTF-8 expansion!)
		    Dim resultByte As New MemoryBlock(1)
		    resultByte.Byte(0) = xorResult
		    result = result + resultByte.StringValue(0, 1)
		  Next

		  // CRITICAL: Mark result as ASCII to prevent UTF-8 interpretation
		  Return result.DefineEncoding(Encodings.ASCII)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GenerateKeys(fileID As String)
		  // Generate encryption keys based on passwords and permissions
		  mFileID = fileID

		  System.DebugLog "=== GenerateKeys START (Revision " + Str(mRevision) + ") ==="
		  System.DebugLog "GenerateKeys - fileID.LenB: " + Str(VNSPDFModule.StringLenB(fileID))

		  If mRevision >= 5 Then
		    // Revision 5-6: Use new AES-256 algorithm with random file encryption key
		    System.DebugLog "GenerateKeys - Using Revision 5-6 algorithm (AES-256)"

		    // Generate random 32-byte file encryption key (NOT password-derived!)
		    Dim randomKey As MemoryBlock = Crypto.GenerateRandomBytes(32)
		    mEncryptionKey = randomKey.StringValue(0, 32).DefineEncoding(Encodings.ASCII)
		    System.DebugLog "GenerateKeys - Generated random encryption key: " + Str(VNSPDFModule.StringLenB(mEncryptionKey)) + " bytes"
		    System.DebugLog "GenerateKeys - Key HEX: " + ToHex(mEncryptionKey)

		    // Compute U and UE entries
		    mUserEntry = ComputeUserEntry(mEncryptionKey, fileID)
		    mUserEncryptionEntry = ComputeUserEncryptionEntry(mEncryptionKey)
		    System.DebugLog "GenerateKeys - mUserEntry.LenB: " + Str(VNSPDFModule.StringLenB(mUserEntry)) + " (should be 48)"
		    System.DebugLog "GenerateKeys - mUserEncryptionEntry.LenB: " + Str(VNSPDFModule.StringLenB(mUserEncryptionEntry)) + " (should be 32)"

		    // Compute O and OE entries
		    mOwnerEntry = ComputeOwnerEntry("", "")  // Will use mUserEntry internally for Rev 5-6
		    mOwnerEncryptionEntry = ComputeOwnerEncryptionEntry(mEncryptionKey)
		    System.DebugLog "GenerateKeys - mOwnerEntry.LenB: " + Str(VNSPDFModule.StringLenB(mOwnerEntry)) + " (should be 48)"
		    System.DebugLog "GenerateKeys - mOwnerEncryptionEntry.LenB: " + Str(VNSPDFModule.StringLenB(mOwnerEncryptionEntry)) + " (should be 32)"

		    // Compute Perms entry
		    mPermsEntry = ComputePermsEntry()
		    System.DebugLog "GenerateKeys - mPermsEntry.LenB: " + Str(VNSPDFModule.StringLenB(mPermsEntry)) + " (should be 16)"

		  Else
		    // Revision 2-4: Use original algorithm with password-derived key
		    System.DebugLog "GenerateKeys - Using Revision 2-4 algorithm"

		    // Pad passwords to 32 bytes
		    Dim userPadded As String = PadPassword(mUserPassword)
		    Dim ownerPadded As String = PadPassword(mOwnerPassword)

		    System.DebugLog "GenerateKeys - userPadded.LenB: " + Str(VNSPDFModule.StringLenB(userPadded))
		    System.DebugLog "GenerateKeys - ownerPadded.LenB: " + Str(VNSPDFModule.StringLenB(ownerPadded))

		    // Generate owner password entry (O)
		    mOwnerEntry = ComputeOwnerEntry(ownerPadded, userPadded)
		    System.DebugLog "GenerateKeys - mOwnerEntry.LenB: " + Str(VNSPDFModule.StringLenB(mOwnerEntry))

		    // Generate encryption key
		    mEncryptionKey = ComputeEncryptionKey(userPadded, mOwnerEntry, mPermissions, fileID)
		    System.DebugLog "GenerateKeys - mEncryptionKey.LenB: " + Str(VNSPDFModule.StringLenB(mEncryptionKey)) + " (should be " + Str(mKeyLength) + ")"

		    // Generate user password entry (U)
		    mUserEntry = ComputeUserEntry(mEncryptionKey, fileID)
		    System.DebugLog "GenerateKeys - mUserEntry.LenB: " + Str(VNSPDFModule.StringLenB(mUserEntry))
		  End If

		  System.DebugLog "=== GenerateKeys END ==="

		  mEncrypted = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAlgorithm() As String
		  Return mAlgorithm
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetEncryptionDictionary() As String
		  // Generate the encryption dictionary for PDF output
		  If Not mEncrypted Then
		    Return ""
		  End If
		  
		  Dim dict As String = "<<"
		  dict = dict + "/Filter /Standard"
		  
		  // Add revision and algorithm
		  Select Case mRevision
		  Case 2
		    dict = dict + " /V 1 /R 2"
		    dict = dict + " /Length 40"
		  Case 3
		    dict = dict + " /V 2 /R 3"
		    dict = dict + " /Length 128"
		  Case 4
		    dict = dict + " /V 4 /R 4"
		    dict = dict + " /Length 128"
		    dict = dict + " /CF <</StdCF <</AuthEvent /DocOpen /CFM /AESV2 /Length 16>>>>"
		    dict = dict + " /StmF /StdCF /StrF /StdCF"
		  Case 5
		    dict = dict + " /V 5 /R 5"
		    dict = dict + " /Length 256"
		    dict = dict + " /CF <</StdCF <</AuthEvent /DocOpen /CFM /AESV3 /Length 32>>>>"
		    dict = dict + " /StmF /StdCF /StrF /StdCF"
		  Case 6
		    dict = dict + " /V 5 /R 6"
		    dict = dict + " /Length 256"
		    dict = dict + " /CF <</StdCF <</AuthEvent /DocOpen /CFM /AESV3 /Length 32>>>>"
		    dict = dict + " /StmF /StdCF /StrF /StdCF"
		  End Select
		  
		  // Add owner entry (O) - hex encoded
		  dict = dict + " /O <" + ToHex(mOwnerEntry) + ">"

		  // Add user entry (U) - hex encoded
		  dict = dict + " /U <" + ToHex(mUserEntry) + ">"

		  // Add permissions (P)
		  dict = dict + " /P " + Str(mPermissions)

		  // For Revisions 5-6, add OE, UE, and Perms entries
		  If mRevision >= 5 Then
		    // Add OE (owner encryption) entry - hex encoded
		    dict = dict + " /OE <" + ToHex(mOwnerEncryptionEntry) + ">"

		    // Add UE (user encryption) entry - hex encoded
		    dict = dict + " /UE <" + ToHex(mUserEncryptionEntry) + ">"

		    // Add Perms entry - hex encoded
		    dict = dict + " /Perms <" + ToHex(mPermsEntry) + ">"
		  End If

		  dict = dict + ">>"

		  Return dict
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRevision() As Integer
		  Return mRevision
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsEncrypted() As Boolean
		  Return mEncrypted
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ModifyKey(key As String, iteration As Integer) As String
		  // Modify key by XORing each byte with iteration number
		  // CRITICAL: Use MemoryBlock to avoid UTF-8 corruption from Chr() calls
		  
		  // Convert key String to MemoryBlock to work with raw bytes
		  Dim keyMB As MemoryBlock = key.DefineEncoding(Encodings.ASCII)
		  
		  // Create result MemoryBlock of same size
		  Dim resultMB As New MemoryBlock(keyMB.Size)
		  
		  // XOR each byte directly (no Chr() calls that cause UTF-8 expansion!)
		  Dim i As Integer
		  For i = 0 To keyMB.Size - 1
		    resultMB.Byte(i) = keyMB.Byte(i) Xor iteration
		  Next
		  
		  // Convert result MemoryBlock back to String
		  Dim result As String = resultMB.StringValue(0, resultMB.Size)
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PadPassword(password As String) As String
		  // Pad or truncate password to 32 bytes using standard PDF padding
		  Dim padded As String = password
		  
		  // Truncate if longer than 32 bytes
		  If VNSPDFModule.StringLenB(padded) > 32 Then
		    padded = padded.LeftBytes(32)
		  End If
		  
		  // Pad with standard padding string if shorter
		  If VNSPDFModule.StringLenB(padded) < 32 Then
		    padded = padded + kPaddingString.LeftBytes(32 - VNSPDFModule.StringLenB(padded))
		  End If
		  
		  Return padded
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PKCS7Pad(data As String, blockSize As Integer) As String
		  // Pad data using PKCS#7 padding scheme (API2) - use MemoryBlock for binary bytes
		  Dim padLen As Integer = blockSize - (VNSPDFModule.StringLenB(data) Mod blockSize)
		  Dim padding As String = ""
		  Dim i As Integer
		  For i = 1 To padLen
		    Dim paddingByte As New MemoryBlock(1)
		    paddingByte.Byte(0) = padLen
		    padding = padding + paddingByte.StringValue(0, 1)
		  Next
		  // Return as ASCII-encoded string to preserve raw binary bytes
		  Dim result As String = data + padding
		  Return result.DefineEncoding(Encodings.ASCII)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RemovePKCS7Padding(data As String) As String
		  // Remove PKCS7 padding from encrypted data
		  // PKCS7 padding: last byte indicates how many padding bytes were added
		  // For example, if 16 bytes of padding: [data... 0x10 0x10 0x10 ... 0x10]
		  
		  If VNSPDFModule.StringLenB(data) = 0 Then Return data
		  
		  // Get padding length from last byte
		  Dim lastByteStr As String = data.RightBytes(1)
		  Dim lastByteMB As MemoryBlock = lastByteStr
		  Dim lastByte As Integer = lastByteMB.Byte(0)
		  Dim paddingLen As Integer = lastByte
		  
		  // Sanity check: padding length must be 1-16
		  If paddingLen < 1 Or paddingLen > 16 Then
		    System.DebugLog "RemovePKCS7Padding - Invalid padding length: " + Str(paddingLen)
		    Return data  // Return as-is if invalid
		  End If
		  
		  // Sanity check: padding length must not exceed data length
		  If paddingLen > VNSPDFModule.StringLenB(data) Then
		    System.DebugLog "RemovePKCS7Padding - Padding length exceeds data length"
		    Return data
		  End If
		  
		  // Remove padding bytes
		  Dim result As String = data.LeftBytes(VNSPDFModule.StringLenB(data) - paddingLen)
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPasswords(userPassword As String, ownerPassword As String)
		  // Set user and owner passwords
		  mUserPassword = userPassword
		  mOwnerPassword = If(ownerPassword = "", userPassword, ownerPassword)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPermissions(allowPrint As Boolean, allowModify As Boolean, allowCopy As Boolean, allowAnnotate As Boolean, allowFillForms As Boolean, allowExtract As Boolean, allowAssemble As Boolean, allowPrintHighQuality As Boolean)
		  // Set document permissions according to PDF specification (all 8 permission bits)
		  // Permission bits: 1 = allowed, 0 = restricted
		  //
		  // Parameters:
		  //   allowPrint: Allow printing (low quality) - Bit 3
		  //   allowModify: Allow document modification - Bit 4
		  //   allowCopy: Allow copying text and graphics - Bit 5
		  //   allowAnnotate: Allow adding/modifying annotations and signatures - Bit 6
		  //   allowFillForms: Allow filling in form fields - Bit 8 (Revision 3+)
		  //   allowExtract: Allow text extraction for accessibility - Bit 9 (Revision 3+)
		  //   allowAssemble: Allow page insertion/rotation/deletion - Bit 10 (Revision 3+)
		  //   allowPrintHighQuality: Allow high-resolution printing - Bit 11 (Revision 3+)

		  Dim p As Integer

		  // Base permissions value depends on revision
		  If mRevision >= 3 Then
		    // Revision 3+: Bits 7-8 must be 1, bits 13-31 must be 1, all others start at 0
		    // Binary: 11111111111111111111000110000000 = 0xFFFFF0C0 = -3904
		    p = -3904  // Bits 7-8 set, bits 13-31 set, permission bits 3-6 and 9-12 cleared
		  Else
		    // Revision 2: Different bit requirements
		    p = -64  // 0xFFFFFFC0 = bits 6-31 set to 1
		  End If

		  // OR in permission bits for allowed operations
		  If allowPrint Then
		    p = p Or kPermPrint  // Bit 3 (value 4): Print (low quality)
		  End If

		  If allowModify Then
		    p = p Or kPermModify  // Bit 4 (value 8): Modify contents
		  End If

		  If allowCopy Then
		    p = p Or kPermCopy  // Bit 5 (value 16): Copy/extract text and graphics
		  End If

		  If allowAnnotate Then
		    p = p Or kPermAnnot  // Bit 6 (value 32): Add/modify annotations and signatures
		  End If

		  If allowFillForms And mRevision >= 3 Then
		    p = p Or kPermFillForms  // Bit 8 (value 256): Fill forms (Revision 3+)
		  End If

		  If allowExtract And mRevision >= 3 Then
		    p = p Or kPermExtract  // Bit 9 (value 512): Extract for accessibility (Revision 3+)
		  End If

		  If allowAssemble And mRevision >= 3 Then
		    p = p Or kPermAssemble  // Bit 10 (value 1024): Assemble document (Revision 3+)
		  End If

		  If allowPrintHighQuality And mRevision >= 3 Then
		    p = p Or kPermPrintHQ  // Bit 11 (value 2048): Print high quality (Revision 3+)
		  End If

		  mPermissions = p
		  System.DebugLog "SetPermissions: Final permissions value = " + Str(p) + " (0x" + Hex(p) + ")"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToHex(data As String) As String
		  // Convert binary string to hexadecimal
		  Const kHexChars As String = "0123456789ABCDEF"
		  Dim result As String = ""
		  Dim i As Integer
		  For i = 0 To VNSPDFModule.StringLenB(data) - 1
		    Dim byteStr As String = data.MiddleBytes(i, 1)
		    Dim byteMB As MemoryBlock = byteStr
		    Dim b As Integer = byteMB.Byte(0)
		    result = result + kHexChars.Middle((b \ 16), 1)
		    result = result + kHexChars.Middle((b Mod 16), 1)
		  Next
		  Return result
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAlgorithm As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEncrypted As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEncryptionKey As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFileID As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeyLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOwnerEntry As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOwnerEncryptionEntry As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOwnerPassword As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPermissions As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPermsEntry As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRevision As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUserEntry As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUserEncryptionEntry As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUserPassword As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUserKeySalt As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUserValidationSalt As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOwnerKeySalt As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOwnerValidationSalt As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mRevision
			End Get
		#tag EndGetter
		Revision As Integer
	#tag EndComputedProperty


	#tag Constant, Name = kPaddingString, Type = String, Dynamic = False, Default = \"(\xBFN^Nu\x8AAd\x00NV\xFF\xFA\x01\b..\x00\xB6\xD0h>\x80/\f\xA9\xFEdSiz", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPermAnnot, Type = Integer, Dynamic = False, Default = \"32", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"32"
	#tag EndConstant

	#tag Constant, Name = kPermAssemble, Type = Integer, Dynamic = False, Default = \"1024", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"1024"
	#tag EndConstant

	#tag Constant, Name = kPermCopy, Type = Integer, Dynamic = False, Default = \"16", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"16"
	#tag EndConstant

	#tag Constant, Name = kPermExtract, Type = Integer, Dynamic = False, Default = \"512", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"512"
	#tag EndConstant

	#tag Constant, Name = kPermFillForms, Type = Integer, Dynamic = False, Default = \"256", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"256"
	#tag EndConstant

	#tag Constant, Name = kPermModify, Type = Integer, Dynamic = False, Default = \"8", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"8"
	#tag EndConstant

	#tag Constant, Name = kPermPrint, Type = Integer, Dynamic = False, Default = \"4", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"4"
	#tag EndConstant

	#tag Constant, Name = kPermPrintHQ, Type = Integer, Dynamic = False, Default = \"2048", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"2048"
	#tag EndConstant


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
			Name="Revision"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
