/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_CHECKBOX - check boxes, which are controls that can be
	toggled on or off by a user*/

#include "cti.ch"
#include "cticontrol.ch"
#include "cticheckbox.ch"
#include "ctievents.ch"

#include "inkey.ch"

#define	SUPERCLASS	CTI_CONTROL

function cti_checkbox_new(Caption)
	local obj := cti_inherit(cti_control_new(),"CTI_CHECKBOX")

	obj:__caption		:= iif(valtype(Caption)=="C",Caption,"")
	obj:__value		:= FALSE

	obj:__mark_symbol	:= chr(0x96)

	obj:__real_draw		:= @cti_checkbox_real_draw()
	obj:__handle_event	:= @cti_checkbox_handle_event()
	obj:get_value		:= {|_obj|_obj:__value}
	obj:set_value		:= @cti_checkbox_set_value()
	obj:toggle		:= {|_obj|_obj:signal_emit(HASH_CTI_TOGGLE_SIGNAL)}
	obj:toggle_real		:= {|_obj|_obj:set_value(.not. obj:__value)}
	obj:set_caption		:= @cti_checkbox_set_caption()
	obj:set_mark_symbol	:= @cti_checkbox_set_mark_symbol()
	obj:realize_real	:= @cti_checkbox_realize_real()

	obj:__signal_connect_internal(HASH_CTI_TOGGLE_SIGNAL, {|_obj|_obj:toggle_real})
return obj

static function cti_checkbox_real_draw(obj)
	local color, s

	if obj:__is_focused
//		color := obj:Palette:ActiveControl
		color := obj:Palette:Selection
	else
		color := obj:Palette:Control
	endif
	if !obj:__is_enabled; color := obj:Palette:DisabledControl; endif

	s := padr("[" + iif(obj:__value,obj:__mark_symbol," ") + "]" + obj:__caption, obj:width)
	winbuf_out_at(obj:__buffer,0,0, s, color)
return TRUE

static function cti_checkbox_set_value(obj,value)
	if obj:__value != value
		obj:__value := value
		obj:signal_emit(cti_signal_new(HASH_CTI_CHANGED_SIGNAL))
		obj:draw_queue()
	endif
return TRUE

static function cti_checkbox_realize_real(obj)
	local h,w

	if obj:height==nil .or. obj:width==nil
		h := iif(obj:height==nil, 1, obj:height)
		w := iif(obj:width==nil, len(obj:__caption)+3, obj:width)
		obj:set_size(h,w)
	endif
	CALL SUPER obj:realize_real()
return

static function cti_checkbox_set_caption(obj,Caption)
	obj:__caption := iif(valtype(Caption)=="C",Caption,"")
	obj:draw_queue()
return

static function cti_checkbox_set_mark_symbol(obj,markSymbol)
	obj:__mark_symbol := iif(valtype(markSymbol)=="C",padr(markSymbol,1),"*")
	obj:draw_queue()
return

static function cti_checkbox_handle_event(obj,event)
***********************************************
	if event:type != CTI_KEYBOARD_EVENT; return .F.; endif

	switch (event:keycode)
		case K_SPACE
		obj:toggle()
	end
return
