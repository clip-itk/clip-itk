#include "box.ch"
#include "Inkey.ch"
#include "Setcurs.ch"
#include "Error.ch"
#include "config.ch"


#define MY_HEADSEP      translate_charset(__CHARSET__,host_charset(),"∂†")
#define MY_COLSEP       translate_charset(__CHARSET__,host_charset(),"Å ")

#define MSG_RECORDS [Record N ]

FUNCTION SQLBrowse(r,top,left,bottom,right,columns,headers,widths)
	LOCAL cScreen
	LOCAL browse
	LOCAL nCursSave
	LOCAL nKey
	LOCAL lMore
	LOCAL strMsg1 := [<bof>]
	LOCAL strMsg2 := [<eof>]
	LOCAL strMsg3 := [<empty>]
	LOCAL i
	LOCAL column

	top	:= IF(top == NIL,1,top)
	left	:= IF(left == NIL,0,left)
	bottom	:= IF(bottom == NIL,MAXROW()-1,bottom)
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
		column := TBColumnNew(headers[i],r:FieldBlock(r:FieldNo(columns[i])))
		IF widths != NIL
			column:width := widths[i]
		ENDIF
		browse:addColumn(column)
	NEXT
	browse:skipBlock := {|x| Skipper(r,x)}
	browse:headSep := MY_HEADSEP
	browse:colSep := MY_COLSEP
	browse:colorSpec := SETCOLOR()
//	browse:refreshBlock := {|| r:refresh()}
	nCursSave := SETCURSOR(SC_NONE)
	lMore := .T.

	WHILE lMore
		nKey := 0
		WHILE !browse:stable
			browse:stabilize()
		ENDDO
		WHILE DISPCOUNT()>0
			DISPEND()
		ENDDO
		DispOutAt(top-1,right-40,MSG_RECORDS+PADR(ALLTRIM(STR(r:Recno()))+"/"+;
			ALLTRIM(STR(r:Lastrec())),20) )
		IF browse:stable
			IF browse:hitTop .OR. browse:hitBottom
				dispOutAt(top-1,right-10,IF(r:Bof(),strMsg1,strMsg2))
				TONE(125,0)
			ELSEIF browse:hitEmpty
				dispOutAt(top-1,right-10,strMsg3)
			ELSE
				dispOutAt(top-1,right-10,SPACE(MAX(LEN(strMsg1),LEN(strMsg2))))
			ENDIF
			IF nkey==0
				browse:refreshCurrent()
				browse:forceStable()
				nKey := InKey(0)
					if setkey(nKey)!=NIL
						eval(setkey(nKey),procname(),procline(),readvar())
							loop
					endif
			ENDIF
		ENDIF

		IF nKey == K_ESC
			lMore := .F.
		ELSE
			ApplyKey(browse,nKey)
		ENDIF
	ENDDO

	SETCURSOR(nCursSave)
	RESTSCREEN(,,,,cScreen)
RETURN

STATIC FUNCTION Skipper(r,n)
	LOCAL i:=0

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
	local ret:=.f. ,b
	b := browse:setkey(nKey)
	if b != NIL
		eval(b,browse,nkey)
		ret := .t.
	endif
RETURN ret
