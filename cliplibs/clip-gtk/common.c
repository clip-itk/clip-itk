/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>
#include <string.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"
#include "clip-gdk.h"

/* This list associates pointer to a widget with pointer to it`s C_widget structure */
static ClipVar _widget_list;
static ClipVar *widget_list = &_widget_list;

#ifdef OS_CYGWIN
	#include <w32api/windows.h>
	static unsigned char * WinCharset;
	static unsigned char * ClipHostCharset;
#endif

/****************************************************************/
CLIP_DLLEXPORT unsigned char *
_clip_locale_to_utf8(unsigned char *text)
{
#ifdef OS_CYGWIN
	unsigned char *buf;
	unsigned char *utf_text;
	int len;

	if (!WinCharset)
	{
		WinCharset = malloc(10);
		snprintf(WinCharset,10,"cp%d",GetACP());
	}
	if (!ClipHostCharset)
		ClipHostCharset = _clip_host_charset();

	if (!WinCharset || !ClipHostCharset || !text)
		return text;

	len = strlen(text);
	buf = (unsigned char *) malloc(len+1); buf[len] = 0;
	_clip_translate_charset(ClipHostCharset,WinCharset,text,buf,len);
	utf_text = g_locale_to_utf8(buf,NULL);
	free(buf);

	return utf_text;
#else
	return text;
#endif
}

CLIP_DLLEXPORT unsigned char *
_clip_locale_from_utf8(unsigned char *text)
{
#ifdef OS_CYGWIN
	unsigned char *buf;
	unsigned char *locale_text;
	int len;

	if (!WinCharset)
	{
		WinCharset = malloc(10);
		snprintf(WinCharset,10,"cp%d",GetACP());
	}
	if (!ClipHostCharset)
		ClipHostCharset = _clip_host_charset();

	if (!WinCharset || !ClipHostCharset || !text)
		return text;

	locale_text = g_locale_from_utf8(text,NULL);
	len = strlen(locale_text);
	buf = (unsigned char *) malloc(len+1); buf[len] = 0;
	_clip_translate_charset(WinCharset,ClipHostCharset,locale_text,buf,len);
	g_free(locale_text);
	return buf;
#else
	return text;
#endif
}


/****************************************************************/
CLIP_DLLEXPORT void
_list_put_cwidget(ClipMachine * cm, void *pointer, C_widget * cwid)
{
	if (widget_list->t.type != MAP_t)
		_clip_map(cm, widget_list);
	if (pointer)
		_clip_mputn(cm, widget_list, (long) pointer, (long) cwid);
}

CLIP_DLLEXPORT void
_list_put_cobject(ClipMachine * cm, void *pointer, C_object * cobj)
{
	if (widget_list->t.type != MAP_t)
		_clip_map(cm, widget_list);
	if (pointer)
		_clip_mputn(cm, widget_list, (long) pointer, (long) cobj);
}

CLIP_DLLEXPORT C_widget *
_list_get_cwidget(ClipMachine * cm, void *pointer)
{
	double d;
	if (pointer && widget_list->t.type == MAP_t)
		if (_clip_mgetn(cm, widget_list, (long) pointer, &d) == 0)
			return (C_widget *) ((long) d);
	return NULL;
}

CLIP_DLLEXPORT C_widget *
_list_get_cwidget_by_data(ClipMachine * cm, void *data)
{
	if (data && widget_list->t.type == MAP_t)
	{
		int i;
		ClipVar * cv;
		for (i=0; i < widget_list->m.count; i++)
		{
			cv = &(widget_list->m.items + i)->v;
			return (C_widget *) ((long) cv->n.d);
		}
	}
	return NULL;
}

CLIP_DLLEXPORT C_object *
_list_get_cobject(ClipMachine * cm, void *pointer)
{
	double d;
	if (pointer && widget_list->t.type == MAP_t)
		if (_clip_mgetn(cm, widget_list, (long) pointer, &d) == 0)
			return (C_object *) ((long) d);
	return NULL;
}

CLIP_DLLEXPORT void
_list_remove_cwidget(ClipMachine * cm, void *pointer)
{
	if (pointer && widget_list->t.type == MAP_t)
		_clip_mdel(cm, widget_list, (long) pointer);
}

/*****************************************************************/

