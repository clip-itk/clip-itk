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
	obj:new		:= @smtp_new()
return obj
****************************************************************
function smtpNew(host)
	local obj:=map()

	obj:classname	:= "SMTP"
	obj:host	:= iif(host==NIL,"localhost",host)
        obj:timeout	:= 6000
        obj:handle	:= NIL
        obj:error	:= ""

	obj:new		:= @smtp_new()
        obj:open	:= @smtp_connect()
        obj:connect	:= @smtp_connect()
        obj:noop	:= @smtp_noop()
        obj:send	:= @smtp_send()
        obj:sendMail	:= @smtp_send()
        obj:close	:= @smtp_destroy()
        obj:destroy	:= @smtp_destroy()
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
static function smtp_send(sFrom,sTo,sData)
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
        if !empty(sData)
        	ret:=tcpwrite(::handle,"DATA&\n"+sData,,::timeout)
        	if (ret:=tcpread(::handle,@buf,BUF_LEN,::timeout))<=0 .or. val(buf)>=500
                	::error:=substr(buf,1,ret)
                        return .f.
                endif
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
