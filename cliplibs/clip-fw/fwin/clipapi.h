////////////////////////////////////////////////////////////////////////////////
//   Clipper API ver 1.0                           Fco.Pulp×n, A.Linares      //
////////////////////////////////////////////////////////////////////////////////

#ifndef _CLIPAPI_H
#define _CLIPAPI_H

// Some xBase for C language!
#define IF(x,y,z) ((x)?(y):(z))

#define MAX( a, b ) ( int ) (((int)(a) > (int)(b)) ? (a) : (b))
#define MIN( a, b ) ( int ) (((int)(a) < (int)(b)) ? (a) : (b))

// Types for wType in generic struct CLIPVAR
#define NIL             0x0000
#define NUMERIC         0x0002   // DWORD
#define NUM_FLOAT       0x0008
#define DATE            0x0020
#define LOGICAL         0x0080
#define CHARACTER       0x0400
#define BLOCK           0x1000
#define ARRAY           0x8000
#define OBJECT          ARRAY

#define BY_REF          0x2000   // Locals and Statics Ref's
#define BY_REF_MEM      0x4000   // MemVars Ref's

#define ANYREF          0x6000   // Mask Any referenced type.
#define ANYNUMBER       0x000A   // Mask any Numerical type. 0x0002 & 0x0008
#define ALLTYPES        0xFFFF   // Mask all types.

#define CLIPPER void pascal

#ifndef __WINDOWS_H

typedef unsigned char BYTE;
typedef unsigned int WORD;
typedef signed long LONG;
typedef unsigned long DWORD;


typedef BYTE far  * LPBYTE;
typedef char far  * LPSTR;
typedef WORD * PWORD;
typedef WORD far * LPWORD;
typedef LONG * PLONG;
typedef LONG far * LPLONG;
typedef DWORD* PDWORD;
typedef DWORD far * LPDWORD;



typedef enum{ FALSE, TRUE } BOOL;


#endif

typedef struct
{
   WORD  wType;
   WORD  w2;
   WORD  w3;
   LPBYTE pPointer1;
   LPBYTE pPointer2;
} CLIPVAR;              // sizeof( CLIPVAR )  --> 14 bytes

// Una especie de herencia del struct CLIPVAR para types NUMERIC
// A kind of inheritance from CLIPVAR struct for NUMERIC types
typedef struct
{
   WORD wType;
   LONG lDummy1;
   LONG lnNumber;
   LONG lDummy2;
     
} CLV_LONG;


typedef struct
{
   WORD wFloat[ 4 ];
} CLIP_FLOAT;

// Una especie de herencia del struct CLIPVAR para types NUM_FLOAT
// aun estÁ por desarrollar. Son las funciones _dv.....

// A kind of inheritance from CLIPVAR struct for NUM_FLOAT types
// still to be completed. They are the functions _dv......

typedef struct
{
   WORD wType;
   LONG lDummy1;
   CLIP_FLOAT fFloat;
     
} CLV_FLOAT;

// Estructura CLV_WORD para NUMERIC (WORD) y para los LOGICAL (BOOL).
// CLV_WORD struct for NUMERIC (WORD) and for LOGICAL (BOOL).

typedef struct
{
    WORD wType;
    LONG lDummy;
    WORD wWord;         // for LOGICAL clipvars -> Casting to (BOOL)
    WORD wDummy[ 3 ];

} CLV_WORD;

// Estructura VITEMCHAR para VITEM's CHAR.
// VITEMCHAR struct for VITEM's CHAR.

typedef struct
{
    WORD wType;
    WORD wLen;
    WORD wDummy[ 5 ];

} CLV_CHAR;


typedef CLIPVAR near * PCLIPVAR;
typedef CLIPVAR far * LPCLIPVAR;

// When a parameter is passed by reference, Clipper provides a
// ClipVar that keeps a pointer to the original ClipVar.
// We call this a REF_CLIPVAR;

typedef struct
{
   WORD wType;
   WORD w2;
   WORD w3;
   PCLIPVAR pClipVar;
   LPBYTE pVoid;
} REF_CLIPVAR;

typedef void ( pascal * PCLIPFUNC )( void );

