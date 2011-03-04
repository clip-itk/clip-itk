/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

//Slightly enhanced Netto.Lib functions

#include "common.ch"
*#include "netto.ch"


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
	nRetVal += ASC( SUBSTR( cStr, i, 1 ) ) * 256^( LEN( cStr ) - i )
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
