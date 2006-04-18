/*
    Copyright (C) 2004 - 2005 ITK
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
handler_signal(GtkFileChooser *filech, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable file_chooser_signals[] =
{
	{"current-folder-changed",	GSF( handler_signal ), ESF( object_emit_signal ), GTK_CURRENT_FOLDER_CHANGED_SIGNAL},
	{"file-activated",		GSF( handler_signal ), ESF( object_emit_signal ), GTK_FILE_ACTIVATED_SIGNAL},
	{"selection-changed",		GSF( handler_signal ), ESF( object_emit_signal ), GTK_SELECTION_CHANGED_SIGNAL},
	{"update-preview",		GSF( handler_signal ), ESF( object_emit_signal ), GTK_UPDATE_PREVIEW_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_file_chooser() { return GTK_TYPE_FILE_CHOOSER; }
long _clip_type_file_chooser() { return GTK_OBJECT_FILE_CHOOSER; }
const char * _clip_type_name_file_chooser()  { return "GTK_OBJECT_FILE_CHOOSER"; }

CLIP_DLLEXPORT GtkType _gtk_type_file_chooser_dialog() { return GTK_TYPE_FILE_CHOOSER_DIALOG; }
long _clip_type_file_chooser_dialog() { return GTK_WIDGET_FILE_CHOOSER_DIALOG; }
const char * _clip_type_name_file_chooser_dialog()  { return "GTK_WIDGET_FILE_CHOOSER_DIALOG"; }

CLIP_DLLEXPORT GtkType _gtk_type_file_chooser_widget() { return GTK_TYPE_FILE_CHOOSER_WIDGET; }
long _clip_type_file_chooser_widget() { return GTK_WIDGET_FILE_CHOOSER_WIDGET; }
const char * _clip_type_name_file_chooser_widget()  { return "GTK_WIDGET_FILE_CHOOSER_WIDGET"; }

int
clip_INIT___FILECHOOSER(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_file_chooser,  _clip_type_name_file_chooser,  _gtk_type_file_chooser,  NULL, file_chooser_signals);
	_wtype_table_put(_clip_type_file_chooser_dialog,  _clip_type_name_file_chooser_dialog,  _gtk_type_file_chooser_dialog,  _gtk_type_dialog, NULL);
	_wtype_table_put(_clip_type_file_chooser_widget,  _clip_type_name_file_chooser_widget,  _gtk_type_file_chooser_widget,  _gtk_type_vbox, NULL);
	return 0;
}

int
clip_GTK_FILECHOOSERERRORQUARK(ClipMachine * cm)
{
	GQuark error_quark;
        C_object *cerr;

	error_quark = gtk_file_chooser_error_quark();

	if (error_quark)
	{
		cerr = _register_object(cm, &error_quark, GTK_TYPE_OBJECT,NULL,NULL);
		if (cerr) _clip_mclone(cm,RETPTR(cm),&cerr->obj);
	}

	return 0;
}


int
clip_GTK_FILECHOOSERSETACTION(ClipMachine * cm)
{
        C_object *cchooser   = _fetch_co_arg(cm);
        GtkFileChooserAction action = _clip_parni(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, NUMERIC_t);

	gtk_file_chooser_set_action(GTK_FILE_CHOOSER(cchooser->object), action);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETACTION(ClipMachine * cm)
{
        C_object *cchooser   = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	_clip_retni(cm, (int)gtk_file_chooser_get_action(GTK_FILE_CHOOSER(cchooser->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETLOCALONLY(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gboolean       set = _clip_parl(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, LOGICAL_t);

	gtk_file_chooser_set_local_only(GTK_FILE_CHOOSER(cchooser->object), set);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETLOCALONLY(ClipMachine * cm)
{
        C_object *cchooser   = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	_clip_retl(cm, gtk_file_chooser_get_local_only(GTK_FILE_CHOOSER(cchooser->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETSELECTMILTIPLE(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gboolean       set = _clip_parl(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, LOGICAL_t);

	gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER(cchooser->object), set);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETSELECTMULTIPLE(ClipMachine * cm)
{
        C_object *cchooser   = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	_clip_retl(cm, gtk_file_chooser_get_select_multiple(GTK_FILE_CHOOSER(cchooser->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETCURRENTNAME(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER(cchooser->object), name);
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETFILENAME(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	_clip_retl(cm, gtk_file_chooser_set_filename(GTK_FILE_CHOOSER(cchooser->object), name));
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETFILENAME(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	name = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(cchooser->object));
	LOCALE_FROM_UTF(name);
        _clip_retc(cm, name);
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSELECTFILENAME(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	_clip_retl(cm, gtk_file_chooser_select_filename(GTK_FILE_CHOOSER(cchooser->object), name));
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}


int
clip_GTK_FILECHOOSERUNSELECTFILENAME(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	gtk_file_chooser_unselect_filename(GTK_FILE_CHOOSER(cchooser->object), name);
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}


int
clip_GTK_FILECHOOSERSELECTALL(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	gtk_file_chooser_select_all(GTK_FILE_CHOOSER(cchooser->object));

	return 0;
err:
	return 1;
}


int
clip_GTK_FILECHOOSERUNSELECTALL(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	gtk_file_chooser_unselect_all(GTK_FILE_CHOOSER(cchooser->object));

	return 0;
err:
	return 1;
}


int
clip_GTK_FILECHOOSERGETFILENAMES(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        GSList       *list ;
        ClipVar        *cv = RETPTR(cm);
        long             l;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	list = gtk_file_chooser_get_filenames(GTK_FILE_CHOOSER(cchooser->object));
        l = g_slist_length(list);

	_clip_array(cm, cv, 1, &l);
        for (l=0; list; list=g_slist_next(list), l++)
        {
        	ClipVar c;
                gchar *str;
                memset(&c, 0, sizeof(c));
                str = (gchar *)list->data;
                _clip_var_str(str, strlen(str), &c);
                _clip_aset(cm, cv, &c, 1, &l);
                _clip_destroy(cm, &c);
                g_free(str);
        }
        g_slist_free(list);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETCURRENTFOLDER(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	gtk_file_chooser_set_current_folder(GTK_FILE_CHOOSER(cchooser->object), name);
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETCURRENTFOLDER(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	name = gtk_file_chooser_get_current_folder(GTK_FILE_CHOOSER(cchooser->object));
	LOCALE_FROM_UTF(name);
        _clip_retc(cm, name);
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETURI(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *uri ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	uri = gtk_file_chooser_get_uri(GTK_FILE_CHOOSER(cchooser->object));
	LOCALE_FROM_UTF(uri);
        _clip_retc(cm, uri);
        FREE_TEXT(uri);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETURI(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *uri  = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(uri);
	gtk_file_chooser_set_uri(GTK_FILE_CHOOSER(cchooser->object), uri);
        FREE_TEXT(uri);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSELECTURI(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *uri  = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(uri);
	_clip_retl(cm, gtk_file_chooser_select_uri(GTK_FILE_CHOOSER(cchooser->object), uri));
        FREE_TEXT(uri);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERUNSELECTURI(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *uri  = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(uri);
	gtk_file_chooser_select_uri(GTK_FILE_CHOOSER(cchooser->object), uri);
        FREE_TEXT(uri);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETURIS(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        GSList       *list ;
        ClipVar        *cv = RETPTR(cm);
        long             l;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	list = gtk_file_chooser_get_uris(GTK_FILE_CHOOSER(cchooser->object));
        l = g_slist_length(list);

	_clip_array(cm, cv, 1, &l);
        for (l=0; list; list=g_slist_next(list), l++)
        {
        	ClipVar c;
                gchar *str;
                memset(&c, 0, sizeof(c));
                str = (gchar *)list->data;
                _clip_var_str(str, strlen(str), &c);
                _clip_aset(cm, cv, &c, 1, &l);
                _clip_destroy(cm, &c);
        }
        g_slist_free(list);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETCURRENTFOLDERURI(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *uri  = _clip_parc(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(uri);
	_clip_retl(cm, gtk_file_chooser_set_current_folder_uri(GTK_FILE_CHOOSER(cchooser->object), uri));
        FREE_TEXT(uri);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETCURRENTFOLDERURI(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *uri ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	uri = gtk_file_chooser_get_current_folder_uri(GTK_FILE_CHOOSER(cchooser->object));
	LOCALE_FROM_UTF(uri);
        _clip_retc(cm, uri);
        FREE_TEXT(uri);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETPREVIEWWIDGET(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        C_widget     *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKCWID(cwid, GTK_IS_WIDGET);

	gtk_file_chooser_set_preview_widget(GTK_FILE_CHOOSER(cchooser->object),
		GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETPREVIEWWIDGET(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        GtkWidget     *wid;
        C_widget     *cwid ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	wid = gtk_file_chooser_get_preview_widget(GTK_FILE_CHOOSER(cchooser->object));
	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETPREVIEWWIDGETACTIVE(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gboolean       set = _clip_parl(cm, 2);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, LOGICAL_t);

	gtk_file_chooser_set_preview_widget_active(GTK_FILE_CHOOSER(cchooser->object), set);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETPREVIEWWIDGETACTIVE(ClipMachine * cm)
{
        C_object *cchooser   = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	_clip_retl(cm, gtk_file_chooser_get_preview_widget_active(GTK_FILE_CHOOSER(cchooser->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETUSEPREVIEWLABEL(ClipMachine * cm)
{
        C_object *cchooser   = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	_clip_retl(cm, gtk_file_chooser_get_use_preview_label(GTK_FILE_CHOOSER(cchooser->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETPREVIEWFILENAME(ClipMachine * cm)
{
        C_object *cchooser   = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	_clip_retc(cm, gtk_file_chooser_get_preview_filename(GTK_FILE_CHOOSER(cchooser->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETPREVIEWURI(ClipMachine * cm)
{
        C_object *cchooser   = _fetch_co_arg(cm);

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	_clip_retc(cm, gtk_file_chooser_get_preview_uri(GTK_FILE_CHOOSER(cchooser->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETEXTRAWIDGET(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        C_widget     *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKCWID(cwid, GTK_IS_WIDGET);

	gtk_file_chooser_set_extra_widget(GTK_FILE_CHOOSER(cchooser->object),
		GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETEXTRAWIDGET(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        GtkWidget     *wid;
        C_widget     *cwid ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	wid = gtk_file_chooser_get_extra_widget(GTK_FILE_CHOOSER(cchooser->object));
	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERADDFILTER(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        C_object  *cfilter = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));

	gtk_file_chooser_add_filter(GTK_FILE_CHOOSER(cchooser->object),
		GTK_FILE_FILTER(cfilter->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERREMOVEFILTER(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        C_object  *cfilter = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));

	gtk_file_chooser_remove_filter(GTK_FILE_CHOOSER(cchooser->object),
		GTK_FILE_FILTER(cfilter->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERLISTFILTERS(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        GSList       *list ;
        ClipVar        *cv = RETPTR(cm);
        long             l;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	list = gtk_file_chooser_list_filters(GTK_FILE_CHOOSER(cchooser->object));
        l = g_slist_length(list);

	_clip_array(cm, cv, 1, &l);
        for (l=0; list; list=g_slist_next(list), l++)
        {
                GtkFileFilter *filter;
                C_object *cfilter;

                filter = GTK_FILE_FILTER(list->data);
                cfilter = _list_get_cobject(cm, filter);
                if (!cfilter) cfilter = _register_object(cm, filter, GTK_TYPE_FILE_FILTER, NULL, NULL);
                if (cfilter)
                	_clip_aset(cm, cv, &cfilter->obj, 1, &l);
        }
        g_slist_free(list);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERSETFILTER(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        C_object  *cfilter = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));

	gtk_file_chooser_set_filter(GTK_FILE_CHOOSER(cchooser->object),
		GTK_FILE_FILTER(cfilter->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERGETFILTER(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        C_object  *cfilter ;
        GtkFileFilter *filter;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	filter = gtk_file_chooser_get_filter(GTK_FILE_CHOOSER(cchooser->object));
        if (filter)
        {
                cfilter = _list_get_cobject(cm, filter);
                if (!cfilter) cfilter = _register_object(cm, filter, GTK_TYPE_FILE_FILTER, NULL, NULL);
                if (cfilter)
                	_clip_mclone(cm, RETPTR(cm), &cfilter->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERADDSHORTCUTFOLDER(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name  = _clip_parc(cm, 2);
        GError      *error ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	_clip_retl(cm, gtk_file_chooser_add_shortcut_folder(GTK_FILE_CHOOSER(cchooser->object), name, &error));
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERREMOVESHORTCUTFOLDER(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name  = _clip_parc(cm, 2);
        GError      *error ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	_clip_retl(cm, gtk_file_chooser_remove_shortcut_folder(GTK_FILE_CHOOSER(cchooser->object), name, &error));
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERLISTSHORTCUTFOLDERS(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        GSList       *list ;
        ClipVar        *cv = RETPTR(cm);
        long             l;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	list = gtk_file_chooser_list_shortcut_folders(GTK_FILE_CHOOSER(cchooser->object));
        l = g_slist_length(list);

	_clip_array(cm, cv, 1, &l);
        for (l=0; list; list=g_slist_next(list), l++)
        {
        	ClipVar c;
                gchar *str;
                memset(&c, 0, sizeof(c));
                str = (gchar *)list->data;
                _clip_var_str(str, strlen(str), &c);
                _clip_aset(cm, cv, &c, 1, &l);
                _clip_destroy(cm, &c);
                g_free(str);
        }
        g_slist_free(list);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERADDSHORTCUTFOLDERURI(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name  = _clip_parc(cm, 2);
        GError      *error ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	_clip_retl(cm, gtk_file_chooser_add_shortcut_folder_uri(GTK_FILE_CHOOSER(cchooser->object), name, &error));
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERREMOVESHORTCUTFOLDERURI(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        gchar        *name  = _clip_parc(cm, 2);
        GError      *error ;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	_clip_retl(cm, gtk_file_chooser_remove_shortcut_folder_uri(GTK_FILE_CHOOSER(cchooser->object), name, &error));
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERLISTSHORTCUTFOLDERURIS(ClipMachine * cm)
{
        C_object *cchooser = _fetch_co_arg(cm);
        GSList       *list ;
        ClipVar        *cv = RETPTR(cm);
        long             l;

	CHECKCOBJ(cchooser, GTK_IS_FILE_CHOOSER(cchooser->object));

	list = gtk_file_chooser_list_shortcut_folder_uris(GTK_FILE_CHOOSER(cchooser->object));
        l = g_slist_length(list);

	_clip_array(cm, cv, 1, &l);
        for (l=0; list; list=g_slist_next(list), l++)
        {
        	ClipVar c;
                gchar *str;
                memset(&c, 0, sizeof(c));
                str = (gchar *)list->data;
                _clip_var_str(str, strlen(str), &c);
                _clip_aset(cm, cv, &c, 1, &l);
                _clip_destroy(cm, &c);
                g_free(str);
        }
        g_slist_free(list);

	return 0;
err:
	return 1;
}
/*****************************************************************************/
/******************* FILE CHOOSER DIALOG *************************************/
int
clip_GTK_FILECHOOSERDIALOGNEW(ClipMachine * cm)
{
        ClipVar       *cv  = _clip_spar(cm, 1);
        gchar      *title  = _clip_parc(cm, 2);
        C_widget  *cparent = _fetch_cwidget(cm, _clip_spar(cm, 3));
        GtkFileChooserAction action = _clip_parni(cm, 4);
        GtkWidget     *wid;
        C_widget     *cwid ;
        gchar  *button[20], *response_id[20] ;
        gint  i, j, n;


        CHECKOPT2(1, NUMERIC_t, MAP_t);
	CHECKOPT(2, CHARACTER_t);
        CHECKCWIDOPT(cparent, GTK_IS_WINDOW);
        CHECKARG(4, NUMERIC_t);
	memset(button, 0, sizeof(button));
	memset(response_id, 0, sizeof(response_id));
        n = _clip_parinfo(cm, 0);
	for (i=0, j=5; j<n; j += 2, i++)
        {
		CHECKOPT(j, CHARACTER_t);
                if (_clip_parinfo(cm, j) == UNDEF_t)
                	break;
		CHECKOPT(j+1, CHARACTER_t);
		button[i] = _clip_parc(cm, j);
		response_id[i] = _clip_parc(cm, j+1);
		LOCALE_TO_UTF(button[i]);
		LOCALE_TO_UTF(response_id[i]);
        }

	if (title) LOCALE_TO_UTF(title);
	wid = gtk_file_chooser_dialog_new((title)?title:NULL,
		GTK_WINDOW(cparent->widget),
		action,
		button[0],  response_id[0],  button[1],  response_id[1],
		button[2],  response_id[2],  button[3],  response_id[3],
		button[4],  response_id[4],  button[5],  response_id[5],
		button[6],  response_id[6],  button[7],  response_id[7],
		button[8],  response_id[8],  button[9],  response_id[9],
		button[10], response_id[10], button[11], response_id[11],
		button[12], response_id[12], button[13], response_id[13],
		button[14], response_id[14], button[15], response_id[15],
		button[16], response_id[16], button[17], response_id[17],
		button[18], response_id[18], button[19], response_id[19],
		NULL );
	for (i=0; i<n-5; i ++)
        {
		FREE_TEXT(button[i]);
		FREE_TEXT(response_id[i]);
        }
	if (title) FREE_TEXT(title);
	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, cv);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERDIALOGNEWWITHBACKEND(ClipMachine * cm)
{
        ClipVar       *cv  = _clip_spar(cm, 1);
        gchar      *title  = _clip_parc(cm, 2);
        C_widget  *cparent = _fetch_cwidget(cm, _clip_spar(cm, 3));
        GtkFileChooserAction action = _clip_parni(cm, 4);
        gchar     *backend = _clip_parc(cm, 5);
        GtkWidget     *wid;
        C_widget     *cwid ;
        gchar  *button[20], *response_id[20] ;
        gint  i, j, n;


        CHECKOPT2(1, NUMERIC_t, MAP_t);
	CHECKOPT(2, CHARACTER_t);
        CHECKCWIDOPT(cparent, GTK_IS_WINDOW);
        CHECKARG(4, NUMERIC_t);
	CHECKOPT(5, CHARACTER_t);

	memset(button, 0, sizeof(button));
	memset(response_id, 0, sizeof(response_id));

        n = _clip_parinfo(cm, 0);
	for (i=0, j=6; j<n; j += 2, i++)
        {
		CHECKOPT(j, CHARACTER_t);
                if (_clip_parinfo(cm, j) == UNDEF_t)
                	break;
		CHECKOPT(j+1, CHARACTER_t);
		button[i] = _clip_parc(cm, j);
		response_id[i] = _clip_parc(cm, j+1);
		LOCALE_TO_UTF(button[i]);
		LOCALE_TO_UTF(response_id[i]);
        }

	if (title) LOCALE_TO_UTF(title);
	wid = gtk_file_chooser_dialog_new((title)?title:NULL,
		GTK_WINDOW(cparent->widget),
		action,
                backend,
		button[0],  response_id[0],  button[1],  response_id[1],
		button[2],  response_id[2],  button[3],  response_id[3],
		button[4],  response_id[4],  button[5],  response_id[5],
		button[6],  response_id[6],  button[7],  response_id[7],
		button[8],  response_id[8],  button[9],  response_id[9],
		button[10], response_id[10], button[11], response_id[11],
		button[12], response_id[12], button[13], response_id[13],
		button[14], response_id[14], button[15], response_id[15],
		button[16], response_id[16], button[17], response_id[17],
		button[18], response_id[18], button[19], response_id[19],
		NULL);
	for (i=0; i<n-6; i ++)
        {
		FREE_TEXT(button[i]);
		FREE_TEXT(response_id[i]);
        }
	if (title) FREE_TEXT(title);
	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, cv);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}

/*****************************************************************************/
/******************* FILE CHOOSER WIDGET *************************************/

int
clip_GTK_FILECHOOSERWIDGETNEW(ClipMachine * cm)
{
        ClipVar        *cv = _clip_spar(cm, 1);
        GtkFileChooserAction action = _clip_parni(cm, 2);
        GtkWidget     *wid;
        C_widget     *cwid ;

        CHECKOPT2(1, NUMERIC_t, MAP_t);
        CHECKARG(2, NUMERIC_t);

	wid = gtk_file_chooser_widget_new(action);
	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, cv);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERWIDGETNEWWITHBACKEND(ClipMachine * cm)
{
        ClipVar        *cv = _clip_spar(cm, 1);
        GtkFileChooserAction action = _clip_parni(cm, 2);
        gchar     *backend = _clip_parc(cm, 2);
        GtkWidget     *wid;
        C_widget     *cwid;

        CHECKOPT2(1, NUMERIC_t, MAP_t);
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, CHARACTER_t);

	wid = gtk_file_chooser_widget_new_with_backend(action, backend);
	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, cv);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}
