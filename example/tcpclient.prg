
#define BUFLEN   1024
#define DEFPORT  3000
#define DEFHOST "localhost"

#define nTimeOut 600


function main( cport, chost )

	local nH, nPort , nL, cbuf := space( BUFLEN )
	local nK, cEnv

	clear screen

	nPort := iif(valtype(cport)=='C', val( cport), DEFPORT )
	if( chost == nil ); chost := DEFHOST; endif


	? "Connecting to " + getHostByName( cHost )

	if( (nH := tcpConnect( cHost, nPort, nTimeOut )) == -1 )
		? "Error connecting to " + cHost + " on port "
		?? nPort
		?
		return( 1 )
	endif

	nK := 0; cEnv := ""
	do while ( nK != 27 )
		if( (nL := tcpRead( nH, @cbuf, BUFLEN, 60 )) > 0 )
			? "Received  ("+alltrim(str(nL))+"):"+substr(cbuf,1,nL)
			?
		endif
		if( (nK := inkey( 0.1 )) == 0 )
			loop; endif
		if( nK == 13 )
			nL := tcpWrite( nH, cEnv )
			? "Send: ",nl, + cEnv
			if upper(cEnv)=="Q"
				exit
			endif
			cEnv := ""
		else
			cEnv += chr(nK)
		endif

	enddo

	? tcpClose( nH )

	?

return( 0 )


