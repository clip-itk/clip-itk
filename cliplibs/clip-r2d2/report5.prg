#include "r2d2lib.ch"
/*
	отчет по субконто: подразделению/работнику/корреспонденту
*/

#define USE_DOCUMENT

function r2d2_report5_xml(_queryArr)

local err, _query
local oDict,oDep, oDep02,oDict02
local accPost, acc_chart
local beg_date:=date(),end_date:=date(),document:=""
local post,account:="",account_desc, subj, subj_desc, obj, obj_desc
local an_value:="",an_obj:=NIL,an_level:=0,an_heritage:=""
local beg_data:={},end_data:={}
local connect_id:="", connect_data, summa_all1,summa_all2
local i,j,k,c1,c2,s,s1,s2,tmp,tmp2
local acc_list, acc_objs, post_list,post_objs, _c_data
local osb_class,ani_class,c_data
local cashe:=map()

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
	if "DOCUMENT" $ _query
		document := upper(_query:document)
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

	if (empty(account) .and. empty(an_value)) .or. (empty(beg_date) .or. empty(end_date))
		cgi_html_header()
		? "Error: bad parameters ! "
		if empty(beg_date) .or. empty(end_date)
			?? "PERIOD not defined "
		endif
		if empty(account)
			?? "ACCOUNT not defined "
		endif
		if empty(an_value)
			?? "AN_VALUE not defined "
		endif
		? "Usage:"
		? "    report5?beg_date=<date>& end_date=<date>&account=<account_code>&an_value=<an_value>&document=<primary_document_id>"
		?
		return
	endif

	//cgi_html_header("Журнал по счету")
	cgi_xml_header()
	? '<body  xmlns:html="http://www.w3.org/1999/xhtml">'

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

	acc_list:={}; acc_objs:={}; tmp:=""
	obj:= oDep02:getValue(account)
	if !empty(obj)
		aadd(acc_objs,obj)
		aadd(acc_list,account)
		cashe[obj:id] := obj
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
			cashe[obj:id] := obj
		next
	endif
	if !empty(an_value)
		an_obj := codb_getvalue(an_value)
		an_heritage := codb_heritage(an_obj:class_id)
		//? an_heritage
		if empty(an_obj)
			cgi_html_error( "AN_VALUE not found: "+an_value)
			return
		endif
		/* delete ненужные счета без нужной аналитики */
		tmp := {}
		for i=1 to len(acc_objs)
			k := .f.
			for j=1 to 99
				s := "AN_VALUE"+alltrim(str(j,2,0))
				if !(s $ acc_objs[i])
					exit
				endif
				//? j,acc_objs[i]:code,acc_objs[i][s],an_heritage,acc_objs[i][s] == an_obj:class_id
				if acc_objs[i][s] $ an_heritage
					k := .t.
				endif
			next
			//? 'A',i,k
			if !k
				aadd(tmp,i)
			endif
		next
		for i=len(tmp) to 1 step -1
			adel(acc_list,tmp[i])
			adel(acc_objs,tmp[i])
		next
		asize(acc_list,len(acc_list)-len(tmp))
		asize(acc_objs,len(acc_objs)-len(tmp))
	endif

	if empty(acc_list)
		cgi_html_error( "ACCOUNT with AN_VALUE not found: "+account+":"+an_value )
		return
	endif

	osb_class := oDict:classBodyByName("os_balance")
	if empty(osb_class)
		cgi_html_error("Class description not found: os_balance")
		return
	endif
	ani_class := oDict:classBodyByName("an_info")
	if empty(ani_class)
		cgi_html_error("Class description not found: an_info")
		return
	endif

	**************
	? '<br/>'
	if !empty(account)
	? '<span name="header">Журнал счету: </span>'
	? '<span name="object">'+ acc_objs[1]:code+'  '+acc_objs[1]:smallname+'</span>'
	endif
	if !empty(an_value)
	? '<span name="header"> Аналитическая карточка по : </span>'
	? '<span name="object" idref="'+an_value+'">'+codb_essence(an_value)+'</span>'
	endif
	? 'за период с <span name="beg_date"> '+dtoc(beg_date)+'</span> по <span name="end_date">'+dtoc(end_date)+'</span>'
	? '<br/>'
	? '<table cellpadding="0" cellspacing="0" border="1" style="width: 90%;"  xmlns:html="http://www.w3.org/1999/xhtml">'
