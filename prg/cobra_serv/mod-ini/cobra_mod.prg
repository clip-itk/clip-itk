parameters oIni

	local i,val, modules,mfuncs:={}
	local s,e,err,oErr,lExit:=.f.
	/* load modules */
	err := errorBlock({|e|break(e)})
	modules := oIni:keys("MODULES")
	? "Loading modules:",modules
	for i=1 to len(modules)
		val := oIni:getValue("MODULES",modules[i])
		? modules[i],val,"...."
		if empty(val) .or. valtype(val) !="C"
			?? "bad definition"
			lExit := .t.
			loop
		endif
		if ! file(val)
			?? "module not found:"
			lExit := .t.
			loop
		endif
		begin sequence
			load(val,mFuncs)
			?? "OK"
			? "Export functions:",mFuncs
		recover using oErr
			?? errorMessage(oErr)
			lExit := .t.
		end sequence
	next
	errorBlock(err)
	if lExit
		quit
	endif
return  .t.

