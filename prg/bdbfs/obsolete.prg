/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html

®¤¯à ¢«¥­ë ¬¥«®ç¨ ¢ áâ ­¤ àâ­®¬ SIx ä ©«¥.
¥ª®â®àë¥ SX_ äã­ªæ¨¨ ¯¥à¥¯¨á ­ë.
*/

/*
ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
º Source file: OBSOLETE.PRG						   º
º Description: Compatibility Functions for SIx 3.0			   º
º Written by : Team SuccessWare						   º
º Notice     : Copyright 1995 - SuccessWare 90, Inc.			   º
º									   º
º  NOTES:  File-based Order Management functions are considered obsolete   º
º  in SIx 3.0. They are more confusing than helpful given the sounder	   º
º  Order List Management model embraced in CA-Clipper 5.2.		   º
º  Here is CA-Clipper source code that will perform the same tasks as	   º
º  the former SIx Driver library functions.				   º
º									   º
º  Also note that the OBSOLETE.CH file contains SIx driver functions that  º
º  are directly replaced with corresponding functions in CA-Clipper 5.2    º
º									   º
ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½
*/
#define ORDER_LIMIT 256
#define BAG_LIMIT    50

/*
  Syntax:  Sx_FileOrder()
  Returns: Position of current index file in the index file list
  Works like indexord() in Clipper 5.01a
*/
FUNC Sx_FileOrder()
LOCAL	nSaveOrder  := indexord() ,;
	nFileOrder  := 0	  ,;
	nextOrder   := 1	  ,;
	nTotalTags  := 0	  ,;
	nTagCount
DO WHILE nextOrder <= nSaveOrder
	IF (nTagCount := Sx_tagCount( ordbagName(nextOrder) )) > 0
		nTotalTags += nTagCount
		nextOrder := nTotalTags + 1
		nFileOrder++
	ELSE
		EXIT
	ENDIF
ENDDO
RETURN nFileOrder
/*
  Syntax:  Sx_SetFileOrd( <nFileOrder> )
	   <nFileOrder> is the position of an index file in
			the index file list.
  Returns:  The previously set file order position.
  Selects 1st tag in an index file given the file order position in
  the SET INDEX TO list. Works like dbSetOrder() under Clipper 5.01a.
*/
FUNC Sx_SetFileOrd( nTarget )
LOCAL	nSaveOrder  := indexord()	,;
	nOldFileOrd := Sx_FileOrder()	,;
	nextOrder   := 1		,;
	nTotalTags  := 0		,;
	nTagCount, i
IF !(nTarget == NIL)
      FOR i := 1 to nTarget
	ordSetFocus( nextOrder )
	IF (nTagCount := Sx_tagCount()) > 0
		nTotalTags += nTagCount
		nextOrder := nTotalTags + 1
	ELSE
		ordsetfocus(nSaveOrder)
		EXIT
	ENDIF
      NEXT
ENDIF
RETURN nOldFileOrd

/*
  Syntax:   Sx_SetTag([cTag | nOrder] [,cBag])
	    cTag     = Name of the tag to make active
	    nOrder   = Position of order in the order list
	    cBag     = Name of the file that contains the tag or order
  Returns:  <logical> .T. if order changed successfully.
	    otherwise returns .F. and former order is restored.
  3/3/95
  ------
  Fix bug that returns .t. when called like sx_settag(x,y) and there are no tags open.
  Test for 0 tagcount is tagEmpty(sx_indexName(1)). Don't use sx_tagCount() because
  if we're at order 0 now, tagcount() w/ no params returns 0, even if an index file is open.

  3/8/95
  ------
  Special Cases:
      if no dbf open	  --> return false
      if xTag == NIL	  --> return false
      if no ix open	  --> return empty(xTag)
*/
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
/*
 we have to do this because, although clipper's ordsetfocus()
 works correctly with a params <cTag>,<cBag> it does
 NOT work correctly with <nTag>, <cBag>. It ignores the
 orderbagname if a number is passed and just sets
 order to the orderlist number represented by <nTag>.
*/
			nCount := bag2Tag( cBag )
			ordSetFocus( nCount + xTag - 1)
			lRet := (ordBagName() == ordBagName( nCount + xTag - 1))
		ENDIF
	  ELSE
		ordSetFocus(xTag, cBag)
		lRet:=IF( valtype(xTag) == "N",;
			 (ordName() == ordName( xTag, cBag) ),;
			 (ordNumber() == ordNumber(xTag, cBag) );
			)
	  ENDIF
	ENDIF
	IF !lRet
		ordSetFocus(oldOrd)
	ENDIF
ENDIF
RETURN lRet

