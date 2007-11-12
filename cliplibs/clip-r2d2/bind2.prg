#include "r2d2lib.ch"

function r2d2_bind(_queryArr, VIA_XML)

local i,j,k,obj,idlist,err,rname,dict
local aTree:={},aList1:={},aList2:={},aList3:={}
local aRefs:={}
local width1:="300", width2:="30"
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

	if "CLASS_NAME" $ _query
		sprname := _query:class_name
	endif
	if "TYPE" $ _query
		type := _query:type
	endif
	if "LANG" $ _query
		lang := _query:lang
	endif
	if "ID" $ _query
		id := _query:id
	endif
	if "BIND_ID" $ _query
		m->bind_id := _query:bind_id
	endif
	if "BIND_TYPE" $ _query
		m->bind_type := lower(_query:bind_type)
	endif

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif

	if "BEG_DATE" $ _query
		beg_date := ctod(_query:beg_date,"dd.mm.yyyy")
	endif
	if "END_DATE" $ _query
		end_date := ctod(_query:end_date,"dd.mm.yyyy")
	endif
	if "PATH" $ _query
		path_obj := _query:path
	endif
	lang := cgi_choice_lang(lang)
	sDep := cgi_choice_sDep(lang)
	//sprname := lower(sprname)
	sDict:= cgi_choice_sDict(@sprname)
	if !empty(id)
		sDict := left(id,codb_info("DICT_ID_LEN"))
		sDep  := substr(id,codb_info("DICT_ID_LEN")+1,codb_info("DEPOSIT_ID_LEN"))
	endif

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
//		cgi_xml_error( "Depository not found: "+sDict+sDep )
		return
	endif
	oDict := oDep:dictionary()
	classDesc:=oDict:classBodyByName(sprname)
	if empty(classDesc)
//		cgi_xml_error("Class definition not found for:"+sprname)
		?
		return
	endif

	columns := cgi_make_columns(oDict,sprname)
	columns2 := cgi_make_columns(oDict,sprname,2)
	for i=1 to 9
		col := "FIND"+str(i,1,0)
		if col $ _query
			find_wrap[col] := _query[col]
		endif
	next
	col := "FIND"
	if col $ _query
		find_wrap[col] := _query[col]
	endif

	if empty(columns)
//		cgi_xml_error("Empty table description for "+sprname)
		return
	endif
	oDepList := {}
	aadd(oDepList,oDep)
	if bind_type=="all" .and. empty(id)
		tmp := oDict:select("DEPOSIT")
		for j=1 to len(tmp)
			obj := oDict:getValue(tmp[j])
			if empty(obj)
				loop
			endif
			if oDep:id == sDict + obj:number
				loop
			endif
			tmp2 := cgi_needDepository(sDict+obj:number,"")
			if empty(tmp2)
				loop
			endif
			aadd(oDepList,tmp2)
		next
	endif

	aRefs := {}
	//outlog(__FILE__,__LINE__,len(oDepLIst))
	for j=1 to len(oDepList)
		oDep := oDepList[j]
		if sprname == "os_balance"
			tmp := osb_aRefs(oDep,classDesc,columns,_query,find_wrap,@Serr,.t.)
			for i=1 to len(tmp)
				aadd(aRefs,tmp[i])
			next
		elseif empty(id)
			tmp := cgi_aRefs(oDep,classDesc,columns,_query,find_wrap,@Serr,.t.,.f.,.t.)
			for i=1 to len(tmp)
				aadd(aRefs,tmp[i])
			next
		else
			if empty(path_obj)
				aadd(aRefs,{id,"","",cgi_getValue(id)})
			else
				tmp := parse_path_obj(oDep,path_obj,id)
				for i=1 to len(tmp)
					aadd(aRefs,tmp[i])
				next
			endif
			exit
		endif
		if !empty(serr)
			cgi_xml_error("Error in parameters:"+sErr)
			return
		endif
	next

	//asort(aRefs,,,{|x,y| x[3] <= y[3] })
	if valtype(aRefs) != "A"
		aRefs := {}
	endif
	tmp := oDict:padrBody(map(),classDesc:id,.t.)
	for i in tmp keys
		if valtype(tmp[i]) == "C"
			tmp[i] := replicate("Ñ",len(tmp[i]))
		endif
	next
	tmp:id := ""
	//aadd(aRefs,{tmp:id,"","",tmp})
	for i=1 to len(aRefs)
		arefs[i][2] := ""   // owner_id
	next
	cgi_fillTreeRdf(aRefs,aTree,"",1)
	if !empty(aRefs) .and. empty(aTree)
		for i=1 to len(aRefs)
			aRefs[i][2] := ""
		next
		cgi_fillTreeRdf(aRefs,aTree,"",1)
	endif

	if empty(urn)
		urn := 'urn:'+sprname
	endif

	via_xml := iif (valtype(via_xml)=="L", via_xml, .f. )

	if VIA_XML
		cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns2,"")
		?
		cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns2,"")
	else
		cgi_putArefs2Rdf(aTree,oDep,0,urn,columns2,"")
	endif

	? '</RDF:RDF>'
?
return
/************************************************/
static function parse_path_obj(oDep,path_obj,id)
	local aRefs := {}
	local paths,i,obj
	if left(path_obj,1)=="{"
		path_obj := substr(path_obj,2)
	endif
	if right(path_obj,1)=="}"
		path_obj := left(path_obj,len(path_obj)-1)
	endif
	paths := split(path_obj,",")
	obj := cgi_getValue(id)
	for i=1 to len(paths)
		if empty(paths[i])
			loop
		endif
		if empty(obj)
			exit
		endif
		if !(upper(paths[i]) $ obj)
			loop
		endif
		id := obj[ upper(paths[i]) ]
		obj := cgi_getValue(id)
	next
	aadd(aRefs,{id,"",{},cgi_getValue(id)})
return aRefs
/************************************************/
static function osb_aRefs(oDep,classDesc,columns,_query,find_wrap,Serr,includeAll)
	local aRefs := {}
	local i,m:={},data,account
	if "ACCOUNT" $ _query
		account := cgi_getValue(_query:account)
	endif
	if empty(account) .or. !("AN_VALUE1" $ account)
		Serr := "Error: account not found !"
		return aRefs
	endif

	data := r2d2_get_osb_data(oDep,classDesc:id,account,m->beg_date,m->end_date)
	aadd(aRefs,{account:id,"",{},data})
	for i=1 to len(columns)
		if upper(columns[i]:name) $ data
			loop
		endif
		aadd(m,i)
	next
	for i=len(m) to 1 step -1
		adel(columns,m[i])
	next
	asize(columns,len(columns)-len(m))
return aRefs
