/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>
#include <string.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/*********************** SIGNALS **************************/

/****************** SIGNALS for List  *********************/

/* Signal handlers */
static gint handle_select_child_signal (GtkWidget *widget, GtkWidget *wid, C_signal *cs)
{
	C_widget *cwid;
	PREPARECV(cs,cv);
        cwid = _list_get_cwidget(cs->cw->cmachine,wid);
        if (!cwid) cwid = _register_widget(cs->cw->cmachine,wid,NULL);
        if (cwid) _clip_madd(cs->cw->cmachine, &cv, HASH_CHILD, &cwid->obj);
        INVOKESIGHANDLER(widget,cs,cv);
}

static gint handle_unselect_child_signal (GtkWidget *widget, GtkWidget *wid, C_signal *cs)
{
	C_widget *cwid;
	PREPARECV(cs,cv);
        cwid = _list_get_cwidget(cs->cw->cmachine,wid);
        if (!cwid) cwid = _register_widget(cs->cw->cmachine,wid,NULL);
        if (cwid) _clip_madd(cs->cw->cmachine, &cv, HASH_CHILD, &cwid->obj);
        INVOKESIGHANDLER(widget,cs,cv);
}

static gint list_emit_signal (C_widget *clist, const gchar *signal_name)
{
	ClipMachine *cm = clist->cmachine;
        C_widget  *cwid = _fetch_cwidget(cm,_clip_spar(cm,3));
        CHECKARG2(3,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_signal_emit_by_name(GTK_OBJECT(clist->widget),signal_name,cwid->widget,clist);
	return 0;
err:
	return 1;
}

/* Signals table */
static SignalTable list_signals[] =
{
	{"selection-changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SELECTION_CHANGED_SIGNAL},
	{"select-child",	GSF( handle_select_child_signal ), ESF( list_emit_signal ), GTK_SELECT_CHILD_SIGNAL},
	{"unselect-child",	GSF( handle_unselect_child_signal ), ESF( list_emit_signal ), GTK_UNSELECT_CHILD_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register List in global table */
CLIP_DLLEXPORT GtkType _gtk_type_list() { return GTK_TYPE_LIST; }
long _clip_type_list() { return GTK_WIDGET_LIST; }
const char * _clip_type_name_list() { return "GTK_WIDGET_LIST"; }

int
clip_INIT___LIST(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_list, _clip_type_name_list, _gtk_type_list, _gtk_type_container, list_signals);
	return 0;
}
/**********************************************************/

/****  LIST constructor ****/
int
clip_GTK_LISTNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_list_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/* Inserts items into the list at the position position.
 * The GList items must not be freed after. */
int
clip_GTK_LISTINSERTITEMS(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        ClipVar    *cv = _clip_spar(cm,2);
        gint  position = _clip_parni(cm,3);
        GList *items = NULL;
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG4(2,ARRAY_t,CHARACTER_t,MAP_t,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        if (_clip_parinfo(cm,3)==UNDEF_t) position = 1;
        switch (cv->t.type)
        {
        	case CHARACTER_t:
                	items = g_list_append(items,gtk_list_item_new_with_label(cv->s.str.buf));
        	break;

		case MAP_t:
		case NUMERIC_t:
                {
        		C_widget *citem = _fetch_cwidget(cm,cv);
                        CHECKCWID(citem,GTK_IS_WIDGET);
                        if (GTK_IS_LIST_ITEM(citem->widget))
                        	items = g_list_append(items,citem->widget);
                        else
			{
                        	GtkWidget *item = gtk_list_item_new();
                                gtk_container_add(GTK_CONTAINER(item),citem->widget);
			        items = g_list_append(items,item);
			}
			break;
                }

		case ARRAY_t:
        	{
        		C_widget *citem;
                	GtkWidget *item;
        		int i;
        		for (i=0; i<cv->a.count; i++)
                	{
                		switch (cv->a.items[i].t.type)
                        	{
                        		case CHARACTER_t:
                        			items = g_list_append(items,gtk_list_item_new_with_label(cv->a.items[i].s.str.buf));
                                        	break;
                                	case MAP_t:
	                                case NUMERIC_t:
					citem = _fetch_cwidget(cm,&cv->a.items[i]);
	                                        CHECKCWID(citem,GTK_IS_WIDGET);
	                                        if (GTK_IS_LIST_ITEM(citem->widget))
	                                        	items = g_list_append(items,citem->widget);
	                                        else
						{
	                                        	item = gtk_list_item_new();
	                                                gtk_container_add(GTK_CONTAINER(item),citem->widget);
						        items = g_list_append(items,item);
						}
	                                	break;
	                                default:
	                                	break;
	                	}
	                }

	        }
                default:
	        	break;
	}
        gtk_list_insert_items(GTK_LIST(clst->widget),items,position-1);
	return 0;
err:
	return 1;
}

/* Adds items to the end of the list. */
int
clip_GTK_LISTAPPENDITEMS(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        ClipVar    *cv = _clip_spar(cm,2);
        GList *items = NULL;
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG4(2,ARRAY_t,CHARACTER_t,MAP_t,NUMERIC_t);
        switch (cv->t.type)
        {
        	case CHARACTER_t:
                	items = g_list_append(items,gtk_list_item_new_with_label(cv->s.str.buf));
        	break;

		case MAP_t:
		case NUMERIC_t:
                {
        		C_widget *citem = _fetch_cwidget(cm,cv);
                        CHECKCWID(citem,GTK_IS_WIDGET);
                        if (GTK_IS_LIST_ITEM(citem->widget))
                        	items = g_list_append(items,citem->widget);
                        else
			{
                        	GtkWidget *item = gtk_list_item_new();
                                gtk_container_add(GTK_CONTAINER(item),citem->widget);
			        items = g_list_append(items,item);
			}
			break;
                }

		case ARRAY_t:
        	{
        		C_widget *citem;
                	GtkWidget *item;
        		int i;
        		for (i=0; i<cv->a.count; i++)
                	{
                		switch (cv->a.items[i].t.type)
                        	{
                        		case CHARACTER_t:
                        			items = g_list_append(items,gtk_list_item_new_with_label(cv->a.items[i].s.str.buf));
                                        	break;
                                	case MAP_t:
	                                case NUMERIC_t:
					citem = _fetch_cwidget(cm,&cv->a.items[i]);
	                                        CHECKCWID(citem,GTK_IS_WIDGET);
	                                        if (GTK_IS_LIST_ITEM(citem->widget))
	                                        	items = g_list_append(items,citem->widget);
	                                        else
						{
	                                        	item = gtk_list_item_new();
	                                                gtk_container_add(GTK_CONTAINER(item),citem->widget);
						        items = g_list_append(items,item);
						}
	                                	break;
	                                default:
	        				break;
	                	}
	                }

	        }
                default:
	        	break;
	}
        gtk_list_append_items(GTK_LIST(clst->widget),items);
	return 0;
err:
	return 1;
}

/* Inserts items at the beginning of the list. */
int
clip_GTK_LISTPREPENDITEMS(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        ClipVar    *cv = _clip_spar(cm,2);
        GList *items = NULL;
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG4(2,ARRAY_t,CHARACTER_t,MAP_t,NUMERIC_t);
        switch (cv->t.type)
        {
        	case CHARACTER_t:
                	items = g_list_append(items,gtk_list_item_new_with_label(cv->s.str.buf));
        	break;

		case MAP_t:
		case NUMERIC_t:
                {
        		C_widget *citem = _fetch_cwidget(cm,cv);
                        CHECKCWID(citem,GTK_IS_WIDGET);
                        if (GTK_IS_LIST_ITEM(citem->widget))
                        	items = g_list_append(items,citem->widget);
                        else
			{
                        	GtkWidget *item = gtk_list_item_new();
                                gtk_container_add(GTK_CONTAINER(item),citem->widget);
			        items = g_list_append(items,item);
			}
			break;
                }

		case ARRAY_t:
        	{
        		C_widget *citem;
                	GtkWidget *item;
        		int i;
        		for (i=0; i<cv->a.count; i++)
                	{
                		switch (cv->a.items[i].t.type)
                        	{
                        		case CHARACTER_t:
                        			items = g_list_append(items,gtk_list_item_new_with_label(cv->a.items[i].s.str.buf));
                                        	break;
                                	case MAP_t:
	                                case NUMERIC_t:
					citem = _fetch_cwidget(cm,&cv->a.items[i]);
	                                        CHECKCWID(citem,GTK_IS_WIDGET);
	                                        if (GTK_IS_LIST_ITEM(citem->widget))
	                                        	items = g_list_append(items,citem->widget);
	                                        else
						{
	                                        	item = gtk_list_item_new();
	                                                gtk_container_add(GTK_CONTAINER(item),citem->widget);
						        items = g_list_append(items,item);
						}
	                                	break;
	                                default:
	        				break;
	                	}
	                }

	        }
                default:
	        	break;
	}
        gtk_list_prepend_items(GTK_LIST(clst->widget),items);
	return 0;
err:
	return 1;
}

/* Removes the items from the list. */
int
clip_GTK_LISTREMOVEITEMS(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        ClipVar    *cv = _clip_spar(cm,2);
        GList *items = NULL;
        C_widget *citem;
        int i;
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG(2,ARRAY_t);
        for (i=0; i<cv->a.count; i++)
        {
        	switch (cv->a.items[i].t.type)
                {
                        case MAP_t:
                        case NUMERIC_t:
				citem = _fetch_cwidget(cm,&cv->a.items[i]);
                                CHECKCWID(citem,GTK_IS_LIST_ITEM);
                                items = g_list_append(items,citem->widget);
                        	break;
                        default:
	        		break;
        	}
        }
        gtk_list_remove_items(GTK_LIST(clst->widget),items);
	return 0;
err:
	return 1;
}

/* Removes the items from the list, without unreferencing them.
 * It may be useful if you want to move the items from one list to another. */
int
clip_GTK_LISTREMOVEITEMSNOUNREF(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        ClipVar    *cv = _clip_spar(cm,2);
        GList *items = NULL;
        C_widget *citem;
        int i;
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG(2,ARRAY_t);
        for (i=0; i<cv->a.count; i++)
        {
        	switch (cv->a.items[i].t.type)
                {
                        case MAP_t:
                        case NUMERIC_t:
				citem = _fetch_cwidget(cm,&cv->a.items[i]);
                                CHECKCWID(citem,GTK_IS_LIST_ITEM);
                                items = g_list_append(items,citem->widget);
                        	break;
                        default:
	        		break;
        	}
        }
        gtk_list_remove_items_no_unref(GTK_LIST(clst->widget),items);
	return 0;
err:
	return 1;
}

/* Removes the items between index start (included) and end (excluded)
 * from the list. If end is negative, or greater than the number of
 * children of list, it's assumed to be exactly the number of elements.
 * If start is greater than or equal to end, nothing is done. */
int
clip_GTK_LISTCLEARITEMS(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        gint     start = INT_OPTION(cm,2,1);
        gint       end = INT_OPTION(cm,3,1);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_list_clear_items(GTK_LIST(clst->widget),start-1,end-1);
	return 0;
err:
	return 1;
}

/* Selects the child number item of the list. Nothing happens if item
 * is out of bounds. The signal GtkList::select-child will be emitted. */
int
clip_GTK_LISTSELECTITEM(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        gint      item = INT_OPTION(cm,2,1);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKOPT(2,NUMERIC_t);
        gtk_list_select_item(GTK_LIST(clst->widget),item-1);
	return 0;
err:
	return 1;
}

/* Unselects the child number item of the list. Nothing happens if item
 * is out of bounds. The signal GtkList::unselect-child will be emitted. */
int
clip_GTK_LISTUNSELECTITEM(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        gint      item = INT_OPTION(cm,2,1);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKOPT(2,NUMERIC_t);
        gtk_list_unselect_item(GTK_LIST(clst->widget),item-1);
	return 0;
err:
	return 1;
}

/* Selects the given child. The signal GtkList::select-child will be emitted. */
int
clip_GTK_LISTSELECTCHILD(ClipMachine *cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
        C_widget *cchild = CWIDGET_ARG(cm,2);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_LIST_ITEM);
        gtk_list_select_child(GTK_LIST(clst->widget),cchild->widget);
	return 0;
err:
	return 1;
}

/* Unselects the given child. The signal GtkList::unselect-child will be emitted. */
int
clip_GTK_LISTUNSELECTCHILD(ClipMachine *cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
        C_widget *cchild = CWIDGET_ARG(cm,2);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_LIST_ITEM);
        gtk_list_unselect_child(GTK_LIST(clst->widget),cchild->widget);
	return 0;
err:
	return 1;
}

/* Searches the children of list for the index of child. */
int
clip_GTK_LISTCHILDPOSITION(ClipMachine *cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
        C_widget *cchild = CWIDGET_ARG(cm,2);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_LIST_ITEM);
        _clip_retni(cm,gtk_list_child_position(GTK_LIST(clst->widget),cchild->widget));
	return 0;
err:
	return 1;
}

/*
Set the list selection mode. The selection mode can be any value in GtkSelectionMode:

GTK_SELECTION_SINGLE

    Zero or one element may be selected.

GTK_SELECTION_BROWSE

    Exactly one element is always selected (this can be false after you have changed the selection mode).

GTK_SELECTION_MULTIPLE

    Any number of elements may be selected. Clicks toggle the state of an item.

GTK_SELECTION_EXTENDED

    Any number of elements may be selected. Click-drag selects a range of elements; the Ctrl key may be used to enlarge the
    selection, and Shift key to select between the focus and the child pointed to.
*/
int
clip_GTK_LISTSETSELECTIONMODE(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        GtkSelectionMode mode = _clip_parni(cm,2);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKOPT(2,NUMERIC_t);
        gtk_list_set_selection_mode(GTK_LIST(clst->widget),mode);
	return 0;
err:
	return 1;
}

/* Extends the selection by moving the anchor according
 * to scroll_type. Only in GTK_SELECTION_EXTENDED. */
int
clip_GTK_LISTEXTENDSELECTION(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        GtkScrollType scroll_type = _clip_parni(cm,2);
        gfloat position = _clip_parnd(cm,3);
        gboolean auto_start_selection = BOOL_OPTION(cm,4,TRUE);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t); CHECKOPT(4,LOGICAL_t);
        gtk_list_extend_selection(GTK_LIST(clst->widget),scroll_type,position,auto_start_selection);
	return 0;
err:
	return 1;
}

