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

/**********************************************************/

GtkType _gdk_type_gc() { return GDK_OBJECT_GC; }
long _clip_type_gc() { return GDK_OBJECT_GC; }
const char * _clip_type_name_gc() { return "GDK_OBJECT_GC"; }

int
clip_INIT___GC(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_gc, _clip_type_name_gc, _gdk_type_gc, NULL, NULL);
	return 0;
}
/**********************************************************/

CLIP_DLLEXPORT int
gdk_object_gc_destructor(ClipMachine *cm, C_object *cgc)
{
	if (cgc && GDK_IS_GC(cgc) && cgc->ref_count>=0)
		gdk_gc_unref(GDK_GC(cgc->object));
	return 0;
}

/* Create a new graphics context with default values. */
int
clip_GDK_GCNEW(ClipMachine * cm)
{
	ClipVar    *cv = _clip_spar(cm,1);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	GdkGC *gc;
	C_object *cgc;
	CHECKOPT(1,MAP_t); CHECKARG2(2,NUMERIC_t,MAP_t);
	gc = gdk_gc_new(cwid->widget->window);
	if (gc)
	{
//		gdk_gc_ref(gc);
		cgc = _register_object(cm,gc,GDK_OBJECT_GC,cv,
			(coDestructor)gdk_object_gc_destructor);
		if (cgc)
		{
	    //		cgc->ref_count=1;
			_clip_mclone(cm,RETPTR(cm),&cgc->obj);
		}
	      //	else
	      //		gdk_gc_unref(gc);

	}
	return 0;
err:
	return 1;
}

