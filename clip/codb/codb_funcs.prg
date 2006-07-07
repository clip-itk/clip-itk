/*
    Copyright (C) 2002-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "codbcfg.ch"
#include "codb_dbf.ch"

static dict_list := map()
static dict_counter:= map()
static dep_list  := map()
static dep_counter:= map()
static oLogDep

************************************
* return default path for ODB dictionaries
************************************
function codbRoot()
	local ret := "", f
	f := cliproot()+PATH_DELIM+"etc"+PATH_DELIM+"CODBROOT"
	if file(f)
		ret := memoread(f)
		if len(ret) < 2
			ret := ""
		endif
		ret := strtran(ret,"&\r","")
		ret := strtran(ret,"&\n","")
		ret := alltrim(ret)
	endif
	if empty(ret) //.and. !empty(getenv("CODBROOT"))
		ret := getenv("CODBROOT")
	endif

	if empty(ret)
		ret := cygwinroot()+PATH_DELIM+PATH_DELIM+"home"+PATH_DELIM+getenv("USER")+PATH_DELIM+"codb"
	endif

	ret := strtran(ret,"//","/")
	ret := strtran(ret,"\\","\")
	memowrit(f,ret)
	ret += PATH_DELIM

return ret
************************************
* return default type for ODB dictionaries
************************************
function codbType()
	local ret := "", f
	f := cliproot()+PATH_DELIM+"etc"+PATH_DELIM+"CODBTYPE"
	if file(f)
		ret := memoread(f)
		if len(ret) < 2
			ret := ""
		endif
		ret := strtran(ret,"&\r","")
		ret := strtran(ret,"&\n","")
		ret := alltrim(ret)
	endif
	if empty(ret) //.and. !empty(getenv("CODBTYPE"))
		ret := getenv("CODBTYPE")
	endif

	if empty(ret)
		ret :=	CODB_DICTTYPE_DEFAULT
	endif

	ret := strtran(ret,"//","/")
	ret := strtran(ret,"\\","\")
	memowrit(f,ret)

return ret
************************************
function codb_dict_register(id,obj)
	if id $ dict_list .and. dict_counter[id] > 0
		dict_counter[id] ++
	else
		dict_list[id] := obj
		dict_counter[id] :=1
	endif
return
************************************
function codb_dict_ref_counter(id)
	if id $ dict_list
		return dict_counter[id]
	else
		return 0
	endif
return 0
************************************
function codb_dict_unregister(id)
	local count:=0
	if id $ dict_list
		dict_counter[id] --
		count := dict_counter[id]
	endif
	if count <= 0
		adel(dict_list,hashstr(id))
	endif
return
************************************
function codb_dict_reference(id)
	local tmp
	if empty(id)
		tmp:=mapkeys(dict_list)
		if len(tmp)>0
			return dict_list[tmp[1]]
		endif
	endif
	if id $ dict_list
		return dict_list[id]
	endif
return NIL
************************************
function codb_dep_register(id,obj)
	if len(id) == codb_info("CODB_ID_LEN")
		id = substr(id,1,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	endif
	if id $ dep_list .and. dep_counter[id] > 0
		dep_counter[id] ++
	else
		dep_list[id] := obj
		dep_counter[id] :=1
	endif
return
************************************
function codb_dep_ref_counter(id)
	if len(id) == codb_info("CODB_ID_LEN")
		id = substr(id,1,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	endif
	if id $ dep_list
		return dep_counter[id]
	else
		return 0
	endif
return 0
************************************
function codb_dep_unregister(id)
	local count:=0
	if len(id) == codb_info("CODB_ID_LEN")
		id = substr(id,1,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))
	endif
	if id $ dep_list
		dep_counter[id] --
		count := dep_counter[id]
	endif
	if count <= 0
		adel(dep_list,hashstr(id))
	endif
return
************************************
function codb_dep_reference(id)
	local tmp
	if empty(id)
		tmp:=mapkeys(dep_list)
		if len(tmp)>0
			return dep_list[tmp[1]]
		endif
	endif
	if len(id) == codb_info("CODB_ID_LEN")
		id = substr(id,codb_info("DICT_ID_LEN")+1,codb_info("DEPOSIT_ID_LEN"))
	endif
	if id $ dep_list
		return dep_list[id]
	endif
return NIL
************************************
function codb_openedDeps()
return dep_list


************************************
function codb_padrBody(oData,aBodyDesc)
	static idLen:=codb_info("DICT_ID_LEN")
	local ret, oDict, idDict
	local i,name, class_id := aBodyDesc
	if valtype(class_id)=="C"
		idDict:=left(class_id,idLen)
		oDict := codb_dict_reference(idDict)
		if valtype(oDict) == "O"
			return  oDict:padrBody(oData,class_id)
		endif
	else
		if empty(aBodyDesc)
			return oData
		endif
	endif
	if valtype(oData) != "O"
		oData := map()
	endif
	for i=1 to len(aBodyDesc)
		/*
		if aBodyDesc[i][2] $ "MRLNDS"
			loop
		endif
		*/
		name := hashStr(upper(aBodyDesc[i][1]))
		if !(name $ oData)
			oData[ name ] := attrBlank ( aBodyDesc[i] )
			//oData[name] := aBodyDesc[i][6]
		endif
		if valtype(oData[name]) $ "C"
			oData[name] := padr(oData[name],aBodyDesc[i][3])
		endif
	next
