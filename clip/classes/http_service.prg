/*
	HTTP_Service - class for create HTTP Servers and Clients.

     Copyright (C) 2004  ITK
     Author  : Uri (uri@itk.ru)
     Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/

#include "http.ch"
#include "tcp.ch"
#define HTTP_NREAD 10000

function httpServiceNew(oIni)
	local obj:=map()
	obj:classname	:= "HTTPSERVICE"
	obj:cHost	:= HTTP_DEFHOST
	obj:nPort	:= KAMACHE_DEFPORT
	obj:nTimeOut	:= TCP_CONNECT_TIMEOUT
	obj:nIOtimeOut	:= TCP_IO_TIMEOUT
	obj:nVersion	:= KAMACHE_VERSION
	obj:DocRoot	:= KAMACHE_DOCROOT
	obj:cgiBin	:= KAMACHE_CGIBIN
	obj:modClip	:= KAMACHE_MODCLIP
	obj:modCache	:= ""
	obj:aliases	:= {}
	obj:ssi		:= {}
	obj:fileicons	:= map()
	obj:mimeicons	:= map()
	obj:hostname	:= getHostName()+"."+getDomainName()
	obj:admin	:= "webmaster@"+obj:hostname
	obj:serverSoft	:= ""
	obj:serverSign	:= ""
	obj:dateFormat	:= "dd.mm.yyyy"

	obj:nConnect	:= -1
	obj:cLine	:= ""
	obj:buffer	:= ""
	obj:command	:= ""
	obj:error	:= ""
	obj:errno	:= 0
	obj:nSended	:= 0
	obj:nReceived	:= 0
	obj:oIni	:= oIni
	obj:sets	:= {}

	_recover_httpservice(obj)

	obj:fromIni(oIni)
	obj:defSetting()
return obj

/******************************/
function _recover_httpservice(obj)
	/* methods of class */
	obj:connect	:=@ HTTP_connect()
	obj:close	:=@ HTTP_close()
	obj:send	:=@ HTTP_send()
	obj:sendLine	:=@ HTTP_sendLine()
	obj:receive	:=@ HTTP_receive()
	obj:receiveLine	:=@ HTTP_receiveLine()
	obj:waitRequest	:=@ HTTP_waitRequest()
	obj:VMsetValues	:=@ HTTP_VMsetValues()
	obj:sendError	:=@ HTTP_sendError()
	obj:sendAnswer	:=@ HTTP_sendAnswer()
	obj:sendFile	:=@ HTTP_sendFile()
	obj:runSSI	:=@ HTTP_runSSI()
	obj:sendDir	:=@ HTTP_sendDir()
	obj:sendCgi	:=@ HTTP_sendCgi()
	obj:runModClip	:=@ HTTP_runModClip()
	obj:runCommand	:=@ HTTP_runCommand()
	obj:runGet	:=@ HTTP_runGet()
	obj:parseHeader :=@ HTTP_parseHeader()
	obj:checkVhost 	:=@ HTTP_checkVhost()

	obj:errorBlock	:=@ HTTP_errorBlock()

	obj:defSetting	:=@ HTTP_defSets()
	obj:fromIni	:=@ HTTP_fromIni()

	if valtype(obj:oIni) == "O"
		_recover_inifile(obj:oIni)
	endif
return obj
/******************************/
static function HTTP_connect()
	local ret:=.t.
	if ::nConnect > 0
		::close()
	endif
	::nConnect := tcpConnect( ::cHost, ::nPort, ::nTimeOut )
	if ::nConnect < 0
		::errno := ferror()
		::error := [TCP connection error:]+fErrorStr()
		ret := .f.
	endif
return ret

/******************************/
static function HTTP_close(self)
	//local cBuf := space(10)
	if self:nConnect > 0
		/*
		outlog(__FILE__,__LINE__,self:nConnect,seconds())
		tcpRead( self:nConnect, @cbuf, 10, 100 )
		*/
	    //	outlog(__FILE__,__LINE__,self:nConnect,seconds())
		tcpClose(self:nConnect)
	    //	outlog(__FILE__,__LINE__,self:nConnect,seconds())
		self:nConnect := -1
	endif
