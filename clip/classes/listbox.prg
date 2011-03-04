/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "button.ch"
#include "box.ch"
#include "setcurs.ch"
#include "set.ch"

#ifdef __UNIX__
   #define LB_PUSHSYM "#"
#else
   #define LB_PUSHSYM chr(31)
#endif

******************************
function _listbox_(top,left,bottom,right,var,items,caption,message,;
		   color, fblock,sblock,ldrop,scroll,bitmap)

   local i,dtext,data,obj
   obj		:= listbox(top,left,bottom,right,ldrop)
   obj:caption	:= iif(caption==NIL,"",caption)
   obj:message	:= message
   obj:bitmap	:= bitmap
   obj:fblock	:= fblock
   obj:sblock	:= sblock

   obj:__bufType:=2
   for i=1 to len(items)
       do case
       case valtype(items[i])=="C"
	    dtext := items[i]
	    obj:__bufType:=1
       case valtype(items[i])=="A"
	    dtext := toString(items[i][1])
	    if len(items[i])>1
		data := items[i][2]
	    else
		obj:__bufType:=1
	    endif
       otherwise
	    dtext := toString(items[i])
       endcase
       obj:addItem(dtext,data,.f.)
       if obj:__bufType==1 .and. valtype(dtext)==valtype(var) .and. dtext==var
	  obj:value:=i
       endif
       if obj:__bufType==2 .and. valtype(data)==valtype(var) .and. data==var
	  obj:value:=i
       endif
   next
   if valtype(var)=="N"
      obj:__bufType:=0
      obj:value:=var
   endif
   obj:value:=min(obj:itemCount,max(obj:value,1))
   obj:__line:=obj:value
   obj:colorSpec:=iif(color==NIL,setcolor(),color)
   if scroll!=NIL .and. scroll
      obj:__SB	:= scrollBar(top+iif(obj:dropDown,1,0),bottom,right,sblock)
      obj:__SB:colorSpec:=obj:colorSpec
   endif

   obj:__setColor()
   obj:__setBuffer()
   obj:display()

return obj

******************************
function listBox(top,left,bottom,right,ldrop)
   local obj
   ldrop:=iif(ldrop==NIL,.f.,ldrop)

   obj		:= map()
   //obj:name	:= ""
   //obj:subscript:= NIL
   obj:classname:="LISTBOX"
   obj:bitmap	:= NIL
   obj:bottom	:= bottom
   obj:buffer	:= 1
   obj:capCol	:= NIL
   obj:capRow	:= NIL
   obj:caption	:= ""
   obj:cargo	:= NIL
   obj:coldBox	:= NIL //B_SINGLE+" "
   obj:colorSpec:= setcolor()
   obj:dropDown	:= ldrop
   obj:fblock	:= NIL
   obj:hasFocus	:= .f.
   obj:hotBox	:= NIL //B_DOUBLE+" "
   obj:isOpen	:= !ldrop
   obj:useArrow := .t.
   obj:itemCount:= 0
   obj:left	:= left
   obj:message	:= ""
   obj:right	:= right
   obj:sblock	:= NIL
   obj:top	:= top
   obj:topItem	:= 1
   obj:typeOut	:= .t.
   obj:value	:= 0
   obj:vscroll	:= NIL

   _recover_listbox(obj)

   obj:__cursor	:= setcursor()
   obj:__line	:= obj:value
   obj:__mText	:= {}
   obj:__mData	:= {}
   obj:__SB	:= NIL
   obj:__colors	:= {}
   obj:__bufType:= 0  // data type in buffer - 0-number, 1-text, 2-some data
   obj:__scr	:= savescreen(top+iif(ldrop,1,0),left,bottom,right)
   obj:__setColor()

