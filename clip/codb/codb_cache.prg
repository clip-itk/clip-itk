/*
    Copyright (C) 2003  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* Virtual metods for CODB object over DBF files */

#include "codbcfg.ch"

#ifndef __1
static data
/***********************************/
function codb_CacheAdd(obj_id,obj)
	local k:=cton(right(obj_id,1),32)+1
	__check_data()
	if obj_id $ data[k]
		return
	endif
	data[k][obj_id] := obj
	if len(data[k]) > CODB_PUBLIC_CACHE
		codb_cache_minimize(data[k], CODB_PUBLIC_CACHE/4 )
	endif
return
/***********************************/
function codb_CacheGet(obj_id)
	local k:=cton(right(obj_id,1),32)+1
	__check_data()
	if obj_id $ data[k]
		return data[k][obj_id]
	endif
return NIL
/***********************************/
function codb_CacheDel(obj_id)
	local k:=cton(right(obj_id,1),32)+1
	__check_data()
	if obj_id $ data[k]
		adel(data[k],obj_id)
	endif
return
/***********************************/
function codb_CacheDestroy()
	local i
	for i=1 to len(data)
		afill(data[i],NIL)
	next
	data := NIL
return

/***********************************/
static function	__check_data()
	local i,m
	if data==NIL
		data := {}
		for i=1 to 32
			m := map()
			aadd(data,m)
			m:=NIL
		next
	endif
return

/***********************************/
/***********************************/
/***********************************/

#else
static data:=map()

/***********************************/
function codb_CacheAdd(obj_id,obj)
	if obj_id $ data
		return
	endif
	data[obj_id] := obj
	if len(data) > CODB_PUBLIC_CACHE*16
		codb_cache_minimize(data, CODB_PUBLIC_CACHE/2 )
	endif
return

/***********************************/
function codb_CacheGet(obj_id)
	if obj_id $ data
		return data[obj_id]
	endif
return NIL

/***********************************/
function codb_CacheDel(obj_id)
	if obj_id $ data
		adel(data,obj_id)
	endif
return
/***********************************/
function codb_CacheDestroy()
	afiil(data,NIL)
	data := map()
return
#endif
