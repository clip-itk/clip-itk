/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_CONTAINER - abstract class for deriving other classes of widgets, who
 * may contain children widget */

#include "cti.ch"

#include "setcurs.ch"

#define	SUPERCLASS	CTI_WIDGET

#define VERT_INDEX(top,left)	(cti_cnum(left)*1000+cti_cnum(top))
#define HORIZ_INDEX(top,left)	(cti_cnum(left)*1000+cti_cnum(top))

function cti_container_new()
	local obj := cti_inherit(cti_widget_new(),"CTI_CONTAINER")

	obj:__children		:= map()
	obj:__focus_child	:= nil

	obj:__last_tab_index	:= 0

	obj:__tab_seq		:= TSortedArrayNew()
	obj:__vert_seq		:= TSortedArrayNew()
	obj:__horiz_seq		:= TSortedArrayNew()

	obj:__set_cursor	:= @cti_container_set_cursor()
	obj:__reposition_child	:= @cti_container_reposition_child()
	obj:__make_buffer	:= {||TRUE}
//	obj:__real_draw		:= @cti_container_real_draw()
	obj:__repaint_container	:= @cti_container_repaint_container()
	obj:__size_allocate	:= @cti_container_size_allocate()
	obj:__position_allocate	:= @cti_container_position_allocate()

	obj:realize_real	:= @cti_container_realize_real()
	obj:add			:= @cti_container_add()
	obj:remove		:= @cti_container_remove()
	obj:for_each		:= @cti_container_for_each()
	obj:for_each_recursive	:= @cti_container_for_each_recursive()
	obj:for_all		:= obj:for_each
	obj:for_all_recursive	:= obj:for_each_recursive
	obj:children		:= {|_obj|_obj:__children}
	obj:focus_move		:= @cti_container_focus_move()
	obj:__set_focus_child	:= @cti_container_set_focus_child_real()

	obj:destroy		:= @cti_container_destroy()
return obj

/********************************************************************/
/* Methods */

/* Adds widget */
static function cti_container_add(obj,child)
	//aadd(obj:__children,child)
	obj:__children[child:id] := child
	child:parent_id := obj:id

//	if top!=nil; child:top:=top; endif
//	if left!=nil; child:left:=left; endif

//	if top!=nil .or. left!=nil
//		child:set_position(top,left)
//	endif

//	if obj:__focus_child==nil
//		obj:set_focus(child)
//	endif

	obj:__last_tab_index ++
	child:__tab_index := obj:__last_tab_index

	child:__size_set := FALSE
	child:__position_set := FALSE
//	if !child:__size_set
	obj:__size_allocate(child)

	obj:__position_allocate(child)
//	endif

	obj:__reposition_child(child)

	obj:repaint_queue()
	child:signal_connect(HASH_CTI_SET_POSITION_SIGNAL, ;
		{|_child,_sig,_obj|_obj:__reposition_child(_child,_sig)},obj)
	child:signal_connect(HASH_CTI_DRAWN_SIGNAL,{|_cnt,_sig,_obj|_obj:repaint_queue()},obj)
//	child:signal_connect(HASH_CTI_DRAWN_SIGNAL,{|_cnt,_sig,_obj|_obj:draw_queue()},obj)
//	obj:signal_connect("CTI_HIDE_SIGNAL",obj,{|_cnt,_sig,_obj|_obj:focus_next_control(),_obj:draw_queue()})
	child:signal_connect(HASH_CTI_DESTROY_SIGNAL,{|_wid,_sig,_obj|,_obj:remove(_wid)},obj)
return

/* Rebuild position indexes */
static function cti_container_reposition_child(obj,child,sig)
	local pos, index

/*
	/* Rebuild vertical position index */
	if sig!=nil
		index := VERT_INDEX(sig:old_top,sig:old_left)
		pos := obj:__vert_seq:hardSeek(index)
		if obj:__vert_seq:found
			obj:__vert_seq:delItem(pos)
		endif
	endif
	index := VERT_INDEX(child:top,child:left)
	pos := obj:__vert_seq:hardSeek(index)
	if obj:__vert_seq:found
		obj:__vert_seq:delItem(pos)
	endif
	obj:__vert_seq:add(index,child)

	/* Rebuild horizontal position index */
	index := HORIZ_INDEX(child:left,child:top)
	pos := obj:__horiz_seq:hardSeek(index)
	if obj:__horiz_seq:found
		obj:__horiz_seq:delItem(pos)
	endif
	obj:__horiz_seq:add(index,child)
*/

	/* Rebuild tab-sequence index */
	pos := obj:__tab_seq:hardSeek(child:__tab_index)
	if obj:__tab_seq:found
		obj:__tab_seq:delItem(pos)
	endif
	obj:__tab_seq:add(child:__tab_index,child)
return TRUE

static function cti_container_remove(obj,wid)
	local NewFocus, F
	cti_return_if_fail(CTI_IS_WIDGET(wid))

	// Remove widget from children list
	if wid:id $ obj:__children
		wid:parent_id:=nil
		obj:__children[wid:id]:=nil
		adel(obj:__children,wid:id)
	endif

	obj:__horiz_seq:del(wid:left)
	obj:__vert_seq:del(wid:top)
	obj:__tab_seq:del(wid:__tab_index)

	obj:draw_queue()
return TRUE

static function cti_container_for_each(obj,bCode)
	local wid

	cti_return_if_fail(valtype(bCode)=="B")

	for wid in obj:__children
		eval(bCode, wid)
	next
return

