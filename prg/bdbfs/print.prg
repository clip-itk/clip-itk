/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
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
	_NeedEject,_pspacing,_MemoNumLines,_lDgtHdr,_lDhAll
MEMVAR  _aExpr, _aHead, _aElen, _aPict, _aTitle, _cFile, _aSecond, _aSum,;
	_fCondit,_NoAsk,_nCounter,_aFooter,_pEveryStep,;
	_aGroup,_nDouble,_NoShow,_lAddi,_aPage,cDivideT,cDivide,countName
MEMVAR _InipFile,_MemoPrnFile
*MEMVAR PGrSum2,ISum2,PSum2
#command SUM ARRAY <a> ;
	 [FROM <nStart>];
	 [COUNT <nCount>];
	 TO <i> ;
	 => <i>:=FT_ASUM(<a>,<nStart>,<nCount>)
#translate Double(<_s>,<_space>)=> Pad(<_s>,m->_L+<_space>)+Trim(<_s>)
STATIC lIsHtml:=.F.
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
	IF EMPTY(_i)	//Forcibly is unset
	   IF cFtype=='M' .OR. (cFtype=='V' .AND. nFlen>5)
		_i:=IF(EMPTY(m->_MemoPrnt),10,m->_MemoPrnt)
		IF cFType=='M' .AND. !EMPTY(m->_MemoPrnt)
			_el:=RealMemoryName(_el)
		ENDIF
	    ELSEIF cFtype=='D' .OR. (cFtype=='V' .AND. nFlen==3)
		_i:=10
	    ELSE
		_i:=nFlen+2		//for amounts more that two digits
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
	_NoAsk,_nCounter,_aFooter,_pEveryStep,_aGroup,;
	_nDouble,_NoShow,_lAddi,_aPage,cDivideT,cDivide,countName
*/
END
**********
PROC PrintHead()
LOCAL s,i,lNo1st:=(_PageNo>1),lWasHead:=.f.
IF lIsHtml THEN Psay('<H2>',.T.)

IF !lNo1st .OR. m->_lTitleAll
  AEval(m->_aTitle,{|i| Pc(1,i,IF(VALTYPE(i)=='C',MAX(_L,LEN(i)),_L))})
  IF m->_NeedMainHead
	Pc(2,_base+BASE_STAT+Dtoc(DATE()))
	Pc(1,LASTUPDATED+DTOC(Lupdate()))
	IF  !Empty(m->_IndexFile)
		Pc(1,IND_FILE+m->_IndexFile)
		Pc(1,m->_Iv+IndexKey(0))
	ENDIF
	Pc(1,IF(_Pcond='.T.',ALL_RECS,CONDITION+_pcond))
  ENDIF
ENDIF

IF  m->_NeedPrPage .AND. lNo1st
	s:=SPACE(MAX(_l+_lmargin-15,25))+PLIST+NTRIM(_PageNo)
	IF (TYPE('_nDouble')=='N' .AND. _nDouble>0) THEN s:=Double(s,_ndouble)
	IF _NeedHeadPage
		@ prow()+1,0 say s
		_plineNo++
	ELSE
		@ prow()+3,0 say s
		_plineNo+=3
	ENDIF
ENDIF
IF lIsHtml THEN Psay('</H2>',.T.)

IF !EMPTY(m->_head) .AND. (_NeedHeadPage .OR. !lNo1st)
	IF lIsHtml THEN PSay('<b>',.T.)
	Line()
	AEval(m->_head,{|i| Psay(' '+i)})
	Line()
	IF lIsHtml THEN DevOut('</b>')
	lWasHead:=.T.
ENDIF

IF (!lNo1st .AND. _lDgtHdr) .OR. (lNo1st .AND. _lDhAll)
	IF lIsHtml THEN PSay('<b>',.T.)
	IF !lWasHead THEN Line()
	s:=' '
	FOR i:=1 TO LEN(_aELen)
		s+=Medi(i,_aELen[i],m->cDivideT)
	NEXT
	@ prow()+1,0 say s
	Line()
	IF lIsHtml THEN PSay('</b>',.T.)
ENDIF
**********
PROC PrintEdit(_FName)
LOCAL aEd:={},s
IF_NIL _FName IS ClearName()+'.REC'
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
lIsHtml:=.F.	//No any HTML
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
*Report generation
*
FUNC MakeReport
LOCAL nHead,_nl:=0,nPos,nMax,cHead,NeedCounter
LOCAL i,j,Acurr,cCurr,pKod,scr,nGrpLines, nRecLen
PARAM lUsual,_aExpr, _aHead, _aElen, _aPict, _aTitle, _cFile,/*_aSecond,*/ _aSum,_fCondit,;
	_NoAsk,_nCounter,_aFooter,_pEveryStep,_aGroup,;
	_nDouble,_NoShow,_lAddi,_aPage,cDivideT,cDivide,countName
