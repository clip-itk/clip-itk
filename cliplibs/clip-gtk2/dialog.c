/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
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

/*********************** SIGNALS **************************/


/*************** SIGNALS for InputDialog  *****************/

/* Signal handlers */
static gint
handle_input_dialog_signal (GtkInputDialog *dialog, gint deviceid, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_DEVICEID, deviceid);
        INVOKESIGHANDLER(GTK_WIDGET(dialog),cs,cv);
}

static gint
emit_input_dialog_signal (C_widget *cidial, const gchar *signal_name)
{
	ClipMachine *cm = cidial->cmachine;
        gint   deviceid = _clip_parni(cm,3);
        CHECKARG(3,NUMERIC_t);
        gtk_signal_emit_by_name(GTK_OBJECT(cidial->widget),signal_name,deviceid,cidial);
	return 0;
err:
	return 1;
}

/* Signals table */
static SignalTable input_dialog_signals[] =
{
	{"enable-device",	GSF( handle_input_dialog_signal ), ESF( emit_input_dialog_signal ), GTK_ENABLE_DEVICE_SIGNAL},
	{"disable-device",	GSF( handle_input_dialog_signal ), ESF( emit_input_dialog_signal ), GTK_DISABLE_DEVICE_SIGNAL},
	{"", NULL, NULL, 0}
};

static gint
handle_response_signal (GtkDialog *dialog, gint arg1, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_RESPONSE_ID, arg1);
        INVOKESIGHANDLER(GTK_WIDGET(dialog),cs,cv);
}