/* This list associates widget type with pointer to table of signals */
static WTypeTable * wtype_table = NULL;

CLIP_DLLEXPORT void
_wtype_table_put(ClipTypeFunc ClipType, TypeNameFunc TypeName, TypeFunc WType, TypeFunc SuperType, SignalTable *s_table)
{
	WTypeTable * wt_item = NULL;
	static WTypeTable * last_wt_item = NULL;

	if (!wtype_table)
	{
		wtype_table = NEW (WTypeTable);
		last_wt_item = wt_item = wtype_table;
	}
	else
	{
		wt_item = last_wt_item;
		wt_item->next = NEW (WTypeTable);
		last_wt_item = wt_item = wt_item->next;
	}
	wt_item->ftype = WType;
	wt_item->ftype_name = TypeName;
	wt_item->fsuper_type = SuperType;
	wt_item->fclip_type = ClipType;
	wt_item->signal_table = s_table;
}

CLIP_DLLEXPORT WTypeTable *
_wtype_table_get(GtkType WType)
{
	WTypeTable * wt_item = NULL;
	if (!wtype_table) return NULL;
	for (wt_item = wtype_table; wt_item; wt_item = wt_item->next)
	{
		if (wt_item->ftype && wt_item->ftype()==WType)
			break;
	}
	return wt_item;
}

CLIP_DLLEXPORT WTypeTable *
_wtype_table_get_by_clip_type(long WClipType)
{
	WTypeTable * wt_item = NULL;
	if (!wtype_table) return NULL;
	for (wt_item = wtype_table; wt_item; wt_item = wt_item->next)
	{
		if (wt_item->fclip_type && wt_item->fclip_type()==WClipType)
			break;
	}
	return wt_item;
}

CLIP_DLLEXPORT WTypeTable *
_wtype_table_get_first()
{
	return wtype_table;
}

/****************************************************************/
CLIP_DLLEXPORT void
destroy_c_widget(void *item)
{
	C_widget *cw = (C_widget *) item;
	C_signal *cs, *csnext;
	if (!cw) return;
	if (cw->destroy)
		cw->destroy(cw->cmachine, cw);
	_clip_destroy(cw->cmachine, &cw->obj);
	for (cs = cw->siglist; cs;)
	{
		csnext = cs->next;
		_clip_destroy(cw->cmachine, &cs->cfunc);
		free(cs);
		cs = csnext;
	}

	if (cw->widget)
		_list_remove_cwidget(cw->cmachine, cw->widget);
	free(cw);
}

CLIP_DLLEXPORT void
destroy_c_object(void *item)
{
	C_object *co = (C_object *) item;
	if (!co) return;
	if (co->destroy)
		co->destroy(co->cmachine, co);
	_clip_destroy(co->cmachine, &co->obj);
	if (co->object)
		_list_remove_cwidget(co->cmachine, co->object);
	free(co);
}

int
clip_GTK_OBJECTDESTROY(ClipMachine * cm)
{
	C_object *co = _fetch_co_arg(cm);
	destroy_c_object(co);
	return 0;
}

/********************************************************/
GtkWidget *
map_get_widget(ClipMachine * cm, ClipVar * map)
{
	double h;
	C_widget *cwid;

	if (!map || map->t.type != MAP_t) goto err;
	if (_clip_mgetn(cm, map, HASH_HANDLE, &h) != 0) goto err;
	cwid = (C_widget *) _clip_fetch_c_item(cm, (int) h, _C_ITEM_TYPE_WIDGET);
	if (cwid == NULL || cwid->widget == NULL) goto err;

	return cwid->widget;
err:
	return NULL;
}

C_widget *
map_get_cwidget(ClipMachine * cm, ClipVar * map)
{
	double h;
	C_widget *cwid;

	if (!map || map->t.type != MAP_t) goto err;
	if (_clip_mgetn(cm, map, HASH_HANDLE, &h) != 0) goto err;
	cwid = (C_widget *) _clip_fetch_c_item(cm, (int) h, _C_ITEM_TYPE_WIDGET);
	if (cwid == NULL) goto err;

	return cwid;
err:
	return NULL;
}

