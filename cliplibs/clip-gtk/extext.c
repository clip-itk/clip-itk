/*
    Copyright (C) 2001  ITK
    Author  : Elena Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html

    Thanks for       : Mikael Hermansson <mikeh@bahnhof.se> and
    gtkextext library: Chris Phelps <chicane@reninet.com>

*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <string.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"
#include "clip-gdk.h"
#include "gtkextext.h"
#include "bmpxpm.h"

#ifdef OS_CYGWIN
	#include "sys\cygwin.h"
#endif

/**********************************************************/
/* Signals table */
static SignalTable extext_signals[] =
{
	{"insert-text",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_INSERT_TEXT_SIGNAL},
	{"delete-text",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_DELETE_TEXT_SIGNAL},
	{"changed",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_CHANGED_SIGNAL},
	{"move-to-row",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_MOVE_TO_ROW_SIGNAL},
	{"move-to-column",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_MOVE_TO_COLUMN_SIGNAL},
	{"cut-clipboard",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_CUT_CLIPBOARD_SIGNAL},
	{"copy-clipboard",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_COPY_CLIPBOARD_SIGNAL},
	{"paste-clipboard",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PASTE_CLIPBOARD_SIGNAL},
	{"property-text-insert",GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PROPERTY_TEXT_INSERT_SIGNAL},
	{"property-text-remove",GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PROPERTY_TEXT_REMOVE_SIGNAL},
	{"property-destroy",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PROPERTY_DESTROY_SIGNAL},
	{"undo-changed",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_UNDO_CHANGED_SIGNAL},
	{"property-mark",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PROPERTY_MARK_SIGNAL},
	{"line-insert",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_LINE_INSERT_SIGNAL},
	{"line-remove",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_LINE_REMOVE_SIGNAL},
	{"margin-enter",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_MARGIN_ENTER_SIGNAL},
	{"margin-exit",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_MARGIN_EXIT_SIGNAL},
	{"margin-clicked",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_MARGIN_CLICKED_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register widget signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_extext() { return GTK_TYPE_EXTEXT; }
long _clip_type_extext() { return GTK_WIDGET_EXTEXT; }
const char * _clip_type_name_extext() { return "GTK_WIDGET_EXTEXT"; }

int
clip_INIT___EXTEXT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_extext, _clip_type_name_extext, _gtk_type_extext,  _gtk_type_widget, extext_signals);
	return 0;
}
/**********************************************************/

/**** EXTEXT constructor ****/
int
clip_GTK_EXTEXTNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);

	wid = gtk_extext_new();

	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/
/* GtkWidget API */
/*GtkType gtk_extext_get_type ();*/

int
clip_GTK_EXTEXTSETADJUSTMENTS(ClipMachine * cm)
{
	C_widget  *extext = _fetch_cw_arg(cm);
	C_widget * chadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
	C_widget * cvadj = _fetch_cwidget(cm,_clip_spar(cm, 3));
	GtkAdjustment *hadj, *vadj;

	CHECKCWID(extext,GTK_IS_EXTEXT);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(chadj,GTK_IS_ADJUSTMENT);
	CHECKOPT2(3,MAP_t,NUMERIC_t); CHECKCWIDOPT(cvadj,GTK_IS_ADJUSTMENT);

	hadj = chadj ? GTK_ADJUSTMENT(chadj->widget) : NULL;
	vadj = cvadj ? GTK_ADJUSTMENT(cvadj->widget) : NULL;
	gtk_extext_set_adjustments(GTK_EXTEXT(extext->widget),hadj,vadj);

	return 0;
err:
	return 1;
}
/* text API */

