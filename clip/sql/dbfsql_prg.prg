FUNCTION ConnectNew(rdbms)
	LOCAL o := map()

	o:classname := "TCONNECT"

	o:conn := SQLCreateConn(rdbms,PARAM(2),PARAM(3),PARAM(4),PARAM(5),PARAM(6),;
		PARAM(7),PARAM(8),PARAM(9))

	o:RDBMS := rdbms
	o:Rowsets := ARRAY(0)
	o:Command := @connCommand()
	o:TestParser := @connTestParser()
	o:Destroy := @connDestroy()
	o:CreateRowset := @connCreateRowset()
RETURN o

STATIC FUNCTION connCommand(sql,pars)
	LOCAL stmt
	LOCAL ret

	SQLLocWrite(::conn,@sql)
	stmt := SQLPrepare(::conn,sql)
	ParLocWrite(::conn,pars)
	ret := SQLCommand(stmt,pars)
	SQLFreeSTMT(stmt)
RETURN ret

STATIC FUNCTION connTestParser(sql,pars)
	LOCAL ret := SQLTestParser(::conn,sql,pars)
RETURN ret

STATIC FUNCTION connDestroy(self)
	LOCAL I
	LOCAL rs

	IF self:conn != NIL
		FOR I:=1 TO LEN(self:Rowsets)
			rs := self:Rowsets[I]
			rs:destroy()
			rs:rowset := NIL
		NEXT
		SQLDestroyConn(self:conn)
		self:conn := NIL
	ENDIF
RETURN

STATIC FUNCTION connCreateRowset(self,selectSQL,pars,insertSQL,deleteSQL,updateSQL,refreshSQL,idname,orders,gen_idSQL)
	LOCAL ors := map()
	LOCAL stmt
	LOCAL i


	ors:classname := "TROWSET"

	SQLLocWrite(self:conn,@selectSQL)
	SQLLocWrite(self:conn,@insertSQL)
	SQLLocWrite(self:conn,@deleteSQL)
	SQLLocWrite(self:conn,@updateSQL)
	SQLLocWrite(self:conn,@refreshSQL)

	stmt := SQLPrepare(self:conn,selectSQL)

	ParLocWrite(self:conn,pars)
	ors:RDBMS := self:RDBMS
	ors:conn := self:conn
	ors:parameters := pars
	ors:idname := idname
	ors:orders := orders
	ors:curorder := NIL

	ors:selectSQL := selectSQL
	ors:insertSQL := insertSQL
	ors:deleteSQL := deleteSQL
	ors:updateSQL := updateSQL
	ors:refreshSQL := refreshSQL

	ors:Read := @rowsetRead()
	ors:Write := @rowsetWrite()
	ors:BOF := @rowsetBOF()
	ors:EOF := @rowsetEOF()
	ors:Recno := @rowsetRecno()
	ors:Lastrec := @rowsetLastrec()
	ors:NFields := @rowsetNFields()
	ors:FieldNo := @rowsetFieldNo()
	ors:FieldName := @rowsetFieldName()
	ors:FieldType := @rowsetFieldType()
	ors:FieldNullable := @rowsetFieldNullable()
	ors:FieldUnsigned := @rowsetFieldUnsigned()
	ors:FieldBinary := @rowsetFieldBinary()
	ors:FieldLen := @rowsetFieldLen()
	ors:FieldDec := @rowsetFieldDec()
	ors:GetValue := @rowsetGetValue()
	ors:SetValue := @rowsetSetValue()
	ors:Append := @rowsetAppend()
	ors:Delete := @rowsetDelete()
	ors:GoTop := @rowsetGoTop()
	ors:GoBottom := @rowsetGoBottom()
	ors:Skip := @rowsetSkip()
	ors:Goto := @rowsetGoto()
	ors:destroy := @rowsetDestroy()
	ors:ToClip := @rowsetToClip()
	ors:FromClip := @rowsetFromClip()
	ors:FieldBlock := @rowsetFieldBlock()
	ors:Browse := @rowsetBrowse()
	ors:Refresh := @rowsetRefresh()
	ors:RefreshCurrent := @rowsetRefreshCurrent()
	ors:CreateOrder := @rowsetCreateOrder()
	ors:Seek := @rowsetSeek()
	ors:SetOrder := @rowsetSetOrder()

	ors:rowset := SQLCreateRowset(ors,stmt,pars,idname,orders,gen_idSQL)
	SQLFillOrders(ors:rowset)

	AADD(self:Rowsets,ors)

