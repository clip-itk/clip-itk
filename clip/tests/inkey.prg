#include "set.ch"

procedure main
clear screen
//showtime(0,maxcol()-8,.f.,"0/w")
? set(_SET_ESC_DELAY,99)
? "Press key or ESC"
nkey:=0
while nkey !=27
	nkey:=inkey(0,255)
	? nkey,'"'+chr(nkey)+'"', kbdstat(), isbit(kbdstat(),18), isbit(kbdstat(),17)
end
?
return

