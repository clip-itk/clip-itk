/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual metods for DBF/CODB driver */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_dictdbf_Methods(path,dict_id,user,passwd)

	local obj	:= codb_dictAll_methods(path,dict_id,user,passwd)

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
	obj:loadPluginses:= @_dict_LoadPluginses()
	obj:loadModule	:= @_dict_LoadModule()
	obj:getModule	:= @_dict_getModule()
	obj:runTrigger  := @_dict_runTrigger()
	obj:getTriggers := @_dict_getTriggers()
	obj:hashName	:= @_dict_hashName() // return string for hashcode
	obj:checkBody	:= @_dict_checkBody()
	obj:create	:= @_dict_create()
	obj:open	:= @_dict_open()
	obj:close	:= @_dict_close()
	//obj:destroy	:= @_dict_close()

	obj:__check_haveCounters:= @__check_haveCounters()

return obj
************************************************************
static function _dict_metaBodyByName(metaClass,metaName)
	local ret:=map(), tmp
	tmp := ::select(metaClass,,metaName)
	if !empty(tmp)
		ret:=::getValue(tmp[1])
	endif
return ret
************************************************************
static function _dict_classBodyByName(className)
	local ret:=map(), tmp
	tmp := ::select("CLASS",,className)
	if !empty(tmp)
		ret:=::getValue(tmp[1])
	endif
return ret
************************************************************
static function _dict_classIdByName(className)
	local ret:=map(), tmp
	tmp := ::select("CLASS",,className)
	if !empty(tmp)
		ret:=tmp[1]
	endif
return ret
************************************************************
static function _dict_attrBodyByName(attrName)
	local ret:=map(), tmp
	tmp := ::select("ATTR",,attrName)
	if !empty(tmp)
		ret:=::getValue(tmp[1])
	endif
return ret
************************************************************
static function _dict_close(self)
	self:error:=""
	if "ID" $ self
		if codb_dict_ref_counter(self:id) > 1
			codb_dict_unregister(self:id)
			return
		endif
		if codb_dict_ref_counter(self:id) <= 0
			return
		endif
	endif
	self:runTrigger(self:id,"BEFORE_CLOSE_DICTIONARY")
	if self:counters != NIL
		self:counters:close()
		self:counters:=NIL
	endif
	if self:hDbMetaIdx != NIL
		rddCloseArea(self:hDbMetaIdx)
		self:hDbMetaIdx:=NIL
	endif
	if self:hDbMeta != NIL
		rddCloseArea(self:hDbMeta)
		self:hDbMeta:=NIL
	endif
	codb_dict_unregister(self:id)
	self:runTrigger(self:id,"AFTER_CLOSE_DICTIONARY")
return .t.
************************************************************
static function _dict_open(self)
	local ver,hf,dbfile,tmp,i,m
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
	makeDirectory(self:path+PATH_DELIM+"modules")

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
		self:error:=codb_error(1027)+":"+str(ferror())+":"+ferrorstr()
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
		self:error:=codb_error(1028)+":"+str(ferror())+":"+ferrorstr()
		[1028:Error open meta index table:]+str(ferror())+":"+ferrorstr()
		return .f.
	endif
	rddSetIndex(self:hDBMetaIdx,CODB_IDRIVER_DEFAULT,dbFile)
	rddSetOrder(self:hDbMetaIdx,"id")
	codb_dict_register(self:id,self)
	self:runTrigger(self:id,"AFTER_OPEN_DICTIONARY")
return .t.
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
static function _dict_loadModule(filename)
	local bCode,file

	if ! (".prg" $ filename)
		filename += ".prg"
	endif

	if filename $ ::__modCache
		return .t.
	endif

	file:=::path+PATH_DELIM+"modules"+PATH_DELIM+filename
	if !file(file)
		::error := codb_error(1035)+":"+file
		return .f.
	endif

	bCode := __loadPlugIns(file)
	if valtype(bCode) =="C"
		::error := codb_error(1036)+":"+bCode
	else
		::__modCache[filename] := bCode
	endif
	if !empty(::error)
		outlog(2,"CODB:",::error)
	endif
