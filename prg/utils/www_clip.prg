/*
    Copyright (C) 2001  ITK
    Autor   : Rust (rust@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
#define CR			CHR(13)
#define LF			CHR(10)
#define CHUNKSIZE	1024

PROCEDURE Main()

	LOCAL srcfile
	LOCAL conn

	PRIVATE vars := GETENV()
	PUBLIC recurse := -1
	PUBLIC stopparsing := .F.

	set translate off

	ErrorBlock({|e| BREAK(e)})

	vars:WWW_CLIP_VERSION   := "0.0.1"
	?? "Content-type: text/html"
	? "Generator: WWW-Clip Version "+vars:WWW_CLIP_VERSION
	?

	srcfile := vars:PATH_TRANSLATED

	? ParseFile(srcfile)

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
	LOCAL ret := ""
	LOCAL done := .F.
	LOCAL brk := .F.
	LOCAL nxt := .F.
	LOCAL pars := ""
	LOCAL ch

	PRIVATE html := ARRAY(0)
	PRIVATE ifdeep := 0
	PRIVATE ifyes := ARRAY(100)
	PRIVATE ifanyyes := ARRAY(100)
	PRIVATE whiledeep := 0
	PRIVATE whilestack := ARRAY(100)
	PRIVATE whileyes := ARRAY(100)
	PRIVATE conn := NIL
	PRIVATE rdbms
	PRIVATE host
	PRIVATE login
	PRIVATE passwd
	PRIVATE rs := map()

	recurse++
	IF recurse >= 10
		recurse--
		RETURN ret
	ENDIF

	AFILL(whilestack,0)
	IF vars:REQUEST_METHOD == "GET"
		pars := vars:QUERY_STRING
	ELSE
		fd := FOPEN("-|",0)
		DO WHILE (read := FREAD(fd,@chunk,CHUNKSIZE)) == CHUNKSIZE
			pars += chunk
			chunk := SPACE(CHUNKSIZE)
		ENDDO
		pars += LEFT(chunk,read)
		FCLOSE(fd)
	ENDIF

	ParseParameters(pars)

	fd := FOPEN(srcfile,0)
	IF fd == -1
		recurse--
		RETURN "File not found"
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
			IF !istag
				IF ch == "<"
					istag := .T.
					tagbegin := I
					term := SUBSTR(src,tagend+1,tagbegin-tagend-1)
					IF LEN(term) > 0
						AADD(html,term)
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
		IF ch == '"' .AND. SUBSTR(src,MAX(I-1,1),1) != "\"
			isquote := !isquote
		ENDIF
	NEXT
	AADD(html,SUBSTR(src,MAX(tagbegin,tagend+1)))

	FOR I:=1 TO LEN(html)
		IF stopparsing
			EXIT
		ENDIF
		IF LEFT(html[I],2) == "<!" .AND.;
			UPPER(LEFT(LTRIM(SUBSTR(html[I],3)),3)) == "SQL"

			done := .F.
			brk := .F.
			nxt := .F.
			ret += ParseCommand(I,@done,@brk,@nxt)
			IF done
				IF whileyes[whiledeep]
					I := whilestack[whiledeep]-1
				ELSE
					whilestack[whiledeep] := 0
					whiledeep--
				ENDIF
			ELSEIF brk
				whileyes[whiledeep] := .F.
			ELSEIF nxt
				I := whilestack[whiledeep]-1
			ENDIF
		ELSE
			IF (ifdeep == 0 .OR. ifyes[ifdeep]) .AND.;
				(whiledeep == 0 .OR. whileyes[whiledeep])

				ret += html[I]
			ENDIF
		ENDIF
	NEXT
	recurse--

RETURN ret

FUNCTION ParseCommand(I,done,brk,nxt)

	LOCAL ret := ""
	LOCAL pos
	LOCAL tag
	LOCAL cmd
	LOCAL args
	LOCAL bl
	LOCAL tmp
	LOCAL mkeys
	LOCAL J
	LOCAL terms
	LOCAL data
	LOCAL query
	LOCAL r
	LOCAL borders
	LOCAL rec
	LOCAL err

BEGIN SEQUENCE
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
	IF ((ifdeep == 0 .OR. ifyes[ifdeep]) .OR.;
		(cmd == "IF" .OR. cmd == "ENDIF" .OR. cmd == "ELSEIF" .OR. cmd == "ELSE"));
		.AND. (whiledeep == 0 .OR. whileyes[whiledeep] .OR. cmd == "WHILE" .OR. cmd == "DONE")

		DO CASE
			CASE cmd == "BREAK"
				whileyes[whiledeep] := .F.
				brk := .T.
			CASE cmd == "CONNECT"
				terms := ParseArgs(args)
				IF LEN(terms) == 0
					RETURN "<p>connect: too few arguments</p>"+LF
				ENDIF
				rdbms := terms[1]
				host := IF(LEN(terms)>1,terms[2],NIL)
				login := IF(LEN(terms)>2,terms[3],NIL)
				passwd := IF(LEN(terms)>3,terms[4],NIL)
				host := IF(host=="NIL" .OR. host=="",NIL,host)
				login := IF(login=="NIL" .OR. login=="",NIL,login)
				passwd := IF(passwd=="NIL" .OR. passwd=="",NIL,passwd)
				IF UPPER(rdbms) == "OR" .OR. UPPER(rdbms) == "MS"
					conn := ConnectNew(rdbms,NIL,NIL,login,passwd)
				ENDIF
			CASE cmd == "CLIP"
			CASE cmd == "CLOSE"
				conn:Destroy()
			CASE cmd == "CONTINUE"
				nxt := .T.
			CASE cmd == "CONVERT"
				terms := ParseArgs(args)
				IF LEN(terms) < 1
					RETURN "<p>convert: too few arguments</p>"+LF
				ENDIF
				vars[HASHSTR(UPPER(terms[1]))] :=;
					XTOC(vars[HASHSTR(UPPER(terms[1]))])
			CASE cmd == "DATABASE"
				terms := ParseArgs(args)
				IF LEN(terms) == 0
					RETURN "<p>database: too few arguments</p>"+LF
				ENDIF
				IF rdbms == "PG"
					conn := ConnectNew(rdbms,host,NIL,login,passwd,terms[1])
				ELSEIF rdbms == "MS"
					conn:Command("use "+terms[1])
				ENDIF
			CASE cmd == "EVAL"
				IF LEN(args)==0
					RETURN "<p>eval: too few arguments</p>"+LF
				ENDIF
				ret := DoEval(ParseExpr(args))
			CASE cmd == "EXEC"
				IF LEN(args)==0
					RETURN "<p>exec: too few arguments</p>"+LF
				ENDIF
				tmp := ""
				err := ""
				SYSCMD(args,"",@tmp,@err)
				ret := tmp
			CASE cmd == "FETCH"
				RETURN ret
			CASE cmd == "FTIME"
				terms := ParseArgs(args)
				IF LEN(terms) < 1
					RETURN "<p>ftime: too few arguments</p>"+LF
				ENDIF
				tmp := 0
				IF LEN(terms) > 1
					tmp := VAL(terms[2])
				ENDIF
				ret += STRFTIME(terms[1],tmp)
			CASE cmd == "FREE"
				terms := ParseArgs(args)
				IF LEN(terms) == 0
					RETURN "<p>free: too few arguments</p>"+LF
				ENDIF
				r := rs[HASHSTR(UPPER(terms[1]))]
				r:Destroy()
			CASE cmd == "IF"
				IF LEN(args)==0
					RETURN "<p>if: too few arguments</p>"+LF
				ENDIF
				tmp := DoEval(ParseExpr(args))
				IF tmp != "0" .AND. tmp != "1"
					RETURN tmp
				ENDIF
				ifdeep++
				IF ifdeep == 1 .OR. ifyes[ifdeep-1]
					ifanyyes[ifdeep] := ifyes[ifdeep] := (tmp != "0")
				ELSE
					ifyes[ifdeep] := .F.
				ENDIF
			CASE cmd == "ELSEIF"
				IF LEN(args)==0
					RETURN "<p>elseif: too few arguments</p>"+LF
				ENDIF
				IF ifdeep == 1 .OR. ifyes[ifdeep-1]
					IF !ifyes[ifdeep]
						tmp := DoEval(ParseExpr(args))
						IF tmp != "0" .AND. tmp != "1"
							ret += tmp
						ENDIF
						ifanyyes[ifdeep] := ifyes[ifdeep] := (tmp != "0")
					ELSE
						ifyes[ifdeep] := .F.
					ENDIF
				ELSE
					ifyes[ifdeep] := .F.
				ENDIF
			CASE cmd == "ELSE"
				IF ifdeep == 1 .OR. ifyes[ifdeep-1]
					ifyes[ifdeep] := !ifanyyes[ifdeep]
				ELSE
					ifyes[ifdeep] := .F.
				ENDIF
			CASE cmd == "ENDIF"
				ifdeep--
			CASE cmd == "INCLUDE"
				terms := ParseArgs(args)
				IF LEN(terms)<1
					RETURN "<p>include: too few arguments</p>"+LF
				ENDIF
				ret := ParseFile(terms[1])
			CASE cmd == "PRINT"
				terms := ParseArgs(args)
				IF LEN(terms) < 0
					RETURN "<p>print: too few arguments</p>"+LF
				ENDIF
				args := STRTRAN(terms[1],'\"','"')
				args := STRTRAN(args,"\n",LF)
				args := STRTRAN(args,"\t",CHR(9))
				args := STRTRAN(args,"\?","?")
				ret := ParseFields(args,.F.)
			CASE cmd == "PRINT_LOOP"
				terms := ParseArgs(args)
				IF LEN(terms)<1
					RETURN "<p>print_loop: too few arguments</p>"+LF
				ENDIF
				r := rs[HASHSTR(UPPER(terms[1]))]
				IF whiledeep == 0 .OR. whilestack[whiledeep] != I
					whiledeep++
					whilestack[whiledeep] := I
				ELSE
					r:Skip()
				ENDIF
				whileyes[whiledeep] := !r:Eof()
			CASE cmd == "PRINT_ROWS"
				terms := ParseArgs(args)
				IF LEN(terms)<2
					RETURN "<p>print_rows: too few arguments</p>"+LF
				ENDIF
				r := rs[HASHSTR(UPPER(terms[1]))]
				terms[2] := STRTRAN(terms[2],'\"','"')
				terms[2] := STRTRAN(terms[2],"\n",LF)
				terms[2] := STRTRAN(terms[2],"\t",CHR(9))
				DO WHILE !r:Eof()
					ret += ParseFields(terms[2],.F.)
					r:Skip()
				ENDDO
			CASE cmd == "QUERY"
				terms := ParseArgs(args)
				IF LEN(terms)<1
					RETURN "<p>query: too few arguments</p>"+LF
				ENDIF
				query := ParseQuery(terms[1])
				IF LEN(terms) == 1
					vars:AFFECTED_ROWS := conn:Command(query)
				ELSE
					r := rs[HASHSTR(UPPER(terms[2]))] :=;
						conn:CreateRowset(query)
					vars:NUM_FIELDS := r:NFields()
					vars:NUM_ROWS := r:Lastrec()
				ENDIF
			CASE cmd == "QTABLE"
				terms := ParseArgs(args)
				IF LEN(terms)<1
					RETURN "<p>qtable: too few arguments</p>"+LF
				ENDIF
				borders := .F.
				IF LEN(terms)>1 .AND. UPPER(terms[2]) == "BORDERS"
					borders := .T.
				ENDIF
				r := rs[HASHSTR(UPPER(terms[1]))]
				ret := "<table"+IF(borders," border","")+;
					"><caption align=high></caption>"+LF
				ret += "<tr>"
				FOR J:=1 TO r:NFields()
					ret += "<th align=right>"
					ret += r:FieldName(J)
					ret += "</th>"
				NEXT
				ret += "</tr>"+LF
				rec := r:Recno()
				r:GoTop()
				DO WHILE !r:Eof()
					ret += "<tr>"
					data := r:Read()
					FOR J:=1 TO r:NFields()
						ret += "<td align=right>"
						tmp := data[HASHSTR(UPPER(r:FieldName(J)))]
						ret += XTOC(tmp)
						ret += "</td>"
					NEXT
					ret += "</tr>"+LF
					r:Skip()
				ENDDO
				r:Goto(rec)
				ret += "</table>"
			CASE cmd == "QLONGFORM"
				terms := ParseArgs(args)
				IF LEN(terms)<1
					RETURN "<p>qlongform: too few arguments</p>"+LF
				ENDIF
				r := rs[HASHSTR(UPPER(terms[1]))]
				rec := r:Recno()
				r:GoTop()
				DO WHILE !r:Eof()
					data := r:Read()
					FOR J:=1 TO r:NFields()
						ret += "<b>"+r:FieldName(J)+":</b> "
						tmp := data[HASHSTR(UPPER(r:FieldName(J)))]
						ret += XTOC(tmp)
						ret += "<br>"+LF
					NEXT
					ret += "<p>"+LF
					r:Skip()
				ENDDO
				r:Goto(rec)
			CASE cmd == "QSELECT"
				terms := ParseArgs(args)
				IF LEN(terms)<2
					RETURN "<p>qselect: too few arguments</p>"+LF
				ENDIF
				ret += '<select name="' + terms[2] + '">'+LF
				r := rs[HASHSTR(UPPER(terms[1]))]
				rec := r:Recno()
				r:GoTop()
				DO WHILE !r:Eof()
					data := r:Read()
					tmp := XTOC(data[HASHSTR(UPPER(r:FieldName(1)))])
					ret += '<option value="'+tmp+'"'
					IF LEN(terms) > 2 .AND. tmp==terms[3]
						ret += " selected"
					ENDIF
					tmp := XTOC(data[HASHSTR(UPPER(r:FieldName(2)))])
					ret += ">"+tmp+LF
					r:Skip()
				ENDDO
				r:Goto(rec)
				ret += "</select>"+LF
			CASE cmd == "SEEK"
				terms := ParseArgs(args)
				IF LEN(terms)<2
					RETURN "<p>seek: too few arguments</p>"+LF
				ENDIF
				r := rs[HASHSTR(UPPER(terms[1]))]
				pos := VAL(terms[2])
				r:Goto(pos)
			CASE cmd == "SET" .OR. cmd == "SETEXPR"
				terms := ParseArgs(args)
				IF LEN(terms)<2
					RETURN "<p>set: too few arguments</p>"+LF
				ENDIF
				pos := AT(" ",args)
				tmp := "vars:"+STUFF(args,pos,1,":=")
				DoEval(ParseExpr(tmp))
			CASE cmd == "SETDEFAULT"
				terms := ParseArgs(args)
				IF LEN(terms)<2
					RETURN "<p>setdefault: too few arguments</p>"+LF
				ENDIF
				pos := AT(" ",args)
				tmp := HASHSTR(UPPER(SUBSTR(args,1,pos-1)))
				mkeys := MAPKEYS(vars)
				FOR J:=1 TO LEN(mkeys)
					IF mkeys[J] == tmp
						RETURN ret
					ENDIF
				NEXT
				pos := AT(" ",args)
				tmp := "vars:"+STUFF(args,pos,1,":=")
				DoEval(tmp)
			CASE cmd == "WHILE"
				IF LEN(args)==0
					RETURN "<p>while: too few arguments</p>"+LF
				ENDIF
				tmp := DoEval(ParseExpr(args))
				IF whiledeep == 0 .OR. whilestack[whiledeep]!=I
					whiledeep++
					whilestack[whiledeep] := I
				ENDIF
				whileyes[whiledeep] := (tmp != "0")
			CASE cmd == "DONE"
				done := .T.
			OTHERWISE
				ret := "<p><b>Unknown command:</b> "+tag+" </p>"+LF
		ENDCASE
	ENDIF
RECOVER USING e
	ret := "<br>WWWClip: Error in tag <b>&lt;"+;
		SUBSTR(html[I],2,LEN(html[I])-2)+"&gt;:</b><br>"+;
		"operation:"+e:operation+"<br>"+;
		"description:"+e:description+"<br>"+LF
	stopparsing := .T.
END SEQUENCE

RETURN ret

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

FUNCTION ParseQuery(pat)
	LOCAL ret
	LOCAL qpos
	LOCAL ch
	LOCAL I
	LOCAL tmp

	DO WHILE (qpos := AT("?",pat)) != 0
		I := qpos+1
		ch := SUBSTR(pat,I,1)
		DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
			I++
			ch := SUBSTR(pat,I,1)
		ENDDO
		tmp := XTOC(vars[HASHSTR(UPPER(SUBSTR(pat,qpos+1,I-qpos-1)))])
		pat := STUFF(pat,qpos,I-qpos,tmp)
	ENDDO
	DO WHILE (qpos := AT("$",pat)) != 0
		I := qpos+1
		ch := SUBSTR(pat,I,1)
		DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
			I++
			ch := SUBSTR(pat,I,1)
		ENDDO
		tmp := XTOC(vars[HASHSTR(UPPER(SUBSTR(pat,qpos+1,I-qpos-1)))])
		pat := STUFF(pat,qpos,I-qpos,tmp)
	ENDDO
RETURN pat

FUNCTION ParseFields(pat,expr)
	LOCAL ret := ""
	LOCAL qpos,fpos
	LOCAL ch
	LOCAL I
	LOCAL tmp
	LOCAL data
	LOCAL r
	LOCAL fval

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
			tmp := XTOC(vars[HASHSTR(UPPER(SUBSTR(pat,qpos+1,I-qpos-1)))])
			pat := STUFF(pat,qpos,I-qpos,tmp)
		ENDDO
		DO WHILE (qpos := AT("#",pat)) != 0
			I := qpos+1
			ch := SUBSTR(pat,I,1)
			DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
				I++
				ch := SUBSTR(pat,I,1)
			ENDDO
			tmp := URLEncode(XTOC(vars[HASHSTR(UPPER(SUBSTR(pat,qpos+1,I-qpos-1)))]))
			pat := STUFF(pat,qpos,I-qpos,tmp)
		ENDDO
	ENDIF
	DO WHILE (qpos := AT("@",pat)) != 0
		ret += SUBSTR(pat,1,qpos-1)
		fpos := qpos+1
		DO WHILE SUBSTR(pat,fpos,1) != "."
			fpos++
		ENDDO
		r := rs[HASHSTR(UPPER(SUBSTR(pat,qpos+1,fpos-qpos-1)))]
		data := r:Read()
		I := fpos+1
		ch := SUBSTR(pat,I,1)
		DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
			I++
			ch := SUBSTR(pat,I,1)
		ENDDO
		tmp := SUBSTR(pat,fpos+1,I-fpos-1)
		IF ISALPHA(tmp)
			fval := data[HASHSTR(UPPER(tmp))]
		ELSE
			fval := data[HASHSTR(UPPER(r:FieldName(VAL(tmp)+1)))]
		ENDIF
		IF !expr .OR. VALTYPE(fval)=="N"
			ret += XTOC(fval)
		ELSE
			ret += '"'+XTOC(fval)+'"'
		ENDIF
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
		r := rs[HASHSTR(UPPER(SUBSTR(pat,qpos+1,fpos-qpos-1)))]
		data := r:Read()
		I := fpos+1
		ch := SUBSTR(pat,I,1)
		DO WHILE ISALPHA(ch) .OR. ISDIGIT(ch) .OR. ch $ "_-"
			I++
			ch := SUBSTR(pat,I,1)
		ENDDO
		tmp := SUBSTR(pat,fpos+1,I-fpos-1)
		IF ISALPHA(tmp)
			ret += URLEncode(XTOC(data[HASHSTR(UPPER(tmp))]))
		ELSE
			ret += URLEncode(XTOC(data[HASHSTR(UPPER(r:FieldName(VAL(tmp)+1)))]))
		ENDIF
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

FUNCTION DoEval(args)
	LOCAL ret
	LOCAL bl
	LOCAL tmp
	LOCAL typ

	bl := &("{|| "+args+"}")
	tmp := EVAL(bl)

	typ := VALTYPE(tmp)
	IF typ == "C"; ret := tmp
	ELSEIF typ == "N"; ret := LTRIM(STR(tmp))
	ELSEIF typ == "D"; ret := DTOC(tmp)
	ELSEIF typ == "L"; ret := IF(tmp,"1","0")
	ELSE; ret := "---"; ENDIF

RETURN ret

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
	s := STRTRAN(s,"+"," ")
RETURN s

FUNCTION URLEncode(s)
	LOCAL I := 1
	LOCAL ch
	LOCAL ret := ""
	LOCAL len := LEN(s)

	FOR I:=1 TO len
		ch := SUBSTR(s,I,1)
		IF ch == " "
			ret += "+"
		ELSEIF ASC(ch) > 32 .AND. ASC(ch) < 127
			ret += ch
		ELSE
			ret += "%"+NTOC(ASC(ch),16)
		ENDIF
	NEXT
RETURN ret
