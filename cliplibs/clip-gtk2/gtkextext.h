/*  GtkExText
 *
 *  Copyright (C) 1999, 2000 
 *  Mikael Hermansson <mikeh@bahnhof.se>
 *  Chris Phelps <chicane@reninet.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#ifndef _GTK_EXTEXT_H_
#define _GTK_EXTEXT_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <gdk/gdk.h>
#include <gtk/gtk.h>

#include <sys/types.h>

#ifdef WITH_SYSTEM_REGEX
#include <regex.h>
#else
#include "regex.h"
#endif

#define GTK_TYPE_EXTEXT                  (gtk_extext_get_type ())
#define GTK_EXTEXT(obj)                  (GTK_CHECK_CAST ((obj), GTK_TYPE_EXTEXT, GtkExText))
#define GTK_EXTEXT_CLASS(klass)          (GTK_CHECK_CLASS_CAST ((klass), GTK_TYPE_EXTEXT, GtkExTextClass))
#define GTK_IS_EXTEXT(obj)               (GTK_CHECK_TYPE ((obj), GTK_TYPE_EXTEXT))
#define GTK_IS_EXTEXT_CLASS(klass)       (GTK_CHECK_CLASS_TYPE ((klass), GTK_TYPE_EXTEXT))

#define LINE_DATA_LENGTH(cur) cur->lineptr->length
#define LINE_DATA_USERDATA(cur) cur->lineptr->user_data
#define LINE_DATA_WIDTH(cur) cur->lineptr->width
#define LINE_DATA_HEIGHT(cur) cur->lineptr->height


#define PROPERTY_INSERT 0
#define PROPERTY_REMOVEALL 1
#define PROPERTY_MERGE 2

typedef struct _GtkExText GtkExText;
typedef struct _GtkExTextClass GtkExTextClass;

typedef struct _GtkExTextMatch {
    gint startpos;
    gint endpos;
} GtkExTextMatch;

enum {
    EXTEXT_UNDO_INSERT,
    EXTEXT_UNDO_REMOVE
};

typedef struct _GtkExTextUndoEntry {
    gboolean insert;
    guint start;
    guint length;
    gchar *text;
} GtkExTextUndoEntry;

/* GtkExTextStyle Setup font and bg/fg colors */
/* to use in textdocument */
#define GTK_EXTEXT_STYLE_BG 0x0001
#define GTK_EXTEXT_STYLE_UNDER 0x0002
#define GTK_EXTEXT_STYLE_STRIKE 0x0004
typedef struct _GtkExTextStyle {
    GdkFont *font;          /* font */
    GdkColor fg_color;      /* bg_color */
    GdkColor bg_color;      /* fg_color */
    gchar key[32];
    guint16 flags;
    gint rbearing;
    gint lbearing;
    gint ascent;
    gint descent;
} GtkExTextStyle;

typedef struct _Regex {
    struct re_pattern_buffer buf;
    struct re_registers reg;
} Regex;

typedef enum {
    SYNTAX_TABLE,
    PATTERN_TABLE,
    EMBEDDED_TABLE
} GtkExTextHighlightTableType;

typedef struct _GtkExTextSyntaxEntry {
    gchar *start;
    Regex regex_start;
    Regex regex_end;
    gchar key[32];
    GdkFont *font;
    GdkColor *color;
    GdkColor *bg;
    guint16 flags;
    gpointer data;
    gint ref_count;
} GtkExTextSyntaxEntry;

typedef struct _GtkExTextPatternEntry {
    Regex regex;
    gchar key[32];
    GdkFont *font;
    GdkColor *color;
    GdkColor *bg;
    guint16 flags;
    gpointer data;
    gint ref_count;
} GtkExTextPatternEntry;

typedef struct _GtkExTextEmbeddedEntry {
    Regex outside;
    Regex inside;
    gchar key[32];
    GdkFont *font;
    GdkColor *color;
    GdkColor *bg;
    guint16 flags;
    gpointer data;
    gint ref_count;
} GtkExTextEmbeddedEntry;

