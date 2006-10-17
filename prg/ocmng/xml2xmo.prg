#include "ocmng.ch"

local oComp, tm := seconds(), str, s
local i,error := 0, dirName

local aDir:={}, aFiles := {}

set translate path off
dirName := param(1)

if empty(dirName)
	? [xml2xmo is recursively compiler for XML with component data.]
	? [Usage: xml2xmo <dirname>]
	?
	quit
endif

aadd(aDir,dirName)
if error==0 .and. !ocMng_make_aDir(dirName,aDir)
	error := 3
endif
if error==0 .and. !ocMng_make_aFiles(dirName,aDir,aFiles,"xml")
	error := 4
endif

/*
if error==0
	? [Found files:]+alltrim(str(len(aFiles)))
	for i=1 to len(aFiles)
		? aFiles[i]
	next
	?
endif
*/
if error==0
	? [Compiling files .....]
	error := __compile_files(aFiles)
endif

if error==0
	str := [Compiled XXXXXX files at YYYYYY seconds]
	s := strzero(seconds()-tm)
	str := strtran(str,"YYYYYY",s)
	s := strzero(len(aFiles))
	str := strtran(str,"XXXXXX",s)
	? str
endif

errorlevel(error)

?
return
**********************************************************
static function __compile_files(aFiles)
	local i, fName, tm
	local oComp, error:=0

	for i=1 to len(aFiles)
		fName := aFiles[i]

		tm := seconds()
		? "Compiling file:",fName
		oComp := ocMngCompile(fName)
		fName := strtran(fName,".xml",".xmo")
		if empty(oComp:error)
			? [Saved to:], fName
			? [Compile successfull]+", "+[time run:]+alltrim(str(seconds()-tm))+" "+[seconds]
			loop
		endif
		if empty(ferror())
			? [Compile error:], oComp:error
			error := 1
		else
			? [Error writing file:], fErrorStr()
			error := 2
		endif
		if error > 0
			exit
		endif
	next
return error
