/*
	Copyright (C) 2004  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual DEPOSITORY metods for DBF/CODB driver */

#include "inkey.ch"
#include "codbcfg.ch"
#include "codb_dbf.ch"

//#define PROFILE

************************************************************
function codb_depDbfNew(oDict,dep_id)
	local obj:=codb_depAll_Methods(oDict,dep_id)
	local tmp

	obj:hDbRefTbl   := NIL

	obj:create	:= @_dep_create()
	obj:makeTables	:= @_dep_makeTables()
	obj:makeIndies	:= @_dep_makeIndies()
	obj:open	:= @_dep_open()
	obj:_delete	:= @_dep__delete()
	obj:unDelete	:= @_dep_unDelete()
	obj:append	:= @_dep_append()
	obj:update	:= @_dep_update()
	obj:moveExtent	:= @_dep_moveExtent()
	obj:id4PrimaryKey:= @_dep_id4PrimaryKey()
	obj:addExtent	:= @_dep_addExtent()
	obj:close	:= @_dep_close()
	//obj:destroy	:= @_dep_close()

	obj:_getValue	:= @_dep__getValue()
	obj:select	:= @_dep_select()

	obj:extentOpen	:= @_ext_open()
	obj:extentOpenAll:= @_ext_openAll()

return obj

************************************************************
static function _dep_moveExtent(self,class_id,oldExt,newExt, lOut)
	local rec,oExt1,oExt2,obj

	oExt1 := self:extentOpen(oldExt)
	oExt2 := self:extentOpen(newExt)

	if empty(oExt1) .or. empty(oExt2)
		self:error := codb_error(1121)+":"+oldExt+"/"+newExt
		taskStart()
		return .f.
	endif

	lOut := iif(valtype(lOut)=="L", lOut, .f. )

	if lOut
		? "Moving objects",class_id,"from extent",oldExt,"to extent",newExt,space(20)
	endif
	taskStop()
	rddGotop(self:hDbRefTbl)
	while !rddEof(self:hDbRefTbl)
		if !waitRddLock(self:hDbRefTbl)
			self:error := codb_error(1005)+":"+rec:object_id+":dep,line:"+alltrim(str(__LINE__))
			rddSkip(self:hDbRefTbl)
			loop
		endif
		rec := rddRead(self:hDbRefTbl)
		if ! (rec:class_id == class_id)
			rddSkip(self:hDbRefTbl)
			loop
		endif
		if ! (rec:extent_id == oldExt)
			rddSkip(self:hDbRefTbl)
			loop
		endif
		if lOut
			?? replicate(chr(K_BS),13),rec:object_id
		endif
		/* get full record structure */
		obj:=oExt1:getValue(rec:object_id,,,.t.)
		if empty(obj)
			outlog(__FILE__,__LINE__,"Error loading object",rec)
			rddSkip(self:hDbRefTbl)
			loop
		endif
		rec:extent_id := newExt
		if oExt2:append(obj,,.t.)
			oExt1:delete(rec:object_id,.t.)
			rddWrite(self:hDbRefTbl,rec)
		endif

		rddUnlock(self:hDbRefTbl)
		rddSkip(self:hDbRefTbl)
	enddo
	taskStart()
return .t.

************************************************************
static function _dep__delete(self,cId,lErase,class_id)
	local oData,old,class_desc,oExt,refData
	local lDeleted := .f.

	lErase := iif(valtype(lErase) == "L", lErase, .f.)

	self:error := ""
	oData:=self:_getValue(cId)
	adel(self:__objCache,cId)
	if empty(oData)
		self:error := codb_error(1123)
	endif
	if "CLASS_ID" $ oData .and. !empty(oData:class_id)
		class_id := oData:class_id
	endif
	if empty(class_id)
		self:error := codb_error(1122)
		return .f.
	endif
	class_desc := self:oDict:getValue(class_id)
	if empty(class_desc)
		self:error := codb_error(1122)
		return .f.
	endif
	if empty(class_desc:unique_key)
		lErase := .t.
	endif
	self:runTrigger(class_id,"BEFORE_DELETE_OBJECT",oData)

	oExt := self:extentOpen(class_Desc:extent_id)
	if empty(oExt)
		self:error := codb_error(1121)+":"+class_Desc:extent_id
		return .f.
	endif
	if !oExt:delete(cId,lErase)
		self:error := oExt:error
		return .f.
	endif
	*****
	rddSeek(self:hDbRefTbl,cId,.f.)
	refData := rddRead(self:hDbRefTbl)
	if refData:object_id == cId
		ldeleted := rddDeleted(self:hDbRefTbl)
	else
		self:error := codb_error(1124)+":"+cId
		return .f.
	endif

	if !waitRddLock(self:hDbRefTbl)
		self:error := codb_error(1005)+":"+cId+":dep,line:"+alltrim(str(__LINE__))
		return .f.
	endif
	refData := rddRead(self:hDbREfTbl)
	if lErase
		rddDelete(self:hDbRefTbl)
	endif
	rddUnlock(self:hDbRefTbl)

	if !empty(self:error)
		return .f.
	endif
	if !lDeleted
		self:runTrigger(class_id,"AFTER_DELETE_OBJECT",oData)
	endif
	if "LOG_NEED" $ class_desc .and. class_desc:log_need
		codb_outlog(self:oDict:user,"delete",oData)
	endif
