/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
****************************************
* save and restore clip SET values
****************************************
*
****************************************
function saveSets()
	local i,__set_names:=setnames()
	for i in __set_names KEYS
	      __set_names[i]:=set(i)
	next
return __set_names

****************************************
function restoreSets(m)
	local i
	if valtype(m)!="O"
		return .f.
	endif

	for i in m KEYS
	      set(i,m[i])
	next
return .t.

****************************************
function setnames()
	local __set_names
	#include "setnames.ch"
return __set_names

****************************************
func OSVer
Return 6.22

