/*
    Copyright (C) 1998-2004 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
#include "set.ch"

MEMVAR _req,__mcol,_im,_HdColor,_zif,_macro,_inifile,_MemoEditor
STATIC aOther:={'_lForced','_timing','_lMeter','_sx_step','_mask','_UndoSize',;
		'_macro','_MemoEditor','_textViewer','_PlugDir',;
		'_nMemoTab','_nMemoWrap',;
		'_DirShow','_AutoSave','_AutoRestore',;
		'_nBrowMaxField','_lPckAsk','_lPckCheck'}

STATIC aOth1 :={'_ClipChoice','_ClipWChoice','_lCnvWClip',;
		'_lexp_o2a','_lexp_o2aq',;
		'_lGsExp','_lGfCond',;
		'__aExt'}

STATIC aColor:={'_bm','_im','_cm','_MenuColor','HiddenColor','_HdColor',;
		'SetBlink()','Set(31)'}

STATIC aPrint:={ "_NeedRec","_RecRight","_NeedCentr","_printZero",;
		"_MemoPrnt","_MemoNumLines",;
		"_pscode","_pecode",;
		"_Plength", "_Lmargin","_pspacing","_NeedSum",;
		"_NeedMainHead","_NeedPrPage",;
		"_NeedHeadPage","_lTitleAll",;
		"_lDgtHdr","_lDHAll",;
		"_DefaultHBorder","_DefaultBorder",;//В зависимости от места вызова
		"_NeedEject","_Printer","_NeedApFile"}

STATIC aSet:={	"EXACT","FIXED","DECIMALS","DATEFORMAT","EPOCH","PATH",;
		"SOFTSEEK","UNIQUE","DELETED","BELL","CONFIRM","ESCAPE",;
		"DELIMITERS","DELIMCHARS","CONSOLE",;
		"ALTERNATE","ALTFILE"}

STATIC aSetN:={	_SET_EXACT,_SET_FIXED,_SET_DECIMALS,_SET_DATEFORMAT,_SET_EPOCH,_SET_PATH,;
		_SET_SOFTSEEK,_SET_UNIQUE,_SET_DELETED,_SET_BELL,_SET_CONFIRM,_SET_ESCAPE,;
		_SET_DELIMITERS,_SET_DELIMCHARS,_SET_CONSOLE,;
		_SET_ALTERNATE,_SET_ALTFILE}

**********
PROC Sets
LOCAL	Sets,Gets,i,ns,el

Gets:={ { 05,05,,	,},;
	{ 05,31,,	,},;
	{ 05,57,,'99'	,},;
	{ 07,10,,	,,10},;
	{ 07,45,,'9999'	,},;
	{ 09,05,,	,,255},;
	{ 11,05,,	,},;
	{ 11,31,,	,},;
	{ 11,57,,	,},;
	{ 13,05,,	,},;
	{ 13,31,,	,},;
	{ 13,57,,	,},;
	{ 15,10,,	,},;
	{ 15,45,,	,},;
	{ 17,10,,	,},;
	{ 17,45,,	,},;
	{ 19,05,,	,,80}}

Sets:={}
FOR i:=1 TO LEN(Gets)
	Gets[i,3]:='SET '+aSet[i]
	ns:=Set(aSetN[i])
	AADD(Sets,  IF(LEN(Gets[i])==5, nS, PAD(ns,Gets[i,6]) ) )
NEXT

IF ConfigWindow(Gets,Sets,_MSG_A_SETS,{})
	FOR i:=1 TO LEN(Sets)
		Set(aSetn[i], Sets[i])
	NEXT
	_req:=2
ENDIF
**********
PROC Colors()
LOCAL	Sets, Gets, i, cColor
Sets:={}
*
FOR i:=1 TO LEN(aColor)
	cColor:=aColor[i]
	AADD(Sets, IF(TYPE(cColor)=='C', PAD(&(cColor),42), &(cColor) ) )
NEXT
* Конструкция AEVAL(aColor, ... дает больший .о

Gets:={ {05,05,_MSG_A_C_ED},;
	{07,05,_MSG_A_C_HLP},;
	{09,05,_MSG_A_C_MARK},;
	{11,05,_MSG_A_C_MM},;
	{13,05,_MSG_A_C_HIDE},;
	{15,05,_MSG_A_C_HD},;
	{19,05,_MSG_A_C_BLINK },;
	{19,  ,_MSG_A_C_INT};
}

IF ConfigWindow(Gets,Sets,_MSG_A_C_TOP,{})
	FOR i:=1 TO 6
		&(aColor[i]):=ALLTRIM(Sets[i])
	NEXT
	SetBlink(Sets[7])
	Set(_SET_INTENSITY,Sets[8])
	_req:=0
ENDIF
**********
PROC OtherConf()
LOCAL	Sets,Gets,as,i
Sets:={}
*
FOR i:=1 TO LEN(aOther)
	AADD(Sets,&(aOther[i]))
NEXT

Sets[7]:=IF(ValType(_macro)=='C','['+_macro+']',FT_XTOY(_macro,'C'))
Sets[8]:=FT_XTOY(m->_MemoEditor,'C')
AEVAL(Sets, {|_1,i| IF(VALTYPE(_1)=='C', Sets[i]:=PAD(_1,512),NIL) })


Gets:={ {05,05,_MSG_A_O_FORCED},;
	{05,  ,_MSG_A_O_TIME},;
	{06,05,_MSG_A_O_IND},;
	{06,  ,_MSG_A_O_FRQ,'99999'},;
	{07,05,_MSG_A_O_MSK,'xxxxxxxxxxxx'},;
	{07,  ,_MSG_A_O_UNDO,'9999',{||Between(Sets[6],0,4095)}},;
	{09,05,_MSG_A_O_MAC},;
	{11,05,_MSG_A_O_ED},;
	{13,05,_MSG_A_O_VF},;
	{15,05,_MSG_A_O_PG},;
	{17,05,_MSG_A_O_TAB,'99'},;
	{18,05,_MSG_A_O_WRAP,'999'},;
	{19,05,_MSG_A_O_NAME,'99'},;
	{17,  ,_MSG_A_O_ASAVE},;
	{18,  ,_MSG_A_O_AREST},;
	{19,  ,_MSG_A_O_MAXF,'9999'},;
	{20,05,_MSG_A_O_PCKASK},;
	{20,  ,_MSG_A_O_PCKFND};
	}


IF ConfigWindow(Gets,Sets,_MSG_A_O_TOP,{})
	FOR i:=1 TO LEN(Sets)
		aS:=Sets[i]
		&(aOther[i]):=IF(VALTYPE(aS)='C',ALLTRIM(as),as)
	NEXT
	BEGIN SEQUENCE
		IF EMPTY(_macro) .OR. Type(_macro) $ 'UEL'
			_macro:=''
		ELSE
			IF Type(_macro)=='N' THEN aS:='['+_macro+']'
			_macro:=&(_macro)
		ENDIF
	END
	IF TYPE(_MemoEditor)=='A' THEN _memoEditor:=&(_MemoEditor)
	m->_req:=0	//Из-за _lForced,_nBrowMaxField
ENDIF
**********
PROC OtherConf1()
LOCAL	Sets,Gets,as,i
Sets:={}
AEval(aOth1,{|el| AADD(Sets,&(el))} )
Sets[8]:=PAD(FT_XTOY(Sets[8],'C'),512)
*

Gets:={ {05,05,_MSG_A_O_CLCH},;
	{07,05,_MSG_A_O_WCLCH},;
	{07,  ,_MSG_A_O_WCLCNV},;
	{09,05,_MSG_A_O_EXOEM},;
	{11,05,_MSG_A_O_EXOEMQ},;
	{13,05,_MSG_A_O_GSEXP},;
	{15,05,_MSG_A_O_GSCOND},;
	{18,04,''};
	}

*

IF ConfigWindow(Gets,Sets,_MSG_A_O_TOP,{{17,_MSG_A_O_FASS}})
	FOR i:=1 TO LEN(Sets)
		aS:=Sets[i]
		&(aOth1[i]):=IF(VALTYPE(aS)='C',ALLTRIM(as),as)
	NEXT
	__aExt:=&(Sets[8])
ENDIF
**********
PROC Configure(lConcr)
LOCAL	Sets, Gets,_prn_seq:=PRN_SEQ, c2:=m->_middlecol+10,;
	i, el

IF EMPTY(lConcr)
	aPrint[19]:="_DefaultHBorder"
	aPrint[20]:="_DefaultBorder"
ELSE
	aPrint[19]:="cDivideT"
	aPrint[20]:="cDivide"
ENDIF

Sets:={}

FOR i:=1 TO LEN(aPrint)
	AADD(Sets,&(aPrint[i]))
NEXT

Sets[7]:=PAD(m->_psCode,255)
Sets[8]:=PAD(m->_peCode,255)
Sets[22]:=PAD(m->_printer,255)

Gets:={ {5,  5, REC_NEED	},;
	{5, c2, REC_RIGHT	},;
	{6,  5, CENTR_NEED	},;
	{6, c2, ZERO_NEED	},;
	{7,  5, MEM_WIDE_PRT	,"999"},;
	{7, c2, MEM_NUM_LINE	,"9999"},;
	{9,  4, ''		,},;
	{11,  4, ''		,},;
	{13,  5, PAGE_LEN	,"999", {||Sets[9]=0 .OR. Sets[9]>30}},;
	{13, c2, LEFT_BORD	,"99"},;
	{14,  5, NUM_LF		,"9"},;
	{14, c2, NEED_SUM	},;
	{15,  5, STAND_HEAD	},;
	{15, c2, NUM_PAGE	},;
	{16,  5, NEED_HEAD	},;
	{16, c2, TITLE_ALL	},;
	{17,  5, DGT_HEAD_1ST	},;
	{17, c2, DGT_HEAD_ALL	},;
	{18,  5, DEF_HBORDER	},;
	{18, c2, DEF_BORDER	},;
	{19,  5, NEED_FF	},;
	{20,  5, OUT_DEV	,"@S22"},;
	{20, c2, F_OUT_AP	}}
IF ConfigWindow(Gets,Sets,SELECT_PRINT,{{8,START_CHAR},{10,END_CHAR}})
	FOR i:=1 TO LEN(aPrint)
		&(aPrint[i]):=Sets[i]
	NEXT
	*AEVAL(Sets, {|el,i| &(aPrint[i]):=el}) //Не работает
	m->_psCode:=TRIM(Sets[7])
	m->_peCode:=TRIM(Sets[8])
	m->_Printer:=ALLTRIM(Sets[22])
ENDIF
**********
STATIC FUNC ConfigWindow(Gets,Sets,cPanelMsg,aCenterMsg)
LOCAL scr, lRes
ScrSave(@scr)
SetColor(_im)
PANEL(2,2,22,__mcol-2,cPanelMsg+_MSG_A_F10,{_im,_HdColor,_im})
AEVAL(aCenterMsg,{|el|Center(el[1],el[2])})
lRes:=ReadCycle(Gets,Sets,21,__mcol-12)
ScrRest(scr)
RETURN lRes
**********
FUNC ReadCycle(Gets,Sets,sc_Row,sc_col)
LOCAL i,GetList:={},aG,cPict,npS
PRIVATE Score_row:=Sc_row,Score_Col:=sc_col
PUSH KEYS
m->Main_keys[10]:=SaveF10Key
ShowMouse()
FOR i:=1 TO LEN(Gets)
	aG:=Ext_Arr(Gets[i],5)
	cPict:=aG[4]
	IF ValType(Sets[i])=='L' THEN cPict:='L'
	nPs:=IF( !EMPTY(cPict) .AND. '9' $ cPict, LEN(cPict), 1)
	IF_NIL aG[2] IS m->__mcol-5-LEN(aG[3])-nPs
	@ aG[1], aG[2] SAY aG[3]+' '
	IF_NIL cPict IS '@S'+NTRIM(m->__mcol-4-COL())
	AAdd( GetList, _GET_( Sets[i], "Sets[i]", cPict, aG[5], ):Display())
NEXT
READMODAL(GetList, .T.) //Cycle
POP KEYS
RETURN (LASTKEY()#K_ESC)
**********
PROC SaveIni(cAop,aDop,cHead)
LOCAL i,cIni:=m->_IniFile
LOCAL aRdd:={'_DefaultRdd','_DefaultMemo','_DefaultCdx'}
LOCAL aSets:={}

AEVAL(aSetN, {|i| AADD(aSets,'SET('+NTRIM(i)+')' ) })
IF !EMPTY(cAop) THEN m->_IniFile:=cAop

IF (!EMPTY(cAop) .OR. GetName(_zif,'_IniFile')) .AND.;
   TestWriteFile(@_IniFile,'.INI')
	SaveIniArr((i:=Fcreate(_IniFile)),aRdd,_MSG_C_INI_H1)
	SaveIniArr(i,A_Join(aOther,aOth1),_MSG_C_INI_H2)
	SaveIniArr(i,aColor,_MSG_C_INI_H3)
	SaveIniArr(i,aPrint,_MSG_C_INI_H4)
	SaveIniArr(i,aSets,_MSG_C_INI_H5)
	IF !EMPTY(cAop) THEN SaveIniArr(i,aDop,cHead)
	FCLOSE(i)
	NFIND(READY)
ENDIF
IF !EMPTY(cAop) THEN m->_IniFile:=cIni
**********
STATIC PROC SaveIniArr(h,aArr,cHead)
LOCAL i,cAr,cStr
FWRITE(h,_CRLF+'// '+cHead+_CRLF)
FOR i:=1 TO LEN(aArr)
	cAr:=aArr[i]
	IF TYPE(cAr)=='C'
		cStr:=cAr+':="'+&(cAr)+'"'
	ELSEIF '()' $ cAr
		cStr:='='+Strip(cAr,1)+FT_XTOY(&(cAr),'C')+')'
	ELSEIF ')' $ cAr
		cStr:='='+Strip(cAr,1)+','
		cStr:=cStr+ IF( VALTYPE(&(cAr))='C'	,;
				'"'+&(cAr)+'")'		,;
				FT_XTOY(&(cAr),'C')+')'	;
			      )
	ELSE
		cStr:=cAr+':='+FT_XTOY(&(cAr),'C')
	ENDIF
	FWRITE(h,cStr+_CRLF)
NEXT
**********
FUNC SelectRdd()
LOCAL aRdd:=m->__aRdd,i

IF ((i:=ForAch(5,DRV_DEFAULT,;
		m->__aDrv,Ascan(aRdd,m->_DefaultRdd)))#0)  .AND. ;
    (aRdd[i]<>m->_DefaultRdd)
	m->_DefaultRdd:=aRdd[i]
	m->_DefaultMemo:=m->__aMem[i]
	m->_DefaultCdx:=m->__aCdx[i]
	RDDSetDefault(m->_DefaultRdd)
/*Это в CheckDbf сделается
	SX_MemoExt(m->_DefaultMemo)
	__CdxName:=Sx_FnameParser(_base,.t.)+m->_DefaultCdx
*/
	m->_indexFile:=m->_oldInd:=''
	_req:=0
ENDIF
RETURN i
**********
FUNC SelectCP(xCp)
LOCAL aNames, HomeDir:=CurrentDir()
ChDir(CLIPROOT()+"/charsets")
aNames:=Filer("*.tbl",SELECT_CP)
ChDir(HomeDir)
IF aNames[1]#0
	IF EMPTY(xCp)
		m->_req:=0
		Set("DBF_CHARSET", Sx_FNameParser(aNames[2]))
	ELSE
		xCp:=aNames[2]	//по ссылке
	ENDIF
	RETU .T.
ENDIF

RETU .f.
