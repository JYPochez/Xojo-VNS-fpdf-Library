#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin SignProjectStep Sign
				  DeveloperID=
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Android
				Begin CopyFilesBuildStep CopyFontResources
					AppliesTo = 0
					Architecture = 0
					Target = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vWG9qb19mcGRmX2lvcy9BcmlhbCUyMFVuaWNvZGUudHRm
				End
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
