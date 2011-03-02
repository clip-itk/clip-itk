/*
    Copyright (C) 1998-2004 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "Set.ch"
#include "Inkey.ch"
#include "common.ch"
#include "Getexit.ch"
#include "bdbfmsg.ch"

#define K_UNDO	K_CTRL_U

MEMVAR _NEEDSCROLL,__MCOL,_PTR

// state variables for active READ
STATIC	Updated := .f.,;
	KillRead,;
	BumpTop,;
	BumpBot,;
	LastExit,;
	LastPos,;
	ActiveGet,;
	ReadProcName,;
	_ReadInsert:=.T.,;
	lSame:=.f., nSame, nCrt, aPos
//	_buffer:=''

#define GE_MPOINT		GE_ESCAPE+1000

// format of array used to preserve state variables
#define GSV_KILLREAD		1
#define GSV_BUMPTOP		2
#define GSV_BUMPBOT		3
#define GSV_LASTEXIT		4
#define GSV_LASTPOS		5
#define GSV_ACTIVEGET		6
#define GSV_READVAR 		7
#define GSV_READPROCNAME	8

/***
	ReadModal()
	Standard modal READ on an array of GETs.
*/
FUNC ReadModal( GetList, lCycle, lPassword )
LOCAL get, pos, savedGetSysVars, savedCursor, name, _aSub

PRIVATE _NeedScroll:='FORG' $ ProcName(1) .AND. m->_tv //,;
m->Ctrl_keys[10]:=_MSG_GET_CF10

lCycle:=!EMPTY(lCycle)

IF EMPTY(getList) THEN	RETURN .F.

aPos:={}
AEVAL(GetList,{|_1| AADD(aPos, SaveCoords(_1) ) } )

// preserve state vars	//ClearGetSysVars()
savedGetSysVars:={KillRead,BumpTop,BumpBot,LastExit,;
		  LastPos,GetActive(NIL),ReadVar(""),ReadProcName}
STORE 0 TO LastExit,LastPos
ReadProcName := ""
Stor .f. to KillRead,BumpBot,BumpTop,Updated
//END ClearGetSysVars()

savedCursor:=SetCursor(IF(_ReadInsert,1,3))

// set these for use in SET KEYs
ReadProcName := ProcName(1)

// set initial GET to be read
pos := Settle( Getlist, 0, lCycle )

WHILE ( pos <> 0 )

	// get next GET from list and post it as the active GET
	get := GetList[pos]
	IF !EMPTY(lPassword) THEN get:ColorSpec:="w/w"

//Text PostActiveGet( get )
	name := Upper(get:name)
	_aSub:=get:subscript

	ActiveGet:=get

	IF ( _asub <> NIL )  THEN;
		AEval(_aSub,{|el| name+= "[" + NTRIM(el) + "]" })

	ReadVar( name )
	ShowScoreBoard()
//End PostActiveGet( get )

	// read the GET
	IF ( ValType( get:reader ) == "C" )
		DoMemo(get:reader)
	ELSE
		GetReader( get, lCycle )// use standard reader
	END

	// move to next GET based on exit condition
	pos := Settle( GetList, pos, lCycle )

END


// restore state vars  RestoreGetSysVars(savedGetSysVars)
KillRead := savedGetSysVars[ GSV_KILLREAD ]
BumpTop := savedGetSysVars[ GSV_BUMPTOP ]
BumpBot := savedGetSysVars[ GSV_BUMPBOT ]
LastExit := savedGetSysVars[ GSV_LASTEXIT ]
LastPos := savedGetSysVars[ GSV_LASTPOS ]
GetActive( savedGetSysVars[ GSV_ACTIVEGET ] )
ReadVar( savedGetSysVars[ GSV_READVAR ] )
ReadProcName := savedGetSysVars[ GSV_READPROCNAME ]
//END RestoreGetSysVars(savedGetSysVars)

SetCursor(savedCursor)

RETURN (Updated)


/***
	GetReader()
	Standard modal read of a single GET.
*/
PROC GetReader( get, lCycle )
LOCAL _c,__c

// read the GET IF the WHEN condition is satisfied

get:exitstate:=IF( KillRead,GE_ESCAPE,GE_NOEXIT)

