/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/* install procedure all CODB dictionaries and default data objects */
//#include "codbcfg.ch"

#include "six2clip.ch"
#include "codbcfg.ch"
#include "inkey.ch"

local dList,list
local dictlist:={}, oDicts:={}, dictId, oDict
local deplist:={} , oDeps:={},  depId, oDep
local classes,class,attr,a,b,c,obj
local plugins,oPlug,m
local i,j,k,k1,k2,id,tmp,key
local c_list:={}

	for i=1 to pcount()
		aadd(c_list,lower(param(i)))
	next

	set exclusive on
	set translate path off
	set autopen on
	rddsetdefault("DBFCDX")

	if empty(c_list)
		? "Usage: codb_rcheck class1 class2 class3 ...."
		? "or"
		? "Usage: codb_rcheck dict1 dict2 ...."
		?
		quit
	endif

	dList:=codbList():new()
	if val(dList:error)!=0
		? [Error open dictionaries list:]+dList:error
		?
		return
	endif

	list := dList:list()
	for i=1 to len(list)
		j := at(":",list[i])
		aadd(dictList,left(list[i],j-1))
	next
	? "Detected dictionaries:",dictList
	? "Open dictionary:"
	for i=1 to len(dictList)
		dictId := dictList[i]
		?? dictId,""
		aadd(oDicts,NIL)
		oDicts[i] := coDictionary():new(dictId)
		if !empty(oDicts[i]:error)
			?? oDicts[i]:error
			oDicts[i]:=NIL
			loop
		endif
		tmp := oDicts[i]:select("DEPOSIT")
		for j=1 to len(tmp)
			key := oDicts[i]:getValue(tmp[j])
			if empty(key)
				loop
			endif
			aadd(depList,dictId+key:number)
		next
		?? "OK,",""
	next
	? "Detected depositories:",depList
	? "Open depository:"
	for i=1 to len(depList)
		depId := depList[i]
		?? depId,""
		aadd(oDeps,NIL)
		oDeps[i] := coDepository():new(depId)
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			oDeps[i] := NIL
			loop
		endif
		oDeps[i]:open()
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			oDeps[i] := NIL
			loop
		endif
		?? "OK",","
	next
	? "Checking deleted references:"
	for i=1 to len(oDeps)
		? "  Checking depository",depList[i]
		oDep := oDeps[i]
		if empty(oDep)
			loop
		endif
		oDict := oDep:dictionary()
		classes := oDict:select("CLASS")
		if empty(classes)
			loop
		endif
		for j=1 to len(classes)
			class := oDict:getValue(classes[j])
			if empty(class)
				loop
			endif
			k1 := ascan(c_list,lower(class:name))
			k2 := ascan(c_list,left(lower(depList[i]),5))
			if k1<=0 .and. k2 <=0
				loop
			endif
			tmp := oDep:select(class:id)
			? "    Checking class",class:name, class:id, alltrim(str(len(tmp))),"objects"
			for k1=1 to len(tmp)
				obj := oDep:getValue(tmp[k1])
				if empty(obj)
					loop
				endif
				for k2=1 to len(class:attr_list)
					attr := oDict:getValue(class:attr_list[k2])
					if empty(attr)
						loop
					endif
					if !(attr:type $ "RS")
					       loop
					endif
					a := obj[upper(attr:name)]
					if empty(a)
						loop
					endif
					b := codb_getValue(a)
					if empty(b)
						? obj:id,"->",a,"(",codb_essence(obj),")"
					endif
				next
			next
		next
	next
	?
return

