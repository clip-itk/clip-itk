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

/****              Menu has no signals                 ****/

/**********************************************************/

/* Register menu signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_menu() { return GTK_TYPE_MENU; }
long _clip_type_menu() { return GTK_WIDGET_MENU; }
const char * _clip_type_name_menu() { return "GTK_WIDGET_MENU"; }

int
clip_INIT___MENU(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_menu, _clip_type_name_menu, _gtk_type_menu, _gtk_type_menu_shell, NULL);
	return 0;
}
/**********************************************************/

/****  MENU constructor ****/
int
clip_GTK_MENUNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_menu_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/
int
clip_GTK_MENUAPPEND(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cmnu,GTK_IS_MENU);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_menu_append(GTK_MENU(cmnu->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUPREPEND(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cmnu,GTK_IS_MENU);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_menu_prepend(GTK_MENU(cmnu->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUINSERT(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        int   position = _clip_parni(cm,3);
        CHECKCWID(cmnu,GTK_IS_MENU);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t);
        gtk_menu_insert(GTK_MENU(cmnu->widget), cwid->widget, position);
	return 0;
err:
	return 1;
}

/* Display the menu onscreen */
int
clip_GTK_MENUPOPUP(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
        CHECKCWID(cmnu,GTK_IS_MENU);
        gtk_menu_popup(GTK_MENU(cmnu->widget), NULL,NULL,NULL,NULL,1,0);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUPOPDOWN(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
        CHECKCWID(cmnu,GTK_IS_MENU);
        gtk_menu_popdown(GTK_MENU(cmnu->widget));
	return 0;
err:
	return 1;
}

/* Keep track of the last menu item selected. (For the purposes
 * of the option menu */
int
clip_GTK_MENUGETACTIVE(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
        GtkWidget *item;
        C_widget *citem;
        CHECKCWID(cmnu,GTK_IS_MENU);
        item = gtk_menu_get_active(GTK_MENU(cmnu->widget));
        citem = _list_get_cwidget(cm,item);
        if (!citem) citem = _register_widget(cm,item,NULL);
        if (citem)
        {
        	ClipVar *ret = RETPTR(cm);
                _clip_mclone(cm,ret,&citem->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUSETACTIVE(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
        int      index = _clip_parni(cm,2);
        CHECKCWID(cmnu,GTK_IS_MENU);
        CHECKOPT(2,NUMERIC_t);
        gtk_menu_set_active(GTK_MENU(cmnu->widget), index);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUSETTEAROFFSTATE(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
        gboolean state = _clip_parl(cm,2);
        CHECKCWID(cmnu,GTK_IS_MENU);
        CHECKOPT(2,LOGICAL_t);
        gtk_menu_set_tearoff_state(GTK_MENU(cmnu->widget), state);
	return 0;
err:
	return 1;
}

/* This sets the window manager title for the window that
 * appears when a menu is torn off */
int
clip_GTK_MENUSETTITLE(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
        gchar   *title = _clip_parc(cm,2);
        CHECKCWID(cmnu,GTK_IS_MENU);
        CHECKOPT(2,CHARACTER_t);
        LOCALE_TO_UTF(title);
        gtk_menu_set_title(GTK_MENU(cmnu->widget), title);
        FREE_TEXT(title);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUREORDERCHILD(ClipMachine * cm)
{
	C_widget *cmnu = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        int   position = _clip_parni(cm,3);
        CHECKCWID(cmnu,GTK_IS_MENU);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t);
        gtk_menu_reorder_child(GTK_MENU(cmnu->widget), cwid->widget, position);
	return 0;
err:
	return 1;
}

