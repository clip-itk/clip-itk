/*
    Copyright (C) 2001  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <string.h>
#include "hashcode.h"
#include "clip.h"
#include "clip-gtkcfg2.h"

#include <gtk/gtk.h>
#include <gdk/gdk.h>

#include "clip-gtk2.ch"
#include "clip-gtk2.h"
#include "clip-gdk2.h"

GtkType _gdk_type_region() { return GDK_TYPE_REGION; }
long _clip_type_region() { return GDK_TYPE_REGION; }
const char * _clip_type_name_region() { return "GDK_OBJECT_REGION"; }

int
clip_INIT___GDKREGION(ClipMachine *cm)
{
	_wtype_table_put(_clip_type_region, _clip_type_name_region, _gdk_type_region, NULL, NULL);
	return 0;
}
/**********************************************************/

/*
static int
gdk_object_region_destructor(ClipMachine *cm, C_object *creg)
{
	if (creg && GDK_IS_REGION(creg))
        	gdk_region_destroy(GDK_REGION(creg->object));
        return 0;
}
*/


/* Get GdkRectangle data from a map */
CLIP_DLLEXPORT int _map_get_gdk_rectangle (ClipMachine *cm, ClipVar *map, GdkRectangle *region)
{
        if (map && map->t.type==MAP_t && region)
        {
		double x, y, width, height;
		_clip_mgetn(cm, map, HASH_X, &x);
		_clip_mgetn(cm, map, HASH_Y, &y);
		_clip_mgetn(cm, map, HASH_WIDTH, &width);
		_clip_mgetn(cm, map, HASH_HEIGHT, &height);
                region->x = x;
                region->y = y;
                region->width = width;
                region->height = height;
                return 0;
	}
        return -1;
}

/* Set GdkRectangle data to a map */
CLIP_DLLEXPORT int _map_put_gdk_rectangle (ClipMachine *cm, ClipVar *map, GdkRectangle *region)
{
        if (map && map->t.type==MAP_t && region)
        {
		_clip_mputn(cm, map, HASH_X, region->x);
		_clip_mputn(cm, map, HASH_Y, region->y);
		_clip_mputn(cm, map, HASH_WIDTH, region->width);
		_clip_mputn(cm, map, HASH_HEIGHT, region->height);
                return 0;
	}
        return -1;
}

/* Calculates the intersection of two rectangles. */
int
clip_GDK_RECTANGLEINTERSECT(ClipMachine * cm)
{
	ClipVar *creg1 = _clip_spar(cm,1);
        ClipVar *creg2 = _clip_spar(cm,2);
        //ClipVar *cdest = _clip_spar(cm,3);
	GdkRectangle reg1, reg2, dest;

	CHECKARG(1,MAP_t); CHECKARG(2,MAP_t); CHECKOPT(3,MAP_t);

	_map_get_gdk_rectangle(cm, creg1, &reg1);
	_map_get_gdk_rectangle(cm, creg2, &reg2);

	_clip_retl(cm, gdk_rectangle_intersect(&reg1, &reg2, &dest));

	if (_clip_parinfo(cm,3) == MAP_t)
        	_map_put_gdk_rectangle(cm, _clip_spar(cm,3), &dest);

	return 0;
err:
	return 1;
}

/* Calculates the union of two rectangles. The union of rectangles
 * src1 and src2 is the smallest rectangle which includes both
 * src1 and src2 within it. */
int
clip_GDK_RECTANGLEUNION(ClipMachine * cm)
{
	ClipVar *creg1 = _clip_spar(cm,1);
        ClipVar *creg2 = _clip_spar(cm,2);
	ClipVar *cdest = RETPTR(cm);
	GdkRectangle reg1, reg2, dest;

	CHECKARG(1,MAP_t); CHECKARG(2,MAP_t); CHECKARG(3,MAP_t);

	_map_get_gdk_rectangle(cm, creg1, &reg1);
	_map_get_gdk_rectangle(cm, creg2, &reg2);

	gdk_rectangle_union(&reg1, &reg2, &dest);

        memset(cdest, 0, sizeof(*cdest)); _clip_map(cm,cdest);
        _map_put_gdk_rectangle(cm, cdest, &dest);

	return 0;
err:
	return 1;
}

/* Creates a new empty GdkRegion. */
int
clip_GDK_REGIONNEW(ClipMachine * cm)
{
	ClipVar *cv = _clip_spar(cm,1);
	GdkRegion *region;
	C_object *cregion;
	CHECKOPT(1,MAP_t);

	region = gdk_region_new();

	if (region)
	{
		cregion = _register_object(cm,region,GDK_TYPE_REGION,cv,NULL);
		if (cregion)
			_clip_mclone(cm,RETPTR(cm),&cregion->obj);
                else
                	gdk_region_destroy(region);
	}
	return 0;
err:
	return 1;
}

