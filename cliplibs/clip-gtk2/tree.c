/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <string.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
/* Signal handlers */
static gint
handle_sel_child_signal (GtkWidget *widget, GtkWidget *child, C_signal *cs)
{
	C_widget *cchild = _get_cwidget(cs->cw->cmachine,child);
	PREPARECV(cs,cv);
	if (cchild) _clip_madd(cs->cw->cmachine, &cv, HASH_CHILD, &cchild->obj);
        INVOKESIGHANDLER(child,cs,cv);
}

/* Signals table */
static SignalTable tree_signals[] =
{
	{"selection-changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SELECTION_CHANGED_SIGNAL},
	{"select-child",	GSF( handle_sel_child_signal ), ESF( object_emit_signal ), GTK_SELECT_CHILD_SIGNAL},
	{"unselect-child",	GSF( handle_sel_child_signal ), ESF( object_emit_signal ), GTK_UNSELECT_CHILD_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register CTree in global table */
CLIP_DLLEXPORT GtkType _gtk_type_tree() { return GTK_TYPE_TREE; }
long _clip_type_tree() { return GTK_WIDGET_TREE; }
const char * _clip_type_name_tree() { return "GTK_WIDGET_TREE"; }

int
clip_INIT___TREE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_tree, _clip_type_name_tree, _gtk_type_tree, _gtk_type_container, tree_signals);
	return 0;
}

/**** Tree constructor ****/
int
clip_GTK_TREENEW(ClipMachine * cm)
{
	ClipVar     * cv = _clip_spar (cm,1);
	GtkWidget *wid = NULL;
        C_widget *cwid;

	CHECKOPT(1,MAP_t);
	wid = gtk_tree_new();

        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Adds the GtkTreeItem in tree_item to the end of the items in tree. */
int
clip_GTK_TREEAPPEND(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
	C_widget  *citem = _fetch_cwidget(cm,_clip_spar(cm,2));

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_TREE_ITEM);

	gtk_tree_append(GTK_TREE(ctree->widget), citem->widget);
	return 0;
err:
	return 1;
}

/* Adds the GtkTreeItem in tree_item to the start of the items in tree. */
int
clip_GTK_TREEPREPEND(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
	C_widget  *citem = _fetch_cwidget(cm,_clip_spar(cm,2));

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_TREE_ITEM);

	gtk_tree_prepend(GTK_TREE(ctree->widget), citem->widget);
	return 0;
err:
	return 1;
}

/* Adds the GtkTreeItem in tree_item to the list of items in tree
 * at the position indicated by position. */
int
clip_GTK_TREEINSERT(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
	C_widget  *citem = _fetch_cwidget(cm,_clip_spar(cm,2));
        gint    position = INT_OPTION(cm,3,1)-1;

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_TREE_ITEM);
        CHECKOPT(3,NUMERIC_t);

	gtk_tree_insert(GTK_TREE(ctree->widget), citem->widget, position);
	return 0;
err:
	return 1;
}

/* Removes a list of items from the GtkTree in tree.

 * If only one item is to be removed from the GtkTree,
 * gtk_container_remove() can be used instead.

 * Removing an item from a GtkTree dereferences the item, and thus
 * usually destroys the item and any subtrees it may contain. If the
 * item is not to be destroyed, use gtk_object_ref() before removing it. */
int
clip_GTK_TREEREMOVEITEMS(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        ClipVar   *items = _clip_spar(cm,2);

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT3(2,MAP_t,NUMERIC_t,ARRAY_t);

	if (items->t.type == MAP_t || items->t.type == NUMERIC_t)
        {
        	C_widget *citem = _fetch_cwidget(cm,items);
                gtk_tree_remove_item(GTK_TREE(ctree->widget), citem->widget);
        }
	if (items->t.type == ARRAY_t)
        {
        	GList *list = NULL;
                unsigned short i;
                ClipVar *item;
                C_widget *citem;
                for (i=0; i<items->a.count; i++)
                {
                	item = &items->a.items[i];
                	if (item->t.type == NUMERIC_t || item->t.type == MAP_t)
                        {
                        	citem = _fetch_cwidget(cm,item);
                                CHECKCWID(citem,GTK_IS_TREE_ITEM);
                                list = g_list_append(list, citem->widget);
                        }
                }
                if (list)
                {
                	gtk_tree_remove_items(GTK_TREE(ctree->widget), list);
                        g_list_free(list);
                }
        }
	return 0;
err:
	return 1;
}

/* Removes the items at positions between start and end from the GtkTree tree.

 * Removing an item from a GtkTree dereferences the item, and thus usually
 * destroys the item and any subtrees it may contain. If the item is not
 * to be destroyed, use gtk_object_ref() before removing it. */
int
clip_GTK_TREECLEARITEMS(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        gint       start = INT_OPTION(cm,2,1)-1;
        gint         end = INT_OPTION(cm,3,1)-1;

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);

	gtk_tree_clear_items(GTK_TREE(ctree->widget), start, end);
	return 0;
err:
	return 1;
}

/* Emits the select_item signal for the child at position item, and thus
 * selects it (unless it is unselected in a signal handler). */