return oData

************************************
function codb_checkBody(oData,aBodyDesc)
	local i:=0,name,len
	if empty(aBodyDesc)
		return oData
	endif
	if valtype(oData) != "O"
		oData := map()
	endif
	len:=len(aBodyDesc)
	while (i++) < len
		name := hashStr(upper(aBodyDesc[i][1]))
		if name $ oData
			attrCheck ( @oData[ name ], aBodyDesc[i] )
		else
			oData[ name ] := attrBlank ( aBodyDesc[i] )
		endif
	end
return oData

************************************
* return empty Attribute
************************************
static function attrBlank ( attrDesc )
	local ret
	switch attrDesc[2] // type of attribute
	case 'C'
		//ret := space(attrDesc[3])
		if attrDesc[5] == CODB_LENTYPE_PADR
			ret := padr(attrDesc[6],attrDesc[3]) // default value
		else
			ret := ""
		endif
	case 'M'
		ret := ""
	case 'D'
		ret := ctod("")
	case 'N'
		if valtype(attrDesc[6])=="N"
			ret := val(str(attrDesc[6]),attrDesc[3],attrDesc[4])
		else
			ret := val("0",attrDesc[3],attrDesc[4])
		endif
		len(@ret,attrDesc[3])
	case 'L'
		ret := .f.
	case 'A'
		ret := {}
	case 'B'
		ret := {||}
	case 'R'
		ret := "" //replicate(chr(0),CODB_ID_LEN)
	case 'S'
		ret := "" //replicate(chr(0),CODB_ID_LEN)
	case 'X'
		ret := attrDesc[6]
	case 'O'
		ret := map()
	end
