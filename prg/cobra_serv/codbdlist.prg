/* Example loaddable module for COBrA server*/
/* return list of dictionaries */

function codbdlist(oConnect,oIni,oAnswer)
	local ret:={}
	local err,e,eb,i,j
	local dlist,list,oDict,dict_id
	eb := errorBlock({|e|break(e)})
	dList:=codbList():new()
	if val(dList:error)!=0
		oAnswer:error:=dList:error
		return
	endif

	list := dList:list()
	for i=1 to len(list)
		j := at(":",list[i])
		dict_id := left(list[i],j-1)
		oDict := codb_dict_reference(Dict_id)
		aadd(ret,{dict_id,substr(list[i],j+1),oDict!=NIL})
	next
	dList:close()
	errorBlock(eb)
	oAnswer:return := ret
return
