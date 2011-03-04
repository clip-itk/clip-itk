/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit REPORT information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_report_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_report_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[REPORT plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_report_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local n,i,s,odict,tmp
	local mtype:={}, atype:=codb_info("CODB_REPORT_TYPES")
	local nType,actype

	for i=1 to len(atype)
		aadd(mtype,atype[i][2])
	next

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()

	@ x1++,y1 say padc([REPORT parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	@ x1++,y1 say [Name............]+data:name

	ntype:=ascan(atype,{|x|x[1]==data:type})
	actype:=iif(ntype==0,[Undefined],atype[ntype][2])
	@ x1++,y1 say [Type............]+actype
	@ x1++,y1 say [File name.......]+data:filename

	tmp:=oDict:getValue(data:extent_id)
	if !empty(tmp)
		@ x1++,y1 say [Extent..........]+alltrim(tmp:name)+"("+data:extent_id+")"
	else
		@ x1++,y1 say [Extent..........]+[(NONE)]
	endif

	tmp:=oDict:getValue(data:class_id)
	if !empty(tmp)
		@ x1++,y1 say [Class...........]+alltrim(tmp:name)+"("+data:class_id+")"
	else
		@ x1++,y1 say [Class...........]+[(NONE)]
	endif

	tmp:=oDict:getValue(data:group_id)
	if !empty(tmp)
		@ x1++,y1 say [Group...........]+alltrim(tmp:name)+"("+data:group_id+")"
	else
		@ x1++,y1 say [Group...........]+[(NONE)]
	endif

	tmp:=oDict:getValue(data:User_id)
	if !empty(tmp)
		@ x1++,y1 say [User............]+alltrim(tmp:name)+"("+data:user_id+")"
	else
		@ x1++,y1 say [User............]+[(NONE)]
	endif

	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function ab_report_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec),scr
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local pic,getlist:={},x,empty_flag:=.f.
	local mEx,nEx:=1,aEx
	local mCl,nCl:=1,aCl
	local mGr,nGr:=1,aGr
	local mUs,nUs:=1,aUs
	local n,i,s,odict,tmp,nkey
	local atype:=codb_info("CODB_REPORT_TYPES")
	local mtype:={},ntype

	for i=1 to len(atype)
		aadd(mtype,atype[i][2])
	next

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()
	pic:="@S"+alltrim(str(y2-y1-17),3,0)

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([REPORT parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"

	ab_padrBody(data,codb_info("CODB_REPORT_BODY"))

	if empty(data)
		@ x1++,y1 say [Can`t edit information]
		dispend()
		return .f.
	endif
	if empty(data:id)
		@ x1++,y1 say [Identification..]+[Generation avtomatically ]
	else
		@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	endif
	@ x1  ,y1 say [Name............]
	@ x1++,y1+16 get data:name  picture (pic) color set("ab_colors_dialog")
*****
	ntype:=ascan(atype,{|x|x[1]==data:type})
	@ x1  ,y1 say [Type............]
	@ x1++,y1+16, x1+6, y1+51 get ntype listbox mtype dropdown color set("ab_colors_dialog")
*****

	@ x1  ,y1 say [File name.......]
	@ x1++,y1+16 get data:filename  picture (pic) color set("ab_colors_dialog")
*****
	aEx := oDict:select("EXTENT")
	mEx:={[(NONE)]}
	for i=1 to len(aEx)
		tmp := oDict:getValue(aEx[i])
		if valtype(tmp)=="O"
			aadd(mEx,alltrim(tmp:name)+"("+alltrim(aEx[i])+")" )
		endif
		if aEx[i] == data:extent_id
			nEx := i+1
		endif
	next
	@ x1  ,y1 say [Extent..........]
	@ x1++,y1+16, x1+6, y1+51 get nEx listbox mEx dropdown color set("ab_colors_dialog")
*****
	aCl := oDict:select("CLASS")
	mCl:={[(NONE)]}
	for i=1 to len(aCl)
		tmp := oDict:getValue(aCl[i])
		if valtype(tmp)=="O"
			aadd(mCl,alltrim(tmp:name)+"("+alltrim(aCl[i])+")" )
		endif
		if aCl[i] == data:class_id
			nCl := i+1
		endif
	next
	@ x1  ,y1 say [Class...........]
	@ x1++,y1+16, x1+6, y1+51 get nCl listbox mCl dropdown color set("ab_colors_dialog")
*****
	aGr := oDict:select("GROUP")
	mGr:={[(NONE)]}
	for i=1 to len(aGr)
		tmp := oDict:getValue(aGr[i])
		if valtype(tmp)=="O"
			aadd(mGr,alltrim(tmp:name)+"("+alltrim(aGr[i])+")" )
		endif
		if aGr[i] == data:group_id
			nGr := i+1
		endif
	next
	@ x1  ,y1 say [Group...........]
	@ x1++,y1+16, x1+6, y1+51 get nGr listbox mGr dropdown color set("ab_colors_dialog")
*****
	aUs := oDict:select("USER")
	mUs:={[(NONE)]}
	for i=1 to len(aUs)
		tmp := oDict:getValue(aUs[i])
		if valtype(tmp)=="O"
			aadd(mUs,alltrim(tmp:name)+"("+alltrim(aUs[i])+")" )
		endif
		if aUs[i] == data:user_id
			nUs := i+1
		endif
	next
	@ x1  ,y1 say [User............]
	@ x1++,y1+16, x1+6, y1+51 get nUs listbox mUs dropdown color set("ab_colors_dialog")

	dispend()
	read
	if lastkey()==27
		ret:=.f.
	else
		data:type:=iif( ntype>0 .and. ntype<=len(mtype), atype[ntype][1], "")

		if nEx > 1
			data:extent_id := aEx[nEx-1]
		else
			data:extent_id := ""
		endif
		if nCl > 1
			data:class_id := aCl[nCl-1]
		else
			data:class_id := ""
		endif
		if nGr > 1
			data:group_id := aGr[nGr-1]
		else
			data:group_id := ""
		endif
		if nUs > 1
			data:user_id := aUs[nUs-1]
		else
			data:user_id := ""
		endif
	endif
	setcolor(oldcol)
return ret