typedef struct _GtkExTextHighlightTable {
    GtkExTextHighlightTableType type;
    GList *entries;
    Regex regex_all;
} GtkExTextHighlightTable;

/* Line struct */
/* holds all lines */
/* all lines ends with "\n" character */
typedef struct _Lines {     /* 20 bytes */
    guint16 length;
    guint16 flags;          /* unused at the moment */
    guint16 width;
    guint16 height;
    GdkPixmap *pixmap;
    GdkBitmap *mask;
    gpointer user_data;     /* possible for the user to set */
    struct _Lines *next;
    struct _Lines *prev;
} Lines;

/* Property is used  to set a property mark in the textdoc*/
typedef struct _GtkExTextProperty {
    /* startpos from begining of text */
    guint startpos;
    /* endpos from begining of text */
    guint endpos;
    /*User data */
    gpointer user_data;
    /* private user should NOT change this */
    struct _GtkExTextProperty *next;
    struct _GtkExTextProperty *prev;
    /* pointer to GtkExTextStyle */
    GtkExTextStyle *style;
} GtkExTextProperty;

/* this is a wrapped and should be public for the user */
/* this calculates startpos and endpos */
/* and the return it to the user */
/* structure is READONLY for the user */
typedef struct _GtkExTextLineData {
    /* in text startpos */
    gint startpos;
    /* in text endpos */
    gint endpos;
    /* the line number */
    gint line_number;
    /* first line property nearest backward  */
    GtkExTextProperty *property_first;
    /* the real lineptr */
    Lines *lineptr;
} GtkExTextLineData;

typedef struct _extext_cursor {
    gboolean hide;
    gint offsetx;
    gint x;
    gint y;
    gint w;
    gint h;
} extext_cursor;

struct _GtkExText {
    /* Old GtkEditable stuff */
    GtkWidget widget;
    guint current_pos;
    gint selection_start_pos;
    gint selection_end_pos;
    guint has_selection:1;
    guint editable:1;
    GdkIC *ic;
    GdkICAttr *ic_attr;
    gchar *clipboard_text;
    /* Start the real GtkExText data */

    GdkWindow *text_area;
    GdkGC *gc;
    GdkGC *bg_gc;
    /* The default font */
    GdkFont *font;
    /* colors used for selection on focus/no focus */
    GdkColor scolor;
    GdkColor pcolor;

    GtkAdjustment *vadj;
    GtkAdjustment *hadj;
    GdkCursor *ecursor;
    GdkCursor *acursor;

    guint timer;
    guint button;

    /* double buffering  */
    GdkDrawable *draw_area;

    gint freeze_count;

    /* size is how mush allocated text memory */
    gint size;

    /* length is how mush used text memory */
    gint length;

    gint gap_len;
    gint part1len;
    guchar *text;
    guchar *part2text;

    guint text_insert_delete_flag:1;
    guint undo_flag:1;

    /* line cache coding see source for more info */

    Lines *line_start;      /* the line first */
    Lines *line_end;        /* the line cache last */
    Lines *line_ptr;        /* current position  */

    gint line_count;

    /* first visible line */
    /* number of visible lines  scroll_line_start + scroll_line_count = last visible line */
    gint scroll_line_count;

    GtkExTextLineData *scroll_line_start;
    gint line_number;       /* current line number */
    gint column_number;     /* current column number */
    //gint lci_bak;

    extext_cursor cursor;
    gint cursor_timer;
    guint cursor_blink:1;

    /* Undo coding */
    gint undo_max;
    GList *undo_redo;
    guint undo_level;

    /* Number drawing stuffs */
    guint draw_numbers:1;
    gint number_width;

    /* Pixmap drawing stuffs */
    guint draw_pixmaps:1;
    gint pixmap_max_width;
    gint pixmap_max_height;

    /* number_width + pixmap_width */
    gint gutter_width;

    guint highlight:1;
    guint select_line:1;
    guint draw_cursor:1;
    guint full_selection:1;
    guint show_whitespace:1;
    guint show_newlines:1;
    guint pseudo_select:1;
    gint pseudo_start;
    gint pseudo_end;
    guint use_spaces:1;
    guint tab_stops:1;
    gint default_tab_width;

