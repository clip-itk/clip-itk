/*
    Copyright (C) 2001-2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/* install procedure all CODB dictionaries and default data objects */
//#include "codbcfg.ch"

#include "six2clip.ch"
#include "codbcfg.ch"
#include "inkey.ch"

local dList,list
local i,j,k,id,tmp,key
local dictlist:={}, oDicts:={}, dictId, oDict,_oDict
local deplist:={} , oDeps:={},  depId, oDep
local classes,class,classDesc,a,b,c,obj,count
local plugins,oPlug,m,found
local attrOldId,attrNewId

local sDict, className, attrOld, attrNew

sDict := param(1)
className := param(2)
attrOld := param(3)
attrNew := param(4)

if empty(sDict) .or. empty(className) .or. empty(attrOld) .or. empty(attrNew)
	? 'arename - renamed attribute name from old to new in classname from sDictID'
	? 'Usage: codb_arename <sDictID> <classname> <attrNameOld> <attrNameNew>'
	?
	return
endif


	set exclusive off

	_oDict:=coDictionary():new(sDict)
	if !empty(_oDict:error)
		? _oDict:error
		?
		return
	endif
	_oDict:open()
	if !empty(_oDict:error)
		? _oDict:error
		?
		return
	endif

	classDesc := _oDict:classBodyByName(className)
	if empty(classDesc)
		? [Class description not found:],classname
		?
		return
	endif
	tmp := _oDict:select("ATTR",,attrOld)
	if empty(tmp)
		? [attrOld description not found:],attrOld
		?
		return
	else
		attrOldId := tmp[1]
	endif
	tmp := _oDict:select("ATTR",,attrNew)
	if empty(tmp)
		? [attrNew description not found:],attrNew
		?
		return
	else
		attrNewId := tmp[1]
	endif
	found := 0
	for i=1 to len(classDesc:attr_list)
		tmp := _oDict:getValue(classDesc:attr_list[i])
		if empty(tmp)
			loop
		endif
		if tmp:name == attrOld
			found := i
		endif
		//? tmp:name, attrOld, found
	next
	if found <= 0
		? [attrOld not found in attribute list from class:],classname+":"+attrOld
		?
		return
	endif

	classDesc:attr_list[found] := attrNewId
	_oDict:update(classDesc)
	****
	tmp := _oDict:select("DEPOSIT")
	for j=1 to len(tmp)
		key := _oDict:getValue(tmp[j])
		if empty(key)
			loop
		endif
		aadd(depList,_oDict:id+key:number)
	next
	? "Detected depositories",deplist
	for i=1 to len(depList)
		depId := depList[i]
		aadd(oDeps,NIL)
		? "Open depository:",depId,""
		oDeps[i] := coDepository():new(depId)
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			loop
		endif
		oDeps[i]:open()
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			loop
		endif
		?? "OK"
		? "Remake objects:"
		count := 0
		oDep  := oDeps[i]
		oDict := oDep:dictionary()
		oDict:stopTriggers()
		****
		tmp := oDep:select(classDesc:id,,,,,.t.)
		?? space(CODB_ID_LEN+1)
		for j=1 to len(tmp)
			?? replicate(chr(K_BS),CODB_ID_LEN+1),padr(tmp[j],CODB_ID_LEN)
			obj:=oDep:getValue(tmp[j])
			if empty(obj)
				loop
			endif
			b := upper(attrOld)
			if b $ obj
				obj[upper(attrNew)] := obj[b]
			else
				obj[upper(attrNew)] := ""
			endif
			oDep:update(obj)
		next
		oDict:startTriggers()
	next
	classDesc:unstable := .f.
	_oDict:update(classDesc)
	?
return

