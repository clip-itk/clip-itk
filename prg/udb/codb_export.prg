/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "codb.ch"
#include "codbcfg.ch"

local oDep,oDict

parameters sDep, className, sData, lRecursive

if empty(sDep) .or. empty(classname) //.or. empty(sData)
	? 'Usage: codb_export depository classname ["expression"]'
	?
	return
endif

	set exclusive off

	lRecursive := iif(lRecursive == NIL, .f., lRecursive)
	if valtype(lRecursive) == "C"
		lRecursive := ( "t" $ lower(lRecursive) )
	endif

	if len(sDep) == DICT_ID_LEN
		oDict := coDictionary():new(sDep)
		if !empty(oDict:error)
			? oDict:error
			?
			return
		endif
		oDict:open()
		if !empty(oDict:error)
			? oDict:error
			?
			return
		endif
		oDep := oDict
	else
		oDep:=coDepository():new(sDep)
		if !empty(oDep:error)
			? oDep:error
			?
			return
		endif
		oDep:open()
		if !empty(oDep:error)
			? oDep:error
			?
			return
		endif
	endif

	? codb_export(oDep,className,sData,lRecursive)

	?
return

/**********************/
function codb_export(oDep,className,expr,lRecursive)
	local oDict,ret := ""
	local classDesc
	if empty(expr)
		expr := .t.
	endif
	oDict:=oDep:dictionary()

	ret += __header(oDep,className,expr)
	classDesc := oDict:classBodyByName(className)
	if empty(classDesc)
		ret += __error([Class description not found:]+' '+toString(classname))
		return ret
	endif

	ret += __exportMeta(oDict,classDesc)
	if oDep:className == "CODBDEPOSITORY"
		ret += __exportData(oDep,classDesc,expr)
	endif

return ret

/**********************/
static function __exportData(oDep,classDesc,expr)
	local  s:="&\t",n:="&\n",ret :=""
	local i,j,tmp,obj,attrs:={},m:={}
	local name,attr,s2,s3,s4
	local oDict := oDep:dictionary()
	for i=1 to len(classDesc:attr_list)
		tmp := oDict:getValue(classDesc:attr_list[i])
		if empty(tmp)
			loop
		endif
		aadd(attrs,tmp)
	next
	if "EXPORT_LIST" $ classDesc .and. !empty(classDesc:export_list)
		for i=1 to len(attrs)
			if ascan(classDesc:export_list,attrs[i]:name) <=0
				aadd(m,i)
			endif
		next
		for i=len(m) to 1 step -1
		    adel(attrs,m[i])
		next
		asize(attrs,len(attrs)-len(m))
	endif
	tmp := oDep:select(classDesc:id,,,expr)
	ret += '<data>'+n
	for i=1 to len(tmp)
		obj := oDep:getValue(tmp[i])
		if empty(obj)
			ret += __error([Object not found:]+tmp[i])
			loop
		endif
		s3:=""
		for j=1 to len(attrs)
			name := attrs[j]:name
			s2 := upper(name)
			if !(s2 $ obj)
				loop
			endif
			s3 += name+'="'+__toString(attrs[j],obj[s2])+'"'+s
		next
		ret += s+'<object '+s3+'/>'+n
	next
	ret += '</data>'+n
return ret

/**********************/
static function __toString(attr,data)
	local ret,type
	type := attr:type
	do case
		case type == "C"
			ret := data
		case type == "N"
			ret := alltrim(str(data))
		case type == "D"
			ret := dtos(data)
		case type == "L"
			ret := iif(data,"yes","no")
		otherwise
			ret := toString(data)
	endcase
