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
handle_changed_signal (GtkWidget *widget, gint row, gint col, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ROW, row+1);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_COL, col+1);
        INVOKESIGHANDLER(widget,cs,cv);
}
/* Signals table */
static SignalTable toggle_combo_signals[] =
{
	{"changed",		GSF( handle_changed_signal ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL },
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register ColorCombo in global table */
CLIP_DLLEXPORT GtkType _gtk_type_toggle_combo() { return gtk_toggle_combo_get_type(); }
long _clip_type_toggle_combo() { return GTK_WIDGET_TOGGLE_COMBO; }
const char * _clip_type_name_toggle_combo() { return "GTK_WIDGET_TOGGLE_COMBO"; }

int
clip_INIT___TOGGLE_COMBO(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_toggle_combo, _clip_type_name_toggle_combo, _gtk_type_toggle_combo, _gtk_type_combo_box, toggle_combo_signals);
	return 0;
}

/**** TOGGLE COMBO constructors ****/
int
clip_GTK_TOGGLECOMBONEW(ClipMachine * cm)
{
	ClipVar    * cv = _clip_spar (cm,1);
        gint      nrows = INT_OPTION(cm,2,1);
        gint      ncols = INT_OPTION(cm,3,1);

	GtkWidget *wid = NULL;
        C_widget *cwid, *cbutton, *ctable;

	CHECKOPT(1,MAP_t); CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);

	wid = gtk_toggle_combo_new(nrows,ncols);

        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        cbutton = _register_widget(cm, GTK_COMBO_BOX(wid)->button, NULL);
        ctable = _register_widget(cm, GTK_TOGGLE_COMBO(wid)->table, NULL);
        _clip_madd(cm, &cwid->obj, HASH_BUTTON, &cbutton->obj);
        _clip_madd(cm, &cwid->obj, HASH_TABLE, &ctable->obj);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_TOGGLECOMBOGETNROWS(ClipMachine * cm)
{
	C_widget  *ctgc = _fetch_cw_arg(cm);
        CHECKCWID(ctgc,GTK_IS_TOGGLE_COMBO);
        gtk_toggle_combo_get_nrows(GTK_TOGGLE_COMBO(ctgc->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_TOGGLECOMBOGETNCOLS(ClipMachine * cm)
{
	C_widget  *ctgc = _fetch_cw_arg(cm);
        CHECKCWID(ctgc,GTK_IS_TOGGLE_COMBO);
        gtk_toggle_combo_get_ncols(GTK_TOGGLE_COMBO(ctgc->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_TOGGLECOMBOSELECT(ClipMachine * cm)
{
	C_widget  *ctgc = _fetch_cw_arg(cm);
        gint        row = INT_OPTION(cm,2,1);
        gint        col = INT_OPTION(cm,3,1);
        CHECKCWID(ctgc,GTK_IS_TOGGLE_COMBO);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_toggle_combo_select(GTK_TOGGLE_COMBO(ctgc->widget),row-1,col-1);
	return 0;
err:
	return 1;
}

int
clip_GTK_TOGGLECOMBOGETSELECTION(ClipMachine * cm)
{
	C_widget  *ctgc = _fetch_cw_arg(cm);
        gint row, col;
        CHECKCWID(ctgc,GTK_IS_TOGGLE_COMBO);
        gtk_toggle_combo_get_selection(GTK_TOGGLE_COMBO(ctgc->widget),&row,&col);
        _clip_storni(cm,row+1,2,0);
        _clip_storni(cm,col+1,3,0);
	return 0;
err:
	return 1;
}
