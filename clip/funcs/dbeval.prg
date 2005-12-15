/*
	Copyright (C) 2001  ITK
	Authors   : uri (uri@itk.ru), rust (rust@itk.ru)
	SoAuthors : Stas (lista@bk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
****************************************************************
FUNCTION dbEval( b, xFor, xWhile, nNext, nRec, lRest)
	LOCAL __bKey, __bFor, __bWhile, OldSel
	IF !USED()
		RETURN
	ENDIF

	OldSel:=SELECT()

	IF ( valtype( xWhile )=="C" )
		__bWhile:="{||"+xWhile+"}"
		__bWhile:=&__bWhile
	ELSE
		IF ( valtype( xWhile )!="B" )
			__bWhile:={ ||.t. }
		ELSE
			__bWhile:=xWhile
			lRest:= .T.
		ENDIF
	ENDIF

	IF ( valtype( xFor )=="C" )
		__bFor:="{||"+xFor+"}"
		__bFor:=&xFor
	ELSE
		IF ( valtype( xFor )!="B" )
			__bFor:={ ||.t. }
		ELSE
			__bFor:=xFor
		ENDIF
	ENDIF

	lRest:=Iif( lRest==NIL, .F., lRest )

	IF ( nRec != NIL )
		GOTO nRec
		nNext:= 1
	ELSE
		IF ( nNext==NIL )
			nNext:= -1
		ELSE
			lRest:= .T.
		ENDIF
		IF ( !lRest )
			GOTO top
		ENDIF
	ENDIF

	WHILE ( !EOF() .AND. nNext-- != 0 .AND. eval( __bWhile ) )
		IF ( eval( __bFor ) )
			EVAL(b)
		ENDIF
		SELECT (OldSel)
		SKIP
	ENDDO

	SELECT (OldSel)
RETURN

******************************************************************
FUNCTION dbEvalOptimize( b, cFor, xWhile, nNext, nRec, lRest)
	LOCAL __bKey, __bWhile, OldSel
	LOCAL h,o,f

	IF !USED()
		RETURN
	ENDIF

	OldSel:=SELECT()

	IF ( valtype( xWhile )=="C" )
		__bWhile:="{||"+xWhile+"}"
		__bWhile:=&__bWhile
	ELSE
		IF ( valtype( xWhile )!="B" )
			__bWhile:={ ||.t. }
		ELSE
			__bWhile:=xWhile
			lRest:= .T.
		ENDIF
	ENDIF

	IF (f := ISFILTERED()) .AND. !EMPTY(cFor)
		o := m6_FiltCopy(m6_GetAreaFilter())
		h := m6_NewFilter(cFor)
		m6_FiltJoin(m6_GetAreaFilter(),h,2)
	ELSEIF !EMPTY(cFor)
		m6_SetAreaFilter(m6_NewFilter(cFor))
	ENDIF

	lRest:=Iif( lRest==NIL, .F., lRest )

	IF ( nRec != NIL )
		GOTO nRec
		nNext:= 1
	ELSE
		IF ( nNext==NIL )
			nNext:= -1
		ELSE
			lRest:= .T.
		ENDIF
		IF ( !lRest )
			GOTO top
		ENDIF
	ENDIF

	WHILE ( !EOF() .AND. nNext-- != 0 .AND. eval( __bWhile ) )
		EVAL(b)
		SELECT (OldSel)
		SKIP
	ENDDO

	SELECT (OldSel)

	IF !EMPTY(cfor)
		DBCLEARFILTER()
		IF f
			m6_SetAreaFilter(o)
		ENDIF
	ENDIF
	SELECT(oldsel)
RETURN

******************************************************************
function m6_dbeval(b,cfor,bfor)
	local h,o,f
	if !used()
		return
	endif
	if f := isfiltered()
		o := m6_FiltCopy(m6_GetAreaFilter())
		h := m6_NewFilter(cfor)
		m6_FiltJoin(m6_GetAreaFilter(),h,2)
	else
		m6_SetAreaFilter(m6_NewFilter(cfor))
	endif

	goto top

	while !eof()
		eval(b)
		skip
	enddo

	dbclearfilter()
	if f
		m6_SetAreaFilter(o)
	endif
return
