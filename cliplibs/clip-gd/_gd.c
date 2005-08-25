/*
    Copyright (C) 2001  ITK
    Authors  : Uri Hnykin <uri@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
   $Log: _gd.c,v $
   Revision 1.7  2005/08/05 10:06:36  clip
   alena: fix for gcc 4

   Revision 1.6  2003/02/04 07:34:21  clip
   alena: add new function gdImageCopyResized()

   Revision 1.5  2002/10/14 07:06:44  clip
   fixed bug from bugzilla - reference to functions
   alena:

   Revision 1.4  2002/05/28 07:34:35  clip
   alena: add toFile to stdout and create file from stdin

   Revision 1.3  2002/05/23 08:37:02  clip
   alena: add function GDIMAGEJPEG() and fix

   Revision 1.2  2002/03/18 06:26:36  clip
   alena:
   add new function into gd - gdImageCopy()

   Revision 1.1  2001/12/06 15:30:47  clip
   change package build system
   paul

   Revision 1.6  2001/06/26 12:28:17  clip
   add new function GdFontInfo()
   alena:

   Revision 1.5  2001/06/13 08:19:56  clip
   alena: gdCos && gdSin

   Revision 1.4  2001/06/06 14:17:05  clip
   alena: small bug in gdcos && gdsin

   Revision 1.3  2001/06/06 12:47:19  clip
   uri:return 0 in functions

   Revision 1.2  2001/06/06 12:45:12  clip
   uri: gdcos & gdsin added

   Revision 1.1  2001/06/05 09:17:20  clip
   add clip_gd to cvs

   Revision 1.9  2001/05/28 11:06:52  clip
   uri: small bugs

   Revision 1.8  2001/05/28 10:18:00  clip
   uri: small bugs

   Revision 1.7  2001/05/28 09:52:29  clip
   uri: charvector & stringvector

   Revision 1.6  2001/05/28 09:41:43  clip
   uri: _clip_vptr() in gdPolygon()

   Revision 1.5  2001/05/28 09:23:33  clip
   uri: new functions in _gd.c

   Revision 1.4  2001/05/28 06:27:59  clip
   uri: polugon() in gd

   Revision 1.3  2001/05/26 15:16:19  clip
   uri: ne functios in gd

   Revision 1.2  2001/05/25 12:59:24  clip
   uri: new function in gd

   Revision 1.1  2001/05/25 11:24:22  clip
   uri: starting add gdlib to clip
*/

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <limits.h>
#include <errno.h>

#include "clip.h"
#include "error.ch"
#include "gdinfo.ch"

#include "gd.h"

#define	HASH_ferror    	0xB5AA60AD

static void
_clip_destroy_gdImage(void *im)
{
	if ( im!= NULL )
		gdImageDestroy( (gdImagePtr) im );
}

static gdImagePtr
_clip_getImagePtr(ClipMachine * mp)
{
	gdImagePtr im=NULL;
	int nImage = _clip_parni(mp,1);

	if ( _clip_parinfo(mp,1) == NUMERIC_t )
	{
		im=_clip_fetch_c_item(mp,nImage,_C_ITEM_TYPE_GDLIB);
	}
	return im;
}

#define GETIMAGE(mp) _clip_getImagePtr(mp)


int
clip_GDIMAGECREATE(ClipMachine * mp)
{
	gdImagePtr im;
	int xSize = _clip_parni(mp,1);
	int ySize = _clip_parni(mp,2);
	int ret;

	if ( xSize<=0 ) xSize=256;
	if ( ySize<=0 ) xSize=256;
	im=gdImageCreate(xSize,ySize);
	if ( im==NULL )
	{
		_clip_retni(mp,-1);
		return 0;
	}
	ret=_clip_store_c_item(mp, (void *)im ,_C_ITEM_TYPE_GDLIB, _clip_destroy_gdImage );
	_clip_retni(mp,ret);
	return 0;
}


static int
_clip_gdImageFromFile(ClipMachine * mp, int typeFile)
{
	gdImagePtr im=NULL;
	char * fname = _clip_parc(mp,1);
	char buf[PATH_MAX];
	FILE *in;
	int ret;
	int fd = -1;

	_clip_retni(mp,-1);
	if ( fname==NULL )
		return 0;

	_clip_translate_path(mp, fname, buf, sizeof(buf));

	if (!strcmp(buf, "-|"))
	{			/* stdin */
		fd = dup(0);
		in = fdopen(fd, "rb");
	}
	else
	{
		in = fopen(buf, "rb");
	}

	if ( in==NULL )
	{
		int *err;
		err = _clip_fetch_item(mp, HASH_ferror);
		*err = errno;
		return 0;
	}
	if ( typeFile==0 ) typeFile=1;
	switch ( typeFile )
	{
#ifdef HAVE_LIBPNG
		case GDFILE_PNG:
			im=gdImageCreateFromPng(in);
			break;
#endif
		case GDFILE_GD:
			im=gdImageCreateFromPng(in);
			break;
		case GDFILE_GD2:
			im=gdImageCreateFromPng(in);
			break;
		case GDFILE_XBM:
			im=gdImageCreateFromXbm(in);
		      break;
/*
#ifdef HAVE_LIBXPM
		case GDFILE_XPM:

			im=gdImageCreateFromXpm(buf);
			break;
#endif
*/
#ifdef HAVE_LIBJPEG
		case GDFILE_JPEG:
			im=gdImageCreateFromJpeg(in);
			break;
#endif

	}
	fclose(in);
	if ( im==NULL )
		return 0;
	ret=_clip_store_c_item(mp, (void *)im ,_C_ITEM_TYPE_GDLIB, _clip_destroy_gdImage );
	_clip_retni(mp,ret);
	return 0;
}

int
clip_GDIMAGECREATEFROMPNG(ClipMachine * mp)
{
	return _clip_gdImageFromFile(mp,GDFILE_PNG);
}


int
clip_GDIMAGECREATEFROMXBM(ClipMachine * mp)
{
	return _clip_gdImageFromFile(mp,GDFILE_XBM);
}
int
clip_GDIMAGECREATEFROMGD(ClipMachine * mp)
{
	return _clip_gdImageFromFile(mp,GDFILE_GD);
}

int
clip_GDIMAGECREATEFROMGD2(ClipMachine * mp)
{
	return _clip_gdImageFromFile(mp,GDFILE_GD2);
}

int
clip_GDIMAGECREATEFROMJPEG(ClipMachine * mp)
{
	return _clip_gdImageFromFile(mp,GDFILE_JPEG);
}

int
clip_GDIMAGECREATEFROMFILE(ClipMachine * mp)
{
	int type = _clip_parni(mp,2);
	return _clip_gdImageFromFile(mp,type);
}

static int
_clip_gdImageToFile(ClipMachine * mp, int typeFile)
{
	gdImagePtr im=GETIMAGE(mp);
	char * fname = _clip_parc(mp,2);
	char buf[PATH_MAX];
	FILE *out;
	int fd = -1;

	_clip_retl(mp,0);
	if ( im==NULL || fname==NULL )
		return 0;

	_clip_translate_path(mp, fname, buf, sizeof(buf));


	if (!strcmp(buf, "|-"))
	{			/* stdout */
		fd = dup(1);
		out = fdopen(fd, "wb");
	}
	else
	{
		out = fopen(buf, "wb");
	}

	if ( out==NULL )
	{
		int *err;
		err = _clip_fetch_item(mp, HASH_ferror);
		*err = errno;
		return 0;
	}
	if ( typeFile==0 ) typeFile=1;
	switch (typeFile)
	{
#ifdef HAVE_LIBPNG
		case GDFILE_PNG:
			gdImagePng(im, out);
			break;
#endif
		case GDFILE_GD:
			gdImageGd(im, out);
			break;
		case GDFILE_GD2:
			gdImageGd2(im, out, 0, GD2_FMT_COMPRESSED);
			break;
#ifdef HAVE_LIBJPEG
		case GDFILE_JPEG:
			gdImageJpeg(im, out, -1);
			break;
#endif
	}
	fclose(out);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEPNG(ClipMachine * mp)
{
	return _clip_gdImageToFile(mp,GDFILE_PNG);
}

int
clip_GDIMAGEGD(ClipMachine * mp)
{
	return _clip_gdImageToFile(mp,GDFILE_GD);
}

int
clip_GDIMAGEGD2(ClipMachine * mp)
{
	return _clip_gdImageToFile(mp,GDFILE_GD2);
}


int
clip_GDIMAGEJPEG(ClipMachine * mp)
{
	return _clip_gdImageToFile(mp,GDFILE_JPEG);
}

int
clip_GDIMAGETOFILE(ClipMachine * mp)
{
	int type = _clip_parni(mp,3);
	return _clip_gdImageToFile(mp,type);
}

int
clip_GDIMAGEDESTROY(ClipMachine * mp)
{
	int nImage = _clip_parni(mp,1);

	_clip_retl(mp,0);
	if ( _clip_parinfo(mp,1) == NUMERIC_t )
	{
		_clip_destroy_c_item(mp,nImage,_C_ITEM_TYPE_GDLIB);
		_clip_retl(mp,1);
	}
	return 0;
}


int
clip_GDCOLORCREATE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int r = _clip_parni(mp,2);
	int g = _clip_parni(mp,3);
	int b = _clip_parni(mp,4);
	int ret;

	_clip_retni(mp, -1);
	if ( im == NULL )
		return 0;
	ret= gdImageColorExact(im,r,g,b);
	if (ret<0)
	    ret= gdImageColorAllocate(im,r,g,b);
	if (ret<0)
	    ret=(long)gdImageColorClosest(im,r,g,b);
	_clip_retni(mp,ret);
	return 0;
}