return .t.
/******************************/
static function HTTP_send(cData)
	local nL,ret := .f.
	if ::nConnect > 0 .and. valtype(cData)=="C"
		nL := tcpWrite( ::nConnect, @cData )
		if nl == len(cData)
			ret :=.t.
		else
			::errno := ferror()
			::error := fErrorStr()
		endif
		if nl>0
			::nSended += nL
		endif
	endif
return ret
/******************************/
static function HTTP_sendLine(cData)
return	::send(cData+"&\r&\n")
/******************************/
static function HTTP_receive(nBytes)
	local nL,ret :=.f.,cBuf
	if ::nConnect < 0
		return .f.
	endif
	nBytes := iif( valtype(nBytes)=="N",nBytes,TCP_BUFLEN)
	cBuf := space(nBytes,.t.)
	nL := tcpRead( ::nConnect, @cbuf, nBytes, ::nIOtimeOut )
	if nL > 0
		ret := .t.
		::buffer += left(@cBuf,nL)
		::nReceived += nL
	else
		::errno := ferror()
		::error := fErrorStr()
	endif
return ret

/******************************/
static function HTTP_receiveLine()
	local i
	::errno := 0
	::error := ""
	while (i := atl("&\r&\n", @::buffer) ) <=0
		::receive()
		if ::errno > 0 .and. ::errno != 11 /* server is busy */
			return .f.
		endif
	end
	::cLine := left(@::buffer,i-1)
	::buffer := substr(@::buffer,i+1)
return .t.

/******************************/
static function HTTP_VMsetValues(self)
	set macro_in_string off
	set translate path off
	set deleted on
	set device to printer
	set printer to membuf
	//outlog(__FILE__,__LINE__,self:dateFormat)
	set date format to (self:dateFormat)
return
/******************************/
static function HTTP_waitRequest(self)
	local lExit := .f.,nl,cBuf,tm:=seconds()
	local crlf2 := chr(13)+chr(10)+chr(13)+chr(10)
	local hlen := 0, cLen := -1, len
	self:VMsetValues()
	self:cLine := ""
	while !lExit
		self:errno := 0
		cBuf := space(HTTP_NREAD,.t.)
		nL := tcpRead( self:nConnect, @cbuf, HTTP_NREAD, 1000 )
		if nL > 0
			self:nReceived += nL
			self:cLine+=left(cbuf,nl)
		endif
		if nl > 0 .and. hLen <= 0
			hLen := at(crlf2,self:cLine)
			if hLen > 0
				nl := at("Content-Length:",self:cLine)
				if nl > 0
					cLen := val(substr(self:cLine,nl+16,30))
				else
					cLen := 0
				endif
			endif
		endif
		if hLen > 0 .and. cLen == 0
			lExit := .t.
		endif
		if hLen > 0 .and. len(self:cline) >= hLen+3+cLen
			lExit := .t.
		endif
		if self:errno!=0
			lExit := .t.
		endif
		if seconds()-tm > self:nIoTimeOut/1000
			lExit := .t.
			self:errno := 11
		endif
	enddo
	if self:errno == 32
		self:error:=[Connection closed from client:]+ferrorStr()
		self:close()
		return .f.
	endif
	if self:errno == 11 /* request timeout */
		self:sendError(HTTP_ERR_REQUESTTIMEOUT)
		self:close()
		return .f.
	endif
