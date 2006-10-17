/*
    Copyright (C) 2005-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
********************************
#include "ocmng.ch"
*****************************************
function ocMngWhereIS(metaName,name)
	local aDir:={}, aFiles := {}
	local error := ""

	__ocmng_init_simbols()

	if empty(metaName)
		return [Bad metaname]
	else
		metaname := upper(metaname)
	endif
	if empty(Name)
		return [Bad meta name]
	else
		name := upper(name)
	endif

	****
	error := ocMng_rFiles("",aDir,aFiles,"xmo")
	if empty(error)
		error := __whereis(aFiles,metaName,name)
	endif
return	error

******************************************
static function __whereis(aFiles,metaName,name)
	local i,s,cFile,oComp
	local nLevel := 1, error:=""

	for i=1 to len(aFiles)

		cFile := aFiles[i]
		s := memoRead(cFile)
		if fError() != 0
			error := fErrorStr()
			ocmngMessage(error,nLevel)
			exit
		endif
		oComp := str2var(s)
		oComp:__filename__ := makePath(cFile)
		error := __whereis2(oComp,metaName,name,nLevel)
		if !empty(error)
			exit
		endif
	next
return error
******************************************
static function __whereis2(oComp,metaName,name,nLevel)
	local i,error:="",oMeta

	set("COMPONENT_FILENAME",oComp:__filename__)
	if "META" $ oComp
		for i=1 to len(oComp:meta)
			oMeta := oComp:meta[i]
			if valtype(oMeta) == "O"
			else
				error := [Bad data of META]
				ocmngMessage(error,nLevel)
				exit
			endif
			if empty(oMeta:dictionary)
				error := [Bad dictionary name of META]
				ocmngMessage(error,nLevel)
				exit
			endif
			error := __whereis3(oMeta,metaName,name,nLevel)
			if !empty(error)
				exit
			endif
		next
	endif
return error
******************************************
static function __whereis3(oMeta,metaName,Name,nLevel)
	local i,j,m,key,val,x
	local error := ""
	m:=mapkeys(oMeta)
	for i=1 to len(m)
		key := hashname(m[i])
		val := oMeta[m[i]]
		if valtype(val) == "A"
		else
			loop
		endif
		//? "a1",metaname,metaname $ key,oMeta:dictionary,key,valtype(val)
		if metaname $ key
		else
			loop
		endif
		for j=1 to len(val)
			x := val[j]
			//? "a2",x:name
			if "NAME" $ x
			else
				loop
			endif
			if name $ upper(x:name)
				? oMeta:dictionary+":"+key+":"+x:name,"->",set("COMPONENT_FILENAME")
			endif
		next
	next
return error

#include "funcs_s.prg"

