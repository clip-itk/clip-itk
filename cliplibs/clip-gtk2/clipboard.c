/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <string.h>

#include "inkey.ch"
#include "clip-gtk2.ch"
#include "clip-gtk2.h"


int
clip_GTK_CLIPBOARDGET(ClipMachine * cm)
{
	C_object     *catom = _fetch_co_arg(cm);
        GtkClipboard *clipb ;
        C_object    *cclipb ;

	if (!catom || catom->type != GDK_TYPE_ATOM)
        	goto err;

	clipb = gtk_clipboard_get((GdkAtom)catom->object);

	if (clipb)
        {
        	cclipb = _register_object(cm, clipb, GTK_TYPE_CLIPBOARD, NULL, NULL);
                if (cclipb) _clip_mclone(cm, RETPTR(cm), &cclipb->obj);
        }
	return 0;
err:
	return 1;
}
/*
static
void _clipboard_get_func(GtkClipboard *clipb, GtkSelectionData *selection_data, guint info, gpointer user_data_or_owner)
{
	//C_var  *cvar = (C_var *)user_data_or_owner;
	return;
}

static
void _clipboard_clear_func(GtkClipboard *clipb, gpointer user_data_or_owner)
{
	//C_var  *cvar = (C_var *)user_data_or_owner;
	return;
}
*/
int
clip_GTK_CLIPBOARDSETWITHDATA(ClipMachine * cm)
{
/*
	C_object     *cclipb = _fetch_co_arg(cm);
        ClipVar   *arrtarget = _clip_spar(cm, 2);
        ClipVar    *cgetfunc = _clip_spar(cm, 3);
        ClipVar  *cclearfunc = _clip_spar(cm, 4);
        GtkTargetEntry *target ;
        gint         n_targets ;
        C_var               *c ;

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;

	gtk_clipboard_set_with_data((GtkClipboard)cclipb->object,
		targets, n_targets,
		(GtkClipboardGetFunc)_clipboard_get_func,
		(GtkClipboardClearFunc)_clipboard_clear_func, c);

	return 0;
err:
*/
	return 1;
}

int
clip_GTK_CLIPBOARDSETWITHOWNER(ClipMachine * cm)
{
/*
	C_object     *cclipb = _fetch_co_arg(cm);
        ClipVar   *arrtarget = _clip_spar(cm, 2);
        ClipVar    *cgetfunc = _clip_spar(cm, 3);
        ClipVar  *cclearfunc = _clip_spar(cm, 4);
        C_object     *cowner = _fetch_cobject(cm, 5);
        GtkTargetEntry *target ;
        gint         n_targets ;
        C_var               *c ;

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;

	gtk_clipboard_set_with_owner((GtkClipboard)cclipb->object,
		targets, n_targets,
		(GtkClipboardGetFunc)_clipboard_get_func,
		(GtkClipboardClearFunc)_clipboard_clear_func,
		(GObject)cowner->object);

	return 0;
err:
*/
	return 1;
}


