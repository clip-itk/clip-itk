STATIC sRootPath := "/var/www"
STATIC sSrcDir := "."
STATIC sHtml

PROCEDURE Main
	LOCAL vars := getenv()
	LOCAL str := ""
	LOCAL i := 0
	LOCAL t

	SET TRANSLATE PATH OFF

	ErrorBlock({|e| break(e)})

	BEGIN SEQUENCE
	IF PCOUNT() == 0
		?? 'Content-type: text/html'
		?
		str := cgi_split(vars:QUERY_STRING):query
		sHtml := .T.
	ELSE
		sHtml := .F.
		WHILE !EMPTY(PARAM(++i))
			IF PARAM(i) == "-h" .OR. PARAM(i) == "--help"
				Usage()
			ELSEIF PARAM(i) == "-r"
				sRootPath := PARAM(++i)
			ELSEIF PARAM(i) == "-s"
				sSrcDir := PARAM(++i)
			ELSEIF PARAM(i) == "-t"
				sHtml := .T.
			ELSE
				str += PARAM(i)
			ENDIF
		ENDDO
	ENDIF

	IF sHtml
		? '<html><body>'
	ENDIF
	USE &(sSrcDir+"/hindex") VIA "DBFCDX" SHARED READONLY
	t := SECONDS()
	? hs_filter(sSrcDir+"/hindex",str,;
		"FILESTR('"+sRootPath+"'+name)",.T.),;
		"references was found in",SECONDS()-t,"seconds:"
	IF sHtml
		?? '<br>'
		? '<table border=1>'
	ENDIF
	go top
	while !eof()
		IF sHtml
			? '<tr>'
			?? '<td><a href="'+name+'">'+name+'</a></td><td>'+title+'</td>'
			?? '</tr>'
		ELSE
			? name,title
		ENDIF
		skip
	enddo
	IF sHtml
		? '</table>'
		? '</body></html>'
	ELSE
	?
	?
	ENDIF
RECOVER USING e
	? "clip_hseek generated an error:"
	? e:description, "("+e:operation+")"
	?
	?
	Usage()
END SEQUENCE
RETURN

PROCEDURE Usage
	?? "clip_hseek Ver 1.00 (c) ITK Ltd."
	? "Text search utility (using the database created by clip_hindex)"
	?
	? "Usage:"
	? "clip_hseek [OPTIONS] [<string>]"
	? "  -h, --help       Display this help and exit"
	? "  -r <www-root>    The path for the WWW-root"
	? "                   (must be the same as one used in clip_hindex)"
	? "                   default is /var/www"
	? "  -s <index_path>  Directory containing hindex.dbf(fpt,htx) files"
	? "                   default is ./"
	? "  -t               HTML output (default text)"
	? "If no OPTIONS and parameters are passed, QUERY_STRING environment variable"
	? "will be used. In this case QUERY_STRING must be in the form 'query=<string>'."
	?
	?
	QUIT
RETURN
