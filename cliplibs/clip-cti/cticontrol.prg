/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_CONTROL is an object, able to react on user`s actions */

#include "setcurs.ch"
#include "box.ch"

#include "cti.ch"

#define SUPERCLASS	CTI_WIDGET

/* CTI_CONTROL constructor */
function cti_control_new()
	local obj := cti_inherit(cti_widget_new(),"CTI_CONTROL")

	obj:__initialized	:= FALSE

	obj:get_value	:= @cti_control_get_value()
	obj:set_value	:= @cti_control_set_value()

	obj:can_focus		:= @cti_control_can_focus()
return obj

/************************************************************/

//static function cti_control_handle_event(obj); return nil
static function cti_control_get_value(obj); return nil
static function cti_control_set_value(obj); return nil

/************************************************************/

/*
static function cti_control_set_focus(obj)
	if .not. obj:__initialized; return .F.; endif
return TRUE
*/

static function cti_control_can_focus(obj)
//	local sup_can_focus
//	CALL SUPER obj:can_focus() TO sup_can_focus
//return sup_can_focus .and. obj:__is_enabled
return obj:__is_enabled .and. obj:__is_shown

/*
static function cti_control_kill_focus(obj)
	if .not. obj:__initialized; return FALSE; endif
return TRUE
*/
