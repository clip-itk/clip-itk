/* A Bison parser, made by GNU Bison 2.0.  */

/* Skeleton parser for Yacc-like parsing with Bison,
   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     STRING = 258,
     NUMBER = 259,
     NAME = 260,
     RPTR = 261,
     FIELD_PTR = 262,
     MEMVAR_PTR = 263,
     TRUE = 264,
     FALSE = 265,
     NIL = 266,
     PCOUNT = 267,
     PARAM = 268,
     IF = 269,
     RDDBEG = 270,
     RDDEND = 271,
     POWA = 272,
     MULA = 273,
     MODA = 274,
     DIVA = 275,
     SUBA = 276,
     ADDA = 277,
     ASSIGN = 278,
     POSTINCR = 279,
     OR = 280,
     AND = 281,
     NOT = 282,
     NE = 283,
     EQ = 284,
     LE = 285,
     GE = 286,
     POW = 287,
     DECR = 288,
     INCR = 289,
     MINUS = 290
   };
#endif
#define STRING 258
#define NUMBER 259
#define NAME 260
#define RPTR 261
#define FIELD_PTR 262
#define MEMVAR_PTR 263
#define TRUE 264
#define FALSE 265
#define NIL 266
#define PCOUNT 267
#define PARAM 268
#define IF 269
#define RDDBEG 270
#define RDDEND 271
#define POWA 272
#define MULA 273
#define MODA 274
#define DIVA 275
#define SUBA 276
#define ADDA 277
#define ASSIGN 278
#define POSTINCR 279
#define OR 280
#define AND 281
#define NOT 282
#define NE 283
#define EQ 284
#define LE 285
#define GE 286
#define POW 287
#define DECR 288
#define INCR 289
#define MINUS 290




#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 405 "rt.y"
typedef union YYSTYPE {
	struct {
		char *beg;
		char *end;
	} string;
	long Long;
	struct {
		double d;
		unsigned char len;
		unsigned char dec;
	} Double;
	Function *func;
	struct {
		long *vect;
		int count;
	} longvect;
	struct {
		long hash;
		int memvar;
	} name;
	struct {
		int pos;
		int i;
	} pos;
	int i;
} YYSTYPE;
/* Line 1318 of yacc.c.  */
#line 134 "rt.tab.h"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif





