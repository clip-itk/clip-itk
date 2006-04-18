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
/****          Option menu has no own signals          ****/
/**********************************************************/

/* Register option menu in global table */
CLIP_DLLEXPORT GtkType _gtk_type_option_menu() { return GTK_TYPE_OPTION_MENU; }
long _clip_type_option_menu() { return GTK_WIDGET_OPTION_MENU; }
const char * _clip_type_name_option_menu() { return "GTK_WIDGET_OPTION_MENU"; }

int
clip_INIT___OPTION_MENU(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_option_menu, _clip_type_name_option_menu, _gtk_type_option_menu, _gtk_type_button, NULL);
	return 0;
}
/**********************************************************/

/**** Option menu constructor ****/
int
clip_GTK_OPTIONMENUNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

        wid = gtk_option_menu_new();
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Returns the GtkMenu associated with the GtkOptionMenu. */
int
clip_GTK_OPTIONMENUGETMENU(ClipMachine * cm)
{
	C_widget *coptmenu = _fetch_cw_arg(cm);
        C_widget *cmenu = 0;
        GtkWidget *menu;
        CHECKCWID(coptmenu,GTK_IS_OPTION_MENU);
        menu = gtk_option_menu_get_menu(GTK_OPTION_MENU(coptmenu->widget));
        if (menu)
        {
        	cmenu = _list_get_cwidget(cm,menu);
                if (!cmenu) cmenu = _register_widget(cm,menu,NULL);
	}
	if (cmenu) _clip_mclone(cm,RETPTR(cm),&cmenu->obj);
	return 0;
err:
	return 1;
}

/* Provides the GtkMenu that is popped up to allow the user to choose a
 * new value. You should provide a simple menu avoiding the use of tearoff
 * menu items, submenus, and accelerators. */
int
clip_GTK_OPTIONMENUSETMENU(ClipMachine * cm)
{
	C_widget *coptmenu = _fetch_cw_arg(cm);
	C_widget    *cmenu = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(coptmenu,GTK_IS_OPTION_MENU);
        CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cmenu,GTK_IS_MENU);
        gtk_option_menu_set_menu(GTK_OPTION_MENU(coptmenu->widget), cmenu->widget);
	return 0;
err:
	return 1;
}

/* Removes the menu from the option menu. */
int
clip_GTK_OPTIONMENUREMOVEMENU(ClipMachine * cm)
{
	C_widget *coptmenu = _fetch_cw_arg(cm);
        CHECKCWID(coptmenu,GTK_IS_OPTION_MENU);
        gtk_option_menu_remove_menu(GTK_OPTION_MENU(coptmenu->widget));
	return 0;
err:
	return 1;
}

/* Selects the menu item specified by index making
 * it the newly selected value for the option menu. */
int
clip_GTK_OPTIONMENUSETHISTORY(ClipMachine * cm)
{
	C_widget *coptmenu = _fetch_cw_arg(cm);
	guint        index = _clip_parni(cm,2);
        CHECKCWID(coptmenu,GTK_IS_OPTION_MENU);
        CHECKOPT(2,NUMERIC_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) index = 1;
        gtk_option_menu_set_history(GTK_OPTION_MENU(coptmenu->widget), index-1);
	return 0;
err:
	return 1;
}

