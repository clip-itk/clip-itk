/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
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
/* Signal handlers */
static gint
handle_select_row_signal (GtkWidget *widget, gint row, gint column, GdkEventButton *event, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ROW, row+1);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_COLUMN, column+1);
	if (event)
		_clip_mputn(cs->cw->cmachine, &cv, HASH_BUTTON, event->button);
	INVOKESIGHANDLER(widget,cs,cv);
}

static gint
handle_unselect_row_signal (GtkWidget *widget, gint row, gint column, GdkEventButton *event, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ROW, row+1);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_COLUMN, column+1);
	if (event)
		_clip_mputn(cs->cw->cmachine, &cv, HASH_BUTTON, event->button);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint
handle_row_move_signal (GtkWidget *widget, gint source, gint destination, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SOURCE, source+1);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_DESTIONATION, destination+1);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint
handle_click_column_signal (GtkWidget *widget, gint column, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_COLUMN, column+1);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint
handle_resize_column_signal (GtkWidget *widget, gint column, gint width, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_COLUMN, column+1);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_NEWWIDTH, width);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint
handle_extend_selection_signal (GtkWidget *widget, GtkScrollType scroll_type, gfloat position, gboolean auto_start_selection, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLLTYPE, scroll_type);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_POSITION, position);
	_clip_mputl(cs->cw->cmachine, &cv, HASH_AUTOSTARTSELECTION, auto_start_selection);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint
handle_scroll_vertical_signal (GtkWidget *widget, GtkScrollType scroll_type, gfloat position, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLLTYPE, scroll_type);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_POSITION, position);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint
handle_scroll_horizontal_signal (GtkWidget *widget, GtkScrollType scroll_type, gfloat position, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLLTYPE, scroll_type);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_POSITION, position);
	INVOKESIGHANDLER(widget,cs,cv);
}

