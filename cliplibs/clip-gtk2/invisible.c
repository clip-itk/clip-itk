/*
    Copyright (C) 2004  ITK
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

/*  Invisible has no signals                              */

CLIP_DLLEXPORT GtkType _gtk_type_invisible() { return GTK_TYPE_INVISIBLE; }
long _clip_type_invisible() { return GTK_WIDGET_INVISIBLE; }
const char * _clip_type_name_invisible() { return "GTK_WIDGET_INVISIBLE"; }

int
clip_INIT___INVISIBLE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_invisible, _clip_type_name_invisible, _gtk_type_invisible,  _gtk_type_widget, NULL);
	return 0;
}
/**********************************************************/

int
clip_GTK_INVISIBLENEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_widget *cwid = NULL;
        GtkWidget *wid ;

	CHECKOPT(1,MAP_t);

	wid = gtk_invisible_new();
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 2)
int
clip_GTK_INVISIBLENEWFORSCREEN(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
        C_object *cscreen = _fetch_cobject(cm, _clip_spar(cm, 2));
	C_widget *cwid = NULL;
        GtkWidget *wid ;

	CHECKOPT(1,MAP_t);
        CHECKCOBJ(cscreen, GDK_IS_SCREEN(cscreen->object));

	wid = gtk_invisible_new_for_screen(GDK_SCREEN(cscreen->object));
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_INVISIBLESETSCREEN(ClipMachine * cm)
{
        C_widget *cinvis  = _fetch_cw_arg(cm);
        C_object *cscreen = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cinvis, GTK_IS_INVISIBLE);
        CHECKCOBJ(cscreen, GDK_IS_SCREEN(cscreen->object));

	gtk_invisible_set_screen(GTK_INVISIBLE(cinvis->widget), GDK_SCREEN(cscreen->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_INVISIBLEGETSCREEN(ClipMachine * cm)
{
        C_widget *cinvis  = _fetch_cw_arg(cm);
        GdkScreen *screen ;
        C_object *cscreen ;

	CHECKCWID(cinvis, GTK_IS_INVISIBLE);

	screen = gtk_invisible_get_screen(GTK_INVISIBLE(cinvis->widget));
        if (screen)
	{
        	cscreen = _list_get_cobject(cm, screen);
                if (!cscreen) cscreen = _register_object(cm, screen, GDK_TYPE_SCREEN, NULL, NULL);
                if (cscreen) _clip_mclone(cm, RETPTR(cm), &cscreen->obj);
        }
	return 0;
err:
	return 1;
}
#endif
