/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_WIDGET is class of all visible objects in CTI */

#include "cti.ch"
#include "ctiwidget.ch"
#include "cticheckbox.ch"

/* CTI_WIDGET constructor */

#define	SUPERCLASS	CTI_OBJECT

function cti_widget_new()
	local obj

	obj := cti_inherit(cti_object_new(),"CTI_WIDGET")

	obj:top		:= nil
	obj:left	:= nil
	obj:width	:= nil
	obj:height	:= nil
	obj:__abs_top	:= nil
	obj:__abs_left	:= nil
	obj:shadow	:= FALSE
	obj:palette	:= cti_get_system_palette()

	obj:__is_focused	:= FALSE
	obj:__always_on_top	:= FALSE

	obj:__is_shown		:= FALSE
	obj:__is_draw_queued	:= FALSE
	obj:__is_realized	:= FALSE

	obj:__buffer	:= nil

	/* Virtual methods */
	obj:__real_draw		:= @cti_widget_real_draw()
	obj:__repaint		:= @cti_widget_repaint()
	obj:__set_color		:= @cti_widget_set_color()

	/* Other methods */
	obj:__make_buffer	:= @cti_widget_make_buffer()
	obj:__calc_abs_coords	:= @cti_widget_calc_abs_coords()
	obj:__draw_shadow	:= @cti_widget_draw_shadow()

	obj:show		:= {|_obj|_obj:signal_emit(HASH_CTI_SHOW_SIGNAL)}
	obj:hide		:= {|_obj|_obj:signal_emit(HASH_CTI_HIDE_SIGNAL)}
	obj:draw_queue		:= {|_obj|_obj:signal_emit(HASH_CTI_DRAW_QUEUE_SIGNAL)}
	obj:realize		:= {|_obj|_obj:signal_emit(HASH_CTI_REALIZE_SIGNAL)}

	obj:show_real		:= {|_obj|_obj:__is_shown:=TRUE, obj:draw_queue()}
	obj:hide_real		:= {|_obj|_obj:__is_shown:=FALSE}
	obj:draw_queue_real	:= @cti_widget_draw_queue_real()
	obj:realize_real	:= {|_obj|_obj:__make_buffer(),_obj:__is_realized := TRUE}

	obj:draw_now		:= @cti_widget_draw_now()
	obj:set_size		:= @cti_widget_set_size()
	obj:set_position	:= @cti_widget_set_position()
	obj:set_shadow		:= @cti_widget_set_shadow()
	obj:can_focus		:= {|_obj|_obj:__is_shown}
	obj:destroy		:= @cti_widget_destroy()

	obj:__signal_connect_internal(HASH_CTI_SHOW_SIGNAL, {|_obj|_obj:show_real()})
	obj:__signal_connect_internal(HASH_CTI_HIDE_SIGNAL, {|_obj|_obj:hide_real()})
	obj:__signal_connect_internal(HASH_CTI_DRAW_QUEUE_SIGNAL, {|_obj|_obj:draw_queue_real()})
	obj:__signal_connect_internal(HASH_CTI_REALIZE_SIGNAL, {|_obj|_obj:realize_real()})
return obj

/**********************************************************************/
/* Virtual methods */

static function cti_widget_real_draw(obj); return nil
static function cti_widget_set_color(obj); return nil

/**********************************************************************/
/* Methods */

/*
/* Sets the object obj is visible */
static function cti_widget_show(obj)
//	obj:__is_shown := TRUE
//	obj:__can_focus := TRUE

	obj:signal_emit(cti_signal_new(HASH_CTI_SHOW_SIGNAL))
//	obj:draw_queue()
return TRUE

/* Sets the object obj is hidden */
static function cti_widget_hide(obj)
//	obj:__is_shown := FALSE
	obj:signal_emit(cti_signal_new(HASH_CTI_HIDE_SIGNAL))
return
*/

static function cti_widget_calc_abs_coords(obj)
	obj:__abs_top := obj:top; obj:__abs_left := obj:left

	if obj:parent != nil
		obj:__abs_top  += obj:parent:__abs_top
		obj:__abs_left += obj:parent:__abs_left
	endif
