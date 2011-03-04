/*
 * File......: REQUEST.PRG
 * Author....: API Group
 * CIS ID....: 71620,1521
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



#include "ftint86.ch"
#include "netto.ch"


/*  $DOC$
 *  $FUNCNAME$
 *     _fnReq()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *     General purpose packet request function for Netware APIs
 *  $SYNTAX$
 *
 *     _fnReq( nService, cRequest, @cReply ) -> nRetVal
 *
 *  $ARGUMENTS$
 *
 *     <nService> - the Netware API service number, in decimal (not hex!)
 *     <cRequest> - the request packet, without length word
 *     <cReply>   - the reply packet, without length word
 *                  (MUST BE PASSED BY REFERENCE!)
 *
 *     Most request and reply packets must have a length word prepended
 *     to the packet.   FN_REQ() supplies these length words!  Do not
 *     put your own length word on the front of either packet or the 
 *     call will fail miserably.
 *
 *  $RETURNS$
 *
 *     <cReply> will be filled in with the reply packet if the call 
 *     succeeds.  The length word (the first two bytes of the string)
 *     will be removed.
 *
 *     <nRetVal> will be the value of register AH, which in most cases
 *     holds a return code that you can use to check whether or not your
 *     call succeeded.
 *
 *     This function calls interrupt 21 using the Nanforum Toolkit's
 *     ft_int86().  If the call to ft_int86() fails, fn_error() is
 *     set with the EINT86 error code.  If the ft_int86() succeeds,
 *     fn_error() is set to the value of register AL, which is often
 *     a completion code for Netware APIs.
 *
 *  $DESCRIPTION$
 *
 *  $EXAMPLES$
 *
 *  $SEEALSO$
 *
 *  $END$
 */



function _fnReq( nService, cRequest, cReply )
    local   aRegs[ INT86_MAX_REGS ],    ;
            nRetVal,;
            cSend, cRecv
    
  cSend := i2bin( len( cRequest ) ) + cRequest
  cRecv := I2bin( len( cReply   ) ) + cReply

  aRegs[ AX ] := makeHI( nService )   // AH
  aRegs[ DS ] := cSend
  aRegs[ SI ] := REG_DS
  aRegs[ ES ] := cRecv
  aRegs[ DI ] := REG_ES

  if ft_int86( INT21, aRegs )
     _fnSetErr( UNSIGNED( lowbyte( aRegs[ AX ] ) ) )
  else
     _fnSetErr( EINT86 )
  endif

  cReply := substr( aRegs[ ES ], 3 )

  return UNSIGNED( lowbyte( aRegs[ AX ] ) )
