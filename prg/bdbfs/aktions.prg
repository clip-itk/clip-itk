/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"

#define ElseUse() NFIND(_ElseUse);_req:=0

STATIC	_corrupted:=_STAT_CORRUPTED,;
	_ELSEUse:=_STAT_ELSEUse,;
	_Give := _STAT_GIVE,;
	_NoIndex:=_STAT_NOINDEX,;
	_TxtMedit:=_STAT_END_EDIT,;
	_Ze:=_STAT_ZE,;
	_Zi:=_STAT_GIVE_NAME,;
	_nfd:=_STAT_NFD,;
	_ertip:=_STAT_ERTIP

MEMVAR _tmr,_c_f,_ptr,_req,__mcol,;
	_tally,_base,_timing,_ncnt,_im,_bm,_cm,_HdColor,;
	_menucolor,HiddenColor,score_row,score_col,_MainHandle
MEMVAR _pole,_works,_curtype,__ContentType,_fc,_dtype,_ddr,_dlen,_dubl,;
       _ftype,_fdr,_flen,_pictures
MEMVAR _LCondit,_indexFile,_oldInd,_Fcondit,_ClipText,_bdbfbrow,_fltrcond,_ngoto,_repl,;
	_rcond,_sumcond,__sum,_newindf,_newind,_indexfor,_macro,_sx_step,;
	_newfile,_ckfield,_cpc,_initvar,_countcond,_delcond,;
	_newdir,_sortfile,_sortcond,_cksort,_inifile,_vuefile,;
	__cdxname,__tagname,__tagnom,_cdxch,__go,_gsearch,_cb,_econd,_mask,;
	_Memoeditor,_Textviewer,_nMemotab,_Dirshow,_TotalCond,_TotalFile
MEMVAR _zif,_iv,_zu,_abort

**********
PROC NewRec()
Keyb _CTRLHOME
UNLOCK		//специально для MDX
DBAPPEND()
ClearRec()	//Из-за VFP
IF !EMPTY(_fltrcond).AND. !&_Fltrcond THEN go _tmr
**********
PROC SetIndex()
LOCAL	iExt:=Rdd_Info()[4],aName,;
	nUniq,nExpr,nExpr2:=0,nMin,nFor,cName
DO CASE
/*
	CASE EMPTY(iExt)
		nMin:=2048
		nUniq:=14
		nExpr:=2072
		nExpr2:=2072
		nFor:=2800
		iExt:='.MDX'
*/
	CASE 'ntx' $ iExt
		nMin:=2048
		nUniq:=278
		nExpr:=22
		nFor:=282
/*
	CASE 'nsx' $ iExt
		nMin:=3072
		nUniq:=1034
		nExpr:=1038
		nFor:=1294
*/
	CASE 'cdx' $ iExt
		nMin:=3072
		nUniq:=2062
		nExpr:=2048
		nExpr2=2512
		nFor:=0

	OTHER	//f.e IDX
		nMin:=1024
		nUniq:=14
		nExpr:=16
		nExpr2:=512
		nFor:=0
ENDCASE

BEGIN SEQUENCE
	aName:=Filer('*'+iExt,INDEX_CHOICE,{|el|Idx_An(el,nMin,nUniq,nExpr,Nexpr2,nFor)},;
		     {_zi,INDEX_NO},,{|_1|Ascan(_1,_IndexFile)})
	IF aName[1]<>0
		cName:=aName[2]
		IF aName[3] .AND. cName==_zi
			IF !GetName(_ZIF,'_IdxCh') .OR.;
			   !IsFileExist( @_IdxCh,iExt);
				THEN BREAK
			cName:=m->_IdxCh
		ELSEIF aName[3]
			cName:=''
		ENDIF
		_indexFile:=cName
		OrdListClear()
		OrdListAdd( _Indexfile )
		IF 'U' $ ValType(IndexKey(0)).AND.!EMPTY(cName) THEN BREAK
		__TagNom:=0
		IF !MGoTo(_tmr) THEN GO TOP
		IF LASTREC()==0 .OR. EMPTY(_indexFile) .OR. ;
		    DBSEEK(&(IndexKey(0)))
			_oldInd:=_indexFile
		ELSE
		    IF Continue(INDEX_NOT_MATCH)
			BEGIN SEQU
				Waiting(_MSG_A_AREINDEX)
				MainUse(M_EXCL,.T.)
				REINDEX
				_req:=0
			RECOVER
				ElseUse()
			END
		    ELSE
			BREAK
		    ENDIF
		ENDIF
	ENDIF
RECOVER
	_IndexFile:=_oldInd
	*SET INDEX TO &_indexFile
	OrdListClear()
	OrdListAdd( _Indexfile )
	IF !EMPTY(__tagNom) THEN SET TagOrder to __tagNom
END
_req:=2
**********
FUNC Idx_An(aName,nMin,nUniq,nExpr,Nexpr2,nFor,lOnlyKey)
LOCAL _handle,cRet:=PAD(UPPER(aName[1]),m->_DirShow)+' - ',_tmp,;
	cExpr,cFor

IF ((_handle:=FOPEN(aName[1],64))<0 ) .OR. OpenFileSize(_handle)<nMin
	cExpr:=''
ELSE
	_tmp:=Asc(ReadFromFile(_handle,nUniq,1))
	IF _tmp>31 THEN nExpr:=nExpr2
	cExpr:=ReadFromFile(_handle,nExpr,255)
	IF EMPTY(lOnlyKey)
		IF nFor==0 THEN nFor:=nExpr+LEN(cExpr)+1
		cFor:=ReadFromFile(_handle,nFor,255)
		IF LEN(cFor)>1 THEN cExpr+=' <FOR> '+ cFor
		IF _tmp % 2 = 1 THEN cExpr+=' <Unique>'
		cRet+=' '+cExpr
		IF aName[1]==_IndexFile THEN cRet += ' √ '
	ELSE
		cRet:=cExpr
	ENDIF
ENDIF
IF EMPTY(cExpr) THEN cRet += INDEX_CORRUPT
FCLOSE(_handle)
RETURN cRet
**********
PROC GotoRec(_i)
IF EMPTY(_i) THEN;
	_i:=ForAch(10,REC_FIND,REC_FIND_C)

BEGIN SEQU
 DO CASE
    CASE _i==0
    CASE _i==2
	IF GetName(REC_SM,'_nSm')
		MGoTo(RECNO()+m->_nSm,.t.)
	ENDIF
    OTHER	// _i==1 .OR. _i==3
	IF GetName(REC_GO,'_Ngoto')
		IF TYPE(m->_Ngoto)<>'N' THEN BreakMess(_ErTip)
		IF _i==1
			MGoTo(&_Ngoto,.T.)
		ELSEIF _i==3
			IF !KeyGoTo(&_Ngoto) THEN BreakMess(NO_DPZ)
		ENDIF
	ENDIF
 END
END
IF EOF() THEN GOTO _tmr
**********
PROC LocateFor(lBack)
IF TakeScopeFunc(FUNC_FIND,'_Lcondit',.T.)
  IF EMPTY(lBack)
	__dbLocate( Compile(_LCondit),,,,!Eof() )
  ELSE
	DBSkip(-1)
	IF BOF()
		GO BOTTOM	// все
	ELSE
		DBSkip()	// оставшиеся
	ENDIF
	__dbBackLocate( Compile(_LCondit))
  ENDIF
  CheckFound()
ENDIF
**********
PROC PackProg()
LOCAL nWas:=LASTREC(),cMsg
*scr save/rest  делается в xBrowse
IF !EMPTY(m->_aCommon[1]) .AND. m->lWasMemo
	Nfind(FORCE_PROHIBITED)
	RETURN
ENDIF

IF Continue(NEED_PACK)
	TimerOn()
	BEGIN SEQU
		Waiting(PACKING)
		MainUse(M_EXCL,!Empty(_IndexFile))
		PACK

		_req:=0
		_Tally:=nWas-LASTREC()
		IF _Tally>0
			m->_UndoNew:=.T.
		ENDIF
		cMsg:=REMOVED		//удаленных
		_Tally:=nWas
		OpFinish(cMsg)

	RECOVER
		ElseUse()
	END
ENDIF
**********
PROC SeekInd
LOCAL _ik:=Upper(IndexKey(0)),_tp,_tmp,_tps
IF Empty(_ik)
	Nfind(_noindex)
