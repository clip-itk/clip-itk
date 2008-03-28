/*
	Copyright (C) 2001  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html

	class SMTP - send mail transport protocol
*/

#define BUF_LEN 1000

****************************************************************
function smtp()
	local obj:=map()
	obj:new := @smtp_new()
return obj
****************************************************************
function smtpNew(host)
	local obj:=map()

	obj:classname   := "SMTP"
	obj:host        := iif(host==NIL,"localhost",host)
	obj:timeout     := 6000
	obj:handle      := NIL
	obj:error       := ""
	obj:fields      := {}
	obj:attachments := {}

	obj:new      := @smtp_new()
	obj:open     := @smtp_connect()
	obj:connect  := @smtp_connect()
	obj:noop     := @smtp_noop()
	obj:hello    := @smtp_hello()
	obj:helo     := @smtp_hello()
	obj:addField := @smtp_addfield()
	obj:attach   := @smtp_attach()
	obj:send     := @smtp_send()
	obj:sendMail := @smtp_send()
	obj:reset    := @smtp_reset()
	obj:rset     := @smtp_reset()
	obj:close    := @smtp_destroy()
	obj:destroy  := @smtp_destroy()
return obj
****************************************************************
static function smtp_new(self,host)
	return smtpNew(host)
****************************************************************
static function smtp_destroy()
	if ::handle != NIL
		tcpwrite(::handle,"QUIT&\n",,::timeout)
		tcpclose(::handle)
		::handle := NIL
	endif
	if ferror()!=0
		::error := ferrorstr()
	endif
return ferror() == 0
****************************************************************
static function smtp_connect()
	local ret,buf:=space(BUF_LEN)
	::handle := tcpconnect(::host,25,::timeout)
	if ::handle < 0 .or. ferror()!=0
		::error := ferrorstr()
		::handle := NIL
		return .f.
	endif
	/* read prompt from server */
	ret:=tcpread(::handle,@buf,BUF_LEN,::timeout)
	if ret<=0 .or. ferror()!=0
		tcpclose(::handle)
		return .f.
	endif
	/* check connect with server */
	tcpwrite(::handle,"NOOP&\n",,::timeout)
	if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
		::error := ferrorstr()+" "+substr(buf,1,ret)
		tcpclose(::handle)
		return .f.
	endif
return .t.
****************************************************************
static function smtp_addField(sName,sData)
	if valtype(sName)!="C" .or. valtype(sData)!="C"
		return .f.
	endif
	aadd(::fields,{sName,sData})
return .t.
****************************************************************
static function smtp_attach(sFile)
	if valtype(sFile)!="C"
		return .f.
	endif
	aadd(::attachments,sFile)
return .t.
****************************************************************
static function smtp_hello(sData)
	local ret,buf := space(BUF_LEN)
	::error:=""
	if ::handle==NIL
		::error:=[Connect not activated]
		return .f.
	endif
	if !empty(sData)
		ret:=tcpwrite(::handle,"HELO "+sData+"&\n",,::timeout)
		if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
			::error:=substr(buf,1,ret)
			return .f.
		endif
	endif
return .t.
****************************************************************
static function smtp_send(sFrom,sTo,sData)
	local ret,i,buf := space(BUF_LEN)
	local fields := ""
	local content_type
	local boundary := "CLIP - Clipper compatible compiler"
	local fname,pos1,pos2,pos,ct
	local base64 := .t.

	::error:=""
	if ::handle==NIL
		::error:=[Connect not activated]
		return .f.
	endif
	fields += "From: "+sFrom+chr(10)
	fields += "To: "+sTo+chr(10)
	if empty(::attachments)
		content_type := "text/plain; charset="+host_charset()
	else
		fields += "MIME-Version: 1.0"+chr(10)
		content_type := 'multipart/mixed; boundary="'+boundary+'"'
		sData := "--"+boundary+chr(10);
			+"Content-Type: text/plain; charset="+host_charset()+chr(10);
			+"Content-Transfer-Encoding: 8bit"+chr(10)+chr(10)+sData+chr(10)
		for i=1 to len(::attachments)
			sData += "--"+boundary+chr(10)
			pos := rat(".",::attachments[i])
			if pos >0
				ct := mimeTypeGet(substr(::attachments[i],pos+1))
			endif
			if empty(ct)
				ct := "application/octet-stream"
			endif
			if upper(left(ct,5)) == "TEXT/"
				base64 := .f.
			endif
			sData += "Content-Type: "+ct+'; name="'
			pos1 := rat("/",::attachments[i])
			pos2 := rat("\",::attachments[i])
			pos := max(pos1,pos2)
			fname := substr(::attachments[i],pos+1)
			sData += fname+'"'+chr(10)
			sData += 'Content-Disposition: attachment; filename="'+fname+'"'+chr(10)
			if base64
				sData += "Content-Transfer-Encoding: base64"+chr(10)
			endif
			sData += chr(10)
			if base64
				//sData += base64encode(filestr(::attachments[i]))+chr(10)
				sData += base64encode(memoread(::attachments[i]))+chr(10)
			else
				//sData += filestr(::attachments[i])+chr(10)
				sData += memoread(::attachments[i])+chr(10)
			endif
		next
		sData += "--"+boundary+"--"+chr(10)
	endif
	fields += "Content-Type: "+content_type+chr(10)
	for i=1 to len(::fields)
		fields += ::fields[i][1]+": "+::fields[i][2]+chr(10)
	next
	if !empty(fields)
		fields+=chr(10)
	endif
	/* check connect with server */
	tcpwrite(::handle,"NOOP&\n",,::timeout)
	if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
		::error := ferrorstr()+" "+substr(buf,1,ret)
		tcpclose(::handle)
		return .f.
	endif
	if !empty(sFrom)
		ret:=tcpwrite(::handle,"MAIL FROM:"+sFrom+"&\n",,::timeout)
		if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
			::error:=substr(buf,1,ret)
			return .f.
		endif
	endif
	if !empty(sTo)
		ret:=tcpwrite(::handle,"RCPT TO:"+sTo+"&\n",,::timeout)
		if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
			::error:=substr(buf,1,ret)
			return .f.
		endif
	endif
	sData := fields+sData
	if !empty(sData)
		ret:=tcpwrite(::handle,"DATA&\n",,::timeout)
		if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
			::error:=substr(buf,1,ret)
			return .f.
		endif
		ret:=tcpwrite(::handle,sData,,::timeout)
	endif
	ret:=tcpwrite(::handle,"&\n.&\n",,::timeout)
	if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
		::error:=substr(buf,1,ret)
		return .f.
	endif
return .t.

****************************************************************
static function smtp_noop()
	local ret,buf := space(BUF_LEN)
	::error:=""
	if ::handle==NIL
		::error:=[Connect not activated]
		return .f.
	endif
	/* check connect with server */
	tcpwrite(::handle,"NOOP&\n",,::timeout)
	if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
		::error := ferrorstr()+" "+substr(buf,1,ret)
		tcpclose(::handle)
		return .f.
	endif
return .t.

static function smtp_reset()
	local ret,buf := space(BUF_LEN)

	::error:=""
	::fields := {}
	::attachments := {}
	if ::handle==NIL
		::error:=[Connect not activated]
		return .f.
	endif
	/* send RSET command to the server */
	tcpwrite(::handle,"RSET&\n",,::timeout)
	if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
		::error := ferrorstr()+" "+substr(buf,1,ret)
		tcpclose(::handle)
		return .f.
	endif
return .t.
