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
static gint
handle_changed_signal (GtkWidget *widget, gint selection, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SELECTION, selection);
        INVOKESIGHANDLER(widget,cs,cv);
}
/* Signals table */
static SignalTable border_combo_signals[] =
{
	{"changed",		GSF( handle_changed_signal ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL },
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register BorderCombo in global table */
CLIP_DLLEXPORT GtkType _gtk_type_border_combo() { return gtk_border_combo_get_type(); }
long _clip_type_border_combo() { return GTK_WIDGET_BORDER_COMBO; }
const char * _clip_type_name_border_combo() { return "GTK_WIDGET_BORDER_COMBO"; }

int
clip_INIT___BORDER_COMBO(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_border_combo, _clip_type_name_border_combo, _gtk_type_border_combo, _gtk_type_combo_box, border_combo_signals);
	return 0;
}

/**** BORDER COMBO constructor ****/
int
clip_GTK_BORDERCOMBONEW(ClipMachine * cm)
{
	ClipVar     * cv = _clip_spar (cm,1);
	GtkWidget *wid = NULL;
        C_widget *cwid, *cbutton, *ctable;

	CHECKOPT(1,MAP_t);

	wid = gtk_border_combo_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        cbutton = _register_widget(cm, GTK_COMBO_BOX(wid)->button, NULL);
        ctable = _register_widget(cm, GTK_BORDER_COMBO(wid)->table, NULL);
        _clip_madd(cm, &cwid->obj, HASH_BUTTON, &cbutton->obj);
        _clip_madd(cm, &cwid->obj, HASH_TABLE, &ctable->obj);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