return .t.
/*************************************/
static function HTTP_sendError(self,nError,data1,data2,data3)
	local crlf:=chr(13)+chr(10)
	local data:=crlf,ret_code:="",s1:="",s2:=""
	//outlog(__FILE__,__LINE__,"error",nError,data1,data2,data3)
	s2:="Your browser sent a request that this server could not understand. See RFC2616."+crlf
	do case
		case nError == HTTP_ERR_FILENOTFOUND
			ret_code := "Not found"
			s1:='The requested URL'
			if !empty(data1)
				s1+=' '+data1
			endif
			if !empty(data2)
				s1+=' '+data2
			endif
			if !empty(data3)
				s1+=' '+data3
			endif
			s1+=' was not found on this server.'
		case nError== HTTP_ERR_REQUESTTIMEOUT
			ret_code := "Request Timeout"
			s1+="Request Timeout."+crlf+s2
		case nError== HTTP_ERR_NOTIMPLEEMENTED
			ret_code := "Not Implemented"
			s1:="Method"
			if !empty(data1)
				s1+=" "+data1
			endif
			s1+=" not implemented."+crlf+s2
		case nError== HTTP_ERR_BADVERSION
			ret_code := "Bad Version"
			s1:="HTTP version"
			if !empty(data1)
				s1+=" "+toString(data1)
			endif
			s1+=" not supported."+crlf+s2
		case nError== HTTP_ERR_BADREQUEST
			ret_code := " Bad Request"
			s1:="Bad Request."
			if !empty(data1)
				s1+=", "+data1
			endif
			s1+=crlf+s2
		case nError== HTTP_ERR_INTERNALSERVERERROR
			ret_code:=' Internal Server Error'
			s1:='The server encountered an internal error or misconfiguration and was unable to complete your request.<P>'
			s1+= 'Please contact the server administrator,'
			s1+= self:admin
			s1+= ' and inform them of the time the error occurred,'
			s1+= ' and anything you might have done that may have'
			s1+= ' caused the error.<P>'
			if !empty(data1)
				s1+=data1
			endif
		otherwise
	endcase
	ret_code := alltrim(str(nError))+" "+ret_code
	data+='<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">'+crlf
	data+='<HTML><HEAD>'+crlf
	data+='<TITLE>'+ret_code+'</TITLE>'+crlf
	data+='</HEAD><BODY>'+crlf
	data+='<H1>'+ret_code+'</H1>'+crlf
	data+=s1+'<P> <HR>'+crlf
	data+='<ADDRESS> '+self:serverSign+'</ADDRESS>'+crlf
	data+='</BODY></HTML>'+crlf
	data+=crlf
	self:sendAnswer(ret_code,"text/html",@data,,"iso-8859-1",,.f.)
	//self:sendAnswer(ret_code)
return .t.
/*************************************/
static function http_sendAnswer(self,ret_code,type,data,modified,charset,nLen)
	local s:="" //,nLen
	local crlf:=chr(13)+chr(10)
	if valtype(ret_code) != "C"
		ret_code = "200 OK"
	endif
	/*
	if empty(type)
		type := "text/html"
	endif
	*/
	if !empty(type) .and. !empty(charset)
		type+="; charset="+charset
	endif
	s+="HTTP/1.1 "+ret_code+crlf
	s+="Date: "+ascDateTime()+crlf
	s+="Server: "+self:serverSoft+crlf
	if valtype(modified) == "C" .and. !empty(modified)
		s+="Last-Modified: "+modified+crlf
	endif
	if valtype(nLen) == "N" //.and. nLen >0
		if nLen == -1
			if left(data,2) == crlf
				nLen := len(data)-2
			elseif left(data,1) == chr(10)
				nLen := len(data)-1
			else
				nLen := at(chr(10)+chr(10),data)
				if nLen>0
					nLen := len(data)-nLen-1
				else
					nLen := len(data)-at(crlf+crlf,data)-3
				endif
			endif
		endif
		if nLen > 0
			s+="Accept-Ranges: bytes"+crlf
			s+="Content-Length: "+alltrim(str(nLen))+crlf
		endif
	endif
	s+="Connection: close"+crlf
	if !empty(type)
		s+="Content-Type: "+type+crlf
	endif
	if valtype(data) == "C"
		s+=data
	endif
	//outlog(__FILE__,__LINE__,"sended=",s)
	self:send(@s)
