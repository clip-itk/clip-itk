/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

*********************************************
function htmlParserNew()
	local obj:=map()
	obj:buffer	:= ""
	obj:tags	:= {}
	obj:put		:= @hp_put()
	obj:getTag	:= @hp_get()
	obj:get		:= @hp_get()
	obj:end		:= @hp_end()
	obj:empty	:= @hp_empty()
	obj:__parseBuf	:= @hp_parse()
	obj:__addText	:= @hp_text()
	obj:__parseTag	:= @hp_parseTag()
return obj

*********************************************
static function hp_empty()
return len(::tags)==0

*********************************************
static function hp_put(s)
	::buffer+=s
	::__parseBuf()
return .t.

*********************************************
static function hp_end(s)
	if !empty(s)
		::buffer+=s
	endif
	::__parseBuf()
	if !empty(::buffer)
		aadd(::tags,::buffer)
		::buffer:=""
	endif
return .t.

*********************************************
static function hp_get(s)
	local ret:=NIL
	if !empty(::tags)
		ret:=::tags[1]
		adel(::tags,1)
		asize(::tags,len(::tags)-1 )
	endif
return ret

*********************************************
static function hp_text(s)
       local i
       s=strtran(s,"&\r","")
       if substr(s,1,8) == '<![CDATA'
       		aadd(::tags,s)
		return .t.
       endif
       while .t.
		i=at("&\n",s)
		if i>0
			if i>1
			   aadd(::tags,substr(s,1,i-1) )
			endif
			aadd(::tags,NIL)
			s=substr(s,i+1)
		else
			aadd(::tags,s)
			exit
		endif
       enddo
return .t.

*********************************************
static function hp_parse
       local tbeg,tend,s,ch,c:=0,f1:=.f.,sch:='"'
       while .t.
	     tbeg=at("<",::buffer)
	     if tbeg>1
		::__addText(substr(::buffer,1,tbeg-1))
		::buffer:=substr(::buffer,tbeg)
		tbeg:=1
	     endif
	     // Check for DOCTYPE or CDATA
	     if substr(::buffer,tbeg+1,8) == '!DOCTYPE' .or. substr(::buffer,tbeg+1,7) == '![CDATA'
		tend:=at("]>",::buffer)
		if tend>0
			// Put as text without interpretation
			::__addText(substr(::buffer,1,tend+1))
	        	::buffer:=substr(::buffer,tend+2)
			loop
		else
			// Missed end: wait for next portion
			exit
		endif
	     endif
	     for tend=tbeg to len(::buffer)
		ch=substr(::buffer,tend,1)
		if !f1 .and. (ch=="'" .or. ch=='"')
			f1:=.t.
			sch:=ch
			loop
		endif
		if f1 .and. ch==sch
			f1:=.f.
			loop
		endif
		if !f1 .and. ch=="<"
			c++
		endif
		if !f1 .and. ch==">"
			c--
		endif
		if c==0
			exit
		endif
	     next
	     if tend>=len(::buffer) .and. ch!=">"
		tend:=0
	     endif
	     //tend=at(">",::buffer)
	     if tbeg<=0 .or. tend<=0
		exit
	     endif

	     ::__parseTag(substr(::buffer,tbeg+1,tend-tbeg-1) )
	     ::buffer:=substr(::buffer,tend+1)
       enddo
return .t.

*********************************************
static function hp_parseTag(str)
	local i,i1,i2,i3,t,fname:="",fdata:=""
	local f1:=.t.,f2:=.f.,f3:=.f.,ch,sch:='"'
	str:=alltrim(str)
	str:=strtran(str,"&\t"," ")
	str:=strtran(str,"&\r","")
	//str:=strtran(str,"&\n"," ")
	if left(str,1)=="!"
		for i=2 to len(str)
			if !(substr(str,i,1)=="-")
				exit
			endif
		next
		str:=substr(str,i)
		for i=len(str) to 1 step -1
			if !(substr(str,i,1)=="-")
				exit
			endif
		next
		str:=substr(str,1,i)
		t=html_tagNew("!")
		t:addField("DATA",str)
		return .t.
	endif
	i:=1
	ch := substr(str,i,1)
	while (isalpha(ch) .or. ch $ "?/_1234567890") .and. !(ch $ " &\t&\n")
		i++
		ch := substr(str,i,1)
	enddo
	if i==0
		i:=len(str)+1
	endif
	t=html_tagNew(substr(str,1,i-1))
	if substr(str,len(str),1) == "/"
		t:closed := .t.
	endif
	str=alltrim(substr(str,i+1))
	while !empty(str)
		ch:=left(str,1)
		str:=substr(str,2)
		if f1 .and. ch $ " &\n"
			loop
		endif
		if ch="=" .and. !f3
			f1:=.f.
			f2:=.t.
			while .t.
				ch:=left(str,1)
				if ch $ " &\n"
					str:=substr(str,2)
				else
					exit
				endif
			enddo
			loop
		endif
		if (ch=='"' .or. ch=="'") .and. !f3
			f3:=.t.
			sch:=ch
			loop
		endif
		if ch==sch .and. f3
			f3:=.f.
			loop
		endif
		if ch=="/" .and. !f3
			loop
		endif
		if (ch $ " &\n" .or. ch=="/") .and. !f3
			f2:=.f.
			f1:=.t.
			t:addField(fname,fdata)
			fname:=""
			fdata:=""
			if ch=="/"
				exit
			else
				loop
			endif
		endif
		if f1
		   fname+=ch
		endif
		if f2
		   fdata+=ch
		endif
	enddo
	if !empty(fname) .or. !empty(fdata)
		t:addField(fname,fdata)
	endif
	aadd(::tags,t)
return .t.

