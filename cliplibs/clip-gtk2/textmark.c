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

/* TextMark has no signals */

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_text_mark() { return GTK_TYPE_TEXT_MARK; }

long _clip_type_text_mark() { return GTK_OBJECT_TEXT_MARK; }

const char * _clip_type_name_text_mark()  { return "GTK_TYPE_TEXT_MARK"; }

int
clip_INIT___TEXTMARK(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_text_mark,  _clip_type_name_text_mark,  _gtk_type_text_mark,  NULL, NULL);
	return 0;
}

/******************************************************************************
* gtk_TextMarkSetVisible( textMark, visibility ) --> NIL
******************************************************************************/
int
clip_GTK_TEXTMARKSETVISIBLE(ClipMachine * cm)
{
        C_object       *cmark = _fetch_co_arg(cm);
        gboolean   visibility = _clip_parl(cm, 2);

	CHECKARG(1,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(cmark->object));
        CHECKARG(2, LOGICAL_t);

	gtk_text_mark_set_visible(GTK_TEXT_MARK(cmark->object), visibility);



	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_TextMarkGetVisible( textMark ) --> TRUE || FALSE
******************************************************************************/
int
clip_GTK_TEXTMARKGETVISIBLE(ClipMachine * cm)
{
        C_object       *cmark = _fetch_co_arg(cm);
        gboolean   visibility;

	CHECKARG(1,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(cmark->object));

	visibility = gtk_text_mark_get_visible(GTK_TEXT_MARK(cmark->object));

	_clip_retl(cm, visibility);

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_TextMarkGetDeleted( textMark ) --> TRUE || FALSE
******************************************************************************/
int
clip_GTK_TEXTMARKGETDELETED(ClipMachine * cm)
{
        C_object       *cmark = _fetch_co_arg(cm);
        gboolean      deleted ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(cmark->object));

	deleted = gtk_text_mark_get_deleted(GTK_TEXT_MARK(cmark->object));

	_clip_retl(cm, deleted);

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_TextMarkGetName( textMark ) --> sMarkName
******************************************************************************/
int
clip_GTK_TEXTMARKGETNAME(ClipMachine * cm)
{
        C_object       *cmark = _fetch_co_arg(cm);
        gchar           *name ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(cmark->object));

	name = (gchar *)gtk_text_mark_get_name(GTK_TEXT_MARK(cmark->object));

	_clip_retc(cm, name);

	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_TextMarkGetBuffer( textMark ) --> textBufferObj
******************************************************************************/
int
clip_GTK_TEXTMARKGETBUFFER(ClipMachine * cm)
{
        C_object       *cmark = _fetch_co_arg(cm);
        GtkTextBuffer *buffer ;
        C_object     *cbuffer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(cmark->object));

	buffer = gtk_text_mark_get_buffer(GTK_TEXT_MARK(cmark->object));

	if (buffer)
	{
		cbuffer = _list_get_cobject(cm,buffer);
		if (!cbuffer) cbuffer = _register_object(cm,buffer,GTK_TYPE_TEXT_BUFFER,NULL,NULL);
		if (cbuffer) _clip_mclone(cm,RETPTR(cm),&cbuffer->obj);
	}
	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_TextMarkGetLeftGravity( textMark ) --> TRUE || FALSE
* "left" and "right" here refer to logical direction
* (left is the toward the start of the buffer);
* in some languages such as Hebrew the logically-leftmost text
* is not actually on the left when displayed.
******************************************************************************/
int
clip_GTK_TEXTMARKGETLEFTGRAVITY(ClipMachine * cm)
{
        C_object       *cmark = _fetch_co_arg(cm);
        gboolean      gravity ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(cmark->object));

	gravity = gtk_text_mark_get_left_gravity(GTK_TEXT_MARK(cmark->object));

	_clip_retl(cm, gravity);

	return 0;
err:
	return 1;
}

