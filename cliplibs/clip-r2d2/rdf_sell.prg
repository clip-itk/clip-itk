#include "r2d2lib.ch"

function r2d2_sell_rdf(_queryArr)

local err,_query
local i,j,tmp,tmp1,obj
local lang:="", sDict:="", sDep:=""
local urn, sprname:="", attrname:=""
local oDict,oDep
local oDep02, oDict02, acc_chart, accounts:=map(),values:=map(), rules:={}
local columns, classDesc, selling, accpost
local doc_summa,customer,doc_id, objs:={}, push_id := ""

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "SPR" $ _query
		sprname := _query:spr
	endif
	if "ATTR" $ _query
		attrname := _query:attr
	endif
	if "PUSH_ID" $ _query
		push_id := upper(_query:push_id)
	endif
	if "LANG" $ _query
		lang := _query:lang
	endif
	if "URN" $ _query
		URN := _query:URN
	endif
	if empty(urn)
		urn := 'urn:'+sprname
	endif

	lang := cgi_choice_lang(lang)
	sDep := cgi_choice_sDep(lang)
	sprname := lower(sprname)
	sDict:= cgi_choice_sDict(@sprname)

	if empty(sprname) .or. empty(attrname) .or. empty(push_id) ;
	   .or. empty(sDep) .or. empty(sDict)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		if empty (sdep)
			?? "LANG not defined "
		endif
		if empty (sdict)
			?? "DICTIONARY not defined "
		endif
		if empty (attrname)
			?? "ATTRIBUTE NAME not defined "
		endif
		if empty (push_id)
			?? "ORDER_PUSH ID not defined "
		endif
		? "Usage:"
		? "    rdf_sell?spr=<spr_name>;attr=attrname;push_id=push_obj_id"
		?
		return
	endif

	cgi_xml_header()
	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	//? 'xmlns:docum="http://last/cbt_new/rdf#">'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	?

	oDep := codb_needDepository(sDict+sDep)
	if empty(oDep)
		cgi_xml_error( "Depository not found: "+sDict+sDep )
		return
	endif
	oDict := oDep:dictionary()
	selling:=oDict:classBodyByName("selling")
	if empty(selling)
		cgi_xml_error("Class definition not found for: selling")
		return
	endif
	accpost:=oDict:classBodyByName("accpost")
	if empty(accpost)
		cgi_xml_error("Class definition not found for: accpost")
		return
	endif
	classDesc:=oDict:classBodyByName(sprname)
	if empty(classDesc)
		cgi_xml_error("Class definition not found for:"+sprname)
		return
	endif
	columns := cgi_make_columns(oDict,sprname)
	if empty(columns)
		cgi_xml_error("Empty table description for "+sprname)
		return
	endif
	oDep02 := codb_needDepository("GBL0201")
	if empty(oDep02)
		cgi_xml_error( "Depository not found: GBL0201" )
		return
	endif
	oDict02 := oDep02:dictionary()
	acc_chart:=oDict02:classBodyByName("acc_chart")
	if empty(acc_chart)
		cgi_xml_error("Class definition not found for: acc_chart")
		return
	endif
	if !make_accounts(oDep02,acc_chart,accounts)
		return
	endif
	if !make_rules(oDep02,acc_chart,accounts,rules)
		return
	endif
	if !make_values(oDep02,acc_chart,accounts,values)
		return
	endif

	tmp:=oDep:select(selling:id,,,'order_push=="'+push_id+'"')
	/* delete old accposts */
	doc_summa := 0
	for i=1 to len(tmp)
		tmp1:=oDep:select(accpost:id,,,'document_record=="'+tmp[i]+'"')
		for j=1 to len(tmp1)
			oDep:delete(tmp1[j])
		next
		obj := oDep:getValue(tmp[i])
		if empty(obj)
			cgi_xml_error("Object not readable: "+tmp[i])
			loop
		endif
		if empty(customer)
			customer := obj:customers
		endif
		doc_summa += obj:retailprice * obj:quantity
	next
	obj:=map()
	obj:summa := doc_summa
	obj:customers := customer
	obj:odate := date()
	obj:regdate := date()
	obj:acc_type_trans := "rdf_sell_prg"
	obj[upper(attrname)] := push_id
	doc_id := oDep:append(obj,classDesc:id)
	if empty(doc_id) .or. !empty(oDep:error)
		cgi_xml_error("Error append object:"+oDep:error)
		return
	endif

	for i=1 to len(tmp)
		obj := oDep:getValue(tmp[i])
		if empty(obj)
			cgi_xml_error("Object not readable: "+tmp[i])
			loop
		endif
		obj:doc_invoice_out := doc_id
		oDep:update(obj)
	next

	//outlog(__FILE__,__LINE__,values)
	make_posts(oDep,accounts,rules,values,tmp)

	print_sell(urn,doc_id,oDep,columns)

