/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"
#include "clip-gdk2.h"

GtkType _gdk_type_cursor() { return GDK_OBJECT_CURSOR; }
long _clip_type_cursor() { return GDK_OBJECT_CURSOR; }
const char * _clip_type_name_cursor() { return "GDK_OBJECT_CURSOR"; }

int
clip_INIT___GDK(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_cursor, _clip_type_name_cursor, _gdk_type_cursor, NULL, NULL);
	return 0;
}
/**********************************************************/

/* Returns the width of the screen in pixels. */
int
clip_GDK_SCREENWIDTH(ClipMachine * cm)
{
	_clip_retni(cm, gdk_screen_width());
	return 0;
}

// Returns the height of the screen in pixels.
int
clip_GDK_SCREENHEIGHT(ClipMachine * cm)
{
	_clip_retni(cm, gdk_screen_height());
	return 0;
}

// Returns the width of the screen in millimeters.
// Note that on many X servers this value will not be correct.
int
clip_GDK_SCREENWIDTHMM(ClipMachine * cm)
{
	_clip_retni(cm, gdk_screen_width_mm());
	return 0;
}

// Returns the height of the screen in millimeters.
// Note that on many X servers this value will not be correct.
int
clip_GDK_SCREENHEIGHTMM(ClipMachine * cm)
{
	_clip_retni(cm, gdk_screen_height_mm());
	return 0;
}

/* Emits a short beep. */
int
clip_GDK_BEEP(ClipMachine * cm)
{
	gdk_beep();
	return 0;
}

static int
gdk_object_cursor_destructor(ClipMachine *cm, C_object *ccur)
{
	if (ccur && GDK_IS_CURSOR(ccur) && ccur->ref_count >= 0)
		gdk_cursor_destroy(GDK_CURSOR(ccur->object));
	return 0;
}

// Sets shape of mouse cursor
int
clip_GDK_WINDOWSETCURSOR(ClipMachine * cm)
{
	C_widget *cwin = _fetch_cw_arg(cm);
	GdkCursorType cursor_type = _clip_parni(cm, 2);

	CHECKCWID(cwin,GTK_IS_WIDGET); CHECKOPT(2,NUMERIC_t);

	if (cwin && cwin->widget)
	{
		GdkCursor *cursor = gdk_cursor_new(cursor_type);
		C_object *ccur;

		if (cursor)
		{
			ccur = _register_object(cm,cursor,GDK_OBJECT_CURSOR,NULL,
				(coDestructor)gdk_object_cursor_destructor);
			ccur->ref_count = 1;
			_clip_mclone(cm,RETPTR(cm),&ccur->obj);
		}
		gdk_window_set_cursor(cwin->widget->window, cursor);
	}
	return 0;
err:
	return 1;
}

/* Grabs the pointer (usually a mouse) so that all events are passed to this
 * application until the pointer is ungrabbed with gdk_pointer_ungrab(), or
 * the grab window becomes unviewable. This overrides any previous pointer
 * grab by this client.

 * Pointer grabs are used for operations which need complete control over mouse
 * events, even if the mouse leaves the application. For example in GTK+ it is
 * used for Drag and Drop, for dragging the handle in the GtkHPaned and GtkVPaned
 * widgets, and for resizing columns in GtkCList widgets.

 * Note that if the event mask of an X window has selected both button press and
 * button release events, then a button press event will cause an automatic pointer
 * grab until the button is released. X does this automatically since most
 * applications expect to receive button press and release events in pairs.
 * It is equivalent to a pointer grab on the window with owner_events set to TRUE. */
int
clip_GDK_POINTERGRAB(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	GdkWindow *win = NULL;
	gboolean owner_events = _clip_parl(cm,2);
	GdkEventMask event_mask = _clip_parnl(cm,3);
	C_widget *cconfine_to = _fetch_cwidget(cm,_clip_spar(cm,4));
	GdkWindow *confine_to = NULL;
	C_object *ccursor = _fetch_cobject(cm,_clip_spar(cm,5));
	GdkCursor *cursor = NULL;

	CHECKCWID(cwin,GTK_IS_WIDGET);
	CHECKOPT(2,LOGICAL_t); CHECKOPT(3,NUMERIC_t);
	CHECKOPT2(4,MAP_t,NUMERIC_t); CHECKCWIDOPT(cwin,GTK_IS_WIDGET);
	CHECKOPT2(5,MAP_t,NUMERIC_t); CHECKCOBJOPT(ccursor,GDK_IS_CURSOR(ccursor));

	if (cwin && cwin->widget) win = cwin->widget->window;
	if (cconfine_to && cconfine_to->widget) confine_to = cconfine_to->widget->window;
	if (ccursor) cursor = GDK_CURSOR(ccursor->object);

	_clip_retni(cm,gdk_pointer_grab(win, owner_events, event_mask,
		confine_to, cursor, GDK_CURRENT_TIME));

	return 0;
err:
	return 1;
}

/* Ungrabs the pointer, if it is grabbed by this application. */
int
clip_GDK_POINTERUNGRAB(ClipMachine * cm)
{
	gdk_pointer_ungrab(GDK_CURRENT_TIME);
	return 0;
}

