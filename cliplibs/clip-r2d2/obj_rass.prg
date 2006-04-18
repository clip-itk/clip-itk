#include "r2d2lib.ch"

function r2d2_objRefAssign_xml(_queryArr)

local err,_query
local oDict,sDep,oDep, tmp,tmp1,tmp2, classDesc
local obj,i,j,a,b,lang:="",idlist
local id := "", value:="",attr:=""

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "LANG" $ _query
		lang := _query:lang
	endif
	if "ID" $ _query
		id := _query:id
	endif
	if "ATTRIBUTE" $ _query
		attr := upper(_query:attribute)
	endif
	if "ATTR" $ _query
		attr := upper(_query:attr)
	endif
	if "VALUE" $ _query
		value := _query:value
	endif

	if empty(id) .or. empty(value) .or. empty(attr)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		? "Usage:"
		? "    obj_rass?id=<id_object>&value=<id_ref>&attr=<attr_name>"
		?
		return
	endif

	cgi_xml_header()

	sDep := left(id,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	oDep := codb_needDepository(sDep)
	if empty(oDep)
//		cgi_xml_error("Depository not found "+sDep)
		return
	endif
	oDict := oDep:dictionary()

	obj := oDep:getValue(id,10)
	if empty(obj)
		cgi_xml_error("Object ID not found "+id)
		return
	endif
	if !(attr $ obj )
		cgi_xml_error(attr+" not found in object.")
		return
	endif
	tmp1:=obj[attr]
	if !empty(tmp1)
		cgi_xml_error(attr+" not empty in object.")
		return
	endif
	obj[attr]:=value
	if !oDep:update(obj)
		cgi_xml_error(oDep:error)
		return
	endif
	obj := oDep:getValue(id)

	classDesc := oDict:getValue(obj:class_id)

	if empty(classDesc)
		cgi_xml_error("Not found class description for "+obj:class_id)
		return
	endif

	/* put xml-header */
	?
	? '<overlay '
	? ' title=" " onload="oppa()"'
	? 'xmlns:html="http://www.w3.org/1999/xhtml"'
	? 'xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul">'
	? '<respond value="yes" />'
	? '</overlay>'
?
return

