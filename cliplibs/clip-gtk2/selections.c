/*
    Copyright (C) 2004 - 2005  ITK
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

/*****************************************************************************/
/************************* Selections -- Functions for ***********************/
/************** handling inter-process communication via selections. *********/
/*****************************************************************************/

int
clip_GTK_TARGETLISTNEW(ClipMachine * cm)
{
        ClipVar   *ctargets = _clip_par(cm, 1);

        CHECKARG(1, ARRAY_t);

	if (ctargets)
        {
        	guint                ntags = ctargets->a.count ;
        	GtkTargetEntry tags[ntags] ;
        	GtkTargetList        *list ;
                C_object            *clist ;
                gint                     i ;

                for (i=0; i<ntags; i++)
                	_array_to_target_entry(cm, &ctargets->a.items[i], &tags[i]);
        	list = gtk_target_list_new(tags, ntags);
                if (list)
                {
                	clist = _register_object(cm, list, GTK_TYPE_TARGET_LIST, NULL, NULL);
                        if (clist) _clip_mclone(cm, RETPTR(cm), &clist->obj);
                }
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_TARGETLISTREF(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;

       	gtk_target_list_ref((GtkTargetList*)(ctlist->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_TARGETLISTUNREF(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;

       	gtk_target_list_unref((GtkTargetList*)(ctlist->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_TARGETLISTADD(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);
        C_object   *catom = _fetch_cobject(cm, _clip_spar(cm, 2));
        guint       flags = _clip_parni(cm, 3);
        guint        info = _clip_parni(cm, 4);

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;
	if (!catom || catom->type != GDK_TYPE_ATOM)
        		goto err;

	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, NUMERIC_t);

       	gtk_target_list_add((GtkTargetList*)(ctlist->object),
       		(GdkAtom)(catom->object),
       		flags, info);

	return 0;
err:
	return 1;
}

int
clip_GTK_TARGETLISTADDTABLE(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);
        ClipVar   *ctargets = _clip_par(cm, 2);

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;

	CHECKARG(2, ARRAY_t);

	if (ctargets)
        {
        	guint                ntags = ctargets->a.count ;
        	GtkTargetEntry tags[ntags] ;
                gint                     i ;

                for (i=0; i<ntags; i++)
                	_array_to_target_entry(cm, &ctargets->a.items[i], &tags[i]);
        	gtk_target_list_add_table((GtkTargetList*)(ctlist->object),
        		tags, ntags);
        }


	return 0;
err:
	return 1;
}

int
clip_GTK_TARGETLISTREMOVE(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);
        C_object   *catom = _fetch_cobject(cm, _clip_spar(cm, 2));

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;
	if (!catom || catom->type != GDK_TYPE_ATOM)
        		goto err;


       	gtk_target_list_remove((GtkTargetList*)(ctlist->object),
       		(GdkAtom)(catom->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_TARGETLISTFIND(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);
        C_object   *catom = _fetch_cobject(cm, _clip_spar(cm, 2));
        guint        info ;

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;
	if (!catom || catom->type != GDK_TYPE_ATOM)
        		goto err;

       	_clip_retl(cm, gtk_target_list_find((GtkTargetList*)(ctlist->object),
       		(GdkAtom)(catom->object),
       		&info));

	_clip_storni(cm, info, 3, 0);

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONOWNERSET(ClipMachine * cm)
{
        C_widget       *cwid = _fetch_cw_arg(cm);
        C_object *cselection = _fetch_cobject(cm, _clip_spar(cm, 2));
        guint32         time = _clip_parni(cm, 3);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!cselection || cselection->type != GDK_TYPE_ATOM)
        		goto err;
	CHECKARG(3, NUMERIC_t);

       	_clip_retl(cm, gtk_selection_owner_set(GTK_WIDGET(cwid->widget),
       		(GdkAtom)(cselection->object),
       		time));

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONADDTARGET(ClipMachine * cm)
{
        C_widget       *cwid = _fetch_cw_arg(cm);
        C_object *cselection = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object    *ctarget = _fetch_cobject(cm, _clip_spar(cm, 3));
        guint           info = _clip_parni(cm, 4);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!cselection || cselection->type != GDK_TYPE_ATOM)
        		goto err;
	if (!ctarget || ctarget->type != GDK_TYPE_ATOM)
        		goto err;
	CHECKARG(4, NUMERIC_t);

       	gtk_selection_add_target(GTK_WIDGET(cwid->widget),
       		(GdkAtom)(cselection->object),
       		(GdkAtom)(ctarget->object),
       		info);

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONADDTARGETS(ClipMachine * cm)
{
        C_widget       *cwid = _fetch_cw_arg(cm);
        C_object *cselection = _fetch_cobject(cm, _clip_spar(cm, 2));
        ClipVar    *ctargets = _clip_par(cm, 3);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!cselection || cselection->type != GDK_TYPE_ATOM)
        		goto err;
        CHECKARG(3, ARRAY_t);

	if (ctargets)
        {
        	guint                ntags = ctargets->a.count ;
        	GtkTargetEntry tags[ntags] ;
                gint                     i ;

                for (i=0; i<ntags; i++)
                	_array_to_target_entry(cm, &ctargets->a.items[i], &tags[i]);
       		gtk_selection_add_targets(GTK_WIDGET(cwid->widget),
       			(GdkAtom)(cselection->object),
       			tags, ntags);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONCLEARTARGETS(ClipMachine * cm)
{
        C_widget       *cwid = _fetch_cw_arg(cm);
        C_object *cselection = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!cselection || cselection->type != GDK_TYPE_ATOM)
        		goto err;

       	gtk_selection_clear_targets(GTK_WIDGET(cwid->widget),
       		(GdkAtom)(cselection->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONCONVERT(ClipMachine * cm)
{
        C_widget       *cwid = _fetch_cw_arg(cm);
        C_object *cselection = _fetch_cobject(cm, _clip_spar(cm, 2));
        C_object    *ctarget = _fetch_cobject(cm, _clip_spar(cm, 3));
        guint32         time = _clip_parni(cm, 4);

	CHECKCWID(cwid, GTK_IS_WIDGET);
	if (!cselection || cselection->type != GDK_TYPE_ATOM)
        		goto err;
	if (!ctarget || ctarget->type != GDK_TYPE_ATOM)
        		goto err;
	CHECKARG(4, NUMERIC_t);

       	gtk_selection_convert(GTK_WIDGET(cwid->widget),
       		(GdkAtom)(cselection->object),
       		(GdkAtom)(ctarget->object),
       		time);

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATASET(ClipMachine * cm)
{
        C_object *cselection = _fetch_co_arg(cm);
        C_object      *ctype = _fetch_cobject(cm, _clip_spar(cm, 2));
        gint          format = _clip_parni(cm, 3);
        const guchar   *data = (const guchar *)_clip_parc(cm, 4);
        gint          length = _clip_parni(cm, 5);

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;
	if (!ctype || ctype->type != GDK_TYPE_ATOM)
        		goto err;
	CHECKARG(3, NUMERIC_t);
	CHECKARG(4, CHARACTER_t);
	CHECKARG(5, NUMERIC_t);

       	gtk_selection_data_set((GtkSelectionData*)(cselection->object),
       		(GdkAtom)(ctype->object),
       		format, data, length);

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATASETTEXT(ClipMachine * cm)
{
        C_object *cselection = _fetch_co_arg(cm);
        gchar           *str = _clip_parc(cm, 2);
        gint          length = _clip_parni(cm, 3);

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;

	CHECKARG(2, CHARACTER_t);
	CHECKARG(3, NUMERIC_t);

       	LOCALE_TO_UTF(str);
       	_clip_retl(cm, gtk_selection_data_set_text((GtkSelectionData*)(cselection->object),
       		str, length));
	FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATAGETTEXT(ClipMachine * cm)
{
        C_object *cselection = _fetch_co_arg(cm);
        gchar           *str ;

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;

       	str = (gchar *)gtk_selection_data_get_text((GtkSelectionData*)(cselection->object));
       	LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
	FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATAGETTARGETS(ClipMachine * cm)
{
        C_object *cselection = _fetch_co_arg(cm);
        ClipVar    *ctargets = _clip_par(cm, 2);
        GdkAtom     *targets ;
        gint          natoms ;
        long               l ;

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;

       	_clip_retl(cm, gtk_selection_data_get_targets((GtkSelectionData*)(cselection->object),
       		&targets, &natoms));

        l = natoms;
        _clip_array(cm, ctargets, 1, &l);
        for (l=0; l<natoms; l++)
        {
        	C_object *ca = _register_object(cm, targets[l], GDK_TYPE_ATOM, NULL, NULL);
                _clip_aset(cm, ctargets, &ca->obj, 1, &l);
        }
        _clip_storni(cm, natoms, 3, 0);

	g_free(targets);
	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATATARGETSINCLUDETEXT(ClipMachine * cm)
{
        C_object *cselection = _fetch_co_arg(cm);

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;

       	_clip_retl(cm, gtk_selection_data_targets_include_text((GtkSelectionData*)(cselection->object)));

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONREMOVEALL(ClipMachine * cm)
{
        C_widget *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid, GTK_IS_WIDGET);

       	gtk_selection_remove_all(GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATACOPY(ClipMachine * cm)
{
        C_object   *cselection = _fetch_co_arg(cm);
        GtkSelectionData *snew ;
        C_object         *cnew ;

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;

       	snew = gtk_selection_data_copy((GtkSelectionData*)(cselection->object));

	if (snew)
        {
        	cnew = _register_object(cm, snew, GTK_TYPE_SELECTION_DATA, NULL, NULL);
                if (cnew) _clip_mclone(cm, RETPTR(cm), &cnew->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATAFREE(ClipMachine * cm)
{
        C_object   *cselection = _fetch_co_arg(cm);

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;

       	gtk_selection_data_free((GtkSelectionData*)(cselection->object));

	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
int
clip_GTK_SELECTIONDATAGETPIXBUF(ClipMachine * cm)
{
        C_object   *cselection = _fetch_co_arg(cm);
        GdkPixbuf         *pix ;
        C_object         *cpix ;

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;

       	pix = gtk_selection_data_get_pixbuf((GtkSelectionData*)(cselection->object));

	if (pix)
        {
        	cpix = _list_get_cobject(cm, pix);
                if (!cpix) cpix = _register_object(cm, pix, GDK_TYPE_PIXBUF, NULL, NULL);
                if (cpix) _clip_mclone(cm, RETPTR(cm), &cpix->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATAGETURIS(ClipMachine * cm)
{
        C_object   *cselection = _fetch_co_arg(cm);
        gchar           **uris ;
        ClipVar            *cv = RETPTR(cm);

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;

       	uris = gtk_selection_data_get_uris((GtkSelectionData*)(cselection->object));

	if (uris)
        {
        	long l ;
                gchar **u = uris;
                _clip_array(cm, cv, 1, 0);

                for(l=0; u; l++)
                {
                	ClipVar *s = 0;
                        _clip_var_str(u[0], strlen(u[0]), s);
                	_clip_aadd(cm, cv, s);
                }

                g_strfreev(uris);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATASETPIXBUF(ClipMachine * cm)
{
        C_object   *cselection = _fetch_co_arg(cm);
        C_object         *cpix = _fetch_cobject(cm, _clip_spar(cm, 2));

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;
	CHECKCOBJ(cpix, GDK_IS_PIXBUF(cpix->object));

       	gtk_selection_data_set_pixbuf((GtkSelectionData*)(cselection->object),
       		GDK_PIXBUF(cpix->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATASETURIS(ClipMachine * cm)
{
        C_object   *cselection = _fetch_co_arg(cm);
        ClipArrVar         *ca = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        gchar           **uris = 0;
        long                 l ;
        int                  i ;

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;
	CHECKARG(2, ARRAY_t);

	l = ca->count;
	*uris = calloc(l+1,sizeof(gchar));
        *uris[l+1] = 0;
       	for(i=0; i<l; i++)
        {
        	ClipVar *s = ca->items+i;
                if (s->t.type != CHARACTER_t) goto err;

		strcpy(uris[i], s->s.str.buf);
	}
       	gtk_selection_data_set_uris((GtkSelectionData*)(cselection->object), uris);
        g_strfreev(uris);

	return 0;
err:
	return 1;
}

int
clip_GTK_SELECTIONDATATARGETSINCLUDEIMAGE(ClipMachine * cm)
{
        C_object   *cselection = _fetch_co_arg(cm);
        gboolean      writable = _clip_parl(cm, 2);

	if (!cselection || cselection->type != GTK_TYPE_SELECTION_DATA)
        		goto err;
	CHECKARG(2, LOGICAL_t);

       	_clip_retl(cm, gtk_selection_data_targets_include_image((GtkSelectionData*)(cselection->object),
       		writable));

	return 0;
err:
	return 1;
}
#endif
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
int
clip_GTK_TARGETLISTADDIMAGETARGETS(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);
        guint        info = _clip_parni(cm, 2);
        gboolean writable = _clip_parl(cm, 3);

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;

	CHECKARG(2, NUMERIC_t);
	CHECKARG(3, LOGICAL_t);

       	gtk_target_list_add_image_targets((GtkTargetList*)(ctlist->object),
       		info, writable);

	return 0;
err:
	return 1;
}

int
clip_GTK_TARGETLISTADDTEXTTARGETS(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);
        guint        info = _clip_parni(cm, 2);

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;

	CHECKARG(2, NUMERIC_t);

       	gtk_target_list_add_text_targets((GtkTargetList*)(ctlist->object),
       		info);

	return 0;
err:
	return 1;
}

int
clip_GTK_TARGETLISTADDURITARGETS(ClipMachine * cm)
{
        C_object  *ctlist = _fetch_co_arg(cm);
        guint        info = _clip_parni(cm, 2);

	if (!ctlist || ctlist->type != GTK_TYPE_TARGET_LIST)
        		goto err;

	CHECKARG(2, NUMERIC_t);

       	gtk_target_list_add_uri_targets((GtkTargetList*)(ctlist->object),
       		info);

	return 0;
err:
	return 1;
}
#endif
