/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

// FoxPro and FlexMemo Functions emulation

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
#include "set.ch"
**********
FUNC Alen(aArr,nDim)
LOCAL aCol,nLen:=0
IF !EMPTY(aArr) .AND. ValType(aArr)=='A'
	nLen:=LEN(aArr)
	aCol:=aArr[1]
	IF nDim # 1		//Lines
		IF EMPTY(nDim)	//Elements
			IF ValType(aCol)='A' THEN nLen:=nLen*LEN(aCol)
		ELSE	//Columns
			nLen:=IF( ValType(aCol)='A', LEN(aCol), 0)
		ENDIF
	ENDIF
ENDIF
RETURN nLen
**********
FUNC AnsiToOem(cStr)
RETURN IF( VALTYPE(cStr)<>'C', '', ChrTran(cStr,m->_Ansi_Set,m->_Oem_Set))
**********
FUNC OemToAnsi(cStr)
RETURN IF( VALTYPE(cStr)<>'C', '', ChrTran(cStr,m->_Oem_Set,m->_Ansi_Set))
**********
FUNC AtC(cStr1,cStr2,nTh)
RETURN FT_AT2(cStr1,cStr2,nTh,.F.)
**********
FUNC Cdx()
RETURN m->__CdxName
**********
FUNC Ceiling(nVal)
LOCAL cI:=INT(nVal)
IF cI<>nVal .AND. nVal>0 THEN cI++
RETURN cI
**********
FUNC DMY(dVal)
#IFDEF ENGLISH
	LOCAL cDate:=DTOS(dVal)
	RETURN NTRIM(Day(dVal))+' '+Cmonth(dVal)+;
		IF(__SetCentury(),LEFT(cDate,4),SUBSTR(cDate,3,2))
#ELSE
	RETURN SayData(dVal)
#ENDIF
RETU .T.
**********
FUNC Evaluate(xPr)
RETURN EVAL(COMPILE(xPr))
**********
FUNC Filter()
RETURN DBFilter()
**********
FUNC Floor(nVal)
LOCAL cI:=INT(nVal)
IF (cI<>nVal) .AND. (nVal<0) THEN cI--
RETURN cI
**********
FUNC GoMonth(dExpr,nMth)
RETURN FT_MADD(dExpr,nMth)
**********
FUNC IsBlank(xPr)
RETURN IF( VALTYPE(xPr)=='C',;
	  EMPTY(xPr) .AND.;
	  	 !( (CHR(9) $ xPr) .OR. (CHR(13) $ xPr) .OR. (CHR(10) $ xPr)),;
	  EMPTY(xPr))
**********
FUNC Key(nExpr)
RETURN OrdKey(nExpr)
**********
FUNC Ndx()
RETURN m->_oldind
**********
FUNC Occurs(cExp1,cExp2)
RETURN FT_NOOCCUR(cExp1,cExp2,.F.)
**********
FUNC Pi()
RETURN 3.141592
**********
FUNC Proper(cExpr)
LOCAL cEx1:=cExpr,cRes:=''
WHILE Parce(LTRIM(cEx1),' ',@cExpr, @cEx1)<>0
	cRes+=Capitalz(cExpr)+' '
END
RETURN cRes+Capitalz(cExpr)
**********
FUNC Seek(xPr,xArea)
IF_NIL xArea IS 1
RETURN (xArea)->(DBSEEK(xPr))
**********
FUNC Sign(nVal)
RETURN nVal/ABS(nVal)
**********
FUNC Sys(_number,_par2,_par3)
STATIC inum:=1
LOCAL _sys:='',i

