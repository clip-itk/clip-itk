// Stand for connection and simply make echo.
#include "set.ch"
#include "tcp.ch"
#include "cobra.ch"
#include "http.ch"

//#define DEBUG

function main( iniFile )

	local tmp, oIni

#ifdef DEBUG
	clear screen
#else
	errorBlock({|e|error2Log(e)})
#endif
	set macro_in_string off
	set translate path off
	begin sequence
		mimeTypesLoad()
		oIni := tcpServerLoadIni(iniFile,"cobra_serv.ini")
		//tmp  := serv_loadModules(oIni)
		tcpServerLoadIniModules(oIni,"COBRA")
	recover
	end sequence
#ifdef DEBUG
	cobra_server(oIni)
	http_server(oIni)
#else
	start(@cobra_server(),oIni)
	start(@http_server(),oIni)
#endif
	while .t.
#ifdef DEBUG
		if inkey(10) !=0
			exit
		endif
#else
		sleep(1000)
#endif
	enddo
	?
return

*********************************
static function cobra_server(oIni)
	local oServer := tcpServerNew("COBrA_SERV",COBRA_DEFPORT,"COBRA",oIni)
	local tmp, nCon

	errorBlock({|e|error2Log(e)})
	? oServer:name+": listen on port ", oServer:nPort

	if ! oServer:listen()
		? oServer:name+":"+oServer:error
		?
		errorlevel(1)
		return( 1 )
	endif

	? "wait client connection"
	do while( .t. )
		if (nCon := oServer:Accept()) != -1
			? "start",nCon,start( @cobra_commander(), nCon, oIni )
		endif
		sleep(0.01)
	enddo
	? oServer:name+": listen close "
	oServer:close()
return( 0 )

*******************************************
static function cobra_commander( nH, oInI )
	local i,command,nQuery,oQuery,oAnswer
	local oConnect, cFile, err,oErr
	local cCmdWrapper, cDaemon, cIPAddr

	? "Task started",seconds(),nH
	errorBlock({|e|error2Log(e)})
	//cFile := "log_"+alltrim(str(nH))+"_"+alltrim(str(seconds()))+".log"
	oConnect := cobraServiceNew(oIni)
	oConnect:setRootPath()
	//errorBlock({|e|oConnect:errorBlock(e)})
	set macro_in_string off
	set translate path off
	set deleted on
	//set(_SET_LOGFILE,cFile)
	set(_SET_LOGLEVEL,3)
	outlog("start task for handle:", nH)

	oConnect:nPort		:= -1
	oConnect:nIOtimeOut	:= 60000
	oConnect:nConnect	:= nH

	oConnect:info:fromIni(oIni)

	cCmdWrapper := oIni:getValue("COBRA","WRAPPER")
	cDaemon := parsefilename(startpath())
	cIPAddr := ""
	tcpGetPeerName(nH, @cIPAddr)
	if !tcp_wrappers(cCmdWrapper, cDaemon, cIPAddr)
		? "Disable connection for:", cIPAddr
		outlog("Disable connection for:", cIPAddr)
		oConnect:close( nH )
		return( 1 )
	endif

	oConnect:sendLine("COBrA (CLIP Object Broker & Application Server) ver:"+alltrim(str(COBRA_VERSION))+" (C) 2003, ITK, Izevsk,Russia.")

	i := oIni:getValue("COBRA","AUTH")

	if !empty(i)
		oConnect:info:auth := i
	endif
	errorBlock({|err|break(err)})

	do while( .t. )

		if oConnect:receiveLine()
#ifdef DEBUG
			outlog("Read from client:",'"'+oConnect:cLine+'"')
#endif
			i := at(" ",oConnect:cLine)
			if i<=0
				i := len(oConnect:cLine)+1
			endif
			command := upper(left(oConnect:cLine,i-1))
#ifdef DEBUG
			outlog("Command detected:",command)
#endif
			if command == "QUIT"
				outlog("Closed task by QUIT for handle:", nH)
				exit
			endif
			oConnect:cLine := substr(oConnect:cLine,i+1)
			i := at(" ",oConnect:cLine)
			if i<=0
				i := len(oConnect:cLine)+1
			endif
			if command == "QUERY"
				nQuery := val(oConnect:cLine)
				oQuery := str2var(substr(oConnect:cLine,i+1))
