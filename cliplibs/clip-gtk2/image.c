/*
    Copyright (C) 2003  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/****        Image has no own signals and events       ****/

/****      insert Image to GtkEventBox for eventig     ****/

/**********************************************************/

/* Register Paned in global table */
CLIP_DLLEXPORT GtkType _gtk_type_image() { return GTK_TYPE_IMAGE; }

long _clip_type_image() { return GTK_WIDGET_IMAGE; }

const char * _clip_type_name_image() { return "GTK_WIDGET_IMAGE"; }

int
clip_INIT___IMAGE(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_image,  _clip_type_name_image,  _gtk_type_image, NULL, NULL);
	return 0;
}

int
clip_GTK_IMAGENEWFROMFILE(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	gchar *filename  = _clip_parc(cm, 2);
	GtkWidget *wid;
        C_widget *cwid;

	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	wid = gtk_image_new_from_file(filename);
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGENEWFROMSTOCK(ClipMachine * cm)
{
	ClipVar * cv      = _clip_spar(cm, 1);
	gchar *stock_id   = _clip_parc(cm, 2);
        GtkIconSize size  = _clip_parni(cm, 3);
	GtkWidget *wid;
        C_widget *cwid;

	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);
        CHECKOPT(3, NUMERIC_t);

	wid = gtk_image_new_from_stock(stock_id, size);
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Creates a new empty widget */

int
clip_GTK_IMAGENEW(ClipMachine * cm)
{
	ClipVar * cv      = _clip_spar(cm, 1);
	GtkWidget *wid;
        C_widget *cwid;

	CHECKOPT(1,MAP_t);

	wid = gtk_image_new();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGENEWFROMPIXMAP(ClipMachine * cm)
{
        C_widget *cpixmap = _fetch_cw_arg(cm);
        C_object *cbitmap = _fetch_cobject(cm, _clip_spar(cm, 2));
        GtkWidget *wid;
        C_widget *cwid;

	//CHECKCWID(cimg,GTK_IS_IMAGE);
	//CHECKOPT(1,MAP_t);
	wid = gtk_image_new_from_pixmap((GdkPixmap *)(cpixmap->widget),
		(GdkBitmap *)(cbitmap->object));

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, NULL);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGEGETIMAGE(ClipMachine * cm)
{
	C_widget *cimg = _fetch_cw_arg(cm);
	ClipVar *cvgdkimg = _clip_par(cm, 2);
	ClipVar *cvbitmap = _clip_par(cm, 3);
        C_object *cgdkimg;
        C_object *cbitmap;
        GdkImage *gdkimg;
        GdkBitmap *mask;
        GtkImage *image;

	CHECKCWID(cimg,GTK_IS_IMAGE);
	//CHECKOPT(1,MAP_t);
        image = GTK_IMAGE(cimg->widget);

	gtk_image_get_image(image, &gdkimg, &mask);

	if (gdkimg)
        {
        	cgdkimg = _list_get_cobject(cm, gdkimg);
		if (!cgdkimg) cgdkimg = _register_object(cm,gdkimg,GDK_OBJECT_IMAGE, cvgdkimg, NULL);
		if (cgdkimg) _clip_mclone(cm, cvgdkimg,&cgdkimg->obj);
        }

	if (mask)
        {
        	cbitmap = _list_get_cobject(cm, mask);
		if (!cbitmap) cbitmap = _register_object(cm,mask,GDK_OBJECT_BITMAP, cvbitmap, NULL);
		if (cbitmap) _clip_mclone(cm, cvbitmap, &cbitmap->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGEGETPIXMAP(ClipMachine * cm)
{
	C_widget *cimg = _fetch_cw_arg(cm);
	ClipVar *cvpixmap = _clip_par(cm, 2);
	ClipVar *cvbitmap = _clip_par(cm, 3);
        C_object *cpixmap;
        C_object *cbitmap;
        GdkPixmap *pixmap;
        GdkBitmap *mask;
        GtkImage *image;

	CHECKCWID(cimg,GTK_IS_IMAGE);
	//CHECKOPT(1,MAP_t);
        image = GTK_IMAGE(cimg->widget);

	gtk_image_get_pixmap(image, &pixmap, &mask);

	if (pixmap)
        {
        	cpixmap = _list_get_cobject(cm, pixmap);
		if (!cpixmap) cpixmap = _register_object(cm,pixmap,GDK_OBJECT_PIXMAP, cvpixmap, NULL);
		if (cpixmap) _clip_mclone(cm, cvpixmap,&cpixmap->obj);
        }

	if (mask)
        {
        	cbitmap = _list_get_cobject(cm, mask);
		if (!cbitmap) cbitmap = _register_object(cm,mask,GDK_OBJECT_BITMAP, cvbitmap, NULL);
		if (cbitmap) _clip_mclone(cm, cvbitmap, &cbitmap->obj);
        }

	return 0;
err:
	return 1;
}


int
clip_GTK_IMAGEGETSTORAGETYPE(ClipMachine * cm)
{
	C_widget *cimg = _fetch_cw_arg(cm);
        GtkImageType type;

	CHECKCWID(cimg,GTK_IS_WIDGET);

	type = gtk_image_get_storage_type(GTK_IMAGE(cimg->widget));

        _clip_retni(cm, type);
	return 0;
err:
	return 1;
}


