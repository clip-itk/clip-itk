#include "r2d2lib.ch"

function r2d2_accpost_log(oDep,oper,id,data)
	local oDict,class_id
	local tmp,obj

	oDict := oDep:dictionary()
	if set("ACCPOST_LOG")=="NO"
		return
	endif
	if empty(class_id)
		tmp := oDict:select("CLASS",,"accpost_log")
		if !empty(tmp)
			class_id := tmp[1]
		endif
	endif
	if empty(class_id)
		outlog(__FILE__,__LINE__,[Can`t find description of class "accpost_log"])
		return .f.
	endif

	obj:=map()
	if empty(id)
		id := ""
	endif
	obj:accpost 	:= id
	obj:opertype	:= oper
	obj:realDate	:= date()
	obj:realTime	:= time()
	obj:diffobj	:= data
	/*
	if oper == "DEL"
	elseif oper=="ADD"
		obj:diffObj := oClone(newData)
	else
		obj:diffObj := diffObj(oldData,newData)
	endif
	*/
	oDep:append(obj,class_id)
	if !empty(oDep:error)
		outlog(__FILE__,__LINE__,[trigger run-time error:],oDEp:error)
		return .f.
	endif
return .t.
