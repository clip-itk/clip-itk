/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/**********************************************************/
/* Signals table */
static SignalTable button_signals[] =
{
	/* Emitted when the button is initially pressed */
	{"pressed",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PRESSED_SIGNAL},
	/* Emitted when a button which is pressed is released,
	 * no matter where the mouse cursor is                 */
	{"released",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_RELEASED_SIGNAL},
	/* Emitted when a button clicked on by the mouse and the cursor stays on
	 * the button. If the cursor is not on the button when the
	 * mouse button is released, the signal is not emitted */
	//{"clicked",	GSF( handle_clicked_signal ),	ESF( object_emit_signal ), GTK_CLICKED_SIGNAL},
	{"clicked",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_CLICKED_SIGNAL},
	/* Emitted when the mouse cursor enters the region of the button */
	{"enter",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_ENTER_SIGNAL},
	/* Emitted when the mouse cursor leaves the region of the button */
	{"leave",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_LEAVE_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register widget signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_button() { return GTK_TYPE_BUTTON; }
long _clip_type_button() { return GTK_WIDGET_BUTTON; }
const char * _clip_type_name_button() { return "GTK_WIDGET_BUTTON"; }

int
clip_INIT___BUTTON(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_button, _clip_type_name_button, _gtk_type_button,  _gtk_type_container, button_signals);
	return 0;
}
/**********************************************************/

/**** BUTTON constructor ****/
int
clip_GTK_BUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	char * pchar   = _clip_parc(cm, 3);
	GtkWidget *wid = NULL, *label = NULL;
	C_widget *cwid, *clabel = NULL;
	guint accel_key = 0;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t); CHECKOPT(3,CHARACTER_t);

	if (pchar)
	{
		unsigned char *pc;
		for (pc = title;pc && *pc; pc++)
			if (*pc == *pchar)
			{
				*pc='_';
				accel_key = *(pc+1);
			}
	}
	if (_clip_parinfo(cm,2) == CHARACTER_t)
	{
		LOCALE_TO_UTF(title);
		wid = gtk_button_new_with_label(title);
		label = GTK_BIN(&(GTK_BUTTON(wid)->bin))->child;
		if (pchar)
			accel_key = gtk_label_parse_uline(GTK_LABEL(label), title);
		FREE_TEXT(title);
	}
	else
	{
		wid = gtk_button_new();
	}
	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);

	if (label) clabel = _register_widget(cm, label, NULL);
	if (clabel) _clip_madd(cm,&cwid->obj,HASH_LABEL,&clabel->obj);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	_clip_mputn(cm,&cwid->obj,HASH_ACCELKEY,accel_key);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/


/* Emits a GtkButton::pressed signal to the given GtkButton. */
int
clip_GTK_BUTTONPRESSED(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	gtk_button_pressed(GTK_BUTTON(cbtn->widget));
	return 0;
err:
	return 1;
}

/* Emits a GtkButton::released signal to the given GtkButton. */
int
clip_GTK_BUTTONRELEASED(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	gtk_button_released(GTK_BUTTON(cbtn->widget));
	return 0;
err:
	return 1;
}

/* Emits a GtkButton::clicked signal to the given GtkButton. */
int
clip_GTK_BUTTONCLICKED(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	gtk_button_clicked(GTK_BUTTON(cbtn->widget));
	return 0;
err:
	return 1;
}

/* Emits a GtkButton::enter signal to the given GtkButton. */
int
clip_GTK_BUTTONENTER(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	gtk_button_enter(GTK_BUTTON(cbtn->widget));
	return 0;
err:
	return 1;
}

/* Emits a GtkButton::leave signal to the given GtkButton. */
int
clip_GTK_BUTTONLEAVE(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	gtk_button_leave(GTK_BUTTON(cbtn->widget));
	return 0;
err:
	return 1;
}

/* Sets the relief style of the edges of the given Button widget.
 * Three styles exist, GTK_RELIEF_NORMAL,GTK_RELIEF_HALF, GTK_RELIEF_NONE.
 * The default style is, as one can guess, GTK_RELIEF_NORMAL. */
int
clip_GTK_BUTTONSETRELIEF(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
	int     relief = _clip_parni(cm,2);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2) == UNDEF_t) relief = GTK_RELIEF_NORMAL;
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	gtk_button_set_relief(GTK_BUTTON(cbtn->widget), relief);
	return 0;
err:
	return 1;
}

/* Returns the current relief style of the given Button. */
int
clip_GTK_BUTTONGETRELIEF(ClipMachine * cm)
{
	C_widget *cbtn = _fetch_cw_arg(cm);
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	_clip_retni(cm,gtk_button_get_relief(GTK_BUTTON(cbtn->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_BUTTONSETSTYLE(ClipMachine * cm)
{
	C_widget   *cbtn = _fetch_cw_arg(cm);
	ClipVar  *mstyle = _clip_spar(cm,2);
	GtkStyle *style;
	GtkWidget *wid;
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	CHECKARG(2,MAP_t);
	/*alena - I'm think it is bad idea: wid = GTK_BIN(&(GTK_BUTTON(cbtn->widget)->bin))->child;*/
	/* alena - style for button now setting! */
	wid = cbtn->widget;
	style = gtk_style_copy(wid->style);
	//gtk_style_unref(wid->style);
	_map_to_style(cm, mstyle, style);
	gtk_widget_set_style (wid, style);

	wid = GTK_BIN(&(GTK_BUTTON(cbtn->widget)->bin))->child;
	gtk_widget_set_style (wid, style);
	return 0;
err:
	return 1;
}

int
clip_GTK_BUTTONSETLABEL(ClipMachine * cm)
{
	C_widget   *cbtn = _fetch_cw_arg(cm);
	gchar     * text = _clip_parc(cm,2);
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	CHECKOPT(2,CHARACTER_t);

	LOCALE_TO_UTF(text);
	gtk_label_set_text(GTK_LABEL(GTK_BIN(&(GTK_BUTTON(cbtn->widget)->bin))->child), text);
	FREE_TEXT(text);

	return 0;
err:
	return 1;
}

int
clip_GTK_BUTTONGETLABEL(ClipMachine * cm)
{
	C_widget   *cbtn = _fetch_cw_arg(cm);
	C_widget  *cwid;
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	cwid = _get_cwidget(cm, GTK_BIN(&(GTK_BUTTON(cbtn->widget)->bin))->child);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_BUTTONGETText(ClipMachine * cm)
{
	C_widget   *cbtn = _fetch_cw_arg(cm);
	gchar     * text;
	CHECKCWID(cbtn,GTK_IS_BUTTON);
	gtk_label_get(GTK_LABEL(
		GTK_BIN(&(GTK_BUTTON(cbtn->widget)->bin))->child),&text);

	LOCALE_FROM_UTF(text);
	_clip_retc(cm,text);
	FREE_TEXT(text);

	return 0;
err:
	return 1;
}


