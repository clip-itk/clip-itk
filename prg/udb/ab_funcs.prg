/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "box.ch"
#include "config.ch"

****************************************
function ab_padrBody(oData,aBodyDesc)
return codb_padrBody(oData,aBodyDesc)
****************************************
function ab_choice_class(oDict)
	local ret:="", oldcol := setcolor(set("ab_colors_menu"))
	local i,tmp,o,s:=space(20),m:={}
	local x1,x2,y1,y2,scr:=savescreen()

	tmp := oDict:select("CLASS")
	for i=1 to len(tmp)
		o:=oDict:getValue(tmp[i])
		s:=padr(o:name,20)
		s+=" "+o:id
		aadd(m,s)
	next
	y2:=maxcol()-4
	x2:=maxrow()-4
	y1:=y2-len(s)-2
	x1:=x2-14
	dbox(x1, y1, x2, y2,,, [Choice class], [Esc: Cancel] )
	if empty(m)
		alert([CLASS list is empty])
		i:=0
	else
		i := achoice(x1+1,y1+1,x2-1,y2-1,m)
	endif
	if i != 0
		ret:=tmp[i]
	endif
	restore screen from scr
	setcolor(oldcol)
return ret

****************************************
function ab_choice_attr(oDict)
	local ret:="", oldcol := setcolor(set("ab_colors_menu"))
	local i,tmp,o,s:=space(20),m:={}
	local x1,x2,y1,y2,scr:=savescreen()

	tmp := oDict:select("ATTR")
	for i=1 to len(tmp)
		o:=oDict:getValue(tmp[i])
		s:=padr(o:name,20)
		s+=" "+o:id
		s+=" "+o:type
		s+=" "+str(o:len)
		s+=" "+str(o:dec)
		aadd(m,s)
	next
	y2:=maxcol()-4
	x2:=maxrow()-4
	y1:=y2-len(s)-2
	x1:=x2-14
	dbox(x1, y1, x2, y2,,, [Choice attribute], [Esc: Cancel] )
	if empty(m)
		alert([ATTRIBUTE list is empty])
		i:=0
	else
		i := achoice(x1+1,y1+1,x2-1,y2-1,m)
	endif
	if i != 0
		ret:=tmp[i]
	endif
	restore screen from scr
	setcolor(oldcol)
return ret

****************************************
function ab_choice_index(oDict,tmp)
	local ret:="", oldcol := setcolor(set("ab_colors_menu"))
	local i,o,s:=space(20),m:={}
	local x1,x2,y1,y2,scr:=savescreen()

	if empty(tmp)
		tmp := oDict:select("INDEX")
	endif
	for i=1 to len(tmp)
		o:=oDict:getValue(tmp[i])
		s:=padr(o:name,20)
		s+=" "+o:expr
		aadd(m,s)
	next
	y2:=maxcol()-4
	x2:=maxrow()-4
	y1:=y2-len(s)-2
	x1:=x2-14
	dbox(x1, y1, x2, y2,,, [Choice index], [Esc: Cancel] )
	if empty(m)
		alert([INDEX list is empty])
		i:=0
	else
		i := achoice(x1+1,y1+1,x2-1,y2-1,m)
	endif
	if i != 0
		ret:=tmp[i]
	endif
	restore screen from scr
	setcolor(oldcol)
return ret

****************************************
function ab_choice_tcolumn(oDict)
	local ret:="", oldcol := setcolor(set("ab_colors_menu"))
	local i,tmp,o,s:=space(20),m:={}
	local x1,x2,y1,y2,scr:=savescreen()

	tmp := oDict:select("TCOLUMN")
	for i=1 to len(tmp)
		o:=oDict:getValue(tmp[i])
		s:=padr(o:name,20)
		s+=" "+padr(o:header,20)
		aadd(m,s)
	next
	y2:=maxcol()-4
	x2:=maxrow()-4
	y1:=y2-len(s)-2
	x1:=x2-14
	dbox(x1, y1, x2, y2,,, [Choice attribute], [Esc: Cancel] )
	if empty(m)
		alert([TCOLUMN list is empty])
		i:=0
	else
		i := achoice(x1+1,y1+1,x2-1,y2-1,m)
	endif
	if i != 0
		ret:=tmp[i]
	endif
	restore screen from scr
	setcolor(oldcol)
