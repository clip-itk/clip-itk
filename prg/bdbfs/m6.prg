/*
    Copyright (C) 2001  ITK
    Author  : Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

//Слегка усовершенствованные функции SIX3.Lib
**********
FUNC _M6ISKEYTY(Arg1)
LOCAL lRes:= .F., bErr:= ErrorSys(.t.)

BEGIN SEQUENCE
	lRes:= (ValType(Evaluate(Arg1)) $ "NCLD")
END SEQUENCE

Errorblock(bErr)

RETURN lRes
**********
PROC _M6CONVERT(cCnv, bCnv, nTCnv)

LOCAL cRslt, bErr, bSave
IF (cCnv == Nil .OR. bCnv == Nil)
	RETURN
ENDIF
IF (nTCnv == Nil)
	nTCnv:= 2
ENDIF
bSave:= bCnv
bErr:= ErrorSys(.t.)
BEGIN SEQUENCE
	cCnv:= Alltrim(cCnv)
	IF (SubStr(cCnv, 1, 1) == "(" .AND. SubStr(cCnv, -1, 1) == ")" ;
			.AND. ValType((cRslt:= eval(bCnv), cRslt)) == "C")
		IF _M6Isclipv(SubStr(cCnv, 2, Len(cCnv) - 1))
			IF (Len(cRslt) <= 256)
				bCnv:= Compile(cRslt)
				IF !_M6Isorder(bCnv)
					eval(bCnv)
				ELSEIF (nTCnv == 1)
					bCnv:= Nil
				ELSE
					bCnv:= {|| .T.}
				ENDIF
			ELSEIF (nTCnv == 1)
				bCnv:= Nil
			ELSE
				bCnv:= {|| .T.}
			ENDIF
			cCnv:= cRslt
		ELSEIF _M6Iskeyty(cRslt)
			bCnv:= Compile(cRslt)
			cCnv:= cRslt
		ELSEIF (Len(cRslt) > 256)
			bCnv:=IF(nTCnv == 1,NIL,{|| .T.})
			cCnv:= cRslt
		ENDIF
	ENDIF
RECOVER
	IF (nTCnv == 1)
		cCnv:= cRslt
		bCnv:= Nil
	ELSE
		bCnv:= bSave
	ENDIF
END SEQUENCE
Errorblock(bErr)
**********
FUNC M6_ADDSCOP(nHandle, xLow, xHigh, nOrder)
LOCAL nOldOrd, nRange, nRecords:=0, cType
IF (nOrder <> Nil .AND. (ValType(nOrder) <> "N"))
	RETURN 0
ENDIF

BEGIN SEQU
  nOldOrd:=Indexord()
  IF (nOrder <> Nil)
	dbSetOrder(nOrder)
	IF (Indexord() <> nOrder)
		BREAK
	ENDIF
  ELSE
	nOrder:= nOldOrd
  ENDIF

  cType:= ValType(xHigh)

  DO CASE
	CASE xLow == Nil .AND. xHigh == Nil
		nRange:= 5
	CASE xLow <> Nil .AND. xHigh == Nil
		nRange:= 2
		cType:= ValType(xLow)
	CASE xLow == Nil .AND. xHigh <> Nil
		nRange:= 3
	CASE cType <> ValType(xLow)
		M6_Error(1, 2019)
		BREAK
	CASE xLow == xHigh
		nRange:= 4
	OTHER
		IF (xHigh < xLow)
			M6_Error(1, 2035)
			BREAK
		ENDIF
		nRange:= 1
  ENDCASE

  dbSetOrder(nOrder)
  IF nRange<>5 .AND. (VALTYPE(&(IndexKey()))<>cType)
	M6_Error(1, 2019)
	BREAK
  ENDIF
  nRecords:= _M6Addscop(nRange, nHandle, xLow, xHigh)

END SEQU
dbSetOrder(nOldOrd)

RETURN nRecords
**********
FUNC M6_NEWFILT(xExpr)
LOCAL hF:= 0, bErr, nRslt
IF (xExpr == Nil) .OR. (ValType(xExpr) == "N")
	hF:= _M6Emptyfi(xExpr)
ELSE
	bErr:= ErrorSys(.t.)
	BEGIN SEQUENCE
		nRslt:= _M6Setcmdf(xExpr, .T., .T.)
	RECOVER
		nRslt:= 0
	END SEQUENCE
	Errorblock(bErr)
	IF (nRslt == 2 .OR. nRslt == 1)
		M6_Chgowne(hF:= M6_Getarea())
	  ENDIF
	_M6Restcmd()
ENDIF
RETURN hF

**********
FUNC RDD_INFO(Arg1)
LOCAL aRet[6]
RETURN IF(_Rdd_Info( IF(Arg1 == Nil, Rddsetdefa(), Arg1), aRet), aRet, {})

**********
FUNC RDDINFO(Arg1)
RETURN Rdd_Info(Arg1)

**********
FUNC SX_MEMOEXT(Arg1)
RETURN Sx_Memoe(Rddsetdefa(), Arg1)

**********
FUNC SX_MEMOBLK
RETURN Sx_Memob(Rddsetdefa())

**********
FUNC SX_DEFTRIG(Arg1, Arg2, Arg3, Arg4)
/*
DO CASE
	CASE Arg1 == 1
		Sx_Settrig(3)
	CASE Arg1 == 2
	CASE Arg1 == 3
	CASE Arg1 == 4
	CASE Arg1 == 5
	CASE Arg1 == 6
	CASE Arg1 == 7
	CASE Arg1 == 8
	CASE Arg1 == 9
	CASE Arg1 == 10
	CASE Arg1 == 11
	CASE Arg1 == 12
	CASE Arg1 == 13
	CASE Arg1 == 14
ENDCASE
*/
IF Arg1 == 1
	Sx_Settrig(3)
