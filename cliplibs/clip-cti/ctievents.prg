/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

#include "ctievents.ch"
#include "cti.ch"

static evQueue
static kbstat

/* Initialize events - create events queue */
procedure _cti_events_init()
	evQueue := QueueNew()
	kbstat := kbdstat()
	//start(@keyb_listen())
return

/* Extract one event from events queue */
function cti_event_get()
	local event
	memvar evQueue

	event := cti_event_peek()
	evQueue:get()
return event

/* Take one event from events queue without extracting it*/
function cti_event_peek()
	local event:=nil
	memvar evQueue

	if .not. evQueue:empty()
		event:=evQueue:head()
	endif
return iif(event!=nil,event,cti_event_new())

/* Gets one event from keyboard */
procedure cti_keyb_listen(Delay)
	memvar evQueue, kbstat
	local keycode, scan_code
	local Event

//	do while .T.
//		scan_code := scankey()
//outlog("scankey=",scan_code)
		keycode := inkey(Delay)
		if keycode != 0
			kbstat:=kbdstat()
			Event := cti_event_new(CTI_KEYBOARD_EVENT)
			Event:keyCode := keycode
			Event:keyState := kbdstat()
			evQueue:put(Event)
		endif
//	enddo
return

function cti_event_put(event)
	memvar evQueue
	cti_return_if_fail(valtype(event)=="O" .and. event:classname=="CTI_EVENT")
        evQueue:put(Event)
return TRUE

/* Create event */
function cti_event_new(eventType,code,state)
	local obj:=map()

        obj:classname := "CTI_EVENT"
	eventType := iif(valtype(eventType)=="N",eventType,CTI_NOTHING_EVENT)
	obj:Type := eventType
return obj

/* Returns TRUE if events queue is not empty */
function cti_events_pending()
	memvar evQueue
return .not. evQueue:empty()

function cti_event_type_by_name(evname)
	local evtype := CTI_NOTHING_EVENT
	local namehash := HashStr(upper(evname))

/*
	switch (namehash)
		case HASH_KEYBOARD_EVENT
		evtype := CTI_KEYBOARD_EVENT

		case HASH_MOUSE_EVENT
		evtype := CTI_MOUSE_EVENT
	end
*/
	evtype:=namehash
return evtype

/* Connects system-wide event handler */
function cti_event_connect(EvType,EvHandler)
	local evinfo := map()
	local E_Type
	memvar EventCurrentID
	memvar EventHandlers

	E_Type := iif(valtype(EvType)=="C",cti_event_type_by_name(EvType),EvType)
//	E_Type := EvType

	if .not. E_Type $ EventHandlers
		EventHandlers[E_Type] := {}
	endif
	evinfo:handler	:= EvHandler
	evinfo:id	:= ++EventCurrentID
	aadd(EventHandlers[E_Type],evinfo)
return evinfo:id
