/*
    Copyright (C) 2003  ITK
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
static gint
handle_tag_added (GtkTextTagTable *tbl, GtkTextTag *arg1, C_signal *cs)
{
	C_object *ctag;
	OBJECTPREPARECV(cs,cv);
	ctag = _list_get_cobject(cs->cw->cmachine,arg1);
	if (!ctag) ctag = _register_object(cs->cw->cmachine,arg1,GTK_TYPE_TEXT_TAG, NULL, NULL);
	if (ctag) _clip_madd(cs->cw->cmachine, &cv, HASH_ARG1, &ctag->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static gint
handle_tag_changed (GtkTextTagTable *tbl, GtkTextTag *arg1, gboolean arg2, C_signal *cs)
{
	C_object *ctag;
	OBJECTPREPARECV(cs,cv);
	ctag = _list_get_cobject(cs->cw->cmachine,arg1);
	if (!ctag) ctag = _register_object(cs->cw->cmachine,arg1,GTK_TYPE_TEXT_TAG, NULL, NULL);
	if (ctag) _clip_madd(cs->cw->cmachine, &cv, HASH_ARG1, &ctag->obj);
	_clip_mputl(cs->cw->cmachine, &cv, HASH_ARG2, arg2);
	OBJECTINVOKESIGHANDLER(cs,cv);
}

static gint
handle_tag_removed (GtkTextTagTable *tbl, GtkTextTag *arg1, C_signal *cs)
{
	C_object *ctag;
	OBJECTPREPARECV(cs,cv);
	ctag = _list_get_cobject(cs->cw->cmachine,arg1);
	if (!ctag) ctag = _register_object(cs->cw->cmachine,arg1,GTK_TYPE_TEXT_TAG, NULL, NULL);
	if (ctag) _clip_madd(cs->cw->cmachine, &cv, HASH_ARG1, &ctag->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
/* Signals table */
static SignalTable text_tag_table_signals[] =
{

	{"tag-added",	GSF( handle_tag_added ), ESF( object_emit_signal ), GTK_TAG_ADDED_SIGNAL},
	{"tag-changed",	GSF( handle_tag_changed ), ESF( object_emit_signal ), GTK_TAG_CHANGED_SIGNAL},
	{"tag-removed",	GSF( handle_tag_removed ), ESF( object_emit_signal ), GTK_TAG_REMOVED_SIGNAL},
	{"", NULL, NULL, 0}
};


static void
_text_tag_table_for_each_func(GtkTextTag *tag, gpointer data)
{
	C_var *c = (C_var*)data;
	C_object *c_obj = _list_get_cobject(c->cm, tag);
	ClipVar stack[2];
	ClipVar res;
	if (!c_obj)
		c_obj = _register_object(c->cm,tag,GTK_TYPE_TEXT_TAG, NULL, NULL);
	if (c_obj)
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		_clip_mclone(c->co->cmachine, &stack[0], &c->co->obj);
		stack[1] = c_obj->obj;
		_clip_eval( c->cm, &(c->cfunc), 2, stack, &res );
		_clip_destroy(c->cm, &res);
	}
}

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_text_tag_table() { return GTK_TYPE_TEXT_TAG_TABLE; }

long _clip_type_text_tag_table() { return GTK_OBJECT_TEXT_TAG_TABLE; }

const char * _clip_type_name_text_tag_table()  { return "GTK_TYPE_TEXT_TAG_TABLE"; }

int
clip_INIT___TEXTTAGTABLE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_text_tag_table,  _clip_type_name_text_tag_table,  _gtk_type_text_tag_table,  NULL, text_tag_table_signals);
	return 0;
}

