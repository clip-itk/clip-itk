/*
 * File......: FNBIT.PRG
 * Author....: Ted Means
 * CIS ID....:
 * Date......: $Date$
 * Revision..: $Revision$
 * Log file..: $Logfile$
 * 
 * This is an original work by Ted Means and is placed in the
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


/*  $DOC$
 *  $FUNCNAME$
 *     FN_ISBIT()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *     Determine if a specified bit is set
 *  $SYNTAX$
 *
 *     fn_isbit( <nNum>, <nBit> ) -> lSet
 *
 *  $ARGUMENTS$
 *
 *     <nNum> is the number to test, <nBit> is the
 *     bit to test (0-15).
 *
 *  $RETURNS$
 *
 *     Returns logical .t. if the bit is set, .f. if 
 *     it isn't.
 *
 *  $DESCRIPTION$
 *
 *     Determines if a specified bit in a number is set.
 *
 *  $EXAMPLES$
 *
 *     ? fn_isbit( 13, 0 ) // .t. (bit 0 is set)
 *
 *  $SEEALSO$
 *
 *  $INCLUDE$
 *
 *  $END$
 */

function fn_IsBit( n, b )
   return ( fn_and( n, 2 ^ b ) != 0 )

/*  $DOC$
 *  $FUNCNAME$
 *     FN_SETBIT()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *     Set a bit in a number
 *  $SYNTAX$
 *
 *     fn_setbit( <nNum>, <nBit> ) -> nResult
 *
 *  $ARGUMENTS$
 *
 *     <nNum> is the number that needs a bit set; and
 *     <nBit> is the bit to set (0-15).
 *
 *  $RETURNS$
 *
 *     <nResult>, a numeric
 *
 *  $DESCRIPTION$
 *
 *      Sets a bit in a number.
 *
 *  $EXAMPLES$
 *
 *      ? fn_setbit( 12, 0 )  // 13 (sets bit 0)
 *
 *  $SEEALSO$
 *
 *  $INCLUDE$
 *
 *  $END$
 */


function fn_setBit( n, b )
   return fn_or( n, 2 ^ b )

/*  $DOC$
 *  $FUNCNAME$
 *     FN_TOGBIT()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *     Toggle a bit in a number
 *  $SYNTAX$
 *
 *     fn_togbit( <nNum>, <nBit> ) -> nResult
 *
 *  $ARGUMENTS$
 *
 *     <nNum> is the number that needs a bit toggled.
 *     <nBit> is the bit to toggle.
 *
 *  $RETURNS$
 *
 *     <nResult>, a numeric
 *
 *  $DESCRIPTION$
 *
 *     Toggles bit <nBit> in number <nNum>.
 *
 *  $EXAMPLES$
 *
 *     ? fn_togbit( 9, 0 ) // 8 (toggles bit 0 )
 *
 *  $SEEALSO$
 *
 *  $INCLUDE$
 *
 *  $END$
 */


function fn_togbit( n, b )
   return fn_xor( n, 2 ^ b)

/*  $DOC$
 *  $FUNCNAME$
 *     FN_CLRBIT()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *     Clear a bit in a number
 *  $SYNTAX$
 *
 *      fn_clrbit( <nNum>, <nBit> ) -> nResult
 *
 *  $ARGUMENTS$
 *
 *      <nNum> is a number that needs a bit cleared;
 *      <nBit> is the bit to clear.
 *
 *  $RETURNS$
 *
 *       <nResult>, a numeric
 *
 *  $DESCRIPTION$
 *
 *        Clears a specified bit in a number.
 *
 *  $EXAMPLES$
 *
 *        fn_clrbit( 9, 0 ) // 8 (clears bit 0)
 *
 *  $SEEALSO$
 *
 *  $INCLUDE$
 *
 *  $END$
 */


function fn_clrbit( n, b )
   return fn_and( n, fn_not( 2 ^ b ) )

