/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html

    class INIFILE
    control for Windows-like .ini files

   :) написано на следующий после пашкиного дня рождения, надо бы
   этот текст пометить красным цветом :)
*/

#include "fileio.ch"

#define DOS_CRLF "&\r&\n"

***************************************
function iniFile()
	local obj:=map()
	obj:new		:=@ __IF_new()
return obj

***************************************
function iniFileNew(sFile)
return  __IF_New(map(),sFile)

***************************************
static function __IF_new(self,sFile)
	self:className	:="INIFILE"
	self:file	:= sFile
	self:data	:=map()
	self:__names	:=map()
	self:error	:=""
	_recover_inifile(self)
return self

***************************************
function _recover_iniFile(obj)
	obj:load	:=@ __IF_load()
	obj:save	:=@ __IF_save()
	obj:getValue	:=@ __IF_getValue()
	obj:setValue	:=@ __IF_setValue()
	obj:sections	:=@ __IF_sections()
	obj:keys	:=@ __IF_keys()
return obj

***************************************
static function __IF_sections()
	local i,ret:={},k:=mapKeys(::data)
	for i=1 to len(k)
		aadd(ret, ::__names[k[i]])
	next
return ret

***************************************
static function __IF_keys(sPart)
	local i,ret:={},s1:=__check_name(sPart)
	if s1 $ ::data
		ret:=mapkeys(::data[s1])
		for i=1 to len(ret)
			ret[i] := ::__names[ret[i]]
		next
	endif
return ret

***************************************
static function __IF_getValue(sPart,sKey)
	local s1,s2
	s1 := __check_Name(sPart)
	s2 := __check_Name(sKey+"_"+host_charset())
	if s1 $ ::data .and. s2 $ ::data[s1]
		return ::data[s1][s2]
	endif
	s2 := __check_Name(sKey)
	if s1 $ ::data .and. s2 $ ::data[s1]
		return ::data[s1][s2]
	endif
return NIL
***************************************
static function __IF_setValue(sPart,sKey,xData)
	local s1,s2
	s1 := __check_Name(sPart)
	s2 := __check_Name(sKey)
	::__names[s1] := s1
	::__names[s2]  := s2
	if ! (s1 $ ::data)
		::data[s1] := map()
	endif
	::data[s1][s2] := xData
return xData
***************************************
static function __IF_save(sFile)
	local nPart,nKey, fh
	local tmp1:={},i
	local tmp2:={},j
	::error:=""
	if sFile==NIL
		fh:=fcreate(::file)
	else
		fh:=fcreate(sFile)
	endif
	if fh<0
		::error := ::file+[: create error:]+ferrorstr()
		return .f.
	endif
	for nPart in ::data KEYS
		aadd(tmp1,::__names[nPart])
	next
	asort(tmp1)
	for i=1 to len(tmp1)
		fwrite(fh,DOS_CRLF)
		fwrite(fh,"["+tmp1[i]+"]"+DOS_CRLF)
		***
		tmp2:={}
		for nKey in ::data[tmp1[i]] KEYS
			aadd(tmp2,::__names[nKey])
		next
		asort(tmp2)
		for j=1 to len(tmp2)
			fwrite(fh,"&\t"+tmp2[j]+"&\t= ")
			fwrite(fh, __xDataToString(::data[tmp1[i]][tmp2[j]]) )
			fwrite(fh,DOS_CRLF)
		next
	next
	/*
	for nPart in ::data KEYS
		fwrite(fh,DOS_CRLF)
		fwrite(fh,"["+::__names[nPart]+"]"+DOS_CRLF)
		***
		for nKey in ::data[nPart] KEYS
			fwrite(fh,"&\t"+::__names[nKey]+"&\t= ")
			fwrite(fh, __xDataToString(::data[nPart][nKey]) )
			fwrite(fh,DOS_CRLF)
		next
	next
	*/
	fwrite(fh,DOS_CRLF)
	fclose(fh)
return .t.
***************************************
static function __IF_load()
	local fh, buf, ch, i, sKey,sVal, sPart:="", oPart
	::error:=""
	if ::file == NIL
		::error := [Bad file name: name is not specified]
		return .f.
	endif
	if ".ini" $ ::file
	else
		::file += ".ini"
	endif
	fh:=fopen(::file,FO_READ)
	if fh<0
		::error := ::file+[: open error:]+ferrorstr()
		return .f.
	endif
	while !fileeof(fh)
	       buf:=filegetstr(fh)
	       buf:=alltrim(buf)
	       ch:=left(buf,1)
	       i := at(";",buf)
	       if i>0
			buf:=substr(buf,1,i-1)
	       endif
	       if empty(buf) .or. ch=="#"
			loop
	       endif
	       if ch=="[" //begin new part
			if right(buf,1)=="]"
				sPart:=substr(buf,2,len(buf)-2)
			else
				sPart:=substr(buf,2,len(buf)-1)
			endif
			sPart := __check_name(sPart)
			::__names[sPart]:=sPart
			::data[sPart] := map()
			oPart := ::data[sPart]
			loop
	       endif
	       i := at("=",buf)
	       if i<=0
			::error+=[Bad string in .ini file:]+buf+";"
			loop
	       endif
	       sKey:=substr(buf,1,i-1)
	       skey:=__check_name(sKey)
	       sVal:=substr(buf,i+1)
	       ::__names[sKey] := sKey
	       oPart[sKey]:=__stringToData(sVal)
	enddo
	fclose(fh)
return .t.

***************************************
static function __check_name(sName)
	local ret:=alltrim(sName)
	ret:=strtran(ret,".","_")
	ret:=strtran(ret," ","_")
	ret:=strtran(ret,"-","_")
return alltrim(upper(ret))
***************************************
static function __stringToData(str)
	local ret:=NIL, err, bErr:=errorblock({|x|break(x)})

	str:=alltrim(str)

	begin sequence
		ret:=&("{"+str+"}")
	recover using err
	end sequence
	// str -> 1,2,3,4,5
	if valType(ret)=="A" .and. len(ret) > 1
		errorBlock(bErr)
		return ret
	endif
	begin sequence
		ret:=&str
	recover using err
	end sequence
	// str -> "string_value"
	if valType(ret) $ "CNDL"
		errorBlock(bErr)
		return ret
	endif
	// str -> "{|| block_expr}"
	if valType(ret) $ "B"
		errorBlock(bErr)
		return str
	endif
	// str -> {yyyy.mm.dd}
	if left(str,1)=="{" .and. right(str,1)=="}"
		errorBlock(bErr)
		ret:=ctod(substr(str,2,len(str)-2),"yyyy.mm.dd")
		return ret
	endif
	// str -> a1,a2,a3,a4
	if ("," $ str) .and. !('"' $ str) .and. !("'" $ str)
		errorBlock(bErr)
		return split(str,",")
	endif
	errorBlock(bErr)
return alltrim(str)
***************************************
static function __xDataToString(xData)
	local ret:="",i
	switch valtype(xData)
		case "L"
			ret:=iif(xData,".t.",".f.")
		case "C"
			ret:=xData
		case "D"
			ret:="{"+dtoc(xData,"yyyy.mm.dd")+"}"
		case "N"
			ret:=alltrim(str(xData))
		case "A"
			for i=1 to len(xData)
				ret+=alltrim(toString(xData[i]))+","
			next
			ret:=substr(ret,1,len(ret)-1)
		case "U"
	end
return ret
