#ifndef __CLIP_GDK_H__
#define __CLIP_GDK_H__

#define GDK_GC(p)		((GdkGC*)(p))
#define GDK_IS_GC(obj)		(((C_object*)(obj))->type == GDK_OBJECT_GC)
#define GDK_FONT(p)		((GdkFont*)(p))
#define GDK_IS_FONT(obj)	(((C_object*)(obj))->type == GDK_OBJECT_FONT)
#define GDK_REGION(p)		((GdkRegion*)(p))
#define GDK_IS_REGION(obj)	(obj && ((C_object*)obj)->type == GDK_OBJECT_REGION)
#define GDK_WINDOW(p)		((GdkWindow*)(p))
#define GDK_IS_WINDOW(obj)	(obj && ((C_object*)obj)->type == GDK_OBJECT_WINDOW)
#define GDK_CURSOR(p)		((GdkCursor*)(p))
#define GDK_IS_CURSOR(obj)	(obj && ((C_object*)obj)->type == GDK_OBJECT_CURSOR)
#define GDK_FONT(p)		((GdkFont*)(p))
#define GDK_IS_FONT(obj)	(((C_object*)(obj))->type == GDK_OBJECT_FONT)
#define GDK_COLORMAP(p)		((GdkColormap*)(p))
#define GDK_IS_COLORMAP(obj)	(((C_object*)(obj))->type == GDK_OBJECT_COLORMAP)

#endif
