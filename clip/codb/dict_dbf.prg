/*
    Copyright (C) 2002-2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual metods for DBF/CODB driver */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_dictDBF_Methods(dbData,user,passwd)

	local obj	:= codb_dictAll_methods(dbData,user,passwd)

	obj:_delete	:= @_dict__delete()
	obj:_undelete	:= @_dict__undelete()
	obj:_append	:= @_dict__append()
	obj:_update	:= @_dict__update()
	obj:select	:= @_dict_select() // return array of selected metaData
	obj:_getValue	:= @_dict__getValue() // return body for ID
	obj:__counter	:= @_dict___counter() // check and return counter value
	obj:__loadPlugins:= @_dict___LoadPlugins()
	obj:hashName	:= @_dict_hashName() // return string for hashcode
	obj:__close	:= @_dict___close()
	obj:__open	:= @_dict___open()
	obj:__depNew	:= @_dict___depNew()
	obj:__countNew	:= @_dict___countNew()
	obj:__makeDirs	:= @_dict___makeDirs()
	obj:__makeVersion:= @_dict___makeVersion()
	obj:makeTables	:= @_dict_makeTables()
	obj:makeIndies	:= @_dict_makeIndies()
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
	chmod(dbfile,"666")
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
static function _dict_makeTables(self,lOut)
	local dbfile

	lOut:=iif(valtype(lOut)=="L",lOut,.f.)

	set(_SET_MBLOCKSIZE,CODB_MEMOSIZE_DEFAULT)

	self:counters := self:__countNew()
	if !self:counters:makeTables()
		self:error := self:counters:error
		return .f.
	endif
	self:counters:close(); self:counters:=NIL

	dbfile:=self:path+PATH_DELIM+"metadata"
	dbCreate(dbfile,CODB_DICT_STRUCTURE)
	if lOut
		? "create table",dbfile
	endif
	chmod(dbfile+".dbf","666")
	chmod(dbfile+".fpt","666")
return .t.
************************************************************
static function _dict_makeIndies(self,lOut)
	local hdb,dbfile

	lOut:=iif(valtype(lOut)=="L",lOut,.f.)

	taskstop()
	set(_SET_MBLOCKSIZE,CODB_MEMOSIZE_DEFAULT)
	self:counters := self:__countNew()
	if !self:counters:makeIndies()
		self:error := self:counters:error
		return .f.
	endif
	self:counters:close(); self:counters:=NIL

	dbfile:=self:path+PATH_DELIM+"metadata"
	ferase(dbfile+".cdx")
	hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,.f.,.f.)
	if lOut
		? "create index",dbfile
	endif
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"id","id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"hashname","hashname")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"meta","meta")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"name","name")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"class_id","class_id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"super_id","super_id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"user_id","user_id")
	//rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"isold","isold")
	rddCloseArea(hDB)
	chmod(dbfile+".cdx","666")
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
return .t.
************************************************************
static function _dict___close(self)
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
		::error := codb_error(1005)+":"+cId+":dict,line:"+alltrim(str(__LINE__))
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

	s:='META=="'+padr("PLUGINS",rddFieldSize(::hDbMeta,rddFieldPos(::hDbMeta,"META")))+'"'
	s+=' .and. CLASS_ID=="'+padr(cID,rddFieldSize(::hDbMeta,rddFieldPos(::hDbMeta,"CLASS_ID")))+'"'
	if !empty(cName)
		s+=' .and. NAME=="'+padr(cName,rddFieldSize(::hDbMeta,rddFieldPos(::hDbMeta,"NAME")))+'"'
	endif
	taskstop()
	rddSetFilter(::hDbMeta,s)
	rddGoTop(::hDbMeta)
	while !rddEof(::hDbMeta)
		if rddGetvalue(::hDbMeta,"ISOLD")
			rddSkip(::hDbMeta)
			loop
		endif
		if rddGetvalue(::hDbMeta,"VERSION") >=0
			aadd(tmp,rddGetValue(::hDbMeta,"ID"))
		endif
		rddSkip(::hDbMeta)
	end
	rddClearFilter(::hDbMeta)
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
static function _dict__getValue(cID,nLocks,version)
	local i,ret:=map(), rec, locked:=.f.,nRecno

	rddSeek(::hDbMeta,cID,.f.,.t.)
	rec := rddRead(::hDbMeta)
	if valtype(version) == "N"
		while rec:id == cId .and. !bof()
			if rec:version == version
				exit
			endif
			rddSkip(::hDbMeta,-1)
			rec := rddRead(::hDbMeta)
		enddo
	endif
	if !(rec:id == cID)
		return map()
	endif
	//ret := ::checkBody(rec:body,alltrim(rec:meta))
	nLocks := iif(valtype(nLocks)!="N",0,nLocks)
	for i=1 to nLocks
		if rddRlock(::hDbMeta)
			locked := .t.
			exit
		endif
		nRecno := rddRecno(::hDbMeta)
		taskStart()
		sleep(0.05)
		taskStop()
		rddGoto(::hDbMeta,nRecno)
	next
	if nLocks==0 .or. locked
	else
		return map()
	endif

	rec := rddRead(::hDbMeta)
	if !(rec:id == cID)
		return map()
	endif
	ret := rec:body
	if empty(rec:crc32)
		rec:crc32 := ::objCRC(ret)
	endif
	ret:__version := rec:version
	ret:__crc32 := rec:crc32
	ret:__meta := alltrim(rec:meta)

