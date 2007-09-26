#include "set.ch"
#include "r2d2lib.ch"

//#define PUT_RDF_TREE

static asdicts:={"GBL01","GBL02","ACC00","ACC01","ETC01"}
static asDeps:= {}
static msDeps:= map()
/************************************************/
function d2ArrToMap(arr)
	local ret := map()
	local i
	for i=1 to len(arr)
		ret[upper(arr[i][1])] := arr[i][2]
	next
return ret

/************************************************/
function cgi_query(p,prg,line)
	local len, ret,data
	ret := p
	if empty(ret)
		ret :=  getenv("QUERY_STRING")
	endif
	if empty(ret)
		len := val(getenv("CONTENT_LENGTH"))
		if len == 0
			ret := ""
		else
			data := space(len)
			len := fread(0,@data,len)
			ret := left(data,len)
		endif
	endif
	outlog(prg,line,pid(),ret)
return ret

/************************************************/
function cgi_text_header()
	qqout("Content-type: text/plain")
	qout()
/************************************************/
function cgi_xml_header()
	qqout('Content-type: text/xml; charset='+host_charset())
	qout()
	qout('<?xml version="1.0" encoding="'+host_charset()+'"?>')
//	qout()
//	qout('<?xml-stylesheet href="chrome://global/skin/" type="text/css"?>')
return ""
/************************************************/
function cgi_html_header(title)
	qqout("Content-type: text/html")
	qout()
	qout('<?xml version="1.0" encoding="'+host_charset()+'"?>')
	qout('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"')
	qout('    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">')
	qout('<html xmlns = "http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">')
	if !empty(title)
		qout( '  <head>')
		qout( '    <title>'+title+'</title>')
		qout( '    <meta http-equiv="content-type" content="text/html; charset='+host_charset()+'">')
		qout( '  </head>')
	endif
return ""
/* этот include - не трогать - пусть тут стоит :) */
#include "r2d2lib.ch"
/************************************************/
function cgi_xml_error(str,ident)
	? '<error>'
	? toString(str)
	if !empty(ident)
		?? ', num='+toString(ident)
	endif
	? '</error>'
return
/************************************************/
function cgi_xml_error2(str,ident)
	? '<error>'
	? toString(str)
	if !empty(ident)
		?? ', num='+toString(ident)
	endif
	? '</error>'
return
*********************************************
function cgi_error2xml(err)
	local i
	if "ARGS" $ err
		for i=1 to len(err:args)
			if valtype(err:args[i]) == "O"
				err:args[i] := "{OBJECT}"
			endif
		next
	endif
	? "<error>"
	i := 1
	while ( !Empty(ProcName(i)) )
		? "Called from", allTrim(ProcName(i)) + ;
			"(" + str(ProcLine(i)) + ")  <BR/>"

		i++
	end
	outlog("object error:",err)
	? "</error>"
return

/************************************************/
function cgi_html_footer()
	? '</BODY>'
	? "</HTML>"
return ""
/************************************************/
function cgi_html_error(str,ident)
	? '<PRE> error description:&\n"'
	? toString(str),' num='+toString(ident)
	? '</PRE>'
return

/************************************************/
function cgi_choice_lang(lang)
		if empty(lang)
			lang := getenv("CLIP_LANG")
			if empty(lang)
				lang := getenv("LANG")
			endif
		endif
		if empty(lang)
			lang := "ru_RU.koi8-r"
		endif
return lang

/************************************************/
function cgi_choice_sDep(lang)
	local i,s1,s2,sDep := ""
	local aDeps:=	{;
			{"ru","01"},;
			{"ua","02"};
			}

	if empty(lang)
		return "01"
	endif
	lang:=substr(lang,1,2)
	i := ascan(aDeps,{|x|x[1]==lang})
	if i>0
		sDep := aDeps[i][2]
	endif
return sDep

/************************************************/
function cgi_choice_sDict(sprname)
	local i,sDict := "", oDict,tmp
	local aDicts:=	{;
			{"currency","GBL01"},;
			{"country","GBL01"},;
			{"units","GBL01"},;
			{"estate_type","GBL01"},;
			{"estate_form","GBL01"},;
			{"t_group","GBL01"},;
			{"commodity_word","GBL01"},;
			{"acc_chart","GBL02"},;
			{"department","GBL02"},;
			{"business_paper","GBL02"},;
			{"region","GBL01"},;
			{"document_type","GBL01"};
			}

	i := ascan(aDicts,{|x|x[1]==sprname})
	if i>0
		sDict := aDicts[i][2]
	else
		if upper(right(sprname,5)) == "_WORD"
			sDict:="GBL01"
		endif
	endif
	if !empty(sDict)
		return sDict
	endif
	for i=1 to len(asDicts)
		oDict := codb_needDepository(asDicts[i])
		if empty(oDict)
			return ""
		endif
		if !empty(oDict:error)
			return ""
		endif
		tmp := oDict:getValue(upper(sprname))
		if !empty(tmp)
			sDict:=asDicts[i]
			sprname := tmp:name
		endif
		if empty(sDict)
			tmp:=oDict:select("CLASS",,sprname)
			if !empty(tmp)
				sDict:=asDicts[i]
			endif
		endif
		if !empty(sDict)
			exit
		endif
	 next
return sDict
************************************************************
function cgi_dataTran(sOut,_queryArr)
	local ret
	local i,j,k,s,s1,s2, sTag
	i := at("<", sOut)
	if i == 0 .or. empty(_queryArr)
		return sOut
	endif
	ret:=substr(sOut,1,i)
	s:=alltrim(substr(sOut,i+1))
	i=at(" ",s)
	if i==0
		i=at("&\t",s)
	endif
	if i==0
		i=at(">",s)+1
	endif
	if i==0
		i=len(s)+1
	endif
	sTag := substr(s,1,i-1)
	s := substr(s,i+1)

	for i=len(_queryArr) to 1 step -1
		j=at("_",_queryArr[i][1])
		if j==0
			loop
		endif
		s1:=substr(_queryArr[i][1],1,j-1)
		s2:=substr(_queryArr[i][1],j+1)
		if ! (sTag == s1)
			loop
		endif
		s := s2+'="'+_queryArr[i][2]+'" '+s
	next

	ret+= sTag +" "+ s
return ret

/************************************************/
function cgi_connect_data(connect_id)
	local tmpDep,i, tmp, ret,Odict, classDesc
	if tmpDep == NIL
		 tmpDep := codb_needDepository("ETC0101")
		 if empty(tmpDep)
			return
		 endif
	endif
	oDict := tmpDep:dictionary()
	tmp:=oDict:select("CLASS",,"connection")
	if empty(tmp)
		return
	endif
	tmp:= tmpDep:select(tmp[1],,,'connect_id=="'+upper(connect_id)+'"')
//	outlog(tmp)
//	for i=1 to len(tmp)
//		ret:= tmpDep:getValue(tmp[1])
//		outlog(ret)
//	next
	if !empty(tmp)
		ret:= tmpDep:getValue(atail(tmp))
	endif
//	outlog(ret)
	if !empty(ret)
		if "ACC00" $ ret .and. !empty(ret:acc00)
			set("ACC00",ret:acc00)
		endif
		if "ACC01" $ ret .and. !empty(ret:acc01)
			set("ACC01",ret:acc01)
		endif
	endif
//	outlog(set("ACC00"),set("ACC01"))
return	ret
/************************************************/
function cgi_essence(oId)
	local ret,idLen1,idLen2,idDep,oDep
	ret := codb_essence(oId)
	if empty(ret) .or. ret==oId
	else
		return ret
	endif
	****** open new depository
	idLen1:=codb_info("DICT_ID_LEN")
	idLen2:=codb_info("DEPOSIT_ID_LEN")
	if substr(oId,idLen1+1,idLen2) == "00"  // metadata
		idDep := left(oId,idLen1)
	else
		idDep := left(oId,idLen1+idLen2)
	endif
	if idDep $ msDeps
		return ret
	else
		oDep := codb_needDepository(idDep)
		//outlog(__FILE__,__LINE__,oDep)
		if empty(oDep) .or. !empty(oDep:error)
		else
			aadd(asDeps, oDep )
		endif
		msDeps[idDep] := idDep
	//outlog(__FILE__,__LINE__,idDep,msDeps)
	endif
	//outlog(__FILE__,__LINE__,len(asDeps),len(msDeps))
return codb_essence(oId)

/************************************************/
function cgi_getValue(oId)
	local ret,idLen1,idLen2,idDep,oDep
	ret := codb_getValue(oId)
	if valtype(ret)=="O"
		return ret
	endif
	****** open new depository
	idLen1:=codb_info("DICT_ID_LEN")
	idLen2:=codb_info("DEPOSIT_ID_LEN")
	if substr(oId,idLen1+1,idLen2) == "00"  // metadata
		idDep := left(oId,idLen1)
	else
		idDep := left(oId,idLen1+idLen2)
	endif
	if idDep $ msDeps
		return ret
	else
		oDep := codb_needDepository(idDep)
		if empty(oDep) .or. !empty(oDep:error)
		else
			aadd(asDeps, oDep )
		endif
		msDeps[idDep] := idDep
	endif