/* Creates a new GdkRegion using the polygon defined by a number of points. */
/*
parameters - ([mObj], <aPoints>, [nPoints], [nFillRule])
	[mObj] - object, will returned;
	<aPoints> - array of points. Every point is an array {x,y};
        [nPoints] - number of points. If no, gets the length of aPoints;
        [nFillRule] - specifies which pixels are included in the region
        		when the polygon overlaps itself.
*/
int
clip_GDK_REGIONPOLYGON(ClipMachine * cm)
{
	ClipVar  *cv = _clip_spar(cm,1);
	ClipVar *cap = _clip_spar(cm,2);
        int  npoints = _clip_parni(cm,3);
        int fillrule = _clip_parni(cm,4);
	GdkRegion *region;
	C_object *cregion;
        unsigned short i;
        ClipVar *cpoint;
        GdkPoint *points;
	CHECKOPT(1,MAP_t); CHECKARG(2,ARRAY_t);
	CHECKOPT(3,NUMERIC_t); CHECKOPT(4,NUMERIC_t);

	if (_clip_parinfo(cm,3) == UNDEF_t) npoints = cap->a.count;
        npoints = MIN (npoints, cap->a.count);

        points = (GdkPoint*)calloc(npoints, sizeof(GdkPoint));
        for (i=0; i<npoints; i++)
        {
		cpoint = &cap->a.items[i];
                if (cpoint->t.type == ARRAY_t)
                {
			if (cpoint->a.count>0 && cpoint->a.items[0].t.type == NUMERIC_t)
				points[i].x = cpoint->a.items[0].n.d;
			if (cpoint->a.count>1 && cpoint->a.items[1].t.type == NUMERIC_t)
				points[i].y = cpoint->a.items[1].n.d;
                }
        }

	region = gdk_region_polygon(points, npoints, fillrule);

	free(points);

	if (region)
	{
		cregion = _register_object(cm,region,GDK_TYPE_REGION,cv,NULL);
		if (cregion)
			_clip_mclone(cm,RETPTR(cm),&cregion->obj);
                else
                	gdk_region_destroy(region);
	}
	return 0;
err:
	return 1;
}

/* Destroys a GdkRegion. */
int
clip_GDK_REGIONDESTROY(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));

	gdk_region_destroy(GDK_REGION(creg));

	return 0;
err:
	return 1;
}

/* Returns the intersection of two regions. */
int
clip_GDK_REGIONSINTERSECT(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
        C_object *creg2 = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object *cdest;

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCOBJ(creg2,GDK_IS_REGION(creg->object));

	gdk_region_intersect(GDK_REGION(creg),GDK_REGION(creg2));

	if (creg)
	{
		cdest = _register_object(cm,GDK_REGION(creg),GDK_TYPE_REGION,NULL,NULL);
		if (cdest)
			_clip_mclone(cm,RETPTR(cm),&cdest->obj);
	}

	return 0;
err:
	return 1;
}

/* Returns the union of two regions. This is all pixels
 * in either of source1 or source2. */
int
clip_GDK_REGIONUNION(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
        C_object *creg2 = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object *cdest;

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCOBJ(creg2,GDK_IS_REGION(creg->object));

	gdk_region_union(GDK_REGION(creg),GDK_REGION(creg2));

	if (creg)
	{
		cdest = _register_object(cm,GDK_REGION(creg),GDK_TYPE_REGION,NULL,NULL);
		if (cdest)
			_clip_mclone(cm,RETPTR(cm),&cdest->obj);
	}

	return 0;
err:
	return 1;
}

/* Subtracts one region from another. The result is a region containing
 * all the pixels which are in source1, but which are not in source2. */
int
clip_GDK_REGIONSUBTRACT(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
        C_object *creg2 = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object *cdest;

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCOBJ(creg2,GDK_IS_REGION(creg->object));

	gdk_region_subtract(GDK_REGION(creg),GDK_REGION(creg2));

	if (creg)
	{
		cdest = _register_object(cm,GDK_REGION(creg),GDK_TYPE_REGION,NULL,NULL);
		if (cdest)
			_clip_mclone(cm,RETPTR(cm),&cdest->obj);
	}

	return 0;
err:
	return 1;
}

/* Returns the difference between the union and the intersection of two
 * regions. This is a region containing the pixels that are in one of the
 * source regions, but which are not in both. */