return .t.
/*************************************/
static function HTTP_runModClip(self,url,cmd,postData)
	local i,j,n,head:="",data,ret, file
	local cFile,cDate:=dt_create(),cData
	local out:=space(0), err:=space(0)
	local mod,oParams,cachable := .t., lastUpdated
	file := makepath(self:modclip+PATH_DELIM+url+".po")
	//outlog(__FILE__,__LINE__,file,file(file))
	if !file(file)
		self:sendError(HTTP_ERR_FILENOTFOUND,file)
		return .f.
	endif

	aadd(self:sets,{"GATEWAY_INTERFACE","MCI/1.0"})
	aadd(self:sets,{"QUERY_STRING",cmd})
	aadd(self:sets,{"SCRIPT_NAME","/mod-clip"+url})
	aadd(self:sets,{"SCRIPT_FILENAME",file})
	*****
	mod := loadBlock(file)
	//outlog(__FILE__,__LINE__,mod)
	if valtype(mod) != "B"
		self:sendError(HTTP_ERR_INTERNALSERVERERROR,file+" is not CLIP module.")
		return .f.
	endif
	if !empty(self:modCache)
		i := hashstr(file+cmd)
		i := ntoc(i,16,12,'0')
		cFile := makepath(self:modCache+PATH_DELIM+i)
		i := directory(cFile)
		if len(i)>0
			cDate := dt_create(i[1][3],i[1][4])
			cData := memoread(cFile)
		endif
	endif
	oParams := cgi_split(cmd,.t.)
	set(_SET_ROOTPATH,self:modclip)
	if !empty(self:modCache)
		cachable := eval(mod,"CACHE-ENABLED?",self,oParams,@postData)
		if valtype(cachable) == "L" .and. cachable
			lastUpdated := eval(mod,"LAST-UPDATED?",self,oParams,@postData)
		endif
	endif
	if dt_isdtdata(lastUpdated) .and. dt_isdtdata(cDate) .and. ;
	   dt_cmp(cDate,lastUpdated) > 0
		*** send old data from cache
		self:sendAnswer("200 OK","",cData,,,-1)
		return .t.
	endif

	ret := eval(mod,"RUN",self,oParams,@postData)
	if valtype(ret) == "L" .and. !ret
		self:sendError(HTTP_ERR_INTERNALSERVERERROR,file+"?"+cmd+"<BR>")
		return .f.
	endif
	cData := getmembuf()
	self:sendAnswer("200 OK","",@cData,,,-1)
	if !dt_isdtdata(lastUpdated)
		return .t.
	endif
	**** save data to cache file
	syscmd("cat > "+cFile,@cData,@out,@err)
return .t.
/*************************************/
static function HTTP_sendCgi(self,file,cmd,url,postData)
	local i,j,n,head:="",data,ret
	local out:=space(0), err:=space(0)
	local path:=""
	if !file(file)
		self:sendError(HTTP_ERR_FILENOTFOUND,file)
		return .f.
	endif

	i := atr("/",file)
	if i>0
		path := left(file,i)
	endif

	//aadd(self:sets,{"AUTH_TYPE",""})
	//aadd(self:sets,{"CONTENT_LENGTH",""})
	//aadd(self:sets,{"CONTENT_TYPE",""})
	//aadd(self:sets,{"PATH_INFO",""})
	//aadd(self:sets,{"PATH_TRANSLATED",""})
	//aadd(self:sets,{"REMOTE_IDENT",""})
	//aadd(self:sets,{"REMOTE_USER",""})

	cmd=strtran(cmd,"(","\(")
	cmd=strtran(cmd,")","\)")
	aadd(self:sets,{"GATEWAY_INTERFACE","CGI/1.1"})
	aadd(self:sets,{"QUERY_STRING",cmd})
	aadd(self:sets,{"SCRIPT_NAME","/cgi-bin"+url})
	aadd(self:sets,{"SCRIPT_FILENAME",file})

	if (ret:=syscmd(file+iif(fileIsScript(url)," "+cmd,""),@postData,@out,@err,self:sets,path)) != 0 .and. !empty(err)
		outlog("cgi-bin error:",file,cmd,err,ret)
		self:sendError(HTTP_ERR_INTERNALSERVERERROR,file+"?"+cmd+"<BR>"+err)
		return .f.
	endif
	self:sendAnswer("200 OK","",@out,ascDateTime(),,-1)
return .t.

