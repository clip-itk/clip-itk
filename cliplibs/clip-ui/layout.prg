/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2005 by E/AS Software Foundation			   */
/*   Authors: 								   */
/*  	     Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*           Igor Satsyuk <satsyuk@tut.by>                                 */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Layout class */
function UILayout( )
	local obj := driver:createLayout( )

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