return ret
************************************
* corrcting attribute to attrDescription
************************************
static function attrCheck (attrData, attrDesc )
	local ret, cType:=valtype(attrData)
	switch attrDesc[2] // type of attribute
	case 'C','M'
		if cType $ "CM"
			ret := attrData
		else
			ret := toString(attrData)
		endif
		if attrDesc[2] == "C"
			switch attrdesc[5] // type of length
				case CODB_LENTYPE_NONE
					// ret := ret
				case CODB_LENTYPE_RTRIM
					ret := rtrim(ret)
				case CODB_LENTYPE_ALLTRIM
					ret := alltrim(ret)
				case CODB_LENTYPE_PADR
					ret := padr(ret,attrDesc[3])
				otherwise
					ret := padr(ret,attrDesc[3])
			endswitch
			ret := left(ret,attrDesc[3])
		endif
	case 'D'
		if cType =="D"
			ret := attrData
		elseIf cType=="C"
			ret := stod(attrData)
		elseIf cType=="N"
			ret := jtod(attrData)
		else
			ret := ctod("")
		endif
	case 'N'
		if cType =="N"
			//ret:=val(str(attrData),attrDesc[3],attrDesc[4])
			ret := round(attrData,attrDesc[4])
		elseIf cType=="C"
			ret := val(attrData,attrDesc[3],attrDesc[4])
		elseIf cType=="D"
			ret := dtoj(attrData)
		else
			ret := val("0",attrDesc[3],attrDesc[4])
		endif
		len(@ret,attrDesc[3])
		//outlog(__FILE__,__LINE__,attrData,ret,attrDesc[3],attrDesc[4])
	case 'L'
		if cType=="L"
			ret := attrData
		elseif cType == "C"
			if left(attrData,1) == "."
				ret := ( substr(attrData,2,1) $ "tTyY" )
			else
				ret := ( substr(attrData,1,1) $ "tTyY" )
			endif
		elseif cType == "N"
			ret := (attrData > 0)
		else
			ret := .f.
		endif
	case 'A'
		if cType=="A"
			ret := attrData
		else
			ret := {}
		endif
	case 'B'
		if cType=="A"
			ret := attrData
		else
			ret := {||}
		endif
	case 'R'
		if cType=="C"
			//ret := padl(attrData,CODB_ID_LEN,"0")
			ret := attrData
		else
			ret := "" //replicate(chr(0),CODB_ID_LEN)
		endif
	case 'S'
		if cType=="C"
			//ret := padl(attrData,CODB_ID_LEN,"0")
			ret := attrData
		else
			ret := "" //replicate(chr(0),CODB_ID_LEN)
		endif
	case 'X'
		ret:=attrData
	case 'O'
		if cType=="O"
			ret := attrData
		else
			ret := map()
		endif
	end
	attrData := ret
return ret
************************************************************
function codb_isMetaName(metaName)
	local ret
	ret := ascan(CODB_METANAMES,metaName)
