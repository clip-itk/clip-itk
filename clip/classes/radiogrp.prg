/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "button.ch"
#include "box.ch"
#include "setcurs.ch"

function _radiogrp_(top,left,bottom,right,var,buttons,caption,message,color,;
		    fblock,style)
   local i,obj
   obj:=radioGroup(top,left,bottom,right)
   obj:message	:=message
   obj:caption	:=caption
   obj:fblock	:=fblock
   for i=1 to len(buttons)
       obj:addItem(buttons[i])
   next
   obj:__setvalue(1)
   if style!=NIL
      obj:setStyle(style)
   endif
   if valtype(var)=="N"
      	obj:__setvalue(var)
   else
        //obj:value:=iif(obj:typeOut,1,0)
	for i=1 to len(obj:__items)
               	if valtype(obj:__items[i]:rvalue) == valtype(var) ;
        	               	.and. obj:__items[i]:rvalue == var

			obj:__setValue(i)
                endif

	next
   endif
   if obj:value!=0
      obj:__items[obj:value]:buffer:=.t.
      obj:__items[obj:value]:setFocus()
   endif

   obj:colorSpec:=iif(empty(color),setcolor(),color)
   obj:__setcolor()
   obj:display(.f.)
return obj

**********************************************
function radioGroup(top,left,bottom,right)
   local obj
   obj:=map()
   obj:classname:="RADIOGROUP"
   obj:bottom	:=bottom
   obj:buffer	:=0       // почему-то в описании стоит buffer,а
   obj:value	:=0        // почему-то в описании стоит buffer,а
			   // в getsys.prg - value ??????
   obj:capRow	:=top
   obj:capCol	:=left+2
   obj:caption	:=NIL
   obj:cargo	:=NIL
   obj:sayBox	:=.t.
   obj:coldbox	:=NIL //B_SINGLE+" "
   obj:colorSpec:=setcolor()
   obj:fblock	:=NIL
   obj:hasFocus	:=.f.
   obj:hotBox	:=NIL //B_DOUBLE+" "
   obj:itemCount:=0
   obj:left	:=left
   obj:message	:=""
   obj:right	:=right
   obj:top	:=top
   obj:typeOut	:=.t.


   obj:__items	:={}
   obj:__cursor	:= setcolor()
   obj:__colors:={}

   _recover_radiogroup(obj)

   obj:__setcolor()

return obj
*************************************
function _recover_radiogroup(obj)
   obj:addItem	:=@rg_addItem()
   obj:delItem	:=@rg_delItem()
   obj:display	:=@rg_display()
   obj:getAccel	:=@rg_getAccel()
   obj:getItem	:=@rg_getItem()
   obj:hitTest	:=@hitTest()
   obj:insItem	:=@rg_insItem()
   obj:killFocus:=@killFocus()
   obj:prevItem	:=@rg_prevItem()
   obj:nextItem	:=@rg_nextItem()
   obj:select	:=@rg_select()
   obj:setcolor	:=@rg_setcolor()
   obj:setFocus	:=@setFocus()
   obj:setstyle	:=@rg_setstyle()
   obj:__setColor:=@__setcolor()
   obj:__setValue:=@rg_setValue()
return obj
*************************************
static func rg_setValue(self,newValue)
	if newValue >0 .and. newValue <=len(self:__items)
                if valtype(self:__items[newValue]:rValue) != NIL
                	self:buffer := self:__items[newValue]:rValue
                else
                	self:buffer := newValue
                endif
                self:value := newValue
        else
        	self:value := 0
        	self:buffer := 0
        endif
*************************************
static func rg_addItem(self,obj_rb)
   aadd(self:__items,obj_rb)
   self:itemCount++
   self:typeOut:=.f.
   //self:display()
return self

*************************************
static func rg_delItem(self,pos)
   adel(self:__items,pos)
   self:itemCount:=max(len(self:__items)-1,0)
   if self:itemCount==0
      self:typeOut:=.t.
   endif
   asize(self:__items,self:itemCount)
