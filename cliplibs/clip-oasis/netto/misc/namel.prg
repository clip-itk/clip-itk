/*
 * File......: NAMEL.PRG
 * Author....: Steven Tyrakowski
 * CIS ID....: 
 * Date......: $Date$
 * Revision..: $Revision$
 * Log file..: $Logfile$
 * 
 * This is an original work by various Netware API group participants
 * and is placed in the public domain.
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
 *     fn_NameL()
 *  $CATEGORY$
 *     Miscellaneous
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
 *  $DESCRIPTION$
 *
 *     There are numerous places where a character string that is sent
 *     needs to be encoded with a leading BYTE specifying the length
 *     and may also need to be padded with NULLs.
 *
 *     A terminating null is guaranteed.
 *
 *     If the Length of cName is greater than nRequiredLength -1,
 *     it is truncated to leave room for the terminator.
 *
 *  $EXAMPLES$
 *
 *  $SEEALSO$
 *
 *  $END$
 */

function fn_nameL( cName, nLen )

  /*
   *  If no length was specified, check for a terminating null
   *  and add room for one if not found
   *
   */

  if nLen == nil
    nLen := len( cName ) + iif( right( cName, 1 ) == chr(0), 0, 1 )
  endif

  return chr( nLen ) + padr( cName, nLen - 1, chr(0) ) + chr(0)

