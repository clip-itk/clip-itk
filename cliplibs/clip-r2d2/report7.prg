#include "r2d2lib.ch"

function r2d2_report7_xml(_queryArr)

local err, _query
local oDict,oDep, oDep02,oDict02
local beg_date:=date(),end_date:=date(), account:="", an_value:=""
local an_info, acc_chart, columns
local urn,connect_id:="", connect_data, sprname:="accpost"
local i,j,k,s,s1,s2,tmp,obj,col
local acc_list, acc_objs
local k_list, d_list, arefs:={}, atree:={}
local post_list:={},post_objs:={}

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

	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	//? 'xmlns:docum="http://last/cbt_new/rdf#">'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	?

	oDep := codb_needDepository("ACC0101")
	if empty(oDep)
		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()

	an_info:= oDict:classBodyByName("an_info")
	if empty(an_info)
		cgi_xml_error( "Class description not found: an_info" )
		return
	endif

	//s2:= '.and. beg_date>=stod("'+dtos(end_date)+'") .and. end_date>=stod("'+dtos(beg_date)+'") '
	s:= 'end_date>=stod("'+dtos(beg_date)+'") '
	if !empty(account)
		s+= '.and. account=="'+account+'" '
	endif
	s+= '.and. an_value=="'+an_value+'" '
	tmp:=oDep:select(an_info:id,,,s)
	//? tmp
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
	cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns,"")
	?
	cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns,"")
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