return empty(::error)
************************************************************
static function _dict_getModule(filename)
	if ! (".prg" $ filename)
		filename += ".prg"
	endif
	if filename $ ::__modCache
		return ::__modCache[ filename ]
	endif
return NIL
************************************************************
static function _dict_loadPluginses(cID)
	local i,j,s,rec,tmp,body, m:={}
	local bCode,file,bNames := {}
	local cExt,eblock,lErr:=.f.
	if cId $ ::__PlugCache
		return .t.
	endif
	s:='META=="'+padr("PLUGINS",rddFieldSize(::hDbMetaIdx,rddFieldPos(::hDbMetaIdx,"META")))+'"'
	taskstop()
	rddSetFilter(::hDbMetaIdx,s)
	rddGoTop(::hDbMetaIdx)
	tmp:={}
	while !rddEof(::hDbMetaIdx)
		aadd(tmp,rddGetValue(::hDbMetaIdx,"ID"))
		rddSkip(::hDbMetaIdx)
	end
	rddClearFilter(::hDbMetaIdx)
	for i=1 to len(tmp)
		if tmp[i] $ ::__objCache
			body := ::__objCache[ tmp[i] ]
		else
			if rddSeek(::hDbMeta,tmp[i],.f.)
				rec := rddRead(::hDbMeta)
				if !(rec:id == tmp[i] )
					loop
				endif
				body:=rec:body
			endif
		endif
		if "CLASS_ID" $ body .and. body:class_id == cId
			aadd(m,body)
		endif
	next
	taskStart()
	::__PlugCache[ cId ] := map()
	for i=1 to len(m)
		body:=m[i]
		if body:type $ "CS" .and. empty(body:filename)
			::error := codb_error(1031)+":"+"("+body:id+")"+body:name
			exit
		endif
		if body:type $ "SL" .and. empty(body:mainfunc)
			::error := codb_error(1032)+":"+"("+body:id+")"+body:name
			exit
		endif
		file:=::path+PATH_DELIM+"plugins"+PATH_DELIM+body:filename
		if body:type $ "CS" .and. !(file(file) .or. file(file+".prg"))
			::error := codb_error(1033)+":"+file
			exit
		endif
		do case
			case body:type=="C"
				// CLIP source code as codeblock
				bCode := __loadPlugIns(file)
				if valtype(bCode) =="C"
					::error := codb_error(1034)+":"+bCode
				endif
			case body:type=="S"
				// Shared library
				eblock := errorblock({|err|break(err)})
				begin sequence
					loadlib(file)
				recover
					lErr:=.t.
				end sequence
				errorblock(eBlock)
				if lErr
					::error := codb_error(1037)+":"+file
				else
					if ! isfunction(body:mainfunc)
						::error := codb_error(1038)+":"+body:mainfunc+[ in ]+file
					else
						bcode:= &("{|p1|"+body:mainfunc+"(p1)}")
					endif
				endif
			case body:type=="L"
				// linked mainfunc procedure
				if ! isfunction(body:mainfunc)
					::error := codb_error(1039)+":"+body:mainfunc
				else
					bcode:= &("{|p1|"+body:mainfunc+"(p1)}")
				endif
		endcase
		if !empty(::error)
			exit
		endif
		bNames := eval(bCode,"MEMBERS")
		if valtype(bNames) == "C" .or. empty(bNames)
			::error := codb_error(1040)+":"+"("+body:id+")"+body:name
			if valtype(bNames) =="C"
				::error += "("+bNames+")"
			endif
			exit
		endif
		for j=1 to len(bnames)
			if bnames[j] $ ::__PlugCache[ cId ]
			else
				::__PlugCache[ cId ][ bNames[j] ] := {}
			endif
			aadd( ::__PlugCache[ cId ][ bNames[j] ], eval(bCode,bNames[j]) )
		next
	next
	if !empty(::error)
		outlog(2,"CODB:",::error)
	endif
