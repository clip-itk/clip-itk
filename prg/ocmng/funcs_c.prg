/*
    Copyright (C) 2005-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
********************************
#include "ocmng.ch"

static parsers := map()
/**********************************************/
function ocMngCompile(xmlFile)
	local ret := map()
	local i,s, fName
	local oHtml

	oHtml := _comp_parse(xmlFile)

	if !empty(oHtml:error)
		ret:error := oHtml:error
		return ret
	endif

	__ocmng_init_simbols()
	ret := _comp_Fill(oHtml)

	if !empty(ret:error)
		return ret
	endif

	i := rat(".",xmlFile)
	fName := left(xmlFile,i)+"xmo"
	s := var2str(ret)
	memoWrit(fName, s)

	if fError() != 0
		ret:error := fErrorStr()
		return ret
	endif
return ret
/**********************************************/
static function __compNew()
	local obj := map()

	obj:classname	:= "XMLCOMPONENT"
	obj:cVersion	:= OCMNG_VERSION
	obj:error 	:= ""
	obj:encoding 	:= host_charset()
	obj:name 	:= ""
	obj:category 	:= ""
	obj:version 	:= ""
	obj:license 	:= ""
	obj:description	:= ""
	obj:created 	:= "" //ctod("")
	obj:modified 	:= "" //ctod("")
	obj:author	:= ""
	obj:Property	:= {}
	obj:Dependence	:= {}
	obj:File	:= {}
	obj:Dictionary	:= {}
	obj:Meta	:= {}
	obj:objects	:= {}


return obj
/**********************************************/
static function _cmp_parse_value(self,oHtml,oTag)
	local tagName := "", error := ""
	local nClosed := 1, lClosed := .f.
	local oData := map()
	local i, len, attrName, attrData

	oData:cdata := ""

	i := 0;	len := len(oTag:fieldsOrder)
	while (i++) < len
		attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
		attrData := oTag:fields[attrName]
		oData[attrName] := attrData
	end

	if oTag:closed
		aadd(self,oData)
		return error
	endif

	do while !oHtml:empty()
		oTag:=oHtml:get()

		if empty(oTag)
			oData:CDATA += "&\n"
			loop
		endif
		if valtype(oTag)=="C"
			oData:CDATA += oTag
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif
		if tagName == "VALUE"
			if "VALUE" $ oData
			else
				oData:value := {}
			endif
			error := eval( @_cmp_parse_value(), oData:value, oHtml, oTag)
			if !empty(error)
				exit
			else
				loop
			endif
		endif
		if tagName == "/VALUE"
			lClosed := .t.
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
	end
	if !lClosed
		error := __error_unclosed("VALUE")
		return error
	endif
	if "VALUE" $ oData .and. !empty(oData:value)
		oData:cData := ""
	endif
	aadd(self,oData)
return error
/**********************************************/
static function _cmp_parse_attr(oData,oHtml,oTag)
	local tagName := "", error := ""
	local nClosed := 1, lClosed := .f.
	local i, len, obj, attrName, attrData
	local aName := "", aValue := {}, cValue := ""
	local aType:="", aRefTo:="", aMeta:=""

	i := 0;	len := len(oTag:fieldsOrder)
	while (i++) < len
		attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
		attrData := oTag:fields[attrName]
		if attrName == "NAME"
			aname := attrData
		endif
		if attrName == "REFTO"
			aRefTo := attrData
		endif
		//oData[attrName] := attrData
	end

	if oTag:closed
		return error
	endif

	do while !oHtml:empty()
		oTag:=oHtml:get()

		if empty(oTag)
			cValue += "&\n"
			loop
		endif
		if valtype(oTag)=="C"
			cValue += oTag
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif
		if tagName == "VALUE"
			error := eval( @_cmp_parse_value(), aValue, oHtml, oTag)
			if !empty(error)
				exit
			else
				loop
			endif
		endif
		if tagName == "/ATTR"
			lClosed := .t.
		else
			error := [Undefined tag in tag ATTR:]+tagName
			return error
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
	end
	if !lClosed
		error := __error_unclosed("ATTR")
		return error
	endif
	if left(cValue,9) == "<![CDATA["
		cValue := substr(cValue,10,len(cValue)-12)
	endif

	obj :=map()
	obj:name  := aName
	obj:refto := aRefTo
	obj:value := iif(empty(aValue),cValue,aValue)

	aadd(oData,obj)
