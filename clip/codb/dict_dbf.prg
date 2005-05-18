/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual metods for DBF/CODB driver */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_dictDBF_Methods(dbData,user,passwd)

	local obj	:= codb_dictAll_methods(dbData,user,passwd)

	obj:delete	:= @_dict_delete()
	obj:undelete	:= @_dict_undelete()
	obj:append	:= @_dict_append()
	obj:update	:= @_dict_update()
	obj:select	:= @_dict_select() // return array of selected metaData
	obj:__getValue	:= @_dict___getValue() // return body for ID
	obj:__counter	:= @_dict___counter() // check and return counter value
	obj:__loadPlugins:= @_dict___LoadPlugins()
	obj:hashName	:= @_dict_hashName() // return string for hashcode
	obj:__close	:= @_dict___close()
	obj:__open	:= @_dict___open()
	obj:__depNew	:= @_dict___depNew()
	obj:__countNew	:= @_dict___countNew()
	obj:__makeDirs	:= @_dict___makeDirs()
	obj:__makeVersion:= @_dict___makeVersion()
	obj:__makeMeta	:= @_dict___makeMeta()
	obj:lockID	:= @_dict_lockID()
	obj:unLockID	:= @_dict_unLockID()

return obj
************************************************************
static function _dict___depNew(self,sDeposit)
return	codb_depDbfNew(self,sDeposit)
************************************************************
static function _dict___countNew(self)
return	codb_countDbfNew(self:path)
************************************************************
static function _dict___makeVersion(self)
	local hf,dbfile
	dbfile:=self:path+PATH_DELIM+".version"
	if file(dbFile)
		/* 1021 used in codb_list !!! not changed*/
		self:error := codb_error(1021)+":"+self:path
		return .f.
	endif
	hf:=fcreate(dbfile)
	if hf<0 .or. !file(dbfile)
		self:error := codb_error(1022)+":"+dbFile+":"+str(ferror(),3,0)+":"+ferrorstr()
		return .f.
	endif
	fwrite(hf,CODB_VERSION)
	fclose(hf)
return .t.
************************************************************
static function _dict___makeDirs(self)
	if empty(self:path)
		self:error := codb_error(1020)
		return .f.
	endif
	if !makeDirectory(self:path)
		self:error := codb_error(1029)+":"+self:path
		return .f.
	endif
return .t.
************************************************************
static function _dict___makeMeta(self)
	local hdb,dbfile

	*************** create metadata table
	taskstop()
	set(_SET_MBLOCKSIZE,CODB_MEMOSIZE_DEFAULT)

	dbfile:=self:path+PATH_DELIM+"metadata"

	dbCreate(dbfile,CODB_DICT_STRUCTURE)
	hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,.f.,.f.)
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"id","id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"hashname","hashname")
//        rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"meta","meta")
	rddCloseArea(hDB)

	*************** create metaindex table
	dbfile:=self:path+PATH_DELIM+"metaidx"
	dbCreate(dbfile,CODB_DICTINDEX_STRUCTURE)
	hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,.f.,.f.)
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"id","id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"meta","meta")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"name","name")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"class_id","class_id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"super_id","super_id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"user_id","user_id")
	rddCloseArea(hDB)
	taskstart()

return .t.
************************************************************
static function _dict___open(self)
	local ver,hf,dbfile,tmp,i,m

	dbfile:=self:path+PATH_DELIM+".version"
	hf:=fopen(dbfile,0)
	if self:counters != NIL
		return .t.
	endif
	if hf<0
		self:error:=codb_error(1024)+";"+ferrorstr()+" "+makepath(dbFile)
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
		self:error:=codb_error(1026)+":"+self:counters:error
		return .f.
	endif

	/* open metadata table */
	dbFile:=self:path+PATH_DELIM+"metadata"
	self:hDbMeta:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,,.f.)
	if self:hDbMeta<=0
		self:hDbMeta:=NIL
		self:error:=codb_error(1027)+":"+str(ferror(),3,0)+":"+ferrorstr()
		return .f.
	endif
	rddSetMemo (self:hDBMeta,"FPT",dbFile)
	rddSetIndex(self:hDBMeta,CODB_IDRIVER_DEFAULT,dbFile)
	rddSetOrder(self:hDbMeta,"id")

	/* open metaindex table */
	dbFile:=self:path+PATH_DELIM+"metaidx"
	self:hDbMetaIdx:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,,.f.)
	if self:hDbMetaIdx<=0
		self:hDbMetaIdx:=NIL
		self:error:=codb_error(1028)+":"+str(ferror(),3,0)+":"+ferrorstr()
		[1028:Error open meta index table:]+str(ferror(),3,0)+":"+ferrorstr()
		return .f.
	endif
	rddSetIndex(self:hDBMetaIdx,CODB_IDRIVER_DEFAULT,dbFile)
	rddSetOrder(self:hDbMetaIdx,"id")
