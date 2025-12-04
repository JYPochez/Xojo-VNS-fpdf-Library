#tag WebPage
Begin WebDialog WebDialogSecurity
   Compatibility   =   ""
   ControlCount    =   0
   ControlID       =   ""
   CSSClasses      =   ""
   Enabled         =   True
   Height          =   550
   Index           =   -2147483648
   Indicator       =   0
   LayoutDirection =   0
   LayoutType      =   0
   Left            =   0
   LockBottom      =   False
   LockHorizontal  =   False
   LockLeft        =   False
   LockRight       =   False
   LockTop         =   False
   LockVertical    =   False
   PanelIndex      =   0
   Position        =   1
   TabIndex        =   0
   Top             =   0
   Visible         =   True
   Width           =   500
   _mDesignHeight  =   0
   _mDesignWidth   =   0
   _mName          =   ""
   _mPanelIndex    =   -1
   Begin WebLabel lblTitle
      Bold            =   True
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      FontName        =   ""
      FontSize        =   0.0
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      Multiline       =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   0
      Text            =   "PDF Security Settings"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   20
      Underline       =   False
      Visible         =   True
      Width           =   460
      _mPanelIndex    =   -1
   End
   Begin WebLabel lblEncryption
      Bold            =   False
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      FontName        =   ""
      FontSize        =   0.0
      Height          =   20
      Index           =   -2147483648
      Indicator       =   0
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      Multiline       =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   1
      Text            =   "Encryption Level:"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   60
      Underline       =   False
      Visible         =   True
      Width           =   150
      _mPanelIndex    =   -1
   End
   Begin WebPopupMenu popEncryption
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   32
      Index           =   -2147483648
      Indicator       =   0
      InitialValue    =   "Revision 4: AES-128 (RECOMMENDED)\nRevision 5: AES-256 (BEST)\nRevision 6: AES-256 R6 (MODERN)\nRevision 3: RC4-128 (LEGACY)\nRevision 2: RC4-40 (WEAK)"
      LastAddedRowIndex=   0
      Left            =   180
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      SearchCriteria  =   ""
      SelectedRowIndex=   0
      SelectedRowValue=   ""
      TabIndex        =   2
      Tooltip         =   ""
      Top             =   55
      Visible         =   True
      Width           =   300
      _mPanelIndex    =   -1
   End
   Begin WebLabel lblUserPassword
      Bold            =   False
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      FontName        =   ""
      FontSize        =   0.0
      Height          =   20
      Index           =   -2147483648
      Indicator       =   0
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      Multiline       =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   3
      Text            =   "User Password:"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   110
      Underline       =   False
      Visible         =   True
      Width           =   150
      _mPanelIndex    =   -1
   End
   Begin WebTextField txtUserPassword
      AllowAutoComplete=   False
      AllowSpellChecking=   False
      CSSClasses      =   ""
      Caption         =   ""
      ControlID       =   ""
      Enabled         =   True
      FieldType       =   3
      Height          =   32
      Hint            =   ""
      Index           =   -2147483648
      Indicator       =   0
      Left            =   180
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      MaximumCharactersAllowed=   0
      PanelIndex      =   0
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   4
      Text            =   "user123"
      TextAlignment   =   0
      Tooltip         =   ""
      Top             =   105
      Visible         =   True
      Width           =   300
      _mPanelIndex    =   -1
   End
   Begin WebLabel lblOwnerPassword
      Bold            =   False
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      FontName        =   ""
      FontSize        =   0.0
      Height          =   20
      Index           =   -2147483648
      Indicator       =   0
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      Multiline       =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   5
      Text            =   "Owner Password:"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   155
      Underline       =   False
      Visible         =   True
      Width           =   150
      _mPanelIndex    =   -1
   End
   Begin WebTextField txtOwnerPassword
      AllowAutoComplete=   False
      AllowSpellChecking=   False
      CSSClasses      =   ""
      Caption         =   ""
      ControlID       =   ""
      Enabled         =   True
      FieldType       =   3
      Height          =   32
      Hint            =   ""
      Index           =   -2147483648
      Indicator       =   0
      Left            =   180
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      MaximumCharactersAllowed=   0
      PanelIndex      =   0
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   6
      Text            =   "owner456"
      TextAlignment   =   0
      Tooltip         =   ""
      Top             =   150
      Visible         =   True
      Width           =   300
      _mPanelIndex    =   -1
   End
   Begin WebLabel lblPermissions
      Bold            =   False
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      FontName        =   ""
      FontSize        =   0.0
      Height          =   20
      Index           =   -2147483648
      Indicator       =   0
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      Multiline       =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   7
      Text            =   "Permissions:"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   205
      Underline       =   False
      Visible         =   True
      Width           =   150
      _mPanelIndex    =   -1
   End
   Begin WebCheckBox chkPrint
      Caption         =   "Allow Printing"
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   8
      Tooltip         =   ""
      Top             =   235
      Value           =   True
      Visible         =   True
      Width           =   200
      _mPanelIndex    =   -1
   End
   Begin WebCheckBox chkModify
      Caption         =   "Allow Modify"
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   9
      Tooltip         =   ""
      Top             =   270
      Value           =   False
      Visible         =   True
      Width           =   200
      _mPanelIndex    =   -1
   End
   Begin WebCheckBox chkCopy
      Caption         =   "Allow Copy"
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   10
      Tooltip         =   ""
      Top             =   305
      Value           =   True
      Visible         =   True
      Width           =   200
      _mPanelIndex    =   -1
   End
   Begin WebCheckBox chkAnnotate
      Caption         =   "Allow Annotations"
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   11
      Tooltip         =   ""
      Top             =   340
      Value           =   True
      Visible         =   True
      Width           =   200
      _mPanelIndex    =   -1
   End
   Begin WebCheckBox chkFillForms
      Caption         =   "Allow Fill Forms"
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Left            =   260
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   12
      Tooltip         =   ""
      Top             =   235
      Value           =   True
      Visible         =   True
      Width           =   220
      _mPanelIndex    =   -1
   End
   Begin WebCheckBox chkExtract
      Caption         =   "Allow Extract"
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Left            =   260
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   13
      Tooltip         =   ""
      Top             =   270
      Value           =   False
      Visible         =   True
      Width           =   220
      _mPanelIndex    =   -1
   End
   Begin WebCheckBox chkAssemble
      Caption         =   "Allow Assemble"
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Left            =   260
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   14
      Tooltip         =   ""
      Top             =   305
      Value           =   False
      Visible         =   True
      Width           =   220
      _mPanelIndex    =   -1
   End
   Begin WebCheckBox chkPrintHighQuality
      Caption         =   "Allow High Quality Print"
      ControlID       =   ""
      CSSClasses      =   ""
      Enabled         =   True
      Height          =   30
      Index           =   -2147483648
      Indicator       =   0
      Left            =   260
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   15
      Tooltip         =   ""
      Top             =   340
      Value           =   True
      Visible         =   True
      Width           =   220
      _mPanelIndex    =   -1
   End
   Begin WebButton btnOK
      AllowAutoDisable=   False
      Cancel          =   False
      Caption         =   "OK"
      ControlID       =   ""
      CSSClasses      =   ""
      Default         =   True
      Enabled         =   True
      Height          =   38
      Index           =   -2147483648
      Indicator       =   0
      Left            =   280
      LockBottom      =   True
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   16
      Tooltip         =   ""
      Top             =   492
      Visible         =   True
      Width           =   100
      _mPanelIndex    =   -1
   End
   Begin WebButton btnCancel
      AllowAutoDisable=   False
      Cancel          =   True
      Caption         =   "Cancel"
      ControlID       =   ""
      CSSClasses      =   ""
      Default         =   False
      Enabled         =   True
      Height          =   38
      Index           =   -2147483648
      Indicator       =   0
      Left            =   390
      LockBottom      =   True
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   17
      Tooltip         =   ""
      Top             =   492
      Visible         =   True
      Width           =   100
      _mPanelIndex    =   -1
   End