int
clip_GDCOLORTRANSPARENT(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int t = _clip_parni(mp,2);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageColorTransparent(im,t);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEINTERLACE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int t = _clip_parni(mp,2);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageInterlace(im,t);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDCOLORINFO(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int info  = _clip_parni(mp,2);
	int color = _clip_parni(mp,3);
	int ret=-1;

	switch ( info )
	{
		case GDINFO_COLORSTOTAL:
			ret = gdImageColorsTotal(im);
			break ;
		case GDINFO_TRANSPARENT:
			ret = gdImageGetTransparent(im);
			break ;
		case GDINFO_INTERLACED:
			ret = gdImageGetInterlaced(im);
			break ;
		case GDINFO_COLORRED:
			ret = gdImageRed(im,color);
			break ;
		case GDINFO_COLORGREEN:
			ret = gdImageGreen(im,color);
			break ;
		case GDINFO_COLORBLUE:
			ret = gdImageBlue(im,color);
			break ;
		case GDINFO_SIZEX:
			ret = gdImageSX(im);
			break ;
		case GDINFO_SIZEY:
			ret = gdImageSY(im);
			break ;
	}
	_clip_retni(mp,ret);
	return 0;
}

int
clip_GDFONTINFO(ClipMachine * mp)
{
	int info  = _clip_parni(mp,1);
	int fnumb = _clip_parni(mp,2);
	int ret=-1;
	gdFontPtr font;
	switch ( info )
	{
		case GDINFO_FONT_WIDTH:
			font = gdSelectFont(fnumb);
			ret = font->w;
			break;
		case GDINFO_FONT_HIGH:
			font = gdSelectFont(fnumb);
			ret = font->h;
			break;
	}
	_clip_retni(mp,ret);
	return 0;
}

int
clip_GDIMAGECOMPARE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	gdImagePtr im2=NULL;
	int nImage = _clip_parni(mp,2);

	if ( _clip_parinfo(mp,2) == NUMERIC_t )
	{
		im2=_clip_fetch_c_item(mp,nImage,_C_ITEM_TYPE_GDLIB);
	}

	_clip_retni(mp, -99);
	if ( im == NULL || im2==NULL )
		return 0;
	_clip_retl(mp,gdImageCompare(im,im2));
	return 0;
}

int
clip_GDIMAGEGETPIXEL(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x = _clip_parni(mp,2);
	int y = _clip_parni(mp,3);

	_clip_retni(mp, -1);
	if ( im == NULL )
		return 0;
	_clip_retni(mp,gdImageGetPixel(im,x,y));
	return 0;
}

