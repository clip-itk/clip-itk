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
/*
static gint
handle_tree_model_row_changed (GtkTreeModel *treemodel, GtkTypeTreePath arg1, GtkTypeTreeIter arg2, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	_clip_mputc(cs->co->cmachine, &cv, HASH_PATHSTRING, arg1);
	_clip_mputn(cs->co->cmachine, &cv, HASH_ARG2, arg2);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
*/
/* Signals table */
static SignalTable tree_model_signals[] =
{

	/*
	{"row-changed",	GSF( handle_tree_model_row_changed ), ESF( object_emit_signal ), GTK_TREE_MODEL_ROW_CHANGED_SIGNAL},
	{"row-deleted",	GSF(  ), ESF( object_emit_signal ), GTK_TREE_UNSELECT_ROW_SIGNAL},
	{"row-has-child-toggled", GSF( ), ESF( object_emit_signal ), GTK_TREE_EXPAND_SIGNAL},
	{"row-inserted",	GSF( ), ESF( object_emit_signal ), GTK_TREE_COLLAPSE_SIGNAL},
	{"rows-reordered", GSF(  ), ESF( object_emit_signal ), GTK_TREE_MOVE_SIGNAL},
	{"change-focus-row-expansion", 	GSF(  ), ESF( object_emit_signal ), GTK_CHANGE_FOCUS_ROW_EXPANSION_SIGNAL},
        */
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_tree_model() { return GTK_TYPE_TREE_MODEL; }
CLIP_DLLEXPORT GtkType _gtk_type_tree_path() { return GTK_TYPE_TREE_PATH; }
CLIP_DLLEXPORT GtkType _gtk_type_tree_iter() { return GTK_TYPE_TREE_ITER; }

long _clip_type_tree_model() { return GTK_OBJECT_TREE_MODEL; }
long _clip_type_tree_path() { return GTK_OBJECT_TREE_PATH; }
long _clip_type_tree_iter() { return GTK_OBJECT_TREE_ITER; }

const char * _clip_type_name_tree_model()  { return "GTK_TYPE_TREE_MODEL"; }
const char * _clip_type_name_tree_path()  { return "GTK_TYPE_TREE_PATH"; }
const char * _clip_type_name_tree_iter()  { return "GTK_TYPE_TREE_ITER"; }

/* Register boxes in global table */
int
clip_INIT___TREEMODEL(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_tree_model,  _clip_type_name_tree_model,  _gtk_type_tree_model,  NULL, tree_model_signals);
	_wtype_table_put(_clip_type_tree_path,  _clip_type_name_tree_path,  _gtk_type_tree_path,  NULL, NULL);
	_wtype_table_put(_clip_type_tree_iter,  _clip_type_name_tree_iter,  _gtk_type_tree_iter,  NULL, NULL);
	return 0;
}