ENDIF

RETURN .T.

**********
FUNC SX_DBFENCR(cPsw)
LOCAL aMemo, aStru, i, j, nLast, cField, cOldPsw, nOrder, lSetDel
IF (!Used()) .OR. (Sx_Isshare())
	RETURN .F.
ENDIF
lSetDel:= Set(11, .F.)
aStru:= Dbstruct_()
aMemo:= {}
FOR i:= 1 TO FCount()
	IF (aStru[i][2] == "M")
		AAdd(aMemo, {i, Nil})
	ENDIF
NEXT
nOrder:= ordSetFocus(0)
dbGoTop()
cOldPsw:= Sx_Setpass(1, "")
IF (cPsw = Nil)
	cPsw:= Sx_Setpass(1, "")
ELSE
	Sx_Setpass(cPsw)
	cPsw:= Sx_Setpass(1, "")
ENDIF
nLast:= LastRec()
FOR i:= 1 TO nLast
	IF (Len(aMemo) > 0)
		Sx_Setpass(2, cOldPsw)
		FOR j:= 1 TO Len(aMemo)
			aMemo[j][2]:= Fieldget(aMemo[j][1])
		NEXT
		Sx_Setpass(2, cPsw)
		FOR j:= 1 TO Len(aMemo)
			Fieldput(aMemo[j][1], aMemo[j][2])
		NEXT
	ENDIF
	Sx_Setpass(2, cOldPsw)
	cField:= Fieldget(1)
	Sx_Setpass(2, cPsw)
	Fieldput(1, cField)
	dbSkip(1)
NEXT
Sx_Setpass(3, "")
ordSetFocus(nOrder)
dbGoTop()
Set(11, lSetDel)
RETURN .T.

**********
FUNC SX_DBFDECR(cPsw)
LOCAL aMemo, aStru, i, j, nLast, cField, cOldPsw, nOrder, lSetDel
IF (!Used()) .OR. (Sx_Isshare())
	RETURN .F.
ENDIF
lSetDel:= Set(11, .F.)
aStru:= Dbstruct_()
aMemo:= {}
FOR i:= 1 TO FCount()
	IF (aStru[i][2] == "M")
		AAdd(aMemo, {i, Nil})
	ENDIF
NEXT
nOrder:= ordSetFocus(0)
dbGoTop()
cOldPsw:= Sx_Setpass(1, "")
IF (cPsw == Nil)
	cPsw:= ""
ENDIF
nLast:= LastRec()
FOR i:= 1 TO nLast
	IF (Len(aMemo) > 0)
		Sx_Setpass(2, cOldPsw)
		FOR j:= 1 TO Len(aMemo)
			aMemo[j][2]:= Fieldget(aMemo[j][1])
		NEXT
		Sx_Setpass(cPsw)
		FOR j:= 1 TO Len(aMemo)
			Fieldput(aMemo[j][1], aMemo[j][2])
		NEXT
	ENDIF
	Sx_Setpass(2, cOldPsw)
	cField:= Fieldget(1)
	Sx_Setpass(cPsw)
	Fieldput(1, cField)
	dbSkip(1)
