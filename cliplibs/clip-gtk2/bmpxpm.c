#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bmpxpm.h"


/*
 * bitio.c - bitstream I/O
 *
 * Works for (sizeof(unsigned long)-1)*8 bits.
 *
 * Copyright (C) 1992 by David W. Sanderson.
*/
struct bitstream
{
	FILE *
		f;		/* bytestream */
	unsigned long
		bitbuf;		/* bit buffer */
	int
		nbitbuf;	/* number of bits in 'bitbuf' */
	char
		mode;
};

#define Mask(n)		((1<<(n))-1)

#define BitPut(b,ul,n)	((b)->bitbuf = (((b)->bitbuf<<(n))	\
					|((ul)&Mask(n))),	\
			(b)->nbitbuf += (n))

#define BitGet(b,n)	(((b)->bitbuf>>((b)->nbitbuf-=(n))) & Mask(n))

/*
 * pm_bitinit() - allocate and return a struct bitstream * for the
 * given FILE*.
 *
 * mode must be one of "r" or "w", according to whether you will be
 * reading from or writing to the struct bitstream *.
 *
 * Returns 0 on error.
 */

struct bitstream *
pm_bitinit(f, mode)
	FILE           *f;
	char           *mode;
{
	struct bitstream *ans = (struct bitstream *)0;

	if(!f || !mode || !*mode)
		return ans;
	if(strcmp(mode, "r") && strcmp(mode, "w"))
		return ans;

	ans = (struct bitstream *)calloc(1, sizeof(struct bitstream));
	if(ans)
	{
		ans->f = f;
		ans->mode = *mode;
	}

	return ans;
}

/*
 * pm_bitfini() - deallocate the given struct bitstream *.
 *
 * You must call this after you are done with the struct bitstream *.
 *
 * It may flush some bits left in the buffer.
 *
 * Returns the number of bytes written, -1 on error.
 */

int
pm_bitfini(b)
	struct bitstream *b;
{
	int		nbyte = 0;

	if(!b)
		return -1;

	/* flush the output */
	if(b->mode == 'w')
	{
		/* flush the bits */
		if (b->nbitbuf < 0 || b->nbitbuf >= 8)
		{
			/* pm_bitwrite() didn't work */
			return -1;
		}

		/*
		 * If we get to here, nbitbuf is 0..7
		 */
		if(b->nbitbuf)
		{
			char	c;

			BitPut(b, 0, (long)8-(b->nbitbuf));
			c = (char) BitGet(b, (long)8);
			if(putc(c, b->f) == EOF)
			{
				return -1;
			}
			nbyte++;
		}
	}

	free(b);
	return nbyte;
}

/*
 * pm_bitread() - read the next nbits into *val from the given file.
 *
 * The last pm_bitread() must be followed by a call to pm_bitfini().
 *
 * Returns the number of bytes read, -1 on error.
 */

int
pm_bitread(b, nbits, val)
	struct bitstream *b;
	unsigned long   nbits;
	unsigned long  *val;
{
	int		nbyte = 0;
	int		c;

	if(!b)
		return -1;

	while (b->nbitbuf < nbits)
	{
		if((c = getc(b->f)) == EOF)
		{
			return -1;
		}
		nbyte++;

		BitPut(b, c, (long) 8);
	}

	*val = BitGet(b, nbits);
	return nbyte;
}

/*
 * pm_bitwrite() - write the low nbits of val to the given file.
 *
 * The last pm_bitwrite() must be followed by a call to pm_bitfini().
 *
 * Returns the number of bytes written, -1 on error.
 */

int
pm_bitwrite(b, nbits, val)
	struct bitstream *b;
	unsigned long   nbits;
	unsigned long   val;
{
	int		nbyte = 0;
	char		c;

	if(!b)
		return -1;

	BitPut(b, val, nbits);

	while (b->nbitbuf >= 8)
	{
		c = (char) BitGet(b, (long)8);

		if(putc(c, b->f) == EOF)
		{
			return -1;
		}
		nbyte++;
	}

	return nbyte;
}

