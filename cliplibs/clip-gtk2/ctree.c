/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <string.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
/* Signal handlers */
gint handle_tree_select_row_signal (GtkWidget *widget, GtkCTreeNode *node, gint column, C_signal *cs)
{
	C_object *cnode = (C_object*)_list_get_cobject(cs->cw->cmachine,node);
	PREPARECV(cs,cv);
	if (!cnode) cnode = _register_object(cs->cw->cmachine,node,GTK_OBJECT_CTREE_NODE,NULL,NULL);
	if (cnode) _clip_madd(cs->cw->cmachine, &cv, HASH_NODE, &cnode->obj);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_COLUMN, column+1);
	INVOKESIGHANDLER(widget,cs,cv);
}

gint handle_tree_unselect_row_signal (GtkWidget *widget, GtkCTreeNode *node, gint column, C_signal *cs)
{
	C_object *cnode = (C_object*)_list_get_cobject(cs->cw->cmachine,node);
	PREPARECV(cs,cv);
	if (!cnode) cnode = _register_object(cs->cw->cmachine,node,GTK_OBJECT_CTREE_NODE,NULL,NULL);
	if (cnode) _clip_madd(cs->cw->cmachine, &cv, HASH_NODE, &cnode->obj);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_COLUMN, column+1);
	INVOKESIGHANDLER(widget,cs,cv);
}

gint handle_tree_expand_signal (GtkWidget *widget, GtkCTreeNode *node, C_signal *cs)
{
	C_object *cnode = (C_object*)_list_get_cobject(cs->cw->cmachine,node);
	PREPARECV(cs,cv);
	if (!cnode) cnode = _register_object(cs->cw->cmachine,node,GTK_OBJECT_CTREE_NODE,NULL,NULL);
	if (cnode) _clip_madd(cs->cw->cmachine, &cv, HASH_NODE, &cnode->obj);
	INVOKESIGHANDLER(widget,cs,cv);
}

gint handle_tree_collapse_signal (GtkWidget *widget, GtkCTreeNode *node, C_signal *cs)
{
	C_object *cnode = (C_object*)_list_get_cobject(cs->cw->cmachine,node);
	PREPARECV(cs,cv);
	if (!cnode) cnode = _register_object(cs->cw->cmachine,node,GTK_OBJECT_CTREE_NODE,NULL,NULL);
	if (cnode) _clip_madd(cs->cw->cmachine, &cv, HASH_NODE, &cnode->obj);
	INVOKESIGHANDLER(widget,cs,cv);
}

gint handle_tree_move_signal (GtkWidget *widget, GtkCTreeNode *node, GtkCTreeNode *new_parent, GtkCTreeNode *new_sibling, C_signal *cs)
{
	C_object *cnode = (C_object*)_list_get_cobject(cs->cw->cmachine,node);
	C_object *cnewparent = (C_object*)_list_get_cobject(cs->cw->cmachine,new_parent);
	C_object *cnewsibling = (C_object*)_list_get_cobject(cs->cw->cmachine,new_sibling);
	PREPARECV(cs,cv);
	if (!cnode) cnode = _register_object(cs->cw->cmachine,node,GTK_OBJECT_CTREE_NODE,NULL,NULL);
	if (!cnewparent) cnode = _register_object(cs->cw->cmachine,new_parent,GTK_OBJECT_CTREE_NODE,NULL,NULL);
	if (!cnewsibling) cnode = _register_object(cs->cw->cmachine,new_sibling,GTK_OBJECT_CTREE_NODE,NULL,NULL);
	if (cnode) _clip_madd(cs->cw->cmachine, &cv, HASH_NODE, &cnode->obj);
	if (cnewparent) _clip_madd(cs->cw->cmachine, &cv, HASH_NEWPARENT, &cnewparent->obj);
	if (cnewsibling) _clip_madd(cs->cw->cmachine, &cv, HASH_NEWSIBLING, &cnewsibling->obj);
	INVOKESIGHANDLER(widget,cs,cv);
}

gint handle_change_focus_row_expansion_signal (GtkWidget *widget, GtkCTreeExpansionType action, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ACTION, action);
	INVOKESIGHANDLER(widget,cs,cv);
}

/* Signals table */
static SignalTable ctree_signals[] =
{
	{"tree-select-row",	GSF( handle_tree_select_row_signal ), ESF( object_emit_signal ), GTK_TREE_SELECT_ROW_SIGNAL},
	{"tree-unselect-row",	GSF( handle_tree_unselect_row_signal ), ESF( object_emit_signal ), GTK_TREE_UNSELECT_ROW_SIGNAL},
	{"tree-expand",		GSF( handle_tree_expand_signal ), ESF( object_emit_signal ), GTK_TREE_EXPAND_SIGNAL},
	{"tree-collapse",	GSF( handle_tree_collapse_signal ), ESF( object_emit_signal ), GTK_TREE_COLLAPSE_SIGNAL},
	{"tree-move",		GSF( handle_tree_move_signal ), ESF( object_emit_signal ), GTK_TREE_MOVE_SIGNAL},
	{"change-focus-row-expansion", 	GSF( handle_change_focus_row_expansion_signal ), ESF( object_emit_signal ), GTK_CHANGE_FOCUS_ROW_EXPANSION_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register CTree in global table */
CLIP_DLLEXPORT GtkType _gtk_type_ctree() { return GTK_TYPE_CTREE; }
long _clip_type_ctree() { return GTK_WIDGET_CTREE; }
const char * _clip_type_name_ctree() { return "GTK_WIDGET_CTREE"; }

int
clip_INIT___CTREE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_ctree, _clip_type_name_ctree, _gtk_type_ctree, _gtk_type_clist, ctree_signals);
	return 0;
}

