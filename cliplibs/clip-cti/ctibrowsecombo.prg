/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_BROWSE_COMBO - a text entry field with a dropdown TBrowse */

#include "cti.ch"
#include "inkey.ch"

#define	SUPERCLASS	CTI_ENTRY

//#ifdef __UNIX__
   #define LB_PUSHSYM "#"
//#else
//   #define LB_PUSHSYM chr(31)
//#endif

function cti_browse_combo_new(TBrowse,EntryType)
	local obj := cti_inherit(cti_entry_new(EntryType),"CTI_BROWSE_COMBO")

	obj:tbrowse	:= iif(CTI_IS_TBROWSE(TBrowse),TBrowse,cti_tbrowse_new())
	obj:window	:= cti_window_new()
//	obj:button	:= cti_pushbutton_new() /* Boxes not implemented yet */

	obj:window:set_enabled(FALSE)

	obj:__is_opened	:= FALSE
	obj:__value	:= nil

	obj:browse_rows	:= 10

		/* If Entry must change when change row in TBrowse,
		use obj:follow_tbrowse(TRUE) */
	obj:follow_tbrowse	:= @cti_browse_combo_follow_tbrowse()
	obj:__follow_tbrowse	:= FALSE

		/* Sets block, which returns value for Entry when row changed */
	obj:set_select_block	:= @cti_browse_combo_set_select_block()
	obj:__select_block	:= nil

		/* If TBrowse must change row position when Entry changed,
		use obj:follow_entry(TRUE) */
	obj:follow_entry	:= @cti_browse_combo_follow_entry()
	obj:__follow_entry	:= FALSE

		/* If TBrowse must change row position when Entry changed,
		even dropdown list closed, use obj:follow_entry_if_closed(TRUE) */
	obj:follow_entry_if_closed := @cti_browse_combo_follow_entry_if_closed()
	obj:__follow_entry_if_closed := FALSE

		/* Sets block, which sets row position in TBrowse in dependence
		of Entry value */
	obj:set_change_block	:= @cti_browse_combo_set_change_block()
	obj:__change_block	:= nil

		/* If BrowseCombo must change value by pressing Up/Down when
		dropdown list closed, use obj:use_arrows(TRUE) */
	obj:use_arrows		:= @cti_browse_combo_use_arrows()
	obj:__use_arrows	:= TRUE

		/* If BrowseCombo value must be changed, when TBrowse activated
		(pressing Enter, by default), use obj:set_value_on_activate(TRUE) */
	obj:set_value_on_activate := @cti_browse_combo_set_value_on_activate()
	obj:__set_val_on_activate := TRUE

		/* If Entry may contain only values, presented in list,
		use obj:set_value_in_list(TRUE) */
	obj:set_value_in_list	:= @cti_browse_combo_set_value_in_list()
	obj:__value_in_list	:= FALSE

		/* If BrowseCombo value must be changed on every change of TBrowse
		row (not on activating and focus losing), use
		obj:set_value_on_select(TRUE) */
	obj:set_value_on_select	:= @cti_browse_combo_set_value_on_select()
	obj:__set_value_on_select	:= FALSE
		/* Sets block, which returns value used as BrowseCombo value */
	obj:set_value_block	:= @cti_browse_combo_set_value_block()
	obj:__set_value_block	:= nil




	obj:__post_valid	:= @cti_browse_combo_post_valid()

	obj:__handle_event	:= @cti_browse_combo_handle_event()
	obj:__init		:= @cti_browse_combo_init()

	obj:__select_tbrowse_row:= @cti_browse_combo_select_tbrowse_row()
	obj:__change_entry_value:= @cti_browse_combo_change_entry_value()

	obj:set_default_keys	:= @cti_browse_combo_set_default_keys()

	obj:get_value		:= {|_obj|obj:__value}
	obj:set_value		:= @cti_browse_combo_set_value()
	obj:set_entry_value	:= @cti_browse_combo_set_entry_value()
	obj:get_entry_value	:= @cti_browse_combo_get_entry_value()
	obj:set_caption		:= {|_obj,_cap|_obj:window:set_caption(_cap)}
	obj:activate_tbrowse	:= @cti_browse_combo_activate_tbrowse()

	obj:set_tbrowse		:= @cti_browse_combo_set_tbrowse()
	obj:get_tbrowse		:= {|_obj|_obj:tbrowse}
	obj:open		:= {|_obj|_obj:signal_emit(HASH_CTI_OPEN_SIGNAL)}
	obj:close		:= {|_obj|_obj:signal_emit(HASH_CTI_CLOSE_SIGNAL)}
	obj:open_real		:= @cti_browse_combo_open_real()
	obj:close_real		:= @cti_browse_combo_close_real()
	obj:realize_real	:= @cti_browse_combo_realize_real()

	obj:destroy		:= @cti_browse_combo_destroy()

	obj:__init()

	obj:__signal_connect_internal(HASH_CTI_OPEN_SIGNAL, {|_obj|_obj:open_real()})
	obj:__signal_connect_internal(HASH_CTI_CLOSE_SIGNAL, {|_obj|_obj:close_real()})

	obj:set_default_keys()
