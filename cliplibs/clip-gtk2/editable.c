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
static gint handle_insert_text_signal (GtkWidget *widget, gchar *new_text, gint new_text_length, gint *position, C_signal *cs)
{
	PREPARECV(cs,cv);
	LOCALE_FROM_UTF(new_text);
	_clip_mputc(cs->cw->cmachine, &cv, HASH_TEXT, new_text, new_text_length);
	FREE_TEXT(new_text);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_TEXTLENGTH, new_text_length);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_POSITION, *position);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_delete_text_signal (GtkWidget *widget, gint start_pos, gint end_pos, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_STARTPOS, start_pos);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ENDPOS, end_pos);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_set_editable_signal (GtkWidget *widget, gboolean is_editable, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputl(cs->cw->cmachine, &cv, HASH_EDITABLE, is_editable);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_move_cursor_signal (GtkWidget *widget, gint x, gint y, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_X, x);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_Y, y);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_move_word_signal (GtkWidget *widget, gint num_words, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_NUMWORDS, num_words);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_move_page_signal (GtkWidget *widget, gint x, gint y, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_X, x);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_Y, y);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_move_to_row_signal (GtkWidget *widget, gint row, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ROW, row);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_move_to_column_signal (GtkWidget *widget, gint column, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_COLUMN, column);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_kill_char_signal (GtkWidget *widget, gint direction, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_DIRECTION, direction);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_kill_word_signal (GtkWidget *widget, gint direction, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_DIRECTION, direction);
	INVOKESIGHANDLER(widget,cs,cv);
}
static gint handle_kill_line_signal (GtkWidget *widget, gint direction, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_DIRECTION, direction);
	INVOKESIGHANDLER(widget,cs,cv);
}

/* Signals table */
static SignalTable editable_signals[] =
{
	{"activate",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_ACTIVATE_SIGNAL},
	{"changed",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL},
	{"insert-text",		GSF( handle_insert_text_signal ), ESF( object_emit_signal ), GTK_INSERT_TEXT_SIGNAL},
	{"delete-text",		GSF( handle_delete_text_signal ), ESF( object_emit_signal ), GTK_DELETE_TEXT_SIGNAL},
	{"set-editable",	GSF( handle_set_editable_signal ), ESF( object_emit_signal ), GTK_SET_EDITABLE_SIGNAL},
	{"move-cursor",		GSF( handle_move_cursor_signal ), ESF( object_emit_signal ), GTK_MOVE_CURSOR_SIGNAL},
	{"move-word",		GSF( handle_move_word_signal ), ESF( object_emit_signal ), GTK_MOVE_WORD_SIGNAL},
	{"move-page",		GSF( handle_move_page_signal ), ESF( object_emit_signal ), GTK_MOVE_PAGE_SIGNAL},
	{"move-to-row",		GSF( handle_move_to_row_signal ), ESF( object_emit_signal ), GTK_MOVE_TO_ROW_SIGNAL},
	{"move-to-column",	GSF( handle_move_to_column_signal ), ESF( object_emit_signal ), GTK_MOVE_TO_COLUMN_SIGNAL},
	{"kill-char",		GSF( handle_kill_char_signal ), ESF( object_emit_signal ), GTK_KILL_CHAR_SIGNAL},
	{"kill-word",		GSF( handle_kill_word_signal ), ESF( object_emit_signal ), GTK_KILL_WORD_SIGNAL},
	{"kill-line",		GSF( handle_kill_line_signal ), ESF( object_emit_signal ), GTK_KILL_LINE_SIGNAL},
	{"cut-clipboard",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CUT_CLIPBOARD_SIGNAL},
	{"copy-clipboard",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_COPY_CLIPBOARD_SIGNAL},
	{"paste-clipboard",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_PASTE_CLIPBOARD_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register editable widget in global table */
CLIP_DLLEXPORT GtkType _gtk_type_editable() { return GTK_TYPE_EDITABLE; }
long _clip_type_editable() { return GTK_WIDGET_EDITABLE; }
const char * _clip_type_name_editable() { return "GTK_WIDGET_EDITABLE"; }

int
clip_INIT___EDITABLE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_editable, _clip_type_name_editable, _gtk_type_editable, _gtk_type_widget, editable_signals);
	return 0;
}
/**********************************************************/

