#include "abx.ch"

static EvQueue
static EvHandlers
static handle_descr_ev

static cur_ev_descr

#define	I_DESCRIPTOR		1
#define I_HANDLER		2

function abx_events_init()
	EvQueue := QueueNew()
	EvHandlers := map()

	cur_ev_descr := 1
	handle_descr_ev := map()
return TRUE

function abx_event_put(Ev)
	if valtype(Ev) == "N"
		EvQueue:Put(abx_event_new(Ev))
	else
		if valtype(Ev) == "O"
			EvQueue:Put(Ev)
		else
			return FALSE
		endif
	endif
return TRUE

function abx_event_get()
return EvQueue:Get()

function abx_event_add_handler(EvType,Handler)
	local EvInfo

	if valtype(Handler) != "B"
		return -1
	endif

	if ! EvType $ EvHandlers
		EvHandlers[EvType] := {}
	endif

	EvInfo := {nil,nil}
	EvInfo[I_DESCRIPTOR] := cur_ev_descr
	EvInfo[I_HANDLER] := Handler
	aadd(EvHandlers[EvType], EvInfo)
	handle_descr_ev[cur_ev_descr] := EvType
return cur_ev_descr

function abx_event_del_handlers(EvType)
	local i, L, evinfo

	if .not. EvType $ EvHandlers
		return FALSE
	endif

	L := len(EvHandlers[EvType])
	for i:=1 to L
		evinfo := EvHandlers[EvType][i]
		adel(handle_descr_ev, evinfo[I_DESCRIPTOR])
	next
	adel(EvHandlers, EvType)
return TRUE

function abx_event_del_handler(EvDescr)
	local i,L, evinfo, EvType

	if .not. EvDescr $ handle_descr_ev
		return FALSE
	endif

	EvType := handle_descr_ev[EvDescr]

	if .not. EvType $ EvHandlers
		return FALSE
	endif

	L := len(EvHandlers[EvType])
	for i:=1 to L
		evinfo := EvHandlers[EvType][i]
		if evinfo[I_DESCRIPTOR] == EvDescr
			adel(EvHandlers[EvType],i)
			asize(EvHandlers[EvType],L-1)
			adel(handle_descr_ev, evinfo[I_DESCRIPTOR])
			return TRUE
		endif
	next
return TRUE

function abx_do_event(oEvent)
	local EvList, i

	if valtype(oEvent) != "O"
		return FALSE
	endif

	if oEvent:type $ EvHandlers
		EvList := EvHandlers[oEvent:type]
	endif

	for i := 1 to len(EvList)
		eval(EvList[i,I_HANDLER],oEvent)
	next

return TRUE

function abx_run_queue()
	local Ev

	Ev := abx_event_get()
	if Ev != nil
		abx_do_event(Ev)
	endif
return

function abx_event_new(EvType)
	local oEvent := map()

	oEvent:type := 0
	if valtype(EvType) == "N"
		oEvent := map()
		oEvent:type := EvType
	endif
return oEvent
