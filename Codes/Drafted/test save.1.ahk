#NoEnv
#SingleInstance force

; Define the global variable to store the handle of the active Photoshop window
Global hWndPhotoshop := 0

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
    ; Use Winget to find the active Photoshop window
    WinGet, hWndPhotoshop, ID, Adobe Photoshop 2020
    
    ; Check if the window handle is valid
    If hWndPhotoshop
    {
      ; Activate the Photoshop window
      WinActivate, ahk_id %hWndPhotoshop%
      
      ; Wait for the window to become active
      WinWaitActive, ahk_id %hWndPhotoshop%
      
      ; Send Ctrl+S to the active Photoshop window
      SendInput, ^s
    }
    else
    {
      ; Display a message indicating that the active Photoshop window could not be found
      MsgBox, Could not find the active Photoshop window.
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

  ; Use a Windows event listener to detect when a new window is activated or when a different window is active
  OnMessage(0x201, "CheckActiveWindow")

  ; Sleep for 500 milliseconds before checking again
  Sleep, 500
}

; Function to check if a process is running
ProcessExist(exe)
{
  Process, Exist, %exe%
  return ErrorLevel
}

; Function to check if Photoshop is active and update the system tray menu accordingly
CheckActiveWindow()
{
  ; Get the handle of the active window
  WinGet, hWndActive, ID, A

  ; Check if the active window is the Photoshop window
  If hWndActive = hWndPhotoshop
    Return

  ; Check if the active window is a Photoshop window
  IfWinActive, Adobe Photoshop 2020
  {
    ; Store the handle of the active Photoshop window in the global variable
    hWndPhotoshop := hWndActive
    
    ; If Photoshop is active and we have not detected it before, add the "Close Photoshop" and "Save" buttons to the system tray menu
    if (!PhotoshopRunning)
    {
      Menu, Tray, Add, &Close Photoshop, ClosePhotoshop
      Menu, Tray, Add, &Save, SavePhotoshopDocument
      PhotoshopRunning := true
    }
  }
  else
  {
    ; If Photoshop is not active and we have detected it before, remove the "Close Photoshop" and "Save" buttons from the system tray menu
    if (PhotoshopRunning)
    {
      Menu, Tray, Delete, &Close Photoshop
      Menu, Tray, Delete, &Save
      PhotoshopRunning := false
    }
  }
  ; Return 0 to indicate that the message has been processed
  Return 0
}