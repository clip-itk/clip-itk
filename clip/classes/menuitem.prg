/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

function menuitem(caption,data,shortcut,message,id)
   local obj

   if caption==NIL
      return NIL
   endif

   obj:=map()
   obj:className:= "MENUITEM"
   obj:caption	:= caption
   obj:cargo	:= NIL
   obj:checked	:= .f.
   obj:data	:= data
   obj:enabled	:= .t.
   obj:disabled	:= .f.
   obj:id	:= iif(valtype(id)=="N",id,0)
   obj:message	:= iif(message==NIL,"",message)
   obj:shortcut	:= iif(valtype(shortcut)=="N",shortcut,0)

#ifdef __UNIX__
   obj:style	:= "*>"
#else
   obj:style	:= "–"+chr(16)
#endif

   _recover_menuitem(obj)
return obj

*********************************
function _recover_menuitem(obj)
   obj:isPopUp	:= @__isPopUp()
   obj:isAccel	:= @mi_isAccel()
   obj:_status	:= @mi_status()
return obj

*********************************
static func mi_isAccel(nkey)
    local s,ret:=.f.
    s=lower("&"+chr(nkey))
    ret=s $ lower(::caption)
return ret

*********************************
static func __isPopUp
       local ret:=.f.
       if valtype(::data)=="O" .and. ::data:classname=="POPUPMENU"
          ret:=.t.
       endif
return ret

*********************************
static func mi_status(self,member,id,newValue)
	local ret
        if valtype(self:data)=="O" .and. self:data:classname=="POPUPMENU"
        	return self:data:_status(member,id,NewValue)
        endif
        if id==self:id .and. member $ self
        	ret:=self[member]
                if newValue!=NIL
                	self[member] := newValue
                endif
        endif
return ret
