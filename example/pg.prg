#include "ctwin.ch"
#include "box.ch"
#include "abox.ch"
#include "pgch.ch"
set color to 'w+/g+'
clear screen
//@ 0, 0 say '__B_SINGLE='+__B_SINGLE

@ 1, 60 say "'"+chr(PGCH_HLINE)+chr(PGCH_LLCORNER)+chr(PGCH_LRCORNER);
	+chr(PGCH_TTEE)+chr(PGCH_RTEE)+chr(PGCH_LTEE)+chr(PGCH_BTEE);
        +chr(PGCH_ULCORNER)+chr(PGCH_URCORNER)+chr(PGCH_VLINE)+"'"
@ 2, 60 say "'"+chr(PGCH_HLINE2)+chr(PGCH_LLCORNER2)+chr(PGCH_LRCORNER2);
	+chr(PGCH_TTEE2)+chr(PGCH_RTEE2)+chr(PGCH_LTEE2)+chr(PGCH_BTEE2);
        +chr(PGCH_ULCORNER2)+chr(PGCH_URCORNER2)+chr(PGCH_VLINE2)+"'"

@ 1, 0 say 'B_SINGLE='+B_SINGLE
@ 2, 0 say 'B_DOUBLE='+B_DOUBLE
@ 1, 30 say 'AB_SINGLE='+AB_SINGLE
@ 2, 30 say 'AB_DOUBLE='+AB_DOUBLE


set color to 'g/r'
@ 4, 1, 8, 9 box B_SINGLE+""
@ 10, 1, 15, 9 box B_DOUBLE+""
set color to 'g+/r+'
@ 4, 31, 8, 39 box AB_SINGLE+""
@ 10, 31, 15, 39 box AB_DOUBLE+""

@ 0, 0 say 'WB_1='+WB_1
@ 0, 30 say 'WB_2='+WB_2

set color to 'w/b+'
x:=wopen(16,1,21,9)
wselect(x)
wbox(WB_1)
@ -1,1 say "WB_1"
?? "a1"
?? "a2"
?

x:=wopen(16,31,21,59)
wselect(x)
wbox()
//wbox(WB_2)
//@ 0, 0, 3, 9 box 2
@ 0, 0, 3, 9 box WB_2
@ -1,1 say "WB_2"
?? "a1"
?? "a2"
?

return
