#ifndef _DLL_CH
#define _DLL_CH

#define VOID     0
#define BYTE     1
#define CHAR     2
#define WORD     3
#define _INT     4         // conflicts with Clipper Int()
#define BOOL     5
#define HDC      6
#define LONG     7
#define STRING   8
#define LPSTR    9
#define PTR     10
#define _DOUBLE 11         // conflicts with BORDER DOUBLE

#translate NOREF([@]<x>) => <x>

//----------------------------------------------------------------------------//

#xcommand DLL [<static:STATIC>] FUNCTION <FuncName>( [ <uParam1> AS <type1> ] ;
                                                     [, <uParamN> AS <typeN> ] ) ;
             AS <return> [<pascal:PASCAL>] LIB <*DllName*> ;
       => ;
          [<static>] function <FuncName>( [NOREF(<uParam1>)] [,NOREF(<uParamN>)] ) ;;
             local hDLL := LoadLibrary( <(DllName)> ) ;;
             local cFarProc ;;
             local uResult ;;
             if hDLL != 0 ;;
                cFarProc = GetProcAddress( hDLL, <(FuncName)>, [<.pascal.>], <return> [,<type1>] [,<typeN>] ) ;;
                uResult = CallDLL( cFarProc [,<uParam1>] [,<uParamN>] ) ;;
                FreeLibrary( hDLL ) ;;
             end ;;
          return uResult

#endif

//----------------------------------------------------------------------------//