void *
map_get_data(ClipMachine * cm, ClipVar * map)
{
	double h;
	C_widget *cwid;

	if (!map || map->t.type != MAP_t) goto err;
	if (_clip_mgetn(cm, map, HASH_HANDLE, &h) != 0) goto err;
	cwid = (C_widget *) _clip_fetch_c_item(cm, (int) h, _C_ITEM_TYPE_WIDGET);
	if (cwid == NULL || cwid->data == NULL) goto err;

	return cwid->data;
err:
	return NULL;
}

/********************************************************/
CLIP_DLLEXPORT C_widget*
_fetch_cw_arg(ClipMachine* cm)
{
	C_widget* cwid;

	if (_clip_parinfo(cm,1)==NUMERIC_t)
	{
		cwid = (C_widget*)_clip_fetch_c_item(cm,_clip_parni(cm,1),
			_C_ITEM_TYPE_WIDGET);
	}
	else
	{
		if (_clip_parinfo(cm,1)==MAP_t)
		{
			double h;
			_clip_mgetn(cm, _clip_spar(cm,1), HASH_HANDLE, &h);
			cwid = (C_widget *) _clip_fetch_c_item(cm, (int) h,
				_C_ITEM_TYPE_WIDGET);
		}
		else
		{
			_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
				EG_ARG,"Bad widget descriptor");
			return NULL;
		}
	}
	if(!cwid)
	{
		_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
			EG_ARG,"Bad widget descriptor");
		return NULL;
	}
	return cwid;
}

CLIP_DLLEXPORT C_widget*
_fetch_cw_opt(ClipMachine* cm)
{
	C_widget* cwid;

	if (_clip_parinfo(cm,1)==UNDEF_t)
		return NULL;
	if (_clip_parinfo(cm,1)==NUMERIC_t)
	{
		cwid = (C_widget*)_clip_fetch_c_item(cm,_clip_parni(cm,1),
			_C_ITEM_TYPE_WIDGET);
	}
	else
	{
		if (_clip_parinfo(cm,1)==MAP_t)
		{
			double h;
			_clip_mgetn(cm, _clip_spar(cm,1), HASH_HANDLE, &h);
			cwid = (C_widget *) _clip_fetch_c_item(cm, (int) h,
				_C_ITEM_TYPE_WIDGET);
		}
		else
		{
			_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
				EG_ARG,"Bad widget descriptor");
			return NULL;
		}
	}
	if(!cwid)
	{
		_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
			EG_ARG,"Bad widget descriptor");
		return NULL;
	}
	return cwid;
}

CLIP_DLLEXPORT C_object*
_fetch_co_arg(ClipMachine* cm)
{
	C_object* cobj;

	if (_clip_parinfo(cm,1)==NUMERIC_t)
	{
		cobj = (C_object*)_clip_fetch_c_item(cm,_clip_parni(cm,1),
			_C_ITEM_TYPE_WIDGET);
	}
	else
	{
		if (_clip_parinfo(cm,1)==MAP_t)
		{
			double h;
			_clip_mgetn(cm, _clip_spar(cm,1), HASH_HANDLE, &h);
			cobj = (C_object *) _clip_fetch_c_item(cm, (int) h,
				_C_ITEM_TYPE_WIDGET);
		}
		else
		{
			_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
				EG_ARG,"Bad object descriptor");
			return NULL;
		}
	}
	if(!cobj)
	{
		_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
			EG_ARG,"Bad object descriptor");
		return NULL;
	}
	return cobj;
}

CLIP_DLLEXPORT C_object*
_fetch_co_opt(ClipMachine* cm)
{
	if (_clip_parinfo(cm,1)==UNDEF_t)
		return NULL;
	else
		return _fetch_co_arg(cm);
}

CLIP_DLLEXPORT C_widget*
_fetch_cwidget(ClipMachine* cm, ClipVar* cv)
{
	C_widget* cwid;

	if (!cv) return NULL;

	if (cv->t.type == NUMERIC_t)
	{
		cwid = (C_widget*)_clip_fetch_c_item(cm,cv->n.d,
			_C_ITEM_TYPE_WIDGET);
	}
	else
	{
		if (cv->t.type == MAP_t)
		{
			double h;
			_clip_mgetn(cm, cv, HASH_HANDLE, &h);
			cwid = (C_widget *) _clip_fetch_c_item(cm, (int) h,
				_C_ITEM_TYPE_WIDGET);
		}
		else
		{
/*			_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
				EG_ARG,"Bad widget descriptor"); */
			return NULL;
		}
	}
	if(!cwid)
	{
/*		_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
			EG_ARG,"Bad widget descriptor"); */
		return NULL;
	}
	return cwid;
}

