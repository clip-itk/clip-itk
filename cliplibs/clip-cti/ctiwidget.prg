/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_WIDGET is class of all visible objects in CTI */

#include "cti.ch"

#include "setcurs.ch"

/* CTI_WIDGET constructor */

#define	SUPERCLASS	CTI_OBJECT

function cti_widget_new()
	local obj

	obj := cti_inherit(cti_object_new(),"CTI_WIDGET")

	obj:__abs_top		:= nil
	obj:__abs_left		:= nil
	obj:__tab_index		:= 0

	obj:__utop		:= nil
	obj:__uleft		:= nil
	obj:__uwidth		:= nil
	obj:__uheight		:= nil
	obj:top			:= nil
	obj:left		:= nil
	obj:width		:= nil
	obj:height		:= nil

	obj:shadow		:= FALSE
	obj:palette		:= cti_get_system_palette()

	obj:__is_focused	:= FALSE
	obj:__always_on_top	:= FALSE

	obj:__frozen 		:= FALSE
	obj:__is_enabled	:= TRUE
	obj:__is_shown		:= FALSE
	obj:__is_draw_queued	:= FALSE
	obj:__repaint_queued	:= FALSE
	obj:__is_toplevel	:= FALSE
	obj:__is_realized	:= FALSE
	obj:__size_set		:= FALSE
	obj:__position_set	:= FALSE
	obj:__usize_set		:= FALSE
	obj:__uposition_set	:= FALSE

	obj:__buffer		:= nil
	obj:__buf_dirty		:= TRUE
	obj:__keymap		:= map()

	obj:__real_draw		:= {|_obj|_obj:__buf_dirty := TRUE }
//	obj:__repaint		:= @cti_widget_repaint()
	obj:__set_color		:= {||}
	obj:__set_cursor	:= {||setcursor(SC_NONE)}

	obj:__make_buffer	:= @cti_widget_make_buffer()
	obj:__calc_abs_coords	:= @cti_widget_calc_abs_coords()
	obj:__draw_shadow	:= @cti_widget_draw_shadow()
	obj:__handle_event	:= @cti_widget_handle_event()

	obj:parent		:= {|_obj|iif(_obj:parent_id!=nil,cti_get_object_by_id(_obj:parent_id),nil)}
	obj:show		:= {|_obj|_obj:signal_emit(HASH_CTI_SHOW_SIGNAL)}
	obj:show_all		:= @cti_widget_show_all()
	obj:hide		:= {|_obj|_obj:signal_emit(HASH_CTI_HIDE_SIGNAL)}
	obj:hide_all		:= @cti_widget_hide_all()
	obj:draw_queue		:= {|_obj|_obj:signal_emit(HASH_CTI_DRAW_QUEUE_SIGNAL)}
	obj:draw		:= obj:draw_queue
	obj:show_real		:= {|_obj|_obj:__is_shown:=TRUE, obj:draw_queue()}
	obj:hide_real		:= {|_obj|_obj:__is_shown:=FALSE}
	obj:draw_queue_real	:= @cti_widget_draw_queue_real()
	obj:draw_now		:= @cti_widget_draw_now()
	obj:repaint_queue	:= {|_obj|_obj:signal_emit(HASH_CTI_REPAINT_QUEUE_SIGNAL)}
	obj:repaint		:= obj:repaint_queue
	obj:repaint_real	:= @cti_widget_repaint_real()
	obj:repaint_queue_real	:= @cti_widget_repaint_queue_real()

	obj:realize		:= {|_obj|_obj:signal_emit(HASH_CTI_REALIZE_SIGNAL)}
	obj:realize_real	:= @cti_widget_realize_real()
	obj:unrealize		:= {|_obj|_obj:signal_emit(HASH_CTI_UNREALIZE_SIGNAL)}
	obj:unrealize_real	:= {|_obj|_obj:__is_realized := FALSE}
	obj:set_size		:= @cti_widget_set_size()
	obj:__set_size		:= @cti_widget_set_size_internal()
	obj:set_position	:= @cti_widget_set_position()
	obj:__set_position	:= @cti_widget_set_position_internal()
	obj:__set_real_size	:= @cti_widget_set_real_size()
	obj:__set_real_position	:= @cti_widget_set_real_position()
	obj:set_shadow		:= @cti_widget_set_shadow()
