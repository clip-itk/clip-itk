/*
$Log: ntx.h,v $
Revision 1.2  1999/10/26 19:19:17  axl
start cvs logging (./dbf)

*/

#ifndef NTX_H
#define NTX_H

typedef struct
{
	unsigned char signature[2];
	unsigned char version[2];
	unsigned char root[4];
	unsigned char empty[4];
	unsigned char item_size[2];
	unsigned char key_size[2];
	unsigned char key_dec[2];
	unsigned char max_items[2];
	unsigned char half_page[2];
	unsigned char key_expr[256];
	unsigned char unique;
}
NtxHeader;

typedef struct
{
	unsigned char count[2];
	unsigned char ref[2];
}
NtxPage;

typedef struct
{
	unsigned char next[4];
}
NtxFreePage;

typedef struct
{
	unsigned char page[4];
	unsigned char record[4];
	unsigned char key[1];
}
NtxBucket;

#endif
