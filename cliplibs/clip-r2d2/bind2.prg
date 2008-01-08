#include "r2d2lib.ch"

function r2d2_bind(_queryArr, typeNode)

local i,j,k,obj,idlist,err,rname,dict
local aTree:={},aList1:={},aList2:={},aList3:={}
local aRefs:={}
local _query, idOverlay := ""
local lang:="", sDict:="", sDep:=""
local oDict,oDep,oDepList, tmp,tmp1,tmp2, classDesc, l_select:=.f.
local columns,columns2,col, id:="",urn
local find_wrap:=map(), children
local connect_id,connect_data

public sprname:="", type:="", Serr:=""
public beg_date:=date(),end_date:=date()
public path_obj
public bind_type:="", bind_id:=""

errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "SPR" $ _query
		sprname := _query:spr
	endif
	if "URN" $ _query
		urn := _query:urn
	endif

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif

	lang := cgi_choice_lang(lang)
	sDep := cgi_choice_sDep(lang)
	sDict:= cgi_choice_sDict(@sprname)

	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif

	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
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
		? "    bind2?spr=<spr_name>& find1=data& find2=data&...."
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

	oDep := cgi_needDepository(sDict,sDep)

	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDict+sDep )
		return
	endif
	oDict := oDep:dictionary()
	classDesc:=oDict:classBodyByName(sprname)
	if empty(classDesc)
		cgi_xml_error("Class definition not found for:"+sprname)
		?
		return
	endif

	columns := cgi_make_columns(oDict,sprname)

	col := "FIND"

	if col $ _query
		find_wrap[col] := _query[col]
		//?_query[col] 44
	endif

	if empty(columns)
		cgi_xml_error("Empty table description for "+sprname)
		return
	endif


	aTree := cgi_aRefs(oDep,classDesc,columns,_query,find_wrap,@Serr,.t.,.f.,.t.)
	//aTree := cgi_aRefs2(oDep,classDesc,columns,_query,find_wrap,@Serr,.f.,.t.,.f.,.t.)

	if !empty(serr)
		cgi_xml_error("Error in parameters:"+sErr)
		return
	endif



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
