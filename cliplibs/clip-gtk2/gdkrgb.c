/*
    Copyright (C) 2004  JARA
    Author  : Sergio Zayas <icaro.maneton@lycos.es>
    License : (GPL) http://www.itk.ru/clipper/license.html
    mail : icaro.maneton@lycos.es
*/

#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <string.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"


int clip_GDK_RGBINIT( ClipMachine * cm )
{
	gdk_rgb_init();
return 0;
}

int clip_GDK_DRAWRGBIMAGE( ClipMachine * cm )
{
	C_widget * cwid = _fetch_cw_arg( cm );
	C_object * cgc  = _fetch_cobject( cm, _clip_spar( cm,2));
	gint x		= _clip_parni( cm, 3 );
	gint y 		= _clip_parni( cm, 4 );
	gint width	= _clip_parni( cm, 5 );
	gint height	= _clip_parni( cm, 6 );
	GdkRgbDither dith = INT_OPTION( cm, 7, 0 );
	guchar * rgb = (guchar *) _clip_parc( cm, 8 );
	gint rowstride	= _clip_parni( cm, 9 );

	CHECKARG(1,MAP_t); CHECKARG(2,MAP_t);
        CHECKARG(3,NUMERIC_t); CHECKARG(4,NUMERIC_t); CHECKARG(5,NUMERIC_t);
        CHECKARG(6,NUMERIC_t); CHECKARG(7,NUMERIC_t);
	CHECKARG(8,CHARACTER_t); CHECKARG(9,NUMERIC_t);

	rgb = rgb + rowstride * y + x * 3;

	gdk_draw_rgb_image( (GdkDrawable *) cwid->widget->window,
            GDK_GC( cgc->object ), x, y, width, height, dith, rgb,
            rowstride );

return 0;
err:
return 1;
}	/* clip_GDK_DRAWRGBIMAGE() */



int clip_GDK_DRAWRGBIMAGEDITHALIGN( ClipMachine * cm )
{
	C_widget * cwid = _fetch_cw_arg( cm );
	C_object * cgc  = _fetch_cobject( cm, _clip_spar( cm,2));
	gint x		= _clip_parni( cm, 3 );
	gint y 		= _clip_parni( cm, 4 );
	gint width	= _clip_parni( cm, 5 );
	gint height	= _clip_parni( cm, 6 );
	GdkRgbDither dith = INT_OPTION( cm, 7, 0 );
	guchar * rgb = (guchar *) _clip_parc( cm, 8 );
	gint rowstride	= _clip_parni( cm, 9 );
	gint xdith	= _clip_parni( cm, 10 );
	gint ydith	= _clip_parni( cm, 11 );

	CHECKARG(1,MAP_t); CHECKARG(2,MAP_t);
        CHECKARG(3,NUMERIC_t); CHECKARG(4,NUMERIC_t); CHECKARG(5,NUMERIC_t);
        CHECKARG(6,NUMERIC_t); CHECKARG(7,NUMERIC_t);
	CHECKARG(8,CHARACTER_t); CHECKARG(9,NUMERIC_t);
        CHECKARG(10,NUMERIC_t); CHECKARG(11,NUMERIC_t);

	rgb = rgb + rowstride * y + x * 3;

	gdk_draw_rgb_image_dithalign( (GdkDrawable *) cwid->widget->window,
            GDK_GC( cgc->object ), x, y, width, height, dith, rgb,
            rowstride, xdith, ydith);

return 0;
err:
return 1;
}	/* clip_GDK_DRAWRGBIMAGEDITHALIGN() */



int clip_GDK_PIXBUFRENDERTODRAWABLE( ClipMachine * cm )
{
	C_object     * cpxb = _fetch_co_arg( cm );
        C_widget *cdrawable = _fetch_cwidget(cm, _clip_spar(cm, 2));
	C_object      * cgc = _fetch_cobject( cm, _clip_spar( cm,3));
        int           src_x = _clip_parni(cm, 4);
        int           src_y = _clip_parni(cm, 5);
        int          dest_x = _clip_parni(cm, 6);
        int          dest_y = _clip_parni(cm, 7);
	int           width = _clip_parni(cm, 8);
	int          height = _clip_parni(cm, 9);
        GdkRgbDither dither = _clip_parni(cm, 10);
        int        x_dither = _clip_parnd(cm, 11);
        int        y_dither = _clip_parnd(cm, 12);

	CHECKCOBJ(cpxb,GDK_IS_PIXBUF(cpxb->object));
	CHECKCWID(cdrawable,GTK_IS_DRAWING_AREA);
	CHECKCOBJ(cgc,GDK_IS_GC(cgc->object));
	CHECKARG(4,NUMERIC_t); CHECKARG(5,NUMERIC_t);
	CHECKARG(6,NUMERIC_t); CHECKARG(7,NUMERIC_t);
	CHECKARG(8,NUMERIC_t); CHECKARG(9,NUMERIC_t);
	CHECKARG(10,NUMERIC_t); CHECKARG(11,NUMERIC_t);
	CHECKARG(12,NUMERIC_t);

	gdk_pixbuf_render_to_drawable( GDK_PIXBUF(cpxb->object),
			GDK_DRAWABLE(cdrawable->widget->window),
                        GDK_GC(cgc->object),
        		src_x, src_y, dest_x, dest_y, width, height,
                        dither, x_dither, y_dither);

return 0;
err:
return 1;
}


