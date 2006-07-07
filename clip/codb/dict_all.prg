/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual metods for all CODB drivers */

#include "codbcfg.ch"
#include "codb_dbf.ch"

static __objCache  := map()
static __plugCache := map()
static __modCache  := map()

************************************************************
function codb_dictAll_Methods(dbData,user,passwd)

	local obj	:= map()

	obj:classname	:= "CODBDICTIONARY"
	obj:id		:= padl(alltrim(dbData:id),codb_info("DICT_ID_LEN"),"0")
	obj:path	:= alltrim(dbData:path)
	obj:type	:= alltrim(dbData:type)
	obj:error	:= ""
	obj:user	:= user
	obj:counters	:= NIL
	obj:hDbMeta	:= NIL
	obj:hDbMetaIdx	:= NIL
	obj:server	:= NIL	  /* connect to SQL server */
	obj:serverData	:= oClone(dbData) /* data from codbList DB */

	obj:__enableTriggers := .t.
	//obj:__objCache	:= map()
	//obj:__plugCache	:= map()
	//obj:__modCache	:= map()
	obj:dictionary	:= @_dict_self()
	obj:idList	:= @_dict_IdList() // return object "ID list"
	obj:objCRC	:= @_dict_objCRC()
	obj:depository	:= @_dict_depository()
	obj:padrBody	:= @_dict_padrBody()
	obj:runTrigger  := @_dict_runTrigger()
	obj:stopTriggers  := @_dict_stopTriggers()
	obj:startTriggers  := @_dict_startTriggers()
	obj:metaBodyByName:= @_dict_metaBodyByName() // return meta BODY by name
	obj:classBodyByName:= @_dict_classBodyByName() // return class BODY by name
	obj:classByName := @_dict_classBodyByName() // return class ID by name
	obj:classIdByName := @_dict_classIdByName() // return class ID by name
	obj:attrBodyByName:= @_dict_attrBodyByName() // return class ID by name
	obj:attrByName  := @_dict_attrBodyByName() // return class ID by name
	obj:classDesc	:= @_dict_classDesc() // return class description with
					   // all inherites
	obj:close	:= @_dict_close()
	obj:open	:= @_dict_open()
	obj:loadModule	:= @_dict_LoadModule()
	obj:getModule	:= @_dict_getModule()
	obj:getTriggers := @_dict_getTriggers()
	obj:checkBody	:= @_dict_checkBody()
	obj:getValue	:= @_dict_getValue() // return body for ID
	obj:append	:= @_dict_append()
	obj:update	:= @_dict_update()
	obj:delete	:= @_dict_delete()
	obj:undelete	:= @_dict_undelete()

	obj:__check_haveCounters:= @__check_haveCounters()
	obj:loadPluginses:= @_dict_LoadPluginses()
	obj:counter	:= @_dict_counter() // check and return counter value
	obj:create	:= @_dict_create()

return obj
************************************************************
static function _dict_self(self)
return self
************************************************************
static function _dict_open(self)
	local tmp,i,m
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

	if !self:__open()
		return .f.
	endif

	codb_dict_register(self:id,self)
	self:runTrigger(self:id,"AFTER_OPEN_DICTIONARY")
return .t.
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

	self:__close()

	codb_dict_unregister(self:id)
	self:runTrigger(self:id,"AFTER_CLOSE_DICTIONARY")
return .t.
************************************************************
static function _dict_update(self,oData,metaName,aRecursive,lOut)
	local ret
	__objCache := map()
	taskStop()
	ret := self:_update(oData,metaName,aRecursive,lOut)
	taskStart()
	__objCache := map()
return ret
************************************************************
static function _dict_delete(self,cId)
	local ret
	adel(__objCache,cId)
	taskStop()
	ret := self:_delete(cId)
	taskStart()
return ret
************************************************************
static function _dict_undelete(self,cId)
	local ret
	adel(__objCache,cId)
	taskStop()
	ret := self:_undelete(cId)
	taskStart()