int
clip_GTK_TREEMODEL(ClipMachine * cm)
{
	C_object *ctree   = _fetch_co_arg(cm);
        C_object *cmodel;
        GtkTreeModel *model;

	CHECKOPT2(1,MAP_t, NUMERIC_t);

        CHECKCOBJ(ctree, GTK_IS_TREE_MODEL(ctree->object));

        if GTK_IS_LIST_STORE(ctree->object)
        	model = GTK_TREE_MODEL(GTK_LIST_STORE(ctree->object));
        else if GTK_IS_TREE_STORE(ctree->object)
        	model = GTK_TREE_MODEL(GTK_TREE_STORE(ctree->object));

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

int
clip_GTK_TREEPATHNEW(ClipMachine * cm)
{
	C_object *ctreepath;
        GtkTreePath *treepath;

        treepath = gtk_tree_path_new();
	if (treepath)
	{
		ctreepath = _list_get_cobject(cm,treepath);
		if (!ctreepath) ctreepath = _register_object(cm,treepath,GTK_TYPE_TREE_PATH,NULL,NULL);
		if (ctreepath) _clip_mclone(cm,RETPTR(cm),&ctreepath->obj);
	}
	return 0;
}

int
clip_GTK_TREEPATHNEWFROMSTRING(ClipMachine * cm)
{
	gchar *str         = _clip_parc(cm, 1);
	C_object *ctreepath;
        GtkTreePath *treepath;

        CHECKARG(1, CHARACTER_t);

        treepath = gtk_tree_path_new_from_string(str);
	if (treepath)
	{
		ctreepath = _list_get_cobject(cm,treepath);
		if (!ctreepath) ctreepath = _register_object(cm,treepath,GTK_TYPE_TREE_PATH,NULL,NULL);
		if (ctreepath) _clip_mclone(cm,RETPTR(cm),&ctreepath->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEPATHTOSTRING(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);
	gchar *str;

	CHECKARG(1,MAP_t);

        str = gtk_tree_path_to_string(GTK_TREE_PATH(ctreepath->object));

	_clip_retc(cm, str);
	return 0;
err:
	return 1;
}


int
clip_GTK_TREEPATHNEWFIRST(ClipMachine * cm)
{
	C_object *ctreepath;
        GtkTreePath *treepath;

        treepath = gtk_tree_path_new_first();
	if (treepath)
	{
		ctreepath = _list_get_cobject(cm,treepath);
		if (!ctreepath) ctreepath = _register_object(cm,treepath,GTK_TYPE_TREE_PATH,NULL,NULL);
		if (ctreepath) _clip_mclone(cm,RETPTR(cm),&ctreepath->obj);
	}
        return 0;
}

int
clip_GTK_TREEPATHAPPENDINDEX(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);
	gint index          = _clip_parni(cm, 2);

	CHECKARG(1,MAP_t);
	CHECKARG(2, NUMERIC_t);

        gtk_tree_path_append_index(GTK_TREE_PATH(ctreepath->object), index);

	return 0;
err:
	return 1;
}


int
clip_GTK_TREEPATHPREPENDINDEX(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);
	gint index          = _clip_parni(cm, 2);

	CHECKARG(1,MAP_t);
	CHECKARG(2, NUMERIC_t);

        gtk_tree_path_prepend_index(GTK_TREE_PATH(ctreepath->object), index);

	return 0;
err:
	return 1;
}



int
clip_GTK_TREEPATHGETDEPTH(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);
        gint depth;

	CHECKARG(1,MAP_t);

        depth = gtk_tree_path_get_depth(GTK_TREE_PATH(ctreepath->object));

	_clip_retni(cm, depth);
	return 0;
err:
	return 1;
}


int
clip_GTK_TREEPATHGETINDICES(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);
        GtkTreePath *path;
        ClipVar *arr;
        gint *indices;
        gint i;

	CHECKARG(1,MAP_t);

        path = GTK_TREE_PATH(ctreepath->object);
        indices = gtk_tree_path_get_indices(path);

	_clip_array(cm, arr, 0, 0);
	for(i=0; i < gtk_tree_path_get_depth(path); i++)
        {
        	ClipVar *item;
                item = NEW(ClipVar);
                item->t.type = NUMERIC_t;
                item->t.flags = 0;
                item->n.d = indices[i];
        	_clip_aadd(cm, arr, item);
                _clip_delete(cm, item);
	}
	_clip_mclone(cm,RETPTR(cm), arr);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEPATHFREE(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t);

        gtk_tree_path_free(GTK_TREE_PATH(ctreepath->object));

	return 0;
err:
	return 1;
}


