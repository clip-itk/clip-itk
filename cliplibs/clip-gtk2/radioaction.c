
/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <string.h>
#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/* Signals table */
static gint
handle_changed_signal(GtkRadioAction *action, GtkRadioAction *current, C_signal *cs)
{
	C_object *ccur;
	OBJECTPREPARECV(cs,cv);
        ccur = _list_get_cobject(cs->co->cmachine, current);
        if (!ccur) ccur = _register_object(cs->co->cmachine, current, GTK_TYPE_RADIO_ACTION, NULL, NULL);
        if (ccur) _clip_madd(cs->co->cmachine, &cv, HASH_CURRENT, &ccur->obj);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
static SignalTable radio_action_signals[] =
{
	{"changed",	GSF( handle_changed_signal ), ESF( object_emit_signal ), GTK_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_radio_action() { return GTK_TYPE_RADIO_ACTION; }

long _clip_type_radio_action() { return GTK_OBJECT_RADIO_ACTION; }

const char * _clip_type_name_radio_action()  { return "GTK_OBJECT_RADIO_ACTION"; }

int
clip_INIT___RADIOACTION(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_radio_action,  _clip_type_name_radio_action,  _gtk_type_radio_action,  _gtk_type_toggle_action, radio_action_signals);
	return 0;
}

int
clip_GTK_RADIOACTIONNEW(ClipMachine * cm)
{
	ClipVar *cv       = _clip_spar(cm,1);
        gchar      * name = _clip_parc(cm, 2);
        gchar     * label = _clip_parc(cm, 3);
        gchar   * tooltip = _clip_parc(cm, 4);
        gchar  * stock_id = _clip_parc(cm, 5);
        gint        value = _clip_parni(cm, 6);
        C_object *caction;
        GtkRadioAction *action;

	CHECKOPT(1,MAP_t);
        CHECKARG(2, CHARACTER_t);
        CHECKARG(3, CHARACTER_t);
        CHECKOPT(4, CHARACTER_t);
        CHECKOPT(5, CHARACTER_t);
        CHECKOPT(6, NUMERIC_t);

	LOCALE_TO_UTF(name);
	LOCALE_TO_UTF(label);
        if (tooltip) LOCALE_TO_UTF(tooltip);
        if (stock_id) LOCALE_TO_UTF(stock_id);

	action = gtk_radio_action_new(name, label, tooltip, stock_id, value);

	if (action)
	{
		caction = _list_get_cobject(cm,action);
		if (!caction) caction = _register_object(cm,action,GTK_TYPE_RADIO_ACTION,cv,NULL);
		if (caction) _clip_mclone(cm,RETPTR(cm),&caction->obj);
	}

	FREE_TEXT(name);
	FREE_TEXT(label);
	if (tooltip) FREE_TEXT(tooltip);
	if (stock_id) FREE_TEXT(stock_id);
	return 0;
err:
	return 1;
}

int
clip_GTK_RADIOACTIONGETGROUP(ClipMachine * cm)
{
        C_object *caction = _fetch_co_arg(cm);
        GSList     *group;
        C_object  *cgroup;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_RADIO_ACTION(caction->object));

	group = gtk_radio_action_get_group(GTK_RADIO_ACTION(caction->object));

	cgroup = _list_get_cobject(cm, group);
        if (!cgroup) cgroup = _register_object(cm, group, GTK_TYPE_OBJECT, NULL, NULL);
        _clip_mclone(cm, RETPTR(cm), &cgroup->obj);

	return 0;
err:
	return 1;
}

int
clip_GTK_RADIOACTIONSETGROUP(ClipMachine * cm)
{
        C_object *caction = _fetch_co_arg(cm);
        C_object  *cgroup = _fetch_cobject(cm, _clip_spar(cm, 2));

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_RADIO_ACTION(caction->object));
	CHECKARG2(2,MAP_t, NUMERIC_t); CHECKCOBJ(cgroup, GTK_IS_OBJECT(cgroup->object));

	gtk_radio_action_set_group(GTK_RADIO_ACTION(caction->object),
		(GSList *)cgroup->object);

	return 0;
err:
	return 1;
}

int
clip_GTK_RADIOACTIONGETCURRENTVALUE(ClipMachine * cm)
{
        C_object *caction = _fetch_co_arg(cm);

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCOBJ(caction, GTK_IS_RADIO_ACTION(caction->object));

	_clip_retni(cm, gtk_radio_action_get_current_value(GTK_RADIO_ACTION(caction->object)));

	return 0;
err:
	return 1;
}

