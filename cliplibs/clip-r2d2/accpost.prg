#include "r2d2lib.ch"

function r2d2_accpost_xml(_queryArr)

local err, _query
local sDict:="", sDep:=""
local oDict,oDep, classDesc
local connect_id:="", connect_data
local beg_date:=date(),end_date:=date()
local i,j,k,tmp,obj,bal_data,post_class,s1,s2,account
local infoDeps:={},infoFields:={}

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

	if !empty(connect_id)
		connect_data := cgi_connect_data(connect_id)
	endif
	if !empty(connect_data)
		beg_date := connect_data:beg_date
		end_date := connect_data:end_date
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
		? "    accpost?beg_date=<date>& end_date=<date>"
		?
		return
	endif

	cgi_xml_header()
	?
	? '<window  id="accpost"'
	? 'xmlns:html="http://www.w3.org/1999/xhtml"'
	? 'xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" >'
	? ' '



	oDep:= codb_needDepository("ACC0101")
	if empty(oDep)
		cgi_xml_error( "Depository not found: ACC0101" )
		return
	endif
	oDict := oDep:dictionary()

	**************
	tmp := oDict:select("CLASS",,"accpost")
	if empty(tmp)
		cgi_xml_error( "Class description not found: os_balance")
		return
	endif
	post_class := oDict:getValue(tmp[1])
	if empty(tmp)
		cgi_xml_error("Class description not found: os_balance")
		return
	endif

	s1:= 'odate>=stod("'+dtos(beg_date)+ '")'
	//s1+= ' .and. odate<=stod("'+dtos(end_date)+ '")'
	s2:= ' .and. odate<stod("'+dtos(beg_date)+ '")'
	tmp:=oDep:select(post_class:id,,,s1)
	for i=1 to len(tmp)
		obj:=oDep:getValue(tmp[i])
		? '<accpost_line id="'+obj:id+'" '
		?? 'odate="'+dtoc(obj:odate)+'" '
		?? 'summa="'+bal_summa(obj:summa)+'" '
		?? '>'
		account := cgi_getValue(obj:daccount)
		?  '  <accpost_debet id="'+obj:daccount+'" '
		if !empty(account)
		?? ' account_code="'+account:code+'" '
		?? ' account_smallname="'+account:smallname+'" '
		endif
		?? '>'
		__out_an_data(obj,.t.)
		**
		account := cgi_getValue(obj:kaccount)
		? '  <accpost_kredit id="'+obj:kaccount+'" '
		if !empty(account)
		?? ' account_code="'+account:code+'" '
		?? ' account_smallname="'+account:smallname+'" '
		endif
		?? '>'
		__out_an_data(obj,.f.)
		***
		? '</accpost_line>'
		//? obj
	next
	**************

	? '</window>'
	?
	return
**********************
static function __out_an_data(obj,lDebet)
	local j,k, an_data,s :="", cClass
	if lDebet
		an_data := obj:an_debet
		s:="debet"
	else
		an_data := obj:an_kredit
		s:="kredit"
	endif
	for j=1 to len(an_data)
		? '    <accpost_an_'+s+' anp_id="'+an_data[j][1]+'" '
		?? ' and_id="'+an_data[j][2]+'" '
		k:=cgi_getValue(an_data[j][2])
		if !empty(k)
			//cClass := codb_classBody(k:class_id)
			//cClass:essence(k)
			if "CODE" $ k
			?? ' and_code="'+k:code+'" '
			endif
			if "UNIT" $ k
			?? ' and_unit="'+k:unit+'" '
			endif
			if "NAME" $ k
			?? ' and_name="'+k:name+'" '
			endif
			if "SMALLNAME" $ k
			?? ' and_smallname="'+k:smallname+'" '
			endif
			if "FULLNAME" $ k
			?? ' and_fullname="'+k:fullname+'" '
			endif
		endif
		?? '/>'
	next
	? '  </accpost_'+s+'>'
return
