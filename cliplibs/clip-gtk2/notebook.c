/*
    Copyright (C) 2001-2004  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    	      Elena V. Kornilova <alena@itk.ru>
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
gint handle_change_current_page_signal (GtkNotebook *notebook, gint page_num,C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_PAGE_NUM, page_num);
	INVOKESIGHANDLER(GTK_WIDGET(notebook),cs,cv);
}

gint handle_move_focus_out_signal (GtkNotebook *notebook, GtkDirectionType type,C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_DIRECTIONTYPE, type);
	INVOKESIGHANDLER(GTK_WIDGET(notebook),cs,cv);
}

gint handle_select_page_signal (GtkNotebook *notebook, gboolean select,C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputl(cs->cw->cmachine, &cv, HASH_SELECT, select);
	INVOKESIGHANDLER(GTK_WIDGET(notebook),cs,cv);
}

gint handle_switch_page_signal (GtkNotebook *notebook,GtkNotebookPage *page,gint page_num,C_signal *cs)
{
	ClipVar cv, mpage, mreq, mallc;
	int ret;
	C_widget *cwid;
	memset(&cv,0,sizeof(ClipVar)); _clip_map(cs->cw->cmachine, &cv);
	memset(&mpage,0,sizeof(ClipVar)); _clip_map(cs->cw->cmachine, &mpage);
	memset(&mreq, 0,sizeof(ClipVar)); _clip_map(cs->cw->cmachine, &mreq);
	memset(&mallc,0,sizeof(ClipVar)); _clip_map(cs->cw->cmachine, &mallc);
	cwid = _list_get_cwidget(cs->cw->cmachine,page->child);
	if (!cwid) cwid = _register_widget(cs->cw->cmachine,page->child,NULL);
	if (cwid) _clip_madd(cs->cw->cmachine, &mpage, HASH_CHILD, &cwid->obj);
	cwid = _list_get_cwidget(cs->cw->cmachine,page->tab_label);
	if (!cwid) cwid = _register_widget(cs->cw->cmachine,page->tab_label,NULL);
	if (cwid) _clip_madd(cs->cw->cmachine, &mpage, HASH_TABLABEL, &cwid->obj);
	cwid = _list_get_cwidget(cs->cw->cmachine,page->menu_label);
	if (!cwid) cwid = _register_widget(cs->cw->cmachine,page->menu_label,NULL);
	if (cwid) _clip_madd(cs->cw->cmachine, &mpage, HASH_MENULABEL, &cwid->obj);
	_clip_mputn(cs->cw->cmachine, &mreq,  HASH_WIDTH, page->requisition.width);
	_clip_mputn(cs->cw->cmachine, &mreq,  HASH_HEIGHT, page->requisition.height);
	_clip_madd(cs->cw->cmachine, &mpage, HASH_REQUISITION, &mreq);
	_clip_mputn(cs->cw->cmachine, &mallc,  HASH_X, page->allocation.x);
	_clip_mputn(cs->cw->cmachine, &mallc,  HASH_Y, page->allocation.y);
	_clip_mputn(cs->cw->cmachine, &mallc,  HASH_WIDTH, page->allocation.width);
	_clip_mputn(cs->cw->cmachine, &mallc,  HASH_HEIGHT, page->allocation.height);
	_clip_madd(cs->cw->cmachine, &mpage, HASH_ALLOCATION, &mallc);
	_clip_mputn(cs->cw->cmachine, &mpage, HASH_DEFAULTMENU, page->default_menu);
	_clip_mputn(cs->cw->cmachine, &mpage, HASH_DEFAULTTAB, page->default_tab);
	_clip_mputn(cs->cw->cmachine, &mpage, HASH_EXPAND, page->expand);
	_clip_mputn(cs->cw->cmachine, &mpage, HASH_PACK, page->pack);
	_clip_mputn(cs->cw->cmachine, &mpage, HASH_FILL, page->fill);
	_clip_madd (cs->cw->cmachine, &cv, HASH_PAGE, &mpage);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_PAGENUM, page_num+1);
	ret = handle_signals (GTK_WIDGET(notebook), cs, &cv);
	_clip_destroy(cs->cw->cmachine, &cv); _clip_destroy(cs->cw->cmachine,&mpage);
	_clip_destroy(cs->cw->cmachine,&mreq); _clip_destroy(cs->cw->cmachine,&mallc);
	return ret;
}

static SignalTable notebook_signals[] =
{
	{"change-current-page",	GSF( handle_change_current_page_signal ), ESF( object_emit_signal ), GTK_CHANGE_CURRENT_PAGE_SIGNAL},
	{"move-focus-out",	GSF( handle_move_focus_out_signal ), ESF( object_emit_signal ), GTK_MOVE_FOCUS_OUT_SIGNAL},
	{"select-page",		GSF( handle_select_page_signal ), ESF( object_emit_signal ), GTK_SELECT_PAGE_SIGNAL},
	{"switch-page",		GSF( handle_switch_page_signal ), ESF( object_emit_signal ), GTK_SWITCH_PAGE_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register notebook in global table */
