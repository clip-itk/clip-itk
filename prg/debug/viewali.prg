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
#include "dbinfo.ch"

************************************************
function make_debug_viewali_window(dbg_obj,ntop,nleft,nbottom,nright,nwin)

	local obj:=map(),n,i
	local __dbi_names,__dbri_names, __dboi_names,__blob_names
	#include "dbinames.ch"

	obj:classname   := "DBG_VIEWALIASES"
	obj:dbg		:= dbg_obj
	obj:dbi		:= __dbi_names
	obj:dbri	:= __dbri_names
	obj:dboi	:= __dboi_names
	obj:blob	:= __blob_names
	obj:menuItems	:= {}
	obj:menuPos	:= 1
	obj:cardActive	:= .f.	// или по списку alias или по
				// информации
	obj:name	:= [View work selects]
	obj:top		:= ntop
	obj:left	:= nleft
	obj:bottom	:= nbottom
	obj:right	:= nright
	obj:header	:= [work selects]
	obj:headWin	:= nWin
	obj:data	:= {}
	obj:cdata	:= {}
	obj:select	:= -1
	obj:__data	:= NIL
	obj:color	:= set("debug_colors_dialog")
	obj:__colors	:= split(obj:color,",")
	obj:focus	:= .f.
	obj:browse	:= NIL
	obj:cbrowse	:= NIL

	obj:setFocus	:= @window_setFocus()
	obj:killFocus	:= @window_killFocus()
	obj:close	:= @window_close()
	obj:redraw	:= @window_redraw()
	obj:redrawMenu	:= @window_redrawMenu()
	obj:redrawCard	:= @window_redrawCard()
	obj:redrawCard1	:= @window_redrawCard1()
	obj:redrawCard2	:= @window_redrawCard2()
	obj:redrawCard3	:= @window_redrawCard3()
	obj:redrawCard4	:= @window_redrawCard4()
	obj:redrawCard5	:= @window_redrawCard5()
	obj:redrawCard6	:= @window_redrawCard6()
	obj:handleKey	:= @handleKey()
	obj:reload	:= @window_reload()
	obj:gotoLine	:= @window_gotoLine()
	obj:make_Browse	:= @window_makeBrowse()
	obj:make_CBrowse:= @window_makeCBrowse()

	aadd(obj:menuItems,[DB])
	aadd(obj:menuItems,[Struct])
	aadd(obj:menuItems,[Record])
	aadd(obj:menuItems,[Orders])
	aadd(obj:menuItems,[Blob])
	aadd(obj:menuItems,[RDD])

	setcolor(obj:color)
	obj:winNo:=wopen(obj:top,obj:left,obj:bottom,obj:right,.t.)
	//setcolor(DBG_BORDER_CLR)
	setcolor(obj:color)
	wbox(WB_SINGLE_CLEAR)
	obj:reload()
	obj:cardPos	:= 22

	obj:make_browse()
	obj:make_cbrowse()
	obj:redraw()
	//obj:redrawMenu()
return obj

************************************************
static function window_reload()
	local i,y,mkeys

	y=::dbg:dbg_command("e -binary select()")
	y=substr(y,at(DBG_DELIM,y)+1)
	y=substr(y,at(DBG_DELIM,y)+2)
	y=substr(y,1,len(y)-1)
	::select=str2var(y)

	y=::dbg:dbg_command("e -binary aliasesInfo()")
	y=substr(y,at(DBG_DELIM,y)+1)
	y=substr(y,at(DBG_DELIM,y)+2)
	y=substr(y,1,len(y)-1)
	::__data=str2var(y)

	asize(::data,0)
	mkeys:=mapkeys(::__data)
	for i=1 to len(mkeys)
		y:=iif(mkeys[i]==::select,">"," ")+str(mkeys[i],3,0)
		aadd(::data,{y,::__data[mkeys[i]][DBI_ALIAS],::__data[mkeys[i]][DBI_FCOUNT]})
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
static function window_redrawMenu()
	local i, j
	if ::menuPos<=0
		::menuPos:=len(::menuItems)
	endif
	if ::menuPos>len(::menuItems)
		::menuPos:=1
	endif
	if ::menuPos==1
		::reload()
		::browse:refreshall()
		::browse:forceStable()
		::cbrowse:refreshall()
		::cbrowse:forceStable()
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
	::redrawCard()