/* End of bitio.c */

/*
 * readto - read as many bytes as necessary to position the
 * file at the desired offset.
 */

static void
readto(fp, ppos, dst)
	FILE           *fp;
	unsigned long  *ppos;	/* pointer to number of bytes read from fp */
	unsigned long   dst;
{
	unsigned long   pos;

	if(!fp || !ppos)
		return;

	pos = *ppos;

	if(pos > dst)
		//pm_error("%s: internal error in readto()", ifname);
                exit(1);

	for(; pos < dst; pos++)
	{
		if (getc(fp) == EOF)
		{
			//pm_error(er_read, ifname);
                        exit(1);
		}
	}

	*ppos = pos;
}

char**
pm_allocarray( cols, rows, size )
    int cols, rows;
    int size;
    {
    char** its;
    int i;

    its = (char**) malloc( rows * sizeof(char*) );
    if ( its == (char**) 0 )
        //pm_error( "out of memory allocating an array" );
        exit(1);
    its[0] = (char*) malloc( rows * cols * size );
    if ( its[0] == (char*) 0 )
        //pm_error( "out of memory allocating an array" );
        exit(1);
    for ( i = 1; i < rows; ++i )
        its[i] = &(its[0][i * cols * size]);
    return its;
    }

void
pm_freearray( its, rows )
    char** its;
    int rows;
    {
    free( its[0] );
    free( its );
    }

/*
 * BMP reading routines
 */

int
pm_readlittleshort(FILE *in, short *sP )
    {
    int c;

    if ( (c = getc( in )) == EOF )
        return -1;
    *sP = c & 0xff;
    if ( (c = getc( in )) == EOF )
        return -1;
    *sP |= ( c & 0xff ) << 8;
    return 0;
    }

int
pm_readlittlelong(FILE *in, long *lP )
    {
    int c;

    if ( (c = getc( in )) == EOF )
        return -1;
    *lP = c & 0xff;
    if ( (c = getc( in )) == EOF )
        return -1;
    *lP |= ( c & 0xff ) << 8;
    if ( (c = getc( in )) == EOF )
        return -1;
    *lP |= ( c & 0xff ) << 16;
    if ( (c = getc( in )) == EOF )
        return -1;
    *lP |= ( c & 0xff ) << 24;
    return 0;
    }

static short
GetShort(FILE *fp)
{
	short           v;

	if (pm_readlittleshort(fp, &v) == -1)
	{
		//pm_error("%s: read error", ifname);
		exit(1);
	}

	return v;
}

static long
GetLong(FILE *fp)
{
	long            v;

	if (pm_readlittlelong(fp, &v) == -1)
	{
		//pm_error("%s: read error", ifname);
		exit(1);
	}

	return v;
}

static int
GetByte(FILE *fp)
{
	int             v;

	if ((v = getc(fp)) == EOF)
	{
		// pm_error("%s: read error", filename);
		exit(1);
	}

	return v;
}

void
BMPreadfileheader(FILE *fp, unsigned long  *ppos, unsigned long  *poffBits)
/*	FILE           *fp;
	unsigned long  *ppos;	number of bytes read from fp
	unsigned long  *poffBits; */
{
	unsigned long   cbSize;
	unsigned short  xHotSpot;
	unsigned short  yHotSpot;
	unsigned long   offBits;

	if (GetByte(fp) != 'B')
	{
		//pm_error("%s is not a BMP file", ifname);
                exit(1);
	}
	if (GetByte(fp) != 'M')
	{
		//pm_error("%s is not a BMP file", ifname);
                exit(1);
	}

	cbSize = GetLong(fp);
	xHotSpot = GetShort(fp);
	yHotSpot = GetShort(fp);
	offBits = GetLong(fp);

	*poffBits = offBits;

	*ppos += 14;
}

