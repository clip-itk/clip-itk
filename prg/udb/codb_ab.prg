/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "set.ch"
#include "debug.ch"

local ddd, ret, nkey
parameters par1,par2

       clear screen
       set deleted on
	showtime(0,maxcol()-8,.f.,"0/w")
       ddd:=abNew(par1,par2)
       do while .t.
		nkey:=inkey(0)
		ret=ddd:handleKey(nkey)
		if ret==0
		   exit
		endif
       enddo
	showtime()
       ? "Good bye"
       ?

return
