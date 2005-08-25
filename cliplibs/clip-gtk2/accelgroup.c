/*
    Copyright (C) 2003 - 2004  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
/****            Accelgroup has no signals              ****/
/**********************************************************/

/* Register menu item signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_accel_group()  { return GTK_TYPE_ACCEL_GROUP; }
long _clip_type_accel_group()  { return GTK_WIDGET_ACCEL_GROUP; }
const char * _clip_type_name_accel_group()  { return "GTK_WIDGET_ACCEL_GROUP"; }

int
clip_INIT___ACCEL_GROUP(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_accel_group, _clip_type_name_accel_group, _gtk_type_accel_group, _gtk_type_data, NULL);
	return 0;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
static gint
handle_changed_signal(GtkAccelMap *map, gchar *path, guint key, GdkModifierType type, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
        _clip_mputc(cs->co->cmachine, &cv, HASH_ACCEL_PATH, path, strlen(path));
        _clip_mputn(cs->co->cmachine, &cv, HASH_ACCEL_KEY, key);
        _clip_mputn(cs->co->cmachine, &cv, HASH_ACCEL_MODS, (int)type);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable accel_map_signals[] =
{
	{"changed",	GSF( handle_changed_signal ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};
CLIP_DLLEXPORT GtkType _gtk_type_accel_map()  { return GTK_TYPE_ACCEL_MAP; }
long _clip_type_accel_map()  { return GTK_OBJECT_ACCEL_MAP; }
const char * _clip_type_name_accel_map()  { return "GTK_OBJECT_ACCEL_MAP"; }

int
clip_INIT___ACCEL_MAP(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_accel_map, _clip_type_name_accel_map, _gtk_type_accel_map, NULL, accel_map_signals);
	return 0;
}
#endif
/**********************************************************/

/****  AccelGroup constructor ****/
int
clip_GTK_ACCELGROUPNEW(ClipMachine * cm)
{
	ClipVar * cv  = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = (GtkWidget *)gtk_accel_group_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/****  Locks the given accelerator group ****/
int
clip_GTK_ACCELGROUPLOCK(ClipMachine * cm)
{
	C_widget *caccelg = _fetch_cw_arg(cm);
        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP);

        gtk_accel_group_lock(GTK_ACCEL_GROUP(caccelg->widget));
	return 0;
err:
	return 1;
}


/****  Unlocks the given accelerator group ****/
int
clip_GTK_ACCELGROUPUNLOCK(ClipMachine * cm)
{
	C_widget *caccelg = _fetch_cw_arg(cm);
        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP);

        gtk_accel_group_unlock(GTK_ACCEL_GROUP(caccelg->widget));
	return 0;
err:
	return 1;
}

/* Installs an accelerator in this group. When accel_group is being activated */
/* in response to a call to gtk_accel_groups_activate(), closure will be      */
/* invoked if the accel_key and accel_mods from gtk_accel_groups_activate()   */
/* match those of this connection.                                            */

int
clip_GTK_ACCELGROUPCONNECT(ClipMachine * cm)
{
	C_widget *caccelg = _fetch_cw_arg(cm);
        guint   accel_key = _clip_parni(cm, 2);
        GdkModifierType accel_mods = _clip_parni(cm, 3);
        GtkAccelFlags accel_flags  = _clip_parni(cm, 4);
        C_object *cclosure = _fetch_cobject(cm, _clip_spar(cm, 5));
        GClosure *closure;

        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP); CHECKOPT2(1, MAP_t, NUMERIC_t);
        CHECKOPT(2, NUMERIC_t); CHECKOPT(3, NUMERIC_t); CHECKOPT(4, NUMERIC_t);

        closure = (GClosure *)(cclosure->object);
        gtk_accel_group_connect(GTK_ACCEL_GROUP(caccelg->widget), accel_key,
        			accel_mods, accel_flags, closure);
	return 0;
err:
	return 1;
}

/* Installs an accelerator in this group, using an accelerator path to look up */
/* the appropriate key and modifiers (see gtk_accel_map_add_entry()).          */
/* When accel_group is being activated in response to a call to                */
/* gtk_accel_groups_activate(), closure will be invoked if the accel_key and   */
/* accel_mods from gtk_accel_groups_activate() match the key and modifiers for */
/* the path.                                                                   */