void
BMPreadinfoheader(fp, ppos, pcx, pcy, pcBitCount, pclass)
	FILE           *fp;
	unsigned long  *ppos;	/* number of bytes read from fp */
	unsigned long  *pcx;
	unsigned long  *pcy;
	unsigned short *pcBitCount;
	int            *pclass;
{
	unsigned long   cbFix;
	unsigned short  cPlanes;

	unsigned long   cx;
	unsigned long   cy;
	unsigned short  cBitCount;
	int             class;

	cbFix = GetLong(fp);

	switch (cbFix)
	{
	case 12:
		class = C_OS2;

		cx = GetShort(fp);
		cy = GetShort(fp);
		cPlanes = GetShort(fp);
		cBitCount = GetShort(fp);

		break;
	case 40:
		class = C_WIN;

		cx = GetLong(fp);
		cy = GetLong(fp);
		cPlanes = GetShort(fp);
		cBitCount = GetShort(fp);

		/*
		 * We've read 16 bytes so far, need to read 24 more
		 * for the required total of 40.
		 */

		GetLong(fp);
		GetLong(fp);
		GetLong(fp);
		GetLong(fp);
		GetLong(fp);
		GetLong(fp);

		break;
	default:
		//pm_error("%s: unknown cbFix: %d", ifname, cbFix);
                exit(1);
		break;
	}

	if (cPlanes != 1)
	{
		//pm_error("%s: don't know how to handle cPlanes = %d"
		//	 ,ifname
		//	 ,cPlanes);
                exit(1);
	}

/*
	switch (class)
	{
	case C_WIN:
		pm_message("Windows BMP, %dx%dx%d"
			   ,cx
			   ,cy
			   ,cBitCount);
		break;
	case C_OS2:
		pm_message("OS/2 BMP, %dx%dx%d"
			   ,cx
			   ,cy
			   ,cBitCount);
		break;
	}

#ifdef DEBUG
	pm_message("cbFix: %d", cbFix);
	pm_message("cx: %d", cx);
	pm_message("cy: %d", cy);
	pm_message("cPlanes: %d", cPlanes);
	pm_message("cBitCount: %d", cBitCount);
#endif
*/
	*pcx = cx;
	*pcy = cy;
	*pcBitCount = cBitCount;
	*pclass = class;

	*ppos += cbFix;
}

/*
 * returns the number of bytes read, or -1 on error.
 */
int
BMPreadrgbtable(fp, ppos, cBitCount, class, R, G, B)
	FILE           *fp;
	unsigned long  *ppos;	/* number of bytes read from fp */
	unsigned short  cBitCount;
	int             class;
	pixval         *R;
	pixval         *G;
	pixval         *B;
{
	int             i;
	int		nbyte = 0;

	long            ncolors = (1 << cBitCount);

	for (i = 0; i < ncolors; i++)
	{
		B[i] = (pixval) GetByte(fp);
		G[i] = (pixval) GetByte(fp);
		R[i] = (pixval) GetByte(fp);
		nbyte += 3;

		if (class == C_WIN)
		{
			(void) GetByte(fp);
			nbyte++;
		}
	}

	*ppos += nbyte;
	return nbyte;
}

/*
 * returns the number of bytes read, or -1 on error.
 */
int
BMPreadrow(fp, ppos, row, cx, cBitCount, R, G, B)
	FILE           *fp;
	unsigned long  *ppos;	/* number of bytes read from fp */
	lpixel         *row;
	unsigned long   cx;
	unsigned short  cBitCount;
	pixval         *R;
	pixval         *G;
	pixval         *B;
{
	BITSTREAM       b;
	unsigned        nbyte = 0;
	int             rc;
	unsigned        x;

	if ((b = pm_bitinit(fp, "r")) == (BITSTREAM) 0)
	{
		return -1;
	}

	for (x = 0; x < cx; x++, row++)
	{
		unsigned long   v;

		if ((rc = pm_bitread(b, cBitCount, &v)) == -1)
		{
			return -1;
		}
		nbyte += rc;

		//PPM_ASSIGN(*row, R[v], G[v], B[v]);
		RGB_ASSIGN(*row, R[v], G[v], B[v]);
	}

	if ((rc = pm_bitfini(b)) != 0)
	{
		return -1;
	}

	/*
	 * Make sure we read a multiple of 4 bytes.
	 */
	while (nbyte % 4)
	{
		GetByte(fp);
		nbyte++;
	}

	*ppos += nbyte;
	return nbyte;
}