CLIP_DLLEXPORT GtkType _gtk_type_notebook() { return GTK_TYPE_NOTEBOOK; }
long _clip_type_notebook() { return GTK_WIDGET_NOTEBOOK; }
const char * _clip_type_name_notebook() { return "GTK_WIDGET_NOTEBOOK"; }

int
clip_INIT___NOTEBOOK(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_notebook, _clip_type_name_notebook, _gtk_type_notebook, _gtk_type_container, notebook_signals);
	return 0;
}
/**********************************************************/

/**** Notebook constructor ****/
int
clip_GTK_NOTEBOOKNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_notebook_new();
	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Appends to notebook a page whose content is child, and whose
 * bookmark is label. */
int
clip_GTK_NOTEBOOKAPPENDPAGE(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget *clabel; GtkWidget *label;


	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG3(3,MAP_t,NUMERIC_t,CHARACTER_t);
	CHECKOPT(4,CHARACTER_t);


	if (_clip_parinfo(cm,3)==CHARACTER_t)
	{
		char   * caption = _clip_parc(cm, 3);
		LOCALE_TO_UTF(caption);
		label = gtk_label_new_with_mnemonic(caption);
		FREE_TEXT(caption);

	}
	else
	{
		clabel = _fetch_cwidget(cm,_clip_spar(cm,3));
		CHECKCWID(clabel,GTK_IS_WIDGET);

		if (clabel) label = clabel->widget;
	}
	gtk_notebook_append_page(GTK_NOTEBOOK(cntb->widget), cchild->widget, label);

	return 0;
err:
	return 1;
}

/* Appends to notebook a page whose content is child, whose bookmark
 * is tab_label, and whose menu label is menu_label. */
int
clip_GTK_NOTEBOOKAPPENDPAGEMENU(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget *ctab_label; GtkWidget *tab_label;
	C_widget *cmenu_label; GtkWidget *menu_label;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG3(3,MAP_t,NUMERIC_t,CHARACTER_t);
	CHECKARG3(4,MAP_t,NUMERIC_t,CHARACTER_t);
	if (_clip_parinfo(cm,3)==CHARACTER_t) {
		char   * caption = _clip_parc(cm, 3);
		LOCALE_TO_UTF(caption);
		tab_label = gtk_label_new_with_mnemonic(caption);
		FREE_TEXT(caption);
	}
	else
	{
		ctab_label = _fetch_cwidget(cm,_clip_spar(cm,3));
		CHECKCWID(ctab_label,GTK_IS_WIDGET);
		if (ctab_label) tab_label = ctab_label->widget;
	}
	if (_clip_parinfo(cm,4)==CHARACTER_t) {
		char   * menu_text = _clip_parc(cm, 4);
		LOCALE_TO_UTF(menu_text);
		menu_label = gtk_label_new_with_mnemonic(menu_text);
		FREE_TEXT(menu_text);
	}
	else
	{
		cmenu_label = _fetch_cwidget(cm,_clip_spar(cm,4));
		CHECKCWID(cmenu_label,GTK_IS_WIDGET);
		if (cmenu_label) menu_label = cmenu_label->widget;
	}
	gtk_notebook_append_page_menu(GTK_NOTEBOOK(cntb->widget), cchild->widget, tab_label, menu_label);
	return 0;
err:
	return 1;
}

