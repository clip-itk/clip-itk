#include "r2d2lib.ch"

function r2d2_report7_xml(_queryArr)

local err, _query
local oDict,oDep, oDep02,oDict02
local beg_date:=date(),end_date:=date(), account:=""
local an_value:="", an_obj, an_class:="XXXXXXXXXXXX"
local an_info, columns,acc_chart, accounts:={}
local an_valuess:={},an_values:={},an_levels:={},an_level,an_data
local acc_obj,acc_list:={}, acc_objs:={}
local urn:="",connect_id:="", connect_data, sprname:="accpost"
local k_list, d_list, arefs:={}, atree:={}
local post_list:={},post_objs:={}
local i,j,k,s,s1,s2,tmp,obj,col

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif
	if "URN" $ _query
		URN := _query:URN
	endif

	if "BEG_DATE" $ _query
		beg_date := ctod(_query:beg_date,"dd.mm.yyyy")
	endif
	if "END_DATE" $ _query
		end_date := ctod(_query:end_date,"dd.mm.yyyy")
	endif
	if "ACCOUNT" $ _query
		account := upper(_query:account)
	endif
	if "AN_VALUE" $ _query
		an_value := upper(_query:an_value)
	endif

	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif
	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
	endif

	if empty(an_value) .or. empty(beg_date) .or. empty(end_date)
		cgi_xml_header()

		? '<body>'
		? "Error: bad parameters ! "
		if empty(beg_date) .or. empty(end_date)
			?? "PERIOD not defined "
		endif
		if empty(an_value)
			?? "AN_VALUE not defined "
		endif
		? "Usage:"
		? "    report7?beg_date=<date>& end_date=<date>& an_value=<an_value_id>"
		?
		return
	endif

	cgi_xml_header()

	?

	oDep := codb_needDepository("ACC0101")
	if empty(oDep)
		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()

	oDep02 := codb_needDepository("GBL0201")
	if empty(oDep02)
		cgi_xml_error( "Depository not found: GBL0201" )
		return
	endif
	oDict02 := oDep02:dictionary()

	an_info:= oDict:classBodyByName("an_info")
	if empty(an_info)
		cgi_xml_error( "Class description not found: an_info" )
		return
	endif
	acc_chart:= oDict02:classBodyByName("acc_chart")
	if empty(acc_chart)
		cgi_xml_error( "Class description not found: acc_chart" )
		return
	endif

	an_obj := codb_getValue(an_value)
	if empty(an_obj)
		cgi_xml_error( "Object not readable: "+an_value )
	else
		an_class := an_obj:class_id
	endif

	//s2:= '.and. beg_date>=stod("'+dtos(end_date)+'") .and. end_date>=stod("'+dtos(beg_date)+'") '
	s:= 'end_date>=stod("'+dtos(beg_date)+'") '
	if !empty(account)
		s+= '.and. account=="'+account+'" '
	endif
	s+= '.and. an_value=="'+an_value+'" '
	tmp:=oDep:select(an_info:id,,,s)
//	? s,tmp
	for i=1 to len(tmp)
		obj := oDep:getValue(tmp[i])
		//? i, tmp[i], obj
		if empty(obj)
			loop
		endif
		//? i, obj:accpost_list
		for j=1 to len(obj:accpost_list)
			aadd(post_list,obj:accpost_list[j])
		next
		aadd(accounts,obj:account)
		aadd(an_levels,obj:an_level)
		//? tmp[i], obj:account, obj:an_value,obj:an_level
	next
	for i=1 to len(post_list)
		obj := oDep:getValue(post_list[i])
		if empty(obj)
			loop
		endif
		if obj:odate>end_date .or. obj:odate<beg_date
			loop
		endif
		aadd(post_objs,obj)
		/*
		acc_obj:=oDep02:getValue(obj:daccount)
		//? i, obj:daccount,an_class,acc_obj
		if empty(acc_obj)
			cgi_xml_error( "Object not readable: "+obj:daccount )
		else
			for j=1 to 99
				s := "AN_VALUE"+alltrim(str(j,2,0))
				if ! ( S $ acc_obj )
					exit
				endif
				if ! (acc_obj[s] == an_class)
					loop
				endif
				aadd(accounts,acc_obj)
				aadd(an_levels,j)
				exit
			next
		endif
		acc_obj:=oDep02:getValue(obj:kaccount)
		//? i, obj:kaccount,an_class,acc_obj
		if empty(acc_obj)
			cgi_xml_error( "Object not readable: "+obj:daccount )
		else
			for j=1 to 99
				s := "AN_VALUE"+alltrim(str(j,2,0))
				if ! ( S $ acc_obj )
					exit
				endif
				if ! (acc_obj[s] == an_class)
					loop
				endif
				aadd(accounts,acc_obj)
				aadd(an_levels,j)
				exit
			next
		endif
		*/
	next
	for i=len(post_objs) to 1 step -1
		tmp := ascan(post_objs,{|x|x:daccount==post_objs[i]:daccount ;
			.and. x:kaccount==post_objs[i]:kaccount;
			.and. x:odate==post_objs[i]:odate;
			.and. x:primary_document==post_objs[i]:primary_document;
			})
		if tmp < 0 .or. tmp == i
			loop
		endif
		//outlog(__FILE__,__LINE__,tmp,post_objs[i])
		post_objs[tmp]:summa += post_objs[i]:summa
		adel(post_objs,i)
		asize(post_objs,len(post_objs)-1)
	next

	for i=1 to len(post_objs)
		obj:=post_objs[i]
		aadd(aRefs,{obj:id,"",dtos(obj:odate)+":"+obj:primary_document,obj})
	next

	columns := cgi_accpost_columns(oDict)

	asort(aRefs,,,{|x,y| x[3] <= y[3] })
	cgi_fillTreeRdf(aRefs,aTree,"",1)

	if empty(urn)
		urn := sprname
	endif
	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	//? 'xmlns:docum="http://last/cbt_new/rdf#">'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	? '<RDF:beg_date>'+dtoc(beg_date)+'</RDF:beg_date>'
	? '<RDF:end_date>'+dtoc(end_date)+'</RDF:end_date>'

	cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns,"")
	?
	cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns,"")
	?
	?

	for i=1 to len(accounts)
		//? "acc=",accounts[i],an_levels[i]
		an_values:={" "," "," "," "," "," "}
		an_values[ an_levels[i] ] := an_value
		an_data := cgi_an_make_data(beg_date,end_date,oDep,accounts[i],an_values,an_levels[i]+1)
		cgi_an_putRdf1(an_data,accounts[i],an_levels[i]+1,urn)
	next
	? '</RDF:RDF>'

/******************************************/
static function empty_data(oDep02,account_id)
	static count:=1
	local tmp,ret := map()
	tmp := oDep02:getValue(account_id)
	ret:id := "REPORT4_"+ntoc(count,32,"0")
	count++
	if empty(tmp)
		ret:account := account_id
		ret:code := account_id
	else
		ret:account := tmp:code+":"+tmp:smallname
		ret:code := padr(tmp:code,10)
	endif
	ret:dsumma := 0.00
	ret:ksumma := 0.00
return ret
