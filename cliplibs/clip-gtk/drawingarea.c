/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/**********************************************************/

/*            Drawing area has no own signals             */

/**********************************************************/

/* Register drawing area in global table */
CLIP_DLLEXPORT GtkType _gtk_type_drawing_area() { return GTK_TYPE_DRAWING_AREA; }
long _clip_type_drawing_area() { return GTK_WIDGET_DRAWING_AREA; }
const char * _clip_type_name_drawing_area() { return "GTK_WIDGET_DRAWING_AREA"; }

int
clip_INIT___DRAWINGAREA(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_drawing_area, _clip_type_name_drawing_area, _gtk_type_drawing_area,  _gtk_type_widget, NULL);
	return 0;
}
/**********************************************************/

/**** Drawing area constructor ****/
int
clip_GTK_DRAWINGAREANEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

        wid = gtk_drawing_area_new();
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/


/* Set the size that the drawing area will request in response to a "size_request"
 * signal. The drawing area may actually be allocated a size larger than this
 * depending on how it is packed within the enclosing containers. */
int
clip_GTK_DRAWINGAREASIZE(ClipMachine * cm)
{
	C_widget  *cda = _fetch_cw_arg(cm);
        guint    width = _clip_parni(cm,2);
        guint   height = _clip_parni(cm,3);
        CHECKCWID(cda,GTK_IS_DRAWING_AREA);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_drawing_area_size(GTK_DRAWING_AREA(cda->widget), width, height);
	return 0;
err:
	return 1;
}
