/*
    Copyright (C) 2001  ITK
    Author   : Alena (alena@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "inkey.ch"
/*
color "1,     2, 3, 4, 5, 6"
1- border, item
2- current item in focus
3- current item out of focus
4- title
5- selected item
6- current selected item
7- found symbols
*/
#define LI_EXIT			-1
#define LI_CONTINUE		0
#define LI_EXCEPTION		1

function listItemNew(Lrow, Lcol, Rrow, Rcol, Columns, Delimiter, color)
local obj
       obj:=map()

       obj:classname    := "LISTITEM"
       obj:first        := 1
       obj:colorSpec    := iif(color==NIL,setcolor(),color)
       obj:nTop         := Lrow
       obj:nLeft        := Lcol
       obj:nBottom      := Rrow-1
       obj:nRight       := Rcol
       obj:line         := Lrow
       obj:col		:= Rcol
       obj:pos          := 1
       obj:colWin       := iif(empty(Columns), 1, Columns)
       obj:rowWin       := Rrow-Lrow
       obj:lencol	:= {}
       obj:itemCount	:= 0
       obj:buffer	:= 0
       obj:hasFocus	:= .f.
       obj:title	:= {}
       obj:union	:= .f.
       obj:itemWin	:= obj:rowWin*obj:colWin
       obj:delim	:= iif(Delimiter==NIL, "|", Delimiter)
       obj:__keys	:= map()
       obj:nSelected	:= 0

       _recover_listitem(obj)

       obj:findbuffer  	:= ""

       obj:item 	:= {}
       obj:__colors	:= {}      // color palettes

       obj:__init()
       obj:__setcolor()

       while (Rcol-Lcol)%obj:colWin > 0
	    Rcol --
       enddo
       asize(obj:lencol, obj:colWin)
       afill(obj:lencol, int((Rcol-Lcol)/obj:colWin))
return obj
*************************************
function _recover_listitem(obj)
       obj:__init       := @__init()
       obj:down         := @down()
       obj:up           := @up()
       obj:left         := @left()
       obj:right        := @right()
       obj:home         := @home()
       obj:end          := @end()
       obj:pageDown     := @pageDown()
       obj:pageUp       := @pageUp()

       obj:addItem	:= @addItem()
       obj:insItem	:= @insItem()
       obj:delItem	:= @delItem()
       obj:getItem 	:= @getItem()
       obj:setItem 	:= @setItem()
       obj:refresh      := @refresh()
       obj:__refreshUnion := @__refreshUnion()
       obj:setFocus     := @setFocus()
       obj:killFocus    := @killFocus()
       obj:clear        := @clear()
       obj:clearFindBuffer := @clearFindBuffer()
       obj:setTitle     := @setTitle()
       obj:drawTitle    := @drawTitle()
       obj:setColumns	:= @setColumns()
       obj:setWidthCol	:= @setWidthCol()
       obj:setNewBound	:= @setNewBound()
       obj:setUnion	:= @setUnion()
       obj:killUnion	:= @killUnion()
       obj:select	:= @li_select()
       obj:getSelected	:= @getSelected()
       obj:find       	:= @find()
       obj:handleKey	:= @handleKey()
       obj:setKey	:= @setKey()
       obj:__setColor	:= @__setcolor()
return obj
*************************************
static func __init()
local m
	::__keys := map()
	m := ::__keys
	m[K_LEFT]	:= {|oL, nKey| oL:left(), LI_CONTINUE }
	m[K_RIGHT]	:= {|oL, nKey| oL:right(), LI_CONTINUE }
	m[K_UP]		:= {|oL, nKey| oL:up(), LI_CONTINUE }
	m[K_DOWN]	:= {|oL, nKey| oL:down(), LI_CONTINUE }
	m[K_HOME]	:= {|oL, nKey| oL:home(), LI_CONTINUE }
	m[K_END]	:= {|oL, nKey| oL:end(), LI_CONTINUE }
	m[K_PGUP]	:= {|oL, nKey| oL:pageup(), LI_CONTINUE }
	m[K_PGDN]	:= {|oL, nKey| oL:pagedown(), LI_CONTINUE }
	m[K_ESC]	:= {|oL, nKey| LI_EXIT }

