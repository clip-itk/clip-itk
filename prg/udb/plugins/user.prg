/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit USER information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_user_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_user_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[USER plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_user_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local i,tmp,odict,nGroup:=1,aGroups:={},mGroups:={},gName:=""

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([User parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	@ x1++,y1 say [Name............]+data:name


	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()
	tmp := oDict:getValue(data:group_id)
	gName := "("+alltrim(data:group_id)+")"
	if valtype(tmp) == "O"
		gname := alltrim(tmp:name)+gName
	endif
	@ x1++,y1 say [Group...........]+gName //data:group_id

	@ x1++,y1 say [Access rules....]+data:access

	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function ab_user_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec),scr
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local i,tmp,odict,nGroup:=1,aGroups:={},mGroups:={}
	local pic,getlist:={}

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([User parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t edit information]
		dispend()
		return .f.
	endif

	ab_padrBody(data,codb_info("CODB_USER_BODY"))

	if empty(data:id)
		@ x1++,y1 say [Identification..]+[Generation avtomatically ]
	else
		@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	endif
	@ x1++,y1 say [Name............]
	@ x1++,y1 say [Group...........]
	@ x1++,y1 say [Access rules....]
	dispend()

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()
	aGroups := oDict:select("GROUP")
	for i=1 to len(aGroups)
		tmp := oDict:getValue(aGroups[i])
		if valtype(tmp)=="O"
			aadd(mGroups,alltrim(tmp:name)+"("+alltrim(aGroups[i])+")" )
		endif
		if aGroups[i] == data:group_id
			nGroup := i
		endif
	next

	dispbegin()
	setcolor(set("ab_colors_dialog"))
	x1:=oBox:nTop+4; y1:=oBox:nLeft+17
	pic:="@S"+alltrim(str(y2-y1),3,0)
	@ x1++,y1 get data:name     picture pic
	//@ x1++,y1 get data:group_id picture pic  valid !empty(data:group_id)
	@ x1++,y1, x1+6, y1+25 get nGroup listbox mGroups dropdown
	@ x1++,y1 get data:access   picture pic
	dispend()
	read
	data:group_id := aGroups[nGroup]
	setcolor(oldcol)
return ret

