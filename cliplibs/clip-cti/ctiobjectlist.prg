/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* list of all objects in CTI system. */

#include "cti.ch"

static cti_object_list_current_id := -1
static cti_object_list := map()

function cti_object_list_put(id,obj)
	cti_return_if_fail(valtype(id)=="N")

	cti_object_list[id] := obj
return TRUE

function cti_object_list_get(id)
	cti_return_if_fail(valtype(id)=="N",nil)
	cti_return_if_fail2(id $ cti_object_list,nil)
return cti_object_list[id]

function cti_object_list_del(id)
	cti_return_if_fail(valtype(id)=="N")
	cti_return_if_fail2(id $ cti_object_list)
	adel(cti_object_list,id)
return TRUE

function cti_object_list_get_new_id()
	cti_object_list_current_id ++
return cti_object_list_current_id

function cti_object_list_get_id()
return cti_object_list_current_id

function cti_object_list_for_each(bCode)
	local obj_key, aKeys := {}, i

	cti_return_if_fail(valtype(bCode)=="B")

	for obj_key in cti_object_list keys
		aadd(aKeys,obj_key)
	next

	for i:=1 to len(aKeys)
		obj_key := aKeys[i]
		if obj_key $ cti_object_list
			eval(bCode,cti_object_list[obj_key])
		endif
	next
return TRUE

function cti_object_list_destroy_all()
	local obj_key, aKeys := {}, i

	for obj_key in cti_object_list keys
		aadd(aKeys,obj_key)
	next

	for i:=1 to len(aKeys)
		obj_key := aKeys[i]
		if obj_key $ cti_object_list
			cti_object_list[obj_key]:destroy()
		endif
	next
return TRUE

function cti_object_list_clear()
	local obj_key, aKeys := {}, i

	for obj_key in cti_object_list keys
		aadd(aKeys,obj_key)
	next

	for i:=1 to len(aKeys)
		cti_object_list[aKeys[i]] := nil
		adel(cti_object_list,aKeys[i])
	next
return TRUE

