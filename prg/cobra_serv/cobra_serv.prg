// Stand for connection and simply make echo.
#include "set.ch"
#include "cobra.ch"

//#define DEBUG

function main( iniFile )

	local tmp, serv_info := map(),oIni
	local nCon

#ifdef DEBUG
	clear screen
#else
	errorBlock({|e|error2Log(e)})
#endif
	set macro_in_string off
	begin sequence
	oIni := serv_loadIni(iniFile,Serv_info)
#ifdef DEBUG
	outlog(__FILE__,__LINE__,oIni)
#endif
	serv_openCODB(oIni)
	recover
	end sequence

	? "COBRA_SERV: listen on port ", serv_info:nPort
	serv_info:listen := tcpListen( serv_info:nPort, 100 )
	if ( serv_info:listen ) == -1
		? "COBRA_SERV: Error listen on port ", serv_info:nPort, ferrorStr()
		?
		return( 1 )
	endif

	? "wait client connection"
	do while( .t. )
		if (nCon := tcpAccept( serv_info:listen, 300 )) != -1
#ifdef DEBUG
			? "start",serv_info:listen,nCon,cobra_commander(nCon, oIni )
#else
//			? "start",serv_info:listen,nCon,cobra_commander(nCon, oIni )
			? "start",serv_info:listen,nCon,start( @cobra_commander(), nCon, oIni )
#endif
		endif
#ifdef DEBUG
		if inkey(1) !=0
			exit
		endif
#else
		sleep(1)
#endif
	enddo
	? "COBRA_SERV: listen close ", serv_info:nPort,serv_info:listen
	tcpClose( serv_info:listen )

	?
return( 0 )


static function cobra_commander( nH, oInI )
	local i,command,nQuery,oQuery,oAnswer
	local oConnect := cobraServiceNew()
	local cFile := "log_"+alltrim(str(nH))+"_"+alltrim(str(seconds()))+".log"
	local err,oErr,rootPath
	local cCmdWrapper, cDaemon, cIPAddr

	? "Task started",seconds(),nH
	set macro_in_string off
	set translate path off
	set deleted on
	//set(_SET_LOGFILE,cFile)
	set(_SET_LOGLEVEL,3)
	outlog("start task for handle:", nH)

	rootPath = oIni:getValue("SERVER","ROOTPATH")
	if empty(rootpath)
		rootPath := "./"
	else
		rootPath := strtran(rootPath,"$CLIPROOT",cliproot())
	endif
	set(_SET_ROOTPATH,rootPath)
	outlog("Set ROOTPATH:", rootPath)


	oConnect:nPort		:= -1
	oConnect:nIOtimeOut	:= 60000
	oConnect:nConnect	:= nH

	oConnect:info:fromIni(oIni)

	cCmdWrapper := oIni:getValue("TCP","WRAPPER")
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

#ifdef DEBUG
	outlog(__FILE__,__LINE__,oIni)
#endif
	i := oIni:getValue("TCP","AUTH")
#ifdef DEBUG
	outlog(__FILE__,__LINE__,oIni)
#endif
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

/*************************************/
static function serv_loadIni(iniFile,serv_info)
	local oIni, val,i, modules,mfuncs:={}
	local s,e,err,oErr,lExit:=.f.
	local values:= {;
		{"NPORT","TCP","port",COBRA_DEFPORT};
		}
	for i=1 to len(values)
		serv_info[values[i][1]] := values[i][4]
	next
	if !empty(iniFile) .and. file(iniFile)
		oIni := iniFileNew(iniFile)
	endif
	if empty(oIni) .and. !empty(iniFile)
		? "Error: inifile not found:",iniFile
		? "Usage: cobra_serv <inifile_name>"
		?
		quit
	endif
	if empty(oIni)
		iniFile := cliproot()+PATH_DELIM+"etc"+PATH_DELIM+"cobra_serv.ini"
		if file(iniFile)
			oIni := iniFileNew(iniFile)
		endif

	endif
	if empty(oIni)
		iniFile := "cobra_serv.ini"
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
	for i=1 to len(values)
		val := oIni:getValue(values[i][2],values[i][3])
		if !empty(val)
			serv_info[values[i][1]] := val
		endif
	next
	/* load modules */
	err := errorBlock({|e|break(e)})
	modules := oIni:keys("MODULES")
	? "Loading modules:",modules
	for i=1 to len(modules)
		val := oIni:getValue("MODULES",modules[i])
		? modules[i],val,"...."
		if empty(val) .or. valtype(val) !="C"
			?? "bad definition"
			lExit := .t.
			loop
		endif
		if ! file(val)
			?? "module not found:"
			lExit := .t.
			loop
		endif
		begin sequence
			load(val,mFuncs)
			?? "OK"
			? "Export functions:",mFuncs
		recover using oErr
			?? errorMessage(oErr)
			lExit := .t.
		end sequence
	next
	errorBlock(err)
	if lExit
		quit
	endif