int
clip_GTK_TREEPATHCOPY(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);
        C_object *ctreepath1;
        GtkTreePath *path;

	CHECKARG(1,MAP_t);

        path = gtk_tree_path_copy(GTK_TREE_PATH(ctreepath->object));
        ctreepath1 = _list_get_cobject(cm, path);
	if (!ctreepath1) ctreepath1 = _register_object(cm,path,GTK_TYPE_TREE_PATH,NULL,NULL);
        if (ctreepath1) _clip_mclone(cm, RETPTR(cm), &ctreepath1->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEPATHCOMPARE(ClipMachine * cm)
{
	C_object *ctreepath1 = _fetch_co_arg(cm);
        C_object *ctreepath2 = _fetch_cobject(cm, _clip_par(cm, 2));
        gint ret;

	CHECKARG(1,MAP_t);
	CHECKARG(2,MAP_t);

        ret = gtk_tree_path_compare(GTK_TREE_PATH(ctreepath1->object), GTK_TREE_PATH(ctreepath2->object));

	_clip_retni(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEPATHNEXT(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t);

        gtk_tree_path_next(GTK_TREE_PATH(ctreepath->object));

	return 0;
err:
	return 1;
}


int
clip_GTK_TREEPATHPREV(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);
        gboolean ret;

	CHECKARG(1,MAP_t);

        ret = gtk_tree_path_prev(GTK_TREE_PATH(ctreepath->object));

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEPATHUP(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);
        gboolean ret;

	CHECKARG(1,MAP_t);

        ret = gtk_tree_path_up(GTK_TREE_PATH(ctreepath->object));

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEPATHDOWN(ClipMachine * cm)
{
	C_object *ctreepath = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t);

        gtk_tree_path_down(GTK_TREE_PATH(ctreepath->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEPATHISDESCENDANT(ClipMachine * cm)
{
	C_object *ctreepath1 = _fetch_co_arg(cm);
        C_object *ctreepath2 = _fetch_cobject(cm, _clip_spar(cm, 2));
        gboolean ret;

	CHECKARG(1,MAP_t);

        ret = gtk_tree_path_is_descendant(GTK_TREE_PATH(ctreepath1->object), GTK_TREE_PATH(ctreepath2->object));

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEITERCOPY(ClipMachine * cm)
{
	C_object *ctreeiter = _fetch_co_arg(cm);
        C_object *ctreeiter1;
        GtkTreeIter *iter;

	CHECKARG(1,MAP_t);

        iter = gtk_tree_iter_copy(ctreeiter->object);

        ctreeiter1 = _list_get_cobject(cm, iter);
	if (!ctreeiter1) ctreeiter1 = _register_object(cm,iter,GTK_TYPE_TREE_ITER,NULL,NULL);
        if (ctreeiter1) _clip_mclone(cm, RETPTR(cm), &ctreeiter1->obj);

	return 0;
err:
	return 1;
}


int
clip_GTK_TREEITERFREE(ClipMachine * cm)
{
	C_object *ctreeiter = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t);

        gtk_tree_iter_free(ctreeiter->object);

	return 0;
err:
	return 1;
}



int
clip_GTK_TREEMODELGETFLAGS(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        GtkTreeModelFlags flags;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));

        flags = gtk_tree_model_get_flags(GTK_TREE_MODEL(ctreemodel->object));

	_clip_retni(cm, flags);
	return 0;
err:
	return 1;
}



int
clip_GTK_TREEMODELGETNCOLUMNS(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        gint ncolumns;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));

        ncolumns = gtk_tree_model_get_n_columns(GTK_TREE_MODEL(ctreemodel->object));

	_clip_retni(cm, ncolumns);
	return 0;
err:
	return 1;
}



int
clip_GTK_TREEMODELGETCOLUMNTYPE(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        gint index	     = _clip_parni(cm, 2);
        GType type;
        gint t;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, NUMERIC_t);

        type = gtk_tree_model_get_column_type(GTK_TREE_MODEL(ctreemodel->object), index-1);

        switch (type)
        {
        case G_TYPE_STRING:
        	t = CLIP_GTK_TYPE_STRING;
                break;
        case G_TYPE_BOOLEAN:
        	t = CLIP_GTK_TYPE_BOOL;
                break;
        case G_TYPE_FLOAT:
        	t = CLIP_GTK_TYPE_FLOAT;
                break;
        case G_TYPE_DOUBLE:
        	t = CLIP_GTK_TYPE_DOUBLE;
                break;
        case G_TYPE_INT:
        	t = CLIP_GTK_TYPE_INT;
                break;
        case G_TYPE_LONG:
        	t = CLIP_GTK_TYPE_LONG;
                break;
        }
	_clip_retni(cm, t);
	return 0;
err:
	return 1;
}

/*
int
clip_GTK_TREEMODELGETITER(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        ClipVar *treeiter    =  _clip_spar(cm, 2);
        //C_object *ctreeiter    = _fetch_cobject(cm,  _clip_spar(cm, 2));
        C_object *ctreepath  = _fetch_cobject(cm, _clip_spar(cm, 3));
        C_object *ctreeiter;
        GtkTreeIter iter;
        gboolean ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        //CHECKOPT(2, MAP_t);
        CHECKARG(3, MAP_t);

        ret = gtk_tree_model_get_iter(GTK_TREE_MODEL(ctreemodel->object),
        			      &iter,
        			      GTK_TREE_PATH(ctreepath->object));

        ctreeiter = _list_get_cobject(cm, &iter);
	if (!ctreeiter) ctreeiter = _register_object(cm,&iter,GTK_TYPE_TREE_ITER,NULL,NULL);
        if (ctreeiter)
        {
        _clip_mclone(cm, RETPTR(cm), &ctreeiter->obj);
        }
        //if (ctreeiter) _clip_mclone(cm, treeiter, &ctreeiter->obj);
        //if (ctreeiter) _clip_mclone(cm, treeiter, ctreeiter->object);
	//_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}
*/

