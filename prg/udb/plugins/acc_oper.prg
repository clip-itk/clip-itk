/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit acc_oper objects information
*/

#include "box.ch"

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| r2d2_aoper_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| r2d2_aoper_edit_card(p1,p2,p3,p4,p5)}
		case query_key == "VIEW_TABLE"
			ret:={|p1,p2,p3,p4,p5| r2d2_aoper_view_table(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[ACC_OPER plugins not supported function:]+query_key
	end
return ret

************************************************************
static function r2d2_aoper_view_table(oBrowse,oDict,class_desc)
	local tmp,data
	tmp := oDict:select("TVIEW",,,'class_id=="'+class_desc:id+'"')
	if empty(tmp)
		return .f.
	endif
	data := oDict:getValue(tmp[1])
	oBrowse : header := data:name
	if empty(data:col_list)
		return .f.
	endif
return  r2d2_fill_tcolumns(oBrowse,oDict,data:col_list)
************************************************************
static function r2d2_aoper_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local oClass,oDict,tmp,i,s

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([Account operation],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif

	@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	@ x1++,y1 say [Code............]+data:code
	@ x1++,y1 say [Small name......]+padr(data:smallname,y2-y1-16)
	@ x1++,y1 say [User name.......]+padr(data:username,y2-y1-16)
	@ x1++,y1 say [Data class......]+padr(data:class,y2-y1-16)

	@ x1++,y1 say padc([List of posting],y2-y1,"€")
	@ x1++,y1 say padr([Debet..............Kredit],y2-y1,".")
	for i=1 to len(data:accpost_list)
		s:=""
		tmp:=codb_getValue(data:accpost_list[i]:debet)
		if !empty(tmp)
			s+=tmp:code+":"+tmp:smallname
		else
			s+="("+data:accpost_list[i]:debet+")"
		endif
		s:=padr(s,20)+"  "
		tmp:=codb_getValue(data:accpost_list[i]:kredit)
		if !empty(tmp)
			s+=tmp:code+":"+tmp:smallname
		else
			s+="("+data:accpost_list[i]:kredit+")"
		endif
		s := padr(s,y2-y1)
		@ x1++,y1 say s
	next

	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function r2d2_aoper_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x,x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local oClass,oDict,tmp,pic
	local getlist:={}
	local empty_flag := .f.,i,m,n,nkey
	local s,s1,s2,o
	local fname,scr

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++
	pic:="@S"+alltrim(str(y2-y1-16),3,0)

	@ x1++,y1 say padc([Account operation],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif

	//r2d2_padrBody(data,data:class_id)
	codb_padrBody(data,data:class_id)

	if !("ID" $ data) .or. empty(data:id)
		@ x1++,y1 say [Identification..]+[Generation avtomatically ]
	else
		@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	endif
	@ x1  ,y1 say [Code............]
	@ x1++,y1+16 get data:code //  picture pic
	@ x1  ,y1 say [Small name......]
	@ x1++,y1+16 get data:smallname picture pic
	@ x1  ,y1 say [User name.......]
	@ x1++,y1+16 get data:username picture pic
	@ x1  ,y1 say [Data class......]+padr(data:class,y2-y1-16)
	@ x1++,y1+16 get data:class picture pic
	@ x1++,y1 say padc([List of posting],y2-y1,"€")
	@ x1++,y1 say padr([Debet..............Kredit],y2-y1,".")
	dispend()
	read
	if lastkey()==27
		setcolor(oldcol)
		return .f.
	endif
	while .t.
		setcolor(oldcol)
		x1:=oBox:nTop+10; y1:=oBox:nLeft+1
		n:=oBox:nBottom-x1-1
		@ x1,y1 CLEAR TO x1+n,y2-1
		m:={}
		for i=1 to len(data:accpost_list)
			s:=""
			tmp:=codb_getValue(data:accpost_list[i]:debet)
			if !empty(tmp)
				s+=tmp:code+":"+tmp:smallname
			else
				s+="("+data:accpost_list[i]:debet+")"
			endif
			s:=padr(s,20)+"  "
			tmp:=codb_getValue(data:accpost_list[i]:kredit)
			if !empty(tmp)
				s+=tmp:code+":"+tmp:smallname
			else
				s+="("+data:accpost_list[i]:kredit+")"
			endif
			s := padr(s,y2-y1)
			aadd(m,s)
		next
		setcolor( set("acc_colors_dialog") )
		if empty(m)
			if empty_flag
				exit
			endif
			i:=1
			nkey:=22
			empty_flag := .t.
		else
			i:=0
			i:=achoice(x1,y1,x1+n,y2-1,m,,{|p1,p2,p3|post_edit_achoice(p1,p2,p3)})
			nKey := lastkey()
		endif
		if i==0
			exit
		endif
		if nKey==13
			exit
		endif
		if nKey == 7 .or. nKey == -7
			adel(data:accpost_list,i)
			asize(data:accpost_list,len(data:accpost_list)-1)
			loop
		endif
		if nKey == 22 .or. nKey == -1
			s1:=s2:=""
			s1 := r2d2_choice_object("acc_chart",[Choice debet account])
			if !empty(s1)
				s2 := r2d2_choice_object("acc_chart",[Choice kredit account])
			endif
			if empty(s1) .or. empty(s2)
				loop
			endif
			o:=map()
			o:debet  := s1
			o:kredit := s2
			if nKey==22
				aadd(data:accpost_list,"")
				ains(data:accpost_list,i)
				data:accpost_list[i] := o
			else
				aadd(data:accpost_list,o)
			endif
			loop
		endif
	enddo
	fname:=tmpfile()
	x:=memowrit(fname,data:rules)
	if x
		save screen to scr
		medit({fname},oBox:ntop,y1-16,oBox:nBottom,y2)
		restore screen from scr
		data:rules:=memoread(fname)
		ferase(fname)
	else
		message([Error writing tmp file:]+ferrorstr())
	endif
	if ret .and. alert([Save changed data ?],{[Yes],[No]})==1
		ret := .t.
	else
		ret := .f.
	endif
	setcolor(oldcol)
	if lastkey()==27
		return .f.
	endif
return ret
****************************************
static function post_edit_achoice(mode,cur_str,kurs)
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

