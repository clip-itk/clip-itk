#include "cobra.ch"

static oConnect:=cobraServiceNew()

function main(iniFile)
	local nMenu,GetList:={}

	oConnect:oIni := clnt_loadIni(iniFile,oConnect)

	clear screen
	while .t.
		clear screen
		@ 0 ,0 say "Choice client function:"
		@ 1 ,1 prompt "Connect to server    "
		@ 2 ,1 prompt "Send Client info     "
		@ 3 ,1 prompt "Login to server      "
		@ 4 ,1 prompt "Run User command     "
		@ 5 ,1 prompt "Get file from server "
		@ 6 ,1 prompt "Send file to server  "
		@ 7 ,1 prompt "Select data from CODB"
		@ 8 ,1 prompt "Get Object  from CODB"
		@ 9 ,1 prompt "Update object        "
		@ 10,1 prompt "Append object        "
		@ 11,1 prompt "Delete object        "
		@ 12,1 prompt "CODB GETTVIEW        "
		@ 13,1 prompt "Random Load speed tst"
		menu to nMenu
		clear screen
		do switch nMenu
			case 0
				exit
			case 1
				clnt_connect()
			case 2
				clnt_sendInfo()
			case 3
				clnt_login()
			case 4
				clnt_userCommand()
			case 5
				clnt_getFile()
			case 6
				clnt_getmyFile()
			case 7
				clnt_codbselect()
			case 8
				clnt_codbgetObj()
			case 9
				clnt_codbUpdObj()
			case 10
				clnt_codbAddObj()
			case 11
				clnt_codbDelObj()
			case 12
				clnt_codbGetTview()
			case 13
				clnt_randomLoad()
		endswitch
		? "Press any key to continue"
		inkey(0)
		clear screen
	end
	clnt_close()
	? "  Sended",oConnect:nSended,"bytes"
	? "Received",oConnect:nReceived,"bytes"
	?
return
/*************************************/
static function clnt_codbSelect()
	local cDepId:=padr("GBL0101",10)
	local cClass:=padr("currency",30)
	local cExpr :=space(200)
	local cIndex:=space(30)
	local nCount:=0
	local GetList:={}
	local oQuery:=oConnect:QueryNew()
	local a,b
	@ 0,30 say "CODB select parameters:"
	@ 1,30 say "Depository " get cDepid
	@ 2,30 say "Class name " get cClass
	@ 3,30 say "Expression " get cExpr
	read
	clear screen
	cDepId := alltrim(cDepId)
	cClass := alltrim(cClass)
	cExpr := alltrim(cExpr)
	? seconds()
	? "Send query:", oConnect:querySend(oQuery:id,"CODBSELECT",cDepid,cClass,cExpr), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
	? seconds()
	if empty(oQuery:answer:errno) .and. !empty(oQuery:answer:return)
		? "Press any key to continue"
		inkey(0)
		clnt_browseListID(cDepId,cClass,oQuery:answer:return)
	endif

