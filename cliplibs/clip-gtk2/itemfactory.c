/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <string.h>
#include <gtk/gtk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"

/*********************** SIGNALS **************************/

/* ItemFactory has no signals */

/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_item_factory() { return GTK_TYPE_ITEM_FACTORY; }

long _clip_type_item_factory() { return GTK_OBJECT_ITEM_FACTORY; }

const char * _clip_type_name_item_factory()  { return "GTK_TYPE_ITEM_FACTORY"; }

int
clip_INIT___ITEMFACTORY(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_item_factory,  _clip_type_name_item_factory,  _gtk_type_item_factory,  NULL, NULL);
	return 0;
}

static void
_item_factory_callback1(gpointer data, guint callback_action, GtkWidget *wid)
{
	C_var *c = (C_var*)data;
	C_widget *c_wid = _list_get_cwidget(c->cm, wid);
	ClipVar stack[2];
	ClipVar res;
	if (!c_wid)
		c_wid = _register_widget(c->cm,wid, NULL);
	if (c_wid)
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		_clip_mclone(c->co->cmachine, &stack[0], &c->co->obj);
		stack[1] = c_wid->obj;
		_clip_eval( c->cm, &(c->cfunc), 2, stack, &res );
		_clip_destroy(c->cm, &res);
	}
}

static void
_item_factory_callback2(GtkWidget *wid, gpointer data, guint callback_action)
{
	C_var *c = (C_var*)data;
	C_widget *c_wid = _list_get_cwidget(c->cm, wid);
	ClipVar stack[2];
	ClipVar res;
	if (!c_wid)
		c_wid = _register_widget(c->cm,wid, NULL);
	if (c_wid)
	{
		memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
		_clip_mclone(c->co->cmachine, &stack[0], &c->co->obj);
		stack[1] = c_wid->obj;
		_clip_eval( c->cm, &(c->cfunc), 2, stack, &res );
		_clip_destroy(c->cm, &res);
	}
}

