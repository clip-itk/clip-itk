/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "set.ch"
#include "lang.ch"
#include "getexit.ch"
#include "date.ch"
#include "config.ch"

function TEXTGETNEW(row,col,bottom,right,block,varname,color,var,vblock,wblock)
  local obj
  obj:=map()
  obj:classname	:="TEXTGET"
  obj:block	:=block

  obj:buffer	:=NIL
  obj:original	:=NIL
  obj:cargo	:=NIL
  obj:changed	:=.f.
  obj:clear	:=.f.
  obj:col	:=col
  obj:row	:=row
  obj:bottom	:=bottom
  obj:right	:=right
  obj:colorSpec	:=iif(color==NIL,setcolor(),color)
  obj:decpos	:=0
  obj:exitState	:=GE_NOEXIT
  obj:hasFocus	:=.f.
  obj:minus	:=.f.
  obj:name	:=varname
  obj:picture	:=NIL
  obj:pos	:=1
  obj:postBlock	:=vblock
  obj:preBlock	:=wblock
  obj:reader	:=NIL
  obj:rejected	:=.f.
  obj:subscript	:=NIL
  obj:type	:="U"
  obj:caption	:=NIL
  obj:capRow	:=NIL
  obj:capCol	:=NIL
  obj:typeOut	:=.f.

  obj:__colors	:={}

  _recover_textget(obj)

  obj:__setcolor()

  obj:__firstKey:=.f.   // pressed first key/metod

  obj:edit:=textEditNew(row, col, bottom, Right, obj:colorSpec)
  obj:setFocus()
  obj:killFocus()

return obj

**********************************************
function _recover_textget(obj)
  obj:badDate	:= @badDate()
  obj:assign 	:= @assign()
  obj:colorDisp := @colorDisp()
  obj:display 	:= @display()
  obj:killFocus := @killFocus()
  obj:setFocus 	:= @setFocus()
  obj:reset 	:= @reset()
  obj:undo 	:= @setFocus()
  obj:updateBuffer := @setFocus()
  obj:varGet 	:= @varGet()
  obj:varPut 	:= @varPut()

  obj:end 	:= @cur_end()
  obj:home 	:= @cur_home()
  obj:left 	:= @cur_left()
  obj:right 	:= @cur_right()
  obj:gotoPos 	:= @cur_goto()
  obj:toDecPos 	:= @toDecPos()
  obj:wordLeft 	:= @wordLeft()
  obj:wordRight	:= @wordRight()

  obj:backSpace	:= @backSpace()
  obj:delLeft	:= @backSpace()
  obj:delRight	:= @delRight()
  obj:delete	:= @delRight()
  obj:delEnd       := @delEnd()
  obj:delWordLeft  := @delWordLeft()
  obj:delWordRight := @delWordRight()

  obj:Insert 	:= @Insert()
  obj:InsertLine:= @InsertLine()
  obj:up	:= @cur_up()
  obj:down	:= @cur_down()
  obj:pgUp	:= @cur_pgUp()
  obj:pgDn	:= @cur_pgDn()
  obj:overStrike:= @overStrike()
  obj:__setColor:= @__setcolor()
return obj

**********************************************
static function badDate()
return .f.

**********************************************
static func assign()
 local changed:=::changed
 if ::changed .and. ::type $ GETS_TYPES
    eval(::block,::edit:saveString())
    ::setFocus()
    ::changed:=changed
 endif
return NIL

**********************************************
static func colorDisp (color)
  if color!=NIL
     ::colorSpec:=color
  endif
  ::__setcolor()
  ::edit:setColor(::colorSpec)
  ::display()
return ::classname

**********************************************
static func killFocus()
  set("__varname","")
  ::hasFocus:=.f.
  ::reset()
  ::display()
return NIL

**********************************************
static func setFocus()
  local v
  set("__varname",::name)
  ::reset()
  ::hasFocus:=.t.
  ::original:=eval(::block)
  ::type:=valtype(::original)
  ::edit:loadString(::original)
  ::display()
return NIL

**********************************************
static func reset(obj)
  if obj:hasFocus
     obj:pos:=1
     obj:reader:=NIL
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
if ::type $ GETS_TYPES
   return eval(::block)
endif
return ::original

**********************************************
static func varPut(value)
if ::type $ GETS_TYPES
   return eval(::block,value)
   ::edit:loadString(value)
endif
return ::original

**********************************************
static func cur_end()
  ::__firstKey:=.t.
  ::edit:end()
  ::display()
return NIL

**********************************************
static func cur_home()
  ::__firstKey:=.t.
  ::edit:home()
  ::display()
return NIL

**********************************************
static func cur_left()
  ::__firstKey:=.t.
  ::edit:left()
  ::display()
return NIL

**********************************************
static func cur_right()
   ::__firstKey:=.t.
   ::edit:right()
   ::display()
return NIL

**********************************************
static func cur_goto(pos)
   ::__firstKey:=.t.
   ::display()
return NIL

**********************************************
static func toDecPos()
   ::__firstKey:=.t.
   ::display()
return NIL

**********************************************
static func wordLeft()
   ::__firstKey:=.t.
   ::edit:wordLeft()
   ::display()
return NIL

**********************************************
static func wordRight()
   ::__firstKey:=.t.
   ::edit:wordRight()
   ::display()
return NIL


**********************************************
static func backSpace()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:backSpace()
   ::display()
return NIL

**********************************************
static func delRight()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:delRight()
   ::display()
return NIL

**********************************************
static func delEnd()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:delEnd()
   ::display()
return NIL

**********************************************
static func delWordLeft()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:delWordLeft()
   ::display()
return NIL

**********************************************
static func delWordRight()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:delWordRight()
   ::display()
return NIL


**********************************************
static func Insert(sym)
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:Insert(sym)
   ::display()
return NIL

**********************************************
static func InsertLine()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:InsertLine()
   ::display()
return NIL

**********************************************
static func cur_up()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:up()
   ::display()
return NIL

**********************************************
static func cur_down()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:down()
   ::display()
return NIL

**********************************************
static func cur_pgUp()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:pageUp()
   ::display()
return NIL
**********************************************
static func cur_pgDn()
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:pageDown()
   ::display()
return NIL

**********************************************
static func overStrike(sym)
   ::__firstKey:=.t.
   ::changed:=.t.
   ::edit:overStrike(sym)
   ::display()
return NIL

**********************************************
static func __setcolor()
       ::__colors:=__splitColors(::colorSpec)
return NIL

**********************************************
static func display ()
	::edit:refresh()
return NIL
