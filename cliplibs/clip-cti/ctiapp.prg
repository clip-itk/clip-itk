/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_APPLICATION - main object, contains all windows and other objects. */
/* This class usually have only one object */

#include "cti.ch"

#include "setcurs.ch"

#define SUPERCLASS	CTI_WIDGET

function cti_application_new()
	local obj := cti_inherit(cti_widget_new(),"CTI_APPLICATION")

	obj:FillChar		:= chr(0x90)

	obj:__is_toplevel	:= TRUE

	obj:__buf_app		:= nil

	obj:__ZOrder		:= cti_zorder_new()

	obj:__children		:= {}
	obj:__focus_widget	:= nil

	obj:__real_draw		:= @cti_application_real_draw()
	obj:__make_buffer	:= @cti_application_make_buffer()
	obj:__draw_background	:= @cti_application_draw_background()
	obj:__set_focus_to_top	:= @cti_application_set_focus_to_top()
	obj:__handle_event	:= @cti_application_handle_event()
	obj:__size_allocate	:= @cti_application_size_allocate()
	obj:__position_allocate	:= @cti_application_position_allocate()
	obj:__set_focus_child	:= @cti_application_set_focus_child_real()
	obj:__toplevel_set_focus:= @cti_application_toplevel_set_focus()

	obj:repaint_real	:= @cti_application_repaint_real()
	obj:realize_real	:= @cti_application_realize_real()
	obj:set_size		:= @cti_application_set_size()
	obj:set_position	:= @cti_application_set_position()
	obj:set_focus_to_top_window	:= @cti_application_set_focus_to_top_window()
	obj:get_active_window	:= @cti_application_get_active_window()
	obj:get_active_window_id:= @cti_application_get_active_window_id()
	obj:add			:= @cti_application_add()
	obj:remove		:= @cti_application_remove()
	obj:move_widget_to_top	:= @cti_application_move_widget_to_top()
	obj:set_focus_child	:= @cti_application_set_focus_child()
	obj:focus_next_window	:= @cti_application_set_focus_next_window()
	obj:focus_prev_window	:= @cti_application_set_focus_prev_window()
	obj:show_all		:= @cti_application_show_all()
	obj:hide_all		:= @cti_application_hide_all()

	obj:destroy		:= @cti_application_destroy()

	obj:set_size(maxrow()+1,maxcol()+1)
return obj

/********************************************************************/
/* Methods */

/* Draw zero window and objects in it */
static function cti_application_real_draw(obj)
	local zlist, i, zlen, child

	CALL SUPER obj:__real_draw()

	winbuf_copy(obj:__buf_app,,,,,obj:__buffer)

	zlist := obj:__ZOrder:get_objlist()
	zlen := obj:__ZOrder:len()
	for i:=1 to zlen
		if zlist[i]:__is_shown
			zlist[i]:__buf_dirty := TRUE
		endif
	next
return TRUE


/* Creates additional buffer for object Application */
static function cti_application_make_buffer(obj)
	CALL SUPER obj:__make_buffer()

	if obj:__buf_app != nil
		winbuf_destroy(obj:__buf_app)
	endif
	obj:__buf_app := winbuf_create(cti_cnum(obj:height),cti_cnum(obj:width))

	obj:__draw_background()
return TRUE

static function cti_application_set_size(obj,height,width)
	if valtype(width)=="N"
		obj:width := width
	endif

	if valtype(height)=="N"
		obj:height := height
	endif

	CALL SUPER obj:set_size(height,width)
return TRUE

static function cti_application_set_position(obj,top,left)
	if valtype(top)=="N"
		obj:top := top
	endif

	if valtype(left)=="N"
		obj:left := left
	endif

	CALL SUPER obj:set_position(top,left)
return TRUE

/* Repaint application */
static function cti_application_repaint_real(obj)
	local zlist, zlen, i
	local wid

	CALL SUPER obj:repaint_real()

	zlist := obj:__ZOrder:get_objlist()
	zlen := obj:__ZOrder:len()
	i:=1
	do while i<=zlen
		if zlist[i]:__is_shown .and. zlist[i]:__buf_dirty
			exit
		endif
		i++
	enddo

	zlist := obj:__ZOrder:get_objlist()
	zlen := obj:__ZOrder:len()

	do while i<=zlen
		wid := zlist[i]
		if wid:__is_shown
			if CTI_IS_CONTAINER(wid) .and. wid:__buffer==nil
				wid:__repaint_container(obj:__buffer)
			else
				if wid:__buffer!=nil
					winbuf_copy(wid:__buffer,,,,,obj:__buffer,wid:top,wid:left)
					wid:__draw_shadow(obj:__buffer)
					wid:__buf_dirty := FALSE
				endif
			endif
		endif
		i++
	enddo

	winbuf_display(obj:__buffer,0,0)

	if obj:__focus_widget!=nil .and. obj:__focus_widget:can_focus()
		obj:__focus_widget:__set_cursor()
	else
		setcursor(SC_NONE)
	endif
