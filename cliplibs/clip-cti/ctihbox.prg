/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_HBOX is a container that organizes child widgets into a single row.
   All children are allocated the same height. */

#include "cti.ch"

#define	SUPERCLASS	CTI_BOX

function cti_hbox_new(homogeneous,spacing)
	local obj := cti_inherit(cti_box_new(),"CTI_HBOX")

	obj:__configure_children:= @cti_hbox_configure_children()

	if valtype(homogeneous)=="L"
		obj:__homogeneous := homogeneous
	endif
	if valtype(spacing)=="N"
		obj:__spacing := spacing
	endif
return obj

static function cti_hbox_configure_children(obj)
	CALL SUPER obj:__configure_children(FALSE)
return TRUE


