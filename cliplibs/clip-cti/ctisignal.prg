/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_SIGNAL - object contains information about CTI signal */

#include "cti.ch"

init procedure __cti_signal_init()
	public SignalCurrentID := 0
return

function cti_signal_new(nType)
	local obj := map()

	obj:type	:= iif(valtype(nType)=="N",nType,HASH_CTI_NO_SIGNAL)
return obj

function cti_signal_new_from_event(event)
	local sig

	cti_return_if_fail(valtype(event)=="O",nil)
	sig := cti_signal_new()
	sig:type := HASH_CTI_EVENT
	switch (event:type)
		case HASH_CTI_KEYBOARD_EVENT
		sig:event := HASH_CTI_KEYBOARD_EVENT
		sig:keyval := event:keyCode
		sig:state := event:keyState
		sig:string := ""
		sig:length := 0

		otherwise
		sig:type := event:type
		sig:event := event
	end
return sig

function cti_signal_type_by_name(signame)
	local sigtype := HASH_CTI_NO_SIGNAL
	local namehash := HashStr(upper(signame))

/*
	switch (namehash)
		case HASH_KEY_PRESSED_SIGNAL
		sigtype := HASH_CTI_KEY_PRESSED_SIGNAL
	end
*/
//return sigtype
return namehash

