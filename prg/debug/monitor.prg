/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "inkey.ch"
#include "debug.ch"
#include "imenu.ch"
#include "set.ch"
#include "ctwin.ch"

************************************************
function make_debug_monitor_window(dbg_obj,ntop,nleft,nbottom,nright,nwin)

	local obj:=map(),n,i

	obj:classname   := "DBG_MONITOR"
	obj:dbg		:= dbg_obj
	obj:name	:= [Monitor ]
	obj:top		:= ntop
	obj:left	:= nleft
	obj:bottom	:= nbottom
	obj:right	:= nright
	obj:header	:= [variable values]
	obj:headWin	:= nWin
	obj:data	:= {}
	obj:menuItems	:= {}
	obj:menuPos	:= 1
	obj:cardPos	:= 3
	obj:color	:= set("debug_colors_dialog")
	obj:__colors	:= split(obj:color,",")
	obj:focus	:= .f.
	obj:setFocus	:= @window_setFocus()
	obj:killFocus	:= @window_killFocus()
	obj:close	:= @window_close()
	obj:redraw	:= @window_redraw()
	obj:redrawMenu	:= @window_redrawMenu()
	obj:handleKey	:= @handleKey()
	obj:reload	:= @window_reload()
	obj:gotoLine	:= @window_gotoLine()

	aadd(obj:menuItems,[Static])
	aadd(obj:menuItems,[Local])
	aadd(obj:menuItems,[Private])
	aadd(obj:menuItems,[Public])

	//setcolor(obj:color)
	obj:winNo:=wopen(obj:top,obj:left,obj:bottom,obj:right,.t.)
	setcolor(obj:color)
	//setcolor(DBG_BORDER_CLR)
	wbox(WB_SINGLE_CLEAR)
	obj:reload()
	obj:browse 	:= TBrowseNew(2,0, maxrow(),maxcol())
	obj:browse:chop	:= .t.
	obj:browse:__setColor(obj:color)
	obj:browse:skipBlock 	:= { |x| Skipper(x, obj:browse) }
	obj:browse:headSep 	:= DBG_HEADSEP
	obj:browse:colSep 	:= DBG_COLSEP
	obj:browse:data		:= obj:data
	obj:browse:curr_record	:= 1
	obj:browse:freeze	:= 2
	*
	n:=TBColumnNew("", {|_1|get_data(1,obj:browse)})
	n:width:=15
	obj:browse:addColumn(n)
	n:=TBColumnNew("", {|_1|get_data(2,obj:browse)})
	n:width:=1
	obj:browse:addColumn(n)
	n:=TBColumnNew("", {|_1|get_data(3,obj:browse)})
	n:width:=obj:right
	obj:browse:addColumn(n)
	obj:browse:configure()
	obj:redraw()
return obj

*********************************************
static function get_data(n, browse)
       local ret:=NIL
       if browse:curr_record<=len(browse:data)
	  ret=browse:data[browse:curr_record][n]
       endif
return ret
*********************************************
STATIC FUNCTION Skipper(n, browse)
    LOCAL i
    browse:curr_record:=max(1,browse:curr_record)
    browse:curr_record:=min(len(browse:data),browse:curr_record)
    i=browse:curr_record
    browse:curr_record+=n
    browse:curr_record:=max(1,browse:curr_record)
    browse:curr_record:=min(len(browse:data),browse:curr_record)
RETURN browse:curr_record-i

************************************************
static function window_reload()
	local i,y,mv
	y:={"static","local","private","public","field"}
	y:=y[::menuPos]
	y:=::dbg:dbg_command("ls "+y)
	//y:=substr(y,at(DBG_DELIM,y)+2 )
	y:=substr(y,at(":",y)+2 )
	y:=substr(y,1,len(y)-1)
	mv:=split(y," ")
	asort(mv)

	asize(::data,0)
	for i=1 to len(mv)
		y:=::dbg:dbg_command("p -binary "+mv[i])
		y:=substr(y,at(DBG_DELIM,y)+1)
		y:=substr(y,at(DBG_DELIM,y)+2)
		y:=substr(y,1,len(y)-1)
		y:=str2var(y)
		aadd(::data,{mv[i],valtype(y),toString(y)})
	next
return
************************************************
static function window_gotoLine(num)
	if num>0 .and. num<=len(::browse:data)
		::browse:curr_record:=num
		::browse:refreshAll()
		::browse:forceStable()
		return .t.
	endif
return .f.
************************************************
static function window_redrawMenu(flag)
	static oldMenuPos:=0
	local i, j
	@ 1,0 say replicate("€",::right) // utf-8: "â”€"
	flag:=iif(flag==NIL,.f.,flag)
	if ::menuPos<=0
		::menuPos:=len(::menuItems)
	endif
	if ::menuPos>len(::menuItems)
		::menuPos:=1
	endif
	@ 0, ::cardPos+1 say space(::right)
	devpos(0,::cardPos+2)
	j:=col()
	for i=1 to len(::menuItems)
		if i==::menuPos
		   j:=col()
		endif
		devout(" "+::menuItems[i]+" ",::__colors[2])
		devout("  ")
	next
	devpos(0,j)
	devout(" "+::menuItems[::menuPos]+" ",::__colors[3])
	devpos(0,j)
	if oldMenuPos!=::menuPos .or. flag
		::reload()
		::browse:configure()
		oldMenuPos:=::menuPos
	endif
return
************************************************
static function window_redraw()
	local oldwin:=wselect()
	dispbegin()
	wselect(::winNo)
	setcolor(::color)
	//clear screen
	@ -1, ::right-5 say "["+alltrim(str(::headWin))+"]"
	::redrawMenu()
	if !::focus
		wselect(oldwin)
	endif
	dispend()
return
************************************************
static function handleKey(hkey)
	local ret:=hkey,x,oldwin:=wselect()
	if hkey==0
		return 0
	endif
	dispbegin()
	wselect(::winNo)
	setcolor(::color)
	if hkey==HASH_ZoomWindow
		return 0
	endif
	if hkey==K_LEFT
		::menuPos--
		::redrawMenu()
		hkey:=0
	endif
	if hkey==K_RIGHT
		::menuPos++
		::redrawMenu()
		hkey:=0
	endif
	if hKey!=0
		::browse:applykey(hkey)
	endif
	::browse:forceStable()
	if !::focus
		wselect(oldwin)
	endif
	dispend()
return ret
***************************************************************************
static function window_close()
	dispbegin()
	wselect(::winno)
	wclose()
	dispend()
return .t.
************************************************
static function window_setFocus()
	::focus:=.t.
	dispbegin()
	wselect(::winno)
	setcursor(1)
	wreopen(::top,::left,::bottom,::right,.t.)
	setcolor(::color)
	//setcolor(DBG_BORDER_CLR)
	wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
	//setcolor(::color)
	clear screen
	::reload()
	::redraw()
	::redrawMenu(.t.)
	dispend()
return
************************************************
static function window_killFocus()
	::focus:=.f.
	dispbegin()
	wselect(::winno)
	setcursor(0)
	wreopen(::top,::left,::bottom,::right,.t.)
	setcolor(::color)
	//setcolor(DBG_BORDER_CLR)
	wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
	//setcolor(::color)
	clear screen
	::redraw()
	dispend()
return
