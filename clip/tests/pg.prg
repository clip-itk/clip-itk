*charset koi8-r
#include "ctwin.ch"
#include "box.ch"
#include "abox.ch"

clear screen
@ 1, 0 say 'B_SINGLE='+B_SINGLE
@ 2, 0 say 'B_DOUBLE='+B_DOUBLE
@ 1, 30 say 'AB_SINGLE='+AB_SINGLE
@ 2, 30 say 'AB_DOUBLE='+AB_DOUBLE

@ 4, 1, 8, 9 box B_SINGLE+""
@ 10, 1, 15, 9 box B_DOUBLE+""
@ 4, 31, 8, 39 box AB_SINGLE+""
@ 10, 31, 15, 39 box AB_DOUBLE+""

x:=wopen(16,1,21,9)
wselect(x)
wbox(x,WB_1)
@ -1,1 say "WB_1"
?? "a1"
?? "a2"
?

x:=wopen(16,31,21,39)
wselect(x)
wbox(x,WB_2)
@ -1,1 say "WB_2"
?? "a1"
?? "a2"
?

return