ELSEIF GetName(I_SEARCH+_Iv+_ik,'_Fcondit')
	_tp:=&_ik
	BEGIN SEQUENCE
		Store Alltrim(_Fcondit) to _FCondit,_tmp

		IF (_tp:=ValType(_tp))=='D' .AND. _Fcondit<':'
			_Tmp:='CTOD(_Fcondit)'
		ELSEIF _tp=='D' .AND. First(_Fcondit)=='{'
			_Tmp:='CTOD(SUBSTR(_Fcondit,2,LEN(_Fcondit)-2))'
		ELSEIF _tp=='C' .AND. (Between(_Fcondit,'0','@') .OR.(_Fcondit>'z'))
			_Tmp:='"'+_Fcondit+'"'
		END

		IF (_tps:=Type(_tmp))=='UI' THEN _tps:=VALTYPE(&_tmp)
		IF _tps<>_Tp
			Nfind(_ERTIP)
		ELSE
			DBSeek(&_tmp)
// не в одном операторе, чтобы реагировать на Softseek
			IF EOF() THEN MessBack(_NFD)
		ENDIF
	END
ENDIF
**********
PROC SeekWild(lContinue,cInit)
LOCAL _ik:=Upper(IndexKey(0)),_tmp
STATIC cWild
IF Empty(_ik)
	Nfind(_noindex)
ELSEIF  VALTYPE(&_ik)<>'C'
	Nfind(_MSG_A_CHARONLY)
ELSEIF !EMPTY(lContinue) .AND. EMPTY(cWild) .AND. EMPTY(cInit)
	Nfind(NO_FIND_EXPR)
ELSE
	BEGIN SEQUENCE
		IF EMPTY(lContinue)
			IF GetName(I_SEARCH+_Iv+_ik,'_Fcondit')
			   Store Alltrim(_Fcondit) to _FCondit,_tmp

			   IF (Between(_Fcondit,'0','@') .OR.(_Fcondit>'z'))
				_Tmp='"'+_Fcondit+'"'
			   END
			   cWild:=&_tmp
			ELSE
				BREAK
			ENDIF
		ELSEIF !EMPTY(cInit)
			cWild:=cInit
		ENDIF
		IF !SX_WildSeek(cWild,lContinue) THEN MessBack(_NFD)
	END
ENDIF
**********
PROC SimpleLoc()
MEMVAR _SimpleLoc,_Lcondit
_SimpleLoc:=m->__Content
IF GetName(_ze + F_SEARCH,'_SIMPLELOC') .AND. TakeScope()
	IniSearching()
	_Lcondit:=IF(__ContentType $ 'MC',;
		[TRIM(_SimpleLoc) $ ] +_C_F,;
		_C_F+[ = _SimpleLoc])

	//IF KeyNo()>1 .AND. _SimpleLoc==m->__Content THEN SKIP
	__DBLOCATE(Compile(_Lcondit),,,,.T.)
	CheckFound()
ENDIF
**********
PROC DispStru(nAuto)
LOCAL	i,_i,_bEval,_flds:={},;
	_fb:=ClearName()+'.ST',;
	aAct,abzac,cIndex,aInfo,;
	_base_struct:=BASE_STRUC

AEval(m->__aDbStruct,{|el,_i| AADD(_flds,Str(_i,3)+'.'+Pad(el[1],17)+;
		ShowTypeLen(el[2],el[3],el[4],el[5]))})
aInfo:=.T.
Information(@aInfo)	//in Help
m->_L:=MAX(38,A_MAXLEN(aInfo))
AADD(_flds,REPL('-',38))
_flds:=A_JOIN(_flds,aInfo)

_i:=_Base_Struct+_base
cIndex:=IF(IsNtx(),'',_CRLF+ SetTag(,.T.)+_CRLF)
_bEval:={||PrintArr(,_i,_flds,cIndex)}
SetKey(K_SH_TAB,_bEval)

aAct:={ {_MSG_A_DS_F2,_bEval},;
	,;
	{_MSG_A_DS_F4,{||PrintArr(_fb+'P',_i,_flds,cIndex)}},;
	{_MSG_A_DS_F5,{||__DbCopyXStruct(_fb+'E'),Nfind(F_CREATE+_fb+'E')}},;
	{_MSG_A_DS_F6,{||_i:='$$BDBF$$',;
			 __DbCopyStruct(_i),;
			 RENAME(_i+'.DBF',_fb+'R'),;
			 RENAME(_i+Sx_MemoExt(),_fb+'T'),;
			 Nfind(F_CREATE+_fb+'R')}},;
	,,;
	{_MSG_A_DS_F9,{||Configure()}},;
	{_MSG_A_DS_F10,{||abzac := ",;"+_CRLF+CHR(9)+CHR(9),;
			  MemoWrit(_fb+'G',;
			  'DBCreate("'+m->_base+'"'+abzac+;
			StrTran(Arr2Str(m->___aDBSTRUCT), "},", "}"+abzac+' ')+;
			";"+_CRLF+CHR(9)+",,.T.)"+_CRLF + cIndex),;
			File_Dial(_fb+'G')}};
      }
IF EMPTY(nAuto)
	IF BETWEEN(;
		    (_i:=ForAch(5,;
			_Base_Struct,_flds,1,'H9',AchKeys(.T.,aAct))),;
		   1,FCOUNT()) .AND.;
	   ASCAN(_Pole,m->__aDbStruct[_i,1])<>0
		KEYBOARD(_CTRLHOME+REPL(_RIGHT,_i-1))	//Встать на поле
	ENDIF
ELSE
	EVAL(aAct[nAuto,2])
ENDIF
AchKeys(.F.)
**********
STATIC FUNC ShowTypeLen(cType,nLen,nDec,cRealType)
IF cType=='V'
	DO CASE
		CASE  nLen==4
			cRealType:='I'
		CASE nLen==3
			cRealType:='D'
		CASE nLen>=6
			cRealType:='M'
	ENDCASE
ENDIF
IF nDec>0 .AND. cType='C'
	nLen:=nDec*256+nLen
	nDec:=0
ENDIF
RETURN PAD(cType+IF(cType<>cRealType,'('+cRealType+')',''),4)+STR(nLen,7)+STR(nDec,6)
**********
PROC CopyRec()
LOCAL _i
IF (_i:=ForAch(10,WHAT_COPY,A_COPY))==2 THEN go bott

IF  _i % 3<>0
	Scatter()
	APPE BLANK
	Gather()
ENDIF
**********
PROC InsRec()
IF  !Empty(IndexKey())
	NFind(NOOP_IND)
ELSEIF TryFLock()
	SET FILT TO
	Insert()
	IF  !Empty(_fltrcond)
		Set Filter TO &_fltrcond
		IF  !&_FltrCond THEN go top
	ENDIF
	_req:=2
ENDIF
**********
PROC ClearRec()
IF TryRlock() THEN AEVAL(DbStruct_(), {|_1| MakeEmpty(_1[1])})
**********
PROC ReplFor(_a,lQuest)
LOCAL _rpl,_beval,_nCnt:=0,_F_type,lEnd,cFld
IF !m->_IsField THEN ReturnMess(CALC_FIELD)
PUSH KEYS

BEGIN SEQUENCE

	m->lCanFunc:=( __ContentType $ 'CM' )	// для возможности выбора
	IF  !GetName(_ZE+REPL_EXPR+Alltrim(_Works[_ptr]),'_Repl');
		THEN Break
	_repl=Alltrim(_repl)

	lEnd:=(_CurType<>'V') .AND.;
	   !(m->_CurRType=='M'.AND.m->_aCommon[5])	//Возможно преобразуем

	IF m->lCanFunc .AND. (_repl>'z')
		_repl:='"'+_repl+'"'
	ENDIF

	_rpl:=&_repl
	_F_Type:=VALTYPE(_rpl)

	IF lEnd
	  DO CASE
		CASE m->lCanFunc	//__ContentType $ 'CM'
			IF _F_Type=='N'
				_rpl:=NTRIM(_rpl)
			ELSEIF _F_Type=='D'
				_rpl:=DTOC(_rpl)
			ENDIF
		CASE _F_Type=='C'
			IF __ContentType $ 'NF' .AND. Between(_rpl,'0','9')
				_rpl:=VAL(_rpl)
			ELSEIF __ContentType = 'D'
				_rpl:=CTOD(_rpl)
			ENDIF
	  ENDCASE
	ENDIF

	IF  VALTYPE(_rpl) # __ContentType .AND. lEnd THEN ;
		BreakMess(_ERTIP)

	IF (_a=K_ALT_F4 .OR. _A=K_CTRL_F4)
		IF TakeScopeFunc(REPLACING,'_RCOND') .AND. TryFlock()
			CheckEsc(.T.)
			_bEval := Compile(_rcond)

