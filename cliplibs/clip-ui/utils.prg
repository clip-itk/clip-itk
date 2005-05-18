/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 	           */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
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

/* Base class for XML tag */
function XMLTag( name )
	local obj 	:= map()
	obj:className 	:= "XMLTag"
	obj:name	:= name
	obj:attrNames	:= array(0)
	obj:attr	:= map()
	obj:parent	:= NIL
	obj:childs	:= array(0)
	obj:o		:= NIL
return obj

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

/* Get tag by path in format root_tag.tag1.tag2... */
function XMLGetTag(root, path)
	local a, e, tt, t:=root, la
	if root == NIL .or. root:className != "XMLTag"
               	return NIL
	endif
	a := split(path,"\.")
	la := len(a)
	for e in a
		for tt in t:childs
			if tt:name == e
				t := tt
				la := la - 1
				exit
			endif
		next
	next
	if t == root .or. la > 0
		t := NIL
	endif
return t

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
	local section:=NIL, mStr:=map(), i
	if empty(locale)
		locale := substr(getenv("LANG"),1,2)
	endif
	
	// Find appropriate section <locale lang="XX">
	for tag in parent:childs
		if tag:name == "LOCALE" .and. "LANG" $ tag:attr .and. tag:attr:lang == locale
			section := tag
			exit
		endif
	next
	
	// Get strings
	if ! empty(section)
		for i in section:childs
			if .not. ("ID" $ i:attr .and. "VALUE" $ i:attr)
				?? "Error in tag <locale>&\n"
			else
//				?? i:attr:id, "=>", i:attr:value,chr(10)
				mStr[i:attr:id] := i:attr:value
			endif
		next
	endif

return mStr