/* Create a new GC with the given initial values. */
/* The GdkGCValues structure holds a set of values used to create or
   modify a graphics context.
GdkColor foreground;	the foreground color.
GdkColor background;	the background color.
GdkFont *font;		the default font..
GdkFunction function;	the bitwise operation used when drawing.
GdkFill fill;		the fill style.
GdkPixmap *tile;	the tile pixmap.
GdkPixmap *stipple;	the stipple bitmap.
GdkPixmap *clip_mask;	the clip mask bitmap.
GdkSubwindowMode subwindow_mode; the subwindow mode.
gint ts_x_origin;	the x origin of the tile or stipple.
gint ts_y_origin;	the y origin of the tile or stipple.
gint clip_x_origin;	the x origin of the clip mask.
gint clip_y_origin;	the y origin of the clip mask.
gint graphics_exposures; whether graphics exposures are enabled.
gint line_width;	the line width
GdkLineStyle line_style; the way dashed lines are drawn
GdkCapStyle cap_style;	the way the ends of lines are drawn
GdkJoinStyle join_style; the way joins between lines are drawn
*/
int
clip_GDK_GCNEWWITHVALUES(ClipMachine * cm)
{
	ClipVar    *cv = _clip_spar(cm,1);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	ClipVar  *cval = _clip_spar(cm,3);
	long      mask = _clip_parnl(cm,4);
	GdkGC *gc;
	GdkGCValues gcv;
	GdkFont *font;
	C_object *cgc, *cfont;
	ClipVar *c;
	C_widget *cw;
	double d;
	CHECKOPT(1,MAP_t); CHECKARG2(2,NUMERIC_t,MAP_t);
	CHECKARG(3,MAP_t); CHECKARG(4,NUMERIC_t);

	/* the foreground color. */
	if ( (c = _clip_mget( cm, cval, HASH_FOREGROUND )) != NULL )
		_map_colors_to_gdk(cm, c, &gcv.foreground);
	/* the background color. */
	if ( (c = _clip_mget( cm, cval, HASH_BACKGROUND )) != NULL )
		_map_colors_to_gdk(cm, c, &gcv.background);
	/* Set default font */
	switch ( _clip_mtype(cm,cval,HASH_FONT) )
	{
		case CHARACTER_t:
			c = _clip_mget(cm,cval,HASH_FONT);
			font = gdk_font_load(c->s.str.buf);
			break;
		case MAP_t:
		case NUMERIC_t:
			cfont = _fetch_cobject(cm,_clip_mget(cm,cval,HASH_FONT));
			if (cfont)
			{
				font = (GdkFont*)cfont->object;
				cfont->ref_count++;
			}
			break;
	}
	if (font)
	{
		gcv.font = font;
		gdk_font_ref (gcv.font);
	}
	/* the bitwise operation used when drawing. */
	/* Determines how the bit values for the source pixels are combined with the
	   bit values for destination pixels to produce the final result. The sixteen
	   values here correspond to the 16 different possible 2x2 truth tables. Only
	   a couple of these values are usually useful; for colored images, only
	   GDK_COPY, GDK_XOR and GDK_INVERT are generally useful. For bitmaps, GDK_AND
	   and GDK_OR are also useful. */
	_clip_mgetn(cm,cval,HASH_FUNCTION,&d);
	gcv.function = (GdkFunction)d;
	/* the fill style. */
	_clip_mgetn(cm,cval,HASH_FILL,&d);
	gcv.fill = (GdkFill)d;
	/* the tile pixmap. */
	if ( (c = _clip_mget( cm, cval, HASH_TILE )) != NULL )
	{
		cw = _fetch_cwidget(cm,c);
		gcv.tile = cw ? GTK_PIXMAP(cw->widget)->pixmap : NULL;
	}
	/* the stipple pixmap. */
	if ( (c = _clip_mget( cm, cval, HASH_STIPPLE )) != NULL )
	{
		cw = _fetch_cwidget(cm,c);
		gcv.stipple = cw ? GTK_PIXMAP(cw->widget)->pixmap : NULL;
	}
	/* the clip mask bitmap. */
	if ( (c = _clip_mget( cm, cval, HASH_CLIPMASK )) != NULL )
	{
		cw = _fetch_cwidget(cm,c);
		gcv.clip_mask = cw ? GTK_PIXMAP(cw->widget)->pixmap : NULL;
	}
	/* the subwindow mode. */
	_clip_mgetn(cm,cval,HASH_SUBWINDOWMODE,&d);
	gcv.subwindow_mode = (GdkSubwindowMode)d;
	/* the x origin of the tile or stipple. */
	_clip_mgetn(cm,cval,HASH_TSXORIGIN,&d);
	gcv.ts_x_origin = (gint)d;
	/* the y origin of the tile or stipple. */
	_clip_mgetn(cm,cval,HASH_TSYORIGIN,&d);
	gcv.ts_y_origin = (gint)d;
	/* the x origin of the clip mask. */
	_clip_mgetn(cm,cval,HASH_CLIPXORIGIN,&d);
	gcv.clip_x_origin = (gint)d;
	/* the y origin of the clip mask. */
	_clip_mgetn(cm,cval,HASH_CLIPYORIGIN,&d);
	gcv.clip_y_origin = (gint)d;
	/* whether graphics exposures are enabled. */
	_clip_mgetn(cm,cval,HASH_GRAPHICSEXPOSURES,&d);
	gcv.graphics_exposures = (gint)d;
	/* the line width */
	_clip_mgetn(cm,cval,HASH_LINEWITDH,&d);
	gcv.line_width = (gint)d;
	/* the way dashed lines are drawn */
	_clip_mgetn(cm,cval,HASH_LINESTYLE,&d);
	gcv.line_style = (GdkLineStyle)d;
	/* the way the ends of lines are drawn */
	_clip_mgetn(cm,cval,HASH_CAPSTYLE,&d);
	gcv.cap_style = (GdkCapStyle)d;
	/* the way joins between lines are drawn */
	_clip_mgetn(cm,cval,HASH_JOINSTYLE,&d);
	gcv.join_style = (GdkJoinStyle)d;

	gc = gdk_gc_new_with_values(cwid->widget->window, &gcv, mask);
	if (gc)
	{
//		gdk_gc_ref(gc);
		cgc = _register_object(cm,gc,GDK_OBJECT_GC,cv,
			(coDestructor)gdk_object_gc_destructor);
		if (cgc)
		{
			cgc->ref_count=1;
			_clip_mclone(cm,RETPTR(cm),&cgc->obj);
		}
		else
			gdk_gc_unref(gc);

	}
	return 0;
err:
	return 1;
}

