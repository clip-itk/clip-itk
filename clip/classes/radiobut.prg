/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "button.ch"

**********************************************
function radioButton(nrow,ncol,caption,rvalue)
   return radioButto(nrow,ncol,caption,rvalue)

**********************************************
function radioButto(nrow,ncol,caption,rvalue)
   local obj
   obj:=map()
   obj:classname:="RADIOBUTTON"
   obj:bitmaps	:=NIL
   obj:buffer	:=.f.
   obj:caption	:=caption
   obj:capCol	:=ncol+4
   obj:capRow	:=nrow
   obj:cargo	:=NIL
   obj:col	:=ncol
   obj:colorSpec:=setcolor()
   obj:fblock	:=NIL
   obj:hasFocus	:=.f.
   obj:message	:=""
   obj:row	:=nrow
   obj:rvalue	:=rvalue
   obj:sblock	:=NIL
   obj:style	:="(* )"
   obj:typeOut	:=.f.

   obj:__colors:={}

   _recover_radiobutton(obj)

   obj:__setcolor()

return obj

*************************************
function _recover_radiobutton(obj)
   obj:display	:=@rb_display()
   obj:hitTest	:=@hitTest()
   obj:isAccel	:=@rb_isAccel()
   obj:killFocus:=@killFocus()
   obj:select	:=@rb_select()
   obj:setFocus	:=@setFocus()
   obj:__setColor:=@__setcolor()
return obj

*************************************
static func rb_display(self)
      local pal,s
      pal:=self:__colors[iif(self:hasFocus,2,1)]
      s=substr(self:style,1,1)
      s+=substr(self:style,iif(self:buffer,2,3),1)
      s+=substr(self:style,4,1)
      dispOutAt(self:row, self:col, s, pal )
      __sayCaption( self:row, self:col+4, self:caption, self:__colors[1],,;
      		self:__colors[iif(self:hasFocus,6,7)])
      setpos(self:row, self:col+1)
return self

*************************************
static func hitTest(mouseRow,mouseCol)
    local ret:=HTNOWHERE
    if mouseRow==::row
       if mouseCol==::col+1
	  ret=HTCLIENT
       else
	  if mouseCol>=::capCol .and. mouseCol<=::capCol+len(::caption)
	     ret=HTCAPTION
	  endif
       endif
    endif
return ret

*************************************
static func rb_isAccel(nkey)
    local s,ret:=.f.
    s=lower("&"+chr(nkey))
    ret=s $ lower(::caption)
return ret

*************************************
static func killFocus(self)
   if self:hasFocus
      self:hasFocus:=.f.
      self:display()
   endif
   if self:fblock!=NIL
       eval(self:fblock)
   endif
return self

*************************************
static func rb_select(self,newState)
       if newstate==NIL
	  self:buffer:=.t.
       else
	  self:buffer:=newState
       endif
       self:display()
return self

*************************************
static func setFocus(self)
       self:hasFocus:=.t.
       self:display()
return self

*************************************
static func __setcolor()
       ::__colors:=__splitColors(::colorSpec)
return NIL

