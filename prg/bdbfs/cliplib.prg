/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
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
/*
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
*/
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
PROC __dbSort(fDest, afields, ufor, uwhile, nNext, nRec, lRest, cRdd)
LOCAL	OldSel:=select(), OldOrder, cset:=set(_SET_CANCEL,.f.), ;
	aFlds:={}, count:=0, aStruct,i, cT, xVal, cFld, cFldN,;
	errMess:='DBSORT error', flag_err:=.f.,  err,;
	tmpfile, indString, bFor, lRes:=.F.

IF EMPTY(fDest) THEN RETURN .F.

IF VALTYPE(uFor)=='C' THEN uFor:=&("{||"+ uFor+"}")

IF VALTYPE(uWhile)=='C' THEN uWhile:=&("{||"+ uWhile+"}")
BEGIN SEQUENCE
	OldOrder:=OrdSetFocus()
	IF EMPTY(afields)
		aStruct:=DBSTRUCT_()
		FOR i=1 TO LEN(aStruct)
			AADD(aFlds, {aStruct[i][1], .f., .f.})
		NEXT
	ELSE
		FOR i=1 TO LEN(aFields)
			cFld:=UPPER(ALLTRIM(aFields[i]))
			Parce(cFld, '/', @cFldN)
			AADD(aFlds,{AllTrim(cFldN),"/D" $ cFld,"/C" $ cFld})
		NEXT
	ENDIF
	IF LEN(aFlds)==0
		errMess:="invalid argument"
		BREAK
	ENDIF

	indString:=""

	FOR i=1 TO len(aFlds)
		cFld:=aFlds[i,1]
		cT:=VALTYPE(&(cFld))
		xVal:=""
		DO CASE
			CASE cT $ "CM"
				IF cT=='M' THEN cFld:="PAD("+cFld+", 255)"
				xVal:=IF( aFlds[i,3],;
					"LOWER("+cFld+")",;
					 cFld)
			CASE cT=="D"
				xVal:="DTOS("+cFld+")"
			CASE cT=="N"
				xVal:="STR("+cFld+")"
			CASE cT=="L"
				xVal:="IF("+cFld+',"1","0")'
		ENDCASE
		IF aFlds[i][2]
			xVal:="DESCEND("+xVal+")"
		ENDIF
		indString+=xVal+"+"
	NEXT
	indString:=Strip(indString,1)

	tmpfile="clip_sort_tmp_file"+NTRIM(random(10000))

        ordCondSet(, ,;
		 !EMPTY(nNext) .OR. !EMPTY(nRec) .OR. !EMPTY(lRest), ;
		 uWhile, , , , nNext, nRec,  lRest, , .t.)

	DBCREATEINDEX( tmpfile , indString , {||&indString} , )
	lRes:=__dbcopy(fDest,{},uFor,,,,,cRdd)

RECOVER USING err
	flag_err:=.t.
END SEQUENCE

SELECT(OldSel)
DbClearIndex()
FERASE(tmpfile+Rdd_info()[4])
OrdSetFocus(OldOrder)

SET(_SET_CANCEL,cset)
IF flag_err
	   Nfind(ErrMess)
	   Break(err)
ENDIF
RETURN lRes
**********
FUNC __DBLOCATE(_bFor, _bWhile, _next, _rec, _rest, lBack)
LOCAL _lFound
CheckEsc(.T.)	//Счетчик
IF EMPTY(lBack)
	IF EMPTY(_next) .AND. EMPTY(_rest) THEN DbGoTop()
	IF_NIL _BFor IS {|| .T.}
	__Dbsetloc(_BFor)
ELSE
	_BFor:=__DbSetLoc()
	DBSkip()
ENDIF

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
FUNC __DBBACKLOCATE(_bFor, _bWhile, lCont)
LOCAL _lFound, nMuch
CheckEsc(.T.)
IF EMPTY(lCont)
	IF_NIL _BFor IS {|| .T.}
	IF_NIL _BWhile IS {|| .T.}
	__Dbsetloc(_BFor)
ELSE
	dbSkip(-1)
	_BFor:=__DbsetLoc()
ENDIF

