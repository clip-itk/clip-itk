/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "config.ch"
#include "inkey.ch"
#include "debug.ch"
#include "imenu.ch"
#include "set.ch"
#include "ctwin.ch"

************************************************
function make_debug_source_window( ntop, nleft, nbottom, nright, fileName, nwin, max)

	local obj:=map()

	obj:classname   :="DBG_SOURCE"
	obj:name	:=[Program source]
	obj:fileName	:=fileName
	obj:top		:=ntop
	obj:oldTop	:=1
	obj:left	:=nleft
	obj:bottom	:=nbottom
	obj:oldBot	:=iif(max==NIL,23,max)
	obj:right	:=nright
	obj:headWin	:=nwin
	obj:edit	:=NIL
	obj:header	:=substr(filename,atr(PATH_DELIM,filename)+1)
	obj:color	:=set("debug_colors_source")
	obj:focus	:=.f.

	obj:sayInfo	:=@window_sayInfo()
	obj:redraw	:=@window_redraw()
	obj:reload	:=@window_reload()
	obj:setFocus	:=@window_setFocus()
	obj:killFocus	:=@window_killFocus()
	obj:handleKey	:=@handleKey()
	obj:close	:=@window_close()
	obj:gotoLine	:=@window_gotoLine()
	obj:highLightAdd:=@highLightAdd()
	obj:highLightDel:=@highLightDel()
	obj:setNumStyle	:=@setNumStyle()
	obj:setTabSize	:=@setTabSize()
	obj:identity	:=@identity()

	setcolor(obj:color)
	obj:winNo = wopen(obj:top,obj:left,obj:bottom,obj:right,.t.)
	setcolor(DBG_BORDER_CLR)
	wbox(iif(obj:focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
	setcolor(obj:color)
	clear screen
	obj:redraw()

return obj
************************************************
static function identity(flag)
	local ret,oldWin:=wselect()
	wselect(::winNo)
	::edit:Identity(flag)
	wselect(oldwin)
return

************************************************
static function setTabSize(tabSize)
	local ret,oldWin:=wselect()
	wselect(::winNo)
	//::edit:tabSize:=tabSize
	//::edit:reLoadFile()
	::edit:setTabSize(tabSize)
	wselect(oldwin)
	::redraw()
return ret

************************************************
static function setNumStyle(flag)
	local ret,oldWin:=wselect()
	wselect(::winNo)
	ret:=::edit:setNumStyle(flag)
	wselect(oldwin)
	::redraw()
return ret

************************************************
static function highLightAdd(num,color)
	local ret,oldWin:=wselect()
	wselect(::winNo)
	ret:=::edit:highLightAdd(num,color)
	wselect(oldwin)
	::redraw()
return ret

************************************************
static function highLightDel(num,color)
	local ret,oldWin:=wselect()
	wselect(::winNo)
	ret:=::edit:highLightDel(num,color)
	wselect(oldwin)
	::redraw()
return ret

************************************************
static function window_gotoLine(num)
	local ret,oldWin:=wselect()
	wselect(::winNo)
	ret:=::edit:gotoLine(num)
	wselect(oldwin)
	::redraw()
return ret
************************************************
static function window_close(par)
	dispbegin()
	wselect(::winno)
	wclose()
	::winNo:=NIL
	::edit:clear()
	::edit:=NIL
	dispend()
return  .t.
************************************************
static function window_setFocus()
	::focus:=.t.
	dispbegin()
	wselect(::winno)
	setcursor(1)
	setcolor(::color)
	wreopen(::top,::left,::bottom,::right,.t.)
	setcolor(DBG_BORDER_CLR)
	wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
	setcolor(::color)
	clear screen
	::redraw()
	dispend()
return
************************************************
static function window_killFocus()
	::focus:=.f.
	dispbegin()
	wselect(::winno)
	setcursor(0)
	setcolor(::color)
	wreopen(::top,::left,::bottom,::right,.t.)
	setcolor(DBG_BORDER_CLR)
	wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
	setcolor(::color)
	::redraw()
	dispend()
return
************************************************
static function window_redraw()
	local oldwin:=wselect()
	dispbegin()
	wselect(::winNo)
	setcolor(::color)
	if ::edit==NIL
		::edit:=textEditNew(0, 0, maxRow(), maxCol(), ::color)
		::edit:loadFile(::filename)
	else
		::edit:refResh()
	endif
	::sayInfo()
	if !::focus
		wselect(oldwin)
	else
		setcursor(1)
	endif
	dispend()
return
************************************************
static function window_reload()
	local x,s, oldwin:=wselect()
	if ::edit==NIL
		return
	endif
	dispbegin()
	wselect(::winNo)
	setcolor(::color)
	::edit:loadFile(::filename)
	::edit:refResh()
	::sayInfo()
	if !::focus
		wselect(oldwin)
	else
		setcursor(1)
	endif
	dispend()
return

************************************************
static func window_sayInfo()
	local a,b,x,s
	a:=row(); b:=col()
	dispbegin()
	setcolor(DBG_BORDER_CLR)
	x=(::right-::left-len(::header))/2-1
	@ -1, x say ::header
	@ -1, ::right-5 say "["+alltrim(str(::headWin))+"]"
	s=substr(iif(::focus,WB_8,WB_1),2,1)
	@ -1, 1 say padr("["+alltrim(str(::edit:line))+"]["+alltrim(str(::edit:pos))+"]",x-2,s)
	setcolor(::color)
	setpos(a,b)
	dispend()
return

************************************************
static function handleKey(hkey)
    local x, ret:=hkey, oldwin:=wselect()
    if hkey==0
		return 0
    endif
    dispbegin()
    wselect(::winNo)
    setcolor(::color)
    if hkey==HASH_ZoomWindow
		x:=::bottom
		::bottom:=::oldbot
		::edit:nbottom:=::bottom
		::oldbot:=x
		x:=::top
		::top:=::oldTop
		::edit:top:=::top
		::oldTop:=x
		setcolor(::color)
		wreopen(::top,::left,::bottom,::right,.t.)
		setcolor(DBG_BORDER_CLR)
		wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
		setcolor(::color)
		clear screen
		::redraw()
		dispend()
		return 0
    endif
    ret:=0
    do case
       case hkey==K_DOWN
	    ::edit:down()
       case hkey==K_PGDN
	    ::edit:pageDown()
       case hkey==K_CTRL_PGDN
	    ::edit:Bottom()
       case hkey==K_UP
	    ::edit:up()
       case hkey==K_PGUP
	    ::edit:pageUp()
       case hkey==K_CTRL_PGUP
	    ::edit:Top()
       case hkey==K_HOME
	    ::edit:home()
       case hkey==K_END
	    ::edit:end()
       case hkey==K_LEFT
	    ::edit:left()
       case hkey==K_RIGHT
	    ::edit:right()
       case hkey==K_CTRL_LEFT
	    ::edit:wordLeft()
       case hkey==K_CTRL_RIGHT
	    ::edit:wordRight()
       otherwise
	    ret:=hkey
    endcase
    //::edit:refresh()
    //::sayInfo()
    if !::focus
	wselect(oldwin)
    else
	setcursor(1)
    endif
    dispend()
return ret
