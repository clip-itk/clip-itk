/*
    Copyright (C) 2001  ITK
    Author   : Alena (alena@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "inkey.ch"
#include "box.ch"

function historyObj(Lrow, Lcol, Rrow, Rcol, color)
local obj
       obj:=map()
       obj:classname    := "HISTORYOBJECT"
       obj:Lrow         := iif(Lrow==NIL, 1, Lrow)
       obj:Lcol         := iif(Lcol==NIL, 1, Lcol)
       obj:Rrow         := iif(Rrow==NIL, maxrow(), Rrow)
       obj:Rcol         := iif(Rcol==NIL, maxcol(), Rcol)

       obj:history	:= {}
       obj:size		:= 0
       obj:header	:= ""

       obj:insert	:= @insert()
       obj:add		:= @add()
       obj:delete	:= @delete()
       obj:run		:= @run()
       obj:setsize	:= @setsize()
       obj:first	:= @first()
       obj:set		:= @set()

       obj:colorSpec    := iif(empty(color),setcolor(),color)
       obj:__colors 	:= {}      // палитры цветов
       obj:__setColor 	:= @__setcolor()
       obj:__setcolor()
return obj

***********
static function __setcolor()
local i, s
       s:=::colorSpec
       while len(s)>0
	   i:=at(",",s)
	   i=iif(i==0,len(s)+1,i)
	   aadd(::__colors,substr(s,1,i-1) )
	   s:=substr(s,i+1)
       enddo
return

***********
static function setsize(size)
	asize(::history, size)
return

***********
static function set(arr, size)
local i, len
	asize(::history, 0)
	len := len(arr)
	for i:=1 to len
		aadd(::history, arr[i])
	next
	if size == NIL
		::size := len(::history)
	else
		::size := size
		asize(::history, ::size)
	endif
return

***********
static function delete(string)
local i, f:=.f.
	string := alltrim(string)
	for i:=1 to len(::history)
		if ::history[i] == NIL
			exit
		endif
		if alltrim(::history[i]) == string
			adel(::history, i)
			f := .t.
			exit
		endif
	next
return f

***********
static function insert(string)
	::delete(string)
	if len(::history)>1
		ains(::history, 1)
	else
		::setsize(10)
	endif
	::history[1] := string
return

***********
static function first()
local ret := ""
	if len(::history) == 0
		return ret
	endif
	if ::history[1] != NIL
		ret := ::history[1]
	endif
return ret

***********
static function add(string)
	aadd(::history, string)
return

***********
static function run(current, retitem)
local ret:="", lb, nkey:=1, length, scr, s, i

current := iif(current == NIL, 1, current)
retitem := iif(retitem == NIL, .t., .f.)
s := setcolor(::colorSpec)
save screen to scr
length := ::Rcol-::Lcol-4
@ ::Lrow, ::Lcol clear to ::Rrow, ::Rcol
@ ::Lrow, ::Lcol TO ::Rrow, ::Rcol color ::colorSpec
if !empty(::header)
	i := int(3*(::Rcol-::Lcol)/4)
	@ ::Lrow, ::Lcol+(i-len(::header))/2 say ::header
endif
lb := listitemnew(::Lrow+1, ::Lcol+1, ::Rrow-1, ::Rcol, 1, "", ::colorSpec)
for i=1 to len(::history)
	if ::history[i] != NIL
		lb:addItem(padr(::history[i], length))
	endif
next
lb:setFocus()
lb:setItem(current)
while nkey != 0
	nkey := inkey(0)
	do case
	case nkey == K_ESC
		if retitem
			ret := ""
		else
			ret := 0
		endif
		nkey := 0
	case nkey == K_ENTER
		if lb:itemCount>0
			ret := iif(retitem, rtrim(::history[lb:buffer]), lb:buffer)
		endif
		nkey := 0
	case nkey == K_DOWN
		lb:Down()
	case nkey == K_UP
		lb:Up()
	case nkey == K_HOME
		lb:Home()
	case nkey == K_HOME
		lb:End()
	endcase
enddo
setcolor(s)
restore screen from scr
return ret
