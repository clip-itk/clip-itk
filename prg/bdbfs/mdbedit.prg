/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "dbedit.ch"
#include "common.ch"
#include "inkey.ch"
#include "bdbfmsg.ch"

#define _ptr _BdbfBrow:ColPos
#translate Stable() => IF !_bdbfbrow:Stable; _bdbfbrow:ForceStable();ENDIF
*#define Stable() _bdbfbrow:ForceStable()
#define ClearVScroll() FOR i:=_tp2+_h to bottom-1 ;  @ i,r_bord say SCROLL_FILL; NEXT
#define ClearHScroll() @ b_Bord,l_1 Say _Sp
#define ShowAlt()  IF _OldAlt#Altf() ; Fkeys(_OldAlt:=Altf()) ; ENDIF

**********
PROC Cdbedit(top,left,bottom,right,columns,userfunc,;
		 colheaders,winheader,aPictures,nFreeze,aWidths)
MEMVAR _BdbfBrow,_bm,_cm,_MINS
LOCAL l_1:=left+1,nMaxColumn,oTbc,cScr,nVs
LOCAL i, rc,  column, baction, ;
	_length:=bottom-top-4, _wide:=right-l_1,;
	l_Bord:=Left-1,r_bord:=Right+1,t_bord:=top-1,b_Bord:=bottom+1,;
	_r,_c,_h:=1,_oldrow:=0,_oldCol,_mox,_moy,_ms,_oldALt:=0,KeyPressed:=.F.,;
	_fc:=LEN(Columns),_lr,_tp1:=top+1,_tp2:=top+2,;
	_nkey:=0,rec_no:=RECNO()

LOCAL _sp:=Repl(SCROLL_FILL,_wide),;
	tbKey:={{K_DOWN,{||_BdbfBrow:down()}		},;
		{K_UP,{||_BdbfBrow:up()}  		},;
		{K_PGDN,{||_BdbfBrow:pagedown()}	},;
		{K_PGUP,{||_BdbfBrow:pageup()}		},;
		{K_CTRL_PGDN,{||_BdbfBrow:gobottom(),__KeyBoard(_EMP)}	},;
		{K_CTRL_PGUP,{||_BdbfBrow:gotop()}	},;
		{K_LEFT,{||_BdbfBrow:left()}		},;
		{K_RIGHT,{||_BdbfBrow:right()}		},;
		{K_CTRL_RIGHT,{||_BdbfBrow:panright()}	},;
		{K_CTRL_LEFT,{||_BdbfBrow:panleft()}	},;
		{K_CTRL_HOME,{||_BdbfBrow:panhome()}	},;
		{K_CTRL_END,{||_BdbfBrow:panend()}	},;
		{K_END,{||_BdbfBrow:end()}		},;
		{K_HOME,{||_BdbfBrow:home()}		},;
		{K_TAB,{||IF(_oldCol=m->_fc,_BdbfBrow:panhome(),_Bdbfbrow:right())}},;
		{K_SH_TAB,{||IF(_oldCol=1,_BdbfBrow:panend(),_Bdbfbrow:left())}},;
		{K_F1,{||Help()}			},;
		{0,{||_BdbfBrow:ForceStable()}	}}


IF_NIL aPictures IS {}
IF_NIL aWidths IS {}
PRIVATE _BdbfBrow,_c_f
//  ������� ��������� ��ꥪ� TBROWSE:
_BdbfBrow:= tbrowseNew(top,left,bottom,right)
_BdbfBrow:goTopBlock    := {|| DbGoTop() }
_BdbfBrow:goBottomBlock := {|| DbGoBottom() }
_BdbfBrow:skipBlock     := {|n| Skipper(n) }
_BdbfBrow:headSep       := '���'
_BdbfBrow:colSep        := ' �'
_BdbfBrow:colorSpec     := SetColor()

// ��ந� ��ꥪ�� - �⮫��� � ������塞 � ���������� ��ꥪ� TBROWSE:
nMaxColumn:=MIN(_Fc,m->_nBrowMaxField)
ASIZE(colHeaders,nMaxColumn)
ASIZE(aPictures,nMaxColumn)
ASIZE(aWidths,nMaxColumn)
FOR i:= 1 TO nMaxColumn
	#IFDEF ENGLISH
		IF Columns[i]>'z' THEN Columns[i]:=''
	#ENDIF
	IF !empty(columns[i])
		IF EMPTY(_c:=colheaders[i]) THEN _c:=columns[i]
		oTbc:=tbColumnNew(_c,Compile(columns[i]))
		oTbc:picture:=aPictures[i]
		oTbc:width:=aWidths[i]
		oTbc:ColorBlock:={||IF(Deleted(),{4,5},{1,2}) }
		_BdbfBrow:AddColumn(oTbc)
		_h:=Max(_h,FT_NOOCCUR(';',_c,.F.)+1)
	ENDIF