return ret

****************************************
function ab_choice_tview(oDict,tmp)
	local ret:="", oldcol := setcolor(set("ab_colors_menu"))
	local i,o,s:=space(20),m:={}
	local x1,x2,y1,y2,scr:=savescreen()

	if empty(tmp)
		tmp := oDict:select("TVIEW")
	endif
	for i=1 to len(tmp)
		o:=oDict:getValue(tmp[i])
		s:=o:header
		aadd(m,s)
	next
	y2:=maxcol()-4
	x2:=maxrow()-4
	y1:=y2-len(s)-2
	x1:=x2-14
	dbox(x1, y1, x2, y2,,, [Choice table view], [Esc: Cancel] )
	if empty(m)
		alert([TVIEW list is empty])
		i:=0
	else
		i := achoice(x1+1,y1+1,x2-1,y2-1,m)
	endif
	if i != 0
		ret:=tmp[i]
	endif
	restore screen from scr
	setcolor(oldcol)
return ret

****************************************
function ab_choice_report(oDict,tmp)
	local ret:="", oldcol := setcolor(set("ab_colors_menu"))
	local i,o,s:=space(20),m:={}
	local x1,x2,y1,y2,scr:=savescreen()

	if empty(tmp)
		tmp := oDict:select("REPORT")
	endif
	for i=1 to len(tmp)
		o:=oDict:getValue(tmp[i])
		s:=o:name
		aadd(m,s)
	next
	y2:=maxcol()-4
	x2:=maxrow()-4
	y1:=y2-max(len(s),25)-2
	x1:=x2-14
	dbox(x1, y1, x2, y2,,, [Choice report], [Esc: Cancel] )
	if empty(m)
		alert([REPORT list is empty])
		i:=0
	else
		i := achoice(x1+1,y1+1,x2-1,y2-1,m)
	endif
	if i != 0
		ret:=tmp[i]
	endif
	restore screen from scr
	setcolor(oldcol)
return ret


************************************************************
function ab_loadPlugIns(_sFile)
	static pi_cache := map()
	local ret,mKey,sFile
	sFile := _sFile //"plugins"+PATH_DELIM+lower(alltrim(_sFile))

	if !file(sFile) .and. !file(sFile+".prg")
		sFile :=  cliproot()+PATH_DELIM+"codb_ab"+PATH_DELIM+sFile
	endif

	mkey:=alltrim(upper(_sFile))
	if mKey $ pi_cache
		ret := pi_cache[mKey]
	else
		ret := loadPlugIns(sFile)
		if valtype(ret) =="B"
			pi_cache[mKey] := ret
		endif
	endif

return ret

