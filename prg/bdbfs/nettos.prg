/*
    Copyright (C) 2001  ITK
    Author  : Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

//‘«¥£ª  ãá®¢¥àè¥­áâ¢®¢ ­­ë¥ äã­ªæ¨¨ Netto.Lib

#include "common.ch"
#include "ftint86.ch"
#include "netto.ch"

#define E3h	227
static  gFnErr := ESUCCESS

/*  $DOC$
 *      GetInternetAddress
 *  $SYNTAX$
 *
 *      fn_inetAdd( [ <nConnectionNo> ] ) -> aAddress
 *
 *  $ARGUMENTS$
 *
 *      <nConnectionNo> is the Logical Connection Number that you are
 *      interested in.  If omitted, the requesting workstation's address
 *      is returned.
 *
 *  $RETURNS$
 *
 *      A 3 element array containing the following address information:
 *
 *            Position   Description            Data Type/Length
 *            ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 *               1       Network Number         Character/  8
 *               2       Physical Node Address  Character/ 12
 *               3       Socket Number          Character/  4
 *
 */

FUNC fn_inetAdd( nConnNo )
LOCAL	cReqBuffer, cRepBuffer := REPL( CHR( 0 ), 12 ),;
	aReply := { "", "", "" }

	/* fetch default connection number if not specified */

IF_NIL nConnNo IS fn_connNum()

	/* construct request packet */

cReqBuffer := CHR(19)+	/*CHR( ft_Hex2Dec( "13" ) )*/ ;
		CHR( nConnNo )

	/* call NetWare and build return array */

IF ( _fnReq( E3h, cReqBuffer, @cRepBuffer ) == 0 )
	aReply:={;
		PADL( fn_bin2hex( LEFT( cRepBuffer, 4 ) ),  8, '0' ),;
		PADL( fn_bin2hex( SUBSTR( cRepBuffer,  5,  6 ) ), 12, '0' ),;
		PADL( fn_bin2hex( SUBSTR( cRepBuffer, 11,  2 ) ),  4, '0' ) ;
		}
ENDIF

RETURN aReply


/*  $FUNCNAME$
 *      fn_staAddr()
 *  $ONELINER$
 *      GetStationAddress
 *  $SYNTAX$
 *
 *      fn_staAddr() -> cPhysicalNodeAddress
 *
 */

#translate RegHex(<xReg>) => LEFT(ft_Byt2Hex(CHR(<xReg>)),2)
#translate HiByte(<xReg>) => INT(<xReg> / 256)
#translate LoByte(<xReg>) => <xReg> % 256
**********
FUNC fn_staAddr()
LOCAL aRegs[ INT86_MAX_REGS ], cRetVal := "", nAx, nBx, nCx

*aRegs[ AX ] := ft_HEX2DEC( "EE00" )
aRegs[ AX ] := 60928	// Netware Service EEh

IF ft_int86( INT21, aRegs )          // fetch Conn No.
	IF (nAx:=aRegs[ AX ]) < 0 THEN nAx+=65536

	IF (nBx:=aRegs[ BX ]) < 0 THEN nBx+=65536

	IF (nCx:=aRegs[ CX ]) < 0 THEN nCx+=65536

	cRetVal := RegHex( HiByte( nCx ) ) +;
		   RegHex( LoByte( nCx ) ) +;
		   RegHex( HiByte( nBx ) ) +;
		   RegHex( LoByte( nBx ) ) +;
		   RegHex( HiByte( nAx ) ) +;
		   RegHex( LoByte( nAx ) )
ELSE
	_fnSetErr( EINT86 )
ENDIF

RETURN cRetVal
**********

#define    IDGET    1
#define    IDSET    2

/*  These are important, don't change the numbers:  */

#define    GET_DEFAULT    2
#define    GET_PREFERRED  1
#define    SET_PREFERRED  0
#define    GET_PRIMARY    5
#define    SET_PRIMARY    4


/*  $FUNCNAME$
 *      fn_connID()
 *  $ONELINER$
 *      GetConnectionID
 *  $SYNTAX$
 *      fn_connID() -> aConnectionTable
 */

#translate BinPeek( <i> ) => fn_bin2i( fn_PeekStr( nSeg, @nOff, <i> ) )
#translate BinHexPeek( <i>, <n> ) =>;
	   PADL( fn_bin2hex( fn_PeekStr( nSeg, @nOff, <i> ) ), <n>, '0' )

FUNC fn_connID()
LOCAL aRegs[ INT86_MAX_REGS ], aReply:={}, i, nSeg, nOff

