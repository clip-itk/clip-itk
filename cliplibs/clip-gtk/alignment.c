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

/**********************************************************/
/****            Alignment has no signals              ****/
/**********************************************************/

/* Register menu item signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_alignment()  { return GTK_TYPE_ALIGNMENT; }
long _clip_type_alignment()  { return GTK_WIDGET_ALIGNMENT; }
const char * _clip_type_name_alignment()  { return "GTK_WIDGET_ALIGNMENT"; }

int
clip_INIT___ALIGNMENT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_alignment, _clip_type_name_alignment, _gtk_type_alignment, _gtk_type_container, NULL);
	return 0;
}
/**********************************************************/

/****  Alignment constructor ****/
int
clip_GTK_ALIGNMENTNEW(ClipMachine * cm)
{
	ClipVar * cv  = _clip_spar(cm, 1);
	gfloat xalign = _clip_parnd(cm, 2);
	gfloat yalign = _clip_parnd(cm, 3);
	gfloat xscale = _clip_parnd(cm, 4);
	gfloat yscale = _clip_parnd(cm, 5);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);

	if (_clip_parinfo(cm,4)==UNDEF_t) xscale = 1;
	if (_clip_parinfo(cm,5)==UNDEF_t) yscale = 1;

	wid = gtk_alignment_new(xalign,yalign,xscale,yscale);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

int
clip_GTK_ALIGNMENTSET(ClipMachine * cm)
{
	C_widget *cali = _fetch_cw_arg(cm);
	gfloat  xalign = _clip_parnd(cm, 2);
	gfloat  yalign = _clip_parnd(cm, 3);
	gfloat  xscale = _clip_parnd(cm, 4);
	gfloat  yscale = _clip_parnd(cm, 5);
        CHECKCWID(cali,GTK_IS_ALIGNMENT);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKOPT(4,NUMERIC_t); CHECKOPT(5,NUMERIC_t);

	if (_clip_parinfo(cm,4)==UNDEF_t) xscale = 1;
	if (_clip_parinfo(cm,5)==UNDEF_t) yscale = 1;

        gtk_alignment_set(GTK_ALIGNMENT(cali->widget), xalign,yalign,xscale,yscale);
	return 0;
err:
	return 1;
}

