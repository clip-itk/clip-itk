/*
	Copyright (C) 2001  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "config.ch"
#include "set.ch"
#include "fileio.ch"
#include "common.ch"
#include "error.ch"
#include "dbinfo.ch"
****************************************************************
function fieldwblock(fname,anum)
  local __cname, __al:=alias(anum)
  __cname:="{|_1| iif(_1==NIL,"+__al+"->"+fname+","+__al+"->"+fname+":=_1) }"
  __cname:=&__cname
return __cname

****************************************************************
function fieldblock(fname)
  local __cname
  __cname:="{|_1| iif(_1==NIL, _field->"+fname+",_field->"+fname+":=_1) }"
  __cname:=&__cname
return __cname

****************************************************************
function __dbCopyStruct(fname,rfields)
	local i,ret,fields:={},stru,err
	if empty(rfields)
		rfields := {}
		outlog(3,"copystruct",fname,dbstruct())
		dbcreate(fname,dbstruct())
		return
	endif
	outlog(3,"copystruct",fname,rfields)
	stru:=dbstruct()
	for i=1 to len(rfields)
		rfields[i]:=upper(alltrim(rfields[i]))
		ret:=ascan(stru,{|x|x[1]==rfields[i]})
		if ret!=0
			aadd(fields,stru[ret])
		endif
	next
	if len(fields)==0
		err=errorNew()
		err:description:="invalid argument"
		err:genCode:=EG_ARG
		eval(errorblock(),err)
	else
		dbcreate(fname,fields)
	endif
return

****************************************************************
function __dbCopyXStruct(fname)
   local i,struct,fields:=dbstruct(),sel:=select(), __alias:=tmpalias()
   struct:={{"field_name","C",10,0},{"field_type","C",1,0},;
		{"field_len" ,"N",3 ,0},{"field_dec","N",4,0},;
		{"field_bin" ,"L",1 ,0},{"field_nil","L",1,0};
		}
   dbcreate(fname,struct)
   use (fname) new exclusive ALIAS (__alias)
   outlog(3,"copyxstruct",fname,fields)
   for i=1 to len(fields)
	   append blank
	   field->field_name:=fields[i][1]
	   field->field_type:=fields[i][2]
	   field->field_len :=fields[i][3]
	   field->field_dec :=fields[i][4]
	   if len(fields[i]) > 5 .and. valtype(fields[i])=="L"
			field->field_bin :=fields[i][5]
	   endif
	   if len(fields[i]) > 6 .and. valtype(fields[i])=="L"
			field->field_nil :=fields[i][6]
	   endif
   next
   commit
   use
   select(sel)
return
****************************************************************
function dbCreate(fname, aStru, rdd, new, al)
	_dbcreate(fname,aStru,rdd)
	if new!=NIL .and. new
		use (fname) via (rdd) alias (aL) NEW
	endif
return

****************************************************************
function __dbCreate(fname1, fname2, rdd, new, al)
   local i,struct:={}, __alias:=tmpalias(), sel:=select()
   local ao := set(_SET_AUTOPEN,.f.)
   new=iif(new==NIL,.f.,new)
   if empty(fname2)
	struct:={{"field_name","C",10,0},{"field_type","C",1,0},;
		{"field_len" ,"N",3 ,0},{"field_dec","N",4,0}}
   else
	use (fname2) new shared alias (__alias)
	if neterr()
		select getarea(fname2)
		go top
	endif
	do while !eof()
	   aadd(struct,{alltrim(field->field_name),field->field_type,field->field_len,field->field_dec})
	   skip
	enddo
	use
   endif
   select(sel)
   outlog(3,"create <file>",fname1,struct)
   dbcreate(fname1,struct,rdd)
   if new
	  use (fname1) alias (al) via (rdd) exclusive NEW
   else
	  use (fname1) alias (al) via (rdd) exclusive
   endif
   set(_SET_AUTOPEN,ao)
return

****************************************************************
function __DbList(off, fields, all, ufor, uwhile, unext, rec, rest, toPrint, toFile)
	local i,margin:=space(set(25)), count:=0
	local __bfor,__bwhile
	outlog(3,"list",alias(),"fields",fields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest,tofile)

	off:=iif(off==NIL,.t.,off)

	if valtype(rec)=="N"
		goto rec
		rest=.t.
		unext=1
	endif

	if uwhile != NIL
		rest := .t.
	endif

	if valtype(ufor)=="C"
		__bfor:="{||"+ufor+"}"
		__bfor:=&__bfor
	else
		if valtype(ufor)!="B"
			__bfor:={||.t.}
		else
			__bfor:=ufor
		endif
	endif

	if valtype(uwhile)=="C"
		__bwhile:="{||"+uwhile+"}"
		__bwhile:=&__bwhile
	else
		if valtype(uwhile)!="B"
			__bwhile:={||.t.}
		else
			__bwhile:=uwhile
		endif
	endif

	if empty(rest) .and. unext==NIL //rest==NIL .or. !rest
		goto top
	endif
	unext=iif(valtype(unext)!="N",lastrec(),unext)

	if !empty(toFile)
		if !("." $ toFile)
			toFile += ".prn"
		endif
		set alternate to (toFile)
		set alternate on
	endif

	do while !eof() .and. count<unext .and. eval(__bwhile)
		count++
		if eval(__bfor)
			? iif(off,margin,margin+str(recno()))
			?? iif(deleted(),"*"," ")
			for i=1 to len(fields)
				?? eval(fields[i]),""
			next
		endif
		if count<unext
			skip
		endif
	enddo
	if !empty(toFile)
		set alternate off
		set alternate to
	endif
return count

****************************************************************
function __DbListOptimize(off,fields,all,cfor,bfor,uwhile,unext,rec,rest,toPrint,toFile)
	local f,o,h,r

	if cfor == NIL .or. unext != NIL
		r := __DbList(off,fields,all,bfor,uwhile,unext,rec,rest,toPrint,toFile)
	else
		if f := isfiltered()
			o := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		else
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif

		r := __DbList(off,fields,all,bfor,uwhile,unext,rec,rest,toPrint,toFile)

		dbclearfilter()
		if f
			m6_SetAreaFilter(o)
		endif
	endif
return r

****************************************************************
function m6_ListFor(off,fields,all,cfor,bfor,toPrint,toFile)
return __DbListOptimize(off,fields,all,cfor,bfor,,,,,toPrint,toFile)

****************************************************************
function __dbApp(file,rfields, ufor, uwhile, unext, rec, rest, rdd)
	local wsel:=select(),rsel, count:=0, rstruct,wstruct:=dbstruct(),i,x1,x2
	local wrec,rrec,fields:={},__alias:=tmpalias(),cset:=set(_SET_CANCEL,.f.)
		local err, flag_err:=.f., err_block:=errorblock({|x|break(x)})
		local dflag
	local __bfor,__bwhile

	outlog(3,"append",alias(),"from",file,"fields",rfields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest)


	begin sequence
		use (file) NEW shared alias (__alias) via (rdd)
		rsel:=select()

		if valtype(rec)=="N"
			goto rec
			rest=.t.
			unext=1
		endif
		if uwhile != NIL
			rest := .t.
		endif
		if empty(rest) .and. unext == NIL //rest==NIL .or. !rest
			goto top
		endif
		unext=iif(valtype(unext)!="N",lastrec(),unext)


		if valtype(ufor)=="C"
			__bfor:="{||"+ufor+"}"
			__bfor:=&__bfor
		else
			if valtype(ufor)!="B"
				__bfor:={||.t.}
			else
				__bfor:=ufor
			endif
		endif

		if valtype(uwhile)=="C"
			__bwhile:="{||"+uwhile+"}"
			__bwhile:=&__bwhile
		else
			if valtype(uwhile)!="B"
				__bwhile:={||.t.}
			else
				__bwhile:=uwhile
			endif
		endif

		rstruct=dbstruct()
		if empty(rfields)
			rfields := {}
			for i=1 to len(rstruct)
				aadd(rfields, rstruct[i][1])
			next
		endif

		for i=1 to len(rfields)
			rfields[i]:=upper(alltrim(rfields[i]))
			x1:=ascan(rstruct,{|x|x[1]==rfields[i]})
			x2:=ascan(wstruct,{|x|x[1]==rfields[i]})
			if x1!=0 .and. x2!=0
				aadd(fields,hashstr(rfields[i]))
			endif
		next

		if len(fields)==0
			select(rsel)
			use
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="invalid argument"
			err:genCode:=EG_ARG
			//err:operation:="__DBAPP"
			eval(errorblock(),err)
			//break(err)
		endif

		select(rsel)
		wrec:=map()
		do while !eof() .and. count<unext .and. eval(__bwhile)
			count++
			if !eval(__bfor)
				skip
				loop
			endif
			rrec:=dbread()
			dflag:=deleted()
			for i=1 to len(fields)
				wrec[fields[i]]=rrec[fields[i]]
			next
			select(wsel)
			dbappend(,wrec)
			if dflag
				delete
			endif
			select(rsel)
			if count<unext
				skip
			endif
		enddo

		select(rsel)
		use
	recover using err
		flag_err:=.t.
	end sequence
	select(wsel)
	set(_SET_CANCEL,cset)
	errorblock(err_block)
	if flag_err
		   err:operation+="/__DBAPP"
		   eval(errorblock(),err)
		   //break(err)
	endif
return count

****************************************************************
function __dbCopy(file,rfields, ufor, uwhile, unext, rec, rest,rdd)
	local rsel:=select(),wsel, count:=0, wstruct:={},rstruct,i,x1,x2
	local wrec,rrec,fields:={},__alias:=tmpalias(),cset:=set(_SET_CANCEL,.f.)
	local err, flag_err:=.f.,  err_block:=errorblock({|x|break(x)})
	local dflag, allFlag:=.f., rawFlag
	local __bfor,__bwhile,__rFor,__rWhile

	outlog(3,"copy to",file,"fields",rfields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest)
	begin sequence
		rawFlag:=empty(rfields) .and. empty(rdd) .and. !clip_ismemo()
		rstruct=dbstruct()
		if empty(rfields)
			rfields := {}
			allFlag:=.t.
			for i=1 to len(rstruct)
				aadd(rfields, rstruct[i][1])
			next
		endif
		for i=1 to len(rfields)
			rfields[i]:=upper(alltrim(rfields[i]))
			x1:=ascan(rstruct,{|x|x[1]==rfields[i]})
			if x1!=0
				aadd(wstruct,rstruct[x1])
				aadd(fields,hashstr(rfields[i]))
			endif
		next
		if len(fields)==0
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="invalid argument"
			err:genCode:=EG_ARG
			//err:operation:="__DBCOPY"
			eval(errorblock(),err)
			//break(err)
		endif

		if valtype(rec)=="N"
			goto rec
			rest=.t.
			unext=1
		endif
		if uwhile!=NIL
			rest := .t.
		endif

		if empty(rest) .and. unext==NIL //rest==NIL .or. !rest
			goto top
		endif
		unext=iif(valtype(unext)!="N",lastrec(),unext)

		if valtype(ufor)=="C"
			__bfor:="{||"+ufor+"}"
			__bfor:=&__bfor
			__rfor:=__bfor
		else
			if valtype(ufor)!="B"
				__bfor:={||.t.}
			else
				__bfor:=ufor
				__rfor:=__bfor
			endif
		endif
		if valtype(uwhile)=="C"
			__bwhile:="{||"+uwhile+"}"
			__bwhile:=&__bwhile
			__rwhile:=__bwhile
		else
			if valtype(uwhile)!="B"
				__bwhile:={||.t.}
			else
				__bwhile:=uwhile
				__rwhile:=__bwhile
			endif
		endif

		select 0
		dbcreate(file,wstruct,rdd)
		use (file) NEW exclusive alias (__alias) via (rdd)
		wsel:=select()
		if rawFlag
			select(rsel)
			count:=__dbcopyRaw(wsel,__rfor,__rwhile,unext)
		else
			select(rsel)
			wrec:=map()
			do while !eof() .and. count<unext .and. eval(__bwhile)
				count++
				if !eval(__bfor)
					skip
					loop
				endif
				rrec:=dbread()
				dflag:=deleted()
				if allflag
					wrec:=rrec
				else
					for i=1 to len(fields)
						wrec[fields[i]]=rrec[fields[i]]
					next
				endif
				select(wsel)
				dbappend(,wrec)
				if dflag
					delete
				endif
				select(rsel)
				if count < unext
					skip
				endif
			enddo
		endif
		select(wsel)
		use
	recover using err
		flag_err:=.t.
	end sequence

	select(rsel)
	set(_SET_CANCEL,cset)
	errorblock(err_block)
	if flag_err
	   err:operation+="/__DBCOPY"
	   eval(errorblock(),err)
	   //break(err)
	endif
return count

function __dbCopyOptimize(file,fields,cfor,bfor,uwhile,unext,rec,rest,rdd)
	local f,o,h,r

	if cfor == NIL .or. unext != NIL
		r := __dbCopy(file,fields,bfor,uwhile,unext,rec,rest,rdd)
	else
		if f := isfiltered()
			o := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		else
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif

		r := __dbCopy(file,fields,bfor,uwhile,unext,rec,rest,rdd)

		dbclearfilter()
		if f
			m6_SetAreaFilter(o)
		endif
	endif
return r

function m6_Copy(file,fields,cfor,bfor,rdd)
return __dbCopyOptimize(file,fields,cfor,bfor,,,,,rdd)

****************************************************************
function __dbDelim(lIO,file,fdelim,rfields, ufor, uwhile, unext, rec, rest)
	if lIO
		return __dbCopyDelim(file,fdelim,rfields, ufor, uwhile, unext, rec, rest)
		endif
return __dbAppDelim(file,fdelim,rfields, ufor, uwhile, unext, rec, rest)
****************************************************************
function __dbCopyDelim(file,fdelim,rfields, ufor, uwhile, unext, rec, rest)
	local rsel:=select(),hfile, count:=0, wstruct:={},rstruct,i,x1,x2
	local wrec,rrec,fields:={},__alias:=tmpalias(),cset:=set(_SET_CANCEL,.f.)
	local rdelim:=",", err, flag_err:=.f.,  err_block:=errorblock({|x|break(x)})
	local __bfor,__bwhile

	fdelim=iif(fdelim==NIL,'"',fdelim)
	if lower(fdelim)=="blank"
		fdelim=""
		rdelim=" "
	endif

	outlog(3,"copy to delimited with",fdelim,file,"fields",rfields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest)

	if !(".txt" $ file .or. "." $ file)
		file+=".txt"
	endif
	begin sequence
		hfile:=fcreate(file)
		if hfile<0
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="cannot open file:"+file
			err:genCode:=EG_OPEN
			//err:operation:="__DBCOPYDELIM"
			eval(errorblock(),err)
			//break(err)
		endif

		rstruct=dbstruct()
		if empty(rfields)
			rfields := {}
			for i=1 to len(rstruct)
				aadd(rfields, rstruct[i][1])
			next
		endif
		for i=1 to len(rfields)
			rfields[i]:=upper(alltrim(rfields[i]))
			x1:=ascan(rstruct,{|x|x[1]==rfields[i]})
			if x1!=0
				aadd(wstruct,rstruct[x1])
				aadd(fields,hashstr(upper(rfields[i])))
			endif
		next
		if len(fields)==0
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="invalid argument"
			err:genCode:=EG_ARG
			//err:operation:="__DBCOPYDELIM"
			eval(errorblock(),err)
			//break(err)
		endif

		if valtype(rec)=="N"
			goto rec
			rest=.t.
			unext=1
		endif
		if uwhile != NIL
			rest := .t.
		endif
		if empty(rest) .and. unext==NIL //rest==NIL .or. !rest
			goto top
		endif
		unext=iif(valtype(unext)!="N",lastrec(),unext)

		if valtype(ufor)=="C"
			__bfor:="{||"+ufor+"}"
			__bfor:=&__bfor
		else
			if valtype(ufor)!="B"
				__bfor:={||.t.}
			else
				__bfor:=ufor
			endif
		endif

		if valtype(uwhile)=="C"
			__bwhile:="{||"+uwhile+"}"
			__bwhile:=&__bwhile
		else
			if valtype(uwhile)!="B"
				__bwhile:={||.t.}
			else
				__bwhile:=uwhile
			endif
		endif

		select(rsel)
		wrec:=map()


		do while !eof() .and. count<unext .and. eval(__bwhile)
			count++
			if !eval(__bfor)
				skip
				loop
			endif
			rrec:=dbread()
			wrec:=""
			for i=1 to len(fields)
				x1=rrec[fields[i]]
				do case
					case valtype(x1)=="C"
						if !empty(set("DBF_CHARSET"))
							x1=translate_charset(host_charset(),set("DBF_CHARSET"),x1)
						endif
						wrec+=fdelim+alltrim(x1)+fdelim+rdelim
					case valtype(x1)=="N"
						wrec+=alltrim(str(x1))+rdelim
					case valtype(x1)=="D"
						wrec+=dtos(x1)+rdelim
					case valtype(x1)=="L"
						wrec+=iif(x1,"T","F")+rdelim
				endcase
			next
			wrec:=left(wrec,len(wrec)-len(rdelim))
			fwrite(hfile,wrec+CRLF)
			if count<unext
				skip
			endif
		enddo

	recover using err
		flag_err:=.t.
	end sequence

	fclose(hfile)
	select(rsel)
	set(_SET_CANCEL,cset)
	errorblock(err_block)
	if flag_err
		err:operation+="/__DBCOPYDELIM"
		eval(errorblock(),err)
		//break(err)
	endif
return count
**********************************************************
function __dbAppDelim(file,fdelim,rfields, ufor, uwhile, unext, rec, rest, rdd)
	local wsel:=select(),rsel, count:=0, rstruct,wstruct:=dbstruct(),i,x1,x2
	local wrec,rrec,fields:={},__alias:=tmpalias(),cset:=set(_SET_CANCEL,.f.), hfile
	local rdelim:=",",rstr,types:={}, err, flag_err:=.f., err_block:=errorblock({|x|break(x)})
	local __bfor,__bwhile,__pvar,__pname,r

	fdelim=iif(fdelim==NIL,'"',fdelim)
	if lower(fdelim)=="blank"
		fdelim=""
		rdelim=" "
	endif

	outlog(3,"append delimited",alias(),"from",file,"fields",rfields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest)

	if !(".txt" $ file .or. "." $ file)
		file+=".txt"
	endif

	begin sequence
		hfile:=fopen(file,FO_READ)
		if hfile<0
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="cannot open file:"+file
			err:genCode:=EG_OPEN
			//err:operation:="__DBAPPDELIM"
			eval(errorblock(),err)
			//break(err)
		endif


		if valtype(rec)=="N"
			//goto rec
			for i=1 to rec
				filegetstr(hfile,MAX_STR)
			next
			rest=.t.
			unext=1
		endif
		unext=iif(valtype(unext)!="N",MAX_RECORDS,unext)

		if valtype(ufor)=="C"
			__bfor:="{||"+ufor+"}"
			__bfor:=&__bfor
		else
			if valtype(ufor)!="B"
				__bfor:={||.t.}
			else
				__bfor:=ufor
			endif
		endif

		if valtype(uwhile)=="C"
			__bwhile:="{||"+uwhile+"}"
			__bwhile:=&__bwhile
		else
			if valtype(uwhile)!="B"
				__bwhile:={||.t.}
			else
				__bwhile:=uwhile
			endif
		endif

		if empty(rfields)
			rfields := {}
			for i=1 to len(wstruct)
				aadd(rfields,wstruct[i][1])
			next
		endif

		for i=1 to len(rfields)
			rfields[i]:=upper(alltrim(rfields[i]))
			x1:=ascan(wstruct,{|x|x[1]==rfields[i]})
			if x1!=0
				aadd(fields,hashstr(rfields[i]))
				aadd(types,wstruct[x1][2])
				__pname=rfields[i]
				private &__pname
			endif
		next

		if len(fields)==0
			fclose(hfile)
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="invalid argument"
			err:genCode:=EG_ARG
			//err:operation:="__DBAPPDELIM"
			eval(errorblock(),err)
			//break(err)
		endif

		wrec:=map()
		do while !fileeof(hfile) .and. count<unext
			count++
			select 0
			rstr:=filegetstr(hfile,MAX_STR)
			if empty(rstr)
				loop
			endif
			if(rdelim == " ")
				rrec = split(rstr,rdelim)
			else
				rrec:=splitdelim(rstr,fdelim,rdelim)
			endif
			for i=1 to len(fields)
				rstr=NIL
				do case
					case types[i]=="C"
						if i<=len(rrec)
							rstr=rrec[i]
							if !empty(set("DBF_CHARSET"))
								rstr=translate_charset(set("DBF_CHARSET"),host_charset(),rstr)
							endif
						else
							rstr=""
						endif
					case types[i]=="N"
						if i<=len(rrec)
							rstr=val(rrec[i])
						else
							rstr=0
						endif
					case types[i]=="D"
						if i<=len(rrec)
							rstr=stod(rrec[i])
						else
							rstr=stod("")
						endif
					case types[i]=="L"
						if i<=len(rrec)
							rstr=(rrec[i]=="T")
						else
							rstr=.f.
						endif
					otherwise
						rstr=""
				endcase
				if rstr!=NIL
					__pname=rfields[i]
					&__pname=rstr
				endif
			next
			if !eval(__bfor)
				loop
			endif
			if !eval(__bwhile)
				exit
			endif
			for i=1 to len(fields)
				__pname=rfields[i]
				wrec[fields[i]]=&__pname
			next
			select(wsel)
			dbappend(,wrec)
		enddo

	recover using err
		flag_err:=.t.
	end sequence
	commit
	select(wsel)
	set(_SET_CANCEL,cset)
	errorblock(err_block)
	if flag_err
		err:operation+="/__DBAPPDELIM"
		eval(errorblock(),err)
		//break(err)
	endif
return count

function m6_CopyDelim(file,delim,fields,cfor,bfor)
return __dbDelimOptimize(.t.,file,delim,fields,cfor,bfor)

function __dbDelimOptimize(lIO,file,fdelim,rfields,cfor,bfor,uwhile,unext,rec,rest)
	local f,o,h,r

	if cfor == NIL .or. unext != NIL
		r := __dbDelim(lIO,file,fdelim,rfields,bfor,uwhile,unext,rec,rest)
	else
		if f := isfiltered()
			o := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		else
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif

		r := __dbDelim(lIO,file,fdelim,rfields,bfor,uwhile,unext,rec,rest)

		dbclearfilter()
		if f
			m6_SetAreaFilter(o)
		endif
	endif
return r

****************************************************************
function __dbSDF(lIO,file,rfields, ufor, uwhile, unext, rec, rest)
	if lIO
		return __dbCopySDF(file,rfields, ufor, uwhile, unext, rec, rest)
	endif
return __dbAppSDF(file,rfields, ufor, uwhile, unext, rec, rest)
****************************************************************
function __dbCopySDF(file,rfields, ufor, uwhile, unext, rec, rest)
	local rsel:=select(),hfile, count:=0, wstruct:={},rstruct,i,x1,x2
	local wrec,rrec,fields:={},__alias:=tmpalias(),cset:=set(_SET_CANCEL,.f.)
		local err, flag_err:=.f.,  err_block:=errorblock({|x|break(x)})
	local __bfor,__bwhile

	outlog(3,"copy to sdf",file,"fields",rfields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest)

	if !(".txt" $ file .or. "." $ file)
			file+=".txt"
	endif
	begin sequence
		hfile:=fcreate(file)
		if hfile<0
			set(_SET_CANCEL,cset)
					err=errorNew()
					err:description:="cannot open file:"+file
					err:genCode:=EG_OPEN
					//err:operation:="__DBCOPYSDF"
					eval(errorblock(),err)
					//break(err)
		endif

		rstruct=dbstruct()
		if empty(rfields)
			rfields := {}
			for i=1 to len(rstruct)
					aadd(rfields, rstruct[i][1])
			next
		endif
		for i=1 to len(rfields)
					rfields[i]:=upper(alltrim(rfields[i]))
				x1:=ascan(rstruct,{|x|x[1]==rfields[i]})
				if x1!=0
					aadd(wstruct,rstruct[x1])
					aadd(fields,hashstr(rfields[i]))
				endif
		next
		if len(fields)==0
			set(_SET_CANCEL,cset)
					err=errorNew()
					err:description:="invalid argument"
					err:genCode:=EG_ARG
					//err:operation:="__DBCOPYSDF"
					eval(errorblock(),err)
					//break(err)
		endif

		if valtype(rec)=="N"
			goto rec
			rest=.t.
			unext=1
		endif
		if uwhile != NIL
			rest := .t.
		endif
		if empty(rest) .and. unext==NIL //rest==NIL .or. !rest
			goto top
		endif
		unext=iif(valtype(unext)!="N",lastrec(),unext)

		if valtype(ufor)=="C"
			__bfor:="{||"+ufor+"}"
			__bfor:=&__bfor
		else
			if valtype(ufor)!="B"
					__bfor:={||.t.}
			else
					__bfor:=ufor
			endif
		endif

		if valtype(uwhile)=="C"
			__bwhile:="{||"+uwhile+"}"
			__bwhile:=&__bwhile
		else
			if valtype(uwhile)!="B"
					__bwhile:={||.t.}
			else
					__bwhile:=uwhile
			endif
		endif

		select(rsel)
		wrec:=map()

		do while !eof() .and. count<unext .and. eval(__bwhile)
			count++
			if !eval(__bfor)
					skip
					loop
			endif
			rrec:=dbread()
			wrec:=""
			for i=1 to len(fields)
				x1=rrec[fields[i]]
				do case
					case valtype(x1)=="C"
						if !empty(set("DBF_CHARSET"))
							x1=translate_charset(host_charset(),set("DBF_CHARSET"),x1)
						endif
						wrec+=x1
					case valtype(x1)=="N"
						wrec+=str(x1)
					case valtype(x1)=="D"
						wrec+=dtos(x1)
					case valtype(x1)=="L"
						wrec+=iif(x1,"T","F")
				endcase
			next
			fwrite(hfile,wrec+CRLF)
			if count<unext
				skip
			endif
		enddo

	recover using err
			flag_err:=.t.
	end sequence

	fclose(hfile)
	select(rsel)
	set(_SET_CANCEL,cset)
		errorblock(err_block)
		if flag_err
		   err:operation+="/__DBCOPYSDF"
		   eval(errorblock(),err)
		   //break(err)
		endif
return count
**********************************************************
function __dbAppSDF(file,rfields, ufor, uwhile, unext, rec, rest, rdd)
	local wsel:=select(),rsel, count:=0, rstruct,wstruct:=dbstruct(),i,x1,x2
	local wrec,rrec,fields:={},__alias:=tmpalias(),cset:=set(_SET_CANCEL,.f.), hfile
	local rstr,types:={},lens:={}, err, flag_err:=.f., err_block:=errorblock({|x|break(x)})
	local __bfor,__bwhile
	local __pvar,__pname

	outlog(3,"append sdf",alias(),"from",file,"fields",rfields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest)

	if !(".txt" $ file .or. "." $ file)
		file+=".txt"
	endif

	begin sequence
		hfile:=fopen(file,FO_READ)
		if hfile<0
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="cannot open file:"+file
			err:genCode:=EG_OPEN
			//err:operation:="__DBAPPSDF"
			eval(errorblock(),err)
			//break(err)
		endif


		if valtype(rec)=="N"
			//goto rec
			for i=1 to rec
				filegetstr(hfile,MAX_STR)
			next
			rest=.t.
			unext=1
		endif
		unext=iif(valtype(unext)!="N",MAX_RECORDS,unext)

		if valtype(ufor)=="C"
			__bfor:="{||"+ufor+"}"
			__bfor:=&__bfor
		else
			if valtype(ufor)!="B"
				__bfor:={||.t.}
			else
				__bfor:=ufor
			endif
		endif

		if valtype(uwhile)=="C"
			__bwhile:="{||"+uwhile+"}"
			__bwhile:=&__bwhile
		else
			if valtype(uwhile)!="B"
				__bwhile:={||.t.}
			else
				__bwhile:=uwhile
			endif
		endif

		if empty(rfields)
			rfields := {}
			for i=1 to len(wstruct)
				aadd(rfields,wstruct[i][1])
			next
		endif

		for i=1 to len(rfields)
			rfields[i]:=upper(alltrim(rfields[i]))
			x1:=ascan(wstruct,{|x|x[1]==rfields[i]})
			if x1!=0
				aadd(fields,hashstr(rfields[i]))
				aadd(types,wstruct[x1][2])
				aadd(lens,wstruct[x1][3])
				__pname=rfields[i]
				private &__pname
			endif
		next

		if len(fields)==0
			fclose(hfile)
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="invalid argument"
			err:genCode:=EG_ARG
			//err:operation:="__DBAPPSDF"
			eval(errorblock(),err)
			//break(err)
		endif

		wrec:=map()
		do while !fileeof(hfile) .and. count<unext
			count++
			select 0
			rstr:=filegetstr(hfile,MAX_STR)
			if empty(rstr)
				loop
			endif
			rrec:=1
			for i=1 to len(fields)
				x1=substr(rstr,rrec,lens[i])
				rrec+=lens[i]
				do case
					case types[i]=="C"
						if !empty(set("DBF_CHARSET"))
							x1=translate_charset(set("DBF_CHARSET"),host_charset(),x1)
						endif
					case types[i]=="N"
						x1=val(x1)
					case types[i]=="D"
						x1=stod(x1)
					case types[i]=="L"
						x1=(x1=="T")
				endcase
				__pname=rfields[i]
				&__pname=x1
			next
			if !eval(__bfor)
				loop
			endif
			if !eval(__bwhile)
				exit
			endif
			for i=1 to len(fields)
				__pname=rfields[i]
				wrec[fields[i]]=&__pname
			next
			select(wsel)
			dbappend(,wrec)
		enddo

	fclose(hfile)
	recover using err
		flag_err:=.t.
	end sequence
	commit
	select(wsel)
	set(_SET_CANCEL,cset)
	errorblock(err_block)
	if flag_err
		err:operation+="/__DBAPPSDF"
		eval(errorblock(),err)
		//break(err)
	endif
return count

function __dbSDFOptimize(lIO,file,rfields,cfor,bfor,uwhile,unext,rec,rest)
	local f,o,h,r

	if cfor == NIL .or. unext != NIL
		r := __dbSDF(lIO,file,rfields,bfor,uwhile,unext,rec,rest)
	else
		if f := isfiltered()
			o := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		else
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif

		r := __dbSDF(lIO,file,rfields,bfor,uwhile,unext,rec,rest)

		dbclearfilter()
		if f
			m6_SetAreaFilter(o)
		endif
	endif
return r

function m6_CopySDF(file,fields,cfor,bfor)
return __dbSDFOptimize(.t.,file,fields,cfor,bfor)

#ifdef 0
**********************************************************
function __dbTotal(file,ukey,rfields, ufor, uwhile, unext, rec, rest, rdd)
	local rsel:=select(),wsel, count:=0, wstruct:={},rstruct,i,x1,x2
	local wrec,rrec,fields:={},__alias:=tmpalias(),cset:=set(_SET_CANCEL,.f.)
		local cur_val, err, flag_err:=.f.,  err_block:=errorblock({|x|break(x)})
	local __bkey,__bfor,__bwhile

	outlog(3,"__dbTotal",file,alias(),ukey,"fields",rfields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest)
	begin sequence
		rstruct=dbstruct()
		for i=1 to len(rfields)
			rfields[i]:=upper(alltrim(rfields[i]))
			x1:=ascan(rstruct,{|x|x[1]==rfields[i]})
			if x1!=0 .and. rstruct[x1][2] != "M"
				aadd(wstruct,rstruct[x1])
				aadd(fields,hashstr(rfields[i]))
			endif
		next
		if valtype(rec)=="N"
			goto rec
			rest=.t.
			unext=1
		endif
		if uwhile != NIL
			rest := .t.
		endif
		if empty(rest) .and. unext==NIL //rest==NIL .or. !rest
			goto top
		endif
		unext=iif(valtype(unext)!="N",lastrec(),unext)

		if empty(ukey)
			   ukey=indexkey()
		endif
		if empty(ukey)
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="invalid argument"
			err:genCode:=EG_ARG
			//err:operation:="__DBTOTAL"
			eval(errorblock(),err)
			//break(err)
		endif

		if valtype(ukey)=="C"
			__bkey:="{||"+ukey+"}"
			__bkey:=&__bkey
		else
			if valtype(ukey)!="B"
				__bkey:={||.t.}
			else
				__bkey:=ukey
			endif
		endif

		if valtype(ufor)=="C"
			__bfor:="{||"+ufor+"}"
			__bfor:=&__bfor
		else
			if valtype(ufor)!="B"
				__bfor:={||.t.}
			else
				__bfor:=ufor
			endif
		endif

		if valtype(uwhile)=="C"
			__bwhile:="{||"+uwhile+"}"
			__bwhile:=&__bwhile
		else
			if valtype(uwhile)!="B"
				__bwhile:={||.t.}
			else
				__bwhile:=uwhile
			endif
		endif

		select 0
		dbcreate(file,rstruct,rdd)
		use (file) NEW exclusive alias (__alias) via (rdd)
		wsel:=select()

		select(rsel)
		wrec:=dbread()
		cur_val:=eval(__bkey)
		do while !eof() .and. count<unext .and. eval(__bwhile)
			count++
			if !eval(__bfor)
				skip
				loop
			endif
			rrec:=dbread()
			if cur_val==eval(__bkey)
			   for i=1 to len(fields)
				wrec[fields[i]]+=rrec[fields[i]]
			   next
			else
			   select(wsel)
			   dbappend(,wrec)
			   select(rsel)
			   wrec=dbread()
			   cur_val:=eval(__bkey)
			endif
			if count<unext
				skip
			endif
		enddo
		select(wsel)
		dbappend(,wrec)
		use
	recover using err
		flag_err:=.t.
	end sequence

	select(rsel)
	set(_SET_CANCEL,cset)
	errorblock(err_block)
	if flag_err
		   err:operation+="/__DBTOTAL"
		   eval(errorblock(),err)
		   //break(err)
	endif
return count
#endif

function __dbTotalOptimize(file,ukey,fields,cfor,bfor,uwhile,unext,rec,rest,rdd)
	local f,o,h,r

	if cfor == NIL .or. unext != NIL
		r := __dbTotal(file,ukey,fields,bfor,uwhile,unext,rec,rest,rdd)
	else
		if f := isfiltered()
			o := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		else
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif

		r := __dbTotal(file,ukey,fields,bfor,uwhile,unext,rec,rest,rdd)

		dbclearfilter()
		if f
			m6_SetAreaFilter(o)
		endif
	endif
return r

function m6_TotalFor(file,ukey,fields,cfor,bfor)
return __dbTotalOptimize(file,ukey,fields,cfor,bfor)

**********************************************************
func tmpalias
local i, alias:="_tmp"
i:=1
while select(alias)!=0
  alias+=alltrim(str(i))
  i++
enddo
return alias
**********************************************************
// return structure with info for all aliases
static function __dbiInfo(nInfo)
		local __dbi_names,__dbri_names,__dboi_names,__blob_names
		#include "dbinames.ch"
		do switch (nInfo)
			case 1
					return __dbi_names
			case 2
					return __dbri_names
			case 3
					return __dboi_names
			case 4
					return __blob_names
		endswitch
return
**********************************************************
// return structure with info for all aliases
function aliasesInfo
	local i,j,k,x,y, ret:=map(), sel:=select()
		local __dbi_names:=__dbiInfo(1)
		for i=0 to MAX_ALIASES
			select(i)
				if !used() .and. i!=0
					loop
				endif
		ret[i]:=map()
				k:=mapkeys(__dbi_names)
				for j=1 to len(k)
					x:=k[j]
						if used()
							y:=dbinfo(x)
							ret[i][x]:=y
						else
							ret[i][x]:= NIL
						endif
				next
				ret[i][DBI_RECNO]:=recno()
				ret[i][DBI_LASTREC]:=lastrec()
		next
		select(sel)
return ret
**********************************************************
function dbStructInfo(sel,rec)
	local ret,i,oldsel:=select(),oldrec
	if sel!=NIL
		select(sel)
	endif
	oldrec:=recno()
	if rec!=NIL
		dbgoto(rec)
	endif
	ret:=dbstruct()
	for i=1 to len(ret)
		if len(ret[i]) == 4
			aadd(ret[i],.f.) // binary flag
			aadd(ret[i],.f.) // NULLable flag
		endif
		aadd(ret[i],fieldget(i))
	next
	dbgoto(oldrec)
	select(sel)
return ret

**********************************************************
function recordInfo(sel,rec)
	local ret,k,x,i,oldsel:=select(),oldrec
		local __dbri_names:=__dbiInfo(2)
		if sel!=NIL .and. sel==0
			return map()
		endif
	if sel!=NIL
			select(sel)
		endif
		oldrec:=recno()
		if rec!=NIL
			dbgoto(rec)
		endif
		ret:=map()
		k:=mapKeys(__dbri_names)
		for i=1 to len(k)
			x:=k[i]
		ret[x]:=dbrecordInfo(x)
		next
		dbgoto(oldrec)
		select(sel)
return ret
**********************************************************
// return structure with info for all aliases
function indexesInfo(sel)
	local ret,i,oldsel:=select()
	if sel!=NIL
			select(sel)
		endif
		ret:={}
		i:=1
		do while .t.
			if empty(ordname(i))
				exit
			endif
			aadd(ret,{ordbagname(i),ordname(i),indexkey(i)})
			i++
		enddo
		select(sel)
return ret

**********************************************************
* check structure of DBF file for "struct" and remake DBF for new structure.
**********************************************************
#include "error.ch"
function dbCheckStructure(file,struct,rdd)
	local err,eblock:=errorblock({|e| break(e) } )
	local ret:=0, sel:=select()
	local app_flag:=.f. , dstru, i, j, sret
	local file1, file2, path, tmpname

	select 0

	if !file(file)
		begin sequence
			dbcreate(file,struct,rdd)
		recover using err
			ret := EG_CREATE
		end sequence
		errorBlock(eblock)
		select(sel)
		return ret
	endif

	begin sequence
		use (file) shared via (rdd)
	recover using err
		ret := EG_OPEN
	end sequence
	if neterr()
		ret:= EG_OPEN
	endif
	if ret != 0
		errorBlock(eblock)
		select(sel)
		return ret
	endif
	/* header correct */
	append blank
	rlock()
	delete
	use

	begin sequence
		use (file) exclusive via (rdd)
	recover using err
		ret := EG_OPEN
	end sequence
	if neterr()
		ret:= EG_OPEN
	endif
	if ret != 0
		use
		errorBlock(eblock)
		select(sel)
		return ret
	endif

	dstru:=dbstruct()
	for j=1 to len(struct)
		if j>len(dstru)
			app_flag := .t.
			exit
		endif
		struct[j][1] := alltrim(upper(struct[j][1]))
		struct[j][2] := alltrim(upper(struct[j][2]))
		sret=ascan(dstru,{|x|x[1]==struct[j][1]})
		if sret==0
			app_flag := .t.
			exit
		endif
		if dstru[sret][2]==struct[j][2]
		else
			ret:=EG_DATATYPE
			exit
		endif
	next
	if ret != 0
		use
		errorBlock(eblock)
		select(sel)
		return ret
	endif
	for j=1 to len(dstru)
		sret=ascan(struct,{|x|x[1]==dstru[j][1]})
		if sret==0
			aadd(struct, dstru[j])
			app_flag := .t.
			loop
		endif
		if struct[sret][3]<=dstru[j][3]
			struct[sret][3]=dstru[j][3]
			struct[sret][4]=dstru[j][4]
			app_flag := .t.
		endif
		if struct[sret][3]>dstru[j][3]
			app_flag := .t.
		endif
		if struct[sret][4]<=dstru[j][4]
			struct[sret][4]=dstru[j][4]
			app_flag := .t.
		endif
		if struct[sret][4]>dstru[j][4]
			app_flag := .t.
		endif
	next

	use

	path := makepath(file)
	j := atr(PATH_DELIM,path)
	if j ==0
		ret := EG_CREATE
	else
		path := substr( path, 1, j)
	endif
	tmpname=path+"clip"+alltrim(str(random(10000),4,0))
	if app_flag .and. ret == 0
		file1=file
		file2=tmpname+".dbf"
		delete file (file2)
		rename (file1) to (file2)
		if (file(file1))
			ret := EG_WRITE
		endif
	endif
	if app_flag .and. ret == 0
		file1=substr(file,1,atr(".",file))+"dbt"
		if file(file1)
			file2=tmpname+".dbt"
			delete file (file2)
			if file(file1)
				rename (file1) to (file2)
			endif
			if (file(file1))
				ret := EG_WRITE
			endif
		endif
		file1=substr(file,1,atr(".",file))+"fpt"
		if file(file1)
			file2=tmpname+".fpt"
			delete file (file2)
			if file(file1)
				rename (file1) to (file2)
			endif
			if (file(file1))
				ret := EG_WRITE
			endif
		 endif
	endif
	if ret != 0
		errorBlock(eblock)
		select(sel)
		return ret
	endif
	if app_flag
		begin sequence
			dbcreate(file,struct,rdd)
			use (file) exclusive via rdd
		recover using err
			ret := EG_CREATE
		end sequence
		if neterr()
			ret:= EG_CREATE
		endif
		if ret != 0
			use
			errorBlock(eblock)
			select(sel)
			return ret
		endif
		begin sequence
