/*
    Copyright (C) 2004  ITK
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

/****            Misc has no own signal                ****/

/**********************************************************/

/* Register misc in global table */
CLIP_DLLEXPORT GtkType _gtk_type_misc() { return GTK_TYPE_MISC; }
long _clip_type_misc() { return GTK_WIDGET_MISC; }
const char * _clip_type_name_misc() { return "GTK_WIDGET_MISC"; }

/* Register arrow in global table */
CLIP_DLLEXPORT GtkType _gtk_type_arrow() { return GTK_TYPE_ARROW; }
long _clip_type_arrow() { return GTK_WIDGET_ARROW; }
const char * _clip_type_name_arrow() { return "GTK_WIDGET_ARROW"; }

int
clip_INIT___MISC(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_misc,  _clip_type_name_misc,  _gtk_type_misc, _gtk_type_widget, NULL);
	_wtype_table_put(_clip_type_arrow, _clip_type_name_arrow, _gtk_type_arrow, _gtk_type_misc, NULL);
	return 0;
}
/**********************************************************/

int
clip_GTK_MISCSETALIGNMENT(ClipMachine * cm)
{
	C_widget *cmisc = _fetch_cw_arg(cm);
	gfloat   xalign = _clip_parnd(cm,2);
	gfloat   yalign = _clip_parnd(cm,3);
        CHECKCWID(cmisc,GTK_IS_MISC);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_misc_set_alignment(GTK_MISC(cmisc->widget), xalign,yalign);
	return 0;
err:
	return 1;
}

int
clip_GTK_MISCSETPADDING(ClipMachine * cm)
{
	C_widget *cmisc = _fetch_cw_arg(cm);
	gfloat     xpad = _clip_parnd(cm,2);
	gfloat     ypad = _clip_parnd(cm,3);
        CHECKCWID(cmisc,GTK_IS_MISC);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_misc_set_padding(GTK_MISC(cmisc->widget), xpad,ypad);
	return 0;
err:
	return 1;
}

int
clip_GTK_MISCGETALIGNMENT(ClipMachine * cm)
{
	C_widget *cmisc = _fetch_cw_arg(cm);
	gfloat   xalign ;
	gfloat   yalign ;
        CHECKCWID(cmisc,GTK_IS_MISC);
        gtk_misc_get_alignment(GTK_MISC(cmisc->widget), &xalign, &yalign);
        _clip_storni(cm, xalign, 2, 0);
        _clip_storni(cm, yalign, 3, 0);
	return 0;
err:
	return 1;
}

int
clip_GTK_MISCGETPADDING(ClipMachine * cm)
{
	C_widget *cmisc = _fetch_cw_arg(cm);
	gint       xpad ;
	gint       ypad ;
        CHECKCWID(cmisc,GTK_IS_MISC);
        gtk_misc_get_padding(GTK_MISC(cmisc->widget), &xpad, &ypad);

	_clip_storni(cm, xpad, 2, 0);
        _clip_storni(cm, ypad, 3, 0);
	return 0;
err:
	return 1;
}

/********************************************************************/
/********************************************************************/
/********************************************************************/
/********************************************************************/

/**** Arrow constructor ****/
int
clip_GTK_ARROWNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkArrowType   arrow_type = _clip_parni(cm, 2);
	GtkShadowType shadow_type = _clip_parni(cm, 3);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t); CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);

        wid = gtk_arrow_new(arrow_type,shadow_type);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Sets the direction and style of the GtkArrow */
int
clip_GTK_ARROWSET(ClipMachine * cm)
{
	C_widget          *carrow = _fetch_cw_arg(cm);
	GtkArrowType   arrow_type = _clip_parni(cm, 2);
	GtkShadowType shadow_type = _clip_parni(cm, 3);
        CHECKCWID(carrow,GTK_IS_ARROW);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_arrow_set(GTK_ARROW(carrow->widget), arrow_type,shadow_type);
	return 0;
err:
	return 1;
}

