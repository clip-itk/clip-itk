/*
    Copyright (C) 2001-2004  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
	      Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>

#include "inkey.ch"
#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/**********************************************************/
/* Signal handlers */
gint handle_destroy_signal (GtkObject *obj, C_signal *cs)
{
	OBJECTPREPARECV(cs,cv);
	OBJECTINVOKESIGHANDLER(cs,cv);
}
/*  { return handle_signals (cs->cw->widget, cs, NULL); }*/



/* Signals table */
static SignalTable object_signals[] =
{
	{"destroy",	GSF( handle_destroy_signal ), NULL, GTK_DESTROY_SIGNAL},
	{"", NULL, NULL, 0}
};

/**********************************************************/

/* Register object in global table */
CLIP_DLLEXPORT GtkType _gtk_type_object() { return GTK_TYPE_OBJECT; }
long _clip_type_object() { return GTK_WIDGET_OBJECT; }
const char * _clip_type_name_object() { return "GTK_WIDGET_OBJECT"; }

int
clip_INIT___OBJECT(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_object, _clip_type_name_object, _gtk_type_object, NULL, object_signals);
	return 0;
}

CLIP_DLLEXPORT guint
x_inkey( GdkEventKey *k, double *d )
{
//	k->state &= GDK_MODIFIER_MASK - GDK_MOD2_MASK;
	switch( k->keyval ) {
	    case GDK_Shift_L:
	    case GDK_Shift_R:
	    case GDK_Control_L:
	    case GDK_Control_R:
	    case GDK_Caps_Lock:
	    case GDK_Shift_Lock:
	    case GDK_Meta_L:
	    case GDK_Meta_R:
	    case GDK_Alt_L:
	    case GDK_Alt_R:
	    case GDK_Super_L:
	    case GDK_Super_R:
		return -1;
	}

	if ( (k->state & GDK_MOD1_MASK) /*||
	     (k->state & GDK_MOD2_MASK) ||
	     (k->state & GDK_MOD3_MASK) ||
	     (k->state & GDK_MOD4_MASK) ||
	     (k->state & GDK_MOD5_MASK) */) {
	    switch( k->keyval ) {
		case GDK_a:
		case GDK_A: *d = K_ALT_A; return 0;
		case GDK_b:
		case GDK_B: *d = K_ALT_B; return 0;
		case GDK_c:
		case GDK_C: *d = K_ALT_C; return 0;
		case GDK_d:
		case GDK_D: *d = K_ALT_D; return 0;
		case GDK_e:
		case GDK_E: *d = K_ALT_E; return 0;
		case GDK_f:
		case GDK_F: *d = K_ALT_F; return 0;
		case GDK_g:
		case GDK_G: *d = K_ALT_G; return 0;
		case GDK_h:
		case GDK_H: *d = K_ALT_H; return 0;
		case GDK_i:
		case GDK_I: *d = K_ALT_I; return 0;
		case GDK_j:
		case GDK_J: *d = K_ALT_J; return 0;
		case GDK_k:
		case GDK_K: *d = K_ALT_K; return 0;
		case GDK_l:
		case GDK_L: *d = K_ALT_L; return 0;
		case GDK_m:
		case GDK_M: *d = K_ALT_M; return 0;
		case GDK_n:
		case GDK_N: *d = K_ALT_N; return 0;
		case GDK_o:
		case GDK_O: *d = K_ALT_O; return 0;
		case GDK_p:
		case GDK_P: *d = K_ALT_P; return 0;
		case GDK_q:
		case GDK_Q: *d = K_ALT_Q; return 0;
		case GDK_r:
		case GDK_R: *d = K_ALT_R; return 0;
		case GDK_s:
		case GDK_S: *d = K_ALT_S; return 0;
		case GDK_t:
		case GDK_T: *d = K_ALT_T; return 0;
		case GDK_u:
		case GDK_U: *d = K_ALT_U; return 0;
		case GDK_v:
		case GDK_V: *d = K_ALT_V; return 0;
		case GDK_w:
		case GDK_W: *d = K_ALT_W; return 0;
		case GDK_x:
		case GDK_X: *d = K_ALT_X; return 0;
		case GDK_y:
		case GDK_Y: *d = K_ALT_Y; return 0;
		case GDK_z:
		case GDK_Z: *d = K_ALT_Z; return 0;
		case GDK_0: *d = K_ALT_0; return 0;
		case GDK_1: *d = K_ALT_1; return 0;
		case GDK_2: *d = K_ALT_2; return 0;
		case GDK_3: *d = K_ALT_3; return 0;
		case GDK_4: *d = K_ALT_4; return 0;
		case GDK_5: *d = K_ALT_5; return 0;
		case GDK_6: *d = K_ALT_6; return 0;
		case GDK_7: *d = K_ALT_7; return 0;
		case GDK_8: *d = K_ALT_8; return 0;
		case GDK_9: *d = K_ALT_9; return 0;
		case GDK_F1:   		*d = K_ALT_F1;		return 0;
		case GDK_F2:   		*d = K_ALT_F2;		return 0;
		case GDK_F3:   		*d = K_ALT_F3;		return 0;
		case GDK_F4:   		*d = K_ALT_F4;		return 0;
		case GDK_F5:   		*d = K_ALT_F5;		return 0;
		case GDK_F6:   		*d = K_ALT_F6;		return 0;
		case GDK_F7:   		*d = K_ALT_F7;		return 0;
		case GDK_F8:   		*d = K_ALT_F8;		return 0;
		case GDK_F9:   		*d = K_ALT_F9;		return 0;
		case GDK_F10:  		*d = K_ALT_F10;		return 0;
		case GDK_F11:  		*d = K_ALT_F11;		return 0;
		case GDK_F12:  		*d = K_ALT_F12;		return 0;
		case GDK_Up:   		*d = K_ALT_UP;		return 0;
		case GDK_Down: 		*d = K_ALT_DOWN;	return 0;
		case GDK_Left: 		*d = K_ALT_LEFT;	return 0;
		case GDK_Right:		*d = K_ALT_RIGHT;	return 0;
		case GDK_Home: 		*d = K_ALT_HOME;	return 0;
		case GDK_End:  		*d = K_ALT_END;		return 0;
		case GDK_Page_Up:	*d = K_ALT_PGUP;	return 0;
		case GDK_Page_Down:	*d = K_ALT_PGDN;	return 0;
		case GDK_Insert:	*d = K_ALT_INS;		return 0;
		case GDK_BackSpace:	*d = K_ALT_BS;		return 0;
		case GDK_Delete:	*d = K_ALT_DEL;		return 0;
		case GDK_Tab:		*d = K_ALT_TAB;		return 0;
		case GDK_Return:	*d = K_ALT_ENTER;	return 0;
		case GDK_Escape:	*d = K_ALT_ESC;		return 0;
		case GDK_equal:		*d = K_ALT_EQUALS;	return 0;
		case GDK_KP_Enter:	*d = KP_ALT_ENTER;	return 0;
		case GDK_KP_Begin:	*d = KP_ALT_5;		return 0;
		case GDK_KP_Divide:	*d = KP_ALT_SLASH;	return 0;
		case GDK_KP_Multiply:	*d = KP_ALT_ASTERISK;	return 0;
		case GDK_KP_Subtract:	*d = KP_ALT_MINUS;	return 0;
		case GDK_KP_Add:	*d = KP_ALT_PLUS;	return 0;
	    }
	}

	if ( (k->state & GDK_MOD2_MASK) )
	    switch( k->keyval ) {
		case GDK_KP_Decimal:
		case GDK_KP_0:
		case GDK_KP_1:
		case GDK_KP_2:
		case GDK_KP_3:
		case GDK_KP_4:
		case GDK_KP_5:
		case GDK_KP_6:
		case GDK_KP_7:
		case GDK_KP_8:
		case GDK_KP_9:	*d = k->keyval - 65408;	return 0;
	    }

	if ( k->state & GDK_CONTROL_MASK ) {
	    switch( k->keyval ) {
		case GDK_a:
		case GDK_A: *d = K_CTRL_A; return 0;
		case GDK_b:
		case GDK_B: *d = K_CTRL_B; return 0;
		case GDK_c:
		case GDK_C: *d = K_CTRL_C; return 0;
		case GDK_d:
		case GDK_D: *d = K_CTRL_D; return 0;
		case GDK_e:
		case GDK_E: *d = K_CTRL_E; return 0;
		case GDK_f:
		case GDK_F: *d = K_CTRL_F; return 0;
		case GDK_g:
		case GDK_G: *d = K_CTRL_G; return 0;
		case GDK_h:
		case GDK_H: *d = K_CTRL_H; return 0;
		case GDK_i:
		case GDK_I: *d = K_CTRL_I; return 0;
		case GDK_j:
		case GDK_J: *d = K_CTRL_J; return 0;
		case GDK_k:
		case GDK_K: *d = K_CTRL_K; return 0;
		case GDK_l:
		case GDK_L: *d = K_CTRL_L; return 0;
		case GDK_m:
		case GDK_M: *d = K_CTRL_M; return 0;
		case GDK_n:
		case GDK_N: *d = K_CTRL_N; return 0;
		case GDK_o:
		case GDK_O: *d = K_CTRL_O; return 0;
		case GDK_p:
		case GDK_P: *d = K_CTRL_P; return 0;
		case GDK_q:
		case GDK_Q: *d = K_CTRL_Q; return 0;
		case GDK_r:
		case GDK_R: *d = K_CTRL_R; return 0;
		case GDK_s:
		case GDK_S: *d = K_CTRL_S; return 0;
		case GDK_t:
		case GDK_T: *d = K_CTRL_T; return 0;
		case GDK_u:
		case GDK_U: *d = K_CTRL_U; return 0;
		case GDK_v:
		case GDK_V: *d = K_CTRL_V; return 0;
		case GDK_w:
		case GDK_W: *d = K_CTRL_W; return 0;
		case GDK_x:
		case GDK_X: *d = K_CTRL_X; return 0;
		case GDK_y:
		case GDK_Y: *d = K_CTRL_Y; return 0;
		case GDK_z:
		case GDK_Z: *d = K_CTRL_Z; return 0;
		case GDK_F1:   		*d = K_CTRL_F1;		return 0;
		case GDK_F2:   		*d = K_CTRL_F2;		return 0;
		case GDK_F3:   		*d = K_CTRL_F3;		return 0;
		case GDK_F4:   		*d = K_CTRL_F4;		return 0;
		case GDK_F5:   		*d = K_CTRL_F5;		return 0;
		case GDK_F6:   		*d = K_CTRL_F6;		return 0;
		case GDK_F7:   		*d = K_CTRL_F7;		return 0;
		case GDK_F8:   		*d = K_CTRL_F8;		return 0;
		case GDK_F9:   		*d = K_CTRL_F9;		return 0;
		case GDK_F10:  		*d = K_CTRL_F10;	return 0;
		case GDK_F11:  		*d = K_CTRL_F11;	return 0;
		case GDK_F12:  		*d = K_CTRL_F12;	return 0;
		case GDK_Up:   		*d = K_CTRL_UP;		return 0;
		case GDK_Down: 		*d = K_CTRL_DOWN;	return 0;
		case GDK_Left: 		*d = K_CTRL_LEFT;	return 0;
		case GDK_Right:		*d = K_CTRL_RIGHT;	return 0;
		case GDK_Home: 		*d = K_CTRL_HOME;	return 0;
		case GDK_End:  		*d = K_CTRL_END;	return 0;
		case GDK_Page_Up:	*d = K_CTRL_PGUP;	return 0;
		case GDK_Page_Down:	*d = K_CTRL_PGDN;	return 0;
		case GDK_Insert:	*d = K_CTRL_INS;	return 0;
		case GDK_BackSpace:	*d = K_CTRL_BS;		return 0;
		case GDK_Delete:	*d = K_CTRL_DEL;	return 0;
		case GDK_Tab:		*d = K_CTRL_TAB;	return 0;
		case GDK_Return:	*d = K_CTRL_ENTER;	return 0;
		case GDK_Print:		*d = K_CTRL_PRTSCR;	return 0;
		case GDK_slash:		*d = K_CTRL_QUESTION;	return 0;
		case GDK_KP_Begin:	*d = KP_CTRL_5;		return 0;
		case GDK_KP_Divide:	*d = KP_CTRL_SLASH;	return 0;
		case GDK_KP_Multiply:	*d = KP_CTRL_ASTERISK;	return 0;
		case GDK_KP_Subtract:	*d = KP_CTRL_MINUS;	return 0;
		case GDK_KP_Add:	*d = KP_CTRL_PLUS;	return 0;
	    }
	}

	if ( k->state & GDK_SHIFT_MASK ) {
	    switch( k->keyval ) {
		case GDK_F1:   	*d = K_SH_F1;	return 0;
		case GDK_F2:   	*d = K_SH_F2;	return 0;
		case GDK_F3:   	*d = K_SH_F3;	return 0;
		case GDK_F4:   	*d = K_SH_F4;	return 0;
		case GDK_F5:   	*d = K_SH_F5;	return 0;
		case GDK_F6:   	*d = K_SH_F6;	return 0;
		case GDK_F7:   	*d = K_SH_F7;	return 0;
		case GDK_F8:   	*d = K_SH_F8;	return 0;
		case GDK_F9:   	*d = K_SH_F9;	return 0;
		case GDK_F10:  	*d = K_SH_F10;	return 0;
		case GDK_F11:  	*d = K_SH_F11;	return 0;
		case GDK_F12:  	*d = K_SH_F12;	return 0;
		case GDK_Tab:  	*d = K_SH_TAB;	return 0;
	    }
	}

	switch( k->keyval )
	{
		case GDK_F1:   		*d = K_F1;		return 0;
		case GDK_F2:   		*d = K_F2;		return 0;
		case GDK_F3:   		*d = K_F3;		return 0;
		case GDK_F4:   		*d = K_F4;		return 0;
		case GDK_F5:   		*d = K_F5;		return 0;
		case GDK_F6:   		*d = K_F6;		return 0;
		case GDK_F7:   		*d = K_F7;		return 0;
		case GDK_F8:   		*d = K_F8;		return 0;
		case GDK_F9:   		*d = K_F9;		return 0;
		case GDK_F10:  		*d = K_F10;		return 0;
		case GDK_F11:  		*d = K_F11;		return 0;
		case GDK_F12:  		*d = K_F12;		return 0;
		case GDK_Up:   		*d = K_UP;		return 0;
		case GDK_Down: 		*d = K_DOWN;		return 0;
		case GDK_Left: 		*d = K_LEFT;		return 0;
		case GDK_Right:		*d = K_RIGHT;		return 0;
		case GDK_Home: 		*d = K_HOME;		return 0;
		case GDK_End:  		*d = K_END;		return 0;
		case GDK_Page_Up:	*d = K_PGUP;		return 0;
		case GDK_Page_Down:	*d = K_PGDN;		return 0;
		case GDK_Insert:	*d = K_INS;		return 0;
		case GDK_BackSpace:	*d = K_BS;		return 0;
		case GDK_Delete:	*d = K_DEL;		return 0;
		case GDK_Tab:		*d = K_TAB;		return 0;
		case GDK_Return:	*d = K_ENTER;		return 0;
		case GDK_Escape:	*d = K_ESC;		return 0;
	}

	*d = k->keyval;
	return 0;
}