/******************************************************************************
* gtk_ItemFactoryNew( container_type, spath, accel_group ) --> ItemFactoryNewObject
* container_type is  one of :GTK_TYPE_MENU_BAR, GTK_TYPE_MENU or GTK_TYPE_OPTION_MENU
******************************************************************************/
int
clip_GTK_ITEMFACTORYNEW(ClipMachine * cm)
{
        gint		itype = INT_OPTION(cm, 1, CLIP_GTK_TYPE_MENU_BAR);
        const gchar     *path = _clip_parc(cm, 2);
        C_object      *caccel = _fetch_cobject(cm, _clip_spar(cm, 3));
        C_object       *citem ;
        GtkItemFactory  *item ;
        GtkType		 type ;

	CHECKARG(1, NUMERIC_t);
	CHECKARG(2, CHARACTER_t);
	CHECKOPT(3, MAP_t); CHECKCOBJOPT(caccel, GTK_IS_ACCEL_GROUP(caccel->object));

        switch (itype)
        {
        	case CLIP_GTK_TYPE_MENU_BAR: type = GTK_TYPE_MENU_BAR; break;
        	case CLIP_GTK_TYPE_MENU: type = GTK_TYPE_MENU; break;
        	case CLIP_GTK_TYPE_OPTION_MENU: type = GTK_TYPE_OPTION_MENU; break;
        }

	item = gtk_item_factory_new(type, path, GTK_ACCEL_GROUP(caccel->object));

	if (item)
	{
		citem = _list_get_cobject(cm,item);
		if (!citem) citem = _register_object(cm,item,GTK_TYPE_ITEM_FACTORY,NULL,NULL);
		if (citem) _clip_mclone(cm,RETPTR(cm),&citem->obj);
	}
	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ItemFactoryConstruct( itemFactory, container_type, spath, accel_group ) --> NIL
* container_type is  one of :GTK_TYPE_MENU_BAR, GTK_TYPE_MENU or GTK_TYPE_OPTION_MENU
******************************************************************************/
int
clip_GTK_ITEMFACTORYCONSTRUCT(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        GtkType		 type = INT_OPTION(cm, 2, GTK_TYPE_MENU_BAR);
        const gchar     *path = _clip_parc(cm, 3);
        C_object      *caccel = _fetch_cobject(cm, _clip_spar(cm, 4));

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
	CHECKARG(2, NUMERIC_t);
	CHECKARG(3, CHARACTER_t);
	CHECKOPT(4, MAP_t); CHECKCOBJOPT(caccel, GTK_IS_ACCEL_GROUP(caccel->object));

	gtk_item_factory_construct(GTK_ITEM_FACTORY(citem->object), type,
		path, GTK_ACCEL_GROUP(caccel->object));

	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ItemFactoryAddForeign( accel_widget, sfull_path, accel_group, nkeyvalue, modifiers ) --> NIL
******************************************************************************/
int
clip_GTK_ITEMFACTORYADDFOREIGN(ClipMachine * cm)
{
        C_widget        *cwid = _fetch_cw_arg(cm);
        const gchar     *path = _clip_parc(cm, 2);
        C_object      *caccel = _fetch_cobject(cm, _clip_spar(cm, 3));
        gint           keyval = _clip_parni(cm, 4);
        GdkModifierType	 type = _clip_parni(cm, 5);

	CHECKARG(1, MAP_t); CHECKCWID(cwid, GTK_IS_WIDGET);
	CHECKARG(2, CHARACTER_t);
	CHECKOPT(3, MAP_t); CHECKCOBJOPT(caccel, GTK_IS_ACCEL_GROUP(caccel->object));
	CHECKARG(4, NUMERIC_t);
	CHECKARG(5, NUMERIC_t);

	gtk_item_factory_add_foreign(GTK_WIDGET(cwid->widget),
		path, GTK_ACCEL_GROUP(caccel->object), keyval, type);

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ItemFactoryFromWidget( widget ) --> itemFactory
******************************************************************************/
int
clip_GTK_ITEMFACTORYFROMWIDGET(ClipMachine * cm)
{
        C_widget        *cwid = _fetch_cw_arg(cm);
        C_object       *citem ;
        GtkItemFactory  *item;

	CHECKARG(1, MAP_t); CHECKCWID(cwid, GTK_IS_WIDGET);

	item = gtk_item_factory_from_widget(GTK_WIDGET(cwid->widget));

	if (item)
	{
		citem = _list_get_cobject(cm,item);
		if (!citem) citem = _register_object(cm,item,GTK_TYPE_ITEM_FACTORY,NULL,NULL);
		if (citem) _clip_mclone(cm,RETPTR(cm),&citem->obj);
	}
	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ItemFactoryPathFromWidget( widget ) --> spath
******************************************************************************/
int
clip_GTK_ITEMFACTORYPATHFROMWIDGET(ClipMachine * cm)
{
        C_widget        *cwid = _fetch_cw_arg(cm);
        gchar            *str ;

	CHECKARG(1, MAP_t); CHECKCWID(cwid, GTK_IS_WIDGET);

	str = (gchar *)gtk_item_factory_path_from_widget(GTK_WIDGET(cwid->widget));

	_clip_retc(cm, str);
	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ItemFactoryGetItem( itemFactory, spath ) --> widget
******************************************************************************/
int
clip_GTK_ITEMFACTORYGETITEM(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        const gchar     *path = _clip_parc(cm, 2);
        GtkWidget        *wid ;
        C_widget        *cwid ;

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, CHARACTER_t);

	wid = gtk_item_factory_get_item(GTK_ITEM_FACTORY(citem->object), path);

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, NULL);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ItemFactoryGetWidget( itemFactory, spath ) --> widget
******************************************************************************/
int
clip_GTK_ITEMFACTORYGETWIDGET(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        const gchar     *path = _clip_parc(cm, 2);
        GtkWidget        *wid ;
        C_widget        *cwid ;

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, CHARACTER_t);

	wid = gtk_item_factory_get_widget(GTK_ITEM_FACTORY(citem->object), path);

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, NULL);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ItemFactoryGetWidgetByAction( itemFactory, naction ) --> widget
******************************************************************************/
int
clip_GTK_ITEMFACTORYGETWIDGETBYACTION(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        gint           action = _clip_parni(cm, 2);
        GtkWidget        *wid ;
        C_widget        *cwid ;

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, NUMERIC_t);

	wid = gtk_item_factory_get_widget_by_action(
		GTK_ITEM_FACTORY(citem->object), action);

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, NULL);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ItemFactoryGetItemByAction( itemFactory, naction ) --> widget
******************************************************************************/
int
clip_GTK_ITEMFACTORYGETITEMBYACTION(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        gint           action = _clip_parni(cm, 2);
        GtkWidget        *wid ;
        C_widget        *cwid ;

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, NUMERIC_t);

	wid = gtk_item_factory_get_item_by_action(
		GTK_ITEM_FACTORY(citem->object), action);

	if (!wid) goto err;
	cwid = _register_widget(cm, wid, NULL);
	_clip_mclone(cm,RETPTR(cm),&cwid->obj);
	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ItemFactoryCreateItem( itemFactory, entry, ncallback_type ) --> NIL
* entry is array with elements:
* - path, string    (f.e. "_File")
* - accelerator, string or NIL (f.e. "<control>N" )
* - callback function, code block or 0 (f.e code block or 0)
* - callback action, numeric (f.e. 1)
* - item type, string or NIL (f.e. "<RadioItem>")
* 	possible values:
* 	NIL		-> "<Item>"
* 	""		-> "<Item>"
* 	"<Title>"	-> create a title item
* 	"<Item>"	-> create a simple item
* 	"<ImageItem>"	-> create an item holding an image
* 	"<StockItem>"	-> create an item holding a stock image
* 	"<CheckItem>"	-> create a check item
* 	"<ToggleItem>"	-> create a toggle item
* 	"<RadioItem>"	-> create a radio item
* 	<path>		-> path of a radio item to link against
* 	"<Separator>"	-> create a separator
* 	"<Tearoff>"	-> create a tearoff separator
* 	"<Branch>"	-> create an item to hold sub items
* 	"<LastBranch>"	-> create a right justified item to hold sub items
*****************************************************************************/
int
clip_GTK_ITEMFACTORYCREATEITEM(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        ClipArrVar   *cventry = (ClipArrVar *)_clip_vptr(_clip_par(cm, 2));
        gint             type = INT_OPTION(cm, 3, 1);
        GtkItemFactoryEntry entry ;
	ClipVar *cfunc ;
        C_var		*data ;

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, ARRAY_t);
        CHECKARG(3, NUMERIC_t);




        entry.path = (cventry->items[0].t.type==UNDEF_t)?NULL:cventry->items[0].s.str.buf;
        entry.accelerator = (cventry->items[1].t.type==UNDEF_t)?NULL:cventry->items[1].s.str.buf;

	cfunc = &cventry->items[2];

	data = NEW(C_var);
	data->cm = cm; data->co = citem;
	_clip_mclone(cm, &data->cfunc, cfunc);

        if (type == 1)
               	entry.callback = (cfunc==NULL)?0:(GtkItemFactoryCallback1)_item_factory_callback1;
        else
               	entry.callback = (cfunc==NULL)?0:(GtkItemFactoryCallback2)_item_factory_callback2;

	entry.callback_action = (cventry->items[3].t.type==UNDEF_t)?0:(guint)cventry->items[3].n.d;
	entry.item_type = (cventry->items[4].t.type==UNDEF_t)?NULL:cventry->items[4].s.str.buf;

	gtk_item_factory_create_item(GTK_ITEM_FACTORY(citem->object), &entry,
		data, type);

	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ItemFactoryCreateItems( itemFactory, array_entry ) --> NIL
******************************************************************************/
int
clip_GTK_ITEMFACTORYCREATEITEMS(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        ClipArrVar   *cventry = (ClipArrVar *)_clip_vptr(_clip_par(cm, 2));
        gint             i, n ;

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, ARRAY_t);

	n = cventry->count;


	for (i=0; i<n; i++)
        {
         	ClipArrVar *it = (ClipArrVar *)_clip_vptr(cventry->items[i].a.items);
		ClipVar *cfunc ;
        	C_var       *c ;
                GtkItemFactoryEntry entry;

         	entry.path = (it->items[0].t.type==UNDEF_t)?NULL:it->items[0].s.str.buf;
         	entry.accelerator = (it->items[1].t.type==UNDEF_t)?NULL:it->items[1].s.str.buf;

		cfunc = (it->items[2].t.type==UNDEF_t)?NULL:&it->items[2];


		c = NEW(C_var);
		c->cm = cm; c->co = citem;
		_clip_mclone(cm, &c->cfunc, cfunc);

                entry.callback = (cfunc==NULL)?0:(GtkItemFactoryCallback1)_item_factory_callback1;

		entry.callback_action = 1;
		entry.item_type = (it->items[4].t.type==UNDEF_t)?0:it->items[4].s.str.buf;
		gtk_item_factory_create_item(GTK_ITEM_FACTORY(citem->object), &entry,
			c, 1);
        }

	return 0;
err:
	return 1;
}


/******************************************************************************
* gtk_ItemFactoryDeleteItem( itemFactory, spath ) --> NIL
******************************************************************************/
int
clip_GTK_ITEMFACTORYDELETEITEM(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        const gchar     *path = _clip_parc(cm, 2);

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, CHARACTER_t);

	gtk_item_factory_delete_item(GTK_ITEM_FACTORY(citem->object), path );

	return 0;
err:
	return 1;
}
/******************************************************************************
* gtk_ItemFactoryDeleteEntry( itemFactory, entry ) --> NIL
*****************************************************************************/
int
clip_GTK_ITEMFACTORYDELETEENTRY(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        ClipArrVar   *cventry = (ClipArrVar *)_clip_vptr(_clip_par(cm, 2));
        GtkItemFactoryEntry entry ;
	ClipVar *cfunc ;
        C_var		*data ;

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, ARRAY_t);

        entry.path = (cventry->items[0].t.type==UNDEF_t)?NULL:cventry->items[0].s.str.buf;
        entry.accelerator = (cventry->items[1].t.type==UNDEF_t)?NULL:cventry->items[1].s.str.buf;

	cfunc = &cventry->items[2];

	data = NEW(C_var);
	data->cm = cm; data->co = citem;
	_clip_mclone(cm, &data->cfunc, cfunc);

        entry.callback = (cfunc==NULL)?0:(GtkItemFactoryCallback1)_item_factory_callback1;

	entry.callback_action = (cventry->items[3].t.type==UNDEF_t)?0:(guint)cventry->items[3].n.d;
	entry.item_type = (cventry->items[4].t.type==UNDEF_t)?NULL:cventry->items[4].s.str.buf;

	gtk_item_factory_delete_entry(GTK_ITEM_FACTORY(citem->object), &entry);

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ItemFactoryDeleteEntries( itemFactory, array_entry ) --> NIL
******************************************************************************/
int
clip_GTK_ITEMFACTORYDELETEENTRIES(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        ClipArrVar   *cventry = (ClipArrVar *)_clip_vptr(_clip_par(cm, 2));
        gint             i, n ;

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, ARRAY_t);

	n = cventry->count;

	for (i=0; i<n; i++)
        {
         	ClipArrVar *it = (ClipArrVar *)_clip_vptr(cventry->items[i].a.items);
		ClipVar *cfunc ;
        	C_var       *c ;
                GtkItemFactoryEntry entry;

         	entry.path = (it->items[0].t.type==UNDEF_t)?NULL:it->items[0].s.str.buf;
         	entry.accelerator = (it->items[1].t.type==UNDEF_t)?NULL:it->items[1].s.str.buf;

		cfunc = (it->items[2].t.type==UNDEF_t)?NULL:&it->items[2];


		c = NEW(C_var);
		c->cm = cm; c->co = citem;
		_clip_mclone(cm, &c->cfunc, cfunc);

                entry.callback = (cfunc==NULL)?0:(GtkItemFactoryCallback1)_item_factory_callback1;

		entry.callback_action = 1;
		entry.item_type = (it->items[4].t.type==UNDEF_t)?0:it->items[4].s.str.buf;
		gtk_item_factory_delete_entry(GTK_ITEM_FACTORY(citem->object), &entry);
        }

	return 0;
err:
	return 1;
}

/******************************************************************************
* gtk_ItemFactoryPopup( itemFactory, nx, ny, nmouse_button, ntime ) --> NIL
* itemFactory of type GLIP_GTK_TYPE_MENU
******************************************************************************/
int
clip_GTK_ITEMFACTORYPOPUP(ClipMachine * cm)
{
        C_object       *citem = _fetch_co_arg(cm);
        gint                x = _clip_parni(cm, 2);
        gint                y = _clip_parni(cm, 3);
        gint     mouse_button = _clip_parni(cm, 4);
        guint32          time = _clip_parni(cm, 5);

	CHECKARG(1, MAP_t); CHECKCOBJ(citem, GTK_IS_ITEM_FACTORY(citem->object));
        CHECKARG(2, NUMERIC_t);
        CHECKARG(3, NUMERIC_t);
        CHECKARG(4, NUMERIC_t);
        CHECKARG(5, NUMERIC_t);

	gtk_item_factory_popup(GTK_ITEM_FACTORY(citem->object), x, y,
        	mouse_button, time );

	return 0;
err:
	return 1;
}