lpixel **
BMPreadbits(fp, ppos, offBits, cx, cy, cBitCount, class, R, G, B)
	FILE           *fp;
	unsigned long  *ppos;	/* number of bytes read from fp */
	unsigned long   offBits;
	unsigned long   cx;
	unsigned long   cy;
	unsigned short  cBitCount;
	int             class;
	pixval         *R;
	pixval         *G;
	pixval         *B;
{
	lpixel        **pixels;	/* output */
	long            y;

	readto(fp, ppos, offBits);

	pixels = ppm_lallocarray(cx, cy);

	if(cBitCount > 24)
	{
		//pm_error("%s: cannot handle cBitCount: %d"
		//	 ,ifname
		//	 ,cBitCount);
		exit(1);
	}

	/*
	 * The picture is stored bottom line first, top line last
	 */

	for (y = cy - 1; y >= 0; y--)
	{
		int rc;
		rc = BMPreadrow(fp, ppos, pixels[y], cx, cBitCount, R, G, B);

		if(rc == -1)
		{
			//pm_error("%s: couldn't read row %d"
			//	 ,ifname
			//	 ,y);
                        exit(1);
		}
		if(rc%4)
		{
			//pm_error("%s: row had bad number of bytes: %d"
			//	 ,ifname
			//	 ,rc);
			exit(1);
		}
	}

	return pixels;
}

unsigned long
BMPlenfileheader(class)
	int             class;
{
	switch (class)
	{
	case C_WIN:
		return 14;
	case C_OS2:
		return 14;
	default:
		//pm_error(er_internal, "BMPlenfileheader");
		return 0;
	}
}

unsigned long
BMPleninfoheader(class)
	int             class;
{
	switch (class)
	{
	case C_WIN:
		return 40;
	case C_OS2:
		return 12;
	default:
		//pm_error(er_internal, "BMPleninfoheader");
		return 0;
	}
}

unsigned long
BMPlenrgbtable(class, bitcount)
	int             class;
	unsigned long   bitcount;
{
	unsigned long   lenrgb;

	if (bitcount < 1)
	{
		//pm_error(er_internal, "BMPlenrgbtable");
		return 0;
	}
	switch (class)
	{
	case C_WIN:
		lenrgb = 4;
		break;
	case C_OS2:
		lenrgb = 3;
		break;
	default:
		//pm_error(er_internal, "BMPlenrgbtable");
		return 0;
	}

	return (1 << bitcount) * lenrgb;
}

/*
 * length, in bytes, of a line of the image
 *
 * Evidently each row is padded on the right as needed to make it a
 * multiple of 4 bytes long.  This appears to be true of both
 * OS/2 and Windows BMP files.
 */
unsigned long
BMPlenline(class, bitcount, x)
	int             class;
	unsigned long   bitcount;
	unsigned long   x;
{
	unsigned long   bitsperline;

	switch (class)
	{
	case C_WIN:
		break;
	case C_OS2:
		break;
	default:
		//pm_error(er_internal, "BMPlenline");
		return 0;
	}

	bitsperline = x * bitcount;

	/*
	 * if bitsperline is not a multiple of 32, then round
	 * bitsperline up to the next multiple of 32.
	 */
	if ((bitsperline % 32) != 0)
	{
		bitsperline += (32 - (bitsperline % 32));
	}

	if ((bitsperline % 32) != 0)
	{
		//pm_error(er_internal, "BMPlenline");
		return 0;
	}

	/* number of bytes per line == bitsperline/8 */
	return bitsperline >> 3;
}

