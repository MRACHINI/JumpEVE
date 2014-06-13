#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
CoordMode, Pixel, Relative
SendMode Input
#SingleInstance Force
;SetTitleMatchMode 2
SetTitleMatchMode RegEx
DetectHiddenWindows On
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1
#Persistent


TrayTip, JumpEVE Controls, `nF9 to Start or Stop `nCtrl+Alt+Shift+E to Exit
SetTimer, RemoveTrayTip, 5000

;TrayTip, My Title, Multiline`nText, 20, 17
;MsgBox, F6 to Start `nF7 to Stop `nCtrl+Alt+Shift+E to Exit


global StartBoolean = 0
Loop
{
	Sleep, 100
	;Trayloop += 1
	;TrayTip, Trayloop, %Trayloop%
	while StartBoolean = 1
	{
		if Counter != 0
		{
			;WinGet, EVEWindow, List, ahk_class triuiScreen
			WinGet, EVEWindow, List, EVE - \w+
			Counter = 0
		}
		Loop, %EVEWindow%
		{
			;MsgBox, %A_index%
			Sleep, 100
			this_id := EVEWindow%A_Index%
			WinActivate, ahk_id %this_id%
			WinGetClass, this_class, ahk_id %this_id%
			WinGetTitle, this_title, ahk_id %this_id%
			WinGetPos, , , Width, Height, ahk_id %this_id%
			;MsgBox, %this_title%
			Start(Width, Height)
		}
		;EVEWindow =
		;EVEWindow :=""
		;Sleep, 100
	}
}
return

Start(Width, Height){
	;MsgBox, %Width%x%Height%
	;skip the image check if warping
	CoordMode, Pixel, Relative
	ImageSearch, FoundX, FoundY, 0, 0, Width, Height, *50 Resources\Warping.png
	If ErrorLevel = 1
	{
		OverviewFocus()
		;MsgBox, not warping
		InitialMouseMove()
		Sleep, 250

		;Check for gate image
		CoordMode, Pixel, Relative
		ImageSearch, FoundX, FoundY, 0, 0, Width, Height, *50 Resources\GY01.png
		Sleep, 10
		If ErrorLevel = 0
		{
			ClickJump(FoundX, FoundY)
			return
		}

		;Check for station images
		CoordMode, Pixel, Relative
		ImageSearch, FoundX, FoundY, 0, 0, Width, Height, *50 Resources\SY01.png
		Sleep, 10
		If ErrorLevel = 0
		{
			ClickJump(FoundX, FoundY)
			return
		}
	}else{
		;MsgBox, Warping
		;Sleep, 500
	}
}

ClickJump(FoundX, FoundY){
	FoundX += 5
	FoundY += 5
	;BlockInput, MouseMove
	Sleep, 50
	Click, %FoundX%, %FoundY%, 0
	Sleep, 50
	Click, %FoundX%, %FoundY% Left, 1
	Sleep, 25
	Send, {d}

	FoundX += 5
	FoundY += 5
	Sleep, 50
	Click, %FoundX%, %FoundY%, 0
	Sleep, 50
	Click, %FoundX%, %FoundY% Left, 1
	Sleep, 25
	Send, {d}
	Sleep, 25
	;BlockInput, MouseMoveOff
	InitialMouseMove()
}

InitialMouseMove(){
	MoveX = 80
	MoveY = 40
	Click, %MoveX%, %MoveY%, 0
	Sleep, 1
	MoveX += 10
	Click, %MoveX%, %MoveY%, 0
	Sleep, 1
	MoveX += 10
	Click, %MoveX%, %MoveY%, 0
	Sleep, 1
	MoveX += 10
	Click, %MoveX%, %MoveY%, 0
	Sleep, 1
	MoveX += 10
	Click, %MoveX%, %MoveY%, 0
	Sleep, 1
	MoveX += 10
	MoveY += 10
	Click, %MoveX%, %MoveY%, 0
}

OverviewFocus(){
	Sleep, 50
	Send, {RAlt Down}{Space Down}
	Sleep, 50
	Send, {Space Up}{RAlt Up}
}

;main activation key to toggle variable "StartBoolean"
F9::
Main:
if (StartBoolean = 0){
	StartBoolean = 1
	TrayTip, JumpEVE Started, `nF9 to Start or Stop
	SetTimer, RemoveTrayTip, 5000
	return
}else if (StartBoolean = 1){
	StartBoolean = 0
	Stop()
}
return

;turn off tray tips
RemoveTrayTip:
SetTimer, RemoveTrayTip, Off
TrayTip
return

;Stop script
Stop(){
sleep 100
Reload
Sleep 100
MsgBox, The script could not be reloaded.
;return
}

;Exit or reload script
^!+E::
MsgBox, 4,, Would you like to Exit?
IfMsgBox Yes
	ExitApp
else
	Stop()