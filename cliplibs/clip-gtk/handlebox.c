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

static gint handle_child_attached_signal (GtkHandleBox *box, GtkWidget *widget, C_signal *cs)
{
	C_widget *cwid;
	PREPARECV(cs,cv);
        cwid = _list_get_cwidget(cs->cw->cmachine,widget);
        if (!cwid) cwid = _register_widget(cs->cw->cmachine,widget,NULL);
        if (cwid) _clip_madd(cs->cw->cmachine, &cv, HASH_WIDGET, &cwid->obj);
        INVOKESIGHANDLER(widget,cs,cv);
}

static gint handle_child_detached_signal (GtkHandleBox *box, GtkWidget *widget, C_signal *cs)
{
	C_widget *cwid;
	PREPARECV(cs,cv);
        cwid = _list_get_cwidget(cs->cw->cmachine,widget);
        if (!cwid) cwid = _register_widget(cs->cw->cmachine,widget,NULL);
        if (cwid) _clip_madd(cs->cw->cmachine, &cv, HASH_WIDGET, &cwid->obj);
        INVOKESIGHANDLER(widget,cs,cv);
}

static gint emit_handle_box_signal (C_widget *cbox, const gchar *signal_name)
{
	ClipMachine *cm = cbox->cmachine;
        C_widget  *cwid = _fetch_cwidget(cm,_clip_spar(cm,3));
        CHECKARG2(3,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_signal_emit_by_name(GTK_OBJECT(cbox->widget),signal_name,cwid->widget,cbox);
	return 0;
err:
	return 1;
}

static SignalTable handle_box_signals[] =
{
	/* This signal is emitted when the contents of the handlebox
	   are reattached to the main window. */
	{"child-attached",	GSF( handle_child_attached_signal ), ESF( emit_handle_box_signal ), GTK_CHILD_ATTACHED_SIGNAL},
	/* This signal is emitted when the contents of the handlebox
	   are detached from the main window. */
	{"child-detached",	GSF( handle_child_detached_signal ), ESF( emit_handle_box_signal ), GTK_CHILD_DETACHED_SIGNAL},
	{"", NULL, NULL, 0}
};
/**********************************************************/

/* Register Handle Box in global table */
CLIP_DLLEXPORT GtkType _gtk_type_handle_box() { return GTK_TYPE_HANDLE_BOX; }
long _clip_type_handle_box() { return GTK_WIDGET_HANDLE_BOX; }
const char * _clip_type_name_handle_box() { return "GTK_WIDGET_HANDLE_BOX"; }

int
clip_INIT___HANDLEBOX(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_handle_box, _clip_type_name_handle_box, _gtk_type_handle_box, _gtk_type_container, handle_box_signals);
	return 0;
}
int
clip_GTK_HANDLEBOXNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_fixed_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Sets the type of shadow to be drawn around the border of the */
int
clip_GTK_HANDLEBOXSETSHADOWTYPE(ClipMachine * cm)
{
	C_widget *cbox = _fetch_cw_arg(cm);
        GtkShadowType type = _clip_parni(cm,2);
	CHECKOPT(2,NUMERIC_t);
        CHECKCWID(cbox,GTK_IS_HANDLE_BOX);
        gtk_handle_box_set_shadow_type(GTK_HANDLE_BOX(cbox->widget), type);
	return 0;
err:
	return 1;
}

/* Gets the type of shadow to be drawn around the border of the */
int
clip_GTK_HANDLEBOXGETSHADOWTYPE(ClipMachine * cm)
{
	C_widget *cbox = _fetch_cw_arg(cm);
        CHECKCWID(cbox,GTK_IS_HANDLE_BOX);
        _clip_retni(cm,GTK_HANDLE_BOX(cbox->widget)->shadow_type);
	return 0;
err:
	return 1;
}

/* Sets the side of the handlebox where the handle is drawn. */
int
clip_GTK_HANDLEBOXSETHANDLEPOSITION(ClipMachine * cm)
{
	C_widget *cbox = _fetch_cw_arg(cm);
        GtkPositionType position = _clip_parni(cm,2);
	CHECKOPT(2,NUMERIC_t);
        CHECKCWID(cbox,GTK_IS_HANDLE_BOX);
        gtk_handle_box_set_handle_position(GTK_HANDLE_BOX(cbox->widget), position);
	return 0;
err:
	return 1;
}

/* Gets the side of the handlebox where the handle is drawn. */
int
clip_GTK_HANDLEBOXGETHANDLEPOSITION(ClipMachine * cm)
{
	C_widget *cbox = _fetch_cw_arg(cm);
        CHECKCWID(cbox,GTK_IS_HANDLE_BOX);
        _clip_retni(cm,GTK_HANDLE_BOX(cbox->widget)->handle_position);
	return 0;
err:
	return 1;
}

/* Sets the snap edge of a handlebox. The snap edge is the edge of the detached
 * child that must be aligned with the corresponding edge of the "ghost" left
 * behind when the child was detached to reattach the torn-off window. Usually,
 * the snap edge should be chosen so that it stays in the same place on the
 * screen when the handlebox is torn off.

 * If the snap edge is not set, then an appropriate value will be guessed from
 * the handle position. If the handle position is GTK_POS_RIGHT or GTK_POS_LEFT,
 * then the snap edge will be GTK_POS_TOP, otherwise it will be GTK_POS_LEFT. */
int
clip_GTK_HANDLEBOXSETSNAPEDGE(ClipMachine * cm)
{
	C_widget *cbox = _fetch_cw_arg(cm);
        GtkPositionType edge = _clip_parni(cm,2);
	CHECKOPT(2,NUMERIC_t);
        CHECKCWID(cbox,GTK_IS_HANDLE_BOX);
        if (_clip_parinfo(cm,2)==UNDEF_t) edge = -1;
        gtk_handle_box_set_snap_edge(GTK_HANDLE_BOX(cbox->widget), edge);
	return 0;
err:
	return 1;
}

int
clip_GTK_HANDLEBOXGETSNAPEDGE(ClipMachine * cm)
{
	C_widget *cbox = _fetch_cw_arg(cm);
        CHECKCWID(cbox,GTK_IS_HANDLE_BOX);
        _clip_retni(cm,GTK_HANDLE_BOX(cbox->widget)->snap_edge);
	return 0;
err:
	return 1;
}

int
clip_GTK_HANDLEBOXCHILDDETACHED(ClipMachine * cm)
{
	C_widget *cbox = _fetch_cw_arg(cm);
        CHECKCWID(cbox,GTK_IS_HANDLE_BOX);
        _clip_retl(cm,GTK_HANDLE_BOX(cbox->widget)->child_detached);
	return 0;
err:
	return 1;
}


