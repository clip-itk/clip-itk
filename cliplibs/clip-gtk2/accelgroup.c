/*
    Copyright (C) 2001  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
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
        GClosure *closure;

        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP); CHECKOPT2(1, MAP_t, NUMERIC_t);
        CHECKOPT(2, NUMERIC_t); CHECKOPT(3, NUMERIC_t); CHECKOPT(4, NUMERIC_t);

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
        GClosure *closure;

        CHECKCWID(caccelg,GTK_IS_ACCEL_GROUP); CHECKOPT2(1, MAP_t, NUMERIC_t);
        CHECKOPT(2, CHARACTER_t);

        gtk_accel_group_connect_by_path(GTK_ACCEL_GROUP(caccelg->widget),
        			accel_path, closure);
	return 0;
err:
	return 1;
}