int
clip_GTK_CLIPBOARDGETOWNER(ClipMachine * cm)
{
	C_object     *cclipb = _fetch_co_arg(cm);
        GObject        *gobj ;
        C_object      *cgobj ;

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;

	gobj = gtk_clipboard_get_owner((GtkClipboard *)cclipb->object);

	if (gobj)
        {
        	cgobj = _register_object(cm, gobj, GTK_TYPE_OBJECT, NULL, NULL);
                if (cgobj) _clip_mclone(cm, RETPTR(cm), &cgobj->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_CLIPBOARDCLEAR(ClipMachine * cm)
{
	C_object     *cclipb = _fetch_co_arg(cm);

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;

	gtk_clipboard_clear((GtkClipboard *)cclipb->object);

	return 0;
err:
	return 1;
}

int
clip_GTK_CLIPBOARDSETTEXT(ClipMachine * cm)
{
	C_object     *cclipb = _fetch_co_arg(cm);
        gchar          *text = _clip_parc(cm, 2);

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;
	CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(text);
	gtk_clipboard_set_text((GtkClipboard *)cclipb->object, text, strlen(text));
        FREE_TEXT(text);

	return 0;
err:
	return 1;
}

static void
_clipboard_received_func(GtkClipboard *clipb, GtkSelectionData *seldata, gpointer data)
{
	C_var *c = (C_var*)data;
	C_object *c_obj = _list_get_cobject(c->cm, clipb);
	ClipVar stack[3];
        C_object *csel;
	ClipVar res;
	if (!c_obj)
		c_obj = _register_object(c->cm, clipb, GTK_TYPE_CLIPBOARD, NULL, NULL);

	csel = _register_object(c->cm, seldata, GTK_TYPE_OBJECT, NULL, NULL);
	if (c_obj)
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		_clip_mclone(c->cw->cmachine, &stack[0], &c->co->obj);
		_clip_mclone(c->cw->cmachine, &stack[1], &c_obj->obj);
		_clip_mclone(c->cw->cmachine, &stack[2], &csel->obj);
		//stack[0] = c->cw->obj;
		//stack[1] = c_obj->obj;
                //stack[2] = csel->obj;
		_clip_eval( c->cm, &(c->cfunc), 3, stack, &res );
		_clip_destroy(c->cm, &res);
		_clip_destroy(c->cm, &stack[0]);
		_clip_destroy(c->cm, &stack[1]);
		_clip_destroy(c->cm, &stack[2]);
	}
}
int
clip_GTK_CLIPBOARDREQUESTCONTENTS(ClipMachine * cm)
{
	C_object     *cclipb = _fetch_co_arg(cm);
        C_object      *catom = _fetch_cobject(cm, _clip_spar(cm, 2));
        ClipVar       *cfunc = _clip_spar(cm, 3);
        C_var               *c ;

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;
	if (!catom || catom->type != GDK_TYPE_ATOM)
        	goto err;
	CHECKARG2(3, PCODE_t, CCODE_t);

	c->cm = cm; c->co = cclipb;
	_clip_mclone(cm, &c->cfunc, cfunc);
	gtk_clipboard_request_contents((GtkClipboard *)cclipb->object,
		(GdkAtom)catom->object,
		(GtkClipboardReceivedFunc)_clipboard_received_func,
		c);

	return 0;
err:
	return 1;
}

static void
_clipboard_text_received_func(GtkClipboard *clipb, const gchar *text, gpointer data)
{
	C_var *c = (C_var*)data;
	C_object *c_obj = _list_get_cobject(c->cm, clipb);
	ClipVar stack[3];
        gchar *te;
        ClipVar t;
	ClipVar res;
	if (!c_obj)
		c_obj = _register_object(c->cm, clipb, GTK_TYPE_CLIPBOARD, NULL, NULL);

	te = (gchar *) text;
	LOCALE_FROM_UTF(te);
        _clip_var_str(te, strlen(te), &t);
        FREE_TEXT(te);
	if (c_obj)
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		memset(&t,0,sizeof(t));
		_clip_mclone(c->cw->cmachine, &stack[0], &c->co->obj);
		_clip_mclone(c->cw->cmachine, &stack[1], &c_obj->obj);
		_clip_mclone(c->cw->cmachine, &stack[2], &t);
		//stack[0] = c->cw->obj;
		//stack[1] = c_obj->obj;
                //stack[2] = t;
		_clip_eval( c->cm, &(c->cfunc), 3, stack, &res );
		_clip_destroy(c->cm, &res);
		_clip_destroy(c->cm, &t);
		_clip_destroy(c->cm, &stack[0]);
		_clip_destroy(c->cm, &stack[1]);
		_clip_destroy(c->cm, &stack[2]);
	}
}

int
clip_GTK_CLIPBOARDREQUESTTEXT(ClipMachine * cm)
{
	C_object     *cclipb = _fetch_co_arg(cm);
        ClipVar       *cfunc = _clip_spar(cm, 2);
        C_var               *c ;

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;
	CHECKARG2(2, PCODE_t, CCODE_t);

	c->cm = cm; c->co = cclipb;
	_clip_mclone(cm, &c->cfunc, cfunc);
	gtk_clipboard_request_text((GtkClipboard *)cclipb->object,
		(GtkClipboardTextReceivedFunc)_clipboard_text_received_func,
		c);

	return 0;
err:
	return 1;
}

int
clip_GTK_CLIPBOARDWAITFORCONTENTS(ClipMachine * cm)
{
	C_object     *cclipb = _fetch_co_arg(cm);
        C_object      *catom = _fetch_cobject(cm, _clip_spar(cm, 2));
        GtkSelectionData *sel ;
        C_object        *csel ;

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;

	if (!catom || catom->type != GDK_TYPE_ATOM)
        	goto err;
	sel = gtk_clipboard_wait_for_contents((GtkClipboard *)cclipb->object,
        	(GdkAtom)catom->object );

	if (sel)
        {
        	csel = _register_object(cm, sel, GTK_TYPE_SELECTION_DATA, NULL, NULL);
                if (csel) _clip_mclone(cm, RETPTR(cm), &csel->obj);
                gtk_selection_data_free(sel);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_CLIPBOARDWAITFORTEXT(ClipMachine * cm)
{
	C_object     *cclipb = _fetch_co_arg(cm);
        gchar          *text ;

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;

	text = gtk_clipboard_wait_for_text((GtkClipboard *)cclipb->object);

	if (text)
        {
        	LOCALE_FROM_UTF(text);
                _clip_retc(cm, text);
                FREE_TEXT(text);
                g_free(text);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_CLIPBOARDWAITISTEXTAVAILABLE(ClipMachine * cm)
{
	C_object     *cclipb = _fetch_co_arg(cm);

	if (!cclipb || cclipb->type != GTK_TYPE_CLIPBOARD)
        	goto err;

	_clip_retl(cm, gtk_clipboard_wait_is_text_available((GtkClipboard *)cclipb->object));

	return 0;
err:
	return 1;
}