/*
	Report autogeneration and printing

  _aHead - Columns header
  _aExpr - Expressions for aech column
  _aElen - Array of columns width
  _aPict - Array of columns pictures
  _aTitle - Report header
  _cFile - output file
  _aSecond - Array of second output strings
  _aSum    - Array of 'needed calculate' flags
  _fCondit - print condition
  _NoAsk - mute - no ask
  _nCounter - if  >0, then prints at left the serial number with _nCounter witdh.
  _aFooter  - name of callback function for printing footer or name of array
            contains footer strings
  _pEveryStep - name of callback funtion or eval'ed code block (runs before
                printing every string by condition _fCondit)
  _aGroup - array of subgroups {'group field',bHead|aHead,bFoot|aFoot,lMore1}
  _nDouble - sign of the need to display in two columns on a worksheet. If zero
             or unspecified, then prints one column. If specified numeric value,
             then this mean count of spaces between columns.
  _lAddi -  append to file.
  _aPage -  {xHeader,xFooter} if specified, then prints summary by page, and
	    Header printed begins from second page.
  cDivideT,cDivide - separator for header columns and information strings
  (':' by default)
  CountName - name of column 'serial number'

  Outputs report to file, show preview and print.

  In the column headings character ';' means that from this point begins the
  next line header.
  Column width is defined as the maximum width between the column title and
  given in the array _aElen.
  If the width of the displayed field is greater than the width of the column,
  then it is done correctly newline (up to 6 lines per column) by the dividers
  'space', dot, comma, semicolon, tabulation.

  Example :
	Heads:={'Client;code','Name'}
	Funcs:={'COD','NAME'}
	Lens:={5,40}
	MakeReport(Heads,Funcs,Lens,,'Bank clients')

  See also MAKE REPORT, ease to use function.

  Lightweight version for BDBFS.

*/
PRIVATE _Head,ISum,PSum,NeedPart:=.f.,nCol,PGrSum,NeedPgGrp:=.F.,_nPp
*PRIVATE ISum2,PSum2,PGrSum2

IF Empty(m->_lAddi) THEN	m->_lAddi:=.f.
IF Empty(m->_NoAsk) THEN	m->_NoAsk:=.f.
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
IF_NIL m->CountName IS COUNTER_NAME
NeedCounter:= (m->_nCounter>0)
IF_NIL m->cDivide IS m->_DefaultBorder
IF_NIL m->cDivideT IS m->_DefaultHBorder

ScrSave(@scr)

IF !BeginPrint(m->_cFile, m->_fcondit)
	RETU .f.
ENDIF

* If the number of titles less than number of columns - make empty headlines.
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
m->ISum := Ext_Arr(,nCol,0)

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
IF !Empty(m->_aGroup)        //needed grouping
	NeedPart:=.t.
	Asize(m->_aGroup,4)
	PSum := ACLONE(m->iSum)
	*Psum2:= AClone(Psum)
ENDIF

IF !Empty(m->_aPage) 	//needed grouping by pages
	NeedPgGrp:=.T.
	Asize(m->_aPage,2)
	PGrSum := ACLONE(m->iSum)
	*PGrsum2:= AClone(PGrsum)
ENDIF

IF Empty(m->_fCondit) THEN m->_fCondit := '.t.'


* determine lines count in header
nHead:=1
FOR i=1 to nCol DO;
	nHead:=Max(nHead,FT_NOOCCUR(';',m->_aHead[i])+1)

* determine detail header lines

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

	IF  j<=nHead	//vertical centering header lines
		A_Ins(aCurr,'')
	ENDIF


* determine column width
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


* adds ceils
	FOR j:=1 to nHead ;
		DO _Head[j]+=Medi(aCurr[j],m->_aElen[i],m->cDivideT)

NEXT

* begin printing
BEGIN SEQUENCE

  _L:=Len(TRIM(_Head[1]))+1
* What if the title is wider
*Report header
*Plen()		&& switch on compres if needed

  PrintHead()			&& header

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

  CheckEsc(.T.)	//counter
  m->_NPp:=0	//serial counter
  DO WHILE !EOF() .AND. CheckEsc()
	IF &(m->_fCondit)
	  SET DEVICE TO PRINT
	  m->_nPp++

	 nGrpLines++		// lines in group
	 IF NeedPart .AND. pKod<>&(m->_aGroup[1])	// Grouping?
		Line(,.T.)  	// Eject not allow
		IF EMPTY(m->_aGroup[4]).OR.;	// in any case or
		   (nGrpLines>1)		// more that one line
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
	SET(_SET_DEVICE,'')	//for counter printing
  ENDSCAN

  SET DEVICE TO PRINT

  IF !Empty(m->_pEveryStep) THEN Aktion(m->_pEveryStep)

  IF NeedPart
	IF EMPTY(m->_aGroup[4]).OR.;	// in any case
		   (nGrpLines>1)	// or more that one line
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

