#include "r2d2lib.ch"

function r2d2_an_rdf3(_queryArr, typeNode)

local err, _query
local sDict:="", sDep:=""
local oDict,oDep, classDesc
local connect_id:="", connect_data
local beg_date:=date(),end_date:=date(),account:=""
local periodic, mPeriod, nPer,  checkloop:= .t.
local i,j,k,tmp,obj
local an_data,an_level:=1, an_values:={" "," "," "," "," "," "}
local urn:="", host:="", total:="", level:="", union:=""
	errorblock({|err|error2html(err)})

	_query := d2ArrToMap(_queryArr)
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
	if "PERIODIC" $ _query
		periodic := _query:periodic
	endif
	if "UNION" $ _query
		union := _query:union
	endif

	if "HOST" $ _query
		host := _query:host
	endif

	if "ACCOUNT" $ _query
		account := _query:account
	endif
	if "AN_LEVEL" $ _query
		an_level := val(_query:an_level)
		if an_level <1
			an_level := 1
		endif
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
	if "URN" $ _query
		URN := _query:URN
	endif
	if "TOTAL" $ _query
		total := _query:total
	endif
	if "LEVEL" $ _query
		level := _query:level
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


	if empty(beg_date) .or. empty(end_date) .or. empty(account)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		if empty(beg_date) .or. empty(end_date)
			?? "PERIOD not defined "
		endif
		if empty(account)
			?? "ACCOUNT not defined "
		endif
		? "Usage:"
		? "    an_rdf?beg_date=<date>& end_date=<date>& account=<id>"
		?
		return
	endif

	cgi_xml_header()
	if typeNode == 'rdf3'
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	    ? 'xmlns:D="http://itk.ru/D#" '
	    ? 'xmlns:R="http://itk.ru/R#" '
	    ? 'xmlns:S="http://itk.ru/S#">'
		? '<RDF:Seq RDF:about="'+urn+'">'
	    ?
	elseif typeNode == 'rdf'
	    ? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	    ? 'xmlns:DOCUM="http://last/cbt_new/rdf#">'
	elseif typeNode == 'xml'
	    ? '<root>'
		? '<item id="'+urn+'"'
		?? ' essence="'+codb_essence(urn)
		?? '">'
	else 
	    ? '<root xmlns="http://itk.ru/json#">'
	    ? '<items id="'+urn+'">['
	endif


	oDep := cgi_needDepository("ACC01","01")
	if empty(oDep)
//		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()
	mperiod := periodic2date(beg_date,end_date,periodic)
	for nPer = 1 to len(mPeriod)
		beg_date =mPeriod[nPer][1]
		end_date =mPeriod[nPer][2]


		an_data := cgi_an_make_data(beg_date,end_date,oDep,account,an_values,an_level,union)
		asort(an_data,,,{|x,y| x:essence <= y:essence })

		if !empty(periodic)
		    periodic := ":"+alltrim(str(nPer))
		    else
		    periodic := ""
		endif
		if typeNode == 'json'
		    ?? iif(checkloop,"",",")
		    checkloop:=.f.
		    cgi_an_putJson(an_data,account,an_level,urn,total,beg_date,end_date,"",periodic,level)
		elseif typeNode == 'rdf3'
		    cgi_an_putRdf3(an_data,account,an_level,urn,total,beg_date,end_date,"",periodic,level)
		elseif typeNode == 'xml'
			cgi_an_putXML(an_data,account,an_level,urn,total,beg_date,end_date,"",periodic,level)
		endif

	next
	if typeNode == 'rdf3'
	    ? '</RDF:Seq>'
	    ? '</RDF:RDF>'
	elseif  typeNode == 'rdf'
	    ? '</RDF:RDF>'
	elseif  typeNode == 'xml'
		? '</item>'
	    ? '</root>'
	else
	    ?? ']</items>'
	    ? '</root>'
	endif

	return
