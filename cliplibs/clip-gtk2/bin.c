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

/*********************** SIGNALS **************************/

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_bin() { return GTK_TYPE_BIN; }

long _clip_type_bin() { return GTK_WIDGET_BIN; }

const char * _clip_type_name_bin()  { return "GTK_OBJECT_BIN"; }

/* Register  in global table */
int
clip_INIT___BIN(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_bin,  _clip_type_name_bin,  _gtk_type_bin,  _gtk_type_container, NULL);
	return 0;
}

int
clip_GTK_BINGETCHILD(ClipMachine * cm)
{
	C_widget      *cbin = _fetch_cw_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCWID(cbin, GTK_IS_BIN);

        gtk_bin_get_child(GTK_BIN(cbin->widget));

	return 0;
err:
	return 1;
}