return .t.
************************************************************
static function _dict___close(self)
	if self:hDbMetaIdx != NIL
		rddCloseArea(self:hDbMetaIdx)
		self:hDbMetaIdx:=NIL
	endif
	if self:hDbMeta != NIL
		rddCloseArea(self:hDbMeta)
		self:hDbMeta:=NIL
	endif
return .t.
************************************************************
static function _dict___counter(cId,value)
	local rec,obj
	if !rddSeek(::hDbMeta,cID,.f.)
		return 0
	endif
	taskstop()
	if !waitRddLock(::hDbMeta)
		::error := codb_error(1005)+":"+cId
		return 0
	endif
	rec := rddRead(::hDbMeta)
	obj := rec:body
	do case
		case obj:type=="MAX"
			if empty(value) .or. value <= obj:max_value
				value := obj:max_value+1
			endif
		case obj:type=="LAST"
			if empty(value)
				value := obj:last_value+1
			endif
		otherwise
	endcase
	obj:max_value := max(value,obj:max_value)
	obj:last_value := value
	rddWrite(::hDbMeta,rec)
	rddUnLock(::hDbMeta)
	taskstart()
return value
************************************************************
static function _dict___loadPlugins(cID,cName)
	local i,s,tmp:={}

	s:='META=="'+padr("PLUGINS",rddFieldSize(::hDbMetaIdx,rddFieldPos(::hDbMetaIdx,"META")))+'"'
	s+=' .and. CLASS_ID=="'+padr(cID,rddFieldSize(::hDbMetaIdx,rddFieldPos(::hDbMetaIdx,"CLASS_ID")))+'"'
	if !empty(cName)
		s+=' .and. NAME=="'+padr(cName,rddFieldSize(::hDbMetaIdx,rddFieldPos(::hDbMetaIdx,"NAME")))+'"'
	endif
	taskstop()
	rddSetFilter(::hDbMetaIdx,s)
	rddGoTop(::hDbMetaIdx)
	while !rddEof(::hDbMetaIdx)
		if rddGetvalue(::hDbMetaIdx,"VERSION") >=0
			aadd(tmp,rddGetValue(::hDbMetaIdx,"ID"))
		endif
		rddSkip(::hDbMetaIdx)
	end
	rddClearFilter(::hDbMetaIdx)
	taskstart()
return tmp
************************************************************
static function _dict_lockID(cID,nSec)
	rddSeek(::hDbMeta,cID,.f.,.t.)
	if ! (rddGetvalue(::hDbMeta,"ID") == cID)
		return .f.
	endif
return waitRddLock(::hDbMeta,nSec)
************************************************************
static function _dict_unLockID(cID)
	rddSeek(::hDbMeta,cID,.f.,.t.)
	if ! (rddGetvalue(::hDbMeta,"ID") == cID)
		return .f.
	endif
	RddUnLock(::hDbMeta)
return .t.
************************************************************
static function _dict___getValue(cID)
	local ret:=map(), rec

	taskstop()
	rddSeek(::hDbMeta,cID,.f.,.t.)
	rec := rddRead(::hDbMeta)
	if !(rec:id == cID)
		taskstart()
		return map()
	endif
		//ret := ::checkBody(rec:body,alltrim(rec:meta))
	ret := rec:body
	if empty(rec:crc32)
		rec:crc32 := ::objCRC(ret)
	endif
	ret:__version := rec:version
	ret:__crc32 := rec:crc32
	ret:__meta := alltrim(rec:meta)
	taskStart()