return
/*************************************/
static function clnt_codbGetTView()
	local getList:={},oQuery:=oConnect:QueryNew()
	local cDepId:=padr("GBL0101",10)
	local tViewListId,tViewList,tViewData
	local tViewObj,columns
	local i,n,m:={}
	@ 0,30 say "CODB select parameters:"
	@ 1,30 say "Depository " get cDepid
	read
	clear screen
	cDepId := alltrim(cDepId)
	? "Send query:", oConnect:querySend(oQuery:id,"CODBSELECT",left(cDepid,5),"TVIEW"), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	if !empty(oQuery:Answer:errno)
		? "Error:", oQuery:Answer:errno, oQuery:Answer:error
		return
	endif
	tViewListId :=  oQuery:Answer:return
	oConnect:queryDelete(oQuery:id)
	oQuery:=oConnect:QueryNew()
	? "Send query:", oConnect:querySend(oQuery:id,"CODBGETNOBJ",tViewListId), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	//? "return is=",oQuery:answer
	if !empty(oQuery:Answer:errno)
		? "Error:", oQuery:Answer:errno, oQuery:Answer:error
		return
	endif
	tViewList :=  oQuery:Answer:return
	oConnect:queryDelete(oQuery:id)
	? "Received",len(tViewList),"objects"
	? "Press any key to continue"
	//inkey(0)
	clear screen
	for i=1 to len(tViewList)
		aadd(m,tViewList[i]:name)
	next
	@ 0, 30 say "Choice TVIEW:"
	n:= achoice(1,30,20,79,m)
	if n<=0
		return
	endif
	oQuery:=oConnect:QueryNew()
	? "Send query:", oConnect:querySend(oQuery:id,"CODBTVIEW",tViewList[n]:id,".t.",cDepId), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	if !empty(oQuery:Answer:errno)
		? "Error:", oQuery:Answer:errno, oQuery:Answer:error
		return
	endif
	tViewData :=  oQuery:Answer:return
	? "Received",len(tViewData),"objects"
	oConnect:queryDelete(oQuery:id)
	? "Press any key to continue"
	inkey(0)
	oQuery:=oConnect:QueryNew()
	? "Send query:", oConnect:querySend(oQuery:id,"CODBGETOBJ",tViewList[n]:id), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	if !empty(oQuery:Answer:errno)
		? "Error:", oQuery:Answer:errno, oQuery:Answer:error
		return
	endif
	tViewObj :=  oQuery:Answer:return
	oConnect:queryDelete(oQuery:id)
	oQuery:=oConnect:QueryNew()
	? "Send query:", oConnect:querySend(oQuery:id,"CODBGETNOBJ",tViewObj:col_list), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	//? "return is=",oQuery:answer
	if !empty(oQuery:Answer:errno)
		? "Error:", oQuery:Answer:errno, oQuery:Answer:error
		return
	endif
	columns :=  oQuery:Answer:return
	oConnect:queryDelete(oQuery:id)
	tviewBrowse(,,,,tviewData,columns)
return
/*************************************/
static function clnt_codbAddObj()
	local cDepId:=padr("GBL0101",10)
	local cClass:=padr("currency",30)
	local cName :=space(30)
	local GetList:={}
	local oQuery:=oConnect:QueryNew()
	local a,b,obj:=map()
	@ 0,30 say "CODB Add Object:"
	@ 1,30 say "Depository " get cDepid
	@ 2,30 say "Class name " get cClass
	@ 3,30 say "Attr 'name'" get cName
	read
	clear screen
	cDepId := alltrim(cDepId)
	cClass := alltrim(cClass)
	obj:name := cname
	? "Send query:", oConnect:querySend(oQuery:id,"CODBADDOBJ",cDepid,cClass,obj), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
return
/*************************************/
static function clnt_codbGetObj()
	local cObjId:="GBL010100001"
	local getList:={}
	local oQuery:=oConnect:QueryNew()
	@ 0,30 say "CODB Get parameters:"
	@ 1,30 say "Object ID  " get cObjId
	read
	clear screen
	? seconds()
	? "Send query:", oConnect:querySend(oQuery:id,"CODBGETOBJ",cObjId), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
	? seconds()
return
/*************************************/
static function clnt_codbDelObj()
	local cObjId:="GBL010100001"
	local getList:={}
	local oQuery:=oConnect:QueryNew()
	@ 0,30 say "CODB Get parameters:"
	@ 1,30 say "Object ID  " get cObjId
	read
	clear screen
	? seconds()
	? "Send query:", oConnect:querySend(oQuery:id,"CODBDELOBJ",cObjId), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
	? seconds()
return
/*************************************/
static function clnt_codbUpdObj()
	local cObjId:="GBL010100001"
	local oData:=map(),cName:=""
	local getList:={}
	local oQuery:=oConnect:QueryNew()
	@ 0,30 say "CODB Get parameters:"
	@ 1,30 say "Object ID  " get cObjId
	read
	clear screen
	? "Send query:", oConnect:querySend(oQuery:id,"CODBGETOBJ",cObjId), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
	if empty(oQuery:answer:errno)
		oData := oQuery:answer:return
	endif
	if "NAME" $ oData
		cName := oData:name
		@ 10,30 say "Change obj attribute"
		@ 11,30 say "Name       " get cName
		read
		oData:name := cname
		clear screen
	endif
	oQuery:=oConnect:QueryNew()
	? "Send query:", oConnect:querySend(oQuery:id,"CODBUPDOBJ",oData,cObjId), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
