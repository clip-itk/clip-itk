/*
 * File......: FNPFEVAL.PRG
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
 * $Log: fnpfeval.prg,v $
 * Revision 1.1  2002/03/09 13:58:12  clip
 * uri: start :) "netto" library
 *
 *
 */

#include "netto.ch"

/*  $DOC$
 *  $FUNCNAME$
 *     FN_PFEVAL()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *     Set preferred server and eval block
 *  $SYNTAX$
 *
 *     fn_pfEval( xID, bBlock ) -> xRet
 *
 *  $ARGUMENTS$
 *
 *     <xID> can be numeric, or a character.
 *
 *     If it's numeric, it is the connection ID of the server you want
 *     to set to before evaluating <bBlock>.  This is is position of
 *     the server in the server name table. You can use FN_FSNAME()
 *     to find a connection ID, given a server name.  If the 
 *     connection ID is invalid, the current connection ID is used.
 *
 *     If it's a character, it is the _name_ of the server you want
 *     to set to before evaluating <bBlock>.  If the server name is
 *     invalid or not found, the current server is used.
 *
 *     <bBlock> is a code block to evaluate.
 *
 *  $RETURNS$
 *
 *     <xVal>, whatever is returned from the block when it is 
 *     evaluated.
 *
 *  $DESCRIPTION$
 *     
 *     Some APIs require you to set to a preferred connection ID first
 *     before they can be executed.  This call just simplifies the
 *     process of getting the old ID, setting the new one, doing 
 *     something, then resetting the old ID.
 *
 *     This function records the state of fn_error() after evaluating
 *     the block and makes sure it stays that way before returning.
 *     Therefore, you can't really know whether or not the calls to
 *     change the preferred server back and forth are working or not,
 *     as there is no way to access their return values.
 *     
 *  $EXAMPLES$
 *
 *  $INCLUDE$
 *
 *  $SEEALSO$
 *    
 *  $END$
 */

function fn_pfEval( xID, bBlk )
   local nOld, xVal, nErr, nID

   default xID to fn_pfconid(), bBlk to { || nil }

   do case
     case valtype( xID ) == "C"                      // It's a server name
        nID := ascan( fn_fsname(), upper( xID ) )    // Look it up
        nID := iif( nID == 0, fn_pfconid(), nID )    // Use current if not found
     case valtype( xID ) == "N"
        if xID < 1 .or. xID > 8                      
           nID := fn_pfconid()                       // Use current if invalid
        else
           nID := xID
        endif
  otherwise
     nID := fn_pfconid()
  endcase

   nOld := fn_pfconid()         // Save old connection ID
   fn_spfcid( nID )             // Set to new connection ID
   xVal := eval( bBlk )         // Evaluate the block
   nErr := fn_error()           // Store the error code; we'll lose it
   fn_spfcid( nOld )            // Reset the connection ID (and lose error)
   _fnSetErr( nErr )            // Reset the error the way we want it

   return xVal                  // Return the result of eval'ing the block
   