/**** CTree constructor ****/
int
clip_GTK_CTREENEW(ClipMachine * cm)
{
	ClipVar     * cv = _clip_spar (cm,1);
	gint    ncolumns = _clip_parni(cm,2);
	gint tree_column = _clip_parni(cm,3);
	ClipVar   *cvcol =  _clip_spar(cm,4);
	ClipArrVar *acol;
	int i;
	gchar * empty_string = "\0";
	gchar * * columns = NULL;
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t); CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKOPT2(4,ARRAY_t,CHARACTER_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) ncolumns = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) tree_column = 1;
	switch (cvcol->t.type)
	{
		case CHARACTER_t:
			columns = (gchar**)calloc(sizeof(columns),ncolumns);
#ifdef OS_CYGWIN
			columns[0] = _clip_locale_to_utf8(cvcol->s.str.buf);
#else
			columns[0] = cvcol->s.str.buf;
#endif
			for(i=1; i < ncolumns; i++ )
				columns[i] = empty_string;
			wid = gtk_ctree_new_with_titles(ncolumns,tree_column-1,columns);
#ifdef OS_CYGWIN
			g_free(columns[0]);
#endif
			if (columns) free(columns);
			break;
		case ARRAY_t:
			acol = (ClipArrVar*)_clip_vptr( cvcol );
			columns = (gchar**)calloc(sizeof(columns),ncolumns);
#ifdef OS_CYGWIN
			for(i=0; i < ncolumns; i++ )
			{
				if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
					columns[i] = _clip_locale_to_utf8(acol->items[i].s.str.buf);
				else
					columns[i] = _clip_locale_to_utf8(empty_string);
			}
			wid = gtk_ctree_new_with_titles(ncolumns,tree_column-1,columns);
			for(i=0; i < ncolumns; i++ )
			{
				g_free(columns[i]);
			}
			if (columns) free(columns);
#else
			for(i=0; i < ncolumns; i++ )
			{
				if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
					columns[i] = acol->items[i].s.str.buf;
				else
					columns[i] = empty_string;
			}
			wid = gtk_ctree_new_with_titles(ncolumns,tree_column-1,columns);
			if (columns) free(columns);
#endif
		default:
			wid = gtk_ctree_new(ncolumns,tree_column-1);
	}

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Insert a new node to the tree. The position is specified through the
 * parent-sibling notation, as explained in the introduction above. */
int
clip_GTK_CTREEINSERTNODE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object  *cparent = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object *csibling = _fetch_cobject(cm,_clip_spar(cm,3));
	ClipVar    *cvtext = _clip_spar(cm,4);
	guint8     spacing = _clip_parni(cm,5);
	C_widget  *cclosed = _fetch_cwidget(cm,_clip_spar(cm,6));
	C_widget  *copened = _fetch_cwidget(cm,_clip_spar(cm,7));
	gboolean   is_leaf = _clip_parl(cm,8);
	gboolean  expanded = _clip_parl(cm,9);
	GtkCTreeNode *new_node, *parent=NULL, *sibling=NULL;
	GdkPixmap *pxm_closed=NULL, *pxm_opened=NULL;
	GdkBitmap *mask_closed=NULL, *mask_opened=NULL;
	C_object *cnew_node;
	int i;
	gchar * * columns = NULL;
	int ncolumns;

	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cparent,cparent->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCOBJOPT(csibling,csibling->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT2(4,ARRAY_t,CHARACTER_t); CHECKOPT(5,NUMERIC_t);
	CHECKOPT2(6,MAP_t,NUMERIC_t); CHECKCWIDOPT(cclosed,GTK_IS_PIXMAP);
	CHECKOPT2(7,MAP_t,NUMERIC_t); CHECKCWIDOPT(copened,GTK_IS_PIXMAP);
	CHECKOPT(8,LOGICAL_t); CHECKOPT(9,LOGICAL_t);

	if (cparent) parent = GTK_CTREE_NODE(cparent->object);
	if (csibling) sibling = GTK_CTREE_NODE(csibling->object);
	if (cclosed)
	{
		pxm_closed=GTK_PIXMAP(cclosed->widget)->pixmap;
		mask_closed=GTK_PIXMAP(cclosed->widget)->mask;
	}
	if (copened)
	{
		pxm_opened=GTK_PIXMAP(copened->widget)->pixmap;
		mask_opened=GTK_PIXMAP(copened->widget)->mask;
	}
	if (_clip_parinfo(cm,8)==UNDEF_t) is_leaf = TRUE;
	if (_clip_parinfo(cm,9)==UNDEF_t) expanded = FALSE;

	ncolumns = GTK_CLIST(cctree->widget)->columns;
	columns = (gchar**)calloc(sizeof(columns),ncolumns);
	for(i=0; i < ncolumns; i++ ) columns[i] = "";
	if (cvtext->t.type==ARRAY_t)
	{
		ClipArrVar *acol = (ClipArrVar*)_clip_vptr(cvtext);
		for(i=0; i < acol->count; i++ )
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				{
				columns[i] = acol->items[i].s.str.buf;
				LOCALE_TO_UTF(columns[i]);
				}
	}
	if (cvtext->t.type==CHARACTER_t)
		{
		columns[0] = _clip_parc(cm,2);
		LOCALE_TO_UTF(columns[0]);
		}

	new_node = gtk_ctree_insert_node(GTK_CTREE(cctree->widget),
		parent,sibling,columns,spacing,pxm_closed,mask_closed,
		pxm_opened,mask_opened,is_leaf,expanded);
	if (new_node)
	{
		cnew_node = _register_object(cm,new_node,GTK_OBJECT_CTREE_NODE,NULL,NULL);
		if (cnew_node) _clip_mclone(cm,RETPTR(cm),&cnew_node->obj);
		gtk_ctree_node_set_row_data_full(GTK_CTREE(cctree->widget),
			new_node,cnew_node,(GtkDestroyNotify)destroy_c_object);
	}

#ifdef OS_CYGWIN
	if (cvtext->t.type==ARRAY_t)
	{
		ClipArrVar *acol = (ClipArrVar*)_clip_vptr(cvtext);
		for(i=0; i < acol->count; i++ )
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				FREE_TEXT(columns[i]);
	}
	if (cvtext->t.type==CHARACTER_t)
		FREE_TEXT(columns[0]);
#endif
	if (columns) free(columns);
	return 0;
err:
	return 1;
}