//	obj:can_focus		:= {|_obj|_obj:__is_shown}
	obj:can_focus		:= {||FALSE}
	obj:destroy		:= @cti_widget_destroy()
	obj:is_focus		:= {|_obj|_obj:__is_focused} /* Alena */
	obj:get_toplevel	:= @cti_widget_get_toplevel()
	obj:set_focus		:= {|_obj|_obj:signal_emit(HASH_CTI_WIDGET_SET_FOCUS_SIGNAL)}
	obj:set_focus_real	:= @cti_widget_set_focus_real()
	obj:lost_focus		:= {|_obj|_obj:signal_emit(HASH_CTI_WIDGET_LOST_FOCUS_SIGNAL)}
	obj:lost_focus_real	:= @cti_widget_lost_focus_real()
	obj:freeze		:= {|_obj|_obj:__frozen := TRUE}
	obj:thaw		:= {|_obj|_obj:__frozen := FALSE,_obj:draw_queue()}
	obj:set_enabled		:= @cti_widget_set_enabled()
	obj:is_enabled		:= {|_obj|_obj:__is_enabled}

	obj:__debug_paint	:= @cti_widget_debug_paint()

	obj:set_key		:= @cti_widget_set_key()
	obj:apply_key		:= @cti_widget_apply_key()

	obj:__signal_connect_internal(HASH_CTI_SHOW_SIGNAL, {|_obj|_obj:show_real()})
	obj:__signal_connect_internal(HASH_CTI_HIDE_SIGNAL, {|_obj|_obj:hide_real()})
	obj:__signal_connect_internal(HASH_CTI_DRAW_QUEUE_SIGNAL, {|_obj|_obj:draw_queue_real()})
	obj:__signal_connect_internal(HASH_CTI_REPAINT_QUEUE_SIGNAL, {|_obj|_obj:repaint_queue_real()})
	obj:__signal_connect_internal(HASH_CTI_REALIZE_SIGNAL, {|_obj|_obj:realize_real()})
	obj:__signal_connect_internal(HASH_CTI_UNREALIZE_SIGNAL, {|_obj|_obj:unrealize_real()})
	obj:__signal_connect_internal(HASH_CTI_WIDGET_SET_FOCUS_SIGNAL, {|_obj|_obj:set_focus_real()})
	obj:__signal_connect_internal(HASH_CTI_WIDGET_LOST_FOCUS_SIGNAL, {|_obj|_obj:lost_focus_real()})
return obj

/**********************************************************************/
/* Methods */

static function cti_widget_debug_paint(obj)
	winbuf_display(obj:__buffer,0,0)
	inkey(1)
return TRUE


static function cti_widget_calc_abs_coords(obj)
	local parent

	obj:__abs_top := obj:top; obj:__abs_left := obj:left

	parent := cti_get_object_by_id(obj:parent_id)
	if parent != nil
		obj:__abs_top  = cti_cnum(obj:__abs_top) + cti_cnum(parent:__abs_top)
		obj:__abs_left = cti_cnum(obj:__abs_left) + cti_cnum(parent:__abs_left)

	endif
return

/* Calculate object`s absolute position and invoke obj:real_draw() for drawn it */
static function cti_widget_draw_now(obj)
	local drawn := FALSE

	if obj:__is_shown .and. !obj:__frozen
		if !obj:__is_realized; obj:realize(); endif
		if obj:__is_draw_queued
			obj:__calc_abs_coords()
			obj:__is_draw_queued := FALSE
			drawn := obj:__real_draw()
			drawn := iif(valtype(drawn)=="L",drawn,TRUE)
			obj:signal_emit(cti_signal_new(HASH_CTI_DRAWN_SIGNAL))
		endif

//		if drawn .or. !obj:__is_draw_queued; obj:__repaint(); endif
		if drawn
			obj:repaint_queue()
		endif
	else
		return FALSE
	endif
return TRUE

/* Sets flag __is_draw_queued to inform CTI about necessiry of drawn it */
static function cti_widget_draw_queue_real(obj)
	local event

	if obj:__is_shown .and. .not. obj:__is_draw_queued
		obj:__is_draw_queued := TRUE
		event := cti_event_new(HASH_CTI_DRAW_QUEUE_EVENT)
		event:widget := obj
		cti_event_put(event)

		obj:signal_emit(cti_signal_new(HASH_CTI_DRAW_QUEUE_SIGNAL))
	endif
return

static function cti_widget_repaint_queue_real(obj)
	local event

	if obj:__is_shown .and. !obj:__repaint_queued
		event := cti_event_new(HASH_CTI_REPAINT_QUEUE_EVENT)
		event:widget := obj
		cti_event_put(event)
		obj:__repaint_queued := TRUE
	endif
