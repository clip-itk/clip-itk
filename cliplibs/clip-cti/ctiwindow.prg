/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_WINDOW - window. */

#include "cti.ch"
#include "ctiwidget.ch"
#include "cticontrol.ch"
#include "ctiwindow.ch"
#include "ctievents.ch"

#include "inkey.ch"
#include "box.ch"
#include "setcurs.ch"

#define	SUPERCLASS	CTI_WIDGET

function cti_window_new(cTitle,nTop,nLeft,nHeight,nWidth)
	local obj := cti_inherit(cti_widget_new(),"CTI_WINDOW")

	obj:Title	:= iif(valtype(cTitle)=="C",cTitle,nil)
	obj:top		:= iif(valtype(nTop)=="N",nTop,obj:top)
	obj:left	:= iif(valtype(nLeft)=="N",nLeft,obj:left)
	obj:height	:= iif(valtype(nHeight)=="N",nHeight,obj:height)
	obj:width	:= iif(valtype(nWidth)=="N",nWidth,obj:width)

	obj:shadow	:= TRUE
	obj:centered	:= FALSE

	obj:__children	:={}
	obj:__FocusedObj	:= nil

	obj:__BorderColor	:= obj:palette:InactiveBorder
	obj:__CaptionColor	:= obj:palette:InactiveCaption
	obj:__WindowColor	:= obj:palette:Window

	obj:__buf_frame	:= nil
	obj:__buf_client:= nil

	obj:__window_focused	:= FALSE

	obj:__real_draw		:= @cti_window_real_draw()
	obj:__handle_event	:= @cti_window_handle_event()
	obj:__set_cursor	:= @cti_window_set_cursor()
	obj:__draw_frame	:= @cti_window_draw_frame()
	obj:__make_buffer	:= @cti_window_make_buffer()

	obj:put			:= @cti_window_put()
	obj:set_focus		:= @cti_window_set_focus()
	obj:set_title		:= @cti_window_set_title()
	obj:focus_next_control	:= @cti_window_focus_next_control()
	obj:focus_prev_control	:= @cti_window_focus_prev_control()
	obj:center		:= @cti_window_center()

	obj:realize_real	:= @cti_window_realize_real()

	obj:destroy		:= @cti_window_destroy()
return obj

/********************************************************************/
/* Methods */

/* Puts control "child" into window in coordinates (top,left) */
static function cti_window_put(obj,child,top,left)
	aadd(obj:__children,child)
	child:parent := obj

//	if top!=nil; child:top:=top; endif
//	if left!=nil; child:left:=left; endif

	if top!=nil .or. left!=nil
		child:set_position(top,left)
	endif

	if obj:__FocusedObj==nil
		obj:set_focus(child)
	endif
	obj:draw_queue()
	child:signal_connect(HASH_CTI_DRAW_QUEUE_SIGNAL,{|_cnt,_sig,_obj|_obj:draw_queue()},obj)
//	obj:signal_connect("CTI_HIDE_SIGNAL",obj,{|_cnt,_sig,_obj|_obj:focus_next_control(),_obj:draw_queue()})
//	obj:signal_connect("CTI_DESTROY_SIGNAL",obj,{|_win,_sig,_obj|_obj:remove_control(_cnt)})
return

static function cti_window_handle_event(obj,event)
	local signal, ret

	if event:type != CTI_KEYBOARD_EVENT; return .F.; endif

	switch (event:keycode)
		case K_TAB
		obj:focus_next_control()

		case K_SH_TAB
		obj:focus_prev_control()

		otherwise
		if obj:__FocusedObj!=nil
			if HASH_CTI_EVENT $ obj:__FocusedObj:__signals
				signal := cti_signal_new(HASH_CTI_EVENT)
				signal:event := event
				ret := obj:__FocusedObj:signal_emit(signal)
			endif

			if ret != TRUE
				ret := obj:__FocusedObj:__handle_event(event)
                        	ret := iif(valtype(ret)=="L",ret,TRUE)
			endif
		endif
	end
return TRUE

