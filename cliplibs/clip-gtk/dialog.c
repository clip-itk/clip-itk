/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>
#include <string.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/*********************** SIGNALS **************************/

/****           Dialog has no own signals              ****/

/**********************************************************/

/*************** SIGNALS for InputDialog  *****************/

/* Signal handlers */
static gint
handle_input_dialog_signal (GtkInputDialog *dialog, gint deviceid, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_DEVICEID, deviceid);
        INVOKESIGHANDLER(GTK_WIDGET(dialog),cs,cv);
}

static gint
emit_input_dialog_signal (C_widget *cidial, const gchar *signal_name)
{
	ClipMachine *cm = cidial->cmachine;
        gint   deviceid = _clip_parni(cm,3);
        CHECKARG(3,NUMERIC_t);
        gtk_signal_emit_by_name(GTK_OBJECT(cidial->widget),signal_name,deviceid,cidial);
	return 0;
err:
	return 1;
}

/* Signals table */
static SignalTable input_dialog_signals[] =
{
	{"enable-device",	GSF( handle_input_dialog_signal ), ESF( emit_input_dialog_signal ), GTK_ENABLE_DEVICE_SIGNAL},
	{"disable-device",	GSF( handle_input_dialog_signal ), ESF( emit_input_dialog_signal ), GTK_DISABLE_DEVICE_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register dialog in global table */
CLIP_DLLEXPORT GtkType _gtk_type_dialog() { return GTK_TYPE_DIALOG; }
long _clip_type_dialog() { return GTK_WIDGET_DIALOG; }
const char * _clip_type_name_dialog() { return "GTK_WIDGET_DIALOG"; }

/* Register Input Dialog in global table */
CLIP_DLLEXPORT GtkType _gtk_type_input_dialog() { return GTK_TYPE_INPUT_DIALOG; }
long _clip_type_input_dialog() { return GTK_WIDGET_INPUT_DIALOG; }
const char * _clip_type_name_input_dialog() { return "GTK_WIDGET_INPUT_DIALOG"; }

int
clip_INIT___DIALOG(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_dialog, _clip_type_name_dialog, _gtk_type_dialog, _gtk_type_window, NULL);
	_wtype_table_put(_clip_type_input_dialog, _clip_type_name_input_dialog, _gtk_type_input_dialog, _gtk_type_dialog, input_dialog_signals);
	return 0;
}
/**********************************************************/

/****  DIALOG constructor ****/
int
clip_GTK_DIALOGNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	C_widget *cvbox, *carea;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	wid = gtk_dialog_new();
        if (!wid) goto err;
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		{
		LOCALE_TO_UTF(title);
		gtk_window_set_title(GTK_WINDOW(wid), title);
		FREE_TEXT(title);
		}
	//cwid = (C_widget*)calloc( 1, sizeof(C_widget) );
	cwid = _register_widget(cm, wid, cv);
	cvbox = _register_widget(cm, GTK_DIALOG(wid)->vbox, NULL);
	carea = _register_widget(cm, GTK_DIALOG(wid)->action_area, NULL);

        if (cvbox) _clip_madd(cm,&cwid->obj,HASH_VBOX,&cvbox->obj);
        if (carea) _clip_madd(cm,&cwid->obj,HASH_ACTIONAREA,&carea->obj);

	cwid->accel_group = gtk_accel_group_new();
	gtk_window_add_accel_group (GTK_WINDOW (wid), cwid->accel_group);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/****  INPUT DIALOG constructor ****/
int
clip_GTK_INPUTDIALOGNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	wid = gtk_input_dialog_new();
        if (!wid) goto err;
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		{
		LOCALE_TO_UTF(title);
		gtk_window_set_title(GTK_WINDOW(wid), title);
		FREE_TEXT(title);
		}
	//cwid = (C_widget*)calloc( 1, sizeof(C_widget) );
	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/* Returns the VBox area of the dialog */
int
clip_GTK_DIALOGGETVBOX(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        GtkWidget *area;
        C_widget *carea;
        CHECKCWID(cdialog,GTK_IS_DIALOG);
        area = GTK_DIALOG(cdialog->widget)->vbox;
        if (area) carea = _list_get_cwidget(cm, area);
        if (!carea) carea = _register_widget(cm, area, NULL);
        if (carea) _clip_mclone(cm, RETPTR(cm), &carea->obj);
	return 0;
err:
	return 1;
}

/* Returns the action area of the dialog */
int
clip_GTK_DIALOGGETACTIONAREA(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        GtkWidget *area;
        C_widget *carea;
        CHECKCWID(cdialog,GTK_IS_DIALOG);
        area = GTK_DIALOG(cdialog->widget)->action_area;
        if (area) carea = _list_get_cwidget(cm, area);
        if (!carea) carea = _register_widget(cm, area, NULL);
        if (carea) _clip_mclone(cm, RETPTR(cm), &carea->obj);
	return 0;
err:
	return 1;
}

