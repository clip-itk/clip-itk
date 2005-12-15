#include "r2d2lib.ch"

static m_objs:=map(), m_class:={}, m_refs:=map()
static sprID:=""

function r2d2_printobj_xml(_queryArr)

local err,_query
local lang:="",sDep:="",sDict,obj_id:="",id_list:={}
local i,j,k,sTmp,obj,classDesc
local sprName,sErr, s_obj
local columns,oDep,oDict


	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "ID" $ _query
		obj_id := _query:id
	endif
	if "LANG" $ _query
		lang := _query:lang
	endif
	if "SPR" $ _query
		sprname := _query:spr
	endif
	lang := cgi_choice_lang(lang)
	sDep := cgi_choice_sDep(lang)
	sprname := lower(sprname)
	sDict:= cgi_choice_sDict(@sprname)

	if empty(obj_id) .or. empty(sprname)
	else
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		?? "ID or SPR not defined "
		? "Usage:"
		? "    print?id=<obj_id>;spr=<classname>"
		?
		return
	endif

	cgi_xml_header()

	if "," $ obj_id
		id_list:=split(obj_id,",")
	elseif !empty(obj_id)
		id_list := {obj_id}
	endif
	if empty(id_list) .and. !empty(sprname)
		oDep := codb_needDepository(sDict+"01")
		if empty(oDep)
			cgi_xml_error( "Depository not found: "+sDict+"01" )
			return
		endif
		oDict := oDep:dictionary()
		classDesc:=oDict:classBodyByName(sprname)
		if empty(classDesc)
			cgi_xml_error("Class definition not found for:"+sprname)
			return
		endif
		sprID := classDesc:id

		columns := cgi_make_columns(oDict,sprname)

		if empty(columns)
			cgi_xml_error("Empty table description for "+sprname)
			return
		endif
		s_obj := cgi_make_select_string(columns,_query,'',@Serr)
		if !empty(sErr)
			cgi_xml_error(sErr)
			return
		endif
		if !empty(s_obj:expr)
			set exact off
			id_list:=oDep:select(classDesc:id,,,s_obj:expr)
			set exact on
		endif
		sprID := ""
	endif

	calc_objs(id_list)

	sTmp := varToString( id_list,,, .f.)
	sTmp := substr(stmp,2,len(sTmp)-2)
	sTmp:=strtran(sTmp,'"',"")
	//? '<body>'
	//?
	//? '<print id="'+sTmp+'">'
	? '<print id="'+sTmp+'">'

	for i=1 to len(m_class)
		print_table(m_class[i][1],m_class[i][2])
	next
	//? '</print>'
	?

	sDep:="ACC00"
	oDep := codb_needDepository(sDep+"01")
	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDep+"01" )
		return
	endif
	oDict := oDep:dictionary()
	sprname:="myfirm_constant"
	classDesc:=oDict:classBodyByName(sprname)
	if empty(classDesc)
		cgi_xml_error("Class definition not found for:"+sprname)
		return
	endif
	//sprID := classDesc:id

	columns := cgi_make_columns(oDict,sprname)

	if empty(columns)
		cgi_xml_error("Empty table description for "+sprname)
		return
	endif

	id_list:=oDep:select(classDesc:id)

	m_class := {}
	calc_objs(id_list)
	//? '<print id="myfirm_constant">'
	for i=1 to len(m_class)
		print_table(m_class[i][1],m_class[i][2])
	next
	? '</print>'



/********************************************/
static function print_table(class_id,_id_list)
	local i,j,k,x,id_list, s:=space(4)
	local obj_id,obj,attr,classDesc,columns
	local idDict,oDict

	id_list:=aclone(_id_list)
	/**/
	classDesc := codb_getValue(class_id)
	if empty(classDesc)
		outlog("Object not readable:",obj:class_id)
		return
	endif
	idDict := substr(class_id,1,codb_info("DICT_ID_LEN"))
	oDict:=codb_dict_reference(idDict)
	if empty(oDict)
		outlog("Dictionary not found for class_id:",class_id)
		return
	endif

	columns := cgi_make_columns(oDict,classDesc:name)
	print_tableHeader(classDesc,columns)

	for i=1 to len(id_list)
	    obj_id := id_list[i]
	    if !(obj_id $ m_objs)
		loop
	    endif
	    obj := m_objs[obj_id]
	    print_obj(obj,columns)
	    //? i,obj_id, obj

	    /* delete from full list */
	    j := ascan(m_class,{|x|x[1] == obj:class_id})
	    if j<=0
		loop
	    endif
	    k := ascan(m_class[j][2],{|x|x == obj:id})
	    if k<=0
		loop
	    endif
	    adel(m_class[j][2],k)
	    asize(m_class[j][2],len(m_class[j][2])-1)
	next

	k := atl(".",classDesc:name)
	s:=classDesc:name
	if k>0
		s := left(classDesc:name,k-1)
	endif
	? '</'+s+'>'
	//? '</table>'
	?