int
clip_GTK_TREEMODELGETITERFROMSTRING(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        ClipVar *treeiter    = _clip_spar(cm, 2);
        const gchar *path_string  = _clip_parc(cm, 3);
        C_object *ctreeiter;
        GtkTreeIter iter;
        gboolean ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);
        CHECKARG(3, CHARACTER_t);

        ret = gtk_tree_model_get_iter_from_string(
              GTK_TREE_MODEL(ctreemodel->object),
	      &iter,
	      path_string);

        ctreeiter = _list_get_cobject(cm, &iter);
	if (!ctreeiter) ctreeiter = _register_object(cm,&iter,GTK_TYPE_TREE_ITER,NULL,NULL);
        if (ctreeiter) _clip_mclone(cm, treeiter, &ctreeiter->obj);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELGETITERFIRST(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        ClipVar   *treeiter  = _clip_spar(cm, 2);
        C_object *ctreeiter;
        GtkTreeIter iter;
        gboolean ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);

        ret = gtk_tree_model_get_iter_first(
              GTK_TREE_MODEL(ctreemodel->object),
	      &iter);

        ctreeiter = _list_get_cobject(cm, &iter);
	if (!ctreeiter) ctreeiter = _register_object(cm,&iter,GTK_TYPE_TREE_ITER,NULL,NULL);
        if (ctreeiter) _clip_mclone(cm, treeiter, &ctreeiter->obj);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELGETITERROOT(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        ClipVar   *treeiter  = _clip_spar(cm, 2);
        C_object *ctreeiter;
        GtkTreeIter iter;
        gboolean ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);
        CHECKARG(3, CHARACTER_t);

        ret = gtk_tree_model_get_iter_root(GTK_TREE_MODEL(ctreemodel->object),
	      &iter);

        ctreeiter = _list_get_cobject(cm, &iter);
	if (!ctreeiter) ctreeiter = _register_object(cm,&iter,GTK_TYPE_TREE_ITER,NULL,NULL);
        if (ctreeiter) _clip_mclone(cm, treeiter, &ctreeiter->obj);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELGETPATH(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object *ctreeiter  = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object *ctreepath;
        GtkTreePath *path;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);

        path = gtk_tree_model_get_path(GTK_TREE_MODEL(ctreemodel->object),
	      ctreeiter->object);

        ctreepath = _list_get_cobject(cm, path);
	if (!ctreepath) ctreepath = _register_object(cm,path,GTK_TYPE_TREE_PATH,NULL,NULL);
        if (ctreepath) _clip_mclone(cm, RETPTR(cm), &ctreepath->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELGETVALUE(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 2));
        gint          column = _clip_parni(cm, 3);
        GValue         value;
        gchar *str;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);
        CHECKARG(3, NUMERIC_t);

        gtk_tree_model_get_value(GTK_TREE_MODEL(ctreemodel->object),
	      ctreeiter->object, column, &value);

        switch (G_VALUE_TYPE(&value))
        {
        	case G_TYPE_LONG:
                        _clip_retnl(cm, g_value_get_long(&value));
                        break;
        	case G_TYPE_FLOAT:
                        _clip_retnd(cm, g_value_get_float(&value));
                        break;
        	case G_TYPE_STRING:
                        str = (gchar *)g_value_get_string(&value);
                        LOCALE_FROM_UTF(str);
                        _clip_retc(cm, str);
                        FREE_TEXT(str);
                        break;
        	case G_TYPE_BOOLEAN:
                        _clip_retl(cm, g_value_get_boolean(&value));
                        break;
        }

	g_value_unset(&value);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELITERNEXT(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        ClipVar    *treeiter = _clip_spar(cm, 2);
        C_object  *ctreeiter;
        GtkTreeIter     iter;
        gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKOPT(2, MAP_t);

        ret = gtk_tree_model_iter_next(GTK_TREE_MODEL(ctreemodel->object),
	      &iter);

        ctreeiter = _list_get_cobject(cm, &iter);
	if (!ctreeiter) ctreeiter = _register_object(cm,&iter,GTK_TYPE_TREE_ITER,treeiter,NULL);
        if (ctreeiter) _clip_mclone(cm, treeiter, &ctreeiter->obj);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}