return error
/**********************************************/
static function _cmp_parse_object(self,oHtml,oTag)
	local tagName := "", error:=""
	local nClosed := 1, lClosed := .f.
	local oData := {}
	local i, len, attrName, attrData

	i := 0;	len := len(oTag:fieldsOrder)
	while (i++) < len
		attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
		attrData := oTag:fields[attrName]
		aadd(oData,{attrName,attrData})
	end

	do while !oHtml:empty()
		oTag:=oHtml:get()

		if empty(oTag)
			loop
		endif
		if valtype(oTag)=="C"
			self:error := [Bad data in tag OBJECT:]+toString(oTag)
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif
		if tagName $ parsers
			self:error := eval( parsers[tagName], oData, oHtml, oTag)
			if !empty(self:error)
				exit
			else
				loop
			endif
		else
			if tagName == "/OBJECT"
				lClosed := .t.
			else
				self:error := [Undefined tag in tag OBJECT:]+tagName
				exit
			endif
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
	end
	if !lClosed .and. empty(self:error)
		self:error := __error_unclosed("OBJECT")
		return
	endif
	aadd(self:object,oData)
return
/**********************************************/
static function _cmp_parse_objects(self,oHtml,oTag)
	local tagName := ""
	local nClosed := 1, lClosed := .f.
	local oData := map()
	local i, len, attrName, attrData

	oData:depository := ""
	oData:rules 	 := ""
	oData:class	 := ""
	oData:error 	 := ""
	oData:cData	 := ""
	oData:object	 := {}

	i := 0;	len := len(oTag:fieldsOrder)
	while (i++) < len
		attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
		attrData := oTag:fields[attrName]
		oData[attrName] := attrData
	end

	do while !oHtml:empty()
		oTag:=oHtml:get()

		if empty(oTag)
			loop
		endif
		if valtype(oTag)=="C"
			self:error := [Undefined data in tag OBJECTS:]+toString(oTag)
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif
		if tagName $ parsers
			eval( parsers[tagName], oData, oHtml, oTag)
			if !empty(oData:error)
				self:error := oData:error
				exit
			endif
			loop
		else
			if tagName == "/OBJECTS"
				lClosed := .t.
			else
				self:error := [Undefined tag in tag OBJECTS:]+tagName
				exit
			endif
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
	end
	if !lClosed .and. empty(self:error)
		self:error := __error_unclosed("OBJECTS")
		return
	endif
	aadd(self:objects,oData)