return codb_getValue(oId)
/************************************************/
function cgi_updateObj(obj)
	local i,ret,oId,idLen1,idLen2,idDep,oDep
	ret := .f.
	if valtype(obj)!="O"
		return ret
	endif
	if !("ID" $ obj) .or. empty(obj:id)
		return ret
	endif
	if empty(obj:id)
		return ret
	endif
	oId := obj:id
	****** open new depository
	idLen1:=codb_info("DICT_ID_LEN")
	idLen2:=codb_info("DEPOSIT_ID_LEN")
	if substr(oId,idLen1+1,idLen2) == "00"  // metadata
		idDep := left(oId,idLen1)
	else
		idDep := left(oId,idLen1+idLen2)
	endif
	/* ************** HZ *********** */
	/*
	if idDep $ msDeps
	     ********* 
	else
		oDep := codb_needDepository(idDep)
		if empty(oDep) .or. !empty(oDep:error)
		else
			aadd(asDeps, oDep )
		endif
		msDeps[idDep] := idDep
	endif
	*/
	oDep := codb_needDepository(idDep)
	if empty(oDep) .or. !empty(oDep:error)
		return ret
	endif
return	oDep:update(obj)
/************************************************/
function cgi_needDepository(sDict,sDep)
	local ss

	sDep := iif( valtype(sDep) == "C", sDep, "")

	if empty(set(sDict))
		ss := sDict+sDep
	else
		ss:=set(sDict)
	endif
return codb_needDepository(ss)

/************************************************/
function cgi_openDepositories(sDict,sDep)
	local i,a1,a2,acc,oDep,oDep1,oDep2
	if sDep == NIL
		sDep := "01"
	endif
	for i=1 to len(asDicts)
		if sDict == asDicts[i]
			loop
		endif
		a1 := asDicts[i]+sDep
		a2 := codb_dep_reference(a1)
		if !empty(a2)
			loop
		endif
		oDep := coDepository():new(a1)
		aadd(asDeps,oDep)
		msDeps[a1] := a1
		if "OPEN" $ oDep
			oDep:open()
		endif
		oDep := NIL
	next
return

/************************************************/
function cgi_depository(sDep)
	local oDep,lang:=""
	lang:=cgi_choice_lang(lang)
	sDep+=cgi_choice_sDep(lang)

	oDep := codb_needDepository(sDep)
	if empty(oDep)
		return
	endif
return oDep

***********************
function bal_summa(summa)
	local str:=str(summa,15,2)
	local ret:=""
	ret+=substr(str,1,3)+" "
	ret+=substr(str,4,3)+" "
	ret+=substr(str,7,3)+" "
	ret+=substr(str,10)
return ret
***********************
function sort_summa(summa,len,dec)
	 local ret := 0
	 if summa<0
	     ret := '-'+padl(alltrim(str(abs(summa),len,dec)),14,"0")
	 else
	     ret := padl(alltrim(str(summa,len,dec)),14,"0")
	 endif

return ret
***********************
function bal_num(num)
	local str:=str(num,8,3)
	if left(str,1)=="*"
		str:=str(num,15,2)
	endif
return str

***********************
function make_doc_list(type,beg_date,end_date,oDep)
	local aData:={},s:="",tmp,oDict
	local i,j,obj,data,attr,aname, accpost
	local class_desc,attrs:={}
	oDict:=oDep:dictionary()
	class_desc:=oDict:classBodyByName(type)
	if empty(class_desc)
		cgi_xml_error("Class description not found:"+type)
		return aData
	endif
	for i=1 to len(class_desc:attr_list)
		attr := oDict:getValue(class_desc:attr_list[i])
		if empty(attr)
			loop
		endif
		aadd(attrs, attr)
	next
	if !empty(beg_date)
		s+='odate>=stod("'+dtos(beg_date)+'")'
	endif
	if !empty(end_date)
		if !empty(s)
			s+=" .and. "
		endif
		s+='odate<=stod("'+dtos(end_date)+'")'
	endif
	//tmp:=oDep:select(class_Desc:id,1,,s)
	tmp:=oDep:select(class_Desc:id,,,s)
	if empty(tmp)
		return aData
	endif
	for i=1 to len(tmp)
		obj:=oDep:getValue(tmp[i])
		if empty(obj)
			loop
		endif
		data:=map()
		data:id := obj:id
		data:odate := iif ("ODATE"$obj,obj:odate,"")
		data:summa := iif ("SUMMA"$obj,obj:summa,0.00)
		data:doc_number := iif ("DOC_NUMBER"$obj,obj:doc_number,"")
		data:doc_person := iif ("DOC_PERSON"$obj,obj:doc_person,"")
		data:__attrs:={}
		for j=1 to len(attrs)
			attr:=attrs[j]
			aname:=upper(attr:name)
			if aname $ "ID ODATE SUMMA DOC_NUMBER DOC_PERSON"
				loop
			endif
			if aname == "ACCPOST_LIST"
				accPost:=obj:accpost_list
				if !empty(accPost)
					accPost:=oDep:getValue(accPost[1])
				endif
				if empty(accPost)
					accPost:=map()
					accPost:dAccount:=""
					accPost:kAccount:=""
					accPost:summa:=0.00
				endif
				aadd(data:__attrs,{attr:name,accPost})
			else
			aadd(data:__attrs,{attr:name,obj[aname]})
			endif
		next
		aadd(aData,data)
	next
return aData

*************
function r2d2_get_osb_data(oDep,bal_id,account,beg_date,end_date,s1,s2)
	local i,j,s,tmp,obj,data:=map()
	local max_date:=beg_date-1,min_date:=end_date+1

	data:id         := account:id+"_"+dtos(beg_date)+"_"+dtos(end_date)
	data:account	:= account:id
	data:smallname	:= account:smallname
	data:code	:= account:code
	data:owner_id	:= account:owner_id
	data:bd_summa	:= 0.00
	data:bk_summa	:= 0.00
	data:od_summa	:= 0.00
	data:ok_summa	:= 0.00
	data:ed_summa	:= 0.00
	data:ek_summa	:= 0.00

	if empty(s1)
		s1:= ' .and. odate>=stod("'+dtos(beg_date)+ '") .and. odate<=stod("'+dtos(end_date)+ '")'
	endif
	s:='account=="'+account:id+'"'
	tmp := oDep:select(bal_id,1,,s+s1)
	//outlog(__FILE__,__LINE__,s+s1,len(tmp))

	for j=1 to len(tmp)
		obj:=oDep:getValue(tmp[j])
		/*
		outlog(__FILE__,__LINE__,j,obj:odate,obj)
		outlog(__FILE__,__LINE__,j,obj:bd_summa,obj:bk_summa)
		outlog(__FILE__,__LINE__,j,obj:od_summa,obj:ok_summa)
		outlog(__FILE__,__LINE__,j,obj:ed_summa,obj:ek_summa)
		outlog(__FILE__,__LINE__)
		*/
		if empty(obj) .or. obj:odate<beg_date
			loop
		endif
		if obj:odate > end_date
			exit
		endif
		if obj:odate < min_date
			data:bd_summa := obj:bd_summa
			data:bk_summa := obj:bk_summa
			min_date := obj:odate
		endif
		data:od_summa += obj:od_summa
		data:ok_summa += obj:ok_summa
		if obj:odate > max_date
			data:ed_summa := obj:ed_summa
			data:ek_summa := obj:ek_summa
			max_date := obj:odate
		endif
		//outlog(__FILE__,__LINE__,j,data)
	next
	if empty(tmp)
		if empty(s2)
			s2:= ' .and. odate<stod("'+dtos(beg_date)+ '")'
		endif
		tmp := oDep:select(bal_id,1,,s+s2,-1)
		//outlog(__FILE__,__LINE__,s+s2,tmp)
	else
		tmp :=NIL
	endif
	if !empty(tmp)
		obj := NIL
		for j=len(tmp) to 1 step -1
			obj:=oDep:getValue(tmp[j])
			if !empty(obj)
				exit
			endif
		next
		//outlog(__FILE__,__LINE__,obj)
		if !empty(obj)
			data:bd_summa := obj:ed_summa
			data:bk_summa := obj:ek_summa
			data:ed_summa := obj:ed_summa
			data:ek_summa := obj:ek_summa
		endif
	endif
return data