/* Signals table */
static SignalTable clist_signals[] =
{
	{"select-row",		GSF( handle_select_row_signal ), ESF( object_emit_signal ), GTK_SELECT_ROW_SIGNAL},
	{"unselect-row",	GSF( handle_unselect_row_signal ), ESF( object_emit_signal ), GTK_UNSELECT_ROW_SIGNAL},
	{"row-move",		GSF( handle_row_move_signal ), ESF( object_emit_signal ), GTK_ROW_MOVE_SIGNAL},
	{"click-column",	GSF( handle_click_column_signal ), ESF( object_emit_signal ), GTK_CLICK_COLUMN_SIGNAL},
	{"resize-column",	GSF( handle_resize_column_signal ), ESF( object_emit_signal ), GTK_RESIZE_COLUMN_SIGNAL},
	{"toggle-focus-row",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_TOGGLE_FOCUS_ROW_SIGNAL},
	{"select-all",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_SELECT_ALL_SIGNAL},
	{"unselect-all",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_UNSELECT_ALL_SIGNAL},
	{"undo-selection",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_UNDO_SELECTION_SIGNAL},
	{"start-selection",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_START_SELECTION_SIGNAL},
	{"end-selection",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_END_SELECTION_SIGNAL},
	{"toggle-add-mode",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_TOGGLE_ADD_MODE_SIGNAL},
	{"extend-selection",	GSF( handle_extend_selection_signal ), ESF( object_emit_signal ), GTK_EXTEND_SELECTION_SIGNAL},
	{"scroll-vertical",	GSF( handle_scroll_vertical_signal ), ESF( object_emit_signal ), GTK_SCROLL_VERTICAL_SIGNAL},
	{"scroll-horizontal",	GSF( handle_scroll_horizontal_signal ), ESF( object_emit_signal ), GTK_SCROLL_HORIZONTAL_SIGNAL},
	{"abort-column-resize",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_ABORT_COLUMN_RESIZE_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register CList in global table */
CLIP_DLLEXPORT GtkType _gtk_type_clist() { return GTK_TYPE_CLIST; }
long _clip_type_clist() { return GTK_WIDGET_CLIST; }
const char * _clip_type_name_clist() { return "GTK_WIDGET_CLIST"; }

int
clip_INIT___CLIST(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_clist, _clip_type_name_clist, _gtk_type_clist, _gtk_type_container, clist_signals);
	return 0;
}

/**** CList constructor ****/
int
clip_GTK_CLISTNEW(ClipMachine * cm)
{
	ClipVar     * cv = _clip_spar (cm,1);
	gint    ncolumns = _clip_parni(cm,2);
	ClipVar   *cvcol =  _clip_spar(cm,3);
	ClipArrVar *acol;
	int i;
	gchar * empty_string = "\0";
	gchar * * columns = NULL;
	gchar * text;
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);
	CHECKARG(2,NUMERIC_t); CHECKOPT2(3,ARRAY_t,CHARACTER_t);
	switch (_clip_parinfo(cm,3))
	{
		case CHARACTER_t:
			columns = (gchar**)calloc(sizeof(columns),ncolumns);
			text = cvcol->s.str.buf;
			LOCALE_TO_UTF(text);
			columns[0] = text;
			for(i=1; i < ncolumns; i++ )
				columns[i] = empty_string;
			wid = gtk_clist_new_with_titles(ncolumns,columns);
			if (columns) free(columns);
			FREE_TEXT(text);
			break;
		case ARRAY_t:
			acol = (ClipArrVar*)_clip_vptr( cvcol );
			columns = (gchar**)calloc(sizeof(columns),ncolumns);
/* #ifdef OS_CYGWIN*/
			for(i=0; i < ncolumns; i++ )
			{
				if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
					columns[i] = _clip_locale_to_utf8(acol->items[i].s.str.buf);
				else
					columns[i] = _clip_locale_to_utf8(empty_string);
			}
			wid = gtk_clist_new_with_titles(ncolumns,columns);
			for(i=0; i < ncolumns; i++ )
			{
				g_free(columns[i]);
			}
			if (columns) free(columns);
/*#else
			for(i=0; i < ncolumns; i++ )
			{
				if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
					columns[i] = acol->items[i].s.str.buf;
				else
					columns[i] = empty_string;
			}
			wid = gtk_clist_new_with_titles(ncolumns,columns);
			if (columns) free(columns);
#endif*/
			break;
		default:
			wid = gtk_clist_new(ncolumns);
	}

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* set adjustments of clist */
int
clip_GTK_CLISTSETHADJUSTMENT(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	C_widget *cadj = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(cadj,GTK_IS_ADJUSTMENT);
	gtk_clist_set_hadjustment(GTK_CLIST(clst->widget),GTK_ADJUSTMENT(cadj->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_CLISTSETVADJUSTMENT(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	C_widget *cadj = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWID(cadj,GTK_IS_ADJUSTMENT);
	gtk_clist_set_vadjustment(GTK_CLIST(clst->widget),GTK_ADJUSTMENT(cadj->widget));
	return 0;
err:
	return 1;
}

/* get adjustments of clist */
int
clip_GTK_CLISTGETHADJUSTMENT(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	GtkAdjustment *adj;
	C_widget *cadj;
	ClipVar * ret = RETPTR(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	adj = gtk_clist_get_hadjustment(GTK_CLIST(clst->widget));
	cadj = _list_get_cwidget(cm,adj);
	if (!cadj) cadj = _register_widget(cm,(GtkWidget*)adj,NULL);
	if (cadj) _clip_mclone(cm,ret,&cadj->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_CLISTGETVADJUSTMENT(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	GtkAdjustment *adj;
	C_widget *cadj;
	ClipVar * ret = RETPTR(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	adj = gtk_clist_get_vadjustment(GTK_CLIST(clst->widget));
	cadj = _list_get_cwidget(cm,adj);
	if (!cadj) cadj = _register_widget(cm,(GtkWidget*)adj,NULL);
	if (cadj) _clip_mclone(cm,ret,&cadj->obj);
	return 0;
err:
	return 1;
}

/* Sets the shadow type for the specified CList.
 * Changing this value will cause the GtkCList to update its visuals. */
int
clip_GTK_CLISTSETSHADOWTYPE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	GtkShadowType type = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	gtk_clist_set_shadow_type(GTK_CLIST(clst->widget), type);
	return 0;
err:
	return 1;
}

/* Sets the selection mode for the specified CList. This allows you to
 * set whether only one or more than one item can be selected at a time
 * in the widget. Note that setting the widget's selection mode to one
 * of GTK_SELECTION_BROWSE or GTK_SELECTION_SINGLE will cause all the
 * items in the GtkCList to become deselected. */
int
clip_GTK_CLISTSETSELECTIONMODE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	GtkSelectionMode mode = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	gtk_clist_set_selection_mode(GTK_CLIST(clst->widget), mode);
	return 0;
err:
	return 1;
}

/* Causes the GtkCList to stop updating its visuals until a matching call to
 * gtk_clist_thaw() is made. This function is useful if a lot of changes will
 * be made to the widget that may cause a lot of visual updating to occur.
 * Note that calls to gtk_clist_freeze() can be nested. */
int
clip_GTK_CLISTFREEZE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_freeze(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Causes the specified GtkCList to allow visual updates. */
int
clip_GTK_CLISTTHAW(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_thaw(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* This function causes the GtkCList to show its column titles,
 * if they are not already showing. */
int
clip_GTK_CLISTCOLUMNTITLESSHOW(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_column_titles_show(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Causes the GtkCList to hide its column titles,
 * if they are currently showing. */
int
clip_GTK_CLISTCOLUMNTITLESHIDE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_column_titles_hide(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Sets the specified column in the GtkCList to become selectable.
 * You can then respond to events from the user clicking on a title
 * button, and take appropriate action. */
int
clip_GTK_CLISTCOLUMNTITLEACTIVE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint    column = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	gtk_clist_column_title_active(GTK_CLIST(clst->widget), column-1);
	return 0;
err:
	return 1;
}

/* auses the specified column title button to become passive, i.e.,
 * does not respond to events, such as the user clicking on it. */
int
clip_GTK_CLISTCOLUMNTITLEPASSIVE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint    column = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	gtk_clist_column_title_passive(GTK_CLIST(clst->widget), column-1);
	return 0;
err:
	return 1;
}

/* Causes all column title buttons to become active. This is the same
 * as calling gtk_clist_column_title_active() for each column. */
int
clip_GTK_CLISTCOLUMNTITLESACTIVE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_column_titles_active(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Causes all column title buttons to become passive. This is the same as
 * calling gtk_clist_column_title_passive() for each column. */
int
clip_GTK_CLISTCOLUMNTITLESPASSIVE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_column_titles_passive(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Sets the title for the specified column. */
int
clip_GTK_CLISTSETCOLUMNTITLE(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint    column = _clip_parni(cm,2);
	gchar  * title = _clip_parc (cm,3);
	gchar * empty_string = "\0";
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,CHARACTER_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) title = empty_string;
	LOCALE_TO_UTF(title);
	gtk_clist_set_column_title(GTK_CLIST(clst->widget), column-1, title);
	FREE_TEXT(title);
	return 0;
err:
	return 1;
}

/* Sets a widget to be used as the specified column's title. This can
 * be used to place a pixmap or something else as the column title,
 * instead of the standard text. */
int
clip_GTK_CLISTSETCOLUMNWIDGET(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint    column = _clip_parni(cm,2);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,3));
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	gtk_clist_set_column_widget(GTK_CLIST(clst->widget),column-1,cwid->widget);
	return 0;
err:
	return 1;
}

/* Sets the justification to be used for all text in the specified column. */
int
clip_GTK_CLISTSETCOLUMNJUSTIFICATION(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint    column = _clip_parni(cm,2);
	GtkJustification justification = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	gtk_clist_set_column_justification(GTK_CLIST(clst->widget), column-1, justification);
	return 0;
err:
	return 1;
}

/* Allows you to set whether a specified column in the GtkCList should be hidden or
 * shown. Note that at least one column must always be showing, so attempting to hide
 * the last visible column will be ignored. */
int
clip_GTK_CLISTSETCOLUMNVISIBILITY(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	gint      column = _clip_parni(cm,2);
	gboolean visible = _clip_parl(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) visible = TRUE;
	gtk_clist_set_column_visibility(GTK_CLIST(clst->widget), column-1, visible);
	return 0;
err:
	return 1;
}

/* Lets you specify whether a specified column should be resizeable by the user.
 * Note that turning on resizeability for the column will automatically shut off
 * auto-resizing, but turning off resizeability will NOT turn on auto-resizing.
 * This must be done manually via a call to gtk_clist_set_column_auto_resize(). */
int
clip_GTK_CLISTSETCOLUMNRESIZEABLE(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	gint      column = _clip_parni(cm,2);
	gboolean resizeable = _clip_parl(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) resizeable = TRUE;
	gtk_clist_set_column_resizeable(GTK_CLIST(clst->widget), column-1, resizeable);
	return 0;
err:
	return 1;
}

/* Lets you specify whether a column should be automatically resized by the widget
 * when data is added or removed. Enabling auto-resize on a column explicity
 * disallows user-resizing of the column. */
int
clip_GTK_CLISTSETCOLUMNAUTORESIZE(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	gint      column = _clip_parni(cm,2);
	gboolean auto_resize = _clip_parl(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) auto_resize = TRUE;
	gtk_clist_set_column_auto_resize(GTK_CLIST(clst->widget), column-1, auto_resize);
	return 0;
err:
	return 1;
}

/* Gets the required width in pixels that is needed
 * to show everything in the specified column. */
int
clip_GTK_CLISTOPTIMALCOLUMNWIDTH(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	gint      column = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	_clip_retni(cm,gtk_clist_optimal_column_width(GTK_CLIST(clst->widget), column-1));
	return 0;
err:
	return 1;
}

/* Causes the column specified for the GtkCList to be set to a specified width. */
int
clip_GTK_CLISTSETCOLUMNWIDTH(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint    column = _clip_parni(cm,2);
	gint     width = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	gtk_clist_set_column_width(GTK_CLIST(clst->widget), column-1, width);
	return 0;
err:
	return 1;
}

/* Causes the column specified to have a minimum width,
 * preventing the user from resizing it smaller than that specified. */
int
clip_GTK_CLISTSETCOLUMNMINWIDTH(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint    column = _clip_parni(cm,2);
	gint min_width = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	gtk_clist_set_column_min_width(GTK_CLIST(clst->widget), column-1, min_width);
	return 0;
err:
	return 1;
}

/* Causes the column specified to have a maximum width,
 * preventing the user from resizing it larger than that specified. */
int
clip_GTK_CLISTSETCOLUMNMAXWIDTH(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint    column = _clip_parni(cm,2);
	gint max_width = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	gtk_clist_set_column_max_width(GTK_CLIST(clst->widget), column-1, max_width);
	return 0;
err:
	return 1;
}

/* Causes the GtkCList to have a specified height for its rows. Setting the
 * row height to 0 allows the GtkCList to adjust automatically to data in the row. */
int
clip_GTK_CLISTSETROWHEIGHT(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	guint   height = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	gtk_clist_set_row_height(GTK_CLIST(clst->widget), height);
	return 0;
err:
	return 1;
}

/* Tells the CList widget to visually move to the specified row and column. */
int
clip_GTK_CLISTMOVETO(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint       row = _clip_parni(cm,2);
	gint    column = _clip_parni(cm,3);
	gint    xalign = _clip_parni(cm,4);
	gint    yalign = _clip_parni(cm,5);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	gtk_clist_moveto(GTK_CLIST(clst->widget), row,column, xalign,yalign);
	return 0;
err:
	return 1;
}

/* Checks how the specified row is visible. */
int
clip_GTK_CLISTROWISVISIBLE(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	gint         row = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	_clip_retl(cm,gtk_clist_row_is_visible(GTK_CLIST(clst->widget), row-1));
	return 0;
err:
	return 1;
}

/* Checks the type of cell at the location specified. */
int
clip_GTK_CLISTGETCELLTYPE(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	gint         row = _clip_parni(cm,2);
	gint      column = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	_clip_retni(cm,gtk_clist_get_cell_type(GTK_CLIST(clst->widget), row-1, column-1));
	return 0;
err:
	return 1;
}

/* Sets the displayed text in the specified cell. */
int
clip_GTK_CLISTSETTEXT(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint       row = _clip_parni(cm,2);
	gint    column = _clip_parni(cm,3);
	gchar   * text = _clip_parc (cm,4);
	gchar * empty_string = "\0";
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t); CHECKOPT(4,CHARACTER_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (_clip_parinfo(cm,4)==UNDEF_t) text = empty_string;
	LOCALE_TO_UTF(text);
	gtk_clist_set_text(GTK_CLIST(clst->widget), row-1, column-1, text);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Gets the text for the specified cell. */
int
clip_GTK_CLISTGETTEXT(ClipMachine * cm)
{
	C_widget *clst = _fetch_cw_arg(cm);
	gint       row = _clip_parni(cm,2);
	gint    column = _clip_parni(cm,3);
	gchar   * text;
	gchar * empty_string = "\0";
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (!gtk_clist_get_text(GTK_CLIST(clst->widget), row-1, column-1, &text))
		text = empty_string;
	LOCALE_FROM_UTF(text);
	_clip_retc(cm,text);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Sets a pixmap for the specified cell. */
int
clip_GTK_CLISTSETPIXMAP(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	C_widget *cpixmap = _fetch_cwidget(cm,_clip_spar(cm,4));
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKARG2(4,MAP_t,NUMERIC_t); CHECKCWID(cpixmap,GTK_IS_PIXMAP);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	gtk_clist_set_pixmap(GTK_CLIST(clst->widget), row-1, column-1, GTK_PIXMAP(cpixmap->widget)->pixmap, GTK_PIXMAP(cpixmap->widget)->mask);
	return 0;
err:
	return 1;
}

/* Gets the pixmap and bitmap mask of the specified cell. */
int
clip_GTK_CLISTGETPIXMAP(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	GdkPixmap *pixmap;
	GdkBitmap *mask;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (gtk_clist_get_pixmap(GTK_CLIST(clst->widget), row-1, column-1, &pixmap, &mask))
	{
		C_widget *cpixmap;
		GtkWidget *xpm = gtk_pixmap_new(pixmap,mask);
		cpixmap = _register_widget(cm,xpm,NULL);
		_clip_mclone(cm, RETPTR(cm), &cpixmap->obj);
	}
	return 0;
err:
	return 1;
}

/* Sets text and a pixmap/bitmap on the specified cell. */
int
clip_GTK_CLISTSETPIXTEXT(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	gchar    * text = _clip_parc (cm,4);
	guint8  spacing = _clip_parni(cm,5);
	C_widget *cpixmap = _fetch_cwidget(cm,_clip_spar(cm,6));
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKOPT(4,NUMERIC_t); CHECKARG(5,NUMERIC_t);
	CHECKARG2(6,MAP_t,NUMERIC_t); CHECKCWID(cpixmap,GTK_IS_PIXMAP);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	LOCALE_TO_UTF(text);
	gtk_clist_set_pixtext(GTK_CLIST(clst->widget), row-1, column-1, text, spacing,
		GTK_PIXMAP(cpixmap->widget)->pixmap, GTK_PIXMAP(cpixmap->widget)->mask);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

/* Gets the text, pixmap and bitmap mask for the specified cell. */
int
clip_GTK_CLISTGETPIXTEXT(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	gchar * text;
	guint8 spacing;
	GdkPixmap *pixmap;
	GdkBitmap *mask;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	if (gtk_clist_get_pixtext(GTK_CLIST(clst->widget), row-1, column-1, &text, &spacing, &pixmap, &mask))
	{
		C_widget *cpixmap;
		GtkWidget *xpm = gtk_pixmap_new(pixmap,mask);
		cpixmap = _register_widget(cm,xpm,NULL);
		_clip_mclone(cm, RETPTR(cm), &cpixmap->obj);
		LOCALE_FROM_UTF(text);
		_clip_storc(cm,text,4,0);
		FREE_TEXT(text);
		_clip_storni(cm,spacing,5,0);
	}
	return 0;
err:
	return 1;
}

/* Sets the foreground color for the specified row. */
int
clip_GTK_CLISTSETFOREGROUND(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	ClipVar *mcolor = _clip_spar (cm,3);
	GdkColor color;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,MAP_t);
	if (_clip_parinfo(cm,3) == MAP_t)
		_map_colors_to_gdk(cm, mcolor, &color);
	else
		color = clst->widget->style->text[0];
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	gtk_clist_set_foreground(GTK_CLIST(clst->widget), row-1, &color);
	return 0;
err:
	return 1;
}

/* Sets the background color for the specified row. */
int
clip_GTK_CLISTSETBACKGROUND(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	ClipVar *mcolor = _clip_spar (cm,3);
	GdkColor color;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,MAP_t);
	if (_clip_parinfo(cm,3) == MAP_t)
		_map_colors_to_gdk(cm, mcolor, &color);
	else
		color = clst->widget->style->bg[0];
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	gtk_clist_set_background(GTK_CLIST(clst->widget), row-1, &color);
	return 0;
err:
	return 1;
}

/* Sets the style for the specified cell. */
int
clip_GTK_CLISTSETCELLSTYLE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	ClipVar *mstyle = _clip_spar (cm,4);
	GtkStyle *style;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t); CHECKARG(4,MAP_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	style = gtk_clist_get_cell_style(GTK_CLIST(clst->widget), row-1, column-1);
	_map_to_style(cm, mstyle, style);
	gtk_clist_set_cell_style(GTK_CLIST(clst->widget), row-1, column-1, style);
	return 0;
err:
	return 1;
}

/* Gets the current style of the specified cell. */
int
clip_GTK_CLISTGETCELLSTYLE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	ClipVar *mstyle = RETPTR(cm);
	GtkStyle *style;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	style = gtk_clist_get_cell_style(GTK_CLIST(clst->widget), row-1, column-1);
	if (!style) style = gtk_widget_get_style(clst->widget);
	if (style)
	{
		memset(mstyle,0,sizeof(*mstyle));
		_clip_map(cm,mstyle);
		_style_to_map(cm, style, mstyle);
	}
	return 0;
err:
	return 1;
}

/* Sets the style for all cells in the specified row. */
int
clip_GTK_CLISTSETROWSTYLE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	ClipVar *mstyle = _clip_spar (cm,3);
	GtkStyle *style;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKARG(3,MAP_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	style = gtk_clist_get_row_style(GTK_CLIST(clst->widget), row-1);
	_map_to_style(cm, mstyle, style);
	gtk_clist_set_row_style(GTK_CLIST(clst->widget), row-1, style);
	return 0;
err:
	return 1;
}

/* Gets the style set for the specified row. */
int
clip_GTK_CLISTGETROWSTYLE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	ClipVar *mstyle = RETPTR(cm);
	GtkStyle *style;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	style = gtk_clist_get_row_style(GTK_CLIST(clst->widget), row-1);
	if (!style) style = gtk_widget_get_style(clst->widget);
	if (style)
	{
		memset(mstyle,0,sizeof(*mstyle));
		_clip_map(cm,mstyle);
		_style_to_map(cm, style, mstyle);
	}
	return 0;
err:
	return 1;
}

/* Sets the vertical and horizontal shift of the specified cell. */
int
clip_GTK_CLISTSETSHIFT(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	gint   vertical = _clip_parni(cm,4);
	gint horizontal = _clip_parni(cm,5);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKARG(4,NUMERIC_t); CHECKARG(5,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	gtk_clist_set_shift(GTK_CLIST(clst->widget), row-1, column-1, vertical, horizontal);
	return 0;
err:
	return 1;
}

/* Sets whether the specified row is selectable or not. */
int
clip_GTK_CLISTSETSELECTABLE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gboolean selectable = _clip_parl(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) selectable = TRUE;
	gtk_clist_set_selectable(GTK_CLIST(clst->widget), row-1, selectable);
	return 0;
err:
	return 1;
}

/* Gets whether the specified row is selectable or not. */
int
clip_GTK_CLISTGETSELECTABLE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	_clip_retl(cm,gtk_clist_get_selectable(GTK_CLIST(clst->widget), row-1));
	return 0;
err:
	return 1;
}

/* Adds a row to the CList at the top. */
int
clip_GTK_CLISTPREPEND(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	ClipArrVar *acol = (ClipArrVar*)_clip_vptr( _clip_spar(cm,2) );
	int i;
	gchar * empty_string = "\0";
	gchar * * columns = NULL;
	int ncolumns;

	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT2(2,ARRAY_t, CHARACTER_t);
	ncolumns = GTK_CLIST(clst->widget)->columns;
	columns = (gchar**)calloc(sizeof(columns),ncolumns);

	for(i=0; i < ncolumns; i++ ) columns[i] = empty_string;
/* #ifdef OS_CYGWIN */
	if (_clip_parinfo(cm,2)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				columns[i] = _clip_locale_to_utf8(acol->items[i].s.str.buf);
		}
	}
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		columns[0] = _clip_locale_to_utf8(_clip_parc(cm,2));

	_clip_retni(cm,gtk_clist_prepend(GTK_CLIST(clst->widget),columns)+1);

	if (_clip_parinfo(cm,2)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				g_free(columns[i]);
		}
	}
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		g_free(columns[0]);

	if (columns) free(columns);
/* #else
	if (_clip_parinfo(cm,2)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				columns[i] = acol->items[i].s.str.buf;
		}
	}
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		columns[0] = _clip_parc(cm,2);

	_clip_retni(cm,gtk_clist_prepend(GTK_CLIST(clst->widget),columns)+1);
	if (columns) free(columns);
#endif */
	return 0;
err:
	return 1;
}

/* Adds a row to the CList at the bottom. */
int
clip_GTK_CLISTAPPEND(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	ClipArrVar *acol = (ClipArrVar*)_clip_vptr( _clip_spar(cm,2) );
	int i;
	gchar * empty_string = "\0";
	gchar * * columns = NULL;
	int ncolumns;

	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT2(2,ARRAY_t,CHARACTER_t);
	ncolumns = GTK_CLIST(clst->widget)->columns;
	columns = (gchar**)calloc(sizeof(columns),ncolumns);
	for(i=0; i < ncolumns; i++ ) columns[i] = empty_string;

/* #ifdef OS_CYGWIN */
	if (_clip_parinfo(cm,2)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				columns[i] = _clip_locale_to_utf8(acol->items[i].s.str.buf);
		}
	}
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		columns[0] = _clip_locale_to_utf8(_clip_parc(cm,2));

	_clip_retni(cm,gtk_clist_append(GTK_CLIST(clst->widget),columns)+1);

	if (_clip_parinfo(cm,2)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				g_free(columns[i]);
		}
	}
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		g_free(columns[0]);

	if (columns) free(columns);
/* #else
	if (_clip_parinfo(cm,2)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				columns[i] = acol->items[i].s.str.buf;
		}
	}
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		columns[0] = _clip_parc(cm,2);

	_clip_retni(cm,gtk_clist_append(GTK_CLIST(clst->widget),columns)+1);
	if (columns) free(columns);
#endif */
	return 0;
err:
	return 1;
}

/* Adds a row of text to the CList at the specified position. */
int
clip_GTK_CLISTINSERT(ClipMachine * cm)
{
	C_widget   *clst = _fetch_cw_arg(cm);
	int          row = _clip_parni(cm,2);
	ClipArrVar *acol = (ClipArrVar*)_clip_vptr( _clip_spar(cm,3) );
	int i;
	gchar * empty_string = "\0";
	gchar * * columns = NULL;
	int ncolumns;

	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT2(3,ARRAY_t,CHARACTER_t);
	ncolumns = GTK_CLIST(clst->widget)->columns;
	columns = (gchar**)calloc(sizeof(columns),ncolumns);
	for(i=0; i < ncolumns; i++ ) columns[i] = empty_string;
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
/* #ifdef OS_CYGWIN */
	if (_clip_parinfo(cm,3)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				columns[i] = _clip_locale_to_utf8(acol->items[i].s.str.buf);
		}
	}
	if (_clip_parinfo(cm,3)==CHARACTER_t)
		columns[0] = _clip_locale_to_utf8(_clip_parc(cm,3));

	_clip_retni(cm,gtk_clist_insert(GTK_CLIST(clst->widget),row-1,columns)+1);

	if (_clip_parinfo(cm,3)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				g_free(columns[i]);
		}
	}
	if (_clip_parinfo(cm,3)==CHARACTER_t)
		g_free(columns[0]);

	if (columns) free(columns);
/* #else
	if (_clip_parinfo(cm,3)==ARRAY_t)
	{
		for(i=0; i < ncolumns; i++ )
		{
			if ( i < acol->count && acol->items[i].t.type == CHARACTER_t )
				columns[i] = acol->items[i].s.str.buf;
		}
	}
	if (_clip_parinfo(cm,3)==CHARACTER_t)
		columns[0] = _clip_parc(cm,3);

	_clip_retni(cm,gtk_clist_insert(GTK_CLIST(clst->widget),row-1,columns)+1);
	if (columns) free(columns);
#endif*/
	return 0;
err:
	return 1;
}

