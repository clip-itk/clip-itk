/*
    Copyright (C) 2002  ITK
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

GtkType _gdk_type_colormap() { return GDK_TYPE_COLORMAP; }
long _clip_type_colormap() { return GDK_OBJECT_COLORMAP; }
const char * _clip_type_name_colormap() { return "GDK_OBJECT_COLORMAP"; }

int
clip_INIT___COLORMAP(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_colormap, _clip_type_name_colormap, _gdk_type_colormap, NULL, NULL);
	return 0;
}

/**********************************************************/
/* Parse a textual specification of a color and fill in the red, green, and
 * blue fields of a GdkColor structure. The color is not allocated, you must
 * call gdk_colormap_alloc_color() yourself. The text string can be in any of
 * the forms accepted by XParseColor; these include name for a color from
 * rgb.txt, such as DarkSlateGray, or a hex specification such as 305050.*/
int
clip_GDK_COLORPARSE(ClipMachine * cm)
{
	gchar * color_name = _clip_parc(cm,1);
	GdkColor color;
	CHECKARG(1,CHARACTER_t);
	if (gdk_color_parse(color_name, &color))
	{
		memset(RETPTR(cm),0,sizeof(ClipVar)); _clip_map(cm,RETPTR(cm));
		_gdk_color_to_map(cm,color,RETPTR(cm));
	}
	return 0;
err:
	return 1;
}

/* Gets a numeric value: first byte - red, second - green, third - blue */
/* Returns a map with fields RED, GREEN and BLUE */
int
clip_GDK_COLORRGB(ClipMachine * cm)
{
	long RGB = _clip_parnl(cm,1);
	CHECKOPT(1,NUMERIC_t);
	if (_clip_parinfo(cm,1) != UNDEF_t)
	{
		ClipVar *ret = RETPTR(cm);
		memset(ret, 0, sizeof(*ret)); _clip_map(cm, ret);
		_clip_mputn(cm, ret, HASH_RED, (RGB & 0xFF) << 8);
		_clip_mputn(cm, ret, HASH_GREEN, ((RGB >> 8) & 0xFF) << 8);
		_clip_mputn(cm, ret, HASH_BLUE, ((RGB >> 16) & 0xFF) << 8);
	}
	return 0;
err:
     	return 1;
}

/* Gets a map with fields RED, GREEN and BLUE */
/* Returns a number: first byte - red, second - green, third - blue */
int
clip_GDK_COLORRGBTON(ClipMachine * cm)
{
	ClipVar *mRGB = _clip_spar(cm,1);
	double red, green, blue;
	long color;

	CHECKARG(1,MAP_t);

	_clip_mgetn(cm, mRGB, HASH_RED, &red);
	_clip_mgetn(cm, mRGB, HASH_GREEN, &green);
	_clip_mgetn(cm, mRGB, HASH_BLUE, &blue);

	//color = ((long)red & 0xFF) + (((long)green & 0xFF) >> 16) + (((long)blue & 0xFF) >> 24);
	color = ((long)red >> 8) + (((long)green >> 8) << 8) + (((long)blue >> 8) << 16);
	_clip_retnl(cm, color);
	return 0;
err:
	return 1;
}

/* Allocate a single color from a colormap. This function is obsolete.
 * See gdk_colormap_alloc_color(). */
int
clip_GDK_COLORALLOC(ClipMachine * cm)
{
	C_object *ccmap = _fetch_co_arg(cm);
	ClipVar *mcolor = _clip_spar(cm,2);
	GdkColor color;
	CHECKCOBJ(ccmap,GDK_IS_COLORMAP(ccmap->object)); CHECKARG(2,MAP_t);
	_map_colors_to_gdk(cm, mcolor, &color);
	if (gdk_color_alloc(GDK_COLORMAP(ccmap), &color))
	{
		_clip_mputn(cm, mcolor, HASH_PIXEL, color.pixel);
		_clip_retl(cm,TRUE);
	}
	else
		_clip_retl(cm,FALSE);
	return 0;
err:
	return 1;
}

CLIP_DLLEXPORT int
gdk_object_colormap_destructor(ClipMachine *cm, C_object *ccmap)
{
	if (ccmap && GDK_IS_COLORMAP(ccmap->object))
		gdk_colormap_unref(GDK_COLORMAP(ccmap->object));
	return 0;
}

/* Returns the system's default colormap. */
int
clip_GDK_COLORMAPGETSYSTEM(ClipMachine * cm)
{
	ClipVar *cv = _clip_spar(cm,1);
	GdkColormap *colormap;
	C_object *ccolormap;
	CHECKOPT(1,MAP_t);

	colormap = gdk_colormap_get_system();

	if (colormap)
	{
		ccolormap = _register_object(cm,colormap,GDK_OBJECT_COLORMAP,cv,
			(coDestructor)gdk_object_colormap_destructor);
		if (ccolormap)
		{
			ccolormap->ref_count = 1;
			_clip_mclone(cm,RETPTR(cm),&ccolormap->obj);
		}
		else
			gdk_colormap_unref(colormap);
	}
	return 0;
err:
	return 1;
}

/* Increase the reference count of a colormap. */
int
clip_GDK_COLORMAPREF(ClipMachine * cm)
{
	C_object *ccmap = _fetch_co_arg(cm);
	CHECKCOBJ(ccmap,GDK_IS_COLORMAP(ccmap->object));
	gdk_colormap_ref(GDK_COLORMAP(ccmap->object));
	ccmap->ref_count++;
	return 0;
err:
	return 1;
}

/* Decrease the reference count of a count by one. If the result is zero,
   destroys the colormap. */
int
clip_GDK_COLORMAPUNREF(ClipMachine * cm)
{
	C_object *ccmap = _fetch_co_arg(cm);
	CHECKCOBJ(ccmap,GDK_IS_COLORMAP(ccmap->object));
	ccmap->ref_count--;
	if (ccmap->ref_count > 0)
		gdk_colormap_unref(GDK_COLORMAP(ccmap->object));
	else
		destroy_c_object(ccmap);
	return 0;
err:
	return 1;
}

/* Returns the size of the system's default colormap.
   (See the description of struct GdkColormap for an
   explanation of the size of a colormap.) */
int
clip_GDK_COLORMAPGETSYSTEMSIZE(ClipMachine * cm)
{
	_clip_retni(cm,gdk_colormap_get_system_size());
	return 0;
}

/* Allocate a single color from a colormap. */
int
clip_GDK_COLORMAPALLOCCOLOR(ClipMachine * cm)
{
	C_object *ccmap = _fetch_co_arg(cm);
	ClipVar *mcolor = _clip_spar(cm,2);
	gboolean writable = BOOL_OPTION(cm,3,TRUE);
	gboolean best_match = BOOL_OPTION(cm,4,TRUE);

	GdkColor color;
	CHECKCOBJ(ccmap,GDK_IS_COLORMAP(ccmap->object)); CHECKARG(2,MAP_t);
	CHECKOPT(3,LOGICAL_t); CHECKOPT(4,LOGICAL_t);
	_map_colors_to_gdk(cm, mcolor, &color);
	if (gdk_colormap_alloc_color(GDK_COLORMAP(ccmap->object), &color, writable, best_match))
	{
		_clip_mputn(cm, mcolor, HASH_PIXEL, color.pixel);
		_clip_retl(cm,TRUE);
	}
	else
		_clip_retl(cm,FALSE);
	return 0;
err:
	return 1;
}