int
clip_GTK_TREESELECTITEM(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        gint        item = INT_OPTION(cm,2,1)-1;

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT(2,NUMERIC_t);

	gtk_tree_select_item(GTK_TREE(ctree->widget), item);
	return 0;
err:
	return 1;
}

/* Emits the unselect_item for the child at position item, and thus unselects it. */
int
clip_GTK_TREEUNSELECTITEM(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        gint        item = INT_OPTION(cm,2,1)-1;

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT(2,NUMERIC_t);

	gtk_tree_unselect_item(GTK_TREE(ctree->widget), item);
	return 0;
err:
	return 1;
}

/* Emits the select_item signal for the child tree_item, and thus
 * selects it (unless it is unselected in a signal handler). */
int
clip_GTK_TREESELECTCHILD(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
	C_widget  *citem = _fetch_cwidget(cm,_clip_spar(cm,2));

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_TREE_ITEM);

	gtk_tree_select_child(GTK_TREE(ctree->widget), citem->widget);
	return 0;
err:
	return 1;
}

/* Emits the unselect_item signal for the child tree_item, and thus unselects it. */
int
clip_GTK_TREEUNSELECTCHILD(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
	C_widget  *citem = _fetch_cwidget(cm,_clip_spar(cm,2));

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_TREE_ITEM);

	gtk_tree_unselect_child(GTK_TREE(ctree->widget), citem->widget);
	return 0;
err:
	return 1;
}

/* Returns the position of child in the GtkTree tree.
 * If child is not a child of tree, then -1 is returned. */
int
clip_GTK_TREECHILDPOSITION(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
	C_widget  *citem = _fetch_cwidget(cm,_clip_spar(cm,2));

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_TREE_ITEM);

	_clip_retni(cm, gtk_tree_child_position(GTK_TREE(ctree->widget), citem->widget));
	return 0;
err:
	return 1;
}

/* Sets the selection mode for the GtkTree tree.
mode can be one of
    GTK_SELECTION_SINGLE for when only one item can be selected at a time.
    GTK_SELECTION_BROWSE for when one item must be selected.
    GTK_SELECTION_MULTIPLE for when many items can be selected at once.
    GTK_SELECTION_EXTENDED Reserved for later use.
The selection mode is only defined for a root tree, as the root tree "owns" the selection.
The default mode is GTK_SELECTION_SINGLE. */
int
clip_GTK_TREESETSELECTIONMODE(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        GtkSelectionMode mode = _clip_parni(cm,2);

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT(2,NUMERIC_t);

	gtk_tree_set_selection_mode(GTK_TREE(ctree->widget), mode);
	return 0;
err:
	return 1;
}

/* Sets the 'viewmode' for the GtkTree in tree.
The 'viewmode' defines how the tree looks when an item is selected.
mode can be one of:
    GTK_TREE_VIEW_LINE : When an item is selected the entire GtkTreeItem is highlighted.
    GTK_TREE_VIEW_ITEM : When an item is selected only the selected item's child widget is highlighted.
The default mode is GTK_TREE_VIEW_LINE. */
int
clip_GTK_TREESETVIEWMODE(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        GtkTreeViewMode mode = _clip_parni(cm,2);

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT(2,NUMERIC_t);

	gtk_tree_set_view_mode(GTK_TREE(ctree->widget), mode);
	return 0;
err:
	return 1;
}

/* Sets whether or not the connecting lines between branches and children are drawn. */
int
clip_GTK_TREESETVIEWLINES(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        gboolean    flag = _clip_parl(cm,2);

        CHECKCWID(ctree,GTK_IS_TREE); CHECKOPT(2,LOGICAL_t);

	gtk_tree_set_view_lines(GTK_TREE(ctree->widget), flag);
	return 0;
err:
	return 1;
}

/* Removes the item child from the GtkTree tree. */
int
clip_GTK_TREEREMOVEITEM(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
	C_widget  *citem = _fetch_cwidget(cm,_clip_spar(cm,2));

        CHECKCWID(ctree,GTK_IS_TREE);
        CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_TREE_ITEM);

	gtk_tree_remove_item(GTK_TREE(ctree->widget), citem->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEISROOTTREE(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);

        CHECKCWID(ctree,GTK_IS_TREE);
	_clip_retl(cm,GTK_IS_ROOT_TREE(ctree->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEROOTTREE(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        C_widget *croot;
        CHECKCWID(ctree,GTK_IS_TREE);
        croot = _get_cwidget(cm,GTK_WIDGET(GTK_TREE_ROOT_TREE(ctree->widget)));
	if (croot) _clip_mclone(cm,RETPTR(cm),&croot->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEGETSELECTION(ClipMachine * cm)
{
	C_widget  *ctree = _fetch_cw_arg(cm);
        GList *list;
        CHECKCWID(ctree,GTK_IS_TREE);
        list = GTK_TREE_SELECTION(ctree->widget);
        if (list)
        {
        	C_widget *citem;
                long l = g_list_length(list);
                ClipVar *a = RETPTR(cm);
                _clip_array(cm,a,1,&l);
                for (l=0; list; list = g_list_next(list), l++)
                {
			citem = _get_cwidget(cm,list->data);
                        if (citem) _clip_aset(cm,a,&citem->obj,1,&l);
                }
        }
	return 0;
err:
	return 1;
}