return self

*************************************
static func rg_getItem(pos)
return ::__items[pos]

*************************************
static func rg_insItem(self,pos,obj_rb)
   self:itemCount++
   asize(self:__items,self:itemCount)
   ains(self:__items,pos,obj_rb)
   self:typeOut:=.f.
   self:display()
return self

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
static func rg_nextItem(self)
    if self:value>0 .and. self:value<=self:itemCount
       self:__items[self:value]:select(.f.)
       self:__items[self:value]:killFocus()
    endif
    self:value++
    self:value:=min(self:itemCount,self:value)
    self:__setValue(self:value)
    if self:value>0 .and. self:value<=self:itemCount
       self:__items[self:value]:select(.t.)
       self:__items[self:value]:setFocus()
    endif
    self:display()
return self

*************************************
static func rg_prevItem(self)
    if self:value>0 .and. self:value<=self:itemCount
       self:__items[self:value]:select(.f.)
       self:__items[self:value]:killFocus()
    endif
    self:value--
    self:value:=max(1,self:value)
    self:__setValue(self:value)
    if self:value>0 .and. self:value<=self:itemCount
       self:__items[self:value]:select(.t.)
       self:__items[self:value]:setFocus()
    endif
    self:display()
return self

*************************************
static func rg_select(self,newState)
	local i
       if newstate!=NIL
          if valtype(newState) == "N"
    		self:__setValue(newState)
          else
		for i=1 to len(self:__items)
                	if valtype(self:__items[i]:rvalue) == valtype(newState) ;
                        	.and. self:__items[i]:rvalue == newState

    				self:__setValue(i)
                        endif

		next
          endif
       endif
       self:display()
return self

*************************************
static func rg_setColor(self,newcolor)
       if newcolor!=NIL
	  self:colorSpec:=newColor
	  self:__setcolor()
	  self:display()
       endif
return self

*************************************
static func setFocus(self)
       self:__cursor:=setcursor(SC_NONE)
       self:hasFocus:=.t.
       self:display()
return self

*************************************
static func __setcolor()
       local i
       ::__colors:=__splitColors(::colorSpec)
       for i=len(::__colors) to 7
	   aadd(::__colors,"W+/B")
       next
return NIL

*************************************
static func rg_setStyle(self,newStyle)
       local i
       if newStyle==NIL
	  return self
       endif
       for i=1 to self:itemCount
	   self:__items[i]:style:=newStyle
       next
       self:display()
return self

*************************************
static func rg_display(self, sb)
      local i,pal,s
      pal:=self:__colors[iif(self:hasFocus,2,1)]
      sb := iif(sb==NIL, .t., sb)
      dispbegin()
      if sb
      		if self:hasFocus
                	if self:hotBox!=NIL
	 			@ self:top, self:left, self:bottom, self:right;
	 			box self:Hotbox color self:__colors[1]
                        else
	 			@ self:top, self:left TO self:bottom, self:right;
	 			DOUBLE color self:__colors[1]
                        endif
                else
                	if self:coldBox!=NIL
	 			@ self:top, self:left, self:bottom, self:right;
	 			box self:coldBox color self:__colors[1]
                        else
	 			@ self:top, self:left TO self:bottom, self:right;
	 			color self:__colors[1]
                        endif

                endif
      endif
      if self:caption!=NIL
	 dispOutAt(self:top, self:left+2, self:caption, pal)
      endif
      for i=1 to self:itemCount
	  self:__items[i]:display()
      next
      if self:value>0 .and. self:value<=self:itemCount
	self:__items[self:value]:display()
      endif
      dispend()
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
static func rg_getAccel(nkey)
    local i
    for i=1 to ::itemCount
	if ::__items[i]:isAccel(nkey)
	   return i
	endif
    next
return 0