******************************
function cgi_an_putJson(bal_data,account,an_level,urn,total,beg_date,end_date,sTree,ext_urn,level)
	local ss,i,j,k,tmp,cont:=.f.,s,acc,attr,urn_id,promt,acccode,sTmp:=""
	local masan, u, stran:="", idan:="", checkloop:= .t.
	s:="AN_VALUE"+alltrim(str(an_level+1,2,0))
	acc := cgi_getValue(account)
	if !empty(acc)
		if s $ acc .and. !empty(acc[s])
			cont := .t.
		endif
	endif
	if empty(ext_urn)
		ext_urn := ""
	endif
	for i=1 to len(bal_data)
		tmp:=bal_data[i]

		if !(tmp:unit_num=="EMPTY") ;
		    .and. empty(ext_urn);
		   .and. tmp:bd_summa == 0 .and. tmp:bk_summa==0;
		   .and. tmp:od_summa == 0 .and. tmp:ok_summa==0;
		   .and. tmp:ed_summa == 0 .and. tmp:ek_summa==0;
		   .and. tmp:beg_num == 0 .and. tmp:in_num==0;
		   .and. tmp:out_num == 0 .and. tmp:end_num==0
			loop
		endif


		if tmp:an_value == 'total' .and. total!='yes'
			loop
		endif

		if tmp:an_value == 'EMPTY'
			loop
		endif
		urn_id := urn
		promt:= iif(tmp:an_value=="total","",tmp:an_value)
		?? iif(checkloop,"",",")
		checkloop:=.f.
		?? "{ a:{level:'"+level+"', isContainer:false }, "

		masan:=split(urn_id,":")
		stran:=""
		idan:=""

		for u=2 to len(masan)
			sTmp := cgi_essence(masan[u])
			stran+="stran"+alltrim(str(u))+":'"+sTmp+"', "
		next
		?? " r:{ "
		for j=1 to len(tmp:tattrib)
		    ?? tmp:tattrib[j][1]+":"
			if tmp:tattrib[j][2][3]=="C"
				?? "'"+strtran_json(tmp:tattrib[j][2][2])+"'"
			elseif tmp:tattrib[j][2][3]=="D"
				?? "'"+dtos(tmp:tattrib[j][2][2])+"'"
			elseif tmp:tattrib[j][2][3]=="L"
				?? iif(tmp:tattrib[j][2][2],'true','false')
			else
				?? "'"
				?? tmp:tattrib[j][2][2]
				?? "'"
			endif
			?? ", "
		next
		??tmp:esse+"account:'"+account+"', unit:'"+tmp:unit_num+"', an_value:'"+tmp:an_value+"'}, "
		sTmp := strtran_json(tmp:essence)

		for j=1 to len(tmp:tattrib)
		    ?? tmp:tattrib[j][1]+":'"
			if tmp:tattrib[j][2][3]=="C"
				?? strtran_json(tmp:tattrib[j][2][1])
			else
				?? tmp:tattrib[j][2][1]
			endif
			?? "', "
		next

		?? " account_name:'"+sTmp+"' ,"
		?? " account:'"+codb_essence(account)+"' ,"
		?? " id:'"+urn_id+":"+tmp:an_value+"', "+tmp:attr
		?? " union:'"
		?? tmp:union
		?? "', "
		?? " bd_summa:'"
		?? tmp:bd_summa 
		?? "', "
		?? " bk_summa:'"
		?? tmp:bk_summa 
		?? "', "
		?? " od_summa:'"
		?? tmp:od_summa 
		?? "', "
		?? " ok_summa:'"
		?? tmp:ok_summa 
		?? "', "
		?? " ed_summa:'"
		?? tmp:ed_summa 
		?? "', "
		?? " ek_summa:'"
		?? tmp:ek_summa 
		?? "', "
		?? " beg_num:'" 
		?? tmp:beg_num 
		?? "', "
		?? " in_num:'" 
		?? tmp:in_num 
		?? "', "
		?? " out_num:'" 
		?? tmp:out_num 
		?? "', "
		?? " end_num:'" 
		?? tmp:end_num 
		?? "', "
		?? " unit:'"+cgi_essence(tmp:unit_num)  +"' "
		?? "}"


	next
return