/* Prepends to notebook a page whose content is child, and whose
 * bookmark is label. */
int
clip_GTK_NOTEBOOKPREPENDPAGE(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget *clabel; GtkWidget *label;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG3(3,MAP_t,NUMERIC_t,CHARACTER_t);
	if (_clip_parinfo(cm,3)==CHARACTER_t) {
		char   * caption = _clip_parc(cm, 3);
		LOCALE_TO_UTF(caption);
		label = gtk_label_new_with_mnemonic(caption);
		FREE_TEXT(caption);
	}
	else
	{
		clabel = _fetch_cwidget(cm,_clip_spar(cm,3));
		CHECKCWID(clabel,GTK_IS_WIDGET);
		if (clabel) label = clabel->widget;
	}
	gtk_notebook_prepend_page(GTK_NOTEBOOK(cntb->widget), cchild->widget, label);
	return 0;
err:
	return 1;
}

/* Prepends to notebook a page whose content is child, whose bookmark
 * is tab_label, and whose menu label is menu_label. */
int
clip_GTK_NOTEBOOKPREPENDPAGEMENU(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget *ctab_label; GtkWidget *tab_label;
	C_widget *cmenu_label; GtkWidget *menu_label;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG3(3,MAP_t,NUMERIC_t,CHARACTER_t);
	CHECKARG3(4,MAP_t,NUMERIC_t,CHARACTER_t);
	if (_clip_parinfo(cm,3)==CHARACTER_t) {
		char   * caption = _clip_parc(cm, 3);
		LOCALE_TO_UTF(caption);
		tab_label = gtk_label_new_with_mnemonic(caption);
		FREE_TEXT(caption);
	}
	else
	{
		ctab_label = _fetch_cwidget(cm,_clip_spar(cm,3));
		CHECKCWID(ctab_label,GTK_IS_WIDGET);
		if (ctab_label) tab_label = ctab_label->widget;
	}
	if (_clip_parinfo(cm,4)==CHARACTER_t) {
		char   * menu_text = _clip_parc(cm, 4);
		LOCALE_TO_UTF(menu_text);
		menu_label = gtk_label_new_with_mnemonic(menu_text);
		FREE_TEXT(menu_text);
	}
	else
	{
		cmenu_label = _fetch_cwidget(cm,_clip_spar(cm,4));
		CHECKCWID(cmenu_label,GTK_IS_WIDGET);
		if (cmenu_label) menu_label = cmenu_label->widget;
	}
	gtk_notebook_prepend_page_menu(GTK_NOTEBOOK(cntb->widget), cchild->widget, tab_label, menu_label);
	return 0;
err:
	return 1;
}

/* Inserts in notebook a new page whose content is child, and whose bookmark
 * is tab_label. The page is inserted just before the page number position,
 * starting with 0. If position is out of bounds, it is assumed to be the
 * current number of pages.  */
int
clip_GTK_NOTEBOOKINSERTPAGE(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget *clabel; GtkWidget *label;
	gint    position = _clip_parni(cm,4);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG3(3,MAP_t,NUMERIC_t,CHARACTER_t);
	CHECKOPT(4,NUMERIC_t);
	if (_clip_parinfo(cm,3)==CHARACTER_t) {
		char   * caption = _clip_parc(cm, 3);
		LOCALE_TO_UTF(caption);
		label = gtk_label_new_with_mnemonic(caption);
		FREE_TEXT(caption);
	}
	else
	{
		clabel = _fetch_cwidget(cm,_clip_spar(cm,3));
		CHECKCWID(clabel,GTK_IS_WIDGET);
		if (clabel) label = clabel->widget;
	}
	if (_clip_parinfo(cm,4)==UNDEF_t) position = 1;
	gtk_notebook_insert_page(GTK_NOTEBOOK(cntb->widget), cchild->widget, label, position-1);
	return 0;
err:
	return 1;
}

/* Inserts in notebook a new page whose content is child, whose bookmark is
 * tab_label, and whose menu label is menu_label. The page is inserted just
 * before the page number position, starting with 0. If position is out of
 * bounds, it is assumed to be the current number of pages. */
