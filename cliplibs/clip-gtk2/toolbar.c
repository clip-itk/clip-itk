/*
    Copyright (C) 2001-2004  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    	      Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/* Signal handlers */
gint handle_orientation_changed_signal (GtkWidget *widget, GtkOrientation orientation, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ORIENTATION, orientation);
        INVOKESIGHANDLER(widget,cs,cv);
}

gint handle_style_changed_signal (GtkWidget *widget, GtkToolbarStyle style, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_STYLE, style);
        INVOKESIGHANDLER(widget,cs,cv);
}

/* Signals table */
static SignalTable toolbar_signals[] =
{
	{"orientation-changed",	GSF( handle_orientation_changed_signal ), ESF( object_emit_signal ), GTK_ORIENTATION_CHANGED_SIGNAL},
	{"style-changed",	GSF( handle_style_changed_signal ), ESF( object_emit_signal ), GTK_STYLE_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};


/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_toolbar() { return GTK_TYPE_TOOLBAR; }
long _clip_type_toolbar() { return GTK_WIDGET_TOOLBAR; }
const char * _clip_type_name_toolbar()  { return "GTK_OBJECT_TOOLBAR"; }

/* Register toolbar in global table */
int
clip_INIT___TOOLBAR(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_toolbar,  _clip_type_name_toolbar,  _gtk_type_toolbar,  _gtk_type_container, toolbar_signals);
	return 0;
}

/**** ------------------ ****/
/**** TOOLBAR constructor ****/
int
clip_GTK_TOOLBARNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
        wid = gtk_toolbar_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* not used
static void
_toolbar_child_destroy(ClipMachine * cm, C_widget * cw)
{
	if (cw && cw->data)
        {
        	free (cw->data);
        }
}
*/
static void
_toolbar_child_callback(GtkWidget * widget, gpointer data)
{
	C_var *c = (C_var *)data;
	ClipVar stack[1];
	ClipVar res;
	if (&(c->cfunc))
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		_clip_mclone(c->cw->cmachine, &stack[0], &c->cw->obj);
		//stack[0]  = c->cw->obj;
		_clip_eval( c->cw->cmachine, &(c->cfunc), 1, stack, &res );
		_clip_destroy(c->cw->cmachine, &res);

		_clip_destroy(c->cw->cmachine, &stack[0]);
	}
}

/* adds a new button to the beginning (left or top edges) of the given toolbar. */
int
clip_GTK_TOOLBARAPPENDITEM(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
	char *text = CHAR_OPTION(cm,2,NULL);
        char *tooltip_text = CHAR_OPTION(cm,3,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,4,NULL);
        C_widget  *cicon = _fetch_cwidget(cm,_clip_spar(cm,5));
        ClipVar   *cfunc = _clip_spar(cm,6);
        C_var *c = NEW(C_var);
        GtkWidget *child;
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKOPT(2,CHARACTER_t); CHECKOPT(3,CHARACTER_t); CHECKOPT(4,CHARACTER_t);
	CHECKOPT2(5,MAP_t,NUMERIC_t); CHECKCWIDOPT(cicon,GTK_IS_WIDGET);
	CHECKOPT2(6,PCODE_t,CCODE_t);
        c->cm = cm; c->cw = ctlb; _clip_mclone(cm, &c->cfunc, cfunc);

        if (text) LOCALE_TO_UTF(text);
        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        child = gtk_toolbar_append_item(GTK_TOOLBAR(ctlb->widget),
        	text, tooltip_text, tooltip_private_text,
        	(cicon?cicon->widget:NULL),
        	(GtkSignalFunc)_toolbar_child_callback, c);
        if (text) FREE_TEXT(text);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	if (child)
        {
        	C_widget *cchild = _register_widget(cm,child,NULL);
   //             cchild->destroy = _toolbar_child_destroy;
                cchild->data = c;
		_clip_mclone(cm,RETPTR(cm),&cchild->obj);
        }
	return 0;
err:
	return 1;
}