******************************
function cgi_an_putRdf3(bal_data,account,an_level,urn,total,beg_date,end_date,sTree,ext_urn)
	local ss,i,j,k,tmp,cont:=.f.,s,acc,attr,urn_id,promt,acccode,essenc
	s:="AN_VALUE"+alltrim(str(an_level+1,2,0))
	acc := cgi_getValue(account)
	//? acc
	if !empty(acc)
		if s $ acc .and. !empty(acc[s])
			cont := .t.
		endif
	endif
	if empty(ext_urn)
		ext_urn := ""
	endif
	for i=1 to len(bal_data)
		tmp:=bal_data[i]

		if !(tmp:unit_num=="EMPTY") ;
		    .and. empty(ext_urn);
		   .and. tmp:bd_summa == 0 .and. tmp:bk_summa==0;
		   .and. tmp:od_summa == 0 .and. tmp:ok_summa==0;
		   .and. tmp:ed_summa == 0 .and. tmp:ek_summa==0;
		   .and. tmp:beg_num == 0 .and. tmp:in_num==0;
		   .and. tmp:out_num == 0 .and. tmp:end_num==0
			loop
		endif


		if tmp:an_value == 'total' .and. total!='yes'
			loop
		endif

		urn_id := urn
		promt:= iif(tmp:an_value=="total","",tmp:an_value)
		?	'<RDF:li resource="'+urn_id+':'+tmp:an_value+ext_urn+'">'
		? '<RDF:Description about="'+urn_id+':'+tmp:an_value+ext_urn+'" id="'+tmp:an_value+ext_urn+'" D:about="'+urn_id+':'+tmp:an_value+ext_urn+'"'
			essenc:=strtran_rdf(tmp:essence)
			essenc := iif(tmp:an_value=="total","Итого:",essenc)
		     if tmp:an_value=="total"
		? '     R:name="'+essenc+'"'
		    endif
		? '     D:an_value="'+essenc+'"'
		? ' 	R:an_value="'+tmp:an_value+'"'


		for j=1 to len(tmp:tattrib)
			if tmp:tattrib[j][2][3]=="C"
				?? ' D:'+tmp:tattrib[j][1]+'="'
				?? strtran_rdf(tmp:tattrib[j][2][1])+'"'
				?? ' R:'+tmp:tattrib[j][1]+'="'
				?? strtran_rdf(tmp:tattrib[j][2][2])+'"'
			elseif tmp:tattrib[j][2][3]=="D"
				?? ' D:'+tmp:tattrib[j][1]+'="'
				?? tmp:tattrib[j][2][1]
				?? '"'
				?? ' S:'+tmp:tattrib[j][1]+'="'
				?? dtos(tmp:tattrib[j][2][1])
				?? '"'

			elseif tmp:tattrib[j][2][3]=="L"
				?? ' D:'+tmp:tattrib[j][1]+'="'
				?? tmp:tattrib[j][2][1]
				?? '"'
			else//if tmp:tattrib[j][2][3]=="N"
				?? ' D:'+tmp:tattrib[j][1]+'="'
				?? tmp:tattrib[j][2][1]
				?? '"'	
			endif
		next

		? '	D:bd_summa="'+bal_summa(tmp:bd_summa)+'"'
		? '	S:bd_summa="'+sort_summa(tmp:bd_summa)+'"'
		? '	D:bk_summa="'+bal_summa(tmp:bk_summa)+'"'
		? '	S:bk_summa="'+sort_summa(tmp:bk_summa)+'"'
		? '	D:od_summa="'+bal_summa(tmp:od_summa)+'"'
		? '	S:od_summa="'+sort_summa(tmp:od_summa)+'"'
		? '	D:ok_summa="'+bal_summa(tmp:ok_summa)+'"'
		? '	S:ok_summa="'+sort_summa(tmp:ok_summa)+'"'
		? '	D:ed_summa="'+bal_summa(tmp:ed_summa)+'"'
		? '	S:ed_summa="'+sort_summa(tmp:ed_summa)+'"'
		? '	D:ek_summa="'+bal_summa(tmp:ek_summa)+'"'
		? '	S:ek_summa="'+sort_summa(tmp:ek_summa)+'"'

		? '	D:beg_num="' +alltrim(bal_num(tmp:beg_num))   +'"'
		? '	S:beg_num="' +sort_summa(tmp:beg_num)   +'"'
		? '	D:in_num="'  +alltrim(bal_num(tmp:in_num))    +'"'
		? '	S:in_num="'  +sort_summa(tmp:in_num)    +'"'
		? '	D:out_num="' +alltrim(bal_num(tmp:out_num))   +'"'
		? '	S:out_num="' +sort_summa(tmp:out_num)   +'"'
		? '	D:end_num="' +alltrim(bal_num(tmp:end_num))   +'"'
		? '	S:end_num="' +sort_summa(tmp:end_num)   +'"'
		? '	D:unit_num="'+tmp:unit_num  +'"'
		? '/>'
		? '</RDF:li>'
	next