return .t.
*************************************
static func __setcolor()
local s, i
       ::__colors:={}
       s:=::colorSpec
       while len(s)>0
	   i:=at(",",s)
	   i=iif(i==0,len(s)+1,i)
	   aadd(::__colors,substr(s,1,i-1) )
	   s:=substr(s,i+1)
       enddo
       i := len(::__colors)
       if i<7
	   asize(::__colors, 7)
	   afill(::__colors, "7/0", i+1)
       endif
return NIL
***********
static func addItem(item, color, colorSel)
local m := map()
    if item == NIL
	return 0
    endif
    color := iif(color==NIL, ::__colors[1], color)
    colorSel := iif(colorSel==NIL, ::__colors[2], colorSel)
    m:item := item
    m:color := color
    m:scolor := colorSel
    m:select := .f.
    aadd(::item, m)
    //aadd(::colorItem, {color, colorSel})
    ::itemCount ++
    m := ""
return 1
***********
static func insItem(item, position, color, colorSel, sel)
    if item == NIL .or. position == NIL .or. !between(position, 1, ::itemCount)
	return 0
    endif
    color := iif(color==NIL, ::__colors[1], color)
    colorSel := iif(colorSel==NIL, ::__colors[2], colorSel)
    sel := iif(sel==NIL, .f., sel)
    ::itemCount ++
    asize(::item, ::itemCount)
    ains(::item, position)
    ::item[position]:item := item
    ::item[position]:color := color
    ::item[position]:scolor := colorSel
    ::item[position]:select := sel
    //::colorItem[position] := {color, colorSel}
    //::refresh() //why it need?
return 1
***********
static func delItem(position)
    if !between(position, 1, ::itemCount)
	return 0
    endif
    adel(::item, position)
    //adel(::colorItem, position)
    ::itemCount --
    asize(::item, ::itemCount)
    //asize(::colorItem, ::itemCount)
    if ::buffer > ::itemCount
	::buffer := ::itemCount
    endif
    ::refresh()
return 1
***********
static func setItem(position)
    if !between(position, 1, ::itemCount)
	return 0
    endif
    ::buffer := position
    if ::buffer > ::first+::itemWin
	::first := ::buffer
    endif
    ::refresh()
return 1
***********
static func getItem()
    if empty(::item)
	return NIL
    endif
return ::item[::buffer]:item

***********
static func clear()
    asize(::item, 0)
    //asize(::colorItem, 0)
    ::buffer := 1
    ::line := ::nTop
    ::pos := 1
    ::clearFindBuffer()
    ::first := 1
    ::itemCount := 0
return

***********
static func clearFindBuffer()
    ::findbuffer := ""
return

***********
static func setFocus()
    ::hasFocus := .t.
    ::refresh()
return

***********
static func killFocus()
    ::hasFocus := .f.
    ::refresh()
return

