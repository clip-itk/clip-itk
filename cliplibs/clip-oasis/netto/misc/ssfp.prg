/*
 *   File......: SSFP.Prg
 *   Author....: Sheldon Easterbrook
 *   CIS ID....: 71421,254
 *   Date......: $Date: 2002/03/09 13:58:12 $
 *   Revision..: $Revision: 1.1 $
 *   Log File..: $LogFile$
 *
 *   This is an original work by Sheldon Easterbrook and is placed in the
 *   Public Domain
 *
 *   Modification History:
 *   ---------------------
 *
 *   $Log: ssfp.prg,v $
 *   Revision 1.1  2002/03/09 13:58:12  clip
 *   uri: start :) "netto" library
 *
 *
 */

/*  $DOC$
 *  $FUNCNAME$
 *     Fn_SSFromP()
 *  $CATEGORY$
 *     Miscellaneous
 *  $ONELINER$
 *      Remove the file server name from a path string
 *  $SYNTAX$
 *
 *      Fn_SSFromP( <cFullPath>,<@cServerName> ) -> cStrippedPath
 *
 *  $ARGUMENTS$
 *
 *      <cFullPath>   - The path from which the server name is to be
 *                      stripped.
 *
 *      <cServerName> - The stripped file server name (MUST BE PASSED BY
 *                      REFERENCE!)
 *
 *  $RETURNS$
 *
 *     <cStrippedPath> - <cFullPath> less <cServerName>.
 *
 *  $DESCRIPTION$
 *
 *      This function strips the server name from the specified path.
 *      If the path does not include a file server specification, then
 *      the function returns the original path.
 *
 *  $EXAMPLES$
 *
 *      cStripped := Fn_SSFromP( "FS1/SYS:\PUBLIC",@cServer )
 *      ? cStripped     // "SYS:\PUBLIC"
 *      ? cServer       // "FS1"
 *
 *  $SEEALSO$
 *
 *  $INCLUDE$
 *
 *  $END$
 */

function Fn_SSFromP( cPath, cServer )
   cServer := SubStr( cPath,1,( At( "/",cPath )))
   cPath   := SubStr( cPath,( At( "/",cPath )+1 ))
   return( cPath )
