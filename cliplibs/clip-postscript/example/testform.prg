/*-------------------------------------------------------------------------*/
/*   This is a part of library clip-postscript							   */
/*													                 	   */
/*   Copyright (C) 2007 by E/AS Software Foundation 					   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>						   */
/*  								 									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "../clip-postscript.ch"

/* Test program for clip-postscript library */
function main()
	local i, form, printer
	local fileName
	local params := array(0)
	local dump:=.F.
	local result:=.F.

	i := 1
	while i <= pcount()
		if param(i) == "--dump"
			dump := .T.
		elseif param(i) == "--result"
			result := .T.
		else
			aadd(params, param(i))
		endif
		i++
	enddo

	// Get fileName from parameters
	if len(params) == 0
		?? "Usage: ./testform [--dump] [--result] <form.xpl>&\n"
		CANCEL
	else
		fileName := params[1]
	endif
	
	// Open form
	form := PSForm()
	if .not. form:openFile( fileName )
		?? "Error: could not open file "+fileName+chr(10)
		CANCEL
	endif
	
	// Check if form is template
	if form:getType() == 'template'
		// Convert to template
		form := PSTemplate( form )
		
		// Fill data
		form:fill()
		
		if result
			?? form:dump()
		endif
		
	endif
	
	// Print
	printer := PSPrinter()
	if dump
		?? printer:save( form )
	else
		printer:print( form )
	endif
	
return 0


/* Function for test list */
function getView( name )
	local a:=array(0), i, p, ph
	
	if lower(name) == "contacts"
		for i:=1 to 30
			p := alltrim(str(random(10000000)))
			ph := left(p,3) + "-" + substr(p,4,2) + "-" + right(p,2)
			aadd( a, { "contact_"+ltrim(str(i)), ph }  )
		next
	endif

return a
