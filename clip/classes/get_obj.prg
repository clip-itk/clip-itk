//#define DEBUG

/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "set.ch"
#include "lang.ch"
#include "getexit.ch"
#include "date.ch"
#include "button.ch"
#include "config.ch"
#include "inkey.ch"
**********************************************************************
/* it`s function via clipper psevdo function __GET */

function ___get(bBlock,varname,cPic,bValid,bWhen)
return getnew(row(),col(),bBlock,varname,cPic,,eval(bBlock),bValid,bWhen)

**********************************************************************

function __GET__(xData,cName,cPic,bValid,bWhen)
	local block
        block:={|_1|local(_2:=@xData), iif(_1==NIL,_2,_2:=_1)}
return getnew(row(),col(),block,cName,cPic,,,bValid,bWhen)

**********************************************************************
function GETNEW(row,col,block,varname,pic,color,var,vblock,wblock)
  local obj,scr
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"getnew",varname)
#endif
  obj		:= map()
  obj:classname	:= "GET"
  obj:block	:= block

  obj:buffer	:= NIL
  obj:original	:= NIL
  obj:cargo  	:= NIL
  obj:changed	:= .f.
  obj:clear	:= .f.
  obj:col	:= iif(col==NIL,col(),col)
  obj:row	:= iif(row==NIL,row(),row)
  obj:colorSpec	:= iif(empty(color),setcolor(),color)
  obj:decpos	:= 0
  obj:exitState	:= GE_NOEXIT
  obj:hasFocus	:= .f.
  obj:minus	:= .f.
  obj:name	:= varname
  obj:picture	:= pic
  obj:control	:= NIL
  obj:pos	:= 1
  obj:cursorPos	:= 1
  obj:postBlock	:= vblock
  obj:preBlock	:= wblock
  obj:reader	:= NIL
  obj:rejected	:= .f.
  obj:subscript	:= NIL
  obj:type	:= "U"
  obj:caption	:= NIL
  obj:capRow	:= NIL
  obj:capCol	:= NIL
  obj:typeOut	:= .f.
  /* CLIP extension */
  obj:readOnly	:= .f.

  //this metods and attribute not exist in CA-Clipper
  obj:__oldReadVar:=""

  obj:__firstKey:= .f. 		   // pressed first key/metod
  obj:_original	:= NIL
  obj:__original:= NIL             // original in string mode
  obj:__len:=NIL                   // only for numeric type
  obj:__dec:=NIL
  obj:__dateFormat:= NIL           // original date format

  obj:__flags:=""                  // PICTURE functions
  obj:__format:=""                 // PICTURE format string
  obj:__dataSay:=""                // ! format symbols for "R"-function
  obj:__posArr:={}                 // array of position Gets symbols
  obj:__winLen:=0                  // S-function parameter

  obj:__first:=.t.
  obj:__colors:={}
  obj:__keys:=map()                // array for ::setkey()

  obj:winbuffer	:= nil

  _recover_get(obj)

  obj:setcolor()

  if block!=NIL
  	dispbegin()
        scr:=savescreen()
	obj:setFocus()
	obj:killFocus()
        restscreen(,,,,scr)
        dispend()
  endif

return obj

**********************************************
function _recover_get(obj)
  obj:badDate		:= @badDate()
  obj:assign 		:= @assign()
  obj:colorDisp 	:= @colorDisp()
  obj:display 		:= @display()
  obj:_display 		:= @_display()
  obj:killFocus 	:= @killFocus()
  obj:reload		:= @reload()
  obj:setFocus		:= @setFocus()
  obj:reset 		:= @reset()
  obj:undo 		:= @get_undo()
  obj:unTransform 	:= @unTransform()
  obj:updateBuffer 	:= @updateBuffer()
  //obj:updateBuffer 	:= @setFocus()
  obj:varGet 		:= @varGet()
  obj:varPut 		:= @varPut()
  obj:width 		:= @get_width()

  obj:end 		:= @cur_end()
  obj:home 		:= @cur_home()
  obj:left 		:= @cur_left()
  obj:right 		:= @cur_right()
  obj:gotoPos 		:= @cur_goto()
  obj:toDecPos 		:= @toDecPos()
  obj:wordLeft 		:= @wordLeft()
  obj:wordRight 	:= @wordRight()

  obj:backSpace    	:= @backSpace()
  obj:delLeft      	:= @backSpace()
  obj:delRight     	:= @delRight()
  obj:delete       	:= @delRight()
  obj:delEnd       	:= @delEnd()
  obj:delWordLeft  	:= @delWordLeft()
  obj:delWordRight 	:= @delWordRight()
  obj:hitTest 		:= @get_hitTest()
  obj:setcolor 		:= @get_setcolor()

  obj:Insert 		:= @Insert()
  obj:overStrike   	:= @overStrike()
  obj:__analizePic 	:= @__analizePic()   // analize PICTURE string
  obj:__fillBuffer 	:= @__fillBuffer()   // заполнитель буфера
  obj:__updateInfo 	:= @__updateInfo()   // читает вновь переменную и обновляет
					// служебную инфу
  obj:__checkSym   	:= @__checkSym()
  obj:__toString   	:= @__toString()
  obj:__toString   	:= @__toString()
  obj:setKey   		:= @__setKey()

  __set_default_keys(obj)

