/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_PUSHBUTTON - control for creating push buttons */

#include "cti.ch"

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
	obj:init		:= @cti_pushbutton_init()
//	obj:set_size		:= @cti_pushbutton_set_size()
	obj:set_justify		:= @cti_pushbutton_set_justify()
	obj:clicked		:= {|_obj|_obj:signal_emit(HASH_CTI_CLICKED_SIGNAL)}
//	obj:clicked_real	:= {|_obj|_obj:__getobj:select(), _obj:draw_queue()}
	obj:clicked_real	:= {|_obj|_obj:draw_queue()}
	obj:realize_real	:= @cti_pushbutton_realize_real()

	obj:__signal_connect_internal(HASH_CTI_CLICKED_SIGNAL, {|_obj|_obj:clicked_real(),TRUE})
	obj:__signal_connect_internal(HASH_CTI_SET_SIZE_SIGNAL, {|_obj| ;
		_obj:__set_getobj_caption(), ;
		_obj:__getobj:row := int(_obj:height/2-0.5), ;
		TRUE})

	obj:__initialized	:= obj:init()
	if obj:__initialized
		obj:set_caption(cCaption)
	endif
	obj:set_key(K_ENTER, obj:clicked)
	obj:set_key(K_SPACE, obj:clicked)
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

	CALL SUPER obj:realize_real()
	if !obj:__usize_set
		w := iif(obj:__uwidth==nil,obj:__calc_width(),obj:__uwidth)
		h := cti_cnum(iif(obj:__uheight==nil,obj:height,obj:__uheight))
		obj:__set_real_size(h,w)
//		obj:set_caption(obj:__caption)
		obj:__set_getobj_caption()
	endif
return

static function cti_pushbutton_set_caption(obj,cCaption)
	local h

	obj:__caption := iif(valtype(cCaption)=="C",cCaption,"")
	if !obj:__usize_set
		h := iif(obj:__size_set,cti_cnum(obj:height),1)
		obj:__set_size(h,obj:__calc_width())
	else
		obj:__set_getobj_caption()
		obj:__set_size(obj:__uheight,obj:__uwidth)
	endif

	obj:draw_queue()
return TRUE

static function cti_pushbutton_set_getobj_caption(obj,cCaption)
	local w

	if obj:__size_set
		w := obj:width
	else
		if obj:__usize_set
			w := obj:__uwidth
		else
			w := len(cCaption)
		endif
	endif
//	w := cti_cnum(iif(obj:__size_set,obj:width,obj:__uwidth))
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

/*
static function cti_pushbutton_set_size(obj,height,width)
	CALL SUPER obj:set_size(height,width)

	obj:__set_getobj_caption()
return TRUE
*/

static function cti_pushbutton_get_caption(obj,cCaption)
return obj:__getobj:caption

static function cti_pushbutton_init(obj)
	obj:__getobj := pushButton(,,obj:__caption)
	obj:__getobj:row := 0
	obj:__getobj:col := 0
return obj:__getobj != nil

static function cti_pushbutton_real_draw(obj)
	local color, bg

	if .not. obj:__initialized; return .F.; endif

	CALL SUPER obj:__real_draw()

//	obj:__getobj:row := obj:__abs_top
//	obj:__getobj:col := obj:__abs_left

	if obj:__is_enabled
		bg := substr(obj:palette:Control,at("/",obj:palette:Control)+1)
		color := obj:palette:Control+","+obj:palette:Selection+",,"+obj:palette:AccelKey+"/"+bg
		obj:__set_color(color)
	else
		bg := substr(obj:Palette:DisabledControl,at("/",obj:Palette:DisabledControl)+1)
		color := obj:Palette:DisabledControl+","+obj:Palette:DisabledControl+",,"+obj:palette:AccelKey+"/"+bg
		obj:__set_color(color)
	endif

	if obj:__is_focused
		obj:__getobj:setfocus()
	else
		obj:__getobj:killfocus()
	endif

	color := iif(obj:__is_focused,obj:palette:Selection,obj:palette:Control)
	winbuf_attr_at(obj:__buffer,0,0,obj:height-1,obj:width-1,color)
//	winbuf_attr_at(obj:__buffer,0,0,obj:height-1,obj:width-1,obj:Palette:Window)
	obj:__getobj:display()
return TRUE

static function cti_pushbutton_set_color(obj,color)
	if .not. obj:__initialized; return .F.; endif
	obj:__getobj:colorSpec := color
	obj:__getobj:__setcolor()
return TRUE

