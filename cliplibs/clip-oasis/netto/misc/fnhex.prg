/*
 * File......: FNHEX.PRG
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
 * Revision 1.1  2002/03/09 13:58:12  clip
 * uri: start :) "netto" library
 *
 *
 */

#include "netto.ch"


/*  $DOC$
 *  $FUNCNAME$
 *      fn_Bin2Hex()
 *  $CATEGORY$
 *      Miscellaneous
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
 *  $DESCRIPTION$
 *
 *      Internally, all information is stored as a series of bytes.  When
 *      performing a direct read from memory, a character string will be
 *      returned.  Use this function to convert that string to its 
 *      hexidecimal numeric equivalent.
 *
 *  $EXAMPLES$
 *
 *      /* convert a string containing CHR(0)+CHR(0)+CHR(222)+CHR(175) */
 *
 *      ? fn_Bin2Hex( "  ޯ" )							// "    DEAF"
 *
 *  $SEEALSO$
 *      fn_Hex2Bin() fn_Bin2I() fn_PeekStr() fn_PokeStr()
 *  $INCLUDE$
 *
 *  $END$
 */

FUNCTION fn_Bin2Hex( cBinStr )
	LOCAL i, cHexStr := ''

	FOR i := 1 TO LEN( cBinStr )
		cHexStr += LEFT( ft_Byt2Hex( SUBST( cBinStr, i, 1 ) ), 2 )
	NEXT
RETURN cHexStr

/*  $DOC$
 *  $FUNCNAME$
 *      fn_Hex2Bin()
 *  $CATEGORY$
 *      Miscellaneous
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
 *  $DESCRIPTION$
 *
 *      This function converts a hexidecimal value to it binary equivalent,
 *      and is useful for doing a direct memory translation.
 *
 *  $EXAMPLES$
 *
 *      ? fn_Hex2Bin( "DEAF" )						// "ޯ"  
 *
 *      ? fn_Hex2Bin( "10" )							// ""  
 *
 *  $SEEALSO$
 *      fn_Bin2Hex() fn_PeekStr() fn_PokeStr()
 *  $INCLUDE$
 *
 *  $END$
 */

FUNCTION fn_Hex2Bin( cHexStr )
	LOCAL cBinStr := "", i, nDecVal
	cHexStr := UPPER( cHexStr )

	FOR i := LEN( cHexStr ) TO 1 STEP -1

		nDecVal := AT( SUBSTR( cHexStr, i--, 1 ), '123456789ABCDEF' )
		IF i > 0
			nDecVal += AT( SUBSTR( cHexStr, i, 1 ), '123456789ABCDEF' ) * 16
		ENDIF

		cBinStr := CHR( nDecVal ) + cBinStr

	NEXT

RETURN( cBinStr )


