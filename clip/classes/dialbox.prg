/*
    Copyright (C) 2001  ITK
    Author   : Alena (alena@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "inkey.ch"
#include "box.ch"	//1   2	   3    4   5   6   7	 8   9	 0
#define DBCOLORS	"0/3,1/3,14/3,14/1,1/3,14/1,0/3,14/1,9/3,14/1"
//#define DBCOLORS	"0/7,1/7,14/7,14/1,1/7,3/7,0/7,14/1,9/7,14/1"
#define _BUTTON_	1
#define _GETB_		2
#define _CHECK_		3
#define _RADIO_		4
#define _GETTEXT_	5

#define TABSIZE		8

/*
say, get, qout
color="col1, col2, col3, col4, col5, col6, col7, col8"
col1 - простой текст
col2 - выделенный текст
col3 - кнопка
col4 - активная кнопка
col5 - get объект не активный
col6 - get объект активный
col7 - checkbox объект не активный
col8 - checkbox объект активный
col9 - radiogroup объект не активный
col10 - radiogroup объект активный
*/
function dialogBox(Lrow, Lcol, Rrow, Rcol, color)
local obj
       obj:=map()
       obj:classname    := "DIALOGBOX"

       obj:lines        := 0
       obj:colorSpec    := iif(color==NIL .or. empty(color),DBCOLORS,color)
       obj:line         := 1
       obj:pos          := 1
       obj:colWin       := 1
       obj:rowWin       := 1
       obj:nT        	:= Lrow
       obj:nL        	:= Lcol
       obj:nB      	:= Rrow
       obj:nR       	:= Rcol
       obj:nTop         := obj:nT+1
       obj:nLeft        := obj:nL+1
       obj:nBottom      := obj:nB-1
       obj:nRight       := obj:nR-1
       obj:marginLeft	:= 8
       obj:header	:= ""
       obj:Find		:= 0
       obj:n_Line	:= 1
       obj:n_pos	:= 1
       obj:leninfo	:= 0

       obj:RadioItem	:= map()

       obj:regSearch	:= 0
       obj:findR	:= {}

       obj:mapKeys	:= HK_get("dialog")
       obj:inbuffer	:= {}

       obj:__nbr	:= 0
       obj:item		:= map()
       obj:item_type	:= 0
       obj:item_area	:= {}

       obj:__oldscr	:= 0
       obj:__oldcolr	:= 0
       obj:__oldcursor	:= 0
       obj:__colors 	:= {}      // палитры цветов

       _recover_dialogbox(obj)

       obj:__setcolor()
       obj:init()
return obj
***********
function _recover_dialogbox(obj)
       obj:drawBox      := @db_drawBox()
       obj:down         := @db_down()
       obj:up           := @db_up()
       obj:left         := @db_left()
       obj:right        := @db_right()
       obj:bottom       := @db_bottom()
       obj:top          := @db_top()
       obj:home         := @db_home()
       obj:end          := @db_end()
       obj:pageDown     := @db_pageDown()
       obj:pageUp       := @db_pageUp()
       obj:select	:= @db_select()
       obj:enter	:= @db_enter()
       obj:delete	:= @db_delete()
       obj:insert	:= @db_insert()
       obj:backspace	:= @db_backspace()
       obj:refresh	:= @db_refresh()
       obj:handleKey	:= @db_handleKey()
       obj:check_line	:= @db_check_line()
       obj:killFocus	:= @db_killFocus()
       obj:goto		:= @db_goto()
       obj:goItem	:= @db_goItem()
       obj:close	:= @db_close()
       obj:destroy	:= @db_destroy()

       obj:menu		:= @db_menu_create()
       obj:init		:= @db_init()
       obj:Text		:= @db_Text()
       obj:Button	:= @db_Button()
       obj:Get		:= @db_Get()
       obj:Check	:= @db_Check()
       obj:Radio	:= @db_Radio()
       obj:GetText	:= @db_GetText()
       obj:curWord	:= @db_curWord()
       obj:getStrElem	:= @db_getStrElem()
       obj:getString	:= @db_getString()
       obj:findStr	:= @db_find()
       obj:makeStr	:= @db_makeStr()
       obj:cancelBlock	:= @db_cancelBlock()

       obj:setValue	:= @db_setValue()
       obj:__setColor 	:= @__setcolor()
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
static function db_init()
local str
	//save screen to ::__oldscr
	::__oldcolor := setcolor()
	::__oldcursor := setcursor()
	::leninfo := maxcol()-maxcol()*3/4 - 1
	setcolor(::colorSpec)
	set("dbox_colors_list","15/3,15/7,0/7,0/3,")   // цвет list объектов
	set("dbox_colors_dialog","15/7,14/1,w+/b,g/rb,15/7,0/7")   // цвет диалогов
	set("dbox_colors_menu","0/7,0/2,r/7,g/rb,15/7,0/7") // цвет меню
	::item:hasFocus := .f.
	asize(::item_area, 0)
	::Find := findOptions(,,set("dbox_colors_dialog"), set("dbox_colors_list"))
	asize(::findR, 3)
return
***********
static function db_close()
   if ::item:hasFocus
	::killFocus()
   endif
   asize(::inbuffer, 0)
   asize(::findR, 0)
   ::lines := 0
   ::n_Line := 1
   ::n_Pos := ::marginLeft
   ::Find := map()
   ::item := map()
   //setcursor(::__oldcursor)
   //setcolor(::__oldcolor)
   //restore screen from ::__oldscr
return len(::inbuffer)
***********
static function db_destroy()
   if !empty(::item)
	::close()
   endif
   setcursor(::__oldcursor)
   setcolor(::__oldcolor)
   //restore screen from ::__oldscr