/* Increase the reference count on a graphics context. */
int
clip_GDK_GCREF(ClipMachine * cm)
{
	C_object      *cgc = _fetch_co_arg(cm);
	CHECKCOBJ(cgc,GDK_IS_GC(cgc));
	gdk_gc_ref(GDK_GC(cgc->object));
	cgc->ref_count++;
	return 0;
err:
	return 1;
}

/* Decrease the reference count on a graphics context. If the resulting
 * reference count is zero, the graphics context will be destroyed. */
int
clip_GDK_GCUNREF(ClipMachine * cm)
{
	C_object      *cgc = _fetch_co_arg(cm);
	CHECKCOBJ(cgc,GDK_IS_GC(cgc));

	cgc->ref_count--;
	if (cgc->ref_count > 0)
		gdk_gc_unref(GDK_GC(cgc->object));
	else
		destroy_c_object(cgc);
//	gdk_gc_unref(GDK_GC(cgc->object));
	return 0;
err:
	return 1;
}

/* Retrieves the current values from a graphics context. */
int
clip_GDK_GCGETVALUES(ClipMachine * cm)
{
	C_object      *cgc = _fetch_co_arg(cm);

	ClipVar *ret = RETPTR(cm);

	GdkGCValues gcv;
	C_object *cfont;
	ClipVar *c = NEW(ClipVar);
	C_widget *cw;

	CHECKCOBJ(cgc,GDK_IS_GC(cgc));

	gdk_gc_get_values(GDK_GC(cgc->object), &gcv);

	memset(ret,0,sizeof(*ret)); _clip_map(cm,ret);
	memset(c,0,sizeof(*c));

	/* the foreground color. */
	_clip_map(cm, c); _gdk_color_to_map(cm, gcv.foreground, c);
	_clip_madd(cm, ret, HASH_FOREGROUND, c);
	/* the background color. */
	_clip_map(cm, c); _gdk_color_to_map(cm, gcv.background, c);
	_clip_madd(cm, ret, HASH_BACKGROUND, c);

	_clip_destroy(cm,c); free(c);

	/* the default font */
	cfont = _get_cobject(cm,gcv.font,GDK_OBJECT_FONT,
		(coDestructor)gdk_object_font_destructor);
	if (cfont) _clip_madd(cm, ret, HASH_FONT, &cfont->obj);
	/* the bitwise operation used when drawing. */
	_clip_mputn(cm,ret,HASH_FUNCTION,gcv.function);
	/* the fill style. */
	_clip_mputn(cm,ret,HASH_FILL,gcv.fill);
	/* the tile pixmap. */
	if (gcv.tile)
	{
		cw = _list_get_cwidget_by_data(cm,gcv.tile);
		if (!cw)
		{
			GtkWidget *wxpm = gtk_pixmap_new(gcv.tile,NULL);
			cw = _register_widget(cm,wxpm,NULL);
		}
		if (cw) _clip_madd( cm, ret, HASH_TILE, &cw->obj);
	}
	/* the stipple pixmap. */
	if (gcv.stipple)
	{
		cw = _list_get_cwidget_by_data(cm,gcv.stipple);
		if (!cw)
		{
			GtkWidget *wxpm = gtk_pixmap_new(gcv.stipple,NULL);
			cw = _register_widget(cm,wxpm,NULL);
		}
		if (cw) _clip_madd( cm, ret, HASH_STIPPLE, &cw->obj);
	}
	/* the clip mask bitmap. */
	if (gcv.clip_mask)
	{
		cw = _list_get_cwidget_by_data(cm,gcv.clip_mask);
		if (!cw)
		{
			GtkWidget *wxpm = gtk_pixmap_new(gcv.clip_mask,NULL);
			cw = _register_widget(cm,wxpm,NULL);
		}
		if (cw) _clip_madd( cm, ret, HASH_CLIPMASK, &cw->obj);
	}
	/* the subwindow mode. */
	_clip_mputn(cm,ret,HASH_SUBWINDOWMODE,gcv.subwindow_mode);
	/* the x origin of the tile or stipple. */
	_clip_mputn(cm,ret,HASH_TSXORIGIN,gcv.ts_x_origin);
	/* the y origin of the tile or stipple. */
	_clip_mputn(cm,ret,HASH_TSYORIGIN,gcv.ts_y_origin);
	/* the x origin of the clip mask. */
	_clip_mputn(cm,ret,HASH_CLIPXORIGIN,gcv.clip_x_origin);
	/* the y origin of the clip mask. */
	_clip_mputn(cm,ret,HASH_CLIPYORIGIN,gcv.clip_y_origin);
	/* whether graphics exposures are enabled. */
	_clip_mputn(cm,ret,HASH_GRAPHICSEXPOSURES,gcv.graphics_exposures);
	/* the line width */
	_clip_mputn(cm,ret,HASH_LINEWIDTH,gcv.line_width);
	/* the way dashed lines are drawn */
	_clip_mputn(cm,ret,HASH_LINESTYLE,gcv.line_style);
	/* the way the ends of lines are drawn */
	_clip_mputn(cm,ret,HASH_CAPSTYLE,gcv.cap_style);
	/* the way joins between lines are drawn */
	_clip_mputn(cm,ret,HASH_JOINSTYLE,gcv.join_style);

	return 0;
err:
	return 1;
}

