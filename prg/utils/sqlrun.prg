/*
	Copyright (C) 2001  ITK
	Autor   : Rust (rust@itk.ru)
	Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
#include "inkey.ch"

#define LF CHR(10)
#define CHUNKSIZE 1024

memvar ep

PROCEDURE Main
	LOCAL srcfile := NIL
	LOCAL cfgfile := NIL
	LOCAL rdbms := NIL
	LOCAL host := NIL
	LOCAL login := NIL
	LOCAL passwd := NIL
	LOCAL dbname := NIL
	LOCAL c,e
	LOCAL cfg
	LOCAL lines
	LOCAL comments := ARRAY(0)
	LOCAL packs := ARRAY(0)
	LOCAL I := 1
	LOCAL ch

	PUBLIC ep

	ErrorBlock({|e| BREAK(e)})

	IF PARAM(1) == NIL .OR. PARAM(1) == "--help" .OR. PARAM(1) == "-?"
		Usage()
	ENDIF
	DO WHILE PARAM(I) != NIL
		DO CASE
			CASE PARAM(I) == "-c"
				cfgfile := PARAM(++I)
			CASE PARAM(I) == "-r"
				rdbms := PARAM(++I)
			CASE PARAM(I) == "-h"
				host := PARAM(++I)
			CASE PARAM(I) == "-l"
				login := PARAM(++I)
			CASE PARAM(I) == "-p"
				passwd := PARAM(++I)
			CASE PARAM(I) == "-d"
				dbname := PARAM(++I)
			OTHERWISE
				IF LEFT(PARAM(I),1) != "-"
					IF srcfile == NIL
						srcfile := PARAM(I)
					ENDIF
				ELSE
					Usage()
				ENDIF
		ENDCASE
		I++
	ENDDO
	IF srcfile == NIL
		?? "No script file (.sql) specified"
		?
		QUIT
	ENDIF
	cfg := ReadCfg(cfgfile)
	FOR I:=1 TO LEN(cfg)
		IF UPPER(LEFT(cfg[I],8)) == "COMMENT="
			AADD(comments,SUBSTR(cfg[I],9))
		ELSEIF UPPER(LEFT(cfg[I],6)) == "BEGIN="
			AADD(packs,SUBSTR(cfg[I],7))
		ELSEIF UPPER(LEFT(cfg[I],4)) == "END="
			ep := ALLTRIM(SUBSTR(cfg[I],5))
		ELSEIF UPPER(LEFT(cfg[I],6)) == "RDBMS=" .AND. rdbms == NIL
			rdbms := ALLTRIM(SUBSTR(cfg[I],7))
		ELSEIF UPPER(LEFT(cfg[I],5)) == "HOST=" .AND. host == NIL
			host := ALLTRIM(SUBSTR(cfg[I],6))
		ELSEIF UPPER(LEFT(cfg[I],6)) == "LOGIN=" .AND. login == NIL
			login := ALLTRIM(SUBSTR(cfg[I],7))
		ELSEIF UPPER(LEFT(cfg[I],7)) == "PASSWD=" .AND. passwd == NIL
			passwd := ALLTRIM(SUBSTR(cfg[I],8))
		ELSEIF UPPER(LEFT(cfg[I],3)) == "DB=" .AND. dbname == NIL
			dbname := ALLTRIM(SUBSTR(cfg[I],4))
		ENDIF
	NEXT
	lines := ReadFile(srcfile,comments,packs)
	c := ConnectNew(rdbms,host,,login,passwd,dbname)
	FOR I:=1 TO LEN(lines)
		? lines[I]
BEGIN SEQUENCE
		c:Command(lines[I])
RECOVER USING e
		? e:operation
		? "Continue? [Y,n]"
		inkey(0)
		IF !(UPPER(CHR(LASTKEY())) == "Y" .OR. LASTKEY() == K_RETURN)
			EXIT
		ENDIF
END SEQUENCE
	NEXT
	?
	c:Destroy()
RETURN

PROCEDURE Usage
	?? "SQLrun v0.0.1 (c) by ITK Ltd., by Rusty"
	?
	? "Usage: sqlrun <file.sql> [OPTIONS]"
	?
	? "OPTIONS:"
	? "  -?, --help    Display this screen"
	? "  -c            Specify config file"
	? "  -r            RDBMS to use"
	? "  -h            Host of server daemon to connect"
	? "  -l            Login to use with connection"
	? "  -p            Password to use with connection"
	? "  -d            Database name to use"
	?
	QUIT
RETURN

FUNCTION ReadCfg(owncfg)
	LOCAL fd
	LOCAL read
	LOCAL chunk := SPACE(CHUNKSIZE)
	LOCAL txt := ""
	LOCAL ar := ARRAY(0)
	LOCAL pos
	LOCAL cfgfile := SUBSTR(STARTPATH(),1,RAT("/",STARTPATH()))+".sqlrun"

	IF owncfg != NIL
		fd := FOPEN(owncfg,0)
		IF fd == -1
			?? "Specified config file ( "+owncfg+" ) not found"
			?
			QUIT
		ENDIF
	ELSE
		fd := FOPEN(GETENV("HOME")+"/.clip/.sqlrun",0)
		IF fd == -1
			?? "Config file ( "+GETENV("HOME")+"/.clip/.sqlrun ) not found,"
			? "trying "+cfgfile
			fd := FOPEN(cfgfile,0)
		ENDIF
		IF fd == -1
			? "Config file ( "+cfgfile+" ) not found"
			?
			QUIT
		ENDIF
	ENDIF
	DO WHILE (read := FREAD(fd,@chunk,CHUNKSIZE)) == CHUNKSIZE
		txt += chunk
	ENDDO
	txt += LEFT(chunk,read)
	FCLOSE(fd)

	DO WHILE (pos := AT(LF,txt)) != 0
		AADD(ar,ALLTRIM(SUBSTR(txt,1,pos-1)))
		txt := SUBSTR(txt,pos+1)
	ENDDO
RETURN ar

FUNCTION ReadFile(srcfile,comments,packs)
	LOCAL fd
	LOCAL read
	LOCAL chunk := SPACE(CHUNKSIZE)
	LOCAL txt := ""
	LOCAL ar := ARRAY(0)
	LOCAL reg := ARRAY(0)
	LOCAL pos := 1
	LOCAL I
	LOCAL tmp
	LOCAL ereg

	fd := FOPEN(srcfile,0)
	IF fd == -1
		?? "No file "+srcfile
		?
		QUIT
	ENDIF
	DO WHILE (read := FREAD(fd,@chunk,CHUNKSIZE)) == CHUNKSIZE
		txt += chunk
	ENDDO
	txt += LEFT(chunk,read)
	FCLOSE(fd)

	FOR I:=1 TO LEN(comments)
		DO WHILE SEARCH(comments[I],txt,reg)
			txt := STUFF(txt,reg[1][1],reg[1][2]-reg[1][1]+1,"")
			reg := ARRAY(0)
		ENDDO
	NEXT
	FOR I:=1 TO LEN(packs)
		DO WHILE SEARCH(packs[I],txt,reg,pos)
			ereg := ARRAY(0)
			IF SEARCH(ep,txt,ereg,reg[1][1])
				tmp := SUBSTR(txt,reg[1][1],ereg[1][2]-reg[1][1]+1)
				tmp := STRTRAN(tmp,";",CHR(1))
				txt := STUFF(txt,reg[1][1],ereg[1][2]-reg[1][1]+1,tmp+";")
				pos := ereg[1][2]
			ENDIF
			reg := ARRAY(0)
		ENDDO
	NEXT
	DO WHILE SEARCH(ep,txt,reg)
		txt := STUFF(txt,reg[1][1],reg[1][2]-reg[1][1]+1,"")
		reg := ARRAY(0)
	ENDDO
	DO WHILE (pos := AT(";",txt)) != 0
		tmp := ALLTRIM(SUBSTR(txt,1,pos-1))
		IF !EMPTY(tmp)
			AADD(ar,STRTRAN(tmp,CHR(1),";"))
		ENDIF
		txt := SUBSTR(txt,pos+1)
	ENDDO

RETURN ar

