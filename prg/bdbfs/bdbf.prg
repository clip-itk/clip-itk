/*
    Copyright (C) 1998-2004 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
#include "dbinfo.ch"
REQUEST dbfntx
REQUEST dbfcdx
REQUEST dbfctx
REQUEST vfpcdx
REQUEST dbfidx
REQUEST sixcdx


* System messages

MEMVAR _DefaultRDD,_DefaultMemo,_DefaultCDX,__ContentType,_fc,;
	_bm,_cm,_im,_rev,_HdColor,_MenuColor,__mcol,__mrow,_middlecol,;
	Main_Keys,;
	_oldind,_ddr,_dLen,_dType,_dubl,_fdr,_flen,_ftype,_works,;
	_pole,_pictures,_widths,_fltrcond,lWasMemo,_MacroTable,;
	_aDbStruct,__adBStruct,_CDXName,__aPrev,cOrig,cValType,_tmp
STATIC	_corrupted:=_STAT_CORRUPTED
STATIC	_SetFBase:='____save.sav'
STATIC	nUndoCrt:=0
**********
PROC Main(p01,p02,p03,p04,p05)
LOCAL _DosC,_i,lNewMemoFormat,lSavedForced,i,aParams:={p01,p02,p03,p04,p05}

m->_base:=p01

Devices()
m->_AutoSave:=.F.
m->_AutoRestore:=.F.
m->_aGlbHCond:={}	// command history
m->_aGlbHRes:={}	// result history
m->_aCommand:={}	// translated commands
m->_MacroTable:={}	// Macrokeys

m->_UndoSize:=1024
m->_UndoBuff:=NIL	//Array will be declated in MainCycle()
m->_UndoNew:=.T.	//Clear buffer

m->bAutoExec:=NIL	//Block from command line
m->Main_keys:=Brow_M_Keys
m->Alt_Keys:=Brow_A_Keys
m->Ctrl_Keys:=Brow_C_Keys
m->Shift_Keys:=Brow_S_Keys

m->_PushFKeys:={}
m->_PushKeys:={}

m->_PlugDir:=LEFT(GetPath(),RAT(PATH_DELIM,GetPath()))+'PLUGINS'
m->_NeedRestoreVue:=.F.
_i:=.F.
IF  PCount()=0
	m->_base:=''
	Read1StIni()
	IF Really(m->_AutoRestore)	// from INI
		m->_NeedRestoreVue:=.T.
	ELSE
		#IFDEF __CLIP__
			m->_base:='*'
		#ELSE
			_i:=.T.
		#ENDIF
	ENDIF
ELSEIF  m->_base $ '/?-?-H-h'
	_i:=.T.
ENDIF

m->_tmp:=''
m->_mask:='*.dbf'

m->_Zu:=PRV_ZU
m->_ZIF:=PRV_ZIF
m->_Iv:=PRV_IV

m->_ABORT:=PRV_ABORT

Set(_SET_CONSOLE,.F.)
Set(_SET_SCOREBOARD,.F.)	// FOR MENU
m->score_row:=0
m->score_col:=16

Set(_SET_DATEFORMAT, DATEFORMAT)	//.ch
Set(_SET_EPOCH, 1945)
Set(_SET_EXACT,.t.)
Set(_SET_CONFIRM,.t.)
Set(_SET_EXCLUSIVE,.f.)
Set(_SET_EXIT, .t.)
Set(_SET_INSERT, .t.)
Set(_SET_CANCEL,.f.)		&&Cancel AltC - only culturally
Set(_SET_WRAP, .t.)
SetBlink(.F.)
SetCursor(0)
SetCancel(.F.)
SetKey(K_ALT_F10, {||BliRun()})

#IFDEF __CLIP__
#IFDEF ENGLISH
	Set("DBF_CHARSET", "cp437")
#ELSE
	Set("DBF_CHARSET", "cp866")
#ENDIF
	SET TRANSLATE PATH OFF
	SET DISPBOX OFF
	Set("FIRST_DAY_WEEK", CHR(0))
	Set(_SET_OPTIMIZE, .t.)
#ENDIF

m->_Sx_Step:=100
m->_lMeter:=.T.
m->_MemoEditor:=''
m->_TextViewer:=''
m->_timing:=.T.
m->_cPsw:=""	//Password for crypted bases

m->HiddenColor:='w/b'
FOR i:=2 TO PCOUNT()
	IF UPPER( aParams[i] )=='/BW'
		_tmp:=.T.
	ENDIF
NEXT
*
IF !EMPTY(_tmp)
	_BM:='W/n,n/W,N,W+/n,n+/w,b+/w,b+/n' ; _rev:='W/n'
	Stor 'n/w,W+/n' to _Im,_CM,_MenuColor,_HdColor
ELSE
	_CM:='Gr+/N'
	_BM:='w/b,n/bg,N,w+/r,r/w,w+/b,w+/r'
	_rev:='n/bg'
	_Im:='w+/b,n/w'
	_MenuColor:='Gr+/b,g+/b'
	_HdColor:='G+/b'
ENDIF
_DosC:=SetColor(_bm)

Stor 0 to m->__sum,m->__Count,m->__go,m->_fc,;
	  m->_Plength,m->_Lmargin,m->_ms,;
	  m->__tagNom,m->_tally,m->_MainHandle,m->__nFreeze

#IFNDEF ENGLISH
	STORE 0 TO m->_kmfo,m->_kokpo,m->_krkc
	m->_ksR:=space(20)
	m->_ks:=space(14)
#ENDIF

m->_MemoPrnt:=80	//as FoxPro
m->_MemoNumLines:=10	//Strings in memo while printed
m->_nMemoWrap:=255	//no longer
m->_nMemoTab:=8
m->_DefaultBorder:=':'	// in Medi
m->_DefaultHBorder:=':'
m->_DirShow:=32		// Width of the filenames display
m->_USA_Keyboard:=SET_OF_USA
m->_My_Keyboard:=SET_OF_MYKB
m->_Ansi_Set:=SET_OF_ANSI
m->_Oem_Set:=SET_OF_OEM
m->_nBrowMaxField:=4000

STORE '' TO m->_Lcondit,m->_fcondit,m->_sumCond,m->_pcond,m->_Econd,;
	m->_CountCond,m->_DELCond,m->_Repl,m->_Rcond,m->_NewDir,m->_oldInd,;
	m->_macro,m->_NewFile,m->_NewInd,m->_newIndF,m->_F_Out,;
	m->_cpc,m->_initVar,m->_pSCode,m->_peCode,m->_fltrcond,m->_sortcond,;
	m->_sortfile,m->_cksort,m->_ckfield,m->_Gsearch,m->_cb,;
	m->_simpleLoc,m->__TagName,m->_indexfor,m->place,m->_NGOTO,;
	m->__CdxName,m->__CurBase,m->_HtmlFile,m->_HtmlCond,;
	m->_XlsFile, m->_XlsCond,;
	m->_XmlFile, m->_XmlCond,;
	m->_TotalCond,m->_TotalFile,m->_TotalExpr,;
	m->_Memo_Ext_File,m->_IniFile,m->_IniPFile,m->_IdxCh,m->_CdxCh,m->_NewName,;
	m->_txtFile,m->_GFCond,m->_indexFile

STORE .t. TO m->_NeedRec,m->_NeedPrPage,m->_NeedHeadPage,m->_NeedEject,;
	m->_NeedMainHead,m->_RecRight,m->_NeedSum,m->_lexp_o2a,m->_lexp_o2aq,;
	m->_lGFCond, m->_lPckAsk
STORE .f. TO m->_replay,m->_ResetFields,m->_NeedCentr,m->_NeedRestIni,;
	     m->_NeedApFile, m->_PrintZero,m->_lDgtHdr,m->_lDhAll,;
	     m->_lPckCheck,;
	     m->_lTitleAll,m->_lGSExp //,_lHasMemo
m->_ClipText:={}	// Internal buffer
m->_ClipChoice:=.T.	// If .T. - we offer a choise.
m->_ClipWText:={}       // System buffer
m->_ClipWChoice:=.F.	// If .T. - we offer a choise.
m->_lCnvWClip:=.F.	// Transform while copyed to buffer

m->_Scatter:=NIL
m->__aExt:={{"" , ""}}		//File associations

m->_printer:='PRN'
m->_StackPos:={0,0,0,0,0,0,0,0,0,0}
STORE 1 to m->_tmr,m->_Pspacing,m->_pageno,m->_plineNo,m->_nSm
m->_told:=Seconds() // Timer

m->__aRdd:={'DBFCDX','DBFNTX','DBFCTX','VFPCDX','SIXCDX','DBFIDX'}
m->__aDrv:={'FoxPro  (CDX,FPT)',;
	    'Clipper (NTX,DBT)',;
	    'Clip    (CTX,DBT)',;
	    'VFP     (CDX,FPT)',;
	    'SIXCDX  (CDX,FPT)',;
	    'FoxOld  (IDX,FPT)';
}
m->__aMem:={'.FPT','.DBT','.DBT','.FPT', '.FPT', '.FPT'}
m->__aCdx:={'.CDX','','.CTX','.CDX', '.CDX', ''}

m->_DefaultRDD:='DBFCDX'
m->_DefaultMemo:='.FPT'
m->_DefaultCDX:='.CDX'

IF _i	//Without parameter or question
	HELP("CMDLINE",,,_CopyRight)
	Quit
ENDIF

PRIVATE _MainMemoFile,;	//Memo file name
	_nMemoBlSize,;	//Memo block size
	_aCommon,;	//Common information about DB, array will filled in RealStruct()
	_aDbStruct,;	//Structure variable (global)
	__aDbStruct,;	//without the fiction fields
	___aDbStruct,;	//without the fiction fields and additional parameters
	__RealFlds	//real header - will written in RealStruct()
			//and will returned to MakeRealStruct()

m->_lForced:=.F.	//Forced mode
m->__aPrev:=Array(2)	//Use for fast reopening

IF (_i:=FOPEN('European.Mem',64))>0
	m->European:=ReadBin(_i,32,255)
	FCLOSE(_i)
ENDIF

m->_VueFile:='BDBFS.MEM'
IF  '.MEM' $ m->_base .AND. FileExist(@_base)
	m->_VueFile:=m->_base;	m->_NeedRestoreVue=.T.
ENDIF

Read1stIni()
Devices()	// may be mistake in INI - then variables needed

FOR i:=2 TO PCOUNT()
  _tmp:=Exclude(UPPER(aParams[i]),"/")

  IF IsLefts(m->_tmp,'I=')
	_oldInd:=SUBSTR(m->_tmp,3)
  ELSEIF IsLefts(m->_tmp,'HTM')
	IF Parce(m->_tmp,'=',,@_HtmlFile)==0 THEN;
		m->_HtmlFile:=ClearName()
	m->bAutoExec:={|| Tb2Html(m->_HtmlFile)}
  ELSEIF IsLefts(m->_tmp,'XLS')
	IF Parce(m->_tmp,'=',,@_XlsFile)==0 THEN;
		m->_XlsFile:=ClearName()
	m->bAutoExec:={|| Tb2XLS(m->_XlsFile)}
  ELSEIF IsLefts(m->_tmp,'XML')
	IF Parce(m->_tmp,'=',,@_XmlFile)==0 THEN;
		m->_XmlFile:=ClearName()
	m->bAutoExec:={|| Tb2XML(m->_XmlFile)}
  ELSEIF IsLefts(m->_tmp,'PRINT')
	IF Parce(m->_tmp,'=',,@_IniPFile)==0 THEN;
		m->_IniPFile:=ClearName()
	m->bAutoExec:={|| RestPrintIni(m->_IniPFile)}
  ELSEIF m->_tmp=='REINDEX'
	m->bAutoExec:={|| Reindex(.T.)}
  ELSEIF m->_tmp=='REBUILD'
	m->bAutoExec:={|| RebuildAll(.T.)}
  ELSEIF m->_tmp=='CHECK'
	m->bAutoExec:={|| CheckDbfSize()}
  ELSEIF m->_tmp=='PACK'
	m->bAutoExec:={|| PackProg()}
  ELSEIF IsLefts(m->_tmp,'STRUCT_')
	IF (_i:=AT(SUBSTR(m->_tmp,8,4), 'PRIN    FILEEXTECOPY            PROG'))<>0 .AND.;
	   (_i % 4 = 1)
		m->bAutoExec:={|| DispStru( INT(_i / 4)+1 )}
	ENDIF
  ELSEIF m->_tmp=='CREATE'
	*m->bBeforeMain:={|| NewBase(m->_base), m->bBeforeMain:=NIL}
	IF !EMPTY(NewBase(m->_base,.t.));
		THEN  m->bAutoExec:={||NewBase(m->_Base) }
  ELSEIF m->_tmp $ 'DBFCDX DBFNTX DBFCTX VFPCDX SIXCDX DBFIDX'
	m->_DefaultRDD:=m->__aRdd[ ASCAN(m->__aRdd,{|_1|m->_tmp $ _1})]
  ELSEIF m->_tmp=='FORCED'
	m->_lForced:=.T.
  ENDIF

NEXT
#ifdef __CLIP__
        showtime(0,maxcol()-7,.f.,m->_bm,.f.,.f.)
#endif

DO WHILE .t.
	SetColor(_bm)
	Scroll()
	IF m->_NeedRestIni THEN RestoreIni()
	IF m->_NeedRestoreVue
		REST FROM (m->_VueFile) ADDI

//The costs of inheritance of previous versions
		lNewMemoFormat:=(TYPE('__DPct001')=='C')
		lSavedForced:=(TYPE('__DRT001')=='C')

		IF m->_Replay
			PUBLIC	_Pole:={},_Works:={},;
				_FType:={},_FLen:={},_FDr:={},;
				_FRType:={},;
				_Pictures:=ARRAY(m->__dfc),;
				_Widths:=ARRAY(m->__dfc),;
				_Dubl:={},_Dtype:={},_Dlen:={},_Ddr:={},;
				_dRType:={}

			FOR _i:=1 to m->__Dfc
				m->_a:=strzero(_i,3)
				IF _i<=m->_fc
					AADD(m->_Pole,__DP&_A)
					AADD(m->_Works,__DW&_A)
					AADD(m->_FType,__DFt&_A)
					AADD(m->_FLen,__DFl&_A)
					AADD(m->_FDr,__Dfd&_A)
				ENDIF

				AADD(m->_dubl,__Du&_A)
				AADD(m->_dtype,__Dt&_A)
				AADD(m->_dlen,__Dl&_A)
				AADD(m->_ddr,__Dd&_A)

				IF lNewMemoFormat
					IF _i<=m->_fc
						m->_Pictures[_i]:=IF(EMPTY(__DPct&_A),,__DPct&_A)
						RELE __DPct&_A
					ENDIF
					IF lSavedForced
						AADD(m->_drType,__drt&_a)
						IF _i<=m->_fc
							AADD(m->_FRType,__dfrt&_a)
						ENDIF
						RELE __drt&_a,__dfrt&_a
					ENDIF
				ENDIF

				RELE __dp&_a,__dw&_a,__dFT&_A,__Dfl&_a,__Dfd&_a,;
				     __Du&_a,__Dt&_a,__Dl&_a,__dd&_a,__ddw&_a
			NEXT
		ENDIF

		m->_NeedRestoreVue=.f.
		m->_UndoNew:=.T.
	ENDIF

	Devices()
	IF  MainCycle() THEN	Exit
ENDDO
HideMouse() ; SetColor(_DosC) ; SetCursor(1)
Scroll() ; DevPos(0,0) ; erase (_setfBase)
**********
STATIC PROC Read1stIni()
STATIC lWas:=.F.
IF lWas THEN RETURN	//have read
m->_lPlain:=.T.		//if errors, then Nfind outputs as text
m->_IniFile:=Sx_FnameParser(GetPath(),.t.)+'.INI'
IF FileExist(@_IniFile) .AND.;
   (m->_IniFile<>Currentdir()+PATH_DELIM+'BDBFS.INI');	//to avoid twice reading
	THEN RestoreIni(m->_iniFile)	// primary
m->_IniFile:='BDBFS.INI'
IF '.INI' $ m->_base
	m->_IniFile:=m->_base
ELSEIF File(m->_iniFile)
ELSEIF File('BDBF.INI')
	m->_IniFile:='BDBF.INI'
ENDIF
IF (m->_NeedRestIni:=File(m->_IniFile)) THEN RestoreIni()
lWas:=.T.
**********
#define QuitMess(mess) Nfind(m->_base+mess) ; RETURN !SelectBase()
FUNC MainCycle()
LOCAL _i,_iloc:=__DBSetLoc(),_alias:=m->__CurBase, _Error,;
      cFirstByte,aDbf,lMemo,cName,cN,aN
STATIC lReplWasMemo:=.F.
PRIVATE lWasMemo
dbCloseAll()
IF '.INI' $ m->_base THEN m->_base:='*'

IF !IsFileExist(@_base,'.DBF') THEN RETURN !SelectBase()
HideMouse()

@ 0,22 say '  '+PAD(BDBF_VERSION,25) color _bm
IF  '*' $ m->_base .OR. '?' $ m->_base

	IF '.' $ m->_base THEN m->_mask := m->_base

	IF  !SelectBase() THEN	RETU .t.
ENDIF

SetColor(_bm)
_i:=CheckDbf(m->_base,@lWasMemo,@cFirstByte)
lReplWasMemo:=m->lWasMemo
IF EMPTY(_i) THEN;
	RETURN IF(EMPTY(m->bAutoExec),!SelectBase(),.T.)
RDDSetDefault(_i)


BEGIN SEQU
	dbUseArea( .F.,, (m->_base), "_mBase", M_SHARED)
	IF Sx_TableName()#_alias
	  m->__nFreeze:=0	//Freeze
	  IF Sx_TableType()=2
		m->_cPsw:=''
		IF GetName(GET_PSW,"_cPsw",,,,,.T.)
			m->_cPsw:=TRIM(m->_cPsw)
			MainUse(M_SHARED)
		ENDIF
	  ELSE
		Sx_SetPass("")
	  ENDIF
	  IF CpDBF()=1251
		SET("DBF_CHARSET", "cp1251")
	  ELSE
#IFDEF ENGLISH
		Set("DBF_CHARSET", "cp437")
#ELSE
		Set("DBF_CHARSET", "cp866")
#ENDIF
	  ENDIF
	ELSE
		MainUse(M_SHARED)
	ENDIF

	m->_MemoBlSize:=DbInfo( DBI_MEMOBLOCKSIZE )
	dbSetIndex(m->_oldind)
RECOVER USING _error

	IF _error<>21	// Incorrect index
		m->_base:='*'
		MakeRealStruct(m->__CurBase)
		RETURN !EMPTY(m->bAutoExec)
	ENDIF

END
IF Sx_TableName()==_alias
	__DBSetLoc(_iloc)		// for continue LOCATE
	IF FileExist(@__CdxName)
		ordListAdd(m->__CdxName)
		IF EMPTY(_oldind) THEN OrdSetFocus(m->__tagnom)
	ENDIF

ELSE
	m->__CurBase:=m->_base
	aN:=__aPrev[1]
	IF EMPTY(aN)
		m->_NewIndF:=''
		IF !EMPTY(_alias) THEN m->_oldind:=''
		m->__tagNom:=0
		m->__tagName:=''
		m->_tmr:=1
	ELSE
		m->_NewIndF:=aN[2]
		m->_oldind:=aN[3]
		m->__tagNom:=aN[4]
		m->__tagName:=aN[5]
		m->_tmr:=aN[6]
		m->_FltrCond:=aN[7]
	ENDIF
	IF !IsNTX() .AND. FileExist(@__CdxName)
		BEGIN SEQU
*			ordListAdd(m->__CdxName)
			IF EMPTY(_oldind) THEN OrdSetFocus(m->__tagnom)
		RECOVER
			ordListClear()
		END
	ENDIF
ENDIF

IFOp( m->_indexFile=m->_oldInd, dbGoto(Min(m->_tmr,LastRec())), m->_IndexFile:=m->_Oldind )

IF !Empty(m->_fltrcond)
	SET FILTER TO ( m->_fltrcond )
	IF !&_fltrcond THEN go top
ENDIF

DevPos(0,49)
IF !m->_replay
	m->_Fc:=m->__dfc:=LEN(m->__aDbStruct)
	PUBLIC  _Pole,_Works,_FType,_FLen,_FDr,_FRType,;
		_Pictures[_fc],_Widths[_fc],;
		_Dubl,_Dtype,_Dlen,_Ddr,_dRtype
	lMemo:=.F.
	m->_FType	:={}
	m->_FrType	:={}
	m->_FLen	:={}
	m->_FDr 	:={}
	m->_pole	:={}
	m->_Works	:={}
	FOR _i:=1 TO _fc
		aN:=m->__aDbStruct[_i]
		cName:=aN[1]
		AADD(m->_FType,aN[2])
		AADD(m->_FLen,aN[3])
		AADD(m->_FDr,aN[4])
		AADD(m->_FRType,aN[5])
		AADD(m->_Works,Padc(cName,Max( Min(m->_FLen[_i],76), Len(cName) ) ) )
		cN:=cName+','+NTRIM(_i)+')'
		IF m->_Ftype[_i] $ 'MGP'
			lMemo:=.T.
			cName:=PsevdoMemoryName(cName)
		ELSEIF IsVMemo(_i)
			lMemo:=.T.
			cName:='ShowVaried('+cN
		ELSEIF m->_FRtype[_i] $ '28MB' .AND.  (m->_FRtype[_i]<>m->_Ftype[_i])
			cName:='ShowForced('+cN
		ENDIF
		AADD(m->_pole,cName)
	NEXT
	IF lMemo .AND. !lWasMemo
		IF Continue(MEMO_NO_MATCH)
			m->_MainHandle:=FOPEN(m->base, 66)
			FSEEK(m->_MainHandle,0)
			FWRITE(m->_MainHandle,cFirstByte,1)
			FCLOSE(m->_MainHandle)
		ELSE
			m->_base:='*'	//Turn to the choise
		ENDIF
		RETURN .F.
	ENDIF

	m->_dubl:=ACLONE(m->_pole) ; m->_dType:=ACLONE(m->_Ftype)
	m->_dLen:=ACLONE(m->_Flen) ; m->_ddr:=ACLONE(m->_Fdr)
	m->_drType:=ACLONE(m->_FRType)

	IF Sx_TableName()<>_alias .OR. !m->_ResetFields THEN ReadAutoOpen()

	IF 'U' $ Type('_Pole[1]')
		QuitMess(_CORRUPTED)
	ENDIF
*	IF 'U' $ Type('_Pole[1]') THEN QuitMess(_CORRUPTED)
ENDIF
IF Sx_TableName()<>_alias .OR. m->_UndoNew
	m->_UndoBuff:=ARRAY(MIN(m->_UndoSize,4095))
	nUndoCrt:=0
	m->_UndoNew:=.F.
ENDIF
SetColor(_bm)
IF EMPTY(m->bAutoExec)
	DevOut(IF(m->_replay,'SF','  '))
	MainMenu(.T.)

	cDbedit(3,1,__mrow-2,__mcol-1,m->_Pole,'XBrowse',m->_Works,m->_base,m->_Pictures,m->__nFreeze,m->_Widths)
	IF !m->_Replay THEN MakeRealStruct(m->__CurBase)
ELSE
	Center(3,m->_base,,_MenuColor)
	BEGIN SEQU
		EVAL(m->bAutoExec)
	END
	IF !EMPTY(m->bAutoExec) THEN m->_base:=''	//exit
ENDIF

RETU (m->_base=='')
**********
PROC ReadAutoOpen(lClose)
LOCAL _iniFile:=ClearName()+'.AOP'
PRIVATE Fields, Heads, Pictures, Widths, _afExclude, _lIsClose
IF !('.DBF' $ UPPER(m->_base)) THEN RETURN
m->_ResetFields:=.T.
m->_lIsClose:=!EMPTY(lClose)
IF m->_lIsClose .AND. !USED() THEN RETURN
IF FileExist(@_iniFile) THEN RestoreIni(_IniFile)
IF m->_lIsClose THEN RETURN		//Enought!

IF VALTYPE(m->_afExclude)=='C' THEN m->_afExclude:=SplitLine(m->_afExclude)
IF VALTYPE(m->Fields)=='A' .OR. VALTYPE(m->Heads)=='A' .OR.;
   VALTYPE(m->Pictures)=='A' .OR. VALTYPE(m->Widths)=='A' .OR.;
   VALTYPE(m->_afExclude)=='A'
	SetField(.T., _afExclude)
	m->_ResetFields:=.F.
ENDIF
BEGIN SEQU
	IF !EMPTY(m->_IndexFile)
		SET INDEX TO (m->_indexFile)
		_oldind:=m->_IndexFile
	ELSEIF  !EMPTY(m->__tagNom)
		SX_SetTagNo(m->__tagnom)
		m->__TagName:=OrdName()
	ELSEIF  !EMPTY(m->__tagName)
		OrdSetFocus(m->__tagName)
		m->__tagNom:=Sx_TagNo()
	ENDIF
END
**********
PROC SaveAutoOpen
LOCAL aSave,cItem,aVar,i
PRIVATE Fields:=_pole, Heads:={}, Pictures:=m->_Pictures, Widths:=m->_Widths
AEVAL(_Works,{|_1| AADD(m->Heads,ALLTRIM(_1))})
aSave:=	{"Fields","Heads","Pictures","Widths",;
	"_IndexFile","__TagName","__nFreeze"}

aVar:=MemVarList("_H*")

FOR i:=1 TO LEN(aVar)
	cItem:=aVar[i]
	IF TYPE(cItem)=='A' THEN AADD(aSave,cItem)
END

SaveIni(ClearName()+'.AOP',aSave,_MSG_C_INI_HAOP)
**********
FUNC ShowVaried(vFld)
IF VALTYPE(vFld)=='A'
	vFld:=Arr2Str(vFld)
ELSEIF VALTYPE(vFld) $ 'NF'
	vFld:=NTRIM(vFld)
ENDIF
RETURN vFld
*********
PROC History(aHist)
LOCAL _val
IF_NIL aHist IS &(m->_aar)
IF (_val:=Len(aHist))>0
	IF (_val:=HistClip(aHist))<>0
		_val:=aHist[_val]
		&(m->_Vars):=;
			IF(m->_tv,Pad(_val,255),;
			   IF(Type(m->_vars) = 'C',Pad(_val,m->_Flen[m->_ptr]),;
			      IF(Type(m->_vars) = 'N',val(_val),;
				 IF(Type(m->_vars) = 'D',CTOD(_val),;
				    .F.);
				);
			     );
			  )
		m->GetList[1]:UpdateBuffer()
		HideMouse()
	ENDIF
ENDIF
*********
FUNC GetName
#define Dialog() (m->_vars#'_SIMPLELOC' .AND. EMPTY(m->_cGetMask))

PARAM _Whead,_vars,cMask,_cGetMask,lCanSelect,_Return,lPsw,cOrig,cValType,;
	_lNoEmpty
/*header, variable(sould begin with _), file mask, GET kasj, ;
  chouse fields possibility, sign of returns to current directory, password
  sign, original (without preprocessor, passed by reference), type of target
  expression (possible transformation for text type), possibility of empty input
*/
LOCAL	_c:=4,_c1:=__MCol-4,_lh:=Len(m->_Whead)/2+1,aF,;
	cFld
