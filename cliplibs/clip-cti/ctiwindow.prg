/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_WINDOW - window. */

#include "cti.ch"

#include "inkey.ch"
#include "box.ch"
#include "setcurs.ch"

#define	SUPERCLASS	CTI_BIN

function cti_window_new(cTitle,nTop,nLeft,nHeight,nWidth)
	local obj := cti_inherit(cti_bin_new(),"CTI_WINDOW")

	obj:FillChar	:= " "

	obj:Title	:= iif(valtype(cTitle)=="C",cTitle,nil)
	obj:Footer	:= ""
	obj:__style	:= B_DOUBLE
//	obj:top		:= iif(valtype(nTop)=="N",nTop,obj:top)
//	obj:left	:= iif(valtype(nLeft)=="N",nLeft,obj:left)
//	obj:height	:= iif(valtype(nHeight)=="N",nHeight,obj:height)
//	obj:width	:= iif(valtype(nWidth)=="N",nWidth,obj:width)

	obj:shadow	:= TRUE
	obj:centered	:= FALSE

	obj:wrap_tab		:= TRUE
	obj:wrap_vertical	:= TRUE
	obj:wrap_horizontal	:= TRUE

	obj:__is_toplevel	:= TRUE

	obj:frozen		:= FALSE

	obj:__BorderColor	:= obj:palette:InactiveBorder
	obj:__CaptionColor	:= obj:palette:InactiveCaption
	obj:__FooterColor	:= obj:palette:WindowFooter

	obj:__buf_frame_top	:= nil
	obj:__buf_frame_bottom	:= nil
	obj:__buf_frame_left	:= nil
	obj:__buf_frame_right	:= nil

	obj:__focus_widget	:= nil

	obj:__window_focused	:= FALSE

	obj:__real_draw		:= @cti_window_real_draw()
	obj:__handle_event	:= @cti_window_handle_event()
	obj:__set_cursor	:= @cti_window_set_cursor()
	obj:__draw_frame	:= @cti_window_draw_frame()
	obj:__draw_background	:= @cti_window_draw_background()
	obj:__make_buffer	:= @cti_window_make_buffer()
	obj:__toplevel_set_focus:= @cti_window_toplevel_set_focus()
	obj:__size_allocate	:= @cti_window_size_allocate()
	obj:__position_allocate	:= @cti_window_position_allocate()
	obj:__set_default_keys	:= @cti_window_set_default_keys()

	obj:repaint_real	:= @cti_window_repaint_real()
	obj:can_focus		:= {|_obj|_obj:__is_shown .and. _obj:__is_enabled}
//	obj:can_focus		:= {|_obj|_obj:__is_enabled}
//	obj:put			:= @cti_window_add()
	obj:set_title		:= @cti_window_set_title()
	obj:set_footer		:= @cti_window_set_footer()
	obj:set_style		:= @cti_window_set_style()
	obj:set_size		:= @cti_window_set_size()
	obj:set_position	:= @cti_window_set_position()
//	obj:set_focus_real	:= @cti_window_set_focus_real()
//	obj:lost_focus_real	:= @cti_window_lost_focus_real()
	obj:focus_move		:= @cti_window_focus_move()
	obj:center		:= @cti_window_center()
	obj:freeze		:= {|_obj|_obj:freeze := TRUE}
	obj:thaw		:= {|_obj|_obj:freeze := FALSE, _obj:draw_queue()}

	obj:realize_real	:= @cti_window_realize_real()

	obj:destroy		:= @cti_window_destroy()

	obj:__set_default_keys()

	if valtype(nHeight)=="N" .or. valtype(nWidth)=="N"
		obj:set_size(nHeight,nWidth)
	endif
	if valtype(nTop)=="N" .or. valtype(nLeft)=="N"
		obj:set_position(nTop,nLeft)
	endif
return obj

/********************************************************************/
/* Methods */

static function cti_window_handle_event(obj,event)
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