NEXT
dbGoTop()
Sx_Setpass(4, "")
ordSetFocus(nOrder)
dbGoTop()
Set(11, lSetDel)
RETURN .T.

**********
FUNC M6_SET(nSet, xSet)
*{SET TYPECHECK,OPTIMIZE,,RECHECK}
STATIC aNowSet:={.F., .T., NIL, .F.}
LOCAL lPrev

IF nSet>=1 .AND. nSet<=4

	IF ValType(xSet)  == "C"
		xSet:= (Upper(xSet) == "ON")
	ENDIF
	lPrev:=aNowSet[nSet]

	IF xSet <> Nil
		_M6Set(nSet, aNowSet[nSet] := xSet )
	ENDIF
ENDIF

RETURN lPrev
**********
FUNC M6_SETTEMP(cNew)
STATIC cTemp:= ""
LOCAL cNow:= cTemp
IF cNow == ""
	cNow:= Getenv("M6TEMP")
ENDIF
IF ValType(cNew) == "C"
	cTemp:= cNew
ENDIF
RETURN cNow

**********
PROC M6_SETFILT(bFilter, cFilter, lNoOpt)
LOCAL lOpt, bErr, lErr:= .F.
IF (cFilter == Nil)
	dbSetFilter(bFilter)
	RETURN
ENDIF
_M6Convert(@cFilter, @bFilter)
_M6Cvtorda(cFilter, @bFilter)
IF (bFilter == Nil)
	bErr:= ErrorSys(.t.)
	BEGIN SEQUENCE
		bFilter:= &("{||" + cFilter + "}")
	RECOVER
		lErr:= .T.
	END SEQUENCE
	Errorblock(bErr)
	IF lErr
		bFilter:=IF(M6_Isoptim(cFilter) <> 0,;
				{|| .T.},;
				Compile( cFilter ))
	ENDIF
ENDIF
IF EMPTY(lNoOpt)
	dbSetFilter(bFilter, cFilter)
ELSE
	lOpt:= M6_Set(2, .F.)
	dbSetFilter(bFilter, cFilter)
	M6_Set(2, lOpt)
ENDIF
**********
FUNC _M6ISORDER(Arg1)
LOCAL lErr:= .F., bErr:= ErrorSys(.t.), oInfo
BEGIN SEQUENCE
	eval(Arg1)
RECOVER USING oinfo
	IF (Upper(oinfo:operation()) = "_ORDER")
		lErr:= .T.
	ENDIF
END SEQUENCE
Errorblock(bErr)
RETURN lErr
**********
PROC _M6CVTORDA(Arg1, Arg2)
IF ( _M6Isorder(Arg2) .AND. Len(Arg1) <= 256)
	_M6Transor(@Arg1)
	Arg2:=IF( Len(Arg1) <= 256, Compile(Arg1), {|| .T.} )
ENDIF
**********
FUNC _ORDER(Arg1)
LOCAL  hFltr, lRes

hFltr:= M6_Newfilt("_ORDER->" + Arg1)
lRes:= M6_Isfiltr(hFltr, RECNO())
M6_Freefil(hFltr)
RETURN lRes
**********
FUNC M6_ISOPTIM(cFor, lIsCount)
LOCAL bErr, nRes:= 0
lIsCount:=!EMPTY(lIsCount)
IF (cFor == Nil)
	IF lIsCount
		cFor:= ".T."
	ELSE
		RETURN 0
	ENDIF
ENDIF
bErr:= ErrorSys(.t.)
BEGIN SEQUENCE
	nRes:= _M6Isoptim(cFor, lIsCount)
END SEQUENCE
Errorblock(bErr)
RETURN nRes
**********
PROC M6_DBEVAL(bEval, cFor, bFor)
LOCAL lRes, bErr
IF (cFor == Nil)
	DBEval(bEval, bFor)
ELSE
	_M6Convert(@cFor, @bFor)
	bErr:= ErrorSys(.t.)
	BEGIN SEQUENCE
		lRes:= !(_M6Setcmdf(cFor) > 0)
	RECOVER
		lRes:= .T.
	END SEQUENCE
	Errorblock(bErr)
	IF !lRes
		DBEval(bEval)
		_M6Restcmd()
	ELSE
		IF bFor == Nil
			bFor:= Compile(cFor)
		ENDIF
		DBEval(bEval, bFor)
	ENDIF
ENDIF