/* Sets the foreground color for a graphics context. */
int
clip_GDK_GCSETFOREGROUND(ClipMachine * cm)
{
	C_object      *cgc = _fetch_co_arg(cm);
	ClipVar    *mcolor = _clip_spar  ( cm, 2);
	GdkColor color;
	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKARG(2,MAP_t);
	_map_colors_to_gdk(cm, mcolor, &color);
	gdk_gc_set_foreground(GDK_GC(cgc->object), &color);
	return 0;
err:
	return 1;
}

/* Sets the background color for a graphics context. */
int
clip_GDK_GCSETBACKGROUND(ClipMachine * cm)
{
	C_object      *cgc = _fetch_co_arg(cm);
	ClipVar    *mcolor = _clip_spar  ( cm, 2);
	GdkColor color;
	CHECKCOBJ(cgc,GDK_IS_GC(cgc));
	CHECKARG(2,MAP_t);
	_map_colors_to_gdk(cm, mcolor, &color);
	gdk_gc_set_background(GDK_GC(cgc->object), &color);
	return 0;
err:
	return 1;
}

/* Sets the font for a graphics context.
 * (Note that all text-drawing functions in GDK take a font argument;
 * the value set here is used when that argument is NULL.) */
int
clip_GDK_GCSETFONT(ClipMachine * cm)
{
	C_object      *cgc = _fetch_co_arg(cm);
	ClipVar *c;
	GdkFont *font; C_object *cfont;

	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKARG3(2,CHARACTER_t,MAP_t,NUMERIC_t);
	switch ( _clip_parinfo(cm,2) )
	{
		case CHARACTER_t:
			c = _clip_spar(cm,2);
			font = gdk_font_load(c->s.str.buf);
			break;
		case MAP_t:
		case NUMERIC_t:
			cfont = _fetch_cobject(cm,_clip_spar(cm,2));
			if (cfont)
			{
				font = (GdkFont*)cfont->object;
				cfont->ref_count++;
			}
			break;
	}
	if (font)
	{
		gdk_gc_set_font(GDK_GC(cgc->object), font);
		gdk_font_ref (font);
	}
	return 0;
err:
	return 1;
}

/* Determines how the current pixel values and the pixel values being
 * drawn are combined to produce the final pixel values. */
int
clip_GDK_GCSETFUNCTION(ClipMachine * cm)
{
	C_object        *cgc = _fetch_co_arg(cm);
	GdkFunction function = _clip_parni(cm,2);
	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKOPT(2,NUMERIC_t);
	gdk_gc_set_function(GDK_GC(cgc->object), function);
	return 0;
err:
	return 1;
}

/* Set the fill mode for a graphics context. */
int
clip_GDK_GCSETFILL(ClipMachine * cm)
{
	C_object *cgc = _fetch_co_arg(cm);
	GdkFill  fill = _clip_parni(cm,2);
	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKOPT(2,NUMERIC_t);
	gdk_gc_set_fill(GDK_GC(cgc->object), fill);
	return 0;
err:
	return 1;
}

/* Set a tile pixmap for a graphics context.
 * This will only be used if the fill mode is GDK_TILED. */
