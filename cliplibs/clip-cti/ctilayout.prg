/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/*  CTI_LAYOUT - this container allows you to place widgets at a fixed   */
/*  position  within  it's  window,  relative  to it's upper left hand   */
/*  corner. The position of the widgets can be changed dynamically.      */

#include "cti.ch"

#include "setcurs.ch"

#define	SUPERCLASS	CTI_CONTAINER

function cti_layout_new(height,width)
	local obj := cti_inherit(cti_container_new(),"CTI_LAYOUT")

//	obj:__frozen 		:= FALSE

//	obj:__real_draw		:= @cti_layout_real_draw()
//	obj:__repaint		:= @cti_layout_repaint()

	obj:add			:= @cti_layout_add()
	obj:put			:= obj:add
	obj:__size_allocate	:= @cti_layout_size_allocate()
	obj:__position_allocate	:= @cti_layout_position_allocate()
//	obj:freeze		:= {|_obj|_obj:__frozen := TRUE}
//	obj:thaw		:= {|_obj|_obj:__frozen := FALSE,_obj:draw_queue()}

	obj:set_size(height,width)
return obj

/********************************************************************/
/* Methods */

/* Adds widget */
static function cti_layout_add(obj,child,top,left)

	cti_return_if_fail(CTI_IS_WIDGET(child))

	cti_return_if_fail(top==nil .or. valtype(top)=="N")
	cti_return_if_fail(left==nil .or. valtype(left)=="N")

	CALL SUPER obj:add(child)

	if top!=nil .or. left!=nil
		child:set_position(top,left)
	endif

	obj:repaint_queue()
return TRUE

/*
/* Draws a layout */
static function cti_layout_real_draw(obj)
	local child

	if obj:__frozen; return FALSE; endif

	for child in obj:__children
		if child!=nil
			child:draw_now(obj:parent:__buffer)
		endif
	next
//	obj:parent:draw_queue()
return TRUE

static function cti_layout_repaint(obj,buf)
	local pbuf, child, par

	par := cti_get_object_by_id(obj:parent_id)
//	do while par!=nil .and. CTI_IS_CONTAINER(par)
	do while par!=nil .and. par:__buffer==nil
		par := cti_get_object_by_id(par:parent_id)
	enddo
	if par!=nil
		pbuf := par:__buffer
	endif

	if pbuf!=nil

//		obj:for_each({|_obj|,_obj:__repaint(pbuf)})
		obj:for_each({|_obj|,_obj:draw_now(pbuf)})
	endif
return TRUE
*/

static function cti_layout_size_allocate(obj,child)
	if !child:__size_set
		child:__set_real_size(child:__uheight,child:__uwidth)
	endif

	CALL SUPER obj:__size_allocate(child)
return TRUE

static function cti_layout_position_allocate(obj,child)
	if !child:__position_set
		child:__set_real_position(child:__utop,child:__uleft)
	endif

	CALL SUPER obj:__position_allocate(child)
return TRUE

