/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_PUSHBUTTON - control for creating push buttons */

#include "cti.ch"
#include "cticontrol.ch"
#include "ctipushbutton.ch"
#include "ctievents.ch"

#include "setcurs.ch"
#include "inkey.ch"

#define	SUPERCLASS	CTI_CONTROL

function cti_pushbutton_new(cCaption)
	local obj := cti_inherit(cti_control_new(),"CTI_PUSHBUTTON")

	obj:__caption		:= ""
	obj:__getobj		:= nil
	obj:__initialized	:= FALSE
	obj:__justification	:= CTI_JUSTIFY_CENTER
	obj:__hotkey_pos	:= -1

	obj:__real_draw		:= @cti_pushbutton_real_draw()
	obj:__make_buffer	:= @cti_pushbutton_make_buffer()
	obj:__set_color		:= @cti_pushbutton_set_color()
	obj:__calc_width	:= @cti_pushbutton_calc_width()
	obj:set_caption		:= @cti_pushbutton_set_caption()
	obj:__set_getobj_caption:= @cti_pushbutton_set_getobj_caption()
	obj:get_caption		:= @cti_pushbutton_get_caption()
	obj:set_style		:= @cti_pushbutton_set_style()
	obj:get_style		:= @cti_pushbutton_get_style()
	obj:__handle_event	:= @cti_pushbutton_handle_event()
	obj:init		:= @cti_pushbutton_init()
	obj:set_size		:= @cti_pushbutton_set_size()
	obj:set_justify		:= @cti_pushbutton_set_justify()
	obj:clicked		:= {|_obj|_obj:signal_emit(HASH_CTI_CLICKED_SIGNAL)}
	obj:clicked_real	:= {|_obj|_obj:__getobj:select(), _obj:draw_queue()}
	obj:realize_real	:= @cti_pushbutton_realize_real()

	obj:__signal_connect_internal(HASH_CTI_CLICKED_SIGNAL, {|_obj|_obj:clicked_real()})

	obj:__initialized	:= obj:init()
	if obj:__initialized
		obj:set_caption(cCaption)
	endif
return obj

static function cti_pushbutton_make_buffer(obj)
	CALL SUPER obj:__make_buffer()
	if obj:__initialized
		obj:__getobj:winbuffer := obj:__buffer
	endif
return TRUE

static function cti_pushbutton_calc_width(obj)
	local w

	w:=len(obj:__caption)
	w += min(len(obj:__getobj:style),2)
	w -= cscount("&", obj:__caption)
return w

static function cti_pushbutton_realize_real(obj)
	local h,w

	obj:height := iif(obj:height==0,nil,obj:height)
	if obj:height==nil .or. obj:width==nil
		h := iif(obj:height==nil, 1, obj:height)
		if obj:width==nil
			w := obj:__calc_width()
		else
			w := obj:width
		endif
		obj:set_size(h,w)
		obj:set_caption(obj:__caption)
	endif
	CALL SUPER obj:realize_real()
return

static function cti_pushbutton_set_caption(obj,cCaption)
	local w

	obj:__caption := iif(valtype(cCaption)=="C",cCaption,"")
//	obj:width := obj:__calc_width()
	obj:set_size(cti_cnum(obj:height),obj:__calc_width())
//	if obj:width!=nil
//		w := obj:width
//		w -= min(len(obj:__getobj:style),2)
//		w += cscount("&", obj:__caption)
//		obj:__getobj:caption := cti_text_justify(obj:__caption,w,obj:__justification)
//		obj:__getobj:caption := obj:__caption
//	endif
//outlog(__FILE__,__LINE__,procname(),obj:__calc_width(),cti_cnum(obj:height))
	//obj:realize()
	obj:draw_queue()
return TRUE

static function cti_pushbutton_set_getobj_caption(obj,cCaption)
	local w := cti_cnum(obj:width)

	w := obj:width
	w -= min(len(obj:__getobj:style),2)
	w += cscount("&", obj:__caption)
	obj:__getobj:caption := cti_text_justify(obj:__caption,w,obj:__justification)
return TRUE

static function cti_pushbutton_set_justify(obj,nJustification)
	if valtype(nJustification)!="N"; return FALSE; endif
	obj:__justification := nJustification
	obj:set_caption(obj:__caption)
	obj:draw_queue()
return TRUE

static function cti_pushbutton_set_style(obj,style)
	style := iif(valtype(style)=="C",padr(style,2),"")
	obj:__getobj:style := style
	obj:set_caption(obj:__caption)
//	obj:draw_queue()
return TRUE

static function cti_pushbutton_get_style(obj)
return obj:__getobj:style

static function cti_pushbutton_set_size(obj,height,width)
	CALL SUPER obj:set_size(height,width)

	obj:__set_getobj_caption()
return TRUE

static function cti_pushbutton_get_caption(obj,cCaption)
return obj:__getobj:caption

static function cti_pushbutton_init(obj)
	obj:__getobj := pushButton(,,obj:__caption)
	obj:__getobj:row := 0
	obj:__getobj:col := 0
return obj:__getobj != nil

static function cti_pushbutton_real_draw(obj)
	local color

	if .not. obj:__initialized; return .F.; endif

//	obj:__getobj:row := obj:__abs_top
//	obj:__getobj:col := obj:__abs_left

	if obj:__is_enabled
		obj:__set_color(obj:palette:Control+","+obj:palette:Selection)
	else
		obj:__set_color(obj:Palette:DisabledControl+","+obj:Palette:DisabledControl)
	endif

	if obj:__is_focused
		obj:__getobj:setfocus()
	else
		obj:__getobj:killfocus()
	endif

	obj:__getobj:display()
return TRUE

static function cti_pushbutton_handle_event(obj,event)
***********************************************
	if .not. obj:__initialized; return .F.; endif
	if event:type != CTI_KEYBOARD_EVENT; return .T.; endif

	switch (event:keycode)
		case K_ENTER, K_SPACE
		obj:signal_emit(cti_signal_new(HASH_CTI_CLICKED_SIGNAL))
	end
return

static function cti_pushbutton_set_color(obj,color)
	if .not. obj:__initialized; return .F.; endif
	obj:__getobj:colorSpec := color
	obj:__getobj:__setcolor()
return TRUE

