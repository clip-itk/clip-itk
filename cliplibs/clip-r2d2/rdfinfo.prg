#include "r2d2lib.ch"

function r2d2_info_rdf(_queryArr)

local err,_query
local i,j,obj,idlist,sErr
local aRefs, aTree :={}, needDeleted := .f.
local connect_id:="", connect_data
local lang:="", sDict:="", sDep:=""
local oDict,oDep, tmp,tmp1,tmp2, classDesc, s_select:=""
local columns,col, id:="", owner_map:=map(),map2:=map(),aData, sId
local urn, sprname:="", values := "", attr := "", atom:="", iftree

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
	if "URN" $ _query
		URN := _query:URN
	endif
	if "ATTR" $ _query
		attr := _query:attr
	endif
	if "VALUES" $ _query
		values := _query:values
	endif
	if !empty(values)
		values := split(values,"[,]")
	endif
	if "ATOM" $ _query
		atom := upper(_query:atom)
	endif
	atom := (left(atom,1) == "Y")
	if "__DELETED" $ _query
		needDeleted := (left(_query:__deleted,1) $ "YyäÄ")
	endif
	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif

	if "IFTREE" $ _query
		iftree := _query:iftree
	endif


    /*
	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
	endif
    */


       if "ACC01" $ _query .and. !empty(_query:acc01)
	   set("ACC01",_query:acc01)
       endif
       if "ACC00" $ _query .and. !empty(_query:acc00)
	   set("ACC00",_query:acc00)
       endif

	lang := cgi_choice_lang(lang)
	sDep := cgi_choice_sDep(lang,sDict)
	//sprname := lower(sprname)
	sDict:= cgi_choice_sDict(@sprname)
	if !empty(id)
		sDict := left(id,codb_info("DICT_ID_LEN"))
		sDep  := substr(id,codb_info("DICT_ID_LEN")+1,codb_info("DEPOSIT_ID_LEN"))
	endif

	if empty(sprname) .or. empty(sDep) .or. empty(sDict)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		if empty (sdep)
			?? "Depository not defined "
		endif
		if empty (sdict)
			?? "DICTIONARY not defined "
		endif
		? "Usage:"
		? "    rdfinfo?spr=<spr_name>"
		?
		return
	endif

	cgi_xml_header()
	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	//? 'xmlns:docum="http://last/cbt_new/rdf#">'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	?

	if empty(id)
		oDep := cgi_needDepository(sDict,sDep)
	else
		oDep := codb_needDepository(sDict+sDep)
	endif
	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDict+sDep )
		return
	endif
	oDict := oDep:dictionary()
	classDesc:=oDict:classBodyByName(sprname)
	if empty(classDesc)
		cgi_xml_error("Class definition not found for:"+sprname)
		return
	endif
	if lower(sprname) == "accpost"
		columns := cgi_accpost_columns(oDict)
	else
		columns := cgi_make_columns(oDict,sprname) //,,atom)
	endif

	if empty(columns)
		cgi_xml_error("Empty table description for "+sprname)
		return
	endif

	if empty(id) .and. empty(values)
		aRefs := cgi_aRefs(oDep,classDesc,columns,_query,,@Serr,.f.,.t.,,needDeleted)
		if !empty(serr)
			cgi_xml_error("Error in parameters:"+Serr)
		endif
	endif

	if aRefs == NIL
		aRefs := {}
		idList := {}
		if !empty(id)
			idList := split(id,"[,]")
		elseif !empty(values) .and. !empty(attr)
			for i=1 to len(values)
				s_select := attr+'=="'+values[i]+'"'
				tmp:=oDep:select(classDesc:id,,,s_select,,needDeleted)
				for j=1 to len(tmp)
					aadd(idList,tmp[j])
				next
			next
		else // if !empty(s_select)
			iDlist:=oDep:select(classDesc:id,,,s_select,,needDeleted)
		endif

		for i=1 to len(idList)
			obj := oDep:getValue(idList[i])
			if empty(obj)
				loop
			endif
			if needDeleted .and. obj:__version >=0
				loop
			endif
			if "OWNER_ID" $ obj .and. empty(iftree)
				aadd(aRefs,{obj:id,obj:owner_id,.f.,obj})
			elseif !empty(obj)
				aadd(aRefs,{obj:id,"",.f.,obj})
			endif
		next
	endif

	if empty(arefs)
		i := map()
		i:id := "_template_obj_"
		oDep:checkBody(i,classDesc:id)
		//aadd(aRefs,{i:id,"",.f.,i})
	endif

	//asort(aRefs,,,{|x,y| x[3] <= y[3] })
	cgi_checkTreeArefs(arefs,oDep)

	if atom .and. "UNIQUE_KEY" $ classDesc .and. !empty(classDesc:unique_key)
		j:= classDesc:unique_key
		for i=1 to len(aRefs)
			obj := arefs[i][4]
			obj:id := mapEval(obj,j)
		next
	endif

	cgi_fillTreeRdf(aRefs,aTree,"",1)

	if empty(urn)
		urn := 'urn:'+sprname
	endif
	cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns,"",,atom)
	?
	cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns,"",,atom)
	? '</RDF:RDF>'
?
return
