#include "r2d2lib.ch"

function r2d2_bind2_rdf(_queryArr)

local i,j,k,obj,idlist,err,rname,dict
local aTree:={},aList1:={},aList2:={},aList3:={}
local aRefs:={}
local width1:="300", width2:="30"
local _query, idOverlay := ""
local lang:="", sDict:="", sDep:=""
local oDict,oDep, tmp,tmp1,tmp2, classDesc, l_select:=.f.
local columns,columns2,col, id:="",urn
local find_wrap:=map(), children
local connect_id,connect_data

public sprname:="", type:="", Serr:=""
public beg_date:=date(),end_date:=date()
public path_obj
public bind_type:="span", bind_id:=""

errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "SPR" $ _query
		sprname := _query:spr
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
	sprname := lower(sprname)
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
			?? "LANG not defined "
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

	oDep := codb_needDepository(sDict+sDep)
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
		cgi_xml_error("Empty table description for "+sprname)
		return
	endif

	if sprname == "os_balance"
		aRefs := osb_aRefs(oDep,classDesc,columns,_query,find_wrap,@Serr,.t.)
	elseif empty(id)
		aRefs := cgi_aRefs(oDep,classDesc,columns,_query,find_wrap,@Serr,.t.,.f.)
	else
		if empty(path_obj)
			aRefs := {}
			aadd(aRefs,{id,"","",codb_getValue(id)})
		else
			aRefs := parse_path_obj(oDep,path_obj,id)
		endif
	endif
	if !empty(serr)
		cgi_xml_error("Error in parameters:"+sErr)
		return
	endif

	//asort(aRefs,,,{|x,y| x[3] <= y[3] })
	cgi_fillTreeRdf(aRefs,aTree,"",1)
	if !empty(aRefs) .and. empty(aTree)
		for i=1 to len(aRefs)
			aRefs[i][2] := ""
		next
		cgi_fillTreeRdf(aRefs,aTree,"",1)
	endif

	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	//? 'xmlns:docum="http://last/cbt_new/rdf#">'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	?

	if empty(urn)
		urn := sprname
	endif
	cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns2,"")
	?
	cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns2,"")
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
	obj := codb_getValue(id)
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
		obj := codb_getValue(id)
	next
	aadd(aRefs,{id,"",{},codb_getValue(id)})
return aRefs
/************************************************/
static function osb_aRefs(oDep,classDesc,columns,_query,find_wrap,Serr,includeAll)
	local aRefs := {}
	local i,m:={},data,account
	if "ACCOUNT" $ _query
		account := codb_getvalue(_query:account)
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
/************************************************/
static function putArefsToBind(aRefs,oDep,level,_queryArr,columns)
	local s:=replicate("   ",level+1),col
	local obj,i,j,k,oOut
	if level==0 //len(arefs)==1
		obj:=aRefs[1][4]
		for j=1 to len(columns)
			col := columns[j]
			oOut := cgi_objDesc(obj,col)
			? s+'<binding id="'+col:name+'"> <content>'
			if m->bind_type=="span"
				?? '<span>'
				?? oOut:label
				?? '</span>'
			else
				? '<xul:menuitem id="'+obj:id+'" label="'+oOut:label+'" />'
			endif
			?? '</content></binding>'
		next
		return
	endif
	if empty(m->bind_id)
		? '<binding id="'+m->sprname+'">'
	else
		? '<binding id="'+m->bind_id+'">'
	endif
	? '<content>'
	for i=1 to len(Arefs)
		obj:=aRefs[i][4]
		if m->bind_type == "span"
			? s+'<'+m->sprname+' id="'+obj:id+'">'
			for j=1 to len(columns)
				col := columns[j]
				? s+s+'<'+col:name+'>'
				oOut := cgi_objDesc(obj,col)
				?? oOut:label
				?? s+'</'+col:name+'>'
			next
			? s+'</'+m->sprname+'>'
		else
			//oOut := cgi_objDesc(obj,columns[1])
			? '<xul:menuitem id="'+obj:id+'" label="'+codb_essence(obj)+'" />'
		endif
	next
	? '</content>'
	? '</binding>'

return
