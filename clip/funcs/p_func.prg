*********** Source code for CA-Clipper Tools / 5.2 functions **************
*
* Program     : P_FUNC.PRG
* Copyright   : (c) 1991-93, Computer Associates International.
*               All rights reserved.
* Date        : 07/06/91
* Author      : Lothar Bongartz
* Description : Source code for CSETFUNC()
* Compiling   : /l /m /n /w /v /r
*
* Linking     : P_FUNC can be added to the .OBJ file list during
*               linking and replaces the module with the same name in
*               CT.LIB.
*
**************************************************************************

#define MAX_FUNC        48

**************************************************************************

STATIC _aFuncTable[MAX_FUNC]

**************************************************************************

FUNCTION CSETFUNC(nKey, cVal)
  LOCAL cResult := ""

  IF nKey >= 1 .AND. nKey <= MAX_FUNC
    IF cVal = NIL .AND. _aFuncTable[nKey] <> NIL
      cResult := _aFuncTable[nKey]
    ELSE
      _aFuncTable[nKey] := cVal
    ENDIF
  ENDIF

RETURN( cResult )

**************************************************************************
**************************************************************************
* EOF P_FUNC.PRG

