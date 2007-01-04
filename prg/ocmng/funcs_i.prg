/*
    Copyright (C) 2005-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
********************************
#include "ocmng.ch"

static dependies := {}
static ncount0 :=0, ncount1 := 0, ncount2:=0
static metaObjects := map()

*****************************************
function ocmngInstall(fName,nWhat,nLevel)
	local i,j,m,k,x,s,tm:=seconds()
	local fPath := "./",cFile
	local oComp,out:=space(0),err:=space(0)
	local error := ""

	nWhat  := iif(valtype(nWhat)=="N",nWhat,0)
	nLevel := iif(valtype(nLevel)=="N",nLevel,0)

	__ocmng_init_simbols()

	fName := __ocmng_getFile(fName)
	fPath := __pathFromFileName(fName)
	ocmngMessage([Reading file]+" "+fName,nLevel)
	s := memoRead(fName)
	if fError() != 0
		ocmngMessage(fErrorStr(),nLevel)
		return fErrorStr()
	endif

	oComp := str2var(s)

	dependies := {}
	ncount1 := 0; ncount2:=0
	set("COMPONENT_FILENAME",fName)
	error := __make_dependies(oComp,fPath,nLevel+1) // and check structures
	set("COMPONENT_FILENAME","")
	if empty(error)
		ocmngMessage([Found]+" "+alltrim(str(len(dependies)))+" "+[dependies for component ]+oComp:name, nLevel)
		***** add self dependence
		x := map()
		x:type    := "component"
		x:cdata   := makepath(fName)
		x:version := ""
		aadd(dependies,x)
		x := NIL
	else
		ocmngMessage(error,nLevel)
		return error
	endif

	? [Found dependies:]+alltrim(str(len(dependies)))
	for i=1 to len(dependies)
		? dependies[i]:cdata
	next
	?
	? [Installing components .....]
	for i=1 to len(dependies)
		cFile := dependies[i]:cdata
		cFile := strtran(cFile,".xml",".xmo")
		s := memoRead(cFile)
		if fError() != 0
			error := fErrorStr()
			ocmngMessage(error,nLevel)
			exit
		endif
		oComp := str2var(s)
		oComp:__filename__ := __ocmng_getFile(cFile)
		error := __ocmng_Install(oComp,nWhat,nLevel+1)
		if !empty(error)
			exit
		endif
	next

	if !empty(error)
		ocmngMessage(error,nLevel)
	else
		ocmngMessage([Installed component]+" "+fName,nLevel)
		ocmngMessage([Statistics:]+" "+;
			alltrim(str(nCount0))+" components, "+;
			alltrim(str(nCount1))+" metaobjects, "+;
			alltrim(str(nCount2))+" objects, "+;
			alltrim(str(seconds()-tm))+" seconds ",nLevel)
	endif

	// Remove unpacked component directory
	syscmd("rm -rf "+cygwinroot()+PATH_DELIM+"tmp"+PATH_DELIM+"ocmng"+PATH_DELIM,"",@out,@err)

return error
*****************************************
static function __ocmng_getFile(fName)
	local s:=""
	local subDir,cmd,out:=space(0),err:=space(0),dir

	// check if file exist
	if .not. file(fName)
		dir := directory(fName+"*.component")
		if len(dir) > 0
			fName := dir[len(dir)][1]
		else
			dir := directory(fName+"*.xmo")
			if len(dir) > 0
				fName := dir[len(dir)][1]
			endif
		endif
	endif
	// get from packed file
	if lower(right(fName,10)) == ".component"
		subDir := cygwinroot()+PATH_DELIM+"tmp"+PATH_DELIM+"ocmng"+PATH_DELIM+left(fName,len(fName)-10)+PATH_DELIM
		syscmd("mkdir -p "+subDir,"",@out,@err)
		cmd := "tar xvfz "+fName+" -C "+subDir
		syscmd(cmd,"",@out,@err)
		dir := directory(subDir+"*.xmo")
		if len(dir) > 0
			fName := dir[1][1]
		endif
	endif

return fName
*****************************************
static function __ocmng_Install(oComp,nWhat,nLevel)
	local error := "", cFile,cEnc
	local cName := ""

	ocmngMessage([Installing component]+" "+oComp:name,nLevel)

	cFile := set("COMPONENT_FILENAME",oComp:__filename__)
	if empty(oComp:encoding)
		cEnc := set("COMPONENT_ENCODING",host_charset())
	else
		cEnc := set("COMPONENT_ENCODING",oComp:encoding)
	endif

	error := __check_oldComponentVersion(oComp,nLevel)

	if nWhat == 0 .or. nWhat == 1
		if empty(error) .and. "DICTIONARY" $ oComp
			error := __install_dicts(oComp:dictionary,nLevel+1)
		endif
		if empty(error) .and. "META" $ oComp
			error := __install_metas(oComp:meta,nLevel+1)
		endif
	endif

	if nWhat == 0 .or. nWhat == 2
		if empty(error) .and. "OBJECTS" $ oComp
			error := __install_data(oComp:objects,oComp,nLevel+1)
		endif
	endif

	if empty(error)
		error := __registry_newComponentVersion(oComp,nLevel)
	endif

	if empty(error)
		ocmngMessage([Installed component]+" "+oComp:name,nLevel)
		nCount0 ++
	endif
	set("COMPONENT_FILENAME",cFile)
	set("COMPONENT_ENCODING",cEnc)
return error
*****************************************
static function	__check_oldComponentVersion(oComp,nLevel)
	local error := ""
return error
*****************************************
static function	__component_installed(name)
	local oDep,oDict,oClass,tmp

	oDep := codb_needDepository("ETC0101")
	oDict := oDep:dictionary()

	oClass := oDict:classBodyByName("mng_component")
	if empty(oClass)
		return .f.
	endif

	tmp := oDep:id4primaryKey(oClass:id,"component_name",name)
return !empty(tmp)
*****************************************
static function	__registry_newComponentVersion(oComp,nLevel)
	local error := ""
	local oDep, oDict
	local depClass, compClass, authClass, catClass
	local depData, compData
	local tmp,str,id,key
	local i
	local aTrans := {;
			{"VERSION","VERSION"},;
			{"DESCRIPTION","DESCRIPTION"},;
			{"LICENSE","LICENSE"},;
			{"CREATED","CREATED"},;
			{"MODIFIED","MODIFIED"},;
			{"DOCUMENTATION","DOCUMENTATION"};
			}

	oDep := codb_needDepository("ETC0101")
	if empty(oDep)
		return error
	endif
	if !empty(oDep:error)
		return error
	endif

	oDict := oDep:dictionary()

	compClass := oDict:classBodyByName("mng_component")
	authClass := oDict:classBodyByName("mng_author")
	catClass := oDict:classBodyByName("mng_category")

	if empty(compClass) .or. empty(authClass)
		error := [Warning! Class name not found:]+"mng_component,mng_author,mng_category"
		//ocmngMessage(error,nLevel)
		//oDep:close()
		return "" //error
	endif

	if "NAME" $ oComp .and. !empty(oComp:name)
		oComp:name := alltrim(oComp:name)
		id := oDep:id4primaryKey(compClass:id,compClass:unique_key,oComp:name)
		if !empty(id)
			compData := oDep:getValue(id)
		endif
		if empty(compData)
			compData := map()
			compData:id := ""
		endif
		compData:component_name := oComp:name
	else
		return error
	endif


	if "AUTHOR" $ oComp .and. !empty(oComp:author)
		oComp:author := alltrim(oComp:author)
		str := oComp:author
		tmp := oDep:id4primaryKey(authClass:id,authClass:unique_key,str)
		if empty(tmp)
			compData:mng_author := str
		else
			compData:mng_author := tmp
		endif
	endif
	if "CATEGORY" $ oComp .and. !empty(oComp:category)
		oComp:category := alltrim(oComp:category)
		str := oComp:category
		tmp := oDep:id4primaryKey(catClass:id,catClass:unique_key,str)
		if empty(tmp)
			compData:mng_category := str
		else
			compData:mng_category := tmp
		endif
	endif

	/* other simple attributes */
	for i=1 to len(aTrans)
		if aTrans[i][1] $ oComp
			compData[ aTrans[i][2]] := ""
		else
			loop
		endif
		str := alltrim(oComp[ aTrans[i][1] ])
		compData[ aTrans[i][2]] := str
	next

	compData:created := ctod(compData:created,"YYYY-MM-DD")
	compData:modified := ctod(compData:modified,"YYYY-MM-DD")

	key := "component:name:"+oComp:name

	__dublicate_metaobject(key,nLevel)

	if empty(compData:id)
		id := oDep:append(compData,compClass:id)
	else
		oDep:update(compData)
	endif
	error := oDep:error

	/*
	depClass := oDict:classBodyByName("mng_dependence")

	if empty(depClass) /*ocmng classes not installed*/
		return error
	endif
	*/

