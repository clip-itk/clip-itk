/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
#include "set.ch"
MEMVAR  _zu,_zif,_base,_im,_l,_pole,_works,_F_Out,;
	_FLen,_FType,__mcol,;
	_printer,_plength,_pscode,_pecode,_plineno,_pageno,_lMargin,;
	_pcond,_needRec,_recRight,_needCentr,_NeedPrPage,_NeedHeadPage,;
	PGrSum,NeedPgGrp,ISum,PSum,NeedPart,nCol,_head,;
	_NeedEject,_pspacing,_MemoNumLines
MEMVAR  _aExpr, _aHead, _aElen, _aPict, _aTitle, _cFile, _aSecond, _aSum,;
	_fCondit,_lSilense,_nCounter,_aFooter,_pEveryStep,;
	_aGroup,_nDouble,_NoShow,_lAddi,_aPage,cDivideT,cDivide,countName
MEMVAR _InipFile,_MemoPrnFile
*MEMVAR PGrSum2,ISum2,PSum2
#command SUM ARRAY <a> ;
	 [FROM <nStart>];
	 [COUNT <nCount>];
	 TO <i> ;
	 => <i>:=FT_ASUM(<a>,<nStart>,<nCount>)
#translate Double(<_s>,<_space>)=> Pad(<_s>,m->_L+<_space>)+Trim(<_s>)
STATIC lIsHtml
**********
PROC PRT
LOCAL	_i,i,_el,nFLen,cFType, nRecLen:=MAX(LenNum(LastRec()),7),;
	_aExpr, _aHead, _aElen, _aSum

BEGIN SEQUENCE
  _aExpr:={}
  _aHead:={}
  _aElen:={}
  _aSum:={}
  _aPict:=m->_Pictures
  FOR i:=1 TO LEN(_Pole)
	_el:=_Pole[i]
	nFlen:=_FLen[i]
	cFtype:=_Ftype[i]
	_i:=m->_Widths[i]
	IF EMPTY(_i)	//Принудительно не задано
	   IF cFtype=='M' .OR. (cFtype=='V' .AND. nFlen>5)
		_i:=IF(EMPTY(m->_MemoPrnt),10,m->_MemoPrnt)
		IF cFType=='M' .AND. !EMPTY(m->_MemoPrnt)
			_el:=RealMemoryName(_el)
		ENDIF
	    ELSEIF cFtype=='D' .OR. (cFtype=='V' .AND. nFlen==3)
		_i:=10
	    ELSE
		_i:=nFlen+2		//для сумм на 2 разряда больше
	    ENDIF
	ENDIF
	AADD(_aExpr,_el)
	AADD(_aHead,_Works[i])
	AADD(_aSum,m->_NeedSum  .AND. ;
	     (cFtype $ 'NF' .OR. (cFtype=='V'.AND. nFlen=4)))
	AADD(_aElen,_i)
  NEXT
  MakeReport(.T.,_aExpr, _aHead, _aElen, _aPict,/* _aTitle*/,/* _cFile*/,;
	  /*_aSecond,*/ _aSum, _PCond)
/*,;
	_lSilense,_nCounter,_aFooter,_pEveryStep,_aGroup,;
	_nDouble,_NoShow,_lAddi,_aPage,cDivideT,cDivide,countName
*/
END
**********
PROC PrintHead()
LOCAL s
IF lIsHtml THEN Psay('<H2>',.T.)
IF m->_NeedMainHead
	Pc(2,_base+BASE_STAT+Dtoc(DATE()))
	Pc(1,LASTUPDATED+DTOC(Lupdate()))
	IF  !Empty(m->_IndexFile)
		Pc(1,IND_FILE+m->_IndexFile)
		Pc(1,m->_Iv+IndexKey(0))
	ENDIF
	Pc(1,IF(_Pcond='.T.',ALL_RECS,CONDITION+_pcond))
