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
/* Signals table */
static SignalTable check_button_signals[] =
{
	{"draw-indicator", GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_DRAW_INDICATOR_SIGNAL},
	{"", NULL, NULL, 0}
};
/**********************************************************/

/* Register check button in global table */
CLIP_DLLEXPORT GtkType _gtk_type_check_button() { return GTK_TYPE_CHECK_BUTTON; }
long _clip_type_check_button() { return GTK_WIDGET_CHECK_BUTTON; }
const char * _clip_type_name_check_button() { return "GTK_WIDGET_CHECK_BUTTON"; }

int
clip_INIT___CHECK_BUTTON(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_check_button, _clip_type_name_check_button, _gtk_type_check_button, _gtk_type_toggle_button, check_button_signals);
	return 0;
}

/**** CHECK BUTTON constructor ****/
int
clip_GTK_CHECKBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	char * pchar   = _clip_parc(cm, 3);
	GtkWidget *wid = NULL, *label;
	C_widget *cwid;
	guint accel_key = 0;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	if (pchar)
	{
		unsigned char *pc;
		for (pc = (unsigned char *)title;pc && *pc; pc++)
			if (*pc == *pchar)
			{
				*pc='_';
				accel_key = *(pc+1);
			}
	}
	if (_clip_parinfo(cm,2) == CHARACTER_t)
		{
		LOCALE_TO_UTF(title);
		wid = gtk_check_button_new_with_label(title);
		label = GTK_BIN(&(GTK_BUTTON(wid)->bin))->child;
		if (pchar)
			accel_key = gtk_label_parse_uline(GTK_LABEL(label), title);
		FREE_TEXT(title);
		}
	else
		wid = gtk_check_button_new();
	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	_clip_mputn(cm,&cwid->obj,HASH_ACCELKEY,accel_key);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

