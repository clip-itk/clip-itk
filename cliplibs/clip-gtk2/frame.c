/*
    Copyright (C) 2001-2004  ITK
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

/* Frame has no signals */

/* AspectFrame has no signals */

/**********************************************************/

/* Register frame in global table */
CLIP_DLLEXPORT GtkType _gtk_type_frame() { return GTK_TYPE_FRAME; }
long _clip_type_frame() { return GTK_WIDGET_FRAME; }
const char * _clip_type_name_frame() { return "GTK_WIDGET_FRAME"; }

CLIP_DLLEXPORT GtkType _gtk_type_aspect_frame() { return GTK_TYPE_ASPECT_FRAME; }
long _clip_type_aspect_frame() { return GTK_WIDGET_ASPECT_FRAME; }
const char * _clip_type_name_aspect_frame() { return "GTK_WIDGET_ASPECT_FRAME"; }

int
clip_INIT___FRAME(ClipMachine *cm)
{
	//_wtype_table_put(_clip_type_frame, _clip_type_name_frame, _gtk_type_frame, _gtk_type_container, NULL);
	_wtype_table_put(_clip_type_frame, _clip_type_name_frame, _gtk_type_frame, _gtk_type_bin, NULL);
	_wtype_table_put(_clip_type_aspect_frame, _clip_type_name_aspect_frame, _gtk_type_aspect_frame, _gtk_type_frame, NULL);
	return 0;
}
int
clip_GTK_FRAMENEW(ClipMachine * cm)
{
	ClipVar * cv       = _clip_spar(cm, 1);
	gchar *label = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t); CHECKOPT(2,CHARACTER_t);

	LOCALE_TO_UTF(label);
	wid = gtk_frame_new(label);
        FREE_TEXT(label);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Set the text of the label. If label is NULL, the current label, if
   any, is removed. */
int
clip_GTK_FRAMESETLABEL(ClipMachine * cm)
{
	C_widget *cframe = _fetch_cw_arg(cm);
	gchar *label = _clip_parc(cm, 2);
	CHECKCWID(cframe,GTK_IS_FRAME);
	CHECKOPT(2,CHARACTER_t);
        LOCALE_TO_UTF(label);
        gtk_frame_set_label(GTK_FRAME(cframe->widget), label);
	FREE_TEXT(label);

	return 0;
err:
	return 1;
}

