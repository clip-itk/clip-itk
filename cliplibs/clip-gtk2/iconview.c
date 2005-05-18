/*
    Copyright (C) 2005  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
/* Signals table */
static int
handle_item_activated(GtkIconView *view, GtkTreePath *path, C_signal *cs)
{
        C_object *cpath;

	PREPARECV(cs,cv);

	cpath = _list_get_cobject(cs->cw->cmachine, path);
        if (!cpath) cpath = _register_object(cs->cw->cmachine, path, GTK_TYPE_TREE_PATH, NULL, NULL);
	if (cpath) _clip_madd(cs->cw->cmachine, &cv, HASH_TREEPATH, &cpath->obj);

	INVOKESIGHANDLER(GTK_WIDGET(view), cs,cv);
}

static int
handle_move_cursor(GtkIconView *view, GtkMovementStep arg1, gint arg2, C_signal *cs)
{
	PREPARECV(cs,cv);

	_clip_mputn(cs->cw->cmachine, &cv, HASH_MOVEMENTSTEP, (int)arg1);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ARG2, arg2);

	INVOKESIGHANDLER(GTK_WIDGET(view), cs,cv);
}
static int
handle_set_scroll_adjustments(GtkIconView *view, GtkAdjustment *arg1, GtkAdjustment *arg2, C_signal *cs)
{
	C_widget *carg1;
	C_widget *carg2;
	PREPARECV(cs,cv);

	carg1 = _list_get_cwidget(cs->cw->cmachine,(GtkWidget *)arg1);
	if (!carg1) carg1 = _register_widget(cs->cw->cmachine,(GtkWidget *)arg1,NULL);
	if (carg1) _clip_madd(cs->cw->cmachine, &cv, HASH_HADJUSTMENT, &carg1->obj);

	carg2 = _list_get_cwidget(cs->cw->cmachine,(GtkWidget *)arg2);
	if (!carg2) carg2 = _register_widget(cs->cw->cmachine,(GtkWidget *)arg2,NULL);
	if (carg2) _clip_madd(cs->cw->cmachine, &cv, HASH_VADJUSTMENT, &carg2->obj);

	INVOKESIGHANDLER(GTK_WIDGET(view), cs,cv);
}
static SignalTable icon_view_signals[] =
{
	{"activate-cursor-item",GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_ACTIVATE_CURSOR_ITEM_SIGNAL},
	{"item-activated",	GSF( handle_item_activated ), ESF( object_emit_signal ), GTK_ITEM_ACTIVATED_SIGNAL},
	{"move-cursor",		GSF( handle_move_cursor ), ESF( object_emit_signal ), GTK_MOVE_CURSOR_SIGNAL},
	{"select-all",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SELECT_ALL_SIGNAL},
	{"select-cursor-item",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SELECT_CURSOR_ITEM_SIGNAL},
	{"selection-changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SELECTION_CHANGED_SIGNAL},
	{"set-scroll-adjustments",	GSF( handle_set_scroll_adjustments ), ESF( object_emit_signal ), GTK_SET_SCROLL_ADJUSTMENTS_SIGNAL},
	{"toggle-cursor-item",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_TOGGLE_CURSOR_ITEM_SIGNAL},
	{"unselect-all",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_UNSELECT_ALL_SIGNAL},
	{"", NULL, NULL, 0}
};

CLIP_DLLEXPORT GtkType _gtk_type_icon_view() { return GTK_TYPE_ICON_VIEW; }
long _clip_type_icon_view() { return GTK_WIDGET_ICON_VIEW; }
const char * _clip_type_name_icon_view() { return "GTK_WIDGET_ICON_VIEW"; }

int
clip_INIT___ICON_VIEW(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_icon_view, _clip_type_name_icon_view, _gtk_type_icon_view,  _gtk_type_container, icon_view_signals);
	return 0;
}
/**********************************************************/

