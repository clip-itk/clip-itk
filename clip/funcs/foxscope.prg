/*
	Copyright (C) 2001  ITK
	Authors : uri (uri@itk.ru), rust (rust@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
****************************************************************
static aScope:={}
****************************************************************
function fx_scopeBegin(cfor,bfor,bwhile,nRecords,nRecord,lRest,lNoOptimize)
	local h,f,oScope
	if !used()
		return
	endif
	oScope	:= map()
	oScope:Select 	:= select()
	oScope:cFor 	:= cFor
	oScope:nRecords	:= iif(nRecords==NIL,lastrec(),nRecords)
	oScope:nCount	:= 0
	if valtype(nRecord)=="N"
		goto nRecord
		lRest := .t.
		oScope:nRecords := 1
	endif
	oScope:bWhile	:= bWhile
	oScope:bFor	:= bFor
	oScope:rm_filter:= NIL
	if lNoOptimize .or. nRecord != NIL
		oScope:cFor := NIL
	else
		if (f := isfiltered()) .and. !empty(cfor)
			oScope:rm_filter := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		elseif !empty(cfor)
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif
	endif

	if valtype(lRest)=="L" .and. lRest
	else
		goto top
	endif
	aadd(aScope,oScope)

return oScope

****************************************************************
function fx_eof(oScope)
	if oScope == NIL
	    oScope := atail(aScope)
	endif

	select (oScope:Select)
return eof()

****************************************************************
function fx_scopeNext(oScope)
	if oScope == NIL
		oScope := atail(aScope)
	endif
	select (oScope:Select)
	if oScope:nCount != 0
		skip
	endif
	while !eof()
		oScope:nCount ++
		if oScope:bWhile != NIL .and. ! eval(oScope:bWhile)
			return .f.
		endif
		if oScope:nCount > oScope:nRecords
			return .f.
		endif
		if oScope:bFor == NIL .or. eval(oScope:bFor)
			return .t.
		endif
		skip
	enddo
return .f.
****************************************************************
function fx_scopeEnd(oScope)
	if oScope == NIL
		oScope := atail(aScope)
	endif
	select (oScope:Select)
	if !empty(oScope:cfor)
		dbclearfilter()
		if oScope:rm_filter != NIL
			m6_SetAreaFilter(oScope:rm_filter)
		endif
	endif
	asize(aScope, len(aScope)-1 )
return .t.

