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
#include "clip-postscript.ch"

/* Class for Postscript embedded variable */

function PSVariable( name, attrs )
	local obj := map()
	
	if empty(name)
		return NIL
	endif
	
	obj:className := "PSVariable"
	obj:name  := name
	obj:attrs := attrs
	
	_recover_PSVARIABLE(obj)
return obj


function _recover_PSVARIABLE( obj )
	obj:get := @ps_get()
return obj


/* Compute and get variable value */
static function ps_get( self, printer, page )
	local v:=NIL
	
	switch lower(self:name)
		case "pagenum"
			if valtype(page) == "O"
				v := page:getNumber()
			else
				v := 0
			endif
		case "pagecount"
			v := printer:getPageCount()
		case "date"
			// TODO: format
			v := date()
		otherwise
			?? "PSVariable:get() error: unknown variable name '"+self:name+"'&\n"
	endswitch
	//?? "VARIABLE:", self:name, v, chr(10)
return v