/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <string.h>
#include <gtk/gtk.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/**********************************************************/
/****           Combo box has no signals               ****/
/**********************************************************/

/* Register combo box in global table */
CLIP_DLLEXPORT GtkType _gtk_type_combo() { return gtk_combo_get_type(); }
long _clip_type_combo() { return GTK_WIDGET_COMBO; }
const char * _clip_type_name_combo() { return "GTK_WIDGET_COMBO"; }

int
clip_INIT___COMBO(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_combo, _clip_type_name_combo, _gtk_type_combo, _gtk_type_hbox, NULL);
	return 0;
}

/**** Combo box constructor ****/
int
clip_GTK_COMBONEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	C_widget *centry, *clist, *cbutton, *cpopup, *cpopwin;
	CHECKOPT(1,MAP_t);

	wid = gtk_combo_new();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);

	centry = _register_widget(cm, GTK_COMBO(wid)->entry, NULL);
	clist = _register_widget(cm, GTK_COMBO(wid)->list, NULL);
	cbutton = _register_widget(cm, GTK_COMBO(wid)->button, NULL);
	cpopup = _register_widget(cm, GTK_COMBO(wid)->popup, NULL);
	cpopwin = _register_widget(cm, GTK_COMBO(wid)->popwin, NULL);

	if (centry) _clip_madd(cm,&cwid->obj,HASH_ENTRY,&centry->obj);
	if (clist) _clip_madd(cm,&cwid->obj,HASH_LIST,&clist->obj);
	if (cbutton) _clip_madd(cm,&cwid->obj,HASH_BUTTON,&cbutton->obj);
	if (cpopup) _clip_madd(cm,&cwid->obj,HASH_POPUP,&cpopup->obj);
	if (cpopwin) _clip_madd(cm,&cwid->obj,HASH_POPWIN,&cpopwin->obj);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

static int
_combo_simple_list_select (GtkList *list, GtkWidget *widget, gpointer data)
{
	GtkWidget *child = NULL;
	GtkCombo *cb = GTK_COMBO(data);
	char *text;

	child = GTK_BIN(&(GTK_ITEM(widget)->bin))->child;
	if (GTK_IS_LABEL(child))
	{
		gtk_label_get(GTK_LABEL(child), &text);
		gtk_entry_set_text(GTK_ENTRY(cb->entry), text);
	}

	return 0;
}

static int
_combo_simple_find_in_list(GtkCombo *cb, char *ftext)
{
	GList *list = GTK_LIST(cb->list)->children;
	GtkWidget *child = NULL;
	int i;
	char *text;

	LOCALE_TO_UTF(ftext);

	for (i=0; list; i++, list = list->next)
	{
		child = GTK_BIN(&(GTK_ITEM(list->data)->bin))->child;

		if (GTK_IS_LABEL(child))
		{
			gtk_label_get(GTK_LABEL(child), &text);
			if (cb->case_sensitive)
			{
				if (strcmp(ftext,text)==0)
					return i;
			}
			else
			{
				if (strcasecmp(ftext,text)==0)
					return i;
			}
		}
	}
	FREE_TEXT(ftext);

	return -1;
}

static int
_combo_simple_entry_change (GtkEntry *entry, gpointer data)
{
	GtkCombo *cb = GTK_COMBO(data);
	int i;

	i = _combo_simple_find_in_list(cb, gtk_entry_get_text(entry));

	if (i == -1)
		gtk_list_unselect_all(GTK_LIST(cb->list));
	else
	{
		gtk_signal_handler_block_by_func(GTK_OBJECT(cb->list),
			GSF(_combo_simple_list_select), data);
		gtk_list_select_item(GTK_LIST(cb->list),i);
		gtk_signal_handler_unblock_by_func(GTK_OBJECT(cb->list),
			GSF(_combo_simple_list_select), data);
	}
	return 0;
}

static int
_combo_simple_entry_focus_out (GtkWidget *entry, GdkEvent *event, gpointer data)
{
	GtkCombo *cb = GTK_COMBO(data);
	char *etext;
	int i;

	if (!cb->value_in_list) return 0;

	etext = gtk_entry_get_text(GTK_ENTRY(entry));

	if (cb->ok_if_empty && strlen(etext)==0) return 0;

	i = _combo_simple_find_in_list(cb, etext);

	if (i == -1)
		gtk_window_set_focus(GTK_WINDOW(gtk_widget_get_toplevel(cb->entry)), cb->entry);

	return 0;
}

