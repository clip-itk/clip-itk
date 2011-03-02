/*
    Copyright (C) 1998-2004 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
Library functions ELB.LIB, specially adopted for bdbfs.
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
#include "set.ch"
MEMVAR	__mcol,__mrow,_middlerow,_middlecol,_mins,_ms,;
	_im,_cm,_MenuColor,_hdcolor,_base,;
	_timing,_told,_tally,main_keys,;
	_c_F,_scatter,_works,_pole,__sum,__count,;
	_req,__go,_tmr,alSelect,_pushkeys,_pushfkeys

***********
PROC Devices
PUBLIC _mins:=IsMouse(),__mcol:=MaxCol(),__mrow:=MaxRow(),_ms:=0
PUBLIC _middleCol:=INT(__mcol/2),_middleRow:=INT(__mrow/2)
IF _mins THEN SetMouseXY(__mcol,__mrow)
PUBLIC __Menu_Row:=0,__Menu_Col:=0,__Menu_Prom:=''	//Used in menu
**********
FUNC NFIND(_mess,_var,_color,_Footer,lNeedTone,nTimeWait,nlShine,nMuch)
LOCAL i,sc:=SetCursor(0),_r,_c,nStr,aDvd:={},cTst:='',nWide:=__mcol-12,aMess
IF TYPE('_lPlain')<>'U'
	? _mess
	QUIT	//Still recovery error while RETURN
ENDIF
IF_NIL _color IS m->_im
IF_NIL _Footer IS ''
IF_NIL nTimeWait IS 0
IF !EMPTY(m->bAutoExec) THEN nTimeWait:=1

__Keyboard()
PUSH KEYS
IF _var#NIL
	Main_Keys:=Reslt_M_Keys
	IF !EMPTY(i:=ALLTRIM(PAD(_var,255))) .AND.;
	    Ascan(m->_aGlbHRes,i)=0 THEN AADD(m->_aGlbHRes,i)
ENDIF
aMess:={""}
DO CASE
	CASE ValType(_mess)='N'
		AADD(aMess,SpaceString(_mess))
	CASE ValType(_mess)="C"
		cTst:=TRIM(_Mess)
	OTHER
		i:=Medi(_mess,nWide,"")
		IF ValType(_mess)="A"
			cTst:=Arr2Str(_mess)
			aMess:={i}
		ELSEIF ValType(_mess)="O"
			aMess:={i}
			cTst:={}
			FOR i IN _mess
				AADD(cTst, i)
			NEXT
			cTst:=Arr2Str(cTst)
		ELSE
			AADD(aMess,i)
		ENDIF
ENDCASE
IF LEN(cTst) > nWide
	nStr:=INT(DivideStr(cTst,14,nWide,"", @aDvd, .T. ))/2+1
ELSE
	nStr:=2
	aDvd:={cTst}
ENDIF
aDvd:=A_JOIN(aMess,aDvd)

i:=ShowButton(_middlerow-nStr,5,_middlerow+nStr,__mcol-6,aDvd,_color,,7)
Center(_middlerow+nStr, LEFT(TRIM(_Footer),nWide),,_HdColor)

IF !EMPTY(nlShine) //.AND. LEN(aDvd)=2
	IF_NIL nMuch IS 1
	@ _middlerow, INT(9+Centr(_mess,__mcol-17)+nlShine-1);
	   SAY SUBSTR(_mess,nlShine,nMuch) COLOR _HdColor
ENDIF

IF !EMPTY(lNeedTone)
	Tone(440,1)
ENDIF
WaitKey(nTimeWait)
DownButton(i,0.2)
i:=LastKey()
IF _var#NIL THEN InsKeys(_var,i)

POP KEYS
SetCursor(sc)
RETURN i
**********
STATIC PROC InsKeys(_var,nK)
LOCAL _i
IF nK==K_F10 THEN;
	 _i:=ForAch(10,MSG_PUTTITLE,MSG_PUTWHERE )
DO CASE
	CASE _i=1 .OR. nK=K_F5
		MyRepl(_c_f,_var)
	CASE _i=2 .OR. nK=K_CTRL_GPLUS
		A_INS(m->_ClipText,_var)
	CASE _i=3 .OR. nK=K_CTRL_INS
		SetWinClip(_var)
	CASE nk=K_F2
		__Keyboard('?'+FT_XTOY(_var,'C'))
#IFNDEF ENGLISH
	CASE _i=4 .OR. nK==36	//$
		Nfind(__go:=LTRIM(TRANSF(FT_XTOY(_var,"N")*0.01,;
			     '@R 999,999,999,999.99')),__go)
#ENDIF

END
**********
FUNC ShowButton(_x01,_y01,_x02,_y02,_s,_color,_Frame,_ColorBorder,_Selected)
/*
 In the presence of an array messages '_s' they appear, beginning with the first
 line of the window. With _ColordBorder around frame is the shadow with specified
 color (as numeric). When set _COLOR - temporarily set the color _FRAME determines
 the form of frames - by default - single. If defined character pair '_Selected',
 it is bordered all the messages (this is used in menus).

 If the window coordinates are given incomplete, then used the maximum dimensions.

	Example:
// Frame with specified color in center
	ShowButton(10,10,14,69,[Press any key],NewColor,FRAME2)

 See WaitWindow(),Nfind(),Waiting()
*/

LOCAL	_wide,nX1,_sc,_front,_lft,_i

IF_NIL _x01 IS 0
IF_NIL _y01 IS 0
IF_NIL _x02 IS __mrow
IF_NIL _y02 IS __mcol
IF_NIL _s IS ''
IF_NIL _color IS SetColor()
IF_NIL _frame IS '�Ŀ����� ' // utf-8: '┌─┐│┘─└│ '

_x01:=INT(_x01)
_x02:=INT(_x02)
_y01:=INT(_y01)
_y02:=INT(_y02)

Hilite(_color,@_front,@_sc)

_wide:=_y02-_y01-1
BoxShadow(_x01,_y01,_x02,_y02,_ColorBorder,_frame,_front)

HideMouse()
DispBegin()
@ _x02,_y01+1 SAY Repl(Substr(_Frame,2,1),_wide)+;
		  Substr(_Frame,5,1) COLOR _sc
nX1:=_x01+1		//Int((_x02-_x01)/2)
FOR _i:=nX1 To _x02-1
	@ _i,_y02 Say Substr(_Frame,4,1) COLOR _sc
NEXT
@ _x01,_y02 SAY Substr(_Frame,3,1) COLOR _sc

IF ValType(_s)=='C' THEN _s:={_s}

FOR _i:=1 TO LEN(_S)
	_lft:=LEFT(_s[_i],_wide)
	IF !Empty(_Selected) .AND. !EMPTY(_lft) .AND. ;
	   LEFT(_lft,1)<>L_A_SIGN .AND. (Len(_lft) < _wide)
		_lft:=LEFT(_Selected,1)+_lft+RIGHT(_Selected,1)
	ELSEIF LEFT(_lft,1)==L_A_SIGN
		_lft=Substr(_lft,2)
	ENDIF
	@ nX1++,INT(_y01+1+Centr(_lft,_wide+1)) say _lft COLOR _color
NEXT

ShowMouse()
DispEnd()
RETURN {_x01,_y01,_x02,_y02,_front,_sc,_frame}
**********
PROC DownButton(_aHandle,_waiting)
* Shows a depressed button on the handle stored in ShowButton
* In the presence of _waiting waits a specified time

LOCAL _i,_front:=_aHandle[5],;
	_x01 :=_aHandle[1],;
	_y01 := _aHandle[2],;
	_x02 :=_aHandle[3],;
	_y02 :=_aHandle[4],;
	_frame:= _aHandle[7]

IF_NIL _waiting IS 0.001

HideMouse()
DispBegin()
DispBox(_x01,_y01,_x02,_y02,TRIM(_frame)/*'┌─┐│┘─└│ '*/,_aHandle[6])
@ _x02,_y01+1 SAY Repl(Substr(_frame,2,1)/*'─'*/,_y02-_y01-1)+;
		  Substr(_frame,5,1) /*'┘'*/ COLOR _front

