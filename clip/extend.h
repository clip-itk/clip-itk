/***
*	extend.h
* Определения Системы Расширения Clipper 5.0 для языка C.
* Copyright (c) 1987,1988,1989,1990 Nantucket Corp.  Все права сохраняются.
*
* Clipper использует соглашения большой модели памяти Microsoft C (large model)
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
#define MPTR    32		/* OR с типом при передаче по ссылке */
#define MEMO		65
#define WORD		128
#define ARRAY		512

#endif

/* количество/тип параметров */
extern int _parinfo(int);
extern int _parinfa(int, unsigned int);

/* значения параметров */
extern char *_parc(int,...);
extern unsigned int _parcsiz(int,...);
extern unsigned int _parclen(int,...);
extern int _parni(int,...);
extern long _parnl(int,...);
extern XDOUBLE _parnd(int,...);
extern int _parl(int,...);
extern char *_pards(int,...);

/* возврат значения */
extern void _retc(char far *);
extern void _retclen(char far *, unsigned int);
extern void _retni(int);
extern void _retnl(long);
extern void _retnd(XDOUBLE);
extern void _retl(int);
extern void _retds(char far *);

/* нет возвращаемого значения (возврат NIL) */
extern void _ret(void);

/* запись значения */
int _storc(char far *, int,...);
int _storclen(char far *, int,...);
int _storni(int, int,...);
int _stornl(long, int,...);
int _stornd(XDOUBLE, int,...);
int _storl(int, int,...);
int _stords(char far *, int,...);

/***
* Замечание:
* _xalloc() возвращает NULL при невозможности удовлетворения запроса
* _xgrab() формирует сообщение об ошибке при невозможности удовлетворения запроса
*/

/*  распределение памяти */
extern void far *_xalloc(unsigned int numberOfBytes);
extern void far *_xgrab(unsigned int numberOfBytes);
extern void _xfree(void far * allocatedBlock);

/* совместимость с Summer '87 */
#define _exmgrab(size)			_xgrab(size)
#define _exmback(ptr, size)		_xfree(ptr)

/* макросы для проверки параметров */
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
