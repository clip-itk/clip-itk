#include "r2d2lib.ch"

function r2d2_report7_xml(_queryArr)

local err, _query, huddle := .f.
local oDict,oDep, oDep02,oDict02
local beg_date:=date(),end_date:=date(), account:=""
local an_value:="", an_obj, an_class:="XXXXXXXXXXXX"
local an_info, columns,acc_chart, accounts:={}
local an_valuess:={},an_values:={},an_levels:={},an_level,an_data
local acc_obj,acc_list:={}, acc_objs:={}
local urn:="",connect_id:="", connect_data, sprname:="accpost"
local k_list, d_list, arefs:={}, atree:={}
local post_list:={},post_objs:={}
local paraSumm:={}
local i,j,k,s,s1,s2,tmp,obj,col,type

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif
	if "URN" $ _query
		URN := _query:URN
	endif
	if "TYPE" $ _query
		type := _query:type
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
	if "HUDDLE" $ _query
		huddle := upper(_query:huddle)
		if upper(left(huddle,1)) $ "TYä"
			huddle := .t.
		endif
	endif


	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif
	/*
	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
	endif
	*/


	if "ACC01" $ _query .and. !empty(_query:acc01)
	    set("ACC01",_query:acc01)
	endif
	if "ACC00" $ _query .and. !empty(_query:acc00)
	    set("ACC00",_query:acc00)
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

	oDep := cgi_needDepository("ACC01","01")
	if empty(oDep)
//		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()

	oDep02 := cgi_needDepository("GBL02","01")
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

	an_obj := cgi_getValue(an_value)
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
			if ascan(post_list,obj:accpost_list[j])<=0
				aadd(post_list,obj:accpost_list[j])
			endif
		next
		if ascan(accounts,obj:account)<=0
			aadd(accounts,obj:account)
			aadd(an_levels,obj:an_level)
		endif
		//? tmp[i], obj:account, obj:an_value,obj:an_level
	next
	//? post_list
	for i=1 to len(post_list)
		obj := oDep:getValue(post_list[i])
		if empty(obj)
			loop
		endif
		if obj:odate>end_date .or. obj:odate<beg_date
			loop
		endif
		if "__VERSION" $ obj .and. obj:__version < 0
			loop
		endif
		aadd(post_objs,obj)
	next

	if !huddle
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
			post_objs[tmp]:dquantity += post_objs[i]:dquantity
			post_objs[tmp]:kquantity += post_objs[i]:kquantity
			adel(post_objs,i)
			asize(post_objs,len(post_objs)-1)
		next
	endif

	asize(paraSumm,len(accounts))
	afill(paraSumm,0.00)

	for i=1 to len(post_objs)
		obj:=post_objs[i]
		aadd(aRefs,{obj:id,"",dtos(obj:odate)+":"+obj:primary_document,obj})
		if !(obj:daccount == obj:kaccount)
			loop
		endif
		j := ascan(accounts,obj:daccount)
		if j<=0
			loop
		endif
		paraSumm[j] += obj:summa
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
	? '<RDF:account>'+cgi_essence(account)+'</RDF:account>'
	? '<RDF:an_value>'+cgi_essence(an_value)+'</RDF:an_value>'
	if empty(type)
	    cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns,"")
		?
	    cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns,"")
		?
		
	else
	    cgi_putArefs2Rdf(aTree,oDep,0,urn,columns,"")

	endif

	for i=1 to len(accounts)
		//? "acc=",accounts[i],an_levels[i]
		an_values:={" "," "," "," "," "," "}
		an_values[ an_levels[i] ] := an_value
		an_data := cgi_an_make_data(beg_date,end_date,oDep,accounts[i],an_values,an_levels[i])
		for j=1 to len(an_data)
			an_data[j]:od_summa -= paraSumm[i]
			an_data[j]:ok_summa -= paraSumm[i]
		next
		if empty(type)
		    cgi_an_putRdf1(an_data,accounts[i],an_levels[i],urn,'no',beg_date,end_date,"",":"+accounts[i])
		else
		?' <items id="level'+alltrim(str(i,2,0))+'">['
		    cgi_an_putRdf2(an_data,accounts[i],an_levels[i],urn,'no',beg_date,end_date,"",accounts[i],'0')
		?' ]</items>'
		endif

		     //cgi_an_putRdf1(bal_data,account,an_level,urn,total,beg_date,end_date,sTree,ext_urn)

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
