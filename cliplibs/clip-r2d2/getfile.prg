#include "r2d2lib.ch"

function r2d2_getfile_xml(_queryArr)

local err, _query, connect_id
local file:="",fext:=""

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

	fext := atr(".",file)
	if fext>0
		fext := substr(file,fext+1)
	else
		fext := "html"
	endif

	?? "Content-type: text/"+fext
	?
	? memoread(file)
return
