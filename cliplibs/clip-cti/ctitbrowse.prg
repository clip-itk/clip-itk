/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_TBROWSE - Provide objects for browsing table-oriented data */

#include "cti.ch"
#include "ctitbrowse.ch"
#include "ctievents.ch"

#include "setcurs.ch"
#include "inkey.ch"
#include "dbedit.ch"

#define	SUPERCLASS	CTI_CONTROL

function cti_tbrowse_new()
	local obj := cti_inherit(cti_control_new(),"CTI_TBROWSE")

	obj:__tbrowse	:= TBrowseNew(0,0,0,0)

	obj:__initialized	:= FALSE
	obj:__control_focused	:= FALSE

	obj:__skipblock		:= nil

	obj:__tbrowse:headSep	:= DE_HEADSEP
	obj:__tbrowse:colSep	:= DE_COLSEP
	obj:__tbrowse:chop	:= TRUE
	obj:__tbrowse:autoLite	:= FALSE

	obj:__stabilize_run	:= FALSE

	obj:__real_draw		:= @cti_tbrowse_real_draw()
	obj:__make_buffer	:= @cti_tbrowse_make_buffer()

	obj:add_column		:= @cti_tbrowse_add_column()
	obj:ins_column		:= @cti_tbrowse_ins_column()
	obj:del_column		:= @cti_tbrowse_del_column()
	obj:set_size		:= @cti_tbrowse_set_size()
	obj:set_position	:= @cti_tbrowse_set_position()
	obj:set_skip_block	:= @cti_tbrowse_set_skip_block()
	obj:__handle_event	:= @cti_tbrowse_handle_event()
	obj:__stabilize		:= @cti_tbrowse_stabilize()
return obj

static function cti_tbrowse_make_buffer(obj)
	CALL SUPER obj:__make_buffer()
	obj:__tbrowse:winbuffer := obj:__buffer
return

static function cti_tbrowse_set_size(obj,height,width)
//	obj:__make_buffer()                 ////////////////////////////////////
	CALL SUPER obj:set_size(height,width)
	obj:__tbrowse:nRight := width-1
	obj:__tbrowse:nBottom := height-1
	if obj:__tbrowse:colCount > 0
		obj:__tbrowse:configure()
	endif
return .T.

static function cti_tbrowse_set_position(obj,top,left)
	CALL SUPER obj:set_position(top,left)
	if obj:__tbrowse:colCount > 0
		obj:__tbrowse:configure()
	endif
return .T.

static function cti_tbrowse_add_column(obj,cCol,bBlock)
	local column:=nil

	if valtype(cCol)=="C"
		column := TBColumnNew(cCol,bBlock)
	endif

	if valtype(cCol)=="O" .and. cCol:classname=="TBCOLUMN"
		column := cCol
	endif

	if column != nil
		obj:__tbrowse:addColumn(column)
	endif

	if obj:__tbrowse:colCount > 0
		obj:__tbrowse:configure()
	endif
return .T.

static function cti_tbrowse_ins_column(obj,nPos,cCol,bBlock)
	local column:=nil

	if valtype(cCol)=="C"
		column := TBColumnNew(cCol,bBlock)
	endif

	if valtype(cCol)=="O" .and. cCol:classname=="TBCOLUMN"
		column := cCol
	endif

	if column != nil
		obj:__tbrowse:insColumn(nPos,column)
	endif

	if obj:__tbrowse:colCount > 0
		obj:__tbrowse:configure()
	endif
return TRUE

static function cti_tbrowse_del_column(obj,nPos)
	obj:__tbrowse:delColumn(nPos)
return TRUE

static function cti_tbrowse_set_skip_block(obj, block)
	obj:__skipBlock := block
	obj:__tbrowse:skipBlock := block
	obj:draw_queue()
return TRUE

static function cti_tbrowse_real_draw(obj)
	local color

//	if .not. obj:__initialized; return .F.; endif

	if obj:__skipBlock == nil; return FALSE; endif

	color := obj:Palette:Control+","+obj:Palette:Selection
	if !obj:__is_enabled; color := obj:Palette:DisabledControl+","+obj:Palette:DisabledControl; endif

	if obj:__tbrowse:colorSpec != color
		obj:__tbrowse:colorSpec := color
		obj:__tbrowse:configure()
		obj:__tbrowse:invalidate()
//		obj:__tbrowse:forceStable()
	endif

	if obj:__control_focused != obj:__is_focused
		if obj:__is_focused
			obj:__tbrowse:hilite()
		else
			obj:__tbrowse:dehilite()
		endif
		obj:__tbrowse:autoLite	:= obj:__is_focused
		obj:__control_focused := obj:__is_focused
	endif

	if .not. obj:__tbrowse:stable
		obj:__stabilize()
	endif
return .T.

static function cti_tbrowse_stabilize(obj)
	if .not. obj:__stabilize_run
		obj:__stabilize_run := TRUE
		obj:__tbrowse:stabilize()
		obj:__stabilize_run := FALSE
	endif
	obj:draw_queue()
	obj:signal_emit(cti_signal_new(HASH_CTI_TBROWSE_STABILIZE))
return TRUE

static function cti_tbrowse_handle_event(obj,event)
***********************************************
	local cKey
	local not_changed := TRUE
	local b

	if event:type != CTI_KEYBOARD_EVENT; return TRUE; endif

	b := obj:__tbrowse:setkey(event:keycode)
	if b != NIL
		eval(b,obj:__tbrowse,event:keycode)
		not_changed := FALSE
	endif

	if not_changed
		// nothing
	else
		obj:draw_queue()
	endif
return