/*************************************/
static function HTTP_runCommand(self,file)
	local i,header,peerAddr,peerName,peerPort
	local data:=""
	local crlf := chr(13)+chr(10)

	tcpGetPeerName(self:nConnect, @peerAddr,@peerPort)
	peerName := GetHostByAddr(peerAddr)
	aadd(self:sets,{"REMOTE_HOST",peerName})
	aadd(self:sets,{"REMOTE_ADDR",peerAddr})
	aadd(self:sets,{"REMOTE_PORT",alltrim(str(peerPort))})

	/* data by POST command */
	i := at(crlf+crlf,self:cLine)
	if i!=0
		data:=substr(self:cLine,i+4)
		self:cLine :=left(self:cLine,i+3)
	endif

	i := at(" ",self:cLine)
	//outlog(__FILE__,__LINE__,self:cLine)
	if i<=0
		i := len(self:cLine)+1
	endif
	self:command := upper(left(self:cLine,i-1))
	self:cLine := alltrim(substr(self:cLine,i+1))
	*****
	i := at(chr(13)+chr(10),self:cLine)
	if i!=0
		header :=left(self:cLine,i-1)
		self:cLine:=substr(self:cLine,i+2)
	else
		header := self:cLine
	endif
	self:parseHeader()
	if self:command $ "GET POST"
		self:checkVhost()
	endif
	aadd(self:sets,{"SERVER_ADMIN",self:admin})
	aadd(self:sets,{"DOCUMENT_ROOT",self:DocRoot})
	*****
	if self:command $ "GET POST"
		self:runGet(Header,@data)
	else
		//self:send(space(400)+chr(13)+chr(10)+chr(13)+chr(10))
		self:sendError(HTTP_ERR_NOTIMPLEEMENTED,self:command)
	endif

	self:close()
return .t.
/*************************************/
static function HTTP_parseHeader(self)
	local lExit := .f.,cLine:=self:cLine
	local i,j,s,s1,s2,m:={}
	while !lExit
		i := at(chr(13)+chr(10),cLine)
		if i<=0
			i := len(cLine)+2
			lExit := .t.
		endif
		s := left(cLine,i-1)
		cLine := substr(cLine,i+2)
		j := at(":",s)
		if j<=0
			loop
		endif
		s1 := upper(left(s,j-1))
		s1 := "HTTP_"+strtran(s1,"-","_")
		s2 := alltrim(substr(s,j+1))
		aadd(self:sets,{s1,s2})
	enddo
	self:cLine := ""
return
/*************************************/
static function HTTP_runGet(self,cLine,postData)
	local i,j, url, _url, cmd:="", ver, file, flag,m
	local alias:="",path:=""
	outlog(__FILE__,__LINE__,self:command,cLine)
	i := at(" HTTP/",cLine)
	if i<=0
		self:sendError(HTTP_ERR_BADREQUEST,"HTTP/1.x not detected")
		return
	endif
	ver := val(substr(cLine,i+6))
	//outlog(__FILE__,__LINE__,ver)
	if ver < 1.0 .or. ver > 1.1
		self:sendError(HTTP_ERR_BADVERSION,ver)
		return
	endif
	url := alltrim(left(cLine,i))

	aadd(self:sets,{"REQUEST_METHOD",self:command})
	aadd(self:sets,{"REQUEST_URI",url})
	aadd(self:sets,{"UNIQUE_ID","CLIP"+ntoc(random(),32,10,"0")})
	if len(postData) > 0
		aadd(self:sets,{"CONTENT_LENGTH",alltrim(str(len(postData)))})
	endif

	//outlog(__FILE__,__LINE__,url)
	i:=at("?",url)
	if i > 0
		cmd := substr(url,i+1)
		url := substr(url,1,i-1)
	endif
	for i=1 to len(self:aliases)
		j := self:aliases[i][1]
		if left(url,len(j)) == j
			alias := j
			path  := self:aliases[i][2]
			exit
		endif
	next
	//outlog(__FILE__,__LINE__,alias)
	if ! empty(alias) //left(url,7) == "/icons/" .and. !empty(self:icons)
		set(_SET_ROOTPATH,path)
		url := substr(url,len(alias))
		file := makepath(url)
		if file(file)
			self:sendFile(url)
		else
			self:sendError(HTTP_ERR_FILENOTFOUND,url)
		endif
	elseif left(url,9) == "/cgi-bin/"
		url := substr(url,9)
		set(_SET_ROOTPATH,self:cgiBin)
		file := makepath(url)
		if file(file)
			self:sendCgi(file,cmd,url,@postData)
		else
			self:sendError(HTTP_ERR_FILENOTFOUND,url)
		endif
	elseif left(url,10) == "/mod-clip/"
		url := substr(url,10)
	//outlog(__FILE__,__LINE__,url,cmd,postdata)
		self:runModClip(url,cmd,@postData)
	else
		set(_SET_ROOTPATH,self:DocRoot)
		flag := .f.
		m := {"","/index.html","/index.htm","/index.shtml"}
		for i =1 to len(m)
			_url := url+m[i]
			file := makepath(_url)
	//outlog(__FILE__,__LINE__,_url,file,file(file))
			if !file(file)
				loop
			endif
	//outlog(__FILE__,__LINE__,"send",_url)
			self:sendFile(_url)
			flag := .t.
			exit
		next
		if !flag
			i := directory(url+"/*","D")
			if len(i)>2
				self:sendDir(url,cmd,i)
				flag := .t.
			endif
		endif
		if !flag
			self:sendError(HTTP_ERR_FILENOTFOUND,url)
		endif
	endif
