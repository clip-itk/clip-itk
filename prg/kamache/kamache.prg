// Stand for connection and simply make echo.
#include "set.ch"
#include "http.ch"

//#define DEBUG

function main( iniFile )

	local oServer
	local oConnect,sConnect,tmpConnect
	local tmp, oIni, nCon

#ifdef DEBUG
	clear screen
#else
	errorBlock({|e|error2Log(e)})
#endif
	set macro_in_string off
	set translate path off
	begin sequence
		mimeTypesLoad()
		oIni := tcpServerLoadIni(iniFile,"kamache.ini")
		tcpServerLoadIniModules(oIni,"HTTP")
	recover
	end sequence

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
#ifdef DEBUG
			? "start",nCon,kamache_commander(tmpConnect,tmpConnect )
#else
			? "start",nCon,start( @kamache_commander(),tmpConnect )
#endif
			tmpConnect:=NIL
		endif
#ifdef DEBUG
		if inkey(1) !=0
			exit
		endif
#else
		sleep(0.01)
#endif
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
	outlog("close task: sended=",oConnect:nSended,"received=",oConnect:nReceived)
return( 0 )

