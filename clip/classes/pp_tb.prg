/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "box.ch"
#include "button.ch"

function topbar(nrow,nleft,nright)
  local obj
  if nrow==NIL .or. nleft==NIL .or. nright==NIL
     return NIL
  endif
  obj		:= map()
  obj:className	:= "TOPBARMENU"
  obj:cargo	:= NIL
  obj:colorSpec	:= setcolor()
  obj:current	:= 0
  obj:itemCount	:= 0
#ifdef 1
  obj:left	:= iif(nleft==NIL,0,nleft)
  obj:right	:= iif(nright==NIL,maxcol(),nright)
  obj:row	:= iif(nrow==NIL,0,nrow)
#else
  obj:left	:= nleft
  obj:right	:= nright
  obj:row	:= nrow
#endif
  obj:width	:= 0
  obj:__begItem := 0

  _recover_topbarmenu(obj)

  obj:__items	:= {}
  obj:__colors	:= {}

return obj
******************************************
function _recover_topbarmenu(obj)
  obj:additem	:= @m_additem()
  obj:delItem	:= @m_delItem()
  obj:insItem	:= @m_insItem()
  obj:getAccel	:= @m_getAccel()
  obj:getFirst	:= @m_getFirst()
  obj:getItem	:= @m_getitem()
  obj:setItem	:= @m_setitem()
  obj:getLast	:= @m_getLast()
  obj:getNext	:= @m_getNext()
  obj:getPrev	:= @m_getPrev()
  obj:select	:= @m_select()
  obj:display	:= @tb_display()
  obj:hittest	:= @tb_hittest()
  obj:getShortct:= @pp_Shortct()
  obj:enableStatus	:= @tb_Estatus()
  obj:disableStatus	:= @tb_Dstatus()
  obj:_Status	:= @m__status()
return obj

******************************************
function popup(ntop,nleft,nbottom,nright)
  local obj

  obj		:= map()
  obj:classname	:= "POPUPMENU"
  obj:border	:= NIL //B_SINGLE+" "+SEPARATOR_SINGLE
  obj:bottom	:= nbottom
  obj:cargo	:= NIL
  obj:colorSpec	:= setcolor()
  obj:current	:= 0
  obj:__begItem	:= 1 // for scrolling items up/down
  obj:itemCount	:= 0
  obj:left	:= nleft
  obj:right	:= nright
  obj:top	:= ntop
  obj:width	:= 0
  obj:isopen    := .f.

  _recover_popupmenu(obj)

  obj:__items	:= {}
  obj:__colors	:= {}
  obj:__scr	:= NIL

return obj

******************************************
function _recover_popupmenu(obj)
  obj:additem	:= @m_additem()
  obj:delItem	:= @m_delItem()
  obj:insItem	:= @m_insItem()
  obj:getAccel	:= @m_getAccel()
  obj:getFirst	:= @m_getFirst()
  obj:getItem	:= @m_getItem()
  obj:setItem	:= @m_setItem()
  obj:getLast	:= @m_getLast()
  obj:getNext	:= @m_getNext()
  obj:getPrev	:= @m_getPrev()
  obj:select	:= @m_select()
  obj:display	:= @pp_display()
  obj:hittest	:= @pp_hittest()
  obj:close	:= @pp_close()
  obj:open	:= @pp_open()
  obj:getShortct:= @pp_Shortct()
  obj:__resize	:= @__resize()
  obj:enableStatus	:= @pp_Estatus()
  obj:disableStatus	:= @pp_Dstatus()
  obj:_Status	:= @m__status()
return obj

******************************************
static func m_addItem(self,omenu)
       if valtype(omenu)=="O" //.and. omenu:classname=="MENUITEM"
	  aadd(self:__items,omenu)
	  self:itemCount++
       endif
return self

******************************************
static func m_delItem(self,npos)
       if npos>0 .and. npos<=self:itemCount
	  adel(self:__items,npos)
	  self:itemCount--
       endif
return self

******************************************
static func m_insItem(self,npos,omenu)
       if npos>0 .and. npos<=self:itemCount
	  //if valtype(omenu)=="O" //.and. omenu:classname=="MENUITEM"
	     asize(self:__items,len(self:__items)+1)
	     self:__items[npos]:=omenu
	     self:itemCount++
	 //    self:width:=max(self:width,__capLength(omenu:caption))
	  //endif
       endif