//	? '<table id="account_ved" cellpadding="2" cellspacing="0" border="1" width="80%" align="center">'
	? '<tr>'
	? '	<th valign="top"  align="left"  >Дата</th>'
	? '	<th valign="top"  align="left"  >Дебет</th>'
	? '	<th valign="top"  align="left"  >Кредит</th>'
	? '	<th valign="top"  align="right" >Д-т сумма</th>'
	? '	<th valign="top"  align="right" >К-т сумма</th>'
#ifdef USE_DOCUMENT
	? '	<th valign="top"  align="left"  width="50%">Документ</th>'
#else
	? '	<th valign="top"  align="left"  width="20%">Субъект</th>'
	? '	<th valign="top"  align="left"  width="20%">Объект</th>'
#endif
	? '</tr>'
	? '<tbody>'

	if empty(an_value)
		for i=1 to len(acc_list)
			c_data := map()
			c_data:account  := acc_objs[i]:code
			c_data:bd_summa := 0
			c_data:bk_summa := 0
			c_data:ed_summa := 0
			c_data:ek_summa := 0
			_c_data:=r2d2_get_osb_data(oDep,osb_class:id,acc_objs[i],beg_date,end_date)
			c_data:bd_summa += _c_data:bd_summa
			c_data:bk_summa += _c_data:bk_summa
			c_data:ed_summa += _c_data:ed_summa
			c_data:ek_summa += _c_data:ek_summa
			aadd(beg_data,c_data)
		next
	else
		for i=1 to len(acc_list)
			an_level = 0
			for j=1 to 99
				k := "AN_VALUE"+alltrim(str(j,2,0))
				if !(k $ acc_objs[i])
					exit
				endif
				if acc_objs[i][k] $ an_heritage
					an_level=j
				endif
			next
			c_data := map()
			c_data:account  := acc_objs[i]:code
			c_data:bd_summa := 0
			c_data:bk_summa := 0
			c_data:ed_summa := 0
			c_data:ek_summa := 0
			//s:= 'beg_date<=stod("'+dtos(end_date)+'") .and. end_date>=stod("'+dtos(beg_date)+'") '
			s:= 'beg_date<=stod("'+dtos(beg_date)+'") .and. summa!=0'
			s+= '.and. an_value=="'+an_value+'" '
			s2 := '.and. account=="'+acc_objs[i]:id+'" '
			s2 += '.and. an_level=='+alltrim(str(an_level,2,0))+' '
			tmp := oDep:select(ani_class:id,,,s+s2)
			/*
			? "1:",acc_objs[i]:code,s+s2,varToString(tmp)
			if !empty(tmp)
				? "1:",varToString(codb_getValue(tmp[1]))
			endif
			*/
			//for j=1 to len(tmp)
				//k := codb_getValue(tmp[j])
			if !empty(tmp)
				k := codb_getValue(atail(tmp))
				if empty(k)
					loop
				endif
				if k:summa >0
					c_data:bd_summa += k:summa
				else
					c_data:bk_summa -= k:summa
				endif
			endif
			//next
			s:= 'end_date>=stod("'+dtos(end_date)+'") .and. summa!=0'
			s+= '.and. an_value=="'+an_value+'" '
			s2 := '.and. account=="'+acc_objs[i]:id+'" '
			s2 += '.and. an_level=='+alltrim(str(an_level,2,0))+' '
			tmp := oDep:select(ani_class:id,,,s+s2)
			/*
			? "2:",acc_objs[i]:code,s+s2,varToString(tmp)
			if !empty(tmp)
				? "2:",varToString(codb_getValue(tmp[1]))
			endif
			*/
			for j=1 to len(tmp)
				k := codb_getValue(tmp[j])
				if empty(k)
					loop
				endif
				if k:summa >0
					c_data:ed_summa += k:summa
				else
					c_data:ek_summa -= k:summa
				endif
				exit
			next
			if c_data:bd_summa != 0 ;
				.or. c_data:bk_summa != 0 ;
				.or. c_data:ed_summa != 0 ;
				.or. c_data:ek_summa != 0 ;

				aadd(beg_data,c_data)
			endif
		next
	endif
	for i=1 to len(beg_data)
		c_data := beg_data[i]
		? '<tr id="beg_status">'
		? '	<td valign="top"  align="center" > '+dtoc(beg_date)+' </td>'
		? '	<td valign="top"  align="center" > '+iif(c_data:bk_summa==0,c_data:account,"  ")+' </td>'
		? '	<td valign="top"  align="center" > '+iif(c_data:bd_summa==0,c_data:account,"  ")+' </td>'
		? '	<td valign="top"  align="right"> '+str(c_data:bd_summa,14,2)+' </td>'
		? '	<td valign="top"  align="right"> '+str(c_data:bk_summa,14,2)+' </td>'