aRegs[ AX ] := 61187	// Netware Service EFh, FUNC 03

IF ft_int86( INT21, aRegs )		// fetch address of ConnID table
	nSeg := aRegs[ ES ]		// store address
	nOff := aRegs[ SI ]

	FOR i := 1 TO 8			// fill sub-arrays with tables
	   AADD(aReply,{;
		BinPeek( 1 ),;
		BinPeek( 1 ),;
		BinHexPeek( 4,  8 ),;
		BinHexPeek( 6, 12 ),;
		BinHexPeek( 2,  4 ),;
		BinPeek( 2 ),;
		BinPeek( 6 ),;
		BinPeek( 1 ),;
		BinPeek( 1 ),;
		BinPeek( 1 ),;
		BinPeek( 2 ),;
		BinPeek( 5 ) ;
	  })
	NEXT
ELSE
	_fnSetErr( EINT86 )
ENDIF

RETURN aReply

/*  $FUNCNAME$
 *      fn_wrConnID()
 *  $ONELINER$
 *      WriteConnectionIDTable
 *  $SYNTAX$
 *
 *      fn_wrConnID( <aConnectTable> ) -> NIL
 *
 *  $ARGUMENTS$
 *
 *      <aConnectTable>: An array containing the new Connection ID Table.
 *
 *  $RETURNS$
 *
 *      Nothing.
 */

PROC fn_wrConnID( aTable )
LOCAL aRegs[ INT86_MAX_REGS ], nSeg, nOff, i, cTable, aEl

aRegs[ AX ] := 61187	// Netware Service EFh, FUNC 03

IF ft_int86( INT21, aRegs )		// fetch address of ConnID table

	nSeg := aRegs[ ES ]
	nOff := aRegs[ SI ]

      FOR i := 1 TO 8			// fill sub-arrays with tables

	aEl:=aTable[i]
	cTable := fn_i2bin(   aEl[  1 ], 1 )+; // SlotInUse
		  fn_i2bin(   aEl[  2 ], 1 )+; // ServerOrderNumber
		  fn_hex2bin( aEl[  3 ], 4 )+; // ServerInternalNetNo
		  fn_hex2bin( aEl[  4 ], 6 )+; // ServerPhysNodeAddr
		  fn_hex2bin( aEl[  5 ], 2 )+; // SocketNo
		  fn_i2bin(   aEl[  6 ], 2 )+; // ReceiveTimeOut
		  fn_i2bin(   aEl[  7 ], 6 )+; // RouterPhysNodeAddr
		  fn_i2bin(   aEl[  8 ], 1 )+; // PacketSeqNo
		  fn_i2bin(   aEl[  9 ], 1 )+; // ConnectionNo
		  fn_i2bin(   aEl[ 10 ], 1 )+; // ConnectionStatus
		  fn_i2bin(   aEl[ 11 ], 2 )+; // MaxTimeOut
		  fn_i2bin(   aEl[ 12 ], 5 )   // Reserved

	/* write the table to memory */

	fn_PokeStr( nSeg, @nOff, cTable )

      NEXT
ELSE
	_fnSetErr( EINT86 )
ENDIF

/*  $FUNCNAME$
 *      fn_defCID()
 *  $ONELINER$
 *      GetDefaultConnectionID
 *  $SYNTAX$
 *
 *      fn_defCID() -> nConnectionID
 *
 *  $ARGUMENTS$
 *
 *      None
 *
 *  $RETURNS$
 *
 *      The connection ID for the default file server, else -1 if error.
 *
 */

FUNC fn_defCID()
RETURN _fnconnid( IDGET, GET_DEFAULT )

/*
 *  $FUNCNAME$
 *      fn_pfConID()
 *  $ONELINER$
 *      GetPreferredConnectionID
 *  $SYNTAX$
 *
 *      fn_pfConID() -> nConnectionID
 *
 *  $ARGUMENTS$
 *
 *      None
 *
 *  $RETURNS$
 *
 *      The Connection ID of the preferred file server, or 0 if the
 *      preferred server is not set.
 *
 */

FUNC fn_pfConID()
RETURN _fnconnid( IDGET, GET_PREFERRED )


/*
 *  $FUNCNAME$
 *      fn_sPfCID()
 *  $ONELINER$
 *      SetPreferredConnectionID
 *  $SYNTAX$
 *
 *      fn_sPfCID( [ <nConnectionID> ] ) -> NIL
 *
 *  $ARGUMENTS$
 *
 *      <nConnectionID> is the Connection ID (1 - 8) for the server to be
 *      set as the default server to which request packets are sent.  If
 *      omitted, <nConnectionID> defaults to 0 (unspecified).
 *
 *  $RETURNS$
 *
 *      NIL
 *
 */

