/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_RADIOBUTTON - button */

#include "cti.ch"
#include "ctiradiogroup.ch"
#include "ctievents.ch"

#include "inkey.ch"

#define	SUPERCLASS	CTI_CONTROL

function cti_radiobutton_new(Caption,group)
	local obj := cti_inherit(cti_control_new(),"CTI_RADIOBUTTON")

	obj:__caption		:= iif(valtype(Caption)=="C",Caption,"")
	obj:__value		:= FALSE
	obj:__group		:= nil
	obj:__mark_symbol	:= "*"

	obj:__real_draw		:= @cti_radiobutton_real_draw()
	obj:__handle_event	:= @cti_radiobutton_handle_event()
	obj:get_value		:= {|_obj|_obj:value}
	obj:set_value		:= @cti_radiobutton_set_value()
	obj:set_caption		:= @cti_radiobutton_set_caption()
	obj:set_mark_symbol	:= @cti_radiobutton_set_mark_symbol()
	obj:set_group		:= @cti_radiobutton_set_group()
	obj:toggle		:= {|_obj|_obj:signal_emit(HASH_CTI_TOGGLE_SIGNAL)}
	obj:toggle_real		:= {|_obj|_obj:set_value(!_obj:__value)}
	obj:realize_real	:= @cti_radiobutton_realize_real()

	obj:__signal_connect_internal(HASH_CTI_TOGGLE_SIGNAL, {|_obj|_obj:toggle_real()})

	if group!=nil
		obj:set_group(group)
	endif
return obj

static function cti_radiobutton_real_draw(obj)
	local color, s

//	if obj:__buffer == nil; obj:set_size(1,len(obj:__caption)+3); endif

	if obj:__is_focused
//		color := obj:Palette:ActiveControl
		color := obj:Palette:Selection
	else
		color := obj:Palette:Control
	endif
	if !obj:__is_enabled; color := obj:Palette:DisabledControl; endif

	s := padr("(" + iif(obj:__value,obj:__mark_symbol," ") + ")" + obj:__caption, obj:width)
	winbuf_out_at(obj:__buffer,0,0, s, color)
return .T.

static function cti_radiobutton_set_value(obj,value)
	local active

	if obj:__value != value
		if value==TRUE .and. obj:__group != nil
			active := obj:__group:get_active()
			if active != nil
				active:set_value(FALSE)
			endif
			obj:__group:set_active(obj)
		endif
		obj:__value := value
		obj:signal_emit(cti_signal_new(HASH_CTI_CHANGED_SIGNAL))
//		obj:signal_emit(cti_signal_new(HASH_CTI_TOGGLED_SIGNAL))
		obj:draw_queue()
	endif
return TRUE

static function cti_radiobutton_realize_real(obj)
	local h,w

	if obj:height==nil .or. obj:width==nil
		h := iif(obj:height==nil, 1, obj:height)
		w := iif(obj:width==nil, len(obj:__caption)+3, obj:width)
		obj:set_size(h,w)
	endif
	CALL SUPER obj:realize_real()
return

static function cti_radiobutton_set_group(obj,group)
	cti_return_if_fail(CTI_IS_RADIOGROUP(group))
	obj:__group := group
	if group:get_active() == nil
		obj:set_value(TRUE)
	endif
return TRUE

static function cti_radiobutton_set_caption(obj,Caption)
	obj:__caption := iif(valtype(Caption)=="C",Caption,"")
	obj:draw_queue()
return

static function cti_radiobutton_set_mark_symbol(obj,markSymbol)
	obj:__mark_symbol := iif(valtype(markSymbol)=="C",padr(markSymbol,1),"*")
	obj:draw_queue()
return

static function cti_radiobutton_handle_event(obj,event)
***********************************************
	if event:type != CTI_KEYBOARD_EVENT; return .F.; endif

	switch (event:keycode)
		case K_SPACE
		obj:set_value(TRUE)
	end
return
