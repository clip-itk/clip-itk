/*
    Copyright (C) 2001 - 2004  ITK
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

/*********************** SIGNALS **************************/

static int
cycle_child_focus_signal_handler(GtkPaned *paned, gboolean arg1, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputl(cs->cw->cmachine, &cv, HASH_ARG1, arg1);
	INVOKESIGHANDLER(GTK_WIDGET(paned), cs,cv);
}

static int
cycle_handle_focus_signal_handler(GtkPaned *paned, gboolean arg1, C_signal *cs)
{
	PREPARECV(cs,cv);
	_clip_mputl(cs->cw->cmachine, &cv, HASH_ARG1, arg1);
	INVOKESIGHANDLER(GTK_WIDGET(paned), cs,cv);
}

static int
move_handle_signal_handler(GtkPaned *paned, GtkScrollType arg1, C_signal *cs)
{
	gint arg=0;
	PREPARECV(cs,cv);
	switch (arg1)
        {
        	case GTK_SCROLL_NONE:
                	arg = CLIP_GTK_SCROLL_NONE; break;
        	case GTK_SCROLL_JUMP:
                	arg = CLIP_GTK_SCROLL_JUMP; break;
        	case GTK_SCROLL_STEP_BACKWARD:
                	arg = CLIP_GTK_SCROLL_STEP_BACKWARD; break;
        	case GTK_SCROLL_STEP_FORWARD:
                	arg = CLIP_GTK_SCROLL_STEP_FORWARD; break;
        	case GTK_SCROLL_PAGE_BACKWARD:
                	arg = CLIP_GTK_SCROLL_PAGE_BACKWARD; break;
        	case GTK_SCROLL_PAGE_FORWARD:
                	arg = CLIP_GTK_SCROLL_PAGE_FORWARD; break;
        	case GTK_SCROLL_STEP_UP:
                	arg = CLIP_GTK_SCROLL_STEP_UP; break;
        	case GTK_SCROLL_STEP_DOWN:
                	arg = CLIP_GTK_SCROLL_STEP_DOWN; break;
        	case GTK_SCROLL_PAGE_UP:
                	arg = CLIP_GTK_SCROLL_PAGE_UP; break;
        	case GTK_SCROLL_PAGE_DOWN:
                	arg = CLIP_GTK_SCROLL_PAGE_DOWN; break;
        	case GTK_SCROLL_STEP_LEFT:
                	arg = CLIP_GTK_SCROLL_STEP_LEFT; break;
        	case GTK_SCROLL_STEP_RIGHT:
                	arg = CLIP_GTK_SCROLL_STEP_RIGHT; break;
        	case GTK_SCROLL_PAGE_LEFT:
                	arg = CLIP_GTK_SCROLL_PAGE_LEFT; break;
        	case GTK_SCROLL_PAGE_RIGHT:
                	arg = CLIP_GTK_SCROLL_PAGE_RIGHT; break;
        	case GTK_SCROLL_START:
                	arg = CLIP_GTK_SCROLL_START; break;
        	case GTK_SCROLL_END:
                	arg = CLIP_GTK_SCROLL_END; break;
        }
	_clip_mputn(cs->cw->cmachine, &cv, HASH_ARG1, arg);
	INVOKESIGHANDLER(GTK_WIDGET(paned), cs,cv);
}
static SignalTable paned_signals[] =
{
	{"accept-position",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_ACCEPT_POSITION_SIGNAL},
	{"cancel-position",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_CANCEL_POSITION_SIGNAL},
	{"cycle-child-focus",	GSF( cycle_child_focus_signal_handler ),	ESF( object_emit_signal ), GTK_CYCLE_CHILD_FOCUS_SIGNAL},
	{"cycle-handle-focus",	GSF( cycle_handle_focus_signal_handler ),	ESF( object_emit_signal ), GTK_CYCLE_HANDLE_FOCUS_SIGNAL},
	{"move-handle",		GSF( move_handle_signal_handler ),	ESF( object_emit_signal ), GTK_MOVE_HANDLE_SIGNAL},
	{"toggle-handle-focus",	GSF( widget_signal_handler ),	ESF( object_emit_signal ), GTK_TOGGLE_HANDLE_FOCUS_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register Paned in global table */
CLIP_DLLEXPORT GtkType _gtk_type_paned() { return GTK_TYPE_PANED; }
CLIP_DLLEXPORT GtkType _gtk_type_hpaned() { return gtk_hpaned_get_type(); }
CLIP_DLLEXPORT GtkType _gtk_type_vpaned() { return gtk_vpaned_get_type(); }

long _clip_type_paned() { return GTK_WIDGET_PANED; }
long _clip_type_hpaned() { return GTK_WIDGET_HPANED; }
long _clip_type_vpaned() { return GTK_WIDGET_VPANED; }

const char * _clip_type_name_paned() { return "GTK_WIDGET_PANED"; }
const char * _clip_type_name_hpaned() { return "GTK_WIDGET_HPANED"; }
const char * _clip_type_name_vpaned() { return "GTK_WIDGET_VPANED"; }

int
clip_INIT___PANED(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_paned,  _clip_type_name_paned,  _gtk_type_paned, _gtk_type_container, paned_signals);
	_wtype_table_put(_clip_type_hpaned, _clip_type_name_hpaned, _gtk_type_hpaned, _gtk_type_paned, paned_signals);
	_wtype_table_put(_clip_type_vpaned, _clip_type_name_vpaned, _gtk_type_vpaned, _gtk_type_paned, paned_signals);
	return 0;
}

int
clip_GTK_HPANEDNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_hpaned_new();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

int
clip_GTK_VPANEDNEW(ClipMachine * cm)
{
	ClipVar * cv     = _clip_spar(cm, 1);
	GtkWidget *wid = NULL;
	C_widget *cwid;
	CHECKOPT(1,MAP_t);

	wid = gtk_vpaned_new();
	if (!wid) goto err;
	cwid = _register_widget(cm, wid, cv);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/* Add a child to the top or left pane with default parameters.
 * This is equivalent to gtk_paned_pack1(paned, FALSE, TRUE); */
int
clip_GTK_PANEDADD1(ClipMachine * cm)
{
	C_widget *cpan = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	gtk_paned_add1(GTK_PANED(cpan->widget), cwid->widget);
	return 0;
err:
	return 1;
}

/* Add a child to the bottom or right pane with default parameters.
 * This is equivalent to gtk_paned_pack1(paned, FALSE, FALSE); */
int
clip_GTK_PANEDADD2(ClipMachine * cm)
{
	C_widget *cpan = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	gtk_paned_add2(GTK_PANED(cpan->widget), cwid->widget);
	return 0;
err:
	return 1;
}

/* Add a child to the top or left pane. */
/* paned : a paned widget
   child : the child to add
  resize : should this child expand when the paned widget is resized.
  shrink : can this child be made smaller than its requsition.  */
int
clip_GTK_PANEDPACK1(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	gboolean resize = _clip_parl(cm,3);
	gboolean shrink = _clip_parl(cm,4);
	CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT(3,LOGICAL_t); CHECKOPT(4,LOGICAL_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) resize = TRUE;
	if (_clip_parinfo(cm,4)==UNDEF_t) shrink = TRUE;
	gtk_paned_pack1(GTK_PANED(cpan->widget), cwid->widget, resize, shrink);
	return 0;
err:
	return 1;
}

/* Add a child to the bottom or right pane. */
int
clip_GTK_PANEDPACK2(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
	C_widget *cwid = _fetch_cwidget(cm,_clip_spar(cm,2));
	gboolean resize = _clip_parl(cm,3);
	gboolean shrink = _clip_parl(cm,4);
	CHECKCWID(cpan,GTK_IS_PANED);
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKOPT(3,LOGICAL_t); CHECKOPT(4,LOGICAL_t);
	if (_clip_parinfo(cm,3)==UNDEF_t) resize = TRUE;
	if (_clip_parinfo(cm,4)==UNDEF_t) shrink = TRUE;
	gtk_paned_pack2(GTK_PANED(cpan->widget), cwid->widget, resize, shrink);
	return 0;
err:
	return 1;
}


/* Set the position of the separator, as if set by the user. If position is
 * negative, the remembered position is forgotten, and the division is
 * recomputed from the the requisitions of the children. */
int
clip_GTK_PANEDSETPOSITION(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
	gint   position = _clip_parni(cm,2);
	CHECKCWID(cpan,GTK_IS_PANED);
	CHECKOPT(2,NUMERIC_t);
	if (_clip_parinfo(cm,2)==UNDEF_t) position = -1;
	gtk_paned_set_position(GTK_PANED(cpan->widget), position);
	return 0;
err:
	return 1;
}
int
clip_GTK_PANEDGETPOSITION(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
	gint   position;
	CHECKCWID(cpan,GTK_IS_PANED);
	position = gtk_paned_get_position(GTK_PANED(cpan->widget));

	_clip_retni(cm, position);
	return 0;
err:
	return 1;
}
/* Get size child1 (top or left)*/
int
clip_GTK_PANEDGETSIZECHILD1(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
	gint    width, height;
	GtkPaned * paned;
	GtkRequisition child_requisition;

	CHECKCWID(cpan,GTK_IS_PANED);
	paned = GTK_PANED(cpan->widget);

	if (paned->child1 && GTK_WIDGET_VISIBLE (paned->child1))
	{
		gtk_widget_size_request (paned->child1, &child_requisition);

		height = child_requisition.height;
		width = child_requisition.width;
	}
	_clip_storni(cm, width, 2, 0);
	_clip_storni(cm, height, 3, 0);
	return 0;
err:
	return 1;
}
/* Get size child2 (bottom or right)*/
int
clip_GTK_PANEDGETSIZECHILD2(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
	gint    width, height;
	GtkPaned * paned;
	GtkRequisition child_requisition;

	CHECKCWID(cpan,GTK_IS_PANED);
	paned = GTK_PANED(cpan->widget);

	if (paned->child2 && GTK_WIDGET_VISIBLE (paned->child2))
	{
		gtk_widget_size_request (paned->child2, &child_requisition);

		height = child_requisition.height;
		width = child_requisition.width;
	}
	_clip_storni(cm, width, 2, 0);
	_clip_storni(cm, height, 3, 0);
	return 0;
err:
	return 1;
}
#if (GTK2_VER_MAJOR >= 2) && (GTK2_VER_MINOR >= 4)
int
clip_GTK_PANEDGETCHILD1(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
        GtkWidget  *wid ;
        C_widget  *cwid ;

	CHECKCWID(cpan,GTK_IS_PANED);

	wid = gtk_paned_get_child1(GTK_PANED(cpan->widget));

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
clip_GTK_PANEDGETCHILD2(ClipMachine * cm)
{
	C_widget  *cpan = _fetch_cw_arg(cm);
        GtkWidget  *wid ;
        C_widget  *cwid ;

	CHECKCWID(cpan,GTK_IS_PANED);

	wid = gtk_paned_get_child2(GTK_PANED(cpan->widget));

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

#endif
