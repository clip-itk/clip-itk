/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "task.h"
#include "clip-gtkcfg2.h"
#include "clipcfg.h"

#undef MAXPATHLEN
#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

static ClipVar _data_list;
static ClipVar *data_list = &_data_list;

static ClipVar _func_list;
static ClipVar *func_list = &_func_list;


static ClipVar _data_idle_list;
static ClipVar *data_idle_list = &_data_idle_list;

static ClipVar _func_idle_list;
static ClipVar *func_idle_list = &_func_idle_list;

/* Sets the current locale according to the program environment.
 * This is the same as calling the libc function setlocale(LC_ALL, "")
 * but also takes care of the locale specific setup of the windowing
 * system used by GDK.

 * You should call this function before gtk_init to support
 * internationalization of your GTK+ applications. */
int
clip_GTK_SETLOCALE(ClipMachine * cm)
{
	_clip_retc(cm,gtk_set_locale());
	return 0;
}

#ifdef USE_TASKS
static gint
__idle_task_yield(gpointer data)
{
	Task_sleep(10);
	while (gtk_events_pending())
		gtk_main_iteration();
	while (gtk_events_pending())
		gtk_main_iteration();
	return 1;
}
#endif

CLIP_DLLEXPORT int
clip_GTK_INIT(ClipMachine * cm)
{
	gtk_set_locale();
	gtk_init(0, NULL);
#ifdef USE_TASKS
	gtk_idle_add(__idle_task_yield,NULL);
#endif
	_clip_retl(cm, 1);
	return 0;
}

/* This function does the same work as gtk_init with only a single change:
 * It does not terminate the program if the GUI can't be initialized.
 * Instead it returns FALSE on failure.

 * This way the application can fall back to some other means of
 * communication with the user - for example a curses or command line interface.*/
int
clip_GTK_INITCHECK(ClipMachine * cm)
{
	_clip_retl(cm,gtk_init_check(0, NULL));
	return 0;
}

/* Terminate the program and return the given exit code to the caller.
 * This function will shut down the GUI and free all resources allocated for GTK. */
int
clip_GTK_EXIT(ClipMachine * cm)
{
	int err_code = _clip_parni(cm,1);
	gtk_exit(err_code);
	return 0;
}

// Returns a .t. if events pending
int
clip_GTK_EVENTSPENDING(ClipMachine * cm)
{
	_clip_retl(cm, gtk_events_pending());
	return 0;
}

/* Runs the main loop until gtk_main_quit() is called. You can nest
 * calls to gtk_main. In that case gtk_main_quit() will make the
 * innerst invocation of the main loop return. */
int
clip_GTK_MAIN(ClipMachine * cm)
{
	gtk_main();
	return 0;
}

/* Ask for the current nesting level of the main loop.
 * This can be useful when calling gtk_quit_add. */
int
clip_GTK_MAINLEVEL(ClipMachine * cm)
{
	_clip_retni(cm,gtk_main_level());
	return 0;
}

// Do one mainloop iteration
int
clip_GTK_MAINITERATION(ClipMachine * cm)
{
#ifdef USE_TASKS
	Task_yield();
#endif
	_clip_retl(cm, gtk_main_iteration());
	return 0;
}

// Do one mainloop iteration
int
clip_GTK_MAINITERATIONDO(ClipMachine * cm)
{
	uint blocking = _clip_parl(cm, 1);

	if (_clip_parinfo(cm, 1) == UNDEF_t)
		blocking = FALSE;
#ifdef USE_TASKS
	Task_yield();
#endif
	_clip_retl(cm, gtk_main_iteration_do(blocking));
	return 0;
}

// Quit from main loop
int
clip_GTK_QUIT(ClipMachine * cm)
{
	if (gtk_main_level() == 1)
        {
                _list_remove_cobject(cm);
        	_wtype_table_destroy(_wtype_table_get_first());
	}
	gtk_main_quit();
	return 0;
}

/* Makes widget the current grabbed widget. This means that
 * interaction with other widgets in the same application is blocked and
 * mouse as well as keyboard events are delivered to this widget. */
int
clip_GTK_GRABADD(ClipMachine * cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid,GTK_IS_WIDGET);

	gtk_grab_add(cwid->widget);
	return 0;