return obj

**********************************************
static function get_width()
return ::__winlen
**********************************************
static function get_hitTest(mrow,mcol)
	if ::row != mrow
		return HTNOWHERE
	endif
	if mcol >= ::col .and. mrow <= ::col+::__winlen
		return HTCLIENT
	endif
return HTNOWHERE
**********************************************
static function get_undo(self)
	eval(self:block,self:original)
	self:reset()
	self:__updateInfo()
   	self:__fillbuffer()
        self:_display()
return self


**********************************************
static func unTransform()
   local s ,i,j, s1,s2,s3,s4
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"untransform",::name)
#endif
    // buffer надо почистить от ненужных символов
    if "R" $ ::__flags .or. ::type!="C"
       s=""
       for i=1 to len(::__posArr)
	  s+=substr(::buffer,::__posArr[i],1)
       next
    else
       s:=::buffer
    endif
    do case
       case ::type=="C"
       case ::type=="D"
	    s1:=""
	    s4:=::__dateFormat
	    j:=1
	    for i=1 to len(s4)
		s2:=substr(s4,i,1)
		if s2 $ DATE_DELIMITER_CHARS
		    s1+=s2
		else
		    s1+=substr(s,j,1)
		    j++
		endif
	    next
	    s:=CTOD(s1,::__dateFormat)
       case ::type=="L"
	    s:=iif(left(s,1) $ ("Y"+LANG_YES_CHAR),.t.,.f.)
       case ::type=="M"
       case ::type=="N"
	    if ::decpos==0
		s:=val(s,len(s),0)
	    else
		j:=len(strtran(::__dataSay," ",""))
		//s:=substr(s,1,::decpos-j)+"."+substr(s,::decpos-j+1)
		s:=left(s,len(s)-::__dec)+"."+right(s,::__dec)
		s:=val(s,::__len,::__dec)
	    endif
       otherwise
	    s:=::_original
    endcase
return s

**********************************************
static function badDate()
   local d,s,s1,s2,s3,s4,i,j, ret:=.f.
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"baddate",::name)
#endif
   if ::buffer==NIL
	return .t.
   endif
   if ::type=="D"
      s:=""
      s4:=::__dateFormat
      j:=1
      for i=1 to len(s4)
	  s2:=substr(s4,i,1)
	  if s2 $ DATE_DELIMITER_CHARS
	      s+=s2
	  else
	      s+=substr(::__original,j,1)
	      j++
	  endif
      next
      d=ctod(s,::__dateFormat)
      ret=(d!=ctod(dtoc(d,::__dateFormat),::__dateformat))
   endif
   ::typeOut:=.f.
return ret

**********************************************
static func assign()
 local s,changed:=::changed
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"assign",::name)
#endif
   if ::block==NIL
	return NIL
   endif
 if ::type $ GETS_TYPES
    s:=::unTransForm()
    eval(::block,s)
    //::setFocus()
    ::updateBuffer()
    ::changed:=changed
 endif
return NIL

**********************************************
static func colorDisp (color)
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"colordisp",::name)
#endif
   if ::block==NIL
	return NIL
   endif
  if color!=NIL
     ::colorSpec:=color
  endif
  ::setcolor()
  ::_display()
return ::classname

**********************************************
static func killFocus()
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"killfocus",::name)
#endif
   if ::block==NIL
	return NIL
   endif
  set("__readvar",::__oldReadVar)
  ::hasFocus:=.f.
  ::reset()
  ::_display()
  ::changed:=.f.
return NIL

**********************************************
static function __updateInfo()
local v,s
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"__updateinfo",::name)
#endif
  if ::block!=NIL
	::_original:=eval(::block)
	s:=::_original
  endif
  ::type:=valtype(::_original)
  //::changed:=.f.
  v:=::_original
  do case
     case ::type=="A"
	  v:=LANG_ARRAY_STRING
     case ::type=="B"
	  v:=LANG_CBLOCK_STRING
     case ::type=="C"
	  v:=v
     case ::type=="D"
	  v:=DTOC(v)
     case ::type=="L"
	  v:=iif(v,LANG_YES_STRING,LANG_NO_STRING)
     case ::type=="M"
	  v:=v
     case ::type=="N"
	  v:=str(v)
     case ::type=="O"
	  v:=LANG_OBJECT_STRING
     case ::type=="U"
	  v:=LANG_UNDEF_STRING
     otherwise
	  v:=LANG_UNKNOWN_STRING
  endcase
  ::__original=v
  ::decpos:=0

return

