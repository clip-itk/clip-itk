/*
 *   File......: FndPVE.Prg
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
 *   $Log: fndpve.prg,v $
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

