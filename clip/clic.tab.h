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
     ISTRING = 260,
     NAME = 261,
     CTEXT = 262,
     DATE = 263,
     KEYS = 264,
     PREPROC = 265,
     RETURN = 266,
     FUNCTION = 267,
     PROCEDURE = 268,
     IPROCEDURE = 269,
     EPROCEDURE = 270,
     EXTERN = 271,
     PARAMETERS = 272,
     SFUNCTION = 273,
     SPROCEDURE = 274,
     TEXT = 275,
     PUBLIC = 276,
     PRIVATE = 277,
     STATIC = 278,
     LOCAL = 279,
     DIMENSION = 280,
     NIL = 281,
     END = 282,
     TRUE = 283,
     FALSE = 284,
     WHILE = 285,
     DO = 286,
     ENDDO = 287,
     EXIT = 288,
     LOOP = 289,
     WITH = 290,
     CALL = 291,
     IF = 292,
     IIF = 293,
     ENDIF = 294,
     ELSE = 295,
     ELSEIF = 296,
     DOCASE = 297,
     CASE = 298,
     OTHERWISE = 299,
     ENDCASE = 300,
     SWITCH = 301,
     ENDSWITCH = 302,
     FIELD = 303,
     MEMVAR = 304,
     IN = 305,
     MEMVARPTR = 306,
     FIELDPTR = 307,
     PCOUNT = 308,
     PARBEG = 309,
     PARAMBEG = 310,
     PSHIFT = 311,
     PALL = 312,
     CGET = 313,
     FOR = 314,
     STEP = 315,
     TO = 316,
     NEXT = 317,
     FOREACH = 318,
     BEGSEQ = 319,
     RECOVER = 320,
     USING = 321,
     BREAK = 322,
     EBREAK = 323,
     ANNOUNCE = 324,
     REQUEST = 325,
     IFNL = 326,
     IFEXPR = 327,
     CODESTR = 328,
     CODEBLOCK = 329,
     AS = 330,
     REF = 331,
     POWA = 332,
     MULA = 333,
     MODA = 334,
     DIVA = 335,
     SUBA = 336,
     ADDA = 337,
     ASSIGN = 338,
     POSTINCR = 339,
     OR = 340,
     AND = 341,
     NOT = 342,
     NE = 343,
     EQ = 344,
     LE = 345,
     GE = 346,
     POW = 347,
     MINUS = 348,
     DECR = 349,
     INCR = 350,
     REPTR = 351,
     RPTR = 352,
     DSEMICOLON = 353
   };
#endif
#define STRING 258
#define NUMBER 259
#define ISTRING 260
#define NAME 261
#define CTEXT 262
#define DATE 263
#define KEYS 264
#define PREPROC 265
#define RETURN 266
#define FUNCTION 267
#define PROCEDURE 268
#define IPROCEDURE 269
#define EPROCEDURE 270
#define EXTERN 271
#define PARAMETERS 272
#define SFUNCTION 273
#define SPROCEDURE 274
#define TEXT 275
#define PUBLIC 276
#define PRIVATE 277
#define STATIC 278
#define LOCAL 279
#define DIMENSION 280
#define NIL 281
#define END 282
#define TRUE 283
#define FALSE 284
#define WHILE 285
#define DO 286
#define ENDDO 287
#define EXIT 288
#define LOOP 289
#define WITH 290
#define CALL 291
#define IF 292
#define IIF 293
#define ENDIF 294
#define ELSE 295
#define ELSEIF 296
#define DOCASE 297
#define CASE 298
#define OTHERWISE 299
#define ENDCASE 300
#define SWITCH 301
#define ENDSWITCH 302
#define FIELD 303
#define MEMVAR 304
#define IN 305
#define MEMVARPTR 306
#define FIELDPTR 307
#define PCOUNT 308
#define PARBEG 309
#define PARAMBEG 310
#define PSHIFT 311
#define PALL 312
#define CGET 313
#define FOR 314
#define STEP 315
#define TO 316
#define NEXT 317
#define FOREACH 318
#define BEGSEQ 319
#define RECOVER 320
#define USING 321
#define BREAK 322
#define EBREAK 323
#define ANNOUNCE 324
#define REQUEST 325
#define IFNL 326
#define IFEXPR 327
#define CODESTR 328
#define CODEBLOCK 329
#define AS 330
#define REF 331
#define POWA 332
#define MULA 333
#define MODA 334
#define DIVA 335
#define SUBA 336
#define ADDA 337
#define ASSIGN 338
#define POSTINCR 339
#define OR 340
#define AND 341
#define NOT 342
#define NE 343
#define EQ 344
#define LE 345
#define GE 346
#define POW 347
#define MINUS 348
#define DECR 349
#define INCR 350
#define REPTR 351
#define RPTR 352
#define DSEMICOLON 353




#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 429 "clic.y"
typedef union YYSTYPE {
	char *string;
	void *ptr;
	Coll *coll;
	struct {
		Coll *coll;
		int haveRest;
	} arglist;
	VarColl *varcoll;
	Var *var;
	List *list;
	Node *node;
	Function *func;
	int i;
	struct
	{
		int curseq;
		Node *using;
		Node *operlist;
	}
	recover;
	SwitchEl *switchel;
} YYSTYPE;
/* Line 1318 of yacc.c.  */
#line 257 "clic.tab.h"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;



