/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_OPTION_MENU - a widget used to choose from a list of valid choices. */

#include "cti.ch"

#include "inkey.ch"

#define	SUPERCLASS	CTI_PUSHBUTTON

//#ifdef __UNIX__
   #define LB_PUSHSYM "#"
//#else
//   #define LB_PUSHSYM chr(31)
//#endif

function cti_option_menu_new()
	local obj := cti_inherit(cti_pushbutton_new(),"CTI_OPTION_MENU")

	obj:__menu	:= cti_menu_new()
	obj:__is_opened	:= FALSE
	obj:__value	:= nil
	obj:__item_caption := ""


	obj:__handle_event	:= @cti_option_menu_handle_event()
	obj:__init		:= @cti_option_menu_init()

	obj:__select_menu_item	:= @cti_option_menu_select_menu_item()
	obj:__set_default_keys	:= @cti_option_menu_set_default_keys()

	obj:get_value		:= {|_obj|obj:__value}
	obj:set_value		:= @cti_option_menu_set_value()
	obj:set_caption		:= @cti_option_menu_set_caption()

	obj:set_menu		:= @cti_option_menu_set_menu()
	obj:get_menu		:= {|_obj|_obj:__menu}
	obj:open		:= {|_obj|_obj:signal_emit(HASH_CTI_OPEN_SIGNAL)}
	obj:close		:= {|_obj|_obj:signal_emit(HASH_CTI_CLOSE_SIGNAL)}
	obj:open_real		:= @cti_option_menu_open_real()
	obj:close_real		:= @cti_option_menu_close_real()
	obj:realize_real	:= @cti_option_menu_realize_real()

	obj:destroy		:= @cti_option_menu_destroy()

	obj:__init()

	obj:__signal_connect_internal(HASH_CTI_OPEN_SIGNAL, {|_obj|_obj:open_real()})
	obj:__signal_connect_internal(HASH_CTI_CLOSE_SIGNAL, {|_obj|_obj:close_real()})

	obj:__set_default_keys()
return obj

static function cti_option_menu_set_caption(obj,cCaption)
	cCaption := cti_text_justify(cCaption,cti_cnum(obj:width)-1,obj:__justification)+LB_PUSHSYM
	CALL SUPER obj:set_caption(cCaption)
return

static function cti_option_menu_select_menu_item(obj,item,item_no)
	cti_return_if_fail(CTI_IS_MENUITEM(item))
	obj:__item_caption := item:get_caption()
	obj:set_caption(obj:__item_caption)
	if item:get_data() == nil
		obj:set_value(item_no)
	else
		obj:set_value(item:get_data())
	endif
return TRUE

static function cti_option_menu_init(obj)
	obj:set_style(nil)
	obj:set_justify(CTI_JUSTIFY_LEFT)
	obj:signal_connect(HASH_CTI_WIDGET_LOST_FOCUS_SIGNAL,{|_obj,_sig|_obj:close()})
	obj:__menu:signal_connect(HASH_CTI_ITEM_SELECTED_SIGNAL,{|_obj,_sig,_opm|_opm:__select_menu_item(_sig:item,_sig:item_no)},obj)
	obj:__menu:show()
return TRUE

static function cti_option_menu_open_real(obj)
	if .not. obj:__is_opened
		obj:__is_opened := TRUE
		obj:__menu:left := obj:__abs_left
		obj:__menu:top := obj:__abs_top + 1
		obj:__menu:popup()
		obj:draw_queue()
	endif
return TRUE

static function cti_option_menu_realize_real(obj)
	obj:set_caption(obj:__item_caption)
	CALL SUPER obj:realize_real()
return TRUE

static function cti_option_menu_close_real(obj)
	if obj:__is_opened
		obj:__is_opened := FALSE
		obj:__menu:unpopup()
		obj:draw_queue()
	endif
return TRUE

static function cti_option_menu_set_value(obj,value)
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

static function cti_option_menu_set_menu(obj, menu)
	cti_return_if_fail(CTI_IS_MENU(menu))
	obj:__menu:=menu
	obj:__is_opened := FALSE
return TRUE

static function cti_option_menu_handle_event(obj,event)

	if event:type != CTI_KEYBOARD_EVENT; return TRUE; endif

	switch (event:keycode)
		case K_UP
		obj:__menu:__handle_event(event)
		event:type := CTI_NOTHING_EVENT
		return TRUE

		case K_DOWN
		obj:__menu:__handle_event(event)
		event:type := CTI_NOTHING_EVENT
		return TRUE

		otherwise
		return obj:apply_key(event:keycode)
	end
return FALSE

static function cti_option_menu_set_default_keys(obj)
	obj:set_key(K_SPACE,  {|_obj|iif(_obj:__is_opened,_obj:close(),_obj:open())} )
	obj:set_key(K_ENTER,  obj:close  )
	obj:set_key(K_ESC,  obj:close  )
return TRUE

static function cti_option_menu_destroy(obj)
	CALL SUPER obj:destroy()
	obj:__menu:destroy()
return TRUE

