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
#include <string.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS ***************************/

/****      File selection widget has no own signals     ****/

/***********************************************************/

/* Register file selection in global table */
CLIP_DLLEXPORT GtkType _gtk_type_file_selection() { return GTK_TYPE_FILE_SELECTION; }
long _clip_type_file_selection() { return GTK_WIDGET_FILE_SELECTION; }
const char * _clip_type_name_file_selection() { return "GTK_WIDGET_FILE_SELECTION"; }

int
clip_INIT___FILESELECTION(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_file_selection, _clip_type_name_file_selection, _gtk_type_file_selection, _gtk_type_window, NULL);
	return 0;
}
/**********************************************************/

/****  Font selection dialog constructor ****/
int
clip_GTK_FILESELECTIONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	C_widget *cfileop_dialog, *cdir_list, *cfile_list, *cok_btn, *ccancel_btn;
	C_widget *chist_pulldown, *cfileop_c_dir, *cfileop_del_file, *cfileop_ren_file;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	if (_clip_parinfo(cm,2)==UNDEF_t) title = "\0";
	LOCALE_TO_UTF(title);
	wid = gtk_file_selection_new(title);
	FREE_TEXT(title);
	cwid = _register_widget(cm, wid, cv);
	cfileop_dialog = _register_widget(cm, GTK_FILE_SELECTION(wid)->fileop_dialog, NULL);
	cdir_list = _register_widget(cm, GTK_FILE_SELECTION(wid)->dir_list, NULL);
	cfile_list = _register_widget(cm, GTK_FILE_SELECTION(wid)->file_list, NULL);
	cok_btn = _register_widget(cm, GTK_FILE_SELECTION(wid)->ok_button, NULL);
	ccancel_btn = _register_widget(cm, GTK_FILE_SELECTION(wid)->cancel_button, NULL);
	chist_pulldown = _register_widget(cm, GTK_FILE_SELECTION(wid)->history_pulldown, NULL);
	cfileop_c_dir = _register_widget(cm, GTK_FILE_SELECTION(wid)->fileop_c_dir, NULL);
	cfileop_del_file = _register_widget(cm, GTK_FILE_SELECTION(wid)->fileop_del_file, NULL);
	cfileop_ren_file = _register_widget(cm, GTK_FILE_SELECTION(wid)->fileop_ren_file, NULL);

	if (cfileop_dialog) _clip_madd(cm,&cwid->obj,HASH_FILEOPDIALOG,&cfileop_dialog->obj);
	if (cdir_list) _clip_madd(cm,&cwid->obj,HASH_DIRLIST,&cdir_list->obj);
	if (cfile_list) _clip_madd(cm,&cwid->obj,HASH_FILELIST,&cfile_list->obj);
	if (cok_btn) _clip_madd(cm,&cwid->obj,HASH_OKBUTTON,&cok_btn->obj);
	if (ccancel_btn) _clip_madd(cm,&cwid->obj,HASH_CANCELBUTTON,&ccancel_btn->obj);
	if (chist_pulldown) _clip_madd(cm,&cwid->obj,HASH_HISTORYPULLDOWN,&chist_pulldown->obj);
	if (cfileop_c_dir) _clip_madd(cm,&cwid->obj,HASH_FILEOPCDIR,&cfileop_c_dir->obj);
	if (cfileop_del_file) _clip_madd(cm,&cwid->obj,HASH_FILEOPDELFILE,&cfileop_del_file->obj);
	if (cfileop_ren_file) _clip_madd(cm,&cwid->obj,HASH_FILEOPRENFILE,&cfileop_ren_file->obj);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/* Sets a default path for the file requestor. If filename includes a directory path,
 * then the requestor will open with that path as its current working directory. */
int
clip_GTK_FILESELECTIONSETFILENAME(ClipMachine *cm)
{
	C_widget       *cfsel = _fetch_cw_arg(cm);
	gchar       *filename = _clip_parc(cm,2);
	CHECKCWID(cfsel,GTK_IS_FILE_SELECTION);
	CHECKOPT(2,CHARACTER_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) filename = "\0";
	LOCALE_TO_UTF(filename);
	gtk_file_selection_set_filename(GTK_FILE_SELECTION(cfsel->widget),filename);
	FREE_TEXT(filename);
	return 0;
err:
	return 1;
}

/* Retrieves the currently selected filename from the file selection dialog.
 * If no file is selected then the selected directory path is returned. */