int
clip_GTK_EXTEXTINSERT(ClipMachine * cm)
{
	C_widget  *extext = _fetch_cw_arg(cm);
	gchar      *chars = _clip_parc(cm, 2);
	gint          len ;

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKARG(2, CHARACTER_t);

	len = strlen(chars);

	gtk_extext_insert(GTK_EXTEXT(extext->widget), chars, len);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTINSERTWITHSTYLE(ClipMachine * cm)
{
	C_widget  *extext = _fetch_cw_arg(cm);
	gchar      *chars = _clip_parc(cm, 2);
	gchar   *stylekey = _clip_parc(cm, 3);
	ClipVar *userdata = _clip_spar(cm, 4);
	gint          len;
	C_var           c;

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKARG(2, CHARACTER_t); CHECKARG(3, CHARACTER_t);
	CHECKARG2(4,CCODE_t,PCODE_t);

	c.cm = cm; c.cfunc = userdata; c.cw = extext;

	len = strlen(chars);

	gtk_extext_insert_with_style(GTK_EXTEXT(extext->widget), chars, len, stylekey, &c);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTINSERTTEXT(ClipMachine * cm)
{
	C_widget      *extext = _fetch_cw_arg(cm);
	const gchar *new_text = _clip_parc(cm, 2);
	gint     new_text_len = _clip_parni(cm, 3);
	gint         position;

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKARG(2, CHARACTER_t); CHECKOPT(3, NUMERIC_t);

	gtk_extext_insert_text(GTK_EXTEXT(extext->widget), new_text, new_text_len, &position);

	_clip_retni(cm, position);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTDELETETEXT(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint       start = _clip_parni(cm, 2);
	gint         end = _clip_parni(cm, 3);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t); CHECKOPT(3, NUMERIC_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		start = 0;
	if (_clip_parinfo(cm, 3) != NUMERIC_t)
		end = GTK_EXTEXT(extext->widget)->length;
	if (GTK_EXTEXT(extext->widget)->length)
		gtk_extext_delete_text(GTK_EXTEXT(extext->widget), start, end);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTSELECTREGION(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint       start = _clip_parni(cm, 2);
	gint         end = _clip_parni(cm, 3);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t); CHECKOPT(3, NUMERIC_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		start = 0;
	if (_clip_parinfo(cm, 3) != NUMERIC_t)
		end = GTK_EXTEXT(extext->widget)->length;
	if (GTK_EXTEXT(extext->widget)->length)
		gtk_extext_select_region(GTK_EXTEXT(extext->widget), start, end);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTGETCHARS(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint       start = _clip_parni(cm, 2);
	gint         end = _clip_parni(cm, 3);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t); CHECKOPT(3, NUMERIC_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		start = 0;
	if (_clip_parinfo(cm, 3) != NUMERIC_t)
		end = GTK_EXTEXT(extext->widget)->length;

	_clip_retc(cm, (char *)gtk_extext_get_chars(GTK_EXTEXT(extext->widget), start, end));

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTGETLENGTH(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);

	CHECKCWID(extext, GTK_IS_EXTEXT);

	_clip_retni(cm, GTK_EXTEXT(extext->widget)->length);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTGETCHARATPOS(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint         pos = _clip_parni(cm, 2);
	guchar       str;

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		pos = GTK_EXTEXT(extext->widget)->line_number;

	str = gtk_extext_get_char_at_pos(GTK_EXTEXT(extext->widget), pos);
	_clip_retc(cm, &str);
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTSETPOPUPMENU(ClipMachine * cm)
{
	C_widget     *extext = _fetch_cw_arg(cm);
	C_widget     *widget = _fetch_cwidget(cm, _clip_spar(cm, 2));
	C_widget *marginmenu = _fetch_cwidget(cm, _clip_spar(cm, 3));

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT2(2, MAP_t, NUMERIC_t); CHECKCWID(widget, GTK_IS_WIDGET);
	CHECKOPT2(3, MAP_t, NUMERIC_t); CHECKCWID(marginmenu, GTK_IS_WIDGET);

	gtk_extext_set_popup_menu(GTK_EXTEXT(extext->widget), GTK_WIDGET(widget->widget), GTK_WIDGET(marginmenu->widget));
	return 0;
err:
	return 1;
}
/* Line and column API */
/*
GtkExTextLineData *gtk_extext_get_line_data (GtkExText * text, gint line,
					     GtkExTextLineData * old);
gboolean gtk_extext_get_line_data_prev (GtkExText * text,
					GtkExTextLineData * cur);
gboolean gtk_extext_get_line_data_next (GtkExText * text,
					GtkExTextLineData * cur);
*/

int
clip_GTK_EXTEXTSETLINE(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint         pos = _clip_parni(cm, 2);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		pos = GTK_EXTEXT(extext->widget)->line_number;

	pos --;

	_clip_retni(cm, gtk_extext_set_line(GTK_EXTEXT(extext->widget), pos));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTGETLINE(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint         pos;
	CHECKCWID(extext, GTK_IS_EXTEXT);

	pos = gtk_extext_get_line(GTK_EXTEXT(extext->widget));
	pos ++;
	_clip_retni(cm, pos);
	return 0;
err:
	return 1;
}

CLIP_DLLEXPORT void
_extext_linedata_to_map(ClipMachine *cm, GtkExText *text, GtkExTextLineData *lined, ClipVar *m_lined)
{
	ClipVar *c = NEW(ClipVar);
	ClipVar *a = NEW(ClipVar);
	gint     l;
	if (!lined || !m_lined || m_lined->t.type!=MAP_t) return;

	_clip_map(cm, c); _clip_mputn(cm, c, HASH_STARTPOS, lined->startpos);
	_clip_madd(cm, m_lined, HASH_STARTPOS, c);

	_clip_map(cm, c); _clip_mputn(cm, c, HASH_ENDPOS, lined->endpos);
	_clip_madd(cm, m_lined, HASH_ENDPOS, c);

	_clip_map(cm, c); _clip_mputn(cm, c, HASH_LINE, lined->line_number);
	_clip_madd(cm, m_lined, HASH_LINE, c);

	l = lined->endpos - lined->startpos;
	_clip_map(cm, c); _clip_mputc(cm, c, HASH_TEXT, text->text + lined->startpos, l);
	_clip_madd(cm, m_lined, HASH_TEXT, c);


	_clip_destroy(cm,c);
	free(c); free(a);

}

int
clip_GTK_EXTEXTGETFIRSTVISIBLELINE(ClipMachine * cm)
{
	C_widget            *extext = _fetch_cw_arg(cm);
	ClipVar 	 *mlineData = RETPTR(cm);
	GtkExTextLineData *lineData;
	CHECKCWID(extext, GTK_IS_EXTEXT);

	memset(mlineData,0,sizeof(*mlineData));
	_clip_map(cm,mlineData);
	lineData = gtk_extext_get_first_visible_line(GTK_EXTEXT(extext->widget));
	_extext_linedata_to_map(cm, GTK_EXTEXT(extext->widget), lineData, mlineData);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTSETLINEPIXMAPFROMXPM(ClipMachine * cm)
{
	C_widget  *extext = _fetch_cw_arg(cm);
	gint 	     line = _clip_parni(cm, 2);
	ClipVar    *cxpmd = _clip_par(cm, 3);
	GdkBitmap *mask;
	GdkPixmap *pixmap;
	GdkWindow *win = NULL;
	GdkColormap *colormap = NULL;
	char * * xpm_data = NULL;
	unsigned short i;

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t);
	CHECKOPT(3, ARRAY_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		line = GTK_EXTEXT(extext->widget)->line_number;
	else
		line --;

	//printf("\nextext %d\n extext->widget %d\n extext->widget->window %d\n" , (extext->parent ), (extext->parent->widget), (extext->parent->widget->window));
	//if (extext && extext->widget && extext->widget->window)
	//{
		win = extext->widget->window;
		colormap = gtk_widget_get_colormap(extext->widget);
	//	printf("\n win & colormap\n");
	//}
	//else
	//	colormap = gdk_colormap_get_system();

	if (cxpmd->a.count > 0)
	{
		ClipVar *item;
		xpm_data = (char * *)calloc(sizeof(char*),cxpmd->a.count);
		for (i = 0; i < cxpmd->a.count; i++)
		{
			item = cxpmd->a.items + i;
			if (item->t.type == CHARACTER_t)
			{
				xpm_data[i] = (char*)calloc(1,item->s.str.len+1);
				strcpy(xpm_data[i], item->s.str.buf);
				//printf("xpm_data[i]=%s\n", xpm_data[i]);
			}
		}
	}

	pixmap = gdk_pixmap_colormap_create_from_xpm_d(win, colormap, &mask, NULL, xpm_data);

	gtk_extext_set_line_pixmap(GTK_EXTEXT(extext->widget), line, pixmap, mask);

	return 0;
err:
	return 1;
}
/*
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
*/

int
clip_GTK_EXTEXTSETCOLUMN(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint         col = _clip_parni(cm, 2);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		col = GTK_EXTEXT(extext->widget)->column_number;

	col --;

	_clip_retni(cm, gtk_extext_set_column(GTK_EXTEXT(extext->widget), col));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTGETCOLUMN(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint         col;
	CHECKCWID(extext, GTK_IS_EXTEXT);

	col = gtk_extext_get_column(GTK_EXTEXT(extext->widget));
	col ++;
	_clip_retni(cm, col);
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTGETABSCOLUMN(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint         pos = _clip_parni(cm, 2);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		pos = GTK_EXTEXT(extext->widget)->line_number;

	_clip_retni(cm, gtk_extext_get_abs_column(GTK_EXTEXT(extext->widget), pos));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTGETNEXTTABSTOP(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint         pos = _clip_parni(cm, 2);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t);

	if (_clip_parinfo(cm, 2) != NUMERIC_t)
		pos = GTK_EXTEXT(extext->widget)->line_number;

	_clip_retni(cm, gtk_extext_get_next_tab_stop(GTK_EXTEXT(extext->widget), pos));
	return 0;
err:
	return 1;
}
/*
gint gtk_extext_get_column_by_offset (GtkExText * text,
				      GtkExTextLineData * linedataptr,
				      gint x, gint * newx);

*/
/* Undo funcs */

int
clip_GTK_EXTEXTUNDOGETMAX(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	_clip_retni(cm, gtk_extext_undo_get_max(GTK_EXTEXT(extext->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTUNDOSETMAX(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gint         max = _clip_parni(cm, 2);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKOPT(2, NUMERIC_t);

	_clip_retl(cm, gtk_extext_undo_set_max(GTK_EXTEXT(extext->widget), max));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTUNDOISEMPTY(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);

	CHECKCWID(extext, GTK_IS_EXTEXT);

	_clip_retl(cm, gtk_extext_undo_is_empty(GTK_EXTEXT(extext->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTREDOISEMPTY(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);

	CHECKCWID(extext, GTK_IS_EXTEXT);

	_clip_retl(cm, gtk_extext_redo_is_empty(GTK_EXTEXT(extext->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTUNDOCLEARALL(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);

	CHECKCWID(extext, GTK_IS_EXTEXT);

	gtk_extext_undo_clear_all(GTK_EXTEXT(extext->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTUNDO(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);

	CHECKCWID(extext, GTK_IS_EXTEXT);

	_clip_retl(cm, gtk_extext_undo(GTK_EXTEXT(extext->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTREDO(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);

	CHECKCWID(extext, GTK_IS_EXTEXT);

	_clip_retl(cm, gtk_extext_redo(GTK_EXTEXT(extext->widget)));
	return 0;
err:
	return 1;
}
/* Style functions */
CLIP_DLLEXPORT void
_extext_style_to_map(ClipMachine *cm, GtkExTextStyle *style, ClipVar *m_style)
{
	ClipVar *c = NEW(ClipVar);
	ClipVar *a = NEW(ClipVar);
	C_object *cfont;
	if (!style || !m_style || m_style->t.type!=MAP_t) return;
	/* Get colors of widget */

	_clip_map(cm, c); _gdk_color_to_map(cm, style->fg_color, c);
	_clip_madd(cm, m_style, HASH_FG_COLOR, c);
	_clip_map(cm, c); _gdk_color_to_map(cm, style->bg_color, c);
	_clip_madd(cm, m_style, HASH_BG_COLOR, c);
	_clip_map(cm, c); _clip_mputc(cm, c, HASH_KEY, style->key, 32);
	_clip_madd(cm, m_style, HASH_KEY, c);

	if (style->font)
	{
		cfont = _list_get_cobject(cm,style->font);
		if (!cfont) cfont = _register_object(cm,style->font,GDK_OBJECT_FONT,
			NULL,(coDestructor)gdk_object_font_destructor);
		if (cfont)
		{
			_clip_madd(cm,m_style,HASH_FONT,&cfont->obj);
		}
	}

	_clip_destroy(cm,c);
	free(c); free(a);

}

int
clip_GTK_EXTEXTSTYLEINSERT(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gchar *stylename = _clip_parc(cm, 2);
	C_object  *cfont = _fetch_cobject(cm, _clip_spar(cm, 3));
	ClipVar     *mfg = _clip_spar(cm, 4);
	ClipVar     *mbg = _clip_spar(cm, 5);
	guint16    flags = _clip_parni(cm, 6);
	ClipVar *exstyle = RETPTR(cm);
	GtkExTextStyle *style;
	GdkColor fgcolor;
	GdkColor bgcolor;

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKARG(2, CHARACTER_t);
	CHECKCOBJ(cfont, GDK_IS_FONT(cfont));
	CHECKARG(4, MAP_t); CHECKARG(5, MAP_t);
	CHECKOPT(6, NUMERIC_t);

	_map_colors_to_gdk(cm, mfg, &fgcolor);
	_map_colors_to_gdk(cm, mbg, &bgcolor);

	memset(exstyle,0,sizeof(*exstyle));
	_clip_map(cm,exstyle);
	style = gtk_extext_style_insert(GTK_EXTEXT(extext->widget), stylename, GDK_FONT(cfont->object), &fgcolor, &bgcolor, flags);
	_extext_style_to_map(cm, style, exstyle);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTSTYLEGET(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gchar *stylename = _clip_parc(cm, 2);
	ClipVar *exstyle = RETPTR(cm);
	GtkExTextStyle *style;

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKARG(2, CHARACTER_t);

	memset(exstyle,0,sizeof(*exstyle));
	_clip_map(cm,exstyle);
	style = gtk_extext_style_get(GTK_EXTEXT(extext->widget), stylename);
	_extext_style_to_map(cm, style, exstyle);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTSTYLEREMOVE(ClipMachine * cm)
{
	C_widget *extext = _fetch_cw_arg(cm);
	gchar *stylename = _clip_parc(cm, 2);

	CHECKCWID(extext, GTK_IS_EXTEXT);
	CHECKARG(2, CHARACTER_t);

	gtk_extext_style_remove(GTK_EXTEXT(extext->widget), stylename);

	return 0;
err:
	return 1;
}

int
clip_GTK_EXTEXTSTYLESET(ClipMachine * cm)
{
	C_widget *widget = _fetch_cw_arg(cm);
	ClipVar  *mstyle = _clip_spar(cm, 2);
	GtkStyle  *style;

	CHECKCWID(widget, GTK_IS_WIDGET);
	CHECKARG(2, MAP_t);

	_map_to_style(cm, mstyle, style);
	gtk_extext_style_set(GTK_WIDGET(widget), style);

	return 0;
err:
	return 1;
}


/*
void gtk_extext_style_set (GtkWidget * widget, GtkStyle * old);
*/
/* Property functions */
/*
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
*/
/* utils returns true if found and the startpos and endpos will be updated */
/* you must initiate the startpos with some value */
/* for example startpos=gtk_extext_get_position() */
/*
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
*/
/* search routines */
/*
gboolean gtk_extext_search (GtkExText * text, gchar * search, gint pos,
			    gboolean iscase, gboolean forward,
			    GtkExTextMatch * m);
*/
/* Regex functions */
/*
gint gtk_extext_regex_search (GtkExText * text, gint start, Regex * regex,
			      gboolean forward, GtkExTextMatch * m);
gint gtk_extext_regex_match (GtkExText * text, gint pos, Regex * regex);
*/
