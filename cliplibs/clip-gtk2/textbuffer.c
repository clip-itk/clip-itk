/*
    Copyright (C) 2003  ITK
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

static GtkTextIter _Iter;
static GtkTextIter *Iter = &_Iter;

static GtkTextIter _Iter2;
static GtkTextIter *Iter2 = &_Iter2;
/*********************** SIGNALS **************************/
static gint
handle_mark_deleted (GtkTextBuffer *buffer, GtkTextMark *arg1, C_signal *cs)
{
	C_object *cmark;
	OBJECTPREPARECV(cs,cv);
	cmark = _list_get_cobject(cs->cw->cmachine,arg1);
	if (!cmark) cmark = _register_object(cs->cw->cmachine,arg1,GTK_TYPE_TEXT_MARK, NULL, NULL);
	if (cmark) _clip_madd(cs->cw->cmachine, &cv, HASH_MARK, &cmark->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
/* Signals table */
static SignalTable text_buffer_signals[] =
{

	/*{"apply-tag",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_APPLY_TAG_SIGNAL},*/
	{"begin-user-action",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_BEGIN_USER_ACTION_SIGNAL},
	{"changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL},
	/*{"delete-range",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_DELETE_RANGE_SIGNAL},*/
	{"end-user-action",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_END_USER_ACTION_SIGNAL},
	/*{"insert-child-anchor",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_INSERT_CHILD_ANCHOR_SIGNAL},*/
	/*{"insert-pixbuf",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_INSERT_PIXBUF_SIGNAL},*/
	/*{"insert-text",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_INSERT_TEXT_SIGNAL},*/
	{"mark-deleted",	GSF( handle_mark_deleted ), ESF( object_emit_signal ), GTK_MARK_DELETED_SIGNAL},
	/*{"mark-set",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_MARK_SET_SIGNAL},*/
	{"modified-changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_MODIFIED_CHANGED_SIGNAL},
	/*{"remove-tag",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_REMOVE_TAG_SIGNAL},*/
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_text_buffer() { return GTK_TYPE_TEXT_BUFFER; }

long _clip_type_text_buffer() { return GTK_OBJECT_TEXT_BUFFER; }

const char * _clip_type_name_text_buffer()  { return "GTK_OBJECT_TEXT_BUFFER"; }

int
clip_INIT___TEXTBUFFER(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_text_buffer,  _clip_type_name_text_buffer,  _gtk_type_text_buffer,  NULL, text_buffer_signals);
	return 0;
}

static int
_tag_set_property(ClipMachine * cm, gint p,  GtkTextTag *tag, const gchar * pname)
{
	long hash;
	C_object *co ;
	GValue value;

	if (pname == NULL) return 0;
	memset(&value, 0, sizeof(value));
	hash = _clip_casehashstr(pname);
	switch (hash)
	{

	case HASH_name:
	case HASH_background:
	case HASH_foreground:
	case HASH_font:
	case HASH_family:
	case HASH_language:
		CHECKARG(p, CHARACTER_t);
		g_value_init(&value,  G_TYPE_STRING);
		g_value_set_string(&value, _clip_parc(cm, p));
		g_object_set_property(G_OBJECT(tag), pname,  &value);
		break;
	case HASH_background_gdk:
	case HASH_foreground_gdk:
		CHECKARG(p, MAP_t);
		g_object_set(G_OBJECT(tag), pname,  (GdkColor *)((_fetch_cobject(cm, _clip_par(cm, p)))->object)); break;
	case HASH_background_stipple:
	case HASH_foreground_stipple:
		co = _fetch_cobject(cm, _clip_par(cm, p));
		CHECKARG(p, MAP_t); CHECKCOBJ(co, GDK_IS_PIXMAP(co->object));
		g_object_set(G_OBJECT(tag), pname, GDK_PIXMAP(co->object)); break;
	case HASH_font_desc:
	/*            PangoFontDescription : Read / Write */ break;
	case HASH_style:
	/*      PangoStyle           : Read / Write */ break;
	case HASH_variant:
	/*        PangoVariant         : Read / Write */ break;
	case HASH_weight:
	case HASH_size:
	case HASH_pixels_above_lines:
	case HASH_pixels_below_lines:
	case HASH_pixels_inside_wrap:
	case HASH_wrap_mode:
	case HASH_justification:
	case HASH_direction:
	case HASH_left_margin:
	case HASH_indent:
	case HASH_right_margin:
	case HASH_rise:
		CHECKARG(p, NUMERIC_t);
		g_value_init(&value,  G_TYPE_INT);
		g_value_set_int(&value, _clip_parni(cm, p));
		g_object_set_property(G_OBJECT(tag), pname, &value);
		break;
	case HASH_stretch:
	/*     PangoStretch         : Read / Write */ break;
	case HASH_size_points:
	case HASH_scale:
		CHECKARG(p, NUMERIC_t);
		g_value_init(&value,  G_TYPE_DOUBLE);
		g_value_set_double(&value, _clip_parnd(cm, p));
		g_object_set_property(G_OBJECT(tag), pname, &value);
		break;
	case HASH_editable:
	case HASH_strikethrough:
	case HASH_background_full_height:
	case HASH_invisible:
	case HASH_background_set:
	case HASH_foreground_set:
	case HASH_background_stipple_set:
	case HASH_foreground_stipple_set:
	case HASH_family_set:
	case HASH_style_set:
	case HASH_variant_set:
	case HASH_weight_set:
	case HASH_stretch_set:
	case HASH_size_set:
	case HASH_scale_set:
	case HASH_pixels_above_lines_set:
	case HASH_pixels_below_lines_set:
	case HASH_pixels_inside_wrap_set:
	case HASH_editable_set:
	case HASH_wrap_mode_set:
	case HASH_justification_set:
	case HASH_left_margin_set:
	case HASH_indent_set:
	case HASH_strikethrough_set:
	case HASH_right_margin_set:
	case HASH_underline_set:
	case HASH_rise_set:
	case HASH_background_full_height_set:
	case HASH_language_set:
	case HASH_tabs_set:
	case HASH_invisible_set:
		CHECKARG(p, LOGICAL_t);
		//g_object_set(G_OBJECT(tag), pname,  _clip_parl(cm, p)); break;
		g_value_init(&value,  G_TYPE_BOOLEAN);
		g_value_set_boolean(&value, _clip_parl(cm, p));
		g_object_set_property(G_OBJECT(tag), pname, &value);
		break;

	case HASH_underline:
	/*   PangoUnderline       : Read / Write */ break;
	case HASH_tabs:
	/*  PangoTabArray        : Read / Write */ break;
	}

	return 0;
err:
	return 1;
}
/*******************************************************************************
* gtk_TextBufferNew( textTagTable ) --> textBufferObj
*******************************************************************************/
int
clip_GTK_TEXTBUFFERNEW(ClipMachine * cm)
{
	C_object *ctbl   = _fetch_co_arg(cm);
	GtkTextBuffer *buffer ;
	C_object     *cbuffer ;

	CHECKOPT(1,MAP_t); CHECKCOBJOPT(ctbl, GTK_IS_TEXT_TAG_TABLE(ctbl->object));

	buffer = gtk_text_buffer_new((ctbl!=NULL)?GTK_TEXT_TAG_TABLE(ctbl->object):NULL);

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

/*******************************************************************************
* gtk_TextBufferGetLineCount( textBuffer ) --> nCount
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETLINECOUNT(ClipMachine * cm)
{
	C_object *cbuffer = _fetch_co_arg(cm);
	gint        count ;

	CHECKOPT(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	count = gtk_text_buffer_get_line_count(GTK_TEXT_BUFFER(cbuffer->object));

	_clip_retni(cm, count);
	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferGetCharCount( textBuffer ) --> nCount
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETCHARCOUNT(ClipMachine * cm)
{
	C_object *cbuffer = _fetch_co_arg(cm);
	gint        count ;

	CHECKOPT(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	count = gtk_text_buffer_get_char_count(GTK_TEXT_BUFFER(cbuffer->object));

	_clip_retni(cm, count);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetTagTable( textBuffer ) --> nCount
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETTAGTABLE(ClipMachine * cm)
{
	C_object      *cbuffer = _fetch_co_arg(cm);
	GtkTextTagTable *table ;
	C_object       *ctable ;

	CHECKOPT(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	table = gtk_text_buffer_get_tag_table(GTK_TEXT_BUFFER(cbuffer->object));

	ctable = _list_get_cobject(cm, table);
	if (!ctable) ctable = _register_object(cm, table, GTK_TYPE_TEXT_TAG_TABLE, NULL, NULL);
	if (ctable) _clip_mclone(cm, RETPTR(cm), &ctable->obj);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsert( textBuffer, textIter, stext, nlen ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERT(ClipMachine * cm)
{
	int l;
	C_object  *cbuffer = _fetch_co_arg(cm);
	C_object    *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	gchar        *text = _clip_parcl(cm, 3, &l);
	gint           len = (_clip_parinfo(cm, 0)==3)?l:_clip_parni(cm, 4);
        gchar         *buf ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3, CHARACTER_t);
	CHECKOPT(4, NUMERIC_t);

	buf = malloc(len+1);
        memcpy(buf, text, len);
        buf[len] = 0;
	LOCALE_TO_UTF(buf);
	gtk_text_buffer_insert(GTK_TEXT_BUFFER(cbuffer->object), GTK_TEXT_ITER(citer->object),
		(const gchar *)buf, strlen(buf));
	FREE_TEXT(buf);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsertAtCursor( textBuffer, stext, nlen ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTATCURSOR(ClipMachine * cm)
{
	int l;
	C_object  *cbuffer = _fetch_co_arg(cm);
	gchar        *text = _clip_parcl(cm, 2, &l);
	gint           len = (_clip_parinfo(cm, 0)==2)?l:_clip_parni(cm, 3);
        gchar         *buf ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2, CHARACTER_t);
	CHECKOPT(3, NUMERIC_t);

	buf = (gchar *)malloc(len+1);
        memcpy(buf, text, len);
        buf[len] = 0;
	LOCALE_TO_UTF(buf);
	gtk_text_buffer_insert_at_cursor(GTK_TEXT_BUFFER(cbuffer->object),
		(const gchar *)buf, strlen(buf));
	FREE_TEXT(buf);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsertInteractive( textBuffer, textIter, stext, nlen, ldefault_editable ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTINTERACTIVE(ClipMachine * cm)
{
	int l;
	C_object  *cbuffer = _fetch_co_arg(cm);
	C_object    *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	gchar        *text = _clip_parcl(cm, 3, &l);
	gint           len = (_clip_parinfo(cm, 3)==UNDEF_t)?l:_clip_parni(cm, 4);
	gboolean  editable = BOOL_OPTION(cm, 5, 1);
	gboolean       ret ;
        gchar         *buf ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3, CHARACTER_t);
	CHECKOPT(4, NUMERIC_t);
	CHECKARG(5, LOGICAL_t);

	buf = malloc(len+1);
        memcpy(buf, text, len);
        buf[len] = 0;
	LOCALE_TO_UTF(buf);
	ret = gtk_text_buffer_insert_interactive(GTK_TEXT_BUFFER(cbuffer->object), GTK_TEXT_ITER(citer->object),
		(const gchar *)buf, strlen(buf), editable);
	FREE_TEXT(buf);
	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsertInteractiveAtCursor( textBuffer, stext, nlen, ldefault_editable ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTINTERACTIVEATCURSOR(ClipMachine * cm)
{
	int l;
	C_object  *cbuffer = _fetch_co_arg(cm);
	gchar        *text = _clip_parcl(cm, 2, &l);
	gint           len = (_clip_parinfo(cm, 2)==UNDEF_t)?l:_clip_parni(cm, 3);
	gboolean  editable = BOOL_OPTION(cm, 4, 1);
	gboolean       ret ;
        gchar         *buf ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2, CHARACTER_t);
	CHECKOPT(3, NUMERIC_t);
	CHECKARG(4, LOGICAL_t);

	buf = malloc(len+1);
        memcpy(buf, text, len);
        buf[len] = 0;
	LOCALE_TO_UTF(buf);
	ret = gtk_text_buffer_insert_interactive_at_cursor(GTK_TEXT_BUFFER(cbuffer->object),
		(const gchar *)buf, strlen(buf), editable);
	FREE_TEXT(buf);
	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsertRange( textBuffer, textIter, textIterStart, textIterEnd ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTRANGE(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object      *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object *citerstart = _fetch_cobject(cm, _clip_par(cm, 3));
	C_object   *citerend = _fetch_cobject(cm, _clip_par(cm, 4));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3,MAP_t); CHECKCOBJ(citerstart, GTK_IS_TEXT_ITER(citerstart));
	CHECKARG(4,MAP_t); CHECKCOBJ(citerend, GTK_IS_TEXT_ITER(citerend));

	gtk_text_buffer_insert_range(GTK_TEXT_BUFFER(cbuffer->object), GTK_TEXT_ITER(citer->object),
		(const GtkTextIter *)(citerstart->object),
		(const GtkTextIter *)(citerend->object));
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsertRangeInteractive( textBuffer, textIter, textIterStart, textIterEnd, leditable ) --> TRUE || FALSE
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTRANGEINTERACTIVE(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object      *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object *citerstart = _fetch_cobject(cm, _clip_par(cm, 3));
	C_object   *citerend = _fetch_cobject(cm, _clip_par(cm, 4));
	gboolean    editable = BOOL_OPTION(cm, 5, 1);
	gboolean         ret ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3,MAP_t); CHECKCOBJ(citerstart, GTK_IS_TEXT_ITER(citerstart));
	CHECKARG(4,MAP_t); CHECKCOBJ(citerend, GTK_IS_TEXT_ITER(citerend));
	CHECKARG(5, LOGICAL_t);

	ret = gtk_text_buffer_insert_range_interactive(GTK_TEXT_BUFFER(cbuffer->object), GTK_TEXT_ITER(citer->object),
		(const GtkTextIter *)(citerstart->object),
		(const GtkTextIter *)(citerend->object),
		editable);
	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsertWithTags( textBuffer, textIter, stext, nlen, textTag, .... ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTWITHTAGS(ClipMachine * cm)
{
	int l;
	C_object  *cbuffer = _fetch_co_arg(cm);
	C_object    *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	gchar        *text = _clip_parcl(cm, 3, &l);
	gint           len = (_clip_parinfo(cm, 0)==3)?l:_clip_parni(cm, 4);
	gint            i, j ;
	gint               n ;
	GtkTextTag *tags[20] ;
        gchar           *buf ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3, CHARACTER_t);
	CHECKOPT(4, NUMERIC_t);

	memset(tags, 0, sizeof(tags));
	n = _clip_parinfo(cm, 0);
	n = (n>20)?20:n;
	for (i=5, j=0; i<=n; i++, j++)
	{
		C_object *ctag = _fetch_cobject(cm, _clip_par(cm, i));
		CHECKARG(i, MAP_t); CHECKCOBJ(ctag, GTK_IS_TEXT_TAG(ctag->object));
		tags[j] = GTK_TEXT_TAG(ctag->object);
	}
	buf = malloc(len+1);
        memcpy(buf, text, len);
        buf[len] = 0;
	LOCALE_TO_UTF(buf);
	gtk_text_buffer_insert_with_tags(GTK_TEXT_BUFFER(cbuffer->object), GTK_TEXT_ITER(citer->object),
		(const gchar *)buf, strlen(buf),
		tags[0],  tags[1],  tags[2],  tags[3],  tags[4],
		tags[5],  tags[6],  tags[7],  tags[8],  tags[9],
		tags[10], tags[11], tags[12], tags[13], tags[14],
		tags[15], tags[16], tags[17], tags[18], tags[19]);
	FREE_TEXT(buf);
	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferInsertWithTagsByName( textBuffer, textIter, stext, nlen, textTagName, .... ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTWITHTAGSBYNAME(ClipMachine * cm)
{
	int l;
	C_object  *cbuffer = _fetch_co_arg(cm);
	C_object    *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	gchar        *text = _clip_parcl(cm, 3, &l);
	gint           len = (_clip_parinfo(cm, 0)==3)?l:_clip_parni(cm, 4);
	gint          i, j ;
	gint             n ;
	const gchar *tags[20] ;
        gchar            *buf ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3, CHARACTER_t);
	CHECKOPT(4, NUMERIC_t);

	memset(tags, 0, sizeof(tags));
	n = _clip_parinfo(cm, 0);
	n = (n>20)?20:n;
	for (i=5, j=0; i<=n; i++, j++)
	{
		CHECKARG(i, CHARACTER_t);
		tags[j] = (const gchar *)_clip_parc(cm, i);
	}
	buf = malloc(len+1);
        memcpy(buf, text, len);
        buf[len] = 0;
	LOCALE_TO_UTF(buf);
	gtk_text_buffer_insert_with_tags_by_name(GTK_TEXT_BUFFER(cbuffer->object), GTK_TEXT_ITER(citer->object),
		(const gchar *)buf, strlen(buf),
		tags[0],  tags[1],  tags[2],  tags[3],  tags[4],
		tags[5],  tags[6],  tags[7],  tags[8],  tags[9],
		tags[10], tags[11], tags[12], tags[13], tags[14],
		tags[15], tags[16], tags[17], tags[18], tags[19]);
	FREE_TEXT(buf);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferDelete( textBuffer, textIterStart, textIterEnd) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERDELETE(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object *citerstart = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object   *citerend = _fetch_cobject(cm, _clip_par(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citerstart, GTK_IS_TEXT_ITER(citerstart));
	CHECKARG(3,MAP_t); CHECKCOBJ(citerend, GTK_IS_TEXT_ITER(citerend));

	gtk_text_buffer_delete(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_ITER(citerstart->object),
		GTK_TEXT_ITER(citerend->object) );
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferDeleteInteractive( textBuffer, textIterStart, textIterEnd, leditable) --> TRUE || FALSE
*******************************************************************************/
int
clip_GTK_TEXTBUFFERDELETEINTERACTIVE(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object *citerstart = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object   *citerend = _fetch_cobject(cm, _clip_par(cm, 3));
	gboolean    editable = BOOL_OPTION(cm, 4, 1);
	gboolean         ret ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citerstart, GTK_IS_TEXT_ITER(citerstart));
	CHECKARG(3,MAP_t); CHECKCOBJ(citerend, GTK_IS_TEXT_ITER(citerend));
	CHECKARG(4, LOGICAL_t);

	ret = gtk_text_buffer_delete_interactive(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_ITER(citerstart->object),
		GTK_TEXT_ITER(citerend->object), editable );
	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferSetText( textBuffer, stext, nlen ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERSETTEXT(ClipMachine * cm)
{
	int l;
	C_object  *cbuffer = _fetch_co_arg(cm);
	gchar        *text = _clip_parcl(cm, 2, &l);
	gint           len = (_clip_parinfo(cm, 0)==2)?l:_clip_parni(cm, 3);
        gchar         *buf ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2, CHARACTER_t);
	CHECKOPT(3, NUMERIC_t);

	buf = malloc(len+1);
        memcpy(buf, text, len);
        buf[len] = 0;
	LOCALE_TO_UTF(buf);
	gtk_text_buffer_set_text(GTK_TEXT_BUFFER(cbuffer->object),
		(const gchar *)buf, strlen(buf));
	FREE_TEXT(buf);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetText( textBuffer, textIterStart, textIterEnd, linclude_hidden_chars ) --> sTextString
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETTEXT(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object *citerstart = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object   *citerend = _fetch_cobject(cm, _clip_par(cm, 3));
	gboolean        incl = BOOL_OPTION(cm, 4, 1);
	gchar           *str ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citerstart, GTK_IS_TEXT_ITER(citerstart));
	CHECKARG(3,MAP_t); CHECKCOBJ(citerend, GTK_IS_TEXT_ITER(citerend));
	CHECKARG(4, LOGICAL_t);

	str = gtk_text_buffer_get_text(GTK_TEXT_BUFFER(cbuffer->object),
		(const GtkTextIter *)(citerstart->object),
		(const GtkTextIter *)(citerend->object),
		incl);
	LOCALE_FROM_UTF(str);
	_clip_retc(cm, str);
	FREE_TEXT(str);
	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferGetSlice( textBuffer, textIterStart, textIterEnd, linclude_hidden_chars ) --> sTextString
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETSLICE(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object *citerstart = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object   *citerend = _fetch_cobject(cm, _clip_par(cm, 3));
	gboolean        incl = BOOL_OPTION(cm, 4, 1);
	gchar           *str ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citerstart, GTK_IS_TEXT_ITER(citerstart));
	CHECKARG(3,MAP_t); CHECKCOBJ(citerend, GTK_IS_TEXT_ITER(citerend));
	CHECKARG(4, LOGICAL_t);

	str = gtk_text_buffer_get_slice(GTK_TEXT_BUFFER(cbuffer->object),
		(const GtkTextIter *)(citerstart->object),
		(const GtkTextIter *)(citerend->object),
		incl);
	LOCALE_FROM_UTF(str);
	_clip_retc(cm, str);
	FREE_TEXT(str);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsertPixbuf( textBuffer, textIter, pixbufObj ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTPIXBUF(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object      *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object    *cpixbuf = _fetch_cobject(cm, _clip_par(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3,MAP_t); CHECKCOBJ(cpixbuf, GDK_IS_PIXBUF(cpixbuf->object));

	gtk_text_buffer_insert_pixbuf(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_ITER(citer->object),
		GDK_PIXBUF(cpixbuf->object));
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferInsertChildAnchor( textBuffer, textIter, textChildAnchor ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERINSERTCHILDANCHOR(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object      *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object    *canchor = _fetch_cobject(cm, _clip_par(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3,MAP_t); CHECKCOBJ(canchor, GTK_IS_TEXT_CHILD_ANCHOR(canchor->object));

	gtk_text_buffer_insert_child_anchor(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_ITER(citer->object),
		GTK_TEXT_CHILD_ANCHOR(canchor->object));
	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferCreateChildAnchor( textBuffer, textIter ) --> textChildAnchor
*******************************************************************************/
int
clip_GTK_TEXTBUFFERCREATECHILDANCHOR(ClipMachine * cm)
{
	C_object    *cbuffer = _fetch_co_arg(cm);
	C_object      *citer = _fetch_cobject(cm, _clip_par(cm, 2));
	GtkTextChildAnchor *anchor ;
	C_object    *canchor ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));

	anchor = gtk_text_buffer_create_child_anchor(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_ITER(citer->object));

	canchor = _list_get_cobject(cm, anchor);
	if (!canchor) canchor = _register_object(cm, anchor, GTK_TYPE_TEXT_CHILD_ANCHOR, NULL, NULL);
	if (canchor) _clip_mclone(cm, RETPTR(cm), &canchor->obj);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferCreateMark( textBuffer, markName, textIter, lleft_gravity ) --> textMark
*******************************************************************************/
int
clip_GTK_TEXTBUFFERCREATEMARK(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	const gchar *markname = _clip_parc(cm, 2);
	C_object       *citer = _fetch_cobject(cm, _clip_par(cm, 3));
	gboolean         left = BOOL_OPTION(cm, 4, 1);
	GtkTextMark     *mark ;
	C_object       *cmark ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2, CHARACTER_t);
	CHECKARG(3,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(4, LOGICAL_t);

	mark = gtk_text_buffer_create_mark(GTK_TEXT_BUFFER(cbuffer->object),
		markname,
		(const GtkTextIter *)(citer->object), left);

	cmark = _list_get_cobject(cm, mark);
	if (!cmark) cmark = _register_object(cm, mark, GTK_TYPE_TEXT_MARK, NULL, NULL);
	if (cmark) _clip_mclone(cm, RETPTR(cm), &cmark->obj);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferMoveMark( textBuffer, textMark, textIter ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERMOVEMARK(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	C_object       *cmark = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object       *citer = _fetch_cobject(cm, _clip_par(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(citer->object));
	CHECKARG(3,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));

	gtk_text_buffer_move_mark(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_MARK(cmark->object),
		(const GtkTextIter *)(citer->object));

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferMoveMarkByName( textBuffer, textMarkName, textIter ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERMOVEMARKBYNAME(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	const gchar     *name = _clip_parc(cm, 2);
	C_object       *citer = _fetch_cobject(cm, _clip_par(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,CHARACTER_t);
	CHECKARG(3,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));

	gtk_text_buffer_move_mark_by_name(GTK_TEXT_BUFFER(cbuffer->object),
		name,
		(const GtkTextIter *)(citer->object));

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferDeleteMark( textBuffer, textMark ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERDELETEMARK(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	C_object       *cmark = _fetch_cobject(cm, _clip_par(cm, 2));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(cmark->object));

	gtk_text_buffer_delete_mark(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_MARK(cmark->object));

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferDeleteMarkByName( textBuffer, textMarkName ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERDELETEMARKBYNAME(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	const gchar     *name = _clip_parc(cm, 2);

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,CHARACTER_t);

	gtk_text_buffer_delete_mark_by_name(GTK_TEXT_BUFFER(cbuffer->object),
		name);

	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferGetMark( textBuffer, markName ) --> textMark
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETMARK(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	const gchar *markname = _clip_parc(cm, 2);
	GtkTextMark     *mark ;
	C_object       *cmark ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2, CHARACTER_t);

	mark = gtk_text_buffer_get_mark(GTK_TEXT_BUFFER(cbuffer->object),
		markname );

	cmark = _list_get_cobject(cm, mark);
	if (!cmark) cmark = _register_object(cm, mark, GTK_TYPE_TEXT_MARK, NULL, NULL);
	if (cmark) _clip_mclone(cm, RETPTR(cm), &cmark->obj);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetInsert( textBuffer ) --> textMark
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETINSERT(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	GtkTextMark     *mark ;
	C_object       *cmark ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	mark = gtk_text_buffer_get_insert(GTK_TEXT_BUFFER(cbuffer->object));

	cmark = _list_get_cobject(cm, mark);
	if (!cmark) cmark = _register_object(cm, mark, GTK_TYPE_TEXT_MARK, NULL, NULL);
	if (cmark) _clip_mclone(cm, RETPTR(cm), &cmark->obj);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetSelectionBound( textBuffer ) --> textMark
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETSELECTIONBOUND(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	GtkTextMark     *mark ;
	C_object       *cmark ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	mark = gtk_text_buffer_get_selection_bound(GTK_TEXT_BUFFER(cbuffer->object));

	cmark = _list_get_cobject(cm, mark);
	if (!cmark) cmark = _register_object(cm, mark, GTK_TYPE_TEXT_MARK, NULL, NULL);
	if (cmark) _clip_mclone(cm, RETPTR(cm), &cmark->obj);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferPlaceCursor( textBuffer, textIter ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERPLACECURSOR(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	C_object       *citer = _fetch_cobject(cm, _clip_par(cm, 2));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));

	gtk_text_buffer_place_cursor(GTK_TEXT_BUFFER(cbuffer->object),
		(const GtkTextIter *)(citer->object));

	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferApplyTag( textBuffer, textTag, textIterStart, textIterEnd ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERAPPLYTAG(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	C_object        *ctag = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object      *cstart = _fetch_cobject(cm, _clip_par(cm, 3));
	C_object        *cend = _fetch_cobject(cm, _clip_par(cm, 4));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(ctag, GTK_IS_TEXT_TAG(ctag->object));
	CHECKARG(3,MAP_t); CHECKCOBJ(cstart, GTK_IS_TEXT_ITER(cstart));
	CHECKARG(4,MAP_t); CHECKCOBJ(cend, GTK_IS_TEXT_ITER(cend));

	gtk_text_buffer_apply_tag(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_TAG(ctag->object),
		(const GtkTextIter *)(cstart->object),
		(const GtkTextIter *)(cend->object));

	return 0;
err:
	return 1;
}
/*******************************************************************************
* gtk_TextBufferRemoveTag( textBuffer, textTag, textIterStart, textIterEnd ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERREMOVETAG(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	C_object        *ctag = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object      *cstart = _fetch_cobject(cm, _clip_par(cm, 3));
	C_object        *cend = _fetch_cobject(cm, _clip_par(cm, 4));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(ctag, GTK_IS_TEXT_TAG(ctag->object));
	CHECKARG(3,MAP_t); CHECKCOBJ(cstart, GTK_IS_TEXT_ITER(cstart));
	CHECKARG(4,MAP_t); CHECKCOBJ(cend, GTK_IS_TEXT_ITER(cend));

	gtk_text_buffer_remove_tag(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_TEXT_TAG(ctag->object),
		(const GtkTextIter *)(cstart->object),
		(const GtkTextIter *)(cend->object));

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferApplyTagByName( textBuffer, textTagName, textIterStart, textIterEnd ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERAPPLYTAGBYNAME(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	const gchar     *name = _clip_parc(cm, 2);
	C_object      *cstart = _fetch_cobject(cm, _clip_par(cm, 3));
	C_object        *cend = _fetch_cobject(cm, _clip_par(cm, 4));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,CHARACTER_t);
	CHECKARG(3,MAP_t); CHECKCOBJ(cstart, GTK_IS_TEXT_ITER(cstart));
	CHECKARG(4,MAP_t); CHECKCOBJ(cend, GTK_IS_TEXT_ITER(cend));

	gtk_text_buffer_apply_tag_by_name(GTK_TEXT_BUFFER(cbuffer->object),
		name,
		(const GtkTextIter *)(cstart->object),
		(const GtkTextIter *)(cend->object));

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferRemoveTagByName( textBuffer, textTagName, textIterStart, textIterEnd ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERREMOVETAGBYNAME(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	const gchar     *name = _clip_parc(cm, 2);
	C_object      *cstart = _fetch_cobject(cm, _clip_par(cm, 3));
	C_object        *cend = _fetch_cobject(cm, _clip_par(cm, 4));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,CHARACTER_t);
	CHECKARG(3,MAP_t); CHECKCOBJ(cstart, GTK_IS_TEXT_ITER(cstart));
	CHECKARG(4,MAP_t); CHECKCOBJ(cend, GTK_IS_TEXT_ITER(cend));

	gtk_text_buffer_remove_tag_by_name(GTK_TEXT_BUFFER(cbuffer->object),
		name,
		(const GtkTextIter *)(cstart->object),
		(const GtkTextIter *)(cend->object));

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferRemoveAllTags( textBuffer, textIterStart, textIterEnd ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERREMOVEALLTAGS(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	C_object      *cstart = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object        *cend = _fetch_cobject(cm, _clip_par(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(cstart, GTK_IS_TEXT_ITER(cstart));
	CHECKARG(3,MAP_t); CHECKCOBJ(cend, GTK_IS_TEXT_ITER(cend));

	gtk_text_buffer_remove_all_tags(GTK_TEXT_BUFFER(cbuffer->object),
		(const GtkTextIter *)(cstart->object),
		(const GtkTextIter *)(cend->object));

	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferCreateTag( textBuffer, tagName, propertyName, val,... ) --> textTag
*******************************************************************************/
int
clip_GTK_TEXTBUFFERCREATETAG(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	const gchar  *tagname = _clip_parc(cm, 2);
	gint             i, j ;
	GtkTextTag       *tag ;
	C_object        *ctag ;


	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,CHARACTER_t);

	tag = gtk_text_buffer_create_tag(GTK_TEXT_BUFFER(cbuffer->object),
		tagname, NULL);
	j = _clip_parinfo(cm, 0);
	for (i=3; i<=j; i+=2)
	{
		CHECKOPT(i, CHARACTER_t);
		_tag_set_property(cm, i+1, tag, _clip_parc(cm, i));

	}

	ctag = _list_get_cobject(cm, tag);
	if (!ctag) ctag = _register_object(cm, tag, GTK_TYPE_TEXT_TAG, NULL, NULL);
	if (ctag) _clip_mclone(cm, RETPTR(cm), &ctag->obj);


	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetIterAtLineOffset( textBuffer, @textIter, nline_number, nchar_offset ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETITERATLINEOFFSET(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	gint             line = _clip_parni(cm, 3);
	gint           offset = _clip_parni(cm, 4);
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

	memset(Iter, 0, sizeof(Iter));
	gtk_text_buffer_get_iter_at_line_offset(GTK_TEXT_BUFFER(cbuffer->object),
		Iter, line, offset);

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetIterAtOffset( textBuffer, @textIter, nchar_offset ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETITERATOFFSET(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	gint           offset = _clip_parni(cm, 3);
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKARG(3, NUMERIC_t);

	memset(Iter, 0, sizeof(Iter));
	gtk_text_buffer_get_iter_at_offset(GTK_TEXT_BUFFER(cbuffer->object),
		Iter, offset);

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferGetIterAtLine( textBuffer, @textIter, nline_number ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETITERATLINE(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	gint             line = _clip_parni(cm, 3);
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKARG(3, NUMERIC_t);

	memset(Iter, 0, sizeof(Iter));
	gtk_text_buffer_get_iter_at_line(GTK_TEXT_BUFFER(cbuffer->object),
		Iter, line);

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetIterAtLineIndex( textBuffer, @textIter, nline_number, nbyte_index ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETITERATLINEINDEX(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	gint             line = _clip_parni(cm, 3);
	gint            index = _clip_parni(cm, 4);
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

	memset(Iter, 0, sizeof(Iter));
	gtk_text_buffer_get_iter_at_line_index(GTK_TEXT_BUFFER(cbuffer->object),
		Iter, line, index);

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetIterAtMark( textBuffer, @textIter, textMark ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETITERATMARK(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	C_object       *cmark = _fetch_cobject(cm, _clip_par(cm, 3));
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKARG(3,MAP_t); CHECKCOBJ(cmark, GTK_IS_TEXT_MARK(cmark->object));

	memset(Iter, 0, sizeof(Iter));
	gtk_text_buffer_get_iter_at_mark(GTK_TEXT_BUFFER(cbuffer->object),
		Iter, GTK_TEXT_MARK(cmark->object));

	if (Iter)
	{
		printf("iter \n");
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) {_clip_mclone(cm, cviter, &citer->obj);
		printf("register ok \n");}
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetIterAtChildAnchor( textBuffer, @textIter, textChildAnchor ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETITERATCHILDANCHOR(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	C_object     *canchor = _fetch_cobject(cm, _clip_par(cm, 3));
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKARG(3,MAP_t); CHECKCOBJ(canchor, GTK_IS_TEXT_CHILD_ANCHOR(canchor->object));

	memset(Iter, 0, sizeof(Iter));
	gtk_text_buffer_get_iter_at_child_anchor(GTK_TEXT_BUFFER(cbuffer->object),
		Iter, GTK_TEXT_CHILD_ANCHOR(canchor->object));

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetStartIter( textBuffer, @textIter ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETSTARTITER(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);

	memset(Iter, 0, sizeof(Iter));
	gtk_text_buffer_get_start_iter(GTK_TEXT_BUFFER(cbuffer->object),
		Iter);

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetEndIter( textBuffer, @textIter ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETENDITER(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);

	memset(Iter, 0, sizeof(Iter));
	gtk_text_buffer_get_end_iter(GTK_TEXT_BUFFER(cbuffer->object),
		Iter);

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetBounds( textBuffer, @textIterStart, @textIterEnd ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETBOUNDS(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	ClipVar      *cviter2 = _clip_par(cm, 3);
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKOPT(3,MAP_t);

	memset(Iter, 0, sizeof(Iter));
	memset(Iter2, 0, sizeof(Iter2));
	gtk_text_buffer_get_bounds(GTK_TEXT_BUFFER(cbuffer->object),
		Iter, Iter2);

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	if (Iter2)
	{
		citer = _register_object(cm, Iter2, GTK_TYPE_TEXT_ITER, cviter2, NULL);
		if (citer) _clip_mclone(cm, cviter2, &citer->obj);
	}
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetModified( textBuffer ) --> TRUE || FALSE
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETMODIFIED(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	gboolean          ret ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	ret = gtk_text_buffer_get_modified(GTK_TEXT_BUFFER(cbuffer->object));

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferSetModified( textBuffer, lmodified|TRUE ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERSETMODIFIED(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	gboolean     modified = BOOL_OPTION(cm, 2, 1);

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2, LOGICAL_t);

	gtk_text_buffer_set_modified(GTK_TEXT_BUFFER(cbuffer->object), modified);

	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferDeleteSelection( textBuffer, linteractive, ldefault_editable ) --> TRUE || FALSE
*******************************************************************************/
int
clip_GTK_TEXTBUFFERDELETESELECTION(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	gboolean  interactive = _clip_parl(cm, 2);
	gboolean     editable = _clip_parl(cm, 3);
	gboolean          ret ;


	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2, LOGICAL_t);
	CHECKARG(3, LOGICAL_t);

	ret = gtk_text_buffer_delete_selection(GTK_TEXT_BUFFER(cbuffer->object),
		interactive, editable);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferPasteClipboard( textBuffer, clipboard, textIter, ldefault_editable ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERPASTECLIPBOARD(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	C_object  *cclipboard = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object       *citer = _fetch_cobject(cm, _clip_par(cm, 3));
	gboolean     editable = _clip_parl(cm, 4);


	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(citer, GTK_IS_TEXT_ITER(citer));
	CHECKARG(3,MAP_t); CHECKCOBJ(cclipboard, GTK_IS_CLIPBOARD(cclipboard));
	CHECKARG(4, LOGICAL_t);

	gtk_text_buffer_paste_clipboard(GTK_TEXT_BUFFER(cbuffer->object),
		GTK_CLIPBOARD(cclipboard->object),
		((citer!=NULL)?GTK_TEXT_ITER(citer->object):NULL),
		editable);


	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferCopyClipboard( textBuffer, @clipboard ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERCOPYCLIPBOARD(ClipMachine * cm)
{
	C_object       *cbuffer = _fetch_co_arg(cm);
	ClipVar    *cvclipboard = _clip_par(cm, 2);
	GtkClipboard *clipboard ;
	C_object    *cclipboard ;


	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);

	gtk_text_buffer_copy_clipboard(GTK_TEXT_BUFFER(cbuffer->object),
		clipboard);

	if (clipboard)
	{
		cclipboard = _register_object(cm, clipboard, GTK_TYPE_CLIPBOARD, cvclipboard, NULL);
		if (cclipboard) _clip_mclone(cm, cvclipboard, &cclipboard->obj);
	}

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferCutClipboard( textBuffer, @clipboard , ldefault_editable) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERCUTCLIPBOARD(ClipMachine * cm)
{
	C_object       *cbuffer = _fetch_co_arg(cm);
	ClipVar    *cvclipboard = _clip_par(cm, 2);
	gboolean       editable = BOOL_OPTION(cm, 3, 1);
	GtkClipboard *clipboard ;
	C_object    *cclipboard ;


	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKARG(3, LOGICAL_t);

	gtk_text_buffer_cut_clipboard(GTK_TEXT_BUFFER(cbuffer->object),
		clipboard, editable);

	if (clipboard)
	{
		cclipboard = _register_object(cm, clipboard, GTK_TYPE_CLIPBOARD, cvclipboard, NULL);
		if (cclipboard) _clip_mclone(cm, cvclipboard, &cclipboard->obj);
	}

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferGetSelectionBounds( textBuffer, @textIterStart, @textIterEnd ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERGETSELECTIONBOUNDS(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);
	ClipVar       *cviter = _clip_par(cm, 2);
	ClipVar      *cviter2 = _clip_par(cm, 3);
	gboolean          ret ;
	C_object       *citer ;

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);
	CHECKOPT(3,MAP_t);

	memset(Iter, 0, sizeof(Iter));
	memset(Iter2, 0, sizeof(Iter2));
	ret = gtk_text_buffer_get_selection_bounds(GTK_TEXT_BUFFER(cbuffer->object),
		Iter, Iter2);

	if (Iter)
	{
		citer = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, cviter, NULL);
		if (citer) _clip_mclone(cm, cviter, &citer->obj);
	}
	if (Iter2)
	{
		citer = _register_object(cm, Iter2, GTK_TYPE_TEXT_ITER, cviter2, NULL);
		if (citer) _clip_mclone(cm, cviter2, &citer->obj);
	}

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferBeginUserAction( textBuffer ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERBEGINUSERACTION(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	gtk_text_buffer_begin_user_action(GTK_TEXT_BUFFER(cbuffer->object));

	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferEndUserAction( textBuffer ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERENDUSERACTION(ClipMachine * cm)
{
	C_object     *cbuffer = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	gtk_text_buffer_end_user_action(GTK_TEXT_BUFFER(cbuffer->object));

	return 0;
err:
	return 1;
}


/*******************************************************************************
* gtk_TextBufferAddSelectionClipboard( textBuffer, @clipboard ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERADDSELECTIONCLIPBOARD(ClipMachine * cm)
{
	C_object       *cbuffer = _fetch_co_arg(cm);
	ClipVar    *cvclipboard = _clip_par(cm, 2);
	GtkClipboard *clipboard ;
	C_object    *cclipboard ;


	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);

	gtk_text_buffer_add_selection_clipboard(GTK_TEXT_BUFFER(cbuffer->object),
		clipboard);

	if (clipboard)
	{
		cclipboard = _register_object(cm, clipboard, GTK_TYPE_CLIPBOARD, cvclipboard, NULL);
		if (cclipboard) _clip_mclone(cm, cvclipboard, &cclipboard->obj);
	}

	return 0;
err:
	return 1;
}

/*******************************************************************************
* gtk_TextBufferRemoveSelectionClipboard( textBuffer, @clipboard ) --> NIL
*******************************************************************************/
int
clip_GTK_TEXTBUFFERREMOVESELECTIONCLIPBOARD(ClipMachine * cm)
{
	C_object       *cbuffer = _fetch_co_arg(cm);
	ClipVar    *cvclipboard = _clip_par(cm, 2);
	GtkClipboard *clipboard ;
	C_object    *cclipboard ;


	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));
	CHECKOPT(2,MAP_t);

	gtk_text_buffer_remove_selection_clipboard(GTK_TEXT_BUFFER(cbuffer->object),
		clipboard);

	if (clipboard)
	{
		cclipboard = _register_object(cm, clipboard, GTK_TYPE_CLIPBOARD, cvclipboard, NULL);
		if (cclipboard) _clip_mclone(cm, cvclipboard, &cclipboard->obj);
	}

	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
int
clip_GTK_TEXTBUFFERSELECTRANGE(ClipMachine * cm)
{
	C_object       *cbuffer = _fetch_co_arg(cm);
	C_object          *cins ;
	C_object        *cbound ;


	CHECKARG(1,MAP_t); CHECKCOBJ(cbuffer, GTK_IS_TEXT_BUFFER(cbuffer->object));

	memset(Iter, 0, sizeof(Iter));
	memset(Iter2, 0, sizeof(Iter2));
	gtk_text_buffer_select_range(GTK_TEXT_BUFFER(cbuffer->object),
		Iter2, Iter2);

	if (Iter)
	{
		cins = _list_get_cobject(cm, Iter);
		if (!cins) cins = _register_object(cm, Iter, GTK_TYPE_TEXT_ITER, NULL, NULL);
		if (cins) _clip_mclone(cm, ARGPTR(cm, 2), &cins->obj);
	}
	if (Iter2)
	{
		cbound = _list_get_cobject(cm, Iter2);
		if (!cbound) cbound = _register_object(cm, Iter2, GTK_TYPE_TEXT_ITER, NULL, NULL);
		if (cbound) _clip_mclone(cm, ARGPTR(cm, 2), &cbound->obj);
	}
	return 0;
err:
	return 1;
}

#endif