***********************
function cgi_make_columns(oDict,sprname,type,atom)
	// type is
	// 0 - default, all columns
	// 1 - only attr_find or first 2 attributes
	// 2 - only menu_list or essence value
	local tmp,tmp2,i,j,columns:={},col, attr, attr_list:={}
	local i_list:={}, classDesc, oEmp,attrEmp
	local a1,a2,a3

	type := iif(type==NIL,0,type)
	atom := iif(valType(atom)!="L",.f.,atom)

	classDesc := oDict:classBodyByName(sprName)
	oEmp := oDict:padrBody(map(),classDesc:id,.t.)
	if !empty(classDesc)
		tmp2:=classDesc:idx_list
		for i=1 to len(tmp2)
			col:=oDict:getValue(tmp2[i])
			if !empty(col)
				aadd(i_list,col)
			endif
		next
		if type==2 .and. "MENU_LIST" $ classDesc
			tmp2:=classDesc:menu_list
			for i=1 to len(tmp2)
				col:=oDict:attrBodyByName(tmp2[i])
				if !empty(col)
					aadd(attr_list,col)
				endif
			next
		endif
		//if (type==1 .or. (type==2 .and. empty(attr_list))) .and. "ATTR_FIND" $ classDesc
		if type==1 .and. "ATTR_FIND" $ classDesc
			tmp2:=classDesc:attr_find
			for i=1 to len(tmp2)
				col:=oDict:attrBodyByName(tmp2[i])
				if !empty(col)
					aadd(attr_list,col)
				endif
			next
		endif
		if type==0 .or. (type==1 .and. empty(attr_list))
			tmp2:=classDesc:attr_list
			for i=1 to len(tmp2)
				col:=oDict:getValue(tmp2[i])
				if !empty(col)
					aadd(attr_list,col)
				endif
				if type==1 .and. len(attr_list) == 2
					exit
				endif
			next
		endif
	endif
	tmp := NIL
	if type == 0
		tmp := oDict:select("TVIEW",,,'class_id=="'+classDesc:id+'"')
	endif
	if empty(tmp)
		for i=1 to len(attr_list)
			col := NIL
			attr := attr_list[i] //oDict:getValue(tmp:attr_list[i])
			if empty(attr)
				loop
			endif
			tmp2 := upper(attr:name)
			/*
			if tmp2 $ "OWNER_ID"
				loop
			endif
			*/
			attrEmp := NIL
			if tmp2 $ oEmp
				attrEmp := oEmp[tmp2]
			endif
			tmp2:=oDict:select("TCOLUMN",,attr:name)
			if !empty(tmp2)
				col := oDict:getValue(tmp2[1])
			endif
			if empty(col)
				col:=map()
				col:id      := ""
				col:attr_id := attr:id
				col:name    := attr:name
				col:header  := attr:name
				col:width   := attr:len
				col:dataLen := attr:len
				col:dataDec := attr:dec
				col:dataType:= attr:type
				col:dataRefTo:= attr:ref_to
				col:datamask := attr:mask
				col:expr    := attr:name
				col:footer  := ""
			 else
				col:attr_id := col:id
				for j=1 to len(attr_list)
					attr := attr_list[j]
					if attr:name == col:expr .or. attr:name==col:name
						col:attr_id := attr:id
						col:dataLen := attr:len
						col:dataDec := attr:dec
						col:dataType:= attr:type
						col:dataRefTo:= attr:ref_to
						col:datamask := attr:mask
					endif
				next
			 endif
			col:defvalue := attrEmp
			aadd(columns,col)
		next
	else
		tmp := oDict:getValue(tmp[1])
		for i=1 to len(tmp:col_list)
			col := oDict:getValue(tmp:col_list[i])
			if !empty(col)
				aadd(columns,col)
			else
				loop
			endif
			col:attr_id := col:id
			col:dataLen := col:width
			col:dataDec := 2
			col:dataType:= "U"
			col:dataRefTo:= ""
			for j=1 to len(attr_list)
				attr := attr_list[j]
				if attr:name == col:expr .or. attr:name == col:name
					col:attr_id := attr:id
					col:dataLen := attr:len
					col:dataDec := attr:dec
					col:dataType:= attr:type
					col:dataRefTo:= attr:ref_to
					col:datamask := attr:mask
					col:defvalue := attr:defvalue
					if upper(attr:name) $ oEmp
						col:defvalue := oEmp[upper(attr:name)]
					endif
				endif
			next
		next
	endif
	if type==2 .and. empty(attr_list)
		col:=map()
		col:id      := ""
		col:attr_id := ""
		col:name    := "essence" //attr:name
		col:header  := ""
		col:width   := 0
		col:dataLen := 0
		col:dataDec := 0
		col:dataType:= "C"
		col:dataRefTo:= ""
		col:datamask := ""
		col:expr    := classDesc:expr_essence
		col:footer  := ""
		aadd(columns,col)
	endif
	if atom .and. "UNIQUE_KEY" $ classDesc .and. !empty(classDesc:unique_key)
		col:=map()
		col:id	    := ""
		col:attr_id := classDesc:id+"ukey"
		col:name    := "unique_key"
		col:header  := ""
		col:width   := 50
		col:dataLen := 0
		col:dataDec := 0
		col:dataType:= "C"
		col:dataRefTo:= ""
		col:datamask := ""
		col:expr    := classDesc:unique_key
		col:footer  := ""
		aadd(columns,col)
	endif
	col:=map()
	col:id	    := ""
	col:attr_id := classDesc:id+"idattr"
	col:name    := "id"
	col:header  := ""
	col:width   := codb_info("CODB_ID_LEN")
	col:expr    := "id"
	col:footer  := ""
	aadd(columns,col)

	for i=1 to len(columns)
		col:=columns[i]
		if empty(col:expr)
			col:block := &('{||"'+[Error in tcolumn expression]+'"}')
		else
			col:block := &("{|p1,p2,p3,p4|"+col:expr+"}")
		endif
		col:isindex:=.f.
		col:isindex_num:=0
		for j=1 to len(i_list)
			if i_list[j]:expr == col:expr
				col:isIndex := .t.
				col:isindex_num:=j
				exit
			endif
		next
		if !("DATAMASK" $ col)
			col:datamask := ""
		endif
		if "DATAREFTO" $ col
			a1:= left(col:datarefto,codb_info("DICT_ID_LEN"))
			a2 := codb_dict_reference(a1)
			a3:=NIL
			if !empty(a2)
				a3 := a2:getValue(col:datarefto)
			endif
			if !empty(a3)
				col:datarefto := a3:name
			endif
		endif
	next
return columns

**********************
function cgi_objDesc(obj,col)
	local sTmp:="",sOut:="",obj_id:="",obj_name:="",ret:=map()
	local obj2,k,s,l,name
	loca oDict,dict_id,tcol,dan:="",dal:=""
	sTmp := mapEval(obj,col:block)
	//outlog(__FILE__,__LINE__,col)
	name := upper(col:name)
	if "DATATYPE" $ col .and. col:datatype == "S"
		obj_id := sTmp
		obj2:=cgi_getValue(sTmp)
		if !empty(obj2)
			k:= codb_tColumnBody(obj2:id)
			if !empty(k)
				sTmp := k:header //+':'+obj2:name
			else
				sTmp := obj2:name+":"+obj2:id
			endif
		endif
	elseif "DATATYPE" $ col .and. col:datatype == "R"
		obj_id:=sTmp
		name := upper(col:name)
		if name $ obj
			obj_id:=obj[name]
		endif
		obj2:=cgi_getValue(obj_id)
		if !empty(obj2)
			sTmp := cgi_essence(obj2) //krNameOnly(obj2)
			s := cgi_getValue(obj2:class_id)
			if !empty(s)
				obj_name := s:name
			endif
		endif
	elseif name == "AN_DEBET"
		for k=1 to len(obj:an_debet)
			//sOut += 'dan'+alltrim(str(k))+'="'+obj:an_debet[k][2]+'" '
			//sOut += 'dal'+alltrim(str(k))+'="'+cgi_essence(obj:an_debet[k][2])+'" '
			dan+=obj:an_debet[k][2]+","
			dal+=cgi_essence(obj:an_debet[k][2])+","
		next
		dan:=substr(dan,1,len(dan)-1)
		dal:=substr(dal,1,len(dal)-1)
		sOut := 'an_ref="'+dan+'" an_data="'+dal+'"'
		sTmp:= alltrim(str(len(obj:an_debet)))
	elseif name == "AN_KREDIT"
		for k=1 to len(obj:an_kredit)
			//sOut+= 'kan'+alltrim(str(k))+'="'+obj:an_kredit[k][2]+'" '
			//sOut+= 'kal'+alltrim(str(k))+'="'+cgi_essence(obj:an_kredit[k][2])+'" '
			dan+=obj:an_kredit[k][2]+","
			dal+=cgi_essence(obj:an_kredit[k][2])+","
		next
		dan:=substr(dan,1,len(dan)-1)
		dal:=substr(dal,1,len(dal)-1)
		sOut := 'an_ref="'+dan+'" an_data="'+dal+'"'
		sTmp:= alltrim(str(len(obj:an_kredit)))
	elseif valtype(sTmp) == "C"
		sTmp := strtran(sTmp,'"',"")
		sTmp := strtran(sTmp,'&',"")
		sTmp := strtran(sTmp,'<',"")
		sTmp := strtran(sTmp,'>',"")
	elseif valtype(sTmp) == "L"
		sTmp:= iif(sTmp,"true","false")
	elseif valtype(sTmp) == "N"
		if "DATALEN" $ col
			l := col:datalen
		else
			l := len(stmp)
		endif
		sTmp := alltrim(Str(sTmp,20,dec(stmp)))
		l:=max(l,len(stmp))
		sTmp := padl(sTmp,l)
	else
		sTmp := toString(sTmp)
	endif
	ret:label    := sTmp
	ret:obj_id   := obj_id
	ret:obj_name := obj_name
	ret:out      := sOut
