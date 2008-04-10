/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* EXTENT control */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_extdbfNew(oDep,ext_id)

	local obj	:= map()
	obj:classname	:= "CODBEXTENT"
	//obj:oDeposit	:= oDep
	obj:path	:= oDep:path + PATH_DELIM + alltrim(ext_id)
	obj:error	:= ""
	obj:hDbData	:= NIL

	obj:delete	:= @_ext_delete()
	obj:undelete	:= @_ext_undelete()
	obj:append	:= @_ext_append()
	obj:update	:= @_ext_update()
	obj:getValue	:= @_ext_getValue() // return body for ID
	obj:open	:= @_ext_open()
	obj:close	:= @_ext_close()
	obj:destroy	:= @_ext_close()
	obj:id4PrimaryKey := @_ext_id4PrimaryKey()
	obj:makeIndies  := @_ext_makeIndies()
	obj:makeTables   := @_ext_makeTables()
	obj:select	 := @_ext_select()
	obj:objCRC	 := @_ext_objCRC()

return obj
************************************************************
static function _ext_close(self)
	self:error:=""
	if self:hDbData != NIL
		rddCloseArea(self:hDbData)
		self:hDbData:=NIL
	endif
return
************************************************************
static function _ext_open(self)
	local ver,hf,dbfile

	self:error:=""

	/* open data table */
	dbFile:=self:path
	self:hDbData:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,,.f.)
	if self:hDbData<=0
		self:hDbData:=NIL
		self:error:=codb_error(1251)+":"+str(ferror(),3,0)+":"+ferrorstr()
		return .f.
	endif
	rddSetMemo (self:hDBData,"FPT",dbFile)
	rddSetIndex(self:hDBData,CODB_IDRIVER_DEFAULT,dbFile)
	rddSetOrder(self:hDbData,"object_id")

return .t.
************************************************************
static function _ext_objCRC(self,obj)
return ntoc(crc32(var2str(obj)),32,8,"0")
************************************************************
static function _ext_select(self,s,aWrapNames,sIndex,nIndex,nCount,deleted)
	local i,ret :={}
	taskstop()
	//outlog(__FILE__,__LINE__s,aWrapNames)
	rddSetFilter(self:hDbData,s,aWrapNames)

	//outlog(__FILE__,__LINE__,self:path,self:hDbData,rddIndexKey(self:hDbData),s,aWrapNames)
	if nIndex!=NIL .and. nIndex>0
		//outlog(__FILE__,__LINE__,nIndex)
		sIndex := "data"+alltrim(str(nIndex,2,0))
		rddSetOrder(self:hDbData,sIndex)
	endif
	if nCount == NIL
		rddGoTop(self:hDbData)
		//outlog(__FILE__,__LINE__,rddEof(self:hDbData))
		while !rddEof(self:hDbData)
			//outlog(__FILE__,__LINE__,rddRecno(self:hDbData))
			if deleted .or. rddGetvalue(self:hDbData,"VERSION") >= 0
				aadd(ret,rddGetvalue(self:hDbData,"OBJECT_ID"))
			endif
			rddSkip(self:hDbData)
		end
	elseif nCount>0
		i:=0
		rddGoTop(self:hDbData)
		while !rddEof(self:hDbData) .and. i<nCount
			if deleted .or. rddGetvalue(self:hDbData,"VERSION") >= 0
				aadd(ret,rddGetvalue(self:hDbData,"OBJECT_ID"))
				i++
			endif
			rddSkip(self:hDbData)
		end
	else
		i:=0
		rddGoBottom(self:hDbData)
		while !rddBof(self:hDbData) .and. i>nCount
			if deleted .or. rddGetvalue(self:hDbData,"VERSION") >= 0
				aadd(ret,rddGetvalue(self:hDbData,"OBJECT_ID"))
				i--
			endif
			rddSkip(self:hDbData,-1)
		end
	endif
	rddClearFilter(self:hDbData)
	rddSetOrder(self:hDbData,"object_id")
	taskStart()
