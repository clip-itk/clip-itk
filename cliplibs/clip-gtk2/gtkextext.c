/*  GtkExText
 *
 *  Copyright (C) 1999, 2000
 *  Mikael Hermansson <mikeh@bahnhof.se>
 *  Chris Phelps <chicane@reninet.com>
 *  for use in Glimmer as a code editor.
 *
 *  This library is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Library General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

//#include <config.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <fcntl.h>
#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gdk/gdkkeysyms.h>
#include <gdk/gdkprivate.h>
#include "gtkextext.h"

#define TEXT_BORDER_ROOM 2
#define CURSOR_TIMEOUT 350
#define MAX_SCROLL_WIDTH 8048
#define MIN_TEXT_WIDTH_LINES     2
#define MIN_TEXT_HEIGHT_LINES    10
#define MIN_TEXT_HEIGHT 5
#define TEXT_BUFFERT_DEFAULT_SIZE 0x8000
#define TEXT_REVERSE_MASK 0xFFFF
#define GAP_DEFAULT_SIZE TEXT_BUFFERT_DEFAULT_SIZE
#define SCROLL_TIME 4
#define DEFAULT_TAB_STOP  5
#define TEXT_STYLE_HEIGHT(style) style ? ((int )((style->ascent + style->descent)*1.2)) : 10
#define LINE_DATA_FLAGS(cur) cur->lineptr->width
#define LINE_DATA_PREV(cur) cur->lineptr->prev
#define LINE_DATA_NEXT(cur) cur->lineptr->next

#define DEFAULT_NEWLINE ' '
#define SHOW_NEWLINE 0xFE

#define DEFAULT_SPACE ' '
#define SHOW_SPACE '.'

typedef gint (*TextDataCallback) (GtkExText * text, GtkExTextLineData * lp,
                                  gint width, gint height, gpointer userdata);
guchar *text_get_text_no_replace (GtkExText * text, gint startpos, gint endpos);
GtkExTextProperty *property_remove_linked_list (GtkExText * text,
                                                GtkExTextProperty * cur);
void property_insert_linked_list (GtkExText * text, GtkExTextProperty * cur,
                                  GtkExTextProperty * next);
GtkWidget *gtk_extext_new (void);
void recompute_text_segment (GtkExText * text, gint start, gint end);
GtkExTextLineData *gtk_extext_get_line_init (GtkExText * text, gint line);
void gtk_extext_get_text_data_foreach_line (GtkExText * text,
                                            GtkExTextLineData * lp,
                                            TextDataCallback st,
                                            gpointer user_data);
static gint text_data_set_line_data (GtkExText * text, GtkExTextLineData * lp,
                                     gint width, gint height, gpointer data);

/*****************************************************************************/
/*                                    Utils                                      */
/*****************************************************************************/

gboolean is_value_ok (gint value, gint start, gint end);
gint get_next_return (gchar * text, gint len);
gint get_next_return_and_tab_indexes (gchar * text, gint fromstartpos,
                                      gint len, GList ** list);
gint get_tab_count (gchar * txt, gint len);
gint get_return_count (gchar * txt, gint len);
gint get_real_text_height (GdkFont * font);

/*****************************************************************************/
/*                               InsertDelete characters API                                 */
/*****************************************************************************/
static gint text_insert_new_lines (GtkExText * text, char *txt, gint len,
                                   GtkExTextLineData * data,
                                   GList ** tabindexes);
static gint text_insert (GtkExText * text, gint pos, char *txt, gint len,
                         gboolean changed_signal);
static gint text_remove (GtkExText * text, gint startpos, gint len);
static void make_room_for (GtkExText * text, gint length);
void gap_to (GtkExText * text, gint length);
static gint text_set_pos (GtkExText * class, gint pos);
guchar *text_get_text_with_expanded_tabs (GtkExText * text, gint linestart,
                                          gint start, gint end, gint * rtabs,
                                          gint * rspaces);
guchar *text_get_text (GtkExText * text, gint start, gint end);
gint move_cursor (GtkExText * text, gint moveto, gboolean select);

/*****************************************************************************/
/*                              Undo buffertcode                                */
/*****************************************************************************/

void extext_undo_insert (GtkExText * text, guint start, guint length,
                         gboolean insertion);
gboolean gtk_extext_remove_undo_entry (GtkExText * text, guint level);

/*****************************************************************************/
/*                           Insert Delete Line code                             */
/*****************************************************************************/

static void line_set_len (GtkExText * text, GtkExTextLineData * linedataptr,
                          gint len);
static GtkExTextLineData *line_insert (GtkExText * textext,
                                       GtkExTextLineData * cur, gint count);
static GtkExTextLineData *line_remove (GtkExText * textext,
                                       GtkExTextLineData * cur);
static GtkExTextLineData *line_set_by_ptr (GtkExText * class,
                                           GtkExTextLineData * data,
                                           gboolean forward);
static Lines *line_set (GtkExText * text, gint line);
static gint line_set_cursor_pos (GtkExText * text, gint pos);

static GtkExTextLineData *line_get_by_char_pos (GtkExText * text, gint pos,
                                                GtkExTextLineData *);
static GtkExTextLineData *line_get_by_offset (GtkExText * text, gint y,
                                              gint * newoffsety);
static gint column_get_by_offset (GtkExText * text, GtkExTextLineData * data,
                                  gint x, gint * newoffsetx);

/*****************************************************************************/
/*                        Insert/Delete Style Cache API                          */
/*****************************************************************************/

typedef struct _FontRef {
    GdkFont *font;
    gboolean exist;             /* is TRUE if font already exist in stylellist */
} FontRef;

void style_init_each (gpointer key, GtkExTextStyle * style, GtkExText * text);
void style_destroy_each (gpointer key, gpointer freeme, gpointer data);
void style_font_ref_each (gpointer key, GtkExTextStyle * style, FontRef * ref);
void gtk_extext_style_remove_real (GtkExText * text, gchar * key);

void propertys_destroy (GtkExText * text);


/*****************************************************************************/
/*                                 WIDGET API                                   */
/*****************************************************************************/

static gint get_line_number_width (GtkExText * text);

gint draw_text_chunk (GtkExText * text, GdkDrawable * draw_area,
                      GtkExTextStyle * style, gchar * chunk, gint length,
                      gint x, gint y, gint h);
gint get_tabs_between (GtkExText * text, gint start, gint end);
gint get_spaces_between (GtkExText * text, gint linestart, gint start,
                         gint end);
static gint extext_get_line_width (GtkExText * text,
                                   GtkExTextLineData * linedataptr, gint pos);
static gint extext_get_line_width_special (GtkExText * text,
                                           GtkExTextLineData * linedataptr,
                                           gint s, gint e);
static gint extext_get_line_height (GtkExText * text,
                                    GtkExTextLineData * linedataptr);

gint expose_line_text (GtkExText * text, GdkDrawable * draw,
                       GtkExTextLineData * linedataptr, gint x, gint y);
static void gtk_extext_adjustment_changed (GtkAdjustment * adjustment,
                                           GtkExText * text);
static void gtk_extext_adjustment_value_changed (GtkAdjustment * adjustment,
                                                 GtkExText * text);
static void gtk_extext_disconnect (GtkAdjustment * adjustment,
                                   GtkExText * text);

static void gtk_extext_class_init (GtkExTextClass * text);
static void gtk_extext_init (GtkExText * text);
static void gtk_extext_destroy (GtkObject * text);

static void gtk_extext_finalize (GtkObject * object);
static void gtk_extext_realize (GtkWidget * widget);
static void gtk_extext_unrealize (GtkWidget * widget);
static gint gtk_extext_cursor_blink (gpointer data);

/* Event handlers */

static gint ugly_popup_hack (GtkWidget * w, GdkEventButton * ev);
static void recompute_geometry (GtkExText * text);
static void recompute_scroll_line_width (GtkExText * text,
                                         GtkExTextLineData * lp, gint count);
static void recompute_scroll_line_height (GtkExText * text);

static void recompute_scroll_line_data (GtkExText * text, gint pos,
                                        gboolean resetprop);

static void gtk_extext_size_allocate (GtkWidget * widget,
                                      GtkAllocation * allocation);

static void gtk_extext_size_request (GtkWidget * widget,
                                     GtkRequisition * requisition);

static void gtk_extext_draw (GtkWidget * widget, GdkRectangle * area);
static gint gtk_extext_expose (GtkWidget * widget, GdkEventExpose * event);
static gint gtk_extext_button_press (GtkWidget * widget,
                                     GdkEventButton * event);
static gint gtk_extext_button_release (GtkWidget * widget,
                                       GdkEventButton * event);
static gint gtk_extext_motion_notify (GtkWidget * widget,
                                      GdkEventMotion * event);
static gint gtk_extext_key_press (GtkWidget * widget, GdkEventKey * event);
static gint gtk_extext_focus_in (GtkWidget * widget, GdkEventFocus * event);
static gint gtk_extext_focus_out (GtkWidget * widget, GdkEventFocus * event);
static void gtk_extext_draw_focus (GtkWidget * widget);
static gint gtk_extext_queue_draw (GtkWidget * widget);

static gint gtk_extext_real_property_text_insert (GtkExText * text,
                                                  GtkExTextProperty * prop,
                                                  gint startpos, gint endpos);
static gint gtk_extext_real_property_text_remove (GtkExText * text,
                                                  GtkExTextProperty * prop,
                                                  gint startpos, gint endpos);


/*****************************************************************************/
/*                                 New signals                                   */
/*****************************************************************************/

static Lines *goto_line (GtkExText * text, gint lineto, gboolean sel,
                         gboolean killselect, gboolean bottom);
void view_to_scroll (GtkExText * text);
void scroll_to_view (GtkExText * text, gint line, gboolean bottom);
static void find_cursor (GtkExText * text, gdouble x, gdouble y,
                         gboolean select);
static void update_select (GtkExText * text, gint oldpos, gboolean select,
                           gboolean killselect);

static gint gtk_extext_selection_clear (GtkWidget * widget,
                                        GdkEventSelection * event);
static void gtk_extext_selection_received (GtkWidget * widget,
                                           GtkSelectionData * selection_data,
                                           guint time);
static void gtk_extext_selection_get (GtkWidget * widget,
                                      GtkSelectionData * selection_data,
                                      guint info, guint time);
static void gtk_extext_claim_selection (GtkExText * text, gboolean claim,
                                        guint32 time);
void gtk_extext_select_region (GtkExText * text, gint start, gint end);
static void gtk_extext_set_selection (GtkExText * text, gint start, gint end);
static guint32 gtk_extext_get_event_time (GtkExText * text);

/* Static Highlighting functions */
static gint property_text_remove (GtkExText * text, GtkExTextProperty * prop,
                                  gint start, gint end);

static gint property_text_insert (GtkExText * text, GtkExTextProperty * prop,
                                  gint start, gint end);

static void check_syntax (GtkExText * text, gint start, gint end);

static void check_embedded (GtkExText * text, gint start, gint end,
                            GtkExTextProperty * prev);

static void check_pattern (GtkExText * text, gint start, gint end,
                           GtkExTextProperty * prev);

static gint get_syntax_end (GtkExText * text, gint pos,
                            GtkExTextSyntaxEntry * table, GtkExTextMatch * m);

/* values for selection info */

enum {
    TARGET_STRING,
    TARGET_TEXT,
    TARGET_COMPOUND_TEXT
};

/* Signals */
enum {
    INSERT_TEXT,
    DELETE_TEXT,
    CHANGED,
    MOVE_TO_ROW,
    MOVE_TO_COLUMN,
    CUT_CLIPBOARD,
    COPY_CLIPBOARD,
    PASTE_CLIPBOARD,
    PROPERTY_TEXT_INSERT,
    PROPERTY_TEXT_REMOVE,
    PROPERTY_DESTROY,
    UNDO_CHANGED,
    PROPERTY_MARK,
    LINE_INSERT,
    LINE_REMOVE,
    MARGIN_ENTER,
    MARGIN_EXIT,
    MARGIN_CLICKED,
    LAST_SIGNAL
};

static GtkWidgetClass *parent_class = NULL;
static guint extext_signals[LAST_SIGNAL] = { 0 };
static GdkAtom clipboard_atom = GDK_NONE;

/*****************************************************************************/
/*                          hmm lets start coding :-)                            */
/*****************************************************************************/

gint
get_next_return (gchar * text, gint len)
{
    gint index;

    for (index = 0; index < len; index++) {
        if (text[index] == '\n')
            return index;
    }
    return -1;
}

gint
get_next_return_and_tab_indexes (gchar * text, gint fromstart, gint len,
                                 GList ** list)
{
    gint index;

    for (index = 0; index < len; index++) {
        if (text[index] == '\t')
            *list = g_list_append (*list, GINT_TO_POINTER (fromstart + index));

        if (text[index] == '\n')
            return index;
    }
    return -1;
}

gint
get_tab_count (gchar * txt, gint len)
{
    gint tabs = 0;
    gint i = 0;

    if (len == -1)
        len = strlen (txt);
    while (i < len) {
        if (txt[i] == '\t')
            tabs++;
        i++;
    }
    return tabs;
}

gint
get_return_count (gchar * txt, gint len)
{
    gint ret = 0;
    gint i = 0;

    while (i < len) {
        if (txt[i] == '\n')
            ret++;
        i++;
    }
    return ret;
}

gint
is_value_ok (gint pos, gint start, gint end)
{
    if (pos >= start && pos < end)
        return 0;
    if (pos < start)
        return -1;
    return 1;
}


/*****************************************************************************/
/*              gtk_extext_get_current_word return TRUE if word                 */
/*****************************************************************************/

gboolean
gtk_extext_get_current_word (GtkExText * text, gint * startpos, gint * endpos)
{
    gint key;
    gint pos;
    gint end = *startpos;

    pos = *startpos;
    key = GTK_EXTEXT_INDEX (text, pos);

    if (ispunct (key)) {
        if (endpos)
            *endpos = pos + 1 <= text->length ? pos + 1 : text->length;
        return (TRUE);
    } else if (isalpha (key)) {
        while (isalnum (key) || key == '#') {
            pos--;
            if (pos < 0)
                break;
            key = GTK_EXTEXT_INDEX (text, pos);
        }

        *startpos = pos + 1;
        if (!endpos)
            return (TRUE);

        pos = end;
        key = GTK_EXTEXT_INDEX (text, pos);
        while (isalnum (key) || key == '#') {
            pos++;
            if (pos > text->length)
                break;
            key = GTK_EXTEXT_INDEX (text, pos);
        }
        *endpos = pos <= text->length ? pos : text->length;
        return (TRUE);
    } else if (isdigit (key)) {
        while (isdigit (key) || key == '.' || key == 'x' || key == '#'
               || (key >= 'a' && key <= 'f') || (key >= 'A' && key <= 'F')) {
            pos--;
            if (pos < 0)
                break;
            key = GTK_EXTEXT_INDEX (text, pos);
        }

        *startpos = pos + 1;
        if (!endpos)
            return (TRUE);
        pos = end;
        key = GTK_EXTEXT_INDEX (text, pos);
        while (isdigit (key) || key == '.' || key == 'x' || key == '#'
               || (key >= 'a' && key <= 'f') || (key >= 'A' && key <= 'F')) {
            pos++;
            if (pos > text->length)
                break;
            key = GTK_EXTEXT_INDEX (text, pos);
        }
        *endpos = pos <= text->length ? pos : text->length;
        return (TRUE);
    }
    return (FALSE);
}

gboolean
gtk_extext_get_previous_word (GtkExText * text, gint * startpos, gint * endpos)
{
    gint pos;
    gint end;

    if (!startpos || *startpos == 0)
        return (FALSE);
    pos = *startpos;
    if (gtk_extext_get_current_word (text, &pos, NULL))
        pos--;
    while (!gtk_extext_get_current_word (text, &pos, &end) && pos > 0)
        pos--;
    if (pos < 0)
        return FALSE;
    if (startpos)
        *startpos = pos;
    if (endpos)
        *endpos = end < text->length ? end : text->length;
    return (TRUE);
}

gboolean
gtk_extext_get_next_word (GtkExText * text, gint * startpos, gint * endpos)
{
    gint pos;
    gint end;

    if (!startpos || *startpos == 0) {
        return (FALSE);
    }
    pos = *startpos;
    if (gtk_extext_get_current_word (text, &pos, NULL))
        pos++;
    while (!gtk_extext_get_current_word (text, &pos, &end)
           && pos <= text->length)
        pos++;
    if (pos > text->length)
        return FALSE;
    if (startpos)
        *startpos = pos > 0 ? pos : 0;
    if (endpos)
        *endpos = end < text->length ? end : text->length;
    return TRUE;
}

void
gap_to (GtkExText * text, gint pos)
{
    gint i = 0;

    if (pos == text->part1len)
        return;

    if (pos < text->part1len) {
        for (i = 0; i < text->part1len - pos; i++)
            text->text[text->part1len + text->gap_len - i - 1] =
                text->text[text->part1len - i - 1];
    } else {
        for (i = 0; i < pos - text->part1len; i++)
            text->text[text->part1len + i] =
                text->text[text->part1len + text->gap_len + i];
    }
    text->part1len = pos;
    text->part2text = text->text + text->gap_len;
}

void
make_room_for (GtkExText * text, gint len)
{
    gint newsize;
    gint count;

    if (text->gap_len <= len) {
        gap_to (text, text->length);
        count = len / text->size;
        if (count * text->size < len)
            count++;
        newsize = text->gap_len + text->length + (text->size * count);
        text->text = g_realloc (text->text, newsize);
        text->gap_len = newsize - text->length;
        text->part2text = text->text + text->gap_len;
    }
}

gint
text_set_pos (GtkExText * text, gint pos)
{
    GtkExTextLineData *linedataptr;
    gboolean forward;

    forward = FALSE;
    if (pos >= text->current_pos)
        forward = TRUE;

    if (pos > text->length)
        text->current_pos = text->length;
    else if (pos == -1)
        text->current_pos = 0;
    else
        text->current_pos = pos;

    linedataptr = line_get_by_char_pos (text, pos, NULL);
    if (linedataptr->lineptr != text->line_ptr) {
        linedataptr = line_set_by_ptr (text, linedataptr, forward);
    }
    line_set_cursor_pos (text, text->current_pos - linedataptr->startpos);
    g_free (linedataptr);
    return text->current_pos;
}


gint
text_insert (GtkExText * text, gint pos, gchar * txt, gint len,
             gboolean removethis)
{
    GtkExTextLineData *linedataptr;
    GtkExTextProperty *property_first;
    GtkExTextProperty *prop;

    gchar *tmp = NULL;
    GList *list = NULL;
    gint old_line_number;
    gint new_lines_count;
    gint signal_return_value;

    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);

    if (!len)
        return text->length;
    if (len == -1)
        len = strlen (txt);

    prop = NULL;
    signal_return_value = FALSE;
    text->text_insert_delete_flag = TRUE;
    old_line_number = text->line_number;

    if (pos != text->current_pos)
        gtk_extext_set_position (text, pos);    /* must call this to update correct */

    linedataptr =
        gtk_extext_get_line_data (text, text->line_number,
                                  text->scroll_line_start);
    property_first = linedataptr->property_first;

    new_lines_count =
        text_insert_new_lines (text, txt, len, linedataptr, &list);
#ifdef BUGGY
    if (text->use_spaces && list) {
        gint lastpos = 0;
        gint spaces = 0;
        GList *cur = g_list_first (list);

        g_print ("found %d tabs\n", g_list_length (list));
        len += g_list_length (list) * 2;
        tmp = g_new (gchar, len + 1);
        while (cur) {
            memcpy (&tmp[lastpos + spaces], &txt[lastpos + 1],
                    GPOINTER_TO_INT (cur->data) - lastpos);
            lastpos = GPOINTER_TO_INT (cur->data);
            tmp[lastpos + spaces] = ' ';
            tmp[lastpos + spaces + 1] = ' ';
            spaces += 2;
            len -= GPOINTER_TO_INT (cur->data) + spaces;
            cur = g_list_next (cur);
        };
        /*if(len > 0)
           memcpy(&tmp[lastpos],&txt[tablen],len-tablen-1);
         */
        txt = tmp;
    }
#endif

    make_room_for (text, len);
    gap_to (text, pos);

    memcpy (text->text + text->part1len, txt, len);
    text->part1len += len;
    text->length += len;
    text->gap_len -= len;
    text->part2text = text->text + text->gap_len;

    if (text->highlight) {
        property_text_insert (text, property_first, pos, pos + len);
    } else {
        gtk_signal_emit (GTK_OBJECT (text),
                         extext_signals[PROPERTY_TEXT_INSERT], property_first,
                         pos, pos + len, &signal_return_value);
        if (!signal_return_value)
            gtk_extext_real_property_text_insert (text, property_first, pos,
                                                  pos + len);
    }

    /* we need to update linedataptr with the new values */
    /* THIS IS THERE TO MAKE SURE TO UPDATE ALL lines */
    /* between oldlinepos < text->scroll_line_index */

    g_free (linedataptr);

    linedataptr = text->scroll_line_start;
    if (old_line_number < text->scroll_line_start->line_number)
        linedataptr =
            gtk_extext_get_line_data (text, old_line_number,
                                      text->scroll_line_start);
    else
        linedataptr =
            gtk_extext_get_line_data (text, text->line_number, linedataptr);

    recompute_scroll_line_width (text, linedataptr, new_lines_count + 1);
    g_free (linedataptr);

    gtk_extext_set_position (text, pos + len);  /* must call this to update correct */
    extext_undo_insert (text, pos, len, FALSE);

    text->text_insert_delete_flag = FALSE;

    if (txt == tmp)
        g_free (tmp);
    if (list)
        g_list_free (list);

    return pos + len;
}

gint
text_insert_new_lines (GtkExText * text, char *txt, gint len,
                       GtkExTextLineData * linedataptr, GList ** list)
{
    gint line_number = text->line_number;
    gint start = 0;
    gint end = 0;
    gint column_number = 0;
    gint diff = 0;
    gint new_lines_count = 0;

    new_lines_count = get_return_count (txt, len);
    if (new_lines_count) {      /* has return characters */
        gint retcount = new_lines_count;

        /* linecurpos has chars before before this line */

        if (text->use_spaces)
            end = get_next_return (txt, len);
        else
            end = get_next_return_and_tab_indexes (txt, 0, len, list);

        start = end + 1;

        /* position  where cursor is */
        column_number = text->column_number;
        /* diff is all chars after return in curline */
        /*      this chars is moved to newline */

        diff = LINE_DATA_LENGTH (linedataptr) - text->column_number;
        line_set_len (text, linedataptr, column_number + end + 1);
        line_insert (text, linedataptr, new_lines_count);

        retcount--;
        if (!retcount) {        /*last return */
            line_number++;
            linedataptr =
                gtk_extext_get_line_data (text, line_number, linedataptr);
            line_set_len (text, linedataptr, diff + len - start);
        } else {
            if (text->use_spaces)
                end =
                    get_next_return_and_tab_indexes (&txt[start], start,
                                                     len - start, list);
            else
                end = get_next_return (&txt[start], len - start);

            while (end != -1) {
                retcount--;
                line_number++;
                linedataptr =
                    gtk_extext_get_line_data (text, line_number, linedataptr);
                line_set_len (text, linedataptr, end + 1);
                start += end + 1;
                if (text->use_spaces)
                    end =
                        get_next_return_and_tab_indexes (&txt[start], start,
                                                         len - start, list);
                else
                    end = get_next_return (&txt[start], len - start);

                column_number = 0;  /* we have inserted a new line and has no chars yet */
            }
            line_number++;
            start += end + 1;
            linedataptr =
                gtk_extext_get_line_data (text, line_number, linedataptr);
            line_set_len (text, linedataptr, diff + (len - start));
        }
    } else {
        line_set_len (text, linedataptr, text->line_ptr->length + len);
    }

    return new_lines_count;
}

gint
text_remove (GtkExText * text, gint pos, gint len)
{
    GtkExTextProperty *property_first;
    GtkExTextLineData *linedataptr;
    gint i;
    gint oldlinelen;
    gint lindex;
    gint linelen;
    gint signal_return_value;
    gint lastline_endpos;
    gboolean lines_removed = FALSE;

    g_return_val_if_fail (text != NULL, 0);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), 0);

    signal_return_value = FALSE;
    text->text_insert_delete_flag = TRUE;

    if (len <= 0 || !text->length || pos < 0)
        return text->current_pos;

    if (pos >= text->length)
        return text->current_pos;

    if (len + pos > text->length)
        len = text->length - pos;

    if (pos >= text->selection_start_pos)
        text->selection_start_pos = -1;
    if (len + pos <= text->selection_end_pos)
        text->selection_end_pos = -1;

    extext_undo_insert (text, pos, len, TRUE);

    linedataptr = line_get_by_char_pos (text, pos, NULL);
    property_first = linedataptr->property_first;
    linelen = LINE_DATA_LENGTH (linedataptr);
    lindex = linedataptr->line_number;
    for (i = pos; i < len + pos; i++) {
        if (GTK_EXTEXT_INDEX (text, i) == '\n') {
            /* always remove line AFTER Current line */
            /* this because we should never remove FIRST line */
            /* ask for all characters before RETURN char */

            /* get next line length */
            lindex++;
            linedataptr = gtk_extext_get_line_data (text, lindex, linedataptr);
            oldlinelen = LINE_DATA_LENGTH (linedataptr) - 1;

            /* remove next line wish line */
            linedataptr = line_remove (text, linedataptr);
            /* line_remove returns previous line */
            line_set_len (text, linedataptr,
                          oldlinelen + LINE_DATA_LENGTH (linedataptr));

            linelen = LINE_DATA_LENGTH (linedataptr);
            lindex = linedataptr->line_number;
            lines_removed = TRUE;
        } else {
            linelen--;
            line_set_len (text, linedataptr, linelen);
        }
    }
    if (lines_removed && text->draw_numbers)
        gtk_extext_set_draw_numbers (text, TRUE);
    lastline_endpos = linedataptr->endpos;
    g_free (linedataptr);
    linedataptr = NULL;

    gap_to (text, pos);
    text->length -= len;
    text->gap_len += len;
    text->part2text = text->text + text->gap_len;

    text_set_pos (text, pos);
    if (text->highlight) {
        property_text_remove (text, property_first, pos, pos + len);
    } else {
        gtk_signal_emit (GTK_OBJECT (text),
                         extext_signals[PROPERTY_TEXT_REMOVE], property_first,
                         pos, pos + len, &signal_return_value);
        if (!signal_return_value)
            gtk_extext_real_property_text_remove (text, property_first, pos,
                                                  pos + len);
    }

    linedataptr =
        gtk_extext_get_line_data (text, text->line_number,
                                  text->scroll_line_start);
    gtk_extext_get_text_data_foreach_line (text, linedataptr,
                                           &text_data_set_line_data,
                                           GINT_TO_POINTER (lastline_endpos));
    g_free (linedataptr);

    text->text_insert_delete_flag = FALSE;
    return text->current_pos;
}

