/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
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

/* Signals table */
static SignalTable toolbutton_signals[] =
{
	{"clicked",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CLICKED_SIGNAL},
	{"", NULL, NULL, 0}
};

static SignalTable toggle_toolbutton_signals[] =
{
	{"toggled",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_TOGGLED_SIGNAL},
	{"", NULL, NULL, 0}
};


/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_tool_button() { return GTK_TYPE_TOOL_BUTTON; }
long _clip_type_tool_button() { return GTK_WIDGET_TOOL_BUTTON; }
const char * _clip_type_name_tool_button()  { return "GTK_WIDGET_TOOL_BUTTON"; }

CLIP_DLLEXPORT GtkType _gtk_type_toggle_tool_button() { return GTK_TYPE_TOGGLE_TOOL_BUTTON; }
long _clip_type_toggle_tool_button() { return GTK_WIDGET_TOGGLE_TOOL_BUTTON; }
const char * _clip_type_name_toggle_tool_button()  { return "GTK_WIDGET_TOGGLE_TOOL_BUTTON"; }


CLIP_DLLEXPORT GtkType _gtk_type_radio_tool_button() { return GTK_TYPE_RADIO_TOOL_BUTTON; }
long _clip_type_radio_tool_button() { return GTK_WIDGET_TOGGLE_TOOL_BUTTON; }
const char * _clip_type_name_radio_tool_button()  { return "GTK_WIDGET_RADIO_TOOL_BUTTON"; }
/* Register toolitem in global table */
int
clip_INIT___TOOLBUTTON(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_tool_button,  _clip_type_name_tool_button,  _gtk_type_tool_button,  _gtk_type_tool_item, toolbutton_signals);
	_wtype_table_put(_clip_type_toggle_tool_button,  _clip_type_name_toggle_tool_button,  _gtk_type_toggle_tool_button,  _gtk_type_tool_button, toggle_toolbutton_signals);
	_wtype_table_put(_clip_type_radio_tool_button,  _clip_type_name_radio_tool_button,  _gtk_type_radio_tool_button,  _gtk_type_tool_button, NULL);
	return 0;
}

/**** ------------------ ****/
int
clip_GTK_TOOLBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_widget *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
	gchar   *label = _clip_parc(cm, 3);
	GtkToolItem *item;
	C_widget *cbutton;

	CHECKOPT(1,MAP_t);
	CHECKOPT(2, MAP_t); CHECKCWIDOPT(cwid, GTK_IS_WIDGET);
	CHECKOPT(3, CHARACTER_t);

	if (label) LOCALE_TO_UTF(label);
	item = gtk_tool_button_new((cwid)?GTK_WIDGET(cwid->widget):NULL,
		(label)?label:NULL);
	if (label) FREE_TEXT(label);
	if (!item) goto err;
	cbutton = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&cbutton->obj);
	return 0;