CLIP_DLLEXPORT C_widget*
_fetch_cwidgetn(ClipMachine* cm, int h)
{
	C_widget* cwid;

	cwid = (C_widget*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_WIDGET);

	if(!cwid)
	{
/*		_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
			EG_ARG,"Bad widget descriptor"); */
		return NULL;
	}
	return cwid;
}

CLIP_DLLEXPORT C_object*
_fetch_cobject(ClipMachine* cm, ClipVar* cv)
{
	C_object* cobj;

	if (!cv) return NULL;

	if (cv->t.type == NUMERIC_t)
	{
		cobj = (C_object*)_clip_fetch_c_item(cm,cv->n.d,
			_C_ITEM_TYPE_WIDGET);
	}
	else
	{
		if (cv->t.type == MAP_t)
		{
			double h;
			_clip_mgetn(cm, cv, HASH_HANDLE, &h);
			cobj = (C_object *) _clip_fetch_c_item(cm, (int) h,
				_C_ITEM_TYPE_WIDGET);
		}
		else
		{
/*			_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
				EG_ARG,"Bad widget descriptor"); */
			return NULL;
		}
	}
	if(!cobj)
	{
/*		_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
			EG_ARG,"Bad widget descriptor"); */
		return NULL;
	}
	return cobj;
}

CLIP_DLLEXPORT C_object*
_fetch_cobjectn(ClipMachine* cm, int h)
{
	C_object* cobj;

	cobj = (C_object*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_WIDGET);

	if(!cobj)
	{
/*		_clip_trap_err(cm,EG_ARG,0,0,"CLIP_GTK_SYSTEM",
			EG_ARG,"Bad widget descriptor"); */
		return NULL;
	}
	return cobj;
}

void object_destructor (C_widget *cw)
{
	if (cw) destroy_c_widget(cw);
}

CLIP_DLLEXPORT C_widget *
_register_widget(ClipMachine * cm, GtkWidget * wid, ClipVar * cv)
{
	int handle = -1;
	C_widget * cwid = (C_widget*)calloc(1,sizeof(C_widget));
	WTypeTable *wt_item;
	long clip_wtype = GTK_WIDGET_UNKNOWN;
	cwid->widget = wid;
	cwid->objtype = GTK_OBJ_WIDGET;
	cwid->cmachine = cm;

	cwid->type = wid ? GTK_WIDGET_TYPE(wid) : GTK_TYPE_INVALID;
	wt_item = _wtype_table_get(cwid->type);
	if (wt_item && wt_item->fclip_type) clip_wtype = wt_item->fclip_type();
	if (wt_item && wt_item->ftype_name) cwid->type_name = wt_item->ftype_name();

	cwid->sigenabled = TRUE;
	cwid->usersigenabled = TRUE;
	cwid->evntenabled = TRUE;
	cwid->destroy = NULL;

	if (cv && cv->t.type == MAP_t)
		cwid->obj = *cv;
	else
		_clip_map(cm, &cwid->obj);
	/* Saving widget info into CLIP state machine
	 * and it`s handle to a map HANDLE property */
	handle = _clip_store_c_item(cm, cwid, _C_ITEM_TYPE_WIDGET, NULL);
	cwid->handle = handle;
	_clip_mputn(cm, &cwid->obj, HASH_HANDLE, handle);
	_clip_mputn(cm, &cwid->obj, HASH_TYPE, clip_wtype);
	/* Store C_widget pointer in list of widgets */
	_list_put_cwidget(cm, wid, cwid);
	if (wid && GTK_IS_OBJECT(wid))
		gtk_object_set_data_full(GTK_OBJECT(wid),"destructor",cwid,
			(GtkDestroyNotify)object_destructor);
	return cwid;
}

