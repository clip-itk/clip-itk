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



function dbedit (top, left, down, right,;
		 fields, user_func,;
		 msay, headers, headSep,;
		 colSep,footSep, footers)

    LOCAL bSaveHandler, error, status
    LOCAL browse                        // The TBrowse object
    LOCAL cColorSave, nCursSave         // State preservers
    LOCAL nKey                          // Keystroke
    LOCAL lMore                         // Loop control
    LOCAL cScreen,filter
    local row,col,ret
    local first:=.t.

    user_func := iif( valtype(user_func) $ "CB", user_func, NIL)
    top  := iif( top  == NIL, 0, top )
    left := iif( left == NIL, 0, left )
    down  := iif( down  == NIL, maxrow(), down )
    right:= iif( right== NIL, maxcol() , right )
    top=max(top,0)
    left=max(left,0)
    down=min(down,maxrow())
    right=min(right,maxcol())

//    cScreen := SAVESCREEN(top, left, down, right)
    nCursSave := SetCursor(SC_NONE)

    browse := TBrowseDB(Top, Left, Down, Right)
    browse:setkey(K_ESC,NIL)
    StockBrowseNew(browse, fields, headers, footers, msay, headSep, colSep, footSep )
    browse:skipBlock := { |x|  Skipper(x, browse) }
    browse:headSep := DE_HEADSEP
    browse:colSep := DE_COLSEP
    FancyColors(browse)

    browse:forceStable()

    lMore := .T.
    DO WHILE lMore
        IF browse:colPos <= browse:freeze
            browse:colPos := browse:freeze + 1
        ENDIF

        DO WHILE !browse:stable .and. nextkey()==0
            browse:stabilize()
        ENDDO

        nKey := InKey()
        ret:=DE_CONT

        if nkey==0 .or. first
        	row:=row(); col:=col()
        	ret=callUserFunc(browse,user_func,0)
        	dispoutAt(row,col,"")

        	if ret==DE_ABORT
               		lmore:=.f.
               		loop
        	endif
        	if ret==DE_REFRESH
               		browse:refreshAll()
                        //loop
        	endif
                first:=.f.
                if nkey==0
               		nKey := InKey(0)
                endif
        endif

	if setKey(nKey)!=NIL
		eval(setKey(nKey),procname(),procline(),readvar())
               	loop
	endif

        IF empty(user_func) .and. (nKey == K_ESC .or. nkey==K_ENTER)
            lMore := .F.
            loop
        endif
        filter:=dbfilter()
        if !ApplyKey(browse, nKey)
        	row:=row(); col:=col()
        	ret=callUserFunc(browse,user_func,nkey)
                first:=.t.
        	dispoutAt(row,col,"")
        endif
        if ret==DE_ABORT
        	lmore:=.f.
        endif
        if filter != dbfilter() .and. used()
        	ret=DE_REFRESH
        endif
        if ret==DE_REFRESH
        	browse:refreshAll()
        endif
    ENDDO
/*
    if used()
    	browse:forcestable()
    endif
*/

    SETCURSOR(nCursSave)
//    RESTSCREEN(top, left, down, right,cScreen)

return  NIL
********************
STATIC FUNCTION callUserFunc( browse, user_func, nKey )
   LOCAL Mode:=0,ret:=DE_CONT,s,i:=1

   DO CASE
   CASE nKey != 0
   	mode := DE_EXCEPT
   CASE browse:hitEmpty
   	mode := DE_EMPTY
   CASE browse:hitBottom
   	mode := DE_HITBOTTOM
   CASE browse:hitTop
   	mode := DE_HITTOP
   OTHERWISE
        mode := DE_IDLE
   ENDCASE

   if !empty(user_func)
   	if "(" $ user_func
   		ret:=&user_func
   	else
        	s:=user_func+"("+alltrim(str(mode))+","+alltrim(str(browse:ColPos()))+")"
                ret=&s
   		//ret:=clip( user_func, mode, browse:ColPos() )
   	endif

   	if ret==DE_CONT .and. mode==DE_EMPTY
       		ret=DE_REFRESH
   	endif
   endif

