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

/* WindowGroup has no signals */

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_window_group() { return GTK_TYPE_WINDOW_GROUP; }

long _clip_type_window_group() { return GTK_OBJECT_WINDOW_GROUP; }

const char * _clip_type_name_window_group()  { return "GTK_OBJECT_WINDOW_GROUP"; }

int
clip_INIT___WINDOWGROUP(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_window_group,  _clip_type_name_window_group,  _gtk_type_window_group,  NULL, NULL);
	return 0;
}

/******************************************************************************
* gtk_WindowGroupNew( wGroupObj ) --> wGroupNewObject
******************************************************************************/
int
clip_GTK_WINDOWGROUPNEW(ClipMachine * cm)
{
        ClipVar           *cv = _clip_spar(cm, 1);
        C_object       *cwgrp ;
        GtkWindowGroup  *wgrp ;

	CHECKOPT(1,MAP_t);

	wgrp = gtk_window_group_new();

	if (wgrp)
	{
		cwgrp = _list_get_cobject(cm,wgrp);
		if (!cwgrp) cwgrp = _register_object(cm,wgrp,GTK_TYPE_WINDOW_GROUP,cv,NULL);
		if (cwgrp) _clip_mclone(cm,RETPTR(cm),&cwgrp->obj);
	}
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_WindowGroupAddWindow( wGroup, window ) --> NIL
******************************************************************************/
int
clip_GTK_WINDOWGROUPADDWINDOW(ClipMachine * cm)
{
        C_object       *cwgrp = _fetch_co_arg(cm);
        C_widget        *cwin = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKARG(1,MAP_t); CHECKCOBJ(cwgrp, GTK_IS_WINDOW_GROUP(cwgrp->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCWID(cwin, GTK_IS_WINDOW);

	gtk_window_group_add_window(GTK_WINDOW_GROUP(cwgrp->object),
		GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_WindowGroupRemoveWindow( wGroup, window ) --> NIL
******************************************************************************/
int
clip_GTK_WINDOWGROUPREMOVEWINDOW(ClipMachine * cm)
{
        C_object       *cwgrp = _fetch_co_arg(cm);
        C_widget        *cwin = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKARG(1,MAP_t); CHECKCOBJ(cwgrp, GTK_IS_WINDOW_GROUP(cwgrp->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCWID(cwin, GTK_IS_WINDOW);

	gtk_window_group_remove_window(GTK_WINDOW_GROUP(cwgrp->object),
		GTK_WINDOW(cwin->widget));

	return 0;
err:
	return 1;
}

