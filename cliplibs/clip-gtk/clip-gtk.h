/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#ifndef __CLIP_GTK_H__
#define __CLIP_GTK_H__

#include <gtk/gtk.h>
#include "clip.h"
#include "error.ch"

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define GSF	GTK_SIGNAL_FUNC
#define ESF	(EmitSignalFunction)

typedef struct _C_signal		C_signal;
typedef struct _C_object		C_object;
typedef struct _C_widget		C_widget;
typedef struct _WTypeTable		WTypeTable;
typedef struct _SignalTable		SignalTable;
typedef struct _ExtraSignalTable	ExtraSignalTable;

typedef void (*cwDestructor) (ClipMachine *cm, C_widget *cwid);
typedef void (*coDestructor) (ClipMachine *cm, C_object *cobj);
typedef int (*EmitSignalFunction) (C_widget *cwid, const gchar *signal_name);
typedef GtkType (*TypeFunc) (void);
typedef const char * (*TypeNameFunc) (void);
typedef long (*ClipTypeFunc) (void);

typedef struct _C_object
{
	void 		*object;
	ClipMachine	*cmachine;
	long		objtype;
	long		type;
	const char	*type_name;
	int		handle;
	ClipVar		obj;
	coDestructor	destroy;
	int		ref_count;
} _C_object;

typedef struct _C_widget
{
	GtkWidget	*widget;
	GtkAccelGroup	*accel_group;
	GtkWidget	*label;
	ClipMachine	*cmachine;
	ClipVar		obj;
//	ClipVar		msig;
	C_signal	*siglist;
	ClipVar		mdata;
	int		usersigenabled;
	int		sigenabled;
	int		evntenabled;
	long		objtype;
	GtkType		type;
	const char	*type_name;
	int		handle;
	cwDestructor	destroy;
	void		*data;
} _C_widget;

typedef struct
{
	ClipVar cfunc;
	unsigned int id;
	ClipMachine *cm;
	ClipVar *cv;
	C_widget *cw;
	C_object *co;
}
C_var;

typedef struct _C_signal
{
	C_widget *cw;
	C_object *co;
	const char * signame;
	int sigid;
	ClipVar cfunc;
	C_signal *next;
}
_C_signal;


typedef struct _SignalTable
{
	char * signame;
	GtkSignalFunc sigfunction;
	EmitSignalFunction emitsigfunction;
	int sigid;
} _SignalTable;

typedef struct _ExtraSignalTable
{
	char * signame;
	GtkSignalFunc sigfunction;
	EmitSignalFunction emitsigfunction;
	int sigid;
	ExtraSignalTable * next;
} _ExtraSignalTable;

typedef struct _WTypeTable
{
	TypeFunc ftype;
	TypeNameFunc ftype_name;
	TypeFunc fsuper_type;
	ClipTypeFunc fclip_type;
	SignalTable * signal_table;
	ExtraSignalTable * extra_signal_table;
	WTypeTable * next;

} _WTypeTable;

#ifdef OS_CYGWIN
	#define LOCALE_TO_UTF(text)	text = text ? _clip_locale_to_utf8(text) : NULL;
	#define LOCALE_FROM_UTF(text)	text = text ? _clip_locale_from_utf8(text) : NULL;
	#define	FREE_TEXT(text)		if (text) g_free(text);
#else
	#define LOCALE_TO_UTF(text)
	#define LOCALE_FROM_UTF(text)
	#define	FREE_TEXT(text)
#endif

#define CHECKARG(n,t) \
  if((_clip_parinfo(cm,n)!=t)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" type",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_ARG,err); \
    goto err; \
    }

#define CHECKARG2(n,t,t2) \
  if((_clip_parinfo(cm,n)!=t) && (_clip_parinfo(cm,n)!=t2)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" or "#t2" type",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_ARG,err); \
    goto err; \
    }

#define CHECKARG3(n,t,t2,t3) \
  if((_clip_parinfo(cm,n)!=t) && (_clip_parinfo(cm,n)!=t2) && (_clip_parinfo(cm,n)!=t3)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" or "#t2" or "#t3" type",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_ARG,err); \
    goto err; \
    }

#define CHECKARG4(n,t,t2,t3,t4) \
  if((_clip_parinfo(cm,n)!=t) && (_clip_parinfo(cm,n)!=t2) && (_clip_parinfo(cm,n)!=t3) && (_clip_parinfo(cm,n)!=t4)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" or "#t2" or "#t3" or "#t4" type",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_ARG,err); \
    goto err; \
    }