return  ret
/**********************/
static function __exportMeta(oDict,classDesc)
	local  s:="&\t",n:="&\n",ret :=""
	local tmp,i,s2,s3,attr,idx
	ret += '<metadata>'+n
	for i=1 to len(classDesc:attr_list)
		attr := oDict:getValue(classDesc:attr_list[i])
		if empty(attr)
			ret += __error([Object not found:]+classDesc:attr_list[i])
			loop
		endif
		if !empty(attr:counter)
			ret += __exportCounter(oDict,attr:counter)
		endif
		ret += __exportAttr(oDict,attr)
	next
	for i=1 to len(classDesc:idx_list)
		idx := oDict:getValue(classDesc:idx_list[i])
		if empty(idx)
			ret += __error([Object not found:]+classDesc:idx_list[i])
			loop
		endif
		ret += __exportIndex(oDict,idx)
	next
	ret += s+'<class name="'+classDesc:name+'"'
	ret += s+'log_need="'+iif(classDesc:log_need,"yes","no")+'"'+n
	tmp := oDict:getValue(classDesc:extent_id)
	ret += s+s+'extent_id="'+iif(empty(tmp),"",tmp:name)+'" '
	tmp := oDict:getValue(classDesc:super_id)
	ret += s+'super_id="'+iif(empty(tmp),"",tmp:name)+'"'+n
	ret += s+s+'expr_essence="'+classDesc:expr_essence+'"'+n
	if "UNIQUE_KEY" $ classDesc .and. !empty(classDesc:unique_key)
		ret += s+s+'unique_key="'+classDesc:unique_key+'"'+n
	endif
	s2 := ""
	for i=1 to len(classDesc:attr_list)
		tmp := oDict:getValue(classDesc:attr_list[i])
		if empty(tmp)
			__error([Object not found:]+classDesc:attr_list[i])
			loop
		endif
		s2+=tmp:name+","
	next
	s2 := left(s2,len(s2)-1)
	ret += s+s+'attr_list="'+s2+'"'+n
	s2 := ""
	for i=1 to len(classDesc:idx_list)
		tmp := oDict:getValue(classDesc:idx_list[i])
		if empty(tmp)
			__error([Object not found:]+classDesc:idx_list[i])
			loop
		endif
		s2+=tmp:name+","
	next
	s2 := left(s2,len(s2)-1)
	ret += s+s+'idx_list="'+s2+'"'+n
	ret += s+'/>'+n
	ret += __exportTviews(oDict,classDesc:id)
	ret += '</metadata>'+n
return ret
/**********************/
static function __exportTviews(oDict,class_id)
	local ret := ""
	local i,j,k,tmp, tmp2, tcols:={}
	tmp := oDict:select("TVIEW",,,'class_id=="'+class_id+'"')
	for i=1 to len(tmp)
		tmp2 := oDict:getValue(tmp[i])
		if empty(tmp2)
			ret += __error([Object not found:]+tmp[i])
			loop
		endif
		for j=1 to len(tmp2:col_list)
			k := ascan(tcols,tmp2:col_list[j])
			if k > 0
				loop
			endif
			aadd(tcols,tmp2:col_list[j])
		next
	next
	for i=1 to len(tcols)
		ret += __exportTcol(oDict,tcols[i])
	next
	for i=1 to len(tmp)
		tmp2 := oDict:getValue(tmp[i])
		if empty(tmp2)
			ret += __error([Object not found:]+tmp[i])
			loop
		endif
		ret += __exportTview(oDict,tmp2)
	next
return ret
/**********************/
static function __exportTview(oDict,tview)
	local  s:="&\t",n:="&\n",ret :=""
	local i,s2,tmp
	ret += s+'<tview name="'+tview:name+'"'+n
	if "HEADER" $ tview .and. !empty(tview:header)
		ret += s+s+'header="'+tview:header+'"'+n
	endif
	if "FOOTER" $ tview .and. !empty(tview:footer)
		ret += s+s+'footer="'+tview:footer+'"'+n
	endif
	tmp := oDict:getValue(tview:class_id)
	if !empty(tmp)
		ret += s+s+'class_id="'+tmp:name+'"'+n
	endif
	tmp := oDict:getValue(tview:extent_id)
	if !empty(tmp)
		ret += s+s+'extent_id="'+tmp:name+'"'+n
	endif
	tmp := oDict:getValue(tview:group_id)
	if !empty(tmp)
		ret += s+s+'group_id="'+tmp:name+'"'+n
	endif
	tmp := oDict:getValue(tview:user_id)
	if !empty(tmp)
		ret += s+s+'user_id="'+tmp:name+'"'+n
	endif
	s2 := ""
	for i=1 to len(tview:col_list)
		tmp := oDict:getValue(tview:col_list[i])
		if empty(tmp)
			__error([Object not found:]+tview:col_list[i])
			loop
		endif
		s2+=tmp:name+","
	next
	s2 := left(s2,len(s2)-1)
	ret += s+s+'col_list="'+s2+'"'+n
	ret += s+'/>'+n

