/*
    Copyright (C) 2005-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
********************************
#include "ocmng.ch"
*****************************************
function ocmngDump(fName,nLevel)
	local i,j,m,k,x,s
	local oComp
	local error := ""

	__ocmng_init_simbols()
	s := memoRead(fName)
	if fError() != 0
		return fErrorStr()
	endif

	oComp := str2var(s)
return	__ocmng_dump(oComp,0)
*****************************************
static function __ocmng_Dump(oComp,nLevel)
	local i,j,m,k,x,s

	s := replicate("&\t",nLevel)
	m:=mapkeys(oComp)
	for i=1 to len(m)
		x := oComp[m[i]]
		if valtype(x) $ "C,N,D,L"
		else
			loop
		endif
		? s+hashname(m[i])+":", x
	next
	for i=1 to len(m)
		x := oComp[m[i]]
		if valtype(x) $ "A"
		else
			loop
		endif
		for j =1 to len(x)
			if valtype(x[j]) == "O"
				? s+hashname(m[i])+"["+alltrim(str(j))+"]:"+"{"
				__ocmng_Dump(x[j],nLevel+1)
				? s+"}"
			else
				? s+hashname(m[i])+"["+alltrim(str(j))+"]:", x[j]
			endif
		next
	next
return ""

#include "funcs_s.prg"