int
clip_GDIMAGESETPIXEL(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x = _clip_parni(mp,2);
	int y = _clip_parni(mp,3);
	int color = _clip_parni(mp,4);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageSetPixel(im,x,y,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEBOUNDSSAFE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x = _clip_parni(mp,2);
	int y = _clip_parni(mp,3);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	_clip_retl(mp,gdImageBoundsSafe(im,x,y));
	return 0;
}

int
clip_GDIMAGELINE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x1 = _clip_parni(mp,2);
	int y1 = _clip_parni(mp,3);
	int x2 = _clip_parni(mp,4);
	int y2 = _clip_parni(mp,5);
	int color = _clip_parni(mp,6);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageLine(im,x1,y1,x2,y2,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEDASHEDLINE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x1 = _clip_parni(mp,2);
	int y1 = _clip_parni(mp,3);
	int x2 = _clip_parni(mp,4);
	int y2 = _clip_parni(mp,5);
	int color = _clip_parni(mp,6);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageDashedLine(im,x1,y1,x2,y2,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGERECTANGLE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x1 = _clip_parni(mp,2);
	int y1 = _clip_parni(mp,3);
	int x2 = _clip_parni(mp,4);
	int y2 = _clip_parni(mp,5);
	int color = _clip_parni(mp,6);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageRectangle(im,x1,y1,x2,y2,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEFILLEDRECTANGLE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x1 = _clip_parni(mp,2);
	int y1 = _clip_parni(mp,3);
	int x2 = _clip_parni(mp,4);
	int y2 = _clip_parni(mp,5);
	int color = _clip_parni(mp,6);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageFilledRectangle(im,x1,y1,x2,y2,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEARC(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int cx = _clip_parni(mp,2);
	int cy = _clip_parni(mp,3);
	int w  = _clip_parni(mp,4);
	int h  = _clip_parni(mp,5);
	int s  = _clip_parni(mp,6);
	int e  = _clip_parni(mp,7);
	int color = _clip_parni(mp,8);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageArc(im,cx,cy,w,h,s,e,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEFILLEDARC(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int cx = _clip_parni(mp,2);
	int cy = _clip_parni(mp,3);
	int w  = _clip_parni(mp,4);
	int h  = _clip_parni(mp,5);
	int color = _clip_parni(mp,6);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageArc(im,cx,cy,w,h,0,360,color);
	gdImageFillToBorder(im,cx,cy,color,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEFILLTOBORDER(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x = _clip_parni(mp,2);
	int y = _clip_parni(mp,3);
	int b = _clip_parni(mp,4);
	int color = _clip_parni(mp,5);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageFillToBorder(im,x,y,b,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEFILL(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	int x = _clip_parni(mp,2);
	int y = _clip_parni(mp,3);
	int color = _clip_parni(mp,4);

	_clip_retl(mp, 0);
	if ( im == NULL )
		return 0;
	gdImageFill(im,x,y,color);
	_clip_retl(mp,1);
	return 0;
}

static int
_clip_gdPolygon(ClipMachine * mp, int fill)
{
	gdImagePtr im=GETIMAGE(mp);
	ClipVar *ap = _clip_par(mp, 2);
	int i,color = _clip_parni(mp,3);
	ClipVar *item, *citem;
	gdPointPtr points;
	int x,y;

	_clip_retl(mp, 0);
	if ( im == NULL || !ap || ap->t.type != ARRAY_t )
		return 0;
	points = malloc ( sizeof(gdPoint) * ap->a.count );
	for (i=0; i<ap->a.count; i++)
	{
		item = ap->a.items + i;
		x=0; y=0;
		if ( item->t.type != ARRAY_t )
			continue;
		item = _clip_vptr(item);
		/* x coordinate */
		if ( item->a.count>0 )
		{
			citem = item->a.items + 0 ;
			if ( citem->t.type == NUMERIC_t )
				x=(int)_clip_double(citem);
		}
		/* y coordinate */
		if ( item->a.count>1 )
		{
			citem = item->a.items + 1 ;
			if ( citem->t.type == NUMERIC_t )
				y=(int)_clip_double(citem);
		}
		points[i].x=x;
		points[i].y=y;
	}
	if ( fill )
		gdImageFilledPolygon(im,points,ap->a.count,color);
	else
		gdImagePolygon(im,points,ap->a.count,color);
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGEPOLYGON(ClipMachine * mp)
{
	_clip_gdPolygon(mp,0);
	return 0;
}

int
clip_GDIMAGEFILLEDPOLYGON(ClipMachine * mp)
{
	_clip_gdPolygon(mp,1);
	return 0;
}


static int
_clip_gdSector(ClipMachine * mp, int type)
{
	gdImagePtr im=GETIMAGE(mp);
	int cx = _clip_parni(mp,2);
	int cy = _clip_parni(mp,3);
	int w  = _clip_parni(mp,4);
	int h  = _clip_parni(mp,5);
	int s  = _clip_parni(mp,6);
	int e  = _clip_parni(mp,7);
	int color = _clip_parni(mp,8);

	_clip_retl(mp,0);
	if ( im == NULL )
		return 0;

	switch ( type )
	{
		case 0:
			gdImageSector(im, cx, cy, w, h, s, e, color);
			break;
		case 1:
			gdImageFilledSector(im, cx, cy, w, h, s, e, color);
			break;
	}
	_clip_retl(mp,1);
	return 0;
}

static int
_clip_gdTruncSector(ClipMachine * mp, int type)
{
	gdImagePtr im=GETIMAGE(mp);
	int cx = _clip_parni(mp,2);
	int cy = _clip_parni(mp,3);
	int w  = _clip_parni(mp,4);
	int h  = _clip_parni(mp,5);
	int we  = _clip_parni(mp,6);
	int he  = _clip_parni(mp,7);
	int s  = _clip_parni(mp,8);
	int e  = _clip_parni(mp,9);
	int color = _clip_parni(mp,10);

	_clip_retl(mp,0);
	if ( im == NULL )
		return 0;

	switch ( type )
	{
		case 2:
			gdImageTruncSector(im, cx, cy, w, h, we, he, s, e, color);
			break;
		case 3:
			gdImageFilledTruncSector(im, cx, cy, w, h, we, he, s, e, color);
			break;
	}
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGESECTOR(ClipMachine * mp)
{
	_clip_gdSector(mp,0);
	return 0;
}

int
clip_GDIMAGEFILLEDSECTOR(ClipMachine * mp)
{
	_clip_gdSector(mp,1);
	return 0;
}

int
clip_GDIMAGETRUNCSECTOR(ClipMachine * mp)
{
	_clip_gdTruncSector(mp,2);
	return 0;
}

int
clip_GDIMAGEFILLEDTRUNCSECTOR(ClipMachine * mp)
{
	_clip_gdTruncSector(mp,3);
	return 0;
}


static int
_clip_gdSetImage(ClipMachine * mp, int type)
{
	gdImagePtr im=GETIMAGE(mp);
	gdImagePtr im2=NULL;
	int nImage = _clip_parni(mp,2);

	if ( _clip_parinfo(mp,2) == NUMERIC_t )
	{
		im2=_clip_fetch_c_item(mp,nImage,_C_ITEM_TYPE_GDLIB);
	}

	_clip_retl(mp, 0);
	if ( im == NULL || im2==NULL )
		return 0;
	if ( type == 0 )
		gdImageSetBrush(im,im2);
	if ( type == 1 )
		gdImageSetTile(im,im2);

	_clip_retl(mp, 1);
	return 0;
}

int
clip_GDIMAGESETBRUSH(ClipMachine * mp)
{
	_clip_gdSetImage(mp,0);
	return 0;
}

int
clip_GDIMAGESETTILE(ClipMachine * mp)
{
	_clip_gdSetImage(mp,1);
	return 0;
}

int
clip_GDIMAGESETSTYLE(ClipMachine * mp)
{
	gdImagePtr im=GETIMAGE(mp);
	ClipVar *ap = _clip_par(mp, 2);
	ClipVar *item;
	int * points,i;

	_clip_retl(mp, 0);
	if ( im == NULL || !ap || ap->t.type != ARRAY_t )
		return 0;
	points = malloc ( sizeof(int) * ap->a.count );
	for (i=0; i<ap->a.count; i++)
	{
		item = ap->a.items + i;
		item = _clip_vptr(item);
		points[i]=(int)_clip_double(item);
	}
	gdImageSetStyle(im,points,ap->a.count);
	_clip_retl(mp,1);
	return 0;
}


static int
_clip_gdPutChar(ClipMachine * mp, int type)
{
	gdImagePtr im=GETIMAGE(mp);
	char * str = _clip_parc(mp,2);
	int x = _clip_parni(mp,3);
	int y = _clip_parni(mp,4);
	int color = _clip_parni(mp,5);
	int font = _clip_parni(mp,6);
	int ugol = _clip_parni(mp,7);
	gdFontPtr  f = gdSelectFont(font);

	_clip_retl(mp, 0);
	if ( im == NULL || str==NULL )
		return 0;
	switch ( type )
	{
		case 0:
			gdImageChar(im,f,x,y,*str,color);
			break;
		case 1:
			gdImageCharUp(im,f,x,y,*str,color);
			break;
		case 2:
			gdImageString(im,f,x,y,(unsigned char *)str,color);
			break;
		case 3:
			gdImageString16(im,f,x,y,(unsigned short *)str,color);
			break;
		case 4:
			gdImageStringUp(im,f,x,y,(unsigned char *)str,color);
			break;
		case 5:
			gdImageStringUp16(im,f,x,y,(unsigned short *)str,color);
			break;
		case 6:
			gdImageCharRotate(im,f,x,y,*str,ugol,color);
			break;
		case 7:
			gdImageStringRotate(im,f,x,y, (unsigned char *)str,ugol,color);
			break;
	}
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGECHAR(ClipMachine * mp)
{
	return _clip_gdPutChar(mp,0);
}

int
clip_GDIMAGECHARUP(ClipMachine * mp)
{
	return _clip_gdPutChar(mp,1);
}

int
clip_GDIMAGECHARROTATE(ClipMachine * mp)
{
	return _clip_gdPutChar(mp,6);
}

int
clip_GDIMAGESTRING(ClipMachine * mp)
{
	return _clip_gdPutChar(mp,2);
}

int
clip_GDIMAGESTRINGUP(ClipMachine * mp)
{
	return _clip_gdPutChar(mp,4);
}

int
clip_GDIMAGESTRINGROTATE(ClipMachine * mp)
{
	return _clip_gdPutChar(mp,7);
}

typedef struct {
	int X;
	int Y;
	char Nach;
} koord;
typedef struct {
	char Num;
	int len;
	koord *Mass;
	int W;
	int H;
} font;

const koord var0[]={
{   0,   5, 1},
{   0,   0, 0},
{   5,   0, 0},
{   5,   5, 0},
{   0,   5, 0},
{   0,  11, 1},
{   0,  38, 0},
{   5,  38, 0},
{   5,  11, 0},
{   0,  11, 0}};

const koord var1[]={
{   0,  11, 1},
{   5,   5, 0},
{   5,   0, 0},
{   0,   0, 0},
{   0,   5, 0},
{   5,   5, 0},
{  11,  11, 1},
{  16,   5, 0},
{  16,   0, 0},
{  11,   0, 0},
{  11,   5, 0},
{  16,   5, 0}};

const koord var2[]={
{   0,  22, 1},
{  22,  22, 0},
{   5,  22, 0},
{   5,  33, 0},
{   5,   0, 0},
{   5,  11, 0},
{   0,  11, 0},
{  22,  11, 0},
{  16,  11, 0},
{  16,   0, 0},
{  16,  33, 0}};

const koord var3[]={
{   0,   5, 1},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  16, 0},
{  16,  22, 0},
{   5,  22, 0},
{   0,  27, 0},
{   0,  33, 0},
{   5,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  11,  38, 1},
{  11,   0, 0}};

const koord var4[]={
{   5,  33, 1},
{   0,  33, 0},
{   0,  38, 0},
{   5,  38, 0},
{   5,  33, 0},
{  22,  38, 1},
{   0,   0, 0},
{  16,   5, 1},
{  22,   5, 0},
{  22,   0, 0},
{  16,   0, 0},
{  16,   5, 0}};

const koord var5[]={
{  22,   0, 1},
{   5,  27, 0},
{   5,  33, 0},
{  11,  38, 0},
{  16,  33, 0},
{  16,  27, 0},
{   0,  16, 0},
{   0,  11, 0},
{   5,   5, 0},
{  11,   5, 0},
{  22,  11, 0}};

const koord var6[]={
{   5,  11, 1},
{   0,   5, 0},
{   0,   0, 0},
{   5,   0, 0},
{   5,   5, 0},
{   0,   5, 0}};

const koord var7[]={
{   5,   0, 1},
{   0,   5, 0},
{   0,  33, 0},
{   5,  38, 0}};

const koord var8[]={
{   0,   0, 1},
{   5,   5, 0},
{   5,  33, 0},
{   0,  38, 0}};

const koord var9[]={
{   5,   0, 1},
{  16,  22, 0},
{   5,  22, 1},
{  16,   0, 0},
{  22,  11, 1},
{   0,  11, 0}};

const koord var10[]={
{   0,  11, 1},
{  22,  11, 0},
{  11,   0, 1},
{  11,  22, 0}};

const koord var11[]={
{   5,   0, 1},
{   0,   0, 0},
{   0,   5, 0},
{   5,   5, 0},
{   5,   0, 0},
{   0,  -5, 0}};

const koord var12[]={
{   0,  22, 1},
{  22,  22, 0}};

const koord var13[]={
{   0,   0, 1},
{   0,   5, 0},
{   5,   5, 0},
{   5,   0, 0},
{   0,   0, 0}};

const koord var14[]={
{   0,   0, 1},
{  22,  38, 0}};

const koord var15[]={
{   5,   0, 1},
{   0,  11, 0},
{   0,  27, 0},
{   5,  38, 0},
{  16,  38, 0},
{  22,  27, 0},
{  22,  11, 0},
{  16,   0, 0},
{   5,   0, 0}};

const koord var16[]={
{   0,   0, 1},
{  11,   0, 0},
{   5,   0, 0},
{   5,  38, 0},
{   0,  33, 0}};

const koord var17[]={
{   0,  33, 1},
{   5,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  22,  22, 0},
{   0,   5, 0},
{   0,   0, 0},
{  22,   0, 0}};

const koord var18[]={
{   0,  38, 1},
{  22,  38, 0},
{  11,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0}};

const koord var19[]={
{  11,  38, 1},
{   0,  11, 0},
{  22,  11, 0},
{  16,  22, 1},
{  16,   0, 0}};

const koord var20[]={
{  22,  38, 1},
{   0,  38, 0},
{   0,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0}};

const koord var21[]={
{  22,  33, 1},
{  16,  38, 0},
{   5,  38, 0},
{   0,  33, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  16, 0},
{  16,  22, 0},
{   5,  22, 0},
{   0,  16, 0}};

const koord var22[]={
{   0,  33, 1},
{   0,  38, 0},
{  22,  38, 0},
{  22,  33, 0},
{   5,   5, 0},
{   5,   0, 0}};

const koord var23[]={
{   5,  22, 1},
{   0,  27, 0},
{   0,  33, 0},
{   5,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  22,  27, 0},
{  16,  22, 0},
{   5,  22, 0},
{   0,  16, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  16, 0},
{  16,  22, 0}};

const koord var24[]={
{   0,   5, 1},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  33, 0},
{  16,  38, 0},
{   5,  38, 0},
{   0,  33, 0},
{   0,  22, 0},
{   5,  16, 0},
{  16,  16, 0},
{  22,  22, 0}};

const koord var25[]={
{   0,   0, 1},
{   0,   5, 0},
{   5,   5, 0},
{   5,   0, 0},
{   0,   0, 0},
{   0,  22, 1},
{   0,  27, 0},
{   5,  27, 0},
{   5,  22, 0},
{   0,  22, 0}};

const koord var26[]={
{   5,   5, 1},
{   0,   5, 0},
{   0,  11, 0},
{   5,  11, 0},
{   5,   5, 0},
{   0,   0, 0},
{   0,  27, 1},
{   0,  33, 0},
{   5,  33, 0},
{   5,  27, 0},
{   0,  27, 0}};

const koord var27[]={
{  22,   0, 1},
{   0,  11, 0},
{  22,  22, 0}};

const koord var28[]={
{   0,  11, 1},
{  22,  11, 0},
{  22,   0, 1},
{   0,   0, 0}};

const koord var29[]={
{   0,   0, 1},
{  22,  11, 0},
{   0,  22, 0}};

const koord var30[]={
{  16,   0, 1},
{   5,   0, 0},
{   5,   5, 0},
{  16,   5, 0},
{  16,   0, 0},
{  11,  11, 1},
{  11,  22, 0},
{  16,  22, 0},
{  22,  27, 0},
{  22,  33, 0},
{  16,  38, 0},
{   5,  38, 0},
{   0,  33, 0}};

const koord var31[]={
{  22,   5, 1},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  22, 0},
{   5,  27, 0},
{  16,  27, 0},
{  22,  22, 0},
{  22,  11, 0},
{  16,   5, 0},
{  16,  22, 0},
{  11,  22, 0},
{   5,  16, 0},
{   5,  11, 0},
{  11,   5, 0},
{  16,  11, 0}};

const koord var32[]={
{   0,   0, 1},
{   0,  33, 0},
{   5,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  22,   0, 0},
{  22,  16, 0},
{   0,  16, 0}};

const koord var33[]={
{   0,   0, 1},
{   0,  38, 0},
{  16,  38, 0},
{   0,  22, 1},
{  16,  22, 0},
{  22,  27, 0},
{  22,  33, 0},
{  16,  38, 0},
{  16,  22, 1},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   0,   0, 0}};

const koord var34[]={
{  22,  33, 1},
{  16,  38, 0},
{   5,  38, 0},
{   0,  33, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0}};

const koord var35[]={
{   0,   0, 1},
{   0,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  22,   5, 0},
{  16,   0, 0},
{   0,   0, 0}};

const koord var36[]={
{  22,   0, 1},
{   0,   0, 0},
{   0,  22, 0},
{  16,  22, 0},
{   0,  22, 0},
{   0,  38, 0},
{  22,  38, 0}};

const koord var37[]={
{   0,   0, 1},
{   0,  38, 0},
{  16,  38, 0},
{   0,  22, 1},
{  16,  22, 0}};

const koord var38[]={
{  22,  33, 1},
{  16,  38, 0},
{   5,  38, 0},
{   0,  33, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  16, 0},
{  16,  16, 0}};

const koord var39[]={
{   0,   0, 1},
{   0,  38, 0},
{   0,  22, 0},
{  22,  22, 0},
{  22,  38, 0},
{  22,   0, 0}};

const koord var40[]={
{   0,   0, 1},
{  11,   0, 0},
{   5,   0, 0},
{   5,  38, 0},
{   0,  38, 0},
{  11,  38, 0}};

const koord var41[]={
{  22,  38, 1},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  11, 0}};

const koord var42[]={
{   0,   0, 1},
{   0,  38, 0},
{   0,  16, 0},
{  22,  38, 0},
{   5,  22, 0},
{  22,   0, 0}};

const koord var43[]={
{  22,   0, 1},
{   0,   0, 0},
{   0,  38, 0}};

const koord var44[]={
{   0,   0, 1},
{   0,  38, 0},
{  11,  22, 0},
{  22,  38, 0},
{  22,   0, 0}};

const koord var45[]={
{   0,   0, 1},
{   0,  38, 0},
{  22,   0, 0},
{  22,  38, 0}};

const koord var46[]={
{   5,  38, 1},
{   0,  33, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  33, 0},
{  16,  38, 0},
{   5,  38, 0}};

const koord var47[]={
{   0,   0, 1},
{   0,  38, 0},
{  16,  38, 0},
{   0,  22, 1},
{  16,  22, 0},
{  22,  27, 0},
{  22,  33, 0},
{  16,  38, 0}};

const koord var48[]={
{   5,  38, 1},
{   0,  33, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  33, 0},
{  16,  38, 0},
{   5,  38, 0},
{  16,   5, 1},
{  22,   0, 0}};

const koord var49[]={
{   0,   0, 1},
{   0,  22, 0},
{  16,  22, 0},
{   0,  22, 0},
{   0,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  22,  27, 0},
{  16,  22, 0},
{  11,  22, 0},
{  22,   0, 0}};

const koord var50[]={
{   0,   5, 1},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  16, 0},
{  16,  22, 0},
{   5,  22, 0},
{   0,  27, 0},
{   0,  33, 0},
{   5,  38, 0},
{  16,  38, 0},
{  22,  33, 0}};

const koord var51[]={
{   0,  38, 1},
{  22,  38, 0},
{  11,  38, 0},
{  11,   0, 0}};

const koord var52[]={
{  22,  38, 1},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  11, 0},
{   0,  38, 0}};

const koord var53[]={
{   0,  38, 1},
{  11,   0, 0},
{  22,  38, 0}};

const koord var54[]={
{   0,  38, 1},
{   0,   0, 0},
{  11,  16, 0},
{  22,   0, 0},
{  22,  38, 0}};

const koord var55[]={
{   0,   0, 1},
{  22,  38, 0},
{   0,  38, 1},
{  22,   0, 0}};

const koord var56[]={
{   0,  38, 1},
{  11,  22, 0},
{  11,   0, 0},
{  11,  22, 0},
{  22,  38, 0}};

const koord var57[]={
{   0,  38, 1},
{  22,  38, 0},
{   0,   0, 0},
{  22,   0, 0},
{   5,  22, 1},
{  16,  22, 0}};

const koord var58[]={
{  11,   0, 1},
{   0,   0, 0},
{   0,  38, 0},
{  11,  38, 0}};

const koord var59[]={
{   0,  38, 1},
{  22,   0, 0}};

const koord var60[]={
{   0,   0, 1},
{  11,   0, 0},
{  11,  38, 0},
{   0,  38, 0}};

const koord var61[]={
{   0,   0, 1},
{  11,  22, 0},
{  22,   0, 0}};

const koord var62[]={
{   0,   0, 1},
{  22,   0, 0}};

const koord var63[]={
{   0,  11, 1},
{   5,   5, 0},
{   5,   0, 0},
{   0,   0, 0},
{   0,   5, 0},
{   5,   5, 0}};

const koord var64[]={
{   0,  16, 1},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   5,  11, 0},
{  22,  11, 0},
{  22,   0, 0}};

const koord var65[]={
{   0,  16, 1},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  33, 0}};

const koord var66[]={
{  22,   5, 1},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0}};

const koord var67[]={
{  22,  16, 1},
{  16,  22, 0},
{   5,  22, 0},
{   0,  16, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,   0, 0},
{  22,  33, 0}};

const koord var68[]={
{  22,   5, 1},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,  11, 0},
{   0,  11, 0}};

const koord var69[]={
{   5,   0, 1},
{   5,  22, 0},
{   0,  22, 0},
{  16,  22, 0},
{   5,  22, 0},
{   5,  27, 0},
{  11,  33, 0},
{  16,  33, 0}};

const koord var70[]={
{   0,   5, 1},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  27, 0},
{  16,  33, 0},
{   5,  33, 0},
{   0,  27, 0},
{   0,  16, 0},
{   5,  11, 0},
{  16,  11, 0},
{  22,  16, 0},
{  22,  33, 0}};

const koord var71[]={
{   0,   0, 1},
{   0,  22, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   0, 0},
{   0,  22, 1},
{   0,  33, 0}};

const koord var72[]={
{   0,   0, 1},
{   0,  22, 0},
{   0,  27, 1},
{   0,  33, 0}};

const koord var73[]={
{   0,   0, 1},
{   5,   5, 0},
{   5,  27, 0},
{   5,  33, 1},
{   5,  38, 0}};

const koord var74[]={
{   0,   0, 1},
{   0,  33, 0},
{   0,  11, 0},
{  16,  22, 0},
{   0,  11, 0},
{  16,   0, 0}};

const koord var75[]={
{  11,   0, 1},
{   5,   0, 0},
{   0,   5, 0},
{   0,  33, 0}};

const koord var76[]={
{   0,   0, 1},
{   0,  22, 0},
{   0,  16, 0},
{   5,  22, 0},
{  11,  22, 0},
{  11,   0, 0},
{  11,  16, 0},
{  16,  22, 0},
{  22,  22, 0},
{  22,   0, 0}};

const koord var77[]={
{   0,   0, 1},
{   0,  22, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   0, 0}};

const koord var78[]={
{   0,  16, 1},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0}};

const koord var79[]={
{   0,  27, 1},
{   5,  33, 0},
{  16,  33, 0},
{  22,  27, 0},
{  22,  16, 0},
{  16,  11, 0},
{   5,  11, 0},
{   0,  16, 0},
{   0,  27, 0},
{   0,  33, 0},
{   0,   0, 0}};

const koord var80[]={
{  22,  16, 1},
{  16,  11, 0},
{   5,  11, 0},
{   0,  16, 0},
{   0,  27, 0},
{   5,  33, 0},
{  16,  33, 0},
{  22,  27, 0},
{  22,  33, 0},
{  22,   0, 0}};

const koord var81[]={
{   0,   0, 1},
{   0,  22, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0}};

const koord var82[]={
{   0,   5, 1},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  16,  11, 0},
{   5,  11, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0}};

