*********** Source code for CA-Clipper Tools / 5.2 functions **************
*
* Program     : P_SECRET.PRG
* Copyright   : (c) 1991-93, Computer Associates International.
*               All rights reserved.
* Date        : 01/15/92
* Author      : Lothar Bongartz
* Description : Source code for GETSECRET()
* Compiling   : /l /m /n /w /v /r
*
* Linking     : P_SECRET can be added to the .OBJ file list during
*               linking and replaces the module with the same name in
*               CT.LIB.
*
**************************************************************************

FUNCTION GETSECRET(xSource, nRow, nCol, lSay, xSay, cPic, bValid, bWhen)
LOCAL nOldRow := ROW(), nOldCol := COL(), GetList[1]

  IF nRow = NIL
    nRow := nOldRow
  ENDIF
  IF nCol = NIL
    nCol := nOldCol
  ENDIF
  IF lSay = NIL
    lSay := .F.
  ENDIF
  if cpic==NIL
     cpic=""
  endif
  if substr(cpic,1,1)=="@"
     cpic="@Q"+substr(cpic,2)
  else
     cpic="@Q "+cpic
  endif

  SetPos(nRow, nCol)

  IF xSay <> NIL
    DispOut(xSay)
    nCol := COL() +1
    SetPos(nRow, nCol)
  ENDIF

  IF xSource = NIL
    RETURN( "" )
  ENDIF

  //GetList[1] := _GET_(xSource, "_GETINPUT", cPic, bValid, bWhen)
  GetList[1] := getnew(nrow,ncol,;
	   {|_1| __field__ iif(_1==NIL,xSource,xSource:=_1 ) __field__ },;
	   xSource, cPic, setcolor(), "_GETINPUT", bValid, bWhen)

  ReadModal(GetList)

  IF lSay
    SetPos(nRow, nCol)
    DispOut(xSource)
  ENDIF

  SetPos(nOldRow, nOldCol)

RETURN( xSource )

**************************************************************************
**************************************************************************
* EOF P_SECRET.PRG
