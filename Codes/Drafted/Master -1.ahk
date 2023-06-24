#NoEnv
#SingleInstance force

; Open Photoshop
Run, "D:\Program Files\Adobe Photoshop 2020\Photoshop.exe"

; Wait for Photoshop to open
WinWait, Adobe Photoshop



; Add button to close Photoshop under the context menu of the AutoHotkey icon in the system tray
Menu, Tray, NoStandard
Menu, Tray, Add, &Close Photoshop, ClosePhotoshop

; Keep the script running while Photoshop is open
Loop
{
  IfWinNotExist, Adobe Photoshop
  {
    ; If Photoshop is not running, exit the script
    ExitApp
  }
  Sleep, 500
}