/* Remove the node and all nodes underneath it from the tree. */
int
clip_GTK_CTREEREMOVENODE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_remove_node(GTK_CTREE(cctree->widget),GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

typedef struct
{
	ClipMachine *cm;
	ClipVar *cv;
	C_widget *cw;
	ClipVar *cfunc;
}
Ctree_var;

void
_ctree_func(GtkCTree *ctree, GtkCTreeNode *node, Ctree_var *c)
{
	C_object *cnode = _list_get_cobject(c->cm,node);
	ClipVar stack[2];
	ClipVar res;
	if (!cnode) cnode = _register_object(c->cm,node,GTK_OBJECT_CTREE_NODE,NULL,NULL);
	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cm, &stack[0], &c->cw->obj);
	_clip_mclone(c->cm, &stack[1], &cnode->obj);
	//stack[0] = c->cw->obj;
	//stack[1] = cnode->obj;
	_clip_eval( c->cm, c->cfunc, 2, stack, &res );
	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &stack[0]);
	_clip_destroy(c->cm, &stack[1]);
}

/* Recursively apply a function to all nodes of the tree at or below a
 * certain node. The function is called for each node after it has been
 * called for that node's children. */
int
clip_GTK_CTREEPOSTRECURSIVE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	ClipVar     *cfunc = _clip_spar(cm,3);
	Ctree_var c;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKARG2(3,CCODE_t,PCODE_t);
	c.cm = cm; c.cv = cfunc; c.cw = cctree; c.cfunc = cfunc;
	gtk_ctree_post_recursive(GTK_CTREE(cctree->widget),GTK_CTREE_NODE(cnode->object),
		(GtkCTreeFunc)_ctree_func,&c);
	return 0;
err:
	return 1;
}

/* Recursively apply a function to nodes up to a certain depth.
 * The function is called for each node after it has been called
 * for that node's children. */
int
clip_GTK_CTREEPOSTRECURSIVETODEPTH(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint         depth = _clip_parni(cm,3);
	ClipVar     *cfunc = _clip_spar(cm,4);
	Ctree_var c;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t); CHECKARG2(4,CCODE_t,PCODE_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) depth = -1;
	c.cm = cm; c.cv = cfunc; c.cw = cctree; c.cfunc = cfunc;
	gtk_ctree_post_recursive_to_depth(GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), depth,
		(GtkCTreeFunc)_ctree_func,&c);
	return 0;
err:
	return 1;
}

/* Recursively apply a function to all nodes of the tree at or below a
 * certain node. The function is called for each node after it has
 * been called for its parent. */
int
clip_GTK_CTREEPRERECURSIVE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	ClipVar     *cfunc = _clip_spar(cm,3);
	Ctree_var c;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKARG2(3,CCODE_t,PCODE_t);
	c.cm = cm; c.cv = cfunc; c.cw = cctree; c.cfunc = cfunc;
	gtk_ctree_pre_recursive(GTK_CTREE(cctree->widget),GTK_CTREE_NODE(cnode->object),
		(GtkCTreeFunc)_ctree_func,&c);
	return 0;
err:
	return 1;
}

/* Recursively apply a function to nodes up to a certain depth. The function
 * is called for each node after it has been called for that node's children. */
