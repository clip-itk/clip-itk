/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/****            Menubar has no signals                ****/

/**********************************************************/

/* Register menu bar signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_menu_bar() { return GTK_TYPE_MENU_BAR; }
long _clip_type_menu_bar() { return GTK_WIDGET_MENU_BAR; }
const char * _clip_type_name_menu_bar() { return "GTK_WIDGET_MENU_BAR"; }

int
clip_INIT___MENU_BAR(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_menu_bar, _clip_type_name_menu_bar, _gtk_type_menu_bar, _gtk_type_menu_shell, NULL);
	return 0;
}
/**********************************************************/

/****  MENU BAR constructor ****/
int
clip_GTK_MENUBARNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_menu_bar_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/
int
clip_GTK_MENUBARAPPEND(ClipMachine * cm)
{
	C_widget *cmnb = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cmnb,GTK_IS_MENU_BAR);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_menu_bar_append(GTK_MENU_BAR(cmnb->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUBARPREPEND(ClipMachine * cm)
{
	C_widget *cmnb = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cmnb,GTK_IS_MENU_BAR);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_menu_bar_prepend(GTK_MENU_BAR(cmnb->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_MENUBARINSERT(ClipMachine * cm)
{
	C_widget *cmnb = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        int   position = _clip_parni(cm,3);
        CHECKCWID(cmnb,GTK_IS_MENU_BAR);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t);
        gtk_menu_bar_insert(GTK_MENU_BAR(cmnb->widget), cwid->widget, position);
	return 0;
err:
	return 1;
}