return ret

**********************
function krName(obj)
	local ret:=""
	local cClass := cgi_getValue(obj:class_id)
return cClass:essence(obj)

**********************
function krNameOnly(obj)
	local ret:=""
	local cClass := cgi_getValue(obj:class_id)
return cClass:essence(obj)

**********************
function sdtod(s,d1,d2)
	local i, forms:={"dd.mm.yy","yy.mm.dd","mm.dd.yy"}
	local s1,s2,s3,d_tmp
	d1:=stod("        ")
	d2:=stod("        ")
	s:=strtran(s," ","")
	s:=strtran(s,"/",".")
	s:=strtran(s,"-",".")
	if "#" $ s
		i := at("#",s)
		s1 := left(s,i-1)
		s2 := substr(s,i+1)
		if ! sdtod(s1,@d1,@d_tmp) .or. !sdtod(s2,@d2,@d_tmp)
			return .f.
		endif
		return .t.
	endif
	d1 := stod(s)
	if !empty(d1) .and. year(d1)>1800 .and. year(d1)<4000 .and. d1==stod(dtos(d1))
		d2:=d1
		return .t.
	endif
	for i=1 to len(forms)
		d1 := ctod(s,forms[i])
		if !empty(d1) .and. d1==ctod(dtoc(d1,forms[i]),forms[i])
			d2:=d1
			exit
		endif
	next
	if !empty(d1)
		return .t.
	endif
	if !isdigit(s)
		return .f.
	endif
	for i=1 to len(s)
		if !isdigit(substr(s,i,1))
			exit
		endif
	next
	if i==5  /* year  */
		i := val(s)
		if i<1000 .or. i>3000
			return .f.
		endif
		d1 := ctod("01.01."+s,"dd.mm.yy")
		d2 := ctod("31.12."+s,"dd.mm.yy")
		return .t.
	endif
	s1 := padl(substr(s,1,i-1),2,"0")
	s3 := substr(s,i)
	for i=1 to len(s3)
		if isdigit(substr(s3,i,1))
			exit
		endif
	next
	s2 := upper(substr(s3,1,i-1))
	s3 := substr(s3,i)
	if empty(s2)
		return .f.
	elseif s2 $ [KQК]     /* quartel */
		s1 := val(s1)
		if s1<1 .or. s1>4
			return .f.
		endif
		s1 := (s1-1)*3+1
		d1 := ctod(s3+"."+str(s1,2,0)+".01","yy.mm.dd")
		d2 := ctod(s3+"."+str(s1+2,2,0)+".01","yy.mm.dd")
		d2 := eom(d2)
		return .t.
	elseif s2 $ [MМ]  /* month   */
		i := val(s1)
		if i<1 .or. i>12
			return .f.
		endif
		d1 := ctod(s3+"."+s1+".01","yy.mm.dd")
		d2 := eom(d1)
		return .t.
	elseif s2 $ [WNН] /* week    */
		s1 := val(s1)
		if s1<1 .or. s1>60
			return .f.
		endif
		d1 := ctod(s3+".01.01","yy.mm.dd")
		d1 += (s1-2)*7
		while week(d1)<s1
			d1++
		end
		d1++
		d2:=d1+6
		return .t.
	else
		return .f.
	endif
return .f.

********************
function cgi_aRefs(oDep,classDesc,columns,_query,find_wrap,Serr,includeAll,lOwnerTree,fullList,needDeleted)
	local s_obj, aRefs, idList, refList
	local sDict,sDep,oDep02,oDict02,oDict, children
	local i,j,k,l,obj
	local isExpr
	s_obj := cgi_make_select_string(columns,_query,find_wrap,@Serr)
	//outlog(__FILE__,__LINE__,"columns=", columns)
	//outlog(__FILE__,__LINE__,"s_obj=", s_obj)
	isExpr:= iif(isExpr==NIL,.f.,isExpr)
	fullList:= iif(fullList==NIL,.f.,fullList)
	//outlog(__FILE__,__LINE__,needDeleted)
	needDeleted:= iif(valtype(needDeleted)=="L",needDeleted,.f.)
	for i=1 to len(columns)
		j := upper(columns[i]:name)
		if j $ _query
			isExpr := .t.
			exit
		endif
	next
	if !empty(sErr)
		return aRefs
	endif
	if includeAll == NIL
		includeAll := .f.
	endif
	set exact off
	if !empty(s_obj:refExpr) .and. !empty(s_obj:classDesc)
		sDep := cgi_choice_sDep(cgi_choice_lang())
		sDict := cgi_choice_sDict(s_obj:classDesc:name)
		oDep02 := codb_dep_reference(sDict+sDep)
		children := {}
		if !empty(oDep02)
			oDict02 := oDep02:dictionary()
			children := oDict02:select("CLASS",,,'SUPER_ID=="'+s_obj:classDesc:id+'"')
			asize(children,len(children)+1)
			ains(children,1)
			children[1] := s_obj:classDesc:id
		endif
		refList:=map()
		for i=1 to len(children)
			iDlist:=oDep02:select(children[i],,,s_obj:refExpr)
			for j=1 to len(idList)
				refList[idList[j]] := idList[j]
			next
		next
		//outlog(__FILE__,__LINE__, "reflist=",reflist)
		//outlog(__FILE__,__LINE__, "children=",children)
		if empty(children)
			refList := NIL
		endif
	endif

	if refList != NIL .and. empty(refList)
		return {}
	endif
	if empty(s_obj:expr) .and. empty(refList) .and. !fullList
		if isExpr
			return {}
		else
			return aRefs
		endif
	endif
	aRefs := {}

	if !empty(s_obj:expr) .or. includeAll .or. !empty(refList)
		oDict := oDep:dictionary()
		children := oDict:select("CLASS",,,'SUPER_ID=="'+classDesc:id+'"')
		asize(children,len(children)+1)
		ains(children,1)
		children[1] := classDesc:id
		for i=1 to len(children)
			if empty(s_obj:expr)
				iDlist:=oDep:select(children[i],s_obj:nIndex,,,,needDeleted)
			else
				iDlist:=oDep:select(children[i],s_obj:nIndex,,s_obj:expr,,needDeleted)
			endif
			//outlog(needDeleted,idList)
		  //	outlog(__FILE__,__LINE__,children[i],s_obj:expr,len(idList))
			for j=1 to len(idList)
				obj:=oDep:getValue(idList[j])
				if refList !=NIL
					if s_obj:refName $ obj .and. obj[s_obj:refName] $ refList
					else
						loop
					endif
				endif
				if needDeleted .and. obj:__version >=0
					loop
				endif
				k:=""
				if "CODE" $ obj
					k:= obj:code
				elseif "NAME" $ obj
					k:= obj:name
				endif
				if "OWNER_ID" $ obj //.and. empty(s_obj:expr)
					aadd(aRefs,{obj:id,obj:owner_id,k,obj})
				else
					aadd(aRefs,{obj:id,"",k,obj})
				endif
			next
		next
	endif
	if lOwnerTree==NIL .or. lOwnerTree==.t.
		cgi_checkTreeArefs(arefs,oDep)
	endif
return aRefs
**********************
function cgi_checkTreeArefs(arefs,oDep)
	local i,j,k,l,obj,mcheck:=map()
	for i=1 to len(aRefs)
		mcheck[aRefs[i][1]] := aRefs[i][1]
	next
	for j=1 to 10
		l := 0
		for i=1 to len(aRefs)
			if empty(aRefs[i][2])
				loop
			endif
			if aRefs[i][2] $ mcheck
				loop
			endif
			obj:=oDep:getValue(aRefs[i][2])
			if empty(obj)
				obj:=cgi_getValue(aRefs[i][2])
			endif
			if empty(obj)
				outlog(__FILE__,__LINE__,"Can`t load object:",aRefs[i][2])
				loop
			endif
			k:=""
			if "CODE" $ obj
				k:= obj:code
			elseif "NAME" $ obj
				k:= obj:name
			endif
			if "OWNER_ID" $ obj
				aadd(aRefs,{obj:id,obj:owner_id,k,obj})
			else
				aadd(aRefs,{obj:id,"",k,obj})
			endif
			mcheck[obj:id] := obj:id
			l++
		next
		if l==0
			exit
		endif
	next