return obj

/*
static function cti_option_menu_select_menu_item(obj,item,item_no)
	cti_return_if_fail(CTI_IS_MENUITEM(item))
	obj:set_caption(item:get_caption())
	if item:get_data() == nil
		obj:set_value(item_no)
	else
		obj:set_value(item:get_data())
	endif
return TRUE
*/

static function cti_browse_combo_init(obj)
	obj:signal_connect(HASH_CTI_WIDGET_LOST_FOCUS_SIGNAL,obj:__post_valid)

	obj:tbrowse:signal_connect(HASH_CTI_SELECT_ROW_SIGNAL,{|_obj,_sig,_brc|_brc:__select_tbrowse_row()},obj)
	obj:signal_connect(HASH_CTI_CHANGED_SIGNAL,{|_obj,_sig|_obj:__change_entry_value()})

	obj:window:add(obj:tbrowse)
return TRUE

static function cti_browse_combo_realize_real(obj)
	local w
	CALL SUPER obj:realize_real()

	if !obj:window:__size_set .and. !obj:window:__usize_set
		obj:window:__set_size(obj:browse_rows+2,32)
	endif
return TRUE

static function cti_browse_combo_open_real(obj)
	memvar CtiApplication

	if .not. obj:__is_opened
		obj:__is_opened := TRUE
		obj:window:__set_position(obj:__abs_top + 1, obj:__abs_left)
		obj:window:show()
		if !obj:tbrowse:__is_realized
			obj:tbrowse:show()
			obj:tbrowse:set_focus()
		endif
		CtiApplication:add(obj:window)
		if empty(obj:get_entry_value())
			obj:__select_tbrowse_row()
		else
			obj:__change_entry_value()
		endif
		obj:draw_queue()
	endif
return TRUE

static function cti_browse_combo_close_real(obj)
	memvar CtiApplication

	if obj:__is_opened
		obj:__is_opened := FALSE
		obj:window:hide()
		CtiApplication:remove(obj:window)
		obj:draw_queue()
	endif
return TRUE

/*
static function cti_browse_combo_set_value(obj,value)
	local sig, old_value

	if .not. obj:__initialized; return FALSE; endif
	old_value := obj:__value
	obj:__value := value
	sig := cti_signal_new(HASH_CTI_CHANGED_SIGNAL)
	sig:old_value := old_value
	sig:value := value
	obj:signal_emit(sig)
	obj:draw_queue()
return TRUE
*/

static function cti_browse_combo_set_tbrowse(obj, browser)
	cti_return_if_fail(CTI_IS_TBROWSE(browser))
	if obj:tbrowse != nil
		obj:window:remove(obj:tbrowse)
	endif
	obj:tbrowse := browser
	obj:window:add(browser)
	obj:close()
return TRUE

static function cti_browse_combo_handle_event(obj,event)
	local ret := FALSE

	if event:type != CTI_KEYBOARD_EVENT; return TRUE; endif

	if obj:__is_opened
		ret := obj:tbrowse:__handle_event(event)
	else
		if obj:__use_arrows .and. (event:keycode==K_UP .or. event:keycode==K_DOWN)
			ret := obj:tbrowse:__handle_event(event)
		endif
	endif
	if ret == FALSE
		CALL SUPER obj:__handle_event(event) TO ret
//		ret := obj:apply_key(event:keycode)
	endif

/*
	switch (event:keycode)
		case K_UP
		obj:tbrowse:__handle_event(event)
		event:type := CTI_NOTHING_EVENT
		return TRUE

		case K_DOWN
		obj:tbrowse:__handle_event(event)
		event:type := CTI_NOTHING_EVENT
		return TRUE

		otherwise
		return obj:apply_key(event:keycode)
	end
*/
return ret

static function cti_browse_combo_select_tbrowse_row(obj)
	local old_follow_entry

	if obj:__follow_tbrowse .and. obj:__select_block!=nil
		old_follow_entry := obj:__follow_entry
		obj:__follow_entry := FALSE
		obj:set_entry_value(eval(obj:__select_block,obj))
		if obj:__set_value_on_select
			obj:set_value()
		endif
		obj:__follow_entry := old_follow_entry
	endif
return TRUE

static function cti_browse_combo_change_entry_value(obj)
	local old_follow_tbrowse, found

	if !obj:__is_opened .and. !obj:__follow_entry_if_closed
		return FALSE
	endif

	if obj:__follow_entry .and. obj:__change_block!=nil
		old_follow_tbrowse := obj:__follow_tbrowse
		obj:__follow_tbrowse := FALSE
		found := eval(obj:__change_block,obj,obj:get_entry_value())
		if found
			obj:set_value()
		else
			obj:__value := nil
			obj:signal_emit(HASH_CTI_NOT_IN_LIST_SIGNAL)
		endif
		if obj:__is_opened
			obj:tbrowse:refresh_all()
		endif
		obj:__follow_tbrowse := old_follow_tbrowse
	endif
