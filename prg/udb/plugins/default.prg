/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit DEFAULT and UNDEF objects information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_def_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			//ret:={|p1,p2,p3,p4,p5| ab_def_view_card(p1,p2,p3,p4,p5)}
			ret:={|p1,p2,p3,p4,p5| ab_def_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[DEFAULT plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_def_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local n,i,s,odict,tmp,mkeys
	local oClass,oAttr,sKey,sData,cDesc

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	//odict := codb_dict_reference()
	//oDep  := codb_dep_reference()
	odict := oDep:dictionary()
	//outlog(data)

	@ x1++,y1 say padc([OBJECT parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
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
		mkeys:=mapKeys(data)
		for i=1 to len(mKeys)
			@ x1++,y1 say padr(oDict:hashname(mKeys[i]),16,".")+padr(data[mKeys[i]],y2-y1-16)
		next
	else
		@ x1++,y1 say [This object of CLASS:]+oClass:name
		if "__VERSION" $ data
			@ x1++,y1 say [Version:]+str(data:__version)+" "+iif("__CRC32" $ data,"CRC:"+data:__crc32,"")
		endif
		for i=1 to len(oClass:attr_list)
			tmp:=oDict:getValue(oClass:attr_list[i])
			sKey:=alltrim(upper(tmp:name))
			if sKey $ data
				sdata := data[sKey]
				sData := varToString(sData,,,.f.)
			else
				sdata := [(Error ! Attribute abscent in data object)]
			endif
			if tmp:type == "R"
				cDesc := ""
				s:=oDep:getValue(data[sKey])
				if !empty(s)
					cDesc := codb_getValue(s:class_id)
				endif
				if !empty(cDesc)
					sData := cDesc:essence(s)
				else
					sData := iif("NAME" $ s,alltrim(s:name),"")+"("+sData+")"
				endif
			endif
			if tmp:type == "S"
				s:=oDict:getValue(data[sKey])
				if !empty(s)
					sData := iif("NAME" $ s,alltrim(s:name),"")+"("+sData+")"
				else
					sData := ""
				endif
			endif
			@ x1++,y1 say padr(tmp:name,16,".")+padr(sData,y2-y1-16)
		next
	endif

	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function ab_def_edit_card(oDep,data,oBox,colorSpec)
	local pic,getlist:={},x, empty_flag:=.f.
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local cDesc

	local n,i,j,s,oDict,tmp,tmp2,mkeys
	local oClass,oAttr,sKey,sData
	local gColor := set("ab_colors_dialog")
	local mRef,nRef:=1,aRef

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	//oDict := codb_dict_reference()
	//oDep  := codb_dep_reference()
	oDict := oDep:dictionary()
	pic:="@S"+alltrim(str(y2-y1-17),3,0)

	@ x1++,y1 say padc([OBJECT parameters],y2-y1)
	@ x1++,y1 say replicate("€",y2-y1)
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	if "CLASS_ID" $ data
		oClass := oDict:getValue(data:class_id)
		oDict:padrBody(data,data:class_id)
	endif
	if empty(oClass)
		@ x1++,y1 say [This object don`t have CLASS description]
		mkeys:=mapKeys(data)
		for i=1 to len(mKeys)
			@ x1++,y1 say padr(oDict:hashname(mKeys[i]),16,".")+padr(data[mKeys[i]],y2-y1-16)
		next
		dispend()
	else
		@ x1++,y1 say [This object of CLASS:]+oClass:name
		dispend()
		for i=1 to len(oClass:attr_list)
			tmp:=oDict:getValue(oClass:attr_list[i])
			sKey:=alltrim(upper(tmp:name))
			@ x1,y1 say padr(tmp:name,16,".")
			if ! (sKey $ data)
				sdata := [(Error ! Attribute abscent in data object)]
				@ x1++,y1+16 say sData
				loop
			endif
			if tmp:type == "R"
				aRef := oDep:select(tmp:ref_to)
				if empty(tmp:ref_to) .or. empty(aRef)
					tmp2 := ab_choice_class(oDict)
					aRef := oDep:select(tmp2)
				endif
				mRef:={}
				for j=1 to len(aRef)
					cDesc:=""
					tmp2 := oDep:getValue(aRef[j])
					if valtype(tmp2)=="O"
						cDesc := codb_getValue(tmp2:class_id)
						if !empty(cDesc)
							aadd(mRef, cDesc:essence(tmp2) )
						elseif "NAME" $ tmp2
							aadd(mRef,alltrim(tmp2:name)+"("+alltrim(aRef[j])+")" )
						else
							aadd(mRef,"")
						endif
					else
						aadd(mRef,"")
					endif
					if aRef[j] == data[sKey]
						nRef := j
					endif
				next
			endif
			if tmp:type == "S"
				aRef := oDict:select("CLASS")
				aadd(aRef,"")
				ains(aref,1)
				aRef[1] := ""
				mRef:={}
				for j=1 to len(aRef)
					tmp2 := oDict:getValue(aRef[j])
					if valtype(tmp2)=="O" .and. "NAME" $ tmp2
						aadd(mRef,alltrim(tmp2:name)+"("+alltrim(aRef[j])+")" )
					else
						aadd(mRef,"")
					endif
					if aRef[j] == data[sKey]
						nRef := j
					endif
				next
			endif
			if !empty( mRef )
				@ x1++,y1+16, x1+6, y1+51 get nRef listbox mRef dropdown
				read
				data[sKey] := aRef[nRef]
				mref := {}
			else
				sData := data[sKey]
				if tmp:type $ "CNLD"
					if tmp:type $ "C"
						@ x1++,y1+16 get sData color (gcolor) picture (pic)
					else
						@ x1++,y1+16 get sData color (gcolor)
					endif
					read
					if lastkey() != 27
						data[sKey] := sData
					endif
				 else
					sData := varToString(sData,,,.f.)
					@ x1++,y1+16 say sData picture (pic)
				 endif
			endif
		next
	endif

	setcolor(oldcol)

return ret
