/*
$Log: idx.h,v $
Revision 1.4  2000/05/18 20:36:27  clip
fix dbseek for empty expression
continue idx RDD
Alex Vorontsov <axl@itk.ru>

Revision 1.3  2000/05/18 19:23:51  clip
fix dbselectarea, make dbunlockall
continue idx RDD

Revision 1.2  2000/02/13 16:58:26  axl
fix exclusive locking (not locking :)

Revision 1.1  2000/01/14 18:15:45  axl
start cvs logging

*/

#ifndef IDX_H
#define IDX_H

#define	IDX_UNIQUE	0x1
#define	IDX_FOREXPR	0x8
#define	IDX_COMPACT	0x20
#define	IDX_COMPAUND	0x40

#define IDX_KEY_NODE	0x0
#define IDX_KEY_ROOT	0x1
#define IDX_KEY_LEAF	0x2

#define	IDX_HEADER_SIZE	1024
#define	IDX_PAGE_SIZE	512

#define	IDX_INDEX_OFFS	12
#define	IDX_LEAF_OFFS	24

typedef struct
{
	unsigned char root[4];
	unsigned char empty[4];
	unsigned char version[4];
	unsigned char key_size[2];
	unsigned char options;
	unsigned char signature;
	unsigned char reserv1[486];
	unsigned char order[2];
	unsigned char total_len[2];
	unsigned char for_len[2];
	unsigned char reserv2[2];
	unsigned char key_len[2];
	unsigned char expr[512];
}
IdxHeader;

typedef struct
{
	/* Common items */
	unsigned char attr[2];
	unsigned char count[2];
	unsigned char left[4];
	unsigned char right[4];
	/* Next items only for LEAF PAGE */
	unsigned char free[2];
	unsigned char rmask[4];
	unsigned char dmask;
	unsigned char tmask;
	unsigned char rbits;
	unsigned char dbits;
	unsigned char tbits;
	unsigned char keybytes;	/* Packed bytes */
}
IdxPage;

/* For LEAF PAGE */
typedef struct
{
	unsigned long record;	/* rbits */
	unsigned int dup;	/* dbits */
	unsigned int trail;	/* tbits */
}
IdxBucket;

#endif
