// Stand for connection and simply make echo.
#define DEFPORT  3000


function main( cport )

	local nPort, nH, nT := seconds() + 60
	local nCon
	clear screen

	nport := iif( cport != nil, val(cport), DEFPORT )

	if (nH := tcpListen( nport, 10 )) == -1
		? "tcpsrv: Error listen on port ", nport
		?
		return( 1 )
	endif

	? "wait client connection"
	do while( .t. )
		if (nCon := tcpAccept( nH, 50 )) != -1
			? "start",nH,nCon
			start( @conEcho(), nCon )
		endif
		sleep(1)
	enddo
	tcpClose( nH )

	?
return( 0 )


static function ConEcho( nH )
// Make echo.

	local cBuf := space(5), nL, cTxt

	? "task, param : ", nH
	do while( .t. )
		if( (nL := tcpRead( nH, @cBuf, len(cBuf), 6000 )) > 0 )
			if( nL == 1 .and. upper( substr(cbuf,1,1)) == "Q" )
				exit
			endif
			? "tcpsrv, read : ", nL
			cTxt := "tcpsrv:" + substr(cBuf, 1, nL)
			tcpWrite( nH, cTxt )
		endif
	enddo
	tcpClose( nH )

return( 0 )


