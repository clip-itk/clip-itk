#include "r2d2lib.ch"

function r2d2_objarr_xml(_queryArr)

local err,_query
local oDict,sDep,oDep, tmp,tmp1,tmp2, classDesc
local obj,i,j,a,b,lang:="",idlist
local id := "",oper:="add", value:="",attr:=""

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
	if "OPER" $ _query
		oper := lower(_query:oper)
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
		? "    obj_arr?id=<id_object>&value=<id_ref>&attr=<attr_name>&oper=<oper_name>"
		?
		return
	endif

	cgi_xml_header()
	if "," $ value
		idList := split(value,",")
	else
		idList := {value}
	endif

	sDep := left(id,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	oDep := codb_needDepository(sDep)
	if empty(oDep)
		cgi_xml_error("Depository not found "+sDep)
		return
	endif

	oDict := oDep:dictionary()

	obj := oDep:getValue(id,10)
	if empty(obj)
		cgi_xml_error("Object ID not found "+id)
		return
	endif
	if attr $ obj .and. valtype(obj[attr])=="A"
	else
		cgi_xml_error(attr+" is not array")
		return
	endif
	tmp1:=obj[attr]
	a:={}; b:={}
	for i=1 to len(idList)
		j := ascan(tmp1,idList[i])
		if oper=="add" .and. j<=0
			aadd(a,idList[i])
		endif
		if oper=="del" .and. j>0
			aadd(b,j)
		endif
	next
	asort(b)
	for i=len(b) to 1 step -1
		adel(tmp1,b[i])
	next
	asize(tmp1,len(tmp1) - len(b))
	for i=1 to len(a)
		aadd(tmp1,a[i])
	next
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

	? '</overlay>'
?
return