CLIP_DLLEXPORT C_object *
_register_object(ClipMachine * cm, void * data, long clip_type, ClipVar * cv, coDestructor fDestroy)
{
	int handle = -1;
	C_object * cobj = (C_object*)calloc(1,sizeof(C_widget));
	WTypeTable *wt_item;
	long clip_wtype = GTK_WIDGET_UNKNOWN;

	cobj->object = data;
	cobj->objtype = GTK_OBJ_OBJECT;
	cobj->cmachine = cm;
	cobj->type = clip_type;
	cobj->destroy = fDestroy;

	if (cv && cv->t.type == MAP_t)
		cobj->obj = *cv;
	else
		_clip_map(cm, &cobj->obj);
	/* Saving widget info into CLIP state machine
	 * and it`s handle to a map HANDLE property */
	handle = _clip_store_c_item(cm, cobj, _C_ITEM_TYPE_WIDGET, NULL);
	cobj->handle = handle;
	_clip_mputn(cm, &cobj->obj, HASH_HANDLE, handle);
	wt_item = _wtype_table_get(cobj->type);
	if (wt_item && wt_item->fclip_type) clip_wtype = wt_item->fclip_type();
	if (wt_item && wt_item->ftype_name) cobj->type_name = wt_item->ftype_name();
	_clip_mputn(cm, &cobj->obj, HASH_TYPE, clip_type);
	/* Store C_object pointer in list of widgets */
	_list_put_cobject(cm, data, cobj);
	return cobj;
}

/* Try to find registered widget. If fail, register it. */
CLIP_DLLEXPORT C_widget *
_get_cwidget(ClipMachine *cm, GtkWidget *wid)
{
	C_widget *cwid = _list_get_cwidget(cm,wid);
	if (wid && !cwid) cwid = _register_widget(cm,wid,NULL);
	return cwid;
}

/* Try to find registered object. If fail, register it. */
CLIP_DLLEXPORT C_object *
_get_cobject(ClipMachine *cm, void *obj, long clip_type, coDestructor fDestroy)
{
	C_object *cobj = _list_get_cobject(cm,obj);
	if (obj && !cobj) cobj = _register_object(cm,obj,clip_type,NULL,fDestroy);
	return cobj;
}

// Get colors for GTK+ from a map
CLIP_DLLEXPORT void
_map_get_colors (ClipMachine *cm, ClipVar *map, double colors[])
{
	if (map && map->t.type==MAP_t)
	{
		colors[0] = colors[1] = colors[2] = 0;
		colors[3] = 65355;
		_clip_mgetn(cm, map, HASH_RED, &colors[0]);
		_clip_mgetn(cm, map, HASH_GREEN, &colors[1]);
		_clip_mgetn(cm, map, HASH_BLUE, &colors[2]);
		_clip_mgetn(cm, map, HASH_OPACITY, &colors[3]);
	}
}

// Put colors from GTK+ to a map
CLIP_DLLEXPORT void
_map_put_colors (ClipMachine *cm, ClipVar *map, double colors[])
{
	if (map && map->t.type==MAP_t)
	{
		_clip_mputn(cm, map, HASH_RED, colors[0]);
		_clip_mputn(cm, map, HASH_GREEN, colors[1]);
		_clip_mputn(cm, map, HASH_BLUE, colors[2]);
		_clip_mputn(cm, map, HASH_OPACITY, colors[3]);
	}
}

// Get colors for color selection from a map
CLIP_DLLEXPORT void
_map_get_sel_colors (ClipMachine *cm, ClipVar *map, double colors[])
{
	_map_get_colors(cm,map,colors);

	colors[0] /= 65535; colors[1] /= 65535;
	colors[2] /= 65535; colors[3] /= 65535;
}

CLIP_DLLEXPORT void
_map_colors_to_gdk (ClipMachine *cm, ClipVar *map, GdkColor *gdk_color)
{
	double red, green, blue, pixel;

	if ( map->t.type == MAP_t )
	{
		_clip_mgetn(cm, map, HASH_RED, &red); gdk_color->red = red;
		_clip_mgetn(cm, map, HASH_GREEN, &green); gdk_color->green = green;
		_clip_mgetn(cm, map, HASH_BLUE, &blue); gdk_color->blue = blue;
		_clip_mgetn(cm, map, HASH_PIXEL, &pixel); gdk_color->pixel = pixel;
	}
}

