﻿#NoEnv
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
    ; Send Ctrl+S to the active Photoshop window
    ControlSend, , ^s, ahk_id %hWndPhotoshop%
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
WinWait, Adobe Photoshop

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

  ; Display the window handles of the active and previous windows for debugging purposes
  MsgBox, Active window: %hWndActive%, Previous window: %hWndPhotoshop%

  ; Check if the active window is a Photoshop window
  IfWinActive, Adobe Photoshop
  {
    ; Store the handle of the active Photoshop window in the global variable
    hWndPhotoshop := hWndActive
; Function to handle Windows messages
OnMessage(msg, wParam, lParam)
{
  ; Display the message ID and wParam and lParam values for debugging purposes
  MsgBox, Message: %msg%, wParam: %wParam%, lParam: %lParam%

  ; Pass the message to the default message handler
  Return DllCall("DefWindowProc", "UInt", msg, "UInt", wParam, "UInt", lParam)
}
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