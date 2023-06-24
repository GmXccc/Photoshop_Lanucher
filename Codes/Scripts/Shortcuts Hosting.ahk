#IfWinActive, ahk_exe Photoshop.exe ; Only apply this hotkey when Photoshop is active

^d::
IfWinActive, ahk_exe Photoshop.exe
{
    SendInput, {Ctrl Down}d{Ctrl Up}
    Sleep 50 ; Wait for the Ctrl+D keystroke to be processed
    SendInput, +{F2}
}
return

#IfWinActive ; Turn off context sensitivity