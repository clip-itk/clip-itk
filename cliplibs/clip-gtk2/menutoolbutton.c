/*
    Copyright (C) 2005  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

static SignalTable menu_tool_button_signals[] =
{
	{"show-menu",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SHOW_MENU_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register menu signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_menu_tool_button() { return GTK_TYPE_MENU_TOOL_BUTTON; }
long _clip_type_menu_tool_button() { return GTK_WIDGET_MENU_TOOL_BUTTON; }
const char * _clip_type_name_menu_tool_button() { return "GTK_WIDGET_MENU_TOOL_BUTTON"; }

int
clip_INIT___MENUTOOLBUTTON(ClipMachine *cm)
{

	_wtype_table_put(_clip_type_menu_tool_button, _clip_type_name_menu_tool_button, _gtk_type_menu_tool_button, _gtk_type_tool_button, menu_tool_button_signals);
	return 0;
}
/**********************************************************/

int
clip_GTK_MENUTOOLBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
        C_widget *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gchar   *label = _clip_parc(cm, 3);
	GtkWidget *wid = NULL;
        GtkToolItem *item ;
        C_widget   *citem ;

	CHECKOPT(1,MAP_t);
        CHECKCWIDOPT(cwid, GTK_IS_WIDGET);
        CHECKOPT(3, CHARACTER_t);

	if (cwid) wid = GTK_WIDGET(cwid->widget);

	item = gtk_menu_tool_button_new(wid, label);
	citem = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&citem->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUTOOLBUTTONNEWFROMSTOCK(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
        gchar   *stock = _clip_parc(cm, 2);
        GtkToolItem *item ;
        C_widget   *citem ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	item = gtk_menu_tool_button_new_from_stock(stock);
	citem = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&citem->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUTOOLBUTTONSETMENU(ClipMachine * cm)
{
	C_widget *cmenu = _fetch_cw_arg(cm);
	C_widget  *cmnu = _fetch_cwidget(cm,_clip_spar(cm,2));

        CHECKCWID(cmenu,GTK_IS_MENU_TOOL_BUTTON);
        CHECKCWID(cmnu,GTK_IS_WIDGET);

        gtk_menu_tool_button_set_menu(GTK_MENU_TOOL_BUTTON(cmenu->widget), GTK_WIDGET(cmnu->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_MENUTOOLBUTTONGETMENU(ClipMachine * cm)
{
	C_widget *cmenu = _fetch_cw_arg(cm);
	GtkWidget  *mnu ;
	C_widget  *cmnu ;

        CHECKCWID(cmenu,GTK_IS_MENU_TOOL_BUTTON);

        mnu = gtk_menu_tool_button_get_menu(GTK_MENU_TOOL_BUTTON(cmenu->widget));

	if (mnu)
        {
        	cmnu = _list_get_cwidget(cm, mnu);
                if (!cmnu) cmnu = _register_widget(cm, mnu, NULL);
                if (cmnu) _clip_mclone(cm, RETPTR(cm), &cmnu->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_MENUTOOLBUTTONSETARROWTOOLTIP(ClipMachine * cm)
{
	C_widget  *cmenu = _fetch_cw_arg(cm);
	C_widget *cttips = _fetch_cwidget(cm,_clip_spar(cm,2));
        gchar        *text = _clip_parc(cm, 3);
        gchar *privatetext = _clip_parc(cm, 4);

        CHECKCWID(cmenu,GTK_IS_MENU_TOOL_BUTTON);
        CHECKCWID(cttips,GTK_IS_WIDGET);
        CHECKARG(3, CHARACTER_t);
        CHECKARG(4, CHARACTER_t);

        LOCALE_TO_UTF(text);
        LOCALE_TO_UTF(privatetext);
        gtk_menu_tool_button_set_arrow_tooltip(GTK_MENU_TOOL_BUTTON(cmenu->widget),
        	GTK_TOOLTIPS(cttips->widget),
        	text,
        	privatetext);
        FREE_TEXT(text);
        FREE_TEXT(privatetext);

	return 0;
err:
	return 1;
}