/* adds a new button to the beginning of the given toolbar. */
int
clip_GTK_TOOLBARPREPENDITEM(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
	char *text = CHAR_OPTION(cm,2,NULL);
        char *tooltip_text = CHAR_OPTION(cm,3,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,4,NULL);
        C_widget  *cicon = _fetch_cwidget(cm,_clip_spar(cm,5));
        ClipVar   *cfunc = _clip_spar(cm,6);
        C_var *c = NEW(C_var);
        GtkWidget *child;
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKOPT(2,CHARACTER_t); CHECKOPT(3,CHARACTER_t); CHECKOPT(4,CHARACTER_t);
	CHECKOPT2(5,MAP_t,NUMERIC_t); CHECKCWIDOPT(cicon,GTK_IS_WIDGET);
	CHECKOPT2(6,PCODE_t,CCODE_t);
        c->cm = cm; c->cw = ctlb; _clip_mclone(cm, &c->cfunc, cfunc);

        if (text) LOCALE_TO_UTF(text);
        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        child = gtk_toolbar_prepend_item(GTK_TOOLBAR(ctlb->widget),
        	text, tooltip_text, tooltip_private_text,
        	(cicon?cicon->widget:NULL),
        	(GtkSignalFunc)_toolbar_child_callback, c);
        if (text) FREE_TEXT(text);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	if (child)
        {
        	C_widget *cchild = _register_widget(cm,child,NULL);
                //cchild->destroy = _toolbar_child_destroy;
                cchild->data = c;
		_clip_mclone(cm,RETPTR(cm),&cchild->obj);
        }
	return 0;
err:
	return 1;
}

/* inserts a new item into the toolbar. You may specify the
 * position in the toolbar where it will be inserted. */
int
clip_GTK_TOOLBARINSERTITEM(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
	char *text = CHAR_OPTION(cm,2,NULL);
        char *tooltip_text = CHAR_OPTION(cm,3,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,4,NULL);
        C_widget  *cicon = _fetch_cwidget(cm,_clip_spar(cm,5));
        ClipVar   *cfunc = _clip_spar(cm,6);
        gint    position = _clip_parni(cm,7);
        C_var *c = NEW(C_var);
        GtkWidget *child;
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKOPT(2,CHARACTER_t); CHECKOPT(3,CHARACTER_t); CHECKOPT(4,CHARACTER_t);
	CHECKOPT2(5,MAP_t,NUMERIC_t); CHECKCWIDOPT(cicon,GTK_IS_WIDGET);
	CHECKOPT2(6,PCODE_t,CCODE_t); CHECKOPT(7,NUMERIC_t);
        c->cm = cm; c->cw = ctlb; _clip_mclone(cm, &c->cfunc, cfunc);

        if (text) LOCALE_TO_UTF(text);
        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        child = gtk_toolbar_insert_item(GTK_TOOLBAR(ctlb->widget), text, tooltip_text,
        	tooltip_private_text, (cicon?cicon->widget:NULL),
        	(GtkSignalFunc)_toolbar_child_callback, c, position);
        if (text) FREE_TEXT(text);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	if (child)
        {
        	C_widget *cchild = _register_widget(cm,child,NULL);
                //cchild->destroy = _toolbar_child_destroy;
                cchild->data = c;
		_clip_mclone(cm,RETPTR(cm),&cchild->obj);
        }
	return 0;
err:
	return 1;
}

/* adds a new space to the end of the toolbar. */
int
clip_GTK_TOOLBARAPPENDSPACE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        gtk_toolbar_append_space(GTK_TOOLBAR(ctlb->widget));
	return 0;
err:
	return 1;
}

/* adds a new space to the beginning of the toolbar. */
int
clip_GTK_TOOLBARPREPENDSPACE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        gtk_toolbar_prepend_space(GTK_TOOLBAR(ctlb->widget));
	return 0;
err:
	return 1;
}

/* inserts a new space in the toolbar at the specified position. */
int
clip_GTK_TOOLBARINSERTSPACE(ClipMachine * cm)
{
	C_widget *ctlb = _fetch_cw_arg(cm);
        gint  position = _clip_parni(cm,2);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKOPT(2,NUMERIC_t);
        gtk_toolbar_insert_space(GTK_TOOLBAR(ctlb->widget),position);
	return 0;
err:
	return 1;
}