#define CHECKOPT(n,t) \
  if((_clip_parinfo(cm,n)!=t)&&(_clip_parinfo(cm,n)!=UNDEF_t)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" type or NIL",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_ARG,err); \
    goto err; \
    }

#define CHECKOPT2(n,t,t2) \
  if((_clip_parinfo(cm,n)!=t)&&(_clip_parinfo(cm,n)!=t2)&&(_clip_parinfo(cm,n)!=UNDEF_t)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" or "#t2" type or NIL",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_ARG,err); \
    goto err; \
    }

#define CHECKOPT3(n,t,t2,t3) \
  if((_clip_parinfo(cm,n)!=t)&&(_clip_parinfo(cm,n)!=t2)&&(_clip_parinfo(cm,n)!=t3)&&(_clip_parinfo(cm,n)!=UNDEF_t)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" or "#t2" or "#t3" type or NIL",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_ARG,err); \
    goto err; \
    }

#define INT_OPTION(cm,n,d)	(_clip_parinfo(cm,n)==UNDEF_t ? d : _clip_parni(cm,n))
#define LONG_OPTION(cm,n,d)	(_clip_parinfo(cm,n)==UNDEF_t ? d : _clip_parnl(cm,n))
#define DBL_OPTION(cm,n,d)	(_clip_parinfo(cm,n)==UNDEF_t ? d : _clip_parnd(cm,n))
#define CHAR_OPTION(cm,n,d)	(_clip_parinfo(cm,n)==UNDEF_t ? d : _clip_parc(cm,n))
#define BOOL_OPTION(cm,n,d)	(_clip_parinfo(cm,n)==UNDEF_t ? d : _clip_parl(cm,n))

#define CWIDGET_ARG(cm,n)	(_fetch_cwidget(cm,_clip_spar(cm,n)))
#define COBJECT_ARG(cm,n)	(_fetch_cobject(cm,_clip_spar(cm,n)))

