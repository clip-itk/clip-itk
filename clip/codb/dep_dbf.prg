/*
	Copyright (C) 2004  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual DEPOSITORY metods for DBF/CODB driver */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_depDbfNew(oDict,dep_id)
	local obj:=codb_depAll_Methods(oDict,dep_id)
	local tmp

	obj:hDbIdxTbl   := NIL

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
	obj:selectDebug	:= @_dep_selectDebug()

	obj:extentOpen	:= @_ext_open()
	obj:extentOpenAll:= @_ext_openAll()

return obj

************************************************************
static function _dep_delete(self,cId,lErase)
	local oData,old,class_id,class_desc,oExt,extent_id,idxData

	lErase := iif(lErase == NIL, .f. , lErase)

	self:error := ""
	oData:=self:_getValue(cId)
	adel(self:__objCache,cId)
	if empty(oData)
		self:error := codb_error(1123)
		return .f.
	endif
	if "CLASS_ID" $ oData .and. !empty(oData:class_id)
		class_id := oData:class_id
	endif
	class_desc := self:oDict:getValue(class_id)
	if empty(class_desc)
		self:error := codb_error(1122)
		return .f.
	endif
	self:runTrigger(class_id,"BEFORE_DELETE_OBJECT",oData)

	taskStop()
	rddSeek(self:hDbIdxTbl,cId,.f.)
	idxData := rddRead(self:hDbIdxTbl)
	if idxData:object_id == cId
		extent_id := idxData:extent_id
	else
		taskStart()
		self:error := codb_error(1124)+":"+cId
		return .f.
	endif

	oExt := self:extentOpen(extent_id)
	if oExt == NIL
		self:error := codb_error(1121)+":"+extent_id
		taskStart()
		return .f.
	endif
	if !waitRddLock(self:hDbIdxTbl)
		self:error := codb_error(1005)+":"+cId
		taskStart()
		return .f.
	endif
	idxData := rddRead(self:hDbIdxTbl)
	if empty(class_desc:unique_key) .or. lErase
		if ! oExt:delete(cId,idxData:version)
			self:error := oExt:error
		endif
		rddDelete(self:hDbIdxTbl)
	else
		old := idxData:version
		if idxData:version >= 0
			idxData:version := -1
		else
			idxData:version --
		endif
		idxData:version := max(idxData:version,-90)
		if ! oExt:changeVersion(cId,old,idxData:version)
			self:error := oExt:error
		else
			rddWrite(self:hDbIdxTbl,idxData)
		endif
	endif
	rddUnlock(self:hDbIdxTbl)
	taskStart()

	if !empty(self:error)
		return .f.
	endif
	self:runTrigger(class_id,"AFTER_DELETE_OBJECT",oData)
	if "LOG_NEED" $ class_desc .and. class_desc:log_need
		codb_outlog(self:oDict:user,"delete",oData)
	endif
return .t.
************************************************************
static function _dep_unDelete(self,cId)
	local oData,old,class_id,class_desc,oExt,extent_id,idxData
	self:error := ""
	oData:=self:_getValue(cId)
	adel(self:__objCache,cId)
	if empty(oData)
		self:error := codb_error(1123)
		return .f.
	endif
	if "CLASS_ID" $ oData .and. !empty(oData:class_id)
		class_id := oData:class_id
	endif
	class_desc := self:oDict:getValue(class_id)
	if empty(class_desc)
		self:error := codb_error(1122)
		return .f.
	endif
	self:runTrigger(class_id,"BEFORE_UNDELETE_OBJECT",oData)

	taskStop()
	rddSeek(self:hDbIdxTbl,cId,.f.)
	idxData := rddRead(self:hDbIdxTbl)
	if idxData:object_id == cId
		extent_id := idxData:extent_id
	else
		taskStart()
		self:error := codb_error(1124)+":"+cId
		return .f.
	endif

	oExt := self:extentOpen(extent_id)
	if oExt == NIL
		self:error := codb_error(1121)+":"+extent_id
		taskStart()
		return .f.
	endif
	if !waitRddLock(self:hDbIdxTbl)
		self:error := codb_error(1005)+":"+cId
		taskStart()
		return .f.
	endif
	idxData := rddRead(self:hDbIdxTbl)
	old := idxData:version
	if old < 0
		idxData:version := oExt:maxVersion(cId,old,idxData:version)+1
		if ! oExt:changeVersion(cId,old,idxData:version)
			self:error := oExt:error
		else
			rddWrite(self:hDbIdxTbl,idxData)
		endif
	endif
	rddUnlock(self:hDbIdxTbl)
	taskStart()

	if !empty(self:error)
		return .f.
	endif
	self:runTrigger(class_id,"AFTER_UNDELETE_OBJECT",oData)
	if "LOG_NEED" $ class_desc .and. class_desc:log_need
		codb_outlog(self:oDict:user,"undelete",oData)
	endif
