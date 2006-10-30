#ifndef BISON_CLIC_TAB_H
# define BISON_CLIC_TAB_H

#ifndef YYSTYPE
typedef union
{
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
} yystype;
# define YYSTYPE yystype
# define YYSTYPE_IS_TRIVIAL 1
#endif
# define	STRING	257
# define	NUMBER	258
# define	ISTRING	259
# define	NAME	260
# define	CTEXT	261
# define	DATE	262
# define	KEYS	263
# define	PREPROC	264
# define	RETURN	265
# define	FUNCTION	266
# define	PROCEDURE	267
# define	IPROCEDURE	268
# define	EPROCEDURE	269
# define	EXTERN	270
# define	PARAMETERS	271
# define	SFUNCTION	272
# define	SPROCEDURE	273
# define	TEXT	274
# define	PUBLIC	275
# define	PRIVATE	276
# define	STATIC	277
# define	LOCAL	278
# define	DIMENSION	279
# define	NIL	280
# define	END	281
# define	TRUE	282
# define	FALSE	283
# define	WHILE	284
# define	DO	285
# define	ENDDO	286
# define	EXIT	287
# define	LOOP	288
# define	WITH	289
# define	CALL	290
# define	IF	291
# define	IIF	292
# define	ENDIF	293
# define	ELSE	294
# define	ELSEIF	295
# define	DOCASE	296
# define	CASE	297
# define	OTHERWISE	298
# define	ENDCASE	299
# define	SWITCH	300
# define	ENDSWITCH	301
# define	FIELD	302
# define	MEMVAR	303
# define	IN	304
# define	MEMVARPTR	305
# define	FIELDPTR	306
# define	PCOUNT	307
# define	PARBEG	308
# define	PARAMBEG	309
# define	PSHIFT	310
# define	PALL	311
# define	CGET	312
# define	FOR	313
# define	STEP	314
# define	TO	315
# define	NEXT	316
# define	FOREACH	317
# define	BEGSEQ	318
# define	RECOVER	319
# define	USING	320
# define	BREAK	321
# define	EBREAK	322
# define	ANNOUNCE	323
# define	REQUEST	324
# define	IFNL	325
# define	IFEXPR	326
# define	CODESTR	327
# define	CODEBLOCK	328
# define	AS	329
# define	REF	330
# define	ASSIGN	331
# define	ADDA	332
# define	SUBA	333
# define	DIVA	334
# define	MODA	335
# define	MULA	336
# define	POWA	337
# define	POSTINCR	338
# define	OR	339
# define	AND	340
# define	NOT	341
# define	GE	342
# define	LE	343
# define	EQ	344
# define	NE	345
# define	POW	346
# define	MINUS	347
# define	INCR	348
# define	DECR	349
# define	RPTR	350
# define	REPTR	351
# define	DSEMICOLON	352


extern YYSTYPE yylval;

#endif /* not BISON_CLIC_TAB_H */