End
#tag EndWebPage

#tag WindowCode
	#tag Property, Flags = &h0
		UserCancelled As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		EncryptionRevision As Integer = 4
	#tag EndProperty

	#tag Property, Flags = &h0
		UserPassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		OwnerPassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowPrint As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowModify As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowCopy As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowAnnotations As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowFillForms As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowExtract As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowAssemble As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowPrintHighQuality As Boolean = True
	#tag EndProperty

#tag EndWindowCode

#tag Events btnOK
	#tag Event
		Sub Pressed()
		  // Map popup selection to revision number
		  Select Case popEncryption.SelectedRowIndex
		  Case 0
		    EncryptionRevision = 4  // AES-128
		  Case 1
		    EncryptionRevision = 5  // AES-256 R5
		  Case 2
		    EncryptionRevision = 6  // AES-256 R6
		  Case 3
		    EncryptionRevision = 3  // RC4-128
		  Case 4
		    EncryptionRevision = 2  // RC4-40
		  End Select

		  UserPassword = txtUserPassword.Text
		  OwnerPassword = txtOwnerPassword.Text
		  AllowPrint = chkPrint.Value
		  AllowModify = chkModify.Value
		  AllowCopy = chkCopy.Value
		  AllowAnnotations = chkAnnotate.Value
		  AllowFillForms = chkFillForms.Value
		  AllowExtract = chkExtract.Value
		  AllowAssemble = chkAssemble.Value
		  AllowPrintHighQuality = chkPrintHighQuality.Value

		  UserCancelled = False
		  Self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnCancel
	#tag Event
		Sub Pressed()
		  UserCancelled = True
		  Self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="PanelIndex"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Index"
		Visible=false
		Group="ID"
		InitialValue="-2147483648"
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
		Name="Position"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="WebDialog.Positions"
		EditorType="Enum"
		#tag EnumValues
			"0 - Top"
			"1 - Center"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mPanelIndex"
		Visible=false
		Group="Behavior"
		InitialValue="-1"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ControlID"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Behavior"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LayoutType"
		Visible=true
		Group="Behavior"
		InitialValue="LayoutTypes.Fixed"
		Type="LayoutTypes"
		EditorType="Enum"
		#tag EnumValues
			"0 - Fixed"
			"1 - Flex"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockHorizontal"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockLeft"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockVertical"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Behavior"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mDesignHeight"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mDesignWidth"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mName"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Visual Controls"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Indicator"
		Visible=false
		Group="Visual Controls"
		InitialValue=""
		Type="WebUIControl.Indicators"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Primary"
			"2 - Secondary"
			"3 - Success"
			"4 - Danger"
			"5 - Warning"
			"6 - Info"
			"7 - Light"
			"8 - Dark"
			"9 - Link"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="LayoutDirection"
		Visible=true
		Group="WebView"
		InitialValue="LayoutDirections.LeftToRight"
		Type="LayoutDirections"
		EditorType="Enum"
		#tag EnumValues
			"0 - LeftToRight"
			"1 - RightToLeft"
			"2 - TopToBottom"
			"3 - BottomToTop"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="UserCancelled"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EncryptionRevision"
		Visible=false
		Group="Behavior"
		InitialValue="4"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="UserPassword"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="OwnerPassword"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowPrint"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowModify"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowCopy"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowAnnotations"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFillForms"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowExtract"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowAssemble"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowPrintHighQuality"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