/*******************************************************************************
* gtk_TextTagTableNew( tagTableObj ) --> textTagTableObj
*******************************************************************************/
int
clip_GTK_TEXTTAGTABLENEW(ClipMachine * cm)
{

        ClipVar     *cv = _clip_spar(cm, 1);
        GtkTextTagTable *tbl ;
        C_object  *ctbl ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	tbl = gtk_text_tag_table_new( );

	if (tbl)
	{
		ctbl = _list_get_cobject(cm,tbl);
		if (!ctbl) ctbl = _register_object(cm,tbl,GTK_TYPE_TEXT_TAG_TABLE,cv,NULL);
		if (ctbl) _clip_mclone(cm,RETPTR(cm),&ctbl->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextTagTableAdd( textTagTable, textTag ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTTAGTABLEADD(ClipMachine * cm)
{
	C_object *ctbl = _fetch_co_arg(cm);
	C_object *ctag = _fetch_cobject(cm, _clip_par(cm, 2));

	CHECKOPT(1,MAP_t); CHECKCOBJ(ctbl, GTK_IS_TEXT_TAG_TABLE(ctbl->object));
	CHECKOPT(2,MAP_t); CHECKCOBJ(ctag, GTK_IS_TEXT_TAG(ctag->object));

	gtk_text_tag_table_add(GTK_TEXT_TAG_TABLE(ctbl->object),
		GTK_TEXT_TAG(ctag->object));

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextTagTableRemove( textTagTable, textTag ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTTAGTABLEREMOVE(ClipMachine * cm)
{
	C_object *ctbl = _fetch_co_arg(cm);
	C_object *ctag = _fetch_cobject(cm, _clip_par(cm, 2));

	CHECKOPT(1,MAP_t); CHECKCOBJ(ctbl, GTK_IS_TEXT_TAG_TABLE(ctbl->object));
	CHECKOPT(2,MAP_t); CHECKCOBJ(ctag, GTK_IS_TEXT_TAG(ctag->object));

	gtk_text_tag_table_remove(GTK_TEXT_TAG_TABLE(ctbl->object),
		GTK_TEXT_TAG(ctag->object));

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextTagTableLookup( textTagTable, textTagName ) --> textTag || NIL
*******************************************************************************/
int
clip_GTK_TEXTTAGTABLELOOKUP(ClipMachine * cm)
{
	C_object    *ctbl = _fetch_co_arg(cm);
	const gchar *name ;
	GtkTextTag   *tag ;
	C_object    *ctag ;

	CHECKOPT(1,MAP_t); CHECKCOBJ(ctbl, GTK_IS_TEXT_TAG_TABLE(ctbl->object));
	CHECKOPT(2,CHARACTER_t);

	tag = gtk_text_tag_table_lookup(GTK_TEXT_TAG_TABLE(ctbl->object),
        	name );

	if (tag)
	{
		ctag = _list_get_cobject(cm,tag);
		if (!ctag) ctag = _register_object(cm,tag,GTK_TYPE_TEXT_TAG,NULL,NULL);
		if (ctag) _clip_mclone(cm,RETPTR(cm),&ctag->obj);
	}
	return 0;
err:
	return 1;
}

/* Calls the CLIP function for each children */
/*******************************************************************************
* gtk_TextTagTableForeach( textTagTable, ufunc ) -->  NIL
*******************************************************************************/
int
clip_GTK_TEXTTAGTABLEFOREACH (ClipMachine *cm)
{
	C_object *ctbl = _fetch_co_arg(cm);
	ClipVar *cfunc = _clip_spar(cm,2);
	C_var *c;

	CHECKOPT(1,MAP_t); CHECKCOBJ(ctbl, GTK_IS_TEXT_TAG_TABLE(ctbl->object));
	CHECKARG2(2,CCODE_t,PCODE_t);

	c->cm = cm; c->co = ctbl;
	_clip_mclone(cm, &c->cfunc, cfunc);
	gtk_text_tag_table_foreach(GTK_TEXT_TAG_TABLE(ctbl->object),
		(GtkTextTagTableForeach)_text_tag_table_for_each_func,c);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextTagTableGeySize( textTagTable ) -->  nSize
*******************************************************************************/
int
clip_GTK_TEXTTAGTABLEGETSIZE (ClipMachine *cm)
{
	C_object *ctbl = _fetch_co_arg(cm);
        gint      size ;

	CHECKOPT(1,MAP_t); CHECKCOBJ(ctbl, GTK_IS_TEXT_TAG_TABLE(ctbl->object));

	size = gtk_text_tag_table_get_size(GTK_TEXT_TAG_TABLE(ctbl->object));

	_clip_retni(cm, size);
	return 0;
err:
	return 1;
}


