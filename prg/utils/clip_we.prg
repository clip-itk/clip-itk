/*
    Copyright (C) 2001  ITK
    Autor   : Uri (uri@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
#include "set.ch"

local par := {}, scr, color

set translate off

//set(_SET_LOGLEVEL,5)
set translate path off

color := setcolor()
clear screen
save screen to scr
showtime(maxrow(),maxcol()-8,.f.,"0/w")
set(_SET_INSERT, .t.)
for i:= 1 to pcount()
	aadd(par, iif(at("/", param(i))>0, param(i), currdrive()+"/"+curdir()+"/"+param(i)))
next
medit(par)
wclose()
showtime()
restore screen from scr
setcolor(color)

return
/*
init procedure setmy
	set("C:", "/usr")
	set("D:", "/home")
return
*/

