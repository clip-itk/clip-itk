/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "box.ch"
#include "Inkey.ch"
#include "Setcurs.ch"
#include "Error.ch"
#include "config.ch"


#define TURN_ON_APPEND_MODE(b)      (b:cargo := .T.)
#define TURN_OFF_APPEND_MODE(b)     (b:cargo := .F.)
#define IS_APPEND_MODE(b)           (b:cargo)
#define MY_HEADSEP      translate_charset(__CHARSET__,host_charset(),"∂†")
#define MY_COLSEP       translate_charset(__CHARSET__,host_charset(),"Å ")

#define MSG_RECORDS [Record N ]

function browse ( top, left, down, right )

    LOCAL bSaveHandler, error
    LOCAL cScreen

    top  := iif( top  == NIL, 1, top )
    left := iif( left == NIL, 0, left )
    down  := iif( down  == NIL, maxrow()-1, down )
    right:= iif( right== NIL, maxcol() , right )
    top=max(top,0)
    left=max(left,0)
    down=min(down,maxrow())
    right=min(right,maxcol())

    cScreen := SAVESCREEN()
    @ top, left TO down, right DOUBLE
    MyBrowse(top+2, left+1 , down-1, right-1 )

    RESTSCREEN(,,,,cScreen)

return NIL

STATIC PROCEDURE MyBrowse(nTop, nLeft, nBottom, nRight)

    LOCAL browse                        // The TBrowse object
    LOCAL cColorSave, nCursSave         // State preservers
    LOCAL nKey                          // Keystroke
    LOCAL lMore                         // Loop control
    local strMsg1:=[<bof>]
    local strMsg2:=[<new>]


    browse := StockBrowseNew(nTop, nLeft, nBottom, nRight)
    TURN_OFF_APPEND_MODE(browse)
    //browse:skipBlock := { |x| local(_b:=@browse), Skipper(x, _b) }
    browse:skipBlock := { |x| Skipper(x, browse) }
    browse:headSep := MY_HEADSEP
    browse:colSep := MY_COLSEP
    FancyColors(browse)
    nCursSave := SetCursor(SC_NONE)
    lMore := .T.
    DO WHILE lMore

	nKey := 0
	DO WHILE ! browse:stable //.and. nextKey() == 0
	    browse:stabilize()
	ENDDO
        while dispcount()>0
        	dispend()
        enddo
	dispOutAt(ntop-1, nright-40, MSG_RECORDS+padr(alltrim(str(recno()))+"/"+alltrim(str(lastrec())),20) )
	IF browse:stable

	    IF browse:hitBottom .AND. .NOT. IS_APPEND_MODE(browse)
		TURN_ON_APPEND_MODE(browse)
		dispOutAt( ntop-1, nright-10, strMsg2 )
		nKey := K_DOWN
	    ELSE
		IF browse:hitTop .OR. browse:hitBottom
		    dispOutAt( ntop-1, nright-10, iif(bof(),strMsg1,strMsg2) )
		    TONE(125, 0)
		else
                	if !IS_APPEND_MODE(browse)
		    		dispOutAt( ntop-1, nright-10, space(max(len(strMsg1),len(strMsg2))) )
                        endif
		ENDIF
	    ENDIF
            if nkey==0
	    	browse:refreshCurrent()
	    	browse:ForceStable()
	    	nKey := InKey(0)
	    	if setkey(nKey)!=NIL
		    	eval(setkey(nKey),procname(),procline(),readvar())
        	    	loop
	    	endif
            endif
	ENDIF

	IF nKey == K_ESC
	    lMore := .F.
	ELSE
	    ApplyKey(browse, nKey)
	ENDIF
    ENDDO
    SETCURSOR(nCursSave)
RETURN

STATIC FUNCTION Skipper(n, browse)
    LOCAL lAppend:=.f.
    LOCAL i:=0
    lAppend := IS_APPEND_MODE(browse)           // see #defines at top
    IF n == 0 .OR. RECCOUNT() == 0
	SKIP 0
    ELSEIF n > 0 .and. RECNO() != RECCOUNT() + 1
	DO WHILE i < n
	    SKIP 1
	    IF ( EOF() )
		IF ( lAppend )
		    i++
		ELSE
		    SKIP -1
		ENDIF
		EXIT
	    ENDIF
	    i++
	ENDDO
    ELSEIF n < 0
	DO WHILE i > n
	    SKIP -1
	    IF ( BOF() )
		EXIT
	    ENDIF
	    i--
	ENDDO
    ENDIF
RETURN i