return

***********
static function db_killFocus()
local i
	if ::item_type == _GETB_
		::item:assign()
		::item:killFocus()
		::item:col := ::item_area[2]
		::item:row := ::item_area[1]
	elseif ::item_type == _CHECK_
		::item:varPut(::item:Control:buffer)
		::item:assign()
		::item:Control:killFocus()
		::item:Control:col := ::item_area[2]
		::item:Control:row := ::item_area[1]
	elseif ::item_type == _RADIO_
		::item:varPut(::item:Control:value)
		::item:assign()
		::item:Control:killFocus()
		for i=1 to ::item:Control:itemCount
			::item:Control:__items[i]:row := ::item_area[1][i]
			::item:Control:__items[i]:col := ::item_area[2][i]
		next
	elseif ::item_type == _GETTEXT_
		::item:assign()
		::item:killFocus()
		::item:edit:nTop := ::item_area[1]
		::item:edit:nLeft := ::item_area[2]
		::item:edit:nBottom := ::item_area[3]
		::item:edit:nRight := ::item_area[4]
	endif
	::item := map()
	::item:hasFocus := .f.
	::item:info := ""
	::item_type := -1
	asize(::item_area, 0)
	::item_num := 0
return

***********
static function db_up()
	if ::item_type < _RADIO_
		::killFocus()
		::line--
		::rowWin--
		::refresh()
	elseif ::item_type == _RADIO_
		::item:Control:prevItem()
		::line--
		::rowWin--
	elseif ::item_type == _GETTEXT_
		::item:edit:up()
	endif
return
***********
static function db_down()
	if ::item_type < _RADIO_
		::killFocus()
		::line++
		::rowWin++
		::refresh()
	elseif ::item_type == _RADIO_
		::item:Control:nextItem()
		::line++
		::rowWin++
	elseif ::item_type == _GETTEXT_
		::item:edit:down()
	endif
return
***********
static function db_left()
	if ::item_type == _GETB_
		::item:left()
	elseif ::item_type == _GETTEXT_
		::item:edit:left()
	else
		if ::item_type == _CHECK_ .or. ::item_type == _RADIO_
			::killFocus()
		endif
		::pos--
		::colWin--
		::refresh()
	endif
return
***********
static function db_right()
	if ::item_type == _GETB_
		::item:right()
	elseif ::item_type == _GETTEXT_
		::item:edit:right()
	else
		if ::item_type == _CHECK_ .or. ::item_type == _RADIO_
			::killFocus()
		endif
		::pos++
		::colWin++
		::refresh()
	endif
return
***********
static function db_pageUp()
	if ::item_type == _GETTEXT_
		::item:edit:pageUp()
		return
	endif
	::killFocus()
	::line=::line-::nbottom-::ntop
	::refresh()
return
***********
static function db_pageDown()
	if ::item_type == _GETTEXT_
		::item:edit:pageDown()
		return
	endif
	::killFocus()
	::line := min(::line+::nbottom-::ntop, ::lines)
	::refresh()
return
***********
static function db_top()
  if ::item_type == _GETTEXT_
	::item:edit:top()
	return
  endif
  ::killFocus()
  ::line:=1
  ::rowWin:=1
  ::refresh()
return
***********
static function db_bottom()
  if ::item_type == _GETTEXT_
	::item:edit:bottom()
	return
   endif
   ::killFocus()
   ::line:=::lines+1
   ::rowWin:=::nbottom-::ntop
   ::refresh()
return
***********
static function db_home()
local homepos:=1
  if ::item_type == _GETB_
	::item:home()
	return
  elseif ::item_type == _GETTEXT_
	::item:edit:home()
	return
  endif
  ::killFocus()
  if len(::inbuffer[::line])>0
	homepos := ::inbuffer[::line][1]:nl
  endif
  if homepos == 1 .or. ::pos <= homepos
      ::pos := 1
      ::colWin := 1
  else
      ::colWin -= (::pos-homepos)
      ::pos := homepos
  endif
  ::refresh()
return
***********
static function db_end()
local len:=0

  if ::item_type == _GETB_
	::item:end()
	return
  elseif ::item_type == _GETTEXT_
	::item:edit:end()
	return
  endif
  ::killFocus()
  if ::line <= ::lines .and. len(::inbuffer[::line]) > 0
	len := ::inbuffer[::line][len(::inbuffer[::line])]:nr
  endif
  ::pos := len+1
  ::colWin := len+1
  ::refresh()
return
***********
static function db_enter(self, p1, p2, p3, p4, p5, p6, p7, p8, p9)
local oldcursor, oldcolor
	if ::item_type == _BUTTON_
		oldcursor:=setcursor()
		oldcolor := setcolor()
//		&(::item:userFunc)
		eval(::item:userFunc, 	self, p1, p2, p3, p4, p5, p6, p7, p8, p9)
		//restore screen from scr
		setcursor(oldcursor)
		setcolor(oldcolor)
		//::refresh()
	elseif ::item_type == _GETTEXT_
		::item:edit:insertLine()
	endif
return
***********
static function db_select(direct)
local op, i, j, pos, eni, stj, enj, _step, nl:=0, nt:=0, nr:=0, nb:=0
/*
	if ::item:hasFocus()
		nl := ::inbuffer[::line][::item_num]:nl
		nr := ::inbuffer[::line][::item_num]:nr
		nt := ::inbuffer[::line][::item_num]:nt
		nb := ::inbuffer[::line][::item_num]:nb
	endif
	*/