/* return the number of bytes used to store the image bits */
unsigned long
BMPlenbits(class, bitcount, x, y)
	int             class;
	unsigned long   bitcount;
	unsigned long   x;
	unsigned long   y;
{
	return y * BMPlenline(class, bitcount, x);
}

/* return the offset to the BMP image bits */
unsigned long
BMPoffbits(class, bitcount)
	int             class;
	unsigned long   bitcount;
{
	return BMPlenfileheader(class)
		+ BMPleninfoheader(class)
		+ BMPlenrgbtable(class, bitcount);
}

/* return the size of the BMP file in bytes */
unsigned long
BMPlenfile(class, bitcount, x, y)
	int             class;
	unsigned long   bitcount;
	unsigned long   x;
	unsigned long   y;
{
	return BMPoffbits(class, bitcount)
		+ BMPlenbits(class, bitcount, x, y);
}

colorhist_vector
ppm_computecolorhist( pixels, cols, rows, maxcolors, colorsP )
    lpixel** pixels;
    int cols, rows, maxcolors;
    int* colorsP;
    {
    colorhash_table cht;
    colorhist_vector chv;

    cht = ppm_computecolorhash( pixels, cols, rows, maxcolors, colorsP );
    if ( cht == (colorhash_table) 0 )
	return (colorhist_vector) 0;
    chv = ppm_colorhashtocolorhist( cht, maxcolors );
    ppm_freecolorhash( cht );
    return chv;
    }

colorhash_table
ppm_colorhisttocolorhash( chv, colors )
    colorhist_vector chv;
    int colors;
    {
    colorhash_table cht;
    int i, hash;
    lpixel color;
    colorhist_list chl;

    cht = ppm_alloccolorhash( );

    for ( i = 0; i < colors; ++i )
	{
	color = chv[i].color;
	hash = ppm_hashpixel( color );
	//for ( chl = cht[hash]; chl != (colorhist_list) 0; chl = chl->next )
	    //if ( PPM_EQUAL( chl->ch.color, color ) )
		//pm_error(
		//    "same color found twice - %d %d %d", PPM_GETR(color),
		//    PPM_GETG(color), PPM_GETB(color) );
	chl = (colorhist_list) malloc( sizeof(struct colorhist_list_item) );
	//if ( chl == (colorhist_list) 0 )
	    //pm_error( "out of memory" );
	chl->ch.color = color;
	chl->ch.value = i;
	chl->next = cht[hash];
	cht[hash] = chl;
	}

    return cht;
    }

int
ppm_lookupcolor( cht, colorP )
    colorhash_table cht;
    lpixel* colorP;
    {
    int hash;
    colorhist_list chl;

    hash = ppm_hashpixel( *colorP );
    for ( chl = cht[hash]; chl != (colorhist_list) 0; chl = chl->next )
    	if ( PPM_EQUAL( chl->ch.color, *colorP ) )
    	    return chl->ch.value;

    return -1;
    }

void
ppm_freecolorhash( cht )
    colorhash_table cht;
    {
    int i;
    colorhist_list chl, chlnext;

    for ( i = 0; i < HASHSIZE; ++i )
	for ( chl = cht[i]; chl != (colorhist_list) 0; chl = chlnext )
	    {
	    chlnext = chl->next;
	    free( (char*) chl );
	    }
    free( (char*) cht );
    }

/*---------------------------------------------------------------------------*/
/* This routine reads a rgb text file.  It stores the rgb values (0->65535)
   and the rgb mnemonics (malloc'ed) into the "rgbn" array.  Returns the
   number of entries stored in "rgbn_max". */