int
clip_GTK_NOTEBOOKINSERTPAGEMENU(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget *ctab_label; GtkWidget *tab_label;
	C_widget *cmenu_label; GtkWidget *menu_label;
	gint    position = _clip_parni(cm,5);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG3(3,MAP_t,NUMERIC_t,CHARACTER_t);
	CHECKARG3(4,MAP_t,NUMERIC_t,CHARACTER_t);
	CHECKOPT(5,NUMERIC_t);
	if (_clip_parinfo(cm,3)==CHARACTER_t) {
		char   * caption = _clip_parc(cm, 3);
		LOCALE_TO_UTF(caption);
		tab_label = gtk_label_new_with_mnemonic(caption);
		FREE_TEXT(caption);
	}
	else
	{
		ctab_label = _fetch_cwidget(cm,_clip_spar(cm,3));
		CHECKCWID(ctab_label,GTK_IS_WIDGET);
		if (ctab_label) tab_label = ctab_label->widget;
	}
	if (_clip_parinfo(cm,4)==CHARACTER_t) {
		char   * menu_text = _clip_parc(cm, 4);
		LOCALE_TO_UTF(menu_text);
		menu_label = gtk_label_new(menu_text);
		FREE_TEXT(menu_text);
	}
	else
	{
		cmenu_label = _fetch_cwidget(cm,_clip_spar(cm,4));
		CHECKCWID(cmenu_label,GTK_IS_WIDGET);
		if (cmenu_label) menu_label = cmenu_label->widget;
	}
	if (_clip_parinfo(cm,5)==UNDEF_t) position = 1;
	gtk_notebook_insert_page_menu(GTK_NOTEBOOK(cntb->widget), cchild->widget, tab_label, menu_label, position-1);
	return 0;
err:
	return 1;
}

/* Removes the page page_num form notebook. Pages are numbered starting at 1.
 * Negative values stand for the last page; too large values are ignored. */
int
clip_GTK_NOTEBOOKREMOVETPAGE(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	gint    page_num = _clip_parni(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) page_num = 1;
	gtk_notebook_remove_page(GTK_NOTEBOOK(cntb->widget), page_num-1);
	return 0;
err:
	return 1;
}
/* Returns the page number of child in notebook. */
int
clip_GTK_NOTEBOOKPAGENUM(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	_clip_retni(cm,gtk_notebook_page_num(GTK_NOTEBOOK(cntb->widget), cchild->widget)+1);
	return 0;
err:
	return 1;
}

/* Switches to the page number page_num. Negative values stand for the
 * last page; too large values are ignored. */
int
clip_GTK_NOTEBOOKSETPAGE(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	gint    page_num = _clip_parni(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) page_num = 1;
	gtk_notebook_set_page(GTK_NOTEBOOK(cntb->widget), (page_num>0?page_num-1:page_num));
	return 0;
err:
	return 1;
}

/* Switches to the next page.
 * Nothing happens if the current page is the last page. */
int
clip_GTK_NOTEBOOKNEXTPAGE(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	gtk_notebook_next_page(GTK_NOTEBOOK(cntb->widget));
	return 0;
err:
	return 1;
}

/* Switches to the previous page.
 * Nothing happens if the current page is the first page. */
int
clip_GTK_NOTEBOOKPREVPAGE(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	gtk_notebook_prev_page(GTK_NOTEBOOK(cntb->widget));
	return 0;
err:
	return 1;
}

/* Moves the page child, so that it appears in position position.
 * Out of bounds position will be clamped. */
int
clip_GTK_NOTEBOOKREORDERCHILD(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	gint    position = _clip_parni(cm,3);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) position = 1;
	gtk_notebook_reorder_child(GTK_NOTEBOOK(cntb->widget), cchild->widget, position);
	return 0;
err:
	return 1;
}

/* Sets the position of the bookmarks. */
int
clip_GTK_NOTEBOOKSETTABPOS(ClipMachine * cm)
{
	C_widget      *cntb = _fetch_cw_arg(cm);
	GtkPositionType pos = _clip_parni(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,NUMERIC_t);
	gtk_notebook_set_tab_pos(GTK_NOTEBOOK(cntb->widget), pos);
	return 0;
err:
	return 1;
}

