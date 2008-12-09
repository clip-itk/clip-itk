#include "r2d2lib.ch"

function r2d2_balance_xml(_queryArr, typeNode)

local err,_query
local sDict:="", sDep:=""
local oDict,oDep, classDesc
local connect_id:="", connect_data
local i,j,k,x,tmp,tmp1,col,obj,bal_data,aBal_data:={}
local acc_chartt_class,acc_chartt_list,balance:="",account:=""
local columns,sprname,atree,nnnn,urn,level,itogo:=.f.
local xslt:=""
local host:=""
local periodic, mPeriod, nPer
private beg_date:=date(),end_date:=date()
memvar beg_date,end_date
private oDep02,oDict02,start_id:=1

errorblock({|err|error2html(err)})



	_query := d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif

	if "BEG_DATE" $ _query
		beg_date := ctod(_query:beg_date,"dd.mm.yyyy")
	endif

	if "XSLT" $ _query
		xslt := _query:xslt
	endif

	if "END_DATE" $ _query
		end_date := ctod(_query:end_date,"dd.mm.yyyy")
	endif

	if "HOST" $ _query
		host := _query:host
	endif

	if "BALANCE" $ _query
		balance := _query:balance
	endif
	if "ACCOUNT" $ _query
		account := _query:account
	endif
	if "PERIODIC" $ _query
		periodic := _query:periodic
	endif
	if "URN" $ _query
		urn := _query:urn
	endif
	if "ITOGO" $ _query
		itogo := _query:itogo
		if lower(left(itogo,1)) $ "yt"
			itogo := .t.
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


	if empty(beg_date) .or. empty(end_date)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		if empty(beg_date) .or. empty(end_date)
			?? "PERIOD not defined "
		endif
		? "Usage:"
		? "    balance?beg_date=<date>& end_date=<date>& account=<code|id>"
		?
		return
	endif


	oDep := cgi_needDepository("ACC01","01")
	if empty(oDep)
		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()

	m->oDep02 := cgi_depository("GBL02")
	if !empty(m->oDep02:error)
//		cgi_xml_error( m->odep02:Error )
		return
	endif
	m->oDict02 := m->oDep02:dictionary()
	acc_chartt_class := m->oDict02:classBodyByName("acc_chart_type")
	if empty(acc_chartt_class)
		//cgi_xml_error("Class description not found: acc_chart_type")
		return
	endif

	if empty(balance)
		acc_chartt_list := m->oDep02:select(acc_chartt_class:id)
	else
		acc_chartt_list := m->oDep02:select(acc_chartt_class:id,,,'code="'+balance+'"')
		if empty(acc_chartt_list)
			acc_chartt_list := {balance}
		endif
	endif

	sprname:= "os_balance"
	columns := cgi_make_columns(oDict,sprname)
	nnnn := {"odate","ndate","an_public1","an_public2",;
		"bd_quantity","bk_quantity","od_quantity",;
		"ok_quantity","ed_quantity","ek_quantity",;
		"unit","owner_id"}
	for j=1 to len(nnnn)
		i := ascan(columns,{|x|x:name==nnnn[j]})
		if i>0
			adel(columns,i)
			asize(columns,len(columns)-1)
		endif
	next
	i := ascan(columns,{|x| lower(x:name)=="account"})
	if i>0
		col := columns[i]
		col:expr := "__obj:=cgi_getValue(account), iif(empty(__obj),account,__obj:code)"
		col:header := "КодСч"
		col:block := &("{|p1,p2,p3,p4|"+col:expr+"}")

		tmp := oclone(col)
		tmp:name := "account_name"
		tmp:header := "СчНазвание"
		tmp:expr := "__obj:=cgi_getValue(account), iif(empty(__obj),account,__obj:code+':'+__obj:smallname)"
		tmp:datatype := "R"
		tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")
		aadd(columns,"")
		ains(columns,i+1)
		columns[i+1] := tmp

		tmp := oclone(col)
		tmp:name := "owner_id"
		tmp:header := "РодСчет"
		tmp:expr := "__obj:=cgi_getValue(account), iif( empty(__obj), account,__obj:code+':'+__obj:smallname)"
		tmp:datatype := "R"
		tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")
		aadd(columns,"")
		ains(columns,i+1)
		columns[i+1] := tmp
	endif
	******
	mperiod := periodic2date(beg_date,end_date,periodic)
	if empty(urn)
		urn := sprname
	endif
	cgi_xml_header()
	
	?
	if typeNode == 'rdf3'
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	    ? 'xmlns:D="http://itk.ru/D#" '
	    ? 'xmlns:R="http://itk.ru/R#" '
	    ? 'xmlns:S="http://itk.ru/S#">'
	elseif typeNode == 'rdf'
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	    ? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	elseif typeNode == 'xml'
	    ? '<root>'
	elseif typeNode == 'json'
	    ? '<root xmlns="http://itk.ru/json#">'
	endif
	
	for nPer = 1 to len(mPeriod)
	    beg_date = mPeriod[nPer][1]
	    end_date = mPeriod[nPer][2]
    	    aBal_data:={}
	    for i=1 to len(acc_chartt_list)
		bal_data := make_balance(beg_date,end_date,oDep,acc_chartt_list[i],account,itogo)
		aadd(aBal_data,bal_data)
	    next
    	    for i=1 to len(aBal_data)
		aTree := aBal_data[i]
		if empty(atree)
		    loop
		endif
		if empty(periodic)
		    level:= ""
		else
		    level:= ':'+alltrim(str(nPer))
		endif
		cgi_putArefs2Rdf3(aTree,oDep,0,urn,columns,"",,typeNode)
	    next
	next
	if typeNode == 'rdf3'
	    ? '</RDF:RDF>'
	elseif  typeNode == 'rdf'
	    ? '</RDF:RDF>'
	elseif  typeNode == 'xml'
	    ? '</root>'
	elseif  typeNode == 'json'
	    ? '</root>'
	endif