static function cti_window_set_focus(obj,child)
	local oldfocus := obj:__FocusedObj
	local sig, F

	cti_return_if_fail(CTI_IS_WIDGET(child))
	F := ascan(obj:__children,{|x|x:id == child:id})
	cti_return_if_fail(F!=0)

	if !child:can_focus(); return; endif
	if obj:__FocusedObj!=nil .and. obj:__FocusedObj:id==child:id; return; endif

	obj:__FocusedObj := child
	if oldfocus!=nil .and. CTI_IS_CONTROL(oldfocus)
		oldfocus:__is_focused := FALSE
		oldfocus:__kill_focus()
		oldfocus:draw_queue()
		oldfocus:signal_emit(cti_signal_new(HASH_CTI_LOST_FOCUS_SIGNAL))
	endif
	if child!=nil .and. CTI_IS_CONTROL(obj:__FocusedObj)
		obj:__FocusedObj:__is_focused := TRUE
		obj:__FocusedObj:__set_focus()
		obj:__FocusedObj:draw_queue()
		obj:__FocusedObj:signal_emit(cti_signal_new(HASH_CTI_SET_FOCUS_SIGNAL))
	endif
	sig := cti_signal_new(HASH_CTI_SET_FOCUS_SIGNAL)
	sig:old_focus := oldfocus
	sig:new_focus := obj:__FocusedObj
	obj:signal_emit(sig)
return TRUE

static function cti_window_set_cursor(obj)
	if obj:__FocusedObj!=nil
        	obj:__FocusedObj:__set_cursor()
	else
		setcursor(SC_NONE)
	endif
return TRUE

static function cti_window_set_title(obj,cTitle)
	cti_return_if_fail(valtype(cTitle)=="C")
	obj:title := cTitle
	obj:draw_queue()
return TRUE

static function cti_window_focus_next_control(obj)
	local i, F, oldfocus, newfocus := nil

	F := ascan(obj:__children,{|x|x:id == obj:__FocusedObj:id})
	if F!=0
		oldfocus := obj:__FocusedObj
		for i:=F+1 to len(obj:__children)
//child := obj:__children[i]
//outlog(__FILE__,__LINE__,procname(),child:classname,"__is_shown"$child,child:__is_shown,obj:__children[i]:__is_shown)
			if obj:__children[i]:can_focus() .and. obj:__children[i]:__is_shown
//			if child:can_focus() .and. child:__is_shown
				newfocus := obj:__children[i]
				exit
			endif

		next
		if newfocus == nil
			for i:=1 to F-1
				if obj:__children[i]:can_focus() .and. obj:__children[i]:__is_shown
					newfocus := obj:__children[i]
					exit
				endif
			next
		endif
		if newfocus != nil .and. oldfocus:id != newfocus:id
			obj:set_focus(newfocus)
		endif
	endif
return

static function cti_window_focus_prev_control(obj)
	local i, F, oldfocus, newfocus

	F := ascan(obj:__children,{|x|x:id == obj:__FocusedObj:id})
	if F!=0
		oldfocus := obj:__FocusedObj
		for i:=F-1 to 1 step -1
			if obj:__children[i]:can_focus() .and. obj:__children[i]:__is_shown
				newfocus := obj:__children[i]
				exit
			endif
		next
		if newfocus == nil
			for i:=len(obj:__children) to F+1 step -1
				if obj:__children[i]:can_focus() .and. obj:__children[i]:__is_shown
					newfocus := obj:__children[i]
					exit
				endif
			next
		endif
		if newfocus != nil .and. oldfocus:id != newfocus:id
			obj:set_focus(newfocus)
		endif
	endif
return

static function cti_window_realize_real(obj)
	local h,w

	if obj:height==nil .or. obj:width==nil
		h := iif(obj:height==nil, 2, obj:height)
		if obj:width==nil
			w := iif(obj:Title!=nil, len(obj:Title)+3, obj:width)
		endif
		obj:set_size(h,w)
	endif

	if obj:centered
		obj:center()
	endif

	CALL SUPER obj:realize_real()
return

