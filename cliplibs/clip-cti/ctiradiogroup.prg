/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_RADIOGROUP -  */

#include "cti.ch"

#define	SUPERCLASS	CTI_OBJECT

function cti_radiogroup_new(Caption)
	local obj := cti_inherit(cti_object_new(),"CTI_RADIOGROUP")

	obj:__active_button	:= nil
	obj:__value		:= 0

	obj:get_value		:= @cti_radiogroup_get_value()

	obj:set_active		:= @cti_radiogroup_set_active()
	obj:get_active		:= @cti_radiogroup_get_active()
return obj

static function cti_radiogroup_get_value(obj)
return obj:__value

static function cti_radiogroup_get_active(obj)
return obj:__active_button

static function cti_radiogroup_set_active(obj,button)
	cti_return_if_fail(CTI_IS_RADIOBUTTON(button))
	obj:__active_button := button
return TRUE
