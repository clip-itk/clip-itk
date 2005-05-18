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
#include <gdk/gdk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

static GtkTreeIter 	_Iter;
static GtkTreeIter 	*Iter = &_Iter;
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
CLIP_DLLEXPORT GtkType _gtk_type_tree_model_sort() { return GTK_TYPE_TREE_MODEL_SORT; }

long _clip_type_tree_model() { return GTK_OBJECT_TREE_MODEL; }
long _clip_type_tree_path() { return GTK_OBJECT_TREE_PATH; }
long _clip_type_tree_iter() { return GTK_OBJECT_TREE_ITER; }
long _clip_type_tree_model_sort() { return GTK_OBJECT_TREE_MODEL_SORT; }

const char * _clip_type_name_tree_model()  { return "GTK_OBJECT_TREE_MODEL"; }
const char * _clip_type_name_tree_path()  { return "GTK_OBJECT_TREE_PATH"; }
const char * _clip_type_name_tree_iter()  { return "GTK_OBJECT_TREE_ITER"; }
const char * _clip_type_name_tree_model_sort()  { return "GTK_OBJECT_TREE_MODEL_SORT"; }

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
CLIP_DLLEXPORT GtkType _gtk_type_tree_model_filter() { return GTK_TYPE_TREE_MODEL_FILTER; }
long _clip_type_tree_model_filter() { return GTK_OBJECT_TREE_MODEL_FILTER; }
const char * _clip_type_name_tree_model_filter()  { return "GTK_OBJECT_TREE_MODEL_FILTER"; }

#endif
/* Register boxes in global table */
int
clip_INIT___TREEMODEL(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_tree_model,  _clip_type_name_tree_model,  _gtk_type_tree_model,  NULL, tree_model_signals);
	_wtype_table_put(_clip_type_tree_path,  _clip_type_name_tree_path,  _gtk_type_tree_path,  NULL, NULL);
	_wtype_table_put(_clip_type_tree_iter,  _clip_type_name_tree_iter,  _gtk_type_tree_iter,  NULL, NULL);
	_wtype_table_put(_clip_type_tree_model_sort,  _clip_type_name_tree_model_sort,  _gtk_type_tree_model_sort,  NULL, NULL);
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
	_wtype_table_put(_clip_type_tree_model_filter,  _clip_type_name_tree_model_filter,  _gtk_type_tree_model_filter,  NULL, NULL);
