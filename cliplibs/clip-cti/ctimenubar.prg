/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_MENUBAR - used as a main menu in which pop-up menus reside */

#include "cti.ch"
#include "ctievents.ch"
#include "ctimenubar.ch"
#include "ctimenuitem.ch"

#include "inkey.ch"

#define	SUPERCLASS	CTI_MENUSHELL

/* CTI_MENUBAR constructor */
function cti_menubar_new(top,left,width)
	local obj := cti_inherit(cti_menushell_new(),"CTI_MENUBAR")
	memvar CtiApplication

	obj:__real_draw			:= @cti_menubar_real_draw()
	obj:__handle_event		:= @cti_menubar_handle_event()
	obj:popup_item			:= @cti_menubar_popup_item()
	obj:unpopup_item		:= @cti_menubar_unpopup_item()

/*************************************************/
//	CtiApplication:put_widget(obj)
	obj:signal_connect(HASH_CTI_ACTIVATE_SIGNAL,{|_menu,_sig,_app|_app:set_focus_to_top_window()},CtiApplication)
	obj:signal_connect(HASH_CTI_ITEM_SELECTED_SIGNAL,{|_obj,_sig|_obj:popup_item(_sig:item)})
	obj:signal_connect(HASH_CTI_ITEM_DESELECTED_SIGNAL,{|_obj,_sig| ;
		iif(_sig:item:is_popup(),_sig:item:__submenu:unpopup(),nil)})
	obj:signal_connect(HASH_CTI_SET_FOCUS_SIGNAL,{|_m,_sig|_m:popup_item(_m:__current) })
	obj:signal_connect(HASH_CTI_LOST_FOCUS_SIGNAL,{|_m,_sig|_m:unpopup_item(_m:__current) })
return obj

/************************************************************/

/* Draw a menu bar */
static function cti_menubar_real_draw(obj)
	local i, item, left
	local color

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
                        item:top := obj:top
                        item:left := obj:left + left
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

        if !item:is_popup(); return FALSE; endif

	item:__submenu:unpopup()
return TRUE

/* Event handler */
static function cti_menubar_handle_event(obj,event)
***********************************************
	local not_changed := FALSE
	local item, old := obj:__current

	if obj:__current != 0
		item := obj:__items[obj:__current]
		if item:is_popup()
			item:__submenu:__handle_event(event)
		endif
	endif

	if event:type != CTI_KEYBOARD_EVENT; return TRUE; endif

	switch (event:keycode)
		case K_HOME
		obj:first_item()

		case K_END
		obj:last_item()

		case K_RIGHT
		obj:next_item()

		case K_LEFT
		obj:prev_item()

		case K_ENTER
		obj:activate_item(obj:__current)

		otherwise
		not_changed := TRUE
	end

	if not_changed
		return TRUE
	else
		event:type := CTI_NOTHING_EVENT
		obj:draw_queue()
	endif
return TRUE