int
clip_GTK_CTREEPRERECURSIVETODEPTH(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint         depth = _clip_parni(cm,3);
	ClipVar     *cfunc = _clip_spar(cm,4);
	Ctree_var c;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t); CHECKARG2(4,CCODE_t,PCODE_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) depth = -1;
	c.cm = cm; c.cv = cfunc; c.cw = cctree; c.cfunc = cfunc;
	gtk_ctree_pre_recursive_to_depth(GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), depth,
		(GtkCTreeFunc)_ctree_func,&c);
	return 0;
err:
	return 1;
}

/* This function checks whether the given node is viewable i.e. so that all
 * of its parent nodes are expanded. This is different from being actually
 * visible: the node can be viewable but outside the scrolling area of the
 * window. */
int
clip_GTK_CTREEISVIEWABLE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	_clip_retl(cm,gtk_ctree_is_viewable(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object)));
	return 0;
err:
	return 1;
}

/* Returns the last child of the last child of the last child... of the given node. */
int
clip_GTK_CTREELAST(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	GtkCTreeNode *last;
	C_object *clast;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	last = gtk_ctree_last(GTK_CTREE(cctree->widget),GTK_CTREE_NODE(cnode->object));
	if (last)
	{
		clast = _list_get_cobject(cm,last);
		if (!clast) clast = _register_object(cm,last,GTK_OBJECT_CTREE_NODE,NULL,NULL);
		if (clast) _clip_mclone(cm,RETPTR(cm),&clast->obj);
	}
	return 0;
err:
	return 1;
}

/* Returns True if child is on some level a child (grandchild...) of the node. */
int
clip_GTK_CTREEFIND(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object   *cchild = _fetch_cobject(cm,_clip_spar(cm,3));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCOBJOPT(cchild,cchild->type==GTK_OBJECT_CTREE_NODE);
	_clip_retl(cm,gtk_ctree_find(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object),
			GTK_CTREE_NODE(cchild->object)));
	return 0;
err:
	return 1;
}

/* Returns True is node is an ancestor of child.  */
int
clip_GTK_CTREEISANCESTOR(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object   *cchild = _fetch_cobject(cm,_clip_spar(cm,3));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCOBJOPT(cchild,cchild->type==GTK_OBJECT_CTREE_NODE);
	_clip_retl(cm,gtk_ctree_is_ancestor(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object),
			GTK_CTREE_NODE(cchild->object)));
	return 0;
err:
	return 1;
}

/* Returns True if the given coordinates lie on an expander button.  */
int
clip_GTK_CTREEISHOTSPOT(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	gint             x = _clip_parni(cm,2);
	gint             y = _clip_parni(cm,3);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKARG(2,NUMERIC_t); CHECKARG(3,NUMERIC_t);
	_clip_retl(cm,gtk_ctree_is_hot_spot(GTK_CTREE(cctree->widget),x,y));
	return 0;
err:
	return 1;
}