// activate the GET for reading
get:SetFocus()
IF lSame THEN get:pos:=nSame

WHILE ( get:exitstate == GE_NOEXIT )

	// check for initial typeout (no editable positions)
	IF ( get:typeOut ) THEN;
		get:exitstate := GE_ENTER
	// apply keystrokes until exit
	WHILE ( get:exitstate == GE_NOEXIT )
		IF IsKbdEmpty()
		  _c:=get:pos
		  DispBegin()
		  @ 0,63 say TRANSFORM(ASC(SUBSTR(get:buffer,_c)),'@R CODE:999')
		  IF  _NeedScroll
			@ 13,__c:=6+Int((_c-1)*(__MCOL-11)/255)  say SCROLL_MARK color m->_CM
	 	  ENDIF
		  get:Display()
		  DispEnd()
		ENDIF
		ShowMouse()
		GetApplyKey( get, WaitKey(0), lCycle )
		HideMouse()
		IF  _NeedScroll THEN @ 13, __c say '±' // utf-8: '‚ñí'
	END

	// disallow exit IF the VALID condition is not satisfied

	IF !GetPostValidate(get) THEN;
		get:exitstate := GE_NOEXIT
END

// de-activate the GET
get:KillFocus()


/***
	GetApplyKey()
	Apply a single Inkey() keystroke to a GET.

	NOTE: GET must have focus.
*/
PROC GetApplyKey(get, key, lCycle)
LOCAL cKey, _mox,_moy, _cGetBuffer, _cGetType, _nGetCol,;
	lIsField:=('GETF' $ PROCNAME(3))//,_col,_row