return empty(::error)
************************************************************
static function _dict_getTriggers(self,cId,cTrigger)
	local nId:=""
	if self:counters == NIL .or. self:hDbMetaIdx == NIL .or. self:hDbMeta == NIL
		return {}
	endif
	self:loadPluginses(cId)
	if !(cId $ self:__PlugCache)
		return {}
	endif
	if !(cTrigger $ self:__PlugCache[cId])
		return {}
	endif
return  self:__PlugCache[cId][cTrigger]
************************************************************
static function _dict_runTrigger(self,cId,cTrigger,oldBody,NewBody)
	local i,m,ret:=.t., tret
	m:=self:getTriggers(cId,cTrigger)
	for i=1 to len(m)
		tret := eval(m[i],self,oldBody,newBody)
		ret := ret .and. ( valtype(tret)=="L" .and. tret)
	next
return ret
************************************************************
static function _dict_getValue(cID)
	local ret:=map(),nId, rec
	local err,bl
	::error := ""
	cID := padr(cID,codb_info("CODB_ID_LEN"))
	if empty(cID)
		return ret
	endif
	if cId $ ::__objCache
		return ::__objCache[cId]
	endif
	if len(::__objCache) > CODB_DICT_CACHE
		codb_cache_minimize(::__objCache, CODB_DICT_CACHE/4 )
	endif
	taskstop()
	rddSeek(::hDbMeta,cID,.f.,.t.)
	/*
	while !rddEof(::hDbMeta)
	      if ! (rddGetValue(::hDbMeta,"ID") == cId)
			exit
	      endif
	      rddSkip(::hDbMeta)
	enddo
	rddSkip(::hDbMeta,-1)
	*/
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
	bl := NIL
	if alltrim(rec:meta) == "CLASS"
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
	ret:__version := rec:version
	ret:__crc32 := rec:crc32
	ret:__meta := alltrim(rec:meta)
	::__objCache[ cId ] := ret
	if alltrim(rec:meta) == "CLASS"
		::loadPluginses(cId)
	endif
	taskstart()
	//::runTrigger(cId,"AFTER_GETVALUE_CLASS",ret)
return ret
************************************************************
static function _dict_classDesc(cID,aRecursive)
	local cDesc:=map(),ret, rec:=map(), super:=map()
	local i,j,mKeys,key,val

	::error := ""
	if aRecursive == NIL
		aRecursive := {}
	endif
	taskStop()
	ret := ::getValue(cId)
	if empty(ret)
		return ret
	endif
	if !empty( ret:super_id )
		if ascan(aRecursive,ret:super_id) == 0
			super := ::classDesc(ret:super_id,aRecursive)
			aadd(aRecursive,ret:super_id)
		endif
	endif
	taskstart()
	if !empty(super)
		mKeys := mapkeys(super)
		for i=1 to len(mkeys)
			cDesc[ mKeys[i] ] := super[ mKeys[i] ]
		next
	endif
	if !empty(ret)
		mKeys := mapkeys(ret)
		for i=1 to len(mkeys)
			key := mkeys[i]
			if ! (key $ cDesc)
				cDesc[key] := ret[key]
				loop
			endif
			if ! (valtype(cDesc[key]) == "A")
				cDesc[key] := ret[key]
				loop
			endif
			for j=1 to len(ret[key])
				if ascan( cDesc[key], ret[key][j] ) != 0
					loop
				endif
				aadd(cDesc[key], ret[key][j] )
			next
		next
	endif
