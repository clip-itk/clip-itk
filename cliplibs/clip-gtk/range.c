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

/**********************************************************/
/* Signal handlers */
static gint
handle_trough_click_signal (GtkRange *wid, gint x, gint y, float *jump_perc, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_X, x);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_Y, y);
	INVOKESIGHANDLER(GTK_WIDGET(wid),cs,cv);
}
static gint handle_trough_keys_signal (GtkRange *wid, GdkEventKey *key, GtkScrollType *scroll, GtkTroughType *trough, C_signal *cs)
{
	double keycode;
	PREPARECV(cs,cv);
	x_inkey(key, &keycode);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_KEYCODE, keycode);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_STATE, key->state);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLL, *scroll);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_TROUGH, *trough);
	INVOKESIGHANDLER(GTK_WIDGET(wid),cs,cv);
}
static gint handle_motion_signal (GtkRange *wid, gint xdelta, gint ydelta, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_XDELTA, xdelta);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_YDELTA, ydelta);
	INVOKESIGHANDLER(GTK_WIDGET(wid),cs,cv);
}

/* Signals table */
static SignalTable range_signals[] =
{
	{"draw-background",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_DRAW_BACKGROUND_SIGNAL},
	{"clear-background",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CLEAR_BACKGROUND_SIGNAL},
	{"draw-trough",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_DRAW_TROUGH_SIGNAL},
	{"draw-slider",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_DRAW_SLIDER_SIGNAL},
	{"step-forward",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_STEP_FORW_SIGNAL},
	{"step-backward",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_STEP_BACK_SIGNAL},
	{"slider-update",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SLIDER_UPDATE_SIGNAL},
	{"trough-click",	GSF( handle_trough_click_signal ), ESF( object_emit_signal ), GTK_TROUGH_CLICK_SIGNAL},
	{"trough-keys",		GSF( handle_trough_keys_signal ), ESF( object_emit_signal ), GTK_TROUGH_KEYS_SIGNAL},
	{"motion",		GSF( handle_motion_signal ), ESF( object_emit_signal ), GTK_MOTION_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register range in global table */
CLIP_DLLEXPORT GtkType _gtk_type_range() { return GTK_TYPE_RANGE; }
long _clip_type_range() { return GTK_WIDGET_RANGE; }
const char * _clip_type_name_range() { return "GTK_WIDGET_RANGE"; }

int
clip_INIT___RANGE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_range, _clip_type_name_range, _gtk_type_range, _gtk_type_widget, range_signals);
	return 0;
}

int
clip_GTK_RANGEGETADJUSTMENT(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
	GtkAdjustment *adj;
	C_widget *cadj;
	ClipVar * ret = RETPTR(cm);
	CHECKCWID(crange,GTK_IS_RANGE);
	adj = gtk_range_get_adjustment(GTK_RANGE(crange->widget));
	cadj = _list_get_cwidget(cm,adj);
	if (!cadj) cadj = _register_widget(cm,(GtkWidget*)adj,NULL);
	if (cadj) _clip_mclone(cm,ret,&cadj->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_RANGESETUPDATEPOLICY(ClipMachine * cm)
{
	C_widget     *crange = _fetch_cw_arg(cm);
	GtkUpdateType policy = _clip_parni(cm,2);
	CHECKCWID(crange,GTK_IS_RANGE);
	CHECKOPT(2,NUMERIC_t);
	gtk_range_set_update_policy(GTK_RANGE(crange->widget), policy);
	return 0;
err:
	return 1;
}

int
clip_GTK_RANGESETADJUSTMENT(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
	C_widget   *cadj = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(crange,GTK_IS_RANGE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(cadj,GTK_IS_ADJUSTMENT);
	gtk_range_set_adjustment(GTK_RANGE(crange->widget), GTK_ADJUSTMENT(cadj->widget));
	return 0;
err:
	return 1;
}

/* Alena: get old  values:
old_lower, old_upper, old_value
*/
int
clip_GTK_RANGEGETOLDVALUE(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);

	CHECKCWID(crange,GTK_IS_RANGE);

	_clip_storni(cm, GTK_RANGE(crange->widget)->old_value, 2,0);
	_clip_storni(cm, GTK_RANGE(crange->widget)->old_lower, 3,0);
	_clip_storni(cm, GTK_RANGE(crange->widget)->old_upper, 4,0);

	return 0;
err:
	return 1;
}


