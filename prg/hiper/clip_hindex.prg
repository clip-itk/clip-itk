#include "directry.ch"

STATIC sExt := {".HTML",".HTM",".SHTML"}
STATIC sSize := 0
STATIC sFiles := 0
STATIC sRootPath := "/var/www/htdocs"
STATIC sDestDir := "."
STATIC sQuiet := .F.

PROCEDURE Main
	LOCAL path := ""
	LOCAL h,t,c,i:=0,j

	WHILE param(++i) != NIL
		IF param(i) == "--help" .OR. param(i) == "-h"
			Usage()
			QUIT
		ELSEIF param(i) == "-e"
			sExt := ARRAY(NUMTOKEN(param(++i),",",1))
			FOR j:=1 TO LEN(sExt)
				sExt[j] = "."+UPPER(TOKEN(param(i),",",j,1))
			NEXT
		ELSEIF param(i) == "-r"
			sRootPath := param(++i)
		ELSEIF param(i) == "-d"
			sDestDir := param(++i)
		ELSEIF param(i) == "-q"
			sQuiet := .T.
		ELSE
			Usage()
			QUIT
		ENDIF
	ENDDO

	IF !sQuiet
		?? "hindex Ver 1.00 (c) ITK Ltd."
		? "indexing    :",MAKEPATH(sRootPath)
		? "suffices    : "
		FOR i:=1 TO LEN(sExt)
			?? sExt[i],""
		NEXT
		? "target files:",MAKEPATH(sDestDir)+"/hindex.dbf(fpt,htx)"
		?
	ENDIF

	RDDSETDEFAULT("DBFCDX")
	DBCREATE(sDestDir+"/hindex",{{"NAME","V",30,0},{"TITLE","V",30,0}})

	USE &(sDestDir+"/hindex") ALIAS html
	h := hs_Create(sDestDir+"/hindex",1,,.T.,1)
	t := SECONDS()
	DirReview(path,h)
	IF !sQuiet
		? sFiles,"files (",sSize,"bytes) indexed in",SECONDS()-t,"seconds"
		?
	ENDIF
RETURN

PROCEDURE DirReview(path,h)
	LOCAL dir := DIRECTORY(sRootPath+path+"/*","D")
	LOCAL i,j,p,o,str

	FOR i:=1 TO LEN(dir)
		IF dir[i][F_ATTR] == 'D' .AND. LEFT(@dir[i][F_NAME],1) != '.'
			DirReview(path+"/"+dir[i][F_NAME],h)
		ENDIF
		IF dir[i][F_ATTR] == 'A'
			FOR j:=1 TO LEN(sExt)
				IF UPPER(RIGHT(@dir[i][F_NAME],LEN(sExt[j]))) == sExt[j]
					EXIT
				ENDIF
			NEXT

			IF j > LEN(sExt)
				LOOP
			ENDIF

			html->(DBAPPEND())
			html->NAME := path+"/"+dir[i][F_NAME]

			p := htmlParserNew()
			p:put(FILESTR(sRootPath+html->NAME))
			str := ""
			WHILE !(o := p:empty())
				o := p:get()
				IF VALTYPE(o) == 'C'
					str += o
				ELSEIF VALTYPE(o) == 'O' .AND. o:TAGNAME == "TITLE"
					tit := p:get()
					IF VALTYPE(tit) == 'C'
						html->TITLE := tit
					ENDIF
				ENDIF
			ENDDO
			IF !sQuiet
				? hs_Add(h,str),CHR(9),dir[i][F_SIZE],CHR(9),path+"/"+dir[i][F_NAME]
			ELSE
				hs_Add(h,str)
			ENDIF
			sSize += dir[i][F_SIZE]
			sFiles++
		ENDIF
	NEXT
RETURN

PROCEDURE Usage
	?? "clip_hindex Ver 1.00 (c) ITK Ltd."
	? "HTML content indexing utility"
	?
	? "Usage: clip_hindex [OPTIONS]"
	?
	? "  -h, --help       Display this help and exit"
	? "  -e <suffix>      File name's suffixes separated with ','"
	? "                   default is html,htm,shtml"
	? "  -r <www-root>    The path for the WWW-root"
	? "                   default is /var/www/htdocs"
	? "  -d <destination> The destination directory"
	? "                   default is ./"
	? "  -q               Quiet mode"
	?
	?
RETURN