**********************************************
static func setFocus()
  local v
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"__setfocus",::name)
#endif
   if ::block==NIL
	return NIL
   endif
  ::__oldReadVar:=set("__readvar",::name)
  ::reset()
  ::hasFocus:=.t.

  ::original:=eval(::block)
  ::__updateInfo()

  ::__analizePic()
  ::__winLen=min(::__winlen,len(::__format))

  if ::type=="N"
       ::__original:=str(::_original,::__len,::__dec)
       ::__original:=strtran(::__original,".","")
  endif

  ::__fillBuffer()
  if len(::__posArr)>0
     ::pos:=::__posArr[1]
  endif
  ::_display()

return NIL
**********************************************
static func reload()
  local v
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"__reload",::name)
#endif
   if ::block==NIL
	return NIL
   endif

  ::original:=eval(::block)
  ::__updateInfo()

  ::__analizePic()
  ::__winLen=min(::__winlen,len(::__format))

  if ::type=="N"
       ::__original:=str(::_original,::__len,::__dec)
       ::__original:=strtran(::__original,".","")
  endif

  ::__fillBuffer()
  if len(::__posArr)>0
     ::pos:=::__posArr[1]
  endif

return NIL
**********************************************
static func updateBuffer()
  local v
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"updatebuffer",::name)
#endif
   if ::block==NIL
	return NIL
   endif

  ::__updateInfo()

  ::__analizePic()
  ::__winLen=min(::__winlen,len(::__format))

  if ::type=="N"
       ::__original:=str(::_original,::__len,::__dec)
       ::__original:=strtran(::__original,".","")
  endif

  ::__fillBuffer()
  ::_display()

return NIL
**********************************************
static func display(self)
   local s:=self:buffer,modify:=.f.
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"display",self:name)
#endif
   if self:block==NIL
	return self
   endif
   self:__fillbuffer()
   if !(s==self:buffer)
	self:buffer:=s
	modify:=.t.
   endif
   if !modify .and. !self:hasFocus .and. (self:buffer==NIL .or. self:_original != eval(self:block) /* .or. !self:changed*/)
	self:__updateInfo()

	self:__analizePic()
	self:__winLen=min(self:__winlen,len(self:__format))

	if self:type=="N"
		self:__original:=str(self:_original,self:__len,self:__dec)
		self:__original:=strtran(self:__original,".","")
	endif

	self:__fillBuffer()
   endif
   self:_display()
   /*
   if self:winbuffer == nil
   	devpos(self:row(),self:col+self:__winlen)
   endif
   */
return self

**********************************************
static func reset(obj)
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"reset",obj:name)
#endif
  if obj:hasFocus
     //obj:changed:=.f.
     //obj:exitState:=GE_NOEXIT
     //obj:hasFocus:=.f.
     obj:pos:=1
     //obj:reader:=NIL
     obj:rejected:=.f.
     obj:subscript:=NIL
     obj:typeOut:=.f.
     obj:clear:=.f.
     obj:minus:=.f.
     obj:__firstKey:=.f.
  endif
return NIL

**********************************************
static func varGet
	local s
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"varget",::name)
#endif
	if ::block==NIL
		return NIL
	endif
	if ::type $ GETS_TYPES
		s:=eval(::block)
		return s
	endif
return ::_original

**********************************************
static func varPut(value)
	local s
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"varput",::name)
#endif
	if ::block==NIL
		return NIL
	endif
	if ::type $ GETS_TYPES
		s:=eval(::block,value)
		return s
	endif
return ::_original

**********************************************
static func cur_end()
   local p
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"cur_end",::name)
#endif
   if len(::__posArr) == 0
   	return NIL
   endif
   ::pos:=atail(::__posArr)
   p:=ascan(::__posArr,::pos)
   while p>0
	::pos:=::__posArr[p]
	if !empty(substr(::buffer,::pos,1))
		p++
		exit
	endif
	p--
   end
   p:=max(p,1)
   p:=min(p,len(::__posArr))
   if p>0 .and. p<=len(::__posArr)
      ::pos:=::__posArr[p]
   endif
  ::__firstKey:=.t.
  ::_display()
return NIL

**********************************************
static func cur_home()
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"cur_home",::name)
#endif
   if len(::__posArr) >0
  	::pos:=::__posArr[1]
   endif
  ::__firstKey:=.t.
  ::_display()
return NIL

**********************************************
static func cur_left()
   local p
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"cur_left",::name)
#endif
   p:=ascan(::__posArr,::pos)
   p--
   if p<=0
      p:=1
      //::typeOut:=.t.
   endif
   p:=min(p,len(::__posArr))
   if p>0 .and. p<=len(::__posArr)
      ::pos:=::__posArr[p]
   endif
  ::__firstKey:=.t.
  ::_display()
return NIL

**********************************************
static func cur_right()
   local p
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"cur_right",::name)
#endif
   p:=ascan(::__posArr,::pos)
   p++
   if p>len(::__posArr)
      p:=len(::__posArr)
      ::typeOut:=.t.
   endif
   p:=max(1,p)
   if p>0 .and. p<=len(::__posArr)
      ::pos:=::__posArr[p]
   endif
  ::__firstKey:=.t.
   ::_display()
return NIL

