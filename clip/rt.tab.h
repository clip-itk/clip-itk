#ifndef BISON_RT_TAB_H
# define BISON_RT_TAB_H

#ifndef YYSTYPE
typedef union
{
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
} yystype;
# define YYSTYPE yystype
# define YYSTYPE_IS_TRIVIAL 1
#endif
# define	STRING	257
# define	NUMBER	258
# define	NAME	259
# define	RPTR	260
# define	FIELD_PTR	261
# define	MEMVAR_PTR	262
# define	TRUE	263
# define	FALSE	264
# define	NIL	265
# define	PCOUNT	266
# define	PARAM	267
# define	IF	268
# define	RDDBEG	269
# define	RDDEND	270
# define	ASSIGN	271
# define	ADDA	272
# define	SUBA	273
# define	DIVA	274
# define	MODA	275
# define	MULA	276
# define	POWA	277
# define	POSTINCR	278
# define	OR	279
# define	AND	280
# define	NOT	281
# define	GE	282
# define	LE	283
# define	EQ	284
# define	NE	285
# define	POW	286
# define	INCR	287
# define	DECR	288
# define	MINUS	289


#endif /* not BISON_RT_TAB_H */
