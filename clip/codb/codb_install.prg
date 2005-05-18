/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* install META data for global dictionary */

function codb_install(dict_id,xmlFile,mdir)
	local modules,dict,xmlData:={}
	local i,ret
	if empty(dict_id) .or. empty(xmlFile) .or. empty(mdir)
		? "usage: codb_install <dictionary_id> <xmlFile_with_data> <source_dir>"
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

	ret:=install_default_dictionary(dict,xmlData,mdir)

	if valtype(ret) == "C" // error
		? ret
		?
		return .f.
	endif

return .t.
/**********************************************/
static function install_default_dictionary(dict,xmlData,mdir)
	local i,j,k,n,x,tmpDict
	local fname,source
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
				if !empty(metadata) .and. left(metadata,1) $ "&^"
					metadata := substr(metadata,2)
					metadata := strtran(metadata,"&\n","")
					bErr:=errorblock({|err|break(err)})
					begin sequence
						metadata := &metadata
					recover
						?? "Error in expression:"+toString(metadata)+" "
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
						//metadata := ""
					endif
				endif

				oMeta[metakey] := metadata
			next
			if metaname == "PLUGINS"
				fname := mdir+PATH_DELIM+"plugins"+PATH_DELIM+oMeta:filename
				oMeta:source := memoread(fname)
				if empty(oMeta:source)
					? "Error:","Can`t load plugins file:",fname,ferrorstr()
				endif
			endif
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