static gint
gtk_extext_real_property_text_insert (GtkExText * text,
                                      GtkExTextProperty * property_first,
                                      gint pos, gint endpos)
{
    GtkExTextProperty *prop;
    gint len = endpos - pos;

    g_return_val_if_fail (text != NULL, TRUE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), TRUE);

    prop =
        gtk_extext_property_get_at_pos (text, pos ? pos - 1 : 0,
                                        property_first);
    if (prop && prop->startpos != pos) {
        prop->endpos += len;
        gtk_extext_property_move_all (text, endpos, len, property_first);
    } else
        gtk_extext_property_move_all (text, pos, len, property_first);
    return TRUE;
}

static gint
gtk_extext_real_property_text_remove (GtkExText * text,
                                      GtkExTextProperty * property_first,
                                      gint pos, gint endpos)
{
    GtkExTextProperty *prop, *prop_end;
    gint len = endpos - pos;

    g_return_val_if_fail (text != NULL, TRUE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), TRUE);

    prop = gtk_extext_property_get_at_pos (text, pos, property_first);
    prop_end =
        gtk_extext_property_get_at_pos (text, endpos - 1, property_first);

    if (prop == prop_end) {
        if (prop)
            prop->endpos -= len;
        gtk_extext_property_move_all (text, endpos, -len, property_first);
        return TRUE;
    }
    /* the same */
    else if (prop_end && prop_end->endpos >= endpos) {
        prop_end->endpos = pos;
        gtk_extext_property_insert (text, prop->style->key, endpos,
                                    prop_end->endpos, prop_end->user_data,
                                    PROPERTY_INSERT, property_first);
        gtk_extext_property_move_all (text, prop_end->endpos, -len,
                                      property_first);
        gtk_extext_property_remove_all (text, pos, endpos, property_first);
    } else {
        if (prop)
            prop->endpos = pos;
        gtk_extext_property_move_all (text, endpos, -len, property_first);
        gtk_extext_property_remove_all (text, pos, endpos, property_first);
    }
    return TRUE;
}

guchar
gtk_extext_get_char_at_pos (GtkExText * text, gint pos)
{
    return pos < text->part1len ? text->text[pos] : text->part2text[pos];
}

guchar *
text_get_text_with_expanded_tabs (GtkExText * text, gint linestart,
                                  gint start, gint end, gint * rtabs,
                                  gint * rspaces)
{
    GList *tabstops = NULL;
    guchar *newtxt;
    gint len;
    gint i = 0;
    gint n = 0;
    gint tabs = 0;
    gint spaces = 0;
    gint tspaces = 0;
    gint spacer = 0;
    gint abscol = 0;

    g_return_val_if_fail (text != NULL, NULL);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);

    if (rspaces)
        tspaces = *rspaces;

    len = end - start;
    i = start;

    while (i < end) {
        if (GTK_EXTEXT_INDEX (text, i) == '\t') {
            abscol = (i + tspaces) - linestart;
            if (text->tab_stops)
                spacer =
                    text->default_tab_width -
                    (abscol % text->default_tab_width);
            else
                spacer = text->default_tab_width;
            tabstops = g_list_append (tabstops, GINT_TO_POINTER (spacer));
            tspaces += spacer - 1;
            spaces += spacer - 1;
            tabs++;
        }
        i++;
    }
    if (tabs || text->show_newlines || text->show_whitespace) {
        n = 0;
        newtxt = g_malloc (len + spaces + 1);
        tabs = 0;
        for (i = start; i < end; i++) {
            if (GTK_EXTEXT_INDEX (text, i) == '\t') {
                spacer = (gint) g_list_nth_data (tabstops, tabs);
                memset (&newtxt[n],
                        text->show_whitespace ? SHOW_SPACE : DEFAULT_SPACE,
                        spacer);
                n += spacer;
                tabs++;
            } else if (GTK_EXTEXT_INDEX (text, i) == ' ')
                newtxt[n++] =
                    text->show_whitespace ? SHOW_SPACE : DEFAULT_SPACE;
            else if (GTK_EXTEXT_INDEX (text, i) == '\n')
                newtxt[n++] =
                    text->show_newlines ? SHOW_NEWLINE : DEFAULT_NEWLINE;
            else
                newtxt[n++] = GTK_EXTEXT_INDEX (text, i);
        }
        newtxt[n] = '\0';
    } else
        newtxt = text_get_text (text, start, end);

    if (rtabs)
        *rtabs = tabs;
    if (rspaces)
        *rspaces = tspaces;
    if (tabstops)
        g_list_free (tabstops);
    return newtxt;
}

guchar *
text_get_text (GtkExText * text, gint startpos, gint endpos)
{
    guchar *txt;
    gint i;
    gint len;

    if (endpos < startpos) {
        g_warning ("Startpos > endpos[text_get_text(%X,%d %d)\n", (gint) text,
                   startpos, endpos);
        return NULL;
    }

    if (startpos > text->length) {
        g_warning
            ("Startpos out of range [text_get_text(%X,%d,%d)] text->length: %d\n",
             (gint) text, startpos, endpos, text->length);

        return NULL;
    }

    if (endpos > text->length)
        endpos = text->length;

    if (startpos == endpos)
        return NULL;

    len = endpos - startpos;
    txt = g_malloc (len + 1);
    for (i = 0; i < len; i++) {
        if (GTK_EXTEXT_INDEX (text, startpos + i) == '\n')
            txt[i] = ' ';
        else
            txt[i] = GTK_EXTEXT_INDEX (text, startpos + i);
    }
    txt[i] = '\0';

    return txt;
}

guchar *
text_get_text_no_replace (GtkExText * text, gint startpos, gint endpos)
{
    guchar *txt;
    gint i;
    gint len;

    if (endpos < startpos) {
        g_warning ("Startpos > endpos[text_get_text(%X,%d %d)\n", (gint) text,
                   startpos, endpos);
        return NULL;
    }

    if (startpos > text->length) {
        g_warning
            ("Startpos out of range [text_get_text(%X,%d,%d)] text->length: %d\n",
             (gint) text, startpos, endpos, text->length);

        return NULL;
    }

    if (endpos > text->length)
        endpos = text->length;

    if (startpos == endpos)
        return NULL;

    len = endpos - startpos;
    txt = g_malloc (len + 1);
    for (i = 0; i < len; i++) {
        txt[i] = GTK_EXTEXT_INDEX (text, startpos + i);
    }
    txt[i] = '\0';

    return txt;
}

/* the main handler to set cursor at pos */
/* called by text_set_pos */
/* and goto_line  */

static gint
line_set_cursor_pos (GtkExText * text, gint cursorpos)
{
    Lines *oldline;
    gint len, oldcol;
    gint width, full_width;

    //gint oldbak;
    gfloat val;
    GtkExTextProperty *prop;
    GtkExTextLineData *linedataptr;

    linedataptr =
        gtk_extext_get_line_data (text, text->line_number,
                                  text->scroll_line_start);
    //oldbak = text->lci_bak;

    prop = text->property_current;
    oldcol = text->column_number;
    oldline = linedataptr->lineptr;
    len = LINE_DATA_LENGTH (linedataptr);
    if (cursorpos < 0) {
        gtk_extext_get_line_data (text, text->line_number - 1, linedataptr);
        line_set_by_ptr (text, linedataptr, FALSE);
        if (oldline != linedataptr->lineptr)
            text->column_number = text->line_ptr->length - 1;
        else
            text->column_number = 0;
    } else if (cursorpos > len) {
        gtk_extext_get_line_data (text, text->line_number + 1, linedataptr);
        line_set_by_ptr (text, linedataptr, TRUE);
        if (oldline == linedataptr->lineptr)
            text->column_number = len;
        else
            text->column_number = 0;
    } else if (cursorpos == len) {
        if (text->current_pos == linedataptr->startpos + cursorpos - 1) {
            gtk_extext_get_line_data (text, text->line_number + 1, linedataptr);
            line_set_by_ptr (text, linedataptr, TRUE);
            if (oldline == linedataptr->lineptr)
                text->column_number = len;
            else
                text->column_number = 0;
        } else {
            if (GTK_EXTEXT_INDEX (text, linedataptr->endpos - 1) == '\n')
                text->column_number = len - 1 > 0 ? len - 1 : 0;
            else
                text->column_number = len;
        }
    } else {
        text->column_number = cursorpos;
        //text->lci_bak = text->column_number;
    }

    text->current_pos = linedataptr->startpos + text->column_number;
    full_width = extext_get_line_width (text, linedataptr, 0);
    width =
        extext_get_line_width_special (text, linedataptr, 0,
                                       text->column_number);
    if (text->draw_numbers)
        width += text->gutter_width;
    if (text->draw_numbers && text->hadj->page_size < text->gutter_width)
        text->hadj->page_size = text->gutter_width;
    val = text->hadj->value;
    if ((gfloat) width >= val + text->hadj->page_size + text->gutter_width) {
        val = (gfloat) (width - text->hadj->page_size - text->gutter_width) + 5;
        gtk_adjustment_set_value (text->hadj, val);
    } else if (!text->draw_numbers && width < val) {
        val = (gfloat) width;
        gtk_adjustment_set_value (text->hadj, val);
    } else if (text->draw_numbers && width < (val + text->gutter_width)) {
        val = (gfloat) width -= text->gutter_width;
        gtk_adjustment_set_value (text->hadj, val);
    }

    text->property_current =
        gtk_extext_property_get_at_pos (text, text->current_pos,
                                        linedataptr->property_first);
    if (prop != text->property_current)
        gtk_signal_emit_by_name (GTK_OBJECT (text), "property-mark",
                                 text->property_current);

    gtk_signal_emit_by_name (GTK_OBJECT (text), "move_to_column",
                             text->column_number);

    g_free (linedataptr);

    return text->column_number;
}

static GtkExTextLineData *
line_insert (GtkExText * text, GtkExTextLineData * linedataptr, gint count)
{
    /* always insert after linedataptr->lineptr */
    gint lindex;
    gint i;

    Lines *cur;
    Lines *newc;
    Lines *next;

    g_return_val_if_fail (linedataptr != NULL, NULL);
    g_return_val_if_fail (count > 0, linedataptr);

    lindex = linedataptr->line_number;
    next = linedataptr->lineptr->next;
    cur = linedataptr->lineptr;
    for (i = 0; i < count; i++) {
        newc = g_malloc0 (sizeof (Lines));
        if (!text->line_start)  /* no lines at all */
            text->line_start = newc;

        newc->prev = cur;
        if (newc->prev)
            newc->prev->next = newc;

        cur = newc;

        gtk_signal_emit (GTK_OBJECT (text), extext_signals[LINE_INSERT],
                         lindex + i + 1);
    }

    cur->next = next;
    if (next)
        next->prev = cur;

    text->line_count += count;

    if (!next)
        text->line_end = cur;

    // recompute the width of the line number gutter
    if (text->draw_numbers)
        gtk_extext_set_draw_numbers (text, TRUE);
    return linedataptr;
}

void
line_set_len (GtkExText * text, GtkExTextLineData * lptr, gint len)
{
    gint oldlen = LINE_DATA_LENGTH (lptr);

    lptr->endpos += len - oldlen;
    lptr->lineptr->length = len;

    if (lptr->line_number < text->scroll_line_start->line_number) {
        text->scroll_line_start->startpos += len - oldlen;
        text->scroll_line_start->endpos += len - oldlen;
    }
    if (lptr->line_number == text->scroll_line_start->line_number)
        text->scroll_line_start->endpos += len - oldlen;
}

static GtkExTextLineData *
line_remove (GtkExText * text, GtkExTextLineData * cur)
{
    gint lindex;
    GtkExTextLineData *linedataptr;
    Lines *remove;

    g_return_val_if_fail (GTK_EXTEXT (text), cur);
    g_return_val_if_fail (cur != NULL, NULL);

    remove = cur->lineptr;
    linedataptr = cur;
    lindex = cur->line_number;
    if (cur->lineptr == text->line_start) {
        g_warning
            ("[line_remove] BUG!!!! tried to Remove first line this is impossible\n");
        return cur;
    }

    if (cur->lineptr == text->line_end)
        text->line_end = text->line_end->prev;

    gtk_signal_emit (GTK_OBJECT (text), extext_signals[LINE_REMOVE], lindex);

    /* update linedataptr so it points to previous line */

    lindex--;
    linedataptr = gtk_extext_get_line_data (text, lindex, linedataptr);

    if (remove->prev)
        remove->prev->next = remove->next;

    if (remove->next)
        remove->next->prev = remove->prev;

    g_free (remove);

    text->line_count--;

    /* if we removed the first visible line whe need to update */
    /* scroll_line_start so it points to prevline */
    if (remove == text->scroll_line_start->lineptr) {
        g_free (text->scroll_line_start);
        text->scroll_line_start = linedataptr;
        /* and yes create a new linedata struct to pass to the user */
        /* else user freeing the text->scroll_line_start struct */
        /* and it will segfault :-) */
        linedataptr =
            gtk_extext_get_line_data (text,
                                      text->scroll_line_start->line_number,
                                      text->scroll_line_start);
    }

    /* we return previous line */
    return linedataptr;
}

GtkExTextLineData *
line_get_by_char_pos (GtkExText * text, gint textoffset,
                      GtkExTextLineData * linedataptr)
{
    gint lindex;
    gint val;

    g_return_val_if_fail (textoffset >= 0, NULL);
    if (textoffset >= text->length)
        return gtk_extext_get_line_data (text, text->line_count, linedataptr);
    if (!textoffset)
        return gtk_extext_get_line_data (text, 0, linedataptr);

    if (!linedataptr) {
        linedataptr =
            gtk_extext_get_line_data (text,
                                      text->scroll_line_start->line_number,
                                      text->scroll_line_start);
    }
    lindex = text->scroll_line_start->line_number;

    /* check if text offset is in current line */
    val = is_value_ok (textoffset, linedataptr->startpos, linedataptr->endpos);
    if (!val)
        return gtk_extext_get_line_data (text, lindex, linedataptr);

    if (val > 0) {
        while (TRUE) {
            linedataptr =
                gtk_extext_get_line_data (text, ++lindex, linedataptr);
            if (!is_value_ok
                (textoffset, linedataptr->startpos, linedataptr->endpos))
                return linedataptr;
        };
    }

    while (lindex >= 0) {
        linedataptr = gtk_extext_get_line_data (text, --lindex, linedataptr);
        if (!is_value_ok
            (textoffset, linedataptr->startpos, linedataptr->endpos))
            return linedataptr;
    };

    g_warning ("[line_get_by_char pos(%d)] failed????????\n", textoffset);

    return gtk_extext_get_line_data (text, 0, NULL);
}

GtkExTextLineData *
line_set_by_ptr (GtkExText * text, GtkExTextLineData * linedataptr,
                 gboolean forward)
{
    gint oldline;

    if (!linedataptr)
        return NULL;

    oldline = text->line_number;
    text->line_ptr = linedataptr->lineptr;
    text->line_number = linedataptr->line_number;
    if (oldline != text->line_number)
        gtk_signal_emit_by_name (GTK_OBJECT (text), "move_to_row",
                                 text->line_number);
    return linedataptr;
}

Lines *
line_set (GtkExText * text, gint pos)
{
    GtkExTextLineData *linedataptr;

    linedataptr = gtk_extext_get_line_data (text, pos, text->scroll_line_start);
    line_set_by_ptr (text, linedataptr, FALSE);
    g_free (linedataptr);
    return text->line_ptr;
}

/*****************************************************************************/
/*                           StyleCache declarations                             */
/*****************************************************************************/

/* this is called after realize to make sure all styles is updated */
/* if user has inserted styles with data wish was not initiated  */

void
style_init_each (gpointer key, GtkExTextStyle * style, GtkExText * text)
{
    gint width;
    GtkExTextStyle *def;

    def = gtk_extext_style_get (text, "Default");
    if (!style->font) {
        style->font = def->font;
        gdk_string_extents (style->font,
                            " `~!@#$%^&*()-_=+\\|[]{};:\"\'<,>.?/1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                            &style->lbearing,
                            &style->rbearing,
                            &width, &style->ascent, &style->descent);
    } else {
        gdk_string_extents (style->font,
                            " `~!@#$%^&*()-_=+\\|[]{};:\"\'<,>.?/1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                            &style->lbearing,
                            &style->rbearing,
                            &width, &style->ascent, &style->descent);
    }
    /* check if color initiated? */

    if (!style->bg_color.pixel)
        style->bg_color = def->bg_color;

    if (!style->fg_color.pixel)
        style->fg_color = def->fg_color;
}

/* this is called after a new style has been inserted/removed to check if font already exist */
/* if exist ref->exist=TRUE. If not exist the gdk_font_[ref/unref] will be called */
/* by the main foreach loop */

void
style_font_ref_each (gpointer key, GtkExTextStyle * style, FontRef * ref)
{
    if (style && style->font == ref->font)
        ref->exist = TRUE;
}

void
style_destroy_each (gpointer key, gpointer freeme, gpointer data)
{
    gtk_extext_style_remove_real (GTK_EXTEXT (data), (gchar *) key);
}

void
propertys_destroy (GtkExText * text)
{
    GtkExTextProperty *next, *cur;

    g_hash_table_foreach (text->hash_styles, (GHFunc) style_destroy_each, text);
    g_hash_table_destroy (text->hash_styles);

    cur = text->property_start;
    while (cur) {
        next = cur->next;

        gtk_signal_emit (GTK_OBJECT (text),
                         extext_signals[PROPERTY_DESTROY], cur);

        g_free (cur);
        cur = next;
    };
    text->property_start = text->property_end = NULL;
}

GtkExTextStyle *
gtk_extext_style_insert (GtkExText * text, gchar * key, GdkFont * font,
                         GdkColor * fg, GdkColor * bg, guint16 flags)
{
    FontRef *fontref = NULL;
    GtkExTextStyle *style, *def;
    gint width;

    def = gtk_extext_style_get (text, "Default");
    style = gtk_extext_style_get (text, key);
    if (!style) {
        fontref = g_malloc0 (sizeof (FontRef));
        fontref->exist = FALSE;
        fontref->font = font;
        style = g_malloc0 (sizeof (GtkExTextStyle));
        strncpy (style->key, key, 32);
        g_hash_table_foreach (text->hash_styles, (GHFunc) style_font_ref_each,
                              fontref);
        if (!fontref->exist && font)
            gdk_font_ref (font);
        g_free (fontref);
        g_hash_table_insert (text->hash_styles, (gpointer *) style->key, style);
    }

    style->flags = 0x0000;
    if (bg)
        style->flags = GTK_EXTEXT_STYLE_BG;
    style->flags |= flags;

    if (def) {
        style->font = font ? font : def->font;
        style->bg_color = bg ? *bg : def->bg_color;
        style->fg_color = fg ? *fg : def->fg_color;

        gdk_color_alloc (gdk_colormap_get_system (), &style->bg_color);
        gdk_color_alloc (gdk_colormap_get_system (), &style->fg_color);
    } else {
        style->font = font ? font : text->font;
        if (bg) {
            style->bg_color = *bg;
            gdk_color_alloc (gdk_colormap_get_system (), &style->bg_color);
        }
        if (fg) {
            style->fg_color = *fg;
            gdk_color_alloc (gdk_colormap_get_system (), &style->fg_color);
        }
    }

    if (style->font) {
        gdk_string_extents (style->font,
                            " `~!@#$%^&*()-_=+\\|[]{};:\"\'<,>.?/1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                            &style->lbearing,
                            &style->rbearing,
                            &width, &style->ascent, &style->descent);
    }
    return style;
}

void
gtk_extext_style_remove (GtkExText * text, gchar * key)
{
    if (!strcasecmp (key, "Default")) {
        g_warning
            ("you cannot remove default/selected/Prelight style\nuse gtk_extext_style_insert to change the values\n");
        return;
    }
    gtk_extext_style_remove_real (text, key);
    g_hash_table_remove (text->hash_styles, key);
}

void
gtk_extext_style_remove_real (GtkExText * text, gchar * key)
{
    FontRef *fontref = NULL;
    GtkExTextStyle *style = NULL;

    style = gtk_extext_style_get (text, key);
    g_hash_table_insert (text->hash_styles, (gpointer *) key, NULL);

    fontref = g_malloc0 (sizeof (FontRef));
    fontref->font = style->font;
    fontref->exist = FALSE;
    g_free (style);

    g_hash_table_foreach (text->hash_styles, (GHFunc) style_font_ref_each,
                          fontref);
    if (!fontref->exist && fontref->font)   /* no style with removed font */
        gdk_font_unref (fontref->font); /* so we unref it */

    g_free (fontref);
}

GtkExTextStyle *
gtk_extext_style_get (GtkExText * text, gchar * key)
{
    GtkExTextStyle *style;

    style = (gpointer) g_hash_table_lookup (text->hash_styles, key);
    return style;
}

/* we dont use  g_list because we need direct acces to ->next */
GtkExTextProperty *
property_remove_linked_list (GtkExText * text, GtkExTextProperty * cur)
{
    GtkExTextProperty *next;

    if (!cur)
        return NULL;
    text->property_count--;
    if (!cur->prev && !cur->next) {
        text->property_start = NULL;
        text->property_end = NULL;
        text->property_current = NULL;
        text->scroll_line_start->property_first = NULL;
        return NULL;
    }

    next = cur->next;
    if (!next) {                /* LAST property */
        text->property_end = cur->prev;
        text->property_end->next = NULL;
    } else {                   /* somewhere in list */

        if (cur->prev)
            cur->prev->next = next;

        next->prev = cur->prev;
    }

    if (!text->property_end || !text->property_end->prev)
        text->property_start = text->property_end;

    if (text->property_current == cur)
        text->property_current = NULL;

    if (text->property_start == cur)
        text->property_start = next;

    if (cur == text->scroll_line_start->property_first) {
        text->scroll_line_start->property_first = cur->prev;
    }
    return next;
}

void
property_insert_linked_list (GtkExText * text, GtkExTextProperty * cur,
                             GtkExTextProperty * next)
{
    if (!cur)
        return;
    text->property_count++;
    cur->prev = NULL;
    cur->next = NULL;
    /* INSERT BEFORE */
    if (next) {
        cur->prev = next->prev;
        next->prev = cur;
        cur->next = next;
        if (cur->prev)
            cur->prev->next = cur;
    }

    if (!cur->next) {           /* there is no after cur property_end */
        if (text->property_end)
            text->property_end->next = cur;

        cur->prev = text->property_end;
        text->property_end = cur;
    }

    if (!cur->prev)             /* cur is the first in list */
        text->property_start = cur;
}

GtkExTextProperty *
gtk_extext_property_remove_all (GtkExText * text, gint startpos, gint endpos,
                                GtkExTextProperty * startprop)
{
    gint i;
    GtkExTextProperty *next;
    GtkExTextProperty *_this;

    _this = NULL;

    next = startprop ? startprop : text->property_start;

    i = startpos;
    do {
        _this = gtk_extext_property_get_at_pos (text, i, next);
        if (_this) {
            i = _this->endpos;
            next = property_remove_linked_list (text, _this);
            gtk_signal_emit (GTK_OBJECT (text),
                             extext_signals[PROPERTY_DESTROY], _this);
            if (_this == startprop)
                startprop = _this->next;
            g_free (_this);
        } else
            i++;
    }
    while (i < endpos);

//      next = gtk_extext_property_move_all(text,endpos,0,startprop);
    next =
        endpos < text->length ? gtk_extext_property_nearest_forward (text,
                                                                     endpos - 1,
                                                                     startprop)
        : NULL;
    return next;
}

GtkExTextProperty *
gtk_extext_property_move_all (GtkExText * text, gint pos, gint diff,
                              GtkExTextProperty * prop)
{
    GtkExTextProperty *next;
    gboolean oldread;

    oldread = text->editable;
    next = NULL;
    if (!prop)
        prop = text->property_start;

    text->editable = TRUE;
    while (prop) {
        if (prop->startpos >= pos) {
            if (!next) {
                next = prop;
                if (!diff)
                    goto end;
            }
            prop->startpos += diff;
            prop->endpos += diff;
        }
        prop = prop->next;
    }

  end:
    text->editable = oldread;
    return next;
}

GtkExTextProperty *
gtk_extext_property_get_current (GtkExText * text)
{
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);
    return text->property_current;
}

GtkExTextProperty *
gtk_extext_property_insert (GtkExText * text,
                            gchar * key,
                            gint startpos,
                            gint endpos,
                            gpointer data, gint type, GtkExTextProperty * prev)
{
    gint diff;
    GtkExTextProperty *prop, *next, *extra;
    GtkExTextProperty *propstart, *propend;

    propend = NULL;
    propstart = NULL;
    extra = NULL;
    next = NULL;

    if (!prev)
        prev = gtk_extext_property_nearest_backward (text, startpos, NULL);

    diff = endpos - startpos;

    prop = g_malloc (sizeof (GtkExTextProperty));
    prop->startpos = 0;
    prop->endpos = 0;
    prop->style = NULL;
    prop->user_data = data;
    prop->next = NULL;
    prop->prev = NULL;

    if (key && *key) {
        prop->style = gtk_extext_style_get (text, key);
    }                           /* if keystyle not found or no key */
    if (!prop->style) {
        prop->style = gtk_extext_style_get (text, "Default");
    }

    if (type == PROPERTY_MERGE) {
        propstart = gtk_extext_property_get_at_pos (text, startpos, prev);
        propend = gtk_extext_property_get_at_pos (text, endpos - 1, prev);
        if (propend && propstart != propend && propend->endpos >= endpos) {
            propend->startpos = endpos;
        } else if (propend && propstart == propend && propend->endpos >= endpos) {
            extra = g_malloc (sizeof (GtkExTextProperty));
            extra->startpos = endpos;
            extra->endpos = propend->endpos;
            extra->style = propend->style;
            extra->user_data = propend->user_data;
            extra->next = NULL;
            extra->prev = NULL;
            /*text->property_count++; */
            property_insert_linked_list (text, extra, propend->next);
        }
        if (propstart) {
            propstart->endpos = startpos - 1;
        }
        next =
            gtk_extext_property_move_all (text, extra ? extra->endpos : endpos,
                                          0, prev);
        gtk_extext_property_remove_all (text, startpos, endpos, prev);
        if (extra)
            next = extra;
    } else if (type == PROPERTY_INSERT) /* NO we dont update em. We only get the next prop to pass to linked_list */
        next = gtk_extext_property_move_all (text, startpos, 0, prev);
    else
        next = gtk_extext_property_remove_all (text, startpos, endpos, prev);

    property_insert_linked_list (text, prop, next);

    prop->startpos = startpos;
    prop->endpos = endpos;
    if (!text->text_insert_delete_flag)
        recompute_text_segment (text, startpos, endpos);
    return prop;
}