ENDIF
IF  m->_NeedPrPage .AND. _PageNo>1
	s:=SPACE(MAX(_l+_lmargin-15,25))+PLIST+NTRIM(_PageNo)
	IF (TYPE('_nDouble')=='N' .AND. _nDouble>0) THEN s:=Double(s,_ndouble)
	@ prow()+1,0 say s
	_plineNo++
ENDIF
IF lIsHtml THEN Psay('</H2>',.T.)

IF !EMPTY(m->_head)
	IF lIsHtml THEN PSay('<b>',.T.)
	Line()
	AEval(m->_head,{|i| Psay(' '+i)})
	Line()
	IF lIsHtml THEN DevOut('</b>')
ENDIF

**********
PROC PrintEdit(_FName)
LOCAL aEd:={},s
PRIVATE _l:=0
AEval(_pole,{|el,_i|AADD(aEd,(s:=Str(_i,3)+'.'+;
		PAD(ALLTRIM(STRTRAN(_Works[_i],';',' ')),32)+;
		ALLTRIM(Medi(&(el),m->_Flen[_i]+2,'')))),;
	_l:=Max(_l,LEN(s))})
PrintArr(_Fname,_base+' - '+N_RECORD_COL+NTRIM(Recno()),aEd)
**********
PROC PrintArr(_Fname,_head,_array,_footer)
SET DEVI TO PRINT
SET(_SET_PRINTFILE,IF(EMPTY(_Fname),_printer,_Fname),m->_NeedApFile)
IF 'U' $ TYPE('_l') THEN _l:=38
lIsHtml:=.F.	//Никаких HTML
BEGIN SEQUENCE
	Pc(1,_head)
	Line()
	EvalA(_array)
	Line() ; Psay('')
	EvalA(_Footer)
END
File_Dial(_fName)
**********
PROC Pc(_r,_s,_lg)
IF_NIL _lg IS _L

_s:=PADC(_s,_lg)
IF TYPE('_nDouble')=='N' .AND. _nDouble>0 THEN;
	_s:=Double(_s,_ndouble)
@ prow()+_r,_Lmargin SAY _s//+IF(lIsHtml,'<br>','')
_plineNo+=_r
*****************
*Генерация отчета
*
FUNC MakeReport
LOCAL nHead,_nl:=0,nPos,nMax,cHead,NeedCounter
LOCAL i,j,Acurr,cCurr,pKod,scr,nGrpLines, nRecLen
PARAM lUsual,_aExpr, _aHead, _aElen, _aPict, _aTitle, _cFile,/*_aSecond,*/ _aSum,_fCondit,;
	_lSilense,_nCounter,_aFooter,_pEveryStep,_aGroup,;
	_nDouble,_NoShow,_lAddi,_aPage,cDivideT,cDivide,countName