PRIVATE _aGetKeys	//Keys
IF TYPE(m->_aar:=StrTran(m->_vars,'_','_H'))#'A' THEN PUBLIC &_aar:={}

IF !EMPTY(m->_Return) THEN m->_Return:=CurrentDir()

m->_tv:=.F.
IF Type(m->_vars) $ 'NDL'
	_c:=_middlecol-_lh
	_c1:=_middlecol+_lh
ELSEIF Dialog()
	m->_tv:=.t.
ELSEIF !m->_Ftype[m->_ptr] $ 'MV' //.AND. !IsVMemo(m->_ptr)
	_c:=_middlecol - (_c1:=Max(_lh,m->_FLen[m->_ptr]/2+1))
	_c1+=_middlecol
ENDIF

PUSH KEYS COLOR _im

Window(11,Max(_c,4),13,Min(_c1,__mCol-4),Rtrim(m->_Whead))

m->_aGetKeys:={;
		{K_F4, {|| History()}},;
		{K_CTRL_DOWN, {|| History(IF(IsShift(),m->_aGlbHCond,))}},;
		{K_ALT_F4, {|| History(m->_aGlbHCond)}},;
		{K_CTRL_F4, {|| History(m->_aGlbHRes)}},;
		{K_F6, {|| InsFKeys(1)}};
	   }