return

***********************
static function	make_balance(beg_date,end_date,oDep,cType,cAccount,itogo)
	local acc_chart_class,acc_chart_list
	local oDict,osb_class,idOwner:=""
	local aData := {},data,adata1,account
	local i,j,k,l,m,item,tmp,tmp1,tmp2,tmp3,obj,s1,s2,s
	local min_date := end_date
	local aTree:=map(),aRefs:={}
	*****
	acc_chart_class := m->oDict02:classBodyByName("acc_chart")
	if empty(acc_chart_class)
//		cgi_xml_error("Class description not found: acc_chart")
		return
	endif
	*****
	oDict:=oDep:dictionary()
	osb_class := oDict:classBodyByName("os_balance")
	if empty(osb_class)
//		cgi_xml_error("Class description not found: os_balance")
		return
	endif

	s1:= ' .and. odate>=stod("'+dtos(beg_date)+ '") .and. odate<=stod("'+dtos(end_date)+ '")'
	s2:= ' .and. odate<stod("'+dtos(beg_date)+ '")'
//	acc_chart_list := m->oDep02:select(acc_chart_class:id,,,'acc_chart_type="'+cType+'"')
	acc_chart_list := m->oDep02:select(acc_chart_class:id)
	if !empty(cAccount)
		for i=1 to len(acc_chart_list)
			account := m->oDep02:getValue(acc_chart_list[i])
			if empty(account)
				loop
			endif
			if !(account:acc_chart_type == cType)
			    loop
			endif
			if account:code == cAccount
				idOwner := account:id
				exit
			endif
		next
	endif
	for i=1 to len(acc_chart_list)
		account := m->oDep02:getValue(acc_chart_list[i])
		if empty(account)
			loop
		endif
		if !(account:acc_chart_type == cType)
		    loop
		endif
		//outlog(__FILE__,__LINE__,cType,account:code)
		if !empty(cAccount)
			if account:id == cAccount .or. at(cAccount,account:code)==1
			else
				loop
			endif
		endif
		//if account:code=="41.1"
		data := r2d2_get_osb_data(oDep,osb_class:id,account,beg_date,end_date,s1,s2)
		data:id := account:id //"ID_TMP_LINE_"+ntoc(m->start_id,32,4,"0")
		m->start_id++
		aadd(aData,data)
		if empty(cAccount)
			aadd(aRefs,{account:id,account:owner_id,account:code,atail(adata)})
		else
			aadd(aRefs,{account:id,idOwner,account:code,atail(adata)})
		endif
	next

	asort(aRefs,,,{|x,y| x[3] < y[3] })

	aTree['level0']:={}
	
	tmp:=cgi_getValue(cType)
	tmp:owner_id := ""
	tmp:account := "Всего:"
	tmp:account_name := tmp:code+":"+tmp:smallname
	tmp:bd_summa:=0.00
	tmp:bk_summa:=0.00
	tmp:od_summa:=0.00
	tmp:ok_summa:=0.00
	tmp:ed_summa:=0.00
	tmp:ek_summa:=0.00

	l:=len(aRefs)
	for i=1 to l
		obj:=aRefs[i][4]
		tmp3 := aRefs[i][2]
		obj:owner_id:=aRefs[i][2]
		tmp1 := iif( empty(tmp3),'level0',tmp3)
		if !(tmp1 $ aTree)
			aTree[tmp1]:={}
		endif
		aadd(aTree[tmp1], obj)
	next

	for i=1 to len(aTree['level0'])
		item:=aTree['level0'][i]
		if item:id $ aTree
		    summaItem(aTree, aTree[item:id], item)
		endif
	next

	for i=1 to len(aTree['level0'])		
		obj:=aTree['level0'][i]
		tmp:bd_summa +=obj:bd_summa
		tmp:bk_summa +=obj:bk_summa
		tmp:od_summa +=obj:od_summa
		tmp:ok_summa +=obj:ok_summa
		tmp:ed_summa +=obj:ed_summa
		tmp:ek_summa +=obj:ek_summa
		
	next
	aadd(aTree['level0'], tmp)
return aTree

function summaItem(aTree, items, parentItem)
local i, id, oid, obj
	for i=1 to len(items)
		id:= items[i]:id
		if id $ aTree
			summaItem(aTree, aTree[id], items[i])
		endif
		obj:=items[i]
		parentItem:bd_summa +=obj:bd_summa
		parentItem:bk_summa +=obj:bk_summa
		parentItem:od_summa +=obj:od_summa
		parentItem:ok_summa +=obj:ok_summa
		parentItem:ed_summa +=obj:ed_summa
		parentItem:ek_summa +=obj:ek_summa
	next
return aTree