//	::killFocus()
	direct := iif(direct==NIL, .t., .f.)
	if direct
		eni := len(::inbuffer)//::lines
		_step := 1
	else
		eni := 1
		_step := -1
	endif
	op := .f.
	pos := ::pos
	for i:= ::line to eni step _step
		stj := iif(direct, 1, len(::inbuffer[i]))
		enj := iif(direct, len(::inbuffer[i]), 1)
		for j:= stj to enj step _step
		/*
			if between(i, nt, nb) .and. between(::inbuffer[i][j]:nl, nl, nr)
				loop
			endif
		    */
			if ::inbuffer[i][j]:type > 0
				if (direct .and. ::inbuffer[i][j]:nl > pos) .or. (!direct .and. ::inbuffer[i][j]:nl < pos)
					pos := ::inbuffer[i][j]:nl
					op := .t.
					exit
				endif
			endif
		next
		if op
			exit
		endif
		pos := iif(direct, 1, iif(i-1>0, ::inbuffer[i-1][len(::inbuffer[i-1])]:nr, 0))
	next
	if op
		::killFocus()
		::colWin += pos - ::pos
		::rowWin += i - ::line
		::pos := pos
		::line := i
		::refresh()
	else
		alert("Object not found!")
	endif
return

***********
static function db_delete()
	if ::item_type == _GETB_ .or. _GETTEXT_
		::item:delete()
	endif
return
***********
static function db_insert(hKey)
	if hKey == K_SPACE .and. ::item_type == _CHECK_
		::item:Control:select(!::item:Control:buffer)
	elseif ( ::item_type == _GETB_  .or. ::item_type == _GETTEXT_ ).and. hKey>=32 .and. hKey<=256
	       if set(_SET_INSERT)
			::item:Insert(chr(hKey))
	       else
			::item:overStrike(chr(hKey))
	       endif
	endif
return

***********
static function db_backspace()
	if ::item_type == _GETB_ .or. ::item_type == _GETTEXT_
		::item:backspace()
		return .t.
	endif
return .f.

