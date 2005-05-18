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

#include "inkey.ch"
#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/* ctag - array of array with items: 1  target - string - drag type  */
/*                                   2  flags  - numeric - target flags */
/*                                   3  info   - numeric */
int
clip_GTK_DRAGDESTSET(ClipMachine * cm)
{
	C_widget        *cwid = _fetch_cw_arg(cm);
        GtkDestDefaults flags = _clip_parni(cm, 2);
        ClipArrVar      *ctag = (ClipArrVar *)_clip_vptr(_clip_par(cm, 3));
        guint           ntags = _clip_parni(cm, 4);
        GdkDragAction actions = _clip_parni(cm, 5);

	CHECKCWID(cwid, GTK_IS_WIDGET);
        CHECKARG(2, NUMERIC_t);
        CHECKOPT(3, ARRAY_t);
        CHECKARG(4, NUMERIC_t);
        CHECKARG(5, NUMERIC_t);

	if (ctag)
        {
        	GtkTargetEntry *tags;
                gint i;

                tags = malloc(ntags*sizeof(GtkTargetEntry));
                memset(tags, 0, sizeof(GtkTargetEntry)*ntags);
                for (i=0; i<ntags; i++)
                {
                	GtkTargetEntry t;
                	_array_to_target_entry(cm, &ctag->items[i], &t);
                        tags[i] = t;
		}

        	gtk_drag_dest_set(GTK_WIDGET(cwid->widget), flags, tags,
        		ntags, actions);
		free(tags);
        }
        else
        	gtk_drag_dest_set(GTK_WIDGET(cwid->widget), flags, NULL,
        		ntags, actions);

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGDESTSETPROXY(ClipMachine * cm)
{
	C_widget           *cwid = _fetch_cw_arg(cm);
        C_object           *cwin = _fetch_cobject(cm, _clip_spar(cm, 2));
        GdkDragProtocol protocol = _clip_parni(cm, 3);
        gboolean use_coordinates = _clip_parl(cm, 4);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKCOBJ(cwin, GDK_IS_WINDOW(cwin->object));
        CHECKARG(3, NUMERIC_t);
        CHECKARG(4, LOGICAL_t);

        gtk_drag_dest_set_proxy(GTK_WIDGET(cwid->widget),
        	GDK_WINDOW(cwin->object),
        	protocol,
                use_coordinates );

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGDESTUNSET(ClipMachine * cm)
{
	C_widget           *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_dest_unset(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}


int
clip_GTK_DRAGDESTFINDTARGET(ClipMachine * cm)
{
	C_widget     *cwid = _fetch_cw_arg(cm);
        C_object *ccontext = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object   *ctlist = _fetch_cobject(cm, _clip_spar(cm, 3));
        GdkAtom       atom ;
        C_object    *catom ;

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;

        atom = gtk_drag_dest_find_target(GTK_WIDGET(cwid->widget),
        	(GdkDragContext*)ccontext->object,
        	(GtkTargetList*)ctlist->object);
	if (atom)
        {
        	catom = _list_get_cobject(cm, &atom);
        	if (!catom) catom = _register_object(cm, &atom, GDK_TYPE_ATOM, NULL, NULL);
                if (catom) _clip_mclone(cm, RETPTR(cm), &catom->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGDESTGETTARGETLIST(ClipMachine * cm)
{
	C_widget      *cwid = _fetch_cw_arg(cm);
        GtkTargetList *list ;
        C_object    *ctlist ;

	CHECKCWID(cwid, GTK_IS_WIDGET);

        list = gtk_drag_dest_get_target_list(GTK_WIDGET(cwid->widget));

        if (list)
        {
        	ctlist = _list_get_cobject(cm, list);
        	if (!ctlist) ctlist = _register_object(cm, list, GDK_TYPE_ATOM, NULL, NULL);
                if (ctlist) _clip_mclone(cm, RETPTR(cm), &ctlist->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGDESTSETTARGETLIST(ClipMachine * cm)
{
	C_widget      *cwid = _fetch_cw_arg(cm);
        C_object    *ctlist = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;

        gtk_drag_dest_set_target_list(GTK_WIDGET(cwid->widget),
        	(GtkTargetList*)ctlist);

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGFINISH(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
	gboolean   success = _clip_parl(cm, 2);
        gboolean       del = _clip_parl(cm, 3);
        guint32       time = _clip_parni(cm, 4);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKARG(2, LOGICAL_t);
	CHECKARG(3, LOGICAL_t);
	CHECKARG(4, NUMERIC_t);

        gtk_drag_finish((GdkDragContext*)ccontext->object, success, del, time);

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGGETDATA(ClipMachine * cm)
{
        C_widget     *cwid = _fetch_cw_arg(cm);
        C_object *ccontext = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object    *catom = _fetch_cobject(cm, _clip_spar(cm, 3));
        guint32       time = _clip_parni(cm, 4);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!catom || catom->type != GDK_TYPE_ATOM)
        	goto err;
	CHECKARG(4, NUMERIC_t);

        gtk_drag_get_data(GTK_WIDGET(cwid->widget),
        	(GdkDragContext*)ccontext->object,
                (GdkAtom)(catom->object),
                time);


	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGGETSOURCEWIDGET(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        GtkWidget     *wid ;
        C_widget     *cwid ;

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;

        wid = gtk_drag_get_source_widget((GdkDragContext*)ccontext->object);

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
clip_GTK_DRAGHIGHLIGHT(ClipMachine * cm)
{
        C_widget     *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_highlight(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGUNHIGHLIGHT(ClipMachine * cm)
{
        C_widget     *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_unhighlight(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGBEGIN(ClipMachine * cm)
{
        C_widget     *cwid = _fetch_cw_arg(cm);
        C_object   *ctlist = _fetch_cobject(cm, _clip_spar(cm, 2));
	GdkDragAction actions = _clip_parni(cm, 3);
        gint           button = _clip_parni(cm, 4);
        C_object      *cevent = _fetch_cobject(cm, _clip_spar(cm, 5));
        GdkDragContext *context ;
        C_object      *ccontext ;

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;
        CHECKARG(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);
	if (!cevent || cevent->type != GDK_TYPE_EVENT)
        		goto err;

        context = gtk_drag_begin(GTK_WIDGET(cwid->widget),
        	(GtkTargetList*)ctlist->object,
        	actions,
        	button,
        	(GdkEvent*)cevent->object);

	if (context)
        {
        	ccontext = _list_get_cobject(cm, context);
        	if (!ccontext) ccontext = _register_object(cm, context, GDK_TYPE_DRAG_CONTEXT, NULL, NULL);
                if (ccontext) _clip_mclone(cm, RETPTR(cm), &ccontext->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSETICONWIDGET(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
	C_widget     *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gint         hot_x = _clip_parni(cm, 3);
        gint         hot_y = _clip_parni(cm, 4);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

        gtk_drag_set_icon_widget((GdkDragContext*)ccontext->object,
        	GTK_WIDGET(cwid->widget),
        	hot_x, hot_y );

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSETICONPIXMAP(ClipMachine * cm)
{
        C_object  *ccontext = _fetch_co_arg(cm);
	C_object *ccolormap = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object   *cpixmap = _fetch_cobject(cm, _clip_spar(cm, 3));
        C_object     *cmask = _fetch_cobject(cm, _clip_spar(cm, 4));
        gint          hot_x = _clip_parni(cm, 5);
        gint          hot_y = _clip_parni(cm, 6);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKCOBJ(ccolormap, GDK_IS_COLORMAP(ccolormap->object));
	CHECKCOBJ(cpixmap, GDK_IS_PIXMAP(cpixmap->object));
	CHECKCOBJ(cmask, GDK_IS_BITMAP(cmask));
	CHECKARG(5, NUMERIC_t);
	CHECKARG(6, NUMERIC_t);

        gtk_drag_set_icon_pixmap((GdkDragContext*)ccontext->object,
        	GDK_COLORMAP(ccolormap->object),
                GDK_PIXMAP(cpixmap->object),
                GDK_BITMAP(cmask->object),
        	hot_x, hot_y );

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSETICONPIXBUF(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        C_object  *cpixbuf = _fetch_cobject(cm, _clip_spar(cm, 2));
        gint         hot_x = _clip_parni(cm, 3);
        gint         hot_y = _clip_parni(cm, 4);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKCOBJ(cpixbuf, GDK_IS_PIXBUF(cpixbuf->object));
	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

        gtk_drag_set_icon_pixbuf((GdkDragContext*)ccontext->object,
                GDK_PIXBUF(cpixbuf->object),
        	hot_x, hot_y );

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSETICONSTOCK(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        const gchar *stock = _clip_parc(cm, 2);
        gint         hot_x = _clip_parni(cm, 3);
        gint         hot_y = _clip_parni(cm, 4);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKARG(2, CHARACTER_t);
	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

        gtk_drag_set_icon_stock((GdkDragContext*)ccontext->object,
                stock,
        	hot_x, hot_y );

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSETICONDEFAULT(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;

        gtk_drag_set_icon_default((GdkDragContext*)ccontext->object);

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSETDEFAULTICON(ClipMachine * cm)
{
        C_object *ccolormap = _fetch_co_arg(cm);
        C_object   *cpixmap = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object     *cmask = _fetch_cobject(cm, _clip_spar(cm, 3));
        gint          hot_x = _clip_parni(cm, 4);
        gint          hot_y = _clip_parni(cm, 5);

	CHECKCOBJ(ccolormap, GDK_IS_COLORMAP(ccolormap->object));
	CHECKCOBJ(cpixmap, GDK_IS_PIXMAP(cpixmap->object));
	CHECKCOBJ(cmask, GDK_IS_PIXMAP(cmask));
	CHECKARG(5, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

        gtk_drag_set_default_icon(GDK_COLORMAP(ccolormap->object),
                GDK_PIXMAP(cpixmap->object),
                GDK_BITMAP(cmask->object),
        	hot_x, hot_y );

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGCHECKTHRESHOLD(ClipMachine * cm)
{
        C_widget *cwid = _fetch_cw_arg(cm);
        gint   start_x = _clip_parni(cm, 2);
        gint   start_y = _clip_parni(cm, 3);
        gint current_x = _clip_parni(cm, 4);
        gint current_y = _clip_parni(cm, 5);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKARG(2, NUMERIC_t);
	CHECKARG(3, NUMERIC_t);
	CHECKARG(5, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

        _clip_retl(cm, gtk_drag_check_threshold(GTK_WIDGET(cwid->widget),
        	start_x, start_y, current_x, current_y ));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSOURCESET(ClipMachine * cm)
{
        C_widget     *cwid = _fetch_cw_arg(cm);
        GdkModifierType start_button_mask = _clip_parni(cm, 2);
        ClipArrVar   *ctag = (ClipArrVar*)_clip_vptr(_clip_spar(cm, 3));
	gint      ntargets = _clip_parni(cm, 4);
	GdkDragAction actions = _clip_parni(cm, 5);

	CHECKCWID(cwid, GTK_IS_WIDGET);
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, ARRAY_t);
        CHECKARG(4, NUMERIC_t);
        CHECKARG(5, NUMERIC_t);

	if (ctag)
        {
        	GtkTargetEntry *tags;
                gint i;

                tags = malloc(ctag->count*sizeof(GtkTargetEntry));
                memset(tags, 0, sizeof(GtkTargetEntry)*ctag->count);
                for (i=0; i<ctag->count; i++)
                	_array_to_target_entry(cm, &ctag->items[i], &tags[i]);
        	gtk_drag_source_set(GTK_WIDGET(cwid->widget),
        		start_button_mask,
        		tags,
                	ntargets,
        		actions);
		free(tags);
        }
        else
        	gtk_drag_source_set(GTK_WIDGET(cwid->widget),
        		start_button_mask,
        		NULL,
                	ntargets,
        		actions);

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSOURCESETICON(ClipMachine * cm)
{
        C_widget      *cwid = _fetch_cw_arg(cm);
	C_object *ccolormap = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object   *cpixmap = _fetch_cobject(cm, _clip_spar(cm, 3));
        C_object     *cmask = _fetch_cobject(cm, _clip_spar(cm, 4));

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKCOBJ(ccolormap, GDK_IS_COLORMAP(ccolormap->object));
	CHECKCOBJ(cpixmap, GDK_IS_PIXMAP(cpixmap->object));
	CHECKCOBJ(cmask, GDK_IS_BITMAP(cmask));

        gtk_drag_source_set_icon(GTK_WIDGET(cwid->widget),
        	GDK_COLORMAP(ccolormap->object),
                GDK_PIXMAP(cpixmap->object),
                GDK_BITMAP(cmask->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSOURCESETICONPIXBUF(ClipMachine * cm)
{
        C_widget      *cwid = _fetch_cw_arg(cm);
        C_object   *cpixbuf = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKCOBJ(cpixbuf, GDK_IS_PIXBUF(cpixbuf->object));

        gtk_drag_source_set_icon_pixbuf(GTK_WIDGET(cwid->widget),
                GDK_PIXBUF(cpixbuf->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSOURCESETICONSTOCK(ClipMachine * cm)
{
        C_widget      *cwid = _fetch_cw_arg(cm);
        const gchar  *stock = _clip_parc(cm, 2);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKARG(2, CHARACTER_t);

        gtk_drag_source_set_icon_stock(GTK_WIDGET(cwid->widget),
                stock);

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSOURCEUNSET(ClipMachine * cm)
{
        C_widget      *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_source_unset(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

/******************************************************************************
******* GDK Drag and Drop functions *******************************************
******************************************************************************/


int
clip_GDK_DRAGGETSELECTION(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        GdkAtom       atom ;
        C_object    *catom ;

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;

        atom = gdk_drag_get_selection((GdkDragContext*)ccontext->object);

	if (atom)
        {
        	catom = _list_get_cobject(cm, atom);
        	if (!catom) catom = _register_object(cm, atom, GDK_TYPE_ATOM, NULL, NULL);
                if (catom) _clip_mclone(cm, RETPTR(cm), &catom->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAGABORT(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        guint32       time = _clip_parni(cm, 2);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKARG(2, NUMERIC_t);

        gdk_drag_abort((GdkDragContext*)ccontext->object, time);

	return 0;
err:
	return 1;
}

int
clip_GDK_DROPREPLY(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        gboolean        ok = _clip_parl(cm, 2);
        guint32       time = _clip_parni(cm, 3);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKARG(2, LOGICAL_t);
	CHECKARG(3, NUMERIC_t);

        gdk_drop_reply((GdkDragContext*)ccontext->object, ok, time);

	return 0;
err:
	return 1;
}

int
clip_GDK_DRAGCONTEXTNEW(ClipMachine * cm)
{
        GdkDragContext *context;
        C_object *ccontext ;


        context = gdk_drag_context_new();

	if (context)
        {
        	ccontext = _list_get_cobject(cm, context);
        	if (!ccontext) ccontext = _register_object(cm, context, GDK_TYPE_DRAG_CONTEXT, NULL, NULL);
                if (ccontext) _clip_mclone(cm, RETPTR(cm), &ccontext->obj);
        }

	return 0;
}

int
clip_GDK_DRAGDROP(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        guint32       time = _clip_parni(cm, 2);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKARG(2, NUMERIC_t);

        gdk_drag_drop((GdkDragContext*)ccontext->object, time);

	return 0;
err:
	return 1;
}

int
clip_GDK_DRAGFINDWINDOW(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        C_object *cgdk_win = _fetch_cobject(cm, _clip_spar(cm, 2));
        gint        x_root = _clip_parni(cm, 3);
        gint        y_root = _clip_parni(cm, 4);
        ClipVar        *cv = _clip_spar(cm, 5);
        GdkWindow     *win ;
        C_object     *cwin ;
        GdkDragProtocol protocol ;

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKCOBJ(cgdk_win, GDK_IS_WINDOW(cgdk_win->object));
	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

        gdk_drag_find_window((GdkDragContext*)ccontext->object,
        	GDK_WINDOW(cgdk_win->object),
        	x_root, y_root,
        	&win, &protocol);

	if (win)
        {
        	cwin = _list_get_cobject(cm, win);
        	if (!cwin) cwin = _register_object(cm, win, GDK_TYPE_WINDOW, NULL, NULL);
                if (cwin) _clip_mclone(cm, cv, &cwin->obj);
                _clip_storni(cm, protocol, 6, 0);
        }
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAGBEGIN(ClipMachine * cm)
{
        C_object *cwin = _fetch_co_arg(cm);
        ClipVar    *cv = _clip_spar(cm, 2);
        GList    *list ;
        gint         i ;

	CHECKCOBJ(cwin, GDK_IS_WINDOW(cwin->object));
	CHECKARG(2, ARRAY_t);

        for (i=0; i<cv->a.count; i++)
        	g_list_append(list, &cv->a.items[i]);

        gdk_drag_begin(GDK_WINDOW(cwin->object), list);

	return 0;
err:
	return 1;
}

int
clip_GDK_DRAGMOTION(ClipMachine * cm)
{
        C_object             *ccontext = _fetch_co_arg(cm);
        C_object             *cgdk_win = _fetch_cobject(cm, _clip_spar(cm, 2));
        GdkDragProtocol       protocol = _clip_parni(cm, 3);
        gint                    x_root = _clip_parni(cm, 4);
        gint                    y_root = _clip_parni(cm, 5);
        GdkDragAction suggested_action = _clip_parni(cm, 6);
        GdkDragAction possible_actions = _clip_parni(cm, 7);
        guint32                   time = _clip_parni(cm, 8);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKCOBJ(cgdk_win, GDK_IS_WINDOW(cgdk_win->object));
	CHECKARG(3, NUMERIC_t); CHECKARG(4, NUMERIC_t);
	CHECKARG(5, NUMERIC_t); CHECKARG(6, NUMERIC_t);
	CHECKARG(7, NUMERIC_t); CHECKARG(8, NUMERIC_t);

        gdk_drag_motion((GdkDragContext*)ccontext->object,
        	GDK_WINDOW(cgdk_win->object),
        	protocol,
        	x_root, y_root,
        	suggested_action,
                possible_actions,
                time);

	return 0;
err:
	return 1;
}

int
clip_GDK_DROPFINISH(ClipMachine * cm)
{
        C_object *ccontext = _fetch_co_arg(cm);
        gboolean   success = _clip_parl(cm, 2);
        guint32       time = _clip_parni(cm, 3);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKARG(2, LOGICAL_t); CHECKARG(3, NUMERIC_t);

        gdk_drop_finish((GdkDragContext*)ccontext->object,
                success, time);

	return 0;
err:
	return 1;
}

int
clip_GDK_DRAGGETPROTOCOL(ClipMachine * cm)
{
        guint32              xid = _clip_parni(cm, 1);
        GdkDragProtocol protocol ;

	CHECKARG(1, NUMERIC_t);

        _clip_retni(cm, gdk_drag_get_protocol(xid, &protocol));
	_clip_storni(cm, protocol, 2, 0);
	return 0;
err:
	return 1;
}

int
clip_GDK_DRAGSTATUS(ClipMachine * cm)
{
        C_object   *ccontext = _fetch_co_arg(cm);
        GdkDragAction action = _clip_parni(cm, 2);
        guint32         time = _clip_parni(cm, 3);

	if (!ccontext || ccontext->type != GDK_TYPE_DRAG_CONTEXT)
        	goto err;
	CHECKARG(2, NUMERIC_t);
	CHECKARG(3, NUMERIC_t);

        gdk_drag_status((GdkDragContext*)ccontext->object,
        	action, time);
	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
int
clip_GTK_DRAGDESTADDIMAGETARGETS(ClipMachine * cm)
{
	C_widget        *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_dest_add_image_targets(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGDESTADDTEXTTARGETS(ClipMachine * cm)
{
	C_widget        *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_dest_add_text_targets(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGDESTADDURITARGETS(ClipMachine * cm)
{
	C_widget        *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_dest_add_uri_targets(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSOURCEADDIMAGETARGETS(ClipMachine * cm)
{
	C_widget        *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_source_add_image_targets(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSOURCEADDTEXTTARGETS(ClipMachine * cm)
{
	C_widget        *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_source_add_text_targets(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_DRAGSOURCEADDURITARGETS(ClipMachine * cm)
{
	C_widget        *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

        gtk_drag_source_add_uri_targets(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}
#endif