FOR _i:=_x01+1 To _x02-1
	@ _i,_y02 Say Substr(_frame,4,1)/*'│'*/ COLOR _front
NEXT
@ _x01,_y02 SAY Substr(_frame,3,1) /*'┐'*/ COLOR _front

ShowMouse()
DispEnd()
WaitKey(_waiting)
**********
PROC Okey(arr,_okey)
LOCAL	_i,nCnt,nlOk,_mc,_srow
IF_NIL _okey IS ""+[ Ok ]+""
PUSH KEYS

nCnt:=LEN(arr)
nlOk:=LEN(_oKey)/2+1
_Srow:=_middleRow-nCnt/2-4

_i:=Min(Max(A_MaxLen(arr),nlOk*2),__mcol-4)
_mc:=_middleCol-_i/2-2
DispBegin()
DownButton(ShowButton(_srow,_mc,_srow+5+ncnt,_middleCol+_i/2+1 ,,_im))

AEVAL(arr,{|_1| Hi_String(PADC(_1,_i+1),++_srow,_mc+2)})

ShowMouse()
_srow+=2
_i:=ShowButton(_srow,_middlecol-nlOk,_srow+2,_middlecol+nlOk+1,_okey,"n/w")
DispEnd()
WaitKey(0)
DownButton(_i,0.2)

POP KEYS
**********
PROC Hi_String(cMsg,nRow,nCol,cDiv)
LOCAL lHl,cHl,cC
IF_NIL cDiv IS CHR(0)

DevPos(nRow,nCol)
lHl:=.F.
cC:=_im

WHILE Parce(cMsg,CHR(0),@cHl,@cMsg)<>0
	DevOut(cHl+' ',cC)
	lHl:=!lHl
	cC:=IF(lHl, _HdColor, _im)
ENDDO
DevOut(cHl,cC)
**********
FUNC Medi(_s,_n,_bd,_nc)
LOCAL	s1,_Decim
IF_NIL _bd IS m->_DefaultBorder
IF_NIL _nc IS .T.
DO CASE
   CASE VALTYPE(_s) $ 'NF'
	IF  _s=0 .AND. !m->_printZero
		_s:=''
	ELSE				//IF INT(_s)#_S
		IF '*' $ (s1:=STR(_s))
			_Decim:=SET(_SET_DECIMALS)
// Provide rejection fraction if overflow
			WHILE '*' $ Str(_s,_n,_decim) .AND. _Decim>0
				_decim--
			END
			_s:=Str(_s,_n,_decim)
		ELSE
			_s:=s1
		ENDIF
	ENDIF

	IF !_nc THEN RETU PADL(LTRIM(_s),_n)+_bd

   CASE ValType(_s)='L'
	_s=IF(_s,YESNO)

   CASE ValType(_s)='D'
	_s:=DTOC(_s)

   CASE ValType(_s) $ 'MC' .AND. !_nc
	RETU PADR(_s,_n)+_bd

   CASE ValType(_s)='A'
	_s:='ARRAY['+NTRIM(LEN(_s))+']'

   CASE ValType(_s)='O'
	_s1:=IF( TYPE('_s:ClassName')<>'C',[UNKNOWN CLASS], _s:ClassName)
	_s:='OBJECT:'+_s1+' SIZE='+NTRIM(LEN(_s))

   CASE ValType(_s)='B'
	_s:=PAD(Eval(_s),255)

   CASE ValType(_s)='T'
	_s:=TTOC(_s)

   CASE _s==NIL
	_s:='NIL'
ENDCASE

RETU PADC(ALLTRIM(_s),_n)+_bd
**********
PROC Insert
LOCAL _tmprc:=RecNo(),i:=0//,_scat
TimerOn()
Meter(1,INSERTING,,LASTREC()-_tmprc)

APPE BLANK
DO WHILE _tmprc < RECNO()
	* shift up for insert
	DBSKIP(-1)

	* get previous fieldspecs
	Scatter()
	*_scat:=Get_Rec()
				* put into current fieldspec
	DBSKIP()

	Gather()
	*Put_Rec(_scat)
	IF ++i % m->_sx_step==0 THEN Meter(2,,i)
				* next
	DBSKIP(-1)
ENDDO
ClearRec()
RECALL
*Put_Rec(SPACE(RECSIZE()))
Meter(3)
**********
PROC InsertAll(nMuch)
LOCAL nRec:=RECNO()-1
Appe(nMuch)
SwapAll(nRec,nRec+nMuch,LASTREC()-nRec-nMuch, .T.)
GO nRec
**********
PROC Scatter(aScat)
LOCAL _i
aScat:={}
For _i:=1 to Fcount() DO AADD(aScat,FieldGet(_i))
AADD(aScat,Deleted())
IF PCOUNT()=0
	m->_Scatter:=aScat
ENDIF
**********
PROC Gather(aScat)
LOCAL _i
IF_NIL aScat IS m->_Scatter
IF ValType(aScat)=='A'
  FOR _i:=1 to Fcount() DO FieldPut(_i, aScat[_i])
  IF aScat[_i]
	DELETE
  ELSE
	RECALL
  ENDIF
ENDIF
**********
FUNC TestWriteFile(_NameFile,_DefaultExt,lNoSame)
LOCAL _h,lRes:=.T.,cMsg
IF EMPTY(_NameFile) THEN RETU .F.
_NameFile:=ADD_EXT(_NameFile,_DefaultExt)
cMsg:=BADNAME
IF !EMPTY(lNoSame) .AND. _NameFile==m->_base
	_h:=-1
ELSEIF FileExist(@_NameFile)
	IF Continue(_NameFile+_NEEDOVER)
		IF ( _h:=FOPEN(_NameFile,66) ) <=0
			cMsg:=BADWRITE
		ELSE
			FCLOSE(_h)
		ENDIF
	ELSE
		lRes:=.F.
		_h:=0
	ENDIF
ELSE
	IF ( _h:=Fcreate(_NameFile) ) > 0
		FCLOSE(_h) ; FErase(_NameFile)
	ENDIF
ENDIF
IF _h < 0
	NFIND(cMsg)
	lRes:=.F.
ENDIF
RETURN lRes
**********
FUNC Add_Ext(name, ext)
name:=ALLTRIM(name)
IF RAT('.',name) <= RAT(PATH_DELIM,name)
#ifdef  __CLIP__
	ext:=LOWER(ext)
#else
	IF IsLower(name)
		ext:=LOWER(ext)
	ELSE
		ext:=UPPER(ext)
	ENDIF
#endif
	name+=ext
ENDIF
RETURN name
**********
FUNC IsFileExist(_NameFile,_DefaultExt,cPath,lNoMsg)
_NameFile:=ADD_EXT(_NameFile,_DefaultExt)
IF_NIL cPath IS IF(_DefaultExt='.DBF',';'+SET(_SET_PATH),'')
IF FileOnPath(@_NameFile,cPath) THEN RETU .T.

IF EMPTY(lNoMsg) THEN Nfind(PRV_NOFILE+_NameFile)
RETU .F.
**********
FUNC FileExist(cName)
*Not File(), that are not confused with PATH
LOCAL lRes:=.T.
IF !EMPTY(Directory(cName))
ELSEIF !EMPTY(Directory(LOWER(cName)))
	cName:=LOWER(cName)
ELSEIF !EMPTY(Directory(UPPER(cName)))
	cName:=UPPER(cName)
ELSE
	lRes:=.F.
ENDIF
RETURN lRes
**********
FUNC FileOnPath(cName,cPath)
LOCAL lRes:=.F., cNow, i, cReal
IF_NIL cPath IS ';'+m->_PlugDir+';'+GetEnv("INCLUDE")
cPath+=';'

DO WHILE .T.
	i:=Parce(cPath, ';', @cNow, @cPath)
	IF !EMPTY(cNow) THEN cNow:=STRTRAN(cNow+PATH_DELIM,PATH_DELIM+PATH_DELIM,PATH_DELIM)
	cReal:=cNow+cName
	IF FileExist(@cReal)
		cName:=cReal
		lRes:=.T.
		EXIT
	ENDIF
	IF i=0 THEN EXIT