return

/* Repaint widget */
static function cti_widget_repaint_real(obj,buf)
	local parent := cti_get_object_by_id(obj:parent_id)

	obj:__repaint_queued := FALSE
	obj:__buf_dirty := TRUE
	if parent!=nil
		parent:repaint()
	endif
return TRUE

/* Sets width and height of object */
static function cti_widget_set_size(obj,height,width)
	obj:__set_size(height,width)
	obj:__usize_set := TRUE
return

/* Sets width and height of object (for internal use) */
static function cti_widget_set_size_internal(obj,height,width)
	local parent := cti_get_object_by_id(obj:parent_id)

	obj:__size_set := FALSE

	if valtype(height)=="N"
		obj:height := obj:__uheight := height
	endif
	if valtype(width)=="N"
		obj:width := obj:__uwidth := width
	endif

	if parent != nil
		parent:__size_allocate(obj)
	endif
return

/* Sets coordinates of objects */
static function cti_widget_set_position(obj,top,left)
	obj:__set_position(top,left)
	obj:__uposition_set := TRUE
return

/* Sets coordinates of objects (for internal use) */
static function cti_widget_set_position_internal(obj,top,left)
	local parent := cti_get_object_by_id(obj:parent_id)

	obj:__position_set := FALSE

	if valtype(top)=="N"
		obj:top := obj:__utop := top
	endif
	if valtype(left)=="N"
		obj:left := obj:__uleft := left
	endif
	if parent != nil
		parent:__position_allocate(obj)
	endif
return

/* Sets width and height of object */
static function cti_widget_set_real_size(obj,height,width)
	if valtype(width)=="N"
		obj:width := width
	endif
	if valtype(height)=="N"
		obj:height := height
	endif

	obj:__size_set := TRUE

	obj:__make_buffer()
	obj:signal_emit(cti_signal_new(HASH_CTI_SET_SIZE_SIGNAL))
	obj:draw_queue()
return

/* Sets coordinates of objects */
static function cti_widget_set_real_position(obj,top,left)
	local sig

	sig := cti_signal_new(HASH_CTI_SET_POSITION_SIGNAL)
	sig:old_top := obj:top
	sig:old_left := obj:left

	if valtype(top)=="N"
		obj:top := top
	endif
	if valtype(left)=="N"
		obj:left := left
	endif

	obj:__position_set := TRUE

	sig:top := obj:top
	sig:left := obj:left

	obj:signal_emit(sig)
	obj:draw_queue()
return

/* Create buffer */
static function cti_widget_make_buffer(obj)
	local h,w

	if obj:__buffer != nil
		winbuf_destroy(obj:__buffer)
		obj:__buffer := nil
	endif

	h := cti_cnum(obj:height); w := cti_cnum(obj:width)
	if h<0; h:=0; endif; if w<0; w:=0; endif;

	obj:__buffer := winbuf_create(h,w)
return

/* Draw shadow for widget */
static function cti_widget_draw_shadow(obj,buf)
	local shVTop, shVBottom, shVLeft, shVRight
	local shHTop, shHBottom, shHLeft, shHRight

	if buf == nil; return FALSE; endif

	if obj:shadow
		shVLeft  := cti_cnum(obj:left) + cti_cnum(obj:width)
		shVRight := shVLeft + 1
		shVTop := cti_cnum(obj:top) + 1
		shVBottom := cti_cnum(obj:top) + cti_cnum(obj:height)

		shHLeft  := cti_cnum(obj:left) + 1
		shHRight := cti_cnum(obj:left) + (obj:width)
		shHTop := cti_cnum(obj:top) + (obj:height)
		shHBottom := shHTop

		winbuf_attr_at(buf,shVTop,shVLeft,shVBottom,shVRight,obj:Palette:Shadow)
		winbuf_attr_at(buf,shHTop,shHLeft,shHBottom,shHRight,obj:Palette:Shadow)
	endif
return TRUE

static function cti_widget_set_shadow(obj,lShadow)
	local shadow := iif(valtype(lShadow)=="L",lShadow,TRUE)
	if obj:shadow != shadow
		obj:shadow := shadow
		obj:repaint()
	endif
return TRUE

