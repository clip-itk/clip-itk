/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit CLASS information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_class_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_class_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[CLASS plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_class_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local n,i,s,odict,tmp

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()

	@ x1++,y1 say padc([CLASS parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	if "UNIQUE_KEY" $ data
	else
		data:unique_key := ""
	endif
	s := data:id
	if "__VERSION" $ data
		s+=[ version:]+str(data:__version)
	endif
	if "__CRC32" $ data
		s+=[ CRC:]+data:__crc32
	endif
	@ x1++,y1 say [Identification..]+padr(s,y2-y1-16)
	@ x1++,y1 say [Name............]+data:name

	tmp:=oDict:getValue(data:extent_id)
	if !empty(tmp)
		@ x1++,y1 say [Extent..........]+alltrim(tmp:name)+"("+data:extent_id+")"
	else
		@ x1++,y1 say [Extent..........]+[(NONE)]
	endif

	tmp:=oDict:getValue(data:super_id)
	if !empty(tmp)
		@ x1++,y1 say [Super class.....]+alltrim(tmp:name)+"("+data:super_id+")"
	else
		@ x1++,y1 say [Super class.....]+[(NONE)]
	endif

	@ x1++,y1 say [Essence.........]+padr(data:expr_essence,y2-y1-16)
	@ x1++,y1 say [Unique key......]+padr(data:unique_key,y2-y1-16)

	if !("HAVE_COUNTERS" $ data)
		data:have_counters := .f.
	endif
	s:=[Logging need....]
	if !("LOG_NEED" $ data)
		data:log_need:=.f.
	endif
	s+=padr(iif(data:log_need,[Yes],[No]),3)
	s+=" "+[Status:]+iif(data:unstable,[Unstable],[Stable])+;
		" "+[Have counters:]+iif(data:have_counters,[Yes],[No])
	s:=padr(s,y2-y1)
	@ x1++,y1 say s

	@ x1++,y1 say padr(str(len(data:attr_list),2,0)+" "+[Attributes.Name.............Type..Len...Dec..],y2-y1,".")
	n:=oBox:nBottom-x1-6
	for i=1 to n //max(n,min(n,len(m)))
		if i>len(data:attr_list)
			x1++
			loop
		endif
		s:=data:attr_list[i]
		tmp:=oDict:getValue(s)
		if empty(tmp)
			s+=":"+[Error access to identification:]+s
		else
			s+=" "+padr(tmp:name,20)
			s+=" "+tmp:type
			s+=" "+str(tmp:len,5,0)
			s+=" "+str(tmp:dec,2,0)
		endif
		@ x1++,y1 say padr(s,y2-y1)
	next
	@ x1++,y1 say padr(str(len(data:idx_list),2,0)+" "+[Indexes....Name.............Expression.......],y2-y1,".")
	n:=oBox:nBottom-x1
	for i=1 to n //max(n,min(n,len(m)))
		if i>len(data:idx_list)
			x1++
			loop
		endif
		s:=data:idx_list[i]
		tmp:=oDict:getValue(s)
		if empty(tmp)
			s+=":"+[Error access to identification:]+s
		else
			s+=" "+padr(tmp:name,20)
			s+=" "+tmp:expr
		endif
		@ x1++,y1 say padr(s,y2-y1)
	next
	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function ab_class_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec),scr
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local pic,getlist:={},x,m, empty_flag:=.f.
	local m1,nSC:=1,aSC
	local m2,nEx:=1,aEx
	local n,i,s,odict,tmp,nkey

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()
	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([CLASS parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1) // utf-8: "â”€"
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif

	ab_padrBody(data,codb_info("CODB_CLASS_BODY"))

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
	@ x1++,y1 say [Name............]
	@ x1++,y1 say [Extent..........]
	@ x1++,y1 say [Super class.....]
	@ x1++,y1 say [Essence.........]
	@ x1++,y1 say [Unique key......]
	if !("HAVE_COUNTERS" $ data)
		data:have_counters := .f.
	endif
	s:=[Logging need....]
	if !("LOG_NEED" $ data)
		data:log_need:=.f.
	endif
	s+=padr(iif(data:log_need,[Yes],[No]),3)
	s+=" "+[Status:]+iif(data:unstable,[Unstable],[Stable])+;
		" "+[Have counters:]+iif(data:have_counters,[Yes],[No])
	s:=padr(s,y2-y1)
	@ x1++,y1 say s
	/*
	@ x1++,y1 say [Status..........]+padr(iif(data:unstable,[Unstable],[Stable]),12)+;
		[Have counters...]+iif(data:have_counters,[Yes],[No])
	*/
	@ x1++,y1 say padr([Attributes....Name.............Type..Len...Dec..],y2-y1,".")
	x1:=oBox:nBottom-6
	@ x1++,y1 say padr([Indexes.......Name.............Expression.......],y2-y1,".")

	setcolor(set("ab_colors_dialog"))
	x1:=oBox:nTop+4; y1:=oBox:nLeft+17
	pic:="@S"+alltrim(str(y2-y1),3,0)
	@ x1++,y1 get data:name  picture pic

	aEx := oDict:select("EXTENT")
	m2:={}
	for i=1 to len(aEx)
		tmp := oDict:getValue(aEx[i])
		if valtype(tmp)=="O"
			aadd(m2,alltrim(tmp:name)+"("+alltrim(aEx[i])+")" )
		endif
		if aEx[i] == data:extent_id
			nEx := i
		endif
	next
	@ x1++,y1, x1+6, y1+25 get nEx listbox m2 dropdown

	aSC := oDict:select("CLASS")
	m1:={[(NONE)]}
	for i=1 to len(aSC)
		tmp := oDict:getValue(aSC[i])
		if valtype(tmp)=="O"
			aadd(m1,alltrim(tmp:name)+"("+alltrim(aSC[i])+")" )
		endif
		if aSC[i] == data:super_id
			nSc := i+1
		endif
	next
	@ x1++,y1, x1+6, y1+25 get nSC listbox m1 dropdown
	@ x1++,y1 get data:expr_essence  picture pic
	@ x1++,y1 get data:unique_key    picture pic
	@ x1  ,y1 get data:log_need      picture "Y"
	//@ x1++,y1+15 get data:unstable    picture "Y"
	dispend()
	read
	if lastkey()==27
		ret:=.f.
	else
		if nSc > 1
			data:super_id := aSC[nSC-1]
		else
			data:super_id := ""
		endif
		data:extent_id := aEx[nEx]
		while .t.
			setcolor(oldcol)
			x1:=oBox:nTop+11; y1:=oBox:nLeft+1
			@ x1,y1 CLEAR TO oBox:nBottom-7,y2-1
			n:=oBox:nBottom-x1-6
			m:={}
			for i=1 to len(data:attr_list)
				tmp:=oDict:getValue(data:attr_list[i])
				s:=data:attr_list[i]
				if !empty(tmp)
					s+=" "+padr(tmp:name,20)
					s+=" "+tmp:type
					s+=" "+str(tmp:len,5,0)
					s+=" "+str(tmp:dec,2,0)
				else
					s+=[Error loading attribute metadata]
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
				i:=0
				i:=achoice(x1,y1,x1+n-1,y2-1,m,,{|p1,p2,p3|ab_class_edit_achoice(p1,p2,p3)})
				nKey := lastkey()
			endif
			if i==0
				exit
			endif
			if nKey==13
				exit
			endif
			if nKey == 7 .or. nKey == -7
				adel(data:attr_list,i)
				asize(data:attr_list,len(data:attr_list)-1)
				loop
			endif
			if nKey == 22 .or. nKey == -1
				tmp := ab_choice_attr(oDict)
				if empty(tmp)
					loop
				endif
				if nKey==22
					aadd(data:attr_list,"")
					ains(data:attr_list,i)
					data:attr_list[i] := tmp
				else
					aadd(data:attr_list,tmp)
				endif
				loop
			endif

		enddo
		while .t.
			setcolor(oldcol)
			x1:=oBox:nBottom-5; y1:=oBox:nLeft+1
			@ x1,y1 CLEAR TO oBox:nBottom-1,y2-1
			n:=oBox:nBottom-x1
			m:={}
			for i=1 to len(data:idx_list)
				tmp:=oDict:getValue(data:idx_list[i])
				s:=data:idx_list[i]
				s+=" "+padr(tmp:name,20)
				s+=" "+tmp:expr
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
				i:=achoice(x1,y1,x1+n-1,y2-1,m,,{|p1,p2,p3|ab_class_edit_achoice(p1,p2,p3)})
				nKey := lastkey()
			endif
			if i==0
				exit
			endif
			if nKey==13
				exit
			endif
			if nKey == 7 .or. nKey == -7
				adel(data:idx_list,i)
				asize(data:idx_list,len(data:idx_list)-1)
				loop
			endif
			if nKey == 22 .or. nKey == -1
				tmp := ab_choice_index(oDict)
				if empty(tmp)
					loop
				endif
				if nKey==22
					aadd(data:idx_list,"")
					ains(data:idx_list,i)
					data:idx_list[i] := tmp
				else
					aadd(data:idx_list,tmp)
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
static function ab_class_edit_achoice(mode,cur_str,kurs)
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


