/*
     TCP server - class for create Listen servers

     Copyright (C) 2004  ITK
     Author  : Uri (uri@itk.ru)
     Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/

#include "http.ch"
#include "tcp.ch"

function tcpServerNew(cName,nPort,type,oIni)
	local tmp,obj := map()
	obj:className	:= "TCPSERVER"
	obj:error	:= ""
	obj:errno	:= 0
	obj:nPort	:= nPort
	obj:listen	:= -1

	if !empty(cName)
		obj:name	:= upper(cName)
	else
		obj:name	:= "TCPUNDEF"
	endif
	if !empty(type)
		obj:type	:= upper(type)
	else
		obj:type	:= "TCP"
	endif

	* timeOut for listen()
	obj:lTimeOut	:= TCP_LISTEN_TIMEOUT
	* timeOut for accept()
	obj:aTimeOut	:= TCP_ACCEPT_TIMEOUT

	if valtype(oIni)=="O" .and. oIni:className == "INIFILE"
		tmp := oIni:getValue(obj:type,"PORT")
		if valtype(tmp) == "N"
			obj:nPort := tmp
		endif
		tmp := oIni:getValue(obj:type,"LISTENTIMEOUT")
		if valtype(tmp) == "N"
			obj:lTimeOut := tmp
		endif
		tmp := oIni:getValue(obj:type,"ACCEPTTIMEOUT")
		if valtype(tmp) == "N"
			obj:aTimeOut := tmp
		endif
	endif
	obj:listen	:=@ tcp_listen()
	obj:close	:=@ tcp_close()
	obj:accept	:=@ tcp_accept()
return obj

***********************************************
static function tcp_listen()
	::error := ""
	::errno := ""
	if valtype(::nPort) == "N" .and. ::nPort > 0
		::listen:= tcpListen( ::nPort, ::lTimeOut )
	endif
	if ( ::listen ) < 0
		::error:=[Error listen on port ]+toString(::nPort)+" "+ferrorStr()
		return .f.
	endif
return .t.
***********************************************
static function tcp_close()
	if ::listen > 0
		tcpClose( ::listen )
		::listen := -1
		return .t.
	endif
return .f.
***********************************************
static function tcp_accept()
	local ret := -1
	ret := tcpAccept( ::listen, ::aTimeOut )
return ret

/*************************************/
function tcpServerLoadIni(iniFile,defIniFile)
	local oIni, s
	if empty(defIniFile)
		defIniFile := "clip-tcp.ini"
	endif
	if !empty(iniFile) .and. file(iniFile)
		oIni := iniFileNew(iniFile)
	endif
	if empty(oIni) .and. !empty(iniFile)
		? "Error: inifile not found:",iniFile
		? "Usage: "+startPath()+" <inifile_name>"
		?
		quit
	endif
	if empty(oIni)
		iniFile := cliproot()+PATH_DELIM+"etc"+PATH_DELIM+defIniFile
		if file(iniFile)
			oIni := iniFileNew(iniFile)
		endif

	endif
	if empty(oIni)
		iniFile := defIniFile
		if file(iniFile)
			oIni := iniFileNew(iniFile)
		endif

	endif
	if empty(oIni)
		oIni := iniFileNew()
		return oIni
	endif
	oIni:load()
	if !empty(oIni:error)
		s := [Error loading ini file:]+toString(iniFile)+":"+oIni:error
		? s
		outlog(s)
	endif
return  oIni

/*********************************/
function tcpServerLoadIniModules(oIni,type)
	local i,j,tmp,dir,file,bl,mFuncs := {}
	if valtype(oIni)=="O" .and. oIni:className == "INIFILE"
	else
		return
	endif
	if empty(type)
		type := "TCP"
	endif
	tmp := oIni:getValue(type,"MOD-INI")
	if empty(tmp)
		return
	endif
	tmp := strtran(tmp,"$CLIPROOT",cliproot())
	dir:=directory(tmp+PATH_DELIM+"*.po")
	? "Found "+alltrim(str(len(dir)))+" modules for HTTP in directory:"+tmp
	for i=1 to len(dir)
		load(tmp+PATH_DELIM+dir[i][1],mFuncs)
		for j=1 to len(mFuncs)
			? "Run init module:"+mFuncs[j]+":"
			clip(mFuncs[j],oIni)
		next
		mFuncs := {}
	next
return

