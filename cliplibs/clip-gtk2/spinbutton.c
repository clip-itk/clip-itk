/*
    Copyright (C) 2002  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <string.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

static
gint handle_change_value_signal (GtkSpinButton *sbutton, GtkScrollType *type, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputn(cs->cw->cmachine, &cv, HASH_SCROLL_TYPE, (gint)type);
	INVOKESIGHANDLER(GTK_WIDGET(sbutton),cs,cv);
}

static
gint handle_input_signal (GtkSpinButton *sbutton, gpointer data, C_signal *cs)
{
	PREPARECV(cs,cv);

	INVOKESIGHANDLER(GTK_WIDGET(sbutton),cs,cv);
}

static SignalTable spin_button_signals[] =
{
	{"change-value",	GSF( handle_change_value_signal ),	ESF( object_emit_signal ), GTK_CHANGE_VALUE_SIGNAL},
	{"input",		GSF( handle_input_signal ),	ESF( object_emit_signal ), GTK_INPUT_SIGNAL},
	{"output",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_OUTPUT_SIGNAL},
	{"value-changed",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_VALUE_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_spin_button() { return GTK_TYPE_SPIN_BUTTON; }
long _clip_type_spin_button() { return GTK_WIDGET_SPIN_BUTTON; }
const char * _clip_type_name_spin_button()  { return "GTK_OBJECT_SPIN_BUTTON"; }

/* Register spin button in global table */
int
clip_INIT___SPIN_BUTTON(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_spin_button, _clip_type_name_spin_button, _gtk_type_spin_button, _gtk_type_entry, spin_button_signals);
	return 0;
}

/**** ------------------ ****/
/**** SPIN BUTTON constructor ****/
int
clip_GTK_SPINBUTTONNEW(ClipMachine * cm)
{
	ClipVar    * cv = _clip_spar(cm, 1);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
        gfloat climb_rate = DBL_OPTION(cm,3,1);
        guint digits    = INT_OPTION(cm,4,1);
	GtkWidget *wid = NULL;
	GtkAdjustment *adj;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
        adj = cadj ? GTK_ADJUSTMENT(cadj->widget) : NULL;
        wid = gtk_spin_button_new(adj,climb_rate,digits);
        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int clip_GTK_SPINBUTTONNEWWITHRANGE(ClipMachine * cm) {
	ClipVar    * cv = _clip_spar(cm, 1);
        gdouble     min = _clip_parnd(cm, 2);
        gdouble     max = _clip_parnd(cm, 3);
        gdouble    step = _clip_parnd(cm, 4);
	GtkWidget *wid = NULL;
        C_widget *cwid;

	CHECKOPT(1,MAP_t);
        CHECKOPT(2,NUMERIC_t);CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);

        wid = gtk_spin_button_new_with_range(min, max, step);

        if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONCONFIGURE(ClipMachine * cm)
{
	C_widget * cspb = _fetch_cw_arg(cm);
	C_widget * cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
        gfloat climb_rate = DBL_OPTION(cm,3,1);
        guint digits    = INT_OPTION(cm,4,1);
	GtkAdjustment *adj;

	CHECKARG2(1,MAP_t, NUMERIC_t); CHECKCWID(cspb, GTK_IS_SPIN_BUTTON);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);
        CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);
        adj = cadj ? GTK_ADJUSTMENT(cadj->widget) : NULL;
        gtk_spin_button_configure(GTK_SPIN_BUTTON(cspb->widget), adj,climb_rate,digits);
	return 0;
err:
	return 1;
}
/**** ------------------ ****/

/* Changes which GtkAdjustment is associated with a spin button. */
int
clip_GTK_SPINBUTTONSETADJUSTMENT (ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
	C_widget *cadj = _fetch_cwidget(cm,_clip_spar(cm, 2));
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
	CHECKOPT2(2,MAP_t,NUMERIC_t); CHECKCWIDOPT(cadj,GTK_IS_ADJUSTMENT);
        gtk_spin_button_set_adjustment (GTK_SPIN_BUTTON(cspb->widget),
        	GTK_ADJUSTMENT(cadj->widget));
	return 0;
err:
	return 1;
}