static function cti_window_lost_focus_real(obj)
	if obj:parent_id == nil
		return FALSE
	endif

	cti_get_object_by_id(obj:parent_id):set_focus_child(nil)
return TRUE

static function cti_window_set_focus_real(obj)
	if obj:parent_id == nil
		return FALSE
	endif

	obj:parent():set_focus_child(obj)
return TRUE

static function cti_window_toplevel_set_focus(obj,child)
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

static function cti_window_focus_move(obj,nDirection,wrap_focus)
	local focus := obj:__focus_widget
	local widget

	if focus==nil
		if obj:__child != nil
			obj:__child:set_focus()
			if CTI_IS_CONTAINER(obj:__child)
				obj:__child:focus_move(nDirection,wrap_focus)
			endif
		endif
	else
		widget := cti_get_object_by_id(focus:parent_id)
		do while widget!=nil .and. widget:id!=obj:id
			if CTI_IS_CONTAINER(widget) .and. widget:focus_move(nDirection,wrap_focus)
				return TRUE
			endif
			widget := cti_get_object_by_id(widget:parent_id)
		enddo

		/* if focus was not moved, wrap focus motion */
		if obj:__focus_widget != nil
			obj:__focus_widget:lost_focus()
		endif

		if obj:__focus_widget == nil
			obj:focus_move(nDirection,TRUE)
		endif
	endif
return FALSE

static function cti_window_set_cursor(obj)
	if !obj:__frozen .and. obj:__focus_widget!=nil .and. HASH___SET_CURSOR $ obj:__focus_widget
		obj:__focus_widget:__set_cursor()
	else
		setcursor(SC_NONE)
	endif
return TRUE

static function cti_window_set_title(obj,cTitle)
	cti_return_if_fail(valtype(cTitle)=="C")
	obj:Title := cTitle
	obj:draw_queue()
return TRUE

static function cti_window_set_footer(obj,cFooter)
	cti_return_if_fail(valtype(cFooter)=="C")
	obj:Footer := cFooter
	obj:draw_queue()
return TRUE

static function cti_window_set_style(obj,cStyle)
	cti_return_if_fail(valtype(cStyle)=="C")
	obj:__Style := cStyle
	obj:draw_queue()
return TRUE

static function cti_window_realize_real(obj)
	local h,w, widget, parent

//	if obj:__uheight==nil .or. obj:__uwidth==nil
	if !obj:__usize_set
		h := iif(obj:__uheight==nil, 2, obj:__uheight)
		if obj:__uwidth==nil
			w := iif(obj:Title!=nil, len(obj:Title)+3, 3)
		endif
		parent := cti_get_object_by_id(obj:parent_id)
		if parent != nil .and. parent:__size_set
			w := min(w,parent:width)
		endif
//		obj:height := h
//		obj:width := w
		obj:set_size(h,w)
		obj:__usize_set := FALSE
	endif

	if obj:centered
		obj:center()
	endif

	if obj:__focus_widget==nil
		obj:focus_move()
	endif

	CALL SUPER obj:realize_real()
return

static function cti_window_real_draw(obj)
	local i, str, child
	local BorderColor, CaptionColor

	if obj:frozen
		return FALSE
	endif

	CALL SUPER obj:__real_draw()

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

	if obj:__buf_frame_top!=nil
		winbuf_copy(obj:__buf_frame_top,,,,,obj:__buffer,0,0)
	endif
	if obj:__buf_frame_left!=nil
		winbuf_copy(obj:__buf_frame_left,,,,,obj:__buffer,1,0)
	endif
	if obj:__buf_frame_right!=nil
		winbuf_copy(obj:__buf_frame_right,,,,,obj:__buffer,1,obj:width-1)
	endif
	if obj:__buf_frame_bottom!=nil
		winbuf_copy(obj:__buf_frame_bottom,,,,,obj:__buffer,obj:height-1,0)
	endif
//	winbuf_copy(obj:__buf_client,,,,,obj:__buffer,1,1)

