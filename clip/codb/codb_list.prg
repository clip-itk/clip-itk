/*
    Copyright (C) 2002-2004  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "codbcfg.ch"
************************************************************
function codbListNew(lReadOnly)
return codbList():new(lReadOnly)
************************************************************
function codbList()
	local obj
	if codb_cobraAvailable()
		obj := codbList_cobra()
	else
		obj := codbList_dbf()
	endif
return obj


************************************************************
************************************************************
************************************************************
/* methods for all driver*/
************************************************************
static function codbList_all()
	local obj	:= map()
	obj:className	:= "CODBLIST"
	obj:error	:= ""
	obj:driver	:= "ALL"
	obj:__readOnly	:= .t.
	obj:checkBody	:= @cdb_all_checkBody()
	obj:padrBody	:= @cdb_all_padrBody()
return obj
************************************************************
static function cdb_all_checkBody(self,data)
return codb_checkBody(data,CODB_DICTLIST_BODY )
************************************************************
static function cdb_all_padrBody(self,data)
return  codb_padrBody(data,CODB_DICTLIST_BODY )


************************************************************
************************************************************
************************************************************
/* methods for COBRA driver*/
************************************************************
static function codbList_cobra()
	local obj	:= codbList_all()
	obj:driver	:= "COBRA"
	obj:new		:= @cdb_cbr_new()
	obj:list	:= @cdb_cbr_list()
	obj:existId	:= @cdb_cbr_existId()
	obj:append	:= @cdb_cbr_append()
	obj:update	:= @cdb_cbr_update()
	obj:connect	:= @cdb_cbr_connect()
	obj:getValue	:= @cdb_cbr_getValue()
	obj:close	:= @cdb_cbr_close()
	obj:destroy	:= @cdb_cbr_close()
return obj

************************************************************
static function cdb_cbr_close(self)
return

************************************************************
static function cdb_cbr_new(self,lReadOnly)
return self

************************************************************
static function cdb_cbr_list(self)
	local ret
	self:error := ""
	ret := codb_cobraQuery("CODBLIST_LIST")
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return {}
	endif
return ret:return
************************************************************
static function cdb_cbr_existID(self,id)
	local ret
	self:error := ""
	ret := codb_cobraQuery("CODBLIST_EXISTID",id)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function cdb_cbr_getValue(self,id)
	local ret
	self:error := ""
	ret := codb_cobraQuery("CODBLIST_GETVALUE",id)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return

************************************************************
static function cdb_cbr_append(self,data)
	local ret
	self:error := ""
	/* temporary disable creating CODB over cobra */
	ret := codb_cobraQuery("CODBLIST_APPEND_DISABLE",data)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function cdb_cbr_update(self,data)
	local ret
	self:error := ""
	ret := codb_cobraQuery("CODBLIST_UPDATE",data)
	if !empty(ret:errno)
		self:error := codb_cobraError(ret)
		return .f.
	endif
return ret:return
************************************************************
static function cdb_cbr_connect(self,ident,user,passwd)
	local ret:=map()
	local i,m,vfunc

	ret:classname	:= "CODBDICTIONARY"
	/* CODB user and password */
	ret:id		:= iif(ident==NIL, "GBL01", ident)
	user		:= iif(user==NIL, getenv("USER"), user)
	ret:dbPass	:= iif(passwd==NIL, "", passwd)
	ret:error	:= ""
	codb_checkBodyCODB(ret)
	vfunc:=codb_dictCobra_Methods(ret,user,passwd)
	/* add virtual methods */
	m:=mapkeys(vfunc)
	for i=1 to len(m)
		ret[ m[i] ] := vfunc[ m[i] ]
	next
return ret


************************************************************
************************************************************
************************************************************
/* methods for DBF driver*/
************************************************************
static function codbList_dbf()
	local obj	:= codbList_all()
	obj:hDB		:= NIL
	obj:driver	:= "DBF"
	obj:__readOnly	:= .t.
	obj:new		:= @cdb_new()
	obj:list	:= @cdb_list()
	obj:existId	:= @cdb_existId()
	obj:append	:= @cdb_append()
	obj:update	:= @cdb_update()
	obj:connect	:= @cdb_connect()
	obj:getValue	:= @cdb_getValue()
	obj:close	:= @cdb_close()
	obj:destroy	:= @cdb_close()

	rddSetDefault(CODB_RDD_DEFAULT)

return obj

************************************************************
static function cdb_close(self)
	if ::hDB!=NIL
		rddCloseArea(::hdb)
	endif
	::hdb:=NIL
return

