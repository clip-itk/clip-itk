/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_BOX - a base class for box containers */

#include "cti.ch"

#define	SUPERCLASS	CTI_CONTAINER

function cti_box_new()
	local obj := cti_inherit(cti_container_new(),"CTI_BOX")

	obj:__pack_queue	:= {}
	obj:__homogeneous	:= FALSE
	obj:__spacing		:= 0

	obj:__pack		:= @cti_box_pack()
	obj:__configure_children:= @cti_box_configure_children()

	obj:pack_start		:= @cti_box_pack_start()
	obj:pack_end		:= @cti_box_pack_end()
	obj:pack_start_defaults	:= @cti_box_pack_start_defaults()
	obj:pack_end_defaults	:= @cti_box_pack_end_defaults()
	obj:set_homogeneous	:= @cti_box_set_homogeneous()
	obj:set_spacing		:= @cti_box_set_spacing()
//	obj:reorder_child	:= @cti_box_reorder_child()
//	obj:query_child_packing	:= @cti_box_query_child_packing()
//	obj:set_child_packing	:= @cti_box_set_child_packing()

	obj:add			:= obj:pack_start_defaults

	obj:signal_connect(HASH_CTI_SET_SIZE_SIGNAL,{|_obj|_obj:__configure_children()})

return obj

static function cti_box_child_info(widget)
	local obj := map()

	obj:widget	:= widget
	obj:padding	:= 0
	obj:expand	:= FALSE
	obj:fill	:= FALSE
	obj:pack	:= CTI_PACK_START
return obj

/********************************************************************/
/* Methods */

/* Adds child to box, packed with reference to the start of box. The child
   is packed after any other child packed with reference to the start of
   box */
static function cti_box_pack_start(obj,child,lExpand,lFill,nPadding)
	obj:__pack(child,lExpand,lFill,nPadding,CTI_PACK_START)
return TRUE

/* Adds child to box, packed with reference to the end of box. The child is
   packed after (away from end of) any other child packed with reference to
   the end of box. */
static function cti_box_pack_end(obj,child,lExpand,lFill,nPadding)
	obj:__pack(child,lExpand,lFill,nPadding,CTI_PACK_END)
return TRUE

/*  Adds widget to box, packed with reference to the start of box. The
child  is  packed  after  any other child packed with reference to the
start of box.
    Parameters  for  how  to  pack the child widget, expand, fill, and
padding are given their default values, TRUE, TRUE, and 0, respectively.
*/
static function cti_box_pack_start_defaults(obj,child)
	obj:__pack(child,TRUE,TRUE,0,CTI_PACK_START)
return TRUE

/*  Adds widget to box, packed with reference to the end of box. The
child  is  packed  after  any other child packed with reference to the
end of box.
    Parameters  for  how  to  pack the child widget, expand, fill, and
padding are given their default values, TRUE, TRUE, and 0, respectively.
*/
static function cti_box_pack_end_defaults(obj,child)
	obj:__pack(child,TRUE,TRUE,0,CTI_PACK_START)
return TRUE

static function cti_box_pack(obj,child,lExpand,lFill,nPadding,nPack)
	local info

	cti_return_if_fail(CTI_IS_WIDGET(child))
	cti_return_if_fail(valtype(lExpand) $ "UL")
	cti_return_if_fail(valtype(lFill) $ "UL")
	cti_return_if_fail(valtype(nPadding) $ "UN")

	if lExpand==nil; lExpand := TRUE; endif
	if lFill==nil; lFill := TRUE; endif
	if nPadding==nil; nPadding := 0; endif

	info := cti_box_child_info(child)
	info:expand := lExpand
	info:fill := lFill
	info:padding := nPadding
	info:pack := nPack

	aadd(obj:__pack_queue,info)

	CALL SUPER obj:add(child)
	obj:__children[child:id] := child
	child:parent_id := obj:id

	obj:__configure_children()
return

/*  Sets  the  homogeneous field of GtkBox, controlling whether or not
all children of box are given equal space in the box. */
static function cti_box_set_homogeneous(obj,lHomogeneous)
	cti_return_if_fail(valtype(lHomogeneous) $ "UL")
	obj:__homogeneous := iif(lHomogeneous==nil,TRUE,lHomogeneous)
	obj:__configure_children()
return TRUE

/*  */
static function cti_box_set_spacing(obj,nSpacing)
	cti_return_if_fail(valtype(nSpacing) $ "UL")
	obj:__spacing := cti_cnum(nSpacing)
	obj:__configure_children()
return TRUE

/* Set size and position of children */
static function cti_box_configure_children(obj,lVertical)
	local i, ql := len(obj:__pack_queue)
	local child, info
	local StartNum:=0, EndNum:=0, expNum
	local height_for_expantion, width_for_expantion, expanded
	local height_expanded, width_expanded, wexp, hexp
	local w,h, left_pos, right_pos, top_pos, bottom_pos

	if lVertical == nil; lVertical==FALSE; endif

	/* Summarize sizes of expanded children */
	expNum := 0
	height_for_expantion := obj:height
	width_for_expantion := obj:width
	height_expanded := width_expanded := 0
	expanded := 0
	for i:=1 to ql
		info := obj:__pack_queue[i]
		child := info:widget
		if child != nil
			if info:expand
//				if !child:__usize_set
					expNum ++
//				endif
				height_expanded += child:height
				width_expanded  += child:width
			else
				height_for_expantion -= child:height
				width_for_expantion  -= child:width
			endif
		endif
	next

	/* Configurate all children */
	left_pos := right_pos := top_pos := bottom_pos :=0
	wexp := hexp := 0
	for i:=1 to ql
		info := obj:__pack_queue[i]
		child := info:widget
		if child != nil
			if info:expand
//				if child:__usize_set
//					h := (child:height / height_expanded) * height_for_expantion
//					w := (child:width / width_expanded) * width_for_expantion
//				else
					h := round(height_for_expantion / expNum)
					w := round(width_for_expantion / expNum)
					expanded ++
					if expanded == expNum
						h := height_for_expantion - hexp
						w := width_for_expantion - wexp
					endif
					wexp += w; hexp += h
//				endif
			else
				h := child:height
				w := child:width
			endif
			if lVertical
				child:__set_size(h,obj:width)
			else
				child:__set_size(obj:height,w)
			endif

			if info:pack == CTI_PACK_START
				child:__set_real_position(top_pos,left_pos)
				if lVertical
					top_pos += child:height
				else
					left_pos += child:width
				endif
			else
				child:__set_real_position(top_pos,left_pos)
				if lVertical
					top_pos += child:height
				else
					left_pos += child:width
				endif
			endif
		endif
	next
	obj:repaint_queue()
return TRUE