return ret
************************************************************
static function _ext_id4PrimaryKey(self,class_id,keyValue,sIndex,nIndex,lList)
	local r,s1,s2,ret:=""

	ret := iif(lList,{},"")

	taskstop()
	/* based on "set scope" */
	s1:=rdd_m6_newfilter(self:hDbData)
	s2:=rdd_m6_newfilter(self:hDbData)
	rdd_m6_addScoped(self:hDbData,s1,class_id,class_id,2)
	rdd_m6_addScoped(self:hDbData,s2,keyValue,keyValue,2+nIndex)
	m6_FiltJoin(s1,s2,2)
	rdd_m6_setAreaFilter(self:hDbData,s1)
	rddGotop(self:hDbData)
	while !rddEof(self:hDbData)
		if rddGetValue(self:hDbData,sIndex) == keyValue
			r := rddGetValue(self:hDbData,"object_id")
			if lList
				aadd(ret,r)
			else
				ret := r
				exit
			endif
		endif
		rddSkip(self:hDbData)
	enddo
	rddClearFilter(self:hDbData)
	taskStart()
return ret

************************************************************
static function _ext_getValue(self,cID,nLocks,version,lRecord)
	local ret:=map(),tmp,i,locked:=.f.,found := .f., nRecno
	self:error := ""
	/*
	if version == NIL
		version := 0
	endif
	*/
	lRecord := iif(valtype(lRecord)=="L",lRecord,.f.)
	taskStop()
	rddSeek(self:hDbData,cID,.f.)
	while !rddEof(self:hDbData)
	      if ! (rddGetValue(self:hDbData,"object_id") == cId)
			exit
	      endif
	      if version==NIL .or. rddGetValue(self:hDbData,"version") == version
			found := .t.
			exit
	      endif
	      rddSkip(self:hDbData)
	enddo
	if found
		nLocks := iif(valtype(nLocks)!="N",0,nLocks)
		for i=1 to nLocks
			if rddRlock(self:hDbData)
				locked := .t.
				exit
			endif
			nRecno := rddRecno(self:hDbData)
			taskStart()
			sleep(0.05)
			taskStop()
			rddGoto(self:hDbData,nRecno)
		next
		if nLocks==0 .or. locked
			tmp := rddRead(self:hDbData)
			if tmp:object_id == cID
				if lRecord
					ret := tmp
				else
					ret := tmp:body
					if valtype(ret) != "O"
						outlog(__FILE__,__LINE__,"error in FPT","file=",self:path,"recno=",rddRecno(self:hDbData),"value=",ret)
					else
						ret:__version := tmp:version
						ret:__crc32   := tmp:crc32
					endif
				endif
				if rddDeleted(self:hDbData)
					ret:__version := -1
				endif
			endif
		else
			self:error := codb_error(1253)+":"+cId+"-"+toString(version,3,0)
		endif
	else
		self:error := codb_error(1252)+":"+cId+"-"+toString(version,3,0)
	endif
	taskStart()
return ret

************************************************************
static function _ext_delete(self,cId,lErase)
	local ver, version :=0

	self:error := ""
	rddSeek(self:hDbData,cId,.f.)
	if ! (rddGetValue(self:hDbData,"object_id") == cId)
		self:error := codb_error(1252)+":"+cId+"-"+alltrim(str(version,3,0))
		return .f.
	endif
	if !waitRddLock(self:hDbData)
		self:error := codb_error(1005)+":"+cId+":ext,line:"+alltrim(str(__LINE__))
		return .f.
	endif
	if lErase
		rddDelete(self:hDbData)
	else
		ver := rddGetValue(self:hDbData,"version")
		if ver > 0
			ver := -1
		else
			ver --
		endif
		ver := max(ver,-99)
		ver := rddSetValue(self:hDbData,"version",ver)
	endif
	rddUnlock(self:hDbData)