DO CASE
	CASE _number=2
		_sys:= Seconds()

	CASE _number=3
		_sys:=FT_TempFile()

	CASE _number=5
		_sys:= Name_Disk()

	CASE _number=6
		_sys:= Set(_SET_PRINTER)

	CASE _number=12
		_sys:= Memory(0)

	CASE _number=13
		_sys:= IF(IsPrinter(),'READY','OFFLINE')

	CASE _number=14
		_par3:=Sx_TagInfo()
		_sys:= IF(Between(_par2,1,Len(_par3)),_Par3[_par2,2],'')

	CASE _number=15
		_sys:=''
		FOR i:=1 TO LEN(_par3)
			_sys += SUBSTR(_par2,ASC(SUBSTR(_par3,i,1)),1)
		NEXT

	CASE _number=16
		_sys:= GetPath()

	CASE _number=21
		_sys:= IndexOrd()

	CASE _number=22
		IF EMPTY(_par2)
			_sys:= SX_TagName()
		ELSE
			_par3:=Sx_TagInfo()
			_sys:=IF(Between(_par2,1,Len(_par3)),_Par3[_par2,1],'')
		ENDIF

	CASE _number=23
		_sys:= Memory(3)

	CASE _number=1001
		_sys:= Memory(0)+Memory(3)

	CASE _number=2000
		IF Empty(_par3) THEN inum:=1
		_par3:=DIRECTORY(_par2)
		_sys:= _par3[inum++,1]

	CASE _number=2003
		_sys:= CurDir()

	CASE _number=2012
		_sys:= SX_SetMemoBlock(_par2)

	CASE _number=2020
		_sys:= DiskSpace()

	CASE _number=2021
		_par3:=Sx_TagInfo()
		_sys:= IF(Between(_par2,1,Len(_par3)),_Par3[_par2,3],'')

ENDCASE
RETURN _sys
**********
FUNC CpDBF()
RETURN {0,437,620,737,850,852,857,861,865,866,895,;
	1250,1251,1252,1253,1254,;
	10000,10006,10007,10029;
	}[AT(SUBSTR(m->__RealFlds,2,1),CHR(1)+'ij'+CHR(2)+'dkgfeh'+;
		    CHR(200)+CHR(201)+CHR(3)+CHR(203)+CHR(202)+CHR(4)+'˜–—')+1] // utf-8: 'Ð¨Ð¦Ð§'
*********
FUNC ShowForced(xFld,nEl)
LOCAL cType,nLen
cType:=m->_FrType[nEl]
DO CASE
	CASE cType $ 'MGP'
		xFld:=IF(MemoEmpty(xFld),'memo','MEMO')
	CASE cType=='2'
		xFld:=Bin2I(xFld)
*	CASE cType=='8'
*		xFld:=CTOF(xFld)
ENDCASE
RETURN xFld
**********
FUNC xToForced(cVal,cType,cFld)
IF ValType(cVal)=='C'
	IF cType $ '2'
		DO CASE
			CASE cType=='2'
				cVal:=I2BIN(cVal)
*			OTHER
		ENDCASE
	ELSE 	//Memo
		cVal:=MemoPut(cFld,cVal)
	ENDIF
ELSE
	cVal:=NIL
ENDIF
RETU cVal
**********
FUNC PictForced(cType,nEl)
RETURN IF(cType=='2','999999',)

**********
FUNC DateTime(nYear,nMonth,nDay,nHours,nMins,nSecs)
LOCAL cDate
IF PCOUNT()=0
	cDate:=DTOC(DATE())+' '+TIME()
ELSE
	cDate:=IF( EMPTY(nYear) .OR. EMPTY(nMonth) .OR. EMPTY(nDay),;
		'',;
		STR(nYear,4)+StrZero(nMonth,2)+StrZero(nDay,2);
		)

	IF_NIL nHours IS 0
	IF_NIL nMins IS 0
	IF_NIL nSecs IS 0
	cDate:= DTOC(FT_STOD(cDate))+' '+;
		StrZero(MIN(nHours,59),2)+':'+;
		StrZero(MIN(nMins,59) ,2)+':'+;
		StrZero(MIN(nSecs,59) ,2)
ENDIF
RETURN cDate
**********
FUNC MemoSrc(cFld,nbSize,nPos,cType)	//"Manual" VFP-fields reading
LOCAL h,cT,cf1,cf2, cMemo
IF MemoEmpty(cFld)
	cFld:=''
	nPos:=0
	nbSize:=0
	cType:='0'+CHR(3)	//For DbFlex
