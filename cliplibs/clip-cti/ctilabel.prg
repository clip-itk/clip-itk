/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_LABEL - A widget that displays a small to medium amount of text. */

#include "cti.ch"

#define	SUPERCLASS	CTI_WIDGET

/* CTI_LABEL constructor */
function cti_label_new(caption)
	local obj := cti_inherit(cti_widget_new(),"CTI_LABEL")

	obj:__caption		:= nil
	obj:__accel_key		:= ""
	obj:__accel_pos		:= -1
	obj:__justify		:= CTI_JUSTIFY_LEFT

	obj:__real_draw		:= @cti_label_real_draw()
	obj:realize_real	:= @cti_label_realize_real()

	obj:can_focus		:= {||FALSE}

	obj:set_text		:= @cti_label_set_text()
	obj:get_text		:= {||obj:__caption}
	obj:set_justify		:= @cti_label_set_justify()

/*****************************************************/
	obj:set_text(caption)
return obj

/************************************************************/

/* Draw a label */
static function cti_label_real_draw(obj)
	local caption, bg

	CALL SUPER obj:__real_draw()

	caption := iif(obj:__caption!=nil,obj:__caption,"")
	switch(obj:__justify)
		case CTI_JUSTIFY_LEFT
		caption := padr(caption,obj:width)

		case CTI_JUSTIFY_RIGHT
		caption := padl(caption,obj:width)

		case CTI_JUSTIFY_CENTER
		caption := padc(caption,obj:width)
	end
	winbuf_out_at(obj:__buffer,0,0,caption,obj:Palette:Label)
	if obj:__accel_pos > 0
		bg := substr(obj:Palette:Label, at("/",obj:Palette:Label)+1)
		winbuf_attr_at(obj:__buffer,0,obj:__accel_pos-1,0,obj:__accel_pos-1,obj:palette:AccelKey+"/"+bg)
	endif
return TRUE

/* Set caption of the label */
static function cti_label_set_text(obj,cText)
	cti_return_if_fail(valtype(cText) $ "CU")

	obj:__caption := cti_text_parse_accelerator(cText,@obj:__accel_key,@obj:__accel_pos)

//	obj:signal_emit()
	obj:draw_queue()
return TRUE

/* Set justify of the label text */
static function cti_label_set_justify(obj,nJustify)
	cti_return_if_fail(valtype(nJustify)=="N")
	cti_return_if_fail(nJustify>=CTI_JUSTIFY_LEFT .and. nJustify>=CTI_JUSTIFY_RIGHT)

	obj:__justify := nJustify
	obj:draw_queue()
return TRUE

static function cti_label_realize_real(obj)
	local w,h

	CALL SUPER obj:realize_real()

	w := obj:width; h := obj:height
	if obj:width == nil .or. obj:height == nil
		if obj:width == nil
			w := len(obj:__caption)
		endif
	endif

	obj:set_size(1,w)
return TRUE
