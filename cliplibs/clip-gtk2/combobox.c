/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

static GtkTreeIter _Iter;
static GtkTreeIter *Iter = &_Iter;
/**********************************************************/
static SignalTable combo_box_signals[] =
{
	{"changed",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};
/**********************************************************/

/* Register combo box in global table */
CLIP_DLLEXPORT GtkType _gtk_type_combo_box() { return GTK_TYPE_COMBO_BOX; }
long _clip_type_combo_box() { return GTK_WIDGET_COMBO_BOX; }
const char * _clip_type_name_combo_box() { return "GTK_WIDGET_COMBO_BOX"; }

int
clip_INIT___COMBOBOX(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_combo_box, _clip_type_name_combo_box, _gtk_type_combo_box, _gtk_type_bin, combo_box_signals);
	return 0;
}

/* Register combo box entry in global table */
CLIP_DLLEXPORT GtkType _gtk_type_combo_box_entry() { return GTK_TYPE_COMBO_BOX_ENTRY; }
long _clip_type_combo_box_entry() { return GTK_WIDGET_COMBO_BOX_ENTRY; }
const char * _clip_type_name_combo_box_entry() { return "GTK_WIDGET_COMBO_BOX_ENTRY"; }

int
clip_INIT___COMBOBOXENTRY(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_combo_box_entry, _clip_type_name_combo_box_entry, _gtk_type_combo_box_entry, _gtk_type_combo_box, NULL);
	return 0;
}

