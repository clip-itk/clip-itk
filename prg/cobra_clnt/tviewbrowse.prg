/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "box.ch"
#include "Inkey.ch"

#define MY_HEADSEP      translate_charset(__CHARSET__,host_charset(),"†∂†")
#define MY_COLSEP       translate_charset(__CHARSET__,host_charset()," Å ")
#define MY_FOOTSEP      translate_charset(__CHARSET__,host_charset(),"†π†")

memvar __a2_data, curr_record,__userfunc


function tViewBrowse

    LOCAL browse                       // The TBrowse object
    LOCAL nKey,b                        // Keystroke
    private __userfunc, curr_record:=1

    parameters  top, left, down, right, __a2_data,__columns

    if len(__a2_data)==0 .or. len(__a2_data[1])==0
       //alert([Error A2EDIT; What~s Edit ?])
       //return
    endif
    top  := iif( top  == NIL, 0, top )
    left := iif( left == NIL, 0, left )
    down  := iif( down  == NIL, maxrow(), down )
    right:= iif( right== NIL, maxcol() , right )
    top=max(top,0)
    left=max(left,0)
    down=min(down,maxrow())
    right=min(right,maxcol())

    browse := TBrowseDB(Top, Left, Down, Right)
    browse:chop := .t.
    StockBrowseNew(browse, __columns )
    browse:skipBlock := { |x| Skipper(x, browse) }
    browse:headSep := MY_HEADSEP
    browse:footSep := MY_FOOTSEP
    browse:colSep := MY_COLSEP
    browse:stabilize()
    DO WHILE .t.

	browse:forcestable()
	nKey := InKey(0)
	if nKey == K_ESC
		exit
	endif
	b := browse:setkey(nKey)
	if b != NIL
		eval(b,browse,nkey)
	endif
    ENDDO

return  NIL

function get_a2_data(field, new_data)
       local ret:=NIL
       if curr_record<=0 .or. field<=0
		return ret
       endif
       if curr_record<=len(__a2_data) .and. len(__a2_data[curr_record]) >= field
	  ret=__a2_data[curr_record][field]
	  if new_data!=NIL
	     __a2_data[curr_record][field]:=new_data
	  endif
       endif
return ret

STATIC FUNCTION Skipper(n, browse)
    LOCAL i
    curr_record:=max(1,curr_record)
    curr_record:=min(len(__a2_data),curr_record)
    i=curr_record
    curr_record+=n
    curr_record:=max(1,curr_record)
    curr_record:=min(len(__a2_data),curr_record)
RETURN curr_record-i

STATIC FUNCTION StockBrowseNew( browse, __columns )
    LOCAL n, column, cType, strhead, strfoot
    local __cname
    FOR n := 1 TO len(__columns)
	__cname:='{|_1| get_a2_data('+str(n)+',_1)}'
	__cname:=&__cname
	if valtype(__columns[n])=="O"
		column := TBColumnNew(__columns[n]:header, __cname)
		column:heading:=__columns[n]:header
		column:footing:=__columns[n]:expr
		column:width  :=__columns[n]:width
		browse:addColumn(column)
	endif
    next
RETURN NIL

