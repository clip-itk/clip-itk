/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
 Генерация меню из ELB.LIB. Слегка упрощенные версии для BDBF
*/

#include 'common.ch'
#include 'inkey.ch'

Memvar __mrow,__mcol,_ms	//global
**********
FUNC MakeMenu(_A_P, _H_P, _Aktions, _M_Title, _M_Row, _M_Col, _H_Row,;
		_Horiz,_NeedBorder, _StepMenu, _MenuChoice,_Color,;
		_Level,_WhenNot,lMain)
LOCAL i,lg,LgMax,HMax,hMin,Smlen,lExact,cColor,adjust,B_row,;
      MenuItems:={},lWhen,_n_p,ch,np1,scr
/*
 АВТОГенерация меню. См. также команду READMENU.

Параметры: (в квадратных скобках - умолчание)
  _A_P - массив Prompt
  _H_P - массив MESS
  _Aktions - массив действий выбора по меню
  _M_Title - заголовок меню ['']
  _M_Row - строка начала меню  [row()+2]
  _M_Col - столбец начала меню, если <0 - центрируется
  _H_Row - строка для Mess [сразу под меню]
  _Horiz - .t.,если меню располагать горизонтально [.t.]
  _NeedBorder - .t.,если нужна рамка вокруг [.t.]
  _StepMenu - промежуток между элементами [1],если <0 - MAX
  _MenuChoice - начальный элемент и элемент выбора
  _Color - Цвет меню {основной,выделенный,подсвеченный,скрытый}
  _Level - Уровень подменю
  _WhenNot - параллельный массив выражений запрета доступа [.f.]


  Только параметр _A_P является обязательным
  Возвращает выбранный элемент меню
  Если тип выбранного элемента в массиве действий - строка,то выполняется
  процедура с таким именем,
  Если тип выбранного элемента в массиве действий - блок кода,то он
  выполняется.
  Если тип выбранного элемента в массиве действий - массив,то строится
  рекурсивно вызываемое подменю на основании элементов массива.

  Символ ~ в элементе меню перед следующей за ним буквой,означает,
  что эта буква будет  использоваться как Hot-Key. По умолчанию таковой
  считается первая буква.

  Пример:
	Doing:={'Продолжить','П~ропустить','Отказаться'}
	MakeMenu(Doing)
*/
lExact:=Set(_SET_EXACT,.t.)
*ScrSave(@scr)

IF !Empty(_Color)
	cColor:=SetColor(IF( ValType(_Color)=='C',;
		_Color,_Color[1]))
ENDIF

IF VALType(_MenuChoice)#'N' THEN _MenuChoice=1

IF VALType(_StepMenu)#'N' THEN _StepMenu=1

IF VALType(_NeedBorder)#'L' THEN _NeedBorder=.T.

IF VALType(_Horiz)#'L' THEN _Horiz=.T.

IF VALType(_M_Col)#'N' THEN _m_col=Col()+2

IF VALType(_M_Row)#'N' THEN _m_row=Row()+2

IF VALType(_M_Title)#'C' THEN _M_Title=''

_n_p=Len(_A_P)	// к-во элементов меню
np1:=_n_p-1

_Aktions:=Ext_Arr(_Aktions, _n_p)

_WhenNot:=Ext_Arr(_WhenNot, _n_p, .F.)	// массив запретов

_H_P:=Ext_Arr(_H_P, _n_p, '')

*
*	Define Length
*

LgMax := SmLen := adjust :=0

FOR  i=1 to _N_P
	Lg=Len(Exclude(_A_P[i],'~'))
	SmLen+=Lg
	LgMax:=Max(Lg,LgMax)