//	obj:for_each_recursive({|_obj|_obj:__buf_dirty:=TRUE})

/*
	for i:=1 to len(obj:__children)
		child:=obj:__children[i]
		if child!=nil
			child:draw_now(obj:__buffer)
		endif
	next
*/
//	if obj:__focus_child!=nil .and. CTI_IS_CONTROL(obj:__focus_child)
//		obj:__FocusedObj:__set_cursor()
//	endif
return

static function cti_window_repaint_real(obj)
	CALL SUPER obj:repaint_real()

	obj:__repaint_container(obj:__buffer)
	obj:__set_cursor()
return TRUE

/* Center window relatively it`s parent */
static function cti_window_center(obj)
	local left,top
	local parent := cti_get_object_by_id(obj:parent_id)

	if parent != nil
		left := round((cti_cnum(parent:width)-cti_cnum(obj:width))/2,0)
		top := round((cti_cnum(parent:height)-cti_cnum(obj:height))/2,0)
		obj:set_position(top,left)
	endif
	obj:centered := TRUE
return TRUE

static function cti_window_set_size(obj,nHeight,nWidth)
	CALL SUPER obj:set_size(nHeight,nWidth)
	if obj:centered
		obj:center()
	endif
return TRUE

static function cti_window_set_position(obj,nTop,nLeft)
	CALL SUPER obj:set_position(nTop,nLeft)
	obj:centered := FALSE
return TRUE

/* Draw window`s background and it`s frame and title */
static function cti_window_draw_frame(obj)
	local i, s1, s2, ledg, redg, title, footer
	local s, w := cti_cnum(obj:width)

	s1 := substr(obj:__style,1,1)+replicate(substr(obj:__style,2,1),w-2)+substr(obj:__style,3,1)
	s2 := substr(obj:__style,7,1)+replicate(substr(obj:__style,6,1),w-2)+substr(obj:__style,5,1)

	/* Top line */
	winbuf_out_at(obj:__buf_frame_top,0,0,s1,obj:__BorderColor)

	/* Window title */
	if !empty(obj:Title)
		title := obj:title
		if len(title) > w-2
			title := left(title,w-5)+"..."
		endif
		winbuf_out_at(obj:__buf_frame_top,0,(w-len(title))/2,title,obj:__CaptionColor)
	endif

	/* Bottom line */
	winbuf_out_at(obj:__buf_frame_bottom,0,0,s2,obj:__BorderColor)

	/* Window footer */
	if !empty(obj:Footer)
		footer := obj:Footer
		if len(footer) > w-2
			footer := left(footer,w-5)+"..."
		endif
		winbuf_out_at(obj:__buf_frame_bottom,0,(w-len(footer))/2,footer,obj:__FooterColor)
	endif

	/* Left and right edges */
	ledg := substr(obj:__style,4,1)
	redg := substr(obj:__style,8,1)
	for i:=0 to obj:height-3
		winbuf_out_at(obj:__buf_frame_left,i,0,ledg,obj:__BorderColor)
		winbuf_out_at(obj:__buf_frame_right,i,0,redg,obj:__BorderColor)
	next

/*
	winbuf_copy(obj:__buf_frame_top,,,,,obj:__buffer,0,0)
	winbuf_copy(obj:__buf_frame_left,,,,,obj:__buffer,1,0)
	winbuf_copy(obj:__buf_frame_right,,,,,obj:__buffer,1,obj:width-1)
	winbuf_copy(obj:__buf_frame_bottom,,,,,obj:__buffer,obj:height-1,0)
*/
return TRUE

static function cti_window_draw_background(obj)
	local s, i

	/* Client area */
	s := replicate(obj:FillChar,obj:width-2)
	for i:=1 to obj:height-2
		winbuf_out_at(obj:__buffer,i,1,s,obj:palette:Window)
	next

	obj:for_each_recursive({|_obj|_obj:__buf_dirty:=TRUE})