PROC fn_sPfCID( nConnID )
_fnconnid( IDSET, SET_PREFERRED, nConnID )


/*
 *  $FUNCNAME$
 *      fn_prConID()
 *  $ONELINER$
 *      GetPrimaryConnectionID
 *  $SYNTAX$
 *
 *      fn_prConID() -> nConnectionID
 *
 *  $ARGUMENTS$
 *
 *      None
 *
 *  $RETURNS$
 *
 *      The Connection ID of the primary file server (1 - 8), or 0 if the
 *      primary file server is not set.
 *
 */

FUNC fn_prConID()
RETURN _fnconnid( IDGET, GET_PRIMARY )


/*
 *  $FUNCNAME$
 *      fn_sPrCID()
 *  $ONELINER$
 *      SetPrimaryConnectionID
 *  $SYNTAX$
 *
 *      fn_sPrCID( [ <nConnectionID> ] ) -> NIL
 *
 *  $ARGUMENTS$
 *
 *      <nConnectionID> is the Connection ID (1 - 8) for the server to be
 *      set as the primary.
 *
 *  $RETURNS$
 *
 *      Nothing
 *
 */

PROC fn_sPrCID( nConnID )
_fnconnid( IDSET, SET_PRIMARY, nConnID )


/* internal FUNC used by the primary/default/preferred functions above */

STATIC FUNC _fnconnid( xOp, xFunc, nID )
LOCAL aRegs[ INT86_MAX_REGS ]

IF_NIL nID IS 0

aRegs[ AX ] := makehi( 240 ) + xFunc          // F0h

IF xOp == IDSET THEN aRegs[ DX ] := nID

IF !ft_int86( INT21, aRegs ) THEN _fnSetErr( EINT86 )

RETURN IF( xOp == IDGET, (  LowByte( aRegs[ AX ] ) ), nil )

/*
 *  $FUNCNAME$
 *      fn_connInf()
 *  $ONELINER$
 *      GetConnectionInformation
 *  $SYNTAX$
 *
 *      fn_connInf( [ <nConnectionNo> ] ) -> aConnectionInfo
 *
 *  $ARGUMENTS$
 *
 *      <nConnectionNo> is the connection number that you are interested in.
 *      If omitted, it defaults to the current workstation.
 *
 *  $RETURNS$
 *
 *      An array containing connection information according to the following
 *      table
 *
 *              Position       Description         Data Type
 *              ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 *                 1           Object ID           Numeric
 *                 2           Object Type         Numeric
 *                 3           Object Name         Character
 *                 4           Login Date          Date
 *                 5           Login Day           Numeric (0-6)
 *                 6           Login Time          Character
 *
 *      For a list of Object Types, see the "Information" section
 *      of this Norton Guide.
 *
 *      If the returned Object ID is 0, there is no object logged into the
 *      requested connection number.  The Login Time is represented in 24
 *      hour format, i.e. HH:MM:SS.  The Login Date is represented as a
 *      Clipper date.
 *
 */

FUNC fn_connInf( nConnNo )
LOCAL	cReqBuffer, cRepBuffer := REPL( CHR( 0 ), 65 ), aDT

/* fetch default connection number if not specified */
IF_NIL nConnNo IS fn_connNum()

/* construct request packet */
*cReqBuffer := CHR( ft_Hex2Dec( "16" ) ) + CHR( nConnNo )

cReqBuffer := CHR(22) + CHR( nConnNo )

/* call NetWare */
_fnReq( E3h, cReqBuffer, @cRepBuffer )

aDT := _fnStr2dt( subs( cRepBuffer, 55, 6 ) )

RETURN {;
	HILO2L( LEFT( cRepBuffer, 4 ) ),;
	HILO2W( SUBSTR( cRepBuffer, 5,  2 ) ),;
	fn_NoNull( SUBSTR( cRepBuffer, 7, 48 ) ),;
	aDT[1],;
	ASC( SUBSTR( cRepBuffer, 61, 1 ) ),;
	aDT[2] ;
}


/*
 *  $FUNCNAME$
 *      fn_connNum()
 *  $ONELINER$
 *      GetConnectionNumber
 *  $SYNTAX$
 *
 *      fn_connNum() -> nConnectionNo
 *
 *  $ARGUMENTS$
 *
 *      None
 *
 *  $RETURNS$
 *
 *      The current workstation's Logical Connection Number.
 *
 */

