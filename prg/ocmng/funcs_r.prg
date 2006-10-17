/*
    Copyright (C) 2005-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
********************************
#include "ocmng.ch"
*****************************************
function ocMngReport(nReport,fName,p2,p3)
	local aDir:={}, aFiles := {}
	local s, nLevel := 1, oComp
	local error := ""

	__ocmng_init_simbols()
	/*
	s := memoRead(fName)
	if fError() != 0
		return fErrorStr()
	endif

	oComp := str2var(s)
	if valtype(oComp) == "O"
	else
		return [Bad file content]
	endif
	*/

	error := ocMng_rFiles("",aDir,aFiles,"xmo")
	if !empty(error)
		return error
	endif

	do case
		case nReport ==1
			error := __report1(aFiles,nLevel)
		//case nReport ==2
			//error := __report1(aFiles,nLevel)
		otherwise
			error := [Bad report number]
	endcase

return error

******************************************
static function __report1(aFiles,nLevel)
	local i,s,cFile,oComp
	local data:={}
	local error:=""

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
		error := __report1_2(oComp,data,nLevel)
		if !empty(error)
			exit
		endif
	next
	error := __report1_3(data,nLevel)
	if !empty(error)
		return error
	endif
	error := __report1_4(data,nLevel)
	if !empty(error)
		return error
	endif
return error
******************************************
static function __report1_4(data,nLevel)
	local error := ""
	local i,j,x,y
	local aPolicy:= {}

	asort(data,,,{|x,y| x[3]<y[3]})

	for i=1 to len(data)
		j := ascan(aPolicy,{|x| x== data[i][5]})
		if j<=0
			aadd(aPolicy,data[i][5])
		endif
	next
	asort(aPolicy,,,{|x,y| x>y})
	for i=1 to len(aPolicy)
		if "xx" $ aPolicy[i]
			loop
		endif
		error := __report1_5(data,aPolicy[i],nLevel)
		if !empty(error)
			exit
		endif
	next
return error
******************************************
static function __report1_5(data,policy,nLevel)
	local i,s,error := ""
	? '<font color="blue" size="+2"><center> Policy = '+policy+'</center></font>'
	? '<table border="1" size="100%">'
	? [<th> Description </th><th> Category </th><th> Name </th><th> File </th><tr>]
	for i=1 to len(data)
		if data[i][5] == policy
		else
			loop
		endif
		s := data[i][4]
		if empty(s)
			s := '&nbsp'
		endif
		? '<td>'+s+'</td>'
		?? '<td>'+data[i][3]+'</td>'
		?? '<td>'+data[i][2]+'</td>'
		?? '<td>'+data[i][1]+'</td>'
		?? '<tr>'
	next
	? '</table>'
	?
return error
******************************************
/* delete left path names */
static function __report1_3(data,nLevel)
	local error := ""
	local i,j,x:=99999,fName,pName
	local lOk := .f.
	if empty(data)
		return error
	endif
	pName := data[1][1]
	pName := strtran(pName,"\","/")
	do while .t.
		x := atr("/",pName)
		pName := substr(pName,1,x)
		if empty(pName)
			exit
		endif
		for i=1 to Len(data)
			if left(data[i][1],x) == pName
				loop
			else
				//? "a1",x,pName,left(data[i][1],x),data[i][1]
				exit
			endif
		next
		//? "a2",x,pName
		if i == len(data)+1
			lOK := .t.
			exit
		endif
		pName := substr(pName,1,len(pName)-1)
	enddo
	//? lOk,pName,x
	if lOk
		for i=1 to Len(data)
			data[i][1] := substr(data[i][1],x+1)
			data[i][1] := strtran(data[i][1],".xmo",".xml")
		next
	endif
return error

******************************************
static function __report1_2(oComp,data,nLevel)
	local i,p,error:=""
	local aProp := {}
	local name := "",cat :="", desc:="", policy:=""

	set("COMPONENT_FILENAME",oComp:__filename__)
	if "NAME" $ oComp
		name := oComp:name
	endif
	if empty(name)
		return ""
	endif
	if "CATEGORY" $ oComp
		cat := oComp:category
	endif
	if "DESCRIPTION" $ oComp
		desc := oComp:description
	endif
	if "PROPERTY" $ oComp .and. valtype(oComp:property) == "A"
		for i=1 to len(oComp:property)
			p := oComp:property[i]
			if "NAME" $ p .and. lower(p:name) == "policy"
				aadd(aProp,p:cdata)
			endif

		next
	endif
	if empty(aProp)
		aadd(aProp,"")
	endif

	for i=1 to len(aProp)
		aadd(data,{oComp:__filename__,name,cat,desc,aProp[i]})
	next

return error

#include "funcs_s.prg"

