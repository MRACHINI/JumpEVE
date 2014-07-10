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

global x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20 =0

global y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y20 =0

global getOverviewBoolean1,getOverviewBoolean2,getOverviewBoolean3,getOverviewBoolean4,getOverviewBoolean5,getOverviewBoolean6,getOverviewBoolean7,getOverviewBoolean8,getOverviewBoolean9,getOverviewBoolean10,getOverviewBoolean11,getOverviewBoolean12,getOverviewBoolean13,getOverviewBoolean14,getOverviewBoolean15,getOverviewBoolean16,getOverviewBoolean17,getOverviewBoolean18,getOverviewBoolean19,getOverviewBoolean20 =0

Loop
{
	Sleep, 100
	;Trayloop += 1
	;TrayTip, Trayloop, %Trayloop%
	while StartBoolean = 1
	{
		if WinGetBoolean != 0
		{
			;WinGet, EVEWindow, List, ahk_class triuiScreen
			WinGet, EVEWindow, List, ^EVE - .+
			WinGetBoolean = 0
		}

		Loop, %EVEWindow%
		{
			Sleep, 100
			this_id := EVEWindow%A_Index%
			WinActivate, ahk_id %this_id%
			WinGetClass, this_class, ahk_id %this_id%
			WinGetTitle, this_title, ahk_id %this_id%
			WinGetPos, LX, LY, Width, Height, ahk_id %this_id%
			;MsgBox, %this_title%

			index = %A_index%
			if (getOverviewBoolean%index% !=0)
			{
				;MsgBox, %LX% %LY% %width% %height%
				;MsgBox, % getOverviewBoolean%index% "inside"
				getOverview(index, LX, LY, Width, Height)
			}else{
			;MsgBox, % getOverviewBoolean%index% " else"
			;MsgBox, % x%index% " " y%index% " " %Width% " " %Height%
			Start(x%index%, y%index%, Width, Height)
			}
		}
		Counter2 = 0
	}
}
return

Start(x, y, Width, Height){
	;MsgBox, %x% %y% %Width% %Height%
	;MsgBox, %x% %y%
	;MsgBox, %Width%x%Height%
	;skip the image check if warping
	CoordMode, Pixel, Relative
	ImageSearch, FoundX, FoundY, 0, 0, Width, Height, *50 Resources\Warping.png
	If ErrorLevel = 1
	{
		OverviewFocus()
		Sleep, 250
		;MsgBox, not warping
		InitialMouseMove()
		Sleep, 250

		newX := x+30
		;MsgBox, %x% %y% %newX% %Height%
		;Check for gate image
		CoordMode, Pixel, Relative
		ImageSearch, FoundX, FoundY, x, y, newX, Height, *50 Resources\GY01.png
		Sleep, 10
		If ErrorLevel = 0
		{
			ClickJump(FoundX, FoundY)
			return
		}

		;Check for station images
		CoordMode, Pixel, Relative
		ImageSearch, FoundX, FoundY, x, y, Width, Height, *50 Resources\SY01.png
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

getOverview(index, LX, LY, Width, Height){
	OverviewFocus()
	CoordMode, Pixel, Relative
	ImageSearch, x, y, 0, 0, Width, Height, *50 Resources\GY01.png
	Sleep, 10
	;MsgBox, %LX% %LY% %width% %height%
	;MsgBox, ErrorLevel %ErrorLevel%
	If ErrorLevel = 0
	{
		;MsgBox, % x%index%
		;MsgBox, % y%index%
		x%index% := x
		y%index% := y
		x%index% -= 5
		y%index% -= 5
		;MsgBox, found overview
		;ClickJump(FoundX, FoundY)
		;return
		;MsgBox, % x%index%
		;MsgBox, % y%index%
		getOverviewBoolean%index% := 0
		;MsgBox, % getOverviewBoolean%index% "overview"
	}
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