return self

******************************************
static func m_getAccel(nkey)
    local i
    for i=1 to ::itemCount
	if ::__items[i]:isAccel(nkey)
	   return i
	endif
    next
return 0

******************************************
static func m_getFirst()
       local i
       for i=1 to ::itemCount
	   if ::__items[i]:enabled .and. !::__items[i]:disabled  .and. ::__items[i]:caption!=MENU_SEPARATOR
	      return i
	   endif
       next
return 0

******************************************
static func m_getNext()
       local i
       for i=::current+1 to ::itemCount
	   if ::__items[i]:enabled .and. !::__items[i]:disabled   .and. ::__items[i]:caption!=MENU_SEPARATOR
	      return i
	   endif
       next
return 0

******************************************
static func m_getLast()
       local i:=::itemCount
       while i>=1
	   if ::__items[i]:enabled .and. !::__items[i]:disabled   .and. ::__items[i]:caption!=MENU_SEPARATOR
	      return i
	   endif
	   i--
       enddo
return 0

******************************************
static func m_getPrev()
       local i:=::current-1
       while i>=1
	   if ::__items[i]:enabled .and. !::__items[i]:disabled  .and. ::__items[i]:caption!=MENU_SEPARATOR
	      return i
	   endif
	   i--
       enddo
return 0

******************************************
static func m_getItem(npos)
   local ret:=NIL
   if npos>0 .and. npos<=::itemCount
      ret := ::__items[npos]
   endif
return ret

******************************************
static func m_setItem(self,npos,omenu)
       if npos>0 .and. npos<=self:itemCount
	  if valtype(omenu)=="O" //.and. omenu:classname=="MENUITEM"
	     self:__items[npos]:=omenu
	     self:width:=max(self:width,__capLength(omenu:caption))
	  endif
       endif
return self

******************************************
static func m_select(self, npos)
   if npos>=0 .and. npos<=self:itemCount
      self:current:=npos
   endif
return self

******************************************
static func pp_open(self)
   if !self:isopen
      self:__scr:=savescreen(self:top,self:left,self:bottom,self:right)
      self:isopen:=.t.
      //self:current:=self:getFirst()
      self:display()
   endif
return self

******************************************
static func pp_close(self)
  if self:isopen
     restscreen(self:top,self:left,self:bottom,self:right,self:__scr)
     self:isopen:=.f.
     //self:current:=0
     self:__begItem:=1
  endif
return self

******************************************
static func pp_shortct(nkey)
   local i
   for i=1 to ::itemCount
	if (`SHORTCUT` $ ::__items[i]) .and. ::__items[i]:shortcut==nkey
	    return i
	endif
   next
return 0

******************************************
static func tb_display(self)
  local x,first:=.f.,i,xpos:=self:left,item
  dispbegin()
  if empty(self:__colors)
     self:__colors:=__splitColors(self:colorSpec)
     first:=.t.
  endif
  x:=self:right
  for i=self:current to 1 step -1
      item:=self:__items[i]
      x-=__capLength(item:caption)+2
  next
  i:=1
  for i=1 to self:itemCount
      if x>=self:left
	 exit
      endif
      item:=self:__items[i]
      x+=__capLength(item:caption)+2
  next
  self:__begItem:=i

  dispOutAt(self:row, self:left, space(self:right-self:left+1), self:colorSpec )
  for i=self:__begitem to self:itemCount
      item:=self:__items[i]
      __sayCaption(self:row,xpos," "+item:caption+" ",;
		   self:__colors[iif(self:current==i,2,1)],NIL, ;
		   self:__colors[iif(self:current==i,4,3)]  )
      if first .and. valtype(item)=="O" .and. valtype(item:data)=="O" .and.  item:data:classname=="POPUPMENU"
	 item:data:__resize(self:row+1,xpos)
      endif
      if xpos>self:right
		exit
      endif
      xpos+=__capLength(item:caption)+2
  next
  dispend()
return self