err:
	return 1;
}
int
clip_GTK_TOOLBUTTONNEWFROMSTOCK(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	gchar   *label = _clip_parc(cm, 2);
	GtkToolItem *item;
	C_widget *cbutton;

	CHECKOPT(1,MAP_t);
	CHECKARG(2, CHARACTER_t);

	item = gtk_tool_button_new_from_stock(label);

	if (!item) goto err;
	cbutton = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&cbutton->obj);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_TOOLBUTTONSETLABEL(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	gchar    *label = _clip_parc(cm, 2);

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);
	CHECKOPT(2, CHARACTER_t);

	LOCALE_TO_UTF(label);
	gtk_tool_button_set_label(GTK_TOOL_BUTTON(cbutton->widget),
		label);
	FREE_TEXT(label);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONGETLABEL(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	gchar    *label ;

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);

	label = (gchar *)gtk_tool_button_get_label(GTK_TOOL_BUTTON(cbutton->widget));
	if (label)
	{
		LOCALE_FROM_UTF(label);
		_clip_retc(cm, label);
		FREE_TEXT(label);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONSETUSEUNDERLINE(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	gboolean    set = _clip_parl(cm, 2);

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);
	CHECKOPT(2, LOGICAL_t);

	gtk_tool_button_set_use_underline(GTK_TOOL_BUTTON(cbutton->widget),
		set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONGETUSEUNDERLINE(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);

	_clip_retl(cm, gtk_tool_button_get_use_underline(GTK_TOOL_BUTTON(cbutton->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONSETSTOCKID(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	gchar    *stock = _clip_parc(cm, 2);

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);
	CHECKOPT(2, CHARACTER_t);

	gtk_tool_button_set_stock_id(GTK_TOOL_BUTTON(cbutton->widget),
		stock);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONGETSTOCKID(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);

	_clip_retc(cm, (gchar *)gtk_tool_button_get_stock_id(GTK_TOOL_BUTTON(cbutton->widget)));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONSETICONWIDGET(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);
	CHECKCWID(cwid, GTK_IS_WIDGET);

	gtk_tool_button_set_icon_widget(GTK_TOOL_BUTTON(cbutton->widget),
		GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONGETICONWIDGET(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	GtkWidget *wid;
	C_widget *cwid;

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);

	wid = gtk_tool_button_get_icon_widget(GTK_TOOL_BUTTON(cbutton->widget));
	if (wid)
	{
		cwid = _list_get_cwidget(cm, wid);
		if (!cwid) cwid = _register_widget(cm, wid, NULL);
		if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
	}

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONSETLABELWIDGET(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	C_widget *cwid  = _fetch_cwidget(cm, _clip_spar(cm, 2));

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);
	CHECKCWID(cwid, GTK_IS_WIDGET);

	gtk_tool_button_set_label_widget(GTK_TOOL_BUTTON(cbutton->widget),
		GTK_WIDGET(cwid->widget));

	return 0;
err:
	return 1;
}

int
clip_GTK_TOOLBUTTONGETLABELWIDGET(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	GtkWidget *wid;
	C_widget *cwid;

	CHECKCWID(cbutton, GTK_IS_TOOL_BUTTON);

	wid = gtk_tool_button_get_label_widget(GTK_TOOL_BUTTON(cbutton->widget));
	if (wid)
	{
		cwid = _list_get_cwidget(cm, wid);
		if (!cwid) cwid = _register_widget(cm, wid, NULL);
		if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
	}

	return 0;
err:
	return 1;
}

/******************************************************************************/
/**************************** TOGGLE TOOL BUTTON ******************************/

int
clip_GTK_TOGGLETOOLBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkToolItem *item;
	C_widget *cbutton;

	CHECKOPT(1,MAP_t);

	item = gtk_toggle_tool_button_new();
	if (!item) goto err;
	cbutton = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&cbutton->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_TOGGLETOOLBUTTONNEWFROMSTOCK(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	gchar   *label = _clip_parc(cm, 2);
	GtkToolItem *item;
	C_widget *cbutton;

	CHECKOPT(1,MAP_t);
	CHECKARG(2, CHARACTER_t);

	item = gtk_toggle_tool_button_new_from_stock(label);

	if (!item) goto err;
	cbutton = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&cbutton->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_TOGGLETOOLBUTTONSETACTIVE(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	gboolean    set = _clip_parl(cm, 2);

	CHECKCWID(cbutton, GTK_IS_TOGGLE_TOOL_BUTTON);
	CHECKOPT(2, LOGICAL_t);

	gtk_toggle_tool_button_set_active(GTK_TOGGLE_TOOL_BUTTON(cbutton->widget),
		set);

	return 0;
err:
	return 1;
}

int
clip_GTK_TOGGLETOOLBUTTONGETACTIVE(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);

	CHECKCWID(cbutton, GTK_IS_TOGGLE_TOOL_BUTTON);

	_clip_retl(cm, gtk_toggle_tool_button_get_active(GTK_TOGGLE_TOOL_BUTTON(cbutton->widget)));

	return 0;
err:
	return 1;
}
/******************************************************************************/
/**************************** RADIO TOOL BUTTON *******************************/

int
clip_GTK_RADIOTOOLBUTTONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_object *cgroup = _fetch_cobject(cm, _clip_spar(cm, 2));
	GtkToolItem *item;
	C_widget *cbutton;

	CHECKOPT(1,MAP_t);
	CHECKCOBJOPT(cgroup, GTK_IS_OBJECT(cgroup->object));

	item = gtk_radio_tool_button_new((cgroup)?(GSList *)(cgroup->object):NULL);

	if (!item) goto err;
	cbutton = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&cbutton->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_RADIOTOOLBUTTONNEWFROMSTOCK(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_object *cgroup = _fetch_cobject(cm, _clip_spar(cm, 2));
	gchar   *label = _clip_parc(cm, 3);
	GtkToolItem *item;
	C_widget *cbutton;

	CHECKOPT(1,MAP_t);
	CHECKCOBJOPT(cgroup, GTK_IS_OBJECT(cgroup->object));
	CHECKARG(3, CHARACTER_t);

	item = gtk_radio_tool_button_new_from_stock((cgroup)?(GSList *)(cgroup->object):NULL,
		label);

	if (!item) goto err;
	cbutton = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&cbutton->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_RADIOTOOLBUTTONNEWFROMWIDGET(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_widget *cgroup = _fetch_cwidget(cm, _clip_spar(cm, 2));
	GtkToolItem *item;
	C_widget *cbutton;

	CHECKOPT(1,MAP_t);
	CHECKCWIDOPT(cgroup, GTK_IS_RADIO_TOOL_BUTTON);

	item = gtk_radio_tool_button_new_from_widget((cgroup)?GTK_RADIO_TOOL_BUTTON(cgroup->widget):NULL);

	if (!item) goto err;
	cbutton = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&cbutton->obj);
	return 0;
err:
	return 1;
}


int
clip_GTK_RADIOTOOLBUTTONNEWWITHSTOCKFROMWIDGET(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	C_widget *cgroup = _fetch_cwidget(cm, _clip_spar(cm, 2));
	gchar   *label = _clip_parc(cm, 3);
	GtkToolItem *item;
	C_widget *cbutton;

	CHECKOPT(1,MAP_t);
	CHECKCWIDOPT(cgroup, GTK_IS_RADIO_TOOL_BUTTON);
	CHECKARG(3, CHARACTER_t);

	item = gtk_radio_tool_button_new_with_stock_from_widget((cgroup)?GTK_RADIO_TOOL_BUTTON(cgroup->widget):NULL,
		label);

	if (!item) goto err;
	cbutton = _register_widget(cm, GTK_WIDGET(item), cv);
	_clip_mclone(cm,RETPTR(cm),&cbutton->obj);
	return 0;
err:
	return 1;
}


int
clip_GTK_RADIOTOOLBUTTONGETGROUP(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	GSList  * list ;
	C_object *cgroup ;

	CHECKOPT(1,MAP_t);
	CHECKCWIDOPT(cbutton, GTK_IS_RADIO_TOOL_BUTTON);

	list = gtk_radio_tool_button_get_group(GTK_RADIO_TOOL_BUTTON(cbutton->widget));

	if (list)
	{
		cgroup = _list_get_cobject(cm, list);
		if (!cgroup) cgroup = _register_object(cm, list, GTK_TYPE_OBJECT, NULL, NULL);
		_clip_mclone(cm,RETPTR(cm),&cgroup->obj);
	}
	return 0;
err:
	return 1;
}


int
clip_GTK_RADIOTOOLBUTTONSETGROUP(ClipMachine * cm)
{
	C_widget *cbutton = _fetch_cw_arg(cm);
	C_object  *cgroup = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKOPT(1,MAP_t);
	CHECKCWIDOPT(cbutton, GTK_IS_RADIO_TOOL_BUTTON);
	CHECKCOBJ(cgroup, GTK_IS_OBJECT(cgroup->object));

	gtk_radio_tool_button_set_group(GTK_RADIO_TOOL_BUTTON(cbutton->widget),
		(GSList *)(cgroup->object));

	return 0;
err:
	return 1;
}