#ifdef CLIPPER50_COMPATIBLE
			append from (tmpname)
#else
			append from (tmpname) via (rdd)
#endif
		recover using err
			ret := EG_WRITE
		end sequence
		use
	endif
	errorBlock(eblock)
	select(sel)
	delete file (tmpname+".dbf")
	delete file (tmpname+".dbt")
	delete file (tmpname+".fpt")
return  ret
****************************************************************
function __dbSort(file,afields, ufor, uwhile, unext, rec, rest,rdd)
	local rsel:=select(), count:=0, rstruct,i,x1,x2
	local rfields:={},cset:=set(_SET_CANCEL,.f.)
	local err, flag_err:=.f.,  err_block:=errorblock({|x|break(x)})
	local allFlag:=.f., a,d,c,tmpfile,desc:=.f.
	local indString

	outlog(3,"sort to",file,"fields",afields,"for",ufor,"while",uwhile,"next",unext,"record",rec,"rest",rest)
	if empty(file)
		return 0
	endif
	begin sequence
		rstruct=dbstruct()
		if empty(afields)
			allFlag:=.t.
			for i=1 to len(rstruct)
				aadd(rfields, {rstruct[i][1], .f., .f.})
			next
		else
			for i=1 to len(afields)
				afields[i]:=upper(alltrim(afields[i]))
				a:=""; d:=.f.; c:=.f.
				if "/D" $ afields[i]
					d:=.t.
				endif
				if "/C" $ afields[i]
					c:=.t.
				endif
				x1:=at("/",afields[i])
				if x1>0
					a:=alltrim(substr(afields[i],1,x1-1))
				else
					a:=alltrim(afields[i])
				endif
				aadd(rfields,{a,d,c})
			next
		endif
		if len(rfields)==0
			set(_SET_CANCEL,cset)
			err=errorNew()
			err:description:="invalid argument"
			err:genCode:=EG_ARG
			//err:operation:="__DBCOPY"
			eval(errorblock(),err)
			//break(err)
		endif

		tmpfile="clip_sort_tmp_file"+alltrim(str(random(10000),4,0))
		count:=__dbcopy(tmpfile,{}, ufor, uwhile, unext, rec, rest,rdd)
		dbusearea(.t.,rdd,tmpfile,,.f.,,.t.)
		//use (tmpfile) exclusive via (rdd)
		indString:=""
		for i=1 to len(rfields)
			x1:=valType(&(rfields[i][1]))
			x2:=""
			do case
				case x1=="C"
					if rfields[i][3]
						x2:="LOWER("+rfields[i][1]+")"
					else
						x2:=rfields[i][1]
					endif
				case x1=="D"
					x2:="DTOS("+rfields[i][1]+")"
				case x1=="N"
					x2:="STR("+rfields[i][1]+")"
				case x1=="L"
					x2:="iif("+rfields[i][1]+',"1","0")'
			endcase
			if rfields[i][2]
				x2:="DESCEND("+x2+")"
			endif
			indString+=x2+"+"
		next
		indString:=substr(indString,1,len(indString)-1)
		if rdd==NIL
			rdd:=upper(rddSetDefault())
		endif
		if "C" $ substr(rdd,4) /* compaund index */
			//index on &indString tag a to tmpfile
			//ORDCONDSET(  ,  ,  ,  ,  ,  , RECNO() ,  ,  ,  , desc  )
			ORDCONDSET(  ,  ,  ,  ,  ,  , RECNO() ,  ,  ,  , )
			ORDCREATE( "tmpfile" , "a" , indString , {||&indString} ,  )
		else
			DBCREATEINDEX( "tmpfile" , indString , {||&indString} , IIF( .F. , .T. , NIL ) )
			//index on &indString to tmpfile
		endif
		set order to 1
		copy to (file)
		use
		ferase(tmpfile+".dbf")
		ferase(tmpfile+memoext())
		ferase(tmpfile+indexext())
	recover using err
		flag_err:=.t.
	end sequence

	select(rsel)
	set(_SET_CANCEL,cset)
	errorblock(err_block)
	if flag_err
	   err:operation+="/__DBSORT"
	   eval(errorblock(),err)
	   //break(err)
	endif
