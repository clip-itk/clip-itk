#ifndef _SIMPLEIO_DEFINED
#define _SIMPLEIO_DEFINED

#command ?  [ <xList,...> ]                                             ;
      => ( OutStd(Chr(13)+Chr(10)) [, OutStd(<xList>)] )

#command ?? [ <xList,...> ]                                             ;
      => OutStd( <xList> )

#command ACCEPT TO <idVar>                                              ;
      => __fhandle:=fopen("-|")						;
      	<idVar> := StrTran( FReadStr(__fhandle, 256), CRLF )		;
        fclose(__fhandle)

#command ACCEPT <cPrompt> TO <idVar>                                    ;
      => ? <cPrompt>                                                    ;
       ; ACCEPT TO <idVar>

#endif

