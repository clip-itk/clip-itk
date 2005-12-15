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
local dictlist:={}, oDicts:={}, dictId, oDict
local deplist:={} , oDeps:={},  depId, oDep
local classes,class,a,b,c,obj,count
local plugins,oPlug,m


	set exclusive on
	set translate path off
	set autopen on
	rddsetdefault("DBFCDX")

	dList:=codbList():new()
	if val(dList:error)!=0
		? [Error open dictionaries list:]+dList:error
		?
		return
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
	? "Check metadata:"
	for i=1 to len(Odicts)
		oDict := oDicts[i]
		if empty(oDict)
			loop
		endif
		?? "update TVIEW for ",oDict:id,""
		tmp := oDict:select("TVIEW")
		?? space(CODB_ID_LEN+1)
		for j=1 to len(tmp)
			key := oDict:getValue(tmp[j])
			if empty(key)
				loop
			endif
			?? replicate(chr(K_BS),CODB_ID_LEN+1),padr(tmp[j],CODB_ID_LEN)
			if ! ("HEADER" $ key) .or. empty(key:header)
				key:header := key:name
			endif
			if ! ("FOOTER" $ key) .or. empty(key:footer)
				key:footer := ""
			endif
			oDict:update(key)
		next
		?? replicate(chr(K_BS),CODB_ID_LEN+1), "","OK",""
	next
	? "Detected depositories:",depList
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
		? "Check indexes for classes and objects:"
		count := 0
		oDep  := oDeps[i]
		oDict := oDep:dictionary()
		oDict:stopTriggers()
		classes := oDict:select("CLASS")
		for a=1 to len(classes)
			class := oDict:getValue(classes[a])
			tmp := oDep:select(classes[a],,,,,.t.)
			count += len(tmp)
			? "&\t",class:name,len(tmp),"objects"
			if empty(class)
				loop
			endif
			if !class:unstable
				?? "","stable"
				loop
			endif
			/*
			plugins := oDict:select("PLUGINS",,,'class_id=="'+classes[a]+'"')
			for m=1 to len(plugins)
				oPlug := map()
				oPlug:class_id := ""
				oPlug:id := plugins[m]
				oDict:update(oPlug)
			next
			*/
			?? space(CODB_ID_LEN+1)
			for b=1 to len(tmp)
				?? replicate(chr(K_BS),CODB_ID_LEN+1),padr(tmp[b],CODB_ID_LEN)
				obj:=oDep:getValue(tmp[b])
				if empty(obj)
					loop
				endif
				oDep:update(obj)
			next
			?? "",len(tmp),"objects"
			/*
			for m=1 to len(plugins)
				oPlug := map()
				oPlug:class_id := classes[a]
				oPlug:id := plugins[m]
				oDict:update(oPlug)
			next
			*/
			class:unstable := .f.
			oDict:update(class)
		next
		? "Checked",count,"objects in depository"
		oDict:startTriggers()

	next
	?
return