/* Signals table */
static SignalTable dialog_signals[] =
{
	{"close",     		GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CLOSE_SIGNAL},
	{"response",  		GSF( handle_response_signal ), ESF( object_emit_signal ), GTK_RESPONSE_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register dialog in global table */
CLIP_DLLEXPORT GtkType _gtk_type_dialog() { return GTK_TYPE_DIALOG; }
long _clip_type_dialog() { return GTK_WIDGET_DIALOG; }
const char * _clip_type_name_dialog() { return "GTK_WIDGET_DIALOG"; }

/* Register Input Dialog in global table */
CLIP_DLLEXPORT GtkType _gtk_type_input_dialog() { return GTK_TYPE_INPUT_DIALOG; }
long _clip_type_input_dialog() { return GTK_WIDGET_INPUT_DIALOG; }
const char * _clip_type_name_input_dialog() { return "GTK_WIDGET_INPUT_DIALOG"; }

/* Register Message Dialog in global table */
CLIP_DLLEXPORT GtkType _gtk_type_message_dialog() { return GTK_TYPE_MESSAGE_DIALOG; }
long _clip_type_message_dialog() { return GTK_WIDGET_MESSAGE_DIALOG; }
const char * _clip_type_name_message_dialog() { return "GTK_WIDGET_MESSAGE_DIALOG"; }

int
clip_INIT___DIALOG(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_dialog, _clip_type_name_dialog, _gtk_type_dialog, _gtk_type_window, dialog_signals);
	_wtype_table_put(_clip_type_input_dialog, _clip_type_name_input_dialog, _gtk_type_input_dialog, _gtk_type_dialog, input_dialog_signals);
	_wtype_table_put(_clip_type_message_dialog, _clip_type_name_message_dialog, _gtk_type_message_dialog, _gtk_type_dialog, NULL);
	return 0;
}
/**********************************************************/

/****  DIALOG constructor ****/
int
clip_GTK_DIALOGNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	C_widget *cvbox, *carea;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	wid = gtk_dialog_new();
        if (!wid) goto err;
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		{
		LOCALE_TO_UTF(title);
		gtk_window_set_title(GTK_WINDOW(wid), title);
		FREE_TEXT(title);
		}
	//cwid = (C_widget*)calloc( 1, sizeof(C_widget) );
	cwid = _register_widget(cm, wid, cv);
	cvbox = _register_widget(cm, GTK_DIALOG(wid)->vbox, NULL);
	carea = _register_widget(cm, GTK_DIALOG(wid)->action_area, NULL);

        if (cvbox) _clip_madd(cm,&cwid->obj,HASH_VBOX,&cvbox->obj);
        if (carea) _clip_madd(cm,&cwid->obj,HASH_ACTIONAREA,&carea->obj);

	cwid->accel_group = gtk_accel_group_new();
	gtk_window_add_accel_group (GTK_WINDOW (wid), cwid->accel_group);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_DIALOGNEWWITHBUTTONS(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
        C_widget * cpwin = _fetch_cwidget(cm, _clip_spar(cm, 3));
        GtkDialogFlags flags = INT_OPTION(cm, 4, 0);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	C_widget *cvbox, *carea;
        gint    i, n = _clip_parinfo(cm, 0)-4;
        gchar  *stock[n];

	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);
	CHECKOPT2(3,MAP_t, NUMERIC_t); CHECKCWIDOPT(cpwin, GTK_WINDOW);
        CHECKARG(4, NUMERIC_t);

        memset(stock, 0, sizeof(stock));
        for(i=0; i<n; i++)
        {
        	CHECKOPT(i+4, CHARACTER_t);
        	if (_clip_parinfo(cm, i+4)== UNDEF_t)
                	break;
        	stock[i] = _clip_parc(cm, i+4);
        }
	LOCALE_TO_UTF(title);
	wid = gtk_dialog_new_with_buttons(title,
		(cpwin != NULL)?GTK_WINDOW(cpwin->widget):NULL,
		flags,
		stock[0],  stock[1],  stock[2],  stock[3],  stock[4],
		stock[5],  stock[6],  stock[7],  stock[8],  stock[9],
		stock[10], stock[11], stock[12], stock[13], stock[14],
		stock[15], stock[16], stock[17], stock[18], stock[19]
		);
        if (!wid) goto err;
	//cwid = (C_widget*)calloc( 1, sizeof(C_widget) );
	cwid = _register_widget(cm, wid, cv);
	cvbox = _register_widget(cm, GTK_DIALOG(wid)->vbox, NULL);
	carea = _register_widget(cm, GTK_DIALOG(wid)->action_area, NULL);

        if (cvbox) _clip_madd(cm,&cwid->obj,HASH_VBOX,&cvbox->obj);
        if (carea) _clip_madd(cm,&cwid->obj,HASH_ACTIONAREA,&carea->obj);

	cwid->accel_group = gtk_accel_group_new();
	gtk_window_add_accel_group (GTK_WINDOW (wid), cwid->accel_group);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	FREE_TEXT(title);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/****  INPUT DIALOG constructor ****/
int
clip_GTK_INPUTDIALOGNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	wid = gtk_input_dialog_new();
        if (!wid) goto err;
	if (_clip_parinfo(cm,2)==CHARACTER_t)
		{
		LOCALE_TO_UTF(title);
		gtk_window_set_title(GTK_WINDOW(wid), title);
		FREE_TEXT(title);
		}
	//cwid = (C_widget*)calloc( 1, sizeof(C_widget) );
	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/* Runs dialog and returns one of response dialog types  */
int
clip_GTK_DIALOGRUN(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gint          ret ;

        CHECKCWID(cdialog,GTK_IS_DIALOG);

	ret = gtk_dialog_run(GTK_DIALOG(cdialog->widget));
        _clip_retni(cm, ret);

	return 0;
err:
	return 1;
}


/* Emit  response signal  */
int
clip_GTK_DIALOGRESPONSE(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gint  response_id = _clip_parni(cm, 2);

        CHECKCWID(cdialog,GTK_IS_DIALOG);
        CHECKARG(2, NUMERIC_t);

	gtk_dialog_response(GTK_DIALOG(cdialog->widget), response_id);

	return 0;
err:
	return 1;
}

/* Adds a button with the given text
*(or a stock button, if button_text is a stock ID)  */
int
clip_GTK_DIALOGADDBUTTON(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gchar       *text = _clip_parc(cm, 2);
        gint  response_id = _clip_parni(cm, 3);

        CHECKCWID(cdialog,GTK_IS_DIALOG);
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, NUMERIC_t);

	LOCALE_TO_UTF(text);
	gtk_dialog_add_button(GTK_DIALOG(cdialog->widget), text, response_id);
	FREE_TEXT(text);

	return 0;
err:
	return 1;
}

