/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_MENU - Place items on the top bar menu or another pop-up menu */

#include "cti.ch"

#include "inkey.ch"
#include "button.ch"
#include "box.ch"

#define	SUPERCLASS	CTI_MENUSHELL

/* CTI_MENU constructor */
function cti_menu_new(top,left,width)
	local obj := cti_inherit(cti_menushell_new(),"CTI_MENU")

	obj:width	:= 0
	obj:height	:= 0
	obj:shadow	:= TRUE

	obj:__popped	:= FALSE

	obj:__buf_frame	:= nil

	obj:__real_draw		:= @cti_menu_real_draw()
	obj:__make_buffer 	:= @cti_menu_make_buffer()
	obj:__handle_event 	:= @cti_menu_handle_event()
	obj:__set_default_keys	:= @cti_menu_set_default_keys()

	obj:__draw_frame	:= @cti_menu_draw_frame()

	obj:can_focus		:= {||FALSE}
	obj:popup		:= @cti_menu_popup()
	obj:unpopup		:= @cti_menu_unpopup()
	obj:calc_height		:= @cti_menu_calc_height()
	obj:left		:= @cti_menu_left()
	obj:right		:= @cti_menu_right()
	obj:destroy		:= @cti_menu_destroy()

/**************************************************************************/
	obj:signal_connect(HASH_CTI_ADD_SIGNAL,@cti_menu_change_size())
	obj:signal_connect(HASH_CTI_REMOVE_SIGNAL,@cti_menu_change_size())

	obj:__set_default_keys()
return obj

/************************************************************/

static function cti_menu_change_size(obj,sig)
	obj:width := max(cti_cnum(obj:width),cti_cnum(sig:child:width+4))
	obj:height := obj:calc_height()
	obj:__make_buffer()
	obj:__draw_frame()
return

static function cti_menu_popup(obj)
	memvar CtiApplication

	if .not. obj:__popped
		CtiApplication:add(obj)
		CtiApplication:move_widget_to_top(obj)
		obj:__popped := TRUE
	endif
return TRUE

static function cti_menu_unpopup(obj)
	memvar CtiApplication

//outlog(__FILE__,__LINE__,procname(),obj:name,obj:id)
	if obj:__popped
		CtiApplication:remove(obj)
		obj:__popped := FALSE
		if !empty(obj:__items) .and. obj:__items[obj:__current]:is_popup() .and. obj:__items[obj:__current]:__submenu:__popped
			obj:__items[obj:__current]:__submenu:unpopup()
		endif
	endif
return TRUE

/* Draw a popup menu */
static function cti_menu_real_draw(obj)
	local i, item
	local color, bg
	local caption
	local top,left
	/*
	top := iif(obj:__abs_top!=nil,obj:__abs_top,0)
	left := iif(obj:__abs_left!=nil,obj:__abs_left,0)
	*/
	top := iif(obj:top!=nil,obj:top,0)
	left := iif(obj:left!=nil,obj:left,0)

	winbuf_copy(obj:__buf_frame,,,,,obj:__buffer)
	top ++
	for i:=1 to obj:__item_count
		item := obj:__items[i]
		if item:__is_shown
			color := item:Palette:Menu
			if item:__caption != nil
				// Draw simple menuitem (or submenu)
				if i==obj:__current
					color := item:Palette:ActiveMenu
				endif
				caption := iif(item:__checked(),substr(item:style,1,1)," ")
				caption += padr(item:__caption,obj:width-4)
				caption += iif(item:is_popup(),substr(item:style,2,1)," ")
				winbuf_out_at(obj:__buffer,i,1,caption,color)
				if item:__accel_pos > 0
					bg := substr(color, at("/",color)+1)
					winbuf_attr_at(obj:__buffer,i,1+item:__accel_pos, ;
						i,1+item:__accel_pos,item:Palette:AccelKey+"/"+bg)
				endif
				item:top := i
				item:left := obj:left
			else
				// Draw a menu separator
				caption := substr(SEPARATOR_SINGLE,1,1)+replicate(substr(SEPARATOR_SINGLE,2,1),obj:width-2)+substr(SEPARATOR_SINGLE,3,1)
				winbuf_out_at(obj:__buffer,i,0,caption,color)
			endif
			top++
		endif
	next
return TRUE

/* Creates additional buffers for object Menu */
static function cti_menu_make_buffer(obj)
	CALL SUPER obj:__make_buffer()

	if obj:__buf_frame != nil
		winbuf_destroy(obj:__buf_frame)
	endif
	obj:__buf_frame := winbuf_create(obj:height,obj:width)

	obj:__draw_frame()
