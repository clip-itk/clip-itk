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

/*********************** SIGNALS **************************/

/**************** SIGNALS for List Item  ******************/

/* Signal handlers */
static gint handle_extend_selection_signal (GtkWidget *widget, GtkScrollType scroll_type, gfloat position, gboolean auto_start_selection, C_signal *cs)
{
	PREPARECV(cs,cv);
  	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLLTYPE, scroll_type);
  	_clip_mputn(cs->cw->cmachine, &cv, HASH_POSITION, position);
  	_clip_mputl(cs->cw->cmachine, &cv, HASH_AUTOSTARTSELECTION, auto_start_selection);
        INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_scroll_vertical_signal (GtkWidget *widget, GtkScrollType scroll_type, gfloat position, C_signal *cs)
{
	PREPARECV(cs,cv);
  	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLLTYPE, scroll_type);
  	_clip_mputn(cs->cw->cmachine, &cv, HASH_POSITION, position);
        INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_scroll_horizontal_signal (GtkWidget *widget, GtkScrollType scroll_type, gfloat position, C_signal *cs)
{
	PREPARECV(cs,cv);
  	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLLTYPE, scroll_type);
  	_clip_mputn(cs->cw->cmachine, &cv, HASH_POSITION, position);
        INVOKESIGHANDLER(widget,cs,cv);
}

static gint emit_extend_selection_signal (C_widget *cwid, const gchar *signal_name)
{
	ClipMachine               *cm = cwid->cmachine;
        GtkScrollType     scroll_type = _clip_parni(cm,3);
        gfloat               position = _clip_parnd(cm,4);
        gboolean auto_start_selection = _clip_parl(cm,5);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,LOGICAL_t);
        if (_clip_parinfo(cm,5)==UNDEF_t) auto_start_selection = TRUE;
        gtk_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name,
        	scroll_type,position,auto_start_selection,
        	cwid);
	return 0;
err:
	return 1;
}

static gint emit_scroll_signal (C_widget *cwid, const gchar *signal_name)
{
	ClipMachine               *cm = cwid->cmachine;
        GtkScrollType     scroll_type = _clip_parni(cm,3);
        gfloat               position = _clip_parnd(cm,4);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
        gtk_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name,
        	scroll_type,position,
        	cwid);
	return 0;
err:
	return 1;
}

/* Signals table */
static SignalTable list_item_signals[] =
{
	{"toggle-focus-row",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_TOGGLE_FOCUS_ROW_SIGNAL },
	{"select-all",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SELECT_ALL_SIGNAL       },
	{"unselect-all",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_UNSELECT_ALL_SIGNAL     },
	{"undo-selection",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_UNDO_SELECTION_SIGNAL   },
	{"start-selection",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_START_SELECTION_SIGNAL  },
	{"end-selection",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_END_SELECTION_SIGNAL    },
	{"toggle-add-mode",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_TOGGLE_ADD_MODE_SIGNAL  },
	{"extend-selection",	GSF( handle_extend_selection_signal  ), ESF( emit_extend_selection_signal ), GTK_EXTEND_SELECTION_SIGNAL },
	{"scroll-vertical",	GSF( handle_scroll_vertical_signal   ), ESF( emit_scroll_signal ), GTK_SCROLL_VERTICAL_SIGNAL  },
	{"scroll-horizontal",	GSF( handle_scroll_horizontal_signal ), ESF( emit_scroll_signal ), GTK_SCROLL_HORIZONTAL_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register ListItem in global table */
CLIP_DLLEXPORT GtkType _gtk_type_list_item() { return GTK_TYPE_LIST_ITEM; }
long _clip_type_list_item() { return GTK_WIDGET_LIST_ITEM; }
const char * _clip_type_name_list_item() { return "GTK_WIDGET_LIST_ITEM"; }

int
clip_INIT___LISTITEM(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_list_item, _clip_type_name_list_item, _gtk_type_list_item, _gtk_type_item, list_item_signals);
	return 0;
}
/**********************************************************/

/****  LIST ITEM constructor ****/
int
clip_GTK_LISTITEMNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
        C_widget *cchild;
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);
        CHECKOPT3(2,CHARACTER_t,MAP_t,NUMERIC_t);
        switch (_clip_parinfo(cm,2))
        {
        	case CHARACTER_t:
                	wid = gtk_list_item_new_with_label(_clip_parc(cm,2));
                        break;
                case MAP_t:
                case NUMERIC_t:
                        wid = gtk_list_item_new();
                        cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
                        CHECKCWID(cchild,GTK_IS_WIDGET);
                        gtk_container_add(GTK_CONTAINER(wid), cchild->widget);
                        break;
        }

        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/* Selects the item, by emitting the item's "select" signal.
 * Depending on the selection mode of the list, this may cause
 * other items to be deselected.*/
int
clip_GTK_LISTITEMSELECT(ClipMachine *cm)
{
	C_widget *clitm = _fetch_cw_arg(cm);
        CHECKCWID(clitm,GTK_IS_LIST_ITEM);
        gtk_list_item_select(GTK_LIST_ITEM(clitm->widget));
	return 0;
err:
	return 1;
}

/* Deselects the item, by emitting the item's "deselect" signal. */
int
clip_GTK_LISTITEMDESELECT(ClipMachine *cm)
{
	C_widget *clitm = _fetch_cw_arg(cm);
        CHECKCWID(clitm,GTK_IS_LIST_ITEM);
        gtk_list_item_deselect(GTK_LIST_ITEM(clitm->widget));
	return 0;
err:
	return 1;
}

/* Returns text in item */
int
clip_GTK_LISTITEMGETTEXT(ClipMachine *cm)
{
	C_widget *clitm = _fetch_cw_arg(cm);
        GtkWidget *child = NULL;
        char *text;
        CHECKCWID(clitm,GTK_IS_LIST_ITEM);
        child = GTK_BIN(&(GTK_ITEM(clitm->widget)->bin))->child;
        if (GTK_IS_LABEL(child))
        {
        	gtk_label_get(GTK_LABEL(child), &text);
		LOCALE_TO_UTF(text);
		_clip_retc(cm,text);
        	FREE_TEXT(text);
	}
	return 0;
err:
	return 1;
}