int
clip_GDK_REGIONXOR(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
        C_object *creg2 = _fetch_cobject(cm,_clip_spar(cm,2));
	C_object *cdest;

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCOBJ(creg2,GDK_IS_REGION(creg->object));

	gdk_region_xor(GDK_REGION(creg),GDK_REGION(creg2));

	if (creg)
	{
		cdest = _register_object(cm,GDK_REGION(creg),GDK_TYPE_REGION,NULL,NULL);
		if (cdest)
			_clip_mclone(cm,RETPTR(cm),&cdest->obj);
	}

	return 0;
err:
	return 1;
}

/* Returns the union of a region and a rectangle. */
int
clip_GDK_REGIONUNIONWITHRECT(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
        ClipVar  *crect = _clip_spar(cm,2);
	C_object *cdest;
        GdkRectangle rect;

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object)); CHECKARG(2,MAP_t);

	_map_get_gdk_rectangle(cm, crect, &rect);
	gdk_region_union_with_rect(GDK_REGION(creg), &rect);

	if (creg)
	{
		cdest = _register_object(cm,GDK_REGION(creg),GDK_TYPE_REGION,NULL,NULL);
		if (cdest)
			_clip_mclone(cm,RETPTR(cm),&cdest->obj);
	}

	return 0;
err:
	return 1;
}

/* Moves a region the specified distance. */
int
clip_GDK_REGIONOFFSET(ClipMachine * cm)
{
	C_object *creg = _fetch_co_arg(cm);
        gint        dx = _clip_parni(cm,2);
        gint        dy = _clip_parni(cm,3);

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);

	gdk_region_offset(GDK_REGION(creg), dx,dy);

	return 0;
err:
	return 1;
}

/* Resizes a region by the specified amount.
 * Positive values shrink the region. Negative values expand it. */
int
clip_GDK_REGIONSHRINK(ClipMachine * cm)
{
	C_object *creg = _fetch_co_arg(cm);
        gint        dx = _clip_parni(cm,2);
        gint        dy = _clip_parni(cm,3);

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);

	gdk_region_shrink(GDK_REGION(creg), dx,dy);

	return 0;
err:
	return 1;
}

/* Returns TRUE if the GdkRegion is empty. */
int
clip_GDK_REGIONEMPTY(ClipMachine * cm)
{
	C_object *creg = _fetch_co_arg(cm);

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));

	_clip_retl(cm,gdk_region_empty(GDK_REGION(creg)));

	return 0;
err:
	return 1;
}

/* Returns TRUE if the two regions are the same. */
int
clip_GDK_REGIONEQUAL(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
	C_object *creg2 = _fetch_cobject(cm,_clip_spar(cm,2));

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));
	CHECKARG2(2,MAP_t,NUMERIC_t); CHECKCOBJ(creg2,GDK_IS_REGION(creg2->object));

	_clip_retl(cm,gdk_region_equal(GDK_REGION(creg), GDK_REGION(creg2)));

	return 0;
err:
	return 1;
}

/* Returns TRUE if a point is in a region. */
int
clip_GDK_REGIONPOINTIN(ClipMachine * cm)
{
	C_object *creg = _fetch_co_arg(cm);
        gint         x = _clip_parni(cm,2);
        gint         y = _clip_parni(cm,3);

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));
	CHECKOPT(2,NUMERIC_t); CHECKOPT(3,NUMERIC_t);

	_clip_retl(cm,gdk_region_point_in(GDK_REGION(creg), x,y));

	return 0;
err:
	return 1;
}

/* Tests whether a rectangle is within a region. */
int
clip_GDK_REGIONRECTIN(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
        ClipVar  *crect = _clip_spar(cm,2);
        GdkRectangle rect;

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object)); CHECKARG(2,MAP_t);

	_map_get_gdk_rectangle(cm, crect, &rect);
	_clip_retni(cm,gdk_region_rect_in(GDK_REGION(creg), &rect));

	return 0;
err:
	return 1;
}

/* Returns the smallest rectangle which includes the entire GdkRegion. */
int
clip_GDK_REGIONGETCLIPBOX(ClipMachine * cm)
{
	C_object *creg  = _fetch_co_arg(cm);
        ClipVar  *crect = RETPTR(cm);
        GdkRectangle rect;

	CHECKCOBJ(creg,GDK_IS_REGION(creg->object));

	gdk_region_get_clipbox(GDK_REGION(creg), &rect);

	memset(crect,0,sizeof(*crect)); _clip_map(cm,crect);
	_map_put_gdk_rectangle(cm, crect, &rect);

	return 0;
err:
	return 1;
}

