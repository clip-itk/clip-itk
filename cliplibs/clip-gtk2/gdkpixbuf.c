/*
    Copyright (C) 2003  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/


/* move defines to clip-gdk.h */
#define GDK_OBJECT_PIXBUF            HASH___GDK_OBJECT_PIXBUF
//#define GDK_PIXBUF(p)             ((GdkPixbuf*)(p))
//#define GDK_IS_PIXBUF(obj)        (obj && ((C_object*)obj)->type == GDK_OBJECT_PIXBUF)
/* end move */



#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <string.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"
//#include "clip-gdk.h"



/*********************** SIGNALS **************************/

/****              Pixbuf has no signal                  ****/

/**********************************************************/

GtkType _gdk_type_pixbuf() { return GDK_TYPE_PIXBUF; }
long _clip_type_pixbuf() { return GDK_OBJECT_PIXBUF; }
const char * _clip_type_name_pixbuf() { return "GDK_OBJECT_PIXBUF"; }

int
clip_INIT___PIXBUF(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_pixbuf, _clip_type_name_pixbuf, _gdk_type_pixbuf, NULL, NULL);
	return 0;
}
/**********************************************************/

/* Create a blank pixbuf with an optimal rowstride and a new buffer */
int
clip_GDK_PIXBUFNEW(ClipMachine * cm)
{
	ClipVar *cv = _clip_spar(cm,1);
	gboolean  has_alpha = _clip_parl(cm,2);
        int bits_per_sample = _clip_parni(cm,3);
        int           width = _clip_parni(cm,4);
        int          height = _clip_parni(cm,5);
	GdkPixbuf  * pixbuf;
	C_object   *cpixbuf;

	CHECKOPT(1,MAP_t); CHECKARG(2,LOGICAL_t);
        CHECKARG(3,NUMERIC_t); CHECKARG(4,NUMERIC_t); CHECKARG(5,NUMERIC_t);

	pixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, has_alpha, bits_per_sample, width, height);
	cpixbuf = _register_object(cm,pixbuf,GDK_TYPE_PIXBUF,cv,NULL);
	if (cpixbuf)
		_clip_mclone(cm,RETPTR(cm),&cpixbuf->obj);

	return 0;
err:
	return 1;
}

/* Copy a pixbuf */

int clip_GDK_PIXBUFCOPY(ClipMachine * cm)
{
	C_object *cpixbufsrc = _fetch_co_arg(cm);
        GdkPixbuf *pixbuf;
        C_object *cpixbuf;

	CHECKCOBJ(cpixbufsrc,GDK_IS_PIXBUF(cpixbuf->object));

	pixbuf = gdk_pixbuf_copy(GDK_PIXBUF(cpixbufsrc->object));
        cpixbuf = _register_object(cm, pixbuf, GDK_OBJECT_PIXBUF, NULL, NULL);
        if (cpixbuf)
        	_clip_mclone(cm, RETPTR(cm), &cpixbuf->obj);
	return 0;
err:
	return 1;
}


int clip_GDK_PIXBUFNEWFROMFILE( ClipMachine * cm )
/* Load image from file
  format permited are : png, jpeg, tiff, gif, xpm, pnm, ras, bmp, xbm and ico
  somes formats depend of how are compiled gdk-pixbuf
*/
{
	char * fname = _clip_parc( cm, 1 );
	GdkPixbuf  * pixbuf;
	C_object   * cpixbuf = NULL ;
        GError     * error = NULL;

	if( ! fname )
return 1;

	pixbuf = gdk_pixbuf_new_from_file( fname, &error );

	if( ! pixbuf )
return 1;

	cpixbuf = _register_object(cm,pixbuf,GDK_TYPE_PIXBUF,NULL,NULL);
	if (cpixbuf)
		_clip_mclone(cm,RETPTR(cm),&cpixbuf->obj);

return 0;
}	/* clip_GDK_PIXBUFNEWFROMFILE() */



int clip_GDK_PIXBUFGETWIDTH( ClipMachine * cm )
/* Return width of image in pixels */
{
	C_object *cpixbufsrc = _fetch_co_arg(cm);

	CHECKCOBJ(cpixbufsrc,GDK_IS_PIXBUF(cpixbufsrc->object));

	_clip_retni( cm, gdk_pixbuf_get_width( GDK_PIXBUF(cpixbufsrc->object)) );

return( 0 );
err:
return( 1 );
}	/* clip_GDK_PIXBUFGETWIDTH() */