void
read_rgb_names(rgb_fname, rgbn, rgbn_max)
    char *rgb_fname;
    rgb_names *rgbn;
    int *rgbn_max;
{
    FILE *rgbf;
    int i, items, red, green, blue;
    char line[512], name[512], *rgbname;//, *n, *m;

    /* Open the rgb text file.  Abort if error. */
    if ((rgbf = fopen(rgb_fname, "r")) == NULL)
	//pm_error("error opening rgb text file \"%s\"", rgb_fname, 0, 0, 0, 0);
        exit(1);

    /* Loop reading each line in the file. */
    for (i = 0; fgets(line, sizeof(line), rgbf); i++) {

	/* Quit if rgb text file is too large. */
	if (i == MAX_RGBNAMES) {
	    fprintf(stderr,
	    "Too many entries in rgb text file, truncated to %d entries.\n",
		    MAX_RGBNAMES);
	    fflush(stderr);
	    break;
	}
	/* Read the line.  Skip if bad. */
	items = sscanf(line, "%d %d %d %[^\n]\n", &red, &green, &blue, name);
	if (items != 4) {
	    fprintf(stderr, "rgb text file syntax error on line %d\n", i + 1);
	    fflush(stderr);
	    i--;
	    continue;
	}
	/* Make sure rgb values are within 0->255 range.  Skip if bad. */
	if (red < 0 || red > 0xFF ||
	    green < 0 || green > 0xFF ||
	    blue < 0 || blue > 0xFF) {
	    fprintf(stderr, "rgb value for \"%s\" out of range, ignoring it\n",
		    name);
	    fflush(stderr);
	    i--;
	    continue;
	}
	/* Allocate memory for ascii name.  Abort if error. */
	if (!(rgbname = (char *) malloc(strlen(name) + 1)))
	    //pm_error("out of memory allocating rgb name", 0, 0, 0, 0, 0);
            exit(1);

#ifdef NAMESLOWCASE
	/* Copy string to ascii name and lowercase it. */
	for (n = name, m = rgbname; *n; n++)
	    *m++ = isupper(*n) ? tolower(*n) : *n;
	*m = '\0';
#else
	strcpy(rgbname, name);
#endif

	/* Save the rgb values and ascii name in the array. */
	rgbn[i].r = red << 8;
	rgbn[i].g = green << 8;
	rgbn[i].b = blue << 8;
	rgbn[i].name = rgbname;
    }

    /* Return the max number of rgb names. */
    *rgbn_max = i - 1;

    fclose(rgbf);

}					/* read_rgb_names */

/* This routine generates the character-pixel colormap table. */
void
gen_cmap(chv, ncolors, maxval, map_rgb_names, rgbn, rgbn_max,
	 cmap, charspp)
/* input: */
    colorhist_vector chv;		/* contains rgb values for colormap */
    int ncolors;			/* number of entries in colormap */
    pixval maxval;			/* largest color value, all rgb
					 * values relative to this, (pixval
					 * == unsigned short) */
    int map_rgb_names;			/* == 1 if mapping rgb values to rgb
					 * mnemonics */
    rgb_names *rgbn;                    /* rgb mnemonics from rgb text file */
int rgbn_max;				/* number of rgb mnemonics in table */

/* output: */
cixel_map *cmap;                        /* pixel strings and ascii rgb
					 * colors */
int *charspp;				/* characters per pixel */