int
clip_GDK_GCSETTILE(ClipMachine * cm)
{
	C_object  *cgc = _fetch_co_arg(cm);
	C_widget *cxpm = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCOBJ(cgc,GDK_IS_GC(cgc));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cxpm,GTK_IS_PIXMAP);
	gdk_gc_set_tile(GDK_GC(cgc->object), GTK_PIXMAP(cxpm->widget)->pixmap);
	return 0;
err:
	return 1;
}

/* Set the stipple bitmap for a graphics context. The stipple will
 * only be used if the fill mode is GDK_STIPPLED or GDK_OPAQUE_STIPPLED. */
int
clip_GDK_GCSETSTIPPLE(ClipMachine * cm)
{
	C_object  *cgc = _fetch_co_arg(cm);
	C_widget *cxpm = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCOBJ(cgc,GDK_IS_GC(cgc));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cxpm,GTK_IS_PIXMAP);
	gdk_gc_set_stipple(GDK_GC(cgc->object), GTK_PIXMAP(cxpm->widget)->pixmap);
	return 0;
err:
	return 1;
}

/* Set the origin when using tiles or stipples with the GC.
 * The tile or stipple will be aligned such that the upper left corner of
 * the tile or stipple will coincide with this point. */
int
clip_GDK_GCSETTSORIGIN(ClipMachine * cm)
{
	C_object *cgc = _fetch_co_arg(cm);
	gint        x = _clip_parni(cm,2);
	gint        y = _clip_parni(cm,3);
	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	gdk_gc_set_ts_origin(GDK_GC(cgc->object), x, y);
	return 0;
err:
	return 1;
}

/* Sets the origin of the clip mask. The coordinates are interpreted relative to
 * the upper-left corner of the destination drawable of  the current operation. */
int
clip_GDK_GCSETCLIPORIGIN(ClipMachine * cm)
{
	C_object *cgc = _fetch_co_arg(cm);
	gint        x = _clip_parni(cm,2);
	gint        y = _clip_parni(cm,3);
	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	gdk_gc_set_clip_origin(GDK_GC(cgc->object), x, y);
	return 0;
err:
	return 1;
}

/* Sets the clip mask for a graphics context from a bitmap.
 * The clip mask is interpreted relative to the clip origin.
 * (See gdk_gc_set_clip_origin()). */
int
clip_GDK_GCSETCLIPMASK(ClipMachine * cm)
{
	C_object  *cgc = _fetch_co_arg(cm);
	C_widget *cxpm = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCOBJ(cgc,GDK_IS_GC(cgc));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cxpm,GTK_IS_PIXMAP);
	gdk_gc_set_clip_mask(GDK_GC(cgc->object), GTK_PIXMAP(cxpm->widget)->pixmap);
	return 0;
err:
	return 1;
}

/* Sets the clip mask for a graphics context from a rectangle.
 * The clip mask is interpreted relative to the clip origin.
 * (See gdk_gc_set_clip_origin()). */
int
clip_GDK_GCSETCLIPRECTANGLE(ClipMachine * cm)
{
	C_object  *cgc = _fetch_co_arg(cm);
	gint16       x = _clip_parni(cm,2);
	gint16       y = _clip_parni(cm,3);
	guint16  width = _clip_parni(cm,4);
	guint16 height = _clip_parni(cm,5);
	double d;
	GdkRectangle rect;
	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKARG2(2,MAP_t,NUMERIC_t);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
	if (_clip_parinfo(cm,2)==MAP_t)
	{
		ClipVar *cv = _clip_spar(cm,2);
		_clip_mgetn(cm, cv, HASH_X, &d); rect.x = (gint16)d;
		_clip_mgetn(cm, cv, HASH_Y, &d); rect.y = (gint16)d;
		_clip_mgetn(cm, cv, HASH_WIDTH, &d); rect.width = (gint16)d;
		_clip_mgetn(cm, cv, HASH_HEIGHT, &d); rect.height = (gint16)d;
	}
	else
	{
		rect.x = x; rect.y = y; rect.width = width; rect.height = height;
	}
	gdk_gc_set_clip_rectangle(GDK_GC(cgc->object), &rect);
	return 0;
err:
	return 1;
}

/* Sets the clip mask for a graphics context from a region structure.
 * The clip mask is interpreted relative to the clip origin.
 * (See gdk_gc_set_clip_origin()). */
