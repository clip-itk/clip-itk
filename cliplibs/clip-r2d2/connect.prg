#include "r2d2lib.ch"

function r2d2_connect_xml(_queryArr)

local obj,err,_query
local sDict:="", sDep:=""
local oDict,oDep, tmp, classDesc
local obj_id:="",id:="",command:="",user:="",passwd:=""
local beg_date,end_date,acc00:="ACC0001",acc01:="ACC0101"
local i,j,x,y

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "COMMAND" $ _query
		command := upper(_query:command)
	endif
	if "ID" $ _query
		id := upper(_query:id)
	endif
	if "USER" $ _query
		user := _query:user
	endif
	if "PASSWD" $ _query
		passwd := _query:passwd
	endif
	if "BEG_DATE" $ _query
		beg_date := ctod(_query:beg_date,"dd.mm.yyyy")
	endif
	if "END_DATE" $ _query
		end_date := ctod(_query:end_date,"dd.mm.yyyy")
	endif
	if "ACC00" $ _query
		acc00 := _query:acc00
	endif
	if "ACC01" $ _query
		acc01 := _query:acc01
	endif

	if empty(command) .or. (command=="BEGIN" .and. empty(user))
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		if empty (command)
			?? "COMMAND not defined "
		endif
		if command="BEGIN" .and. empty(user)
			?? "USER not defined "
		endif
		? "Usage:"
		? "    connect?command=<command>& id=<id>& user=<user>& passwd=<passwd>& beg_date=<date>& end_date=<date>"
		?
		return
	endif

	cgi_xml_header()
	?
	? '<window>'

	oDep := codb_needDepository("ETC0101")
	if empty(oDep)
		cgi_xml_error( "Depository not found: ETC0101" )
		return
	endif
	oDict := oDep:dictionary()
	tmp:=oDict:select("CLASS",,"connection")
	if empty(tmp)
		cgi_xml_error("Class CONNECTION not found !","3")
		return
	endif
	classDesc := oDict:getValue(tmp[1])
	if empty(classDesc)
		cgi_xml_error("Bad description of class CONNECTION !","4")
		return
	endif


	if command=="BEGIN"
		if empty(id) //.or. !empty(tmp)
			id:="A"+padl(alltrim(ntoc(random(),32)),10,"0")
		endif
		while .t.
			tmp:= oDep:select(classDesc:id,,,'connect_id=="'+id+'"')
			if empty(tmp)
				exit
			endif
			id:="A"+padl(alltrim(ntoc(random(),32)),10,"0")
		end
		obj:=map()
		obj:user := user
		obj:passwd := passwd
		obj:connect_id := id
		obj:date := date()
		obj:time := time()
		obj:beg_date := iif(empty(beg_date),date(),beg_date)
		obj:end_date := iif(empty(end_date),date(),end_date)
		obj:acc00 := acc00
		obj:acc01 := acc01
		obj_id:=oDep:append(obj,classDesc:id)
		if empty(obj_id)
			cgi_xml_error(oDep:error,"5")
			return
		endif
		obj:= oDep:getValue(obj_id)
	endif
	if empty(obj_id) .and. !empty(id)
		tmp:= oDep:select(classDesc:id,,,'connect_id=="'+id+'"')
		if !empty(tmp)
			obj_id := tmp[1]
			obj:= oDep:getValue(obj_id)
		endif
	endif
	if !empty(oDep:error)
		cgi_xml_error(oDep:error,"6")
		return
	endif
	if empty(obj)
		cgi_xml_error("Connection ID not found:"+id,"7")
		return
	endif
	//? "obj1=",id,obj
	if command=="SET" .or. command=="BEGIN"
		if !empty(beg_date)
			obj:beg_date := beg_date
		endif
		if !empty(end_date)
			obj:end_date := end_date
		endif
		for i=1 to len(_queryArr)
			x := upper(_queryArr[i][1])
			y := _queryArr[i][2]
			if x $ "USER PASSWD BEG_DATE END_DATE COMMAND ACC00 ACC01 ID CLASS_ID"
				loop
			endif
			j := ascan(obj:user_data,{|_z|_z[1]==x})
			if j>0
				obj:user_data[j][2] := y
			else
				aadd(obj:user_data,{x,y})
			endif
		next
		oDep:update(obj)
		if !empty(oDep:error)
			cgi_xml_error(oDep:error,"8")
			return
		endif
	endif
	//? "obj2=",id,obj
	? '<connect id="'+obj:connect_id+'" user="'+obj:user+'" passwd="'+obj:passwd+'" '
	?? 'beg_date="'+dtoc(obj:beg_date)+'" end_date="'+dtoc(obj:end_date)+'" '
	?? 'acc00="'+acc00+'" acc01="'+acc01+'" '
	for i=1 to len(obj:user_data)
		x:=lower(obj:user_data[i][1])
		y:=obj:user_data[i][2]
		?? x+'="'+y+'" '
	next
	?? '/>'

	? '</window>'
	?
	return

