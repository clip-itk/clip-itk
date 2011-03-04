/*
 * File......: FNPEEK.PRG
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
 *      fn_PeekStr()
 *  $CATEGORY$
 *      Miscellaneous
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
 *  $DESCRIPTION$
 *
 *      Use this function to perform memory reads of a contiguous block of
 *      memory.  The string returned contains one character for each byte
 *      of memory read.
 *
 *      If you plan to perform consecutive memory reads from memory, for
 *      instance in filling an array, pass <nOffset> by reference to keep
 *      it updated in the calling routine.
 *
 *  $EXAMPLES$
 *
 *      /* fill an array with 8-bytes taken from a block in memory */
 *
 *      ARRAY( aMemValues, 10 )                 // create a Clipper array
 *
 *		  nSeg := <...>									// initialize pointers to
 *      nOff := <...>                           //  desired memory location
 *
 *      AEVAL( aMemValues, {|e| e = fn_PeekStr( nSeg, @nOff, 8 ) }
 *
 *  $SEEALSO$
 *      fn_PokeStr()
 *  $INCLUDE$
 *
 *  $END$
 */

FUNCTION fn_PeekStr( nSeg, nOff, nLen )
	LOCAL cRetVal := "", i
	FOR i := 1 TO nLen
		cRetVal += I2BYTE( ft_Peek( nSeg, nOff++ ) )
	NEXT
RETURN cRetVal

/*  $DOC$
 *  $FUNCNAME$
 *      fn_PokeStr()
 *  $CATEGORY$
 *      Miscellaneous
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
 *  $DESCRIPTION$
 *
 *      Use this function to perform memory write to a contiguous block of
 *      memory.  
 *
 *      If you plan to perform consecutive memory write to memory, for
 *      instance in copying an array of binary strings to memory, pass 
 *      <nOffset> by reference to keep it updated in the calling routine.
 *
 *  $EXAMPLES$
 *
 *      /* write an array to a block in memory */
 *
 *		  nSeg := <...>									// initialize pointers to
 *      nOff := <...>                           //  desired memory location
 *
 *      AEVAL( aMemValues, {|e| fn_PokeStr( nSeg, @nOff, e ) }
 *
 *  $SEEALSO$
 *      fn_PeekStr()
 *  $INCLUDE$
 *
 *  $END$
 */

FUNCTION fn_PokeStr( nSeg, nOff, cStr )
	LOCAL i
	FOR i := 1 TO LEN( cStr )
		ft_Poke( nSeg, nOff++, BYTE2I( SUBST( cStr, i, 1 ) ) )
	NEXT
RETURN nil
