/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "button.ch"
#include "setcurs.ch"

function _pushbutt_(caption,message,color,fblock,sblock,style,;
                    sizex,sizey,capxoff,capyoff,bitmap,bmpxoff,;
                    bmpyoff,row,col)
   local obj
   obj:=pushButton(row,col,caption)
   obj:buffer	:=.f.
   obj:fblock	:=fblock
   obj:sblock	:=sblock
   obj:message	:=message
   obj:sizex	:=sizex
   obj:sizey	:=sizey
   obj:capxoff	:=capxoff
   obj:capyoff	:=capyoff
   obj:bitmap	:=bitmap
   obj:bmpxoff	:=bmpxoff
   obj:bmpyoff	:=bmpyoff
   if style!=NIL
      obj:style:=style
   endif
   obj:colorSpec:=iif(empty(color),setcolor(),color)
   obj:__setcolor()
   obj:display()
return obj


function pushButton(nrow,ncol,caption)
   local obj
   obj:=map()
   obj:classname:="PUSHBUTTON"
   obj:bitmap	:=NIL
   obj:bmpXOff	:=NIL
   obj:bmpYOff	:=NIL
   obj:buffer	:=.f.
   obj:caption	:=caption
   obj:capRow	:=nrow
   obj:capcol	:=ncol
   obj:capXOff	:=NIL
   obj:capYOff	:=NIL
   obj:cargo	:=NIL
   obj:col	:=ncol
   obj:colorSpec:=setcolor()
   obj:fblock	:=NIL
   obj:hasFocus	:=.f.
   obj:message	:=""
   obj:row	:=nrow
   obj:sblock	:=NIL
   obj:sizeX	:=NIL
   obj:sizeY	:=NIL
   obj:style	:="<>"
   obj:typeOut	:=.f.

   //obj:capCol	:=ncol+4
   //obj:capRow	:=nrow


   obj:__cursor	:=setcursor()
   obj:__colors	:={}

   obj:winbuffer := nil

   _recover_pushbutton(obj)

   obj:__setcolor()

return obj

*************************************
function _recover_pushbutton(obj)
   obj:display	:=@pb_display()
   obj:hitTest	:=@hitTest()
   obj:killFocus:=@killFocus()
   obj:select	:=@pb_select()
   obj:setFocus	:=@setFocus()
   obj:__setColor:=@__setcolor()
return obj

*************************************
static func pb_display(self)
      local pal,s
      pal:=self:__colors[iif(self:hasFocus,2,1)]
      if self:style==NIL
         	if self:winbuffer == nil
         		@ self:row, self:col TO self:row+2, self:col+1+__capLength(self:caption) ;
           			color pal
		else
         		winbuf_dispbox(self:winbuffer, self:row, self:col, ;
         		self:row+2, self:col+1+__capLength(self:caption), 1, pal)
		endif
         	__sayCaption( self:Row+1, self:Col+1, self:caption, pal,,self:__colors[4],self:winbuffer)
      else
      	if len(self:style)<=2
         	s=substr(self:style,1,1)+self:caption+substr(self:style,2,1)
         	__sayCaption( self:Row, self:Col, s, pal,,self:__colors[4],self:winbuffer)
         	if self:winbuffer == nil
	         	dispOutAt(self:row, self:col+1, "")
      		endif
      	else
         	if self:winbuffer == nil
         		@ self:row, self:col, self:row+2, self:col+1+__capLength(self:caption) ;
           		box self:style color pal
         	else
         		winbuf_dispbox(self:row, self:col, self:row+2, ;
         		self:col+1+__capLength(self:caption), self:style, pal)
         	endif
         	__sayCaption( self:Row+1, self:Col+1, self:caption, pal,,self:__colors[4],self:winbuffer)
      	endif
      endif
return self

*************************************
static func hitTest(mouseRow,mouseCol)
    local ret:=HTNOWHERE
    if mouseRow==::capRow
	  if mouseCol>=::capCol .and. mouseCol<=::capCol+len(::caption)
	     ret=HTCAPTION
	  endif
    endif
return ret

*************************************
static func killFocus(self)
   if self:hasFocus
      setcursor(self:__cursor)
      self:hasFocus:=.f.
      self:display()
   endif
   if self:fblock!=NIL
       eval(self:fblock)
   endif
return self

*************************************
static func pb_select(self,newState)
       if newstate==NIL
	  self:buffer:=.t.
       	  eval(self:sblock)
       else
	  self:buffer:=newState
       endif
       self:display()
return self

*************************************
static func setFocus(self)
       self:__cursor:=setcursor(SC_NONE)
       self:hasFocus:=.t.
       self:display()
return self

*************************************
static func __setcolor()
       ::__colors:=__splitColors(::colorSpec)
return NIL

