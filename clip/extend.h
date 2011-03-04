/***
*	extend.h
* Definitions of System Exstentions Clipper 5.0 for C.
* Copyright (c) 1987,1988,1989,1990 Nantucket Corp.  All rights reserved.
*
* Clipper used large memory model by Microsoft C
*/

#ifndef EXTEND_H
#define EXTEND_H

#ifndef CLIPPERDEFS

#define CLIPPER		void
#define far

#define FALSE	0
#define TRUE	1

#define NIL		'\0'
#define NULL	0L

typedef unsigned char byte;
typedef unsigned int quant;
typedef int Boolean;
typedef double XDOUBLE;

#define CLIPPERDEFS
#endif

#ifndef CLIP_H

#define UNDEF		0
#define CHARACTER	1
#define NUMERIC		2
#define LOGICAL		4
#define DATE		8
#define ALIAS		16
#define MPTR    32		/* OR with type while transmitted by reference */
#define MEMO		65
#define WORD		128
#define ARRAY		512

#endif

/* parameters count/type */
extern int _parinfo(int);
extern int _parinfa(int, unsigned int);

/* parameters values */
extern char *_parc(int,...);
extern unsigned int _parcsiz(int,...);
extern unsigned int _parclen(int,...);
extern int _parni(int,...);
extern long _parnl(int,...);
extern XDOUBLE _parnd(int,...);
extern int _parl(int,...);
extern char *_pards(int,...);

/* return values */
extern void _retc(char far *);
extern void _retclen(char far *, unsigned int);
extern void _retni(int);
extern void _retnl(long);
extern void _retnd(XDOUBLE);
extern void _retl(int);
extern void _retds(char far *);

/* no returned values (returns NIL) */
extern void _ret(void);

/* record values */
int _storc(char far *, int,...);
int _storclen(char far *, int,...);
int _storni(int, int,...);
int _stornl(long, int,...);
int _stornd(XDOUBLE, int,...);
int _storl(int, int,...);
int _stords(char far *, int,...);

/***
* Remark:
* _xalloc() returns NULL if request can't be satisfied
* _xgrab()  generates an error message if request can't be satisfied
*/

/*  memory allocation */
extern void far *_xalloc(unsigned int numberOfBytes);
extern void far *_xgrab(unsigned int numberOfBytes);
extern void _xfree(void far * allocatedBlock);

/* compability with '87 */
#define _exmgrab(size)			_xgrab(size)
#define _exmback(ptr, size)		_xfree(ptr)

/* macroses for parameters checking */
#define PCOUNT		(_parinfo(0))
#define ISCHAR(n)	(_parinfo(n) & CHARACTER)
#define ISNUM(n)	(_parinfo(n) & NUMERIC)
#define ISLOG(n)	(_parinfo(n) & LOGICAL)
#define ISDATE(n)	(_parinfo(n) & DATE)
#define ISMEMO(n)	(_parinfo(n) & MEMO)
#define ISBYREF(n)	(_parinfo(n) & MPTR)
#define ISARRAY(n)	(_parinfo(n) & ARRAY)
#define ALENGTH(n)	(_parinfa(n, 0))

#endif
