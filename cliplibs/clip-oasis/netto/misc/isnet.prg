/*
 * File......: ISNET.PRG
 * Author....: Michael Landesman
 * CIS ID....: 76376,2465
 * Date......: $Date: 2002/03/09 13:58:12 $
 * Revision..: $Revision: 1.1 $
 * Log file..: $Logfile$
 * 
 * This is an original work by Michael Landesman and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 * $Log: isnet.prg,v $
 * Revision 1.1  2002/03/09 13:58:12  clip
 * uri: start :) "netto" library
 *
 *
 */

/*  $DOC$
 *  $FUNCNAME$
 *     fn_isNet()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *     Determine if user is on functioning NetWare node
 *  $SYNTAX$
 *
 *     fn_isNet() -> nStatus
 *
 *  $ARGUMENTS$
 *
 *     None
 *
 *  $RETURNS$
 *
 *     <nStatus>, a numeric, which will be one of:
 *
 *           0     User has shell loaded and is logged in
 *           1     User hasn't loaded IPX
 *           2     User hasn't loaded a shell
 *           3     User is not attached to a server
 *           4     User has no connection id (?)
 *           5     User is not logged in
 *
 *
 *  $DESCRIPTION$
 *
 *     fn_isNet() provides a simple way to determine if the user
 *     running your program is logged in.  if fn_isNet() == 0, 
 *     she's in.
 *
 *  $EXAMPLES$
 *
 *     if !fn_isNet()
 *        qout( "This program requires Novell NetWare." )
 *     endif
 *
 *     if fn_isNet()
 *        qout( "This is not a network version!" )
 *        ft_reboot()   // Take that!
 *     endif
 *
 *  $SEEALSO$
 *     fn_netver(), fn_is3x()
 *  $END$
 */

#include "netto.ch"

#define in_NETOK        0
#define in_NOIPX        1
#define in_NOSHELL      2
#define in_NOSERVER     3
#define in_NOCONNECTION 4
#define in_NOTLOGGEDIN  5

function fn_isNet()
   do case
     case !( fn_ipxInit() )
        return in_NOIPX
     case ( fn_shVer() == "" )
        return in_NOSHELL
     case ( fn_fsname()[1] == "" )
        return in_NOSERVER
     case ( fn_connID()[1][9] == 255 )
        return in_NOCONNECTION
     case ( fn_connInfo()[3] )
        return in_NOTLOGGEDIN
   otherwise
     return in_NETOK
   end case

   return nil
