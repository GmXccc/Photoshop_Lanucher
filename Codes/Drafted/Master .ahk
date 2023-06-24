#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force

; Open Photoshop
Run, "D:\Program Files\Adobe Photoshop 2020\Photoshop.exe"

; Wait for Photoshop to open
WinWait, Adobe Photoshop

; Check if Photoshop is still running every 500 milliseconds
Loop
{
  IfWinNotExist, Adobe Photoshop
  {
    ; If Photoshop is not running, exit the script
    ExitApp
  }
  Sleep, 500
}