RETURN ors

STATIC FUNCTION rowsetBOF()
RETURN SQLBof(::rowset)

STATIC FUNCTION rowsetEOF()
RETURN SQLEof(::rowset)

STATIC FUNCTION rowsetRecno()
RETURN SQLRecno(::rowset)

STATIC FUNCTION rowsetLastrec()
RETURN SQLLastrec(::rowset)

STATIC FUNCTION rowsetNFields()
RETURN SQLNFields(::rowset)

STATIC FUNCTION rowsetFieldNo(fieldname)
RETURN SQLFieldNo(::rowset,fieldname)

STATIC FUNCTION rowsetFieldName(fieldno)
RETURN SQLFieldName(::rowset,fieldno)

STATIC FUNCTION rowsetFieldType(fieldno)
RETURN SQLFieldType(::rowset,fieldno)

STATIC FUNCTION rowsetFieldNullable(fieldno)
RETURN SQLFieldNullable(::rowset,fieldno)

STATIC FUNCTION rowsetFieldUnsigned(fieldno)
RETURN SQLFieldUnsigned(::rowset,fieldno)

STATIC FUNCTION rowsetFieldBinary(fieldno)
RETURN SQLFieldBinary(::rowset,fieldno)

STATIC FUNCTION rowsetFieldLen(fieldno)
RETURN SQLFieldLen(::rowset,fieldno)

STATIC FUNCTION rowsetFieldDec(fieldno)
RETURN SQLFieldDec(::rowset,fieldno)

STATIC FUNCTION rowsetGetValue(self,field)
	LOCAL fieldno :=;
		IIF(VALTYPE(field) == "C", SQLFieldNo(self:rowset,field), field)
RETURN self:ToClip(fieldno)

STATIC FUNCTION rowsetSetValue(self,field,value)
	LOCAL fieldno :=;
		IIF(VALTYPE(field) == "C", SQLFieldNo(self:rowset,field), field)

	SQLSetValue(self:rowset,fieldno,self:FromClip(fieldno,value,.F.))
RETURN

STATIC FUNCTION rowsetAppend(self,data)
	LOCAL keys := mapkeys(data)
	LOCAL stmt
	LOCAL id
	LOCAL pars
	LOCAL i
	LOCAL idhash

	IF self:insertSQL != NIL
		id := SQLGenId(self:rowset)
		IF id != NIL .AND. self:idname != NIL
			IF data == NIL
				data := map()
			ENDIF
			idhash := HASHSTR(UPPER(self:idname))
			data[idhash] := id
			AADD(keys,idhash)
		ENDIF
		sql := ParsMacros(self,self:insertSQL,data)
		stmt := SQLPrepare(self:conn,sql)
		pars := ParsArray(self,sql,data)
		IF VALTYPE(self:parameters) == "A"
			FOR i:=1 TO LEN(self:parameters)
				AADD(pars,self:parameters[i])
			NEXT
		ENDIF
		SQLCommand(stmt,pars)
		SQLAppend(self:rowset)
		IF SQLRowId(self:rowset) != 0
			id := SQLNewId(self:conn,stmt)
			self:SetValue(SQLRowId(self:rowset),id)
		ENDIF
		SQLFreeSTMT(stmt)
	ELSE
		SQLAppend(self:rowset)
	ENDIF
	FOR I:=1 TO LEN(data)
		FOR J:=1 TO SQLNFields(self:rowset)
			IF HASHSTR(UPPER(SQLFieldName(self:rowset,J))) == keys[I]
				self:SetValue(J,data[keys[I]])
				EXIT
			ENDIF
		NEXT
	NEXT
RETURN

STATIC FUNCTION rowsetDelete(self)
	LOCAL ret
	LOCAL pars,i

	IF SQLLastrec(self:rowset) > 0 .AND. self:deleteSQL != NIL
		stmt := SQLPrepare(self:conn,self:deleteSQL)
		pars := ParsArray(self,self:deleteSQL,self:Read())
		IF VALTYPE(self:parameters) == "A"
			FOR i:=1 TO LEN(self:parameters)
				AADD(pars,self:parameters[i])
			NEXT
		ENDIF
		SQLCommand(stmt,pars)
		SQLFreeSTMT(stmt)
	ENDIF
	ret := SQLDelete(self:rowset)