int
clip_GTK_FRAMESETLABELWIDGET(ClipMachine * cm)
{
	C_widget *cframe = _fetch_cw_arg(cm);
	C_widget   *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKCWID(cframe,GTK_IS_FRAME);
	CHECKCWID(cwid, GTK_IS_FRAME);

        gtk_frame_set_label_widget(GTK_FRAME(cframe->widget), GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

/* Set the alignment of the Frame widget's label. The default value for a
   newly created Frame is 0.0.

   frame : The Frame widget.
  xalign : The position of the label along the top edge of the widget. A
           value of 0.0 represents left alignment; 1.0 represents right
           alignment.
  yalign : The y alignment of the label. Currently ignored. */
int
clip_GTK_FRAMESETLABELALIGN(ClipMachine * cm)
{
	C_widget *cframe = _fetch_cw_arg(cm);
	gfloat    xalign = _clip_parnd(cm, 2);
	gfloat    yalign = _clip_parnd(cm, 2);
	CHECKCWID(cframe,GTK_IS_FRAME);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_frame_set_label_align(GTK_FRAME(cframe->widget), xalign, yalign);

	return 0;
err:
	return 1;
}

/* Set the shadow type for the Frame widget. */
int
clip_GTK_FRAMESETSHADOWTYPE(ClipMachine * cm)
{
	C_widget   *cframe = _fetch_cw_arg(cm);
	GtkShadowType type = _clip_parni(cm, 2);
	CHECKCWID(cframe,GTK_IS_FRAME);
	CHECKOPT(2,NUMERIC_t);
        gtk_frame_set_shadow_type(GTK_FRAME(cframe->widget), type);

	return 0;
err:
	return 1;
}

int
clip_GTK_FRAMEGETLABEL(ClipMachine * cm)
{
	C_widget   *cframe = _fetch_cw_arg(cm);
        gchar       *label ;

	CHECKCWID(cframe,GTK_IS_FRAME);
        label = (gchar *)gtk_frame_get_label(GTK_FRAME(cframe->widget));
        LOCALE_FROM_UTF(label);
        _clip_retc(cm, label);
        FREE_TEXT(label);

	return 0;
err:
	return 1;
}

int
clip_GTK_FRAMEGETLABELALIGN(ClipMachine * cm)
{
	C_widget   *cframe = _fetch_cw_arg(cm);
        gfloat        x, y ;

	CHECKCWID(cframe,GTK_IS_FRAME);

        gtk_frame_get_label_align(GTK_FRAME(cframe->widget), &x, &y);

	_clip_stornd(cm, x, 2, 0);
        _clip_stornd(cm, y, 3, 0);
	return 0;
err:
	return 1;
}

int
clip_GTK_FRAMEGETLABELWIDGET(ClipMachine * cm)
{
	C_widget   *cframe = _fetch_cw_arg(cm);
        GtkWidget     *wid ;
        C_widget     *cwid ;

	CHECKCWID(cframe,GTK_IS_FRAME);

        wid = gtk_frame_get_label_widget(GTK_FRAME(cframe->widget));

	if (wid)
        {
        	cwid = _list_get_cwidget(cm, wid);
                if (!cwid) cwid = _register_widget(cm, wid, NULL);
                if (wid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_FRAMEGETSHADOWTYPE(ClipMachine * cm)
{
	C_widget   *cframe = _fetch_cw_arg(cm);

	CHECKCWID(cframe,GTK_IS_FRAME);

        _clip_retni(cm, (int)gtk_frame_get_shadow_type(GTK_FRAME(cframe->widget)));

	return 0;
err:
	return 1;
}

/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/

/* Create a new GtkAspectFrame.

      label : Label text.
     xalign : Horizontal alignment of the child within the allocation of
              the GtkAspectFrame. This ranges from 0.0 (left aligned) to 1.0 (right
              aligned)
     yalign : Vertical alignment of the child within the allocation of the
              GtkAspectFrame. This ranges from 0.0 (left aligned) to 1.0 (right
              aligned)
      ratio : The desired aspect ratio.
 obey_child : If TRUE, ratio is ignored, and the aspect ratio is taken
              from the requistion of the child.
    Returns : the new GtkAspectFrame. */
int
clip_GTK_ASPECTFRAMENEW(ClipMachine * cm)
{
	ClipVar * cv       = _clip_spar(cm, 1);
	gchar *label       = _clip_parc(cm, 2);
        gfloat      xalign = _clip_parnd(cm, 3);
        gfloat      yalign = _clip_parnd(cm, 4);
        gfloat       ratio = _clip_parnd(cm, 5);
        gboolean obey_child= _clip_parl(cm,6);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t); CHECKOPT(2,CHARACTER_t);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
	CHECKOPT(5,NUMERIC_t); CHECKOPT(6,LOGICAL_t);

        if (_clip_parinfo(cm,5)==UNDEF_t) ratio = 1;
        if (_clip_parinfo(cm,6)==UNDEF_t) obey_child = TRUE;

	LOCALE_TO_UTF(label);
	wid = gtk_aspect_frame_new(label,xalign,yalign,ratio,obey_child);
        FREE_TEXT(label);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Set parameters for an existing GtkAspectFrame. */
int
clip_GTK_ASPECTFRAMESET(ClipMachine * cm)
{
	C_widget *cframe = _fetch_cw_arg(cm);
        gfloat      xalign = _clip_parnd(cm, 2);
        gfloat      yalign = _clip_parnd(cm, 3);
        gfloat       ratio = _clip_parnd(cm, 4);
        gboolean obey_child= _clip_parl(cm,5);
	CHECKCWID(cframe,GTK_IS_FRAME);
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
	CHECKOPT(4,NUMERIC_t); CHECKOPT(5,LOGICAL_t);

        if (_clip_parinfo(cm,4)==UNDEF_t) ratio = 1;
        if (_clip_parinfo(cm,5)==UNDEF_t) obey_child = TRUE;

        gtk_aspect_frame_set(GTK_ASPECT_FRAME(cframe->widget),
        	xalign,yalign,ratio,obey_child);

	return 0;
err:
	return 1;
}