*********** filling
static func refresh()
local cur, i, j, nl:=::nLeft
       if ::union
		::__refreshUnion()
		return
       endif
       if ::line > ::nBottom
	   if ::pos != ::colWin
	       ::pos ++
	       ::line := ::nTop
	   else
	       ::first ++
	       ::line := ::nBottom
	   endif
       endif
       if ::line < ::nTop
	   if ::pos != 1
	       ::pos --
	       ::line := ::nBottom
	   else
	       ::first --
	       ::line := ::nTop
	   endif
       endif

       if ::pos < 1
	   ::pos = 1
	   ::first -= ::rowWin
       endif
       if ::pos > ::colWin
	   ::pos = ::colWin
	   ::first += ::rowWin
       endif

       ::first := min(::first, ::itemCount)
       ::first := max(::first, 1)
       ::buffer := min(::buffer, ::itemCount)
       ::buffer := max(::buffer, 1)
       cur := ::first

       ::line := min(::line, ::nTop+(::buffer-::first)%::rowWin)
       if !empty(::findbuffer)
	   ::line := ::nTop+(::buffer-::first)%::rowWin
       endif

       dispbegin()
       if ::itemCount == 0
		dispOutAt(::nTop, nl, replicate(" ", ::lencol[1]), ::__colors[2] )
       endif
       for i=1 to ::colWin
	   for j=::nTop to ::nBottom
	       if ::buffer == cur .and. ::itemCount >= cur
		   if !empty(::findbuffer)
			dispOutAt(j, nl, substr(padr(::item[cur]:item, ::lenCol[i]), 1, len(::findbuffer)), iif(::hasFocus, ::__colors[7], iif(::item[cur]:select, ::__colors[5], ::__colors[3])) )
			dispOutAt(j, nl+len(::findbuffer), substr(padr(::item[cur]:item, ::lenCol[i]), len(::findbuffer)+1), iif(::hasFocus, iif(::item[cur]:select, ::__colors[6], ::item[cur]:scolor), iif(::item[cur]:select, ::__colors[5], ::__colors[3])) )
		   else
			dispOutAt(j, nl, padr(::item[cur]:item, ::lenCol[i]), iif(::hasFocus, iif(::item[cur]:select, ::__colors[6], ::item[cur]:scolor), iif(::item[cur]:select, ::__colors[5], ::__colors[3])) )
		   endif
		   ::pos := i
		   ::line := j
	       else
		   if cur <= ::itemCount
		       dispOutAt(j, nl, padr(::item[cur]:item, ::lenCol[i]),;
			   iif(::item[cur]:select, ::__colors[5], ::item[cur]:color) )
		   else
		       dispOutAt(j, nl, padl(" ", ::lenCol[i]), ::__colors[1] )
		   endif
	       endif
	       if i!=::colWin
		   dispOutAt(j, nl+::lenCol[i], ::delim, ::__colors[1] )
	       endif
	       cur ++
	   next
	   nl += ::lenCol[i]+1
       next
       if empty(::findbuffer)
	   ::col := ::nLeft
	   for i=1 to ::pos-1
		::col += ::lencol[i]+1
	   next
       else
	   ::col:= ::nLeft+len(::findbuffer)
	   for i=1 to ::pos-1
		::col += ::lencol[i]+1
	   next
       endif
       devpos(::line, ::col)
       dispend()
return
******************
static function __refreshUnion()
local i,a, j, nl:=::nLeft, s, es:="", cur
       if ::line > ::nBottom
	       ::first ++
       endif
       if ::line < ::nTop
	       ::first --
       endif

       if ::pos > 1
	   ::pos = 1
	   ::first += ::rowWin
       endif
       if ::pos < 1
	   ::pos = 1
	   ::first -= ::rowWin
       endif

       ::first := min(::first, ::itemCount)
       ::first := max(::first, 1)
       ::buffer := min(::buffer, ::itemCount)
       ::buffer := max(::buffer, 1)
       cur := ::first

       ::line := min(::line, ::nTop+(::buffer-::first)%::rowWin)
       if !empty(::findbuffer)
	   ::line := ::nTop+(::buffer-::first)%::rowWin
       endif
       for i=1 to ::colWin
		es += padr(" ", ::lenCol[i]) + iif(i<::colWin, ::delim, "")
       next
       dispbegin()
       if ::itemCount == 0
	   dispOutAt(::nTop, nl, es, ::__colors[2] )
       endif
       for j=::nTop to ::nBottom
	   if cur > ::itemCount
		dispOutAt(j, nl, es, ::__colors[1] )
		loop
	   endif
	   s:=""
	   a := {}
	   a := split(::item[cur]:item, ::delim)
	   asize(a, ::colWin)
	   for i=1 to ::colWin
		s += padr(a[i], ::lenCol[i]) + iif(i<::colWin, ::delim, "")
	   next
	   if ::buffer == cur
		dispOutAt(j, nl, s, iif(::hasFocus, iif(::item[cur]:select, ::__colors[6], ::item[cur]:scolor), iif(::item[cur]:select, ::__colors[5], ::__colors[3])) )
		::pos := 1
		::line := j
	   else
		dispOutAt(j, nl, s, iif(::item[cur]:select, ::__colors[5], ::item[cur]:color) )
	   endif
	   cur ++
       next

       if empty(::findbuffer)
	   ::col := ::nLeft
	   for i=1 to ::pos
		::col += ::lencol[i]
	   next
       else
	   ::col:= ::nLeft+len(::findbuffer)
	   for i=1 to ::pos
		::col += ::lencol[i]
	   next
       endif
       devpos(::line, ::col)
       dispend()
