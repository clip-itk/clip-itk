
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

/* Signals table */
static gint
handle_action_activated_signal(GtkEntryCompletion *completion, gint index, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
        _clip_mputn(cs->co->cmachine, &cv, HASH_INDEX, index);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static gint
handle_match_selected_signal(GtkEntryCompletion *completion, GtkTreeModel *model, GtkTreeIter *iter, C_signal *cs)
{
	C_object *cmodel, *citer;
	OBJECTPREPARECV(cs,cv);
        cmodel = _list_get_cobject(cs->co->cmachine, model);
        if (!cmodel) cmodel = _register_object(cs->co->cmachine, model, GTK_TYPE_TREE_MODEL, NULL, NULL);
        _clip_madd(cs->co->cmachine, &cv, HASH_TREEMODEL, &cmodel->obj);

        citer = _list_get_cobject(cs->co->cmachine, iter);
        if (!citer) citer = _register_object(cs->co->cmachine, iter, GTK_TYPE_TREE_ITER, NULL, NULL);
        _clip_madd(cs->co->cmachine, &cv, HASH_TREEITER, &citer->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable entry_completion_signals[] =
{
	{"action-activated",	GSF( handle_action_activated_signal ), ESF( object_emit_signal ), GTK_ACTION_ACTIVATED_SIGNAL},
	{"match-selected",	GSF( handle_match_selected_signal ), ESF( object_emit_signal ), GTK_MATCH_SELECTED_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_entry_completion() { return GTK_TYPE_ENTRY_COMPLETION; }

long _clip_type_entry_completion() { return GTK_OBJECT_ENTRY_COMPLETION; }

const char * _clip_type_name_entry_completion()  { return "GTK_OBJECT_ENTRY_COMPLETION"; }

int
clip_INIT___ENTRYCOMPLETION(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_entry_completion,  _clip_type_name_entry_completion,  _gtk_type_entry_completion,  NULL, entry_completion_signals);
	return 0;
}

int
clip_GTK_ENTRYCOMPLETIONNEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        GtkEntryCompletion *completion;
        C_object *ccompletion;

	CHECKOPT(1,MAP_t);

	completion = gtk_entry_completion_new();

	if (completion)
	{
		ccompletion = _list_get_cobject(cm,completion);
		if (!ccompletion) ccompletion = _register_object(cm,completion,GTK_TYPE_ENTRY_COMPLETION,cv,NULL);
		if (ccompletion) _clip_mclone(cm,RETPTR(cm),&ccompletion->obj);
	}

	return 0;
err:
	return 1;
}


int
clip_GTK_ENTRYCOMPLETIONGETENTRY(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        C_widget *cwid;
        GtkWidget *wid;

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));

	wid = gtk_entry_completion_get_entry(GTK_ENTRY_COMPLETION(ccompletion->object));

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
clip_GTK_ENTRYCOMPLETIONSETMODEL(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        C_object *cmodel = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));
	CHECKCOBJ(cmodel, GTK_IS_TREE_MODEL(cmodel->object));

	gtk_entry_completion_set_model(GTK_ENTRY_COMPLETION(ccompletion->object),
		GTK_TREE_MODEL(cmodel->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYCOMPLETIONGETMODEL(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        C_object *cmodel;
        GtkTreeModel *model;

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));

	model = gtk_entry_completion_get_model(GTK_ENTRY_COMPLETION(ccompletion->object));

	if (model)
	{
		cmodel = _list_get_cobject(cm,model);
		if (!cmodel) cmodel = _register_object(cm,model,GTK_TYPE_TREE_MODEL,NULL,NULL);
		if (cmodel) _clip_mclone(cm,RETPTR(cm),&cmodel->obj);
	}
	return 0;
err:
	return 1;
}


static
gboolean _match_func(GtkEntryCompletion *completion, const gchar *key, GtkTreeIter *iter, gpointer data)
{
	C_var *c = (C_var*)data;
	C_object *ccomp = _list_get_cobject(c->cm, completion);
	C_object *citer = _list_get_cobject(c->cm, iter);
	ClipVar stack[4];
	ClipVar res;
        gboolean ret = TRUE;
	if (!ccomp)
		ccomp = _register_object(c->cm,completion,GTK_TYPE_ENTRY_COMPLETION, NULL, NULL);
	if (!citer)
		citer = _register_object(c->cm,iter,GTK_TYPE_TREE_ITER, NULL, NULL);

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cw->cmachine, &stack[0], &c->co->obj);
	_clip_mclone(c->cw->cmachine, &stack[1], &ccomp->obj);
        _clip_var_str((gchar *)key, strlen(key), &stack[2]);
	_clip_mclone(c->cw->cmachine, &stack[3], &citer->obj);

	if ( _clip_eval( c->cm, &(c->cfunc), 4, stack, &res ) == 0 )
        	ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &stack[0]);
	_clip_destroy(c->cm, &stack[1]);
	_clip_destroy(c->cm, &stack[2]);
	_clip_destroy(c->cm, &stack[3]);
	return ret;
}

