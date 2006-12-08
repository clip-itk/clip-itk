/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*									   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 		   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <clip-ui.ch>

#define PRGVERSION	"0.1.2.4"

static ws, win

function main()
	local i,form
	local fileName,driver
	local params := array(0)

	driver := "gtk2"
	i := 1
	while i <= pcount()
		if left(param(i),9) == "--driver="
			driver := substr(param(i),10)
		elseif param(i) == "-driver" .and. i+1<=pcount()
			driver := param(i+1)
			i += 2
			loop
		else
			aadd(params, param(i))
		endif
		i++
	enddo

	// Get fileName from parameters
	if len(params) == 0
		?? "Usage: ./form_ui [--driver=<DRIVER>] <form.xfl>&\n"
		CANCEL
	else
		fileName := params[1]
	endif

	/* Use driver for GTK+ 2.x */
	?? "Used driver: "+driver,chr(10)
	useDriver( driver )

	ws  := UIWorkSpace( params )

	form := UIForm( fileName )
	win  := form:parseFile()
	if win == NIL
		CANCEL
	endif
	win:show()

	ws:run()
	ws:quit()
return 0

function openForm( obj, filename, action )
	local f, w
	if valtype(obj) != 'O'
		return NIL
	endif
	
	f := UIForm( filename, obj )
	w := f:parseFile()
	w:returnAction := action
	
	if w == NIL
		return NIL
	endif
	w:show()
	
return NIL

function showValues()
	local a, i
	a := win:getValues()
	for i in a
		if valtype(i[2]) == 'A'
			?? "    "+i[1]+" = ",i[2],chr(10)
		else
			?? "    "+i[1]+" = "+val2str(i[2]),chr(10)
		endif
	next
return

function getAttributeValue(name)
return ''