return TRUE

/* Add widget to application */
static function cti_application_add(obj,wid,top,left)
	cti_return_if_fail(CTI_IS_WIDGET(wid))

	if ascan(obj:__children,{|w|w:id==wid:id}) > 0; return TRUE; endif
	aadd(obj:__children,wid)

	if top!=nil .or. left!=nil
		wid:set_position(top,left)
	endif

	obj:__ZOrder:add(wid)
	wid:parent_id := obj:id
	wid:signal_connect(HASH_CTI_DRAWN_SIGNAL,{|_wid,_sig,_obj| ;
		iif(_obj:__focus_widget=nil,_obj:set_focus_to_top_window(),nil), ;
		_obj:draw_queue() ;
		},obj)
	wid:signal_connect_after(HASH_CTI_HIDE_SIGNAL,{|_wid,_sig,_obj| ;
		_obj:set_focus_to_top_window(), _obj:draw_queue()},obj)
	wid:signal_connect(HASH_CTI_DESTROY_SIGNAL,{|_wid,_sig,_obj| ;
		_obj:remove(_wid)},obj)

	if (CTI_IS_WINDOW(wid) .or. obj:__focus_widget==nil) .and. wid:can_focus()
		obj:set_focus_child(wid)
	endif

	if !wid:__size_set
		obj:__size_allocate(wid)
	endif
return TRUE

/* Put widget to top of application */
static function cti_application_move_widget_to_top(obj,wid)
	cti_return_if_fail(CTI_IS_APPLICATION(obj))
	cti_return_if_fail(CTI_IS_WIDGET(wid))

	if obj:__ZOrder:move_to_top(wid)
		wid:draw_queue()
	endif
return TRUE

/* Remove widget from application */
static function cti_application_remove(obj,wid)
	local F, old_focus_id
	local ret

//outlog(__FILE__,__LINE__,procname(),wid:name,wid:id)
	cti_return_if_fail(CTI_IS_WIDGET(wid))

	old_focus_id := wid:id

	wid:lost_focus()

	// Remove widget from ZOrder
	ret := obj:__ZOrder:remove(wid)

	if old_focus_id == wid:id
//		obj:set_focus_to_top_window()
//		obj:__set_focus_to_top()
	endif

	// Remove widget from application widget list
	F := ascan(obj:__children,{|x|x:id == wid:id})
	if F>0
		wid:parent_id:=nil
		adel(obj:__children,F)
		asize(obj:__children,len(obj:__children)-1)
	endif

	obj:draw_queue()

return TRUE

static function cti_application_toplevel_set_focus(obj,child)
	local sig
	if child != nil
		cti_return_if_fail(CTI_IS_WIDGET(child))
	endif

	if child != nil .or. obj:__focus_widget!=nil
		sig := cti_signal_new(HASH_CTI_SET_FOCUS_SIGNAL)
		sig:old_focus := obj:__focus_widget
		sig:new_focus := child
		obj:signal_emit(sig)
	endif

	obj:__focus_widget := child

	if obj:__focus_widget!=nil .and. !obj:__frozen
		obj:__set_cursor()
	endif
return TRUE

static function cti_application_set_focus_child_real(obj,wid)
	if !obj:__is_shown; return FALSE; endif
	obj:__focus_widget := wid

	obj:__ZOrder:move_to_top(wid)
return TRUE

/* Set focus to widget "wid" */
static function cti_application_set_focus_child(obj,wid)
	local focused, i, ret

	if !obj:__is_shown; return FALSE; endif

return wid:set_focus()

/* Set focus to widget "wid" */
static function cti_application_set_focus_to_top(obj)
	local i, zlist := obj:__ZOrder:get_objlist()
	local child

	for i:=len(zlist) to 1 step -1
		child := zlist[i]
		if obj:set_focus_child(child)
			return TRUE
		endif
	next
return FALSE

/* If focused widget is windows, return it, else return NIL */
static function cti_application_get_active_window(obj)
	local widget := obj:__ZOrder:get_top()

	if CTI_IS_WINDOW(widget)
		return widget
	else
		return nil
	endif
return TRUE

/* If focused widget is windows, return it`s ID, else return -1 */
static function cti_application_get_active_window_id(obj)
	local widget := obj:__ZOrder:get_top()

	if CTI_IS_WINDOW(widget)
		return widget:id
	else
		return -1
	endif
return TRUE

/* Set focus to widget "wid" */
static function cti_application_set_focus_to_top_window(obj)
	local i, zlist := obj:__ZOrder:get_objlist()
	local child

	for i:=len(zlist) to 1 step -1
		child := zlist[i]
		if CTI_IS_WINDOW(child) .and. child:__is_shown .and. child:set_focus()
			return TRUE
		endif
	next
