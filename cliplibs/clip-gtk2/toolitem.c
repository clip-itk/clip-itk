/*
    Copyright (C) 2004 - 2005  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/* Signal handlers */
gint handle_set_tooltip_signal (GtkToolItem *toolitem, GtkTooltips *tooltips, gchar *tip_text, gchar *tip_private, C_signal *cs)
{
	C_widget *ctips;
	PREPARECV(cs,cv);
        ctips = _list_get_cwidget(cs->cw->cmachine, tooltips);
        if (!ctips) ctips = _register_widget(cs->cw->cmachine, GTK_WIDGET(tooltips), NULL);
        if (ctips) _clip_madd(cs->cw->cmachine, &cv, HASH_TOOLTIPS, &ctips->obj);

	LOCALE_FROM_UTF(tip_text);
        _clip_mputc(cs->cw->cmachine, &cv, HASH_TIP_TEXT, tip_text, strlen(tip_text));
        FREE_TEXT(tip_text);

	LOCALE_FROM_UTF(tip_private);
        _clip_mputc(cs->cw->cmachine, &cv, HASH_TIP_PRIVATE, tip_private, strlen(tip_private));
        FREE_TEXT(tip_private);
        INVOKESIGHANDLER(GTK_WIDGET(toolitem),cs,cv);
}

/* Signals table */
static SignalTable toolitem_signals[] =
{
	{"create-menu-proxy",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CREATE_MENU_PROXY_SIGNAL},
	{"set-tooltip",		GSF( handle_set_tooltip_signal ), ESF( object_emit_signal ), GTK_SET_TOOLTIP_SIGNAL},
	{"toolbar-reconfigured",GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_TOOLBAR_RECONFIGURED_SIGNAL},
	{"", NULL, NULL, 0}
};


/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_tool_item() { return GTK_TYPE_TOOL_ITEM; }
long _clip_type_tool_item() { return GTK_WIDGET_TOOL_ITEM; }
const char * _clip_type_name_tool_item()  { return "GTK_WIDGET_TOOL_ITEM"; }

CLIP_DLLEXPORT GtkType _gtk_type_separator_tool_item() { return GTK_TYPE_SEPARATOR_TOOL_ITEM; }
long _clip_type_separator_tool_item() { return GTK_WIDGET_SEPARATOR_TOOL_ITEM; }
const char * _clip_type_name_separator_tool_item()  { return "GTK_WIDGET_SEPARATOR_TOOL_ITEM"; }

/* Register toolitem in global table */
int
clip_INIT___TOOLITEM(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_tool_item,  _clip_type_name_tool_item,  _gtk_type_tool_item,  _gtk_type_bin, toolitem_signals);
	_wtype_table_put(_clip_type_separator_tool_item,  _clip_type_name_separator_tool_item,  _gtk_type_separator_tool_item,  _gtk_type_tool_item, NULL);
	return 0;
}