/* Starts a selection (or part of selection) at the
 * focused child. Only in GTK_SELECTION_EXTENDED mode. */
int
clip_GTK_LISTSTARTSELECTION(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        CHECKCWID(clst,GTK_IS_LIST);
        gtk_list_start_selection(GTK_LIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Ends the selection. Used with gtk_list_extend_selection and
 * gtk_list_start_selection. Only in GTK_SELECTION_EXTENDED. */
int
clip_GTK_LISTENDSELECTION(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        CHECKCWID(clst,GTK_IS_LIST);
        gtk_list_end_selection(GTK_LIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Selects all children of list. A signal will
 * be emitted for each newly selected child. */
int
clip_GTK_LISTSELECTALL(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        CHECKCWID(clst,GTK_IS_LIST);
        gtk_list_select_all(GTK_LIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Unselects all children of list. A signal will
 * be emitted for each newly unselected child. */
int
clip_GTK_LISTUNSELECTALL(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        CHECKCWID(clst,GTK_IS_LIST);
        gtk_list_unselect_all(GTK_LIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Scrolls list horizontaly. This supposes that the list is packed into a
 * scrolled window or something similar, and adjustments are well set. Step
 * and page increment are those from the horizontal adjustment of list.
 * Backward means to the left, and forward to the right. Out of bounds values
 * are truncated. scroll_type may be any valid GtkScrollType. If scroll_type is
 * GTK_SCROLL_NONE, nothing is done. If it's GTK_SCROLL_JUMP, the list scrolls
 * to the ratio position: 0 is full left, 1 is full right. */
int
clip_GTK_LISTSCROLLHORIZONTAL(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        GtkScrollType scroll_type = _clip_parni(cm,2);
        gfloat position = _clip_parnd(cm,3);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_list_scroll_horizontal(GTK_LIST(clst->widget),scroll_type,position);
	return 0;
err:
	return 1;
}

/* Scrolls list vertically. This supposes that the list is packed into a
 * scrolled window or something similar, and adjustments are well set. Step
 * and page increment are those from the vertical adjustment of list.
 * Backward means up, and forward down. Out of bounds values are truncated.
 * scroll_type may be any valid GtkScrollType. If scroll_type is GTK_SCROLL_NONE,
 * nothing is done. If it's GTK_SCROLL_JUMP, the list scrolls to the ratio
 * position: 0 is top, 1 is bottom. */
int
clip_GTK_LISTSCROLLVERTICAL(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        GtkScrollType scroll_type = _clip_parni(cm,2);
        gfloat position = _clip_parnd(cm,3);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_list_scroll_vertical(GTK_LIST(clst->widget),scroll_type,position);
	return 0;
err:
	return 1;
}

/* Toggles between adding to the selection and beginning a new selection.
 * Only in GTK_SELECTION_EXTENDED. Useful with gtk_list_extend_selection. */
int
clip_GTK_LISTTOGGLEADDMODE(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        CHECKCWID(clst,GTK_IS_LIST);
        gtk_list_toggle_add_mode(GTK_LIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Toggles the focus row. If the focus row is selected, it's unselected.
 * If the focus row is unselected, it's selected. If the selection mode of
 * list is GTK_SELECTION_BROWSE, this has no effect, as the selection is
 * always at the focus row. */
int
clip_GTK_LISTTOGGLEFOCUSROW(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        CHECKCWID(clst,GTK_IS_LIST);
        gtk_list_toggle_focus_row(GTK_LIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Toggles the child item of list. If the selection mode of list is
 * GTK_SELECTION_BROWSE, the item is selected, and the others are unselected. */
int
clip_GTK_LISTTOGGLEROW(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        C_widget *citem = CWIDGET_ARG(cm,2);
        CHECKCWID(clst,GTK_IS_LIST);
        CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_IS_LIST_ITEM);
        gtk_list_toggle_row(GTK_LIST(clst->widget),citem->widget);
	return 0;
err:
	return 1;
}

/* Restores the selection in the last state, only if selection mode is
 * GTK_SELECTION_EXTENDED. If this function is called twice, the selection
 * is cleared. This function sometimes gives stranges "last states". */
int
clip_GTK_LISTUNDOSELECTION(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        CHECKCWID(clst,GTK_IS_LIST);
        gtk_list_undo_selection(GTK_LIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Stops the drag selection mode and ungrabs the pointer.
 * This has no effect if a drag selection is not active. */
int
clip_GTK_LISTENDDRAGSELECTION(ClipMachine *cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
        CHECKCWID(clst,GTK_IS_LIST);
        gtk_list_end_drag_selection(GTK_LIST(clst->widget));
	return 0;
err:
	return 1;
}

