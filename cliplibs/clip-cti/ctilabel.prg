/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_LABEL - A widget that displays a small to medium amount of text. */

#include "cti.ch"
#include "ctilabel.ch"

#define	SUPERCLASS	CTI_WIDGET

/* CTI_LABEL constructor */
function cti_label_new(caption)
	local obj := cti_inherit(cti_widget_new(),"CTI_LABEL")

	obj:__caption	:= nil
	obj:__justify	:= CTI_JUSTIFY_LEFT

	obj:__real_draw	:= @cti_label_real_draw()
//	obj:__repaint	:= @cti_label_repaint()

	obj:can_focus	:= @cti_label_can_focus()

	obj:set_text	:= @cti_label_set_text()
	obj:get_text	:= @cti_label_get_text()
	obj:set_justify	:= @cti_label_set_justify()

/*****************************************************/
	obj:set_text(caption)
return obj

/************************************************************/

/* Draw a label */
static function cti_label_real_draw(obj)
	local caption
//	setcursor(SC_NONE)
	caption := iif(obj:__caption!=nil,obj:__caption,"")
	switch(obj:__justify)
		case CTI_JUSTIFY_LEFT
		caption := padr(caption,obj:width)

		case CTI_JUSTIFY_RIGHT
		caption := padl(caption,obj:width)

		case CTI_JUSTIFY_CENTER
		caption := padc(caption,obj:width)
	end
//	DispOutAt(obj:__abs_top,obj:__abs_left,caption,obj:Palette:Label)
	winbuf_out_at(obj:__buffer,0,0,caption,obj:Palette:Label)
return TRUE

/* Set caption of the label */
static function cti_label_set_text(obj,cText)
	obj:__caption := iif(valtype(cText) $ "CU",cText,obj:__caption)
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

/* Returns caption of the label*/
static function cti_label_get_text(obj)
return obj:__caption

static function cti_label_can_focus(obj)
return FALSE