int clip_GDK_PIXBUFGETHEIGHT( ClipMachine * cm )
/* Return height of image in pixels. */
{
	C_object *cpixbufsrc = _fetch_co_arg(cm);

	CHECKCOBJ(cpixbufsrc,GDK_IS_PIXBUF(cpixbufsrc->object));

	_clip_retni( cm, gdk_pixbuf_get_height( GDK_PIXBUF(cpixbufsrc->object)) );
return( 0 );
err:
return( 1 );
}	/* clip_GDK_PIXBUFGETHEIGHT() */


int clip_GDK_PIXBUFGETROWSTRIDE( ClipMachine * cm )
/* Return image's rowstride. */
{
	C_object * cpixbufsrc = _fetch_co_arg( cm );
	CHECKCOBJ(cpixbufsrc,GDK_IS_PIXBUF(cpixbufsrc->object));

	_clip_retni( cm, gdk_pixbuf_get_rowstride( GDK_PIXBUF(cpixbufsrc->object)) );
return( 0 );
err:
return( 1 );
}	/* clip_GDK_PIXBUFGETROWSTRIDE() */



int clip_GDK_PIXBUFGETPIXELS( ClipMachine * cm )
/* Return string with the image's pixels. */
{
	gint rowstride, height;

	C_object * cpxbsrc = _fetch_co_arg( cm );
	CHECKCOBJ(cpxbsrc,GDK_IS_PIXBUF(cpxbsrc->object));

	rowstride = gdk_pixbuf_get_rowstride( GDK_PIXBUF(cpxbsrc->object ));
	height = gdk_pixbuf_get_height( GDK_PIXBUF(cpxbsrc->object));
	_clip_retcn( cm, gdk_pixbuf_get_pixels( GDK_PIXBUF(cpxbsrc->object)),
		 rowstride*height );
return( 0 );
err:
return( 1 );
}	/* clip_GDK_PIXBUFGETPIXELS() */


int clip_GDK_PIXBUFCOMPOSITE( ClipMachine * cm )
{
	C_object * cpxbsrc 	= _fetch_co_arg( cm );
	C_object * cpxbdst 	= _fetch_cobject( cm, _clip_spar(cm,2));
	int dest_x		= _clip_parni( cm, 3 );
	int dest_y		= _clip_parni( cm, 4 );
	int dest_width		= _clip_parni( cm, 5 );
	int dest_height		= _clip_parni( cm, 6 );
	double offset_x		= _clip_parnd( cm, 7 );
	double offset_y		= _clip_parnd( cm, 8 );
	double scale_x		= _clip_parnd( cm, 9 );
	double scale_y		= _clip_parnd( cm, 10 );
	GdkInterpType interp_type= INT_OPTION( cm, 11, 0 );
	int overall_alpha	= _clip_parni( cm, 12 );

	CHECKCOBJ(cpxbsrc,GDK_IS_PIXBUF(cpxbsrc->object));
	CHECKCOBJ(cpxbdst,GDK_IS_PIXBUF(cpxbdst->object));
	CHECKARG(3,NUMERIC_t); CHECKARG(4,NUMERIC_t);
        CHECKARG(5,NUMERIC_t); CHECKARG(6,NUMERIC_t);
        CHECKARG(7,NUMERIC_t); CHECKARG(8,NUMERIC_t);
	CHECKARG(9,NUMERIC_t); CHECKARG(10,NUMERIC_t);
        CHECKARG(11,NUMERIC_t); CHECKARG(12,NUMERIC_t);

        gdk_pixbuf_composite(GDK_PIXBUF(cpxbsrc->object),
        	GDK_PIXBUF(cpxbdst->object),
                dest_x,
                dest_y,
                dest_width,
                dest_height,
                offset_x,
                offset_y,
                scale_x,
                scale_y,
                interp_type,
                overall_alpha);


return( 0 );
err:
return( 1 );
}	/* clip_GDK_PIXBUFCOMPOSITE() */


