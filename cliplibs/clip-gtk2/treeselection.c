/*
    Copyright (C) 2003  ITK
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


static GtkTreeIter _Iter;
static GtkTreeIter *Iter = &_Iter;

/*********************** SIGNALS **************************/
/* Signals table */
static SignalTable tree_selection_signals[] =
{
	{"changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_tree_selection() { return GTK_TYPE_TREE_SELECTION; }

long _clip_type_tree_selection() { return GTK_OBJECT_TREE_SELECTION; }

const char * _clip_type_name_tree_selection()  { return "GTK_TYPE_TREE_SELECTION"; }

/* Register boxes in global table */
int
clip_INIT___TREESELECTION(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_tree_selection,  _clip_type_name_tree_selection,  _gtk_type_tree_selection,  NULL, tree_selection_signals);
	return 0;
}

int
clip_GTK_TREESELECTIONSETMODE(ClipMachine * cm)
{
	C_object *ctreesel = _fetch_co_arg(cm);
        GtkSelectionMode mode = _clip_parni(cm, 2);

	CHECKOPT2(1, MAP_t, NUMERIC_t); CHECKCOBJ(ctreesel,GTK_IS_TREE_SELECTION(ctreesel->object));
	CHECKARG(2, NUMERIC_t);

	gtk_tree_selection_set_mode(GTK_TREE_SELECTION(ctreesel->object), mode);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREESELECTIONGETMODE(ClipMachine * cm)
{
	C_object *ctreesel = _fetch_co_arg(cm);
        GtkSelectionMode mode;

	CHECKOPT2(1, MAP_t, NUMERIC_t); CHECKCOBJ(ctreesel,GTK_IS_TREE_SELECTION(ctreesel->object));

	mode = gtk_tree_selection_get_mode(GTK_TREE_SELECTION(ctreesel->object));

	_clip_retni(cm, mode);

	return 0;
err:
	return 1;
}


int
clip_GTK_TREESELECTIONGETTREEVIEW(ClipMachine * cm)
{
	C_object *ctreesel = _fetch_co_arg(cm);
        GtkTreeView *view;
        C_widget *cwid;

	CHECKOPT2(1, MAP_t, NUMERIC_t); CHECKCOBJ(ctreesel,GTK_IS_TREE_SELECTION(ctreesel->object));

	view = gtk_tree_selection_get_tree_view(GTK_TREE_SELECTION(ctreesel->object));

	if (!view) goto err;
	cwid = _register_widget(cm, GTK_WIDGET(view), NULL);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREESELECTIONGETSELECTED(ClipMachine * cm)
{
	C_object *ctreesel = _fetch_co_arg(cm);
        C_object *cmodel   = _fetch_cobject(cm, _clip_par(cm, 2));
        ClipVar *cviter    = _clip_par(cm, 3);
        C_object *citer;
        GtkTreeModel *model;
        gboolean ret;

	CHECKOPT2(1, MAP_t, NUMERIC_t); CHECKCOBJ(ctreesel,GTK_IS_TREE_SELECTION(ctreesel->object));

	memset(Iter, 0, sizeof(Iter));
	if (cmodel)
        {
		model = GTK_TREE_MODEL(cmodel->object);
		ret = gtk_tree_selection_get_selected(GTK_TREE_SELECTION(ctreesel->object),
			&model, Iter);
	}
	else
		ret = gtk_tree_selection_get_selected(GTK_TREE_SELECTION(ctreesel->object),
			NULL, Iter);

	if (ret && Iter)
        {
		citer = _list_get_cobject(cm,Iter);
		if (!citer) citer = _register_object(cm,Iter,GTK_TYPE_TREE_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter,&citer->obj);
        }

        _clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

