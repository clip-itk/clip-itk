/*
    Copyright (C) 2001 - 2004  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    	      Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/****           Rulers has no own signals              ****/

/**********************************************************/

/* Register Ruler in global table */
CLIP_DLLEXPORT GtkType _gtk_type_ruler() { return GTK_TYPE_RULER; }
CLIP_DLLEXPORT GtkType _gtk_type_hruler() { return gtk_hruler_get_type(); }
CLIP_DLLEXPORT GtkType _gtk_type_vruler() { return gtk_vruler_get_type(); }

long _clip_type_ruler() { return GTK_WIDGET_RULER; }
long _clip_type_hruler() { return GTK_WIDGET_HRULER; }
long _clip_type_vruler() { return GTK_WIDGET_VRULER; }

const char * _clip_type_name_ruler()  { return "GTK_WIDGET_RULER"; }
const char * _clip_type_name_hruler() { return "GTK_WIDGET_HRULER"; }
const char * _clip_type_name_vruler() { return "GTK_WIDGET_VRULER"; }

int
clip_INIT___RULER(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_ruler,  _clip_type_name_ruler,  _gtk_type_ruler, _gtk_type_widget, NULL);
	_wtype_table_put(_clip_type_hruler, _clip_type_name_hruler, _gtk_type_hruler, _gtk_type_ruler, NULL);
	_wtype_table_put(_clip_type_vruler, _clip_type_name_vruler, _gtk_type_vruler, _gtk_type_ruler, NULL);
	return 0;
}

int
clip_GTK_HRULERNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_hruler_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_VRULERNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_vruler_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* This calls the GTKMetricType to set the ruler to units defined.
 * Available units are GTK_PIXELS, GTK_INCHES, or GTK_CENTIMETERS.
 * The default unit of measurement is GTK_PIXELS. */
int
clip_GTK_RULERSETMETRIC(ClipMachine * cm)
{
	C_widget       *crul = _fetch_cw_arg(cm);
        GtkMetricType metric = _clip_parni(cm,2);
        CHECKCWID(crul,GTK_IS_RULER);
	CHECKOPT(2,NUMERIC_t);
        gtk_ruler_set_metric(GTK_RULER(crul->widget), metric);
	return 0;
err:
	return 1;
}

/* This sets the range of the ruler using gfloat lower,
 * gfloat upper, gfloat position, and gfloat max_size. */
int
clip_GTK_RULERSETRANGE(ClipMachine * cm)
{
	C_widget   *crul = _fetch_cw_arg(cm);
        gdouble    lower = _clip_parnd(cm,2);
        gdouble    upper = _clip_parnd(cm,3);
        gdouble position = _clip_parnd(cm,4);
        gdouble max_size = _clip_parnd(cm,5);
        CHECKCWID(crul,GTK_IS_RULER);
	CHECKARG(2,NUMERIC_t); CHECKARG(3,NUMERIC_t);
	CHECKARG(4,NUMERIC_t); CHECKARG(5,NUMERIC_t);
        gtk_ruler_set_range(GTK_RULER(crul->widget), lower, upper, position, max_size);
	return 0;
err:
	return 1;
}

int
clip_GTK_RULERGETMETRIC(ClipMachine * cm)
{
	C_widget       *crul = _fetch_cw_arg(cm);
        CHECKCWID(crul,GTK_IS_RULER);
        _clip_retni(cm, (int)gtk_ruler_get_metric(GTK_RULER(crul->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_RULERGETRANGE(ClipMachine * cm)
{
	C_widget   *crul = _fetch_cw_arg(cm);
        gdouble    lower ;
        gdouble    upper ;
        gdouble position ;
        gdouble max_size ;
        CHECKCWID(crul,GTK_IS_RULER);
        gtk_ruler_get_range(GTK_RULER(crul->widget), &lower, &upper,
        	&position, &max_size);

	_clip_stornd(cm, lower, 2, 0);
        _clip_stornd(cm, upper, 3, 0);
        _clip_stornd(cm, position, 4, 0);
        _clip_stornd(cm, max_size, 5, 0);
	return 0;
err:
	return 1;
}

