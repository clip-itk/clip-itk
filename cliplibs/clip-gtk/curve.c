/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/**********************************************************/
/* Signals table */
static SignalTable curve_signals[] =
{
	{"curve-type-changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CURVE_TYPE_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register curve in global table */
CLIP_DLLEXPORT GtkType _gtk_type_curve() { return GTK_TYPE_CURVE; }
long _clip_type_curve() { return GTK_WIDGET_CURVE; }
const char * _clip_type_name_curve() { return "GTK_WIDGET_CURVE"; }

CLIP_DLLEXPORT GtkType _gtk_type_gamma_curve() { return gtk_gamma_curve_get_type(); }
long _clip_type_gamma_curve() { return GTK_WIDGET_GAMMA_CURVE; }
const char * _clip_type_name_gamma_curve() { return "GTK_WIDGET_GAMMA_CURVE"; }

int
clip_INIT___CURVE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_curve, _clip_type_name_curve, _gtk_type_curve,  _gtk_type_drawing_area, curve_signals);
	_wtype_table_put(_clip_type_gamma_curve, _clip_type_name_gamma_curve, _gtk_type_gamma_curve,  _gtk_type_curve, NULL);
	return 0;
}
/**********************************************************/

/**** Curve constructor ****/
int
clip_GTK_CURVENEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

        wid = gtk_curve_new();
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/**** Gamma Curve constructor ****/
int
clip_GTK_GAMMACURVENEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

        wid = gtk_gamma_curve_new();
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Resets the curve to a straight line from the minimum x & y values to the
 * maximum x & y values (i.e. from the bottom-left to the top-right corners).
 * The curve type is not changed. */
int
clip_GTK_CURVERESET(ClipMachine * cm)
{
	C_widget *ccur = _fetch_cw_arg(cm);
        CHECKCWID(ccur,GTK_CURVE);
        gtk_curve_reset(GTK_CURVE(ccur->widget));
	return 0;
err:
	return 1;
}

/* Recomputes the entire curve using the given gamma value. A gamma value of 1
 * results in a straight line. Values greater than 1 result in a curve above the
 * straight line. Values less than 1 result in a curve below the straight line.
 * The curve type is changed to GTK_CURVE_TYPE_FREE. */
int
clip_GTK_CURVESETGAMMA(ClipMachine * cm)
{
	C_widget *ccur = _fetch_cw_arg(cm);
        gfloat   gamma = _clip_parnd(cm,2);
        CHECKCWID(ccur,GTK_CURVE);
        CHECKOPT(2,NUMERIC_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) gamma = 1;
        gtk_curve_set_gamma(GTK_CURVE(ccur->widget),gamma);
	return 0;
err:
	return 1;
}

/* Sets the minimum and maximum x & y values of the curve.
 * The curve is also reset with a call to gtk_curve_reset(). */
int
clip_GTK_CURVESETRANGE(ClipMachine * cm)
{
	C_widget *ccur = _fetch_cw_arg(cm);
        gfloat   min_x = _clip_parnd(cm,2);
        gfloat   max_x = _clip_parnd(cm,3);
        gfloat   min_y = _clip_parnd(cm,4);
        gfloat   max_y = _clip_parnd(cm,5);
        CHECKCWID(ccur,GTK_CURVE);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
        gtk_curve_set_range(GTK_CURVE(ccur->widget),min_x,max_x,min_y,max_y);
	return 0;
err:
	return 1;
}

/* Returns a vector of points representing the curve. */
int
clip_GTK_CURVEGETVECTOR(ClipMachine * cm)
{
	C_widget *ccur = _fetch_cw_arg(cm);
        int     veclen = _clip_parni(cm,2);
        gfloat* vector = calloc(veclen,sizeof(gfloat));
	long n=0, i;
	ClipVar *a = RETPTR(cm);
        CHECKCWID(ccur,GTK_CURVE);
        CHECKARG(2,NUMERIC_t);
  	_clip_array(cm, a, veclen, &n);
        gtk_curve_get_vector(GTK_CURVE(ccur->widget),veclen,vector);
        for (i = 0; i < veclen; i++)
        {
        	a->a.items[i].t.type = NUMERIC_t;
        	a->a.items[i].n.d = vector[i];
        }
	return 0;
err:
	return 1;
}

/* Sets the vector of points on the curve. The curve type is set to GTK_CURVE_TYPE_FREE. */
int
clip_GTK_CURVESETVECTOR(ClipMachine * cm)
{
	C_widget *ccur = _fetch_cw_arg(cm);
        int     veclen = _clip_parni(cm,2);
	ClipVar *cvvec = _clip_spar(cm,3);
        gfloat* vector = calloc(veclen,sizeof(gfloat));
	long i;
        CHECKCWID(ccur,GTK_CURVE);
        CHECKARG(2,NUMERIC_t); CHECKARG(3,ARRAY_t);
        for (i = 0; i < veclen; i++)
        {
        	if (cvvec->a.items[i].t.type == NUMERIC_t)
        		vector[i] = cvvec->a.items[i].n.d;
        }
        gtk_curve_set_vector(GTK_CURVE(ccur->widget),veclen,vector);
	return 0;
err:
	return 1;
}

/* Sets the type of the curve. The curve will remain unchanged except when changing
 * from a free curve to a linear or spline curve, in which case the curve will be
 * changed as little as possible. */
int
clip_GTK_CURVESETCURVETYPE(ClipMachine * cm)
{
	C_widget *ccur = _fetch_cw_arg(cm);
        GtkCurveType type = _clip_parni(cm,2);
        CHECKCWID(ccur,GTK_CURVE);
        CHECKOPT(2,NUMERIC_t);
        gtk_curve_set_curve_type(GTK_CURVE(ccur->widget),type);
	return 0;
err:
	return 1;
}