/*
	Автогенерация и вывод отчета

  _aHead - массив заголовков колонок
  _aExpr - массив выражений для каждой колонки
  _aElen - массив ширин колонок
  _aPict - массив картинок колонки
  _aTitle - массив заголовка отчета
  _cFile - файл вывода
  _aSecond - массив вторых строчек вывода
  _aSum    - массив необходимости суммирования
  _fCondit - условие печати
  _lSilense - молчание- ничего не спрашиваем
  _nCounter - если >0, то слева выводит порядковый номер шириной _nCounter
  _aFooter  - имя дополнительной процедуры,печатающей подвал или имя массива,
	    содержащего подвал
  _pEveryStep - имя дополнительной процедуры или блока выполняющейся перед
  	     печатью каждой строки,удовлетворяющей условию _fCondit
  _aGroup - массив подгруппировок {'поле группировки',bHead|aHead,bFoot|aFoot,lMore1}
  _nDouble - признак необходимости вывода в две колонки на листе.Если 0 или не
	задан - печатается одна.Если задан числовой параметр - воспринимается
	как количество пробелов между двумя колонками.
  _lAddi -  файл дописывается.
  _aPage -  {xHeader,xFooter} если определен, то печатаются итоги по странице,
	    причем Header печатается, начиная со второй.
  cDivideT,cDivide - символ разделения колонок в заголовке и инфостроках
	    (умолчание - ':')
  CountName - название колонки Номер по порядку

  Выводит отчет в файл,предлагает для просмотра и печатает.

  В заголовках колонок символ ; означает, что с этого места начинается
  следующая строчка заголовка
  Ширина колонки определяется как максимальная среди ширины заголовка
  колонки и заданной в массиве _aElen
  Если ширина выводимого поля больше, чем ширина колонки,то делается
  корректный перенос (до 6-и строк на колонку) по разделителям
  пробел,точка,запятая,точка с запятой,табуляция

  Пример :
	Heads:={'Код;клиента','Наименование'}
	Funcs:={'KOD','NAME'}
	Lens:={5,40}
	MakeReport(Heads,Funcs,Lens,,'Клиенты банка')

  См.также команду MAKE REPORT, облегчающую использование функции.

  Упрощенная для BDBFS версия.

*/
PRIVATE _Head,ISum,PSum,NeedPart:=.f.,nCol,PGrSum,NeedPgGrp:=.F.,_nPp
*PRIVATE ISum2,PSum2,PGrSum2

IF Empty(m->_lAddi) THEN	m->_lAddi:=.f.
IF Empty(m->_lSilense) THEN	m->_lSilense:=.f.
IF Empty(m->_nDouble) THEN	m->_nDouble:=0

IF Empty(m->_aExpr)
	nCol:=m->_fc
	m->_aExpr:=AClone(_Pole)
	m->_aElen:=AClone(_Flen)
ELSE
	aCurr:={}
	AEVAL(m->_aExpr,{|_1| IF(!EMPTY(_1),AADD(aCurr,_1),)})
	m->_aExpr:=ACLONE(aCurr)
	nCol:=Len(m->_aExpr)
ENDIF

IF_NIL m->_nCounter IS 0
IF_NIL m->cDivide IS m->_DefaultBorder
IF_NIL m->cDivideT IS m->_DefaultBorder
IF_NIL m->CountName IS COUNTER_NAME
NeedCounter:= (m->_nCounter>0)

ScrSave(@scr)

IF !m->_lSilense .AND. !m->_lAddi .AND. !BeginPrint(m->_cFile, m->_fcondit)
	RETU .f.
ELSEIF m->_lSilense .OR. m->_lAddi
	_plineNo:=_nl:=0
	_pageNo:=1
	Set(_SET_PRINTFILE,m->_cFile, m->_NeedApFile)
ENDIF

* Если количество заголовков < количества столбцов - сделаем пустые заголовки
IF !IsPArray('_aHead') THEN m->_aHead := {}
FOR i:=Len(m->_aHead)+1 TO nCol ;
	DO AADD(m->_aHead,m->_aExpr[i])

m->_aPict:=Ext_Arr(m->_aPict,ncol)

m->_aElen:=Ext_Arr(m->_aElen,ncol)

m->_aSum :=Ext_Arr(m->_aSum,ncol)

IF NeedCounter
	ncol++
	A_Ins(m->_aExpr,'_Npp')
	A_Ins(m->_aHead,m->CountName)
	A_Ins(m->_aPict,'')
	A_Ins(m->_aElen,m->_nCounter)
	A_Ins(m->_aSum,.F.)
ENDIF

m->ISum := Ext_Arr(,nCol,0)

IF m->lUsual .AND. _needRec
	nCol++
	nRecLen:=MAX(LenNum(LastRec()),7)
	IF _RecRight
		AADD(m->_aExpr,'RECNO()')
		AADD(m->_aHead,N_RECORD)
		AADD(m->_aElen,nRecLen)
		AADD(m->_aSum,.F.)
		AADD(m->_aPict,)
	ELSE
		A_INS(m->_aExpr,'RECNO()')
		A_INS(m->_aHead,N_RECORD)
		A_INS(m->_aElen,nRecLen)
		A_INS(m->_aSum,.F.)
		A_INS(m->_aPict,)
	ENDIF
  ENDIF