return
**********************
function cgi_make_select_string(columns,_query, wrap,err)
	local i,j,j1,j2,k,x, lor, col, attrName
	local ret, expr:=space(7), refExpr
	local tmp,tmp1,tmp2,classDesc, refName,fName, attrDesc, value
	local wName, nIndex:=0
	local d1,d2,d3,d4
	local s,s1,s2,e1,e2
	// wrap is
	// find1 -> column field 1
	// find2 -> column field 1
	// ...

	lor := "FIND" $ _query

	err := ""
	for i=1 to len(columns)
		col := columns[i]
		if empty(wrap) .and. !lor
			attrName := upper(col:name)
		else
			attrName := "FIND"+alltrim(str(col:isindex_num,1,0))
			if !empty(wrap) .and. (attrName $ wrap)
			else
				if lor .and. col:isIndex
					attrName := "FIND"
				else
					loop
				endif
			endif
		endif
		if (! ( attrName $ _query) ) //.or. empty(_query[attrName])
			loop
		endif
		if col:isIndex .and. empty(nIndex)
			nIndex := col:isIndex_num
		endif

		//s:=alltrim(_query[attrName])
		s:=_query[attrName]
		s1:=s2:=s
		e1:=">="; e2 := "<="
		j1:= at(">",s)
		j2:= at("<",s)
		if j1<=0 .and. j2<=0
		elseif j1>j2 .and. j2>0
			s := substr(s,j1) + substr(s,1,j1-1)
			s1:=s2:=s
		endif
		j1:= at(">",s)
		j2:= at("<",s)
		if j1<=0 .and. j2<=0
		else
			   if j2<=0
				s2:=""
			   else
				s1:=substr(s,1,j2-1)
			   endif
			   if !__check_expr(j1,@s1,@e1)
				err += "Bad expression:"+s1+","
			   endif
			   if !empty(s2) .and. !__check_expr(j2,@s2,@e2)
				err += "Bad expression:"+s2+","
			   endif
		endif
		if lor
			refExpr := ""
		endif
		if  !lor .and. empty(refExpr) .and. col:dataType == "R" .and. !empty(col:dataRefTo) .and. len(s) != codb_info("CODB_ID_LEN")
			   refName := col:expr
			   classDesc := codb_classBodyByName(col:dataRefTo)
			   if !empty(classDesc)
				if "IDX_MAIN" $ classDesc .and. !empty(classDesc:idx_main)
					fName := classDesc:idx_main
				else
					for j=1 to len(classDesc:idx_list)
						tmp := cgi_getValue(classDesc:idx_list[j])
						if empty(tmp)
							loop
						endif
						if isWord(tmp:expr)
							fName := tmp:expr
							exit
						endif
					next
				endif
			   endif
			   if !empty(fname)
				for j=1 to len(classDesc:attr_list)
					tmp := cgi_getValue(classDesc:attr_list[j])
					if empty(tmp)
						loop
					endif
					if tmp:name == fname
						attrDesc := tmp
						exit
					endif
				next
			   endif
			   if !empty(attrDesc)
				if attrDesc:type $ "SRC"
					x := atr('"',s)
					if x>0
					    s := substr(s,1,x-1)
					endif	    			
					value   := s
					refExpr := fname+'="'+value+'"'
				elseif attrDesc:type $ "N"
					value   := val(s)
					refExpr := fname+'='+str(value)
				elseif attrDesc:type $ "D"
					if !sdtod(s1,@d1,@d2)
						err += "Bad date format:"+s1+","
						fname := NIL
					else
						value   := d1
						refExpr := fname+'= stod("'+dtos(d1)+'")'
					endif
				else
					fname := NIL
				endif
			   else
				fname := NIL
			   endif
		elseif col:dataType $ "SRC"
			//outlog(__FILE__,__LINE__,col)
			tmp1 := col:expr
			if col:DataType == "R" .and. !empty(col:attr_id)
				tmp1 := col:name
			endif
			x := atr('"',s)
			if x>0
			    s := substr(s,1,x-1)
			endif	    			
			x := atr('"',s1)
			if x>0
			    s1 := substr(s1,1,x-1)
			endif	    			
			x := atr('"',s2)
			if x>0
			    s2 := substr(s2,1,x-1)
			endif	    			
			if s1==s2 .or. lor
				if empty(s)
					expr+= tmp1+'=="'+s+'"'+iif(lor," .or.  "," .and. ")
				else
					expr+= tmp1+'="'+s+'"'+iif(lor," .or.  "," .and. ")
				endif
			else
				if !empty(s1)
					expr+= tmp1+e1+'"'+s1+'" .and. '
				endif
				if !empty(s2)
					expr+= tmp1+e2+'"'+s2+'" .and. '
				endif
			endif
		elseif col:dataType $ "N"
			if (s1==s2 .and. !lor) .or. (lor .and. val(s1)!=0)
				expr+= col:expr+'='+alltrim(str(val(s1)))+iif(lor," .or.  "," .and. ")
			elseif !(s1==s2)
				if !empty(s1)
					expr+= col:expr+e1+alltrim(str(val(s1)))+' .and. '
				endif
				if !empty(s2)
					expr+= col:expr+e2+alltrim(str(val(s2)))+' .and. '
				endif
			endif
		elseif col:dataType $ "D"
			if !sdtod(s1,@d1,@d2)
				err += "Bad date format:"+s1+","
			endif
			if !empty(s2)
				if !sdtod(s2,@d3,@d4)
					err += "Bad date format:"+s2+","
				endif
				d2:=d4
			endif
			if lor .and. !empty(err)
				err := ""
			else
				//outlog(__FILE__,__LINE__,d1,d2,lor,col:expr,err)
				if (d1==d2 .and. empty(e1) .and. !lor) .or. (lor .and. !empty(d1))
					expr+= col:expr+'= stod("'+dtos(d1)+'")'+iif(lor," .or.  "," .and. ")
				elseif !(d1==d2)
					if empty(e1)
						e1 := ">="
					endif
					if empty(e2)
						e2 := "<="
					endif
					expr+= col:expr+e1+'stod("'+dtos(d1)+'") .and. '
					if !empty(s2)
						expr+= col:expr+e2+'stod("'+dtos(d2)+'") .and. '
					endif
				else
					expr+= col:expr+'= stod("'+dtos(d1)+'") .and. '
				endif
			endif
		endif
	next
	expr := ltrim(substr(expr,1,len(expr)-7))
	if lor .and.  !empty(expr)
		expr :="("+expr+")"
	endif
	ret  := map()
	ret:expr := expr
	ret:nIndex := nIndex
	ret:refName := alltrim(upper(refName))
	ret:fname := alltrim(upper(fname))
	ret:value := value
	ret:refExpr := refExpr
	ret:classDesc := classDesc
return ret
**********************
static function __check_expr(pos,s,e)
	if pos<=0
		s := ""
		e := ""
		return .t.
	endif
	if  substr(s,pos+1,1) == "="
		  e := substr(s,pos,2)
		  s := substr(s,pos+2)
	else
		  e := substr(s,pos,1)
		  s := substr(s,pos+1)
	endif
return !empty(s)
**********************
**********************
**********************
* операции с проводками и автопроводками.
**********************
function r2d2_mt_oper(MT_oper,oDep,obj)
	local ret:=""
	local oDict,oDep02,oDict02
	local acc_trans_obj,filename,bCode
	local command,err

	oDep02 := codb_dep_reference("GBL0201")
	if empty(oDep02)
		outlog("MT warning",__LINE__,"GBL0201 not opened")
		return ret
	endif
	oDict02 := oDep02:dictionary()
	oDict   := oDep:dictionary()
	if !("ACC_TYPE_TRANS" $ obj)
		obj:acc_type_trans := ""
		/*
		outlog("MT warning",__LINE__,"accpost object don`t have attribute ACC_TYPE_TRANS")
		return ret
		*/
	endif
	//	acc_trans_obj := oDep02:getValue(obj:acc_type_trans)
	/*
	if empty(acc_trans_obj)
		outlog("MT warning",__LINE__,"accpost object have undefined reference to ACC_TYPE_TRANS")
		return ret
	endif
	*/

	filename := ""//iif("FILENAME" $ acc_trans_obj,acc_trans_obj:filename,"")
	//outlog("MT message",__LINE__,"ACC_TYPE_TRANS filename found:",filename)
	if !empty(filename)
		bCode := oDict:loadModule(filename)
		if !empty(oDict:error)
			outlog("MT error",__LINE__,oDict:error)
			return oDict:error
		endif
		bCode := oDict:getModule(filename)
		if valtype(bCode) != "B"
			ret := "Error: can`t load module:"+filename
			outlog("MT error",__LINE__,ret)
			return ret
		endif
	endif
	switch (mt_oper)
		case "delete_accpost"
			command := "delete"
		case "append_accpost"
			command := "append"
		case "update_accpost"
			command := "update"
		otherwise
			command := ""
	endswitch
	if empty(command)
		ret := "Error: unknown MT operation:"+mt_oper
		outlog("MT error",__LINE__,ret)
		return ret
	endif
	if empty(bCode)
		switch (command)
			case "delete"
				oDep:delete(obj:id)
			case "append"
				oDep:append(obj)
			case "update"
				oDep:update(obj)
		endswitch
		ret := oDep:error
	else
		//err := errorblock({|e|outlog("MT run block error:",e),break(e)}
		outlog("MT:",__LINE__,"call command",command,obj)
		eval(bCode,command,oDep,obj)
		outlog("MT:",__LINE__,"call end",command,obj)
		//errorBlock(err)
	endif
