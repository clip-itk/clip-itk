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
# define	FOR	312
# define	STEP	313
# define	TO	314
# define	NEXT	315
# define	FOREACH	316
# define	BEGSEQ	317
# define	RECOVER	318
# define	USING	319
# define	BREAK	320
# define	EBREAK	321
# define	ANNOUNCE	322
# define	REQUEST	323
# define	IFNL	324
# define	IFEXPR	325
# define	CODESTR	326
# define	CODEBLOCK	327
# define	AS	328
# define	REF	329
# define	ASSIGN	330
# define	ADDA	331
# define	SUBA	332
# define	DIVA	333
# define	MODA	334
# define	MULA	335
# define	POWA	336
# define	POSTINCR	337
# define	OR	338
# define	AND	339
# define	NOT	340
# define	GE	341
# define	LE	342
# define	EQ	343
# define	NE	344
# define	POW	345
# define	MINUS	346
# define	INCR	347
# define	DECR	348
# define	RPTR	349
# define	REPTR	350
# define	DSEMICOLON	351


extern YYSTYPE yylval;

#endif /* not BISON_CLIC_TAB_H */
