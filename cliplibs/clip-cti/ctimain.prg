/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

#include "set.ch"
#include "setcurs.ch"
#include "cti.ch"

static cti_mainloop_level:=0
static cti_initialized := FALSE
static cti_lquit := FALSE

static cti_init_funcs_id := 0
static cti_init_funcs

static cti_idle_funcs_id := 0
static cti_idle_funcs

function cti_init()
	public EventCurrentID:=0
	public CtiApplication := nil
	public EventHandlers := map()

	_cti_events_init()

	if .not. cti_initialized
		CtiApplication := cti_application_new()
		CtiApplication:show()
		cti_initialized := TRUE
		set(_SET_ESC_DELAY,10)
	endif

	cti_init_funcs := map()
	cti_idle_funcs := map()

return CtiApplication

function cti_idle_add(bFunc,xParam)
	cti_return_if_fail(valtype(bFunc)=="B", -1)

	cti_idle_funcs_id ++
	cti_idle_funcs[cti_idle_funcs_id] := {bFunc,xParam}
return cti_idle_funcs_id

function cti_idle_remove(id)
	cti_return_if_fail(valtype(id)=="N")

	if id $ cti_idle_funcs
		cti_idle_funcs[id] := nil
		adel(cti_idle_funcs, id)
	else
		return FALSE
	endif
return TRUE

function cti_main_iteration_do()
	local event, ret, evlist, i
	local signal

	memvar CtiApplication
	memvar EventHandlers

	event := cti_event_get()

//outlog(__FILE__,__LINE__,procname(),"event:type",event:type,CTI_DRAW_QUEUE_EVENT)
	// Process event given from queue
	if event:type != CTI_NOTHING_EVENT
		if CtiApplication:__focus_widget != nil
			/* Process given event by focused object */
			if HASH_CTI_EVENT $ CtiApplication:__focus_widget:__signals
				signal := cti_signal_new_from_event(event)
				ret := CtiApplication:__focus_widget:signal_emit(signal)
			endif
/*
			if ret != TRUE
				ret := CtiApplication:__focus_widget:__handle_event(event)
				ret := iif(valtype(ret)=="L",ret,FALSE)
			endif

			if ret==FALSE .and. event:type == CTI_KEYBOARD_EVENT
				/* Emit signal for keyboard event */
				signal := cti_signal_new(HASH_CTI_KEYBOARD_SIGNAL)
				signal:keyCode := event:keyCode
				signal:keyState := event:keyState
				CtiApplication:__FocusedObj:signal_emit(signal)
			endif
*/
		endif
		if ret != TRUE
			ret := CtiApplication:__handle_event(event)
			ret := iif(valtype(ret)=="L",ret,FALSE)
		endif
	endif

	switch (event:type)
		case CTI_DRAW_QUEUE_EVENT
		event:widget:draw_now()

		case CTI_REPAINT_QUEUE_EVENT
		if !event:widget:__frozen
			event:widget:repaint_real()
		endif
	end

	if event:type != CTI_NOTHING_EVENT .and. event:type $ EventHandlers
		evlist := EventHandlers[event:type]
		for i:=1 to len(evlist)
			eval(evlist[i]:handler,CtiApplication:__focus_widget,event)
		next
	endif
return

function cti_main()
	local event:=nil, f
	local keycode

	cti_return_if_fail(cti_initialized)

	cti_mainloop_level ++

	if cti_mainloop_level == 1
		for f in cti_init_funcs
			eval(f[1],f[2])
		next

		for f in cti_init_funcs keys
			cti_init_funcs[f] := nil
		next

		cti_init_funcs := nil
	endif

	if cti_initialized
		do while .not. cti_lquit
			if cti_events_pending()
				cti_main_iteration_do()
			else

				if .not. cti_lquit
					cti_keyb_listen(0.02)
				endif

				for f in cti_idle_funcs
					eval(f[1],f[2])
				next

			endif
		enddo
		cti_mainloop_level --
		cti_lquit := cti_mainloop_level==0
	endif

//	cti_object_list_destroy_all()
return

function cti_main_level()
return cti_mainloop_level

function cti_quit()
	cti_lquit:=TRUE
return