return ret
****************************
function r2d2_acc_constant(cName)
	local id, obj
	local oDep := codb_dep_reference("GBL0201")
	if empty(oDep)
		return
	endif
	id := oDep:id4primaryKey("acc_constant","name",cName)
	if empty(id)
		return
	endif
	obj := oDep:getValue(id)
	if empty(obj)
		return
	endif
return obj:value

/************************************************/
function cgi_putArefs2Rdf(aRefs,oDep,level,urn,columns,sTree,ext_urn,atom)
	local s:=replicate("",level),sOut,col
	local obj,obj2,i,j,k,tmp,sTmp,sTmp2,sTmp3,stmp4
	local sid,dName := urn , refs, refr, essenc
	local ret := .f., ltree:= .f., alen
	local sdata,rerr,errblock:=errorBlock({|err|cgi_error2xml(err)})

	if empty(ext_urn)
		ext_urn := ""
	endif
	if empty(sTree)
		sTree := "level0"
	endif
?? '<items id="'+sTree+'">['
	alen := len(Arefs)
	for i=1 to alen
		tmp:=aRefs[i][4]
		sid := ""
		if "ID" $ tmp .and. !empty(tmp:id)
			sid := tmp:id
		else
			sid := "XXXXXXXXXXXX"
		endif
		sid+=ext_urn

		refs:= ""


		essenc:=cgi_essence(tmp:id)
		essenc := strtran(essenc,'&',"&amp;")
		essenc := strtran(essenc,'"','\"')
		essenc := strtran(essenc,"'","\'")
		essenc := strtran(essenc,'<',"&lt;")
		essenc := strtran(essenc,'>',"&gt;")
		refr:= "id:'"+essenc+"' "

		?? s+" {id:'" +sid+ "' , essence:'" +essenc+ "', "
		?? s+" a: {"
		?? s+" level:"+alltrim(str(level,3,0))+", "
		?? s+" isContainer:"+iif(empty(aRefs[i][5]),'false','true')
		?? s+" },"

		begin sequence
			sdata := ""
			for j=1 to len(columns)
				col := columns[j]
				sTmp := mapEval(tmp,col:block)
				sTmp3 := ""
				if "DATATYPE" $ col .and. col:datatype == "R"

					if "OBJ_ID" $ col
						sTmp2 := mapEval(tmp,col:obj_id)
					elseif upper(col:name) $ tmp
						sTmp2 := tmp[upper(col:name)]
					else
						sTmp2 := sTmp
					endif

					if empty(sTmp2)
						sTmp3 := cgi_getValue(stmp)
						    if !empty(stmp3)
							sTmp2 := sTmp3:id
						    endif
						sTmp3 := ""
					endif

					if !empty(stmp2)
						refr  := refr+iif(refr=="","",",")+" "+col:name+":'"+ sTmp2 + "'"
						sTmp3 := cgi_essence(sTmp)
						sTmp3 := strtran(sTmp3,'&',"&amp;")
						sTmp3 := strtran(sTmp3,'"','\"')
						sTmp3 := strtran(sTmp3,"'","\'")
						sTmp3 := strtran(sTmp3,'<',"&lt;")
						sTmp3 := strtran(sTmp3,'>',"&gt;")
						sTmp3  := "'"+sTmp3+"'"
					endif
				elseif "DATATYPE" $ col .and. col:datatype=="L" .and. len(stmp) > 0
					refr  := refr+iif(refr=="","",",")+" "+col:name+":"+iif(tmp[upper(col:name)],'true','false') + ""
					sTmp3 := "'"+sTmp+"'"
				elseif "DATATYPE" $ col .and. col:datatype=="S" .and. len(stmp) > 0

					obj2:=cgi_getValue(sTmp)
					if !empty(obj2)
						k:= codb_tColumnBody(obj2:id)
						if !empty(k)
							sTmp3 := "'"+k:header+"'" //+':'+obj2:name
						else
							sTmp3 := "'"+obj2:name+"'" //+":"+obj2:id
						endif
					endif
					refr:=refr+iif(refr=="","",",")+" "+col:name+":'"+ stmp + "'"
				elseif valtype(sTmp) == "C"
					if "DATATYPE" $ col .and. col:datatype == "M"
						if !empty(sTmp)
							sTmp3 := "true"
						endif
					else
						sTmp := strtran(sTmp,'&',"&amp;")
						sTmp := strtran(sTmp,'"','\"')
						sTmp := strtran(sTmp,"'","\'")
						sTmp := strtran(sTmp,'<',"&lt;")
						sTmp := strtran(sTmp,'>',"&gt;")
						sTmp3 := "'"+sTmp+"'"
					endif
				elseif valtype(sTmp) == "L"
					sTmp3:= iif(sTmp,"'true'","'false'")
					refr  := refr+iif(refr=="","",",")+" "+col:name+":"+ iif(sTmp,"true","false")  + ""

				elseif valtype(sTmp) == "N"
					stmp4 := alltrim(str(stmp))
					if col:datadec > 0
					    sTmp3 := "'"+bal_summa(stmp)+"'"
					else
					    sTmp3 := "'"+alltrim(str(stmp))+"'"
					    if "*" $ sTmp3
						sTmp3 := "'"+alltrim(str(stmp),20,0)+"'"
						stmp4 := "'"+stmp4+"'"
					    endif
					endif
					refr  := refr+iif(refr=="","",",")+" "+col:name+":"+ stmp4  + ""
				elseif valtype(sTmp) == "D"
					refr  := refr+iif(refr=="","",",")+" "+col:name+":"+ iif(empty(sTmp),"'00000000'","'"+dtos(sTmp)+"'") + ""
					sTmp3 := iif(empty(sTmp),'',"'"+dtoc(sTmp)+"'")
				endif

				if !empty(stmp3) .and. len(stmp3) > 2
				    ?? s+" "+col:name+":"+sTmp3+iif( j==len(columns), "",",")
				else
				    ?? s+" "+col:name+":'"+iif(col:name=='essence',essenc,'')+" '"+iif( j==len(columns), "",",")
				endif
			next
		recover using rerr
			cgi_error2xml(rerr)
		end sequence
			if len(refr) >0
				?? s+", r:{"+refr+"}"
			endif
		?? s+'}'+iif( i==aLen, '',',')
	next
	?? ']</items>'
	for i=1 to len(Arefs)
		tmp:=aRefs[i][4]
		if !empty(aRefs[i][5])
			cgi_putArefs2Rdf(aRefs[i][5],oDep,level+1,urn,columns,tmp:id,ext_urn)
		endif
	next
	errorBlock(errBlock)
return ret
/************************************************/
function cgi_putArefs2RdfLevels(aRefs,oDep,level,urn,columns,sTree,ext_urn)
	local sOut:="", i,tmp,sid
	if empty(ext_urn)
		ext_urn := ""
	endif
	if empty(sTree)
		sTree := "0"
	endif
	if level==0
		? '<levels>'
	endif
	for i=1 to len(aRefs)
		tmp:=aRefs[i][4]
		if !empty(aRefs[i][5])
			cgi_putArefs2RdfLevels(aRefs[i][5],oDep,level+1,urn,columns,tmp:id)
		endif
		if "ID" $ tmp .and. !empty(tmp:id)
			sid := tmp:id
		else
			sid := "XXXXXXXXXXXX"
		endif
		sOut+=sid+","
	next
	? '	<level name="'+sTree+'" idrefs="'+sOut+'" />'
	if level==0
		? '</levels>'
	endif
return
/************************************************/
function cgi_putArefs2Rdf1(aRefs,oDep,level,urn,columns,sTree,ext_urn,atom)
	local s:=replicate("   ",level),sOut,col
	local obj,obj2,i,j,k,tmp,sTmp,sTmp2,sTmp3,stmp4,essenc:=""
	local sid,dName := urn // "docum"
	local ret := .f., ltree:= .f.
	local sdata,rerr,errBlock

	if level==0
		errblock:=errorBlock({|err|cgi_error2xml(err)})
	endif

	if empty(ext_urn)
		ext_urn := ""
	endif
	atom := iif(valType(atom)!="L",.f.,atom)

#ifdef PUT_RDF_TREE
	for i=1 to len(aRefs)
		if empty(aRefs[i][5])
			loop
		endif
		lTree := .t.
		exit
	next
	if level==0
		? s+"<RDF:Seq about='"+dname+"'>"
		if lTree
			? s+"<RDF:li>"
		endif
	endif
