/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit ATTRIBUTE information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_attr_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_attr_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[ATTR plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_attr_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local atype:=codb_info("CODB_ATTR_TYPES")
	local ltype:=codb_info("CODB_ATTR_LENTYPES")
	local itype:=codb_info("CODB_ATTR_INDEXTYPES")
	local mtype:={},ntype,actype,s,n,lctype,ictype,sss,pic,i,m
	local source:=.f.,fname,scr
	local tmp,odict

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()

	for i=1 to len(atype)
		aadd(mtype,atype[i][2])
	next

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++; y1++

	@ x1++,y1 say padc([Attribute parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
	if empty(data)
		//@ x1++,y1 say [Can`t display information]
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
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

	ntype:=ascan(atype,{|x|x[1]==data:type})
	actype:=iif(ntype==0,[Undefined],atype[ntype][2])
	@ x1++,y1 say [Type............]+actype

	@ x1++,y1 say [Length..........]+str(data:len)

	lctype:=iif(data:lentype<=0 .or. data:lentype>len(ltype),[??????],ltype[data:lentype])
	@ x1++,y1 say [Type  length....]+lctype

	@ x1++,y1 say [Decimals........]+str(data:dec)

	tmp:=oDict:getValue(data:ref_to)
	if !empty(data:ref_to) .and. !empty(tmp)
		@ x1++,y1 say [Reference to....]+alltrim(tmp:name)+"("+data:ref_to+")"
	elseif !empty(data:ref_to)
		@ x1++,y1 say [Reference to....]+[(Unknown name)]+"("+data:ref_to+")"
	else
		@ x1++,y1 say [Reference to....]+[(ANY OBJECT)]
	endif

	@ x1++,y1 say [Picture mask....]+data:mask

	@ x1++,y1 say [Default value...]+data:defvalue
	@ x1++,y1 say [Counter name....]+iif("COUNTER"$data,data:counter,"")

	//@ x1++,y1 say [Unique values...]+iif(data:unique,[Yes],[No ])
	@ x1++,y1 say "NOT_NULL........"+iif(data:not_null,[Yes],[No ])
	@ x1++,y1 say "NOT_EMPTY......."+iif(data:not_Empty,[Yes],[No ])

	source:=!empty(data:source)
	@ x1++,y1 say [Source code.....]+iif(Source,[Yes],[No ])
	if !empty(data:source)
		m:=split(data:source,CRLF)
		n:=oBox:nBottom-x1-1
		for i=1 to n //max(n,min(n,len(m)))
			s:=iif(i>len(m),"",m[i])
			s:=padr(s,y2-y1)
			@ x1++,y1 say s color set("ab_colors_dialog")
		next
	endif
	x1:=oBox:nBottom-2
	@ x1++ ,y1 say replicate("€",y2-y1)
	sss:=[This attribute have ###### references from classes]
	sss:=strtran(sss,"######",str(data:count,6,0))
	@ x1++,y1 say sss
	dispend()
	setcolor(oldcol)
return ret

************************************************************
static function ab_attr_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local atype:=codb_info("CODB_ATTR_TYPES")
	local ltype:=codb_info("CODB_ATTR_LENTYPES")
	local itype:=codb_info("CODB_ATTR_INDEXTYPES")
	local mtype:={},ntype,actype,s,n,lctype,ictype,sss,pic,i,m
	local source:=.f.,fname,scr,getlist:={},x
	local gColor := set("ab_colors_dialog")
	local tmp,odict
	local aSc,nSc:=1,m1
	local aCount,nCount:=1,m2

	//odict := codb_dict_reference()
	oDict:=oDep:dictionary()

	for i=1 to len(atype)
		aadd(mtype,atype[i][2])
	next

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++; y1++

	@ x1++,y1 say padc([Attribute parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)

	if empty(data)
		//@ x1++,y1 say [Can`t edit information]
		@ x1++,y1 say [Can`t edit information]
		dispend()
		return .f.
	endif

	ab_padrBody(data,codb_info("CODB_ATTR_BODY"))


	if empty(data:id)
		@ x1++,y1 say [Identification..]+[Generation avtomatically ]
	else
		@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	endif

	pic:="@S"+alltrim(str(y2-y1-17),3,0)
	@ x1  ,y1 say [Name............]
	@ x1++,y1+16 get data:name  picture pic color (gcolor)

	ntype:=ascan(atype,{|x|x[1]==data:type})
	@ x1  ,y1 say [Type............]
	@ x1++,y1+16, x1+6, y1+51 get ntype listbox mtype dropdown color (gcolor)

	@ x1  ,y1 say [Length..........]
	@ x1++,y1+16 get data:len  color(gcolor) range 1,codb_info("CODB_MAX_LEN_STRING")

	@ x1  ,y1 say [Type  length....]
	@ x1++,y1+16, x1+6, y1+51 get data:lenType listbox ltype dropdown color (gcolor)

	@ x1  ,y1 say [Decimals........]
	@ x1++,y1+16 get data:dec color(gcolor) range codb_info("CODB_MIN_DECIMALS"),codb_info("CODB_MAX_DECIMALS")

	aSC := oDict:select("CLASS")
	m1:={[(ANY OBJECT)]}
	for i=1 to len(aSC)
		tmp := oDict:getValue(aSC[i])
		if valtype(tmp)=="O"
			aadd(m1,alltrim(tmp:name)+"("+alltrim(aSC[i])+")" )
		endif
		if aSC[i] == data:ref_to
			nSc := i+1
		endif
	next
	@ x1  ,y1 say [Reference to....]
	@ x1++,y1+16, x1+10, y1+51 get nSC listbox m1 dropdown color (gcolor)

	@ x1  ,y1 say [Picture mask....]
	@ x1++,y1+16 get data:mask color(gcolor)

	@ x1  ,y1 say [Default value...]
	@ x1++,y1+16 get data:defValue picture pic color (gcolor)

	aCount := oDict:select("COUNTER")
	m2:={[(NONE COUNTER)]}
	for i=1 to len(aCount)
		tmp := oDict:getValue(aCount[i])
		if valtype(tmp)=="O"
			aadd(m2,alltrim(tmp:name)+"("+alltrim(aCount[i])+")" )
		endif
		if "COUNTER" $ data .and. tmp:name == data:counter
			nCount := i+1
		endif
	next
	@ x1  ,y1 say [Counter name....]
	@ x1++,y1+16, x1+10, y1+51 get nCount listbox m2 dropdown color (gcolor)

	/*
	@ x1  ,y1 say [Unique values...]
	@ x1++,y1+16 get data:unique color (gcolor)
	*/

	@ x1  ,y1 say "NOT_NULL........"
	@ x1++,y1+16 get data:not_null color (gcolor)

	@ x1  ,y1 say "NOT_EMPTY......."
	@ x1++,y1+16 get data:not_empty color (gcolor)

	@ x1  ,y1 say [Source code.....]
	@ x1++,y1+16 get source color (gcolor)
	dispend()
	read
	if nSc > 1
		data:ref_to := aSC[nSC-1]
	else
		data:ref_to := ""
	endif
	if nCount > 1
		tmp := oDict:getValue(aCount[nCount-1])
		if !empty(tmp)
			data:counter := tmp:name
		else
			data:counter := ""
		endif
	else
		data:counter := ""
	endif

	data:type:=iif( ntype>0 .and. ntype<=len(mtype), atype[ntype][1], "")

	if lastkey()==27
		ret:=.f.
	else
		if source .or. ntype==len(atype)
			fname:=tmpfile()
			x:=memowrit(fname,data:source)
			if x
				save screen to scr
				medit({fname},oBox:ntop,y1-16,oBox:nBottom,y2)
				restore screen from scr
				data:source:=memoread(fname)
			else
				message([Error writing tmp file:]+ferrorstr())
			endif
		endif
	endif
	setcolor(oldcol)
return ret