int
clip_GTK_ACCELGROUPCONNECTBYPATH(ClipMachine * cm)
{
	C_widget *caccelg = _fetch_cw_arg(cm);
        const gchar *accel_path = _clip_parc(cm, 2);
        C_object *cclosure = _fetch_cobject(cm, _clip_spar(cm, 3));
        GClosure *closure;

        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP); CHECKOPT2(1, MAP_t, NUMERIC_t);
        CHECKOPT(2, CHARACTER_t);

        closure = (GClosure *)(cclosure->object);
        gtk_accel_group_connect_by_path(GTK_ACCEL_GROUP(caccelg->widget),
        			accel_path, closure);
	return 0;
err:
	return 1;
}


int
clip_GTK_ACCELGROUPDISCONNECT(ClipMachine * cm)
{
	C_widget *caccelg = _fetch_cw_arg(cm);
        C_object *cclosure = _fetch_cobject(cm, _clip_spar(cm, 2));
        GClosure *closure;

        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP); CHECKOPT2(1, MAP_t, NUMERIC_t);

        closure = (GClosure *)(cclosure->object);
        _clip_retl(cm, gtk_accel_group_disconnect(GTK_ACCEL_GROUP(caccelg->widget),
        			closure));
	return 0;
err:
	return 1;
}



int
clip_GTK_ACCELGROUPDISCONNECTKEY(ClipMachine * cm)
{
	C_widget *caccelg = _fetch_cw_arg(cm);
        guint   accel_key = _clip_parni(cm, 2);
        GdkModifierType mods = _clip_parni(cm, 3);

        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP); CHECKOPT2(1, MAP_t, NUMERIC_t);
        CHECKARG(2, NUMERIC_t); CHECKARG(3, NUMERIC_t);

        _clip_retl(cm, gtk_accel_group_disconnect_key(GTK_ACCEL_GROUP(caccelg->widget),
        			accel_key, mods));
	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELGROUPQUERY(ClipMachine * cm)
{
	C_widget *caccelg = _fetch_cw_arg(cm);
        guint   accel_key = _clip_parni(cm, 2);
        GdkModifierType mods = _clip_parni(cm, 3);
        guint   n_entries ;
        GtkAccelGroupEntry *entry ;

        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP); CHECKOPT2(1, MAP_t, NUMERIC_t);
        CHECKARG(2, NUMERIC_t); CHECKARG(3, NUMERIC_t);

        entry = gtk_accel_group_query(GTK_ACCEL_GROUP(caccelg->widget),
        			accel_key, mods, &n_entries);

	if (entry)
        {
        	ClipVar *cv = RETPTR(cm);
                long      n;

		n = n_entries;
                _clip_array(cm, cv, 1, &n);
                for (n=0; n<n_entries; n++)
                {
                	C_object *centry ;
                        centry = _register_object(cm, &entry[n], GTK_TYPE_ACCEL_GROUP_ENTRY, NULL, NULL);
                        if (centry) _clip_aset(cm, cv, &centry->obj, 1, &n);
                }
                _clip_storni(cm, n_entries, 4, 0);
        }

	return 0;
err:
	return 1;
}



int
clip_GTK_ACCELGROUPFROMACCELCLOSURE(ClipMachine * cm)
{
        C_object *cclosure = _fetch_co_arg(cm);
        GClosure *closure;
	C_widget  *caccelg ;
        GtkAccelGroup *accelg ;

        closure = (GClosure *)(cclosure->object);
        accelg = gtk_accel_group_from_accel_closure(closure);

	if (accelg)
        {
        	caccelg = _register_widget(cm, GTK_WIDGET(accelg), NULL);
                if (caccelg) _clip_mclone(cm, RETPTR(cm), &caccelg->obj);
        }
	return 0;
//err:
//	return 1;
}

int
clip_GTK_ACCELGROUPSACTIVATE(ClipMachine * cm)
{
        C_widget             *cobj = _fetch_cw_arg(cm);
        guint            accel_key = _clip_parni(cm, 2);
        GdkModifierType accel_mods = _clip_parni(cm, 3);

	CHECKCWID(cobj, GTK_IS_OBJECT);
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, NUMERIC_t);

        _clip_retl(cm, gtk_accel_groups_activate((GObject *)(cobj->widget),
        	accel_key, accel_mods));

	return 0;
err:
	return 1;
}