************************************************************
function ab_metaToXml(oDict,fname)
	local hFile,str:="",len,name
	local i,j,k,list,obj
	local aMeta:={;
	{"COUNTER",,"NAME","TYPE","DEPOSIT"},;
	{"ATTR","ATTRIBUTE","NAME","TYPE","LEN","DEC","LENTYPE","MASK","REF_TO",;
			"DEFVALUE","COUNTER","NOT_NULL","NOT_EMPTY",;
			"SOURCE","CODE","HELP"},;
	{"INDEX",,"NAME","EXPR"},;
	{"EXTENT",,"NAME","HELP"},;
	{"DEPOSIT","DEPOSITORY","NAME","MEMOSIZE"},;
	{"CLASS",,"NAME","SUPER_ID","EXTENT_ID","EXPR_ESSENCE","UNIQUE_KEY","LOG_NEED",;
			"ATTR_LIST","IDX_LIST","ATTR_FIND"},;
	{"TCOLUMN",,"NAME","HEADER","FOOTER","WIDTH","EXPR","DEPEND_OF","REFS"},;
	{"TVIEW",,"NAME","CLASS_ID","EXTENT_ID","GROUP_ID","USER_ID","COL_LIST"},;
	{"REPORT",,"NAME","TYPE","FILENAME","CLASS_ID","EXTENT_ID",;
			"GROUP_ID","USER_ID"},;
	{"PLUGINS",,"NAME","TYPE","FILENAME","MAINFUNC","CLASS_ID"};
	}

	hFile := fcreate(fname)
	if hFile < 0
		return [Error creating file:]+fname+";"+ferrorstr()
	endif

	str+='<-- description of dictionary '+oDict:id+' ("'+oDict:name+'") -->'+CRLF+CRLF
	for i=1 to len(ameta)
		str+=CRLF
		str+="<!-- begin metadata "+ameta[i][1]+" -->"+CRLF
		list := oDict:select(aMeta[i][1])
		for j=1 to len(list)
			obj := oDict:getValue(list[j])
			if empty(obj)
				str+='<!-- Error loading object:'+list[j]+' -->'+CRLF
				loop
			endif
			name := iif(empty(aMeta[i][2]),aMeta[i][1],aMeta[i][2])
			str+='<'+lower(name)+'&\t'
			str+=iif(len(name)>6,'','&\t')
			str+=lower(aMeta[i][3])+'&\t= '+metaToString(obj,aMeta[i][3],aMeta[i][1])+CRLF
			for k=4 to len(aMeta[i])
				if aMeta[i][k] $ obj
					str+='&\t&\t'+lower(aMeta[i][k])
					str+=iif(len(aMeta[i][k])>7,'','&\t')
					str+='= '+metaToString(obj,aMeta[i][k],aMeta[i][1])+CRLF
				endif
			next
			str+='/>'+CRLF
		next
		str+="<!-- end metadata "+ameta[i][1]+" -->"+CRLF
		str+=CRLF
	next

	len := fWrite(hFile,str)
	if len !=len(str)
		fclose(hFile)
		return [Error writing to file:]+fname+";"+ferrorstr()
	endif

	fclose(hFile)
return ""

****************
static function metaToString(obj,name, meta)
	local ret, data, type, mname:=obj:name
	local i,s,j,tmp1,tmp2
	if name $ obj
		data := obj[name]
	else
		return '"........"'
	endif
	type := valtype(data)
	do case
	case name $ "EXTENT_ID SUPER_ID CLASS_ID GROUP_ID USER_ID"
		if empty(data)
			ret := '""'
		else
			tmp1 := metagetValue(data)
			if empty(tmp1)
				ret := '"'+data+'"'
			else
				ret := '"'+tmp1:name+'"'
			endif
		endif
	case name $ "ATTR_LIST IDX_LIST ATTR_FIND COL_LIST REFS"
		//"&({'code','unit','name','smallname'})"
		s:=""
		for i=1 to len(data)
			if name $ "ATTR_FIND REFS"
				s+="'"+data[i]+"',"
			else
				tmp1 := metagetValue(data[i])
				if empty(tmp1)
					loop
				endif
				s+="'"+tmp1:name+"',"
			 endif
		next
		s:=substr(s,1,len(s)-1)
		ret := '"&({'+s+'})"'
	case name =="LEN" .and. meta == "ATTR" .and. (obj:type $ "SR")
		ret := '"'+"&(codb_info('CODB_ID_LEN'))"+'"'
	case name == "REF_TO"
		if empty(data)
			ret := '""'
		else
			ret := '"'+left(data,codb_info('DICT_ID_LEN'))+':'
			tmp1 := metagetValue(data)
			if empty(tmp1)
				ret+=data
			else
				ret+=tmp1:name
			endif
			ret+='"'
		endif
	case type =="L"
		ret := iif(data,".t.",".f.")
	case type =="N"
		ret := alltrim(str(data))
	case type =="C"
		ret := '"'+data+'"'
	otherwise
		ret := '"'+toString(data)+'"'
	endcase
return ret
************************
static function metaGetValue(cID)
	local oDict, dict_id:=left(cID,codb_info('DICT_ID_LEN'))
	oDict := codb_dict_reference(dict_id)
	if valtype(oDict) != "O"
		oDict := coDictionary():new(dict_id)
		if empty(oDict:error)
			oDict:open()
			if !empty(oDict:error)
				oDict:close()
				oDict := NIL
			endif
		else
			oDict := NIL
		endif
	endif
	if valtype(oDict) != "O"
		return  cId
	endif
return  oDict:getValue(cId)

