//proc browse
local lappend

set('DBF_CHARSET', 'cp866')
use test
test_num = RECNO()
test_name = last
LOCATE FOR last = test_name .AND. RECNO() <> test_num
inkey(0)
lAppend := .F.
//ob:=map()
//oB:skipBlock :=
//{|x| Skipped(x, lAppend)}
cb:={|| lAppend}
? lAppend
? cb
? eval(cb)
?
return