return cDesc
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
		rddRLock(self:hDbMetaIdx)
		rddWrite(self:hDbMetaIdx,idxData)
		rddUnLock(self:hDbMetaIdx)
	else
		self:error := codb_error(1023)+":"+cId
		taskstart()
		return .f.
	endif
	rddSeek(self:hDbMeta,cID,.f.,.t.)
	/*
	while !rddEof(self:hDbMeta)
	      if ! (rddGetValue(self:hDbMeta,"ID") == cId)
			exit
	      endif
	      if rddGetValue(self:hDbMeta,"version") == oldVer
			found := .t.
			exit
	      endif
	      rddSkip(self:hDbMeta)
	enddo
	*/
	rec := rddRead(self:hDbMeta)
	if rec:id == cID
		rddRLock(self:hDbMeta)
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
		rddRLock(self:hDbMeta)
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
		rddRLock(self:hDbMetaIdx)
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
	rddRlock(self:hDbMeta)
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
	rddRlock(self:hDbMetaIdx)
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
	self:runTrigger(oData:id,"AFTER_UPDATE_CLASS",oData)
return  ret

************************************************************
static function _dict_checkBody(self,oData,metaName,lPadr)
	local tmp,i,body_stru, class_desc
	metaname := alltrim(metaname)
	do case
		case metaName=="GROUP"
			body_stru := CODB_GROUP_BODY
		case metaName=="USER"
			body_stru := CODB_USER_BODY
		case metaName=="ATTR"
			body_stru := CODB_ATTR_BODY
		case metaName=="EXTENT"
			body_stru := CODB_EXTENT_BODY
		case metaName=="CLASS"
			body_stru := CODB_CLASS_BODY
		case metaName=="DEPOSIT"
			body_stru := CODB_DEPOSIT_BODY
		case metaName=="TCOLUMN"
			body_stru := CODB_TCOLUMN_BODY
		case metaName=="TVIEW"
			body_stru := CODB_TVIEW_BODY
		case metaName=="REPORT"
			body_stru := CODB_REPORT_BODY
		case metaName=="PLUGINS"
			body_stru := CODB_PLUGINS_BODY
		case metaName=="INDEX"
			body_stru := CODB_INDEX_BODY
		case metaName=="COUNTER"
			body_stru := CODB_COUNTER_BODY
		otherwise
			body_stru := {}
			class_desc := self:getValue(metaname)
			if empty(class_desc)
				self:error := codb_error(1042)
				return oData
			endif
			for i=1 to len(class_desc:attr_list)
				tmp:=class_desc:attr_list[i]
				tmp:=self:getValue(tmp)
				if empty(tmp)
					outlog(__FILE__,__LINE__,[Internal error:],"oDict:getvalue("+toString(class_desc:attr_list[i])+")","in class",class_desc:name)
					loop
				endif
				aadd(body_stru,{alltrim(upper(tmp:name)),tmp:type,tmp:len,tmp:dec,tmp:lentype,tmp:defValue})
			next
	endcase
	if lPadr !=NIL .and. lPadr
		oData:=codb_padrBody(odata,body_stru)
	else
		oData:=codb_checkBody(odata,body_stru)
	endif
