/*
    Copyright (C) 2001  ITK
    Author  : Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
В основном, модификация стандартных клипперовских функций,
а также работа в "форсированном" режиме.
*/

#include "inkey.ch"
#include "common.ch"
#include "bdbfmsg.ch"
MEMVAR _tally
**********
FUNC ADIR(csPath, aNames, aSizes, aDates, aTimes, aAttrs)
LOCAL _aDir, _Path, i, el
LOCAL aN, aS, aD, aT, aA
IF !(SubStr(csPath, 2, 1) == ":" .OR. SubStr(csPath, 1, 1) == PATH_DELIM)
	_Path:=Set(7)
	IF (Len(_Path) > 0) .AND. !(Substr(_Path,-1) $ ":"+PATH_DELIM)
		_Path += IF(Len(_Path) == 1, ":", PATH_DELIM)
	ENDIF
	csPath:=_Path+csPath
ENDIF

IF ValType(_aDir:=Directory(cSPath,IF(ValType(aAttrs) == "A","HSD","")))<>"A"
	RETURN 0
ENDIF

/*Так хорошо, но параметры надо передавать по ссылке, что не соответствует
функции

aNames:={}
aSizes:={}
aDates:={}
aTimes:={}
aAttrs:={}
AEVAL(_aDir,{|el|;
	AADD(aNames,el[1]),;
	AADD(aSizes,el[2]),;
	AADD(aDates,el[3]),;
	AADD(aTimes,el[4]),;
	AADD(aAttrs,el[5]);
})
*/
FOR i:=1 TO LEN(_adir)
	el:=_aDir[i]
	aNames[i]:=el[1]
	IF ValType(aSizes) == "A"  THEN aSizes[i]:=el[2]
	IF ValType(aDates) == "A"  THEN aDates[i]:=el[3]
	IF ValType(aTimes) == "A"  THEN aTimes[i]:=el[4]
	IF ValType(aAttrs) == "A"  THEN aAttrs[i]:=el[5]
NEXT

RETURN LEN(_adir)
**********
FUNC AFIELDS(aName, aType, aLen, aDec)
LOCAL aStr, naStr, i, el
IF (Empty(aStr:= Dbstruct_())) THEN RETURN 0

naStr:= Min(Len(aStr),Len(aName))

FOR i:=1 To naStr
	el:=aStr[i]
	aName[i]:=el[1]

	IF (ValType(aType) == "A") THEN aType[i]:=el[2]
	IF (ValType(aLen) == "A") THEN aLen[i]:=el[3]
	IF (ValType(aDec) == "A") THEN aDec[i]:=el[4]
NEXT

RETURN naStr
**********
FUNC AFILL(Arg1, Arg2, Arg3, Arg4)

Aeval(Arg1, {|_1, _2| Arg1[_2]:= Arg2}, Arg3, Arg4)
RETURN Arg1
**********
FUNC ACLONE(aAr)
LOCAL aNew
IF ValType(aAr) = "A"
	aNew:={}
	AEval(aAr,{|el|AADD(aNew,IF(ValType(el) == "A",Aclone(el),el))})
ENDIF
RETURN aNew
**********
FUNC __DBCOPY(NewBase, aFlds, bFor, bWhile, nNext, nRec, lRest, cRdd)
LOCAL NewSelect, oldBase:=Select(), _aFlds, RetError, _error:= .F.,i

IF (Empty(_aFlds:= __Fledit(Dbstruct_(), aFlds))) THEN RETU .F.
BEGIN SEQUENCE
	Dbcreate(NewBase, _aFlds, cRdd, .T., "_nb")
	NewSelect:= Select()
	dbSelectArea(oldBase)
	__Dbtrans(NewSelect, _aFlds, bFor, bWhile, nNext, nRec, lRest)
RECOVER USING RetError
	_error:= .T.
END SEQUENCE
IF NewSelect <> Nil
	//m->_tally:=LASTREC()
	CLOSE (NewSelect)
ENDIF
dbSelectArea(oldBase)
IF (_error) THEN BREAK(RetError)

