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

parameters pClass,p1,p2,p3,p4,p5

	if pClass == "--help"
		? "codb_load: util for loading objects fron file[s] and "
		? "           append/update it on depositories"
		?
		? "Usage: codb_load [classname]"
		?
		? "Description of method loading: data[x]/codb_load.xml"
		quit
	endif

	s+=iif(p1==NIL,"",p1)
	s+=iif(p2==NIL,"",p2)
	s+=iif(p3==NIL,"",p3)
	s+=iif(p4==NIL,"",p4)
	s+=iif(p5==NIL,"",p5)


	set exclusive on
	set translate path off
	set optimize on
	set optimize level to 2

	dList:=codbList():new()
	if val(dList:error)!=0
		? [Error open dictionary list!]+":"+dList:error
		?
		return
	endif

	codb_openLog()

	for d=1 to len(mdirs)
		mdir := mdirs[d]+PATH_DELIM+"codb_load.xml"
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

		ret:=""
		if "DATALOADER" $ xmlData
			ret:=install_default_data(xmlData:dataloader,pClass)
		else
			? mdir, "don`t have default data loaders"
		endif
		if "CODELOADER" $ xmlData
			ret:=install_default_data(xmlData:codeloader,pClass)
		else
			? mdir, "don`t have default code loaders"
		endif

		if valtype(ret) == "C" // error
			? ret
			?
			return .f.
		endif


		? "end",mdir
		?
	next
return
/**********************************************/
static function install_default_data(xmlData,pClass)

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
			if!empty(attrdata) .and.  left(attrData,1) $ "&^"
				attrData := substr(attrData,2)
				bErr:=errorblock({|err|break(err)})
				begin sequence
					attrData := &attrData
				recover
					?? "Error in expression:"+toString(attrData)+" "
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
			? "Undefine type in loader module",oModule
			loop
		endif
		if !("CLASSNAME" $ oModule)
			? "Undefine classname in loader module",oModule
			loop
		endif
		if !("DEPOSITORY" $ oModule)
			? "Undefine depository in loader module",oModule
			loop
		endif

		if !empty(pClass)
			if lower(oModule:classname) == lower(pClass)
			else
				loop
			endif
		endif

		if lower(oModule:type) == "clip_script"
			ret:=install_default_data_with_script(oModule)
		else
			ret:=install_default_data_from_xmlfile(oModule)
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
static function install_default_data_from_xmlfile(oModule)
/**********************************************/
static function install_default_data_with_script(oModule)
	local err,fname,fBlock,tmp,count:=0
	local ret,odep

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

	oDep := coDepository():new(oModule:depository)
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


