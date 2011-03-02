/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html

Fixed little bugs in standard file SIx.
Some SX_* function was rewritten.
*/
#include 'common.ch'
#define ORDER_LIMIT 256
#define BAG_LIMIT    50

/*
  Syntax:   Sx_SetTag([cTag | nOrder] [,cBag])
	    cTag     = Name of the tag to make active
	    nOrder   = Position of order in the order list
	    cBag     = Name of the file that contains the tag or order
  Returns:  <logical> .T. if order changed successfully.
	    otherwise returns .F. and former order is restored.
  ------
  Special Cases:
      if no dbf open	  --> return false
      if xTag == NIL	  --> return false
      if no ix open	  --> return empty(xTag)
*/

/*
FUNC Sx_SetTag(xTag, cBag)
LOCAL cTag, nCount, oldOrd, lRet := .t., nTagCount := sx_tagCount()

IF empty(alias()) .OR. xTag == NIL
	lRet := .f.

ELSEIF empty(sx_indexName(1))
// if we say sx_settag(0) or sx_setTag("") then
// we return true even if there is no index open.

	lRet := empty( xTag )

ELSE
	oldOrd := ordNumber()
	IF empty(cBag)
	  IF empty(ordBagName()) .AND. !empty( xTag )
	 	ordSetFocus(xTag)
	 	lRet := !empty( ordBagName() )
	  ELSE
	 	ordSetFocus(xTag)
	 	lRet := (ordBagName(xTag) == ordBagName())
	  ENDIF
	ELSE
	  IF valtype(xTag) == "N"
		nTagCount := sx_tagCount(cBag)
// if passed number is greater than number of tags
// in the passed orderbag, return false
		IF xTag > nTagCount .OR. xTag < 0
			lRet := .f.
		ELSE
*/

/*
 we have to do this because, although clipper's ordsetfocus()
 works correctly with a params <cTag>,<cBag> it does
 NOT work correctly with <nTag>, <cBag>. It ignores the
 orderbagname if a number is passed and just sets
 order to the orderlist number represented by <nTag>.
*/
/*
 Return orderlist position of the first order of an orderbag.
 xBag can be nBagPos, cBagName, or NIL
*/
static FUNC bag2Tag(xBag)
LOCAL nOrdCnt, cBagName, nAtDot, cExt, cPrevBag, nBagCnt := 1

IF xBag == NIL
   IF empty( cBagName := ordBagName(1) )
	nOrdCnt := 0
   ELSE
	nOrdCnt := 1
	WHILE !( cBagName == ordBagName(nOrdCnt) )
		nOrdCnt++
	ENDDO
   ENDIF
ELSEIF valtype(xBag) == "N"
   IF empty(ordBagName(xBag))
	nOrdCnt := 0
   ELSE
	nOrdCnt := 1
	WHILE nBagCnt < xBag
		cBagName := ordBagName(nOrdCnt)
		nOrdCnt++
		WHILE cBagName == ordBagName(nOrdCnt)
			nOrdCnt++
		ENDDO
		nBagCnt++
	ENDDO
   ENDIF
ELSE	 // xbag is a filename
   nAtDot := at(".", xBag)
   cExt   := ordBagExt()
   xBag   := upper(xBag)
   IF empty( ordBagName(1) )
	nOrdCnt := 0
   ELSE
	nOrdCnt := 1
	IF nAtDot == 0 .AND. cExt == ".IDX"
		WHILE !( xBag + ".CDX" == (cBagName:=ordBagName(nOrdCnt)) )
			IF ( xBag + cExt == cBagName)
				EXIT
			ENDIF
			IF ++nOrdCnt > ORDER_LIMIT // no xBag in the index file list
				nOrdCnt := 0
				EXIT
			ENDIF
		ENDDO
	ELSE
		IF nAtDot == 0
			xBag += cExt
		ENDIF
		WHILE !( xBag == ordBagName( nOrdCnt ) )
			IF ++nOrdCnt > ORDER_LIMIT // no xBag in the index file list
				nOrdCnt := 0
				EXIT
			ENDIF
		ENDDO
	ENDIF
   ENDIF
ENDIF
RETURN nOrdCnt
**********
FUNC Sx_EnCrypt(cStr, cPsw)
LOCAL cRes
IF_NIL cPsw IS Sx_SetPass()
RETURN IF(Valtype(cStr) $ 'CM', Crypt(cStr, cPsw), cStr)
**********
FUNC Sx_DeCrypt(cStr, cPsw)
RETURN Sx_EnCrypt(cStr, cPsw)	//So clipper tools works