RETURN .T.
**********
FUNC __DBAPP(NewBase, aFlds, bFor, bWhile, nNext, nRec, lRest, cRdd)
LOCAL NewSelect, oldBase:=Select(), _aFlds, RetError, _error:= .F.
IF (Empty(_aFlds:= __Fledit(Dbstruct_(), aFlds))) THEN RETU .F.
BEGIN SEQUENCE
	dbUseArea(.T., cRdd, NewBase, "", .T., .T.)
	NewSelect:= Select()
	aFlds:= {}
	Aeval(Dbstruct(), {|_1| AAdd(aFlds, _1[1])})
	IF (!Empty(_aFlds:= __Fledit(_aFlds, aFlds)))
		__Dbtrans(oldBase, _aFlds, bFor, bWhile, nNext, nRec, lRest)
	ENDIF
RECOVER USING RetError
	_error:= .T.
END SEQUENCE
IF (NewSelect <> Nil) THEN dbCloseArea()

dbSelectArea(oldBase)
//_tally:=LASTREC()-nWas
IF _error THEN BREAK(RetError)

RETURN .T.
**********
EXTE SDF	// драйвер SDF
EXTE DELIM
**********
FUNC __DBDELIM( lCopy, NewBase, cDelim, aFlds, bFor, bWhile,;
		nNext, nRec, lRest, _Rdd)
LOCAL NewSelect, oldBase:= Select(), _aFlds, nFsize
IF_NIL lCopy IS .T.
IF_NIL _Rdd IS "DELIM"
IF (Empty(_aFlds:= __Fledit(Dbstruct_(), aFlds))) THEN RETURN .F.
IF lCopy
	Dbcreate(NewBase, _aFlds, _Rdd, .T., "_nb", cDelim)
	NewSelect:=Select()
	dbSelectArea(oldBase)
ELSE
	nFSize:=INT(FileSize(NewBase)/RecSize())
	IF !__Dbopensd(NewBase, _aFlds, _Rdd, .T., "_nSDF", cDelim ) THEN RETURN .F.
	NewSelect:=Select()
ENDIF

__Dbtrans(IF(lCopy,NewSelect,OldBase), _aFlds, bFor, bWhile, nNext, nRec,lRest,nFSize)

CLOSE (NewSelect)
dbSelectArea(oldBase)
RETURN .T.
**********
PROC __Dbtrans(fDest, _aFlds, bFor, bWhile, nNext,nRec, lRest,nFSize)
LOCAL	nSkip:=0, aFld, cTDest,cTsrc,cfName,cFld,i,lErr:=.F.,nDec
IF_NIL bWhile IS {||.T.}
IF_NIL bFor IS {||.T.}
IF_NIL nNext IS -1
IF (nRec <> Nil)
	dbGoto(nRec)
	lRest:=.T.
	nNext:= 1
ENDIF
ErrorSys(.t.)
CheckEsc(.T.)	//счетчик
IF EMPTY(lRest) THEN GO TOP
DO WHILE !EOF() .AND. Eval(bWhile) .AND. nNext-- # 0 .AND. CheckEsc(,nfSize)
	IF EVAL(bFor)
		nSkip++
		(fDest)->(DBAPPEND())
		IF DELETED() THEN (fDest)->(DBDELETE())
		FOR i:=1 TO LEN(_aFlds)
			aFld:=_aFlds[i]
			cfName:=aFld[1]
			cTSrc:=VALTYPE(&cfName)
			cTDest:=aFld[2]
			BEGIN SEQU
				(fDest)->&cfName:=IF( cTdest<>cTsrc,;
							XTOY(&cfName,cTDest),;
							&cfName)
			RECOVER
				lErr:=.T.
				IF cTdest=='N'	//переполнение
				   nDec:=aFld[4]
				   cTSrc:=REPL('9',aFld[3]-nDec-1)+;
					  IF(nDec>0,;
						'.'+REPL('9',nDec),;
						'9')
				   (fDest)->&cfName:=VAL(cTSrc)
				ENDIF
			END
		NEXT
	ENDIF
	DBSKIP()
ENDDO
m->_tally:=nSkip
Meter(3)
ErrorSys()
IF lErr THEN NFIND(_MSG_CL_NOF)
**********
FUNC __DBSORT(NewBase, aFlds, bFor, bWhile, nNext, nRec, lRest)
LOCAL NewSelect, oldBase:=Select(), _aFlds, RetError, _error:= .F.
_aFlds:= DbStruct_()
BEGIN SEQUENCE
	Dbcreate(NewBase, _aFlds, Nil,.T., "_nb")
	NewSelect:= Select()
	dbSelectArea(oldBase)
	__Dbarrang(NewSelect, _aFlds, bFor, bWhile, nNext, nRec, lRest, aFlds)