/* Move a node in the tree to another location. */
int
clip_GTK_CTREEMOVE(ClipMachine * cm)
{
	C_widget       *cctree = _fetch_cw_arg(cm);
	C_object        *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object  *cnew_parent = _fetch_cobject(cm,_clip_spar(cm,3));
	C_object *cnew_sibling = _fetch_cobject(cm,_clip_spar(cm,4));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnew_parent,cnew_parent->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT2(4,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnew_sibling,cnew_sibling->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_move(GTK_CTREE(cctree->widget),GTK_CTREE_NODE(cnode->object),
			GTK_CTREE_NODE(cnew_parent->object),
			GTK_CTREE_NODE(cnew_sibling->object));
	return 0;
err:
	return 1;
}

/* Expand one node. */
int
clip_GTK_CTREEEXPAND(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_expand(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Expand one node and all nodes underneath. */
int
clip_GTK_CTREEEXPANDRECURSIVE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_expand_recursive(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Expand a node and its children up to the depth given. */
int
clip_GTK_CTREEEXPANDTODEPTH(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint         depth = _clip_parni(cm,3);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	if (_clip_parinfo(cm,3)==UNDEF_t) depth = -1;
	gtk_ctree_expand_to_depth(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), depth);
	return 0;
err:
	return 1;
}

/* Collapse one node. */
int
clip_GTK_CTREECOLLAPSE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_collapse(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Collapse one node and all its subnodes. */
int
clip_GTK_CTREECOLLAPSERECURSIVE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_collapse_recursive(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Collapse a node and its children up to the depth given. */
int
clip_GTK_CTREECOLLAPSETODEPTH(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint         depth = _clip_parni(cm,3);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	if (_clip_parinfo(cm,3)==UNDEF_t) depth = -1;
	gtk_ctree_collapse_to_depth(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), depth);
	return 0;
err:
	return 1;
}

/* Toggle a node, i.e. if it is collapsed, expand it and vice versa. */
int
clip_GTK_CTREETOGGLEEXPANSION(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_toggle_expansion(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Toggle the expansion of a node and all its children. */
int
clip_GTK_CTREETOGGLEEXPANSIONRECURSIVE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_toggle_expansion_recursive(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Cause the given node to be selected and emit the appropriate signal. */
int
clip_GTK_CTREESELECT(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_select(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Cause the given node and its subnodes to be selected and emit the
   appropriate signal(s). */
int
clip_GTK_CTREESELECTRECURSIVE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_select_recursive(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}


/* Unselect the given node and emit the appropriate signal. */
int
clip_GTK_CTREEUNSELECT(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_unselect(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Unselect the given node and its subnodes and emit the appropriate
   signal(s). */
int
clip_GTK_CTREEUNSELECTRECURSIVE(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_unselect_recursive(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Set the text in a node. */
int
clip_GTK_CTREENODESETTEXT(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        column = _clip_parni(cm,3);
	gchar        *text = _clip_parc(cm,4);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,CHARACTER_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (_clip_parinfo(cm,4)==UNDEF_t) text = "";
	LOCALE_TO_UTF(text);
	gtk_ctree_node_set_text(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), column-1,text);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Set the pixmap in a node. */
int
clip_GTK_CTREENODESETPIXMAP(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        column = _clip_parni(cm,3);
	C_widget  *cpixmap = _fetch_cwidget(cm,_clip_spar(cm,4));
	GdkPixmap *pixmap=NULL; GdkBitmap *mask=NULL;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t);
	CHECKOPT2(4,MAP_t,NUMERIC_t); CHECKCWIDOPT(cpixmap,GTK_IS_PIXMAP);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (cpixmap)
	{
		pixmap = GTK_PIXMAP(cpixmap->widget)->pixmap;
		mask = GTK_PIXMAP(cpixmap->widget)->mask;
	}
	gtk_ctree_node_set_pixmap(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), column-1,pixmap,mask);
	return 0;
err:
	return 1;
}
/* Set the pixmap in a node. */
int
clip_GTK_CTREENODESETPIXTEXT(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        column = _clip_parni(cm,3);
	gchar        *text = _clip_parc(cm,4);
	gint       spacing = _clip_parni(cm,5);
	C_widget  *cpixmap = _fetch_cwidget(cm,_clip_spar(cm,6));
	GdkPixmap *pixmap=NULL; GdkBitmap *mask=NULL;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,CHARACTER_t); CHECKOPT(5,NUMERIC_t);
	CHECKOPT2(6,MAP_t,NUMERIC_t); CHECKCWIDOPT(cpixmap,GTK_IS_PIXMAP);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (_clip_parinfo(cm,4)==UNDEF_t) text = "";
	if (cpixmap)
	{
		pixmap = GTK_PIXMAP(cpixmap->widget)->pixmap;
		mask = GTK_PIXMAP(cpixmap->widget)->mask;
	}
	LOCALE_TO_UTF(text);
	gtk_ctree_node_set_pixtext(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), column-1,
			text,spacing,pixmap,mask);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Change the information. Most parameters correspond to the parameters
   of gtk_ctree_insert_node. */
int
clip_GTK_CTREENODESETNODEINFO(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	ClipVar    *cvtext = _clip_spar(cm,3);
	guint8     spacing = _clip_parni(cm,4);
	C_widget  *cclosed = _fetch_cwidget(cm,_clip_spar(cm,5));
	C_widget  *copened = _fetch_cwidget(cm,_clip_spar(cm,6));
	gboolean   is_leaf = _clip_parl(cm,7);
	gboolean  expanded = _clip_parl(cm,8);
	GtkCTreeNode *node;
	GdkPixmap *pxm_closed=NULL, *pxm_opened=NULL;
	GdkBitmap *mask_closed=NULL, *mask_opened=NULL;
	int i;
	gchar * * columns = NULL;
	int ncolumns;

	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT2(3,ARRAY_t,CHARACTER_t); CHECKOPT(4,NUMERIC_t);
	CHECKOPT2(5,MAP_t,NUMERIC_t); CHECKCWIDOPT(cclosed,GTK_IS_PIXMAP);
	CHECKOPT2(6,MAP_t,NUMERIC_t); CHECKCWIDOPT(copened,GTK_IS_PIXMAP);
	CHECKOPT(7,LOGICAL_t); CHECKOPT(8,LOGICAL_t);

	if (cnode) node = GTK_CTREE_NODE(cnode->object);
	if (cclosed)
	{
		pxm_closed=GTK_PIXMAP(cclosed->widget)->pixmap;
		mask_closed=GTK_PIXMAP(cclosed->widget)->mask;
	}
	if (copened)
	{
		pxm_opened=GTK_PIXMAP(copened->widget)->pixmap;
		mask_opened=GTK_PIXMAP(copened->widget)->mask;
	}
	if (_clip_parinfo(cm,7)==UNDEF_t) is_leaf = TRUE;
	if (_clip_parinfo(cm,8)==UNDEF_t) expanded = FALSE;

	ncolumns = GTK_CLIST(cctree->widget)->columns;
	columns = (gchar**)calloc(sizeof(columns),ncolumns);
	for(i=0; i < ncolumns; i++ ) columns[i] = "";
	if (cvtext->t.type==ARRAY_t)
	{
		ClipArrVar *acol = (ClipArrVar*)_clip_vptr(cvtext);
		for(i=0; i < acol->count; i++ )
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				{
				columns[i] = acol->items[i].s.str.buf;
				LOCALE_TO_UTF(columns[i]);
				}
	}
	if (cvtext->t.type==CHARACTER_t)
		{
		columns[0] = _clip_parc(cm,2);
		LOCALE_TO_UTF(columns[0]);
		}
	gtk_ctree_set_node_info(GTK_CTREE(cctree->widget),
		node,columns[0],spacing,pxm_closed,mask_closed,
		pxm_opened,mask_opened,is_leaf,expanded);
#ifdef OS_CYGWIN
	if (cvtext->t.type==ARRAY_t)
	{
		ClipArrVar *acol = (ClipArrVar*)_clip_vptr(cvtext);
		for(i=0; i < acol->count; i++ )
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				FREE_TEXT(columns[i]);
	}
	if (cvtext->t.type==CHARACTER_t)
		FREE_TEXT(columns[0]);
#endif
	if (columns) free(columns);
	return 0;
err:
	return 1;
}

/* Shift the given cell the given amounts in pixels. */
int
clip_GTK_CTREENODESETSHIFT(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        column = _clip_parni(cm,3);
	gint      vertical = _clip_parni(cm,4);
	gint    horizontal = _clip_parni(cm,5);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	gtk_ctree_node_set_shift(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), column-1,
			vertical, horizontal);
	return 0;
err:
	return 1;
}

/* selectable : Whether this node can be selected by the user. */
int
clip_GTK_CTREENODESETSELECTABLE(ClipMachine * cm)
{
	C_widget    *cctree = _fetch_cw_arg(cm);
	C_object     *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gboolean selectable = _clip_parl(cm,3);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,LOGICAL_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) selectable = TRUE;
	gtk_ctree_node_set_selectable(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), selectable);
	return 0;
err:
	return 1;
}

/* Returns : Whether this node can be selected by the user.  */
int
clip_GTK_CTREENODEGETSELECTABLE(ClipMachine * cm)
{
	C_widget    *cctree = _fetch_cw_arg(cm);
	C_object     *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	_clip_retl(cm,gtk_ctree_node_get_selectable(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object)));
	return 0;
err:
	return 1;
}

/* Returns : The type of the given cell. */
int
clip_GTK_CTREENODEGETCELLTYPE(ClipMachine * cm)
{
	C_widget    *cctree = _fetch_cw_arg(cm);
	C_object     *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint         column = _clip_parni(cm,3);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	_clip_retni(cm,gtk_ctree_node_get_cell_type(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object),column-1));
	return 0;
err:
	return 1;
}

/*  */
int
clip_GTK_CTREENODEGETTEXT(ClipMachine * cm)
{
	C_widget    *cctree = _fetch_cw_arg(cm);
	C_object     *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint         column = _clip_parni(cm,3);
	gint nColumns;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t);
	nColumns = GTK_CLIST(cctree->widget)->columns;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (column==1)
	{
		gchar **text = calloc(nColumns, sizeof(gchar*));

		if (gtk_ctree_get_node_info (GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), text, 0,0,0,0,0,0,0))
		LOCALE_TO_UTF(*text);
		_clip_retc(cm, text[column-1]);
		FREE_TEXT(*text);
		free(text);
	}
	else
	{
		gchar *text;
		gtk_ctree_node_get_text(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object), column-1, &text);
		LOCALE_FROM_UTF(text);
		if (text) _clip_retc(cm, text);
		FREE_TEXT(text);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_CTREENODEGETPIXMAP(ClipMachine * cm)
{
	C_widget    *cctree = _fetch_cw_arg(cm);
	C_object     *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint         column = _clip_parni(cm,3);
	GdkPixmap *pixmap;
	GdkBitmap *mask;
	C_widget *cpixmap;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (gtk_ctree_node_get_pixmap(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object),column-1,&pixmap,&mask))
	{
		if (pixmap)
		{
			cpixmap = _list_get_cwidget_by_data(cm,pixmap);
			if (!cpixmap) cpixmap = _register_widget(cm,gtk_pixmap_new(pixmap,mask),NULL);
			if (cpixmap) _clip_mclone(cm,RETPTR(cm),&cpixmap->obj);
		}
	}
	return 0;
err:
	return 1;
}

/* Get the parameters of a cell containing both a pixmap and text. */
int
clip_GTK_CTREENODEGETPIXTEXT(ClipMachine * cm)
{
	C_widget    *cctree = _fetch_cw_arg(cm);
	C_object     *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint         column = _clip_parni(cm,3);
	gchar *text = NULL;
	guint8 spacing;
	GdkPixmap *pixmap;
	GdkBitmap *mask;
	C_widget *cpixmap;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (gtk_ctree_node_get_pixtext(GTK_CTREE(cctree->widget),
			GTK_CTREE_NODE(cnode->object),column-1,
			&text,&spacing,&pixmap,&mask))
	{
		if (pixmap)
		{
			cpixmap = _list_get_cwidget_by_data(cm,pixmap);
			if (!cpixmap) cpixmap = _register_widget(cm,gtk_pixmap_new(pixmap,mask),NULL);
			if (cpixmap) _clip_mclone(cm,RETPTR(cm),&cpixmap->obj);
		}
	}

	if (text)
		{
		LOCALE_FROM_UTF(text);
		_clip_storc(cm,text,4,0);
		FREE_TEXT(text);
		}
	else
		_clip_storc(cm,"",4,0);

	_clip_storni(cm,spacing,5,0);
	return 0;
err:
	return 1;
}

/* Get information corresponding to a node. Any of the return parameters can be null. */
int
clip_GTK_CTREENODEGETNODEINFO(ClipMachine * cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	ClipVar    *minfo = RETPTR(cm);
	guint8     spacing;
	C_widget  *cclosed;
	C_widget  *copened;
	gboolean   is_leaf;
	gboolean  expanded;
	GdkPixmap *pxm_closed=NULL, *pxm_opened=NULL;
	GdkBitmap *mask_closed=NULL, *mask_opened=NULL;
	long i;
	gchar * * text;
	long ncolumns;

	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);

	ncolumns = GTK_CLIST(cctree->widget)->columns;
	text = calloc(ncolumns, sizeof(gchar*));
	if (gtk_ctree_get_node_info(GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object),text,&spacing,&pxm_closed,&mask_closed,
		&pxm_opened,&mask_opened,&is_leaf,&expanded))
	{
		ClipVar *a = NEW(ClipVar);
		ClipVar cv;
		cv.t.type = CHARACTER_t;

		_clip_array(cm, a, 1, &ncolumns);

		for (i=0; i<ncolumns; i++)
		{
			gtk_ctree_node_get_text(GTK_CTREE(cctree->widget),
				GTK_CTREE_NODE(cnode->object), i, text);
#ifdef OS_CYGWIN
			cv.s.str.buf = _clip_locale_from_utf8(text[0]);
			cv.s.str.len = strlen(cv.s.str.buf);
#else
			cv.s.str.len = strlen(text[0]);
			cv.s.str.buf = (gchar*)calloc(1, cv.s.str.len+1);
			strcpy(cv.s.str.buf, text[0]);
#endif
			_clip_aset(cm, a, &cv, 1, &i);
			_clip_destroy(cm,&cv);
		}

		memset(minfo,0,sizeof(*minfo)); _clip_map(cm,minfo);

		if (pxm_closed)
		{
			cclosed = _list_get_cwidget_by_data(cm,pxm_closed);
			if (!cclosed) cclosed = _register_widget(cm,gtk_pixmap_new(pxm_closed,mask_closed),NULL);
			if (cclosed) _clip_madd(cm, minfo, HASH_PIXMAPCLOSED,&cclosed->obj);
		}

		if (pxm_opened)
		{
			copened = _list_get_cwidget_by_data(cm,pxm_opened);
			if (!copened) copened = _register_widget(cm,gtk_pixmap_new(pxm_opened,mask_opened),NULL);
			if (copened) _clip_madd(cm, minfo, HASH_PIXMAPOPENED,&copened->obj);
		}

		_clip_madd(cm, minfo, HASH_TEXT, a);

		_clip_mputn(cm, minfo, HASH_SPACING, spacing);
		_clip_mputl(cm, minfo, HASH_ISLEAF, is_leaf);
		_clip_mputl(cm, minfo, HASH_EXPANDED, expanded);
		free(a);
	}
	if (text) free(text);

	return 0;
err:
	return 1;
}

/* Set the style of a row. */
int
clip_GTK_CTREENODESETROWSTYLE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	ClipVar    *mstyle = _clip_spar(cm,3);
	GtkStyle *style;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKARG(3,MAP_t);
	style = gtk_ctree_node_get_row_style (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object));
	_map_to_style(cm, mstyle, style);
	gtk_ctree_node_set_row_style (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), style);
	return 0;