return
/*************************************/
static function HTTP_sendDir(self,url,cmd,m)
	local i,x,y,ext,mime,icon
	local maxlen:=17,prevDir
	local crlf := chr(13)+chr(10)
	local data := crlf

	data += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"'+crlf
	data += '"http://www.w3.org/TR/REC-html40/loose.dtd">'+crlf
	data += '<html><head><title>Index of '+url+'</title></head>'+crlf
	data += '<body bgcolor="#ffffff" text="#000000">'+crlf
	data += '<table><tr><td bgcolor="#ffffff" class="title">'+crlf
	data += '<font size="+3" face="Helvetica,Arial,sans-serif">'+crlf
	data += '<b>Index of '+url+'</b></font>'+crlf

	data += '</td></tr></table>'+crlf

	for i=1 to len(m)
		maxlen := max(maxlen,len(m[i][1]))
	next
	if cmd == "N=D"
		asort(m,,,{|x,y|x[1]<=y[1]})
	elseif cmd == "M=A"
		asort(m,,,{|x,y|dtos(x[3])+x[4]<=dtos(y[3])+y[4]})
	elseif cmd == "S=A"
		asort(m,,,{|x,y|x[5]=="D" .or. x[2]<=y[2]})
	endif

	data += '<pre><img border="0" src="/icons/blank.gif" ALT="[INFO]">'
	data += '<a href="?N=D">Name</a>'+space(maxlen-3)
	data += '<a href="?M=A">Last modified</a>            '
	data += '<a href="?S=A">Size</a>  <a href="?D=A">Description</a>'+crlf
	data += '<hr noshade align="left" width="80%">'+crlf
	*
	url := strtran(url,"//","/")
	if len(url)>1 .and. right(url,1) == "/"
		url := left(url,len(url)-1)
	endif
	i := atr("/",url)
	if i>0
		prevdir := left(url,i)
	else
		prevDir := "/"
	endif
	data += '<img border="0" src="/icons/back.gif" alt="[DIR]"> '
	data += '<a href="'+prevdir+'">Parent Directory</a>'+space(maxlen-15)
	i := ascan(m,{|x|x[1]==".."})
	if i>0
		data += ascDateTime(m[i][3],m[i][4],2)+'     -'+crlf
	else
		data += ascDateTime(,,,2)+'     -'+crlf
	endif
	for i=1 to len(m)
		if m[i][1]=="." .or. m[i][1]==".."
			loop
		endif
		x := atr(".",m[i][1])
		ext := upper(iif(x>0, substr(m[i][1],x+1),""))
		if ext $ self:fileicons
			icon := self:fileicons[ext]
		else
			mime = mimeTypeGet(ext)
			x := at("/",mime)
			ext := upper(iif(x>0, left(mime,x-1),""))
			if ext $ self:mimeicons
				icon := self:mimeicons[ext]
			else
				icon := "unknown.gif"
			endif
		endif
		data += '<img border="0" src="/icons/'
		if m[i][5] == "D"
			data+='folder.gif" alt="[DIR ]"> '
		else
			data+=icon+'" alt="['+padr(ext,4)+']"> '
		endif
		data += '<a href="'+url+'/'+m[i][1]+'">'+m[i][1]+'</a>'+space(maxlen-len(m[i][1]))
		data += ascDateTime(m[i][3],m[i][4],2)
		data += str(m[i][2]/1000,6,0)+"K"
		data += crlf
	next
	data += '</pre><hr noshade align="left" width="80%">'+crlf
	data +='<ADDRESS> '+self:serverSign+'</ADDRESS>'+crlf
	data += '</body></html>'+crlf
	//self:sendAnswer("200 OK","text/html",@data,ascDateTime())
	self:sendAnswer("200 OK","text/html",@data,,,-1)