return
************************************************
static function window_redrawCard()
	static oldpos:=0,oldMenu:=0,x
	local s, flag:=.f.
	@ 2, ::cardPos+1 clear to ::bottom, ::right
	x:=::browse:curr_record
	if x<=0 .or. x>len(::data)
		return
	endif
	s:=val(substr(::data[::browse:curr_record][1],2))   // number of select
	if oldPos!=s .or. oldMenu!=::menuPos
		asize(::cdata,0)
		flag:=.t.
		oldPos:=s
		oldMenu:=::menuPos
	endif
	if flag
		do case
			case ::menuPos==1
				::redrawCard1(s)
			case ::menuPos==2
				::redrawCard2(s)
			case ::menuPos==3
				::redrawCard3(s)
			case ::menuPos==4
				::redrawCard4(s)
			case ::menuPos==5
				::redrawCard5(s)
			case ::menuPos==6
				::redrawCard6(s)
		endcase
	endif
	if ::cbrowse!=NIL
		//if flag
			::cbrowse:refreshAll()
		//endif
		::cbrowse:forceStable()
	endif
return
************************************************
static function window_redrawCard1(n)
	local i,k,s
	s:=::__data[n]
	if empty(s)
		return
	endif
	k:=mapkeys(::dbi)
	for i=1 to len(k)
		if k[i] $ s
			aadd(::cdata,{::dbi[ k[i] ], toString(s[ k[i] ]) })
		endif
	next
return
************************************************
static function window_redrawCard2(n)
	local y,i
	y:=::dbg:dbg_command("e -binary dbstructInfo("+alltrim(str(n))+")")
	y=substr(y,at(DBG_DELIM,y)+1)
	y=substr(y,at(DBG_DELIM,y)+2)
	y=substr(y,1,len(y)-1)
	y:=str2var(y)
	for i=1 to len(y)
		aadd(::cdata,{padr(y[i][1],10)+":"+;
		y[i][2]+":"+str(y[i][3],3,0)+":"+str(y[i][4],2,0)+;
		":"+toString(y[i][5])+":"+toString(y[i][6]),;
		toString(y[i][7])})
	next
return
************************************************
static function window_redrawCard3(n)
	local y,i,k
	y:=::dbg:dbg_command("e -binary recordInfo("+alltrim(str(n))+")")
	y=substr(y,at(DBG_DELIM,y)+1)
	y=substr(y,at(DBG_DELIM,y)+2)
	y=substr(y,1,len(y)-1)
	y:=str2var(y)
	k:=mapkeys(::dbri)
	for i=1 to len(k)
		if k[i] $ y
			aadd(::cdata,{::dbri[ k[i] ], toString(y[ k[i] ]) })
		endif
	next
return
************************************************
static function window_redrawCard4(n)
	local y,i
	y:=::dbg:dbg_command("e -binary indexesInfo("+alltrim(str(n))+")")
	y=substr(y,at(DBG_DELIM,y)+1)
	y=substr(y,at(DBG_DELIM,y)+2)
	y=substr(y,1,len(y)-1)
	y:=str2var(y)
	for i=1 to len(y)
		aadd(::cdata,{padr(y[i][2],10)+":"+y[i][1],y[i][3]})
	next
return
************************************************
static function window_redrawCard5(n)
return
************************************************
static function window_redrawCard6(n)
return
************************************************
static function window_redraw()
	local i,x,oldwin:=wselect()
	dispbegin()
	wselect(::winNo)
	setcolor(::color)
	clear screen
	x=(::right-::left-len(::header))/2-1
	setcolor(::color)
	//setcolor(DBG_BORDER_CLR)
	//@ -1, 2 say ::header
	@ -1, ::right-5 say "["+alltrim(str(::headWin))+"]"

	::browse:configure()
	@ 1, ::cardPos say replicate("─", ::right )
	for i=0 to ::bottom
		@ i, ::cardPos say "█"
	next
	::redrawMenu()
	if !::focus
		wselect(oldwin)
	endif
	dispend()
