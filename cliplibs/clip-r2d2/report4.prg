#include "r2d2lib.ch"

function r2d2_report4_xml(_queryArr)

local err, _query
local oDict,oDep, oDep02,oDict02
local beg_date:=date(),end_date:=date(), account:=""
local chess_bal, acc_chart, columns
local connect_id:="", connect_data
local i,j,k,s1,s2,tmp,obj,col
local acc_list, acc_objs
local k_list, d_list, arefs:={}, atree:={}

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
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

	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif
	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
	endif

	if empty(account) .or. empty(beg_date) .or. empty(end_date)
		cgi_xml_header()

		? '<body>'
		? "Error: bad parameters ! "
		if empty(beg_date) .or. empty(end_date)
			?? "PERIOD not defined "
		endif
		if empty(account)
			?? "ACCOUNT not defined "
		endif
		? "Usage:"
		? "    report4?beg_date=<date>& end_date=<date>& account=<account_code>"
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

	chess_bal:= oDict:classBodyByName("chess_balance")
	if empty(chess_bal)
		cgi_xml_error( "Class description not found: chess_balance" )
		return
	endif

	oDep02 := codb_needDepository("GBL0201")
	if empty(oDep)
		cgi_xml_error( "Depository not found: GBL0201" )
		return
	endif
	oDict02 := oDep02:dictionary()

	acc_chart:= oDict02:classBodyByName("acc_chart")
	if empty(acc_chart)
		cgi_xml_error( "Class description not found: acc_chart" )
		return
	endif

	/* search account in acc_chart*/
	acc_list:={}; acc_objs:={}; tmp:=""
	obj:= oDep02:getValue(account)
	if !empty(obj)
		aadd(acc_objs,obj)
		aadd(acc_list,account)
	else
		set exact off
		tmp := oDep02:select(acc_chart:id,,,'code="'+account+'"')
		set exact on
	endif
	if !empty(tmp)
		for i=1 to len(tmp)
			obj:=oDep02:getValue(tmp[i])
			if empty(obj)
				loop
			endif
			aadd(acc_objs,obj)
			aadd(acc_list,tmp[i])
		next
	endif

	if empty(acc_list)
		cgi_xml_error( "ACCOUNT not found: "+account )
		return
	endif

	s1:= 'odate>=stod("'+dtos(beg_date)+'") .and. odate<=stod("'+dtos(end_date)+'") .and. '

	d_list := {}
	for i=1 to len(acc_list)
		tmp := oDep:select(chess_bal:id,,,s1+'daccount=="'+acc_list[i]+'"')
		for j=1 to len(tmp)
			aadd(d_list,tmp[j])
		next
	next
	k_list := {}
	for i=1 to len(acc_list)
		tmp := oDep:select(chess_bal:id,,,s1+'kaccount=="'+acc_list[i]+'"')
		for j=1 to len(tmp)
			aadd(k_list,tmp[j])
		next
	next

	arefs:={}
	for i=1 to len(d_list)
		tmp := oDep:getValue(d_list[i])
		if empty(tmp)
			loop
		endif
		j := ascan(aRefs,{|x|x[1]==tmp:kaccount})
		if j<=0
			obj := empty_data(oDep02,tmp:kaccount)
			aadd(aRefs,{tmp:kaccount,"",obj:code,obj})
		else
			obj := aRefs[j][4]
		endif
		obj:dsumma += tmp:summa
	next
	for i=1 to len(k_list)
		tmp := oDep:getValue(k_list[i])
		if empty(tmp)
			loop
		endif
		j := ascan(aRefs,{|x|x[1]==tmp:daccount})
		if j<=0
			obj := empty_data(oDep02,tmp:daccount)
			aadd(aRefs,{tmp:daccount,"",obj:code,obj})
		else
			obj := aRefs[j][4]
		endif
		obj:ksumma += tmp:summa
	next
	asort(aRefs,,,{|x,y| x[3] <= y[3] })
	columns := cgi_make_columns(oDict,"chess_balance")
	tmp := oClone(columns[1])
	columns := {}
	col := oclone(tmp)
	col:datatype := "C"
	col:name := "account"
	col:header := "Счет"
	col:expr := "account"
	col:block := &("{|p1,p2,p3,p4|"+col:expr+"}")
	aadd(columns,col)
	col := oclone(tmp)
	col:datatype := "N"
	col:name := "dsumma"
	col:header := "Дебет"
	col:expr := "dsumma"
	col:block := &("{|p1,p2,p3,p4|"+col:expr+"}")
	aadd(columns,col)
	col := oclone(tmp)
	col:datatype := "N"
	col:name := "ksumma"
	col:header := "Кредит"
	col:expr := "ksumma"
	col:block := &("{|p1,p2,p3,p4|"+col:expr+"}")
	aadd(columns,col)
/*
	for i=1 to len(arefs)
		? arefs[i][3], arefs[i][4]:dSumma, arefs[i][4]:kSumma
	next
*/
	cgi_fillTreeRdf(aRefs,aTree,"",1)

	cgi_putArefs2Rdf1(aTree,oDep,0,"report4",columns,"")
	?
	cgi_putArefs2Rdf2(aTree,oDep,0,"report4",columns,"")
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
