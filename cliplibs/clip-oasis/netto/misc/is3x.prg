/*
 * File......: IS3X.PRG
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
 * $Log: is3x.prg,v $
 * Revision 1.1  2002/03/09 13:58:12  clip
 * uri: start :) "netto" library
 *
 *
 */

#ifdef FT_TEST
   function main()
      local aTbl, nX

      aTbl := fn_fsname()
      for nX := 1 to len( aTbl )
         if !empty( aTbl[ nX ] )
            qqout( aTbl[ nX ] + " " )
            fn_pfeval( nX,  { ||  qqout( iif( fn_is3x(), "is 3.x", "is not 3.x" ) ) } )
            qout( "" )
         endif
      next
#endif

      
        
      


/*  $DOC$
 *  $FUNCNAME$
 *      FN_IS3X()
 *  $CATEGORY$
 *      Miscellaneous
 *  $ONELINER$
 *      Is the current server a 3.x server?
 *  $SYNTAX$
 *
 *      fn_is3x() -> lIs3X
 *
 *  $ARGUMENTS$
 *
 *      None
 *
 *  $RETURNS$
 *
 *      .t. if the server is a 3.x server, .f. if it isn't
 * 
 *  $DESCRIPTION$
 *
 *      A simple function that wraps around FN_GETFSI().  Determines
 *      whether or not the current server is a NetWare 3.x server or
 *      not.
 *
 *  $EXAMPLES$
 *
 *      if fn_is3X()
 *         qout( "You're on NetWare 3.x" )
 *      endif
 *
 *  $SEEALSO$
 *      FN_GETFSI()
 *  $INCLUDE$
 *
 *  $END$
 */


function fn_is3x()
   return  ( fn_netver() > 3.0 )
