/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_OBJECT - virtual object, all other objects inherits from it. */

#include "cti.ch"

/* CTI_OBJECT constructor */

function cti_object_new()
	local obj

	obj := cti_inherit(map(),"CTI_OBJECT")

//	obj:classname	:= ":CTI_OBJECT:"
//	obj:__genealogy	:= obj:classname
//	obj:name	:= obj:classname
	obj:id		:= cti_object_list_get_new_id()
//	obj:parent	:= nil
	obj:parent_id	:= nil

	cti_object_list_put(obj:id, obj)

	obj:__signals	:= map()
	obj:__signals_after := map()
	obj:__signals_internal := map()

	obj:__handle_event	:= {||TRUE}
	obj:__signal_emit_real	:= @cti_object___signal_emit_real()

	obj:signal_emit		:= @cti_object_signal_emit()

	obj:signal_connect	:= {|_obj,SigType,SigHandler,ConnectedObj| ;
		_obj:__signal_connect_real(SigType,ConnectedObj,SigHandler,FALSE)}

	obj:signal_connect_after:= {|_obj,SigType,SigHandler,ConnectedObj| ;
		_obj:__signal_connect_real(SigType,ConnectedObj,SigHandler,TRUE)}

	obj:__signal_connect_internal:= @cti_object_signal_connect_internal()
	obj:__signal_connect_real:= @cti_object_signal_connect_real()

	obj:set_name		:= @cti_object_set_name()

	obj:destroy		:= @cti_object_destroy()
return obj

/**********************************************************************/
static function cti_object___signal_emit_real(obj,SigHandler,Signal,ConnectedObj)
//	if valtype(SigHandler)=="B"
		return eval(SigHandler,obj,Signal,ConnectedObj)
//	endif
return nil

/**********************************************************************/
/* Methods */

/* Invoke all signal handlers for object "obj" */
static function cti_object_signal_emit(obj,signal)
	local i, ret := TRUE
	local siglist

	cti_return_if_fail(valtype(signal) $ "ONC")
	if valtype(signal)=="N"
		signal:=cti_signal_new(signal)
	endif
	if valtype(signal)=="C"
		signal:=cti_signal_new(cti_signal_type_by_name(signal))
	endif

	/* Process first signals queue */
	if signal:type $ obj:__signals
		siglist := obj:__signals[signal:type]
		for i:=1 to len(siglist)
//			obj:__signal_emit_real(siglist[i]:handler,signal,siglist[i]:connected_obj)
			ret := eval(siglist[i]:handler,obj,signal,siglist[i]:connected_obj)
			if signal:type == HASH_CTI_EVENT .and. ret==TRUE
				return ret
			endif
		next
	endif

	/* Let widget to do any actions */
	if signal:type $ obj:__signals_internal
		siglist := obj:__signals_internal[signal:type]
		for i:=1 to len(siglist)
			ret := eval(siglist[i],obj)
		next
	endif

	/* Process second signals queue (after) */
	if signal:type $ obj:__signals_after
		siglist := obj:__signals_after[signal:type]
		for i:=1 to len(siglist)
//			obj:__signal_emit_real(siglist[i]:handler,signal,siglist[i]:connected_obj)
			ret := eval(siglist[i]:handler,obj,signal,siglist[i]:connected_obj)
		next
	endif
return valtype(ret)=="L" .and. ret

static function cti_object_signal_connect_internal(obj,SigType,SigHandler)
	local S_Type

	cti_return_if_fail(valtype(SigHandler)=="B")

	if .not. SigType $ obj:__signals_internal
		obj:__signals_internal[SigType] := {}
	endif
	aadd(obj:__signals_internal[SigType],SigHandler)
return TRUE

/* Real connection signal handler to object */
static function cti_object_signal_connect_real(obj,SigType,ConnectedObj,SigHandler,lAfter)
	local siginfo := map()
	local S_Type := SigType
	memvar SignalCurrentID

	if valtype(SigHandler)!="B"
		cti_return_if_fail(valtype(SigHandler)=="B",-1)
	endif

//	S_Type := iif(valtype(SigType)=="C",cti_signal_type_by_name(SigType),SigType)

	siginfo:handler := SigHandler
	siginfo:id	:= ++SignalCurrentID
	siginfo:connected_obj	:= ConnectedObj

	if .not. lAfter
		if .not. S_Type $ obj:__signals
			obj:__signals[S_Type] := {}
		endif
		aadd(obj:__signals[S_Type],siginfo)
	else
		if .not. S_Type $ obj:__signals_after
			obj:__signals_after[S_Type] := {}
		endif
		aadd(obj:__signals_after[S_Type],siginfo)
	endif
return siginfo:id

/* Destructor */
static function cti_object_destroy(obj)
	obj:signal_emit(cti_signal_new(HASH_CTI_DESTROY_SIGNAL))

	obj:parent_id:=nil
	cti_object_list_del(obj:id)
	obj:id := -1
return

/* Sets name of object */
static function cti_object_set_name(obj,name)
	cti_return_if_fail(valtype(name)=="C")
	obj:name := name
return TRUE

/************************************************************/
