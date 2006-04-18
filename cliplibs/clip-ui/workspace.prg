/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*									   */
/*   Copyright (C) 2003 by E/AS Software Foundation 			   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Workspace class */
function UIWorkSpace( params )
	local obj	:= driver:createInstance( params )
	obj:className	:= "UIWorkSpace"
	obj:onQuit 	:= NIL
	_recover_UIWORKSPACE(obj)
return obj

function _recover_UIWORKSPACE( obj )
	obj:setAction   := @ui_setAction()
	obj:run     	:= @ui_run()
	obj:quit	:= @ui_quit()
return obj

/* Set callback function on quit */
static function ui_setAction(self, signal, action)
	if lower(signal)=='quit' .and. valtype(action)=='B'
		self:onQuit := action
	endif
return NIL

/* Run application in infinitive loop */
static function ui_run(self)
	driver:run( self )
return NIL

/* Quit application */
static function ui_quit(self)
	if self:onQuit != NIL
		eval( self:onQuit )
	endif
	driver:quit( self )
return NIL
