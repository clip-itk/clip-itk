#include "r2d2lib.ch"

function r2d2_report6_xml(_queryArr)

local err, _query
local oDict,oDep, oDep02,oDict02
local accPost, acc_chart, osb_class
local beg_date:=date(),end_date:=date(), account:=""
local connect_id:="", connect_data
local i,j,k,s1,s2,tmp,tmp2,obj
local acc_list, acc_objs, acc_s
local post_list,post_list2,p_list,m_list:=map()
local d_data,k_data, d_list,k_list, d_res,k_res
local d_cache:=map(), k_cache:=map()
local an_data,an_datas,an_level:=1, an_values:={" "," "," "," "," "," "}
local c_data
local cache:=map()

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)

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
	if "AN1" $ _query
		an_values[1] := _query:an1
	endif
	if "AN2" $ _query
		an_values[2] := _query:an2
	endif
	if "AN3" $ _query
		an_values[3] := _query:an3
	endif
	if "AN4" $ _query
		an_values[4] := _query:an4
	endif
	if "AN5" $ _query
		an_values[5] := _query:an5
	endif
	if "AN6" $ _query
		an_values[6] := _query:an6
	endif
	if "AN_LEVEL" $ _query
		an_level := val(_query:an_level)
		if an_level <1
			an_level := 1
		endif
	endif

	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif
	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
	endif

	if empty(account) .or. empty(beg_date) .or. empty(end_date)
		//cgi_html_header()
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
		? "    report1?beg_date=<date>& end_date=<date>& account=<account_code>"
		?
		return
	endif

//	cgi_html_header("Справка по счету")
	cgi_xml_header()
	? '<body>'

	oDep := codb_needDepository("ACC0101")
	if empty(oDep)
		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()

	accPost:= oDict:classBodyByName("accpost")
	if empty(accPost)
		cgi_html_error( "Class description not found: accpost" )
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
		cgi_html_error( "Class description not found: acc_chart" )
		return
	endif

	/* search account in acc_chart*/
	acc_list:={}; acc_objs:={}; tmp:=""
	obj:= oDep02:getValue(account)
	if !empty(obj)
		aadd(acc_objs,obj)
		aadd(acc_list,account)
		cache[obj:id] := obj
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
			cache[obj:id] := obj
		next
	endif

	if empty(acc_list)
		cgi_html_error( "ACCOUNT not found: "+account )
		return
	endif

	post_list := {}; an_datas:={}
	for i=1 to len(acc_list)
		aadd(an_datas, cgi_an_make_data(beg_date,end_date,oDep,acc_list[i],an_values,an_level))
		an_data := an_datas[i]
		for j=1 to len(an_data)
			p_list := an_data[j]
			for k=1 to len(p_list:accpost_list)
				tmp := p_list:accpost_list[k]
				if tmp $ m_list
					loop
				endif
				tmp2 := oDep:getValue(tmp)
				if empty(tmp2)
					loop
				endif
				m_list[tmp] := tmp
				aadd(post_list,tmp)
			next
		next
	next

