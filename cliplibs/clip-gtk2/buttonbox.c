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

/*********************** SIGNALS **************************/

/* Button Box has no signals */

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_button_box() { return GTK_TYPE_BUTTON_BOX; }
CLIP_DLLEXPORT GtkType _gtk_type_hbutton_box() { return gtk_hbutton_box_get_type(); }
CLIP_DLLEXPORT GtkType _gtk_type_vbutton_box() { return gtk_vbutton_box_get_type(); }

long _clip_type_button_box() { return GTK_WIDGET_BUTTON_BOX; }
long _clip_type_hbutton_box() { return GTK_WIDGET_HBUTTON_BOX; }
long _clip_type_vbutton_box() { return GTK_WIDGET_VBUTTON_BOX; }

const char * _clip_type_name_button_box()  { return "GTK_WIDGET_BUTTON_BOX"; }
const char * _clip_type_name_hbutton_box() { return "GTK_WIDGET_HBUTTON_BOX"; }
const char * _clip_type_name_vbutton_box() { return "GTK_WIDGET_VBUTTON_BOX"; }

/* Register button boxes in global table */
int
clip_INIT___BUTTONBOX(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_button_box,  _clip_type_name_button_box,  _gtk_type_button_box,  _gtk_type_box, NULL);
	_wtype_table_put(_clip_type_hbutton_box, _clip_type_name_hbutton_box, _gtk_type_hbutton_box, _gtk_type_button_box, NULL);
	_wtype_table_put(_clip_type_vbutton_box, _clip_type_name_vbutton_box, _gtk_type_vbutton_box, _gtk_type_button_box, NULL);
	return 0;
}

/* Retrieves how much space a button box is placing between each child
   button. */
int
clip_GTK_BUTTONBOXGETSPACING(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        _clip_retni(cm,gtk_button_box_get_spacing(GTK_BUTTON_BOX(cbbox->widget)));
	return 0;
err:
	return 1;
}

/* Retrieves the method being used to arrange the buttons in a button box. */
int
clip_GTK_BUTTONBOXGETLAYOUT(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        _clip_retni(cm,gtk_button_box_get_layout(GTK_BUTTON_BOX(cbbox->widget)));
	return 0;
err:
	return 1;
}

/* Retrieves the current width and height of all child widgets in a button box.
   min_width and min_height are filled with those values, respectively. */
int
clip_GTK_BUTTONBOXGETCHILDSIZE(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        gint min_width, min_height;
        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        gtk_button_box_get_child_size(GTK_BUTTON_BOX(cbbox->widget),&min_width,&min_height);
	_clip_storni(cm,min_width,2,0);
	_clip_storni(cm,min_height,3,0);
	return 0;
err:
	return 1;
}

/* Gets the default number of pixels that pad the buttons in a given
   button box. */
int
clip_GTK_BUTTONBOXGETCHILDIPADDING(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        gint ipad_x, ipad_y;
        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        gtk_button_box_get_child_ipadding(GTK_BUTTON_BOX(cbbox->widget),&ipad_x,&ipad_y);
	_clip_storni(cm,ipad_x,2,0);
	_clip_storni(cm,ipad_y,3,0);
	return 0;
err:
	return 1;
}

/* Sets the amount of spacing between buttons in a given button box. */
int
clip_GTK_BUTTONBOXSETSPACING(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        gint    spacing = _clip_parni(cm,2);
        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        CHECKOPT(2,NUMERIC_t);
        gtk_button_box_set_spacing(GTK_BUTTON_BOX(cbbox->widget),spacing);
        return 0;
err:
        return 1;
}

/* Changes the way buttons are arranged in their container. */
int
clip_GTK_BUTTONBOXSETLAYOUT(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        GtkButtonBoxStyle layout_style = _clip_parni(cm,2);
        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        CHECKOPT(2,NUMERIC_t);
        gtk_button_box_set_layout(GTK_BUTTON_BOX(cbbox->widget),layout_style);
        return 0;
err:
        return 1;
}