return count

****************************************************************
function __dbSortOptimize(file,fields,cfor,bfor,uwhile,unext,rec,rest,rdd)
	local f,o,h,r

	if cfor == NIL .or. unext != NIL
		r := __dbSort(file,fields,bfor,uwhile,unext,rec,rest,rdd)
	else
		if f := isfiltered()
			o := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		else
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif

		r := __dbSort(file,fields,bfor,uwhile,unext,rec,rest,rdd)

		dbclearfilter()
		if f
			m6_SetAreaFilter(o)
		endif
	endif
return r

****************************************************************
function m6_SortFor(file,fields,cfor,bfor)
return __dbSortOptimize(file,fields,cfor,bfor)

****************************************************************
static function _m6_copyrec(fields,recnos)
	local rec := dbread(),i,a:={}

	if recnos==NIL .or. recnos
		aadd(a,recno())
	endif
	for i:=1 to len(fields)
		aadd(a,rec[fields[i][1]])
	next
return a

****************************************************************
function m6_CopyToArray(var,fields,cfor,bfor,bwhile,next,recno,rest,recnos)
	local f,o,h,dstru:=array(0),sstru := dbstruct(),i,j,rec,line,x

	if len(fields) == 0
		dstru := sstru
	else
		for j:=1 to len(fields)
			for i:=1 to len(sstru)
				if upper(sstru[i][1]) == alltrim(upper(fields[j]))
					aadd(dstru,sstru[i])
					exit
				endif
			next
		next
	endif
	if f := isfiltered()
		o := m6_FiltCopy(m6_GetAreaFilter())
		h := m6_NewFilter(cfor)
		m6_FiltJoin(m6_GetAreaFilter(),h,2)
	else
		m6_SetAreaFilter(m6_NewFilter(cfor))
	endif

	var := {}
	if recno!=NIL .and. recno > 0
		goto recno
		aadd(var,_m6_copyrec(dstru,recnos))
	else
		if bwhile != NIL
			rest := .t.
		endif
		if empty(rest) .and. next==NIL //rest==NIL .or. !rest
			go top
		endif
		while !eof()
			aadd(var,_m6_copyrec(dstru,recnos))
			if next!=NIL .and. len(var)==next .or.;
				bwhile!=NIL .and. !eval(bwhile)
				exit
			endif
			skip
		enddo
	endif
	dbclearfilter()
	if f
		m6_SetAreaFilter(o)
	endif
