/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

#include "setcurs.ch"
#include "ctievents.ch"
#include "cti.ch"
//#include "signal.ch"

static cti_mainloop_level:=0

init procedure init_cti()
	public cti_initialized:=.F.
        public lQuit:=.F.
	public EventCurrentID:=0
	public CtiApplication
	public EventHandlers := map()
return

function cti_init()
	local palette

	memvar cti_initialized, CtiApplication

	palette := cti_get_system_palette()
	_cti_events_init()

	if .not. cti_initialized
		CtiApplication := cti_application_new()
		CtiApplication:show()
		cti_initialized := .T.
	endif
return CtiApplication

function cti_main_iteration_do()
	local event, ret, evlist, i
	local signal

        memvar CtiApplication
        memvar EventHandlers

	event := cti_event_get()

	// Process event given from queue
	if event:type != CTI_NOTHING_EVENT
		if CtiApplication:__FocusedObj != nil
                        /* Process given event by focused object */
			if HASH_CTI_EVENT $ CtiApplication:__FocusedObj:__signals
				signal := cti_signal_new(HASH_CTI_EVENT)
				signal:event := event
				ret := CtiApplication:__FocusedObj:signal_emit(signal)
			endif

			if ret != TRUE
				ret := CtiApplication:__FocusedObj:__handle_event(event)
                        	ret := iif(valtype(ret)=="L",ret,FALSE)
			endif
/*
                        if ret==FALSE .and. event:type == CTI_KEYBOARD_EVENT
                        	/* Emit signal for keyboard event */
				signal := cti_signal_new(HASH_CTI_KEYBOARD_SIGNAL)
				signal:keyCode := event:keyCode
				signal:keyState := event:keyState
				CtiApplication:__FocusedObj:signal_emit(signal)
			endif
*/
		endif
	endif

	if event:type == CTI_DRAW_QUEUE_EVENT
		event:widget:draw_now()
	endif

	if event:type != CTI_NOTHING_EVENT .and. event:type $ EventHandlers
		evlist := EventHandlers[event:type]
		for i:=1 to len(evlist)
			eval(evlist[i]:handler,CtiApplication:__FocusedObj,event)
		next
	endif
return

function cti_main()
	local event:=nil
	memvar cti_initialized, lQuit

	cti_mainloop_level ++
	if cti_initialized
		do while .not. lQuit
			if cti_events_pending()
                		cti_main_iteration_do()
			else
				if .not. lQuit
                                	cti_keyb_listen(0.01)
				endif
			endif
                enddo
                cti_mainloop_level --
        	lQuit := cti_mainloop_level==0
        endif
return

function cti_quit()
	memvar cti_initialized, lQuit

	lQuit:=.T.
return