NEXT
LgMax=Min(__mcol-1, MAX(LgMax,Len(_M_Title)))
*
BEGIN SEQUENCE
  IF  _Horiz
	_H_Row=_m_row+1
	IF  _m_col<0		&& надо центрировать
		IF _StepMenu<0  && макс.шаг
			_m_col=2
			_StepMenu=INT((__mcol-2-SmLen)/np1)
		ELSE
			_m_col=INT((__mcol+1-SmLen-np1*_StepMenu)/2)
		ENDIF
	ELSE
		IF _StepMenu<0  && макс.шаг
			_m_col=2
			_StepMenu=INT((__mcol-2-_m_col-SmLen)/np1)
		ENDIF
	ENDIF
	SmLen += np1*_StepMenu

	IF _StepMenu>1
		adjust:=SmLen - (__mcol-2-_m_col)
		IF adjust>0 THEN SmLen-=adjust
	ENDIF

	IF  _NeedBorder
		Window(_m_row-1,_m_col-1,_m_row+1,_m_col+SmLen+1,_M_Title)
	ELSE
		@ _m_row-1,_m_col+Centr(_M_Title,SmLen) say _M_Title
	ENDIF

	hMax:=Min(A_MAXLEN(_H_P), SmLen+1)
	hMin:=_m_col+(SmLen+1-hMax)/2

	FOR i:=1 to _N_P
		lWhen:=_WhenNot[i]
		IF VALTYPE(lWhen)=='C' THEN lWhen:=&lWhen
		AADD(MenuItems,{_m_row,_m_col,_A_P[i],_H_P[i],lWhen})
		_m_col+=(Len(Exclude(_A_P[i],'~'))+IF(adjust-- > 0,_StepMenu-1,_StepMenu) )
	NEXT

  ELSE
	B_Row=Min(_m_row+_N_P*_StepMenu,__mrow-3)

	IF  _m_col<0 THEN _m_col=(__mcol-LgMax)/2

	IF  _NeedBorder
		Window(_m_row-1,_m_col-1,B_row,_m_col+LgMax,_M_Title)
	ELSE
		@ _m_row-1,_m_col+Centr(_M_Title,Lgmax) say _M_Title
	ENDIF

	FOR i:=0 to np1
		lWhen:=_WhenNot[i+1]
		IF VALTYPE(lWhen)=='C' THEN lWhen:=&lWhen
		AADD(MenuItems,{_m_row+i*_StepMenu,_m_col,_A_P[i+1],_H_P[i+1],lWhen})
	NEXT

  ENDIF
END

_MenuChoice:=PROMS(MenuItems,_MenuChoice,_color,_h_row,;
		   hMin, hMax, _Level, lMain )

SET(_SET_EXACT,lExact)
SetColor(cColor)

IF _MenuChoice<>0
	Ch:=_aktions[_MenuChoice]
ENDIF

IF ValType(Ch) $ 'CB' THEN Aktion(ch)
*ScrRest(scr)
RETU _MenuChoice
*
**********
FUNC PROMS(ArrP,current,ArrC,nhRow,nhCol,nhMax,nLevel,lMain)
LOCAL _ff:='',_ff_e,i,j,cp,_k,char,_mox,_moy,aEl,;
      cKey,clr,nlArrp,OldPos
/*
 Обеспечивает меню с возможностью выбора мышкой
 На вход передается n-мерный массив следующей структуры
 {строка,
  столбец,
  Prompt,
  Message,
  признак запрета выбора,обычно .f.
 }

  Current - предпочтительный элемент
  ArrC - массив цветов
  { основной, реверс, подсветка "горячей" буквы, цвет запрещенного элемента
  }
  HelpRow
  Признак смены вертикального меню

 Возвращает выбранный элемент.
*/

#define P_ROW 1
#define P_COL 2
#define P_PROMPT 3
#define P_MESS 4
#define NOSELECT 5
#define HI_CHAR 6
#define HI_POS 7
#define E_Prm(el)  (ArrP[el][P_PROMPT])
#define E_Ms(el)  ArrP[el][P_MESS]
#define E_Sel(el)  ArrP[el][NOSELECT]
#define UsualColor ArrC[1]		//Выгоднее, чем LOCAL
#define ReversColor ArrC[2]
#define HilightColor ArrC[3]
#define HiddenColor ArrC[4]
#define Ch_Attr(row,col,cChar) @ row,col Say cChar color HilightColor