return .t.
************************************************************
static function _dep_append(self,oData,class_id)
	local ret := .t., cId:="",rec:=map(), i
	local tmp,sData,oExt,class_desc:=map()
	local keyValue

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
		return ""
	endif
	oExt := self:extentOpen(class_desc:extent_id)
	if oExt == NIL
		self:error := codb_error(1121)+":"+class_desc:extent_id
		return ""
	endif

	oData := self:checkObjBody(oData,class_desc)

	if "UNIQUE_KEY" $ class_desc .and. !empty(class_desc:unique_key)
		/* check unique value */
		keyValue:=self:eval(class_desc:unique_key,oData)
		/*
		if empty(keyValue)
			self:error += " (unique_key in class "+class_desc:name+")"
			return ""
		endif
		*/
		tmp := self:id4PrimaryKey(class_desc:name,class_desc:unique_key,keyValue,.t.)
		if !empty(tmp)
			self:error := codb_error(1143)+":"+toString(keyValue)
			return ""
		endif
	endif

	cId := self:counters:addvalue("OBJECT")
	cId := padl(alltrim(ntoc(cId,32)),codb_info("OBJECT_ID_LEN"),"0")
	cId := self:oDict:id + self:number + cId
	oData:id:= cId
	oData:class_id := class_id
	if "HAVE_COUNTERS" $ class_desc .and. class_desc:have_counters
		self:__check_counters(class_desc,oData)
	endif

	self:runTrigger(class_id,"BEFORE_APPEND_OBJECT",oData)
	aDel(oData,"__VERSION")
	aDel(oData,"__CRC32")
	if ! oExt:append(oData,0)
		self:error := oExt:error
		if empty(self:error)
			self:error := codb_error(1199)
		endif
		return ""
	endif

	/* add data to IDXTABLE */
	rec:=map()
	rec:object_id := cId
	rec:class_id  := class_id
	rec:extent_id := class_desc:extent_id
	rec:version   := 0
	rec:crc32     := self:objCRC(oData)
	taskStop()
	/* DATAx !!!! */
	for i:=1 to len(class_desc:idx_list)
		sdata:="DATA"+alltrim(str(i,2,0))
		tmp:=self:oDict:getValue(class_desc:idx_list[i])
		if empty(tmp)
			outlog(3,"Index #",alltrim(str(i,2,0)),"for class",class_desc:name,"don`t have description")
			loop
		endif
		tmp:=alltrim(tmp:expr)
		tmp := self:eval(tmp,oData)
		//if tmp!=NIL
			rec[sdata]:=tmp
		//endif

	next
	//outlog(__FILE__,__LINE__,rec)
	rddAppend(self:hDbIdxTbl,rec)
	rddSkip(self:hDbIdxTbl,0)
	taskStart()
	if !empty(self:error)
		return ""
	endif
	if "LOG_NEED" $ class_desc .and. class_desc:log_need
		codb_outlog(self:oDict:user,"append",oData)
	endif
	self:runTrigger(class_id,"AFTER_APPEND_OBJECT",oData)