RECOVER USING RetError
	_error:= .T.
END SEQUENCE
IF (NewSelect <> Nil)
	dbSelectArea(NewSelect)
	_tally:=LASTREC()
	dbCloseArea()
ENDIF
dbSelectArea(oldBase)
IF _error THEN BREAK(RetError)

RETURN .T.
**********
FUNC __DBLOCATE(_bFor, _bWhile, _next, _rec, _rest)
LOCAL _lFound
CheckEsc(.T.)	//Счетчик
IF EMPTY(_next) .AND. EMPTY(_rest) THEN DbGoTop()
IF_NIL _BFor IS {|| .T.}
__Dbsetloc(_BFor)

IF EMPTY(_bWhile) .AND. EMPTY(_next)
	WHILE (!EOF() .AND. !(eval(_BFor))) .AND. CheckEsc()
		dbSkip()
	END
ELSE
	WHILE !EOF() .AND. _next-- > 0 .AND. eval(_BWhile) .AND. ;
	      !(eval(_BFor)) .AND. CheckEsc()
		dbSkip()
	END
END
_lFound:=!EOF() .AND. Eval(_bFor)
__Dbsetfou(_lFound)
RETURN _lFound
**********
FUNC __DBCONTIN
LOCAL _lFound, _bFor:=__DbsetLoc()
CheckEsc(.T.)
dbSkip()
WHILE !EOF() .AND. !eval(_bFor) .AND. CheckEsc()
	dbSkip()
END
_lFound:=!EOF() .AND. Eval(_bFor)
__Dbsetfou(_lFound)
RETURN _lFound
**********
FUNC __DBBACKLOCATE(_bFor, _bWhile)
LOCAL _lFound
CheckEsc(.T.)
IF_NIL _BFor IS {|| .T.}
IF_NIL _BWhile IS {|| .T.}
__Dbsetloc(_BFor)

WHILE !BOF() .AND. !(eval(_BFor)) .AND. CheckEsc()
	dbSkip(-1)
END
_lFound:=!BOF() .AND. Eval(_bFor)
__Dbsetfou(_lFound)
RETURN _lFound
**********
FUNC __DBBACKCONTIN
LOCAL _lFound, _bFor:=__DbsetLoc()
CheckEsc(.T.)
dbSkip(-1)
WHILE !BOF() .AND. !eval(_bFor) .AND. CheckEsc()
	dbSkip(-1)
END
_lFound:=!BOF() .AND. Eval(_bFor)
__Dbsetfou(_lFound)
RETURN _lFound
**********
FUNC CheckEsc(lStart,nTotal)
STATIC nLast
IF EMPTY(lStart)
	IF _tally >= nLast
		IF Inkey()==K_ESC THEN RETURN .F.
		nLast+=m->_sx_step
		IF !EMPTY(m->_lMeter) THEN Meter(2,,_tally,nTotal)	//nTotal только для SDF
	ENDIF
	_tally++
ELSE		//обнуление
	nLast:=m->_sx_step
	m->_tally:=0
ENDIF
RETURN .T.
**********
FUNC BD_DbEval(bEval,bFor,bWhile,nNext,nRec,lRest)
LOCAL nCnt:=0
IF_NIL bEval IS {||.T.}
IF_NIL bFor IS {||.T.}
CheckEsc(.T.)
DO WHILE !EOF() .AND. CheckEsc()
	IF EVAL(bFor)
		nCnt++
		Eval(bEval)
	ENDIF
	DBSKIP()
ENDDO
Meter(3)
GO m->_tmr
RETURN _tally:=nCnt
**********
FUNC __DBCREATE(NewBase, Struc_Ext, cRdd, lNew, cAlias)
LOCAL Ar_Str := {}, _error, i, nSel:=Select()
IF_NIL lNew IS .F.
IF VALTYPE(cAlias)=='C'
	IF Parce(cAlias,':',,@i)<>0 THEN cAlias:=i
	IF Parce(cAlias,PATH_DELIM,,@i)<>0 THEN cAlias:=i
	Parce(cAlias,'.',@cAlias)
ENDIF