typedef struct
{
   BYTE cName[ 11 ];
   BYTE cType;
   LPBYTE pSymbol; // Is a LPCLIPSYMBOL. You must cast.
} CLIPNAME;                      // 16 bytes

typedef CLIPNAME * PCLIPNAME;
typedef CLIPNAME far * LPCLIPNAME;

typedef struct
{
   BYTE Dummy[ 8 ];
   PCLIPNAME pName;
   PCLIPFUNC pFunc;
} CLIPSYMBOL;                    // 16 bytes

typedef CLIPSYMBOL * PCLIPSYMBOL;
typedef CLIPSYMBOL far * LPCLIPSYMBOL;

extern PCLIPSYMBOL _SymEval;         // == _Get_Sym( "EVAL" )
                                     // SymSys init


/////////////////////////////////////////////////////////
// EXTEND Module - Clipper Extend system functions     //
/////////////////////////////////////////////////////////


extern WORD  _parinfo( WORD );
extern WORD  _parinfa( WORD, WORD );
extern LPSTR _parc( WORD wParam, ... );
extern WORD  _parclen( WORD wParam, ... );
extern BOOL  _parl( WORD wParam, ... );
extern int   _parni( WORD wParam, ... );
extern LONG  _parnl( WORD wParam, ... );
extern void  _retc( char * );
extern void  _retclen( char *, WORD wLen );
extern void  _retd( char * );
extern void  _retl( BOOL );
extern void  _retni( WORD wNumber );
extern void  _retnl( LONG lNumber );
extern void  _ret( void );
extern void  _reta( WORD wArrayLen );      // Creates and returns an Array
extern BOOL  _storc( LPSTR, WORD wParam, ... );
extern BOOL  _storclen( LPSTR, WORD wLen, WORD wParam, ... );
extern BOOL  _storl( BOOL, WORD wParam, ... );
extern BOOL  _storni( WORD wValue, WORD wParam, ... );
extern BOOL  _stornl( LONG lValue, WORD wParam, ... );
extern BOOL  _stords( LPSTR szYYYYMMDD, WORD wParam, ... );
extern void  _xunlock( void );
extern LPBYTE _xgrab( WORD wSize );
extern void   _xfree( LPBYTE );

#define  ISCHAR( c )     ( ( _lbase + c + 1 )->wType & CHARACTER )
#define  ISNUM( c )      ( ( _lbase + c + 1 )->wType & ANYNUMBER )
#define  ISLOGICAL( c )  ( ( _lbase + c + 1 )->wType & LOGICAL )
#define  ISARRAY( c )  ( ( _lbase + c + 1 )->wType & ARRAY )
#define  ISDATE( c )  ( ( _lbase + c + 1 )->wType & DATE )
#define  ISBLOCK( c )  ( ( _lbase + c + 1 )->wType & BLOCK )
#define  ISBYREF( c )  ( ( _lbase + c + 1 )->wType & ANYREF )



// Retrieves any parameter checking type. Use ALLTYPES #define for no test.
extern PCLIPVAR _param( WORD wParam, WORD wType );

// Number of parameters
extern WORD _pcount;

#define PCOUNT() _parinfo(0)

typedef struct
{
   BYTE Red, Green, Blue, Attr;       // Four bytes
} RGB;

//////////////////////////////////////////////////////
// COLOR Module - Colors Control                    //
//////////////////////////////////////////////////////

// General Terminal
typedef struct
{                         //  R   G   B   +*
   RGB Fore;              //  FF  FF  FF  00
   RGB Back;              //  FF  FF  FF  00
} CLIPCOLOR;

extern CLIPCOLOR * _colors;       // _colors[ 5 ]
extern WORD _ColorCount;      // Number of colors used É?
void _xSetColor( PCLIPVAR );  // String dBase Colors

//////////////////////////////////////////////////////////////////
// GT Module - General Terminal                                 //
//////////////////////////////////////////////////////////////////

typedef struct
{
   WORD wTop;
   WORD wLeft;
   WORD wHeight;
   WORD wWidth;      // so there is no conflict with Windows.h rect
} gtRECT;            // asÂ no hay conflicto con el rect de windows.h

typedef gtRECT * LPgtRECT;

