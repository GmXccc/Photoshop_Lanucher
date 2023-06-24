#NoTrayIcon
#NoEnv
#SingleInstance, Force

PhotoshopPath := "D:\Program Files\Adobe Photoshop 2020\Photoshop.exe"
PhotoshopPluginsPath := "D:\Program Files\Adobe Photoshop 2020\Plug-ins\Microsoft\"

Run, % PhotoshopPath, , , PhotoshopPID

Menu, Tray, Add, Save, SaveAllUntitledWindows
Menu, Tray, Add, Close Photoshop, ClosePhotoshop
Menu, Tray, Icon, % PhotoshopPath
Menu, Tray, Show

return

SaveAllUntitledWindows:
    WinGet, id, list, ahk_exe Photoshop.exe
    for index, windowID in id {
        WinGetTitle, thisTitle, ahk_id %windowID%
        if InStr(thisTitle, "Untitled") {
            WinActivate, ahk_id %windowID%
            Send, ^s
            Sleep, 500
        }
    }
return

ClosePhotoshop:
    WinGet, id, list, ahk_exe Photoshop.exe
    for index, windowID in id {
        WinActivate, ahk_id %windowID%
        Send, ^q
        Sleep, 500
    }
    Process, Close, % PhotoshopPID
    RunExeFilesInFolder(PhotoshopPluginsPath, true)
    ExitApp
return

RunExeFilesInFolder(folder, close := false) {
    Loop, Files, % folder . "\*.exe", FR
    {
        if (close) {
            Process, Close, % A_LoopFileName
        } else {
            Run, % A_LoopFileFullPath
        }
    }
}

OnExit:
    Process, Close, % PhotoshopPID
    RunExeFilesInFolder(PhotoshopPluginsPath, true)
return