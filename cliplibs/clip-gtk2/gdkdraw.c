/*
    Copyright (C) 2002-2005  ITK
    Author  :   Elena V. Kornilova <alena@itk.ru>
    		Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"
#include "clip-gdk2.h"

/**********************************************************/
int
clip_GDK_DRAWABLEGETIMAGE(ClipMachine * cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	gint             x = _clip_parni(cm,2);
	gint             y = _clip_parni(cm,3);
	gint         width = _clip_parni(cm,4);
	gint        height = _clip_parni(cm,5);
	GdkDrawable *drw = NULL;
        GdkImage    *img ;
        C_object   *cimg ;
	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG(2,NUMERIC_t);  CHECKARG(3,NUMERIC_t);
	CHECKARG(4,NUMERIC_t);  CHECKARG(4,NUMERIC_t);
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;

	img = gdk_drawable_get_image(drw, x,y, width,height);
        if (img)
        {
        	cimg = _list_get_cobject(cm, img);
		if (!cimg) cimg = _register_object(cm,img,GDK_TYPE_IMAGE, NULL, NULL);
		if (cimg) _clip_mclone(cm, RETPTR(cm),&cimg->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWABLESETCOLORMAP(ClipMachine * cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *ccm = _fetch_cobject(cm,_clip_spar(cm,2));
	GdkDrawable *drw = NULL;

	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t); CHECKCOBJ(ccm,GDK_IS_COLORMAP(ccm->object));

	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;

	gdk_drawable_set_colormap(drw, GDK_COLORMAP(ccm->object));

	return 0;
err:
	return 1;
}
/* Draws a rectangular outline or filled rectangle, using the foreground
 * color and other attributes of the GdkGC. */

/* Note: A rectangle drawn filled is 1 pixel smaller in both dimensions
 * than a rectangle outlined. Calling gdk_draw_rectangle (window, gc, TRUE, 0, 0, 20, 20)
 * results in a filled rectangle 20 pixels wide and 20 pixels high. Calling
 * gdk_draw_rectangle (window, gc, FALSE, 0, 0, 20, 20) results in an outlined
 * rectangle with corners at (0, 0), (0, 20), (20, 20), and (20, 0), which makes
 * it 21 pixels wide and 21 pixels high. */
int
clip_GDK_DRAWRECTANGLE(ClipMachine * cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        filled = BOOL_OPTION(cm,3,TRUE);
	gint             x = _clip_parni(cm,4);
	gint             y = _clip_parni(cm,5);
	gint         width = _clip_parni(cm,6);
	gint        height = _clip_parni(cm,7);
	GdkDrawable *drw = NULL;
	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKOPT(3,LOGICAL_t); CHECKOPT(4,NUMERIC_t);  CHECKOPT(5,NUMERIC_t);
	CHECKOPT(6,NUMERIC_t);  CHECKOPT(7,NUMERIC_t);
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_rectangle(drw, GDK_GC(cgc->object), filled, x,y, width,height);
	return 0;
err:
	return 1;
}
/*
gc : a GdkGC.
filled : TRUE if the arc should be filled, producing a 'pie slice'.
x : the x coordinate of the left edge of the bounding rectangle.
y : the y coordinate of the top edge of the bounding rectangle.
width : the width of the bounding rectangle.
height : the height of the bounding rectangle.
angle1 : the start angle of the arc, relative to the 3 o'clock position, counter-clockwise, in 1/64ths of a degree.
angle2 : the end angle of the arc, relative to angle1, in 1/64ths of a degree.
*/

int
clip_GDK_DRAWARC(ClipMachine * cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        filled = BOOL_OPTION(cm,3,TRUE);
	gint             x = _clip_parni(cm,4);
	gint             y = _clip_parni(cm,5);
	gint         width = _clip_parni(cm,6);
	gint        height = _clip_parni(cm,7);
	gint        angle1 = _clip_parni(cm,8);
	gint        angle2 = _clip_parni(cm,9);
	GdkDrawable *drw = NULL;
	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKOPT(3,LOGICAL_t); CHECKOPT(4,NUMERIC_t);  CHECKOPT(5,NUMERIC_t);
	CHECKOPT(6,NUMERIC_t);  CHECKOPT(7,NUMERIC_t);
	CHECKOPT(8,NUMERIC_t);  CHECKOPT(9,NUMERIC_t);
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_arc(drw, GDK_GC(cgc->object), filled,
		x, y, width, height, angle1, angle2);
	return 0;
err:
	return 1;
}

/* Alena */
int
clip_GDK_DRAWPOINT(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	gint             x = _clip_parni(cm,3);
	gint             y = _clip_parni(cm,4);
	GdkDrawable *drw = NULL;

	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKARG(3,NUMERIC_t);  CHECKARG(4,NUMERIC_t);

	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_point(drw, GDK_GC(cgc->object), x, y);
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWPOINTS(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
        ClipVar      *carr = _clip_spar(cm, 3);
	GdkDrawable   *drw = NULL;
        GdkPoint       *gp = NULL;
        ClipArrVar    *cgp = NULL;
        int              i ;

	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKARG(3,ARRAY_t);

        cgp = (ClipArrVar*)_clip_vptr(carr);
	gp = malloc(cgp->count * sizeof(GdkPoint));
	for(i=0; i<cgp->count; i++)
        {
        	ClipArrVar *ca;
        	if (cgp->items[i].t.type != ARRAY_t)
                	goto err;
        	ca = (ClipArrVar*)_clip_vptr(((ClipVar*)&cgp->items[i]));
        	gp[i].x = (gint)((ClipVar*)&ca->items[0])->n.d;
        	gp[i].y = (gint)((ClipVar*)&ca->items[1])->n.d;
	}
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_points(drw, GDK_GC(cgc->object), gp, cgp->count);
	free(gp);
	return 0;
err:
	return 1;
}
/* Draws a line, using the foreground color and other attributes of the GdkGC. */
int
clip_GDK_DRAWLINE(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	gint            x1 = _clip_parni(cm,3);
	gint            y1 = _clip_parni(cm,4);
	gint            x2 = _clip_parni(cm,5);
	gint            y2 = _clip_parni(cm,6);
	GdkDrawable *drw = NULL;

	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKOPT(3,NUMERIC_t);  CHECKOPT(4,NUMERIC_t);
	CHECKOPT(5,NUMERIC_t);  CHECKOPT(6,NUMERIC_t);

	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_line(drw, GDK_GC(cgc->object), x1, y1, x2, y2);
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWLINES(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
        ClipVar      *carr = _clip_spar(cm, 3);
	GdkDrawable   *drw = NULL;
        GdkPoint       *gp = NULL;
        ClipArrVar    *cgp ;
        int              i ;

	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKARG(3,ARRAY_t);

        cgp = (ClipArrVar*)_clip_vptr(carr);
	gp = malloc(cgp->count * sizeof(GdkPoint));
	for(i=0; i<cgp->count; i++)
        {
        	ClipArrVar *ca;
        	if (cgp->items[i].t.type != ARRAY_t)
                	goto err;
        	ca = (ClipArrVar*)_clip_vptr(((ClipVar*)&cgp->items[i]));
        	gp[i].x = (gint)((ClipVar*)&ca->items[0])->n.d;
        	gp[i].y = (gint)((ClipVar*)&ca->items[1])->n.d;
	}
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_lines(drw, GDK_GC(cgc->object), gp, cgp->count);
	free(gp);
	return 0;
err:
	return 1;
}
/* Draws a number of characters in the given font or fontset. */
int
clip_GDK_DRAWTEXT(ClipMachine *cm)
{
	C_widget      *cwid = _fetch_cw_arg(cm);
	C_object       *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object      *font = _fetch_cobject(cm,_clip_spar(cm,3));
	gint              x = _clip_parni(cm,4);
	gint              y = _clip_parni(cm,5);
        gchar         *text = _clip_parc(cm,6);
	gint         length = _clip_parni(cm,7);
	GdkDrawable    *drw = NULL;
	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKOPT2(3,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_FONT(font));
	CHECKOPT(4,NUMERIC_t);  CHECKOPT(5,NUMERIC_t);
	CHECKOPT(6,CHARACTER_t);  CHECKOPT(7,NUMERIC_t);
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	LOCALE_TO_UTF(text);
	gdk_draw_text(drw, GDK_FONT(font->object), GDK_GC(cgc->object), x, y, text, length);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWPIXMAP(ClipMachine * cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	C_widget     *cpix = _fetch_cwidget(cm,_clip_spar(cm,3));
	gint          xsrc = _clip_parni(cm,4);
	gint          ysrc = _clip_parni(cm,5);
	gint         xdest = _clip_parni(cm,6);
	gint         ydest = _clip_parni(cm,7);
	gint         width = _clip_parni(cm,8);
	gint        height = _clip_parni(cm,9);
	GdkDrawable *drw = NULL;

	CHECKARG2(1,NUMERIC_t,MAP_t); CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKARG2(3,NUMERIC_t,MAP_t); CHECKCWID(cpix,GTK_IS_WIDGET);
	CHECKARG(4,NUMERIC_t);  CHECKARG(5,NUMERIC_t);
	CHECKARG(6,NUMERIC_t);  CHECKARG(7,NUMERIC_t);
	CHECKARG(8,NUMERIC_t);  CHECKARG(9,NUMERIC_t);
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget))
		drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_pixmap(drw, GDK_GC(cgc->object), GTK_PIXMAP(cpix->widget)->pixmap, xsrc, ysrc, xdest, ydest, width,height);
	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 2)

int
clip_GDK_DRAWPIXBUF(ClipMachine * cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object     *cpix = _fetch_cobject(cm,_clip_spar(cm,3));
	gint          xsrc = _clip_parni(cm,4);
	gint          ysrc = _clip_parni(cm,5);
	gint         xdest = _clip_parni(cm,6);
	gint         ydest = _clip_parni(cm,7);
	gint         width = _clip_parni(cm,8);
	gint        height = _clip_parni(cm,9);
        GdkRgbDither   dit = _clip_parni(cm, 10);
        gint          xdit = _clip_parni(cm, 11);
        gint          ydit = _clip_parni(cm, 12);
	GdkDrawable *drw = NULL;

	CHECKARG2(1,NUMERIC_t,MAP_t); CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKARG2(3,NUMERIC_t,MAP_t); CHECKCOBJ(cpix,GDK_IS_PIXBUF(cpix->object));
	CHECKARG(4,NUMERIC_t);  CHECKARG(5,NUMERIC_t);
	CHECKARG(6,NUMERIC_t);  CHECKARG(7,NUMERIC_t);
	CHECKARG(8,NUMERIC_t);  CHECKARG(9,NUMERIC_t);
	CHECKARG(10,NUMERIC_t);  CHECKARG(11,NUMERIC_t);
	CHECKARG(12,NUMERIC_t);
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget))
		drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_pixbuf(drw, GDK_GC(cgc->object), GDK_PIXBUF(cpix->object),
			xsrc, ysrc, xdest, ydest, width,height,
			dit, xdit, ydit);
	return 0;
err:
	return 1;
}

#endif

int
clip_GDK_DRAWSEGMENTS(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
        ClipVar      *carr = _clip_spar(cm, 3);
	GdkDrawable   *drw = NULL;
        GdkSegment   *segm = NULL;
        ClipArrVar    *cgp ;
        int              i ;

	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKARG(3,ARRAY_t);

        cgp = (ClipArrVar*)_clip_vptr(carr);
	segm = malloc(cgp->count * sizeof(GdkSegment));
	for(i=0; i<cgp->count; i++)
        {
        	ClipArrVar *ca;
        	if (cgp->items[i].t.type != ARRAY_t)
                	goto err;
        	ca = (ClipArrVar*)_clip_vptr(((ClipVar*)&cgp->items[i]));
        	segm[i].x1 = (gint)((ClipVar*)&ca->items[0])->n.d;
        	segm[i].y1 = (gint)((ClipVar*)&ca->items[1])->n.d;
        	segm[i].x2 = (gint)((ClipVar*)&ca->items[2])->n.d;
        	segm[i].y2 = (gint)((ClipVar*)&ca->items[3])->n.d;
	}
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_segments(drw, GDK_GC(cgc->object), segm, cgp->count);
	free(segm);
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWPOLYGON(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        filled = BOOL_OPTION(cm,3,TRUE);
        ClipVar      *carr = _clip_spar(cm, 4);
	GdkDrawable   *drw = NULL;
        GdkPoint       *gp = NULL;
        ClipArrVar    *cgp = NULL;
        int              i ;

	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t); CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKOPT(3, LOGICAL_t);
	CHECKARG(4,ARRAY_t);

        cgp = (ClipArrVar*)_clip_vptr(carr);
	gp = malloc(cgp->count * sizeof(GdkPoint));
	for(i=0; i<cgp->count; i++)
        {
        	ClipArrVar *ca;
        	if (cgp->items[i].t.type != ARRAY_t)
                	goto err;
        	ca = (ClipArrVar*)_clip_vptr(((ClipVar*)&cgp->items[i]));
        	gp[i].x = (gint)((ClipVar*)&ca->items[0])->n.d;
        	gp[i].y = (gint)((ClipVar*)&ca->items[1])->n.d;
	}
	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;
	gdk_draw_polygon(drw, GDK_GC(cgc->object), filled, gp, cgp->count);
	free(gp);
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWLAYOUTLINE(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	gint             x = _clip_parni(cm,3);
	gint             y = _clip_parni(cm,4);
        C_object   *cpango = _fetch_cobject(cm, _clip_spar(cm, 5));

	GdkDrawable *drw = NULL;
	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT2(2,NUMERIC_t,MAP_t);
	CHECKOPT2(3,NUMERIC_t,MAP_t);
	CHECKOPT(4,NUMERIC_t);
        CHECKCOBJ(cpango, GTK_IS_PANGO_LAYOUT_LINE(cpango	));

	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;

	gdk_draw_layout_line(drw, GDK_GC(cgc->object),
				 x, y, (PangoLayoutLine *)(cpango->object));
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWLAYOUTLINEWITHCOLORS(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	gint             x = _clip_parni(cm,3);
	gint             y = _clip_parni(cm,4);
        C_object   *cpango = _fetch_cobject(cm, _clip_spar(cm, 5));
        ClipVar    *color1 = _clip_spar(cm, 6);
        ClipVar    *color2 = _clip_spar(cm, 7);
        GdkColor    backgr, foregr;

	GdkDrawable *drw = NULL;
	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t);
	CHECKARG(3,NUMERIC_t);
	CHECKARG(4,NUMERIC_t);
        CHECKCOBJ(cpango, GTK_IS_PANGO_LAYOUT_LINE(cpango));
        CHECKARG(6, MAP_t);
        CHECKARG(7, MAP_t);

	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;

	_map_colors_to_gdk(cm, color1, &foregr);
	_map_colors_to_gdk(cm, color2, &backgr);
	gdk_draw_layout_line_with_colors(drw, GDK_GC(cgc->object),
				 x, y, (PangoLayoutLine *)(cpango->object),
				 &foregr, &backgr );
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWDRAWABLE(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	C_widget     *csrc = _fetch_cwidget(cm, _clip_spar(cm, 3));
	gint          xsrc = _clip_parni(cm,4);
	gint          ysrc = _clip_parni(cm,5);
	gint         xdest = _clip_parni(cm,6);
	gint         ydest = _clip_parni(cm,7);
	gint         width = _clip_parni(cm,8);
	gint        height = _clip_parni(cm,9);

	GdkDrawable *drw = NULL;
	GdkDrawable *src = NULL;
	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKCWID(csrc,GTK_IS_WIDGET);
	CHECKARG2(2,NUMERIC_t,MAP_t);
	CHECKARG2(3,NUMERIC_t,MAP_t);
	CHECKARG(4,NUMERIC_t);
	CHECKARG(5,NUMERIC_t);
	CHECKARG(6,NUMERIC_t);
	CHECKARG(7,NUMERIC_t);
	CHECKARG(8,NUMERIC_t);
	CHECKARG(9,NUMERIC_t);

	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;

	src = csrc->widget->window;
	if (GTK_IS_PIXMAP(csrc->widget)) src = GTK_PIXMAP(csrc->widget)->pixmap;

	gdk_draw_drawable(drw, GDK_GC(cgc->object), src,
				 xsrc, ysrc, xdest, ydest, width, height);
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAWIMAGE(ClipMachine *cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
	C_object      *cgc = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object     *cimg = _fetch_cobject(cm, _clip_spar(cm, 3));
	gint          xsrc = _clip_parni(cm,4);
	gint          ysrc = _clip_parni(cm,5);
	gint         xdest = _clip_parni(cm,6);
	gint         ydest = _clip_parni(cm,7);
	gint         width = _clip_parni(cm,8);
	gint        height = _clip_parni(cm,9);

	GdkDrawable *drw = NULL;
	GdkImage    *img = NULL;
	CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKCOBJ(cimg,GDK_IS_IMAGE(cimg->object));
	CHECKARG2(2,NUMERIC_t,MAP_t);
	CHECKARG2(3,NUMERIC_t,MAP_t);
	CHECKARG(4,NUMERIC_t);
	CHECKARG(5,NUMERIC_t);
	CHECKARG(6,NUMERIC_t);
	CHECKARG(7,NUMERIC_t);
	CHECKARG(8,NUMERIC_t);
	CHECKARG(9,NUMERIC_t);

	drw = cwid->widget->window;
	if (GTK_IS_PIXMAP(cwid->widget)) drw = GTK_PIXMAP(cwid->widget)->pixmap;

	img = GDK_IMAGE(cimg->object);

	gdk_draw_image(drw, GDK_GC(cgc->object), img,
				 xsrc, ysrc, xdest, ydest, width, height);
	return 0;
err:
	return 1;
}


