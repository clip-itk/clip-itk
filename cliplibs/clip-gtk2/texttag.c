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
/* Signals table */
static SignalTable text_tag_signals[] =
{

	/*{"event",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_EVENT_SIGNAL},*/
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_text_tag() { return GTK_TYPE_TEXT_TAG; }
CLIP_DLLEXPORT GtkType _gtk_type_text_attributes() { return GTK_TYPE_TEXT_ATTRIBUTES; }

long _clip_type_text_tag() { return GTK_OBJECT_TEXT_TAG; }
long _clip_type_text_attributes() { return GTK_OBJECT_TEXT_ATTRIBUTES; }

const char * _clip_type_name_text_tag()  { return "GTK_OBJECT_TEXT_TAG"; }
const char * _clip_type_name_text_attributes()  { return "GTK_OBJECT_TEXT_ATTRIBUTES"; }

int
clip_INIT___TEXTTAG(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_text_tag,  _clip_type_name_text_tag,  _gtk_type_text_tag,  NULL, text_tag_signals);
	_wtype_table_put(_clip_type_text_attributes,  _clip_type_name_text_attributes,  _gtk_type_text_attributes,  NULL, NULL);
	return 0;
}

/*******************************************************************************
* gtk_TextTagNew( tagObj, sTagName ) --> textTagObj
*******************************************************************************/
int
clip_GTK_TEXTTAGNEW(ClipMachine * cm)
{

        ClipVar     *cv = _clip_spar(cm, 1);
        gchar     *name = _clip_parc(cm, 2);
        GtkTextTag *tag ;
        C_object  *ctag ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	tag = gtk_text_tag_new( name );

	if (tag)
	{
		ctag = _list_get_cobject(cm,tag);
		if (!ctag) ctag = _register_object(cm,tag,GTK_TYPE_TEXT_TAG,cv,NULL);
		if (ctag) _clip_mclone(cm,RETPTR(cm),&ctag->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextTagGetPriority( textTag ) --> nPrioroty
*******************************************************************************/
int
clip_GTK_TEXTTAGGETPRIORITY(ClipMachine * cm)
{
	C_object *ctag = _fetch_co_arg(cm);
        gint  priority ;

	CHECKOPT(1,MAP_t); CHECKCOBJ(ctag, GTK_IS_TEXT_TAG(ctag->object));

	priority = gtk_text_tag_get_priority(GTK_TEXT_TAG(ctag->object));

	_clip_retni(cm, priority);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextTagSetPriority( textTag, nPrioroty ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTTAGSETPRIORITY(ClipMachine * cm)
{
	C_object *ctag = _fetch_co_arg(cm);
        gint  priority = _clip_parni(cm, 2);

	CHECKOPT(1,MAP_t); CHECKCOBJ(ctag, GTK_IS_TEXT_TAG(ctag->object));
        CHECKARG(2, NUMERIC_t);

	gtk_text_tag_set_priority(GTK_TEXT_TAG(ctag->object), priority);

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextTagEvent( textTag, eventObj, gdkEvent, textIter ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTTAGEVENT(ClipMachine * cm)
{
	/************
	   U N R E A L I Z E D ! ! !

	C_object *ctag = _fetch_co_arg(cm);

	CHECKOPT(1,MAP_t); CHECKCOBJ(ctag, GTK_IS_TEXT_TAG(ctag->object));
        CHECKARG(2, NUMERIC_t);

	gtk_text_tag_event(GTK_TEXT_TAG(ctag->object), priority);
	return 0;
err:
 	*************/
	return 1;
}

/*******************************************************************************
* gtk_TextAttributesNew( attrObj ) --> textAttrObj
*******************************************************************************/
int
clip_GTK_TEXTATTRIBUTESNEW(ClipMachine * cm)
{

        ClipVar     *cv = _clip_spar(cm, 1);
        C_object  *cattr ;
        GtkTextAttributes *attr ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	attr = gtk_text_attributes_new( );

	if (attr)
	{
		cattr = _list_get_cobject(cm,attr);
		if (!cattr) cattr = _register_object(cm,attr,GTK_TYPE_TEXT_ATTRIBUTES,cv,NULL);
		if (cattr) _clip_mclone(cm,RETPTR(cm),&cattr->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextAttributesCopy( textattrObj ) --> textAttrObj
*******************************************************************************/
int
clip_GTK_TEXTATTRIBUTESCOPY(ClipMachine * cm)
{

        C_object  *cattr = _fetch_co_arg(cm);
        GtkTextAttributes *attrN ;
        C_object *cattrN ;

	CHECKOPT(1,MAP_t); CHECKCOBJ(cattr, GTK_IS_TEXT_ATTRIBUTES(cattr));

	attrN = gtk_text_attributes_copy( GTK_TEXT_ATTRIBUTES(cattr->object) );

	if (attrN)
	{
		cattrN = _list_get_cobject(cm,attrN);
		if (!cattrN) cattrN = _register_object(cm,attrN,GTK_TYPE_TEXT_ATTRIBUTES,NULL,NULL);
		if (cattrN) _clip_mclone(cm,RETPTR(cm),&cattrN->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextAttributesCopyValues( textAttrSrc, @textAttrDest ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTATTRIBUTESCOPYVALUES(ClipMachine * cm)
{

        C_object  *cattr = _fetch_co_arg(cm);
        C_object *cattrN = _fetch_cobject(cm, _clip_par(cm, 2));
        GtkTextAttributes *attrN ;


	CHECKOPT(1,MAP_t); CHECKCOBJ(cattr, GTK_IS_TEXT_ATTRIBUTES(cattr));
	CHECKOPT(2,MAP_t); CHECKCOBJ(cattrN, GTK_IS_TEXT_ATTRIBUTES(cattrN));

	attrN = GTK_TEXT_ATTRIBUTES(cattrN->object);
	gtk_text_attributes_copy_values( GTK_TEXT_ATTRIBUTES(cattr->object),
		attrN );

	if (attrN)
	{
		cattrN = _list_get_cobject(cm,attrN);
		if (!cattrN) cattrN = _register_object(cm,attrN,GTK_TYPE_TEXT_ATTRIBUTES,NULL,NULL);
		if (cattrN) _clip_mclone(cm,_clip_spar(cm,2),&cattrN->obj);
	}

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextAttributesUnref( textAttr ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTATTRIBUTESUNREF(ClipMachine * cm)
{

        C_object  *cattr = _fetch_co_arg(cm);


	CHECKOPT(1,MAP_t); CHECKCOBJ(cattr, GTK_IS_TEXT_ATTRIBUTES(cattr));

	gtk_text_attributes_unref( GTK_TEXT_ATTRIBUTES(cattr->object) );

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextAttributesRef( textAttr ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTATTRIBUTESREF(ClipMachine * cm)
{

        C_object  *cattr = _fetch_co_arg(cm);


	CHECKOPT(1,MAP_t); CHECKCOBJ(cattr, GTK_IS_TEXT_ATTRIBUTES(cattr));

	gtk_text_attributes_ref( GTK_TEXT_ATTRIBUTES(cattr->object) );

	return 0;
err:
	return 1;
}