GtkExTextProperty *
gtk_extext_property_remove (GtkExText * text, GtkExTextProperty * prop)
{
    gint start, end;
    GtkExTextProperty *next;

    if (!prop)
        return text->property_end;

    next = property_remove_linked_list (text, prop);

    start = prop->startpos;
    end = prop->endpos;
    g_free (prop);

    if (!text->text_insert_delete_flag)
        recompute_text_segment (text, start, end);

    return next;                /* we always return next property */
}

/* ALL propertys should be in sorted order */
/*****************************************************/

GtkExTextProperty *
gtk_extext_property_get_at_pos (GtkExText * text, gint pos,
                                GtkExTextProperty * oldprop)
{
    GtkExTextProperty *cur, *curstart;

    if (!text->property_start)
        return NULL;

    curstart = cur = oldprop ? oldprop : text->property_start;
    while (cur) {
        gint val;

        val = is_value_ok (pos, cur->startpos, cur->endpos);
        /* if return 0, pos is in property interval :-) */
        if (!val)
            return cur;

        /* if value returns more it probadly because property -> startpos */
        /*  is after pos */
        if (val < 0)
            return NULL;
        cur = cur->next;
    }

    /* we started from curstart so we should start before curstart */
    cur = curstart->prev;

    /*    search backward if not found forward */
    /* until val is less than cur->endpos */
    while (cur) {
        gint val;

        val = is_value_ok (pos, cur->startpos, cur->endpos);
        /* if val return 0 it is found */
        if (!val)
            return cur;
        if (val > 0)
            return NULL;
        cur = cur->prev;
    }
    return NULL;
}

/* call property_nearest_forward to return property after current pos  */

GtkExTextProperty *
gtk_extext_property_nearest_forward (GtkExText * text,
                                     gint pos, GtkExTextProperty * cur)
{
    if (!cur)
        cur = text->property_start;

    if (!cur)
        return NULL;

    while (cur) {
        if (cur->startpos > pos)
            return cur;
        cur = cur->next;
    }
    return cur;
}

/* call property_nearest_forward to return property after the pos  */

GtkExTextProperty *
gtk_extext_property_nearest_backward (GtkExText * text, gint pos,
                                      GtkExTextProperty * prop)
{
    GtkExTextProperty *new_prop;
    gint val = 0;

    if (!prop)
        prop = text->property_start;
    new_prop = prop;
    if (prop) {
        val = is_value_ok (pos, prop->startpos, prop->endpos);
        if (val == 0)
            return prop->prev;
        else if (val < 0) {
            new_prop = text->property_start;    /* if something goes wrong */
            while (prop) {
                if (is_value_ok (pos, prop->startpos, prop->endpos) >= 0)
                    return prop->prev;
                prop = prop->prev;
            }
            return NULL;
        } else {
            new_prop = text->property_end;
            while (prop) {
                if (is_value_ok (pos, prop->startpos, prop->endpos) <= 0)
                    return prop->prev;
                prop = prop->next;
            }
            return text->property_end;
        }
    }
    return NULL;
}

/*****************************************************************************/
/*                                 widget api                                   */
/*****************************************************************************/
static void
gtk_extext_class_init (GtkExTextClass * _class)
{
    GtkObjectClass *object_class;
    GtkWidgetClass *widget_class;

    object_class = (GtkObjectClass *) _class;
    widget_class = (GtkWidgetClass *) _class;
    parent_class = gtk_type_class (GTK_TYPE_WIDGET);

    widget_class->set_scroll_adjustments_signal =
        gtk_signal_new ("set_scroll_adjustments",
                        GTK_RUN_LAST,
                        object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass,
                                           set_scroll_adjustments),
                        gtk_marshal_NONE__POINTER_POINTER, GTK_TYPE_NONE, 2,
                        GTK_TYPE_ADJUSTMENT, GTK_TYPE_ADJUSTMENT);

    extext_signals[INSERT_TEXT] =
        gtk_signal_new ("insert_text", GTK_RUN_LAST, object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass, insert_text),
                        gtk_marshal_NONE__POINTER_INT_POINTER, GTK_TYPE_NONE, 3,
                        GTK_TYPE_POINTER, GTK_TYPE_INT, GTK_TYPE_POINTER);

    extext_signals[DELETE_TEXT] =
        gtk_signal_new ("delete_text", GTK_RUN_LAST, object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass, delete_text),
                        gtk_marshal_NONE__INT_INT, GTK_TYPE_NONE, 2,
                        GTK_TYPE_INT, GTK_TYPE_INT);

    extext_signals[CHANGED] =
        gtk_signal_new ("changed", GTK_RUN_LAST, object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass, changed),
                        gtk_marshal_NONE__NONE, GTK_TYPE_NONE, 0);

    extext_signals[MOVE_TO_ROW] =
        gtk_signal_new ("move_to_row", GTK_RUN_LAST, object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass, move_to_row),
                        gtk_marshal_NONE__INT, GTK_TYPE_NONE, 1, GTK_TYPE_INT);

    extext_signals[MOVE_TO_COLUMN] =
        gtk_signal_new ("move_to_column", GTK_RUN_LAST, object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass, move_to_column),
                        gtk_marshal_NONE__INT, GTK_TYPE_NONE, 1, GTK_TYPE_INT);

    extext_signals[CUT_CLIPBOARD] =
        gtk_signal_new ("cut_clipboard", GTK_RUN_LAST, object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass, cut_clipboard),
                        gtk_marshal_NONE__NONE, GTK_TYPE_NONE, 0);

    extext_signals[COPY_CLIPBOARD] =
        gtk_signal_new ("copy_clipboard", GTK_RUN_LAST, object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass, copy_clipboard),
                        gtk_marshal_NONE__NONE, GTK_TYPE_NONE, 0);

    extext_signals[PASTE_CLIPBOARD] =
        gtk_signal_new ("paste_clipboard", GTK_RUN_LAST, object_class->type,
                        GTK_SIGNAL_OFFSET (GtkExTextClass, paste_clipboard),
                        gtk_marshal_NONE__NONE, GTK_TYPE_NONE, 0);

    extext_signals[PROPERTY_TEXT_INSERT] =
        gtk_signal_new ("property_text_insert", GTK_RUN_LAST,
                        object_class->type, GTK_SIGNAL_OFFSET (GtkExTextClass,
                                                               property_text_insert),
                        gtk_marshal_BOOL__POINTER_INT_INT, GTK_TYPE_BOOL, 3,
                        GTK_TYPE_POINTER, GTK_TYPE_INT, GTK_TYPE_INT);

    extext_signals[PROPERTY_TEXT_REMOVE] =
        gtk_signal_new ("property_text_remove", GTK_RUN_LAST,
                        object_class->type, GTK_SIGNAL_OFFSET (GtkExTextClass,
                                                               property_text_remove),
                        gtk_marshal_BOOL__POINTER_INT_INT, GTK_TYPE_BOOL, 3,
                        GTK_TYPE_POINTER, GTK_TYPE_INT, GTK_TYPE_INT);

    extext_signals[PROPERTY_DESTROY] = gtk_signal_new ("property_destroy",
                                                       GTK_RUN_LAST,
                                                       object_class->type,
                                                       GTK_SIGNAL_OFFSET
                                                       (GtkExTextClass,
                                                        property_destroy),
                                                       gtk_marshal_NONE__POINTER,
                                                       GTK_TYPE_NONE, 1,
                                                       GTK_TYPE_POINTER);

    extext_signals[UNDO_CHANGED] = gtk_signal_new ("undo_changed",
                                                   GTK_RUN_LAST,
                                                   object_class->type,
                                                   GTK_SIGNAL_OFFSET
                                                   (GtkExTextClass,
                                                    undo_changed),
                                                   gtk_marshal_NONE__NONE,
                                                   GTK_TYPE_NONE, 0);

    /* called if cursor has moved to a new property */
    extext_signals[PROPERTY_MARK] = gtk_signal_new ("property_mark",
                                                    GTK_RUN_LAST,
                                                    object_class->type,
                                                    GTK_SIGNAL_OFFSET
                                                    (GtkExTextClass,
                                                     property_mark),
                                                    gtk_marshal_NONE__POINTER,
                                                    GTK_TYPE_NONE, 1,
                                                    GTK_TYPE_POINTER);

    extext_signals[LINE_INSERT] = gtk_signal_new ("line_insert",
                                                  GTK_RUN_LAST,
                                                  object_class->type,
                                                  GTK_SIGNAL_OFFSET
                                                  (GtkExTextClass, line_insert),
                                                  gtk_marshal_NONE__INT,
                                                  GTK_TYPE_NONE, 1,
                                                  GTK_TYPE_INT);

    extext_signals[LINE_REMOVE] = gtk_signal_new ("line_remove",
                                                  GTK_RUN_LAST,
                                                  object_class->type,
                                                  GTK_SIGNAL_OFFSET
                                                  (GtkExTextClass, line_remove),
                                                  gtk_marshal_NONE__INT,
                                                  GTK_TYPE_NONE, 1,
                                                  GTK_TYPE_INT);

    extext_signals[MARGIN_CLICKED] = gtk_signal_new ("margin_enter",
                                                     GTK_RUN_LAST,
                                                     object_class->type,
                                                     GTK_SIGNAL_OFFSET
                                                     (GtkExTextClass,
                                                      margin_enter),
                                                     gtk_marshal_NONE__INT,
                                                     GTK_TYPE_NONE, 1,
                                                     GTK_TYPE_INT);

    extext_signals[MARGIN_CLICKED] = gtk_signal_new ("margin_exit",
                                                     GTK_RUN_LAST,
                                                     object_class->type,
                                                     GTK_SIGNAL_OFFSET
                                                     (GtkExTextClass,
                                                      margin_exit),
                                                     gtk_marshal_NONE__INT,
                                                     GTK_TYPE_NONE, 1,
                                                     GTK_TYPE_INT);

    extext_signals[MARGIN_CLICKED] = gtk_signal_new ("margin_clicked",
                                                     GTK_RUN_LAST,
                                                     object_class->type,
                                                     GTK_SIGNAL_OFFSET
                                                     (GtkExTextClass,
                                                      margin_clicked),
                                                     gtk_marshal_NONE__POINTER_INT,
                                                     GTK_TYPE_NONE, 2,
                                                     GTK_TYPE_POINTER,
                                                     GTK_TYPE_INT);

    gtk_object_class_add_signals (object_class, extext_signals, LAST_SIGNAL);

    object_class->destroy = gtk_extext_destroy;
    object_class->finalize = gtk_extext_finalize;

    widget_class->style_set = gtk_extext_style_set;
    widget_class->size_request = gtk_extext_size_request;
    widget_class->size_allocate = gtk_extext_size_allocate;
    widget_class->realize = gtk_extext_realize;
    widget_class->unrealize = gtk_extext_unrealize;
    widget_class->button_press_event = gtk_extext_button_press;
    widget_class->button_release_event = gtk_extext_button_release;
    widget_class->motion_notify_event = gtk_extext_motion_notify;
    widget_class->draw = gtk_extext_draw;
    widget_class->draw_focus = gtk_extext_draw_focus;
    widget_class->expose_event = gtk_extext_expose;
    widget_class->key_press_event = gtk_extext_key_press;
    widget_class->focus_in_event = gtk_extext_focus_in;
    widget_class->focus_out_event = gtk_extext_focus_out;

    /* Handle selection bull */
    widget_class->selection_clear_event = gtk_extext_selection_clear;
    widget_class->selection_received = gtk_extext_selection_received;
    widget_class->selection_get = gtk_extext_selection_get;

    _class->property_destroy = NULL;
    _class->set_scroll_adjustments = gtk_extext_set_adjustments;
    _class->line_by_offset = line_get_by_offset;
    _class->column_by_offset = column_get_by_offset;
    _class->property_text_insert = property_text_insert;
    _class->property_text_remove = property_text_remove;
    _class->undo_changed = NULL;
    _class->property_mark = NULL;
    _class->line_insert = NULL;
    _class->line_remove = NULL;
    _class->margin_clicked = NULL;

}

void
gtk_extext_draw_focus (GtkWidget * widget)
{
    GtkExText *text;
    gint width, height;

    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));

    text = GTK_EXTEXT (widget);

    if (GTK_WIDGET_DRAWABLE (widget)) {
        width = widget->allocation.width;
        height = widget->allocation.height;
        width -= 2;
        height -= 2;
        gtk_paint_shadow (widget->style, widget->window,
                          GTK_STATE_NORMAL, GTK_SHADOW_IN,
                          NULL, widget, "text", 1, 1, width, height);
    }
}

static void
gtk_extext_size_request (GtkWidget * widget, GtkRequisition * requisition)
{
    GtkExText *text;
    gint xthickness;
    gint ythickness;
    gint char_height;
    gint char_width;

    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));
    g_return_if_fail (requisition != NULL);

    text = GTK_EXTEXT (widget);

    gtk_extext_set_draw_numbers (text, text->draw_numbers);
    text->gutter_width = text->number_width + text->pixmap_max_width;

    xthickness = TEXT_BORDER_ROOM;
    ythickness = TEXT_BORDER_ROOM;

    char_height = MIN_TEXT_HEIGHT_LINES * (widget->style->font->ascent +
                                           widget->style->font->descent);

    char_width =
        MIN_TEXT_WIDTH_LINES *
        gdk_text_width (widget->style->font, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26);

    requisition->width =
        char_width + text->gutter_width ? text->gutter_width : xthickness * 2;
    requisition->height = char_height + ythickness * 2;

    if (GTK_EXTEXT (widget)->text_area == widget->window
        && GTK_EXTEXT (widget)->hadj)
        GTK_EXTEXT (widget)->hadj->page_increment = (gfloat) requisition->width;
}

static void
gtk_extext_size_allocate (GtkWidget * widget, GtkAllocation * allocation)
{
    GtkExText *text;

    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));
    g_return_if_fail (allocation != NULL);

    text = GTK_EXTEXT (widget);

    gtk_extext_set_draw_numbers (text, text->draw_numbers);
    text->gutter_width = text->number_width + text->pixmap_max_width;

    widget->allocation = *allocation;
    if (GTK_WIDGET_REALIZED (widget)) {
        gdk_window_move_resize (widget->window,
                                allocation->x, allocation->y,
                                allocation->width, allocation->height);

        gdk_window_move_resize (text->text_area,
                                TEXT_BORDER_ROOM,
                                TEXT_BORDER_ROOM,
                                MAX (1,
                                     (gint) allocation->width -
                                     (TEXT_BORDER_ROOM * 2)), MAX (1, (gint)
                                                                   allocation->
                                                                   height -
                                                                   (TEXT_BORDER_ROOM
                                                                    * 2)));

#ifdef USE_XIM
        if (text->ic && (gdk_ic_get_style (text->ic) & GDK_IM_PREEDIT_POSITION)) {
            gint width, height;

            gdk_window_get_size (text->text_area, &width, &height);
            text->ic_attr->preedit_area.width = width;
            text->ic_attr->preedit_area.height = height;
            gdk_ic_set_attr (text->ic, text->ic_attr, GDK_IC_PREEDIT_AREA);
        }
#endif
        recompute_geometry (text);
    }
}

static void
recompute_scroll_line_width (GtkExText * text, GtkExTextLineData * lp,
                             gint count)
{
    gint i;
    gint firstline;
    gboolean haschanged;
    GtkExTextLineData linedata;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (!text->hadj)
        return;

    firstline = lp->line_number;
    linedata = *lp;
    haschanged = FALSE;
    for (i = 0; i < count; i++) {
        gint w;

        gtk_extext_get_line_data_next (text, &linedata);
        w = extext_get_line_width (text, &linedata, 0);
        if ((gfloat) w > text->hadj->upper) {
            text->hadj->upper = (gfloat) w;
            haschanged = TRUE;
        }
    }
    if (haschanged)
        gtk_adjustment_changed (text->hadj);
}

static void
recompute_scroll_line_height (GtkExText * text)
{
    gint height, width, count, h, startpos;
    GtkExTextStyle *style;
    GtkExTextLineData *linedataptr;

    if (!text->vadj)
        return;

    gdk_window_get_size (text->text_area, &width, &height);

    count = 0;
    h = 0;

    style = gtk_extext_style_get (text, "Default");
    linedataptr = text->scroll_line_start;
    while (TRUE) {
        if (text->scroll_line_start->line_number + count <= text->line_count) {
            linedataptr =
                gtk_extext_get_line_data (text,
                                          text->scroll_line_start->line_number +
                                          count, linedataptr);
            startpos = linedataptr->startpos;
            h += extext_get_line_height (text, linedataptr);
        } else
            h += TEXT_STYLE_HEIGHT (style);

        if (h > height)
            break;
        count++;
    }
    g_free (linedataptr);
    text->scroll_line_count = count;
    text->vadj->page_increment = (gfloat) text->scroll_line_count;
    text->vadj->page_size = (gfloat) text->scroll_line_count;
    if (text->vadj->upper < text->vadj->page_size)
        text->vadj->upper = (gfloat) text->scroll_line_count;
}

static void
recompute_geometry (GtkExText * text)
{
    gint height, width;

    gdk_window_get_size (text->text_area, &width, &height);
    if (text->draw_area)
        gdk_pixmap_unref (text->draw_area);
    text->draw_area = gdk_pixmap_new (text->text_area, width, height, -1);

    if (!text->hadj)
        return;

    recompute_scroll_line_height (text);
    text->hadj->page_size = width - text->gutter_width;
    if (text->hadj && text->hadj->upper < (gfloat) width)
        text->hadj->upper = width;

    gtk_adjustment_changed (text->hadj);
    text->vadj->step_increment = 1.0;
    text->vadj->page_size = (gfloat) text->scroll_line_count;
    text->vadj->upper = (gfloat) text->line_count;
}

void
recompute_scroll_line_data (GtkExText * text, gint pos, gboolean clearprop)
{
    GtkExTextLineData *lp;

    if (clearprop) {
        text->scroll_line_start->property_first = NULL;
    }
    lp = gtk_extext_get_line_data (text, pos, text->scroll_line_start);
    g_free (text->scroll_line_start);
    text->scroll_line_start = lp;
}

