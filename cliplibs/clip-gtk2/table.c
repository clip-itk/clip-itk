/*
    Copyright (C) 2002-2004  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    	      Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/***             Table has no own signals               ***/

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_table() { return GTK_TYPE_TABLE; }
long _clip_type_table() { return GTK_WIDGET_TABLE; }
const char * _clip_type_name_table()  { return "GTK_OBJECT_TABLE"; }

/* Register table in global table */
int
clip_INIT___TABLE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_table, _clip_type_name_table, _gtk_type_table, _gtk_type_container, NULL);
	return 0;
}

/**** ------------------ ****/
/**** TABLE constructor ****/
/* Used to create a new table widget. An initial size must be given by
 * specifying how many rows and columns the table should have, although
 * this can be changed later with gtk_table_resize(). */
int
clip_GTK_TABLENEW(ClipMachine * cm)
{
	ClipVar    * cv = _clip_spar(cm, 1);
        guint      rows = _clip_parni(cm,2);
        guint      cols = _clip_parni(cm,3);
        gboolean homogeneous = BOOL_OPTION(cm,4,FALSE);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t); CHECKOPT(4,LOGICAL_t);
        wid = gtk_table_new(rows,cols,homogeneous);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* If you need to change a table's size after it has been created,
 * this function allows you to do so. */
int
clip_GTK_TABLERESIZE(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint     rows = _clip_parni(cm,2);
        guint     cols = _clip_parni(cm,3);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_table_resize (GTK_TABLE(ctbl->widget), rows, cols);
	return 0;
err:
	return 1;
}

/* Adds a widget to a table. The number of 'cells' that a widget
 * will occupy is specified by left_attach, right_attach, top_attach
 * and bottom_attach. These each represent the leftmost, rightmost,
 * uppermost and lowest column and row numbers of the table.
 * (Columns and rows are indexed from 1). */
int
clip_GTK_TABLEATTACH(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        guint   left_attach = INT_OPTION(cm,3,1);
        guint  right_attach = INT_OPTION(cm,4,1);
        guint    top_attach = INT_OPTION(cm,5,1);
        guint bottom_attach = INT_OPTION(cm,6,1);
        GtkAttachOptions xoptions = _clip_parni(cm,7);
        GtkAttachOptions yoptions = _clip_parni(cm,8);
        guint xpadding = _clip_parni(cm,9);
        guint ypadding = _clip_parni(cm,10);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
        CHECKOPT(6,NUMERIC_t); CHECKOPT(7,NUMERIC_t); CHECKOPT(8,NUMERIC_t);
        CHECKOPT(9,NUMERIC_t); CHECKOPT(10,NUMERIC_t);
        gtk_table_attach(GTK_TABLE(ctbl->widget), cwid->widget, left_attach-1, right_attach-1,
        	top_attach-1, bottom_attach-1, xoptions,yoptions, xpadding,ypadding);
	return 0;
err:
	return 1;
}

/* As there are many options associated with gtk_table_attach(), this
 * convenience function provides the programmer with a means to add
 * children to a table with identical padding and expansion options. */
int
clip_GTK_TABLEATTACHDEFAULTS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        guint   left_attach = INT_OPTION(cm,3,1);
        guint  right_attach = INT_OPTION(cm,4,1);
        guint    top_attach = INT_OPTION(cm,5,1);
        guint bottom_attach = INT_OPTION(cm,6,1);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
        CHECKOPT(5,NUMERIC_t); CHECKOPT(6,NUMERIC_t);
        gtk_table_attach_defaults(GTK_TABLE(ctbl->widget), cwid->widget,
        	left_attach-1, right_attach-1, top_attach-1, bottom_attach-1);
	return 0;
err:
	return 1;
}

/* changes the space between a given table row and its surrounding rows. */
int
clip_GTK_TABLESETROWSPACING(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint      row = INT_OPTION(cm,2,1);
        guint  spacing = _clip_parni(cm,3);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_table_set_row_spacing(GTK_TABLE(ctbl->widget), row-1, spacing);
	return 0;
err:
	return 1;
}

