/*
    Copyright (C) 2002  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
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
static gint
handle_widget_entered_signal (GtkWidget *widget, GtkWidget *wid, gchar *tip_text, gchar *tip_private, C_signal *cs)
{
	C_widget *cwid = _list_get_cwidget(cs->cw->cmachine,wid);
	PREPARECV(cs,cv);
        if (!cwid) cwid = _register_widget(cs->cw->cmachine,wid,NULL);
	if (cwid) _clip_madd(cs->cw->cmachine, &cv, HASH_WIDGET, &cwid->obj);
	LOCALE_FROM_UTF(tip_text);
	LOCALE_FROM_UTF(tip_private);
	_clip_mputc(cs->cw->cmachine, &cv, HASH_TIPTEXT, tip_text, strlen(tip_text));
	_clip_mputc(cs->cw->cmachine, &cv, HASH_TIPPRIVATE, tip_private, strlen(tip_private));
       	FREE_TEXT(tip_text);
       	FREE_TEXT(tip_private);
        INVOKESIGHANDLER(widget,cs,cv);
}

static gint
handle_widget_selected_signal (GtkWidget *widget, GtkWidget *wid, gchar *tip_text, gchar *tip_private, GdkEventButton *event, C_signal *cs)
{
	C_widget *cwid = _list_get_cwidget(cs->cw->cmachine,wid);
	PREPARECV(cs,cv);
        if (!cwid) cwid = _register_widget(cs->cw->cmachine,wid,NULL);
	if (cwid) _clip_madd(cs->cw->cmachine, &cv, HASH_WIDGET, &cwid->obj);
	LOCALE_FROM_UTF(tip_text);
	LOCALE_FROM_UTF(tip_private);
	_clip_mputc(cs->cw->cmachine, &cv, HASH_TIPTEXT, tip_text, strlen(tip_text));
	_clip_mputc(cs->cw->cmachine, &cv, HASH_TIPPRIVATE, tip_private, strlen(tip_private));
	_clip_mputn(cs->cw->cmachine, &cv, HASH_BUTTON, event->button);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_X, event->x);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_Y, event->y);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_XROOT, event->x_root);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_YROOT, event->y_root);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_STATE, event->state);
       	FREE_TEXT(tip_text);
       	FREE_TEXT(tip_private);
        INVOKESIGHANDLER(widget,cs,cv);
}

/* Signals table */
static SignalTable tips_query_signals[] =
{
	/* Emitted when the query is started. */
	{"start-query",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_START_QUERY_SIGNAL},
	/* Emitted when the query is stopped. */
	{"stop-query",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_STOP_QUERY_SIGNAL},
	/* Emitted when a widget is entered by the pointer while the query is in effect. */
	{"widget-entered",	GSF( handle_widget_entered_signal ), ESF( object_emit_signal ), GTK_WIDGET_ENTERED_SIGNAL},
	/* Emitted when a widget is selected during a query. */
	{"widget-selected",	GSF( handle_widget_selected_signal ), ESF( object_emit_signal ), GTK_WIDGET_SELECTED_SIGNAL},
	{"", NULL, NULL, 0}
};


/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_tips_query() { return GTK_TYPE_TIPS_QUERY; }
long _clip_type_tips_query() { return GTK_WIDGET_TIPS_QUERY; }
const char * _clip_type_name_tips_query()  { return "GTK_OBJECT_TIPS_QUERY"; }

/* Register toolbar in global table */
int
clip_INIT___TIPS_QUERY(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_tips_query,  _clip_type_name_tips_query,  _gtk_type_tips_query,  _gtk_type_label, tips_query_signals);
	return 0;
}

/**** ------------------ ****/
/**** TIPS QUERY constructor ****/
int
clip_GTK_TIPSQUERYNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
        wid = gtk_tips_query_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Starts a query. The GtkTipsQuery widget will take control of the
 * mouse and as the mouse moves it will display the tooltip of the
 * widget beneath the mouse. */
int
clip_GTK_TIPSQUERYSTARTQUERY(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
        gtk_tips_query_start_query(GTK_TIPS_QUERY(ctq->widget));
	return 0;
err:
	return 1;
}

/* Stops a query. */
int
clip_GTK_TIPSQUERYSTOPQUERY(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
        gtk_tips_query_stop_query(GTK_TIPS_QUERY(ctq->widget));
	return 0;
err:
	return 1;
}

/* Sets the widget which initiates the query, usually a button. If
 * the caller is selected while the query is running, the query is
 * automatically stopped. */
int
clip_GTK_TIPSQUERYSETCALLER(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
        gtk_tips_query_set_caller(GTK_TIPS_QUERY(ctq->widget), cwid->widget);
	return 0;
err:
	return 1;
}

/* Sets the text to display when the query is not in effect, and the
 * text to display when the query is in effect but the widget beneath
 * the pointer has no tooltip. */
int
clip_GTK_TIPSQUERYSETLABELS(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        gchar *label_inactive = _clip_parc(cm,2);
        gchar *label_no_tip = _clip_parc(cm,3);
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
	CHECKOPT(2,CHARACTER_t); CHECKOPT(3,CHARACTER_t);
        LOCALE_TO_UTF(label_inactive);
        LOCALE_TO_UTF(label_no_tip);
        gtk_tips_query_set_labels(GTK_TIPS_QUERY(ctq->widget), label_inactive, label_no_tip);
        FREE_TEXT(label_inactive);
        FREE_TEXT(label_no_tip);
	return 0;
err:
	return 1;
}

int
clip_GTK_TIPSQUERYSETEMITALWAYS(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        gboolean always = _clip_parl(cm,2);
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
	CHECKOPT(2,LOGICAL_t);
        gtk_widget_set(ctq->widget, "emit-always", always, NULL);
	return 0;
err:
	return 1;
}

int
clip_GTK_TIPSQUERYGETEMITALWAYS(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
        _clip_retl(cm,GTK_TIPS_QUERY(ctq->widget)->emit_always);
	return 0;
err:
	return 1;
}

int
clip_GTK_TIPSQUERYGETCALLER(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        C_widget *cwid = NULL;
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
        if (GTK_TIPS_QUERY(ctq->widget)->caller)
        {
        	cwid = _list_get_cwidget(cm,GTK_TIPS_QUERY(ctq->widget)->caller);
                if (!cwid) cwid = _register_widget(cm,GTK_TIPS_QUERY(ctq->widget)->caller,NULL);
        	if (cwid) _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_TIPSQUERYGETLABELINACTIVE(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
        _clip_retc(cm,GTK_TIPS_QUERY(ctq->widget)->label_inactive);
	return 0;
err:
	return 1;
}

int
clip_GTK_TIPSQUERYGETLABELNOTIP(ClipMachine * cm)
{
	C_widget  *ctq = _fetch_cw_arg(cm);
        CHECKCWID(ctq,GTK_IS_TIPS_QUERY);
        _clip_retc(cm,GTK_TIPS_QUERY(ctq->widget)->label_no_tip);
	return 0;
err:
	return 1;
}