int
clip_GTK_FILESELECTIONGETFILENAME(ClipMachine *cm)
{
	C_widget       *cfsel = _fetch_cw_arg(cm);
	gchar *filename;
	CHECKCWID(cfsel,GTK_IS_FILE_SELECTION);
	filename = (gchar *)gtk_file_selection_get_filename(GTK_FILE_SELECTION(cfsel->widget));
	LOCALE_FROM_UTF(filename);
	_clip_retc(cm,filename);
	FREE_TEXT(filename);
	return 0;
err:
	return 1;
}

/* Will attempt to match pattern to a valid filename in the current directory.
 * If a match can be made, the matched filename  will appear in the text entry
 * field of the file selection dialog. If a partial match can be made, the
 * "Files" list will contain  those file names which have been partially matched. */
int
clip_GTK_FILESELECTIONCOMPLETE(ClipMachine *cm)
{
	C_widget       *cfsel = _fetch_cw_arg(cm);
	gchar  *pattern = _clip_parc(cm,2);
	CHECKCWID(cfsel,GTK_IS_FILE_SELECTION);
	CHECKOPT(2,CHARACTER_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) pattern = "\0";
	LOCALE_TO_UTF(pattern);
	gtk_file_selection_complete(GTK_FILE_SELECTION(cfsel->widget),pattern);
	FREE_TEXT(pattern);
	return 0;
err:
	return 1;
}

/* Shows the file operation buttons, if they have previously been hidden.
 * The rest of the widgets in the dialog will be resized accordingly. */
int
clip_GTK_FILESELECTIONSHOWFILEOPBUTTONS(ClipMachine *cm)
{
	C_widget       *cfsel = _fetch_cw_arg(cm);
	CHECKCWID(cfsel,GTK_IS_FILE_SELECTION);
	gtk_file_selection_show_fileop_buttons(GTK_FILE_SELECTION(cfsel->widget));
	return 0;
err:
	return 1;
}

/* Hides the file operation buttons that normally appear at the top of
 * the dialog. Useful if you wish to create a custom file selector,
 * based on GtkFileSelection. */
int
clip_GTK_FILESELECTIONHIDEFILEOPBUTTONS(ClipMachine *cm)
{
	C_widget       *cfsel = _fetch_cw_arg(cm);
	CHECKCWID(cfsel,GTK_IS_FILE_SELECTION);
	gtk_file_selection_hide_fileop_buttons(GTK_FILE_SELECTION(cfsel->widget));
	return 0;
err:
	return 1;
}


int
clip_GTK_FILESELECTIONGETSELECTIONS(ClipMachine *cm)
{
	C_widget       *cfsel = _fetch_cw_arg(cm);
	gchar           **sel ;
        long                i ;
        ClipVar           *cv = RETPTR(cm);

	CHECKCWID(cfsel,GTK_IS_FILE_SELECTION);
	sel = gtk_file_selection_get_selections(GTK_FILE_SELECTION(cfsel->widget));
        for (i = 0; sel[i] != NULL; i++);
        _clip_array(cm, cv, 1, &i);
        for (i = 0; sel[i] != NULL; i++)
        {
        	ClipVar cstr ;
                gchar   *str = sel[i];

        	memset(&cstr, 0, sizeof(cstr));
        	LOCALE_FROM_UTF(str);
        	_clip_var_str(str, strlen(str), &cstr);
                FREE_TEXT(str);
        	_clip_aset(cm, cv, &cstr, 1, &i);
                _clip_destroy(cm, &cstr);
        }
        g_strfreev(sel);
	return 0;
err:
	return 1;
}

int
clip_GTK_FILESELECTIONSETSELECTMULTIPLE(ClipMachine *cm)
{
	C_widget       *cfsel = _fetch_cw_arg(cm);
        gboolean     multiple = _clip_parl(cm, 2);

	CHECKCWID(cfsel,GTK_IS_FILE_SELECTION);
        CHECKARG(2, LOGICAL_t);

	gtk_file_selection_set_select_multiple(GTK_FILE_SELECTION(cfsel->widget),
		multiple);
	return 0;
err:
	return 1;
}

int
clip_GTK_FILESELECTIONGETSELECTMULTIPLE(ClipMachine *cm)
{
	C_widget       *cfsel = _fetch_cw_arg(cm);

	CHECKCWID(cfsel,GTK_IS_FILE_SELECTION);

	_clip_retl(cm, gtk_file_selection_get_select_multiple(GTK_FILE_SELECTION(cfsel->widget)));
	return 0;
err:
	return 1;
}