return TRUE

static function cti_browse_combo_set_default_keys(obj)
	obj:set_key(K_F4,	{|_obj|iif(_obj:__is_opened,_obj:close(),_obj:open()) } )
	obj:set_key(K_ENTER,	obj:activate_tbrowse )
	obj:set_key(K_ESC,	obj:close )
return TRUE

static function cti_browse_combo_set_entry_value(obj,Value)
	local ret
	CALL SUPER obj:set_value(Value) TO ret
return ret

static function cti_browse_combo_get_entry_value(obj)
	local ret
	CALL SUPER obj:get_value() TO ret
return ret

static function cti_browse_combo_activate_tbrowse(obj)
	if obj:__set_val_on_activate
		if obj:__is_opened
			obj:__select_tbrowse_row()
			if !obj:__set_value_on_select
				obj:set_value()
			endif
		else
//			obj:__change_entry_value()
			if eval(obj:__change_block,obj,obj:get_entry_value())
				obj:set_value()
			else
				obj:__value := nil
				obj:signal_emit(HASH_CTI_NOT_IN_LIST_SIGNAL)
			endif
		endif
	endif
	obj:signal_emit(HASH_CTI_ACTIVATE_SIGNAL)
	obj:close()
return TRUE

static function cti_browse_combo_follow_tbrowse(obj,lFollow)
	cti_return_if_fail(valtype(lFollow) $ "UL")
	if lFollow==nil; lFollow:=TRUE; endif
	obj:__follow_tbrowse := lFollow
//	obj:__select_tbrowse_row()
return TRUE

static function cti_browse_combo_set_select_block(obj,bSelectBlock)
	cti_return_if_fail(valtype(bSelectBlock) $ "UB")

	obj:__select_block := bSelectBlock
//	obj:__select_tbrowse_row()
return TRUE

static function cti_browse_combo_follow_entry(obj,lFollow)
	cti_return_if_fail(valtype(lFollow) $ "UL")
	if lFollow==nil; lFollow:=TRUE; endif
	obj:__follow_entry := lFollow
return TRUE

static function cti_browse_combo_follow_entry_if_closed(obj,lFollow)
	cti_return_if_fail(valtype(lFollow) $ "UL")
	if lFollow==nil; lFollow:=TRUE; endif
	obj:__follow_entry_if_closed := lFollow
return TRUE

static function cti_browse_combo_set_change_block(obj,bChangeBlock)
	cti_return_if_fail(valtype(bChangeBlock) $ "UB")

	obj:__change_block := bChangeBlock
//	obj:__select_tbrowse_row()
return TRUE

static function cti_browse_combo_set_value_block(obj,bSetValueBlock)
	cti_return_if_fail(valtype(bSetValueBlock) $ "UB")

	obj:__set_value_block := bSetValueBlock
return TRUE

static function cti_browse_combo_set_value(obj)
	if obj:__set_value_block == nil; return FALSE; endif
	obj:__value := eval(obj:__set_value_block,obj)
	obj:signal_emit(HASH_CTI_SET_VALUE_SIGNAL)
return TRUE

static function cti_browse_combo_set_value_in_list(obj,lValueInList)
	cti_return_if_fail(valtype(lValueInList) $ "UL")
	if lValueInList==nil; lValueInList:=TRUE; endif
	obj:__value_in_list := lValueInList
return TRUE

static function cti_browse_combo_set_value_on_select(obj,lSetValueOnSelect)
	cti_return_if_fail(valtype(lSetValueOnSelect) $ "UL")
	if lSetValueOnSelect==nil; lSetValueOnSelect:=TRUE; endif
	obj:__set_value_on_select := lSetValueOnSelect
return TRUE

static function cti_browse_combo_post_valid(obj,sig)
	local old_follow_entry_if_closed

	if obj:__value_in_list .and. obj:__set_value_block!=nil
		old_follow_entry_if_closed := obj:__follow_entry_if_closed
		obj:__follow_entry_if_closed := TRUE
		obj:__change_entry_value()
		obj:__follow_entry_if_closed := old_follow_entry_if_closed
		if obj:__value==nil
			obj:open()
			sig:type := HASH_CTI_NO_SIGNAL
			return FALSE
		endif
	endif
	obj:close()
return TRUE

static function cti_browse_combo_use_arrows(obj,lUseArrows)
	cti_return_if_fail(valtype(lUseArrows) $ "UL")
	if lUseArrows==nil; lUseArrows:=TRUE; endif
	obj:__use_arrows := lUseArrows
return TRUE

static function cti_browse_combo_set_value_on_activate(obj,lSetOnActivate)
	cti_return_if_fail(valtype(lSetOnActivate) $ "UL")
	if lSetOnActivate==nil; lSetOnActivate:=TRUE; endif
	obj:__set_val_on_activate := lSetOnActivate
return TRUE

static function cti_browse_combo_destroy(obj)
	CALL SUPER obj:destroy()
	obj:tbrowse:destroy()
	obj:window:destroy()
return TRUE

