/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_APPLICATION - main object, contains all windows and other objects. */
/* This class usually have only one object */

#include "cti.ch"
#include "ctiapp.ch"
#include "ctiwindow.ch"
#include "ctiwidget.ch"
#include "cticontrol.ch"
#include "ctimenushell.ch"

#include "setcurs.ch"

#define SUPERCLASS	CTI_WIDGET

function cti_application_new()
	local obj := cti_inherit(cti_widget_new(),"CTI_APPLICATION")

	obj:palette:FillChar	:= chr(0x90)

	obj:top		:= 0
	obj:left	:= 0
	obj:height	:= maxrow()+1
	obj:width	:= maxcol()+1

	obj:__WidgetList:= {}
	obj:__FocusedObj := nil
	obj:__OldFocus	:= nil
	obj:__ZOrder	:= cti_zorder_new()

	obj:__buf_app	:= nil


	obj:__real_draw		:= @cti_application_real_draw()
	obj:__repaint		:= @cti_application_repaint()

	obj:__make_buffer	:= @cti_application_make_buffer()
	obj:__draw_background	:= @cti_application_draw_background()
	obj:__set_focus_to_top	:= @cti_application_set_focus_to_top()
	obj:set_focus_to_top_window	:= @cti_application_set_focus_to_top_window()
	obj:get_active_window	:= @cti_application_get_active_window()
	obj:get_active_window_id:= @cti_application_get_active_window_id()
	obj:put			:= @cti_application_put_widget()
	obj:remove		:= @cti_application_remove_widget()
	obj:move_widget_to_top	:= @cti_application_move_widget_to_top()
	obj:set_focus		:= @cti_application_set_focus()
	obj:focus_next_window	:= @cti_application_set_focus_next_window()
	obj:focus_prev_window	:= @cti_application_set_focus_prev_window()

	obj:destroy		:= @cti_application_destroy()


	obj:__make_buffer()
	obj:__draw_background()
return obj

/********************************************************************/
/* Methods */

/* Draw zero window and objects in it */
static function cti_application_real_draw(obj)
	local zlist, i, win, wid

	winbuf_copy(obj:__buf_app,,,,,obj:__buffer)

	zlist := obj:__ZOrder:get_objlist()

	for i:=1 to len(zlist)
		wid := zlist[i]
		if CTI_IS_WIDGET(wid)
			wid:draw_now(obj:__buffer)
		endif
	next

	if obj:__FocusedObj!=nil
		if CTI_IS_WINDOW(obj:__FocusedObj) .or. CTI_IS_CONTROL(obj:__FocusedObj)
			obj:__FocusedObj:__set_cursor()
		else
			setcursor(SC_NONE)
		endif
	else
		setcursor(SC_NONE)
	endif
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

/* Repaint application */
static function cti_application_repaint(obj)
	winbuf_display(obj:__buffer,0,0)
return TRUE

/* Put widget to application */
static function cti_application_put_widget(obj,wid)
	cti_return_if_fail(CTI_IS_APPLICATION(obj))
	cti_return_if_fail(CTI_IS_WIDGET(wid))

	if ascan(obj:__WidgetList,{|w|w:id==wid:id}) > 0; return TRUE; endif
	aadd(obj:__WidgetList,wid)
	obj:__ZOrder:put(wid)
	wid:parent := obj
	wid:signal_connect(HASH_CTI_DRAW_QUEUE_SIGNAL,{|_wid,_sig,_obj|_obj:draw_queue()},obj)
	wid:signal_connect(HASH_CTI_HIDE_SIGNAL,{|_wid,_sig,_obj|_obj:draw_queue()},obj)
	wid:signal_connect(HASH_CTI_DESTROY_SIGNAL,{|_wid,_sig,_obj|_obj:remove(_wid)},obj)

//	if obj:__FocusedObj==nil; obj:set_focus(wid); endif
	if CTI_IS_WINDOW(wid)
		obj:set_focus(wid)
	endif
/*
	if CTI_IS_MENUSHELL(wid)
		wid:signal_connect(HASH_CTI_ACTIVATE_SIGNAL,{|_wid,_sig,_obj|_obj:set_focus(_obj:__OldFocus)},obj)
		wid:set_size(1,obj:width)
	endif
*/
return TRUE

/* Put widget to top of application */
static function cti_application_move_widget_to_top(obj,wid)
	cti_return_if_fail(CTI_IS_APPLICATION(obj))
	cti_return_if_fail(CTI_IS_WIDGET(wid))

	if obj:__FocusedObj!=nil
		obj:__FocusedObj:draw_queue()
	endif
	obj:__ZOrder:move_to_top(wid)
	wid:draw_queue()
return TRUE

