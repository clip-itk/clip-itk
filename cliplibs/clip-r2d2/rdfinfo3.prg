#include "r2d2lib.ch"

function r2d2_rdfinfo3(_queryArr, typeNode)

local err,_query
local i,j,u,obj,idlist,sErr
local aRefs, aTree :={}, needDeleted := .f.
local connect_id:="", connect_data
local lang:="", sDict:="", sDep:=""
local oDict,oDep, tmp,tmp1,tmp2, classDesc, s_select:=""
local columns,col, id:="", owner_map:=map(),map2:=map(),aData, sId
local urn, sprname:="", values := "", attr := "", atom:="",iftree:=.f.
local aTree2:={}
local s_obj

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
/*
	if "IFTREE" $ _query
		iftree := _query:iftree
	endif
*/

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
	if typeNode == 'rdf3'
    	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	    ? 'xmlns:D="http://itk.ru/D#" '
	    ? 'xmlns:R="http://itk.ru/R#" '
	    ? 'xmlns:S="http://itk.ru/S#">'
	    ?
	elseif typeNode == 'rdf'
	  ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'                                                 
          ? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'         
	else
	  ? '<root xmlns="http://itk.ru/json#">'         
	endif

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

		aTree := cgi_aRefs2(oDep,classDesc,columns,_query,,@Serr,.f.,.t.,.f.,needDeleted)
		if !empty(serr)
			cgi_xml_error("Error in parameters:"+Serr)
		endif
	endif

//*---------------------------------------------------
	
	if aTree == NIL
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
	    else 
		iDlist:=oDep:select(classDesc:id,,,s_select,,needDeleted)
	    endif
	endif    

	if len(idList)>0
	    obj := oDep:getValue(idList[1])
	    aTree := {}
	    if "OWNER_ID" $ obj
	        iftree:=.t.
	        j:=1
	        for i=1 to len(idList)
		    obj := oDep:getValue(idList[i])
		    if empty(obj)
		        loop
		    endif
		    if needDeleted .and. obj:__version >=0
		        loop
		    endif
		    tmp1 := obj:owner_id
		    j := ascan(aTree,{|x|x[1]==tmp1})
		    if j<=0
		        aadd(aTree,{tmp1, {}})
		        j := len(aTree)
		    endif
		    aadd(aTree[j][2], obj)
		next
	    else    
		aadd(aTree,{'',{}})
		for i=1 to len(idList)
		    obj := oDep:getValue(idList[i])
		    if empty(obj)
		        loop
		    endif
		    if needDeleted .and. obj:__version >=0
		        loop
		    endif
		    aadd(aTree[1][2], obj)
		next
	    endif
	endif
	
	
	if empty(urn)
		urn := 'urn:'+sprname
	endif
	if typeNode == 'rdf3'
	    cgi_putArefs2Rdf3(aTree,oDep,0,urn,columns,"",,typeNode)
	    ? '</RDF:RDF>'
	elseif	typeNode == 'rdf'
	    cgi_putArefs2Rdf3(aTree,oDep,0,urn,columns,"",,typeNode)
	    ? '</RDF:RDF>'
	else
	    cgi_putArefs2Rdf3(aTree,oDep,0,urn,columns,"",,typeNode)
	    ? '</root>'
	endif
	
?
return