// dbeval нельзя из-за ошибок в размере данных
			lEnd:=.F.
			cFld:=RealFldName(_c_f)
			DO WHILE !EOF()
				IF EVAL(_bEval)
				     IF _a=K_CTRL_F4 THEN _rpl:=&(_repl)
				     IF EMPTY(lQuest) .OR.;
					ReplQuest({NEED_REPLACE,'   '+PAD(&_C_F,__mcol-19),'-> '+PAD(_rpl,__mcol-19),''},@lQuest,@lEnd)
					MyRepl(cFld,_rpl,m->_CurRType,.T.)
					*FastRepl(cFld,_rpl)
				     ENDIF
				     _nCnt++
				ENDIF
				IF lEnd .OR. !CheckEsc() THEN EXIT
				DBSkip()
			ENDDO
			m->_tally:=_nCnt
			CheckFound(.T.)
			BREAK
		ENDIF
	ELSE
		IF !lQuest .OR.;
		    CONTINUE({NEED_REPLACE,'   '+PAD(&_C_F,50),'-> '+PAD(_rpl,50)})
			MyRepl(_C_F,_rpl)
		ENDIF
		BREAK
	ENDIF
RECOVER
	go _tmr
END
_req:=2
POP KEYS
**********
STATIC FUNC ReplQuest(aMsg,lQuest,lEnd)
LOCAL i,scr
ScrSave(@scr)
Panel(8,5,17,__mcol-5,aMsg,{m->_im,m->_im,m->_im},2)
READMENU PROMPTS MENU_SCOPE;
	NOBORDER ROW 14 NEEDCENTR STEP 10;
	COLOR {_MenuColor,'n/bg','w+/b',HiddenColor};
	TO i
ScrRest(@scr)

IF i==2
	lQuest:=.F.
ELSEIF i=4
	lEnd:=.T.	//прервать цикл
ENDIF
RETURN BETWEEN(i,1,2)
**********
PROC InsFunc
LOCAL _i,aIns,aFunc,aIns1:={},cTrans,_lf:=_LEFT,_cFld,_cTran,_cPsw
LOCAL _Crf:='('+RealFldName(m->_c_f)
_cFld:= _Crf+')'+_lf
_cTran:=_Crf+',[],[])'+REPL(_lf,5)
_cPsw:= _Crf+',[password])'+REPL(_lf,10)

cTrans:=_MSG_A_IF_TRANS
aIns:=_MSG_A_IF_AINS

aFunc:={'StrTran'+_cTran,;
	'ChrTran'+_cTran,;
	'Upper'+_cFld,;
	'Lower'+_cFld,;
	'Capitalz'+_cFld,;
	'Proper'+_cFld,;
	'OemToAnsi'+_cFld,;
	'AnsiToOem'+_cFld,;
	'Usa2Nation'+_cFld,;
	'Nation2Usa'+_cFld,;
	'CryptStr'+_cPsw,;
	'DeCryptStr'+_cPsw,;
	'Crc_All()',;
	'Descend'+_cFld,;
	'Sx_SlimFast'+_cFld,;
	'Compress'+_cFld,;
	'DeCompress'+_cFld,;
	'Soundex'+_cFld;
	}
AEVAL(aIns,{|_el,_i| AADD(aIns1,Num_S36(_i)+'-'+_el)})
_i:=ForAch(m->_Middlerow-LEN(aIns)/2,_MSG_A_IF_TITLE,aIns1)
__KeyBoard(IF(_i<>0,aFunc[_i],_RIGHT+_lf))
**********
PROC Reindex(lObligate)
LOCAL nRec:=0
IF Empty(IndexCount())
	Nfind(_noindex)
ELSEIF !EMPTY(lObligate) .OR. Continue(NEED_REINDEX)
	TimerOn()
	Meter(1,INDEXING,,LASTREC()*IndexCount())
	BEGIN SEQU
		MainUse(M_EXCL,.T.)
		REINDEX EVAL Meter(2,,(nRec:=nRec+_Sx_Step)) EVERY _Sx_Step
		COMMIT
		m->_tally:=KeyCount()
		CheckFound(.T.)

		_req:=0
	RECOVER
		ElseUse()
	END
ENDIF
**********
PROC SumFor
IF  _CurType $ "LMD" .OR. (_CurType='V' .AND. _Flen[m->_ptr]==3)
	Nfind(NODIGITAL)
ELSEIF TakeScopeFunc(SUMMING,'_SumCond')
	m->__sum := 0
	Bd_DbEval(Compile('__sum:=__sum+'+;
			IF(_curtype=='N',_C_F,'XTOY('+_C_F+',"N")')),;
		 Compile(_SumCond))
	OpFinish(SUM_IS+SpaceString(__sum),__sum)
ENDIF
**********
PROC ContLocate(lBack)
IF Empty(__dbSetLoc())
	Nfind(NO_FIND_EXPR)
ELSE
	IniSearching()
	IF EMPTY(lBack)
		__DbContinue()
	ELSE
		__DbBackContinue()
	ENDIF
	CheckFound()
ENDIF
**********
PROC Zap
IF Continue(NEED_ZAP)
	BEGIN SEQU
		MainUse(M_EXCL)
		ZAP
		IF  !Empty(_IndexFile)
			REINDEX
		ENDIF
		_req:=0
		m->_UndoNew:=.T.	//Сбросить Undo
	RECOVER
		ElseUse()
	END
ENDIF
**********
PROC IndexFor
LOCAL _idx_ext:=RDD_INFO(1)[4], nRec:=0,_if,_ifb
BEGIN SEQU
	IF EMPTY(_NewIndF) THEN _NewIndF:=ClearName()
	_NewInd:=RealFldName(_C_F)		//скорее всего

	IF !GetName(_ZIF+F_INDEXING,'_NewIndF').OR.;
		!TestWriteFile(@_NewIndF,_Idx_ext).OR.;
		!GetName(_GIVE+_Iv,'_NewInd').OR.;
		!GetName(_ZU+F_INDEXING,'_indexFor') THEN BREAK

	_newIndF:=Rtrim(_newIndF)
	_newInd:=Rtrim(_newInd) ; _IndexFor:=Rtrim(_IndexFor)
	Set(_SET_UNIQUE,Continue(IS_UNIQ))

	TimerOn()
	Meter(1,INDEXING,,LASTREC())

	IF !EMPTY(_IndexFor)
        	_if:=_IndexFor
		_ifb:={|| &_IndexFor}
	ENDIF
*
        ordCondSet(_if, _ifb, NIL, NIL,;
			 {|| Meter(2,,(nRec:=nRec+10))},;
			 10, RECNO())
	DbCreateIndex(_NewIndF, _newInd, {|| &_newInd}, )
*
	COMMIT
	_IndexFile:=_oldInd:=_NewIndF

	IF !MGoTo(_tmr) THEN GO TOP
	_req:=2
	m->_tally:=KeyCount()
	CheckFound(.T.)
END
**********
PROC SetFilter()
LOCAL _i
IF MakeFunc(F_FLTRING,'_FltrCond')

  _i:=SetFilt(_FltrCond)
  ScrRest()
  IF EOF()
	go _tmr
	OpFinish(NO_FLTRING)
	_FltrCond:=_i
	SetFilt(_i)
  ELSE
	OpReady()
  ENDIF
