/*   FiveWin likely messages functions				*/
/*   								*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   License : (GPL) http://www.itk.ru/clipper/licence.html	*/


#include <fwin/FiveWin.ch>
#include <fwin/msgxpm.ch>
#include <fwin/itk.ch>

static lbStyle
static FontMessage
static Selector := GetSelector()

function InitMessageStyle()
local clr, clr1
if lbStyle == NIL

	lbStyle := map()
	eval(Selector:__InitMessageStyle, lbStyle, @FontMessage)
endif
return
***************
function MsgBeep()
	eval(Selector:__MsgBeep)
return
***************
* in original called WinApi MessageBeep( uVal )
function MessageBeep( uVal )
	eval(Selector:__MsgBeep)
return
****************
function MsgInfo(cMsg, cTitle)
local cXPM
	cTitle := iif(cTitle==NIL, [Information], cTitle)
	cXPM := infoXPM
return	eval(Selector:__MsgBox, cMsg, cTitle, FontMessage, lbStyle, cXPM)
****************
function MsgStop(cMsg, cTitle)
local cXPM
	cTitle := iif(cTitle==NIL, [Stop], cTitle)
	cXPM := stopXPM
return	eval(Selector:__MsgBox, cMsg, cTitle, FontMessage, lbStyle, cXPM)
****************
function MsgAlert(cMsg)
local cXPM, cTitle
	cTitle := [Attention]
	cXPM := alertXPM
return	eval(Selector:__MsgBox, cMsg, cTitle, FontMessage, lbStyle, cXPM)
****************
function Alert(cMsg, aOptions)
local cXPM, cTitle, aRet:={}, i
	cTitle := [Attention]
	cXPM := alertXPM
	if aOptions == NIL
		aOptions := {[&Yes]}
	endif
	for i=1 to len(aOptions)
		aadd(aRet, i)
	next
return	eval(Selector:__MsgBox, cMsg, cTitle, FontMessage, lbStyle, cXPM, aOptions, aRet)
****************
function MsgYesNo(cMsg)
local cXPM, cTitle
	cTitle := [Messages]
	cXPM := yesnoXPM
return	eval(Selector:__MsgBox, cMsg, cTitle, FontMessage, lbStyle, cXPM, {[&Yes], [&No]}, {.t., .f.})
****************
function MsgAbout()
return  eval(Selector:__MsgAbout, FontMessage, lbStyle)
***********
function MsgMeter(bAction, cMsg, cTitle)

local oDlg, oMeter, oText, oBtn, oFont
local lEnd := .f., lCancel := .f.
local nVal := 0

	DEFAULT bAction := { || nil },;
	   cMsg := [Processing...], cTitle := [Please, wait]

	DEFINE FONT oFont NAME "-adobe-courier-bold-r-normal-*-*-140-*-*-m-*-*-*" //SIZE 0, -8

	DEFINE DIALOG oDlg FROM 100, 100 TO 180, 370 TITLE cTitle FONT oFont PIXEL COLOR CLR_BLUE


	@ 10, 10  SAY oText VAR cMsg SIZE 130, 10 OF oDlg PIXEL

	@ 30, 10  METER oMeter VAR nVal TOTAL 10 SIZE 250, 10 OF oDlg PIXEL

	@ 5, 11  BUTTON oBtn PROMPT "&Cancel" OF oDlg ;
		ACTION ( lEnd:= .t., lCancel:= .t. ) SIZE 32, 11

	// This block gets evaluated only the first time the DialogBox is painted !!!
	oDlg:bStart = { || Eval( bAction, oMeter, oText, oDlg, @lEnd, oBtn ),;
		      lEnd := .t., oDlg:End() }

	ACTIVATE DIALOG oDlg CENTERED ;
		VALID lEnd

return lCancel
****************
function ChooseColor()
return  eval(Selector:__ChooseColor)
****************
function cGetFile(cMask, cTitle)
return eval(Selector:FileDialog, cMask, cTitle)
