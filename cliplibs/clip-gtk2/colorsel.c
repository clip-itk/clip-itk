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
/* Signals table */
static SignalTable colorsel_signals[] =
{
	{"color-changed",	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_COLOR_CHANGED_SIGNAL},
	{"", NULL, NULL, 0}
};
/***********************************************************/

/* Register color selection in global table */
CLIP_DLLEXPORT GtkType _gtk_type_color_selection() { return GTK_TYPE_COLOR_SELECTION; }
long _clip_type_color_selection() { return GTK_WIDGET_COLOR_SELECTION; }
const char * _clip_type_name_color_selection() { return "GTK_WIDGET_COLOR_SELECTION"; }

/* Register color selection dialog in global table */
CLIP_DLLEXPORT GtkType _gtk_type_color_selection_dialog() { return GTK_TYPE_COLOR_SELECTION_DIALOG; }
long _clip_type_color_selection_dialog() { return GTK_WIDGET_COLOR_SELECTION_DIALOG; }
const char * _clip_type_name_color_selection_dialog() { return "GTK_WIDGET_COLOR_SELECTION_DIALOG"; }

int
clip_INIT___COLORSELECTION(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_color_selection, _clip_type_name_color_selection, _gtk_type_color_selection, _gtk_type_vbox, colorsel_signals);
	_wtype_table_put(_clip_type_color_selection_dialog, _clip_type_name_color_selection_dialog, _gtk_type_color_selection_dialog, _gtk_type_window, NULL);
	return 0;
}
/**********************************************************/

/****  Color selection constructor ****/
int
clip_GTK_COLORSELECTIONNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_color_selection_new();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

/* Sets the policy controlling when the color_changed signals are emitted.
   The available policies are:

    GTK_UPDATE_CONTINUOUS - signals are sent continuously as the color selection changes.

    GTK_UPDATE_DISCONTINUOUS - signals are sent only when the mouse button is released.

    GTK_UPDATE_DELAYED - signals are sent when the mouse button is released or when the
	mouse has been motionless for a period of time.
*/
int
clip_GTK_COLORSELECTIONSETUPDATEPOLICY(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	GtkUpdateType policy = _clip_parni(cm,2);
	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	CHECKOPT(2,NUMERIC_t);
	gtk_color_selection_set_update_policy(GTK_COLOR_SELECTION(ccsel->widget),policy);
	return 0;
err:
	return 1;
}

/* Controls whether opacity can be set with the GtkColorSelection. If this
 * functionality is enabled, the necessary additional widgets are added to
 * the GtkColorSelection and the opacity value can be retrieved via the fourth
 * value in the color array returned by the gtk_color_selection_get_color() function. */
int
clip_GTK_COLORSELECTIONSETHASOPACITYCONTROL(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	gboolean use_opacity = _clip_parl(cm,2);
	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) use_opacity = TRUE;
	gtk_color_selection_set_has_opacity_control(GTK_COLOR_SELECTION(ccsel->widget),use_opacity);
	return 0;
