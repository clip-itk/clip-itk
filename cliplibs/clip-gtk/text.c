/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/********************** SIGNALS **************************/
/****          Text have no own signals               ****/
/*********************************************************/

/* Register text in global table */
CLIP_DLLEXPORT GtkType _gtk_type_text() { return GTK_TYPE_TEXT; }
long _clip_type_text() { return GTK_WIDGET_TEXT; }
const char * _clip_type_name_text() { return "GTK_WIDGET_TEXT"; }

int
clip_INIT___TEXT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_text, _clip_type_name_text, _gtk_type_text, _gtk_type_editable, NULL);
	return 0;
}
/**********************************************************/

/**** TEXT constructor ****/
int
clip_GTK_TEXTNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_widget * chadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	C_widget * cvadj = _fetch_cwidget(cm,_clip_spar(cm, 3));
        GtkAdjustment *hadj, *vadj;
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(chadj,GTK_IS_ADJUSTMENT);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCWIDOPT(cvadj,GTK_IS_ADJUSTMENT);

        hadj = chadj ? GTK_ADJUSTMENT(chadj->widget) : NULL;
        vadj = cvadj ? GTK_ADJUSTMENT(cvadj->widget) : NULL;
        wid = gtk_text_new(hadj,vadj);
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Set whether the GtkText widget can be edited by the user or not.
 * This still allows you the programmer to make changes with the
 * various GtkText functions.  */
int
clip_GTK_TEXTSETEDITABLE(ClipMachine * cm)
{
	C_widget   *ctext = _fetch_cw_arg(cm);
        gboolean editable = _clip_parl(cm,2);
        CHECKCWID(ctext,GTK_IS_TEXT);
        CHECKOPT(2,LOGICAL_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) editable = TRUE;
        gtk_text_set_editable(GTK_TEXT(ctext->widget),editable);
	return 0;
err:
	return 1;
}

/* Sets whether the GtkText widget wraps words down to the next
 * line if it can't be completed on the current line. */
int
clip_GTK_TEXTSETWORDWRAP(ClipMachine * cm)
{
	C_widget   *ctext = _fetch_cw_arg(cm);
        gboolean wordwrap = _clip_parl(cm,2);
        CHECKCWID(ctext,GTK_IS_TEXT);
        CHECKOPT(2,LOGICAL_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) wordwrap = TRUE;
        gtk_text_set_word_wrap(GTK_TEXT(ctext->widget),wordwrap);
	return 0;
err:
	return 1;
}

/* Controls how GtkText handles long lines of continuous text.
 * If line wrap is on, the line is broken when it reaches the
 * extent of the GtkText widget viewing area and the rest is
 * displayed on the next line. If it is not set, the line continues
 * regardless size of current viewing area. Similar to word wrap
 * but it disregards word boundaries. */
int
clip_GTK_TEXTSETLINEWRAP(ClipMachine * cm)
{
	C_widget   *ctext = _fetch_cw_arg(cm);
        gboolean linewrap = _clip_parl(cm,2);
        CHECKCWID(ctext,GTK_IS_TEXT);
        CHECKOPT(2,LOGICAL_t);
        if (_clip_parinfo(cm,2)==UNDEF_t) linewrap = TRUE;
        gtk_text_set_line_wrap(GTK_TEXT(ctext->widget),linewrap);
	return 0;
err:
	return 1;
}

/* Allows you to set GtkAdjustment pointers which in turn allows
 * you to keep track of the viewing position of the GtkText widget. */
int
clip_GTK_TEXTSETADJUSTMENTS(ClipMachine * cm)
{
	C_widget  *ctext = _fetch_cw_arg(cm);
	C_widget * chadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	C_widget * cvadj = _fetch_cwidget(cm,_clip_spar(cm, 3));
        GtkAdjustment *hadj, *vadj;
        CHECKCWID(ctext,GTK_IS_TEXT);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(chadj,GTK_IS_ADJUSTMENT);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCWIDOPT(cvadj,GTK_IS_ADJUSTMENT);

        hadj = chadj ? GTK_ADJUSTMENT(chadj->widget) : NULL;
        vadj = cvadj ? GTK_ADJUSTMENT(cvadj->widget) : NULL;
        gtk_text_set_adjustments(GTK_TEXT(ctext->widget),hadj,vadj);
	return 0;
err:
	return 1;
}

/* Sets the cursor at the given point. In this case a point constitutes the
 * number of characters from the extreme upper left corner of the GtkText widget. */
int
clip_GTK_TEXTSETPOINT(ClipMachine * cm)
{
	C_widget *ctext = _fetch_cw_arg(cm);
        guint     index = _clip_parni(cm,2);
        CHECKCWID(ctext,GTK_IS_TEXT);
        CHECKOPT(2,NUMERIC_t);
        gtk_text_set_point(GTK_TEXT(ctext->widget),index);
	return 0;
err:
	return 1;
}

/* Gets the current position of the cursor as the number of
 * characters from the upper left corner of the GtkText widget.  */
int
clip_GTK_TEXTGETPOINT(ClipMachine * cm)
{
	C_widget *ctext = _fetch_cw_arg(cm);
        CHECKCWID(ctext,GTK_IS_TEXT);
        _clip_retni(cm,gtk_text_get_point(GTK_TEXT(ctext->widget)));
	return 0;
err:
	return 1;
}

