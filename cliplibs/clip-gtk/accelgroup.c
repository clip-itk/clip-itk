/*
    Copyright (C) 2004  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/**********************************************************/
/****            Accelgroup has no signals              ****/
/**********************************************************/

/* Register menu item signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_accel_group()  { return GTK_TYPE_ACCEL_GROUP; }
long _clip_type_accel_group()  { return GTK_OBJECT_ACCEL_GROUP; }
const char * _clip_type_name_accel_group()  { return "GTK_WIDGET_ACCEL_GROUP"; }

int
clip_INIT___ACCEL_GROUP(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_accel_group, _clip_type_name_accel_group, _gtk_type_accel_group, NULL, NULL);
	return 0;
}
/**********************************************************/

/****  AccelGroup constructor ****/
int
clip_GTK_ACCELGROUPNEW(ClipMachine * cm)
{
	ClipVar * cv  = _clip_spar(cm, 1);
	GtkAccelGroup *accelg = NULL;
	C_object *cobj;
	CHECKOPT(1,MAP_t);

	accelg = gtk_accel_group_new();
	if (!accelg) goto err;
	cobj = _register_object(cm, accelg, GTK_TYPE_ACCEL_GROUP, cv, NULL);
	_clip_mclone(cm,RETPTR(cm),&cobj->obj);
	return 0;
err:
	return 1;
}

/****  Locks the given accelerator group ****/
int
clip_GTK_ACCELGROUPLOCK(ClipMachine * cm)
{
	C_object *caccelg = _fetch_co_arg(cm);
	CHECKCOBJ(caccelg,GTK_IS_ACCEL_GROUP(caccelg));

	gtk_accel_group_lock(GTK_ACCEL_GROUP(caccelg->object));
	return 0;
err:
	return 1;
}


/****  Unlocks the given accelerator group ****/
int
clip_GTK_ACCELGROUPUNLOCK(ClipMachine * cm)
{
	C_object *caccelg = _fetch_co_arg(cm);
	CHECKCOBJ(caccelg,GTK_IS_ACCEL_GROUP(caccelg));

	gtk_accel_group_unlock(GTK_ACCEL_GROUP(caccelg->object));
	return 0;
err:
	return 1;
}


