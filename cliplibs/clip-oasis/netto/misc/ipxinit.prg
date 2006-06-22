/*
 *   File......: IPXInit.Prg
 *   Author....: Sheldon Easterbrook
 *   CIS ID....: 71421,254
 *   Date......: $Date$
 *   Revision..: $Revision$
 *   Log File..: $LogFile$
 *
 *   This is an original work by Sheldon Easterbrook and is placed in the
 *   Public Domain
 *
 *   Modification History:
 *   ---------------------
 *
 *   $Log$
 *   Revision 1.1  2006/06/22 20:12:13  itk
 *   uri: init sf.net
 *
 *   Revision 1.1  2002/03/09 13:58:12  clip
 *   uri: start :) "netto" library
 *
 */


/*  $DOC$
 *  $FUNCNAME$
 *     Fn_IPXInit()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *      This function gets the entry address for the IPX interface.
 *  $SYNTAX$
 *
 *      Fn_IPXInit() -> lInit
 *
 *  $ARGUMENTS$
 *
 *  $RETURNS$
 *
 *      <lInit> - Whether IPX has been initialised.  If <lInit> is false
 *      check Fn_Error() for the error code which could be one of:
 *
 *       [ Error codes here ]
 *
 *  $DESCRIPTION$
 *
 *      This function initializes an array in the library
 *      with the address of the IPX services. This function must be
 *      called before any of the IPX functions in this library can be
 *      performed.
 *
 *      [This function is meant to be part of a larger suite but 
 *      the code wasn't ready by the release date.  In its present
 *      form, it can be used to determine if IPX is installed, 
 *      which might be useful.]
 *
 *  $EXAMPLES$
 *
 *      If ( Fn_IPXInit())
 *          ? "IPX installed"
 *      EndIf
 *
 *  $SEEALSO$
 *      
 *  $INCLUDE$
 *
 *  $END$
 */

#include "ftint86.ch"
#include "netto.ch"

static aIPXLocn := { 0, 0 }

/* ----------------------------------------------------------------- */

function fn_ipxInit()
   local aReg[ 10 ], lRet := .f.

   aIpxLocn[ 1 ] := 0
   aIpxLocn[ 2 ] := 0

   aReg[ AX ]    := ft_hex2dec( "7a00" )

   if ft_int86( ft_hex2dec( "2f" ), aReg ) 
      if lowbyte( aReg[ AX ] ) == 0
         _fnSetErr( ft_hex2dec( "F0" ) )
      else
         aIPXLocn[ 1 ] := aReg[ DI ]
         aIPXLocn[ 2 ] := aReg[ ES ]
         lRet := .t.
      endif
   else
      _fnSetErr( EINT86 )
   endif

   return lRet

/* ----------------------------------------------------------------- */

function _fnipxLoc()
   return aclone( aIPXLocn )
