/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_STATUSBAR - report messages of minor importance to the user. */

#include "cti.ch"

#define	SUPERCLASS	CTI_WIDGET

/* CTI_STATUSBAR constructor */
function cti_statusbar_new()
	local obj := cti_inherit(cti_widget_new(),"CTI_STATUSBAR")

	obj:__message	:= nil

	obj:__real_draw		:= @cti_statusbar_real_draw()
	obj:set_message		:= @cti_statusbar_set_message()
	obj:clear		:= @cti_statusbar_clear()
	obj:can_focus		:= {||FALSE}
	obj:realize_real	:= @cti_statusbar_realize_real()
return obj

/************************************************************/

/* Draw a status bar */
static function cti_statusbar_real_draw(obj)
	local message

//	setcursor(SC_NONE)

	message := padr(iif(obj:__message!=nil,obj:__message,""),obj:width)
	winbuf_out_at(obj:__buffer,0,0,message,obj:Palette:StatusBar)
return TRUE

/* Set message in status bar */
static function cti_statusbar_set_message(obj,cMsg)
	obj:__message := iif(valtype(cMsg) $ "CU",cMsg,obj:__message)
	obj:draw_queue()
return TRUE

/* Clear status bar */
static function cti_statusbar_clear(obj)
	obj:set_message(nil)
return TRUE

static function cti_statusbar_realize_real(obj)
	local parent

	if !obj:__usize_set .and. obj:parent_id != nil
		parent := cti_get_object_by_id(obj:parent_id)
		obj:__set_size(1,parent:width)
	endif
return TRUE