return NIL

****************************************************************
function m6_CountFor(cfor,bfor)
	local var := 0

	DBEvalOptimize({|| local(_count:=@var),_count := _count + 1},cfor)
return var

****************************************************************
procedure __ReportFormOptimize(cFRMName,lPrinter,cAltFile,lNoConsole,;
	cFor,bFor,bWhile,nNext,nRecord,lRest,lPlain,cHeading,lBEject,lSummary )

	local f,o,h

	if cfor == NIL .or. nNext != NIL
		__ReportForm(cFRMName,lPrinter,cAltFile,lNoConsole,bFor,bWhile,nNext,;
			nRecord,lRest,lPlain,cHeading,lBEject,lSummary)
	else
		if f := isfiltered()
			o := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		else
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif

		__ReportForm(cFRMName,lPrinter,cAltFile,lNoConsole,bFor,bWhile,nNext,;
			nRecord,lRest,lPlain,cHeading,lBEject,lSummary)

		dbclearfilter()
		if f
			m6_SetAreaFilter(o)
		endif
	endif
return

****************************************************************
procedure m6_ReportForm(frm,print,toFile,noconsole,cfor,bfor,plain,heading,;
	noeject,summary)

	__ReportFormOptimize(frm,print,toFile,noconsole,cfor,bfor,,,,,plain,;
		heading,noeject,summary)
