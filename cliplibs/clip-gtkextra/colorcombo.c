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
static gint
handle_changed_signal (GtkWidget *widget, gint selection, gchar *color_name, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SELECTION, selection);
	_clip_mputc(cs->cw->cmachine, &cv, HASH_COLORNAME, color_name, strlen(color_name));
        INVOKESIGHANDLER(widget,cs,cv);
}
/* Signals table */
static SignalTable color_combo_signals[] =
{
	{"changed",		GSF( handle_changed_signal ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL },
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register ColorCombo in global table */
CLIP_DLLEXPORT GtkType _gtk_type_color_combo() { return gtk_color_combo_get_type(); }
long _clip_type_color_combo() { return GTK_WIDGET_COLOR_COMBO; }
const char * _clip_type_name_color_combo() { return "GTK_WIDGET_COLOR_COMBO"; }

int
clip_INIT___COLOR_COMBO(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_color_combo, _clip_type_name_color_combo, _gtk_type_color_combo, _gtk_type_combo_box, color_combo_signals);
	return 0;
}

/**** COLOR COMBO constructors ****/
int
clip_GTK_COLORCOMBONEW(ClipMachine * cm)
{
	ClipVar     * cv = _clip_spar (cm,1);
	GtkWidget *wid = NULL;
        C_widget *cwid, *cbutton, *ctable;

	CHECKOPT(1,MAP_t);

	wid = gtk_color_combo_new();

        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        cbutton = _register_widget(cm, GTK_COMBO_BOX(wid)->button, NULL);
        ctable = _register_widget(cm, GTK_COLOR_COMBO(wid)->table, NULL);
        _clip_madd(cm, &cwid->obj, HASH_BUTTON, &cbutton->obj);
        _clip_madd(cm, &cwid->obj, HASH_TABLE, &ctable->obj);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
int
clip_GTK_COLORCOMBONEWWITHVALUES(ClipMachine * cm)
{
	ClipVar     * cv = _clip_spar (cm,1);
        gint       nrows = _clip_parni(cm,2);
        gint       ncols = _clip_parni(cm,3);
        ClipVar *cvalues = _clip_spar (cm,4);
	GtkWidget *wid = NULL;
        C_widget *cwid, *cbutton, *ctable;

	CHECKOPT(1,MAP_t); CHECKARG(2,NUMERIC_t); CHECKARG(3,NUMERIC_t); CHECKARG(4,ARRAY_t);

	if (_clip_parinfo(cm,4) == ARRAY_t)
        {
        	unsigned short i;
                ClipVar *item;
        	gchar **color_names = NULL;
                if (cvalues->a.count > 0)
                {
        		color_names = (gchar**)calloc(sizeof(gchar*),cvalues->a.count);
        		for (i=0; i < cvalues->a.count; i++)
                	{
				item = cvalues->a.items + i;
                        	if (item->t.type == CHARACTER_t)
                                {
                                	color_names[i] = (gchar*)calloc(1,item->s.str.len+1);
					strcpy(color_names[i],item->s.str.buf);
                                }
                	}
                        if (color_names)
                        	wid = gtk_color_combo_new_with_values(nrows,ncols,color_names);
                }
        }

        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        cbutton = _register_widget(cm, GTK_COMBO_BOX(wid)->button, NULL);
        ctable = _register_widget(cm, GTK_COLOR_COMBO(wid)->table, NULL);
        _clip_madd(cm, &cwid->obj, HASH_BUTTON, &cbutton->obj);
        _clip_madd(cm, &cwid->obj, HASH_TABLE, &ctable->obj);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_COLORCOMBOGETCOLORAT(ClipMachine * cm)
{
	C_widget  *cclc = _fetch_cw_arg(cm);
        gint        row = INT_OPTION(cm,2,1);
        gint        col = INT_OPTION(cm,3,1);
        CHECKCWID(cclc,GTK_IS_COLOR_COMBO);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        _clip_retc(cm,gtk_color_combo_get_color_at(GTK_COLOR_COMBO(cclc->widget),row-1,col-1));
	return 0;
err:
	return 1;
}

int
clip_GTK_COLORCOMBOFINDCOLOR(ClipMachine * cm)
{
	C_widget  *cclc = _fetch_cw_arg(cm);
        ClipVar *mcolor = _clip_spar(cm,2);
        gint row,col;
        GdkColor color;
        CHECKCWID(cclc,GTK_IS_COLOR_COMBO);
        CHECKARG(2,MAP_t);
        _map_colors_to_gdk(cm,mcolor,&color);
        gtk_color_combo_find_color(GTK_COLOR_COMBO(cclc->widget),&color,&row,&col);
        _clip_storni(cm,row+1,3,0);
        _clip_storni(cm,col+1,4,0);
	return 0;
err:
	return 1;
}

