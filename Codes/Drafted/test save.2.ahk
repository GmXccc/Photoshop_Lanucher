#NoEnv
#SingleInstance force

; Define the function to close Photoshop
ClosePhotoshop()
{
  ; Check if the Photoshop process is running
  If ProcessExist("Photoshop.exe")
  {
    ; Use the taskkill command to forcefully close the Photoshop process
    RunWait, taskkill /IM Photoshop.exe /F
  }
  else
  {
    ; Display a message indicating that Photoshop is not running
    MsgBox, Photoshop is not running.
  }
}

; Define the function to save the Photoshop document
SavePhotoshopDocument()
{
  ; Check if the Photoshop process is running
  If ProcessExist("Photoshop.exe")
  {
    ; Check if the Adobe Photoshop 2020 window is active
    If WinActive("Adobe Photoshop 2020")
    {
      ; Send Ctrl+S to the active Photoshop window
      SendInput, ^s
    }
    else
    {
      ; Display a message indicating that the Adobe Photoshop 2020 window is not active
      MsgBox, Adobe Photoshop 2020 is not active.
      
      ; Try to activate the Adobe Photoshop 2020 window
      WinActivate, Adobe Photoshop 2020
      
      ; Wait for the window to become active
      WinWaitActive, Adobe Photoshop 2020
      
      ; Send Ctrl+S to the active Photoshop window
      SendInput, ^s
    }
  }
  else
  {
    ; Display a message indicating that Photoshop is not running
    MsgBox, Photoshop is not running.
  }
}

; Open Photoshop
Run, "D:\Program Files\Adobe Photoshop 2020\Photoshop.exe"

; Wait for Photoshop to open
WinWait, Adobe Photoshop 2020

; Keep track of whether Photoshop is running
PhotoshopRunning := true

; Add button to close Photoshop under the context menu of the AutoHotkey icon in the system tray
Menu, Tray, NoStandard
Menu, Tray, Add, &Close Photoshop, ClosePhotoshop

; Add button to save the Photoshop document under the context menu of the AutoHotkey icon in the system tray
Menu, Tray, Add, &Save, SavePhotoshopDocument

; Check if Photoshop is running every 500 milliseconds
Loop
{
  If !ProcessExist("Photoshop.exe")
  {
    ; If Photoshop is not running and we have detected it before, remove the buttons to close and save
    if (PhotoshopRunning)
    {
      Menu, Tray, Delete, &Close Photoshop
      Menu, Tray, Delete, &Save
      PhotoshopRunning := false
    }
    ExitApp
  }

  ; Use a Windows event listener to detect when the Save button is pressed
  OnMessage(0x111, "CheckSaveButton")

  ; Sleep for 500 milliseconds before checking again
  Sleep, 500
}

; Function to check if a process is running
ProcessExist(exe)
{
  Process, Exist, %exe%
  return ErrorLevel
}

; Function to check if the Save button is pressed and save the Photoshop document
CheckSaveButton(wParam, lParam)
{
  ; Check if the wParam is the ID of the Save button
  If (wParam = 0x1E)
  {
    ; Check if the Photoshop process is running
    If ProcessExist("Photoshop.exe")
    {
      ; Check if the Adobe Photoshop 2020 window is active
      If WinActive("Adobe Photoshop 2020")
      {
        ; Send Ctrl+S to the active Photoshop window
        SendInput, ^s
      }
      else
      {
        ; Display a message indicating that the Adobe Photoshop 2020 window is not active
        MsgBox, Adobe Photoshop 2020 is not active.
        
        ; Try to activate the Adobe Photoshop 2020 window
        WinActivate, Adobe Photoshop 2020
        
        ; Wait for the window to become active
        WinWaitActive, Adobe Photoshop 2020
        
        ; Send Ctrl+S to the active Photoshop window
        SendInput, ^s
      }
    }
    else
    {
      ; Display a message indicating that Photoshop is not running
      MsgBox, Photoshop is not running.
    }
  }
}