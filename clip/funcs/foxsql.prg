/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "error.ch"
#include "set.ch"
**************************************************
* foxpro compatible SQL functions
**************************************************

**************************************************
* create table as SQL query "f1 t1(l1,d1), f2 t2 ,...."
******
function fx_dbcreate(data,ddriver)
	local i,ch,m:={},filename
	local flag:=1,f:=.f.
	local fname:="",ftype:="",flen:="",fdec:=""
	i=at(" ",data)
	filename:=alltrim(substr(data,1,i-1))
	data:=alltrim(substr(data,i+1))
	if !(  left(data,1)=="(" .and. right(data,1)==")"  )
		i:=errorNew()
		i:description:="Sql syntax error:"+data
		i:genCode:=EG_SYNTAX
		i:operation:="CREATE TABLE"
		break(i)
	endif
	data:=alltrim(substr(data,2,len(data)-2))
	do while !empty(data)
		 ch:=left(data,1)
		 data:=substr(data,2)
		 if ch=="," .and. !f //end of description field
			aadd(m,{alltrim(fname), alltrim(ftype),val(flen),val(fdec)})
			flag:=1; f:=.f.
			fname:="";ftype:="";flen:="";fdec:=""
			data:=alltrim(data)
			loop
		 endif
		 if ch=="," .and. f
			flag++
			data:=alltrim(data)
			loop
		 endif
		 if ch==" "
			flag++
			data:=alltrim(data)
			loop
		 endif
		 if ch=="("
			flag:=3
			f:=.t.
			data:=alltrim(data)
			loop
		 endif
		 if ch==")"
			flag:=5
			f:=.f.
			data:=alltrim(data)
			loop
		 endif
		 do case
			case flag==1
				fname+=ch
			case flag==2
				ftype+=ch
			case flag==3
				flen+=ch
			case flag==4
				fdec+=ch
		 endcase
	enddo
	aadd(m,{alltrim(fname), alltrim(ftype),val(flen),val(fdec)})
	dbcreate(filename,m,ddriver)
	use (filename) VIA (ddriver) NEW
return

**************************************************
* INSERT INTO data VALUES valData VIA ddriver
******
function fx_insert(data,valData,ddriver)
	local i,j,d,fields:={},values,filename
	i=at(" ",data)
	i:=iif(i==0,len(data)+1,i)
	filename:=alltrim(substr(data,1,i-1))
	data:=alltrim(substr(data,i+1))
	ddriver:=iif(ddriver==NIL,rddSetDefault(),ddriver)
	if (j:=getarea(filename)) > 0
		d:=rddHandle(j)
	else
		d:=rddUseArea(substr(ddriver,1,3),filename,.t.)
		if file(filename+memoext())
			rddSetMemo(d,,filename)
		endif
		if file(filename+"."+lower(substr(ddriver,4,3)))
			rddSetIndex(d,,filename)
		endif
	endif
	//d:=rddUseArea(substr(ddriver,1,3),filename,.t.) //shared
	if empty(data) // fields list is empty
		for i=1 to rddfcount(d)
			aadd(fields,rddFieldName(d,i))
		next
	else
		if !(  left(data,1)=="(" .and. right(data,1)==")"  )
			use
			i:=errorNew()
			i:description:="Sql syntax error:"+data
			i:genCode:=EG_SYNTAX
			i:operation:="INSERT INTO"
			break(i)
		endif
		data:=substr(data,2,len(data)-2)
		fields:=split(data,",")
	endif
	if valtype(valData) == "A"
		values:=valData
	else
	if valtype(valData)=="U"
		values:={}
		for i=1 to len(fields)
			j:=memvarBlock(fields[i])
			if j!=NIL
				aadd(values,eval(j) )
			else
				aadd(values, NIL )
			endif
		next
	else
		if !(  left(valData,1)=="(" .and. right(valData,1)==")"  )
			use
			i:=errorNew()
			i:description:="Sql syntax error:"+valData
			i:genCode:=EG_SYNTAX
			i:operation:="INSERT INTO... VALUES"
			break(i)
		endif
		valData:=substr(valData,2,len(valData)-2)
		values:=split(valData,",")
		for i=1 to len(values)
			if left(values[i],1)=="{"
				values[i]=substr(values[i],2,len(values[i])-2)
				values[i]=ctod(values[i])
			else
				values[i]=&(values[i])
			endif
		next
	endif
	endif
	rddAppend(d)
	for i=1 to len(fields)
		j:=rddFieldPos(d,fields[i])
		if j>0 .and. i<=len(values) .and. values[i]!=NIL
			rddSetValue(d,j,values[i])
		endif
	next
	rddCloseArea(d)
return

**************************************************
* SELECT .... FROM .....
******

#include "foxsql.ch"
function fx_select(sQuery)
	local oQuery:=sqlQueryNew(),tmp
	oQuery:parse(sQuery)
	oQuery:parseFrom()
	oQuery:parseTo()
	oQuery:openDB()
	oQuery:parseFields()
	oQuery:parseOrder()
	oQuery:parseGroup()
	oQuery:where:=oQuery:parseExpr(oQuery:where)
	oQuery:where:=oQuery:logicalOptimizeExpr(oQuery:where)
	tmp:=oQuery:makeFilters(oQuery:where,.f.)
	oQuery:filter:=atail(tmp)
	asize(tmp,len(tmp)-1)
	oQuery:filters:=tmp
	oQuery:having:=oQuery:parseExpr(oQuery:having)
	oQuery:having:=oQuery:logicalOptimizeExpr(oQuery:having)
	tmp:=oQuery:makeFilters(oQuery:having,.t.)
	oQuery:hFilter:=atail(tmp)
	oQuery:run()
	oQuery:outResult()
	oQuery:closeOut()
	oQuery:closeDB()
return

