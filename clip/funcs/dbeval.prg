/*
	Copyright (C) 2001  ITK
	Authors : uri (uri@itk.ru), rust (rust@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
****************************************************************
function dbeval(b,ufor,uwhile,nrec,rec,flag)
 local i,__bfor,__bwhile,oldsel:=select()
 if !used()
	return
 endif
 if valtype(rec)=="N"
	goto rec
	eval(b)
		select(oldsel)
	return
 endif
 if valtype(ufor)=="C"
	__bfor:="{||"+ufor+"}"
	__bfor:=&__bfor
 else
	if valtype(ufor)=="B"
		__bfor:=ufor
	else
		__bfor:={||.t.}
	endif
 endif
 if valtype(uwhile)=="C"
	__bwhile:="{||"+uwhile+"}"
	__bwhile:=&__bwhile
 else
	if valtype(uwhile)=="B"
	   __bwhile:=uwhile
	else
	   __bwhile:={||.t.}
	endif
 endif
 nrec:=iif(nrec==NIL,lastrec(),nrec)

 if valtype(flag)=="L" .and. flag
 else
	goto top
 endif

 i:=0
 while !eof() .and. i<nrec .and. eval(__bwhile)
	if eval(__bfor)
	   eval(b)
	   select(oldsel)
	endif
	i++
	skip
 enddo
 select(oldsel)
return

function dbevaloptimize(b,cfor,bwhile,nrec,rec,flag)
 local i,h,o,f,oldsel:=select()
 if !used()
	return
 endif
 if valtype(rec)=="N"
	goto rec
	eval(b)
	select(oldsel)
	return
 endif
 nrec:=iif(nrec==NIL,lastrec(),nrec)
 if valtype(bwhile) != "B"
	bwhile := {||.t.}
 endif

 if (f := isfiltered()) .and. !empty(cfor)
	o := m6_FiltCopy(m6_GetAreaFilter())
	h := m6_NewFilter(cfor)
	m6_FiltJoin(m6_GetAreaFilter(),h,2)
 elseif !empty(cfor)
	m6_SetAreaFilter(m6_NewFilter(cfor))
 endif

 if valtype(flag)=="L" .and. flag
 else
	goto top
 endif

 i:=0
 while !eof() .and. i<nrec .and. eval(bwhile)
	eval(b)
	select(oldsel)
	i++
	skip
 enddo

 if !empty(cfor)
	dbclearfilter()
	if f
		m6_SetAreaFilter(o)
	endif
 endif
 select(oldsel)
return

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