******************************************
static func pp_display(self)
    local i,s,pal,pal2,item,first:=.f.,x,y,sSep
    if empty(self:__colors)
       self:__colors:=__splitColors(self:colorSpec)
       first:=.t.
    endif
    if !self:isopen .or. self:current==0
	return self
    endif
    dispbegin()
    if self:border == NIL
	sSep:=SEPARATOR_SINGLE
	@ self:top,self:left TO self:bottom,self:right ;
	   color self:__colors[6]
    else
	sSep:=substr(self:border,10)
	@ self:top,self:left,self:bottom,self:right ;
	   box substr(self:border,1,8) color self:__colors[6]
    endif
    self:__begItem:=  (self:top+self:current) - (maxrow()-2)+1
    if self:__begItem < 1
	self:__begItem:=1
    endif
    for i=self:__begItem to self:itemCount
	x:=self:top+i-self:__begItem+1
	if x > maxrow()-2
		exit
	endif
	item:=self:__items[i]
	if item:caption==MENU_SEPARATOR
	   s=substr(sSep,1,1)+;
	     replicate(substr(sSep,2,1),self:width+2)+;
	     substr(sSep,3,1)
	   dispOutAt(x, self:left, s, self:__colors[6])
	else
	   pal:=iif(self:current==i,2,1)
	   pal2:=iif(self:current==i,4,3)
	   pal:=iif(item:enabled .and. !item:disabled,pal,5)
	   pal2:=iif(item:enabled .and. !item:disabled,pal2,pal)
	   s:=iif(item:checked,substr(item:style,1,1)," ")
	   if first .and. valtype(item:data)=="O" .and.  item:data:classname=="POPUPMENU"
	      item:data:__resize(self:top+i,self:left+self:width+3)
	   endif
	   __sayCaption(x, self:left+1,;
			s+item:caption,;
			self:__colors[pal],self:width+2,self:__colors[pal2])
	   if valtype(item:data)=="O"
	      dispOutAt(x,self:left+self:width+2, substr(item:style,2,1), ;
			   self:__colors[pal] )
	   endif
	endif
    next
    dispend()
return self


******************************************
static func __resize(nrow,ncol)
    local i
    for i=1 to ::itemCount
	::width=max(::width,__capLength(::__items[i]:caption))
    next
    ::top:=nrow
    ::left:=ncol
    ::right :=::left+::width+3
    i:=::right-maxcol()
    if i>0
	::right-=i
	::left-=i
    endif
    ::bottom:=min(::top+::itemCount+1,maxrow()-1)

return ::itemCount

******************************************
static func pp_hitTest(mrow,mcol)
	local ret:=0,i,x,item
	if ! ( mCol>::left .and. mCol < (::left+::width)+2 )
		return 0
	endif
	for i=::__begItem to ::itemCount
		x:=::top+i-::__begItem+1
		item:=::__items[i]
		if item:caption!=MENU_SEPARATOR
			if x==mRow
				ret:=i
				exit
			endif
		endif
	next
return ret
******************************************
static func tb_hitTest(mrow,mcol)
	local ret:=0,i,j,xpos:=::left,item
	if mRow != ::row
		return 0
	endif
	for i=::__begitem to ::itemCount
		item:=::__items[i]
		j:=xpos+__capLength(item:caption)+2
		if mcol > xpos .and. mcol < j
			ret:=i
		endif
		if xpos>::right
			exit
		endif
		xpos+=__capLength(item:caption)+2
	next
return ret

******************************************
static function tb_Estatus(self,id,Newvalue)
return	self:_status("ENABLED",id,Newvalue)
******************************************
static function tb_Dstatus(self,id,Newvalue)
return	self:_status("DISABLED",id,Newvalue)
******************************************
static function pp_Estatus(self,id,Newvalue)
return	self:_status("ENABLED",id,Newvalue)
******************************************
static function pp_Dstatus(self,id,Newvalue)
return	self:_status("DISABLED",id,Newvalue)
******************************************
static function m__status(self,member,id,newValue)
	local o,ret
	for o in self:__items
		if valtype(o)=="O"
			ret := o:_status(member,id,newValue)
		endif
		if ret!=NIL
			exit
		endif
	next
return ret
