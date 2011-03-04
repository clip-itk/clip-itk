/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit ACC_CHART objects information
*/

#include "box.ch"

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| r2d2_acc_chart_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| r2d2_acc_chart_edit_card(p1,p2,p3,p4,p5)}
		case query_key == "VIEW_TABLE"
			ret:={|p1,p2,p3,p4,p5| r2d2_acc_chart_view_table(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[ACC_CHART plugins not supported function:]+query_key
	end
return ret

************************************************************
static function r2d2_acc_chart_view_table(oBrowse,oDict,class_desc)
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
static function r2d2_acc_chart_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local oClass,oDict,tmp,i,s,an_list:={}

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	odict := oDep:dictionary()

	@ x1++,y1 say padc([Account information],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	if "CLASS_ID" $ data
		oClass := oDict:getValue(data:class_id)
	endif
	if empty(oClass)
		@ x1++,y1 say [This object don`t have CLASS description]
		return .f.
	endif
	@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	@ x1++,y1 say [Code............]+data:code
	@ x1++,y1 say [Name............]+padr(data:smallname,y2-y1-16)
	tmp:=oDep:getValue(data:owner_id)
	@ x1++,y1 say [Owner...........]+iif(empty(tmp),[(NONE)],tmp:code)+":("+data:owner_id+")"
	tmp:=oDep:getValue(data:acc_chart_type)
	@ x1++,y1 say [Chart type......]+iif(empty(tmp),[(NONE)],tmp:code)+":("+data:acc_chart_type+")"
	tmp:=oDep:getValue(data:account_para)
	@ x1++,y1 say [Twice account...]+iif(empty(tmp),[(NONE)],tmp:code)+":("+data:account_para+")"

	@ x1++,y1 say padc([List of analitics],y2-y1,"€") // utf-8: "â”€"
	for i=1 to 99
		s := "AN_VALUE"+alltrim(str(i,2,0))
		if ! (s $ data)
			exit
		endif
		aadd(an_list,data[s])
	next
	for i=1 to len(an_list)
		/*
		tmp:=codb_getValue(an_list[i])
		s:=""
		if !empty(tmp)
			if "NAME" $ tmp
				s+=" "+padr(tmp:name,20)
			elseif "SMALLNAME" $ tmp
				s+=" "+padr(tmp:smallname,20)
			elseif "FULLNAME" $ tmp
				s+=" "+padr(tmp:fullname,20)
			endif
		endif
		s+="("+an_list[i]+")"
		*/
		s := codb_essence(an_list[i])
		@ x1++,y1 say s
	next

	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function r2d2_acc_chart_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local i,x,x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local oClass,oDict,tmp,pic
	local getlist:={}, an_list :={}
	local idOwn,aOwn,nOwn:=1
	local idPara,aPara,nPara:=1
	local acc_type,idType,aType,nType:=1
	local empty_flag := .f.,m,n,s,nkey

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++
	pic:="@S"+alltrim(str(y2-y1-16),3,0)

	odict := oDep:dictionary()
	acc_type := oDict:classBodyByName("acc_chart_type")

	@ x1++,y1 say padc([Account information],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	if "CLASS_ID" $ data
		oClass := oDict:getValue(data:class_id)
	endif
	if empty(oClass)
		@ x1++,y1 say [This object don`t have CLASS description]
		return .f.
	endif

	oDict:padrBody(data,data:class_id)
	if !("ID" $ data) .or. empty(data:id)
		@ x1++,y1 say [Identification..]+[Generation avtomatically ]
	else
		@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	endif
	@ x1  ,y1    say [Code............]
	@ x1++,y1+16 get data:code  picture pic
	@ x1  ,y1    say [Name............]
	@ x1++,y1+16 get data:smallname picture pic

	**********
	idOwn := oDep:select(data:class_id)
	aOwn:={[(NONE)]}
	for i=1 to len(idOwn)
		tmp := oDep:getValue(idOwn[i])
		if valtype(tmp)=="O"
			aadd(aOwn,alltrim(tmp:smallname)+"("+alltrim(idOwn[i])+")" )
		else
			aadd(aOwn,[Error:]+"("+alltrim(idOwn[i])+")" )
		endif
		if idOwn[i] == data:owner_id
			nOwn := i+1
		endif
	next
	@ x1  ,y1 say [Owner...........]
	@ x1++,y1+16, x1+6, y1+50 get nOwn listbox aOwn dropdown
	**********
	idType := oDep:select(acc_type:id)
	aType:={}
	for i=1 to len(idType)
		tmp := oDep:getValue(idType[i])
		if valtype(tmp)=="O"
			aadd(aType,alltrim(tmp:smallname)+"("+alltrim(idType[i])+")" )
		else
			aadd(aType,[Error:]+"("+alltrim(idType[i])+")" )
		endif
		if idType[i] == data:acc_chart_type
			nType := i
		endif
	next
	@ x1  ,y1 say [Chart type......]
	@ x1++,y1+16, x1+6, y1+50 get nType listbox aType dropdown
	**********
	idPara := oDep:select(data:class_id)
	aPara:={[(NONE)]}
	for i=1 to len(idPara)
		tmp := oDep:getValue(idPara[i])
		if valtype(tmp)=="O"
			aadd(aPara,alltrim(tmp:smallname)+"("+alltrim(idPara[i])+")" )
		else
			aadd(aPara,[Error:]+"("+alltrim(idPara[i])+")" )
		endif
		if idPara[i] == data:account_para
			nPara := i+1
		endif
	next
	@ x1  ,y1 say [Twice account...]
	@ x1++,y1+16, x1+6, y1+50 get nPara listbox aPara dropdown
	**********

	dispend()
	read
	if lastkey()==27
		setcolor(oldcol)
		return .f.
	endif
	if nOwn > 1 .and. nOwn <= len(idOwn)
		data:owner_id := idOwn[nOwn-1]
	else
		data:owner_id := ""
	endif
	if nType > 0 .and. nType <= len(idType)
		data:acc_chart_type := idType[nType]
	else
		data:acc_chart_type := ""
	endif
	if nPara > 1 .and. nPara <= len(idPara)
		data:account_para := idPara[nPara-1]
	else
		data:account_para := ""
	endif
	x:=x1
	for i=1 to 99
		s := "AN_VALUE"+alltrim(str(i,2,0))
		if ! (s $ data)
			exit
		endif
		aadd(an_list,data[s])
	next
	while .t.
		x1:=x
		@ x1++,y1 say padc([List of analitics],y2-y1,"€") // utf-8: "â”€"
		setcolor(oldcol)
		@ x1,y1 CLEAR TO oBox:nBottom-2,y2-1
		n:=oBox:nBottom-x1-7
		m:={}
		for i=1 to len(an_list)
			/*
			tmp:=codb_getValue(an_list[i])
			s:=""
			if "NAME" $ tmp
				s+=" "+padr(tmp:name,20)
			elseif "SMALLNAME" $ tmp
				s+=" "+padr(tmp:smallname,20)
			elseif "FULLNAME" $ tmp
				s+=" "+padr(tmp:fullname,20)
			endif
			s+="("+an_list[i]+")"
			*/
			s := codb_essence(an_list[i])
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
			i:=achoice(x1,y1,x1+n-1,y2-1,m,,{|p1,p2,p3|r2d2_acc_chart_edit_achoice(p1,p2,p3)})
			nKey := lastkey()
		endif
		if i==0
			exit
		endif
		if nKey==13
			exit
		endif
		if nKey == 7 .or. nKey == -7
			adel(an_list,i)
			asize(an_list,len(an_list)-1)
			loop
		endif
		if nKey == 22 .or. nKey == -1
			tmp := r2d2_choice_class()
			if empty(tmp)
				loop
			endif
			if nKey==22
				aadd(an_list,"")
				ains(an_list,i)
				an_list[i] := tmp
			else
				aadd(an_list,tmp)
			endif
			loop
		endif

	enddo
	for i=1 to 99
		s := "AN_VALUE"+alltrim(str(i,2,0))
		if ! (s $ data)
			exit
		endif
		if i<=len(an_list)
			data[s] := an_list[i]
		else
			data[s] := ""
		endif
	next
	setcolor(oldcol)
return ret
****************************************
static function r2d2_acc_chart_edit_achoice(mode,cur_str,kurs)
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

