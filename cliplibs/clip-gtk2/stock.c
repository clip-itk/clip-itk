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


/**********************************************************/
CLIP_DLLEXPORT GtkType _gtk_type_stock_item() { return GTK_TYPE_STOCK_ITEM; }

long _clip_type_stock_item() { return GTK_OBJECT_STOCK_ITEM; }

const char * _clip_type_name_stock_item()  { return "GTK_OBJECT_STOCK_ITEM"; }

/* Register in global table */
int
clip_INIT___STOCKITEM(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_stock_item,  _clip_type_name_stock_item,  _gtk_type_stock_item,  NULL, NULL);
	return 0;
}

/* gtk_StockAdd(aStocks, nStocks) --> NUL                                     */
/* aStocks - array of map with attibutes:                                     */
/*        STOCK_ID - string, stock identifier                                 */
/*           LABEL - string, label                                            */
/*        MODIFIER - numeric, the GdkModifierType                             */
/*          KEYVAL - numeric, key value                                       */
/*   TRANSL_DOMAIN - string,                                                  */

int
clip_GTK_STOCKADD(ClipMachine * cm)
{
	ClipArrVar *cv   = (ClipArrVar *)_clip_vptr(_clip_spar(cm,1));
        guint    n_items = _clip_parni(cm, 2);
        GtkStockItem       *items;
        gint                    i;

	CHECKARG(1, ARRAY_t);
        CHECKARG(2, NUMERIC_t);

	if (cv->count < n_items)
        	n_items = cv->count;
	items = malloc(n_items*sizeof(GtkStockItem));
        memset(items, 0, n_items*sizeof(GtkStockItem));
	for (i=0; i<n_items; i++)
        {
        	GtkStockItem it;
                _map_to_stock_item(cm, &cv->items[i], &it);
                items[i] = it;
        }

	gtk_stock_add(items, n_items);

        free(items);

	return 0;
err:
	return 1;
}


int
clip_GTK_STOCKADDSTATIC(ClipMachine * cm)
{
	ClipArrVar *cv   = (ClipArrVar *)_clip_vptr(_clip_spar(cm,1));
        guint    n_items = _clip_parni(cm, 2);
        GtkStockItem       *items;
        gint                    i;

	CHECKARG(1, ARRAY_t);
        CHECKARG(2, NUMERIC_t);

	if (cv->count < n_items)
        	n_items = cv->count;
	items = malloc(n_items*sizeof(GtkStockItem));
        memset(items, 0, n_items*sizeof(GtkStockItem));
	for (i=0; i<n_items; i++)
        {
        	GtkStockItem it;
                _map_to_stock_item(cm, &cv->items[i], &it);
                items[i] = it;
        }

	gtk_stock_add_static(items, n_items);

        free(items);

	return 0;
err:
	return 1;
}

int
clip_GTK_STOCKITEMCOPY(ClipMachine * cm)
{
	ClipVar *cv   = _clip_spar(cm,1);
        ClipVar           *newcv;
        GtkStockItem        item;
        GtkStockItem    *newitem;

	CHECKARG(1, MAP_t);

        _map_to_stock_item(cm, cv, &item);

	newitem = gtk_stock_item_copy(&item);

	_stock_item_to_map(cm, newcv, newitem);

        _clip_mclone(cm, RETPTR(cm), newcv);

	return 0;
err:
	return 1;
}

int
clip_GTK_STOCKITEMFREE(ClipMachine * cm)
{
	ClipVar *cv   = _clip_spar(cm,1);
        GtkStockItem        item;

	CHECKARG(1, MAP_t);

        _map_to_stock_item(cm, cv, &item);

	gtk_stock_item_free(&item);

	return 0;
err:
	return 1;
}

int
clip_GTK_STOCKLISTIDS(ClipMachine * cm)
{
	ClipVar  *cv;
        GSList *list;
        long    i, n;

	list = gtk_stock_list_ids();

        n = g_slist_length(list);
        if (n>0)
        {
        	_clip_array(cm, cv, 1, &n);
                for (i=0; list; list=g_slist_next(list), i++)
                {
                	ClipVar  c;
                        gchar *str;

			memset(&cv, 0, sizeof(cv));
			str = (gchar *)list->data;
                	_clip_var_str(str, strlen(str), &c);
                	_clip_aset(cm, cv, &c, 1, &i);
                        _clip_destroy(cm, &c);
                        g_free(str);
                }
                g_slist_free(list);
                _clip_mclone(cm, RETPTR(cm), cv);
        }

	return 0;
}

int
clip_GTK_STOCKLOOKUP(ClipMachine * cm)
{
	gchar *stock_id	= _clip_parc(cm, 1);
	ClipVar     *cv	= _clip_spar(cm, 2);
        GtkStockItem        item;

	CHECKARG(1, CHARACTER_t);
	CHECKARG(2, MAP_t);

        _map_to_stock_item(cm, cv, &item);

	_clip_retl(cm, gtk_stock_lookup(stock_id, &item));

	return 0;
err:
	return 1;
}