FUNC fn_connNum()
LOCAL aRegs[ INT86_MAX_REGS ], nRetVal := 0

aRegs[ AX ] := 56320	// Netware Service DCh

IF ft_int86( INT21, aRegs )		// fetch Conn No.
	IF (nRetVal:=aRegs[ AX ]) < 0 THEN nRetVal+=65536
	nRetVal :=  nRetVal % 256
ELSE
	_fnSetErr( EINT86 )
ENDIF

RETURN nRetVal

/*
 *  $FUNCNAME$
 *      fn_objCNum()
 *  $ONELINER$
 *      GetObjectConnectionNumbers
 *  $SYNTAX$
 *
 *      fn_objCNum( <cObjectName> [, <nObjectType> ] ) -> aConnectionNumbers
 *
 *  $ARGUMENTS$
 *
 *      <cObjectName> is the name of the Object that you are interested in.
 *      It can be from 1 to 47 characters in length.
 *
 *      <nObjectType> is the Netware object type.  For a list of object types
 *      refer to the "Information" section in this Norton Guide, or NETTO.CH.
 *      If omitted, <nObjectType> defaults to OT_USER.
 *
 *  $RETURNS$
 *
 *      An array containing a list of each logical connection number for the
 *      requested object.  If the object is not logged into the default
 *      file server, an empty array is returned.
 *
 */

FUNC fn_objCNum( cObjectName, nObjectType )
LOCAL cReqBuffer, cRepBuffer := REPL( CHR( 0 ), 101 ), aReply := {}, i

IF_NIL cObjectName IS ""
IF_NIL nObjectType IS OT_USER

*cReqBuffer := CHR( FT_HEX2DEC( "15" ) )	+;
cReqBuffer := CHR(21)+;
		W2HILO( nObjectType )+;
		fn_nameL( UPPER( cObjectName ) )

_fnReq( E3h, cReqBuffer, @cRepBuffer )

/* build return array */
FOR i:=1 TO ASC( SUBSTR( cRepBuffer, 1, 1 ) )
	AADD(aReply, ASC( SUBSTR( cRepBuffer, i+1, 1 ) ))
NEXT

RETURN aReply

/*
 *  $FUNCNAME$
 *     FN_Devtype()
 *  $ONELINER$
 *     Get the Device type for any drive number (Network, Local, or Subst)
 *  $SYNTAX$
 *
 *     fn_Devtype( <nDrive> ) -> <nDevtype>
 *
 *  $ARGUMENTS$
 *
 *     <nDrive> Disk drive number (1 for A, etc.) or 0 for default drive
 *
 *  $RETURNS$
 *
 *     <nDevtype> returns 1 for Local, 2 for Remote (Network), 3 for Subst,
 *                0 for Invalid drive, -1 for Error.
 *
 */

FUNC FN_DEVTYPE(nDrive)
LOCAL   aRegs[ INT86_MAX_REGS ], nRetval:=1

IF_NIL nDrive IS 0	// Default to current drive.

*aRegs[ AX ] := ft_hex2dec("4409")   // Get device type
aRegs[ AX ] := 17417
aRegs[ BX ] := nDrive

IF ft_int86( INT21, aRegs )
	IF aRegs[ DX ]==0			// Invalid Drive
		nRetval:=0
	ELSEIF FT_ISBiton(aRegs[ DX ],12)	// Remote Drive
		nRetval:=2
	ELSEIF FT_ISBiton(aRegs[ DX ],15)	// Subst drive
		nRetval:=3
	ENDIF
ELSE
	nRetval:=-1
ENDIF
RETURN nRetval


/*
 *  $FUNCNAME$
 *      fn_Bin2I()
 *  $ONELINER$
 *      Convert a binary string to numeric
 *  $SYNTAX$
 *
 *      fn_Bin2I( <cBinStr> ) -> nValue
 *
 *  $ARGUMENTS$
 *
 *      <cBinStr> is a string of bytes representing a number.
 *
 *  $RETURNS$
 *
 *      The decimal value of <cBinStr>.
 *
 */

FUNC fn_Bin2I( cStr )
LOCAL i, nRetVal := 0
FOR i := 1 TO LEN( cStr )
	nRetVal += ASC( SUBST( cStr, i, 1 ) ) * 256^( LEN( cStr ) - i )
NEXT
RETURN INT( nRetVal )