NEXT
IF !EMPTY(nFreeze) THEN FreezeFields(nFreeze)

// ��砫쭠� ࠧ�ᮢ�� ��࠭�
Window(t_bord,l_bord,b_bord,r_bord,WinHeader)
@ top+_h,l_bord Say '�'
@ top+_h,r_bord Say '�'
_length:=bottom-top-3-_h

// ��砫쭠� ࠧ�ᮢ�� �஫������
ClearHScroll()
DEVOUT( SCROLL_RIGHT, _cm)
@ b_bord,Left say SCROLL_LEFT+_LF color _cm
@ _tp1+_h,r_bord say SCROLL_UP color _cm
@ bottom,r_bord say SCROLL_DOWN color _cm
                      
Fkeys()

// ������ 横�:
*_bdbfbrow:ForceStable()
Keyb(255)	//�⮡� 1-� ࠧ ���ᮢ���

_lr:=KeyCount()
WHILE .T.
   ShowMouse(); ShowMouse(); ShowMouse()
   WHILE .T.
// �஢��塞 ����稥 �ࠢ���饩 ������ � ����:
	_nKey := INKEY(, 254)
	IF _nKey>1001
		WaitMouse0()
		GetMouseXY()
		cScr:=SaveScreen(_tp1,left,_tp1,right)		//��� ��।������ ���न��� ������
		cScr:=SUBSTR(StrTran(cScr,SUBSTR(cScr,2,2)),1,_mox)
		nVs:=Ft_NoOccur("�",cScr)
		IF SUBSTR(cScr,-1)=="�" THEN nVs--

		IF (i:=_bdbfbrow:Freeze)>0
			IF nVs>i-1
				nVs:=_bdbfbrow:LeftVisible+nVs-1-i
			ENDIF
		ELSE
			nVs:=_bdbfbrow:LeftVisible+nVs-1
		ENDIF

		column:=_ptr-1
		DO CASE
			CASE ( _moy<=bottom ) .AND. _moy>=_Tp2
				DO CASE
				CASE _mox=r_bord
				   IF _moy=_Tp2
					_mox:=K_UP
				   ELSEIF _moy=bottom
					_mox:=K_DOWN
				   ELSE
					KeyGoTo(MIN(1+int((_moy-top-3)*(_lr-1)/_length),_lr))
					_bdbfbrow:refreshAll()
					_mox:=_EMP	//���쪮 �� �� ��������
				   ENDIF

				CASE _mox=l_bord
					_mox:=K_CTRL_HOME
				CASE (_moy=_BdbfBrow:RowPos+_tp1) .AND.;
				     (nVs==column)
					IF _ms=2 .AND. SELECT()=1
						#IFDEF ENGLISH
						_mox:={K_F10,'D'}
						#ELSE
						_mox:={K_F10,'�'}
						#ENDIF
					ELSE
						_mox=_ENTER
					ENDIF
				OTHER
					_mox:=repl(IF(column<nVs,_RIGHT,_LEFT),abs(column-nVs))+_EMP
					_mox:=_mox+repl(IF(_Moy<_r,_UP,_DOWN),abs(_moy-_r))
				ENDCASE
			CASE _moy=b_bord	//��ਧ.�஫����
				IF _mox==left
					_mox:=_LEFT
				ELSEIF _mox==Right
					_mox:=_RIGHT
				ELSE
					_mox=1+int((_mox-l_bord-2)*nMaxColumn/_wide)
					_mox=repl(IF(_Mox<_ptr,_LEFT,_RIGHT),abs(_mox-_ptr))
				ENDIF
			CASE _moy=t_bord
				_mox=K_F4
			CASE _moy=top
				_mox=K_CTRL_F2
			CASE _moy=_tp1
				_mox:=K_PGUP
			CASE _moy=1 .AND. SELECT()=1
				m->__Menu_Col:=_mox	//� MainMenu() ������
				_mox:=K_F10
			CASE _moy=m->__mrow
				_mox:=Int(_mox/8)
				IF (_OldAlt:=Altf())=0
					_mox:=IF( _mox=9 .AND. _ms=2,;
							K_ALT_X,;
							IF(_mox=0,K_F1,-_mox);
						   )
				ELSE
					_mox:=-40 + _oldalt*10 - _mox
				ENDIF
		ENDCASE
		PlayMacro(_mox)
		LOOP
	ELSEIF _nKey=1001
	ELSEIF _nKey <> 0
		KeyPressed:=.t.
		Out(0,16, 'Ch:'+Str(_nkey,3)+' ', _bm)
		exit
	ELSE
		ShowAlt()
		_nkey:=0
		Stable()
