/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual metods for COBRA/CODB driver */

#include "codbcfg.ch"

************************************************************
function codb_dictCobra_Methods(path,dict_id,user,passwd)

	local obj	:= codb_dictAll_Methods(path,dict_id,user,passwd)

	obj:delete	:= @_dict_delete()
	obj:undelete	:= @_dict_undelete()
	obj:append	:= @_dict_append()
	obj:update	:= @_dict_update()
	obj:select	:= @_dict_select() // return array of selected metaData
	obj:getValue	:= @_dict_getValue() // return body for ID
	obj:metaBodyByName:= @_dict_metaBodyByName() // return class ID by name
	obj:classBodyByName:= @_dict_classBodyByName() // return class ID by name
	obj:classByName := @_dict_classBodyByName() // return class ID by name
	obj:classIdByName := @_dict_classIdByName() // return class ID by name
	obj:attrBodyByName:= @_dict_attrBodyByName() // return class ID by name
	obj:attrByName  := @_dict_attrBodyByName() // return class ID by name
	obj:classDesc	:= @_dict_classDesc() // return class description with
					   // all inherites
	obj:counter	:= @_dict_counter() // check and return counter value
	obj:hashName	:= @_dict_hashName() // return string for hashcode
	obj:checkBody	:= @_dict_checkBody()
	obj:create	:= @_dict_create()
	obj:open	:= @_dict_open()
	obj:close	:= @_dict_close()
	//obj:destroy	:= @_dict_close()

return obj
************************************************************
static function _dict_open(self)
	local tmp,i,m,ret
	self:error:=""
	if codb_dict_ref_counter(self:id) > 0
		tmp := codb_dict_reference(self:id)
		m := mapKeys(tmp)
		for i=1 to len(m)
			if valtype(tmp[m[i]]) == "B"
				self[m[i]] := tmp[m[i]]
			else
				self[m[i]] :=@ tmp[m[i]]
			endif
		next
		codb_dict_register(self:id)
		return
	endif
	ret := codb_cobraQuery("DICT_OPEN",self:id)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
	codb_dict_register(self:id,self)
return ret:return
************************************************************
static function _dict_close(self)
	self:error:=""
	codb_dict_unregister(self:id)
return .t.
************************************************************
static function _dict_select(self,metaName,nIndex,sName,sWhere,nCount,deleted)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_SELECT",self:id,metaName,nIndex,sName,sWhere,nCount,deleted)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return {}
	endif
return ret:return
************************************************************
static function _dict_getValue(self,cID)
	local _ret,ret,err,bl
	self:error := ""
	_ret := codb_cobraQuery("DICT_GETVALUE",self:id,cId)
	if !empty(_ret:errno)
		self:error := codb_cobraError(_ret)
		return map()
	endif
	ret := _ret:return
//	outlog(__FILE__,__LINE__,cId,ret)
	if "__META" $ ret .and. alltrim(ret:__meta) == "CLASS"
		if !empty(ret:expr_essence)
			err := errorblock({|_1|break(_1)})
			begin sequence
				bl:="{||"+ret:expr_essence+"}"
				bl:=&bl
			end
			errorBlock(err)
		endif
		if empty(bl)
			ret:_bEssence := NIL
		else
			ret:_bEssence := bl
		endif
		ret:essence :=@class_essence()
	endif
return ret
************************************************************
static function _dict_metaBodyByName(self,metaClass,metaName)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_METABODYBYNAME",self:id,metaClass,MetaName)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return map()
	endif
return ret:return
************************************************************
static function _dict_classBodyByName(self,className)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_CLASSBODYBYNAME",self:id,className)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return map()
	endif
return ret:return
************************************************************
static function _dict_classIdByName(self,className)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_CLASSIDBYNAME",self:id,className)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return map()
	endif
return ret:return
************************************************************
static function _dict_attrBodyByName(self,attrName)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_ATTRBODYBYNAME",self:id,attrName)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return map()
	endif
return ret:return

************************************************************
static function _dict_classDesc(self,cID,aRecursive)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_CLASSDESC",self:id,cId,aRecursive)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return map()
	endif
return ret:return
************************************************************
static function _dict_hashName(self,nHCode)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_HASHNAME",self:id,nHCode)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return ""
	endif
return ret:return
************************************************************
static function _dict_delete(self,cId)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_DELETE",self:id,cId)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function _dict_undelete(self,cId)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_UNDELETE",self:id,cId)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function _dict_append(self,oData,metaName)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_APPEND",self:id,oData,metaName)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return ""
	endif
return ret:return
************************************************************
static function _dict_update(self,oData,metaName,aRecursive)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_UPDATE",self:id,oData,metaName,aRecursive)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return

************************************************************
static function _dict_checkBody(self,oData,metaName,lPadr)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_CHECKBODY",self:id,oData,metaName,lPadr)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return oData
	endif
return ret:return
************************************************************
static function _dict_create(self)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_CREATE",self:id)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function _dict_counter(self,name,deposit,value)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DICT_COUNTER",self:id,name,deposit,value)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return 0
	endif
return ret:return
************************************************************
static function class_essence(self,obj)
	// self is class description
	local ret := ""
	local err
	if valtype(obj) != "O"
		return
	endif
	if valtype(self:_bEssence) == "B"
		err := errorBlock({|x|break(x)})
		begin sequence
			ret := mapEval(obj,self:_bEssence)
		recover
			ret := [Error in expression:]+self:expr_essence
		end sequence
		errorBlock(err)
	else
		if "NAME" $ obj
			ret:= obj:name
		elseif "EMPL_NAME" $ obj
			ret:= obj:empl_name
		elseif "SMALLNAME" $ obj
			ret:= obj:smallname
		elseif "FULLNAME" $ obj
			ret:= obj:fullname
		endif
	endif
return ret

