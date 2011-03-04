/*
	COBrA is CLIP Object Broker & Application Server.
	cobraService - class for connection and dialog client <-> server
*/
/*   Copyright (C) 2003  ITK
     Author  : Uri (uri@itk.ru)
     Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/

#include "set.ch"
#include "cobra.ch"
#include "tcp.ch"

function cobraServiceNew(oIni)
	local tmp,obj:=map()
	obj:classname	:= "COBRASERVICE"
	obj:cHost	:= COBRA_DEFHOST
	obj:nPort	:= COBRA_DEFPORT
	obj:nTimeOut	:= TCP_ACCEPT_TIMEOUT
	obj:nIOtimeOut	:= TCP_IO_TIMEOUT
	obj:nVersion	:= COBRA_VERSION
	obj:nConnect	:= -1
	obj:cLine	:= ""
	obj:buffer	:= ""
	obj:error	:= ""
	obj:warning	:= ""
	obj:errno	:= 0
	obj:nSended	:= 0
	obj:nReceived	:= 0
	obj:rootPath    := "./"

	obj:__queries	:= map()

	/* install values from ini-file */
	if valtype(oIni)=="O" .and. oIni:className == "INIFILE"

		tmp = oIni:getValue("COBRA","ROOTPATH")
		if !empty(tmp)
			tmp := strtran(tmp,"$CLIPROOT",cliproot())
		endif
		obj:rootPath := tmp
	endif

	obj:info	:= cobraInfoNew()
	obj:oIni	:= iniFileNew()
	obj:connect	:=@ COBRA_connect()
	obj:setRootPath	:=@ COBRA_setRootPath()
	obj:close	:=@ COBRA_close()
	obj:send	:=@ COBRA_send()
	obj:sendLine	:=@ COBRA_sendLine()
	obj:receive	:=@ COBRA_receive()
	obj:receiveLine	:=@ COBRA_receiveLine()
	obj:queryNew	:=@ COBRA_queryNew()
	obj:querySend	:=@ COBRA_querySend()
	obj:queryASend	:=@ COBRA_queryASend()
	obj:queryDelete	:=@ COBRA_queryDelete()
	obj:queryRun	:=@ COBRA_queryRun()
	obj:answerSend	:=@ COBRA_answerSend()
	obj:answerWait	:=@ COBRA_answerWait()

	obj:errorBlock	:=@ COBRA_errorBlock()
return obj

/******************************/
static function COBRA_setRootPath(self)
	set(_SET_ROOTPATH,self:rootPath)
return
/******************************/
static function COBRA_connect()
	local ret:=.t.
	if ::nConnect > 0
		::close()
	endif
	::nConnect := tcpConnect( ::cHost, ::nPort, ::nTimeOut )
	if ::nConnect < 0
		::errno := ferror()
		::error := [TCP connection error:]+fErrorStr()
		ret := .f.
	endif
return ret

/******************************/
static function COBRA_close()
	if ::nConnect > 0
		tcpClose(::nConnect)
		::nConnect := -1
	endif
return .t.
/******************************/
static function COBRA_send(cData)
	local nL,ret := .f.
	if ::nConnect > 0 .and. valtype(@cData)=="C"
		nL := tcpWrite( ::nConnect, @cData )
		if nl == len(cData)
			ret :=.t.
		else
			::errno := ferror()
			::error := fErrorStr()
		endif
		if nl>0
			::nSended += nL
		endif
	endif
return ret
/******************************/
static function COBRA_sendLine(cData)
return	::send(cData+"&\n")
/******************************/
static function COBRA_receive(nBytes)
	local nL,ret :=.f.,cBuf
	if ::nConnect < 0
		return .f.
	endif
	nBytes := iif( valtype(nBytes)=="N",nBytes,TCP_BUFLEN)
	cBuf := space(nBytes,.t.)
	nL := tcpRead( ::nConnect, @cbuf, nBytes, ::nIOtimeOut )
	if nL > 0
		ret := .t.
		::buffer += left(@cBuf,nL)
		::nReceived += nL
	else
		::errno := ferror()
		::error := fErrorStr()
	endif
return ret