const koord var83[]={
{  16,   0, 1},
{  11,   0, 0},
{   5,   5, 0},
{   5,  33, 0},
{   5,  22, 0},
{   0,  22, 0},
{  11,  22, 0}};

const koord var84[]={
{   0,  22, 1},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,   0, 0},
{  22,  22, 0}};

const koord var85[]={
{   0,  22, 1},
{  11,   0, 0},
{  22,  22, 0}};

const koord var86[]={
{   0,  22, 1},
{   5,   0, 0},
{  11,  11, 0},
{  16,   0, 0},
{  22,  22, 0}};

const koord var87[]={
{   0,   0, 1},
{  22,  22, 0},
{  11,  11, 0},
{   0,  22, 0},
{  22,   0, 0}};

const koord var88[]={
{   0,  22, 1},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  22, 0},
{  22,  -5, 0},
{  16, -11, 0},
{   5, -11, 0}};

const koord var89[]={
{   0,  22, 1},
{  22,  22, 0},
{   0,   0, 0},
{  22,   0, 0}};

const koord var90[]={
{  11,   0, 1},
{   5,   5, 0},
{   5,  16, 0},
{   0,  22, 0},
{   5,  27, 0},
{   5,  38, 0},
{  11,  44, 0}};

const koord var91[]={
{   0,   0, 1},
{   0,  38, 0}};