/* Retrieves the GtkAdjustment used by a given spin button. */
int
clip_GTK_SPINBUTTONGETADJUSTMENT (ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        ClipVar * cv  = RETPTR(cm);
        GtkAdjustment* adj;
        C_widget *cadj;
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        adj = gtk_spin_button_get_adjustment (GTK_SPIN_BUTTON(cspb->widget));
        cadj = _list_get_cwidget(cm, adj);
        if (!cadj) cadj = _register_widget(cm, (GtkWidget*)adj, NULL);
        if (cadj) _clip_mclone(cm, cv, &cadj->obj);
	return 0;
err:
	return 1;
}

/* Alters the number of decimal places that are displayed in a spin button. */
int
clip_GTK_SPINBUTTONSETDIGITS (ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        guint   digits = _clip_parni(cm,2);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKOPT(2,NUMERIC_t);
        gtk_spin_button_set_digits(GTK_SPIN_BUTTON(cspb->widget), digits);
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONSETINCREMENTS(ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        gdouble   step = _clip_parnd(cm,2);
        gdouble   page = _clip_parnd(cm,3);

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKARG(2,NUMERIC_t);
        CHECKARG(3,NUMERIC_t);

        gtk_spin_button_set_increments(GTK_SPIN_BUTTON(cspb->widget), step, page);
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONSETRANGE(ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        gdouble    min = _clip_parnd(cm,2);
        gdouble    max = _clip_parnd(cm,3);

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKARG(2,NUMERIC_t);
        CHECKARG(3,NUMERIC_t);

        gtk_spin_button_set_range(GTK_SPIN_BUTTON(cspb->widget), min, max);
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONGETVALUEASINT(ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        gint       ret ;

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);

        ret = gtk_spin_button_get_value_as_int(GTK_SPIN_BUTTON(cspb->widget));
        _clip_retni(cm, ret);
	return 0;
err:
	return 1;
}


/* Retrieves the current value of a GtkSpinButton. */
int
clip_GTK_SPINBUTTONGETVALUE (ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        _clip_retnd(cm,gtk_spin_button_get_value(GTK_SPIN_BUTTON(cspb->widget)));
	return 0;
err:
	return 1;
}

/* Sets the value of a spin button. */
int
clip_GTK_SPINBUTTONSETVALUE (ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        gfloat   value = _clip_parnd(cm,2);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKOPT(2,NUMERIC_t);
        gtk_spin_button_set_value(GTK_SPIN_BUTTON(cspb->widget), value);
	return 0;
err:
	return 1;
}

/* Changes the way a spin button refreshes and updates itself. */
int
clip_GTK_SPINBUTTONSETUPDATEPOLICY (ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        GtkSpinButtonUpdatePolicy policy = _clip_parni(cm,2);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKOPT(2,NUMERIC_t);
        gtk_spin_button_set_update_policy(GTK_SPIN_BUTTON(cspb->widget), policy);
	return 0;
err:
	return 1;
}

/* Sets how the spin button's GtkEntry reacts to alphabetic characters.
 * A value of TRUE to numeric means that all non-numeric characters
 * (except '-' and a decimal point) are ignored. */
int
clip_GTK_SPINBUTTONSETNUMERIC (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        gboolean numeric = BOOL_OPTION(cm,2, TRUE);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKOPT(2,LOGICAL_t);
        gtk_spin_button_set_numeric(GTK_SPIN_BUTTON(cspb->widget), numeric);
	return 0;
err:
	return 1;
}

/* Performs an explicit 'spin' on a spin button. */
int
clip_GTK_SPINBUTTONSPIN (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        GtkSpinType direction = _clip_parni(cm,2);
        gfloat increment = _clip_parnd(cm,3);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_spin_button_spin(GTK_SPIN_BUTTON(cspb->widget), direction, increment);
	return 0;
err:
	return 1;
}

/* Sets a spin button's value to the lower limit when
 * it's upper limit is reached, and vice versa. */
int
clip_GTK_SPINBUTTONSETWRAP(ClipMachine *cm)
{
	C_widget *cspb = _fetch_cw_arg(cm);
        gboolean  wrap = BOOL_OPTION(cm,2, TRUE);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKOPT(2,LOGICAL_t);
        gtk_spin_button_set_wrap(GTK_SPIN_BUTTON(cspb->widget), wrap);
	return 0;
err:
	return 1;
}


int
clip_GTK_SPINBUTTONSETCLIMBRATE (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        gfloat climb_rate = _clip_parnd(cm,2);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKOPT(2,NUMERIC_t);
	gtk_widget_set(cspb->widget,"climb-rate",climb_rate,NULL);
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONGETCLIMBRATE (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
	_clip_retnd(cm,GTK_SPIN_BUTTON(cspb->widget)->climb_rate);
	return 0;
err:
	return 1;
}



/* Sets whether a number typed into a spin button should
 * be snapped to the nearest step increment. */
int
clip_GTK_SPINBUTTONSETSNAPTOTICKS (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        gboolean snap_to_ticks = BOOL_OPTION(cm,2, TRUE);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        CHECKOPT(2,LOGICAL_t);
        gtk_spin_button_set_snap_to_ticks(GTK_SPIN_BUTTON(cspb->widget), snap_to_ticks);
	return 0;
err:
	return 1;
}

/* Refreshes a spin button. The behaviour of the update is
 * determined by gtk_spin_button_set_update_policy(). */
int
clip_GTK_SPINBUTTONUPDATE (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);
        gtk_spin_button_update(GTK_SPIN_BUTTON(cspb->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONGETDIGITS (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        guint        ret ;

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);

        ret = gtk_spin_button_get_digits(GTK_SPIN_BUTTON(cspb->widget));
        _clip_retni(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONGETINCREMENTS (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        gdouble step, page ;

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);

        gtk_spin_button_get_increments(GTK_SPIN_BUTTON(cspb->widget), &step, &page);

        _clip_stornd(cm, step, 2, 0);
        _clip_stornd(cm, page, 3, 0);
	return 0;
err:
	return 1;
}


int
clip_GTK_SPINBUTTONGETNUMERIC (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        gboolean     ret ;

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);

        ret = gtk_spin_button_get_numeric(GTK_SPIN_BUTTON(cspb->widget));

        _clip_retl(cm, ret);
	return 0;
err:
	return 1;
}


int
clip_GTK_SPINBUTTONGETRANGE (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        gdouble min, max ;

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);

        gtk_spin_button_get_range(GTK_SPIN_BUTTON(cspb->widget), &min, &max);

        _clip_stornd(cm, min, 2, 0);
        _clip_stornd(cm, max, 3, 0);
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONGETSNAPTOTICKS (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        gboolean     ret ;

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);

        ret = gtk_spin_button_get_snap_to_ticks(GTK_SPIN_BUTTON(cspb->widget));

        _clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_SPINBUTTONGETUPDATEPOLICY (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        GtkSpinButtonUpdatePolicy policy;

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);

        policy = gtk_spin_button_get_update_policy(GTK_SPIN_BUTTON(cspb->widget));

        _clip_retni(cm, (int)policy);
	return 0;
err:
	return 1;
}


int
clip_GTK_SPINBUTTONGETWRAP (ClipMachine *cm)
{
	C_widget   *cspb = _fetch_cw_arg(cm);
        gboolean     ret ;

        CHECKCWID(cspb,GTK_IS_SPIN_BUTTON);

        ret = gtk_spin_button_get_wrap(GTK_SPIN_BUTTON(cspb->widget));

        _clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

