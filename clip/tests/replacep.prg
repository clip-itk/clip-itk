? 'replacep:'
?
? &fff
? alias()
? first
&fff := "4444"
? m->first, f->first, first
m->&fff := "555"
? m->first, f->first, first
sleep(1)
? 'try replace:'
replace &fff with time()
? first
?