void
gtk_extext_set_adjustments (GtkExText * text,
                            GtkAdjustment * hadj, GtkAdjustment * vadj)
{

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (hadj)
        g_return_if_fail (GTK_IS_ADJUSTMENT (hadj));
    else
        hadj =
            GTK_ADJUSTMENT (gtk_adjustment_new (0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
    if (vadj)
        g_return_if_fail (GTK_IS_ADJUSTMENT (vadj));
    else
        vadj =
            GTK_ADJUSTMENT (gtk_adjustment_new (0.0, 0.0, 0.0, 0.0, 0.0, 0.0));

    if (text->hadj && (text->hadj != hadj)) {
        gtk_signal_disconnect_by_data (GTK_OBJECT (text->hadj), text);
        g_object_unref (GTK_OBJECT (text->hadj));
    }

    if (text->vadj && (text->vadj != vadj)) {
        gtk_signal_disconnect_by_data (GTK_OBJECT (text->vadj), text);
        g_object_unref (GTK_OBJECT (text->vadj));
    }

    if (text->hadj != hadj) {
        text->hadj = hadj;
        g_object_ref (GTK_OBJECT (text->hadj));
        gtk_object_sink (GTK_OBJECT (text->hadj));

        gtk_signal_connect (GTK_OBJECT (text->hadj), "changed",
                            (GtkSignalFunc) gtk_extext_adjustment_changed,
                            text);
        gtk_signal_connect (GTK_OBJECT (text->hadj), "value_changed",
                            (GtkSignalFunc) gtk_extext_adjustment_value_changed,
                            text);
        gtk_signal_connect (GTK_OBJECT (text->hadj), "disconnect",
                            (GtkSignalFunc) gtk_extext_disconnect, text);
        gtk_extext_adjustment_changed (hadj, text);
    }

    if (text->vadj != vadj) {
        text->vadj = vadj;
        g_object_ref (GTK_OBJECT (text->vadj));
        gtk_object_sink (GTK_OBJECT (text->vadj));

        gtk_signal_connect (GTK_OBJECT (text->vadj), "changed",
                            (GtkSignalFunc) gtk_extext_adjustment_changed,
                            text);
        gtk_signal_connect (GTK_OBJECT (text->vadj), "value_changed",
                            (GtkSignalFunc) gtk_extext_adjustment_value_changed,
                            text);
        gtk_signal_connect (GTK_OBJECT (text->vadj), "disconnect",
                            (GtkSignalFunc) gtk_extext_disconnect, text);
        gtk_extext_adjustment_changed (vadj, text);
    }

    text->hadj->step_increment = 0;
    text->hadj->page_increment = 0;
    text->hadj->page_size = 0;
    text->hadj->upper = 0;
    text->hadj->value = 0;


    text->vadj->step_increment = 1.0;
    text->vadj->page_increment = text->scroll_line_count;
    text->vadj->page_size = text->scroll_line_count;
    text->vadj->upper = text->line_count;
}

static void
gtk_extext_init (GtkExText * text)
{
    static const GtkTargetEntry targets[] = {
        {"STRING", 0, TARGET_STRING},
        {"TEXT", 0, TARGET_TEXT},
        {"COMPOUND_TEXT", 0, TARGET_COMPOUND_TEXT}
    };
    static const gint n_targets = sizeof (targets) / sizeof (targets[0]);

    GTK_WIDGET_SET_FLAGS (text, GTK_CAN_FOCUS);
    text->draw_area = NULL;
    text->gc = NULL;
    text->bg_gc = NULL;
    text->text_area = NULL;
    text->font = NULL;
    text->ecursor = NULL;
    text->acursor = NULL;
    text->margin_popupmenu = NULL;
    text->text_popupmenu = NULL;
    text->text = g_new0 (guchar, TEXT_BUFFERT_DEFAULT_SIZE);
    text->size = TEXT_BUFFERT_DEFAULT_SIZE;
    text->gap_len = TEXT_BUFFERT_DEFAULT_SIZE;
    text->part1len = 0;
    text->part2text = text->text + text->gap_len;
    text->length = 0;
    text->editable = TRUE;
    text->hash_styles = g_hash_table_new (g_str_hash, g_str_equal);
    text->line_start = text->line_end = g_malloc0 (sizeof (Lines));
    text->line_ptr = text->line_start;
    text->line_number = 0;
    text->line_count = 0;
    text->column_number = 0;
    text->scroll_line_start = gtk_extext_get_line_data (text, 0, NULL);
    text->use_spaces = FALSE;
    text->tab_stops = TRUE;
    text->default_tab_width = DEFAULT_TAB_STOP;

    text->property_count = 0;
    text->property_start = NULL;
    text->property_end = NULL;
    text->property_current = NULL;
    text->cursor_blink = TRUE;
    text->undo_redo = NULL;
    text->undo_max = 10;
    text->undo_level = 0;
    text->text_insert_delete_flag = FALSE;
    text->undo_flag = FALSE;
    text->draw_numbers = FALSE;
    text->number_width = 0;
    text->draw_pixmaps = FALSE;
    text->pixmap_max_width = 0;
    text->gutter_width = 0;
    text->select_line = FALSE;
    text->draw_cursor = TRUE;
    text->full_selection = FALSE;
    text->show_newlines = FALSE;
    text->show_whitespace = FALSE;
    text->pseudo_select = FALSE;
    text->pseudo_start = -1;
    text->pseudo_end = -1;
    text->hadj = 0;
    text->vadj = 0;
    text->highlight = FALSE;
    text->syntax_table = NULL;
    text->pattern_table = NULL;
    text->embedded_table = NULL;

    gtk_extext_set_adjustments (text,
                                GTK_ADJUSTMENT (gtk_adjustment_new
                                                (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)),
                                GTK_ADJUSTMENT (gtk_adjustment_new
                                                (0.0, 0.0, 0.0, 0.0, 0.0,
                                                 0.0)));

    text->current_pos = 0;
    text->has_selection = 0;
    text->selection_start_pos = -1;
    text->selection_start_pos = -1;

    if (!clipboard_atom)
        clipboard_atom = gdk_atom_intern ("CLIPBOARD", FALSE);

    gtk_selection_add_targets (GTK_WIDGET (text), GDK_SELECTION_PRIMARY,
                               targets, n_targets);
    gtk_selection_add_targets (GTK_WIDGET (text), clipboard_atom,
                               targets, n_targets);
}

GtkWidget *
gtk_extext_new ()
{
    GtkWidget *text;

    text = gtk_widget_new (GTK_TYPE_EXTEXT, NULL);
    return text;
}

static void
gtk_extext_destroy (GtkObject * object)
{
    GtkExText *text;

    g_return_if_fail (object != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (object));
    text = GTK_EXTEXT (object);
    gtk_extext_undo_clear_all (text);
    propertys_destroy (text);
    gtk_signal_disconnect_by_data (GTK_OBJECT (text->hadj), text);
    gtk_signal_disconnect_by_data (GTK_OBJECT (text->vadj), text);
    if (text->timer) {
        gtk_timeout_remove (text->timer);
        text->timer = 0;
    }
    if (text->cursor_timer) {
        gtk_timeout_remove (text->cursor_timer);
        text->cursor_timer = 0;
    }
    if (text->ecursor)
        gdk_cursor_destroy (text->ecursor);
    if (text->acursor)
        gdk_cursor_destroy (text->acursor);
    GTK_OBJECT_CLASS (parent_class)->destroy (object);
}

static void
gtk_extext_finalize (GtkObject * object)
{
    GtkExText *text;
    Lines *current, *next;

    g_return_if_fail (object != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (object));

    text = GTK_EXTEXT (object);

    g_object_unref (GTK_OBJECT (text->hadj));
    g_object_unref (GTK_OBJECT (text->vadj));

    gtk_extext_undo_clear_all (GTK_EXTEXT (object));
    current = text->line_start;
    while (current) {
        next = current->next;
        g_free (current);
        current = next;
    }
    g_free (text->text);
    GTK_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gtk_extext_realize (GtkWidget * widget)
{
    GtkExText *text;
    GdkWindowAttr attributes;
    gint attributes_mask;
    GtkExTextLineData *lp;

    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));

    text = GTK_EXTEXT (widget);
    GTK_WIDGET_SET_FLAGS (text, GTK_REALIZED);

    attributes.window_type = GDK_WINDOW_CHILD;
    attributes.x = widget->allocation.x;
    attributes.y = widget->allocation.y;
    attributes.width = widget->allocation.width;
    attributes.height = widget->allocation.height;
    attributes.wclass = GDK_INPUT_OUTPUT;
    attributes.visual = gtk_widget_get_visual (widget);
    attributes.colormap = gtk_widget_get_colormap (widget);
    attributes.event_mask = gtk_widget_get_events (widget);
    attributes.event_mask |= (GDK_EXPOSURE_MASK |
                              GDK_BUTTON_PRESS_MASK |
                              GDK_BUTTON_RELEASE_MASK |
                              GDK_BUTTON_MOTION_MASK |
                              GDK_BUTTON1_MOTION_MASK |
                              GDK_BUTTON2_MOTION_MASK |
                              GDK_BUTTON3_MOTION_MASK |
                              GDK_POINTER_MOTION_MASK |
                              GDK_ENTER_NOTIFY_MASK |
                              GDK_LEAVE_NOTIFY_MASK | GDK_KEY_PRESS_MASK);
    attributes_mask = GDK_WA_X | GDK_WA_Y | GDK_WA_VISUAL | GDK_WA_COLORMAP;


    widget->window =
        gdk_window_new (gtk_widget_get_parent_window (widget), &attributes,
                        attributes_mask);
    gdk_window_set_user_data (widget->window, text);

    widget->style = gtk_style_attach (widget->style, widget->window);

    attributes.x = TEXT_BORDER_ROOM;
    attributes.y = TEXT_BORDER_ROOM;
    attributes.width = MAX (1, (gint) widget->allocation.width - attributes.x);
    attributes.height =
        MAX (1, (gint) widget->allocation.height - (attributes.y * 2));
    attributes.cursor = text->ecursor = gdk_cursor_new (GDK_XTERM);
    attributes_mask |= GDK_WA_CURSOR;
    text->text_area =
        gdk_window_new (widget->window, &attributes, attributes_mask);
    gdk_window_set_user_data (text->text_area, text);
    text->acursor = gdk_cursor_new (GDK_ARROW);

    text->gc = gdk_gc_new (text->text_area);
    gdk_gc_set_exposures (text->gc, TRUE);
    gdk_gc_set_foreground (text->gc, &widget->style->text[GTK_STATE_NORMAL]);
    gdk_gc_set_background (text->gc, &widget->style->bg[GTK_STATE_NORMAL]);

    if (GTK_WIDGET (text)->style->bg_pixmap[GTK_STATE_NORMAL]) {
        GdkGCValues values;

        values.tile = GTK_WIDGET (text)->style->bg_pixmap[GTK_STATE_NORMAL];
        values.fill = GDK_TILED;
        text->bg_gc =
            gdk_gc_new_with_values (text->text_area, &values,
                                    GDK_GC_FILL | GDK_GC_TILE);
        gdk_window_set_back_pixmap (widget->window,
                                    widget->style->bg_pixmap[GTK_STATE_NORMAL],
                                    0);
        gdk_window_set_back_pixmap (text->text_area,
                                    widget->style->bg_pixmap[GTK_STATE_NORMAL],
                                    0);
    } else {
        text->bg_gc = gdk_gc_new (text->text_area);
        gdk_window_set_background (widget->window,
                                   &widget->style->bg[GTK_STATE_NORMAL]);
        gdk_window_set_background (text->text_area,
                                   &widget->style->bg[GTK_STATE_NORMAL]);
    }

    gdk_gc_set_foreground (text->bg_gc, &widget->style->bg[GTK_STATE_NORMAL]);
    gdk_gc_set_background (text->bg_gc, &widget->style->bg[GTK_STATE_NORMAL]);

#ifdef USE_XIM
    if (gdk_im_ready () && (text->ic_attr = gdk_ic_attr_new ()) != NULL) {
        gint width, height;
        GdkColormap *colormap;
        GdkEventMask mask;
        GdkICAttr *attr = text->ic_attr;
        GdkICAttributesType attrmask = GDK_IC_ALL_REQ;
        GdkIMStyle style;
        GdkIMStyle supported_style = GDK_IM_PREEDIT_NONE |
            GDK_IM_PREEDIT_NOTHING |
            GDK_IM_PREEDIT_POSITION | GDK_IM_STATUS_NONE |
            GDK_IM_STATUS_NOTHING;

        if (widget->style && widget->style->font->type != GDK_FONT_FONTSET)
            supported_style &= ~GDK_IM_PREEDIT_POSITION;

        attr->style = style = gdk_im_decide_style (supported_style);
        attr->client_window = text->text_area;

        if ((colormap =
             gtk_widget_get_colormap (widget)) !=
            gtk_widget_get_default_colormap ()) {
            attrmask |= GDK_IC_PREEDIT_COLORMAP;
            attr->preedit_colormap = colormap;
        }
        switch (style & GDK_IM_PREEDIT_MASK) {
        case GDK_IM_PREEDIT_POSITION:
            if (widget->style && widget->style->font->type != GDK_FONT_FONTSET) {
                g_warning ("over-the-spot style requires fontset");
                break;
            }
            attrmask |= GDK_IC_PREEDIT_POSITION_REQ;
            gdk_window_get_size (text->text_area, &width, &height);
            attr->spot_location.x = 0;
            attr->spot_location.y = height;
            attr->preedit_area.x = 0;
            attr->preedit_area.y = 0;
            attr->preedit_area.width = width;
            attr->preedit_area.height = height;
            attr->preedit_fontset = widget->style->font;
            break;
        }
        text->ic = gdk_ic_new (attr, attrmask);
        if (text->ic == NULL)
            g_warning ("Can't create input context.");
        else {
            mask = gdk_window_get_events (text->text_area);
            mask |= gdk_ic_get_events (text->ic);
            gdk_window_set_events (text->text_area, mask);
            if (GTK_WIDGET_HAS_FOCUS (widget))
                gdk_im_begin (text->ic, text->text_area);
        }
    }
#endif

    text->font = widget->style->font;
    gdk_window_show (text->text_area);

    if (text->has_selection
        && text->selection_start_pos != text->selection_end_pos)
        gtk_extext_claim_selection (text, TRUE, GDK_CURRENT_TIME);

    /* ok now we need to check if user has setup any styles */
    /* unitialized Color/font values will be set to default values */

    g_hash_table_foreach (text->hash_styles, (GHFunc) style_init_each, text);
    text->scolor = GTK_WIDGET (text)->style->bg[GTK_STATE_SELECTED];
    text->pcolor = GTK_WIDGET (text)->style->bg[GTK_STATE_PRELIGHT];

    text->timer = 0;
    text->freeze_count = 0;
    if (text->hadj) {
        text->hadj->value = 0;
        text->hadj->step_increment = gdk_char_width (text->font, ' ');
        text->hadj->page_increment = gdk_char_width (text->font, ' ') * 10;
        gtk_adjustment_value_changed (text->hadj);
    }
    recompute_scroll_line_data (text, 0, TRUE);
    recompute_geometry (text);
    lp = gtk_extext_get_line_data (text, 0, NULL);
    gtk_extext_get_text_data_foreach_line (text, lp, &text_data_set_line_data,
                                           GINT_TO_POINTER (text->length));
    g_free (lp);

    gtk_signal_connect (GTK_OBJECT (text), "button_press_event",
                        GTK_SIGNAL_FUNC (ugly_popup_hack), NULL);
}

static void
gtk_extext_unrealize (GtkWidget * widget)
{
    GtkExText *text;

    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));

    text = GTK_EXTEXT (widget);

#ifdef USE_XIM
    if (text->ic) {
        gdk_ic_destroy (text->ic);
        text->ic = NULL;
    }
    if (text->ic_attr) {
        gdk_ic_attr_destroy (text->ic_attr);
        text->ic_attr = NULL;
    }
#endif

    gdk_window_set_user_data (text->text_area, NULL);
    gdk_window_destroy (text->text_area);
    text->text_area = NULL;

    gdk_gc_destroy (text->gc);
    text->gc = NULL;

    if (text->bg_gc) {
        gdk_gc_destroy (text->bg_gc);
        text->bg_gc = NULL;
    }

    if (text->draw_area) {
        gdk_pixmap_unref (text->draw_area);
        text->draw_area = NULL;
    }

    if (GTK_WIDGET_CLASS (parent_class)->unrealize)
        (*GTK_WIDGET_CLASS (parent_class)->unrealize) (widget);
}

void
gtk_extext_style_set (GtkWidget * widget, GtkStyle * old)
{
    GtkExText *text;

    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));

    text = GTK_EXTEXT (widget);
    if (GTK_WIDGET_REALIZED (widget)) {
        gdk_color_alloc (gdk_colormap_get_system (),
                         &widget->style->text[GTK_STATE_NORMAL]);
        gdk_color_alloc (gdk_colormap_get_system (),
                         &widget->style->bg[GTK_STATE_NORMAL]);
        gdk_color_alloc (gdk_colormap_get_system (),
                         &widget->style->bg[GTK_STATE_SELECTED]);
        text->scolor = widget->style->bg[GTK_STATE_SELECTED];
        gdk_color_alloc (gdk_colormap_get_system (),
                         &widget->style->bg[GTK_STATE_PRELIGHT]);
        text->pcolor = widget->style->bg[GTK_STATE_PRELIGHT];
        gdk_color_alloc (gdk_colormap_get_system (),
                         &widget->style->bg[GTK_STATE_INSENSITIVE]);
    }
    if (text->gc) {
        gdk_gc_destroy (text->gc);
        text->gc = gdk_gc_new (text->text_area);
        gdk_gc_set_exposures (text->gc, TRUE);
        gdk_gc_set_foreground (text->gc,
                               &widget->style->text[GTK_STATE_NORMAL]);
        gdk_gc_set_background (text->gc, &widget->style->bg[GTK_STATE_NORMAL]);
    }
    if (text->bg_gc) {
        gdk_gc_destroy (text->bg_gc);
        if (widget->style->bg_pixmap[GTK_STATE_NORMAL]) {
            GdkGCValues values;

            values.tile = widget->style->bg_pixmap[GTK_STATE_NORMAL];
            values.fill = GDK_TILED;
            text->bg_gc =
                gdk_gc_new_with_values (text->text_area, &values,
                                        GDK_GC_FILL | GDK_GC_TILE);
            gdk_window_set_back_pixmap (widget->window,
                                        widget->style->
                                        bg_pixmap[GTK_STATE_NORMAL], 0);
            gdk_window_set_back_pixmap (text->text_area,
                                        widget->style->
                                        bg_pixmap[GTK_STATE_NORMAL], 0);
        } else {
            text->bg_gc = gdk_gc_new (text->text_area);
            gdk_window_set_background (widget->window,
                                       &widget->style->bg[GTK_STATE_NORMAL]);
            gdk_window_set_background (text->text_area,
                                       &widget->style->bg[GTK_STATE_NORMAL]);
        }
        gdk_gc_set_foreground (text->bg_gc,
                               &widget->style->bg[GTK_STATE_NORMAL]);
        gdk_gc_set_background (text->bg_gc,
                               &widget->style->bg[GTK_STATE_NORMAL]);
    }
    if (!widget->style->font && old && old->font)
        widget->style->font = old->font;
    else if (!widget->style->font) {
        g_warning ("No default style->font set in gtkextext????");
        return;
    }
    text->font = widget->style->font;
    gtk_extext_style_insert (text, "Default", GTK_WIDGET (text)->style->font,
                             &GTK_WIDGET (text)->style->text[GTK_STATE_NORMAL],
                             NULL, 0);
    gtk_extext_set_draw_numbers (text, text->draw_numbers);
    text->gutter_width = text->number_width + text->pixmap_max_width;
}

static void
expose_text (GtkExText * text, GdkRectangle * area, gboolean hmm)
{
    gint lines = 0;
    gint endline = 0;
    gint w, h;
    gint y;
    GtkExTextLineData linedataptr;
    GdkDrawable *draw = NULL;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (text->draw_area)
        draw = text->draw_area;
    else
        draw = text->text_area;

    if (text->freeze_count) {
        if (draw != text->text_area) {
            gdk_draw_pixmap (text->text_area,
                             text->bg_gc,
                             draw, area->x, area->y, area->x, area->y,
                             area->width, area->height);
            return;
        }
    }

    if (text->cursor_timer) {
        gtk_timeout_remove (text->cursor_timer);
        text->cursor_timer = 0;
    }

    if (text->scroll_line_start->line_number + text->scroll_line_count <
        text->line_count)
        endline =
            text->scroll_line_start->line_number + text->scroll_line_count;
    else
        endline = text->line_count;

    gdk_window_get_size (text->text_area, &w, &h);

    /* initiate linedataptr by passing first visible line */
    /* Only draw text if we are exposing the whole window */
    if (area->x == 0 && area->y == 0 && area->width >= w && area->height >= h) {
        gdk_gc_set_ts_origin (text->bg_gc, 0, 0);
        gdk_draw_rectangle (draw, text->bg_gc, TRUE, 0, 0, w, h);
        if (text->gutter_width) {
            gdk_gc_set_foreground (text->gc,
                                   &GTK_WIDGET (text)->style->
                                   bg[GTK_STATE_INSENSITIVE]);
            gdk_draw_rectangle (draw, text->gc, TRUE, 0, 0,
                                text->gutter_width - TEXT_BORDER_ROOM, h);
        }
        memcpy (&linedataptr, text->scroll_line_start,
                sizeof (GtkExTextLineData));
        lines = linedataptr.line_number;
        for (y = TEXT_BORDER_ROOM; lines <= endline; lines++) {
            y = expose_line_text (text, draw, &linedataptr,
                                  text->gutter_width ? text->gutter_width +
                                  1 : TEXT_BORDER_ROOM, y);
            gtk_extext_get_line_data_next (text, &linedataptr);
        }
        if (text->gutter_width) {
            gdk_draw_line (draw, GTK_WIDGET (text)->style->black_gc,
                           text->gutter_width - TEXT_BORDER_ROOM, 0,
                           text->gutter_width - TEXT_BORDER_ROOM, h);
        }
    }
    if (text->gc && text->draw_cursor && text->cursor.x >= text->gutter_width) {
        text->cursor.hide = FALSE;
        gtk_extext_cursor_blink (text);
        gdk_draw_line (draw, text->gc, text->cursor.x, text->cursor.y,
                       text->cursor.w, text->cursor.h);
    }
    if (draw != text->text_area) {
        gdk_draw_pixmap (text->text_area,
                         text->bg_gc,
                         draw, area->x, area->y, area->x, area->y,
                         area->width, area->height);
    }
    gtk_widget_draw_focus (GTK_WIDGET (text));
    if (text->cursor_blink)
        text->cursor_timer =
            gtk_timeout_add (CURSOR_TIMEOUT, gtk_extext_cursor_blink, text);
}

void
recompute_text_segment (GtkExText * text, gint startpos, gint len)
{
    GtkExTextLineData *lp;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    return;
    /* how can we optimize this crap */
    lp = gtk_extext_get_line_by_char_pos (text, startpos, NULL);
    len += startpos - lp->startpos;
    startpos = lp->startpos;
    gtk_extext_get_text_data_foreach_line (text, lp, &text_data_set_line_data,
                                           GINT_TO_POINTER (startpos + len));
    g_free (lp);
}

/* this routine will iterate from line start at startpos up to line including startpos+length+lastline length */

void
gtk_extext_get_text_data_foreach_line (GtkExText * text,
                                       GtkExTextLineData * lp,
                                       TextDataCallback cb, gpointer userdata)
{
    gint linecount;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    g_return_if_fail (cb != NULL);

    if (!GTK_WIDGET_REALIZED (text))
        return;

    linecount = lp->line_number;
    while (linecount <= text->line_count && LINE_DATA_LENGTH (lp)) {
        gint w, h;

        lp = gtk_extext_get_line_data (text, linecount, lp);
        w = extext_get_line_width (text, lp, 0);
        h = extext_get_line_height (text, lp);
        if (!cb (text, lp, w, h, userdata))
            return;
        linecount++;
    }
}

static gint
text_data_set_line_data (GtkExText * text, GtkExTextLineData * lp, gint width,
                         gint height, gpointer data)
{
    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);

    if (lp->startpos > GPOINTER_TO_INT (data))
        return FALSE;           /* stop iterate */

    LINE_DATA_HEIGHT (lp) = height;
    LINE_DATA_WIDTH (lp) = width;
    return TRUE;
}

static gint
extext_get_line_width (GtkExText * text, GtkExTextLineData * linedataptr,
                       gint pos)
{
    gchar *txt;
    GtkExTextStyle *style;
    GtkExTextStyle *default_style;
    GtkExTextProperty *prop = NULL;
    gint start, end;
    gint curpos = 0;
    gint x = 0, w = 0;
    gint length = 0;
    gint spaces = 0;

    default_style = gtk_extext_style_get (text, "Default");

    curpos = start = linedataptr->startpos;
    curpos += pos;
    end = linedataptr->endpos;

    if (end - curpos > 0) {
        while (curpos < end) {
            prop =
                gtk_extext_property_get_at_pos (text, curpos,
                                                prop ? prop : linedataptr->
                                                property_first);
            if (prop)
                length =
                    prop->endpos < end ? prop->endpos - curpos : end - curpos;
            if (!prop) {
                prop =
                    gtk_extext_property_nearest_forward (text, curpos,
                                                         linedataptr->
                                                         property_first);
                length = prop
                    && prop->startpos <
                    end ? prop->startpos - curpos : end - curpos;
                prop = NULL;
            }

            if (prop)
                style = prop->style;
            else
                style = default_style;

            txt =
                text_get_text_with_expanded_tabs (text, start, curpos,
                                                  curpos + length, NULL,
                                                  &spaces);

            if (txt && style && style->font) {
                w = gdk_text_width (style->font, txt, strlen (txt));
                x += w;
                g_free (txt);
            } else
                length = 1;

            curpos += length;
        }
    }
    return x;
}

static int
extext_get_line_width_special (GtkExText * text,
                               GtkExTextLineData * linedataptr, gint s, gint e)
{
    gchar *txt;
    GtkExTextStyle *style;
    GtkExTextStyle *default_style;
    GtkExTextProperty *prop = NULL;
    gint start = 0, end = 0;
    gint curpos = 0;
    gint x = 0, w = 0;
    gint length = 0;
    gint spaces = 0;

    default_style = gtk_extext_style_get (text, "Default");

    curpos = start = linedataptr->startpos;
    curpos += s;
    end = curpos + e;

    if (end - curpos > 0) {
        while (curpos < end) {
            prop =
                gtk_extext_property_get_at_pos (text, curpos,
                                                prop ? prop : linedataptr->
                                                property_first);
            if (prop)
                length =
                    prop->endpos < end ? prop->endpos - curpos : end - curpos;
            if (!prop) {
                prop =
                    gtk_extext_property_nearest_forward (text, curpos,
                                                         linedataptr->
                                                         property_first);
                length = prop
                    && prop->startpos <
                    end ? prop->startpos - curpos : end - curpos;
                prop = NULL;
            }

            if (prop)
                style = prop->style;
            else
                style = default_style;

            txt =
                text_get_text_with_expanded_tabs (text, start, curpos,
                                                  curpos + length, NULL,
                                                  &spaces);

            if (txt && style && style->font) {
                w = gdk_text_width (style->font, txt, strlen (txt));
                x += w;
                g_free (txt);
            } else
                length = 1;
            curpos += length;
        }
    }
    return x;
}

static gint
extext_get_line_height (GtkExText * text, GtkExTextLineData * linedataptr)
{
    GtkExTextStyle *default_style;
    GtkExTextProperty *prop = NULL;
    GtkExTextProperty *last = NULL;
    gint start = 0, end = 0;
    gint max_height = 0;

    default_style = gtk_extext_style_get (text, "Default");
    max_height = TEXT_STYLE_HEIGHT (default_style);

    start = linedataptr->startpos;
    end = linedataptr->endpos;

    last = text->scroll_line_start->property_first;
    while ((prop = gtk_extext_property_nearest_forward (text, start, last))) {
        gint h;

        if (prop->startpos >= end)
            break;
        last = prop;
        h = TEXT_STYLE_HEIGHT (prop->style);
        if (max_height < h)
            max_height = h;
        start = prop->endpos;
    }
    /*  if(text->pixmap_width > max_height) max_height = text->pixmap_width; */
    return max_height + 1;
}

gint
draw_text_chunk (GtkExText * text, GdkDrawable * draw_area,
                 GtkExTextStyle * style, gchar * chunk, gint length, gint x,
                 gint y, gint h)
{
    gint w;

    w = gdk_text_width (style->font, chunk, length);
    if (x + w > text->gutter_width) {
        if (style->flags & GTK_EXTEXT_STYLE_BG) {
            gdk_gc_set_foreground (text->gc, &style->bg_color);
            gdk_draw_rectangle (draw_area, text->gc, TRUE, x, y, w, h);
        }
        gdk_gc_set_foreground (text->gc, &style->fg_color);
        gdk_draw_text (draw_area, style->font, text->gc, x,
                       y + (h - 1) - style->descent, chunk, length);
        if (style->flags & GTK_EXTEXT_STYLE_UNDER) {
            gdk_draw_line (draw_area, text->gc, x, y + (h - 1), x + w,
                           y + (h - 1));
        }
        if (style->flags & GTK_EXTEXT_STYLE_STRIKE) {
            gdk_draw_line (draw_area, text->gc, x, y + (h / 2), x + w,
                           y + (h / 2));
        }
    }
    return (w);
}

gint
get_tabs_between (GtkExText * text, gint start, gint end)
{
    gint count = 0;
    gint i;

    for (i = start; i < end; i++) {
        if (GTK_EXTEXT_INDEX (text, i) == '\t')
            count++;
    }
    return (count);
}

gint
get_spaces_between (GtkExText * text, gint linestart, gint start, gint end)
{
    gint count = 0;
    gint i = 0;
    gint spacer = 0;

    i = start;
    while (i < end) {
        if (GTK_EXTEXT_INDEX (text, i) == '\t') {
            spacer = (i + count) - linestart;
            if (text->tab_stops)
                spacer =
                    text->default_tab_width -
                    (spacer % text->default_tab_width);
            else
                spacer = text->default_tab_width;
            count += spacer - 1;
        }
        i++;
    }
    return (count);
}

