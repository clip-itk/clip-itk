LOCAL conn,rs,data
LOCAL sql := ""
LOCAL I := 1
LOCAL user := "scott"	// -u
LOCAL passwd := "tiger"	// -p
LOCAL db := ""			// -d

ErrorBlock({|e| SQLError(e)})

DO WHILE param(I) != NIL
	IF param(I) == "--help" .OR. param(I) == "-?"
		? "mysqlplus  Ver 0.01 for Oracle Distrib 8.1.6, for pc-linux-gnu (i686)"
		? "By ITK Ltd., by Rusty"
		? "This software comes with ABSOLUTELY NO WARRANTY."
		?
		? "Usage: mymysql [OPTIONS]"
		?
		? "  -?, --help     Display this help and exit"
		? "  -u             User for login if not current user"
		? "  -p             Password to use when connecting to server"
		? "  -d             Database to work with"
		?
		QUIT
	ELSEIF param(I) == "-u"
		user := param(++I)
	ELSEIF param(I) == "-p"
		passwd := param(++I)
	ELSEIF param(I) == "-d"
		db := param(++I)
	ENDIF
	I++
ENDDO

CLS

BEGIN SEQUENCE
	conn := ConnectNew("OR",NIL,NIL,user,passwd,db)
RECOVER USING e
	QUIT
END SEQUENCE

DO WHILE UPPER(sql := GetCommand()) != "Q"
	IF UPPER(LEFT(sql,6))=="SELECT"
		sql := LEFT(sql,LEN(sql)-1)
		BEGIN SEQUENCE
			rs := conn:CreateRowset(sql,,,,,,,,,.t.)
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
				IF tmp==NIL
					?? "NIL       ","|"
				ELSE
					?? PADR(data[HASHSTR(UPPER(rs:FieldName(I)))],10),"|"
				ENDIF
			NEXT
			rs:Skip()
		ENDDO
		rs:Destroy()
	ELSE
		sql := LEFT(sql,LEN(sql)-1)
		BEGIN SEQUENCE
			IF UPPER(LEFT(sql,5))=="START" .OR. UPPER(LEFT(sql,5))=="BEGIN"
				?? sql+": "
				trpars := SUBSTR(CHARONE(' ',sql),7)
				conn:Start(IF(LEN(trpars)>0,trpars,NIL))
				?? "OK"
			ELSEIF UPPER(LEFT(sql,6))=="COMMIT"
				?? sql+": "
				conn:Commit()
				?? "OK"
			ELSEIF UPPER(LEFT(sql,8))=="ROLLBACK"
				?? sql+": "
				conn:Rollback()
				?? "OK"
			ELSE
				?? sql+": "
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


