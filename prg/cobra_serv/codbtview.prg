/* Example loaddable module for COBrA server*/

#include "cobra.ch"
#define MAX_TVIEW 1000


function codbtview(oConnect,oIni,oAnswer,tViewId,cCond,DepId)
	local ret:={}
	local class_id, class_desc
	local dict_id, oDict
	local dep_id, oDep
	local err,e,eb
	local i,j,tmp, obj,val
	local columns:={}
	local tViewObj := codb_getvalue(tViewId)
	if empty(tViewObj)
		oAnswer:errno := COBRA_ERR_BADDATA
		oAnswer:error := [Bad TVIEW ID]
		oAnswer:return := ret
	endif
	class_id := tViewObj:class_id
	class_desc := codb_getValue(class_id)
	if empty(class_desc)
		oAnswer:errno := COBRA_ERR_BADDATA
		oAnswer:error := [Bad CLASS ID]
		oAnswer:return := ret
	endif
	dict_id:=left(class_id,codb_info("DICT_ID_LEN"))
	oDict := codb_dict_reference(Dict_id)
	if empty(oDict)
		oAnswer:errno := COBRA_ERR_BADDATA
		oAnswer:error := [Bad dictionary]
		oAnswer:return := ret
	endif
	for i=1 to len(tViewObj:col_list)
		tmp := oDict:getValue(tViewObj:col_list[i])
		if empty(tmp)
			loop
		endif
		aadd(columns,tmp)
	next
	if empty(columns)
		oAnswer:errno := COBRA_ERR_BADDATA
		oAnswer:error := [Bad columns]
		oAnswer:return := ret
	endif
	/**/
	if empty(depId)
		dep_id := dict_id+"01" /* Depository number is ????? */
	else
		dep_id := depId
	endif
	oDep := codb_dep_reference(dep_id)
	if empty(oDep)
		oAnswer:errno := COBRA_ERR_BADDATA
		oAnswer:error := [Bad depository]
		oAnswer:return := ret
	endif
	if empty(cCond)
		tmp := oDep:select(class_id,,,,MAX_TVIEW)
	else
		tmp := oDep:select(class_id,,,cCond,MAX_TVIEW)
	endif
	if empty(tmp) .and. !empty(oDep:error)
		oAnswer:errno := COBRA_ERR_BADDATA
		oAnswer:error := oDep:error
		oAnswer:return := ret
	endif
	/**/
	eb := errorBlock({|e|break(e)})
	for i=1 to len(tmp)
		obj := oDep:getValue(tmp[i])
		if empty(obj)
			loop
		endif
		aadd(ret,{})
		for j=1 to len(columns)
			val := NIL
			begin sequence
				val := mapEval(obj,columns[j]:expr)
			recover using err
				val := [Error:]+e:description
			end sequence
			aadd(ret[i],val)
		next
		aadd(ret[i],obj:id)
	next
	errorBlock(eb)
	oAnswer:return := ret
return
