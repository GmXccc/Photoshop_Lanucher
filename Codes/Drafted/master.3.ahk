#NoEnv
#SingleInstance force



SetTitleMatchMode, 2 ; Set title match mode to 'contains' for partial window title matching
DetectHiddenWindows, On ; Detect hidden windows

; Create a system tray menu item called "Save"
Menu, Tray, Add, Save, SaveUntitledPhotoshop
Menu, Tray, Default, Save

return ; End of auto-execute section

SaveUntitledPhotoshop:
; Save the current active window
WinGet, activeWindowID, ID, A

; Find all "Untitled" windows of "photoshop.exe"
WinGet, untitledWindows, List, Untitled ahk_exe photoshop.exe

; Iterate through all found "Untitled" windows and send Ctrl+S to save them
Loop, %untitledWindows%
{
    thisWindowID := untitledWindows%A_Index%
    WinActivate, ahk_id %thisWindowID%
    Sleep, 200
    Send, ^s
    Sleep, 200
}

; Restore the previously active window
WinActivate, ahk_id %activeWindowID%

return

; Open Photoshop
Run, "D:\Program Files\Adobe Photoshop 2020\Photoshop.exe"

; Wait for Photoshop to open
WinWait, Adobe Photoshop

; Keep track of whether Photoshop is running
PhotoshopRunning := true

; Add button to close Photoshop under the context menu of the AutoHotkey icon in the system tray
Menu, Tray, NoStandard
Menu, Tray, Add, &Close Photoshop, ClosePhotoshop




; Function to check if a process is running
ProcessExist(exe)
{
  Process, Exist, %exe%
  return ErrorLevel
}