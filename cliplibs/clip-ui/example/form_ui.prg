/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 	           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 16 Feb 2005						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <clip-ui.ch>

#define PRGVERSION	"0.1.2.2"

static ws, win

function main( formName )
	local form
	local fileName
	
	if empty(formName)
		?? "Usage: ./form_ui <form.xfl>&\n"
		CANCEL
	else
		fileName := formName
	endif
	
	driver := "gtk"
	for i:=1 to pcount()
		if left(param(i),9) == "--driver="
			driver := substr(param(i),10)
		elseif param(i) == "-driver" .and. i+1<=pcount()
			driver := param(i+1)
		endif
	next
	
	/* Use driver for GTK+ 2.x */
	?? "Used driver: "+driver,chr(10)
	useDriver( driver )
	
	ws  := UIWorkSpace()
	
	form := UIForm( fileName )
	win  := form:parseFile()
	if win == NIL
		CANCEL
	endif
	win:show()
	
	ws:run()
	ws:quit()
return 0