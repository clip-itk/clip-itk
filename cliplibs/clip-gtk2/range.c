/*
    Copyright (C) 2001 - 2004  ITK
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

static gint handle_motion_signal (GtkRange *wid, gint xdelta, gint ydelta, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_XDELTA, xdelta);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_YDELTA, ydelta);
	INVOKESIGHANDLER(GTK_WIDGET(wid),cs,cv);
}
static gint
handle_adjust_bounds_signal (GtkRange *wid, gdouble arg1, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ARG1, arg1);
	INVOKESIGHANDLER(GTK_WIDGET(wid),cs,cv);
}

static gint
handle_move_slider_signal (GtkRange *wid, GtkScrollType type, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLLTYPE, type);
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
	{"motion",		GSF( handle_motion_signal ), ESF( object_emit_signal ), GTK_MOTION_SIGNAL},
	{"adjust-bounds",	GSF( handle_adjust_bounds_signal ), ESF( object_emit_signal ), GTK_ADJUST_BOUNDS_SIGNAL},
	{"move-slider",		GSF( handle_move_slider_signal ), ESF( object_emit_signal ), GTK_MOVE_SLIDER_SIGNAL},
	{"value-changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_VALUE_CHANGED_SIGNAL},
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


int
clip_GTK_RANGEGETINVERTED(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
	CHECKCWID(crange,GTK_IS_RANGE);
	_clip_retl(cm, gtk_range_get_inverted(GTK_RANGE(crange->widget)));
	return 0;
err:
	return 1;
}


int
clip_GTK_RANGESETINVERTED(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
        gboolean setting = _clip_parl(cm, 2);

	CHECKCWID(crange,GTK_IS_RANGE);
	CHECKARG(2, LOGICAL_t);
	gtk_range_set_inverted(GTK_RANGE(crange->widget), setting);
	return 0;
err:
	return 1;
}


int
clip_GTK_RANGEGETUPDATEPOLICY(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
	CHECKCWID(crange,GTK_IS_RANGE);
	_clip_retni(cm, (int)gtk_range_get_update_policy(GTK_RANGE(crange->widget)));
	return 0;
err:
	return 1;
}



int
clip_GTK_RANGEGETVALUE(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
	CHECKCWID(crange,GTK_IS_RANGE);
	_clip_retnd(cm, gtk_range_get_value(GTK_RANGE(crange->widget)));
	return 0;
err:
	return 1;
}



int
clip_GTK_RANGESETINCREMENTS(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
        gdouble     step = _clip_parnd(cm, 2);
        gdouble     page = _clip_parnd(cm, 3);
	CHECKCWID(crange,GTK_IS_RANGE);
        CHECKARG(2, NUMERIC_t); CHECKARG(3, NUMERIC_t);
	gtk_range_set_increments(GTK_RANGE(crange->widget), step, page);
	return 0;
err:
	return 1;
}

int
clip_GTK_RANGESETRANGE(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
        gdouble      min = _clip_parnd(cm, 2);
        gdouble      max = _clip_parnd(cm, 3);
	CHECKCWID(crange,GTK_IS_RANGE);
        CHECKARG(2, NUMERIC_t); CHECKARG(3, NUMERIC_t);
	gtk_range_set_range(GTK_RANGE(crange->widget), min, max);
	return 0;
err:
	return 1;
}


int
clip_GTK_RANGESETVALUE(ClipMachine * cm)
{
	C_widget *crange = _fetch_cw_arg(cm);
        gdouble    value = _clip_parnd(cm, 2);
	CHECKCWID(crange,GTK_IS_RANGE);
        CHECKARG(2, NUMERIC_t);
	gtk_range_set_value(GTK_RANGE(crange->widget), value);
	return 0;
err:
	return 1;
}

