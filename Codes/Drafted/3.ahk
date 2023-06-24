#SingleInstance, Force
#NoEnv
; Start/Stop all .exe in the specified folder on script start/exit
Loop, D:\Program Files\Adobe Photoshop 2020\Plug-ins\Microsoft\*.exe
{
    Run, %A_LoopFileLongPath%
}
 
; Start Photoshop on script start
Run, D:\Program Files\Adobe Photoshop 2020\Photoshop.exe
; Wait for Photoshop to open
WinWait, Adobe Photoshop
; Save function
Save:
WinGet, id, list, Untitled ahk_exe Photoshop.exe
Loop, %id%
{
    this_id := id%A_Index%
    WinActivate, ahk_id %this_id%
    Send, ^s
}


; Close Photoshop function
ClosePS:
WinGet, id, list, Untitled ahk_exe Photoshop.exe
Loop, %id%
{
    this_id := id%A_Index%
    WinActivate, ahk_id %this_id%
    Send, ^q
}
; Create a tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Save, Save
Menu, Tray, Add, Close Photoshop, ClosePS
Menu, Tray, Default, Save


; Keep track of whether Photoshop is running
Loop
{
  ; Check if Photoshop is running
  Process, Exist, Photoshop.exe
  if (!ErrorLevel) ; Photoshop is not running
  {
    ExitSub:
Loop, D:\Program Files\Adobe Photoshop 2020\Plug-ins\Microsoft\*.exe
{
Process, Close, %A_LoopFileName%
}  ExitApp
  }
  else ; Photoshop is running
  {
    ; Your code goes here
    ; This code will run continuously in the background
    ; while the script is checking if Photoshop is running
    
    Sleep, 1000 ; Sleep for 1 second before running the loop again
  }
}