gint
expose_line_text (GtkExText * text, GdkDrawable * draw_area,
                  GtkExTextLineData * linedataptr, gint x, gint y)
{
    gchar *txt;
    gint tabindex = 0;
    GtkExTextStyle *style;
    GtkExTextStyle *default_style;
    GtkExTextProperty *prop = NULL;
    GtkExTextProperty *oldprop = NULL;
    gint start, end;
    gboolean selection = FALSE;
    gboolean pseudo = FALSE;
    gint sstart = 0, send = 0;
    gint curpos = 0;
    gint w = 0;
    gint max_height = 0;
    gint length = 0;
    gint chars = 0;
    gint cursor_done = 0;
    gboolean cursor_line = FALSE;
    gint real_cursor = 0;
    GdkColor color;
    GdkColor fgcolor;
    GdkColor selected_color;
    gboolean use_color = FALSE;
    guint16 flags = 0;
    gint spaces = 0;
    gchar numbers[15];
    gint wz, hz;

    gdk_window_get_size (text->text_area, &wz, &hz);

    if (linedataptr->line_number == text->line_number)
        cursor_line = TRUE;
    x += (gint) - text->hadj->value;
    default_style = gtk_extext_style_get (text, "Default");

    max_height = extext_get_line_height (text, linedataptr);

    if (GTK_WIDGET_HAS_FOCUS (text))
        selected_color = text->scolor;
    else
        selected_color = text->pcolor;

    curpos = start = linedataptr->startpos;
    end = linedataptr->endpos;

    if (text->has_selection) {
        sstart = text->selection_start_pos;
        send = text->selection_end_pos;
        if ((sstart >= start && sstart < end) || (send > start && send <= end)
            || (sstart <= start && send >= end))
            selection = TRUE;
        if (sstart < start)
            sstart = start;
        if (send > end)
            send = end;
    }

    if (!selection && text->pseudo_select && start <= text->pseudo_start
        && end >= text->pseudo_end)
        pseudo = TRUE;

    if (cursor_line) {
        tabindex =
            get_spaces_between (text, start, start,
                                start + text->column_number);
        real_cursor = text->column_number + tabindex;
    }

    oldprop = linedataptr->property_first;

    if (end - start > 0) {
        while (curpos < end) {
            if (x >= wz)
                break;
            prop = gtk_extext_property_get_at_pos (text, curpos, oldprop);
            if (prop) {
                length =
                    prop->endpos < end ? prop->endpos - curpos : end - curpos;
                oldprop = prop;
            }
            if (!prop) {
                prop =
                    gtk_extext_property_nearest_forward (text, curpos, oldprop);
                length = prop
                    && prop->startpos <
                    end ? prop->startpos - curpos : end - curpos;
                oldprop = prop;
                prop = NULL;
            }

            if (prop)
                style = prop->style;
            else
                style = default_style;

            if (selection && sstart <= curpos && send >= curpos + length) {
                if (curpos + length > send)
                    length = send - curpos;
                color = style->bg_color;
                style->bg_color = selected_color;
                fgcolor = style->fg_color;
                style->fg_color.red = style->fg_color.red ^ TEXT_REVERSE_MASK;
                style->fg_color.green =
                    style->fg_color.green ^ TEXT_REVERSE_MASK;
                style->fg_color.blue = style->fg_color.blue ^ TEXT_REVERSE_MASK;
                gdk_color_alloc (gdk_colormap_get_system (), &style->fg_color);
                flags = style->flags;
                style->flags |= GTK_EXTEXT_STYLE_BG;
                use_color = TRUE;
            } else if (selection && sstart > curpos && sstart < curpos + length) {
                length = sstart - curpos;
            } else if (selection && send > curpos && send <= curpos + length) {
                length = send - curpos;
                color = style->bg_color;
                style->bg_color = selected_color;
                fgcolor = style->fg_color;
                style->fg_color.red = style->fg_color.red ^ TEXT_REVERSE_MASK;
                style->fg_color.green =
                    style->fg_color.green ^ TEXT_REVERSE_MASK;
                style->fg_color.blue = style->fg_color.blue ^ TEXT_REVERSE_MASK;
                gdk_color_alloc (gdk_colormap_get_system (), &style->fg_color);
                flags = style->flags;
                style->flags |= GTK_EXTEXT_STYLE_BG;
                use_color = TRUE;
            } else if (pseudo && curpos == text->pseudo_start) {
                length = text->pseudo_end - curpos;
                color = style->bg_color;
                style->bg_color = text->pcolor;
                fgcolor = style->fg_color;
                style->fg_color.red = style->fg_color.red ^ TEXT_REVERSE_MASK;
                style->fg_color.green =
                    style->fg_color.green ^ TEXT_REVERSE_MASK;
                style->fg_color.blue = style->fg_color.blue ^ TEXT_REVERSE_MASK;
                gdk_color_alloc (gdk_colormap_get_system (), &style->fg_color);
                flags = style->flags;
                style->flags |= GTK_EXTEXT_STYLE_BG;
                use_color = TRUE;
            } else if (pseudo && curpos < text->pseudo_start
                       && curpos + length > text->pseudo_start) {
                length = text->pseudo_start - curpos;
            }

            if (text->full_selection && selection && use_color && send == end) {
                gdk_gc_set_foreground (text->gc, &style->bg_color);
                gdk_draw_rectangle (draw_area, text->gc, TRUE, x, y, wz - x,
                                    max_height);
            }

            txt =
                text_get_text_with_expanded_tabs (text, start, curpos,
                                                  curpos + length, NULL,
                                                  &spaces);

            if (txt) {
                w = draw_text_chunk (text, draw_area, style, txt, strlen (txt),
                                     x, y, max_height);
                //g_print("x: %d width: %d.\n", x, w);
                chars += strlen (txt);
                x += w;
                if (cursor_line && !cursor_done && chars >= real_cursor) {
                    int h = 0;
                    int len = chars - real_cursor;

                    cursor_done =
                        gdk_text_width (style->font, &txt[strlen (txt) - len],
                                        len);
                    h = TEXT_STYLE_HEIGHT (style);
                    text->cursor.x = x - cursor_done;
                    if (selection && start + text->column_number >= sstart
                        && start + text->column_number <= send)
                        text->cursor.y = (y + 1);
                    else
                        text->cursor.y = (y + (max_height - 1)) - h;
                    text->cursor.w = text->cursor.x;
                    text->cursor.h = y + (max_height - 1);
                    text->cursor.hide = TRUE;
                    cursor_done = TRUE;
                }
                g_free (txt);
            } else
                length = 1;
            curpos += length;
            if (use_color) {
                style->bg_color = color;
                style->fg_color = fgcolor;
                style->flags = flags;
                use_color = FALSE;
            }
        }
    } else if (cursor_line) {
        gint def_height;

        def_height = TEXT_STYLE_HEIGHT (default_style);
        text->cursor.x = x;
        text->cursor.y = y + (max_height - 1) - def_height;
        text->cursor.w = text->cursor.x;
        text->cursor.h = y + (max_height - 1);
        text->cursor.hide = TRUE;
    }

    if (text->gutter_width) {
        gdk_gc_set_foreground (text->gc,
                               &GTK_WIDGET (text)->style->
                               bg[GTK_STATE_INSENSITIVE]);
        gdk_draw_rectangle (draw_area, text->gc, TRUE, 0, y,
                            text->gutter_width - TEXT_BORDER_ROOM,
                            y + max_height);
    }
    if (text->draw_numbers) {
        gint textwidth;

        g_snprintf (numbers, sizeof (numbers), "%d:",
                    linedataptr->line_number + 1);
        textwidth =
            gdk_text_width (default_style->font, numbers, strlen (numbers));
        gdk_gc_set_foreground (text->gc,
                               &GTK_WIDGET (text)->style->
                               text[GTK_STATE_NORMAL]);
        gdk_draw_text (draw_area, default_style->font, text->gc,
                       text->number_width - (textwidth + TEXT_BORDER_ROOM),
                       y + (max_height - 3), numbers, strlen (numbers));
    }
    if (text->draw_pixmaps && linedataptr->lineptr
        && linedataptr->lineptr->pixmap) {
        if (linedataptr->lineptr->mask) {
            gdk_gc_set_clip_mask (GTK_WIDGET (text)->style->black_gc,
                                  linedataptr->lineptr->mask);
            gdk_gc_set_clip_origin (GTK_WIDGET (text)->style->black_gc,
                                    text->gutter_width -
                                    text->pixmap_max_width + TEXT_BORDER_ROOM,
                                    y + TEXT_BORDER_ROOM + 1);
        }
        if (draw_area)
            gdk_draw_pixmap (draw_area, GTK_WIDGET (text)->style->black_gc,
                             linedataptr->lineptr->pixmap, 0, 0,
                             text->gutter_width - text->pixmap_max_width +
                             TEXT_BORDER_ROOM, y + TEXT_BORDER_ROOM + 1, -1,
                             -1);
        if (linedataptr->lineptr->mask) {
            gdk_gc_set_clip_mask (GTK_WIDGET (text)->style->black_gc, NULL);
            gdk_gc_set_clip_origin (GTK_WIDGET (text)->style->black_gc, 0, 0);
        }
    }
    return y + max_height;
}

/* gint
expose_line_text(GtkExText *text,GdkDrawable *draw_area,GtkExTextLineData *linedataptr,gint x,gint y)
{
  gchar *txt;
  gint tabindex = 0;
  GtkExTextStyle *style;
  GtkExTextStyle *default_style;
  GtkExTextProperty *prop = NULL;
  GtkExTextProperty *oldprop = NULL;
  GtkWidget *widget=GTK_WIDGET(text);
  gint start, end;
  gboolean selection = FALSE;
  gboolean pseudo = FALSE;
  gint sstart = 0, send = 0;
  gint curpos = 0;
  gint w = 0;
  gint max_height = 0;
  gint length = 0;
  gint chars = 0;
  gint cursor_done = 0;
  gboolean cursor_line = FALSE;
  gint real_cursor = 0;
   GdkColor color;
   GdkColor fgcolor;
   GdkColor selected_color;
   gboolean use_color = FALSE;
   guint16 flags = 0;
   gint spaces = 0;
   gchar numbers[15];
   gint wz, hz;

   gdk_window_get_size(text->text_area, &wz, &hz);

   if(linedataptr->line_number == text->line_number) cursor_line = TRUE;
   x += (gint)-text->hadj->value;
   default_style = gtk_extext_style_get(text,"Default");

   max_height = extext_get_line_height(text, linedataptr);

   if(GTK_WIDGET_HAS_FOCUS(text))
      selected_color = text->scolor;
   else
      selected_color = text->pcolor;

   curpos = start = linedataptr->startpos;
   end = linedataptr->endpos;

   if(GTK_EDITABLE(text)->has_selection)
   {
      sstart = GTK_EDITABLE(text)->selection_start_pos;
      send = GTK_EDITABLE(text)->selection_end_pos;
      if((sstart >= start && sstart < end) || (send > start && send <= end) || (sstart <= start && send >= end))
         selection=TRUE;
      if(sstart < start) sstart = start;
      if(send > end) send = end;
                }

   if(!selection && text->pseudo_select && start <= text->pseudo_start && end >= text->pseudo_end)
      pseudo = TRUE;

   if(cursor_line)
   {
      tabindex = get_spaces_between(text, start, start, start+text->column_number);
      real_cursor = text->column_number + tabindex;
  	}

   oldprop = linedataptr->property_first;

   if(end-start > 0)
   {
      while(curpos < end)
      {
         if(x >= wz) break;
         prop = gtk_extext_property_get_at_pos(text, curpos, oldprop);
         if(prop)
         {
            length = prop->endpos < end ? prop->endpos - curpos : end - curpos;
            oldprop = prop;
         }
         if(!prop)
         {
            prop = gtk_extext_property_nearest_forward(text, curpos, oldprop);
            length = prop && prop->startpos < end ? prop->startpos - curpos : end-curpos;
            oldprop = prop;
            prop = NULL;
         }

         if(prop) style = prop->style;
         else style = default_style;

         if(selection && sstart <= curpos && send >= curpos+length)
         {
            if(curpos+length > send) length = send-curpos;
            color = style->bg_color;
            style->bg_color = selected_color;
            fgcolor = style->fg_color;
            style->fg_color.red = style->fg_color.red ^ TEXT_REVERSE_MASK;
            style->fg_color.green = style->fg_color.green ^ TEXT_REVERSE_MASK;
            style->fg_color.blue = style->fg_color.blue ^ TEXT_REVERSE_MASK;
            gdk_color_alloc(gdk_colormap_get_system(), &style->fg_color);
            flags = style->flags;
            style->flags |=GTK_EXTEXT_STYLE_BG;
            use_color = TRUE;
         }
         else if(selection && sstart > curpos && sstart < curpos+length)
         {
            length = sstart - curpos;
         }
         else if(selection && send > curpos && send <= curpos+length)
         {
            length = send - curpos;
            color = style->bg_color;
            style->bg_color = selected_color;
            fgcolor = style->fg_color;
            style->fg_color.red = style->fg_color.red ^ TEXT_REVERSE_MASK;
            style->fg_color.green = style->fg_color.green ^ TEXT_REVERSE_MASK;
            style->fg_color.blue = style->fg_color.blue ^ TEXT_REVERSE_MASK;
            gdk_color_alloc(gdk_colormap_get_system(), &style->fg_color);
            flags = style->flags;
            style->flags |=GTK_EXTEXT_STYLE_BG;
            use_color = TRUE;
         }
         else if(pseudo && curpos == text->pseudo_start)
         {
            length = text->pseudo_end - curpos;
            color = style->bg_color;
            style->bg_color = text->pcolor;
            fgcolor = style->fg_color;
            style->fg_color.red = style->fg_color.red ^ TEXT_REVERSE_MASK;
            style->fg_color.green = style->fg_color.green ^ TEXT_REVERSE_MASK;
            style->fg_color.blue = style->fg_color.blue ^ TEXT_REVERSE_MASK;
            gdk_color_alloc(gdk_colormap_get_system(), &style->fg_color);
            flags = style->flags;
            style->flags |=GTK_EXTEXT_STYLE_BG;
            use_color = TRUE;
         }
         else if(pseudo && curpos < text->pseudo_start && curpos + length > text->pseudo_start)
         {
            length = text->pseudo_start - curpos;
         }

         if(text->full_selection && selection && use_color && send == end)
         {
            gdk_gc_set_foreground(text->gc, &style->bg_color);
            gdk_draw_rectangle(draw_area, text->gc, TRUE, x, y, wz-x, max_height);
         }

         txt = text_get_text_with_expanded_tabs(text, start, curpos, curpos+length, NULL, &spaces);

         if(txt)
         {
            w = draw_text_chunk(text, draw_area, style, txt, strlen(txt), x, y, max_height);
            //g_print("x: %d width: %d.\n", x, w);
            chars += strlen(txt);
            x += w;
            if(cursor_line && !cursor_done && chars >= real_cursor)
            {
               int h = 0;
               int len = chars - real_cursor;
               cursor_done=gdk_text_width(style->font, &txt[strlen(txt)-len], len);
               h = TEXT_STYLE_HEIGHT(style);
               text->cursor.x = x - cursor_done;
               if(selection && start+text->column_number >= sstart && start+text->column_number <= send)
                  text->cursor.y = (y+1);
               else
                  text->cursor.y = (y+(max_height-1)) - h;
               text->cursor.w= text->cursor.x;
               text->cursor.h= y+(max_height-1);
               text->cursor.hide=TRUE;
               cursor_done = TRUE;
            }
            g_free(txt);
         }
         else length = 1;
         curpos += length;
         if(use_color)
         {
            style->bg_color = color;
            style->fg_color = fgcolor;
            style->flags = flags;
            use_color = FALSE;
         }
      }
   }
   else if(cursor_line)
   {
      gint def_height;
      def_height = TEXT_STYLE_HEIGHT(default_style);
      text->cursor.x = x;
      text->cursor.y = y+(max_height-1)-def_height;
      text->cursor.w = text->cursor.x;
      text->cursor.h = y+(max_height-1);
      text->cursor.hide=TRUE;
  }

   if(text->gutter_width)
   {
      gdk_gc_set_foreground(text->gc, &GTK_WIDGET(text)->style->bg[GTK_STATE_PRELIGHT]);
      gdk_draw_rectangle(draw_area, text->gc, TRUE, 0, y, text->gutter_width-TEXT_BORDER_ROOM, y+max_height);
   }
   if(text->draw_numbers)
   {
      gint textwidth;
      g_snprintf(numbers, sizeof(numbers), "%d:", linedataptr->line_number + 1);
      textwidth = gdk_text_width(default_style->font, numbers, strlen(numbers));
      gdk_gc_set_foreground(text->gc, &GTK_WIDGET(text)->style->text[GTK_STATE_NORMAL]);
      gdk_draw_text(draw_area, default_style->font, text->gc, text->number_width-(textwidth+TEXT_BORDER_ROOM), y + (max_height-3), numbers, strlen(numbers));
   }
   if(text->draw_pixbufs && linedataptr->lineptr && linedataptr->lineptr->pixbuf)
   {
	GdkPixbuf *pixbuf=linedataptr->lineptr->pixbuf;
	    int width = gdk_pixbuf_get_width(pixbuf) ;
        int height=gdk_pixbuf_get_height(pixbuf);
	   int  rowstride=gdk_pixbuf_get_rowstride(pixbuf);
       guchar* pixels=gdk_pixbuf_get_pixels(pixbuf);
        if(gdk_pixbuf_get_has_alpha (pixbuf))
		gdk_draw_rgb_32_image (draw_area,
				    widget->style->white_gc,
				 text->gutter_width-width-TEXT_BORDER_ROOM,y-TEXT_BORDER_ROOM,
                          width,height,
				    GDK_RGB_DITHER_MAX,
				   pixels,
				    rowstride);
        else
		gdk_draw_rgb_image (draw_area,
				    widget->style->white_gc,
				 text->gutter_width-width-TEXT_BORDER_ROOM,y-TEXT_BORDER_ROOM,
                          width,height,
				    GDK_RGB_DITHER_NORMAL,
				   pixels,
				    rowstride);

   }
   return y+max_height;
}
*/

gint
gtk_extext_cursor_blink (gpointer data)
{
    GdkColor *color;
    GtkExText *text;

    g_return_val_if_fail (data != NULL, TRUE);
    g_return_val_if_fail (GTK_IS_EXTEXT (data), TRUE);

    text = GTK_EXTEXT (data);

    if (!text->draw_cursor)
        return (FALSE);
    else if (!GTK_WIDGET_HAS_FOCUS (text) && text->cursor.hide)
        return TRUE;

    if (!text->cursor.hide) {
        color = &GTK_WIDGET (text)->style->text[GTK_STATE_NORMAL];
        text->cursor.hide = TRUE;
    } else {
        color = &GTK_WIDGET (text)->style->bg[GTK_STATE_NORMAL];
        text->cursor.hide = FALSE;
    }

    if (text->gc && text->draw_cursor && text->cursor.x >= text->gutter_width) {
        gdk_gc_set_foreground (text->gc, color);
        gdk_draw_line (text->text_area, text->gc,
                       text->cursor.x, text->cursor.y,
                       text->cursor.w, text->cursor.h);
    }
    return (TRUE);
}

static void
gtk_extext_disconnect (GtkAdjustment * adjustment, GtkExText * text)
{
    g_return_if_fail (adjustment != NULL);
    g_return_if_fail (GTK_IS_ADJUSTMENT (adjustment));
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (adjustment == text->hadj)
        gtk_extext_set_adjustments (text, NULL, text->vadj);
    if (adjustment == text->vadj)
        gtk_extext_set_adjustments (text, text->hadj, NULL);
}

static gint
gtk_extext_scroll_timeout (gpointer data)
{
    GtkExText *text;
    GdkEventMotion event;
    gint x, y;
    GdkModifierType mask;

    GDK_THREADS_ENTER ();
    text = GTK_EXTEXT (data);
    gdk_window_get_pointer (text->text_area, &x, &y, &mask);
    if (mask & (GDK_BUTTON1_MASK | GDK_BUTTON3_MASK)) {
        event.is_hint = 0;
        event.x = x;
        event.y = y;
        event.state = mask;
        gtk_extext_motion_notify (GTK_WIDGET (text), &event);
    }
    GDK_THREADS_LEAVE ();
    return FALSE;
}

/*****************************************************************************/
/*                    Mousecursor TO line and linecursorpos                      */
/*                         Code 																*/
/*****************************************************************************/

gint
gtk_extext_get_column_by_offset (GtkExText * text,
                                 GtkExTextLineData * linedataptr, gint x,
                                 gint * offsetx)
{
    GtkExTextClass *klass;

    g_return_val_if_fail (text, 0);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), 0);

    klass = GTK_EXTEXT_CLASS (GTK_OBJECT (text)->klass);
    if (klass)
        return klass->column_by_offset (text, linedataptr, x, offsetx);

    return 0;
}

GtkExTextLineData *
gtk_extext_get_line_by_offset (GtkExText * text, gint y, gint * offsety)
{
    g_return_val_if_fail (text, 0);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);

    return GTK_EXTEXT_CLASS (GTK_OBJECT (text)->klass)->line_by_offset (text, y,
                                                                        offsety);
}

GtkExTextLineData *
gtk_extext_get_line_by_char_pos (GtkExText * text, gint pos,
                                 GtkExTextLineData * lp)
{
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);

    return line_get_by_char_pos (text, pos, lp);
}

GtkExTextLineData *
line_get_by_offset (GtkExText * text, gint y, gint * offsety)
{
    gint lnum;
    gint height = 0;
    gint w, h, len, i;
    GtkExTextLineData *linedataptr;

    g_return_val_if_fail (text != NULL, NULL);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);

    linedataptr = text->scroll_line_start;
    gdk_window_get_size (text->text_area, &w, &h);
    if (offsety)
        *offsety = 0;
    for (lnum = text->scroll_line_start->line_number; lnum <= text->line_count;
         lnum++) {
        i = 0;
        linedataptr =
            gtk_extext_get_line_data (text, lnum, text->scroll_line_start);
        len = LINE_DATA_LENGTH (linedataptr);
        height += extext_get_line_height (text, linedataptr);
        if (y <= height)
            break;
        if (offsety)
            *offsety += height;
        if (lnum != text->line_count)
            g_free (linedataptr);
    }
    return linedataptr;
}

void
find_cursor (GtkExText * text, gdouble x, gdouble y, gboolean select)
{
    GtkExTextStyle *defstyle;
    GtkExTextLineData *lp = NULL;
    gint cursor = -1;
    gint dummy;
    gint oldpos = 0;
    gint adj = text->hadj->value;

    oldpos = text->current_pos;
    defstyle = gtk_extext_style_get (text, "Default");

    if (y < 0) {
        lp = gtk_extext_get_line_data (text,
                                       text->scroll_line_start->line_number - 1,
                                       text->scroll_line_start);
        if (text->scroll_line_start->line_number - 1 >= 0) {
            goto_line (text, text->scroll_line_start->line_number - 1, select,
                       TRUE, FALSE);
            if (text->timer) {
                gtk_timeout_remove (text->timer);
                text->timer = 0;
            }
            text->timer =
                gtk_timeout_add (SCROLL_TIME, gtk_extext_scroll_timeout, text);
        }
    } else {
        y -= 2;
        lp = gtk_extext_get_line_by_offset (text, y, &dummy);
        if ((lp->line_number >
             text->scroll_line_start->line_number + text->scroll_line_count)
            && (text->scroll_line_start->line_number + text->scroll_line_count +
                1 <= text->line_count)) {
            gint line = 0;

            line = text->line_number + 1;
            lp = gtk_extext_get_line_data (text, line, text->scroll_line_start);
            if (text->timer) {
                gtk_timeout_remove (text->timer);
                text->timer = 0;
            }
            text->timer =
                gtk_timeout_add (SCROLL_TIME, gtk_extext_scroll_timeout, text);
        } else {
            if (text->timer) {
                gtk_timeout_remove (text->timer);
                text->timer = 0;
            }
        }
        if (lp->line_number <= text->line_count)
            goto_line (text, lp->line_number, select, TRUE, TRUE);
    }

    text->hadj->value = adj;
    lp = gtk_extext_get_line_data (text, text->line_number,
                                   text->scroll_line_start);
    cursor = gtk_extext_get_column_by_offset (text, lp, x + adj, &dummy);

    if (cursor == -1 && lp->line_number == text->line_count)
        move_cursor (text, LINE_DATA_LENGTH (lp), select);
    else if (cursor == -1)
        move_cursor (text, LINE_DATA_LENGTH (lp) - 1, select);
    else
        move_cursor (text, cursor, select);
    g_free (lp);
    if ((text->current_pos != oldpos) || !select)
        gtk_widget_queue_draw (GTK_WIDGET (text));
}

gint
column_get_by_offset (GtkExText * text, GtkExTextLineData * linedataptr,
                      gint x, gint * newx)
{
    GtkExTextStyle *style;
    GtkExTextProperty *prop;
    GtkExTextStyle *defstyle;
    GtkExTextProperty *new;
    gchar chars[9];
    gint width = 0;
    gint curwidth = 0;
    gint cursor = 0;
    guchar key = 0;
    gint abscol = 0;
    gint spaces = 0;
    gint spacer = 0;
    gint tabindex = 0;
    gint i = 0;
    gint pos = 0;

    g_return_val_if_fail (text, 0);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), 0);

    defstyle = gtk_extext_style_get (text, "Default");
    prop = linedataptr->property_first;
    pos = linedataptr->startpos;

    x -= text->gutter_width;
    for (i = 0; i < LINE_DATA_LENGTH (linedataptr); i++, pos++) {
        style = defstyle;
        if ((new =
             gtk_extext_property_get_at_pos (text, pos,
                                             linedataptr->property_first))) {
            prop = new;
            style = prop->style;
        }
        if (!style)
            style = defstyle;

        key = GTK_EXTEXT_INDEX (text, pos);
        if (key == '\t') {
            abscol = i + spaces;
            spacer =
                text->default_tab_width - (abscol % text->default_tab_width);
            spaces += spacer - 1;
            memset (chars, ' ', spacer);
            chars[spacer] = '\0';
            tabindex++;
        } else {
            chars[0] = key;
            chars[1] = '\0';
            spacer = 1;
        }
        if (key != '\n') {
            curwidth = gdk_text_width (style->font, chars, spacer);
            if ((width + curwidth / 2) >= x)
                break;
            width += curwidth;
            cursor++;
        }
    }
    return cursor;
}

void
gtk_extext_draw (GtkWidget * widget, GdkRectangle * area)
{
    //static gint counter = 0;
    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));
    g_return_if_fail (area != NULL);

    if (GTK_WIDGET_DRAWABLE (widget)) {
        //g_print("Counter is currently: %d.\n", counter++);
        expose_text (GTK_EXTEXT (widget), area, TRUE);
    }
}