err:
	return 1;
}
int
clip_GTK_COLORSELECTIONGETHASOPACITYCONTROL(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	_clip_retl(cm, gtk_color_selection_get_has_opacity_control(GTK_COLOR_SELECTION(ccsel->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_COLORSELECTIONSETHASPALETTE(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	gboolean use_palette = _clip_parl(cm,2);
	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	CHECKOPT(2,LOGICAL_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) use_palette = TRUE;
	gtk_color_selection_set_has_palette(GTK_COLOR_SELECTION(ccsel->widget),use_palette);
	return 0;
err:
	return 1;
}

int
clip_GTK_COLORSELECTIONGETHASPALETTE(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	_clip_retl(cm, gtk_color_selection_get_has_palette(GTK_COLOR_SELECTION(ccsel->widget)));
	return 0;
err:
	return 1;
}


int
clip_GTK_COLORSELECTIONGETCURRENTALPHA(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	_clip_retni(cm, (int)gtk_color_selection_get_current_alpha(GTK_COLOR_SELECTION(ccsel->widget)));
	return 0;
err:
	return 1;
}



int
clip_GTK_COLORSELECTIONSETCURRENTALPHA(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
        guint16        alpha = _clip_parni(cm, 2);

	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
        CHECKARG(2, NUMERIC_t);

	gtk_color_selection_set_current_alpha(GTK_COLOR_SELECTION(ccsel->widget), alpha);
	return 0;
err:
	return 1;
}


int
clip_GTK_COLORSELECTIONGETCURRENTCOLOR(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
        GdkColor       color ;

	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);

	gtk_color_selection_get_current_color(GTK_COLOR_SELECTION(ccsel->widget), &color);

	memset(RETPTR(cm),0,sizeof(ClipVar)); _clip_map(cm,RETPTR(cm));
	_gdk_color_to_map(cm,color,RETPTR(cm));

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORSELECTIONSETCURRENTCOLOR(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
        ClipVar       *cvclr = _clip_spar(cm, 2);
        GdkColor       color ;

	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
        CHECKARG(2, MAP_t);

	_map_to_gdk_color(cm,&color,cvclr);

	gtk_color_selection_set_current_color(GTK_COLOR_SELECTION(ccsel->widget), &color);


	return 0;
err:
	return 1;
}
int
clip_GTK_COLORSELECTIONGETPREVIOUSALPHA(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	_clip_retni(cm, (int)gtk_color_selection_get_previous_alpha(GTK_COLOR_SELECTION(ccsel->widget)));
	return 0;
err:
	return 1;
}


int
clip_GTK_COLORSELECTIONSETPREVIOUSALPHA(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
        guint16        alpha = _clip_parni(cm, 2);

	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
        CHECKARG(2, NUMERIC_t);

	gtk_color_selection_set_previous_alpha(GTK_COLOR_SELECTION(ccsel->widget), alpha);
	return 0;
err:
	return 1;
}

int
clip_GTK_COLORSELECTIONGETPREVIOUSCOLOR(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
        GdkColor       color ;

	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);

	gtk_color_selection_get_previous_color(GTK_COLOR_SELECTION(ccsel->widget), &color);

	memset(RETPTR(cm),0,sizeof(ClipVar)); _clip_map(cm,RETPTR(cm));
	_gdk_color_to_map(cm,color,RETPTR(cm));

	return 0;
err:
	return 1;
}

int
clip_GTK_COLORSELECTIONSETPREVIOUSCOLOR(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
        ClipVar       *cvclr = _clip_spar(cm, 2);
        GdkColor       color ;

	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
        CHECKARG(2, MAP_t);

	_map_to_gdk_color(cm,&color,cvclr);

	gtk_color_selection_set_previous_color(GTK_COLOR_SELECTION(ccsel->widget), &color);


	return 0;
err:
	return 1;
}

int
clip_GTK_COLORSELECTIONISADJUSTING(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);

	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);

	_clip_retl(cm, gtk_color_selection_is_adjusting(GTK_COLOR_SELECTION(ccsel->widget)));


	return 0;
err:
	return 1;
}

/* gtk_ColorSelectionPaletteFromString(sPalette, @aColor, @nLenColor)--> TRUE||FALSE */
int
clip_GTK_COLORSELECTIONPALETTEFROMSTRING(ClipMachine *cm)
{
        gchar       *palette = _clip_parc(cm, 1);
        ClipVar     *cvcolor = _clip_spar(cm, 2);
        GdkColor     *color ;
        gint            len ;
        gboolean         ret ;

	CHECKARG(1, CHARACTER_t);

	ret = gtk_color_selection_palette_from_string(palette, &color, &len);


	if (ret)
        {
        	long i, d = len;
        	_clip_array(cm, cvcolor, 1, &d);
                for(i=0; i<len; i++)
                {
                	ClipVar  *cv;
			memset(cv,0,sizeof(ClipVar)); _clip_map(cm, cv);
			_gdk_color_to_map(cm,color[i],cv);
                        _clip_aset(cm, cvcolor, cv, 1, &i);
                }
                _clip_storni(cm, len, 3, 0);
        }

	_clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_COLORSELECTIONPALETTETOSTRING(ClipMachine *cm)
{
        ClipVar     *cvcolor = _clip_spar(cm, 1);
        gint             len = INT_OPTION(cm, 2, 0);
        gchar       *palette ;

	CHECKARG(1, ARRAY_t); CHECKARG(2, NUMERIC_t);

        if (len>0)
        {
        	GdkColor color[len];
                gint     i;
        	for(i=0; i<len; i++)
        	{
			_map_to_gdk_color(cm, &color[i], &cvcolor->a.items[i]);
        	}
		palette = gtk_color_selection_palette_to_string(color, len);
        }

	_clip_retc(cm, palette);
	return 0;
err:
	return 1;
}


/* Sets the color in the GtkColorSelection. The widgets are updated to
 * reflect the new color. */
int
clip_GTK_COLORSELECTIONSETCOLOR(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	ClipVar      *mcolor = _clip_spar(cm,2);
	gdouble color[4];
	gdouble k, max;

	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	CHECKOPT(2,MAP_t);
	if (_clip_parinfo(cm,2)==UNDEF_t)
		gtk_color_selection_get_color(GTK_COLOR_SELECTION(ccsel->widget),color);
	else
		_map_get_colors(cm,mcolor,color);
	color[0] = color[0] > 0 ? color[0] : 1;
	color[1] = color[1] > 0 ? color[1] : 1;
	color[2] = color[2] > 0 ? color[2] : 1;
	max = color[0] > color[1] ? color[0] : color[1];
	max = max > color[2] ? max : color[2];
	max = max > 0 ? max : 1;
	k = 1 / max;
	color[0] *= k; color[1] *= k; color[2] *= k;
	gtk_color_selection_set_color(GTK_COLOR_SELECTION(ccsel->widget),color);
	return 0;
err:
	return 1;
}

/* Retrieve the currently selected color value. */
int
clip_GTK_COLORSELECTIONGETCOLOR(ClipMachine *cm)
{
	C_widget      *ccsel = _fetch_cw_arg(cm);
	GtkColorSelection *colorsel;
	ClipVar mcolor;
	gdouble color[4];
	CHECKCWID(ccsel,GTK_IS_COLOR_SELECTION);
	colorsel = GTK_COLOR_SELECTION(ccsel->widget);
	gtk_color_selection_get_color(GTK_COLOR_SELECTION(ccsel->widget),color);
	color[0] *= CLIP_GTK_MAX_COLOR;
	color[1] *= CLIP_GTK_MAX_COLOR;
	color[2] *= CLIP_GTK_MAX_COLOR;
	memset(&mcolor,0,sizeof(mcolor)); _clip_map(cm,&mcolor);
	_map_put_colors(cm,&mcolor,color);
	_clip_mclone(cm,RETPTR(cm),&mcolor);
	return 0;
err:
	return 1;
}

/***************************************************************************/

/************        * Color selection dialog *                 ************/

/***************************************************************************/

/****  Color selection dialog constructor ****/
int
clip_GTK_COLORSELECTIONDIALOGNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	char * title   = _clip_parc(cm, 2);
	GtkWidget *wid = NULL;
	C_widget *cwid, *ccolorsel, *cokbtn, *ccancelbtn, *chlpbtn;
	CHECKOPT(1,MAP_t);
	CHECKOPT(2,CHARACTER_t);

	if (_clip_parinfo(cm,2)==UNDEF_t) title = "\0";
	LOCALE_TO_UTF(title);
	wid = gtk_color_selection_dialog_new(title);
	FREE_TEXT(title);
	cwid = _register_widget(cm, wid, cv);

	ccolorsel = _register_widget(cm, GTK_COLOR_SELECTION_DIALOG(wid)->colorsel, NULL);
	cokbtn = _register_widget(cm, GTK_COLOR_SELECTION_DIALOG(wid)->ok_button, NULL);
	ccancelbtn = _register_widget(cm, GTK_COLOR_SELECTION_DIALOG(wid)->cancel_button, NULL);
	chlpbtn = _register_widget(cm, GTK_COLOR_SELECTION_DIALOG(wid)->help_button, NULL);

	if (ccolorsel) _clip_madd(cm,&cwid->obj,HASH_COLORSEL,&ccolorsel->obj);
	if (cokbtn) _clip_madd(cm,&cwid->obj,HASH_OKBUTTON,&cokbtn->obj);
	if (ccancelbtn) _clip_madd(cm,&cwid->obj,HASH_CANCELBUTTON,&ccancelbtn->obj);
	if (chlpbtn) _clip_madd(cm,&cwid->obj,HASH_HELPBUTTON,&chlpbtn->obj);

	if (ccolorsel) _clip_destroy(cm,&ccolorsel->obj);
	if (cokbtn) _clip_destroy(cm,&cokbtn->obj);
	if (ccancelbtn) _clip_destroy(cm,&ccancelbtn->obj);
	if (chlpbtn) _clip_destroy(cm,&chlpbtn->obj);

	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}
/****  ------------------ ****/