ENDIF
**********
FUNC TestMacro(nKey,nRegion)
LOCAL i
IF ((i:=ASCAN(m->_MacroTable, {|x| x[1]==nKey .AND. x[3]==nRegion}))#0) .OR.;
   ((i:=ASCAN(m->_MacroTable, {|x| x[1]==nKey .AND. EMPTY(x[3])}))#0)
	PlayMacro(m->_MacroTable[i,2])
ENDIF
RETURN !EMPTY(i)
**********
PROC PlayMacro(aSequ)
#ifdef __CLIP__
LOCAL aStuff:=""
        AEVAL(aSequ,{|_1| aStuff+=(IF(ValType(_1)=='N',chr(_1),_1))})
        __keyboard(aStuff)
        return
#else
LOCAL aStuff:={}
IF_NIL aSequ IS _macro
IF ValType(aSequ)=='C'
	KEYB aSequ
ELSEIF ValType(aSequ)=='N'
	aStuff:={aSequ}
ELSE
	aStuff:=aSequ
ENDIF
BEGIN SEQU
	AEVAL(aStuff,{|_1| FT_PUTKEY(IF(ValType(_1)=='C',ASC(_1),_1))})
END
#endif
**********
PROC SelectFlds()
LOCAL _flds:={}

AEval(m->__aDBStruct,{|el,_i| AADD(_flds,Pad(el[1],17)+;
		el[2]+Padl(el[3],7)+Padl(el[4],6)+'  [x]')})
m->alSelect:=Ext_Arr(,m->__dfc,.T.)

IF (ForAch(5,FLDS_SELECT,_flds,1,'H3')<>0) .AND.;
   (ASCAN(m->alSelect,.F.)<>0) .AND. (ASCAN(m->alSelect,.T.)<>0)
	_flds:=''
	AEVAL(m->alSelect,{|el,i| IF(el,_flds+=','+TRIM(m->__aDBSTRUCT[i,1]),NIL)})
	_flds:=SUBSTR(_flds,2)
	&_vars:=PAD(_flds,255)
	m->GetList[1]:UpdateBuffer()
	KEYBOARD _END
ELSE
	KEYBOARD _EMP
ENDIF
**********
PROC CopyTo(_BaseTo,cRdd)
LOCAL _bfor,i,cDelim
BEGIN SEQUENCE
	IF Empty(_BaseTo)
		IF !GetName(_ZIF+F_COPYING,'_Newfile') THEN BREAK
	ELSE
		_NewFile:=_BaseTo
	ENDIF
	IF TestWriteFile(@_NewFile,'.DBF',.T.) .AND.;
	   ((i:=DefineTxtDrv(@cRdd,@cDelim))#0) .AND.;
	   GetName(FLDS_COPYING,'_ckField',,,.T.).AND.;
	   TakeScopeFunc(COPYING,'_Cpc')

		_bFor:=Compile(_Cpc)
		IF i==1 //Usual DBF
			IF EMPTY(_ckField)
				__dbCopy( _Newfile, {}, _bFor ,,,,!EOF(), cRdd)
			ELSE
				dbTrans( _Newfile, _ckField, _bFor)
			ENDIF
		ELSE
			__dbDelim(.T., _Newfile, cDelim,;
				IF(EMPTY(_ckField),{},SplitLine(_ckField)),;
				_bFor,,,,,cRdd )
		ENDIF
		go _tmr
		OpReady()
	ENDIF
END
**********
PROC CopyRdd()
LOCAL i,cRdd
IF (i:=ForAch(5,_give+DRV_FOR_COPY,m->__aDrv))<>0
	SX_MemoExt(m->__aMem[i])
	SetRdd((cRdd:=m->__aRdd[i]))
	SetMemoBlock()
	CopyTo(,cRdd)
	SX_MemoExt(m->_DefaultMemo)
	SetRdd(m->_DefaultRdd)
ENDIF
**********
PROC SetMemoBlock
IF !IsNTX()
	m->_nMemoBlSize:=SX_SetMemoBlock()
	IF GetName(MEMO_BLOCK_SIZE,"_nMemoBlSize")
		SX_SetMemoBlock(m->_nMemoBlSize:=MAX(m->_nMemoBlSize,1))
	ENDIF
ENDIF
**********
PROC AppeFrom(_baseAp)
LOCAL _bFor,i,cDelim,cRdd
BEGIN SEQUENCE
	IF Empty(_baseAp)
		IF !GetName(_ZIF+F_ATTACHING,'_Newfile','*.DBF',,,.T.) THEN BREAK
	ELSE
		_NewFile:=TRIM(_baseAp)
	ENDIF

	IF  IsFileExist( @_NewFile,'.DBF') .AND.;
	    (_newFile#_base .OR. Continue(APPEND_SELF)) .AND.;
	    ((i:=DefineTxtDrv(@cRdd,@cDelim))#0) .AND.;
	    MakeFunc(ATTACHING,'_Cpc') .AND. TryFlock()

		_bFor:=_Cpc
		IF _newFile==_base THEN;
			_bFor+='.AND. RECNO()<='+NTRIM(LASTREC())

		_bFor:=Compile(_bFor)

		BEGIN SEQU
			IF i==1
				__dbApp( _Newfile, {}, _bFor)
			ELSE
				__dbDelim(.F., _Newfile, cDelim,{},;
					 _bFor,,,,,cRdd)
			ENDIF

		RECOVER
			IF Empty(alias())
				SELE 1
				MainUse(M_SHARED,.T.)

				IF !Empty(_fltrcond)
					SET FILTER TO &_fltrcond
				ENDIF
			ENDIF
		END

		go _tmr
		OpReady()
		_req:=2
	ENDIF
End
**********
STATIC FUNC DefineTxtDrv(cRdd,cDelim)
LOCAL _i,nRes:=1	//Предполагаем DBF
PRIVATE _cDelim
IF !('.DBF' $ UPPER(_Newfile))
	IF (_i:=ForAch(10,_MSG_A_SDF_FILE_TYPE,_MSG_A_SDF_A_FILETYPE) )==0
		nRes:=0		//BREAK
	ELSEIF _i#4		//для DBF nRes уже определен
		nRes:=2
		IF _i=1
			cRdd:="SDF"
			cDelim:=""
		ELSE
			IF _i=3
				cDelim:="BLANK"
			ELSE
				m->_cDelim:='"'
				GetName(_MSG_A_SDF_F_DELIM,'_cDelim',,"X")
				cDelim:=m->_cDelim
			ENDIF
		ENDIF
	ENDIF
ENDIF
RETURN nRes
**********
PROC SetVar()
LOCAL _var, _Init
BEGIN SEQUENCE
     IF  GetName(GIVE_VAR,'_InitVar')

	IF  Parce(_InitVar,'=',@_var,@_Init) ==0
		IF '[' $ _InitVar .AND. ']' $ _InitVar
			Parce(_InitVar,'[',@_var,@_Init)
			_Init:=Strip(TRIM(_Init), 1)
			Public &_var[&_Init]
		ELSE
			NFIND(BAD_EXPR)
		ENDIF
	ELSE
		StripRight(@_var,':')
		IF 'U' $ TYPE(_var) THEN Public &_var
		&_var:=AKTION(Preproc(TRIM(_Init)))
	ENDIF

    ENDIF
END
**********
PROC CountFor()
IF TakeScopeFunc(COUNTING,'_CountCond')
	m->__count := BD_Dbeval( , Compile(_CountCond))
	OpFinish(IT_RECS,m->__count)
ENDIF
**********
PROC RestFor(cMsg,bEval)
IF TakeScopeFunc(cMsg,'_DELCond') .AND. TryFLock()
	BD_Dbeval( bEval, Compile(_DelCond))
	OpReady()
	_req:=2
ENDIF
**********
PROC ChangeDir()
LOCAL _i
BEGIN SEQUENCE
	IF GetName(DISK_KAT,'_NewDir') .AND. !EMPTY((_NewDir:=ALLTRIM(_NewDir)))
		_i:=Name_Disk()
		StripRight(@_NewDir,PATH_DELIM)
		ChDisk(_NewDir)
		IF ChDir(_NewDir)<>0
			BreakMess(_NewDir+NO_KAT)
			ChDisk(CHR(_i))
		ENDIF
	ENDIF
END
**********
PROC SortFor()
PRIVATE _nCnt:=0
BEGIN SEQUENCE
	IF  GetName(_ZIF+F_SORTING,'_Sortfile') .AND.;
		TestWriteFile(@_SortFile,'.DBF',.T.) .AND.;
		GetName(_ZE+SORTING,'_cksort',,,.T.).AND.;
		TakeScopeFunc(SORTING,'_sortcond')

		__dbSort( _Sortfile,;
			 IF(EMPTY(_ckSort),{},SplitLine(_ckSort)),;
			 Compile('_nCnt:=_nCnt+1,Meter(2,,_nCnt),'+_SortCond),;
			 {||Inkey()<>K_ESC} )
		CheckFound(.T.)
	ENDIF
END
go _tmr
**********
PROC TotalFor()
LOCAL _ik:=Indexkey(0)
IF  Empty(_ik)
	Nfind(_noindex)
ELSE
  BEGIN SEQUENCE
	IF  GetName(PRV_ZIFN,'_TotalFile') .AND.;
		TestWriteFile(@_TotalFile,'.DBF',.T.) .AND.;
		GetName(FLDS_TOTAL,'_cksort',,,.T.).AND.;
		TakeScopeFunc(SUMMING,'_TotalCond')

		__dbTotal( _Totalfile,Compile(_ik),;
			 IF(EMPTY(_ckSort),{},SplitLine(_ckSort)),;
			 Compile(m->_TotalCond))
		CheckFound(.T.)
		go _tmr
	ENDIF
  END
ENDIF
**********
PROC RestIni()
IF GetName(_ZIF+INI_F,'_Inifile','*.ini',,,.T.) .AND.;
   IsFileExist(@_IniFile,'.INI',';'+m->_PlugDir+';'+GetEnv("INCLUDE") )

	BEGIN SEQUENCE
		RestoreIni()
	END
ENDIF

**********
PROC SaveEnv(lObligate)
LOCAL _i
BEGIN SEQUENCE
	IF EMPTY(lObligate)
		IF !GetName(_ZIF+F_ENVIR,'_Vuefile') .OR.;
		   !TestWriteFile(@_VueFile,'.MEM');
			THEN Break
	ELSE
		_vueFile:='BDBFS.MEM'
	ENDIF

	m->__dfc=LEN(m->__adbStruct)
	IF m->_Replay		// Массивы не сохраняются,ручками
		FOR _i=1 to m->__dfc
			m->_a=strzero(_i,3)

			IF _i<=_fc
				__Dp&_A=_Pole[_i]
				__Dw&_A=_Works[_i]
				__DFt&_A=_FType[_i]
				__DFl&_A=_FLen[_i]
				__DFd&_A=_FDr[_i]
				__DPct&_A:=IF(EMPTY(_Pictures[_i]),'',_Pictures[_i])
				__DFRt&_A:=_FRType[_i]
			ENDIF

			__Du&_A=_dubl[_i]
			__Dt&_A=_dtype[_i]
			__Dl&_A=_dlen[_i]
			__Dd&_A=_ddr[_i]
			__DRt&_A:=_drType[_i]
		NEXT
	ENDIF
	SAVE ALL to (_VueFile)
END
**********
PROC RestEnv
IF GetName(_ZIF+ENVIR_F,'_Vuefile','*.MEM',,,.T.) .AND.;
	IsFileExist(@_vueFile,'.MEM')
		m->_NeedRestoreVue=.t.
		_req=0
ENDIF
**********
PROC ModiStru
LOCAL i
IF  2*DbfDskSize()+1024 >= DiskSpace()
	Nfind(NO_SPACE)
ELSEIF  SUBSTR(_base,-4)=='.BAK'
	Nfind(BAD_EXT)
ELSEIF !EMPTY(m->_aCommon[1])
	Nfind(FORCE_PROHIBITED)
ELSE
	BEGIN SEQU
		i:=__DbSetLoc()
		MainUse(M_EXCL)
		m->_req=Modify_Stru(.T.)
		__DbSetLoc(i)
	RECOVER
		ElseUse()
	END
ENDIF
**********
FUNC SetTag(sposob, lForStruct)
LOCAL aTag:={},cTagFull,aTagInfo,_i,aEl,fPrg:=ClearName()+'.TRG'
PRIVATE lAgain
IsTags()

IF IndexCount()>=1 .AND. Sx_TagCount()=0	//Не в текущем каталоге или MDX
	OrdSetFocus(1,__CdxName)
ENDIF

IF SX_TagCount()=0
	IF EMPTY(lForStruct) THEN NFIND(NO_ORDER)
	RETURN ''
ENDIF
IF_NIL sposob IS 3
BEGIN SEQUENCE
  DO CASE
     CASE sposob=0
	IF GetName(_Give+TAG_NUMBER,'__tagNom')
		SET TagOrder to __tagNom
	ENDIF
     CASE sposob=1
	IF GetName(_Give+TAG_NAME,'__tagName')
		Set Tag to &__tagName
	ENDIF
     OTHER
	aTagInfo:=TagInfo()
	cTagFull:="//"+_base+" TAGS"+_CRLF
	FOR _i:=1 TO LEN(aTagInfo)
		aEl:=aTagInfo[_i]
		AADD(aTag,Pad(aEl[1],13)+Pad(aEl[2],44)+' '+Pad(aEl[3],16))
		cTagFull+=(_CRLF+"INDEX ON "+TRIM(aEl[2]) + ";"+_CRLF+;
			"      TAG "+aEl[1])
		IF !EMPTY(aEl[3]) THEN;
			 cTagFull+=(";"+_CRLF+"      FOR "+aEl[3])
		IF aEl[4] THEN;
			 cTagFull+=" UNIQ"
	NEXT

	_i:={||m->_L:=70,PrintArr(,TAG_HEAD,aTag)}
	SetKey(K_SH_TAB,_i)
	aTagInfo:=AchKeys(.T.,{ {_MSG_A_DS_F2,_i},;
				{_MSG_A_DS_F3,{||AddTag(),m->lAchFinish:=.T.,m->lAgain:=.T.,__KeyBoard(_EMP)}},;
				{_MSG_A_DS_F4,{|| MemoWrit(fPrg,cTagFull),;
						  File_Dial(fPrg)}},;
				,,,;
				{_MSG_A_DS_F8,},;
				{_MSG_A_DS_F9,{||Configure()}},;
        			};
			  )
	IF EMPTY(lForStruct) .AND. ;
	   (_i:=ForAch(7,TAG_HEAD,A_Join(aTag,{TAG_NO}),Sx_TagNo(),'HT',aTagInfo))<>0
		Set TagOrder to IF(_i==LEN(aTag)+1,0,_i)
	ELSE
		OrdListClear()
		OrdListAdd( _Indexfile )
		IF !EMPTY(__tagNom) THEN;
			Set TagOrder TO __tagNom	//Мог быть установлен
	ENDIF
	AchKeys(.F.)
	IF !EMPTY(m->lAgain) THEN SetTag(3)	//Если добавили
  ENDCASE
END
__tagNom:=Sx_TagNo()
__tagName:=OrdName()
_req:=2
RETURN cTagFull
**********
PROC AddTag()
LOCAL nRec:=0, _if, _ifb
IsTags()
__tagname:=_NewInd:=RealFldName(_c_f)
IF GetName(_Give+TAG_NAME,'__tagName') .AND.;
	   GetName(_Give+_Iv,'_newInd') .AND.;
	   GetName(_ZU+F_INDEXING,'_indexFor') .AND.;
	   GetName(_ZIF,'__cdxName')

	_newind:=Rtrim(_newInd) ; _indexFor:=Rtrim(_indexFor) ;__cdxName:=Rtrim(__CdxName)
	__tagName:=Rtrim(__tagName)
	Set(_SET_UNIQUE,Continue(IS_UNIQ))

	TimerOn()
	Meter(1,INDEXING,,LASTREC())
	BEGIN SEQU
		IF !EMPTY(_IndexFor)
			_if:=_IndexFor
			_ifb:={|| &_IndexFor}
		ENDIF
*		IF EMPTY(_If) THEN _If:='.T.'
		ordCondSet( _if, _ifb, , , {||Meter(2,,(nRec:=nRec+10))},;
			  10 , RECNO())
		ordCreate( __cdxName, __TagName, _newInd, {|| &_newInd}, )

*		INDEX ON &_NewInd TAG &__TagName TO &__cdxName;
*			FOR &_if  EVERY 10 EVAL Meter(2,,(nRec:=nRec+10))
		__TagNom:=Sx_TagCount(1)
	END
	_tally:=KeyCount()
	IF !MGoTo(_tmr) THEN GO TOP
	CheckFound(.T.)
	_req:=0
END
**********
PROC DelTag(sposob,nTag)
LOCAL aTag:={},aTagInfo,_i, oldTag, cDelTag
IsTags()
IF IndexCount()>=1 .AND. Sx_TagCount()=0	//Не в текущем каталоге или MDX
	OrdSetFocus(1,__CdxName)
ENDIF
IF SX_TagCount()=0 THEN ReturnMess(NO_ORDER)
IF_NIL sposob IS 3
BEGIN SEQUENCE
  oldTag:=OrdName()
  aTagInfo:=TagInfo()
  AEVAL(aTagInfo,;
	{|_1|AADD(aTag,Pad(_1[1],13)+Pad(_1[2],44)+' '+Pad(_1[3],16))})

  IF sposob=0
	__tagName:=''
	IF GetName(_Give+TAG_NAME_DEL,'__tagName')
		cDelTag:=ALLTRIM(__TagName)
	ENDIF
  ELSEIF sposob=1	//из SetTag()
	IF nTag<=LEN(aTag)
		cDelTag:=aTagInfo[nTag,1]
	ENDIF
  ELSEIF (_i:=ForAch(7,TAG_HEAD,aTag))<>0
	cDelTag:=aTagInfo[nTag,1]
  ENDIF
  IF !EMPTY(cDelTag) .AND. Continue(_MM_TAGMENU[2]+' '+cDelTag)
	MainUse(M_EXCL,.T.)
	Waiting(REMOVING)
	OrdDestroy(cDelTag)
	IF oldTag==cDelTag
		__tagNom:=0
		__tagName:=''
	ELSE
		__tagName:=oldTag
	ENDIF
	_req:=0
   ENDIF

RECOVER
	ElseUse()
	__tagName:=oldTag
END

go _tmr
**********
PROC SetCdx()
LOCAL _i,aName,cName,iExt
IsTags()
iExt:=m->_DefaultCdx
BEGIN SEQUENCE
	aName:=Filer('*'+iExt,INDEX_CHOICE,{|el|Cdx_An(el)},;
		     {_zi,'■ No Index'},,{|_1|Ascan(_1,__cdxName)})
	IF aName[1]<>0
		cName:=aName[2]
		IF aName[3] .AND. cName==_zi
			IF !GetName(_ZIF,'_CdxCh') .OR.;
			   !IsFileExist( @_CdxCh,iExt);
					THEN BREAK

			cName:=AllTrim(_CdxCh)
		ELSEIF aName[3]
			cName:=''
		ENDIF

		_IndexFile:=cName
		OrdListClear()
		OrdListAdd( _Indexfile )	// Здесь может брякать
		__CdxName:=cName
		__tagNom:=0
		_oldInd:=_IndexFile
		_req:=2
	ENDIF
RECOVER
	_IndexFile:=_oldInd
	OrdListClear()
	OrdListAdd( _Indexfile )
	_req:=2
END
**********
FUNC Cdx_An(aName)
LOCAL _handle,cRet:=UPPER(aName[1])
IF aName[1]=Sx_IndexName()
	cRet:=' √ '+PAD(cRet,16)

ELSEIF ((_handle:=FOPEN(aName[1],64))<0) .OR.;
	OpenFileSize(_handle) < 3072
	cRet:=PAD(cRet,16)+INDEX_CORRUPT
ELSE
	cRet:=PAD(cRet,16)
EndIF
FCLOSE(_handle)
RETURN cRet
**********
PROC CopyField(sposob)
LOCAL _tmp
IF !m->_IsField THEN ReturnMess(CALC_FIELD)
DO CASE
	CASE sposob=1	.OR. sposob=8		//сверху
		DbSkip(-1)
		IF !BOF()
			_tmp=&_C_F
			IF sposob=8 THEN MyRepl(_C_F,m->__content)
			DbSkip()
			MyRepl(_C_F,_tmp)
		ENDIF

	CASE sposob=2	.OR. sposob=9		//снизу
		DBSkip()
		IF EOF()
			go _tmr
		ELSE
			_tmp=&_C_F
			IF sposob=9 THEN MyRepl(_C_F,m->__content)
			DbSkip(-1)
			MyRepl(_C_F,_tmp)
		ENDIF

	CASE sposob=3		//слева
		MyRepl(_C_F,&(If(_ptr#1,_Pole[_ptr-1],_Pole[_fc]) ))

	CASE sposob=4		//справа
		MyRepl(_C_F,&(IF(_ptr#_fc,_Pole[_ptr+1],_Pole[1]) ))

	CASE sposob=5 .OR. sposob=6
		IF !EMPTY((_tmp:=IF(sposob=5,GetClipboard(),GetWinClip())) );
			THEN MyRepl(_C_F,_tmp)
	*CASE sposob=7
	OTHER
		SetWinClip(m->__content)
ENDCASE
**********
PROC ClipField(sposob)
LOCAL _tmp,cType,_val:=m->__Content
IF BETWEEN(sposob,4,7) .AND. (;
   EMPTY(_ClipText) .OR.;
   !TypeCompatible(cType:=ValType(_ClipText[1]),__ContentType) );
	THEN ReturnMess(_ertip)

DO CASE
	CASE sposob=1
		IF Ascan(_ClipText,_val)=0 THEN A_INS(_ClipText,_val)

	CASE sposob=2
		Nfind(_ClipText,,,CLIPBOARD)

	CASE sposob=3
		CopyField(5)	// в поле

	CASE sposob=4 .AND. cType<>'L'
		_ClipText[1] += _val

	CASE sposob=5 .AND. cType<>'L'
		_ClipText[1] -= _val

	CASE sposob=6 .AND. cType=='N'
		_ClipText[1] *= _val

	CASE sposob=7 .AND. cType=='N'
		_ClipText[1] /= _val

	CASE sposob=8	//Для ввода в GET и MEMO
		ALLTRIM(Medi(GetClipBoard(),4096,''))

ENDCASE
**********
PROC WideEdit()
IF m->_CurrType # 'C' .OR. _CurType == 'V' .OR.;
   !(m->__ContentType $ 'CU')
	KEYBOARD _ENTER
ELSE	//U-для незаполненного V
	DoMemo(RealFldName(m->_C_F),MIN(__mcol-6, _Flen[m->_ptr]),m->_IsField)
ENDIF
**********
PROC FreezeField(nFz)
LOCAL _i,nOldFz:=_BdbfBrow:Freeze,oTbc
IF_NIL nFz IS IF(nOldFz>=_ptr,_ptr-1,_ptr)
IF nFz<LEN(_bdbfbrow:ColCount)
	m->__nFreeze:=nFz

	_BdbfBrow:Freeze:=nFz

	oTbc:=_BdbfBrow:GetColumn(nFz+1)
	oTbc:ColSep:='  '
	_BdbfBrow:SetColumn(nFz+1, oTbc)

	oTbc:=_BdbfBrow:GetColumn(nOldFz+1)
	oTbc:ColSep:=' │'
	_BdbfBrow:SetColumn(nOldFz+1, oTbc)

	_BdbfBrow:Configure()
ENDIF
**********
PROC NewColor(lClear)
LOCAL cNew

IF !EMPTY(lClear)
	cNew:='{1,2})'
ELSEIF GetName(COLOR_COND,'_cb') .AND. !EMPTY(_cb) .AND. TrueCond(_cb)
	cNew:='IF('+TRIM(_cb)+',{6,7},{1,2}))'
ELSE
	RETURN
ENDIF
_req:=2
_BdbfBrow:GetColumn(_ptr):DefColor:=Compile('IF(Deleted(),{4,5},'+cNew)
**********
PROC Extremum(nMode)
IF EMPTY(nMode)
	nMode:=MENU_MAX()
ENDIF
IF !EMPTY(nMode) .AND. TakeScope()
	TimerOn()
	FindMax(nMode==1,_C_F,,.T.)
	OpReady()
ENDIF
**********
PROC FindLong
IF _CurType $ 'CMV' .AND. TakeScope()
	TimerOn()
	OpFinish(LONGEST+NTRIM(FindMax(,_C_F,{|i| Len(Trim(FT_XTOY(i,'C')))},.T.)))
ELSEIF LASTKEY()<>K_ESC
	NFIND(NOCHARACTER)
ENDIF
**********
PROC FindDouble
LOCAL _ik:=IndexKey(0),_var
IF Empty(_ik)
	Nfind(NO_ORDER)
ELSE
	CheckEsc(.T.)
	IniSearching()
	DO WHILE !EOF() .AND. CheckEsc()	// начнем с текущей записи
		_var:=&_ik
		DBSKIP()
		IF &_ik==_var
			SKIP -1
			__DBSetFou(.T.)
			EXIT
		ENDIF
	ENDDO
	CheckFound()
ENDIF
**********
PROC GlobFind()
LOCAL _tmp,_i,scr
STATIC cSrch,lCase:=.T.
*ScrSave(@scr)

BEGIN SEQU
	IF IsShift().AND.!EMPTY(cSrch)	// С Shift- продолжение поиска
		SKIP
	ELSEIF GetName(_ZE+GLOB_FIND,'_GSearch') .AND.;
	   (cSrch:=ALLTRIM(_gSearch))<>''
		lCase:=IF( TYPE(m->_GSearch) $ 'CU',;
				CONTINUE(_MSG_A_CASE_SENSITIVE),;
				.T. )
	ELSE
		BREAK
	ENDIF

	IniSearching((DbfDskSize()-Header())/RecSize())
	_tmp:=GlobalFind(cSrch,lCase)
	Meter(3)
	IF  _tmp = 0
		OpFinish(_NFD)
	ELSE
		IF MGoTo(INT(_tmp))
			*_gSearch:=&_gSearch
			IF !lCase THEN cSrch:=UPPER(cSrch)
			FOR _i=1 to _Fc
				IF  Ascan(_dubl,ALLTRIM(_tmp:=_Pole[_i]))#0
				    _tmp:=IF( _Ftype[_i] $ 'NF',;
						PADL(&_tmp,_FLen[_i]),;
						_tmp:=XTOC(&_tmp,'C') )

				    IF !lCase THEN _tmp:=UPPER(_tmp)
				    IF cSrch $ _tmp THEN EXIT
				ENDIF
			NEXT
			_req:=2
			m->_Tally:=RECNO()
			OpReady()
			IF _i<=_fc THEN;
				keyb(_CTRLHOME+REPL(_RIGHT,_i-1))
		ENDIF
	ENDIF
END SEQU
*ScrRest(scr)
**********
FUNC GlobalFind(cSearch,lCase)
#define FilePos() Fseek(_MainHandle,0,1)
#define BufSize 16384
LOCAL cString:=space(BufSize),nCPos,nSize,nBytes, nSearch,nAtPos,nCur:=RECNO(),;
	_MainHandle:=FOPEN(m->_base, 64)
IF (nSearch:=Len(cSearch))#0
  IF !lCase THEN cSearch:=UPPER(cSearch)

  Fseek(_MainHandle,Header()+RecSize()*(Recno()-1))
  nCPos:=FilePos() ; nSize:=DbfDskSize()

  DO WHILE InKey()#K_ESC .AND. (nSize - nCpos)>nsearch
	Meter(2,,INT((ncPos-Header())/RecSize()))
	nBytes:=Fread(_MainHandle,@cString,BufSize)
	IF !lCase THEN	cString:=UPPER(cString)
	IF (nAtPos:=AT(cSearch,cString))#0 		// найдено !
		nAtPos:=1+(ncPos+nAtPos-Header())/RecSize()
		_Tally:=nAtPos-nCur+1
		FCLOSE(_MainHandle)
		RETU nAtPos
	ENDIF
	nCpos+=nBytes - nSearch + 1
	Fseek(_MainHandle,nCPos)
  ENDDO
  _Tally:=LASTREC()-nCur+1
ENDIF
FCLOSE(_MainHandle)
RETU 0
**********
PROC CalcExpr
LOCAL xRes
IF GetName(_ZE+CALC_EXPR,'_Econd')
   BEGIN SEQUENCE
	TimerOn()
	xRes:=__Go:=AKTION(Preproc(_Econd))	//in common.prg
	IF VALTYPE(xRes)=='C' THEN xRes:='"'+xRes+'"'
	Nfind(xRes,__go,, RESULT_IS + TRIM(_econd))
  END
  xRes:=NIL
ENDIF
**********
PROC Chg_Recs(nWhere)
LOCAL nRec:=RECNO()
SKIP( nWhere)		// -1,1

IF bof() .OR. eof()
	go nRec
ELSE
	SWAP(nRec,RecNo())
ENDIF
**********
PROC SaveRestStack(nKey)
LOCAL _i
IF Between((_i:=WaitKey(20)-47),1,10)
	IF nKey=K_CTRL_K
		m->_StackPos[_i]:=RECNO()
	ELSE
		Mgoto(m->_StackPos[_i],.t.) //THEN go _tmr - в самой MgoTo
	ENDIF
ELSE
	__KEYBOARD(chr(_i+47))
ENDIF
**********
FUNC CryptStr(cStr,cPsw)
IF_NIL cPsw IS ''
RETURN Sx_EnCrypt(cStr,cPsw)
**********
FUNC DeCryptStr(cStr,cPsw)
IF_NIL cPsw IS ''
RETURN Sx_DeCrypt(cStr,cPsw)
**********
FUNC CryptBase(cBase,cPsw)
LOCAL res
IF_NIL cPsw IS ''
BEGIN SEQU
	dbUseArea( .T.,, (cbase), "", M_EXCL)
	res:=SX_DBFEncrypt(cPsw)
	USE
RECOVER
	NFIND(_ElseUse)
END
SELE 1
RETURN res
**********
FUNC DeCryptBase(cBase,cPsw)
LOCAL res
IF_NIL cPsw IS ''
BEGIN SEQU
	dbUseArea( .T.,, (cbase), "", .F.)
	SX_SetPass(cPsw)
	res:=SX_DBFDecrypt()
	USE
END
SELE 1
RETURN res
**********
PROC MFiler()
LOCAL aView:={, {_MSG_A_MF_F3,{||m->__mfAct:=3,__KeyBoard(_ENTER)}},;
		{_MSG_A_MF_F4,{||m->__mfAct:=4,__KeyBoard(_ENTER)}},;
		,,,,,;
		{_MSG_A_MF_F10,{||m->__mfAct:=10,__KeyBoard(_ENTER)}};
		}
LOCAL aFile,cFile:='',i
DO WHILE .T.
	m->__mfAct:=0	// признак редакции,просмотра,чтения описания
	aFile:=Filer(,,,,aView,{|_1|Ascan(_1,cFile)},'HF2')
	IF aFile[1]<>0
		cFile:=aFile[2]
		IF m->__mfAct=4
			ModiFile(cFile)
		ELSEIF m->__mfAct=3
			ViewFile(cFile,,.F.)
		ELSEIF m->__mfAct=10
			i:=Description(cFile)
			NFind(IF(EMPTY(i),_MSG_A_MF_DSCR,i))
		ELSE
			ShowFile(cFile)
		ENDIF
	ELSE
		EXIT
	ENDIF
ENDDO
**********
FUNC NewBase(cBase,lExit)
LOCAL cbClr,lRes
IF EMPTY(cBase)
	IF !GetName(_ZIF,'_NewName') THEN RETURN .F.
ELSE
	IF EMPTY(lExit)
		USE
		FERASE(m->_base)	//Себя предварительно созданного
	ENDIF
	m->_NewName:=cBase
ENDIF

cBase:=ADD_EXT(m->_NewName,'.DBF')
//IF LEN(cBase)>16 THEN cBase:=LFNShort(cBase)
IF TestWriteFile(cBase)
	USE
	m->_base:=cBase
	FERASE(cbClr:=ClearName()+m->_DefaultCdx)
	FERASE(cbClr+m->_DefaultMemo)
	DBCREATE(cBase,{{'NEWFIELD','C',10,0}},,.T.,"")
	IF EMPTY(lExit)
		_req:=Modify_stru(.F.)
		m->bAutoExec:=NIL	//Чтоб не выйти
	ENDIF
	lRes:=.T.
ELSEIF !EMPTY(lExit)
	m->_base='*'
ENDIF
RETURN lRes
**********
#IFNDEF ENGLISH
PROC TakeKr(_sposob)
LOCAL	_i:=_sposob, cMsg:='Проверяем лицевой счет: ',;
	cPictUkr:='@R 9999.x.9.99999999',;
	cPictRus:='@R 99999.X.99.x.99999999999',nHl:=6
IF EMPTY(_i)
	_i:=ForAch(10,[Вычисляем контрольный по:],;
		{'Счету Украины','Счету России','МФО','ОКПО'})
ENDIF
IF _i==1 .AND.  GetName(cMsg,'_ks',,cPictUkr) .AND. ;
		GetName('От МФО (5 или 6 знаков)','_kmfo',,'999999')
	_i:=vkrz14(m->_ks,m->_kmfo)
	cMsg:=TRANSF(_i,cPictUkr)
ELSEIF _i==2 .AND. GetName(cMsg,'_ksR',,cPictRus) .AND.;
		   GetName('От РКЦ (2 или 3 знака)','_krkc')
	_i:=vkrz20(m->_ksr,m->_krkc)
	cMsg:=TRANSF(_i,cPictRus)
	nHl:=12
ELSEIF _i==3 .AND. GetName('МФО (5-знаков)','_kmfo',,'99999')
	cMsg:=_i:=vkrz1(m->_kmfo)
ELSEIF _i==4 .AND. GetName('ОКПО (8-знаков)','_kokpo',,'99999999')
	cMsg:=_i:=OkpoTst(m->_kokpo)
	nHl:=8
ELSE
	RETURN
ENDIF
NFIND(ALLTRIM(cMsg),_i,,,,,nHl)
#ENDIF
**********
FUNC ModiFile(FileName)
LOCAL _res,cFile
PRIVATE _MemoPrnt:=512
IF !EMPTY(FileName)
	m->_TxtFile:=FileName
ELSEIF !GetName(TXT_NAME,'_TxtFile',FILE_MASK,,,.T.) .OR. EMPTY(m->_TxtFile)
	RETURN .F.
ENDIF
_Res:=MemoRead(cFile:=ALLTRIM(m->_TxtFile))
_Res:=Memo_Edit(@_Res,{_TxtMedit},'File: '+cFile,.t.,,cFile)
RETURN IF(LastKey()=K_ESC,.F.,MemoWrit( cFile,_Res))
**********
PROC IniSearching(nMuch)
TimerOn()
#IFDEF ENGLISH
	Meter(1,FUNC_FIND,,,nMuch)
#ELSE
	Meter(1,'поиск',,,nMuch)
#ENDIF
**********
PROC UserMenu()
IF Type("m->UserMenuPrompt")+Type("m->UserMenuAct")<>"AA"
	ReturnMess(MSG_USERMENU_NO)
ENDIF
SecondMenu(m->UserMenuPrompt,m->UserMenuAct,;
	m->_middlecol-A_MaxLen(m->UserMenuPrompt)/2-1,7,,_MSG_A_UMENU,.T.)
**********
FUNC TryFlock()
LOCAL lRes
WHILE !FLOCK() .AND. Continue(_MSG_A_FLOCK,1)
ENDDO
IF !(lRes:=FLOCK())
	Meter(3)
	Go _tmr
ENDIF
RETURN lRes
**********
FUNC TryRlock()
WHILE !RLOCK() .AND. !SX_RLOCK() .AND. Continue(_MSG_A_RLOCK,1)
ENDDO

RETURN RLOCK() .OR. SX_RLOCK()
**********
PROC CheckDBFSize()
LOCAL dbSize, fSize, xSize, scr, i, nRec, _MainHandle

BEGIN SEQU
    dbSize:=DbfSize()	//Надо определить до эксклюзивного открытия
    nRec:=LASTREC()
    MainUse(M_EXCL)
    _MainHandle:=FOPEN(m->base, 64)

    BEGIN SEQU

	fSize:=DbfSize()

	xSize:=BIN2L( ReadBin(_MainHandle,4,4) )*RecSize() + Header()

	IF (xSize == dbSize) .AND. ABS(fSize - dbSize) <= 1
		NFind(_MSG_A_CSIZE_NOERR)
		BREAK
	ENDIF

	ScrSave(@scr)
	Panel(5,6,18,73,_MSG_A_CSIZE)
	i:=BarMenu({DefItem(13,10,16,27,_MSG_A_CSIZE_MENU1),;
		    DefItem(13,30,16,42,_MSG_A_CSIZE_MENU2),;
		    DefItem(13,45,16,57,_MSG_A_CSIZE_MENU3),;
		    DefItem(13,60,16,69,_MSG_A_CSIZE_MENU4)},1)
	ScrRest(scr)
	IF i % 4 = 0 THEN BREAK

	IF i=2	//по заголовку
		dbSize:=xSize	//Логический выправится сам
	ELSE
		IF i=3	//по файлу
			// Записей - выровненных до ближайшего размера
			IF ABS(fSize - dbSize) >1
				nRec:=INT((fSize-Header()) / RecSize())+1
				dbSize:=Header() +RecSize()*nRec
			ENDIF
		ENDIF
		FSEEK(_MainHandle,4)
		FWRITE(_MainHandle,L2BIN(nRec),4)
	ENDIF
	FSEEK(_MainHandle,dbSize)
	FTRUNC(_MainHandle)
    END
	_req:=0
RECOVER
	ElseUse()
END
**********
FUNC SelectBase
LOCAL aNames,cFile
aNames:=Filer(m->_mask,SELECT_BASE,,{_zi},,{|_1|Ascan(_1,m->_base)})
IF aNames[1]#0
	IF aNames[3]		// задать файл
		m->_dbfc=''
		IF !GetName(m->_ZIF,'_dbfc') .OR.;
		   !IsFileExist( @_dbfc,'.DBF') THEN;
			RETU .f.

		cFile:=m->_dbfc
	ELSE
		cFile:=aNames[2]
	ENDIF

	IF m->_base# cFile .OR. !USED()	// помогает при блокировке
		SavePrev()
		m->__aPrev[1]:=NIL
		m->_FltrCond:=''
		m->_base=cFile
		m->_tmr=1	// во вновь избранной базе встать на 1 запись
		m->_OldInd=''
		m->_StackPos:={0,0,0,0,0,0,0,0,0,0}
		m->_Replay=.f.
		m->_req:=0
		RETU .t.
	ENDIF
ENDIF
RETU .f.
**********
PROC SavePrev()
m->__aPrev[2]:={m->_base,m->_NewIndF,m->_oldind,;
		m->__tagNom,m->__tagName,m->_tmr,m->_FltrCond}
IF USED() THEN ReadAutoOpen(.T.)	//Секцию закрытия
**********
PROC ReOpenPrev()
IF !EMPTY(m->__aPrev[2])
	m->__aPrev[1]:=ACLONE(m->__aPrev[2])
	SavePrev()
	m->_base:=m->__aPrev[1,1]
	m->_StackPos:={0,0,0,0,0,0,0,0,0,0}
	m->_Replay=.f.
	m->_req:=0
ENDIF
**********
FUNC DoMemo(_Fld,nWide,lEd,cFoot,lNoRepl,cEdit)
LOCAL _i,cHead,lArr
IF_NIL lEd IS .T.
IF_NIL cFoot IS FIELD_ED+_fld
IF_NIL cEdit IS &_Fld
cHead:=IF(lEd,_TxtMedit,'Up Down PgUp PgDn'+m->_ABORT)
BEGIN SEQU
	lArr:=TYPE(_Fld)=='A'
	_i:=FT_XTOY(cEdit,'C')

	_i:=Memo_Edit(@_i,{cHead},cFoot,lEd,nWide)
	IF lEd .AND. _i<>NIL
		_i:=Exclude(_i,[Н]+_LF)
		IF lArr	//TYPE(_i)=='A'	// почему-то не всегда работает
			_i:=&(_i)
		ENDIF
		IF EMPTY(lNoRepl) THEN MyRepl(_Fld,_i)
	ELSE
		_i:=NIL
	ENDIF
END
RETU _i
**********
FUNC MakeFunc(_txt,_varu,lRest)
LOCAL cSkl,nMuch
m->_tally:=0
IF GetName(_ZU+_txt+IF(EMPTY(lRest),EMPTY_IS_ALL,''),_varu) .AND.;
   TrueCond(@&_varu)
	*ScrSave()

	#IFNDEF ENGLISH
		IF (cSkl:=Substr(_txt,-1)) $ 'яи'
			_txt:=CHG_EXT(_txt,1,IF(cSkl='я','е','а'))
		ELSE
			_txt:=SUBSTR(_txt,1,LEN(_txt)-1)
		ENDIF
	#ENDIF

	TimerOn()
	Meter(1,_txt)
	RETU .t.
ELSE
	go m->_tmr
ENDIF
RETU .f.
**********
FUNC TakeScopeFunc(_txt,_varu,lRest)
RETU TakeScope() .AND. MakeFunc(_txt,_varu,lRest)