**********************************************
static func cur_goto(pos)
   local p:=pos
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"cur_goto",::name)
#endif
//   p:=ascan(::__posArr,::pos)
//   p++
   if p>len(::__posArr)
      p:=len(::__posArr)
      ::typeOut:=.t.
   endif
   p:=max(1,p)
   if p>0 .and. p<=len(::__posArr)
      ::pos:=::__posArr[p]
   endif
  ::__firstKey:=.t.
   ::_display()
return NIL

**********************************************
static func toDecPos()
   local i,pos,s1,s2
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"todecpos",::name)
#endif
   if ! ( ::type=="N" .and. ::decpos!=NIL )
      return NIL
   endif
   if len(::__posarr) == 0
   	return NIL
   endif
   pos:=::pos
   for i=1 to len(::__posArr)
	  if ::__posArr[i]>::decpos
	     ::pos:=::__posArr[i]
	     exit
	  endif
   next
   if !::__firstKey
      ::__original:=str(0,::__len,::__dec)
      ::__original:=strtran(::__original,".","")
      ::__fillBuffer()
   endif
   if pos==::pos
     ::pos:=atail(::__posArr)
   endif
   if ::decpos!=0
	s1:=left(::__original,len(::__original)-::__dec)
	s2:=right(::__original,::__dec)
	s2:=strtran(s2," ","0")
	s1:=str(val(s1,len(s1),0),len(s1),0)
	::__original=s1+s2
	::__fillBuffer()
   else
   //  		::__original=substr(::__original,1,p-1)+substr(::__original,p+1)+" "
   endif
  ::__firstKey:=.t.
  ::_display()
return NIL

**********************************************
static func wordLeft()
   local p,fl:=.f.,pl:=.f.,s
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"wordleft",::name)
#endif
   p:=ascan(::__posArr,::pos)
   p--
   while p>0
	s=substr(::__original,p,1)
	if s!=" "
	   pl:=.t.
	else
	   if fl .and. pl
	      exit
	   endif
	   fl:=.t.
	endif
	p--
   enddo
   p++
   ::__firstKey:=.t.
   if p>0 .and. p<=len(::__posArr)
      ::pos:=::__posArr[p]
      ::_display()
   endif
return NIL

**********************************************
static func wordRight()
   local p,fl:=.f.,s
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"wordright",::name)
#endif
   p:=ascan(::__posArr,::pos)
   while p<len(::__original)
	s=substr(::__original,p,1)
	if s!=" "
	   if fl
	      exit
	   endif
	else
	   fl:=.t.
	endif
	p++
   enddo
   ::__firstKey:=.t.
   if p>0 .and. p<=len(::__posArr)
      ::pos:=::__posArr[p]
      ::_display()
   endif
return NIL


**********************************************
static func backSpace()
   local p,s1,s2
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"backspace",::name)
#endif
   p:=ascan(::__posArr,::pos)
   ::__firstKey:=.t.
   p--
   if p<1 .or. ::readOnly
      return NIL
   endif
   if ::type=="C"
      ::__original=substr(::__original,1,p-1)+substr(::__original,p+1)+" "
   endif
   if ::type=="N"
	if ::decpos!=0
		s1:=substr(::__original,1,::decpos-1)
		s2:=substr(::__original,::decpos)
		if p<::decpos
			s1=substr(s1,1,p-1)+substr(s1,p+1)+" "
		else
			s2=substr(s2,1,p-::decpos)+substr(s2,p-::decpos+2)+" "
		endif
		::__original=s1+s2
	else
		::__original=substr(::__original,1,p-1)+substr(::__original,p+1)+" "
	endif
   endif
   if ::type=="D"
      ::__original=substr(::__original,1,p-1)+" "+substr(::__original,p+1)
   endif
   ::changed:=.t.
   ::__fillBuffer()
   ::left()
return NIL

**********************************************
static func delRight()
   local p,s1,s2,s3
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"delright",::name)
#endif
   p:=ascan(::__posArr,::pos)
   ::__firstKey:=.t.
   if p<1 .or. p>len(::__original) .or. ::readOnly
      return NIL
   endif
   if ::type=="C"
      ::__original=substr(::__original,1,p-1)+substr(::__original,p+1)+" "
   endif
   if ::type=="N"
	if ::decpos>0
		s1:=substr(::__original,1,::decpos-1)
		s2:=substr(::__original,::decpos)
		if p<::decpos
			s1=substr(s1,1,p-1)+substr(s1,p+1)+" "
		else
			s2=substr(s2,1,p-::decpos)+substr(s2,p-::decpos+2)+" "
		endif
		::__original=s1+s2
	else
		::__original=substr(::__original,1,p-1)+substr(::__original,p+1)+" "
	endif
   endif
   if ::type=="D"
      ::__original=substr(::__original,1,p-1)+" "+substr(::__original,p+1)
   endif
   ::changed:=.t.
   ::__fillBuffer()
   ::_display()
return NIL

