/*
 *   File......: FndPVE.Prg
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
 *
 */

function _fndPVarE( cPathVar,nSrchOrdr )
    Local nI := 1
    Local cRetPath := ""

    If ( Empty( cPathVar ))
        Return( Nil )
    EndIf
    cRetPath = cPathVar
    For nI = nSrchOrdr-1 to 1 Step -1
        cRetPath = SubStr( cRetPath,( At( ";",cRetPath )+1 ))
    Next nI
    Return( cRetPath )

