/*
    Copyright (C) 2001-2004  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    	      Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <pango/pango-layout.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/********************** SIGNALS **************************/
/****          Entry have no own signals              ****/
/*********************************************************/

/* Register entry in global table */
CLIP_DLLEXPORT GtkType _gtk_type_entry() { return GTK_TYPE_ENTRY; }
long _clip_type_entry() { return GTK_WIDGET_ENTRY; }
const char * _clip_type_name_entry() { return "GTK_WIDGET_ENTRY"; }

int
clip_INIT___ENTRY(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_entry, _clip_type_name_entry, _gtk_type_entry, _gtk_type_editable, NULL);
	return 0;
}
/**********************************************************/

/**** ENTRY constructor ****/
int
clip_GTK_ENTRYNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	int max_lentgh = _clip_parni(cm, 2);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,NUMERIC_t);

	if (_clip_parinfo(cm,2) == NUMERIC_t)
		wid = gtk_entry_new_with_max_length(max_lentgh);
        else
        	wid = gtk_entry_new();
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Sets text in entry */
int
clip_GTK_ENTRYSETTEXT(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gchar      *text = _clip_parc(cm,2);
        gchar empty_text[] = "\0";
        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKOPT(2,CHARACTER_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) text = empty_text;
        LOCALE_TO_UTF(text);
        gtk_entry_set_text(GTK_ENTRY(centry->widget),text);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Append text to entry */
int
clip_GTK_ENTRYAPPENDTEXT(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gchar      *text = _clip_parc(cm,2);
        gchar empty_text[] = "\0";
        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKOPT(2,CHARACTER_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) text = empty_text;
        LOCALE_TO_UTF(text);
        gtk_entry_append_text(GTK_ENTRY(centry->widget),text);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Insert text to start of entry */
int
clip_GTK_ENTRYPREPENDTEXT(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gchar      *text = _clip_parc(cm,2);
        gchar empty_text[] = "\0";
        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKOPT(2,CHARACTER_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) text = empty_text;
        LOCALE_TO_UTF(text);
        gtk_entry_prepend_text(GTK_ENTRY(centry->widget),text);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Sets a cursor position in entry */
int
clip_GTK_ENTRYSETPOSITION(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gint    position = _clip_parni(cm,2);
        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKOPT(2,NUMERIC_t);
        gtk_entry_set_position(GTK_ENTRY(centry->widget),position);
	return 0;
err:
	return 1;
}

/* Returns a text in entry */
int
clip_GTK_ENTRYGETTEXT(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gchar *text;
        CHECKCWID(centry,GTK_IS_ENTRY);
        text = (gchar *)gtk_entry_get_text(GTK_ENTRY(centry->widget));
        LOCALE_FROM_UTF(text);
        _clip_retc(cm, text);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Selects a text in entry */
int
clip_GTK_ENTRYSELECTREGION(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gint   start_pos = _clip_parni(cm,2);
        gint     end_pos = _clip_parni(cm,3);
        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        if (_clip_parinfo(cm,3)==UNDEF_t) end_pos = -1;
        gtk_entry_select_region(GTK_ENTRY(centry->widget),start_pos,end_pos);
	return 0;
err:
	return 1;
}

/* Sets a visibility of characters in entry */
int
clip_GTK_ENTRYSETVISIBILITY(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gboolean visibility = _clip_parl(cm,2);
        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKOPT(2,LOGICAL_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) visibility = TRUE;
        gtk_entry_set_visibility(GTK_ENTRY(centry->widget),visibility);
	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYSETINVISIBLECHAR(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gunichar      ch = _clip_parni(cm, 2);

        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKOPT(2, CHARACTER_t);

        gtk_entry_set_invisible_char(GTK_ENTRY(centry->widget), ch);
	return 0;
err:
	return 1;
}

/* Sets a editable of entry */
int
clip_GTK_ENTRYSETEDITABLE(ClipMachine * cm)
{
	C_widget *centry = _fetch_cw_arg(cm);
        gboolean editable = _clip_parl(cm,2);
        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKOPT(2,LOGICAL_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) editable = TRUE;
        gtk_entry_set_editable(GTK_ENTRY(centry->widget),editable);
	return 0;
err:
	return 1;
}

/* Sets a max length of text in entry */
int
clip_GTK_ENTRYSETMAXLENGTH(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        guint16 max_length = _clip_parni(cm,2);
        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKARG(2,NUMERIC_t);
        gtk_entry_set_max_length(GTK_ENTRY(centry->widget),max_length);
	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYGETACTIVATESDEFAULT(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        gboolean       ret ;

        CHECKCWID(centry,GTK_IS_ENTRY);

        ret = gtk_entry_get_activates_default(GTK_ENTRY(centry->widget));

        _clip_retl(cm,ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYGETHASFRAME(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        gboolean       ret ;

        CHECKCWID(centry,GTK_IS_ENTRY);

        ret = gtk_entry_get_has_frame(GTK_ENTRY(centry->widget));

        _clip_retl(cm,ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYGETWIDTHCHARS(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        gint           ret ;

        CHECKCWID(centry,GTK_IS_ENTRY);

        ret = gtk_entry_get_width_chars(GTK_ENTRY(centry->widget));

        _clip_retni(cm,ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYSETACTIVATESDEFAULT(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        gboolean   setting = _clip_parl(cm, 2);

        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKARG(2, LOGICAL_t);

        gtk_entry_set_activates_default(GTK_ENTRY(centry->widget), setting);

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYSETHASFRAME(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        gboolean   setting = _clip_parl(cm, 2) ;

        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKARG(2, LOGICAL_t);

        gtk_entry_set_has_frame(GTK_ENTRY(centry->widget), setting);

	return 0;
err:
	return 1;
}


int
clip_GTK_ENTRYSETWIDTHCHARS(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        gint         width = _clip_parni(cm, 2);

        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKARG(2, NUMERIC_t);

        gtk_entry_set_width_chars(GTK_ENTRY(centry->widget), width);

	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYGETINVISIBLECHAR(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        gunichar        ch ;

        CHECKCWID(centry,GTK_IS_ENTRY);

        ch = gtk_entry_get_invisible_char(GTK_ENTRY(centry->widget));

	_clip_retc(cm, (gchar *)ch);
	return 0;
err:
	return 1;
}


int
clip_GTK_ENTRYGETLAYOUT(ClipMachine * cm)
{
	C_widget    *centry = _fetch_cw_arg(cm);
        PangoLayout *layout ;
        C_object   *clayout ;

        CHECKCWID(centry,GTK_IS_ENTRY);

        layout = gtk_entry_get_layout(GTK_ENTRY(centry->widget));

        if (!layout) goto err;

	clayout = _register_object(cm, layout, PANGO_TYPE_LAYOUT, NULL, NULL);
        _clip_mclone(cm,RETPTR(cm),&clayout->obj);
	return 0;
err:
	return 1;
}


int
clip_GTK_ENTRYGETLAYOUTOFFSETS(ClipMachine * cm)
{
	C_widget    *centry = _fetch_cw_arg(cm);
        gint           x, y ;

        CHECKCWID(centry,GTK_IS_ENTRY);

        gtk_entry_get_layout_offsets(GTK_ENTRY(centry->widget), &x, &y);

	_clip_storni(cm, x, 2, 0);
	_clip_storni(cm, y, 3, 0);
	return 0;
err:
	return 1;
}

/* Returns a max length of text in entry */
int
clip_GTK_ENTRYGETMAXLENGTH(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        CHECKCWID(centry,GTK_IS_ENTRY);
        _clip_retni(cm,GTK_ENTRY(centry->widget)->text_max_length);
	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYGETVISIBILITY(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        CHECKCWID(centry,GTK_IS_ENTRY);
        _clip_retl(cm, gtk_entry_get_visibility(GTK_ENTRY(centry->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYSETSTYLE(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
	ClipVar  *mstyle = _clip_spar(cm,2);
	GtkStyle *style;
        CHECKCWID(centry,GTK_IS_ENTRY);
	CHECKARG(2,MAP_t);
	style = gtk_style_copy(centry->widget->style);
	//gtk_style_unref(centry->widget->style);
	_map_to_style(cm, mstyle, style);
	gtk_widget_set_style (centry->widget, style);
	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
int
clip_GTK_ENTRYSETCOMPLETION(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        C_object *ccomplet = _fetch_cobject(cm, _clip_spar(cm, 2));

        CHECKCWID(centry,GTK_IS_ENTRY);
        CHECKCOBJ(ccomplet, GTK_IS_ENTRY_COMPLETION(ccomplet->object));

	gtk_entry_set_completion(GTK_ENTRY(centry->widget),
		GTK_ENTRY_COMPLETION(ccomplet->object));
	return 0;
err:
	return 1;
}

int
clip_GTK_ENTRYGETCOMPLETION(ClipMachine * cm)
{
	C_widget   *centry = _fetch_cw_arg(cm);
        GtkEntryCompletion *complet ;
        C_object *ccomplet ;

        CHECKCWID(centry,GTK_IS_ENTRY);

	complet = gtk_entry_get_completion(GTK_ENTRY(centry->widget));

	if (complet)
        {
        	ccomplet = _list_get_cobject(cm, complet);
                if (!ccomplet) ccomplet = _register_object(cm, complet, GTK_TYPE_ENTRY_COMPLETION, NULL, NULL);
                if (ccomplet) _clip_mclone(cm, RETPTR(cm), &ccomplet->obj);
        }
	return 0;
err:
	return 1;
}

#endif
