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

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
/* Signals table */
static SignalTable calendar_signals[] =
{
	/* Emitted when the user clicks a button to change the selected month on a calendar. */
	{"month-changed",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_MONTH_CHANGED_SIGNAL},
	/* Emitted when the user selects a day. */
	{"day-selected",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_DAY_SELECTED_SIGNAL},
	{"day-selected-double-click",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_DAY_SELECTED_DOUBLE_CLICK_SIGNAL},
	{"prev-month",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_PREV_MONTH_SIGNAL},
	{"next-month",		GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_NEXT_MONTH_SIGNAL},
	{"prev-year",		GSF( widget_signal_handler ),		ESF( object_emit_signal ), GTK_PREV_YEAR_SIGNAL},
	{"next-year",		GSF( widget_signal_handler ),		ESF( object_emit_signal ), GTK_NEXT_YEAR_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register calendar in global table */
CLIP_DLLEXPORT GtkType _gtk_type_calendar() { return GTK_TYPE_CALENDAR; }
long _clip_type_calendar() { return GTK_WIDGET_CALENDAR; }
const char * _clip_type_name_calendar() { return "GTK_WIDGET_CALENDAR"; }

int
clip_INIT___CALENDAR(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_calendar, _clip_type_name_calendar, _gtk_type_calendar,  _gtk_type_widget, calendar_signals);
	return 0;
}
/**********************************************************/

/**** CALENDAR constructor ****/
int
clip_GTK_CALENDARNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
        C_widget *cwid;
	CHECKOPT(1,MAP_t);

        wid = gtk_calendar_new();
        if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
        _clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/


/* Shifts the calendar to a different month. */
int
clip_GTK_CALENDARSELECTMONTH(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        guint    month = _clip_parni(cm,2);
        guint     year = _clip_parni(cm,3);
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);
        gtk_calendar_select_month(GTK_CALENDAR(ccal->widget), month-1, year);
	return 0;
err:
	return 1;
}

/* Selects a day from the current month. */
int
clip_GTK_CALENDARSELECTDAY(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        guint      day = _clip_parni(cm,2);
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        CHECKOPT(2,NUMERIC_t);
        gtk_calendar_select_day(GTK_CALENDAR(ccal->widget), day);
	return 0;
err:
	return 1;
}


int
clip_GTK_CALENDARMARKDAY(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        guint      day = _clip_parni(cm,2);
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        CHECKOPT(2,NUMERIC_t);
        gtk_calendar_mark_day(GTK_CALENDAR(ccal->widget), day);
	return 0;
err:
	return 1;
}

int
clip_GTK_CALENDARUNMARKDAY(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        guint      day = _clip_parni(cm,2);
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        CHECKOPT(2,NUMERIC_t);
        gtk_calendar_unmark_day(GTK_CALENDAR(ccal->widget), day);
	return 0;
err:
	return 1;
}

int
clip_GTK_CALENDARCLEARMARKS(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        gtk_calendar_clear_marks(GTK_CALENDAR(ccal->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_CALENDARDISPLAYOPTIONS(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        GtkCalendarDisplayOptions flags = _clip_parni(cm,2);
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        CHECKARG(2,NUMERIC_t);
        gtk_calendar_display_options(GTK_CALENDAR(ccal->widget),flags);
	return 0;
err:
	return 1;
}

int
clip_GTK_CALENDARGETDATE(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        guint year,month, day;
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        gtk_calendar_get_date(GTK_CALENDAR(ccal->widget), &year, &month, &day);
        _clip_retdc(cm,year,month+1,day);
	return 0;
err:
	return 1;
}

/* Locks the display of the calendar until it is thawed with gtk_calendar_thaw(). */
int
clip_GTK_CALENDARFREEZE(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        gtk_calendar_freeze(GTK_CALENDAR(ccal->widget));
	return 0;
err:
	return 1;
}

/* Defrosts a calendar; all the changes made since
 * the last gtk_calendar_freeze() are displayed. */
int
clip_GTK_CALENDARTHAW(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        CHECKCWID(ccal,GTK_IS_CALENDAR);
        gtk_calendar_thaw(GTK_CALENDAR(ccal->widget));
	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)

int
clip_GTK_CALENDARGETDISPLAYOPTIONS(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);

        CHECKCWID(ccal,GTK_IS_CALENDAR);

        _clip_retni(cm, gtk_calendar_get_display_options(GTK_CALENDAR(ccal->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_CALENDARSETDISPLAYOPTIONS(ClipMachine * cm)
{
	C_widget *ccal = _fetch_cw_arg(cm);
        GtkCalendarDisplayOptions opt = _clip_parni(cm, 2);

        CHECKCWID(ccal,GTK_IS_CALENDAR);
        CHECKARG(2, NUMERIC_t);

        gtk_calendar_set_display_options(GTK_CALENDAR(ccal->widget), opt);
	return 0;
err:
	return 1;
}
#endif
