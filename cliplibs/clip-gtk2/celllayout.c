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
/* Ginterface Cell Layout has no signals                  */
/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_cell_layout() { return GTK_TYPE_CELL_LAYOUT; }

long _clip_type_cell_layout() { return GTK_OBJECT_CELL_LAYOUT; }

const char * _clip_type_name_cell_layout()  { return "GTK_OBJECT_CELL_LAYOUT"; }

int
clip_INIT___CELLLAYOUT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_cell_layout,  _clip_type_name_cell_layout,  _gtk_type_cell_layout, NULL, NULL);
	return 0;
}

int
clip_GTK_CELLLAYOUTPACKSTART(ClipMachine * cm)
{
	ClipVar      *cvlay = ARGPTR(cm, 1);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gboolean     expand = _clip_parl(cm, 3);
	GtkCellLayout  *lay ;
	C_object      *clay ;

	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG(3, LOGICAL_t);

	gtk_cell_layout_pack_start(lay, GTK_CELL_RENDERER(crenderer->object), expand);

	if (lay)
	{
		clay = _list_get_cobject(cm, lay);
		if (!clay)  clay = _register_object(cm, lay, GTK_TYPE_CELL_LAYOUT, NULL, NULL);
		if (clay) _clip_mclone(cm, cvlay, &clay->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTPACKEND(ClipMachine * cm)
{
	ClipVar      *cvlay = ARGPTR(cm, 1);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gboolean     expand = _clip_parl(cm, 3);
	GtkCellLayout  *lay ;
	C_object      *clay ;

	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG(3, LOGICAL_t);

	gtk_cell_layout_pack_end(lay, GTK_CELL_RENDERER(crenderer->object), expand);

	if (lay)
	{
		clay = _list_get_cobject(cm, lay);
		if (!clay)  clay = _register_object(cm, lay, GTK_TYPE_CELL_LAYOUT, NULL, NULL);
		if (clay) _clip_mclone(cm, cvlay, &clay->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTREOEDER(ClipMachine * cm)
{
	ClipVar      *cvlay = ARGPTR(cm, 1);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gint            pos = _clip_parni(cm, 3);
	GtkCellLayout  *lay ;
	C_object      *clay ;

	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG(3, NUMERIC_t);

	gtk_cell_layout_reorder(lay, GTK_CELL_RENDERER(crenderer->object), pos);

	if (lay)
	{
		clay = _list_get_cobject(cm, lay);
		if (!clay)  clay = _register_object(cm, lay, GTK_TYPE_CELL_LAYOUT, NULL, NULL);
		if (clay) _clip_mclone(cm, cvlay, &clay->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTCLEAR(ClipMachine * cm)
{
	C_object *clay = _fetch_co_arg(cm);

	CHECKCOBJ(clay, GTK_IS_CELL_LAYOUT(clay->object));

	gtk_cell_layout_clear(GTK_CELL_LAYOUT(clay->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTSETATTRIBUTES(ClipMachine * cm)
{
	C_object      *clay = _fetch_co_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gchar    *attrs[20] ;
	gint           n, i ;

	CHECKCOBJ(clay, GTK_IS_CELL_LAYOUT(clay->object));
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));

	memset(attrs, 0, sizeof(attrs));
	n = _clip_parinfo(cm, 0) - 2;
	n = (n<20)?n:20;
	for (i=0; i<n; i++)
	{
		CHECKOPT(i+2, CHARACTER_t);
		attrs[i] = _clip_parc(cm, i+2);
	}
	gtk_cell_layout_set_attributes(GTK_CELL_LAYOUT(clay->object),
		GTK_CELL_RENDERER(crenderer->object),
		attrs[0], attrs[1], attrs[2], attrs[3], attrs[4],
		attrs[5], attrs[6], attrs[7], attrs[8], attrs[9],
		attrs[10], attrs[11], attrs[12], attrs[13], attrs[14],
		attrs[15], attrs[16], attrs[17], attrs[18], attrs[19]
		);

	return 0;
err:
	return 1;
}
/***************************************************************************/
int
clip_GTK_CELLLAYOUTADDATTRIBUTE(ClipMachine * cm)
{
	C_object      *clay = _fetch_co_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gchar         *attr = _clip_parc(cm, 3);
	gint         column = _clip_parni(cm, 4);

	CHECKCOBJ(clay, GTK_IS_CELL_LAYOUT(clay->object));
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG(3, CHARACTER_t);
	CHECKARG(4, NUMERIC_t);

	gtk_cell_layout_add_attribute(GTK_CELL_LAYOUT(clay->object),
		GTK_CELL_RENDERER(crenderer->object),
		attr, column);
	return 0;
err:
	return 1;
}

static
void _data_func(GtkCellLayout *layout, GtkCellRenderer *renderer, GtkTreeModel *model, GtkTreeIter *iter, gpointer data)
{

	C_var            *c = (C_var*)data;
	C_object      *clay = _list_get_cobject(c->cm, layout);
	C_object *crenderer = _list_get_cobject(c->cm, renderer);
	C_object    *cmodel = _list_get_cobject(c->cm, model);
	C_object     *citer = _list_get_cobject(c->cm, iter);
	ClipVar stack[4];
	ClipVar res;
	if (!clay) clay = _register_object(c->cm, layout, GTK_TYPE_CELL_LAYOUT, NULL, NULL);
	if (!crenderer) crenderer = _register_object(c->cm, renderer, GTK_TYPE_CELL_RENDERER, NULL, NULL);
	if (!cmodel) cmodel = _register_object(c->cm, model, GTK_TYPE_TREE_MODEL, NULL, NULL);
	if (!citer) citer = _register_object(c->cm, iter, GTK_TYPE_TREE_ITER, NULL, NULL);

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cw->cmachine, &stack[0], &clay->obj);
	_clip_mclone(c->cw->cmachine, &stack[1], &crenderer->obj);
	_clip_mclone(c->cw->cmachine, &stack[2], &cmodel->obj);
	_clip_mclone(c->cw->cmachine, &stack[3], &citer->obj);

	_clip_eval( c->cm, &(c->cfunc), 4, stack, &res );

	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &stack[0]);
	_clip_destroy(c->cm, &stack[1]);
	_clip_destroy(c->cm, &stack[2]);
	_clip_destroy(c->cm, &stack[3]);
}
int
clip_GTK_CELLLAYOUTSETCELLDATAFUNC(ClipMachine * cm)
{
	C_object      *clay = _fetch_co_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	ClipVar       *func = _clip_spar(cm, 3);
	C_var            *c ;

	CHECKCOBJ(clay, GTK_IS_CELL_LAYOUT(clay->object));
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG2(3, PCODE_t, CCODE_t);

	c->cm = cm; c->co = clay; _clip_mclone(cm, &c->cfunc, func);

	gtk_cell_layout_set_cell_data_func(GTK_CELL_LAYOUT(clay->object),
		GTK_CELL_RENDERER(crenderer->object),
		(GtkCellLayoutDataFunc)_data_func, c, NULL);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTCLEARATTRIBUTES(ClipMachine * cm)
{
	C_object      *clay = _fetch_co_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCOBJ(clay, GTK_IS_CELL_LAYOUT(clay->object));
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));

	gtk_cell_layout_clear_attributes(GTK_CELL_LAYOUT(clay->object),
		GTK_CELL_RENDERER(crenderer->object));

	return 0;
err:
	return 1;
}