return obj
******************************
function _recover_listbox(obj)
   obj:addItem	:= @lb_addItem()
   obj:close	:= @lb_close()
   obj:delItem	:= @lb_delItem()
   obj:display	:= @lb_display()
   obj:findText	:= @lb_findText()
   obj:getData	:= @lb_getData()
   obj:getItem	:= @lb_getItem()
   obj:getText	:= @lb_getText()
   obj:hitTest	:= @lb_hitTest()
   obj:insItem	:= @lb_insItem()
   obj:killFocus:= @lb_killFocus()
   obj:nextItem	:= @lb_nextItem()
   obj:nextPage	:= @lb_nextPage()
   obj:open	:= @lb_open()
   obj:prevItem	:= @lb_prevItem()
   obj:prevPage	:= @lb_prevPage()
   obj:scroll	:= @lb_scroll()
   obj:select	:= @lb_select()
   obj:setData	:= @lb_setData()
   obj:setFocus	:= @lb_setFocus()
   obj:setItem	:= @lb_setItem()
   obj:setText	:= @lb_setText()
   obj:__setBuffer:=@__setBuffer()
   obj:__setColor:= @__setcolor()
   //obj:reader  := {|a,b,c,d|GuiReader(a,b,c,d)}
return obj
******************************
static func __setBuffer
    if ::__bufType==0
       ::buffer:=::value
    endif
    if ::__bufType==1
       ::buffer:=::__mtext[::value]
    endif
    if ::__bufType==2
       ::buffer:=::__mdata[::value]
    endif
return ::buffer

******************************
static func lb_display(self)
  local curr:=self:value, pal:=1, ntop:=self:top,i,ltop,atop
  if len(self:__mtext) == 0
	return self
  endif
  self:value:=min(self:itemCount,max(self:value,1))
  if self:value>self:itemCount .or. self:value<1
	return self
  endif
  dispbegin()
  if self:dropDown
      pal:= iif(self:hasFocus,2,1)
      dispOutAt(self:top, self:left, ;
	    padr(self:__mtext[curr],self:right-self:left)+ LB_PUSHSYM,;
	    self:__colors[pal] )
      ntop++
  endif
  if self:isopen
     if self:hasFocus
		if self:hotBox!=NIL
			@ ntop, self:left, self:bottom, self:right box ;
				self:hotBox color self:__colors[3]
		else
			@ ntop, self:left TO self:bottom, self:right;
				DOUBLE color self:__colors[3]
		endif
     else
		if self:coldBox!=NIL
			@ ntop, self:left, self:bottom, self:right box ;
				self:coldBox color self:__colors[3]
		else
			@ ntop, self:left TO self:bottom, self:right;
				 color self:__colors[3]
		endif
     endif
     self:__line:=min(min(max(1,self:__line),self:bottom-ntop-1),self:itemCount)
     ltop:=self:value-self:__line+1
     ltop:=min(ltop,self:itemcount - ( self:bottom-ntop-2) )
     ltop:=max(ltop,1)
     //pal:= iif(self:hasFocus,2,5)
     pal:=5
     for i=1 to self:bottom-ntop-1
	 if ltop<=self:itemCount
	    dispOutAt(ntop+i, self:left+1,;
		  padr(self:__mText[ ltop ],self:right-self:left-1),;
		  self:__colors[pal] )
	 else
	    dispOutAt(ntop+i, self:left+1, space(self:right-self:left-1) )
	 endif
	 ltop++
     next
     pal:= iif(self:hasFocus,2,1)

     dispOutAt(ntop+self:__line, self:left+1,;
	     padr(self:__mText[ self:value ],self:right-self:left-1),;
	     self:__colors[pal] )
  endif

  if self:__SB != NIL .and. self:isopen
     self:__SB:total  := self:itemCount
     self:__SB:current:= curr
     self:__SB:display()
  endif
  dispend()
return self

******************************
static func lb_killFocus(self)
       setcursor(self:__cursor)
       self:hasFocus:=.f.
       if self:dropDown
	  self:close()
       endif
       if self:fblock != NIL
	  eval(self:fblock,.f.)
       endif
       self:display()
