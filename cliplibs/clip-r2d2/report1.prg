#include "r2d2lib.ch"

function r2d2_report1_xml(_queryArr)

local err, _query
local oDict,oDep, oDep02,oDict02
local accPost,chess, acc_chart, osb_class
local beg_date:=date(),end_date:=date(), account:=""
local connect_id:="", connect_data
local i,j,k,x,s1,s2,summ:=0,tmp,obj
local acc_list, acc_objs,acc_s,accname:=""
local post_list, d_data,k_data, d_list,k_list, d_res,k_res
local d_cache:=map(), k_cache:=map()
local c_data, itogo:={0.00,0.00,0.00,0.00,0.00,0.00}
local cache:=map()

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


	if "ACC01" $ _query .and. !empty(_query:acc01)
	    set("ACC01",_query:acc01)
	endif
	if "ACC00" $ _query .and. !empty(_query:acc00)
	    set("ACC00",_query:acc00)
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

//	cgi_html_header("Account report")
	cgi_xml_header()
	? '<body>'

	oDep := cgi_needDepository("ACC01","01")
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

	chess := oDict:classBodyByName("chess_balance")
	if empty(accPost)
		cgi_html_error( "Class description not found: chess_balance" )
		return
	endif

	oDep02 := cgi_needDepository("GBL02","01")
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
//		outlog(__FILE__,__LINE__,obj:code)
			if (account+'.') $ obj:code
			aadd(acc_objs,obj)
			aadd(acc_list,tmp[i])
			cache[obj:id] := obj
			else
			    accname:=obj:smallname
			endif

		next

	endif
/*
	if empty(acc_list)
		cgi_html_error( "ACCOUNT not found: "+account )
		return
	endif
*/
	d_data := {}; k_data := {}
	d_list := {}; k_list := {}
	post_list := {}

#define D20070312
#ifndef D20070312 /* old code */
	s1 := 'odate>=stod("'+dtos(beg_date)+'") .and. odate<=stod("'+dtos(end_date)+'")'
	for i=1 to len(acc_list)
		s2 := ' .and. (daccount="'+acc_list[i]+'" .or. kaccount="'+acc_list[i]+'")'
		tmp:=oDep:select(accpost:id,,,s1+s2)
		for j=1 to len(tmp)
			if ascan(post_list,tmp[j])<=0
				aadd(post_list,tmp[j])
			endif
		next
	next
#else
	s1 := 'odate>=stod("'+dtos(beg_date)+'") .and. odate<=stod("'+dtos(end_date)+'")'
	for i=1 to len(acc_list)
		s2 := ' .and. (daccount="'+acc_list[i]+'" .or. kaccount="'+acc_list[i]+'")'
		tmp:=oDep:select(chess:id,,,s1+s2)
		for j=1 to len(tmp)
			if ascan(post_list,tmp[j])<=0
				aadd(post_list,tmp[j])
			endif
		next
	next