int
clip_GTK_ACCELGROUPSFROMOBJECT(ClipMachine * cm)
{
        C_widget     *cobj = _fetch_cw_arg(cm);
        GSList       *list ;

	CHECKCWID(cobj, GTK_IS_OBJECT);

        list = gtk_accel_groups_from_object((GObject *)(cobj->widget));
        if (list)
        {
		ClipVar *cv = RETPTR(cm);
		long      n = g_slist_length(list);

		_clip_array(cm, cv, 1, &n);
                for (n=0; list; list = g_slist_next(list))
                {
			C_widget     *caccelg ;
                        GtkAccelGroup *accelg ;

			accelg = list->data;
                        caccelg = _register_widget(cm, GTK_WIDGET(accelg), NULL);
                        if (caccelg) _clip_aset(cm, cv, &caccelg->obj, 1, &n);
                }
	}
	return 0;
err:
	return 1;
}


int
clip_GTK_ACCELERATORVALID(ClipMachine * cm)
{
        guint              keyval = _clip_parni(cm, 1);
        GdkModifierType modifiers = _clip_parni(cm, 2);

	CHECKARG(1, NUMERIC_t); CHECKARG(2, NUMERIC_t);

        _clip_retl(cm, gtk_accelerator_valid(keyval, modifiers));
	return 0;
err:
	return 1;
}