return  oIni

/*************************************/
static function serv_openCODB(oIni)

	local dList,List
	local dictId,dictList:={},oDicts:={}
	local depId,depList:={}, oDeps:={}
	local i,j,k,tmp,key
	local use_all := .f.

	i:=oIni:getValue("CODB","POLICY")
	if empty(i) .or. "ALL" $ upper(i)
		use_all := .t.
	endif

	i := oIni:sections()
	j := ascan(i,"CODB")
	if j<=0 /* not open CODB data */
		return
	endif
	i := oIni:getValue("CODB","open_mode")
	if !empty(i)
		if left(upper(i),4)=="EXCL"
			set exclusive on
		else
			set exclusive off
		endif
	endif

	set translate path off
	set autopen on
	set deleted on
	rddsetdefault("DBFCDX")

	dList:=codbList():new()
	if val(dList:error)!=0
		? [Error open dictionaries list:]+dList:error
		?
		return
	endif

	list := dList:list()
	for i=1 to len(list)
		j := at(":",list[i])
		aadd(dictList,left(list[i],j-1))
	next
	? "Detected dictionaries:",dictList

	for i=1 to len(dictList)
		dictId := dictList[i]
		aadd(oDicts,NIL)
		? "Open dictionary:",dictId,""
		key := oIni:getValue("CODB",dictId)
		if use_all
			if !empty(key) .and. left(upper(key),2)=="DI" /* disabled */
				?? "disabled"
				loop
			endif
		else
			if empty(key) .or. !(left(upper(key),2)=="EN") /* enabled */
				?? "disabled"
				loop
			endif
		endif
		?? "opening "
		oDicts[i] := coDictionary():new(dictId)
		if !empty(oDicts[i]:error)
			?? oDicts[i]:error
			loop
		endif
		tmp := oDicts[i]:select("DEPOSIT")
		for j=1 to len(tmp)
			key := oDicts[i]:getValue(tmp[j])
			if empty(key)
				loop
			endif
			aadd(depList,dictId+key:number)
		next
		?? "OK"
	next
	? "Detected depositories:",depList
	for i=1 to len(depList)
		depId := depList[i]
		aadd(oDeps,NIL)
		? "Open depository:",depId,""
		key := oIni:getValue("CODB",depId)
		if use_all
			if !empty(key) .and. left(upper(key),2)=="DI" /* disabled */
				?? "disabled"
				loop
			endif
		else
			if empty(key) .or. !(left(upper(key),2)=="EN") /* enabled */
				loop
			endif
		endif
		?? "opening "
		oDeps[i] := coDepository():new(depId)
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			loop
		endif
		oDeps[i]:open()
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			loop
		endif
		oDeps[i]:extentOpenAll()
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			loop
		endif
		?? "OK"
	next

return


/*****************************************/
static function error2Log(err)
	local i,s
	i := 1
	while ( !Empty(ProcName(i)) )
		s := "Called from "+allTrim(ProcName(i)) + ;
			"(" + str(ProcLine(i)) + ")"

		//? s
		outlog(s)
		i++
	end
	outlog("object error:",err)
	s := errorMessage(err)
	? s
	outlog(s)
return

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
