/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "fileio.ch"
#include "clipcfg.h"

*************************************************
function urlNew(prot,host,path,file,params,anchor,port,user,password)
	local obj:=map(),fill:=.f.

	if valType(prot)=="O"
		if prot:classname=="URL"
			obj:protocol	:= prot:protocol
			obj:host	:= prot:host
			obj:path	:= prot:path
			obj:file	:= prot:file
			obj:port	:= prot:port
			obj:user	:= prot:user
			obj:password	:= prot:password
			obj:params	:= prot:params
			obj:anchor	:= prot:anchor
		else
			obj:protocol	:= "http"
		endif
		fill:=.t.
	else
		obj:protocol	:= iif(prot==NIL, "http", prot )
	endif

	if !fill
		obj:host	:= iif(host==NIL, "",host )
		obj:path	:= iif(path==NIL, "", path )
		obj:file	:= iif(file==NIL, "index.html", file )
		obj:port	:= port
		obj:user	:= user
		obj:password	:= password
		obj:params	:= params
		obj:anchor	:= anchor
	endif

	obj:classname	:= "URL"
	obj:start	:= seconds()
	obj:stop	:= seconds()
	obj:pos		:= 0
	obj:status	:= ""
	obj:messages	:= ""
	obj:length	:= 0
	obj:ready	:= 0
	obj:__wget	:= NIL
	obj:__eof	:= .f.
	obj:__dEof	:= .f.
	obj:__fEof	:= .f.

	obj:parseUrl	:= @url_parseUrl()
	obj:makeUrl	:= @url_makeUrl()

	/* metods for read process from network */
	obj:open	:= @url_open()
	obj:close	:= @url_close()
	obj:eof		:= @url_eof()  // end of process reading file from network
	obj:kick	:= @url_kick()

	/* metods for read process from result file */
	obj:goTop	:= @url_goTop()
	obj:read	:= @url_read()
	obj:readStr	:= @url_readStr()
	obj:getStr	:= @url_getStr()
	obj:dataEof	:= @url_dataEof() // end of file with data
	obj:fileEof	:= @url_fileEof() // end of file with data in current
					//  state of process reading from network

	obj:destroy	:= @url_close()

return obj

*************************************************
static function url_open()
	local i,j:=1,s

	::__eof	:= .f.
	::__dEof:= .f.
	::__fEof:= .f.

	::start := seconds()
	if lower(::protocol)=="file"
		::filename=::path+"/"+::file
		::status:="read local file"
		::__eof:=.t.
		i:=fopen(::fileName)
		::ready:=flength(i)
		::length:=::ready
		fclose(i)
		return i>=0
	endif
	::fileName := getenv("HOME")+"/.clip/cache.web/"+::protocol+"/"+::host+::path+"/"+::file
	while ( i:=at("/",::fileName,j) )>0
		s=substr(::filename,1,i-1)
		dirMake(s)
		j++
	enddo
#ifndef WGET_PRG
	outlog(__FILE__, __LINE__, "program wget not installed")
	return .f.
#endif
	s= WGET_PRG+" -c -v -s -O "+::fileName+" "
	s+=::makeUrl(.f.)
	::__wget:=fopen(s+" |",FO_READ)
	if ferror()!=0 .or. ::__wget<0
		return .f.
	endif
return .t.
*************************************************
static function url_kick()
	local i
	if ::__wget==NIL .or. lower(::protocol)=="file"
		return .f.
	endif
	::messages+=freadstr(::__wget,10000)
	::__eof := fileeof(::__wget)
	i=at("length:",lower(::messages))
	if ::length==0 .and. i>0 .and. i<len(::messages)-25
		::length:=val(strtran(substr(::messages,i+8,12),",",""))
	endif
	i:=rat("&\n",::messages)
	::status:=substr(::messages,i+1)
	i:=fopen(::fileName)
	::ready:=flength(i)
	fclose(i)
	if "0K -> " $ ::status
		::status:="reading "+alltrim(str(::ready))+" of "+alltrim(str(::length))+" bytes"
	endif
return .t.

*************************************************
static function url_read(buf,nbytes)
	local i,ret
	i:=fopen(::fileName,FO_READ)
	fseek(i,::pos,FS_SET)
	ret := fread(i,@buf,nbytes)
	::__feof := fileEof(i)
	::__dEof := (::__eof .and. ::__feof )
	::pos=fseek(i,0,FS_RELATIVE)
	fclose(i)
return ret

