/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
              Elena V. Kornilova  <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <string.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

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

static gint handle_move_focus_signal (GtkWindow *window, GtkDirectionType arg1, C_signal *cs)
  {
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_DIRECTIONTYPE, arg1);
	INVOKESIGHANDLER(GTK_WIDGET(window),cs,cv);
  }

static gint handle_frame_event_signal (GtkWindow *window, GdkEvent *event, C_signal *cs)
  {
        return handle_events(GTK_WIDGET(window), event, cs);

  }

static SignalTable window_signals[] =
{
	{"activate-default",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_ACTIVATE_DEFAULT_SIGNAL},
	{"activate-focus",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_ACTIVATE_FOCUS_SIGNAL},
	{"kyes-changed",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_KEYS_CHANGED_SIGNAL},
	{"move-focus",		GSF( handle_move_focus_signal ), ESF( object_emit_signal ), GTK_MOVE_FOCUS_SIGNAL},
	{"set-focus",		GSF( handle_set_focus_signal ), ESF( object_emit_signal ), GTK_SET_FOCUS_SIGNAL},
	{"frame-event",		GSF( handle_frame_event_signal ),ESF( object_emit_signal ), GTK_FRAME_EVENT_SIGNAL},
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
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cpix,GTK_IS_PIXMAP);
	if (cwin->widget->window)
	{
		gdk_window_set_icon(cwin->widget->window, cwin->widget->window,
			GTK_PIXMAP(cpix->widget)->pixmap, (GdkBitmap *) NULL);
		_clip_retl(cm, TRUE);
	}
	else
		_clip_retl(cm, FALSE);
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