err:
	return 1;
}

/* Queries the current grab. */
/* Returns : The widget which currently has the grab or NIL if no grab is active. */
int
clip_GTK_GRABGETCURRENT(ClipMachine * cm)
{
	GtkWidget *wid = gtk_grab_get_current();
	if (wid)
	{
		C_widget *cwid = _list_get_cwidget(cm,wid);
		if (!cwid)
			cwid = _register_widget(cm,wid,NULL);
		if (cwid)
			_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	}
	return 0;
}

/* Remove the grab from the given widget. You have to pair
 * calls to gtk_grab_add and gtk_grab_remove. */
int
clip_GTK_GRABREMOVE(ClipMachine * cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);

	CHECKCWID(cwid,GTK_IS_WIDGET);

	gtk_grab_remove(cwid->widget);
	return 0;
err:
	return 1;
}


static void
_destroy__func(void* data)
{
	C_var *c = (C_var*) data;
	if (c)
	{
		_clip_destroy(c->cm,&c->cfunc);
		free(&c->cfunc);
		free(c);
	}
}

static gint
__func(void* data)
{
	ClipVar res;
	C_var *c = (C_var*)data;
	int ret = TRUE;
	memset( &res, 0, sizeof(ClipVar) );
	_clip_eval( c->cm, &c->cfunc, 0, NULL, &res );
	if (res.t.type == LOGICAL_t)
		ret = res.l.val;
	_clip_destroy(c->cm, &res);
	return ret;
}


static gint
__timeout__func(void* data)
{
	ClipVar res;
	C_var *c = (C_var*)data;
	ClipVar stack[1];
	int ret = TRUE;
	memset( &stack, 0, sizeof(stack) );memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cm, &stack[0], c->cv);
	_clip_eval( c->cm, &c->cfunc, 1, stack, &res );
	if (res.t.type == LOGICAL_t)
		ret = res.l.val;
	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &stack[0]);
//	if (!ret)
  //		_destroy__func(c);
	return ret;
}

/* Register a function to be called when the mainloop is started. */
int
clip_GTK_INITADD(ClipMachine * cm)
{
	C_var *c;

	CHECKARG2(1,PCODE_t,CCODE_t);

	c = NEW(C_var);
	c->cm = cm; //c->cfunc = NEW(ClipVar);
	_clip_mclone(cm,&c->cfunc, _clip_spar(cm,1));
	gtk_init_add((GtkFunction)__func,c);
	return 0;
err:
	return 1;
}

/* Trigger destruction of object in case the mainloop at level main_level is quit. */
int
clip_GTK_QUITADDDESTROY(ClipMachine * cm)
{
	guint main_level = INT_OPTION(cm,1,gtk_main_level());
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	C_object *cobj;

	CHECKOPT(1,NUMERIC_t); CHECKARG2(2,MAP_t,NUMERIC_t);

	if (cwid->objtype == GTK_OBJ_WIDGET)
	{
		CHECKCWID(cwid, GTK_IS_OBJECT);
		gtk_quit_add_destroy(main_level, GTK_OBJECT(cwid->widget));
	}
	if (cwid->objtype == GTK_OBJ_OBJECT)
	{
		cobj = (C_object*)cwid;
		CHECKCOBJ(cobj, GTK_IS_OBJECT(cobj->object));
		gtk_quit_add_destroy(main_level, GTK_OBJECT(cobj->object));
	}
	return 0;
err:
	return 1;
}

/* Registers a function to be called when an instance of the mainloop is left. */
int
clip_GTK_QUITADD(ClipMachine * cm)
{
	guint main_level = INT_OPTION(cm,1,gtk_main_level());
	C_var *c;

	CHECKOPT(1,NUMERIC_t); CHECKARG2(2,PCODE_t,CCODE_t);

	c = NEW(C_var);
	c->cm = cm; //c->cfunc = NEW(ClipVar);
	_clip_mclone(cm,&c->cfunc, _clip_spar(cm,2));
	_clip_retni(cm,gtk_quit_add_full(main_level,(GtkFunction)__func,NULL,c,
		_destroy__func));
	return 0;
err:
	return 1;
}

