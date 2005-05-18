/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/* install procedure all CODB dictionaries and default data objects */
//#include "codbcfg.ch"

local dList,ret,ret2
local xmlData,i,j,d,s:=""
local fName,fBlock,err
local fList,mdir,mdirs:={"data","data1","data2","data3","data4","data5","data6"}

parameters p1,p2,p3,p4,p5
	if p1 == "--help"
		? "codb_make: util for loading meta data fron file[s] and "
		? "           append/update it on dictionaries"
		?
		? "Usage: codb_make"
		?
		? "Description of meta data will load from data[x]/codb_list.xml"
		quit
	endif

	s+=iif(p1==NIL,"",p1)
	s+=iif(p2==NIL,"",p2)
	s+=iif(p3==NIL,"",p3)
	s+=iif(p4==NIL,"",p4)
	s+=iif(p5==NIL,"",p5)


	if "--nodata" $ lower(s)
		set("CODB_INSTALL_NODATA","yes")
	endif

	set exclusive on
	set translate path off
	set optimize on
	set optimize level to 2
    set deleted off

	dList:=codbList():new()
	if val(dList:error)!=0
		? [Error open dictionary list!]+":"+dList:error
		?
		return
	endif

	codb_openLog()

	for d=1 to len(mdirs)
		mdir := mdirs[d]+PATH_DELIM+"codb_list.xml"
		if !file(mdir)
			loop
		endif
		? "begin",mdir
		xmlData := codb_parseXMLfile(mdir)

		if valtype(xmlData) == "C" // error
			? xmlData
			?
			return .f.
		endif

		if !("DICTIONARY" $ xmlData)
			? "Error: invalid data in codb_list.xml or dictionary list is empty !"
			?
			return .f.
		endif

		ret:=install_default_dictionary_list(dList,xmlData:dictionary,mdir)

		if valtype(ret) == "C" // error
			? ret
			?
			return .f.
		endif

		if "INSTALL" $ xmlData
			ret2:=parse_install_extensions(xmlData:install,mdir)
		endif

		if valtype(ret2) == "C" // error
			? ret2
			?
			return .f.
		endif

		if valtype(ret2) == "A" // error
			for i=1 to len(ret2)
				aadd(ret,ret2[i])
			next
		endif

		if valtype(ret) == "C" // error
			? ret
			?
			return .f.
		endif

		if isFunction("CODB_INSTALL")
			fblock:={|p1,p2,p3,p4|codb_install(p1,p2,p3,p4)}
		else
			fName:=lower("codb_install")
			if !compileFile(fName+".prg","-p", @err)
				? "Error load plugins:",fName+".prg",err
				?
				return
			endif
			fBlock := loadBlock(fName+".po")
			if valType(fBlock) != "B"
				? "Error load codeblock from:",fName+".po"
				?
				return
			endif
		endif
		for i=1 to len(ret)
			/* load and install metadata for dictionaries */
			eval(fBlock,ret[i],mdirs[d]+PATH_DELIM+ret[i]+".xml",mdirs[d])
			? "Added default metadata from:",ret[i],"OK"
			fList:=directory(mdirs[d]+PATH_DELIM+ret[i]+"_*.xml")
			asort(flist,,,{|x,y|x[1]<y[1]})
			for j=1 to len(fList)
				eval(fBlock,ret[i],mdirs[d]+PATH_DELIM+fList[j][1],mDirs[d])
				? "Added default metadata from:",fList[j][1],"OK"
				? "******************"
			next
			?
		next
		? "end",mdir
		?
	next
	? "end"
	?
return

/****************************************************/
static function install_default_dictionary_list(dList,xmlData,mdir)
	local i,j,k,bErr,ret,arr:={}
	local dict,dictDesc
	local attrname,attrData
	? "Install dictionaries:"
	for i=1 to len(xmlData)
		dict:=xmlData[i]
		dictDesc:=map()
		for j=1 to len(dict)
			attrName:=alltrim(upper(dict[j][1]))
			attrData:=dict[j][2]
			if left(attrData,1) == "&"
				attrData := substr(attrData,2)
				bErr:=errorblock({|err|break(err)})
				attrData := strtran(attrData,"&\n","")
				begin sequence
					attrData := &attrData
				recover
					?? "Error1 in expression:"+toString(attrData)
				end sequence
				errorBlock(bErr)
			endif
			dictDesc[attrName] := attrData
		next
		dictDesc:id := upper(dictDesc:id)
		if !("ID" $ dictDesc) .or. empty(dictDesc:id)
			ret:="Error: empty dictionary identification in description"
			exit
		endif
		?? dictDesc:id," to ", dictDesc:path
		if dList:existId(dictDesc:id)
			dList:update(dictDesc)
			?? "(updated),"
		else
			dList:append(dictDesc)
			?? "(added),"
		end
		if !empty(dList:error)
			ret:=dList:error
			exit
		endif
		aadd(arr,dictDesc:id)
	next
	if empty(ret)
		return arr
	endif
return  ret

************************************************************
static function parse_install_extensions(xmlData,mdir)
	local i,j,k,bErr,ret,arr:={}
	local dict,dictDesc
	local attrname,attrData
	for i=1 to len(xmlData)
		dict:=xmlData[i]
		dictDesc:=map()
		for j=1 to len(dict)
			attrName:=alltrim(upper(dict[j][1]))
			attrData:=dict[j][2]
			if left(attrData,1) == "&"
				attrData := substr(attrData,2)
				bErr:=errorblock({|err|break(err)})
				attrData := strtran(attrData,"&\r","")
				attrData := strtran(attrData,"&\n","")
				begin sequence
					attrData := &attrData
				recover
					?? "Error2 in expression:"+toString(attrData)
				end sequence
				errorBlock(bErr)
			endif
			dictDesc[attrName] := attrData
		next
		if !("ID" $ dictDesc) .or. empty(dictDesc:id)
			ret:="Error: empty dictionary identification in description"
			exit
		endif
		dictDesc:id := upper(dictDesc:id)
		aadd(arr,dictDesc:id)
	next
	if empty(ret)
		return arr
	endif
return  ret
************************************************************


