/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual metods for all CODB drivers */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_dictAll_Methods(path,dict_id,user,passwd)

	local obj	:= map()

	obj:classname	:= "CODBDICTIONARY"
	obj:id		:= padl(alltrim(dict_id),codb_info("DICT_ID_LEN"),"0")
	obj:path	:= alltrim(path)
	obj:error	:= ""
	obj:user	:= user
	obj:counters	:= NIL
	obj:hDbMeta	:= NIL
	obj:hDbMetaIdx	:= NIL
	obj:__objCache	:= map()
	obj:__plugCache	:= map()
	obj:__modCache	:= map()
	obj:dictionary	:= @_dict_self()
	obj:idList	:= @_dict_IdList() // return object "ID list"
	obj:objCRC	:= @_dict_objCRC()
	obj:depository	:= @_dict_depository()
	obj:padrBody	:= @_dict_padrBody()

return obj
************************************************************
static function _dict_self(self)
return self
************************************************************
static function _dict_IdList(self,metaName,nIndex,sName,sWhere,nCount,deleted)
return coDb_IdList(self,metaName,nIndex,sName,sWhere,nCount,deleted)
************************************************************
static function _dict_objCRC(self,obj)
return ntoc(crc32(var2str(obj)),32,8,"0")
************************************************************
static function _dict_padrBody(self,oData,metaName)
return	self:checkBody(oData,metaName,.t.)
************************************************************
static function _dict_depository(self,sDep)
	local sDeposit:=sDep, depName :=""
	local tmp,i,oTmp
	if len(sdep)==codb_info("DEPOSIT_ID_LEN")+codb_info("DICT_ID_LEN")
		sDep := substr(sDep,codb_info("DICT_ID_LEN")+1)
	endif
	if len(sdep)==codb_info("DEPOSIT_ID_LEN")
		tmp:= self:select("DEPOSIT")
		sDeposit := ""
		for i=1 to len(tmp)
			otmp:=self:getValue(tmp[i])
			if oTmp:number == sDep
				depName := oTmp:name
				sDeposit:=tmp[i]
			endif
		next
	endif
	if codb_cobraAvailable()
		tmp :=	codb_depCobraNew(self,sDeposit)
	else
		tmp :=	codb_depDbfNew(self,sDeposit)
	endif
	tmp:name := depName
return tmp
