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
/****            Scrollbars has no signals             ****/
/**********************************************************/

/* Register menu item signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_scrollbar()  { return GTK_TYPE_SCROLLBAR; }
CLIP_DLLEXPORT GtkType _gtk_type_hscrollbar() { return GTK_TYPE_HSCROLLBAR; }
CLIP_DLLEXPORT GtkType _gtk_type_vscrollbar() { return GTK_TYPE_VSCROLLBAR; }

long _clip_type_scrollbar()  { return GTK_WIDGET_SCROLLBAR; }
long _clip_type_hscrollbar() { return GTK_WIDGET_HSCROLLBAR; }
long _clip_type_vscrollbar() { return GTK_WIDGET_VSCROLLBAR; }

const char * _clip_type_name_scrollbar()  { return "GTK_WIDGET_SCROLLBAR"; }
const char * _clip_type_name_hscrollbar() { return "GTK_WIDGET_HSCROLLBAR"; }
const char * _clip_type_name_vscrollbar() { return "GTK_WIDGET_VSCROLLBAR"; }

int
clip_INIT___SCROLLBAR(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_scrollbar,  _clip_type_name_scrollbar,  _gtk_type_scrollbar, _gtk_type_range, NULL);
	_wtype_table_put(_clip_type_hscrollbar, _clip_type_name_hscrollbar, _gtk_type_hscrollbar, _gtk_type_scrollbar, NULL);
	_wtype_table_put(_clip_type_vscrollbar, _clip_type_name_vscrollbar, _gtk_type_vscrollbar, _gtk_type_scrollbar, NULL);
	return 0;
}
/**********************************************************/

/****  Horizontal scrollbar constructor ****/
int
clip_GTK_HSCROLLBARNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	GtkAdjustment *adj;
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);

        adj = cadj ? GTK_ADJUSTMENT(cadj->widget) : NULL;
	wid = gtk_hscrollbar_new(adj);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/****  Vertical scrollbar constructor ****/
int
clip_GTK_VSCROLLBARNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	GtkAdjustment *adj;
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);

        adj = cadj ? GTK_ADJUSTMENT(cadj->widget) : NULL;
	wid = gtk_vscrollbar_new(adj);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

