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
#include "ctievents.ch"
#include "ctisignal.ch"
#include "cticontrol.ch"

#define SUPERCLASS	CTI_WIDGET

/* CTI_CONTROL constructor */
function cti_control_new()
	local obj := cti_inherit(cti_widget_new(),"CTI_CONTROL")

	obj:__is_enabled	:= TRUE
//	obj:__can_focus		:= TRUE

	obj:__initialized	:= FALSE

	/* Virtual methods */
	obj:__handle_event	:= @cti_control_handle_event()
	obj:__set_cursor	:= @cti_control_set_cursor()

	obj:get_value	:= @cti_control_get_value()
	obj:set_value	:= @cti_control_set_value()

	/* Non-virtual methods */
	obj:is_enabled		:= @cti_control_is_enabled()
	obj:set_enabled		:= @cti_control_set_enabled()
	obj:can_focus		:= @cti_control_can_focus()

	obj:__set_focus		:= @cti_control_set_focus()
	obj:__kill_focus	:= @cti_control_kill_focus()
return obj

/************************************************************/

static function cti_control_handle_event(obj); return nil
static function cti_control_get_value(obj); return nil
static function cti_control_set_value(obj); return nil

static function cti_control_set_cursor(obj)
	setcursor(SC_NONE)
return

/************************************************************/

static function cti_control_set_focus(obj)
	if .not. obj:__initialized; return .F.; endif
return TRUE

static function cti_control_can_focus(obj)
	local sup_can_focus
	CALL SUPER obj:can_focus() TO sup_can_focus
return sup_can_focus .and. obj:__is_enabled

static function cti_control_set_enabled(obj,enabled)
	if valtype(enabled) != "L"; return FALSE; endif
	if obj:__is_enabled != enabled; obj:draw_queue(); endif
	obj:__is_enabled := enabled
return TRUE

static function cti_control_is_enabled(obj)
return obj:__is_enabled

static function cti_control_kill_focus(obj)
	if .not. obj:__initialized; return .F.; endif
return .T.