nMuch:=KeyNo()-1
WHILE !BOF() .AND. !(eval(_BFor)) .AND. CheckEsc(, nMuch)
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
			{TRIM(FIELD->field_name),;
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
RETURN Dbcreate(NewBase,  __FlEdit(DbStruct_(),aFlds))
**********
FUNC __DBCOPYXS(NewBase)
LOCAL oldBase:=Select(), aFlds:=DbStruct_(), _error:= .F.,;
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
LOCAL aDest, aItem, i,n
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

RETURN Strip5(aDest)
**********
STATIC FUNC Strip5(aDest)
LOCAL aItem
IF LEN(aDest)>4
//Если массив не четырехмерный.
	FOR i:=1 TO LEN(aDest)
		aItem:=aDest[i]
		aDest[i]:={aItem[1], aItem[2], aItem[3], aItem[4]}
	NEXT
ENDIF
RETURN aDest
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
	Dbcreate(NewBase, Strip5(_aFlds), cRdd, .T., "_Nb")
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
FUNC __DbTransR(nSelect, aFields)
LOCAL i, cFld
(nSelect)->(DbAppend())
FOR i:=1 TO LEN(aFields)
	cFld:=aFields[i]
	IF VALTYPE(cFld)=='A' THEN cFld:=cFld[1]
	IF (nSelect)->(IsField(cFld)) .AND. IsField(cFld)
		(nSelect)->&(CFld) := &cFld
	ENDIF
	IF deleted()
		(nSelect)->(DbDelete())
	ENDIF
NEXT
**********
**********
FUNC RealSTRUCT(_handle,NeedForced)
LOCAL	aStr:={},i,nStart,nFld,;
	cfName,cfType,cfLen,cfDec,cfFlag,cFld:=SPACE(32),;
	cNewByte,cNewType,lWasMemo, lCpDBF, lWasVFP
#define DBASE4 CHR(139)+CHR(142)+CHR(123)+CHR(203)
nFld:=Fseek(_handle,0,2)	//Размер для проверки
FSeek(_handle,0)
Fread(_handle,@cFld,28)
//Тип базы, CDX_flag,CodePage
cNewType:=First(cFld)
nStart:=Bin2I(SUBSTR(cFld,9,2))		//Начало данных
IF nStart>nFld .OR. nStart<65 .OR. nFld<65 THEN RETURN aStr	//Фигня какая-то

m->__RealFlds:=ReadBin(_handle,0,nStart-36,1)
lCpDBF:=BETWEEN(CPDBF(),1200,1299)
m->_aCommon:={lCpDBF .AND. !EMPTY(m->_lForced),;//Вообще форсированна
	      cNewType,;			//Оригинал 1-го байта
	      cNewType,;			//Измененный 1-й байт
	      lCpDBF,;				//Надо OemToAnsi
	      .F.;				//Есть AutoInc
	      }

lWasMemo:=.F.
FSeek(_handle,32)
DO WHILE .T.	//окончание полей
	IF (Fread(_handle,@cFld,32) <>32) .OR.;
	   (First(cFld) == _ENTER) .OR.;
	   (FSeek(_handle,0,1)>nStart) THEN EXIT	//окончание полей

	cfName:=TRIM(FN_NoNull(cFld))
	IF lCpDBF
		cfName:=Translate_Charset('cp'+NTRIM(CpDBF()), host_charset(), cfName )
	ENDIF
	cfType:=SUBSTR(cFld,12,1)
	cfLen:=ASC(SUBSTR(cFld,17,1))
	cfDec:=ASC(SUBSTR(cFld,18,1))
	cfFlag:=ASC(SUBSTR(cFld,19,1))
// 1|2|4|12
// NOT VISIBLE | CAN STORE 0 | BINARY | AUTOINC

	cNewByte:=''
	DO CASE
		CASE cfType $ 'M'
			cNewByte:='M'	//Memo Flex, DBASE4
			IF cNewType $ DBASE4 THEN NeedForced:=2 //D4

		CASE cfType=='B' .AND. cNewType $ DBASE4
			cNewByte:='M'
			NeedForced:=2	//bmp D5

		CASE (cfType $ 'CNFLDYTGPBIX') .OR.;
		     (cfType=='V' .AND. cfLen > 2)	//известные
			IF cfType=='I' .AND. cfFlag=12
				cfType:='AI'
				m->_aCommon[6]:=.T.
			ENDIF
			IF cfType $ 'YTGPBIX' THEN lWasVFP:=.T.

		CASE cfType $ '4'	//Integer FS
			cNewByte:='V'

		CASE cfType $ '28'	//Short FS,Long FS,
			NeedForced:=3
			cNewByte:='C'

		CASE cfType=='0' .AND. cFName=='_NullFlags'
			lWasVFP:=.T.			
	
		OTHER	//Unknown
			NeedForced:=6
			cNewByte:='C'
	ENDCASE
	IF EMPTY(cNewByte)
		cNewByte:=cfType
	ELSE
		IF !EMPTY(m->_lForced) THEN m->_aCommon[1]:=.t.

		IF cNewByte=='M'
			lWasMemo:=.T.
			IF FileExist(ClearName()+'.DBV')	//FlexFile
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
	IF cFName<>'_NullFlags' .AND. cFName<>'_'
		AADD(aStr,{cFName,cNewByte,cfLen,cfDec,cfType,cfFlag})
	ENDIF
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

	IF !InList(ASC(cNewType),3,131,245,48,49)	//известные RDD
		FSeek(_handle,0)

		cNewType:=IF(cNewType $ DBASE4,;
			     CHR(131), CHR(3))

		IF !EMPTY(lWasVFP) THEN cNewType:="0"

		Fwrite(_handle,cNewType,1)
		m->_aCommon[3]:=cNewType
		m->_aCommon[1]:=.t.
	ENDIF
	NeedForced:=0	//Зафорсировали уже
ELSE
	IF cNewType $ DBASE4
		NeedForced:=2
	ELSEIF cNewType $ CHR(179)
		NeedForced:=3
	ELSEIF cNewType $ CHR(2)+CHR(251) .AND. EMPTY(NeedForced)
		NeedForced:=5
	ELSEIF !InList(ASC(cNewType),3,131,245,48,49) .AND. EMPTY(NeedForced)
		NeedForced:=IF(EMPTY(lWasVFP), 6, 1)
	ENDIF
ENDIF

RETURN aStr
**********
STATIC FUNC MakeRghtName(cFld)
LOCAL lRes,i,chr,cNew:=''
FOR i:=1 TO LEN(cFld)
	chr:=SUBSTR(cFld,i,1)
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
PROC MakeRealStr(cBase)
LOCAL hBase
IF VALTYPE(_aCommon)=='A' .AND. !EMPTY(_aCommon[1])	//ValType из-за старых мемо
	hBase:=FOPEN(cBase, 2)
	FSeek(hBase,0)
	Fwrite(hBase,m->_aCommon[2],1)
	FSeek(hBase,28)
	Fwrite(hBase,m->__RealFlds)
	FCLOSE(hBase)
ENDIF
**********
FUNC DbStruct_()		//В CH хуже
RETURN IF(SELECT()=1, m->__aDbStruct, DBStruct())

