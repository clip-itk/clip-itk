/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_ZORDER stores list of widgetss in Z(vertical) order */

#include "cti.ch"

/* CTI_ZORDER constructor */
function cti_zorder_new()
	local obj := map()

	obj:classname	:= "CTI_ZORDER"
	obj:__ZList	:= {}
	obj:__ObjList	:= map()

	obj:add		:= @cti_zorder_add()
	obj:remove	:= @cti_zorder_remove()
	obj:move_to_top	:= @cti_zorder_move_to_top()
	obj:len		:= {|_zorder|len(_zorder:__ZList)}
	obj:get_objlist	:= {|_zorder|_zorder:__ZList}
	obj:get_top	:= {|_zorder|iif(len(_zorder:__ZList)>0,atail(_zorder:__ZList),nil)}
return obj

/****************************************************************/
/* Methods */

/* Adds a widget and add it to top of Z-order */
static function cti_zorder_add(zorder,obj)
	if .not. obj:id $ zorder:__ObjList
		aadd(zorder:__ZList, obj)
		zorder:__ObjList[obj:id] := obj:id
	else
		zorder:move_to_top(obj)
	endif
return

/* Move widget to top of Z-order */
static function cti_zorder_move_to_top(zorder,obj)
	local F, l

	if .not. obj:id $ zorder:__ObjList
		return FALSE
	endif

	if atail(zorder:__ZList):id != obj:id
		F := ascan(zorder:__ZList,{|x|x:id == obj:id})
		if F != 0
			adel(zorder:__ZList, F)
			zorder:__ZList[len(ZOrder:__ZList)] := obj
//			atail(zorder:__ZList) := obj
		endif
	endif
return TRUE

/* Remove widget from Z-order */
static function cti_zorder_remove(zorder,obj)
	local F

	if obj:id $ zorder:__ObjList
		adel(zorder:__ObjList,obj:id)
	else
		return FALSE
	endif

	F := ascan(zorder:__ZList,{|x|x:id == obj:id})
	if F != 0
		adel(zorder:__ZList, F)
		asize(zorder:__ZList, len(zorder:__ZList)-1)
	endif
return TRUE
