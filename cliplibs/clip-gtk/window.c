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
static gint handle_set_focus_signal (GtkWindow *window, GtkWidget *widget, C_signal *cs)
  {
	C_widget *cwid;
	PREPARECV(cs,cv);
	cwid = _list_get_cwidget(cs->cw->cmachine,widget);
	if (!cwid) cwid = _register_widget(cs->cw->cmachine,widget,NULL);
	if (cwid) _clip_madd(cs->cw->cmachine, &cv, HASH_WIDGET, &cwid->obj);
	INVOKESIGHANDLER(widget,cs,cv);
  }

static SignalTable window_signals[] =
{
	{"set-focus",	GSF( handle_set_focus_signal ), ESF( object_emit_signal ), GTK_SET_FOCUS_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register widget signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_window() { return GTK_TYPE_WINDOW; }
long _clip_type_window() { return GTK_WIDGET_WINDOW; }
const char * _clip_type_name_window() { return "GTK_WIDGET_WINDOW"; }

int
clip_INIT___WINDOW(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_window, _clip_type_name_window, _gtk_type_window, _gtk_type_container, window_signals);
	return 0;
}
/**********************************************************/

/*
gint delete_window_handler( GtkWidget *widget, GdkEvent *event, gpointer data )
{
	gtk_widget_destroy(widget);
	gtk_main_quit();
	return(FALSE);
}
*/

/****  WINDOW constructor ****/
int
clip_GTK_WINDOWNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	gint     typ   = INT_OPTION(cm, 3, 0);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);
	CHECKOPT(3,NUMERIC_t);

	//wid = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	wid = gtk_window_new(typ);
	if (!wid) goto err;
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		{
		LOCALE_TO_UTF(title);
		gtk_window_set_title(GTK_WINDOW(wid), title);
		FREE_TEXT(title);
		}
	//cwid = (C_widget*)calloc( 1, sizeof(C_widget) );
	cwid = _register_widget(cm, wid, cv);
	cwid->accel_group = gtk_accel_group_new();
	gtk_window_add_accel_group (GTK_WINDOW (wid), cwid->accel_group);
//	gtk_signal_connect( GTK_OBJECT( wid ), "delete-event",
//		GTK_SIGNAL_FUNC( delete_window_handler ), NULL );

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

// Set ICON PIXMAP property for window
int
clip_GTK_WINDOWSETICONPIXMAP(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	C_widget *cpix = _fetch_cwidget(cm,_clip_spar(cm,2));
        GdkPixmap *pix;
        GdkBitmap *bit;
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cpix,GTK_IS_PIXMAP);
	gtk_pixmap_get(GTK_PIXMAP(cpix->widget), &pix, &bit);
	gdk_window_set_icon(GDK_WINDOW(cwin->widget->window),
			    GDK_WINDOW(cpix->widget->window),
		pix, bit);
	return 0;
err:
	return 1;
}

// Set ICON NAME property for window
int
clip_GTK_WINDOWSETICONNAME(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gchar    *name = _clip_parc(cm, 2);
	CHECKARG(2,CHARACTER_t);

	CHECKCWID(cwin,GTK_IS_WINDOW);
	if (cwin->widget->window)
	{
		LOCALE_TO_UTF(name);
		gdk_window_set_icon_name(cwin->widget->window, name);
		FREE_TEXT(name);
		_clip_retl(cm, TRUE);
	}
	else
		_clip_retl(cm, FALSE);
	return 0;
err:
	return 1;
}

// Set DECORATIONS for window
int
clip_GTK_WINDOWSETDECORATIONS(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	GdkWMDecoration Decor = _clip_parni(cm, 2);
	CHECKARG(2,NUMERIC_t);

	CHECKCWID(cwin,GTK_IS_WINDOW);
	if (cwin->widget->window)
	{
		gdk_window_set_decorations(cwin->widget->window, Decor);
		_clip_retl(cm, TRUE);
	}
	else
		_clip_retl(cm, FALSE);
	return 0;
err:
	return 1;
}

// Set FUNCTIONS for window
int
clip_GTK_WINDOWSETFUNCTIONS(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	GdkWMFunction Func = _clip_parni(cm, 2);
	CHECKARG(2,NUMERIC_t);

	CHECKCWID(cwin,GTK_IS_WINDOW);
	if (cwin->widget->window)
	{
		gdk_window_set_functions(cwin->widget->window, Func);
		_clip_retl(cm, TRUE);
	}
	else
		_clip_retl(cm, FALSE);
	return 0;
err:
	return 1;
}

/* Raise window */
int
clip_GTK_WINDOWRAISE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);

	CHECKCWID(cwin,GTK_IS_WINDOW);
	if (cwin->widget->window)
	{
		gdk_window_raise(cwin->widget->window);
		_clip_retl(cm, TRUE);
	}
	else
		_clip_retl(cm, FALSE);
	return 0;
err:
	return 1;
}

/* Sets title for window */
int
clip_GTK_WINDOWSETTITLE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gchar   *title = _clip_parc ( cm, 2);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKARG(2,CHARACTER_t);
	LOCALE_TO_UTF(title);
	gtk_window_set_title(GTK_WINDOW(cwin->widget), title);
	FREE_TEXT(title);
	return 0;
err:
	return 1;
}