return oData
************************************************************
static function _dict_create(self)
	local tmp,tmp1,oCount
	self:error:=""
	if empty(self:path)
		self:error := codb_error(1020)
		return .f.
	endif
	if !makeDirectory(self:path)
		self:error := codb_error(1029)+":"+self:path
		return .f.
	endif
	if !makeDirectory(self:path+PATH_DELIM+"plugins")
		self:error := codb_error(1029)+":"+self:path+PATH_DELIM+"plugins"
		return .f.
	endif
	if !makeDirectory(self:path+PATH_DELIM+"modules")
		self:error := codb_error(1029)+":"+self:path+PATH_DELIM+"modules"
		return .f.
	endif
	if !make_version(self)
		return .f.
	endif
	self:counters := codb_countDbfNew(self:path)
	if !self:counters:create()
		self:error := self:counters:error
		return .f.
	endif
	if self:counters:open()
		self:counters:append("METADATA","Counter for meta data")
		self:counters:append("DEPOSIT","Counter for depositories")
	else
		self:error := codb_error(1030)
	endif
	self:counters:close()
	self:counters:=NIL
	if !codb_make_metadata(self)
		return .f.
	endif
	if ! self:open()
		return .f.
	endif
	/* add codbroot group & user */
	tmp:=map()
	tmp:name := "codbroot"
	self:append(tmp,"GROUP")
	tmp:name := "work"
	self:append(tmp,"GROUP")
	tmp:name := "nobody"
	self:append(tmp,"GROUP")

	tmp1:=self:select("GROUP",0,"codbroot")
	tmp:=map()
	tmp:name := "codbroot"
	tmp:group_id := tmp1[1]
	self:append(tmp,"USER")

	tmp1:=self:select("GROUP",0,"work")
	tmp:=map()
	tmp:name := "work"
	tmp:group_id := tmp1[1]
	self:append(tmp,"USER")

	tmp1:=self:select("GROUP",0,"nobody")
	tmp:=map()
	tmp:name := "anonymous"
	tmp:group_id := tmp1[1]
	self:append(tmp,"USER")

	/* add default extent */
	tmp:=map()
	tmp:name := "undef"
	tmp:help := [This extent only for undefined objects.]
	self:append(tmp,"EXTENT")

	/* add void attribute */
	tmp:=map()
	tmp:name := "void"
	tmp:type := "C"
	tmp:len  := 10
	tmp:lenType := 1
	self:append(tmp,"ATTR")

	/* add void class */
	tmp1:=self:select("EXTENT",0,"undef")
	tmp:=map()
	tmp:name := "void"
	tmp:extent_id := tmp1[1]
	self:append(tmp,"CLASS")

	self:close()
return .t.

************************************************************
static function make_version(self)
	local hf,dbfile
	dbfile:=self:path+PATH_DELIM+".version"
	if file(dbFile)
		/* 1021 used in codb_list !!! not changed*/
		self:error := codb_error(1021)+":"+self:path
		return .f.
	endif
	hf:=fcreate(dbfile)
	if hf<0 .or. !file(dbfile)
		self:error := codb_error(1022)+":"+dbFile+":"+str(ferror())+":"+ferrorstr()
		return .f.
	endif
	fwrite(hf,CODB_VERSION)
	fclose(hf)
return .t.
************************************************************
static function codb_make_metadata(self)
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
************************************************************
static function __check_haveCounters(self,oData)
	local i, attr, have := .f.
	for i=1 to len(oData:attr_list)
		attr := self:getValue(oData:attr_list)
		if empty(attr)
			loop
		endif
		if !empty(attr:counter)
			have := .t.
		endif
	next
	oData:have_counters := .t.
return

************************************************************
static function _dict_counter(name,deposit,value)
	local i,n:=0,rec,ret := 0, cId,tmp,obj
	if empty(name)
		return ret
	endif
	deposit := iif(empty(deposit),"",deposit)
	tmp := ::select("COUNTER")
	if empty(tmp)
		return ret
	endif
	for i=1 to len(tmp)
		obj := ::getValue(tmp[i])
		if empty(obj)
			loop
		endif
		if obj:name == name
			n := i
		endif
		if obj:name == name .and. obj:deposit==deposit
			cId := tmp[i]
			exit
		endif
	next
	if n<=0
		return ret
	endif
	if empty(cId)
		obj := ::getValue(tmp[n])
		adel(obj,"ID")
		obj:deposit := deposit
		obj:max_value := value
		obj:last_value := value
		cId := ::append(obj,"COUNTER")
		if !empty(cId) .and. value>0
			return value
		else
			return ret
		endif
	endif
	if empty(cId)
		return ret
	endif
	if cId $ ::__objCache
		adel(::__objCache,cId)
	endif
	if !rddSeek(::hDbMeta,cID,.f.)
		return ret
	endif
	for i=1 to 20
		if rddRlock(::hDbMeta)
			exit
		endif
		sleep(0.1)
	next
	if i>20
		return ret
	endif
	taskstop()
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
static function __loadPlugIns(sFile)
return loadPlugIns(sFile)