#ifdef USE_DOCUMENT
		? '	<td valign="top"  align="left" >Начальное сальдо</td>'
#else
		? '	<td valign="top"  align="left" >Начальное</td>'
		? '	<td valign="top"  align="left" >сальдо</td>'
#endif
		? '</tr>'
	next

	post_list := {}
	if empty(an_value)
		s1 := 'odate>=stod("'+dtos(beg_date)+'") .and. odate<=stod("'+dtos(end_date)+'")'
		for i=1 to len(acc_list)
			s2 := ' .and. daccount="'+acc_list[i]+'"'
			if !empty(document)
				s2+=' .and. primary_dcoument=="'+document+'"'
			endif
			tmp:=oDep:select(accpost:id,,,s1+s2)
			//outlog(__FILE__,__LINE__,acc_objs[i]:code,s1+s2,tmp)
			for j=1 to len(tmp)
				aadd(post_list,tmp[j])
			next
			s2 := ' .and. kaccount="'+acc_list[i]+'"'
			if !empty(document)
				s2+=' .and. primary_dcoument=="'+document+'"'
			endif
			tmp:=oDep:select(accpost:id,,,s1+s2)
			//outlog(__FILE__,__LINE__,acc_objs[i]:code,s1+s2,tmp)
			for j=1 to len(tmp)
				aadd(post_list,tmp[j])
			next
		next
	else
		s:= 'end_date>=stod("'+dtos(beg_date)+'") '
		s+= '.and. an_value=="'+an_value+'" '
		for i=1 to len(acc_list)
			an_level = 0
			for j=1 to 99
				k := "AN_VALUE"+alltrim(str(j,2,0))
				if !(k $ acc_objs[i])
					exit
				endif
				if acc_objs[i][k] $ an_heritage
					an_level=j
				endif
			next
			s2 := '.and. account=="'+acc_objs[i]:id+'" '
			s2 += '.and. an_level=='+alltrim(str(an_level,2,0))+' '
			tmp := oDep:select(ani_class:id,,,s+s2)
			for j=1 to len(tmp)
				tmp2 := oDep:getValue(tmp[j])
				if empty(tmp2)
					loop
				endif
				for k=1 to len(tmp2:accpost_list)
					aadd(post_list,tmp2:accpost_list[k])
				next
			next
		next
	endif
	summa_all1:=summa_all2:=0.00
	tmp := map()
	post_objs:={}
	for i=1 to len(post_list)
		/* не показывать дубликаты проводок */
		if post_list[i] $ tmp
			loop
		endif
		tmp[ post_list[i] ] := post_list[i]
		/* */
		post:=oDep:getValue(post_list[i])
		if empty(post)
			loop
		endif
		if ! ("DACCOUNT" $ post .and. "KACCOUNT" $ post)
			loop
		endif
		if post:odate < beg_date .or. post:odate > end_date
			loop
		endif
		if !empty(document) .and. !(post:primary_document == document)
			loop
		endif
		aadd(post_objs,post)
	next
	if empty(document)
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
	for i=1 to len(post_objs)
		post:= post_objs[i] //oDep:getValue(post_list[i])
		//outlog(__FILE__,__LINE__,post:id,post:class_id)

		c1:=accountBody(oDep02,post:daccount)
		c2:=accountBody(oDep02,post:kaccount)

