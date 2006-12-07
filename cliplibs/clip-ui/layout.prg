/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2005 by E/AS Software Foundation                        */
/*   Authors:                                                              */
/*               Andrey Cherepanov <skull@eas.lrn.ru>                      */
/*           Igor Satsyuk <satsyuk@tut.by>                                 */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* UILayout class */
function UILayout()
	local obj 	  := driver:createLayout( )
	obj:className := "UILayout"
	_recover_UILayout(obj)
return obj

function _recover_UILayout( obj )
	obj:add 	:= @ui_add()
	obj:move 	:= @ui_move()
return obj

static function ui_add(self, o, pos)
	local a, x, y
	a := split(iif(empty(pos),"",pos), ',')
	x := val(a[1])
	y := iif(len(a)>1, val(a[2]), 0)
	driver:addLayout(self, o, x, y)
return self

static function ui_move(self, o, pos)
	local a, x, y
	a := split(iif(empty(pos),"0,0",pos), ',')
	x := val(a[1])
	y := iif(len(a)>1, val(a[2]), NIL)
	driver:moveLayout(self, o, x, y)
return self

/* UITabArea class */
function UITabArea()
	local obj 	  := driver:createTabArea()
	obj:className := "UITabArea"
	obj:tabs	  := array(0)
	_recover_UITABAREA(obj)
	_recover_UITABCOMMON(obj)
return obj

/* UITab class */
function UITab(caption, name)
	local obj 	  := driver:createTab(caption, name)
	obj:className := "UITab"
	obj:name 	  := name
	obj:parent    := NIL
	_recover_UITAB(obj)
	_recover_UITABCOMMON(obj)
return obj

function _recover_UITABAREA( obj )
	obj:add  := @ui_tabAdd()
return obj

function _recover_UITABCOMMON( obj )
	obj:show := @ui_tabShow()
	obj:hide := @ui_tabHide()
return obj

function _recover_UITAB( obj )
	obj:activate    := @ui_tabActivate()
	obj:setCaption  := @ui_tabSetCaption()
return obj

static function ui_tabAdd(self, tab, pos)
	if valtype(tab) == 'O' .and. 'CLASSNAME' $ tab .and. tab:className == "UITab"
		driver:addTab(self, tab, pos)
		aadd(self:tabs, tab)
		tab:parent := self
	endif
return self

static function ui_tabVisible(self, pos, flag)
	local o:=NIL, p:=NIL, i
	
	if self:className == "UITab"
		o := self
		if 'PARENT' $ self
			p := self:parent
		endif
	elseif self:className == "UITabArea"
		p := self
	endif
	
	if valtype(pos) != 'U' .or. o == NIL
		switch valtype(pos)
			case 'O' // by object
				o := pos
			case 'N' // by index
				if valtype(p) == 'O' .and. pos > 0 .and. pos <= len(p:tabs)
					o := p:tabs[ pos ]
				endif
			case 'C' // by name
				if valtype(p) == 'O'
					i := ascan(p:tabs, {|e| e:name == pos })
					if i > 0
						o := p:tabs[ i ]
					endif
				endif

			otherwise
				return NIL
		endswitch
	endif
	
	if o != NIL
		driver:showWidget(o, flag)
	endif
return NIL

static function ui_tabShow(self, pos)
	ui_tabVisible(self, pos, .T.)
return NIL

static function ui_tabHide(self, pos)
	ui_tabVisible(self, pos, .F.)
return NIL

static function ui_tabActivate(self)
	driver:activateTab(self)
return NIL

static function ui_tabSetCaption(self, caption)
	driver:setTabCaption(self, caption)
return NIL