int
clip_GTK_ICONVIEWNEW(ClipMachine * cm)
{
	ClipVar    *cv = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid ;

	CHECKOPT(1,MAP_t);

	wid = gtk_icon_view_new();

	if (!wid) goto err;
        cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWNEWWITHMODEL(ClipMachine * cm)
{
	ClipVar      *cv = _clip_spar(cm, 1);
        C_object *cmodel = _fetch_cobject(cm, _clip_spar(cm, 2));
	GtkWidget *wid = NULL;
	C_widget *cwid ;

	CHECKOPT(1,MAP_t);
        CHECKCOBJ(cmodel, GTK_IS_TREE_MODEL(cmodel->object));

	wid = gtk_icon_view_new_with_model(GTK_TREE_MODEL(cmodel->object));

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETMODEL(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        C_object *cmodel = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKCOBJ(cmodel, GTK_IS_TREE_MODEL(cmodel->object));

	gtk_icon_view_set_model(GTK_ICON_VIEW(cview->widget), GTK_TREE_MODEL(cmodel->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETMODEL(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        C_object *cmodel ;
        GtkTreeModel *model ;

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	model = gtk_icon_view_get_model(GTK_ICON_VIEW(cview->widget));

	if (model)
        {
        	cmodel = _list_get_cobject(cm, model);
                if (!cmodel) cmodel = _register_object(cm, model, GTK_TYPE_TREE_MODEL, NULL, NULL);
                if (cmodel) _clip_mclone(cm, RETPTR(cm), &cmodel->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETTEXTCOLUMN(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint      column = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	column --;

	gtk_icon_view_set_text_column(GTK_ICON_VIEW(cview->widget), column);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETTEXTCOLUMN(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_text_column(GTK_ICON_VIEW(cview->widget))-1);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETMARKUPCOLUMN(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint      column = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	column --;

	gtk_icon_view_set_markup_column(GTK_ICON_VIEW(cview->widget), column);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETMARKUPCOLUMN(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_markup_column(GTK_ICON_VIEW(cview->widget))-1);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETPIXBUFCOLUMN(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint      column = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	column --;

	gtk_icon_view_set_pixbuf_column(GTK_ICON_VIEW(cview->widget), column);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETPIXBUFCOLUMN(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_pixbuf_column(GTK_ICON_VIEW(cview->widget))-1);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETPATHATPOS(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint           x = _clip_parni(cm, 2);
        gint           y = _clip_parni(cm, 3);
        C_object   *cpath ;
        GtkTreePath *path ;

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, NUMERIC_t);

	path = gtk_icon_view_get_path_at_pos(GTK_ICON_VIEW(cview->widget), x, y);

	if (path)
        {
        	cpath = _list_get_cobject(cm, path);
                if (!cpath) cpath = _register_object(cm, path, GTK_TYPE_TREE_PATH, NULL, NULL);
                if (cpath) _clip_mclone(cm, RETPTR(cm), &cpath->obj);
        }

	return 0;
err:
	return 1;
}

static void
_selected_foreach(GtkIconView *view, GtkTreePath *path, gpointer data)
{
	C_var *c = (C_var*)data;
	C_widget *c_wid = _list_get_cwidget(c->cm, view);
        C_object *cpath ;
	ClipVar stack[3];
	ClipVar res;
	if (!c_wid)
		c_wid = _register_widget(c->cm,GTK_WIDGET(view),NULL);

	cpath = _list_get_cobject(c->cm, path);
        if (!cpath) cpath = _register_object(c->cm, path, GTK_TYPE_TREE_PATH, NULL, NULL);

	if (c_wid)
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		_clip_mclone(c->cw->cmachine, &stack[0], &c->cw->obj);
		_clip_mclone(c->cw->cmachine, &stack[1], &cpath->obj);
		if (c->cv) _clip_mclone(c->cw->cmachine, &stack[2], c->cv);
		_clip_eval( c->cm, &(c->cfunc), 3, stack, &res );
		_clip_destroy(c->cm, &res);
		_clip_destroy(c->cm, &stack[0]);
		_clip_destroy(c->cm, &stack[1]);
		if (c->cv) _clip_destroy(c->cm, &stack[2]);
	}
}

int
clip_GTK_ICONVIEWSELECTEDFOREACH(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        ClipVar   *cfunc = _clip_spar(cm, 2);
        ClipVar   *cdata = _clip_spar(cm, 3);
        C_var         *c ;

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG2(2, CCODE_t, PCODE_t);

	c->cm = cm; c->cw = cview;
	_clip_mclone(cm, &c->cfunc, cfunc);
	if (cdata) _clip_mclone(cm, c->cv, cdata);

	gtk_icon_view_selected_foreach(GTK_ICON_VIEW(cview->widget),
		(GtkIconViewForeachFunc)_selected_foreach, c);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETSELECTIONMODE(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        GtkSelectionMode mode = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	gtk_icon_view_set_selection_mode(GTK_ICON_VIEW(cview->widget), mode);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETSELECTIONMODE(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, (int)gtk_icon_view_get_selection_mode(GTK_ICON_VIEW(cview->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETORIENTATION(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        GtkOrientation mode = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	gtk_icon_view_set_orientation(GTK_ICON_VIEW(cview->widget), mode);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETORIENTATION(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, (int)gtk_icon_view_get_orientation(GTK_ICON_VIEW(cview->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETCOLUMNS(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint     columns = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	gtk_icon_view_set_columns(GTK_ICON_VIEW(cview->widget), columns);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETCOLUMNS(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_columns(GTK_ICON_VIEW(cview->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETITEMWIDTH(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint       width = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	gtk_icon_view_set_item_width(GTK_ICON_VIEW(cview->widget), width);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETITEMWIDTH(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_item_width(GTK_ICON_VIEW(cview->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETSPACING(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint     spacing = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	gtk_icon_view_set_spacing(GTK_ICON_VIEW(cview->widget), spacing);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETSPACING(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_spacing(GTK_ICON_VIEW(cview->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETROWSPACING(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint     spacing = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	gtk_icon_view_set_row_spacing(GTK_ICON_VIEW(cview->widget), spacing);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETROWSPACING(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_row_spacing(GTK_ICON_VIEW(cview->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETCOLUMNSPACING(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint     spacing = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	gtk_icon_view_set_column_spacing(GTK_ICON_VIEW(cview->widget), spacing);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETCOLUMNSPACING(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_column_spacing(GTK_ICON_VIEW(cview->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSETMARGIN(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        gint      margin = _clip_parni(cm, 2);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKARG(2, NUMERIC_t);

	gtk_icon_view_set_margin(GTK_ICON_VIEW(cview->widget), margin);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETMARGIN(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	_clip_retni(cm, gtk_icon_view_get_margin(GTK_ICON_VIEW(cview->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSELECTPATH(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        C_object  *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	gtk_icon_view_select_path(GTK_ICON_VIEW(cview->widget),
		GTK_TREE_PATH(cpath->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWUNSELECTPATH(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        C_object  *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	gtk_icon_view_unselect_path(GTK_ICON_VIEW(cview->widget),
		GTK_TREE_PATH(cpath->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWPATHISSELECTED(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        C_object  *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	_clip_retl(cm, gtk_icon_view_path_is_selected(GTK_ICON_VIEW(cview->widget),
		GTK_TREE_PATH(cpath->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWGETSELECTEDITEMS(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        GList      *list ;
        ClipVar      *cv = RETPTR(cm);
        long           l ;

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	list = gtk_icon_view_get_selected_items(GTK_ICON_VIEW(cview->widget));
	l = g_list_length(list);
        _clip_array(cm, cv, 1, &l);
	for (l=0; list; list=g_list_next(list), l++)
	{
		C_object *cpath;
		GtkTreePath *path;

		path = GTK_TREE_PATH(list->data);
		if (path)
		{
			cpath = _list_get_cobject(cm, path);
			if (!cpath) cpath = _register_object(cm, path, GTK_TYPE_TREE_PATH, NULL, NULL);
			if (cpath) _clip_aset(cm, cv, &cpath->obj, 1, &l);
		}
	}

	g_list_free(list);

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWSELECTALL(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	gtk_icon_view_select_all(GTK_ICON_VIEW(cview->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWUNSELECTALL(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);

	CHECKCWID(cview,GTK_IS_ICON_VIEW);

	gtk_icon_view_unselect_all(GTK_ICON_VIEW(cview->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_ICONVIEWITEMACTIVATED(ClipMachine * cm)
{
	C_widget  *cview = _fetch_cw_arg(cm);
        C_object  *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cview,GTK_IS_ICON_VIEW);
        CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	gtk_icon_view_item_activated(GTK_ICON_VIEW(cview->widget),
		GTK_TREE_PATH(cpath->object));

	return 0;
err:
	return 1;
}