***********
static function db_refresh()
local bp,bl,l,i,j,dev, str, clr, pl:=.f., x, fnd, xi, elem, ch:=.f.
local dx

       ::line   := max(1, ::line)
       ::pos    := max(1, ::pos)
       if ::rowWin > ::nBottom-::nTop+1
	::rowWin := min(::nBottom-::nTop+1, ::line)
       elseif ::rowWin < ::nTop
	::rowWin := max(::rowWin, 1)
       else
	::rowWin := min(::line, max(::rowWin, 1))
       endif
       if ::colWin > ::nRight
	::colWin := min(::nRight, ::pos)
       elseif ::colWin < ::nLeft
	::colWin := max(::colWin, 1)
       else
	::colWin := min(::pos, max(::colWin, 1))
       endif

       fnd := iif(len(::findR)>0 .and. ::findR[1]!=NIL, .t., .f.)

       bl := ::line-::rowWin
       l  := ::nRight-::nLeft+1

       if fnd .and. !between(::findR[1], bl+1, bl+1+::nbottom-::ntop+1)
	   fnd := .f.
	   afill(::findR, NIL)
       endif

       dispbegin()
       for i=1 to ::nbottom-::ntop+1
	   if (bl+i) <= ::lines
		@ ::ntop+i-1, ::nLeft say replicate(" ", ::nRight-::nLeft+1) color ::__colors[1]
		for j=1 to len(::inbuffer[bl+i])
			elem := ::inbuffer[bl+i][j]
			str := ::getStrElem(elem, bl+i)

			if elem:nl<=(::pos - ::colWin)
				str=substr(str, ::pos-::colWin-elem:nl+2)
			endif
			if elem:nr>::pos-::colWin+(::nRight-::nLeft)
				str:= substr(str, 1, len(str)-(elem:nr-(::pos-::colWin+(::nRight-::nLeft)))+3)
			endif

			if (bl+i==::line) .and. elem:type == _GETB_ .and. between(::pos, elem:nl, elem:nr)
				if !elem:objit:hasFocus
					::item:=elem:objit
					asize(::item_area, 2)
					::item_area[1] := ::item:row
					::item_area[2] := ::item:col
					::item:col := max(elem:nl-::pos+::colWin, ::nLeft)
					::item:row := ::nTop+i-1
					::item_num := j
					::item_type := _GETB_
					::item:setFocus()
				endif
			elseif (bl+i==::line) .and. elem:type == _CHECK_ .and. between(::pos, elem:nl, elem:nr)
				if !elem:objit:Control:hasFocus
					::item := elem:objit
					asize(::item_area, 2)
					::item_area[2] := ::item:Control:col
					::item_area[1] := ::item:Control:row
					::item:Control:col := max(elem:nl-::pos+::colWin, ::nLeft)
					::item:Control:row := ::nTop+i-1
					@ ::ntop+i-1, ::item:Control:col say "[ ]" color elem:color
					::item_num := j
					::item_type := _CHECK_
					::item:Control:setFocus()
				endif
			elseif elem:type == _RADIO_ .and. between(::pos, elem:nl, elem:nr) .and. between(bl+i, elem:nt, elem:nb) .and. between(::line, elem:nt, elem:nb)
				if !elem:objit:Control:hasFocus
					::item := elem:objit
					if ::item:Control:bottom>::line+::nBottom-::rowWin
						::line := ::item:Control:bottom
						::rowWin := ::nBottom
						::refresh()
						exit
					endif

					if ::item:Control:top < ::line - ::rowWin
						::line := ::item:Control:top
						::rowWin := ::nTop+1
						::refresh()
						exit
					endif
					asize(::item_area, 2)
					::item_area[1] := {}
					::item_area[2] := {}
					asize(::item_area[1], ::item:Control:itemCount)
					asize(::item_area[2], ::item:Control:itemCount)
					for x=1 to ::item:Control:itemCount
						::item_area[1][x] := ::item:Control:__items[x]:row
						::item_area[2][x] := ::item:Control:__items[x]:col
						::item:Control:__items[x]:col := max(::item:Control:__items[x]:col-::pos+::colWin, ::nLeft)
						::item:Control:__items[x]:row := ::item:Control:top-bl+x-1
					next
					::item_num := j
					::item_type := _RADIO_
					::item:Control:setFocus()
				endif
			elseif elem:type == _GETTEXT_ .and. between(::pos, elem:nl, elem:nr) .and. between(bl+i, elem:nt, elem:nb) .and. between(::line, elem:nt, elem:nb)
				if !elem:objit:hasFocus
					::item:=elem:objit
					if ::item:edit:nTop< ::line-::rowWin+1
						::line := ::item:edit:nTop
						::rowWin := ::nTop
						ch := .t.//::refresh()
					endif
					if ::item:edit:nBottom>::line+::nBottom-::rowWin
						::line := ::item:edit:nBottom
						::rowWin := ::nBottom
						ch := .t.//::refresh()
					endif
					if ch
						::refresh()
					endif
					asize(::item_area, 4)
					::item_area[1] := ::item:edit:nTop
					::item_area[2] := ::item:edit:nLeft
					::item_area[3] := ::item:edit:nBottom
					::item_area[4] := ::item:edit:nRight
					::item:edit:nTop   := ::item:edit:nTop - bl
					::item:edit:nLeft  := max(::item:edit:nLeft-::pos+::colWin, ::nLeft)
					::item:edit:nBottom:= ::item:edit:nBottom - bl
					::item:edit:nRight := min(::item:edit:nRight-::pos+::colWin, ::nRight)

					::item_type := _GETTEXT_
					::item_num := j
					::item:setFocus()

				endif
			else
				if (bl+i==::line) .and. elem:type == _BUTTON_ .and. between(::pos, elem:nl, elem:nr)
					clr := ::__colors[4]+","+::__colors[2]
					::item:hasFocus := .t.
					::item:info := elem:info
					::item_type := _BUTTON_
					::item_num := j
					::item:userFunc := elem:fnc
				else
					if elem:type == _GETTEXT_ .and. elem:objit:hasFocus
						clr := ::item:colorSpec
					elseif elem:type == _RADIO_ .and. elem:objit:hasFocus
						clr := ::item:colorSpec
					else
						clr := elem:color+","+::__colors[2]
					endif
				endif
				dx := ::pos - ::colWin
				xi := max(elem:nl-dx, ::nLeft)
				if fnd .and. ::findR[1] == bl+i .and. between(::findR[2]-dx, xi, xi+len(str))
					@ ::ntop+i-1, ::nLeft+xi-1 say substr(str, 1, ::findR[2]-dx-xi) color clr
					@ ::ntop+i-1, ::nLeft+::findR[2]-dx-1 say substr(str, ::findR[2]-dx-xi+1, ::findR[3]) color ::__colors[4]
					@ ::ntop+i-1, ::nLeft+::findR[2]-dx+::findR[3]-1 say substr(str, ::findR[2]-dx-xi+1+::findR[3]) color clr
				else
					__sayCaption(::ntop+i-1, ::nLeft+xi-1, str, clr)
				endif
			endif
		next
	   endif

	   if (bl+i) > ::lines
	      @ ::ntop+i-1, ::nLeft say space(l) color ::__colors[1]
	   endif
       next
       //dispend()
       //devpos(::nTop+::rowWin-1,::nLeft+::colWin-1)
	if ::item_type == _GETB_
		::colWin := ::item:col+min(::item:pos, ::item:__winLen) - 1
		::pos := ::item_area[2]+min(::item:pos, ::item:__winLen) -1
	elseif ::item_type == _GETTEXT_
		::colWin := ::item:edit:nLeft+::item:edit:colWin-1
		::rowWin := ::item:edit:nTop+::item:edit:rowWin-1
		::line := ::item:edit:nTop + ::item:edit:rowWin-1
		::pos := ::item :edit:nLeft +  ::item:edit:colWin -1
	endif
	str:=padr("<"+alltrim(str(::line)+"><"+alltrim(str(::pos))+">"), ::leninfo, substr(B_DOUBLE, 6, 1))
	@ ::nT, 1 say str
	devpos(::nTop+::rowWin-1,::nLeft+::colWin-1)
	dispend()
return
***********
static function db_drawBox(vref)
local str
	vref := iif(vref==NIL, .t., vref)
	@ ::nT, ::nL clear to ::nB, ::nR
	//@ ::nT, ::nL, ::nB, ::nR box B_DOUBLE
	@ ::nT, ::nL TO ::nB, ::nR DOUBLE
	str:=padr("<"+alltrim(str(::line)+"><"+alltrim(str(::pos))+">"), ::leninfo, substr(B_DOUBLE, 6, 1))
	dispbegin()
	@ ::nT, 1 say str
	@ ::nT, (maxcol()-len(::header))/2 say ::header
	devpos(::nTop+::rowWin-1,::nLeft+::colWin-1)
	dispend()
	setcursor(1)
	if vref
		::refresh()
	endif