return TRUE

/* Creates additional buffers for object Window */
static function cti_window_make_buffer(obj)
	local w := cti_cnum(obj:width)
	local h := cti_cnum(obj:height)

	CALL SUPER obj:__make_buffer()

	if obj:__buffer != nil
		winbuf_destroy(obj:__buffer); obj:__buffer := nil
	endif
	obj:__buffer := winbuf_create(cti_cnum(obj:height),cti_cnum(obj:width))

	if w > 2
		if obj:__buf_frame_top != nil
			winbuf_destroy(obj:__buf_frame_top); obj:__buf_frame_top := nil
		endif
		obj:__buf_frame_top := winbuf_create(1,w)

		if obj:__buf_frame_bottom != nil
			winbuf_destroy(obj:__buf_frame_bottom); obj:__buf_frame_bottom := nil
		endif
		obj:__buf_frame_bottom := winbuf_create(1,w)
	endif

	if h > 2
		if obj:__buf_frame_left != nil
			winbuf_destroy(obj:__buf_frame_left); obj:__buf_frame_left := nil
		endif
		obj:__buf_frame_left := winbuf_create(h-2,1)

		if obj:__buf_frame_right != nil
			winbuf_destroy(obj:__buf_frame_right); obj:__buf_frame_right := nil
		endif
		obj:__buf_frame_right := winbuf_create(h-2,1)
	endif
/*
	if obj:__buf_client != nil
		winbuf_destroy(obj:__buf_client)
	endif
	obj:__buf_client := winbuf_create(cti_cnum(obj:height)-2,cti_cnum(obj:width)-2)
*/

	obj:__draw_frame()
	obj:__draw_background()
return TRUE

static function cti_window_set_default_keys(obj)
	obj:set_key(K_TAB, 	{|_obj|_obj:focus_move(CTI_DIR_TAB_FORWARD)})
	obj:set_key(K_SH_TAB, 	{|_obj|_obj:focus_move(CTI_DIR_TAB_BACKWARD)})
	obj:set_key(K_UP, 	{|_obj|_obj:focus_move(CTI_DIR_UP)})
	obj:set_key(K_DOWN, 	{|_obj|_obj:focus_move(CTI_DIR_DOWN)})
	obj:set_key(K_LEFT, 	{|_obj|_obj:focus_move(CTI_DIR_LEFT)})
	obj:set_key(K_RIGHT, 	{|_obj|_obj:focus_move(CTI_DIR_RIGHT)})
return TRUE

static function cti_window_size_allocate(obj,child)
//	if obj:__is_realized .and. !child:__size_set
	if !child:__size_set
		child:__set_real_size(cti_cnum(obj:height) - 2,cti_cnum(obj:width) - 2)
//		child:height := cti_cnum(obj:height) - 2
//		child:__size_set := TRUE
	endif

	CALL SUPER obj:__size_allocate(child)
return TRUE

static function cti_window_position_allocate(obj,child)
//	if obj:__is_realized .and. !child:__position_set
	if !child:__position_set
		child:__set_real_position(1,1)
//		child:left := 1
//		child:__position_set := TRUE
	endif

	CALL SUPER obj:__position_allocate(child)
return TRUE

/* Window destructor - must destroy window frame buffer and client area */
static function cti_window_destroy(obj)

	CALL SUPER obj:destroy()

	if obj:__buf_frame_top != nil
		winbuf_destroy(obj:__buf_frame_top); obj:__buf_frame_top := nil
	endif
	if obj:__buf_frame_bottom != nil
		winbuf_destroy(obj:__buf_frame_bottom); obj:__buf_frame_bottom := nil
	endif
	if obj:__buf_frame_left != nil
		winbuf_destroy(obj:__buf_frame_left); obj:__buf_frame_left := nil
	endif
	if obj:__buf_frame_right != nil
		winbuf_destroy(obj:__buf_frame_right); obj:__buf_frame_right := nil
	endif
return

