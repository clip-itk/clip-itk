/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
*****************************************************
function linedraw
return
*****************************************************
function rundos
return
*****************************************************
function altdel
return 0
*****************************************************
function mouse_move()
return 0
*****************************************************
function mousekey()
return 0
*****************************************************
function mouptr_on()
return .t.
*****************************************************
function mouptr_off()
return .t.
*****************************************************
function mrelease()
return 0
*****************************************************
function moumaxrow()
return 0
*****************************************************
function moumaxcol()
return 0
*****************************************************
function setmouse()
return .t.

*****************************************************
function setblink()
return .t.

*****************************************************
function msetcursor(lvisible)
return .f.
*****************************************************
function csetcurs(lvisible)
	local ret
	ret:=setcursor()!=0
	if lVisible != NIL
		setcursor(iif(lvisible,1,0))
	endif
return ret
*****************************************************
function _isgraphics()
return .f.
*****************************************************
function low_alt(s)
return lower(s)
************************************************************
function cretry()
return 0
*****************************************************
function kbdEmulate()
return 0
*****************************************************
function tone()
	__beep()
return .t.
*****************************************************
function sound
	__beep()
return .t.
*****************************************************
function kbdspeed()
return .t.
*****************************************************
function vgapalette()
return .t.
*****************************************************
FUNCTION Network()
  RETURN ( .T. )
*****************************************************
FUNCTION NOSNOW()
  RETURN NIL
*****************************************************
FUNCTION ISVGA()
  RETURN .F.
*****************************************************
FUNCTION ISEGA()
  RETURN .F.
*****************************************************
	function setmode()
	return .t.
*****************************************************
	function getmode
	return "CGA80(.t.)"
*****************************************************
	function cga80
	return .t.
*****************************************************
	function vga28
	return .f.
*****************************************************
	function vga50
	return .f.
*****************************************************
	function fontload
	return 0
*****************************************************
	function fontselect
	return 0
*****************************************************
	function fontreset
	return .t.
*****************************************************
	function dosidle
	return .t.