return
***********
static function db_handleKey(self, p1, p2, p3, p4, p5, p6, p7, p8, p9)
local hKey, wn, oldcursor, oldcolor, scr, oldcol,oldrow
local i, j, k, num, oInfo, nchoice:=1

	::drawBox()
	do while .t.
		hKey := inkey(0)
		if hkey $ ::mapKeys
			hkey := ::mapKeys[hKey]
		endif
		if hKey == HASH_CallMenu
			set( _SET_EVENTMASK, INKEY_ALL )
			i := setcursor(0)
			oldrow := row()
			oldcol := col()
			//oldwin := wi
			wopen(::nTop-1, ::nLeft, ::nBottom, ::nRight, .f.)
			oInfo := ::menu()
			hKey := MenuModal(oInfo,nchoice,maxrow(),0,maxcol(),"r/w")
			wclose()
			//wselect(::curwin)
			setpos(oldrow, oldcol)
			nchoice := oInfo:current
			setcursor(i)
			if hKey == -1
				loop
			endif
		endif
		do case
		case hKey == HASH_Exit
			::close()
			exit
		case hKey == K_UP
			::up()
		case hKey == K_DOWN
			::down()
		case hKey == K_LEFT
			::left()
		case hKey == K_RIGHT
			::right()
		case hKey == K_HOME
			::home()
		case hKey == K_END
			::end()
		case hKey == K_PGDN
			::pageDown()
		case hKey == K_PGUP
			::pageUp()
		case hKey == K_INS
			set(_SET_INSERT, !set(_SET_INSERT))
		case hKey == K_DEL
			::delete()
		case hKey == K_BS
			::backspace()
		case hKey == HASH_NextItem
			::select()
		case hKey == HASH_PrevItem
			::select(.f.)
		case hKey == K_ENTER
			::enter(self, p1, p2, p3, p4, p5, p6, p7, p8, p9)
		case hKey == K_F5
			num := ::line
			alert("Das ist Gluck into Screen!!!")
			readkeyb((::nBottom-::nTop)/2, ((::nRight-::nLeft)/2)-len([Line]), [Line], @num,,,"0/7,14/1", B_DOUBLE)
			setcursor(1)
			::goto(num)
			/*
		case hKey == HASH_Find
			num := 0
			alert("Das ist Gluck into Screen!!!")
			readkeyb((::nBottom-::nTop)/2, ((::nRight-::nLeft)/2)-len([Where are you going?]), [Where are you going?], @num,,,"0/7,14/1", B_DOUBLE)
			setcursor(1)
			if !::goItem(num)
				alert("Oblomaiz!!!")
			endif
			*/
		case hKey == HASH_Find
			k := ::curWord()
			::Find:fstring := iif (empty(k), ::Find:fhistory:first(), k)
			::Find:replace := .f.
			if ::Find:get()
				if !::findStr()
					alert([String;]+::Find:fstring+[;not found!], "OK", set("dbox_colors_menu"))
				endif
			endif
			setcursor(1)
		case hKey == HASH_ResumeFind
			::right()
			if !::findStr()
				alert([String;]+::Find:fstring+[;not found!], "OK", set("dbox_colors_menu"))
			endif
		case hKey == HASH_UnmarkBlock
			::cancelBlock()
		otherwise
		    ::insert(hKey)
		endcase
	enddo
return
***************
static function db_check_line(line)
local i:=len(::inbuffer)
   if line<=0
      return
   endif

   for i=i to line-1
       aadd(::inbuffer,{})
   next
  ::lines:=len(::inbuffer)
return
****************
static function db_Text(txt, nt, nl, nb, nr, color, name)
local i, len, m
	nt := iif(nt==NIL, ::lines+1, nt)
	nl := iif(nl==NIL, ::marginLeft, nl)
	nb := iif(nb==NIL, nt, nb)
	nr := iif(nr==NIL, nl+len(txt)+1, nr)
	color := iif(color==NIL .or. empty(color), ::colorSpec, color)
	name := iif(name==NIL, "", name)
	len := nr-nl+1
	::check_line(nb)
	//asize(::inbuffer, ::lines)
	::__nbr++

	for i=nt to nb
		m := map()
		m:color := color
		m:txt := substr(txt, 1, len)
		m:number := ::__nbr
		m:nt := i
		m:nl := nl
		m:nb := i
		m:nr := nr
		m:type := 0
		m:name := name
		aadd(::inbuffer[i], m)
		txt := substr(txt, len+1)
		asort(::inbuffer[i],,,{|x, y| x:nl < y:nl})
	next
	::n_Line := nb
	::n_Pos  := nr-1
return ::__nbr
****************
static function db_Button(txt, fnc, nt, nl, nb, nr, color, name, info)
local i, len, m
	if valtype(fnc) == "O"
		name := iif(name==NIL, "", name)
	else
		nt := iif(nt==NIL, ::lines+1, nt)
		nl := iif(nl==NIL, ::n_Pos, nl)
		nb := iif(nb==NIL, nt, nb)
		nr := iif(nr==NIL, nl+len(txt)+1, nr)
		color := iif(color==NIL .or. empty(color), ::__colors[3]+","+::__colors[4], color)
		name := iif(name==NIL, "", name)
		info := iif(info==NIL, "", info)
	endif
	len := nr-nl+1
	::check_line(nb)
	//asize(::inbuffer, ::lines)
	::__nbr++
	for i=nt to nb
		m := map()
		m:txt := substr(txt, 1, len)
		m:color := color
		m:info := info
		m:number := ::__nbr
		m:nt := i
		m:nl := nl
		m:nb := i
		m:nr := nr
		m:type := 1
		m:fnc := fnc
		m:name := name
		aadd(::inbuffer[i], m)
		txt := substr(txt, len+1)
		asort(::inbuffer[i],,,{|x, y| x:nl < y:nl})
	next
	::n_Line := nb
	::n_Pos  := nr-1