/* Remove a quit handler by it's identifier. */
int
clip_GTK_QUITREMOVE(ClipMachine * cm)
{
	guint quit_handler_id = _clip_parni(cm,1);

	CHECKARG(1,NUMERIC_t);

	gtk_quit_remove(quit_handler_id);
	return 0;
err:
	return 1;
}

void
_list_put_data(ClipMachine * cm, gint id, ClipVar * cdata)
{
	if (data_list->t.type != MAP_t)
		_clip_map(cm, data_list);
	if (id)
		_clip_mputn(cm, data_list, (long) id, (long) cdata);
}

ClipVar *
_list_get_data(ClipMachine * cm, gint id)
{
	double d;
	if (id && data_list->t.type == MAP_t)
		if (_clip_mgetn(cm, data_list, (long) id, &d) == 0)
			return (ClipVar *) ((long) d);
	return NULL;
}
void
_list_remove_data(ClipMachine * cm, gint id)
{
	if (id && data_list->t.type == MAP_t)
		_clip_mdel(cm, data_list, (long) id);
}
void
_list_put_func(ClipMachine * cm, gint id, ClipVar * cfunc)
{
	if (func_list->t.type != MAP_t)
		_clip_map(cm, func_list);
	if (id)
		_clip_mputn(cm, func_list, (long) id, (long) cfunc);
}

ClipVar *
_list_get_func(ClipMachine * cm, gint id)
{
	double d;
	if (id && func_list->t.type == MAP_t)
		if (_clip_mgetn(cm, func_list, (long) id, &d) == 0)
			return (ClipVar *) ((long) d);
	return NULL;
}
void
_list_remove_func(ClipMachine * cm, gint id)
{
	if (id && func_list->t.type == MAP_t)
		_clip_mdel(cm, func_list, (long) id);
}


/* Registers a function to be called periodically.
 * The function will be called repeatedly after interval milliseconds
 * until it returns FALSE at which point the timeout is destroyed and
 * will not be called again. */
/* gtkTimeoutAdd(interval, @func()[, userData]) */
int
clip_GTK_TIMEOUTADD(ClipMachine * cm)
{
	guint32 interval = _clip_parnl(cm,1);
	C_var *c;

	CHECKARG(1,NUMERIC_t); CHECKARG2(2,PCODE_t,CCODE_t);

	c = NEW(C_var);
	c->cm = cm;
	c->cv = NEW(ClipVar);
	_clip_mclone(cm,&c->cfunc, _clip_spar(cm,2));
	if (_clip_parinfo(cm, 0)>2)
		_clip_mclone(cm, c->cv, _clip_spar(cm,3));
	c->id = gtk_timeout_add(interval,(GtkFunction)__timeout__func,c);
	_list_put_data(cm, c->id, c->cv);
	_list_put_func(cm, c->id, &c->cfunc);
	_clip_retni(cm,c->id);
	return 0;
err:
	return 1;
}

/* Removes the given timeout destroying all information about it. */
int
clip_GTK_TIMEOUTREMOVE(ClipMachine * cm)
{
	guint timeout_handler_id = _clip_parni(cm,1);

	CHECKARG(1,NUMERIC_t);

	gtk_timeout_remove(timeout_handler_id);

	_clip_destroy(cm, _list_get_data(cm, timeout_handler_id));
	_clip_destroy(cm, _list_get_func(cm, timeout_handler_id));

	_list_remove_data(cm, timeout_handler_id);
	_list_remove_func(cm, timeout_handler_id);

	return 0;
err:
	return 1;
}


static gint
__idle__func(void* data)
{
	ClipVar res;
	C_var *c = (C_var*)data;
	ClipVar stack[1];
	int ret = TRUE;
	memset( &stack, 0, sizeof(stack) );memset( &res, 0, sizeof(ClipVar) );
	_clip_mclone(c->cm, &stack[0], c->cv);
	_clip_eval( c->cm, &c->cfunc, 1, stack, &res );
	if (res.t.type == LOGICAL_t)
		ret = res.l.val;
	_clip_destroy(c->cm, &res);
	_clip_destroy(c->cm, &stack[0]);
	return ret;
}
void
_list_idle_put_data(ClipMachine * cm, gint id, ClipVar * cdata)
{
	if (data_idle_list->t.type != MAP_t)
		_clip_map(cm, data_idle_list);
	if (id)
		_clip_mputn(cm, data_idle_list, (long) id, (long) cdata);
}

