/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
/*   no owner signals                                     */
/**********************************************************/

/* Register image menu item signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_image_menu_item() { return GTK_TYPE_IMAGE_MENU_ITEM; }
long _clip_type_image_menu_item() { return GTK_WIDGET_IMAGE_MENU_ITEM; }
const char * _clip_type_name_image_menu_item() { return "GTK_WIDGET_IMAGE_MENU_ITEM"; }

int
clip_INIT___IMAGE_MENU_ITEM(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_image_menu_item, _clip_type_name_image_menu_item, _gtk_type_image_menu_item, _gtk_type_menu_item, NULL);
	return 0;
}

/**********************************************************/

int
clip_GTK_IMAGEMENUITEMSETIMAGE(ClipMachine * cm)
{
	C_widget *cimgitem = _fetch_cw_arg(cm);
        C_widget   *cimage = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCWID(cimgitem, GTK_IS_IMAGE_MENU_ITEM);
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCWID(cimage, GTK_IS_WIDGET);

	gtk_image_menu_item_set_image(GTK_IMAGE_MENU_ITEM(cimgitem->widget),
		GTK_WIDGET(cimage->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGEMENUITEMGETIMAGE(ClipMachine * cm)
{
	C_widget *cimgitem = _fetch_cw_arg(cm);
        C_widget   *cimage ;
        GtkWidget   *image ;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCWID(cimgitem, GTK_IS_IMAGE_MENU_ITEM);

	image = gtk_image_menu_item_get_image(GTK_IMAGE_MENU_ITEM(cimgitem->widget));

	if (image)
        {
        	cimage = _list_get_cwidget(cm, image);
                if (!cimage) cimage = _register_widget(cm, image, NULL);
                if (cimage) _clip_mclone(cm, RETPTR(cm), &cimage->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGEMENUITEMNEW(ClipMachine * cm)
{
	ClipVar        *cv = _clip_spar(cm, 1);
        C_widget   *cimage ;
        GtkWidget   *image ;

	CHECKOPT(1,MAP_t);

	image = gtk_image_menu_item_new();

	if (image)
        {
        	cimage = _list_get_cwidget(cm, image);
                if (!cimage) cimage = _register_widget(cm, image, cv);
                if (cimage) _clip_mclone(cm, RETPTR(cm), &cimage->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGEMENUITEMNEWFROMSTOCK(ClipMachine * cm)
{
	ClipVar        *cv = _clip_spar(cm, 1);
        gchar    *stock_id = _clip_parc(cm, 2);
        C_widget  *accelgr = _fetch_cwidget(cm, _clip_spar(cm, 3));
        C_widget   *cimage ;
        GtkWidget   *image ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);
        CHECKOPT2(3, MAP_t, NUMERIC_t); CHECKCWIDOPT(accelgr, GTK_IS_ACCEL_GROUP);

	image = gtk_image_menu_item_new_from_stock(stock_id,
		(accelgr != NULL)?GTK_ACCEL_GROUP(accelgr->widget):NULL);

	if (image)
        {
        	cimage = _list_get_cwidget(cm, image);
                if (!cimage) cimage = _register_widget(cm, image, cv);
                if (cimage) _clip_mclone(cm, RETPTR(cm), &cimage->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGEMENUITEMNEWWITHLABEL(ClipMachine * cm)
{
	ClipVar        *cv = _clip_spar(cm, 1);
        gchar       *label = _clip_parc(cm, 2);
        C_widget   *cimage ;
        GtkWidget   *image ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(label);
	image = gtk_image_menu_item_new_with_label(label);

	if (image)
        {
        	cimage = _list_get_cwidget(cm, image);
                if (!cimage) cimage = _register_widget(cm, image, cv);
                if (cimage) _clip_mclone(cm, RETPTR(cm), &cimage->obj);
        }
        FREE_TEXT(label);
	return 0;
err:
	return 1;
}

int
clip_GTK_IMAGEMENUITEMNEWWITHMNEMONIC(ClipMachine * cm)
{
	ClipVar        *cv = _clip_spar(cm, 1);
        gchar       *label = _clip_parc(cm, 2);
        C_widget   *cimage ;
        GtkWidget   *image ;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(label);
	image = gtk_image_menu_item_new_with_mnemonic(label);

	if (image)
        {
        	cimage = _list_get_cwidget(cm, image);
                if (!cimage) cimage = _register_widget(cm, image, cv);
                if (cimage) _clip_mclone(cm, RETPTR(cm), &cimage->obj);
        }
        FREE_TEXT(label);
	return 0;
err:
	return 1;
}