/*****************************************************************************/
/*                              extext_key_press                                */
/*****************************************************************************/
static gint
gtk_extext_key_press (GtkWidget * widget, GdkEventKey * event)
{
    GtkExText *text;
    gboolean shift_state;
    gboolean control_state;
    gboolean paint = FALSE;
    gboolean return_value = FALSE;
    gint key;
    gint curpos;

    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    g_return_val_if_fail (event != NULL, FALSE);

    text = GTK_EXTEXT (widget);

    curpos = text->current_pos;

    shift_state = event->state & GDK_SHIFT_MASK;
    control_state = event->state & GDK_CONTROL_MASK;

    if (event->state & GDK_MOD1_MASK)
        return FALSE;

    key = event->keyval;
    if (control_state) {
        if (key == 'V' || key == 'v') {
            gtk_extext_paste_clipboard (text);
            update_select (text, 0, FALSE, TRUE);
            return_value = TRUE;
            paint = TRUE;
        } else if (key == 'C' || key == 'c') {
            gtk_extext_copy_clipboard (text);
            return_value = TRUE;
            paint = TRUE;
        } else if (key == 'X' || key == 'x') {
            gtk_extext_cut_clipboard (text);
            update_select (text, 0, FALSE, TRUE);
            return_value = TRUE;
            paint = TRUE;
        }
    }
    if (!return_value) {
        switch (event->keyval) {
        case GDK_Home:
            if (control_state) {
                goto_line (text, 0, shift_state, TRUE, FALSE);
                paint = TRUE;
            } else {
                if (!text->column_number && shift_state) {
                    goto_line (text, text->line_number - 1, shift_state, TRUE,
                               FALSE);
                    paint = TRUE;
                } else {
                    if (text->column_number > 0) {
                        line_set_cursor_pos (text, 0);
                        update_select (text, curpos, shift_state, TRUE);
                        paint = TRUE;
                    }
                }
            }
            return_value = TRUE;
            break;
        case GDK_End:
            if (control_state) {
                goto_line (text, text->line_count, shift_state, TRUE, TRUE);
                paint = TRUE;
            } else {
                GtkExTextLineData *linedata;
                gint index = 0;

                linedata =
                    gtk_extext_get_line_data (text, text->line_number, NULL);
                if (GTK_EXTEXT_INDEX (text, linedata->endpos - 1) == '\n'
                    && text->line_ptr->length > 1)
                    index = text->line_ptr->length - 1;
                else if (text->line_ptr->length == 1
                         && GTK_EXTEXT_INDEX (text,
                                              linedata->endpos - 1) == '\n')
                    index = text->column_number;
                else
                    index = text->line_ptr->length;
                if (text->column_number != index) {
                    line_set_cursor_pos (text, text->line_ptr->length);
                    update_select (text, curpos, shift_state, TRUE);
                    paint = TRUE;
                }
                g_free (linedata);
            }
            return_value = TRUE;
            break;
        case GDK_Page_Up:
            if (text->line_number > 0) {
                goto_line (text, text->line_number - text->scroll_line_count,
                           shift_state, TRUE, FALSE);
                if (text->select_line && !shift_state) {
                    GtkExTextLineData *linedata;

                    linedata =
                        gtk_extext_get_line_data (text, text->line_number,
                                                  text->scroll_line_start);
                    if (linedata) {
                        text->selection_start_pos = linedata->startpos;
                        text->selection_end_pos = linedata->endpos;
                        text->has_selection = TRUE;
                        g_free (linedata);
                    }
                }
                paint = TRUE;
            }
            return_value = TRUE;
            break;
        case GDK_Page_Down:
            if (text->line_number < text->line_count) {
                goto_line (text, text->line_number + text->scroll_line_count,
                           shift_state, TRUE, TRUE);
                if (text->select_line && !shift_state) {
                    GtkExTextLineData *linedata;

                    linedata =
                        gtk_extext_get_line_data (text, text->line_number,
                                                  text->scroll_line_start);
                    if (linedata) {
                        text->selection_start_pos = linedata->startpos;
                        text->selection_end_pos = linedata->endpos;
                        text->has_selection = TRUE;
                        g_free (linedata);
                    }
                }
                paint = TRUE;
            }
            return_value = TRUE;
            break;
        case GDK_Insert:
            if (control_state) {
                gtk_extext_copy_clipboard (text);
                return_value = TRUE;
                paint = TRUE;
            } else if (shift_state) {
                gtk_extext_paste_clipboard (text);
                return_value = TRUE;
                paint = TRUE;
            }
            break;
        case GDK_Up:
            if (text->line_number - 1 >= 0) {
                goto_line (text, text->line_number - 1, shift_state, TRUE,
                           FALSE);
                if (text->select_line && !shift_state) {
                    GtkExTextLineData *linedata;

                    linedata =
                        gtk_extext_get_line_data (text, text->line_number,
                                                  text->scroll_line_start);
                    if (linedata) {
                        text->selection_start_pos = linedata->startpos;
                        text->selection_end_pos = linedata->endpos;
                        text->has_selection = TRUE;
                        g_free (linedata);
                    }
                }
                paint = TRUE;
            }
            return_value = TRUE;
            break;
        case GDK_Down:
            if (text->line_number + 1 <= text->line_count) {
                goto_line (text, text->line_number + 1, shift_state, TRUE,
                           TRUE);
                if (text->select_line && !shift_state) {
                    GtkExTextLineData *linedata;

                    linedata =
                        gtk_extext_get_line_data (text, text->line_number,
                                                  text->scroll_line_start);
                    if (linedata) {
                        text->selection_start_pos = linedata->startpos;
                        text->selection_end_pos = linedata->endpos;
                        text->has_selection = TRUE;
                        g_free (linedata);
                    }
                }
                paint = TRUE;
            }
            return_value = TRUE;
            break;
        case GDK_Left:
            if (control_state) {
                gint oldselstart = text->selection_start_pos;
                gint oldselend = text->selection_end_pos;
                gint pos = 0;
                gint start = curpos;
                gint end = 0;
                gboolean selection;

                selection = text->has_selection;
                if (gtk_extext_get_current_word (text, &start, &end)
                    && start != curpos)
                    pos = start;
                else if (gtk_extext_get_previous_word (text, &start, &end))
                    pos = start;
                else
                    pos = 0;
                if (pos != curpos) {
                    gtk_extext_set_position (text, pos);
                    if (shift_state) {
                        if (selection) {
                            text->selection_start_pos =
                                pos <= oldselstart ? pos : oldselstart;
                            text->selection_end_pos = pos <= oldselend
                                && pos >= oldselstart ? pos : oldselend;
                        } else {
                            text->selection_start_pos = pos;
                            text->selection_end_pos = curpos;
                        }
                        update_select (text, pos, TRUE, FALSE);
                    }
                    paint = TRUE;
                }
            } else {
                if (curpos > 0) {
                    move_cursor (text, text->column_number - 1, shift_state);
                    paint = TRUE;
                }
            }
            return_value = TRUE;
            break;
        case GDK_Right:
            if (control_state) {
                gint oldselstart = text->selection_start_pos;
                gint oldselend = text->selection_end_pos;
                gint pos = text->length;
                gint start = text->current_pos;
                gint end;
                gboolean selection;

                selection = text->has_selection;
                if (gtk_extext_get_current_word (text, &start, &end))
                    pos = end;
                else if (gtk_extext_get_next_word (text, &start, &end))
                    pos = end;
                else
                    pos = text->length;
                if (pos != curpos) {
                    gtk_extext_set_position (text, pos);
                    if (shift_state) {
                        if (selection) {
                            text->selection_start_pos = pos >= oldselstart
                                && pos <= oldselend ? pos : oldselstart;
                            text->selection_end_pos =
                                pos >= oldselend ? pos : oldselend;
                        } else {
                            text->selection_start_pos = pos;
                            text->selection_end_pos = curpos;
                        }
                        update_select (text, pos, TRUE, FALSE);
                    }
                    paint = TRUE;
                }
            } else if (text->column_number + 1 <= text->length) {
                move_cursor (text, text->column_number + 1, shift_state);
                paint = TRUE;
            }
            return_value = TRUE;
            break;
        default:
            if (text->editable && !control_state) {
                switch (event->keyval) {
                case GDK_Return:
                    gtk_extext_insert_text (text, "\n", 1, &curpos);
                    return_value = TRUE;
                    paint = TRUE;
                    break;
                case GDK_KP_Enter:
                    gtk_extext_insert_text (text, "\n", 1, &curpos);
                    return_value = TRUE;
                    paint = TRUE;
                    break;
                case GDK_BackSpace:
                    if (text->has_selection)
                        gtk_extext_delete_text (text,
                                                text->selection_start_pos,
                                                text->selection_end_pos);
                    else if (curpos > 0)
                        gtk_extext_delete_text (text,
                                                text->current_pos - 1,
                                                text->current_pos);
                    else
                        break;
                    update_select (text, 0, FALSE, TRUE);
                    return_value = TRUE;
                    paint = TRUE;
                    break;
                case GDK_Delete:
                    if (shift_state && text->has_selection)
                        gtk_extext_cut_clipboard (text);
                    else if (text->has_selection)
                        gtk_extext_delete_text (text,
                                                text->selection_start_pos,
                                                text->selection_end_pos);
                    else if (curpos < text->length)
                        gtk_extext_delete_text (text, text->current_pos,
                                                text->current_pos + 1);
                    else
                        break;
                    update_select (text, 0, FALSE, TRUE);
                    return_value = TRUE;
                    paint = TRUE;
                    break;
                case GDK_Tab:
                    if (!text->use_spaces)
                        gtk_extext_insert_text (text, "\t", 1, &curpos);
                    else
                        gtk_extext_insert_text (text, "  ", 2, &curpos);

                    return_value = TRUE;
                    paint = TRUE;
                    break;
                default:
                    if (event->length) {
                        gtk_extext_insert_text (text,
                                                (guchar *) event->string,
                                                event->length, &curpos);
                        return_value = TRUE;
                        paint = TRUE;
                    }
                    break;
                }
            }
            break;
        }
    }
    if (paint)
        gtk_widget_queue_draw (widget);
    return return_value;
}

static void
gtk_extext_adjustment_changed (GtkAdjustment * adjustment, GtkExText * text)
{
    g_return_if_fail (adjustment != NULL);
    g_return_if_fail (GTK_IS_ADJUSTMENT (adjustment));
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    /* Just ignore it if we haven't been size-allocated and realized yet */
    if (!GTK_WIDGET_REALIZED (text))
        return;

    if (adjustment == text->hadj) {
    } else if (adjustment == text->vadj) {
        recompute_scroll_line_height (text);
        text->vadj->upper = (float) text->line_count + 1;   // Added +1 by chicane
    }
}

static void
gtk_extext_adjustment_value_changed (GtkAdjustment * adjustment,
                                     GtkExText * text)
{
    GtkExTextLineData *lp;
    gint firstline;
    gint curline;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));


    if (adjustment == text->vadj) {
        firstline = (gint) text->vadj->value;
        curline = text->line_number;

        lp = gtk_extext_get_line_data (text, firstline,
                                       text->scroll_line_start);
        text->scroll_line_start = lp;

        if (curline < text->scroll_line_start->line_number) {
            goto_line (text, firstline, FALSE, FALSE, FALSE);
        }
        /* if out of viewport */
        else if (curline >=
                 text->scroll_line_start->line_number +
                 text->scroll_line_count - 1) {
            goto_line (text,
                       text->scroll_line_start->line_number +
                       text->scroll_line_count - 1, FALSE, FALSE, TRUE);
        }
    } else if (adjustment == text->hadj) {
    }
    gtk_widget_queue_draw (GTK_WIDGET (text));
}

static gint
gtk_extext_focus_in (GtkWidget * widget, GdkEventFocus * event)
{
    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    g_return_val_if_fail (event != NULL, FALSE);

    GTK_WIDGET_SET_FLAGS (widget, GTK_HAS_FOCUS);
    gtk_widget_draw_focus (widget);

#ifdef USE_XIM
    if (GTK_EXTEXT (widget)->ic)
        gdk_im_begin (GTK_EXTEXT (widget)->ic, GTK_EXTEXT (widget)->text_area);
#endif
    return FALSE;
}

static gint
gtk_extext_focus_out (GtkWidget * widget, GdkEventFocus * event)
{
    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    g_return_val_if_fail (event != NULL, FALSE);

    GTK_WIDGET_UNSET_FLAGS (widget, GTK_HAS_FOCUS);
    gtk_widget_queue_draw (widget);
    gtk_widget_draw_focus (widget);
#ifdef USE_XIM
    gdk_im_end ();
#endif
    return FALSE;
}

static gint
gtk_extext_motion_notify (GtkWidget * widget, GdkEventMotion * event)
{
    GtkExText *text;
    gint x, y;
    GdkModifierType mask;

    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    g_return_val_if_fail (event != NULL, FALSE);

    text = GTK_EXTEXT (widget);

    x = event->x;
    y = event->y;
    mask = event->state;

    if (x < text->gutter_width) {
        gdk_window_set_cursor (GTK_EXTEXT (widget)->text_area, text->acursor);
    } else {
        gdk_window_set_cursor (GTK_EXTEXT (widget)->text_area, text->ecursor);
    }

    if (event->is_hint || (text->text_area != event->window)) {
        gdk_window_get_pointer (text->text_area, &x, &y, &mask);
    }
    if ((text->button == 0) || !(mask & (GDK_BUTTON1_MASK | GDK_BUTTON3_MASK)))
        return FALSE;
    find_cursor (GTK_EXTEXT (widget), (float) x, (float) y, TRUE);
    return FALSE;
}

static gint
ugly_popup_hack (GtkWidget * widget, GdkEventButton * event)
{
    GtkExText *text = GTK_EXTEXT (widget);

    if (!GTK_WIDGET_HAS_FOCUS (widget))
        gtk_widget_grab_focus (widget);

    if (event->button == 3 && event->type == GDK_BUTTON_PRESS) {
        if (text->margin_popupmenu && event->x < text->gutter_width)
            gtk_menu_popup (GTK_MENU (text->margin_popupmenu),
                            NULL, NULL, NULL, NULL, event->button, event->time);
        else if (text->text_popupmenu && event->x > text->gutter_width)
            gtk_menu_popup (GTK_MENU (text->text_popupmenu),
                            NULL, NULL, NULL, NULL, event->button, event->time);

        gtk_signal_emit_stop_by_name (GTK_OBJECT (widget),
                                      "button_press_event");
        return TRUE;
    }
    return FALSE;
}

static gint
gtk_extext_button_press (GtkWidget * widget, GdkEventButton * event)
{
    gchar *chars;
    gint start, end;
    GtkExText *text;
    GtkExTextLineData *linedataptr;
    static GdkAtom ctext_atom = GDK_NONE;
    gint shift_state;
    gint control_state;

    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    g_return_val_if_fail (event != NULL, FALSE);

    if (ctext_atom == GDK_NONE)
        ctext_atom = gdk_atom_intern ("COMPOUND_TEXT", FALSE);

    text = GTK_EXTEXT (widget);
    shift_state = event->state & GDK_SHIFT_MASK;
    control_state = event->state & GDK_CONTROL_MASK;

    if (text->button && (event->button != text->button))
        return FALSE;

    linedataptr =
        gtk_extext_get_line_data (text, text->line_number,
                                  text->scroll_line_start);
    text->button = event->button;

    if (event->button == 1) {
        switch (event->type) {
        case GDK_BUTTON_PRESS:
            gtk_grab_add (widget);
            text->has_selection = TRUE;
            find_cursor (text, event->x, event->y, FALSE);
            break;
        case GDK_2BUTTON_PRESS:
            start = end = text->current_pos;
            if (!gtk_extext_get_current_word (text, &start, &end))
                gtk_extext_get_previous_word (text, &start, &end);
            gtk_extext_set_position (text, start);
            text->selection_start_pos = start;
            text->selection_end_pos = end;
            text->has_selection = TRUE;
            break;
        case GDK_3BUTTON_PRESS:
            gtk_extext_set_position (text, linedataptr->startpos);
            text->selection_start_pos = linedataptr->startpos;
            text->selection_end_pos = linedataptr->endpos;
            text->has_selection = TRUE;
            break;
        default:
            break;
        }
    } else if (event->type == GDK_BUTTON_PRESS) {
        if ((event->button == 2) && text->editable) {
            if (text->has_selection
                && text->selection_start_pos != text->selection_end_pos) {
                start = text->selection_start_pos;
                end = text->selection_end_pos;
                chars =
                    gtk_extext_get_chars (text,
                                          text->selection_start_pos,
                                          text->selection_end_pos);
                if (chars) {
                    gint insert_pos;

                    find_cursor (text, event->x, event->y, FALSE);
                    insert_pos = text->current_pos;
                    gtk_extext_insert_text (text, chars, strlen (chars),
                                            &text->current_pos);
                    if (insert_pos < start)
                        start += strlen (chars);
                    if (insert_pos < end)
                        end += strlen (chars);
                    text->selection_start_pos = insert_pos;
                    text->selection_end_pos = insert_pos + strlen (chars);
                    text->has_selection = TRUE;
                    g_free (chars);
                    return (TRUE);
                }
            } else {
                text->has_selection = FALSE;
                text->selection_start_pos = -1;
                text->selection_end_pos = -1;
            }
            gtk_selection_convert (widget, GDK_SELECTION_PRIMARY, ctext_atom,
                                   event->time);
            gtk_signal_emit_stop_by_name ((GtkObject *) widget,
                                          "button_press_event");
        } else if (event->button == 4) {
            if ((text->line_number - (text->scroll_line_count / 2)) >= 0)
                goto_line (text,
                           text->line_number - (text->scroll_line_count / 2),
                           shift_state, TRUE, FALSE);
            else
                goto_line (text, 0, shift_state, TRUE, FALSE);
            gtk_widget_queue_draw (widget);
        } else if (event->button == 5) {
            if ((text->line_number + (text->scroll_line_count / 2)) <=
                text->line_count)
                goto_line (text,
                           text->line_number + (text->scroll_line_count / 2),
                           shift_state, TRUE, TRUE);
            else
                goto_line (text, text->line_count, shift_state, TRUE, TRUE);
            gtk_widget_queue_draw (widget);
        } else {
            gtk_grab_add (widget);
            gtk_extext_set_no_selection (text, TRUE);
        }
    }

    if (event->x < text->gutter_width) {
        gtk_signal_emit (GTK_OBJECT (text), extext_signals[MARGIN_CLICKED],
                         event, text->line_number);
    }
    g_free (linedataptr);
    return FALSE;
}

static gint
gtk_extext_button_release (GtkWidget * widget, GdkEventButton * event)
{
    GtkExText *text;
    GtkExTextLineData *linedata;

    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    g_return_val_if_fail (event != NULL, FALSE);

    text = GTK_EXTEXT (widget);

    gtk_grab_remove (widget);

    if (text->button != event->button)
        return FALSE;

    text->button = 0;

    if (text->timer) {
        gtk_timeout_remove (text->timer);
        text->timer = 0;
    }

    if (event->button == 1) {
        gtk_grab_remove (widget);
        text->has_selection = FALSE;
        if (text->selection_start_pos != text->selection_end_pos) {
            if (gtk_selection_owner_set
                (widget, GDK_SELECTION_PRIMARY, event->time)) {
                text->has_selection = TRUE;
            } else {
                gtk_widget_queue_draw (widget);
            }
        } else {
            if (gdk_selection_owner_get (GDK_SELECTION_PRIMARY) ==
                widget->window)
                gtk_selection_owner_set (NULL, GDK_SELECTION_PRIMARY,
                                         event->time);
        }
        linedata =
            gtk_extext_get_line_data (text, text->line_number,
                                      text->scroll_line_start);
        if (text->select_line && !text->has_selection) {
            text->has_selection = TRUE;
            text->selection_start_pos = linedata->startpos;
            text->selection_end_pos = linedata->endpos;
            gtk_widget_queue_draw (widget);
        } else if (!text->has_selection && event->x < text->gutter_width) {
            text->has_selection = TRUE;
            text->selection_start_pos = linedata->startpos;
            text->selection_end_pos = linedata->endpos;
            gtk_widget_queue_draw (widget);
        }

        g_free (linedata);
    } else if (event->button == 3) {
        gtk_grab_remove (widget);
    }
    return (FALSE);
}

/* Make sure scrolladjustment is up to date */
void
scroll_to_view (GtkExText * text, gint moveto, gboolean bottom)
{
    GtkExTextLineData *lp;

    if (text->scroll_line_start->line_number > moveto) {
        lp = gtk_extext_get_line_data (text, moveto, text->scroll_line_start);
        g_free (text->scroll_line_start);
        text->scroll_line_start = lp;
        text->vadj->value = (gfloat) moveto;
        gtk_adjustment_changed (text->vadj);
    } else if (text->scroll_line_start->line_number + text->scroll_line_count <=
               moveto) {
        if (bottom) {
            lp = gtk_extext_get_line_data (text,
                                           moveto - (text->scroll_line_count -
                                                     1),
                                           text->scroll_line_start);
            text->vadj->value =
                (gfloat) (moveto - (text->scroll_line_count - 1));
        } else {
            if (moveto + text->scroll_line_count > text->line_count)
                moveto = text->line_count - text->scroll_line_count + 1;
            lp = gtk_extext_get_line_data (text, moveto,
                                           text->scroll_line_start);
            text->vadj->value = (gfloat) moveto;
        }
        g_free (text->scroll_line_start);
        text->scroll_line_start = lp;
        gtk_adjustment_changed (text->vadj);
    }
}

Lines *
goto_line (GtkExText * text, gint posindex, gboolean select,
           gboolean killselect, gboolean bottom)
{
    gint curpos, oldpos, len;
    Lines *pos;
    GtkExTextLineData *linedata;

    //gint oldbak;

    linedata =
        gtk_extext_get_line_data (text, posindex, text->scroll_line_start);
    oldpos = text->current_pos;
    curpos = text->column_number;
    pos = line_set (text, posindex);
    len = pos->length;
    //oldbak = text->lci_bak;
    //curpos = oldbak > -1 ? oldbak : curpos;
    if (curpos > len) {
        if (linedata && GTK_EXTEXT_INDEX (text, linedata->endpos - 1) != '\n')
            line_set_cursor_pos (text, len ? len : 0);
        else
            line_set_cursor_pos (text, len ? len - 1 : 0);
        //text->lci_bak = oldbak;
    } else
        line_set_cursor_pos (text, text->column_number);
    //if(oldbak != text->lci_bak) text->lci_bak = oldbak;
    scroll_to_view (text, text->line_number, bottom);
    update_select (text, oldpos, select, killselect);
    recompute_scroll_line_width (text, text->scroll_line_start,
                                 text->scroll_line_count);
    g_free (linedata);
    gtk_signal_emit (GTK_OBJECT (text), extext_signals[MOVE_TO_ROW],
                     text->line_number);
    return text->line_ptr;
}

gint
move_cursor (GtkExText * text, gint moveto, gboolean select)
{
    /* if move cursor we should always kill selection if select is false */
    gint oldpos;

    oldpos = text->current_pos;
    line_set_cursor_pos (text, moveto);
    scroll_to_view (text, text->line_number, FALSE);
    update_select (text, oldpos, select, TRUE);
    return text->current_pos;
}

static void
update_select (GtkExText * text, gint oldpos, gboolean select,
               gboolean killselect)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (select) {
        /* FORWARD SELECT */
        if (oldpos < text->current_pos) {
            if (text->selection_start_pos == -1) {
                text->selection_start_pos = oldpos;
                text->selection_end_pos = text->current_pos;
            } else if (text->selection_start_pos == oldpos)
                text->selection_start_pos = text->current_pos;
            else
                text->selection_end_pos = text->current_pos;
        } else {
            if (text->selection_end_pos == -1) {
                text->selection_end_pos = oldpos;
                text->selection_start_pos = text->current_pos;
            } else if (text->selection_end_pos == oldpos)
                text->selection_end_pos = text->current_pos;
            else
                text->selection_start_pos = text->current_pos;
        }
        /* this is to make sure start end is not swaped */
        if (text->selection_end_pos < text->selection_start_pos) {
            gint swap = text->selection_start_pos;

            text->selection_start_pos = text->selection_end_pos;
            text->selection_end_pos = swap;
        }
        if (text->selection_start_pos != text->selection_end_pos)
            text->has_selection = TRUE;
        else {
            text->has_selection = FALSE;
            text->selection_start_pos = -1;
            text->selection_end_pos = -1;
            gtk_widget_queue_draw (GTK_WIDGET (text));
        }
    } else if (killselect) {
        text->has_selection = FALSE;
        text->selection_start_pos = -1;
        text->selection_end_pos = -1;
        gtk_widget_queue_draw (GTK_WIDGET (text));
    }

    if (text->has_selection)
        gtk_extext_set_pseudo_select (text, -1, -1);
}

void
gtk_extext_set_pseudo_select (GtkExText * text, gint start, gint end)
{
    if (start == end)
        text->pseudo_select = FALSE;
    else
        text->pseudo_select = TRUE;
    text->pseudo_start = start;
    text->pseudo_end = end;
}

static gint
gtk_extext_expose (GtkWidget * widget, GdkEventExpose * event)
{
    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    g_return_val_if_fail (event != NULL, FALSE);

    if (event->window == GTK_EXTEXT (widget)->text_area)
        expose_text (GTK_EXTEXT (widget), &event->area, TRUE);
    else
        gtk_widget_draw_focus (widget);
    return (FALSE);
}

static gint
gtk_extext_queue_draw (GtkWidget * widget)
{
    GdkRectangle rect;
    gint w, h;

    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    rect.x = 0;
    rect.y = 0;
    gdk_window_get_size (GTK_EXTEXT (widget)->text_area, &w, &h);
    rect.width = w;
    rect.height = h;
    expose_text (GTK_EXTEXT (widget), &rect, TRUE);
    gtk_widget_draw_focus (widget);
    return (FALSE);
}

GtkType
gtk_extext_get_type (void)
{
    static GtkType extext_type = 0;

    if (!extext_type) {
        static const GtkTypeInfo extext_info = {
            "GtkExText",
            sizeof (GtkExText),
            sizeof (GtkExTextClass),
            (GtkClassInitFunc) gtk_extext_class_init,
            (GtkObjectInitFunc) gtk_extext_init,
            NULL,
            NULL,
            (GtkClassInitFunc) NULL,
        };

        extext_type = gtk_type_unique (GTK_TYPE_WIDGET, &extext_info);
    }
    return extext_type;
}

/*****************************************************************************/
/*                               Public USER API                                 */
/*****************************************************************************/

void
gtk_extext_insert (GtkExText * text, const gchar * chars, gint length)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    gtk_extext_insert_with_style (text, chars, length, NULL, NULL);
}

void
gtk_extext_insert_with_style (GtkExText * text, const gchar * chars,
                              gint length, gchar * stylekey, gpointer userdata)
{
    gint pos;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    pos = text->current_pos;
    if (length == -1)
        length = strlen (chars);

    gtk_extext_insert_text (text, chars, length, &pos);

    if (stylekey)
        gtk_extext_property_insert (text, stylekey, pos - length, pos, userdata,
                                    PROPERTY_MERGE,
                                    text->scroll_line_start->property_first);
}

GtkExTextLineData *
gtk_extext_get_first_visible_line (GtkExText * text)
{
    GtkExTextLineData *cur;

    g_return_val_if_fail (text != NULL, NULL);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);

    cur = g_malloc (sizeof (GtkExTextLineData));
    memcpy (cur, text->scroll_line_start, sizeof (GtkExTextLineData));
    return cur;
}

GtkExTextLineData *
gtk_extext_get_line_init (GtkExText * text, gint line)
{
    GtkExTextLineData *cur;

    g_return_val_if_fail (text != NULL, NULL);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);


    cur = g_malloc0 (sizeof (GtkExTextLineData));
    if (line <= (gint) (text->line_count / 2)) {
        cur->lineptr = text->line_start;
        cur->endpos = LINE_DATA_LENGTH (cur);
    } else {
        cur->lineptr = text->line_end;
        cur->startpos = text->length - LINE_DATA_LENGTH (cur);
        cur->endpos = text->length;
        cur->line_number = text->line_count;
    }
    return cur;
}