ENDDO
RETURN lRes
**********
FUNC MakeEmpty(_fld)
LOCAL i,xRes,cType

xRes:=&_Fld
xRes:={'','','','','','','',0,0,0,0,0,ctod(''),.f.,NIL};
	[AT(ValType(xRes),'CMVXGPTNFBIYDLU')]
IF m->_CurRType=='X' THEN xRes:=NIL
IF Select()==1
	_fld:=RealFldName(_fld)

	i:=ASCAN(m->__aDbStruct,{|_1|UPPER(TRIM(_fld))==_1[1]})
	IF i#0 THEN cType:=m->__aDbStruct[i,5]
ELSE
	cType:=ValType(xRes)
ENDIF
MyRepl(_fld,xRes,cType)
RETURN xRes
**********
FUNC WORK(_head)
LOCAL _i:=ASCAN(_Works,{|x|ALLTRIM(UPPER(x))==ALLTRIM(UPPER(_head))})

RETU IF(_i#0, &(_Pole[_i]), BAD_EXPR+_head)
**********
FUNC ForAch
LOCAL _oldc:=SetColor(m->_im),_i
PARAM _awt,_Whead,_acItems,_Current,_Hlp,anKeys,aDescr
PRIVATE _aWl,_aWr,_lHist:=.F.

m->_awt:=MAX(m->_awt,5)

_i:=INT(Max(A_MaxLen(m->_acItems),LEN(m->_wHead))/2)+1
m->_aWl:=MAX(_middlecol-_i,2)-1
m->_aWr:=MIN(_middlecol+_i,__mcol-2)+1
SaveAllKeys(m->anKeys)

IF 'HIST' $ ProcName(1)
	m->Main_Keys[8]:=_MSG_DEL_F8
	m->_lHist:=.T.
ENDIF

Panel(m->_awt-2,m->_awl-1,;
	m->_awb:=MIN(m->_awt+2+MIN(Len(m->_acItems),m->__mrow-9),m->__mrow),;
		m->_awr,m->_Whead,{_im, _HdColor, _im})
FOR _i:=m->_Awt+1 to m->_awb-1 DO @ _i,m->_awr say SCROLL_FILL

@ m->_awt,m->_awr say SCROLL_UP color _cm
@ m->_awb,m->_awr say SCROLL_DOWN color _cm

FT_PutKey(260)	&& To activate L_ACH
ShowMouse()
m->lRepeat:=.T.
m->lAchFinish:=.F.	// Finish from user-defuned function
WHILE m->lRepeat
	_i=Achoice(m->_awt+1,m->_awl+1,m->_awb-2,m->_awr-2,;
		   m->_acItems,,'L_Ach',IF(PCount()<6,1,m->_Current))
END
IF _i > 0
	DO WHILE First(m->_acItems[_i])=='>'
		_i--
	ENDDO
ENDIF
RestoreAllKeys(!EMPTY(m->anKeys))
SetColor(_oldc) ; retu _i
**********
FUNC L_Ach (_mode,_numb,_posit, oTb)
Static _search:='', _Nmoves:=0
LOCAL _a:=LastKey(),_n,_oldsearch:='',_mox,_moy,_length:=m->_awb-m->_awt-2,;
      _la:=Len(m->_acItems),_Top:=m->_Awt+1,_Left:=m->_awl+1,;
      _right:=m->_awr-1
LOCAL _cpos:=_Top+_Posit,;
      cRowMark:=_top+Int((_numb-1)*_Length/(_la-1)),;
      nWide:=_right-_left
LOCAL bSelect:={|_n,lSlct| m->alSelect[_n]:=lSlct,;
			m->_acItems[_n]:=IF(lSlct,;
				Strtran(m->_acItems[_n],'[ ]','[x]'),;
				Strtran(m->_acItems[_n],'[x]','[ ]'))}
m->lRepeat:=.F.
m->nItem:=_numb		//For SetKey

DispBegin()
@ cRowMark,m->_awr SAY SCROLL_MARK COLOR _cm
IF _nmoves=0 .AND. Between(_a, 1, 31)
	_search=''
ENDIF
@ m->_awb,_left SAY Padc(_search,nWide,'�');
	COLOR IF(EMPTY(_search), "n/b", ) // utf-8: '─'

IF !EMPTY(m->aDescr)
	@ m->_awb-1,_left SAY Padc(m->aDescr[_numb],nWide,'�');
		COLOR IF(EMPTY(m->aDescr[_numb]),"w/b",_HdColor) // utf-8: '─'
ENDIF

IF _la<>_length
	@ m->_awb, _right SAY IF(_numb+_length-_posit > _la, '�', '+') COLOR _HdColor // utf-8: '─'
	@ m->_awt, _right SAY IF(_numb-_posit > 1, '+', '�') COLOR _HdColor // utf-8: '┐'
ENDIF
DispEnd()

DO CASE
	CASE _a=K_ESC .OR. _a=K_ALT_X .OR. m->lAchFinish
		RETU 0

	CASE _a=K_ENTER
		RETU 1

	CASE _a=K_F8 .OR. (_a=K_CTRL_D .AND. Altf()=2)	//Distinguished from ->
		IF m->_lHist
			A_Del(m->_acItems,_numb)
			IF m->_lOwn THEN A_Del(m->_ClipText,_numb)
			RETU 5
		ELSEIF	'SETTAG' $ CalledFrom()
			DelTag(1,_numb)
			m->lAgain:=.T.	//Repeat choise
			RETU 0
		ENDIF

	CASE (_a=K_SPACE .OR. _a=K_INS) .AND. IsPArray('alSelect')
		EVAL(bSelect,_numb,!alSelect[_numb])
		KEYB _DOWN

	CASE (_a=KP_ALT_MINUS .OR. _a=KP_ALT_PLUS) .AND. IsPArray('alSelect')
		AEVAL(m->_acItems,{|_el,_n| EVAL(bSelect,_n,(_a=KP_ALT_PLUS))})
		m->lRepeat:=.T.
		m->_Current:=_numb
		FT_PUTKEY(260)
		@ cRowMark,m->_awr say SCROLL_FILL
		RETU 1

	CASE _a=K_CTRL_UP .AND. m->_lHist .AND. _numb<>1
		SwapAItems(m->_acItems,_numb,_numb-1)
		IF m->_lOwn THEN SwapAItems(m->_ClipText,_numb,_numb-1)
		KEYB _UP

	CASE _a=K_CTRL_DOWN .AND. m->_lHist .AND. _numb<>_la
		SwapAItems(m->_acItems,_numb,_numb+1)
		IF m->_lOwn THEN SwapAItems(m->_ClipText,_numb,_numb+1)
		KEYB _DOWN

	CASE BETWEEN(_a,32,255) .OR. _a==299	//ALT+\
	  _oldsearch := _search
	  IF _a==299
		_search:=" "+CHR(16)+" "+_search
	  ELSE
		_search += Upper(chr(_a))
	  ENDIF
	  Set(_SET_EXACT,.F.)
	  _n=Ascan(m->_acItems,{|_1|UPPER(_1)=_search})
	  Set(_SET_EXACT,.T.)
	  IF _n=0
		_search:=_oldsearch
		_NMoves:=0
	  ELSE
		_Nmoves=_n-_Numb
		IF _nMoves==0
			KEYB _a
		ELSE
			Eval(oTb:SkipBlock, _nMoves)
			oTb:RefreshAll()
			@ _top+Int((_numb-1)*_Length/(_la-1)),m->_awr say SCROLL_FILL
			KEYB _EMP
			RETU 2
		ENDIF
	  ENDIF

	OTHER
		_Nmoves:=0
ENDCASE
*
DispBegin()
@ _cpos,_left say (_a:=Pad(m->_acItems[_numb],nWide) ) color m->_Rev
DispEnd()
ShowMouse();ShowMouse()

_n:=WaitKey(0)
HideMouse()
IF m->_ms=1
	GetMouseXY()
	IF Between(_mox,_left,_right-1)
	  DO CASE
		CASE Between(_moy,_Top,m->_awb-1)
			IF _moy=_cpos
				RETU 1
			ENDIF
			Eval(oTb:SkipBlock, _moy-_cPos)
		CASE Between(_moy, m->_awb, m->_awb+1)
			KEYB _PGDN
		CASE Between(_moy, m->_awt-2, m->_awt)
			KEYB _PGUP
	  ENDCASE

	ELSEIF _mox=m->_Awr
		IF _moy==m->_awt
			KEYB _UP
		ELSEIF _moy==m->_awb
			KEYB _DOWN
		ELSEIF Between(_moy, _top, _awb-1)
			Eval(oTb:SkipBlock, Int((_moy-m->_awt)*(_la)/_Length)-_numb)
		ENDIF
	ENDIF
	m->_ms:=0
	oTb:RefreshAll()
ELSE
	FT_PutKey(_n)
ENDIF

DispBegin()
@ _cpos,_left say _a
@ cRowMark,m->_awr say SCROLL_FILL
DispEnd()
RETU 2		//_mode
**********
FUNC AchKeys(lSet,abAction)
LOCAL aKeys
IF lSet
	PUSH KEYS
	abAction:=Ext_Arr(abAction,11,{'',})
	aKeys:={_MSG_F1}
	AEVAL(abAction,{|_1,i|AADD(aKeys,_1[1]),SETKEY(0 - i,_1[2])})
ELSE
	SET KEY K_SH_TAB TO	//where need
	POP KEYS
ENDIF
RETURN aKeys
**********
FUNC Capitalz(_cf)
LOCAL cRes:=LTRIM(_cf)
RETU PADL( Upper(LEFT(cRes,1))+Lower(Substr(cRes,2)), LEN(_cf))
**********
PROC Waiting(_mess)
ShowButton(_middlerow-2,8,;
	   _middlerow+2,__mcol-9,{'',WAIT_WIND+_mess+'...'},m->_im)
**********
FUNC MENU2(aPrompt,_start,aMsg,cAdd,aKeys)
/*
aPrompt - array of alternatives
_start -  Start element
aMsg - header array
cAdd - additional comment (see Continue())
*/
LOCAL i,_r,aMenu:={},aCol,nLeft, nRight
aMsg:=FT_XTOY(aMsg,'A')

PUSH KEYS COLOR _MenuColor
IF !EMPTY(aKeys)
	AEVAL(aKeys,{|aEl| m->Main_Keys[aEl[1]]:=aEl[2],;
			   SetKey(1-aEl[1], aEl[3])} )
ENDIF

nLeft:=m->_middlecol-25
nRight:=m->_middlecol+22-LEN(aPrompt[LEN(aPrompt)])
aCol:={nLeft,nRight,nRight}
i:=INT(Len(aMsg)/2)
_r:=m->_middlerow-1-i+LEN(aMsg)
Panel(m->_middlerow-3-i,nLeft-5,_r+4,m->_middlecol+30,aMsg)
ShowMouse()
IF LEN(aPrompt)=2
	IF !EMPTY(cAdd)
		@_r+1,nLeft SAY cAdd
		aCol:={_middlecol-10,_middlecol+10}
	ENDIF
ELSE
	i:=nLeft+LEN(aPrompt[1])
	aCol[2]:=i+INT((nRight-i-LEN(aPrompt[2]))/2)
ENDIF
AEVAL(aPrompt,{|_1,i| AADD(aMenu,DefItem(_R,aCol[i],,,_1))})
i:=BarMenu(aMenu,_start,.T.)
POP KEYS
RETURN i
**********
FUNC Continue(_Mess,_choice)
IF_NIL _choice IS 2
RETU (MSG_MNU_YESNO = 1)
**********
* * * * * *  C A L L E D   F U N C T I O N S
**********
FUNC Sum( _Fld,_cond)
m->__sum := 0
m->_tally:=0
M6_DBEval({||__sum+=&(_Fld),_tally++},_cond)	//Compile - � m6

go _tmr
RETU __sum
**********
FUNC AVER(_fld,_cond)
RETU Sum(_fld,_cond) / m->_tally
**********
FUNC COUN(_cond)
__count := 0
M6_DBEval({||__count++},_cond)
go _tmr
RETU (m->_tally:=__count)
**********
FUNC MGoTo(_ngoto,lMsg)
LOCAL i,res:=.T.,cMsg
IF Between(_ngoto,1, LastRec())
	i:=RECNO()
	GOTO _ngoto
	IF (!EMPTY(m->_fltrcond) .AND. !&_fltrcond ) .OR.;
	   (!EMPTY(OrdFor()) .AND. !&(OrdFor()) )
		cMsg:=NO_FLTR
		res:=.f.
		GOTO i
	ENDIF
	/*
	IF m->__tagNom<>0 .AND. !EMPTY((i:=OrdFor(m->__tagNom)))
		res:=&(i)
	ENDIF
	*/
ELSE
	cMsg:=NO_DPZ
	res:=.F.
ENDIF
IF !EMPTY(lMsg) .AND. !res THEN NFIND(cMsg)
RETU res
**********
PROC InitVar(_var,_a)
_var:=ALLTRIM(_var)
IF 'U' $ Type(_var) THEN Public &_Var
&_Var:=_a
**********
PROC Appe(nC)
LOCAL i
FOR i=1 TO nC DO appe blank
**********

**********
PROC SetBell(_cond)
Set(_SET_BELL,_cond)
**********
PROC SetConf(_cond)
SET(_SET_CONFIRM,_cond)
**********
PROC SetDele(_cond)
SET(_SET_DELETED,_cond)
**********
PROC SetExac(_cond)
SET(_SET_EXACT,_cond)
**********
PROC SetDate(_cond)
Set( _SET_DATEFORMAT,IF(_cond,"dd/mm/yyyy","mm/dd/yyyy"))
_Req:=2
**********
FUNC SetFilt(_cond)
LOCAL _i
_i:=DBFilter()
SET FILTER TO &_cond
IF !EMPTY(_cond) THEN go top
_tally:=M6_RecCount()
IF _tally==0 .AND. !EMPTY(DBFILTER()) THEN _tally:=LASTREC()
_req:=2
RETU _i
**********
PROC SetFUNC(_var,_cond)
Set FUNC _var to _cond
**********
PROC SetInde(_var)
m->_oldind:=IF(PCount()=0,'',_var)
ordListClear(); ordListAdd( m->_oldind )
_req:=2
**********
PROC SetRela(_base,_index,_expr)
EXTE DbRelation
dbUseArea( .T.,, (_base), "_Relation", M_SHARED)
ordListAdd( (_index) )
sele 1
dbClearRel(); dbSetRelation( "_Relation", {|| &_expr}, _expr )
**********
PROC SetPrint(_var)
Set(_SET_PRINTFILE,_var)
**********
FUNC SumLine(nF1,nFx)
LOCAL i,xVal
IF EMPTY(nF1) THEN nF1:=1
IF EMPTY(nFx) THEN nFx:=m->_fc

__Go=0
FOR i:=nF1 TO nFx
	IF VALTYPE(xVal:=FieldGet(i))=='N' THEN __Go+=xVal
NEXT

RETU __Go
*********
FUNC FindMax(NeedMax,_fld,_bFld,lMeter)
LOCAL maxVal,MaxRec,_val,cvt
IF_NIL NeedMax IS .t.
IF EMPTY(_fld) THEN _fld:=_C_F
IF EMPTY(_bFld) THEN _bFld:={|i| IF(VALTYPE(i)=='A',LEN(i), i) }
lMeter:=!EMPTY(lMeter)
MaxVal:=Eval(_bFld,&_fld)
cvt:=VALTYPE(MaxVal)	//because V
CheckEsc(.T.)
MaxRec:=RecNo()
IF lMeter THEN IniSearching()
SCAN
	IF lMeter .AND. !CheckEsc() THEN EXIT
	_val:=Eval(_bFld,&_fld)
	IF (ValType(_val)==cvt) .AND.;
	   ((NeedMax .AND. (MaxVal < _val)) .OR. ;
	   (!NeedMax .AND. (MaxVal > _val)))
		MaxVal:=_Val ; MaxRec:=RecNo()
	ENDIF
ENDSCAN
go maxRec
IF lMeter THEN Meter(3)
RETU MaxVal
*********
PROC SWAP(_rec1,_rec2)
LOCAL _temp
IF !EMPTY(Sx_RLock({_rec1,_rec2}))
	go _rec1
	Scatter()
	_temp:=_scatter
	go _rec2
	Scatter()
	go _rec1
	Gather()
	go _rec2
	_scatter:=_temp
	Gather()
	_req:=2
ENDIF
**********
PROC SwapAll(nSrc,nDst,nMuch,lRev)
LOCAL i
FOR i:=1 TO nMuch
	IF EMPTY(lRev)
		Swap(nSrc++,nDst++)
	ELSE
		Swap(nSrc-- + nMuch, nDst-- + nMuch)
	ENDIF
NEXT
**********
PROC SwapAItems(arr,i,j)
LOCAL x:=arr[i]
arr[i]:=arr[j]
arr[j]:=x
**********
PROC File_Dial(cFile)
LOCAL cMsg:=IF(EMPTY(cFile),READY,F_CREATE+cFile)
SET PRINTER TO
SET(_SET_DEVICE,'')
Meter(3)
IF EMPTY(m->bAutoExec) .AND. !EMPTY(cFile)
	IF Menu2(F_SHOW,1,cMsg)==1 THEN ShowFile(cFile)
ELSE
	NFind(cMsg)
ENDIF
**********
PROC OpFinish(cMsg,xVar)
NFIND(cMsg,xVar,,IF(EMPTY(_timing),'',TimerOff()))	//� Msg.ch
**********
PROC OpReady()
IF !EMPTY(_Timing) THEN OpFinish(READY)
**********
PROC CheckFound(lNfd)
Meter(3)
IF EMPTY(lNfd) .AND. !FOUND()
	GO _tmr
	OpFinish(_STAT_NFD)
ELSE
	OpReady()
ENDIF
**********
FUNC Meter(nStep,cMsg,nCurr,nTotal)
STATIC scr,nLast,nMuch,lWas:=.F.
LOCAL nL:=_middlecol-28, cDev:=SET(_SET_DEVICE)
SET(_SET_DEVICE,'')
IF_NIL nCurr IS m->_tally
DispBegin()

DO CASE
// First - frequent checking
	CASE lWas .AND. nStep=2 .AND. nCurr>=nLast .AND. !EMPTY(m->_lMeter)
		nLast:=nCurr
		IF nMuch==0 THEN nMuch:=KeyCount()	//In Append can occur
		IF !EMPTY(nTotal) THEN nMuch:=nTotal
		nCurr:=MIN(nCurr,nMuch-1)
		@ 13,nL SAY REPL('�',nCurr*57/nMuch-1) COLOR _im // utf-8: '▄'

		SAY_HERE '�' COLOR _HdColor // utf-8: '│'
		@ 15,nL+14  SAY NTRIM(nCurr)+'/'+NTRIM(nMuch) +;
				' ( '+NTRIM(nCurr*100/nMuch)+ ' % ) '+;
				IF(EMPTY(_timing),'',Ntrim(Seconds()-_tOld)+SEC_M);
				COLOR _HdColor

	CASE nStep==1
		lWas:=.T.
		ScrSave(@scr)
		IF !EMPTY(m->_lMeter)		//Bar accepted
			Panel(8,nL-2,17,_middlecol+30,;
				{WAIT_WIND+cMsg+'...'+m->_abort},;
				{_im,_HdColor,_im})
			@ 11,nL SAY '0 %' COLOR _HdColor
			@ 11,_middlecol+24 SAY '100 %' COLOR _HdColor
			@ 13,nL SAY REPL('�',57) COLOR _im // utf-8: '▄'
			@ 15,nL SAY PROCESSED COLOR _im
			nLast:=m->_SX_Step
			nMuch:=IF(EMPTY(nTotal),KeyCount()-KeyNo()+1,nTotal)
		ELSE
			Waiting(cMsg)
		ENDIF

	CASE nStep=3 .AND. lWas
		lWas:=.F.
		IF (EMPTY(_timing) .AND. (nCurr>300)) .OR.;
		   (Seconds() - m->_TOld > 5);
			THEN Tone(440,1)
		ScrRest(scr)
ENDCASE
DispEnd()
SET(_SET_DEVICE,cDev)
RETURN .T.
**********
FUNC IndexCount
LOCAL nRet:=0,i:=1
FOR i:=1 TO Sx_IndexCount()
	nRet+=SX_TagCount(i)
NEXT
RETURN nRet
**********
FUNC TagInfo()
LOCAL aTag:={},i,nCnt
aTag:=Sx_TagInfo(1)
RETURN aTag
**********
FUNC KeyGoTo(nRec)
LOCAL nOld
IF EMPTY(OrdKey())
	nRec:=MGoTo(nRec,.t.)
ELSE
	nRec:=OrdKeyGoto(nRec)
ENDIF
RETU nRec
**********
FUNC NTRIM(nNum)
RETURN LTRIM(STR(nNum))
**********
FUNC NUM_S36(i)
RETURN SUBSTR(SET_OF_M_NO, i, 1)
**********
FUNC S36_NUM(cNum)
RETURN AT(cNum, SET_OF_M_NO)
**********
FUNC Usa2Nation(cStr)
RETURN ChrTran(cStr,m->_USA_Keyboard,m->_My_Keyboard)
**********
FUNC Nation2USA(cStr)
RETURN ChrTran(cStr,m->_My_Keyboard,m->_USA_Keyboard)

**********
FUNC Crc_All(cFldExclude,aFlds)
LOCAL cStr:='',i
IF_NIL cFldExclude IS m->_C_F
IF_NIL aFlds IS m->_dubl
cFldExclude:=UPPER(ALLTRIM(cFldExclude))
AEVAL(aFlds,{|_1|IF(_1==cFldExclude,NIL,cStr:=cStr+XTOC(&(_1)))})
RETURN Ntoc(Crc32(cStr), 16, 8, '0')
**********
FUNC Compress(cStr,lArr)
LOCAL xCopy:=cStr, nLen, cType:= ValType(cStr)
IF (cType $ "CM")
	nLen:=LEN(cStr)
	IF !EMPTY(lArr) .OR. (nLen >= 256) .OR. Continue(TOO_SHORT)
/*
		xCopy:= Space(nLen + 257)
		cStr:= Sx_Comp1(cStr, xCopy, nLen)
		xCopy:= L2Bin(nLen) + Left(xCopy, cStr)
*/
*		xCopy:=CharPack(cStr)

	ENDIF
ELSEIF (cType = "A")
	xCopy:={}
	AEVAL(cStr,{|_1|AADD(xCopy,Compress(_1,.T.))})
ENDIF
RETURN xCopy
**********
FUNC Decompress(cStr)
LOCAL xCopy:= cStr, cType:= ValType(cStr)
IF (cType $ "CM")
/*
	xCopy:= Space(Bin2L(Left(cStr, 4)))
	cStr:= SubStr(cStr, 5)
	Sx_Decomp1(cStr, xCopy, Len(cStr))
*/
*	xCopy:=CharUnPack(cStr)
ELSEIF (cType = "A")
	xCopy:={}
	AEVAL(cStr,{|_1|AADD(xCopy,DeCompress(_1))})
ENDIF
RETURN xCopy
**********
PROC ShowNum(nVal,cMsg)
Nfind(nVal,,,cMsg)
**********
PROC Cdd(cWhere)
*Go to the directory, regardless of the disc
StripRight(@cWhere,'\')
ChDisk(cWhere)
ChDir(cWhere)

**********
FUNC For(xFrom,xTo, bEval, bFor)
LOCAL i,xRet
IF_NIL bFor IS {||.T.}
bFor:=Compile(bFor)
bEval:=Compile(bEval)
FOR i:=xFrom TO xTo
	IF Eval(bFor, i) THEN xRet:=Eval(bEval,i)
NEXT
RETURN xRet
**********
FUNC While(clCond,bEval,cFor,lBase)
LOCAL xRet
IF_NIL cFor IS '.T.'
cFor:=Compile(cFor)
clCond:=Compile(clCond)
bEval:=Compile(bEval)
WHILE EVAL(clCond)
	IF EVAL(cFor) THEN xRet:=Eval(bEval)
	IF !EMPTY(lBase) THEN SKIP
END
RETURN xRet
**********
FUNC ROUNDIT(nNumber, nPlaces)
IF_NIL nPlaces IS 0
RETURN IF(nNumber < 0.0, -1.0, 1.0) * ;
       INT( ABS(nNumber) * 10 ^ nPlaces + 0.50 + 10 ^ -12 ) / 10 ^ nPlaces
**********
FUNC TypeCompatible(t1,t2)
RETURN (t1==t2 .OR. (t1 $ 'NFV' .AND. t2 $ 'NFV') .OR. ;
       (t1 $ 'CMV' .AND. t2 $ 'CMV'))
**********
FUNC Preproc(cExp)
LOCAL	i,j,jr,cCmd,cFcmd,cPar

cExp:=Sx_SlimFast(ALLTRIM(cExp))	//SlimFast not trim the last space

FOR i:=1 TO LEN(m->_aCommand)
	cFcmd:=m->_aCommand[i,1]
	cCmd:=IF( (j:=AT('<',cFcmd))=0,cFcmd,LEFT(cFcmd,j-1) )
	IF IsLefts(cExp,UPPER(cCmd)) THEN EXIT
NEXT
IF i<=LEN(m->_aCommand)	//found
	jr:=AT('>',cFcmd)
	cPar:=IF(jr==0,'',SUBSTR(cFcmd,j,jr-j+1))	//<x>
	cFcmd:=m->_aCommand[i,2]	//resultat
	cExp := ALLTRIM(IF( EMPTY(cPar), cFcmd,;
				 StrTran(cFcmd,cPar,SUBSTR(cExp,LEN(cCmd)+1)) ))

	IF FT_NOOCCUR('(',cExp) < FT_NOOCCUR(')',cExp)
		cExp:=StripRight(cExp,')')
	ENDIF
ENDIF

* Check the predefined replacements
cPar:=Exclude(cExp,' ')
DO CASE
	CASE '{^' $ cExp	//format VFP
		j:= AT('{^',cPar)
		jr:=AT( '}', SUBSTR(cPar,j+2))
		IF Between(jr,9,11)	//will not convert datetime
			cFcmd:=SET(_SET_DATEFORMAT)
			SET DATE JAPAN
			cCmd:=CTOD(SUBSTR(cPar,j+2,jr-1))
			SET(_SET_DATEFORMAT, cFcmd)
			cExp:= LEFT(cPar,j-1)+;
			       'CTOD("'+DTOC(cCmd)+'")'+;
			       SUBSTR(cPar,j+2+jr)
		ENDIF
ENDCASE

RETURN cExp
**********
FUNC WaitKey(_time)
LOCAL key,keyBlock,_timeBegin:=Seconds(),_oldAlt:=-1
IF PCount()=0
	_time:=-1
ELSE
	IF _time=0 THEN _time:=36000	// 10 hours for waiting
	ShowMouse();ShowMouse()
ENDIF
m->_ms:=0
DO WHILE .T.
	ShowMouse()
	IF (key:=inkey(0.01, 254))#0 .OR.  (Seconds()-_timeBegin > _time)
		DO CASE
		CASE (key=K_F1)
			key:=ProcName(2)
			IF 'READMODAL' $ key
				key:=ProcName(3)
			ELSEIF ('ACH' $ CalledFrom()) .AND. !EMPTY(m->_Hlp)
				key:=m->_hlp
			ENDIF
			HELP(key)
		CASE (key=K_ALT_F10)
			BliRun()
		CASE ( (keyBlock := SetKey(key)) <> NIL )
			Eval(keyBlock)

		CASE key==K_LBUTTONDOWN
			WHILE MLeftDown()
				Inkey()
			ENDDO
			m->_ms:=1
			IF MouseY()==m->__mrow
				key:=Int(MouseX()/8)
				FT_PutKey(IF( (_OldAlt:=Altf())=0,;
				     IF(key=0,K_F1,-key),;
				     -40 + _oldalt*10 - key))
			ELSE
				RETU K_ENTER
			ENDIF

		CASE key==K_RBUTTONDOWN
			m->_ms:=2
			WHILE MRightDown()
				Inkey()
			ENDDO
			RETU K_ESC

		CASE key=K_RBUTTONUP .OR. key=K_LBUTTONUP

		CASE (key=1001)
		OTHER
			IF _time>0 THEN HideMouse()
			RETU key
		ENDCASE
		_TimeBegin:=Seconds()	// Something is pressed
	ENDIF

	IF _time>0 .AND. NextKey()=0 .AND. ((key:=KbdStat()) # _OldAlt)
		 Fkeys(_OldAlt:=key)
	ENDIF
ENDDO
**********
PROC Panel(nTop,nLeft,nBottom,nRight,aMess,aColor,nBottomBord)
/*
 Draw 3D panel.

 Example:
	Panel(10,10,16,69,'Write error !',AlarmColor)
*/
IF_NIL nBottomBord IS 1
IF ValType(aColor)=='C' THEN;
	aColor:=SplitLine(aColor)
IF ValType(aMess)=='C' THEN;
	aMess:=SplitLine(aMess)
aColor:=Ext_Arr(aColor,3,SetColor())
HideMouse()
ShowButton(nTop++,nLeft,nBottom,nRight,,aColor[1])
AEVAL(aMess,{|_1|DevPos(nTop++,nLeft+1),DevOut(PADC(_1,nRight-nLeft-1),aColor[2])})
DownButton(ShowButton(nTop,nLeft+1,nBottom-nBottomBord,nRight-1,,aColor[3]))
ShowMouse()
************
PROC WINDOW(_x01,_y01,_x02,_y02,_s,_Mess)
/*
 _S Message appears on frame
A simplified version
*/
LOCAL	_wide:=_y02-_y01
BoxShadow(_x01,_y01,_x02,_y02,7,'�ͻ���Ⱥ ' ) // utf-8: '╔═╗║╝═╚║ '
_s:=LEFT(_s,_wide--)
@ _x01,_y01+1+Centr(_s,_wide) say _s
**********
PROC BoxShadow(_x01,_y01,_x02,_y02,_ColorBorder,_box,_colorBox)
DispBegin()
IF !Empty(_ColorBorder)
	DbgShadow(_x01, _y01, _x02, _y02, _ColorBorder)
ENDIF
DispBox(_x01,_y01,_x02,_y02,_box,_ColorBox)
DispEnd()
**********
PROC Rename(fSrc,fDst)
FERASE(fDst)
FRENAME(fSrc,fDst)
**********
FUNC FileSize(Fname,lNoMsg)
LOCAL nH, nSize:=-1

IF  (nH:=Fopen(Fname,64))>0
	nSize:=Fseek(nH,0,2)
	FClose(nH)
ELSEIF EMPTY(lNoMsg)
	NFind(PRV_NOMEMO+Fname)
ENDIF
RETURN nSize
***********
FUNC Aktion(symbol)
LOCAL res//:=.F.
DO CASE
CASE Empty(symbol)
	res:=NIL
CASE ValType(symbol)=='B'
	res:=Eval(symbol)
CASE IsSuchProc(symbol) .AND. (Substr(symbol,-1) # ')')
	res:=&symbol()
OTHER
	res:= &symbol 	// any func
ENDCASE
RETURN res
**********
FUNC CurrentDir()
RETURN Chr(Name_disk())+':'+PATH_DELIM+CurDir()
**********
PROC SaveAllKeys(anKeys,color)
LOCAL nLen,i,scr
ScrSave(@scr)
// SetKey
IF EMPTY(anKeys)
	AADD(_pushFKeys,{})

	nLen:=Len(_pushFKeys)
	FOR i:=-39 to -1
		AADD(_Pushfkeys[nLen],SetKey(i,NIL))
	NEXT
	anKeys:=Base_M_Keys
ENDIF
//names
AADD(_PushKeys,{ACLONE(m->Main_keys),ACLONE(m->Alt_Keys),;
		ACLONE(m->Ctrl_Keys),ACLONE(m->Shift_Keys),scr,SetColor(color)})

m->Main_keys:=anKeys
Afill(m->Ctrl_keys,'')
Afill(m->Alt_keys,'')
Afill(m->Shift_keys,'')

**********
PROC RestoreAllKeys(lNoFuncs)
LOCAL i,nLen
nLen:=Len(_PushFkeys)
IF EMPTY(lNoFuncs) .AND. !EMPTY(nLen)
	FOR i:=-39 to -1
		SetKey(i,_PushFkeys[nlen][i+40])
	NEXT

	Asize(_pushFKeys,nlen-1)
ENDIF

IF (nLen:=Len(_Pushkeys))<>0
	m->Main_keys:=ACLONE(_PushKeys[nlen,1])
	m->Alt_keys:=ACLONE(_PushKeys[nlen,2])
	m->Ctrl_keys:=ACLONE(_PushKeys[nlen,3])
	m->Shift_keys:=ACLONE(_PushKeys[nlen,4])
	ScrRest(_PushKeys[nLen,5])
	SetColor(_PushKeys[nLen,6])

	Asize(_PushKeys,nlen-1)
ENDIF
**********
PROC Fkeys(_alt)
LOCAL _i:=1,keys,_r,_c
HideMouse()
SavePos()
_alt:=ALTF()
DO CASE
  CASE EMPTY(_alt)
	keys:=m->Main_Keys
	keys[1]:=_MSG_F1

  CASE _alt=1	//Alt_Pressed
	keys:=m->Alt_keys
	keys[10]:=_MSG_AF10

  CASE _alt=2	//Ctrl_Pressed
	keys:=m->Ctrl_keys
  OTHER
	keys:=m->Shift_keys
ENDCASE
DevPos(m->__mrow,0)
Aeval(Keys,{|el| DevOut(TRANS(_i++ % 10,"9"),"W+/n"),;
		 DevOut(pad(IF(ValType(el)=='B',Eval(el),el),7),"n/bg")})
RestPos()
ShowMouse()
**********
FUNC Parce(cStr,cTest,cBefore,cAfter)
/*
If the string contains cStr cTest, then the corresponding substrings
cStr written to the  reference variables cBefore, cAfter.
Otherwise cBefore:=cStr, cAfter:=''
Returns position of cTest.
*/
LOCAL i:=AT(cTest, cStr)
IF i>0
	cBefore:=LEFT(cStr,i-1)
	cAfter :=SUBSTR(cStr,i+LEN(cTest))
ELSE
	cBefore:=cStr
	cAfter:=''
ENDIF
RETURN i
**********
FUNC SplitLine(cStr)
LOCAL aRes:={},cBefore
WHILE Parce(cStr,',',@cBefore,@cStr)<>0
	AADD(aRes,cBefore)
END
AADD(aRes,cBefore)
RETURN aRes
**********
PROC StripRight(cStr,cRght)
LOCAL nL:=LEN(cRght)
IF SUBSTR(cStr, -nL ) == cRght THEN cStr:=Strip(cStr,nL)
**********
FUNC RealFldName(cDest)
IF PAD(cDest,11) $  'ShowVaried( ShowForced('
	Parce(Substr(cDest,12),',',@cDest)
ENDIF
RETURN cDest
**********
FUNC BliRun(process, cmd_stdin)
LOCAL cursor,out:=space(0), error:=space(0),scr, _r, _c
IF_NIL cmd_stdin IS ''
IF_NIL process IS GETE("COMSPEC")
ScrSave(@scr)
SavePos()
Scroll() ; DevPos(0,0)
cursor:=SetCursor(1)
COMMIT
BEGIN SEQU
	SysCmd(process, cmd_stdin, @out, @error)
*	__run(process)
END
__KeyBoard()
SetCursor(cursor)
RestPos()
ScrRest(scr)
SetBlink(.F.)	// somehow spoil
RETURN error
**********
// For connection of ONIDLE
PROC TimeShow()
STATIC oldTime
LOCAL cT
IF (cT:=Time())<>oldTime
	Out(0,72,oldTime:=cT,m->_bm)
ENDIF
**********
FUNC GetWinClip()
LOCAL cBuf:=GetClipBoardData(), i:=0

IF LEN(cBuf)>0
	IF m->_LCnvWClip THEN cBuf:=AnsiToOem(cBuf)
	IF ASCAN(m->_ClipWText, cBuf)=0 THEN A_INS(m->_ClipWText, cBuf)
ENDIF

IF !EMPTY(m->_ClipWText)
	IF (LEN(m->_ClipWText) > 1) .AND. m->_ClipWChoice
		i:=HistClip(m->_ClipWText)
	ENDIF
	IF i<>0 THEN cBuf:=m->_ClipWText[i]
ENDIF

RETURN cBuf
**********
PROC SetWinClip(xVar)
xVar:=TRIM(FT_XTOY(xVar,"C"))
IF m->_LCnvWClip THEN xVar:=OemToAnsi(xVar)
SetClipBoardData(xVar)
**********
FUNC GetClipboard()
LOCAL xRes,i:=1, aClip:={}
IF !EMPTY(m->_ClipText)
	IF (LEN(m->_ClipText) > 1) .AND. m->_ClipChoice
		AEVAL(m->_ClipText,{|_1| AADD(aClip,PAD(FT_XTOY(_1,'C'),60)+ ;
					' ('+VALTYPE(_1)+ ')' ) } )
		i:=HistClip(aClip,.T.)
	ENDIF
	IF i<>0 THEN xRes:=m->_ClipText[i]
ENDIF
RETURN xRes
**********
FUNC HistClip(aClip,lInClip)
m->_lOwn:=!EMPTY(lInClip)	//Call sign GetClipboard
RETURN ForAch(10,USE_HISTORY,aClip,1,'H1')
**********
FUNC Compile(cBlock)
ErrorBlock({|e|Break(.T.)})	//Due to an error of nested blocks
IF_NIL cBlock IS ".T."
BEGIN SEQU
	cBlock:=&("{||"+ ALLTRIM(cBlock)+"}")
// raise break if not C
END
ErrorSys()
RETURN cBlock
**********
PROC MainUse(lMode,lIndex)
// lMode = (Shared,Excl)
USE
IF !EMPTY(m->_cPsw) THEN Sx_SetPass(m->_cPsw,1)
dbUseArea( .F.,, (m->_base), "_mBase", lMode)
IF !EMPTY(lIndex)
	OrdListAdd( m->_Indexfile )
*	IF FileExist(@__CdxName) THEN ordListAdd(m->__CdxName)
ENDIF
**********
FUNC SpaceString(_v,_drb)
LOCAL _dbfc,_s,cPict
IF PCount()=1 THEN _drb:=SET(_SET_DECIMALS)
IF ABS(_v)< 10^-_drb .AND. _v#0
	_dbfc:=STRTRAN(FT_D2e(_v,_drb),'E',' E')
ELSE
	cPict:="9 999 999 999 999 999"
	IF Int(_v)#_v THEN cPict+='.'+REPL('9',_drb)

	_dbfc:=LTRIM(TRANSF(_v,cPict))
	IF '*' $ _dbfc
		_dbfc:=STRTRAN(FT_D2e(_v,_drb),'E',' E+')
	ENDIF
ENDIF
RETU _dbfc
**********
FUNC ClearName()
LOCAL i:=RAT('.',m->_base)
RETURN IF(i==0,m->_base,LEFT(m->_base,i-1))
**********
FUNC ReadBin(_handle,_from,_num,nType)
LOCAL cRet:=SPACE(_num)
Fseek(_handle,_from,nType) ; Fread(_handle,@cRet,_num)
RETU cRet
**********
FUNC IsLefts(cLong,cShort,lNeedTrim)
*Checks for equality cShort and the corresponding left substring of cLong
LOCAL i:=LEN(cShort)
IF IsNILorTRUE(lNeedTrim) THEN cLong:=LTRIM(cLong)
RETURN (LEFT(cLong,i)==cShort)
**********
PROC Out(r,c,xMsg,cClr)
LOCAL _r, _c
SavePos(); DispOutAt(r,c,xMsg,cClr); RestPos()
**********
FUNC A_JOIN(a1, a2)
LOCAL aRet:=Aclone(a1)
AEVAL(a2,{|_1|AADD(aRet,_1)})
RETURN aRet
************
FUNC A_Ins(ar,xVal,nEl)
IF EMPTY(nEl)
	nEl:=1
ENDIF
AADD(ar,NIL)
AINS(ar,nEl)
ar[nEl]:=xVal
RETURN ar
************
FUNC A_Del(ar,nEl)
ADEL(ar,nEl)
ASIZE(ar,LEN(ar)-1)
RETURN ar
************
FUNC A_MaxLen(ar)
LOCAL i:=0
AEVAL(ar,{|_1|i:=MAX(i,LEN(_1))})
RETURN i
**********
PROC ScrSave(_var)
/*
 Saves the contents of the screen and hides the mouse
 Saved in the passed by reference variable _var screen
 can be restored by command 'Clipper Rest Screen From',
 or by steam function ScrRest ()
 Examples :
	ScrSave()
	ScrSave(@current)

 See also SaveEkr() ScrRest()
*/
HideMouse()
IF Pcount()=0
	Save SCRE
ELSE
	_var:=SaveScreen()
ENDIF
**********
PROC ScrRest(_var)
IF Pcount()=0
	Rest Scre
ELSE
	RestScreen(,,,,_var)
ENDIF
ShowMouse()
**********
FUNC Ext_Arr(aName,size,Init)
/*
	Initialization of array by other aName array 
	If array doesn't extsts, then it will created with size 'size'
	and will filled by 'Init'

	If array size less than specified in 'size' , then array will increased
	and new element will filled by 'Init'

	Returns the array.
*/
LOCAL arr,i
IF (ValType(aName)=='A')
	arr:=Aclone(aName)
	Asize(arr,size)
ELSE
	arr:=Array(size)
ENDIF
FOR i:=1 TO size
	IF arr[i]==NIL THEN arr[i]:=init
NEXT
RETU arr
**********
PROC CenterB(_x,_s,_n,ccolor)		//B, not to be confused with TOOLS
/*
*Centers the line of text on screen
_x-Line number
_s-Text
_n-Width of "cell" (default: full screen)
_ccolor - output color (default: current)

See also Centr(),Medi(),Pc()
*/
IF_NIL _n IS m->__mcol
_s:=LEFT(_s,_n)
@ _x,Centr(_s,_n)  Say _S color cColor
**********
FUNC Centr(_s,_n)
/*
Line center of text
_s-string
_n-Width of "cell" (default: full screen)

See also Center(),Medi(),Pc()
*/
IF EMPTY(_n) THEN _n:=m->__mcol
RETU MAX(0,(_n-Len(_s))/2)
************
Func ReadFromFile(_handle,_from,_num)
/*
 Read _num bytes by _from position from file with _handle descriptor
 Returns the string

 Epample : reads type from database
	Handle:=Fopen('base',64)
	If ReadFromFile(handle,0,1)==chr(245)
		NFind('this is FoxPro database with memo-filed.')
	ENDIF

 See also WriteToFile(),FreadLn()
*/

Fseek(_handle,_from,0)
RETU FreadStr(_handle,_num)
**********
FUNC Rand (nStart)
/*
 Returns a sequence of pseudo-random numbers from 0.00 to 1.00
 If nStart parameter is specified, then then the sequence begins again.
 From each nStart always returns the same sequence.
 Example:
	? Rand(seconds()) - first element
	While !Waitkey(3)<>xbeK_ESC
		? Rand()
	end
*/

static r_iy:=100001
IF !Empty(nStart) THEN r_iy:=nStart+100000
r_iy = r_iy * 125
r_iy = r_iy - int(r_iy/2796203) * 2796203
RETURN  (r_iy/2796203.0)

**********
FUNC RandomScope(nMin,nMax)
LOCAL n1,nDigits
IF nMin>nMax 
	n1:=nMax
	nMax:=nMin
	nMin:=n1
ENDIF
nDigits:=LenNum(nMax)
n1:=INT(Rand()*10^nDigits)
IF n1<nMin
	WHILE n1 < nMin DO n1+=(nMax-nMin)
ELSEIF n1>nMax
	WHILE n1 > nMax DO n1-=(nMax-nMin)
ENDIF
RETURN n1
**********
FUNC DTOC8(date)
LOCAL cRet,cCent:=__SETCENTURY(.F.)
cRet:=DTOC(date)
__SETCENTURY(cCent)
RETURN cRet
#IFNDEF ENGLISH
************
FUNC SayData(data)
/*
	Returns string as 01 January 1995
*/
local Cmth:=Cmonth(data)
RETURN  NTRIM(day(data))+"'th "+;
	Cmth+' ')+;
	NTRIM(Year(data))

/* Russian
RETURN  NTRIM(day(data))+' '+;
	IF(SUBSTR(Cmth,-1)=='т', Cmth+'а ', LEFT(Cmth,Len(cmth)-1)+'я ')+;
	NTRIM(Year(data))+ ' года'
*/
#ENDIF
**********
FUNC ChrTran(c1,c2,c3)
LOCAL cRet:='',i,cSym,nPos
FOR i:=1 TO LEN(c1)
	cSym:=SUBSTR(c1,i,1)
	IF (nPos:=AT(cSym,c2))<>0
		cRet+=SUBSTR(c3,nPos,1)
	ELSE
		cRet+=cSym
	ENDIF
NEXT
RETURN cRet
**********
PROC Hilite(_color,_front,_back)
* Defines the highlight, and the inverse of the highlight color, based on the current color
* returns them in reference variables _front,_back

LOCAL _lft

_back:=SUBSTR(_Color,AT("/", _color) + 1)
_lft:=LEFT(_back,IF(Substr(_back,2,1) $ '+*, ',1,2))

IF !('*' $ Substr(_back,2,2))
	_front:=_lft+'+/'+_lft
	_back:='N/'+_lft
ELSE
	_front:='W/'+_back
	_back:='n/'+_back
ENDIF
**********
FUNC CalledFrom()
LOCAL _i:=2,_s:='',_ss

WHILE !Empty((_ss:=ProcName(_i++)))
	_s+=_ss+','
END
RETU _S

**********
FUNC PADJ(cStr, cJust, cFill, nLen)
LOCAL _i
IF_EMPTY nLen IS LEN(cStr)
IF EMPTY(cJust)
	_i:=ForAch(10,_MSG_A_JUSTH,_MSG_A_JUSTA)

	IF  _i <>0
		cJust:=SUBSTR('LCRJEU',_i,1)
	ELSE
		RETURN cStr
	ENDIF
ELSE
	cJust:=UPPER(cJust)
ENDIF
cStr:=ALLTRIM(cStr)
DO CASE
	CASE cJust=='L'
		cStr:=PADR(cStr,nLen,cFill)
	CASE cJust=='C'
		cStr:=PADC(cStr,nLen,cFill)
	CASE cJust=='J'
		cStr:=CharSpread(cStr,nLen,cFill)
	CASE cJust=='E'
		cStr:=Expand(cStr,1,cFill)
	CASE cJust=='U'
		cStr:=CharOne(cFill,cStr)
	OTHER //n-r, just PAD
		cStr:=PADL(cStr,nLen,cFill)
ENDCASE
RETURN cStr
