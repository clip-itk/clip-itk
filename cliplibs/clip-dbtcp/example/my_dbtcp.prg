LOCAL conn,rs,data
LOCAL sql := ""
LOCAL I := 1
LOCAL host      // -h
LOCAL user      // -u
LOCAL passwd    // -p
LOCAL db        // -d
LOCAL port      // -P
LOCAL cs := NIL // -c

ErrorBlock({|e| SQLError(e)})

DO WHILE param(I) != NIL
	IF param(I) == "--help" .OR. param(I) == "-?"
		? "my_dbtcp Ver 0.01"
		? "By ITK Ltd., by Rusty"
		? "This software comes with ABSOLUTELY NO WARRANTY."
		?
		? "Usage: my_dbtcp [OPTIONS]"
		?
		? "  -?, --help     Display this help and exit"
		? "  -h             Connect to host"
		? "  -u             User for login if not current user"
		? "  -p             Password to use when connecting to server"
		? "  -d             DSN to be used"
		? "  -P             Port number to use for connection"
		? "  -c             Backend charset"
		?
		QUIT
	ELSEIF param(I) == "-h"
		host := param(++I)
	ELSEIF param(I) == "-u"
		user := param(++I)
	ELSEIF param(I) == "-p"
		passwd := param(++I)
	ELSEIF param(I) == "-d"
		db := param(++I)
	ELSEIF param(I) == "-P"
		port := param(++I)
	ELSEIF param(I) == "-c"
		cs := param(++I)
	ENDIF
	I++
ENDDO

CLS

IF !EMPTY(cs)
	SET("SQL_CHARSET",cs)
ENDIF

BEGIN SEQUENCE
	conn := ConnectNew("DBTCP",host,port,user,passwd,db)
RECOVER USING e
	QUIT
END SEQUENCE

DO WHILE UPPER(sql := GetCommand()) != "Q"
	IF UPPER(LEFT(sql,6))=="SELECT"
		BEGIN SEQUENCE
			rs := conn:CreateRowset(sql,,,,,,,,,.t.)
		RECOVER USING e
			LOOP
		END SEQUENCE
		FOR I:=1 TO rs:NFields()
			?? PADR(rs:FieldName(I),rs:FieldLen(I)),"|"
		NEXT
		?
		FOR I:=1 TO rs:NFields()
			?? REPLICATE("-",rs:FieldLen(I)),"|"
		NEXT
		DO WHILE !rs:Eof()
			?
			data := rs:Read()
			FOR I:=1 TO rs:NFields()
				tmp := data[HASHSTR(UPPER(rs:FieldName(I)))]
				IF VALTYPE(tmp)=="C" .AND. rs:FieldBinary(I)
					?? PADR("<Binary>",rs:FieldLen(I)),"|"
				ELSEIF VALTYPE(tmp) == "N"
					?? STR(data[HASHSTR(UPPER(rs:FieldName(I)))],rs:FieldLen(I)),"|"
				ELSE
					?? data[HASHSTR(UPPER(rs:FieldName(I)))],"|"
				ENDIF
			NEXT
			rs:Skip()
		ENDDO
		rs:Destroy()
	ELSE
		BEGIN SEQUENCE
			IF UPPER(LEFT(sql,5))=="START" .OR. UPPER(LEFT(sql,5))=="BEGIN"
				?? (sql := LEFT(sql,LEN(sql)-1))+": "
				trpars := SUBSTR(CHARONE(' ',sql),7)
				conn:Start(IF(LEN(trpars)>0,trpars,NIL))
				?? "OK"
			ELSEIF UPPER(LEFT(sql,6))=="COMMIT"
				?? LEFT(sql,LEN(sql)-1)+": "
				conn:Commit(sql)
				?? "OK"
			ELSEIF UPPER(LEFT(sql,8))=="ROLLBACK"
				?? LEFT(sql,LEN(sql)-1)+": "
				conn:Rollback(sql)
				?? "OK"
			ELSE
				?? LEFT(sql,LEN(sql)-1)+": "
				conn:Command(sql)
				?? "OK"
			ENDIF
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