GtkExTextLineData *
gtk_extext_get_line_data (GtkExText * text, gint newline,
                          GtkExTextLineData * cur)
{
    g_return_val_if_fail (text != NULL, NULL);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);

    if (cur && cur == text->scroll_line_start) {
        cur = g_malloc (sizeof (GtkExTextLineData));
        memcpy (cur, text->scroll_line_start, sizeof (GtkExTextLineData));
    } else if (cur && !cur->lineptr) {
        memset (cur, 0, sizeof (GtkExTextLineData));
        cur->lineptr = text->line_start;
        cur->startpos = 0;
        cur->endpos = LINE_DATA_LENGTH (cur);
    } else if (!cur) {
        cur = gtk_extext_get_line_init (text, newline);
        cur->property_first = NULL;
    }
    /* optimize start from begin/pos/end */
    /*and make sure user dont request line out of range */
    /* if request minus 0 set to first line */
    /* if request more than last line set to endline */
    if (newline <= 0
        || (newline < cur->line_number
            && cur->line_number - newline > (text->line_count / 2))) {
        cur->line_number = 0;
        cur->lineptr = text->line_start;
        cur->startpos = 0;
        cur->endpos = LINE_DATA_LENGTH (cur);
        cur->property_first = NULL;
    } else if (newline >= text->line_count
               || (newline > cur->line_number
                   && newline - cur->line_number > (text->line_count / 2))) {
        cur->line_number = text->line_count;
        cur->lineptr = text->line_end;
        cur->startpos = text->length - LINE_DATA_LENGTH (cur);
        cur->endpos = text->length;
        cur->property_first = NULL;
    }
    /* make sure dont loop if user request out range */
    if (newline > cur->line_number && newline < text->line_count) {
        while (cur->lineptr) {
            if (newline == cur->line_number)
                break;
            cur->startpos += LINE_DATA_LENGTH (cur);
            cur->line_number++;
            if (newline == cur->line_number)
                cur->property_first =
                    gtk_extext_property_nearest_backward (text, cur->startpos,
                                                          cur->property_first);
            cur->lineptr = LINE_DATA_NEXT (cur);
            cur->endpos += LINE_DATA_LENGTH (cur);
        }
    } else if (newline < cur->line_number && newline >= 0) {
        while (cur->lineptr) {
            if (newline == cur->line_number)
                break;
            cur->endpos -= LINE_DATA_LENGTH (cur);
            cur->line_number--;
            if (newline == cur->line_number)
                cur->property_first =
                    gtk_extext_property_nearest_backward (text, cur->startpos,
                                                          cur->property_first);
            cur->lineptr = LINE_DATA_PREV (cur);
            cur->startpos -= LINE_DATA_LENGTH (cur);
        }
    }

    cur->property_first =
        gtk_extext_property_nearest_backward (text, cur->startpos,
                                              cur->property_first);
    if (!cur->property_first)
        LINE_DATA_HEIGHT (cur) =
            TEXT_STYLE_HEIGHT (gtk_extext_style_get (text, "Default"));
    else
        LINE_DATA_HEIGHT (cur) = extext_get_line_height (text, cur);
    if (!cur->lineptr)
        g_warning ("WHAT THE FUCK? THIS SHOULD NEVER HAPPEN!\n");
    if (cur && cur->endpos > text->length)
        cur->endpos = text->length;
    return cur;
}

gboolean
gtk_extext_get_line_data_prev (GtkExText * text, GtkExTextLineData * cur)
{
    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);
    if (cur == NULL)
        return (FALSE);
    if (cur->line_number == 0)
        return (FALSE);

    cur->startpos = cur->endpos;
    cur->line_number--;
    cur->property_first =
        gtk_extext_property_nearest_backward (text, cur->startpos,
                                              cur->property_first);
    cur->lineptr = LINE_DATA_PREV (cur);
    cur->endpos = cur->startpos + LINE_DATA_LENGTH (cur);
    if (cur->endpos > text->length)
        cur->endpos = text->length;
    return (TRUE);
}

gboolean
gtk_extext_get_line_data_next (GtkExText * text, GtkExTextLineData * cur)
{
    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);
    if (cur == NULL)
        return (FALSE);
    if (cur->line_number == text->line_count)
        return (FALSE);

    cur->startpos = cur->endpos;
    cur->line_number++;
    cur->property_first =
        gtk_extext_property_nearest_backward (text, cur->startpos,
                                              cur->property_first);
    cur->lineptr = LINE_DATA_NEXT (cur);
    cur->endpos = cur->startpos + LINE_DATA_LENGTH (cur);
    if (cur->endpos > text->length)
        cur->endpos = text->length;
    return (TRUE);
}

void
gtk_extext_set_use_spaces (GtkExText * text, gboolean spaces)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->use_spaces = spaces;
}

gpointer
gtk_extext_get_line_userdata (GtkExText * text, gint line)
{
    gpointer userdata = NULL;
    GtkExTextLineData *linedata = NULL;

    g_return_val_if_fail (text != NULL, NULL);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);
    g_return_val_if_fail (line >= 0, NULL);
    g_return_val_if_fail (line <= text->line_count, NULL);

    linedata = gtk_extext_get_line_data (text, line, NULL);
    if (linedata && linedata->lineptr)
        userdata = linedata->lineptr->user_data;

    g_free (linedata);

    return userdata;
}

void
gtk_extext_set_line_userdata (GtkExText * text, gint line, gpointer userdata)
{
    GtkExTextLineData *linedata;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    g_return_if_fail (line >= 0);
    g_return_if_fail (line <= text->line_count);

    linedata = gtk_extext_get_line_data (text, line, NULL);
    if (linedata && linedata->lineptr)
        linedata->lineptr->user_data = userdata;
    g_free (linedata);
}

void
gtk_extext_set_line_pixmap (GtkExText * text, gint line, GdkPixmap * pixmap,
                            GdkBitmap * mask)
{
    GtkExTextLineData *linedata;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    g_return_if_fail (line >= 0);
    g_return_if_fail (line <= text->line_count);

    linedata = gtk_extext_get_line_data (text, line, NULL);
    if (linedata && linedata->lineptr) {
        linedata->lineptr->pixmap = pixmap;
        linedata->lineptr->mask = mask;
    }
    g_free (linedata);
}

gboolean
gtk_extext_get_line_pixmap (GtkExText * text, gint line, GdkPixmap ** pixmap,
                            GdkBitmap ** mask)
{
    gboolean retval = FALSE;
    GtkExTextLineData *linedata;

    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);
    g_return_val_if_fail (line >= 0, FALSE);
    g_return_val_if_fail (line <= text->line_count, FALSE);

    linedata = gtk_extext_get_line_data (text, line, FALSE);
    if (linedata && linedata->lineptr) {
        *pixmap = linedata->lineptr->pixmap;
        *mask = linedata->lineptr->mask;
        retval = TRUE;
    } else {
        *pixmap = NULL;
        *mask = NULL;
    }
    g_free (linedata);
    return (retval);
}

gint
gtk_extext_set_line (GtkExText * text, gint line)
{
    GtkExTextLineData *linedata;

    g_return_val_if_fail (text != NULL, -1);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), -1);
    goto_line (text, line, FALSE, FALSE, FALSE);
    if (text->select_line) {
        linedata =
            gtk_extext_get_line_data (text, text->line_number,
                                      text->scroll_line_start);
        if (linedata) {
            gtk_extext_select_region (text, linedata->startpos,
                                      linedata->endpos);
            g_free (linedata);
        }
    } else
        gtk_widget_queue_draw (GTK_WIDGET (text));
    return text->line_number;
}

gint
gtk_extext_set_column (GtkExText * text, gint col)
{
    g_return_val_if_fail (text != NULL, -1);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), -1);
    col = line_set_cursor_pos (text, col);
    gtk_widget_queue_draw (GTK_WIDGET (text));
    return col;
}

gint
gtk_extext_get_line (GtkExText * text)
{
    g_return_val_if_fail (text != NULL, -1);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), -1);
    return text->line_number;
}

gint
gtk_extext_get_column (GtkExText * text)
{
    g_return_val_if_fail (text != NULL, -1);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), -1);
    return text->column_number;
}

gint
gtk_extext_get_abs_column (GtkExText * text, gint pos)
{
    gint retval = 0;
    gchar *string = NULL;
    GtkExTextLineData *linedata;

    linedata = gtk_extext_get_line_by_char_pos (text, pos, NULL);
    if (pos > linedata->startpos)
        string =
            text_get_text_with_expanded_tabs (text, linedata->startpos,
                                              linedata->startpos, pos, NULL,
                                              &retval);
    if (!string)
        retval = 0;
    else
        retval += strlen (string);
    g_free (linedata);
    g_free (string);
    return (retval);
}

gint
gtk_extext_get_next_tab_stop (GtkExText * text, gint pos)
{
    gint retval = 0;
    gint spaces;
    gchar *string = NULL;
    GtkExTextLineData *linedata;

    if (!text->tab_stops)
        return (text->default_tab_width);

    linedata = gtk_extext_get_line_by_char_pos (text, pos, NULL);
    if (pos > linedata->startpos)
        string =
            text_get_text_with_expanded_tabs (text, linedata->startpos,
                                              linedata->startpos, pos, NULL,
                                              &spaces);
    if (!string)
        spaces = 0;
    else
        spaces += strlen (string);
    g_free (linedata);
    g_free (string);
    if (spaces)
        retval = text->default_tab_width - (spaces % text->default_tab_width);
    else
        retval = text->default_tab_width;
    return (retval);
}

void
gtk_extext_freeze (GtkExText * text)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->freeze_count++;
}

void
gtk_extext_thaw (GtkExText * text)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    text->freeze_count = 0;
    goto_line (text, text->line_number, FALSE, TRUE, FALSE);
    gtk_widget_queue_draw (GTK_WIDGET (text));
}

/* Undo/Redo Code by Chicane */
/* uses a GList with an int that represents the current level in the undo list */

gboolean
gtk_extext_remove_undo_entry (GtkExText * text, guint level)
{
    GtkExTextUndoEntry *entry;
    gboolean removed = FALSE;

    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (g_list_length (text->undo_redo) > 0, FALSE);
    entry = g_list_nth_data (text->undo_redo, level);
    if (entry) {
        if (entry->text)
            g_free (entry->text);
        text->undo_redo = g_list_remove (text->undo_redo, entry);
        g_free (entry);
        removed = TRUE;
        //g_print("Undo entry removed.\n");
    }
    return (removed);
}

gboolean
gtk_extext_undo (GtkExText * text)
{
    GtkExTextUndoEntry *entry;
    gint length;
    gint start;
    gchar *txt;

    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);

    length = g_list_length (text->undo_redo);
    if ((length < 1) || (length == text->undo_level))
        return (FALSE);
    text->undo_flag = TRUE;
    entry = g_list_nth_data (text->undo_redo, text->undo_level);
    if (entry->insert) {
        text->has_selection = FALSE;
        text->selection_start_pos = -1;
        text->selection_end_pos = -1;
        start = entry->start;
        //g_print("Undo: Inserting chars: %s.\n", entry->text);
        gtk_extext_insert_text (text, entry->text, entry->length, &start);
        gtk_extext_set_position (text, start);
        g_free (entry->text);
        entry->text = NULL;
        entry->insert = FALSE;
    } else {
        text->has_selection = FALSE;
        text->selection_start_pos = -1;
        text->selection_end_pos = -1;
        txt =
            gtk_extext_get_chars (text, entry->start,
                                  entry->start + entry->length);
        gtk_extext_delete_text (text, entry->start,
                                entry->start + entry->length);
        gtk_extext_set_position (text, entry->start);
        entry->text = txt;
        entry->insert = TRUE;
        //g_print("Undo: Removed chars: %s (%d-%d)\n", txt, entry->start, entry->start + entry->length);
    }
    text->undo_level++;
    text->undo_flag = FALSE;
    gtk_signal_emit (GTK_OBJECT (text), extext_signals[UNDO_CHANGED]);
    return (TRUE);
}

gboolean
gtk_extext_redo (GtkExText * text)
{
    GtkExTextUndoEntry *entry;
    gint length;
    gint start;
    gchar *txt;

    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);

    length = g_list_length (text->undo_redo);
    if ((length < 1) || (text->undo_level < 1))
        return (FALSE);
    text->undo_flag = TRUE;
    text->undo_level--;
    entry = g_list_nth_data (text->undo_redo, text->undo_level);
    if (entry->insert) {
        text->has_selection = FALSE;
        text->selection_start_pos = -1;
        text->selection_end_pos = -1;

        //g_print("Redo: Inserting chars: %s.\n", entry->text);
        start = entry->start;
        gtk_extext_insert_text (text, entry->text, entry->length, &start);
        gtk_extext_set_position (text, start);
        g_free (entry->text);
        entry->text = NULL;
        entry->insert = FALSE;
    } else {
        text->has_selection = FALSE;
        text->selection_start_pos = -1;
        text->selection_end_pos = -1;
        txt =
            gtk_extext_get_chars (text, entry->start,
                                  entry->start + entry->length);
        gtk_extext_delete_text (text, entry->start,
                                entry->start + entry->length);
        gtk_extext_set_position (text, entry->start);
        entry->text = txt;
        entry->insert = TRUE;
        //g_print("Redo: Removed chars: %s (%d-%d)\n", txt, entry->start, entry->start + entry->length);
    }
    text->undo_flag = FALSE;
    gtk_signal_emit (GTK_OBJECT (text), extext_signals[UNDO_CHANGED]);
    return (TRUE);
}

void
extext_undo_insert (GtkExText * text, guint start, guint length,
                    gboolean insertion)
{
    GtkExTextUndoEntry *entry;
    gint remove;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    if (text->undo_flag)
        return;

    if (text->undo_level > 0) {
        for (remove = 0; remove < text->undo_level; remove++)
            gtk_extext_remove_undo_entry (text, 0);
    }
    entry = g_new (GtkExTextUndoEntry, 1);
    entry->insert = insertion;
    if (insertion)
        entry->text = gtk_extext_get_chars (text, start, start + length);
    else
        entry->text = NULL;
    entry->start = start;
    entry->length = length;
    text->undo_redo = g_list_prepend (text->undo_redo, (gpointer) entry);
    if (g_list_length (text->undo_redo) > text->undo_max)
        gtk_extext_remove_undo_entry (text,
                                      g_list_length (text->undo_redo) - 1);
    text->undo_level = 0;
    gtk_signal_emit (GTK_OBJECT (text), extext_signals[UNDO_CHANGED]);
}

gboolean
gtk_extext_undo_is_empty (GtkExText * text)
{
    gboolean empty = TRUE;

    g_return_val_if_fail (text != NULL, TRUE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), TRUE);
    if (g_list_length (text->undo_redo) > 0
        && text->undo_level < g_list_length (text->undo_redo))
        empty = FALSE;
    return (empty);
}

gboolean
gtk_extext_redo_is_empty (GtkExText * text)
{
    gboolean empty = TRUE;

    g_return_val_if_fail (text != NULL, TRUE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), TRUE);
    if (g_list_length (text->undo_redo) > 0 && text->undo_level > 0)
        empty = FALSE;
    return (empty);
}

gint
gtk_extext_undo_get_max (GtkExText * text)
{
    g_return_val_if_fail (text != NULL, 0);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), 0);

    return text->undo_max;
}

gboolean
gtk_extext_undo_set_max (GtkExText * text, gint max)
{
    gboolean discarded = FALSE;

    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);

    if (max < 0)
        return (discarded);
    if (max >= text->undo_max)
        text->undo_max = max;
    else {
        while (g_list_length (text->undo_redo) > max) {
            gtk_extext_remove_undo_entry (text,
                                          g_list_length (text->undo_redo) - 1);
        }
        text->undo_max = max;
        discarded = TRUE;
        gtk_signal_emit (GTK_OBJECT (text), extext_signals[UNDO_CHANGED]);
    }
    return (discarded);
}

void
gtk_extext_undo_clear_all (GtkExText * text)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (text->undo_redo) {
        while (g_list_length (text->undo_redo) > 0) {
            gtk_extext_remove_undo_entry (text,
                                          g_list_length (text->undo_redo) - 1);
        }
        g_list_free (text->undo_redo);
        text->undo_redo = NULL;
        text->undo_level = 0;
    }
    if (GTK_WIDGET_REALIZED (text))
        gtk_signal_emit (GTK_OBJECT (text), extext_signals[UNDO_CHANGED]);
}

gint
gtk_extext_get_length (GtkExText * text)
{
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);
    return text->length;
}

void
gtk_extext_set_draw_numbers (GtkExText * text, gboolean draw)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->draw_numbers = draw ? TRUE : FALSE;
    if (draw && text->font) {
        text->number_width = get_line_number_width (text);
        text->number_width += TEXT_BORDER_ROOM * 2;
    } else
        text->number_width = 0;
    text->gutter_width = text->number_width + text->pixmap_max_width;
}

static gint
get_line_number_width (GtkExText * text)
{
    gchar *lines;
    gint chars = 1;
    gint compare = 9;
    gint width = 0;

    while (compare < text->line_count + 1) {
        chars++;
        compare *= 10;
        compare += 9;
    }
    lines = g_new0 (char, chars + 2);

    memset (lines, '0', chars);
    lines[chars] = ':';
    width = gdk_string_width (text->font, lines);
    g_free (lines);
    return (width);
}

void
gtk_extext_set_popup_menu (GtkExText * text, GtkWidget * w, GtkWidget * marg)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->text_popupmenu = w;
    text->margin_popupmenu = marg;
}

void
gtk_extext_set_draw_pixmaps (GtkExText * text, gboolean draw)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->draw_pixmaps = draw ? TRUE : FALSE;
    if (draw) {
        text->pixmap_max_width = 16;
        text->pixmap_max_width += TEXT_BORDER_ROOM * 2;
    } else
        text->pixmap_max_width = 0;
    text->gutter_width = text->number_width + text->pixmap_max_width;
}

void
gtk_extext_set_pixmap_size (GtkExText * text, gint size)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    if (size >= 0 && size <= 32) {
        text->pixmap_max_width = size;
        text->pixmap_max_width += TEXT_BORDER_ROOM * 2;
    }
    text->gutter_width = text->number_width + text->pixmap_max_width;
}

void
gtk_extext_set_select_line (GtkExText * text, gboolean select)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->select_line = select ? TRUE : FALSE;
    return;
}

void
gtk_extext_set_cursor_blink (GtkExText * text, gboolean blink)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->cursor_blink = blink ? TRUE : FALSE;
    if (text->cursor_blink) {
        if (text->cursor_timer)
            gtk_timeout_remove (text->cursor_timer);
        text->cursor_timer =
            gtk_timeout_add (CURSOR_TIMEOUT, gtk_extext_cursor_blink, text);
    } else {
        if (text->cursor_timer)
            gtk_timeout_remove (text->cursor_timer);
        text->cursor_timer = 0;
    }
}

void
gtk_extext_set_draw_cursor (GtkExText * text, gboolean draw)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->draw_cursor = draw ? TRUE : FALSE;
    if (text->draw_cursor) {
        gtk_widget_queue_draw (GTK_WIDGET (text));
    }
    return;
}

void
gtk_extext_set_full_selection (GtkExText * text, gboolean full)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->full_selection = full ? TRUE : FALSE;
    return;
}

void
gtk_extext_set_show_newlines (GtkExText * text, gboolean show)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->show_newlines = show ? TRUE : FALSE;
    return;
}

void
gtk_extext_set_show_whitespace (GtkExText * text, gboolean show)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->show_whitespace = show ? TRUE : FALSE;
    return;
}

gint
gtk_extext_get_tab_width (GtkExText * text)
{
    g_return_val_if_fail (GTK_IS_EXTEXT (text), -1);
    return text->default_tab_width;
}

void
gtk_extext_set_tab_width (GtkExText * text, gint width)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->default_tab_width = width > 0
        && width <= 10 ? width : DEFAULT_TAB_STOP;
}

void
gtk_extext_set_use_tab_stops (GtkExText * text, gboolean tab_stops)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->tab_stops = tab_stops ? TRUE : FALSE;
}

void
gtk_extext_insert_text (GtkExText * text,
                        const gchar * new_text, gint new_len, gint * position)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (!text->editable)
        return;

    if (text->selection_start_pos != -1 && text->selection_end_pos != -1) {
        gint start;
        gint end;

        start = text->selection_start_pos;
        end = text->selection_end_pos;
        text->has_selection = FALSE;
        text->selection_start_pos = -1;
        text->selection_end_pos = -1;
        gtk_extext_delete_text (text, start, end);
        *position = text->current_pos = start;
    }
    *position =
        text_insert (text, *position, (gchar *) new_text, new_len, TRUE);
    text->vadj->upper = text->line_count;
    if (text->scroll_line_count)
        text->vadj->page_size = text->line_count / text->scroll_line_count;

    gtk_adjustment_changed (text->vadj);
    gtk_signal_emit (GTK_OBJECT (text), extext_signals[CHANGED]);
    gtk_signal_emit (GTK_OBJECT (text), extext_signals[INSERT_TEXT],
                     (gchar *) new_text, new_len, &text->current_pos);
    gtk_widget_queue_draw (GTK_WIDGET (text));
}

void
gtk_extext_delete_text (GtkExText * text, gint startpos, gint endpos)
{
    gint oldlinecount;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (!text->editable)
        return;

    oldlinecount = text->line_count;
    if (text->selection_start_pos != text->selection_end_pos
        && text->selection_start_pos != -1)
        text_remove (text, text->selection_start_pos,
                     text->selection_end_pos - text->selection_start_pos);
    else
        text_remove (text, startpos, endpos - startpos);

    if (oldlinecount != text->line_count) {
        text->vadj->upper = text->line_count;
        if (text->scroll_line_count)
            text->vadj->page_size = text->line_count / text->scroll_line_count;
        if (text->scroll_line_start->line_number < text->vadj->value)
            text->vadj->value = text->scroll_line_start->line_number;
        gtk_adjustment_changed (text->vadj);
    }
    gtk_signal_emit (GTK_OBJECT (text), extext_signals[CHANGED]);
    gtk_signal_emit (GTK_OBJECT (text), extext_signals[DELETE_TEXT],
                     startpos, endpos);
    gtk_widget_queue_draw (GTK_WIDGET (text));
}

gchar *
gtk_extext_get_chars (GtkExText * text, gint start, gint end)
{
    g_return_val_if_fail (text != NULL, NULL);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), NULL);
    return text_get_text_no_replace (text, start, end);
}

void
gtk_extext_set_editable (GtkExText * text, gboolean r)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->editable = r;
}

gboolean
gtk_extext_get_editable (GtkExText * text)
{
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);
    return text->editable;
}

void
gtk_extext_set_position (GtkExText * text, gint pos)
{
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text_set_pos (text, pos);
    goto_line (text, text->line_number, FALSE, TRUE, FALSE);
    gtk_widget_queue_draw (GTK_WIDGET (text));
}

gint
gtk_extext_get_position (GtkExText * text)
{
    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);
    return text->current_pos;
}

/*****************************************************************************/
/*                              Search functions                                */
/*****************************************************************************/

gboolean
gtk_extext_search (GtkExText * text, gchar * search, gint pos,
                   gboolean iscase, gboolean forward, GtkExTextMatch * m)
{
    guchar *txt;
    gint len;
    gint found;

    g_return_val_if_fail (pos <= text->length, FALSE);
    g_return_val_if_fail (pos > -1, FALSE);
    g_return_val_if_fail (m != NULL, FALSE);

    m->startpos = m->endpos = 0;
    txt = text->text;
    len = strlen (search);
    if (!forward) {
        g_warning ("SEARCH BACKWARD NOT YET IMPLEMENTED\n");
        return (FALSE);
    }

    while (pos <= text->length - len) {
        if (pos + len > text->part1len && txt == text->text) {
            gint i = 0;

            txt = gtk_extext_get_chars (text, pos, pos + len);
            while (pos < text->part1len) {
                found =
                    iscase ? strncmp (&txt[i], search,
                                      len) : g_strncasecmp (&txt[i], search,
                                                            len);
                if (!found) {
                    g_free (txt);
                    m->startpos = pos;
                    m->endpos = pos + len;
                    return (TRUE);
                }
                pos++;
                i++;
            }
            g_free (txt);
            txt = text->part2text;
        } else {
            found =
                iscase ? strncmp (&txt[pos], search,
                                  len) : g_strncasecmp (&txt[pos], search, len);
            if (!found) {
                m->startpos = pos;
                m->endpos = pos + len;
                return TRUE;
            }
            pos++;
        }
    }
    return FALSE;
}

/*****************************************************************************/
/*                                  Regex API                                    */
/* 	stolen from GtkEditor by Thomas Mailund */
/*****************************************************************************/

/* arch -- searches for regex in text from position
 * 'start'. If 'forward' is TRUE, it searches forward, otherwise
 * backwards.  If  found, returns index of beginning of the match,
 * otherwise returns < 0.  If found the match interval is
 * [m.from,m.to[.  m.from is always equal to the return value, but
 * m.to is undefined if no match.  I search in GtkSCText, since I don't
 * really need an editor for this function. This will also make it
 * easier to move this function to the text widget, should we want
 * that. */
gint
gtk_extext_regex_search (GtkExText * text, gint start, Regex * regex,
                         gboolean forward, GtkExTextMatch * m)
{
    g_return_val_if_fail (start <= text->length, -1);
    g_return_val_if_fail (regex != NULL, -1);
    g_return_val_if_fail (m != NULL, -1);

    m->startpos = re_search_2 (&regex->buf,
                               /* text before gap */
                               text->text, text->part1len,
                               /* text after gap */
                               &text->part2text[text->part1len],
                               text->length - text->part1len + 1,
                               /* from 'start' and forward to the end */
                               start,
                               (forward ? text->length - start :
                                -start), &regex->reg, text->length);

    if (m->startpos > -1)
        m->endpos = regex->reg.end[0];

    return m->startpos;
}

/* regex_match -- tries to match regex at the 'pos' position in the
 * text. It returns the number of chars matched, or -1 if no match.
 * Warning!  The number matched can be 0, if the regex matches the
 * empty string.  The reason for workin on GtkSCText is the same as in
 * regex_search. */
gint
gtk_extext_regex_match (GtkExText * text, gint pos, Regex * regex)
{
    g_return_val_if_fail (pos <= text->length, -1);
    g_return_val_if_fail (regex != NULL, -1);

    return re_match_2 (&regex->buf,
                       /* text before gap */
                       text->text, text->part1len,
                       /* text after gap */
                       &text->part2text[text->part1len],
                       text->length - text->part1len + 1,
                       /* from pos and not after the end */
                       pos, &regex->reg, text->length);
}


/* Deal with selection stuff */

static gint
gtk_extext_selection_clear (GtkWidget * widget, GdkEventSelection * event)
{
    GtkExText *text;

    g_return_val_if_fail (widget != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (widget), FALSE);
    g_return_val_if_fail (event != NULL, FALSE);

    /* Let the selection handling code know that the selection
     * has been changed, since we've overriden the default handler */
    if (!gtk_selection_clear (widget, event))
        return FALSE;

    text = GTK_EXTEXT (widget);

    if (event->selection == GDK_SELECTION_PRIMARY) {
        if (text->has_selection) {
            text->has_selection = FALSE;
            gtk_widget_queue_draw (widget);
        }
    } else if (event->selection == clipboard_atom) {
        g_free (text->clipboard_text);
        text->clipboard_text = NULL;
    }

    return TRUE;
}

