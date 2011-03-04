#include "box.ch"
#include "Inkey.ch"
#include "Setcurs.ch"
#include "Error.ch"
#include "config.ch"

#define MY_HEADSEP      translate_charset(__CHARSET__,host_charset(),"∂†") //utf-8: "‚ï§‚ïê"
#define MY_COLSEP       translate_charset(__CHARSET__,host_charset(),"Å ") //utf-8: "‚îÇ "

#define MSG_RECORDS [Record N ]

FUNCTION SQLBrowse(r,top,left,bottom,right,columns,headers,widths,pictures)
	LOCAL cScreen
	LOCAL browse
	LOCAL nCursSave
	LOCAL nKey
	LOCAL lMore
	LOCAL strMsg1 := [<bof>]
	LOCAL strMsg2 := [<eof>]
	LOCAL strMsg3 := [<empty>]
	LOCAL block
	LOCAL i
	LOCAL column

	top	:= IF(top == NIL,1,top)
	left	:= IF(left == NIL,0,left)
	bottom	:= IF(bottom == NIL,MAXROW(),bottom)
	right	:= IF(right == NIL,MAXCOL(),right)
	top	:= MAX(top,0)
	left	:= MAX(left,0)
	bottom	:= MIN(bottom,MAXROW())
	right	:= MIN(right,MAXCOL())

	IF columns == NIL
		columns := ARRAY(r:NFields())
		FOR i := 1 TO r:NFields()
			columns[i] := r:FieldName(i)
		NEXT
	ENDIF
	IF headers == NIL
		headers := ARRAY(r:NFields())
		FOR i := 1 TO r:NFields()
			headers[i] := r:FieldName(i)
		NEXT
	ENDIF

	cScreen := SAVESCREEN()
	@ top, left TO bottom, right DOUBLE

	browse := TBrowseNew(top+2,left+1,bottom-1,right-1)

	FOR i := 1 TO LEN(columns)
		block := r:FieldBlock(r:FieldNo(columns[i]))
		IF r:FieldBinary(columns[i]) .AND. r:FieldType(columns[i]) == "C"
			column := TBColumnNew(headers[i],{|| "<Binary>"})
		ELSE
			column := TBColumnNew(headers[i],block)
		ENDIF
		IF widths != NIL
			column:width := widths[i]
		ENDIF
		IF pictures != NIL
			column:picture := pictures[i]
		ENDIF
		column:type := r:FieldType(columns[i])
		column:_len := r:FieldLen(columns[i])
		column:dec := r:FieldDec(columns[i])
		browse:addColumn(column)
	NEXT
	browse:skipBlock := {|x| Skipper(x,browse)}
	browse:headSep := MY_HEADSEP
	browse:colSep := MY_COLSEP
	browse:colorSpec := SETCOLOR()
	nCursSave := SETCURSOR(SC_NONE)
	lMore := .T.
	FancyColors(browse)
	nCursSave := SetCursor(SC_NONE)
	browse:rowset := r

	DO WHILE lMore

		nKey := 0
		DO WHILE ! browse:stable //.and. nextKey() == 0
			browse:stabilize()
		ENDDO
		while dispcount()>0
			dispend()
		enddo
		dispOutAt(top-1, right-40, MSG_RECORDS+padr(alltrim(str(r:recno()))+"/"+alltrim(str(r:lastrec())),20) )
		IF browse:stable

			IF browse:hitTop .OR. browse:hitBottom
				dispOutAt( top-1, right-10, iif(r:bof(),strMsg1,strMsg2) )
				TONE(125, 0)
			else
				dispOutAt( top-1, right-10, space(max(len(strMsg1),len(strMsg2))) )
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

STATIC FUNCTION Skipper(n,browse)
	LOCAL i:=0
	LOCAL r := browse:rowset

	IF n > 0
		WHILE i < n
			r:Skip(1)
			IF r:Eof()
				EXIT
			ENDIF
			i++
		ENDDO
	ELSEIF n < 0
		WHILE i > n
			r:Skip(-1)
			IF r:Bof()
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
		CASE nKey == K_UP
			browse:up()
		CASE nKey == K_PGUP
			browse:pageUp()
		CASE nKey == K_CTRL_PGUP
			browse:goTop()
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

	browse:ForceStable()
	lScore := Set(_SET_SCOREBOARD, .F.)
	lExit := Set(_SET_EXIT, .T.)
	bIns := SetKey(K_INS)
	SetKey( K_INS, {|| InsToggle()} )
	SetCursor( IF(ReadInsert(), SC_INSERT, SC_NORMAL) )
	col := browse:getColumn(browse:colPos)
	pic:="@S"+alltrim(str(browse:nRight-col()+1))
	if eval(col:block) == NIL
		switch(col:type)
			case 'C'
				eval(col:block,space(col:_len))
			case 'N'
				eval(col:block,0)
			case 'D'
				eval(col:block,stod("        "))
			case 'L'
				eval(col:block,.F.)
// No GET DATETIME_t implemented yet
//			case 'T'
//				eval(col:block,STOT())
		endswitch
	endif
	get := GetNew(Row(), Col(), col:block, col:heading, pic, browse:colorSpec)
	ReadModal( {get} )
	SetCursor(0)
	Set(_SET_SCOREBOARD, lScore)
	Set(_SET_EXIT, lExit)
	SetKey(K_INS, bIns)

	browse:refreshAll()
	browse:ForceStable()

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
	FOR n := 1 TO browse:colCount
		column := browse:getColumn(n)
		xValue := EVAL(column:block)

		column:defColor := {1, 2}
	NEXT
RETURN

