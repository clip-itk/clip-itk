/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit TCOLUMN information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_tcol_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_tcol_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[TCOLUMN plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_tcol_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local i

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++; y1++

	@ x1++,y1 say padc([TColumn parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	@ x1++,y1 say [Name............]+data:name
	@ x1++,y1 say [Width...........]+str(data:width)
	@ x1++,y1 say [Header..........]+padr(data:header,y2-y1-16)
	@ x1++,y1 say [Footer..........]+padr(data:footer,y2-y1-16)
	@ x1++,y1 say [Expression......]+padr(data:expr,y2-y1-16)
	@ x1++,y1 say [Depend of.......]+padr(data:depend_of,y2-y1-16)
	@ x1++,y1 say padc([References to],y2-y1,".")
	for i=1 to len(data:refs)
	@ x1++,y1 say padr(data:refs[i],y2-y1)
	next
	dispend()
	setcolor(oldcol)
return ret

************************************************************
static function ab_tcol_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local gColor := set("ab_colors_dialog")
	local getlist:={},pic

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++; y1++

	@ x1++,y1 say padc([TColumn parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
	if empty(data)
		@ x1++,y1 say [Can`t edit information]
		dispend()
		return .f.
	endif

	ab_padrBody(data,codb_info("CODB_TCOLUMN_BODY"))

	if empty(data:id)
		@ x1++,y1 say [Identification..]+[Generation avtomatically ]
	else
		@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	endif

	pic:="@S"+alltrim(str(y2-y1-17),3,0)
	@ x1  ,y1 say [Name............]
	@ x1++,y1+16 get data:name  picture pic color (gcolor)

	@ x1  ,y1 say [Width...........]
	@ x1++,y1+16 get data:width

	@ x1  ,y1 say [Header..........]
	@ x1++,y1+16 get data:header picture pic color (gcolor)

	@ x1  ,y1 say [Footer..........]
	@ x1++,y1+16 get data:footer picture pic color (gcolor)

	@ x1  ,y1 say [Expression......]
	@ x1++,y1+16 get data:expr  picture pic color (gcolor)
	dispend()
	read
	adel(data,"EXPR_BLOCK")
	if lastkey()==27
		ret:=.f.
	endif

	setcolor(oldcol)
return ret

