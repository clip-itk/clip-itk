/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003,2004 by E/AS Software Foundation 	           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 16 Dec 2004						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <clip-ui.ch>

#define PRGVERSION	"0.1.1"

static ws, win
static driver := getDriver()

function main( formName )
	local form
	local fileName
	
	if empty(formName)
		?? "Usage: ./form_ui <form.xfl>&\n"
		CANCEL
	else
		fileName := formName
	endif
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