return .t.
************************************************************
static function _dep_unDelete(self,cId)
	local oData,old,class_id,class_desc,oExt,extent_id,refData

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

	rddSeek(self:hDbRefTbl,cId,.f.)
	refData := rddRead(self:hDbRefTbl)
	if refData:object_id == cId
		extent_id := refData:extent_id
	else
		self:error := codb_error(1124)+":"+cId
		return .f.
	endif

	oExt := self:extentOpen(extent_id)
	if empty(oExt)
		self:error := codb_error(1121)+":"+extent_id
		taskStart()
		return .f.
	endif
	oExt:undelete(cId)
	self:error := oExt:error
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
static function _dep_append(self,oData,class_id,obj_id)
	local ret := .t., cId:="",rec:=map(), i
	local tmp,sData,xData:=map(),oExt,class_desc:=map()
	local keyValue

	self:error := ""
	class_id := iif(valtype(class_id)!="C","",class_id)
	if empty(class_id) .and. "CLASS_ID" $ oData .and. !empty(oData:class_id)
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
	if valtype(obj_id) == "C" .and. len(obj_id)==codb_info("CODB_ID_LEN") ;
	   .and. self:oDict:id $ obj_id
		cId := obj_id
	else
		cId := self:counters:addvalue("OBJECT")
		cId := padl(alltrim(ntoc(cId,32)),codb_info("OBJECT_ID_LEN"),"0")
		cId := self:oDict:id + self:number + cId
	endif
	oData:id:= cId
	oData:class_id := class_id
	oData:extent_id := class_desc:extent_id

	self:runTrigger(class_id,"BEFORE_APPEND_OBJECT",oData)
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

	if "HAVE_COUNTERS" $ class_desc .and. class_desc:have_counters
		self:__check_counters(class_desc,oData)
	endif

	aDel(oData,"__VERSION")
	aDel(oData,"__CRC32")
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
		xData[sdata]:=tmp
	next
	taskStop()
	if ! oExt:append(oData, xData)
		self:error := oExt:error
		if empty(self:error)
			self:error := codb_error(1199)
		endif
		taskStart()
		return ""
	endif

	/* add data to DATAREF */
	rec:=map()
	rec:object_id := cId
	rec:extent_id := class_desc:extent_id
	rec:class_id := class_desc:id
	rddAppend(self:hDbRefTbl,rec)
	rddSkip(self:hDbRefTbl,0)
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
	local i, ret := .t., cId:="",rec:=map()
	local tmp,sData,oExt,class_desc:=map()
	local class_id,oldData,extent_id,refData,xData:=map()
	local keyValue1,keyValue2,x,changed,lUnique := .f.

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
	oData := self:checkObjBody(oData,class_desc)
	self:runTrigger(class_id,"BEFORE_UPDATE_OBJECT",oData,oldData)
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
		lUnique := .t.
	endif

	aDel(oData,"__VERSION")
	aDel(oData,"__CRC32")
	aDel(oldData,"__VERSION")
	aDel(oldData,"__CRC32")
	changed := !(self:objCRC(oData) == self:objCRC(oldData)) //varChanged(oData,oldData)
	if !changed .and. !class_desc:unstable
		return .t.
	endif

	extent_id := class_desc:extent_id

	oExt := self:extentOpen(extent_id)
	if empty(oExt)
		self:error := codb_error(1121)+":"+extent_id
		return .f.
	endif

	taskstop()
	rddSeek(self:hDbRefTbl,cID,.f.)
	refData := rddRead(self:hDbRefTbl)
	if refData:object_id == cId
	else
		taskStart()
		self:error := codb_error(1124)+":"+cId
		return .f.
	endif
	if !waitRddLock(self:hDbRefTbl)
		self:error := codb_error(1005)+":"+oData:id+":dep,line:"+alltrim(str(__LINE__))
		taskStart()
		return .f.
	endif

	/* update data to DATAREF */
	refData := rddRead(self:hDbRefTbl)
	refData:object_id := oData:id
	refData:class_id  := oData:class_id
	refData:extent_id := extent_id
	rddWrite(self:hDbRefTbl,refData)
	rddUnlock(self:hDbRefTbl)

	/* DATAx !!!! */
	for i:=1 to len(class_desc:idx_list)
		sdata:="DATA"+alltrim(str(i,2,0))
		tmp:=self:oDict:getValue(class_desc:idx_list[i])
		if empty(tmp)
			outlog(3,"Index #",alltrim(str(i,2,0)),"for class",class_desc:name,"don`t have description")
			loop
		endif
		tmp:expr:=alltrim(tmp:expr)
		xData[sdata]:=self:eval(tmp:expr,oData)
	next
	if ! oExt:update(oData,xData,lUnique)
		self:error := oExt:error
		taskStart()
		return .f.
	endif
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
	local i,s,ret := ""
	local tmp,iTmp,nIndex:=-1,sIndex
	local class_desc:=map(),class_id
	local oExt

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

	oExt:=self:extentOpen(class_desc:extent_id)
	if empty(oExt)
		self:error := codb_error(1121)+":"+class_desc:extent_id
		return ret
	endif

	/* seek data in Extent */
	sIndex := "data"+alltrim(str(nIndex,2,0))
	//s:="class_id=='"+class_id+"'"