/* Sets whether to show the bookmarks or not. */
int
clip_GTK_NOTEBOOKSETSHOWTABS(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);
	gboolean show_tabs = _clip_parl(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) show_tabs = TRUE;
	gtk_notebook_set_show_tabs(GTK_NOTEBOOK(cntb->widget), show_tabs);
	return 0;
err:
	return 1;
}

/* Sets whether to show the border of the notebook or not.
 * Bookmarks are in the border. */
int
clip_GTK_NOTEBOOKSETSHOWBORDER(ClipMachine * cm)
{
	C_widget       *cntb = _fetch_cw_arg(cm);
	gboolean show_border = _clip_parl(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) show_border = TRUE;
	gtk_notebook_set_show_border(GTK_NOTEBOOK(cntb->widget), show_border);
	return 0;
err:
	return 1;
}

/* Sets whether the bookmarks area may be scrollable or not if there are
 * too many bookmarks to fit in the allocated area. */
int
clip_GTK_NOTEBOOKSETSCROLLABLE(ClipMachine * cm)
{
	C_widget      *cntb = _fetch_cw_arg(cm);
	gboolean scrollable = _clip_parl(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) scrollable = TRUE;
	gtk_notebook_set_scrollable(GTK_NOTEBOOK(cntb->widget), scrollable);
	return 0;
err:
	return 1;
}

/* Sets whether there should be a border around the bookmarks or not. */
int
clip_GTK_NOTEBOOKSETTABBORDER(ClipMachine * cm)
{
	C_widget      *cntb = _fetch_cw_arg(cm);
	guint  border_width = _clip_parl(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,NUMERIC_t);
	gtk_notebook_set_tab_border(GTK_NOTEBOOK(cntb->widget), border_width);
	return 0;
err:
	return 1;
}

/* Enables the popup menu: if the user clicks with the right mouse button
 * on the bookmarks, a menu with all the pages will be popped up. */
int
clip_GTK_NOTEBOOKPOPUPENABLE(ClipMachine * cm)
{
	C_widget      *cntb = _fetch_cw_arg(cm);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	gtk_notebook_popup_enable(GTK_NOTEBOOK(cntb->widget));
	return 0;
err:
	return 1;
}

/* Disables the popup menu */
int
clip_GTK_NOTEBOOKPOPUPDISABLE(ClipMachine * cm)
{
	C_widget      *cntb = _fetch_cw_arg(cm);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	gtk_notebook_popup_disable(GTK_NOTEBOOK(cntb->widget));
	return 0;
err:
	return 1;
}

/* Returns the page number of the current page. */
int
clip_GTK_NOTEBOOKGETCURRENTPAGE(ClipMachine * cm)
{
	C_widget      *cntb = _fetch_cw_arg(cm);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	_clip_retni(cm,gtk_notebook_get_current_page(GTK_NOTEBOOK(cntb->widget))+1);
	return 0;
err:
	return 1;
}

/* Returns the menu label of the page child. NULL is returned if child is
 * not in notebook or NULL if it has the default menu label. */
int
clip_GTK_NOTEBOOKGETMENULABEL(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget   *cwid;
	GtkWidget *wid;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	wid = gtk_notebook_get_menu_label(GTK_NOTEBOOK(cntb->widget), cchild->widget);
	if (wid)
        {
		cwid = _list_get_cwidget(cm,wid);
		if (!cwid) cwid = _register_widget(cm,wid,NULL);
		if (cwid) _clip_mclone(cm,RETPTR(cm),&cwid->obj);
        }
	return 0;
err:
	return 1;
}

/* Returns the content of the page number page_num, or
 * NULL if page_num is out of bounds. */
int
clip_GTK_NOTEBOOKGETNTHPAGE(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	gint    page_num = _clip_parni(cm,2);
	C_widget   *cwid;
	GtkWidget *wid;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) page_num = 1;
	wid = gtk_notebook_get_nth_page(GTK_NOTEBOOK(cntb->widget), page_num-1);
	cwid = _list_get_cwidget(cm,wid);
	if (!cwid) cwid = _register_widget(cm,wid,NULL);
	if (cwid) _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Returns the menu tab of the page child. NULL is returned if child is
 * not in notebook or NULL if it has the default tab label. */
