/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003 by E/AS Software Foundation 		           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 03 May 2004						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Workspace class */
function UIWorkSpace()
	local obj	:= driver:createInstance()
	obj:className	:= "UIWorkSpace"
	_recover_UIWORKSPACE(obj)
return obj

function _recover_UIWORKSPACE( obj )
	obj:run     	:= @ui_run()
	obj:quit	:= @ui_quit()
return obj

/* Run application in infinitive loop */
static function ui_run(self)
	driver:run( self )
return NIL

/* Quit application */
static function ui_quit(self)
	driver:quit( self )
return NIL