return ret
************************************************************
static function _dict_append(self,oData,metaName)
	local dep_id:="00",id:=""
	local i, oDep, list ,tmp, mtmp:={}
	local m, super_desc

	self:error := ""
	if empty(metaName)
		self:error := codb_error(1043)
		return ""
	endif

	metaName := alltrim(upper(metaName))

	oData := self:checkBody(oData,metaName)

	if metaName == "ATTR"
		if  !isword(oData:name)
			// check validate name
			self:error:=codb_error(1044)+":"+oData:name
			return ""
		endif
		if oData:type $ "RS"
			oData:len := CODB_ID_LEN
		endif
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
	if metaName=="CLASS"
		/* inherit from SUPER class*/
		super_desc := self:classDesc(oData:super_id)
		m:=aclone(oData:attr_list)
		if empty(super_desc)
			oData:attr_list:= {}
		else
			oData:attr_list:= aclone(super_desc:attr_list)
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
			oData:idx_list:= {}
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

	self:runTrigger(self:id,"BEFORE_APPEND_CLASS",oData)

	self:_append(oData,metaName)

	if !empty(self:error)
		return ""
	endif

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
		oDep:close()
	endif
	if metaName == "EXTENT"
		/* add new extent to exist depositories */
		list := self:select("DEPOSIT")
		for i=1 to len(list)
			tmp := self:getValue(list[i])
			aadd(mtmp, codb_needDepository(self:id+tmp:number))
			oDep := mTmp[i]
			if empty(oDep)
				loop
			endif
			if ! oDep:addExtent(id)
				self:error := oDep:error
				loop
			endif
		next
	endif
	if !empty(self:error)
		return ""
	endif
	codb_outlog(self:user,"append",oData)
	self:runTrigger(self:id,"AFTER_APPEND_CLASS",oData)

return id
************************************************************
static function _dict_getValue(self,cID,nLocks,version)
	local ret:=map(), err,bl

	self:error := ""
	if empty(cID)
		return ret
	endif
	cID := padr(cID,codb_info("CODB_ID_LEN"))
	if valtype(version)=="N" .or. nLocks != NIL
		adel(__objCache,cId)
	endif
	if cId $ __objCache .and. self:id==left(cId,DICT_ID_LEN)
		return __objCache[cId]
	endif
	if len(__objCache) > CODB_DICT_CACHE
		codb_cache_minimize(__objCache, CODB_DICT_CACHE/4 )
	endif

	taskStop()
	ret := self:_getValue(cID,nLocks,version)
	taskStart()

	if empty(ret)
		return ret
	endif
	__objCache[ cId ] := ret

	if alltrim(ret:__meta) == "CLASS"
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

		self:loadPluginses(cId)
	endif
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
static function _dict_attrBodyByName(attrName)
	local ret:=map(), tmp
	tmp := ::select("ATTR",,attrName)
	if !empty(tmp)
		ret:=::getValue(tmp[1])
	endif
return ret
************************************************************
static function _dict_classIdByName(self,className)
	local ret:=map(), tmp
	tmp := self:select("CLASS",,className)
	if !empty(tmp)
		ret := tmp[1]
	endif
return ret
************************************************************
static function _dict_classBodyByName(self,className)
	local ret:=map(), tmp
	tmp := self:select("CLASS",,className)
	if !empty(tmp)
		ret := self:getValue(tmp[1])
	endif
return ret
************************************************************
static function _dict_metaBodyByName(self,metaClass,metaName)
	local ret:=map(), tmp
	tmp := self:select(metaClass,,metaName)
	if !empty(tmp)
		ret := self:getValue(tmp[1])
	endif
return ret
************************************************************
static function _dict_IdList(self,metaName,nIndex,sName,sWhere,nCount,deleted)
return coDb_IdList(self,metaName,nIndex,sName,sWhere,nCount,deleted)
************************************************************
static function _dict_objCRC(self,obj)
return ntoc(crc32(var2str(obj)),32,8,"0")
************************************************************
static function _dict_padrBody(self,oData,metaName)
return	self:checkBody(oData,metaName,.t.)
************************************************************
static function _dict_stopTriggers(self)
	self:__enableTriggers := .f.
