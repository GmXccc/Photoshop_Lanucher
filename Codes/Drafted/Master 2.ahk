#NoEnv
#SingleInstance force

; Define the function to close Photoshop
ClosePhotoshop()
{
  ; Close Photoshop
  WinClose, Adobe Photoshop
}

; Open Photoshop
Run, "D:\Program Files\Adobe Photoshop 2020\Photoshop.exe"

; Wait for Photoshop to open
WinWait, Adobe Photoshop

; Keep track of whether Photoshop is running
PhotoshopRunning := true

; Add button to close Photoshop under the context menu of the AutoHotkey icon in the system tray
Menu, Tray, NoStandard
Menu, Tray, Add, &Close Photoshop, ClosePhotoshop

; Check if Photoshop is running every 500 milliseconds
Loop
{
  IfWinNotExist, Adobe Photoshop
  {
    ; If Photoshop is not running and we have detected it before, remove the button to close Photoshop
    if (PhotoshopRunning)
    {
      Menu, Tray, Delete, &Close Photoshop
      PhotoshopRunning := false
    }
    ExitApp
  }
  Sleep, 500
}