parameters oIni
local tmp1,tmp2,tmp3
local hfile
tmp1 := oIni:getValue("HTTP","MOD-CACHE")
if empty(tmp1)
	return
endif
hfile := fcreate(tmp1+"/test")
fclose(hfile)
if hfile < 0
	tmp2:=space(0)
	tmp3:=space(0)
	? "mkdir ",tmp1
	syscmd("mkdir "+tmp1,@tmp2,@tmp3)
	if !empty(tmp3)
		? "Error:",tmp3
	endif
endif
return