return ret
************************************************************
static function _dict_select(self,metaName,nIndex,sName,sWhere,nCount,deleted)
	local ret:={},s:="",rec

	deleted := iif(deleted == NIL, .f., deleted)

	if !empty(metaName)
		s+='META=="'+padr(alltrim(upper(metaName)),rddFieldSize(self:hDbMeta,rddFieldPos(self:hDbMeta,"META")))+'"'
	endif
	if sName != NIL
		if !empty(s)
			s+=" .and. "
		endif
		s+='NAME=="'+padr(sName,rddFieldSize(self:hDbMeta,rddFieldPos(self:hDbMeta,"NAME")))+'"'
	endif
	if !empty(sWhere)     //sWhere != NIL
		if !empty(s)
			s+=" .and. "
		endif
		s+=alltrim(sWhere)
	endif

	if !empty(metaName)
		self:runTrigger(metaname,"BEFORE_SELECT_DICTIONARY",nIndex,s)
	endif
	taskstop()
	if !empty(s)
		rddSetFilter(self:hDbMeta,s)
	endif
	rddGoTop(self:hDbMeta)
	while !rddEof(self:hDbMeta)
		rec := rddRead(self:hDbMeta)
		if !rec:isOld .and. (deleted .or. rec:version >= 0)
			aadd(ret,rec:id)
		endif
		rddSkip(self:hDbMeta)
		/*
		if rddGetvalue(self:hDbMeta,"ISOLD")
			rddSkip(self:hDbMeta)
			loop
		endif
		if deleted .or. rddGetvalue(self:hDbMeta,"VERSION") >= 0
			aadd(ret,rddGetvalue(self:hDbMeta,"ID"))
		endif
		rddSkip(self:hDbMeta)
		*/
	end
	rddClearFilter(self:hDbMeta)
	taskStart()
	//outlog(__FILE__,__LINE__,self:hDbMeta,s,ret)
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
static function _dict__delete(self,cId,lErase)
	local rec,oData,version

	lErase := iif(valtype(lErase) == "L", lErase, .f.)

	self:error := ""
	self:runTrigger(cId,"BEFORE_DELETE_CLASS")

	rddSeek(self:hDbMeta,cID,.f.,.t.) // seek last record
	rec := rddRead(self:hDbMeta)
	if rec:id == cID
	else
		self:error := codb_error(1023)+":"+cId
		return .f.
	endif
	if !waitRddLock(self:hDbMeta)
		self:error := codb_error(1005)+":"+cId+":dict,line:"+alltrim(str(__LINE__))
		return .f.
	endif
	***
	rec := rddRead(self:hDbMeta)
	oData := rec:body
	version := rec:version
	if version > 0
		version := -1
	else
		version --
	endif
	version := max(version,-99)
	if lErase
		rddDelete(self:hDbMeta)
	else
		rddSetValue(self:hDbMeta,"ISOLD",.f.)
		rddSetValue(self:hDbMeta,"VERSION",version)
	endif
	***
	rddUnLock(self:hDbMeta)
	codb_outlog(self:user,"delete",oData)
	self:runTrigger(cId,"AFTER_DELETE_CLASS",oData)