CLIP_DLLEXPORT void
_map_colors_to_gdk_array (ClipMachine *cm, ClipVar *map, GdkColor gdk_color[])
{
	double colors[4];

	if ( map->t.type == MAP_t )
	{
		_map_get_colors(cm, map, colors);
		gdk_color[0].red = colors[0];
		gdk_color[0].green = colors[1];
		gdk_color[0].blue = colors[2];
	}
	if ( map->t.type == ARRAY_t )
	{
		ClipArrVar *a = (ClipArrVar*)_clip_vptr( map );
		int i;

		for(i=0; i < a->count && i<5; i++ )
		{
			if ( a->items[i].t.type != MAP_t ) continue;
			_map_get_colors(cm, (ClipVar*)&a->items[i].d, colors);
			gdk_color[i].red = colors[0];
			gdk_color[i].green = colors[1];
			gdk_color[i].blue = colors[2];
		}
	}
}

CLIP_DLLEXPORT void
_map_gc_to_gdk_array (ClipMachine *cm, ClipVar *map, GdkGC *gdk_gc[])
{
	if ( map->t.type == MAP_t || map->t.type == NUMERIC_t)
	{
		C_object *cgc = _fetch_cobject(cm,map);
		gdk_gc[0] = cgc ? (GdkGC*)(cgc->object) : NULL;
	}
	if ( map->t.type == ARRAY_t )
	{
		ClipArrVar *a = (ClipArrVar*)_clip_vptr( map );
		int i;
		C_object *cgc;

		for(i=0; i < a->count && i<5; i++ )
		{
			if ( a->items[i].t.type != MAP_t && a->items[i].t.type != NUMERIC_t) continue;
			cgc = _fetch_cobject(cm,&a->items[i]);
			gdk_gc[i] = cgc ? (GdkGC*)(cgc->object) : NULL;
		}
	}
}

CLIP_DLLEXPORT void
_map_gc_to_gdk (ClipMachine *cm, ClipVar *map, GdkGC * * gdk_gc)
{
	if ( map->t.type == MAP_t || map->t.type == NUMERIC_t)
	{
		C_object *cgc = _fetch_cobject(cm,map);
		*gdk_gc = cgc ? (GdkGC*)(cgc->object) : NULL;
	}
}

CLIP_DLLEXPORT void
_gdk_gc_to_map (ClipMachine *cm, GdkGC * * gdk_gc, ClipVar *map)
{
	if ( map->t.type == MAP_t || map->t.type == NUMERIC_t)
	{
		C_object *cgc = _get_cobject(cm,map,GDK_OBJECT_GC,
			(coDestructor)gdk_object_gc_destructor);
		*gdk_gc = cgc ? (GdkGC*)(cgc->object) : NULL;
	}
}

/* Get color and store it to map */
CLIP_DLLEXPORT void
_gdk_color_to_map (ClipMachine *cm, GdkColor gdk_color, ClipVar *col)
{
	_clip_mputn(cm, col, HASH_RED, gdk_color.red);
	_clip_mputn(cm, col, HASH_GREEN, gdk_color.green);
	_clip_mputn(cm, col, HASH_BLUE, gdk_color.blue);
	_clip_mputn(cm, col, HASH_PIXEL, gdk_color.pixel);
}

/* Get array of GCs and store it to array of maps */
CLIP_DLLEXPORT void
_gdk_array_to_map_gcs (ClipMachine *cm, GdkGC *gdk_gcs[], ClipVar *a)
{
	long i=5;
	C_object *cgc = NULL;

	_clip_array(cm, a, 1, &i);
	for (i=0; i<5; i++)
	{
		cgc = _get_cobject(cm,gdk_gcs[i],GDK_OBJECT_GC,
			(coDestructor)gdk_object_gc_destructor);
		if (cgc) _clip_aset(cm,a,&cgc->obj,1,&i);
	}
}

/* Get array of colors and store it to array of maps */
CLIP_DLLEXPORT void
_gdk_array_to_map_colors (ClipMachine *cm, GdkColor gdk_colors[], ClipVar *a)
{
	long i=5;
	ClipVar cv;

	memset(&cv,0,sizeof(cv));
	_clip_array(cm, a, 1, &i);
	for (i=0; i<5; i++)
	{
		_clip_map(cm,&cv);
		_gdk_color_to_map(cm,gdk_colors[i],&cv);
		_clip_aset(cm,a,&cv,1,&i);
	}
	_clip_destroy(cm,&cv);
}

