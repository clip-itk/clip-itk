/*
    Copyright (C) 2002  ITK
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

/***             Packer have no signals                 ***/

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_packer() { return GTK_TYPE_PACKER; }
long _clip_type_packer() { return GTK_WIDGET_PACKER; }
const char * _clip_type_name_packer()  { return "GTK_TYPE_PACKER"; }

/* Register packer in global table */
int
clip_INIT___PACKER(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_packer,  _clip_type_name_packer,  _gtk_type_packer,  _gtk_type_container, NULL);
	return 0;
}

/**** ------------------ ****/
/**** PACKER constructor ****/
int
clip_GTK_PACKERNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
        wid = gtk_packer_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_PACKERADDDEFAULTS(ClipMachine * cm)
{
	C_widget   *cpck = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        GtkSideType side = INT_OPTION(cm,3,GTK_SIDE_TOP);
        GtkAnchorType anchor = INT_OPTION(cm,4,GTK_ANCHOR_CENTER);
        GtkPackerOptions options = INT_OPTION(cm,5,GTK_PACK_EXPAND);
        CHECKCWID(cpck,GTK_IS_PACKER);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
        gtk_packer_add_defaults(GTK_PACKER(cpck->widget), cwid->widget,
        	side, anchor, options);
	return 0;
err:
	return 1;
}

int
clip_GTK_PACKERADD(ClipMachine * cm)
{
	C_widget   *cpck = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        GtkSideType side = INT_OPTION(cm,3,GTK_SIDE_TOP);
        GtkAnchorType anchor = INT_OPTION(cm,4,GTK_ANCHOR_CENTER);
        GtkPackerOptions options = INT_OPTION(cm,5,GTK_PACK_EXPAND);
        guint border_width = _clip_parni(cm,6);
        guint pad_x      = _clip_parni(cm,7);
        guint pad_y      = _clip_parni(cm,8);
        guint i_pad_x    = _clip_parni(cm,9);
        guint i_pad_y    = _clip_parni(cm,10);
        CHECKCWID(cpck,GTK_IS_PACKER);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
        CHECKOPT(6,NUMERIC_t); CHECKOPT(7,NUMERIC_t); CHECKOPT(8,NUMERIC_t);
        CHECKOPT(9,NUMERIC_t); CHECKOPT(10,NUMERIC_t);
        gtk_packer_add(GTK_PACKER(cpck->widget), cwid->widget,
        	side, anchor, options, border_width, pad_x, pad_y, i_pad_x, i_pad_y);
	return 0;
err:
	return 1;
}

int
clip_GTK_PACKERREORDERCHILD(ClipMachine * cm)
{
	C_widget   *cpck = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        gint    position = INT_OPTION(cm,3,1);
        CHECKCWID(cpck,GTK_IS_PACKER);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t);
        gtk_packer_reorder_child(GTK_PACKER(cpck->widget), cwid->widget, position);
	return 0;
err:
	return 1;
}

int
clip_GTK_PACKERSETSPACING(ClipMachine * cm)
{
	C_widget   *cpck = _fetch_cw_arg(cm);
        gint     spacing = _clip_parni(cm,2);
        CHECKCWID(cpck,GTK_IS_PACKER);
        CHECKOPT(2,NUMERIC_t);
        gtk_packer_set_spacing(GTK_PACKER(cpck->widget), spacing);
	return 0;
err:
	return 1;
}

int
clip_GTK_PACKERSETDEFAULTBORDERWIDTH(ClipMachine * cm)
{
	C_widget   *cpck = _fetch_cw_arg(cm);
        gint      border = _clip_parni(cm,2);
        CHECKCWID(cpck,GTK_IS_PACKER);
        CHECKOPT(2,NUMERIC_t);
        gtk_packer_set_default_border_width(GTK_PACKER(cpck->widget), border);
	return 0;
err:
	return 1;
}

int
clip_GTK_PACKERSETDEFAULTPAD(ClipMachine * cm)
{
	C_widget   *cpck = _fetch_cw_arg(cm);
        gint       pad_x = _clip_parni(cm,2);
        gint       pad_y = _clip_parni(cm,3);
        CHECKCWID(cpck,GTK_IS_PACKER);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_packer_set_default_pad(GTK_PACKER(cpck->widget), pad_x, pad_y);
	return 0;
err:
	return 1;
}

int
clip_GTK_PACKERSETDEFAULTIPAD(ClipMachine * cm)
{
	C_widget   *cpck = _fetch_cw_arg(cm);
        gint       pad_x = _clip_parni(cm,2);
        gint       pad_y = _clip_parni(cm,3);
        CHECKCWID(cpck,GTK_IS_PACKER);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_packer_set_default_ipad(GTK_PACKER(cpck->widget), pad_x, pad_y);
	return 0;
err:
	return 1;
}

int
clip_GTK_PACKERSETCHILDPACKING(ClipMachine * cm)
{
	C_widget   *cpck = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        GtkSideType side = INT_OPTION(cm,3,GTK_SIDE_TOP);
        GtkAnchorType anchor = INT_OPTION(cm,4,GTK_ANCHOR_CENTER);
        GtkPackerOptions options = INT_OPTION(cm,5,GTK_PACK_EXPAND);
        guint border_width = _clip_parni(cm,6);
        guint pad_x      = _clip_parni(cm,7);
        guint pad_y      = _clip_parni(cm,8);
        guint i_pad_x    = _clip_parni(cm,9);
        guint i_pad_y    = _clip_parni(cm,10);
        CHECKCWID(cpck,GTK_IS_PACKER);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
        CHECKOPT(6,NUMERIC_t); CHECKOPT(7,NUMERIC_t); CHECKOPT(8,NUMERIC_t);
        CHECKOPT(9,NUMERIC_t); CHECKOPT(10,NUMERIC_t);
        gtk_packer_set_child_packing(GTK_PACKER(cpck->widget), cwid->widget,
        	side, anchor, options, border_width, pad_x, pad_y, i_pad_x, i_pad_y);
	return 0;
err:
	return 1;
}

