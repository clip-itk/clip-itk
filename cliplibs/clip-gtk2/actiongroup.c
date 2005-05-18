
/*
    Copyright (C) 2004  ITK
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

/* Signals table */
static gint
handle_proxy_signal(GtkActionGroup *actiongr, GtkAction *action, GtkWidget *wid, C_signal *cs)
{
	C_object *caction;
        C_widget *cwid;
	OBJECTPREPARECV(cs,cv);
        caction = _list_get_cobject(cs->cw->cmachine, action);
        if (!caction) caction = _register_object(cs->cw->cmachine, action, GTK_TYPE_ACTION, NULL, NULL);
        _clip_madd(cs->cw->cmachine, &cv, HASH_ACTION, &caction->obj);

        cwid = _list_get_cwidget(cs->cw->cmachine, wid);
        if (!cwid) cwid = _register_widget(cs->cw->cmachine, wid, NULL);
        _clip_madd(cs->cw->cmachine, &cv, HASH_PROXY, &cwid->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static gint
handle_activate_signal(GtkActionGroup *actiongr, GtkAction *action, C_signal *cs)
{
	C_object *caction;
	OBJECTPREPARECV(cs,cv);
        caction = _list_get_cobject(cs->cw->cmachine, action);
        if (!caction) caction = _register_object(cs->cw->cmachine, action, GTK_TYPE_ACTION, NULL, NULL);
        _clip_madd(cs->cw->cmachine, &cv, HASH_ACTION, &caction->obj);

	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable action_group_signals[] =
{
	{"connect-proxy",	GSF( handle_proxy_signal ), ESF( object_emit_signal ), GTK_CONNECT_PROXY_SIGNAL},
	{"disconnect-proxy",	GSF( handle_proxy_signal ), ESF( object_emit_signal ), GTK_DISCONNECT_PROXY_SIGNAL},
	{"post-activate",	GSF( handle_activate_signal ), ESF( object_emit_signal ), GTK_POST_ACTIVATE_SIGNAL},
	{"pre-activate",	GSF( handle_activate_signal ), ESF( object_emit_signal ), GTK_PRE_ACTIVATE_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_action_group() { return GTK_TYPE_ACTION_GROUP; }

long _clip_type_action_group() { return GTK_OBJECT_ACTION_GROUP; }

const char * _clip_type_name_action_group()  { return "GTK_OBJECT_ACTION_GROUP"; }

int
clip_INIT___ACTIONGROUP(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_action_group,  _clip_type_name_action_group,  _gtk_type_action_group,  NULL, action_group_signals);
	return 0;
}

int
clip_GTK_ACTIONGROUPNEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        gchar      * name = _clip_parc(cm, 2);
        C_object *cagroup;
        GtkActionGroup *agroup;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);

	agroup = gtk_action_group_new(name);

	if (agroup)
	{
		cagroup = _list_get_cobject(cm,agroup);
		if (!cagroup) cagroup = _register_object(cm,agroup,GTK_TYPE_ACTION_GROUP,cv,NULL);
		if (cagroup) _clip_mclone(cm,RETPTR(cm),&cagroup->obj);
	}

	FREE_TEXT(name);
	return 0;
err:
	return 1;
}


int
clip_GTK_ACTIONGROUPGETNAME(ClipMachine * cm)
{
        C_object *cagroup   = _fetch_co_arg(cm);
        gchar    *name ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));

	name = (gchar *)gtk_action_group_get_name(GTK_ACTION_GROUP(cagroup->object));

	LOCALE_FROM_UTF(name);

        _clip_retc(cm, name);

        FREE_TEXT(name);
	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPGETSENSITIVE(ClipMachine * cm)
{
        C_object *cagroup   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));

	_clip_retl(cm, gtk_action_group_get_sensitive(GTK_ACTION_GROUP(cagroup->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPSETSENSITIVE(ClipMachine * cm)
{
        C_object *cagroup   = _fetch_co_arg(cm);
        gboolean sensitive  = _clip_parl(cm, 2);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
        CHECKARG(2, LOGICAL_t);

	gtk_action_group_set_sensitive(GTK_ACTION_GROUP(cagroup->object), sensitive);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPGETVISIBLE(ClipMachine * cm)
{
        C_object *cagroup   = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));

	_clip_retl(cm, gtk_action_group_get_visible(GTK_ACTION_GROUP(cagroup->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPSETVISIBLE(ClipMachine * cm)
{
        C_object *cagroup   = _fetch_co_arg(cm);
        gboolean visible    = _clip_parl(cm, 2);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
        CHECKARG(2, LOGICAL_t);

	gtk_action_group_set_visible(GTK_ACTION_GROUP(cagroup->object), visible);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPGETACTION(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        gchar       *name = _clip_parc(cm, 2);
        GtkAction *action ;
        C_object *caction ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	action = gtk_action_group_get_action(GTK_ACTION_GROUP(cagroup->object), name );

	if (action)
        {
        	caction = _list_get_cobject(cm, action);
                if (!caction) caction = _register_object(cm, action, GTK_TYPE_ACTION, NULL, NULL);
                if (caction) _clip_mclone(cm, RETPTR(cm), &caction->obj);
        }

	FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPLISTACTIONS(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        GList       *list ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));

	list = gtk_action_group_list_actions(GTK_ACTION_GROUP(cagroup->object));

        if (list)
        {
		ClipVar *cv = RETPTR(cm);
		long      n = g_list_length(list);

		_clip_array(cm, cv, 1, &n);
                for (n=0; list; list = g_list_next(list))
                {
			C_object *caction ;
                        GtkAction *action ;

			action = list->data;
                        caction = _list_get_cobject(cm, action);
                        if (!caction) caction = _register_object(cm, action, GTK_TYPE_ACTION, NULL, NULL);
                        if (caction) _clip_aset(cm, cv, &caction->obj, 1, &n);
                }
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPADDACTION(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        C_object *caction = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	gtk_action_group_add_action(GTK_ACTION_GROUP(cagroup->object),
        	GTK_ACTION(caction->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPADDACTIONWITHACCEL(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        C_object *caction = _fetch_cobject(cm, _clip_spar(cm, 2));
        gchar      *accel = _clip_parc(cm, 3);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));
        CHECKARG(3, CHARACTER_t);

	LOCALE_TO_UTF(accel);
	gtk_action_group_add_action_with_accel(GTK_ACTION_GROUP(cagroup->object),
        	GTK_ACTION(caction->object), accel);

	FREE_TEXT(accel);
	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPREMOVEACTION(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        C_object *caction = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_ACTION(caction->object));

	gtk_action_group_remove_action(GTK_ACTION_GROUP(cagroup->object),
        	GTK_ACTION(caction->object));

	return 0;
err:
	return 1;
}

static void destroy_d(gpointer data)
{
	C_var *c = (C_var *)data;
	ClipVar stack[1];
	ClipVar res;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cm, &stack[0], &c->co->obj);
	_clip_eval( c->cm, &c->cfunc2, 1, stack, &res );

	_clip_destroy(c->cm, &res);

	_clip_destroy(c->cm, &stack[0]);
}

int
clip_GTK_ACTIONGROUPADDACTIONS(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        ClipArrVar  *carr = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        guint   n_actions = _clip_parni(cm, 3);
        C_var *c = NEW(C_var);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);

	if (carr)
        {
        	GtkActionEntry *acts;
                gint i;

                acts = malloc(carr->count*sizeof(GtkActionEntry));
                memset(acts, 0, sizeof(GtkActionEntry)*carr->count);
                for (i=0; i<n_actions; i++)
                	_map_to_action_entry(cm, &carr->items[i], &acts[i]);

		c->cm = cm;
		gtk_action_group_add_actions(GTK_ACTION_GROUP(cagroup->object),
                	acts,
                        n_actions,
                        c);
		free(acts);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPADDACTIONSFULL(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        ClipArrVar  *carr = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        guint   n_actions = _clip_parni(cm, 3);
        ClipVar    *cfunc = _clip_spar(cm, 4);
        C_var *c = NEW(C_var);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);
        CHECKARG2(4, PCODE_t, CCODE_t);

	if (carr)
        {
        	GtkActionEntry *acts;
                gint i;

                acts = malloc(carr->count*sizeof(GtkActionEntry));
                memset(acts, 0, sizeof(GtkActionEntry)*carr->count);
                for (i=0; i<n_actions; i++)
                	_map_to_action_entry(cm, &carr->items[i], &acts[i]);

		c->cm = cm; c->co = cagroup; _clip_mclone(cm, &c->cfunc, cfunc);
		gtk_action_group_add_actions_full(GTK_ACTION_GROUP(cagroup->object),
                	acts,
                        n_actions,
                        c,
                        (GDestroyNotify)destroy_d);
		free(acts);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPADDTOGGLEACTIONS(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        ClipArrVar  *carr = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        guint   n_actions = _clip_parni(cm, 3);
        C_var *c = NEW(C_var);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);

	if (carr)
        {
        	GtkToggleActionEntry *acts;
                gint i;

                acts = malloc(carr->count*sizeof(GtkToggleActionEntry));
                memset(acts, 0, sizeof(GtkToggleActionEntry)*carr->count);
                for (i=0; i<n_actions; i++)
                	_map_to_toggle_action_entry(cm, &carr->items[i], &acts[i]);

		c->cm = cm;
		gtk_action_group_add_toggle_actions(GTK_ACTION_GROUP(cagroup->object),
                	acts,
                        n_actions,
                        c);
		free(acts);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPADDTOGGLEACTIONSFULL(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        ClipArrVar  *carr = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        guint   n_actions = _clip_parni(cm, 3);
        ClipVar    *cfunc = _clip_spar(cm, 4);
        C_var *c = NEW(C_var);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);
        CHECKARG2(4, PCODE_t, CCODE_t);

	if (carr)
        {
        	GtkToggleActionEntry *acts;
                gint i;

                acts = malloc(carr->count*sizeof(GtkToggleActionEntry));
                memset(acts, 0, sizeof(GtkToggleActionEntry)*carr->count);
                for (i=0; i<n_actions; i++)
                	_map_to_toggle_action_entry(cm, &carr->items[i], &acts[i]);

		c->cm = cm; c->co = cagroup; _clip_mclone(cm, &c->cfunc2, cfunc);
		gtk_action_group_add_toggle_actions_full(GTK_ACTION_GROUP(cagroup->object),
                	acts,
                        n_actions,
                        c,
                        (GDestroyNotify)destroy_d);
		free(acts);
	}

	return 0;
err:
	return 1;
}

static void
call_b(gpointer data)
{
	C_var *c = (C_var *)data;
	ClipVar stack[1];
	ClipVar res;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cm, &stack[0], &c->co->obj);
	_clip_eval( c->cm, &c->cfunc, 1, stack, &res );

	_clip_destroy(c->cm, &res);

	_clip_destroy(c->cm, &stack[0]);
}

int
clip_GTK_ACTIONGROUPADDRADIOACTIONS(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        ClipArrVar  *carr = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        guint   n_actions = _clip_parni(cm, 3);
        gint        value = _clip_parni(cm, 4);
        ClipVar    *cfunc = _clip_spar(cm, 5);
        C_var *c = NEW(C_var);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);
        CHECKARG2(5, PCODE_t, CCODE_t);

	if (carr)
        {
        	GtkRadioActionEntry *acts;
                gint i;

                acts = malloc(carr->count*sizeof(GtkRadioActionEntry));
                memset(acts, 0, sizeof(GtkRadioActionEntry)*carr->count);
                for (i=0; i<n_actions; i++)
                	_map_to_radio_action_entry(cm, &carr->items[i], &acts[i]);

		c->cm = cm; c->co = cagroup; _clip_mclone(cm, &c->cfunc, cfunc);
		gtk_action_group_add_radio_actions(GTK_ACTION_GROUP(cagroup->object),
                	acts,
                        n_actions,
                        value,
                        (GCallback)call_b,
                        c);
		free(acts);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPADDRADIOACTIONSFULL(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        ClipArrVar  *carr = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        guint   n_actions = _clip_parni(cm, 3);
        gint        value = _clip_parni(cm, 4);
        ClipVar    *cfunc = _clip_spar(cm, 5);
        ClipVar   *cfunc2 = _clip_spar(cm, 6);
        C_var *c = NEW(C_var);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
	CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);
        CHECKARG2(5, PCODE_t, CCODE_t);
        CHECKARG2(6, PCODE_t, CCODE_t);

	if (carr)
        {
        	GtkRadioActionEntry *acts;
                gint i;

                acts = malloc(carr->count*sizeof(GtkRadioActionEntry));
                memset(acts, 0, sizeof(GtkRadioActionEntry)*carr->count);
                for (i=0; i<n_actions; i++)
                	_map_to_radio_action_entry(cm, &carr->items[i], &acts[i]);

		c->cm = cm; c->co = cagroup; _clip_mclone(cm, &c->cfunc, cfunc);
                _clip_mclone(cm, &c->cfunc2, cfunc2);
		gtk_action_group_add_radio_actions_full(GTK_ACTION_GROUP(cagroup->object),
                	acts,
                        n_actions,
                        value,
                        (GCallback)call_b,
                        c,
                        (GDestroyNotify)destroy_d);
		free(acts);
	}

	return 0;
err:
	return 1;
}

static gchar*
translate_func(const gchar *path, gpointer data)
{
	C_var *c = (C_var *)data;
	ClipVar stack[2];
        ClipVar str;
	ClipVar res;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cm, &stack[0], &c->co->obj);
	_clip_var_str(path, strlen(path), &str);
	_clip_mclone(c->cm, &stack[1], &str);
	_clip_eval( c->cm, &c->cfunc, 2, stack, &res );

	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &str);

	_clip_destroy(c->cm, &stack[0]);

        if (res.t.type == CHARACTER_t)
        	return res.s.str.buf;
        else
        	return NULL;

}

static void
destroy_notify(gpointer data)
{
	C_var *c = (C_var *)data;
	ClipVar stack[1];
	ClipVar res;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cm, &stack[0], &c->co->obj);
	_clip_eval( c->cm, &c->cfunc, 1, stack, &res );

	_clip_destroy(c->cm, &res);

	_clip_destroy(c->cm, &stack[0]);
}

int
clip_GTK_ACTIONGROUPSETTRANSLATEFUNC(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        ClipVar    *cfunc = _clip_spar(cm, 2);
        ClipVar   *cfunc2 = _clip_spar(cm, 3);
        C_var *c = NEW(C_var);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
        CHECKARG2(2, PCODE_t, CCODE_t);
        CHECKARG2(3, PCODE_t, CCODE_t);

	c->cm = cm; c->co = cagroup; _clip_mclone(cm, &c->cfunc, cfunc);
        _clip_mclone(cm, &c->cfunc2, cfunc2);
	gtk_action_group_set_translate_func(GTK_ACTION_GROUP(cagroup->object),
                (GtkTranslateFunc)translate_func,
                c,
                (GtkDestroyNotify)destroy_notify);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACTIONGROUPSETTRANSLATIONDOMAIN(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        gchar     *domain = _clip_parc(cm, 2);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
        CHECKARG(2, CHARACTER_t);

	gtk_action_group_set_translation_domain(GTK_ACTION_GROUP(cagroup->object),
                domain);

	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
int
clip_GTK_ACTIONGROUPTRANSLATESTRING(ClipMachine * cm)
{
        C_object *cagroup = _fetch_co_arg(cm);
        gchar     *string = _clip_parc(cm, 2);
        gchar     *resstr ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cagroup, GTK_IS_ACTION_GROUP(cagroup->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(string);
	resstr = (gchar *)gtk_action_group_translate_string(GTK_ACTION_GROUP(cagroup->object),
                string);
	LOCALE_FROM_UTF(resstr);
        _clip_retc(cm, resstr);

	FREE_TEXT(string);
        FREE_TEXT(resstr);

	return 0;
err:
	return 1;
}

#endif