return

*********** move one line down
static func down
    ::line++
    ::buffer++
    ::clearFindBuffer()
    ::refresh()
RETURN

*********** move one line up
static func up
     ::line--
     ::buffer--
     ::clearFindBuffer()
     ::refresh()
RETURN

*********** move PgDn
static func PageDown
    ::buffer += ::itemWin
    ::first += ::itemWin
    ::clearFindBuffer()
    ::refresh()
return
*********** move PgUp
static func PageUp
    ::buffer -= ::itemWin
    ::first -= ::itemWin
    ::clearFindBuffer()
    ::refresh()
RETURN

*********** move by left/roght arrows
static func left()
    ::pos --
    ::buffer -= ::rowWin
    ::clearFindBuffer()
    ::refresh()
return

static func right()
    ::pos ++
    ::buffer += ::rowWin
    ::clearFindBuffer()
    ::refresh()
return

*********** move to begin of list
static func Home
  ::pos := 1
  ::buffer := 1
  ::first := 1
  ::line := ::nTop
  ::clearFindBuffer()
  ::refresh()
return

*********** move to end of list
static func End
  ::pos := ::colWin
  ::buffer := ::itemCount
  ::first := ::itemCount - (::colWin*::rowWin) + 1
  ::line := ::nBottom- ::rowWin + 1
  ::clearFindBuffer()
  ::refresh()
return

*********** substring search
static func find(ch)
local i, j, cur, oldfirst, oldline, oldbuff, oldpos, oldfb, found:=.f., cw

    oldfirst := ::first
    oldline := ::line
    oldbuff := ::buffer
    oldpos  := ::pos
    oldfb   := ::findbuffer
    if empty(::findbuffer)
	cur := 1
	cw := 1
	::first := 1
	::line  := ::nTop
	::buffer:= 1
	::pos   := 1
    else
	cur := ::buffer
	cw := ::pos*::rowWin-(::nBottom-::line)
    endif
    ::findbuffer += ch
    for j=cw to ::itemWin
	if cur<=::itemCount .and. "ITEM"$::item[cur] .and. !empty(::item[cur]:item) ;
		.and. ::item[cur]:item = ::findbuffer
		::buffer := cur
		found := .t.
		::refresh()
		return found
	endif
	cur++
    next

    ::line := ::nBottom
    ::pos := ::colWin
    ::first ++

    if cur<=::itemCount .and. "ITEM"$::item[cur] .and. !empty(::item[cur]:item)
       for i=cur to ::itemCount
	   if ::item[i]:item = ::findbuffer
	      ::buffer := i
	      found := .t.
	      ::refresh()
	      return found
	   endif
	   ::first ++
	next
    endif
    if !found
	::first := oldfirst
	::line  := oldline
	::buffer:= oldbuff
	::pos   := oldpos
	::findbuffer := oldfb
    endif
    ::refresh()