return cId
************************************************************
static function _dep_update(self,oData)
	local ret := .t., cId:="",rec:=map(), i
	local tmp,sData,oExt,class_desc:=map()
	local class_id,oldData,extent_id,idxData
	local keyValue1,keyValue2,x,changed

	self:error := ""
	if "ID" $ oData
		cId := oData:id
	endif
	if empty(cId)
		self:error := codb_error(1139)
		return .f.
	endif
	oldData := self:_getValue(cId)
	oData := o2update(oData,oldData)
	adel(self:__objCache,cId)

	if "CLASS_ID" $ oData .and. !empty(oData:class_id)
		class_id := oData:class_id
	endif
	class_desc := self:oDict:getValue(class_id)
	if empty(class_desc)
		self:error := codb_error(1122)
		return .f.
	endif
	if "UNIQUE_KEY" $ class_desc .and. !empty(class_desc:unique_key)
		/* check unique value */
		keyValue1:=self:eval(class_desc:unique_key,oData)
		keyValue2:=self:eval(class_desc:unique_key,oldData)
		if ! (keyValue1 == keyValue2)
			tmp := self:id4PrimaryKey(class_desc:name,class_desc:unique_key,keyValue1,.t.)
			x := ascan(tmp,oData:id)
			if x!=0 .or. empty(tmp)
			else
				self:error := codb_error(1143)+":"+toString(keyValue1)
				return .f.
			endif
		endif
	endif
	oData := self:checkObjBody(oData,class_desc)
	self:runTrigger(class_id,"BEFORE_UPDATE_OBJECT",oData,oldData)

	taskstop()
	rddSeek(self:hDbIdxTbl,cID,.f.)
	idxData := rddRead(self:hDbIdxTbl)
	if idxData:object_id == cId
		extent_id := idxData:extent_id
	else
		taskStart()
		self:error := codb_error(1124)+":"+cId
		return .f.
	endif
	oExt := self:extentOpen(extent_id)
	if oExt == NIL
		self:error := codb_error(1121)+":"+extent_id
		taskStart()
		return .f.
	endif

	aDel(oData,"__VERSION")
	aDel(oData,"__CRC32")
	aDel(oldData,"__VERSION")
	aDel(oldData,"__CRC32")
	changed := !(self:objCRC(oData) == self:objCRC(oldData)) //varChanged(oData,oldData)
	if !changed .and. !class_desc:unstable
		taskStart()
		return .t.
	elseif idxData:version > 50
		outlog(0,"Object version more than 50")
		outlog(0,"old object",oldData)
		outlog(0,"new object",oData)
	endif
	/* update data to IDXTABLE */
	if !waitRddLock(self:hDbIdxTbl)
		self:error := codb_error(1005)+":"+oData:id
		taskStart()
		return .f.
	endif
	idxData := rddRead(self:hDbIdxTbl)
	idxData:object_id := oData:id
	idxData:class_id  := oData:class_id
	idxData:extent_id := extent_id
	idxData:crc32     := self:objCRC(oData)
	/* DATAx !!!! */
	for i:=1 to len(class_desc:idx_list)
		sdata:="DATA"+alltrim(str(i,2,0))
		tmp:=self:oDict:getValue(class_desc:idx_list[i])
		if empty(tmp)
			outlog(3,"Index #",alltrim(str(i,2,0)),"for class",class_desc:name,"don`t have description")
			loop
		endif
		tmp:expr:=alltrim(tmp:expr)
		idxData[sdata]:=self:eval(tmp:expr,oData)
	next
	if empty(class_desc:unique_key) .or. idxData:version < 0 .or. idxData:version >= 900
		if ! oExt:update(oData,idxData:version)
			self:error := oExt:error
			rddUnlock(self:hDbIdxTbl)
			taskStart()
			return .f.
		else
			rddWrite(self:hDbIdxTbl,idxData)
		endif
	else
		idxData:version++
		idxData:version := min(idxData:version,900)
		if ! oExt:append(oData,idxData:version)
			self:error := oExt:error
			rddUnlock(self:hDbIdxTbl)
			taskStart()
			return .f.
		else
			rddWrite(self:hDbIdxTbl,idxData)
		endif

	endif
	rddUnlock(self:hDbIdxTbl)
	taskStart()
	if !empty(self:error)
		return .f.
	endif
	if "LOG_NEED" $ class_desc .and. class_desc:log_need
		codb_outlog(self:oDict:user,"update",oData)
	endif
	oData := self:_getValue(cId)
	self:runTrigger(class_id,"AFTER_UPDATE_OBJECT",oData,oldData)
