/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit TVIEW information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_tview_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_tview_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[TVIEW plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_tview_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local n,i,s,odict,tmp

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()

	@ x1++,y1 say padc([TVIEW parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	@ x1++,y1 say [Name............]+data:name
	@ x1++,y1 say [Header..........]+data:header
	@ x1++,y1 say [Footer..........]+data:footer

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

	@ x1++,y1 say padr([Columns.......Name.............Header...........],y2-y1,".")
	n:=oBox:nBottom-x1
	for i=1 to n //max(n,min(n,len(m)))
		if i>len(data:col_list)
			loop
		endif
		s:=data:col_list[i]
		tmp:=oDict:getValue(s)
		if empty(tmp)
			s+=":"+[Error access to identification:]+s
		else
			s+=" "+padr(tmp:name,20)
			s+=" "+padr(tmp:header,20)
		endif
		@ x1++,y1 say padr(s,y2-y1)

	next
	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function ab_tview_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec),scr
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local pic,getlist:={},x,m,empty_flag:=.f.
	local mEx,nEx:=1,aEx
	local mCl,nCl:=1,aCl
	local mGr,nGr:=1,aGr
	local mUs,nUs:=1,aUs
	local n,i,s,odict,tmp,nkey

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()
	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([TVIEW parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)

	ab_padrBody(data,codb_info("CODB_TVIEW_BODY"))

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
	pic:="@S"+alltrim(str(y2-y1-17),3,0)
	@ x1  ,y1 say [Name............]
	@ x1++,y1+16 get data:name  picture pic color set("ab_colors_dialog")
	@ x1  ,y1 say [Header..........]
	@ x1++,y1+16 get data:header  picture pic color set("ab_colors_dialog")
	@ x1  ,y1 say [Footer..........]
	@ x1++,y1+16 get data:footer  picture pic color set("ab_colors_dialog")
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

	@ x1++,y1 say padr([Columns.......Name.............Header...........],y2-y1,".")

	dispend()
	read
	if lastkey()==27
		ret:=.f.
	else
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
		while .t.
			setcolor(oldcol)
			x1:=oBox:nTop+12; y1:=oBox:nLeft+1
			@ x1,y1 CLEAR TO oBox:nBottom-1,y2-1
			n:=oBox:nBottom-x1
			m:={}
			for i=1 to len(data:col_list)
				tmp:=oDict:getValue(data:col_list[i])
				s:=data:col_list[i]
				if !empty(tmp)
					s+=" "+padr(tmp:name,20)
					s+=" "+padr(tmp:header,20)
				else
					s+=[Error access]
				endif
				aadd(m,s)
			next
			setcolor( set("ab_colors_dialog") )
			if empty(m)
				if empty_flag
					exit
				endif
				i:=1
				nkey:=22
				empty_flag := .t.
			else
				i:=achoice(x1,y1,x1+n-1,y2-1,m,,{|p1,p2,p3|ab_tview_edit_cols(p1,p2,p3)})
				nKey := lastkey()
			endif
			if i==0
				exit
			endif
			if nKey==13
				exit
			endif
			if nKey == 7 .or. nKey == -7
				adel(data:col_list,i)
				asize(data:col_list,len(data:col_list)-1)
				loop
			endif
			if nKey == 22 .or. nKey == -1
				tmp := ab_choice_tcolumn(oDict)
				if empty(tmp)
					loop
				endif
				if nKey==22
					aadd(data:col_list,"")
					ains(data:col_list,i)
					data:col_list[i] := tmp
				else
					aadd(data:col_list,tmp)
				endif
				loop
			endif

		enddo
	endif
	if ret .and. alert([Save changed data ?],{[Yes],[No]})==1
		ret := .t.
	else
		ret := .f.
	endif
	setcolor(oldcol)
return ret

****************************************
static function ab_tview_edit_cols(mode,cur_str,kurs)
do case
   case lastkey()==13
	return 1
   case lastkey()==-7   // K_F8
	return 1
   case lastkey()==7   // K_DEL
	return 1
   case lastkey()==22   // K_INS
	return 1
   case lastkey()==-1   // K_F2
	return 1
   case lastkey()==27
	return 0
endcase
return 2