{
    int i, j, base, cpp, mval, red, green, blue, r, g, b, matched;
    char *str;

    /*
     * Figure out how many characters per pixel we'll be using.  Don't want
     * to be forced to link with libm.a, so using a division loop rather
     * than a log function.
     */
    base = (int) HIGH_CHAR - (int) LOW_CHAR + 1;
    for (cpp = 0, j = ncolors; j; cpp++)
	j /= base;
    *charspp = cpp;

    /*
     * Determine how many hex digits we'll be normalizing to if the rgb
     * value doesn't match a color mnemonic.
     */
    mval = (int) maxval;
    if (mval <= 0x000F)
	mval = 0x000F;
    else if (mval <= 0x00FF)
	mval = 0x00FF;
    else if (mval <= 0x0FFF)
	mval = 0x0FFF;
    else
	mval = 0xFFFF;

    /*
     * Generate the character-pixel string and the rgb name for each
     * colormap entry.
     */
    for (i = 0; i < ncolors; i++) {

	/*
	 * The character-pixel string is simply a printed number in base
	 * "base" where the digits of the number range from LOW_CHAR to
	 * HIGH_CHAR and the printed length of the number is "cpp".
	 */
	cmap[i].cixel = gen_numstr(i, base, cpp);

	/* Fetch the rgb value of the current colormap entry. */
	red = PPM_GETR(chv[i].color);
	green = PPM_GETG(chv[i].color);
	blue = PPM_GETB(chv[i].color);

	/*
	 * If the ppm color components are not relative to 15, 255, 4095,
	 * 65535, normalize the color components here.
	 */
	if (mval != (int) maxval) {
	    red = (red * mval) / (int) maxval;
	    green = (green * mval) / (int) maxval;
	    blue = (blue * mval) / (int) maxval;
	}

	/*
	 * If the "-rgb <rgbfile>" option was specified, attempt to map the
	 * rgb value to a color mnemonic.
	 */
	if (map_rgb_names) {

	    /*
	     * The rgb values of the color mnemonics are normalized relative
	     * to 255 << 8, (i.e. 0xFF00).  [That's how the original MIT
	     * code did it, really should have been "v * 65535 / 255"
	     * instead of "v << 8", but have to use the same scheme here or
	     * else colors won't match...]  So, if our rgb values aren't
	     * already 16-bit values, need to shift left.
	     */
	    if (mval == 0x000F) {
		r = red << 12;
		g = green << 12;
		b = blue << 12;
		/* Special case hack for "white". */
		if (0xF000 == r && r == g && g == b)
		    r = g = b = 0xFF00;
	    } else if (mval == 0x00FF) {
		r = red << 8;
		g = green << 8;
		b = blue << 8;
	    } else if (mval == 0x0FFF) {
		r = red << 4;
		g = green << 4;
		b = blue << 4;
	    } else {
		r = red;
		g = green;
		b = blue;
	    }

	    /*
	     * Just perform a dumb linear search over the rgb values of the
	     * color mnemonics.  One could speed things up by sorting the
	     * rgb values and using a binary search, or building a hash
	     * table, etc...
	     */
	    for (matched = 0, j = 0; j <= rgbn_max; j++)
		if (r == rgbn[j].r && g == rgbn[j].g && b == rgbn[j].b) {

		    /* Matched.  Allocate string, copy mnemonic, and exit. */
		    if (!(str = (char *) malloc(strlen(rgbn[j].name) + 1)))
			//pm_error("out of memory", 0, 0, 0, 0, 0);
                        exit(1);
		    strcpy(str, rgbn[j].name);
		    cmap[i].rgbname = str;
		    matched = 1;
		    break;
		}
	    if (matched)
		continue;
	}

	/*
	 * Either not mapping to color mnemonics, or didn't find a match.
	 * Generate an absolute #RGB value string instead.
	 */
	if (!(str = (char *) malloc(mval == 0x000F ? 5 :
				    mval == 0x00FF ? 8 :
				    mval == 0x0FFF ? 11 :
				    14)))
	    //pm_error("out of memory", 0, 0, 0, 0, 0);
            exit(1);

//	if (red == 0 && green == 0 && blue == 0)
//		sprintf(str, "None");
//	else
		sprintf(str, mval == 0x000F ? "#%02X%02X%02X" :
			mval == 0x00FF ? "#%02X%02X%02X" :
			mval == 0x0FFF ? "#%03X%03X%03X" :
			"#%04X%04X%04X", red, green, blue);
	cmap[i].rgbname = str;
    }

}					/* gen_cmap */