/*
 *  $FUNCNAME$
 *      fn_I2Bin()
 *  $ONELINER$
 *      Convert an integer to binary string
 *  $SYNTAX$
 *
 *      fn_I2Bin( <nValue>, [ <nLen> ] ) -> cBinStr
 *
 *  $ARGUMENTS$
 *
 *      <nValue> is the integer to convert.  Only positive integers may
 *      be converted.
 *
 *      <nLen> is the desired resultant string length.  If omitted, it
 *      defaults to the length required to represent <nValue>.  If <nLen>
 *      is larger than the length required to represent <nValue>, cBinStr
 *      is left-padded with CHR(0)'s to fill it out to the desired length.
 *
 *  $RETURNS$
 *
 *      A binary string representing the value passed.
 *
 */

FUNC fn_I2Bin( nValue, nLen )
LOCAL cStr := "", i, nTemp

IF nLen == NIL			// determine minimum str. len
	nLen := 0
	WHILE ( nValue % (256^nLen++) ) < nValue  // each byte represents 256^n
	END
	--nLen
ENDIF

FOR i := 1 TO nLen		// build string by subtracting
	nTemp   := INT( nValue / 256^( nLen - i ) )  // (byte)*(256^n) for
	cStr    += CHR( nTemp )			     // nLen bytes
	nValue  -= nTemp * 256^( nLen - i )
NEXT

RETURN cStr


/*
 *  $FUNCNAME$
 *     FN_ERROR()
 *  $ONELINER$
 *     Return current error status for a Netware Library function
 *  $SYNTAX$
 *
 *     fn_error() -> nError
 *
 *  $ARGUMENTS$
 *
 *     None
 *
 *  $RETURNS$
 *
 *     <nError>, a numeric error code.  Details on the error codes can
 *     be found...
 *
 */


FUNC fn_Error()
RETURN gFnErr	//static


/*
 *  $FUNCNAME$
 *     _fnSetErr()
 *  $ONELINER$
 *     Set the current Netware Library error status
 *  $SYNTAX$
 *
 *     _fnSetErr( nErrCode ) -> nOldError
 *
 *  $ARGUMENTS$
 *
 *    <nErrCode>
 *
 *  $RETURNS$
 *
 *    <nOldError>
 *
 */


FUNC _fnSetErr( nCode )
LOCAL xOld := gFnErr
gFnErr     := nCode
RETURN xOld


/*
 *  $FUNCNAME$
 *      fn_Bin2Hex()
 *  $ONELINER$
 *      Convert a binary string to hexidecimal
 *  $SYNTAX$
 *
 *      fn_Bin2I( <cBinStr> ) -> cHexStr
 *
 *  $ARGUMENTS$
 *
 *      <cBinStr> is a string of bytes representing a number.
 *
 *  $RETURNS$
 *
 *      A string containing the hexdecimal value of <cBinStr>.
 *
 */

FUNC fn_Bin2Hex( cBinStr )
LOCAL i, cHexStr := ''

FOR i := 1 TO LEN( cBinStr )
	cHexStr += LEFT( ft_Byt2Hex( SUBST( cBinStr, i, 1 ) ), 2 )
NEXT
RETURN cHexStr

/*
 *  $FUNCNAME$
 *      fn_Hex2Bin()
 *  $ONELINER$
 *      Convert a hexidecimal string to to binary
 *  $SYNTAX$
 *
 *      fn_Hex2Bin( <cHexStr> ) -> cBinStr
 *
 *  $ARGUMENTS$
 *
 *      <cHexStr> is a string containing hexidecimal characters.
 *
 *  $RETURNS$
 *
 *      A binary string representing the value passed.
 *
 */

FUNC fn_Hex2Bin( cHexStr )
LOCAL cBinStr := "", i, nDecVal, cTempl:='123456789ABCDEF'

cHexStr := UPPER( cHexStr )

FOR i := LEN( cHexStr ) TO 1 STEP -1

	nDecVal := AT( SUBSTR( cHexStr, i--, 1 ), cTempl )
	IF i > 0 THEN;
		nDecVal += AT( SUBSTR( cHexStr, i, 1 ), cTempl ) * 16

	cBinStr := CHR( nDecVal ) + cBinStr

NEXT

RETURN cBinStr

/*
 *  $FUNCNAME$
 *      fn_PeekStr()
 *  $ONELINER$
 *      Read a string of bytes from memory
 *  $SYNTAX$
 *
 *      fn_PeekStr( <nSegment>, <nOffset>, <nLength> ) -> cBinStr
 *
 *  $ARGUMENTS$
 *
 *      <nSegment> is the memory segment to read.
 *
 *      <nOffset> is the starting offset from <nSegment> to read from.
 *
 *      <nLength> is the number of bytes to read.
 *
 *  $RETURNS$
 *
 *      A string containing the characters found at <nSegment>:<nOffset>.
 *
 */

