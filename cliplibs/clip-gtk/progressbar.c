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

/*********************** SIGNALS **************************/

/****         Progress bar has no own signal           ****/

/**********************************************************/

/* Register container signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_progress_bar() { return GTK_TYPE_PROGRESS_BAR; }
long _clip_type_progress_bar() { return GTK_WIDGET_PROGRESS_BAR; }
const char * _clip_type_name_progress_bar() { return "GTK_WIDGET_PROGRESS_BAR"; }

int
clip_INIT___PROGRESS_BAR(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_progress_bar, _clip_type_name_progress_bar, _gtk_type_progress_bar, _gtk_type_progress, NULL);
	return 0;
}
/**********************************************************/

int
clip_GTK_PROGRESSBARNEW(ClipMachine * cm)
{
	ClipVar * cv    = _clip_spar(cm, 1);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	GtkWidget *wid = NULL;
        C_widget *cwid;
        GtkAdjustment *adj;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);

	if (_clip_parinfo(cm,2)==UNDEF_t)
		wid = gtk_progress_bar_new();
        else
		wid = gtk_progress_bar_new_with_adjustment(adj);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Controls whether progress text is shown. */
int
clip_GTK_PROGRESSBARSETBARSTYLE(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	GtkProgressBarStyle style = _clip_parni(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
        gtk_progress_bar_set_bar_style(GTK_PROGRESS_BAR(cprg->widget), style);
	return 0;
err:
	return 1;
}

/* Sets the number of blocks that the progress bar is divided into when the
 * style is GTK_PROGRESS_DISCRETE. */
int
clip_GTK_PROGRESSBARSETDISCRETEBLOCKS(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	guint   blocks = _clip_parni(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
        gtk_progress_bar_set_discrete_blocks(GTK_PROGRESS_BAR(cprg->widget), blocks);
	return 0;
err:
	return 1;
}

/* Sets the step value used when the progress bar is in activity mode.
 * The step is the amount by which the progress is incremented each iteration. */
int
clip_GTK_PROGRESSBARSETACTIVITYSTEP(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	guint     step = _clip_parni(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
        gtk_progress_bar_set_activity_step(GTK_PROGRESS_BAR(cprg->widget), step);
	return 0;
err:
	return 1;
}

/* Sets the number of blocks used when the progress bar is in activity mode.
 * Larger numbers make the visible block smaller. */
int
clip_GTK_PROGRESSBARSETACTIVITYBLOCKS(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	guint   blocks = _clip_parni(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
        gtk_progress_bar_set_activity_blocks(GTK_PROGRESS_BAR(cprg->widget), blocks);
	return 0;
err:
	return 1;
}

/* Sets the orientation of the progress bar. This controls whether the bar is
 * horizontal or vertical and the direction in which it grows. */
int
clip_GTK_PROGRESSBARSETORIENTATION(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	GtkProgressBarOrientation orientation = _clip_parni(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
        gtk_progress_bar_set_orientation(GTK_PROGRESS_BAR(cprg->widget), orientation);
	return 0;
err:
	return 1;
}