************************************************************
static function cdb_new(self,readOnly)
	local path,nPath,fh

	self:error:=""
	if valtype(readOnly)!="L"
		readOnly := .t.
	endif

	nPath:=cliproot()+PATH_DELIM+"etc"+PATH_DELIM+"codb"
	path:=PATH_DELIM+"var"+PATH_DELIM+"codb"

#ifdef __NEW
	makeDirectory(path)
	path+=PATH_DELIM+"codb"
	/* check access denied to /var/codb */
	fh := fcreate(path)
	if fh<0
	      path := nPath
	else
		if file(nPath)
			frename(nPath+".dbf",path+".dbf")
			frename(nPath+".fpt",path+".fpt")
		endif
	endif
	fErase(path)
	fClose(fh)
#else
	path := nPath
#endif

	if !file(path+".dbf")
		dbcreate(path,codb_info("CODB_DICTLIST_STRUCTURE"))
	endif
	chmod(path+".dbf","666")
	chmod(path+".fpt","666")

	if !file(path+".dbf")
		self:error:=codb_error(1002)
		return self
	endif
	self:hDB:=rddUseArea(self:driver,path,.t.,readOnly)
	rddSetMemo(self:hDb,"FPT",path)
	self:__readOnly := readOnly
	if self:hDB<=0
		self:error:=codb_error(1008)+":"+str(ferror(),3,0)+":"+ferrorstr()
	endif
return self

************************************************************
static function cdb_list()
	local ret:={},body
	if ::hDB==NIL
		return ret
	endif
	rddGotop(::hDB)
	while !rddEof(::hDB)
		body:=rddGetValue(::hDB,"BODY")
		aadd(ret,body:ID+":"+body:NAME)
		rddSkip(::hDB)
	enddo
return ret
************************************************************
static function cdb_existID(id)
	local ret:=.f.
	::error:=""
	if ::hdb==NIL .or. valtype(ID)!="C"
		::error := codb_error(1007)
	endif
	if empty(::error)
		rddGotop(::hDb)
		while !rddEof(::hDb) .and. !(rddGetValue(::hDb,"ID") == id)
			rddSkip(::hDb)
		enddo
		if rddGetValue(::hDb,"ID") == id
			ret:=.t.
		endif
	endif
return ret
************************************************************
static function cdb_getValue(id)
	local ret := NIL
	::error:=""
	if ::hdb==NIL .or. valtype(ID)!="C"
		::error := codb_error(1007)
	endif
	if empty(::error)
		rddGotop(::hDb)
		while !rddEof(::hDb) .and. !(rddGetValue(::hDb,"ID") == id)
			rddSkip(::hDb)
		enddo
		if rddGetValue(::hDb,"ID") == id
			ret:= rddGetValue(::hDb,"BODY")
		endif
	endif
return ret

************************************************************
static function cdb_append(data)
	local id,ret:=.f.,dict,rec
	::error:=""
	if ::__readOnly
		::close()
		::new(.f.)
		//error := codb_error(1009)
		if !empty(::error)
			return ret
		endif
	endif
	if ::hdb==NIL .or. valtype(data)!="O" .or. !("ID" $ data) .or. empty(data:id)
		::error := codb_error(1007)
		return .f.
	endif
	data:id := upper(data:id)
	data:id := strtran(alltrim(data:id)," ","_")
	data:id := padr(data:id,DICT_ID_LEN,"0")
	if empty(::error)
		id:=data:id
		rddGotop(::hDb)
		while !rddEof(::hDb) .and. !(rddGetValue(::hDb,"ID") == id)
			rddSkip(::hDb)
		enddo
		if rddGetValue(::hDb,"ID") == id
			::error := codb_error(1003)+":"+id
		endif
	endif
	if empty(::error)
		if empty(data:type) .or. ("$CODBTYPE$" $ data:type)
			data:type:=codbType()
		endif
		if empty(data:path) .or. ("$CODBROOT$" $ data:path)
			data:path := codbRoot()+PATH_DELIM+alltrim(data:id)
		endif
		data:path := alltrim(strtran(data:path,"//","/"))
		data:type := alltrim(data:type)
		if data:type $ "DBF " // "SQL ..."
		else // SQL default parameters
			::error := codb_error(1010)+":"+data:type
		endif
	endif
	codb_checkBodyCODB(data )
	if empty(::error)
		rddAppend(::hdb)
		rec:=map()
		rec:id := data:id
		rec:body:=data
		rddWrite(::hDb,rec)
		//ret:=rddGetValue(::hDb,"ID")
		ret := .t.
	endif
	if ret //!empty(ret)
		dict:=::connect(data:id)
		if empty(::error)
			if !dict:create() .or. !empty(dict:error)
				::error := dict:error
				ret := .f.
			endif
			dict:close()
		else
			::error := dict:error
			ret := .f.
			dict:close()
		endif
	endif
	if empty(::error)
		set("CODB_SERVER_REINIT","Y")
	endif
	if !ret
		rddRlock(::hDb)
		rddDelete(::hDb,rec)
		rddUnlock(::hDb)
	endif
