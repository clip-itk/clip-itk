#include "r2d2lib.ch"

function r2d2_report3_xml(_queryArr)

local err, _query
local oDict,oDep, oDep02,oDict02
local accPost, acc_chart, osb_class
local beg_date:=date(),end_date:=date(), account:=""
local connect_id:="", connect_data
local i,j,k,s1,s2,tmp,obj,col,columns
local acc_list, acc_objs
local post_list, d_data,k_data, d_list,k_list, d_res,k_res
local d_cache:=map(), k_cache:=map()
local c_data, aRefs:={},aTree:={}
local urn,sprname,cache:=map()

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
	if "URN" $ _query
		URN := _query:URN
	endif

	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif
	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
	endif

	if empty(account) .or. empty(beg_date) .or. empty(end_date)
		cgi_html_header()
		? '<body>'
		? "Error: bad parameters ! "
		if empty(beg_date) .or. empty(end_date)
			?? "PERIOD not defined "
		endif
		if empty(account)
			?? "ACCOUNT not defined "
		endif
		? "Usage:"
		? "    report3?beg_date=<date>& end_date=<date>& account=<account_code>"
		?
		return
	endif

	cgi_xml_header()

	oDep := codb_needDepository("ACC0101")
	if empty(oDep)
		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()

	sprname = "accpost"
	accPost:= oDict:classBodyByName(sprname)
	if empty(accPost)
		cgi_xml_error( "Class description not found: "+sprname )
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
		cgi_xml_error( "ACCOUNT not found: "+account )
		return
	endif

	columns := cgi_make_columns(oDict,sprname)
	i := ascan(columns,{|x|x:name == "an_debet"})
	if i>0
		col := oclone(columns[i])
		col:datatype := "R"
		col:dataref_to := ""
		adel(columns,i)
		asize(columns,len(columns)-1)
		*
		for j=6 to 1 step -1
			tmp:=NIL; tmp := oclone(col)
			tmp:name := "an_debet"+alltrim(str(j,2,0))
			tmp:header := "áÎäÅÂÅÔ"+alltrim(str(j,2,0))
			tmp:expr := "iif(len(an_debet)>="+alltrim(str(j,2,0))+",codb_essence(an_debet["+alltrim(str(j,2,0))+"][2]),'')"
			tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")

			tmp:obj_id := "iif(len(an_debet)>="+alltrim(str(j,2,0))+",an_debet["+alltrim(str(j,2,0))+"][2],'')"
			tmp:obj_id := &("{|p1,p2,p3,p4|"+tmp:obj_id+"}")

			aadd(columns,"")
			ains(columns,i)
			columns[i] := tmp
		next

	endif
	i := ascan(columns,{|x|x:name == "an_kredit"})
	if i>0
		col := oclone(columns[i])
		col:datatype :="R"
		col:dataref_to := ""
		adel(columns,i)
		asize(columns,len(columns)-1)
		*
		for j=6 to 1 step -1
			tmp:=NIL; tmp := oclone(col)
			tmp:name := "an_kredit"+alltrim(str(j,2,0))
			tmp:header := "áÎëÒÅÄÉÔ"+alltrim(str(j,2,0))
			tmp:expr := "iif(len(an_kredit)>="+alltrim(str(j,2,0))+",codb_essence(an_kredit["+alltrim(str(j,2,0))+"][2]),'')"
			tmp:block := &("{|p1,p2,p3,p4|"+tmp:expr+"}")

			tmp:obj_id := "iif(len(an_kredit)>="+alltrim(str(j,2,0))+",an_kredit["+alltrim(str(j,2,0))+"][2],'')"
			tmp:obj_id := &("{|p1,p2,p3,p4|"+tmp:obj_id+"}")

			aadd(columns,"")
			ains(columns,i)
			columns[i] := tmp
		next

	endif
	post_list := {}
	aRefs := {}
	s1 := 'odate>=stod("'+dtos(beg_date)+'") .and. odate<=stod("'+dtos(end_date)+'")'
	for i=1 to len(acc_list)
		s2 := ' .and. (daccount="'+acc_list[i]+'" .or. kaccount="'+acc_list[i]+'")'
		tmp:=oDep:select(accpost:id,,,s1+s2)
		for j=1 to len(tmp)
			obj := oDep:getValue(tmp[j])
			if empty(obj)
				outlog(__FILE__,__LINE__,"Can`t load object:",tmp[i])
				loop
			endif
			aadd(aRefs,{obj:id,"",dtos(obj:odate)+":"+obj:primary_document,obj})
			//aadd(aRefs,{obj:id,{},obj})
			//aadd(aTree,{aRefs[i][1],{},aRefs[i][4]})
		next
	next

#ifndef ___1
	asort(aRefs,,,{|x,y| x[3] <= y[3] })
	cgi_fillTreeRdf(aRefs,aTree,"",1)

	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	?

	if empty(urn)
		urn := sprname
	endif
	cgi_putArefs2Rdf1(aTree,oDep,0,urn,columns,"")
	?
	cgi_putArefs2Rdf2(aTree,oDep,0,urn,columns,"")
	? '</RDF:RDF>'
#else
	cgi_putTreeHeader(columns)
	? '<treechildren id="data">'

	if !empty(aRefs)
		//cgi_fillTreeArefs(aRefs,aTree,"",1)
		atree := aRefs
		cgi_putTreeArefs(aTree,oDep,0,_queryArr,columns)
	endif

	? '<treeitem id="end"/>'
	? '</treechildren>'

	cgi_putTreeFooter()
#endif

