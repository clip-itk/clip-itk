/*
    Copyright (C) 2005-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
********************************************************
function ocMng_rFiles(DirName,aDir,aFiles,cExt)
	local error := ""

	if empty(dirName) .and. !empty(getenv("OCMNG_ROOT"))
		dirName := getenv("OCMNG_ROOT")
	endif
	if empty(dirName)
		dirName := "./"
	endif

	aadd(aDir,dirName)
	if empty(error) .and. !ocMng_make_aDir(dirName,aDir)
		error := [Bad reading directory]
	endif
	if empty(error) .and. !ocMng_make_aFiles(dirName,aDir,aFiles,cExt)
		error := [Error reading file]
	endif
return error
********************************************************
function ocMng_make_aDir(sDir,aDir)
	local mDir,dir,i,x,y

	mdir := directory(sDir+PATH_DELIM+"*","D")
	asort(mdir,,,{|x,y|x[1]<y[1]})
	for i=1 to len(mdir)
		dir := mDir[i]
		if dir[5] == "D"
		else
			loop
		endif
		if dir[1] == "."
			loop
		endif
		if dir[1] == ".."
			loop
		endif
		aadd(aDir,sDir+PATH_DELIM+dir[1])
		ocMng_make_aDir(sDir+PATH_DELIM+dir[1],aDir)
	next
return .t.

******************************************************************
function ocmng_make_aFiles(sDir,aDir,aFiles,cExt)
	local i,j,f,f1,f2,dir,mFiles
	local ret := .t., str, fName, fName2

	if empty(cExt)
		cExt := "xml"
	endif

	for i=1 to len(aDir)
		//? i, aDir[i]
		dir := aDir[i]+PATH_DELIM
		mFiles := directory(dir+"*."+cExt)
		for j=1 to len(mFiles)
			fName := dir+mFiles[j][1]
			if cExt == "xml"
			else
				aadd(aFiles,fName)
			endif
			//? j, fName //mfiles[j]
			str := memoread(fName)
			if fError() > 0
				? [Error reading]+" '"+fName+"':",fErrorStr()
				ret := .f.
			endif
			//? j,fName,fError(),len(str)
			if "<component>" $ str
			else
				loop
			endif
			fName2 := strtran(fName,".xml",".xmo")
			f := directory(fName2)
			if len(f) <= 0
				aadd(aFiles,fName)
				loop
			endif
			f1 := mFiles[j]
			f2 := f[1]
			//? fName,f1
			//? fName2,f2
			//outlog(__FILE__,__LINE__,"a1", f1)
			//outlog(__FILE__,__LINE__,"a2", f2)
			if f1[3] > f2[3] .or. ;
			   (f1[3] == f2[3] .and. f1[4] > f2[4] )
				aadd(aFiles,fName)
			endif
		next
	next

return ret