    /* property handling */
    gint property_count;

    GtkWidget *margin_popupmenu;
    GtkWidget *text_popupmenu;

    GtkExTextProperty *property_start;
    GtkExTextProperty *property_end;
    GtkExTextProperty *property_current;

    /* hash list with font/color styles */
    GHashTable *hash_styles;

    /* List of all the stuff we want to highlight */
    GtkExTextHighlightTable *syntax_table;
    GtkExTextHighlightTable *pattern_table;
    GtkExTextHighlightTable *embedded_table;
};

struct _GtkExTextClass {
    GtkWidgetClass parent_class;

    /* Signals from GtkEditable */
    void (*insert_text) (GtkExText * text,
                         const gchar * new_text, gint length,
                         gint * position);
    void (*delete_text) (GtkExText * text, gint start_pos, gint end_pos);
    void (*changed) (GtkExText * text);
    void (*move_to_row) (GtkExText * text, gint row);
    void (*move_to_column) (GtkExText * text, gint col);
    void (*cut_clipboard) (GtkExText * text);
    void (*copy_clipboard) (GtkExText * text);
    void (*paste_clipboard) (GtkExText * text);
    /* End of GtkEditable signals */

      gint (*property_text_insert) (GtkExText * text,
                                    GtkExTextProperty * prop, gint startpos,
                                    gint endpos);
      gint (*property_text_remove) (GtkExText * text,
                                    GtkExTextProperty * prop, gint startpos,
                                    gint endpos);
    void (*property_destroy) (GtkExText * text, GtkExTextProperty * prop);
      gint (*undo_changed) (GtkExText * text);

    void (*set_scroll_adjustments) (GtkExText * text,
                                    GtkAdjustment * hadjustment,
                                    GtkAdjustment * vadjustment);

    /* Is called everytime cursor comes to a new property */
    void (*property_mark) (GtkExText * text, GtkExTextProperty * prop);

    /* line_[insert/remove] signal is sent when insert/delete a line */
    /* Use for example when you need to update line marks/breakpoints or similar */
      gint (*line_insert) (GtkExText * text, gint line_number);
      gint (*line_remove) (GtkExText * text, gint line_number);
    void (*margin_enter) (GtkExText * text, gint line);
    void (*margin_exit) (GtkExText * text, gint line);
    void (*margin_clicked) (GtkExText * text, GdkEventButton * ev,
                            gint line);

    /* line_funcs */
    GtkExTextLineData *(*line_by_offset) (GtkExText * text, gint y,
                                          gint * newoffsety);
      gint (*column_by_offset) (GtkExText * text, GtkExTextLineData * data,
                                gint x, gint * newoffsetx);
};


/* GtkWidget API */
GtkType gtk_extext_get_type ();
GtkWidget *gtk_extext_new ();
void gtk_extext_set_adjustments (GtkExText * text, GtkAdjustment * hadj,
                                 GtkAdjustment * vadj);
/* text API */

void gtk_extext_insert (GtkExText * text, const gchar * chars, gint len);
void gtk_extext_insert_with_style (GtkExText * text,
                                   const char *chars, gint len,
                                   gchar * stylekey, gpointer userdata);

void gtk_extext_insert_text (GtkExText * text,
                             const gchar * new_text,
                             gint new_text_length, gint * position);

void gtk_extext_delete_text (GtkExText * text, gint startpos, gint endpos);
void gtk_extext_select_region (GtkExText * text, gint start, gint end);
gchar *gtk_extext_get_chars (GtkExText * text, gint start, gint end);

gint gtk_extext_get_length (GtkExText * text);
guchar gtk_extext_get_char_at_pos (GtkExText * text, gint pos);

void gtk_extext_set_popup_menu (GtkExText * text, GtkWidget * widget,
                                GtkWidget * marginmenu);

/* Line and column API */
GtkExTextLineData *gtk_extext_get_line_data (GtkExText * text, gint line,
                                             GtkExTextLineData * old);
gboolean gtk_extext_get_line_data_prev (GtkExText * text,
                                        GtkExTextLineData * cur);