**********************************************
static func delEnd()
   local p,s1,s2,s3
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"delend",::name)
#endif
   p:=ascan(::__posArr,::pos)
   ::__firstKey:=.t.
   if p<1 .or. p>len(::__original) .or. ::readOnly
      return NIL
   endif
   if ::type$"CND"
      ::__original=substr(::__original,1,p-1)+space(len(::__original)-p+1)
   endif
   ::changed:=.t.
   ::__fillBuffer()
   ::_display()
return NIL

**********************************************
static func delWordLeft()
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"delWordLeft",::name)
#endif
   ::__firstKey:=.t.
   ::changed:=.t.
   ::_display()
return NIL

**********************************************
static func delWordRight()
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"delWordRight",::name)
#endif
   ::__firstKey:=.t.
   ::changed:=.t.
   ::_display()
return NIL


**********************************************
static func Insert(sym)
   local s,p
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"insert",::name)
#endif
   ::typeOut:=.f.
   p:=ascan(::__posArr,::pos)
   if p<1 .or. p>len(::__original) .or. ::readOnly
      ::__firstKey:=.t.
      return NIL
   endif
   ::rejected:=.f.

   s:=::__checkSym(sym)

   if !::__firstKey .and. "K"$::__flags
      ::__original:=space(len(::__original))
      ::changed:=.t.
   endif
   if len(s)>0
      if ::type=="L"
		if s==" "
			::__original:=iif(::__original==LANG_YES_STRING,LANG_NO_STRING,LANG_YES_STRING)
		else
			::__original:=iif( (upper(s) $ ("TY"+LANG_YES_CHAR) ),LANG_YES_STRING,LANG_NO_STRING)
			::__dataSay:=::__original
		endif
      else
	if ::type=="D"
		 ::__original:=substr(::__original,1,p-1)+s+substr(::__original,p+1)
	else
	  	::__original:=left(::__original,len(::__original)-1)
        	if "R" $ ::__flags //::type=="C"
	  		::__original:=substr(::__original,1,p-1)+s+substr(::__original,p)
        	else
	  		::__original:=substr(::__original,1,::pos-1)+s+substr(::__original,::pos)
        	endif
	endif
      endif
      ::__firstKey:=.t.
      ::__fillBuffer()
      ::changed:=.t.
      ::right()
   else
      ::rejected:=.t.
   endif
return NIL

**********************************************
static func overStrike(sym)
   local s,p
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"overstrike",::name)
#endif
   ::typeOut:=.f.
   p:=ascan(::__posArr,::pos)
   if p<1 .or. p>len(::__original) .or. ::readOnly
      ::__firstKey:=.t.
      return NIL
   endif

   ::rejected:=.f.
   s:=::__checkSym(sym)

   if !::__firstKey .and. "K"$::__flags
      ::__original:=space(len(::__original))
      ::changed:=.t.
   endif

   if len(s)>0
      if ::type=="L"
		if s==" "
			::__original:=iif(::__original==LANG_YES_STRING,LANG_NO_STRING,LANG_YES_STRING)
		else
			::__original:=iif( (upper(s) $ ("TY"+LANG_YES_CHAR) ),LANG_YES_STRING,LANG_NO_STRING)
			::__dataSay:=::__original
		endif
      else
	//::__original:=substr(::__original,1,p-1)+s+substr(::__original,p+1)

        if "R" $ ::__flags //::type=="C"
	      ::__original:=substr(::__original,1,p-1)+s+substr(::__original,p+1)
        else
	      //::__original:=substr(::__original,1,p-1)+s+substr(::__original,p+1)
	      ::__original:=substr(::__original,1,::pos-1)+s+substr(::__original,::pos+1)
        endif
      endif
      ::__firstKey:=.t.
      ::__fillBuffer()
      ::changed:=.t.
      ::right()
   else
      ::rejected:=.t.
   endif
return NIL

**********************************************
static func __checkSym(sym)
   local s:="",sf
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"__checksym",::name)
#endif
   sf:=substr(::__format,::pos,1)
   if sf=="X"
      s=sym
   endif
   if sf=="A" .and. isalpha(sym)
      s=sym
   endif
   if sf=="N" .and. ( isalpha(sym) .or. isdigit(sym) )
      s=sym
   endif
   if sf=="9" .and. ( isdigit(sym) .or. sym $ "-+" )
      s=sym
   endif
   if sf=="#" .and. ( isdigit(sym) .or. sym $ "-+ " )
      s=sym
   endif
   if sf=="L" .and. ( upper(sym) $ (" TFYN"+LANG_YES_CHAR+LANG_NO_CHAR) )
      s=sym
   endif
   if sf=="Y" .and. ( upper(sym) $ (" YN"+LANG_YES_CHAR+LANG_NO_CHAR) )
      s=sym
   endif
   if sf=="!" .or. "!"$::__flags
      s=upper(sym)
   endif
return s

