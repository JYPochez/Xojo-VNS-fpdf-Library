#tag Class
Protected Class App
Inherits DesktopApplication
	#tag Event
		Sub Opening()
		  // Open main window on startup
		  WindowMain.Show()
		End Sub
	#tag EndEvent


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
	#tag EndConstant


End Class
#tag EndClass
