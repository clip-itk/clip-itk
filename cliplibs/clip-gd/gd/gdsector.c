#include "gd.h"
#include "gdfontg.h"
#include "gdfontl.h"
#include "gdfontmb.h"
#include "gdfonts.h"
#include "gdfontt.h"

#define sintScale 1024
#define costScale 1024
extern int gdCosT[],gdSinT[];

void
gdImageSector(gdImagePtr im, int cx, int cy, int w, int h, int s, int e, int color)
{
	int i;
	int x, y;
	int lx = 0, ly = 0;
	int w2, h2;
	w2 = w/2;
	h2 = h/2;
	while (e < s) {
		e += 360;
	}
	for (i=s; (i <= e); i++) {
		x = ((long)gdCosT[i % 360] * (long)w2 / costScale) + cx;
		y = ((long)gdSinT[i % 360] * (long)h2 / sintScale) + cy;
		if (i != s)
			gdImageLine(im, lx, ly, x, y, color);
		else
			gdImageLine(im, cx, cy, x, y, color);
		lx = x;
		ly = y;
	}
	gdImageLine(im, cx, cy, lx, ly, color);
}

void
gdImageFilledSector(gdImagePtr im, int cx, int cy, int w, int h, int s, int e, int color)
{
	int i,p;
	int x, y;
	int lx = 0, ly = 0;
	int w2, h2;
	w2 = w/2;
	h2 = h/2;
	while (e < s) {
		e += 360;
	}
	p=(e-s)/2;
	if (p>30) p=30;
	p+=s;
	for (i=s; (i <= e); i++) {
		x = ((long)gdCosT[i % 360] * (long)w2 / costScale) + cx;
		y = ((long)gdSinT[i % 360] * (long)h2 / sintScale) + cy;
		if (i != s)
			gdImageLine(im, lx, ly, x, y, color);
		else
			gdImageLine(im, cx, cy, x, y, color);
		lx = x;
		ly = y;
	}
	gdImageLine(im, cx, cy, lx, ly, color);
	x = ((long)gdCosT[p % 360] * ((long)w2/2) / costScale) + cx;
	y = ((long)gdSinT[p % 360] * ((long)h2/2) / sintScale) + cy;
	gdImageFillToBorder(im,x,y,color,color);
}

void
gdImageTruncSector(gdImagePtr im, int cx, int cy, int w, int h, int we, int he, int s, int e, int color)
{
	int i;
	int x, y, xe, ye;
	int lx = 0, ly = 0, lxe = 0, lye = 0;
	int w2, h2, we2, he2;
	w2 = w/2;
	h2 = h/2;
	we2 = we/2;
	he2 = he/2;
	while (e < s) {
		e += 360;
	}
	for (i=s; (i <= e); i++) {
		x = ((long)gdCosT[i % 360] * (long)w2 / costScale) + cx;
		y = ((long)gdSinT[i % 360] * (long)h2 / sintScale) + cy;
		xe = ((long)gdCosT[i % 360] * (long)we2 / costScale) + cx;
		ye = ((long)gdSinT[i % 360] * (long)he2 / sintScale) + cy;

		if (i != s){
			gdImageLine(im, lx, ly, x, y, color);
			gdImageLine(im, lxe, lye, xe, ye, color);
		}
		else
			gdImageLine(im, xe, ye, x, y, color);

		lx = x;
		ly = y;
		lxe = xe;
		lye = ye;
	}
	gdImageLine(im, xe, ye, lx, ly, color);
}

void
gdImageFilledTruncSector(gdImagePtr im, int cx, int cy, int w, int h, int we, int he, int s, int e, int color)
{
	int i, p;
	int x, y, xe, ye;
	int lx = 0, ly = 0, lxe = 0, lye = 0;
	int w2, h2, we2, he2;
	w2 = w/2;
	h2 = h/2;
	we2 = we/2;
	he2 = he/2;
	while (e < s) {
		e += 360;
	}
	p=(e-s)/2;
	if (p>30) p=30;
	p+=s;
	for (i=s; (i <= e); i++) {
		x = ((long)gdCosT[i % 360] * (long)w2 / costScale) + cx;
		y = ((long)gdSinT[i % 360] * (long)h2 / sintScale) + cy;
		xe = ((long)gdCosT[i % 360] * (long)we2 / costScale) + cx;
		ye = ((long)gdSinT[i % 360] * (long)he2 / sintScale) + cy;

		if (i != s){
			gdImageLine(im, lx, ly, x, y, color);
			gdImageLine(im, lxe, lye, xe, ye, color);
		}
		else
			gdImageLine(im, xe, ye, x, y, color);

		lx = x;
		ly = y;
		lxe = xe;
		lye = ye;
	}
	gdImageLine(im, xe, ye, lx, ly, color);
	x = ((long)gdCosT[p % 360] * ((long)(w2+we2)/2) / costScale) + cx;
	y = ((long)gdSinT[p % 360] * ((long)(h2+he2)/2) / sintScale) + cy;
	gdImageFillToBorder(im,x,y,color,color);
}

gdFontPtr
gdSelectFont(int num)
{
	gdFontPtr ret;
	switch (num)
	{
		case 0: ret=gdFontGiant;      break;
		case 1: ret=gdFontLarge;      break;
		case 2: ret=gdFontMediumBold; break;
		case 3: ret=gdFontSmall;      break;
		case 4: ret=gdFontTiny;       break;
		default:
			ret=gdFontGiant;      break;
	}
	return ret;
}

void
gdImageCharRotate(gdImagePtr im, gdFontPtr f, int x, int y, int c,
	int a, int color)
{
	int cx, cy;
	int px, py;
	int fline;
	int dx,dy;
	cx = 0;
	cy = 0;
	if ((c < f->offset) || (c >= (f->offset + f->nchars))) {
		return;
	}
	fline = (c - f->offset) * f->h * f->w;
	for (py = y; (py < (y + f->h)); py++) {
		for (px = x; (px < (x + f->w)); px++) {
			if (f->data[fline + cy * f->w + cx]) {
				dx=px-x;
				dy=py-y;
				gdImageSetPixel(im,
					x+dx*gdCosT[a % 360]/costScale-dy*gdSinT[a % 360]/sintScale,
					y+dx*gdSinT[a % 360]/sintScale+dy*gdCosT[a % 360]/costScale, color);
			}
			cx++;
		}
		cx = 0;
		cy++;
	}
}

void
gdImageStringRotate(gdImagePtr im, gdFontPtr f,
	int x, int y, unsigned char *s, int a, int color)
{
	int width=(f->w+1)*gdCosT[a % 360]/costScale;
	int height=(f->w+1)*gdSinT[a % 360]/sintScale;
	unsigned char *p;
	for (p=s; *p; p++, x+=width, y += height )
	{
		gdImageCharRotate(im, f, x, y, *p, a, color);
	}
}