**********************************************
static func __analizePic()
  local s1:="",s2:="",s3:="",s4,i,j,sf:=.f.,df
  local len,p:="ANX9#LY!$*"
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"__analizePic",::name)
#endif
  ::__winlen:=0
  ::__flags:=""
  ::__posArr:={}
  ::__format:=""
  ::__dataSay:=""
  if ::type=="N"
     ::__len:=0
     ::__dec:=0
     ::decpos:=0
  else
     ::__len:=NIL
     ::__dec:=NIL
     ::decpos:=NIL
  endif
  if !empty(::picture)
	  // разбор команд в PICTURE-строке
	s1:=::picture
	if substr(s1,1,1)=="@"
		i:=at(" ",s1)
		i:=iif(i==0,len(s1)+1,i)
		s4=substr(s1,i+1)
		s1=upper(substr(s1,2,i-2))
		for i=1 to len(s1)
			s2=substr(s1,i,1)
			if sf && isdigit(s2)
				s3+=s2
				loop
			endif
			sf:=(s2=="S")
			::__flags+=s2
		next
	else
		s4:=::picture
	endif
	if empty(s3)
		::__winlen:=len(s4)
	else
		::__winLen:=val(s3)
	endif
  endif
  if ::type=="D"
     if "E"$::__flags
	 if __setCentury()
	     s4:=DATE_BRITISH_FORMAT_CENTURY
	 else
	     s4:=DATE_BRITISH_FORMAT
	 endif
     else
	 s4:=lower(set(_SET_DATEFORMAT))
     endif
     ::__dateFormat:=s4
     df:=""
     for i=1 to len(s4)
		s2=substr(s4,i,1)
		if s2 $ DATE_DELIMITER_CHARS
			::__format+=" "
			::__dataSay+=s2
		else
			::__format+="9"
			::__dataSay+=" "
			aadd(::__posArr,i)
			df+=s2
		endif
     next
     ::__original:=DTOC(::_original,df)
     ::__winlen:=len(::__format)
     //::__flags+="K"
     return NIL
  endif
  if empty(s4) //empty(::picture)
     // сделать шаблон по умолчанию
	do case
	case ::type=="C"
		  len:=len(::__original)
		  ::__format:=replicate("X",len)
		  ::__dataSay:=space(len)
		  for i=1 to len
		      aadd(::__posArr,i)
		  next
	case ::type=="D"
		  ::__format:=""
		  ::__dataSay:=""
	case ::type=="L"
		  ::__dataSay:=::__original
		  ::__format:="Y"+space(len(::__original)-1)
		  aadd(::__posArr,1)
	case ::type=="N"
		::__len:=len(::__original)
		::decpos:=::__len+1
		for i=1 to ::__len
			s2=substr(::__original,i,1)
			if s2=="."
				s1+="."
				::decpos:=i
				::__format+=" "
				::__dataSay+="."
			else
				::__format+="9"
				::__dataSay+=" "
				aadd(::__posArr,i)
			endif
		next
		::__dec:=::__len-::decpos
		::__dec:=max(::__dec,0)
		::__flags+="K"
	case ::type=="M"
		::__flags+="R"
		::__winlen:=maxcol()-::col-1
		::__format:=replicate("X",GETOBJ_MAX_MEMO_LEN)
		::__dataSay:=space(GETOBJ_MAX_MEMO_LEN)
		  for i=1 to GETOBJ_MAX_MEMO_LEN
		      aadd(::__posArr,i)
		  next
	case ::type=="A"
		::__dataSay:=::__original
		::__format:=space(len(::__original))
	case ::type=="B"
		::__dataSay:=::__original
		::__format:=space(len(::__original))
	case ::type=="O"
		::__dataSay:=::__original
		::__format:=space(len(::__original))
	case ::type=="P"
		::__dataSay:=::__original
		::__format:=space(len(::__original))
	otherwise
		::__dataSay:=::__original
		::__format:=space(len(::__original))
	endcase
	if !("S" $ ::__flags) .or. ::__winlen==0
	   ::__winlen:=min(len(::__format),maxcol()-::col)
	endif
	return NIL

  else
	//  разбор шаблона вывода данных
	::__format:=""
	::__dataSay:=""
	for i=1 to len(s4)
		s2=substr(s4,i,1)
		if s2=="." .and. ::type=="N"
			::decpos:=i
			::__len++
		endif
		if s2 $ p
			::__format+=s2
			::__dataSay+=" "
			aadd(::__posArr,i)
			if ::type=="N"
				::__len++
				if ::decpos>0
					::__dec++
				endif
			endif
		else
			::__format+=" "
			::__dataSay+=s2
		endif
	next
	if ::type=="N"
		::__flags+="K"
	endif
	if ::type=="N" .and. "E" $ ::__flags
		for i=1 to len(::__dataSay)
			s2:=substr(::__dataSay,i,1)
			if !(s2 $ ",.")
				loop
			endif
			::__dataSay:=substr(::__dataSay,1,i-1)+;
				iif(s2==".",",",".")+;
				substr(::__dataSay,i+1)
		next
	endif
	if ::__winlen==0
		::__winlen:=min(len(::__format),maxcol()-::col)
	endif
  endif
return NIL