return ret
************************************************************
static function cdb_update(data)
	local id,ret:=.f.,dict,rec
	::error:=""

	if ::__readOnly
		::close()
		::new(.f.)
		//error := codb_error(1009)
		if !empty(::error)
			return ret
		endif
	endif
	if ::hdb==NIL .or. valtype(data)!="O" .or. !("ID" $ data) .or. empty(data:id)
		::error := codb_error(1007)
	endif
	if empty(::error)
		id:=data:id
		rddGotop(::hDb)
		while !rddEof(::hDb) .and. !(rddGetValue(::hDb,"ID") == id)
			rddSkip(::hDb)
		enddo
	endif
	if !(rddGetValue(::hDb,"ID") == id)
		::error := codb_error(1004)+":"+id
	else
    	data := rddGetValue(::hDb,"BODY")
	endif
	if empty(::error)
		if empty(data:type) .or. ("$CODBTYPE$" $ data:type)
			data:type:=codbType()
		endif
		if empty(data:path) .or. ("$CODBROOT$" $ data:path)
			data:path := codbRoot()+PATH_DELIM+alltrim(data:id)
		endif
		data:path := alltrim(strtran(data:path,"//","/"))
		data:type:=alltrim(data:type)
		if data:type $ "DBF " // "SQL ..."
		else // SQL default parameters
			::error := codb_error(1010)+":"+data:type
		endif
	endif
	codb_checkBodyCODB(data )
	if empty(::error)
		rec:=map()
		rec:id := data:id
		rec:body:=data
		if waitRddLock(::hDb)
			rddWrite(::hDb,rec)
		else
			::error := codb_error(1005)
		endif
		rddUnLock(::hDb)
		//ret:=rddGetValue(::hDb,"ID")
		ret := .t.
	endif
	if ret //!empty(ret)
		dict:=::connect(data:id)
		::error := dict:error
		ret := empty(dict:error)
		dict:close()
	endif
return ret
************************************************************
static function cdb_connect(ident,user,passwd)
	local ret:=map(), path:=cliproot()
	local i,tmp,m,vfunc
	path := path+PATH_DELIM+"etc"+PATH_DELIM+"codb.dbf"

	ret:classname	:= "CODBDICTIONARY"
	/* CODB user and password */
	ret:id		:= iif(ident==NIL, "GBL01", ident)
	user		:= iif(user==NIL, getenv("USER"), user)
	//ret:dbUser	:= iif(user==NIL, getenv("USER"), user)
	ret:dbPass	:= iif(passwd==NIL, "", passwd)
	ret:error	:= ""
	rddGotop(::hDb)
	while !rddEof(::hDb) .and. !(rddGetvalue(::hDb,"ID") == ret:id)
		rddSkip(::hDb)
	enddo
	if !(rddGetvalue(::hDb,"ID") == ret:id)
		::error:=codb_error(1006)+":"+ret:id
		ret:error := ::error
		return ret
	endif
		/* read info of depository */
	tmp=rddRead(::hDb)
	ret := tmp:body
	ret:server:=NIL
	codb_checkBodyCODB(ret)
	ret:path:=alltrim(ret:path)
	ret:type:=upper(alltrim(ret:type))
	ret:dtype:=upper(alltrim(ret:dtype))
	/* make virtual methods */
	do case
		case codb_cobraAvailable()
			ret:path:=""
			vfunc:=codb_dictCobra_Methods(ret,user,passwd)
		case ret:type=="DBF"
			vfunc:=codb_dictdbf_Methods(ret,user,passwd)
		case ret:type=="SQL"
			vfunc:=codb_dictsql_Methods(ret,user,passwd)
		otherwise
			vFunc := map()
			ret:error := codb_error(1010)+":"+ret:type
	endcase

	/* add virtual methods */
	m:=mapkeys(vfunc)
	for i=1 to len(m)
		ret[ m[i] ] := vfunc[ m[i] ]
	next
return ret
************************************************************
************************************************************
************************************************************
static function codb_checkBodyCODB(data)
return codb_checkBody(data,CODB_DICTLIST_BODY )