/* Sets resize policy */
int
clip_GTK_WINDOWSETPOLICY(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gboolean AutoShrink = FALSE, AllowShrink = TRUE, AllowGrow = TRUE;
	CHECKOPT(2,LOGICAL_t);
	CHECKOPT(3,LOGICAL_t);
	CHECKOPT(4,LOGICAL_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	if (_clip_parinfo(cm,2)==LOGICAL_t) AutoShrink  = _clip_parl(cm,2);
	if (_clip_parinfo(cm,3)==LOGICAL_t) AllowGrow   = _clip_parl(cm,3);
	if (_clip_parinfo(cm,4)==LOGICAL_t) AllowShrink = _clip_parl(cm,4);
	gtk_window_set_policy(GTK_WINDOW(cwin->widget),
		AllowShrink,AllowGrow,AutoShrink);
	return 0;
err:
	return 1;
}

/*  */
int
clip_GTK_WINDOWACTIVATEFOCUS(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	_clip_retni(cm,gtk_window_activate_focus(GTK_WINDOW(cwin->widget)));
	return 0;
err:
	return 1;
}

/*  */
int
clip_GTK_WINDOWACTIVATEDEFAULT(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	_clip_retni(cm,gtk_window_activate_default(GTK_WINDOW(cwin->widget)));
	return 0;
err:
	return 1;
}

/*  */
int
clip_GTK_WINDOWSETTRANSIENTFOR(ClipMachine * cm)
{
	C_widget *cwin  = _fetch_cw_arg(cm);
	C_widget *cwin2 = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKARG2(2,MAP_t,NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW); CHECKCWID(cwin2,GTK_IS_WINDOW);
	gtk_window_set_transient_for(GTK_WINDOW(cwin->widget),GTK_WINDOW(cwin2->widget));
	return 0;
err:
	return 1;
}

/* If window is set modal, input will be grabbed when show and released when hide */
int
clip_GTK_WINDOWSETMODAL(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gboolean modal = _clip_parl(cm,2);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2) == UNDEF_t) modal = TRUE;
	CHECKCWID(cwin,GTK_IS_WINDOW);
	gtk_window_set_modal(GTK_WINDOW(cwin->widget), modal);
	return 0;
err:
	return 1;
}

/* Sets focus to widget */
int
clip_GTK_WINDOWSETFOCUS(ClipMachine * cm)
{
	C_widget *cwin  = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKARG2(2,MAP_t,NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW); CHECKCWID(cwid,GTK_IS_WIDGET);
	gtk_window_set_focus(GTK_WINDOW(cwin->widget),cwid->widget);
	return 0;
err:
	return 1;
}

/* Sets default widget in window */
int
clip_GTK_WINDOWSETDEFAULT(ClipMachine * cm)
{
	C_widget *cwin  = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKARG2(2,MAP_t,NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW); CHECKCWID(cwid,GTK_IS_WIDGET);
	GTK_WINDOW(cwin->widget)->default_widget = cwid->widget;
	return 0;
err:
	return 1;
}

/* Sets default size for window */
int
clip_GTK_WINDOWSETDEFAULTSIZE(ClipMachine * cm)
{
	C_widget *cwin  = _fetch_cw_arg(cm);
	gint      width = _clip_parni(cm,2);
	gint     height = _clip_parni(cm,3);
	GtkArg arg;
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t)
	{
		arg.type = GTK_TYPE_INT; arg.name = "width";
		gtk_widget_get(cwin->widget, &arg);
		if (arg.d.int_data == -1) arg.d.int_data = cwin->widget->requisition.width;
		width = arg.d.int_data;
	}
	if (_clip_parinfo(cm,3)==UNDEF_t)
	{
		arg.type = GTK_TYPE_INT; arg.name = "height";
		gtk_widget_get(cwin->widget, &arg);
		if (arg.d.int_data == -1) arg.d.int_data = cwin->widget->requisition.height;
		height = arg.d.int_data;
	}
	gtk_window_set_default_size(GTK_WINDOW(cwin->widget), width, height);
	return 0;
err:
	return 1;
}
/* Alena:Set  window positions */
/* GTK_WIN_POS_NONE   	No influence is made on placement.                      */
/* GTK_WIN_POS_CENTER   Windows should be placed in the center of the screen.   */
/* GTK_WIN_POS_MOUSE    Windows should be placed at the current mouse position. */
/* GTK_WIN_POS_CENTER_ALWAYS Keep window centered as it changes size, etc.      */
/* GTK_WIN_POS_CENTER_ON_PARENT Center the window on its transient parent (see  */
/*				 gtk_window_set_transient_for()). 		*/
int
clip_GTK_WINDOWSETPOSITION(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gint  position = _clip_parni(cm, 2);
	CHECKOPT(2, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	gtk_window_set_position(GTK_WINDOW(cwin->widget), position);
	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWADDACCELGROUP(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	C_object *caccg = _fetch_cobject(cm,_clip_spar(cm,2));

	CHECKARG2(2, MAP_t, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKCOBJ(caccg,GTK_IS_ACCEL_GROUP(caccg));

	gtk_window_add_accel_group(GTK_WINDOW(cwin->widget), GTK_ACCEL_GROUP(caccg->object));

	return 0;
err:
	return 1;
}

