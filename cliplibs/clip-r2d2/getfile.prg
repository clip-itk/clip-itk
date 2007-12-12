#include "r2d2lib.ch"
#include "fileio.ch"

function r2d2_getfile_xml(_queryArr)

local err, _query, connect_id
local data,ldata,file:="",c_type:="",locale:=""

	errorblock({|err|error2html(err)})

	set translate path off

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif

	if "FILE" $ _query
		file := _query:file
	endif
	if "LOCALE" $ _query
		locale := _query:locale
	endif

	if empty(file)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		? "Usage:"
		? "    getfile?file=<file_name>"
		?
		return
	endif

	c_type = get_contentType(file)

	?? "Content-type: "+c_type
	?

	ldata := _get_localeData(file,locale)
	if empty(ldata)

		data := memoread(file)
		data := _normalize(@data,file)
		if empty(data)
		data:="<error>file not found </error>"
		endif
		? data
		return
	endif
	data := memoread(file)
	data := _localize(@data,ldata)
	data := _normalize(@data,file)
	? data
return
*******************
static function _localize(data,ldata)
	local i,ret
	if empty(ldata)
		return data
	endif
	ret := data
	for i=1 to len(ldata)
		ret := strtran(ret,"&"+ldata[i][1]+";",ldata[i][2])
	next
return ret
*******************
static function _normalize(data,file)
	local i, ret := data
	local ndata := ;
		{;
			{"HOSTNAME",getHostName()},;
			{"AQUARUM","cgi-bin/aquarum/"},;
			{"FILE",file};
		}
	for i=1 to len(ndata)
		ret := strtran(ret,"$"+ndata[i][1]+"$",ndata[i][2])
	next
return ret
*******************
static function _get_localeData(file,locale)
	local ret := {}, oldset
	local i,s1,s2,lfile,fh

	i := atr("/",file)
	if i<=0
		i := atr("\",file)
	endif
	if i<=0
		return ret
	endif

	s1 := substr(file,1,i)
	s2 := substr(file,i+1)

	lfile := s1+"locale/"+locale+"/"+s2

	i := atr(".",lfile)
	if i<=0
		s1 := lfile
	else
		s1 := substr(lfile,1,i-1)
	endif
	lfile := s1+".dtd"

	oldset := set(_SET_TRANSLATE_PATH,.f.)

	if !file(lfile)
		set(_SET_TRANSLATE_PATH,oldset)
		return ret
	endif
/*<!ENTITY button.proba.parent "asdf"> */

	fh:=fopen(lfile,FO_READ)
	if fh < 0
		set(_SET_TRANSLATE_PATH,oldset)
		outlog(__FILE__,__LINE__,[Can`t open file:]+lfile)
		return ret
	endif
	while !fileeof(fh)
		s1:=filegetstr(fh)
		s2 := substr(s1,1,8)
		if !(s2 == "<!ENTITY")
			loop
		endif
		s1 := alltrim(strtran(substr(s1,10),">",""))
		i := at(" ",s1)
		if i<=0
			loop
		endif
		s2 := substr(s1,i+1)
		s2 := strtran(s2,'"',"")
		s1 := substr(s1,1,i-1)
		aadd(ret,{s1,s2})
	enddo
	fclose(fh)
	set(_SET_TRANSLATE_PATH,oldset)
	//? lfile,ret
return ret