err:
	return 1;
}

/* Get the style of a row. */
int
clip_GTK_CTREENODEGETROWSTYLE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	ClipVar    *mstyle = RETPTR(cm);
	GtkStyle *style;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	style = gtk_ctree_node_get_row_style (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object));
	memset(mstyle,0,sizeof(*mstyle));
	_clip_map(cm,mstyle);
	_style_to_map(cm, style, mstyle);
	return 0;
err:
	return 1;
}


/* Set the style of an individual cell. */
int
clip_GTK_CTREENODESETCELLSTYLE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        column = _clip_parni(cm,3);
	ClipVar    *mstyle = _clip_spar(cm,4);
	GtkStyle *style;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t); CHECKARG(4,MAP_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	style = gtk_ctree_node_get_cell_style (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), column-1);
	_map_to_style(cm, mstyle, style);
	gtk_ctree_node_set_cell_style (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), column-1, style);
	return 0;
err:
	return 1;
}

/* Get the style of an individual cell. */
int
clip_GTK_CTREENODEGETCELLSTYLE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        column = _clip_parni(cm,3);
	ClipVar    *mstyle = RETPTR(cm);
	GtkStyle *style;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	style = gtk_ctree_node_get_cell_style (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), column-1);
	memset(mstyle,0,sizeof(*mstyle));
	_clip_map(cm,mstyle);
	_style_to_map(cm, style, mstyle);
	return 0;
