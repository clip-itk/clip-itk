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
//#include "clip-gdk.h"


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





