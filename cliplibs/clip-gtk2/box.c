/*
    Copyright (C) 2001 - 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
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

/* Box has no signals */

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_box() { return GTK_TYPE_BOX; }
CLIP_DLLEXPORT GtkType _gtk_type_hbox() { return GTK_TYPE_HBOX; }
CLIP_DLLEXPORT GtkType _gtk_type_vbox() { return GTK_TYPE_VBOX; }

long _clip_type_box() { return GTK_WIDGET_BOX; }
long _clip_type_hbox() { return GTK_WIDGET_HBOX; }
long _clip_type_vbox() { return GTK_WIDGET_VBOX; }

const char * _clip_type_name_box()  { return "GTK_WIDGET_BOX"; }
const char * _clip_type_name_hbox() { return "GTK_WIDGET_HBOX"; }
const char * _clip_type_name_vbox() { return "GTK_WIDGET_VBOX"; }

/* Register boxes in global table */
int
clip_INIT___BOX(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_box,  _clip_type_name_box,  _gtk_type_box,  _gtk_type_container, NULL);
	_wtype_table_put(_clip_type_hbox, _clip_type_name_hbox, _gtk_type_hbox, _gtk_type_box, NULL);
	_wtype_table_put(_clip_type_vbox, _clip_type_name_vbox, _gtk_type_vbox, _gtk_type_box, NULL);
	return 0;
}

/**** ------------------ ****/
/**** HBOX constructor ****/
int
clip_GTK_HBOXNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	gboolean homogeneous = _clip_parl(cm, 2);
	gint spacing   = _clip_parni(cm, 3);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,LOGICAL_t);
	CHECKOPT(3,NUMERIC_t);
        wid = gtk_hbox_new(homogeneous,spacing);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/**** VBOX constructor ****/
int
clip_GTK_VBOXNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	gboolean homogeneous = _clip_parl(cm, 2);
	gint spacing   = _clip_parni(cm, 3);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,LOGICAL_t);
	CHECKOPT(3,NUMERIC_t);
        wid = gtk_vbox_new(homogeneous,spacing);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Adds child to box, packed with reference to the start of box.
 * The child is packed after any other child packed with
 * reference to the start of box. */
int
clip_GTK_BOXPACKSTART(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm,_clip_spar(cm,2));
        gboolean expand = _clip_parl(cm,3);
        gboolean   fill = _clip_parl(cm,4);
        guint      padd = _clip_parni(cm,5);
        CHECKCWID(cbox,GTK_IS_BOX);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT(3,LOGICAL_t);CHECKOPT(4,LOGICAL_t);CHECKOPT(5,NUMERIC_t);
        gtk_box_pack_start(GTK_BOX(cbox->widget), cwid->widget, expand, fill, padd);
	return 0;
err:
	return 1;
}

/* Adds child to box, packed with reference to the end of box.
 *The child is packed after (away from end of) any other child
 * packed with reference to the end of box. */
int
clip_GTK_BOXPACKEND(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm,_clip_spar(cm,2));
        gboolean expand = _clip_parl(cm,3);
        gboolean   fill = _clip_parl(cm,4);
        guint      padd = _clip_parni(cm,5);
        CHECKCWID(cbox,GTK_IS_BOX);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT(3,LOGICAL_t);
	CHECKOPT(4,LOGICAL_t);
	CHECKOPT(5,NUMERIC_t);
        gtk_box_pack_end(GTK_BOX(cbox->widget), cwid->widget, expand, fill, padd);
	return 0;
err:
	return 1;
}

/* Adds widget to box, packed with reference to the start of box.
 * The child is packed after any other child packed with reference
 * to the start of box.
 * Parameters for how to pack the child widget, expand, fill, and
 * padding in GtkBoxChild, are given their default values,
 * TRUE, TRUE, and 0, respectively. */
int
clip_GTK_BOXPACKSTARTDEFAULTS(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cbox,GTK_IS_BOX);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_box_pack_start_defaults(GTK_BOX(cbox->widget), cwid->widget);
	return 0;
err:
	return 1;
}