typedef struct
{
   WORD wTop, wLeft, wHeight, wWidth;
   BYTE RGBColor[ 8 ];
   LONG lDummy1;
   WORD wDummy2;
   WORD wDummy3;
   LPBYTE p34Bytes;
   BYTE bDummy2[ 10 ];
} WINDOW;

typedef WINDOW * gtHWND;
typedef gtHWND * PgtHWND;


WORD _gtBox( WORD, WORD, WORD, WORD, LPSTR );
WORD _gtColorSelect( WORD wColor );      // __color() in 5.01
WORD _gtMaxRow( void );
WORD _gtMaxCol( void );
WORD _gtSetColor( CLIPCOLOR * pColors );
WORD _gtGetColor( CLIPCOLOR * pColors );
WORD _gtSetPos( WORD wRow, WORD wCol );
WORD _gtGetPos( WORD * pwRow, WORD * pwCol );
WORD _gtScroll( WORD, WORD, WORD, WORD, int );
WORD _gtWriteAt( WORD wRow, WORD wCol, LPSTR szText, WORD wLen );
WORD _gtWrite( LPSTR szText, WORD wLen );
WORD _gtWriteCon( LPSTR szText, WORD wLen );
WORD _gtSave( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPBYTE pBuffer );
WORD _gtScrDim( LPWORD pwRows, LPWORD pwCols );
WORD _gtRest( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPBYTE pBuffer );
WORD _gtRectSize( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPWORD wResult );
WORD _gtRepChar( WORD wRow, WORD wCol, WORD wChar, WORD wTimes );

// Undocumented Windowing System !!!
void _gtWCreate( LPgtRECT rctCoors, PgtHWND hWnd );
void _gtWCurrent( gtHWND hWnd );
BOOL _gtWVis( gtHWND hWnd, WORD wStatus );
BOOL _gtWFlash( void );
void _gtWApp( PgtHWND hWndApp );
void _gtWPos( gtHWND hWnd, LPgtRECT rctCoors );

// Selects a color - Clipper calling conventions
extern void _color( void );

// extended GT - RUNsoft
void _gtShadow( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight );
void _gtClrReverse( WORD wColor );
void _gtSayHot( WORD wRow, WORD wCol, LPSTR szText, WORD wClrNormal, WORD wClrHot );
WORD _gtClrGet( WORD wColor );

//////////////////////////////////////////////////////////////////
// FILESYS Module - Low level Files Management
//////////////////////////////////////////////////////////////////

extern WORD _tcreat( LPSTR szFileName, WORD wMode );
extern BOOL _tclose( WORD wHandle );
extern WORD _topen( LPSTR szFileName, WORD wMode );
extern LONG _tlseek( WORD wHandle, LONG lRecNo, WORD wPosition );
extern WORD _tread( WORD wHandle, LPBYTE cBuffer, WORD wBytes );
extern WORD _twrite( WORD wHandle, LPBYTE cBuffer, WORD wBytes );

////////////////////////////////////////////////////////////////////////////
// STACK and OM Module - Clipper internal stack and ClipVars management   //
////////////////////////////////////////////////////////////////////////////

// it stores the return value of a function // return ...
extern PCLIPVAR _eval;

// _lbase + 1  --> Self from within Methods ! Reach it with _par...( 0, ... ) !
// _lbase + 2  --> First parameter
// _lbase + 3  --> Second parameter
// ...
extern PCLIPVAR _lbase;      // LOCAL BASE

// statics
extern PCLIPVAR _sbase;    // STATIC BASE

// Clipper Stack   tos = TO S tack
extern PCLIPVAR _tos;


// They automatically update _tos.
extern void _PutC( LPSTR szText );
extern void _PutCL( LPSTR szText, WORD wLen );
extern void _PutQ( WORD wNumber );
extern void _PutLN( LONG lNumber );
extern void _PutL( BOOL );

// Places any CLIPVAR at Clipper Stack.  Pass ClipVars by value.
// Automatically updates _tos
extern void _xPushM( LPCLIPVAR );    


// calling Clipper from C
extern void _PutSym( PCLIPSYMBOL );
// ( ++_tos )->wType = NIL;               <-- We place nil at Self !!!
// we place other params with _Put...
extern void _xDo( WORD wParams );