/* Sets a new default size for the children of a given button box. */
int
clip_GTK_BUTTONBOXSETCHILDSIZE(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        gint  min_width = _clip_parni(cm,2);
        gint min_height = _clip_parni(cm,3);
        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_button_box_set_child_size(GTK_BUTTON_BOX(cbbox->widget),
        	min_width,min_height);
        return 0;
err:
        return 1;
}

/* Changes the amount of internal padding used by all buttons in a given
   button box. */
int
clip_GTK_BUTTONBOXSETCHILDIPADDING(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        gint     ipad_x = _clip_parni(cm,2);
        gint     ipad_y = _clip_parni(cm,3);
        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_button_box_set_child_ipadding(GTK_BUTTON_BOX(cbbox->widget),
        	ipad_x, ipad_y);
        return 0;
err:
        return 1;
}
int
clip_GTK_BUTTONBOXSETCHILDSECONDARY(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        C_widget  *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gboolean is_secondary = BOOL_OPTION(cm, 3, 1);

        CHECKARG2(1,NUMERIC_t, MAP_t);CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);
        CHECKARG2(2,NUMERIC_t, MAP_t);CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKARG(3,LOGICAL_t);

        gtk_button_box_set_child_secondary(GTK_BUTTON_BOX(cbbox->widget),
        	GTK_WIDGET(cwid->widget), is_secondary );
        return 0;
err:
        return 1;
}

/**** ------------------ ****/
/**** VBUTTONBOX constructor ****/
int
clip_GTK_VBUTTONBOXNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
        wid = gtk_vbutton_box_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/


/**** ------------------ ****/
/**** HBUTTONBOX constructor ****/
int
clip_GTK_HBUTTONBOXNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
        wid = gtk_hbutton_box_new();
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Retrieves the current default spacing for horizontal button boxes. This
   is the number of pixels to be placed between the buttons when they are
   arranged. */
int
clip_GTK_HBUTTONBOXGETSPACINGDEFAULT(ClipMachine * cm)
{
	_clip_retni(cm,gtk_hbutton_box_get_spacing_default());
        return 0;
}

/* Changes the default spacing that is placed between widgets in an
   horizontal button box. */
int
clip_GTK_HBUTTONBOXSETSPACINGDEFAULT(ClipMachine * cm)
{
        gint spacing = _clip_parni(cm,1);
        CHECKOPT(1,NUMERIC_t);
        gtk_hbutton_box_set_spacing_default(spacing);
        return 0;
err:
        return 1;
}

/* Retrieves the current layout used to arrange buttons in button box widgets. */
int
clip_GTK_HBUTTONBOXGETLAYOUTDEFAULT(ClipMachine * cm)
{
	_clip_retni(cm,gtk_hbutton_box_get_layout_default());
        return 0;
}

/* Sets a new layout mode that will be used by all button boxes. */
int
clip_GTK_HBUTTONBOXSETLAYOUTDEFAULT(ClipMachine * cm)
{
        gint spacing = _clip_parni(cm,1);
        CHECKOPT(1,NUMERIC_t);
        gtk_hbutton_box_set_layout_default(spacing);
        return 0;
err:
        return 1;
}


#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
int
clip_GTK_BUTTONBOXGETCHILDSECONDARY(ClipMachine * cm)
{
	C_widget *cbbox = _fetch_cw_arg(cm);
        ClipVar     *cv = _clip_spar(cm, 2);
        C_widget  *cwid ;
        GtkWidget  *wid = 0;

        CHECKCWID(cbbox,GTK_IS_BUTTON_BOX);

        _clip_retl(cm, gtk_button_box_get_child_secondary(GTK_BUTTON_BOX(cbbox->widget),
        	wid));
	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (cwid) _clip_mclone(cm, cv, &cwid->obj);
        }
        return 0;
err:
        return 1;
}

#endif
