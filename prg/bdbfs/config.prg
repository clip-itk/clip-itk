/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
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
		'_nBrowMaxField','_ClipChoice','_lCnvWClip'}

STATIC aColor:={'_bm','_im','_cm','_MenuColor','HiddenColor','_HdColor',;
		'SetBlink()','Set(31)'}

STATIC aPrint:={ "_NeedRec","_RecRight","_NeedCentr","_printZero",;
		"_MemoPrnt","_MemoNumLines",;
		"_pscode","_pecode",;
		"_Plength", "_Lmargin","_pspacing","_NeedHeadPage",;
		"_NeedMainHead","_NeedPrPage","_DefaultBorder",;
		"_NeedEject","_NeedSum","_Printer","_NeedApFile"}

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
LOCAL	i,ns,el,Sets,Gets

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
FOR i:=1 TO LEN(aColor)
	cColor:=aColor[i]
	AADD(Sets, IF(TYPE(cColor)=='C', PAD(&(cColor),42), &(cColor) ) )
NEXT
*AEVAL(aColor, {|_1| AADD(Sets,IF(TYPE(_1)=='C', PAD(&(_1),42), &(_1) ) ) })

Gets:={ {05,05,_MSG_A_C_ED},;
	{07,05,_MSG_A_C_HLP},;
	{09,05,_MSG_A_C_MARK},;
	{11,05,_MSG_A_C_MM},;
	{13,05,_MSG_A_C_HIDE},;
	{15,05,_MSG_A_C_HD},;
	{19,05,_MSG_A_C_BLINK},;
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
FOR i:=1 TO LEN(aOther)
	AADD(Sets,&(aOther[i]))
NEXT
*AEval(aOther,{|el| AADD(Sets,&(el))} )	//�� ࠡ�⠥�
Sets[7]:=IF(ValType(_macro)=='C','['+_macro+']',FT_XTOY(_macro,'C'))
Sets[8]:=FT_XTOY(m->_MemoEditor,'C')
AEVAL(Sets, {|_1,i| IF(VALTYPE(_1)=='C', Sets[i]:=PAD(_1,512),NIL) })

Gets:={ {05,05,_MSG_A_O_FORCED},;
	{05,  ,_MSG_A_O_TIME},;
	{06,05,_MSG_A_O_IND},;
	{06,,_MSG_A_O_FRQ,'99999'},;
	{07,05,_MSG_A_O_MSK,'xxxxxxxxxxxx'},;
	{07,,_MSG_A_O_UNDO,'9999',{||Between(Sets[6],0,4095)}},;
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
	{20,05,_MSG_A_O_CLCH},;
	{20,  ,_MSG_A_O_WCLCNV};
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
	m->_req:=0	//��-�� _lForced,_nBrowMaxField
ENDIF
**********
PROC Configure
LOCAL	_prn_seq:=PRN_SEQ, c2:=m->_middlecol+10,;
	Gets,Sets, i, el

Sets:={}
FOR i:=1 TO LEN(aPrint)
	AADD(Sets,&(aPrint[i]))
NEXT

*AEval(aPrint,{|el| AADD(Sets,&(el))} )	//�� ࠡ�⠥�

Sets[7]:=PAD(m->_psCode,255)
Sets[8]:=PAD(m->_peCode,255)
Sets[18]:=PAD(m->_printer,255)

Gets:={ {6,  5, REC_NEED	},;
	{6, c2, REC_RIGHT	},;
	{7,  5, CENTR_NEED	},;
	{7, c2, ZERO_NEED	},;
	{8,  5, MEM_WIDE_PRT	,"999"},;
	{8, c2, MEM_NUM_LINE	,"9999"},;
	{11, 4, ''		,},;
	{13, 4, ''		,},;
	{15,  5, PAGE_LEN	,"999", {||Sets[9]=0 .OR. Sets[9]>30}},;
	{15, c2, LEFT_BORD	,"99"},;
	{16,  5, NUM_LF	 	,"9"},;
	{17,  5, NEED_HEAD	},;
	{17, c2, STAND_HEAD	},;
	{18,  5, NUM_PAGE	},;
	{18, c2, DEF_BORDER	},;
	{19,  5, NEED_FF	},;
	{19, c2, NEED_SUM	},;
	{20,  5, OUT_DEV	,"@S22"},;
	{20, c2, F_OUT_AP	}}
IF ConfigWindow(Gets,Sets,SELECT_PRINT,{{10,START_CHAR},{12,END_CHAR}})
	FOR i:=1 TO LEN(aPrint)
		&(aPrint[i]):=Sets[i]
	NEXT
	*AEVAL(Sets, {|el,i| &(aPrint[i]):=el}) //�� ࠡ�⠥�
	m->_psCode:=TRIM(Sets[7])
	m->_peCode:=TRIM(Sets[8])
	m->_Printer:=ALLTRIM(Sets[18])
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
	SaveIniArr((i:=Fcreate(_IniFile)),aRdd,'Data Driver')
	SaveIniArr(i,aOther,'System variables')
	SaveIniArr(i,aColor,'Colors')
	SaveIniArr(i,aPrint,'Printer')
	SaveIniArr(i,aSets,'Clipper standard sets')
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
/*�� � CheckDbf ᤥ������
	SX_MemoExt(m->_DefaultMemo)
	__CdxName:=Sx_FnameParser(_base,.t.)+m->_DefaultCdx
*/
	m->_indexFile:=m->_oldInd:=''
	_req:=0
ENDIF
RETURN i