colorhash_table
ppm_computecolorhash( pixels, cols, rows, maxcolors, colorsP )
    lpixel** pixels;
    int cols, rows, maxcolors;
    int* colorsP;
    {
    colorhash_table cht;
    register lpixel* pP;
    colorhist_list chl;
    int col, row, hash;

    cht = ppm_alloccolorhash( );
    *colorsP = 0;

    /* Go through the entire image, building a hash table of colors. */
    for ( row = 0; row < rows; ++row )
	for ( col = 0, pP = pixels[row]; col < cols; ++col, ++pP )
	    {
	    hash = ppm_hashpixel( *pP );
	    for ( chl = cht[hash]; chl != (colorhist_list) 0; chl = chl->next )
		if ( PPM_EQUAL( chl->ch.color, *pP ) )
		    break;
	    if ( chl != (colorhist_list) 0 )
		++(chl->ch.value);
	    else
		{
		if ( ++(*colorsP) > maxcolors )
		    {
		    ppm_freecolorhash( cht );
		    return (colorhash_table) 0;
		    }
		chl = (colorhist_list) malloc( sizeof(struct colorhist_list_item) );
		if ( chl == 0 )
		    //pm_error( "out of memory computing hash table" );
                    exit(1);
		chl->ch.color = *pP;
		chl->ch.value = 1;
		chl->next = cht[hash];
		cht[hash] = chl;
		}
	    }

    return cht;
    }

colorhash_table
ppm_alloccolorhash( )
    {
    colorhash_table cht;
    int i;

    cht = (colorhash_table) malloc( HASHSIZE * sizeof(colorhist_list) );
    if ( cht == 0 )
	//pm_error( "out of memory allocating hash table" );
        exit(1);

    for ( i = 0; i < HASHSIZE; ++i )
	cht[i] = (colorhist_list) 0;

    return cht;
    }

colorhist_vector
ppm_colorhashtocolorhist( cht, maxcolors )
    colorhash_table cht;
    int maxcolors;
    {
    colorhist_vector chv;
    colorhist_list chl;
    int i, j;

    /* Now collate the hash table into a simple colorhist array. */
    chv = (colorhist_vector) malloc( maxcolors * sizeof(struct colorhist_item) );
    /* (Leave room for expansion by caller.) */
    if ( chv == (colorhist_vector) 0 )
	//pm_error( "out of memory generating histogram" );
        exit(1);

    /* Loop through the hash table. */
    j = 0;
    for ( i = 0; i < HASHSIZE; ++i )
	for ( chl = cht[i]; chl != (colorhist_list) 0; chl = chl->next )
	    {
	    /* Add the new entry. */
	    chv[j] = chl->ch;
	    ++j;
	    }

    /* All done. */
    return chv;
    }

/* Given a number and a base, (base == HIGH_CHAR-LOW_CHAR+1), this routine
   prints the number into a malloc'ed string and returns it.  The length of
   the string is specified by "digits".  The ascii characters of the printed
   number range from LOW_CHAR to HIGH_CHAR.  The string is LOW_CHAR filled,
   (e.g. if LOW_CHAR==0, HIGH_CHAR==1, digits==5, i=3, routine would return
   the malloc'ed string "00011"). */
char *
gen_numstr(i, base, digits)
    int i, base, digits;
{
    char *str, *p;
    int d;

    /* Allocate memory for printed number.  Abort if error. */
    if (!(str = (char *) malloc(digits + 1)))
	//pm_error("out of memory", 0, 0, 0, 0, 0);
        exit(1);

    /* Generate characters starting with least significant digit. */
    p = str + digits;
    *p-- = '\0';			/* nul terminate string */
    while (p >= str) {
	d = i % base;
	i /= base;
	*p-- = (char) ((int) LOW_CHAR + d);
    }

    return str;

}					/* gen_numstr */


