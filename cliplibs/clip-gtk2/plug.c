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
static SignalTable plug_signals[] =
{
	{"embedded",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_EMBEDDED_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register widget signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_plug() { return GTK_TYPE_PLUG; }
long _clip_type_plug() { return GTK_WIDGET_PLUG; }
const char * _clip_type_name_plug() { return "GTK_WIDGET_PLUG"; }

int
clip_INIT___PLUG(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_plug, _clip_type_name_plug, _gtk_type_plug,  _gtk_type_window, plug_signals);
	return 0;
}
/**********************************************************/

/**** PLUG constructor ****/
int
clip_GTK_PLUGCONSTRUCT(ClipMachine * cm)
{
	C_widget    *cplug = _fetch_cw_arg(cm);
	GdkNativeWindow id = _clip_parni(cm, 2);

        CHECKARG(2, NUMERIC_t);
	CHECKCWID(cplug,GTK_IS_PLUG);

	gtk_plug_construct(GTK_PLUG(cplug->widget), id);

	return 0;
err:
	return 1;
}

int
clip_GTK_PLUGNEW(ClipMachine * cm)
{
	ClipVar        *cv = _clip_spar(cm, 1);
	GdkNativeWindow id = _clip_parni(cm, 2);
	GtkWidget *wid = NULL;
        C_widget *cwid ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, NUMERIC_t);

	wid = gtk_plug_new(id);

	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_PLUGGETID(ClipMachine * cm)
{
	C_widget *cplug = _fetch_cw_arg(cm);

	CHECKCWID(cplug,GTK_IS_PLUG);

	_clip_retni(cm, (int)gtk_plug_get_id(GTK_PLUG(cplug->widget)));

	return 0;
err:
	return 1;
}