FUNC fn_PeekStr( nSeg, nOff, nLen )
LOCAL cRetVal := "", i
FOR i := 1 TO nLen
	cRetVal += CHR( ft_Peek( nSeg, nOff++ ) )
NEXT
RETURN cRetVal

/*
 *  $FUNCNAME$
 *      fn_PokeStr()
 *  $ONELINER$
 *      Write a string of bytes to memory
 *  $SYNTAX$
 *
 *      fn_PokeStr( <nSegment>, <nOffset>, <cBinStr> ) -> NIL
 *
 *  $ARGUMENTS$
 *
 *      <nSegment> is the memory segment to write to.
 *
 *      <nOffset> is the starting offset from <nSegment> to write at.
 *
 *      <cBinStr> is a string of bytes to write.
 *
 *  $RETURNS$
 *
 *      Nothing.
 *
 */

PROC fn_PokeStr( nSeg, nOff, cStr )
LOCAL i
FOR i := 1 TO LEN( cStr )
	ft_Poke( nSeg, nOff++, ASC( SUBST( cStr, i, 1 ) ) )
NEXT

/*
 *  $FUNCNAME$
 *      fn_FSName()
 *  $ONELINER$
 *      GetFileServerNameTable
 *  $SYNTAX$
 *
 *      fn_FSName() -> aNameTable
 *
 *  $ARGUMENTS$
 *
 *      None
 *
 *  $RETURNS$
 *
 *      An 8 element array containing the names of each file server that
 *      the calling workstation is currently attached to.
 *
 */

FUNC fn_FSName()
LOCAL aRegs[ INT86_MAX_REGS ], cReply := '', aReply:={}, nSeg, nOff, i

aRegs[ AX ] := 61188	// Netware Service EFh, FUNC 04

IF ft_int86( INT21, aRegs )	// fetch address of FSName table
	nSeg := aRegs[ ES ]
	nOff := aRegs[ SI ]
// read a table
	FOR i := 1 TO 8		// fill array with Server Names
		AADD(aReply, fn_NoNull( fn_PeekStr( nSeg, @nOff, 48 ) ) )
	NEXT
ELSE
	_fnSetErr( EINT86 )
ENDIF

RETURN aReply

/*
 *  $FUNCNAME$
 *      fn_wrFSName()
 *  $ONELINER$
 *      WriteFileServerNameTable
 *  $SYNTAX$
 *
 *      fn_wrFSName( <aNameTable> ) -> NIL
 *
 *  $ARGUMENTS$
 *
 *      <aNameTable> is an 8 element array of file server names,
 *      corresponding to entries in the Connection ID table.
 *
 *      File server names may be up to 47 characters in length.
 *
 *  $RETURNS$
 *
 *      Nothing
 *
 */

PROC fn_wrFSName( aTable )
LOCAL aRegs[ INT86_MAX_REGS ], nSeg, nOff

*aRegs[ AX ] := ft_HEX2DEC( "EF04" )   // Netware Service EFh, FUNC 04
aRegs[ AX ] := 61188

IF ft_int86( INT21, aRegs )	      // fetch address of FSName table
	nSeg := aRegs[ ES ]
	nOff := aRegs[ SI ]
// write Server Names to memory
	AEVAL( aTable, {|_1| fn_PokeStr( nSeg, @nOff, PADR( _1, 48, CHR(0) ))})
ELSE
	_fnSetErr( EINT86 )
ENDIF

/*
 *  $FUNCNAME$
 *      FN_GETFSI()
 *  $ONELINER$
 *      Get default File Server Information
 *  $SYNTAX$
 *
 *      fn_GetFSI() -> aFS_Info
 *
 *  $ARGUMENTS$
 *
 *      None
 *
 *  $RETURNS$
 *
 *      An array of 17 elements containing the information about
 *      the default File Server.
 *
 *        aFS_Info[1]   File Server Name.
 *        aFS_Info[2]   Netware Major version number.
 *        aFS_Info[3]   Netware Minor version number.
 *        aFS_Info[4]   Max connections supported by server.
 *        aFS_Info[5]   connections currently in use.
 *        aFS_Info[6]   Max connected volumes.
 *        aFS_Info[7]   OS Revision Number.
 *        aFS_Info[8]   SFT Level.
 *        aFS_Info[9]   TTS Level.
 *        aFS_Info[10]  Peak connections used.
 *        aFS_Info[11]  Accounting Version.
 *        aFS_Info[12]  VAP Version.
 *        aFS_Info[13]  Queuing Version.
 *        aFS_Info[14]  Print Server Version.
 *        aFS_Info[15]  Virtual Console Version.
 *        aFS_Info[16]  Security Restrictions Level.
 *        aFS_Info[17]  Internetwork Bridge Version.
 *
 *      Returns an empty array if not logged in.
 *
 */

