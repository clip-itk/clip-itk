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

static gint
handle_commit_signal(GtkIMContext *imcontext, gchar * arg1,  C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
        _clip_mputc(cs->co->cmachine, &cv, HASH_ARG1, arg1, strlen(arg1));
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static gint
handle_delete_surrounding_signal(GtkIMContext *imcontext, gint arg1, gint arg2,  C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
        _clip_mputn(cs->co->cmachine, &cv, HASH_ARG1, arg1);
        _clip_mputn(cs->co->cmachine, &cv, HASH_ARG2, arg2);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable im_context_signals[] =
{
	{"commit",		GSF( handle_commit_signal ), ESF( object_emit_signal ), GTK_COMMIT_SIGNAL},
	{"delete-surrounding",	GSF( handle_delete_surrounding_signal ), ESF( object_emit_signal ), GTK_DELETE_SURROUNDING_SIGNAL},
	{"preedit-changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_PREEDIT_CHANGED_SIGNAL},
	{"preedit-end",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_PREEDIT_END_SIGNAL},
	{"preedit-start",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_PREEDIT_START_SIGNAL},
	{"retrieve-surrounding",GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_RETRIEVE_SURROUNDING_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_im_context() { return GTK_TYPE_IM_CONTEXT; }

long _clip_type_im_context() { return GTK_OBJECT_IM_CONTEXT; }

const char * _clip_type_name_im_context()  { return "GTK_OBJECT_IM_CONTEXT"; }

/* Register  in global table */
int
clip_INIT___IMCONTEXT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_im_context,  _clip_type_name_im_context,  _gtk_type_im_context,  _gtk_type_object, im_context_signals);
	return 0;
}

CLIP_DLLEXPORT GtkType _gtk_type_im_context_simple() { return GTK_TYPE_IM_CONTEXT_SIMPLE; }

long _clip_type_im_context_simple() { return GTK_OBJECT_IM_CONTEXT_SIMPLE; }

const char * _clip_type_name_im_context_simple()  { return "GTK_OBJECT_IM_CONTEXT_SIMPLE"; }

/* Register  in global table */
int
clip_INIT___IMCONTEXTSIMPLE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_im_context_simple,  _clip_type_name_im_context_simple,  _gtk_type_im_context_simple,  _gtk_type_im_context, NULL);
	return 0;
}

CLIP_DLLEXPORT GtkType _gtk_type_im_multicontext() { return GTK_TYPE_IM_MULTICONTEXT; }

long _clip_type_im_multicontext() { return GTK_OBJECT_IM_MULTICONTEXT; }

const char * _clip_type_name_im_multicontext()  { return "GTK_OBJECT_IM_MULTICONTEXT"; }

/* Register  in global table */
int
clip_INIT___IMMULTICONTEXT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_im_multicontext,  _clip_type_name_im_multicontext,  _gtk_type_im_multicontext,  _gtk_type_im_context, NULL);
	return 0;
}

/******************************************************************************
* gtk_ImContextSetClientWindow(imContextObj, GdkWindowObj) --> NIL
******************************************************************************/
int
clip_GTK_IMCONTEXTSETCLIENTWINDOW(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        C_object       *cwin = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));
	CHECKOPT2(2,MAP_t, NUMERIC_t); CHECKCOBJOPT(cwin, GDK_IS_WINDOW(cwin->object));

        gtk_im_context_set_client_window(GTK_IM_CONTEXT(cimcontext->object),
        	GDK_WINDOW(cwin->object));

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImContextGetPreeditString(imContextObj, @string, @PangoAttrListObj, @cursor_pos) --> NIL
*
******************************************************************************/
int
clip_GTK_IMCONTEXTGETPREEDITSTRING(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        ClipVar      *cvlist = _clip_par(cm, 3);
        gchar        *string ;
        gint      cursor_pos ;
        PangoAttrList  *list ;
        C_object      *clist ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));

        gtk_im_context_get_preedit_string(GTK_IM_CONTEXT(cimcontext->object),
        	&string, &list, &cursor_pos);

	if (list)
        {
		clist = _register_object(cm, list, GTK_TYPE_PANGO_ATTR_LIST, NULL, NULL);
		if (clist) _clip_mclone(cm, cvlist, &clist->obj);
        }

	_clip_storc(cm, string, 2, 0);
	_clip_storni(cm, cursor_pos, 4, 0);

        g_free(string);
        pango_attr_list_unref(list);
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImContextFilterKeypress(imContextObj, GdkEventObj) --> TRUE || FALSE
*
******************************************************************************/
int
clip_GTK_IMCONTEXTFILTERKEYPRESS(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        C_object     *cevent = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));
	CHECKARG(2,MAP_t); CHECKCOBJ(cevent, GDK_IS_EVENT_KEY(cevent));

        _clip_retl(cm, gtk_im_context_filter_keypress(GTK_IM_CONTEXT(cimcontext->object),
        	GDK_EVENT_KEY(cevent->object)));

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImContextFocusIn(imContextObj) --> NIL
*
******************************************************************************/
int
clip_GTK_IMCONTEXTFOCUSIN(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));

        gtk_im_context_focus_in(GTK_IM_CONTEXT(cimcontext->object));

	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ImContextFocusOut(imContextObj) --> NIL
*
******************************************************************************/
int
clip_GTK_IMCONTEXTFOCUSOUT(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));

        gtk_im_context_focus_out(GTK_IM_CONTEXT(cimcontext->object));

	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ImContextReset(imContextObj) --> NIL
*
******************************************************************************/
int
clip_GTK_IMCONTEXTRESET(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));

        gtk_im_context_reset(GTK_IM_CONTEXT(cimcontext->object));

	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ImContextSetCursorLocation(imContextObj, aRectangle) --> NIL