return  .t.
************************************************************
static function _dict__undelete(self,cId)
	local rec,oData,version:=-1

	self:error := ""
	self:runTrigger(cId,"BEFORE_UNDELETE_CLASS")

	rddSeek(self:hDbMeta,cID,.f.,.t.)
	rddSkip(self:hDbMeta,-1)
	rec := rddRead(self:hDbMeta)
	if rec:id == cID
		version := rec:version
	endif
	if version < 0
		version := -1
	endif
	version := min(version+1,CODB_MAX_OBJ_VERSION)
	rddSeek(self:hDbMeta,cID,.f.,.t.)
	rec := rddRead(self:hDbMeta)
	if rec:id == cID
	else
		self:error := codb_error(1023)+":"+cId
		return .f.
	endif
	if rec:version >=0 .and. !rec:isold
		return .f.
	endif
	if !waitRddLock(self:hDbMeta)
		self:error := codb_error(1005)+":"+cId+":dict,line:"+alltrim(str(__LINE__))
		return .f.
	endif
	rddSetValue(self:hDbMeta,"ISOLD",.f.)
	rddSetValue(self:hDbMeta,"VERSION",version)
	rddUnLock(self:hDbMeta)
	oData := rec:body
	codb_outlog(self:user,"undelete",oData)
	self:runTrigger(cId,"AFTER_UNDELETE_CLASS",oData)
return  .t.
************************************************************
static function _dict__append(self,oData,metaName)
	local rec:=map()

	rec:id := oData:id
	rec:crc32 := self:objCRC(odata)
	rec:meta := metaName
	rec:body := oData
	rec:version := 0
	rec:name := oData:name
	rec:hashname := hashstr(upper(alltrim(oData:name)))
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

	rddAppend(self:hDbMeta,rec)