return error
*****************************************
static function __install_data(aData,oComp,nLevel)
	local n, error := ""
	if valtype(aData) == "A"
	else
		error := [Bad data of DATA]
		ocmngMessage(error,nLevel)
		return error
	endif

	for n = 1 to len(aData)
		error := __install_objects(aData[n],oComp,nLevel)
		if !empty(error)
			exit
		endif
	next
return error
*****************************************
static function __install_objects(oData,oComp,nLevel)
	local error := "",s,s1,n,n1, rules
	local sDep := "", classname := ""
	local oDep, oDict, _oClass, oClass
	if valtype(oData) == "O"
	else
		error := [Bad data of OBJECTS]
		ocmngMessage(error,nLevel)
		return error
	endif
	if "INSTALLONLY" $ upper(oData:rules)
		if __component_installed(oComp:name)
			ocmngMessage("Data already installed for component "+oComp:name,nLevel)
			return ""
		endif
	endif
	if "DEPOSITORY" $ oData
		sDep := oData:depository
	endif
	if "CLASS" $ oData
		className := oData:class
	endif
	if empty(sDep)
		error := [Depository ID not defined]
		ocmngMessage(error,nLevel)
		return error
	endif
	if empty(className)
		error := [Class name not defined]
		ocmngMessage(error,nLevel)
		return error
	endif

	oDep := codb_needDepository(sDep)
	if empty(oDep)
		error := [Depository not found:]+sDep
		ocmngMessage(error,nLevel)
		return error
	endif
	if !empty(oDep:error)
		error := oDep:error
		ocmngMessage(error,nLevel)
		return error
	endif
	oDict := oDep:dictionary()
	_oClass := oDict:classBodyByName(classname)
	if empty(_oClass)
		error := [Class name not found:]+className
		ocmngMessage(error,nLevel)
		//oDep:close()
		return error
	endif

	oClass := oClone(_oClass)
	for n=1 to len(oClass:attr_list)
		s := oClass:attr_list[n]
		s1 := oDict:getValue(s)
		if empty(s1)
			error := [Attribute ID not found:]+s
			exit
		endif
		oClass:attr_list[n] := s1
		s1 := NIL
	next

	if !empty(error)
		ocmngMessage(error,nLevel)
		//oDep:close()
		return error
	endif

	ocmngMessage([Installing objects for]+" "+sDep+":"+classname,nLevel)
	rules := set("OCMNG_RULES",oData:rules)
	n1 := nCount2
	for n=1 to len(oData:object)
		error := __install_object(oDep,oClass,oData:object[n],nLevel+1)
		if !empty(error)
			exit
		endif
	next
	set("OCMNG_RULES",rules)
	if empty(error)
		s1 := str(n-1,6,0)
		s1 := strtran(s1," ","0")
		s :=[Installed $$$$$$/###### objects for]+" "+sDep+":"+classname
		s := strtran(s,"######",s1)
		s1 := str(nCount2-n1,6,0)
		s1 := strtran(s1," ","0")
		s := strtran(s,"$$$$$$",s1)
		ocmngMessage(s,nLevel)
	else
		ocmngMessage(error,nLevel)
	endif

	//oDep:close()
return error
*****************************************
static function __install_object(oDep,oClass,obj,nLevel)
	local error, rules := set("OCMNG_RULES")
	local i,j,x,id,name,type,attr
	local data
	local oData := map()

	//? "a1",obj
	for i=1 to len(oClass:attr_list)
		attr := oClass:attr_list[i]
		name := upper(attr:name)
		j := ascan(obj, {|x| upper(x:name) == name} )
		if j <= 0
			loop
		endif
		data := ___convertData(oDep,obj[j],attr:type,oClass:name,nLevel+1)
		//? "a1",name,data
		if data == NIL
			loop
		endif
		oData[name] := data
	next

	/* search installed object by unique value*/
	if !empty(oClass:unique_key)
		name := upper(oClass:unique_key)
		if name $ oData
			data := oData[name]
		else
			data := ""
		endif
		if empty(data)
		else
			id := oDep:id4primaryKey(oClass:id,oClass:unique_key,data)
			oData:id := id
		endif
	endif

	//? "a11",oData
	*****
//	outlog(__FILE__,__LINE__,rules,oClass:name,ncount2)
	if "ID" $ oData .and. !empty(oData:id)
		if "APPENDONLY" $ upper(rules)
		else
			nCount2 ++
			oDep:update(oData)
		endif
	else
		nCount2 ++
		oDep:append(oData,oClass:id)
	endif
//	outlog(__FILE__,__LINE__,rules,oClass:name,ncount2)
	//? "a111",oDep:error

return oDep:error
*****************************************
static function ___convertData(oDep,oData,type,className,nLevel)
	local data := NIL
	local i,j,_val,val,vType,refto,sMeta
	local types := codb_info("CODB_ATTR_TYPES")

	if "TYPE" $ oData
		type := upper(oData:type)
	endif
	if empty(type)
		return data
	endif
	j := ascan(types,{|x| upper(x[3]) == type})
	if j > 0
		type := types[j][1]
	endif
	*****
	//? "b11",oData
	if "CDATA" $ oData
		val := oData:cdata
	endif
	if "VALUE" $ oData
		val := oData:value
	endif
	//? "b1",nLevel,val
	if empty(type) .or. val == NIL
		return data
	endif
	vType := valtype(val)
	data := NIL
	do case
		case type == "C"
			if vType $ "C"
				data := __decoding(val)
			else
				data := toString(val)
			endif
		case type == "N"
			data := val(val)
		case type == "D"
			data := stod(val)
			if empty(data)
				data := ctod(val,"yyyy-mm-dd")
			endif
		case type == "L"
			if vType == "C"
				data := ( left(val,1) $ "yYtT" )
			elseif vType == "L"
				data := val
			else
				data := .f.
			endif
		case type == "R"
			if vType == "C"
				refTo := oData:refto
				if empty(refTo)
					refTo := className
				endif
				data := __searchIdByUniKey(oDep,refTo,val,nLevel)
			else
				data := ""
			endif
		case type == "S"
			if "META" $ oData
				sMeta := oData:meta
			else
				sMeta := "CLASS"
			endif
			if vType == "C"
				data := __searchIdByName(oDep:dictionary(),sMeta,val,nLevel)
			else
				data := ""
			endif
		case type == "A"
			data:= {}
			if vType == "A"
			else
				val := {}
			endif
			for i=1 to len(val)
				oData := val[i]
				//? "b2",nLevel,oData
				aadd(data,___convertData(oDep,oData,type,className,nLevel+1))
				//? "b3",nLevel,atail(data)
			next
		case type == "O"
		case type $ "MXB"
			if vType $ "C"
				val := __decoding(val)
			else
				val := toString(val)
			endif
			// load from file
			data := ___readMemoFile(val,nLevel)
		otherwise
			ocmngMessage([Warning! Bad type of attribute:]+type,nLevel)
	endcase
return data
*****************************************
static function ___readMemoFile(sName,nLevel)
	local i,j,ret := ""
	local fName := set("COMPONENT_FILENAME")

	i := atr("/",fName)
	if i<=0
		i := atr("\",fName)
	endif
	if i > 0
		fName := substr(fName,1,i)
	endif
	fName += sName

	if !file(fName)
		return sName
	endif

	ocmngMessage([Reading file]+" "+fName,nLevel)
	ret := memoRead(fName)
	if fError() != 0
		ocmngMessage(fErrorStr(),nLevel)
		return fErrorStr()
	endif
return ret
*****************************************
static function __install_metas(aMetas,nLevel)
	local n, error := ""
	if valtype(aMetas) == "A"
	else
		error := [Bad data of META]
		ocmngMessage(error,nLevel)
		return error
	endif

	for n = 1 to len(aMetas)
		error := __install_meta(aMetas[n],nLevel)
		if !empty(error)
			exit
		endif
	next
return error
*****************************************
static function __install_meta(oMeta,nLevel)
	local error := "", rules:=""
	local dList, oData := map()
	local i,j,s,s1,s2,m
	local oDict
	local metaTypes1 := {;
			{"DEPOSIT","DEPOSITORY"},;
			{"COUNTER","COUNTER"},;
			{"INDEX","INDEX"};
		  }

	if valtype(oMeta) == "O"
	else
		error := [Bad data of META]
		ocmngMessage(error,nLevel)
		return error
	endif
	if empty(oMeta:dictionary)
		error := [Bad dictionary name of META]
		ocmngMessage(error,nLevel)
		return error
	endif
	oDict := codb_needDepository(oMeta:dictionary)
	if empty(oDict) .or. !empty(oDict:error)
		error := [Error opening dictionary]+" "+oMeta:dictionary+":"
		if empty(oDict)
			error += " "+[dictionary not installed]
		else
			error += " "+oDict:error
		endif
		ocmngMessage(error,nLevel)
		return error
	endif

	ocmngMessage([Installing meta data ]+oMeta:dictionary,nLevel)
	rules := set("OCMNG_RULES",oMeta:rules)


	if "EXTENT" $ oMeta .and. valtype(oMeta:extent) == "A"
		for i=1 to len(oMeta:extent)
			error := __install_extent(oDict,oMeta:extent[i],nLevel+1)
			if !empty(error)
				exit
			endif
		next
	endif
	if empty(error) .and. "ATTRIBUTE" $ oMeta .and. valtype(oMeta:attribute) == "A"
		for i=1 to len(oMeta:attribute)
			error := __install_attribute(oDict,oMeta:attribute[i],nLevel+1)
			if !empty(error)
				exit
			endif
		next
	endif

	if empty(error)
	   for j=1 to len(metaTypes1)
		s1 := metaTypes1[j][1]
		s2 := metaTypes1[j][2]
		if s2 $ oMeta .and. valtype(oMeta[s2]) == "A"
		else
			loop
		endif
		for i=1 to len(oMeta[s2])
			error := __install_meta1(oDict,oMeta[s2][i],s1,nLevel+1)
			if !empty(error)
				exit
			endif
		next
	   next
	endif
	if empty(error) .and. "CLASS" $ oMeta .and. valtype(oMeta:class) == "A"
		for i=1 to len(oMeta:class)
			error := __install_class(oDict,oMeta:class[i],nLevel+1)
			if !empty(error)
				exit
			endif
		next
	endif
	if empty(error) .and. "PLUGIN" $ oMeta .and. valtype(oMeta:plugin) == "A"
		for i=1 to len(oMeta:plugin)
			error := __install_plugin(oDict,oMeta:plugin[i],nLevel+1)
			if !empty(error)
				exit
			endif
		next
	endif
	if empty(error) .and. "TCOLUMN" $ oMeta .and. valtype(oMeta:tcolumn) == "A"
		for i=1 to len(oMeta:tcolumn)
			error := __install_tcolumn(oDict,oMeta:tcolumn[i],nLevel+1)
			if !empty(error)
				exit
			endif
		next
	endif
	if empty(error) .and. "TVIEW" $ oMeta .and. valtype(oMeta:tview) == "A"
		for i=1 to len(oMeta:tview)
			error := __install_tview(oDict,oMeta:tview[i],nLevel+1)
			if !empty(error)
				exit
			endif
		next
	endif
	set("OCMNG_RULES",rules)
	if !empty(error)
		return error
	endif

	//oDict:close()
	ocmngMessage([Installed meta data ]+oMeta:dictionary,nLevel)
return error

*****************************************
static function __install_meta1(oDict,oMeta,mType,nLevel)
	local error := "", oData := map()
	local i,s,s1,m
	local stru := codb_info("CODB_"+mType+"_BODY")
	local trans := map()

	trans:EXPR   := "EXPRESSION"

	if valtype(oMeta) == "O"
	else
		error := [Bad data of ]+mType
		ocmngMessage(error,nLevel)
		return error
	endif
	for i=1 to len(stru)
		s := stru[i][1]
		s := stru[i][1]
		s1 := iif( s $ trans, trans[s],s)
		if s1 $ oMeta
			oData[s] := oMeta[s1]
		else
			oData[s] := ""
		endif
	next
	if empty(oData:name)
		oData:name := oMeta:cdata
	endif
	if empty(oData:name)
		error := [Bad name of ]+mType
		ocmngMessage(error,nLevel)
		return error
	endif

	error := __append_meta_data(oDict,mType,oData,nLevel)

	if empty(error)
		ocmngMessage([Installed ]+lower(mtype)+" "+oData:name,nLevel)
	endif
return error
*****************************************
static function __install_attribute(oDict,oAttr,nLevel)
	local error := "", oData := map()
	local i,s,s1,m, types
	local stru := codb_info("CODB_ATTR_BODY")
	local trans := map()

	trans:NOT_NULL   := "NOTNULL"
	trans:NOT_EMPTY  := "NOTEMPTY"
	trans:LOG_NEED   := "LOGNEED"
	trans:REF_TO     := "REFTO"

	if valtype(oAttr) == "O"
	else
		error := [Bad data of ATTRIBUTE]
		ocmngMessage(error,nLevel)
		return error
	endif
	for i=1 to len(stru)
		s := stru[i][1]
		s1 := iif( s $ trans, trans[s],s)
		if s1 $ oAttr
			oData[s] := oAttr[s1]
		else
			oData[s] := ""
		endif
	next

	if empty(oData:name)
		error := [Bad name of ATTRIBUTE]
		ocmngMessage(error,nLevel)
		return error
	endif

	oData:len := val(oData:len)
	oData:dec := val(oData:dec)
	oData:ref_to := __searchIdByName(oDict,"CLASS",oData:ref_to,nLevel)

	**
	types := codb_info("CODB_ATTR_TYPES")
	i := ascan(types,{|x| upper(x[3]) == upper(oData:type)})
	if i > 0
		oData:type := types[i][1]
	else
		oData:type := "C"
		ocmngMessage([Warning ! Bad type of attribute]+" "+oData:name,nLevel)
	endif
	types :={"ignore","rtrim","alltrim","fill"}

	**
	i := ascan(types,{|x| upper(x) == upper(oData:lentype)})
	if i > 0
		oData:lentype := i
	else
		oData:lentype := 1
		ocmngMessage([Warning ! Bad len type of attribute]+" "+oData:name,nLevel)
	endif

	error := __append_meta_data(oDict,"ATTR",oData,nLevel)

	if empty(error)
		ocmngMessage([Installed attribute ]+oData:name,nLevel)
	endif
return error
*****************************************
static function __install_class(oDict,oClass,nLevel)
	local error := "", oData := map()
	local i,s,s1,m,x, types
	local stru := codb_info("CODB_CLASS_BODY")
	local trans := map()

	trans:LOG_NEED   := "LOGNEED"
	trans:EXTENT_ID  := "EXTENT"
	trans:SUPER_ID   :=  "SUPERCLASS"
	trans:EXPR_ESSENCE := "ESSENCE"
	trans:UNIQUE_KEY := "UNIQUEKEY"
	trans:IDX_MAIN   := "MAINIDX"
	trans:ATTR_LIST  := "ATTRIBUTES"
	trans:IDX_LIST   := "INDICES"
	trans:ATTR_FIND  := "FINDATTRS"
	trans:CLASS_ID   := "CLASS"
	trans:TCOL_LIST   := "COLUMNS"
	trans:TCOL_LIST   := "TCOLLIST"

	if valtype(oClass) == "O"
	else
		error := [Bad data of CLASS]
		ocmngMessage(error,nLevel)
		return error
	endif
	for i=1 to len(stru)
		s := stru[i][1]
		s1 := iif( s $ trans, trans[s],s)
		if s1 $ oClass
			oData[s] := oClass[s1]
		else
			oData[s] := ""
		endif
	next

	if empty(oData:name)
		error := [Bad name of CLASS]
		ocmngMessage(error,nLevel)
		return error
	endif

	oData:super_id := __searchIdByName(oDict,"CLASS",oData:super_id,nLevel)
	oData:extent_id := __searchIdByName(oDict,"EXTENT",oData:extent_id,nLevel)
	oData:tcol_list := ocmng_splitDelim(oData:tcol_list,",")
	oData:attr_find := ocmng_splitDelim(oData:attr_find,",")
	//oData:unstable := .t.
	aDel(oData,"UNSTABLE")

	***
	m := ocmng_splitDelim(oData:attr_list,",")
	oData:attr_list := {}
	x := oData:attr_list
	for i=1 to len(m)
		s := __searchIdByName(oDict,"ATTR",m[i],nLevel)
		if empty(s)
			loop
		endif
		aadd(x,s)
	next
	***
	m := ocmng_splitDelim(oData:idx_list,",")
	oData:idx_list := {}
	x := oData:idx_list
	for i=1 to len(m)
		s := __searchIdByName(oDict,"INDEX",m[i],nLevel)
		if empty(s)
			loop
		endif
		aadd(x,s)
	next
	***

	error := __append_meta_data(oDict,"CLASS",oData,nLevel)

	if empty(error)
		ocmngMessage([Installed class ]+oData:name,nLevel)
	endif
return error
*****************************************
static function __install_plugin(oDict,oPlug,nLevel)
	local error := "", oData := map()
	local i,s,s1,m, types
	local stru := codb_info("CODB_PLUGINS_BODY")
	local trans := map()

	trans:CLASS_ID   := "CLASS"
	trans:FILENAME   := "FILE"
	trans:MAINFUNC   := "FUNCTION"

	if valtype(oPlug) == "O"
	else
		error := [Bad data of PLUGIN]
		ocmngMessage(error,nLevel)
		return error
	endif
	for i=1 to len(stru)
		s := stru[i][1]
		s1 := iif( s $ trans, trans[s],s)
		if s1 $ oPlug
			oData[s] := oPlug[s1]
		else
			oData[s] := ""
		endif
	next
	if "SOURCEFILE" $ oPlug
		oData:sourceFile := oPlug:sourceFile
	endif
	//? oPlug
	//? oData

	if empty(oData:name)
		error := [Bad name of PLUGIN]
		ocmngMessage(error,nLevel)
		return error
	endif

	oData:class_id  := __searchIdByName(oDict,"CLASS" ,oData:class_id,nLevel)

	s := set("COMPONENT_FILENAME")
	i := atr("/",s)
	if i<=0
		i := atr("\",s)
	endif
	if i > 0
		s := substr(s,1,i)
	endif
	if "SOURCEFILE" $ oData
		//if file(s+oData:sourceFile)
			s += oData:sourceFile
		//endif
	else
		s += oData:filename
	endif

	if !file(s)
		error := [File not found:]+s
		ocmngMessage(error,nLevel)
		return error
	endif

	ocmngMessage([Reading file]+" "+s,nLevel)
	s1 := memoRead(s)
	if fError() != 0
		ocmngMessage(fErrorStr(),nLevel)
		return fErrorStr()
	endif

	oData:source    := s1

	types := codb_info("CODB_PLUGINS_TYPES")
	i := ascan(types,{|x| upper(x[3]) == upper(oData:type)})
	if i > 0
		oData:type := types[i][1]
	else
		oData:type := "C"
		ocmngMessage([Warning ! Bad type of plugin]+" "+oData:name,nLevel)
	endif

	error := __append_meta_data(oDict,"PLUGINS",oData,nLevel)

	if empty(error)
		ocmngMessage([Installed plugin ]+oData:name,nLevel)
	endif
return error
*****************************************
static function __install_tcolumn(oDict,oTcol,nLevel)
	local error := "", oData := map()
	local i,s,s1,m
	local stru := codb_info("CODB_TCOLUMN_BODY")
	local trans := map()

	trans:DEPEND_OF   := "DEPEND_OF"
	trans:EXPR        := "EXPRESSION"

	if valtype(oTcol) == "O"
	else
		error := [Bad data of TCOLUMN]
		ocmngMessage(error,nLevel)
		return error
	endif
	for i=1 to len(stru)
		s := stru[i][1]
		s1 := iif( s $ trans, trans[s],s)
		if s1 $ oTcol
			oData[s] := oTcol[s1]
		else
			oData[s] := ""
		endif
	next

	if empty(oData:name)
		error := [Bad name of TCOLUMN]
		ocmngMessage(error,nLevel)
		return error
	endif

	oData:width := val(oData:width)
	oData:refs  := ocmng_splitDelim(oData:refs,",")

	error := __append_meta_data(oDict,"TCOLUMN",oData,nLevel)

	if empty(error)
		ocmngMessage([Installed tcolumn ]+oData:name,nLevel)
	endif
return error
*****************************************
static function __install_tview(oDict,oTv,nLevel)
	local error := "", oData := map()
	local i,s,s1,m
	local stru := codb_info("CODB_TVIEW_BODY")
	local trans := map()

	trans:CLASS_ID    := "CLASS"
	trans:EXTENT_ID   := "EXTENT"
	trans:GROUP_ID    := "GROUP"
	trans:USER_ID     := "GROUP"
	trans:COL_LIST    := "COLUMNS"

	if valtype(oTv) == "O"
	else
		error := [Bad data of TVIEW]
		ocmngMessage(error,nLevel)
		return error
	endif
	for i=1 to len(stru)
		s := stru[i][1]
		s1 := iif( s $ trans, trans[s],s)
		if s1 $ oTv
			oData[s] := oTv[s1]
		else
			oData[s] := ""
		endif
	next

	if empty(oData:name)
		error := [Bad name of TVIEW]
		ocmngMessage(error,nLevel)
		return error
	endif

	oData:class_id  := __searchIdByName(oDict,"CLASS" ,oData:class_id,nLevel)
	oData:extent_id := __searchIdByName(oDict,"EXTENT",oData:extent_id,nLevel)
	oData:group_id  := __searchIdByName(oDict,"GROUP" ,oData:group_id,nLevel)
	oData:user_id   := __searchIdByName(oDict,"USER"  ,oData:user_id,nLevel)
	oData:col_list  := ocmng_splitDelim(oData:col_list,",")
	for i=1 to len(oData:col_list)
		oData:col_list[i]   := __searchIdByName(oDict,"TCOLUMN"  ,oData:col_list[i],nLevel)
	next

	error := __append_meta_data(oDict,"TVIEW",oData,nLevel)

	if empty(error)
		ocmngMessage([Installed tview ]+oData:name,nLevel)
	endif
return error
*****************************************
static function __install_extent(oDict,oExt,nLevel)
	local error := "", oData := map()
	local i,s,m
	local stru := codb_info("CODB_EXTENT_BODY")
	if valtype(oExt) == "O"
	else
		error := [Bad data of EXTENT]
		ocmngMessage(error,nLevel)
		return error
	endif
	for i=1 to len(stru)
		s := stru[i][1]
		if s $ oExt
			oData[s] := oExt[s]
		else
			oData[s] := ""
		endif
	next
	if empty(oData:help)
		oData:help := oExt:cdata
	endif
	if empty(oData:name)
		error := [Bad name of EXTENT]
		ocmngMessage(error,nLevel)
		return error
	endif

	error := __append_meta_data(oDict,"EXTENT",oData,nLevel)

	if empty(error)
		ocmngMessage([Installed extent ]+oData:name,nLevel)
	endif
return error
*****************************************
static function __install_dicts(aDicts,nLevel)
	local nDict, error := ""
	if valtype(aDicts) == "A"
	else
		error := [Bad data of DICTIONARY]
		ocmngMessage(error,nLevel)
		return error
	endif

	for nDict = 1 to len(aDicts)
		error := __install_dict(aDicts[nDict],nLevel)
		if !empty(error)
			exit
		endif
	next
return error
*****************************************
static function __install_dict(oDict,nLevel)
	local error, rules := set("OCMNG_RULES")
	local dList, oData := map()
	local i,s,m
	if valtype(oDict) == "O"
	else
		error := [Bad data of DICTIONARY]
		ocmngMessage(error,nLevel)
		return error
	endif

	dList:=codbList():new()
	if val(dList:error)!=0
		error := [Error open dictionary list!]+":"+dList:error
		ocmngMessage(error,nLevel)
		return error
	endif

	m := mapKeys(oDict)
	for i=1 to len(m)
		s := hashName(m[i])
		oData[s] := oDict[s]
	next

	if "ID" $ oData
	else
		error := [Bad data about dictionary]
		ocmngMessage(error,nLevel)
		return error
	endif

	if dList:existId(oData:id)
		if "APPENDONLY" $ rules
		else
			dList:update(oData)
		endif
	else
		dList:append(oData)
	end
	if !empty(dList:error)
		error := dList:error
		ocmngMessage(error,nLevel)
		return error
	endif
	ocmngMessage([Installed dictionary ]+oData:id,nLevel)
return error
*****************************************
static function __make_dependies(oComp,fPath,nLevel)
	local aDeps,nDep, oDep
	local error := "", cName := ""
	local s,tmp, cType, cFile
	local _cFile

	if !(valtype(oComp) == "O" .and. oComp:classname == "XMLCOMPONENT")
		error := [Bad data of COMPONENT]
		ocmngMessage(error,nLevel)
		return error
	endif

	if ! (oComp:cVersion == OCMNG_VERSION)
		error := [Bad version data:]+oComp:cVersion
		ocmngMessage(error,nLevel)
		return error
	endif

	if "NAME" $ oComp
		cName := oComp:name
	else
		error := [Bad name of component]
		ocmngMessage(error,nLevel)
		return error

	endif

	if "DEPENDENCE" $ oComp
	else
		return error
	endif

	ocmngMessage([Making dependies for component ]+cName,nLevel)

	aDeps := oComp:dependence

	if valtype(aDeps) == "A"
	else
		error := [Bad data of DEPENDENCE]
		ocmngMessage(error,nLevel)
		return error
	endif

	for nDep = 1 to len(aDeps)
		oDep := aDeps[nDep]
		if valtype(oDep) == "O"
		else
			error := [Bad data of DEPENDENCE]
			ocmngMessage(error,nLevel)
			exit
		endif
		cType := ""
		oDep:cdata := makepath(fPath+alltrim(oDep:cData))
		cFile := alltrim(oDep:cData)
		if "TYPE" $ oDep
			cType := alltrim(upper(oDep:type))
		endif
		if cType == "COMPONENT"
			if __check_dependence_exist(oDep)
				loop
			endif
			cFile := strtran(cFile,".xml",".xmo")
			ocmngMessage([Reading file]+" "+cFile,nLevel)
			s := memoRead(cFile)
			if fError() != 0
				error := fErrorStr()
				ocmngMessage(error,nLevel)
				exit
			endif
			oComp := str2var(s)
			//? nLevel,fPath,cfile
			_cFile := set("COMPONENT_FILENAME",cFile)
			error := __make_dependies(oComp,__pathFromFileName(cFile),nLevel+1)
			set("COMPONENT_FILENAME",_cFile)
			if !empty(error)
				exit
			endif
			aadd(dependies,oDep)
			loop
		endif
		if cType == "CLIPVERSION"
			if !__check_Version(cFile,version())
				error := [Uncompatible CLIP version:]+cFile
				ocmngMessage(error,nLevel)
				exit
			endif
			loop
		endif
		if cType == "CODBVERSION"
			if !__check_Version(cFile,codb_version())
				error := [Uncompatible CODB version:]+cFile
				ocmngMessage(error,nLevel)
				exit
			endif
			loop
		endif
	next
return error
*****************************************
static function __check_Version(cVer,sVer)
	local ret := .f., x1:=0, x2:=0
	local i,j, s1,s2
	i := atr(".",cVer)
	j := atr(".",sVer)
	if i<=0 .and. j>0
		return ret
	endif
	s1 := substr(cVer,i+1)
	s2 := substr(sVer,j+1)
	x1 += val(s1)
	x2 += val(s2)
	cVer := substr(cVer,1,i-1)
	sVer := substr(sVer,1,j-1)
	i := atr(".",cVer)
	j := atr(".",sVer)
	if i<=0 .and. j>0
		return ret
	endif
	s1 := substr(cVer,i+1)
	s2 := substr(sVer,j+1)
	x1 += val(s1)*1000
	x2 += val(s2)*1000
	cVer := substr(cVer,1,i-1)
	sVer := substr(sVer,1,j-1)
	i := atr(":",cVer)
	j := atr(":",sVer)
	if i<=0 .and. j>0
		return ret
	endif
	s1 := substr(cVer,i+1)
	s2 := substr(sVer,j+1)
	x1 += val(s1)*1000000
	x2 += val(s2)*1000000
return x1<=x2

*****************************************
static function __check_dependence_exist(oDep)
	local i,x,y,ret := .f.
	for i=1 to len(dependies)
		x := dependies[i]
		if x:type == oDep:type .and. x:cdata == oDep:cdata
			ret := .t.
			exit
		endif
	next
return ret
*****************************************
static function __decoding(cVal)
return	translate_charset(set("COMPONENT_ENCODING"),host_charset(),cVal)
*****************************************
static function __pathFromFileName(fName)
	local i,j,fPath := "./"

	i := atr("/",fName)
	j := atr("\",fName)
	i := max(i,j)
	if i>0
		fPath := left(fName,i)
	endif
return fPath
*****************************************
static function __append_meta_data(oDict,sMeta,oData,nLevel)
	local tmp, rules := upper(set("OCMNG_RULES"))
	local key

	key := oDict:id+":"+sMeta+":"+oData:name
	__dublicate_metaobject(key,nLevel)

	tmp := oDict:select(sMeta,,oData:name)

	//outlog(__FILE__,__LINE__,oData)


	if empty(tmp)
		nCount1++
		oData:id := oDict:append(oData,sMeta)
		//outlog(__FILE__,__LINE__,sMeta,oData)
	else
		if "APPENDONLY" $ rules
		else
			oData:id := tmp[1]
			nCount1++
			oDict:update(oData,sMeta,,.t.)
			//outlog(__FILE__,__LINE__,sMeta,oData)
			if len(tmp) > 1 .and. ! (sMeta == "COUNTER")
				ocmngMessage([Warning ! Metadata have duplicate objects for]+" "+sMeta+":"+oData:name,nLevel)
			endif
		endif
	endif
return	oDict:error
*****************************************
static function __searchIdByUniKey(_oDep,sRef,sKeyVal,nLevel)
	local ret := sRef+"/"+sKeyVal
	local x, tmp, error := ""
	local oDep,sDep,sName
	local oDict,oClass
	if empty(sRef) .or. empty(sKeyVal)
		return "" //ret
	endif

	x := at(":",sRef)
	if x==0
		sName := sRef
		oDep := _oDep
	else
		sName := substr(sRef,x+1)
		sDep := substr(sRef,1,x-1)
		if len(sDep) != codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN")
			error := [Warning! Bad depository ID:]+sDep
			ocmngMessage(error,nLevel)
			return ret
		endif
		oDep := codb_needDepository(sDep)
		if empty(oDep) .or. !empty(oDep:error)
			error := [Warning! Error opening depository]+" "+sDep+":"
			if empty(oDict)
				error += " "+[depository not installed]
			else
				error += " "+oDep:error
			endif
			ocmngMessage(error,nLevel)
			return ret
		endif
	endif

	oDict := oDep:dictionary()
	oClass := oDict:classBodyByName(sName)
	if empty(oClass)
		error := [Warning! Class name not found:]+sName
		ocmngMessage(error,nLevel)
		return ret
	endif

	if !empty(oClass:unique_key)
		tmp := oDep:id4primaryKey(oClass:id,oClass:unique_key,sKeyVal)
		//? tmp, oDep:id,oClass:id,oClass:name,oClass:unique_key,sKeyVal
		if empty(tmp)
			error := [Warning! Reference not found:]+ret
			ocmngMessage(error,nLevel)
		else
			ret := tmp
		endif
	else
		error := [Warning! Class don`t have unique index:]+sRef
		ocmngMessage(error,nLevel)
	endif
return ret
*****************************************
static function ocmng_splitDelim(str,ch)
	local ret,i
	str := strtran(str,"&\n","")
	ret := splitDelim(str,,ch)

	for i=1 to len(ret)
		ret[i] := alltrim(ret[i])
	next
return ret
*****************************************
static function __searchIdByName(_oDict,sMeta,sRef,nLevel)
	local ret := "", x, tmp, error := ""
	local oDict,sDict,sName
	if empty(sMeta) .or. empty(sRef)
		return ret
	endif

	x := at(":",sRef)
	if x==0
		sName := sRef
		oDict := _oDict
	else
		sName := substr(sRef,x+1)
		sDict := substr(sRef,1,x-1)
		oDict := codb_needDepository(sDict)
		if empty(oDict) .or. !empty(oDict:error)
			error := [Warning! Error opening dictionary]+" "+sDict+":"
			if empty(oDict)
				error += " "+[dictionary not installed]
			else
				error += " "+oDict:error
			endif
			ocmngMessage(error,nLevel)
			return ret
		endif
	endif

	tmp:=oDict:select(sMeta,,sName)
	if !empty(tmp)
		ret := tmp[1]
	else
		ocmngMessage([Warning! Meta not found:]+sMeta+"/"+sRef,nLevel)
	endif
return ret
*****************************************
static function __dublicate_metaobject(key,nLevel)
	local rules := upper(set("OCMNG_RULES"))
	if key $ metaObjects
		if "APPENDONLY" $ rules
			ocmngMessage([Warning ! Metaobject already defined]+" "+key,nLevel)
			ocmngMessage([First definition here]+" "+metaObjects[key][2],nLevel)
		endif
	else
		metaObjects[key] := {key,set("COMPONENT_FILENAME")}
	endif
return
#include "funcs_s.prg"