return
/*************************************/
static function clnt_Login()
	local cUser:=space(30),cPass:=space(30)
	local GetList:={}
	local oQuery:=oConnect:QueryNew()
	local a,b
	@ 0,30 say "Login parameters:"
	@ 1,30 say "User name  " get cUser
	@ 2,30 say "Password   " get cPass
	read
	clear screen
	cUser := alltrim(cUser)
	cPass := alltrim(cPass)
	? seconds()
	? "Send query:", oConnect:querySend(oQuery:id,"AUTH",cUser,cPass), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
	? seconds()
return
/*************************************/
static function clnt_userCommand()
	local GetList:={}
	local cCmd:=padr("GETFILELIST",20)
	local cP1:=padr("*.prg",20)
	local oQuery:=oConnect:QueryNew()
	local a,b
	@ 0,30 say "Command Alias parameters:"
	@ 1,30 say "Command name   " get cCmd picture "@S30"
	@ 2,30 say "Param1 value   " get cP1  picture "@S30"
	read
	clear screen
	cCmd := alltrim(cCmd)
	cP1 := alltrim(cP1)
	? "Send query:", oConnect:querySend(oQuery:id,cCmd,cP1), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
return
/*************************************/
static function clnt_GetFile()
	local cFile:=space(200),GetList:={}
	local oQuery:=oConnect:QueryNew()
	local a,b
	@ 0,30 say "Command GETFILE parameters:"
	@ 1,30 say "File name   " get cFile picture "@S30"
	read
	clear screen
	cFile := alltrim(cFile)
	? seconds()
	? "Send query:", oConnect:querySend(oQuery:id,"GETFILE",cFile), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	//? "return is=",oQuery:answer
	? "error is=",oQuery:answer:error
	if empty(oQuery:answer:errno)
		memowrit("_"+cFile,oQuery:answer:return)
	else
		? "Answer error",oQuery:answer:errno,oQuery:answer:error
	endif
	oConnect:queryDelete(oQuery:id)
	? seconds()
return
/*************************************/
static function clnt_GetMyFile()
	local cFile:=space(200),GetList:={}
	local oQuery:=oConnect:QueryNew()
	local a,b
	@ 0,30 say "Command GETMYFILE parameters:"
	@ 1,30 say "File name   " get cFile picture "@S30"
	read
	clear screen
	cFile := alltrim(cFile)
	? seconds()
	? "Send query:", oConnect:querySend(oQuery:id,"GETMYFILE",cFile), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
	? seconds()
return
/*************************************/
static function clnt_SendInfo()
	local a,b
	local oQuery:=oConnect:QueryNew()
	? "Send query:", oConnect:querySend(oQuery:id,"CLNT",oConnect:info), oQuery
	? oConnect:error
	? "Wait answer",oConnect:answerWait(oQuery:id)//, len(oQuery:answer)
	? "return is=",oQuery:answer
	oConnect:queryDelete(oQuery:id)
return
/*************************************/
static function clnt_loadIni(iniFile,oConnect)
	local oIni, val,i
	local values:= {;
		{"NPORT","TCP","port"},;
		{"CHOST","TCP","host"},;
		{"NIOTIMEOUT","TCP","io_timeout"},;
		{"NTIMEOUT","TCP","connect_timeout"};
		}
	if !empty(iniFile) .and. file(iniFile)
		oIni := iniFileNew(iniFile)
	endif
	if empty(oIni) .and. !empty(iniFile)
		? "Usage: cobra_clnt1 <inifile_name>"
		?
		quit
	endif
	if empty(oIni)
		iniFile := PATH_DELIM+"home"+PATH_DELIM+getenv("USER")+;
			   PATH_DELIM+".clip"+PATH_DELIM+"cobra_clnt.ini"
		if file(iniFile)
			oIni := iniFileNew(iniFile)
		endif
	endif
	if empty(oIni)
		iniFile := cliproot()+PATH_DELIM+"etc"+PATH_DELIM+"cobra_clnt.ini"
		if file(iniFile)
			oIni := iniFileNew(iniFile)
		endif

	endif
	if empty(oIni)
		iniFile := "cobra_clnt.ini"
		if file(iniFile)
			oIni := iniFileNew(iniFile)
		endif

	endif
	if empty(oIni)
		oIni := inifileNew()
		return oIni
	endif
	oIni:load()

	for i=1 to len(values)
		val := oIni:getValue(values[i][2],values[i][3])
		if !empty(val)
			oConnect[values[i][1]] := val
		endif
	next
	oConnect:info:fromIni(oIni)