/******************************/
static function COBRA_receiveLine()
	local i
	::errno := 0
	::error := ""
	while (i := atl("&\n", @::buffer) ) <=0
		::receive()
		if ::errno > 0 .and. ::errno != 11 /* server is busy */
			return .f.
		endif
	end
	::cLine := left(@::buffer,i-1)
	::buffer := substr(@::buffer,i+1)
return .t.
/******************************/
static function COBRA_queryNew()
	local oQuery:=cobraQueryNew()
	::__queries[oQuery:id] := oQuery
return oQuery
/******************************/
static function COBRA_queryDelete(nQuery)
	if valtype(nQuery) != "N"
		return .f.
	endif
	adel(::__queries,nQuery)
return .t.
/******************************/
static function __isQuery(oQuery)
	if valtype(oQuery) != "O"
		return .f.
	endif
	if !(oQuery:className == "COBRAQUERY")
		return .f.
	endif
return .t.
/******************************/
static function __isAnswer(oAnswer)
	if valtype(oAnswer) != "O"
		return .f.
	endif
	if !(oAnswer:className == "COBRAANSWER")
		return .f.
	endif
return .t.
/******************************/
static function COBRA_querySend(nQuery,cCommand,arg1,arg2,arg3,arg4)
	local oQuery,i,ret := .t., str:=""
	if valtype(nQuery) != "N"
		ret := .f.
	endif
	if ret .and. ! (nQuery $ ::__queries)
		ret := .f.
	endif
	if ret
		oQuery := ::__queries[nQuery]
	endif
	if !ret .or. !__isQuery(oQuery)
		::errno := COBRA_ERR_BADQUERY
		::error := [Bad cobraQuery object]
		return .f.
	endif
	if !empty(cCommand)
		oQuery:command := cCommand
	endif
	for i=4 to pcount()
		aadd(oQuery:args,param(i))
	next
	str+="QUERY "+alltrim(str(oQuery:id))+" "
	str+=var2Str(oQuery)
return	::sendLine(str)
/******************************/
static function COBRA_queryASend(nQuery,cCommand,aParams)
	local oQuery,i,ret := .t., str:=""
	if valtype(nQuery) != "N"
		ret := .f.
	endif
	if ret .and. ! (nQuery $ ::__queries)
		ret := .f.
	endif
	if ret
		oQuery := ::__queries[nQuery]
	endif
	if !ret .or. !__isQuery(oQuery)
		::errno := COBRA_ERR_BADQUERY
		::error := [Bad cobraQuery object]
		return .f.
	endif
	if !empty(cCommand)
		oQuery:command := cCommand
	endif
	oQuery:args:=aclone(aParams)
	str+="QUERY "+alltrim(str(oQuery:id))+" "
	str+=var2Str(oQuery)
return	::sendLine(str)
/******************************/
static function COBRA_answerSend(oAnswer)
	local ret := .t., str:=""
	if !__isAnswer(oAnswer)
		::errno := COBRA_ERR_BADANSWER
		::error := [Bad cobraAnswer object]
		return .f.
	endif
	str+="ANSWER "+alltrim(str(oAnswer:id))+" "
	str+=var2Str(oAnswer)