#endif

	for i=1 to len(Arefs)
		tmp:=aRefs[i][4]
		sid := ""
		if "ID" $ tmp .and. !empty(tmp:id)
			sid := tmp:id

			essenc:=cgi_essence(tmp:id)
			essenc := strtran(essenc,'&',"&amp;")
			essenc := strtran(essenc,'"','&quot;')
			essenc := strtran(essenc,"'","&apos;")
			essenc := strtran(essenc,'<',"&lt;")
			essenc := strtran(essenc,'>',"&gt;")
		else
			sid := "XXXXXXXXXXXX"
		endif
		//outlog(__FILE__,__LINE__,i,tmp:id)
		sid+=ext_urn
#ifdef PUT_RDF_TREE
		if lTree
			? s+'<RDF:Seq about='"+dname+sTree+":"+sid+"'>"
		else
			? s+"<RDF:li resource='"+dname+sTree+":"+sid+"'>"
		endif
#endif
		? s+"	<RDF:Description about='"+dname+sTree+":"+sid+"' id='"+sid+"' DOCUM:about='"+dname+sTree+":"+sid+"' DOCUM:essences='"+essenc+"'"
		begin sequence
			sdata := ""
			for j=1 to len(columns)
				col := columns[j]
				sTmp := mapEval(tmp,col:block)
				sTmp3 := "я"
				if "DATATYPE" $ col .and.  col:datatype == "S"
					//sData += s+ ' <DOCUM:ref_'+col:name+'>'+ stmp + '</DOCUM:ref_'+col:name+'>'
					? s+"    DOCUM:ref_"+col:name+"='"+ stmp + "' "
				endif
				//sData+=s+' <DOCUM:'+col:name+'>'
				if "DATATYPE" $ col .and. col:datatype == "R"
					if "OBJ_ID" $ col
						sTmp2 := mapEval(tmp,col:obj_id)
					elseif upper(col:name) $ tmp
						sTmp2 := tmp[upper(col:name)]
					else
						sTmp2 := sTmp
					endif
					if empty(sTmp2)
						sTmp3 := cgi_getValue(stmp)
						if !empty(stmp3)
							sTmp2 := sTmp3:id
						endif
						sTmp3 := ""
					endif
					sTmp  := cgi_essence(sTmp)

					sTmp := strtran(sTmp,'&','&amp;')
					sTmp := strtran(sTmp,'"','&quot;')
					sTmp := strtran(sTmp,"'","&apos;")
					sTmp := strtran(sTmp,'<',"&lt;")
					sTmp := strtran(sTmp,'>',"&gt;")


				elseif "DATATYPE" $ col .and. col:datatype=="S"
					obj2:=cgi_getValue(sTmp)
					if !empty(obj2)
						k:= codb_tColumnBody(obj2:id)
						if !empty(k)
							sTmp := k:header //+':'+obj2:name
						else
							sTmp := obj2:name+":"+obj2:id
						endif
					endif
				elseif valtype(sTmp) == "C"
					if "DATATYPE" $ col .and. col:datatype == "M"
						if !empty(sTmp)
							sTmp3 := "true"
						endif
					else
						sTmp := strtran(sTmp,'&',"&amp;")
						sTmp := strtran(sTmp,'"',"&quot;")
						sTmp := strtran(sTmp,"'","&apos;")
						sTmp := strtran(sTmp,'<',"&lt;")
						sTmp := strtran(sTmp,'>',"&gt;")
						sTmp3 := sTmp
					endif
				elseif valtype(sTmp) == "L"
					sTmp:= iif(sTmp,"true","false")
					sTmp3 := sTmp
				elseif valtype(sTmp) == "A"
					if len(sTmp)>0
						sTmp := alltrim(varToString( stmp[1],,, .f.))
						if valtype(sTmp[1]) == "A"
							sTmp := substr(stmp,2,len(sTmp)-2)
						endif
						sTmp:=strtran(sTmp,'"',"")
						//outlog(__FILE__,__LINE__,col:name,tmp:id,stmp)
					else
						sTmp := ""
					endif
					sTmp := ""

				elseif valtype(sTmp) == "N"
					sTmp3 := sort_summa(stmp,col:datalen,col:datadec) //padl(alltrim(str(sTmp,col:datalen,col:datadec)),10,"0")
					sTmp := alltrim(Str(sTmp,col:datalen,col:datadec))
				elseif valtype(sTmp) == "D"
					sTmp3 := dtos(sTmp)
					sTmp := dToc(sTmp)
				else
					sTmp := toString(sTmp)
				endif
				? s+'	 DOCUM:'+col:name+'="'+sTmp+'"'
				if "DATATYPE" $ col .and.  col:datatype == "R"
			   //		sData+= s+' <DOCUM:ref_'+col:name+'>'+ sTmp2 + '</DOCUM:ref_'+col:name+'>'
					? s+"	 DOCUM:ref_"+col:name+"='"+ sTmp2 + "'"
					sTmp4 := cgi_getValue(sTmp2)
					if !empty(stmp4)
					? s+"	 DOCUM:class_"+col:name+"='"+ stmp4:class_id + "'"
					endif
				endif
				if "DATATYPE" $ col .and.  col:datatype == "A"
					sTmp2 := tmp[upper(col:name)]
					sTmp2 := alltrim(varToString( stmp2,,, .f.))
					sTmp2 := substr(stmp2,2,len(sTmp2)-2)
					sTmp2:=strtran(sTmp2,'"',"")
			   //		sData+= s+' <DOCUM:ref_'+col:name+'>'+ sTmp2 + '</DOCUM:ref_'+col:name+'>'
					//sData+= s+' DOCUM:ref_'+col:name+'="'+ sTmp2 + '"'
				endif
				if !empty(sTmp3)
				    if col:name!="paydate"
				    ? s+'	 DOCUM:sort_'+col:name+'="'+ sTmp3 + '"'
				    endif
				endif

			next
		recover using rerr
			cgi_error2xml(rerr)
			//quit
		end sequence
		//? s+'</RDF:Description>'
		? s+'	/>'

		if !empty(aRefs[i][5])
			ret := .t.
			aRefs[i][3] := cgi_putArefs2Rdf1(aRefs[i][5],oDep,level+1,urn,columns,sTree+":"+tmp:id,ext_urn)
		endif
#ifdef PUT_RDF_TREE
		if lTree
			? s+"</RDF:Seq>"
		else
			? s+"</RDF:li >"
		endif
#endif
	next
#ifdef PUT_RDF_TREE
	if level==0
		errorBlock(errBlock)
		? s+'</RDF:Seq>'
		if lTree
			? s+'</RDF:li>'
		endif
	endif
#endif
	?
return ret
/************************************************/
function cgi_putArefs2Rdf2(aRefs,oDep,level,urn,columns,sTree,ext_urn)
	local s:=replicate("   ",level),sOut,col
	local obj,obj2,i,j,tmp,sTmp,tmp2,sid
	local dName := urn //"docum"
	local llTree := .f.

#ifdef PUT_RDF_TREE
	return
#endif

	if empty(ext_urn)
		ext_urn := ""
	endif
	*****
	llTree := .f.
	for j=1 to len(aRefs)
		tmp2 := aRefs[j]
		if !empty(tmp2[5])
			llTree := .t.
			exit
		endif
	next
	****
	if level==0
		? s+'<RDF:Seq about="'+dname+'">'
	endif
	if llTree
		? s+'<RDF:li>'
	endif
	for i=1 to len(aRefs)
		tmp:=aRefs[i][4]

		if "ID" $ tmp .and. !empty(tmp:id)
			sid := tmp:id
		else
			sid := "XXXXXXXXXXXX"
		endif
		sid += ext_urn
		if empty(aRefs[i][5])

			if llTree
				? s+'   <RDF:seq about="'+dname+sTree+':'+sid+'"/>'
			else
				? s+'   <RDF:li resource="'+dname+sTree+':'+sid+'"/>'
			endif
			loop
		endif
		? s+'   <RDF:Seq about="'+dname+sTree+':'+sid+'">'
		cgi_putArefs2Rdf2(aRefs[i][5],oDep,level+1,urn,columns,sTree+":"+sid)
		? s+'   </RDF:Seq>'
	next
	if llTree
		? s+'</RDF:li>'
	endif
	if level==0
		? s+'</RDF:Seq>'
	endif
	?

return

/************************************************/
function cgi_putTreeHeader(columns)
	local i,j,col,k
	/* put xml-header */
	?
	? '<overlay '
	? ' title=" " onload="oppa()"'
	? 'xmlns:html="http://www.w3.org/1999/xhtml"'
	? 'xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul">'

	? '<tree id="info" onselect="prosm(currentIndex)" height="350">'
	? '  <treecols id="trc">'

	for i=1 to len(columns)
		col:=columns[i]
		? '    <treecol id="'+col:name+'"'
		?? ' primary="false"'
		?? ' label="'+col:header+'"'
		?? ' hidden="'+iif(empty(col:header),"true","false")+'"'
		if "DATALEN" $ col
			?? ' datalen="'+alltrim(toString(col:datalen))+'" '
			?? ' datatype="'+col:datatype+'"'
			?? ' datamask="'+col:datamask+'"'
			?? ' dataisindex="'+iif(col:isindex,"true","false")+'"'
		endif
		if "DEFVALUE" $ col
			?? ' defvalue="'+toString(col:defvalue)+'"'
		endif
		if "REFS" $ col .and. !empty(col:refs)
			k:=""
			for j=1 to len(col:refs)
			    k+=col:refs[j]+","
			next
			k := left(k,len(k)-1)
			?? ' dataRefTo="'+k+'"'
		else
			if "DATAREFTO" $ col
				?? ' dataRefTo="'+col:dataRefTo+'"'
			endif
		endif
		?? '/>'
		? '    <splitter class="tree-splitter"/>'
	next

	? ' </treecols>'

