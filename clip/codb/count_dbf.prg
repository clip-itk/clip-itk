/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  Virtual counter class for CODB object and metadata over DBF files
*/

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_countDbfNew(path)
	local obj:=map()
	obj:classname	:= "CODBCOUNTERS"
	obj:error	:= ""
	obj:path	:= alltrim(path)
	obj:hDb		:= NIL
	obj:seek	:= @codb_count_seek()
	obj:lock	:= @codb_count_lock()
	obj:unlock	:= @codb_count_unlock()
	obj:addValue	:= @codb_count_add()
	obj:create	:= @codb_count_create()
	obj:append	:= @codb_count_append()
	obj:open	:= @codb_count_open()
	obj:close	:= @codb_count_close()
return obj
************************************************************
static function __count_not_activated(self)
	self:error := codb_error(1200)
return
************************************************************
static function codb_count_seek(self,countId)
	if self:hDb == NIL
		__count_not_activated(self)
		return .f.
	endif
return  rddSeek(self:hDb,CountID)
************************************************************
static function codb_count_lock(self,nTry)
	local i:=1
	if self:hDb == NIL
		__count_not_activated(self)
		return .f.
	endif
	while ! rddRlock(self:hDb) .and. i<=nTry
		sleep(0.01)
	enddo
return  rddRlock(self:hdb)
************************************************************
static function codb_count_unlock(self)
	if self:hDb == NIL
		__count_not_activated(self)
		return .f.
	endif
return  rddUnLock(self:hDb)

************************************************************
static function codb_count_add(countId)
	local s1,n2
	countId := iif( countId==NIL, "METADATA", countId )
	::error := ""
	taskstop()
	if !::seek(countId)
		taskstart()
		::error := codb_error(1201)+":"+toString(countID)
		return -1
	endif
	if !::lock(10)
		taskstart()
		::error := codb_error(1202)+":"+toString(countID)
		return -1
	endif

	s1 := rddGetvalue(::hDb,"ID")
	n2 := rddGetvalue(::hDb,"VALUE")
	if alltrim(s1) == countId
		n2++
		if n2 >20000000
			outlog([WARNING!!!! Depository have many objects],n2)
		endif
		rddSetValue(::hDb,"VALUE",n2)
		rddUnLock(::hDb)
	else
		::error := codb_error(1203)
		taskstart()
		return -1
	endif
	taskstart()
return n2
************************************************************
static function codb_count_append(countId,countName)
	local s1,n2
	::error := ""
	taskstop()
	if empty(countId)
		taskstart()
		::error := codb_error(1204)+":"+toString(countId)
		return .f.
	endif
	if ::seek(countId)
		taskstart()
		::error := codb_error(1205)+":"+countId
		return .f.
	endif
	countName := iif (CountName==NIL,countId,countName)
	rddAppend(::hdb)
	rddSetValue(::hDB,"id",countId)
	rddSetValue(::hDB,"name",CountName)
	rddSetValue(::hDB,"value",0)

	rddUnLock(::hDb)
	taskstart()
return .t.

************************************************************
static function codb_count_close()
	::error := ""
	if ::hdb != NIL
		rddCloseArea(::hdb)
		::hdb := NIL
	endif
return .t.
************************************************************
static function codb_count_open()
	local dbfile
	::error := ""
	if ::hdb != NIL
		rddCloseArea(::hdb)
		::hdb := NIL
	endif
	dbfile := ::path+PATH_DELIM+"counters"
	::hdb := rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,,.f.)
	rddSetIndex(::hDB,CODB_IDRIVER_DEFAULT,dbFile)
	rddSetOrder(::hDb,"id")
return .t.
************************************************************
static function codb_count_create()
	local hdb,dbfile
	::error := ""
	dbfile:=::path+PATH_DELIM+"counters"

	if file(dbfile+".dbf")
		::error := codb_error(1206)+":"+dbfile
		return .f.
	endif

	rddCreate(CODB_DDRIVER_DEFAULT,dbfile+".dbf",CODB_COUNTER_STRUCTURE)
	hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,.f.,.f.)
	rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"id","id")

	rddCloseArea(hDB)

return  .t.