**********************************************
static func __fillBuffer()
     local i,j:=0,k:=1,s1,s2,s3
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"__fillbuffer",::name)
#endif
     ::__first:=.f.
     ::buffer:=""
     for i=1 to len(::__posArr)
	 k:=::__posArr[i]
         s1:=substr(::__dataSay,j+1,k-j-1)
         s2:=substr(::__original,i,1)
         s3:=substr(::__format,i,1)
	 ::buffer+=s1
         if "R" $ ::__flags
         	//if s1==s2
         	//	::__original:=left(::__original,i-1)+substr(::__original,i+1)
         	//	s2:=substr(::__original,i,1)
         	//endif
         else
         	if ::type $ "CM"
	 		s2:=substr(::__original,k,1)
         	endif
         endif
         s2:=iif(s3=="!",upper(s2),s2)
	 ::buffer+=s2
	 j:=k
     next
     ::buffer+=substr(::__dataSay,j+1,len(::__dataSay))
     if "!" $ ::__flags
       ::buffer=upper(::buffer)
     endif
return NIL

**********************************************
static func get_setcolor(color)
	if color != NIL
        	::colorSpec := color
        endif
       	::__colors:=__splitColors(::colorSpec)
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"setcolor",::name)
#endif
return NIL

**********************************************
static func _display ()
  local bpos,epos,spos,mlen,p,ssay,i,x,y,s
  local setd:=set(_SET_DELIMITERS),setdc:=set(_SET_DELIMCHARS)
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"_display",::name)
#endif
  if ::control != NIL
  	return
  endif
  if ::__first
	::setfocus()
	::killfocus()
  endif
  if ::winbuffer == nil
  	dispbegin()
  endif
  if ::caption!=NIL
     __sayCaption(::capRow,::capCol,::caption,::__colors[1])
  endif
  if !::hasFocus
      if ::winbuffer == nil
      		dispOutAt(::row, ::col, iif(setd,substr(setdc,1,1),""), ::__colors[1] )
      else
      		s:= iif(setd,substr(setdc,1,1),"")
      		winbuf_out_at(::winbuffer,::row,::col,s, ::__colors[1])
      		y := ::row; x := ::col + len(s)
      endif
      //ssay:=substr(::buffer,1,::__winlen)
      ssay:= ::__toString()
      if "Q" $ ::__flags
	 ssay=padr(replicate("*",len(rtrim(ssay))),len(ssay))
      endif
      if ::winbuffer == nil
      		dispOut(ssay,::__colors[5])
      		dispOut(iif(setd,substr(setdc,2,1),""),::__colors[1])
      else
      		winbuf_out_at(::winbuffer,y,x,ssay, ::__colors[5])
      		x += len(ssay)
      		s:= iif(setd,substr(setdc,2,1),"")
      		winbuf_out_at(::winbuffer,y,x,s, ::__colors[1])
      		y := ::row; x := ::col + len(s)
      endif
      //setpos(::row,::col)
      if ::winbuffer == nil
      		dispend()
      endif
      return NIL
  endif
  spos:=int(::__winLen/4)
  epos:=len(::__format)
  epos=min(::pos+spos,epos)
  epos=max(epos,::__winLen)
  bpos=epos-::__winLen+1
  if ::winbuffer == nil
  	dispOutAt(::row, ::col, iif(setd,substr(setdc,1,1),""), ::__colors[2] )
  else
  	s := iif(setd,substr(setdc,1,1),"")
  	winbuf_out_at(::winbuffer,::row, ::col, s, ::__colors[2] )
  	y := ::row; x := ::col + len(s)
  endif
  ssay:=substr(::buffer,bpos,epos-bpos+1)
  if "Q" $ ::__flags
	 ssay=padr(replicate("*",len(rtrim(ssay))),len(ssay))
  endif
  if ::winbuffer == nil
  	dispOut(ssay,::__colors[2])
  	dispOut(iif(setd,substr(setdc,2,1),""),::__colors[2])
  else
  	winbuf_out_at(::winbuffer,y,x,ssay,::__colors[2])
  	x += len(ssay)
  	winbuf_out_at(::winbuffer,y,x,iif(setd,substr(setdc,2,1),""),::__colors[2])
  endif
  ::cursorPos := ::__winLen-(epos-::pos)-iif(setd,0,1)+1
  if ::winbuffer == nil
  	setpos(::row,::col+::cursorPos-1)
  	dispend()
  endif
return NIL

*********************************************
function __capLength(str)
return len(strtran(str,"&",""))

*********************************************
function __sayCaption(nrow,ncol,str,ccolor,len,ncolor,winbuffer)
   local s,oldcol,n,n1,n2
#ifdef DEBUG
	outlog(__FILE__,__LINE__,"__sayCaption")