*DevOut(NORMAL+_CRLF)		&& Switch on to normal font on the printer

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
nItem:=1			// At leat one line
AFILL(cCurr,'')			// lines (probably MEMO)

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
PROC ShowSum(_sum,lPart,need2,lPage)	//also used from Psay()
					//while printing page footer
LOCAL i,ii,cCurr,start:=ASCAN(m->_aSum,.T.),n1Wide
lPage:=!EMPTY(lPage)
IF Ascan(_sum,{|_1|_1>0})==0	// No summ>0
	RETURN
ENDIF
SUM ARRAY m->_aElen FROM 1 COUNT start-1 TO i

n1Wide:=i+(start-2)*LEN(cDivide)+1	// Width for summary message output

cCurr:=' '
IF !need2 .AND. start>1			// Have place for output
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
IF lPage	// page
/*
	IF IsPArray('_aSecond') .AND. !need2
		ShowSum(PGrsum2,.F.,.T.,.T.)
	ENDIF
*/
ELSEIF lPart	// group
*	IF IsPArray('_aSecond') .AND. !need2
*		ShowSum(Psum2,.T.,.T.)
*		Line()
*	ELSEIF !IsPArray('_aSecond')
		Line()
*	ENDIF
ELSE		// footer
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

IF m->_lAddi THEN m->_NeedApFile:=.T.

IF m->_NoAsk .OR. (TakeScope(FOROTBOR) .AND. GetName(_ZU+FOROTBOR,'_PCond') .AND. TrueCond(@_PCond))

//  SetColor(m->_MenuColor)
  _i:=IF(m->_NoAsk, 1, ;
	 Menu2({WHERE_DEV},1,WHERE_OUT,,{{9,_MSG_PR_F9,{||Configure(.T.)}}});
	)
  lIsHtml:=.F.
  IF _i<3
	IF m->_NoAsk .OR. GetName(_ZIF+m->_ABORT,'_F_OUT')
		IF  Empty(_F_OUT) THEN _F_Out=ClearName()
		IF _i==1
			cExt:='.PRN'
		ELSE
			cExt:='.HTM'
			lIsHtml:=.T.
		ENDIF
		IF !m->_NoAsk .AND. !m->_NeedApFile .AND. !TestWriteFile(@_F_OUT,cExt)
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
	HtmlHeader(cTitle, aDesign)	//Options - just in case
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
	IF Really(NeedPgGrp)	// summary by page
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
// no need to ptrint page if accidentally got on the end of file
	IF USED()
		SKIP
		IF EOF()
			GO BOTTOM
			RETURN
		ELSE
			SKIP -1
		ENDIF
	ENDIF
	IF Really(NeedPgGrp)	// pages header
		IF !EMPTY(_aPage[1]) THEN EvalA(m->_aPage[1])
	ENDIF
	PrintHead()
ENDIF
**********
PROC Line(char,lNoPage)
IF_NIL char IS '-'
Psay(Repl(char,_L),lNoPage)
**********
PROC RestPrintIni(cfBpf)
PRIVATE _aExpr, _aHead, _aElen, _aPict, _aTitle, _cFile,/* _aSecond,*/ _aSum,;
	_fCondit,_NoAsk,_nCounter,_aFooter,_pEveryStep,;
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
		   /*_aSecond,*/ _aSum, _fCondit, _NoAsk, _nCounter,;
		   _aFooter, _pEveryStep, _aGroup, _nDouble,;
		   _NoShow, _lAddi, _aPage, cDivideT, cDivide, countName)
END
**********
#define divisor ' ;.,!?'+chr(9)//+chr(10)
**********
FUNC DivideStr(cStr,NumItem,nLen,_Border, aArr, lTrunc )
// Split string by NumItem items by length nLen
LOCAL i:=1, nSp, j, cItem, cRest
aArr:=Array(NumItem)
cStr:=StrTran(StrTran(cStr,'ç'+chr(10)),chr(10)) // utf-8: '–ù'
*IF_NIL _Border IS ':'

DO WHILE !Empty(cStr) .AND. i<=NumItem
	Parce(cStr,chr(13),@cItem,@cRest)
//cItem already done
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
		cItem:=LEFT(cStr,nsp)
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