RETURN ret

STATIC FUNCTION rowsetGoTop(self)
	SQLGotop(self:rowset)
RETURN

STATIC FUNCTION rowsetGoBottom(self)
	SQLGobottom(self:rowset)
RETURN

STATIC FUNCTION rowsetSkip(self,rows)
	LOCAL ret
	IF rows==NIL;rows:=1;ENDIF
	ret := SQLSkip(self:rowset,rows)
RETURN ret

STATIC FUNCTION rowsetGoto(self,row)
	LOCAL ret
	ret := SQLGoto(self:rowset,row)
RETURN ret

STATIC FUNCTION rowsetDestroy(self)
	IF self:rowset != NIL
		SQLDestroyRowset(self:rowset)
		self:rowset := NIL
	ENDIF
RETURN

STATIC FUNCTION rowsetRead(self)
	LOCAL data := map()
	LOCAL I
	FOR I:=1 TO SQLNFields(self:rowset)
		data[HASHSTR(UPPER(SQLFieldName(self:rowset,I)))] := self:GetValue(I)
	NEXT
RETURN data

STATIC FUNCTION rowsetWrite(self,data)
	LOCAL I,J
	LOCAL datakeys := mapkeys(data)
	LOCAL stmt
	LOCAL sql
	LOCAL pars

	IF SQLLastrec(self:rowset) > 0
		IF self:updateSQL != NIL
			data[HASHSTR(UPPER(;
				SQLFieldName(self:rowset,SQLRowId(self:rowset))))] :=;
				self:GetValue(SQLRowId(self:rowset))
			sql := ParsMacros(self,self:updateSQL,data)
			stmt := SQLPrepare(self:conn,sql)
			pars := ParsArray(self,sql,data)
			IF VALTYPE(self:parameters) == "A"
				FOR i:=1 TO LEN(self:parameters)
					AADD(pars,self:parameters[i])
				NEXT
			ENDIF
			SQLCommand(stmt,pars)
			SQLFreeSTMT(stmt)
		ENDIF
		FOR I:=1 TO LEN(datakeys)
			FOR J:=1 TO SQLNFields(self:rowset)
				IF HASHSTR(UPPER(SQLFieldName(self:rowset,J))) == datakeys[I]
					self:SetValue(J,data[datakeys[I]])
					EXIT
				ENDIF
			NEXT
		NEXT
	ENDIF
RETURN

STATIC FUNCTION rowsetToClip(self,fieldno)
RETURN _FromRDBMSToClip(self:rowset,self:conn,self:RDBMS,fieldno)

FUNCTION _FromRDBMSToClip(rowset,conn,RDBMS,fieldno)
	LOCAL ret

	IF RDBMS == "PG"
		ret := CLIP("PG2CLIP",rowset,fieldno)
	ELSEIF RDBMS == "MS"
		ret := CLIP("MS2CLIP",rowset,fieldno)
	ELSEIF RDBMS == "OR"
		ret := CLIP("OR2CLIP",rowset,fieldno)
	ELSEIF RDBMS == "ODBC"
		ret := CLIP("ODBC2CLIP",rowset,fieldno)
	ELSEIF RDBMS == "IB"
		ret := CLIP("IB2CLIP",rowset,fieldno)
	ENDIF
	IF VALTYPE(ret) == "C" .AND. !SQLFieldBinary(rowset,fieldno)
		SQLLocRead(conn,@ret)
	ENDIF
RETURN ret

FUNCTION _FromClipToRDBMS(rowset,conn,rdbms,fieldno,value,totext)
	LOCAL ret
	LOCAL lob

	IF rdbms == "PG"
		ret := CLIP("CLIP2PG",rowset,fieldno,value,totext)
		IF totext
			ret := "'"+ret+"'"
		ENDIF
	ELSEIF rdbms == "MS"
		ret := CLIP("CLIP2MS",rowset,fieldno,value,totext)
		IF totext
			ret := "'"+ret+"'"
		ENDIF
	ELSEIF rdbms == "OR"
		lob := NIL
		IF totext
			lob := CLIP("OR_GETLOBLOC",rowset,fieldno)
		ENDIF
		ret := CLIP("CLIP2OR",rowset,fieldno,value,totext)
		IF lob!=NIL
			ret := lob+ret
		ENDIF
	ELSEIF rdbms == "ODBC"
		ret := CLIP("CLIP2ODBC",rowset,fieldno,value,totext)
		IF totext
			ret := "'"+ret+"'"
		ENDIF
	ELSEIF rdbms == "IB"
		ret := CLIP("CLIP2IB",rowset,fieldno,value,totext)
	ENDIF
	IF VALTYPE(ret) == "C" .AND. !SQLFieldBinary(rowset,fieldno)
		SQLLocWrite(conn,@ret)
	ENDIF
