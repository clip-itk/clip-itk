/*
    Copyright (C) 2001 - 2004  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    	      Elena V. Kornilova <alena@itk.ru>
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
static gint container_handle_signal (GtkContainer *container,GtkWidget *widget, C_signal *cs)
{
	C_widget *cwid;
	PREPARECV(cs,cv);
	cwid = _list_get_cwidget(cs->cw->cmachine,widget);
	if (!cwid) cwid = _register_widget(cs->cw->cmachine,widget,NULL);
	if (cwid) _clip_madd(cs->cw->cmachine, &cv, HASH_WIDGET, &cwid->obj);
	INVOKESIGHANDLER(GTK_WIDGET(container),cs,cv);
}

static SignalTable container_signals[] =
{
	{"add",			GSF( container_handle_signal ), ESF( object_emit_signal ), GTK_ADD_SIGNAL},
	{"remove",		GSF( container_handle_signal ), ESF( object_emit_signal ), GTK_REMOVE_SIGNAL},
	{"check-resize",   	GSF( widget_signal_handler ), ESF( object_emit_signal ), GTK_CHECK_RESIZE_SIGNAL},
	{"focus",		GSF( container_handle_signal ), ESF( object_emit_signal ), GTK_FOCUS_SIGNAL},
	{"set-focus-child",	GSF( container_handle_signal ), ESF( object_emit_signal ), GTK_SET_FOCUS_CHILD_SIGNAL},
	{"", NULL, NULL, 0}
};

/* Register container signals table in global table */
CLIP_DLLEXPORT GtkType _gtk_type_container() { return GTK_TYPE_CONTAINER; }
long _clip_type_container() { return GTK_WIDGET_CONTAINER; }
const char * _clip_type_name_container() { return "GTK_WIDGET_CONTAINER"; }

CLIP_DLLEXPORT GtkType _gtk_type_event_box() { return GTK_TYPE_EVENT_BOX; }
long _clip_type_event_box() { return GTK_WIDGET_EVENT_BOX; }
const char * _clip_type_name_event_box() { return "GTK_WIDGET_EVENT_BOX"; }

int
clip_INIT___CONTAINER(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_container, _clip_type_name_container, _gtk_type_container, _gtk_type_widget, container_signals);
	_wtype_table_put(_clip_type_event_box, _clip_type_name_event_box, _gtk_type_event_box, _gtk_type_bin, NULL);
//	_wtype_table_put(_clip_type_event_box, _clip_type_name_event_box, _gtk_type_event_box, _gtk_type_container, NULL);
	return 0;
}
/**********************************************************/

/**** Event Box constructor ****/
int
clip_GTK_EVENTBOXNEW(ClipMachine * cm)
{
	ClipVar * cv   = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_event_box_new();
	if (!wid) goto err;

	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);

	return 0;
err:
	return 1;
}
/**** ------------------ ****/

