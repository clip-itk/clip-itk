/*
	Copyright (C) 2004  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual DEPOSITORY metods for COBRA/CODB driver */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_depCobraNew(oDict,dep_id)
	local obj:=codb_depAll_Methods(oDict,dep_id)
	local tmp

	obj:create	:= @_dep_create()
	obj:open	:= @_dep_open()
	obj:delete	:= @_dep_delete()
	obj:unDelete	:= @_dep_unDelete()
	obj:append	:= @_dep_append()
	obj:update	:= @_dep_update()
	obj:id4PrimaryKey:= @_dep_id4PrimaryKey()
	obj:addExtent	:= @_dep_addExtent()
	obj:close	:= @_dep_close()
	//obj:destroy	:= @_dep_close()

	obj:_getValue	:= @_dep__getValue()
	obj:select	:= @_dep_select()

return obj

************************************************************
static function _dep_delete(self,cId)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP_DELETE",self:id,cId)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function _dep_unDelete(self,cId)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP_UNDELETE",self:id,cId)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function _dep_append(self,oData,class_id)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP_APPEND",self:id,oData,class_id)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return ""
	endif
return ret:return
************************************************************
static function _dep_update(self,oData)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP_UPDATE",self:id,oData)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function _dep_id4PrimaryKey(self,classname,keyName,keyValue,lList)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP_ID4PRIMARYKEY",self:id,classname,keyName,keyValue,lList)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return ""
	endif
return ret:return
************************************************************
static function _dep__GetValue(self,objId,nLocks)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP__GETVALUE",self:id,objId,nLocks)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return map()
	endif
return ret:return
************************************************************
static function _dep_select(self,class_Id,nIndex,sName,sWhere,nCount,deleted)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP_SELECT",self:id,class_Id,nIndex,sName,sWhere,nCount,deleted)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return {}
	endif
return ret:return

************************************************************
static function _dep_close(self)
	self:error:=""
	codb_dict_unregister(self:id)
return .t.
************************************************************
static function _dep_open(self)
	local ret,tmp,i,m
	self:error:=""
	if codb_dep_ref_counter(self:id) > 0
		tmp := codb_dep_reference(self:id)
		m := mapKeys(tmp)
		for i=1 to len(m)
			if valtype(tmp[m[i]]) == "B"
				self[m[i]] := tmp[m[i]]
			else
				self[m[i]] :=@ tmp[m[i]]
			endif
		next
		codb_dep_register(self:id)
		return
	endif
	ret := codb_cobraQuery("DEP_OPEN",self:id)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
	codb_dep_register(self:id,self)
return .t.
************************************************************
static function _dep_create(self)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP_CREATE",self:id)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function _dep_addExtent(self,ext_id)
	local ret
	self:error := ""
	ret := codb_cobraQuery("DEP_ADDEXTENT",self:id,ext_id)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return