IF Type('m->_ptr')#'U'
	m->_aGetKeys:=A_Join(m->_aGetKeys,{;
		{K_F2, {|| InsFKeys(3)}},;
		{K_CTRL_F2, {|| InsFKeys(6)}},;
		{K_F3, {|| InsFKeys(4)}},;
		{K_CTRL_F3, {|| InsFKeys(7)}},;
		{K_F5, {|| InsFKeys(2)}},;
		{K_CTRL_F5, {|| InsFKeys(8)}},;
		{K_F10,{|| InsFKeys()}};
		} )
	m->Main_keys:=Val_M_Keys
	m->Ctrl_Keys:=Val_C_Keys
	m->Alt_Keys[4]:=_MSG_GN_AF4
ELSE
	Main_keys[4]:=_MSG_GN_F4
ENDIF
IF !EMPTY(m->cMask)
	AADD(m->_aGetKeys,{K_F9,{||aF:=Filer(m->cMask),__KeyBoard(IF(af[1]=0,'',af[2]))}})
	Main_keys[9]:=_MSG_GN_F9
ENDIF
IF Really(m->lCanFunc)
	m->_aGetKeys:=A_Join(m->_aGetKeys,{;
			  {K_F7, {|| InsFunc()}},;
			  {K_ALT_F, {|| InsFunc()}};
			  })
	Main_keys[7]:=_MSG_GN_F7
