#include <clipcfg.h>

static Selector
static drivers := {}
static initialized := .f.

function fw_driver_register(cDriver)
	aadd(drivers,cDriver)
return

function FWInitDriver()
local driver,i,aDrivers:={}

	if initialized
		return
	endif

	driver := upper(getenv("CLIP_FWDRIVER"))
	if !empty(driver)
		aadd(aDrivers,driver)
	endif
	#ifdef OS_CYGWIN
	if empty(aDrivers)
		aadd(aDrivers,"GTK")
		aadd(aDrivers,"CTI")
	endif
	#else

	if empty(aDrivers)
		if !empty(getenv("DISPLAY"))
			aadd(aDrivers,"GTK")
			aadd(aDrivers,"CTI")
		else
			aadd(aDrivers,"CTI")
			aadd(aDrivers,"GTK")
		endif
	endif
	#endif
	for i=1 to len(aDrivers)
		if isFunction("getselector"+aDrivers[i])
			Selector := clip("getselector"+aDrivers[i])
			exit
		endif
	next
	if empty(selector)
		? "No one driver from the list ",aDrivers," not available !!!"
		? "Available drivers: ", drivers
		?
		quit
	endif
	Selector:InitFWDriver()
	initialized := .t.
return
******************
function GetSelector()
return Selector
*************
function GetWinDir()
local cPath
	cPath := set("C:")
return cPath
******************
function GetFWDriver()
return eval(Selector:GetFwDriver)
*************
function WinExec(cAppl)
return eval(Selector:WinExec, cAppl)
*************
function WinHelp(cFile)
return eval(Selector:WinHelp, cFile)
*************
function Calendar(date)
return eval(Selector:Calendar, date)
*************
function SysRefresh()
return eval(Selector:SysRefresh)
*************
function SelectObject(hDC, hPen)
return eval(Selector:SelectObject, hDC, hPen)
*************
function DeleteObject(hObj)
return eval(Selector:DeleteObject, hObj)
*************
function GetDc(hWnd)
return eval(Selector:GetDc, hWnd)
*************
function ReleaseDc(hWnd, hDC)
return eval(Selector:ReleaseDc, hWnd, hDC)
*************
function CreatePen(nStyle, nWidth, nRGBColor)
return eval(Selector:CreatePen, nStyle, nWidth, nRGBColor)
*************
function LineTo(hDC, nRow, nCol)
return eval(Selector:LineTo, hDC, nRow, nCol)
**************
function MoveTo(hDC, nRow, nCol)
return eval(Selector:MoveTo, hDC, nRow, nCol)
*****************************
function lAnd()
return
*****************************
function nAnd()
return
*****************************
function oRead (cStr)
local obj
	&(cStr)
return obj
*****************************
function oSend()
return