/* Remove widget from application */
static function cti_application_remove_widget(obj,wid)
	local NewFocus, F
	cti_return_if_fail(CTI_IS_APPLICATION(obj))
	cti_return_if_fail(CTI_IS_WIDGET(wid))

	// Remove widget from ZOrder
	obj:__ZOrder:remove(wid)

	if obj:__FocusedObj:id == wid:id
		obj:__set_focus_to_top()
	endif

	// Remove widget from application widget list
	F := ascan(obj:__WidgetList,{|x|x:id == wid:id})
	if F>0
		adel(obj:__WidgetList,F)
		asize(obj:__WidgetList,len(obj:__WidgetList)-1)
	endif

	if CTI_IS_WINDOW(wid)
		// Remove window from ZOrder
		obj:__ZOrder:remove(wid)
		if obj:__FocusedObj:id == wid:id
			// If removed window had focus, move focus to window under it
			obj:__FocusedObj := obj:__ZOrder:get_top()
			if obj:__FocusedObj!=nil
				obj:set_focus(obj:__FocusedObj)
			endif
		endif
		// Remove window from application windows list
		F := ascan(obj:__WidgetList,{|x|x:id == wid:id})
		if F>0
			adel(obj:__WidgetList,F)
			asize(obj:__WidgetList,len(obj:__WidgetList)-1)
		endif
	else
		// Remove widget from application widget list
		F := ascan(obj:__WidgetList,{|x|x:id == wid:id})
		if F>0
			adel(obj:__WidgetList,F)
			asize(obj:__WidgetList,len(obj:__WidgetList)-1)
		endif
	endif
	obj:draw_queue()

return TRUE

/* Set focus to widget "wid" */
static function cti_application_set_focus(obj,wid)
	local i, sig, F

	cti_return_if_fail(CTI_IS_WIDGET(wid))
	F := ascan(obj:__WidgetList,{|x|x:id == wid:id})
	cti_return_if_fail(F!=0)

	if !wid:__is_shown .or. !wid:can_focus(); return FALSE; endif
	if obj:__FocusedObj!=nil .and. obj:__FocusedObj:id==wid:id; return TRUE; endif
/*
		if CTI_IS_WINDOW(wid)
			obj:__ZOrder:move_to_top(wid)
		endif
*/
	obj:__ZOrder:move_to_top(wid)
	obj:__OldFocus := obj:__FocusedObj
	sig:=cti_signal_new(HASH_SET_FOCUS_SIGNAL)
	sig:old_focus := obj:__FocusedObj
	sig:focus := wid
	obj:draw_queue()

	if obj:__FocusedObj!=nil
		obj:__FocusedObj:__is_focused := FALSE
		obj:__FocusedObj:signal_emit(cti_signal_new(HASH_CTI_LOST_FOCUS_SIGNAL))
		obj:__FocusedObj:draw_queue()
	endif

	obj:__FocusedObj:=wid
	obj:__FocusedObj:__is_focused := TRUE
	obj:__FocusedObj:draw_queue()
	obj:__FocusedObj:signal_emit(cti_signal_new(HASH_CTI_SET_FOCUS_SIGNAL))
	obj:signal_emit(sig)
return

/* Set focus to widget "wid" */
static function cti_application_set_focus_to_top(obj)
	local widget := obj:__ZOrder:get_top()

	if widget == nil; return FALSE; endif

	obj:set_focus(widget)
return TRUE

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

	for i:=len(zlist) to 1 step -1
		if CTI_IS_WINDOW(zlist[i])
			obj:set_focus(zlist[i])
			return TRUE
		endif
	next
return FALSE

/* Switch focus to next window in list */
static function cti_application_set_focus_next_window(obj)
	local i, F, NewF:=0

	if obj:__FocusedObj == nil
		obj:set_focus_to_top_window()
		return
	endif

	F := ascan(obj:__WidgetList,{|x|x:id == obj:__FocusedObj:id})
	if F!=0
		/* Scan WidgetList forward */
		for i:=F+1 to len(obj:__WidgetList)
			if CTI_IS_WINDOW(obj:__WidgetList[i]) .and. obj:__WidgetList[i]:can_focus()
				NewF := i
				exit
			endif
		next i
		if NewF==0
			/* Wrap scan - from 1 to F-1 */
			for i:=1 to F-1
				if CTI_IS_WINDOW(obj:__WidgetList[i]) .and. obj:__WidgetList[i]:can_focus()
					NewF := i
					exit
				endif
			next i
		endif
		/* If found, set focus */
		if NewF!=0
			obj:set_focus(obj:__WidgetList[NewF])
		endif
	endif
return

/* Switch focus to previous window in list */
static function cti_application_set_focus_prev_window(obj)
	local i, F, NewF:=0

	F := ascan(obj:__WidgetList,{|x|x:id == obj:__FocusedObj:id})
	if F!=0
		/* Scan WidgetList backward */
		for i:=F-1 to 1 step -1
			if CTI_IS_WINDOW(obj:__WidgetList[i]) .and. obj:__WidgetList[i]:can_focus()
				NewF := i
				exit
			endif
		next i
		if NewF==0
			/* Wrap scan - from end to F+1 */
			for i:=len(obj:__WidgetList) to F+1 step -1
				if CTI_IS_WINDOW(obj:__WidgetList[i]) .and. obj:__WidgetList[i]:can_focus()
					NewF := i
					exit
				endif
			next i
		endif
		/* If found, set focus */
		if NewF!=0
			obj:set_focus(obj:__WidgetList[NewF])
		endif
	endif
return

/* Application destructor - must destroy application frame buffer */
static function cti_application_destroy(obj)
	if obj:__buf_app != nil
		winbuf_destroy(obj:__buf_app)
		obj:__buf_app := nil
	endif
	CALL SUPER obj:destroy()
return

/* Draw background for application */
static function cti_application_draw_background(obj)
	local s, i

	s := replicate(obj:palette:FillChar,obj:width)
	for i:=0 to obj:height-1
		winbuf_out_at(obj:__buf_app,i,0,s,obj:palette:AppWorkspace)
	next
return