return ret
************************************************************
static function _dict_select(self,metaName,nIndex,sName,sWhere,nCount,deleted)
	local ret:={},s:=""
	if deleted == NIL
		deleted := .f.
	endif
	if !empty(metaName)
		s+='META=="'+padr(alltrim(upper(metaName)),rddFieldSize(self:hDbMetaIdx,rddFieldPos(self:hDbMetaIdx,"META")))+'"'
	endif
	if sName != NIL
		if !empty(s)
			s+=" .and. "
		endif
		s+='NAME=="'+padr(sName,rddFieldSize(self:hDbMetaIdx,rddFieldPos(self:hDbMetaIdx,"NAME")))+'"'
	endif
	if !empty(sWhere)     //sWhere != NIL
		if !empty(s)
			s+=" .and. "
		endif
		s+=sWhere
	endif
	self:runTrigger(metaname,"BEFORE_SELECT_DICTIONARY",nIndex,s)
	taskstop()
	rddSetFilter(self:hDbMetaIdx,s)
	rddGoTop(self:hDbMetaIdx)
	while !rddEof(self:hDbMetaIdx)
		if deleted .or. rddGetvalue(self:hDbMetaIdx,"VERSION") >=0
			aadd(ret,rddGetvalue(self:hDbMetaIdx,"ID"))
		endif
		rddSkip(self:hDbMetaIdx)
	end
	rddClearFilter(self:hDbMetaIdx)
	taskStart()
	self:runTrigger(metaname,"AFTER_SELECT_DICTIONARY",nIndex,s)
return ret
************************************************************
static function _dict_hashName(nHCode)
	local ret := ""
	taskstop()
	rddSetOrder(::hDbMeta,"hashname")
	rddSeek(::hDbMeta,nHCode,.f.)
	ret := rddRead(::hDbMeta)
	rddSetOrder(::hDbMeta,"id")
	taskstart()
	if !(ret:hashname == nHCode)
		return hashname(nHCode)
	endif
	ret := ret:body
	if "NAME" $ ret
		ret := alltrim( ret:name )
	else
		ret := ""
	endif
	if empty(ret)
		ret:=hashname(nHCode)
	endif
return ret
************************************************************
static function _dict_delete(self,cId)
	local rec,oData,idxData,oldVer,found := .f.
	self:error := ""
	self:runTrigger(cId,"BEFORE_DELETE_CLASS")
	adel(self:__objCache,cId)
	taskStop()
	rddSeek(self:hDbMetaIdx,cID,.f.)
	idxData := rddRead(self:hDbMetaIdx)
	if idxData:id == cId
		oldVer := idxData:version
		if idxData:version > 0
			idxData:version := -1
		else
			idxData:version --
		endif
		idxData:version :=max(idxData:version,-90)
		if !waitRddLock(self:hDbMetaIdx)
			self:error := codb_error(1005)+":"+cId
			taskStart()
			return .f.
		endif
		rddWrite(self:hDbMetaIdx,idxData)
		rddUnLock(self:hDbMetaIdx)
	else
		self:error := codb_error(1023)+":"+cId
		taskstart()
		return .f.
	endif
	rddSeek(self:hDbMeta,cID,.f.,.t.)
	rec := rddRead(self:hDbMeta)
	if rec:id == cID
		if !waitRddLock(self:hDbMeta)
			self:error := codb_error(1005)+":"+cId
			taskStart()
			return .f.
		endif
		rec := rddRead(self:hDbMeta)
		oData := rec:body
		rec:version := idxData:version
		if rec:version > 0 .and. rec:version < 900
			rddAppend(self:hDbMeta,rec)
		else
			rec := map()
			rec:version := idxData:version
			rddWrite(self:hDbMeta,rec)
		endif
		rddUnLock(self:hDbMeta)
	else
		self:error := codb_error(1023)+":"+cId
		taskstart()
		return .f.
	endif
	taskstart()
	codb_outlog(self:user,"delete",oData)
	self:runTrigger(cId,"AFTER_DELETE_CLASS",oData)
