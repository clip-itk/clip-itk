/*
    Copyright (C) 1998-2004 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "dbedit.ch"
#include "common.ch"
#include "inkey.ch"
#include "bdbfmsg.ch"

#define _ptr _BdbfBrow:ColPos
#translate Stable() => IF !_bdbfbrow:Stable; _bdbfbrow:ForceStable(); ENDIF
*#define Stable() _bdbfbrow:ForceStable()
#define ClearVScroll() FOR i:=_tp2+_h to bottom-1 ;  @ i,r_bord say SCROLL_FILL; NEXT
#define ClearHScroll() @ b_Bord,l_1 Say _Sp
#define ShowAlt()  IF _OldAlt#(_nKey:=KbdStat()) ; Fkeys(_OldAlt:=_nkey) ; ENDIF

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
		{K_PGUP,{||IF(Altf()=2,_BdbfBrow:RefreshAll(),_BdbfBrow:pageup())}},;
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
		{K_EMP,{||_BdbfBrow:ForceStable()}	}}


IF_NIL aPictures IS {}
IF_NIL aWidths IS {}
PRIVATE _BdbfBrow,_c_f
//  Создаем экземпляр объекта TBROWSE:
_BdbfBrow:= tbrowseNew(top,left,bottom,right)
_BdbfBrow:goTopBlock    := {|| DbGoTop() }
_BdbfBrow:goBottomBlock := {|| DbGoBottom() }
_BdbfBrow:skipBlock     := {|n| Skipper(n) }
_BdbfBrow:headSep       := '═╤═'
_BdbfBrow:colSep        := ' │'
_BdbfBrow:colorSpec     := SetColor()

// Строим объекты - столбцы и добавляем к экземпляру объекта TBROWSE:
nMaxColumn:=MIN(_Fc,m->_nBrowMaxField)
ASIZE(colHeaders,nMaxColumn)
ASIZE(aPictures,nMaxColumn)
ASIZE(aWidths,nMaxColumn)
FOR i:= 1 TO nMaxColumn
*	IF ('U' $ TYPE(Columns[i])) THEN Columns[i]:=''
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

DispBegin()
// начальная разрисовка экрана
Window(t_bord,l_bord,b_bord,r_bord,WinHeader)
@ top+_h,l_bord Say '╠'
@ top+_h,r_bord Say '╣'
_length:=bottom-top-3-_h

// начальная разрисовка скроллингов

ClearHScroll()
DEVOUT( SCROLL_RIGHT, _cm)
@ b_bord,Left say SCROLL_LEFT+SCROLL_MARK color _cm
@ _tp1+_h,r_bord say SCROLL_UP color _cm
@ bottom,r_bord say SCROLL_DOWN color _cm
Fkeys()
DispEnd()
// Главный цикл:
*_bdbfbrow:ForceStable()
Keyb(260)	//чтобы 1-й раз нарисовать - незначащий код

_lr:=KeyCount()
WHILE .T.
   ShowMouse(); ShowMouse(); ShowMouse()
   WHILE .T.
// Проверяем наличие управляющей клавиши в буфере:
	_nKey := INKEY(0.01, 254)
	IF _nKey>1001
		WaitMouse0()
		GetMouseXY()

		cScr:=ScreenString(_tp1,left)		//Для определения координат нажатия
		nVs:=0
		FOR i:=1 TO _mox-1
			IF SUBSTR(cScr, i, 1)=="╤" THEN nVs++
		NEXT

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
					KeyPressed:=.T.
					exit
				   ENDIF

				CASE _mox=l_bord
					_mox:=K_CTRL_HOME
				CASE (_moy=_BdbfBrow:RowPos+_tp1) .AND.;
				     (nVs==column)
					IF _ms=2 .AND. SELECT()=1
						_mox:={K_F10, _MM_FIELDMENU_HK}
					ELSE
						_mox=_ENTER
					ENDIF
				OTHER
					_mox:=repl(IF(column<nVs,_RIGHT,_LEFT),abs(column-nVs))+_EMP
					_mox:=_mox+repl(IF(_Moy<_r,_UP,_DOWN),abs(_moy-_r))
				ENDCASE
			CASE _moy=b_bord	//гориз.скроллинг
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
				m->__Menu_Col:=_mox	//в MainMenu() анализ
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
		IF  KeyPressed .AND. NextKey(254)=0
			KeyPressed:=.f.
			DispBegin()
			SavePos()

			IF SELECT()=1
				_mox:=	_Ftype[_ptr]+;
					PAD(IF(_FDr[_ptr]<>0,;
						NTRIM(_FLen[_ptr])+'.'+NTRIM(_FDr[_ptr]),;
						_FLen[_ptr]),7)
			ELSE
				_mox:=	DbStruct()[_ptr,2]+;
					PAD(NTRIM(DbStruct()[_ptr,3]),7)
			ENDIF
			@ 0,52 SAY _mox+;
				  IF(EMPTY(m->_clipText),'  ','C'+ValType(m->_ClipText[1]))+;
				  ' '+dTOC8(DATE());
				  color _bm

			DevPos(0,0)
			IF LASTREC()=0
				DevOut("0/0",_cm)
			ELSE
				DevOut( PAD(NTRIM(RECNO())+'/'+NTRIM(LASTREC()),15),_bm )
			ENDIF
			RestPos()
			DispEnd()
		ENDIF
	ENDIF
   ENDDO

   rec_no:= recno()
   _oldCol:=MIN(Max(_BdbfBrow:ColPos,1),nMaxColumn)	//keyboard  не всегда правильно
							//работает - дает 65535

   m->_c_f:=m->_Pole[_oldCol]	//здесь, чтобы в SetKey() было
   HideMouse()
   DO CASE

// Обработка ранее назначенных клавиш

	CASE (baction:= setkey(_nkey)) # NIL
		eval(baction,ProcName(1))	// ProcName() для Help
		_lr:=KeyCount()
		LOOP

	CASE _nKey==K_CTRL_X .AND. IsCtrlShift() .AND. (VALTYPE(&_c_F) $ 'CM')
		__KeyBoard(_ENTER+_DOWN+_CTRLEND)

	CASE _nKey==K_CTRL_LEFT .AND. IsCtrlShift() 
		ChangeCol(_oldcol-1)
		__KeyBoard(_LEFT)

	CASE _nKey==K_CTRL_RIGHT .AND. IsCtrlShift()
		ChangeCol(_oldcol+1)
		__KeyBoard(_RIGHT)

	CASE _nKey==K_CTRL_H
		ColWdt( _oldCol, IF(IsCtrlShift(),;
				    MAX(_Flen[_oldCol],LEN(_Works[_oldCol])),;
				    1 ) )

// Обработка стандартных клавиш навигации
	CASE (baction:=Ascan(tbKey,{|elem|_nkey=elem[1]}))<>0
		eval(tbKey[baction,2])

	CASE _nkey==K_ALT_PGDN .OR. _nkey==K_ALT_PGUP
		__KeyBoard(IF(_nkey==K_ALT_PGDN,_PGDN,_PGUP)+;
				     _EMP+REPL(_UP,_bdbfbrow:rowpos-1))

	CASE TestMacro(_nKey,1)	//Здесь выполнится

	OTHER
// Обработка исключительных клавиш

		i:=m->Main_Keys
		rc:=&userfunc.(_oldcol,_nkey)
		m->Main_Keys:=i
		FKeys(_OldAlt:=KbdStat())

		IF rc == DE_ABORT
			RETURN
		ELSEIF rc == DE_REFRESH .OR. (rec_no <> recno())
			_lr:=KeyCount()
			IF !Mgoto(recno(),.f.) THEN GO TOP
			_bdbfbrow:cargo:= .T.
			_bdbfbrow:refreshall()
			_bdbfbrow:cargo:= .F.
		ELSEIF !EOF()
// "Освежить" текущую запись
			_bdbfbrow:refreshcurrent()
		ENDIF
   ENDCASE

// "Освежить", если переместился указатель:
   IF NextKey(254)=0
	Stable()
	DispBegin()
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
	DispEnd()
   ENDIF
ENDDO
**********
// Стандартная функция перехода:

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
