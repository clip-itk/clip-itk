/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <string.h>

#include "clip-gtk.ch"
#include "clip-gtk.h"

/* Lists all available input devices, along with their configuration information. */
int
clip_GDK_INPUTLISTDEVICES(ClipMachine * cm)
{
	GList *list = gdk_input_list_devices();
        ClipVar *cvlist = RETPTR(cm);
        long n = g_list_length(list);
        long i,j;
        memset(cvlist,0,sizeof(ClipVar));
        _clip_array(cm,cvlist,1,&n);
        for (i=0; list; list = g_list_next(list))
        {
		GdkDeviceInfo *dev = (GdkDeviceInfo*)list->data;
		ClipVar item;
                ClipVar aaxes, akeys;
               	ClipVar cv;
                long naxes = dev->num_axes;
                long nkeys = dev->num_keys;
		memset(&cv,0,sizeof(ClipVar));
                _clip_array(cm,&aaxes,1,&naxes);
                _clip_array(cm,&akeys,1,&nkeys);
		memset(&item,0,sizeof(ClipVar));
		_clip_map(cm,&item);
                _clip_mputn(cm,&item,HASH_DEVICEID,dev->deviceid);
                _clip_mputn(cm,&item,HASH_SOURCE,dev->source);
                _clip_mputn(cm,&item,HASH_MODE,dev->mode);
                _clip_mputc(cm,&item,HASH_NAME,dev->name,strlen(dev->name));
                _clip_mputl(cm,&item,HASH_HASCURSOR,dev->has_cursor);
                _clip_mputn(cm,&item,HASH_NUMAXES,dev->num_axes);
                _clip_mputn(cm,&item,HASH_NUMKEYS,dev->num_keys);
                _clip_aset(cm,cvlist,&item,1,&i);
		cv.t.type = NUMERIC_t;
                for (j=0; j<dev->num_axes; j++)
                {
                        cv.n.d = dev->axes[j];
                        _clip_aset(cm,&aaxes,&cv,1,&j);
                }
                _clip_madd(cm,&item,HASH_AXES,&aaxes);
                for (j=0; j<dev->num_keys; j++)
                {
                        memset (&cv,0,sizeof(ClipVar));
                	_clip_map(cm,&cv);
                        _clip_mputn(cm,&cv,HASH_KEYVAL,dev->keys[j].keyval);
                        _clip_mputn(cm,&cv,HASH_MODIFIERS,dev->keys[j].modifiers);
                        _clip_aset(cm,&akeys,&cv,1,&j);
                        _clip_destroy(cm,&cv);
                }
                _clip_madd(cm,&item,HASH_KEYS,&akeys);
		_clip_destroy(cm,&aaxes); _clip_destroy(cm,&akeys);
		_clip_destroy(cm,&item);
        }
        return 0;
}

/* Turns extension events on or off for a particular window, and
 * specifies the event mask for extension events. */
int
clip_GDK_INPUTSETEXTENSIONEVENTS(ClipMachine * cm)
{
	C_widget *cwid = _fetch_cw_arg(cm);
        gint      mask = _clip_parni(cm,2);
        GdkExtensionMode mode = _clip_parni(cm,3);

	CHECKARG2(1,MAP_t,NUMERIC_t); CHECKCWID(cwid,GTK_IS_WIDGET);
	CHECKARG(2,NUMERIC_t); CHECKARG(3,NUMERIC_t);

	if (cwid->widget->window)
        	gdk_input_set_extension_events (cwid->widget->window,mask,mode);
	return 0;
err:
	return 1;
}

/* Sets the source type for a device. */
int
clip_GDK_INPUTSETSOURCE(ClipMachine * cm)
{
        guint32      deviceid = _clip_parnl(cm,1);
        GdkInputSource source = _clip_parni(cm,2);

	CHECKARG(1,NUMERIC_t); CHECKARG(2,NUMERIC_t);

	gdk_input_set_source (deviceid, source);
	return 0;
err:
	return 1;
}

/* Enables or disables a device, and determines how the device maps onto the screen. */
int
clip_GDK_INPUTSETMODE(ClipMachine * cm)
{
	guint32  deviceid = LONG_OPTION(cm,1,-1);
        GdkInputMode mode = _clip_parni(cm,2);

	CHECKOPT(1,NUMERIC_t); CHECKARG(2,NUMERIC_t);
	if (deviceid == -1)
	{
		static guint32 def_deviceid = -1;
		if (def_deviceid == -1)
                {
			GList *list = gdk_input_list_devices();
        		if (g_list_length(list) > 0)
				def_deviceid = ((GdkDeviceInfo*)list->data)->deviceid;
                }
                deviceid = def_deviceid;
	}

	if (deviceid != -1)
		_clip_retni(cm,gdk_input_set_mode (deviceid, mode));
        else
		_clip_retni(cm,FALSE);
	return 0;
err:
	return 1;
}

/* Sets the key event generated when a macro button is pressed. */
int
clip_GDK_INPUTSETKEY(ClipMachine * cm)
{
        guint32  deviceid = _clip_parnl(cm,1);
        guint       index = _clip_parni(cm,2);
        guint      keyval = _clip_parni(cm,3);
        GdkModifierType modifiers = _clip_parni(cm,4);

	CHECKARG(1,NUMERIC_t); CHECKARG(2,NUMERIC_t);
	CHECKARG(3,NUMERIC_t); CHECKARG(4,NUMERIC_t);

	gdk_input_set_key (deviceid, index, keyval, modifiers);
	return 0;
err:
	return 1;
}

/* Returns information about the current position of the pointer
 * within a window, including extended device information. */
int
clip_GDK_INPUTWINDOWGETPOINTER(ClipMachine * cm)
{
	C_widget    *cwid = _fetch_cw_opt(cm);
	guint32  deviceid = LONG_OPTION(cm,2,-1);
	gdouble x=0, y=0, pressure=0, xtilt=0, ytilt=0;
	GdkModifierType mask=0;

	CHECKCWIDOPT(cwid,GTK_IS_WIDGET);
	CHECKOPT(2,NUMERIC_t);

	if (deviceid == -1)
	{
		static guint32 def_deviceid = -1;
		if (def_deviceid == -1)
                {
			GList *list = gdk_input_list_devices();
        		if (g_list_length(list) > 0)
				def_deviceid = ((GdkDeviceInfo*)list->data)->deviceid;
                }
                deviceid = def_deviceid;
	}

	if (deviceid != -1)
        {
		if (cwid && cwid->widget && cwid->widget->window)
			gdk_input_window_get_pointer (cwid->widget->window, deviceid,
				&x, &y, &pressure, &xtilt, &ytilt, &mask);
		else
			gdk_input_window_get_pointer (NULL, deviceid,
				&x, &y, &pressure, &xtilt, &ytilt, &mask);
        }

	_clip_stornd(cm,x,3,0);
	_clip_stornd(cm,y,4,0);
	_clip_stornd(cm,pressure,5,0);
	_clip_stornd(cm,xtilt,6,0);
	_clip_stornd(cm,ytilt,7,0);
	_clip_storni(cm,mask,8,0);

	return 0;
err:
	return 1;
}