return

******************************
function cgi_an_putXML(bal_data,account,an_level,urn,total,beg_date,end_date,sTree,ext_urn)
	local ss,i,j,k,tmp,cont:=.f.,s,acc,attr,urn_id,promt,acccode,essenc
	s:="AN_VALUE"+alltrim(str(an_level+1,2,0))
	acc := cgi_getValue(account)
	//? acc
	if !empty(acc)
		if s $ acc .and. !empty(acc[s])
			cont := .t.
		endif
	endif
	if empty(ext_urn)
		ext_urn := ""
	endif
	for i=1 to len(bal_data)
		tmp:=bal_data[i]

		if !(tmp:unit_num=="EMPTY") ;
		    .and. empty(ext_urn);
		   .and. tmp:bd_summa == 0 .and. tmp:bk_summa==0;
		   .and. tmp:od_summa == 0 .and. tmp:ok_summa==0;
		   .and. tmp:ed_summa == 0 .and. tmp:ek_summa==0;
		   .and. tmp:beg_num == 0 .and. tmp:in_num==0;
		   .and. tmp:out_num == 0 .and. tmp:end_num==0
			loop
		endif


		if tmp:an_value == 'total' .and. total!='yes'
			loop
		endif

		urn_id := urn
		promt:= iif(tmp:an_value=="total","",tmp:an_value)
		?? '<object'
		?? " id='"+tmp:an_value+ext_urn+"'"
			strtran_rdf(tmp:essence)
		?? " essence='"+strtran_rdf(tmp:essence)+"'"
		?? '>'


		for j=1 to len(tmp:tattrib)
			?? '<'+tmp:tattrib[j][1]

			if tmp:tattrib[j][2][3]=="C"
				?? ' idref="'+ strtran_rdf(tmp:tattrib[j][2][2])+'"'
			elseif tmp:tattrib[j][2][3]=="L"
				?? ' value="'+ iif(tmp:tattrib[j][2][2],'true','false')+'"'
			elseif tmp:tattrib[j][2][3]=="D"
				?? ' value="'+ dtos(tmp:tattrib[j][2][2])+'"'
			endif
			?? '>'
			if tmp:tattrib[j][2][3]=="C"
				?? strtran_rdf(tmp:tattrib[j][2][1])+'"'
			else
				??	tmp:tattrib[j][2][1]
			endif
				?? '</'+tmp:tattrib[j][1]+'>'
		next

		?? '<bd_summa>'
		?? tmp:bd_summa
		?? '</bd_summa>'
		?? '<bk_summa>'
		?? tmp:bk_summa
		?? '</bk_summa>'
		?? '<od_summa>'
		?? tmp:od_summa
		?? '</od_summa>'
		?? '<ok_summa>'
		?? tmp:ok_summa
		?? '</ok_summa>'
		?? '<ed_summa>'
		?? tmp:ed_summa
		?? '</ed_summa>'
		?? '<ek_summa>'
		?? tmp:ek_summa
		?? '</ek_summa>'
		?? '<beg_num>'
		?? tmp:beg_num
		?? '</beg_num>'
		?? '<in_num>'
		?? tmp:in_num
		?? '</in_num>'
		?? '<out_num>'
		?? tmp:out_num
		?? '</out_num>'
		?? '<end_num>'
		?? tmp:end_num
		?? '</end_num>'
		?? '<unit_num idref="'
		?? tmp:unit_num
		??	'">'
		?? codb_essence(tmp:unit_num)	
		?? '</unit_num>'
		?? '</object>'
	next
?
return