m->__Menu_Row:=m->__Menu_Col:=0
m->__Menu_Prom:=''

nlArrP:=Len(arrP)

DO WHILE E_Sel(Current)
	IF ++Current>nlArrP THEN Current:=1
ENDDO
oldPos:=Current

FOR i:=1 to nLArrp
	aEl:=ArrP[i]
	j:=AT('~',cp:=aEl[P_PROMPT])
	char:=SUBSTR(cp,IF(j==0,1,j--+1),1)
	_ff+=IF(aEl[NOSELECT], _EMP, Upper(char))

	ArrP[i][P_PROMPT]:=Exclude(cp,'~')
	AADD(ArrP[i],char)
	AADD(ArrP[i],aEl[P_COL]+j)

	IF i=Current
		clr:=2
	ELSEIF aEl[NOSELECT]
		clr:=4
	ELSE
		clr:=1
	ENDIF

	@ aEl[P_ROW],aEl[P_COL] SAY aEl[P_PROMPT] COLOR ArrC[clr]
	IF clr==1 THEN;	//Обычный пункт
		Ch_Attr(aEl[P_ROW],aEl[HI_POS],char)
NEXT
_ff_e:=Nation2Usa(_ff)

DO WHILE .t.
	IF !EMPTY(cKey:=E_Ms(Current))
		@ nhRow,nhCol SAY Padc(cKey,nhMax,'═')
	ENDIF
	cKey:=UPPER(CHR(_k:=WaitKey(0)))
	IF cKey $ _ESC+_ENTER+_DOWN+_UP+_PGDN+_PGUP+_LEFT+_RIGHT+_END+_HOME+_ff+_ff_e

	  DO CASE

		CASE _k=K_ESC
			Current:=0
			EXIT

		CASE _k=K_ENTER .OR. (_k=K_DOWN .AND. !EMPTY(lMain))
			IF _ms=0
				EXIT
			ELSE
				_mox=MouseX() ;_moy=MouseY()
				IF !EMPTY(nLevel) .AND. _moy=1
					KEYBOARD REPL(_ESC, nLevel-1)
					m->__Menu_Col:=_mox
				ELSE
				  FOR i:=1 TO nLArrP
					aEl:=ArrP[i]
					IF !aEl[NOSELECT] .AND. _moy=aEl[P_ROW] .AND. ;
					   BETWEEN(_mox,aEl[P_COL],aEl[P_COL]+len(aEl[P_PROMPT]))
						EXIT
					ENDIF
				  NEXT
				  IF Current=i
					EXIT
				  ELSEIF i<=nlArrP
					Current:=i
				  ENDIF
				ENDIF
			ENDIF

		CASE cKey $ _LEFT+_RIGHT .AND. !EMPTY(nLevel)
			IF nLevel=2
				PlayMacro({K_ESC,_k,K_ENTER})
			ELSE
				KEYBOARD _ESC
			ENDIF

		CASE cKey $ _UP+_LEFT
			IF Current > 1
				Current--
			ELSEIF Set(_SET_WRAP)
				Current:=nLArrp
			ENDIF

		CASE cKey $ _RIGHT+_DOWN
			IF Current < nlArrP
				Current++
			ELSEIF Set(_SET_WRAP)
				Current:=1
			ENDIF

		CASE cKey $ _END+_PGDN
			Current:=nlArrP
			_k:=K_UP	//движение назад (если запрет)

		CASE ckey $ _HOME+_PGUP
			Current:=1
			_k:=K_DOWN	//инициируем движение вперед

		OTHER	//CASE (_k:=AT(cKey,_ff+_ff_e)) <> 0
			Current:=((AT(cKey,_ff+_ff_e) -1) % LEN(_ff))+1
			EXIT
	  ENDCASE

	  IF  E_Sel(Current)
		PlayMacro(_k)
		LOOP
	  ENDIF

	ENDIF
	IF Current<>oldPos
		aEl:=ArrP[oldPos]
		@ aEl[P_ROW],aEl[P_COL] SAY aEl[P_PROMPT] COLOR UsualColor

		Ch_Attr(aEl[P_ROW], aEl[HI_POS], aEl[HI_CHAR])

		aEl:=ArrP[Current]
		@ aEl[P_ROW],aEl[P_COL] SAY aEl[P_PROMPT] COLOR ReversColor

		oldPos:=Current
	ENDIF
	ShowMouse()
