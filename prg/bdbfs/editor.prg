/*
    Copyright (C) 2001  ITK
    Author  : Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
#include "set.ch"
MEMVAR __mrow,__mcol,_im,_bm,_HdColor,_c_f,_zif,_lWrap
MEMVAR cFld,cTitle,cFooter,lEdit,nrBorder,cPrintHeader	//parameters
**********
FUNC Memo_Edit
LOCAL	TmpFile:='$$BDBF$$.COM',i,_cur:=SetCursor(),;
	cEditor,cData,cOpt,nShift,lSpec,amEd
PARAM cFld,cTitle,cFooter,lEdit,nrBorder,cPrintHeader
IF_NIL m->cFooter IS ''
IF_NIL m->nrBorder IS m->_nMemoWrap
PRIVATE score_row:=__mrow-5,score_col:=__mcol-12, _lWrap:=.T.,;
	lFinish:=.T.,lReload:=.F.
PUSH KEYS COLOR _im
m->Main_Keys:=Memo_M_Keys

IF EMPTY(m->lEdit)
	m->Main_Keys[4]:=''
	m->Main_Keys[5]:=''
	m->Main_Keys[6]:=''
	m->Main_Keys[10]:=''
ENDIF

Fkeys()

IF EMPTY(m->_MemoEditor) .OR. !m->lEdit
	HideMouse()
	Panel(3,1,__mrow-3,__mcol-1,m->cTitle,;
		{m->_im,_HdColor, m->_im},2)
	Center(__mrow-4,m->cFooter,,_HdColor)
	ShowMouse();ShowMouse()
	DO WHILE .T.
		ShowMouse();ShowMouse()
		i:=MemoEdit(m->cFld,6,3,__mrow-6,__mcol-3,m->lEdit,;
			    'FileEditor', m->nrBorder,m->_nMemoTab)
		IF !m->lReload
			cFld:=i
			m->lReload:=.F.
		ENDIF
		IF m->lFinish THEN EXIT
//Произошли изменения конфигурации
		m->nrBorder:=m->_nMemoWrap
	ENDDO
	IF !m->lEdit .OR. LastKey()==K_ESC THEN m->cFld:=NIL
ELSE
	cOpt:=''
	cData:=m->cFld
	nShift:=1
	IF VALTYPE(m->_memoEditor)=='A'
		lSpec:=.T.
		IF (i:=ASCAN(m->_memoEditor,{|x|LIKE(x[1],_c_f)}))==0;
			THEN i:=1
// если не найдено - первый
		amEd:=m->_MemoEditor[i]
		ASIZE(amEd,5)
		cEditor:=amEd[2]
		IF !EMPTY(amEd[3]) THEN;
			cData:=SUBSTR(cData,(nShift:=amEd[3]))

		IF !EMPTY(amEd[4]) THEN cOpt:=amEd[4]
		IF !EMPTY(amEd[5]) THEN TmpFile:=amEd[5]
	ELSE
		cEditor:=m->_MemoEditor
		lSpec:=.F.
	ENDIF
	MemoWrit(TmpFile,cData)
	BliRun(ALLTRIM(cEditor+' '+TmpFile+' '+cOpt))

	cData:=MemoRead(TmpFile)
	m->cFld:=IF( lSpec, LEFT(m->cFld,nShift-1)+cData,;
				cData)
	Ferase(TmpFile)
ENDIF
POP KEYS
SetCursor(_cur)
RETURN m->cFld
**********
FUNC FileEditor(nMode,nRow,nCol)
LOCAL	nKey:=LastKey()

IF nMode=3
	ShowScoreBoard()
	SetCursor(IF(SET(_SET_INSERT),1,3))
	m->lFinish:=.T.
ELSEIF nKey <> K_ESC
	@ 5,5 SAY 'L:'+PAD(nRow,5)+'C:'+PAD(nCol+1,3) COLOR _HdColor
*	@ 5,__mcol-15 SAY 'Code:'+??? COLOR _HdColor
	@ 0,19 SAY Str(nKey,3) COLOR _bm

	DO CASE

		CASE nKey==K_F2
			PrintMemo(m->cFld,m->cPrintHeader)

		CASE nKey==K_F3
			IF GetName(_ZIF,'_Memo_Ext_File') .AND.;
			   TestWriteFile(m->_Memo_Ext_File,'')

				MemoWrit(m->_Memo_Ext_File,m->cFld)
			ENDIF

		CASE nKey==K_F4 .AND. m->lEdit
			IF GetName(_ZIF,'_Memo_Ext_File',FILE_MASK,,,.T.) .AND.;
			   IsFileExist(m->_Memo_Ext_File,'')

				m->cFld:=MemoRead(TRIM(m->_Memo_Ext_File))
				IF EMPTY(m->cPrintHeader) THEN;
					MyRepl(_c_F,m->cFld)
				m->lFinish:=.F.
				m->lReload:=.T.
				RETURN K_CTRL_W

			ENDIF

		CASE nKey==K_F5
			_lWrap:=!_lWrap
			Fkeys()
			RETURN 34
/*
		CASE nKey==K_F6 .OR. (nKey==K_INS .AND. IsShift())
			__KeyBoard(GetWinClip())
			RETURN 32
*/
		CASE nKey==K_F9 .AND. GetMemoVars()
			m->lFinish:=.F.		//перечитать
			RETURN K_CTRL_W

		CASE nKey==K_F10
			RETURN K_CTRL_W

		CASE nKey==K_INS
			Set( _SET_INSERT, !Set(_SET_INSERT) )
			ShowScoreBoard()
			RETURN 32

		CASE (nRow:=ASCAN({  384,    385,  282,  296, K_ALT_B, K_ALT_O,  K_ALT_A,       K_ALT_C, K_ALT_X, K_CTRL_GMINUS  },nKey))#0
				KEYB {'()'+CHR(19),'()','{}'+CHR(19),'[]'+CHR(19),'{||}'+CHR(19)+CHR(19),' .OR. ',' .AND. ','CTOD("//")'+CHR(19)+CHR(19)+CHR(19)+CHR(19),  _ESC, ClipField(8) }[nRow]

		CASE TestMacro(nKey,4)

	ENDCASE
ENDIF
RETURN 0
**********
STATIC FUNC GetMemoVars()
LOCAL	i,Sets
PUSH KEYS COLOR m->_MenuColor
PANEL(7,7,16,__mcol-7,_MSG_A_O_TOP)

Sets:={m->_nMemoTab,m->_nMemoWrap,m->_MemoPrnt}

IF (i:=ReadCycle({{10,10, _MSG_A_O_TAB,'99'  ,},;
		  {12,10, _MSG_A_O_WRAP,'999',},;
		  {14,10, MEM_WIDE_PRT ,'999',}},;
		 Sets,__mrow-5,__mcol-12))	//in aktions
	m->_nMemoTab:=Sets[1]
	m->_nMemoWrap:=Sets[2]
	m->_MemoPrnt:=Sets[3]
ENDIF
POP KEYS
RETURN i
