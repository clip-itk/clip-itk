static outstr:=""

/*
/*********************************/
function cgi_return()
	outlog(__FILE__,__LINE__)
	qout(outstr+"&\n")
	outstr := ""
return
/*********************************/
function cgi_quit()
	outlog(__FILE__,__LINE__)
	qout(outstr+"&\n QUIT &\n")
	outstr := ""
quit
*/
/*********************************/
exit procedure cgi_end()
	//outlog(__FILE__,__LINE__)
	if !empty(outStr)
		qout(outstr+"&\n")
	endif
	outstr := ""
return
/*********************************/
function cgi_outstr()
return  outstr
/*********************************/
function cgi_clear()
	outstr := ""
return
/*********************************/
function cgi_qout()
	local i
	outstr += "&\n"
	//outlog(__FILE__,__LINE__,pcount(),param(1))
	for i=1 to pcount()
		cgi_qqout(param(i))
	next
return
/*********************************/
function cgi_qqout(data)
	local s
	if valtype(data) == "CM"
		s := data
	else
		s := toString(data)
	endif
	outstr+=s
return
