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
static gint handle_move_current_signal (GtkWidget *widget, GtkMenuDirectionType direction, C_signal *cs)
{
	PREPARECV(cs,cv);
        _clip_mputn(cs->cw->cmachine, &cv, HASH_DIRECTION, direction);
        INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_activate_current_signal (GtkWidget *widget, gboolean force_hide, C_signal *cs)
{
	PREPARECV(cs,cv);
        _clip_mputn(cs->cw->cmachine, &cv, HASH_FORCEHIDE, force_hide);
        INVOKESIGHANDLER(widget,cs,cv);
}

static SignalTable menushell_signals[] =
{
	{"deactivate",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_DEACTIVATE_SIGNAL},
	{"selection-done",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SELECTION_DONE_SIGNAL},
	{"move-current",	GSF( handle_move_current_signal ), ESF( object_emit_signal ), GTK_MOVE_CURRENT_SIGNAL},
	{"activate-current",	GSF( handle_activate_current_signal ), ESF( object_emit_signal ), GTK_ACTIVATE_CURRENT_SIGNAL},
	{"cancel",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CANCEL_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register menu shell signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_menu_shell() { return GTK_TYPE_MENU_SHELL; }
long _clip_type_menu_shell() { return GTK_WIDGET_MENU_SHELL; }
const char * _clip_type_name_menu_shell() { return "GTK_WIDGET_MENU_SHELL"; }

int
clip_INIT___MENU_SHELL(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_menu_shell, _clip_type_name_menu_shell, _gtk_type_menu_shell, _gtk_type_container, menushell_signals);
	return 0;
}
/**********************************************************/

int
clip_GTK_MENUSHELLAPPEND(ClipMachine * cm)
{
	C_widget *cmns = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cmns,GTK_IS_MENU_SHELL);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_menu_shell_append(GTK_MENU_SHELL(cmns->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUSHELLPREPEND(ClipMachine * cm)
{
	C_widget *cmns = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cmns,GTK_IS_MENU_SHELL);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_menu_shell_prepend(GTK_MENU_SHELL(cmns->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUSHELLINSERT(ClipMachine * cm)
{
	C_widget *cmns = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        int   position = _clip_parni(cm,3);
        CHECKCWID(cmns,GTK_IS_MENU_SHELL);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t);
        gtk_menu_shell_insert(GTK_MENU_SHELL(cmns->widget), cwid->widget, position);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUSHELLDEACTIVATE(ClipMachine * cm)
{
	C_widget *cmns = _fetch_cw_arg(cm);
        CHECKCWID(cmns,GTK_IS_MENU_SHELL);
        gtk_menu_shell_deactivate(GTK_MENU_SHELL(cmns->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUSHELLSELECTITEM(ClipMachine * cm)
{
	C_widget *cmns = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cmns,GTK_IS_MENU_SHELL);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_menu_shell_select_item(GTK_MENU_SHELL(cmns->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUSHELLDESELECT(ClipMachine * cm)
{
	C_widget *cmns = _fetch_cw_arg(cm);
        CHECKCWID(cmns,GTK_IS_MENU_SHELL);
        gtk_menu_shell_deselect(GTK_MENU_SHELL(cmns->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUSHELLACTIVATETITEM(ClipMachine * cm)
{
	C_widget *cmns = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        gboolean force_deactivate = _clip_parl(cm,3);
        CHECKCWID(cmns,GTK_IS_MENU_SHELL);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,LOGICAL_t);
        gtk_menu_shell_activate_item(GTK_MENU_SHELL(cmns->widget), cwid->widget, force_deactivate);
	return 0;
err:
	return 1;
}