#endif
   if nrow==NIL .or. ncol==NIL .or. str==NIL .or. ccolor==NIL
      return .f.
   endif
   oldcol:=setcolor(ccolor)
   if ncolor==NIL
	ncolor:=setcolor(,.t.)
	n:=at("/",ncolor)
	n1 := val(substr(ncolor,n+1))
	n2 := val(ncolor)
	n2:=numxor(numxor(n1,0x07),n2)
	n2:=numxor(n1+n2,0x07)
	ncolor:=alltrim(str(n2,2,0))+"/"+alltrim(str(n1,2,0))
   endif
   n=at("&",str)
   s:=strtran(str,"&","")
   if len!=NIL
      s:=padr(s,len)
   endif
   if winbuffer == nil
   	dispOutAt(nrow,ncol, s )
   	if n!=0
		n--
		dispattr(nrow,ncol+n,nrow,ncol+n,ncolor)
   	endif
   else
   	winbuf_out_at(winbuffer,nrow,ncol,s,ccolor)
   	if n!=0
		n--
		winbuf_attr_at(winbuffer,nrow,ncol+n,nrow,ncol+n,ncolor)
   	endif
   endif
   setcolor(oldcol)
return .t.

**********************************************
function __splitColors(s)
       local i,__colors:={},ss
       if s==NIL .or. empty(s)
	  return __colors
       endif
       s:=upper(s)
       while len(s)>0
	   i:=at(",",s)
	   i=iif(i==0,len(s)+1,i)
	   ss:=alltrim(substr(s,1,i-1))
	   if (ss=="N/N")
		ss:="w/n"
	   endif
	   aadd(__colors, ss )
	   s:=substr(s,i+1)
       enddo
       if empty(__colors)
		aadd(__colors,"W+/B")
       endif
       for i=len(__colors) to GET_MAX_COLORS
	   aadd(__colors,__colors[1])
       next
return __colors
*********************************************
static function __toString()
  local ret,i,s,ch,flag
  ret:=::buffer
  if "B" $ ::__flags
	ret:=padr(alltrim(ret),len(ret))
  endif
  if "S" $ ::__flags
	ret:=substr(ret,1,::__winlen)
  endif
  if "(" $ ::__flags .and. ::type=="N" .and. ::_original<0
	ret:="("+ret+")"
  endif
  if ::type=="N"
	if "," $ ::__dataSay
		s:=ret; ret:=""; flag:=.f.
		for i=1 to len(s)
			ch:=substr(s,i,1)
			if isdigit(ch)
				flag:=.t.
			endif
			if flag
				ret+=ch
				loop
			endif
			ret+=iif(ch==","," ",ch)
		next
	endif
	if "E" $ ::__flags
		s:=ret; ret:=""; flag:=.f.
		for i=1 to len(s)
			ch:=substr(s,i,1)
			if isdigit(ch)
				flag:=.t.
			endif
			if flag
				ret+=ch
				loop
			endif
			ret+=iif(ch=="."," ",ch)
		next
	endif
	if ::_original==0 .and. "Z" $ ::__flags
		ret:=space(len(ret))
	endif
  endif
return ret

*********************************************
function trans(xValue,picture)
return transform(xValue,picture)
*********************************************
function transform(xValue,picture)
  local obj	:=map()
  obj:original	:=xValue
  obj:_original	:=xValue
  obj:picture	:=picture
  obj:block	:=NIL
  obj:col	:=0

  __updateInfo(obj)
  __analizePic(obj)

  if obj:type=="N"
       obj:__original:=str(obj:_original,obj:__len,obj:__dec)
       obj:__original:=strtran(obj:__original,".","")
  endif

  //__fillTransform(obj)
  __fillBuffer(obj)

return __toString(obj)

*********************************************
function devoutpict(xValue,pict,cColor)
	devOut(transform(xValue,pict),cColor)
return

*********************************
static function	__set_default_keys()
	local m
	::__keys := map()
	m:=::__keys
	m[K_END]  	:= { |oGet,nKey| oGet:end(),0 }
	m[K_HOME]  	:= { |oGet,nKey| oGet:home(),0 }
	m[K_LEFT]  	:= { |oGet,nKey| oGet:left(),0 }
	m[K_RIGHT]  	:= { |oGet,nKey| oGet:right(),0 }
	m[K_CTRL_END]  	:= { |oGet,nKey| oGet:End(),0 }
	m[K_CTRL_HOME]  := { |oGet,nKey| oGet:Home(),0 }
	m[K_CTRL_LEFT]  := { |oGet,nKey| oGet:wordLeft(),0 }
	m[K_CTRL_RIGHT] := { |oGet,nKey| oGet:wordRight(),0 }
	m[K_DEL]	:= { |oGet,nKey| oGet:delete(),0 }
	m[K_CTRL_T]	:= { |oGet,nKey| oGet:delWordRight(),0 }
	m[K_CTRL_Y]	:= { |oGet,nKey| oGet:delEnd(),0 }
	m[K_CTRL_BS]	:= { |oGet,nKey| oGet:delWordLeft(),0 }
	m[K_BS]		:= { |oGet,nKey| oGet:BackSpace(),0 }
return
*********************************
static function __setkey(nKey,value)
	local ret,m := ::__keys

	if nkey $ m
		ret := m[nKey]
	endif
	if pcount() > 2   /* self as first parameter */
		m[nKey] := value
	endif
	if nKey $ m .and. m[nKey] == NIL
		adel(m ,nKey)
	endif
return ret

