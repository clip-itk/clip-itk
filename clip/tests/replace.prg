fff:="FIRST"
use test
? &fff
? alias()
? first
&fff := "4444"
? m->first, f->first, first
m->&fff := "555"
? m->first, f->first, first

replace &fff with time()
? first
?
replacep()
?