return
/**********************************************/
static function _cmp_parse_tview(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"TVIEW",{"NAME","CLASS","COLUMNS"})
/**********************************************/
static function _cmp_parse_tcolumn(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"TCOLUMN",{"NAME","WIDTH","HEADER","FOOTER","EXPRESSION"})
/**********************************************/
static function _cmp_parse_plugin(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"PLUGIN",{"NAME","CLASS","FILE"})
/**********************************************/
static function _cmp_parse_class(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"CLASS",{"NAME","ESSENCE","EXTENT","ATTRIBUTES","INDICES"})
/**********************************************/
static function _cmp_parse_index(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"INDEX",{"NAME","EXPRESSION"})
/**********************************************/
static function _cmp_parse_counter(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"COUNTER",{"NAME","TYPE"})
/**********************************************/
static function _cmp_parse_attribute(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"ATTRIBUTE",{"NAME","TYPE","LEN","DEC","LENTYPE"})
/**********************************************/
static function _cmp_parse_depository(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"DEPOSITORY",{"NAME"})
/**********************************************/
static function _cmp_parse_extent(oMeta,oHtml,oTag)
return _cmp_parse_simple2(oMeta,oHtml,oTag,"EXTENT",{"NAME"})
/**********************************************/
static function _cmp_parse_meta(self,oHtml,oTag)
	local tagName := ""
	local nClosed := 1, lClosed := .f.
	local oData := map()
	local i, len, attrName, attrData

	oData:dictionary := ""
	oData:error 	 := ""
	oData:cData	 := ""
	oData:rules	 := ""
	oData:depository := {}
	oData:extent 	 := {}
	oData:counter	 := {}
	oData:attribute	 := {}
	oData:index	 := {}
	oData:plugin	 := {}
	oData:class	 := {}
	oData:tcolumn	 := {}
	oData:tview	 := {}

	i := 0;	len := len(oTag:fieldsOrder)
	while (i++) < len
		attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
		attrData := oTag:fields[attrName]
		oData[attrName] := attrData
	end

	do while !oHtml:empty()
		oTag:=oHtml:get()

		if empty(oTag)
			loop
		endif
		if valtype(oTag)=="C"
			self:error := [Undefined data in tag META:]+toString(oTag)
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif
		if tagName $ parsers
			eval( parsers[tagName], oData, oHtml, oTag)
			loop
		else
			if tagName == "/META"
				lClosed := .t.
			else
				self:error := [Undefined tag in tag META:]+tagName
				exit
			endif
		endif
		if !empty(oData:error)
			self:error := oData:error
			exit
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
	end
	if !lClosed .and. empty(self:error)
		self:error := __error_unclosed("META")
		return
	endif
	aadd(self:meta,oData)
return
/**********************************************/
static function _cmp_parse_file(self,oHtml,oTag)
return 	_cmp_parse_simple2(self,oHtml,oTag,"FILE",{"NAME","FORM","TYPE"})
/**********************************************/
static function _cmp_parse_dependence(self,oHtml,oTag)
return 	_cmp_parse_simple2(self,oHtml,oTag,"DEPENDENCE",{"TYPE","VERSION"})
/**********************************************/
static function _cmp_parse_property(self,oHtml,oTag)
return 	_cmp_parse_simple2(self,oHtml,oTag,"PROPERTY",{"NAME"})
/**********************************************/
static function _cmp_parse_simple2(self,oHtml,oTag,cName,aAttr)
	local tagName := ""
	local nClosed := 1, lClosed := .f.
	local oData := map()
	local i, len, attrName, attrData

	i := 0;	len := len(aAttr)
	while (i++) < len
		oData[ aAttr[i] ] := ""
	end
	oData:cdata := ""

	i := 0;	len := len(oTag:fieldsOrder)
	while (i++) < len
		attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
		attrData := oTag:fields[attrName]
		oData[attrName] := attrData
	end

	if oTag:closed
		aadd(self[cName],oData)
		return
	endif

	do while !oHtml:empty()
		oTag:=oHtml:get()

		if empty(oTag)
			oData:CDATA += "&\n"
			loop
		endif
		if valtype(oTag)=="C"
			oData:CDATA += oTag
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif
		if tagName == "/"+cName
			lClosed := .t.
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
	end
	if !lClosed
		self:error := __error_unclosed(cName)
		return
	endif
	if left(oData:cdata,9) == "<![CDATA["
		oData:cdata := substr(oData:cData,10,len(oData:cdata)-12)
	endif
	aadd(self[cName],oData)
return
/**********************************************/
static function _cmp_parse_dict(self,oHtml,oTag)
	local tagName := ""
	local nClosed := 1, lClosed := .f.
	local oDict := map(), curAttr:=""
	do while !oHtml:empty()
		oTag:=oHtml:get()

		if empty(oTag)
			loop
		endif
		if valtype(oTag)=="C"
			oDict[curAttr] := oTag
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif

		if tagName == "/DICTIONARY"
			lClosed := .t.
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
		if left(tagName,1) == "/"
			loop
		endif
		curAttr := tagName
	end
	if !lClosed
		self:error := __error_unclosed("DICTIONARY")
	else
		aadd(self:Dictionary,oDict)
	endif