*************************************************
static function url_readStr(nbytes)
	local i,ret
	i:=fopen(::fileName,FO_READ)
	fseek(i,::pos,FS_SET)
	ret := freadstr(i,nbytes)
	::__feof := fileEof(i)
	::__dEof := (::__eof .and. ::__feof )
	::pos=fseek(i,0,FS_RELATIVE)
	fclose(i)
return ret

*************************************************
static function url_getStr(nbytes)
	local i,ret
	i:=fopen(::fileName,FO_READ)
	fseek(i,::pos,FS_SET)
	ret := filegetstr(i,nbytes)
	::__feof := fileEof(i)
	::__dEof := (::__eof .and. ::__feof )
	::pos=fseek(i,0,FS_RELATIVE)
	fclose(i)
return ret

*************************************************
static function url_close()
	::stop:=seconds()
	if ::__wget==NIL .or. lower(::protocol)=="file"
		return .f.
	endif
	fclose(::__wget)
	::__wget:= NIL
	outlog(3,getenv("USER"),"open url:",::makeUrl(), "read",::length,"bytes in",::stop-::start,"seconds")
return .t.

*************************************************
static function url_eof()
return ::__eof

*************************************************
static function url_dataEof()
return ::__dEof

*************************************************
static function url_fileEof()
return ::__fEof

*************************************************
static function url_goTop()
return ::pos:=0

*************************************************
static function url_makeUrl(full)
	local ret:="",user:=.f., i
	full := iif(full==NIL, .t., full)
	ret+=::protocol+":"
	if ::port!=NIL
		ret+=alltrim(str(::port,4,0))
	endif
	if ::user!=NIL .and. ::password!=NIL
		ret+="//"+::user+":"+::password+"@"
		user:=.t.
	endif
	if !empty(::host)
		if user
			ret+=::host
		else
			ret+="//"+::host
		endif
	endif
	ret+=::path+"/"+::file
	if full .and. ::params!=NIL
		ret+="?"+::params
	endif
	if full .and. ::anchor!=NIL
		i := at("#", ret)
		if i>0
			ret:=substr(ret, 1, i-1)
		endif
		ret+="#"+::anchor
	endif
return ret

*************************************************
static function url_parseUrl(sUrl)
	local i,j,k,s
	sUrl:=alltrim(sUrl)
	sUrl:=strtran(sUrl,"//","/")
	i:=at("@",sUrl)
	i:=at("#",sUrl)
	if i>0   // URL anchor
		::anchor:=substr(sUrl,i+1)
		sUrl:=substr(sUrl,1,i-1)
	else
		::anchor:=NIL
	endif

	i:=at("?",sUrl)
	if i>0   // URL parameters
		::params:=substr(sUrl,i+1)
		sUrl:=substr(sUrl,1,i-1)
	else
		::params:=NIL
	endif
	if i>0			 //  user and password
	   j:=at("/",sUrl)
	   s=substr(sUrl,1,j-1)
	   if i>j .and. !empty(s)          // protocol and port
		k=at(":",s)
		k=iif(k>0,k,len(s)+1)
		::protocol:=substr(s,1,k-1)
		if len(s)-k>1	// port
			::port:=val(substr(s,k+1))
		endif
	   endif
	   sUrl:=substr(sUrl,j+1)
	   i:=at("@",sUrl)
	   s=substr(sUrl,1,i-1)
	   if !empty(s)          // user and password
		k=at(":",s)
		k=iif(k>0,k,len(s)+1)
		::user:=substr(s,1,k-1)
		::password:=substr(s,k+1)
	   endif
	   sUrl:=substr(sUrl,i+1)
	endif
	i:=at(":",sUrl)
	if i>0
		::protocol:=substr(sUrl,1,i-1)
		sUrl:=substr(sUrl,i+1)
	endif
	if !(lower(::protocol)=="file")
		i:=at("/",sUrl)
		if i==1
			sUrl:=substr(sUrl,2)
		endif
		i:=at("/",sUrl)
		if i>0
			::host:=substr(sUrl,1,i-1)
			sUrl:=substr(sUrl,i)
		else
			if !empty(sUrl)
				::host:=sUrl
			endif
			return .t.
		endif
	endif
	i=rat("/",sUrl)
	if i>2
		::path:=substr(sUrl,1,i-1)
		if i!=len(sUrl)
			if !empty(sUrl)
				::file:=substr(sUrl,i+1)
			endif
		endif
	else
		if lower(::protocol)=="file"
			::path:=currdrive()+"/"+curdir()
		endif
		if !empty(sUrl)
			::file:=substr(sUrl,i+1)
		endif
	endif
return .t.

