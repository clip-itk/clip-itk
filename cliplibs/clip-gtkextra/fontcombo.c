/*
    Copyright (C) 2002  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkextracfg.h"

#include <gtkextra/gtkextra.h>
#include <string.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

#include "clip-gtkextra.ch"
#include "clip-gtkextra.h"

/**********************************************************/
/* Signals table */
static SignalTable font_combo_signals[] =
{
	{"changed",		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL },
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register FontCombo in global table */
CLIP_DLLEXPORT GtkType _gtk_type_font_combo() { return gtk_font_combo_get_type(); }
long _clip_type_font_combo() { return GTK_WIDGET_FONT_COMBO; }
const char * _clip_type_name_font_combo() { return "GTK_WIDGET_FONT_COMBO"; }

int
clip_INIT___FONT_COMBO(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_font_combo, _clip_type_name_font_combo, _gtk_type_font_combo, _gtk_type_toolbar, font_combo_signals);
	return 0;
}

/**** FONT COMBO constructor ****/
int
clip_GTK_FONTCOMBONEW(ClipMachine * cm)
{
	ClipVar     * cv = _clip_spar (cm,1);
	GtkWidget *wid = NULL;
        C_widget *cwid, *cname_combo, *csize_combo, *cbold_btn, *citalic_btn;

	CHECKOPT(1,MAP_t);

	wid = gtk_font_combo_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        cname_combo = _register_widget(cm, GTK_FONT_COMBO(wid)->name_combo, NULL);
        csize_combo = _register_widget(cm, GTK_FONT_COMBO(wid)->size_combo, NULL);
        cbold_btn   = _register_widget(cm, GTK_FONT_COMBO(wid)->bold_button, NULL);
        citalic_btn = _register_widget(cm, GTK_FONT_COMBO(wid)->italic_button, NULL);
        _clip_madd(cm, &cwid->obj, HASH_NAMECOMBO, &cname_combo->obj);
        _clip_madd(cm, &cwid->obj, HASH_SIZECOMBO, &csize_combo->obj);
        _clip_madd(cm, &cwid->obj, HASH_BOLDBUTTON, &cbold_btn->obj);
        _clip_madd(cm, &cwid->obj, HASH_ITALICBUTTON, &citalic_btn->obj);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_FONTCOMBOSELECT(ClipMachine * cm)
{
	C_widget  *cfnc = _fetch_cw_arg(cm);
	const gchar *family = CHAR_OPTION(cm,2,"");
	gboolean   bold = BOOL_OPTION(cm,3,FALSE);
	gboolean italic = BOOL_OPTION(cm,4,FALSE);
	gint     height = _clip_parni(cm,5);
        CHECKCWID(cfnc,GTK_IS_FONT_COMBO);
        CHECKARG(2,CHARACTER_t); CHECKOPT(3,LOGICAL_t); CHECKOPT(4,LOGICAL_t);
        CHECKOPT(5,NUMERIC_t);
        gtk_font_combo_select(GTK_FONT_COMBO(cfnc->widget),family,bold,italic,height);
	return 0;
err:
	return 1;
}

int
clip_GTK_FONTCOMBOSELECTNTH(ClipMachine * cm)
{
	C_widget  *cfnc = _fetch_cw_arg(cm);
	gint          n = INT_OPTION(cm,2,1);
	gboolean   bold = BOOL_OPTION(cm,3,FALSE);
	gboolean italic = BOOL_OPTION(cm,4,FALSE);
	gint     height = _clip_parni(cm,5);
        CHECKCWID(cfnc,GTK_IS_FONT_COMBO);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,LOGICAL_t); CHECKOPT(4,LOGICAL_t);
        CHECKOPT(5,NUMERIC_t);
        gtk_font_combo_select_nth(GTK_FONT_COMBO(cfnc->widget),n,bold,italic,height);
	return 0;
err:
	return 1;
}

int
clip_GTK_FONTCOMBOGETFONT(ClipMachine * cm)
{
	C_widget  *cfnc = _fetch_cw_arg(cm);
        C_object *cfont;
        CHECKCWID(cfnc,GTK_IS_FONT_COMBO);
        cfont = _list_get_cobject(cm,GTK_FONT_COMBO(cfnc->widget)->font);
       	if (!cfont) cfont = _register_object(cm, GTK_FONT_COMBO(cfnc->widget)->font,
       		GDK_OBJECT_FONT, NULL,	(coDestructor)gdk_object_font_destructor);
	if (cfont) _clip_mclone(cm,RETPTR(cm),&cfont->obj);
	return 0;
err:
	return 1;
}
