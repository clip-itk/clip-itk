
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
handle_actions_changed_signal(GtkUIManager *manager, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static gint
handle_add_widget_signal(GtkUIManager *manager, GtkWidget *wid, C_signal *cs)
{
	C_widget *cwid;
	OBJECTPREPARECV(cs,cv);
        cwid = _list_get_cwidget(cs->co->cmachine, wid);
        if (!cwid) cwid = _register_widget(cs->co->cmachine, wid, NULL);
        if (cwid) _clip_madd(cs->co->cmachine, &cv, HASH_WIDGET, &cwid->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static gint
handle_proxy_signal(GtkUIManager *manager, GtkAction *action, GtkWidget *wid, C_signal *cs)
{
	C_object *cact;
	C_widget *cwid;
	OBJECTPREPARECV(cs,cv);
        cact = _list_get_cobject(cs->co->cmachine, action);
        if (!cact) cact = _register_object(cs->co->cmachine, action, GTK_TYPE_ACTION, NULL, NULL);
        if (cact) _clip_madd(cs->co->cmachine, &cv, HASH_ACTION, &cact->obj);
        cwid = _list_get_cwidget(cs->co->cmachine, wid);
        if (!cwid) cwid = _register_widget(cs->co->cmachine, wid, NULL);
        if (cwid) _clip_madd(cs->co->cmachine, &cv, HASH_WIDGET, &cwid->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static gint
handle_activate_signal(GtkUIManager *manager, GtkAction *action, C_signal *cs)
{
	C_object *cact;
	OBJECTPREPARECV(cs,cv);
        cact = _list_get_cobject(cs->co->cmachine, action);
        if (!cact) cact = _register_object(cs->co->cmachine, action, GTK_TYPE_ACTION, NULL, NULL);
        if (cact) _clip_madd(cs->co->cmachine, &cv, HASH_ACTION, &cact->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable ui_manager_signals[] =
{
	{"actions-changed",	GSF( handle_actions_changed_signal ), ESF( object_emit_signal ), GTK_ACTIONS_CHANGED_SIGNAL},
	{"add-widget", 		GSF( handle_add_widget_signal ), ESF( object_emit_signal ), GTK_ADD_WIDGET_SIGNAL},
	{"connect-proxy",	GSF( handle_proxy_signal ), ESF( object_emit_signal ), GTK_CONNECT_PROXY_SIGNAL},
	{"disconnect-proxy",	GSF( handle_proxy_signal ), ESF( object_emit_signal ), GTK_DISCONNECT_PROXY_SIGNAL},
	{"post-activate",	GSF( handle_activate_signal ), ESF( object_emit_signal ), GTK_POST_ACTIVATE_SIGNAL},
	{"pre-activate",	GSF( handle_activate_signal ), ESF( object_emit_signal ), GTK_PRE_ACTIVATE_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_ui_manager() { return GTK_TYPE_UI_MANAGER; }

long _clip_type_ui_manager() { return GTK_OBJECT_UI_MANAGER; }

const char * _clip_type_name_ui_manager()  { return "GTK_OBJECT_UI_MANAGER"; }

int
clip_INIT___UIMANAGER(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_ui_manager,  _clip_type_name_ui_manager,  _gtk_type_ui_manager,  NULL, ui_manager_signals);
	return 0;
}

int
clip_GTK_UIMANAGERNEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        C_object *cmanager;
        GtkUIManager *manager;

	CHECKOPT(1,MAP_t);

	manager = gtk_ui_manager_new();

	if (manager)
	{
		cmanager = _list_get_cobject(cm,manager);
		if (!cmanager) cmanager = _register_object(cm,manager,GTK_TYPE_UI_MANAGER,cv,NULL);
		if (cmanager) _clip_mclone(cm,RETPTR(cm),&cmanager->obj);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERSETADDTEAROFFS(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        gboolean add_tearoffs = _clip_parl(cm, 2);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
        CHECKARG(2, LOGICAL_t);

	gtk_ui_manager_set_add_tearoffs(GTK_UI_MANAGER(cmanager->object), add_tearoffs);

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERGETADDTEAROFFS(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));

	_clip_retl(cm, gtk_ui_manager_get_add_tearoffs(GTK_UI_MANAGER(cmanager->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERINSERTACTIONGROUP(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        C_object *cgaction = _fetch_cobject(cm, _clip_spar(cm, 2));
        gint           pos = _clip_parni(cm, 3);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCOBJ(cgaction, GTK_IS_ACTION_GROUP(cgaction->object));
        CHECKARG(3, NUMERIC_t);

	if (pos > -1) pos --;

	gtk_ui_manager_insert_action_group(GTK_UI_MANAGER(cmanager->object),
		GTK_ACTION_GROUP(cgaction->object), pos);

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERREMOVEACTIONGROUP(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        C_object *cgaction = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCOBJ(cgaction, GTK_IS_ACTION_GROUP(cgaction->object));

	gtk_ui_manager_remove_action_group(GTK_UI_MANAGER(cmanager->object),
		GTK_ACTION_GROUP(cgaction->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERGETACTIONGROUPS(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        GList        *list ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));

	list = gtk_ui_manager_get_action_groups(GTK_UI_MANAGER(cmanager->object));

        if (list)
        {
		ClipVar *cv = RETPTR(cm);
		long      n = g_list_length(list);

		_clip_array(cm, cv, 1, &n);
                for (n=0; list; list = g_list_next(list))
                {
			C_object *cgaction ;
                        GtkActionGroup *gaction ;

			gaction = list->data;
                        cgaction = _list_get_cobject(cm, gaction);
                        if (!cgaction) cgaction = _register_object(cm, gaction, GTK_TYPE_ACTION_GROUP, NULL, NULL);
                        if (cgaction) _clip_aset(cm, cv, &cgaction->obj, 1, &n);
                }
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERGETACCELGROUP(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        GtkAccelGroup *agroup;
        C_widget     *cagroup;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));

	agroup = gtk_ui_manager_get_accel_group(GTK_UI_MANAGER(cmanager->object));

	if (agroup)
        {
                cagroup = _list_get_cwidget(cm, agroup);
                if (!cagroup) cagroup = _register_widget(cm, GTK_WIDGET(agroup), NULL);
                if (cagroup) _clip_mclone(cm, RETPTR(cm), &cagroup->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERGETWIDGET(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        gchar        *path = _clip_parc(cm, 2);
        GtkWidget     *wid;
        C_widget     *cwid;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
        CHECKARG(2, CHARACTER_t);

	wid = gtk_ui_manager_get_widget(GTK_UI_MANAGER(cmanager->object), path);

	if (wid)
        {
                cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERGETTOPLEVELS(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        GtkUIManagerItemType type = _clip_parni(cm, 2);
        GSList       *list ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
        CHECKARG(2, NUMERIC_t);

	list = gtk_ui_manager_get_toplevels(GTK_UI_MANAGER(cmanager->object), type);

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
clip_GTK_UIMANAGERGETACTION(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        gchar        *path = _clip_parc(cm, 2);
        GtkAction     *action;
        C_object     *caction;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
        CHECKARG(2, CHARACTER_t);

	action = gtk_ui_manager_get_action(GTK_UI_MANAGER(cmanager->object), path);

	if (action)
        {
                caction = _list_get_cobject(cm, action);
                if (!caction) caction = _register_object(cm, action, GTK_TYPE_ACTION, NULL, NULL);
                if (caction) _clip_mclone(cm, RETPTR(cm), &caction->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERADDUIFROMSTRING(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        gchar      *buffer = _clip_parc(cm, 2);
        gssize      length = _clip_parni(cm, 3);
        GError      *error ;
        guint          ret ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, NUMERIC_t);

	ret = gtk_ui_manager_add_ui_from_string(GTK_UI_MANAGER(cmanager->object),
		buffer, length, &error);
	_clip_retni(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERADDUIFROMFILE(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        gchar    *filename = _clip_parc(cm, 2);
        GError      *error ;
        guint          ret ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
        CHECKARG(2, CHARACTER_t);

	ret = gtk_ui_manager_add_ui_from_file(GTK_UI_MANAGER(cmanager->object),
		filename, &error);
	_clip_retni(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERNEWMERGEID(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        guint          ret ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));

	ret = gtk_ui_manager_new_merge_id(GTK_UI_MANAGER(cmanager->object));

	_clip_retni(cm, ret);

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERADDUI(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        guint     merge_id = _clip_parni(cm, 2);
        gchar        *path = _clip_parc(cm, 3);
        gchar        *name = _clip_parc(cm, 4);
        gchar      *action = _clip_parc(cm, 5);
        GtkUIManagerItemType type = _clip_parni(cm, 6);
        gboolean       top = _clip_parl(cm, 7);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, CHARACTER_t);
        CHECKARG(4, CHARACTER_t);
        CHECKARG(5, CHARACTER_t);
        CHECKARG(6, NUMERIC_t);
        CHECKARG(7, LOGICAL_t);


	gtk_ui_manager_add_ui(GTK_UI_MANAGER(cmanager->object),
		merge_id,
		path,
		name,
		action,
		type,
		top);

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERREMOVEUI(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);
        guint     merge_id = _clip_parni(cm, 2);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));
        CHECKARG(2, NUMERIC_t);


	gtk_ui_manager_remove_ui(GTK_UI_MANAGER(cmanager->object),
		merge_id);

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERGETUI(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));


	_clip_retc(cm, gtk_ui_manager_get_ui(GTK_UI_MANAGER(cmanager->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_UIMANAGERENSUREUPDATE(ClipMachine * cm)
{
        C_object *cmanager = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cmanager, GTK_IS_UI_MANAGER(cmanager->object));


	gtk_ui_manager_ensure_update(GTK_UI_MANAGER(cmanager->object));

	return 0;
err:
	return 1;
}

