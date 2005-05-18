/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"
#include "clip-gdk2.h"

GtkType _gdk_type_gdk_window() { return GDK_OBJECT_WINDOW; }
long _clip_type_gdk_window() { return GDK_OBJECT_WINDOW; }
const char * _clip_type_name_gdk_window() { return "GDK_OBJECT_WINDOW"; }

int
clip_INIT___GDKWINDOW(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_gdk_window, _clip_type_name_gdk_window, _gdk_type_gdk_window, NULL, NULL);
	return 0;
}
/**********************************************************/

CLIP_DLLEXPORT int
gdk_object_window_destructor(ClipMachine *cm, C_object *cwin)
{
	if (cwin && GDK_IS_WINDOW(cwin) && cwin->ref_count >= 0)
		gdk_window_unref(GDK_WINDOW(cwin->object));
	return 0;
}

int
clip_GDK_WINDOWGETPOINTER(ClipMachine * cm)
{
//	C_object    *cwin = _fetch_co_arg(cm);
	C_widget    *cwin = _fetch_cw_arg(cm);
	gint  px,  py;
	GdkWindow *win = NULL;
	GdkModifierType mask;

	CHECKCWID(cwin,GTK_IS_WIDGET);

	if (cwin && cwin->widget) win = cwin->widget->window;

	if (!win) return 0;

	gdk_window_get_pointer(win, &px, &py, &mask);
	_clip_storni(cm, px,2,0);
	_clip_storni(cm, py,3,0);
	_clip_storni(cm, mask,4,0);

	return 0;
err:
	return 1;
}

int
clip_GDK_WINDOWGETSIZE(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	gint        width = _clip_parni(cm,2);
	gint       height = _clip_parni(cm,3);
	gint * px, * py;
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	px = _clip_parinfo(cm,2) == UNDEF_t ? NULL : &width;
	py = _clip_parinfo(cm,3) == UNDEF_t ? NULL : &height;

	if (cwin && cwin->widget) win = cwin->widget->window;

	gdk_window_get_size(win, px, py);
	_clip_storni(cm,*px,2,0);
	_clip_storni(cm,*py,3,0);

	return 0;
err:
	return 1;
}


int
clip_GDK_WINDOWGETPOSITION(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	gint            x = _clip_parni(cm,2);
	gint            y = _clip_parni(cm,3);
	gint * px, * py;
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	px = _clip_parinfo(cm,2) == UNDEF_t ? NULL : &x;
	py = _clip_parinfo(cm,3) == UNDEF_t ? NULL : &y;

	if (cwin && cwin->widget) win = cwin->widget->window;

	gdk_window_get_position(win, px, py);
	_clip_storni(cm,*px,2,0);
	_clip_storni(cm,*py,3,0);

	return 0;
err:
	return 1;
}

int
clip_GDK_WINDOWCLEAR(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);

	if (cwin && cwin->widget) win = cwin->widget->window;

	gdk_window_clear(win);

	return 0;
err:
	return 1;
}


int
clip_GDK_WINDOWGETTYPE(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);

	if (cwin && cwin->widget) win = cwin->widget->window;

	_clip_retni(cm, gdk_window_get_type(win));

	return 0;
err:
	return 1;
}


/*Lowers window to the bottom of the Z-order (stacking order), so
that other windows with the same parent window appear above window.*/
int
clip_GDK_WINDOWLOWER(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);

	if (cwin && cwin->widget) win = cwin->widget->window;

	gdk_window_lower(win);

	return 0;
err:
	return 1;
}

/* Raises window to the top of the Z-order (stacking order), so
that other windows with the same parent window appear below
window. If window is a toplevel, the window. */
int
clip_GDK_WINDOWRAISE(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);

	if (cwin && cwin->widget) win = cwin->widget->window;

	gdk_window_raise(win);

	return 0;
err:
	return 1;
}

/* Alena */
/* Window is viewable */
int
clip_GDK_WINDOWISVIEWABLE(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);

	if (cwin && cwin->widget) win = cwin->widget->window;

	_clip_retl(cm, gdk_window_is_viewable(win));

	return 0;
err:
	return 1;
}
/* Alena */
/* Window is visible */
int
clip_GDK_WINDOWISVISIBLE(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);

	if (cwin && cwin->widget) win = cwin->widget->window;

	_clip_retl(cm, gdk_window_is_visible(win));

	return 0;
err:
	return 1;
}

int
clip_GDK_WINDOWSETHINTS(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	gint            x = INT_OPTION(cm,2,-1);
	gint            y = INT_OPTION(cm,3,-1);
	gint    min_width = INT_OPTION(cm,4,-1);
	gint   min_height = INT_OPTION(cm,5,-1);
	gint    max_width = INT_OPTION(cm,6,-1);
	gint   max_height = INT_OPTION(cm,7,-1);
	gint        flags = INT_OPTION(cm,8,0);
	GdkWindow *win = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET); CHECKOPT(2,NUMERIC_t);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
	CHECKOPT(6,NUMERIC_t); CHECKOPT(7,NUMERIC_t); CHECKOPT(8,NUMERIC_t);

	CHECKCWID(cwin,GTK_IS_WIDGET);

	if (cwin && cwin->widget) win = cwin->widget->window;

	gdk_window_set_hints(win,x,y,min_width,min_height,max_width,max_height,flags);

	return 0;
err:
	return 1;
}


int
clip_GDK_WINDOWSETBACKPIXMAP(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
        C_widget    *cpix = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gboolean relative = _clip_parl(cm, 3);
	GdkWindow *win = NULL;
        GdkPixmap *pix = NULL;
        GdkBitmap *mask;

	CHECKCWID(cwin,GTK_IS_WIDGET); CHECKOPT(2, MAP_t);
	CHECKCWIDOPT(cpix,GTK_IS_PIXMAP);
	CHECKARG(3,LOGICAL_t);

	if (cwin && cwin->widget) win = (GdkWindow *)cwin->widget->window;

	if (cpix) gtk_pixmap_get(GTK_PIXMAP(cpix->widget), &pix, &mask);

	gdk_window_set_back_pixmap(win, pix, relative);

	return 0;
err:
	return 1;
}