gboolean gtk_extext_get_line_data_next (GtkExText * text,
                                        GtkExTextLineData * cur);

gint gtk_extext_set_line (GtkExText * text, gint pos);
gint gtk_extext_get_line (GtkExText * text);

GtkExTextLineData *gtk_extext_get_first_visible_line (GtkExText * text);
GtkExTextLineData *gtk_extext_get_line_by_char_pos (GtkExText * text,
                                                    gint pos,
                                                    GtkExTextLineData *
                                                    data);
GtkExTextLineData *gtk_extext_get_line_by_offset (GtkExText * text, gint y,
                                                  gint * newoffsety);

gpointer gtk_extext_get_line_userdata (GtkExText * text, gint line);
void gtk_extext_set_line_userdata (GtkExText * text, gint line,
                                   gpointer userdata);
void gtk_extext_set_line_pixmap (GtkExText * text, gint line,
                                 GdkPixmap * pixmap, GdkBitmap * mask);
gboolean gtk_extext_get_line_pixmap (GtkExText * text, gint line,
                                     GdkPixmap ** pixmap,
                                     GdkBitmap ** mask);

gint gtk_extext_set_column (GtkExText * text, gint col);
gint gtk_extext_get_column (GtkExText * text);
gint gtk_extext_get_abs_column (GtkExText * text, gint pos);
gint gtk_extext_get_next_tab_stop (GtkExText * text, gint pos);
gint gtk_extext_get_column_by_offset (GtkExText * text,
                                      GtkExTextLineData * linedataptr,
                                      gint x, gint * newx);

/* Undo funcs */
gint gtk_extext_undo_get_max (GtkExText * text);
gboolean gtk_extext_undo_set_max (GtkExText * text, gint max);
gboolean gtk_extext_undo_is_empty (GtkExText * text);
gboolean gtk_extext_redo_is_empty (GtkExText * text);
void gtk_extext_undo_clear_all (GtkExText * text);
gboolean gtk_extext_undo (GtkExText * text);
gboolean gtk_extext_redo (GtkExText * text);

/* Style functions */
GtkExTextStyle *gtk_extext_style_insert (GtkExText * text,
                                         gchar * stylename, GdkFont * font,
                                         GdkColor * fg, GdkColor * bg,
                                         guint16 flags);
GtkExTextStyle *gtk_extext_style_get (GtkExText * text, gchar * key);
void gtk_extext_style_remove (GtkExText * textclass, gchar * key);
void gtk_extext_style_set (GtkWidget * widget, GtkStyle * old);

/* Property functions */
GtkExTextProperty *gtk_extext_property_insert (GtkExText * text,
                                               gchar * key, gint startpos,
                                               gint endpos, gpointer data,
                                               gint typ,
                                               GtkExTextProperty * prev);
GtkExTextProperty *gtk_extext_property_remove (GtkExText * text,
                                               GtkExTextProperty * remove);
GtkExTextProperty *gtk_extext_property_get_at_pos (GtkExText * text,
                                                   gint pos,
                                                   GtkExTextProperty * cur);
GtkExTextProperty *gtk_extext_property_move_all (GtkExText * text, gint pos,
                                                 gint diff,
                                                 GtkExTextProperty * cur);
GtkExTextProperty *gtk_extext_property_remove_all (GtkExText * text,
                                                   gint start, gint end,
                                                   GtkExTextProperty * cur);
GtkExTextProperty *gtk_extext_property_nearest_forward (GtkExText * text,
                                                        gint pos,
                                                        GtkExTextProperty *
                                                        cur);
GtkExTextProperty *gtk_extext_property_nearest_backward (GtkExText * text,
                                                         gint pos,
                                                         GtkExTextProperty *
                                                         cur);
GtkExTextProperty *gtk_extext_property_get_current (GtkExText * text);

/* utils returns true if found and the startpos and endpos will be updated */
/* you must initiate the startpos with some value */
/* for example startpos=gtk_extext_get_position() */

gboolean gtk_extext_get_current_word (GtkExText * text, gint * startpos,
                                      gint * endpos);