/*
	post_list2 := {}
	s1 := 'odate>=stod("'+dtos(beg_date)+'") .and. odate<=stod("'+dtos(end_date)+'")'
	for i=1 to len(acc_list)
		s2 := ' .and. (daccount="'+acc_list[i]+'" .or. kaccount="'+acc_list[i]+'")'
		tmp:=oDep:select(accpost:id,,,s1+s2)
		for j=1 to len(tmp)
			aadd(post_list2,tmp[j])
		next
	next
	asort(post_list)
	asort(post_list2)
	for i=1 to len(post_list2)
		if ascan(post_list,post_list2[i]) > 0
			loop
		endif
		tmp := oDep:getValue(post_list2[i])
		outlog(__FILE__,__LINE__,post_list2[i],tmp)
		//outlog(__FILE__,__LINE__,post_list2[i],tmp:daccount,tmp:an_debet)
		//outlog(__FILE__,__LINE__,post_list2[i],tmp:kaccount,tmp:an_kredit)
	next
//	return
*/

	d_data := {}; k_data := {}
	d_list := {}; k_list := {}

	for i=1 to len(post_list)
		obj:=oDep:getValue(post_list[i])
		if empty(obj)
			loop
		endif
		j:=ascan(acc_list,obj:daccount)
		if j>0
			tmp:=obj:daccount+obj:kaccount
			//? tmp,d_cache,"<BR/>"
			if  tmp $ d_cache
				j := d_cache[tmp]
				j:summa += obj:summa
			else
				aadd(d_data,obj)
				d_cache[tmp] := atail(d_data)
			endif
		endif
		j:=ascan(acc_list,obj:kaccount)
		if j>0
			tmp:=obj:daccount+obj:kaccount
			if  tmp $ k_cache
				j := k_cache[tmp]
				j:summa += obj:summa
			else
				aadd(k_data,obj)
				k_cache[tmp] := atail(k_data)
			endif
		endif
	next
	for i=1 to len(d_data)
		k :=map()
		obj:=d_data[i]
		tmp := NIL
		if obj:daccount $ cache
			tmp:= cache[obj:daccount]
		else
			tmp := oDep02:getValue(obj:daccount)
			if !empty(tmp)
				cache[tmp:id] := tmp
			endif
		endif
		if empty(tmp)
			cgi_html_error("ACCOUNT reference not found:"+obj:daccount)
			loop
		endif
		k:debet := tmp:code
		tmp := NIL
		if obj:kaccount $ cache
			tmp:= cache[obj:kaccount]
		else
			tmp := oDep02:getValue(obj:kaccount)
			if !empty(tmp)
				cache[tmp:id] := tmp
			endif
		endif
		if empty(tmp)
			cgi_html_error("ACCOUNT reference not found:"+obj:kaccount)
			loop
		endif
		k:kredit := tmp:code
		k:summa  := obj:summa
		aadd(d_list,k)
	next
	for i=1 to len(k_data)
		obj:=k_data[i]
		k:=map()
		tmp := NIL
		if obj:daccount $ cache
			tmp:= cache[obj:daccount]
		else
			tmp := oDep02:getValue(obj:daccount)
			if !empty(tmp)
				cache[tmp:id] := tmp
			endif
		endif
		if empty(tmp)
			cgi_html_error("ACCOUNT reference not found:"+obj:daccount)
			loop
		endif
		k:debet := tmp:code
		tmp := NIL
		if obj:kaccount $ cache
			tmp:= cache[obj:kaccount]
		else
			tmp := oDep02:getValue(obj:kaccount)
			if !empty(tmp)
				cache[tmp:id] := tmp
			endif
		endif
		if empty(tmp)
			cgi_html_error("ACCOUNT reference not found:"+obj:kaccount)
			loop
		endif
		k:kredit := tmp:code
		k:summa  := obj:summa
		aadd(k_list,k)
	next
	asort(d_list,,,{|x,y|x:kredit<y:kredit})
	d_res := resumm(d_list)
	//?
	//? d_list
	//? d_res
	asort(k_list,,,{|x,y|x:debet<y:debet})
	k_res := resumm(k_list)
	//? k_list
	//? k_res
	acc_s:=""
	j := len(acc_objs)
	for i=1 to j
		acc_s+=acc_objs[i]:code
		if i!=j
			acc_s+=','
		endif
	next

	**************
	? '<div>Справка по оборотам проводок по счету(ам): '+acc_s
	acc_s :=""
	for i=1 to len(an_values)
		if empty(an_values[i])
			loop
		endif
		acc_s+=codb_essence(an_values[i])+","
	next
	if !empty(acc_s)
	? 'аналитика:'+acc_s
	endif
	? 'за период с '+dtoc(beg_date)+' по '+dtoc(end_date)+'</div>'
	? '<table cellpadding="2" cellspacing="0" border="1" width="80%" align="center">'
	? '<tr>'
	? '	<th valign="top" width="10%"><br/></th>'
	? '	<th valign="top" width="10%"><br/></th>'
	? '	<th valign="top" width="30%">Оборот по дебету</th>'

	? '	<th valign="top" width="10%"><br/></th>'
	? '	<th valign="top" width="10%"><br/></th>'
	? '	<th valign="top" width="30%">Оборот по кредиту</th>'
	? '</tr>'
	? '<tbody>'

	j:=max(len(d_res),len(k_res))

	for i=1 to j
		if i<=len(d_res)
			tmp := d_res[i]
		else
			tmp := empty_data()
		endif
		? '<tr>'
		? '	<td valign="top" align="left">'+tmp:debet+'</td>'
		? '	<td valign="top" align="left">'+tmp:kredit+'</td>'
		? '	<td valign="top">'+Str(tmp:summa,14,2)+'</td>'
		if i<=len(k_res)
			tmp := k_res[i]
		else
			tmp := empty_data()
		endif
		? '	<td valign="top" align="left">'+tmp:debet+'</td>'
		? '	<td valign="top" align="left">'+tmp:kredit+'</td>'
		? '	<td valign="top">'+Str(tmp:summa,14,2)+'</td>'
		? '</tr>'
	next
	? '</tbody>'
	? '</table>'
	? '<BR/>'
	**********************
	? '<div>Справка по оборотам:</div>'
	? '<table cellpadding="2" cellspacing="2" border="1" width="80%" align="center">'
	? '<tr>'
	? '	<th valign="top" width="10%">Счет</th>'
	? '	<th valign="top">Начало дебет</th>'
	? '	<th valign="top">Начало кредит</th>'
	? '	<th valign="top">Оборот дебет</th>'
	? '	<th valign="top">Оборот кредит</th>'
	? '	<th valign="top">Конец дебет</th>'
	? '	<th valign="top">Конец кредит</th>'
	? '</tr>'
	? '<tbody>'

	osb_class := oDict:classBodyByName("os_balance")
	if empty(osb_class)
		cgi_html_error("Class description not found: os_balance")
		return
	endif
	s1:= ' .and. odate>=stod("'+dtos(beg_date)+ '") .and. odate<=stod("'+dtos(end_date)+ '")'
	s2:= ' .and. odate<stod("'+dtos(beg_date)+ '")'
	for i=1 to len(acc_objs)
		tmp := acc_objs[i]
		//c_data:=r2d2_get_osb_data(oDep,osb_class:id,tmp,beg_date,end_date,s1,s2)
		c_data := NIL
		for j=1 to len(an_datas[i])
			if an_datas[i][j]:an_value == "total"
				c_data := an_datas[i][j]
				exit
			endif
		next
		if empty(c_data)
			loop
		endif
//		? "c_data",c_data
		? '<tr>'
		? '<td valign="top" align="left" >'+tmp:code+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:bd_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:bk_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:od_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:ok_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:ed_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:ek_summa,14,2)+'</td>'
		? '</tr>'
	next
	? '</tbody>'
	? '</table>'
	? '<div id="end"></div></body>'

	//cgi_html_footer()
	?
	return

***********************
static function empty_data()
	static ret
	if empty(ret)
		ret := map()
		ret:debet := "<BR/>"
		ret:kredit := "<BR/>"
		ret:summa  := 0.00
	endif
return ret
***********************
static function resumm(a_list)
	local res:={},i,cel,scel
	res:=a_list
return res