/* Adds a buttons with the given text
*(or a stock button, if button_text is a stock ID)  */
int
clip_GTK_DIALOGADDBUTTONS(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gint            n = _clip_parinfo(cm, 0)-1;
        gchar  *text[20] ;
        gint  response_id[20] ;
        gint         j, i ;

        CHECKCWID(cdialog,GTK_IS_DIALOG);
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, NUMERIC_t);

	memset(text, 0, sizeof(text));
	memset(response_id, 0, sizeof(response_id));
	for (i=0, j=0; j<n; j += 2, i ++)
        {
		CHECKOPT(i, CHARACTER_t);
                if (_clip_parinfo(cm, i) == UNDEF_t)
                {
                	n --;
                        n = n/2;
                	break;
		}
		CHECKOPT(i+1, NUMERIC_t);
		text[i] = _clip_parc(cm, i);
		response_id[i] = _clip_parni(cm, i+1);
		LOCALE_TO_UTF(text[i]);
        }
	gtk_dialog_add_buttons(GTK_DIALOG(cdialog->widget),
		text[0],  response_id[0],  text[1],  response_id[1],
		text[2],  response_id[2],  text[3],  response_id[3],
		text[4],  response_id[4],  text[5],  response_id[5],
		text[6],  response_id[6],  text[7],  response_id[7],
		text[8],  response_id[8],  text[9],  response_id[9],
		text[10], response_id[10], text[11], response_id[11],
		text[12], response_id[12], text[13], response_id[13],
		text[14], response_id[14], text[15], response_id[15],
		text[16], response_id[16], text[17], response_id[17],
		text[18], response_id[18], text[19], response_id[19]
		);

	for (i=0; i<n; i ++)
        {
		FREE_TEXT(text[i]);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_DIALOGADDACTIONWIDGET(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        C_widget    *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gint  response_id = _clip_parni(cm, 3);

        CHECKCWID(cdialog,GTK_IS_DIALOG);
        CHECKARG(2, MAP_t); CHECKCWID(cwid, GTK_WIDGET);
        CHECKARG(3, NUMERIC_t);

	gtk_dialog_add_action_widget(GTK_DIALOG(cdialog->widget),
		GTK_WIDGET(cwid->widget), response_id);

	return 0;
err:
	return 1;
}

int
clip_GTK_DIALOGGETHASSEPARATOR(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gboolean      ret ;

        CHECKCWID(cdialog,GTK_IS_DIALOG);

	ret = gtk_dialog_get_has_separator(GTK_DIALOG(cdialog->widget));

	_clip_retni(cm, ret);

	return 0;
err:
	return 1;
}

int
clip_GTK_DIALOGSETDEFAULTRESPONSE(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gint  response_id = _clip_parni(cm, 2);

        CHECKCWID(cdialog,GTK_IS_DIALOG);
        CHECKARG(2, NUMERIC_t);

	gtk_dialog_set_default_response(GTK_DIALOG(cdialog->widget), response_id);

	return 0;
err:
	return 1;
}

int
clip_GTK_DIALOGSETHASSEPARATOR(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gboolean  setting = _clip_parl(cm, 2);

        CHECKCWID(cdialog,GTK_IS_DIALOG);
        CHECKARG(2, LOGICAL_t);

	gtk_dialog_set_default_response(GTK_DIALOG(cdialog->widget), setting);

	return 0;
err:
	return 1;
}

int
clip_GTK_DIALOGSETRESPONSESENSITIVE(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        gint  response_id = _clip_parni(cm, 2);
        gboolean  setting = _clip_parl(cm, 3);

        CHECKCWID(cdialog,GTK_IS_DIALOG);
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, LOGICAL_t);

	gtk_dialog_set_response_sensitive(GTK_DIALOG(cdialog->widget),
		response_id, setting);

	return 0;
err:
	return 1;
}

/* Returns the VBox area of the dialog */
int
clip_GTK_DIALOGGETVBOX(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        GtkWidget *area;
        C_widget *carea;
        CHECKCWID(cdialog,GTK_IS_DIALOG);
        area = GTK_DIALOG(cdialog->widget)->vbox;
        if (area) carea = _list_get_cwidget(cm, area);
        if (!carea) carea = _register_widget(cm, area, NULL);
        if (carea) _clip_mclone(cm, RETPTR(cm), &carea->obj);
	return 0;
err:
	return 1;
}

/* Returns the action area of the dialog */
int
clip_GTK_DIALOGGETACTIONAREA(ClipMachine *cm)
{
	C_widget *cdialog = _fetch_cw_arg(cm);
        GtkWidget *area;
        C_widget *carea;
        CHECKCWID(cdialog,GTK_IS_DIALOG);
        area = GTK_DIALOG(cdialog->widget)->action_area;
        if (area) carea = _list_get_cwidget(cm, area);
        if (!carea) carea = _register_widget(cm, area, NULL);
        if (carea) _clip_mclone(cm, RETPTR(cm), &carea->obj);
	return 0;
err:
	return 1;
}