static void
gtk_extext_selection_received (GtkWidget * widget,
                               GtkSelectionData * selection_data, guint time)
{
    GtkExText *text;
    gint reselect;
    gint old_pos;
    gint tmp_pos;
    enum { INVALID, STRING, CTEXT } type;

    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));

    text = GTK_EXTEXT (widget);

    if (selection_data->type == GDK_TARGET_STRING)
        type = STRING;
    else if ((selection_data->type == gdk_atom_intern ("COMPOUND_TEXT", FALSE))
             || (selection_data->type == gdk_atom_intern ("TEXT", FALSE)))
        type = CTEXT;
    else
        type = INVALID;

    if (type == INVALID || selection_data->length < 0) {
        /* avoid infinite loop */
        if (selection_data->target != GDK_TARGET_STRING)
            gtk_selection_convert (widget, selection_data->selection,
                                   GDK_TARGET_STRING, time);
        return;
    }

    reselect = FALSE;

    if ((text->selection_start_pos != text->selection_end_pos) &&
        (!text->has_selection ||
         (selection_data->selection == clipboard_atom))) {
        reselect = TRUE;

        /* Don't want to call gtk_extext_delete_selection here if we are going
         * to reclaim the selection to avoid extra server traffic */
        if (text->has_selection) {
            gtk_extext_delete_text (text,
                                    MIN (text->selection_start_pos,
                                         text->selection_end_pos),
                                    MAX (text->selection_start_pos,
                                         text->selection_end_pos));
        } else
            gtk_extext_delete_selection (text);
    }

    tmp_pos = old_pos = text->current_pos;

    switch (type) {
    case STRING:
        selection_data->data[selection_data->length] = 0;
        gtk_extext_insert_text (text, (gchar *) selection_data->data,
                                strlen ((gchar *) selection_data->data),
                                &tmp_pos);
        text->current_pos = tmp_pos;
        break;
    case CTEXT:
        {
            gchar **list;
            gint count;
            gint i;

            count = gdk_text_property_to_text_list (selection_data->type,
                                                    selection_data->format,
                                                    selection_data->data,
                                                    selection_data->length,
                                                    &list);

            for (i = 0; i < count; i++) {
                gtk_extext_insert_text (text, list[i], strlen (list[i]),
                                        &tmp_pos);
                text->current_pos = tmp_pos;
            }
            if (count > 0)
                gdk_free_text_list (list);
        }
        break;
    case INVALID:              /* quiet compiler */
        break;
    }

    if (reselect)
        gtk_extext_set_selection (text, old_pos, text->current_pos);
}

static void
gtk_extext_selection_get (GtkWidget * widget,
                          GtkSelectionData * selection_data,
                          guint info, guint time)
{
    GtkExText *text;
    gint selection_start_pos;
    gint selection_end_pos;

    gchar *str;
    gint length;

    g_return_if_fail (widget != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (widget));
    text = GTK_EXTEXT (widget);

    if (selection_data->selection == GDK_SELECTION_PRIMARY) {
        selection_start_pos =
            MIN (text->selection_start_pos, text->selection_end_pos);
        selection_end_pos =
            MAX (text->selection_start_pos, text->selection_end_pos);
        str =
            gtk_extext_get_chars (text, selection_start_pos, selection_end_pos);
        if (!str)
            return;             /* Refuse */
        length = strlen (str);
    } else {                    /* CLIPBOARD */

        if (!text->clipboard_text)
            return;             /* Refuse */

        str = text->clipboard_text;
        length = strlen (text->clipboard_text);
    }

    if (info == TARGET_STRING) {
        gtk_selection_data_set (selection_data,
                                GDK_SELECTION_TYPE_STRING,
                                8 * sizeof (gchar), (guchar *) str, length);
    } else if ((info == TARGET_TEXT) || (info == TARGET_COMPOUND_TEXT)) {
        guchar *text;
        gchar c;
        GdkAtom encoding;
        gint format;
        gint new_length;

        c = str[length];
        str[length] = '\0';
        gdk_string_to_compound_text (str, &encoding, &format, &text,
                                     &new_length);
        gtk_selection_data_set (selection_data, encoding, format, text,
                                new_length);
        gdk_free_compound_text (text);
        str[length] = c;
    }

    if (str != text->clipboard_text)
        g_free (str);
}

void
gtk_extext_delete_selection (GtkExText * text)
{
    guint start;
    guint end;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (!text->editable)
        return;

    start = text->selection_start_pos;
    end = text->selection_end_pos;

    text->selection_start_pos = -1;
    text->selection_end_pos = -1;

    if (start != end)
        gtk_extext_delete_text (text, start, end);

    if (text->has_selection) {
        text->has_selection = FALSE;
        if (gdk_selection_owner_get (GDK_SELECTION_PRIMARY) ==
            GTK_WIDGET (text)->window)
            gtk_selection_owner_set (NULL, GDK_SELECTION_PRIMARY,
                                     GDK_CURRENT_TIME);
    }
}

static void
gtk_extext_claim_selection (GtkExText * text, gboolean claim, guint32 time)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    g_return_if_fail (GTK_WIDGET_REALIZED (text));
    text->has_selection = FALSE;

    if (claim) {
        if (gtk_selection_owner_set
            (GTK_WIDGET (text), GDK_SELECTION_PRIMARY, time))
            text->has_selection = TRUE;
    } else {
        if (gdk_selection_owner_get (GDK_SELECTION_PRIMARY) ==
            GTK_WIDGET (text)->window)
            gtk_selection_owner_set (NULL, GDK_SELECTION_PRIMARY, time);
    }
}

void
gtk_extext_select_region (GtkExText * text, gint start, gint end)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    if (GTK_WIDGET_REALIZED (text))
        gtk_extext_claim_selection (text, start != end, GDK_CURRENT_TIME);

    gtk_extext_set_selection (text, start, end);
}

static void
gtk_extext_set_selection (GtkExText * text, gint start, gint end)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->selection_start_pos = start;
    text->selection_end_pos = end;
    text->has_selection = start != end ? TRUE : FALSE;
    gtk_widget_queue_draw (GTK_WIDGET (text));
}

static guint32
gtk_extext_get_event_time (GtkExText * text)
{
    GdkEvent *event;
    guint32 tm = GDK_CURRENT_TIME;

    event = gtk_get_current_event ();

    if (event) {
        switch (event->type) {
        case GDK_MOTION_NOTIFY:
            tm = event->motion.time;
            break;
        case GDK_BUTTON_PRESS:
        case GDK_2BUTTON_PRESS:
        case GDK_3BUTTON_PRESS:
        case GDK_BUTTON_RELEASE:
            tm = event->button.time;
            break;
        case GDK_KEY_PRESS:
        case GDK_KEY_RELEASE:
            tm = event->key.time;
            break;
        case GDK_ENTER_NOTIFY:
        case GDK_LEAVE_NOTIFY:
            tm = event->crossing.time;
            break;
        case GDK_PROPERTY_NOTIFY:
            tm = event->property.time;
            break;
        case GDK_SELECTION_CLEAR:
        case GDK_SELECTION_REQUEST:
        case GDK_SELECTION_NOTIFY:
            tm = event->selection.time;
            break;
        case GDK_PROXIMITY_IN:
        case GDK_PROXIMITY_OUT:
            tm = event->proximity.time;
            break;
        default:               /* use current time */
            break;
        }

        gdk_event_free (event);
    }

    return tm;
}

void
gtk_extext_cut_clipboard (GtkExText * text)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    gtk_extext_copy_clipboard (text);
    gtk_extext_delete_selection (text);
}

void
gtk_extext_copy_clipboard (GtkExText * text)
{
    guint32 time;
    gint selection_start_pos;
    gint selection_end_pos;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    time = gtk_extext_get_event_time (text);
    selection_start_pos =
        MIN (text->selection_start_pos, text->selection_end_pos);
    selection_end_pos =
        MAX (text->selection_start_pos, text->selection_end_pos);

    if (selection_start_pos != selection_end_pos) {
        if (gtk_selection_owner_set (GTK_WIDGET (text), clipboard_atom, time))
            text->clipboard_text = gtk_extext_get_chars (text,
                                                         selection_start_pos,
                                                         selection_end_pos);
    }
}

void
gtk_extext_paste_clipboard (GtkExText * text)
{
    guint32 time;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    time = gtk_extext_get_event_time (text);
    if (text->editable)
        gtk_selection_convert (GTK_WIDGET (text),
                               clipboard_atom,
                               gdk_atom_intern ("COMPOUND_TEXT", FALSE), time);
    text->has_selection = FALSE;
    text->selection_start_pos = -1;
    text->selection_end_pos = -1;
    gtk_widget_queue_draw (GTK_WIDGET (text));
}

void
gtk_extext_set_no_selection (GtkExText * text, gboolean draw)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    text->has_selection = FALSE;
    text->selection_start_pos = -1;
    text->selection_end_pos = -1;
    if (draw)
        gtk_widget_queue_draw (GTK_WIDGET (text));
}

/* Start of highlight code from GtkExText */
/* Start of highlight code from GtkExText */
/* Start of highlight code from GtkExText */
/* Start of highlight code from GtkExText */
/* Start of highlight code from GtkExText */

/* Public GtkExText highlighting functions */

void
gtk_extext_set_highlight (GtkExText * text, gboolean value)
{
    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));

    text->highlight = value;
    gtk_extext_property_remove_all (text, 0, text->length, NULL);
    if (text->highlight)
        check_syntax (text, 0, text->length);
}

void
gtk_extext_highlight (GtkExText * text)
{
    if (text->highlight) {
        gtk_extext_freeze (text);
        gtk_extext_property_remove_all (text, 0, text->length, NULL);
        check_syntax (text, 0, text->length);
        gtk_extext_thaw (text);
    }
}

gboolean
gtk_extext_compile_regex (const gchar * pattern, Regex * regex)
{
    memset (&regex->buf, 0, sizeof (regex->buf));
    regex->buf.translate = NULL;
    regex->buf.fastmap = g_malloc (256);
    regex->buf.allocated = 0;
    regex->buf.buffer = NULL;
    regex->buf.can_be_null = 0; /* so we wont allow that in patterns! */
    regex->buf.no_sub = 0;
    if (re_compile_pattern (pattern, strlen (pattern), &regex->buf) == 0) {
        if (re_compile_fastmap (&regex->buf) != 0) {
            g_warning ("GtkExText: REGEX FAILED TO CREATE FASTMAP\n");
            g_free (regex->buf.fastmap);
            regex->buf.fastmap = NULL;
        }
        return TRUE;
    } else {
        g_warning ("GtkExText: REGEX FAILED TO COMPILE\n");
        return FALSE;
    }
}

void
gtk_extext_install_table (GtkExText * text, GtkExTextHighlightTable * table)
{
    GList *cur;
    GtkExTextSyntaxEntry *sentry;
    GtkExTextPatternEntry *pentry;
    GtkExTextEmbeddedEntry *eentry;

    g_return_if_fail (text != NULL);
    g_return_if_fail (GTK_IS_EXTEXT (text));
    g_return_if_fail (table != NULL);

    if (table->type == SYNTAX_TABLE) {
        text->syntax_table = table;
        cur = g_list_first (table->entries);
        while (cur) {
            sentry = (GtkExTextSyntaxEntry *) cur->data;
            gtk_extext_style_insert (GTK_EXTEXT (text), sentry->key,
                                     sentry->font, sentry->color, sentry->bg,
                                     sentry->flags);
            cur = g_list_next (cur);
        }
    } else if (table->type == PATTERN_TABLE) {
        text->pattern_table = table;
        cur = g_list_first (table->entries);
        while (cur) {
            pentry = (GtkExTextPatternEntry *) cur->data;
            gtk_extext_style_insert (GTK_EXTEXT (text), pentry->key,
                                     pentry->font, pentry->color, pentry->bg,
                                     pentry->flags);
            cur = g_list_next (cur);
        }
    } else if (table->type == EMBEDDED_TABLE) {
        text->embedded_table = table;
        cur = g_list_first (table->entries);
        while (cur) {
            eentry = (GtkExTextEmbeddedEntry *) cur->data;
            gtk_extext_style_insert (GTK_EXTEXT (text), eentry->key,
                                     eentry->font, eentry->color, eentry->bg,
                                     eentry->flags);
            cur = g_list_next (cur);
        }
    } else {
        g_warning ("Table could not be inserted.\n");
    }
}

GtkExTextHighlightTable *
gtk_extext_syntax_table_new (GList * entries)
{
    gchar *regs;
    GList *cur;
    GtkExTextHighlightTable *table;
    GtkExTextSyntaxEntry *syntax;

    g_return_val_if_fail (entries != NULL, NULL);
    g_return_val_if_fail (g_list_length (entries), NULL);

    table = g_malloc0 (sizeof (GtkExTextHighlightTable));
    table->type = SYNTAX_TABLE;
    table->entries = entries;
    regs = g_malloc0 (1024);
    cur = g_list_first (entries);
    while (cur) {
        syntax = (GtkExTextSyntaxEntry *) cur->data;
        strcat (regs, syntax->start);
        cur = g_list_next (cur);
        if (cur)
            strcat (regs, "\\|");
    }
    gtk_extext_compile_regex (regs, &table->regex_all);
    g_free (regs);
    return (table);
}

GtkExTextHighlightTable *
gtk_extext_pattern_table_new (GList * entries)
{
    GtkExTextHighlightTable *table;

    g_return_val_if_fail (entries != NULL, NULL);
    g_return_val_if_fail (g_list_length (entries), NULL);

    table = g_malloc0 (sizeof (GtkExTextHighlightTable));
    table->type = PATTERN_TABLE;
    table->entries = entries;
    return (table);
}

GtkExTextHighlightTable *
gtk_extext_embedded_table_new (GList * entries)
{
    GtkExTextHighlightTable *table;

    g_return_val_if_fail (entries != NULL, NULL);
    g_return_val_if_fail (g_list_length (entries), NULL);

    table = g_malloc0 (sizeof (GtkExTextHighlightTable));
    table->type = EMBEDDED_TABLE;
    table->entries = entries;
    return (table);
}

GList *
gtk_extext_syntax_entry_new (GList * entries, gchar * name, gchar * start,
                             gchar * end, GdkColor * fg, GdkColor * bg,
                             GdkFont * font, guint16 flags, gpointer data)
{
    GtkExTextSyntaxEntry *syntax;

    syntax = g_malloc0 (sizeof (GtkExTextSyntaxEntry));
    syntax->start = g_strdup (start);
    strncpy (syntax->key, name, 32);
    syntax->font = font;
    syntax->color = fg;
    syntax->bg = bg;
    syntax->flags = flags;
    syntax->data = data;
    gtk_extext_compile_regex (start, &syntax->regex_start);
    gtk_extext_compile_regex (end, &syntax->regex_end);
    return (g_list_append (entries, syntax));
}


GList *
gtk_extext_pattern_entry_new (GList * entries, gchar * name, gchar * start,
                              GdkColor * fg, GdkColor * bg, GdkFont * font,
                              guint16 flags, gpointer data)
{
    GtkExTextPatternEntry *pattern;

    pattern = g_malloc0 (sizeof (GtkExTextPatternEntry));
    strncpy (pattern->key, name, 32);
    pattern->font = font;
    pattern->color = fg;
    pattern->bg = bg;
    pattern->flags = flags;
    pattern->data = data;
    gtk_extext_compile_regex (start, &pattern->regex);
    return (g_list_append (entries, pattern));
}

GList *
gtk_extext_embedded_entry_new (GList * entries, gchar * name, gchar * outside,
                               gchar * inside, GdkColor * fg, GdkColor * bg,
                               GdkFont * font, guint16 flags, gpointer data)
{
    GtkExTextEmbeddedEntry *embedded;

    embedded = g_malloc0 (sizeof (GtkExTextEmbeddedEntry));
    strncpy (embedded->key, name, 32);
    embedded->font = font;
    embedded->color = fg;
    embedded->bg = bg;
    embedded->flags = flags;
    embedded->data = data;
    gtk_extext_compile_regex (outside, &embedded->outside);
    gtk_extext_compile_regex (inside, &embedded->inside);
    return (g_list_append (entries, embedded));
}

void
gtk_extext_table_free (GtkExTextHighlightTable * table)
{
    GtkExTextSyntaxEntry *syntax;
    GtkExTextPatternEntry *pattern;
    GtkExTextEmbeddedEntry *embedded;
    GList *cur;

    for (cur = table->entries; cur; cur = cur->next) {
        if (table->type == SYNTAX_TABLE) {
            syntax = (GtkExTextSyntaxEntry *) cur->data;
            g_free (syntax->regex_start.buf.fastmap);
            syntax->regex_start.buf.fastmap = NULL;
            regfree (&syntax->regex_start.buf);
            g_free (syntax->regex_end.buf.fastmap);
            syntax->regex_end.buf.fastmap = NULL;
            regfree (&syntax->regex_end.buf);
        } else if (table->type == PATTERN_TABLE) {
            pattern = (GtkExTextPatternEntry *) cur->data;
            g_free (pattern->regex.buf.fastmap);
            pattern->regex.buf.fastmap = NULL;
            regfree (&pattern->regex.buf);
        }
        if (table->type == EMBEDDED_TABLE) {
            embedded = (GtkExTextEmbeddedEntry *) cur->data;
            g_free (embedded->outside.buf.fastmap);
            embedded->outside.buf.fastmap = NULL;
            regfree (&embedded->outside.buf);
            g_free (embedded->inside.buf.fastmap);
            embedded->inside.buf.fastmap = NULL;
            regfree (&embedded->inside.buf);
        }
        g_free (cur->data);
    }
    g_list_free (table->entries);
    g_free (table);
}

static gint
property_text_remove (GtkExText * text, GtkExTextProperty * prop, gint start,
                      gint end)
{
    GtkExTextLineData *slinedataptr, *elinedataptr;
    gint diff, e;

    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);
    if (!text->highlight)
        return FALSE;

    if (end > text->length) {
        gtk_extext_property_remove_all (text, text->length, end, NULL);
        end = text->length;
    }
    diff = end - start;
    e = end;
    /* If the whole text chunk was inside a highlight, parse from prop->start to prop->end */
    if ((prop = gtk_extext_property_get_at_pos (text, start, prop))
        && ((gint) prop->startpos <= start)
        && ((gint) (prop->endpos - diff) > start)) {
        start = prop->startpos;
        end = prop->endpos - diff > end ? prop->endpos - diff : end;
    }
    /* If the text chunk was after a SYNTAX_TABLE, parse from prop->start to line->end */
    else if ((prop = gtk_extext_property_nearest_backward (text, start, prop))
             && GPOINTER_TO_INT (prop->user_data) == SYNTAX_TABLE) {
        start = prop->startpos;
        elinedataptr = gtk_extext_get_line_by_char_pos (text, end, NULL);
        end = elinedataptr
            && elinedataptr->endpos > end ? elinedataptr->endpos : end;
        g_free (elinedataptr);
    }
    /* Else, parse from line1->start to line2->end */
    else {
        slinedataptr = gtk_extext_get_line_by_char_pos (text, start, NULL);
        start = slinedataptr
            && slinedataptr->startpos < start ? slinedataptr->startpos : start;
        g_free (slinedataptr);
        elinedataptr = gtk_extext_get_line_by_char_pos (text, end, NULL);
        end = elinedataptr
            && elinedataptr->endpos > end ? elinedataptr->endpos : end;
        g_free (elinedataptr);
    }
    //g_print("Remove Highlight - (%d, %d)\n", start, end);
    gtk_extext_property_move_all (text, e, -diff, prop);
    gtk_extext_property_remove_all (text, start, end, prop);
    check_embedded (text, start, end, prop);
    return (TRUE);
}

static gint
property_text_insert (GtkExText * text, GtkExTextProperty * prop, gint start,
                      gint end)
{
    gint diff, s;
    GtkExTextLineData *slinedataptr, *elinedataptr;

    g_return_val_if_fail (text != NULL, FALSE);
    g_return_val_if_fail (GTK_IS_EXTEXT (text), FALSE);
    if (!text->highlight)
        return (FALSE);

    s = start;
    diff = end - start;
    if ((prop = gtk_extext_property_get_at_pos (text, start, prop))
        && ((gint) prop->startpos < start)
        && ((gint) (prop->endpos + diff) >= end)) {
        start = prop->startpos;
        end =
            prop->endpos + diff <
            text->length ? prop->endpos + diff : text->length;
    } else if ((prop = gtk_extext_property_nearest_backward (text, start, prop))
               && GPOINTER_TO_INT (prop->user_data) == SYNTAX_TABLE) {
        start = prop->startpos;
        elinedataptr = gtk_extext_get_line_by_char_pos (text, end, NULL);
        end = elinedataptr
            && elinedataptr->endpos > end ? elinedataptr->endpos : end;
        g_free (elinedataptr);
    } else {
        slinedataptr = gtk_extext_get_line_by_char_pos (text, start, NULL);
        start = slinedataptr
            && slinedataptr->startpos < start ? slinedataptr->startpos : start;
        g_free (slinedataptr);
        elinedataptr = gtk_extext_get_line_by_char_pos (text, end, NULL);
        end = elinedataptr
            && elinedataptr->endpos > end ? elinedataptr->endpos : end;
        g_free (elinedataptr);
    }
    //g_print("Insert Highlight - (%d, %d)\n", start, end);
    gtk_extext_property_move_all (text, s, diff, prop);
    gtk_extext_property_remove_all (text, start, end, prop);
    check_embedded (text, start, end, prop);
    return (TRUE);
}

static void
check_embedded (GtkExText * text, gint start, gint end,
                GtkExTextProperty * prev)
{
    GtkExTextHighlightTable *table;
    GtkExTextEmbeddedEntry *embedded;
    gint i = 0;
    gint len = 0;
    GList *list;
    gint j = 0;
    gint mlen = 0;

    table = text->embedded_table;
    if (!table) {
        check_syntax (text, start, end);
        return;
    }

    if (end > text->length) {
        g_warning ("THIS IS BUGGY! end [%d] is more than text->length [%d]\n",
                   end, text->length);
        end = text->length;
    }
    prev = NULL;
    for (i = start; i < end; i++) {
        for (list = table->entries; list; list = list->next) {
            embedded = (GtkExTextEmbeddedEntry *) list->data;
            if ((len = gtk_extext_regex_match (text, i, &embedded->outside)) > 0
                && end >= i + len) {
                //g_print("Embedded range found at position %d with length %d.\n", i, len);
                for (j = i; j < (i + len); j++) {
                    if ((mlen =
                         gtk_extext_regex_match (text, j,
                                                 &embedded->inside)) > 0
                        && (j + mlen) <= (i + len)) {
                        //g_print("Embedded item found at position %d with length %d.\n", j, mlen);
                        prev =
                            gtk_extext_property_insert (text, embedded->key, j,
                                                        j + mlen,
                                                        GINT_TO_POINTER
                                                        (EMBEDDED_TABLE),
                                                        PROPERTY_REMOVEALL,
                                                        prev);
                        j += (mlen - 1);    // we're about to j++ so make sure we compensate now
                    }
                }
            }
        }
    }
    check_syntax (text, start, end);
}

static void
check_syntax (GtkExText * text, gint start, gint end)
{
    gint s, i, j;
    gboolean found = FALSE;
    GList *list;
    GtkExTextMatch m;
    GtkExTextProperty *prev;
    GtkExTextHighlightTable *table;
    GtkExTextSyntaxEntry *sentry;

    table = text->syntax_table;
    if (!table) {
        check_pattern (text, start, end, NULL);
        return;
    }

    i = start;
    prev = text->scroll_line_start->property_first;
    if (end > text->length) {
        g_warning
            ("THIS IS BUGGY check_syntax end [%d] is more than text->length [%d]\n",
             end, text->length);
        end = text->length;
    }
    while (i < end) {
        s = gtk_extext_regex_search (text, i, &table->regex_all, TRUE, &m);
        if (s < 0 || s > end)
            break;
        if (i < s)
            check_pattern (text, i, s, prev);
        i = m.endpos;
        for (list = table->entries; list; list = list->next) {
            sentry = (GtkExTextSyntaxEntry *) list->data;
            if (gtk_extext_regex_match (text, s, &sentry->regex_start) > 0
                && GTK_EXTEXT_INDEX (text, s - 1) != '\\') {
                if ((j = get_syntax_end (text, i, sentry, &m)) > 0)
                    i = m.endpos;
                else if (j == 0)
                    continue;
                else
                    i = text->length;
                prev =
                    gtk_extext_property_insert (text, sentry->key, s, i,
                                                GINT_TO_POINTER (SYNTAX_TABLE),
                                                PROPERTY_REMOVEALL, prev);
                found = TRUE;
                break;
            } else if (GTK_EXTEXT_INDEX (text, s - 1) == '\\')
                found = TRUE;
        }
        if (!found)
            i++;
    }
    if (i < end)
        check_pattern (text, i, end, prev);
}

static void
check_pattern (GtkExText * text, gint start, gint end, GtkExTextProperty * prev)
{
    GtkExTextHighlightTable *table;
    GtkExTextPatternEntry *pentry;
    gint i = 0;
    GList *list;
    gint len = 0;

    table = text->pattern_table;
    if (!table)
        return;
    list = g_list_first (table->entries);
    if (end > text->length) {
        g_warning ("THIS IS BUGGY! end [%d] is more than text->length [%d]\n",
                   end, text->length);
        end = text->length;
    }
    prev = NULL;
    for (i = start; i < end; i++) {
        for (list = table->entries; list; list = list->next) {
            pentry = (GtkExTextPatternEntry *) list->data;
            if ((len = gtk_extext_regex_match (text, i, &pentry->regex)) > 0
                && end >= i + len) {
                prev =
                    gtk_extext_property_insert (text, pentry->key, i, i + len,
                                                GINT_TO_POINTER (PATTERN_TABLE),
                                                PROPERTY_REMOVEALL, prev);
                i += (len - 1); // compensate for i++ that's about to happen
                break;
            }
        }
    }
    gtk_widget_queue_draw (GTK_WIDGET (text));
}

static gint
get_syntax_end (GtkExText * text, gint pos, GtkExTextSyntaxEntry * table,
                GtkExTextMatch * m)
{
    int ret;
    int nbesc;

    do {
        ret =
            gtk_extext_regex_search (text, m->endpos, &table->regex_end, TRUE,
                                     m);
        if (ret < 0)
            return (-1);
        for (nbesc = 0; GTK_EXTEXT_INDEX (text, m->endpos - 2 - nbesc) == '\\';
             nbesc++);
    } while (m->endpos && nbesc & 1);
    return (ret);
}
