#include "r2d2lib.ch"

function r2d2_accpost_log_beg(oDep,oper,id,data)
	local oDict,class_id
	local ret :="" ,tmp,obj

	oDict := oDep:dictionary()
	if set("ACCPOST_LOG")=="NO"
		return ""
	endif
	if empty(class_id)
		tmp := oDict:select("CLASS",,"accpost_log")
		if !empty(tmp)
			class_id := tmp[1]
		endif
	endif
	if empty(class_id)
		outlog(__FILE__,__LINE__,[Can`t find description of class "accpost_log"])
		return ""
	endif

	obj:=map()
	if empty(id)
		id := ""
	endif
	obj:accpost 	:= id
	obj:opertype	:= oper
	obj:realDate	:= date()
	obj:realTime	:= time()
	obj:beg_time	:= time()
	obj:end_time	:= "99:99"
	obj:diffobj	:= data
	/*
	if oper == "DEL"
	elseif oper=="ADD"
		obj:diffObj := oClone(newData)
	else
		obj:diffObj := diffObj(oldData,newData)
	endif
	*/
	ret := oDep:append(obj,class_id)
	if !empty(oDep:error)
		outlog(__FILE__,__LINE__,[trigger run-time error:],oDEp:error)
		return ret
	endif
return ret

**************************
function r2d2_accpost_log_end(oDep,log_id)
	local oDict,obj,accpost_log
	local tmp
	if set("ACCPOST_LOG")=="NO"
		return
	endif
	oDict := oDep:dictionary()
	accpost_log := oDict:classBodyByName("accpost_log")
	outlog(__FILE__,__LINE__,log_id)
	if !empty(log_id)
		if empty(accpost_log)
			outlog(__FILE__,__LINE__,[Can`t find description of class "accpost_log"])
			return .f.
		endif
		obj := oDep:getValue(log_id)
		if empty(obj)
			return .f.
		endif
		obj:end_time := time()
		oDep:update(obj)
	endif
	tmp := oDep:select(accpost_log:id,,,'end_time=="99:99"')
	// outlog("",tmp)
	if empty(tmp)
		return .t.
	endif
	? "<error>"
	? [analitic balance have error]
	? "</error>"
return .t.