return

/************************************************/
function cgi_putTreeFooter()
	? '</tree>'
//	? '</box>'
	? '</overlay>'
?
return

/************************************************/
function cgi_putTreeArefs(atree,oDep,level,_queryArr,columns)
	local s:=replicate("   ",level),sOut,col
	local obj,obj2,i,j,sTmp,obj_id
	local sdata,rerr,errblock:=errorBlock({|err|cgi_error2xml(err)})
	for i=1 to len(atree)
		//obj:=oDep:getValue(aTree[i][1])
		obj:=aTree[i][3]
		if !empty(atree[i][2])
			sOut:=s+' <treeitem container="true" id="'+obj:id+'" open="false" >'
		else
			sOut:=s+' <treeitem id="'+obj:id+'" >'
		endif
		? cgi_dataTran(sOut,_queryArr)
		sOut := s+"   <treerow>"
		? cgi_dataTran(sOut,_queryArr)

		begin sequence
			for j=1 to len(columns)
				col := columns[j]
				sTmp := mapEval(obj,col:block)
				obj_id := ""
				if "DATATYPE" $ col .and. col:datatype == "R"
					if "OBJ_ID" $ col
						obj_id := mapEval(obj,col:obj_id)
					elseif upper(col:name) $ obj
						obj_id := obj[upper(col:name)]
					endif
					stmp := cgi_essence(sTmp)
				elseif valtype(sTmp) == "C"
					sTmp := strtran(sTmp,'"',"'")
					sTmp := strtran(sTmp,'&',"'")
					sTmp := strtran(sTmp,'<',"")
					sTmp := strtran(sTmp,'>',"")
				elseif valtype(sTmp) == "L"
					sTmp:= iif(sTmp,"true","false")
				else
					sTmp := toString(sTmp)
				endif
				sOut := s+"      "+'<treecell label="'+sTmp+'" obj_id="'+obj_id+'"/>'
				? cgi_dataTran(sOut,_queryArr)
			next
		recover using rerr
			cgi_error2xml(rerr)
		end sequence

		? s,"  </treerow>"

		if !empty(atree[i][2])
			sOut := s+'<treechildren>'
			? cgi_dataTran(sOut,_queryArr)
			cgi_putTreeArefs(atree[i][2],oDep,level+1,_queryArr,columns)
			? s,'</treechildren>'
		endif
		? s,' </treeitem>'
	next
return


/************************************************/
function cgi_fillTreeArefs(aRefs,atree,owner_id,level)
	local i, mdel:={}
	for i=1 to len(aRefs)
		if alltrim(aRefs[i][2])==owner_id
			aadd(aTree,{aRefs[i][1],{},aRefs[i][4]})
			aadd(mdel,i)
		endif
	next
	for i=len(mdel) to 1 step -1
		adel(aRefs,mdel[i])
	next
	asize(aRefs,len(aRefs)-len(mdel))
	for i=1 to len(aTree)
		cgi_fillTreeArefs(aRefs,atree[i][2],aTree[i][1],level+1)
	next
return
/************************************************/
function cgi_fillTreeRdf(aRefs,atree,owner_id,level)
	local i,mdel:={}
	if level > 2
		m->lTree := .t.
	endif
	for i=1 to len(aRefs)
		if alltrim(aRefs[i][2])==owner_id
			aadd(aTree,{aRefs[i][1],aRefs[i][2],aRefs[i][3],aRefs[i][4],{}})
			aadd(mdel,i)
		endif
	next

	for i=len(mdel) to 1 step -1
		adel(aRefs,mdel[i])
	next
	asize(aRefs,len(aRefs)-len(mdel))

	for i=1 to len(aTree)
		cgi_fillTreeRdf(aRefs,atree[i][5],atree[i][1],level+1)
	next
return

/************************************************/
function cgi_accpost_columns(oDict,sprname)
	local columns,x,i,j,col,tmp
	if empty(sprname)
		sprname = "accpost"
	endif
	columns := cgi_make_columns(oDict,sprname)
	//? "columns=", columns
    // add reference to acc_char_type
	i := ascan(columns,{|x|x:name == "daccount"})
	if i>0
		col := oclone(columns[i])
		col:datatype := "R"
		col:dataref_to := ""
		col:name := "acc_chart_type"
		col:header := "Тип баланса"
		col:expr := "__obj:=cgi_getValue(daccount),iif(empty(__obj),'',cgi_essence(__obj:acc_chart_type))"
		col:block := &("{|p1,p2,p3,p4|"+col:expr+"}")
		col:obj_id :={|| "" }
		aadd(columns,col)
	endif
	i := ascan(columns,{|x|x:name == "an_debet"})
	if i>0
		col := oclone(columns[i])
		col:datatype := "R"
		col:dataref_to := ""
		adel(columns,i)
		asize(columns,len(columns)-1)
		*
		for j=6 to 1 step -1
			tmp:=NIL; tmp := oclone(col)
			tmp:name := "an_debet"+alltrim(str(j,2,0))
			tmp:header := "АнДебет"+alltrim(str(j,2,0))
			tmp:expr := "iif(len(an_debet)>="+alltrim(str(j,2,0))+",cgi_essence(an_debet["+alltrim(str(j,2,0))+"][2]),'')"
			tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")

			tmp:obj_id := "iif(len(an_debet)>="+alltrim(str(j,2,0))+",an_debet["+alltrim(str(j,2,0))+"][2],'')"
			tmp:obj_id := &("{|p1,p2,p3,p4|"+tmp:obj_id+"}")

			aadd(columns,"")
			ains(columns,i)
			columns[i] := tmp
		next

	endif
	i := ascan(columns,{|x|x:name == "an_kredit"})
	if i>0
		col := oclone(columns[i])
		col:datatype :="R"
		col:dataref_to := ""
		adel(columns,i)
		asize(columns,len(columns)-1)
		*
		for j=6 to 1 step -1
			tmp:=NIL; tmp := oclone(col)
			tmp:name := "an_kredit"+alltrim(str(j,2,0))
			tmp:header := "АнКредит"+alltrim(str(j,2,0))
			tmp:expr := "iif(len(an_kredit)>="+alltrim(str(j,2,0))+",cgi_essence(an_kredit["+alltrim(str(j,2,0))+"][2]),'')"
			tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")

			tmp:obj_id := "iif(len(an_kredit)>="+alltrim(str(j,2,0))+",an_kredit["+alltrim(str(j,2,0))+"][2],'')"
			tmp:obj_id := &("{|p1,p2,p3,p4|"+tmp:obj_id+"}")

			aadd(columns,"")
			ains(columns,i)
			columns[i] := tmp
		next

	endif
return columns
/************************************************/
/*
  ptype - type of periodic:
  NIL - none
  1.....n - n days
  w - week
  d - decade
  m - month
  k - kvartel
*/
function periodic2date(bdate,edate,pType)
	local ret := {},i,j,n
	if pType == NIL
		aadd(ret,{bdate,edate})
		return ret
	endif
	if valtype(pType) == "N"
		n := pType
	else
		n := val(pType)
	endif
	if n > 0
		for i=bdate to edate step n
			aadd(ret,{i,min(i+n-1,edate)})
		next
		return ret
	endif
	if valType(pType) != "C"
		aadd(ret,{bdate,edate})
		return ret
	endif
	pType := upper(pType)
	/*
	if pType == "D"
		for i=bdate to edate
			aadd(ret,{i,min(i,edate)})
		next
		return ret
	endif
	*/
	if pType == "W"
		j := bdate
		for i=bdate to edate
			if dow(i) == 1
				aadd(ret,{j,min(i,edate)})
				j := i+1
			endif
		next
		if j<edate
			aadd(ret,{j,edate})
		endif
		return ret
	endif
	if pType == "D"
		j := bdate
		for i=bdate+1 to edate
			n := day(i)
			if n==11 .or. n==21 .or. n==1
				aadd(ret,{j,min(i-1,edate)})
				j := i
			endif
		next
		if j<edate
			aadd(ret,{j,edate})
		endif
		return ret
	endif
	if pType == "M"
		j := bdate
		for i=bdate+1 to edate
			if day(i) == 1
				aadd(ret,{j,min(i-1,edate)})
				j := i
			endif
		next
		if j<edate
			aadd(ret,{j,edate})
		endif
		return ret
	endif

	aadd(ret,{bdate,edate})
return ret
