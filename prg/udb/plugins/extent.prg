/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit EXTENT information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_ext_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_ext_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[EXTENT plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_ext_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local m,n,i,s

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([Extent parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	@ x1++,y1 say [Name............]+data:name

	@ x1++,y1 say [Description.....]
	if !empty(data:help)
		m:=split(data:help,"&\n")
		n:=oBox:nBottom-x1
		for i=1 to n //max(n,min(n,len(m)))
			s:=iif(i>len(m),"",m[i])
			s:=padr(s,y2-y1)
			@ x1++,y1 say s color set("ab_colors_dialog")
		next
	endif
	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function ab_ext_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec),scr
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local pic,getlist:={},fname,x

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([Extent parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t edit information]
		dispend()
		return .f.
	endif

	ab_padrBody(data,codb_info("CODB_EXTENT_BODY"))

	if empty(data:id)
		@ x1++,y1 say [Identification..]+[Generation avtomatically ]
	else
		@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	endif
	@ x1++,y1 say [Name............]
	@ x1++,y1 say [Description.....]

	setcolor(set("ab_colors_dialog"))
	x1:=oBox:nTop+4; y1:=oBox:nLeft+17
	pic:="@S"+alltrim(str(y2-y1),3,0)
	@ x1++,y1 get data:name  picture pic
	dispend()
	read
	if lastkey()==27
		ret:=.f.
	else
		fname:=tmpfile()
		x:=memowrit(fname,data:help)
		if x
			save screen to scr
			medit({fname},oBox:ntop,y1-16,oBox:nBottom,y2)
			restore screen from scr
			data:help:=memoread(fname)
		else
			message([Error writing tmp file:]+ferrorstr())
		endif
	endif
	setcolor(oldcol)
return ret

