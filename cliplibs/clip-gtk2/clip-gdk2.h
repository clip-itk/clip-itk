/*      changes for gtk+-2.0
	comment to: GDK_GC
        	    GDK_IS_GC
                    GDK_WINDOW
                    GDK_IS_WINDOW
                    GDK_COLORMAP
                    GDK_IS_COLORMAP

*/
#ifndef __CLIP_GDK_H__
#define __CLIP_GDK_H__

#define GDK_FONT(p)		((GdkFont*)(p))
#define GDK_IS_FONT(obj)	(((C_object*)(obj))->type == GDK_OBJECT_FONT)
#define GDK_REGION(p)		((GdkRegion*)(p))
#define GDK_IS_REGION(obj)	(obj && ((C_object*)obj)->type == GDK_OBJECT_REGION)


#define GDK_CURSOR(p)		((GdkCursor*)(p))
#define GDK_IS_CURSOR(obj)	(obj && ((C_object*)obj)->type == GDK_OBJECT_CURSOR)
#define GDK_FONT(p)		((GdkFont*)(p))
#define GDK_IS_FONT(obj)	(((C_object*)(obj))->type == GDK_OBJECT_FONT)

#endif

