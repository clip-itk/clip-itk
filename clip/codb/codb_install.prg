/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* install META data for global dictionary */

function codb_install(dict_id,xmlFile)
	local modules,dict,xmlData:={}
	local i,ret
	if empty(dict_id) .or. empty(xmlFile)
		? "usage: codb_install <dictionary_id> <xmlFile_with_data> [module1 module2 .... moduleN]"
		?
		return .f.
	endif

	dict := coDictionaryNew(dict_id)
	if ! empty(dict:error)
		? "Error open dictionary (",dict_id,"):",dict:error
		?
		return .f.
	endif

	? "Parse xml data file:",xmlFile
	xmlData := codb_parseXMLfile(xmlFile)

	if valtype(xmlData) == "C" // error
		? xmlData
		?
		return .f.
	endif

	ret:=install_default_dictionary(dict,xmlData)

	if valtype(ret) == "C" // error
		? ret
		?
		return .f.
	endif

	ret:=""
	if empty(set("CODB_INSTALL_NODATA"))
		if "DATALOADER_MODULE" $ xmlData
			ret:=install_default_data(xmlData:dataloader_module,dict)
		else
			? "Dictionary ",dict_id, "don`t have default data loaders"
		endif
	endif

	if valtype(ret) == "C" // error
		? ret
		?
		return .f.
	endif

return .t.
/**********************************************/
static function install_default_dictionary(dict,xmlData)
	local i,j,k,n,x,tmpDict
	local nSpec,aSpec,nSpec2,aSpec2
	local oMeta,Obj,aMeta,aTypes
	local metaname,metaTag,metadata,metakey
	local bErr,tmp
	aTypes := {;
			{"COUNTER","COUNTER"},;
			{"ATTR","ATTRIBUTE"},;
			{"INDEX","INDEX"},;
			{"EXTENT","EXTENT"},;
			{"DEPOSIT","DEPOSITORY"},;
			{"CLASS","CLASS"},;
			{"TCOLUMN","TCOLUMN"},;
			{"TVIEW","TVIEW"},;
			{"REPORT","REPORT"},;
			{"PLUGINS","PLUGINS"},;
			{"ATTR","ATTRIBUTE"};
		  }
	aSpec := {;
			{"CLASS","ATTR_LIST","ATTR"},;
			{"CLASS","IDX_LIST","INDEX"},;
			{"TVIEW","COL_LIST","TCOLUMN"};
		 }
	aSpec2 := {;
			{"CLASS_ID","CLASS","void"},;
			{"SUPER_ID","CLASS",""},;
			{"REF_TO","CLASS",""},;
			{"EXTENT_ID","EXTENT","undef"},;
			{"USER_ID","USER",""},;
			{"GROUP_ID","GROUP",""};
		 }

	for i=1 to len(aTypes)  // all meta types
		metaname := aTypes[i][1]
		metaTag := aTypes[i][2]
		? "adding meta object`s",metatag,":"
		if ! (metaTag $ xmlData)
			loop
		endif

		aMeta := xmlData [metaTag]
		for j=1 to len(aMeta) // all objects for type
			oBj := aMeta[j]
			oMeta := map()
			for k=1 to len(obj) // all attributes in obj
				metakey :=alltrim(upper(obj[k][1]))
				metadata:=obj[k][2]
				if left(metadata,1) =="&"
					metadata := substr(metadata,2)
					metadata := strtran(metadata,"&\n","")
					bErr:=errorblock({|err|break(err)})
					begin sequence
						metadata := &metadata
					recover
						?? "Error in expression:"+toString(metadata)
					end sequence
					errorBlock(bErr)
				endif
				if (nSpec:=ascan(aSpec,{|x|x[1]==metaname .and. x[2]==metakey}))>0 .and. valtype(metadata)=="A"
					for n=1 to len(metadata)
						tmp=dict:select(aSpec[nSpec][3],,metadata[n])
						if !empty(tmp)
							metadata[n] := tmp[1]
						endif
					next
				endif
				if (nSpec2:=ascan(aSpec2,{|x|x[1]==metakey}))>0
					if metaName=="CLASS" .and. empty(metadata)
						metadata := aSpec2[nSpec2][3]
					endif
					x:=at(":",metadata)
					if !empty(metadata)
					    if x==0
						tmp:=dict:select(aSpec2[nSpec2][2],,metadata)
					     else
						tmp:=substr(metadata,x+1)
						x:=substr(metadata,1,x-1)
						metadata := tmp
						tmpDict := coDictionary():new(x)
						tmp:=NIL
						if empty(tmpDict:error)
							tmpDict:open()
							if empty(tmpDict:error)
								tmp:=tmpDict:select(aSpec2[nSpec2][2],,metadata)
							endif
							tmpDict:close()
						else
							outlog(__FILE__,__LINE__,metadata,tmpDict:error,aMeta)
						endif
					     endif
					else
						tmp:=NIL
					endif
					if !empty(tmp)
						metadata := tmp[1]
					else
						metadata := ""
					endif
				endif

				oMeta[metakey] := metadata
			next
			tmp:=dict:select(metaname,,oMeta:name)
			if !empty(tmp)
				if len(tmp)==1
					oMeta:id := tmp[1]
					dict:update(oMeta,metaname)
					//?? ometa:name+"(updated),"
				else
					?? 'Warning install metadata ! "'+ometa:name+ '" have duplicate objects !,'
					//quit
				endif
			else
				dict:append(ometa,metaname)
				//?? ometa:name+"(added),"
			endif

			if !empty(dict:error)
				? "Error:",dict:error,"  "
			else
				?? ometa:name+iif(empty(tmp),"(added),","(updated),")
			endif
		next
	next
