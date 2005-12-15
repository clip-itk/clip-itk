/*
    Copyright (C) 2002-2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

local oDep,oDict,tmp,obj
local i,j,x, aList, classDesc, attrs, attr

parameters sDep, className, sData, cKeyField

if empty(sDep) .or. empty(classname) .or. empty(sData)
	? 'Usage: codb_addobj <depository> <classname> <"attr1=data1;attr2=data2;...attrN=dataN">'
	?
	return
endif

	set exclusive off

	oDep:=coDepository():new(sDep)
	if !empty(oDep:error)
		? oDep:error
		?
		return
	endif
	oDep:open()
	if !empty(oDep:error)
		? oDep:error
		?
		return
	endif

	oDict:=oDep:dictionary()
	classDesc := oDict:classBodyByName(className)
	if empty(classDesc)
		? [Class description not found:],classname
		?
		return
	endif

	aList := cgi_split(sData)
	obj:=map()
	for i=1 to len(classDesc:attr_list)
		attr := oDict:getValue(classDesc:attr_list[i])
		if empty(attr)
			loop
		endif
		x := upper(attr:name)
		if ! (x $ aList)
			loop
		endif
		do switch attr:type
			case "N"
				obj[x] := val(aList[x])
			case "D"
				obj[x] := stod(aList[x])
			otherwise
				obj[x] := aList[x]
		endswitch
	next
	if "ID" $ aList
		obj:id := aList:id
		oDep:update(obj)
	else
		if !empty(cKeyField) .and. upper(cKeyField) $ obj
			aList:id := oDep:id4PrimaryKey(classDesc:id,cKeyField, obj[upper(cKeyField)])
		endif
		if !empty(aList:id)
			obj:id := aList:id
			oDep:update(obj)
		else
			obj:id := oDep:append(obj,classDesc:id)
		endif
	endif
	? [Added(updated) object], oDep:getValue(obj:id)
	? oDep:error
	?
return