#endif
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

	CHECKARG(1,MAP_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	Iter = gtk_tree_iter_copy(ctreeiter->object);

	ctreeiter1 = _list_get_cobject(cm, Iter);
	if (!ctreeiter1) ctreeiter1 = _register_object(cm,Iter,GTK_TYPE_TREE_ITER,NULL,NULL);
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
	gboolean ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	//CHECKOPT(2, MAP_t);
	CHECKARG(3, MAP_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	ret = gtk_tree_model_get_iter(GTK_TREE_MODEL(ctreemodel->object),
				      Iter,
				      GTK_TREE_PATH(ctreepath->object));

	ctreeiter = _list_get_cobject(cm, Iter);
	if (!ctreeiter) ctreeiter = _register_object(cm, Iter,GTK_TYPE_TREE_ITER,NULL,NULL);
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
	gboolean ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	CHECKARG(2, MAP_t);
	CHECKARG(3, CHARACTER_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	ret = gtk_tree_model_get_iter_from_string(
	      GTK_TREE_MODEL(ctreemodel->object),
	      Iter,
	      path_string);

	ctreeiter = _list_get_cobject(cm, Iter);
	if (!ctreeiter) ctreeiter = _register_object(cm, Iter,GTK_TYPE_TREE_ITER,NULL,NULL);
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
	gboolean ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	CHECKARG(2, MAP_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	ret = gtk_tree_model_get_iter_first(
	      GTK_TREE_MODEL(ctreemodel->object),
	      Iter);

	ctreeiter = _list_get_cobject(cm, Iter);
	if (!ctreeiter) ctreeiter = _register_object(cm, Iter,GTK_TYPE_TREE_ITER,NULL,NULL);
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
	gboolean ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	CHECKARG(2, MAP_t);
	CHECKARG(3, CHARACTER_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	ret = gtk_tree_model_get_iter_root(GTK_TREE_MODEL(ctreemodel->object),
	      Iter);

	ctreeiter = _list_get_cobject(cm, Iter);
	if (!ctreeiter) ctreeiter = _register_object(cm, Iter,GTK_TYPE_TREE_ITER,NULL,NULL);
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
	gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	CHECKOPT(2, MAP_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	ret = gtk_tree_model_iter_next(GTK_TREE_MODEL(ctreemodel->object),
	      Iter);

	ctreeiter = _list_get_cobject(cm, Iter);
	if (!ctreeiter) ctreeiter = _register_object(cm, Iter,GTK_TYPE_TREE_ITER,treeiter,NULL);
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
	gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	CHECKOPT(2, MAP_t);
	CHECKOPT(3, MAP_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	ret = gtk_tree_model_iter_children(GTK_TREE_MODEL(ctreemodel->object),
	      Iter, ctreeparent->object);

	ctreeiter = _list_get_cobject(cm, Iter);
	if (!ctreeiter) ctreeiter = _register_object(cm, Iter,GTK_TYPE_TREE_ITER,treeiter,NULL);
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
	gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	CHECKOPT(2, MAP_t);
	CHECKOPT(3, MAP_t);
	CHECKARG(4, NUMERIC_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	ret = gtk_tree_model_iter_nth_child(GTK_TREE_MODEL(ctreemodel->object),
	      Iter, ctreeparent->object, n);

	ctreeiter = _list_get_cobject(cm, Iter);
	if (!ctreeiter) ctreeiter = _register_object(cm, Iter,GTK_TYPE_TREE_ITER,treeiter,NULL);
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
	gboolean         ret;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	CHECKOPT(2, MAP_t);
	CHECKOPT(3, MAP_t);

	memset(Iter, 0, sizeof(GtkTreeIter));
	ret = gtk_tree_model_iter_parent(GTK_TREE_MODEL(ctreemodel->object),
	      Iter, ctreechild->object);

	ctreeiter = _list_get_cobject(cm, Iter);
	if (!ctreeiter) ctreeiter = _register_object(cm, Iter,GTK_TYPE_TREE_ITER,treeiter,NULL);
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
        GdkPixbuf *pix;
        C_object  *cpix;
	ClipVar *vv ;

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
			/*case GDK_TYPE_PIXBUF:
				vv = _clip_spar(cm, i+1);
				gtk_tree_model_get(GTK_TREE_MODEL(ctreemodel->object),
					iter, x, pix, -1);
				cpix = _list_get_cobject(cm, pix);
                                if (!cpix)  cpix = _register_object(cm, pix, GDK_TYPE_PIXBUF, NULL, NULL);
				_clip_mclone(cm, vv, &cpix->obj);
				break;*/
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
			       // printf("try string \n");
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

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
int
clip_GTK_TREEMODELFILTERNEW(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object  *ctreepath = _fetch_cobject(cm, _clip_spar(cm, 2));
	C_object  *cnewmodel ;
	GtkTreeModel *newmod ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));
	CHECKCOBJ(ctreepath, GTK_IS_TREE_PATH(ctreepath->object));

	newmod = gtk_tree_model_filter_new(GTK_TREE_MODEL(ctreemodel->object),
		GTK_TREE_PATH(ctreepath->object));

	if (newmod)
	{
		cnewmodel = _list_get_cobject(cm, newmod);
		if (!cnewmodel) cnewmodel = _register_object(cm, newmod, GTK_TYPE_TREE_MODEL, NULL, NULL);
		if (cnewmodel) _clip_mclone(cm, RETPTR(cm), &cnewmodel->obj);
	}
	return 0;
err:
	return 1;
}

static
gboolean _visible_func(GtkTreeModel *model, GtkTreeIter *iter, gpointer data)
{
	C_var *c = (C_var*)data;
	C_object *cmodl = _list_get_cobject(c->cm, model);
	C_object *citer = _list_get_cobject(c->cm, iter);
	ClipVar stack[3];
	ClipVar res;
	gboolean ret = TRUE;
	if (!cmodl)
		cmodl = _register_object(c->cm,model,GTK_TYPE_TREE_MODEL, NULL, NULL);
	if (!citer)
		citer = _register_object(c->cm,iter,GTK_TYPE_TREE_ITER, NULL, NULL);

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cw->cmachine, &stack[0], &c->co->obj);
	_clip_mclone(c->cw->cmachine, &stack[1], &cmodl->obj);
	_clip_mclone(c->cw->cmachine, &stack[2], &citer->obj);

	if ( _clip_eval( c->cm, &(c->cfunc), 3, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &stack[0]);
	_clip_destroy(c->cm, &stack[1]);
	_clip_destroy(c->cm, &stack[2]);
	return ret;
}

int
clip_GTK_TREEMODELFILTERSETVISIBLEFUNC(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	ClipVar        *func = _clip_spar(cm, 2);
	C_var             *c ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));
	CHECKARG2(2, PCODE_t, CCODE_t);

	c->cm = cm; c->co = ctreemodel; _clip_mclone(cm, &c->cfunc, func);
	gtk_tree_model_filter_set_visible_func(GTK_TREE_MODEL_FILTER(ctreemodel->object),
		(GtkTreeModelFilterVisibleFunc)_visible_func, c, NULL);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELFILTERSETVISIBLECOLUMN(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	gint          column = _clip_parni(cm, 2);

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));
	CHECKARG(2, NUMERIC_t);

	column --;
	gtk_tree_model_filter_set_visible_column(GTK_TREE_MODEL_FILTER(ctreemodel->object),
		column);

	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELFILTERGETMODEL(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object  *cnewmodel ;
	GtkTreeModel *newmod ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));

	newmod = gtk_tree_model_filter_get_model(GTK_TREE_MODEL_FILTER(ctreemodel->object));

	if (newmod)
	{
		cnewmodel = _list_get_cobject(cm, newmod);
		if (!cnewmodel) cnewmodel = _register_object(cm, newmod, GTK_TYPE_TREE_MODEL, NULL, NULL);
		if (cnewmodel) _clip_mclone(cm, RETPTR(cm), &cnewmodel->obj);
	}
	return 0;
err:
	return 1;
}
int
clip_GTK_TREEMODELFILTERCONVERTCHILDITERTOITER(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *citer ;
	C_object     *cchild = _fetch_cobject(cm, _clip_spar(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));
	CHECKCOBJ(cchild, GTK_IS_TREE_ITER(cchild->object));

	gtk_tree_model_filter_convert_child_iter_to_iter(
		GTK_TREE_MODEL_FILTER(ctreemodel->object),
		Iter,
		GTK_TREE_ITER(cchild->object));

	if (Iter)
	{
		citer = _list_get_cobject(cm, Iter);
		if (!citer) citer = _register_object(cm, Iter, GTK_TYPE_TREE_ITER, NULL, NULL);
		if (citer) _clip_mclone(cm, ARGPTR(cm,2), &citer->obj);
	}
	return 0;
err:
	return 1;
}
int
clip_GTK_TREEMODELFILTERCONVERTITERTOCHILDITER(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *citer ;
	C_object     *cchild = _fetch_cobject(cm, _clip_spar(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));
	CHECKCOBJ(cchild, GTK_IS_TREE_ITER(cchild->object));

	gtk_tree_model_filter_convert_iter_to_child_iter(
		GTK_TREE_MODEL_FILTER(ctreemodel->object),
		Iter,
		GTK_TREE_ITER(cchild->object));

	if (Iter)
	{
		citer = _list_get_cobject(cm, Iter);
		if (!citer) citer = _register_object(cm, Iter, GTK_TYPE_TREE_ITER, NULL, NULL);
		if (citer) _clip_mclone(cm, ARGPTR(cm, 2), &citer->obj);
	}
	return 0;
err:
	return 1;
}
int
clip_GTK_TREEMODELFILTERCONVERTCHILDPATHTOPATH(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));
	C_object     *cnpath ;
	GtkTreePath   *npath ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));
	CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	npath = gtk_tree_model_filter_convert_child_path_to_path(
		GTK_TREE_MODEL_FILTER(ctreemodel->object),
		GTK_TREE_PATH(cpath->object));

	if (npath)
	{
		cnpath = _list_get_cobject(cm, npath);
		if (!cnpath) cnpath = _register_object(cm, npath, GTK_TYPE_TREE_PATH, NULL, NULL);
		if (cnpath) _clip_mclone(cm, RETPTR(cm), &cnpath->obj);
	}
	return 0;
