/*
    Copyright (C) 2004  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "codbcfg.ch"

static connections:=map()
static counters:=map()

************************************************************
function codb_SqlConnect(oData)
	local ret,s1,s2
	s1 := oData:dType+oData:Host+toString(oData:port)+oData:user+;
		oData:passwd+oData:dbname
	if s1 $ connections
		counters[s1] ++
		return connections[s1]
	else
		counters[s1] := 0
	endif
	s2 := cliproot()+PATH_DELIM+"lib"+PATH_DELIM+"libclip-mysql"
	ret := loadLib(s2)
	ret := ConnectNew(oData:dType,oData:Host,oData:port,oData:user,oData:passwd,oData:dbname)
	//	[<cSocket>],[<cFlags>],[<cCharset>],[<cIsolation>])
	connections[s1] := ret
	counters[s1] ++
return  ret


function codb_SqlClose(oData)
	local ret,s1
	s1 := oData:dType+oData:Host+oData:port+oData:user+;
		oData:passwd+oData:dbname
	if s1 $ connections
		ret := connections[s1]
	else
		return .t.
	endif
	counters[s1] --
	if counters[s1] == 0
		ret:destroy()
		adel(counters,s1)
		adel(connections,s1)
	endif
return .t.