const koord var92[]={
{   0,   0, 1},
{   5,   5, 0},
{   5,  16, 0},
{  11,  22, 0},
{   5,  27, 0},
{   5,  38, 0},
{   0,  44, 0}};

const koord var93[]={
{   0,   5, 1},
{   5,  11, 0},
{  22,   0, 0},
{  27,   5, 0}};

const koord var94[]={
{   0,   0, 1},
{   0,  33, 0},
{   5,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  22,   0, 0},
{  22,  16, 0},
{   0,  16, 0}};

const koord var95[]={
{   0,  22, 1},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   0,   0, 0},
{   0,  38, 0},
{  22,  38, 0}};

const koord var96[]={
{   0,   0, 1},
{   0,  38, 0},
{  16,  38, 0},
{   0,  22, 1},
{  16,  22, 0},
{  22,  27, 0},
{  22,  33, 0},
{  16,  38, 0},
{  16,  22, 1},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   0,   0, 0}};

const koord var97[]={
{   0,   0, 1},
{   0,  38, 0},
{  22,  38, 0},
{  22,  33, 0}};

const koord var98[]={
{   0,  -5, 1},
{   0,   0, 0},
{  27,   0, 0},
{  27,  -5, 0},
{  27,   0, 0},
{  22,   0, 0},
{  22,  38, 0},
{  11,  38, 0},
{   5,   0, 0}};

const koord var99[]={
{  22,   0, 1},
{   0,   0, 0},
{   0,  22, 0},
{  16,  22, 0},
{   0,  22, 0},
{   0,  38, 0},
{  22,  38, 0}};

const koord var100[]={
{   0,   0, 1},
{  22,  38, 0},
{   0,  38, 1},
{  22,   0, 0},
{  11,  38, 1},
{  11,   0, 0}};

const koord var101[]={
{   0,  33, 1},
{   5,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  22,  27, 0},
{  16,  22, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0}};

const koord var102[]={
{   0,  38, 1},
{   0,   0, 0},
{  22,  38, 0},
{  22,   0, 0}};

const koord var103[]={
{   0,  38, 1},
{   0,   0, 0},
{  22,  38, 0},
{  22,   0, 0},
{   5,  38, 1},
{  16,  38, 0}};

const koord var104[]={
{   0,   0, 1},
{   0,  38, 0},
{   0,  16, 0},
{  22,  38, 0},
{   5,  22, 0},
{  22,   0, 0}};

const koord var105[]={
{   0,   0, 1},
{  11,  38, 0},
{  22,  38, 0},
{  22,   0, 0}};

const koord var106[]={
{   0,   0, 1},
{   0,  38, 0},
{  11,  22, 0},
{  22,  38, 0},
{  22,   0, 0}};

const koord var107[]={
{   0,   0, 1},
{   0,  38, 0},
{   0,  22, 0},
{  22,  22, 0},
{  22,  38, 0},
{  22,   0, 0}};

const koord var108[]={
{   5,  38, 1},
{   0,  33, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  33, 0},
{  16,  38, 0},
{   5,  38, 0}};

const koord var109[]={
{   0,   0, 1},
{   0,  38, 0},
{  22,  38, 0},
{  22,  33, 0},
{  22,   0, 0}};

const koord var110[]={
{   0,   0, 1},
{   0,  38, 0},
{  16,  38, 0},
{   0,  22, 1},
{  16,  22, 0},
{  22,  27, 0},
{  22,  33, 0},
{  16,  38, 0}};

const koord var111[]={
{  22,  33, 1},
{  16,  38, 0},
{   5,  38, 0},
{   0,  33, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0}};

const koord var112[]={
{   0,  38, 1},
{  22,  38, 0},
{  11,  38, 0},
{  11,   0, 0}};

const koord var113[]={
{   0,  38, 1},
{   0,  16, 0},
{   5,  11, 0},
{  16,  11, 0},
{  22,  16, 0},
{  22,  38, 0},
{  22,   5, 0},
{  16,   0, 0},
{   0,   0, 0}};

const koord var114[]={
{  11,   0, 1},
{  11,  33, 0},
{   5,  33, 0},
{   0,  27, 0},
{   0,  16, 0},
{   5,  11, 0},
{  16,  11, 0},
{  22,  16, 0},
{  22,  27, 0},
{  16,  33, 0},
{  11,  33, 0},
{  11,  38, 0}};

const koord var115[]={
{   0,   0, 1},
{  22,  38, 0},
{   0,  38, 1},
{  22,   0, 0}};

const koord var116[]={
{   0,  38, 1},
{   0,   0, 0},
{  22,   0, 0},
{  22,  38, 0},
{  22,   0, 0},
{  27,   0, 0},
{  27,  -5, 0}};

const koord var117[]={
{   0,  38, 1},
{   0,  22, 0},
{   5,  16, 0},
{  22,  16, 0},
{  22,  38, 0},
{  22,   0, 0}};

const koord var118[]={
{   0,  38, 1},
{   0,   0, 0},
{  11,   0, 0},
{  11,  38, 0},
{  11,   0, 0},
{  22,   0, 0},
{  22,  38, 0}};

const koord var119[]={
{   0,  38, 1},
{   0,   0, 0},
{  11,   0, 0},
{  11,  38, 0},
{  11,   0, 0},
{  22,   0, 0},
{  22,  38, 0},
{  22,   0, 0},
{  27,   0, 0},
{  27,  -5, 0}};

const koord var120[]={
{   0,  38, 1},
{   5,  38, 0},
{   5,   0, 0},
{  22,   0, 0},
{  27,   5, 0},
{  27,  16, 0},
{  22,  22, 0},
{   5,  22, 0}};

const koord var121[]={
{   0,  38, 1},
{   0,   5, 0},
{   5,   0, 0},
{  11,   0, 0},
{  16,   5, 0},
{  16,  16, 0},
{  16,  22, 0},
{   0,  22, 0},
{  22,  38, 1},
{  22,   0, 0}};

const koord var122[]={
{   0,  22, 1},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   0,   0, 0},
{   0,  38, 0}};

const koord var123[]={
{   0,   0, 1},
{  16,   0, 0},
{  22,   5, 0},
{  22,  22, 0},
{   5,  22, 0},
{  22,  22, 0},
{  22,  33, 0},
{  16,  38, 0},
{   0,  38, 0}};

const koord var124[]={
{   0,   0, 1},
{   0,  38, 0},
{   0,  22, 0},
{   5,  22, 0},
{   5,  33, 0},
{  11,  38, 0},
{  16,  38, 0},
{  22,  33, 0},
{  22,   5, 0},
{  16,   0, 0},
{  11,   0, 0},
{   5,   5, 0},
{   5,  22, 0}};

const koord var125[]={
{  22,   0, 1},
{  22,  38, 0},
{   5,  38, 0},
{   0,  33, 0},
{   0,  22, 0},
{   5,  16, 0},
{  22,  16, 0},
{  11,  16, 0},
{   0,   0, 0}};

const koord var126[]={
{  27,   0, 1},
{  22,   0, 0},
{  22,  22, 0},
{  22,  16, 0},
{  16,  22, 0},
{   5,  22, 0},
{   0,  16, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0}};

const koord var127[]={
{  16,  22, 1},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{   0,  27, 0},
{   5,  33, 0},
{  22,  33, 0}};

