#include "r2d2lib.ch"

function r2d2_array2rdf(_queryArr, isRDF)

local err,_query
local aRefs, aTree :={}
local lang:="", sDict:="", sDep:=""
local oDict,oDep, tmp,tmp1,tmp2, classDesc, s_select:=""
local columns,col, id:="",attr:="", owner_map:=map(),map2:=map(),aData, sId
local i,j,obj,idlist,_idList
local urn, sprname:=""

	isRDF := iif( valType(isRDF)=="L", isRDF, ".t.")

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

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

	lang := cgi_choice_lang(lang)

	if empty(id) .or. empty(attr)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		? "Usage:"
		? "    rdfarr?id=<object_id>&attr=<attr_name>"
		?
		return
	endif

	cgi_xml_header()
	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	//? 'xmlns:docum="http://last/cbt_new/rdf#">'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	?

	sDep := left(id,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	oDep := codb_needDepository(sDep)
	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDep )
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

	aRefs := {}
	for i=1 to len(idList)
		obj := cgi_getValue(idList[i])
		if "OWNER_ID" $ obj
			aadd(aRefs,{obj:id,obj:owner_id,.f.,obj})
		elseif !empty(obj)
			aadd(aRefs,{obj:id,"",.f.,obj})
		endif
	next

	if empty(arefs) .and. !empty(classDesc)
		i := map()
		i:id := "_template_obj_"
		oDep:checkBody(i,classDesc:id)
		aadd(aRefs,{i:id,"",.f.,i})
	endif

	//asort(aRefs,,,{|x,y| x[3] <= y[3] })
	cgi_checkTreeArefs(arefs,oDep)
	cgi_fillTreeRdf(aRefs,aTree,"",1)


	if empty(urn)
		urn := 'urn:'+sprname
	endif

	if isRDF
		cgi_putArefs2Rdf(aTree,oDep,0,urn,columns,"")
	//cgi_putArefs2RdfLevels(aTree,oDep,0,urn,columns,"",,atom)
	else
		cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns,"")
		?
		cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns,"")
	endif
	? '</RDF:RDF>'
?
return