/**** Combo Simple constructor ****/
int
clip_GTK_COMBOSIMPLENEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	GtkWidget *list, *popup;
	C_widget *cwid;
	C_widget *centry, *clist, *cpopup;
	CHECKOPT(1,MAP_t);

	wid = gtk_combo_new();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	if (!cwid) goto err;

	cwid->objtype = GTK_WIDGET_COMBO_SIMPLE;

	gtk_widget_destroy(GTK_COMBO(wid)->list);
	gtk_widget_destroy(GTK_COMBO(wid)->button);
	gtk_widget_destroy(GTK_COMBO(wid)->popup);
	gtk_widget_destroy(GTK_COMBO(wid)->popwin);

	list = gtk_list_new();
	popup = gtk_scrolled_window_new(NULL,NULL);
	gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(popup),GTK_POLICY_AUTOMATIC,GTK_POLICY_AUTOMATIC);
	gtk_scrolled_window_add_with_viewport(GTK_SCROLLED_WINDOW(popup),list);

	GTK_COMBO(wid)->list = list;
	GTK_COMBO(wid)->popup = popup;

	gtk_list_set_selection_mode(GTK_LIST(list), GTK_SELECTION_SINGLE);
	gtk_signal_connect(GTK_OBJECT(list), "select-child",
		GSF(_combo_simple_list_select), wid);

	gtk_signal_connect(GTK_OBJECT(GTK_COMBO(wid)->entry), "changed",
		GSF(_combo_simple_entry_change), wid);
	gtk_signal_connect(GTK_OBJECT(GTK_COMBO(wid)->entry), "focus-out-event",
		GSF(_combo_simple_entry_focus_out), wid);

	centry = _register_widget(cm, GTK_COMBO(wid)->entry, NULL);
	clist = _register_widget(cm, GTK_COMBO(wid)->list, NULL);
	cpopup = _register_widget(cm, GTK_COMBO(wid)->popup, NULL);

	if (centry) _clip_madd(cm,&cwid->obj,HASH_ENTRY,&centry->obj);
	if (clist) _clip_madd(cm,&cwid->obj,HASH_LIST,&clist->obj);
	if (cpopup) _clip_madd(cm,&cwid->obj,HASH_POPUP,&cpopup->obj);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* the text in the entry must be or not be in the list */
int
clip_GTK_COMBOSETVALUEINLIST(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	gint         val = _clip_parl(cm,2);
	gint ok_if_empty = _clip_parl(cm,3);
	CHECKCWID(ccmb,GTK_IS_COMBO);
	CHECKOPT(2,LOGICAL_t); CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) val = TRUE;
	if (_clip_parinfo(cm,3)==UNDEF_t) ok_if_empty = FALSE;
	gtk_combo_set_value_in_list(GTK_COMBO(ccmb->widget), val, ok_if_empty);
	return 0;
err:
	return 1;
}

/* set/unset arrows working for changing the value (can be annoying */
int
clip_GTK_COMBOSETUSEARROWS(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	gint  use_arrows = _clip_parl(cm,2);
	CHECKCWID(ccmb,GTK_IS_COMBO);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) use_arrows = TRUE;
	gtk_combo_set_use_arrows(GTK_COMBO(ccmb->widget), use_arrows);
	return 0;
err:
	return 1;
}

/* up/down arrows change value if current value not in list */
int
clip_GTK_COMBOSETUSEARROWSALWAYS(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	gint  use_arrows = _clip_parl(cm,2);
	CHECKCWID(ccmb,GTK_IS_COMBO);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) use_arrows = TRUE;
	gtk_combo_set_use_arrows_always(GTK_COMBO(ccmb->widget), use_arrows);
	return 0;
err:
	return 1;
}

/* perform case-sensitive compares */
int
clip_GTK_COMBOSETCASESENSITIVE(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	gint   case_sens = _clip_parl(cm,2);
	CHECKCWID(ccmb,GTK_IS_COMBO);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) case_sens = TRUE;
	gtk_combo_set_case_sensitive(GTK_COMBO(ccmb->widget), case_sens);
	return 0;
err:
	return 1;
}

/* call this function on an item if it isn't a label or you
   want it to have a different value to be displayed in the entry */
