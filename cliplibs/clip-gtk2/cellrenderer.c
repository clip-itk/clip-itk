/*
    Copyright (C) 2003  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <string.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/*	CellRenderer has no own signals 		  */

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

long _clip_type_cell_renderer() { return GTK_OBJECT_CELL_RENDERER; }
long _clip_type_cell_renderer_text() { return GTK_OBJECT_CELL_RENDERER_TEXT; }
long _clip_type_cell_renderer_pixbuf() { return GTK_OBJECT_CELL_RENDERER_PIXBUF; }
long _clip_type_cell_renderer_toggle() { return GTK_OBJECT_CELL_RENDERER_TOGGLE; }

const char * _clip_type_name_cell_renderer()  { return "GTK_TYPE_CELL_RENDERER"; }
const char * _clip_type_name_cell_renderer_text()  { return "GTK_TYPE_CELL_RENDERER_TEXT"; }
const char * _clip_type_name_cell_renderer_pixbuf()  { return "GTK_TYPE_CELL_RENDERER_PIXBUF"; }
const char * _clip_type_name_cell_renderer_toggle()  { return "GTK_TYPE_CELL_RENDERER_TOGGLE"; }

/* Register boxes in global table */
int
clip_INIT___CELLRENDERER(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_cell_renderer,  _clip_type_name_cell_renderer,  _gtk_type_cell_renderer,  NULL, NULL);
	_wtype_table_put(_clip_type_cell_renderer_text,  _clip_type_name_cell_renderer_text,  _gtk_type_cell_renderer_text,  _gtk_type_cell_renderer, cell_renderer_text_signals);
	_wtype_table_put(_clip_type_cell_renderer_toggle,  _clip_type_name_cell_renderer_toggle,  _gtk_type_cell_renderer_toggle,  _gtk_type_cell_renderer, cell_renderer_toggle_signals);
	_wtype_table_put(_clip_type_cell_renderer_pixbuf,  _clip_type_name_cell_renderer_pixbuf,  _gtk_type_cell_renderer_pixbuf,  _gtk_type_cell_renderer, NULL);
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


