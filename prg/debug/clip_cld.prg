/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "set.ch"
#include "debug.ch"

parameters par1,par2

	local script_file, prog_name, ddd
        //set(_SET_LOGLEVEL,5)

	set translate off

	if !empty(par1) .and. ("@" $ par1)
   		script_file:=substr(par1,2)
   		prog_name:=par2
	endif
	if !empty(par2) .and. ("@" $ par2)
   		script_file:=substr(par2,2)
   		prog_name:=par1
	endif
	if script_file==NIL .or. empty(script_file)
   		script_file="init"
	endif
  	setcolor(set("debug_colors"))
	ddd:=debugNew()

        ddd:statusLine([Loading script file])
        ddd:run("input "+script_file)
        ddd:statusLine([Esc-menu F1-help CtrlU-switch panels AltX-exit Alt0-list windows])

       do while .t.
                ret=ddd:handleKey(inkey(0))
                if ret==0
                   exit
                endif
       enddo
       ? "Good bye"
       ?

return