IF (Used() .AND. !lNew) THEN dbCloseArea()

BEGIN SEQUENCE
	IF (Empty(Struc_Ext))
		Dbcreate(NewBase,{{"FIELD_NAME", "C", 10, 0}, ;
				{"FIELD_TYPE", "C", 1, 0}, {"FIELD_LEN", "N", 3, 0}, ;
				{"FIELD_DEC", "N", 3, 0}}, cRdd, .F., cAlias)
	ELSE
		dbUseArea(lNew, Nil, Struc_Ext)
		DBEval({|| AAdd(Ar_Str,;
			{FIELD->field_name,;
			 FIELD->field_type,;
			 FIELD->field_len,FIELD->field_dec})})
		dbCloseArea()
		IF lNew THEN dbSelectArea(nSel)
		Aeval(Ar_Str, {|_1| IIF(_1[2] == "C" .AND. _1[4] <> 0, ;
			_1[3]:= _1[3] + _1[4] * 256, Nil)})
		Dbcreate(NewBase, Ar_Str, cRdd, lNew, cAlias)
	ENDIF
RECOVER USING _error
	dbCloseArea()
	BREAK(_error)
END SEQUENCE
RETURN Used()
**********
FUNC __DBCOPYST(NewBase, aFlds)
RETURN Dbcreate(NewBase,  Strip5(__FlEdit(DbStruct_(),aFlds)) )
**********
FUNC __DBCOPYXS(NewBase)
LOCAL	oldBase:=Select(), aFlds:=DbStruct_(), _error:= .F.,;
	sa:=SET(_SET_AUTOPEN, .F.)
*IF Empty(aFlds) THEN RETU .F.

BEGIN SEQUENCE
	dbSelectArea(0)
	__dbCreate(NewBase)
	USE (NewBase)

	Aeval(aFlds, {|_1| (IF(_1[2] == "C" .AND. _1[3] > 255, ;
		(_1[4]:= Int(_1[3] / 256), _1[3]:= _1[3] % 256), Nil), .F.)})
	Aeval(aFlds, {|_1| dbAppend(), FIELD->field_name:= _1[1], ;
		FIELD->field_type:= _1[2], FIELD->field_len:= _1[3], ;
		FIELD->field_dec:= _1[4], .F.})

RECOVER
	_error:= .T.
END SEQUENCE
SET(_SET_AUTOPEN, sa)
IF (Select() <> oldBase)
	dbCloseArea()
	dbSelectArea(oldBase)
ENDIF
IF _error THEN BREAK(_error)
RETURN .T.
**********
FUNC __FLEDIT(aEtalon, aTrans)
LOCAL aDest,i,n
IF EMPTY(aTrans)
	aDest:=aEtalon
ELSE
	aDest:={}
	FOR i:=1 TO LEN(aTrans)
		IF (n:=ASCAN(aEtalon,{|aE| aE[1]==UPPER(TRIM(aTrans[i]))}))<>0
			AADD(aDest,aEtalon[n])
		ENDIF
	NEXT

ENDIF
RETURN aDest
**********
PROC __SETFUNCT(Key, cText)
SetKey(IF(Key == 1, 28, 1-Key),;
	IF(ValType(cText) <> "C" .OR. Empty(cText),Nil,;
						   {|| __Keyboard(cText)});
      )
**********
PROC __SETHELPK
SetKey(28, {|_1| __Xhelp(_1)})

**********
FUNC __SetCentu(xPar)
LOCAL lFull, cyFmt:= UPPER(Set(_SET_DATEFORMAT))
IF ValType(xPar) == "C" THEN xPar:= (UPPER(xPar) = "ON")
lFull:= "YYYY" $ cyFmt
IF (ValType(xPar) == "L") .AND. (xPar <> lFull)
	SET(_SET_DATEFORMAT,IF(xPar, StrTran(cyFmt,'Y','YY'),;
				StrTran(cyFmt,'YY','Y') ) )
ENDIF
RETURN lFull

**********
FUNC DBTrans(NewBase, aFlds, bFor, bWhile, nNext,lRest,cRdd )
LOCAL	NewSelect, oldBase:=Select(), _aFlds:={},_aEt:=m->___aDbStruct,;
	i,j,_type,_len,_dec,aTemp,cF,cFN,RetError, _error:= .F.,_tally