//*------------------
	if (c2:code!=c1:code)
		? '<tr id="'+post:id+'">'
		? '	<td valign="top"   >'+dtoc(post:odate)+' </td>'
		? '	<td valign="top"   >'+c1:code+' </td>'
		? '	<td valign="top"   >'+c2:code+' </td>'
		subj := NIL; obj:=NIL
		if ascan(acc_list,post:daccount) >0
			summa_all1+=post:summa
			? '	<td valign="top"  align="right">'+str(post:summa,14,2)+' </td>'
			if len(post:an_debet) >0 .and. len(post:an_debet[1])>1
				subj := post:an_debet[1][2]
			endif
			if len(post:an_debet) >1 .and. len(post:an_debet[2])>1
				obj := post:an_debet[2][2]
			endif
		else
			? '	<td valign="top"  align="right">'+str(0.00,14,2)+' </td>'
		endif
		if ascan(acc_list,post:kaccount) >0
			summa_all2+=post:summa
			? '	<td valign="top"  align="right">'+str(post:summa,14,2)+' </td>'
			if len(post:an_kredit) >0 .and. len(post:an_kredit[1])>1
				subj := post:an_kredit[1][2]
			endif
			if len(post:an_kredit) >1 .and. len(post:an_kredit[2])>1
				obj := post:an_kredit[2][2]
			endif
		else
			? '	<td valign="top"  align="right">'+str(0.00,14,2)+' </td>'
		endif
#ifdef USE_DOCUMENT
		? '	<td font="size"   align="left"  ><span>'+codb_essence(post:primary_document)+'</span> <span>'+codb_essence(post:document_record)+'</span> </td>'
#else
		subj_desc := codb_getValue(subj)
		obj_desc := codb_getValue(obj)
		if empty(subj_desc)
			? '	<td valign="top"   > ... </td>'
		else
			//? '	<td valign="top"  align="left" >'+krName(subj_desc)+' </td>'
			? '	<td font="size"   align="left"  >'+codb_essence(subj)+' </td>'
		endif
		if empty(obj_desc)
			? '	<td valign="top"   > ... </td>'
		else
			//? '	<td valign="top"   >'+krName(obj_desc)+' </td>'
			? '	<td font="size" align="left">'+codb_essence(obj)+' </td>'
		endif
#endif
		? '</tr>'
	endif
//*---------------


	next
	? '<tr id="total">'
	? '	<td valign="top"  align="left" >ИТОГО </td>'
	? '	<td valign="top"  > ... </td>'
	? '	<td valign="top"  > ... </td>'
	? '	<td valign="top"  align="right">'+str(summa_all1,14,2)+'</td>'
	? '	<td valign="top"  align="right">'+str(summa_all2,14,2)+'</td>'
#ifdef USE_DOCUMENT
	? '	<td valign="top"   align="left" >Обороты за период </td>'
#else
	? '	<td valign="top"   align="left" >Обороты </td>'
	? '	<td valign="top"   align="left" >за период </td>'
#endif
	? '</tr>'
	for i=1 to len(beg_data)
		c_data := beg_data[i]
		? '<tr id="end_status">'
		? '	<td valign="top"  align="center">'+dtoc(end_date)+' </td>'
		? '	<td valign="top"  align="center">'+iif(c_data:ek_summa==0,c_data:account," ... ")+' </td>'
		? '	<td valign="top"  align="center">'+iif(c_data:ed_summa==0,c_data:account," ... ")+' </td>'
		? '	<td font="bold"  align="right">'+str(c_data:ed_summa,14,2)+' </td>'
		? '	<td font="bold"  align="right">'+str(c_data:ek_summa,14,2)+' </td>'
#ifdef USE_DOCUMENT
		? '	<td valign="top"  align="left" >Конечное сальдо </td>'
#else
		? '	<td valign="top"  align="left" >Конечное </td>'
		? '	<td valign="top"  align="left" >сальдо </td>'
#endif
		? '</tr>'
	next
	? '</tbody>'
	? '</table>'
	? '<div id="end"></div></body>'

	//cgi_html_footer()
	?
	return
**********************
static function accountBody(oDep02,account_id)
	static cashe:=map()
	local ret
	if account_id $ cashe
		return cashe[account_id]
	endif
	ret:=oDep02:getValue(account_id)
	cashe[account_id] := ret
return ret