ckey:=chr(key)
_cGetBuffer:=get:buffer
_cGetType:=get:type
lSame:=.F.
DO CASE
	CASE TYPE('_aGetKeys')=='A' .AND.;
	     (_mox:=AMSCAN(m->_aGetKeys,1,key))<>0
		EVAL(m->_aGetKeys[_mox,2])

	CASE (_cGetType == "C") .AND. key==K_CTRL_X .AND. IsCtrlShift()
		get:buffer:=IF(_cGetBuffer>='Ä',Nation2Usa(_cGetBuffer),;
			    Usa2Nation(_cGetBuffer)) // utf-8: '–ê'
		get:VarPut(get:buffer)
		get:Changed:=.t.

	CASE (_mox:=ASCAN({K_UP,K_DOWN,K_CTRL_HOME,K_CTRL_END,K_PGUP,K_PGDN,K_F10},key))<>0
		get:exitstate:={GE_UP,GE_DOWN,GE_TOP,GE_WRITE,IF(lCycle,GE_TOP,GE_WRITE),IF(lCycle,GE_BOTTOM,GE_WRITE),GE_WRITE}[_mox]

		IF IsShift()
			lSame:=.T.
			nSame:=get:pos
		ENDIF

	CASE key=K_DEL .AND. IsShift() .AND. lIsField
		KEYBOARD _ESC+cKey+_EMP+_ENTER

	CASE key=K_INS .AND. IsShift()
		InsString(Get,GetWinClip())

	CASE key=K_CTRL_INS
		SetWinClip(_cGetBuffer)

	CASE (_mox:=ASCAN({K_INS,K_HOME,K_END,K_RIGHT,K_LEFT,;
			   K_CTRL_RIGHT,K_CTRL_LEFT,;
			   K_BS,K_DEL,;
			   K_CTRL_T,K_CTRL_Y,K_CTRL_BS,K_CTRL_K,;
			   K_CTRL_GPLUS;
			   },key))<>0
	      EVAL({;
		{||Set( _SET_INSERT, (_ReadInsert:=!_ReadInsert )),ShowScoreboard()},;
		{||get:Home()},;
		{||get:End()},;
		{||get:Right()},;
		{||get:Left()},;
		{||get:WordRight()},;
		{||get:WordLeft()},;
		{||get:BackSpace()},;
		{||get:Delete()},;
		{||get:DelWordRight()},;
		{||get:Home(), get:DelEnd()},;
		{||get:WordLeft(), get:DelWordRight()},;
		{||get:DelEnd()},;
		{||A_INS(m->_clipText,_cGetBuffer)},;
		   }[_mox])

	CASE key==296 .AND. IsShift() .AND. _NeedScroll	//Alt+Shift+"
		KEYB _HOME+'"'+_END+'"'

	CASE IsKbMacro(key, IF(_NeedScroll,2,3))


	CASE key=K_CTRL_GMINUS
		InsString(get, ClipField(8))

	CASE key=K_CTRL_F10
		InsString(get, AsciiTbl(SUBSTR(_cGetBuffer,get:pos)))

	CASE (_cGetType == "L") .AND. (cKey $ " " + L_YES_SET+L_NO_SET)
		InsString(get,IF(cKey==" ",;
				IF(_cGetBuffer $ L_YES_SET,'F','T'),;
				IF(cKey $ L_YES_SET,'T','F');
				))

	CASE (_cGetType == "C") .AND.;
	     (_mox:=ASCAN({K_ALT_U,K_ALT_L,K_ALT_K,K_ALT_Q,K_ALT_Y,K_ALT_J,K_ALT_P},key))<>0
		EVAL({;
		{||get:buffer:=UPPER(_cGetBuffer)},;
		{||get:buffer:=LOWER(_cGetBuffer)},;
		{||get:buffer:=Capitalz(_cGetBuffer)},;
		{||get:buffer:=Usa2Nation(_cGetBuffer)},;
		{||get:buffer:=Nation2Usa(_cGetBuffer)},;
		{||get:buffer:=PADJ(_cGetBuffer)},;
		{||get:buffer:=PROPER(_cGetBuffer)};
		}[_mox])
		get:VarPut(get:buffer)
		get:Changed:=.t.

	CASE ASCAN({K_UNDO,K_ALT_BS,K_ESC},key)<>0
		get:Undo()
		IF ( key == K_ESC ) .AND. ( Set(_SET_ESCAPE) )
			get:exitstate := GE_ESCAPE
		ENDIF

	CASE ( key == K_ENTER )
		IF m->_ms=0
			get:exitstate := GE_ENTER
		ELSE
			GetMouseXY()
			_nGetCol:=get:col
			DO CASE
				CASE _moy ==get:row .AND. ;
				     _mox>=_nGetCol .AND. _mox<=_nGetCol+Len(_cGetBuffer) //buffer
					get:pos:=_mox-_nGetCol+1
					#ifndef __CLIP__
						get:display()
					#endif
				CASE _NeedScroll .AND. _moy=get:row+1 .AND.;
				     _mox>=5 .AND. _mox<=__mcol-5
					get:pos:=1+Int((_mox-5)*254/(__mcol-10))
					#ifndef __CLIP__
						get:display()
					#endif
				CASE (nCrt:=DefPos(_moy,_mox))<>0
					get:exitState := GE_MPOINT

				OTHER
					get:exitstate := GE_ENTER
			ENDCASE
		ENDIF

	CASE ( key == K_SH_TAB ) .OR. ( key == K_TAB )
		PlayMacro(IF(lIsField,;
			{K_CTRL_END,key,K_EMP,K_ENTER},;
			IF( key == K_TAB, K_DOWN,  K_UP));
		)

	CASE (_cGetType == "N") .AND. (cKey $  ".," ) .AND.;
	      get:DecPos<LEN(_cGetBuffer)
		get:ToDecPos()
		get:display()

	CASE lIsField .AND. (key=K_ALT_UP .OR. key=K_ALT_DOWN)
		PlayMacro({K_ESC,key,_EMP,K_ENTER})

	CASE (key >= 1 .AND. key <= 255) .OR. key==K_CTRL_2 .OR. key==K_CTRL_Q

		IF key==K_CTRL_2 .OR. key==K_CTRL_Q
			key:=Inkey(30)
			IF key=K_CTRL_2
				ckey:=chr(0)
			ELSEIF key=0 .OR. key>255
				RETURN
			ELSE
			       cKey:=CHR(key)
			ENDIF
		ENDIF

		InsString(get, cKey)

ENDCASE
***********
STATIC FUNC DefPos(mR,mC)
LOCAL nRes:=0,i,aEl
IF LEN(aPos)>1
	i:=1
	WHILE i<=LEN(aPos)
		aEl:=aPos[i]
		IF (aEl[1]==mR) .AND. Between(mC,aEl[2],aEl[3])
			nRes:=i
			lSame:=.T.
			nSame:=mC-aEl[2]
			EXIT
		ENDIF
		i++
	END