err:
	return 1;
}
int
clip_GTK_TREEMODELFILTERCONVERTPATHTOCHILDPATH(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));
	C_object     *cnpath ;
	GtkTreePath   *npath ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));
	CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	npath = gtk_tree_model_filter_convert_path_to_child_path(
		GTK_TREE_MODEL_FILTER(ctreemodel->object),
		GTK_TREE_PATH(cpath->object));

	if (npath)
	{
		cnpath = _list_get_cobject(cm, npath);
		if (!cnpath) cnpath = _register_object(cm, npath, GTK_TYPE_TREE_PATH, NULL, NULL);
		if (cnpath) _clip_mclone(cm, RETPTR(cm), &cnpath->obj);
	}
	return 0;
err:
	return 1;
}
int
clip_GTK_TREEMODELFILTERREFILTER(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));

	gtk_tree_model_filter_refilter(GTK_TREE_MODEL_FILTER(ctreemodel->object));
	return 0;
err:
	return 1;
}
int
clip_GTK_TREEMODELFILTERCLEARCACHE(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_FILTER(ctreemodel->object));

	gtk_tree_model_filter_clear_cache(GTK_TREE_MODEL_FILTER(ctreemodel->object));
	return 0;
err:
	return 1;
}
#endif
/******************************************************************************/
/***************************** Gtk tree model SORT ****************************/
/******************************************************************************/

