/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   				   */
/*																		   */
/*   Copyright (C) 2003-2006 by E/AS Software Foundation 				   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>						   */
/*   																	   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"
#include "var.ch"

static currentDriver := NIL
static currentDriverName := DEFAULT_DRIVER

/* Useful functions */

/* Driver choose */
function useDriver( name )
	currentDriverName := name
return

/* Connect driver */
function getDriver( name, params )
	local drv_file, drv_get

	if .not. empty(currentDriver)
		return currentDriver
	endif

	if empty(name)
		name := currentDriverName
	endif

	drv_file := DRIVERSDIR + '/driver-' + name + '.po'
	//?? "Loading",drv_file,"...&\n"
	if file( drv_file )
		load( drv_file )
	else
		?? "ERROR: No driver file '"+drv_file+"'&\n"
		CANCEL
		return NIL
	endif

	drv_get  := upper("get"+name+"Driver")
	//?? "Run",drv_get,"...&\n"
	if isfunction( drv_get )
		currentDriver := clip( drv_get )
		return currentDriver
	endif
	?? "ERROR: No function '"+drv_get+"'&\n"
	CANCEL
return NIL

/* Safe retrieve value from map */
function mapget( m, key, defVal )
	local ret := defVal
	if valtype(m)=="O" .and. key $ m
		ret := m[key]
	endif
return ret

/* Parse geometry (one, two or four parameters separated by ',') */
function splitGeom( str, alen )
	local a, i, fill := NIL
	a := split(str, ",")
	if valtype(alen) != "N" .or. alen < 1
		return {}
	endif
	if len(a) == 1 .and. valtype(a[1]) == "C"
		fill := val(a[1])
	endif
	if len(a) < alen
		asize( a, alen )
	endif
	for i=1 to len(a)
		if valtype(a[i]) == "C"
			a[i] := val(a[i])
		endif
		if fill != NIL
			a[i] = fill
		endif
	next
return a

/* Get library version */
function getClipUIVersion()
return lib_version

function val2str( value, format )
	local dec
	switch valtype(value)
		case 'N'
			// TODO: value type transformation
			dec := iif(value-int(value)>0,2,NIL)
			value := alltrim(str(value,15,dec))
		case 'C'
			value := value
		case 'D'
			value := dtoc(value, "dd.mm.yyyy")
		case 'L'
			value := iif(value,"true","false")
		case 'U'
			value := ""
		otherwise
			value := ""
	endswitch
return value

/* Fill i18n map for current locale from XFL/XPL forms
	parent	parent tag
	locale	two-letter language identifier
*/
function getLocaleStrings( parent, locale )
	local section:=NIL, mStr:=map(), tag, i, a
	
	if empty(locale)
		locale := left(getenv("LANG"),2)
	endif
	// Find appropriate section <locale lang="XX">
	for tag in parent:getChilds()
		if tag:getName() == "locale" .and. tag:attribute("lang","") == locale
			section := tag
			exit
		endif
	next

	// Get strings
	if ! empty(section)
		for i in section:getChilds()
			if lower(i:name) == 'msg' .and. ( i:attribute("id","") == "" .or. i:attribute("value","") == "" )
				?? "Error in message tag&\n"
			else
//				?? i:attribute("id"), "=>", i:attribute("value"),chr(10)
				mStr[i:attribute("id")] := i:attribute("value")
			endif
		next
	endif

	// Collect messages inside widgets
	a := parent:XPath('//msg')
	//?? valtype(a), len(a),chr(10)
	
	if valtype(a) == 'A' .and. len(a) > 0
		for i in a
			if i:attribute('lang','') == locale .and. .not. ( i:attribute("id","") == "" .and. i:attribute("value","") == "" )
				mStr[i:attribute("id")] := i:attribute("value")
	//			?? i:attribute("id"), "=>", i:attribute("value"),chr(10)
			endif
		next
	endif

return mStr