return ret > 0
************************************
function codb_version()
return CODB_VERSION
************************************
/* return static informations */
function codb_info(dKey)
	local ret, data_key
	data_key := alltrim(upper(dKey))
	do switch (data_key)
		case "CODB_VERSION"
			ret:=CODB_VERSION
		case "CODB_ID_LEN"
			ret:=CODB_ID_LEN
		case "DICT_ID_LEN"
			ret:=DICT_ID_LEN
		case "DEPOSIT_ID_LEN"
			ret:=DEPOSIT_ID_LEN
		case "DEP_ID_LEN"
			ret:=DEPOSIT_ID_LEN
		case "OBJECT_ID_LEN"
			ret:=CODB_ID_LEN - DICT_ID_LEN - DEPOSIT_ID_LEN
		case "CODB_CLASS_BODY"
			ret:=CODB_CLASS_BODY
		case  "CODB_ATTR_BODY"
			ret:=CODB_ATTR_BODY
		case  "CODB_COUNTER_BODY"
			ret:=CODB_COUNTER_BODY
		case  "CODB_SEMA_BODY"
			ret:=CODB_SEMA_BODY
		case  "CODB_IDX_PER_CLASS"
			ret:=CODB_IDX_PER_CLASS
		case  "CODB_IDX_DATALENGTH"
			ret:=CODB_IDX_DATALENGTH
		case  "CODB_DICT_CACHE"
			ret:=CODB_DICT_CACHE
		case  "CODB_DEP_CACHE"
			ret:=CODB_DEP_CACHE
		case  "CODB_MEMOSIZE_DEFAULT"
			ret:=CODB_MEMOSIZE_DEFAULT
		case  "CODB_ATTR_TYPES"
			ret:=CODB_ATTR_TYPES
		case  "CODB_REPORT_TYPES"
			ret:=CODB_REPORT_TYPES
		case  "CODB_PLUGINS_TYPES"
			ret:=CODB_PLUGINS_TYPES
		case  "CODB_ATTR_LENTYPES"
			ret:=CODB_ATTR_LENTYPES
		case  "CODB_INDEX_TYPES"
			ret:=CODB_INDEX_TYPES
		case  "CODB_COUNTER_TYPES"
			ret:=CODB_COUNTER_TYPES
		case  "CODB_MAX_LEN_STRING"
			ret:=CODB_MAX_LEN_STRING
		case  "CODB_MIN_DECIMALS"
			ret:=CODB_MIN_DECIMALS
		case  "CODB_MAX_DECIMALS"
			ret:=CODB_MAX_DECIMALS
		case  "CODB_GROUP_BODY"
			ret:=CODB_GROUP_BODY
		case  "CODB_USER_BODY"
			ret:=CODB_USER_BODY
		case  "CODB_EXTENT_BODY"
			ret:=CODB_EXTENT_BODY
		case  "CODB_DEPOSIT_BODY"
			ret:=CODB_DEPOSIT_BODY
		case  "CODB_TCOLUMN_BODY"
			ret:=CODB_TCOLUMN_BODY
		case  "CODB_TVIEW_BODY"
			ret:=CODB_TVIEW_BODY
		case  "CODB_REPORT_BODY"
			ret:=CODB_REPORT_BODY
		case  "CODB_PLUGINS_BODY"
			ret:=CODB_PLUGINS_BODY
		case  "CODB_INDEX_BODY"
			ret:=CODB_INDEX_BODY
		case  "CODB_DICT_TYPES"
			ret:=CODB_DICT_TYPES
		case  "CODB_DICT_DTYPES"
			ret:=CODB_DICT_DTYPES
		case  "CODB_DICTLIST_STRUCTURE"
			ret:=CODB_DICTLIST_STRUCTURE
		case  "CODB_DICTLIST_BODY"
			ret:=CODB_DICTLIST_BODY
		case  "CODB_DICT_STRUCTURE"
			ret:=CODB_DICT_STRUCTURE
		case  "CODB_EXTENT_STRUCTURE"
			ret:=CODB_EXTENT_STRUCTURE
		case  "CODB_DEPIDX_STRUCTURE"
			ret:=CODB_DEPIDX_STRUCTURE
	end
	/*
	data_key := alltrim(upper(dKey))
	do case
		case data_key == "CODB_VERSION"
			ret:=CODB_VERSION
		case data_key == "CODB_ID_LEN"
			ret:=CODB_ID_LEN
		case data_key == "DICT_ID_LEN"
			ret:=DICT_ID_LEN
		case data_key == "DEPOSIT_ID_LEN"
			ret:=DEPOSIT_ID_LEN
		case data_key == "OBJECT_ID_LEN"
			ret:=CODB_ID_LEN - DICT_ID_LEN - DEPOSIT_ID_LEN
		case data_key == "CODB_CLASS_BODY"
			ret:=CODB_CLASS_BODY
		case data_key == "CODB_ATTR_BODY"
			ret:=CODB_ATTR_BODY
		case data_key == "CODB_COUNTER_BODY"
			ret:=CODB_COUNTER_BODY
		case data_key == "CODB_SEMA_BODY"
			ret:=CODB_SEMA_BODY
		case data_key == "CODB_IDX_PER_CLASS"
			ret:=CODB_IDX_PER_CLASS
		case data_key == "CODB_IDX_DATALENGTH"
			ret:=CODB_IDX_DATALENGTH
		case data_key == "CODB_DICT_CACHE"
			ret:=CODB_DICT_CACHE
		case data_key == "CODB_DEP_CACHE"
			ret:=CODB_DEP_CACHE
		case data_key == "CODB_MEMOSIZE_DEFAULT"
			ret:=CODB_MEMOSIZE_DEFAULT
		case data_key == "CODB_ATTR_TYPES"
			ret:=CODB_ATTR_TYPES
		case data_key == "CODB_REPORT_TYPES"
			ret:=CODB_REPORT_TYPES
		case data_key == "CODB_PLUGINS_TYPES"
			ret:=CODB_PLUGINS_TYPES
		case data_key == "CODB_ATTR_LENTYPES"
			ret:=CODB_ATTR_LENTYPES
		case data_key == "CODB_INDEX_TYPES"
			ret:=CODB_INDEX_TYPES
		case data_key == "CODB_COUNTER_TYPES"
			ret:=CODB_COUNTER_TYPES
		case data_key == "CODB_MAX_LEN_STRING"
			ret:=CODB_MAX_LEN_STRING
		case data_key == "CODB_MIN_DECIMALS"
			ret:=CODB_MIN_DECIMALS
		case data_key == "CODB_MAX_DECIMALS"
			ret:=CODB_MAX_DECIMALS
		case data_key == "CODB_GROUP_BODY"
			ret:=CODB_GROUP_BODY
		case data_key == "CODB_USER_BODY"
			ret:=CODB_USER_BODY
		case data_key == "CODB_EXTENT_BODY"
			ret:=CODB_EXTENT_BODY
		case data_key == "CODB_DEPOSIT_BODY"
			ret:=CODB_DEPOSIT_BODY
		case data_key == "CODB_TCOLUMN_BODY"
			ret:=CODB_TCOLUMN_BODY
		case data_key == "CODB_TVIEW_BODY"
			ret:=CODB_TVIEW_BODY
		case data_key == "CODB_REPORT_BODY"
			ret:=CODB_REPORT_BODY
		case data_key == "CODB_PLUGINS_BODY"
			ret:=CODB_PLUGINS_BODY
		case data_key == "CODB_INDEX_BODY"
			ret:=CODB_INDEX_BODY
		case data_key == "CODB_DICT_TYPES"
			ret:=CODB_DICT_TYPES
		case data_key == "CODB_DICT_DTYPES"
			ret:=CODB_DICT_DTYPES
		case data_key == "CODB_DICTLIST_STRUCTURE"
			ret:=CODB_DICTLIST_STRUCTURE
		case data_key == "CODB_DICTLIST_BODY"
			ret:=CODB_DICTLIST_BODY
		case data_key == "CODB_DICT_STRUCTURE"
			ret:=CODB_DICT_STRUCTURE
		case data_key == "CODB_EXTENT_STRUCTURE"
			ret:=CODB_EXTENT_STRUCTURE
		case data_key == "CODB_DEPIDX_STRUCTURE"
			ret:=CODB_DEPIDX_STRUCTURE
	end
	*/