RETURN ret

STATIC FUNCTION rowsetFromClip(self,fieldno,value,totext)
RETURN _FromClipToRDBMS(self:rowset,self:conn,self:RDBMS,fieldno,value,totext)

STATIC FUNCTION rowsetFieldBlock(self,fieldno)
	LOCAL b,toclip,fromclip

	toclip := "_FromRDBMSToClip("+ALLTRIM(STR(self:rowset))+","+;
		ALLTRIM(STR(self:conn))+",'"+self:RDBMS+"',"+;
		ALLTRIM(STR(fieldno))+")"

	fromclip := "SQLSetValue("+ALLTRIM(STR(self:rowset))+","+;
		ALLTRIM(STR(fieldno))+",_FromClipToRDBMS("+;
		ALLTRIM(STR(self:rowset))+","+ALLTRIM(STR(self:conn))+",'"+;
		self:RDBMS+"',"+ALLTRIM(STR(fieldno))+",x,.F.))"
RETURN &("{|x| IF(x==NIL,"+toclip+","+fromclip+")}")

STATIC FUNCTION rowsetBrowse(self,top,left,bottom,right,columns,headers,widths)
RETURN SQLBrowse(self,top,left,bottom,right,columns,headers,widths)

STATIC FUNCTION ParsMacros(self,sql,data)
	LOCAL I,J
	LOCAL keys := mapkeys(data)
	LOCAL up := UPPER(sql)
	LOCAL lis := ""
	LOCAL fields := ""
	LOCAL values := ""
	LOCAL poslist,posfields,posvalues

	poslist := AT("%LIST",up)
	posfields := AT("%FIELDS",up)
	posvalues := AT("%VALUES",up)

	IF poslist==0 .AND. posfields==0 .AND. posvalues==0
		RETURN sql
	ENDIF

	IF LEN(data)==0
		RETURN NIL
	ENDIF
	FOR I:=1 TO LEN(data)
		FOR J:=1 TO SQLNFields(self:rowset)
			IF SQLRowId(self:rowset) != J .OR. self:idname != NIL
				IF HASHSTR(UPPER(SQLFieldName(self:rowset,J))) == keys[I]
					IF poslist!=0
						lis += SQLFieldName(self:rowset,J)+;
							"=:"+SQLFieldName(self:rowset,J)+","
					ENDIF
					IF posfields!=0
						fields += SQLFieldName(self:rowset,J)+","
					ENDIF
					IF posvalues!=0
						values += ":"+SQLFieldName(self:rowset,J)+","
					ENDIF
					EXIT
				ENDIF
			ENDIF
		NEXT
	NEXT

	IF poslist != 0
		lis := LEFT(lis,LEN(lis)-1)
		WHILE (poslist := AT("%LIST",UPPER(sql))) != 0
			sql := STUFF(sql,poslist,5,lis)
		ENDDO
	ENDIF
	IF posfields != 0
		fields := LEFT(fields,LEN(fields)-1)
		WHILE (posfields := AT("%FIELDS",UPPER(sql))) != 0
			sql := STUFF(sql,posfields,7,fields)
		ENDDO
	ENDIF
	IF posvalues != 0
		values := LEFT(values,LEN(values)-1)
		WHILE (posvalues := AT("%VALUES",UPPER(sql))) != 0
			sql := STUFF(sql,posvalues,7,values)
		ENDDO
	ENDIF

RETURN sql