return self

******************************
static func lb_setFocus(self)
      self:__cursor:=setcursor(SC_NONE)
      self:hasFocus:=.t.
      if self:fblock != NIL
	 eval(self:fblock,.t.)
      endif
      self:display()
return self

******************************
static func lb_addItem(self,dtext,data,visible)
     aadd(self:__mText,dtext)
     aadd(self:__mData,data)
     self:itemCount++
     self:typeOut:=.f.
     if self:__SB!=NIL
	self:__SB:total:=self:itemCount
     endif
     if visible==NIL .or. visible
	self:display()
     endif
return self

******************************
static func lb_delItem(self,pos)
     adel(self:__mText,pos)
     asize(self:__mText,len(self:__mtext)-1)
     adel(self:__mData,pos)
     asize(self:__mData,len(self:__mData)-1)
     self:itemCount--
     if self:itemCount==0
	self:typeOut:=.t.
     endif
     if self:__SB!=NIL
	self:__SB:total:=self:itemCount
     endif
     self:display()
return self

******************************
static func lb_insItem(self,pos,mtext,data)
     asize(self:__mText,len(self:__mtext)+1)
     ains(self:__mText,pos)
     self:__mText[pos] := mtext
     asize(self:__mData,len(self:__mData)-1)
     aadd(self:__mData,pos)
     self:__mData[pos] := data
     self:itemCount++
     self:typeOut:=.f.
     if self:__SB!=NIL
	self:__SB:total:=self:itemCount
     endif
     self:display()
return self

******************************
static func lb_setData(self,pos,data)
       if pos>0 .and. pos<=len(self:__mData)
	  self:__mData[pos]:=data
       endif
return self

******************************
static func lb_setItem(self,pos,item)
       if pos>0 .and. pos<=len(self:__mText) ;
	  .and. valtype(item)=="A"  .and. len(item)>=2
	  self:__mText[pos]:=item[1]
	  self:__mData[pos]:=item[2]
       endif
return self

******************************
static func lb_setText(self,pos,mtext)
       if pos>0 .and. pos<=len(self:__mText)
	  self:__mText[pos]:=mText
       endif
return self

******************************
static func lb_nextItem(self)
	if self:value<self:itemCount
	   self:value++
	   if self:isopen
	      self:__line++
	   endif
	endif
	self:__setBuffer()
	self:display()
return self
******************************
static func lb_nextPage(self)
	if self:value<self:itemCount
	   self:value += (self:bottom-self:top)
	   if self:isopen
	      if self:value > self:itemCount
		self:__line := self:itemcount
	      endif
	   endif
	   self:value:=min(self:value,self:itemCount)
	endif
	self:__setBuffer()
	self:display()
return self

******************************
static func lb_prevItem(self)
	if self:value>1
	   self:value--
	   if self:isopen
	      self:__line--
	   endif
	endif
	self:__setBuffer()
	self:display()
return self
******************************
static func lb_prevPage(self)
	if self:value>1
	   self:value -= (self:bottom-self:top)
	   if self:isopen
	      if self:value<1
		 self:__line:=min(1,self:itemCount)
	      endif
	   endif
	   self:value:=min(max(1,self:value),self:itemCount)
	endif
	self:__setBuffer()
	self:display()
return self

******************************
static func lb_getData(pos)
       if pos>0 .and. pos<=len(::__mData)
	  return ::__mData[pos]
       endif
return NIL

******************************
static func lb_getItem(pos)
       if pos>0 .and. pos<=len(::__mText)
	  return {::__mText[pos],::__mData[pos]}
       endif
return NIL

******************************
static func lb_getText(pos)
       if pos>0 .and. pos<=len(::__mText)
	  return ::__mText[pos]
       endif
return NIL

******************************
static func lb_close(self)
	if self:isopen
	   restscreen(self:top+iif(self:dropDown,1,0),self:left,self:bottom,self:right,self:__scr)
	   self:isopen:=.f.
	endif
