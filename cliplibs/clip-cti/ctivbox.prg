/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_VBOX is a container that organizes child widgets into a single column.
   All children are allocated the same width. */

#include "cti.ch"

#define	SUPERCLASS	CTI_BOX

function cti_vbox_new(homogeneous,spacing)
	local obj := cti_inherit(cti_box_new(),"CTI_VBOX")

	obj:__configure_children:= @cti_vbox_configure_children()

	if valtype(homogeneous)=="L"
		obj:__homogeneous := homogeneous
	endif
	if valtype(spacing)=="N"
		obj:__spacing := spacing
	endif
return obj

static function cti_vbox_configure_children(obj)
	CALL SUPER obj:__configure_children(TRUE)
return TRUE


