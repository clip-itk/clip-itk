/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_TBROWSE - Provide objects for browsing table-oriented data */

#include "cti.ch"

#include "setcurs.ch"
#include "inkey.ch"
#include "dbedit.ch"

#define	SUPERCLASS	CTI_CONTROL

function cti_tbrowse_new()
	local obj := cti_inherit(cti_control_new(),"CTI_TBROWSE")

	obj:__tbrowse	:= TBrowseNew(0,0,0,0)

	obj:__control_focused	:= FALSE
	obj:auto_lose_focus	:= FALSE

	obj:__skipblock		:= nil

	obj:CursorRow		:= 0
	obj:CursorCol		:= 0
	obj:CursorLen		:= 0

	obj:__tbrowse:headSep	:= DE_HEADSEP
	obj:__tbrowse:colSep	:= DE_COLSEP
	obj:__tbrowse:chop	:= TRUE
	obj:__tbrowse:autoLite	:= FALSE

	obj:__stabilize_run	:= FALSE
	obj:__signals_on_stable	:= {}

	obj:__real_draw		:= @cti_tbrowse_real_draw()
	obj:__make_buffer	:= @cti_tbrowse_make_buffer()
	obj:__handle_event	:= @cti_tbrowse_handle_event()
	obj:__stabilize		:= @cti_tbrowse_stabilize()

	obj:add_column		:= @cti_tbrowse_add_column()
	obj:ins_column		:= @cti_tbrowse_ins_column()
	obj:del_column		:= @cti_tbrowse_del_column()
	obj:set_browser_size	:= @cti_tbrowse_set_browser_size()
	obj:set_skip_block	:= @cti_tbrowse_set_skip_block()

	obj:refresh_current	:= {|_obj|_obj:__tbrowse:RefreshCurrent(),_obj:draw_queue()}
	obj:refresh_all		:= {|_obj|_obj:__tbrowse:RefreshAll(),_obj:draw_queue()}

	obj:__sig_select_row_gen := @cti_tbrowse_sig_select_row_gen()
	obj:__sig_cursor_moved_gen := @cti_tbrowse_sig_cursor_moved_gen()

	obj:down		:= @cti_tbrowse_down()
	obj:up			:= @cti_tbrowse_up()
	obj:pageDown		:= @cti_tbrowse_pageDown()
	obj:pageUp		:= @cti_tbrowse_pageUp()
	obj:goBottom		:= @cti_tbrowse_goBottom()
	obj:goTop		:= @cti_tbrowse_goTop()
	obj:end			:= {|_obj| _obj:__tbrowse:end(), _obj:__sig_cursor_moved_gen(), TRUE }
	obj:home		:= {|_obj| _obj:__tbrowse:home(), _obj:__sig_cursor_moved_gen(), TRUE }
	obj:left		:= {|_obj| _obj:__tbrowse:left(), _obj:__sig_cursor_moved_gen(), TRUE }
	obj:right		:= {|_obj| _obj:__tbrowse:right(), _obj:__sig_cursor_moved_gen(), TRUE }
	obj:panEnd		:= {|_obj| _obj:__tbrowse:panEnd(), _obj:__sig_cursor_moved_gen(), TRUE }
	obj:panHome		:= {|_obj| _obj:__tbrowse:panHome(), _obj:__sig_cursor_moved_gen(), TRUE }
	obj:panLeft		:= {|_obj| _obj:__tbrowse:panLeft(), _obj:__sig_cursor_moved_gen(), TRUE }
	obj:panRight		:= {|_obj| _obj:__tbrowse:panRight(), _obj:__sig_cursor_moved_gen(), TRUE }

	obj:realize_real	:= @cti_tbrowse_realize_real()
	obj:set_default_keys	:= @cti_tbrowse_set_default_keys()

	obj:set_default_keys()
	obj:signal_connect(HASH_CTI_SET_SIZE_SIGNAL, obj:set_browser_size)
return obj

static function cti_tbrowse_set_default_keys(obj)
	obj:__tbrowse:__keys := map()

	obj:set_key(K_DOWN,		obj:down )
	obj:set_key(K_UP,   		obj:up )
	obj:set_key(K_END,		obj:end )
	obj:set_key(K_HOME,		obj:home )
	obj:set_key(K_LEFT,		obj:left )
	obj:set_key(K_RIGHT,		obj:right )
	obj:set_key(K_PGDN,		obj:pageDown )
	obj:set_key(K_PGUP,		obj:pageUp )
	obj:set_key(K_CTRL_PGDN,	obj:goBottom )
	obj:set_key(K_CTRL_PGUP,	obj:goTop )
	obj:set_key(K_CTRL_END,		obj:panEnd )
	obj:set_key(K_CTRL_HOME,	obj:panHome )
	obj:set_key(K_CTRL_LEFT,	obj:panLeft )
	obj:set_key(K_CTRL_RIGHT,	obj:panRight )