/*
  Syntax:   Sx_TagCount([xBag])
	    xBag = Bag Name or Bag Position in list of Index Files
  Returns:  <numeric> Number of tags in the current or specified
	    index (order bag). 0 if the order is invalid, no index is open,
	    or if the current order is 0 and no parameters were passed.
*/
FUNC Sx_TagCount(xBag)
LOCAL nOrd, cBagName, nCnt := 0
// get order list position of first tag in the passed bag.
IF !empty(alias())
	nOrd := bag2Tag(xBag)
	cBagName := ordBagName(nOrd)
	IF nOrd > 0
		WHILE cBagName == ordBagName(nOrd++)
			nCnt++
		ENDDO
	ENDIF
ENDIF
RETURN nCnt

/*
   Return array of Tagnames in a given orderBag
   Syntax:	   Sx_Tags( [cBagName | nBagPosition] )
		   cBagName = name of index file (order bag)
		   nBagPosition = position of index in list of indexes
  Returns:	<array> Array of tag names contained in the index file.
		{} if the order is invalid or no index open.
*/
FUNC  Sx_Tags(xBag)
LOCAL ar_ := {}, nCount, i, nFirstTag
IF !empty( alias() )
	nFirstTag := bag2Tag( xBag ) - 1
	nCount := Sx_tagCount(xBag)
	FOR i := 1 to nCount
		AADD(ar_,ordName( nFirstTag + i ))
	NEXT
ENDIF
RETURN ar_

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
FUNC SXCHAR(nLen, xVal)
LOCAL cType:=ValType(xVal)
IF ValType(nLen)<>'N'
	nLen:=10
ENDIF

IF (cType $ "NF")
	xVal:= Str(xVal)
ELSEIF (cType == "D")
	xVal:= DToS(xVal)
ELSEIF (cType == "L")
	xVal:= IF(xVal, "T", "F")
ELSEIF !(cType $ 'CM')
	xVal:= ''
ENDIF

RETURN PAD(LTRIM(xVal),nLen)
**********
FUNC SXNUM(xVal)
LOCAL cType:= ValType(xVal)
IF (cType $ "CM")
	xVal:= Val(xVal)
ELSEIF (cType $ 'NF')
	//“¦¥
ELSEIF (cType == "D")
	xVal:= Sx_Dateval(xVal)
ELSEIF (cType == "L") .AND. xVal
	xVal:= 1
ELSE
	xVal:=0
ENDIF
RETURN xVal
**********
FUNC SXDATE(xVal)
RETURN IF(ValType(xVal) $ 'CM', CTOD(xVal), Sx_Valdate(xVal) )
**********
FUNC SXLOG(xVal)
LOCAL cType:= ValType(xVal)
IF (cType $ "CM")
	xVal := (UPPER(xVal) $  ".T.Y")
ELSEIF (cType $ "NF")
	xVal:= (xVal # 0)
ELSEIF (cType <> "L")
	xVal:= .F.
ENDIF
RETURN xVal
**********
FUNC Sx_WildSeek(cSearch,lCont)
//à¨£¨­ «ì­ ï Sx_WildSeek ­¥ à ¡®â ¥â á NTX
LOCAL _ik:=IndexKey(0), i1, i2, cBase, lFound

IF Empty(_Ik) .OR. VALTYPE(&_ik)<>'C' .OR. VALTYPE(cSearch)<>'C'
	lFound:=.F.
ELSE
	IF LEN(cSearch)<LEN(&_ik)
		cSearch+='*'
	ENDIF

	i1:=AT('*',cSearch)
	i2:=AT('?',cSearch)
	i1:=IF( i1>0 .AND. i2>0, MIN(i1,i2), MAX(i1,i2) )
	cBase:=SUBSTR(cSearch,1,i1-1)

	IF EMPTY(lCont)
		DBSEEK(cBase)
	ELSE
		DBSKIP()
	ENDIF
	WHILE !EOF() .AND. IsLefts(&_ik,cBase) .AND. !LIKE(cSearch,&_ik)
		DBSKIP()
	ENDDO
	lFound:=LIKE(cSearch,&_ik)
ENDIF
__Dbsetfou(lFound)
RETURN lFound
**********
FUNC Sx_WildMatch(cSearch,cValue)
RETURN LIKE(cSearch,cValue)
**********
FUNC M6_RecCount
* ®ª  ­¥ á¤¥« îâ ¢ CLIP
RETURN ORDKEYCOUNT()

**********
EXTERNAL SX_IDTYPE,SX_ISFLOCK,SX_ISREADONLY,;
	 SX_VFGET,SX_SetPass,Sx_SlimFast,SX_DTOP,SX_PTOD,;
	 SX_KeyADD,SX_KeyDrop,SX_FINDREC,SX_KeyData,;
	 SX_IsLocked,Sx_GetLock,;
	 M6_IsFilter,M6_RefreshFilter,M6_FiltCopy,M6_FiltAdd,M6_FiltChg,;
	 M6_FiltCount,M6_FiltDropRec,M6_FiltInfo,M6_FiltInverse,;
	 M6_FiltJoin,M6_SetAreaFilter