return .t.
************************************************************
static function _dep_id4PrimaryKey(self,classname,keyName,keyValue,lList)
	local i,r,ret := "",s,s1,s2
	local tmp,iTmp,nIndex:=-1,sIndex
	local class_desc:=map(),class_id

	if empty(classname) .or. empty(keyName) //.or. empty(keyValue)
		return ret
	endif
	lList := iif(lList == NIL, .f. ,.t.)
	ret := iif(lList,{},"")

	class_desc := self:oDict:getValue(className)
	if empty(class_desc)
		tmp:=self:oDict:select("CLASS",,classname)
		if empty(tmp)
			return ret
		endif

		class_desc := self:oDict:getValue(tmp[1])
		if empty(class_desc)
			return ret
		endif
	endif
	class_id:=class_desc:id

	for i=1 to len(class_desc:idx_list)
		iTmp:=self:oDict:getValue(class_desc:idx_list[i])
		if empty(iTmp)
			outlog(__FILE__,__LINE__,[Internal error:],"oDict:getvalue("+toString(class_desc:attr_list[i])+")")
			loop
		endif
		if upper(iTmp:name) == upper(keyName)
			nIndex:=i
			exit
		endif
	next
	if nIndex <0
		return ret
	endif

	/* seek data in IDXTABLE */
	sIndex := "data"+alltrim(str(nIndex,2,0))
	s:="class_id=='"+class_id+"'"

	taskstop()

	/* based on "set scope" */
	s1:=rdd_m6_newfilter(self:hDbIdxTbl)
	s2:=rdd_m6_newfilter(self:hDbIdxTbl)
	rdd_m6_addScoped(self:hDbIdxTbl,s1,class_id,class_id,3)
	rdd_m6_addScoped(self:hDbIdxTbl,s2,keyValue,keyValue,3+nIndex)
	m6_FiltJoin(s1,s2,2)
	rdd_m6_setAreaFilter(self:hDbIdxTbl,s1)
	rddGotop(self:hDbIdxTbl)
	while !rddEof(self:hDbIdxTbl)
		if rddGetValue(self:hDbIdxTbl,sIndex) == keyValue
			r := rddGetValue(self:hDbIdxTbl,"object_id")
			if lList
				aadd(ret,r)
			else
				ret := r
				exit
			endif
		endif
		rddSkip(self:hDbIdxTbl)
	enddo
	rddClearFilter(self:hDbIdxTbl)
	taskStart()
return ret
************************************************************
static function _dep__GetValue(self,objId,nLocks)
	local i:=0,ret:=map(),idxData,oExt,class_desc

	self:error := ""
	if !(valtype(objId) =="C")
		return ret
	endif
	taskStop()
	if !rddSeek(self:hDbIdxTbl,objID,.f.)
		taskStart()
		return ret
	endif
	idxData := rddRead(self:hDbIdxTbl)
	taskStart()

	if !(idxData:object_id == objId)
		return ret
	endif

	oExt := self:extentOpen(idxData:extent_id)
	if oExt == NIL
		return ret
	endif

	while (i++) < 10
		ret := oExt:getValue(objId,nLocks,idxData:version)
		if valtype(ret) == "O" .and. "CLASS_ID" $ ret
			exit
		endif
		outlog(__FILE__,__LINE__,"Undefined problem for loading object:",objId)
		sleep(0.02)
	enddo

	if valtype(ret) != "O"
		ret := map()
		ret:id := objId
		ret:class_id := idxData:class_id
		class_desc := self:oDict:getValue(ret:class_id)
		ret := self:checkObjBody(ret,class_desc)
	endif
	if !empty(ret)
		class_desc := self:oDict:getValue(ret:class_id)
		if !empty(class_desc) .and. class_desc:unstable
			ret := self:checkObjBody(ret,class_desc)
		endif
		if empty(idxData:crc32)
			idxData:crc32 := self:objCRC(ret)
		endif
		ret:__version := idxData:version
		ret:__crc32   := idxData:crc32
	endif
	if "CLASS_ID" $ ret
	else
		return map()
	endif
	if len(self:__objCache) > CODB_DEP_CACHE
		codb_cache_minimize(self:__objCache, CODB_DEP_CACHE/4 )
	endif
	self:__objCache[objId] := ret
	self:runTrigger(ret:class_id,"AFTER_GETVALUE_OBJECT",ret)
