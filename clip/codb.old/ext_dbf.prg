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
	obj:oDeposit	:= oDep
	obj:path	:= oDep:path + PATH_DELIM + alltrim(ext_id)
	obj:error	:= ""
	obj:hDbData	:= NIL

	obj:delete	:= @_ext_delete()
	obj:append	:= @_ext_append()
	obj:update	:= @_ext_update()
	obj:changeVersion:= @_ext_changeVersion()
	obj:maxVersion	:= @_ext_maxVersion()
	obj:getValue	:= @_ext_getValue() // return body for ID
	obj:open	:= @_ext_open()
	obj:close	:= @_ext_close()
	obj:destroy	:= @_ext_close()

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
static function _ext_getValue(cID,nLocks,version)
	local ret:=map(),tmp,i,locked:=.f.,found := .f., nRecno
	::error := ""
	if version == NIL
		version := 0
	endif
	//outlog(__FILE__,__LINE__,::path)
	//outlog(__FILE__,__LINE__,'"'+cId+'"',rddIndexKey(::hDbData))
	taskStop()
      //outlog(__FILE__,__LINE__,rddRecno(::hDbData),rddLastrec(::hDbData),rddEof(::hDbData))
	rddSeek(::hDbData,cID,.f.)
      //outlog(__FILE__,__LINE__,rddRecno(::hDbData),rddLastrec(::hDbData),rddEof(::hDbData))
	while !rddEof(::hDbData)
	      //outlog(__FILE__,__LINE__,rddRecno(::hDbData),rddGetValue(::hDbData,"object_id"))
	      if ! (rddGetValue(::hDbData,"object_id") == cId)
			exit
	      endif
	      if rddGetValue(::hDbData,"version") == version
			found := .t.
			exit
	      endif
	      rddSkip(::hDbData)
	enddo
	//outlog(__FILE__,__LINE__,rddRecno(::hDbData),found)
	if found
		nLocks := iif(valtype(nLocks)!="N",0,nLocks)
		for i=1 to nLocks
			if rddRlock(::hDbData)
				locked := .t.
				exit
			endif
			nRecno := rddRecno(::hDbData)
			taskStart()
			sleep(0.05)
			taskStop()
			rddGoto(::hDbData,nRecno)
		next
		if nLocks==0 .or. locked
			tmp := rddRead(::hDbData)
			//outlog(__FILE__,__LINE__,rddRecno(::hDbData),tmp)
			if tmp:object_id == cID
				ret := tmp:body
				if valtype(ret) != "O"
					outlog(__FILE__,__LINE__,"error in FPT","file=",::path,"recno=",rddRecno(::hDbData),"value=",ret)
				endif
			endif
		else
			::error := codb_error(1253)+":"+cId+"-"+alltrim(str(version,3,0))
		endif
	else
		::error := codb_error(1252)+":"+cId+"-"+alltrim(str(version,3,0))
	endif
	taskStart()
return ret

************************************************************
static function _ext_delete(self,cId,version)
	local found:=.f.
	self:error := ""
	if version == NIL
		version := 0
	endif
	taskStop()
	rddSeek(self:hDbData,cId,.f.)
	while !rddEof(self:hDbData)
	      if ! (rddGetValue(self:hDbData,"object_id") == cId)
			exit
	      endif
	      if rddGetValue(self:hDbData,"version") == version
			found := .t.
			exit
	      endif
	      rddSkip(self:hDbData)
	enddo
	if found
		if !waitRddLock(self:hDbData)
			self:error := codb_error(1005)+":"+cId+":ext,line:"+alltrim(str(__LINE__))
			taskStart()
			return .f.
		endif
		rddDelete(self:hDbData)
		rddUnlock(self:hDbData)
	else
		self:error := codb_error(1252)+":"+cId+"-"+alltrim(str(version,3,0))
		taskStart()
		return .f.
	endif
	taskStart()
return .t.
************************************************************
static function _ext_append(self,oData,version)
	local rec := map()
	if version == NIL
		version := 0
	endif
	self:error := ""
	rec:object_id   := oData:id
	rec:class_id    := oData:class_id
	rec:version	:= version
	rec:body        := oData
	taskStop()
	rddAppend(self:hDbData,rec)
	rddSkip(self:hDbData,0)
	taskStart()
return .t.

************************************************************
static function _ext_update(self,oData,version)
	local rec := map(),found:=.f.
	if version == NIL
		version := 0
	endif
	rec:object_id   := oData:id
	rec:class_id    := oData:class_id
	rec:version	:= version
	rec:body        := oData

	self:error := ""
	taskStop()
	rddSeek(self:hDbData,oData:id,.f.)
	while !rddEof(self:hDbData)
	      if ! (rddGetValue(self:hDbData,"object_id") == oData:id)
			exit
	      endif
	      if rddGetValue(self:hDbData,"version") == version
			found := .t.
			exit
	      endif
	      rddSkip(self:hDbData)
	enddo
	if found //rddGetValue(self:hDbData,"object_id") == oData:id
		if !waitRddLock(self:hDbData)
			self:error := codb_error(1005)+":"+oData:id+":ext,line:"+alltrim(str(__LINE__))
			taskStart()
			return .f.
		endif
		rddWrite(self:hDbData,rec)
		rddUnlock(self:hDbData)
	else
		self:error := codb_error(1252)+":"+oData:id+"-"+alltrim(str(version,3,0))
		taskStart()
		return .f.
	endif
	taskStart()
return .t.
************************************************************
static function _ext_changeVersion(self,cId,old,new)
	local rec := map(),found:=.f.
	self:error := ""
	taskStop()
	rddSeek(self:hDbData,cId,.f.)
	while !rddEof(self:hDbData)
	      if ! (rddGetValue(self:hDbData,"object_id") == cId)
			exit
	      endif
	      if rddGetValue(self:hDbData,"version") == old
			found := .t.
			exit
	      endif
	      rddSkip(self:hDbData)
	enddo
	if found
		if !waitRddLock(self:hDbData)
			self:error := codb_error(1005)+":"+cId+":ext,line:"+alltrim(str(__LINE__))
			taskStart()
			return .f.
		endif
		rec:version := new
		rddWrite(self:hDbData,rec)
		rddUnlock(self:hDbData)
	else
		self:error := codb_error(1252)+":"+cId+"-"+alltrim(str(old,3,0))
		taskStart()
		return .f.
	endif
	taskStart()
return .t.
************************************************************
static function _ext_maxVersion(self,cId)
	local rec := map(),found:=.f.,ver,maxver:=-999
	self:error := ""
	taskStop()
	rddSeek(self:hDbData,cId,.f.)
	while !rddEof(self:hDbData)
	      if ! (rddGetValue(self:hDbData,"object_id") == cId)
			exit
	      endif
	      ver := rddGetValue(self:hDbData,"version")
	      maxver := max(ver,maxver)
	      rddSkip(self:hDbData)
	enddo
	taskStart()
return max(maxver,-1)

