/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_MENUITEM objects are the basis for which both top bar and pop-up menus
     are built upon */

#include "cti.ch"
#include "ctimenuitem.ch"
#include "ctimenu.ch"

#define	SUPERCLASS	CTI_WIDGET

/* CTI_MENUITEM constructor */
function cti_menuitem_new(caption,shortcut,message)
	local obj := cti_inherit(cti_widget_new(),"CTI_MENUITEM")

	obj:__caption	:= nil
	obj:__shortcut	:= iif(valtype(caption)=="N",shortcut,nil)
	obj:__message	:= iif(valtype(caption)=="C",message,nil)

	obj:__checked	:= FALSE
	obj:__enabled	:= TRUE
	obj:__disabled	:= FALSE

	obj:__submenu	:= nil

	obj:__data	:= nil

	obj:style	:= chr(0x96)+chr(16)

	obj:set_caption		:= @cti_menuitem_set_caption()
	obj:get_caption		:= @cti_menuitem_get_caption()
	obj:set_data		:= @cti_menuitem_set_data()
	obj:get_data		:= @cti_menuitem_get_data()
	obj:set_submenu		:= @cti_menuitem_set_submenu()
	obj:set_enabled		:= @cti_menuitem_set_enabled()
	obj:set_disabled	:= @cti_menuitem_set_disabled()
	obj:set_checked		:= @cti_menuitem_set_checked()
	obj:is_checked		:= @cti_menuitem_is_checked()
	obj:is_popup		:= @cti_menuitem_is_popup()
	obj:is_accel		:= @cti_menuitem_is_accel()
	obj:is_enabled		:= @cti_menuitem_is_enabled()
	obj:is_disabled		:= @cti_menuitem_is_disabled()
	obj:is_selectable	:= @cti_menuitem_is_selectable()
/**********************************************************************/

	obj:set_caption(caption)
return obj

/************************************************************/

/* Returns TRUE, if menu item have a popup menu */
static function cti_menuitem_is_popup(obj)
return obj:__submenu != nil

/* Returns TRUE, if menu item have a shotrcut nKey */
static function cti_menuitem_is_accel(obj,nKey)
return FALSE

/* Returns TRUE, if menu item may be a selected */
static function cti_menuitem_is_selectable(obj)
return obj:__is_shown .and. obj:__is_enabled .and. !obj:__disabled .and. obj:__caption!=nil

/* Returns TRUE, if menu item is checked */
static function cti_menuitem_is_checked(obj)
return obj:__checked

/* Sets submenu to menu item */
static function cti_menuitem_set_submenu(obj,oSubMenu)
	cti_return_if_fail(CTI_IS_MENU(oSubMenu))
	oSubMenu:parent := obj
	obj:__submenu := oSubMenu
	obj:__submenu:signal_connect(HASH_CTI_ACTIVATE_SIGNAL,{|_submenu,_sig,_item|_item:signal_emit(_sig)},obj)
	obj:__submenu:signal_connect(HASH_CTI_DRAW_QUEUE_SIGNAL,{|_submenu,_sig,_item|_item:draw_queue()},obj)
	obj:__submenu:signal_connect(HASH_CTI_KEYBOARD_SIGNAL,{|_submenu,_sig,_item|_item:signal_emit(_sig)},obj)
return TRUE

/* Sets caption of menu item and calculate it`s width */
static function cti_menuitem_set_caption(obj,cCaption)
	obj:__caption   := iif(valtype(cCaption)=="C",cCaption,nil)

	obj:width := iif(obj:__caption!=nil,len(obj:__caption),0)
	obj:draw_queue()
return TRUE

/* Returns caption of menu item */
static function cti_menuitem_get_caption(obj,cCaption)
return obj:__caption

static function cti_menuitem_set_data(obj,data)
	obj:__data := data
return

static function cti_menuitem_get_data(obj)
return obj:__data

static function cti_menuitem_set_enabled(obj,lEnabled)
	obj:__is_enabled := lEnabled
	obj:draw_queue()
return

static function cti_menuitem_set_checked(obj,lChecked)
	obj:__checked := lChecked
	obj:draw_queue()
return

static function cti_menuitem_set_disabled(obj,lDisabled)
	obj:__disabled := lDisabled
	obj:draw_queue()
return

static function cti_menuitem_is_enabled(obj)
return obj:__is_enabled

static function cti_menuitem_is_disabled(obj)
return obj:__disabled
