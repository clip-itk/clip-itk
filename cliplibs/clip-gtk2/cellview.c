/*
    Copyright (C) 2005  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/

CLIP_DLLEXPORT GtkType _gtk_type_cell_view() { return GTK_TYPE_CELL_VIEW; }
long _clip_type_cell_view() { return GTK_WIDGET_CELL_VIEW; }
const char * _clip_type_name_cell_view() { return "GTK_WIDGET_CELL_VIEW"; }

int
clip_INIT___CELL_VIEW(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_cell_view, _clip_type_name_cell_view, _gtk_type_cell_view,  _gtk_type_widget, NULL);
	return 0;
}
/**********************************************************/

int
clip_GTK_CELLVIEWNEW(ClipMachine * cm)
{
	ClipVar    *cv = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid ;

	CHECKOPT(1,MAP_t);

	wid = gtk_cell_view_new();

	if (!wid) goto err;
        cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLVIEWNEWWITHTEXT(ClipMachine * cm)
{
	ClipVar    *cv = _clip_spar(cm, 1);
        gchar    *text = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(text);
	wid = gtk_cell_view_new_with_text((const gchar *)text);
        FREE_TEXT(text);

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLVIEWNEWWITHMARKUP(ClipMachine * cm)
{
	ClipVar    *cv = _clip_spar(cm, 1);
        gchar  *markup = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(markup);
	wid = gtk_cell_view_new_with_markup((const gchar *)markup);
        FREE_TEXT(markup);

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLVIEWNEWWITHPIXBUF(ClipMachine * cm)
{
	ClipVar    *cv = _clip_spar(cm, 1);
        C_object *cpix = _fetch_cobject(cm, _clip_spar(cm, 2));
	GtkWidget *wid = NULL;
	C_widget *cwid ;

	CHECKOPT(1,MAP_t);
        CHECKCOBJ(cpix, GDK_IS_PIXBUF(cpix->object));

	wid = gtk_cell_view_new_with_pixbuf(GDK_PIXBUF(cpix->object));

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLVIEWSETMODEL(ClipMachine * cm)
{
	C_widget  *ccell = _fetch_cw_arg(cm);
        C_object *cmodel = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(ccell,GTK_IS_CELL_VIEW);
        CHECKCOBJ(cmodel, GTK_IS_TREE_MODEL(cmodel->object));

	gtk_cell_view_set_model(GTK_CELL_VIEW(ccell->widget), GTK_TREE_MODEL(cmodel->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLVIEWSETDISPLAYEDROW(ClipMachine * cm)
{
	C_widget  *ccell = _fetch_cw_arg(cm);
        C_object  *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(ccell,GTK_IS_CELL_VIEW);
        CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	gtk_cell_view_set_displayed_row(GTK_CELL_VIEW(ccell->widget), GTK_TREE_PATH(cpath->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLVIEWGETDISPLAYEDROW(ClipMachine * cm)
{
	C_widget   *ccell = _fetch_cw_arg(cm);
        GtkTreePath *path ;
        C_object   *cpath ;

	CHECKCWID(ccell,GTK_IS_CELL_VIEW);

	path = gtk_cell_view_get_displayed_row(GTK_CELL_VIEW(ccell->widget));

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

int
clip_GTK_CELLVIEWGETSIZEOFROW(ClipMachine * cm)
{
	C_widget  *ccell = _fetch_cw_arg(cm);
        C_object  *cpath = _fetch_cobject(cm, _clip_spar(cm, 2));
        ClipVar      *cv = _clip_spar(cm, 3);
        GtkRequisition requisition ;

	CHECKCWID(ccell,GTK_IS_CELL_VIEW);
        CHECKCOBJ(cpath, GTK_IS_TREE_PATH(cpath->object));

	_clip_retl(cm, gtk_cell_view_get_size_of_row(GTK_CELL_VIEW(ccell->widget), GTK_TREE_PATH(cpath->object), &requisition));

        _clip_map(cm, cv);
        _clip_mputn(cm, cv, HASH_WIDTH, requisition.width);
        _clip_mputn(cm, cv, HASH_HEIGHT, requisition.height);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLVIEWSETBACKGROUNDCOLOR(ClipMachine * cm)
{
	C_widget  *ccell = _fetch_cw_arg(cm);
        ClipVar  *ccolor = _clip_spar(cm, 2);
        GdkColor  *color = 0;

	CHECKCWID(ccell,GTK_IS_CELL_VIEW);
        CHECKARG(2, MAP_t);

	_map_colors_to_gdk(cm, ccolor, color);

	gtk_cell_view_set_background_color(GTK_CELL_VIEW(ccell->widget), color);

	return 0;
err:
	return 1;
}

int
clip_GTK_CELLVIEWGETCELLRENDERERS(ClipMachine * cm)
{
	C_widget  *ccell = _fetch_cw_arg(cm);
        ClipVar      *cv = RETPTR(cm);
        GList      *list ;
        long           l ;

	CHECKCWID(ccell,GTK_IS_CELL_VIEW);

	list = gtk_cell_view_get_cell_renderers(GTK_CELL_VIEW(ccell->widget));
	l = g_list_length(list);
	_clip_array(cm, cv, 1, &l);
	for (l=0; list; list=g_list_next(list), l++)
	{
		C_object *cren;
		GtkCellRenderer *ren;

		ren = GTK_CELL_RENDERER(list->data);
		if (ren)
		{
			cren = _list_get_cobject(cm, ren);
			if (!cren) cren = _register_object(cm, ren, GTK_TYPE_CELL_RENDERER, NULL, NULL);
			if (cren) _clip_aset(cm, cv, &cren->obj, 1, &l);
		}
	}

	g_list_free(list);

	return 0;
err:
	return 1;
}

