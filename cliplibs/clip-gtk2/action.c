
/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <string.h>
#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/* Signals table */
static gint
handle_activate_signal(GtkAction *action, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable action_signals[] =
{
	{"activate",	GSF( handle_activate_signal ), ESF( object_emit_signal ), GTK_ACTIVATE_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_action() { return GTK_TYPE_ACTION; }

long _clip_type_action() { return GTK_OBJECT_ACTION; }

const char * _clip_type_name_action()  { return "GTK_OBJECT_ACTION"; }

int
clip_INIT___ACTION(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_action,  _clip_type_name_action,  _gtk_type_action,  NULL, action_signals);
	return 0;
}

int
clip_GTK_ACTIONNEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        gchar      * name = _clip_parc(cm, 2);
        gchar     * label = _clip_parc(cm, 3);
        gchar   * tooltip = _clip_parc(cm, 4);
        gchar  * stock_id = _clip_parc(cm, 5);
        C_object *caction;
        GtkAction *action;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, CHARACTER_t);
        CHECKOPT(4, CHARACTER_t);
        CHECKOPT(5, CHARACTER_t);

	LOCALE_TO_UTF(name);
	LOCALE_TO_UTF(label);
        if (tooltip) LOCALE_TO_UTF(tooltip);
        if (stock_id) LOCALE_TO_UTF(stock_id);

	action = gtk_action_new(name, label, tooltip, stock_id);

	if (action)
	{
		caction = _list_get_cobject(cm,action);
		if (!caction) caction = _register_object(cm,action,GTK_TYPE_ACTION,cv,NULL);
		if (caction) _clip_mclone(cm,RETPTR(cm),&caction->obj);
	}

	FREE_TEXT(name);
	FREE_TEXT(label);
	if (tooltip) FREE_TEXT(tooltip);
	if (stock_id) FREE_TEXT(stock_id);
	return 0;
err:
	return 1;
}


int
clip_GTK_ACTIONGETNAME(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        gchar    *name ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	name = (gchar *)gtk_action_get_name(GTK_ACTION(caction->object));

	LOCALE_FROM_UTF(name);

        _clip_retc(cm, name);

        FREE_TEXT(name);
	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONISSENSITIVE(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	_clip_retl(cm, gtk_action_is_sensitive(GTK_ACTION(caction->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGETSENSITIVE(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	_clip_retl(cm, gtk_action_get_sensitive(GTK_ACTION(caction->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONISVISIBLE(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	_clip_retl(cm, gtk_action_is_visible(GTK_ACTION(caction->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGETVISIBLE(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	_clip_retl(cm, gtk_action_get_visible(GTK_ACTION(caction->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONACTIVATE(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	gtk_action_activate(GTK_ACTION(caction->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONCREATEICON(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        GtkIconSize    size = _clip_parni(cm, 2);
        GtkWidget *wid;
        C_widget *cwid;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));
        CHECKARG(2, NUMERIC_t);

	wid = gtk_action_create_icon(GTK_ACTION(caction->object), size);

	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (cwid)  _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }


	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONCREATEMENUITEM(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        GtkWidget *wid;
        C_widget *cwid;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	wid = gtk_action_create_menu_item(GTK_ACTION(caction->object));

	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (cwid)  _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }


	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONCREATETOOLITEM(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        GtkWidget *wid;
        C_widget *cwid;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	wid = gtk_action_create_tool_item(GTK_ACTION(caction->object));

	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (cwid)  _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }


	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONCONNECTPROXY(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        C_widget    *cwid   = _fetch_cwidget(cm, _clip_spar(cm, 2));;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCWID(cwid, GTK_IS_WIDGET);

	gtk_action_connect_proxy(GTK_ACTION(caction->object), GTK_WIDGET(cwid->widget));



	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONDISCONNECTPROXY(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        C_widget    *cwid   = _fetch_cwidget(cm, _clip_spar(cm, 2));;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCWID(cwid, GTK_IS_WIDGET);

	gtk_action_disconnect_proxy(GTK_ACTION(caction->object), GTK_WIDGET(cwid->widget));



	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGETPROXIES(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        GSList *list;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	list = gtk_action_get_proxies(GTK_ACTION(caction->object));

        if (list)
        {
		ClipVar *cv = RETPTR(cm);
		long      n = g_slist_length(list);

		_clip_array(cm, cv, 1, &n);
                for (n=0; list; list = g_slist_next(list))
                {
			C_widget *cwid ;
                        GtkWidget *wid ;

			wid = list->data;
                        cwid = _list_get_cwidget(cm, wid);
                        if (!cwid) cwid = _register_widget(cm, wid, NULL);
                        if (cwid) _clip_aset(cm, cv, &cwid->obj, 1, &n);
                }
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONCONNECTACCELERATOR(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	gtk_action_connect_accelerator(GTK_ACTION(caction->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONDISCONNECTACCELERATOR(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	gtk_action_disconnect_accelerator(GTK_ACTION(caction->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONBLOCKACTIVATEFROM(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        C_widget  *cproxy   = _fetch_cwidget(cm, _clip_spar(cm, 2));;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCWID(cproxy, GTK_IS_WIDGET);

	gtk_action_block_activate_from(GTK_ACTION(caction->object),
		GTK_WIDGET(cproxy->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONUNBLOCKACTIVATEFROM(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        C_widget  *cproxy   = _fetch_cwidget(cm, _clip_spar(cm, 2));;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCWID(cproxy, GTK_IS_WIDGET);

	gtk_action_unblock_activate_from(GTK_ACTION(caction->object),
		GTK_WIDGET(cproxy->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONSETACCELPATH(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        gchar * accel_path  = _clip_parc(cm, 2);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));
	CHECKARG(2,CHARACTER_t);

	gtk_action_set_accel_path(GTK_ACTION(caction->object), accel_path);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONSETACCELGROUP(ClipMachine * cm)
{
        C_object *caction   = _fetch_co_arg(cm);
        C_widget *cagroup   = _fetch_cwidget(cm, _clip_spar(cm, 2));;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCWID(cagroup, GTK_IS_ACCEL_GROUP);

	gtk_action_set_accel_group(GTK_ACTION(caction->object),
		GTK_ACCEL_GROUP(cagroup->widget));

	return 0;
err:
	return 1;
}