return ret
************************************************************
static function _ext_Open(self,ext_id)
	local oExt
	self:error := ""
	if empty(ext_id)
		self:error := codb_error(1142)
		return
	endif
	if ext_id $ self:extents
		oExt := self:Extents[ext_id]
	else
		oExt:=codb_extDbfNew(self,ext_id)
		oExt:open()
		if !empty(oExt:error)
			self:error := oExt:error
			oExt:close()
			oExt := NIL
		else
			self:Extents [ext_id] := oExt
		endif
	endif
return oExt
************************************************************
static function _ext_OpenAll(self)
	local i,tmp,oDict,oExt,ext_id
	self:error := ""
	oDict := self:dictionary()
	tmp := oDict:select("EXTENT")
	for i=1 to len(tmp)
		ext_id := tmp[i]
		if ext_id $ self:extents
			loop
		endif
		oExt:=codb_extDbfNew(self,ext_id)
		oExt:open()
		if !empty(oExt:error)
			self:error := oExt:error
			oExt:close()
			oExt := NIL
		else
			self:Extents [ext_id] := oExt
		endif
	next
return empty(self:error)
************************************************************
static function _dep_selectDebug(self,class_Id,nIndex,sName,sWhere,nCount)
	local tmp1,tmp2,set:=set(_SET_OPTIMIZE)
	tmp1:=self:select(class_Id,nIndex,sName,sWhere,nCount)
	set(_SET_OPTIMIZE,!set)
	tmp2:=self:select(class_Id,nIndex,sName,sWhere,nCount)
	outlog("select debug begin:",class_id,nIndex,sWhere,nCount)
	outlog("select debug tmp1=",tmp1)
	outlog("select debug tmp1=",tmp2)
	if len(tmp1) != len(tmp2)
		while .t.
		? "begin select debug cycle:"
		inkey(0)
		set(_SET_OPTIMIZE,set)
		tmp1:=self:select(class_Id,nIndex,sName,sWhere,nCount)
		set(_SET_OPTIMIZE,!set)
		tmp2:=self:select(class_Id,nIndex,sName,sWhere,nCount)
		outlog("select debug cycle:",class_id,nIndex,sWhere,nCount)
		outlog("select debug tmp1=",tmp1)
		outlog("select debug tmp2=",tmp2)
		sleep(1)
		end
	endif
	set(_SET_OPTIMIZE,set)
	outlog("select debug retur:",tmp1)