const koord var128[]={
{  16,   0, 1},
{  22,   5, 0},
{  22,  11, 0},
{  16,  16, 0},
{   5,  16, 0},
{   0,  11, 0},
{  11,  27, 0},
{   5,  33, 0},
{   0,  33, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0}};

const koord var129[]={
{   0,  16, 1},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0}};

const koord var130[]={
{  22,  16, 1},
{  16,  22, 0},
{   5,  22, 0},
{   0,  16, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  27, 0},
{  16,  33, 0},
{   5,  33, 0}};

const koord var131[]={
{  22,   5, 1},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,  11, 0},
{   0,  11, 0}};

const koord var132[]={
{   0,  22, 1},
{  22,   0, 0},
{   0,   0, 1},
{  22,  22, 0},
{  11,   0, 1},
{  11,  22, 0}};

const koord var133[]={
{   0,  16, 1},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  16,  11, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{  11,  11, 1},
{  16,  11, 0}};

const koord var134[]={
{   0,  22, 1},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,   0, 0},
{  22,  22, 0}};

const koord var135[]={
{   0,  22, 1},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,   0, 0},
{  22,  22, 0},
{  16,  27, 1},
{   5,  27, 0}};

const koord var136[]={
{   0,   0, 1},
{   0,  22, 0},
{  16,  22, 1},
{   0,  11, 0},
{  16,   0, 0}};

const koord var137[]={
{   0,   0, 1},
{   5,  16, 0},
{  11,  22, 0},
{  16,  22, 0},
{  16,   0, 0}};

const koord var138[]={
{   0,   0, 1},
{   0,  22, 0},
{  11,  11, 0},
{  22,  22, 0},
{  22,   0, 0}};

const koord var139[]={
{   0,   0, 1},
{   0,  22, 0},
{   0,  11, 1},
{  16,  11, 0},
{  16,  22, 1},
{  16,   0, 0}};

const koord var140[]={
{   0,  16, 1},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0}};

const koord var141[]={
{   0,   0, 1},
{   0,  22, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   0, 0}};

const koord var142[]={
{   0,  16, 1},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,   5, 0},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0},
{   0,  22, 0},
{   0, -11, 0}};

const koord var143[]={
{  22,   5, 1},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0}};

const koord var144[]={
{   0,   0, 1},
{   0,  22, 0},
{   0,  16, 0},
{   5,  22, 0},
{  11,  22, 0},
{  11,   0, 0},
{  11,  16, 0},
{  16,  22, 0},
{  22,  22, 0},
{  22,   0, 0}};

const koord var145[]={
{   0,  22, 1},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  22, 0},
{  22,  -5, 0},
{  16, -11, 0},
{   5, -11, 0}};

const koord var146[]={
{  11,  22, 1},
{   5,  22, 0},
{   0,  16, 0},
{   0,   5, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  16, 0},
{  16,  22, 0},
{  11,  22, 0},
{  11,  27, 0},
{  11, -11, 0}};

const koord var147[]={
{   0,   0, 1},
{  22,  22, 0},
{  11,  11, 0},
{   0,  22, 0},
{  22,   0, 0}};

const koord var148[]={
{   0,  22, 1},
{   0,   0, 0},
{  16,   0, 0},
{  16,  22, 0},
{  16,   0, 1},
{  22,   0, 0},
{  22,  -5, 0}};

const koord var149[]={
{   0,  22, 1},
{   0,  16, 0},
{   5,  11, 0},
{  16,  11, 0},
{  16,  22, 0},
{  16,   0, 0}};

const koord var150[]={
{   0,  22, 1},
{   0,   0, 0},
{  22,   0, 0},
{  22,  22, 0},
{  11,  22, 1},
{  11,   0, 0}};

const koord var151[]={
{   0,  22, 1},
{   0,   0, 0},
{  22,   0, 0},
{  22,  22, 0},
{  11,  22, 1},
{  11,   0, 0},
{  22,   0, 1},
{  27,   0, 0},
{  27,  -5, 0}};

const koord var152[]={
{   0,  22, 1},
{   5,  22, 0},
{   5,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  11, 0},
{  16,  16, 0},
{   5,  16, 0}};

const koord var153[]={
{   0,  22, 1},
{   0,   0, 0},
{  11,   0, 0},
{  16,   5, 0},
{  16,  11, 0},
{  11,  16, 0},
{   0,  16, 0},
{  22,  22, 1},
{  22,   0, 0}};

const koord var154[]={
{   0,  22, 1},
{   0,   0, 0},
{  11,   0, 0},
{  16,   5, 0},
{  16,  11, 0},
{  11,  16, 0},
{   0,  16, 0}};

const koord var155[]={
{   0,   0, 1},
{  11,   0, 0},
{  16,   5, 0},
{  16,  16, 0},
{  11,  22, 0},
{   0,  22, 0},
{   5,  11, 1},
{  16,  11, 0}};

const koord var156[]={
{   5,  11, 1},
{   5,   5, 0},
{  11,   0, 0},
{  16,   0, 0},
{  22,   5, 0},
{  22,  16, 0},
{  16,  22, 0},
{  11,  22, 0},
{   5,  16, 0},
{   5,  11, 0},
{   0,  11, 0},
{   0,  22, 1},
{   0,   0, 0}};

const koord var157[]={
{  16,   0, 1},
{  16,  22, 0},
{   5,  22, 0},
{   0,  16, 0},
{   0,  11, 0},
{  16,  11, 0},
{  11,  11, 1},
{   0,   0, 0}};

const koord var158[]={
{  22,   0, 1},
{   0,   0, 0},
{   0,  16, 0},
{  16,  16, 0},
{   0,  16, 0},
{   0,  33, 0},
{  22,  33, 0},
{   5,  38, 1},
{  11,  38, 0},
{  16,  38, 1},
{  22,  38, 0}};

const koord var159[]={
{  22,   5, 1},
{  16,   0, 0},
{   5,   0, 0},
{   0,   5, 0},
{   0,  16, 0},
{   5,  22, 0},
{  16,  22, 0},
{  22,  16, 0},
{  22,  11, 0},
{   0,  11, 0},
{   5,  27, 1},
{  11,  27, 0},
{  16,  27, 1},
{  22,  27, 0}};

const koord var160[]={
{   7,  0, 1},
{   7, 48, 0},
{   0, 13, 0},
{  11, 13, 0},
{   8, 53, 1},
{   7, 54, 0},
{   6, 54, 0},
{   5, 53, 0},
{   5, 50, 0},
{   6, 49, 0},
{   7, 49, 0},
{   8, 50, 0}};