return oIni
/*************************************/
static function clnt_close()
	if ! oConnect:sendLine("QUIT")
		? oConnect:error
	else
		? 'Send to server: "QUIT"', "OK"
	endif
	oConnect:close()
	? "Connection closed, Quit."
return
/*************************************/
static function clnt_connect()
	local ret := .t.,GetList:={}
	@ 0,30 say "Fill connect parameters:"
	oConnect:cHost := padr(oConnect:cHost,30)
	@ 1,30 say "Host name   " get oConnect:cHost
	@ 2,30 say "Port number " get oConnect:nPort
	@ 3,30 say "Timeout     " get oConnect:nTimeOut
	read
	clear screen
	oConnect:cHost := alltrim(oConnect:cHost)
	? "Connecting to " + getHostByName( oConnect:cHost )
	if ! oConnect:connect()
		ret := .f.
		? oConnect:error
	else
		? "OK, nConnect=",oConnect:nConnect
	endif
	oConnect:receiveLine()
	? "Received from COBrA server:",oConnect:cLine
	if "COBRA" $ upper(oConnect:cLine)
		? "COBrA server detected !"
	else
		? "COBrA server NOT detected !"
	endif
return ret
/*************************************/
static function __call_query(command,p1,p2,p3,p4,p5,p6,p7)
	loca oQuery,ret
	oQuery := oConnect:QueryNew()
	oConnect:querySend(oQuery:id,command,p1,p2,p3,p4,p5,p6,p7)
	//outlog(__FILE__,__LINE__,"sendQuery",oQuery)
	oConnect:answerWait(oQuery:id)
	//outlog(__FILE__,__LINE__,"ResultIs",oQuery:answer)
	ret := oQuery:answer:return
	oConnect:queryDelete(oQuery:id)
return ret

/*************************************/
static function clnt_browseListId(cDepID,cCLass,listId)
	local i,j,a,b:={},c,tm, classDesc
	local fields := {}
	local headers := {}
	classDesc := __call_query("CODBMETABYNAME",left(cDepid,5),"CLASS",cClass)
	for i=1 to len(classDesc:attr_list)
		a:= __call_query("CODBGETOBJ",classDesc:attr_list[i])
		if empty(a)
			loop
		endif
		aadd(fields,a)
		aadd(headers,a:name)
	next
	tm := seconds()
	? "Loading objects:"
#ifdef ___1
	for i=1 to len(listId)
		a := NIL
		a:= __call_query("CODBGETOBJ",listId[i])
		if empty(a)
			loop
		endif
		aadd(b,a)
		?? "."
	next
#else
	b:= __call_query("CODBGETNOBJ",listId)
#endif
	? "Loaded",len(b),"objects at",seconds()-tm,"seconds"
	? "Press any key to continue"
	//inkey(0)
	objBrowse(,,,,b,fields,,,headers)
	clear screen
return
/*************************************/
static function clnt_randomLoad()
	local a,b,c
	local i,j,k,nkey:=0
	local tm:=seconds(),count:=0
	a:= __call_query("CODBSELECT","GBL01","CLASS")
	? "Detected",Len(a),"classes"
	while .t.
	    for i=1 to len(a)
		b:= __call_query("CODBSELECT","GBL0101",a[i])
		? "Found",len(b),"objects for",a[i]
		/*
		count++
		for j=1 to len(b)
			c:= __call_query("CODBGETOBJ",b[j])
			count++
		next
		*/
		c:= __call_query("CODBGETNOBJ",b)
		count+=len(b)
		? "Loaded",count,"objects,",seconds()-tm,"seconds"
		if (nkey :=inkey())!=0
			exit
		endif
	    next
	    if nkey!=0
		exit
	    endif
	end
return