return	::sendLine(str)
/******************************/
static function COBRA_answerWait(nQuery)
	local ret:=.t.,e,err,oErr
	local i,cAnswer,oAnswer,num,data
	local oQuery, oAnswerQuery
	if valtype(nQuery) != "N"
		ret := .f.
	endif
	if ret .and. ! (nQuery $ ::__queries)
		ret := .f.
	endif
	if ret
		oQuery := ::__queries[nQuery]
	endif
	if !ret .or. !__isQuery(oQuery)
		::errno := COBRA_ERR_BADQUERY
		::error := [Bad cobraQuery object]
		return .f.
	endif
	oQuery := NIL
	while .t.
		if !::receiveLine()
			ret := .f.
			exit
		endif
		i := at(" ",::cLine)
		if i<=0
			i := len(::cLine)+1
		endif
		cAnswer := left(::cLine,i-1)
		::cLine := substr(::cLine,i+1)
		if cAnswer == "ERROR"
			::error := ::cLine
			::cLine := ""
			ret := .f.
			exit
		endif
		num := val(::cLine)
		i := at(" ",::cLine)
		if i<=0
			i := len(::cLine)+1
		endif
		data := substr(::cLine,i+1)
		if cAnswer == "ANSWER"
			::cLine := ""
			if num $ ::__queries
				oAnswerQuery := ::__queries[nQuery]
				oAnswerQuery:answer := str2var(data)
			else
				::errno := COBRA_ERR_BADANSWER
				::error := [Answer ID not found]
				ret := .f.
			endif
			if num==nQuery
				exit
			endif
		endif
		/* got request during getting response :) */
		if cAnswer == "QUERY"
			err := errorBlock({|e|break(e)})
			::cLine := ""
			oQuery := str2var(data)
			begin sequence
				oAnswer := ::queryRun(oQuery,::oIni)
				if !empty(::errno)
					oAnswer:id := num
					oAnswer:errno := ::errno
					oAnswer:error := ::error
				endif
			recover using oErr
				oAnswer := cobraAnswerNew()
				oAnswer:id := num
				oAnswer:errno := COBRA_ERR_RUNTIME
				oAnswer:error := errorMessage(oErr)
			end sequence
			errorBlock(err)
			if !::answerSend(oAnswer)
				oAnswer := cobraAnswerNew()
				oAnswer:id := num
				oAnswer:errno := ::errno
				oAnswer:error := ::error
				::answerSend(oAnswer)
			endif
		endif
	end
return ret
/******************************/
static function COBRA_queryRun(self,oQuery,oIniData)
	local oAnswer := cobraAnswerNew()
	local e,err,oErr, alias

	self:errno := 0
	self:error := ""

	if !__isQuery(oQuery)
		self:errno := COBRA_ERR_BADQUERY
		return oAnswer
	endif
	err := errorBlock({|e|break(e)})

	begin sequence
	oAnswer:id := oQuery:id
	do case
		case oQuery:command == "CODBUNIFY"
			__run_codbunify(oQuery:args,oAnswer)
		case oQuery:command == "CODBSELECT"
			__run_codbselect(oQuery:args,oAnswer)
		case oQuery:command == "CODBDELOBJ"
			__run_codbDelObj(oQuery:args,oAnswer)
		case oQuery:command == "CODBGETOBJ"
			__run_codbGetObj(oQuery:args,oAnswer)
		case oQuery:command == "CODBGETNOBJ"
			__run_codbGetNObj(oQuery:args,oAnswer)
		case oQuery:command == "CODBMETABYNAME"
			__run_codbmetabyname(oQuery:args,oAnswer)
		case oQuery:command == "CODBUPDOBJ"
			__run_codbUpdObj(oQuery:args,oAnswer)
		case oQuery:command == "CODBADDOBJ"
			__run_codbAddObj(oQuery:args,oAnswer)
		case oQuery:command == "CLNT"
			__check_clnt_info(self:info,oQuery:args,oAnswer)
		case oQuery:command == "AUTH"
			__run_auth(self:info,oQuery:args,oAnswer,oIniData)
		case oQuery:command == "GETFILE"
			__run_getfile(oQuery:args,oAnswer)
		case oQuery:command == "GETMYFILE"
			__run_getmyfile(self,oQuery:args,oAnswer)
		otherwise
			if valType(oIniData) == "O" .and. oIniData:className=="INIFILE"
				alias := oIniData:getValue("ALIASES",oQuery:command)
			endif
			if empty(alias)
				oAnswer:errno := COBRA_ERR_BADCOMMAND
			else
				//oAnswer:return := clipA(alias,oQuery:args)
				aSize(oQuery:args,len(oQuery:args)+3)
				ains(oQuery:args,1)
				oQuery:args[1] := oAnswer
				ains(oQuery:args,1)
				oQuery:args[1] := oIniData
				ains(oQuery:args,1)
				oQuery:args[1] := self
				clipA(alias,oQuery:args)
			endif
	end
	recover using oErr
		oAnswer:errno := COBRA_ERR_RUNTIME
		oAnswer:error := errorMessage(oErr)
	end sequence
	errorBlock(err)
	//outlog(__FILE__,__LINE__,oAnswer)
