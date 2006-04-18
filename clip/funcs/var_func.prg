/*
	Copyright (C) 2001  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "lang.ch"
***************************************************************
function memvarblock(vname)
  local __cname
  if ismemvar(vname) //type("m->"+vname)!="U"
	 __cname:="{|_1| iif(_1==NIL,m->"+vname+",m->"+vname+":=_1) }"
	 __cname:=&__cname
	 return __cname
  endif
return NIL

***************************************************************
function between(p1,p2,p3)
local ret:=.f.
 if valtype(p1) == valtype(p2) .and. valtype(p1) == valtype(p3)
	if p2<=p3
	   ret=( p2<=p1 .and. p3>=p1)
	else
	   ret=( p2>=p1 .and. p3<=p1)
	endif
 endif
return ret

***************************************************************
function xtoc( var,len,dec )
   local ret:="",sw:=valtype(var)
   do case
	  case sw=="A"
	   ret=LANG_ARRAY_STRING
	  case sw=="B"
	   ret=LANG_CBLOCK_STRING
	  case sw=="C"
	   ret=var
	  case sw=="D"
		if empty(var)
			ret=space(10)
		else
			ret=dtos(var)
		endif
	  case sw=="L"
	   ret=iif(var,"T","F") //iif(var,LANG_YES_CHAR,LANG_NO_CHAR)
	  case sw=="N"
	   ret=str(var,len,dec)
	  case sw=="M"
	   ret=var
	  case sw=="O"
	   ret=LANG_OBJECT_STRING
	  case sw=="U"
	   ret=""
	  otherwise
	   ret=LANG_UNKNOWN_STRING
   end
return ret

***************************************************************
function readvar
	local s:=set("__readvar")
	if s==NIL
		s=""
	endif
return upper(s)

***************************************************************
function toString( var,len,dec )
   local ret:="",sw:=valtype(var)
   do case
	  case sw=="A"
	   ret=LANG_ARRAY_STRING
	  case sw=="B"
	   ret=LANG_CBLOCK_STRING
	  case sw=="C"
	   ret=var
	  case sw=="D"
	   ret=dtoc(var)
	  case sw=="T"
	   ret=ttoc(var)
	  case sw=="L"
	   ret=iif(var,LANG_YES_STRING,LANG_NO_STRING)
	  case sw=="N"
	   ret=str(var,len,dec)
	  case sw=="M"
	   ret=LANG_MEMO_STRING
	  case sw=="O"
	   ret=LANG_OBJECT_STRING
	  case sw=="U"
	   ret=LANG_UNDEF_STRING
	  otherwise
	   ret=LANG_UNKNOWN_STRING
   end
return ret
***************************************************************
function cValToChar( var,len,dec )
   local ret:="",sw:=valtype(var)
   do case
	  case sw=="A"
	   ret=LANG_ARRAY_STRING
	  case sw=="B"
	   ret=LANG_CBLOCK_STRING
	  case sw=="C"
	   ret=var
	  case sw=="D"
	   ret=dtoc(var)
	  case sw=="T"
	   ret=ttoc(var)
	  case sw=="L"
	   ret=iif(var,LANG_YES_STRING,LANG_NO_STRING)
	  case sw=="N"
	   ret=str(var,len,dec)
	  case sw=="M"
	   ret=var
	  case sw=="O"
	   ret=LANG_OBJECT_STRING
	  case sw=="U"
	   ret=LANG_UNDEF_STRING
	  otherwise
	   ret=LANG_UNKNOWN_STRING
   end
return ret

***************************************************************
function varToString( var,len,dec, lAtype )
   local ret:="",sw:=valtype(var), i, arr
   lAtype:=iif(lAtype==NIL,.t.,lAtype)
   do case
	  case sw=="A"
		if lAtype
			ret="aclone({"
		else
			ret="{"
		endif
		for i:=1 to len(var)
			ret += varToString(var[i], len, dec, lAtype) + ","
		next
		if len(var) > 0
			ret := substr(ret, 1, len(ret)-1)
		endif
		if lAtype
			ret += "})"
		else
			ret += "}"
		endif
	  case sw=="C"
		ret='"'+var+'"'
	  case sw=="D"
		ret='"'+dtoc(var)+'"'
	  case sw=="T"
		ret='"'+ttoc(var)+'"'
	  case sw=="L"
		ret=iif(var,".T.",".F.")
	  case sw=="N"
		ret=str(var,len,dec)
	  case sw=="M"
		ret='"'+var+'"'
	  case sw=="O"
		if lAtype
			ret := "obj:=map()"
			arr := mapkeys(var)
			for i:= 1 to len(arr)
				ret += ", obj:"+alltrim(hashname(arr[i]))+":="+varToString(var[arr[i]], len, dec, lAtype)
			next
		else
			ret := "{object}"
		endif
	  case sw=="U"
		ret="NIL"
	  otherwise
		ret="NIL"
   end
return ret

****************************************************************************
function funcname(pn)
	local str,i := 2 // i>1 начинаем не с функции, которая вызывает FUNCNAME()
		   // а с предыдущей
	pn := upper(pn)
	do while .t.
		str := procname(i)
		if empty(str)
			exit
		endif
		if str == pn
			return .t.
		endif
		i++
	enddo
return .f.

****************************
function stype(var)
	Local objLocal,nLastHandler,error,ret_val:="U",prom
	nLastHandler:=ERRORBLOCK({|x|Break(x)})

	Begin Sequence
		ret_val=Type(var)
	Recover Using error
	End Sequence
	if ret_val="U"
		Begin Sequence
			prom=&var
		Recover Using error
		End Sequence
		ret_val=valtype(prom)
	endif
	ERRORBLOCK(nLastHandler)
return ret_val
*****************************************************
function slen(per)
	local n:=0
	do case
		case stype(per)=="C"
			n=len(&per)
		case stype(per)=="D"
			n=len(dtoc(&per))
		case stype(per)=="N"
		n=len(str(&per))
	endcase
return n

**************************************
function inlist
	local i,j,p,ret:=.f.
	p=param(1)
	j=pcount()
	for i=2 to j
		if p==param(i)
			ret=.t.
			exit
		endif
	next
return ret

**************************************
function Inherit(Obj)
	local NewObj := nil, k

	if valtype(Obj)!="O"; return nil; endif

	NewObj := map()
	for k in Obj keys
		if k != HASH_SUPER
			if valtype(Obj[k])=="B"
				NewObj[k] := Obj[k]
			else
				NewObj[k] := @Obj[k]
			endif
		endif
	next
	NewObj:super := Obj
return NewObj
**************************************
function oclone(Obj)
	local NewObj := nil, k,vt

	if valtype(Obj)!="O"; return nil; endif

	NewObj := map()
	for k in Obj keys
		vt := valtype(Obj[k])
		if vt=="O"
			newObj[k] := oClone(obj[k])
		elseif vt=="A"
			newObj[k] := aClone(obj[k])
		else
			NewObj[k] := Obj[k]
		endif
	next
return NewObj

**************************************
function varClone(var)
	local NewVar := nil, k, t:=valtype(var)
	if t == "O"
		NewVar := map()
		for k in Var keys
			newVar[k] := varClone(var[k])
		next
	elseif t == "A"
		newVar := {}
		for k=1 to len(var)
			aadd(newVar,varClone(var[k]))
		next
	else
		newVar := var
	endif
return NewVar

**************************************
function o2self(self,Obj)
	local k

	if valtype(Obj)!="O"; return nil; endif

	for k in Obj keys
		if valtype(Obj[k])=="B"
			self[k] := Obj[k]
		else
			self[k] := @Obj[k]
		endif
	next
return self

**************************************
function o2update(newData,oldData)
	local ret:=map(),k

	if valtype(oldData)!="O"; return newData; endif
	if valtype(newData)!="O"; return newData; endif

	for k in oldData keys
		ret[k] := oldData[k]
	next
	for k in newData keys
		ret[k] := newData[k]
	next
return ret

**************************************
function varChanged(newData,oldData)
	local i,m1,m2,val1,val2
	local t1:=valtype(newData), t2:=valtype(oldData)
	if t1 == t2
		if newData == oldData
			return .f.
		endif
	else
		return .t.
	endif
	if t1 == "A"
		if len(newData) != len(oldData)
			return .t.
		endif
		for i=1 to len(newData)
			if varChanged(newData[i],oldData[i])
				return .t.
			endif
		next
		return .f.
	endif
	if t1 != "O" .or. t2!="O"
		return .t.
	endif
	m1 := mapkeys(newData)
	m2 := mapkeys(oldData)
	if len(m1) != len(m2)
		return .t.
	endif
	for i=1 to len(m1)
		if m1[i] != m2[i]
			return .t.
		endif
		val1 := newData[m1[i]]
		val2 := oldData[m2[i]]
		if varChanged(val1,val2)
			return .t.
		endif
	next
return .f.

**************************************
function patchObj(obj,diff)
	local i
	if valtype(obj)!="O" .or. valtype(diff)!="O"
		return obj
	endif
	for i in diff KEYS
		obj[i] := diff[i]
	next
return obj

**************************************
function diffObj(oOld,oNew)
	local diff:=map()
	local i,x,t,vOld,vNew
	if valtype(oOld)!="O" .or. valtype(oNew)!="O"
		return diff
	endif
	for i in oNew KEYS
		if ! (i $ oOLd)
			diff[i] := oNew[i]
			loop
		endif
		vNew := oNew[i]
		vOld := oOld[i]
		t := valtype(vNew)
		if t != valtype(vOld)
			diff[i] := vNew
			loop
		endif
		if  t $ "CLDNM"
			if vOld != vNew
				diff[i] := vNew
			endif
			loop
		endif
		if  t == "O"
			x := diffObj(vOld,vNew)
			if !empty(x)
				diff[i] := x
			endif
			loop
		endif
		if  t == "A"
			x := cmpArrays(vOld,vNew)
			if !x
				diff[i] := vNew
			endif
			loop
		endif
	next
return diff

**************************************
**************************************
static function cmpArrays(aOld,aNew)
	local i,x,t,vOld,vNew
	if len(aOld) != len(aNew)
		return .f.
	endif
	for i=1 to len(aOld)
		vNew := aNew[i]
		vOld := aOld[i]
		t := valtype(vNew)
		if t != valtype(vOld)
			return .f.
		endif
		if  t $ "CLDNM"
			if vOld != vNew
				return .f.
			endif
			loop
		endif
		if  t == "O"
			x := diffObj(vOld,vNew)
			if !empty(x)
				return .f.
			endif
			loop
		endif
		if  t == "A"
			x := cmpArrays(vOld,vNew)
			if !x
				return .f.
			endif
		endif
	next
return  .t.

**************************************