return .t.
************************************************************
static function _ext_undelete(self,cId)
	local ver, version :=0

	self:error := ""
	rddSeek(self:hDbData,cId,.f.)
	if ! (rddGetValue(self:hDbData,"object_id") == cId)
		self:error := codb_error(1252)+":"+cId+"-"+alltrim(str(version,3,0))
		return .f.
	endif
	if !waitRddLock(self:hDbData)
		self:error := codb_error(1005)+":"+cId+":ext,line:"+alltrim(str(__LINE__))
		return .f.
	endif

	ver := rddGetValue(self:hDbData,"version")
	if ver < 0
		rddSetValue(self:hDbData,"version",0)
	endif
	rddUnlock(self:hDbData)
return .t.
************************************************************
static function _ext_append(self,oData, xData, lRecord)
	local i, rec := map() //, tmp

	lRecord := iif(valtype(lRecord)=="L", lRecord, .f. )
	self:error := ""

	if lRecord
		rec := oData
	else
		rec:object_id   := oData:id
		rec:class_id    := oData:class_id
		rec:version	:= 0
		rec:isOld 	:= .f.
		rec:body        := oData

		/*
		tmp := mapKeys(xData)
		for i=1 to len(tmp)
			rec[tmp[i]] := xData[tmp[i]]
		next
		*/
		for i in xData KEYS
			rec[i] := xData[i]
		next
	endif
	rec:crc32     := self:objCRC(rec:body)

	rddAppend(self:hDbData,rec)
	rddSkip(self:hDbData,0)

return .t.

************************************************************
static function _ext_update(self,oData, xData, lUnique)
	local i, ver,rec := map() //, found:=.f. //,tmp

	self:error := ""

	rec:object_id   := oData:id
	rec:class_id    := oData:class_id
	rec:version	:= 0 //version  // доделать
	rec:isOld 	:= .f.
	rec:body        := oData
	rec:crc32     := self:objCRC(rec:body)

	/*
	tmp := mapKeys(xData)
	for i=1 to len(tmp)
		rec[tmp[i]] := xData[tmp[i]]
	next
	*/
	for i in xData KEYS
		rec[i] := xData[i]
	next

	**********
	rddSeek(self:hDbData,oData:id,.f.)
	if rddGetValue(self:hDbData,"object_id") == oData:id
	else
		self:error := codb_error(1252)+":"+oData:id
		return .f.
	endif
	if !waitRddLock(self:hDbData)
		self:error := codb_error(1005)+":"+oData:id+":ext,line:"+alltrim(str(__LINE__))
		return .f.
	endif
	ver := rddGetValue(self:hDbData,"version")
	rec:version := ver
	if ver >= 0 .and. lUnique
		ver := min(ver+1,CODB_MAX_OBJ_VERSION)
		rec:version := ver
	endif
	rddWrite(self:hDbData,rec)
	rddUnlock(self:hDbData)
return .t.
/*
static function xRddWrite(a,b)
return rddWrite(a,b)
*/

************************************************************
static function _ext_makeIndies(self,lOut)
	local hdb,dbfile
	local j,str

	lOut:=iif(valtype(lOut)=="L",lOut,.f.)

	dbfile:=self:path
	ferase(dbfile+".cdx")
	hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,,.f.)
	if lOut
		? "create index",dbfile
	endif
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"object_id","object_id")
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"class_id" ,"class_id")
	for j=1 to CODB_IDX_PER_CLASS
		str:="data"+alltrim(str(j,2,0))
		//rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,str,str,,.t.,str+"!=NIL")
		rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,str,str,,.t.)
	next
	rddCloseArea(hDB)
	chmod(dbfile+".cdx","666")
return .t.
************************************************************
static function _ext_makeTables(self,lOut)
	local hdb,dbfile,stru
	local i,x,tmp,str,oDict

	lOut:=iif(valtype(lOut)=="L",lOut,.f.)

	stru := CODB_EXTENT_STRUCTURE
	x := atail(stru)
	adel(stru,len(stru))
	asize(stru,len(stru)-1)
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
	aadd(stru,x)
	if lOut
		? "create table",dbfile
	endif
	dbFile := self:path
	dbCreate(dbFile,stru)
	chmod(dbfile+".dbf","666")
	chmod(dbfile+".fpt","666")
return .t.

