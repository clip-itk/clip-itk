/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_MENUBAR - used as a main menu in which pop-up menus reside */

#include "cti.ch"

#include "inkey.ch"

#define	SUPERCLASS	CTI_MENUSHELL

/* CTI_MENUBAR constructor */
function cti_menubar_new(top,left,width)
	local obj := cti_inherit(cti_menushell_new(),"CTI_MENUBAR")
	memvar CtiApplication

	obj:__real_draw			:= @cti_menubar_real_draw()
	obj:__handle_event		:= @cti_menubar_handle_event()
	obj:__set_default_keys		:= @cti_menubar_set_default_keys()
	obj:can_focus			:= {|_obj|_obj:__is_shown .and. _obj:__is_enabled}

	obj:popup_item			:= @cti_menubar_popup_item()
	obj:unpopup_item		:= @cti_menubar_unpopup_item()

/*************************************************/
//	CtiApplication:put_widget(obj)
	obj:signal_connect(HASH_CTI_ACTIVATE_SIGNAL,{|_menu,_sig,_app|_app:set_focus_to_top_window()},CtiApplication)
	obj:signal_connect(HASH_CTI_ITEM_SELECTED_SIGNAL,{|_obj,_sig|_obj:popup_item(_sig:item)})
	obj:signal_connect(HASH_CTI_ITEM_DESELECTED_SIGNAL,{|_obj,_sig| ;
		iif(_sig:item:is_popup(),_sig:item:__submenu:unpopup(),nil)})

	obj:signal_connect(HASH_CTI_WIDGET_SET_FOCUS_SIGNAL,{|_m,_sig|_m:popup_item(_m:__current) })
	obj:signal_connect(HASH_CTI_WIDGET_LOST_FOCUS_SIGNAL,{|_m,_sig| _m:unpopup_item(_m:__current) })

	obj:__set_default_keys()
return obj

/************************************************************/

/* Draw a menu bar */
static function cti_menubar_real_draw(obj)
	local i, item, left
	local color, bg

	left := 0
	winbuf_out_at(obj:__buffer,0,0,space(obj:width),obj:Palette:Menu)
	for i:=1 to obj:__item_count
		item := obj:__items[i]
		if item:__caption != nil .and. item:__is_shown
			color := item:Palette:Menu
			if obj:__is_focused .and. i==obj:__current
				color := item:Palette:ActiveMenu
			endif
			winbuf_out_at(obj:__buffer,0,left,item:__caption,color)
			if item:__accel_pos > 0
				bg := substr(color, at("/",color)+1)
				winbuf_attr_at(obj:__buffer,0,left+item:__accel_pos, ;
					0,left+item:__accel_pos,item:Palette:AccelKey+"/"+bg)
			endif
//			item:top := obj:0
//			item:left := obj:left + left
			item:top := 0
			item:left := left
			left += len(item:__caption)
		endif
	next
return TRUE

/* Redraw a menu bar */
static function cti_menubar_repaint(obj,buf)
	local item

	CALL SUPER obj:__repaint(buf)

	if obj:__is_focused
		item := obj:__items[obj:__current]
		if item:is_popup()
			item:__submenu:__repaint(buf)
		endif
	endif
return TRUE

/* Popup submenu connected to item "item_no" */
static function cti_menubar_popup_item(obj,item_no)
	local item

	if valtype(item_no)=="N"
		cti_return_if_fail(item_no>0 .and. item_no<=obj:__item_count)
		item := obj:__items[item_no]
	else
		if valtype(item_no)=="O"
			cti_return_if_fail(CTI_IS_MENUITEM(item_no))
			item := item_no
		else
			return FALSE
		endif
	endif

	if !item:is_popup(); return FALSE; endif

	if obj:__abs_left!=nil .and. obj:__abs_top!=nil
		item:__submenu:left := obj:__abs_left + item:left
		item:__submenu:top := obj:__abs_top + item:top+1
		item:__submenu:popup()
	endif
return TRUE

/* Unpopup submenu connected to item "item_no" */
static function cti_menubar_unpopup_item(obj,item_no)
	local item

	if valtype(item_no)=="N"
		cti_return_if_fail(item_no>0 .and. item_no<=obj:__item_count)
		item := obj:__items[item_no]
	else
		if valtype(item_no)=="O"
			cti_return_if_fail(CTI_IS_MENUITEM(item_no))
			item := item_no
		else
			return FALSE
		endif
	endif

	if item:is_popup()
		item:__submenu:unpopup()
		return TRUE
	endif
return FALSE

/* Event handler */
static function cti_menubar_handle_event(obj,event)
***********************************************
	local item, old := obj:__current

	if obj:__current != 0
		item := obj:__items[obj:__current]
		if item:is_popup()
			item:__submenu:__handle_event(event)
		endif
	endif

	if event:type != CTI_KEYBOARD_EVENT; return FALSE; endif

	if obj:apply_key(event:keycode)
		event:type := CTI_NOTHING_EVENT
		obj:draw_queue()
		return TRUE
	endif
return FALSE

static function cti_menubar_set_default_keys(obj)
	obj:set_key(K_HOME,  obj:first_item )
	obj:set_key(K_END,   obj:last_item  )
	obj:set_key(K_RIGHT, obj:next_item  )
	obj:set_key(K_LEFT,  obj:prev_item  )
	obj:set_key(K_ENTER, {|_obj|_obj:activate_item(_obj:__current)})
return TRUE
