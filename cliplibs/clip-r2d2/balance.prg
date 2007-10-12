#include "r2d2lib.ch"

function r2d2_balance_xml(_queryArr, isRDF)

local err,_query
local sDict:="", sDep:=""
local oDict,oDep, classDesc
local connect_id:="", connect_data
local i,j,k,x,tmp,col,obj,bal_data,aBal_data:={}
local acc_chartt_class,acc_chartt_list,balance:="",account:=""
local columns,sprname,atree,nnnn,urn,level,itogo:=.f.
local xslt:=""
local host:=""
local periodic, mPeriod, nPer
private beg_date:=date(),end_date:=date()
memvar beg_date,end_date
private oDep02,oDict02,start_id:=1

errorblock({|err|error2html(err)})

	isRDF := iif( valType(isRDF)=="L", isRDF, ".t.")

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

	cgi_xml_header()
	?

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
	if len(xslt)>0
		? '<?xml-stylesheet type="text/xsl" href="http://'+host+'/xslt/'+xslt+'"?>'
	endif
	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	?

	sprname:= "os_balance"
	columns := cgi_make_columns(oDict,sprname)
	nnnn := {"odate","ndate","an_public1","an_public2",;
		"bd_quantity","bk_quantity","od_quantity",;
		"ok_quantity","ed_quantity","ek_quantity",;
		"unit"}
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
	      //tmp:expr := "cgi_getValue(account):code"
	      tmp:expr := "__obj:=cgi_getValue(account), iif(empty(__obj),account,__obj:code+':'+__obj:smallname)"
	      tmp:datatype := "C"
	      tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")
	      aadd(columns,"")
	      ains(columns,i+1)
	      columns[i+1] := tmp

	      tmp := oclone(col)
	      tmp:name := "end_date"
	      tmp:header := "Конец"
	      tmp:expr := "m->end_date"
	      tmp:datatype := "C"
	      tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")
	      aadd(columns,"")
	      ains(columns,i+1)
	      columns[i+1] := tmp

	      tmp := oclone(col)
	      tmp:name := "beg_date"
	      tmp:header := "Начало"
	      tmp:expr := "m->beg_date"
	      tmp:datatype := "C"
	      tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")
	      aadd(columns,"")
	      ains(columns,i+1)
	      columns[i+1] := tmp

	      tmp := oclone(col)
	      tmp:name := "points_count"
	      tmp:header := "Позиций"
	      tmp:expr := "points_count"
	      tmp:datatype := "N"
	      tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")
	      aadd(columns,tmp)
	endif
	******
	mperiod := periodic2date(beg_date,end_date,periodic)
	if empty(urn)
		urn := sprname
	endif
	for nPer = 1 to len(mPeriod)
		beg_date = mPeriod[nPer][1]
		end_date = mPeriod[nPer][2]

		aBal_data:={}
		for i=1 to len(acc_chartt_list)
			bal_data := make_balance(beg_date,end_date,oDep,acc_chartt_list[i],account,itogo)
			aadd(aBal_data,bal_data)
		next
		//? beg_date,end_date,len(aBal_data)

		? '<RDF:beg_date>'+dtoc(beg_date)+'</RDF:beg_date>'
		? '<RDF:end_date>'+dtoc(end_date)+'</RDF:end_date>'
		//? '000000'
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

			if isRDF
				cgi_putArefs2Rdf(aTree,oDep,0,urn,columns,"",,)
			else
				cgi_putArefs2Rdf1(aTree,oDep,0,'urn:'+urn,columns,"",level)
				?
				cgi_putArefs2Rdf2(aTree,oDep,0,'urn:'+urn,columns,"",level)
			endif
		next
	next
	? '</RDF:RDF>'

return

***********************
static function	make_balance(beg_date,end_date,oDep,cType,cAccount,itogo)
	local acc_chart_class,acc_chart_list
	local oDict,osb_class,idOwner:=""
	local aData := {},data,adata1,account
	local i,j,k,tmp,obj,s1,s2,s
	local min_date := end_date
	local aTree:={},aRefs:={}

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
	acc_chart_list := m->oDep02:select(acc_chart_class:id,,,'acc_chart_type="'+cType+'"')
	if !empty(cAccount)
		for i=1 to len(acc_chart_list)
			account := m->oDep02:getValue(acc_chart_list[i])
			if empty(account)
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
		if !empty(cAccount)
			if account:id == cAccount .or. at(cAccount,account:code)==1
			else
				loop
			endif
		endif
		//if account:code=="41.1"
		data := r2d2_get_osb_data(oDep,osb_class:id,account,beg_date,end_date,s1,s2)
		//outlog(__FILE__,__LINE__,account,beg_date,end_date,s1,s2)
		//outlog(__FILE__,__LINE__,data)
		//else
		//	loop
		//endif
		data:id := account:id //"ID_TMP_LINE_"+ntoc(m->start_id,32,4,"0")
		m->start_id++
		aadd(aData,data)
		if empty(cAccount)
			aadd(aRefs,{account:id,account:owner_id,account:code,atail(adata)})
		else
			aadd(aRefs,{account:id,idOwner,account:code,atail(adata)})
		endif
	next
	asort(aRefs,,,{|x,y| x[3] <= y[3] })
	if  empty(cAccount)
		fillTree(aRefs,atree,"",1)
	else
		fillTree(aRefs,atree,idOwner,1)
	endif
	if !empty(aTree) //empty(cAccount)
		adata1:=reSummTree(aTree,0)
		data:=map()
		if empty(cAccount)
			data:account	:= cType
			data:smallname	:= cgi_essence(cType)
			data:id 	:= "TOTAL_LINE_"+ntoc(m->start_id,32,4,"0")
		else
			if empty(idOwner)
				data:account	:= cAccount
			else
				data:account	:= idOwner
			endif
			data:smallname	:= cgi_essence(idOwner)
			data:id 	:= "TOTAL_"+cAccount
		endif
		data:code	    := [Total]
		data:owner_id	:= ""
		data:bd_summa	:= aData1[1]
		data:bk_summa	:= aData1[2]
		data:od_summa	:= aData1[3]
		data:ok_summa	:= aData1[4]
		data:ed_summa	:= aData1[5]
		data:ek_summa	:= aData1[6]
		data:points_count := aData1[7]
		m->start_id++
		//outlog(__FILE__,__LINE__, itogo)
		if itogo // =="true"
		    aadd(aTree,{[Total]+cType,"",[Total],data,{}})
		endif
	endif
return aTree
/************************************************/
static function reSummTree(aTree,level)
	local i, tItem,	adata1,adata :={0.00,0.00,0.00,0.00,0.00,0.00,0}
	for i=1 to len(atree)
		tItem := atree[i][4]
		if !empty(aTree[i][5])
			adata1:=reSummTree(aTree[i][5],level+1)
			tItem:bd_summa += aData1[1]
			tItem:bk_summa += aData1[2]
			tItem:od_summa += aData1[3]
			tItem:ok_summa += aData1[4]
			tItem:ed_summa += aData1[5]
			tItem:ek_summa += aData1[6]
			tItem:points_count := aData1[7]
		endif
		aData[1] += tItem:bd_summa
		aData[2] += tItem:bk_summa
		aData[3] += tItem:od_summa
		aData[4] += tItem:ok_summa
		aData[5] += tItem:ed_summa
		aData[6] += tItem:ek_summa
		aData[7] ++
	next
return aData
/************************************************/
static function fillTree(aRefs,atree,owner_id,level)
	local i, mdel:={}
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
		fillTree(aRefs,atree[i][5],atree[i][1],level+1)
	next
return