/* Returns TRUE if the pointer is currently grabbed by this application.

 * Note that the return value is not completely reliable since the X server
 * may automatically ungrab the pointer, without informing the application,
 * if the grab window becomes unviewable. It also does not take passive
 * pointer grabs into account. */
int
clip_GDK_POINTERISGRABBED(ClipMachine * cm)
{
	_clip_retl(cm,gdk_pointer_is_grabbed());
	return 0;
}

/* Grabs the keyboard so that all events are passed to this application until
 * the keyboard is ungrabbed with gdk_keyboard_ungrab().
 * This overrides any previous keyboard grab by this client. */
int
clip_GDK_KEYBOARDGRAB(ClipMachine * cm)
{
	C_widget    *cwin = _fetch_cw_arg(cm);
	GdkWindow *win = NULL;
	gint owner_events = _clip_parl(cm,2);

	CHECKCWID(cwin,GTK_IS_WIDGET);
	CHECKOPT(2,LOGICAL_t);

	if (cwin && cwin->widget) win = cwin->widget->window;

	gdk_keyboard_grab(win, owner_events, GDK_CURRENT_TIME);

	return 0;
err:
	return 1;
}

/* Ungrabs the keyboard, if it is grabbed by this application. */
int
clip_GDK_KEYBOARDUNGRAB(ClipMachine * cm)
{
	gdk_keyboard_ungrab(GDK_CURRENT_TIME);
	return 0;
}


/* Converts a key value into a symbolic name. The names are the same as those
   in the <clip-gdk.ch> header file but without the leading "GDK_". */
int
clip_GDK_KEYVALNAME(ClipMachine * cm)
{
	guint keyval = INT_OPTION(cm, 1,0);
	_clip_retc(cm, gdk_keyval_name(keyval));
	return 0;
}

/* Converts a key name to a key value. */
int
clip_GDK_KEYVALFROMNAME(ClipMachine * cm)
{
	gchar * keyval_name = CHAR_OPTION(cm, 1,"");
	_clip_retni(cm, gdk_keyval_from_name(keyval_name));
	return 0;
}

/* Returns TRUE if the given key value is in upper case. */
int
clip_GDK_KEYVALISUPPER(ClipMachine * cm)
{
	guint keyval = INT_OPTION(cm, 1,0);
	_clip_retl(cm, gdk_keyval_is_upper(keyval));
	return 0;
}

/* Returns TRUE if the given key value is in lower case. */
int
clip_GDK_KEYVALISLOWER(ClipMachine * cm)
{
	guint keyval = INT_OPTION(cm, 1,0);
	_clip_retl(cm, gdk_keyval_is_lower(keyval));
	return 0;
}

/* Converts a key value to upper case, if applicable. */
int
clip_GDK_KEYVALTOUPPER(ClipMachine * cm)
{
	guint keyval = INT_OPTION(cm, 1,0);
	_clip_retl(cm, gdk_keyval_to_upper(keyval));
	return 0;
}

/* Converts a key value to lower case, if applicable. */
int
clip_GDK_KEYVALTOLOWER(ClipMachine * cm)
{
	guint keyval = INT_OPTION(cm, 1,0);
	_clip_retl(cm, gdk_keyval_to_lower(keyval));
	return 0;
}

int
clip_GDK_KEYVALTOUNICODE(ClipMachine * cm)
{
	guint keyval = INT_OPTION(cm, 1,0);
        wchar_t wc ; //= INT_OPTION(cm, 1,0);
        gchar *result ;
        int total_len, first, clen ;
	wc  = gdk_keyval_to_unicode(keyval);

  	total_len = 0;
      	if (wc < 0x80)
		total_len += 1;
      	else if (wc < 0x800)
		total_len += 2;
      	else if (wc < 0x10000)
		total_len += 3;
      	else if (wc < 0x200000)
		total_len += 4;
      	else if (wc < 0x4000000)
		total_len += 5;
      	else
		total_len += 6;

  	result = calloc(total_len+1, sizeof(char));

      	if (wc < 0x80)
	{
		first = 0;
		clen = 1;
	}
      	else if (wc < 0x800)
	{
		first = 0xc0;
		clen = 2;
	}
      	else if (wc < 0x10000)
	{
		first = 0xe0;
		clen = 3;
	}
      	else if (wc < 0x200000)
	{
		first = 0xf0;
		clen = 4;
	}
      	else if (wc < 0x4000000)
	{
		first = 0xf8;
		clen = 5;
	}
      	else
	{
		first = 0xfc;
		clen = 6;
	}

      	switch (clen)
	{
		case 6: result[5] = (wc & 0x3f) | 0x80; wc >>= 6; /* Fall through */
		case 5: result[4] = (wc & 0x3f) | 0x80; wc >>= 6; /* Fall through */
		case 4: result[3] = (wc & 0x3f) | 0x80; wc >>= 6; /* Fall through */
		case 3: result[2] = (wc & 0x3f) | 0x80; wc >>= 6; /* Fall through */
		case 2: result[1] = (wc & 0x3f) | 0x80; wc >>= 6; /* Fall through */
		case 1: result[0] = wc | first;

	}

	_clip_retc(cm, result);
        free(result);
	return 0;
}


