/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "common.ch"
*****************************************************
function allt(p1)
return alltrim(p1)
***************************************************************
function atc(s,str,kol)
return at(lower(s),lower(str),kol)
***************************************************************
func low_alt(str)
return lower(str)
***************************************************************
func upp_alt(str)
return upper(str)
*****************************************************
FUNCTION memotran(str,s1,s2)
	local ret
	s1:=iif(s1==NIL,";",s1)
	s2:=iif(s2==NIL," ",s2)
	ret:=strtran(str,chr(13)+chr(10),s1)
return strtran(ret,chr(141)+chr(10),s2)
***************************************************************
* s1 - string
* s2 - delimiter
FUNCTION Split(s1,s2)
LOCAL temp:={}, arr:={}, i:=1
do while search(s2, s1, arr)
	aadd(temp, left(s1, arr[i][1]-1))
	s1 := substr(s1, arr[i][2])
	i++
enddo
aadd(temp, s1)
RETURN temp
****************************************************************
/*
делит строку на подстроки заданной длины,
записывает подстроки в arr и возвращает полученный массив
str -  исходная строка
len -  длина подстроки
delim - разделитель
*/
FUNCTION splitLen(str, len, delim)
local m, nstr, i, arr := {}
  str := alltrim(str)
  delim := iif(delim==NIL, " ", delim)
  if len(str)<=len
	aadd(arr, str)
	RETURN arr
  endif
  m := split(str, delim)
  nstr := ''
  for i in m
    if len(nstr)+len(i)<len
      nstr += i+delim
    else
      aadd(arr, nstr)
      nstr := i+delim
    endif
  next
  aadd(arr, nstr)
RETURN arr
****************************************************************
FUNCTION cgi_split(cgistr,aType)
	local c,arr, le, i, k, s, key, val, iskey := .f., prevs:=""
	if aType == NIL
		aType :=.f.
	endif
	if aType
		arr:={}
	else
		arr:=map()
	endif

	le := len(cgistr)
	key := ""
	val := ""
	k := ""
	for i=1 to le+1
		s := substr(cgistr, i, 1)
		do case
		case s == "=" .and. ! ( prevs $ "<>" )
			key := k
			k := ""
			iskey := .t.
		case s == "&" .or. s== ";"
			if iskey
				val := k
			else
				key := k
			endif
			if aType
				aadd(arr,{key,val})
			else
				arr[hashstr(upper(key))] := val
			endif
			iskey := .f.
			key := ""
			val := ""
			k:=""
		case s == "%"
			c := substr(cgistr, i+1, 2)
			if len(c)==2
				k += chr(cton(c, 16))
			endif
			i += len(c)
		case s == "+"
			k += " "
		otherwise
			k += s
		endcase
		prevs := s
	next
	if iskey
		val := k
	else
		key := k
	endif
	if .not. empty(key)
	  if aType
		aadd(arr, {key, val})
	  else
		arr[hashstr(upper(key))] := val
	  endif
	endif
return arr

*****************************************************
function parse_rules_text(sRules)
	local ret := {}, cTarget:=NIL,depends
	local m1,m2,m3,s,s1,s2,i,j,k
	m1 := split(sRules,"&\n")
	for i=1 to len(m1)
		s := m1[i]
		if left(s,1) == "&\t" .and. cTarget != NIL
			aadd(cTarget[3],substr(s,2))
			loop
		endif
		if empty(s) .or. left(s,1)=="#"
			loop
		endif
		m2 :=split(s,"[:, ]")
		if empty(m2)
			loop
		endif
		aadd(ret,{m2[1],{},{}})
		cTarget := atail(ret)
		for j=2 to len(m2)
			if empty(m2[j])
				loop
			endif
			aadd(ctarget[2],m2[j])
		next
	next
return ret