return

/* Calculate object`s absolute position and invoke obj:real_draw() for drawn it */
static function cti_widget_draw_now(obj,buf)
	local drawn := FALSE

	if obj:__is_shown
		if !obj:__is_realized; obj:realize(); endif
		if obj:__is_draw_queued
			obj:__calc_abs_coords()
			obj:__is_draw_queued := FALSE
			drawn := obj:__real_draw()
			drawn := iif(valtype(drawn)=="L",drawn,TRUE)
			obj:signal_emit(cti_signal_new(HASH_CTI_DRAW_SIGNAL))
		endif

		if drawn .or. !obj:__is_draw_queued; obj:__repaint(buf); endif
	else
		return FALSE
	endif
return obj:__buffer != nil

/* Sets flag __is_draw_queued to inform CTI about necessiry of drawn it */
static function cti_widget_draw_queue_real(obj)
	local event

	if obj:__is_shown .and. .not. obj:__is_draw_queued
		obj:__is_draw_queued := TRUE
		event := cti_event_new(HASH_CTI_DRAW_QUEUE_EVENT)
		event:widget := obj
		cti_event_put(event)

//		obj:signal_emit(cti_signal_new(HASH_CTI_DRAW_QUEUE_SIGNAL))
	endif
return

/* Repaint widget */
static function cti_widget_repaint(obj,buf)
	if obj:__buffer==nil .or. buf==nil; return FALSE; endif
	winbuf_copy(obj:__buffer,,,,,buf,obj:top,obj:left)
	obj:__draw_shadow(buf)
return TRUE

/* Sets width and height of object */
static function cti_widget_set_size(obj,height,width)
	if valtype(width)=="N"; obj:width := width; endif
	if valtype(height)=="N"; obj:height := height; endif

	obj:__make_buffer()
	obj:signal_emit(cti_signal_new(HASH_CTI_SET_SIZE_SIGNAL))
	obj:draw_queue()
return

/* Sets coordinates of objects */
static function cti_widget_set_position(obj,top,left)
	if valtype(top)=="N"; obj:top := top; endif
	if valtype(left)=="N"; obj:left := left; endif

	obj:signal_emit(cti_signal_new(HASH_CTI_SET_POSITION_SIGNAL))
	obj:draw_queue()
return

/* Create buffer */
static function cti_widget_make_buffer(obj)
	if obj:__buffer != nil
		winbuf_destroy(obj:__buffer)
	endif
	obj:__buffer := winbuf_create(cti_cnum(obj:height),cti_cnum(obj:width))
return

/* Draw shadow for widget */
static function cti_widget_draw_shadow(obj,buf)
	local shVTop, shVBottom, shVLeft, shVRight
	local shHTop, shHBottom, shHLeft, shHRight

	if buf == nil; return FALSE; endif

	if obj:shadow
		shVLeft  := obj:left + obj:width
		shVRight := shVLeft + 1
		shVTop := obj:top + 1
		shVBottom := obj:top + obj:height

		shHLeft  := obj:left + 1
		shHRight := obj:left + obj:width
		shHTop := obj:top + obj:height
		shHBottom := shHTop

		winbuf_attr_at(buf,shVTop,shVLeft,shVBottom,shVRight,obj:Palette:Shadow)
		winbuf_attr_at(buf,shHTop,shHLeft,shHBottom,shHRight,obj:Palette:Shadow)
	endif
return TRUE

static function cti_widget_set_shadow(obj,lShadow)
	local shadow := iif(valtype(lShadow)=="L",lShadow,TRUE)
	if obj:shadow != shadow
		obj:shadow := shadow
		obj:draw_queue()
	endif
return TRUE

/* Destroys widget */
static function cti_widget_destroy(obj)
	if obj:__buffer != nil
		winbuf_destroy(obj:__buffer)
		obj:__buffer := nil
	endif
	CALL SUPER obj:destroy()
return
