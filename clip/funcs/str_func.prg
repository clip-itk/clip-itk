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
	local c,arr, le, i, k, s, key, val, iskey := .f.
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
		case s == "="
			key := k
			k := ""
			iskey := .t.
		case s == "&"
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