LOCAL	bAct:={||_Nb->(DBAPPEND()),;
		AEval(_aFlds,{|el| (NewSelect)->&(el[1]):=&(el[5])}),;
		IF(DELETED(),(NewSelect)->(DBDELETE()),NIL) }

IF ValType(aFlds)=='C'
	aFlds:= IF( LEFT(aFlds,1)='{', &aFlds, SplitLine(aFlds) )
ENDIF

ErrorSys(.t.)
_Tally:=0
FOR i:=1 TO LEN(aFlds)
	cF:=UPPER(aFlds[i])
	IF Parce(cF,' AS ',@cF, @cFn) = 0 THEN cFn:=cF
	cF:=ALLTRIM(cF)		//а вдруг пробелы перед AS или после запятой
	cFn:=ALLTRIM(cFn)

	IF (j:=AMScan(_aEt,1,cF))<>0
		aTemp:=Aclone(_aEt[j])
		aTemp[1]:=cFn
		AADD(aTemp,cF)
		AADD(_aFlds,aTemp)
	ELSE
		BEGIN SEQU
			_dec:=0
			j:=&cf
			_type:=ValType(j)
			DO CASE
				CASE _type=='N'
					IF j<>INT(j) THEN _dec:=SET(_SET_DECIMALS)
					_len:=16 //LENNUM(i)
				CASE _type=='C'
					_len:=LEN(j)
				CASE _type=='L'
					_len:=1
				CASE _type=='D'
					_len:=8
				OTHER		//_type=='M' и возможно A
					_len:=10
			END
			j:=IF(cF==cFN,'EXP_'+NTRIM(i),cFN)
			AADD(_aFlds,{j,_type,_len,_dec,cF})
		END SEQU

	ENDIF

NEXT
BEGIN SEQUENCE
	IF EMPTY(_aFlds) THEN BREAK
	Dbcreate(NewBase, _aFlds, cRdd, .T., "_Nb")
	NewSelect:= Select()
	dbSelectArea(oldBase)
	BD_DBEVAL(bAct,bFor, bWhile, nNext, , lRest)
RECOVER USING RetError
	_error:= .T.
END SEQUENCE
ErrorSys()

IF NewSelect <> Nil THEN CLOSE (NewSelect)
dbSelectArea(oldBase)
Meter(3)
IF EMPTY(_aFlds) THEN NFIND(_MSG_CL_NOONE)
IF (_error) THEN BREAK(RetError)

RETURN _tally
**********
FUNC __DBTOTAL(NewBase, bKey, aFlds, bFor, bWhile, nNext,nRec, lRest)
LOCAL OldBase, NewSelect, aTotal, aSumFields, aSums, lWasKey, xKeyVal, ;
	RetError, _Error:= .F.,nSkip:=0,i,nCount
IF (bWhile == Nil)
	bWhile:= {|| .T.}
ELSE
	lRest:= .T.
ENDIF
IF_NIL bFor IS {|| .T.}
IF_NIL lRest IS .F.
IF (nNext == Nil)
	nNext:= -1
ELSE
	lRest:= .T.
ENDIF
IF !lRest THEN dbGoTop()
OldBase:= Select()

/* Так в стандарте
aTotal:= {}
Aeval(Dbstruct(), {|_1| IIF(_1[2] == "M", Nil, AAdd(aTotal, _1))})

IF (Empty(aTotal))
	RETURN .F.
ENDIF
*/
aTotal:=DbStruct_()	//да мы и Memo возьмем
CheckEsc(.T.)	//счетчик

