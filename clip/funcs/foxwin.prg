/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "ctwin.ch"
***********************************************************
static fx_windows := {}
static fx_wstack  := {}
***********************************************************
*reference fx_winNum
function fx_wDefine(cName,x1,y1,x2,y2,cTitle,cFoot,;
			system,double,panel,none,;
			shadow,zoom,color,all)
	local wNo, w:= map()
	wNo:= fx_winNum(cName)
        if wNo != 0
        	w :=@ fx_windows[wNo]
                w := map()
        endif
        cname := upper(cname)
        w:classname	:= "FX_WINDOW"
        w:name		:= cName
        w:winNo		:= NIL
        w:color		:= iif(empty(color),setcolor(),color)
        w:top		:= iif(x1==NIL,1,x1)
        w:left		:= iif(y1==NIL,0,y1)
        w:bottom	:= iif(x2==NIL,maxrow(.t.),w:top+x2+1)
        w:right		:= iif(y2==NIL,maxcol(.t.),w:left+y2+1)
        w:title		:= alltrim(cTitle)
        w:footer	:= alltrim(cFoot)
        w:system	:= system
        w:double	:= double
        w:panel		:= panel
        w:none		:= none
        w:shadow	:= shadow
        w:zoom		:= zoom
        aadd(fx_windows,{cName,w})
return
***********************************************************
function fx_wActivate(cName)
	local wNo,oWin, bType
        local x1,x2,s1,s2
	wNo:= fx_winNum(cName)
        if wNo == 0
        	return
        endif
	oWin:=fx_windows[wNo][2]
        do case
        	case oWin:system
                	bType:=1  //WB_11
                case oWin:double
                	bType:=2 //WB_0
                case oWin:panel
                	bType:=1 //WB_11
                case oWin:none
                	bType:=""
                otherwise
                	bType:=1 //WB_1
        endcase
        setcolor(oWin:color)
        dispBegin()
        set cursor on
        if oWin:winNo == NIL
        	oWin:winNo := wopen(oWin:top,oWin:left,oWin:bottom,oWin:right,.t.)
                wselect(oWin:winNo)
                if !empty(bType)
                	wbox(bType)
                endif
                clear screen
                x2:=oWin:right-oWin:left-2
               	x1:=(x2-len(oWin:title))/2
                x1:=max(1,x1)
                if !oWin:none .and. !empty(oWin:title)
                        s1:=alltrim(padr(oWin:title,x2))
                        @ -1, x1 say s1
                endif
                if !oWin:none .and. !empty(oWin:footer)
                        s1:=alltrim(padr(oWin:footer,x2))
                        //@ oWin:bottom+1, x1 say s1
                endif
                aadd(fx_wstack,oWin:winNo)
        endif
        dispEnd()
return

***********************************************************
function fx_wDeactivate(cName)
	local wNo,oWin
	wNo:= fx_winNum(cName)
        if wNo == 0
        	return
        endif
	oWin:=fx_windows[wNo][2]
        dispBegin()
        if oWin:winNo != NIL
        	wselect(oWin:winNo)
                wclose()
                oWin:winNo := NIL
                if len(fx_wstack) > 1
                        asize(fx_wstack, len(fx_wstack)-1 )
                endif
                if len(fx_wstack) > 0
                	wselect( atail( fx_wstack ) )
                endif
        endif
        dispEnd()
return

***********************************************************
function fx_wrelease(cName)
	local wNo,oWin
	wNo:= fx_winNum(cName)
        if wNo == 0
        	return
        endif
	oWin:=fx_windows[wNo][2]
        dispBegin()
        if oWin:winNo != NIL
        	wselect(oWin:winNo)
                wclose()
                oWin:winNo := NIL
                if len(fx_wstack) > 1
                        asize(fx_wstack, len(fx_wstack)-1 )
                endif
                if len(fx_wstack) > 0
                	wselect( atail( fx_wstack ) )
                endif
        endif
        dispEnd()
        adel(fx_windows,wNo)
        aSize(fx_windows,len(fx_windows)-1)
return
***********************************************************
static function fx_winNum(cName)
        cName := upper(cName)
return ascan(fx_windows,{|x|x[1]==cname})

***********************************************************
function wExist(cName)
	local wNo,oWin, bType
        local x1,x2,s1,s2
return	fx_winNum(cName) > 0