static function cti_container_for_each_recursive(obj,bCode)
	local wid

	cti_return_if_fail(valtype(bCode)=="B")

	for wid in obj:__children
		if CTI_IS_CONTAINER(wid)
			wid:for_each_recursive(bCode)
		endif
		eval(bCode, wid)
	next
return

static function cti_container_focus_move(obj,nDirection,wrap_focus)
	local i, pos, focus, new_focus
	local sequence, index, forward

	if !obj:__is_shown; return FALSE; endif
	if wrap_focus==nil; wrap_focus:=FALSE; endif

	if nDirection==nil; nDirection := CTI_DIR_TAB_FORWARD; endif
	cti_return_if_fail(valtype(nDirection)=="N")

	switch (nDirection)
		case CTI_DIR_UP
			nDirection := CTI_DIR_TAB_BACKWARD
		case CTI_DIR_DOWN
			nDirection := CTI_DIR_TAB_FORWARD
		case CTI_DIR_LEFT
			nDirection := CTI_DIR_TAB_BACKWARD
		case CTI_DIR_RIGHT
			nDirection := CTI_DIR_TAB_FORWARD
	end

	focus := obj:__focus_child
	switch (nDirection)
		case CTI_DIR_TAB_FORWARD, CTI_DIR_TAB_BACKWARD
		sequence := obj:__tab_seq
		index := iif(focus!=nil,focus:__tab_index,nil)
		forward := nDirection==CTI_DIR_TAB_FORWARD
//		wrap := obj:wrap_tab

		case CTI_DIR_UP, CTI_DIR_DOWN
		sequence := obj:__vert_seq
		forward := nDirection==CTI_DIR_DOWN
		index := iif(focus!=nil,VERT_INDEX(focus:top+iif(forward,1,-1),focus:left),nil)
//		wrap := obj:wrap_vertical

		case CTI_DIR_LEFT, CTI_DIR_RIGHT
		sequence := obj:__horiz_seq
		index := iif(focus!=nil,focus:left,nil)
		forward := nDirection==CTI_DIR_RIGHT
//		wrap := obj:wrap_horizontal
	end

	if index==nil
		pos := iif(forward,1,sequence:len())
	else
		pos := sequence:softSeek(index)
		if sequence:found
			if forward
				pos ++
			else
				pos --
			endif
		endif
	endif

	if forward
		i := pos
		new_focus := sequence:getData(i)
		do while new_focus!=nil
			if new_focus:can_focus()
//				obj:set_focus_child(new_focus)
				new_focus:set_focus()
				return TRUE
			endif
			i ++
			new_focus := sequence:getData(i)
		enddo

		if wrap_focus
			i := 1
			new_focus := sequence:getData(i)
			do while new_focus!=nil .and. i<pos
				if new_focus:can_focus()
					new_focus:set_focus()
					return TRUE
				endif
				i ++
				new_focus := sequence:getData(i)
			enddo
		endif
	else
		i := pos
		new_focus := sequence:getData(i)
		do while i>0
			if new_focus!=nil .and. new_focus:can_focus()
				new_focus:set_focus()
				return TRUE
			endif
			i --
			new_focus := sequence:getData(i)
		enddo

		if wrap_focus
			i := sequence:len()
			new_focus := sequence:getData(i)
			do while new_focus!=nil .and. i>pos
				if new_focus:can_focus()
					new_focus:set_focus()
					return TRUE
				endif
				i --
				new_focus := sequence:getData(i)
			enddo
		endif
	endif
return FALSE

static function cti_container_set_focus_child_real(obj,child)
	if !obj:__is_shown; return FALSE; endif

	obj:__focus_child := child
return TRUE

static function cti_container_set_focus_child(obj,child)
	if !obj:__is_shown; return FALSE; endif

	child:set_focus()
return TRUE

static function cti_container_set_cursor(obj)
	if obj:__focus_child!=nil
		obj:__focus_child:__set_cursor()
	else
		setcursor(SC_NONE)
	endif
return TRUE

static function cti_container_repaint_container(obj,buf)
	local child

	if buf==nil; return FALSE; endif
	if !obj:__is_shown; return FALSE; endif

	obj:__calc_abs_coords()

	for child in obj:__children
		if CTI_IS_CONTAINER(child) .and. child:__buffer==nil
////////
////////  Shift coordinates for containers, inserted into containers
////////
			child:__repaint_container(buf)
		else
			if child:__is_realized .and. child:__buffer!=nil .and. child:__buf_dirty
				winbuf_copy(child:__buffer,,,,,buf,obj:top+child:top,obj:left+child:left)
				child:__draw_shadow(buf)
				child:__buf_dirty := FALSE
			endif
		endif
	next
return TRUE

static function cti_container_realize_real(obj)
	local child

	CALL SUPER obj:realize_real()

	for child in obj:__children
		if !child:__size_set
			obj:__size_allocate(child)
		endif
		if !child:__position_set
			obj:__position_allocate(child)
		endif
	next
return TRUE

static function cti_container_size_allocate(obj,child)
	cti_return_if_fail(CTI_IS_WIDGET(child))

	if !child:__size_set
		child:__set_real_size()
	endif
return TRUE

static function cti_container_position_allocate(obj,child)
	cti_return_if_fail(CTI_IS_WIDGET(child))

	if !child:__position_set
		child:__set_real_position()
	endif
return TRUE

/* Container destructor - must destroy all children */
static function cti_container_destroy(obj)
	local wid, children:={}, i

	CALL SUPER obj:destroy()

	for wid in obj:__children
		if HASH_DESTROY $ wid
			aadd(children,wid)
		endif
	next

	for i:=1 to len(children)
		children[i]:destroy()
		children[i] := nil
	next
return

