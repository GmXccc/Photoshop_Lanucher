#NoEnv
#SingleInstance force

; Define the function to close Photoshop
ClosePhotoshop()
{
  ; Check if Photoshop is running and Adobe Spaces Helper is running
  if WinExist("Adobe Photoshop") && ProcessExist("Adobe Spaces Helper.exe")
  {
    ; Close Photoshop
    WinClose, Adobe Photoshop
  }
  else
  {
    ; If Photoshop is not running or Adobe Spaces Helper is not running, display an error message
    MsgBox, Photoshop is not running or Adobe Spaces Helper is not running.
  }
}

; Define the function to save the Photoshop document
SavePhotoshopDocument()
{
  ; Check if Photoshop is running and Adobe Spaces Helper is running
  if WinExist("Adobe Photoshop") && ProcessExist("Adobe Spaces Helper.exe")
  {
    ; Check if Photoshop is active
    IfWinActive, Adobe Photoshop
    {
      ; If Photoshop is active, send Ctrl+S to save the document
      Send, ^s
    }
    else
    {
      ; If Photoshop is not active, activate the Photoshop window
      WinActivate, Adobe Photoshop
      WinWaitActive, Adobe Photoshop

      ; Send Ctrl+S to save the document
      Send, ^s
    }
  }
  else
  {
    ; If Photoshop is not running or Adobe Spaces Helper is not running, display an error message
    MsgBox, Photoshop is not running or Adobe Spaces Helper is not running.
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

; Check if Photoshop and Adobe Spaces Helper are running every 500 milliseconds
Loop
{
  ; Check if Photoshop and Adobe Spaces Helper are running
  If ProcessExist("Photoshop.exe") && ProcessExist("Adobe Spaces Helper.exe")
  {
    ; If Photoshop and Adobe Spaces Helper are running and we have not detected it before, add the buttons to close and save
    if (!PhotoshopRunning)
    {
      Menu, Tray, Add, &Close Photoshop, ClosePhotoshop
      Menu, Tray, Add, &Save, SavePhotoshopDocument
      PhotoshopRunning := true
    }
  }
  else
  {
    ; If Photoshop or Adobe Spaces Helper is not running and we have detected it before, remove the buttons to close and save
    if (PhotoshopRunning)
    {
      Menu, Tray, Delete, &Close Photoshop
      Menu, Tray, Delete, &Save
      PhotoshopRunning := false
    }
  }

  ; Check if the current Photoshop document has changes that need to be saved
  IfWinActive, Adobe Photoshop
  {
    IfWinExist, Save Changes
    {
      ; If there are changes that need to be saved, send the Enter key to save them
      WinActivate, Save Changes
      Send, {Enter}
    }
  }
  
  ; Save the current Photoshop document if there are changes that need to be saved
  IfWinExist, Save Changes
  {
    WinActivate, Save Changes
    Send, {Enter}
  }
  
  ; Check if the new document window is open
  IfWinExist, New Document
  {
    ; If the new document window is open, close it
    WinClose, New Document
  }
  
  ; Wait for 500 milliseconds
  Sleep, 500
}

; Function to check if a process is running
ProcessExist(exe)
{
  Process, Exist, %exe%
  return ErrorLevel
}