/*************************************/
static function HTTP_sendFile(self,file)
	local i,ext,data,crlf:=chr(13)+chr(10)
	i := makePath(file)
	if file(i)
		data:=memoread(file)
	else
		self:sendError(HTTP_ERR_FILENOTFOUND,file)
		return .f.
	endif
	if empty(data) .and. !empty(ferror())
		data := crlf+"Can`t load data from "+file+", error:"+ferrorstr()
		self:sendAnswer("200 OK","text/plain",@data,"",,-1)
	else
		data := crlf+data
		i := atr(".",file)
		ext := substr(file,i+1)
		i := ascan(self:ssi,ext)
		if i>0
			data := self:runSSI(data)
		endif
		i := directory(file)
		self:sendAnswer("200 OK",mimeTypeGet(ext),@data,ascDateTime(i[1][3],i[1][4]),,len(data)-2)
	endif
return .t.
/*************************************/
static function HTTP_runSSI(self,data)
	local i,j,beg,inc,end:="",s,s1,s2
	local url,file
	s := data
/*
<!--#include virtual="/top.inc"-->
*/

	while (i := at("<!--#include ",s)) > 0
		beg := left(s,i-1)
		s := substr(s,i+13)
		i := at("-->",s)
		if i<=0
			i := len(s)+1
		endif
		end := substr(s,i+3)
		***
		inc := ""
		s1 := left(s,i-1)
		i := at("virtual=",s1)
		if i<=0
			s := beg+" Bad 'include' format. "+end
			loop
		endif
		s1 := substr(s1,i+9)
		url := strtran(s1,'"','')
		file := makePath(url)
		if !file(file)
			s := beg+' Included URL '+url+' not found. '+end
			loop
		endif
		inc := memoread(url)
		***
		s := beg+inc+end
	enddo
return s

/*****************************************/
static function HTTP_ErrorBlock(self,err)
	local i,s:="",data:="", crlf:=chr(13)+chr(10)
	i := 1
	s+="Run Time Error in HTTP-service:"+crlf
	while ( !Empty(ProcName(i)) )
		s += "Called from "+allTrim(ProcName(i)) + ;
			"(" + str(ProcLine(i)) + ")"+crlf

		i++
	end
	s += errorMessage(err)
	outlog(s)
	self:sendError(HTTP_ERR_INTERNALSERVERERROR,s)
return

/*****************************************/
static function HTTP_defSets(self)
	self:hostname	:= getHostName()+"."+getDomainName()
	self:serverSoft	:= 'Kamache/'+alltrim(str(KAMACHE_VERSION))
	self:serverSign	:= self:serverSoft+' Server at '+self:hostname+' Port '+;
				alltrim(str(self:nPort))

	aadd(self:sets,{"SERVER_PROTOCOL","HTTP/1.1"})
	aadd(self:sets,{"HTTP_CONNECTION","Keep-Alive"})
	aadd(self:sets,{"SERVER_NAME",self:hostname})
	aadd(self:sets,{"SERVER_SOFTWARE",self:serverSoft})
	aadd(self:sets,{"SERVER_SIGNATURE",self:serverSign})
	aadd(self:sets,{"SERVER_PORT",alltrim(str(self:nPort))})
	aadd(self:sets,{"SERVER_ADDR",getHostByName(self:hostname)})
	//aadd(self:sets,{"HTTP_HOST",self:hostname})