return
/********************************************/
static function print_obj(obj,columns)
	local i,j,col,k,obj2,sTmp,id_ref, s:=space(4), midref:=""
	//? s+'<tr name="object" id="'+obj:id+'">'
	? s+'<object id="'+obj:id+'" '
	if "VALUE" $ obj
		?? 'value="'+obj:value+'"'
	endif
	?? '>'
	for i=1 to len(columns)
		midref:=""
		id_ref := ""
		col:=columns[i]
		//? s+'<td name="'+col:name+'"'
		? space(4)+s+'<'+col:name+' '
		sTmp := mapEval(obj,col:block)
		if "DATATYPE" $ col .and. col:datatype == "R"
			id_ref := obj[upper(col:name)]
			sTmp  := codb_essence(sTmp)
			sTmp := strtran(sTmp,'&',"&amp;")
			sTmp := strtran(sTmp,'"',"&quot;")
			sTmp := strtran(sTmp,"'","&apos;")
			sTmp := strtran(sTmp,'<',"&lt;")
			sTmp := strtran(sTmp,'>',"&gt;")
			midref:= 'idref="'+id_ref+'"'
		elseif "DATATYPE" $ col .and. col:datatype=="S"
			//id_ref := obj[upper(col:name)]
			obj2:=codb_getValue(sTmp)
			if !empty(obj2)
				k:= codb_tColumnBody(obj2:id)
				if !empty(k)
					sTmp := k:header //+':'+obj2:name
					//id_ref := obj2:name
					midref:= 'idref="'+obj2:name+'"'
				else
					sTmp := obj2:name+":"+obj2:id
				endif
			endif
		elseif valtype(sTmp) == "C"
			sTmp := strtran(sTmp,'&',"&amp;")
			sTmp := strtran(sTmp,'<',"&lt;")
			sTmp := strtran(sTmp,'>',"&gt;")
		elseif valtype(sTmp) == "L"
			sTmp:= iif(sTmp,"true","false")
		elseif valtype(sTmp) == "A"
			sTmp := alltrim(varToString( stmp,,, .f.))
			sTmp := substr(stmp,2,len(sTmp)-2)
			sTmp := strtran(sTmp,'"',"")
			sTmp := strtran(sTmp,','," ")
			midref:= 'idrefs="'+sTmp+'"'
			//id_ref := sTmp
			sTmp:=""
		else
			sTmp := toString(sTmp)
		endif

		//midref := iif(valtype(sTmp) == "A", 'idrefs', 'idref')
		//?? midref+'="'+id_ref+'">'+alltrim(sTmp)+'</'+col:name+'>'
		?? midref+'>'+alltrim(sTmp)+'</'+col:name+'>'

	next
	? s+'</object>'
return

/************************************************/
static function print_tableHeader(classDesc,columns)
	local i,j,col,k, s:=space(4)
	/* put table header */
	k := atl(".",classDesc:name)
	s:=classDesc:name
	if k>0
		s := left(classDesc:name,k-1)
	endif
	//? '<table id="'+classDesc:id+'" name="'+s+'">'
	? '<'+s+' id="'+classDesc:id+'" name="'+s+'">'
	s:=space(4)
	? s+'<headers>'
	for i=1 to len(columns)
		col:=columns[i]
		? s+'<col name="'+col:name+'"'
		if "ATTR_ID" $ col
			?? ' id="'+col:attr_id+'"'
		endif
		if "DATATYPE" $ col
			?? ' type="'+col:datatype+'"'
		endif
		if "REFS" $ col .and. !empty(col:refs)
			k:=""
			for j=1 to len(col:refs)
			    k+=col:refs[j]+","
			next
			k := left(k,len(k)-1)
			?? ' dataRefTo="'+k+'"'
		else
			if "DATAREFTO" $ col
				?? ' dataRefTo="'+col:dataRefTo+'"'
			endif
			if "DATALEN" $ col
			 //	?? ' datalen="'+col:datalen+'"'
			endif

		endif
		?? '>'+col:header+'</col>'
	next
	? s+'</headers>'
return
/********************************************/
static function calc_objs(id_list)
	local i,j,k,m:={},x,obj,attr,classDesc
	local s1,s2

	for i=1 to len(id_list)
		if empty(id_list[i])
			loop
		endif
		if id_list[i] $ m_objs
			loop
		endif
		obj := codb_getValue(id_list[i])

		if empty(obj)
			outlog("Object not readable:",id_list[i])
			loop
		endif
		if !("CLASS_ID" $ obj) .or. obj:class_id == sprID
			loop
		endif
		classDesc := codb_getValue(obj:class_id)
		if empty(classDesc)
			outlog("Object not readable:",obj:class_id)
			loop
		endif
		if len(id_list) == 1 .and. empty(sprID)
			sprId := classDesc:id
		endif
		m_objs[obj:id] := obj
		j := ascan(m_class,{|x|x[1] == obj:class_id})
		if j<=0
			aadd(m_class,{obj:class_id,{}})
			j := len(m_class)
		endif
		aadd(m_class[j][2],obj:id)

		/* references and objs */
		for j=1 to len(classDesc:attr_list)
			attr := codb_getValue(classDesc:attr_list[j])
			if empty(attr)
				outlog("Object not readable:",classDesc:attr_list[j])
				loop
			endif
			if !empty(attr:ref_to)
				s1:=classDesc:id+attr:ref_to
				s2:=attr:ref_to+classDesc:id
				//? obj:id,s1,s2,s1 $ m_refs,s2 $ m_refs
				if ! (s1 $ m_refs)
					m_refs[s1] := s1
				endif
				if s2 $ m_refs
					loop
				endif
			endif

			if attr:ref_to == sprID
				loop
			endif
			//? obj:id, obj[upper(attr:name)],classDesc:name,attr:name,attr:ref_to,sprID,attr:ref_to == sprID
			if attr:type=="R"
				aadd(m, obj[upper(attr:name)])
				loop
			endif
			if attr:type=="A"
				calc_array(obj[upper(attr:name)],m)
			endif
		next
	next
	if !empty(m)
		calc_objs(m)
	endif
return
/********************************************/
static function calc_array(ar,m)
	local i
	for i=1 to len(ar)
		if valtype(ar[i]) == "C"
			aadd(m,ar[i])
			loop
		endif
		if valtype(ar[i]) == "A"
			calc_array(ar[i],m)
		endif
	next
return