return tmp1
************************************************************
static function _dep_select(self,class_Id,nIndex,sName,sWhere,nCount,deleted)
	static wrap:=map()
	local ret:={},sIndex,s:=""
	local tmp,class_desc,i,aWrapNames:={}
	self:error := ""
	if deleted == NIL .or. valtype(deleted) != "L"
		deleted := .f.
	endif
	if !empty(class_id)
		s+='CLASS_ID=="'+class_Id+'"'
	endif
	if sName != NIL
		if !empty(s)
			s+=" .and. "
		endif
		s+='NAME=="'+sName+'"'
	endif
	if !empty(sWhere)
		if !empty(s)
			s+=" .and. "
		endif
		s+=sWhere
	endif
	if class_id $ wrap
		aWrapNames := wrap[class_id]
	else
		class_desc:=self:oDict:getValue(class_id)
		if !empty(class_desc)
			for i=1 to len(class_desc:idx_list)
				sIndex:="DATA"+alltrim(str(i,2,0))
				tmp:=self:oDict:getValue(class_desc:idx_list[i])
				if !empty(tmp)
					aadd(aWrapNames,{tmp:expr,sIndex})
				else
					outlog(3,"Index #",alltrim(str(i,2,0)),"for class",class_desc:name,"don`t have description")
				endif
				if valtype(nIndex) == "C" .and. nIndex==tmp:name
					nIndex := i
				endif
			next
		endif
		wrap[class_id] := aWrapNames
	endif
	self:runTrigger(class_id,"BEFORE_SELECT_OBJECT",class_id,nIndex,sWhere)
	if empty(s) //.or. empty(aWrapNames)
		return ret
	endif
	taskstop()
	rddSetFilter(self:hDbIdxTbl,s,aWrapNames)

	if nIndex!=NIL .and. nIndex>0
		sIndex := "data"+alltrim(str(nIndex,2,0))
		rddSetOrder(self:hDbIdxTbl,sIndex)
	endif
	if nCount == NIL
		rddGoTop(self:hDbIdxTbl)
		while !rddEof(self:hDbIdxTbl)
			if deleted .or. rddGetvalue(self:hDbIdxTbl,"VERSION") >= 0
				aadd(ret,rddGetvalue(self:hDbIdxTbl,"OBJECT_ID"))
			endif
			rddSkip(self:hDbIdxTbl)
		end
	elseif nCount>0
		i:=0
		rddGoTop(self:hDbIdxTbl)
		while !rddEof(self:hDbIdxTbl) .and. i<nCount
			if deleted .or. rddGetvalue(self:hDbIdxTbl,"VERSION") >= 0
				aadd(ret,rddGetvalue(self:hDbIdxTbl,"OBJECT_ID"))
				i++
			endif
			rddSkip(self:hDbIdxTbl)
		end
	else
		i:=0
		rddGoBottom(self:hDbIdxTbl)
		while !rddEof(self:hDbIdxTbl) .and. i>nCount
			if deleted .or. rddGetvalue(self:hDbIdxTbl,"VERSION") >= 0
				aadd(ret,rddGetvalue(self:hDbIdxTbl,"OBJECT_ID"))
				i--
			endif
			rddSkip(self:hDbIdxTbl,-1)
		end
	endif
	rddClearFilter(self:hDbIdxTbl)
	rddSetOrder(self:hDbIdxTbl,"object_id")
	taskStart()
	self:runTrigger(class_id,"AFTER_SELECT_OBJECT",class_id,nIndex,sWhere)
return ret
************************************************************

static function	__rddSetFilter(p1,p2,p3)
return	rddSetFilter(p1,p2,p3)

************************************************************
static function _dep_close(self)
	local i
	self:error := ""
	if "ID" $ self
		if codb_dep_ref_counter(self:id) > 1
			codb_dep_unregister(self:id)
			if self:DictClosing
				self:oDict:close()
			endif
			return .t.
		endif
		if codb_dep_ref_counter(self:id) <= 0
			return .t.
		endif
	endif
	self:runTrigger(self:id,"BEFORE_CLOSE_DEPOSITORY")
	if self:counters != NIL
		self:counters:close()
		self:counters:=NIL
	endif
	if self:hDbIdxTbl != NIL
		rddCloseArea(self:hDbIdxTbl)
		self:hDbIdxTbl := NIL
	endif
	if self:Extents !=NIL
		for i in self:Extents
			i:close()
		next
		self:Extents := NIL
	endif
	self:Extents := NIL
	codb_dep_unregister(self:id)
	if self:DictClosing
		self:oDict:close()
	endif
	self:runTrigger(self:id,"AFTER_CLOSE_DEPOSITORY")
