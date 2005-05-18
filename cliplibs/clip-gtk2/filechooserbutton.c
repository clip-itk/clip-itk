/*
    Copyright (C) 2005  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_file_chooser_button() { return GTK_TYPE_FILE_CHOOSER_BUTTON; }
long _clip_type_file_chooser_button() { return GTK_WIDGET_FILE_CHOOSER_BUTTON; }
const char * _clip_type_name_file_chooser_button() { return "GTK_WIDGET_FILE_CHOOSER_BUTTON"; }

int
clip_INIT___FILE_CHOOSER_BUTTON(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_file_chooser_button, _clip_type_name_file_chooser_button, _gtk_type_file_chooser_button,  _gtk_type_hbox, NULL);
	return 0;
}
/**********************************************************/

int
clip_GTK_FILECHOOSERBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	gchar * title  = _clip_parc(cm, 2);
	GtkFileChooserAction action = _clip_parni(cm, 3);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);
	CHECKARG(2,CHARACTER_t); CHECKARG(3,NUMERIC_t);

	wid = gtk_file_chooser_button_new(title, action);

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERBUTTONNEWWITHBACKEND(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	gchar * title  = _clip_parc(cm, 2);
	GtkFileChooserAction action = _clip_parni(cm, 3);
	gchar *backend = _clip_parc(cm, 4);
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);
	CHECKARG(2,CHARACTER_t); CHECKARG(3,NUMERIC_t);

	wid = gtk_file_chooser_button_new_with_backend(title, action, backend);

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERBUTTONNEWWITHDIALOG(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
        C_widget *cdlg = _fetch_cwidget(cm, _clip_spar(cm, 2));
	GtkWidget *wid = NULL;
	C_widget *cwid;

	CHECKOPT(1,MAP_t);
	CHECKCWID(cdlg, GTK_IS_DIALOG);

	wid = gtk_file_chooser_button_new_with_dialog(GTK_WIDGET(cdlg->widget));

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERBUTTONGETTITLE(ClipMachine * cm)
{
        C_widget *cbutton = _fetch_cw_arg(cm);
        gchar      *title ;

	CHECKCWID(cbutton, GTK_IS_FILE_CHOOSER_BUTTON);

	title = (gchar *)gtk_file_chooser_button_get_title(GTK_FILE_CHOOSER_BUTTON(cbutton->widget));

	LOCALE_FROM_UTF(title);
        _clip_retc(cm, title);
        FREE_TEXT(title);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERBUTTONSETTITLE(ClipMachine * cm)
{
        C_widget *cbutton = _fetch_cw_arg(cm);
        gchar      *title = _clip_parc(cm, 2);

	CHECKCWID(cbutton, GTK_IS_FILE_CHOOSER_BUTTON);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(title);
	gtk_file_chooser_button_set_title(GTK_FILE_CHOOSER_BUTTON(cbutton->widget),
		(const gchar *)title);
	FREE_TEXT(title);

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERBUTTONGETWIDTHCHARS(ClipMachine * cm)
{
        C_widget *cbutton = _fetch_cw_arg(cm);

	CHECKCWID(cbutton, GTK_IS_FILE_CHOOSER_BUTTON);

	_clip_retni(cm, gtk_file_chooser_button_get_width_chars(GTK_FILE_CHOOSER_BUTTON(cbutton->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_FILECHOOSERBUTTONSETWIDTHCHARS(ClipMachine * cm)
{
        C_widget *cbutton = _fetch_cw_arg(cm);
        gint        width = _clip_parni(cm, 2);

	CHECKCWID(cbutton, GTK_IS_FILE_CHOOSER_BUTTON);
        CHECKARG(2, NUMERIC_t);

	gtk_file_chooser_button_set_width_chars(GTK_FILE_CHOOSER_BUTTON(cbutton->widget), width);

	return 0;
err:
	return 1;
}