STATIC PROCEDURE ApplyKey(browse, nKey)
	local bBlock
    DO CASE
    CASE nKey == K_CTRL_PGDN
	browse:goBottom()
	TURN_OFF_APPEND_MODE(browse)
    CASE nKey == K_UP
	browse:up()
	IF IS_APPEND_MODE(browse)
	    TURN_OFF_APPEND_MODE(browse)
	    browse:refreshAll()
	ENDIF
    CASE nKey == K_PGUP
	browse:pageUp()
	IF IS_APPEND_MODE(browse)
	    TURN_OFF_APPEND_MODE(browse)
	    browse:refreshAll()
	ENDIF
    CASE nKey == K_CTRL_PGUP
	browse:goTop()
	TURN_OFF_APPEND_MODE(browse)
    CASE nKey == K_RETURN
	DoGet(browse)
    OTHERWISE
	bBlock := browse:setkey(nkey)
        if bBlock != NIL
        	eval(bBlock, browse, nkey)
        else
    		if nKey >=32 .and. nKey < 1000
			KEYBOARD CHR(nKey)
			DoGet(browse)
        	endif
        endif
    ENDCASE
RETURN



STATIC PROCEDURE DoGet(browse)
    LOCAL bIns, lScore, lExit, pic
    LOCAL col, get, nKey
    LOCAL lAppend:=.f., xOldKey, xNewKey
    browse:ForceStable()
    lAppend := IS_APPEND_MODE(browse)
    IF lAppend .AND. RECNO() == RECCOUNT() + 1
	APPEND BLANK
    ENDIF
    //xOldKey := IF( EMPTY(INDEXKEY()), NIL, &(INDEXKEY()) )
    xOldKey := NIL
    lScore := Set(_SET_SCOREBOARD, .F.)
    lExit := Set(_SET_EXIT, .T.)
    bIns := SetKey(K_INS)
    SetKey( K_INS, {|| InsToggle()} )
    SetCursor( IF(ReadInsert(), SC_INSERT, SC_NORMAL) )
    col := browse:getColumn(browse:colPos)
    pic:="@S"+alltrim(str(browse:nRight-col()+1))
    get := GetNew(Row(), Col(), col:block, col:heading, pic, browse:colorSpec)
    ReadModal( {get} )
    SetCursor(0)
    Set(_SET_SCOREBOARD, lScore)
    Set(_SET_EXIT, lExit)
    SetKey(K_INS, bIns)
    //xNewKey := IF( EMPTY(INDEXKEY()), NIL, &(INDEXKEY()) )
    xNewKey := NIL
    IF .NOT. (xNewKey == xOldKey) .OR. (lAppend .AND. xNewKey != NIL)
	browse:refreshAll()
	browse:ForceStable()
	DO WHILE &(INDEXKEY()) > xNewKey .AND. .NOT. browse:hitTop()
	    browse:up()
	    browse:ForceStable()
	ENDDO
    ENDIF
    TURN_OFF_APPEND_MODE(browse)
    nKey := LASTKEY()
    IF nKey == K_UP .OR. nKey == K_DOWN .OR. ;
	nKey == K_PGUP .OR. nKey == K_PGDN
	KEYBOARD( CHR(nKey) )
    ENDIF
RETURN


STATIC PROCEDURE InsToggle()
    IF READINSERT()
	READINSERT(.F.)
	SETCURSOR(SC_NORMAL)
    ELSE
	READINSERT(.T.)
	SETCURSOR(SC_INSERT)
    ENDIF
RETURN

STATIC PROCEDURE FancyColors(browse)
    LOCAL n, column
    LOCAL xValue
    browse:colorSpec := setcolor()
    /*
    if empty(browse:colorSpec)
	 browse:colorSpec := "N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R"
    else
	 browse:colorSpec := setcolor()+", N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R"
    endif
    */
    FOR n := 1 TO browse:colCount
	column := browse:getColumn(n)
	xValue := EVAL(column:block)

	column:defColor := {1, 2}
        /*
	IF VALTYPE(xValue) != "N"
	    column:defColor := {1, 2}
	ELSE
	    column:colorBlock := {|x| if( x < 0, {7, 8}, {5, 6} )}
	    column:defColor := {7, 8}
	ENDIF
        */
    NEXT
RETURN

STATIC FUNCTION StockBrowseNew(nTop, nLeft, nBottom, nRight)
    LOCAL browse
    LOCAL n, column
    browse := TBrowseDB(nTop, nLeft, nBottom, nRight)
    FOR n := 1 TO FCount()
	column := TBColumnNew(Field(n), FieldWBlock(Field(n), Select()))
	browse:addColumn(column)
    NEXT
RETURN browse
