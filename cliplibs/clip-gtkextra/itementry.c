/*
    Copyright (C) 2002  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkextracfg.h"

#include <gtkextra/gtkextra.h>
#include <string.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

#include "clip-gtkextra.ch"
#include "clip-gtkextra.h"

/**********************************************************/

/* Register ItemEntry in global table */
CLIP_DLLEXPORT GtkType _gtk_type_item_entry() { return gtk_item_entry_get_type(); }
long _clip_type_item_entry() { return GTK_WIDGET_ITEM_ENTRY; }
const char * _clip_type_name_item_entry() { return "GTK_WIDGET_ITEM_ENTRY"; }

int
clip_INIT___ITEM_ENTRY(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_item_entry, _clip_type_name_item_entry, _gtk_type_item_entry, _gtk_type_entry, NULL);
	return 0;
}

/**** ITEM ENTRY constructor ****/
int
clip_GTK_ITEMENTRYNEW(ClipMachine * cm)
{
	ClipVar  * cv = _clip_spar (cm,1);
        guint16   max = _clip_parni(cm,2);
	GtkWidget *wid = NULL;
        C_widget *cwid;

	CHECKOPT(1,MAP_t); CHECKOPT(2,NUMERIC_t);

	if (_clip_parinfo(cm,2) == UNDEF_t)
		wid = gtk_item_entry_new();
        else
		wid = gtk_item_entry_new_with_max_length(max);

        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_ITEMENTRYSETTEXT(ClipMachine * cm)
{
	C_widget    *cite = _fetch_cw_arg(cm);
	const gchar *text = CHAR_OPTION(cm,2,"");
	GtkJustification justification = INT_OPTION(cm,3,GTK_JUSTIFY_LEFT);
        CHECKCWID(cite,GTK_IS_ITEM_ENTRY);
        CHECKOPT(2,CHARACTER_t); CHECKOPT(3,NUMERIC_t);
        gtk_item_entry_set_text(GTK_ITEM_ENTRY(cite->widget),text,justification);
	return 0;
err:
	return 1;
}

int
clip_GTK_ITEMENTRYGETTEXT(ClipMachine * cm)
{
	C_widget    *cite = _fetch_cw_arg(cm);
        CHECKCWID(cite,GTK_IS_ENTRY);
        _clip_retc(cm,gtk_entry_get_text(GTK_ENTRY(cite->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_ITEMENTRYSETJUSTIFICATION(ClipMachine * cm)
{
	C_widget    *cite = _fetch_cw_arg(cm);
	GtkJustification justification = INT_OPTION(cm,2,GTK_JUSTIFY_LEFT);
        CHECKCWID(cite,GTK_IS_ITEM_ENTRY);
        CHECKOPT(2,NUMERIC_t);
        gtk_item_entry_set_justification(GTK_ITEM_ENTRY(cite->widget),justification);
	return 0;
err:
	return 1;
}

int
clip_GTK_ITEMENTRYGETJUSTIFICATION(ClipMachine * cm)
{
	C_widget    *cite = _fetch_cw_arg(cm);
        CHECKCWID(cite,GTK_IS_ITEM_ENTRY);
        _clip_retni(cm,GTK_ITEM_ENTRY(cite->widget)->justification);
	return 0;
err:
	return 1;
}

int
clip_GTK_ITEMENTRYGETTEXTMAXSIZE(ClipMachine * cm)
{
	C_widget    *cite = _fetch_cw_arg(cm);
        CHECKCWID(cite,GTK_IS_ITEM_ENTRY);
        _clip_retni(cm,GTK_ITEM_ENTRY(cite->widget)->text_max_size);
	return 0;
err:
	return 1;
}


