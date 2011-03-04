/*
 * File......: FNBIN2I.PRG
 * Author....: Steve Larsen
 * CIS ID....: 76370,1532
 * Date......: $Date$
 * Revision..: $Revision$
 * Log file..: $Logfile$
 *
 * This is an original work by Steve Larsen and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 * $Log$
 * Revision 1.1  2006/06/22 20:12:13  itk
 * uri: init sf.net
 *
 * Revision 1.1  2002/03/09 13:58:11  clip
 * uri: start :) "netto" library
 *
 *
 */

#include "netto.ch"


/*  $DOC$
 *  $FUNCNAME$
 *      fn_Bin2I()
 *  $CATEGORY$
 *      Miscellaneous
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
 *  $DESCRIPTION$
 *
 *      Internally, all information is stored as a series of bytes.  When
 *      performing a direct read from memory, a character string will be
 *      returned.  Use this function to convert that string to its Clipper
 *      numeric equivalent.
 *
 *      This function only returns integer values.
 *
 *  $EXAMPLES$
 *
 *      /* convert a string containing CHR(0)+CHR(0)+CHR(222)+CHR(175) */
 *
 *      ? fn_Bin2I( "  ޯ" )							// 57007
 *
 *  $SEEALSO$
 *      fn_I2Bin() fn_PeekStr() fn_PokeStr()
 *  $INCLUDE$
 *
 *  $END$
 */

#include "netto.ch"

FUNCTION fn_Bin2I( cStr )
	LOCAL i, nRetVal := 0
	FOR i := 1 TO LEN( cStr )
		nRetVal += BYTE2I( SUBST( cStr, i, 1 ) ) * 256^( LEN( cStr ) - i )
	NEXT
RETURN INT( nRetVal )

/*  $DOC$
 *  $FUNCNAME$
 *      fn_I2Bin()
 *  $CATEGORY$
 *      Miscellaneous
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
 *  $DESCRIPTION$
 *
 *      This function converts a decimal value to it binary equivalent,
 *      and is useful for doing a direct memory translation.
 *
 *  $EXAMPLES$
 *
 *      ? fn_I2Bin( 57007 )							// "ޯ"  
 *
 *      ? fn_I2Bin( 57007, 4 )						// "  ޯ"  
 *
 *  $SEEALSO$
 *      fn_Bin2I() fn_PeekStr() fn_PokeStr()
 *  $INCLUDE$
 *
 *  $END$
 */

FUNCTION fn_I2Bin( nValue, nLen )
	LOCAL cStr := "", nResult := 0, i, nTemp

	IF nLen == NIL                           		// determine minimum str. len
		nLen := 0
		WHILE ( nValue % (256^nLen++) ) < nValue  // each byte represents 256^n
		END
		--nLen
	ENDIF

	FOR i := 1 TO nLen                          // build string by subtracting
		nTemp   := INT( nValue / 256^( nLen - i ) )  // (byte)*(256^n) for 
		cStr    += CHR( nTemp )								// nLen bytes
		nValue  -= nTemp * 256^( nLen - i )
	NEXT

RETURN( cStr )

