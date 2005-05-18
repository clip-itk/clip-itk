/*
    Copyright (C) 2003 - 2005  ITK
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
	ClipVar *cvgdkimg = _clip_spar(cm, 2);
	ClipVar *cvbitmap = _clip_spar(cm, 3);
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
		if (!cgdkimg) cgdkimg = _register_object(cm,gdkimg,GDK_TYPE_IMAGE, cvgdkimg, NULL);
		if (cgdkimg) _clip_mclone(cm, cvgdkimg,&cgdkimg->obj);
        }

	if (mask)
        {
        	cbitmap = _list_get_cobject(cm, mask);
		if (!cbitmap) cbitmap = _register_object(cm,mask,GDK_TYPE_BITMAP, cvbitmap, NULL);
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
		if (!cpixmap) cpixmap = _register_object(cm,pixmap,GDK_TYPE_PIXMAP, cvpixmap, NULL);
		if (cpixmap) _clip_mclone(cm, cvpixmap,&cpixmap->obj);
        }

	if (mask)
        {
        	cbitmap = _list_get_cobject(cm, mask);
		if (!cbitmap) cbitmap = _register_object(cm,mask,GDK_TYPE_BITMAP, cvbitmap, NULL);
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

int
clip_GTK_IMAGESETFROMFILE(ClipMachine * cm)
{
	C_widget *cimg = _fetch_cw_arg(cm);
        gchar    *file = _clip_parc(cm, 2);

	CHECKCWID(cimg,GTK_IS_IMAGE);
        CHECKARG(2, CHARACTER_t);

	gtk_image_set_from_file(GTK_IMAGE(cimg->widget), file);

	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGESETFROMIMAGE(ClipMachine * cm)
{
	C_widget *cimg = _fetch_cw_arg(cm);
	C_object *cgdkimg = _fetch_cobject(cm, _clip_par(cm, 2));
	C_object *cbitmap = _fetch_cobject(cm, _clip_par(cm, 3));

	CHECKCWID(cimg,GTK_IS_IMAGE);
        CHECKCOBJOPT(cgdkimg, GDK_IS_IMAGE(cgdkimg->object));
        CHECKCOBJOPT(cbitmap, GDK_IS_BITMAP(cbitmap));

	gtk_image_set_from_image(GTK_IMAGE(cimg->widget),
        	(cgdkimg)?GDK_IMAGE(cgdkimg->object):NULL,
                (cbitmap)?GDK_BITMAP(cbitmap->object):NULL);

	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGESETFROMPIXBUF(ClipMachine * cm)
{
	C_widget *cimg = _fetch_cw_arg(cm);
	C_object *cpixbuf = _fetch_cobject(cm, _clip_par(cm, 2));

	CHECKCWID(cimg,GTK_IS_IMAGE);
        CHECKCOBJOPT(cpixbuf, GDK_IS_PIXBUF(cpixbuf->object));


	gtk_image_set_from_pixbuf(GTK_IMAGE(cimg->widget),
        	(cpixbuf)?GDK_PIXBUF(cpixbuf->object):NULL);
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGESETFROMSTOCK(ClipMachine * cm)
{
	C_widget *cimg   = _fetch_cw_arg(cm);
	gchar *stock_id  = _clip_parc(cm, 2);
	GtkIconSize size = _clip_parni(cm, 3);

	CHECKCWID(cimg,GTK_IS_IMAGE);
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, NUMERIC_t);


	gtk_image_set_from_stock(GTK_IMAGE(cimg->widget),
        	stock_id, size);
	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 6)
int
clip_GTK_IMAGEGETICONNAME(ClipMachine * cm)
{
	C_widget *cimg   = _fetch_cw_arg(cm);
	gchar      *name ;
	GtkIconSize size ;

	CHECKCWID(cimg,GTK_IS_IMAGE);


	gtk_image_get_icon_name(GTK_IMAGE(cimg->widget),
        	(G_CONST_RETURN gchar **)&name, &size);

        _clip_storc(cm, name, 2, 0);
        _clip_storni(cm, size, 3, 0);
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGEGETPIXELSIZE(ClipMachine * cm)
{
	C_widget *cimg   = _fetch_cw_arg(cm);

	CHECKCWID(cimg,GTK_IS_IMAGE);


	_clip_retni(cm, gtk_image_get_pixel_size(GTK_IMAGE(cimg->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGESETPIXELSIZE(ClipMachine * cm)
{
	C_widget *cimg   = _fetch_cw_arg(cm);
        gint      size   = _clip_parni(cm, 2);

	CHECKCWID(cimg,GTK_IS_IMAGE);
        CHECKARG(2, NUMERIC_t);

	gtk_image_set_pixel_size(GTK_IMAGE(cimg->widget), size);

	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGENEWFROMICONNAME(ClipMachine * cm)
{
	gchar       *name = _clip_parc(cm, 1);
        GtkIconSize  size = _clip_parni(cm, 2);
	GtkWidget *wid;
        C_widget *cwid;

	CHECKARG(1,CHARACTER_t);
	CHECKARG(2,NUMERIC_t);

	wid = gtk_image_new_from_icon_name((const gchar *)name, size);
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, NULL);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGESETFROMICONNAME(ClipMachine * cm)
{
	C_widget  *cimage = _fetch_cw_arg(cm);
	gchar       *name = _clip_parc(cm, 2);
        GtkIconSize  size = _clip_parni(cm, 3);

	CHECKCWID(cimage, GTK_IS_IMAGE);
	CHECKARG(2,CHARACTER_t);
	CHECKARG(3,NUMERIC_t);

	gtk_image_set_from_icon_name(GTK_IMAGE(cimage->widget), (const gchar *)name, size);

	return 0;
err:
	return 1;
}
#endif