/* Common signal handlers. It called from signal handler in C and passes it to CLIP */
CLIP_DLLEXPORT gint
handle_signals( GtkWidget *widget, C_signal *cs, ClipVar *cv )
{
	ClipVar stack[2];
	ClipVar res;
	int ret = TRUE;

	if (!cs) return ret;
	if (!cs->cw) return ret;
	memset( stack, 0, sizeof(stack) );
	_clip_mclone(cs->cw->cmachine, &stack[0], &cs->cw->obj);
	//stack[0] = cs->cw->obj;

	if (!cs->cw->sigenabled) return FALSE;

	if (cv && cv->t.type==MAP_t)
		_clip_mclone(cs->cw->cmachine, &stack[1], cv);
	//	stack[1] = *cv;
	else
		_clip_map(cs->cw->cmachine,&stack[1]);

	_clip_mputn(cs->cw->cmachine,&stack[1], HASH_EVENT, (double)cs->sigid);

	memset( &res, 0, sizeof(ClipVar) );
	if ( _clip_eval( cs->cw->cmachine, &(cs->cfunc), 2, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;
	_clip_destroy(cs->cw->cmachine, &res);

	_clip_destroy(cs->cw->cmachine, &stack[0]);
	_clip_destroy(cs->cw->cmachine, &stack[1]);
	return ret;
}
/* Common object signal handlers. It called from signal handler in C and passes it to CLIP */
CLIP_DLLEXPORT gint
object_handle_signals( C_signal *cs, ClipVar *cv )
{
	ClipVar stack[2];
	ClipVar res;
	int ret = TRUE;

	if (!cs) return ret;
	if (!cs->co) return ret;
	memset( stack, 0, sizeof(stack) );
	_clip_mclone(cs->co->cmachine, &stack[0], &cs->co->obj);
	//stack[0] = cs->cw->obj;

	if (!cs->co->sigenabled) return FALSE;

	if (cv && cv->t.type==MAP_t)
		_clip_mclone(cs->co->cmachine, &stack[1], cv);
		//stack[1] = *cv;
	else
		_clip_map(cs->co->cmachine,&stack[1]);

	_clip_mputn(cs->co->cmachine,&stack[1], HASH_EVENT, (double)cs->sigid);

	memset( &res, 0, sizeof(ClipVar) );
	if ( _clip_eval( cs->co->cmachine, &(cs->cfunc), 2, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(cs->co->cmachine, &res);

	_clip_destroy(cs->co->cmachine, &stack[0]);
	_clip_destroy(cs->co->cmachine, &stack[1]);
	return ret;
}



/* Common event handlers. It called from event handler in C and passes it to CLIP */
CLIP_DLLEXPORT gint
handle_events(GtkWidget *widget, GdkEvent *event, C_signal *cs)
{
	ClipVar stack[2];
	ClipVar *cfunc = NULL;
	int ret = TRUE;
	ClipMachine *cm;
	double keycode;

/*printf("Widget name: %s, event: %d \n",gtk_widget_get_name(widget), event->type);*/

	if (!cs) return ret;
	if (!cs->cw) return ret;
	if (event->type != cs->sigid && cs->sigid != GTK_EVENT) return ret;

	cm = cs->cw->cmachine;
	memset( stack, 0, sizeof(stack) );
	//stack[0] = cs->cw->obj;
	_clip_mclone(cs->cw->cmachine, &stack[0], &cs->cw->obj);

	if (!cs->cw->evntenabled) return FALSE;

	_clip_map(cs->cw->cmachine,&stack[1]);

	//_clip_mputn(cs->cw->cmachine,&stack[1], HASH_EVENT, cs->sigid);
	_clip_mputn(cs->cw->cmachine,&stack[1], HASH_EVENT, event->type);
	cfunc = &cs->cfunc;
	switch( event->type )
	{
		case GDK_CONFIGURE:
//printf("Widget name: %s, event: GDK_CONFIGURE \n",gtk_widget_get_name(widget));
			_clip_mputn(cm, &stack[1], HASH_X, event->configure.x);
			_clip_mputn(cm, &stack[1], HASH_Y, event->configure.y);
			_clip_mputn(cm, &stack[1], HASH_WIDTH, event->configure.width);
			_clip_mputn(cm, &stack[1], HASH_HEIGHT, event->configure.height);
			break;
		case GDK_EXPOSE:
			{
			ClipVar area;
			C_object *cwin;
			memset(&area,0,sizeof(area)); _clip_map(cm,&area);

/*printf("Widget name: %s, event: GDK_EXPOSE \n",gtk_widget_get_name(widget));*/
			_clip_mputn(cm, &area, HASH_X, event->expose.area.x);
			_clip_mputn(cm, &area, HASH_Y, event->expose.area.y);
			_clip_mputn(cm, &area, HASH_WIDTH, event->expose.area.width);
			_clip_mputn(cm, &area, HASH_HEIGHT, event->expose.area.height);

			_clip_madd(cm, &stack[1], HASH_AREA, &area);
			//_clip_mclone(cm, &stack[1], &area);
			_clip_mputn(cm, &stack[1], HASH_COUNT, event->expose.count);

			cwin = _list_get_cobject(cm, event->expose.window);
			if (!cwin) cwin = _register_object(cm, event->expose.window, GDK_TYPE_WINDOW, NULL, NULL);
			if (cwin) _clip_madd(cm, &stack[1], HASH_WINDOW, &cwin->obj);
			_clip_destroy(cm, &area);
			break;
			}
		case GDK_BUTTON_PRESS:
		case GDK_BUTTON_RELEASE:
		case GDK_2BUTTON_PRESS:
		case GDK_3BUTTON_PRESS:
			_clip_mputn(cm, &stack[1], HASH_BUTTON, event->button.button);
			_clip_mputn(cm, &stack[1], HASH_TYPE, event->button.type);
			_clip_mputn(cm, &stack[1], HASH_TIME, event->button.time);
			_clip_mputn(cm, &stack[1], HASH_X, event->button.x);
			_clip_mputn(cm, &stack[1], HASH_Y, event->button.y);
			_clip_mputn(cm, &stack[1], HASH_XROOT, event->button.x_root);
			_clip_mputn(cm, &stack[1], HASH_YROOT, event->button.y_root);
			_clip_mputn(cm, &stack[1], HASH_STATE, event->button.state);
			break;
		case GDK_MOTION_NOTIFY:
			_clip_mputn(cm, &stack[1], HASH_X, event->motion.x);
			_clip_mputn(cm, &stack[1], HASH_Y, event->motion.y);
			_clip_mputn(cm, &stack[1], HASH_XROOT, event->motion.x_root);
			_clip_mputn(cm, &stack[1], HASH_YROOT, event->motion.y_root);
			//last_motion_event = *(GdkEventMotion*)event;
			break;
		case GDK_KEY_PRESS:
		case GDK_KEY_RELEASE:
			if ( x_inkey( (GdkEventKey*)event, &keycode ) )
				cfunc = NULL;
			else
			{
				_clip_mputn(cm, &stack[1], HASH_KEYVAL, keycode);
				_clip_mputn(cm, &stack[1], HASH_STATE, event->key.state);
				_clip_mputn(cm, &stack[1], HASH_LENGTH, event->key.length);
				_clip_mputc(cm, &stack[1], HASH_STRING, event->key.string, event->key.length);
				_clip_mputn(cm, &stack[1], HASH_HARDWARE_KEYCODE, event->key.hardware_keycode);
			}
			break;
		default:
			break;
	}
	if ( cfunc )
	{
		ClipVar res;
		memset( &res, 0, sizeof(ClipVar) );
		if ( _clip_eval( cs->cw->cmachine, cfunc, 2, stack, &res ) == 0 )
			ret = res.t.type == LOGICAL_t ? res.l.val : ret;
		_clip_destroy(cs->cw->cmachine, &res);
	}
	_clip_destroy(cm, &stack[0]);
	_clip_destroy(cm, &stack[1]);
	//return TRUE;
	return ret;
}

/* Find SignalTable entry by signal string name */
static SignalTable *
//_sig_table_by_name(C_widget *cwid, const gchar *signame)
_sig_table_by_name(GtkType wtype, const gchar *signame)
{
	WTypeTable    *wt_item = NULL;
	SignalTable *sig_table = NULL;
	ExtraSignalTable *extra_sig_table = NULL;
	TypeFunc tfun = NULL;
	//GtkType wtype;

	//if (!cwid) return NULL;

	//wtype = cwid->type;
	do
	{
		/* Get WTypeTable entry corresponding to type of this widget */
		wt_item = _wtype_table_get(wtype);
		sig_table = wt_item ? wt_item->signal_table : NULL;
		/* Search the signal name in SignalTable */
		for (; sig_table && sig_table->sigfunction; sig_table++)
		{
			if (strcmp(sig_table->signame,signame)==0)
				return sig_table;
		}
		extra_sig_table = wt_item ? wt_item->extra_signal_table : NULL;
		/* Search the signal name in ExtraSignalTable */
		for (; extra_sig_table && extra_sig_table->sigfunction; extra_sig_table = extra_sig_table->next)
		{
			if (strcmp(extra_sig_table->signame,signame)==0)
				return (SignalTable*)extra_sig_table;
		}
		/* if not found, get WTypeTable entry for parent type and continue searching */
		if (wt_item) tfun = wt_item->fsuper_type;
		if (tfun) wtype = tfun();
	}
	while (tfun);
	return NULL;
}

/* Return TRUE if given signal is in ExtraSignalTable */
static gboolean
_extra_signal_lookup(const gchar *signame, GtkType wtype)
{
	WTypeTable    *wt_item = NULL;
	ExtraSignalTable *extra_sig_table = NULL;
	TypeFunc tfun = NULL;

	do
	{
		/* Get WTypeTable entry corresponding to type of this widget */
		wt_item = _wtype_table_get(wtype);
		extra_sig_table = wt_item ? wt_item->extra_signal_table : NULL;
		/* Search the signal name in ExtraSignalTable */
		for (; extra_sig_table && extra_sig_table->sigfunction; extra_sig_table = extra_sig_table->next)
		{
			if (strcmp(extra_sig_table->signame,signame)==0)
				return TRUE;
		}
		/* if not found, get WTypeTable entry for parent type and continue searching */
		if (wt_item) tfun = wt_item->fsuper_type;
		if (tfun) wtype = tfun();
	}
	while (tfun);
	return FALSE;
}

/* Find SignalTable entry by signal integer identificator */
static SignalTable *
//_sig_table_by_id(C_widget *cwid, long id)
_sig_table_by_id(GtkType wtype, long id)
{
	WTypeTable    *wt_item = NULL;
	SignalTable *sig_table = NULL;
	ExtraSignalTable *extra_sig_table = NULL;
	TypeFunc tfun = NULL;
	//GtkType wtype;

	//if (!cwid) return NULL;

	//wtype = cwid->type;
	do
	{
		/* Get WTypeTable entry corresponding to type of this widget */
		wt_item = _wtype_table_get(wtype);
		sig_table = wt_item ? wt_item->signal_table : NULL;
		/* Search the signal identificator in SignalTable */
		for (; sig_table && sig_table->sigfunction; sig_table++)
		{
			if (sig_table->sigid == id)
				return sig_table;
		}
		extra_sig_table = wt_item ? wt_item->extra_signal_table : NULL;
		/* Search the signal name in ExtraSignalTable */
		for (; extra_sig_table && extra_sig_table->sigfunction; extra_sig_table = extra_sig_table->next)
		{
			if (extra_sig_table->sigid == id)
				return (SignalTable*)extra_sig_table;
		}
		/* if not found, get WTypeTable entry for parent type and continue searching */
		if (wt_item) tfun = wt_item->fsuper_type;
		if (tfun) wtype = tfun();
	}
	while (tfun);
	return NULL;
}

/* Find signal name by signal integer identificator (search in all entries)*/
CLIP_DLLEXPORT char *
_sig_name_by_id(long id)
{
	WTypeTable    *wt_item = NULL;
	SignalTable *sig_table = NULL;
	ExtraSignalTable *extra_sig_table = NULL;

	for (wt_item = _wtype_table_get_first(); wt_item; wt_item = wt_item->next)
	{
		for (sig_table = wt_item->signal_table; sig_table && sig_table->sigfunction; sig_table++)
		{
			if (sig_table->sigid == id)
				return sig_table->signame;
		}
		for (extra_sig_table = wt_item->extra_signal_table; extra_sig_table && extra_sig_table->sigfunction; extra_sig_table = extra_sig_table->next)
		{
			if (extra_sig_table->sigid == id)
				return extra_sig_table->signame;
		}
	}
	return NULL;
}

static int
_signal_connect(ClipMachine *cm, gboolean after)
{
	C_widget *cwid       = _fetch_cw_arg(cm);
	SignalTable *sig_table = NULL;
	int ret=-1;
	CHECKCWID(cwid,GTK_IS_OBJECT);
	CHECKARG2(2,CHARACTER_t,NUMERIC_t);
	CHECKARG2(3,PCODE_t,CCODE_t);


	if (_clip_parinfo(cm,2) == CHARACTER_t)
	{
		//sig_table = _sig_table_by_name(cwid, _clip_parc(cm,2));
		sig_table = _sig_table_by_name(cwid->type, _clip_parc(cm,2));
	}
	else
		sig_table = _sig_table_by_id(cwid->type, _clip_parni(cm,2));
		//sig_table = _sig_table_by_id(cwid, _clip_parni(cm,2));

	if (sig_table && sig_table->sigfunction)
	{
		GtkSignalFunc sfunc = sig_table->sigfunction;
		gchar *signame = sig_table->signame;
		long sid = sig_table->sigid;
		//int sigfound = gtk_signal_lookup(signame, GTK_WIDGET_TYPE(cwid->widget));
		int sigfound = g_signal_lookup(signame, GTK_WIDGET_TYPE(cwid->widget));
		int extra_sigfound = _extra_signal_lookup(signame, GTK_WIDGET_TYPE(cwid->widget));
		C_signal *cs;

		if (sigfound || extra_sigfound || sid < 1000) /* sid<1000 - event */
		{
			if (!cwid->siglist)
			{
				cwid->siglist = NEW(C_signal);
				cs = cwid->siglist;
			}
			else
			{
				for (cs = cwid->siglist; cs && cs->next; cs = cs->next);
				cs->next = NEW(C_signal);
				cs = cs->next;
			}
			cs->cw = cwid;
			cs->signame = sig_table->signame;
			cs->sigid = sig_table->sigid;
			_clip_mclone(cm, &cs->cfunc, _clip_spar(cm,3));
		}

		if ( (sid == GTK_BUTTON_PRESS ||
			sid == GTK_2BUTTON_PRESS || sid == GTK_3BUTTON_PRESS))
		{
			//cwid->event_connected = TRUE;
			if (after)
				ret = g_signal_connect_after(GTK_OBJECT(cwid->widget),
					"button-press-event",GSF(sfunc),cs);
				//ret = gtk_signal_connect_after(GTK_OBJECT(cwid->widget),
				//	"button-press-event",GSF(sfunc),cs);
			else
				ret = g_signal_connect(GTK_OBJECT(cwid->widget),
					"button-press-event",GSF(sfunc),cs);
				//ret = gtk_signal_connect(GTK_OBJECT(cwid->widget),
				//	"button-press-event",GSF(sfunc),cs);
		}
		if (sigfound && sid != GTK_BUTTON_PRESS)
		{
			if (after)
			{
				ret = g_signal_connect_after(GTK_OBJECT(cwid->widget),
					signame,GSF(sfunc),cs);
				//ret = gtk_signal_connect_after(GTK_OBJECT(cwid->widget),
				//	signame,GSF(sfunc),cs);
			}
			else
			{
				ret = g_signal_connect(GTK_OBJECT(cwid->widget),
					signame,GSF(sfunc),cs);
				//ret = gtk_signal_connect(GTK_OBJECT(cwid->widget),
				//	signame,GSF(sfunc),cs);
			}
		}

	}

	_clip_retni(cm,ret);
	return 0;
err:
	_clip_retni(cm,ret);
	return 1;
}


static int
_object_signal_connect(ClipMachine *cm, gboolean after)
{
	C_object *cobj       = _fetch_co_arg(cm);
	SignalTable *sig_table = NULL;
	int ret=-1;
	CHECKCOBJ(cobj,GTK_IS_OBJECT(cobj->object));
	CHECKARG2(2,CHARACTER_t,NUMERIC_t);
	CHECKARG2(3,PCODE_t,CCODE_t);


	if (_clip_parinfo(cm,2) == CHARACTER_t)
	{
		sig_table = _sig_table_by_name(cobj->type, _clip_parc(cm,2));
	}
	else
		sig_table = _sig_table_by_id(cobj->type, _clip_parni(cm,2));

	if (sig_table && sig_table->sigfunction)
	{
		GtkSignalFunc sfunc = sig_table->sigfunction;
		gchar *signame = sig_table->signame;
		long sid = sig_table->sigid;
		int sigfound = g_signal_lookup(signame, GTK_OBJECT_TYPE(cobj->object));
		int extra_sigfound = _extra_signal_lookup(signame, GTK_OBJECT_TYPE(cobj->object));
		C_signal *cs;

		if (sigfound || extra_sigfound || sid < 1000) /* sid<1000 - event */
		{
			if (!cobj->siglist)
			{
				cobj->siglist = NEW(C_signal);
				cs = cobj->siglist;
			}
			else
			{
				for (cs = cobj->siglist; cs && cs->next; cs = cs->next);
				cs->next = NEW(C_signal);
				cs = cs->next;
			}
			cs->co = cobj;
			cs->signame = sig_table->signame;
			cs->sigid = sig_table->sigid;
			_clip_mclone(cm, &cs->cfunc, _clip_spar(cm,3));
		}

		if (sigfound)
		{
			if (after)
			{
				ret = g_signal_connect_after(GTK_OBJECT(cobj->object),
					signame,GSF(sfunc),cs);
			}
			else
			{
				ret = g_signal_connect(GTK_OBJECT(cobj->object),
					signame,GSF(sfunc),cs);
			}
		}
	}

	_clip_retni(cm,ret);
	return 0;
err:
	_clip_retni(cm,ret);
	return 1;
}

int
clip_GTK_SIGNALCONNECT(ClipMachine *cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
	C_object *cobj = _fetch_co_arg(cm);

	if (cwid->type != 0)
		return _signal_connect(cm,FALSE);
	else if (cobj->type != 0)
		return _object_signal_connect(cm, FALSE);

	return 1;
}

int
clip_GTK_SIGNALCONNECTAFTER(ClipMachine *cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
	C_object *cobj = _fetch_co_arg(cm);

	if (cwid->type != 0)
		return _signal_connect(cm,TRUE);
	else if (cobj->type != 0)
		return _object_signal_connect(cm, TRUE);

	return 1;
}

int
clip_GTK_SIGNALDISCONNECT(ClipMachine *cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
	int    conn_id = _clip_parni(cm,2);
	CHECKCWID(cwid,GTK_IS_OBJECT);
	CHECKARG(2,NUMERIC_t);
	//gtk_signal_disconnect(GTK_OBJECT(cwid->widget),conn_id);
	g_signal_handler_disconnect(GTK_OBJECT(cwid->widget),conn_id);
	return 0;
err:
	return 1;
}

int
clip_GTK_SIGNALHANDLERBLOCK(ClipMachine *cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
	int    conn_id = _clip_parni(cm,2);
	CHECKCWID(cwid,GTK_IS_OBJECT);
	CHECKARG(2,NUMERIC_t);
	//gtk_signal_handler_block(GTK_OBJECT(cwid->widget),conn_id);
	g_signal_handler_block(GTK_OBJECT(cwid->widget),conn_id);
	return 0;
err:
	return 1;
}

int
clip_GTK_SIGNALHANDLERUNBLOCK(ClipMachine *cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
	int    conn_id = _clip_parni(cm,2);
	CHECKCWID(cwid,GTK_IS_OBJECT);
	CHECKARG(2,NUMERIC_t);
	//gtk_signal_handler_unblock(GTK_OBJECT(cwid->widget),conn_id);
	g_signal_handler_unblock(GTK_OBJECT(cwid->widget),conn_id);
	return 0;
err:
	return 1;
}


static int
extra_signal_emitter (C_widget *cwid, const gchar *signal_name)
{
	C_signal *cs;
	long sigid = _clip_hashstr(signal_name);

	if (cwid && cwid->siglist)
	{
		for (cs = cwid->siglist; cs; cs = cs->next)
		{
			if (cs->sigid == sigid && strcmp(cs->signame, signal_name)==0)
			{
				ClipVar *cv = _clip_spar(cs->cw->cmachine,3);
				if (handle_signals(cs->cw->widget, cs, cv))
					break;
			}
		}
	}
	return 0;
}

int
clip_GTK_SIGNALNEW(ClipMachine *cm)
{
	long   type = _clip_parnl(cm,1);
	char * sig_name = _clip_parc(cm,2);
	WTypeTable *wt_item;

	CHECKARG(1,NUMERIC_t); CHECKARG(2,CHARACTER_t);

	wt_item = _wtype_table_get_by_clip_type(type);
	if (wt_item)
	{
		ExtraSignalTable *s_table;
		if (wt_item->extra_signal_table == NULL)
		{
			wt_item->extra_signal_table = NEW (ExtraSignalTable);
			s_table = wt_item->extra_signal_table;
		}
		else
		{
			for (s_table = wt_item->extra_signal_table; s_table->next; s_table=s_table->next);
			s_table->next = NEW (ExtraSignalTable);
			s_table = s_table->next;
		}
		s_table->signame = sig_name;
		s_table->sigid = _clip_hashstr(sig_name);
//		s_table->sigfunction = extra_signal_handler;
		s_table->emitsigfunction = ESF(extra_signal_emitter);
	}
	return 0;
err:
	return 1;
}

int
clip_GTK_SIGNALEMIT(ClipMachine *cm)
{
	C_widget         *cwid = _fetch_cw_arg(cm);
	SignalTable *sig_table = NULL;
	int ret=0;
	CHECKCWID(cwid,GTK_IS_OBJECT);
	CHECKARG2(2,CHARACTER_t,NUMERIC_t);

	if (_clip_parinfo(cm,2) == CHARACTER_t)
		sig_table = _sig_table_by_name(cwid->type, _clip_parc(cm,2));
	  //	sig_table = _sig_table_by_name(cwid, _clip_parc(cm,2));
	else
		sig_table = _sig_table_by_id(cwid->type, _clip_parni(cm,2));
		//sig_table = _sig_table_by_id(cwid, _clip_parni(cm,2));

	if (sig_table && sig_table->emitsigfunction)
	{
		if (cwid && cwid->widget && GTK_IS_OBJECT(cwid->widget))
			ret = sig_table->emitsigfunction(_list_get_cobject(cm, GTK_OBJECT(cwid->widget)),sig_table->signame);
		//int sigfound = gtk_signal_lookup(signame, GTK_WIDGET_TYPE(cwid->widget));
	}
	_clip_retl(cm,sig_table && sig_table->sigfunction);
	return ret;
err:
	return 1;
}

/* Common object signal emitter */
CLIP_DLLEXPORT int
object_emit_signal(C_object *cobj, const gchar *signal_name)
{
	//gtk_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name,cwid);
	//gtk_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name);
	g_signal_emit_by_name(GTK_OBJECT(cobj->object),signal_name);
	return 0;
}
/* Common object event emitter */
CLIP_DLLEXPORT int
object_emit_event(C_widget *cwid, const gchar *signal_name)
{
	GdkEvent ev;
	C_signal *cs;
	SignalTable *sig_table = NULL;
	ClipVar *cvev = _clip_spar(cwid->cmachine,3);

	if (!cwid) return 0;

	//sig_table = _sig_table_by_name(cwid,signal_name);
	sig_table = _sig_table_by_name(cwid->type,signal_name);
	if (!sig_table) return 0;

	memset(&ev,0,sizeof(GdkEvent));
	memset(&cs,0,sizeof(C_signal));
	ev.type = sig_table->sigid;

	if (cvev && cvev->t.type == MAP_t)
	{
		double d;
		switch (ev.type)
		{
			case GDK_BUTTON_PRESS:
			case GDK_BUTTON_RELEASE:
			case GDK_2BUTTON_PRESS:
			case GDK_3BUTTON_PRESS:
				_clip_mgetn(cwid->cmachine, cvev, HASH_BUTTON,   &d); ev.button.button   = (guint)d;
				_clip_mgetn(cwid->cmachine, cvev, HASH_X,        &d); ev.button.x        = (guint)d;
				_clip_mgetn(cwid->cmachine, cvev, HASH_Y,        &d); ev.button.y        = (guint)d;
				_clip_mgetn(cwid->cmachine, cvev, HASH_XROOT,    &d); ev.button.x_root   = (guint)d;
				_clip_mgetn(cwid->cmachine, cvev, HASH_YROOT,    &d); ev.button.y_root   = (guint)d;
				_clip_mgetn(cwid->cmachine, cvev, HASH_STATE,    &d); ev.button.state    = (guint)d;
				break;
			case GDK_KEY_PRESS:
			case GDK_KEY_RELEASE:
				_clip_mgetn(cwid->cmachine, cvev, HASH_KEYVAL, &d); ev.key.keyval = (guint)d;
				_clip_mgetn(cwid->cmachine, cvev, HASH_STATE,  &d); ev.key.state = (guint)d;
				_clip_mgetc(cwid->cmachine, cvev, HASH_STRING, &ev.key.string, &ev.key.length);
				_clip_mgetn(cwid->cmachine, cvev, HASH_LENGTH, &d); ev.key.length = (guint)d;
				break;
			default:
				break;
		}
	}

	//gtk_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name,&ev,cwid);
	for (cs = cwid->siglist; cs && cs->sigid != sig_table->sigid; cs = cs->next);
	if (cs)
	{
		//gtk_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name,&ev, cs);
		g_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name,&ev, cs);
		/* It is a very strange, but after calling gtk_signal_emit_by_name()
		   cs->cw becomes NULL and we need to restore it */
		cs->cw = cwid;
	}
	else
	{
		C_signal cs;
		memset(&cs,0,sizeof(cs));
		//gtk_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name,&ev, &cs);
		g_signal_emit_by_name(GTK_OBJECT(cwid->widget),signal_name,&ev, &cs);
	}
	return 0;
}

/*
int
clip_GTK_SIGNALEMITSTOP(ClipMachine *cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
	int    conn_id = _clip_parni(cm,2);
	CHECKCWID(cwid,GTK_IS_OBJECT);
	CHECKARG(2,NUMERIC_t);
	gtk_signal_emit_stop(GTK_OBJECT(cwid->widget),conn_id);
	return 0;
err:
	return 1;
}

int
clip_GTK_SIGNALEMITSTOPBYNAME(ClipMachine *cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
	const gchar *name = _clip_parc(cm,2);
	CHECKCWID(cwid,GTK_IS_OBJECT);
	CHECKARG(2,CHARACTER_t);
	gtk_signal_emit_stop_by_name(GTK_OBJECT(cwid->widget),name);
	return 0;
err:
	return 1;
}
*/

int
clip_GTK_GETOBJBYHANDLE(ClipMachine *cm)
{
	long handle = _clip_parnl(cm,1);
	C_widget *cwid;
	C_object *cobj;
	CHECKARG(1,NUMERIC_t);
	cwid = _fetch_cwidgetn(cm,handle);
	if (cwid)
		_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	else
	{
		cobj = _fetch_cobjectn(cm,handle);
		if (cobj)
		{
			_clip_mclone(cm,RETPTR(cm),&cobj->obj);
			return 0;
		}
	}
	return 0;
err:
	return 1;
}

int
clip_GDK_SETSHOWEVENTS(ClipMachine *cm)
{
	gint show_events = BOOL_OPTION(cm, 1, TRUE);

	gdk_set_show_events(show_events);

	return 0;
}


