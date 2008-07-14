#include "r2d2lib.ch"

function r2d2_report3_xml(_queryArr)

local err, _query
local oDict,oDep, oDep02,oDict02
local accPost, acc_chart, osb_class
local beg_date,end_date, account:="", document:="", an_value:=""
local connect_id:="", connect_data
local i,j,k,s,s1,s2,s3,tmp,obj,col,columns
local acc_list, acc_objs
local d_data,k_data, d_list,k_list, d_res,k_res
local d_cache:=map(), k_cache:=map()
local c_data, aRefs:={},aTree:=map()
local post,post_list,post_objs
local urn,sprname,typenode,cache:=map()

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
	if "AN_VALUE" $ _query
		an_value := upper(_query:an_value)
	endif
	if "DOCUMENT" $ _query
		document := upper(_query:document)
	endif
	if "URN" $ _query
		URN := _query:URN
	endif
	if "TYPENODE" $ _query
		TYPENODE := _query:TYPENODE
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

	if empty(account) .and. empty(beg_date) .and. empty(end_date) .and. empty(document)
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
		? "    report3?beg_date=<date>& end_date=<date>& account=<account_code>& document=<primary_document_id>& an_value=<an_value>"
		?
		return
	endif

	cgi_xml_header()

	oDep := cgi_needDepository("ACC01","01")
	if empty(oDep)
//		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()

	sprname = "accpost"
	accPost:= oDict:classBodyByName(sprname)
	if empty(accPost)
		cgi_xml_error( "Class description not found: "+sprname )
		return
	endif
	
	
	if empty(urn)                                                                                                                                        
	    urn := 'urn:'+sprname                                                                                                                        
        endif        

	oDep02 := cgi_needDepository("GBL02","01")
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
	acc_list:={}; acc_objs:={}; tmp:={}
	if !empty(account)
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
	endif

	if !empty(account)
		for i=1 to len(tmp)
			obj:=oDep02:getValue(tmp[i])
			if empty(obj)
				loop
			endif
			aadd(acc_objs,obj)
			aadd(acc_list,tmp[i])
			cache[obj:id] := obj
		next
	else
		aadd(acc_list,"")
		aadd(acc_objs,map())
	endif

	if empty(acc_list)
		cgi_xml_error( "ACCOUNT not found: "+account )
		return
	endif

	columns := cgi_accpost_columns(oDict,sprname)
	post_list := {}
	aRefs := {}
	s1 :=""
	if !empty(beg_date)
		s1 += 'odate>=stod("'+dtos(beg_date)+'")'
	endif
	if !empty(end_date)
		if !empty(s1)
			s1+=' .and. '
		endif
		s1+='odate<=stod("'+dtos(end_date)+'")'
	endif
	for i=1 to len(acc_list)
		s2:=""
		if !empty(document)
			if !empty(s1)
				s2+=" .and. "
			endif
			s2+='primary_document=="'+document+'"'
		endif
		if empty(acc_list[i])
			tmp:=oDep:select(accpost:id,,,s1+s2)
			//outlog(__FILE__,__LINE__, s1+s2,tmp)
			for j=1 to len(tmp)
				aadd(post_list,tmp[j])
			next
		endif
		s3:=""
		if empty(s1) .and. empty(s2)
		else
			s3+=' .and. '
		endif
		s3 += 'daccount="'+acc_list[i]+'"'
		tmp:=oDep:select(accpost:id,,,s1+s2+s3)
		//outlog(__FILE__,__LINE__, s1+s2+s3,tmp)
		for j=1 to len(tmp)
			aadd(post_list,tmp[j])
		next
		s3:=""
		if empty(s1) .and. empty(s2)
		else
			s3+=' .and. '
		endif
		s3 += 'kaccount="'+acc_list[i]+'"'
		tmp:=oDep:select(accpost:id,,,s1+s2+s3)
		//outlog(__FILE__,__LINE__, s1+s2+s3,tmp)
		for j=1 to len(tmp)
			aadd(post_list,tmp[j])
		next
	next
	//outlog(__FILE__,__LINE__, len(post_list))
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
		if !empty(beg_date) .and. post:odate < beg_date
			loop
		endif
		if !empty(end_date) .and. post:odate > end_date
			loop
		endif
		if !empty(document) .and. !(post:primary_document == document)
			loop
		endif
		if !empty(an_value)
			s := ""
			for j=1 to len(post:an_debet)
				s+= post:an_debet[j][2]+","
			next
			for j=1 to len(post:an_kredit)
				s+= post:an_kredit[j][2]+","
			next
			if an_value $ s
			else
				loop
			endif
		endif
		aadd(post_objs,post)
	next
	if .t. //empty(document)
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
		obj:=post_objs[i]
		aadd(aRefs,{obj:id,"",dtos(obj:odate)+":"+obj:primary_document,obj})
	next

	asort(aRefs,,,{|x,y| x[3] <= y[3] })

	if typeNode == 'rdf3'                                                                                                                                
	     ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'                                                                             
	     ? 'xmlns:D="http://itk.ru/D#" '                                                                                                                  
	     ? 'xmlns:R="http://itk.ru/R#" '                                                                                                                  
	     ? 'xmlns:S="http://itk.ru/S#">'                                                                                                                  
	     ?                                                                                                                                                
	 elseif typeNode == 'rdf'                                                                                                                             
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'                                                                               
	    ? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'                                                                                                        
	 elseif typeNode == 'xml'                                                                                                                             
	    ? '<root>'                                                                                                                                         
	 else                                                                                                                                                 
	    ? '<root xmlns="http://itk.ru/json#">'                                                                                                             
         endif                 

	aTree['level0']:={}                                                                                                                    
	for i=1 to len(aRefs)                                                                                                                       
	    obj:= aRefs[i][4]                                                                                                        
	    aadd(aTree['level0'], obj)                                                                                                               
	next                                                                                                                                         
																											                                                                                                                                                               
          if len(aTree)>0                                                                                                                                      
              cgi_putArefs2Rdf3(aTree,oDep,0,urn,columns,"",,typeNode,.f., sprname)                                                                
          endif                                                                                                                                                



	if typeNode == 'rdf3'                                                                                                                                
    	    ? '</RDF:RDF>'                                                                                                                                   
	elseif  typeNode == 'rdf'                                                                                                                            
	    ? '</RDF:RDF>'                                                                                                                                   
	else                                                                                                                                                 
	    ? '</root>'                                                                                                                                      
	endif                                                                                                                                                
	?						                                  
