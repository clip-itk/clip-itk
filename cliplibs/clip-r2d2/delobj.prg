#include "r2d2lib.ch"

function r2d2_delobj_xml(_queryArr)

local _query
local lang:="",sDep:="",obj_id:="",objs_id:={}
local oDep,oDict,obj, classDesc, attr_list,attr
local i,j,k,x,tcol,rname,ind_list

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "ID" $ _query
		obj_id := _query:id
	endif
	if "LANG" $ _query
		lang := _query:lang
	endif

	if empty(obj_id)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		?? "ID not defined "
		? "Usage:"
		? "    delobj?id=<obj_id>"
		?
		return
	endif


	cgi_xml_header()
	sDep := substr(obj_id,1,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	oDep := codb_needDepository(sDep)
	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDep )
		return
	endif
	oDict := oDep:dictionary()

	if "," $ obj_id
		objs_id := split(obj_id,"[,]")
	else
		aadd(objs_id,obj_id)
	endif
	? ' <window name="object_body"'
	? 'xmlns:html="http://www.w3.org/1999/xhtml"'
	? 'xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul">'


	for x=1 to len(objs_id)
		obj_id := objs_id[x]
		obj:=oDep:getValue(obj_id)

		if empty(obj)
			cgi_xml_error("Object not found for:"+obj_id)
			?
			loop
		endif
		classDesc := oDict:getValue(obj:class_id)

		if empty(classDesc)
			cgi_xml_error("Class definition not found for:"+obj:class_id)
			?
			loop
		endif

		if classDesc:name == "accpost"
			oDep:error := r2d2_mt_oper("delete_accpost",oDep,obj)
		else
			oDep:delete(obj_id)
		endif

		if !empty(oDep:error)
			cgi_xml_error("Error deleting object:"+oDep:error)
			?
			loop
		endif


		? '<vbox id="'+obj_id+'" class="'+classDesc:name+'">'
		ind_list:={}
		for i=1 to len(classDesc:idx_list)
			j:=oDict:getValue(classDesc:idx_list[i])
			if empty(j)
				loop
			endif
			aadd(ind_list,j)
		next

		//? obj
		for i=1 to len(classDesc:attr_list)
			attr:=oDict:getValue(classDesc:attr_list[i])
			if empty(attr)
				loop
			endif
			tcol := NIL
			k:=oDict:select("TCOLUMN",,attr:name)
			if !empty(k)
				tcol := oDict:getValue(k[1])
			endif
			if !empty(tcol)
				rname := tcol:header
			else
				rname := attr:name
			endif
			? '    <hbox>'
			? '       <label'
			?? ' value="'+rname+'"'
			?? ' control="'+attr:name+'"'
			?? ' datalen="'+alltrim(str(attr:len))+'"'
			?? ' datatype="'+attr:type+'"'
			?? ' datamask="'+attr:mask+'"'
			k := ascan(ind_list,{|j|j:expr == attr:name })
			?? ' dataisindex="'+iif(k!=0,"true","false")+'"'
			?? ' defvalue="'+attr:defvalue+'"'
			?? ' dataRefTo="'+attr:ref_to+'"/>'

			k:=alltrim(upper(attr:name))
			if attr:type $ "CNDL"
				j:=""
				do switch (attr:type)
					case "C"
						j:=obj[k]
					case "N"
						j:=alltrim(str(obj[k]))
					case "D"
						j:=dtoc(obj[k])
					case "L"
						j:=iif(obj[k],"true","false")
				endswitch
				? '       <textbox '
				?? ' id="'+attr:name+'"'
				?? ' value="'+j+'"'
				?? ' hidden="false"/>'
			endif
			if attr:type == "M"
				? '       <textbox id="'+attr:name+'" hidden="true">'
				? '       <html:div> <![CDATA[ "'+obj[k]+'" ]]> </html:div>'
				? '       </textbox>'
			endif
			if attr:type == "R"
				? '       <textbox id="'+attr:name+'"'
				?? ' value="'+obj[k]+'" hidden="false"/>'
			endif
			if attr:type == "A"
				j:=varToString(obj[k],,,.f.)
				j:=strtran(j,'"',"'")
				? '       <textbox '
				?? ' id="'+attr:name+'"'
				?? ' value="'+j+'"'
				?? ' hidden="false"/>'
				/*
				? '       <textbox id="'+attr:name+'" hidden="true">'
				? '       <html:table>'
				for j=1 to len(obj[k])
					? '       <html:tr><html:td>'+toString(obj[k][j])+'</html:tr>'
				next
				? '       </html:table>'
				? '       </textbox>'
				*/
			endif
			? '    </hbox>'
		next
		? '</vbox>'
	next
	? '</window>'
?
return