return
************************************************
static function handleKey(hkey)
	local ret:=hkey,x:=0,oldwin:=wselect()
	if hkey==0
		return 0
	endif
	if hkey==HASH_ZoomWindow
		return 0
	endif
	dispbegin()
	wselect(::winNo)
	setcolor(::color)
	if hkey==HASH_SwitchPanel
		::cardActive := ! ::cardActive
		::reload()
		::browse:refreshall()
		::browse:forceStable()
		::cbrowse:refreshall()
		::cbrowse:forceStable()
		hkey:=0
	endif
	if hkey==K_LEFT
		::menuPos--
		hkey:=0
	endif
	if hkey==K_RIGHT
		::menuPos++
		hkey:=0
	endif
	if hkey!=0
		if ::cardActive
			x:=::cbrowse:applyKey(hkey)
			::cbrowse:forceStable()
		else
			x:=::browse:applyKey(hkey)
			::browse:forceStable()
			::redrawMenu()
		endif
		if x==1 .or. x==-1
			hkey:=0
		endif
	endif
	if hkey==0
		::redrawMenu()
	endif
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
	setcolor(::color)
	wreopen(::top,::left,::bottom,::right,.t.)
	setcolor(DBG_BORDER_CLR)
	wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
	setcolor(::color)
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
	setcolor(::color)
	wreopen(::top,::left,::bottom,::right,.t.)
	setcolor(::color)
	//setcolor(DBG_BORDER_CLR)
	wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
	clear screen
	::redraw()
	dispend()
return
************************************************
static function window_makeBrowse(self)
	local n

	self:browse		:= TBrowseNew(0,0, maxrow(),self:cardPos-1)
	self:browse:skipBlock 	:= { |x| Skipper(x, self:browse) }
	self:browse:headSep 	:= DBG_HEADSEP
	self:browse:colSep 	:= DBG_COLSEP
	self:browse:data	:= self:data
	self:browse:curr_record	:= 1
	self:browse:freeze	:= 2
	self:browse:chop	:= .t.
	self:browse:__setColor(self:color)
	*
	n:=TBColumnNew("Sel", {|_1|get_data(1,self:browse)})
	n:width:=4
	self:browse:addColumn(n)
	n:=TBColumnNew("Alias", {|_1|get_data(2,self:browse)})
	n:width:=10
	self:browse:addColumn(n)
	n:=TBColumnNew("Fcount", {|_1|get_data(3,self:browse)})
	n:width:=4
	self:browse:addColumn(n)

	self:browse:configure()
return

************************************************
static function window_makeCBrowse(self)
	local n

	self:cBrowse		:= TBrowseNew(2,self:cardPos+1, maxrow(),maxCol())
	self:cBrowse:skipBlock 	:= { |x| Skipper(x, self:cBrowse) }
	//self:cBrowse:headSep 	:= DBG_HEADSEP
	self:cBrowse:colSep 	:= DBG_COLSEP
	self:cBrowse:data	:= self:cdata
	self:cbrowse:chop	:= .t.
	self:cbrowse:curr_record:= 1
	self:cbrowse:__setColor(self:color)

	n:=TBColumnNew("", {|_1|get_data(1,self:cBrowse)})
	n:width:=20
	self:cBrowse:addColumn(n)
	n:=TBColumnNew("", {|_1|get_data(2,self:cBrowse)})
	n:width:=self:right
	self:cBrowse:addColumn(n)

	self:cBrowse:configure()
return

*********************************************
static function get_data(n, browse)
       local ret:=NIL
       if browse:curr_record<=len(browse:data) .and. browse:curr_record>0
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

