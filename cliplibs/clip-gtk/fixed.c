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

/*********************** SIGNALS **************************/

/* Fixed has no signals */

/**********************************************************/

/* Register Fixed in global table */
CLIP_DLLEXPORT GtkType _gtk_type_fixed() { return GTK_TYPE_FIXED; }
long _clip_type_fixed() { return GTK_WIDGET_FIXED; }
const char * _clip_type_name_fixed() { return "GTK_WIDGET_FIXED"; }

int
clip_INIT___FIXED(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_fixed, _clip_type_name_fixed, _gtk_type_fixed, _gtk_type_container, NULL);
	return 0;
}
int
clip_GTK_FIXEDNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_fixed_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Adds a widget to a GtkFixed container at the given position. */
int
clip_GTK_FIXEDPUT(ClipMachine * cm)
{
	C_widget *cfix = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        gint x = _clip_parni(cm,3);
        gint y = _clip_parni(cm,4);
	CHECKARG2(2,MAP_t,NUMERIC_t);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
        CHECKCWID(cfix,GTK_IS_FIXED); CHECKCWID(cwid,GTK_IS_WIDGET);
        if (_clip_parinfo(cm,3) == UNDEF_t) x = cwid->widget->allocation.x;
        if (_clip_parinfo(cm,4) == UNDEF_t) y = cwid->widget->allocation.y;
        gtk_fixed_put(GTK_FIXED(cfix->widget), cwid->widget, x,y);

	return 0;
err:
	return 1;
}

/* Moves a child of a GtkFixed container to the given position. */
int
clip_GTK_FIXEDMOVE(ClipMachine * cm)
{
	C_widget *cfix = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        gint x = _clip_parni(cm,3);
        gint y = _clip_parni(cm,4);
	CHECKARG2(2,MAP_t,NUMERIC_t);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
        CHECKCWID(cfix,GTK_IS_FIXED); CHECKCWID(cwid,GTK_IS_WIDGET);
        if (_clip_parinfo(cm,3) == UNDEF_t) x = cwid->widget->allocation.x;
        if (_clip_parinfo(cm,4) == UNDEF_t) y = cwid->widget->allocation.y;
        gtk_fixed_move(GTK_FIXED(cfix->widget), cwid->widget, x,y);

	return 0;
err:
	return 1;
}