return oAnswer
/******************************/
static function __check_args(qArgs,nLen,aTypes)
	local i
	if valtype(qArgs) != "A"
		return .f.
	endif
	if len(qArgs) < nLen
		return .f.
	endif
	for i=1 to len(qArgs)
		if len(aTypes) < i
			return .t.
		endif
		if empty(aTypes[i])
			loop
		endif
		if ! (valtype(qArgs[i]) $ aTypes[i])
			return .f.
		endif
	next
return .t.
/******************************/
static function __run_codbUnify(qArgs,oAnswer)
	local i,cCmd, args:={}
	if valtype(qArgs) !="A" .or. len(qArgs)<1 .or. valtype(qArgs[1]) != "C"
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	cCmd := qArgs[1]
	for i=2 to len(qArgs)
		aadd(args,qArgs[i])
	next
	clip("codb_unify",cCmd,Args,oAnswer)
	if !empty(oAnswer:error) .and. empty(oAnswer:errno)
		oAnswer:errno := COBRA_ERR_CODB
	endif
return
/******************************/
static function __run_codbselect(qArgs,oAnswer)
	local oDep,class_id,cExpr,index,numbers,tmp
		/* dep,class_name|class_id,cExpr,index,numbers*/
	if ! __check_args(qArgs,2,{"C","C","CU","CNU","NU"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	if !isFunction("codb_needDepository")
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := [CODB library not linked]
		return
	endif
	oDep := clip("codb_needDepository",qArgs[1])
	if empty(oDep)
		oAnswer:errno := COBRA_ERR_BADARG
		oAnswer:error := [Bad depository ID:]+qArgs[1]
		return
	endif
	if !empty(oDep:error)
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := oDep:error
		return
	endif
	class_id := clip("codb_metaIdByName",oDep,qArgs[2],"CLASS")
	if empty(class_id)
		oAnswer:errno := COBRA_ERR_BADARG
		oAnswer:error := [Bad class name or ID:]+qArgs[2]
		return
	endif
	if len(qArgs)>2
		cExpr := qArgs[3]
	endif
	if len(qArgs)>3
		index := qArgs[4]
	endif
	if len(qArgs)>4
		numbers := qArgs[5]
	endif
	tmp := oDep:select(class_Id,index,NIL,cExpr,numbers)
	if !empty(oDep:error)
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := oDep:error
	else
		oAnswer:return := tmp
	endif
return
/******************************/
static function __run_codbmetabyname(qArgs,oAnswer)
	local oDep
	if ! __check_args(qArgs,3,{"C","C","C"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	oDep := clip("codb_needDepository",qArgs[1])
	if empty(oDep)
		oAnswer:errno := COBRA_ERR_BADARG
		oAnswer:error := [Bad depository ID:]+qArgs[1]
		return
	endif
	if !empty(oDep:error)
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := oDep:error
		return
	endif
	oAnswer:return := oDep:metaBodyByName(qArgs[2],qArgs[3])
return
/******************************/
static function __run_codbDelObj(qArgs,oAnswer)
	local tmp,oDep
	if ! __check_args(qArgs,1,{"C"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	oDep := clip("codb_needDepository",qArgs[1])
	if empty(oDep)
		oAnswer:errno := COBRA_ERR_BADARG
		oAnswer:error := [Bad depository ID:]+qArgs[1]
		return
	endif
	if !empty(oDep:error)
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := oDep:error
		return
	endif
	tmp := oDep:delete(qArgs[1])
	if !empty(oDep:error)
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := oDep:error
	else
		oAnswer:return := tmp
	endif
return
/******************************/
static function __run_codbGetObj(qArgs,oAnswer)
	local tmp
	if ! __check_args(qArgs,1,{"C"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	if !isFunction("codb_getValue")
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := [CODB library not linked]
		return
	endif
	tmp := clip("codb_cacheGet",qArgs[1])
	if tmp == NIL
		tmp := clip("codb_getValue",qArgs[1])
	endif
	if !empty(tmp)
		clip("codb_cacheAdd",tmp:id,tmp)
	endif
	oAnswer:return := tmp
return
/******************************/
static function __run_codbUpdObj(qArgs,oAnswer)
	local tmp,cId
	if ! __check_args(qArgs,1,{"O","CU"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	if !isFunction("codb_getValue")
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := [CODB library not linked]
		return
	endif
	if len(qArgs)>1
		cId := qArgs[2]
	endif
	if valtype(cId) =="C"
		qArgs[1]:id := cId
	else
		if "ID" $ qArgs[1]
			cId := qArgs[1]:id
		else
			oAnswer:errno := COBRA_ERR_BADOBJID
			return
		endif
	endif
	tmp := clip("codb_update",qArgs[1])
	if tmp
		clip("codb_cacheDel",cId)
	endif
	oAnswer:return := tmp
return
/******************************/
static function __run_codbAddObj(qArgs,oAnswer)
	local oDep,class_id,cExpr,index,numbers,tmp
		/* dep,class_name,Obj*/
	if ! __check_args(qArgs,3,{"C","C","O"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	if !isFunction("codb_needDepository")
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := [CODB library not linked]
		return
	endif
	oDep := clip("codb_needDepository",qArgs[1])
	if empty(oDep)
		oAnswer:errno := COBRA_ERR_BADARG
		oAnswer:error := [Bad depository ID:]+qArgs[1]
		return
	endif
	if !empty(oDep:error)
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := oDep:error
		return
	endif
	class_id := clip("codb_metaIdByName",oDep,qArgs[2],"CLASS")
	if empty(class_id)
		oAnswer:errno := COBRA_ERR_BADARG
		oAnswer:error := [Bad class name or ID:]+qArgs[2]
		return
	endif
	tmp := oDep:append(qArgs[3],class_Id)
	if !empty(oDep:error)
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := oDep:error
	else
		oAnswer:return := tmp
	endif
return
/******************************/
static function __run_codbGetNObj(qArgs,oAnswer)
	local i,tmp
	if ! __check_args(qArgs,1,{"A"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	if !isFunction("codb_getValue")
		oAnswer:errno := COBRA_ERR_CODB
		oAnswer:error := [CODB library not linked]
		return
	endif
	oAnswer:return := {}
	for i=1 to len(qArgs[1])
		tmp := clip("codb_cacheGet",qArgs[1][i])
		if tmp == NIL
			tmp := clip("codb_getValue",qArgs[1][i])
		endif
		if tmp != NIL
			clip("codb_cacheAdd",tmp:id,tmp)
		endif
		aadd(oAnswer:return,tmp)
	next
return
/******************************/
static function __run_auth(oInfo,qArgs,oAnswer,oIni)
	local cUser, cPasswd
	local cCmd,cStdOut:=space(0), cStdErr:=space(0)
	local s1,s2
	if ! __check_args(qArgs,2,{"C","C"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	cUser := qArgs[1]
	cPasswd := qArgs[2]
	cCmd := oInfo:auth
	if empty(cCmd)
		cCmd := COBRA_AUTH_SCRIPT
	endif
	if ( syscmd(cCmd,cUser+" "+cPasswd+"&\n",@cStdOut,@cStdErr) != 0 )
		oAnswer:errno := COBRA_ERR_SYSCMD
		oAnswer:error := cCmd+":"+cStdOut+" "+cStdErr
		oAnswer:return := .f.
	endif
	if empty(oAnswer:error)
		if left(cStdOut,2) == "OK"
			oAnswer:return := .t.
			oInfo:user   := cUser
			oInfo:passwd := cPasswd
		else
			oAnswer:errno := COBRA_ERR_AUTH
			oAnswer:return := .f.
			oAnswer:error := cCmd+":"+cStdOut+" "+cStdErr
		endif
	endif
	if !empty(oAnswer:error)
		s1 := oIni:getValue("TCP","AUTH-ERR-MSG")
		outlog(s1)
		if !empty(s1)
			s2 := memoread(s1)
		endif
		outlog(s2)
		if !empty(s2)
			oAnswer:error += "&\n&\n"+s2
		endif
	endif
return
/******************************/
static function __run_getfile(qArgs,oAnswer)
	local cFile
	if ! __check_args(qArgs,1,{"C"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	cFile := qArgs[1]
	if empty(cFile) .or. !file(makepath(cFile))
		oAnswer:errno := COBRA_ERR_BADFILENAME
		oAnswer:error := [File not found:]+makepath(cFile)
		return
	endif
	oAnswer:return := memoread(cFile)
	if ferror() !=0
		oAnswer:errno := ferror()
		oAnswer:error := ferrorstr()
	endif
return
/******************************/
static function __run_getmyfile(oConnect,qArgs,oAnswer)
	local ret := .t., oQuery := oConnect:queryNew()
	if ! __check_args(qArgs,1,{"C"})
		oAnswer:errno := COBRA_ERR_BADARG
		return
	endif
	if !oConnect:querySend(oQuery:id,"GETFILE",qArgs[1])
		ret := .f.
	endif
	if ret .and. !oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
		ret := .f.
	endif
	if !ret
		oAnswer:errno := oConnect:errno
		oAnswer:error := oConnect:error
		oAnswer:return := .f.
		oConnect:queryDelete(oQuery:id)
		return
	endif
	if empty(oQuery:answer:errno)
		memowrit(qArgs[1],oQuery:answer:return)
		oAnswer:return := .t.
	else
		oAnswer:errno := oQuery:answer:errno
		oAnswer:error := oQuery:answer:error
		oAnswer:return := .f.
	endif
	oConnect:queryDelete(oQuery:id)
return
/******************************/
static function __check_clnt_info(sInfo,qArgs,oAnswer)
	local i,j,x,a,ret := .t.
	local cInfo
	if ! __check_args(qArgs,1,{"O"})
		oAnswer:errno := COBRA_ERR_BADARG
		return .f.
	endif
	cInfo := qArgs[1]
	if ! (cInfo:classname == "COBRAINFO")
		oAnswer:errno := COBRA_ERR_BADINFO
		return .f.
	endif
	if cInfo:version != sInfo:version
		if cInfo:version < COBRA_COMPAT_VERSION
			oAnswer:errno := COBRA_ERR_BADVERSION
			return .f.
		else
			oAnswer:warning += [Need updating client]+"&\n"
		endif
	endif
	/* check langs */
	x := .f.
	for i=1 to len(cInfo:langs)
		j := ascan(sInfo:langs,{|a|upper(a)==upper(cInfo:langs[i])})
		if j<=0
			loop
		endif
		cInfo:lang := sInfo:langs[j]
		x := .t.
	next
	if empty(cInfo:lang)
		oAnswer:errno := COBRA_ERR_BADLANG
		return .f.
	else
		sInfo:lang := cInfo:lang
	endif
	if !x
		oAnswer:warning += [Client LANG value not supported]+"&\n"
	endif
	/* check charsets */
	x := .f.
	for i=1 to len(cInfo:charsets)
		j := ascan(sInfo:charsets,{|a|upper(a) == upper(cInfo:charsets[i])})
		if j<=0
			loop
		endif
		cInfo:charset := sInfo:charset[j]
		x := .t.
	next
	if empty(cInfo:charset)
		oAnswer:errno := COBRA_ERR_BADCHARSET
		return .f.
	else
		sInfo:charset := cInfo:charset
	endif
	if !x
		oAnswer:warning += [Client CHARSET value not supported]+"&\n"
	endif
	/* check crypts */
	x := .f.
	for i=1 to len(cInfo:crypts)
		j := ascan(sInfo:crypts,{|a|upper(a)==upper(cInfo:crypts[i])})
		if j<=0
			loop
		endif
		cInfo:crypto := sInfo:crypts[j]
		x := .t.
	next
	if empty(cInfo:crypto)
		oAnswer:errno := COBRA_ERR_BADCRYPTO
		return .f.
	else
		sInfo:crypto := cInfo:crypto
	endif
	if !x
		oAnswer:warning += [Client CRYPTO value not supported]+"&\n"
	endif
	oAnswer:return := cInfo
return .t.
/*****************************************/
static function COBRA_ErrorBlock(self,err)
	break(err)
return