return

******************************************************
static function make_posts(oDep,accounts,rules,values,pList)
	local i,j,k,tmp,obj,post
	local oDict,accPost
	local e,err,flag,s,v,rule,val

	oDict := oDep:dictionary()
	accPost:= oDict:classBodyByName("accpost")
	err:=errorblock({|e|break(e)})
	for i=1 to len(pList)
		obj := oDep:getValue(pList[i])
		if empty(obj)
			cgi_xml_error("Object not readable: "+pList[i])
			loop
		endif
		for j=1 to len(rules)
			rule := rules[j]
			flag := .f.
			post:=map()
			for k in rule KEYS
				s := rule[k]
				begin sequence
					v := mapEval(obj,s)
				recover
					cgi_xml_error("Error in expression: "+s)
					flag :=.t.
				end sequence
				if flag
					exit
				endif
				if valtype(v) == "N"
					v := val(alltrim(str(v,len(v),dec(v))))
				endif
				post[k] := v
			next
			if flag
				loop
			endif
			if ! ("SUMMA" $ post .and. post:summa !=0)
				loop
			endif
			post:an_debet:={}
			if "DACCOUNT" $ post .and. post:daccount $ values
				val := values[post:daccount]
				for k=1 to len(val)
					s := val[k][2]
					v := ""
					begin sequence
						v := mapEval(obj,s)
					recover
						cgi_xml_error("Error in expression: "+s)
					end sequence
					aadd(post:an_debet,{val[k][1],v})
				next
			endif
			post:an_kredit:={}
			if "KACCOUNT" $ post .and. post:kaccount $ values
				val := values[post:kaccount]
				for k=1 to len(val)
					s := val[k][2]
					v := ""
					begin sequence
						v := mapEval(obj,s)
					recover
						cgi_xml_error("Error in expression: "+s)
					end sequence
					aadd(post:an_kredit,{val[k][1],v})
				next
			endif
			//outlog(__FILE__,__LINE__,post)
			oDep:append(post,accpost:id)
			if !empty(oDep:error)
				cgi_xml_error("Append error accpost object: "+oDep:error)
			endif
		next
	next
	errorBlock(err)
return
******************************************************
static function make_values(oDep02,acc_chart,accounts,values)
	local i,k,s, acc,acc_code, tmp,val
	for k in accounts KEYS
		acc := accounts[k]
		values[acc:id] := {}
		val := values[acc:id]
		acc_code := acc:code
		for i=1 to 99
			s := "AN_VALUE"+alltrim(str(i,2,0))
			if !(s $ acc) .or. empty(acc[s])
				exit
			endif
			tmp := {acc[s]}
			do case
				case acc_code == "62" .and. i==1
					aadd(tmp,"customers")
				case acc_code == "62" .and. i==2
					aadd(tmp,"doc_invoice_out")
				case acc_code == "41" .and. i==1
					aadd(tmp,"tov_class")
				case acc_code == "41" .and. i==2
					aadd(tmp,"tovar_name")
				case acc_code == "41" .and. i==3
					aadd(tmp,"inventories2")
			endcase
			aadd(val,tmp)
		next
	next
