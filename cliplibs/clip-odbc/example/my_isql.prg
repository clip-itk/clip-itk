LOCAL conn,rs,data
LOCAL sql := ""
LOCAL I := 1
LOCAL user		// -u
LOCAL passwd	// -p
LOCAL db

SET("SQL_CHARSET","cp1251")
ErrorBlock({|e| SQLError(e)})

DO WHILE param(I) != NIL
	IF param(I) == "--help" .OR. param(I) == "-?"
		Usage()
		QUIT
	ELSEIF param(I) == "-h"
		host := param(++I)
	ELSEIF param(I) == "-u"
		user := param(++I)
	ELSEIF param(I) == "-p"
		passwd := param(++I)
	ELSE
		db := param(I)
	ENDIF
	I++
ENDDO

IF EMPTY(db)
	Usage()
	QUIT
ENDIF

CLS

BEGIN SEQUENCE
	conn := ConnectNew("ODBC",db,user,passwd)
RECOVER USING e
	QUIT
END SEQUENCE

DO WHILE UPPER(sql := GetCommand()) != "Q"
	IF UPPER(LEFT(sql,6))=="SELECT"
		BEGIN SEQUENCE
			rs := conn:CreateRowset(sql)
		RECOVER USING e
			LOOP
		END SEQUENCE
		FOR I:=1 TO rs:NFields()
			?? PADR(rs:FieldName(I),10),"|"
		NEXT
		?
		FOR I:=1 TO rs:NFields()
			?? "----------","|"
		NEXT
		DO WHILE !rs:Eof()
			?
			data := rs:Read()
			FOR I:=1 TO rs:NFields()
				tmp := data[HASHSTR(UPPER(rs:FieldName(I)))]
				IF VALTYPE(tmp)=="A"
					?? "{...}     ","|"
				ELSEIF tmp==NIL
					?? "NIL       ","|"
				ELSE
					?? PADR(data[HASHSTR(UPPER(rs:FieldName(I)))],10),"|"
				ENDIF
			NEXT
			rs:Skip()
		ENDDO
		rs:Destroy()
	ELSE
		BEGIN SEQUENCE
			?? LEFT(sql,LEN(sql)-1)+": "
			conn:Command(sql)
			?? "OK"
		RECOVER USING e
			LOOP
		END SEQUENCE
	ENDIF
	?
ENDDO

conn:Destroy()

RETURN

FUNCTION GetCommand()
	LOCAL ret := ""
	LOCAL tmp := ""
	LOCAL first := .T.

	@ MAXROW(),0 SAY ""
	DO WHILE !(";" $ tmp) .AND. ALLTRIM(UPPER(ret)) != "Q"
		IF first
			ACCEPT "SQL> " TO tmp
			first := .F.
		ELSE
			ACCEPT "SQL---> " TO tmp
		ENDIF
		ret += tmp + " "
	ENDDO
RETURN ALLTRIM(ret)

FUNCTION SQLError(e)
	?? e:operation
	?
	BREAK(e)
RETURN NIL

PROCEDURE Usage()
	?? "my_isql  Ver 1.00 (simple ODBC frontend) (c) by ITK Ltd., by Rusty"
	? "This software comes with ABSOLUTELY NO WARRANTY."
	?
	? "Usage: my_isql [OPTIONS] <DSN>"
	?
	? "  -?, --help     Display this help and exit"
	? "  -u             User for login if not current user"
	? "  -p             Password to use when connecting to server"
	?
RETURN
