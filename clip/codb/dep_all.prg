/*
	Copyright (C) 2004  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual DEPOSITORY metods for all CODB drivers */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_depAll_Methods(oDict,dep_id)
	local obj:=map(),tmp
	obj:classname	:= "CODBDEPOSITORY"
	obj:id		:= dep_id 	// padl(alltrim(dep_id),codb_info("DEPOSIT_ID_LEN"),"0")
	tmp:=oDict:getValue(dep_id)
	if empty(tmp)
		obj:error := codb_error(1100)+":"+dep_id
		obj:number:=space(codb_info("DEPOSIT_ID_LEN"))
	else
		obj:number	:= tmp:number
	endif
	***
	//tmp := str(obj:number,codb_info("DEPOSIT_ID_LEN"),0)
	//tmp := strtran(tmp," ","0")
	obj:id := left(obj:id, codb_info("DICT_ID_LEN"))+obj:number
	***

	obj:counters	:= NIL
	obj:Extents	:= map()
	obj:__objCache	:= map()
	obj:error	:= ""
	obj:oDict	:= oDict
	obj:DictClosing := .f.
	obj:path	:= oDict:path+PATH_DELIM+alltrim(obj:number)
	if empty(obj:number)
		obj:error := codb_error(1141)+":"+toString(dep_id)
	endif

	obj:dictionary	:= @_dep_dict()
	obj:objCRC	:= @_dep_objCRC()
	obj:eval	:= @_dep_eval()
	obj:idList	:= @_dep_IdList() // return object "ID list"
	obj:getValue	:= @_dep_getValue()
	obj:padrObjBody := @_dep_padrObjBody()
	obj:checkObjBody:= @_dep_checkObjBody()
	obj:padrBody	:= @_dep_padrBody()
	obj:checkBody	:= @_dep_checkBody()
	obj:__check_counters:= @__check_counters()

return obj

************************************************************
static function _dep_dict(self)
return self:oDict
************************************************************
static function _dep_objCRC(self,obj)
return ntoc(crc32(var2str(obj)),32,8,"0")
************************************************************
static function _dep_padrObjBody(self,oData,class_desc)
return self:checkObjBody(oData,class_desc, .t.)
************************************************************
static function _dep_padrBody(self,oData,class_id)
return self:checkBody(oData,class_id,.t.)
************************************************************
static function _dep_checkObjBody(self,oData,class_desc,lPadr)
	local i,tmp,body_stru:={}
	for i=1 to len(class_desc:attr_list)
		tmp:=class_desc:attr_list[i]
		tmp:=self:oDict:getValue(tmp)
		if empty(tmp)
			outlog(__FILE__,__LINE__,[Internal error:],"oDict:getvalue("+toString(class_desc:attr_list[i])+")")
			loop
		endif
		aadd(body_stru,{alltrim(upper(tmp:name)),tmp:type,tmp:len,tmp:dec,tmp:lentype,tmp:defValue})
	next
	if lPadr != NIL .and. lPadr
		oData:=codb_padrBody(odata,body_stru)
	else
		oData:=codb_checkBody(odata,body_stru)
	endif
return oData
************************************************************
static function _dep_checkBody(self,oData,class_id,lPadr)
	local ret := map(), tmp,class_desc:=map()

	self:error := ""
	class_id := iif(valtype(class_id)!="C","",class_id)
	if "CLASS_ID" $ oData .and. !empty(oData:class_id)
		class_id := oData:class_id
	endif
	class_desc := self:oDict:getValue(class_id)
	if empty(class_desc)
		tmp:= self:oDict:select("CLASS",0,"void")
		class_id := tmp[1]
		class_desc := self:oDict:getValue(class_id)
	endif
	if empty(class_desc)
		self:error := codb_error(1122)
		return .f.
	endif
	oData:class_id := class_id
	oData := self:checkObjBody(oData,class_desc,lPadr)
return oData
************************************************************
static function _dep_eval(self,Expr,oData)
	local ret,bErr:=errorBlock({|err|break(err)})
	begin sequence
		if isWord(expr) .and. upper(expr) $ oData
			ret := oData[upper(expr)]
		else
			ret := mapEval(oData,expr,self)
		endif
	recover
		self:error := codb_error(1140)+":"+expr
	end sequence
	errorBlock(bErr)
return ret
************************************************************
static function _dep_IdList(self,objId,nIndex,sName,sWhere,nCount,deleted,p1,p2)
return coDb_IdList(self,objId,nIndex,sName,sWhere,nCount,deleted)
************************************************************
static function _dep_GetValue(self,objId,nLocks)
	local ret:=map()
	if nLocks == NIL
		self:error := ""
		if !(valtype(objId) =="C")
			return ret
		endif
		if objId $ self:__objCache
			return self:__objCache[objId]
		endif
		ret := self:_getValue(objId)
	else
		ret := self:_getValue(objId,nLocks)
	endif
return ret
************************************************************
static function __check_counters(self,class_desc,oData)
	local i,oDict, attr,name
	oDict:=self:dictionary()
	for i=1 to len(class_desc:attr_list)
		attr := oDict:getValue(class_desc:attr_list[i])
		if empty(attr) .or. !("COUNTER" $ attr) .or. empty(attr:counter)
			loop
		endif
		name := alltrim(upper(attr:name))
		oData[name] := oDict:counter(attr:counter,self:number,oData[name])
	next
return