ENDIF
RETURN nRes
***********
STATIC FUNC SaveCoords(get)
LOCAL nr:=get:row, nc:=get:col, nl, cScr, i, cAttr
cScr:=Savescreen(nr,nc,nr,__mcol)
cAttr:=SUBSTR(cScr,2,1)
nl:=1
i:=5
WHILE cAttr==SUBSTR(cScr,i,1)
	nl++
	i+=3
END
RETURN {nr,nc,nc+nl}

/***
	GetPostValidate()
	Test exit condition (VALID clause) for a GET.

	NOTE: bad dates are rejected in such a way as to preserve edit buffer.
*/
FUNC GetPostValidate(get)
LOCAL saveUpdated, changed, valid := .t.

IF ( get:exitstate == GE_ESCAPE ) THEN RETURN .T.

IF Get:BadDate(get)
	get:Home()
	RETURN .f.
END

// IF editing occurred, assign the new value to the variable
IF ( get:changed )
	get:Assign()
	Updated := .t.
END

// check VALID condition if specified

IF ( get:postblock <> NIL )
	saveUpdated := Updated

	// S87 compat.

	valid := Eval(get:postblock , get)

	get:UpdateBuffer()

	Updated := saveUpdated

	IF KillRead
		get:exitstate := GE_ESCAPE	// provokes ReadModal() exit
		valid := .t.
	END

END

// reform edit buffer, set cursor to home position, redisplay
get:Reset()

RETURN valid

/********************
	READ services
*/

/***
	Settle()

	RETURNs new position in array of Get objects, based on

		- current position
		- exitState of Get object at current position

	NOTE RETURN value of 0 indicates termination of READ
	NOTE exitState of old Get is transferred to new Get
*/
static FUNC Settle(GetList, pos, lCycle)
LOCAL exitState := IF( pos == 0, GE_DOWN, GetList[pos]:exitstate )

IF ( exitState == GE_ESCAPE .OR. exitState == GE_WRITE ) THEN RETURN 0

IF ( exitState <> GE_WHEN )
	// reset state info
	LastPos := pos
	BumpTop := BumpBot := .f.
ELSE
	// re-use last exitState, do not disturb state info
	exitState := LastExit
END


/***
	move
*/
DO CASE
	CASE ( exitState == GE_UP ) //.OR. pos>1 .OR. !lCycle
		pos --

	CASE ( exitState == GE_DOWN ) .OR. ( exitState == GE_ENTER )
		pos ++

	CASE ( exitState == GE_TOP )
		pos := 1
		BumpTop := .T.
		exitState := GE_DOWN

	CASE ( exitState == GE_BOTTOM )
		pos := Len(GetList)
		BumpBot := .T.
		exitState := GE_UP

	CASE ( exitState == GE_MPOINT )
		pos:=nCrt

ENDCASE


/***
	bounce
*/
IF ( pos == 0 ) 			// bumped top

	IF lCycle .OR. ( !ReadExit() .AND. !BumpBot )
		BumpTop := .T.
		pos := LastPos
		exitState := GE_DOWN
	END

ELSEIF ( pos == Len(GetList) + 1 )	// bumped bottom

	IF lCycle .OR. ( !ReadExit() .AND. exitState <> GE_ENTER .AND. !BumpTop )
		BumpBot := .T.
		pos := LastPos
		exitState := GE_UP
	ELSE
		pos := 0
	END
END

// record exit state
LastExit := exitState

IF ( pos <> 0 ) THEN GetList[pos]:exitstate := exitState

RETURN (pos)

/**********************
	system services
*/

/***
	GetActive()
*/
FUNC GetActive(g)
LOCAL oldActive := ActiveGet
IF ( PCount() > 0 ) THEN  ActiveGet := g
RETURN ( oldActive )


/***
	Updated()
*/
FUNC Updated()
RETURN (Updated)

/***
	ReadExit()
*/
FUNC ReadExit(lNew)
RETURN ( Set(_SET_EXIT, lNew) )

/***
	ReadInsert()
*/

FUNC ReadInsert(lNew)
RETURN ( Set(_SET_INSERT, lNew) )