/* Select a region */
int
clip_GTK_EDITABLESELECTREGION(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	gint     start = _clip_parni(cm,2);
	gint       end = _clip_parni(cm,3);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	gtk_editable_select_region(GTK_EDITABLE(cedt->widget),start,end);
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLEINSERTTEXT(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	gchar    *text = _clip_parc(cm,2);
	gint  position = _clip_parni(cm,3);
	gchar empty_text[] = "\0";
	gint  text_length;
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	CHECKOPT(2,CHARACTER_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t)
		text = empty_text;
	if (_clip_parinfo(cm,3)==UNDEF_t)
		position = gtk_editable_get_position(GTK_EDITABLE(cedt->widget));
	text_length = strlen(text);
	LOCALE_TO_UTF(text);
	gtk_editable_insert_text(GTK_EDITABLE(cedt->widget),text,text_length,&position);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLEDELETETEXT(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	gint start_pos = _clip_parni(cm,2);
	gint   end_pos = _clip_parni(cm,3);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) start_pos = 0;
	if (_clip_parinfo(cm,3)==UNDEF_t) end_pos = -1;
	gtk_editable_delete_text(GTK_EDITABLE(cedt->widget),start_pos,end_pos);
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLEGETCHARS(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	gint start_pos = _clip_parni(cm,2);
	gint   end_pos = _clip_parni(cm,3);
	gchar   * text;
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) start_pos = 0;
	if (_clip_parinfo(cm,3)==UNDEF_t) end_pos = -1;
	text = gtk_editable_get_chars(GTK_EDITABLE(cedt->widget),start_pos,end_pos);
	LOCALE_FROM_UTF(text);
	_clip_retc(cm,text);
	FREE_TEXT(text);
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLECUTCLIPBOARD(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	gtk_editable_cut_clipboard(GTK_EDITABLE(cedt->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLECOPYCLIPBOARD(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	gtk_editable_copy_clipboard(GTK_EDITABLE(cedt->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLEPASTECLIPBOARD(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	gtk_editable_paste_clipboard(GTK_EDITABLE(cedt->widget));
	return 0;
err:
	return 1;
}


int
clip_GTK_EDITABLEDELETESELECTION(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	gtk_editable_delete_selection(GTK_EDITABLE(cedt->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLEGETSELECTIONBOUNDS(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
        gint start, end;
	CHECKCWID(cedt,GTK_IS_EDITABLE);
        gtk_editable_get_selection_bounds(GTK_EDITABLE(cedt->widget), &start, &end);
	_clip_storni(cm,start,2,0);
	_clip_storni(cm,end,3,0);
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLEHASSELECTION(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
        gint start, end;
	CHECKCWID(cedt,GTK_IS_EDITABLE);
        gtk_editable_get_selection_bounds(GTK_EDITABLE(cedt->widget), &start, &end);
        start += end;
	_clip_retl(cm, start);
	return 0;
err:
	return 1;
}


int
clip_GTK_EDITABLESETPOSITION(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	gint  position = _clip_parni(cm,2);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	CHECKOPT(2,NUMERIC_t);
	gtk_editable_set_position(GTK_EDITABLE(cedt->widget),position);
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLEGETPOSITION(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	_clip_retni(cm,gtk_editable_get_position(GTK_EDITABLE(cedt->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_EDITABLESETEDITABLE(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	gboolean editable = _clip_parl(cm,2);
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) editable = TRUE;
	gtk_editable_set_editable(GTK_EDITABLE(cedt->widget),editable);
	return 0;
err:
	return 1;
}

/*
int
clip_GTK_EDITABLEGETEDITABLE(ClipMachine * cm)
{
	C_widget *cedt = _fetch_cw_arg(cm);
	GtkArg arg;
	CHECKCWID(cedt,GTK_IS_EDITABLE);
	arg.type = GTK_TYPE_BOOL;
	arg.name = "editable";
  ???	gtk_widget_get(cedt->widget, &arg);
	_clip_retl(cm,arg.d.bool_data);
	return 0;
err:
	return 1;
}
*/