/**** ------------------ ****/
int
clip_GTK_TOOLITEMNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkToolItem *item;
        C_widget *citem;

	CHECKOPT(1,MAP_t);
        item = gtk_tool_item_new();
        if (!item) goto err;
	citem = _register_widget(cm, GTK_WIDGET(item), cv);
        _clip_mclone(cm,RETPTR(cm),&citem->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_TOOLITEMSETHOMOGENEOUS(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gboolean    set = _clip_parl(cm, 2);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKOPT(2,LOGICAL_t);

        gtk_tool_item_set_homogeneous(GTK_TOOL_ITEM(citem->widget),
        	set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETHOMOGENEOUS(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retl(cm, gtk_tool_item_get_homogeneous(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}


int
clip_GTK_TOOLITEMSETEXPAND(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gboolean    set = _clip_parl(cm, 2);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKOPT(2,LOGICAL_t);

        gtk_tool_item_set_expand(GTK_TOOL_ITEM(citem->widget),
        	set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETEXPAND(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retl(cm, gtk_tool_item_get_expand(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMSETTOOLTIP(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        C_widget *ctips = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gchar *tip_text = _clip_parc(cm, 3);
        gchar *tip_priv = _clip_parc(cm, 4);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKCWID(ctips, GTK_IS_TOOLTIPS);
        CHECKOPT(3, CHARACTER_t); CHECKOPT(4, CHARACTER_t);


        LOCALE_TO_UTF(tip_text);
        LOCALE_TO_UTF(tip_priv);
        gtk_tool_item_set_tooltip(GTK_TOOL_ITEM(citem->widget),
        	GTK_TOOLTIPS(ctips->widget),
        	tip_text, tip_priv);
        FREE_TEXT(tip_text);
        FREE_TEXT(tip_priv);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMSETUSEDRAGWINDOW(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gboolean    set = _clip_parl(cm, 2);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKOPT(2,LOGICAL_t);

        gtk_tool_item_set_use_drag_window(GTK_TOOL_ITEM(citem->widget),
        	set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETUSEDRAGWINDOW(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retl(cm, gtk_tool_item_get_use_drag_window(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMSETVISIBLEHORIZONTAL(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gboolean    set = _clip_parl(cm, 2);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKOPT(2,LOGICAL_t);

        gtk_tool_item_set_visible_horizontal(GTK_TOOL_ITEM(citem->widget),
        	set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETVISIBLEHORIZONTAL(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retl(cm, gtk_tool_item_get_visible_horizontal(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMSETVISIBLEVERTICAL(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gboolean    set = _clip_parl(cm, 2);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKOPT(2,LOGICAL_t);

        gtk_tool_item_set_visible_vertical(GTK_TOOL_ITEM(citem->widget),
        	set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETVISIBLEVERTICAL(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retl(cm, gtk_tool_item_get_visible_vertical(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMSETISIMPORTANT(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gboolean    set = _clip_parl(cm, 2);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKOPT(2,LOGICAL_t);

        gtk_tool_item_set_is_important(GTK_TOOL_ITEM(citem->widget),
        	set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETISIMPORTANT(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retl(cm, gtk_tool_item_get_is_important(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETICONSIZE(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retni(cm, (int)gtk_tool_item_get_icon_size(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETORIENTATION(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retni(cm, (int)gtk_tool_item_get_orientation(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETTOOLBARSTYLE(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retni(cm, (int)gtk_tool_item_get_toolbar_style(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETRELIEFSTYLE(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        _clip_retni(cm, (int)gtk_tool_item_get_relief_style(GTK_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMRETRIEVEPROXYMENUITEM(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        GtkWidget *wid ;
        C_widget *cwid ;

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        wid = gtk_tool_item_retrieve_proxy_menu_item(GTK_TOOL_ITEM(citem->widget));
        if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (wid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMGETPROXYMENUITEM(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gchar *menu_item_id = _clip_parc(cm, 2);
        GtkWidget *wid ;
        C_widget *cwid ;

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKARG(2, CHARACTER_t);

        LOCALE_TO_UTF(menu_item_id);
        wid = gtk_tool_item_get_proxy_menu_item(GTK_TOOL_ITEM(citem->widget), menu_item_id);
        FREE_TEXT(menu_item_id);
        if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (wid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLITEMSETPROXYMENUITEM(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gchar *menu_item_id = _clip_parc(cm, 2);
        C_widget  *cwid = _fetch_cwidget(cm, _clip_spar(cm, 3));

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);
        CHECKCWID(cwid, GTK_IS_WIDGET);
        CHECKARG(2, CHARACTER_t);

        LOCALE_TO_UTF(menu_item_id);
        gtk_tool_item_set_proxy_menu_item(GTK_TOOL_ITEM(citem->widget),
        	menu_item_id,
        	GTK_WIDGET(cwid->widget));
        FREE_TEXT(menu_item_id);

	return 0;
err:
	return 1;
}
/******************************************************************************/
/************** SEPARATOR TOOL ITEM *******************************************/


int
clip_GTK_SEPARATORTOOLITEMNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkToolItem *item;
        C_widget *citem;

	CHECKOPT(1,MAP_t);
        item = gtk_separator_tool_item_new();
        if (!item) goto err;
	citem = _register_widget(cm, GTK_WIDGET(item), cv);
        _clip_mclone(cm,RETPTR(cm),&citem->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_SEPARATORTOOLITEMSETDRAW(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);
        gboolean    set = _clip_parl(cm, 2);

        CHECKCWID(citem, GTK_IS_SEPARATOR_TOOL_ITEM);
        CHECKOPT(2,LOGICAL_t);

        gtk_separator_tool_item_set_draw(GTK_SEPARATOR_TOOL_ITEM(citem->widget),
        	set);

	return 0;
err:
	return 1;
}

int
clip_GTK_SEPARATORTOOLITEMGETDRAW(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_SEPARATOR_TOOL_ITEM);

        _clip_retl(cm, gtk_separator_tool_item_get_draw(GTK_SEPARATOR_TOOL_ITEM(citem->widget)));

	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
int
clip_GTK_TOOLITEMREBUILDMENU(ClipMachine * cm)
{
	C_widget *citem = _fetch_cw_arg(cm);

        CHECKCWID(citem, GTK_IS_TOOL_ITEM);

        gtk_tool_item_rebuild_menu(GTK_TOOL_ITEM(citem->widget));

	return 0;
err:
	return 1;
}
#endif
