static on_tick_enable := .f.
static on_tick_block := {||}
static on_tick_period := 99999999

function ft_ontick(xData, nTicks)
	on_tick_enable := .f.
	on_tick_block := {||}
	on_tick_period := 99999999
	if pcount() != 2 .or. nTicks <= 0
		return
	endif
	if valtype(xData) == "C"
		on_tick_block := &("{||"+xData+"()}")
	elseif valtype(xData) == "B"
		on_tick_block := xData
	else
		return
	endif
	on_tick_enable := .t.
	on_tick_period := (1/18.2 * nTicks)

	start( {||run_ontick()} )
return

static function run_ontick()
	while on_tick_enable
		eval(on_tick_block)
		sleep(on_tick_period)
	end
return