return self

******************************
static func lb_findText(mtext,pos,lcase,lexact)
	local bl,ret
	if valtype(mtext)!="C"
	   return ::value
	endif
	pos:=iif(pos==NIL,1,pos)
	lcase:=iif(lcase==NIL,.t.,lcase)
	lexact:=iif(lexact==NIL,set(_SET_EXACT),lexact)
	if lcase
	   mtext:=lower(mtext)
	   if lexact
		bl:={ |x| lower(x)==mtext }
	   else
		bl:={ |x| lower(x)=mtext }
	   endif
	else
	   if lexact
		bl:={|x| x==mtext }
	   else
		bl:={|x| x=mtext }
	   endif
	endif
	ret:=ascan(::__mText,bl,pos,len(::__mText))
return ret

******************************
static func lb_select(self,pos)
	if valtype(pos)=="N"
	   self:value:=pos
	   self:value:=min(max(1,self:value),self:itemCount)
	   self:__setBuffer()
	   self:display()
	   if self:sblock != NIL
		eval(self:sblock)
	   endif
	endif
return  self

******************************
static func lb_open(self)
       if self:dropDown
	  self:__scr:= savescreen(self:top+iif(self:dropDown,1,0),self:left,self:bottom,self:right)
	  self:isopen:=.t.
	  self:__line:=self:value
	  self:display()
       endif
return self

******************************
static func lb_scroll(self,num)
       if num==HTSCROLLUNITDEC
	  self:value++
	  if self:isopen
	      self:__line++
	  endif
       endif
       if num==HTSCROLLUNITINC
	  self:value--
	  if self:isopen
	      self:__line--
	  endif
       endif
       if num==HTSCROLLBLOCKDEC
	  self:value+=self:bottom-self:top-iif(self:dropDown,1,0)
       endif
       if num==HTSCROLLBLOCKINC
	  self:value-=self:bottom-self:top-iif(self:dropDown,1,0)
       endif

       self:value:=min(max(1,self:value),self:itemCount)
       self:__setBuffer()
       self:display()

return self

******************************
static func lb_hitTest(mrow,mcol)
       local ret:=0, ntop
       if ::isopen .and. ::__SB!=NIL
	  ret=::__SB:hitTest(mrow,mcol)
	  if ret!=0
	     return ret
	  endif
       endif
       ntop:=iif(::dropDown,::top+1,::top)
       if ::isopen
	     if mrow==ntop
		if mcol>::left .and. mcol<::right
		   ret=HTTOP
		endif
		if mcol==::left
		   ret=HTTOPLEFT
		endif
		if mcol==::right
		   ret=HTTOPRIGHT
		endif
	     endif
	     if mrow==::bottom
		if mcol>::left .and. mcol<::right
		   ret=HTBOTTOM
		endif
		if mcol==::left
		   ret=HTBOTTOMLEFT
		endif
		if mcol==::right
		   ret=HTBOTTOMRIGHT
		endif
	     endif
	     if mcol==::left .and. mrow>ntop .and. mrow<::bottom
		ret=HTLEFT
	     endif
	     if mcol==::right .and. mrow>ntop .and. mrow<::bottom
		ret=HTRIGHT
	     endif
	     if mrow>ntop .and. mrow<::bottom .and. ;
		    mcol>::left .and. mcol<::right
		ret=HTCAPTION
	     endif
       endif
       if ::dropDown
	   if mrow==::top .and. mcol>=::left .and. mcol<::right
		ret=HTCAPTION
	   endif
	   if mrow==::top .and. mcol==::right
		ret=HTDROPBUTTON
	   endif
       endif
return ret

******************************
static func __setcolor()
       local i
       ::__colors:=__splitColors(::colorSpec)
       for i=len(::__colors) to 8
	   aadd(::__colors,"W+/B")
       next
return NIL

