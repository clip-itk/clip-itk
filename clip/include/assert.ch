#ifndef _ASSERT_DEFINED
#define _ASSERT_DEFINED

    #ifndef NDEBUG

	#command ASSERT( <exp> [, <msg>] )                                      ;
                                                                        ;
      => IF ( !(<exp>) )                                                ;
       ;   OUTSTD( CRLF+ __FILE__+"("+alltrim(str(__LINE__))+")"+       ;
                   \[  Assertion failed: \] +                           ;
                   IF( <.msg.>, <msg>, <"exp"> )                        ;
                 )                                                      ;
       ;   QUIT                                                         ;
       ; ENDIF

    #else

	#command ASSERT( <exp> [, <msg>] )      =>

#endif

#endif