BEGIN SEQUENCE
	aSumFields:= {}

	FOR i:=1 TO LEN(aFlds)
		IF TYPE(xKeyVal:=aFlds[i])=='N' THEN;
			AAdd(aSumFields, FieldBlock(xKeyVal))
		*IF !EMPTY (nRec:=Getfield(aFlds[i]) );
		*	THEN AAdd(aSumFields, nRec )	//FieldBlock()
	END

	aSums:= Array(Len(aSumFields))
	Dbcreate(NewBase, aTotal, , .T., "_nb")
	NewSelect:= Select()
	dbSelectArea(OldBase)
	WHILE (!EOF() .AND. nNext <> 0 .AND. eval(bWhile)) .AND. CheckEsc()
		lWasKey:= .F.
		Afill(aSums, 0)
		xKeyVal:= eval(bKey)
		nCount:=0

		WHILE (!EOF() .AND. nNext-- <> 0 .AND. eval(bWhile) .AND. ;
				xKeyVal == eval(bKey))
			IF eval(bFor)
				nSkip++
				IF !lWasKey
					__Dbtransr(NewSelect, aTotal)
					dbSelectArea(OldBase)
					lWasKey:= .T.
				ENDIF
				Aeval(aSumFields, {|_1, _2| aSums[_2]:= aSums[_2] + ;
					eval(_1)})
				nCount++
			ENDIF
			dbSkip()
		END
		IF lWasKey
			(NewSelect)->(Aeval(aSumFields, {|_1, _2| eval(_1, aSums[_2])}))
		ENDIF
		IF IsField('TotalCount')
			(NewSelect)->TotalCount:=nCount
		ENDIF
	END
RECOVER USING RetError
	_Error:= .T.
END SEQUENCE
m->_tally:=nSkip
IF NewSelect <> Nil THEN CLOSE (NewSelect)
dbSelectArea(OldBase)
IF _Error THEN BREAK(RetError)

RETURN .T.
**********
FUNC MemoWrit(cFile,cStr)
LOCAL h:=FCREATE(cFile),Res
IF h>0
	Res:=FWRITE(h,cStr)
	FCLOSE(h)
ENDIF
RETURN (h>0) .AND. Res>=0
**********
**********
FUNC RealSTRUCT(_handle)
LOCAL	aStr:={},i,nStart,nFld,;
	cfName,cfType,cfLen,cfDec,cfFlag,cFld:=SPACE(32),;
	cNewByte,cNewType,lWasMemo, lCpDBF

*m->lWasFoxPro:=m->lWasDBASE5:=m->lWasFlagShip:=lWasUnknown:=.F.
*FSeek(_handle,0)	//И так - в начале
Fread(_handle,@cFld,28)
//Тип базы, CDX_flag,CodePage
cNewType:=First(cFld)
nStart:=Bin2I(SUBSTR(cFld,9,2))		//Начало данных

m->__RealFlds:=ReadBin(_handle,0,nStart-36,1)
lCpDBF:=BETWEEN(CPDBF(),1200,1299)
m->_aCommon:={lCpDBF .AND. !EMPTY(m->_lForced),;//Вообще форсированна
	      cNewType,;			//Оригинал 1-го байта
	      cNewType,;			//Измененный 1-й байт
	      lCpDBF,;				//Надо OemToAnsi
	      .F.}				//FlexMemo

lWasMemo:=.F.
FSeek(_handle,32)
DO WHILE .T.	//окончание полей
	IF (Fread(_handle,@cFld,32) <>32) .OR.;
	   (First(cFld) == _ENTER) THEN EXIT	//окончание полей

	cfName:=FN_NoNull(cFld)
	cfType:=SUBSTR(cFld,12,1)
	cfLen:=ASC(SUBSTR(cFld,17,1))
	cfDec:=ASC(SUBSTR(cFld,18,1))
	*cfFlag:=.F.
	*cfFlag:=ASC(SUBSTR(cFld,19,1))	// 1|2|4
					// NOT VISIBLE | CAN STORE 0 | BINARY

	cNewByte:=''
	DO CASE
		CASE cfType $ 'GPM' .OR.; //general FP,D5, picture Fp, Memo
		     (cfType=='B' .AND. cfLen==10) //bmp D5
			cNewByte:='M'	//Проверить надо будет на VFP