/***
	ShowScoreboard()
*/
PROC ShowScoreboard()
LOCAL _r,_c

// default display coordinates for SCOREBOARD 0, 16

SetCursor(IF(SET(_SET_INSERT),1,3))
Out(m->score_row, m->score_col, IF(SET(_SET_INSERT),_MSG_INSOVR),m->_hDColor )

**********
FUNC READVAR(Arg1)
LOCAL _var:= ActiveGet
IF (ValType(Arg1) == "C")
	ActiveGet:= Arg1
ENDIF
RETU _var
**********
PROC InsString(oGet,cStr,lMemo)
//Instead KeyBoard, because may be present control characters in string
LOCAL i
FOR i:=1 TO LEN(cStr)
	IF ( _ReadInsert )
		oGet:Insert(SUBSTR(cStr,i,1))
	ELSE
		oGet:Overstrike(SUBSTR(cStr,i,1))
	ENDIF

	IF EMPTY(lMemo) .AND. (oGet:typeOut .AND. !Set(_SET_CONFIRM) )
		?? Chr(7)
		oGet[9] := GE_ENTER
		EXIT
	END

NEXT
**********
FUNC AsciiTbl(cStart)
LOCAL nR, nR1, nC, i, j, cStr, nA, cNa, nK, sc:=SetCursor(1)
IF_NIL cStart IS CHR(0)

PUSH KEYS COLOR m->_im

nR:=m->_middlerow-6
nR1:=m->_middlerow+7
nC:=m->_middlecol-17
Window(nR, nC, nR1, m->_middlecol+17, _MSG_ASCII)

@ nR+2, nC SAY (cStr:='«'+REPL('ƒ', 33)+'∂')// utf-8: (cStr:='‚ïü'+REPL('‚îÄ', 33)+'‚ï¢')
@ nR1-2, nC++ SAY cStr

FOR i:=0 TO 7
	cStr:=''
	For j:=0 TO 31 DO cStr += CHR( i*32+j)
	@ nR+3+i, nC SAY cStr
NEXT

nA:=ASC(cStart)
i:=INT(nA/32)
j:=nA-i*32
cStr:=''

DO WHILE .T.
	nA:=i*32+j
	cNa:=CHR(nA)

        DevPos(nR+3+i, nC+j)

	Out(nR1-1, nC+2, [Char: ]+ cNa +[   Dec: ]+STR(nA, 3)+;
			  [   Hex: ]+FT_Byt2Hex(cNa) )

*	Out(nR+3+i, nC+j, cNa, m->_HdColor)
	Out(, , cNa, m->_HdColor)

	nK:=WaitKey(0)
	DevOut(cNa)

	DO CASE
		CASE nK==K_ESC
			cStr:=''
			EXIT

		CASE nK==K_ENTER
			cStr+=cNa
			EXIT

		CASE nK==KP_ALT_PLUS .OR. nK==KP_ALT_MINUS
			IF nK==KP_ALT_PLUS
				cStr+=cNa
			ELSE
				cStr:=Strip(cStr,1)
			ENDIF
			Out(nR1-2, nC, PAD(_MSG_ASC_SLCT+cStr, 33), m->_HdColor)

		CASE nk==K_RIGHT
			j:=IF( j<31, j+1, 0)

		CASE nK==K_LEFT
			j:=IF( j>0, j-1, 31)

		CASE nK==K_DOWN
			i:=IF( i<7, i+1, 0)

		CASE nK==K_UP
			i:=IF( i>0, i-1, 7)
	ENDCASE
ENDDO

POP KEYS
SetCursor(sc)

RETURN cStr
**********
FUNC IsKbMacro(Key, nMode)
LOCAL i, lRes:=.T.
IF TestMacro(key,nMode)

ELSEIF (i:=ASCAN({  384, 385,       282,       296,           K_ALT_B, K_ALT_O, K_ALT_A,  K_ALT_C},key))#0
	KEYB {'()'+_LEFT,'()','{}'+_LEFT,'""'+_LEFT,'{||}'+_LEFT+_LEFT,' .OR. ',' .AND. ','CTOD("//")'+_LEFT+_LEFT+_LEFT+_LEFT}[i]
ELSE
	lRes:=.F.
ENDIF
RETU lRes