return .t.
******************************************************
static function make_rules(oDep02,acc_chart,accounts,rules)
	local tmp,acc
	*
	aadd(rules,map())
	tmp := rules[1]
	tmp:odate := "date()"
	tmp:document_record := "id"
	tmp:primary_document := "doc_invoice_out"
	tmp:acc_type_trans :="'rdf_sell_prg'"
	tmp:documenttype := ""
	tmp:daccount:="62"
	if tmp:daccount $ accounts
		acc := accounts[tmp:daccount]
		tmp:daccount := "'"+acc:id+"'"
	endif
	tmp:kaccount:="90"
	if tmp:kaccount $ accounts
		acc := accounts[tmp:kaccount]
		tmp:kaccount := "'"+acc:id+"'"
	endif
	tmp:summa := "retailprice*quantity"
	tmp:quantity := "quantity"
	tmp:unit := "unit"
	*
	aadd(rules,map())
	tmp := rules[2]
	tmp:odate := "date()"
	tmp:document_record := "id"
	tmp:primary_document := "doc_invoice_out"
	tmp:acc_type_trans :="'rdf_sell_prg'"
	tmp:documenttype := ""
	tmp:daccount:="90"
	if tmp:daccount $ accounts
		acc := accounts[tmp:daccount]
		tmp:daccount := "'"+acc:id+"'"
	endif
	tmp:kaccount:="41"
	if tmp:kaccount $ accounts
		acc := accounts[tmp:kaccount]
		tmp:kaccount := "'"+acc:id+"'"
	endif
	tmp:summa := "summa"
	tmp:quantity := "quantity"
	tmp:unit := "unit"
	*
	aadd(rules,map())
	tmp := rules[3]
	tmp:odate := "date()"
	tmp:document_record := "id"
	tmp:primary_document := "doc_invoice_out"
	tmp:acc_type_trans :="'rdf_sell_prg'"
	tmp:documenttype := ""
	tmp:daccount:="90"
	if tmp:daccount $ accounts
		acc := accounts[tmp:daccount]
		tmp:daccount := "'"+acc:id+"'"
	endif
	tmp:kaccount:="68"
	if tmp:kaccount $ accounts
		acc := accounts[tmp:kaccount]
		tmp:kaccount := "'"+acc:id+"'"
	endif
	tmp:summa := "retailprice*quantity-summa"
	tmp:quantity := "quantity"
	tmp:unit := "unit"
return  .t.
******************************************************
static function make_accounts(oDep02,acc_chart,accounts)
	local i,j,tmp,obj,m:={"62","90","41","68"}
	local ret := .t.

	for i=1 to len(m)
		tmp:=oDep02:select(acc_chart:id,,,'code=="'+m[i]+'"')
		if empty(tmp)
			cgi_xml_error("Account not found:"+m[i])
			ret := .f.
			loop
		endif
		obj := oDep02:getValue(tmp[1])
		if empty(obj)
			cgi_xml_error("Account not readable:"+tmp[1])
			ret := .f.
			loop
		endif
		accounts[m[i]] := obj
	next
return ret

******************************************************
static function print_sell(urn,doc_id,oDep,columns)
	local doc_obj
	local aRefs:={}, aTree :={}

	doc_obj := oDep:getValue(doc_id)
	if "OWNER_ID" $ doc_obj
		aadd(aRefs,{doc_obj:id,doc_obj:owner_id,.f.,doc_obj})
	else
		aadd(aRefs,{doc_obj:id,"",.f.,doc_obj})
	endif

	//asort(aRefs,,,{|x,y| x[3] <= y[3] })
	cgi_checkTreeArefs(arefs,oDep)
	cgi_fillTreeRdf(aRefs,aTree,"",1)


	cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns,"")
	?
	cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns,"")
	? '</RDF:RDF>'
?
return