return .t.

/**********************************************/
static function install_default_data(xmlData,dict)

	local tm,i,j,fname,fBlock,tmp,count:=0
	local err,ret,odep
	local modules:={},aModule,oModule
	local bErr,attrName,attrData

	for i=1 to len(xmlData)
		aModule:=xmlData[i]
		oModule:=map()
		for j=1 to len(aModule)
			attrName:=alltrim(upper(aModule[j][1]))
			attrData:=aModule[j][2]
			if left(attrData,1) == "&"
				attrData := substr(attrData,2)
				bErr:=errorblock({|err|break(err)})
				begin sequence
					attrData := &attrData
				recover
					?? "Error in expression:"+toString(attrData)
				end sequence
				errorBlock(bErr)
			endif
			oModule[attrName] := attrData
		next
		aadd(modules,oModule)
	next

	/* called modules added data from TXT files */
	tm:=seconds()
	for i=1 to len(modules)
		oModule:=modules[i]
		if !("TYPE" $ oModule)
			? "Undefine type in "+alltrim(str(i))+"loader module"
			loop
		endif

		if lower(oModule:type) == "clip_script"
			ret:=install_default_data_with_script(oModule,dict)
		else
			ret:=install_default_data_from_xmlfile(oModule,dict)
		endif
		if valtype(ret) == "N"
			count += ret
			? "Module install OK:"+oModule:script
		else
			? "Module install error:"+oModule:script+":"+toString(ret)
		endif
	next
	tm:=seconds()-tm
	? "Loaded all objects:",count,", time:",tm,"seconds"

return .t.
/**********************************************/
static function install_default_data_from_xmlfile(oModule,dict)
/**********************************************/
static function install_default_data_with_script(oModule,dict)
	local err,fname,fBlock,tmp,count:=0
	local ret,odep

	//fName:=lower(dict:id+PATH_DELIM+oModule:script)
	fName:=lower("loaders"+PATH_DELIM+oModule:script)

	if !compileFile(fName+".prg","-p", @err)
		return "Error load plugins: "+fName+".prg "+err
	endif
	fBlock := loadBlock(fName+".po")
	if valType(fBlock) != "B"
		return "Error load codeblock from: "+fName+".po"
	endif

	if "DATAFILE" $ oModule
		fName:=oModule:dataFile
	else
		return "Not defined datafile for loading data:"+oModule:script
	endif

	oDep := coDepository():new(oModule:todepository)
	if !empty(oDep:error)
		ret:=oDep:error
		return ret
	endif
	oDep:open()
	if !empty(oDep:error)
		ret:=oDep:error
		oDep:close()
		return ret
	endif

	ret:= eval(fBlock,oDep,fName)


	oDep:close()

return ret

