#include "ocmng.ch"

local com, oComp, tm
local isFile := .f., fName:="", nWhat := 0
local metaname, name
local error :="", errStr:="", errNum := 0
set translate path off
com := param(1)


if empty(com)
	? [ocmng is CODB component manager over XML data.]
	? [Usage: ocmng <command> <path>/<filename>]
	? [Commands:]
	? "&\t"+[install <path>/<filename> - install component to CODB .]
	? "&\t"+[compile <path>/<filename> - compile XML file with component description.]
	? "&\t"+[whereis <metaname> <name> - search in all .xml definitions <name> in <meta> .]
	? "&\t"+[report1 <path>/<filename> - report HTML about components.]
	? "&\t"+[dump    <path>/<filename> - dump compiled data from XMO file.]
	? "&\t"+[imeta   <path>/<filename> - install metadata of component to CODB .]
	? "&\t"+[idata   <path>/<filename> - install only data of component to CODB .]
	?
	quit
endif


com := alltrim(upper(com))
do case
	case com == "REPORT1" // .or. left(com,1) == "C"
		fName := param(2)
		if !empty(fName) .and. !file(fName)
			fName += ".xmo"
		endif
		isFile := .t.
	case com == "WHEREIS" // .or. left(com,1) == "C"
		metaname := param(2)
		name := param(3)
	case com == "COMPILE" // .or. left(com,1) == "C"
		fName := param(2)
		if !empty(fName) .and. !file(fName)
			fName += ".xml"
		endif
		isFile := .t.
	case com == "DUMP" // .or. left(com,1) == "C"
		fName := param(2)
		if !empty(fName) .and. !file(fName)
			fName += ".xmo"
		endif
		isFile := .t.
	case com $ "INSTALL IMETA IDATA" // .or. left(com,1) == "C"
		fName := param(2)
		if !empty(fName) .and. !file(fName)
			fName += ".xmo"
		endif
		isFile := .t.
endcase
if isFile
	if empty(fName) .or. !file(fName)
		?? [Error. Bad file name:],fname
		?
		errorlevel(1)
		quit
	endif
endif
do case
	case left(com,6) == "REPORT" // .or. left(com,1) == "C"
		error := ocMngReport(val(substr(com,7,1)),fName,param(3),param(4))
		if !empty(error)
			errNum := 15
		endif
	case com == "WHEREIS" // .or. left(com,1) == "C"
		error := ocMngWhereis(metaName,Name)
		if !empty(error)
			errNum := 14
		endif
	case com == "COMPILE" // .or. left(com,1) == "C"
		tm := seconds()
		oComp := ocMngCompile(fname)
		if !empty(oComp:error)
			error := oComp:error
			if empty(ferror())
				errNum := 11
			else
				errNum := 3
			endif
		else
			fName := strtran(fName,".xml",".xmo")
			?? [Compile successfull]+", "+[time run:]+alltrim(str(seconds()-tm))+" "+[seconds]+", "+[saved to:], fName
			?
		endif
	case com == "DUMP" // .or. left(com,1) == "C"
		error := ocmngDump(fName,0)
		if !empty(error)
			if !empty(fError())
				errNum := 2
			else
				errNum := 12
			endif
		endif
	case com $ "INSTALL IMETA IDATA" // .or. left(com,1) == "C"
		nWhat := 0
		if com == "IMETA"
			nWhat := 1
		endif
		if com == "IDATA"
			nWhat := 2
		endif
		error := ocmngInstall(fName,nWhat,1)
		?
		if !empty(error)
			if !empty(fError())
				errNum := 2
			else
				errNum := 13
			endif
		endif
	otherwise
		errNum := 20
end

errStr := ""
do case
	case errNum == 1
		errStr := [File not found:]+error
	case errNum == 2
		errStr := [Error reading file:]+error
	case errNum == 3
		errStr := [Error writing file:]+error
	case errNum == 11
		errStr := [Error compiling file:]+error
	case errNum == 12
		errStr := [Error dumping file:]+error
	case errNum == 13
		errStr := [Error installing file:]+error
	case errNum == 14
		errStr := [Error serching metadata:]+error
	case errNum == 15
		errStr := [Error reporting:]+error
	case errNum == 20
		errStr := [Command not supported:]+toString(com)
endcase
?? errStr
?
errorLevel(errNum)
return