ENDIF

IF !EMPTY(m->lCanSelect)
	AADD(m->_aGetKeys,{K_ALT_F2, {|| SelectFlds()}})
	m->Alt_Keys[2]:=_MSG_GN_AF2
ENDIF
BEGIN SEQU
  ForGet(m->lPsw)
  IF !Empty((_c:=ALLTRIM(PAD(&(m->_vars),255))))
	IF Ascan(&(m->_aar),_c)=0 THEN AADD(&(m->_aar),_c)
	IF Ascan(m->_aGlbHCond,_c)=0 THEN AADD(m->_aGlbHCond,_c)
	IF m->_tv .AND. EMPTY(m->lPsw)
		cOrig:=&(m->_vars)

		IF !EMPTY(cValType)
			IF cValType $ 'CM'
				IF (Between(cOrig,'0','@') .OR.(cOrig>'z'))
					cOrig:='"'+TRIM(cOrig)+'"'
				ENDIF
			ENDIF
		ENDIF

		&(m->_vars):=Preproc(cOrig)
	ENDIF
  ENDIF
END
POP KEYS

IF !EMPTY(m->_Return) THEN Cdd(m->_Return)
RETU (Lastkey()#K_ESC) .AND. (!EMPTY(_c) .OR. EMPTY(m->_lNoEmpty))
**********
static PROC ForGet(lPsw)
LOCAL _wide:=__MCOL-11
LOCAL _c:=6,_pict:="@ks"+NTRIM(_wide)
ReadExit(.F.)
IF m->_vars=='_SIMPLELOC'
	IF IsVMemo(m->_ptr)
		m->_SimpleLoc:=PAD(FT_XTOY(m->_simpleLoc,"C"),_wide)
	ELSEIF m->_Ftype[m->_ptr]#'M' //.AND. (_FType[_ptr] # 'V' .OR. _FLen[_ptr]<5)
		_c:=Max(_middlecol-m->_FLen[m->_ptr]/2,5)
	ELSEIF Len(m->_SimpleLoc)< _wide
		m->_SimpleLoc:=Pad(m->_simpleLoc,_wide)
	ENDIF
ELSEIF m->_tv
*	IF TYPE(_vars)<>'C' THEN &_vars:=''	// because strange problems in 
*						// ViewFile
	&(m->_vars)=IF(Upper(&(m->_vars))='.T.',Space(255),Pad(&(m->_vars),255))

        DispOutAt(13, 5, SCROLL_LEFT, _cm)
	DevOut(repl(SCROLL_FILL,_wide))
	DevOut(SCROLL_RIGHT,_cm)
ELSEIF !EMPTY(m->_cGetMask)
	_c:=_middlecol-LEN(Exclude(m->_cGetMask,'@R '))/2
	_pict:=m->_cGetMask
ELSE
	_c:=_middlecol-6
	_pict:=Repl('9',14)
ENDIF
DevPos(12,_c)
ReadModal(m->GetList:={_GET_( &_Vars, m->_Vars, _pict)},,lPsw )
ReadExit(.t.)
**********
PROC InsFKeys(_i)
LOCAL aIns:=MSG_aIns,i,cHdr,cKb:=''
*IF !EMPTY(m->_clipText) THEN AADD(aIns,MSG_ClpVal)
IF_NIL _i IS ForAch(10,MSG_cTitleIns,aIns)
DO CASE
	CASE _i=1
		cKb:=ClearName()
	CASE _i=2 .OR. _i=8
		cKb:=FT_XTOY(m->__content,'C')
		IF _i=8 THEN cKb:='"'+cKb+'"'
	CASE _i=9
		cKb:=AsciiTbl()
	CASE _i=3
		cKb:=RealFldName(m->_c_f)
	CASE _i=4
		cKb:=m->_Works[m->_ptr]
	CASE _i=5
		cKb:=ClipField(8)
	CASE _i>5
		cHdr:=aIns[_i-3]
		aIns:={}
		IF _i=6
			AEVAL(m->__aDbStruct,{|el| AADD(aIns,el[1]) })
		ELSE
			AEVAL(_Works,{|el| AADD(aIns,ALLTRIM(el))})
		ENDIF
		IF (i:=ForAch(5,cHdr,aIns))<>0
			cKb:=aIns[i]
		ENDIF
END
InsString(GetList[1],ALLTRIM(cKb))
**********
FUNC Xbrowse
LOCAL	_i,_var,_R:=Row(),_C:=Col(),;
	_ik:=Upper(OrdKey(0)),nKey
LOCAL	_ce:=IF(Empty(_ik),'',&_ik)	// Current index value
PARA _ptr,_a
nKey:=m->_a
PRIVATE _req,_CurType,_IsField,__Content,__ContentType
m->_req:=1

m->_tmr:=Recno()		&& early declared

m->_CurRType:=m->_FrType[m->_Ptr]
m->_IsField=LEFT(m->_c_f,1)<>'(' .AND.;
	   (Ascan(m->_dubl,AllTrim(m->_c_f))#0) .AND.;
	    m->_CurRType<>'AI'
// returns not 0 with fields such as  _Pole<non-letter>, others: bank*2

IF (m->_CurType:=m->_FType[m->_Ptr])=='M'
	m->_CurType:='C'
	m->_c_f=RealMemoryName(m->_c_f)	// _c_f defined in Mdbedit
	m->_isField:=.t.
ENDIF
m->__Content:=&(m->_C_F)
m->__ContentType:=ValType(m->__Content)

ScrSave()

_var:=chr(nKey)
DO CASE
	CASE nKey=K_ESC .OR. nKey=K_ALT_X

		IF (m->_req:=IF( nKey=K_ALT_X,0,IF(Continue(NEED_FINISH),0,1))) =0
			ReadAutoOpen(.T.)	//Section close
			IF Really(m->_AutoSave) THEN SaveEnv(.T.)
			m->_base=''
		ENDIF

	CASE nKey=K_ENTER
	      IF m->_IsField .AND. !eof() .AND. TryRLock()
		@ 0,0 say PAD(NTRIM(m->_tmr)+'/'+NTRIM(LASTREC()),15)
		GetField(m->_c_f,_r,_C,m->_Pictures[m->_ptr])
		IF !Empty(m->_fltrcond) .AND. !&_fltrcond
			go top  ;__Keyboard() ; m->_req:=2
		ENDIF
	      ELSE
		__KeyBoard()	// for avoid looping
	      ENDIF

	CASE nKey=K_F2
		Prt()

	CASE (nKey=K_F3).OR.((nKey=K_INS).AND.!IsShift())
		NewRec()

	CASE nKey=K_F4
		SelectBase()

	CASE nKey=K_CTRL_O
		ReOpenPrev()

	CASE nKey=K_F5
		SetIndex()

	CASE nKey=K_F6
		 GotoRec(1)

	CASE nKey=K_F7
		LocateFor()

	CASE nKey=K_F8
		PackProg()

	CASE nKey=K_F9
		SeekInd()

	CASE nKey=K_F10 .OR. nKey=K_ALT_V
		MainMenu()

	CASE nKey=K_F11
		SimpleLoc()

	CASE nKey=K_F12
		UserMenu()

	CASE nKey=K_ALT_F1
		Information()

	CASE nKey=K_ALT_F2
		DispStru()

	CASE nKey=K_ALT_F3
		CopyRec()

	CASE (nKey = K_ALT_F4 .OR. nKey=K_ALT_R .OR. nKey=K_CTRL_F4) .AND. m->_IsField
		ReplFor(nKey,IsShift())

	CASE nKey=K_ALT_F5
		Reindex()

	CASE nKey=K_ALT_F6
		IF IsShift()
			TotalFor()
		ELSE
			SumFor()
		ENDIF

	CASE nKey=K_ALT_F7
		ContLocate(IsShift())

	CASE nKey=K_ALT_F8
		Zap()

	CASE nKey=K_ALT_F9
		IndexFor()

	CASE (nKey=K_ALT_F11 .OR. nKey=K_ALT_F)
		SetFilter(!IsShift())

	CASE nKey=K_ALT_F12
		MFiler()

	CASE nKey=K_CTRL_F1 .AND. IsShift()
		SaveAutoOpen()

	CASE nKey=K_CTRL_F1
		PlayMacro()

	CASE nKey=K_CTRL_F2
		SetField()

	CASE nKey=K_CTRL_F3
		IF IsShift() .AND. m->lWasMemo
			CopyRdd()
		ELSE
			CopyTo()
		ENDIF

	CASE nKey=K_CTRL_F5
		SetVar()

	CASE nKey=K_CTRL_F6
		CountFor()

	CASE nKey=K_CTRL_F7 .AND. IsShift()
		LocateFor(.T.)

	CASE nKey=K_CTRL_F7
		RestFor(RECALLING,{||dbRecall()}, '.AND.DELE()' )

	CASE nKey=K_CTRL_F8 .AND. IsShift()
		RestFor(INVERTING,{|| IF(DELE(),dbRecall(),dbDelete())}, '')

	CASE nKey=K_CTRL_F8
		RestFor(DELETING,{||dbDelete()}, '.AND.!DELE()' )

	CASE nKey=K_CTRL_F9
		AppeFrom()

	CASE nKey=K_CTRL_F10
		ChangeDir()

	CASE nKey=K_CTRL_F11 .AND. IsShift()
		SimpleLoc(.T.)

	CASE nKey=K_CTRL_F11 .OR. nKey=K_ALT_S
		SortFor()

	CASE nKey=K_CTRL_F12
		RestIni()

	CASE nKey=K_SH_F1
		SaveEnv()

	CASE nKey=K_SH_F2
		ModiStru()
		IF USED() THEN Mgoto(m->_tmr)

	CASE nKey=K_SH_F3
		InsRec()

	CASE nKey=K_SH_F4
		MakeEmpty(m->_C_F)

	CASE nKey=K_SH_F5
		RestEnv()

	CASE nKey=K_SH_F6 .OR. nKey=K_ALT_G .OR. _var = '?'
		CalcExpr()

	CASE nKey=K_SH_F7
		SetTag(0)

	CASE nKey=K_SH_F8
		SetTag(1)

	CASE nKey=K_SH_F9
		AddTag()

	CASE nKey=K_SH_F10
		DelTag(0)

	CASE nKey=K_SH_F11
		SetCdx()

	CASE nKey=K_SH_F12 .OR. nKey=K_ALT_T
		SetTag()

	CASE nKey=K_CTRL_T .OR. nKey=K_DEL
		IF TryRLock()
			IF DELETED()
				RECALL
			ELSE
				DELETE
			ENDIF
			Undo({m->_tmr, DELETED()})
		ENDIF

	CASE nKey==_AltUp
		CopyField(IF(ISShift(),8,1)) // 8,9- exchange

	CASE nKey==_AltDown
		CopyField(IF(ISShift(),9,2))

	CASE nKey=_AltLeft
		CopyField(3)

	CASE nKey=_AltRight
		CopyField(4)

#IFNDEF ENGLISH
	CASE nKey=K_ALT_A		&&For ODB
		TakeKr()
#ENDIF
	CASE nKey=K_ALT_I
		GlobFind(m->_lGsExp)

	CASE nKey=282		//	K_ALT_[
		SeekWild(IsShift())

	CASE nKey=K_ALT_B
		NewColor(IsShift())

	CASE nKey=K_ALT_M
		Extremum()

	CASE nKey=K_CTRL_L
		FindLong()

	CASE nKey=K_CTRL_N
		NewBase()

	CASE nKey=K_CTRL_Y
		ClearRec()

	CASE nKey=K_CTRL_P
		PrintEdit()

	CASE __ContentType = 'C' .AND. m->_IsField .AND. ;
	     (_i:=ASCAN({K_ALT_U,K_ALT_L,K_ALT_K,K_ALT_Q,K_ALT_Y,K_ALT_P,K_ALT_J},nKey))<>0
		MyRepl(m->_c_f,EVAL({;
				{||Upper(m->__content)},;
				{||Lower(m->__content)},;
				{||Capitalz(m->__content)},;
				{||USA2Nation(m->__content)},;
				{||Nation2Usa(m->__content)},;
				{||Proper(m->__content)},;
				{||PADJ(m->__content)};
				}[_i]))

	CASE nKey=K_ALT_E
		FullEdit() ; m->_req:=2

	CASE nKey=377	// ALT_2
		FindDouble()

	CASE nKey=299	//Alt_>
		Tb2Html()

	CASE nKey=K_ALT_W
		WideEdit()

	CASE nKey=K_ALT_Z
		FreezeField()

	CASE nKey=K_CTRL_ENTER
		ClipField(2)

	CASE nKey=K_CTRL_GPLUS
		ClipField(1)

	CASE nKey=K_CTRL_GMINUS .OR. nkey=K_ALT_GENTER
		ClipField(3)

	CASE nKey=K_CTRL_INS
		CopyField(7)

	CASE nKey=K_CTRL_U .OR. nKey=K_ALT_BS
		Undo()

	CASE nKey=K_INS .AND. IsShift()
		CopyField(6)

	CASE nKey=K_ALT_GPLUS
		ClipField(4)

	CASE nKey=K_ALT_GMINUS
		ClipField(5)

	CASE nKey=K_ALT_GMULT
		ClipField(6)

	CASE nKey=K_ALT_GDIV
		ClipField(7)

	CASE nKey=K_CTRL_UP
		Chg_Recs(-1)

	CASE nKey=K_CTRL_DOWN
		Chg_Recs(1)

	CASE nKey=K_CTRL_K .OR. nKey=K_CTRL_Q
		SaveRestStack(nKey)

	CASE ((Between(nKey,48,57) .AND. m->_CurType # 'L').OR.;
	     (Between(nKey,65,255) .AND. m->_CurType $ 'CMV'))   .AND. (LastRec()<>0)
		KeyBoard(_ENTER+_var)

	CASE m->_CurType == 'L' .AND. _var $ L_YES_SET+L_NO_SET+' ' .AND. (LastRec()<>0)
		KeyBoard(_ENTER+_var+_CTRLEND)

ENDCASE
IF Used()
	UNLOCK
ENDIF

SetColor(_Bm)
IF m->_req<>0
  _var:=IndexKey(0)
  IF !Empty(m->_indexFile) .AND. m->_req=1 .AND. !EMPTY(_var).AND.;
	(ValType(&_var)<>'U').AND.;
	(ValType(_ce)<>ValType(&(_var)) .OR. _ce#&(OrdKey(0)));
		THEN m->_req:=2

  IF _req=1 THEN ScrRest()
ENDIF

RETU m->_req
**********
FUNC TakeScope(_txt)
static _Scope,cLastCall:=''
IF_NIL _txt IS FUNC_FIND
DBSkip(-1)
IF BOF() THEN RETU .T.
DBSkip()

IF (ProcName(1)<>cLastCall) .OR. (_scope==0) THEN _scope:=2
cLastCall:=ProcName(1)

IF (_Scope:=MENU_RECS(_txt))==1 ;
	THEN go top

RETU _Scope#0
**********
static FUNC GetField(_c_f,_r,_c, _pict, lSpecial)
LOCAL	_i,_a,_Em := _MSG_EMODE,cType:=m->_Ftype[m->_ptr],_xFld
STATIC _EnterMode:=1
PRIVATE _aGetKeys
HideMouse()
BEGIN SEQU
  IF  (Select()=1) .AND. (m->_ptr<=_Fc) .AND. (cType $ 'MGP')
	DoMemo(m->_C_F)
  ELSEIF m->_CurRType=='X' .AND. m->__Content==NIL
	BREAK
  ELSEIF (_a:=RealFldName(_c_f)) # _c_f
	IF m->_CurRType $ '28M'
		_xFld:=&_a	//Real value

		DO CASE
			CASE m->_CurRType $ '28'
				IF (_xFld:=GetField('__Content',_r,_c,;
						PictForced(m->_CurRType,m->_ptr),;
						.T.))<> NIL THEN;
					MyRepl(_a,_xFld)

			OTHER //CASE cType $ 'MGP'
				_i:=DoMemo(_a,m->__mcol-6,.T.,,.T.,MemoSrc(_xFld) )
				 IF _i<>NIL THEN MyRepl(_a, _i)
				BREAK
		ENDCASE
	ELSEIF (VALTYPE(_a)=='C' .AND. TYPE(_a)=='A') .OR. m->_Flen[m->_ptr]>5
		DoMemo(_a)
	ELSE
		GetField(_a,_r,_c)
	ENDIF
  ELSE
	PUSH KEYS Get_M_Keys COLOR _im
	@ 0,37 say _Em[_ENTERMode]
	m->_aGetKeys:={;
		     {K_F4,{|| Out( 0, 37, _Em[_ENTERMode:=(_ENTERMode % 4)+1]);
			}}}
	Set FUNC 21 to m->_macro
	IF Select()=1 THEN AADD(m->_aGetKeys,;
				{K_F3,{||__KeyBoard(_ESC+_CTRLHOME+_EMP+_ENTER),dbAppend()}})

	SetPos( _r, _c )
	IF EMPTY(_pict) THEN _pict:="@S"+NTRIM(__mcol-_C)
	IF SELECT()=1 .AND. !EMPTY(m->_widths[m->_ptr]);
		THEN _pict:="@S"+NTRIM(m->_widths[m->_ptr])
	_xFld:=&_C_F
	ReadModal({ _GET_( _xFld, "_xFld", _pict) })
	IF UPDATED()
		IF EMPTY(lSpecial)
			MyRepl(_C_F,_xFld)
		ENDIF
	ELSE
		_xFld:=NIL
	ENDIF
	POP KEYS
  ENDIF
  IF (_a:=chr(LastKey())) = _ENTER
	DO CASE
		CASE _ENTERMode=2
			_i:=_DOWN
		CASE _ENTERMode=3 .AND. m->_ptr=_fc
			_i:=CHR(29)+CHR(24)
		CASE _ENTERMode=4
			_a:=CHR(23)
		OTHER
			_i:=_RIGHT
	ENDCASE
  ELSE
	_i:=_a
  ENDIF
  IF ! _a $ CHR(27)+CHR(23)+CHR(247) .AND. EMPTY(m->_MemoEditor) THEN	KEYB _i+_EMP+_ENTER

END
ShowMouse()
RETURN _xFld
**********
PROC SetField(lAuto,aExclude)
FIELD NAME,FIELD,F_PICT,NLEN
LOCAL	nFld,_i,_j,cFld,_num:=0,_tmp,cPict,nScroll,;
	_tmpBase:='bdbf_tmp_file.dbf',cfT

STATIC _cbase:=''

#define TrueLen() IF((cfT:=m->_Ftype[_i])=='N',16,;
		  IF(cfT=='D',8,;
		  IF(cfT=='C',a->(Len(&cFld)),;
		  0)))
IF m->_replay
	m->_ResetFields:=.T.
	m->_replay:=.F.
	m->_req:=0
	MakeRealStruct()
	RETURN
ENDIF

PUSH KEYS Setf_M_Keys

IF  m->_base#_cbase
	FERASE(_SetFBase)
	_cbase:=m->_base
ENDIF

DBCreate(_TmpBase,{{'Field','C',60,0},;
	  {'Name','C',80,0},;
	  {'F_PICT','C',30,0},;
	  {'nLEN','N',3,0};
	   },;
	 /*driver*/)

/*
AEVAL(m->__aDbStruct,{|el,_i|;
	DbAppend(),;
	_FIELD->Field:=el[1],;
	_FIELD->Name:=AllTrim(m->_Works[_i]),;
	_FIELD->F_Pict:=IF(EMPTY(m->_Pictures[_i]),'',m->_Pictures[_i]),;
	_FIELD->nLen:=IF(EMPTY(m->_Widths[_i]),0,m->_Widths[_i]);
      })
*/
SELECT 0
USE (_TmpBase) ALIAS _tmpb EXCL
FOR _i:=1 TO LEN(m->__aDbStruct)
	DbAppend()
	_FIELD->Field:=m->__aDbStruct[_i,1]
	_FIELD->Name:=AllTrim(m->_Works[_i])
	_FIELD->F_Pict:=IF(EMPTY(m->_Pictures[_i]),'',m->_Pictures[_i])
	_FIELD->nLen:=IF(EMPTY(m->_Widths[_i]),0,m->_Widths[_i])
NEXT
IF !EMPTY(lAuto)
	IF VALTYPE(m->Fields)=='A'
		FOR _i:=1 TO LEN(m->Fields)
			IF _i>LASTREC() THEN DBAPPEND()
			GO _i
			cFld:=m->Fields[_i]
			IF '"memo","MEMO"' $ cFld THEN cFld:=RealMemoryName(cFld)
			IF VALTYPE(cFld)=='C'
				_FIELD->Field:=cFld
				IF (nFld:=ASCAN(m->__aDBSTRUCT, {|_1|_1[1]==UPPER(cFld)}))<>0
					_FIELD->Name:=ALLTRIM(m->_Works[nFld])
				ENDIF
			ENDIF
		NEXT
		IF RECNO()<LASTREC()
			SKIP
			DBEval ({|| dbDelete()}, , , , , .T.)
		ENDIF
	ENDIF
	IF VALTYPE(m->Heads)=='A'
		AEVAL(m->Heads,;
			 {|_1,i| IF(VALTYPE(_1)=='C' .AND. i<=LASTREC(),;
			 (DbGoto(i),FIELD->Name:=ALLTRIM(_1)),) })
	ENDIF
	IF VALTYPE(m->Pictures)=='A'
		AEVAL(m->Pictures,;
			 {|_1,i| IF(VALTYPE(_1)=='C' .AND. i<=LASTREC(),;
			 (DbGoto(i),FIELD->F_PICT:=ALLTRIM(_1)),) })
	ENDIF
	IF VALTYPE(m->Widths)=='A'
		AEVAL(m->Widths,;
			 {|_1,i| IF(VALTYPE(_1)=='N' .AND. i<=LASTREC(),;
			 (DbGoto(i),FIELD->nLen:=_1),) })
	ENDIF

	IF !EMPTY(aExclude)
		FOR _i:=1 TO LEN(aExclude)
			IF __DbLocate({||ExactEqual(FIELD->Field,aExclude[_i])})
				DELETE
			ENDIF
		NEXT
	ENDIF
ENDIF

GO TOP

IF EMPTY(lAuto)
	cPict:='@S'+NTRIM(nScroll:=__mcol/2-14)
	m->_Pole:={'Field','Name','F_PICT','nLen'}
	cDbedit(9,4,__mrow-7,__mcol-3,_Pole,;
		'FldBrow',A_SETF_BROW,SET_FIELDS,{cPict,cPict,'@S11'})
ENDIF

IF LastKey()==K_F10 .OR. !EMPTY(lAuto)
*   __DbCopy(_SetFBase)
   COPY TO (_SetFBase)
   GO TOP
   _i:=1

   m->_Ftype:={}
   m->_FrType:={}
   m->_Flen:={}
   m->_Fdr:={}
   m->_Works:={}
   m->_Pole:={}
   m->_Pictures:={}
   m->_Widths:={}
   SCAN
	IF !DELETED() .AND. !EMPTY(Field)
		cFld:=Trim(Field)
		sele 1
		BEGIN SEQUENCE
			IF (nFld:=ASCAN(m->__aDBSTRUCT, {|_1|_1[1]==UPPER(cFld)}))==0
				_j:=ValType(&cFld)	&&Is have sence?
			ENDIF
			SELE _tmpb
			AADD(m->_pole,IF(nFld=0,cFld,m->_dubl[nFld]))
			AADD(m->_Ftype,IF(nFld=0,_j,m->_dtype[nFld]))
			AADD(m->_FRType,IF(nFld=0,_j,m->_drType[nFld]))
			AADD(m->_FLen,IF(nFld=0,TrueLen(),m->_dlen[nFld]))
			AADD(m->_FDr,IF(nFld=0,0,m->_Ddr[nFld]))
			AADD(m->_Works,Padc(Rtrim(Name),Max(Min(m->_FLen[_i],76),Len(Rtrim(Name)))))
			AADD(m->_Pictures,IF(EMPTY(F_PICT),,TRIM(F_PICT)))
			AADD(m->_Widths,IF(EMPTY(nLen),,nLen))

			_i++
		END
		SELE _tmpb
	ENDIF
   ENDSCAN

  IF  Len(m->_pole)#0
	m->_replay:=.T.
	_Fc=_i-1
  ENDIF

ENDIF
POP KEYS .T.
m->_req:=0

USE
SELE 1
Ferase(_tmpBase)
**********
FUNC FldBrow(_ptr,nKey)
LOCAL i,_req:=2
m->_c_f:=Field(_ptr)	//Used in CopyField
m->__Content:=&_c_F
DO CASE
	CASE nKey=K_ENTER
		GetField(Field(_ptr),row(),Col(),;
			m->_bdbfbrow:GetColumn(_ptr):Picture)

	CASE nKey=K_ESC .OR. nKey=K_ALT_X .OR. nKey=K_F10
		_req:=0

	CASE nKey=K_CTRL_Y .OR. nKey=K_DEL
		IfOp( DELETED(),RECALL,DELETE)

	CASE (nKey=K_F3).OR.((nKey=K_INS).AND.!IsShift())
		DbAppend()

	CASE nKey=K_F5 .AND. FileExist(_SetFBase)	//restore previous
		ZAP
		APPE FROM (_SetFBase)
		GO top

	CASE nKey=K_F7 .OR. nkey=K_F8
		i:=RECNO()
		DBEVAL(IF(nkey=K_F7,{||DBRECALL()},{||DBDELETE()}),,,,,.T.)
		GO i

	CASE nKey=K_CTRL_UP
		Chg_Recs(-1)

	CASE nKey=K_CTRL_DOWN
		Chg_Recs(1)

	CASE nKey==_AltUp
		CopyField(IF(ISShift(),8,1)) // 8,9- exchange

	CASE nKey==_AltDown
		CopyField(IF(ISShift(),9,2))

	CASE (Between(nKey,48,57) .AND. _ptr>1) .OR.;
	     (Between(nKey,65,255))
		KeyBoard(_ENTER+CHR(nKey))
		_req:=1

	OTHER
		_req:=1
ENDCASE
RETU _req
**********
FUNC TrueCond(_cnd)
LOCAL _i:=.f.
IF_EMPTY _cnd IS '.T.'

BEGIN SEQUENCE
	_i:= (VALTYPE((&_cnd))=='L')
END
IF !_i THEN NFIND(_STAT_ERTIP)

RETU _i
**********
PROC FullEdit
LOCAL	_i,_R,_c:=2,_page:=0,GetList:={},_ptr,_pict,;
	_C_F,__mrow_2:=__mrow-5,_pages:=INT(LEN(m->_pole)/(__mrow-6)),;
	aGet,cType,nlGet,cRName

IF LEN(m->_pole)/(__mrow-6) > _pages THEN _pages++

PUSH KEYS COLOR _im
Panel(1,0,__mrow,__mcol,{FULL_ED},{_im,_HdColor,_im})
BEGIN SEQUENCE	//For avoid breaks and for fixing Header
DO WHILE .t.
  _r:=4
  IF !Empty(m->_fltrcond) .AND. !&_fltrcond THEN	go top
  @ __mrow-1,65 SAY PLIST+NTRIM(_page+1)+'/'+NTRIM(_pages);
		COLOR _HdColor
  IF !TryRLock()
	EXIT
  ENDIF
  aGet:=ARRAY(_Fc)
  nlGet:=0
  FOR _i=1 to Min(_Fc-_page*(__mrow_2),__mrow_2)
	_ptr:=_page*(__mrow_2)+_i  ;  _c_f:=m->_pole[_ptr]
	nlGet++
	DispOutAt(_r++,_C, Str(_ptr,3)+'.'+Pad(Alltrim(m->_Works[_ptr]),11))
	cType:=m->_FRtype[_ptr]
	_pict:="@S"+NTRIM(__mcol-18)
	crName:=RealFldName(_c_f)
	IF m->_Ftype[_ptr] $ 'MGP'
		crName:=RealMemoryName(_c_f)
		AAdd( GetList, _GET_( &_c_F, crName, _pict ):Display() )
		GetList[nlGet,10]:=crName
	ELSEIF  Ascan(m->_dubl,_c_f)=0 .OR. cType $ 'MGP'
		DevOut(&(_C_F),_rev)
		nlGet--
	ELSEIF cType $ '2'
		aGet[_i]:={crName,&_c_F,cType}
		*AAdd( GetList, _GET_( &_c_F, "aGet[_i,2]", PictForced(cType,_ptr) ) :Display())
		GET_HERE aGet[_i,2] PICT PictForced(cType,_ptr)
	ELSE
		*_c_f:=RealFldName(_c_f)
		AAdd( GetList, _GET_( &crName, crName, _pict ) :Display())
		*GET_HERE &_C_F PICT _pict
	ENDIF
	IF DELETED() THEN GetList[nlGet]:ColorDisp(m->HiddenColor)
	*GetList[nlGet,3]:=_pict
  NEXT
  READMODAL(GetList) ; GetList:={}
  *AEVAL(aGet,{|_1| IF(EMPTY(_1), , WriteForced(_1[1],_1[2],_1[3])) })

  AEVAL(aGet,{|_1| IF(EMPTY(_1), ,_FIELD->&(_1[1]):=xToForced(_1[2],_1[3])) })

  DO CASE
	CASE ((_i:=LastKey()) = K_ENTER .OR. _i = K_PGDN)
		Scroll(4,2,__mrow-2,__mcol-2)
		IF _ptr>=_fc
			UNLOCK
			DBSkip() ; _page=0
		ELSE
			_page++
		ENDIF
	CASE _i = K_PGUP .AND. !Bof()
		Scroll(4,2,__mrow-2,__mcol-2)
		IF _page=0
			UNLOCK
			DBSkip(-1)
		ELSE
			_page--
		ENDIF

	CASE (_i = K_ESC .OR. _i = K_CTRL_W)
		EXIT
  ENDCASE
  IF EOF() THEN	go bott
  @ 0,0 say PAD(NTRIM(RECNO())+'/'+NTRIM(LASTREC()),15) color _bm
ENDDO
END SEQU
POP KEYS
**********
PROC MyRepl(dest,source,cType,lFast)
LOCAL _old,nRec:=RECNO()
IF EMPTY(lFast)
	IF !TryRLock() THEN RETU
	dest:=RealFldName(dest)
	m->_req:=2	//If filter was broken
	IF_NIL cType IS IF(Select()==1,m->_CurRType,VALTYPE(source))
ENDIF

IF cType=='AI' THEN RETU	//AutoInc

_old:=&dest

*IF cType $ 'YBT2'
IF cType $ '2'
	source:=xToForced(source,cType)	//in foxpro
ELSEIF cType $ 'B' .AND. VALTYPE(source)=='N'
	cType:='N'
ELSEIF cType $ 'M' .AND. m->_lForced
	source:= MemoPut(_old,source)
ELSEIF EMPTY(lFast) .AND. cType<>VALTYPE(source)
	source:=FT_XTOY(source,cType)
ENDIF

BEGIN SEQU
	IF cType $ 'VX' .OR. _old<>source
	  _FIELD->&dest:=source
	  IF SELECT()==1
		Undo({nRec,dest,_old})
	  ENDIF
	ENDIF
RECOVER
	GO nRec
	IF empty(&dest) THEN REPL &dest with _old
END
**********
PROC Undo(aChg)
LOCAL nPoint,xVal

IF m->_UndoSize<=0 THEN RETURN

IF !EMPTY(aChg) THEN nUndoCrt++
nPoint:=nUndoCrt % m->_UndoSize
IF nPoint=0 THEN nPoint:=m->_UndoSize
IF !EMPTY(aChg)
	m->_UndoBuff[nPoint]:=aChg
	RETURN
ENDIF

IF nUndoCrt>0
	aChg:=m->_UndoBuff[nPoint]
	GOTO aChg[1]
	IF TryRLock()
		IF LEN(aChg)==2
			IF aChg[2]
				RECALL
			ELSE
				DELETE
			ENDIF
		ELSE
			xVal:=aChg[3]
			IF_NIL xVal IS ''
			BEGIN SEQU
				_FIELD->&(aChg[2]) := xVal
			END
		ENDIF
		nUndoCrt--
	ENDIF
	m->_req:=2
ENDIF
**********
FUNC RestoreIni
LOCAL	_h,_s,_s1,_nTotRead:=0,_init,_var,_i,;
	aLocals:={},___ret, aIf:=ARRAY(10), aIfWas:=ARRAY(10), nIf:=1,;
	aWhile:=ARRAY(10),nWhile:=0,;
	lSkipIf, lSkipWhile, lNoSkipPrev, cKeyWord, cArgs,;
	aLTable, lLTable:=.F.
PARAM _Ini,_1,_2,_3,_4,_5

IF_NIL m->_Ini IS m->_IniFile
PRIVATE lNoReopen, _nLines:=0, cCodePage
m->lNoReopen:=.F.
#IFDEF ENGLISH
	cCodePage:='cp437'
#ELSE
	cCodePage:='cp866'
#ENDIF

m->_NeedRestIni=.F.

aLTable:=ACLONE(m->_aCommand)

IF !FileOnPath(@_Ini) .OR. (_h:=FOPEN(m->_Ini,64))<=0
	NFIND(PRV_NOMEMO + m->_Ini)
ELSE
//1-st IF reserved for closing section in AOP.
  aIf[1]:=!Really(_lIsClose)
  aIfWas[1]:=aIf[1]
//aIfWas needed for ELSEIF/CASE
  _s:=''
   DO While FreadLn(_h, @_s1, 512)
	_nTotRead:=FSEEK(_h, 0, 1)
	m->_nLines++
	_s1:=StrTran(ALLTRIM(_s1), chr(9),' ')
	_s += _s1
	IF SUBSTR(_s1,-1)==';'		// carriage
		_s:=Strip(_s,1)
		LOOP
	ENDIF
	Parce((_s:=ALLTRIM(_s)),'//',@_s)
	IF EMPTY(_s) .OR. First(_s) $ '*;/'
		_s:=''
		LOOP
	ENDIF
	_s:=Translate_Charset(cCodePage, host_charset(), _s)
	*Parce(_s,'/*',@_s)

	_s1:=SX_SlimFast(SUBST(_s,1,512))
//SUBST because SlimFast broke _s

	IF LEFT(_s1,7)=='DO WHIL' THEN _s:=LTRIM(SUBSTR(_s,4))
	Parce(_s,' ', @cKeyWord, @cArgs)
	cKeyWord:=UPPER(cKeyWord)
	cArgs:=LTRIM(cArgs)
//Variant with the primary finding in full command table worse
// by speed and by size

    BEGIN SEQUENCE
	lSkipIf:=!aIf[nIf]
	lSkipWhile:=(nWhile>0 .AND. !aWhile[nWhile,1])
	lNoSkipPrev:=!lSkipWhile .AND. nIf>1 .AND. aIf[nIf-1]

	IF (LEFT(_s1,3) $ '#IF ' .OR. _s1=='DO CASE');
	   .AND. !lSkipWhile	//Not lured to #INCLUDE

		IF lSkipIf .OR. cKeyWord=='DO'
//By previous IF or initialization of DO CASE
			aIf[++nIf]:=.F.
		ELSE
			IF SUBSTR(cKeyWord,4,3) $ 'NDEF'
				IF TYPE(cArgs)<>'L'
					cArgs:='.F.'
				ENDIF
			ENDIF
			IF !EMPTY(cArgs)
				aIf[++nIf]:=Evaluate(cArgs)
				IF 'N' $ cKeyWord	//#IFNDEF
					aIf[nIf]:=!aIf[nIf]
				ENDIF
			ENDIF
		ENDIF
		aIfWas[nIf]:=aIf[nIf]
	ELSEIF IsOperator(cKeyWord,'ELSE,OTHERWISE') .AND. lNoSkipPrev
//You can make a separate IF, will not enter to error when wrong
// expresstion. Now says: no variable.
		aIf[nIf]:=!aIfWas[nIf]
	ELSEIF cKeyWord=='ELSE'	//In order not to be confused with ELSEIF
	ELSEIF IsOperator(cKeyWord,'ELSEIF,CASE')
		IF lNoSkipPrev .AND. lSkipIf .AND. !aIfWas[nIf]
			aIf[nIf]:=aIfWas[nIf]:=Evaluate(cArgs)
		ELSE
			aIf[nIf]:=.F.
		ENDIF
	ELSEIF IsOperator(cKeyWord,'ENDIF,ENDCASE');
	 .AND. !lSkipWhile .AND. nIf>1
		aIf[nIf--]:=.F.
	ELSEIF cKeyWord=='[CLOSE]'	//AOP section
		aIf[1]:=!aIf[1]
	ELSEIF lSkipIf
//ignore
	ELSEIF IsOperator(cKeyWord,'WHILE') .OR. cKeyWord=='FOR'
		IF cKeyWord=='FOR'
			Parce(SUBSTR(_s1,5),'=',@_var,@_Init)
			StripRight(@_var,':')	//:=
			Parce(_Init,' TO ',@_Init,@cArgs)
			&_var:=&_Init
			Parce(cArgs,' STEP ',@cArgs,@_Init)
			_Init:=IF(EMPTY(_Init),1,&_Init)
			cArgs:=_var+ IF(_Init>0,'<=','>=')+ cArgs
		ENDIF
		aWhile[++nWhile]:={Evaluate(cArgs), _nTotRead, cArgs, m->_nLines,_Init}

	ELSEIF IsOperator(cKeyWord,'EXIT') .AND. (nWhile>0)
			aWhile[nWhile,1]:=.F.
			aWhile[nWhile,3]:='.F.'
	ELSEIF IsOperator(cKeyWord,'ENDWHILE,ENDDO,ENDFOR,NEXT,LOOP') .AND.;
		(nWhile>0)

		cArgs:=aWhile[nWhile,3]
		IF IsOperator(cKeyWord,'ENDFOR,NEXT')
			Parce(cArgs, '=',@_var)	//<=,>=
			_var:= STRIP(_var, 1)
			&_var += aWhile[nWhile,5]
		ENDIF
		IF Evaluate(cArgs)
			FSEEK(_h, _nTotRead:=aWhile[nWhile,2])
			m->_nLines:=aWhile[nWhile,4]
		ELSEIF !IsOperator(cKeyWord,'LOOP')
			aWhile[nWhile--]:=.F.
		ENDIF

	ELSEIF lSkipWhile
//ignore
	ELSEIF cKeyWord=='#INCLUDE'
		IF LEFT(cArgs,1) + SUBSTR(cArgs,-1) $ "''"+ '""'
			cArgs:=ALLTRIM(SUBSTR(cArgs,2,LEN(cArgs)-2))
		ENDIF
		_i:=m->_req
		RestoreIni(cArgs)
		m->_req:=_i
	ELSEIF cKeyWord=='#EXCLUDE'		//Fields
		Parce(cArgs,' ',@_afExclude)
	ELSEIF cKeyWord=='#DEFINE'
		Parce(cArgs,' ',@_var,@_Init)//<>0
		_Init=LTRIM(_Init)
		InitVar(_var, IF(EMPTY(_Init),.T.,&_Init)) //f.e. #define _SET_CH
	ELSEIF cKeyWord=='#UNDEF'
		IF LEN(cArgs)<>0 THEN __MxRelease(cArgs)
	ELSEIF cKeyWord=='#XCOMMAND'
		IF Parce(cArgs,'=>',@_var,@_Init)<>0
			*_Init=LTRIM(_Init)
			_Init=TRIM(_Init)
			_var:=TRIM(_var)
			IF (_i:=AMScan(m->_aCommand,1,_var))==0
				AADD(m->_aCommand,{_Var,_Init})
			ELSE
				m->_aCommand[_i,2]:=_Init
			ENDIF
		ENDIF
	ELSEIF LEFT(cKeyWord,6)=='#MACRO'
		_i:=0
		IF SUBSTR(cKeyWord,7,4)=='_IN_'
			_i:=AT(SUBSTR(cKeyWord,11,4), 'BROWDIALFIELMEMO')
			_i:=ROUND(_i/4,0)
		ENDIF
		IF Parce(cArgs,'=>',@_var,@_Init)<>0
			AssignKey(TRIM(_var), LTRIM(_Init), _i)
		ENDIF
	ELSEIF cKeyWord=='#LOCALTABLE'
		lLTable:=.T.
	ELSEIF IsOperator(cKeyWord,'LOCAL,PRIVATE,PUBLIC')
		cArgs:=SplitLine(cArgs)
		FOR _i:=1 TO LEN(cArgs)
			IF Parce(cArgs[_i],':=',@_var,@_Init)<>0
				_var:=ALLTRIM(_var)
				_Init:=LTRIM(_Init)
				cArgs[_i]:=_var
				InitVar(_var, &_Init)
			ENDIF
		NEXT
		IF !('PUB' $ cKeyWord) THEN aLocals:=A_Join(aLocals,cArgs)
	ELSEIF IsOperator(cKeyWord,'PARAMETERS')
		cArgs:=SplitLine(cArgs)
		FOR _i:=1 TO LEN(cArgs)
			&(cArgs[_i]):=&('_'+NTRIM(_i))
		NEXT
	ELSEIF cKeyWord=='#BREAK'
		IF EMPTY(cArgs) .OR. Evaluate(cArgs)
			BREAK(.T.)
		ENDIF
	ELSEIF IsOperator(cKeyWord,'RETURN')
		___Ret:=IF( EMPTY(cArgs), NIL, Evaluate(cArgs))
	ELSEIF IsOperator(cKeyWord,'MEMVAR,FIELD,EXTERNAL')
		//ignore
	ELSEIF '=' $ _s
		Parce(_s,'=',@_var,@_Init)
		IF EMPTY(_Var)		// just function without variable
			Aktion(Compile(Preproc(_Init)))
		ELSE
			StripRight(@_var,':')	//:=

			InitVar(_var,&_Init)
			*&_var := EVAL(Preproc(_Init))
			//Not allowed while assigning blocks - they immediately started
		ENDIF
	ELSE
		Aktion(Compile(Preproc(_s)))
	ENDIF
    RECOVER USING _i
	IF VALTYPE(_i)=="L" .AND. _i THEN EXIT
    END
	_s:=''
  ENDDO

ENDIF
Fclose(_h)
AEVAL(aLocals,{|_1| __MxRelease(_1)})
IF lLTable THEN m->_aCommand:=ACLONE(aLTable)

IF !m->lNoReOpen	// May be redefined in ini
	m->_req:=0	// reread
ENDIF
RETURN ___ret
**********
STATIC FUNC IsOperator(cKeyWord, aMatch)
aMatch:=SplitLine(aMatch)

IF LEFT(cKeyWord,1)='#' THEN cKeyWord:=SUBSTR(cKeyWord,2)

RETURN (LEN(cKeyWord)>=4) .AND. ;
	ASCAN(aMatch,{|_1| LEFT(_1,LEN(cKeyWord))==cKeyWord})<>0
**********
STATIC PROC AssignKey(xKey,xVar,nRegion)
LOCAL i,aKey
xKey:=&xKey
xVar:=&xVar
aKey:={xKey,xVar,nRegion}
IF (i:=ASCAN(m->_MacroTable, {|x| x[1]==xKey .AND. x[3]==nRegion}))==0
	AADD(m->_MacroTable,aKey)
ELSE
	m->_MacroTable[i]:=aKey
ENDIF
**********
FUNC CheckDbf(cName,lNeedMemo,cFirstByte)
LOCAL _handle,i,cRdd,_memo,_mFile,_cdx,lExit,NeedForced
// Parameters - by reference
cFirstByte:=' '
m->_MainMemoFile:=''

IF (_handle:=FOPEN(cName,66))<0
	NFIND(cName+CORRUPT_OR_LOCKED)
ELSE
  WHILE .T.
	m->_aDbStruct:=RealStruct(_handle,@NeedForced)	//Structure variable (global)
	IF EMPTY(m->_aDbStruct)
		NFIND(cName+UNSUPPORT)
		lExit:=.t.
		EXIT
	ENDIF
	cFirstByte:=m->_aCommon[3]
#ifdef __CLIP__
	IF !(cFirstByte $ chr(3)+chr(245)+chr(131)+chr(48)+chr(49)) .OR. !EMPTY(NeedForced)
#else
	IF !(cFirstByte $ 'õƒ†‹åæö') .OR. !EMPTY(NeedForced) // utf-8: 'Ñ—Ð“Ð–Ð›Ñ…Ñ†ÐŽ'
#endif
	  IF !EMPTY(NeedForced)
		NeedForced:=CHECK_DBF_FORCED[NeedForced]
	  ENDIF

	  IF EMPTY(m->_lForced) .AND. Continue(CHECK_DBF_TRY)
		m->_lForced:=.T.
	  ELSE
		lExit:=.T.
		EXIT
	  ENDIF
	ELSE
		EXIT
	ENDIF
  ENDDO

  Fclose(_handle)
  m->_MainHandle:=_handle	// global access if normally opened
  IF EMPTY(lExit)
    m->__aDbStruct:={}
    m->___aDbStruct:={}
    AEVAL(m->_aDbStruct,{|el| IF(EMPTY(el[1]),,;
				(AADD(m->__aDbStruct,el),;
				 AADD(m->___aDbStruct,{el[1],el[2],el[3],el[4]});
				))})

    DO CASE
	CASE cFirstByte $ '01'	//VFPCDX
		IF UPPER(Substr(cName,-4))=='.DBC'
			_memo:='.DCT'
		ELSEIF UPPER(Substr(cName,-4))<>'.DBF'
			_memo:='.'+SUBSTR(cName,-3,2)+'T'
		ENDIF
		i:=4

	CASE m->_aCommon[2] $ chr(245)	//'Ñ—' DBFCDX
		IF UPPER(Substr(cName,-4))<>'.DBF';
			THEN _memo:='.'+SUBSTR(cName,-3,2)+'T'
		i:=1

	CASE cFirstByte $ chr(131)	//'Ð“'	DBFNTX
		i:=2

	CASE cFirstByte<>'0' .AND. IsVFP()
		i:=1				//VFPCDX not open

	OTHER
		IF (i:=ASCAN(m->__aRdd,_DefaultRDD))==0
//number in ini specified incorrectly
			IF (i:=SelectRdd())==0
				_DefaultRdd:='DBFCDX'
				i:=1
			ENDIF
		ENDIF
    ENDCASE
    _mFile:=ClearName()
    _DefaultCdx:=m->__aCdx[i]
    m->__CdxName:=_mFile+_DefaultCdx
    cRdd:=m->__aRdd[i]
    IF EMPTY(_memo) THEN _memo:=m->__aMem[i]
    lNeedMemo:=(cFirstByte $ chr(245)+chr(131)+chr(48)+chr(49))	//'Ñ—Ð“01'
    IF lNeedMemo .AND. !IsFileExist(@_mFile,_memo, , (cFirstByte $ '01'))
        IF !(cFirstByte $ '01')
		cRdd:=''
	ELSE
		lNeedMemo:=.F.
	ENDIF
    ELSE
	Sx_MemoExt(_memo)
	m->_MainMemoFile:=_mFile
    ENDIF
    cFirstByte:=SUBSTR(chr(245)+chr(131)+CHR(48)+CHR(49),i,1)	//For a possible fix MEMO

    IF EMPTY(_DefaultCdx) .OR. !('.DBF' $ UPPER(m->_base))
	m->__CdxName:=''
	Sx_AutoOpen(.F.)
    ELSE
	IF FileExist(@__CdxName) .AND. FileSize(m->__CdxName,.T.)==0
		IF Continue(m->__CdxName+_corrupted+NEED_DEL_FILE,1)
			FERASE(m->__CdxName)
		ELSE
			cRdd:=''
		ENDIF
	ENDIF
	Sx_AutoOpen(.T.)
    ENDIF
  ENDIF
ENDIF

RETU cRdd
**********
EXTE Descend,Soundex,bIN2d,Bin2W,IsPrinter,Stuff,iscolor,;
     DBSETORDER,Right,True_Ver,__mRelease
#IFDEF DEBUG
**********
FUNC __DBGHELP
RETU 0
#ENDIF