FUNC fn_GetFSI()
LOCAL cRep := space(130), aReply

aReply := {}

IF _fnReq( E3h, CHR(17), @cRep ) == ESUCCESS
	aReply:={;
		LEFT( cRep,48),;
		ASC(substr( cRep,49,1)),;
		ASC(substr( cRep,50,1)),;
		HILO2W(substr( cRep,51,2)),;
		HILO2W(substr( cRep,53,2)),;
		HILO2W(substr( cRep,55,2)),;
		ASC(substr( cRep,57,1)),;
		ASC(substr( cRep,58,1)),;
		ASC(substr( cRep,59,1)),;
		HILO2W(substr( cRep,60,2)),;
		ASC(substr( cRep,62,1)),;
		ASC(substr( cRep,63,1)),;
		ASC(substr( cRep,64,1)),;
		ASC(substr( cRep,65,1)),;
		ASC(substr( cRep,66,1)),;
		ASC(substr( cRep,67,1)),;
		ASC(substr( cRep,68,1)) ;
		}
ENDIF

RETURN aReply

/*
 *  $FUNCNAME$
 *     Fn_GetSN()
 *  $ONELINER$
 *     Get file server name
 *  $SYNTAX$
 *
 *      Fn_GetSN( <nConnId> ) -> <cServerName>
 *
 *  $ARGUMENTS$
 *
 *      <nConnId> - Is the connection id of the server.
 *      Defaults to the value of fn_defCID() (default connection ID)
 *
 *  $RETURNS$
 *
 *     <cServerName> - Is the name of the server associated with
 *                     <nConnId>.
 *
 */


FUNC Fn_GetSN( nConnId )
IF_NIL nConnID IS fn_defcid()
RETURN Fn_FSName()[ nConnId ]

/*
 *  $FUNCNAME$
 *     fn_NameL()
 *  $ONELINER$
 *     General purpose string to length+string packet function
 *  $SYNTAX$
 *
 *     fn_NameL( cName, nRequiredLength)  => cReturn
 *
 *  $ARGUMENTS$
 *
 *     <cName>	 - the character string to be used (shouldn't be longer
 *                  than 255 characters
 *     <nLength> -  if specified, the String is padded with NULLs
 *		            to this length
 *
 *  $RETURNS$
 *
 *     <cReturn> - a character string with a one byte word at the beginning
 *	  which indicates the string length, including a null terminator
 *	  which is added if it does not exist.
 *
 */

FUNC fn_nameL( cName, nLen )

/*
 *  If no length was specified, check for a terminating null
 *  and add room for one if not found
 *
 */

IF_NIL nLen IS len( cName ) + IF( SUBSTR( cName, -1 ) == chr(0), 0, 1 )

RETURN chr( nLen ) + padr( cName, nLen - 1, chr(0) ) + chr(0)


/*
 *  $FUNCNAME$
 *      FN_NETVER()
 *  $ONELINER$
 *      Return the Netware version as a numeric
 *  $SYNTAX$
 *
 *      fn_NetVer() -> nVersion
 *
 *  $ARGUMENTS$
 *
 *      None
 *
 *  $RETURNS$
 *
 *      A number contain the version number of Netware. The integer
 *      portion is the major number and the decimal is the minor
 *      version number.
 *
 *      Returns 0.0 if not logged in.
 *
 */

FUNC fn_netVer()
LOCAL nVersion := 0.0, arr_ := fn_getFsi()

IF !empty(arr_) THEN  nVersion := arr_[2]+(arr_[3]*0.01)
RETURN nVersion

/*
 *  $FUNCNAME$
 *      FN_WHOAMI()
 *  $ONELINER$
 *      Return a user name
 *  $SYNTAX$
 *
 *      fn_whoami( [<nConnection>] ) -> cUserName
 *
 *  $ARGUMENTS$
 *
 *      <nConnection>.  Optional, defaults to current connection
 *      number.  If supplied, fn_whoami() will return the user
 *      logged in at logical connection number <nConnection>.
 *      <nConnection> is numeric and can be anything from 1 to
 *      250.
 *
 *  $RETURNS$
 *
 *      The name of the user, as a character string.  It will be
 *      all uppercase and will be no longer than 48 characters.
 *
 */

