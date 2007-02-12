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

#define PSFDEBUG	.F.

/** PSForm - Class for XPL form */
function PSForm()
	local obj := map()
	
	obj:className := "PSForm"
	obj:oXml := NIL
	obj:root := NIL
	
	_recover_PSFORM(obj)
return obj


function _recover_PSFORM(obj)
	obj:openFile	:= @ps_openFile()
	obj:openStream	:= @ps_openStream()
	obj:getType		:= @ps_getType()
	obj:dump		:= @ps_dump()
	obj:print		:= @ps_print()
	obj:save		:= @ps_save()
return obj


/* Open XPL form from file */
static function ps_openFile( self, fileName )
	
	if PSFDEBUG
		?? "PSForm: file parsing...&\n"
	endif
	// Parse file
	self:oXml := XMLTree()
	if .not. self:oXml:parseFile( fileName )
		?? "ERROR: Cannot open form file '"+fileName+"': "+self:oXml:getError()+chr(10)
		return .F.
	endif
	if PSFDEBUG
		?? "PSForm: file parsing complete&\n"
	endif
	
	self:root := self:oXml:getRoot()

return .T.


/* Open XPL template from string */
static function ps_openStream( self, str )
	if PSFDEBUG
		?? "PSForm: string parsing...&\n"
	endif
	// Parse string
	self:oXml := XMLTree()
	if .not. self:oXml:parseString( str )
		?? "ERROR: Cannot open form file: "+self:oXml:getError()+chr(10)
		return .F.
	endif

	if PSFDEBUG
		?? "PSForm: string parsing complete&\n"
	endif

	self:root := self:oXml:getRoot()

return .T.


/* Get type of opened form */
static function ps_getType( self )
	local t:='', tt
	
	if valtype(self:root)=='O'
		tt := lower(self:root:attribute('type',''))
		if tt=='template' .or. tt=='form'
			t := tt
		else
			t := 'form'
		endif
	endif
return t


/* Dump filled form to XML string */
static function ps_dump( self )
return iif( empty(self:root), '', self:oXml:dump() )


/* Print form on default printer */
static function ps_print( self, viewer, file )
	local pr := PSPrinter()
return pr:print( self, viewer, file )


/* Save generated PostScript for form to file or steam */
static function ps_save( self, file )
	local pr := PSPrinter()
return pr:save( self, file )