return ::__nbr
****************
static function db_Get(row,col,var,length,color,pic,vblock,wblock,name)
local m, varname, block, getList:= {}
local nt,nl,nb,nr
	color := iif(color==NIL .or. empty(color), ::__colors[5], color)
	length := iif(length==NIL, len(var), length)
	nt := iif(row==NIL, ::lines+1, row)
	nl := iif(col==NIL, ::n_pos, col)
	nb := nt
	nr := nl+length
	name := iif(name==NIL, "", name)
	if var==NIL
		var := ""
	endif
	::check_line(nb)
	//asize(::inbuffer, ::lines)
	::__nbr ++
	varname := "get"+alltrim(str(::__nbr))
	block := {|_1| iif(_1==NIL, var,var:=_1)}
	pic := iif(pic == NIL, "@kS"+alltrim(str(length)), pic)
	m := map()
	m:objit := getNew(nt,nl,block,varname,pic,color,var,vblock,wblock)
	m:color := color
	m:number := ::__nbr
	m:nt := nt
	m:nl := nl
	m:nb := nb
	m:nr := nr
	m:type := 2
	m:name := name
	aadd(::inbuffer[nt], m)
	asort(::inbuffer[nt],,,{|x, y| x:nl < y:nl})
	::n_Line := nb
	::n_Pos  := nr
return ::__nbr

****************
static function db_Check(row,col,var,caption,color,fblock,sblock, name)
local m, message, style, bitmaps, getList:= {}, block, varname
local nt,nl,nb,nr
	color := iif(color==NIL .or. empty(color), ::__colors[7]+","+::__colors[8], color)
	caption := iif(caption==NIL, "", caption)
	nt := iif(row==NIL, ::lines+1, row)
	nl := iif(col==NIL, ::marginLeft, col)
	nb := nt
	nr := nl+2
	name := iif(name==NIL, "", name)
	::check_line(nb)
	//asize(::inbuffer, ::lines)
	if !empty(caption)
		::Text(caption, nt, nl+4,,, color)
		caption := ""
	endif
	::__nbr ++
	varname := "check"+alltrim(str(::__nbr))
	block := {|_1| iif(_1==NIL, var,var:=_1)}
	m := map()
	m:objit := getNew(nt,nl,block,varname,,color,var)
	m:objit:Control := _checkbox_(var,caption,message,color,fblock,sblock,style,bitmaps,nt,nl)
	m:color := color
	m:number := ::__nbr
	m:nt := nt
	m:nl := nl
	m:nb := nb
	m:nr := nr
	m:type := 3
	m:name := name
	aadd(::inbuffer[nt], m)
	asort(::inbuffer[nt],,,{|x, y| x:nl < y:nl})
	::n_Line := nb
	::n_Pos  := nl+3
return ::__nbr

****************
static function db_Radio(row,col,var,varname,caption,color,fblock,sblock, name)
local m, message, style, bitmaps, getList:= {}, block, varnm
local nt,nl,nb,nr
	color := iif(color==NIL .or. empty(color), ::__colors[9]+","+::__colors[10], color)
	caption := iif(caption==NIL, "", caption)
	nt := iif(row==NIL, ::lines+1, row)
	nl := iif(col==NIL, ::marginLeft, col)
	nb := nt
	nr := nl+2
	name := iif(name==NIL, "", name)
	::check_line(nb)
	//asize(::inbuffer, ::lines)
	if !empty(caption)
		::Text(caption, nt, nl+4,,, color)
		caption := ""
	endif
	::__nbr ++
	varnm := upper("radio"+varname)//alltrim(str(::__nbr))
	block := {|_1| iif(_1==NIL, var,var:=_1)}
	if !(varnm$::RadioItem)
		::RadioItem[varnm] := map()
		::RadioItem[varnm]:radio := radioGroup(nt, nl, nb, nr)
		::RadioItem[varnm]:getobj := getNew(nt,nl,block,varnm,,color,var)
		::RadioItem[varnm]:radio:sayBox := .f.
	endif
	::RadioItem[varnm]:radio:bottom := max(nb, ::RadioItem[varnm]:radio:bottom)
	::RadioItem[varnm]:radio:top := min(nt, ::RadioItem[varnm]:radio:top)
	if var!=NIL
		if valtype(var)=="L"
			var := iif(var, len(::RadioItem[varnm]:radio:__items)+1, 0)
		endif
		::RadioItem[varnm]:radio:value := var
	endif

	::RadioItem[varnm]:radio:addItem(radioButton(nt, nl, caption))
	if (var!=NIL) .and. (var == len(::RadioItem[varnm]:radio:__items))
		::RadioItem[varnm]:radio:__items[var]:setFocus()
		::RadioItem[varnm]:radio:__items[var]:buffer := .t.
		::RadioItem[varnm]:radio:value := var
	endif
	m := map()
	m:objit := ::RadioItem[varnm]:getobj
	m:objit:Control := ::RadioItem[varnm]:radio
	m:color := color
	m:number := ::__nbr
	m:nt := nt
	m:nl := nl
	m:nb := m:nt
	m:nr := nr
	m:type := 4
	m:name := name
	aadd(::inbuffer[nt], m)
	asort(::inbuffer[nt],,,{|x, y| x:nl < y:nl})
	::n_Line := nb
	::n_Pos  := nl+3
