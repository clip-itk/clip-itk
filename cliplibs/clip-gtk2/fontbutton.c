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
static SignalTable font_button_signals[] =
{
	{"font-set",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_FONT_SET_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register widget signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_font_button() { return GTK_TYPE_FONT_BUTTON; }
long _clip_type_font_button() { return GTK_WIDGET_FONT_BUTTON; }
const char * _clip_type_name_font_button() { return "GTK_WIDGET_FONT_BUTTON"; }

int
clip_INIT___FONTBUTTON(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_font_button, _clip_type_name_font_button, _gtk_type_font_button,  _gtk_type_button, font_button_signals);
	return 0;
}
/**********************************************************/

int
clip_GTK_FONTBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);

	wid = gtk_font_button_new();

	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_FONTBUTTONNEWWITHFONT(ClipMachine * cm)
{
	ClipVar * cv    = _clip_spar(cm, 1);
        gchar *fontname = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	wid = gtk_font_button_new_with_font(fontname);

	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_FONTBUTTONSETFONTNAME(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gchar *fontname = _clip_parc(cm, 2);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);
        CHECKARG(2, CHARACTER_t);

	gtk_font_button_set_font_name(GTK_FONT_BUTTON(cbtn->widget), fontname);
	return 0;
err:
	return 1;
}


int
clip_GTK_FONTBUTTONGETFONTNAME(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);

	_clip_retc(cm, (gchar *)gtk_font_button_get_font_name(GTK_FONT_BUTTON(cbtn->widget)));
	return 0;
err:
	return 1;
}


int
clip_GTK_FONTBUTTONSETSHOWSTYLE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gboolean show_style = _clip_parl(cm, 2);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);
        CHECKARG(2, LOGICAL_t);

	gtk_font_button_set_show_style(GTK_FONT_BUTTON(cbtn->widget), show_style);

	return 0;
err:
	return 1;
}

int
clip_GTK_FONTBUTTONGETSHOWSTYLE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);

	_clip_retl(cm, gtk_font_button_get_show_style(GTK_FONT_BUTTON(cbtn->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FONTBUTTONSETSHOWSIZE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gboolean show_size = _clip_parl(cm, 2);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);
        CHECKARG(2, LOGICAL_t);

	gtk_font_button_set_show_size(GTK_FONT_BUTTON(cbtn->widget), show_size);

	return 0;
err:
	return 1;
}

int
clip_GTK_FONTBUTTONGETSHOWSIZE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);

	_clip_retl(cm, gtk_font_button_get_show_size(GTK_FONT_BUTTON(cbtn->widget)));

	return 0;
err:
	return 1;
}


int
clip_GTK_FONTBUTTONSETUSEFONT(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gboolean use_font = _clip_parl(cm, 2);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);
        CHECKARG(2, LOGICAL_t);

	gtk_font_button_set_use_font(GTK_FONT_BUTTON(cbtn->widget), use_font);

	return 0;
err:
	return 1;
}

int
clip_GTK_FONTBUTTONGETUSEFONT(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);

	_clip_retl(cm, gtk_font_button_get_use_font(GTK_FONT_BUTTON(cbtn->widget)));

	return 0;
err:
	return 1;
}


int
clip_GTK_FONTBUTTONSETUSESIZE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gboolean use_size = _clip_parl(cm, 2);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);
        CHECKARG(2, LOGICAL_t);

	gtk_font_button_set_use_size(GTK_FONT_BUTTON(cbtn->widget), use_size);

	return 0;
err:
	return 1;
}

int
clip_GTK_FONTBUTTONGETUSESIZE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);

	_clip_retl(cm, gtk_font_button_get_use_size(GTK_FONT_BUTTON(cbtn->widget)));

	return 0;
err:
	return 1;
}


int
clip_GTK_FONTBUTTONSETTITLE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gchar * title = _clip_parc(cm, 2);

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(title);
	gtk_font_button_set_title(GTK_FONT_BUTTON(cbtn->widget), title);
        FREE_TEXT(title);

	return 0;
err:
	return 1;
}

int
clip_GTK_FONTBUTTONGETTITLE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
        gchar *title;

	CHECKCWID(cbtn,GTK_IS_FONT_BUTTON);

	title = (gchar *)gtk_font_button_get_title(GTK_FONT_BUTTON(cbtn->widget));
        LOCALE_FROM_UTF(title);
        _clip_retc(cm, title);
        FREE_TEXT(title);

	return 0;
err:
	return 1;
}

