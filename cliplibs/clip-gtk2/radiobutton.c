/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/

/****           Radio button has no signals            ****/

/**********************************************************/

/* Register radio button in global table */
CLIP_DLLEXPORT GtkType _gtk_type_radio_button() { return GTK_TYPE_RADIO_BUTTON; }
long _clip_type_radio_button() { return GTK_WIDGET_RADIO; }
const char * _clip_type_name_radio_button() { return "GTK_WIDGET_RADIO"; }

CLIP_DLLEXPORT GtkType _gtk_type_radio_group() { return GTK_WIDGET_RADIO_GROUP; }
long _clip_type_radio_group() { return GTK_WIDGET_RADIO_GROUP; }
const char * _clip_type_name_radio_group() { return "GTK_WIDGET_RADIO_GROUP"; }

int
clip_INIT___RADIO_BUTTON(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_radio_button, _clip_type_name_radio_button, _gtk_type_radio_button, _gtk_type_toggle_button, NULL);
	_wtype_table_put(_clip_type_radio_group, _clip_type_name_radio_group, _gtk_type_radio_group, NULL, NULL);
	return 0;
}

/**** Radio button constructor ****/
int
clip_GTK_RADIOBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_widget *cgrp = _fetch_cwidget(cm,_clip_spar(cm, 2));
	char *   label = _clip_parc(cm, 3);
	GtkWidget *wid = NULL;
        C_widget *cwid;
        GtkRadioButton *rb = NULL;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t);
	CHECKOPT(3,CHARACTER_t);

	if (cgrp && cgrp->type != GTK_WIDGET_RADIO_GROUP) goto err;
        if (cgrp && cgrp->data) rb = ((GSList*)(cgrp->data))->data;

	if (_clip_parinfo(cm,3) == CHARACTER_t)
        {
                LOCALE_TO_UTF(label);
		wid = gtk_radio_button_new_with_label_from_widget(rb,label);
		if (cgrp && !cgrp->data) cgrp->data = gtk_radio_button_get_group(GTK_RADIO_BUTTON(wid));
        	FREE_TEXT(label);
        }
        else
        {
        	wid = gtk_radio_button_new_from_widget(rb);
		if (cgrp && !cgrp->data) cgrp->data = gtk_radio_button_get_group(GTK_RADIO_BUTTON(wid));
        }
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/**** Radio group constructor ****/
int
clip_GTK_RADIOGROUPNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

	cwid = _register_widget(cm, NULL, cv);
        cwid->type = _clip_type_radio_group();
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Sets a RadioButton's group. It should be noted that this does not
 * change the layout of your interface in any way, so if you are
 * changing the group, it is likely you will need to re-arrange the
 * user interface to reflect these changes. */

int
clip_GTK_RADIOBUTTONSETGROUP(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
	C_widget *cgrp = _fetch_cwidget(cm,_clip_spar(cm,2));
        GSList * group = NULL;
	CHECKARG2(2,MAP_t,NUMERIC_t);
        CHECKCWID(cbtn,GTK_IS_RADIO_BUTTON);
        if (cgrp && cgrp->type != GTK_WIDGET_RADIO_GROUP) goto err;
	if (cgrp && cgrp->data)
		group = gtk_radio_button_get_group(
			GTK_RADIO_BUTTON(((GSList*)(cgrp->data))->data));
	gtk_radio_button_set_group(GTK_RADIO_BUTTON(cbtn->widget),group);
	if (cgrp && cgrp->data)
		cgrp->data = gtk_radio_button_get_group(GTK_RADIO_BUTTON(cbtn->widget));
        return 0;
err:
	return 1;
}

int
clip_GTK_RADIOBUTTONSETSTYLE(ClipMachine * cm)
{
	C_widget   *cbtn = _fetch_cw_arg(cm);
	ClipVar  *mstyle = _clip_spar(cm,2);
	GtkStyle *style;
        GtkButton *button;
        CHECKCWID(cbtn,GTK_IS_TOGGLE_BUTTON);
	CHECKARG(2,MAP_t);

        button = &(GTK_TOGGLE_BUTTON(cbtn->widget)->button);
	style = gtk_style_copy(GTK_BIN(&(button->bin))->child->style);
        //gtk_style_unref(GTK_BIN(&(button->bin))->child->style);
	_map_to_style(cm, mstyle, style);
	gtk_widget_set_style (GTK_BIN(&(button->bin))->child, style);
	return 0;
err:
	return 1;
}

