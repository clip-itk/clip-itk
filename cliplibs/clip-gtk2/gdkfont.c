/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"
#include "clip-gdk2.h"

/*********************** SIGNALS **************************/

/****              Font has no signal                  ****/

/**********************************************************/

GtkType _gdk_type_font() { return GDK_OBJECT_FONT; }
long _clip_type_font() { return GDK_OBJECT_FONT; }
const char * _clip_type_name_font() { return "GDK_OBJECT_FONT"; }

int
clip_INIT___FONT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_font, _clip_type_name_font, _gdk_type_font, NULL, NULL);
	return 0;
}
/**********************************************************/

CLIP_DLLEXPORT int
gdk_object_font_destructor(ClipMachine *cm, C_object *cfont)
{
	if (cfont && GDK_IS_FONT(cfont) && cfont->ref_count>=0)
        	gdk_font_unref(GDK_FONT(cfont->object));
        return 0;
}

/* Loads a font.
 *
 * Currently, this function will always return a new font, however, in the future,
 * it may be changed to look up the font in a cache. You should make no assumptions
 * about the initial reference count. */
int
clip_GDK_FONTLOAD(ClipMachine * cm)
{
	ClipVar *cv = _clip_spar(cm,1);
	const gchar *font_name = _clip_parc(cm,2);
	GdkFont *font;
	C_object *cfont;
	CHECKOPT(1,MAP_t); CHECKARG(2,CHARACTER_t);
	font = gdk_font_load(font_name);
	if (font)
	{
//		gdk_font_ref(font);
		cfont = _register_object(cm,font,GDK_OBJECT_FONT,cv,
	       		(coDestructor)gdk_object_font_destructor);
		if (cfont)
                {
                	cfont->ref_count = 1;
			_clip_mclone(cm,RETPTR(cm),&cfont->obj);
                }
                else
                	gdk_font_unref(font);
	}
	return 0;
err:
	return 1;
}

/* Loads a fontset.
 *
 * Currently, this function will always return a new font, however, in the future,
 * it may be changed to look up the font in a cache. You should make no assumptions
 * about the initial reference count.

 fontset_name : a comma-separated list of XLFDs describing the
 		component fonts of the fontset to load.
 */
int
clip_GDK_FONTSETLOAD(ClipMachine * cm)
{
	ClipVar *cv = _clip_spar(cm,1);
	const gchar *font_name = _clip_parc(cm,2);
	GdkFont *font;
	C_object *cfont;
	CHECKOPT(1,MAP_t); CHECKARG(2,CHARACTER_t);
	font = gdk_fontset_load(font_name);
	if (font)
	{
//		gdk_font_ref(font);
		cfont = _register_object(cm,font,GDK_OBJECT_FONT,cv,
			(coDestructor)gdk_object_font_destructor);
		if (cfont)
		{
                	cfont->ref_count = 1;
			_clip_mclone(cm,RETPTR(cm),&cfont->obj);
                }
                else
                	gdk_font_unref(font);
	}
	return 0;
err:
	return 1;
}

/* Increase the reference count of a count by one. */
int
clip_GDK_FONTREF(ClipMachine * cm)
{
	C_object *cfont = _fetch_co_arg(cm);
	CHECKCOBJ(cfont,GDK_IS_FONT(cfont));
	gdk_font_ref(GDK_FONT(cfont->object));
       	cfont->ref_count++;
	return 0;
err:
	return 1;
}

/* Decrease the reference count of a count by one. If the result is zero,
   destroys the font. */
int
clip_GDK_FONTUNREF(ClipMachine * cm)
{
	C_object *cfont = _fetch_co_arg(cm);
	CHECKCOBJ(cfont,GDK_IS_FONT(cfont));
       	cfont->ref_count--;
        if (cfont->ref_count > 0)
		gdk_font_unref(GDK_FONT(cfont->object));
        else
        	destroy_c_object(cfont);
	return 0;
err:
	return 1;
}

/* Returns the X Font ID for the given font. */
int
clip_GDK_FONTID(ClipMachine * cm)
{
	C_object *cfont = _fetch_co_opt(cm);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	if (cfont)
		_clip_retni(cm,gdk_font_id(GDK_FONT(cfont->object)));
        else
		_clip_retni(cm,gdk_font_id(NULL));
	return 0;
err:
	return 1;
}

/* Compares two fonts for equality. Single fonts compare equal if they
   have the same X font ID. This operation does not currently work
   correctly for fontsets. */
int
clip_GDK_FONTEQUAL(ClipMachine * cm)
{
	C_object *cfont  = _fetch_co_arg(cm);
	C_object *cfont2 = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCOBJ(cfont,GDK_IS_FONT(cfont));
	CHECKARG2(2,MAP_t,NUMERIC_t);
	CHECKCOBJ(cfont2,cfont2->type==GDK_OBJECT_FONT);
	_clip_retl(cm,gdk_font_equal(GDK_FONT(cfont->object),
				GDK_FONT(cfont2->object)));
	return 0;
err:
	return 1;
}