/******************************************************************************
* MESSAGE DIALOG
******************************************************************************/
int
clip_GTK_MESSAGEDIALOGNEW(ClipMachine * cm)
{
	ClipVar         * cv = _clip_spar(cm, 1);
        C_widget     * cpwin = _fetch_cwidget(cm, _clip_spar(cm, 2));
        GtkDialogFlags flags = INT_OPTION(cm, 3, 0);
        GtkMessageType  msgs = INT_OPTION(cm, 4, 0);
        GtkButtonsType  btns = INT_OPTION(cm, 5, 0);
	GtkWidget       *wid = NULL;
	C_widget *cwid;

        gint            i, n = _clip_parinfo(cm, 0)-5;
        gchar  *mfmt[n];

	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t, NUMERIC_t); CHECKCWIDOPT(cpwin, GTK_WINDOW);
	CHECKOPT(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);
        CHECKARG(5, NUMERIC_t);

        memset(mfmt, 0, sizeof(mfmt));
        for(i=0; i<n; i++)
        {
        	CHECKOPT(i+4, CHARACTER_t);
        	if (_clip_parinfo(cm, i+4)== UNDEF_t)
                	break;
        	mfmt[i] = _clip_parc(cm, i+4);
        }
	wid = gtk_message_dialog_new(
		(cpwin != NULL)?GTK_WINDOW(cpwin->widget):NULL,
		flags, msgs, btns,
		mfmt[0],  mfmt[1],  mfmt[2],  mfmt[3],  mfmt[4],
		mfmt[5],  mfmt[6],  mfmt[7],  mfmt[8],  mfmt[9],
		mfmt[10], mfmt[11], mfmt[12], mfmt[13], mfmt[14],
		mfmt[15], mfmt[16], mfmt[17], mfmt[18], mfmt[19]
		);
        if (!wid) goto err;
	//cwid = (C_widget*)calloc( 1, sizeof(C_widget) );
	cwid = _register_widget(cm, wid, cv);

	cwid->accel_group = gtk_accel_group_new();
	gtk_window_add_accel_group (GTK_WINDOW (wid), cwid->accel_group);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
int
clip_GTK_MESSAGEDIALOGNEWWITHMARKUP(ClipMachine * cm)
{
	ClipVar         * cv = _clip_spar(cm, 1);
        C_widget     * cpwin = _fetch_cwidget(cm, _clip_spar(cm, 2));
        GtkDialogFlags flags = INT_OPTION(cm, 3, 0);
        GtkMessageType  msgs = INT_OPTION(cm, 4, 0);
        GtkButtonsType  btns = INT_OPTION(cm, 5, 0);
	GtkWidget       *wid = NULL;
	C_widget *cwid;

        gint            i, n = _clip_parinfo(cm, 0)-5;
        gchar  *mfmt[n];

	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t, NUMERIC_t); CHECKCWIDOPT(cpwin, GTK_WINDOW);
	CHECKOPT(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);
        CHECKARG(5, NUMERIC_t);

        memset(mfmt, 0, sizeof(mfmt));
        for(i=0; i<n; i++)
        {
        	CHECKOPT(i+4, CHARACTER_t);
        	if (_clip_parinfo(cm, i+4)== UNDEF_t)
                	break;
        	mfmt[i] = _clip_parc(cm, i+4);
        }
	wid = gtk_message_dialog_new_with_markup(
		(cpwin != NULL)?GTK_WINDOW(cpwin->widget):NULL,
		flags, msgs, btns,
		mfmt[0],  mfmt[1],  mfmt[2],  mfmt[3],  mfmt[4],
		mfmt[5],  mfmt[6],  mfmt[7],  mfmt[8],  mfmt[9],
		mfmt[10], mfmt[11], mfmt[12], mfmt[13], mfmt[14],
		mfmt[15], mfmt[16], mfmt[17], mfmt[18], mfmt[19]
		);
        if (!wid) goto err;
	//cwid = (C_widget*)calloc( 1, sizeof(C_widget) );
	cwid = _register_widget(cm, wid, cv);

	cwid->accel_group = gtk_accel_group_new();
	gtk_window_add_accel_group (GTK_WINDOW (wid), cwid->accel_group);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_MESSAGEDIALOGSETMARKUP(ClipMachine * cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
        gchar  *markup = _clip_parc(cm, 2);

        CHECKCWID(cwid, GTK_IS_MESSAGE_DIALOG);
        CHECKARG(2, CHARACTER_t);

	gtk_message_dialog_set_markup(GTK_MESSAGE_DIALOG(cwid->widget), markup);
	return 0;
err:
	return 1;
}
#endif