static function cti_widget_set_key(obj, nKey, Handler, Param)
	local ret:=nil,m := obj:__keymap

	cti_return_if_fail(valtype(nKey)=="N", nil)
	cti_return_if_fail(Handler==nil .or. valtype(Handler)=="B", nil)

	if nkey $ m
		ret := m[nKey]
	endif
	if pcount() > 2   /* self as first parameter */
		m[nKey] := {Handler, Param}
	endif
	if nKey $ m .and. m[nKey,1] == NIL
		adel(m, nKey)
	endif
return ret

static function cti_widget_apply_key(obj, nKey)
	local ret := FALSE

	cti_return_if_fail(valtype(nKey)=="N")

	if nKey $ obj:__keymap
		ret := eval(obj:__keymap[nKey][1],obj, nKey, obj:__keymap[nKey][2])
		ret := iif(valtype(ret)=="L",ret,TRUE)
	endif
return ret

/* Destroys widget */
static function cti_widget_destroy(obj)
//outlog(__FILE__,__LINE__,procname(),obj:name,obj:id)
	obj:freeze()
	obj:lost_focus()

	CALL SUPER obj:destroy()

	obj:unrealize()

	if obj:__buffer != nil
		winbuf_destroy(obj:__buffer)
		obj:__buffer := nil
	endif
return

static function cti_widget_handle_event(obj,event)
	if event:type != CTI_KEYBOARD_EVENT; return FALSE; endif
return obj:apply_key(event:keycode)

static function cti_widget_show_all(obj)
	obj:show()
	if CTI_IS_CONTAINER(obj)
		obj:for_each({|_obj|_obj:show_all()})
	endif
return TRUE

static function cti_widget_hide_all(obj)
	obj:show()
	if CTI_IS_CONTAINER(obj)
		obj:for_each({|_obj|_obj:hide_all()})
	endif
return TRUE

static function cti_widget_get_toplevel(obj)
	local widget := cti_get_object_by_id(obj:parent_id)

	do while widget != nil
		if widget:__is_toplevel
			exit
		endif
		widget := cti_get_object_by_id(widget:parent_id)
	enddo
return widget

static function cti_widget_lost_focus_real(obj)
	local toplevel, widget := nil, parent

	if !obj:__is_focused
		return FALSE
	endif

	widget := obj:parent()
	do while widget!=nil
		if widget:__is_toplevel
			widget:__toplevel_set_focus(nil)
			exit
		else
			widget:__set_focus_child(nil)
		endif
		widget := widget:parent()
	enddo

	obj:__is_focused := FALSE
	obj:draw_queue()
return TRUE

static function cti_widget_set_focus_real(obj)
	local toplevel, widget := nil
	local parent, sig

	if !obj:__is_shown .and. !obj:can_focus()
		return FALSE
	endif

	if obj:__is_focused
		return TRUE
	endif

	toplevel := obj:get_toplevel()

	if toplevel!=nil .and. toplevel:__is_toplevel
		widget := toplevel:__focus_widget
		if widget!=nil
			if obj:id == widget:id
				return TRUE
			endif
			sig := cti_signal_new(HASH_CTI_WIDGET_LOST_FOCUS_SIGNAL)
			sig:new_focus := obj
			if !widget:signal_emit(sig)
				return FALSE
			endif
		endif
	endif
	widget := obj
	parent := cti_get_object_by_id(widget:parent_id)
	do while parent!=nil .and. !CTI_IS_APPLICATION(parent)
		parent:__set_focus_child(widget)
		widget := parent
		parent := cti_get_object_by_id(widget:parent_id)
	enddo
	parent := cti_get_object_by_id(obj:parent_id)
	if CTI_IS_APPLICATION(parent)
		cti_get_object_by_id(widget:parent_id):__set_focus_child(widget)
		widget := cti_get_object_by_id(widget:parent_id)
	endif
	if widget != nil .and. widget:__is_toplevel
		widget:__toplevel_set_focus(obj)
	endif
	obj:__is_focused := TRUE
	obj:draw_queue()
return TRUE

static function cti_widget_realize_real(obj)
	local parent := cti_get_object_by_id(obj:parent_id)

	if parent != nil .and. !parent:__is_realized
		parent:realize()
	endif
	if !obj:__size_set .and. parent != nil
		parent:__size_allocate(obj)
	endif
	obj:__make_buffer()
	obj:__is_realized := TRUE
	if obj:__is_focused
		obj:set_focus()
	endif
return TRUE

static function cti_widget_set_enabled(obj,enabled)
	if valtype(enabled) != "L"; return FALSE; endif
	if obj:__is_enabled != enabled; obj:draw_queue(); endif
	obj:__is_enabled := enabled
return TRUE