int
clip_GDK_GCSETCLIPREGION(ClipMachine * cm)
{
	C_object   *cgc = _fetch_co_arg(cm);
	C_object  *creg = _fetch_cobject(cm,_clip_spar(cm,2));

	CHECKCOBJ(cgc,GDK_IS_GC(cgc));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCOBJ(creg,GDK_IS_REGION(creg));
	gdk_gc_set_clip_region(GDK_GC(cgc->object), (GdkRegion*)(creg->object));
	return 0;
err:
	return 1;
}

/* Sets how drawing with this GC on a window will affect child windows of that window. */
/* GDK_CLIP_BY_CHILDREN		only draw onto the window itself.
   GDK_INCLUDE_INFERIORS	Draw onto the window and child windows. */
int
clip_GDK_GCSETSUBWINDOW(ClipMachine * cm)
{
	C_object         *cgc = _fetch_co_arg(cm);
	GdkSubwindowMode mode = _clip_parni (cm, 2);

	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKARG(2,NUMERIC_t);
	gdk_gc_set_subwindow(GDK_GC(cgc->object), mode);
	return 0;
err:
	return 1;
}

/* Sets whether copying non-visible portions of a drawable using this graphics
 * context generate exposure events for the corresponding regions of the
 * destination drawable. (See gdk_draw_pixmap()). */
int
clip_GDK_GCSETEXPOSURES(ClipMachine * cm)
{
	C_object  *cgc = _fetch_co_arg(cm);
	gint exposures = _clip_parni (cm, 2);

	CHECKCOBJ(cgc,GDK_IS_GC(cgc)); CHECKARG(2,NUMERIC_t);
	gdk_gc_set_exposures(GDK_GC(cgc->object), exposures);
	return 0;
err:
	return 1;
}

/* Sets various attributes of how lines are drawn. See the corresponding
 * members of GdkGCValues for full explanations of the arguments. */
int
clip_GDK_GCSETLINEATTRIBUTES(ClipMachine * cm)
{
	C_object      *cgc = _fetch_co_arg(cm);
	gint    line_width = INT_OPTION (cm, 2, 0);
	GdkLineStyle line_style = _clip_parni (cm, 3);
	GdkCapStyle   cap_style = _clip_parni (cm, 4);
	GdkJoinStyle join_style = _clip_parni (cm, 5);

	CHECKCOBJ(cgc,GDK_IS_GC(cgc));
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
	gdk_gc_set_line_attributes(GDK_GC(cgc->object),
		line_width, line_style, cap_style, join_style);
	return 0;
err:
	return 1;
}

/* Sets the way dashed-lines are drawn. Lines will be drawn with alternating
 * on and off segments of the lengths specified in dash_list. The manner in
 * which the on and off segments are drawn is determined by the line_style
 * value of the GC. (This can be changed with gdk_gc_set_line_attributes) */
int
clip_GDK_GCSETDASHES(ClipMachine * cm)
{
	C_object      *cgc = _fetch_co_arg(cm);
	gint   dash_offset = _clip_parni (cm, 2);
	gchar   *dash_list = _clip_parc  (cm, 3);
	gint             n = _clip_parni (cm, 4);

	CHECKCOBJ(cgc,GDK_IS_GC(cgc));
	CHECKOPT(2,NUMERIC_t); CHECKARG(3,CHARACTER_t); CHECKOPT(4,NUMERIC_t);
	if (_clip_parinfo(cm,4)==UNDEF_t) n = strlen(dash_list);

	gdk_gc_set_dashes(GDK_GC(cgc->object), dash_offset,dash_list,n);

	return 0;
err:
	return 1;
}

/* Copy the set of values from one graphics context onto another graphics context. */
int
clip_GDK_GCCOPY(ClipMachine * cm)
{
	C_object *cdst_gc = _fetch_co_arg(cm);
	C_object *csrc_gc = _fetch_cobject(cm,_clip_spar(cm,2));

	CHECKCOBJ(cdst_gc,GDK_IS_GC(cdst_gc));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCOBJ(csrc_gc,GDK_IS_GC(csrc_gc));

	gdk_gc_copy(GDK_GC(cdst_gc->object), GDK_GC(csrc_gc->object));

	return 0;
err:
	return 1;
}
