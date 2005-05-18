/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit PLUGINS information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_plugins_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_plugins_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[PLUGINS plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_plugins_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local n,i,s,odict,tmp
	local mtype:={}, atype:=codb_info("CODB_PLUGINS_TYPES")
	local nType,actype

	for i=1 to len(atype)
		aadd(mtype,atype[i][2])
	next

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

//	odict := codb_dict_reference()
	oDict:=oDep:dictionary()

	@ x1++,y1 say padc([PLUGINS parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	//outlog(__FILE__,__LINE__,data)
	s:=data:id
	if "__VERSION" $ data
		s+=[ version:]+str(data:__version)
	endif
	if "__CRC32" $ data
		s+=[ CRC:]+data:__crc32
	endif
	@ x1++,y1 say [Identification..]+padr(s,y2-y1-16)
	@ x1++,y1 say [Name............]+data:name

	ntype:=ascan(atype,{|x|x[1]==data:type})
	actype:=iif(ntype==0,[Undefined],atype[ntype][2])
	@ x1++,y1 say [Type............]+actype
	@ x1++,y1 say [File name.......]+data:filename
	@ x1++,y1 say [Main function...]+data:mainfunc

	tmp:=oDict:getValue(data:class_id)
	if !empty(tmp)
		@ x1++,y1 say [Class...........]+alltrim(tmp:name)+"("+data:class_id+")"
	else
		@ x1++,y1 say [Class...........]+[(NONE)]+"("+data:class_id+")"
	endif
	@ x1++,y1 say padr("",y2-y1,"-")
	s := ""
	if "SOURCE" $ data
		s := data:source
	endif
	tmp:=split(s,"&\n")
	i:=1
	for x1=x1 to oBox:nBottom-1
		s:=""
		if i<=len(tmp)
			s := tmp[i]
		endif
		@ x1++,y1 say padr(s,y2-y1," ")
		i++
	next
	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function ab_plugins_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec),scr
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local pic,getlist:={},x,empty_flag:=.f.
	local mCl,nCl:=1,aCl
	local n,i,s,odict,tmp,nkey
	local atype:=codb_info("CODB_PLUGINS_TYPES")
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

	@ x1++,y1 say padc([PLUGINS parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)

	ab_padrBody(data,codb_info("CODB_PLUGINS_BODY"))

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
	@ x1  ,y1 say [Main function...]
	@ x1++,y1+16 get data:mainfunc  picture (pic) color set("ab_colors_dialog")
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
	dispend()
	read
	if lastkey()==27
		ret:=.f.
	else
		data:type:=iif( ntype>0 .and. ntype<=len(mtype), atype[ntype][1], "")

		if nCl > 1
			data:class_id := aCl[nCl-1]
		else
			data:class_id := ""
		endif
	endif
	setcolor(oldcol)
return ret
