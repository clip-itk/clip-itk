/*
	Copyright (C) 2004  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual DEPOSITORY metods for all CODB drivers */

#include "codbcfg.ch"
#include "codb_dbf.ch"

static __objCache := map()

************************************************************
function codb_depAll_Methods(oDict,dep_id)
	local obj:=map(),tmp
	obj:classname	:= "CODBDEPOSITORY"
	obj:id		:= dep_id 	// padl(alltrim(dep_id),codb_info("DEPOSIT_ID_LEN"),"0")
	tmp		:= oDict:getValue(dep_id)
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
	//obj:__objCache	:= map()
	obj:__profile	:= map()
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
	obj:update	:= @_dep_update()
	obj:delete	:= @_dep_delete()
	obj:undelete	:= @_dep_undelete()
	obj:padrObjBody := @_dep_padrObjBody()
	obj:checkObjBody:= @_dep_checkObjBody()
	obj:padrBody	:= @_dep_padrBody()
	obj:checkBody	:= @_dep_checkBody()
	obj:runTrigger	:= @_dep_runTrigger()
	obj:needExtent	:= @_dep_needExtent()
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
static function _dep_delete(self,cId,lErase,class_id)
	local ret, dFlag := set(_SET_DELETED)
	taskStop()
	set(_SET_DELETED, .f.)
	adel(__objCache,cId)
	ret := self:_delete(cId,lErase,class_id)
	set(_SET_DELETED,dFlag)
	taskStart()
return ret
************************************************************
static function _dep_undelete(self,cId)
	local ret
	taskStop()
	adel(__objCache,cId)
	ret := self:_undelete(cId)
	taskStart()
return ret
************************************************************
static function _dep_update(self,oData)
	local ret,cId
	if "ID" $ oData
		cId := oData:id
	endif
	if empty(cId)
		self:error := codb_error(1139)
		return .f.
	endif
	adel(__objCache,cId)
	taskStop()
	ret := self:_update(oData)
	taskStart()
return ret
************************************************************
static function _dep_checkObjBody(self,oData,class_desc,lPadr)
	static bodies := map(),crcs:=map()
	local i,crc,name,tmp,body_stru:={}
	name := class_desc:name
	crc := crc32(var2str(class_desc))
	if name $ crcs .and. crc != crcs[name]
		adel(crcs,name)
		adel(bodies,name)
	endif
	if name $ bodies
		body_stru := bodies[name]
	else
		//outlog(__FILE__,__LINE__,class_desc:name,crc)
		for i=1 to len(class_desc:attr_list)
			tmp:=class_desc:attr_list[i]
			tmp:=self:oDict:getValue(tmp)
			if empty(tmp)
				outlog(__FILE__,__LINE__,[Internal error:],"oDict:getvalue("+toString(class_desc:attr_list[i])+")")
				loop
			endif
			aadd(body_stru,{alltrim(upper(tmp:name)),tmp:type,tmp:len,tmp:dec,tmp:lentype,tmp:defValue})
		next
		bodies[name] := body_stru
		crcs[name] := crc
	endif
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
static function _dep_GetValue(self,cId,nLocks,version)
	local ret:=map(), dFlag := set(_SET_DELETED)

	self:error := ""
	if !(valtype(cId) =="C")
		return ret
	endif
	cID := padr(cID,codb_info("CODB_ID_LEN"))
	if !empty(version) .or. nLocks != NIL
		adel(__objCache,cId)
	endif
	if cId $ __objCache
		return __objCache[cId]
	endif

	taskStop()
	set(_SET_DELETED, .f.)
	ret := self:_getValue(cId,nLocks,version)
	set(_SET_DELETED,dFlag)
	taskStart()

	if len(__objCache) > CODB_DEP_CACHE
		codb_cache_minimize(__objCache, CODB_DEP_CACHE/4 )
	endif
	if empty(ret)
		return ret
	endif
	__objCache[cId] := ret
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
************************************************************
static function _dep_needExtent(self,ext_id)
return self:extenOpen(ext_id)
************************************************************
static function _dep_runTrigger(self,cId,cTrigger,newData,oldData)
	local ret:=.t.,i,m, tret
	if self:oDict==NIL .or. !self:oDict:__enableTriggers
		return .t.
	endif
	m := self:oDict:getTriggers(cId,cTrigger)
	for i=1 to len(m)
		tret := eval(m[i],self,newData,oldData)
		ret := ret .and. ( valtype(tret)=="L" .and. tret)
	next
return ret