err:
	return 1;
}

/* Sets the foreground color of a node */
int
clip_GTK_CTREENODESETFOREGROUND (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	ClipVar    *mcolor = _clip_spar (cm,3);
	GdkColor color;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,MAP_t);
	if (_clip_parinfo(cm,3) == MAP_t)
		_map_colors_to_gdk(cm, mcolor, &color);
	else
		color = cctree->widget->style->text[0];
	gtk_ctree_node_set_foreground (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), &color);
	return 0;
err:
	return 1;
}

/* Sets the background color of a node */
int
clip_GTK_CTREENODESETBACKGROUND (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	ClipVar    *mcolor = _clip_spar (cm,3);
	GdkColor color;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,MAP_t);
	if (_clip_parinfo(cm,3) == MAP_t)
		_map_colors_to_gdk(cm, mcolor, &color);
	else
		color = cctree->widget->style->bg[0];
	gtk_ctree_node_set_background (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), &color);
	return 0;
err:
	return 1;
}

/* This function makes the given column of the given node visible by scrolling. */
int
clip_GTK_CTREENODEMOVETO (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	gint        column = _clip_parni(cm,3);
	gfloat   row_align = _clip_parnd(cm,4);
	gfloat   col_align = _clip_parnd(cm,5);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	gtk_ctree_node_moveto (GTK_CTREE(cctree->widget),
		GTK_CTREE_NODE(cnode->object), column-1, row_align, col_align);
	return 0;
err:
	return 1;
}

