
LOCAL conn,rs,data
LOCAL sql := ""
LOCAL I

CLS
ErrorBlock({|e| SQLError(e)})

conn := ConnectNew("PG",,,,,"template1")
DO WHILE UPPER(sql := GetCommand()) != "Q"
	IF UPPER(LEFT(sql,6))=="SELECT" .OR. UPPER(LEFT(sql,5))=="FETCH"
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
			IF UPPER(LEFT(sql,5))=="START" .OR. UPPER(LEFT(sql,5))=="BEGIN"
				?? (sql := LEFT(sql,LEN(sql)-1))+": "
				trpars := SUBSTR(CHARONE(' ',sql),7)
				conn:Start(IF(LEN(trpars)>0,trpars,NIL))
				?? "OK"
			ELSEIF UPPER(LEFT(sql,6))=="COMMIT" .OR. UPPER(LEFT(sql),3) == "END"
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


