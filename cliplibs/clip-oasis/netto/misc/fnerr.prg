/*
 * File......: FNERR.PRG
 * Author....: Glenn Scott
 * CIS ID....: 71620,1521
 * Date......: $Date: 2002/03/09 13:58:12 $
 * Revision..: $Revision: 1.1 $
 * Log file..: $Logfile$
 * 
 * This is an original work by Glenn Scott and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 * $Log: fnerr.prg,v $
 * Revision 1.1  2002/03/09 13:58:12  clip
 * uri: start :) "netto" library
 *
 *
 */


#include "ftint86.ch"
#include "netto.ch"


static  gFnErr   :=    ESUCCESS


/*  $DOC$
 *  $FUNCNAME$
 *     FN_ERROR()
 *  $CATEGORY$
 *     Miscellaneous
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
 *  $DESCRIPTION$
 *
 *  $EXAMPLES$
 *
 *  $SEEALSO$
 *     _fnSetErr()
 *  $END$
 */


function fn_Error()
  return gFnErr


/*  $DOC$
 *  $FUNCNAME$
 *     _fnSetErr()
 *  $CATEGORY$
 *     Miscellaneous
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
 *  $DESCRIPTION$
 *
 *  $EXAMPLES$
 *
 *  $SEEALSO$
 *     FN_ERROR()
 *  $END$
 */



function _fnSetErr( nCode )
  local xOld := gFnErr

  gFnErr     := nCode 
  return xOld