#endif
	//outlog(__FILE__,__LINE__,len(post_list),post_list)
	//return
	for i=1 to len(post_list)
		x := .f.
		obj:=oDep:getValue(post_list[i])
		//outlog(__FILE__,__LINE__,obj)
		//outlog(__FILE__,__LINE__,oDep02:getValue(obj:daccount):code,oDep02:getValue(obj:kaccount):code,obj:summa)
		//outlog(__FILE__,__LINE__,k)
		if empty(obj)
			loop
		endif
		j:=ascan(acc_list,obj:daccount)
		if j>0
			tmp:=obj:daccount+obj:kaccount
			//? tmp,d_cache,"<BR/>"
			if  tmp $ d_cache
				j := d_cache[tmp]
				//outlog(__FILE__,__LINE__,j:summa,obj:summa)
				j:summa += obj:summa
				//outlog(__FILE__,__LINE__,j:summa)
			else
				aadd(d_data,obj)
				d_cache[tmp] := atail(d_data)
			endif
			x := .t.
		endif
		j:=ascan(acc_list,obj:kaccount)
		if j>0
			tmp:=obj:daccount+obj:kaccount
			if  tmp $ k_cache
				j := k_cache[tmp]
				if !x
					j:summa += obj:summa
				endif
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

	**************
	acc_s := ""
	j:=len(acc_objs)
	for i=1 to j
		acc_s+=acc_objs[i]:code
		if i!=j
			acc_s+=","
		endif
	next
	? '<div><span>Account report</span>'
	if len(account)==12
	? '<span> '+codb_essence(account)+'</span>'
	else
	? '<span> '+codb_essence(account)+':'+accname+'</span>'
	endif
	? '<span>period from '+dtoc(beg_date)+' to '+dtoc(end_date)+'</span></div>'
	? '<table cellpadding="2" cellspacing="0" border="1" width="80%" align="center">'
	? '<tr>'
	? '	<th valign="top" width="10%"><br/></th>'
	? '	<th valign="top" width="10%"><br/></th>'
	? '	<th valign="top" width="30%">The motion of the debit</th>'

	? '	<th valign="top" width="10%"><br/></th>'
	? '	<th valign="top" width="10%"><br/></th>'
	? '	<th valign="top" width="30%">The motion of the credit</th>'
	? '</tr>'
	? '<tbody>'

	asort(d_res,,,{|x,y|val(x:debet)<val(y:debet)})
	asort(k_res,,,{|x,y|val(x:kredit)<val(y:kredit)})
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
	? '<div>Motion report:</div>'
	? '<table cellpadding="2" cellspacing="2" border="1" width="80%" align="center">'
	? '<tr>'
	? '	<th valign="top" width="10%">Account</th>'
	? '	<th valign="top">Debet begin</th>'
	? '	<th valign="top">Credit begin</th>'
	? '	<th valign="top">Debet motion</th>'
	? '	<th valign="top">Credit motion</th>'
	? '	<th valign="top">Debet end</th>'
	? '	<th valign="top">Credit end</th>'
	? '</tr>'
	? '<tbody>'

	osb_class := oDict:classBodyByName("os_balance")
	if empty(osb_class)
		cgi_html_error("Class description not found: os_balance")
		return
	endif
	asort(acc_objs,,,{|x,y|val(x:code)<val(y:code)})
	s1:= ' .and. odate>=stod("'+dtos(beg_date)+ '") .and. odate<=stod("'+dtos(end_date)+ '")'
	s2:= ' .and. odate<stod("'+dtos(beg_date)+ '")'
	for i=1 to len(acc_objs)
		tmp := acc_objs[i]
		c_data:=r2d2_get_osb_data(oDep,osb_class:id,tmp,beg_date,end_date,s1,s2)
//		? "c_data",c_data
		summ := abs(c_data:bd_summa)+abs(c_data:bk_summa)+;
			abs(c_data:od_summa)+abs(c_data:ok_summa)+;
			abs(c_data:ed_summa)+abs(c_data:ek_summa)
		if summ == 0
			loop
		endif
		? '<tr>'
		? '<td valign="top" align="left" >'+tmp:code+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:bd_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:bk_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:od_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:ok_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:ed_summa,14,2)+'</td>'
		? '<td valign="top" align="right" >'+str(c_data:ek_summa,14,2)+'</td>'
		? '</tr>'
		itogo[1]+=c_data:bd_summa
		itogo[2]+=c_data:bk_summa
		itogo[3]+=c_data:od_summa
		itogo[4]+=c_data:ok_summa
		itogo[5]+=c_data:ed_summa
		itogo[6]+=c_data:ek_summa
	next
	if len(acc_objs)>1
	    ? '<tr>'
	    ? '<td valign="top" align="left" >'+split(codb_essence(account),":")[1]+'</td>'
	    ? '<td valign="top" align="right" >'+str(itogo[1],14,2)+'</td>'
	    ? '<td valign="top" align="right" >'+str(itogo[2],14,2)+'</td>'
	    ? '<td valign="top" align="right" >'+str(itogo[3],14,2)+'</td>'
	    ? '<td valign="top" align="right" >'+str(itogo[4],14,2)+'</td>'
	    ? '<td valign="top" align="right" >'+str(itogo[5],14,2)+'</td>'
	    ? '<td valign="top" align="right" >'+str(itogo[6],14,2)+'</td>'
	    ? '</tr>'
	endif

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
