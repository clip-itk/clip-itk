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
	C_widget      *cwid = _fetch_cw_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gboolean     expand = _clip_parl(cm, 3);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG(3, LOGICAL_t);

	gtk_cell_layout_pack_start(GTK_CELL_LAYOUT(cwid->widget), GTK_CELL_RENDERER(crenderer->object), expand);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTPACKEND(ClipMachine * cm)
{
	C_widget      *cwid = _fetch_cw_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gboolean     expand = _clip_parl(cm, 3);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG(3, LOGICAL_t);

	gtk_cell_layout_pack_end(GTK_CELL_LAYOUT(cwid->widget), GTK_CELL_RENDERER(crenderer->object), expand);
	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTREORDER(ClipMachine * cm)
{
	C_widget      *cwid = _fetch_cw_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gint            pos = _clip_parni(cm, 3);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG(3, NUMERIC_t);

	gtk_cell_layout_reorder(GTK_CELL_LAYOUT(cwid->widget), GTK_CELL_RENDERER(crenderer->object), pos);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTCLEAR(ClipMachine * cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

	gtk_cell_layout_clear(GTK_CELL_LAYOUT(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLLAYOUTSETATTRIBUTES(ClipMachine * cm)
{
	C_widget      *cwid = _fetch_cw_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gint      attrn[20] ;
	gchar    *attrs[20] ;
	gint        n, i, j ;

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));

	memset(attrs, 0, sizeof(attrs));
	memset(attrn, 0, sizeof(attrn));
	n = _clip_parinfo(cm, 0);
	for (i=3, j=0; i<n; i+=2, j++)
	{
		CHECKOPT(i, CHARACTER_t);
		CHECKOPT(i+1, NUMERIC_t);
		attrs[j] = _clip_parc(cm, i);
		attrn[j] = _clip_parni(cm, i+1)-1;
	}
	gtk_cell_layout_set_attributes(GTK_CELL_LAYOUT(cwid->widget),
		GTK_CELL_RENDERER(crenderer->object),
		attrs[0], attrn[0],  attrs[1],  attrn[1],  attrs[2],  attrn[2],  attrs[3],  attrn[3],  attrs[4], attrn[4],
		attrs[5], attrn[5],  attrs[6],  attrn[6],  attrs[7],  attrn[7],  attrs[8],  attrn[8],  attrs[9], attrn[9],
		attrs[10],attrn[10], attrs[11], attrn[11], attrs[12], attrn[12], attrs[13], attrn[13], attrs[14],attrn[14],
		attrs[15],attrn[15], attrs[16], attrn[16], attrs[17], attrn[17], attrs[18], attrn[18], attrs[19],attrn[19]
		);

	return 0;
err:
	return 1;
}
/***************************************************************************/
int
clip_GTK_CELLLAYOUTADDATTRIBUTE(ClipMachine * cm)
{
	C_widget      *cwid = _fetch_cw_arg(cm);
	C_object *crenderer = _fetch_cobject(cm, _clip_spar(cm, 2));
	gchar         *attr = _clip_parc(cm, 3);
	gint         column = _clip_parni(cm, 4);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKCOBJ(crenderer, GTK_IS_CELL_RENDERER(crenderer->object));
	CHECKARG(3, CHARACTER_t);
	CHECKARG(4, NUMERIC_t);

	gtk_cell_layout_add_attribute(GTK_CELL_LAYOUT(cwid->widget),
		GTK_CELL_RENDERER(crenderer->object),
		attr, column-1);
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

