/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
//#include "codbcfg.ch"
/*
*/
**************************************************
function coDepository()
	local obj:=map()

	obj:classname	:= "CODBDEPOSITORY"
	obj:error	:= ""
	obj:new		:=@ coDep_new()

return obj

**************************************************
static function coDep_new(self,sDeposit,user,passwd)
	local sDict,sDep
	local d,oDict
	local tmp,i,m

	tmp:=codb_dep_reference(sDeposit)
	if !empty(tmp)
		o2self(self,tmp)
		self:DictClosing := .f.
		codb_dep_register(sDeposit)
		return self
	endif

	sDict := substr(sDeposit,1,codb_info("DICT_ID_LEN"))

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
	tmp := oDict:depository(sDeposit)
	o2self(self,tmp)
	self:DictClosing := .t.
	d:close()
return self

**************************************************
function coDepositoryNew(s)
return coDepository():new(s)

**************************************************
function coGetId4PrimaryKey(sDep,classname,keyName,keyValue)
	local oDep:=coDepository():new(sDep)
	local ret:=""
	if !empty(oDep:error)
		return ret
	endif
	oDep:open()
	if !empty(oDep:error)
		oDep:close()
		return ret
	endif
	ret:=oDep:id4PrimaryKey(classname,keyName,keyValue)
	oDep:close()
return ret