ClipVar *
_list_idle_get_data(ClipMachine * cm, gint id)
{
	double d;
	if (id && data_idle_list->t.type == MAP_t)
		if (_clip_mgetn(cm, data_idle_list, (long) id, &d) == 0)
			return (ClipVar *) ((long) d);
	return NULL;
}
void
_list_idle_remove_data(ClipMachine * cm, gint id)
{
	if (id && data_idle_list->t.type == MAP_t)
		_clip_mdel(cm, data_idle_list, (long) id);
}
void
_list_idle_put_func(ClipMachine * cm, gint id, ClipVar * cfunc)
{
	if (func_idle_list->t.type != MAP_t)
		_clip_map(cm, func_idle_list);
	if (id)
		_clip_mputn(cm, func_idle_list, (long) id, (long) cfunc);
}

ClipVar *
_list_idle_get_func(ClipMachine * cm, gint id)
{
	double d;
	if (id && func_idle_list->t.type == MAP_t)
		if (_clip_mgetn(cm, func_idle_list, (long) id, &d) == 0)
			return (ClipVar *) ((long) d);
	return NULL;
}
void
_list_idle_remove_func(ClipMachine * cm, gint id)
{
	if (id && func_idle_list->t.type == MAP_t)
		_clip_mdel(cm, func_idle_list, (long) id);
}
/* Causes the mainloop to call the given function whenever no events
 * with higher priority are to be processed. The default priority is
 * GTK_PRIORITY_DEFAULT, which is rather low. */
/* gtk_IdleAdd(@func()[, userData ]) --> idleHandle */
int
clip_GTK_IDLEADD(ClipMachine * cm)
{
	C_var *c;
	guint id;

	CHECKARG2(1, PCODE_t,CCODE_t);

	c = NEW(C_var);
	c->cm = cm;
	c->cv = NEW(ClipVar);
	_clip_mclone(cm,&c->cfunc, _clip_spar(cm,1));
	if (_clip_parinfo(cm, 0)>1)
		_clip_mclone(cm, c->cv, _clip_spar(cm,2));
	id = gtk_idle_add((GtkFunction)__idle__func,c);
	_list_idle_put_data(cm, id, c->cv);
	_list_idle_put_func(cm, id, &c->cfunc);
	_clip_retni(cm, id);

	return 0;
err:
	return 1;
}
/* Removes the idle function with the given id. */
int
clip_GTK_IDLEREMOVE(ClipMachine * cm)
{
	guint idle_handler_id = _clip_parni(cm,1);

	CHECKARG(1,NUMERIC_t);

	gtk_idle_remove(idle_handler_id);

	_clip_destroy(cm, _list_idle_get_data(cm, idle_handler_id));
	_clip_destroy(cm, _list_idle_get_func(cm, idle_handler_id));

	_list_idle_remove_data(cm, idle_handler_id);
	_list_idle_remove_func(cm, idle_handler_id);

	return 0;
err:
	return 1;
}
/*
int
clip_GTK_IDLEADD(ClipMachine * cm)
{
	gint priority = INT_OPTION(cm,1,G_PRIORITY_DEFAULT_IDLE);
	C_var *c;

	CHECKOPT(1,NUMERIC_t); CHECKARG2(2,PCODE_t,CCODE_t);

	if (priority > G_PRIORITY_HIGH) priority = G_PRIORITY_HIGH;

	c = NEW(C_var);
	c->cm = cm;
	_clip_mclone(cm,&c->cfunc, _clip_spar(cm,2));
	_clip_retni(cm,gtk_idle_add_full(priority,(GtkFunction)__func,NULL,
		c,_destroy__func));
	return 0;
err:
	return 1;
}
int
clip_GTK_IDLEREMOVE(ClipMachine * cm)
{
	guint idle_handler_id = _clip_parni(cm,1);

	CHECKARG(1,NUMERIC_t);

	gtk_idle_remove(idle_handler_id);
	return 0;
err:
	return 1;
}
*/

