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
handle_changed_signal(GtkIconTheme *icon, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable icon_theme_signals[] =
{
	{"changed",	GSF( handle_changed_signal ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_icon_theme() { return GTK_TYPE_ICON_THEME; }

long _clip_type_icon_theme() { return GTK_OBJECT_ICON_THEME; }

const char * _clip_type_name_icon_theme()  { return "GTK_OBJECT_ICON_THEME"; }

int
clip_INIT___ICONTHEME(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_icon_theme,  _clip_type_name_icon_theme,  _gtk_type_icon_theme,  NULL, icon_theme_signals);
	return 0;
}

int
clip_GTK_ICONTHEMENEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        C_object *cicon;
        GtkIconTheme *icon;

	CHECKOPT(1,MAP_t);

	icon = gtk_icon_theme_new();

	if (icon)
	{
		cicon = _list_get_cobject(cm,icon);
		if (!cicon) cicon = _register_object(cm,icon,GTK_TYPE_ICON_THEME,cv,NULL);
		if (cicon) _clip_mclone(cm,RETPTR(cm),&cicon->obj);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMEGETDEFAULT(ClipMachine * cm)
{
        C_object *cicon;
        GtkIconTheme *icon;

	icon = gtk_icon_theme_get_default();

	if (icon)
	{
		cicon = _list_get_cobject(cm,icon);
		if (!cicon) cicon = _register_object(cm,icon,GTK_TYPE_ICON_THEME,NULL,NULL);
		if (cicon) _clip_mclone(cm,RETPTR(cm),&cicon->obj);
	}

	return 0;
}

int
clip_GTK_ICONTHEMEGETFORSCREEN(ClipMachine * cm)
{
        C_object *cscreen = _fetch_co_arg(cm);
        C_object *cicon;
        GtkIconTheme *icon;

	CHECKCOBJ(cscreen, GDK_IS_SCREEN(cscreen->object));

	icon = gtk_icon_theme_get_for_screen(GDK_SCREEN(cscreen->object));

	if (icon)
	{
		cicon = _list_get_cobject(cm,icon);
		if (!cicon) cicon = _register_object(cm,icon,GTK_TYPE_ICON_THEME,NULL,NULL);
		if (cicon) _clip_mclone(cm,RETPTR(cm),&cicon->obj);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMESETSCREEN(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        C_object *cscreen = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
	CHECKCOBJ(cscreen, GDK_IS_SCREEN(cscreen->object));

	gtk_icon_theme_set_screen(GTK_ICON_THEME(cicon->object),
		GDK_SCREEN(cscreen->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMESETSEARCHPATH(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        ClipArrVar  *cv   = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        gint n_elements   = _clip_parni(cm, 3);
        gint          i;

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
	CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);

	i = cv->count;
        n_elements = (i<n_elements)?i:n_elements;
	if (cv)
        {
		const gchar *path[n_elements];
                ClipVar *s;
		for (i=0; i<n_elements; i++)
                {
                	s = &cv->items[i];
                	path[i] = s->s.str.buf;
		}
		gtk_icon_theme_set_search_path(GTK_ICON_THEME(cicon->object),
			path, n_elements);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMEGETSEARCHPATH(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        ClipVar     *cv   = RETPTR(cm) ;
	gchar    **path   ;
        gint n_elements   ;
        long          i   ;

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));

	gtk_icon_theme_get_search_path(GTK_ICON_THEME(cicon->object),
		&path, &n_elements);
	i = n_elements;
	_clip_array(cm, cv, 1, &i);
        for(i=0; i<n_elements; i++)
        {
        	ClipVar c;
                _clip_var_str(path[i], strlen(path[i]), &c);
                _clip_aset(cm, cv, &c, 1, &i);
                _clip_destroy(cm, &c);
        }
        g_strfreev(path);
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMEAPPENDSEARCHPATH(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        gchar     *path   = _clip_parc(cm, 2);

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
        CHECKARG(2, CHARACTER_t);

	gtk_icon_theme_append_search_path(GTK_ICON_THEME(cicon->object),
			path);
	return 0;
err:
	return 1;
}


int
clip_GTK_ICONTHEMEPREPENDSEARCHPATH(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        gchar     *path   = _clip_parc(cm, 2);

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
        CHECKARG(2, CHARACTER_t);

	gtk_icon_theme_prepend_search_path(GTK_ICON_THEME(cicon->object),
			path);
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMESETCUSTOMTHEME(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        gchar     *name   = _clip_parc(cm, 2);

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
        CHECKARG(2, CHARACTER_t);

	gtk_icon_theme_set_custom_theme(GTK_ICON_THEME(cicon->object),
			name);
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMEHASICON(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        gchar     *name   = _clip_parc(cm, 2);

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
        CHECKARG(2, CHARACTER_t);

	_clip_retl(cm, gtk_icon_theme_has_icon(GTK_ICON_THEME(cicon->object),
			name));
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMELOOKUPICON(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        gchar     *name   = _clip_parc(cm, 2);
        gint       size   = _clip_parni(cm, 3);
        GtkIconLookupFlags flags = _clip_parni(cm, 4);

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);

	gtk_icon_theme_lookup_icon(GTK_ICON_THEME(cicon->object),
			name, size, flags);
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMELOADICON(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        gchar     *name   = _clip_parc(cm, 2);
        gint       size   = _clip_parni(cm, 3);
        GtkIconLookupFlags flags = _clip_parni(cm, 4);
        GError   *error   ;
        C_object *cpixbuf ;
        GdkPixbuf *pixbuf ;

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);

	pixbuf = gtk_icon_theme_load_icon(GTK_ICON_THEME(cicon->object),
			name, size, flags, &error);

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
clip_GTK_ICONTHEMELISTICONS(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        gchar     *name   = _clip_parc(cm, 2);
        ClipVar     *cv   = RETPTR(cm);
        GList     *list   ;
        long          n   ;

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));
        CHECKARG(2, CHARACTER_t);

	list = gtk_icon_theme_list_icons(GTK_ICON_THEME(cicon->object),
			name);
	n = g_list_length(list);
        _clip_array(cm, cv, 1, &n);
        for (n=0; list; list = g_list_next(list), n++)
        {
        	ClipVar c;
                gchar *str;

		str = (gchar *)(list->data);
                _clip_var_str(str, strlen(str), &c);
        	_clip_aset(cm, cv, &c, 1, &n);
                _clip_destroy(cm, &c);
                g_free(str);
        }
        g_list_free(list);
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMEGETEXAMPLEICONNAME(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);
        gchar     *name   ;

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));

	name = gtk_icon_theme_get_example_icon_name(GTK_ICON_THEME(cicon->object));

	_clip_retc(cm, name);

        g_free(name);
	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMERESCANIFNEEDED(ClipMachine * cm)
{
        C_object *cicon   = _fetch_co_arg(cm);

	CHECKCOBJ(cicon, GTK_IS_ICON_THEME(cicon->object));

	_clip_retl(cm, gtk_icon_theme_rescan_if_needed(GTK_ICON_THEME(cicon->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONTHEMEADDBUILTINAICON(ClipMachine * cm)
{
        gchar     *name   = _clip_parc(cm, 1);
        gint       size   = _clip_parni(cm, 2);
        C_object *cpixbuf = _fetch_cobject(cm, _clip_spar(cm, 3));

        CHECKARG(1, CHARACTER_t);
        CHECKARG(2, NUMERIC_t);
	CHECKCOBJ(cpixbuf, GDK_IS_PIXBUF(cpixbuf->object));

	gtk_icon_theme_add_builtin_icon(name,
		size, GDK_PIXBUF(cpixbuf->object));

	return 0;
err:
	return 1;
}