return ret
***********************************
STATIC FUNCTION Skipper(n, browse)
    LOCAL i:=0
    IF n == 0 .OR. RECCOUNT() == 0
    	SKIP 0
    ELSEIF n > 0 //.and. RECNO() != RECCOUNT() + 1
        DO WHILE i < n
            SKIP 1
            IF ( EOF() )
                SKIP -1
                EXIT
            ENDIF
            i++
        ENDDO
    ELSEIF n < 0
        DO WHILE i > n
            SKIP -1
            IF ( BOF() )
                EXIT
            ENDIF
            i--
        ENDDO
    ENDIF
RETURN i

STATIC PROCEDURE ApplyKey(browse, nKey)
    local ret:=.f. ,b
    b := browse:setkey(nKey)
    if b != NIL
    	eval(b,browse,nkey)
        ret := .t.
    endif
RETURN ret

STATIC PROCEDURE FancyColors(browse)
    LOCAL n, column
    LOCAL xValue
    browse:colorSpec := setcolor()
    if empty(browse:colorSpec)
         browse:colorSpec := DE_COLOR
    else
         browse:colorSpec := setcolor()+","+DE_COLOR
    endif
    FOR n := 1 TO browse:colCount
        column := browse:getColumn(n)
        xValue := EVAL(column:block)

        column:defColor := {1, 2}
    NEXT
RETURN

STATIC FUNCTION StockBrowseNew( browse, fields, headers, footers, msay, hSep, cSep, fSep )
    LOCAL n, column, cType, strhead, strfoot, strpict, strcsep, strhsep, strfsep
    local __cname
    if empty( fields )
       fields:={}
       asize(fields,fcount())
       afields(fields)
    endif
    if empty(headers)
          headers:={}
    endif
    if empty(footers)
          footers:={}
    endif
    if empty(msay); msay:=array(len(fields)); endif
    if empty(hSep); hSep:=array(len(fields)); endif
    if empty(cSep); cSep:=array(len(fields)); endif
    if empty(fSep); fSep:=array(len(fields)); endif
    if valtype(headers)=="C"
       strhead=headers
       headers:={}
       asize(headers,len(fields))
       afill(headers,strhead)
    endif
    if valtype(headers)=="A"
       for n = len(headers)+1 to len(fields)
           aadd(headers,fields[n])
       next
    endif
    if valtype(footers)=="C"
       strfoot=footers
       footers:={}
       asize(footers,len(fields))
       afill(footers,strfoot)
    endif
    if valtype(footers)=="A"
       for n = len(footers)+1 to len(fields)
           aadd(footers,"")
       next
    endif
    if valtype(msay)=="C"
      strpict=msay; msay:=array(len(fields)); afill(msay,strpict)
    elseif valtype(msay) != "A"
    	msay:=array(len(fields))
    endif
    if valtype(hSep)=="C"
      strhsep=hSep; hSep:=array(len(fields)); afill(hSep,strhsep)
    endif
    if valtype(cSep)=="C"
      strcsep=cSep; cSep:=array(len(fields)); afill(cSep,strcsep)
    endif
    if valtype(fSep)=="C"
      strfsep=fSep; fSep:=array(len(fields)); afill(fSep,strfsep)
    endif
    asize(msay,len(fields))
    asize(hSep,len(fields))
    asize(cSep,len(fields))
    asize(fSep,len(fields))
    asize(headers,len(fields))
    asize(footers,len(fields))
    FOR n := 1 TO len(fields)
        __cname:="{|| "+fields[n]+"}"
        __cname:=&__cname
        //column := TBColumnNew(Field(n), FieldWBlock(Field(n), Select()))
        column := TBColumnNew(fields[n], __cname)
        column:heading:=headers[n]
        column:footing:=footers[n]
        column:picture:=msay[n]
        column:headSep:=hsep[n]
        column:colSep:=csep[n]
        column:footSep:=fsep[n]
        browse:addColumn(column)
    next
RETURN NIL

