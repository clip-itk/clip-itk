/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_BIN - a container with just one child. */

/*  The  GtkBin  widget  is a container with just one child. It is not
very useful itself, but it is useful for deriving subclasses, since it
provides common code needed for handling a single child widget. */

#include "cti.ch"

#define	SUPERCLASS	CTI_CONTAINER

function cti_bin_new()
	local obj := cti_inherit(cti_container_new(),"CTI_BIN")

	obj:__child		:= nil
	obj:__focus_child	:= nil

	obj:__repaint_container	:= @cti_bin_repaint_container()
	obj:__size_allocate	:= @cti_bin_size_allocate()
	obj:__position_allocate	:= @cti_bin_position_allocate()

	obj:add			:= @cti_bin_add()
	obj:remove		:= @cti_bin_remove()
	obj:for_each		:= @cti_bin_for_each()
	obj:for_all		:= obj:for_each
	obj:for_each_recursive	:= @cti_bin_for_each_recursive()
	obj:for_all_recursive	:= obj:for_each_recursive
	obj:children		:= {|_obj|_obj:__child}
	obj:focus_move		:= @cti_bin_focus_move()
	obj:set_focus_child	:= {||TRUE}
	obj:destroy		:= @cti_bin_destroy()
	obj:realize_real	:= @cti_bin_realize_real()

	obj:signal_connect(HASH_CTI_SET_SIZE_SIGNAL,{|_obj| ;
		iif(_obj:__child!=nil, ;
		(_obj:__child:__size_set := FALSE, _obj:__size_allocate(_obj:__child)), ;
		TRUE)})
return obj

/********************************************************************/
/* Methods */

/* Adds widget */
static function cti_bin_add(obj,child)
	cti_return_if_fail(obj:__child==nil)

	obj:__child := child
	child:parent_id := obj:id

	child:__size_set := FALSE
	child:__position_set := FALSE
//	if !child:__size_set
	obj:__size_allocate(child)
	obj:__position_allocate(child)

	obj:set_focus_child(child)
	obj:repaint_queue()
//	child:signal_connect(HASH_CTI_DRAW_QUEUE_SIGNAL,{|_cnt,_sig,_obj|_obj:__repaint()},obj)
//	obj:signal_connect("CTI_HIDE_SIGNAL",obj,{|_cnt,_sig,_obj|_obj:focus_next_control(),_obj:draw_queue()})
//	obj:signal_connect("CTI_DESTROY_SIGNAL",obj,{|_win,_sig,_obj|_obj:remove_control(_cnt)})
return

static function cti_bin_remove(obj,child)
//	cti_return_if_fail2(obj:__child!=nil)

	if obj:__child:id != child:id
		return FALSE
	endif
	obj:__child := nil
	obj:__focus_child := nil
	obj:draw_queue()
return TRUE

static function cti_bin_for_each(obj,bCode)
	local i

	cti_return_if_fail(valtype(bCode)=="B")
	cti_return_if_fail2(obj:__child!=nil)

	eval(bCode, obj:__child)
return

static function cti_bin_for_each_recursive(obj,bCode)
	local i

	cti_return_if_fail(valtype(bCode)=="B")
	cti_return_if_fail2(obj:__child!=nil)

	if CTI_IS_CONTAINER(obj:__child)
		obj:__child:for_each_recursive(bCode)
	endif
	eval(bCode, obj:__child)
return

static function cti_bin_focus_move(obj,nDirection,wrap_focus)
	obj:__focus_child := obj:__child
	if CTI_IS_CONTAINER(obj:__child)
		obj:__child:focus_move(nDirection,wrap_focus)
	endif
return TRUE

static function cti_bin_realize_real(obj)
	CALL SUPER obj:realize_real()

	if obj:__child==nil
		return TRUE
	endif

	if !obj:__child:__size_set
		obj:__size_allocate(obj:__child)
	endif
	if !obj:__child:__position_set
		obj:__position_allocate(obj:__child)
	endif
return TRUE

static function cti_bin_size_allocate(obj,child)
	if !child:__size_set
		child:__set_real_size(obj:height,obj:width)
	endif

	CALL SUPER obj:__size_allocate(child)
return TRUE

static function cti_bin_position_allocate(obj,child)
	if !child:__position_set
		child:__set_real_position(0,0)
	endif

	CALL SUPER obj:__position_allocate(child)
return TRUE

static function cti_bin_repaint_container(obj,buf)
	local child := obj:__child

	CALL SUPER obj:repaint_real()

	if child!=nil
		if CTI_IS_CONTAINER(child)
			child:__repaint_container(buf)
		else
			obj:__child:__buffer!=nil .and. obj:__child:__buf_dirty
			winbuf_copy(obj:__child:__buffer,,,,,buf,child:top,child:left)
		endif
		obj:__child:__buf_dirty := FALSE
	endif
return TRUE

/* bin destructor - must destroy child */
static function cti_bin_destroy(obj)
	CALL SUPER obj:destroy()
	if obj:__child!=nil .and. HASH_DESTROY $ obj:__child
		obj:__child:parent_id:=nil
		obj:__child:destroy()
		obj:__child := nil
	endif
return TRUE

