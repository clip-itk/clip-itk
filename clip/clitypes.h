/*
 * $Log$
 * Revision 1.1  2006/06/22 19:35:16  itk
 * uri: init sf.net repository
 *
 * Revision 1.4  2002/04/15 12:25:58  clip
 * Changes from Alexander S.Kresin <alex@belacy.belgorod.su>
 * paul
 *
 * Revision 1.3  2002/04/12 09:34:06  clip
 * long long fix
 * paul
 *
 * Revision 1.2  2000/05/24 18:34:19  clip
 * _clip_push_area
 * indents all
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.1  1999/10/25 16:39:28  paul
 * first entry
 *
 */

#ifndef YTYPES_H
#define YTYPES_H

typedef unsigned char Uchar;
typedef unsigned int Uint;
typedef unsigned short Ushort;
typedef unsigned long Ulong;

#if defined(__GNUC__)
	typedef long long llong;
	typedef unsigned long long Ullong;
#else
	typedef __int64 llong;
	typedef unsigned __int64 Ullong;
#endif


typedef struct
{
	long hash;
	long offs;
}
OffsEntry;

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))
#define VAR(type,var,ini) type *var=(type*)(ini)
#define NEWVAR(type,var) type *var=(type*)calloc(sizeof(type),1)

#endif