#define CHECKCWID(cwid,wt) \
  if(!cwid || !cwid->widget) { \
    char err[100]; \
    sprintf(err,"No widget"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_NOWIDGET,err); \
    goto err; \
    } \
  else \
    if (!(wt(cwid->widget))) { \
    char err[100]; \
    sprintf(err,"Widget have a wrong type ("#wt" failed)"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_WIDGETTYPE,err); \
    goto err; \
    }

#define CHECKCOBJ(cobj,wt) \
  if(!cobj || !cobj->object) { \
    char err[100]; \
    sprintf(err,"No object"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_NOOBJECT,err); \
    goto err; \
    } \
  else \
    if (!(wt)) { \
    char err[100]; \
    sprintf(err,"Object have a wrong type ("#wt" failed)"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_OBJECTTYPE,err); \
    goto err; \
    }

#define CHECKCWIDOPT(cwid,wt) \
  if(cwid && !cwid->widget) { \
    char err[100]; \
    sprintf(err,"No widget"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_NOWIDGET,err); \
    goto err; \
    } \
  else \
    if (cwid && !(wt(cwid->widget))) { \
    char err[100]; \
    sprintf(err,"Widget have a wrong type ("#wt" failed)"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_WIDGETTYPE,err); \
    goto err; \
    }

#define CHECKCOBJOPT(cobj,wt) \
  if(cobj && !cobj->object) { \
    char err[100]; \
    sprintf(err,"No object"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_NOOBJECT,err); \
    goto err; \
    } \
  else \
    if (cobj && !(wt)) { \
    char err[100]; \
    sprintf(err,"Object have a wrong type ("#wt" failed)"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",EG_OBJECTTYPE,err); \
    goto err; \
    }

#define PREPARECV(cs,cv) \
	ClipVar cv; int ret; \
	memset(&cv,0,sizeof(ClipVar)); _clip_map(cs->cw->cmachine, &cv);

#define INVOKESIGHANDLER(widget,cs,cv) \
	ret = handle_signals (widget, cs, &cv); \
	_clip_destroy(cs->cw->cmachine, &cv); \
	return ret;

GtkType _gtk_type_object(void);
C_widget * _register_widget(ClipMachine *cm, GtkWidget *wid, ClipVar *cv);
C_object * _register_object(ClipMachine * cm, void * data, long type, ClipVar * cv, coDestructor fDestroy);
C_widget * _get_cwidget(ClipMachine *cm, GtkWidget *wid);
C_object * _get_cobject(ClipMachine *cm, void *wid, long clip_type, coDestructor fDestroy);
C_widget* _fetch_cwidget(ClipMachine* cm, ClipVar *cv);
C_widget* _fetch_cwidgetn(ClipMachine* cm, int h);
C_object* _fetch_cobject(ClipMachine* cm, ClipVar *cv);
C_object* _fetch_cobjectn(ClipMachine* cm, int h);
C_widget* _fetch_cw_arg(ClipMachine* cm);
C_widget* _fetch_cw_opt(ClipMachine* cm);
C_object* _fetch_co_arg(ClipMachine* cm);
C_object* _fetch_co_opt(ClipMachine* cm);
gint handle_signals( GtkWidget *widget, C_signal *cs, ClipVar *cv );
gint handle_events( GtkWidget *widget, GdkEvent *event, C_signal *cs );
gint widget_signal_handler( GtkWidget *widget, C_signal *cs);
void _wtype_table_put(ClipTypeFunc CWType, TypeNameFunc TypeName, TypeFunc WType, TypeFunc SuperType, SignalTable *table);
WTypeTable * _wtype_table_get(GtkType WType);
WTypeTable * _wtype_table_get_by_clip_type(long WClipType);
WTypeTable * _wtype_table_get_first(void);
char * _sig_name_by_id(long id);
// Get colors for GTK+ from a map
void _map_get_colors (ClipMachine *cm, ClipVar *map, double colors[]);
// Put colors from GTK+ to a map
void _map_put_colors (ClipMachine *cm, ClipVar *map, double colors[]);
// Get colors for color selection from a map
void _map_get_sel_colors (ClipMachine *cm, ClipVar *map, double colors[]);
void _map_colors_to_gdk (ClipMachine *cm, ClipVar *map, GdkColor *gdk_color);
void _map_colors_to_gdk_array (ClipMachine *cm, ClipVar *map, GdkColor gdk_color[]);
// Get color and store it to map
void _gdk_color_to_map (ClipMachine *cm, GdkColor gdk_color, ClipVar *col);
// Get array of colors and store it to array of maps
void _gdk_array_to_map_colors (ClipMachine *cm, GdkColor gdk_colors[], ClipVar *a);
void _style_to_map(ClipMachine *cm, GtkStyle *style, ClipVar *m_style);
void _map_to_style(ClipMachine *cm, ClipVar *m_style, GtkStyle *style);
void _list_put_cwidget(ClipMachine * cm, void *pointer, C_widget * cwid);
C_widget * _list_get_cwidget(ClipMachine * cm, void *pointer);
C_widget * _list_get_cwidget_by_data(ClipMachine * cm, void *data);
void _list_put_cobject(ClipMachine * cm, void *pointer, C_object * cobj);
C_object * _list_get_cobject(ClipMachine * cm, void *pointer);
void _list_remove_cwidget(ClipMachine * cm, void *pointer);
void destroy_c_widget(void *item);
void destroy_c_object(void *item);
guint x_inkey( GdkEventKey *k, double *d );
int object_emit_signal(C_widget *cwid, const gchar *signal_name);
int object_emit_event(C_widget *cwid, const gchar *signal_name);
int gdk_object_font_destructor(ClipMachine *cm, C_object *cfont);
int gdk_object_gc_destructor(ClipMachine *cm, C_object *cgc);
int gdk_object_colormap_destructor(ClipMachine *cm, C_object *ccmap);
int gdk_object_window_destructor(ClipMachine *cm, C_object *cwin);
unsigned char * _clip_locale_to_utf8(unsigned char *);
unsigned char * _clip_locale_from_utf8(unsigned char *);

GtkType _gtk_type_accel_label();
GtkType _gtk_type_adjustment();
GtkType _gtk_type_alignment();
GtkType _gtk_type_arrow();
GtkType _gtk_type_aspect_frame();
GtkType _gtk_type_box();
GtkType _gtk_type_button();
GtkType _gtk_type_button_box();
GtkType _gtk_type_calendar();
GtkType _gtk_type_check_button();
GtkType _gtk_type_check_menu_item();
GtkType _gtk_type_clist();
GtkType _gtk_type_color_selection();
GtkType _gtk_type_color_selection_dialog();
GtkType _gtk_type_combo();
GtkType _gtk_type_container();
GtkType _gtk_type_ctree();
GtkType _gtk_type_curve();
GtkType _gtk_type_data();
GtkType _gtk_type_dialog();
GtkType _gtk_type_drawing_area();
GtkType _gtk_type_editable();
GtkType _gtk_type_entry();
GtkType _gtk_type_event_box();
GtkType _gtk_type_file_selection();
GtkType _gtk_type_fixed();
GtkType _gtk_type_font_selection();
GtkType _gtk_type_font_selection_dialog();
GtkType _gtk_type_frame();
GtkType _gtk_type_gamma_curve();
GtkType _gtk_type_handle_box();
GtkType _gtk_type_hbox();
GtkType _gtk_type_hbutton_box();
GtkType _gtk_type_hpaned();
GtkType _gtk_type_hruler();
GtkType _gtk_type_hscale();
GtkType _gtk_type_hscrollbar();
GtkType _gtk_type_hseparator();
GtkType _gtk_type_input_dialog();
GtkType _gtk_type_item();
GtkType _gtk_type_label();
GtkType _gtk_type_layout();
GtkType _gtk_type_list();
GtkType _gtk_type_list_item();
GtkType _gtk_type_menu();
GtkType _gtk_type_menu_bar();
GtkType _gtk_type_menu_item();
GtkType _gtk_type_menu_shell();
GtkType _gtk_type_misc();
GtkType _gtk_type_notebook();
GtkType _gtk_type_object();
GtkType _gtk_type_option_menu();
GtkType _gtk_type_packer();
GtkType _gtk_type_paned();
GtkType _gtk_type_pixmap();
GtkType _gtk_type_progress();
GtkType _gtk_type_progress_bar();
GtkType _gtk_type_radio_button();
GtkType _gtk_type_radio_group();
GtkType _gtk_type_radio_menu_group();
GtkType _gtk_type_radio_menu_item();
GtkType _gtk_type_range();
GtkType _gtk_type_ruler();
GtkType _gtk_type_scale();
GtkType _gtk_type_scrollbar();
GtkType _gtk_type_scrolled_window();
GtkType _gtk_type_separator();
GtkType _gtk_type_spin_button();
GtkType _gtk_type_status_bar();
GtkType _gtk_type_table();
GtkType _gtk_type_tearoff_menu_item();
GtkType _gtk_type_text();
GtkType _gtk_type_tips_query();
GtkType _gtk_type_toggle_button();
GtkType _gtk_type_toolbar();
GtkType _gtk_type_tooltips();
GtkType _gtk_type_tree();
GtkType _gtk_type_tree_item();
GtkType _gtk_type_vbox();
GtkType _gtk_type_vbutton_box();
GtkType _gtk_type_viewport();
GtkType _gtk_type_vpaned();
GtkType _gtk_type_vruler();
GtkType _gtk_type_vscale();
GtkType _gtk_type_vscrollbar();
GtkType _gtk_type_vseparator();
GtkType _gtk_type_widget();
GtkType _gtk_type_window();


#define GTK_ACCEL_GROUP(obj)           ((GtkAccelGroup *)(obj))
#define GTK_IS_ACCEL_GROUP(obj)        (obj && ((C_object*)obj)->type == GTK_TYPE_ACCEL_GROUP)

#ifndef GDK_BITMAP
#define GDK_BITMAP(obj)           ((GdkBitmap *)(obj))
#define GDK_IS_BITMAP(obj)        (obj && ((C_object*)obj)->type == GDK_TYPE_BITMAP)
#endif

#ifndef GDK_PIXMAP
#define GDK_PIXMAP(obj)           ((GdkPixmap *)(obj))
#define GDK_IS_PIXMAP(obj)        (obj && ((C_object*)obj)->type == GDK_TYPE_PIXMAP)
#endif

#ifndef GDK_WINDOW
#define GDK_WINDOW(obj)           ((GdkWindow *)(obj))
#define GDK_IS_WINDOW(obj)        (obj && ((C_object*)obj)->type == GDK_TYPE_WINDOW)
#endif

#ifndef GDK_COLORMAP
#define GDK_COLORMAP(obj)           ((GdkColormap *)(obj))
#define GDK_IS_COLORMAP(obj)        (obj && ((C_object*)obj)->type == GDK_TYPE_COLORMAP)
#endif

#endif
