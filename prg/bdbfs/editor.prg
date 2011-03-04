/*
    Copyright (C) 1998-2004 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
#include "set.ch"
#include "memoedit.ch"
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
		inkey()		//reads extraneus ESC
		IF !m->lReload
			cFld:=i
			m->lReload:=.F.
		ENDIF
		IF m->lFinish THEN EXIT
//Configuration changes was occured
		m->nrBorder:=m->_nMemoWrap
	ENDDO
	IF !m->lEdit .OR. LastKey()==K_ESC;
		THEN m->cFld:=NIL
ELSE
	cOpt:=''
	cData:=m->cFld
	nShift:=1
	IF VALTYPE(m->_memoEditor)=='A'
		lSpec:=.T.
		IF (i:=ASCAN(m->_memoEditor,{|x|LIKE(x[1],_c_f)}))==0;
			THEN i:=1
// If not found - first
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
FUNC FileEditor(nMode,nRow,nCol,oEd)
LOCAL	nKey:=LastKey(), nRes:=ME_DEFAULT, _r,_c, _moy, _mox
STATIC ch
SavePos()
IF nMode=ME_INIT
	IF m->lEdit THEN ShowScoreBoard()
	SetCursor(IF(SET(_SET_INSERT),1,3))
	m->lFinish:=.T.
	oEd:idletime:=0.2
ELSEIF nMode=ME_IDLE
	DispBegin()
	@ 5,5 SAY 'L:'+PAD(nRow,5)+'C:'+PAD(nCol+1,3) COLOR _HdColor
	IF nRow<=LEN(oEd:edbuffer)
		ch := ASC(substr(oEd:edbuffer[nrow],ncol,1))
		@ 5,__mcol-15 SAY 'Code: '+STR(ch, 3) COLOR _HdColor
	ENDIF
	Fkeys(Altf())
	DispEnd()
ELSE
	DO CASE
		CASE nKey==K_F1
			Help('_MEMO_EDIT')
			nRes:=ME_IGNORE

		CASE nKey==K_ESC
			IF nMode==ME_UNKEYX
				nKey:=Menu2(SAVE_AND_EXIT_ALT,1,SAVE_AND_EXIT)
				IF nKey<2
					nRes:=ME_IGNORE
				ELSEIF nKey=2
					oEd:updated:=.F.
					KEYBOARD _ESC	//Further is LastKey() processing
				ELSEIF nKey=3
					nRes:=K_CTRL_W
				ENDIF
			ENDIF

		CASE nKey==K_ALT_X
			oEd:updated:=.F.
			KEYBOARD _ESC	//Prevent repeat
			nRes:=K_ESC

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
				nRes:=K_CTRL_W
			ENDIF

		CASE nKey==K_F5
			_lWrap:=!_lWrap
			nRes:=ME_TOGGLEWRAP

		CASE nKey==K_F6 .OR. (nKey==K_INS .AND. IsShift())
			InsString(oEd, GetWinClip(), .T.)
			nRes:=ME_IGNORE
			__Keyboard(_RIGHT+_LEFT)	//cursor is not set

		CASE nKey==K_CTRL_GMINUS
			InsString(oEd, FT_XTOY(GetClipBoard(), 'C'), .T.)
			__Keyboard(_RIGHT+_LEFT)

		CASE nKey==K_F9 .AND. GetMemoVars()
			m->lFinish:=.F.		//reread
			nRes:=K_CTRL_W

		CASE nKey==K_F10
			nRes:=K_CTRL_W

		CASE nKey==K_CTRL_F10
			InsString(oEd, AsciiTbl(CHR(ch)), .T. )
			__Keyboard(_RIGHT+_LEFT)	//cursor is not set

		CASE nKey==K_INS .AND. m->lEdit
			Set( _SET_INSERT, !Set(_SET_INSERT) )
			ShowScoreBoard()
			nRes:=ME_IGNORE

		CASE nKey==K_CTRL_U .OR. nKey==K_ALT_BS
			oEd:Undo()
			nRes:=ME_IGNORE

		CASE nKey==K_CTRL_2
			nRes:=ME_DATA
			nKey:=Inkey(10)
			IF nKey=K_CTRL_2
				nkey:=0
			ELSEIF nKey=0 .OR. nKey>255
				nRes:=ME_IGNORE
			ENDIF

			oEd:cargo:=nKey

		CASE IsKBMacro(nKey,4)

		CASE nKey=K_LBUTTONDOWN
			GetMouseXY()

			DO CASE
			  CASE Between(_moy,6,__mrow-6) .AND.;
				     Between(_mox,3,__mcol-3)
				ch:=REPL(IF(_Moy<_r,_UP,_DOWN),abs(_moy-_r))+;
				    REPL(IF(_Mox<_c,_LEFT,_RIGHT),abs(_mox-_c))
			  CASE Between(_moy,__mrow-5,__mrow-3)
				ch:= _PGDN
			  CASE Between(_moy,3,5)
				ch:= _PGUP
			  CASE _mox<=2
				ch:=CHR(K_CTRL_A)
			  CASE _mox>=__mcol-2
				ch:=CHR(K_CTRL_F)
			  OTHER
				ch:=_RIGHT+_LEFT
		  	ENDCASE
			KEYB ch

		CASE nKey==K_RBUTTONDOWN
			WHILE mrightdown()
				inkey()
			ENDDO
			KEYBOARD _ESC
			nRes:=K_ESC

	ENDCASE
ENDIF
RestPos()
RETURN nRes
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