return
************************************************************
static function _dict_startTriggers(self)
	self:__enableTriggers := .t.
return
************************************************************
static function _dict_runTrigger(self,cId,cTrigger,oldBody,NewBody)
	local i,m,ret:=.t., tret
	if !self:__enableTriggers
		return ret
	endif
	m:=self:getTriggers(cId,cTrigger)
	for i=1 to len(m)
		tret := eval(m[i],self,oldBody,newBody)
		ret := ret .and. ( valtype(tret)=="L" .and. tret)
	next
return ret
************************************************************
static function _dict_depository(self,sDep)
	local sDeposit:=sDep, depName :=""
	local tmp,i,oTmp
	if len(sdep)==codb_info("DEPOSIT_ID_LEN")+codb_info("DICT_ID_LEN")
		sDep := substr(sDep,codb_info("DICT_ID_LEN")+1)
	endif
	if len(sdep)==codb_info("DEPOSIT_ID_LEN")
		tmp:= self:select("DEPOSIT")
		sDeposit := ""
		for i=1 to len(tmp)
			otmp:=self:getValue(tmp[i])
			if oTmp:number == sDep
				depName := oTmp:name
				sDeposit:=tmp[i]
			endif
		next
	endif
	tmp := self:__depNew(sDeposit)
	tmp:name := depName
return tmp
************************************************************
static function _dict_loadModule(modname)
	local tmp,obj,bCode,file

	if modname $ __modCache
		return .t.
	endif

	tmp := ::__loadPlugins("_MODULE_",modname)
	if empty(tmp)
		return .t.
	endif
	obj:= ::getValue(tmp[1])
	if empty(obj)
		return .t.
	endif
	file:= PATH_DELIM+"tmp"+PATH_DELIM+"codb"+;
		+PATH_DELIM+::id+PATH_DELIM+"modules"+PATH_DELIM
	makeDirectory(file)
	file += obj:filename
	if "SOURCE" $ obj
		memowrit(file,obj:source)
		chmod(file,"666")
	endif
	if !file(file)
		::error := codb_error(1035)+":"+file
		return .f.
	endif

	bCode := loadPlugIns(file)
	if valtype(bCode) =="C"
		::error := codb_error(1036)+":"+bCode
	else
		__modCache[modname] := bCode
	endif
	if !empty(::error)
		outlog(2,"CODB:",::error)
	endif
return empty(::error)
************************************************************
static function _dict_getModule(modname)
	if modname $ __modCache
		return __modCache[ modname ]
	endif
return NIL
************************************************************
static function _dict_getTriggers(self,cId,cTrigger)
	/*
	if self:counters == NIL .or. self:hDbMetaIdx == NIL .or. self:hDbMeta == NIL
		return {}
	endif
	*/
	self:loadPluginses(cId)
	if !(cId $ __PlugCache)
		return {}
	endif
	if !(cTrigger $ __PlugCache[cId])
		return {}
	endif
return  __PlugCache[cId][cTrigger]
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
		case metaName=="SEMA"
			body_stru := CODB_SEMA_BODY
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
static function __check_haveCounters(self,oData)
	local i, attr, have := .f.
	for i=1 to len(oData:attr_list)
		attr := self:getValue(oData:attr_list[i])
		if empty(attr)
			loop
		endif
		if !empty(attr:counter)
			have := .t.
		endif
	next
	oData:have_counters := have //.t.
