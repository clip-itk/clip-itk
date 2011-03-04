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
local k_list, d_list, arefs:={}, aTree:=map()
local post_list:={},post_objs:={}
local paraSumm:={}
local i,j,k,s,s1,s2,tmp,obj,col,typenode

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif
	if "URN" $ _query
		URN := _query:URN
	endif
	if "TYPENODE" $ _query
		typenode := _query:typenode
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
		if upper(left(huddle,1)) $ "TYD"
		    huddle := .t.
		else 	
		    huddle := .f.
		endif
	endif


	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif


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
*********************************************************
	? '<root>'
	for i=1 to len(tmp)
		obj := oDep:getValue(tmp[i])
		if empty(obj)
			loop
		endif
		if ascan(accounts,obj:account)<=0
			aadd(accounts,obj:account)
			aadd(an_levels,obj:an_level)
		endif
	next
	k:=0
  ?' <items id="level0">['
	for i=1 to len(accounts)
		an_values:={" "," "," "," "," "," "}
		an_values[ an_levels[i] ] := an_value
		an_data := cgi_an_make_data(beg_date,end_date,oDep,accounts[i],an_values,an_levels[i],,'no')
		if !empty(an_data)
		? iif(k==0,'',',')
		k++
	    	cgi_an_putJson(an_data,accounts[i],an_levels[i],urn,'no',beg_date,end_date,"",accounts[i],'0', 'rep7')
	    endif
	next

	?' ]</items>'
	? '</root>'

return 