RETURN found
*************
static function setTitle(Title)
local i
	if empty(Title) .or. valtype(Title)!="A"
		return .f.
	endif
	if empty(::title)
		::rowWin --
		::nTop ++
	endif
	asize(::title, ::colWin)
	afill(::title, "")
	for i=1 to ::colWin
		if len(Title)<i
			exit
		endif
		::title[i] := Title[i]
	next
return .t.
**************
static function drawTitle()
local i, nl:=::nLeft
	for i=1 to ::colWin
		dispOutAt(::nTop-1, nl, padc(::title[i], ::lencol[i]), ::__colors[4] )
		if i!=::colWin
			dispOutAt(::nTop-1, nl+::lencol[i], ::delim, ::__colors[1] )
		endif
		nl += ::lencol[i]+1
	next
return .t.
*************
static function setColumns(col)
local Rcol:=::nRight, Lcol:=::nLeft
	if col == NIL .or. valtype(col) != "N" .or. col < 1
		return .f.
	endif
	::colWin := col
	while (Rcol-Lcol)%::colWin > 0
		Rcol --
	enddo
	asize(::lencol, ::colWin)
	afill(::lencol, int((Rcol-Lcol)/::colWin))
return .t.
*************
/*
width - it's array {}
every element is number or 0 - all remaining, and zero may be somewhat,
in this case remaining width is divided equally between them
*/
static function setWidthCol(width)
local i, az:={}, s:=0, len
	if empty(width) .or. valtype(width)!="A"
		return .f.
	endif
	afill(::lencol, 0)
	for i=1 to ::colWin
		if len(width)<i
			exit
		endif
		::lencol[i] := width[i]
	next
	for i=1 to ::colWin
		if ::lencol[i] == 0
			aadd(az, i)
		else
			s += ::lencol[i]
		endif
	next
	len := (::nRight - ::nLeft - ::colWin+1 - s)/len(az)
	for i=1 to len(az)
		::lencol[az[i]] := len
	next
return .t.
*************
static function setUnion()
	::union := .t.
return .t.
*************
static function killUnion()
	::union := .f.
return .t.
**************
//static function setNewBound(top, left, bottom, right)
static function setNewBound(left, right)
	if valtype(left) != "N" .or. valtype(right) != "N" ;
		.or. (left < 0) .or. (right < 0)
		return .f.
	endif
	//::nTop := top
	::nLeft := left
	//::nBottom := bottom
	::nRight := right
	::SetColumns(::ColWin)
return .t.
***************
static function li_select(it)
local i
	it := iif(it==NIL, ::buffer, it)
	if valtype(it)=="A"
		for i=1 to len(it)
			if valtype(it[i])== "N" .and. between(it[i], 1, ::itemCount)
				::item[it[i]]:select := !::item[it[i]]:select
				if ::item[it[i]]:select
					::nSelected += 1
				else
					::nSelected -= 1
				endif
			endif
		next
	elseif valtype(it)=="N".and. between(it, 1, ::itemCount)
		::item[it]:select := !::item[it]:select
		if ::item[it]:select
			::nSelected += 1
		else
			::nSelected -= 1
		endif
	endif
	::refresh()
return .t.
***************
static function getSelected()
local ret:={}
	/*
	for i=1 to ::itemCount
		if ::item[i]:select
			aadd(ret, ::item[i]:item)
		endif
	next
	*/
	aeval(::item, {|item| iif(item:select, aadd(ret, item:item), NIL)})
	if len(ret) == 0
		aadd(ret, ::getItem())
	endif
return ret
***************
static function handleKey(oL, nKey)
local ret := LI_CONTINUE
	if !(nKey $ oL:__keys)
		return ret
	endif

	ret := eval(oL:__keys[nKey], oL, nKey)
return ret
*************************************
static function setKey(nKey, vData)
local ret
	ret := vData
	if nKey $ ::__keys
		ret := ::__keys[nKey]
	endif
	::__keys[nKey] := vData
	if vData == NIL
		adel(::__keys, nKey)
	endif
return ret