return

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
static function _dict_loadPluginses(cID)
	local i,j,obj,tmp,body, source1,source2, m:={}
	local bCode,path,file,bNames := {}
	local cExt,eblock,lErr:=.f.,lError
	if cId $ __PlugCache
		return .t.
	endif

	tmp := ::__loadPlugins(cId)

	for i=1 to len(tmp)
		obj := ::getValue(tmp[i])
		if empty(obj)
			loop
		endif
		if "CLASS_ID" $ obj .and. obj:class_id == cId
			aadd(m,obj)
		endif
	next
	__PlugCache[ cId ] := map()
	for i=1 to len(m)
		body:=m[i]
		file := ""
		lError := .f.
		if body:type $ "CS" .and. empty(body:filename)
			::error := codb_error(1031)+":"+"("+body:id+")"+body:name
			lError:=.t. ;loop
		endif
		if body:type $ "SL" .and. empty(body:mainfunc)
			::error := codb_error(1032)+":"+"("+body:id+")"+body:name
			lError:=.t. ;loop
		endif
		if body:type == "C"
			file:= PATH_DELIM+"tmp"+PATH_DELIM+"codb"+;
				+PATH_DELIM+::id+PATH_DELIM+"plugins"+PATH_DELIM
			makeDirectory(file)
			file += body:filename
			if "SOURCE" $ body
				source1 := body:source
			endif
			if file(file)
				source2 := memoread(file)
			endif
			if source1 != NIL .and. !(source1==source2)
				memowrit(file,source1)
				chmod(file,"666")
			endif
			if empty(source1)
				loop
			endif
		endif
		if body:type $ "CS" .and. !(file(file) .or. file(file+".prg"))
			::error := codb_error(1033)+":"+file
			lError:=.t. ;loop
		endif
		do case
			case body:type=="C"
				// CLIP source code as codeblock
				bCode := loadPlugIns(file)
				if valtype(bCode) == "C"
					::error := codb_error(1034)+":"+bCode+":"+file
					lError:=.t. ;loop
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
					lError:=.t. ;loop
				else
					if ! isfunction(body:mainfunc)
						::error := codb_error(1038)+":"+body:mainfunc+[ in ]+file
						lError:=.t. ;loop
					else
						bcode:= &("{|p1|"+body:mainfunc+"(p1)}")
					endif
				endif
			case body:type=="L"
				// linked mainfunc procedure
				if ! isfunction(body:mainfunc)
					::error := codb_error(1039)+":"+body:mainfunc
					lError:=.t. ;loop
				else
					bcode:= &("{|p1|"+body:mainfunc+"(p1)}")
				endif
			otherwise
				outlog("Undefined type of plugins:",body:type,body:name)
				loop
		endcase
		if lError
			loop
		endif
		bNames := eval(bCode,"MEMBERS")
		if valtype(bNames) == "C" .or. empty(bNames)
			::error := codb_error(1040)+":"+"("+body:id+")"+body:name
			if valtype(bNames) =="C"
				::error += "("+bNames+")"
			endif
			lError:=.t. ;loop
		endif
		for j=1 to len(bnames)
			if bnames[j] $ __PlugCache[ cId ]
			else
				__PlugCache[ cId ][ bNames[j] ] := {}
			endif
			aadd( __PlugCache[ cId ][ bNames[j] ], eval(bCode,bNames[j]) )
		next
	next
	if !empty(::error)
		outlog(2,"CODB:",::error)
	endif
return empty(::error)
************************************************************
static function _dict_counter(name,deposit,value)
	local i,n:=0,cId,tmp,obj
	if empty(name)
		return 0
	endif
	deposit := iif(empty(deposit),"",deposit)
	tmp := ::select("COUNTER")
	if empty(tmp)
		return 0
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
		return 0
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
			return 0
		endif
	endif
	if empty(cId)
		return 0
	endif
	if cId $ __objCache
		adel(__objCache,cId)
	endif
return ::__counter(cId,value)
************************************************************
static function _dict_create(self)
	local tmp,tmp1,oCount
	self:error:=""
	if !self:__makeDirs()
		return .f.
	endif
	if !self:__makeVersion(self)
		return .f.
	endif
	if ! self:makeTables(self)
		return .f.
	endif
	if ! self:makeIndies(self)
		return .f.
	endif
	self:counters := self:__countNew()
	/*
	if !self:counters:makeTables()
		self:error := self:counters:error
		return .f.
	endif
	if !self:counters:makeIndies()
		self:error := self:counters:error
		return .f.
	endif
	*/
	if self:counters:open()
		self:counters:append("METADATA","Counter for meta data")
		self:counters:append("DEPOSIT","Counter for depositories")
	else
		self:error := codb_error(1030)
	endif
	self:counters:close()
	self:counters:=NIL
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