return TRUE

/* Draw menu frame */
static function cti_menu_draw_frame(obj)
	winbuf_dispbox(obj:__buf_frame,0,0,obj:height-1,obj:width-1,B_SINGLE,obj:Palette:Menu)
return TRUE

/* Calculates popup menu`s height */
static function cti_menu_calc_height(obj)
	local i, height := 0

	for i:=1 to obj:__item_count
		height += iif(obj:__items[i]:__is_shown, 1, 0)
	next
return height+2

/* Event handler */
static function cti_menu_handle_event(obj,event)
***********************************************
	local cKey, item

	if obj:__current != 0
		item := obj:__items[obj:__current]
		if item:is_popup() .and. item:__submenu:__popped
			item:__submenu:__handle_event(event)
		endif
	endif

	if event:type != CTI_KEYBOARD_EVENT; return TRUE; endif

	if obj:apply_key(event:keycode)
		event:type := CTI_NOTHING_EVENT
		obj:draw_queue()
	endif

/*
	switch (event:keycode)
		case K_HOME
		obj:first_item()
		event:type := CTI_NOTHING_EVENT

		case K_END
		obj:last_item()
		event:type := CTI_NOTHING_EVENT

		case K_DOWN
		obj:next_item()
		event:type := CTI_NOTHING_EVENT

		case K_UP
		obj:prev_item()
		event:type := CTI_NOTHING_EVENT

		case K_RIGHT
		if obj:__items[obj:__current]:is_popup() .and. !obj:__items[obj:__current]:__submenu:__popped
//			obj:__items[obj:__current]:__submenu:left := obj:__abs_left + obj:__items[obj:__current]:left + obj:__items[obj:__current]:__submenu:width - 1
			obj:__items[obj:__current]:__submenu:left := obj:__abs_left + obj:__items[obj:__current]:__submenu:width - 1
			obj:__items[obj:__current]:__submenu:top := obj:__abs_top + obj:__items[obj:__current]:top
			obj:__items[obj:__current]:__submenu:popup()
			event:type := CTI_NOTHING_EVENT
		endif

		case K_LEFT
		if obj:__items[obj:__current]:is_popup() .and. obj:__items[obj:__current]:__submenu:__popped
			obj:__items[obj:__current]:__submenu:unpopup()
			event:type := CTI_NOTHING_EVENT
		endif

		case K_ENTER
		obj:activate_item(obj:__current)
		event:type := CTI_NOTHING_EVENT

		otherwise
		not_changed := TRUE
	end

	if not_changed
		return TRUE
	else
		obj:draw_queue()
	endif
*/
return TRUE

static function cti_menu_right(obj)
	if obj:__items[obj:__current]:is_popup() .and. !obj:__items[obj:__current]:__submenu:__popped
//		obj:__items[obj:__current]:__submenu:left := obj:__abs_left + obj:__items[obj:__current]:left + obj:__items[obj:__current]:__submenu:width - 1
		obj:__items[obj:__current]:__submenu:left := obj:__abs_left + obj:__items[obj:__current]:__submenu:width - 1
		obj:__items[obj:__current]:__submenu:top := obj:__abs_top + obj:__items[obj:__current]:top
		obj:__items[obj:__current]:__submenu:popup()
		return TRUE
	endif
return FALSE

static function cti_menu_left(obj)
	if obj:__items[obj:__current]:is_popup() .and. obj:__items[obj:__current]:__submenu:__popped
		obj:__items[obj:__current]:__submenu:unpopup()
		return TRUE
	endif
return FALSE

/* Menu destructor - must destroy menu frame buffer */
static function cti_menu_destroy(obj)
	if obj:__buf_frame != nil
		winbuf_destroy(obj:__buf_frame)
		obj:__buf_frame := nil
	endif
	CALL SUPER obj:destroy()
return

static function cti_menu_set_default_keys(obj)
	obj:set_key(K_HOME,  obj:first_item )
	obj:set_key(K_END,   obj:last_item  )
	obj:set_key(K_DOWN,  obj:next_item  )
	obj:set_key(K_UP,    obj:prev_item  )
	obj:set_key(K_LEFT,  obj:left       )
	obj:set_key(K_RIGHT, obj:right      )
	obj:set_key(K_ENTER, {|_obj|_obj:activate_item(_obj:__current)})
return TRUE