/* Returns the length of the all the text contained within the
 * GtkText widget; disregards current point position.  */
int
clip_GTK_TEXTGETLENGTH(ClipMachine * cm)
{
	C_widget *ctext = _fetch_cw_arg(cm);
        CHECKCWID(ctext,GTK_IS_TEXT);
        _clip_retni(cm,gtk_text_get_length(GTK_TEXT(ctext->widget)));
	return 0;
err:
	return 1;
}

/* Freezes the GtkText widget which disallows redrawing of the widget
 * until it is thawed. This is useful if a large number of changes
 * are going to made to the text within the widget, reducing the amount
 * of flicker seen by the user.  */
int
clip_GTK_TEXTFREEZE(ClipMachine * cm)
{
	C_widget *ctext = _fetch_cw_arg(cm);
        CHECKCWID(ctext,GTK_IS_TEXT);
        gtk_text_freeze(GTK_TEXT(ctext->widget));
	return 0;
err:
	return 1;
}

/* Allows the GtkText widget to be redrawn again by GTK. */
int
clip_GTK_TEXTTHAW(ClipMachine * cm)
{
	C_widget *ctext = _fetch_cw_arg(cm);
        CHECKCWID(ctext,GTK_IS_TEXT);
        gtk_text_thaw(GTK_TEXT(ctext->widget));
	return 0;
err:
	return 1;
}

/* Inserts given text into the GtkText widget with the given
 * properties as outlined below. */
int
clip_GTK_TEXTINSERT(ClipMachine * cm)
{
	C_widget  *ctext = _fetch_cw_arg(cm);
        gchar      *text = _clip_parc(cm,2);
        gchar *fontdescr = _clip_parc(cm,3);
        ClipVar *mforecolor = _clip_spar(cm,4);
        ClipVar *mbackcolor = _clip_spar(cm,5);
        gint      length = _clip_parni(cm,6);
  	GdkFont * font = NULL;
        GdkColor forecolor, backcolor;
        CHECKCWID(ctext,GTK_IS_TEXT);
        CHECKARG(2,CHARACTER_t); CHECKOPT(3,CHARACTER_t);
        CHECKOPT(4,MAP_t); CHECKOPT(5,MAP_t); CHECKOPT(6,NUMERIC_t);
	if (_clip_parinfo(cm,3) == CHARACTER_t) /* font */
        {
  		font = gdk_font_load(fontdescr);
                if (font) gdk_font_ref (font);
	}
	if (_clip_parinfo(cm,3) == UNDEF_t || !font)
        	font = ctext->widget->style->font;

	if (_clip_parinfo(cm,4) == MAP_t)       /* foreground color */
  		_map_colors_to_gdk(cm, mforecolor, &forecolor);
        else
        	forecolor = ctext->widget->style->text[0];

	if (_clip_parinfo(cm,5) == MAP_t)       /* background color */
  		_map_colors_to_gdk(cm, mbackcolor, &backcolor);
        else
        	backcolor = ctext->widget->style->base[0];

	if (_clip_parinfo(cm,6) == UNDEF_t)       /* length. If -1, inserts all the text */
        	length = -1;

        LOCALE_TO_UTF(text);
        gtk_text_insert(GTK_TEXT(ctext->widget),font,&forecolor,&backcolor,text,length);
        FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Deletes from the current point position backward
 * the given number of characters. */
int
clip_GTK_TEXTBACKWARDDELETE(ClipMachine * cm)
{
	C_widget *ctext = _fetch_cw_arg(cm);
        guint    nchars = _clip_parni(cm,2);
        CHECKCWID(ctext,GTK_IS_TEXT);
        CHECKOPT(2,NUMERIC_t);
        gtk_text_backward_delete(GTK_TEXT(ctext->widget),nchars);
	return 0;
err:
	return 1;
}

/* Deletes from the current point position forward
 * the given number of characters. */
int
clip_GTK_TEXTFORWARDDELETE(ClipMachine * cm)
{
	C_widget *ctext = _fetch_cw_arg(cm);
        guint    nchars = _clip_parni(cm,2);
        CHECKCWID(ctext,GTK_IS_TEXT);
        CHECKOPT(2,NUMERIC_t);
        gtk_text_forward_delete(GTK_TEXT(ctext->widget),nchars);
	return 0;
err:
	return 1;
}

int
clip_GTK_TEXTGETEDITABLE(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
        GtkArg arg;
        CHECKCWID(cedt,GTK_IS_EDITABLE);
        arg.type = GTK_TYPE_BOOL;
        arg.name = "editable";
	gtk_widget_get(cedt->widget, &arg);
        _clip_retl(cm,arg.d.bool_data);
	return 0;
err:
	return 1;
}

int
clip_GTK_TEXTGETWORDWRAP(ClipMachine * cm)
{
	C_widget *ctext = _fetch_cw_arg(cm);
        CHECKCWID(ctext,GTK_IS_TEXT);
	_clip_retl(cm,GTK_TEXT(ctext->widget)->word_wrap);
	return 0;
err:
	return 1;
}