/* Returns : True if the node is currently inside the bounds of the window.
 * Note that this function can return true even if the node is not viewable,
 * if the node's ancestor is visible.  */
int
clip_GTK_CTREENODEISVISIBLE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	_clip_retni(cm,gtk_ctree_node_is_visible (GTK_CTREE(cctree->widget),
				GTK_CTREE_NODE(cnode->object)));
	return 0;
err:
	return 1;
}

/* indent : The number of pixels to shift the levels of the tree. */
int
clip_GTK_CTREESETINDENT (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	gint        indent = _clip_parni(cm,2);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT(2,NUMERIC_t);
	gtk_ctree_set_indent (GTK_CTREE(cctree->widget), indent);
	return 0;
err:
	return 1;
}

/* The spacing between the tree graphic and the actual node content. */
int
clip_GTK_CTREESETSPACING (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	gint       spacing = _clip_parni(cm,2);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT(2,NUMERIC_t);
	gtk_ctree_set_spacing (GTK_CTREE(cctree->widget), spacing);
	return 0;
err:
	return 1;
}

int
clip_GTK_CTREESETREORDERABLE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	gint       spacing = _clip_parni(cm,2);
	CHECKCWID(cctree,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	gtk_ctree_set_reorderable (GTK_CLIST(cctree->widget), spacing);
	return 0;
err:
	return 1;
}

int
clip_GTK_CTREESETLINESTYLE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	gint    line_style = _clip_parni(cm,2);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT(2,NUMERIC_t);
	gtk_ctree_set_line_style (GTK_CTREE(cctree->widget), line_style);
	return 0;
err:
	return 1;
}

int
clip_GTK_CTREESETEXPANDERSTYLE (ClipMachine *cm)
{
	C_widget    *cctree = _fetch_cw_arg(cm);
	gint expander_style = _clip_parni(cm,2);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT(2,NUMERIC_t);
	gtk_ctree_set_expander_style (GTK_CTREE(cctree->widget), expander_style);
	return 0;
err:
	return 1;
}

/* Sort the children of a node. See GtkCList for how to set the sorting criteria etc. */
int
clip_GTK_CTREESORTNODE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_sort_node (GTK_CTREE(cctree->widget),GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Sort the descendants of a node. See GtkCList for how to set the sorting criteria etc. */
int
clip_GTK_CTREESORTRECURSIVE (ClipMachine *cm)
{
	C_widget   *cctree = _fetch_cw_arg(cm);
	C_object    *cnode = _fetch_cobject(cm,_clip_spar(cm,2));
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCOBJOPT(cnode,cnode->type==GTK_OBJECT_CTREE_NODE);
	gtk_ctree_sort_recursive (GTK_CTREE(cctree->widget),GTK_CTREE_NODE(cnode->object));
	return 0;
err:
	return 1;
}

/* Returns : The node corresponding to the row th row. */
int
clip_GTK_CTREENODENTH (ClipMachine *cm)
{
	C_widget *cctree = _fetch_cw_arg(cm);
	guint        row = _clip_parni(cm,2);
	C_object  *cnode;
	GtkCTreeNode *node;
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	node = gtk_ctree_node_nth (GTK_CTREE(cctree->widget), row-1);
	if (node)
	{
		cnode = _list_get_cobject(cm,node);
		if (!cnode) cnode = _register_object(cm,node,GTK_OBJECT_CTREE_NODE,NULL,NULL);
		if (cnode) _clip_mclone(cm,RETPTR(cm),&cnode->obj);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_CTREESETSHOWSTUB (ClipMachine *cm)
{
	C_widget    *cctree = _fetch_cw_arg(cm);
	gboolean show_stub  = _clip_parl(cm,2);
	CHECKCWID(cctree,GTK_IS_CTREE);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) show_stub = 1;
	gtk_ctree_set_show_stub (GTK_CTREE(cctree->widget), show_stub);
	return 0;
err:
	return 1;
}