ENDDO
IF Current<>0
	aEl:=ArrP[Current]
	m->__Menu_Row:=aEl[P_ROW]
	m->__Menu_Col:=aEl[P_COL]
	m->__Menu_Prom:=aEl[P_PROMPT]
ENDIF
RETURN Current
**********
FUNC DefItem(top,left,bottom,right,prompt)
/*
IF_NIL top IS ROW()
IF_NIL left IS COL()
IF_NIL prompt IS [OK]
IF_NIL color IS m->_MenuColor	//SetColor()
*/
IF_NIL bottom IS top+2
IF_NIL right IS left+LEN(prompt)+3
RETURN {top,left,bottom,right,prompt}
**********
FUNC BarMenu(aMenu,Current,lSaveScreen)

#define ShowCurrent(i)	ShowButton(aItem[1],aItem[2],aItem[3],aItem[4],;
				   CurPrompt,color,,,'')

#define ShowUsual(i)	ShowButton(aItem[1],aItem[2],aItem[3],aItem[4],;
				   CurPrompt,color)

LOCAL	i,ckey,lm:=LEN(aMenu),_my,_mx,firstKeys:='',scr,;
	aItem, color:=m->_MenuColor, aDb, CurPrompt

IF !EMPTY(lSaveScreen) THEN scr:=SaveScreen()

DispBegin()
FOR i:=1 TO lm
	aItem:=aMenu[i]
	CurPrompt:=aItem[5]
	ShowUsual(i)
        FirstKeys+=UPPER(First(IF(ValType(CurPrompt)="A",CurPrompt[1],CurPrompt)))
NEXT
DispEnd()

DO WHILE .T.
	aItem:=aMenu[Current]
	CurPrompt:=aItem[5]
	aDb:=ShowCurrent(Current)
     IF (cKey:=UPPER(Chr(WaitKey(0)))) $ _ESC+_ENTER+_DOWN+_UP+_PGDN+_PGUP+_LEFT+_RIGHT+_END+_HOME+FirstKeys
	ShowUsual(Current)

	IF cKey = _ESC
		Current:=0
		EXIT
	ELSEIF ckey = _ENTER
		IF m->_ms<>0
			BEGIN SEQU
			  _mx:=MouseX()
			  _my:=MouseY()
			  FOR i:=1 TO lm
				aItem:=aMenu[i]
				IF MouseInRegion(aItem[1],aItem[2],aItem[3],aItem[4])
					Current:=i
					KEYB _ENTER
					*BREAK		//Так вдавливается предыдущий
				ENDIF
			  NEXT
			END SEQU
		ELSE
			i:=1
		ENDIF
		IF i <= lm
			DownButton(aDb,0.3)
			EXIT
		ENDIF
	ELSEIF ckey $ _RIGHT+_DOWN
		Current=(Current % lm) +1
	ELSEIF ckey $ _LEFT+_UP
		Current=IF(Current=1,lm,Current-1)
	ELSEIF ckey $ _END+_PGDN
		Current:=lm
        ELSEIF (i:=AT(ckey,FirstKeys))<>0
		Current:=i
		KEYBOARD _ENTER
	ELSE	//ckey $ _HOME+_CTRLPGUP+_CTRLHOME+_CTRLLEFT+_PGUP
		Current:=1
	ENDIF

     ENDIF
ENDDO

IF !EMPTY(lSaveScreen) THEN ScrRest(scr)
RETURN Current
