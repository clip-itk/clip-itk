/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_ZORDER stores list of windows in Z(vertical) order */

/* CTI_ZORDER constructor */
function cti_zorder_new()
	local obj := map()

	obj:classname	:= "CTI_ZORDER"
	obj:__ZList	:= {}
	obj:__ObjList	:= map()

	obj:put		:= @cti_zorder_put()
	obj:remove	:= @cti_zorder_remove()
	obj:move_to_top	:= @cti_zorder_move_to_top()
	obj:len		:= @cti_zorder_len()
	obj:get_objlist	:= @cti_zorder_get_objlist()
	obj:get_top	:= @cti_zorder_get_top()
//	obj:repaint	:= @cti_zorder_repaint()
return obj

/****************************************************************/
/* Methods */

/* Adds a window and put it to top of Z-order */
static function cti_zorder_put(zorder,obj)
//	memvar app

	if .not. obj:id $ zorder:__ObjList
		aadd(zorder:__ZList, obj)
		zorder:__ObjList[obj:id] := obj:id
	else
		zorder:move_to_top(obj)
	endif

//	app:__FocusedWindow := obj
return

/* Move window to top of Z-order */
static function cti_zorder_move_to_top(zorder,obj)
	local F
//	local WasFocused

//	memvar app

	if obj:id $ zorder:__ObjList
		F := ascan(zorder:__ZList,{|x|x:id == obj:id})
		if F != 0
//			WasFocused := app:FocusedWindow
			adel(zorder:__ZList, F)
			zorder:__ZList[len(ZOrder:__ZList)] := obj
//			obj:draw_queue()
		endif
//		app:FocusedWindow := obj
//		WasFocused:draw_queue()
	endif
return

/* Remove window from Z-order */
static function cti_zorder_remove(zorder,obj)
	local F

	if obj:id $ zorder:__ObjList; adel(zorder:__ObjList,obj:id); endif

	F := ascan(zorder:__ZList,{|x|x:id == obj:id})
	if F != 0
		adel(zorder:__ZList, F)
		asize(zorder:__ZList, len(zorder:__ZList)-1)
	endif
return

/* Returns length of windows list */
static function cti_zorder_len(zorder)
return len(zorder:__ZList)

/* Returns reference to windows list */
static function cti_zorder_get_objlist(zorder)
return zorder:__ZList

/* Returns top-level window from Z-order */
static function cti_zorder_get_top(zorder)
return iif(len(zorder:__ZList)>0,atail(zorder:__ZList),nil)