/* adds a new element to the end of a toolbar. */
int
clip_GTK_TOOLBARAPPENDELEMENT(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
	GtkToolbarChildType type = INT_OPTION(cm,2,GTK_TOOLBAR_CHILD_SPACE);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,3));
	char *text = CHAR_OPTION(cm,4,NULL);
        char *tooltip_text = CHAR_OPTION(cm,5,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,6,NULL);
        C_widget  *cicon = _fetch_cwidget(cm,_clip_spar(cm,7));
        ClipVar   *cfunc = _clip_spar(cm,8);
        C_var *c = NEW(C_var);
        GtkWidget *child;
        GtkWidget *icon = cicon ? cicon->widget : NULL;
        CHECKCWID(ctlb,GTK_IS_TOOLBAR); CHECKOPT(2,NUMERIC_t);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(4,CHARACTER_t); CHECKOPT(5,CHARACTER_t); CHECKOPT(6,CHARACTER_t);
	CHECKOPT2(7,MAP_t,NUMERIC_t); CHECKCWIDOPT(cicon,GTK_IS_WIDGET);
	CHECKOPT2(8,PCODE_t,CCODE_t);
        c->cm = cm; c->cw = ctlb; _clip_mclone(cm, &c->cfunc, cfunc);

        if (text) LOCALE_TO_UTF(text);
        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        child = gtk_toolbar_append_element(GTK_TOOLBAR(ctlb->widget), type, cwid->widget,
        	text, tooltip_text, tooltip_private_text, icon,
        	(GtkSignalFunc)_toolbar_child_callback, c);
        if (text) FREE_TEXT(text);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	if (child)
        {
        	C_widget *cchild = _register_widget(cm,child,NULL);
                //cchild->destroy = _toolbar_child_destroy;
                cchild->data = c;
		_clip_mclone(cm,RETPTR(cm),&cchild->obj);
        }
        free(c);
	return 0;
err:
	return 1;
}

/* adds a new element to the beginning of a toolbar. */
int
clip_GTK_TOOLBARPREPENDELEMENT(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
	GtkToolbarChildType type = INT_OPTION(cm,2,GTK_TOOLBAR_CHILD_SPACE);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,3));
	char *text = CHAR_OPTION(cm,4,NULL);
        char *tooltip_text = CHAR_OPTION(cm,5,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,6,NULL);
        C_widget  *cicon = _fetch_cwidget(cm,_clip_spar(cm,7));
        ClipVar   *cfunc = _clip_spar(cm,8);
        C_var *c = NEW(C_var);
        GtkWidget *child;
        CHECKCWID(ctlb,GTK_IS_TOOLBAR); CHECKOPT(2,NUMERIC_t);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(4,CHARACTER_t); CHECKOPT(5,CHARACTER_t); CHECKOPT(6,CHARACTER_t);
	CHECKOPT2(7,MAP_t,NUMERIC_t); CHECKCWIDOPT(cicon,GTK_IS_WIDGET);
	CHECKOPT2(8,PCODE_t,CCODE_t);
        c->cm = cm; c->cw = ctlb; _clip_mclone(cm, &c->cfunc, cfunc);

        if (text) LOCALE_TO_UTF(text);
        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        child = gtk_toolbar_prepend_element(GTK_TOOLBAR(ctlb->widget), type, cwid->widget,
        	text, tooltip_text, tooltip_private_text, cicon->widget,
        	(GtkSignalFunc)_toolbar_child_callback, c);
        if (text) FREE_TEXT(text);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	if (child)
        {
        	C_widget *cchild = _register_widget(cm,child,NULL);
                //cchild->destroy = _toolbar_child_destroy;
                cchild->data = c;
		_clip_mclone(cm,RETPTR(cm),&cchild->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARINSERTELEMENT(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
	GtkToolbarChildType type = INT_OPTION(cm,2,GTK_TOOLBAR_CHILD_SPACE);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,3));
	char *text = CHAR_OPTION(cm,4,NULL);
        char *tooltip_text = CHAR_OPTION(cm,5,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,6,NULL);
        C_widget  *cicon = _fetch_cwidget(cm,_clip_spar(cm,7));
        ClipVar   *cfunc = _clip_spar(cm,8);
        gint    position = _clip_parni(cm,9);
        C_var *c = NEW(C_var);
        GtkWidget *child;
        CHECKCWID(ctlb,GTK_IS_TOOLBAR); CHECKOPT(2,NUMERIC_t);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(4,CHARACTER_t); CHECKOPT(5,CHARACTER_t); CHECKOPT(6,CHARACTER_t);
	CHECKOPT2(7,MAP_t,NUMERIC_t); CHECKCWIDOPT(cicon,GTK_IS_WIDGET);
	CHECKOPT2(8,PCODE_t,CCODE_t); CHECKOPT(9,NUMERIC_t);
        c->cm = cm; c->cw = ctlb; _clip_mclone(cm, &c->cfunc, cfunc);

        if (text) LOCALE_TO_UTF(text);
        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        child = gtk_toolbar_insert_element(GTK_TOOLBAR(ctlb->widget),
        				   type,
        				   cwid->widget,
        				   text,
        				   tooltip_text,
        				   tooltip_private_text,
        				   cicon->widget,
        				   (GtkSignalFunc)_toolbar_child_callback,
        				   c,
        				   position);
        if (text) FREE_TEXT(text);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	if (child)
        {
        	C_widget *cchild = _register_widget(cm,child,NULL);
                //cchild->destroy = _toolbar_child_destroy;
                cchild->data = c;
		_clip_mclone(cm,RETPTR(cm),&cchild->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARAPPENDWIDGET(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        char *tooltip_text = CHAR_OPTION(cm,3,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,4,NULL);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,CHARACTER_t); CHECKOPT(4,CHARACTER_t);

        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        gtk_toolbar_append_widget(GTK_TOOLBAR(ctlb->widget), cwid->widget,
        	tooltip_text, tooltip_private_text);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARPREPENDWIDGET(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        char *tooltip_text = CHAR_OPTION(cm,3,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,4,NULL);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,CHARACTER_t); CHECKOPT(4,CHARACTER_t);

        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        gtk_toolbar_prepend_widget(GTK_TOOLBAR(ctlb->widget), cwid->widget,
        	tooltip_text, tooltip_private_text);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARINSERTWIDGET(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        char *tooltip_text = CHAR_OPTION(cm,3,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,4,NULL);
        gint position = _clip_parni(cm,5);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,CHARACTER_t); CHECKOPT(4,CHARACTER_t); CHECKOPT(5,NUMERIC_t);

        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        gtk_toolbar_insert_widget(GTK_TOOLBAR(ctlb->widget), cwid->widget,
        	tooltip_text, tooltip_private_text, position);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	return 0;
err:
	return 1;
}

/* sets whether a toolbar should appear horizontally or vertically. */
int
clip_GTK_TOOLBARSETORIENTATION(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        GtkOrientation orientation = _clip_parni(cm,2);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR); CHECKOPT(2,NUMERIC_t);
        gtk_toolbar_set_orientation(GTK_TOOLBAR(ctlb->widget), orientation);
	return 0;
err:
	return 1;
}

/* alters the view of toolbar to display either icons only, text only, or both. */
int
clip_GTK_TOOLBARSETSTYLE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        GtkToolbarStyle style = _clip_parni(cm,2);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR); CHECKOPT(2,NUMERIC_t);
        gtk_toolbar_set_style(GTK_TOOLBAR(ctlb->widget), style);
	return 0;