/**** Combo box constructor ****/
int
clip_GTK_COMBOBOXNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);

	wid = gtk_combo_box_new();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXNEWWITHMODEL(ClipMachine * cm)
{
	ClipVar   * cv   = _clip_spar(cm, 1);
        C_object *cmodel = _fetch_cobject(cm, _clip_spar(cm, 2));
	GtkWidget   *wid = NULL;
	C_widget   *cwid;

	CHECKOPT(1,MAP_t);
        CHECKCOBJ(cmodel, GTK_IS_TREE_MODEL(cmodel->object));

	wid = gtk_combo_box_new_with_model(GTK_TREE_MODEL(cmodel->object));
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXNEWTEXT(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);

	wid = gtk_combo_box_new_text();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_COMBOBOXSETWRAPWIDTH(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	gint       width = _clip_parni(cm,2);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
	CHECKOPT(2, NUMERIC_t);

	gtk_combo_box_set_wrap_width(GTK_COMBO_BOX(ccmb->widget), width);

	return 0;
err:
	return 1;
}


int
clip_GTK_COMBOBOXSETROWSPANCOLUMN(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	gint    row_span = _clip_parni(cm,2);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
	CHECKOPT(2, NUMERIC_t);

	gtk_combo_box_set_row_span_column(GTK_COMBO_BOX(ccmb->widget), row_span);

	return 0;
err:
	return 1;
}


int
clip_GTK_COMBOBOXSETCOLUMNSPANCOLUMN(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	gint column_span = _clip_parni(cm,2);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
	CHECKOPT(2, NUMERIC_t);

	gtk_combo_box_set_column_span_column(GTK_COMBO_BOX(ccmb->widget), column_span);

	return 0;
err:
	return 1;
}


int
clip_GTK_COMBOBOXGETACTIVE(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        gint       index ;

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);

	index = gtk_combo_box_get_active(GTK_COMBO_BOX(ccmb->widget));

	if (index>-1) index ++;
        _clip_retni(cm, index);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXSETACTIVE(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        gint       index = _clip_parni(cm, 2);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
        CHECKARG(2, NUMERIC_t);

	index --;

	gtk_combo_box_set_active(GTK_COMBO_BOX(ccmb->widget), index);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXSETACTIVEITER(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        C_object  *citer = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
        CHECKCOBJ(citer, GTK_IS_TREE_ITER(citer->object));

	gtk_combo_box_set_active_iter(GTK_COMBO_BOX(ccmb->widget),
		GTK_TREE_ITER(citer->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXGETACTIVEITER(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        ClipVar      *cv = _clip_spar(cm, 2);
        C_object  *citer ;

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);

	_clip_retl(cm, gtk_combo_box_get_active_iter(GTK_COMBO_BOX(ccmb->widget),
		Iter));

	if (Iter)
        {
         	citer = _list_get_cobject(cm, Iter);
                if (!citer) citer = _register_object(cm, Iter, GTK_TYPE_TREE_ITER, NULL, NULL);
                if (citer) _clip_mclone(cm, cv, &citer->obj);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXSETMODEL(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        C_object *cmodel = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
        CHECKCOBJ(cmodel, GTK_IS_TREE_MODEL(cmodel->object));

	gtk_combo_box_set_model(GTK_COMBO_BOX(ccmb->widget),
		GTK_TREE_MODEL(cmodel->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXGETMODEL(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        GtkTreeModel *model;
        C_object *cmodel ;

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);

	model = gtk_combo_box_get_model(GTK_COMBO_BOX(ccmb->widget));

	if (model)
        {
         	cmodel = _list_get_cobject(cm, model);
                if (!cmodel) cmodel = _register_object(cm, Iter, GTK_TYPE_TREE_MODEL, NULL, NULL);
                if (cmodel) _clip_mclone(cm, RETPTR(cm), &cmodel->obj);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXAPPENDTEXT(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        gchar      *text = _clip_parc(cm, 2);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(text);
	gtk_combo_box_append_text(GTK_COMBO_BOX(ccmb->widget), text);
        FREE_TEXT(text);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXPREPENDTEXT(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        gchar      *text = _clip_parc(cm, 2);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(text);
	gtk_combo_box_prepend_text(GTK_COMBO_BOX(ccmb->widget), text);
        FREE_TEXT(text);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXINSERTTEXT(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        gint         pos = _clip_parni(cm, 2);
        gchar      *text = _clip_parc(cm, 3);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, CHARACTER_t);

	pos --;
	LOCALE_TO_UTF(text);
	gtk_combo_box_insert_text(GTK_COMBO_BOX(ccmb->widget), pos, text);
        FREE_TEXT(text);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXREMOVETEXT(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
        gint         pos = _clip_parni(cm, 2);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
        CHECKARG(2, NUMERIC_t);

	pos --;
	gtk_combo_box_remove_text(GTK_COMBO_BOX(ccmb->widget), pos);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXPOPUP(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);

	gtk_combo_box_popup(GTK_COMBO_BOX(ccmb->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXPOPDOWN(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);

	gtk_combo_box_popdown(GTK_COMBO_BOX(ccmb->widget));

	return 0;
err:
	return 1;
}
/******************************************************************************/
/********************** COMBO BOX ENTRY ***************************************/

int
clip_GTK_COMBOBOXENTRYNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);

	wid = gtk_combo_box_entry_new();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXENTRYNEWWITHMODEL(ClipMachine * cm)
{
	ClipVar   * cv   = _clip_spar(cm, 1);
        C_object *cmodel = _fetch_cobject(cm, _clip_spar(cm, 2));
        gint text_column = _clip_parni(cm, 3);
	GtkWidget   *wid = NULL;
	C_widget   *cwid;

	CHECKOPT(1,MAP_t);
        CHECKCOBJ(cmodel, GTK_IS_TREE_MODEL(cmodel->object));
        CHECKARG(3, NUMERIC_t);

	text_column --;
	wid = gtk_combo_box_entry_new_with_model(GTK_TREE_MODEL(cmodel->object),
		text_column);
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXENTRYNEWTEXT(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);

	wid = gtk_combo_box_entry_new_text();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXENTRYSETTEXTCOLUMN(ClipMachine * cm)
{
	C_widget    *ccmb = _fetch_cw_arg(cm);
	gint  text_column = _clip_parni(cm, 2);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);
	CHECKOPT(2, NUMERIC_t);

	text_column --;
	gtk_combo_box_entry_set_text_column(GTK_COMBO_BOX_ENTRY(ccmb->widget),
		text_column);

	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOBOXENTRYGETTEXTCOLUMN(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);

	CHECKCWID(ccmb,GTK_IS_COMBO_BOX);

	_clip_retni(cm, gtk_combo_box_entry_get_text_column(GTK_COMBO_BOX_ENTRY(ccmb->widget))+1);

	return 0;
err:
	return 1;
}