return TRUE

static function cti_tbrowse_make_buffer(obj)
	CALL SUPER obj:__make_buffer()
	obj:__tbrowse:winbuffer := obj:__buffer
return

static function cti_tbrowse_set_browser_size(obj,sig)
	obj:__tbrowse:nRight := cti_cnum(obj:width)-1
	obj:__tbrowse:nBottom := cti_cnum(obj:height)-1
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

	if obj:__tbrowse:colCount > 0 .and. obj:__is_realized
		obj:__tbrowse:configure()
	endif
return TRUE

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
	local color, i

	CALL SUPER obj:__real_draw()

	if !obj:__is_realized; return FALSE; endif

	cti_return_if_fail(obj:__skipBlock != nil)

	color := obj:Palette:Control+","+obj:Palette:Selection
	if !obj:__is_enabled; color := obj:Palette:DisabledControl+","+obj:Palette:DisabledControl; endif

	if obj:__tbrowse:colorSpec != color
		obj:__tbrowse:colorSpec := color
		obj:__tbrowse:configure()
		obj:__tbrowse:invalidate()
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

	if obj:__tbrowse:stable
		if !empty(obj:__signals_on_stable)
			for i:=1 to len(obj:__signals_on_stable)
				obj:signal_emit(obj:__signals_on_stable[i])
				obj:__signals_on_stable[i] := nil
			next
			obj:__signals_on_stable := {}
		endif
	else
		obj:__stabilize()
//		start(obj:__stabilize, obj)
	endif
return TRUE

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

	if event:type != CTI_KEYBOARD_EVENT; return FALSE; endif

	if obj:apply_key(event:keycode)
		obj:draw_queue()
		return TRUE
	endif
return FALSE

static function cti_tbrowse_realize_real(obj)
	CALL SUPER obj:realize_real()
	if obj:__tbrowse:colCount > 0
		obj:__tbrowse:colPos := 1
		obj:__tbrowse:configure()
	endif
return

static function cti_tbrowse_down(obj)
	obj:__tbrowse:down()
	if obj:__tbrowse:hitBottom
		return !obj:auto_lose_focus
	endif
	obj:__sig_select_row_gen()
	obj:__sig_cursor_moved_gen()
return TRUE

static function cti_tbrowse_up(obj)
	obj:__tbrowse:up()
	if obj:__tbrowse:hitTop
		return !obj:auto_lose_focus
	endif
	obj:__sig_select_row_gen()
	obj:__sig_cursor_moved_gen()
return TRUE

static function cti_tbrowse_pageDown(obj)
	obj:__tbrowse:PageDown()
	obj:__sig_select_row_gen()
	obj:__sig_cursor_moved_gen()
return TRUE

static function cti_tbrowse_pageUp(obj)
	obj:__tbrowse:PageUp()
	obj:__sig_select_row_gen()
	obj:__sig_cursor_moved_gen()
return TRUE

static function cti_tbrowse_goBottom(obj)
	obj:__tbrowse:GoBottom()
	if obj:__tbrowse:hitBottom
		return !obj:auto_lose_focus
	endif
	obj:__sig_select_row_gen()
	obj:__sig_cursor_moved_gen()
return TRUE

static function cti_tbrowse_goTop(obj)
	obj:__tbrowse:GoTop()
	if obj:__tbrowse:hitTop
		return !obj:auto_lose_focus
	endif
	obj:__sig_select_row_gen()
	obj:__sig_cursor_moved_gen()
return TRUE

static function cti_tbrowse_sig_select_row_gen(obj)
	if obj:__is_realized
		aadd(obj:__signals_on_stable, cti_signal_new(HASH_CTI_SELECT_ROW_SIGNAL))
	else
		obj:signal_emit(HASH_CTI_SELECT_ROW_SIGNAL)
	endif
return TRUE

static function cti_tbrowse_sig_cursor_moved_gen(obj)
	local sig

	obj:CursorRow := obj:__tbrowse:CursorRow
	obj:CursorCol := obj:__tbrowse:CursorCol
	obj:CursorLen := obj:__tbrowse:CursorLen
	if obj:__is_realized
		aadd(obj:__signals_on_stable, cti_signal_new(HASH_CTI_TBROWSE_CURSOR_MOVED_SIGNAL))
	else
		obj:signal_emit(cti_signal_new(HASH_CTI_TBROWSE_CURSOR_MOVED_SIGNAL))
	endif
return TRUE