return
/*
****************************************************************
procedure __LabelFormOptimize(cLBLName,lPrinter,cAltFile,lNoConsole,cFor,bFor,bWhile,;
	nNext,nRecord,lRest,lSample)

	local f,o,h

	if cfor == NIL .or. nNext != NIL
		__LabelForm(cLBLName,lPrinter,cAltFile,lNoConsole,bFor,bWhile,;
			nNext,nRecord,lRest,lSample)
	else
		if f := isfiltered()
			o := m6_FiltCopy(m6_GetAreaFilter())
			h := m6_NewFilter(cfor)
			m6_FiltJoin(m6_GetAreaFilter(),h,2)
		else
			m6_SetAreaFilter(m6_NewFilter(cfor))
		endif

		__LabelForm(cLBLName,lPrinter,cAltFile,lNoConsole,bFor,bWhile,;
			nNext,nRecord,lRest,lSample)

		dbclearfilter()
		if f
			m6_SetAreaFilter(o)
		endif
	endif
return

****************************************************************
procedure m6_LabelForm(lbl,print,toFile,noconsole,cfor,bfor,sample)
	__LabelFormOptimize(lbl,print,toFile,noconsole,cfor,bfor,,,,,sample)
return
*/

****************************************************************
function m6_Search(cfor,bfor,var)
	local f,o,h

	if f := isfiltered()
		o := m6_FiltCopy(m6_GetAreaFilter())
		h := m6_NewFilter(cfor)
		m6_FiltJoin(m6_GetAreaFilter(),h,2)
	else
		m6_SetAreaFilter(m6_NewFilter(cfor))
	endif
	go top

	var := {}
	while !eof()
		aadd(var,recno())
		skip
	enddo

	dbclearfilter()
	if f
		m6_SetAreaFilter(o)
	endif