FUNC fn_whoami( nConn )
IF_NIL nConn IS fn_connNum()
RETURN fn_conninf( nConn )[3]

/*
 *  $ONELINER$
 *     Strip a string of trailing nulls
 *  $SYNTAX$
 *
 *     fn_noNull( cStr ) -> cNewStr
 *
 *  $ARGUMENTS$
 *
 *     <cStr> - The string to be stripped of nulls
 *
 *  $RETURNS$
 *
 *     <cNewStr>
 *
 */
FUNC fn_noNull( cVar )
Parce(cVar,chr(0),@cVar)
RETURN cVar

**********
//NWDATE.PRG
**********
FUNC _fndt2Str( dDate, cTime )

RETURN IF( EMPTY(dDate) .OR. (cTime==NIL) .OR. (cTime == "99:99:99"),;
	   REPL( _EMP, 6 ),	/* FFFFFFFFFFFFh*/;
	   _FndTOnc(dDate) + _FntTOnc(cTime))
**********
FUNC _fnStr2dt( cStr )
LOCAL dDate, cTime

IF (cStr==NIL) .OR. (cStr == REPL( _EMP, 6 ))	// FFFFFFFFFFFFh
	dDate := ctod("")
	cTime := "99:99:99"
ELSE
	dDate := _fnnctod( SUBSTR( cStr, 1, 3 ) )
	cTime := _fnnctot( SUBSTR( cStr, 4 ) )
ENDIF

RETURN { dDate, cTime }
**********
FUNC _fnnctod(cDate)
* Convert Novell 3 byte date string to a Clipper date

LOCAL dDate, cDateFormat := SET(_SET_DATEFORMAT)

SET(_SET_DATEFORMAT, "yy/mm/dd")

dDate  := ctod( str( ASC( substr( cDate, 1, 1 ) ), 2 ) + "/" + ;
		str( ASC( substr( cDate, 2, 1 ) ), 2 ) + "/" + ;
		str( ASC( substr( cDate, 3 ) ), 2 ) )

SET(_SET_DATEFORMAT, cDateFormat)
RETURN dDate
**********
FUNC _fndtonc(dDate)
* Convert Clipper date into the Novell 3-byte date string

RETURN	CHR( year  (dDate) % 100 ) + ;
	CHR( month (dDate)       ) + ;
	CHR( day   (dDate)       )

**********
FUNC _fnttonc(cTime)
* Convert a Clipper time to the Novell 3 byte time string

RETURN CHR( val( subs( cTime, 1, 2 ) ) ) + ;
       CHR( val( subs( cTime, 4, 2 ) ) ) + ;
       CHR( val( subs( cTime, 7 ) ) )

**********
FUNC _fnnctot(cNTime)
* Convert a Novell 3 byte time string to a Clipper time
#translate _fnstrz( <n> ) => padl( ltrim( str( <n> ) ), 2, "0" )

RETURN _fnstrz( ASC( substr( cNTime, 1, 1 ) ) ) + ":" + ;
       _fnstrz( ASC( substr( cNTime, 2, 1 ) ) ) + ":" + ;
       _fnstrz( ASC( substr( cNTime, 3, 1 ) ) )
**********
FUNC _fnintod(nYear, nMonth, nDay)
* Convert Year, Month and Day values to a date
LOCAL dDate, cDateFormat := SET(_SET_DATEFORMAT)

SET(_SET_DATEFORMAT, "yy/mm/dd")

dDate := ctod( str( nYear,  2 ) + "/" + ;
	 str( nMonth, 2 )	+ "/" + ;
	 str( nDay,   2 ) )

SET(_SET_DATEFORMAT, cDateFormat)

RETURN dDate
**********
FUNC _fndtoin(dDate)
* Convert date to Year, Month and Day values.

RETURN { year(dDate) % 100, month(dDate), day(dDate)  }

**********
FUNC _fndtoic(dDate)
* Convert Clipper Date to an international date
LOCAL cDate:=DTOS(dDate)

RETURN SUBSTR(cDate,3,2)+'/'+SUBSTR(cDate,5,2)+'/'+SUBSTR(cDate,7)
**********
FUNC _fnictod(cDate)
* Convert an international date in the form "yy/mm/dd" to a Clipper date
LOCAL dDate, cDateFormat := SET(_SET_DATEFORMAT)

SET(_SET_DATEFORMAT, "yy/mm/dd")
dDate := ctod(cDate)
SET(_SET_DATEFORMAT, cDateFormat)

RETURN dDate
**********