static function cti_window_real_draw(obj)
	local i, str, child
	local BorderColor, CaptionColor

	obj:__BorderColor:=obj:palette:InactiveBorder
	obj:__CaptionColor:=obj:palette:InactiveCaption
	if obj:__is_focused
		obj:__BorderColor:=obj:palette:ActiveBorder
		obj:__CaptionColor:=obj:palette:ActiveCaption
	endif
//	setcursor(SC_NONE)

	if obj:__window_focused != obj:__is_focused
		obj:__draw_frame()
		obj:__window_focused := obj:__is_focused
	endif

	winbuf_copy(obj:__buf_frame,,,,,obj:__buffer)
	winbuf_copy(obj:__buf_client,,,,,obj:__buffer,1,1)

	for i:=1 to len(obj:__children)
		child:=obj:__children[i]
		if child!=nil
			child:draw_now(obj:__buffer)
		endif
	next

	if obj:__FocusedObj!=nil .and. CTI_IS_CONTROL(obj:__FocusedObj)
//		obj:__FocusedObj:__set_cursor()
	endif
return

/* Center window relatively it`s parent */
static function cti_window_center(obj)
	local left,top
	if obj:parent != nil
		left := round((cti_cnum(obj:parent:width)-cti_cnum(obj:width))/2,0)
		top := round((cti_cnum(obj:parent:height)-cti_cnum(obj:height))/2,0)
		obj:set_position(top,left)
	endif
	obj:centered := TRUE
return TRUE

/* Draw window`s background and it`s frame and title */
static function cti_window_draw_frame(obj)
	local i, s1, s2, ledg, redg, title
	local s

	s1 := substr(B_DOUBLE,1,1)+replicate(substr(B_DOUBLE,2,1),obj:width-2)+substr(B_DOUBLE,3,1)
	s2 := substr(B_DOUBLE,7,1)+replicate(substr(B_DOUBLE,6,1),obj:width-2)+substr(B_DOUBLE,5,1)

	/* Top line */
	winbuf_out_at(obj:__buf_frame,0,0,s1,obj:__BorderColor)

	/* Window title */
	if obj:title!=nil
		title := obj:title
		if len(title) > obj:width-2
			title := left(title,obj:width-5)+"..."
		endif
		winbuf_out_at(obj:__buf_frame,0,1+(obj:width-len(title))/2,title,obj:__CaptionColor)
	endif

	/* Left and right edges */
	ledg := substr(B_DOUBLE,4,1)
	redg := substr(B_DOUBLE,8,1)
	for i:=1 to obj:height-2
		winbuf_out_at(obj:__buf_frame,i,0,ledg,obj:__BorderColor)
		winbuf_out_at(obj:__buf_frame,i,obj:width-1,redg,obj:__BorderColor)
	next

	/* Bottom line */
	winbuf_out_at(obj:__buf_frame,obj:height-1,0,s2,obj:__BorderColor)

	/* Client area */
	s := space(obj:width-2)
	for i:=0 to obj:height-3
		winbuf_out_at(obj:__buf_client,i,0,s,obj:__WindowColor)
	next
return TRUE

/* Creates additional buffers for object Window */
static function cti_window_make_buffer(obj)
	CALL SUPER obj:__make_buffer()

	if obj:__buf_frame != nil
		winbuf_destroy(obj:__buf_frame)
	endif
	obj:__buf_frame := winbuf_create(cti_cnum(obj:height),cti_cnum(obj:width))

	if obj:__buf_client != nil
		winbuf_destroy(obj:__buf_client)
	endif
	obj:__buf_client := winbuf_create(cti_cnum(obj:height)-2,cti_cnum(obj:width)-2)

	obj:__draw_frame()
return TRUE

/* Window destructor - must destroy window frame buffer and client area */
static function cti_window_destroy(obj)
	if obj:__buf_frame != nil
		winbuf_destroy(obj:__buf_frame)
		obj:__buf_frame := nil
	endif
	if obj:__buf_client != nil
		winbuf_destroy(obj:__buf_client)
		obj:__buf_client := nil
	endif
	CALL SUPER obj:destroy()
return

