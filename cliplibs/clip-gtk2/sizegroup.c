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

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_size_group() { return GTK_TYPE_SIZE_GROUP; }

long _clip_type_size_group() { return GTK_OBJECT_SIZE_GROUP; }

const char * _clip_type_name_size_group()  { return "GTK_OBJECT_SIZE_GROUP"; }

/* Register  in global table */
int
clip_INIT___SIZEGROUP(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_size_group,  _clip_type_name_size_group,  _gtk_type_size_group,  _gtk_type_object, NULL);
	return 0;
}

/******************************************************************************
* gtk_SizeGroupNew(clipObj, nSizeGroupMode) --> new sizeGroup object
******************************************************************************/
int
clip_GTK_SIZEGROUPNEW(ClipMachine * cm)
{
        ClipVar           *cv = _clip_spar(cm, 1);
        GtkSizeGroupMode mode = _clip_parni(cm, 2);
        GtkSizeGroup   *group ;
        C_object      *cgroup ;

	CHECKOPT(1,MAP_t);
	CHECKARG(2, NUMERIC_t);

        group = gtk_size_group_new( mode );

	if (group)
        {
        	cgroup = _register_object(cm, group, GTK_TYPE_SIZE_GROUP, cv, NULL);
                if (cgroup) _clip_mclone(cm, RETPTR(cm), &cgroup->obj);
        }

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_SizeGroupSetMode(sizeGroupObj, nMode) --> NIL
******************************************************************************/
int
clip_GTK_SIZEGROUPSETMODE(ClipMachine * cm)
{
	C_object      *cgroup = _fetch_co_arg(cm);
        GtkSizeGroupMode mode = _clip_parni(cm, 2);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cgroup, GTK_IS_SIZE_GROUP(cgroup->object));
        CHECKARG(2, NUMERIC_t);

        gtk_size_group_set_mode(GTK_SIZE_GROUP(cgroup->object), mode );

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_SizeGroupGetMode(sizeGroupObj) --> nMode
******************************************************************************/
int
clip_GTK_SIZEGROUPGETMODE(ClipMachine * cm)
{
	C_object      *cgroup = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cgroup, GTK_IS_SIZE_GROUP(cgroup->object));

        _clip_retni(cm, gtk_size_group_get_mode(GTK_SIZE_GROUP(cgroup->object)));

	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_SizeGroupAddWidget(sizeGroupObj, widget) --> NIL
******************************************************************************/
int
clip_GTK_SIZEGROUPADDWIDGET(ClipMachine * cm)
{
	C_object      *cgroup = _fetch_co_arg(cm);
        C_widget        *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cgroup, GTK_IS_SIZE_GROUP(cgroup->object));
        CHECKARG2(2, MAP_t, NUMERIC_t); CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_size_group_add_widget(GTK_SIZE_GROUP(cgroup->object), GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_SizeGroupRemoveWidget(sizeGroupObj, widget) --> NIL
******************************************************************************/
int
clip_GTK_SIZEGROUPREMOVEWIDGET(ClipMachine * cm)
{
	C_object      *cgroup = _fetch_co_arg(cm);
        C_widget        *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cgroup, GTK_IS_SIZE_GROUP(cgroup->object));
        CHECKARG2(2, MAP_t, NUMERIC_t); CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_size_group_remove_widget(GTK_SIZE_GROUP(cgroup->object), GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}


