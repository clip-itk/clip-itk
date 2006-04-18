#include "r2d2lib.ch"

function r2d2_delobj_xml(_queryStr)

local _query,_queryArr,sprname:=""
local lang:="",sDep:="",obj_id:="",objs_id:={}
local oDep,oDict,obj, classDesc,defClass, attr_list,attr
local i,j,k,x,tcol,rname,ind_list
local needDelete:=.t.
local first_flag := .t.

	errorblock({|err|error2html(err)})

	_queryArr := cgi_split(_queryStr,.t.)
	_query    := d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "ID" $ _query
		obj_id := _query:id
	endif
	if "SPR" $ _query
		sprname := _query:spr
	endif
	if "UNDELETE" $ _query
		needDelete := .f.
	endif
	if "LANG" $ _query
		lang := _query:lang
	endif

	if empty(obj_id)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		?? "ID not defined "
		? "Usage:"
		? "    delobj?id=<obj_id>;[undelete=any]"
		?
		return
	endif


	cgi_xml_header()
	? ' <window name="object_body"'
	? 'xmlns:html="http://www.w3.org/1999/xhtml"'
	? 'xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul">'

	sDep := substr(obj_id,1,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	oDep := codb_needDepository(sDep)
	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDep )
		return
	endif
	oDict := oDep:dictionary()
    defClass := oDict:classBodyByName(sprname)

	if "," $ obj_id
		objs_id := split(obj_id,"[,]")
	else
		aadd(objs_id,obj_id)
	endif


	for x=1 to len(objs_id)
		obj_id := objs_id[x]
		obj:=oDep:getValue(obj_id)

		if empty(obj)
        	if empty(defClass)
				oDep:delete(obj_id)
            else
				oDep:delete(obj_id,,defClass:id)
            endif
			cgi_xml_error("Object not found for:"+obj_id)
			cgi_xml_error("Object not found for:"+oDep:error)
			?
			loop
		endif
		classDesc := oDict:getValue(obj:class_id)

		if empty(classDesc)
			cgi_xml_error("Class definition not found for:"+obj:class_id)
			?
			loop
		endif

		if classDesc:name == "accpost" .and. first_flag
			r2d2_accpost_log(oDep,"CGIDEL","",_queryStr)
			first_flag := .f.
		endif

		if !oDict:lockID(classDesc:id,10000)
			return
		endif
		if .f. //classDesc:name == "accpost"
			oDep:error := r2d2_mt_oper("delete_accpost",oDep,obj)
		else
			if needDelete
				oDep:delete(obj_id)
			else
				oDep:unDelete(obj_id)
			endif
		endif
		oDict:unLockID(classDesc:id)

		if !empty(oDep:error)
			cgi_xml_error("Error deleting object:"+oDep:error)
			?
			loop
		endif

	next
	? '</window>'
?
return
