/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
//#include "codbcfg.ch"
/*
*/
**************************************************
function coDictionary()
	local obj:=map()

	obj:classname	:= "CODBDICTIONARY"
	obj:error	:= ""
	obj:new		:=@ coDict_new()

return obj

**************************************************
static function coDict_new(self,sDict,user,passwd)
	local d,oDict
	local tmp,i,m

	if empty(sDict)
		self:error := codb_error(1001)+":"+toString(sDict)
		return self
	endif

	sDict := substr(sDict,1,codb_info("DICT_ID_LEN"))

	tmp:=codb_dict_reference(sDict)
	if !empty(tmp)
		o2self(self,tmp)
		codb_dict_register(sDict)
		return self
	endif

	d := codbList():new()
	if !empty(d:error)
		self:error:=d:error
		return self
	endif
	oDict := d:connect(sDict,user,passwd)
	if !empty(oDict:error)
		self:error:=oDict:error
		return self
	endif
	oDict:open()
	if !empty(oDict:error)
		self:error:=oDict:error
		oDict:close()
		return self
	endif
	o2self(self,oDict)
	d:close()
return self

**************************************************
function coDictionaryNew(s)
return coDictionary():new(s)

**************************************************

