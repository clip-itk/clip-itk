#include "r2d2lib.ch"

function r2d2_getfile_xml(_queryArr)

local err, _query, connect_id
local file:="",c_type:=""

	errorblock({|err|error2html(err)})

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif

	if "FILE" $ _query
		file := _query:file
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

	c_type = _get_contentType(file)

	?? "Content-type: "+c_type
	?
	? memoread(file)
return
*******************
static function _get_contentType(file)
	local c_type:="text/html"
	local fext,j
	local mime := ;
		{;
			{"txt","text/plain"},;
			{"css","text/css"},;
			{"js","application/x-javascript"},;
			{"xul","application/vnd.mozilla.xul+xml"},;
			{"rdf","application/rdf+xml"},;
			{"xhtml","application/xhtml+xml"},;
			{"xht","application/xhtml+xml"},;
			{"xml","application/xml"},;
			{"xls","application/xml"};
		}

	fext := atr(".",file)
	if fext>0
		fext := substr(file,fext+1)
	else
		fext := ""
	endif
	j := ascan(mime,{|x|x[1]==fext})
	if empty(fext)
		c_type := mime[1][2]
	elseif 	j<=0
		c_type := "text/"+fext
	else
		c_type := mime[j][2]
	endif
return  c_type

