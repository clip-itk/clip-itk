/*
    Copyright (C) 2004  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
/* Signals table */
static SignalTable color_button_signals[] =
{
	{"color-set",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_COLOR_SET_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register widget signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_color_button() { return GTK_TYPE_COLOR_BUTTON; }
long _clip_type_color_button() { return GTK_WIDGET_COLOR_BUTTON; }
const char * _clip_type_name_color_button() { return "GTK_WIDGET_COLOR_BUTTON"; }

int
clip_INIT___COLORBUTTON(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_color_button, _clip_type_name_color_button, _gtk_type_color_button,  _gtk_type_button, color_button_signals);
	return 0;
}
/**********************************************************/

int
clip_GTK_COLORBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);

	wid = gtk_color_button_new();

	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONNEWWITHCOLOR(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
        ClipVar *cclr  = _clip_spar(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;
        GdkColor color;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, MAP_t);

	_map_colors_to_gdk(cm, cclr, &color);

	wid = gtk_color_button_new_with_color(&color);

	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONSETCOLOR(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        ClipVar *cclr  = _clip_spar(cm, 2);
        GdkColor color;

	CHECKCWID(cbtn,GTK_IS_COLOR_BUTTON);
        CHECKARG(2, MAP_t);

	_map_colors_to_gdk(cm, cclr, &color);

	gtk_color_button_set_color(GTK_COLOR_BUTTON(cbtn->widget), &color);
	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONGETCOLOR(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        ClipVar  *cclr = RETPTR(cm);
        GdkColor  color;

	CHECKCWID(cbtn,GTK_IS_COLOR_BUTTON);

	gtk_color_button_get_color(GTK_COLOR_BUTTON(cbtn->widget), &color);
        _gdk_color_to_map(cm, color, cclr);

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONSETALPHA(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        guint16  alpha = _clip_parni(cm, 2);

	CHECKCWID(cbtn,GTK_IS_COLOR_BUTTON);
        CHECKARG(2, NUMERIC_t);


	gtk_color_button_set_alpha(GTK_COLOR_BUTTON(cbtn->widget), alpha);

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONGETALPHA(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);

	CHECKCWID(cbtn,GTK_IS_COLOR_BUTTON);

	_clip_retni(cm, gtk_color_button_get_alpha(GTK_COLOR_BUTTON(cbtn->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONSETUSEALPHA(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gboolean alpha = _clip_parl(cm, 2);

	CHECKCWID(cbtn,GTK_IS_COLOR_BUTTON);
        CHECKARG(2, LOGICAL_t);


	gtk_color_button_set_use_alpha(GTK_COLOR_BUTTON(cbtn->widget), alpha);

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONGETUSEALPHA(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);

	CHECKCWID(cbtn,GTK_IS_COLOR_BUTTON);

	_clip_retl(cm, gtk_color_button_get_use_alpha(GTK_COLOR_BUTTON(cbtn->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONSETTITLE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gchar   *title = _clip_parc(cm, 2);

	CHECKCWID(cbtn,GTK_IS_COLOR_BUTTON);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(title);

	gtk_color_button_set_title(GTK_COLOR_BUTTON(cbtn->widget), title);
	FREE_TEXT(title);
	return 0;
err:
	return 1;
}

int
clip_GTK_COLORBUTTONGETTITLE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gchar   *title ;

	CHECKCWID(cbtn,GTK_IS_COLOR_BUTTON);


	title = (gchar *)gtk_color_button_get_title(GTK_COLOR_BUTTON(cbtn->widget));
	LOCALE_FROM_UTF(title);
	_clip_retc(cm, title);
	FREE_TEXT(title);
	return 0;
err:
	return 1;
}