/* Adds widget to box, packed with reference to the end of box.
 * The child is packed after (away from end of) any other child
 * packed with reference to the end of box.
 * Parameters for how to pack the child widget, expand, fill, and
 * padding in GtkBoxChild, are given their default values,
 * TRUE, TRUE, and 0, respectively. */
int
clip_GTK_BOXPACKENDDEFAULTS(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm,_clip_spar(cm,2));
        CHECKCWID(cbox,GTK_IS_BOX);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_box_pack_end_defaults(GTK_BOX(cbox->widget), cwid->widget);
	return 0;
err:
	return 1;
}

/* Sets the homogeneous field of GtkBox, controlling whether or not all
 * children of box are given equal space in the box. */
int
clip_GTK_BOXSETHOMOGENEOUS(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
	gboolean homogeneous  = _clip_parl(cm,2);
	CHECKOPT(2,LOGICAL_t);
        CHECKCWID(cbox,GTK_IS_BOX);
        if (_clip_parinfo(cm,2)==UNDEF_t) homogeneous = TRUE;
        gtk_box_set_homogeneous(GTK_BOX(cbox->widget), homogeneous);
	return 0;
err:
	return 1;
}

int
clip_GTK_BOXGETHOMOGENEOUS(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
        CHECKCWID(cbox,GTK_IS_BOX);
        _clip_retl(cm, gtk_box_get_homogeneous(GTK_BOX(cbox->widget)));
	return 0;
err:
	return 1;
}

/* Sets the spacing field of GtkBox, which is the number of pixels
 * to place between children of box. */
int
clip_GTK_BOXSETSPACING(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
	gint   spacing  = _clip_parni(cm,2);
	CHECKOPT(2,NUMERIC_t);
        CHECKCWID(cbox,GTK_IS_BOX);
        gtk_box_set_spacing(GTK_BOX(cbox->widget), spacing);
	return 0;
err:
	return 1;
}

/* Moves child to a new position in the list of box children.
 * The list is the children field of GtkBox, and contains both
 * widgets packed GTK_PACK_START as well as widgets packed
 * GTK_PACK_END, in the order that these widgets were added to box.
 *
 * A widget's position in the box children list determines where the
 * widget is packed into box. A child widget at some position in the
 * list will be packed just after all other widgets of the same packing
 *  type that appear earlier in the list. A negative value of position
 * is interpreted as position 0. */
int
clip_GTK_BOXREORDERCHILD(ClipMachine * cm)
{
	C_widget *cbox = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	gint  position = _clip_parni(cm,3);
        CHECKCWID(cbox,GTK_IS_BOX);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT(3,NUMERIC_t);
        gtk_box_reorder_child(GTK_BOX(cbox->widget), cwid->widget, position);
	return 0;
err:
	return 1;
}

/* Returns information about how child is packed into box. */
int
clip_GTK_BOXQUERYCHILDPACKING(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm,_clip_spar(cm,2));
        gboolean expand, fill;
        gint padding;
        GtkPackType pack_type;
        CHECKCWID(cbox,GTK_IS_BOX);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        gtk_box_query_child_packing(GTK_BOX(cbox->widget), cwid->widget,
        	&expand, &fill, &padding, &pack_type);
        _clip_storl(cm,expand,3,0);
        _clip_storl(cm,fill,4,0);
        _clip_storni(cm,padding,5,0);
        _clip_storni(cm,pack_type,6,0);
	return 0;
err:
	return 1;
}

int
clip_GTK_BOXSETCHILDPACKING(ClipMachine * cm)
{
	C_widget *cbox  = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm,_clip_spar(cm,2));
        gboolean expand = _clip_parl(cm, 3);
        gboolean   fill = _clip_parl(cm, 4);
        gint    padding = _clip_parni(cm, 5);
        GtkPackType pack_type = _clip_parni(cm, 6);
        CHECKCWID(cbox,GTK_IS_BOX);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKARG(3, LOGICAL_t); CHECKARG(4, LOGICAL_t);
        CHECKARG(5, NUMERIC_t); CHECKARG(6, NUMERIC_t);
        gtk_box_set_child_packing(GTK_BOX(cbox->widget), cwid->widget,
        	expand, fill, padding, pack_type);
	return 0;
err:
	return 1;
}


