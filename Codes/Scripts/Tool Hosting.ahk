#SingleInstance, Force
#NoEnv

; Define the path to the folder to open
FolderPath := "D:\System Disk\Photoshop Presets\Tools"



; Add a menu item to the tray icon
Menu, Tray, Add, Tool Presets, Tools
Menu, Tray, NoStandard



; Loop to keep the script running in the background
Loop
{
  ; Do background tasks or respond to events here
  Sleep, 1000 ; Sleep for 1 second before running the loop again
}

return

; Function to open the folder
Tools:
; Create a file explorer window for the folder
Run, explorer.exe "%FolderPath%"
return

ExitApp