return
/**********************************************/
static function _cmp_parse_install(self,oHtml,oTag)
return _cmp_parse_skipEmpty(self,oHtml,oTag,"INSTALL")
/**********************************************/
static function _cmp_parse_uninstall(self,oHtml,oTag)
return _cmp_parse_skipEmpty(self,oHtml,oTag,"UNINSTALL")
/**********************************************/
static function _cmp_parse_locale(self,oHtml,oTag)
return _cmp_parse_skipEmpty(self,oHtml,oTag,"LOCALE")
/**********************************************/
static function _cmp_parse_commands(self,oHtml,oTag)
return _cmp_parse_skipEmpty(self,oHtml,oTag,"COMMANDS")
/**********************************************/
static function _cmp_parse_skipEmpty(self,oHtml,oTag,cName)
	local tagName := ""
	local nClosed := 1, lClosed := .f.
	do while !oHtml:empty()
		oTag:=oHtml:get()
		if empty(oTag)
			loop
		endif
		if valtype(oTag)=="C"
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif

		if tagName == "/"+cName
			lClosed := .t.
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
	end
	if !lClosed
		self:error := __error_unclosed(cName)
	endif
return
/**********************************************/
static function _cmp_parse_author(self,oHtml,oTag)
	local tagName := ""
	local nClosed := 1, lClosed := .f.
	local oDict := map(), curAttr:=""
	do while !oHtml:empty()
		oTag:=oHtml:get()

		if empty(oTag)
			loop
		endif
		if valtype(oTag)=="C"
			if valtype(self:author) == "C"
				self:author := oTag
			else
				self:author[curAttr] := oTag
			endif
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif

		if tagName == "/AUTHOR"
			lClosed := .t.
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
		if left(tagName,1) == "/"
			loop
		endif
		if valtype(self:author) == "C"
			self:author := map()
		endif

		curAttr := tagName
	end
	if !lClosed
		self:error := __error_unclosed("AUTHOR")
	endif
return
/**********************************************/
static function _cmp_parse_modified(self,oHtml,oTag)
	local ret
	ret := _cmp_parse_simple1(self,oHtml,oTag,"MODIFIED")
	//self:modified := ctod(self:modified,"YYYY-MM-DD")
return ret
/**********************************************/
static function _cmp_parse_created(self,oHtml,oTag)
	local ret
	ret := _cmp_parse_simple1(self,oHtml,oTag,"CREATED")
	//self:created := ctod(self:created,"YYYY-MM-DD")
return ret
/**********************************************/
static function _cmp_parse_description(self,oHtml,oTag)
return	_cmp_parse_simple1(self,oHtml,oTag,"DESCRIPTION")
/**********************************************/
static function _cmp_parse_license(self,oHtml,oTag)
return	_cmp_parse_simple1(self,oHtml,oTag,"LICENSE")
/**********************************************/
static function _cmp_parse_category(self,oHtml,oTag)
return	_cmp_parse_simple1(self,oHtml,oTag,"CATEGORY")
/**********************************************/
static function _cmp_parse_version(self,oHtml,oTag)
return	_cmp_parse_simple1(self,oHtml,oTag,"VERSION")
/**********************************************/
static function _cmp_parse_name(self,oHtml,oTag)
return	_cmp_parse_simple1(self,oHtml,oTag,"NAME")
/**********************************************/
static function _cmp_parse_simple1(self,oHtml,oTag,sName)
	local tagName := ""
	local nClosed := 1, lClosed := .f.
	local i, len, attrName, attrData
	i := 0; len := len(oTag:fieldsOrder)
	while (i++) < len
		attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
		attrData := oTag:fields[attrName]
		self[attrName] := attrData
	end
	if oTag:closed
		return
	endif
	do while !oHtml:empty()
		oTag:=oHtml:get()
		if empty(oTag)
			self:cData += "&\n"
			loop
		endif
		if valtype(oTag)=="C"
			self[sName] += oTag
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		endif
		if tagName == "/"+sName
			lClosed := .t.
		endif
		nClosed += iif( left(tagName,1) == "/", -1, +1)
		if nClosed == 0
			exit
		endif
	end
	if ! lClosed
		self:error := __error_unclosed(sName)
	endif