return ret
/**********************/
static function __exportTcol(oDict,tcol_id)
	local  s:="&\t",n:="&\n",ret :=""
	local i,s2,tcol := oDict:getValue(tcol_id)
	if empty(tcol)
		ret += __error([Object not found:]+tcol_id)
		return ret
	endif
	ret += s+'<tcolumn name="'+tcol:name+'"'
	ret += s+'width="'+alltrim(str(tcol:width))+'"'+n
	ret += s+s+'header="'+tcol:header+'"'+n
	ret += s+s+'footer="'+tcol:footer+'"'+n
	ret += s+s+'expr="'+tcol:expr+'"'+n
	if !empty(tcol:depend_of)
		ret += s+s+'depend_of="'+tcol:depend_of+'"'+n
	endif
	if !empty(tcol:refs)
		s2 := ""
		for i=1 to len(tcol:refs)
			s2+=tcol:refs[i]+","
		next
		s2 := left(s2,len(s2)-1)
		ret += s+s+'refs="'+s2+'"'+n
	endif
	ret += s+'/>'+n
return ret
/**********************/
static function __exportCounter(oDict,counter_name)
	local  s:="&\t",n:="&\n",ret :=""
	local tmp,tmp2
	tmp := oDict:select("COUNTER",,counter_name)
	if empty(tmp)
		ret += __error([Counter name not found:]+counter_name)
	else
		tmp2 := oDict:getValue(tmp[1])
		if empty(tmp2)
		ret += __error([Object not found:]+tmp[1])
		else
		ret += s+'<counter name="'+tmp2:name+'" type="'+tmp2:type+'" />'+n
		endif
	endif
return ret
/**********************/
static function __exportAttr(oDict,attr)
	local  s:="&\t",n:="&\n",ret :=""
	local tmp,i,s2,s3:=""

	ret += s+'<attr name="'+attr:name+'"'
	ret += s+'type="'+attr:type+'"'+n
	ret += s+s+'len="'+alltrim(str(attr:len))+'"'
	ret += s+'dec="'+alltrim(str(attr:dec))+'"'
	ret += s+'lentype="'+alltrim(str(attr:lentype))+'"'+n
	ret += s+s+'mask="'+attr:mask+'"'
	ret += s+s+'defvalue="'+attr:defvalue+'"'+n
	if !empty(attr:counter)
		ret += s+s+'counter="'+attr:counter+'"'+n
	endif
	ret += s+s+'not_null="'+iif(attr:not_null,"yes","no")+'"'
	ret += s+'not_empty="'+iif(attr:not_empty,"yes","no")+'"'
	if !empty(attr:source)
		ret += s+s+'source="'+var2str(attr:source)+'"'+n
	endif
	if !empty(attr:code)
		ret += s+s+'code="'+var2str(attr:code)+'"'+n
	endif
	if !empty(attr:help)
		ret += s+s+'help="'+var2str(attr:help)+'"'+n
	endif
	if !empty(attr:ref_to)
		s2 := '"'+left(attr:ref_to,codb_info('DICT_ID_LEN'))+':'
		tmp := __metagetValue(attr:ref_to)
		if empty(tmp)
			s3 += __error([Object not found:]+attr:ref_to)
		else
			s2+=tmp:name
		endif
		ret += s+s+'ref_to="'+s2+'"'+n
	 endif
	ret += s+'/>'+n
	if !empty(s3)
		ret += s3
	endif
return ret
/**********************/
static function __exportIndex(oDict,idx)
	local  s:="&\t",n:="&\n",ret :=""
	local tmp,i,s2,s3:=""

	ret += s+'<index name="'+idx:name+'"'
	ret += s+'expr="'+idx:expr+'"'
	ret += '/>'+n
return ret
/**********************/
static function __header(oDep,className,expr)
	local ret := ""
	ret+='<?xml version="1.0" encoding="'+host_charset()+'" ?/>&\n'
	ret+='<?codb version="'+CODB_VERSION+'" knowledge="'+CODB_KNOWLEDGE+'"'
	ret+=' date="'+dtos(date())+'" time="'+time()+'" ?/>&\n'
	ret+='<?export from="'+getHostName()+'.'+getDomainName()+'" depository="'+oDep:id+'" classname="'+classname+'" expr="'+expr+'" ?/>&\n'
	ret+='&\n'
return ret
/**********************/
static function __error(s)
return  '<error decription="'+s+'"/>&\n'

/**********************/
static function __metaGetValue(cID)
	local oDict, dict_id:=left(cID,codb_info('DICT_ID_LEN'))
	oDict := codb_dict_reference(dict_id)
	if valtype(oDict) != "O"
		oDict := coDictionary():new(dict_id)
		if empty(oDict:error)
			oDict:open()
			if !empty(oDict:error)
				oDict:close()
				oDict := NIL
			endif
		else
			oDict := NIL
		endif
	endif
	if valtype(oDict) != "O"
		return  cId
	endif
return  oDict:getValue(cId)