#ifdef DEBUG
				outlog("Query detected:",command,nQuery,oQuery)
#endif
				oConnect:cLine := ""
				begin sequence
#ifdef DEBUG
					outlog(__FILE__,__LINE__,"queryRun call")
#endif
					oAnswer := oConnect:queryRun(oQuery,oIni)
#ifdef DEBUG
					outlog(__FILE__,__LINE__,"queryRun return")
#endif
					if !empty(oConnect:errno)
						oAnswer:id := nQuery
						oAnswer:errno := oConnect:errno
						oAnswer:error := oConnect:error
					endif
				recover using oErr
#ifdef DEBUG
					outlog(__FILE__,__LINE__,"queryRun errorBlock")
#endif
					oAnswer := cobraAnswerNew()
					oAnswer:id := nQuery
					oAnswer:errno := COBRA_ERR_RUNTIME
					oAnswer:error := errorMessage(oErr)
				end sequence
#ifdef DEBUG
				outlog("Send answer:",oAnswer)
#endif
				if !oConnect:answerSend(oAnswer)
					oAnswer := cobraAnswerNew()
					oAnswer:id := nQuery
					oAnswer:errno := oConnect:errno
					oAnswer:error := oConnect:error
#ifdef DEBUG
					outlog("Send error answer:",oAnswer)
#endif
					oConnect:answerSend(oAnswer)
				endif
			else
				i := "ERROR "+[bad command:]+command
#ifdef DEBUG
				outlog("Send to client:",'"'+i+'"')
#endif
				oConnect:sendLine(i)
			endif
			//run_command(oConnect)
		elseif oConnect:errno == 32
			outlog("Connection closed from client:",ferrorStr())
			exit
		endif
	enddo
	outlog("Close TCP handle:",nH)
	oConnect:close( nH )

return( 0 )

*********************************
static function http_server(oIni)
	local oServer,nCon
	local oConnect,sConnect,tmpConnect

	errorBlock({|e|error2Log(e)})

	set macro_in_string off
	set translate path off

	oServer := tcpServerNew("KAMACHE",KAMACHE_DEFPORT,"HTTP",oIni)

	oConnect := httpServiceNew(oIni)
	oConnect:nPort	:= oServer:nPort
	oConnect:defSetting()
	sConnect:=var2str(oConnect)

	? oServer:name+": listen on port ", oServer:nPort
	if ! oServer:listen()
		? oServer:name+":"+oServer:error
		?
		errorlevel(1)
		return( 1 )
	endif

	? "wait client connection"
	do while( .t. )

		if (nCon := oServer:Accept()) != -1
			tmpConnect:=str2var(sConnect)
			tmpConnect:nConnect := nCon
			? "start",nCon,start( @kamache_commander(),tmpConnect )
			tmpConnect:=NIL
		endif
	enddo
	? oServer:name+": listen close "
	oServer:close()
return( 0 )


/*********************************/
static function kamache_commander(oConnect)
	local e

	? "Task started",seconds(),oConnect:nConnect
	outlog("start task for handle:", oConnect:nConnect)

	errorBlock({|e|oConnect:errorBlock(e)})

	begin sequence
		if ! oConnect:waitRequest()
			return
		endif
		oConnect:runCommand()
	recover
		oConnect:close()
	end sequence
	outlog("close task for handle:", oConnect:nConnect,"sended=",oConnect:nSended,"received=",oConnect:nReceived)
return( 0 )

/***************************************/
static function tcp_wrappers(cCmd, cDaemon, cIPAddr)
	local cStdOut:=space(0), cStdErr:=space(0)
	local lResult:=.t.

	if !empty(cCmd)
		if ( syscmd(cCmd,cDaemon+" "+cIPAddr+"&\n",@cStdOut,@cStdErr) != 0 )
			? "error "+cCmd+":"+cStdOut+" "+cStdErr
			lResult:=.f.
		elseif left(cStdOut,2) <> "OK"
			lResult:=.f.
		endif
	endif

return lResult