int clip_GDK_PIXBUFCOPYAREA( ClipMachine * cm )
{
	C_object * cpxbsrc 	= _fetch_co_arg( cm );
	int src_x		= _clip_parni( cm, 2 );
	int src_y		= _clip_parni( cm, 3 );
	int width		= _clip_parni( cm, 4 );
	int height		= _clip_parni( cm, 5 );
	C_object * cpxbdst 	= _fetch_cobject( cm, _clip_spar(cm,6));
	int dest_x		= _clip_parnd( cm, 7 );
	int dest_y		= _clip_parnd( cm, 8 );

	CHECKCOBJ(cpxbsrc,GDK_IS_PIXBUF(cpxbsrc->object));
	CHECKARG(2,NUMERIC_t); CHECKARG(3,NUMERIC_t);
        CHECKARG(4,NUMERIC_t); CHECKARG(5,NUMERIC_t);
	CHECKCOBJ(cpxbdst,GDK_IS_PIXBUF(cpxbdst->object));
        CHECKARG(7,NUMERIC_t); CHECKARG(8,NUMERIC_t);


        gdk_pixbuf_copy_area( GDK_PIXBUF( cpxbsrc->object ),
        	src_x,
                src_y,
                width,
                height,
               	GDK_PIXBUF( cpxbdst->object ),
                dest_x,
                dest_y);


return( 0 );
err:
return( 1 );
}	/* clip_GDK_PIXBUFCOPYAREA() */


int clip_GDK_PIXBUFSCALE( ClipMachine * cm )
{
	C_object * cpxbsrc 	= _fetch_co_arg( cm );
	C_object * cpxbdst 	= _fetch_cobject( cm, _clip_spar(cm,2));
	int dest_x		= _clip_parni( cm, 3 );
	int dest_y		= _clip_parni( cm, 4 );
	int dest_width		= _clip_parni( cm, 5 );
	int dest_height		= _clip_parni( cm, 6 );
	double offset_x		= _clip_parnd( cm, 7 );
	double offset_y		= _clip_parnd( cm, 8 );
	double scale_x		= _clip_parnd( cm, 9 );
	double scale_y		= _clip_parnd( cm, 10 );
	GdkInterpType interp_type= INT_OPTION( cm, 11, 0 );

	CHECKCOBJ(cpxbsrc,GDK_IS_PIXBUF(cpxbsrc->object));
	CHECKCOBJ(cpxbdst,GDK_IS_PIXBUF(cpxbdst->object));
	CHECKARG(3,NUMERIC_t); CHECKARG(4,NUMERIC_t);
        CHECKARG(5,NUMERIC_t); CHECKARG(6,NUMERIC_t);
        CHECKARG(7,NUMERIC_t); CHECKARG(8,NUMERIC_t);
	CHECKARG(9,NUMERIC_t); CHECKARG(10,NUMERIC_t);
        CHECKOPT(11,NUMERIC_t);

        gdk_pixbuf_scale( GDK_PIXBUF(cpxbsrc->object),
        	GDK_PIXBUF(cpxbdst->object),
                dest_x, dest_y,
                dest_width, dest_height,
                offset_x, offset_y,
                scale_x, scale_y,
                interp_type);

return( 0 );
err:
return( 1 );
}	/* clip_GDK_PIXBUFSCALE() */


int clip_GDK_PIXBUFSCALESIMPLE( ClipMachine * cm )
{
	C_object * cpxb 	= _fetch_co_arg( cm );
	int dest_width		= _clip_parni( cm, 2 );
	int dest_height		= _clip_parni( cm, 3 );
	GdkInterpType interp_type= INT_OPTION( cm, 4, 0 );
	GdkPixbuf * pxb_dst;
	C_object * cpxb_dst;


	CHECKCOBJ(cpxb,GDK_IS_PIXBUF(cpxb->object));
	CHECKARG(2,NUMERIC_t); CHECKARG(3,NUMERIC_t);
        CHECKOPT(4,NUMERIC_t);


	pxb_dst = gdk_pixbuf_scale_simple( GDK_PIXBUF(cpxb->object),
        	dest_width, dest_height, interp_type);
	if ( pxb_dst ) {
        	cpxb_dst = _register_object(cm, pxb_dst, GDK_OBJECT_PIXBUF, NULL, NULL);
        	if (cpxb_dst)
        		_clip_mclone(cm, RETPTR(cm), &(cpxb_dst->obj));
	}

return( 0 );
err:
return( 1 );
}	/* clip_GDK_PIXBUFSCALESIMPLE() */




