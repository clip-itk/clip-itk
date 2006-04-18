#include "r2d2lib.ch"

function r2d2_opermemo(_queryStr)

local _query, _queryArr
local lang:="", sDep:="", oper:="", attr:="", value:=""
local obj_id:="",objs_id:={}
local oDep,oDict
local x,obj, classDesc

	errorblock({|err|error2html(err)})

	_queryArr := cgi_split(_queryStr,.t.)
	_query    := d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "ID" $ _query
		obj_id := _query:id
	endif
	if "__OPER" $ _query
		oper := upper(_query:__oper)
	endif
	if empty(oper)
		oper := "GET"
	endif
	if "__ATTR" $ _query
		attr := _query:__attr
	endif

	if "VALUE" $ _query
		value := _query:value
	endif

	if empty(obj_id) .or. empty(oper) .or. empty(attr)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		if empty(obj_id)
			?? "ID not defined "
		endif
		if empty(oper)
			?? "__OPER not defined "
		endif
		if empty(attr)
			?? "__ATTR not defined "
		endif
		? "Usage:"
		? "    memo?id=<obj_id>;__oper=<oper>;__attr=<attrname>;value=<anydata>"
		?
		return
	endif

	cgi_text_header()

	sDep := substr(obj_id,1,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	oDep := codb_needDepository(sDep)
	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDep )
		return
	endif
	oDict := oDep:dictionary()

	aadd(objs_id,obj_id)
	****
	for x=1 to len(objs_id)
		obj_id := objs_id[x]
		obj:= oDep:getValue(obj_id)

		if empty(obj)
			cgi_xml_error("Object not found for:"+obj_id)
			?
			loop
		endif
		classDesc := oDict:getValue(obj:class_id)

		if empty(classDesc)
			cgi_xml_error("Class definition not found for:"+obj:class_id)
			?
			loop
		endif

		if upper(attr) $ obj
		else
			cgi_xml_error("Attribute not found in object:"+attr)
			?
			loop
		endif

		if !oDict:lockID(classDesc:id,10000)
			return
		endif

		if oper=="SET"
			obj[upper(attr)] := value
			oDep:update(obj)
		endif
		if !empty(oDep:error)
			cgi_xml_error2("Error updating object:"+oDep:error)
		endif
		obj := oDep:getValue(obj_id)
		value := obj[upper(attr)]
		oDict:unLockID(classDesc:id)
	next
	? value
return