int
clip_GTK_WINDOWSETDECORATED(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gboolean  setting = _clip_parl(cm, 2);

	CHECKARG(2, LOGICAL_t);
        CHECKCWID(cwin , GTK_IS_WINDOW);

	gtk_window_set_decorated(GTK_WINDOW(cwin->widget), setting);
	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWGETDECORATED(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gboolean  setting;

        CHECKCWID(cwin , GTK_IS_WINDOW);

	setting = gtk_window_get_decorated(GTK_WINDOW(cwin->widget));

	_clip_parl(cm, setting);
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

/* Gets title of window */
int
clip_GTK_WINDOWGETTITLE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gchar   *title;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	title = (gchar *) gtk_window_get_title(GTK_WINDOW(cwin->widget));

	LOCALE_FROM_UTF(title);
        _clip_retc(cm, title);
	FREE_TEXT(title);
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

int
clip_GTK_WINDOWGETMODAL(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gboolean modal;
	CHECKCWID(cwin,GTK_IS_WINDOW);
	modal = gtk_window_get_modal(GTK_WINDOW(cwin->widget));
	_clip_retl(cm, modal);
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

/* Gets focus to widget */
int
clip_GTK_WINDOWGETFOCUS(ClipMachine * cm)
{
	C_widget *cwin  = _fetch_cw_arg(cm);
	C_widget *cwid;
	CHECKCWID(cwin,GTK_IS_WINDOW);

	cwid = _get_cwidget(cm, gtk_window_get_focus(GTK_WINDOW(cwin->widget)));

	_clip_mclone(cm, RETPTR(cm), &cwid->obj);
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

	GTK_WIDGET_SET_FLAGS(GTK_WIDGET(cwid->widget), GTK_CAN_DEFAULT);
	gtk_window_set_default(GTK_WINDOW(cwin->widget), GTK_WIDGET(cwid->widget));
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

	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t)
		width = -1;
	if (_clip_parinfo(cm,3)==UNDEF_t)
		height = -1;

	gtk_window_set_default_size(GTK_WINDOW(cwin->widget), width, height);
	return 0;
err:
	return 1;
}
/* Gets default size for window */
int
clip_GTK_WINDOWGETDEFAULTSIZE(ClipMachine * cm)
{
	C_widget *cwin  = _fetch_cw_arg(cm);
	gint      width;
	gint     height;

	CHECKCWID(cwin,GTK_IS_WINDOW);
	gtk_window_get_default_size(GTK_WINDOW(cwin->widget), &width, &height);
        _clip_storni(cm, width, 2, 0);
        _clip_storni(cm, height, 3, 0);
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

/* Sets unique name for restart application */
/* if TITLE -is unique name - this function can't be use :) */
int
clip_GTK_WINDOWSETROLE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gchar 	*role = _clip_parc(cm, 2);
	CHECKOPT(2, CHARACTER_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_set_role(GTK_WINDOW(cwin->widget), (const gchar*) role);

	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWGETROLE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	G_CONST_RETURN gchar 	*role;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	role = gtk_window_get_role(GTK_WINDOW(cwin->widget));

	_clip_retc(cm, (gchar *)role);
	return 0;
err:
	return 1;
}



int
clip_GTK_WINDOWADDACCELGROUP(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	C_widget *caccg = _fetch_cwidget(cm,_clip_spar(cm,2));

	CHECKARG2(2, MAP_t, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKCWID(caccg,GTK_IS_ACCEL_GROUP);

	gtk_window_add_accel_group(GTK_WINDOW(cwin->widget), GTK_ACCEL_GROUP(caccg->widget));

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWREMOVEACCELGROUP(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	C_widget *caccg = _fetch_cwidget(cm,_clip_spar(cm,2));

	CHECKARG2(2, MAP_t, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKCWID(caccg,GTK_IS_ACCEL_GROUP);

	gtk_window_remove_accel_group(GTK_WINDOW(cwin->widget), GTK_ACCEL_GROUP(caccg->widget));

	return 0;
err:
	return 1;
}

/*
  see clip-gtk2.ch
GDK_WINDOW_TYPE_HINT_NORMAL	1
GDK_WINDOW_TYPE_HINT_DIALOG	2
GDK_WINDOW_TYPE_HINT_MENU	3
GDK_WINDOW_TYPE_HINT_TOOLBAR	4

*/

int
clip_GTK_WINDOWSETTYPEHINT(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	gint hint = _clip_parni(cm,2);

	CHECKARG(2, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_set_type_hint(GTK_WINDOW(cwin->widget), hint);

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWGETTYPEHINT(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gint hint;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	hint = gtk_window_get_type_hint(GTK_WINDOW(cwin->widget));

	_clip_retni(cm, hint);

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWSETDESTROYWITHPARENT(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gboolean setting = _clip_parl(cm, 2);

	CHECKARG(2, LOGICAL_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_set_destroy_with_parent(GTK_WINDOW(cwin->widget), setting);

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWGETDESTROYWITHPARENT(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gboolean setting;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	setting = gtk_window_get_destroy_with_parent(GTK_WINDOW(cwin->widget));

	_clip_retl(cm, setting);
	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWSETRESIZEABLE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gboolean resizable = _clip_parl(cm, 2);

	CHECKARG(2, LOGICAL_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_set_resizable(GTK_WINDOW(cwin->widget), resizable);

	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWGETRESIZEABLE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gboolean resizable;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	resizable = gtk_window_get_resizable(GTK_WINDOW(cwin->widget));

	_clip_retl(cm, resizable);

	return 0;
err:
	return 1;
}
/*
  see clip-gtk2.ch
GDK_GRAVITY_NORTH_WEST	1
GDK_GRAVITY_NORTH	2
GDK_GRAVITY_NORTH_EAST	3
GDK_GRAVITY_WEST	4
GDK_GRAVITY_CENTER	5
GDK_GRAVITY_EAST	6
GDK_GRAVITY_SOUTH_WEST	7
GDK_GRAVITY_SOUTH	8
GDK_GRAVITY_SOUTH_EAST	9
GDK_GRAVITY_STATIC	10
*/
int
clip_GTK_WINDOWSETGRAVITY(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gint gravity = _clip_parni(cm, 2);

	CHECKARG(2, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_set_gravity(GTK_WINDOW(cwin->widget), gravity);

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWGETGRAVITY(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gint gravity;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gravity = gtk_window_get_gravity(GTK_WINDOW(cwin->widget));

	_clip_retni(cm, gravity);

	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWSETHASFRAME(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gboolean setting = _clip_parl(cm, 2);

	CHECKARG(2, LOGICAL_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_set_has_frame(GTK_WINDOW(cwin->widget), setting);

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWGETHASFRAME(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gboolean setting;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	setting = gtk_window_get_has_frame(GTK_WINDOW(cwin->widget));

	_clip_retl(cm, setting);

	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWSETFRAMEDIMENSIONS(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gint      left = _clip_parl(cm, 2);
        gint       top = _clip_parl(cm, 3);
        gint     right = _clip_parl(cm, 4);
        gint    bottom = _clip_parl(cm, 5);

	CHECKARG(2, NUMERIC_t);
	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);
	CHECKARG(5, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_set_frame_dimensions(GTK_WINDOW(cwin->widget), left, top, right, bottom);

	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWGETFRAMEDIMENSIONS(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        gint      left;
        gint       top;
        gint     right;
        gint    bottom;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_get_frame_dimensions(GTK_WINDOW(cwin->widget), &left, &top, &right, &bottom);

	_clip_storni(cm,   left, 2, 0);
	_clip_storni(cm,    top, 3, 0);
	_clip_storni(cm,  right, 4, 0);
	_clip_storni(cm, bottom, 5, 0);
	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWSETICONLIST(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        ClipVar *items = _clip_spar(cm, 2);

	CHECKCWID(cwin,GTK_IS_WINDOW);
        CHECKOPT(2, ARRAY_t);

	if (items->t.type == ARRAY_t)
        {
        	GList *list = NULL;
                unsigned short i;
                ClipVar *item;
                C_object *citem;
                for (i=0; i<items->a.count; i++)
                {
                	item = &items->a.items[i];
                	if (item->t.type == NUMERIC_t || item->t.type == MAP_t)
                        {
                        	citem = _fetch_cobject(cm,item);
                                CHECKCOBJ(citem,GDK_IS_PIXBUF(citem->object));
                                list = g_list_append(list, citem->object);
                        }
                }
                if (list)
                {
			gtk_window_set_icon_list(GTK_WINDOW(cwin->widget), list);
                        g_list_free(list);
                }
        }

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWGETICONLIST(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        C_widget *clist;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	clist = _get_cwidget(cm, GTK_WIDGET(gtk_window_get_icon_list(GTK_WINDOW(cwin->widget))));

	_clip_mclone(cm, RETPTR(cm), &clist->obj);
	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWSETICON(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        C_object *cicon = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cwin,GTK_IS_WINDOW);  CHECKCOBJ(cicon, GDK_IS_PIXBUF(cicon));

        gtk_window_set_icon(GTK_WINDOW(cwin->widget), GDK_PIXBUF(cicon->object));
	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWGETICON(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        GdkPixbuf *pixbuf;
        C_object *cicon;

	CHECKCWID(cwin,GTK_IS_WINDOW);

        pixbuf = gtk_window_get_icon(GTK_WINDOW(cwin->widget));
        cicon = _register_object(cm, pixbuf, GDK_TYPE_PIXBUF, NULL, NULL);
        if (cicon)
        	_clip_mclone(cm, RETPTR(cm), &cicon->obj);
	return 0;
err:
	return 1;
}
int
clip_GTK_WINDOWSETDEFAULTICONLIST(ClipMachine * cm)
{
        ClipVar *items = _clip_spar(cm, 1);

        CHECKOPT(1, ARRAY_t);

	if (items->t.type == ARRAY_t)
        {
        	GList *list = NULL;
                unsigned short i;
                ClipVar *item;
                C_object *citem;
                for (i=0; i<items->a.count; i++)
                {
                	item = &items->a.items[i];
                	if (item->t.type == NUMERIC_t || item->t.type == MAP_t)
                        {
                        	citem = _fetch_cobject(cm,item);
                                CHECKCOBJ(citem,GDK_IS_PIXBUF(citem->object));
                                list = g_list_append(list, citem->object);
                        }
                }
                if (list)
                {
			gtk_window_set_default_icon_list(list);
                        g_list_free(list);
                }
        }

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWGETDEFAULTICONLIST(ClipMachine * cm)
{
        C_widget *clist;

	clist = _get_cwidget(cm, GTK_WIDGET(gtk_window_get_default_icon_list()));

	_clip_mclone(cm, RETPTR(cm), &clist->obj);
	return 0;
}



int
clip_GTK_WINDOWLISTTOPLEVELS(ClipMachine * cm)
{
        C_widget *clist;

	clist = _get_cwidget(cm, GTK_WIDGET(gtk_window_list_toplevels()));

	_clip_mclone(cm, RETPTR(cm), &clist->obj);
	return 0;
}

int
clip_GTK_WINDOWADDMNEMONIC(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        guint   keyval = _clip_parni(cm, 2);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,3));

	CHECKARG(2, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKCWID(cwid,GTK_IS_WIDGET);

	gtk_window_add_mnemonic(GTK_WINDOW(cwin->widget), keyval, GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWREMOVEMNEMONIC(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        guint   keyval = _clip_parni(cm, 2);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,3));

	CHECKARG(2, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKCWID(cwid,GTK_IS_WIDGET);

	gtk_window_remove_mnemonic(GTK_WINDOW(cwin->widget), keyval, GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWMNEMONICACTIVATE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
        guint   keyval = _clip_parni(cm, 2);
	GdkModifierType modifier = _clip_parni(cm, 3);
        gboolean ret;

	CHECKARG(2, NUMERIC_t); CHECKARG(3, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	ret = gtk_window_mnemonic_activate(GTK_WINDOW(cwin->widget), keyval, modifier);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWSETMNEMONICMODIFIER(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	GdkModifierType modifier = _clip_parni(cm, 2);

	CHECKARG(2, NUMERIC_t);
	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_set_mnemonic_modifier(GTK_WINDOW(cwin->widget), modifier);

	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWGETMNEMONICMODIFIER(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	GdkModifierType modifier;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	modifier = gtk_window_get_mnemonic_modifier(GTK_WINDOW(cwin->widget));

	_clip_retni(cm, modifier);
	return 0;
err:
	return 1;
}


/* Presents a window to the user. This may mean raising the window in the */
/* stacking order, deiconifying it, moving it to the current desktop,     */
/* and/or giving it the keyboard focus, possibly dependent on the user's  */
/* platform, window manager, and preferences.                             */

int
clip_GTK_WINDOWPRESENT(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_present(GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}

/* Asks to iconify (i.e. minimize) the specified window. */
int
clip_GTK_WINDOWICONIFY(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_iconify(GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}


/* Asks to deiconify (i.e. unminimize) the specified window. */
int
clip_GTK_WINDOWDEICONIFY(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_deiconify(GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}

/* Asks to stick window, which means that it will appear on all user desktops. */
int
clip_GTK_WINDOWSTICK(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_stick(GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}
/* Asks to unstick window. */
int
clip_GTK_WINDOWUNSTICK(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_unstick(GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}

/* Asks to maximize window, so that it becomes full-screen. */
int
clip_GTK_WINDOWMAXIMIZE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_maximize(GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}

/* Asks to unmaximize window. */
int
clip_GTK_WINDOWUNMAXIMIZE(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_unmaximize(GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}

/* Starts resizing a window. */
int
clip_GTK_WINDOWBEGINRESIZEDRAG(ClipMachine * cm)
{
	C_widget     *cwin = _fetch_cw_arg(cm);
        GdkWindowEdge edge = _clip_parni(cm, 2);
        gint        button = _clip_parni(cm, 3);
        gint        root_x = _clip_parni(cm, 4);
        gint        root_y = _clip_parni(cm, 5);
        guint32  timestamp = _clip_parni(cm, 6);

	CHECKCWID(cwin,GTK_IS_WINDOW);
        CHECKARG(2, NUMERIC_t);CHECKARG(3, NUMERIC_t); CHECKARG(4, NUMERIC_t);
        CHECKARG(5, NUMERIC_t); CHECKARG(6, NUMERIC_t);

	gtk_window_begin_resize_drag(GTK_WINDOW(cwin->widget), edge, button,
					root_x, root_y, timestamp);

	return 0;
err:
	return 1;
}

/* Starts moving a window. */
int
clip_GTK_WINDOWBEGINMOVEDRAG(ClipMachine * cm)
{
	C_widget     *cwin = _fetch_cw_arg(cm);
        gint        button = _clip_parni(cm, 2);
        gint        root_x = _clip_parni(cm, 3);
        gint        root_y = _clip_parni(cm, 4);
        guint32  timestamp = _clip_parni(cm, 5);

	CHECKCWID(cwin,GTK_IS_WINDOW);
        CHECKARG(2, NUMERIC_t);CHECKARG(3, NUMERIC_t); CHECKARG(4, NUMERIC_t);
        CHECKARG(5, NUMERIC_t);

	gtk_window_begin_move_drag(GTK_WINDOW(cwin->widget), button,
					root_x, root_y, timestamp);

	return 0;
err:
	return 1;
}


/* Resizes the window as if the user had done so, obeying geometry constraints. */
int
clip_GTK_WINDOWRESIZE(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
        gint        width = _clip_parni(cm, 2);
        gint       height = _clip_parni(cm, 3);

	CHECKCWID(cwin,GTK_IS_WINDOW);
        CHECKOPT(2, NUMERIC_t);CHECKOPT(3, NUMERIC_t);

	gtk_window_resize(GTK_WINDOW(cwin->widget), width, height);

	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWGETSIZE(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
        gint        width;
        gint       height;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_get_size(GTK_WINDOW(cwin->widget), &width, &height);

	_clip_storni(cm, width, 2, 0);
	_clip_storni(cm, height, 3, 0);
	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWMOVE(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
        gint       x = _clip_parni(cm, 2);
        gint       y = _clip_parni(cm, 3);

	CHECKCWID(cwin,GTK_IS_WINDOW);
        CHECKARG(2, NUMERIC_t);CHECKARG(3, NUMERIC_t);

	gtk_window_move(GTK_WINDOW(cwin->widget), x, y);

	return 0;
err:
	return 1;
}

int
clip_GTK_WINDOWGETPOSITION(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
        gint       root_x;
        gint       root_y;

	CHECKCWID(cwin,GTK_IS_WINDOW);

	gtk_window_get_position(GTK_WINDOW(cwin->widget), &root_x, &root_y);

	_clip_storni(cm, root_x, 2, 0);
	_clip_storni(cm, root_y, 3, 0);
	return 0;
err:
	return 1;
}


/* Parses a standard X Window System geometry string - see the manual page    */
/* for X (type 'man X') for details on this. gtk_window_parse_geometry() does */
/* work on all GTK+ ports including Win32 but is primarily intended for       */
/* an X environment.                                                          */
/*                                                                            */
/* If either a size or a position can be extracted from the geometry string,  */
/* gtk_window_parse_geometry() returns TRUE and calls                         */
/* gtk_window_set_default_size() and/or gtk_window_move() to resize/move the  */
/* window.                                                                    */


int
clip_GTK_WINDOWPARSEGEOMETRY(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
        const char * geometry = _clip_parc(cm, 2);
        gboolean ret;

	CHECKCWID(cwin,GTK_IS_WINDOW);
        CHECKARG(2, CHARACTER_t);

	ret = gtk_window_parse_geometry(GTK_WINDOW(cwin->widget), geometry);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}


int
clip_GTK_WINDOWSETGEOMETRYHINTS(ClipMachine * cm)
{
	C_widget     *cwin = _fetch_cw_arg(cm);
        C_widget     *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        ClipVar     *mgeom = _clip_par(cm, 3);
        GdkGeometry *geometry;
        gint mask = 0;

	CHECKCWID(cwin,GTK_IS_WINDOW);
	CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(2, MAP_t);

	mask = _map_to_gdk_geometry(cm, mgeom, geometry);
	gtk_window_set_geometry_hints(GTK_WINDOW(cwin->widget), GTK_WIDGET(cwid->widget), geometry, mask);

	return 0;
err:
	return 1;
}