return
/**********************************************/
static function _cmp_parse_header(self,oHtml,oTag)
	local len := len(oTag:fieldsOrder)
	local i := 0, attrName, attrData
	while (i++) < len
		attrName := oTag:fieldsOrder[i] //oTag:hashname(i)
		attrData := oTag:fields[attrName]
		if upper(attrName) == "ENCODING"
			if !empty(attrData)
				self:encoding := attrData
			endif
		endif
	end
return
/**********************************************/
static function _comp_fill(oHtml)
	local i,attrName,attrData
	local oTag, tagName := "", oldTag := ""
	local oComp := __compNew()

	_init_comp_parsers()

	do while !oHtml:empty()
		oTag:=oHtml:get()
		if empty(oTag)
			//oComp:__add("","&\n")
			loop
		endif
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
			tagName := upper(oTag:tagname)
		else
			//oComp:__add("", oTag )
			loop
		endif
		if tagName $ parsers
			eval( parsers[tagName], oComp, oHtml, oTag)
			loop
		endif
		if !empty(oComp:error)
			exit
		endif
		//? tagName //,oTag
	enddo
return oComp

/**********************************************/
static function _comp_parse(xmlFile)
	local hFile, oHtml
	local lSet := set(_SET_TRANSLATE_PATH,.f.)

	oHtml := htmlParserNew()
	hFile := fopen(xmlFile,0)
	set(_SET_TRANSLATE_PATH,lSet)
	if hFile < 0
		oHtml:error := [Error open file:]+xmlFile+":"+ferrorstr()
		return oHtml
	endif
	do while !fileeof(hFile)
		oHtml:put(freadstr(hFile,20))
	enddo
	fclose(hFile)
	oHtml:end()
return oHtml

/**********************************************/
static function	_init_comp_parsers()
	parsers["?XML"] := @_cmp_parse_header()
	parsers["NAME"] := @_cmp_parse_name()
	parsers["CATEGORY"] := @_cmp_parse_category()
	parsers["VERSION"] := @_cmp_parse_version()
	parsers["DESCRIPTION"] := @_cmp_parse_description()
	parsers["LICENSE"] := @_cmp_parse_license()
	parsers["CREATED"] := @_cmp_parse_created()
	parsers["MODIFIED"] := @_cmp_parse_modified()
	parsers["AUTHOR"] := @_cmp_parse_author()
	parsers["PROPERTY"] := @_cmp_parse_property()
	//parsers["REQUIRES"] := @_cmp_parse_requires()
	parsers["DEPENDENCE"] := @_cmp_parse_dependence()
	parsers["FILE"] := @_cmp_parse_file()
	parsers["COMMANDS"] := @_cmp_parse_commands()
	parsers["LOCALE"] := @_cmp_parse_locale()
	parsers["INSTALL"] := @_cmp_parse_install()
	parsers["UNINSTALL"] := @_cmp_parse_uninstall()
	parsers["DICTIONARY"] := @_cmp_parse_dict()
	parsers["META"] := @_cmp_parse_meta()
	parsers["DEPOSITORY"] := @_cmp_parse_depository()
	parsers["EXTENT"] := @_cmp_parse_extent()
	parsers["COUNTER"] := @_cmp_parse_counter()
	parsers["ATTRIBUTE"] := @_cmp_parse_attribute()
	parsers["INDEX"] := @_cmp_parse_index()
	parsers["CLASS"] := @_cmp_parse_class()
	parsers["PLUGIN"] := @_cmp_parse_plugin()
	parsers["TCOLUMN"] := @_cmp_parse_tcolumn()
	parsers["TVIEW"] := @_cmp_parse_tview()
	parsers["OBJECTS"] := @_cmp_parse_objects()
	parsers["OBJECT"] := @_cmp_parse_object()
	parsers["ATTR"] := @_cmp_parse_attr()
return
/**********************************************/
static function __error_unclosed(tagName)
	local ret

	ret := [Unclosed XML tag:]+tagName

return ret

#include "funcs_s.prg"