return  .t.
************************************************************
static function _dict_undelete(self,cId)
	local rec,prevrec,oData,idxData,oldVer,found := .f.
	self:error := ""
	self:runTrigger(cId,"BEFORE_UNDELETE_CLASS")
	adel(self:__objCache,cId)
	taskStop()
	rddSeek(self:hDbMeta,cID,.f.,.t.)
	rddSkip(self:hDbMeta,-1)
	prevrec := rddRead(self:hDbMeta)
	if !(prevrec:id == cID)
		prevRec:=nil
	endif
	rddSeek(self:hDbMeta,cID,.f.,.t.)
	rec := rddRead(self:hDbMeta)
	if rec:id == cID
		if !waitRddLock(self:hDbMeta)
			self:error := codb_error(1005)+":"+cId
			taskStart()
			return .f.
		endif
		oData := rec:body
		rec := map()
		if prevRec != NIL
			rec:version := prevRec:version+1
		else
			rec:version := 0
		endif
		rddWrite(self:hDbMeta,rec)
		rddUnLock(self:hDbMeta)
	else
		self:error := codb_error(1023)+":"+cId
		taskstart()
		return .f.
	endif
	rddSeek(self:hDbMetaIdx,cID,.f.)
	idxData := rddRead(self:hDbMetaIdx)
	if idxData:id == cId
		idxData := map()
		idxData:version := rec:version
		if !waitRddLock(self:hDbMetaIdx)
			self:error := codb_error(1005)+":"+cId
			taskStart()
			return .f.
		endif
		rddWrite(self:hDbMetaIdx,idxData)
		rddUnLock(self:hDbMetaIdx)
	else
		self:error := codb_error(1023)+":"+cId
		taskstart()
		return .f.
	endif
	taskstart()
	codb_outlog(self:user,"undelete",oData)
	self:runTrigger(cId,"AFTER_UNDELETE_CLASS",oData)
return  .t.
************************************************************
static function _dict_append(self,oData,metaName)
	local ret := .t., dep_id:="00",id:="",rec:=map()
	local oDep, list,i,tmp
	local m, super_desc
	metaName := alltrim(upper(metaName))

	self:error := ""
	if empty(metaName)
		self:error := codb_error(1043)
		return ""
	endif

	oData := self:checkBody(oData,metaName)

	if metaName == "ATTR" .and. !isword(oData:name)
		 // check validate name
		self:error:=codb_error(1044)+":"+oData:name
		return ""
	endif
	if metaName == "CLASS" // check unique name
		tmp:=self:select(metaname,,odata:name)
		if !empty(tmp) .and. self:getValue(tmp[1]):name == oData:name
			self:error:=codb_error(1041)+":"+oData:name
			return ""
		endif
	endif

	Id := self:counters:addvalue("METADATA")

	if metaName == "DEPOSIT"
		dep_Id := self:counters:addvalue("DEPOSIT")
		dep_id := padl(alltrim(ntoc(dep_id,32)),2,"0")
		oData:number  := dep_id
	endif
	id := padl(alltrim(ntoc(id,32)),codb_info("OBJECT_ID_LEN"),"0")
	id := padr(self:id,codb_info("CODB_ID_LEN")-len(id),"0")+id
	oData:id:= id
	rec:id := id
	rec:meta := metaName
	rec:body := oData
	if "NAME" $ oData
		rec:hashname := hashstr(upper(alltrim(oData:name)))
	endif
	if metaName=="CLASS"
		/* inherit from SUPER class*/
		super_desc := self:classDesc(oData:super_id)
		m:=aclone(oData:attr_list)
		if !empty(super_desc)
			oData:attr_list:= super_desc:attr_list
		else
			oData:attr_list:= {}
		endif
		for i=1 to len(m)
			if ascan(oData:attr_list, m[i]) == 0
				aadd(oData:attr_list, m[i])
			endif
		next
		m:=aclone(oData:idx_list)
		if !empty(super_desc)
			oData:idx_list:= super_desc:idx_list
		else
			oData:idx_list:= {}
		endif
		for i=1 to len(m)
			if ascan(oData:idx_list, m[i]) == 0
				aadd(oData:idx_list, m[i])
			endif
		next
		self:__check_haveCounters(oData)
		if empty(oData:extent_id)
			tmp:=self:select("EXTENT",,"undef")
			if !empty(tmp)
				oData:extent_id := tmp[1]
			endif
		endif
	endif
	adel(oData,"__VERSION")
	adel(oData,"__CRC32")
	adel(oData,"__META")
	rec:crc32 := self:objCRC(odata)

	self:runTrigger(self:id,"BEFORE_APPEND_CLASS",oData)
	/*
	rddAppend(self:hDbMeta)
	rddWrite(self:hDbMeta,rec)
	*/
	rddAppend(self:hDbMeta,rec)

	/* add data to METAIDX data */
	rec:=map()
	rec:meta := metaName
	rec:name := oData:name
	if "CLASS_ID" $ oData
		rec:class_id := oData:class_id
	endif
	if "SUPER_ID" $ oData
		rec:super_id := oData:super_id
	endif
	if "EXTENT_ID" $ oData
		rec:extent_id := oData:extent_id
	endif
	if "GROUP_ID" $ oData
		rec:group_id := oData:group_id
	endif
	if "USER_ID" $ oData
		rec:user_id := oData:user_id
	endif
	rec:id   := oData:id
	/*
	rddAppend(self:hDbMetaIdx)
	rddWrite(self:hDbMetaIdx,rec)
	*/
	rddAppend(self:hDbMetaIdx,rec)

	if metaName == "DEPOSIT"
		oDep := codb_depDbfNew(self,oData:id)
		if ! oDep:create()
			self:error := oDep:error
			return ""
		endif
		if ! oDep:open()
			self:error := oDep:error
			return ""
		endif
		/* add extents to new depository */
		list:={}
		list := self:select("EXTENT")
		for i=1 to len(list)
			if ! oDep:addExtent(list[i])
				self:error := oDep:error
				exit
			endif
		next
		oDep:close()
	endif
	if metaName == "EXTENT"
		/* add new extent to exist depositories */
		list := self:select("DEPOSIT")
		for i=1 to len(list)
			oDep := codb_depDbfNew(self,list[i])
			if ! oDep:open()
				self:error := oDep:error
				exit
			endif
			if ! oDep:addExtent(id)
				self:error := oDep:error
				exit
			endif
			oDep:close()
		next
	endif
	if !empty(self:error)
		return ""
	endif
	codb_outlog(self:user,"append",oData)
	self:runTrigger(self:id,"AFTER_APPEND_CLASS",oData)
