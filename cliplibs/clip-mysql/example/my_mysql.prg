LOCAL conn,rs,data
LOCAL sql := ""
LOCAL I := 1
LOCAL host		// -h
LOCAL user		// -u
LOCAL passwd	// -p
LOCAL db		// -d
LOCAL port		// -P
LOCAL socket	// -s
LOCAL flag		// -f

ErrorBlock({|e| SQLError(e)})

DO WHILE param(I) != NIL
	IF param(I) == "--help" .OR. param(I) == "-?"
		? "mymysql  Ver 0.01 for MySQL Distrib 3.22.25, for pc-linux-gnu (i686)"
		? "By ITK Ltd., by Rusty"
		? "This software comes with ABSOLUTELY NO WARRANTY."
		?
		? "Usage: mymysql [OPTIONS]"
		?
		? "  -?, --help     Display this help and exit"
		? "  -h             Connect to host"
		? "  -u             User for login if not current user"
		? "  -p             Password to use when connecting to server"
		? "  -d             Database to work with"
		? "  -P             Port number to use for connection"
		? "  -s             Socket file to use for connection"
		? "  -f             Extra flags to use for connection"
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
	ELSEIF param(I) == "-s"
		socket := param(++I)
	ELSEIF param(I) == "-f"
		flag := param(++I)
	ENDIF
	I++
ENDDO

CLS

BEGIN SEQUENCE
	conn := ConnectNew("MS",host,port,user,passwd,db,socket,flag)
RECOVER USING e
	QUIT
END SEQUENCE

DO WHILE UPPER(sql := GetCommand()) != "Q"
	IF UPPER(LEFT(sql,6))=="SELECT" .OR. UPPER(LEFT(sql,4))=="SHOW";
		.OR. UPPER(LEFT(sql,8))=="DESCRIBE" .OR. UPPER(LEFT(sql,7))=="EXPLAIN"
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


