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

/* There is no signals                                    */
/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_file_filter() { return GTK_TYPE_FILE_FILTER; }
long _clip_type_file_filter() { return GTK_OBJECT_FILE_FILTER; }
const char * _clip_type_name_file_filter()  { return "GTK_OBJECT_FILE_FILTER"; }

int
clip_INIT___FILEFILTER(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_file_filter,  _clip_type_name_file_filter,  _gtk_type_file_filter,  NULL, NULL);
	return 0;
}

int
clip_GTK_FILEFILTERNEW(ClipMachine * cm)
{
        GtkFileFilter *filter;
        C_object     *cfilter;

	filter = gtk_file_filter_new();

	if (filter)
	{
		cfilter = _register_object(cm, filter, GTK_TYPE_FILE_FILTER, NULL,NULL);
		if (cfilter) _clip_mclone(cm,RETPTR(cm),&cfilter->obj);
	}

	return 0;
}

int
clip_GTK_FILEFILTERSETNAME(ClipMachine * cm)
{
        C_object  *cfilter = _fetch_co_arg(cm);
        gchar        *name = _clip_parc(cm, 2);

	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(name);
	gtk_file_filter_set_name(GTK_FILE_FILTER(cfilter->object), name);
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILEFILTERGETNAME(ClipMachine * cm)
{
        C_object  *cfilter = _fetch_co_arg(cm);
        gchar        *name ;

	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));

	name = (gchar *)gtk_file_filter_get_name(GTK_FILE_FILTER(cfilter->object));
	LOCALE_FROM_UTF(name);
        _clip_retc(cm, name);
        FREE_TEXT(name);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILEFILTERADDMIMETYPE(ClipMachine * cm)
{
        C_object  *cfilter = _fetch_co_arg(cm);
        gchar        *type = _clip_parc(cm, 2);

	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));
        CHECKARG(2, CHARACTER_t);

	gtk_file_filter_add_mime_type(GTK_FILE_FILTER(cfilter->object), type);

	return 0;
err:
	return 1;
}


int
clip_GTK_FILEFILTERADDPATTERN(ClipMachine * cm)
{
        C_object  *cfilter = _fetch_co_arg(cm);
        gchar     *pattern = _clip_parc(cm, 2);

	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));
        CHECKARG(2, CHARACTER_t);

	gtk_file_filter_add_pattern(GTK_FILE_FILTER(cfilter->object), pattern);

	return 0;
err:
	return 1;
}

static
gboolean _file_filter_func(GtkFileFilterInfo *info, gpointer data)
{
	C_var *c = (C_var*)data;
	ClipVar stack[2];
	ClipVar cv;
	ClipVar res;
        gboolean ret = TRUE;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
        memset( &cv, 0, sizeof(ClipVar) );
        _clip_map(c->cm, &cv);
	_file_filter_info_to_map(c->cm, info, &cv);
	_clip_mclone(c->cm, &stack[0], &c->co->obj);
	_clip_mclone(c->cm, &stack[1], &cv);
	if ( _clip_eval( c->cm, &(c->cfunc), 2, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;
	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &cv);
	_clip_destroy(c->cm, &stack[0]);
	_clip_destroy(c->cm, &stack[1]);
	return ret;
}

int
clip_GTK_FILEFILTERADDCUSTOM(ClipMachine * cm)
{
        C_object  *cfilter = _fetch_co_arg(cm);
        GtkFileFilterFlags flags = _clip_parni(cm, 2);
        ClipVar      *func = _clip_spar(cm, 3);
        C_var           *c;

	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));
        CHECKARG(2, NUMERIC_t); CHECKOPT2(3, PCODE_t, CCODE_t);

	c->cm = cm; c->co = cfilter; _clip_mclone(cm, &c->cfunc, func);
	gtk_file_filter_add_custom(GTK_FILE_FILTER(cfilter->object),
		flags, (GtkFileFilterFunc)_file_filter_func, c, NULL);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILEFILTERGETNEEDED(ClipMachine * cm)
{
        C_object  *cfilter = _fetch_co_arg(cm);

	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));

	_clip_retni(cm, (int)gtk_file_filter_get_needed(GTK_FILE_FILTER(cfilter->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILEFILTERFILTER(ClipMachine * cm)
{
        C_object  *cfilter = _fetch_co_arg(cm);
        ClipVar        *cv = _clip_spar(cm, 2);
        GtkFileFilterInfo info;

	CHECKCOBJ(cfilter, GTK_IS_FILE_FILTER(cfilter->object));
        CHECKARG(2, MAP_t);

	_map_to_file_filter_info(cm, cv, &info);
	_clip_retl(cm, gtk_file_filter_filter(GTK_FILE_FILTER(cfilter->object), &info));

	return 0;
err:
	return 1;
}

