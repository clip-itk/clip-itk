/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "button.ch"
#include "setcurs.ch"

function _checkbox_(var,caption,message,color,fblock,sblock,style,bitmaps,row,col)
   local obj
   iif(row==NIL, row:=row(), NIL)
   iif(col==NIL, col:=col(), NIL)
   obj:=checkbox(row,col,caption)
   obj:buffer:=var
   obj:fblock:=fblock
   obj:sblock:=sblock
   obj:bitmaps:=bitmaps
   obj:message:=message
   if style!=NIL
      obj:style:=style
   endif
   obj:colorSpec:=iif(empty(color),setcolor(),color)
   obj:__setcolor()
   obj:display()
return obj


function checkbox(nrow,ncol,caption)
   local obj
   obj:=map()
   obj:classname:="CHECKBOX"
   obj:bitmaps	:=NIL
   obj:col	:=ncol
   obj:row	:=nrow
   obj:buffer	:=.f.
   obj:capCol	:=ncol+4
   obj:capRow	:=nrow
   obj:caption	:=caption
   obj:cargo	:=NIL
   obj:colorSpec:=setcolor()
   obj:fblock	:=NIL
   obj:hasFocus	:=.f.
   obj:message	:=""
   obj:sblock	:=NIL
   obj:style	:="[X ]"
   obj:typeOut	:=.f.
   obj:__colors	:={}

   _recover_checkbox(obj)

   obj:__cursor :=setcursor()
   obj:__setcolor()

return obj

*************************************
function _recover_checkbox(obj)
   obj:display	:=@cb_display()
   obj:hitTest	:=@hitTest()
   obj:killFocus:=@killFocus()
   obj:select	:=@cb_select()
   obj:setFocus	:=@setFocus()
   obj:__setColor:=@__setcolor()
return obj

*************************************
static func cb_display(self)
      local pal
      pal:=self:__colors[iif(self:hasFocus,2,1)]
       dispOutAt(self:row, self:col, substr(self:style,1,1)+" "+substr(self:style,4,1),self:__colors[3] )
      dispOutAt(self:row, self:col+1, substr(self:style,iif(self:buffer,2,3),1), pal)
      __sayCaption( self:capRow, self:capCol, self:caption, pal,,self:__colors[4] )
      dispOutAt(self:row, self:col+1, "" )
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
static func killFocus(self)
   if self:hasFocus
      setCursor(self:__cursor)
      self:hasFocus:=.f.
      self:display()
   endif
   if self:fblock!=NIL
       eval(self:fblock)
   endif
return self

*************************************
static func cb_select(self,newState)
       if newstate==NIL
	  self:buffer:=!self:buffer
	  eval(self:sblock)
       elseif valtype(newState) == "L"
	  self:buffer:=newState
       endif
       self:display()
return self

*************************************
static func setFocus(self)
       self:hasFocus:=.t.
       self:__cursor:=setCursor(SC_NONE)
       self:display()
return self

*************************************
static func __setcolor()
       ::__colors:=__splitColors(::colorSpec)
       dispOutAt(::row, ::col, substr(::style,1,1) )
       dispOutAt(::row, ::col+2, substr(::style,4,1)+" " )
return NIL