return

/*****************************************/
static function HTTP_checkVhost(self)
	local i,j,x,s,s1,s2,host,sections,found := .f.
	i := ascan(self:sets,{|x|x[1]=="HTTP_HOST"})
	if i<=0
		return
	endif
	host := self:sets[i][2]
	i := atr(":",host)
	if i>0
		host := left(host,i-1)
	endif
	s2 := self:oIni:checkName(host)
	sections := self:oIni:sections()
	for i=1 to len(sections)
		s := sections[i]
		if !(left(s,12) == "HTTP_VIRTUAL")
			loop
		endif
		s1 := substr(s,14)
		if s2 == s1
			found := .t.
			exit
		endif
	next
	if found
		self:fromIni(self:oIni,s)
	endif
return
	/* install values from ini-file */
/*****************************************/
static function HTTP_fromIni(obj,oIni,vHost)
	local tmp,i,j,a,b,allKeys,_vHost
	if valtype(oIni)=="O" .and. oIni:className == "INIFILE"
	else
		return
	endif
	if empty(vHost)
		_vHost := "HTTP"
	else
		_vHost := vHost
	endif
	tmp = oIni:getValue(_vHost,"ADMIN")
	if !empty(tmp)
		obj:admin := tmp
	endif
	tmp = oIni:getValue(_vHost,"DOCROOT")
	if !empty(tmp)
		tmp := strtran(tmp,"$CLIPROOT",cliproot())
		obj:DocRoot := tmp
	endif
	tmp = oIni:getValue(_vHost,"CGI-BIN")
	if !empty(tmp)
		tmp := strtran(tmp,"$CLIPROOT",cliproot())
		obj:cgiBin := tmp
	endif
	tmp = oIni:getValue(_vHost,"MOD-CLIP")
	if !empty(tmp)
		tmp := strtran(tmp,"$CLIPROOT",cliproot())
		obj:modClip := tmp
	endif
	tmp = oIni:getValue(_vHost,"MOD-CACHE")
	if !empty(tmp)
		tmp := strtran(tmp,"$CLIPROOT",cliproot())
		obj:modCache := tmp
	endif
	if !empty(vHost)
		return
	endif
	tmp := oIni:getValue("HTTP","DATEFORMAT")
	if !empty(tmp)
		obj:dateFormat := tmp
	endif
	tmp := oIni:getValue("HTTP","SSI")
	if !empty(tmp)
		if valtype(tmp)=="C"
			tmp := split(tmp,"[ \t]")
		endif
		if valtype(tmp)=="A"
			obj:ssi := aclone(tmp)
		endif
	endif
	tmp := oIni:getValue("HTTP","REQUESTTIMEOUT")
	if valtype(tmp) == "N"
		obj:nIoTimeOut := tmp
	endif
	tmp := oIni:getValue("FILE-EXT-ICONS")
	if !empty(tmp)
		for i in tmp keys
			obj:fileicons[i] := tmp[i]
		next
	endif
	tmp := oIni:getValue("MIME-TYPE-ICONS")
	if !empty(tmp)
		for i in tmp keys
			obj:mimeicons[i] := tmp[i]
		next
	endif
	allkeys := oIni:getValue("HTTP-ALIASES")
	for i in allkeys
		if empty(i)
			loop
		endif
		j := at("->",i)
		if j <= 0
			loop
		endif
		a := alltrim(left(i,j-1))
		b := alltrim(substr(i,j+3))
		if empty(a) .or. empty(b)
			loop
		endif
		if !(right(a,1) =="/")
			a += "/"
		endif
		if !(right(b,1) =="/")
			b += "/"
		endif
		aadd(obj:aliases,{a,b})
	next
return