/* alters the amount of space between a given table column and the adjacent columns. */
int
clip_GTK_TABLESETCOLSPACING(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint      col = INT_OPTION(cm,2,1);
        guint  spacing = _clip_parni(cm,3);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_table_set_col_spacing(GTK_TABLE(ctbl->widget), col-1, spacing);
	return 0;
err:
	return 1;
}

/* sets the space between every row in table equal to spacing. */
int
clip_GTK_TABLESETROWSPACINGS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint  spacing = _clip_parni(cm,2);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKOPT(2,NUMERIC_t);
        gtk_table_set_row_spacings(GTK_TABLE(ctbl->widget), spacing);
	return 0;
err:
	return 1;
}

/* sets the space between every column in table equal to spacing. */
int
clip_GTK_TABLESETCOLSPACINGS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint  spacing = _clip_parni(cm,2);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKOPT(2,NUMERIC_t);
        gtk_table_set_col_spacings(GTK_TABLE(ctbl->widget), spacing);
	return 0;
err:
	return 1;
}

/* changes the homogenous property of table cells.
 * Ie. whether all cells are an equal size or not. */
int
clip_GTK_TABLESETHOMOGENEOUS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        gboolean homogeneous = BOOL_OPTION(cm,2,FALSE);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKOPT(2,LOGICAL_t);
        gtk_table_set_homogeneous(GTK_TABLE(ctbl->widget), homogeneous);
	return 0;
err:
	return 1;
}

int
clip_GTK_TABLEGETDEFAULTROWSPACING(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        _clip_retni(cm, gtk_table_get_default_row_spacing(GTK_TABLE(ctbl->widget)));
	return 0;
err:
	return 1;
}


int
clip_GTK_TABLEGETHOMOGENEOUS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        _clip_retl(cm, GTK_TABLE(ctbl->widget)->homogeneous);
	return 0;
err:
	return 1;
}
int
clip_GTK_TABLEGETROWSPACING(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint      row = _clip_parni(cm, 2);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKARG(2, NUMERIC_t);

        _clip_retni(cm, gtk_table_get_row_spacing(GTK_TABLE(ctbl->widget), row));
	return 0;
err:
	return 1;
}

int
clip_GTK_TABLEGETCOLSPACING(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint   column = _clip_parni(cm, 2);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKARG(2, NUMERIC_t);
        _clip_retni(cm, gtk_table_get_col_spacing(GTK_TABLE(ctbl->widget), column));
	return 0;
err:
	return 1;
}


int
clip_GTK_TABLEGETDEFAULTCOLSPACING(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        _clip_retni(cm, gtk_table_get_default_col_spacing(GTK_TABLE(ctbl->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_TABLESETNROWS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint    nrows = _clip_parni(cm,2);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKOPT(2,NUMERIC_t);
        gtk_widget_set(ctbl->widget, "n-rows",nrows,NULL);
	return 0;
err:
	return 1;
}

int
clip_GTK_TABLEGETNROWS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        _clip_retl(cm, GTK_TABLE(ctbl->widget)->nrows);
	return 0;
err:
	return 1;
}

int
clip_GTK_TABLESETNCOLUMNS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        guint    ncols = _clip_parni(cm,2);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        CHECKOPT(2,NUMERIC_t);
        gtk_widget_set(ctbl->widget, "n-columns",ncols,NULL);
	return 0;
err:
	return 1;
}

int
clip_GTK_TABLEGETNCOLUMNS(ClipMachine *cm)
{
	C_widget *ctbl = _fetch_cw_arg(cm);
        CHECKCWID(ctbl,GTK_IS_TABLE);
        _clip_retl(cm, GTK_TABLE(ctbl->widget)->ncols);
	return 0;
err:
	return 1;
}