return ::__nbr
****************
static function db_GetText(top,left,bottom,right,var,color,pic,vblock,wblock,name)
local m, varname, block, getList:= {}, item, arr, length, color_item
local i,nt,nl,nb,nr
	color := iif(color==NIL .or. empty(color), ::__colors[5]+","+::__colors[6], color)
	color_item := substr(color, at(",", color)+1)
	color_item := iif(empty(color_item), ::__colors[6], color_item)
	nt := iif(top==NIL, ::lines+1, top)
	nl := iif(left==NIL, ::marginLeft, left)
	nb := iif(bottom==NIL, ::nBottom-1, bottom)
	nr := iif(right==NIL, ::nRight-1, right)
	name := iif(name==NIL, "", name)
	if var==NIL
		var := ""
	endif
	length := nr-nl+1
	::check_line(nb)
	//asize(::inbuffer, ::lines)
	::__nbr ++
	varname := "getTxt"+alltrim(str(::__nbr))
	block := {|_1| iif(_1==NIL, var,var:=_1)}
	item := TEXTGETNEW(top,left,bottom,right,block,varname,color_item,var,vblock,wblock)
	arr := split(var, "&\n")
	for i=1 to nb-nt+1
		m := map()
		m:objit := item
		m:color := color
		m:number := ::__nbr
		m:nt := nt+i-1
		m:nl := nl
		m:nb := m:nt
		m:nr := nr
		m:type := 5
		m:name := name
		aadd(::inbuffer[nt+i-1], m)
		asort(::inbuffer[nt+i-1],,,{|x, y| x:nl < y:nl})
	next
	::n_Line := nb
	::n_Pos  := nr-1
return ::__nbr


************
static function db_goto(line, pos, row, col)
	if (line==NIL .or. line < 1 .or. line > ::lines) .and. (pos==NIL .or. pos<1)
		return .f.
	endif
	::killFocus()

	if !empty(line)
		::line := line
		::rowWin := iif(row==NIL,min((::nBottom-::nTop+1)*2/3, ::line), row)
	endif
	if !empty(pos)
		::pos := pos
		::ColWin := iif(col==NIL, min((::nRight-::nLeft+1)*2/3, ::pos), col)
	endif
	::refresh()
return .t.

************
static function db_goItem(item, vref)
local i, j, found := .f., vt
	vref := iif(vref==NIL, .t., vref)
	vt := valtype(item)
	if item==NIL .or. (vt=="N" .and. (item < 1 .or. item > ::__nbr-1))
		return .f.
	endif
	::killFocus()

	for i:=1 to ::lines
		for j:=1 to len(::inbuffer[i])
			if (vt=="N" .and. ::inbuffer[i][j]:number == item) .or.;
			   (vt=="C" .and. ::inbuffer[i][j]:name == item)
				found := .t.
				::line := ::inbuffer[i][j]:nt
				::pos := ::inbuffer[i][j]:nl
				::colWin := ::pos
				::rowWin := ::line
				::item_num := j
				exit
			endif
		next
		if found
			exit
		endif
	next
	if found .and. vref
		::refresh()
	endif
return found

******************
static function db_makeStr(self, item)
local i, str:="", pr
	pr := 0
	for i:=1 to len(item)
		str += padl(padr(item[i]:txt, item[i]:nr-item[i]:nl+1), item[i]:nr-pr)
		pr := item[i]:nr
	next
return str

**************
static function db_curWord()
local word:="", i, ch
	if ::line > ::lines
		return word
	endif
	word := ::makeStr(::inbuffer[::line])
	if len(word) >= ::pos
		for i:= ::pos to 1 step -1
			ch := substr(word, i, 1)
			if !isalpha(ch) .and. !isdigit(ch) .and. ch!="_"
				word := substr(word, i+1)
				exit
			endif
		next
		for i:=1 to len(word)
			ch := substr(word, i, 1)
			if !isalpha(ch) .and. !isdigit(ch) .and. ch!="_"
				word := substr(word, 1, i)
				exit
			endif
		next
	else
		word := ""
	endif