gboolean gtk_extext_get_next_word (GtkExText * text, gint * startpos,
                                   gint * endpos);
gboolean gtk_extext_get_previous_word (GtkExText * text, gint * startpos,
                                       gint * endpos);

void gtk_extext_freeze (GtkExText * text);
void gtk_extext_thaw (GtkExText * text);

void gtk_extext_set_pseudo_select (GtkExText * text, gint start, gint end);

void gtk_extext_set_use_spaces (GtkExText * text, gboolean spaces);
void gtk_extext_set_draw_numbers (GtkExText * text, gboolean draw);
void gtk_extext_set_draw_pixmaps (GtkExText * text, gboolean draw);
void gtk_extext_set_pixmap_size (GtkExText * text, gint size);

void gtk_extext_set_select_line (GtkExText * text, gboolean select);
void gtk_extext_set_cursor_blink (GtkExText * text, gboolean blink);
void gtk_extext_set_draw_cursor (GtkExText * text, gboolean draw);
void gtk_extext_set_full_selection (GtkExText * text, gboolean full);
void gtk_extext_set_show_newlines (GtkExText * text, gboolean show);
void gtk_extext_set_show_whitespace (GtkExText * text, gboolean show);

gint gtk_extext_get_tab_width (GtkExText * text);
void gtk_extext_set_tab_width (GtkExText * text, gint width);
void gtk_extext_set_use_tab_stops (GtkExText * text, gboolean tab_stops);

void gtk_extext_set_position (GtkExText * text, gint pos);
gint gtk_extext_get_position (GtkExText * text);
gboolean gtk_extext_get_editable (GtkExText * text);
void gtk_extext_set_editable (GtkExText * text, gboolean r);

void gtk_extext_cut_clipboard (GtkExText * text);
void gtk_extext_copy_clipboard (GtkExText * text);
void gtk_extext_paste_clipboard (GtkExText * text);

void gtk_extext_delete_selection (GtkExText * text);
void gtk_extext_set_no_selection (GtkExText * text, gboolean draw);

GtkType gtk_extext_get_type (void);

gboolean gtk_extext_compile_regex (const gchar * pattern, Regex * regex);

void gtk_extext_set_highlight (GtkExText * text, gboolean value);
void gtk_extext_highlight (GtkExText * text);

GtkExTextHighlightTable *gtk_extext_syntax_table_new (GList * entries);
GtkExTextHighlightTable *gtk_extext_pattern_table_new (GList * entries);
GtkExTextHighlightTable *gtk_extext_embedded_table_new (GList * entries);

void gtk_extext_table_free (GtkExTextHighlightTable * table);

GList *gtk_extext_syntax_entry_new (GList * entries, gchar * name,
                                    gchar * start, gchar * end,
                                    GdkColor * fg, GdkColor * bg,
                                    GdkFont * font, guint16 flags,
                                    gpointer data);
GList *gtk_extext_pattern_entry_new (GList * entries, gchar * name,
                                     gchar * start, GdkColor * fg,
                                     GdkColor * bg, GdkFont * font,
                                     guint16 flags, gpointer data);
GList *gtk_extext_embedded_entry_new (GList * entries, gchar * name,
                                      gchar * outside, gchar * inside,
                                      GdkColor * fg, GdkColor * bg,
                                      GdkFont * font, guint16 flags,
                                      gpointer data);

void gtk_extext_install_table (GtkExText * text,
                               GtkExTextHighlightTable * table);

#define GTK_EXTEXT_INDEX(extext,index) (index < extext->part1len ? \
                                  extext->text[index] : extext->part2text[index])

/* search routines */
gboolean gtk_extext_search (GtkExText * text, gchar * search, gint pos,
                            gboolean iscase, gboolean forward,
                            GtkExTextMatch * m);

/* Regex functions */
gint gtk_extext_regex_search (GtkExText * text, gint start, Regex * regex,
                              gboolean forward, GtkExTextMatch * m);
gint gtk_extext_regex_match (GtkExText * text, gint pos, Regex * regex);

#ifdef __cplusplus
}
#endif
#endif
