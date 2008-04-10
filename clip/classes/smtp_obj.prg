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
	obj:EOL     	:= "&\n"
	obj:LF     	:= CHR(10)
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
		tcpwrite(::handle,"QUIT"+::EOL,,::timeout)
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
	tcpwrite(::handle,"NOOP"+::EOL,,::timeout)
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
		ret:=tcpwrite(::handle,"HELO "+sData+::EOL,,::timeout)
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
	fields += "From: "+sFrom+::LF
	fields += "To: "+sTo+::LF
	if empty(::attachments)
		content_type := "text/plain; charset="+host_charset()
	else
		fields += "MIME-Version: 1.0"+::LF
		content_type := 'multipart/mixed; boundary="'+boundary+'"'
		sData := "--"+boundary+::LF;
			+"Content-Type: text/plain; charset="+host_charset()+::LF;
			+"Content-Transfer-Encoding: 8bit"+::LF+::LF+sData+::LF
		for i=1 to len(::attachments)
			sData += "--"+boundary+::LF
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
			sData += fname+'"'+::LF
			sData += 'Content-Disposition: attachment; filename="'+fname+'"'+::LF
			if base64
				sData += "Content-Transfer-Encoding: base64"+::LF
			endif
			sData += ::LF
			if base64
				//sData += base64encode(filestr(::attachments[i]))+::LF
				sData += base64encode(memoread(::attachments[i]))+::LF
			else
				//sData += filestr(::attachments[i])+::LF
				sData += memoread(::attachments[i])+::LF
			endif
		next
		sData += "--"+boundary+"--"+::LF
	endif
	fields += "Content-Type: "+content_type+::LF
	for i=1 to len(::fields)
		fields += ::fields[i][1]+": "+::fields[i][2]+::LF
	next
	if !empty(fields)
		fields+=::LF
	endif
	/* check connect with server */
	tcpwrite(::handle,"NOOP"+::EOL,,::timeout)
	if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
		::error := ferrorstr()+" "+substr(buf,1,ret)
		tcpclose(::handle)
		return .f.
	endif
	if !empty(sFrom)
		ret:=tcpwrite(::handle,"MAIL FROM:"+sFrom+""+::EOL,,::timeout)
		if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
			::error:=substr(buf,1,ret)
			return .f.
		endif
	endif
	if !empty(sTo)
		ret:=tcpwrite(::handle,"RCPT TO:"+sTo+""+::EOL,,::timeout)
		if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
			::error:=substr(buf,1,ret)
			return .f.
		endif
	endif
	sData := fields+sData
	if !empty(sData)
		ret:=tcpwrite(::handle,"DATA"+::EOL,,::timeout)
		if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
			::error:=substr(buf,1,ret)
			return .f.
		endif
        	ret:=tcpwrite(::handle,sData,,::timeout)
	endif
	ret:=tcpwrite(::handle,::EOL+"."+::EOL,,::timeout)
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
	tcpwrite(::handle,"NOOP"+::EOL,,::timeout)
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
	tcpwrite(::handle,"RSET"+::EOL,,::timeout)
	if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
		::error := ferrorstr()+" "+substr(buf,1,ret)
		tcpclose(::handle)
		return .f.
	endif
return .t.