int
clip_GTK_TREEMODELITERCHILDREN(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        ClipVar    *treeiter = _clip_spar(cm, 2);
        C_object *ctreeparent = _fetch_cobject(cm, _clip_spar(cm, 3));
        C_object  *ctreeiter;
        GtkTreeIter     iter;
        gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKOPT(2, MAP_t);
        CHECKOPT(3, MAP_t);

        ret = gtk_tree_model_iter_children(GTK_TREE_MODEL(ctreemodel->object),
	      &iter, ctreeparent->object);

        ctreeiter = _list_get_cobject(cm, &iter);
	if (!ctreeiter) ctreeiter = _register_object(cm,&iter,GTK_TYPE_TREE_ITER,treeiter,NULL);
        if (ctreeiter) _clip_mclone(cm, treeiter, &ctreeiter->obj);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}


int
clip_GTK_TREEMODELITERHASCHILD(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 2));
        gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);

        ret = gtk_tree_model_iter_has_child(GTK_TREE_MODEL(ctreemodel->object),
	      ctreeiter->object);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}


int
clip_GTK_TREEMODELITERNCHILDREN(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 2));
        gint             ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKOPT(2, MAP_t);

        ret = gtk_tree_model_iter_n_children(GTK_TREE_MODEL(ctreemodel->object),
	      ctreeiter->object);

	_clip_retni(cm, ret);
	return 0;
err:
	return 1;
}


int
clip_GTK_TREEMODELITERNTHCHILD(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        ClipVar    *treeiter = _clip_spar(cm, 2);
        C_object *ctreeparent = _fetch_cobject(cm, _clip_spar(cm, 3));
        gint                n = _clip_parni(cm, 4);
        C_object  *ctreeiter;
        GtkTreeIter     iter;
        gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKOPT(2, MAP_t);
        CHECKOPT(3, MAP_t);
        CHECKARG(4, NUMERIC_t);

        ret = gtk_tree_model_iter_nth_child(GTK_TREE_MODEL(ctreemodel->object),
	      &iter, ctreeparent->object, n);

        ctreeiter = _list_get_cobject(cm, &iter);
	if (!ctreeiter) ctreeiter = _register_object(cm,&iter,GTK_TYPE_TREE_ITER,treeiter,NULL);
        if (ctreeiter) _clip_mclone(cm, treeiter, &ctreeiter->obj);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELITERPARENT(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        ClipVar    *treeiter = _clip_spar(cm, 2);
        C_object *ctreechild = _fetch_cobject(cm, _clip_spar(cm, 3));
        C_object  *ctreeiter;
        GtkTreeIter     iter;
        gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKOPT(2, MAP_t);
        CHECKOPT(3, MAP_t);

        ret = gtk_tree_model_iter_parent(GTK_TREE_MODEL(ctreemodel->object),
	      &iter, ctreechild->object);

        ctreeiter = _list_get_cobject(cm, &iter);
	if (!ctreeiter) ctreeiter = _register_object(cm,&iter,GTK_TYPE_TREE_ITER,treeiter,NULL);
        if (ctreeiter) _clip_mclone(cm, treeiter, &ctreeiter->obj);

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}


int
clip_GTK_TREEMODELREFNODE(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKOPT(2, MAP_t);

        gtk_tree_model_ref_node(GTK_TREE_MODEL(ctreemodel->object),
	      ctreeiter->object);

	return 0;
err:
	return 1;
}


int
clip_GTK_TREEMODELUNREFNODE(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKOPT(2, MAP_t);

        gtk_tree_model_unref_node(GTK_TREE_MODEL(ctreemodel->object),
	      ctreeiter->object);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELGET(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 2));
        GtkTreeIter    *iter;
        GType       *columns;
        gint               n = _clip_parinfo(cm, 0);
        gint i, x;
        gchar *str;
        glong l;
        gfloat f;
        gboolean b;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);

        if GTK_IS_LIST_STORE(ctreemodel->object)
        	columns = GTK_LIST_STORE(ctreemodel->object)->column_headers;
        else if GTK_IS_TREE_STORE(ctreemodel->object)
        	columns = GTK_TREE_STORE(ctreemodel->object)->column_headers;

	iter = GTK_TREE_ITER(ctreeiter->object);

        for(i=3; i<=n; i+=2)
        {
        	x = _clip_parni(cm, i);
                if (x == -1) break;
                x --;
                switch(columns[x])
                {
                	case G_TYPE_STRING:
                                gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
                                	iter, x, str, -1);
                                _clip_storc(cm, str, i+1, 0);
                        	break;
                	case G_TYPE_BOOLEAN:
                                gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
                                	iter, x, &b, -1);
                                _clip_storl(cm, b, i+1, 0);
                        	break;
                	case G_TYPE_LONG:
                                gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
                                	iter, x, &l, -1);
                                _clip_stornl(cm, l, i+1, 0);
                        	break;
                	case G_TYPE_FLOAT:
                                gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
                                	iter, x, &f, -1);
                                _clip_stornd(cm, f, i+1, 0);
                        	break;
                }
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELGETFROMPATHSTRING(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        //C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 2));
        const gchar    *path = _clip_parc(cm, 2);
        GtkTreeIter    iter;
        GType       *columns;
        gint               n = _clip_parinfo(cm, 0);
        gint i, x;
        gchar *str;
        glong l;
        gfloat f;
        gboolean b;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        //CHECKARG(2, MAP_t);
        CHECKARG(2, CHARACTER_t);

        if GTK_IS_LIST_STORE(ctreemodel->object)
        	columns = GTK_LIST_STORE(ctreemodel->object)->column_headers;
        else if GTK_IS_TREE_STORE(ctreemodel->object)
        	columns = GTK_TREE_STORE(ctreemodel->object)->column_headers;

	gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ctreemodel->object),
		&iter, path);
	//iter = (GtkTreeIter *)(ctreeiter->object);

        for(i=3; i<=n; i+=2)
        {
        	x = _clip_parni(cm, i);
                if (x == -1) break;
                x --;

                switch(columns[x])
                {
                	case G_TYPE_STRING:
                                printf("try string \n");
                                gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
                                	&iter, x, &str, -1);
                                LOCALE_FROM_UTF(str);
                                if (str!= NULL) _clip_storc(cm, str, i+1, 0);
                                FREE_TEXT(str);
                        	break;
                	case G_TYPE_BOOLEAN:
                                gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
                                	&iter, x, &b, -1);
                                _clip_storl(cm, b, i+1, 0);
                        	break;
                	case G_TYPE_LONG:
                                gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
                                	&iter, x, &l, -1);
                                _clip_stornl(cm, l, i+1, 0);
                        	break;
                	case G_TYPE_FLOAT:
                                gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
                                	&iter, x, &f, -1);
                                _clip_stornd(cm, f, i+1, 0);
                        	break;
                }
        }

	return 0;