******************************************************************************/
int
clip_GTK_IMCONTEXTSETCURSORLOCATION(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        ClipVar      *cvarea = _clip_spar(cm, 2);
        GdkRectangle    area ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));
        CHECKARG(2, MAP_t);

	_map_get_gdk_rectangle(cm, cvarea, &area);
        gtk_im_context_set_cursor_location(GTK_IM_CONTEXT(cimcontext->object),
        	&area);

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImContextSetUsePreedit(imContextObj, lUse) --> NIL
******************************************************************************/
int
clip_GTK_IMCONTEXTSETUSEPREEDIT(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        gboolean        usep = _clip_parl(cm, 2);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));
        CHECKARG(2, LOGICAL_t);

        gtk_im_context_set_use_preedit(GTK_IM_CONTEXT(cimcontext->object), usep);

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImContextSetSurrounding(imContextObj, sText, ncursor_index) --> NIL
******************************************************************************/
int
clip_GTK_IMCONTEXTSETSURROUNDING(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        gchar          *text = _clip_parc(cm, 2);
        gint      cursor_ind = _clip_parni(cm, 3);
        gint             len ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, NUMERIC_t);

	LOCALE_TO_UTF(text);
	len = strlen(text);
        gtk_im_context_set_surrounding(GTK_IM_CONTEXT(cimcontext->object),
        	text, len, cursor_ind);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImContextGetSurrounding(imContextObj, @sText, @ncursor_index) --> TRUE || FALSE
******************************************************************************/
int
clip_GTK_IMCONTEXTGETSURROUNDING(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        gchar          *text ;
        gint      cursor_ind ;
        gboolean         ret ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));

        ret = gtk_im_context_get_surrounding(GTK_IM_CONTEXT(cimcontext->object),
        	&text, &cursor_ind);
	_clip_retl(cm, ret);
	if (ret)
        {
		LOCALE_FROM_UTF(text);
        	_clip_storc(cm, text, 2, 0);
		FREE_TEXT(text);
        	_clip_storni(cm, cursor_ind, 3, 0);
	}
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImContextDeleteSurrounding(imContextObj, nOffset, nChars) --> TRUE || FALSE
******************************************************************************/
int
clip_GTK_IMCONTEXTDELETESURROUNDING(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        gint          offset = _clip_parni(cm, 2);
        gint           chars = _clip_parni(cm, 3);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT(cimcontext->object));
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, NUMERIC_t);

        _clip_retl(cm, gtk_im_context_delete_surrounding(GTK_IM_CONTEXT(cimcontext->object),
        	offset, chars ));
	return 0;
err:
	return 1;
}

/******************************************************************************
*
*******************************************************************************/

/******************************************************************************
* gtk_ImContextSimpleNew(clipObj) --> imContext new object
******************************************************************************/
int
clip_GTK_IMCONTEXTSIMPLENEW(ClipMachine * cm)
{
	ClipVar             *cv = _clip_spar(cm, 1);
	GtkIMContext *imcontext ;
	C_object    *cimcontext ;

	CHECKOPT(1, MAP_t);

        imcontext = gtk_im_context_simple_new();

	if (imcontext)
        {
        	cimcontext = _register_object(cm, imcontext, GTK_TYPE_IM_CONTEXT, cv, NULL);
                if (cimcontext) _clip_mclone(cm, RETPTR(cm), &cimcontext->obj);
        }
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImContextSimpleAddTable(imContextSimpleObj, arrData, nMax_seq_name, nSeqs) --> NIL
******************************************************************************/
int
clip_GTK_IMCONTEXTSIMPLEADDTABLE(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        ClipVar         *arr = _clip_par(cm, 2);
        gint      max_seq_no = _clip_parni(cm, 3);
        gint           n_seq = _clip_parni(cm, 4);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_CONTEXT_SIMPLE(cimcontext->object));
        CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);

	if (arr)
        {
        	guint16 data[arr->a.count] ;
        	gint       i ;

		for (i=0; i<arr->a.count; i++)
                	data[i] = arr->a.items[i].n.d;
        	gtk_im_context_simple_add_table(GTK_IM_CONTEXT_SIMPLE(cimcontext->object),
        		data, max_seq_no, n_seq );
        }
	return 0;
err:
	return 1;
}


/******************************************************************************
*
*******************************************************************************/

/******************************************************************************
* gtk_ImMultiContextNew(clipObj) --> imContext new object
******************************************************************************/
int
clip_GTK_IMMULTICONTEXTNEW(ClipMachine * cm)
{
	ClipVar             *cv = _clip_spar(cm, 1);
	GtkIMContext *imcontext ;
	C_object    *cimcontext ;

	CHECKOPT(1, MAP_t);

        imcontext = gtk_im_multicontext_new();

	if (imcontext)
        {
        	cimcontext = _register_object(cm, imcontext, GTK_TYPE_IM_CONTEXT, cv, NULL);
                if (cimcontext) _clip_mclone(cm, RETPTR(cm), &cimcontext->obj);
        }
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ImMultiContextAppendMenuitems(imMultiContextObj, menuItemsObj) --> NIL
******************************************************************************/
int
clip_GTK_IMMULTICONTEXTAPPENDMENUITEMS(ClipMachine * cm)
{
	C_object *cimcontext = _fetch_co_arg(cm);
        C_widget      *cmenu = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(cimcontext, GTK_IS_IM_MULTICONTEXT(cimcontext->object));
        CHECKARG2(2, MAP_t, NUMERIC_t); CHECKCWID(cmenu, GTK_IS_MENU_SHELL);

        gtk_im_multicontext_append_menuitems(GTK_IM_MULTICONTEXT(cimcontext->object),
        	GTK_MENU_SHELL(cmenu->widget));

	return 0;
err:
	return 1;
}



