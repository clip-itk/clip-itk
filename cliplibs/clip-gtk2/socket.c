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
static SignalTable socket_signals[] =
{
	{"plug-added",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PLUG_ADDED_SIGNAL},
	{"plug-removed",GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PLUG_REMOVED_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register widget signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_socket() { return GTK_TYPE_SOCKET; }
long _clip_type_socket() { return GTK_WIDGET_SOCKET; }
const char * _clip_type_name_socket() { return "GTK_WIDGET_SOCKET"; }

int
clip_INIT___SOCKET(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_socket, _clip_type_name_socket, _gtk_type_socket,  _gtk_type_container, socket_signals);
	return 0;
}
/**********************************************************/

/**** SOCKET constructor ****/
int
clip_GTK_SOCKETNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid ;

	CHECKOPT(1,MAP_t);

	wid = gtk_socket_new();

	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_SOCKETSTEAL(ClipMachine * cm)
{
	C_widget *csocket = _fetch_cw_arg(cm);
        GdkNativeWindow id = _clip_parni(cm, 2);

	CHECKCWID(csocket,GTK_IS_SOCKET);
        CHECKARG(2, NUMERIC_t);

	gtk_socket_steal(GTK_SOCKET(csocket->widget), id);

	return 0;
err:
	return 1;
}

int
clip_GTK_SOCKETADDID(ClipMachine * cm)
{
	C_widget *csocket = _fetch_cw_arg(cm);
        GdkNativeWindow id = _clip_parni(cm, 2);

	CHECKCWID(csocket,GTK_IS_SOCKET);
        CHECKARG(2, NUMERIC_t);

	gtk_socket_add_id(GTK_SOCKET(csocket->widget), id);

	return 0;
err:
	return 1;
}


int
clip_GTK_SOCKETGETID(ClipMachine * cm)
{
	C_widget *csocket = _fetch_cw_arg(cm);

	CHECKCWID(csocket,GTK_IS_SOCKET);

	_clip_retni(cm, gtk_socket_get_id(GTK_SOCKET(csocket->widget)));

	return 0;
err:
	return 1;
}

