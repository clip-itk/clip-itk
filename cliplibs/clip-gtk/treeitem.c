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
static SignalTable tree_item_signals[] =
{
	{"collapse",  	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_COLLAPSE_SIGNAL},
	{"expand",  	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_EXPAND_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register item signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_tree_item() { return GTK_TYPE_TREE_ITEM; }
long _clip_type_tree_item() { return GTK_WIDGET_TREE_ITEM; }
const char * _clip_type_name_tree_item() { return "GTK_WIDGET_TREE_ITEM"; }

int
clip_INIT___TREEITEM(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_tree_item, _clip_type_name_tree_item, _gtk_type_tree_item, _gtk_type_container, tree_item_signals);
	return 0;
}
/**********************************************************/

/**** TREE ITEM constructor ****/
int
clip_GTK_TREEITEMNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * label   = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	if (_clip_parinfo(cm,2) == CHARACTER_t)
		{
		LOCALE_TO_UTF(label);
		wid = gtk_tree_item_new_with_label(label);
		FREE_TEXT(label);
		}
	else
		wid = gtk_tree_item_new();
	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_TREEITEMSETSUBTREE(ClipMachine * cm)
{
	C_widget *citm = _fetch_cw_arg(cm);
	C_widget *csubtree = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(citm,GTK_IS_TREE_ITEM);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(csubtree,GTK_IS_WIDGET);
	gtk_tree_item_set_subtree(GTK_TREE_ITEM(citm->widget), GTK_WIDGET(csubtree->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEITEMGETSUBTREE(ClipMachine * cm)
{
	C_widget *citm = _fetch_cw_arg(cm);
	C_widget *csubtree = NULL;
	GtkWidget *subtree;
	CHECKCWID(citm,GTK_IS_TREE_ITEM);
	subtree = GTK_TREE_ITEM_SUBTREE(citm->widget);
	csubtree = _list_get_cwidget(cm, subtree);
	if (!csubtree) csubtree = _register_widget(cm, subtree, NULL);
	if (csubtree) _clip_mclone(cm,RETPTR(cm),&csubtree->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEITEMREMOVESUBTREE(ClipMachine * cm)
{
	C_widget *citm = _fetch_cw_arg(cm);
	CHECKCWID(citm,GTK_IS_TREE_ITEM);
	gtk_tree_item_remove_subtree(GTK_TREE_ITEM(citm->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEITEMSELECT(ClipMachine * cm)
{
	C_widget *citm = _fetch_cw_arg(cm);
	CHECKCWID(citm,GTK_IS_TREE_ITEM);
	gtk_tree_item_select(GTK_TREE_ITEM(citm->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEITEMDESELECT(ClipMachine * cm)
{
	C_widget *citm = _fetch_cw_arg(cm);
	CHECKCWID(citm,GTK_IS_TREE_ITEM);
	gtk_tree_item_deselect(GTK_TREE_ITEM(citm->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEITEMEXPAND(ClipMachine * cm)
{
	C_widget *citm = _fetch_cw_arg(cm);
	CHECKCWID(citm,GTK_IS_TREE_ITEM);
	gtk_tree_item_expand(GTK_TREE_ITEM(citm->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEITEMCOLLAPSE(ClipMachine * cm)
{
	C_widget *citm = _fetch_cw_arg(cm);
	CHECKCWID(citm,GTK_IS_TREE_ITEM);
	gtk_tree_item_collapse(GTK_TREE_ITEM(citm->widget));
	return 0;
err:
	return 1;
}
