/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <string.h>
#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

int
clip_GTK_STYLENEW(ClipMachine * cm)
{
	GtkStyle *style;
        ClipVar *cstyle = RETPTR(cm);

        _clip_map(cm, cstyle);
        style = gtk_style_new();

	_style_to_map(cm, style, cstyle);
	return 0;
}


int
clip_GTK_STYLECOPY(ClipMachine * cm)
{
        ClipVar      *cs = _clip_spar(cm, 1);
        ClipVar  *cstyle = RETPTR(cm);
	GtkStyle *style, *newstyle;

        CHECKARG(1, MAP_t);
        _map_to_style(cm, cs, style);
        newstyle = gtk_style_copy(style);

	_style_to_map(cm, newstyle, cstyle);
	return 0;
err:
	return 1;
}

int
clip_GTK_STYLEATTACH(ClipMachine * cm)
{
        ClipVar     *cs = _clip_spar(cm, 1);
        C_widget  *cwin = _fetch_cwidget(cm, _clip_spar(cm, 2));
        ClipVar *cstyle = RETPTR(cm);
	GtkStyle *style, *newstyle;

        CHECKARG(1, MAP_t);
        CHECKCWID(cwin, GTK_IS_WINDOW);
        _map_to_style(cm, cs, style);
        newstyle = gtk_style_attach(style, GDK_WINDOW(cwin->widget->window));

	_style_to_map(cm, newstyle, cstyle);
	return 0;
err:
	return 1;
}

int
clip_GTK_STYLEDETACH(ClipMachine * cm)
{
        ClipVar     *cs = _clip_spar(cm, 1);
	GtkStyle *style;

        CHECKARG(1, MAP_t);
        _map_to_style(cm, cs, style);
        gtk_style_detach(style);

	return 0;
err:
	return 1;
}

int
clip_GTK_STYLESETBACKGROUND(ClipMachine * cm)
{
        ClipVar     *cs = _clip_spar(cm, 1);
        C_widget  *cwin = _fetch_cwidget(cm, _clip_spar(cm, 2));
        GtkStateType  t = _clip_parni(cm, 3);
	GtkStyle *style;

        CHECKARG(1, MAP_t);
        CHECKCWID(cwin, GTK_IS_WINDOW);
        CHECKARG(3, NUMERIC_t);

        _map_to_style(cm, cs, style);
        gtk_style_set_background(style, GDK_WINDOW(cwin->widget->window), t);

	return 0;
err:
	return 1;
}

int
clip_GTK_STYLEAPPLYDEFAULTBACKGROUND(ClipMachine * cm)
{
        ClipVar     *cs = _clip_spar(cm, 1);
        C_widget  *cwin = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gboolean set_bg = _clip_parl(cm, 3);
        GtkStateType  t = _clip_parni(cm, 4);
        ClipVar     *cv = _clip_spar(cm, 5);
        gint          x = _clip_parni(cm, 6);
        gint          y = _clip_parni(cm, 7);
        gint      width = _clip_parni(cm, 8);
        gint     height = _clip_parni(cm, 9);
	GtkStyle *style;
        GdkRectangle rect;

        CHECKARG(1, MAP_t);
        CHECKCWID(cwin, GTK_IS_WINDOW);
        CHECKARG(3, LOGICAL_t);
        CHECKARG(4, NUMERIC_t);
        CHECKARG(5, MAP_t);
        CHECKARG(6, NUMERIC_t);
        CHECKARG(7, NUMERIC_t);
        CHECKARG(8, NUMERIC_t);
        CHECKARG(9, NUMERIC_t);

        _map_to_style(cm, cs, style);
        _map_put_gdk_rectangle(cm, cv, &rect);
        gtk_style_apply_default_background(style, GDK_WINDOW(cwin->widget->window),
        	set_bg, t, &rect, x, y, width, height);

	return 0;
err:
	return 1;
}

