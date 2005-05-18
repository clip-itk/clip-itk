/*
    Copyright (C) 2001-2005  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    	      Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/****           Progress has no own signal             ****/

/**********************************************************/

/* Register container signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_progress() { return GTK_TYPE_PROGRESS; }
long _clip_type_progress() { return GTK_WIDGET_PROGRESS; }
const char * _clip_type_name_progress() { return "GTK_WIDGET_PROGRESS"; }

int
clip_INIT___PROGRESS(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_progress, _clip_type_name_progress, _gtk_type_progress, _gtk_type_widget, NULL);
	return 0;
}
/**********************************************************/

/* Controls whether progress text is shown. */
int
clip_GTK_PROGRESSSETSHOWTEXT(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	gint      show = BOOL_OPTION(cm,2,TRUE);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,LOGICAL_t);
        gtk_progress_set_show_text(GTK_PROGRESS(cprg->widget), show);
	return 0;
err:
	return 1;
}

/* Controls the alignment of the text within the progress bar area. */
int
clip_GTK_PROGRESSSETTEXTALIGNMENT(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	gfloat x_align = _clip_parnd(cm,2);
	gfloat y_align = _clip_parnd(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) x_align = GTK_PROGRESS(cprg->widget)->x_align;
        if (_clip_parinfo(cm,3)==UNDEF_t) y_align = GTK_PROGRESS(cprg->widget)->y_align;
        gtk_progress_set_text_alignment(GTK_PROGRESS(cprg->widget), x_align, y_align);
	return 0;
err:
	return 1;
}

/* Sets a format string used to display text indicating the current progress.
 * The string can contain the following substitution characters:

    %v - the current progress value.

    %l - the lower bound for the progress value.

    %u - the upper bound for the progress value.

    %p - the current progress percentage. */
int
clip_GTK_PROGRESSSETFORMATSTRING(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	gchar * format = _clip_parc(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,CHARACTER_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) format = "\0";
        LOCALE_TO_UTF(format);
        gtk_progress_set_format_string(GTK_PROGRESS(cprg->widget), format);
        FREE_TEXT(format);
	return 0;
err:
	return 1;
}

/* Associates a GtkAdjustment with the GtkProgress. A GtkAdjustment is used
 * to represent the upper and lower bounds and the step interval of the
 * underlying value for which progress is shown. */
int
clip_GTK_PROGRESSSETADJUSTMENT(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	C_widget *cadj = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cprg,GTK_IS_PROGRESS);
        CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(cadj,GTK_IS_ADJUSTMENT);
        gtk_progress_set_adjustment(GTK_PROGRESS(cprg->widget),GTK_ADJUSTMENT(cadj->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_PROGRESSGETADJUSTMENT(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	C_widget *cadj;
	CHECKCWID(cprg,GTK_IS_PROGRESS);
	cadj = _get_cwidget(cm,GTK_WIDGET(GTK_PROGRESS(cprg->widget)->adjustment));
	if (cadj) _clip_mclone(cm,RETPTR(cm),&cadj->obj);
	return 0;
err:
	return 1;
}

/* Sets the current percentage completion for the GtkProgress. */
int
clip_GTK_PROGRESSSETPERCENTAGE(ClipMachine * cm)
{
	C_widget    *cprg = _fetch_cw_arg(cm);
	gfloat percentage = _clip_parnd(cm,2);
	CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
	gtk_progress_set_percentage(GTK_PROGRESS(cprg->widget), percentage);
	return 0;
err:
	return 1;
}

/* Sets the value within the GtkProgress to an absolute value. The value must
* be within the valid range of values for the underlying GtkAdjustment. */
int
clip_GTK_PROGRESSSETVALUE(ClipMachine * cm)
{
	C_widget    *cprg = _fetch_cw_arg(cm);
	gfloat      value = _clip_parnd(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
        gtk_progress_set_value(GTK_PROGRESS(cprg->widget), value);
	return 0;
err:
	return 1;
}

/* Returns the current progress complete value. */
int
clip_GTK_PROGRESSGETVALUE(ClipMachine * cm)
{
	C_widget    *cprg = _fetch_cw_arg(cm);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
        _clip_retnd(cm,gtk_progress_get_value(GTK_PROGRESS(cprg->widget)));
	return 0;
err:
	return 1;
}

/* A GtkProgress can be in one of two different modes: percentage mode (the default)
 * and activity mode. In activity mode, the progress is simply indicated as activity
 * rather than as a percentage complete. */
int
clip_GTK_PROGRESSSETACTIVITYMODE(ClipMachine * cm)
{
	C_widget      *cprg = _fetch_cw_arg(cm);
	guint activity_mode = _clip_parl(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,LOGICAL_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) activity_mode = TRUE;
        gtk_progress_set_activity_mode(GTK_PROGRESS(cprg->widget), activity_mode);
	return 0;
err:
	return 1;
}

/* Returns the current text associated with the GtkProgress. This text is the based
 * on the underlying format string after any substitutions are made. */
int
clip_GTK_PROGRESSGETCURRENTTEXT(ClipMachine * cm)
{
	C_widget    *cprg = _fetch_cw_arg(cm);
        gchar       *text;
        CHECKCWID(cprg,GTK_IS_PROGRESS);
        text = gtk_progress_get_current_text(GTK_PROGRESS(cprg->widget));
        LOCALE_FROM_UTF(text);
        _clip_retc(cm,text);
        FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Returns the text indicating the progress based on the supplied value.
 * The current value for the GtkProgress remains unchanged.  */
int
clip_GTK_PROGRESSGETTEXTFROMVALUE(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	gfloat   value = _clip_parnd(cm,2);
        gchar    *text;
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
        text = gtk_progress_get_text_from_value(GTK_PROGRESS(cprg->widget),value);
        LOCALE_TO_UTF(text);
        _clip_retc(cm,text);
        FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Returns the current progress as a percentage. */
int
clip_GTK_PROGRESSGETCURRENTPERCENTAGE(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
        _clip_retnd(cm,gtk_progress_get_current_percentage(GTK_PROGRESS(cprg->widget)));
	return 0;
err:
	return 1;
}

/* Returns the progress as a percentage calculated
 * from the supplied absolute progress value. */
int
clip_GTK_PROGRESSGETPERCENTAGEFROMVALUE(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	gfloat   value = _clip_parnd(cm,2);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t);
        _clip_retnd(cm,gtk_progress_get_percentage_from_value(GTK_PROGRESS(cprg->widget),value));
	return 0;
err:
	return 1;
}

/* Allows the configuration of the minimum, maximum,
 * and current values for the GtkProgress. */
int
clip_GTK_PROGRESSCONFIGURE(ClipMachine * cm)
{
	C_widget *cprg = _fetch_cw_arg(cm);
	gfloat   value = _clip_parnd(cm,2);
	gfloat     min = _clip_parnd(cm,3);
	gfloat     max = _clip_parnd(cm,4);
        CHECKCWID(cprg,GTK_IS_PROGRESS);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
        gtk_progress_configure(GTK_PROGRESS(cprg->widget),value,min,max);
	return 0;
err:
	return 1;
}