return ret

*******************************************
function codb_cache_minimize(oCache,num)
	local m:={},i
	for i in oCache KEYS
		aadd(m,i)
		if len(m) > num
			exit
		endif
	next
	for i=1 to len(m)
		adel(oCache,m[i])
	next
return

/**********************************************/
function codb_ParseXMLfile(xmlFile)
	local hFile, oHtml,oTag,oMeta
	local ret, line := 1, s
	local i,attrName,attrData
	hFile := fopen(xmlFile,0)
	if hFile < 0
		return "Error open source file ("+xmlFile+"):"+ferrorstr()
	endif
	oHtml := htmlParserNew()
	do while !fileeof(hFile)
		s := filegetstr(hFile)
		//s := freadstr(hFile,20)
		oHtml:put(s)
		if !empty(oHtml:error)
			outlog([XML parse error:],oHtml:error,[file],xmlFile,[line],line,[data],s)
		endif
		line ++
	enddo
	fclose(hFile)
	oHtml:end()

	ret:=map()
	do while !oHtml:empty()
		oTag:=oHtml:get()
		if empty(oTag)
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
		else
			loop
		endif
		if oTag:tagname=="!"
			loop
		endif
		oTag:tagName:=upper(alltrim(oTag:tagName))
		if oTag:tagname $ ret
		else
			ret[oTag:tagname]={}
		endif
		oMeta:={}
		/*
		for i in oTag:fields KEYS
			attrName := oTag:hashname(i)
			attrData := oTag:fields[i]
			aadd(oMeta,{attrName,attrData})
		next
		*/
		for i=1 to len(oTag:fieldsOrder) //in oTag:fields KEYS
			attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
			attrData := oTag:fields[attrName]
			aadd(oMeta,{attrName,attrData})
		next
		aadd(ret[oTag:tagname],oMeta)
	enddo