err:
	return 1;
}


/* sets if the tooltips of a toolbar should be active or not. */
int
clip_GTK_TOOLBARSETTOOLTIPS(ClipMachine * cm)
{
	C_widget *ctlb = _fetch_cw_arg(cm);
	gboolean enable = BOOL_OPTION(cm,2,TRUE);
        CHECKCWID(ctlb,GTK_IS_TOOLBAR); CHECKOPT(2,LOGICAL_t);
        gtk_toolbar_set_tooltips(GTK_TOOLBAR(ctlb->widget), enable);
	return 0;
err:
	return 1;
}



int
clip_GTK_TOOLBARINSERTSTOCK(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
	char *stock_id = CHAR_OPTION(cm,2,NULL);
        char *tooltip_text = CHAR_OPTION(cm,3,NULL);
        char *tooltip_private_text = CHAR_OPTION(cm,4,NULL);
        ClipVar   *cfunc = _clip_spar(cm,5);
        gint    position = _clip_parni(cm,6);

        C_var *c = NEW(C_var);
        GtkWidget *child;

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKOPT(2,CHARACTER_t); CHECKOPT(3,CHARACTER_t); CHECKOPT(4,CHARACTER_t);
	CHECKOPT2(5,PCODE_t,CCODE_t); CHECKOPT(6,NUMERIC_t);

        c->cm = cm; c->cw = ctlb; _clip_mclone(cm, &c->cfunc, cfunc);

        if (stock_id) LOCALE_TO_UTF(stock_id);
        if (tooltip_text) LOCALE_TO_UTF(tooltip_text);
        if (tooltip_private_text) LOCALE_TO_UTF(tooltip_private_text);
        child = gtk_toolbar_insert_stock(GTK_TOOLBAR(ctlb->widget),
        				   stock_id,
        				   tooltip_text,
        				   tooltip_private_text,
        				   (GtkSignalFunc)_toolbar_child_callback,
        				   c,
        				   position);
        if (stock_id) FREE_TEXT(stock_id);
        if (tooltip_text) FREE_TEXT(tooltip_text);
        if (tooltip_private_text) FREE_TEXT(tooltip_private_text);

	if (child)
        {
        	C_widget *cchild = _register_widget(cm,child,NULL);
                //cchild->destroy = _toolbar_child_destroy;
                cchild->data = c;
		_clip_mclone(cm,RETPTR(cm),&cchild->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARSETICONSIZE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        GtkIconSize size = INT_OPTION(cm, 2, GTK_ICON_SIZE_INVALID);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	gtk_toolbar_set_icon_size(GTK_TOOLBAR(ctlb->widget), size);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETICONSIZE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	_clip_retni(cm, (int)gtk_toolbar_get_icon_size(GTK_TOOLBAR(ctlb->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETORIENTATION(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	_clip_retni(cm, (int)gtk_toolbar_get_orientation(GTK_TOOLBAR(ctlb->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETSTYLE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	_clip_retni(cm, (int)gtk_toolbar_get_style(GTK_TOOLBAR(ctlb->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETTOOLTIPS(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	_clip_retl(cm, gtk_toolbar_get_tooltips(GTK_TOOLBAR(ctlb->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARREMOVESPACE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        gint   position  = _clip_parni(cm, 2);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKARG(2, NUMERIC_t);

	gtk_toolbar_remove_space(GTK_TOOLBAR(ctlb->widget), position - 1);

	return 0;
err:
	return 1;
}


int
clip_GTK_TOOLBARUNSETICONSIZE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	gtk_toolbar_unset_icon_size(GTK_TOOLBAR(ctlb->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARUNSETSTYLE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	gtk_toolbar_unset_style(GTK_TOOLBAR(ctlb->widget));

	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)

int
clip_GTK_TOOLBARINSERT(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        C_widget *citm   = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gint       pos   = _clip_parni(cm, 3);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKCWID(citm,GTK_IS_TOOL_ITEM);
        CHECKARG(3, NUMERIC_t);

	pos = (pos == -1)? pos:pos-1;
	gtk_toolbar_insert(GTK_TOOLBAR(ctlb->widget),
		GTK_TOOL_ITEM(citm->widget), pos);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETITEMINDEX(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        C_widget *citm   = _fetch_cwidget(cm, _clip_spar(cm, 2));

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKCWID(citm,GTK_IS_TOOL_ITEM);

	_clip_retni(cm, gtk_toolbar_get_item_index(GTK_TOOLBAR(ctlb->widget),
		GTK_TOOL_ITEM(citm->widget)) +1);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETNTHITEM(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        gint       nth   = _clip_parni(cm, 2);
        C_widget *citm   ;
        GtkToolItem *itm;

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKARG(2, NUMERIC_t);

	nth --;
	itm = gtk_toolbar_get_nth_item(GTK_TOOLBAR(ctlb->widget), nth);
	if (itm)
        {
        	citm = _list_get_cwidget(cm, itm);
                if (!citm) citm = _register_widget(cm, GTK_WIDGET(itm), NULL);
                if (citm) _clip_mclone(cm, RETPTR(cm), &citm->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETDROPINDEX(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        gint         x   = _clip_parni(cm, 2);
        gint         y   = _clip_parni(cm, 3);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, NUMERIC_t);

	_clip_retni(cm, gtk_toolbar_get_drop_index(GTK_TOOLBAR(ctlb->widget), x, y)+1);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARSETDROPHIGHLIGHTITEM(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        C_widget *citm   = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gint       pos   = _clip_parni(cm, 3);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKCWID(citm,GTK_IS_TOOL_ITEM);
        CHECKARG(3, NUMERIC_t);

	pos = (pos == -1)? pos: pos-1;
	gtk_toolbar_set_drop_highlight_item(GTK_TOOLBAR(ctlb->widget),
		GTK_TOOL_ITEM(citm->widget), pos);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARSETSHOWARROW(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);
        gboolean   set   = _clip_parl(cm, 2);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);
        CHECKARG(2, LOGICAL_t);

	gtk_toolbar_set_show_arrow(GTK_TOOLBAR(ctlb->widget), set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETSHOWARROW(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	_clip_retl(cm, gtk_toolbar_get_show_arrow(GTK_TOOLBAR(ctlb->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBARGETRELIEFSTYLE(ClipMachine * cm)
{
	C_widget *ctlb   = _fetch_cw_arg(cm);

        CHECKCWID(ctlb,GTK_IS_TOOLBAR);

	_clip_retni(cm, gtk_toolbar_get_relief_style(GTK_TOOLBAR(ctlb->widget)));

	return 0;
err:
	return 1;
}
#endif