int
clip_GTK_TREEMODELSORNEWWITHMODEL(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object  *cnewmodel ;
	GtkTreeModel *newmod ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL(ctreemodel->object));

	newmod = gtk_tree_model_sort_new_with_model(GTK_TREE_MODEL(ctreemodel->object));

	if (newmod)
	{
		cnewmodel = _list_get_cobject(cm, newmod);
		if (!cnewmodel) cnewmodel = _register_object(cm, newmod, GTK_TYPE_TREE_MODEL, NULL, NULL);
		if (cnewmodel) _clip_mclone(cm, RETPTR(cm), &cnewmodel->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELSORTGETMODEL(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object  *cnewmodel ;
	GtkTreeModel *newmod ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_SORT(ctreemodel->object));

	newmod = gtk_tree_model_sort_get_model(GTK_TREE_MODEL_SORT(ctreemodel->object));

	if (newmod)
	{
		cnewmodel = _list_get_cobject(cm, newmod);
		if (!cnewmodel) cnewmodel = _register_object(cm, newmod, GTK_TYPE_TREE_MODEL, NULL, NULL);
		if (cnewmodel) _clip_mclone(cm, RETPTR(cm), &cnewmodel->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELSORTCONVERTCHILDPATHTOPATH(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));
	C_object     *cnpath ;
	GtkTreePath   *npath ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_SORT(ctreemodel->object));
	CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	npath = gtk_tree_model_sort_convert_child_path_to_path(
		GTK_TREE_MODEL_SORT(ctreemodel->object),
		GTK_TREE_PATH(cpath->object));

	if (npath)
	{
		cnpath = _list_get_cobject(cm, npath);
		if (!cnpath) cnpath = _register_object(cm, npath, GTK_TYPE_TREE_PATH, NULL, NULL);
		if (cnpath) _clip_mclone(cm, RETPTR(cm), &cnpath->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELSORTCONVERTPATHTOCHILDPATH(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));
	C_object     *cnpath ;
	GtkTreePath   *npath ;

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_SORT(ctreemodel->object));
	CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	npath = gtk_tree_model_sort_convert_path_to_child_path(
		GTK_TREE_MODEL_SORT(ctreemodel->object),
		GTK_TREE_PATH(cpath->object));

	if (npath)
	{
		cnpath = _list_get_cobject(cm, npath);
		if (!cnpath) cnpath = _register_object(cm, npath, GTK_TYPE_TREE_PATH, NULL, NULL);
		if (cnpath) _clip_mclone(cm, RETPTR(cm), &cnpath->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELSORTCONVERTCHILDITERTOITER(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *citer ;
	C_object     *cchild = _fetch_cobject(cm, _clip_spar(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_SORT(ctreemodel->object));
	CHECKCOBJ(cchild, GTK_IS_TREE_ITER(cchild->object));

	gtk_tree_model_sort_convert_child_iter_to_iter(
		GTK_TREE_MODEL_SORT(ctreemodel->object),
		Iter,
		GTK_TREE_ITER(cchild->object));

	if (Iter)
	{
		citer = _list_get_cobject(cm, Iter);
		if (!citer) citer = _register_object(cm, Iter, GTK_TYPE_TREE_ITER, NULL, NULL);
		if (citer) _clip_mclone(cm, ARGPTR(cm,2), &citer->obj);
	}
	return 0;
err:
	return 1;
}
int
clip_GTK_TREEMODELSORTCONVERTITERTOCHILDITER(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *citer ;
	C_object     *cchild = _fetch_cobject(cm, _clip_spar(cm, 3));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_SORT(ctreemodel->object));
	CHECKCOBJ(cchild, GTK_IS_TREE_ITER(cchild->object));

	gtk_tree_model_sort_convert_iter_to_child_iter(
		GTK_TREE_MODEL_SORT(ctreemodel->object),
		Iter,
		GTK_TREE_ITER(cchild->object));

	if (Iter)
	{
		citer = _list_get_cobject(cm, Iter);
		if (!citer) citer = _register_object(cm, Iter, GTK_TYPE_TREE_ITER, NULL, NULL);
		if (citer) _clip_mclone(cm, ARGPTR(cm, 2), &citer->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELSORTRESETDEFAULTSORTFUNC(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_SORT(ctreemodel->object));

	gtk_tree_model_sort_reset_default_sort_func(
		GTK_TREE_MODEL_SORT(ctreemodel->object));
	return 0;
err:
	return 1;
}

int
clip_GTK_TREEMODELSORTCLEARCACHE(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_SORT(ctreemodel->object));

	gtk_tree_model_sort_clear_cache(
		GTK_TREE_MODEL_SORT(ctreemodel->object));
	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 2)
int
clip_GTK_TREEMODELSORTITERISVALID(ClipMachine * cm)
{
	C_object *ctreemodel = _fetch_co_arg(cm);
	C_object      *citer = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG(1,MAP_t); CHECKCOBJ(ctreemodel, GTK_IS_TREE_MODEL_SORT(ctreemodel->object));
	CHECKCOBJ(citer, GTK_IS_TREE_ITER(citer->object));

	gtk_tree_model_sort_iter_is_valid(
		GTK_TREE_MODEL_SORT(ctreemodel->object),
		GTK_TREE_ITER(citer->object));

	return 0;
err:
	return 1;
}
#endif