return .t.
************************************************************
static function _dep_open(self)
	local ver,hf,dbfile,tmp,i,m
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
	dbfile:=self:path+PATH_DELIM+".version"
	hf:=fopen(dbfile,0)
	if hf<0
		self:error:=codb_error(1120)
		return .f.
	endif
	ver:=freadstr(hf,100)
	fclose(hf)
	if !(ver==CODB_VERSION)
		self:error:=codb_error(1025)
		return .f.
	endif

	self:counters := codb_countDbfNew(self:path)
	self:counters:open()
	if !empty(self:counters:error)
		self:error:=codb_error(1125)+":"+self:counters:error
		return .f.
	endif

	/* open data index table */
	dbFile:=self:path+PATH_DELIM+"dataidx"
	self:hDbIdxTbl:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,,.f.)
	if self:hDbIdxTbl<=0
		self:hDbIdxTbl:=NIL
		self:error:=codb_error(1128)+":"+str(ferror(),3,0)+":"+ferrorstr()
		return .f.
	endif
	rddSetIndex(self:hDBIdxTbl,CODB_IDRIVER_DEFAULT,dbFile)
	rddSetOrder(self:hDbIdxTbl,"object_id")

	codb_dep_register(self:id,self)
return .t.
************************************************************
static function _dep_create(self)
	local tmp,tmp1
	self:error := ""
	if !makeDirectory(self:path)
		self:error:=codb_error(1108)+":"+self:path
		return .f.
	endif
	if !_dep_make_version(self)
		return .f.
	endif
	self:counters := codb_countDbfNew(self:path)
	if !self:counters:create()
		self:error := self:counters:error
		return .f.
	endif
	if self:counters:open()
		self:counters:append("OBJECT","Counter for all object ID`s")
	else
		self:error := codb_error(1104)
	endif
	self:counters:close()
	self:counters := NIL

	if !_dep_make_IdxTable(self)
		return .f.
	endif

	self:close()
return .t.
************************************************************
static function _dep_addExtent(self,ext_id)
	local hdb,dbfile,msize,oDict,tmp
	self:error := ""
	ext_id := alltrim(ext_id)
	if empty(ext_id)
		self:error := codb_error(1129)
		return .f.
	endif
	dbfile:=self:path+PATH_DELIM+ext_id
	if file(dbfile+".dbf")
		self:error := codb_error(1130)+":"+dbfile
		return .f.
	endif

	taskstop()

	oDict:=self:dictionary()
	tmp:=oDict:getValue(self:id)
	if !empty(tmp)
		mSize := tmp:memosize
	endif
	if empty(mSize) .or. mSize<32
		mSize := CODB_MEMOSIZE_DEFAULT
	endif
	set(_SET_MBLOCKSIZE,mSize)

	dbCreate(dbfile,CODB_EXTENT_STRUCTURE)
	hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,,.f.)
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"object_id","object_id")
/*
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"class_id" ,"class_id")
*/
	rddCloseArea(hDB)
	taskStart()

return .t.

************************************************************
static function _dep_make_IdxTable(self)
	local hdb,dbfile,stru
	local i,str

	*************** create table with references
	dbfile:=self:path+PATH_DELIM+"dataidx"
	stru := CODB_IDXTABLE_STRUCTURE
	for i=1 to CODB_IDX_PER_CLASS
		str:="DATA"+alltrim(str(i,2,0))
		if i<=2
			aadd(stru,{str,"X",CODB_IDX_DATALENGTH+12,0} )
		elseif i<=5
			aadd(stru,{str,"X",CODB_IDX_DATALENGTH+2,0} )
		else
			aadd(stru,{str,"X",CODB_ID_LEN+2,0} )
		endif
	next
	dbCreate(dbfile,stru)
	hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,.f.,.f.)
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"object_id","object_id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"extent_id","extent_id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"class_id" ,"class_id")
	for i=1 to CODB_IDX_PER_CLASS
		str:="data"+alltrim(str(i,2,0))
		//rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,str,str,,.t.,str+"!=NIL")
		rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,str,str,,.t.)
	next
	rddCloseArea(hDB)
return .t.

************************************************************
static function _dep_make_version(self)
	local hf,dbfile
	self:error := ""
	dbfile:=self:path+PATH_DELIM+".version"
	if file(dbFile)
		return .f.
		self:error := codb_error(1101)+":"+self:path
	endif
	hf:=fcreate(dbfile)
	if hf<0
		self:error := codb_error(1102)+":"+dbfile+":"+str(ferror(),2,0)+":"+ferrorstr()
		return .f.
	endif
	fwrite(hf,CODB_VERSION)
	fclose(hf)
return .t.
