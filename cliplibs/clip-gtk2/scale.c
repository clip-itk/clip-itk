/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/****            Scale has no own signals              ****/

/**********************************************************/

/* Register Scale in global table */
CLIP_DLLEXPORT GtkType _gtk_type_scale() { return GTK_TYPE_SCALE; }
CLIP_DLLEXPORT GtkType _gtk_type_hscale() { return gtk_hscale_get_type(); }
CLIP_DLLEXPORT GtkType _gtk_type_vscale() { return gtk_vscale_get_type(); }

long _clip_type_scale() { return GTK_WIDGET_SCALE; }
long _clip_type_hscale() { return GTK_WIDGET_HSCALE; }
long _clip_type_vscale() { return GTK_WIDGET_VSCALE; }

const char * _clip_type_name_scale()  { return "GTK_WIDGET_SCALE"; }
const char * _clip_type_name_hscale() { return "GTK_WIDGET_HSCALE"; }
const char * _clip_type_name_vscale() { return "GTK_WIDGET_VSCALE"; }

int
clip_INIT___SCALE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_scale,  _clip_type_name_scale,  _gtk_type_scale, _gtk_type_range, NULL);
	_wtype_table_put(_clip_type_hscale, _clip_type_name_hscale, _gtk_type_hscale, _gtk_type_scale, NULL);
	_wtype_table_put(_clip_type_vscale, _clip_type_name_vscale, _gtk_type_vscale, _gtk_type_scale, NULL);
	return 0;
}

int
clip_GTK_HSCALENEW(ClipMachine * cm)
{
	ClipVar * cv    = _clip_spar(cm, 1);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
        GtkAdjustment *adj;
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);

        adj = cadj ? GTK_ADJUSTMENT(cadj->widget) : NULL;
	wid = gtk_hscale_new(adj);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_VSCALENEW(ClipMachine * cm)
{
	ClipVar * cv    = _clip_spar(cm, 1);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
        GtkAdjustment *adj;
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);

        adj = cadj ? GTK_ADJUSTMENT(cadj->widget) : NULL;
	wid = gtk_vscale_new(adj);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_SCALESETADJUSTMENT(ClipMachine * cm)
{
	C_widget *cscale = _fetch_cw_arg(cm);
	C_widget  * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
        CHECKCWID(cscale,GTK_IS_SCALE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);
	gtk_widget_set(cscale->widget, "adjustment", GTK_ADJUSTMENT(cadj->widget), NULL);
	return 0;
err:
	return 1;
}

int
clip_GTK_SCALEGETADJUSTMENT(ClipMachine * cm)
{
	C_widget *cscale = _fetch_cw_arg(cm);
	GtkAdjustment  * adj;
        C_widget * cadj;
        CHECKCWID(cscale,GTK_IS_SCALE);

        adj = GTK_RANGE(&GTK_SCALE(cscale->widget)->range)->adjustment;
	cadj = _list_get_cwidget(cm,adj);
	if (!cadj) cadj = _register_widget(cm,(GtkWidget*)adj,NULL);
	if (cadj) _clip_mclone(cm,RETPTR(cm),&cadj->obj);

	return 0;
err:
	return 1;
}

/* Sets the number of decimal places that are displayed in the value. */
int
clip_GTK_SCALESETDIGITS(ClipMachine * cm)
{
	C_widget     *cscale = _fetch_cw_arg(cm);
        gint          digits = _clip_parni(cm,2);
        CHECKCWID(cscale,GTK_IS_SCALE);
	CHECKOPT(2,NUMERIC_t);
        gtk_scale_set_digits(GTK_SCALE(cscale->widget), digits);
	return 0;
err:
	return 1;
}

int
clip_GTK_SCALEGETDIGITS(ClipMachine * cm)
{
	C_widget     *cscale = _fetch_cw_arg(cm);
        CHECKCWID(cscale,GTK_IS_SCALE);
        _clip_retni(cm,GTK_SCALE(cscale->widget)->digits);
	return 0;
err:
	return 1;
}

/* Specifies whether the current value is displayed as a string next to the slider. */
int
clip_GTK_SCALESETDRAWVALUE(ClipMachine * cm)
{
	C_widget     *cscale = _fetch_cw_arg(cm);
        gboolean  draw_value = _clip_parni(cm,2);
        CHECKCWID(cscale,GTK_IS_SCALE);
	CHECKOPT(2,NUMERIC_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) draw_value = TRUE;
        gtk_scale_set_draw_value(GTK_SCALE(cscale->widget), draw_value);
	return 0;
err:
	return 1;
}

int
clip_GTK_SCALEGETDRAWVALUES(ClipMachine * cm)
{
	C_widget     *cscale = _fetch_cw_arg(cm);
        CHECKCWID(cscale,GTK_IS_SCALE);
        _clip_retl(cm, GTK_SCALE(cscale->widget)->draw_value);
	return 0;
err:
	return 1;
}

/* Sets the position in which the current value is displayed. */
int
clip_GTK_SCALESETVALUEPOS(ClipMachine * cm)
{
	C_widget     *cscale = _fetch_cw_arg(cm);
        GtkPositionType  pos = _clip_parni(cm,2);
        CHECKCWID(cscale,GTK_IS_SCALE);
	CHECKOPT(2,NUMERIC_t);
        gtk_scale_set_value_pos(GTK_SCALE(cscale->widget), pos);
	return 0;
err:
	return 1;
}

int
clip_GTK_SCALEGETVALUEPOS(ClipMachine * cm)
{
	C_widget     *cscale = _fetch_cw_arg(cm);
        CHECKCWID(cscale,GTK_IS_SCALE);
        _clip_retni(cm, GTK_SCALE(cscale->widget)->value_pos);
	return 0;
err:
	return 1;
}