CLIP_DLLEXPORT void
_style_to_map(ClipMachine *cm, GtkStyle *style, ClipVar *m_style)
{
	ClipVar *c = NEW(ClipVar);
	ClipVar *a = NEW(ClipVar);
	C_object *cfont, *cgc;
	if (!style || !m_style || m_style->t.type!=MAP_t) return;
	/* Get colors of widget */

	_gdk_array_to_map_colors(cm, style->fg, a);
	_clip_madd(cm, m_style, HASH_FG_COLOR, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_colors(cm, style->bg, a);
	_clip_madd(cm, m_style, HASH_BG_COLOR, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_colors(cm, style->light, a);
	_clip_madd(cm, m_style, HASH_LIGHT_COLOR, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_colors(cm, style->dark, a);
	_clip_madd(cm, m_style, HASH_DARK_COLOR, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_colors(cm, style->mid, a);
	_clip_madd(cm, m_style, HASH_MID_COLOR, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_colors(cm, style->text, a);
	_clip_madd(cm, m_style, HASH_TEXT_COLOR, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_colors(cm, style->base, a);
	_clip_madd(cm, m_style, HASH_BASE_COLOR, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_gcs(cm, style->fg_gc, a);
	_clip_madd(cm, m_style, HASH_FG_GC, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_gcs(cm, style->bg_gc, a);
	_clip_madd(cm, m_style, HASH_BG_GC, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_gcs(cm, style->light_gc, a);
	_clip_madd(cm, m_style, HASH_LIGHT_GC, a);
	_clip_destroy(cm,a);


	_clip_map(cm, c); _gdk_color_to_map(cm, style->black, c);
	_clip_madd(cm, m_style, HASH_BLACK_COLOR, c);
	_clip_map(cm, c); _gdk_color_to_map(cm, style->white, c);
	_clip_madd(cm, m_style, HASH_WHITE_COLOR, c);


	_gdk_array_to_map_gcs(cm, style->dark_gc, a);
	_clip_madd(cm, m_style, HASH_DARK_GC, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_gcs(cm, style->mid_gc, a);
	_clip_madd(cm, m_style, HASH_MID_GC, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_gcs(cm, style->text_gc, a);
	_clip_madd(cm, m_style, HASH_TEXT_GC, a);
	_clip_destroy(cm,a);

	_gdk_array_to_map_gcs(cm, style->base_gc, a);
	_clip_madd(cm, m_style, HASH_BASE_GC, a);
	_clip_destroy(cm,a);

	cgc = _get_cobject(cm,style->black_gc,GDK_OBJECT_GC,
		(coDestructor)gdk_object_gc_destructor);
	if (cgc) _clip_madd(cm, m_style, HASH_BLACK_GC, &cgc->obj);
	cgc = _get_cobject(cm,style->white_gc,GDK_OBJECT_GC,
		(coDestructor)gdk_object_gc_destructor);
	if (cgc) _clip_madd(cm, m_style, HASH_WHITE_GC, &cgc->obj);

	if (style->font)
	{
		cfont = _list_get_cobject(cm,style->font);
		if (!cfont) cfont = _register_object(cm,style->font,GDK_OBJECT_FONT,
			NULL,(coDestructor)gdk_object_font_destructor);
		if (cfont)
		{
			//gdk_font_ref(style->font);
			//cfont->ref_count++;
			_clip_madd(cm,m_style,HASH_FONT,&cfont->obj);
		}
	}
	if (style->colormap)
	{
		C_object *ccmap = _list_get_cobject(cm,style->colormap);
		if (!ccmap) ccmap = _register_object(cm,style->colormap,GDK_OBJECT_COLORMAP,
			NULL,(coDestructor)gdk_object_colormap_destructor);
		if (ccmap)
		{
			//gdk_colormap_ref(style->colormap);
			//ccmap->ref_count++;
			_clip_madd(cm,m_style,HASH_COLORMAP,&ccmap->obj);
		}
	}

	_clip_destroy(cm,c);
	free(c); free(a);

}

CLIP_DLLEXPORT void
_map_to_style(ClipMachine *cm, ClipVar *m_style, GtkStyle *style)
{
	ClipVar *c;
	GdkFont * font = NULL;
	C_object *cfont, *ccmap;

	if ( (c = _clip_mget( cm, m_style, HASH_BG_GC )) != NULL )
		_map_gc_to_gdk_array(cm, c, style->bg_gc);
	/* Colors */
	if ( (c = _clip_mget( cm, m_style, HASH_FG_COLOR )) != NULL )
		_map_colors_to_gdk_array(cm, c, style->fg);
	if ( (c = _clip_mget( cm, m_style, HASH_BG_COLOR )) != NULL )
		_map_colors_to_gdk_array(cm, c, style->bg);
	if ( (c = _clip_mget( cm, m_style, HASH_LIGHT_COLOR )) != NULL )
		_map_colors_to_gdk_array(cm, c, style->light);
	if ( (c = _clip_mget( cm, m_style, HASH_DARK_COLOR )) != NULL )
		_map_colors_to_gdk_array(cm, c, style->dark);
	if ( (c = _clip_mget( cm, m_style, HASH_MID_COLOR )) != NULL )
		_map_colors_to_gdk_array(cm, c, style->mid);
	if ( (c = _clip_mget( cm, m_style, HASH_TEXT_COLOR )) != NULL )
		_map_colors_to_gdk_array(cm, c, style->text);
	if ( (c = _clip_mget( cm, m_style, HASH_BASE_COLOR )) != NULL )
		_map_colors_to_gdk_array(cm, c, style->base);
	if ( (c = _clip_mget( cm, m_style, HASH_BLACK_COLOR )) != NULL )
		_map_colors_to_gdk(cm, c, &style->black);
	if ( (c = _clip_mget( cm, m_style, HASH_WHITE_COLOR )) != NULL )
		_map_colors_to_gdk(cm, c, &style->white);

	/* Graphics contexts */
	if ( (c = _clip_mget( cm, m_style, HASH_FG_GC )) != NULL )
		_map_gc_to_gdk_array(cm, c, style->fg_gc);
	if ( (c = _clip_mget( cm, m_style, HASH_BG_GC )) != NULL )
		_map_gc_to_gdk_array(cm, c, style->bg_gc);
	if ( (c = _clip_mget( cm, m_style, HASH_LIGHT_GC )) != NULL )
		_map_gc_to_gdk_array(cm, c, style->light_gc);
	if ( (c = _clip_mget( cm, m_style, HASH_DARK_GC )) != NULL )
		_map_gc_to_gdk_array(cm, c, style->dark_gc);
	if ( (c = _clip_mget( cm, m_style, HASH_MID_GC )) != NULL )
		_map_gc_to_gdk_array(cm, c, style->mid_gc);
	if ( (c = _clip_mget( cm, m_style, HASH_TEXT_GC )) != NULL )
		_map_gc_to_gdk_array(cm, c, style->text_gc);
	if ( (c = _clip_mget( cm, m_style, HASH_BASE_GC )) != NULL )
		_map_gc_to_gdk_array(cm, c, style->base_gc);
	if ( (c = _clip_mget( cm, m_style, HASH_BLACK_GC )) != NULL )
		_map_gc_to_gdk(cm, c, &style->black_gc);
	if ( (c = _clip_mget( cm, m_style, HASH_WHITE_GC )) != NULL )
		_map_gc_to_gdk(cm, c, &style->white_gc);

/* Set font of widget */
	switch ( _clip_mtype(cm,m_style,HASH_FONT) )
	{
		case CHARACTER_t:
			c = _clip_mget(cm,m_style,HASH_FONT);
			font = gdk_font_load(c->s.str.buf);
			break;
		case MAP_t:
		case NUMERIC_t:
			cfont = _fetch_cobject(cm,_clip_mget(cm,m_style,HASH_FONT));
			if (cfont)
			{
				font = (GdkFont*)cfont->object;
				cfont->ref_count++;
			}
			break;
		default:
	}
	if (font)
	{
		gdk_font_unref (style->font);
		style->font = font;
		gdk_font_ref (style->font);
	}

/* Set colormap of widget */
	c = _clip_mget(cm,m_style,HASH_COLORMAP);
	if (c && (c->t.type == MAP_t || c->t.type == NUMERIC_t))
	{
		ccmap = _fetch_cobject(cm,_clip_mget(cm,m_style,HASH_COLORMAP));
		if (ccmap)
		{
			style->colormap = GDK_COLORMAP(ccmap->object);
		}
	}
}


