#include "r2d2lib.ch"

function r2d2_report6_xml(_queryArr)

local err, _query, huddle := .f.
local oDict,oDep, oDep02,oDict02
local beg_date:=date(),end_date:=date(), account:=""
local an_value:="", an_obj, an_class:="XXXXXXXXXXXX"
local an_info, columns,acc_chart, accounts:={}
local an_valuess:={},an_values:={},an_levels:={},an_level,an_data
local acc_obj,acc_list:={}, acc_objs:={}
local urn:="",connect_id:="", connect_data, sprname:="accpost"
local k_list, d_list, arefs:={}, aTree:=map()
local post_list:={},post_objs:=map(),apost:=map()
local paraSumm:={}
local i,j,k,s,s1,s2,tmp,obj,obj2,col,typenode
	aTree['level0']:={}

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

	

	

	oDep := cgi_needDepository("ACC01","01")
	if empty(oDep)
		cgi_xml_error( "Depository not found: ACC0101" )
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

	s:= 'end_date>=stod("'+dtos(beg_date)+'") '
	if !empty(account)
	    s+= '.and. account=="'+account+'" '
	endif
	    s+= '.and. an_value=="'+an_value+'" '
	tmp:=oDep:select(an_info:id,,,s)

	for i=1 to len(tmp)
	    obj := cgi_getValue(tmp[i])
	    if empty(obj)
		loop
	    endif
	    for j=1 to len(obj:accpost_list)                                                                                                             
		k := obj:accpost_list[j]                                                                                                                 
		obj2 := cgi_getValue(obj:accpost_list[j])                                                                                               
		if !(k $ post_objs)   
		    if empty(obj2)
			loop
		    endif
		    if obj2:odate>end_date .or. obj2:odate<beg_date
			loop
		    endif
		    if "__VERSION" $ obj2 .and. obj2:__version < 0
		        loop
		    endif
		    post_objs[k]:= obj2                                                                                                                      
                endif                         
	    next 
	next


	for tmp in post_objs
	    k:=tmp:daccount+tmp:kaccount+tmp:primary_document+dtoc(tmp:odate)
	    if k $ apost
			apost[k]:summa+=tmp:summa
			apost[k]:dquantity+=tmp:dquantity
			apost[k]:kquantity+=tmp:kquantity
	    else
	        apost[k]:=tmp
	        aadd(aTree['level0'], apost[k])
	    endif 
	next
/*
	for k in apost
	    aadd(aTree['level0'], k)
	next		
*/
	asort(aTree['level0'],,,{|x,y| x:odate <= y:odate})
	columns := cgi_accpost_columns(oDict)
	if empty(urn)
		urn := sprname
	endif

	if typeNode == 'rdf3'
		cgi_xml_header()                                                                                                                                 
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'                                                                              
	    ? 'xmlns:D="http://itk.ru/D#" '                                                                                                                   
	    ? 'xmlns:R="http://itk.ru/R#" '                                                                                                                   
	    ? 'xmlns:S="http://itk.ru/S#">'                                                                                                                   
	    ?                                                                                                                                                 
	elseif typeNode == 'rdf' 
		cgi_xml_header()                                                                                                                             
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'                                                                                
	    ? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'                                                                                                         
	elseif typeNode == 'xml'
		cgi_xml_header()
		? 'root' 
	else 
		cgi_text_header()
		? '{'              
	endif                  

	cgi_putArefs2Rdf3(aTree, oDep, 0, urn, columns,"",, typeNode,.f., sprname)
	
	if typeNode == 'rdf3' .or. typeNode == 'rdf'
	    ? '</RDF:RDF>'
	elseif typeNode == 'json'
		? '}'
	else
	    ? '</root>'
	endif
return 