int
clip_GTK_ACCELERATORPARSE(ClipMachine * cm)
{
        gchar        *accelerator = _clip_parc(cm, 1);
        guint              keyval ;
        GdkModifierType modifiers ;

	CHECKARG(1, CHARACTER_t);

        gtk_accelerator_parse(accelerator, &keyval, &modifiers);

	_clip_storni(cm, keyval, 2, 0);
        _clip_storni(cm, modifiers, 3, 0);
	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELERATORNAME(ClipMachine * cm)
{
        guint              keyval = _clip_parni(cm, 1);
        GdkModifierType modifiers = _clip_parni(cm, 2);

	CHECKARG(1, NUMERIC_t); CHECKARG(2, NUMERIC_t);

        _clip_retc(cm, gtk_accelerator_name(keyval, modifiers));
	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELERATORSETDEFAULTMODMASK(ClipMachine * cm)
{
        GdkModifierType modifiers = _clip_parni(cm, 1);

	CHECKARG(1, NUMERIC_t);

        gtk_accelerator_set_default_mod_mask(modifiers);
	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELERATORGETDEFAULTMODMASK(ClipMachine * cm)
{

        _clip_retni(cm, (int)gtk_accelerator_get_default_mod_mask());
	return 0;
//err:
//	return 1;
}

/*******************************************************************************
*************************** Accelerator Maps
*******************************************************************************/

int
clip_GTK_ACCELMAPADDENTRY(ClipMachine * cm)
{
        gchar          *accel_path = _clip_parc(cm, 1);
        guint            accel_key = _clip_parni(cm, 2);
        GdkModifierType accel_mods = _clip_parni(cm, 3);

	CHECKARG(1, CHARACTER_t); CHECKARG(2, NUMERIC_t); CHECKARG(3, NUMERIC_t);

        gtk_accel_map_add_entry(accel_path, accel_key, accel_mods);

	return 0;
err:
	return 1;
}


int
clip_GTK_ACCELMAPLOOKUPENTRY(ClipMachine * cm)
{
        gchar          *accel_path = _clip_parc(cm, 1);
        ClipVar                *cv = _clip_spar(cm, 2);
        GtkAccelKey            key ;

	CHECKARG(1, CHARACTER_t); CHECKARG(2, MAP_t);

        _map_to_gtk_accel_key(cm, cv, &key);

        gtk_accel_map_lookup_entry(accel_path, &key);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELMAPCHANGEENTRY(ClipMachine * cm)
{
        gchar          *accel_path = _clip_parc(cm, 1);
        guint            accel_key = _clip_parni(cm, 2);
        GdkModifierType accel_mods = _clip_parni(cm, 3);
        gboolean           replace = BOOL_OPTION(cm, 4, 1);

	CHECKARG(1, CHARACTER_t); CHECKARG(2, NUMERIC_t); CHECKARG(3, NUMERIC_t);
        CHECKOPT(4, LOGICAL_t);

        _clip_retl(cm, gtk_accel_map_change_entry(accel_path, accel_key,
        	accel_mods, replace));

	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELMAPLOAD(ClipMachine * cm)
{
        gchar *file_name = _clip_parc(cm, 1);

	CHECKARG(1, CHARACTER_t);

        gtk_accel_map_load(file_name);

	return 0;
err:
	return 1;
}


int
clip_GTK_ACCELMAPSAVE(ClipMachine * cm)
{
        gchar *file_name = _clip_parc(cm, 1);

	CHECKARG(1, CHARACTER_t);

        gtk_accel_map_save(file_name);

	return 0;
err:
	return 1;
}


static void
_accel_map_foreach_func(gpointer data, const gchar *accel_path, guint accel_key, GdkModifierType accel_mods, gboolean changed)
{
	C_var *c = (C_var*)data;
	ClipVar stack[5];
	ClipVar res;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cw->cmachine, &stack[0], &c->cw->obj);
        _clip_var_str(accel_path, strlen(accel_path), &stack[1]);
        _clip_var_num((double)accel_key, &stack[2]);
        _clip_var_num((double)accel_mods, &stack[3]);
        _clip_var_log((int)changed, &stack[4]);

	_clip_eval( c->cm, &(c->cfunc), 5, stack, &res );
	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &stack[0]);
}

int
clip_GTK_ACCELMAPFOREACH(ClipMachine * cm)
{
        C_widget *cwid = _fetch_cw_arg(cm);
        ClipVar *cfunc = _clip_spar(cm, 2);
        C_var       *c ;

	CHECKOPT(1, MAP_t);
	CHECKARG2(2, PCODE_t, CCODE_t);

        c->cm = cm; c->cw = cwid;
        _clip_mclone(cm, &c->cfunc, cfunc);
        gtk_accel_map_foreach(c, (GtkAccelMapForeach)_accel_map_foreach_func);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELMAPLOADFD(ClipMachine * cm)
{
        gint fd = _clip_parni(cm, 1);

	CHECKARG(1, NUMERIC_t);

        gtk_accel_map_load_fd(fd);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELMAPSAVEFD(ClipMachine * cm)
{
        gint fd = _clip_parni(cm, 1);

	CHECKARG(1, NUMERIC_t);

        gtk_accel_map_save_fd(fd);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELMAPADDFILTER(ClipMachine * cm)
{
        gchar *filter_pattern = _clip_parc(cm, 1);

	CHECKARG(1, CHARACTER_t);

        gtk_accel_map_add_filter(filter_pattern);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELMAPFOREACHUNFILTERED(ClipMachine * cm)
{
        C_widget *cwid = _fetch_cw_arg(cm);
        ClipVar *cfunc = _clip_spar(cm, 2);
        C_var       *c ;

	CHECKOPT(1, MAP_t);
	CHECKARG2(2, PCODE_t, CCODE_t);

        c->cm = cm; c->cw = cwid;
        _clip_mclone(cm, &c->cfunc, cfunc);
        gtk_accel_map_foreach_unfiltered(c, (GtkAccelMapForeach)_accel_map_foreach_func);

	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)

int
clip_GTK_ACCELMAPGET(ClipMachine * cm)
{
        C_object   *cmap;
        GtkAccelMap *map;


        map = gtk_accel_map_get();
        if (map)
        {
        	cmap = _list_get_cobject(cm, map);
                if (!cmap) cmap = _register_object(cm, map, GTK_TYPE_ACCEL_MAP, NULL, NULL);
        	if (cmap) _clip_mclone(cm, RETPTR(cm), &cmap->obj);
        }
	return 0;
}

int
clip_GTK_ACCELMAPLOCKPATH(ClipMachine * cm)
{
	gchar * accel_path = _clip_parc(cm, 1);

	CHECKARG(1, CHARACTER_t);

        gtk_accel_map_lock_path(accel_path);

	return 0;
err:
	return 1;
}

int
clip_GTK_ACCELMAPUNLOCKPATH(ClipMachine * cm)
{
	gchar * accel_path = _clip_parc(cm, 1);

	CHECKARG(1, CHARACTER_t);

        gtk_accel_map_unlock_path(accel_path);

	return 0;
err:
	return 1;
}
#endif

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
int
clip_GTK_ACCELERATORGETLABEL(ClipMachine * cm)
{
	guint accelerator_key = _clip_parni(cm, 1);
	GdkModifierType  type = _clip_parni(cm, 2);
        gchar  *label ;

	CHECKARG(1, NUMERIC_t);
	CHECKARG(2, NUMERIC_t);

	label = gtk_accelerator_get_label(accelerator_key, type);

        LOCALE_FROM_UTF(label);
        _clip_retc(cm, label);
        FREE_TEXT(label);

	return 0;
err:
	return 1;
}
#endif