err:
	return 1;
}


int
clip_GTK_TREEMODELROWCHANGED(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreepath = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);
        CHECKARG(3, MAP_t);

	gtk_tree_model_row_changed(GTK_TREE_MODEL(ctreemodel->object),
		ctreepath->object, ctreeiter->object);

	return 0;
err:
	return 1;
}


int
clip_GTK_TREEMODELROWINSERTED(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreepath = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);
        CHECKARG(3, MAP_t);

	gtk_tree_model_row_inserted(GTK_TREE_MODEL(ctreemodel->object),
		ctreepath->object, ctreeiter->object);

	return 0;
err:
	return 1;
}



int
clip_GTK_TREEMODELROWHASCHILDTOGGLED(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreepath = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);
        CHECKARG(3, MAP_t);

	gtk_tree_model_row_has_child_toggled(GTK_TREE_MODEL(ctreemodel->object),
		ctreepath->object, ctreeiter->object);

	return 0;
err:
	return 1;
}



int
clip_GTK_TREEMODELROWDELETED(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreepath = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);

	gtk_tree_model_row_deleted(GTK_TREE_MODEL(ctreemodel->object),
		ctreepath->object);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELROWSREORDERED(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
        C_object  *ctreepath = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object  *ctreeiter = _fetch_cobject(cm, _clip_spar(cm, 3));
        ClipVar       	 *cv = RETPTR(cm);
        gint      *new_order;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
        CHECKARG(2, MAP_t);

	gtk_tree_model_rows_reordered(GTK_TREE_MODEL(ctreemodel->object),
		ctreepath->object, ctreeiter->object, new_order);

	memset(cv, 0, sizeof(*cv));
//        _clip_array(cm, cv);

	return 0;
err:
	return 1;
}