/* Returns the metrics of a NULL-terminated string.

       font : a GdkFont.
     string : the NULL-terminated string to measure.
   lbearing : the left bearing of the string.
   rbearing : the right bearing of the string.
      width : the width of the string.
     ascent : the ascent of the string.
    descent : the descent of the string. */
int
clip_GDK_STRINGEXTENTS(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	gint lbearing, rbearing, width, ascent, descent;
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t);
	LOCALE_TO_UTF(string);
	gdk_string_extents(GDK_FONT(cfont->object), string,
		&lbearing, &rbearing, &width, &ascent, &descent);
	FREE_TEXT(string);
	_clip_storni(cm,lbearing,3,0);
	_clip_storni(cm,rbearing,4,0);
	_clip_storni(cm,width,5,0);
	_clip_storni(cm,ascent,6,0);
	_clip_storni(cm,descent,7,0);
	return 0;
err:
	return 1;
}

/* Returns the metrics of a string.

	 font : a GdkFont
	 text : the text to measure
  text_length : the length of the text in bytes. (If the font is a
		16-bit font, this is twice the length of the text in characters.)
     lbearing : the left bearing of the string.
     rbearing : the right bearing of the string.
	width : the width of the string.
       ascent : the ascent of the string.
      descent : the descent of the string. */
int
clip_GDK_TEXTEXTENTS(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	gint     text_length = _clip_parni(cm,3);
	gint lbearing, rbearing, width, ascent, descent;
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) text_length = strlen(string);
	LOCALE_TO_UTF(string);
	gdk_text_extents(GDK_FONT(cfont->object), string, text_length,
		&lbearing, &rbearing, &width, &ascent, &descent);
	FREE_TEXT(string);
	_clip_storni(cm,lbearing,4,0);
	_clip_storni(cm,rbearing,5,0);
	_clip_storni(cm,width,6,0);
	_clip_storni(cm,ascent,7,0);
	_clip_storni(cm,descent,8,0);
	return 0;
err:
	return 1;
}

/* Determine the width of a NULL-terminated string. (The distance from
   the origin of the string to the point where the next string in a
   sequence of strings should be drawn) */
int
clip_GDK_STRINGWIDTH(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_string_width(GDK_FONT(cfont->object), string));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* Determine the width of a given string. */
int
clip_GDK_TEXTWIDTH(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	gint     text_length = _clip_parni(cm,3);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) text_length = strlen(string);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_text_width(GDK_FONT(cfont->object), string, text_length));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* Determine the width of a given character. */
int
clip_GDK_CHARWIDTH(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_char_width(GDK_FONT(cfont->object), *string));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* Determines the distance from the origin to the rightmost portion of a
   NULL-terminated string when drawn. This is not the correct value for
   determining the origin of the next portion when drawing text in
   multiple pieces. See gdk_string_width(). */
int
clip_GDK_STRINGMEASURE(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_string_measure(GDK_FONT(cfont->object), string));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* Determines the distance from the origin to the rightmost portion of a
   string when drawn. This is not the correct value for determining the
   origin of the next portion when drawing text in multiple pieces. See
   gdk_text_width(). */
int
clip_GDK_TEXTMEASURE(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	gint     text_length = _clip_parni(cm,3);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) text_length = strlen(string);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_text_measure(GDK_FONT(cfont->object), string, text_length));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* Determines the distance from the origin to the rightmost portion of a
   character when drawn. This is not the correct value for determining
   the origin of the next portion when drawing text in multiple pieces. */
int
clip_GDK_CHARMEASURE(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_char_measure(GDK_FONT(cfont->object), *string));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* Determines the total height of a given NULL-terminated string. This
   value is not generally useful, because you cannot determine how this
   total height will be drawn in relation to the baseline. See
   gdk_string_extents(). */
int
clip_GDK_STRINGHEIGHT(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_string_height(GDK_FONT(cfont->object), string));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* Determines the total height of a given string. This value is not
   generally useful, because you cannot determine how this total height
   will be drawn in relation to the baseline. See gdk_text_extents(). */
int
clip_GDK_TEXTHEIGHT(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	gint     text_length = _clip_parni(cm,3);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) text_length = strlen(string);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_text_height(GDK_FONT(cfont->object), string, text_length));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* Determines the total height of a given character. This value is not
   generally useful, because you cannot determine how this total height
   will be drawn in relation to the baseline. See gdk_text_extents(). */
int
clip_GDK_CHARHEIGHT(ClipMachine * cm)
{
	C_object      *cfont = _fetch_co_opt(cm);
	gchar * string = _clip_parc(cm,2);
	CHECKCOBJOPT(cfont,GDK_IS_FONT(cfont));
	CHECKARG(2,CHARACTER_t);
	LOCALE_TO_UTF(string);
	_clip_retni(cm,gdk_char_height(GDK_FONT(cfont->object), *string));
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