const font FontDef[]={
{'!', sizeof(var0)/sizeof(*var0), (koord*)(&var0),    5,   38},
{'"', sizeof(var1)/sizeof(*var1), (koord*)(&var1),   16,   11},
{'#', sizeof(var2)/sizeof(*var2), (koord*)(&var2),   22,   33},
{'$', sizeof(var3)/sizeof(*var3), (koord*)(&var3),   22,   38},
{'%', sizeof(var4)/sizeof(*var4), (koord*)(&var4),   22,   38},
{'&', sizeof(var5)/sizeof(*var5), (koord*)(&var5),   22,   38},
{'\'', sizeof(var6)/sizeof(*var6), (koord*)(&var6),    5,   11},
{'(', sizeof(var7)/sizeof(*var7), (koord*)(&var7),    5,   38},
{')', sizeof(var8)/sizeof(*var8), (koord*)(&var8),    5,   38},
{'*', sizeof(var9)/sizeof(*var9), (koord*)(&var9),   22,   22},
{'+', sizeof(var10)/sizeof(*var10), (koord*)(&var10),   22,   22},
{',', sizeof(var11)/sizeof(*var11), (koord*)(&var11),    5,   11},
{'-', sizeof(var12)/sizeof(*var12), (koord*)(&var12),   22,    0},
{'.', sizeof(var13)/sizeof(*var13), (koord*)(&var13),    5,    5},
{'/', sizeof(var14)/sizeof(*var14), (koord*)(&var14),   22,   38},
{'0', sizeof(var15)/sizeof(*var15), (koord*)(&var15),   22,   38},
{'1', sizeof(var16)/sizeof(*var16), (koord*)(&var16),   11,   38},
{'2', sizeof(var17)/sizeof(*var17), (koord*)(&var17),   22,   38},
{'3', sizeof(var18)/sizeof(*var18), (koord*)(&var18),   22,   38},
{'4', sizeof(var19)/sizeof(*var19), (koord*)(&var19),   22,   38},
{'5', sizeof(var20)/sizeof(*var20), (koord*)(&var20),   22,   38},
{'6', sizeof(var21)/sizeof(*var21), (koord*)(&var21),   22,   38},
{'7', sizeof(var22)/sizeof(*var22), (koord*)(&var22),   22,   38},
{'8', sizeof(var23)/sizeof(*var23), (koord*)(&var23),   22,   38},
{'9', sizeof(var24)/sizeof(*var24), (koord*)(&var24),   22,   38},
{':', sizeof(var25)/sizeof(*var25), (koord*)(&var25),    5,   27},
{';', sizeof(var26)/sizeof(*var26), (koord*)(&var26),    5,   33},
{'<', sizeof(var27)/sizeof(*var27), (koord*)(&var27),   22,   22},
{'=', sizeof(var28)/sizeof(*var28), (koord*)(&var28),   22,   11},
{'>', sizeof(var29)/sizeof(*var29), (koord*)(&var29),   22,   22},
{'?', sizeof(var30)/sizeof(*var30), (koord*)(&var30),   22,   38},
{'@', sizeof(var31)/sizeof(*var31), (koord*)(&var31),   22,   27},
{'A', sizeof(var32)/sizeof(*var32), (koord*)(&var32),   22,   38},
{'B', sizeof(var33)/sizeof(*var33), (koord*)(&var33),   22,   38},
{'C', sizeof(var34)/sizeof(*var34), (koord*)(&var34),   22,   38},
{'D', sizeof(var35)/sizeof(*var35), (koord*)(&var35),   22,   38},
{'E', sizeof(var36)/sizeof(*var36), (koord*)(&var36),   22,   38},
{'F', sizeof(var37)/sizeof(*var37), (koord*)(&var37),   16,   38},
{'G', sizeof(var38)/sizeof(*var38), (koord*)(&var38),   22,   38},
{'H', sizeof(var39)/sizeof(*var39), (koord*)(&var39),   22,   38},
{'I', sizeof(var40)/sizeof(*var40), (koord*)(&var40),   11,   38},
{'J', sizeof(var41)/sizeof(*var41), (koord*)(&var41),   22,   38},
{'K', sizeof(var42)/sizeof(*var42), (koord*)(&var42),   22,   38},
{'L', sizeof(var43)/sizeof(*var43), (koord*)(&var43),   22,   38},
{'M', sizeof(var44)/sizeof(*var44), (koord*)(&var44),   22,   38},
{'N', sizeof(var45)/sizeof(*var45), (koord*)(&var45),   22,   38},
{'O', sizeof(var46)/sizeof(*var46), (koord*)(&var46),   22,   38},
{'P', sizeof(var47)/sizeof(*var47), (koord*)(&var47),   22,   38},
{'Q', sizeof(var48)/sizeof(*var48), (koord*)(&var48),   22,   38},
{'R', sizeof(var49)/sizeof(*var49), (koord*)(&var49),   22,   38},
{'S', sizeof(var50)/sizeof(*var50), (koord*)(&var50),   22,   38},
{'T', sizeof(var51)/sizeof(*var51), (koord*)(&var51),   22,   38},
{'U', sizeof(var52)/sizeof(*var52), (koord*)(&var52),   22,   38},
{'V', sizeof(var53)/sizeof(*var53), (koord*)(&var53),   22,   38},
{'W', sizeof(var54)/sizeof(*var54), (koord*)(&var54),   22,   38},
{'X', sizeof(var55)/sizeof(*var55), (koord*)(&var55),   22,   38},
{'Y', sizeof(var56)/sizeof(*var56), (koord*)(&var56),   22,   38},
{'Z', sizeof(var57)/sizeof(*var57), (koord*)(&var57),   22,   38},
{'[', sizeof(var58)/sizeof(*var58), (koord*)(&var58),   11,   38},
{'\\', sizeof(var59)/sizeof(*var59), (koord*)(&var59),   22,   38},
{']', sizeof(var60)/sizeof(*var60), (koord*)(&var60),   11,   38},
{'^', sizeof(var61)/sizeof(*var61), (koord*)(&var61),   22,   22},
{'_', sizeof(var62)/sizeof(*var62), (koord*)(&var62),   22,    0},
{'`', sizeof(var63)/sizeof(*var63), (koord*)(&var63),    5,   11},
{'a', sizeof(var64)/sizeof(*var64), (koord*)(&var64),   22,   22},
{'b', sizeof(var65)/sizeof(*var65), (koord*)(&var65),   22,   33},
{'c', sizeof(var66)/sizeof(*var66), (koord*)(&var66),   22,   22},
{'d', sizeof(var67)/sizeof(*var67), (koord*)(&var67),   22,   33},
{'e', sizeof(var68)/sizeof(*var68), (koord*)(&var68),   22,   22},
{'f', sizeof(var69)/sizeof(*var69), (koord*)(&var69),   16,   33},
{'g', sizeof(var70)/sizeof(*var70), (koord*)(&var70),   22,   33},
{'h', sizeof(var71)/sizeof(*var71), (koord*)(&var71),   22,   33},
{'i', sizeof(var72)/sizeof(*var72), (koord*)(&var72),    0,   33},
{'j', sizeof(var73)/sizeof(*var73), (koord*)(&var73),    5,   38},
{'k', sizeof(var74)/sizeof(*var74), (koord*)(&var74),   16,   33},
{'l', sizeof(var75)/sizeof(*var75), (koord*)(&var75),   11,   33},
{'m', sizeof(var76)/sizeof(*var76), (koord*)(&var76),   22,   22},
{'n', sizeof(var77)/sizeof(*var77), (koord*)(&var77),   22,   22},
{'o', sizeof(var78)/sizeof(*var78), (koord*)(&var78),   22,   22},
{'p', sizeof(var79)/sizeof(*var79), (koord*)(&var79),   22,   33},
{'q', sizeof(var80)/sizeof(*var80), (koord*)(&var80),   22,   33},
{'r', sizeof(var81)/sizeof(*var81), (koord*)(&var81),   22,   22},
{'s', sizeof(var82)/sizeof(*var82), (koord*)(&var82),   22,   22},
{'t', sizeof(var83)/sizeof(*var83), (koord*)(&var83),   16,   33},
{'u', sizeof(var84)/sizeof(*var84), (koord*)(&var84),   22,   22},
{'v', sizeof(var85)/sizeof(*var85), (koord*)(&var85),   22,   22},
{'w', sizeof(var86)/sizeof(*var86), (koord*)(&var86),   22,   22},
{'x', sizeof(var87)/sizeof(*var87), (koord*)(&var87),   22,   22},
{'y', sizeof(var88)/sizeof(*var88), (koord*)(&var88),   22,   33},
{'z', sizeof(var89)/sizeof(*var89), (koord*)(&var89),   22,   22},
{'{', sizeof(var90)/sizeof(*var90), (koord*)(&var90),   11,   44},
{'|', sizeof(var91)/sizeof(*var91), (koord*)(&var91),    0,   38},
{'}', sizeof(var92)/sizeof(*var92), (koord*)(&var92),   11,   44},
{'~', sizeof(var93)/sizeof(*var93), (koord*)(&var93),   27,   11},
{'á', sizeof(var94)/sizeof(*var94), (koord*)(&var94),   22,   38},
{'â', sizeof(var95)/sizeof(*var95), (koord*)(&var95),   22,   38},
{'÷', sizeof(var96)/sizeof(*var96), (koord*)(&var96),   22,   38},
{'ç', sizeof(var97)/sizeof(*var97), (koord*)(&var97),   22,   38},
{'ä', sizeof(var98)/sizeof(*var98), (koord*)(&var98),   27,   44},
{'å', sizeof(var99)/sizeof(*var99), (koord*)(&var99),   22,   38},
{'ö', sizeof(var100)/sizeof(*var100), (koord*)(&var100),   22,   38},
{'ú', sizeof(var101)/sizeof(*var101), (koord*)(&var101),   22,   38},
{'é', sizeof(var102)/sizeof(*var102), (koord*)(&var102),   22,   38},
{'ê', sizeof(var103)/sizeof(*var103), (koord*)(&var103),   22,   38},
{'ë', sizeof(var104)/sizeof(*var104), (koord*)(&var104),   22,   38},
{'ì', sizeof(var105)/sizeof(*var105), (koord*)(&var105),   22,   38},
{'í', sizeof(var106)/sizeof(*var106), (koord*)(&var106),   22,   38},
{'î', sizeof(var107)/sizeof(*var107), (koord*)(&var107),   22,   38},
{'ï', sizeof(var108)/sizeof(*var108), (koord*)(&var108),   22,   38},
{'ð', sizeof(var109)/sizeof(*var109), (koord*)(&var109),   22,   38},
{'ò', sizeof(var110)/sizeof(*var110), (koord*)(&var110),   22,   38},
{'ó', sizeof(var111)/sizeof(*var111), (koord*)(&var111),   22,   38},
{'ô', sizeof(var112)/sizeof(*var112), (koord*)(&var112),   22,   38},
{'õ', sizeof(var113)/sizeof(*var113), (koord*)(&var113),   22,   38},
{'æ', sizeof(var114)/sizeof(*var114), (koord*)(&var114),   22,   38},
{'è', sizeof(var115)/sizeof(*var115), (koord*)(&var115),   22,   38},
{'ã', sizeof(var116)/sizeof(*var116), (koord*)(&var116),   27,   44},
{'þ', sizeof(var117)/sizeof(*var117), (koord*)(&var117),   22,   38},
{'û', sizeof(var118)/sizeof(*var118), (koord*)(&var118),   22,   38},
{'ý', sizeof(var119)/sizeof(*var119), (koord*)(&var119),   27,   44},
{'ÿ', sizeof(var120)/sizeof(*var120), (koord*)(&var120),   27,   38},
{'ù', sizeof(var121)/sizeof(*var121), (koord*)(&var121),   22,   38},
{'ø', sizeof(var122)/sizeof(*var122), (koord*)(&var122),   22,   38},
{'ü', sizeof(var123)/sizeof(*var123), (koord*)(&var123),   22,   38},
{'à', sizeof(var124)/sizeof(*var124), (koord*)(&var124),   22,   38},
{'ñ', sizeof(var125)/sizeof(*var125), (koord*)(&var125),   22,   38},
{'Á', sizeof(var126)/sizeof(*var126), (koord*)(&var126),   27,   22},
{'Â', sizeof(var127)/sizeof(*var127), (koord*)(&var127),   22,   33},
{'×', sizeof(var128)/sizeof(*var128), (koord*)(&var128),   22,   33},
{'Ç', sizeof(var129)/sizeof(*var129), (koord*)(&var129),   22,   22},
{'Ä', sizeof(var130)/sizeof(*var130), (koord*)(&var130),   22,   33},
{'Å', sizeof(var131)/sizeof(*var131), (koord*)(&var131),   22,   22},
{'Ö', sizeof(var132)/sizeof(*var132), (koord*)(&var132),   22,   22},
{'Ú', sizeof(var133)/sizeof(*var133), (koord*)(&var133),   22,   22},
{'É', sizeof(var134)/sizeof(*var134), (koord*)(&var134),   22,   22},
{'Ê', sizeof(var135)/sizeof(*var135), (koord*)(&var135),   22,   27},
{'Ë', sizeof(var136)/sizeof(*var136), (koord*)(&var136),   16,   22},
{'Ì', sizeof(var137)/sizeof(*var137), (koord*)(&var137),   16,   22},
{'Í', sizeof(var138)/sizeof(*var138), (koord*)(&var138),   22,   22},
{'Î', sizeof(var139)/sizeof(*var139), (koord*)(&var139),   16,   22},
{'Ï', sizeof(var140)/sizeof(*var140), (koord*)(&var140),   22,   22},
{'Ð', sizeof(var141)/sizeof(*var141), (koord*)(&var141),   22,   22},
{'Ò', sizeof(var142)/sizeof(*var142), (koord*)(&var142),   22,   33},
{'Ó', sizeof(var143)/sizeof(*var143), (koord*)(&var143),   22,   22},
{'Ô', sizeof(var144)/sizeof(*var144), (koord*)(&var144),   22,   22},
{'Õ', sizeof(var145)/sizeof(*var145), (koord*)(&var145),   22,   33},
{'Æ', sizeof(var146)/sizeof(*var146), (koord*)(&var146),   22,   38},
{'È', sizeof(var147)/sizeof(*var147), (koord*)(&var147),   22,   22},
{'Ã', sizeof(var148)/sizeof(*var148), (koord*)(&var148),   22,   27},
{'Þ', sizeof(var149)/sizeof(*var149), (koord*)(&var149),   16,   22},
{'Û', sizeof(var150)/sizeof(*var150), (koord*)(&var150),   22,   22},
{'Ý', sizeof(var151)/sizeof(*var151), (koord*)(&var151),   27,   27},
{'ß', sizeof(var152)/sizeof(*var152), (koord*)(&var152),   22,   22},
{'Ù', sizeof(var153)/sizeof(*var153), (koord*)(&var153),   22,   22},
{'Ø', sizeof(var154)/sizeof(*var154), (koord*)(&var154),   16,   22},
{'Ü', sizeof(var155)/sizeof(*var155), (koord*)(&var155),   16,   22},
{'À', sizeof(var156)/sizeof(*var156), (koord*)(&var156),   22,   22},
{'Ñ', sizeof(var157)/sizeof(*var157), (koord*)(&var157),   16,   22},
{'³', sizeof(var158)/sizeof(*var158), (koord*)(&var158),   22,   38},
{'£', sizeof(var159)/sizeof(*var159), (koord*)(&var159),   22,   27},
{255, sizeof(var160)/sizeof(*var160), (koord*)(&var160),  110,  540}};

