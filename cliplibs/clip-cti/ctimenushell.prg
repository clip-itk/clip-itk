/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* A CTI_MENUSHELL is the abstract base class used to derive the CTI_MENU and
   CTI_MENUBAR subclasses.
   A CTI_MENUSHELL is a container of CTI_MENUITEM objects arranged in a list
   which can be navigated, selected, and activated by the user to perform
   application functions. A CTI_MENUITEM can have a submenu associated with it,
   allowing for nested hierarchical menus. */

#include "cti.ch"
#include "ctimenushell.ch"
#include "ctimenuitem.ch"

#define	SUPERCLASS	CTI_WIDGET

/* CTI_MENUSHELL constructor */
function cti_menushell_new(top,left,width)
	local obj := cti_inherit(cti_widget_new(),"CTI_MENUSHELL")

	obj:__current	:= 0
	obj:__item_count:= 0

	obj:__activated	:= FALSE

	obj:__items	:= {}

	obj:activate	:= @cti_menushell_activate()
	obj:deactivate	:= @cti_menushell_deactivate()

	obj:add_item	:= @cti_menushell_add_item()
	obj:del_item	:= @cti_menushell_del_item()
	obj:ins_item	:= @cti_menushell_ins_item()

	obj:activate_item	:= @cti_menushell_activate_item()

	obj:select_item	:= @cti_menushell_select_item()
	obj:first_item	:= @cti_menushell_first_item()
	obj:last_item	:= @cti_menushell_last_item()
	obj:next_item	:= @cti_menushell_next_item()
	obj:prev_item	:= @cti_menushell_prev_item()
return obj

/************************************************************/

/* Adds an item at end of menu */
static function cti_menushell_add_item(obj,item)
	local sig
	cti_return_if_fail(CTI_IS_MENUITEM(item))

	aadd(obj:__items, item)
	item:parent := obj
	obj:__item_count++
	item:signal_connect(HASH_CTI_ACTIVATE_SIGNAL,{|_item,_sig,_menu|_menu:signal_emit(_sig)},obj)
	item:signal_connect(HASH_CTI_DRAW_QUEUE_SIGNAL,{|_item,_sig,_menu|_menu:draw_queue()},obj)
	item:signal_connect(HASH_CTI_KEYBOARD_SIGNAL,{|_item,_sig,_menu|_menu:signal_emit(_sig)},obj)

	sig := cti_signal_new(HASH_CTI_ADD_SIGNAL)
	sig:child := item
	obj:signal_emit(sig)
	if obj:__current == 0
		obj:select_item(1)
	endif
return obj:__item_count

/* Inserts an item into menu at position nPos */
static function cti_menushell_ins_item(obj,item,nPos)
	local sig
	cti_return_if_fail(CTI_IS_MENUITEM(item))

	if obj:__item_count == 0
		return obj:add_item(item)
	endif
	obj:__item_count++
	aadd(obj:__items, nil)
	ains(obj:__items, nPos)
	obj:__items[nPos] := item
	item:signal_connect(HASH_CTI_ACTIVATE_SIGNAL,{|_item,_sig,_menu|_menu:signal_emit(cti_signal_new(HASH_CTI_ACTIVATE_SIGNAL))},obj)
	item:signal_connect(HASH_CTI_DRAW_QUEUE_SIGNAL,{|_item,_sig,_menu|_menu:draw_queue()},obj)
	item:signal_connect(HASH_CTI_KEYBOARD_SIGNAL,{|_item,_sig,_menu|_menu:signal_emit(_sig)},obj)

	sig := cti_signal_new(HASH_CTI_ADD_SIGNAL)
	sig:child := item
	obj:signal_emit(sig)
return nPos

/* Deletes an item from menu by number */
static function cti_menushell_del_item(obj,nItem)
	local sig

	if nItem == obj:__current
		if .not. obj:next_item()
			obj:prev_item()
		endif
	endif

	sig := cti_signal_new(HASH_CTI_REMOVE_SIGNAL)
	sig:child := obj:__items[nItem]

	adel(obj:__items, nItem)
	obj:__item_count--
	asize(obj:__items,obj:__item_count)

	obj:signal_emit(sig)
return nItem

/* Activates a menu */
static function cti_menushell_activate(obj)
	obj:__activated := TRUE
return TRUE

/* Deactivates a menu */
static function cti_menushell_deactivate(obj)
	obj:__activated := FALSE
return TRUE

/* Selects an item by it`s number and emits suitable signals */
static function cti_menushell_select_item(obj,nItem)
	local old := obj:__current
	local sig

	if nItem>0 .and. nItem<=obj:__item_count .and. nItem!=obj:__current
		if old != 0
			sig := cti_signal_new(HASH_CTI_ITEM_DESELECTED_SIGNAL)
			sig:item := obj:__items[old]
			sig:item_no := old
			obj:__items[old]:signal_emit(cti_signal_new(HASH_CTI_DESELECT_SIGNAL))
			obj:signal_emit(sig)
		endif
		obj:__current := nItem
		obj:__items[nItem]:signal_emit(cti_signal_new(HASH_CTI_SELECT_SIGNAL))
		sig := cti_signal_new(HASH_CTI_ITEM_SELECTED_SIGNAL)
		sig:item := obj:__items[nItem]
		sig:item_no := nItem
		obj:signal_emit(sig)
	endif
return obj:__current

/* Activates an item and emits signal */
static function cti_menushell_activate_item(obj,nItem)
	if nItem > 0 .and. nItem <= obj:__item_count
		obj:__items[nItem]:signal_emit(cti_signal_new(HASH_CTI_ACTIVATE_SIGNAL))
		return TRUE
	endif
return FALSE

/* Selects a first selectable menu item */
static function cti_menushell_first_item(obj)
	local i

	for i:=1 to obj:__item_count
		if obj:__items[i]:is_selectable()
			obj:select_item(i)
			exit
		endif
	next
return obj:__current

/* Selects a last selectable menu item */
static function cti_menushell_last_item(obj)
	local i, item

	for i:=obj:__item_count to 1 step -1
		if obj:__items[i]:is_selectable()
			obj:select_item(i)
			exit
		endif
	next
return obj:__current

/* Selects a next selectable menu item */
static function cti_menushell_next_item(obj)
	local i, si, item

	if obj:__current == obj:__item_count
		si := 1
	else
		si := obj:__current + 1
	endif

	for i:=si to obj:__item_count
		if obj:__items[i]:is_selectable()
			obj:select_item(i)
			exit
		endif
	next
return obj:__current

/* Selects a next selectable menu item */
static function cti_menushell_prev_item(obj)
	local i,si, item

	if obj:__current == 1
		si := obj:__item_count
	else
		si := obj:__current-1
	endif

	for i:=si to 1 step -1
		if obj:__items[i]:is_selectable()
			obj:select_item(i)
			return i
		endif
	next
return obj:__current
