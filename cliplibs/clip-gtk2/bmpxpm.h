#ifndef __BMPXPM_H__
#define __BMPXPM_H__

#include <stdio.h>

/*
 * Classes of BMP files
 */
#define C_WIN	1
#define C_OS2	2

#define MAX_RGBNAMES 1024

/* Lower bound and upper bound of character-pixels printed in UIL output. */
#define LOW_CHAR '`'
#define HIGH_CHAR '~'

typedef unsigned char pixval;
typedef unsigned long lpixel;

typedef struct { pixval r, g, b; } pixel;
typedef struct bitstream	*BITSTREAM;

#define PPM_ASSIGN(p, R, G, B) (p).r = R; (p).g = G; (p).b = B
#define PPM_EQUAL(p,q) ((p) == (q))

#define ppm_lallocarray( cols, rows ) ((lpixel**) pm_allocarray( cols, rows, sizeof(lpixel) ))

#define ppm_allocarray( cols, rows ) ((pixel**) pm_allocarray( cols, rows, sizeof(pixel) ))
#define ppm_freearray( pixels, rows ) pm_freearray( (char**) pixels, rows )

#define RGB_ASSIGN(p,red,grn,blu) (p) = ((lpixel) (red) << 20) | ((lpixel) (grn) << 10) | (lpixel) (blu)
#define PPM_GETR(p) (((p) & 0x3ff00000) >> 20)
#define PPM_GETG(p) (((p) & 0xffc00) >> 10)
#define PPM_GETB(p) ((p) & 0x3ff)

#define HASHSIZE 20023

#ifdef PPM_PACKCOLORS
#define ppm_hashpixel(p) ( ( (int) (p) & 0x7fffffff ) % HASHSIZE )
#else /*PPM_PACKCOLORS*/
#define ppm_hashpixel(p) ( ( ( (long) PPM_GETR(p) * 33023 + (long) PPM_GETG(p) * 30013 + (long) PPM_GETB(p) * 27011 ) & 0x7fffffff ) % HASHSIZE )
#endif /*PPM_PACKCOLORS*/

char** pm_allocarray( int cols, int rows, int size );
void pm_freearray( char** its, int rows );
void BMPreadfileheader(FILE *fp, unsigned long  *ppos, unsigned long  *poffBits);
void BMPreadinfoheader(FILE *fp, unsigned long  *ppos, unsigned long  *pcx, unsigned long  *pcy, unsigned short *pcBitCount, int *pclass);
int BMPreadrgbtable(FILE *fp, unsigned long  *ppos, unsigned short cBitCount, int class, pixval *R, pixval *G, pixval *B);
int BMPreadrow(FILE *fp, unsigned long *ppos, lpixel *row, unsigned long cx, unsigned short cBitCount, pixval *R, pixval *G, pixval *B);
lpixel ** BMPreadbits(FILE *fp, unsigned long  *ppos, unsigned long offBits, unsigned long cx, unsigned long  cy, unsigned short cBitCount, int class, pixval *R, pixval *G, pixval *B);
unsigned long BMPoffbits (int class, unsigned long bitcount);
unsigned long BMPlenfileheader (int class);
unsigned long BMPleninfoheader (int class);
unsigned long BMPlenrgbtable (int class, unsigned long bitcount);
unsigned long BMPlenline (int class, unsigned long bitcount, unsigned long x);
unsigned long BMPlenbits (int class, unsigned long bitcount, unsigned long x, unsigned long y);
unsigned long BMPlenfile (int class, unsigned long bitcount, unsigned long x, unsigned long y);

/* Color histogram stuff. */

typedef struct colorhist_item* colorhist_vector;
struct colorhist_item
    {
    lpixel color;
    int value;
    };

typedef struct colorhist_list_item* colorhist_list;
struct colorhist_list_item
    {
    struct colorhist_item ch;
    colorhist_list next;
    };

colorhist_vector ppm_computecolorhist ( lpixel** pixels, int cols, int rows, int maxcolors, int* colorsP );
/* Returns a colorhist *colorsP long (with space allocated for maxcolors. */

void ppm_addtocolorhist ( colorhist_vector chv, int* colorsP, int maxcolors, pixel* colorP, int value, int position );

void ppm_freecolorhist ( colorhist_vector chv );


/* Color hash table stuff. */

typedef colorhist_list* colorhash_table;

colorhash_table ppm_computecolorhash ( lpixel** pixels, int cols, int rows, int maxcolors, int* colorsP );

int ppm_lookupcolor ( colorhash_table cht, lpixel* colorP );

colorhist_vector ppm_colorhashtocolorhist ( colorhash_table cht, int maxcolors );
colorhash_table ppm_colorhisttocolorhash ( colorhist_vector chv, int colors );

int ppm_addtocolorhash ( colorhash_table cht, pixel* colorP, int value );
/* Returns -1 on failure. */

colorhash_table ppm_alloccolorhash (void);

void ppm_freecolorhash (colorhash_table cht);

typedef struct {			/* rgb values and ascii names (from
					 * rgb text file) */
    int r, g, b;			/* rgb values, range of 0 -> 65535 */
    char *name;				/* color mnemonic of rgb value */
}      rgb_names;

typedef struct {			/* character-pixel mapping */
    char *cixel;			/* character string printed for
					 * pixel */
    char *rgbname;			/* ascii rgb color, either color
					 * mnemonic or #rgb value */
}      cixel_map;


/* prototypes/forward reference */
void   read_rgb_names (char *, rgb_names *, int *);
char * gen_numstr (int, int, int);
void   gen_cmap (colorhist_vector, int, pixval, int, rgb_names *, int, cixel_map *, int *);


#endif