int
clip_GTK_COMBOSETITEMSTRING(ClipMachine * cm)
{
	C_widget  *ccmb = _fetch_cw_arg(cm);
	C_widget *citem = _fetch_cwidget(cm,_clip_spar(cm,2));
	gchar   *string = _clip_parc(cm,3);
	gchar empty_string[] = "\0";
	CHECKCWID(ccmb,GTK_IS_COMBO);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(citem,GTK_IS_WIDGET);
	CHECKOPT(3,CHARACTER_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) string = empty_string;
	LOCALE_TO_UTF(string);
	gtk_combo_set_item_string(GTK_COMBO(ccmb->widget),
		GTK_ITEM(citem->widget), string);
	FREE_TEXT(string);
	return 0;
err:
	return 1;
}

/* simple interface */
#ifndef OS_CYGWIN
int
clip_GTK_COMBOSETPOPDOWNSTRINGS(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	ClipArrVar *astr = (ClipArrVar*)_clip_vptr(_clip_spar(cm,2));
	GList  *str_list = NULL;
	ClipStrVar *s;
	int i;
	CHECKCWID(ccmb,GTK_IS_COMBO);
	CHECKOPT(2,ARRAY_t);

	for(i=0; i < astr->count; i++ )
	{
		if ( astr->items[i].t.type != CHARACTER_t ) continue;
		s = (ClipStrVar*)_clip_vptr(&astr->items[i]);
		if (ccmb->objtype == GTK_WIDGET_COMBO_SIMPLE)
			str_list = g_list_append( str_list,
				gtk_list_item_new_with_label(s->str.buf) );
		else
			str_list = g_list_append( str_list, s->str.buf );
	}
	if (ccmb->objtype == GTK_WIDGET_COMBO_SIMPLE)
	{
		gtk_list_clear_items(GTK_LIST(GTK_COMBO(ccmb->widget)->list),0,-1);
		gtk_list_append_items(GTK_LIST(GTK_COMBO(ccmb->widget)->list),str_list);
	}
	else
		gtk_combo_set_popdown_strings(GTK_COMBO(ccmb->widget), str_list);
	return 0;
err:
	return 1;
}
#endif

#ifdef OS_CYGWIN
int
clip_GTK_COMBOSETPOPDOWNSTRINGS(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	ClipArrVar *astr = (ClipArrVar*)_clip_vptr(_clip_spar(cm,2));
	GList  *str_list = NULL;
	gchar * text_utf;
	ClipStrVar *s;
	int i;
	CHECKCWID(ccmb,GTK_IS_COMBO);
	CHECKOPT(2,ARRAY_t);

	for(i=0; i < astr->count; i++ )
	{
		if ( astr->items[i].t.type != CHARACTER_t ) continue;
		s = (ClipStrVar*)_clip_vptr(&astr->items[i]);
		text_utf = _clip_locale_to_utf8(s->str.buf);
		if (ccmb->objtype == GTK_WIDGET_COMBO_SIMPLE)
		{
			str_list = g_list_append( str_list,
				gtk_list_item_new_with_label(text_utf) );
			g_free(text_utf);
		}
		else
			str_list = g_list_append( str_list, text_utf );
	}
	if (ccmb->objtype == GTK_WIDGET_COMBO_SIMPLE)
	{
		gtk_list_clear_items(GTK_LIST(GTK_COMBO(ccmb->widget)->list),0,-1);
		gtk_list_append_items(GTK_LIST(GTK_COMBO(ccmb->widget)->list),str_list);
	}
	else
		gtk_combo_set_popdown_strings(GTK_COMBO(ccmb->widget), str_list);

/*
	while (str_list)
	{
		g_free(str_list->data);
		str_list = g_list_next(str_list);
	}
*/
	return 0;
err:
	return 1;
}
#endif

int
clip_GTK_COMBODISABLEACTIVATE(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	CHECKCWID(ccmb,GTK_IS_COMBO);
	gtk_combo_disable_activate(GTK_COMBO(ccmb->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_COMBOGETSELECTIONINDEX(ClipMachine * cm)
{
	C_widget   *ccmb = _fetch_cw_arg(cm);
	GtkList    *list;
	GList *selection;
	int index;
	CHECKCWID(ccmb,GTK_IS_COMBO);
	list = GTK_LIST(GTK_COMBO(ccmb->widget)->list);
	selection = list->selection;
	index = g_list_index(list->children,selection->data);
        _clip_retni(cm, index+1);
	return 0;
err:
	return 1;
}