return .t.
************************************************************
static function _dict__update(self,oData,metaName,aRecursive,lOut)
	local i,j,s,m,rec,rec2,cId,recno
	local changed := .f., oldData, super_desc
	local unstable, oldExt:="", newExt:=""
	local list,oDep,tmp,mTmp

	self:error := ""
	if aRecursive == NIL
		aRecursive := {}
	endif

	if !empty(metaname)
		metaName := alltrim(upper(metaName))
	endif
	cId := iif("ID" $ oData,oData:id,"")
	rddSeek(self:hDbMeta,cId,.f.,.t.)
	rec:= rddRead(self:hDbMeta)
	if !(rec:id == cId) .or. empty(cId)
		self:error := codb_error(1023)+":"+cId
		return .f.
	endif
	if !waitRddLock(self:hDbMeta)
		self:error := codb_error(1005)+":"+cId+":dict,line:"+alltrim(str(__LINE__))
		return .f.
	endif
	recno := rddRecno(self:hDbMeta)
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
	if metaName == "DEPOSIT"
		oData:number := oldData:number
		oData:memosize := oldData:memosize
	endif
	oData := self:checkBody(oData,metaname)
	adel(oData,"__VERSION")
	adel(oData,"__CRC32")
	adel(oData,"__META")
	if metaName == "CLASS"
		oldExt := oldData:extent_id
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
			if empty(m[i])
				loop
			endif
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
			if empty(m[i])
				loop
			endif
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
				if ascan(oData:idx_list, oldData:idx_list[i])!=i
					changed := .t.
				endif
			next
		endif
		if changed
			oData:unstable := .t.
		endif
		self:__check_haveCounters(oData)
		//odata:unstable := .f.
		newExt := oData:extent_id
	endif

	oData := self:checkBody(oData,metaName)
	if metaName == "ATTR"
		if !isword(oData:name)
			// check validate name
			self:error:=codb_error(1044)+":"+oData:name
			rddUnlock(self:hDbMeta)
			return .f.
		endif
		if oData:type $ "RS"
			oData:len := CODB_ID_LEN
		endif

	endif
	changed := !(self:objCRC(oData) == self:objCRC(oldData)) //varChanged(oData,oldData)
	if !changed //.and. ("UNSTABLE" $ oData .and. !oData:unstable)
		rddUnlock(self:hDbMeta)
		return .t.
	endif
	if rec:version >= CODB_MAX_OBJ_VERSION
		outlog(0,"Metaobject version more than "+alltrim(str(CODB_MAX_OBJ_VERSION)))
		outlog(0,"old object",oldData)
		outlog(0,"new object",oData)

		/* move old versions to stack */
		rec := rddRead(self:hDbMeta)
		for i=CODB_MAX_OBJ_VERSION-1 to 0 step -1
			rddSkip(self:hDbMeta,-1)
			rec2 := rddRead(self:hDbMeta)
			if !(rec2:id == cId)
				exit
			endif
			if rddRLock(self:hDbMeta)
				rec:version := i
				rec:isold := .t.
				rddWrite(self:hDbMeta,rec)
				rddUnlock(self:hDbMeta)
			endif
			rec := NIL; rec:=rec2; rec2:=NIL
		next
	endif
	rddUnlock(self:hDbMeta)

	self:runTrigger(cId,"BEFORE_UPDATE_CLASS",oData)
	rddSeek(self:hDbMeta,cId,.f.,.t.)
	rec:= rddRead(self:hDbMeta)
	if !(rec:id == cId) .or. empty(cId)
		self:error := codb_error(1023)+":"+cId
		return .f.
	endif
	if !waitRddLock(self:hDbMeta)
		self:error := codb_error(1005)+":"+cId+":dict,line:"+alltrim(str(__LINE__))
		return .f.
	endif
	rec:body  := oData
	rec:isold := .f.
	if "SUPER_ID" $ oData
		rec:super_id := oData:super_id
	endif
	if "CLASS_ID" $ oData
		rec:class_id := oData:class_id
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
	if rec:version < 0 .or. rec:version >= CODB_MAX_OBJ_VERSION
		rddWrite(self:hDbMeta,rec)
	else
		rddSetValue(self:hDbMeta,"ISOLD",.t.)
		rec:version ++
		rec:version := min(rec:version,CODB_MAX_OBJ_VERSION)
		rec:crc32 := self:objCRC(odata)
		rddAppend(self:hDbMeta,rec)
	endif
	rddUnlock(self:hDbMeta)

	if metaName == "CLASS" .and. oData:unStable
		/* changed CLASS description */
		/* need reconstruction database */
		/* and need check all children classes descriptions */
		/* recursivelly :) */
		/* select all children for self class */
		m := {}
		s:='META=="'+padr(alltrim(upper(metaName)),rddFieldSize(self:hDbMeta,rddFieldPos(self:hDbMeta,"META")))+'"'
		s+='.and. SUPER_ID=="'+oData:id+'"'
		rddSetFilter(self:hDbMeta,s)
		rddGoTop(self:hDbMeta)
		while !rddEof(self:hDbMeta)
			aadd(m,rddGetvalue(self:hDbMeta,"ID"))
			rddSkip(self:hDbMeta)
		end
		rddClearFilter(self:hDbMeta)
		aadd(aRecursive,oData:id)
		for i=1 to len(m)
			if ascan(aRecursive,m[i]) == 0
				oData:=self:getValue(m[i])
				self:update(oData,"CLASS",aRecursive)
				aadd(aRecursive,m[i])
			endif
		next
	endif
	if !(oldExt == newExt)
		/* move old objects to new extent */
		list := self:select("DEPOSIT")
		mtmp:={}
		for i=1 to len(list)
			tmp := self:getValue(list[i])
			aadd(mtmp, codb_needDepository(self:id+tmp:number))
			oDep := mTmp[i]
			if empty(oDep)
				loop
			endif
			if ! oDep:moveExtent(oData:id,oldExt,newExt,lOut)
				self:error := oDep:error
				loop
			endif
		next
	endif
	codb_outlog(self:user,"update",oData)
	self:runTrigger(cId,"AFTER_UPDATE_CLASS",oData,oldData)
return  .t.