return NIL
****************************************************************
function __DBUPDATE( cAlias, bKey, lRandom, bWith )
	local nSel, xKey, oErr, lErr := .F.

	iif(lRandom==NIL, lRandom:= .F.,)
	goto top
	nSel := Select()
	begin sequence
		select (cAlias)
		goto top
		do while ( !EOF() )
			xKey := eval(bKey)
			select (nSel)
			if ( lRandom )
				dbSeek(xKey, iif( .F., .T., Nil ))
				if ( Found() )
					eval(bWith)
				endif
			else
				do while ( eval(bKey) < xKey .AND. ! EOF() )
					skip
				enddo
				if ( eval(bKey) == xKey .AND. ! EOF() )
					eval(bWith)
				endif
			endif
			select (cAlias)
			skip
		enddo
	recover using oErr
		lErr := .T.
	end sequence
	select (nSel)
	if ( lErr )
		break( oErr )
	endif
return .T.

****************************************************************
function waitRddLock(hRdd,nSeconds,lType)
	local stop_time,locker

	if valtype(nSeconds) != "N"
		nSeconds := 10
	endif
	if valtype(lType) != "L"
		lType := .f.
	endif

	locker=iif(lType,rddFlock(hRdd),rddRlock(hRdd))
	if locker
		return .t.
	endif

	stop_time := seconds()+nSeconds
	do while seconds() < stop_time .and. !locker
		locker=iif(lType,rddFlock(hRdd),rddRlock(hRdd))
		sleep(0.1)
	enddo
return  locker