STATIC FUNCTION ParsArray(self,sql,data)
	LOCAL ar := ARRAY(0)
	LOCAL iter := sql
	LOCAL b
	LOCAL name
	LOCAL I
	LOCAL fieldno
	LOCAL val

	DO WHILE (b := AT(":",iter)) != 0
		iter := SUBSTR(iter,b)
		e := AtAny(" ,;)",iter)
		name := SUBSTR(iter,2,e-2)
		iter := SUBSTR(iter,e+1)
		IF ASCAN(ar,{|x| x[1]==name}) == 0
			fieldno := self:FieldNo(name)
			IF fieldno != 0
				IF data[HASHSTR(UPPER(name))] != NIL
					val := self:FromClip(fieldno,data[HASHSTR(UPPER(name))],.T.)
					AADD(ar,{name,val,SQLFieldType(self:rowset,fieldno),;
						SQLFieldBinary(self:rowset,fieldno)})
				ELSE
					AADD(ar,{name,IIF(self:RDBMS=="IB",NIL,"null"),;
						self:FieldType(fieldno)})
				ENDIF
			ENDIF
		ENDIF
	ENDDO
RETURN ar

STATIC FUNCTION AtAny(sub,str)
	LOCAL I := 0
	LOCAL c

	DO WHILE !empty( c := SUBSTR(str,++I,1) )
		IF c $ sub
			EXIT
		ENDIF
	ENDDO
RETURN I

FUNCTION NUMNO(str,no)
	LOCAL I,J
	LOCAL nos := 0
	LOCAL pos
	LOCAL len := LEN(str)+1
	LOCAL digits := "1234567890.-"

	str := " "+str
	IF no>0
		FOR I:=1 TO len
			IF !(SUBSTR(str,I-1,1) $ digits) .AND.;
				SUBSTR(str,I,1) $ digits
				IF ++nos == no
					EXIT
				ENDIF
			ENDIF
		NEXT
	ELSE
		FOR I:=len TO 1 STEP -1
			IF !(SUBSTR(str,I-1,1) $ digits) .AND.;
				SUBSTR(str,I,1) $ digits
				IF ++nos == -no
					EXIT
				ENDIF
			ENDIF
		NEXT
	ENDIF
	J := I
	IF nos==ABS(no)
		WHILE J<=len .AND. SUBSTR(str,J,1) $ digits; J++; ENDDO
		RETURN SUBSTR(str,I,J-I)
	ENDIF
RETURN

STATIC FUNCTION rowsetRefresh(self)
	LOCAL recno := SQLRecno(self:rowset)
	LOCAL stmt

	IF self:rowset != NIL
		SQLDestroyRowset(self:rowset)
	ENDIF
	stmt := SQLPrepare(self:conn,self:selectSQL)
	self:rowset := SQLCreateRowset(self,stmt,self:parameters,self:idname,self:orders)
	SQLFillOrders(self:rowset)
	self:SetOrder(self:curorder)
	SQLGoto(self:rowset,recno)
RETURN SQLLastrec(self:rowset)

STATIC FUNCTION rowsetRefreshCurrent(self,data)
	LOCAL stmt
	LOCAL sql
	LOCAL pars,i

	IF self:refreshSQL != NIL
		IF VALTYPE(data) != "O"
			data := map()
		ENDIF
		data[HASHSTR(UPPER(;
			SQLFieldName(self:rowset,SQLRowId(self:rowset))))] :=;
			self:GetValue(SQLRowId(self:rowset))
		stmt := SQLPrepare(self:conn,self:refreshSQL)
		pars := ParsArray(self,self:refreshSQL,data)
		IF VALTYPE(self:parameters) == "A"
			FOR i:=1 TO LEN(self:parameters)
				AADD(pars,self:parameters[i])
			NEXT
		ENDIF
		SQLRefresh(self:rowset,stmt,pars,self:idname)
		SQLFreeSTMT(stmt)
	ENDIF
RETURN

STATIC PROCEDURE ParLocWrite(conn,pars)
	LOCAL i
	IF VALTYPE(pars) == "A"
		FOR i:=1 to LEN(pars)
			IF VALTYPE(pars[i][2]) == "C" .AND.;
				(LEN(pars[i]) < 4 .OR. VALTYPE(pars[i][4]) != "L" .OR. !pars[i][4])
				SQLLocWrite(conn,@pars[i][2])
			ENDIF
		NEXT
	ENDIF
RETURN

STATIC PROCEDURE rowsetCreateOrder(self,tagname,exp,len)
	SQLCreateOrder(self,self:rowset,tagname,exp,len)
RETURN

STATIC FUNCTION rowsetSeek(self,val,soft)
RETURN SQLSeek(self:rowset,val,soft)

STATIC FUNCTION rowsetSetOrder(self,tagname)
	self:curorder := tagname
RETURN SQLSetOrder(self:rowset,tagname)