*		IF (KeyPressed .AND. NextKey()=0)
		IF  NextKey(254)=0
			KeyPressed:=.f.
			SavePos()

			@ 0,56 SAY VALType(&(columns[_ptr]))+'  '+;
				  IF(EMPTY(m->_clipText),'  ','C'+ValType(m->_ClipText[1]))+;
				  '  '+dTOC8(DATE())+' '+Time();
				  color _bm

			DevPos(0,0)
			IF LASTREC()=0
				DevOut(EMPTY_BASE,_cm)
			ELSE
				DevOut( PAD(NTRIM(RECNO())+'/'+NTRIM(LASTREC()),15),_bm )
			ENDIF
			RestPos()
		ENDIF
	ENDIF
   ENDDO

   rec_no:= recno()
   _oldCol:=MIN(Max(_BdbfBrow:ColPos,1),nMaxColumn)	//keyboard  �� �ᥣ�� �ࠢ��쭮
							//ࠡ�⠥� - ���� 65535

   m->_c_f:=m->_Pole[_oldCol]	//�����, �⮡� � SetKey() �뫮
   HideMouse()
   DO CASE

// ��ࠡ�⪠ ࠭�� �����祭��� ������

	CASE (baction:= setkey(_nkey)) # NIL
		eval(baction,ProcName(1))	// ProcName() ��� Help
		_lr:=KeyCount()
		LOOP

// ��ࠡ�⪠ �⠭������ ������ ������樨
	CASE (baction:=Ascan(tbKey,{|elem|_nkey=elem[1]}))<>0
		eval(tbKey[baction,2])

	CASE _nkey==K_ALT_PGDN .OR. _nkey==K_ALT_PGUP
		__KeyBoard(IF(_nkey==K_ALT_PGDN,_PGDN,_PGUP)+;
				     _EMP+REPL(_UP,_bdbfbrow:rowpos-1))

	CASE TestMacro(_nKey,1)	//����� �믮������

	OTHER
// ��ࠡ�⪠ �᪫��⥫��� ������

		i:=m->Main_Keys
		rc:=&userfunc.(_oldcol,_nkey)
		m->Main_Keys:=i
		FKeys(_OldAlt:=Altf())

		IF rc == DE_ABORT
			RETURN
		ELSEIF rc == DE_REFRESH .OR. (rec_no <> recno())
			_lr:=KeyCount()
			_bdbfbrow:cargo:= .T.
			_bdbfbrow:refreshall()
			_bdbfbrow:cargo:= .F.
		ELSEIF !EOF()
// "�ᢥ����" ⥪���� ������
			_bdbfbrow:refreshcurrent()
		ENDIF
   ENDCASE

// "�ᢥ����", �᫨ ��६��⨫�� 㪠��⥫�:
   IF NextKey(254)=0
	Stable()
	SavePos()
	IF (column:=_ptr)<=nMaxColumn
		ClearHScroll()
		@ b_bord,l_1+int(((column-1)*(_wide-1))/(nMaxColumn-1)) say SCROLL_MARK color _cm
	ENDIF

	IF (rec_no:=_tp2+_h+int((KeyNo()-1)*_length/(_lr-1)))<>_oldrow
		_oldRow:=rec_no
		ClearVScroll()
		@ rec_no,r_bord say SCROLL_MARK color _cm
	ENDIF
	RestPos()
   ENDIF
ENDDO
**********
// �⠭���⭠� �㭪�� ���室�:

STATIC FUNC Skipper(x)
LOCAL i:=0
IF x>0
	WHILE i<x .AND. !eof()
		DBSKIP(1)
		IF EOF()
			SKIP -1
			EXIT
		ENDIF
		i++
	ENDDO

ELSEIF x<0
	WHILE i>x
		DBSKIP(-1)
		IF BOF()
			IF !EMPTY(m->_BdbfBrow:cargo) THEN m->_BdbfBrow:rowpos:= -i+1	//cargo
			EXIT
		ENDIF
		i--
	ENDDO
ENDIF
RETURN i
