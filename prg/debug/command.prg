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
function make_debug_command_window(ntop,nleft,nbottom,nright,nwin)

	local obj:=map()

       	obj:classname    := "DBG_COMMAND"
        obj:name:=[Debug commands]
        obj:top:=ntop
        obj:oldtop:=1
        obj:left:=nleft
        obj:bottom:=nbottom
        obj:right:=nright


        obj:header:=[Commands]
        obj:headWin:=nWin
        obj:current:=0
        obj:history:={}
        obj:commands:={}
        obj:color:=set("debug_colors_view")
        obj:focus:=.f.
        obj:prompt:="> "
        obj:command:=""
        obj:redraw:=@window_redraw()
        obj:put:=@window_put()
        obj:add:=@window_add()
        obj:setFocus:=@window_setFocus()
        obj:killFocus:=@window_killFocus()
        obj:sayPrompt:=@window_prompt()
        obj:handleKey:=@handleKey()
        obj:reload:=@window_reload()
        obj:close:=@window_close()
        obj:gotoLine:=@window_gotoLine()

        setcolor(obj:color)
        obj:winNo:=wopen(obj:top,obj:left,obj:bottom,obj:right,.t.)
        setcolor(DBG_BORDER_CLR)
        wbox(WB_SINGLE_CLEAR)
        obj:redraw()
        obj:put(obj:prompt)

return obj

************************************************
static function window_reload()
return
************************************************
static function window_gotoLine(num)
return .t.
************************************************
static function window_close(par)
	if par!=NIL .and. par
        	wselect(::winno)
                wclose()
                return .t.
        endif
return .f.
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
       	clear screen
        ::redraw()
        dispend()
return
************************************************
static function window_redraw()
        local x, oldwin:=wselect()
        dispbegin()
        wselect(::winNo)
        setcolor(DBG_BORDER_CLR)
        x=(::right-::left-len(::header))/2-1
        @ -1, 1 say time()
        @ -1, x say ::header
        @ -1, ::right-5 say "["+alltrim(str(::headWin))+"]"
        setcolor(::color)
        x=max(len(::history)-(::bottom-::top)+1,1)
        for x=x to len(::history)
        	? ::history[x]
        next
        ? ::prompt
        if !::focus
        	wselect(oldwin)
        endif
        dispend()
return

************************************************
static function window_put(str)
	local oldwin:=wselect()
        dispbegin()
	wselect(::winno)
        setcolor(::color)
        @ row(),0 say ""
        ? str
        if !empty(str) .and. !(atail(::history)==str)
        	aadd(::history,str)
        endif
        if !::focus
           wselect(oldwin)
        endif
        dispend()
return
************************************************
static function window_add(str)
        if empty(str) .and. !empty(::command)
        	str:=::command
        endif
        if !empty(str)
        	if str!=atail(::commands)
        	   aadd(::commands,str)
        	   ::current:=len(::commands)+1
                endif
        endif
return
************************************************
static function window_prompt(str,addflag)
	local oldwin:=wselect(), a,b
        a:=row(); b:=col()
        dispbegin()
	wselect(::winno)
        setcolor(DBG_BORDER_CLR)
        @ -1, 1 say time()
        setcolor(::color)
        a:=max(0,a)
        setpos(a,b)
        setcursor(1)
        @ row(),0 say space(::right-::left-1)
        setpos(row(),0)
        if str!=NIL
        	?? ::prompt+str
                if addflag==NIL .or. addflag
        		aadd(::history,::prompt+str)
                endif
        else
        	?? ::prompt
        endif
        if !::focus
           wselect(oldwin)
        endif
        dispend()
return
************************************************
static function handleKey(hkey)
	local ret:=hkey,x,oldwin:=wselect()
        setcolor(::color)
        if hkey==0
        	return 0
        endif
        dispbegin()
        wselect(::winno)
        if hkey==HASH_ZoomWindow
               	x:=::top
                ::top:=::oldtop
                ::oldtop:=x
        	setcolor(::color)
        	::winNo = wreopen(::top,::left,::bottom,::right,.t.)
        	setcolor(DBG_BORDER_CLR)
        	wbox(iif(::focus,WB_DOUBLE_CLEAR,WB_SINGLE_CLEAR))
        	setcolor(::color)
        	clear screen
                ::redraw()
                dispend()
                return 0
        endif
        if hkey==K_UP .or. hkey==K_DOWN
                ::current:=iif(hkey==K_UP,::current--,::current++)
                ::current:=min(::current,len(::commands)+1)
                ::current:=max(::current,1)
                if ::current<=len(::commands)
                	::command:=::commands[::current]
                else
                	::command:=""
                endif
                ::sayPrompt(::command,.f.)
                dispend()
                return 0
        endif
        if hkey==K_BS
        	::command:=left(::command,len(::command)-1)
                ::sayPrompt(::command,.f.)
                dispend()
           	return 0
        endif
        if hkey>=32 .and. hkey<=256
           	::command+=chr(hkey)
                ::sayPrompt(::command,.f.)
                dispend()
           	return 0
        endif
        if !::focus
        	wselect(oldwin)
        endif
        dispend()
return ret