int
clip_GTK_NOTEBOOKGETTABLABEL(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget   *cwid;
	GtkWidget *wid;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	wid = gtk_notebook_get_tab_label(GTK_NOTEBOOK(cntb->widget), cchild->widget);
	cwid = _list_get_cwidget(cm,wid);
	if (!cwid) cwid = _register_widget(cm,wid,NULL);
	if (cwid) _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Looks for the packing attributes of the bookmarks of child. */
int
clip_GTK_NOTEBOOKQUERYTABLABELPACKING(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	gboolean expand, fill;
	GtkPackType pack_type;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	gtk_notebook_query_tab_label_packing(GTK_NOTEBOOK(cntb->widget),
		cchild->widget, &expand, &fill, &pack_type);
	_clip_storni(cm,expand,3,0);
	_clip_storni(cm,fill,4,0);
	_clip_storni(cm,pack_type,5,0);
	return 0;
err:
	return 1;
}

/* Sets whether the tabs must have all the same size or not. */
int
clip_GTK_NOTEBOOKSETHOMOGENEOUSTABS(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);
	guint  homogeneous = _clip_parl(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) homogeneous = TRUE;
	gtk_notebook_set_homogeneous_tabs(GTK_NOTEBOOK(cntb->widget), homogeneous);
	return 0;
err:
	return 1;
}

/* Changes the menu label of child. Nothing happens if child is not in notebook. */
int
clip_GTK_NOTEBOOKSETMENULABEL(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget *clabel;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG3(3,MAP_t,NUMERIC_t,CHARACTER_t);
	if (_clip_parinfo(cm,3)==CHARACTER_t) {
		char * menu_text = _clip_parc(cm,3);
		LOCALE_TO_UTF(menu_text);
		gtk_notebook_set_menu_label_text(GTK_NOTEBOOK(cntb->widget),
			cchild->widget, menu_text);
		FREE_TEXT(menu_text);
	}
	else
	{
		clabel = _fetch_cwidget(cm,_clip_spar(cm,3));
		CHECKCWID(clabel,GTK_IS_WIDGET);
		if (clabel)
			gtk_notebook_set_menu_label(GTK_NOTEBOOK(cntb->widget),
				cchild->widget, clabel->widget);

	}
	return 0;
err:
	return 1;
}

/* Sets whether the tabs should have a horizontal border. */
int
clip_GTK_NOTEBOOKSETTABHBORDER(ClipMachine * cm)
{
	C_widget       *cntb = _fetch_cw_arg(cm);
	gboolean tab_hborder = _clip_parl(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) tab_hborder = TRUE;
	gtk_notebook_set_tab_hborder(GTK_NOTEBOOK(cntb->widget), tab_hborder);
	return 0;
err:
	return 1;
}

/* Changes the bookmark label of child. Nothing happens if child is not in notebook. */
int
clip_GTK_NOTEBOOKSETTABLABEL(ClipMachine * cm)
{
	C_widget   *cntb = _fetch_cw_arg(cm);
	C_widget *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_widget *clabel;
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG3(3,MAP_t,NUMERIC_t,CHARACTER_t);
	if (_clip_parinfo(cm,3)==CHARACTER_t) {
		char   * caption = _clip_parc(cm, 3);
		LOCALE_TO_UTF(caption);
		gtk_notebook_set_tab_label_text(GTK_NOTEBOOK(cntb->widget),
			cchild->widget,caption);
		FREE_TEXT(caption);
	}
	else
	{
		clabel = _fetch_cwidget(cm,_clip_spar(cm,3));
		CHECKCWID(clabel,GTK_IS_WIDGET);
		if (clabel)
			gtk_notebook_set_tab_label(GTK_NOTEBOOK(cntb->widget),
				cchild->widget,clabel->widget);

	}
	return 0;
err:
	return 1;
}

/* Sets the packing parameters for the bookmark of child.
 * See GtkBoxPackStart for the exact meanings. */