return ret

************************************************************
function codb_getRefTo(ObjId)
	local ret := left(objId,codb_info("DICT_ID_LEN"))+":"
	local s,obj,class

	ret := left(objId,codb_info("DICT_ID_LEN"))
	s := substr(objId,codb_info("DICT_ID_LEN")+1,codb_info("DEPOSIT_ID_LEN"))
	if !(s = "00")
		ret += s
	endif
	ret += ":"
	obj := codb_getValue(objId)
	if empty(obj)
		return ret+"__ERROR__("+objId+")"
	endif
	if "CLASS_ID" $ obj
		class := codb_getValue(obj:class_id)
		if empty(class)
			return ret+"__ERROR__("+obj:class_id+")"
		endif
		ret += class:name
	elseif "NAME" $ obj
		ret += obj:name
	endif
return  ret
************************************************************
function codb_getKeyValue(ObjId)
	local ret := objId
	local obj,class, expr
	local err,bErr

	obj := codb_getValue(objId)
	if empty(obj)
		return ret
	endif
	class := codb_getValue(obj:class_id)
	if empty(class)
		return ret
	endif
	expr := class:unique_key
	if empty(expr)
		return ret
	endif

	bErr:=errorBlock({|err|break(err)})
	begin sequence
		if isWord(expr) .and. upper(expr) $ obj
			ret := obj[upper(expr)]
		else
			ret := mapEval(obj,expr)
		endif
	recover
		ret := codb_error(1140)+":"+expr
	end sequence
	errorBlock(bErr)
return ret
************************************************************
function codb_getValue(ObjId)
	static idLen1:=codb_info("DICT_ID_LEN")
	static idLen2:=codb_info("DEPOSIT_ID_LEN")
	local ret, oDep, idDep, idDict,oDict
	if valtype(ObjId)!="C"
		return
	endif
	if substr(ObjId,idLen1+1,idLen2) == "00"  // metadata
		idDict:=left(ObjId,idLen1)
		oDict := codb_dict_reference(idDict)
		if valtype(oDict) != "O"
			return
		endif
		return  oDict:getValue(ObjId)
	else
		idDep:=left(ObjId,idLen1+idLen2)
		oDep := codb_dep_reference(idDep)
		if valtype(oDep) != "O"
			return
		endif
		return  oDep:getValue(ObjId)
	endif
return
************************************************************
function codb_updateObj(Obj)
	local idLen1:=codb_info("DICT_ID_LEN")
	local idLen2:=codb_info("DEPOSIT_ID_LEN")
	local ret, oDep, idDep, idDict,oDict
	local objId
	if valtype(Obj)!="O"
		return
	endif
	if "ID" $ obj
		objId := obj:id
	endif
	if valtype(objId)!="C"
		return
	endif
	if substr(ObjId,idLen1+1,idLen2) == "00"  // metadata
		idDict:=left(ObjId,idLen1)
		oDict := codb_dict_reference(idDict)
		if valtype(oDict) != "O"
			return
		endif
		return  oDict:update(Obj)
	else
		idDep:=left(ObjId,idLen1+idLen2)
		oDep := codb_dep_reference(idDep)
		if valtype(oDep) != "O"
			return
		endif
		return  oDep:update(Obj)
	endif
