/*
    Copyright (C) 2001  ITK
    Autor   : Rust (rust@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
#define CR			CHR(13)
#define LF			CHR(10)
#define CHUNKSIZE	1024

PROCEDURE Main(srcfile,prg)
	LOCAL I

	PUBLIC destfile
	PUBLIC rdbms
	PUBLIC host
	PUBLIC login
	PUBLIC passwd
	PUBLIC rs := map()
	PUBLIC funcs := ARRAY(0)

	set translate off

	IF srcfile==NIL .OR. prg == NIL
		? "WCL2PRG Version 0.0.1"
		? "Usage: wcl2prg <infile.wcl> <outfile.prg>"
		?
		QUIT
	ENDIF
	ErrorBlock({|e| QOUT(e)})
	destfile := FCREATE(prg,0)

	ToPrg("PROCEDURE Main()"+LF)
	ToPrg("LOCAL _r := map()"+LF)
	ToPrg("LOCAL _data := map()"+LF)
	ToPrg("LOCAL bl"+LF)
	ToPrg("LOCAL _c := map()"+LF)
	ToPrg("LOCAL _rec := map()"+LF)
	ToPrg("LOCAL _I"+LF)
	ToPrg("LOCAL _err,_res"+LF)
	ToPrg("LOCAL _pars := ''"+LF)
	ToPrg("LOCAL _fd"+LF)
	ToPrg("LOCAL _read"+LF)
	ToPrg("LOCAL _chunk"+LF)
	ToPrg("PUBLIC vars := GETENV()"+LF)
	ToPrg("PUBLIC conn"+LF)
	ToPrg("PUBLIC _rs := map()"+LF)
	ToPrg("ErrorBlock({|e| QOUT(e)})"+LF)
	ToPrg('vars:WWW_CLIP_VERSION := "0.0.1"'+LF)
	ToPrg('?? "Content-type: text/html"'+LF)
	ToPrg('? "Generator: WWW-Clip Version "+vars:WWW_CLIP_VERSION'+LF)
	ToPrg('?'+LF+'?'+LF)

	ToPrg('IF vars:REQUEST_METHOD == "GET"'+LF)
	ToPrg('_pars := vars:QUERY_STRING'+LF)
	ToPrg('ELSE'+LF)
	ToPrg('_fd := FOPEN("-|",0)'+LF)
	ToPrg('DO WHILE (_read := FREAD(_fd,@_chunk,1024)) == 1024'+LF)
	ToPrg('_pars += _chunk'+LF)
	ToPrg('_chunk := SPACE(1024)'+LF)
	ToPrg('ENDDO'+LF)
	ToPrg('_pars += LEFT(_chunk,_read)'+LF)
	ToPrg('FCLOSE(_fd)'+LF)
	ToPrg('ENDIF'+LF)
	ToPrg('ParseParameters(_pars)'+LF)

	ParseFile(srcfile)

	ToPrg('RETURN'+LF)

	ToPrg('FUNCTION XTOC(x)'+LF)
	ToPrg('IF VALTYPE(x) == "C"'+LF)
	ToPrg('RETURN x'+LF)
	ToPrg('ELSEIF VALTYPE(x) == "N"'+LF)
	ToPrg('RETURN ALLTRIM(STR(x))'+LF)
	ToPrg('ELSEIF VALTYPE(x) == "D"'+LF)
	ToPrg('RETURN DTOC(x)'+LF)
	ToPrg('ELSEIF VALTYPE(x) == "L"'+LF)
	ToPrg('RETURN IF(x,"TRUE","FALSE")'+LF)
	ToPrg('ENDIF'+LF)
	ToPrg('RETURN "---"'+LF)

	ToPrg('FUNCTION Regul(pattern,string)'+LF)
	ToPrg('LOCAL reg := ARRAY(0)'+LF)
	ToPrg('IF SEARCH(pattern,string,reg)'+LF)
	ToPrg('RETURN reg[1][1]'+LF)
	ToPrg('ENDIF'+LF)
	ToPrg('RETURN 0'+LF)

	ToPrg('FUNCTION GetFieldValue(r,f)'+LF)
	ToPrg('LOCAL q := _rs[HASHSTR(UPPER(r))]'+LF)
	ToPrg('LOCAL data := q:Read()'+LF)
	ToPrg('LOCAL ret'+LF)
	ToPrg('IF VALTYPE(f) == "N"'+LF)
	ToPrg('ret := data[HASHSTR(UPPER(q:FieldName(f+1)))]'+LF)
	ToPrg('ELSE'+LF)
	ToPrg('ret := data[HASHSTR(UPPER(f))]'+LF)
	ToPrg('ENDIF'+LF)
	ToPrg('RETURN IF(ret==NIL,"---",ret)'+LF)

	ToPrg('FUNCTION URLDecode(s)'+LF)
	ToPrg('LOCAL pos'+LF)
	ToPrg('DO WHILE (pos := AT("%",s)) != 0'+LF)
	ToPrg('s := STUFF(s,pos,3,CHR(CTON(SUBSTR(s,pos+1,2),16)))'+LF)
	ToPrg('ENDDO'+LF)
	ToPrg('s := STRTRAN(s,"+"," ")'+LF)
	ToPrg('RETURN s'+LF)

	ToPrg('FUNCTION URLEncode(s)'+LF)
	ToPrg('LOCAL I := 1'+LF)
	ToPrg('LOCAL ch'+LF)
	ToPrg('LOCAL ret := ""'+LF)
	ToPrg('LOCAL len := LEN(s)'+LF)
	ToPrg('FOR I:=1 TO len'+LF)
	ToPrg('ch := SUBSTR(s,I,1)'+LF)
	ToPrg('IF ch == " "'+LF)
	ToPrg('ret += "+"'+LF)
	ToPrg('ELSEIF ASC(ch) > 32 .AND. ASC(ch) < 127'+LF)
	ToPrg('ret += ch'+LF)
	ToPrg('ELSE'+LF)
	ToPrg('ret += "%"+NTOC(ASC(ch),16)'+LF)
	ToPrg('ENDIF'+LF)
	ToPrg('NEXT'+LF)
	ToPrg('RETURN ret'+LF)

	ToPrg('PROCEDURE ParseParameters(pars)'+LF)
	ToPrg('LOCAL pos'+LF)
	ToPrg('LOCAL tmp'+LF)
	ToPrg('LOCAL var'+LF)
	ToPrg('pars := STRTRAN(pars,"+"," ")'+LF)
	ToPrg('URLDecode(@pars)'+LF)
	ToPrg('DO WHILE (pos := AT("&",pars)) != 0'+LF)
	ToPrg('tmp := ALLTRIM(SUBSTR(pars,1,pos-1))'+LF)
	ToPrg('pos := AT("=",tmp)'+LF)
	ToPrg('var := SUBSTR(tmp,pos+1)'+LF)
	ToPrg('var := IF(LEN(var)==0,NIL,var)'+LF)
	ToPrg('var := IF(var=="---",NIL,var)'+LF)
	ToPrg('IF var != NIL .AND. ISDIGIT(var)'+LF)
	ToPrg('var := VAL(var)'+LF)
	ToPrg('ENDIF'+LF)
	ToPrg('vars[HASHSTR(UPPER(SUBSTR(tmp,1,pos-1)))] := var'+LF)
	ToPrg('pars := SUBSTR(pars,LEN(tmp)+2)'+LF)
	ToPrg('ENDDO'+LF)
	ToPrg('tmp := pars'+LF)
	ToPrg('pos := AT("=",tmp)'+LF)
	ToPrg('var := SUBSTR(tmp,pos+1)'+LF)
	ToPrg('var := IF(LEN(var)==0,NIL,var)'+LF)
	ToPrg('var := IF(var=="---",NIL,var)'+LF)
	ToPrg('IF var != NIL .AND. ISDIGIT(var)'+LF)
	ToPrg('var := VAL(var)'+LF)
	ToPrg('ENDIF'+LF)
	ToPrg('vars[HASHSTR(UPPER(SUBSTR(tmp,1,pos-1)))] := var'+LF)
	ToPrg('RETURN'+LF)

	ToPrg('FUNCTION ParseQuery(pat)'+LF)
	ToPrg('LOCAL ret'+LF)
	ToPrg('LOCAL qpos'+LF)
	ToPrg('LOCAL ch'+LF)
	ToPrg('LOCAL I'+LF)
	ToPrg('LOCAL tmp'+LF)
	ToPrg('DO WHILE (qpos := AT("?",pat)) != 0'+LF)
	ToPrg('I := qpos+1'+LF)
	ToPrg('ch := SUBSTR(pat,I,1)'+LF)
	ToPrg('DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"'+LF)
	ToPrg('I++'+LF)
	ToPrg('ch := SUBSTR(pat,I,1)'+LF)
	ToPrg('ENDDO'+LF)
	ToPrg('tmp := XTOC(vars[HASHSTR(UPPER(SUBSTR(pat,qpos+1,I-qpos-1)))])'+LF)
	ToPrg('pat := STUFF(pat,qpos,I-qpos,tmp)'+LF)
	ToPrg('ENDDO'+LF)
	ToPrg('DO WHILE (qpos := AT("$",pat)) != 0'+LF)
	ToPrg('I := qpos+1'+LF)
	ToPrg('ch := SUBSTR(pat,I,1)'+LF)
	ToPrg('DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"'+LF)
	ToPrg('I++'+LF)
	ToPrg('ch := SUBSTR(pat,I,1)'+LF)
	ToPrg('ENDDO'+LF)
	ToPrg('tmp := XTOC(vars[HASHSTR(UPPER(SUBSTR(pat,qpos+1,I-qpos-1)))])'+LF)
	ToPrg('pat := STUFF(pat,qpos,I-qpos,tmp)'+LF)
	ToPrg('ENDDO'+LF)
	ToPrg('RETURN pat'+LF)

	FOR I:=1 TO LEN(funcs)
		ToPrg(funcs[I])
	NEXT
	FCLOSE(destfile)
	Formatter(prg)
RETURN

PROCEDURE Formatter(prg)
	LOCAL fd
	LOCAL src := ""
	LOCAL chunk := SPACE(CHUNKSIZE)
	LOCAL read
	LOCAL lines := ARRAY(0)
	LOCAL pos
	LOCAL I,J
	LOCAL tab := 0
	LOCAL upline
	LOCAL e

	fd := FOPEN(prg,0)
	DO WHILE (read := FREAD(fd,@chunk,CHUNKSIZE)) == CHUNKSIZE
		src += chunk
		chunk := SPACE(CHUNKSIZE)
	ENDDO
	src += LEFT(chunk,read)
	FCLOSE(fd)

	DO WHILE (pos := AT(LF,src)) != 0
		AADD(lines,SUBSTR(src,1,pos-1))
		src := SUBSTR(src,pos+1)
	ENDDO
	AADD(lines,src)
	fd := FCREATE(prg,0)
	FOR I:=1 TO LEN(lines)
		upline := ALLTRIM(UPPER(lines[I]))
		IF;
			LEFT(upline,5) == "ENDIF" .OR.;
			LEFT(upline,4) == "ELSE" .OR.;
			LEFT(upline,5) == "ENDDO" .OR.;
			LEFT(upline,4) == "NEXT"

			tab--
		ENDIF
		IF LEFT(upline,6) == "RETURN" .AND. tab == 1
			tab--
		ENDIF
		FOR J:=1 TO tab
			FWRITE(fd,CHR(9),1)
		NEXT
		FWRITE(fd,lines[I]+LF,LEN(lines[I])+1)
		IF;
			LEFT(upline,2) == "IF" .OR.;
			LEFT(upline,4) == "ELSE" .OR.;
			LEFT(upline,8) == "FUNCTION" .OR.;
			LEFT(upline,9) == "PROCEDURE" .OR.;
			LEFT(upline,8) == "DO WHILE" .OR.;
			LEFT(upline,3) == "FOR"

			tab++
		ENDIF
	NEXT
	FCLOSE(fd)

RETURN

PROCEDURE ToPrg(s)
	s := STRTRAN(s,'""+',"")
	s := STRTRAN(s,'+""',"")
	FWRITE(destfile,s,LEN(s))
RETURN

FUNCTION ParseFile(srcfile)

	LOCAL fd
	LOCAL src := ""
	LOCAL chunk := SPACE(CHUNKSIZE)
	LOCAL read
	LOCAL len
	LOCAL I
	LOCAL istag := .F.
	LOCAL tagbegin := 0
	LOCAL tagend := 0
	LOCAL term
	LOCAL isquote := .F.
	LOCAL iscomment := .F.
	LOCAL ret := ""
	LOCAL done := .F.
	LOCAL brk := .F.
	LOCAL nxt := .F.
	LOCAL pars := ""
	LOCAL ch
	LOCAL pos
	LOCAL tmp

	PRIVATE html := ARRAY(0)

	fd := FOPEN(srcfile,0)
	IF fd == -1
		? "File not found"
		RETURN
	ENDIF

	DO WHILE (read := FREAD(fd,@chunk,CHUNKSIZE)) == CHUNKSIZE
		src += chunk
		chunk := SPACE(CHUNKSIZE)
	ENDDO
	src += LEFT(chunk,read)
	FCLOSE(fd)

	len := LEN(src)
	FOR I:=1 TO len
		ch := SUBSTR(src,I,1)
		IF !isquote
			IF iscomment
				IF ch == "-" .AND. SUBSTR(src,I+1,1) == "-" .AND. SUBSTR(src,I+2,1) == ">"
					I += 2
					iscomment := .F.
					istag := .F.
					tagend := I
					AADD(html,SUBSTR(src,tagbegin,tagend-tagbegin+1))
				ENDIF
			ELSE
				IF !istag
					IF ch == "<"
						istag := .T.
						tagbegin := I
						term := SUBSTR(src,tagend+1,tagbegin-tagend-1)
						IF LEN(term) > 0
							AADD(html,term)
						ENDIF
						IF SUBSTR(src,I+1,1) == "!" .AND. SUBSTR(src,I+2,1) == "-" .AND.;
							SUBSTR(src,I+3,1) == "-"

							iscomment := .T.
						ENDIF
					ENDIF
				ELSE
					IF ch == ">"
						istag := .F.
						tagend := I
						term := SUBSTR(src,tagbegin,tagend-tagbegin+1)
						AADD(html,term)
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		IF ch == '"' .AND. SUBSTR(src,MAX(I-1,1),1) != "\"
			isquote := !isquote
		ENDIF
	NEXT
	AADD(html,SUBSTR(src,MAX(tagbegin,tagend+1)))

	FOR I:=1 TO LEN(html)
		IF LEFT(html[I],2) == "<!" .AND.;
			UPPER(LEFT(LTRIM(SUBSTR(html[I],3)),3)) == "SQL"

			ParseCommand(I)
		ELSEIF LEFT(html[I],4) == "<!--"
			IF UPPER(LEFT(LTRIM(SUBSTR(html[I],5)),8)) == "CLIPFUNC"
				pos := AT("CLIPFUNC",UPPER(html[I]))
				tmp :=SUBSTR(html[I],pos+9)
				tmp := LEFT(tmp,LEN(tmp)-3)
				AADD(funcs,tmp)
			ELSEIF UPPER(LEFT(LTRIM(SUBSTR(html[I],5)),4)) == "CLIP"
				pos := AT("CLIP",UPPER(html[I]))
				tmp :=SUBSTR(html[I],pos+5)
				tmp := LEFT(tmp,LEN(tmp)-3)
				ToPrg(tmp+LF)
			ENDIF
		ELSE
			ToPrg('?? "'+Prepare(html[I])+'"'+LF)
		ENDIF
	NEXT

RETURN ret

FUNCTION Prepare(s)
	s := STRTRAN(s,'"','"+CHR(34)+"')
	s := STRTRAN(s,LF,'"+CHR(10)+"')
RETURN s

PROCEDURE ParseCommand(I,done,brk,nxt)
	LOCAL pos
	LOCAL tag
	LOCAL cmd
	LOCAL args
	LOCAL borders
	LOCAL tmp

	pos := AT("SQL",UPPER(html[I]))
	tag := SUBSTR(html[I],pos+4)
	tag := ALLTRIM(LEFT(tag,LEN(tag)-1))
	tag := STRTRAN(tag,CR,"")
	tag := STRTRAN(tag,LF," ")
	pos := AT(" ",tag)
	IF pos == 0
		cmd := UPPER(tag)
		args := ""
	ELSE
		cmd := UPPER(LEFT(tag,pos-1))
		args := ALLTRIM(SUBSTR(tag,pos+1))
	ENDIF

	DO CASE
		CASE cmd == "BREAK"
			ToPrg("EXIT"+LF)
		CASE cmd == "CONNECT"
			terms := ParseArgs(args)
			IF LEN(terms) == 0
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			rdbms := terms[1]
			host := IF(LEN(terms)>1,terms[2],"NIL")
			login := IF(LEN(terms)>2,terms[3],"NIL")
			passwd := IF(LEN(terms)>3,terms[4],"NIL")
			host := IF(host=="NIL" .OR. host=="",'NIL','"'+host+'"')
			login := IF(login=="NIL" .OR. login=="",'NIL','"'+login+'"')
			passwd := IF(passwd=="NIL" .OR. passwd=="",'NIL','"'+passwd+'"')
			IF UPPER(rdbms) == "OR" .OR. UPPER(rdbms) == "MS"
				ToPrg('conn := ConnectNew("'+rdbms+'",NIL,NIL,'+login+;
					','+passwd+')'+LF)
			ENDIF
		CASE cmd == "CLOSE"
			ToPrg("conn:Destroy()"+LF)
		CASE cmd == "CONTINUE"
			ToPrg("CONTINUE"+LF)
		CASE cmd == "CONVERT"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ToPrg('vars:'+terms[1]+' := XTOC(vars:'+terms[1]+')'+LF)
		CASE cmd == "DATABASE"
			terms := ParseArgs(args)
			IF LEN(terms) == 0
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			IF rdbms == "PG"
				ToPrg('conn := ConnectNew("'+rdbms+'",NIL,NIL,'+login+;
					','+passwd+',"'+terms[1]+'")'+LF)
			ELSEIF rdbms == "MS"
				ToPrg('conn:Command("use '+terms[1]+'")'+LF)
			ENDIF
		CASE cmd == "EVAL"
			ToPrg("bl := &('{|| "+ParseExpr(args)+"}')"+LF)
			ToPrg('?? XTOC(Eval(bl))'+LF)
		CASE cmd == "EXEC"
			terms := ParseArgs(args)
			IF LEN(terms) == 0
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ToPrg('_err := ""'+LF)
			ToPrg('_res := ""'+LF)
			ToPrg('SYSCMD("'+args+'","",@_res,@_err)'+LF)
			ToPrg('?? _res'+LF)
		CASE cmd == "FETCH"
		CASE cmd == "FTIME"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			tmp := "0"
			IF LEN(terms) > 1
				tmp := terms[2]
			ENDIF
			ToPrg('?? STRFTIME("'+terms[1]+'",'+tmp+')'+LF)
		CASE cmd == "FREE"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ToPrg('_rs:'+terms[1]+':Destroy()'+LF)
		CASE cmd == "IF"
			ToPrg("IF "+ParseExpr(args)+LF)
		CASE cmd == "ELSEIF"
			ToPrg("ELSEIF "+ParseExpr(args)+LF)
		CASE cmd == "ELSE"
			ToPrg("ELSE"+LF)
		CASE cmd == "ENDIF"
			ToPrg("ENDIF"+LF)
		CASE cmd == "INCLUDE"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ParseFile(terms[1])
		CASE cmd == "PRINT"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			args := STRTRAN(terms[1],'\"','"')
			args := STRTRAN(args,"\n",LF)
			args := STRTRAN(args,"\t",CHR(9))
			args := STRTRAN(args,"\?","?")
			ToPrg('?? "'+ParseFields(Prepare(args),.F.)+'"'+LF)
		CASE cmd == "PRINT_LOOP"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ToPrg('_c:'+terms[1]+' := 1'+LF)
			ToPrg('DO WHILE _c:'+terms[1]+'<=_rs:'+terms[1]+':Lastrec()'+LF)
			ToPrg('_rs:'+terms[1]+':Goto(_c:'+terms[1]+')'+LF)
			ToPrg('_c:'+terms[1]+'++'+LF)
		CASE cmd == "PRINT_ROWS"
			terms := ParseArgs(args)
			IF LEN(terms) < 2
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			args := STRTRAN(terms[2],'\"','"')
			args := STRTRAN(args,"\n",LF)
			args := STRTRAN(args,"\t",CHR(9))
			args := STRTRAN(args,"\?","?")
			ToPrg('DO WHILE !_rs:'+terms[1]+':Eof()'+LF)
			ToPrg('?? "'+ParseFields(Prepare(args),.F.)+'"'+LF)
			ToPrg('_rs:'+terms[1]+':Skip()'+LF)
			ToPrg('ENDDO'+LF)
		CASE cmd == "QUERY"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			IF LEN(terms) == 1
				ToPrg('vars:AFFECTED_ROWS := conn:Command(ParseQuery("'+;
					terms[1]+'"))'+LF)
			ELSE
				ToPrg('_rs:'+terms[2]+' := conn:CreateRowset(ParseQuery("'+;
					terms[1]+'"))'+LF)
				ToPrg('vars:NUM_FIELDS := _rs:'+terms[2]+':NFields()'+LF)
				ToPrg('vars:NUM_ROWS := _rs:'+terms[2]+':Lastrec()'+LF)
			ENDIF
		CASE cmd == "QTABLE"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			borders := .F.
			IF LEN(terms) > 1 .AND. UPPER(terms[2]) == "BORDERS"
				borders := .T.
			ENDIF
			ToPrg('?? "<table'+IF(borders,' border','')+;
				'><caption align=high></caption>"'+LF)
			ToPrg('? "<tr>"'+LF)
			ToPrg('FOR _I:= 1 TO _rs:'+terms[1]+':NFields()'+LF)
			ToPrg('?? "<th align=right>"'+LF)
			ToPrg('?? _rs:'+terms[1]+':FieldName(_I)'+LF)
			ToPrg('?? "</th>"'+LF)
			ToPrg('NEXT'+LF)
			ToPrg('?? "</tr>"'+LF)
			ToPrg('_rec:'+terms[1]+' := _rs:'+terms[1]+':Recno()'+LF)
			ToPrg('_rs:'+terms[1]+':Gotop()'+LF)
			ToPrg('DO WHILE !_rs:'+terms[1]+':Eof()'+LF)
			ToPrg('? "<tr>"'+LF)
			ToPrg('_data:'+terms[1]+' := _rs:'+terms[1]+':Read()'+LF)
			ToPrg('FOR _I:=1 TO _rs:'+terms[1]+':NFields()'+LF)
			ToPrg('?? "<td align=right>"'+LF)
			ToPrg('?? XTOC(_data:'+terms[1]+'[HASHSTR(UPPER(_rs:'+terms[1]+':FieldName(_I)))])'+LF)
			ToPrg('?? "</td>"'+LF)
			ToPrg('NEXT'+LF)
			ToPrg('?? "</tr>"'+LF)
			ToPrg('_rs:'+terms[1]+':Skip()'+LF)
			ToPrg('ENDDO'+LF)
			ToPrg('_rs:'+terms[1]+':Goto(_rec:'+terms[1]+')'+LF)
			ToPrg('? "</table>"'+LF)
		CASE cmd == "QLONGFORM"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ToPrg('_rec:'+terms[1]+' := _rs:'+terms[1]+':Recno()'+LF)
			ToPrg('_rs:'+terms[1]+':GoTop()'+LF)
			ToPrg('DO WHILE !_rs:'+terms[1]+':Eof()'+LF)
			ToPrg('_data:'+terms[1]+' := _rs:'+terms[1]+':Read()'+LF)
			ToPrg('FOR _I:=1 TO _rs:'+terms[1]+':NFields()'+LF)
			ToPrg('? "<b>"+_rs:'+terms[1]+':FieldName(_I)+":</b> "'+LF)
			ToPrg('?? _data:'+terms[1]+'[HASHSTR(UPPER(_rs:'+terms[1]+':FieldName(_I)))]'+LF)
			ToPrg('?? "<br>"'+LF)
			ToPrg('NEXT'+LF)
			ToPrg('?? "<p>"'+LF)
			ToPrg('_rs:'+terms[1]+':Skip()'+LF)
			ToPrg('ENDDO'+LF)
			ToPrg('_rs:'+terms[1]+':Goto(_rec:'+terms[1]+')'+LF)
		CASE cmd == "QSELECT"
			terms := ParseArgs(args)
			IF LEN(terms) < 2
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ToPrg('_rec:'+terms[1]+' := _rs:'+terms[1]+':Recno()'+LF)
			ToPrg("?? '<select name="+CHR(34)+terms[2]+CHR(34)+">'+CHR(10)"+LF)
			ToPrg('DO WHILE !_rs:'+terms[1]+':Eof()'+LF)
			ToPrg('_data:'+terms[1]+' := _rs:'+terms[1]+':Read()'+LF)
			ToPrg('?? "<option value="+CHR(34)+'+'XTOC(_data:'+terms[1]+;
				'[HASHSTR(UPPER(_rs:'+terms[1]+':FieldName(1)))])+CHR(34)'+LF)
			IF LEN(terms) > 2
				ToPrg('IF XTOC(_data:'+terms[1]+'[HASHSTR(UPPER(_rs:'+terms[1]+;
					':FieldName(1)))]) == "'+terms[3]+'"'+LF)
				ToPrg('?? " selected"'+LF)
				ToPrg('ENDIF'+LF)
			ENDIF
			ToPrg('?? ">"+XTOC(_data:'+terms[1]+'[HASHSTR(UPPER(_rs:'+terms[1]+;
				':FieldName(2)))])+CHR(10)'+LF)
			ToPrg('_rs:'+terms[1]+':Skip()'+LF)
			ToPrg('ENDDO'+LF)
			ToPrg('?? "</select>"'+LF)
			ToPrg('_rs:'+terms[1]+':Goto(_rec:'+terms[1]+')'+LF)
		CASE cmd == "SEEK"
			terms := ParseArgs(args)
			IF LEN(terms) < 2
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ToPrg('_rs:'+terms[1]+':Goto('+terms[2]+')'+LF)
		CASE cmd == "SET" .OR. cmd == "SETEXPR"
			terms := ParseArgs(args)
			IF LEN(terms) < 2
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			pos := AT(" ",args)
			args := "vars:"+STUFF(args,pos,1,":=")
			ToPrg(ParseExpr(args)+LF)
		CASE cmd == "SETDEFAULT"
			terms := ParseArgs(args)
			IF LEN(terms) <2
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			pos := AT(" ",args)
			args := "vars:"+STUFF(args,pos,1,":=")
			ToPrg('IF vars:'+terms[1]+'==NIL'+LF)
			ToPrg(ParseExpr(args)+LF)
			ToPrg('ENDIF'+LF)
		CASE cmd == "WHILE"
			terms := ParseArgs(args)
			IF LEN(terms) < 1
				? html[I]+": too few arguments"
				RETURN
			ENDIF
			ToPrg('DO WHILE '+ParseExpr(args)+LF)
		CASE cmd == "DONE"
			ToPrg('ENDDO'+LF)
		OTHERWISE
	ENDCASE

RETURN

FUNCTION XTOC(x)
	IF VALTYPE(x) == "C"
		RETURN x
	ELSEIF VALTYPE(x) == "N"
		RETURN ALLTRIM(STR(x))
	ELSEIF VALTYPE(x) == "D"
		RETURN DTOC(x)
	ELSEIF VALTYPE(x) == "L"
		RETURN IF(x,"TRUE","FALSE")
	ENDIF
RETURN "---"

FUNCTION ParseFields(pat,expr)
	LOCAL ret := ""
	LOCAL qpos,fpos
	LOCAL ch
	LOCAL I
	LOCAL tmp
	LOCAL data
	LOCAL r
	LOCAL fname
	LOCAL getfield

	pat := STRTRAN(pat,"\$",CHR(1))
	pat := STRTRAN(pat,"\@",CHR(2))
	pat := STRTRAN(pat,"\#",CHR(3))
	IF !expr
		DO WHILE (qpos := AT("$",pat)) != 0
			I := qpos+1
			ch := SUBSTR(pat,I,1)
			DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
				I++
				ch := SUBSTR(pat,I,1)
			ENDDO
			pat := STUFF(pat,qpos,I-qpos,'"+XTOC(vars:'+SUBSTR(pat,qpos+1,I-qpos-1)+')+"')
		ENDDO
		DO WHILE (qpos := AT("#",pat)) != 0
			I := qpos+1
			ch := SUBSTR(pat,I,1)
			DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
				I++
				ch := SUBSTR(pat,I,1)
			ENDDO
			pat := STUFF(pat,qpos,I-qpos,'"+URLEncode(XTOC(vars:'+SUBSTR(pat,qpos+1,I-qpos-1)+'))+"')
		ENDDO
	ENDIF
	DO WHILE (qpos := AT("@",pat)) != 0
		ret += SUBSTR(pat,1,qpos-1)
		fpos := qpos+1
		DO WHILE SUBSTR(pat,fpos,1) != "."
			fpos++
		ENDDO
		r := SUBSTR(pat,qpos+1,fpos-qpos-1)
		I := fpos+1
		ch := SUBSTR(pat,I,1)
		DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
			I++
			ch := SUBSTR(pat,I,1)
		ENDDO
		tmp := SUBSTR(pat,fpos+1,I-fpos-1)
		IF ISALPHA(tmp)
			getfield := 'GetFieldValue("'+r+'","'+tmp+'")'
		ELSE
			getfield := 'GetFieldValue("'+r+'",'+tmp+')'
		ENDIF
		IF !expr
			getfield := '"+XTOC('+getfield+')+"'
		ENDIF
		ret += getfield
		pat := SUBSTR(pat,I)
	ENDDO
	ret += pat
	pat := ret
	ret := ""
	DO WHILE (qpos := AT("#",pat)) != 0
		ret += SUBSTR(pat,1,qpos-1)
		fpos := qpos+1
		DO WHILE SUBSTR(pat,fpos,1) != "."
			fpos++
		ENDDO
		r := SUBSTR(pat,qpos+1,fpos-qpos-1)
		I := fpos+1
		ch := SUBSTR(pat,I,1)
		DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
			I++
			ch := SUBSTR(pat,I,1)
		ENDDO
		tmp := SUBSTR(pat,fpos+1,I-fpos-1)
		IF ISALPHA(tmp)
			getfield := 'GetFieldValue("'+r+'","'+tmp+'")'
		ELSE
			getfield := 'GetFieldValue("'+r+'",'+tmp+')'
		ENDIF
		IF !expr
			getfield := '"+URLEncode(XTOC('+getfield+'))+"'
		ENDIF
		ret += getfield
		pat := SUBSTR(pat,I)
	ENDDO

	ret += pat
	ret := STRTRAN(ret,CHR(1),"$")
	ret := STRTRAN(ret,CHR(2),"@")
	ret := STRTRAN(ret,CHR(3),"#")
RETURN ret

FUNCTION ParseArgs(args,leftquotes)
	LOCAL terms := ARRAY(0)
	LOCAL len := LEN(args)
	LOCAL I
	LOCAL isquote := .F.
	LOCAL termbegin := 0
	LOCAL termend := 0
	LOCAL ch
	LOCAL tmp
	LOCAL wordbegin := 1
	LOCAL bb := 1
	LOCAL ee := -1

	IF leftquotes != NIL .AND. leftquotes
		bb := 0
		ee := 1
	ENDIF
	FOR I:=1 TO len
		ch := SUBSTR(args,I,1)
		IF isquote
			IF ch=='"' .AND. SUBSTR(args,I-1,1) != "\"
				isquote := .F.
				AADD(terms,SUBSTR(args,wordbegin+bb,I-wordbegin+ee))
				I++
				DO WHILE I < len .AND. SUBSTR(args,I,1) == " "
					I++
				ENDDO
				wordbegin := I
				I--
			ENDIF
		ELSE
			IF ch=='"'
				tmp := ALLTRIM(SUBSTR(args,wordbegin,I-wordbegin))
				IF tmp != ""
					AADD(terms,tmp)
				ENDIF
				isquote := .T.
				wordbegin := I
			ELSEIF ch==" "
				tmp := ALLTRIM(SUBSTR(args,wordbegin,I-wordbegin))
				IF tmp != ""
					AADD(terms,ALLTRIM(SUBSTR(args,wordbegin,I-wordbegin)))
				ENDIF
				DO WHILE I < len .AND. SUBSTR(args,I,1) == " "
					I++
				ENDDO
				wordbegin := I
				I--
			ENDIF
		ENDIF
	NEXT
	tmp := ALLTRIM(SUBSTR(args,wordbegin))
	IF tmp != ""
		AADD(terms,tmp)
	ENDIF
RETURN terms

FUNCTION ParseExpr(args)
	LOCAL ret := ""
	LOCAL terms
	LOCAL I
	LOCAL tmp

	args := ParseFields(args,.T.)
	terms := ParseArgs(args,.T.)

	FOR I:=1 TO LEN(terms)
		ParseColon(terms,I)
	NEXT
	args := STRTRAN(args,"\$",CHR(1))
	args := STRTRAN(args,"\@",CHR(2))
	args := STRTRAN(args,"\#",CHR(3))
	FOR I:=1 TO LEN(terms)
		IF terms[I] != NIL
			IF LEFT(terms[I],1) != '"'
				tmp := STRTRAN(terms[I],"&&"," .AND. ")
				tmp := STRTRAN(tmp,"&"," .AND. ")
				tmp := STRTRAN(tmp,"||"," .OR. ")
				tmp := STRTRAN(tmp,"|"," .OR. ")
				tmp := STRTRAN(tmp,"$","vars:")
				ret += tmp + " "
			ELSE
				tmp := STRTRAN(terms[I],'\"','"+CHR(34)+"')
				tmp := STRTRAN(tmp,"\t",'"+CHR(9)+"')
				tmp := STRTRAN(tmp,"\n",'"+CHR(10)+"')
				ret += tmp + " "
			ENDIF
		ENDIF
	NEXT
	ret := STRTRAN(ret,CHR(1),"$")
	ret := STRTRAN(ret,CHR(2),"@")
	ret := STRTRAN(ret,CHR(3),"#")
RETURN ret

PROCEDURE ParseColon(terms,I)
	LOCAL string
	LOCAL pattern

	IF terms[I] != NIL .AND. LTRIM(terms[I]) == ":" .AND.;
		I > 1 .AND. I < LEN(terms)

		string := terms[I-1]
		string := SUBSTR(string,2,LEN(string)-2)
		pattern := terms[I+1]
		pattern := SUBSTR(pattern,2,LEN(pattern)-2)
		terms[I-1] := NIL
		terms[I+1] := NIL
		terms[I] := "Regul("+'"'+pattern+'"'+","+'"'+string+'"'+")"
	ENDIF
RETURN

FUNCTION Regul(pattern,string)
	LOCAL reg := ARRAY(0)

	IF SEARCH(pattern,string,reg)
		RETURN reg[1][1]
	ENDIF
RETURN 0

PROCEDURE ParseParameters(pars)
	LOCAL pos
	LOCAL tmp
	LOCAL var

	pars := STRTRAN(pars,"+"," ")
	URLDecode(@pars)
	DO WHILE (pos := AT("&",pars)) != 0
		tmp := ALLTRIM(SUBSTR(pars,1,pos-1))
		pos := AT("=",tmp)
		var := SUBSTR(tmp,pos+1)
		var := IF(LEN(var)==0,NIL,var)
		var := IF(var=="---",NIL,var)
		IF var != NIL .AND. ISDIGIT(var)
			var := VAL(var)
		ENDIF
		vars[HASHSTR(UPPER(SUBSTR(tmp,1,pos-1)))] := var
		pars := SUBSTR(pars,LEN(tmp)+2)
	ENDDO
	tmp := pars
	pos := AT("=",tmp)
	var := SUBSTR(tmp,pos+1)
	var := IF(LEN(var)==0,NIL,var)
	var := IF(var=="---",NIL,var)
	IF var != NIL .AND. ISDIGIT(var)
		var := VAL(var)
	ENDIF
	vars[HASHSTR(UPPER(SUBSTR(tmp,1,pos-1)))] := var
RETURN

FUNCTION URLDecode(s)
	LOCAL pos

	DO WHILE (pos := AT("%",s)) != 0
		s := STUFF(s,pos,3,CHR(CTON(SUBSTR(s,pos+1,2),16)))
	ENDDO
RETURN s

FUNCTION URLEncode(s)
	LOCAL I := 1
	LOCAL ch
	LOCAL ret := ""
	LOCAL len := LEN(s)

	FOR I:=1 TO len
		IF (ch := SUBSTR(s,I,1)) > CHR(127)
			ret += "%"+NTOC(ASC(ch),16)
		ELSE
			ret += ch
		ENDIF
	NEXT
RETURN ret