/*
IF IsPArray('_aSecond')
	IF  NeedCounter THEN A_Ins(m->_aSecond,NIL)
	ASize(m->_aSecond,nCol)
	Isum2:=ACLONE(Isum)
ENDIF
*/
IF !IsPCharacter('_cFile') THEN m->_cFile := ''

IF Empty(m->_aTitle) .OR. (Type('_aTitle')#'A') ;
	THEN m->_aTitle:=IF(IsPCharacter('_aTitle'),{ m->_aTitle },{})

nGrpLines:=0
IF !Empty(m->_aGroup) 	//нужна группировка
	NeedPart:=.t.
	Asize(m->_aGroup,4)
	PSum := ACLONE(m->iSum)
	*Psum2:= AClone(Psum)
ENDIF

IF !Empty(m->_aPage) 	//нужна группировка по странице
	NeedPgGrp:=.T.
	Asize(m->_aPage,2)
	PGrSum := ACLONE(m->iSum)
	*PGrsum2:= AClone(PGrsum)
ENDIF

IF Empty(m->_fCondit) THEN m->_fCondit := '.t.'


* определим число строк в заголовке
nHead:=1
FOR i=1 to nCol DO;
	nHead:=Max(nHead,FT_NOOCCUR(';',m->_aHead[i])+1)

* определим детальные строки заголовка

_Head:=Ext_Arr(,nHead,'')
FOR i:=1 to nCol

	cHead:=m->_aHead[i]
	j:=1 ; nMax:=0
	aCurr:=Ext_Arr(,nHead,'')
	DO While !Empty(cHead)
		Parce(cHead, ';', @cCurr, @cHead)
		aCurr[j++]:= cCurr
		nMax:=Max(nMax,Len(cCurr))
	ENDDO

	IF  j<=nHead	//подцентрируем строчки заголовка по вертикали
		A_Ins(aCurr,'')
	ENDIF


* определим ширину колонки
	IF  ValType( m->_aElen[i] )<>'N'
		m->_aElen[i]:=0
		j:=m->_aExpr[i]
		IF Type(j)='C'
			j:=Len(&j)
		ELSEIF Type(j)='L'
			j:=4
		ELSE
			j:=Len(Trim(Pad(&j,20)))
		ENDIF
		nMax:=Max(nMax,j)
		m->_aElen[i]:=MAX( m->_aElen[i], nMax)
		IF !EMPTY(m->_aPict[i]) THEN ;
			m->_aElen[i]:=MAX( m->_aElen[i], LEN(m->_aPict[i]))
	ENDIF


* добавляем клетки
	FOR j:=1 to nHead ;
		DO _Head[j]+=Medi(aCurr[j],m->_aElen[i],m->cDivideT)

NEXT

* начинаем печать
BEGIN SEQUENCE

  _L:=Len(TRIM(_Head[1]))+1
* А вдруг заголовок шире
*Заголовок отчета
*Plen()		&& включить сжатие при необходимости
  AEval(m->_aTitle,{|i| Pc(1,i,IF(VALTYPE(i)=='C',MAX(_L,LEN(i)),_L))})

  PrintHead()			&& заголовок

  IF NeedPart
	pKod := &(m->_aGroup[1])
	IF EMPTY(m->_aGroup[2])
		Pc(2,GROUP_HEAD+AllTrim(Medi(pKod,255,'')))
		Psay()
	ELSE
		EvalA(m->_aGroup[2])
	ENDIF
	Line()
  ENDIF

  CheckEsc(.T.)	//Счетчик
  m->_NPp:=0	//Счетчик п.п
  DO WHILE !EOF() .AND. CheckEsc()
	IF &(m->_fCondit)
	  SET DEVICE TO PRINT
	  m->_nPp++

	 nGrpLines++		// строк в группе
	 IF NeedPart .AND. pKod<>&(m->_aGroup[1])	// Группировка?
		Line(,.T.)  	// не допустим Eject
		IF EMPTY(m->_aGroup[4]).OR.;	// в любом случае или
		   (nGrpLines>1)		// более одной строки
			ShowSum(PSum,.T.,.F.)
		ENDIF

		nGrpLines:=0

		Afill(PSum,0)
		*Afill(PSum2,0)

		pKod=&(m->_aGroup[1])
		IF EMPTY(m->_aGroup[2])
			Pc(2,GROUP_HEAD+AllTrim(Medi(pKod,255,'')))
			Psay(,.T.)
		ELSE
			EvalA(m->_aGroup[2])
		ENDIF
		Line(,.T.)
	  ENDIF

	  IF !Empty(m->_pEveryStep) THEN Aktion(m->_pEveryStep)
	  ShowLine(m->_aExpr,.t.)
	  *IF IsPArray('_aSecond') THEN ShowLine(m->_aSecond,.f.)
	ENDIF
	SET(_SET_DEVICE,'')	//для вывода счетчика
  ENDSCAN

  SET DEVICE TO PRINT

  IF !Empty(m->_pEveryStep) THEN Aktion(m->_pEveryStep)

  IF NeedPart
	IF EMPTY(m->_aGroup[4]).OR.;	// в любом случае
		   (nGrpLines>1)	// или более одной строки
		Line(,.T.)
		ShowSum(PSum,.T.,.F.)
	ENDIF
  ENDIF

  IF NeedPgGrp .AND. _PLength>0
	SUM ARRAY PGrSum TO i
	IF i>0
		Line(,.T.)
		ShowSum(PGrSum,.F.,.F.,.T.)
	ENDIF
  ENDIF

  Line('=',.T.)
  ShowSum(ISum,.F.,.F.)

  EvalA(m->_aFooter)

*DevOut(NORMAL+_CRLF)		&& включили нормальный шрифт на принтере

  IF TYPE(_PeCode)=='C' THEN Psay(&_PeCode)
  Psay(IF(lIsHTML,'</PRE></BODY></HTML>',),.T.)

  IF EMPTY(m->_Noshow) .AND. !EMPTY(_f_out)
	File_Dial(_F_OUT)
  ENDIF

END SEQUENCE
Go m->_tmr
POP KEYS
SET PRINTER TO; SET(_SET_DEVICE,'') ; ScrRest(scr)
RETU .t.
**********
STATIC PROC ShowLine(arr,IsFirst)
LOCAL nItem,cCurr:=ARRAY(_MemoNumLines),aCurr,nCurr,i,ii,jj,nLen,nTot
nItem:=1			// по-крайней мере одна строка
AFILL(cCurr,'')			// строки(возможно мемо)

FOR i:=1 to nCol
	nCurr:=arr[i]
	nLen:=m->_aElen[i]
	nCurr:=IF(EMPTY(nCurr),'', &nCurr)
	IF VALTYPE(nCurr)=='A' THEN nCurr:=Arr2Str(nCurr)
	IF (ValType(nCurr)=='C') .AND. ;
	  ((Len(nCurr:=AllTrim(nCurr) ) ) > nLen) .AND.;
	  (_MemoNumLines>1)
		nTot:=DivideStr(nCurr,_MemoNumLines,nLen,m->cDivide, @aCurr)
		FOR ii:=1 to _MemoNumLines DO ccurr[ii]+=aCurr[ii]
		nItem:= Max(nItem,nTot)
	ELSE
		jj:=nCurr
		IF !EMPTY(m->_aPict[i]) ;
			THEN jj:=Transform(nCurr,m->_aPict[i])
		IF _NeedCentr .OR. !(ValType(nCurr) $ 'NC')
			jj:=Medi(jj,nLen,cDivide)
		ELSEIF ValType(nCurr)=='N'
			jj:=Medi(jj,nLen,cDivide,.F.)
		ELSE
			jj:=PADR(LTRIM(jj),nLen)+ cDivide
		ENDIF
		cCurr[1] += jj

		FOR jj:=2 TO _MemoNumLines DO cCurr[jj]+=(SPACE(nLen)+cDivide)
	ENDIF

	IF !Empty(m->_aSum[i])  .AND. m->_aSum[i]
		nCurr:=	IF(valtype(nCurr)='C',Val(nCurr),nCurr)
		IF IsFirst
			ISum[i]+= nCurr
		*ELSE
		*	ISum2[i]+= nCurr
		ENDIF
		IF NeedPart
			IF IsFirst
				PSum[i]+=nCurr
		*	ELSE
		*		PSum2[i]+=nCurr
			ENDIF
		ENDIF
		IF NeedPgGrp
			IF IsFirst
				PGrSum[i]+=nCurr
		*	ELSE
		*		PGrSum2[i]+=nCurr
			ENDIF
		ENDIF
	ENDIF
NEXT
Asize(cCurr,nItem)
AEval(cCurr,{|el|Psay(IF(deleted(),'*',' ')+el)})
**********
PROC ShowSum(_sum,lPart,need2,lPage)	//используется и из Psay()
					//при печати подвала страницы
LOCAL i,ii,cCurr,start:=ASCAN(m->_aSum,.T.),n1Wide
lPage:=!EMPTY(lPage)
IF Ascan(_sum,{|_1|_1>0})==0	// Нет сумм>0
	RETURN
ENDIF
SUM ARRAY m->_aElen FROM 1 COUNT start-1 TO i

n1Wide:=i+(start-2)*LEN(cDivide)	// Ширина для вывода
					// итогового сообщения
cCurr:=' '
IF !need2 .AND. start>1			// Есть куда всунуть
   IF lPage
	cCurr:=ON_PAGE_TOTAL
	IF EMPTY(m->_aPage[2])
		cCurr:=Medi(cCurr,n1Wide,cDivide)
	ELSE
		EvalA(m->_aPage[2])
	ENDIF
   ELSE
	IF lPart
		IF EMPTY(m->_aGroup) .OR. EMPTY(m->_aGroup[3])
			cCurr:=PRNT_TOTAL
		ELSE
			cCurr:=''
			EvalA(m->_aGroup[3])
		ENDIF
	ELSE
		cCurr:=PRNT_TOTAL_ALL
	ENDIF
	cCurr:=Medi(cCurr,n1Wide,cDivide)
   ENDIF
ENDIF
FOR i:=start TO nCol
	cCurr+= IF(!Empty(m->_aSum[i]),;
		    MedI( IF(Empty(m->_aPict[i]),;
			    _Sum[i],Transform(_Sum[i],m->_aPict[i])),;
			    m->_aElen[i],cDivide,.F.),;
		   SPACE(m->_aElen[i])+cDivide)
NEXT
IF lIsHtml THEN cCurr:='<b><i>'+cCurr+'</b></i>'
Psay(cCurr,.T.)
IF lPage	// страница
/*
	IF IsPArray('_aSecond') .AND. !need2
		ShowSum(PGrsum2,.F.,.T.,.T.)
	ENDIF
*/
ELSEIF lPart	// группа
*	IF IsPArray('_aSecond') .AND. !need2
*		ShowSum(Psum2,.T.,.T.)
*		Line()
*	ELSEIF !IsPArray('_aSecond')
		Line()
*	ENDIF
ELSE		// подвал
*	IF IsPArray('_aSecond') .AND. !need2
*		ShowSum(Isum2,.F.,.T.)
*		Line('=',.T.)
*	ELSEIF !IsPArray('_aSecond')
		Line('=',.T.)
*	ENDIF
ENDIF
**********
STATIC PROC EvalA(afR)
IF ValType(aFr)=='A'
	IF (_plength>0) .AND. _NeedEject .AND. (Len(aFr)+ _plineNo> _Plength)
		_plineNo:=0
		Eject
	ENDIF
	Aeval(aFr,{|el| Psay(el,.T.)})
ELSEIF ValType(aFr)=='B'
	Psay(Eval(aFr),.T.)
ELSEIF ValType(aFr)=='C'
	Psay(aFr,.T.)
ENDIF
**********
STATIC FUNC BeginPrint(cFile,cFcond,cTitle, aDesign)
LOCAL _i,_scr,lRes:=.F.,cExt

PUSH KEYS
BEGIN SEQUENCE

IF !EMPTY(cFile) THEN _F_OUT:=cFile
IF !EMPTY(cFcond) THEN _PCond:=cFCond
IF TakeScope() .AND. GetName(_ZU+FOROTBOR,'_PCond') .AND. TrueCond(@_PCond)

//  SetColor(m->_MenuColor)
  _i:=Menu2({WHERE_DEV},1,WHERE_OUT,,{{9,_MSG_PR_F9,{||Configure()}}})
  lIsHtml:=.F.
  IF _i<3
	IF GetName(_ZIF+m->_ABORT,'_F_OUT')
		IF  Empty(_F_OUT) THEN _F_Out=ClearName()
		IF _i==1
			cExt:='.PRN'
		ELSE
			cExt:='.HTM'
			lIsHtml:=.T.
		ENDIF
		IF !m->_NeedApFile .AND. !TestWriteFile(@_F_OUT,cExt)
			BREAK
		ENDIF
	ELSE
		BREAK
	ENDIF
  ELSEDO _F_Out:=_printer

  Set(_SET_PRINTFILE,_F_out,m->_NeedApFile)
  m->_fCondit:=_PCond
  m->_told:=Seconds()
  Meter(1,IF(_i=1,F_OUT_PRINT+_F_out,IS_PRINT))

  IF  _i=3 THEN	_F_OUT:=''

  SET DEVI TO PRINT
  m->_L:=80
  _pageno:=1
  _PlineNo:=1
  lRes:=.T.
  IF lIsHtml
	HtmlHeader(cTitle, aDesign)	//Параметры - на всяк случай
	PSAY('<PRE>')
  ENDIF
  IF TYPE(_PsCode)=='C' THEN Psay(&_PsCode)
ENDIF
END SEQUENCE
IF !lRes
	go m->_tmr
	POP KEYS
ENDIF
RETURN lRes
**********
PROC Psay(s,lPageNo)
LOCAL lDouble:=(Type('_nDouble')=='N') .AND. (_nDouble>0)
IF_NIL s IS ''
IF !EMPTY(s) .AND. lDouble
	s:=Double(s,_nDouble)
ENDIF

@ prow()+_pspacing,_Lmargin SAY s
_plineno+=_pspacing

IF EMPTY(lPageNo) .AND. _PlineNo > _plength .AND. (_plength#0)
	_pageno++
	_plineNo=1
	IF Really(NeedPgGrp)	// итоги по странице
		LINE(,.T.)
		ShowSum(m->PGrsum,.F.,.F.,.T.)
		LINE(,.T.)
		Afill(m->PGrSum,0)
*		Afill(m->PGrSum2,0)
	ENDIF

	IF _NeedEject .AND. !lIsHTML
		Eject
	ELSE
		@ prow()+2,0 say ''
	ENDIF
// если случайно попали на конец файла - печатать страницу не надо
	IF USED()
		SKIP
		IF EOF()
			GO BOTTOM
			RETURN
		ELSE
			SKIP -1
		ENDIF
	ENDIF
	IF Really(NeedPgGrp)	// заглавие страниц
		IF !EMPTY(_aPage[1]) THEN EvalA(m->_aPage[1])
	ENDIF
	IF _NeedHeadPage
		PrintHead()
	ELSEIF  _NeedPrPage
		s:=SPACE(MAX(_l+_lmargin-15,25))+PLIST+NTRIM(_PageNo)
		IF lDouble THEN	s:=Double(s,_nDouble)
		@ prow()+2,0 say s+_CRLF
		_plineNo+=3
		Line()
	ENDIF
ENDIF
**********
PROC Line(char,lNoPage)
IF_NIL char IS '-'
Psay(Repl(char,_L),lNoPage)
**********
PROC RestPrintIni(cfBpf)
PRIVATE _aExpr, _aHead, _aElen, _aPict, _aTitle, _cFile,/* _aSecond,*/ _aSum,;
	_fCondit,_lSilense,_nCounter,_aFooter,_pEveryStep,;
	_aGroup,_nDouble,_NoShow,_lAddi,_aPage,cDivideT,cDivide,countName

BEGIN SEQUENCE
	IF EMPTY(cfBpf)
		m->_IniPFile:=ClearName()
		IF !GetName(_ZIF+INI_F,'_IniPFile','*.BPF',,,.T.) THEN BREAK
	ELSE
		m->_IniPFile:=cfBpf
	ENDIF

	IF !IsFileExist(@_IniPFile,'.BPF') THEN BREAK

	RestoreIni(_IniPFile)

	MakeReport(.F.,_aExpr, _aHead, _aElen, _aPict, _aTitle, _cFile,;
		   /*_aSecond,*/ _aSum, _fCondit, _lSilense, _nCounter,;
		   _aFooter, _pEveryStep, _aGroup, _nDouble,;
		   _NoShow, _lAddi, _aPage, cDivideT, cDivide, countName)
END
**********
#define divisor ' ;.,!?'+chr(9)//+chr(10)
**********
FUNC DivideStr(cStr,NumItem,nLen,_Border, aArr, lTrunc )
// Разбивает строку на NumItem клеток длиной nLen
LOCAL i:=1, nSp, j, cItem, cRest
aArr:=Array(NumItem)
cStr:=StrTran(StrTran(cStr,'Н'+chr(10)),chr(10))
*IF_NIL _Border IS ':'

DO WHILE !Empty(cStr) .AND. i<=NumItem
	Parce(cStr,chr(13),@cItem,@cRest)
//cItem уже сделан
	IF  Len(cItem) > nLen
		j:=nLen
		DO WHILE j>1
			IF Substr(cStr,j,1) $ divisor
				nsp:=j
				EXIT
			ENDIF
			j--
		ENDDO
		IF j=1 THEN nsp:=nLen
		cItem:=SUBSTR(cStr,1,nsp)
*		cStr:=LTRIM(Substr(cStr,nsp+1))
		cStr:=Substr(cStr,nsp+1)
	ELSE
		cStr:=cRest
	ENDIF

	aArr[i++]:=IF(m->_NeedCentr,PadC(cItem,nLen),;
				    PadR(cItem,nLen))+_Border
ENDDO
nSp:=i-1

IF EMPTY(lTrunc)
	WHILE i<=NumItem DO ;
		aArr[i++]:= Space(nLen)+_Border
ELSE
	ASIZE(aArr,nSp)
ENDIF

RETU nSp
**********
PROC PrintMemo(cFld,cHeader)
LOCAL aPrnt
PRIVATE _l:=m->_MemoPrnt, _MemoPrnFile:=ClearName()+'.MPF'
IF_NIL cHeader IS _base+' - '+N_RECORD_COL+NTRIM(Recno())+' - '+_Works[m->_ptr]
IF _l<=0 THEN _l:=78
IF GetName(_ZIF,'_MemoPrnFile') .AND. TestWriteFile(@_MemoPrnFile,'.MPF')
	DivideStr(cFld,4096,m->_l,'', @aPrnt, .t.)	//4096-Max Array
	PrintArr(TRIM(m->_MemoPrnFile),cHeader,aPrnt)
ENDIF
**********
/*
STATIC FUNC Double(_s,_space)
RETU Pad(_S,m->_L+_space)+Trim(_S)
*/