ELSEIF m->_aCommon[5]	//DbFlex
	nPos:=Bin2L(SUBSTR(cFld,5))
	nbSize:=Bin2L(cFld)
	cMemo:=ClearName()
	IsFileExist(@cMemo, '.DBV', , .F.)
	h:=FOPEN(cMemo,64)
	cType:=ReadBin(h,nPos+4,2)
ELSE
	*h:=m->_MainHandle+1
	h:=FOPEN(m->_MainMemoFile)
	nPos:=IF( VALTYPE(cFld)=='C',Bin2L(cFld),cFld) * m->_MemoBlSize
	nbSize:=FN_Bin2I(ReadBin(h,nPos+4,4) )

ENDIF
cFld:=ReadBin(h,0,MIN(nbSize,64512),1)
IF m->_aCommon[5]
	cT:=SUBSTR(cType,2)
	IF cT==CHR(4)		//DATE
		cFld:=SXDate(Bin2L(cFld))
	*ELSEIF cT==CHR(3)		//CHAR
	ELSEIF cT==CHR(12)	//LOGICAL
		cFld:=(First(cFld)#CHR(0))
	ELSEIF cT==CHR(7)		//Array
		cFld:=Bin2Arr(cFld)
	ELSEIF cT==CHR(9)	//Num short
		cFld:=Bin2I(SUBSTR(cFld,3))
	ELSEIF cT==CHR(14)		//Num Long
		cFld:=CTOF(SUBSTR(cFld,-8))
	ENDIF

	FCLOSE(h)
ENDIF
RETURN cFld
**********
#xtranslate NBlocks(<nLen>) => Ceiling(<nLen> / m->_MemoBlSize)* m->_MemoBlSize
FUNC MemoPut(cFld,cNew)
LOCAL nOldSize,nNewSize,nPos,cType,cT,lNew,h,nSize, cMemo

IF cNew==NIL THEN RETURN NIL

MemoSrc(cFld,@nOldSize,@nPos,@cType)
cMemo:=ClearName()
IsFileExist(@cMemo, '.DBV', , .F.)
IF (h:=FOPEN(IF( m->_aCommon[5], cMemo, m->_MainMemoFile), ;
		66)) < 0 THEN RETURN NIL

nSize:=FSeek(h,0,2)

IF m->_aCommon[5]	//DbFlex
	cT:=VALTYPE(cNew)
	IF cT=='C'		//All right
		IF LEN(TRIM(cNew))==0 THEN RETU SPACE(10)
		cType:='C'+CHR(3)
	ELSEIF cT=='D'
		cNew:=L2Bin(SXNum(cNew))
		cType:='D'+CHR(4)
	ELSEIF cT=='L'
		cNew:=IF(cNew,'~',CHR(0))+REPL(CHR(0),3)
		cType:='L'+CHR(12)
	ELSEIF cT=='A'		//Array
		cNew:=Arr2Bin(cNew)
		cType:='A'+CHR(7)
	ELSEIF cT=="N" .AND. ABS(cNew)<32750
		cNew:=CHR(10)+CHR(0)+I2Bin(cNew)
		cType:='2'+CHR(9)
	ELSEIF cT $ 'NF' .AND. ABS(cNew)>=32750
		cNew:=CHR(8)+CHR(0)+CHR(10)+REPL(CHR(0),3) +FTOC(cNew)
		cType:='8'+CHR(14)
	ELSE
		cNew:=CHR(0)
		cType:=CHR(0)+CHR(0)
	ENDIF
	lNew:=(LEN(cNew) > nOldSize) .AND.;
		(nPos+nOldSize+6 < nSize)	//Tail can be rewritten
ELSE
	cNew:=FT_XTOY(cNew,'C')
	IF LEN(TRIM(cNew))==0 THEN;
		RETU IF( VALTYPE(cFld)=='C', REPL(CHR(0),4), 0 )

	cNew:=REPL(CHR(0),3)+CHR(1)+ FN_I2Bin(LEN(cNew),4) + cNew
	nNewSize:=NBlocks(LEN(cNew))
	cNew:=PAD(cNew, nNewSize, CHR(0))
	IF nOldSize>0 THEN nOldSize:=NBlocks((nOldSize+8))
	lNew:= (nOldSize < nNewSize) .AND. nPos + nOldSize < nSize
ENDIF

IF lNew
	nPos:=nSize
ELSE
	FSeek(h,nPos)
ENDIF
IF m->_aCommon[5]
	FWRITE(h,L2BIN(LEN(cNew))+cType+cNew)
	nPos:=L2BIN(LEN(cNew))+L2BIN(nPos)+cType
	FCLOSE(h)
ELSE
	FWRITE(h,cNew)
	nPos:=INT(nPos/m->_MemoBlSize)
	IF VALTYPE(cFld)=='C' THEN nPos:=L2Bin(nPos)
ENDIF
RETU nPos
**********
FUNC Bin2Arr(cStr)
LOCAL nSize,i,xItem,cT,aRes,nLen

nSize:=Bin2I(LEFT(cStr,2))
aRes:=ARRAY(nSize)

cStr:=SUBSTR(cStr,3)
FOR i:=1 TO nSize
	cT:=First(cStr)
	DO CASE
		CASE cT==CHR(7)	//Char
			nLen:=Bin2I(SUBSTR(cStr,2,2))
			xItem:=SUBSTR(cStr,4,nLen)
			cStr:=SUBSTR(cStr,nLen+4)
		CASE ct $ CHR(19)+CHR(20)	//Word
			xItem:=BIN2I(SUBSTR(cStr,2,2))
			cStr:=SUBSTR(cStr,5)
		CASE ct==CHR(17)	//Byte
			xItem:=ASC(SUBSTR(cStr,2,1))
			cStr:=SUBSTR(cStr,4)
		CASE ct==CHR(18)
			xItem:=-(256-BIN2I(SUBSTR(cStr,2,2)))
			cStr:=SUBSTR(cStr,4)
		CASE ct==CHR(15)	//Long
			xItem:=CTOF(SUBSTR(cStr,4,8))
			cStr:=SUBSTR(cStr,12)
		CASE ct==CHR(14)	//date
			xItem:=SXDate(Bin2L(SUBSTR(cStr,2,4)))
			cStr:=SUBSTR(cStr,6)
		CASE ct==CHR(12)	//ARRAY
			cStr:=SUBSTR(cStr,2)
			xItem:=Bin2Arr(@cStr)
		CASE ct $ CHR(25)+chr(26)		//.T. .F.
			xItem:= (ct == CHR(25))
			cStr:=SUBSTR(cStr,2)
		CASE ct==CHR(0)		//NIL
			xItem:=NIL
			cStr:=SUBSTR(cStr,2)
		OTHER
			xItem:=SUBSTR(cStr,2)
			cStr:=''
	ENDCASE
	aRes[i]:=xItem
END
RETU aRes
**********
FUNC Arr2Bin(aSrc)
LOCAL nSize,i,xItem,cT,cRes

cRes:=I2Bin(LEN(aSrc))

FOR i:=1 TO LEN(aSrc)
	xItem:=aSrc[i]
	cT:=VALTYPE(xItem)
	DO CASE
		CASE cT=='C'	//Char
			xItem:=CHR(7)+I2Bin(LEN(xItem))+xItem
		CASE cT=='N'
			IF BETWEEN(xItem,0,255)
				xItem:=CHR(17)+CHR(xItem)+CHR(10)
			ELSEIF ABS(xItem)<32750
				xItem:=IF(xItem>0,CHR(20),CHR(19))+;
					I2BIN(xItem)+CHR(10)
			ELSE
				xItem:=CHR(15)+CHR(10)+CHR(0)+FTOC(xItem)
			ENDIF
		CASE ct=='D'	//date
			xItem:=CHR(14)+L2Bin(SXNum(xItem))
		CASE ct=="L"
			xItem:=IF(xItem,CHR(25),CHR(26))
		CASE ct=='A'	//ARRAY
			xItem:=CHR(12)+Arr2Bin(xItem)
		OTHER
			xItem:=CHR(0)
	ENDCASE
	cRes+=xItem
END
RETU cRes
**********
FUNC MemoEmpty(cFld)
RETU EMPTY(cFld) .OR. (VALTYPE(cFld)=='C' .AND. cFld==REPL(CHR(0),4))