#define costScale 1024
extern int gdCosT[];
#define sintScale 1024
extern int gdSinT[];

static void
_clip_gdImageCharVector(gdImagePtr im, int x, int y, int a, int c, int color, int chis, int znam )
{
	int i,j;
	int x1,y1,x2,y2;
	int dx1,dy1,dx2,dy2;

	if (chis==0) chis=1;
	if (znam==0) znam=1;
	a%=360;
	if (a) a=360-a;
	for ( i=0;i<sizeof( FontDef )/sizeof( *FontDef ) && FontDef[i].Num!=c;i++ );
	if ( i<sizeof( FontDef )/sizeof( *FontDef ) )
	{
		for ( j=1; j<FontDef[i].len; j++ )
		{
			if (FontDef[i].Mass[j].Nach==0)
			{
				dx1=FontDef[i].Mass[j-1].X*chis/znam;
				dy1=FontDef[i].Mass[j-1].Y*chis/znam;
				dx2=FontDef[i].Mass[j].X*chis/znam;
				dy2=FontDef[i].Mass[j].Y*chis/znam;
				x1=x+dx1*gdCosT[a]/costScale-dy1*gdSinT[a]/sintScale;
				y1=y-(dx1*gdSinT[a]/sintScale+dy1*gdCosT[a]/costScale);
				x2=x+dx2*gdCosT[a]/costScale-dy2*gdSinT[a]/sintScale;
				y2=y-(dx2*gdSinT[a]/sintScale+dy2*gdCosT[a]/costScale);
				gdImageLine(im, x1, y1, x2, y2, color);
			}
		}
	}
}

static void
_clip_gdImageStringVector(gdImagePtr im, int x1, int y1, int a, char *s, int color, int chis, int znam )
{
	int width=( 28+28/5 )*gdCosT[a % 360]/costScale*chis/znam;
	int height=( 28+28/5 )*gdSinT[a % 360]/sintScale*chis/znam;
	char *p;
	int x,y;

	for (x=x1, y=y1, p=s; *p!='\0'; p++, x+=width, y+=height)
		_clip_gdImageCharVector(im, x, y, a, *p, color, chis, znam);
}

static int
_clip_gdPutCharVector(ClipMachine * mp, int type)
{
	gdImagePtr im=GETIMAGE(mp);
	char * str = _clip_parc(mp,2);
	int x = _clip_parni(mp,3);
	int y = _clip_parni(mp,4);
	int a = _clip_parni(mp,5);
	int color = _clip_parni(mp,6);
	int fontSize = _clip_parni(mp,7);

	_clip_retl(mp, 0);
	if ( im == NULL || str==NULL )
		return 0;
	switch ( type )
	{
		case 0:
			_clip_gdImageCharVector(im,x,y,a,*str,color,fontSize,1000);
			break;
		case 1:
			_clip_gdImageStringVector(im,x,y,a,str,color,fontSize,1000);
			break;
	}
	_clip_retl(mp,1);
	return 0;
}

int
clip_GDIMAGECHARVECTOR(ClipMachine * mp)
{
	_clip_gdPutCharVector(mp,0);
	return 0;
}

int
clip_GDIMAGESTRINGVECTOR(ClipMachine * mp)
{
	_clip_gdPutCharVector(mp,1);
	return 0;
}

int
clip_GDCOS(ClipMachine * mp)
{
	int angle=_clip_parni(mp,2);
	_clip_retni(mp, gdCosT[angle  % 360]/costScale);
	return 0;
}

int
clip_GDSIN(ClipMachine * mp)
{
	int angle=_clip_parni(mp,2);
	_clip_retni(mp, gdSinT[angle % 360]/sintScale);
	return 0;
}

int
clip_GDIMAGECOPY(ClipMachine * mp)
{
	gdImagePtr imDst=GETIMAGE(mp);
	gdImagePtr imSrc=NULL;
	int nImSrc = _clip_parni(mp, 2);
	int dstX = _clip_parni(mp, 3);
	int dstY = _clip_parni(mp, 4);
	int srcX = _clip_parni(mp, 5);
	int srcY = _clip_parni(mp, 6);
	int width = _clip_parni(mp, 7);
	int height = _clip_parni(mp, 8);

	if ( _clip_parinfo(mp,2) == NUMERIC_t )
	{
		imSrc=_clip_fetch_c_item(mp,nImSrc,_C_ITEM_TYPE_GDLIB);
	}
	if ( imDst==NULL || imSrc==NULL)
	{
		_clip_retni(mp,-1);
		return 0;
	}
	gdImageCopy(imDst, imSrc, dstX, dstY, srcX, srcY, width, height);
	_clip_retni(mp,1);
	return 0;
}


int
clip_GDIMAGECOPYRESIZED(ClipMachine * mp)
{
	gdImagePtr imDst=GETIMAGE(mp);
	gdImagePtr imSrc=NULL;
	int nImSrc = _clip_parni(mp, 2);
	int dstX = _clip_parni(mp, 3);
	int dstY = _clip_parni(mp, 4);
	int srcX = _clip_parni(mp, 5);
	int srcY = _clip_parni(mp, 6);
	int dstW = _clip_parni(mp, 7);
	int dstH = _clip_parni(mp, 8);
	int srcW = _clip_parni(mp, 9);
	int srcH = _clip_parni(mp, 10);

	if ( _clip_parinfo(mp,2) == NUMERIC_t )
	{
		imSrc=_clip_fetch_c_item(mp,nImSrc,_C_ITEM_TYPE_GDLIB);
	}
	if ( imDst==NULL || imSrc==NULL)
	{
		_clip_retni(mp,-1);
		return 0;
	}
	gdImageCopyResized(imDst, imSrc, dstX, dstY, srcX, srcY, dstW, dstH, srcW, srcH);
	_clip_retni(mp,1);
	return 0;
}


