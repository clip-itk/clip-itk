/*
 * File......: NONULL.PRG
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
 *     fn_noNull()
 *  $CATEGORY$
 *     Miscellaneous
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
 *  $DESCRIPTION$
 *
 *     Given a string <cStr>, fn_noNull() strips any trailing NULLs,
 *     [ chr(0) ] from the end.  If there are no nulls, the entire
 *     string is returned.
 *
 *  $EXAMPLES$
 *
 *  $SEEALSO$
 *
 *  $END$
 */


function fn_noNull( cVar )
  local pos := at( chr(0), cVar )

  if pos > 0
    cVar := substr( cVar, 1, pos - 1 )
  endif

  return cVar
