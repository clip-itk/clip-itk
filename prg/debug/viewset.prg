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
function make_debug_viewset_window(dbg_obj,ntop,nleft,nbottom,nright,nwin)

	local obj:=map(),n,i

	obj:classname   := "DBG_VIEWSET"
	obj:dbg		:= dbg_obj
	obj:name	:= [View info]
	obj:top		:= ntop
	obj:left	:= nleft
	obj:bottom	:= nbottom
	obj:right	:= nright
	obj:header	:= [current settings]
	obj:headWin	:= nWin
	obj:data	:= {}
	obj:color	:= set("debug_colors_dialog")
	obj:focus	:= .f.
	obj:setFocus	:= @window_setFocus()
	obj:killFocus	:= @window_killFocus()
	obj:close	:= @window_close()
	obj:redraw	:= @window_redraw()
	obj:handleKey	:= @handleKey()
	obj:reload	:= @window_reload()
	obj:gotoLine	:= @window_gotoLine()

	//setcolor(obj:color)
	obj:winNo:=wopen(obj:top,obj:left,obj:bottom,obj:right,.t.)
	//obj:winNo:=wopen(0,0,dbg_obj:maxrow,dbg_obj:maxcol,.t.)
	//obj:winNo:=wopen(2,15,22,65,.t.)
	setcolor(obj:color)
	//setcolor(DBG_BORDER_CLR)
	wbox(WB_SINGLE_CLEAR)
	obj:reload()
	obj:browse 	:= TBrowseNew(0,0, maxrow(),maxcol())
	obj:browse:chop	:= .t.
	obj:browse:__setColor(obj:color)
	obj:browse:skipBlock 	:= { |x| Skipper(x, obj:browse) }
	obj:browse:headSep 	:= DBG_HEADSEP
	obj:browse:colSep 	:= DBG_COLSEP
	obj:browse:data		:= obj:data
	obj:browse:curr_record	:= 1
	obj:browse:freeze	:= 2
	*
	n:=TBColumnNew("Num", {|_1|get_data(1,obj:browse)})
	n:width:=4
	obj:browse:addColumn(n)
	n:=TBColumnNew("Name", {|_1|get_data(2,obj:browse)})
	n:width:=15
	obj:browse:addColumn(n)
	n:=TBColumnNew("Local value", {|_1|get_data(3,obj:browse)})
	n:width:=25
	obj:browse:addColumn(n)
	n:=TBColumnNew("Remote value", {|_1|get_data(4,obj:browse)})
	n:width:=25
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
	local __set_names,i,l,x,y,keys
	#include "setnames.ch"
	keys:=mapkeys(__set_names)
	l:=len(keys)
	asize(::data,0)
	for i=1 to l
		x=set(keys[i])   // local data
		y=::dbg:dbg_command("e set("+alltrim(str(keys[i]))+")")
		y=substr(y,at(DBG_DELIM,y)+1)
		y=substr(y,at(DBG_DELIM,y)+2)
		y=strtran(y,"&\n","")
		aadd(::data,{keys[i],__set_names[keys[i]],valtype(x)+":"+toString(x),y})
		//aadd(::data,{keys[i],__set_names[keys[i]],valtype(x)+":"+toString(x),x})
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
static function window_redraw()
	local x,oldwin:=wselect()
	wselect(::winNo)
	dispbegin()
	setcolor(::color)
	clear screen
	x=(::right-::left-len(::header))/2-1
	//setcolor(DBG_BORDER_CLR)
	@ -1, x say ::header
	@ -1, ::right-5 say "["+alltrim(str(::headWin))+"]"
	//setcolor(::color)
	::browse:configure()
	if !::focus
		wselect(oldwin)
	endif
	dispend()
return
************************************************
static function handleKey(hkey)
	local ret:=hkey,x,oldwin:=wselect()
	local ret1
	if hkey==0
		return 0
	endif
	dispbegin()
	wselect(::winNo)
	setcolor(::color)
	if hkey==HASH_ZoomWindow
		return 0
	endif
	ret1=::browse:applykey(hkey)
	if ret1==0
		ret:=0
	endif
	do while !::browse:stabilize()
	enddo
	//::browse:forceStable()
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
	//wreopen(21,2,::dbg:maxrow,::dbg:maxcol,.t.)
	//wreopen(2,15,22,65,.t.)
	setcolor(::color)
	//setcolor(DBG_BORDER_CLR)
	wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
	//setcolor(::color)
	clear screen
	::reload()
	::redraw()
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