return id
************************************************************
static function _dict_update(self,oData,metaName,aRecursive)
	local i,j,s,m,ret := .f., rec,idxData, recno,cId
	local changed := .f., oldData, super_desc
	local unstable

	self:error := ""
	if aRecursive == NIL
		aRecursive := {}
	endif

	self:__objCache := map()
	if !empty(metaname)
		metaName := alltrim(upper(metaName))
	endif
	cId := iif("ID" $ oData,oData:id,"")
	taskStop()
	rddSeek(self:hDbMeta,cId,.f.,.t.)
	rec:= rddRead(self:hDbMeta)
	if !(rec:id == cId) .or. empty(cId)
		self:error := codb_error(1023)+":"+cId
		taskstart()
		return .f.
	endif
	recno:=rddRecno(self:hDbMeta)
	metaname := alltrim(upper(rec:meta))
	oldData := rec:body
	if metaName == "CLASS"
		if "UNSTABLE" $ oData
			unstable := oData:unstable
		else
			unstable := oldData:unstable
		endif
	endif
	oData := o2update(oData,oldData)
	oData := self:checkBody(oData,metaname)
	adel(oData,"__VERSION")
	adel(oData,"__CRC32")
	adel(oData,"__META")
	if metaName == "CLASS"
			adel(oData,"_BESSENCE")
			adel(oData,"ESSENCE")
			odata:unstable := unstable
			/* check old and new class descriptions */
			super_desc := self:classDesc(oData:super_id)
			m:=aclone(oData:attr_list)
			if empty(super_desc)
				oData:attr_list:={}
			else
				oData:attr_list := aclone(super_desc:attr_list)
			endif
			for i=1 to len(m)
				if ascan(oData:attr_list, m[i]) == 0
					aadd(oData:attr_list, m[i])
				endif
			next
			m:=aclone(oData:idx_list)
			if empty(super_desc)
				oData:idx_list:={}
			else
				oData:idx_list:= aclone(super_desc:idx_list)
			endif
			for i=1 to len(m)
				if ascan(oData:idx_list, m[i]) == 0
					aadd(oData:idx_list, m[i])
				endif
			next
			m:=mapKeys(oldData)
			for i=1 to len(m)
				if i==hashstr("_BESSENCE") .or. i==hashstr("ESSENCE")
					loop
				endif
				if m[i] $ oData .and. oData[ m[i] ] == oldData[ m[i] ]
					loop
				endif
				if m[i] == `EXTENT_ID`
					loop
				endif
				if m[i] == `UNSTABLE`
					loop
				endif
				if valtype(oldData[ m[i] ] ) == "A"
					loop
				endif
				changed := .t.
			next
			if !changed
				if len(oData:attr_list) != len(oldData:attr_list)
					changed := .t.
				endif
				if len(oData:idx_list) != len(oldData:idx_list)
					changed := .t.
				endif
			endif
			if !changed
				for i=1 to len(oldData:attr_list)
					if ascan(oData:attr_list, oldData:attr_list[i])==0
						changed := .t.
					endif
				next
			endif
			if !changed
				for i=1 to len(oldData:idx_list)
					if ascan(oData:idx_list, oldData:idx_list[i])==0
						changed := .t.
					endif
				next
			endif
			if changed
				oData:unstable := .t.
			endif
			self:__check_haveCounters(oData)
			//odata:unstable := .f.
	endif

	oData := self:checkBody(oData,metaName)
	changed := !(self:objCRC(oData) == self:objCRC(oldData)) //varChanged(oData,oldData)
	if !changed //.and. ("UNSTABLE" $ oData .and. !oData:unstable)
		taskstart()
		return .t.
	elseif rec:version > 50
		outlog(0,"Metaobject version more than 50")
		outlog(0,"old object",oldData)
		outlog(0,"new object",oData)
	endif
	if metaName == "ATTR" .and. !isword(oData:name)
		 // check validate name
		self:error:=codb_error(1044)+":"+oData:name
		taskstart()
		return .f.
	endif

	self:runTrigger(cId,"BEFORE_UPDATE_CLASS",oData)
	rddSeek(self:hDbMeta,cId,.f.,.t.)
	rec:= rddRead(self:hDbMeta)
	if !(rec:id == cId) .or. empty(cId)
		self:error := codb_error(1023)+":"+cId
		taskstart()
		return .f.
	endif
	if !waitRddLock(self:hDbMeta)
		self:error := codb_error(1005)+":"+cId
		taskStart()
		return .f.
	endif
	rec:body := oData
	if rec:version < 0 .or. rec:version >= 900
		rddWrite(self:hDbMeta,rec)
	else
		rec:version ++
		rec:version := min(rec:version,900)
		rec:crc32 := self:objCRC(odata)
		rddAppend(self:hDbMeta,rec)
	endif
	rddUnlock(self:hDbMeta)

	rddSeek(self:hDbMetaIdx,cID,.f.)
	idxData:= rddRead(self:hDbMetaIdx)
	if !(idxData:id == cId)
		self:error := codb_error(1023)+":"+cId
		taskstart()
		return .f.
	endif
	if !waitRddLock(self:hDbMetaIdx)
		self:error := codb_error(1005)+":"+cId
		taskStart()
		return .f.
	endif
	idxData:version := rec:version
	if "SUPER_ID" $ oData
		idxData:super_id := oData:super_id
	endif
	if "CLASS_ID" $ oData
		idxData:class_id := oData:class_id
	endif
	if "EXTENT_ID" $ oData
		idxData:extent_id := oData:extent_id
	endif
	if "GROUP_ID" $ oData
		idxData:group_id := oData:group_id
	endif
	if "USER_ID" $ oData
		idxData:user_id := oData:user_id
	endif
	ret:=rddWrite(self:hDbMetaIdx,idxData)
	rddUnlock(self:hDbMetaIdx)
	taskStart()

	if metaName == "CLASS" .and. oData:unStable
		/* changed CLASS description */
		/* need reconstruction database */
		/* and need check all children classes descriptions */
		/* recursivelly :) */
		/* select all children for self class */
		m := {}
		s:='META=="'+padr(alltrim(upper(metaName)),rddFieldSize(self:hDbMetaIdx,rddFieldPos(self:hDbMetaIdx,"META")))+'"'
		s+='.and. SUPER_ID=="'+oData:id+'"'
		taskstop()
		rddSetFilter(self:hDbMetaIdx,s)
		rddGoTop(self:hDbMetaIdx)
		while !rddEof(self:hDbMetaIdx)
			aadd(m,rddGetvalue(self:hDbMetaIdx,"ID"))
			rddSkip(self:hDbMetaIdx)
		end
		rddClearFilter(self:hDbMetaIdx)
		taskStart()
		aadd(aRecursive,oData:id)
		for i=1 to len(m)
			if ascan(aRecursive,m[i]) == 0
				oData:=self:getValue(m[i])
				self:update(oData,"CLASS",aRecursive)
				aadd(aRecursive,m[i])
			endif
		next
	endif
	codb_outlog(self:user,"update",oData)
return  ret