int
clip_GTK_ENTRYCOMPLETIONSETMATCHFUNC(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        ClipVar  *func = _clip_spar(cm, 2);
        C_var *c;

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));
        CHECKARG2(2, PCODE_t, CCODE_t);

	c->cm = cm; c->co = ccompletion; _clip_mclone(cm, &c->cfunc, func);
	gtk_entry_completion_set_match_func(GTK_ENTRY_COMPLETION(ccompletion->object),
		(GtkEntryCompletionMatchFunc)_match_func, c, NULL);

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYCOMPLETIONSETMINIMUMKEYLENGTH(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        gint length = _clip_parni(cm, 2);

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));
        CHECKARG(2, NUMERIC_t);

	gtk_entry_completion_set_minimum_key_length(GTK_ENTRY_COMPLETION(ccompletion->object),
		length);

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYCOMPLETIONGETMINIMUMKEYLENGTH(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));

	_clip_parni(cm, gtk_entry_completion_get_minimum_key_length(GTK_ENTRY_COMPLETION(ccompletion->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYCOMPLETIONCOMPLETE(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));

	gtk_entry_completion_complete(GTK_ENTRY_COMPLETION(ccompletion->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYCOMPLETIONINSERTACTIONTEXT(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        gint    index = _clip_parni(cm, 2);
        gchar   *text = _clip_parc(cm, 3);

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));
        CHECKARG(2, NUMERIC_t);CHECKARG(3, CHARACTER_t);

	index --;
        LOCALE_TO_UTF(text);
	gtk_entry_completion_insert_action_text(GTK_ENTRY_COMPLETION(ccompletion->object),
		index, text);
	FREE_TEXT(text);

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYCOMPLETIONINSERTACTIONMARKUP(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        gint    index = _clip_parni(cm, 2);
        gchar   *text = _clip_parc(cm, 3);

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));
        CHECKARG(2, NUMERIC_t);CHECKARG(3, CHARACTER_t);

	index --;
        LOCALE_TO_UTF(text);
	gtk_entry_completion_insert_action_markup(GTK_ENTRY_COMPLETION(ccompletion->object),
		index, text);
	FREE_TEXT(text);

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYCOMPLETIONDELETEACTION(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        gint    index = _clip_parni(cm, 2);

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));
        CHECKARG(2, NUMERIC_t);

	index --;
	gtk_entry_completion_delete_action(GTK_ENTRY_COMPLETION(ccompletion->object),
		index);

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYCOMPLETIONSETTEXTCOLUMN(ClipMachine * cm)
{
        C_object *ccompletion   = _fetch_co_arg(cm);
        gint    index = _clip_parni(cm, 2);

	CHECKCOBJ(ccompletion, GTK_IS_ENTRY_COMPLETION(ccompletion->object));
        CHECKARG(2, NUMERIC_t);

	index --;
	gtk_entry_completion_set_text_column(GTK_ENTRY_COMPLETION(ccompletion->object),
		index);

	return 0;
err:
	return 1;
}

