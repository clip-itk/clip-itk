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
function make_debug_values_window(dbg_obj,ntop,nleft,nbottom,nright,nwin,max)

	local obj:=map()

       	obj:classname	:= "DBG_VALUES"
        obj:dbg		:= dbg_obj
        obj:name	:= [Debug variables]
        obj:top		:= ntop
        obj:left	:= nleft
        obj:bottom	:= nbottom
        obj:oldBot	:= iif(max==NIL,23,max)
        obj:right	:= nright


        obj:header	:= [Values]
        obj:headWin	:= nWin
        obj:points	:= {}
        obj:curVar	:= 0
        obj:curPos	:= 0
        obj:color	:= set("debug_colors_values")
        obj:focus	:= .f.
        obj:prompt	:= "> "
        obj:redraw	:= @window_redraw()
        obj:add		:= @window_add()
        obj:delete	:= @window_delete()
        obj:deleteAll	:= @window_deleteAll()
        obj:setFocus	:= @window_setFocus()
        obj:killFocus	:= @window_killFocus()
        obj:handleKey	:= @handleKey()
        obj:reload	:= @window_reload()
        obj:close	:= @window_close()
        obj:gotoLine	:= @window_gotoLine()

        setcolor(obj:color)
        obj:winNo:=wopen(obj:top,obj:left,obj:bottom,obj:right,.t.)
        setcolor(DBG_BORDER_CLR)
        wbox(WB_SINGLE_CLEAR)
        setcolor(obj:color)
        obj:redraw()
return obj

************************************************
static function window_reload()
return
************************************************
static function window_gotoLine(num)
	if num>0 .and. num<=len(::points)
        	::curVar:=num
                return .t.
        endif
return .f.
************************************************
static function window_close(par)
        /*
	if par!=NIL .and. par
        	dispbegin()
        	wselect(::winno)
                wclose()
                dispend()
                return .t.
        endif
        */
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
        local i,b,e,x,y,s,l, oldwin:=wselect()
        wselect(::winNo)
        ::curVar:=min(::curVar,len(::points))
        ::curVar:=max(::curVar,1)
        ::curPos:=min(::curPos,maxrow()+1)
        ::curPos:=min(max(::curPos,1),::curVar)
        l:=len(alltrim(str(len(::points),5,0)))
        dispbegin()
        setcolor(::color)
        clear screen
        setcolor(DBG_BORDER_CLR)
        x=(::right-::left-len(::header))/2-1
        @ -1, x say ::header
        @ -1, ::right-5 say "["+alltrim(str(::headWin))+"]"
        setcolor(::color)
        b:=::curVar-::curPos
        e=min(maxrow()+1,len(::points))
        x:=0
        for i=1 to e
        	if (b+i)>len(::points)
                	exit
                endif
        	s:= str(b+i,l,0)+") " //+::points[b+i]+":"
                if ::dbg:dbgconnect!=NIL
                	y=::dbg:dbg_command("p "+::points[b+i])
                	y:=substr(y,1,len(y)-1)
                	if lower(substr(y,1,2))=="no"
                		y=::dbg:dbg_command("e "+::points[b+i])
        			y=substr(y,at(DBG_DELIM,y)+1)
        			y=substr(y,at(DBG_DELIM,y)+2)
                		y:=substr(y,1,len(y)-1)
                        	s+=::points[b+i]+":"
                	endif
                	s+=y
                else
                	s+=::points[b+i]
                endif
                s:=padr(s,::right+1)
                if b+i==::curVar
        		@ i-1,0 say s color substr(::color,at(",",::color)+1)
                else
        		@ i-1,0 say s
                endif
        next
        if !::focus
        	wselect(oldwin)
        endif
        dispend()
return

************************************************
static function window_add(str)
	local  oldwin:=wselect(), s, getlist:={}
        if !empty(str)
        	if ascan(::points,{|x|x==str})==0
        	   aadd(::points,str)
        	   ::curVar:=len(::points)
                   ::curPos:=::curVar
                   ::redraw()
                   return .t.
                endif
        else
               aadd(::points,"")
               ::curVar:=len(::points)
               ::curPos:=::curVar
               ::redraw()
               wselect(::winNo)
               s:=space(256)
               //@ maxrow(),0 say [Enter a new expression:] get s
               //read
               readkeyb(,, [Enter a new expression:],@s )
               ::points[len(::points)]:=alltrim(s)
               ::redraw()
               wselect(oldwin)
        endif
return .f.
************************************************
static function window_delete(num)
	if num>0 .and. num<=len(::points) .and. len(::points)>0
		adel(::points,num)
                asize(::points,len(::points)-1)
                if ::curVar>num
                	::curVar--
                endif
                ::redraw()
		return .t.
        endif
return .f.
************************************************
static function window_deleteAll()
	::points:={}
        ::curVar:=0
        ::curPos:=0
        ::redraw()
return .f.
************************************************
static function window_prompt(str,addflag)
return
************************************************
static function handleKey(hkey)
	local ret:=hkey,x,oldwin:=wselect()
        local vname,y
        if hkey==0
        	return 0
        endif
        dispbegin()
	wselect(::winNo)
        setcolor(::color)
        if hkey==HASH_ZoomWindow
               	x:=::bottom
                ::bottom:=::oldBot
                ::oldBot:=x
        	setcolor(::color)
        	::winNo = wreopen(::top,::left,::bottom,::right,.t.)
        	setcolor(DBG_BORDER_CLR)
        	wbox(iif(::focus,WB_FULL_CLEAR,WB_SINGLE_CLEAR))
        	setcolor(::color)
        	clear screen
                ::redraw()
                dispend()
                return 0
        endif
        if hkey==K_UP .or. hkey==K_DOWN
                ::curVar:=iif(hkey==K_UP,::curVar--,::curVar++)
                ::curPos:=iif(hkey==K_UP,::curPos--,::curPos++)
                ::redraw()
                dispend()
                return 0
        endif
        if hkey==K_ENTER .and. ::curVar>0 .and. ::curVar<=len(::points)
                vname:=::points[::curVar]
		y:=::dbg:dbg_command("p -binary "+vname)
                if lower(substr(y,1,2))=="no"
                else
        		y:=substr(y,at(DBG_DELIM,y)+1)
        		y:=substr(y,at(DBG_DELIM,y)+2)
        		y:=substr(y,1,len(y)-1)
                        while dispcount()>0
                		dispend()
                        enddo
        		::dbg:viewVar(vname,1,str2var(y),.t.)
                endif
                ret:=0
        endif
        if hkey==K_CTRL_Y .or. hkey==K_DEL .or. hkey==HASH_DeletePoint
        	::delete(::curVar)
                ret:=0
        endif
        if !::focus
        	wselect(oldwin)
        endif
        dispend()
return ret

