/*
    Copyright (C) 2003 -2004 ITK
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
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)

static gint
handle_editing_canceled (GtkCellRenderer *cell, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable cell_renderer_signals[] =
{
	{"editing-canceled",	GSF( handle_editing_canceled ), ESF( object_emit_signal ), GTK_EDITING_CANCELED_SIGNAL},
	{"", NULL, NULL, 0}
};
#endif
/**********************************************************/
/* Signals table  CellRendererText   */
static gint
handle_cell_renderer_text_edited (GtkCellRendererText *cellrenderertext, gchar * arg1, gchar * arg2, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	_clip_mputc(cs->co->cmachine, &cv, HASH_PATHSTRING, arg1, strlen(arg1));
	LOCALE_FROM_UTF(arg2);
	_clip_mputc(cs->co->cmachine, &cv, HASH_NEWTEXT, arg2, strlen(arg2));
        FREE_TEXT(arg2);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable cell_renderer_text_signals[] =
{
	{"edited",	GSF( handle_cell_renderer_text_edited ), ESF( object_emit_signal ), GTK_CELL_RENDERER_TEXT_EDITED_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Signals table  CellRendererToggle   */
static gint
handle_cell_renderer_toggle_toggled (GtkCellRendererToggle *cellrenderertoggle, gchar * arg1, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	_clip_mputc(cs->co->cmachine, &cv, HASH_PATHSTRING, arg1, strlen(arg1));
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable cell_renderer_toggle_signals[] =
{
	{"toggled",	GSF( handle_cell_renderer_toggle_toggled ), ESF( object_emit_signal ), GTK_CELL_RENDERER_TOGGLE_TOGGLED_SIGNAL},
	{"", NULL, NULL, 0}
};
CLIP_DLLEXPORT GtkType _gtk_type_cell_renderer() { return GTK_TYPE_CELL_RENDERER; }
CLIP_DLLEXPORT GtkType _gtk_type_cell_renderer_text() { return GTK_TYPE_CELL_RENDERER_TEXT; }
CLIP_DLLEXPORT GtkType _gtk_type_cell_renderer_pixbuf() { return GTK_TYPE_CELL_RENDERER_PIXBUF; }
CLIP_DLLEXPORT GtkType _gtk_type_cell_renderer_toggle() { return GTK_TYPE_CELL_RENDERER_TOGGLE; }
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
CLIP_DLLEXPORT GtkType _gtk_type_cell_renderer_combo() { return GTK_TYPE_CELL_RENDERER_COMBO; }
CLIP_DLLEXPORT GtkType _gtk_type_cell_renderer_progress() { return GTK_TYPE_CELL_RENDERER_PROGRESS; }
#endif
long _clip_type_cell_renderer() { return GTK_OBJECT_CELL_RENDERER; }
long _clip_type_cell_renderer_text() { return GTK_OBJECT_CELL_RENDERER_TEXT; }
long _clip_type_cell_renderer_pixbuf() { return GTK_OBJECT_CELL_RENDERER_PIXBUF; }
long _clip_type_cell_renderer_toggle() { return GTK_OBJECT_CELL_RENDERER_TOGGLE; }
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
long _clip_type_cell_renderer_combo() { return GTK_OBJECT_CELL_RENDERER_COMBO; }
long _clip_type_cell_renderer_progress() { return GTK_OBJECT_CELL_RENDERER_PROGRESS; }
#endif

const char * _clip_type_name_cell_renderer()  { return "GTK_OBJECT_CELL_RENDERER"; }
const char * _clip_type_name_cell_renderer_text()  { return "GTK_OBJECT_CELL_RENDERER_TEXT"; }
const char * _clip_type_name_cell_renderer_pixbuf()  { return "GTK_OBJECT_CELL_RENDERER_PIXBUF"; }
const char * _clip_type_name_cell_renderer_toggle()  { return "GTK_OBJECT_CELL_RENDERER_TOGGLE"; }
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
const char * _clip_type_name_cell_renderer_combo()  { return "GTK_OBJECT_CELL_RENDERER_COMBO"; }
const char * _clip_type_name_cell_renderer_progress()  { return "GTK_OBJECT_CELL_RENDERER_PROGRESS"; }
#endif

/* Register boxes in global table */
int
clip_INIT___CELLRENDERER(ClipMachine *cm)
{
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
	_wtype_table_put(_clip_type_cell_renderer,  _clip_type_name_cell_renderer,  _gtk_type_cell_renderer,  NULL, cell_renderer_signals);
#else
	_wtype_table_put(_clip_type_cell_renderer,  _clip_type_name_cell_renderer,  _gtk_type_cell_renderer,  NULL, NULL);
#endif
	_wtype_table_put(_clip_type_cell_renderer_text,  _clip_type_name_cell_renderer_text,  _gtk_type_cell_renderer_text,  _gtk_type_cell_renderer, cell_renderer_text_signals);
	_wtype_table_put(_clip_type_cell_renderer_toggle,  _clip_type_name_cell_renderer_toggle,  _gtk_type_cell_renderer_toggle,  _gtk_type_cell_renderer, cell_renderer_toggle_signals);
	_wtype_table_put(_clip_type_cell_renderer_pixbuf,  _clip_type_name_cell_renderer_pixbuf,  _gtk_type_cell_renderer_pixbuf,  _gtk_type_cell_renderer, NULL);
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
	_wtype_table_put(_clip_type_cell_renderer_combo,  _clip_type_name_cell_renderer_combo,  _gtk_type_cell_renderer_combo,  _gtk_type_cell_renderer_text, NULL);
	_wtype_table_put(_clip_type_cell_renderer_progress,  _clip_type_name_cell_renderer_progress,  _gtk_type_cell_renderer_progress,  _gtk_type_cell_renderer, NULL);
#endif
	return 0;
}

int
clip_GTK_CELLRENDERERTEXTNEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        C_object *ccell;
        GtkCellRenderer *cell;

	CHECKOPT(1,MAP_t);

	cell = gtk_cell_renderer_text_new();

	if (cell)
	{
		ccell = _list_get_cobject(cm,cell);
		if (!ccell) ccell = _register_object(cm,cell,GTK_TYPE_CELL_RENDERER_TEXT,cv,NULL);
		if (ccell) _clip_mclone(cm,RETPTR(cm),&ccell->obj);
	}
	return 0;
err:
	return 1;
}



int
clip_GTK_CELLRENDERERTOGGLENEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        C_object *ccell;
        GtkCellRenderer *cell;

	CHECKOPT(1,MAP_t);

	cell = gtk_cell_renderer_toggle_new();

	if (cell)
	{
		ccell = _list_get_cobject(cm,cell);
		if (!ccell) ccell = _register_object(cm,cell,GTK_TYPE_CELL_RENDERER_TOGGLE,cv,NULL);
		if (ccell) _clip_mclone(cm,RETPTR(cm),&ccell->obj);
	}
	return 0;
err:
	return 1;
}


int
clip_GTK_CELLRENDERERPIXBUFNEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        C_object *ccell;
        GtkCellRenderer *cell;

	CHECKOPT(1,MAP_t);

	cell = gtk_cell_renderer_pixbuf_new();

	if (cell)
	{
		ccell = _list_get_cobject(cm,cell);
		if (!ccell) ccell = _register_object(cm,cell,GTK_TYPE_CELL_RENDERER_PIXBUF,cv,NULL);
		if (ccell) _clip_mclone(cm,RETPTR(cm),&ccell->obj);
	}
	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
int
clip_GTK_CELLRENDEREREDITINGCANCELED(ClipMachine * cm)
{
        C_object *ccell = _fetch_co_arg(cm);;

	CHECKCOBJ(ccell, GTK_IS_CELL_RENDERER(ccell->object));

	gtk_cell_renderer_editing_canceled(GTK_CELL_RENDERER(ccell->object));

	return 0;
err:
	return 1;
}

#endif
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
int
clip_GTK_CELLRENDERERSTOPEDITING(ClipMachine * cm)
{
        C_object *ccell = _fetch_co_arg(cm);
	gboolean  lstop = _clip_parl(cm, 2);

	CHECKCOBJ(ccell, GTK_IS_CELL_RENDERER(ccell->object));
        CHECKARG(2, LOGICAL_t);

	gtk_cell_renderer_stop_editing(GTK_CELL_RENDERER(ccell->object), lstop);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLRENDERERCOMBONEW(ClipMachine * cm)
{
	ClipVar  *cv       = _clip_spar(cm, 1);
	C_object *cmodel   = _fetch_cobject(cm, _clip_spar(cm, 2));
	gint      column   = _clip_parni(cm, 3);
	gboolean  contains = _clip_parl(cm, 4);
	gboolean  editable = _clip_parl(cm, 5);
	C_object *ccell;
	GtkCellRenderer *cell;
        
	CHECKOPT(1, MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cmodel, GTK_IS_TREE_MODEL(cmodel->object));
	CHECKOPT(3, NUMERIC_t);
	CHECKOPT(4,LOGICAL_t);
	CHECKOPT(5,LOGICAL_t);

	cell = gtk_cell_renderer_combo_new();
	g_object_set (cell,
				"model", GTK_TREE_MODEL(cmodel->object),
				"text-column", column-1,
                "has-entry", contains,
                "editable", editable,
                NULL);

	if (cell)
	{
		ccell = _list_get_cobject(cm,cell);
		if (!ccell) ccell = _register_object(cm,cell,GTK_TYPE_CELL_RENDERER_COMBO,cv,NULL);
		if (ccell) _clip_mclone(cm,RETPTR(cm),&ccell->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_CELLRENDERERPROGRESSNEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        C_object *ccell;
        GtkCellRenderer *cell;

	CHECKOPT(1,MAP_t);

	cell = gtk_cell_renderer_progress_new();

	if (cell)
	{
		ccell = _list_get_cobject(cm,cell);
		if (!ccell) ccell = _register_object(cm,cell,GTK_TYPE_CELL_RENDERER_PROGRESS,cv,NULL);
		if (ccell) _clip_mclone(cm,RETPTR(cm),&ccell->obj);
	}
	return 0;
err:
	return 1;
}
#endif