/* Removes the specified row from the CList. */
int
clip_GTK_CLISTREMOVE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKARG(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	gtk_clist_remove(GTK_CLIST(clst->widget), row-1);
	return 0;
err:
	return 1;
}

/* Selects the specified row. Causes the "select-row" signal to be
 * emitted for the specified row and column. */
int
clip_GTK_CLISTSELECTROW(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	gtk_clist_select_row(GTK_CLIST(clst->widget), row-1, column-1);
	return 0;
err:
	return 1;
}

/* Unselects the specified row. Causes the "unselect-row" signal to be
 * emitted for the specified row and column. */
int
clip_GTK_CLISTUNSELECTROW(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	gint     column = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) column = 1;
	gtk_clist_unselect_row(GTK_CLIST(clst->widget), row-1, column-1);
	return 0;
err:
	return 1;
}

/* Undoes the last selection for an "extended selection mode" CList. */
int
clip_GTK_CLISTUNDOSELECTION(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_undo_selection(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Removes all the CList's rows. */
int
clip_GTK_CLISTCLEAR(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_clear(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Gets the row and column at the specified pixel position in the CList. */
int
clip_GTK_CLISTGETSELECTIONINFO(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint          x = _clip_parni(cm,2);
	gint          y = _clip_parni(cm,3);
	gint row, column;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKARG(2,NUMERIC_t); CHECKARG(3,NUMERIC_t);
	_clip_retni(cm,gtk_clist_get_selection_info(GTK_CLIST(clst->widget), x-1,y-1, &row,&column));
	_clip_storni(cm,row+1,4,0); _clip_storni(cm,column+1,5,0);
	return 0;
err:
	return 1;
}

/* Selects all rows in the CList. This function has no affect for a
 * CList in "single" or "browse" selection mode. */
int
clip_GTK_CLISTSELECTALL(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_select_all(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Unselects all rows in the CList. */
int
clip_GTK_CLISTUNSELECTALL(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_unselect_all(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Swaps the two specified rows with each other. */
int
clip_GTK_CLISTSWAPROWS(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint       row1 = _clip_parni(cm,2);
	gint       row2 = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKARG(2,NUMERIC_t); CHECKARG(3,NUMERIC_t);
	gtk_clist_swap_rows(GTK_CLIST(clst->widget), row1 - 1, row2 - 1);
	return 0;
err:
	return 1;
}

/* Sets the sort column of the clist. The sort column is used by the
 * default compare function to determine which column to sort by.  */
int
clip_GTK_CLISTSETSORTCOLUMN(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint     column = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	gtk_clist_set_sort_column(GTK_CLIST(clst->widget), column - 1);
	return 0;
err:
	return 1;
}

/* Sets the sort type of the GtkClist. This is either GTK_SORT_ASCENDING
 * for ascening sort or GTK_SORT_DESCENDING for descending sort. */
int
clip_GTK_CLISTSETSORTTYPE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	GtkSortType sort_type = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	gtk_clist_set_sort_type(GTK_CLIST(clst->widget), sort_type);
	return 0;
err:
	return 1;
}

/* Sorts the GtkClist according to the current compare function, which
 * can be set with the gtk_clist_set_compare_func() function. */
int
clip_GTK_CLISTSORT(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	gtk_clist_sort(GTK_CLIST(clst->widget));
	return 0;
err:
	return 1;
}

/* Turns on or off auto sort of the GtkCList. If auto sort is on,
 * then the CList will be resorted when a row is inserted into the CList. */
int
clip_GTK_CLISTSETAUTOSORT(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gboolean auto_sort = _clip_parl(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) auto_sort = TRUE;
	gtk_clist_set_auto_sort(GTK_CLIST(clst->widget), auto_sort);
	return 0;
err:
	return 1;
}

/* Auto-sizes all columns in the CList and returns the total width of the CList. */
int
clip_GTK_CLISTCOLUMNSAUTOSIZE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	_clip_retni(cm, gtk_clist_columns_autosize(GTK_CLIST(clst->widget)));
	return 0;
err:
	return 1;
}

/* Gets the current title of the specified column */
int
clip_GTK_CLISTGETCOLUMNTITLE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint     column = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	_clip_retc(cm,gtk_clist_get_column_title(GTK_CLIST(clst->widget), column - 1));
	return 0;
err:
	return 1;
}

/* Gets the widget in the column header for the specified column. */
int
clip_GTK_CLISTGETCOLUMNWIDGET(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint     column = _clip_parni(cm,2);
	GtkWidget *wid;
	C_widget *cwid;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) column = 1;
	column--;
	wid = gtk_clist_get_column_widget(GTK_CLIST(clst->widget), column);
	if (!wid && column>=0 && column<=GTK_CLIST(clst->widget)->columns)
		wid = (GTK_CLIST(clst->widget)->column[column].button);
	if (wid && GTK_IS_ALIGNMENT(wid))
		wid = GTK_BIN(&(GTK_ALIGNMENT(wid)->bin))->child;
	if (wid)
	{
		cwid = _list_get_cwidget(cm,wid);
		if (!cwid) cwid = _register_widget(cm,wid,NULL);
		if (cwid) _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	}
	return 0;
err:
	return 1;
}

/* Allows you to move a row from one position to another in the list. */
int
clip_GTK_CLISTROWMOVE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint source_row = _clip_parni(cm,2);
	gint   dest_row = _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) source_row = 1;
	if (_clip_parinfo(cm,3)==UNDEF_t) dest_row = 1;
	gtk_clist_row_move(GTK_CLIST(clst->widget), source_row - 1, dest_row - 1);
	return 0;
err:
	return 1;
}

/* Sets the action(s) that the specified mouse button will have on the CList. */
int
clip_GTK_CLISTSETBUTTONACTIONS(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	guint    button = _clip_parni(cm,2);
	guint8 button_actions= _clip_parni(cm,3);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) button = 1;
	gtk_clist_set_button_actions(GTK_CLIST(clst->widget), button, button_actions);
	return 0;
err:
	return 1;
}

/* Sets whether the CList's rows are re-orderable using drag-and-drop. */
int
clip_GTK_CLISTSETREORDERABLE(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gboolean reorderable = _clip_parl(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) reorderable = TRUE;
	gtk_clist_set_reorderable(GTK_CLIST(clst->widget), reorderable);
	return 0;
err:
	return 1;
}

/* Determines whether the GtkClist should use icons when
 * doing drag-and-drop operations. */
int
clip_GTK_CLISTSETUSEDRAGICONS(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gboolean use_icons = _clip_parl(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) use_icons = TRUE;
	gtk_clist_set_use_drag_icons(GTK_CLIST(clst->widget), use_icons);
	return 0;
err:
	return 1;
}

int
clip_GTK_CLISTGETFOCUSROW(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	_clip_retni(cm,GTK_CLIST(clst->widget)->focus_row+1);
	return 0;
err:
	return 1;
}

int
clip_GTK_CLISTSETFOCUSROW(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint   row = _clip_parni(cm,2);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKOPT(2, NUMERIC_t);
	GTK_CLIST(clst->widget)->focus_row = row-1;
	return 0;
err:
	return 1;
}

void
__row_data_destroy_func(gpointer data)
{
	C_var * cvar = (C_var*) data;

	if (!cvar || !cvar->cv)
		return;

	_clip_destroy(cvar->cm,cvar->cv);
	free(cvar);
}

int
clip_GTK_CLISTSETROWDATA(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	C_var     *cvar;
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKARG(2, NUMERIC_t);
	cvar = NEW(C_var);
	cvar->cm = cm; cvar->cv = NEW(ClipVar);
	_clip_mclone(cm, cvar->cv, _clip_par(cm,3));

	gtk_clist_set_row_data_full(GTK_CLIST(clst->widget),row-1,cvar,__row_data_destroy_func);
	return 0;
err:
	return 1;
}

int
clip_GTK_CLISTGETROWDATA(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	gint        row = _clip_parni(cm,2);
	C_var     *cvar;
	ClipVar    *ret = RETPTR(cm);
	CHECKCWID(clst,GTK_IS_CLIST);
	CHECKARG(2, NUMERIC_t);

	cvar = gtk_clist_get_row_data(GTK_CLIST(clst->widget),row-1);

	if (!cvar ||!cvar->cm || !cvar->cv)
		return 0;

	_clip_mclone(cvar->cm,ret,cvar->cv);

	return 0;
err:
	return 1;
}

int
clip_GTK_CLISTGETSELECTION(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	ClipVar *ret = RETPTR(cm);
	GList *selection = GTK_CLIST(clst->widget)->selection;
	GList *rows = GTK_CLIST(clst->widget)->row_list;
	long nsel = g_list_length(selection);

	CHECKCWID(clst,GTK_IS_CLIST);
	memset(ret,0,sizeof(*ret)); _clip_array(cm,ret,1,&nsel);

	if (nsel > 0)
	{
		ClipVar cv;
		long i, row;

		memset(&cv,0,sizeof(cv));
		cv.t.type = NUMERIC_t;

		i = 0; row = 1;
		while (rows)
		{
			if (GTK_CLIST_ROW(rows)->state & GTK_STATE_SELECTED)
			{
				cv.n.d = row;
				_clip_aset(cm,ret,&cv,1,&i);
				i++;
			}
			rows = g_list_next(rows);
			row++;
		}
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_CLISTGETCOUNTSELECTED(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	GList *selection = GTK_CLIST(clst->widget)->selection;
	CHECKCWID(clst,GTK_IS_CLIST);

	_clip_retni(cm,g_list_length(selection));

	return 0;
err:
	return 1;
}

int
clip_GTK_CLISTGETROWCOUNT(ClipMachine * cm)
{
	C_widget  *clst = _fetch_cw_arg(cm);
	CHECKCWID(clst,GTK_IS_CLIST);

	_clip_retni(cm,g_list_length(GTK_CLIST(clst->widget)->row_list));

	return 0;
err:
	return 1;
}

