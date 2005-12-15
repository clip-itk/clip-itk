#include "r2d2lib.ch"

function r2d2_an_rdf(_queryArr)

local err, _query
local sDict:="", sDep:=""
local oDict,oDep, classDesc
local connect_id:="", connect_data
local beg_date:=date(),end_date:=date(),account:=""
local periodic, mPeriod, nPer
local i,j,k,tmp,obj
local an_data,an_level:=1, an_values:={" "," "," "," "," "," "}
local urn:="", xslt:="", host:="", total:="", union:=""
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
	if "XSLT" $ _query
		xslt := _query:xslt
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
	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif
	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
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

	if len(xslt)>0
	? '<?xml-stylesheet type="text/xsl" href="http://'+host+'/xslt/'+xslt+'"?>'
	endif
	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	? '	xmlns:DOCUM="http://last/cbt_new/rdf#">'

	oDep := codb_needDepository("ACC0101")
	if empty(oDep)
//		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()


	mperiod := periodic2date(beg_date,end_date,periodic)
	for nPer = 1 to len(mPeriod)
		beg_date =mPeriod[nPer][1]
		end_date =mPeriod[nPer][2]

		//? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
		//? '	xmlns:DOCUM="http://last/cbt_new/rdf#">'
		? '<RDF:beg_date>'+dtoc(beg_date)+'</RDF:beg_date>'
		? '<RDF:end_date>'+dtoc(end_date)+'</RDF:end_date>'
		? '<RDF:account>'+codb_essence(account)+'</RDF:account>'
		//? '<RDF:an_value>'+codb_essence(an_value)+'</RDF:an_value>'

		an_data := cgi_an_make_data(beg_date,end_date,oDep,account,an_values,an_level,union)
		asort(an_data,,,{|x,y| x:essence <= y:essence })

		if !empty(periodic)
		    periodic := ":"+alltrim(str(nPer))
		    else
		    periodic := ""
		endif
		cgi_an_putRdf1(an_data,account,an_level,urn,total,beg_date,end_date,"",periodic)
		//putRdf2(an_data,account,an_level)

	next
	? '</RDF:RDF>'
	oDep:close()
	return
******************************
function cgi_an_putRdf1(bal_data,account,an_level,urn,total,beg_date,end_date,sTree,ext_urn)
	local ss,i,j,k,tmp,cont:=.f.,s,acc,attr,urn_id,promt,acccode
	s:="AN_VALUE"+alltrim(str(an_level+1,2,0))
	acc := codb_getValue(account)
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
//		? '<RDF:Description about="'+urn_id+':'+tmp:an_value+ext_urn+'" id="'+tmp:an_value+'_'+alltrim(str(random(10000)))+'" DOCUM:about="'+urn_id+':'+tmp:an_value+ext_urn+'"'
		? '<RDF:Description about="'+urn_id+':'+tmp:an_value+ext_urn+'" id="'+tmp:an_value+ext_urn+'" DOCUM:about="'+urn_id+':'+tmp:an_value+ext_urn+'"'
		? '	DOCUM:_saldo_="an_data"'
		? '	DOCUM:union="'+tmp:union+'"'
		? '	DOCUM:beg_date="'+dtoc(beg_date)+'"'
		? '	DOCUM:end_date="'+dtoc(end_date)+'"'
		acccode:=split(codb_essence(account),":")[1]
		? '	DOCUM:acccode="'+acccode+'"'
		? '	DOCUM:account="'+codb_essence(account)+'"'
		? '	DOCUM:sort_account="'+codb_essence(account)+'"'
		? '	DOCUM:ref_account="'+account+'"'
		? '	DOCUM:account_name="'+tmp:essence+'"'
		? ' 	DOCUM:an_value.id="'+tmp:an_value+'"'

		k := split(tmp:tcols,'"  ')
		for j=1 to len(k)
			//? '	DOCUM:an_value.'+alltrim(k[j])+iif(j==len(k),'','"')
			ss := ""
			if "="$alltrim(k[j])
				ss +="DOCUM:rfl."+alltrim(k[j])+iif(j==len(k),'','"')
			else
				ss+=alltrim(k[j])+iif(j==len(k),'','"')
			endif
			?? " "+	ss
		next

		? '	DOCUM:bd_summa="'+bal_summa(tmp:bd_summa)+'"'
		? '	DOCUM:sort_bd_summa="'+sort_summa(tmp:bd_summa)+'"'
		? '	DOCUM:bk_summa="'+bal_summa(tmp:bk_summa)+'"'
		? '	DOCUM:sort_bk_summa="'+sort_summa(tmp:bk_summa)+'"'
		? '	DOCUM:od_summa="'+bal_summa(tmp:od_summa)+'"'
		? '	DOCUM:sort_od_summa="'+sort_summa(tmp:od_summa)+'"'
		? '	DOCUM:ok_summa="'+bal_summa(tmp:ok_summa)+'"'
		? '	DOCUM:sort_ok_summa="'+sort_summa(tmp:ok_summa)+'"'
		? '	DOCUM:ed_summa="'+bal_summa(tmp:ed_summa)+'"'
		? '	DOCUM:sort_ed_summa="'+sort_summa(tmp:ed_summa)+'"'
		? '	DOCUM:ek_summa="'+bal_summa(tmp:ek_summa)+'"'
		? '	DOCUM:sort_ek_summa="'+sort_summa(tmp:ek_summa)+'"'

		? '	DOCUM:beg_num="' +alltrim(bal_num(tmp:beg_num))   +'"'
		? '	DOCUM:sort_beg_num="' +sort_summa(tmp:beg_num)   +'"'
		? '	DOCUM:in_num="'  +alltrim(bal_num(tmp:in_num))    +'"'
		? '	DOCUM:sort_in_num="'  +sort_summa(tmp:in_num)    +'"'
		? '	DOCUM:out_num="' +alltrim(bal_num(tmp:out_num))   +'"'
		? '	DOCUM:sort_out_num="' +sort_summa(tmp:out_num)   +'"'
		? '	DOCUM:end_num="' +alltrim(bal_num(tmp:end_num))   +'"'
		? '	DOCUM:sort_end_num="' +sort_summa(tmp:end_num)   +'"'
		? '	DOCUM:unit_num="'+tmp:unit_num  +'"'
		? '	DOCUM:sort_unit_num="'+tmp:unit_num  +'"'

		? '/>'

	next

	if empty(ext_urn)
	    urn:=urn
	    else
	    urn:=urn+':'+promt
	endif

	? '<RDF:Seq about="'+urn+'">'
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
		if  tmp:an_value=='EMPTY'
			loop
		endif

		? '	<RDF:li resource="'+urn_id+':'+tmp:an_value+ext_urn+'"/>'
	next
	? '</RDF:Seq>'
return