return FALSE

/* Switch focus to next window in list */
static function cti_application_set_focus_next_window(obj)
	local i, F, NewF:=0

	if obj:__focus_widget == nil
		obj:set_focus_to_top_window()
		return
	endif

	F := ascan(obj:__children,{|x|x:id == obj:__focus_widget:id})
	if F!=0
		/* Scan children forward */
		for i:=F+1 to len(obj:__children)
			if CTI_IS_WINDOW(obj:__children[i]) .and. obj:__children[i]:can_focus()
				NewF := i
				exit
			endif
		next i
		if NewF==0
			/* Wrap scan - from 1 to F-1 */
			for i:=1 to F-1
				if CTI_IS_WINDOW(obj:__children[i]) .and. obj:__children[i]:can_focus()
					NewF := i
					exit
				endif
			next i
		endif
		/* If found, set focus */
		if NewF!=0
			obj:set_focus_child(obj:__children[NewF])
		endif
	endif
return

/* Switch focus to previous window in list */
static function cti_application_set_focus_prev_window(obj)
	local i, F, NewF:=0

	F := ascan(obj:__children,{|x|x:id == obj:__focus_widget:id})
	if F!=0
		/* Scan children backward */
		for i:=F-1 to 1 step -1
			if CTI_IS_WINDOW(obj:__children[i]) .and. obj:__children[i]:can_focus()
				NewF := i
				exit
			endif
		next i
		if NewF==0
			/* Wrap scan - from end to F+1 */
			for i:=len(obj:__children) to F+1 step -1
				if CTI_IS_WINDOW(obj:__children[i]) .and. obj:__children[i]:can_focus()
					NewF := i
					exit
				endif
			next i
		endif
		/* If found, set focus */
		if NewF!=0
			obj:set_focus_child(obj:__children[NewF])
		endif
	endif
return

/* Application destructor - must destroy application frame buffer */
static function cti_application_destroy(obj)
	local i, wid, zlist

	CALL SUPER obj:destroy()

	zlist := aclone(obj:__ZOrder:get_objlist())
	for i:=1 to obj:__ZOrder:len()
		wid := zlist[i]
		if HASH_DESTROY $ wid
			wid:destroy()
			zlist[i] := nil
		endif
	next

	if obj:__buf_app != nil
		winbuf_destroy(obj:__buf_app)
		obj:__buf_app := nil
	endif
return

/* Draw background for application */
static function cti_application_draw_background(obj)
	local s, i

	s := replicate(obj:FillChar,obj:width)
	for i:=0 to obj:height-1
		winbuf_out_at(obj:__buf_app,i,0,s,obj:palette:AppWorkspace)
	next
return

static function cti_application_realize_real(obj)
	local i, child, l

	CALL SUPER obj:realize_real()

	if obj:__focus_widget==nil
		obj:set_focus_to_top_window()
	endif

	l := len(obj:__children)
	for i:=1 to l
		child := obj:__children[i]
		if !child:__size_set
			obj:__size_allocate(child)
		endif
		if !child:__position_set
			obj:__position_allocate(child)
		endif
	next
return TRUE

static function cti_application_show_all(obj)
	local i, zlen, zlist

	CALL SUPER obj:show_all()

	zlist := obj:__ZOrder:get_objlist()
	zlen := obj:__ZOrder:len()

	for i:=1 to zlen
		zlist[i]:show_all()
	next
return TRUE

static function cti_application_hide_all(obj)
	local i, zlen, zlist

	CALL SUPER obj:hide_all()

	zlist := obj:__ZOrder:get_objlist()
	zlen := obj:__ZOrder:len()

	for i:=1 to zlen
		zlist[i]:hide_all()
	next
return TRUE

static function cti_application_handle_event(obj,event)
	local signal, ret := FALSE

	if event:type != CTI_KEYBOARD_EVENT; return .F.; endif

	if obj:__focus_widget!=nil
		if HASH_CTI_EVENT $ obj:__focus_widget:__signals
			signal := cti_signal_new_from_event(event)
			ret := obj:__focus_widget:signal_emit(signal)
		endif

		if ret != TRUE
			ret := obj:__focus_widget:__handle_event(event)
			ret := iif(valtype(ret)=="L",ret,FALSE)
		endif
	endif

	if ret!=TRUE
		return obj:apply_key(event:keycode)
	endif
return ret

static function cti_application_size_allocate(obj,child)
	if !child:__size_set
		child:__set_real_size(child:__uheight,child:__uwidth)
	endif
return TRUE

static function cti_application_position_allocate(obj,child)
	local sig

	if !child:__position_set
		child:__set_real_position(child:__utop,child:__uleft)
	endif
return TRUE

