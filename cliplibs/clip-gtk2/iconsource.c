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


/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_icon_source() { return GTK_TYPE_ICON_SOURCE; }

long _clip_type_icon_source() { return GTK_OBJECT_ICON_SOURCE; }

const char * _clip_type_name_icon_source()  { return "GTK_OBJECT_ICON_SOURCE"; }

/* Register in global table */
int
clip_INIT___ICONSOURCE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_icon_source,  _clip_type_name_icon_source,  _gtk_type_icon_source,  NULL, NULL);
	return 0;
}

int
clip_GTK_ICONSOURCENEW(ClipMachine * cm)
{
	ClipVar *cv   = _clip_spar(cm,1);
        GtkIconSource  *isrc;
        C_object      *cisrc;

	CHECKOPT(1, MAP_t);
        CHECKARG(2, NUMERIC_t);

	isrc = gtk_icon_source_new();

	if (isrc)
        {
        	cisrc = _list_get_cobject(cm, isrc);
                if (!cisrc) cisrc = _register_object(cm, isrc, GTK_TYPE_ICON_SOURCE, cv, NULL);
                if (cisrc) _clip_mclone(cm, RETPTR(cm), &cisrc->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCECOPY(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);
        GtkIconSource  *isrc;

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	isrc = gtk_icon_source_copy(GTK_ICON_SOURCE(cisrc->object));

	if (isrc)
        {
        	cisrc = _list_get_cobject(cm, isrc);
                if (!cisrc) cisrc = _register_object(cm, isrc, GTK_TYPE_ICON_SOURCE, NULL, NULL);
                if (cisrc) _clip_mclone(cm, RETPTR(cm), &cisrc->obj);
        }
	return 0;
err:
	return 1;
}


int
clip_GTK_ICONSOURCEFREE(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	gtk_icon_source_free(GTK_ICON_SOURCE(cisrc->object));

	return 0;
err:
	return 1;
}


int
clip_GTK_ICONSOURCEGETDIRECTION(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	_clip_retni(cm, (int)gtk_icon_source_get_direction(GTK_ICON_SOURCE(cisrc->object)));

	return 0;
err:
	return 1;
}


int
clip_GTK_ICONSOURCEGETDIRECTIONWILDCARDED(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	_clip_retl(cm, gtk_icon_source_get_direction_wildcarded(GTK_ICON_SOURCE(cisrc->object)));

	return 0;
err:
	return 1;
}


int
clip_GTK_ICONSOURCEGETFILENAME(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	_clip_retc(cm, (gchar *)gtk_icon_source_get_filename(GTK_ICON_SOURCE(cisrc->object)));

	return 0;
err:
	return 1;
}


int
clip_GTK_ICONSOURCEGETPIXBUF(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);
        GdkPixbuf    *pixbuf ;
        C_object    *cpixbuf ;

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	pixbuf = gtk_icon_source_get_pixbuf(GTK_ICON_SOURCE(cisrc->object));

	if (pixbuf)
        {
        	cpixbuf = _list_get_cobject(cm, pixbuf);
                if (!cpixbuf) cpixbuf = _register_object(cm, pixbuf, GDK_TYPE_PIXBUF, NULL, NULL);
                if (cpixbuf) _clip_mclone(cm, RETPTR(cm), &cpixbuf->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCEGETSIZE(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	_clip_retni(cm, (int)gtk_icon_source_get_size(GTK_ICON_SOURCE(cisrc->object)));

	return 0;
err:
	return 1;
}


int
clip_GTK_ICONSOURCEGETSIZEWILDCARDED(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	_clip_retl(cm, gtk_icon_source_get_size_wildcarded(GTK_ICON_SOURCE(cisrc->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCEGETSTATE(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	_clip_retni(cm, (int)gtk_icon_source_get_state(GTK_ICON_SOURCE(cisrc->object)));

	return 0;
err:
	return 1;
}


int
clip_GTK_ICONSOURCEGETSTATEWILDCARDED(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));

	_clip_retl(cm, gtk_icon_source_get_state_wildcarded(GTK_ICON_SOURCE(cisrc->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCESETDIRECTION(ClipMachine * cm)
{
        C_object      *cisrc = _fetch_co_arg(cm);
        GtkTextDirection direction = _clip_parni(cm, 2);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));
        CHECKARG(2, NUMERIC_t);

	gtk_icon_source_set_direction(GTK_ICON_SOURCE(cisrc->object), direction);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCESETDIRECTIONWILDCARDED(ClipMachine * cm)
{
        C_object  *cisrc = _fetch_co_arg(cm);
        gboolean setting = _clip_parl(cm, 2);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));
        CHECKARG(2, LOGICAL_t);

	gtk_icon_source_set_direction_wildcarded(GTK_ICON_SOURCE(cisrc->object), setting);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCESETFILENAME(ClipMachine * cm)
{
        C_object *cisrc = _fetch_co_arg(cm);
        gchar *filename = _clip_parc(cm, 2);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));
        CHECKARG(2, CHARACTER_t);

	gtk_icon_source_set_filename(GTK_ICON_SOURCE(cisrc->object), filename);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCESETPIXBUF(ClipMachine * cm)
{
        C_object   *cisrc = _fetch_co_arg(cm);
        C_object *cpixbuf = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));
	CHECKARG(2, MAP_t); CHECKCOBJ(cpixbuf, GDK_IS_PIXBUF(cpixbuf));

	gtk_icon_source_set_pixbuf(GTK_ICON_SOURCE(cisrc->object), GDK_PIXBUF(cpixbuf->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCESETSIZE(ClipMachine * cm)
{
        C_object    *cisrc = _fetch_co_arg(cm);
        GtkIconSize   size = _clip_parni(cm, 2);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));
        CHECKARG(2, NUMERIC_t);

	gtk_icon_source_set_size(GTK_ICON_SOURCE(cisrc->object), size);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCESETSIZEWILDCARDED(ClipMachine * cm)
{
        C_object  *cisrc = _fetch_co_arg(cm);
        gboolean setting = _clip_parl(cm, 2);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));
        CHECKARG(2, LOGICAL_t);

	gtk_icon_source_set_size_wildcarded(GTK_ICON_SOURCE(cisrc->object), setting);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCESETSTATE(ClipMachine * cm)
{
        C_object    *cisrc = _fetch_co_arg(cm);
        GtkStateType  type = _clip_parni(cm, 2);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));
        CHECKARG(2, NUMERIC_t);

	gtk_icon_source_set_state(GTK_ICON_SOURCE(cisrc->object), type);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONSOURCESETSTATEWILDCARDED(ClipMachine * cm)
{
        C_object  *cisrc = _fetch_co_arg(cm);
        gboolean setting = _clip_parl(cm, 2);

	CHECKARG(1, MAP_t); CHECKCOBJ(cisrc, GTK_IS_ICON_SOURCE(cisrc));
        CHECKARG(2, LOGICAL_t);

	gtk_icon_source_set_state_wildcarded(GTK_ICON_SOURCE(cisrc->object), setting);

	return 0;
err:
	return 1;
}