return oExt:id4PrimaryKey(class_id,keyValue,sIndex,nIndex,lList)
************************************************************
static function _dep__GetValue(self,objId,nLocks,version)
	local i:=0,ret:=map(),refData,oExt,class_desc

	self:error := ""
	if !(valtype(objId) =="C")
		return ret
	endif
	if !rddSeek(self:hDbRefTbl,objID,.f.)
		return ret
	endif
	refData := rddRead(self:hDbRefTbl)

	if !(refData:object_id == objId)
		return ret
	endif

	oExt := self:extentOpen(refData:extent_id)
	if oExt == NIL
		return ret
	endif

	while (i++) < 10
		ret := oExt:getValue(objId,nLocks)
		if valtype(ret) == "O" .and. "CLASS_ID" $ ret
			exit
		endif
		outlog(__FILE__,__LINE__,"Undefined problem for loading object:",objId)
		sleep(0.01)
	enddo

	if valtype(ret) != "O"
		ret := map()
		ret:id := objId
		ret:class_id := refData:class_id
		class_desc := self:oDict:getValue(ret:class_id)
		ret := self:checkObjBody(ret,class_desc)
	elseif !empty(ret)
		class_desc := self:oDict:getValue(ret:class_id)
		if !empty(class_desc) .and. class_desc:unstable
			ret := self:checkObjBody(ret,class_desc)
		endif
	endif
	if "CLASS_ID" $ ret
	else
		return map()
	endif
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
			self:Extents[ext_id] := oExt
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
static function _dep_select(self,class_Id,nIndex,sName,sWhere,nCount,deleted)
	static wrap:=map()
	local tm,ret:={},sIndex,s:="",oExt
	local tmp,class_desc,i,aWrapNames:={}
#ifdef PROFILE
	s:=procname(1)+str(procline(1))
	if ! (s $ self:__profile)
		self:__profile[s]:={procline(1),0,0,0}
	endif
	s:=""
	tm:=seconds()