int
clip_GTK_CONTAINERADD(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	gtk_container_add(GTK_CONTAINER(ccon->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERREMOVE(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	gtk_container_remove(GTK_CONTAINER(ccon->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERADDWITHPROPERTIES(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
        ClipVar    *cv = _clip_par(cm, 3);
	gchar *pname[20];
        gint       i;

	CHECKCWID(ccon,GTK_IS_CONTAINER);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
        CHECKARG(3, ARRAY_t);

	memset(pname, 0, sizeof(pname));
        for (i=0; i<cv->a.count; i++)
        	pname[i] = cv->a.items[i].s.str.buf;

	gtk_container_add_with_properties(GTK_CONTAINER(ccon->widget), cwid->widget,
		pname[0], pname[1], pname[2], pname[3], pname[4], pname[5],
		pname[6], pname[7], pname[8], pname[9], pname[10], pname[11],
		pname[12], pname[13], pname[14], pname[15], pname[16], pname[17],
		pname[18], pname[19]);
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERGETRESIZEMODE(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	_clip_retni(cm, (int)gtk_container_get_resize_mode(GTK_CONTAINER(ccon->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERSETRESIZEMODE(ClipMachine * cm)
{
	C_widget     *ccon = _fetch_cw_arg(cm);
	GtkResizeMode mode = _clip_parni(cm,2);
	CHECKARG(2,NUMERIC_t);
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	gtk_container_set_resize_mode(GTK_CONTAINER(ccon->widget), mode);
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERCHECKRESIZE(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	gtk_container_check_resize(GTK_CONTAINER(ccon->widget));
	return 0;
err:
	return 1;
}

static void
_container_children_func(GtkWidget *wid, gpointer data)
{
	C_var *c = (C_var*)data;
	C_widget *c_wid = _list_get_cwidget(c->cm, wid);
	if (!c_wid)
		c_wid = _register_widget(c->cm,wid,NULL);
	if (c_wid)
		_clip_aadd(c->cm, c->cv, &c_wid->obj);
}

// Returns a list of container children
int
clip_GTK_CONTAINERCHILDREN (ClipMachine *cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	long n=0;
	ClipVar *a = RETPTR(cm);
	C_var c;

	CHECKCWID(ccon,GTK_IS_CONTAINER);

	_clip_array(cm, a, 1, &n);
	c.cm = cm; c.cv = a;
	gtk_container_foreach(GTK_CONTAINER(ccon->widget),
		(GtkCallback)_container_children_func,&c);
	return 0;
err:
	return 1;
}

static void
_container_for_each_func(GtkWidget *wid, gpointer data)
{
	C_var *c = (C_var*)data;
	C_widget *c_wid = _list_get_cwidget(c->cm, wid);
	ClipVar stack[2];
	ClipVar res;
	if (!c_wid)
		c_wid = _register_widget(c->cm,wid,NULL);
	if (c_wid)
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		_clip_mclone(c->cw->cmachine, &stack[0], &c->cw->obj);
		_clip_mclone(c->cw->cmachine, &stack[1], &c_wid->obj);
		//stack[0] = c->cw->obj;
		//stack[1] = c_wid->obj;
		_clip_eval( c->cm, &(c->cfunc), 2, stack, &res );
		_clip_destroy(c->cm, &res);
		_clip_destroy(c->cm, &stack[0]);
		_clip_destroy(c->cm, &stack[1]);
	}
}

/* Calls the CLIP function for each children */
int
clip_GTK_CONTAINERFOREACH (ClipMachine *cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	ClipVar *cfunc = _clip_spar(cm,2);
	C_var *c;

	CHECKCWID(ccon,GTK_IS_CONTAINER);
	CHECKARG2(2,CCODE_t,PCODE_t);

	c->cm = cm; c->cw = ccon;
	_clip_mclone(cm, &c->cfunc, cfunc);
	gtk_container_foreach(GTK_CONTAINER(ccon->widget),
		(GtkCallback)_container_for_each_func,c);
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERGETCHILDREN (ClipMachine *cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
        GList    *list ;
        ClipVar    *cv = RETPTR(cm);
        long         l ;

	CHECKCWID(ccon,GTK_IS_CONTAINER);

	list = gtk_container_get_children(GTK_CONTAINER(ccon->widget));
	l = g_list_length(list);
        _clip_array(cm, cv, 1, &l);
        memset(cv, 0, sizeof(cv));
        for (l=0; list; list = g_list_next(list), l++)
        {
        	C_widget *cwid;
                GtkWidget *wid;
                wid = (GtkWidget *)list->data;
                if (wid)
                {
                	cwid = _register_widget(cm, wid, NULL);
                        if (cwid) _clip_aset(cm, cv, &cwid->obj, 1, &l);
                }
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERSETREALLOCATEREDRAWS (ClipMachine *cm)
{
	C_widget        *ccon = _fetch_cw_arg(cm);
        gboolean needs_redraw = _clip_parl(cm, 2);

	CHECKCWID(ccon,GTK_IS_CONTAINER);
        CHECKARG(2, LOGICAL_t);

	gtk_container_set_reallocate_redraws(GTK_CONTAINER(ccon->widget), needs_redraw);
	return 0;
err:
	return 1;
}


int
clip_GTK_CONTAINERSETFOCUSCHILD(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	gtk_container_set_focus_child(GTK_CONTAINER(ccon->widget), cwid->widget);
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERGETFOCUSVADJUSTMENT(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid ;
        GtkAdjustment *adj;
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	adj = gtk_container_get_focus_vadjustment(GTK_CONTAINER(ccon->widget));
        if (adj)
        {
        	cwid = _list_get_cwidget(cm, GTK_WIDGET(adj));
                if (!cwid) cwid = _register_widget(cm, GTK_WIDGET(adj), NULL);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERGETFOCUSHADJUSTMENT(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid ;
        GtkAdjustment *adj;
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	adj = gtk_container_get_focus_hadjustment(GTK_CONTAINER(ccon->widget));
        if (adj)
        {
        	cwid = _list_get_cwidget(cm, GTK_WIDGET(adj));
                if (!cwid) cwid = _register_widget(cm, GTK_WIDGET(adj), NULL);
                if (cwid) _clip_mclone(cm, RETPTR(cm), &cwid->obj);
        }
	return 0;
err:
	return 1;
}
int
clip_GTK_CONTAINERSETFOCUSVADJUSTMENT(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_ADJUSTMENT);
	gtk_container_set_focus_vadjustment(GTK_CONTAINER(ccon->widget),
		GTK_ADJUSTMENT(cwid->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERSETFOCUSHADJUSTMENT(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_ADJUSTMENT);
	gtk_container_set_focus_hadjustment(GTK_CONTAINER(ccon->widget),
		GTK_ADJUSTMENT(cwid->widget));
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERRESIZECHILDREN(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	if (!ccon || !GTK_IS_CONTAINER(ccon->widget)) goto err;
	gtk_container_resize_children(GTK_CONTAINER(ccon->widget));
	return 0;
err:
	return 1;
}


int
clip_GTK_CONTAINERCHILDTYPE(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	if (!ccon || !GTK_IS_CONTAINER(ccon->widget)) goto err;
	_clip_retni(cm, (int)gtk_container_child_type(GTK_CONTAINER(ccon->widget)));

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ContainerChildGet(containerObj, childWidget, @sPromName1, @sPropName2,... ) -->
*******************************************************************************/
int
clip_GTK_CONTAINERCHILDGET(ClipMachine * cm)
{
	C_widget   *ccon = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gchar *pname[20] ;
        gint        i, n ;

	if (!ccon || !GTK_IS_CONTAINER(ccon->widget)) goto err;
        CHECKCWID(cwid, GTK_IS_WIDGET);

	gtk_container_child_get(GTK_CONTAINER(ccon->widget), cwid->widget,
		pname[0], pname[1], pname[2], pname[3], pname[4], pname[5],
		pname[6], pname[7], pname[8], pname[9], pname[10], pname[11],
		pname[12], pname[13], pname[14], pname[15], pname[16], pname[17],
		pname[18], pname[19]);

        n = _clip_parinfo(cm, 0);
	for (i=3; i<n; i++)
        	_clip_storc(cm, pname[i-3], i, 0);
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ContainerChildSet(containerObj, childWidget, @sPromName1, @sPropName2,... ) -->
*******************************************************************************/
int
clip_GTK_CONTAINERCHILDSET(ClipMachine * cm)
{
	C_widget   *ccon = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gchar *pname[20] ;
        gint        i, n ;

	if (!ccon || !GTK_IS_CONTAINER(ccon->widget)) goto err;
        CHECKCWID(cwid, GTK_IS_WIDGET);
        n = _clip_parinfo(cm, 0);
	for (i=3; i<n; i++)
        {
        	CHECKOPT2(i, CHARACTER_t, UNDEF_t);
        	if (_clip_parinfo(cm, i) == UNDEF_t)
                	break;
        	pname[i-3] = _clip_parc(cm, i);
        }

	gtk_container_child_set(GTK_CONTAINER(ccon->widget), cwid->widget,
		pname[0], pname[1], pname[2], pname[3], pname[4], pname[5],
		pname[6], pname[7], pname[8], pname[9], pname[10], pname[11],
		pname[12], pname[13], pname[14], pname[15], pname[16], pname[17],
		pname[18], pname[19]);

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ContainerChildGetPrperty(containerObj, childWidget, sPropName, @value ) -->
*******************************************************************************/
int
clip_GTK_CONTAINERCHILDGETPROPERTY(ClipMachine * cm)
{
	C_widget   *ccon = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gchar      *name = _clip_parc(cm, 3);
        GValue       val ;
        GType       type ;


	if (!ccon || !GTK_IS_CONTAINER(ccon->widget)) goto err;
        CHECKCWID(cwid, GTK_IS_WIDGET);
        CHECKARG(3, CHARACTER_t);

	gtk_container_child_get_property(GTK_CONTAINER(ccon->widget), cwid->widget,
        	name, &val);

	type = G_VALUE_TYPE(&val);
        switch (type)
        {
        	case G_TYPE_INT: _clip_storni(cm, g_value_get_int(&val), 3, 0); break;
        	case G_TYPE_STRING: _clip_storc(cm, g_value_get_string(&val), 3, 0); break;
        	case G_TYPE_BOOLEAN: _clip_storl(cm, g_value_get_boolean(&val), 3, 0); break;
        	case G_TYPE_LONG: _clip_storni(cm, g_value_get_long(&val), 3, 0); break;
        	case G_TYPE_DOUBLE: _clip_stornd(cm, g_value_get_double(&val), 3, 0); break;
        }
	return 0;
err:
	return 1;
}
/******************************************************************************
* gtk_ContainerChildSetPrperty(containerObj, childWidget, sPropName, value ) -->
*******************************************************************************/
int
clip_GTK_CONTAINERCHILDSETPROPERTY(ClipMachine * cm)
{
	C_widget   *ccon = _fetch_cw_arg(cm);
        C_widget   *cwid = _fetch_cwidget(cm, _clip_spar(cm, 2));
        gchar      *name = _clip_parc(cm, 3);
        GValue       val ;
        ClipVar      *cv = _clip_par(cm, 4);
        long        type ;


	if (!ccon || !GTK_IS_CONTAINER(ccon->widget)) goto err;
        CHECKCWID(cwid, GTK_IS_WIDGET);
        CHECKARG(3, CHARACTER_t);

	type = cv->t.type;
	switch (type)
        {
        	case NUMERIC_t: g_value_init(&val, G_TYPE_INT); g_value_set_int(&val, cv->n.d); break;
        	case CHARACTER_t: g_value_init(&val, G_TYPE_STRING); g_value_set_string(&val, cv->s.str.buf); break;
        	case LOGICAL_t: g_value_init(&val, G_TYPE_BOOLEAN); g_value_set_boolean(&val, cv->l.val); break;
        }
	gtk_container_child_set_property(GTK_CONTAINER(ccon->widget), cwid->widget,
        	name, &val);

	return 0;
err:
	return 1;
}
int
clip_GTK_CONTAINERFORALL (ClipMachine *cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	ClipVar *cfunc = _clip_spar(cm,2);
	C_var *c;

	CHECKCWID(ccon,GTK_IS_CONTAINER);
	CHECKARG2(2,CCODE_t,PCODE_t);

	c->cm = cm; c->cw = ccon;
	_clip_mclone(cm, &c->cfunc, cfunc);
	gtk_container_forall(GTK_CONTAINER(ccon->widget),
		(GtkCallback)_container_for_each_func,c);
	return 0;
err:
	return 1;
}

/* Sets a width of container's border */
int
clip_GTK_CONTAINERGETBORDERWIDTH(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	_clip_retni(cm, gtk_container_get_border_width(GTK_CONTAINER(ccon->widget)));
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERSETBORDERWIDTH(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	int      width = _clip_parni(cm,2);
	CHECKOPT(2,NUMERIC_t);
	CHECKCWID(ccon,GTK_IS_CONTAINER);
	gtk_container_set_border_width(GTK_CONTAINER(ccon->widget), width);
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERGETFOCUSCHAIN (ClipMachine *cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
        ClipVar    *cv = _clip_par(cm, 2);
        GList    *list ;
        long         l ;
        gboolean   ret ;

	CHECKCWID(ccon,GTK_IS_CONTAINER);

	ret = gtk_container_get_focus_chain(GTK_CONTAINER(ccon->widget), &list);
        list = g_list_first(list);
	l = g_list_length(list);
        _clip_array(cm, cv, 1, &l);
        for (l=0; list; list = g_list_next(list), l++)
        {
        	C_widget *cwid;
                GtkWidget *wid;
                wid = GTK_WIDGET(list->data);
                if (wid)
                {
                	cwid = _list_get_cwidget(cm, wid);
                	if (!cwid) cwid = _register_widget(cm, wid, NULL);
                        if (cwid)  _clip_aset(cm, cv, &cwid->obj, 1, &l);
                }
        }
	g_list_free(list);
        _clip_retl(cm, ret);
	return 0;
err:
	return 1;
}

int
clip_GTK_CONTAINERSETFOCUSCHAIN (ClipMachine *cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
        ClipArrVar *cv = (ClipArrVar *)_clip_vptr(_clip_spar(cm, 2));
        GList    *list = NULL ;
        gint      n, l ;

	CHECKCWID(ccon,GTK_IS_CONTAINER);
        CHECKARG(2, ARRAY_t);

        n = cv->count;
        for (l=0; l<n; l++)
        {
        	C_widget *cwid = _fetch_cwidget(cm, &cv->items[l]);
                CHECKCWID(cwid, GTK_IS_WIDGET);
		list = g_list_append(list, GTK_WIDGET(cwid->widget));
        }
	gtk_container_set_focus_chain(GTK_CONTAINER(ccon->widget), list);
	return 0;
err:
	return 1;
}


int
clip_GTK_CONTAINERUNSETFOCUSCHAIN (ClipMachine *cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);

	CHECKCWID(ccon,GTK_IS_CONTAINER);

	gtk_container_unset_focus_chain(GTK_CONTAINER(ccon->widget));
	return 0;
err:
	return 1;
}

#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
int
clip_GTK_EVENTBOXSETVISIBLE(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	gint visible_window = _clip_parl(cm,2);

	CHECKCWID(ccon,GTK_IS_EVENT_BOX);
        CHECKARG(2, LOGICAL_t);

	gtk_event_box_set_visible_window (GTK_EVENT_BOX(ccon->widget), visible_window);

	return 0;
err:
	return 1;
}
int
clip_GTK_EVENTBOXGETVISIBLE(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);

	CHECKCWID(ccon,GTK_IS_EVENT_BOX);

	_clip_retl(cm, gtk_event_box_get_visible_window (GTK_EVENT_BOX(ccon->widget)));

	return 0;
err:
	return 1;
}
int
clip_GTK_EVENTBOXSETABOVECHILD(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);
	gboolean above_child  = _clip_parl(cm,2);

	CHECKCWID(ccon,GTK_IS_EVENT_BOX);
        CHECKARG(2, LOGICAL_t);

	gtk_event_box_set_above_child (GTK_EVENT_BOX(ccon->widget), above_child);

	return 0;
err:
	return 1;
}
int
clip_GTK_EVENTBOXGETABOVECHILD(ClipMachine * cm)
{
	C_widget *ccon = _fetch_cw_arg(cm);

	CHECKCWID(ccon,GTK_IS_EVENT_BOX);

	_clip_retl(cm, gtk_event_box_get_above_child (GTK_EVENT_BOX(ccon->widget)));

	return 0;
err:
	return 1;
}
#endif


