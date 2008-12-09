#include "r2d2lib.ch"

function r2d2_array2rdf(_queryArr, typeNode)

local err,_query
local aRefs, aTree :={}
local lang:="", sDict:="", sDep:="",connect_id:=""
local oDict,oDep, tmp,tmp1,tmp2, classDesc, s_select:=""
local columns,col, id:="",attr:="", owner_map:=map(),map2:=map(),aData, sId
local i,j,obj,idlist,_idList, iftree:=.f., istree:=""
local urn, sprname:=""


	errorblock({|err|error2html(err)})
	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
	    connect_id := _query:connect_id
        endif

	if "SPR" $ _query
		sprname := _query:spr
	endif
	if "LANG" $ _query
		lang := _query:lang
	endif
	if "ID" $ _query
		id := _query:id
	endif
	if "ATTR" $ _query
		attr := upper(_query:attr)
	endif
	if "ATTRIBUTE" $ _query
		attr := upper(_query:attribute)
	endif
	if "URN" $ _query
		URN := _query:URN
	endif

	if "__ISTREE" $ _query
		istree := _query:__istree
	endif

	lang := cgi_choice_lang(lang)

	if empty(id) .or. empty(attr)
		?? "Content-type: text/html"
		?
		? "Error: bad parameters ! "
		? "Usage:"
		? "    rdfarr?id=<object_id>&attr=<attr_name>"
		?
		return
	endif

	cgi_xml_header()

	if typeNode == 'rdf3'
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	    ? 'xmlns:D="http://itk.ru/D#" '
	    ? 'xmlns:R="http://itk.ru/R#" '
	    ? 'xmlns:S="http://itk.ru/S#">'

	elseif typeNode == 'rdf'
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	    ? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	else
	    ? '<root xmlns="http://itk.ru/json#">'
	endif



	sDep := left(id,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	oDep := codb_needDepository(sDep)
	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDep )
		return
	endif
	oDict := oDep:dictionary()
	//obj := oDep:getValue(id,10)
	obj:=cgi_getValue(id)
	if empty(obj)
		cgi_xml_error("Object ID not found "+id)
		return
	endif


	if attr $ obj //.and. valtype(obj[attr])=="A"

//Когда создается новый объект у него этот атрибут пустой и возвращается как С!!!!!!
	else
		cgi_xml_error(attr+" is not array")
		return
	endif

	classDesc := oDict:getValue(obj:class_id)

	if empty(classDesc)
		cgi_xml_error("Not found class description for "+obj:class_id)
		return
	endif


	idList := {}
	_idList := obj[attr]
	if classDesc:name == "accpost" .and. left(attr,2)=="AN"
		for i=1 to len(_idList)
			aadd(idList,_idList[i][2])
		next
	else
		idList := _idList
	endif



	for i=1 to len(classDesc:attr_list)
		tmp := oDict:getValue(classDesc:attr_list[i])
		if empty(tmp)
			loop
		endif
		if upper(tmp:name) == attr
			sprname := tmp:ref_to
			exit
		endif
	next

	classDesc := NIL
	if !empty(sprname)

		classDesc := cgi_getValue(sprName)
		sprName := classDesc:name

		if empty(classDesc)
			cgi_xml_error("Not found class description")
			return
		endif
		if len(idList) > 0
			oDep := codb_needDepository(idList[1])
			oDict := oDep:dictionary()

		else
			oDict := codb_needDepository(left(classDesc:id,codb_info("DICT_ID_LEN")))
		endif

		columns := cgi_make_columns(oDict,sprname)
	else
	
		columns :={}
		col := map()
		col:datatype := "R"
		col:dataref_to := ""
		col:name := "essence"
		col:header := ""
		col:expr := "cgi_essence(id)"
		col:block := &("{|p1,p2,p3,p4|"+col:expr+"}")
		col:obj_id :={|| "" }
		aadd(columns,col)
	endif

	if empty(columns)
		cgi_xml_error("Empty table description for "+sprname)
		return
	endif

	if empty(istree)    
	    for i=1 to len(columns)
		if columns[i]:name = 'owner_id'
	    	    iftree := .t.
		    exit
		endif
	    next
	else
	    iftree:=iif(istree=='false', .f., .t.)
	endif 

	aTree:=idlist_atree(idList, iftree, oDep, .f., 'exp')
//*--------------------В этом месте перескочить

	if empty(urn)
		urn := 'urn:'+sprname
	endif

	if typeNode == 'rdf3'
	    cgi_putArefs2Rdf3(aTree,oDep,0,urn,columns,"",,typeNode)
	    ? '</RDF:RDF>'
	elseif  typeNode == 'rdf'
	    cgi_putArefs2Rdf3(aTree,oDep,0,urn,columns,"",,typeNode)
	    ? '</RDF:RDF>'
	else
	    cgi_putArefs2Rdf3(aTree,oDep,0,urn,columns,"",,typeNode)
	    ? '</root>'
	endif


?
return