#endif
	self:error := ""
	if deleted == NIL .or. valtype(deleted) != "L"
		deleted := .f.
	endif
	if sName != NIL
		s+='NAME=="'+sName+'"'
	endif
	if !empty(sWhere)
		if !empty(s)
			s+=" .and. "
		endif
		s+=alltrim(sWhere)
	endif
	if !empty(class_id)
		if !empty(s)
			s+=" .and. "
		endif
		s+='CLASS_ID=="'+class_Id+'"'
	endif
	if empty(s) //.or. empty(aWrapNames)
		return ret
	endif

	class_desc:=self:oDict:getValue(class_id)
	if empty(class_desc)
		return ret
	endif
	if class_id $ wrap
		aWrapNames := wrap[class_id]
	else
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
		wrap[class_id] := aWrapNames
	endif
	self:runTrigger(class_id,"BEFORE_SELECT_OBJECT",class_id,nIndex,sWhere)

	oExt:=self:extentOpen(class_desc:extent_id)

	if oExt == NIL
		self:error := codb_error(1121)+":"+class_desc:extent_id
		return .f.
	endif

	//outlog(__FILE__,__LINE__,s,aWrapNames,sIndex,nIndex,nCount,deleted)
	ret := oExt:select(s,aWrapNames,sIndex,nIndex,nCount,deleted)
	//outlog(__FILE__,__LINE__,class_desc:extent_id,ret)

	self:runTrigger(class_id,"AFTER_SELECT_OBJECT",class_id,nIndex,sWhere)
#ifdef PROFILE
	s:=procname(1)+str(procline(1))
	i:=self:__profile[s]
	i[2]++
	i[3]+=seconds()-tm
	i[4]+=len(ret)
#endif
return ret

************************************************************
static function _dep_close(self)
	local i
#ifdef PROFILE
	for i in self:__profile
		outlog("dep profile",i)
	next
#endif
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

	if self:hDbRefTbl != NIL
		rddCloseArea(self:hDbRefTbl)
		self:hDbRefTbl := NIL
	endif

	for i in self:Extents
		i:close()
	next
	self:Extents := map()

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
		return .t.
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
	self:hDbRefTbl:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,,.f.)
	if self:hDbRefTbl<=0
		self:hDbRefTbl:=NIL
		self:error:=codb_error(1128)+":"+str(ferror(),3,0)+":"+ferrorstr()
		return .f.
	endif
	rddSetIndex(self:hDBRefTbl,CODB_IDRIVER_DEFAULT,dbFile)
	rddSetOrder(self:hDbRefTbl,"object_id")

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
	if !self:counters:makeTables()
		self:error := self:counters:error
		return .f.
	endif
	if !self:counters:makeIndies()
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

	if !self:makeTables()
		return .f.
	endif
	if !self:makeIndies()
		return .f.
	endif

	self:close()
return .t.
************************************************************
static function _dep_addExtent(self,ext_id)
	local hdb,dbfile,msize,oDict,tmp,oExt

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


	oExt := codb_extdbfNew(self,ext_id)
	oExt:makeTables(.f.)
	oExt:makeIndies(.f.)
	taskStart()

return .t.

************************************************************
static function _dep_makeIndies(self,lOut)
	local hdb,dbfile
	local i,j,str,tmp,oDict,oExt

	lOut:=iif(valtype(lOut)=="L",lOut,.f.)

	self:counters := codb_countDbfNew(self:path)
	if !self:counters:makeIndies()
		self:error := self:counters:error
		return .f.
	endif
	self:counters:close()
	self:counters := NIL

	dbfile:=self:path+PATH_DELIM+"dataidx"
	ferase(dbfile+".cdx")
	hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,.f.,.f.)
	if lOut
		? "create index",dbfile
	endif
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"object_id","object_id")
	rddCloseArea(hDB)
	chmod(dbfile+".cdx","666")

	oDict:=self:Dictionary()
	tmp := oDict:select("EXTENT")
	for i=1 to len(tmp)
		oExt := codb_extdbfNew(self,tmp[i])
		oExt:makeIndies(lOut)
	next
return .t.
************************************************************
static function _dep_makeTables(self,lOut)
	local i,tmp,dbFile,oDict,mSize,oExt

	lOut:=iif(valtype(lOut)=="L",lOut,.f.)

	dbFile := self:path+PATH_DELIM+"dataidx"
	dbCreate(dbFile,CODB_DEPIDX_STRUCTURE)
	chmod(dbfile+".dbf","666")

	oDict:=self:dictionary()
	tmp:=oDict:getValue(self:id)
	if !empty(tmp)
		mSize := tmp:memosize
	endif
	if empty(mSize) .or. mSize<32
		mSize := CODB_MEMOSIZE_DEFAULT
	endif
	set(_SET_MBLOCKSIZE,mSize)

	tmp := oDict:select("EXTENT")
	for i=1 to len(tmp)
		oExt := codb_extdbfNew(self,tmp[i])
		oExt:makeTables(lOut)
	next
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
	chmod(dbfile,"666")
return .t.