return
************************************************************
function codb_update(oData)
	static idLen1:=codb_info("DICT_ID_LEN")
	static idLen2:=codb_info("DEPOSIT_ID_LEN")
	local ret, oDep, idDep, idDict,oDict,objId
	if "ID" $ oData
		objId := oData:id
	else
		return .f.
	endif
	if substr(ObjId,idLen1+1,idLen2) == "00"  // metadata
		idDict:=left(ObjId,idLen1)
		oDict := codb_dict_reference(idDict)
		if valtype(oDict) != "O"
			return .f.
		endif
		return  oDict:update(oData,ObjId)
	else
		idDep:=left(ObjId,idLen1+idLen2)
		oDep := codb_dep_reference(idDep)
		if valtype(oDep) != "O"
			return .f.
		endif
		return  oDep:update(oData,ObjId)
	endif
return .f.
************************************************************
function codb_essence(ObjId)
	static idLen:=codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN")
	local ret, oDep, idDep, idDict,oDict, obj
	local cClass, essence:="" //[(Undef)]
	if valtype(ObjId)=="C"
		idDep:=left(ObjId,idLen)
		oDep := codb_dep_reference(idDep)
		if valtype(oDep) != "O"
			return objId
		endif
		obj := oDep:getValue(ObjId)
	else
		obj := objId
	endif
	if valtype(obj)== "O" .and. "CLASS_ID" $ obj
		cClass := codb_getValue(obj:class_id)
		if !empty(cClass)
			essence := cClass:essence(obj)
		endif
	endif
return essence

************************************************************
function codb_tColumnBody(ObjId)
	static cashe:=map()
	local ret,tmp,oDict,cClass
	if valtype(ObjId)!="C"
		return
	endif
	if objId $ cashe
		return cashe[objId]
	endif
	for oDict in dict_list
		cClass := oDict:getValue(objId)
		if !empty(cClass)
			exit
		endif
		cClass:=oDict:classBodyByName(objId)
		if !empty(cClass)
			exit
		endif
	next
	if empty(cClass)
		return objId
	endif
	tmp := oDict:select("TCOLUMN",,cClass:name)
	if !empty(tmp)
		ret := oDict:getValue(tmp[1])
		cashe[objId] := ret
	endif
return ret
************************************************************
function codb_classBodyByName(className)
	local oDict,cClass
	if valtype(className)!="C"
		return
	endif
	for oDict in dict_list
		cClass:=oDict:classBodyByName(className)
		if !empty(cClass)
			exit
		endif
	next
	if empty(cClass)
		return
	endif
return cClass

************************************************************
function codb_openLog(dep_id)
	local ret:=""
	if !empty(oLogDep)
		oLogDep:close()
		oLogDep := NIL
	endif
	if empty(dep_id)
		dep_id := upper(getenv("CODB_LOG_DEPOSIT"))
	endif
	if empty(dep_id)
		dep_id := upper(set("CODB_LOG_DEPOSIT"))
	endif
	if empty(dep_id)
		return ret
	endif

	oLogDep := coDepository():new(dep_id)
	if !empty(oLogDep:error)
		ret := oLogDep:error
		oLogDep:=NIL
		outlog(3,[Can`t open log depository],dep_id,ret)
		return ret
	endif
	oLogDep:open()
	if !empty(oLogDep:error)
		ret := oLogDep:error
		oLogDep:close()
		oLogDep := NIL
		outlog(3,[Can`t open log depository],dep_id,ret)
		return ret
	endif
return ""