// executing CodeBlocks

// _PutSym( _symEVAL );
extern void _xEval( WORD wNumberOfParameters );

                                           // eval a codeblock with no params
extern void _cEval0( PCLIPVAR CodeBlock ); // evalua codeblock sin parametros.
extern void _cEval1( PCLIPVAR CodeBlock, PCLIPVAR Param1 ); // idem con un parÁmetro.
                                           // same but with one param

extern PCLIPVAR _GetGrip( PCLIPVAR ); // allocates new clipvar in high stack pos.
extern void    _DropGrip( PCLIPVAR ); // free it.


// Returns pointer to _lbase of calls stack, 0->this, 1->previous, ...
extern PCLIPVAR _ActInfo( WORD wIndex );


extern WORD  _sptoq( PCLIPVAR );   // Returns the value of a number placed at _tos
                                   // By value or by ref as WORD
extern LONG  _sptol( PCLIPVAR );   // IDEM as LONG


// Copy wBytes from Source to Destination
extern void _bcopy( LPBYTE pDest, LPBYTE pSource, WORD wBytes );

// Inicializes wLen Bytes with the value wValue
extern void _bset( LPBYTE pStart, WORD wValue, WORD wLen );

// Retrieves an element of an array
extern void _cAt( PCLIPVAR vArray, WORD wIndex, WORD wFlag, PCLIPVAR vDest );

// Changes an element of an array
extern void _cAtPut( PCLIPVAR vArray, WORD wIndex, PCLIPVAR vSource );

// Stores a String into an array element
extern void _cAtPutStr( PCLIPVAR vArray, WORD wIndex, LPSTR szString,
                        WORD wStrLen );

// Strings
// Creates a new String. Stores a CLIPVAR at _eval
extern void pascal _BYTESNEW( WORD wLenBytes );

// Locks a CLIPVAR String to access its bytes
// if need unlock returns TRUE
extern BOOL pascal _VSTRLOCK( PCLIPVAR vString );

// Gets the LPSTR of the String. It must be locked before with _VSTRLOCK
extern LPSTR pascal _VSTR( PCLIPVAR vString );

// UnLocks the String
extern void pascal _VSTRUNLOCK( PCLIPVAR vString );


extern WORD strlen( LPSTR szText );
extern void strcpy( LPBYTE lpTarget, LPBYTE lpSource );
extern LPBYTE strcat( LPBYTE lpTarget, LPBYTE lpSource );
LPSTR _StrScan( LPSTR szSearchAt, LPSTR szSearchFor );

// Arrays
// Retrieves the Len of an array
extern WORD pascal _VARRAYLEN( PCLIPVAR vArray );

// Creates and returns an Array in _eval
extern void pascal _ARRAYNEW( WORD wLen );


//

// Add a new element to an array
// _tos + 1  --> array
// _tos + 2  --> element
// _tos must be incremented
extern void pascal __AADD( void );

// Resizes an Array
// Parameters must be placed usign _tos
// pcount must be updated
extern void pascal ASIZE( void );

// Retrieves the Symbol of a String
extern PCLIPSYMBOL _Get_Sym( LPSTR szName );
extern PCLIPSYMBOL _Chk_Sym( LPSTR szName );

////////////////////////////////////////////////////////
// SEND Module - OOPS Management !
////////////////////////////////////////////////////////

// Creates a new Class
LONG _mdCreate( WORD wMethods, PCLIPSYMBOL pClassName );

// Adds a new Method to a ClassH
extern _mdAdd( LONG lClassHandle, PCLIPSYMBOL pMethodName, PCLIPFUNC pMethod );

// Gets the function address of a method
// Message info must be placed at ( _lbase + 0 )->pMsg
// Self must be placed at _lbase + 1
extern PCLIPFUNC _isendp( void );

// Retrieves the ClassH of an Object
extern LONG _VDict( PCLIPVAR );

// Changes the ClassH of an Object or Array
extern void _VSetDict( PCLIPVAR, LONG lClassHandle );

void _xSend( WORD wNumberOfParameters );     // The missing xSend function

