#include "r2d2lib.ch"

function r2d2_info_rdf(_queryArr)

local err,_query
local i,j,obj,idlist,sErr
local aRefs, aTree :={}
local lang:="", sDict:="", sDep:=""
local oDict,oDep, tmp,tmp1,tmp2, classDesc, s_select:=""
local columns,col, id:="", owner_map:=map(),map2:=map(),aData, sId
local urn, sprname:=""

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
	if "URN" $ _query
		URN := _query:URN
	endif

	lang := cgi_choice_lang(lang)
	sDep := cgi_choice_sDep(lang)
	sprname := lower(sprname)
	sDict:= cgi_choice_sDict(@sprname)

	if empty(sprname) .or. empty(sDep) .or. empty(sDict)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		if empty (sdep)
			?? "LANG not defined "
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

	oDep := codb_needDepository(sDict+sDep)
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
	columns := cgi_make_columns(oDict,sprname)

	if empty(columns)
		cgi_xml_error("Empty table description for "+sprname)
		return
	endif

	if empty(id)
		aRefs := cgi_aRefs(oDep,classDesc,columns,_query,,@Serr,.f.,.t.)
		if !empty(serr)
			cgi_xml_error("Error in parameters:"+Serr)
		endif
	endif

	if aRefs == NIL
		aRefs := {}
		if !empty(id)
			idList := split(id,"[,]")
		else
			iDlist:=oDep:select(classDesc:id,,,s_select)
		endif

		for i=1 to len(idList)
			obj := oDep:getValue(idList[i])
			if "OWNER_ID" $ obj
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
		aadd(aRefs,{i:id,"",.f.,i})
	endif

	//asort(aRefs,,,{|x,y| x[3] <= y[3] })
	cgi_checkTreeArefs(arefs,oDep)
	cgi_fillTreeRdf(aRefs,aTree,"",1)

	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	//? 'xmlns:docum="http://last/cbt_new/rdf#">'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	?

	if empty(urn)
		urn := sprname
	endif
	cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns,"")
	?
	cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns,"")
	? '</RDF:RDF>'
?
return
