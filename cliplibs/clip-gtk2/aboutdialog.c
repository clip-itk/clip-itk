/*
    Copyright (C) 2005 ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/

/* Register about_dialog in global table */
CLIP_DLLEXPORT GtkType _gtk_type_about_dialog() { return GTK_TYPE_ABOUT_DIALOG; }
long _clip_type_about_dialog() { return GTK_WIDGET_ABOUT_DIALOG; }
const char * _clip_type_name_about_dialog() { return "GTK_WIDGET_ABOUT_DIALOG"; }

int
clip_INIT___ABOUT_DIALOG(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_about_dialog, _clip_type_name_about_dialog, _gtk_type_about_dialog, _gtk_type_dialog, NULL);
	return 0;
}
/**********************************************************/

/****  DIALOG constructor ****/
int
clip_GTK_ABOUTDIALOGNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	wid = gtk_about_dialog_new();
        if (!wid) goto err;
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		{
		LOCALE_TO_UTF(title);
		gtk_window_set_title(GTK_WINDOW(wid), title);
		FREE_TEXT(title);
		}
	cwid = _register_widget(cm, wid, cv);

	cwid->accel_group = gtk_accel_group_new();
	gtk_window_add_accel_group (GTK_WINDOW (wid), cwid->accel_group);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGGETNAME(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        char         *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (char *)gtk_about_dialog_get_name(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}


int
clip_GTK_ABOUTDIALOGSETNAME(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_name(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGGETVERSION(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (gchar *)gtk_about_dialog_get_version(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETVERSION(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_version(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGGETCOPYRIGHT(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (gchar *)gtk_about_dialog_get_copyright(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETCOPYRIGHT(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_copyright(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}


int
clip_GTK_ABOUTDIALOGGETCOMMENTS(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar   *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (gchar *)gtk_about_dialog_get_comments(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETCOMMENTS(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_comments(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}


int
clip_GTK_ABOUTDIALOGGETLICENSE(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (gchar *)gtk_about_dialog_get_license(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETLICENSE(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_license(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}


int
clip_GTK_ABOUTDIALOGGETWEBSITE(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (gchar *)gtk_about_dialog_get_website(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETWEBSITE(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_website(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGGETWEBSITELABEL(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (gchar *)gtk_about_dialog_get_website_label(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETWEBSITELABEL(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_website_label(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}


int
clip_GTK_ABOUTDIALOGSETAUTHORS(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        ClipArrVar    *ca = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        long            l ;
        int             i ;
        gchar       **str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, ARRAY_t);

	l = ca->count;
        for (i=0; i<l; i++)
        	if (ca->items[i].t.type != CHARACTER_t) goto err;

        str = (gchar **)calloc(sizeof(gchar *), l);

	for (i=0; i<l; i++)
        {
        	ClipVar *c;

                c = ca->items + i;

        	str[i] = (gchar *)calloc(sizeof(gchar *), c->s.str.len+1);
                strcpy(str[i], c->s.str.buf);
                LOCALE_TO_UTF(str[i]);
        }

	gtk_about_dialog_set_authors(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar **)str);

	for (i=0; i<l; i++)
        {
        	FREE_TEXT(str[i]);
                free(str[i]);
        }
        free(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETARTISTS(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        ClipArrVar    *ca = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        long            l ;
        int             i ;
        gchar       **str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, ARRAY_t);

	l = ca->count;
        for (i=0; i<l; i++)
        	if (ca->items[i].t.type != CHARACTER_t) goto err;

        str = (gchar **)calloc(sizeof(gchar *), l);

	for (i=0; i<l; i++)
        {
        	ClipVar *c;

                c = ca->items + i;

        	str[i] = (gchar *)calloc(sizeof(gchar *), c->s.str.len+1);
                strcpy(str[i], c->s.str.buf);
                LOCALE_TO_UTF(str[i]);
        }

	gtk_about_dialog_set_artists(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar **)str);

	for (i=0; i<l; i++)
        {
        	FREE_TEXT(str[i]);
                free(str[i]);
        }
        free(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETDOCUMENTERS(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        ClipArrVar    *ca = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        long            l ;
        int             i ;
        gchar       **str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, ARRAY_t);

	l = ca->count;
        for (i=0; i<l; i++)
        	if (ca->items[i].t.type != CHARACTER_t) goto err;

        str = (gchar **)calloc(sizeof(gchar *), l);

	for (i=0; i<l; i++)
        {
        	ClipVar *c;

                c = ca->items + i;

        	str[i] = (gchar *)calloc(sizeof(gchar *), c->s.str.len+1);
                strcpy(str[i], c->s.str.buf);
                LOCALE_TO_UTF(str[i]);
        }

	gtk_about_dialog_set_documenters(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar **)str);

	for (i=0; i<l; i++)
        {
        	FREE_TEXT(str[i]);
                free(str[i]);
        }
        free(str);

	return 0;
err:
	return 1;
}
int
clip_GTK_ABOUTDIALOGGETTRANSLATORCREDITS(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (gchar *)gtk_about_dialog_get_translator_credits(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETTRANSLATORCREDITS(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_translator_credits(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGGETLOGO(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        GdkPixbuf    *pix ;
        C_object    *cpix ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	pix = gtk_about_dialog_get_logo(GTK_ABOUT_DIALOG(cdialog->widget));

	if (pix)
        {
        	cpix = _list_get_cobject(cm, pix);
                if (!cpix) cpix = _register_object(cm, pix, GDK_TYPE_PIXBUF, NULL, NULL);
                if (cpix) _clip_mclone(cm, RETPTR(cm), &cpix->obj);
        }

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETLOGO(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        C_object    *cpix = _fetch_cobject(cm, _clip_spar(cm, 2));

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKCOBJ(cpix, GDK_IS_PIXBUF(cpix->object));

	gtk_about_dialog_set_logo(GTK_ABOUT_DIALOG(cdialog->widget), GDK_PIXBUF(cpix->object));

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGGETLOGOICONNAME(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str ;

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);

	str = (gchar *)gtk_about_dialog_get_logo_icon_name(GTK_ABOUT_DIALOG(cdialog->widget));
        LOCALE_FROM_UTF(str);
        _clip_retc(cm, str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETLOGOICONNAME(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar        *str = _clip_parc(cm, 2);

        CHECKCWID(cdialog,GTK_IS_ABOUT_DIALOG);
        CHECKARG(2, CHARACTER_t);

	LOCALE_TO_UTF(str);
	gtk_about_dialog_set_logo_icon_name(GTK_ABOUT_DIALOG(cdialog->widget), (const gchar *)str);
        FREE_TEXT(str);

	return 0;
err:
	return 1;
}

static void
_about_dialog_func(GtkAboutDialog *dialog,const gchar *link, gpointer data)
{
	C_var *c = (C_var*)data;
	C_widget *c_wid = _list_get_cwidget(c->cm, dialog);
	ClipVar stack[2];
	ClipVar res;
	if (!c_wid)
		c_wid = _register_widget(c->cm,GTK_WIDGET(dialog),NULL);
	if (c_wid)
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		//_clip_mclone(c->cw->cmachine, &stack[0], &c->cw->obj);
		_clip_mclone(c->cw->cmachine, &stack[0], &c_wid->obj);
        	_clip_var_str(link, strlen(link), &stack[1]);
		_clip_eval( c->cm, &(c->cfunc), 2, stack, &res );
		_clip_destroy(c->cm, &res);
		_clip_destroy(c->cm, &stack[0]);
		//_clip_destroy(c->cm, &stack[1]);
	}
}

int
clip_GTK_ABOUTDIALOGSETEMAILHOOK(ClipMachine *cm)
{
        ClipVar    *cfunc = _clip_spar(cm, 1);
        C_var          *c ;

        CHECKARG2(1, CCODE_t, PCODE_t);

	c->cm = cm; _clip_mclone(cm, &c->cfunc, cfunc);
	gtk_about_dialog_set_email_hook((GtkAboutDialogActivateLinkFunc)_about_dialog_func, c, NULL);

	return 0;
err:
	return 1;
}

int
clip_GTK_ABOUTDIALOGSETURLHOOK(ClipMachine *cm)
{
        ClipVar    *cfunc = _clip_spar(cm, 1);
        C_var          *c ;

        CHECKARG2(1, CCODE_t, PCODE_t);

	c->cm = cm; _clip_mclone(cm, &c->cfunc, cfunc);
	gtk_about_dialog_set_url_hook((GtkAboutDialogActivateLinkFunc)_about_dialog_func, c, NULL);

	return 0;
err:
	return 1;
}