#define INSTVAR(Name,pCode) _mdAdd(ulHandle,_get_sym(Name),pCode); _mdAdd(ulHandle,_get_sym("_"Name),pCode)
#define METHOD(Name,pCode) _mdAdd(ulHandle,_get_sym(Name),pCode)

/*********************************************************/


// executes a CodeBlock
// lbase + 1  --> CodeBlock
// lbase + 2  --> First parameter
// lbase + 3  --> ...
// _pcount    --> Number of parameters
// extern void _ixblock( void );   // NO DEBE USARSE SIN guardar y preparar
                                   // las variables de estado de plankton.

                                   // IT MAY NOT BE USED without saving and
                                   // preparing plakton state variables


// Memory Management
// Alloc wBytes (fixed É?)
extern LPBYTE _AllocF( WORD wBytes );


//////////////////////////////////////////////
// EVENT Module - Clipper internally is event-driven !!!
//////////////////////////////////////////////

typedef struct
{
   WORD wDymmy;
   WORD wMessage;
} EVENT;

typedef EVENT * PEVENT;

typedef WORD ( far * EVENTFUNCP ) ( PEVENT pEvent );

// Register a new Event Handler
extern WORD _evRegReceiverFunc( EVENTFUNCP pFunc, WORD wType );

extern void _evDeRegReceiver( WORD wHandlerOrder );

extern void _evSendId( WORD wMessage, WORD wHandlerOrder ); // 0xFFFF a Todos
extern WORD _evRegType( DWORD, DWORD, WORD );
extern void _evPostId( WORD evId, WORD wReceiverHandle );

extern void _Break_Cycle( void );

WORD _evModalRead( void );

WORD _gtModalRead( void );

extern void ( * _evKbdEntry )( PEVENT pEvent );


///////////////////////////////////////////////////////////
// BEEP Module - Terminal Driver Module
///////////////////////////////////////////////////////////

void _beep_( void );


///////////////////////////////////////////////////////////
// DYNC Module - Dynamic Linking Modules
///////////////////////////////////////////////////////////

typedef struct
{
   WORD AX, BX, CX, DX;
} DLM_PARAMS;

typedef DLM_PARAMS * PDLM_PARAMS;

typedef WORD ( far * DLMSERVER )( PDLM_PARAMS pParams, WORD wService );
typedef DLMSERVER * PDLMSERVER;

void _DynLoadModule( PWORD pHandle, LPSTR szModule );
WORD _DynGetNamedAddr( WORD wHandle, LPSTR szEntryModule, PDLMSERVER pServer );
LONG _DynGetOrdAddr( WORD wHandle, WORD wService );

// ERROR
void _ierror( WORD wError );  // generates an internal error message and quit.

/** YO ESTAS cuatro no las ponÂa **/
/** Not sure about these **/

void _CycleF( void );
WORD _osStackBase( void );
void _osAllocDefSeg( WORD*, WORD*,WORD* );
WORD _osAvail( void );   // NÚ de parrafos disponibles.

// TB Module
LPSTR _tbname( PCLIPVAR, WORD );      // Same as ProcName. 2Ú param no matter
                                      // 1 param is _ActInfo( WORD )


// LAS "DATE"
// "DATE" ones
                              // gets the date at _tos, returns
extern void _year( void );    // recibe fecha en _tos, retorna
                              // (CLV_LONG) aÄo en _tos
                              // (CLV_LONG) year at _tos
extern void _month( void );   // idem.
extern void _day( void );     // idem.

/*****

           CLIPPER MiYear()
           {
               // copiamos el VITEM Fecha en la primera posici×n libre 
               // del STACK.

               // we copy the date VITEM at the STACK first free position

               _bcopy( ( FARP ) ( ++tos ),
                       ( FARP ) _param( 1, DATE ),
                       sizeof( CLIPVAR ) );

               _year();

               // copiamos retorno en _eval y realineamos el STACK.
               // we copy the return at _eval and realign the STACK

               _bcopy( ( FARP ) _eval,
                       ( FARP ) ( _tos-- ),
                       sizeof( CLIPVAR ) );

           }
*****/

// TERM

void pascal QOUT( void );

#endif

// Nuevas para Windows
// New for Windows

WORD GetWndApp( void );      // Devuelve Handle Objeto ventana principal
                             // retrieves Main Object Window handle