return word
**************
static function db_find()
local found := .f., i, j, str, p, f, st, en, _step, itemstr, pr
local elem, scr
	if empty(::Find:fstring)
		return found
	endif
	str := ::Find:fstring
	p := ::pos
	if ::Find:where == 2
		if !(::strBlock .or. ::rectBlock)
			//messagep("Block not found!")
			restore screen from scr
			return .f.
		endif
		if ::Find:direct == 2  // backward
			st := max(::koordBlock[1], ::koordBlock[3])
			en := min(::koordBlock[1], ::koordBlock[3])
			_step := -1
		else
			st := min(::koordBlock[1], ::koordBlock[3])
			en := max(::koordBlock[1], ::koordBlock[3])
			_step := 1
		endif
	else
		if ::Find:direct == 2  // backward
			st := min(::line, ::lines)
			en := 1
			_step := -1
		else
			st := min(::line, ::lines)
			en := ::lines
			_step := 1
		endif
	endif

	if !::Find:case // ignore case
		str := upper(str)
	endif


	if ::Find:regexp
		for i = st to en step _step
			for j=1 to len(::inbuffer[i])
				::regSearch := {}
				elem := ::inbuffer[i][j]
				itemstr := ::getString(elem, i)
				//itemstr := strtran(itemstr, "&", "")
				f := search(str, iif(!::Find:case, upper(itemstr), itemstr), ::regSearch, p)
				if f
					if ::Find:wordonly .and. (isalpha(substr(itemstr, ::regSearch[1][1]-1, 1)) .or. isalpha(substr(itemstr, ::regSearch[1][2], 1)))
						loop
					endif
					::findR[1] := i		//line
					::findR[2] := ::regSearch[1][1]	//start pos
					::findR[3] := ::regSearch[1][2]-::regSearch[1][1]//length
					do case
					case elem:type == _GETTEXT_
						elem:objit:edit:top()
						elem:objit:edit:find(::Find)
						::findR[1] := elem:nt + elem:objit:edit:rowWin - 1
						::findR[2] := elem:nl + elem:objit:edit:pos - 1
						::colWin += ::findR[2] - ::pos + 1
						::pos := elem:nl + elem:objit:edit:colWin
					otherwise
						::findR[2] += elem:nl -1
						::colWin += ::findR[2]-::pos + 1
						::pos := elem:nl
					endcase
					::rowWin += i-(::line*_step)
					::line := i
					found := .t.
					exit
				endif
				p := 1
			next
			if found
				exit
			endif
		next
	else
		for i = st to en step _step
			for j=1 to len(::inbuffer[i])
				elem := ::inbuffer[i][j]
				itemstr := ::getString(elem, i)
				f := atl(str, substr(iif(!::Find:case, upper(itemstr), itemstr), p))
				if f > 0
					if ::Find:wordonly .and. (isalpha(substr(itemstr, p+f-2, 1)) .or. isalpha(substr(itemstr, p+f+len(str)-1, 1)))
						loop
					endif
					::findR[1] := i	//line
					::findR[2] := p+f-1	//start pos
					::findR[3] := len(str)	//length
					do case
					case elem:type == _GETTEXT_
						elem:objit:edit:top()
						elem:objit:edit:find(::Find)
						::findR[1] := elem:nt + elem:objit:edit:rowWin - 1
						::findR[2] := elem:nl + elem:objit:edit:pos - 1
						::colWin += ::findR[2] - ::pos + 1
						::pos := elem:nl + elem:objit:edit:colWin
					otherwise
						::findR[2] += elem:nl -1
						::colWin += ::findR[2]-::pos + 1
						::pos := elem:nl
					endcase
					::rowWin += i-(::line*_step)
					::line := i
					found := .t.
					exit
				endif
				p := 1
			next
			if found
				exit
			endif
		next
	endif
	if found
		::refresh()
	endif
return found
************************************************
static function db_menu_Create(enable)
local oTopBar, oPopUp, oPopUp1, oItem
local keys:=HK_get("dialog"),kn

      oTopBar := TopBar( 0, 0, maxcol())
      oTopBar:ColorSpec := set("dbox_colors_menu")

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("dbox_colors_menu")
      oTopBar:AddItem( MenuItem ( [&File],oPopUp) )

      /*
      kn:=key_name(HK_get_key(keys,HASH_Print))
      oItem :=MenuItem( [&Print...           ]+kn ,{|| .t. }, ,[Print a file], HASH_Print)
      oItem:Enabled := .f.//enable
      oPopUp:AddItem( oItem)
      */

      //oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(keys,HASH_Exit))
      oItem :=MenuItem( [E&xit   ]+kn ,{|| .t. }, ,[End of application], HASH_Exit)
      oPopUp:AddItem( oItem)

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("dbox_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Options],oPopUp) )

      kn:=key_name(HK_get_key(keys,HASH_Find))
      oItem :=MenuItem( [&Find   ]+kn ,{|| .t. }, ,[Find string], HASH_Find)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_ResumeFind))
      oItem :=MenuItem( [&Resume   ]+kn ,{|| .t. }, ,[Resume find string], HASH_ResumeFind)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_UnmarkBlock))
      oItem :=MenuItem( [&Unmark   ]+kn ,{|| .t. }, ,[Unmark selected block], HASH_UnmarkBlock)
      oPopUp:AddItem( oItem)


   return ( oTopBar)

*************
static function db_getStrElem(self, elem, line)
local str, ielem
	if "OBJIT"$elem
		ielem := elem:OBJIT
	endif

	do case
	case elem:type == _GETB_
		str := substr(ielem:buffer, 1, ielem:__winLen)
	case elem:type == _CHECK_
		str := "["+substr(ielem:Control:style, iif(ielem:Control:buffer, 2, 3),1)+"]"
	case elem:type == _RADIO_
		str := "("+iif(ielem:Control:value==line-ielem:row+1, "*", " ")+") "+ielem:Control:__items[line-ielem:row+1]:caption
	case elem:type == _GETTEXT_
		str := padr(ielem:edit:edbuffer[min(line-ielem:row+1+ielem:edit:line-ielem:edit:rowWin, ielem:edit:lines)], elem:nr-elem:nl+1)
	otherwise
		str := elem:txt
	endcase
return str

*************
static function db_getString(self, elem, line)
local str, i, ielem
	if ("OBJIT"$elem)
		ielem := elem:objit
	endif

	do case
	case elem:type == _GETB_
		str := ielem:buffer
	case elem:type == _CHECK_
		str := "["+substr(ielem:Control:style, iif(ielem:Control:buffer, 2, 3),1)+"]"
	case elem:type == _RADIO_
		str := "("+iif(ielem:Control:value==line-ielem:row+1, "*", " ")+") "+ielem:Control:__items[line-ielem:row+1]:caption
	case elem:type == _GETTEXT_
		str := ""
		for i=1 to len(ielem:edit:edbuffer)
			str += ielem:edit:edbuffer[i]+"&\t"
		next
	otherwise
		str := elem:txt
	endcase
return str

**************
static function db_cancelBlock()
	asize(::findR, 3)
	afill(::findR, NIL)
	::refresh()
return

*************
static function db_setValue(numb, value)
local elem
	if ::goItem(numb, .f.)
		elem:=::inbuffer[::line][::item_num]
	else
		return .f.
	endif
	elem:objit:varPut(value)
	//elem:objit:assign()
	::refresh()
return