************************************************************
function codb_outLog(user,oper,oData)
	static classDesc
	local i,obj:=map(), oDict
	if empty(oLogDep)
		return
	endif
	if classDesc == NIL
		oDict := oLogDep:dictionary()
		classDesc := oDict:classBodyByName("codbsyslog")
	endif
	if empty(classDesc)
		outlog(3,[Class Description not found in log depository],"codbsyslog")
		return
	endif
	if empty(user)
		user := getenv("USER")
	endif
	if empty(oper)
		oper := "unknown"
	endif
	obj:user      := user
	obj:date      := date()
	obj:time      := time()
	obj:oper      := oper
	if valtype(oData) == "O"
		if "ID" $ oData
			obj:obj_id    := oData:id
			i:=codb_info("DICT_ID_LEN")
			/* recursively logging break */
			if substr(oData:id,1,i) == substr(classDesc:id,1,i)
				return
			endif
		endif
		if "CLASS_ID" $ oData
			obj:obj_class := oData:class_id
		endif
	endif
	obj:data      := oData
	oLogDep:append(obj,classDesc:id)
	if !empty(oLogDep:error)
		outlog(3,[Error append to log depository],oLogDep:error)
	endif
return
************************************************************
/* open dictionary List */
function codb_DictList()
	local ret := {}
	local i,j,dList, List
	dList:=codbList():new()
	if val(dList:error)!=0
		return ret
	endif

	list := dList:list()
	for i=1 to len(list)
		j := at(":",list[i])
		aadd(ret,left(list[i],j-1))
	next
return ret
************************************************************
/* open or return reference to dep or dict by ID */
function codb_needDepository(depId)
	local oDep, x, len:=len(depId), isDict := .f.

	if len == DICT_ID_LEN
		isDict := .t.
	elseif len >= DICT_ID_LEN+DEPOSIT_ID_LEN
		x := substr(depId,DICT_ID_LEN+1,DEPOSIT_ID_LEN)
		if x =="00"
			depId := left(depId,DICT_ID_LEN)
			isDict := .t.
		endif
	endif

	if isDict
		oDep := codb_dict_reference(depId)
		if valType(oDep) == "O"
		 //	oDep:error := ""
			return oDep
		endif
		oDep:=coDictionary():new(depId)
		if !empty(oDep:error)
			return oDep
		endif
		oDep:open()
		return oDep
	endif
	if len >= DICT_ID_LEN+DEPOSIT_ID_LEN
		depId := left(depId,DICT_ID_LEN+DEPOSIT_ID_LEN)
		oDep := codb_dep_reference(depId)
		if valType(oDep) == "O"
		//	oDep:error := ""
			return oDep
		endif
		oDep:=coDepository():new(depId)
		if !empty(oDep:error)
			return oDep
		endif
		oDep:open()
		return oDep
	endif
return oDep

************************************************************
function codb_metaIdByName(oDep,metaName,metaClass)
	local oDict,tmp
	if oDep:classname == "CODBDEPOSITORY"
		oDict := oDep:dictionary()
	else
		oDict := oDep
		if codb_isMetaName(metaName)
			return metaName
		endif
	endif
	tmp := oDict:getValue(metaname)
	if !empty(tmp)
		return metaName
	endif
	tmp := oDict:select(metaclass,,metaname)
	if !empty(tmp)
		return tmp[1]
	endif
return ""

************************************************************
function codb_heritage(class_id)
	local idLen:=codb_info("DICT_ID_LEN")
	local ret:="",s, tmp,oDict, idDict
	if valtype(class_id)=="C"
		idDict:=left(class_id,idLen)
		oDict := codb_dict_reference(idDict)
	endif
	if empty(oDict)
		return ret
	endif
	s := class_id
	ret+=class_id
	while .t.
		tmp := oDict:getValue(s)
		if empty(tmp)
			exit
		endif
		if empty(tmp:super_id)
			exit
		endif
		ret+=tmp:super_id
		s := tmp:super_id
	end
return ret
