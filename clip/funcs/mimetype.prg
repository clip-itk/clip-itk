/*
    Copyright (C) 2004  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "clipcfg.h"
#include "fileio.ch"

static types

*************************************************
function mimeTypesLoad(fName)
	local fh,buf, i,j,k

	types := map()

	if empty(fName)
		fname := "/etc/mime.types"
	endif

	fh:=fopen(fName,FO_READ)
	if fh<0
		return .f.
	endif
	while !fileeof(fh)
		buf:=filegetstr(fh)
		buf:=alltrim(buf)
		if left(buf,1)=="#" .or. empty(buf)
			loop
		endif
		buf := strtran(buf,"&\t"," ")
		i := at(" ",buf)
		if i<=0
			loop
		endif
		k := left(buf,i-1)
		buf := alltrim(substr(buf,i+1))
		while !empty(buf)
			i:=at(" ",buf)
			if i<=0
				i := len(buf)+1
			endif
			j := upper(left(buf,i-1))
			if empty(j)
				loop
			endif
			types[j] := k
			buf := alltrim(substr(buf,i+1))
		enddo
	enddo
	fclose(fh)
return .t.
*************************************************
function mimeTypeGet(sType)
	if valtype(sType) !="C"
		return ""
	endif
	if empty(types)
		mimeTypesLoad()
	endif
	sType := upper(sType)
	if sType $ types
		return types[sType]
	endif
return ""
*************************************************
function mimeTypeSet(sType,sData)
	if valtype(sType) !="C"
		return .f.
	endif
	if valtype(sData) !="C"
		return .f.
	endif
	sType := upper(sType)
	if empty(types)
		mimeTypesLoad()
	endif
	types[sType] := sData
return .t.
