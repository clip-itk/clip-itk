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

/****           Paned has no own signals               ****/

/**********************************************************/

/* Register Paned in global table */
CLIP_DLLEXPORT GtkType _gtk_type_paned() { return GTK_TYPE_PANED; }
CLIP_DLLEXPORT GtkType _gtk_type_hpaned() { return gtk_hpaned_get_type(); }
CLIP_DLLEXPORT GtkType _gtk_type_vpaned() { return gtk_vpaned_get_type(); }

long _clip_type_paned() { return GTK_WIDGET_PANED; }
long _clip_type_hpaned() { return GTK_WIDGET_HPANED; }
long _clip_type_vpaned() { return GTK_WIDGET_VPANED; }

const char * _clip_type_name_paned() { return "GTK_WIDGET_PANED"; }
const char * _clip_type_name_hpaned() { return "GTK_WIDGET_HPANED"; }
const char * _clip_type_name_vpaned() { return "GTK_WIDGET_VPANED"; }

int
clip_INIT___PANED(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_paned,  _clip_type_name_paned,  _gtk_type_paned, _gtk_type_container, NULL);
	_wtype_table_put(_clip_type_hpaned, _clip_type_name_hpaned, _gtk_type_hpaned, _gtk_type_paned, NULL);
	_wtype_table_put(_clip_type_vpaned, _clip_type_name_vpaned, _gtk_type_vpaned, _gtk_type_paned, NULL);
	return 0;
}

int
clip_GTK_HPANEDNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_hpaned_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_VPANEDNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_vpaned_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Add a child to the top or left pane with default parameters.
 * This is equivalent to gtk_paned_pack1(paned, FALSE, TRUE); */
int
clip_GTK_PANEDADD1(ClipMachine * cm)
{
	C_widget *cpan = _fetch_cw_arg(cm);
        C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_paned_add1(GTK_PANED(cpan->widget), cwid->widget);
	return 0;
err:
	return 1;
}

/* Add a child to the bottom or right pane with default parameters.
 * This is equivalent to gtk_paned_pack1(paned, FALSE, FALSE); */
int
clip_GTK_PANEDADD2(ClipMachine * cm)
{
	C_widget *cpan = _fetch_cw_arg(cm);
        C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_paned_add2(GTK_PANED(cpan->widget), cwid->widget);
	return 0;
err:
	return 1;
}

/* Add a child to the top or left pane. */
/* paned : a paned widget
   child : the child to add
  resize : should this child expand when the paned widget is resized.
  shrink : can this child be made smaller than its requsition.  */
int
clip_GTK_PANEDPACK1(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
        C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        gboolean resize = _clip_parl(cm,3);
        gboolean shrink = _clip_parl(cm,4);
        CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,LOGICAL_t); CHECKOPT(4,LOGICAL_t);
        if (_clip_parinfo(cm,3)==UNDEF_t) resize = TRUE;
        if (_clip_parinfo(cm,4)==UNDEF_t) shrink = TRUE;
        gtk_paned_pack1(GTK_PANED(cpan->widget), cwid->widget, resize, shrink);
	return 0;
err:
	return 1;
}

/* Add a child to the bottom or right pane. */
int
clip_GTK_PANEDPACK2(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
        C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        gboolean resize = _clip_parl(cm,3);
        gboolean shrink = _clip_parl(cm,4);
        CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,LOGICAL_t); CHECKOPT(4,LOGICAL_t);
        if (_clip_parinfo(cm,3)==UNDEF_t) resize = TRUE;
        if (_clip_parinfo(cm,4)==UNDEF_t) shrink = TRUE;
        gtk_paned_pack2(GTK_PANED(cpan->widget), cwid->widget, resize, shrink);
	return 0;
err:
	return 1;
}

/* Set the width of the gutter. (The area between the two panes). */
int
clip_GTK_PANEDSETGUTTERSIZE(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
	CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG(2,NUMERIC_t);
        gtk_paned_set_gutter_size(GTK_PANED(cpan->widget), _clip_parni(cm,2));
	return 0;
err:
	return 1;
}

#ifndef OS_CYGWIN
int
clip_GTK_PANEDGETGUTTERSIZE(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
        CHECKCWID(cpan,GTK_IS_PANED);
        _clip_retni(cm,GTK_PANED(cpan->widget)->gutter_size);
	return 0;
err:
	return 1;
}
#endif

/* Set the the handle size to size x size pixels. */
int
clip_GTK_PANEDSETHANDLESIZE(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
        guint16    size = _clip_parni(cm,2);
        CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG(2,NUMERIC_t);
        gtk_paned_set_handle_size(GTK_PANED(cpan->widget), size);
	return 0;
err:
	return 1;
}

int
clip_GTK_PANEDGETHANDLESIZE(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
        CHECKCWID(cpan,GTK_IS_PANED);
        _clip_retni(cm,GTK_PANED(cpan->widget)->handle_size);
	return 0;
err:
	return 1;
}

/* Set the position of the separator, as if set by the user. If position is
 * negative, the remembered position is forgotten, and the division is
 * recomputed from the the requisitions of the children. */
int
clip_GTK_PANEDSETPOSITION(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
        gint   position = _clip_parni(cm,2);
        CHECKCWID(cpan,GTK_IS_PANED);
	CHECKOPT(2,NUMERIC_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) position = -1;
        gtk_paned_set_position(GTK_PANED(cpan->widget), position);
	return 0;
err:
	return 1;
}