int
clip_GTK_NOTEBOOKSETTABLABELPACKING(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);
	C_widget   *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
	gboolean    expand = _clip_parl(cm,3);
	gboolean      fill = _clip_parl(cm,4);
	guint packing_type = _clip_parni(cm,5);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKOPT(3,LOGICAL_t); CHECKOPT(4,LOGICAL_t); CHECKOPT(5,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) expand = TRUE;
	if (_clip_parinfo(cm,4)==UNDEF_t) fill = TRUE;
	gtk_notebook_set_tab_label_packing(GTK_NOTEBOOK(cntb->widget),
		cchild->widget, expand, fill, packing_type);
	return 0;
err:
	return 1;
}

int
clip_GTK_NOTEBOOKSETTABLABELTEXT(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);
	C_widget   *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
        gchar        *text = _clip_parc(cm, 3);

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	CHECKARG(3,CHARACTER_t);
	LOCALE_TO_UTF(text);
	gtk_notebook_set_tab_label_text(GTK_NOTEBOOK(cntb->widget),
		cchild->widget, text);
        FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Sets whether the tabs should have a vertical border. */
int
clip_GTK_NOTEBOOKSETTABVBORDER(ClipMachine * cm)
{
	C_widget       *cntb = _fetch_cw_arg(cm);
	gboolean tab_vborder = _clip_parl(cm,2);
	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) tab_vborder = TRUE;
	gtk_notebook_set_tab_vborder(GTK_NOTEBOOK(cntb->widget), tab_vborder);
	return 0;
err:
	return 1;
}

int
clip_GTK_NOTEBOOKGETMENULABELTEXT(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);
	C_widget   *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
        gchar        *text ;

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	text = (gchar *)gtk_notebook_get_menu_label_text(GTK_NOTEBOOK(cntb->widget),
		GTK_WIDGET(cchild->widget));
	LOCALE_TO_UTF(text);
        _clip_retc(cm, text);
        FREE_TEXT(text);
	return 0;
err:
	return 1;
}

int
clip_GTK_NOTEBOOKGETSCROLLABLE(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	_clip_retl(cm, gtk_notebook_get_scrollable(GTK_NOTEBOOK(cntb->widget)));
	return 0;
err:
	return 1;
}


int
clip_GTK_NOTEBOOKGETSHOWBORDER(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	_clip_retl(cm, gtk_notebook_get_show_border(GTK_NOTEBOOK(cntb->widget)));
	return 0;
err:
	return 1;
}



int
clip_GTK_NOTEBOOKGETSHOWTABS(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	_clip_retl(cm, gtk_notebook_get_show_tabs(GTK_NOTEBOOK(cntb->widget)));
	return 0;
err:
	return 1;
}


int
clip_GTK_NOTEBOOKGETTABLABELTEXT(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);
	C_widget   *cchild = _fetch_cwidget(cm,_clip_spar(cm,2));
        gchar        *text ;

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cchild,GTK_IS_WIDGET);
	text = (gchar *)gtk_notebook_get_tab_label_text(GTK_NOTEBOOK(cntb->widget),
		GTK_WIDGET(cchild->widget));
	LOCALE_TO_UTF(text);
        _clip_retc(cm, text);
        FREE_TEXT(text);
	return 0;
err:
	return 1;
}

int
clip_GTK_NOTEBOOKGETTABPOS(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
	_clip_retni(cm, (int)gtk_notebook_get_tab_pos(GTK_NOTEBOOK(cntb->widget)));
	return 0;
err:
	return 1;
}


int
clip_GTK_NOTEBOOKSETCURRENTPAGE(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);
        gint          page = _clip_parni(cm, 2);

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);
        CHECKARG(2, NUMERIC_t);
	gtk_notebook_set_current_page(GTK_NOTEBOOK(cntb->widget), page-1);
	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 2)
int
clip_GTK_NOTEBOOKGETNPAGES(ClipMachine * cm)
{
	C_widget     *cntb = _fetch_cw_arg(cm);

	CHECKCWID(cntb,GTK_IS_NOTEBOOK);

	_clip_retni(cm, gtk_notebook_get_n_pages(GTK_NOTEBOOK(cntb->widget)));

	return 0;
err:
	return 1;
}

#endif
