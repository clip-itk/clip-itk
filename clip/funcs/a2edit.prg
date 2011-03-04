/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "box.ch"
#include "Inkey.ch"
#include "Setcurs.ch"
#include "Error.ch"
#include "config.ch"
#include "dbedit.ch"


#define MY_HEADSEP      translate_charset(__CHARSET__,host_charset(),"†∂†") // utf-8: "‚ïê‚ï§‚ïê"
#define MY_COLSEP       translate_charset(__CHARSET__,host_charset()," Å ") // utf-8: " ‚îÇ "

memvar __a2_data, curr_record,__userfunc


function a2edit

    LOCAL bSaveHandler, error, status
    LOCAL browse                        // The TBrowse object
    LOCAL cColorSave, nCursSave         // State preservers
    LOCAL nKey                          // Keystroke
    LOCAL lMore                         // Loop control
    LOCAL cScreen,ret
    private __userfunc, curr_record:=1

    parameters  top, left, down, right, __a2_data, user_func, msay, headers, none1,non2,none3, footers

    if len(__a2_data)==0 .or. len(__a2_data[1])==0
       alert([Error A2EDIT; What~s Edit ?])
       return
    endif
    top  := iif( top  == NIL, 0, top )
    left := iif( left == NIL, 0, left )
    down  := iif( down  == NIL, maxrow(), down )
    right:= iif( right== NIL, maxcol() , right )
    top=max(top,0)
    left=max(left,0)
    down=min(down,maxrow())
    right=min(right,maxcol())

    cScreen := SAVESCREEN()
    nCursSave := SetCursor(SC_NONE)

    browse := TBrowseDB(Top, Left, Down, Right)
    StockBrowseNew(browse, len(__a2_data), headers, footers )
    browse:skipBlock := { |x| Skipper(x, browse) }
    browse:headSep := MY_HEADSEP
    browse:colSep := MY_COLSEP
    FancyColors(browse)
    lMore := .T.
    DO WHILE lMore
	IF browse:colPos <= browse:freeze
	    browse:colPos := browse:freeze + 1
	ENDIF

	nKey := 0
	DO WHILE nKey == 0 .AND. .NOT. browse:stable
	    browse:stabilize()
	    nKey := InKey()
	ENDDO

	IF browse:stable
		IF browse:hitTop .OR. browse:hitBottom
		    TONE(125, 0)
		ENDIF
		browse:refreshCurrent()
		browse:ForceStable()
		nKey := InKey(0)
	ENDIF

	IF empty(user_func) .and. (nKey == K_ESC .or. nkey==K_ENTER)
	    lMore := .F.
	ELSE
	    ApplyKey(browse, nKey)

	    if empty(user_func)
	       loop
	    endif
	    status:=DE_IDLE
	    if lastrec()==0
	       status:=DE_EMPTY
	    endif
	    if browse:hitTop
	       status:=DE_HITTOP
	    endif
	    if browse:hitBottom
	       status:=DE_HITBOTTOM
	    endif
	    // DE_EXCEPT           4          // Key don't handled in DBEDIT()
	    if "(" $ user_func
		__userfunc:=user_func
	    else
		__userfunc:=user_func+"("+alltrim(str(status))+","+alltrim(str(browse:colPos))+")"
	    endif
	    ret=&__userfunc
	    if ret==DE_ABORT
	       lmore:=.f.
	    endif
	    if ret==DE_REFRESH
	       browse:refreshAll()
	    endif
	ENDIF
    ENDDO

    SETCURSOR(nCursSave)
    RESTSCREEN(,,,,cScreen)

return  NIL

function __a2_edit_get_a2_data(n, new_data)
       local ret:=NIL
       if n<=len(__a2_data) .and. curr_record<=len(__a2_data[n])
	  ret=__a2_data[n][curr_record]
	  if new_data!=NIL
	     __a2_data[n][curr_record]:=new_data
	  endif
       endif
return ret

STATIC FUNCTION Skipper(n, browse)
    LOCAL i
    curr_record:=max(1,curr_record)
    curr_record:=min(len(__a2_data[1]),curr_record)
    i=curr_record
    curr_record+=n
    curr_record:=max(1,curr_record)
    curr_record:=min(len(__a2_data[1]),curr_record)
RETURN curr_record-i

STATIC PROCEDURE ApplyKey(browse, nKey)
    local status
    DO CASE
    CASE nKey == K_DOWN
	browse:down()
    CASE nKey == K_PGDN
	browse:pageDown()
    CASE nKey == K_CTRL_PGDN
	browse:goBottom()
    CASE nKey == K_UP
	browse:up()
    CASE nKey == K_PGUP
	browse:pageUp()
    CASE nKey == K_CTRL_PGUP
	browse:goTop()
    CASE nKey == K_RIGHT
	browse:right()
    CASE nKey == K_LEFT
	browse:left()
    CASE nKey == K_HOME
	browse:home()
    CASE nKey == K_END
	browse:end()
    CASE nKey == K_CTRL_LEFT
	browse:panLeft()
    CASE nKey == K_CTRL_RIGHT
	browse:panRight()
    CASE nKey == K_CTRL_HOME
	browse:panHome()
    CASE nKey == K_CTRL_END
	browse:panEnd()
    OTHERWISE
    ENDCASE
RETURN

STATIC PROCEDURE FancyColors(browse)
    LOCAL n, column
    LOCAL xValue
    browse:colorSpec := setcolor()
    if empty(browse:colorSpec)
	 browse:colorSpec := "N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R"
    else
	 browse:colorSpec := setcolor()+", N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R"
    endif
    FOR n := 1 TO browse:colCount
	column := browse:getColumn(n)
	xValue := EVAL(column:block)

	IF VALTYPE(xValue) != "N"
	    column:defColor := {3, 4}
	ELSE
	    column:colorBlock := {|x| if( x < 0, {7, 8}, {5, 6} )}
	    column:defColor := {7, 8}
	ENDIF
    NEXT
RETURN

STATIC FUNCTION StockBrowseNew( browse, len_data, headers, footers )
    LOCAL n, column, cType, strhead, strfoot
    local __cname
    if empty(headers)
	  headers:={}
    endif
    if empty(footers)
	  footers:={}
    endif
    if valtype(headers)=="C"
       strhead=headers
       headers:={}
       asize(headers,len_data)
       afill(headers,strhead)
    endif
    if valtype(headers)=="A"
       for n = len(headers)+1 to len_data
	   aadd(headers,str(n))
       next
    endif
    if valtype(footers)=="C"
       strfoot=footers
       footers:={}
       asize(footers,len_data)
       afill(footers,strfoot)
    endif
    if valtype(footers)=="A"
       for n = len(footers)+1 to len_data
	   aadd(footers,"")
       next
    endif
    FOR n := 1 TO len_data
	__cname:="{|_1| __a2_edit_get_a2_data("+alltrim(str(n))+",_1)}"
	__cname:=&__cname
	column := TBColumnNew("__a2_data["+alltrim(str(n))+"]", __cname)
	column:heading:=headers[n]
	column:footing:=footers[n]
	browse:addColumn(column)
    next
RETURN NIL

