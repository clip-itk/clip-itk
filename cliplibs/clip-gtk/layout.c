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

/* Layout has no signals */

/**********************************************************/

/* Register layout signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_layout() { return GTK_TYPE_LAYOUT; }
long _clip_type_layout() { return GTK_WIDGET_LAYOUT; }
const char * _clip_type_name_layout() { return "GTK_WIDGET_LAYOUT"; }

int
clip_INIT___LAYOUT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_layout, _clip_type_name_layout, _gtk_type_layout, _gtk_type_container, NULL);
	return 0;
}
int
clip_GTK_LAYOUTNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	C_widget * chadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	C_widget * cvadj = _fetch_cwidget(cm,_clip_spar(cm, 3));
	GtkWidget *wid = NULL;
	C_widget *cwid;
	GtkAdjustment *hadj, *vadj;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(chadj,GTK_IS_ADJUSTMENT);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCWIDOPT(cvadj,GTK_IS_ADJUSTMENT);

	hadj = chadj ? GTK_ADJUSTMENT(chadj->widget) : NULL;
	vadj = cvadj ? GTK_ADJUSTMENT(cvadj->widget) : NULL;
	wid = gtk_layout_new(hadj,vadj);
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_LAYOUTPUT(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	gint x = _clip_parni(cm,3);
	gint y = _clip_parni(cm,4);
	CHECKARG2(2,MAP_t,NUMERIC_t);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
	CHECKCWID(ccon,GTK_IS_LAYOUT); CHECKCWID(cwid,GTK_IS_WIDGET);
	if (_clip_parinfo(cm,3) == UNDEF_t) x = cwid->widget->allocation.x;
	if (_clip_parinfo(cm,4) == UNDEF_t) y = cwid->widget->allocation.y;
	gtk_layout_put(GTK_LAYOUT(ccon->widget), cwid->widget, x,y);

	return 0;
err:
	return 1;
}

/* These disable and enable moving and repainting the scrolling window
 * of the GtkLayout, respectively.  If you want to update the layout's
 * offsets but do not want it to repaint itself, you should use these
 * functions. */
int
clip_GTK_LAYOUTFREEZE(ClipMachine * cm)
{
	C_widget *clay = _fetch_cw_arg(cm);
	CHECKCWID(clay,GTK_IS_LAYOUT);
	gtk_layout_freeze(GTK_LAYOUT(clay->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_LAYOUTTHAW(ClipMachine * cm)
{
	C_widget *clay = _fetch_cw_arg(cm);
	CHECKCWID(clay,GTK_IS_LAYOUT);
	gtk_layout_thaw(GTK_LAYOUT(clay->widget));
	return 0;
err:
	return 1;
}


/* Alena: set vertical adjustment for layout */
int
clip_GTK_LAYOUTSETVADJUSTMENT(ClipMachine * cm)
{
	C_widget *clay = _fetch_cw_arg(cm);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	GtkAdjustment *adj;
	CHECKCWID(clay,GTK_IS_LAYOUT);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);

	adj = cadj ? GTK_ADJUSTMENT(cadj->widget) : NULL;
	gtk_layout_set_vadjustment(GTK_LAYOUT(clay->widget), adj);

	return 0;
err:
	return 1;
}

/* Alena: set horizontal adjustment for layout */
int
clip_GTK_LAYOUTSETHADJUSTMENT(ClipMachine * cm)
{
	C_widget *clay = _fetch_cw_arg(cm);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	GtkAdjustment *adj;
	CHECKCWID(clay,GTK_IS_LAYOUT);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);

	adj = cadj ? GTK_ADJUSTMENT(cadj->widget) : NULL;
	gtk_layout_set_hadjustment(GTK_LAYOUT(clay->widget), adj);

	return 0;
err:
	return 1;
}