/*
		CASE cfType=='V' .AND. cfLen < 3	//Ошибка в драйвере SIX
			cNewByte:='C'
			*cfType:='2'	//Заносятся пробелы и неверно интерпретируются
*/
		CASE (cfType $ 'CNFLD') .OR.;
		     (cfType=='V' .AND. cfLen > 2)	//известные

		CASE cfType $ 'I4'	//Integer Fp or FS
			cNewByte:='V'

		OTHER	//Y,T,2,8... Currensy Fp, DateTime, Short FS,Long FS,Unknown
			cNewByte:='C'
	ENDCASE

	IF EMPTY(cNewByte)
		cNewByte:=cfType
	ELSEIF !EMPTY(m->_lForced)
		m->_aCommon[1]:=.t.

		IF cNewByte=='M'
			lWasMemo:=.T.
			IF cfLen=4
				cNewByte:='C' //VFP-Мемо
			ELSEIF cNewType='ї'
				cNewByte:='N'
			ELSEIF FileExist(ClearName()+'.DBV')	//FlexFile
				cNewByte:='C'
				*cfFlag:=.T.
				m->_aCommon[5]:=.T.
			ENDIF
		ENDIF

	ENDIF

	IF m->_lForced
		IF lCpDBF THEN cFName:=AnsiToOem(cFName)
		IF MakeRghtName(@cFName) THEN m->_aCommon[1]:=.T.
	ENDIF
	IF m->_aCommon[1]
		cFld:=PAD(cFname,11,CHR(0))+;
			 cNewByte+;
			 SUBSTR(cFld,13,5)+;
			 IF(cfType $ 'YB', CHR(0), CHR(cfDec))+;
			 SUBSTR(cFld,19)
		FSeek(_handle,-32,1)
		FWrite(_handle,cFld)
	ENDIF
	*AADD(aStr,{cFName,cNewByte,cfLen,cfDec,cfType,cfFlag})
	AADD(aStr,{cFName,cNewByte,cfLen,cfDec,cfType})
ENDDO
IF !EMPTY(m->_lForced)
	i:=FSeek(_handle,0,1)

	IF i < nStart	//Не в начале данных, н-р контейнер FoxPro нашли
		i:=i-32	//Позиция ENTER
		FSEEK(_handle,i)

		cFld:=' '+REPL(CHR(0),10)+'C'+REPL(CHR(0),4)+CHR(1)+;
		      CHR(0)+CHR(1)+REPL(CHR(0),13)
		nFld:=(nStart-i) % 32
		FOR i:=1 TO nFld
			FWRITE(_handle,cFld,32)
			AADD(aStr,{'','',1,0,'C',CHR(1)})
		NEXT
		FWRITE(_handle,_ENTER,1)
	ENDIF

//	IF cNewType $ '√CcО{╦0'
	IF InList(ASC(cNewType),2,251,4,5,67,99,142,123,203,48)
//Различный dBase4-5, FoxBase,
//xB3 - FlagShip, возможно с мемо
		FSeek(_handle,0)

		cNewType:=IF(cNewType=='0' .AND. lWasMemo,;
			     CHR(245),;
			     IF(InList(ASC(cNewType),2,251,4,5,67,99,48), CHR(3),CHR(139));
			     )

		Fwrite(_handle,cNewType,1)
		m->_aCommon[3]:=cNewType
		m->_aCommon[1]:=.t.
	ENDIF
ENDIF

RETURN aStr
**********
STATIC FUNC MakeRghtName(cFld)
LOCAL lRes,i,chr,cNew:=''
FOR i:=1 TO LEN(cFld)
	chr:=SUBSTR(cFld,i,1)
	*IF !( IsDigit(chr) .OR. IsAlpha(chr) )
	IF !( (chr $ '0123456789_') .OR. IsAlpha(chr) )
		chr:='_'
	ENDIF
	cNew+=chr
NEXT
IF cNew < 'A' THEN cNew:='_'+cNew
lRes:=(cFld<>cNew)
cFld:=cNew	//По ссылке
RETU lRes
**********
PROC MakeRealStr()
IF VALTYPE(_aCommon)=='A' .AND. !EMPTY(_aCommon[1])	//ValType из-за старых мемо
	m->_MainHandle:=FOPEN(m->_base)
	FSeek(m->_MainHandle,0)
	Fwrite(m->_MainHandle,m->_aCommon[2],1)
	FSeek(m->_MainHandle,28)
	Fwrite(m->_MainHandle,m->__RealFlds)
	FCLOSE(m->_MainHandle)
ENDIF
**********
FUNC DbStruct_()		//В CH хуже
RETURN IF(SELECT()=1, m->__aDbStruct, DBStruct())

**********
STATIC FUNC Strip5(aFlds)
LOCAL i, aNew:={}, aItem
FOR i:=1 TO LEN(aFlds)
	aItem:=aFlds[i]
	*ACOPY(aFlds[i], aItem, 1, 4)
	AADD(aNew, {aItem[1], aItem[2], aItem[3], aItem[4]})
NEXT
RETURN aNew
