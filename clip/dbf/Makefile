#CC = gcc
CFLAGS += -g -Wimplicit-decl -Wall #-O2
YACC = bison
MLIB = ../mapfile/libmapbase.a
LIB = libdbf.a
OBJS = dbf.o ntx.o dbfrt.tab.o mem.o dbt.o idx.o
SRCS = dbf.c ntx.c mem.c dbt.c idx.c
PROGS = dtest ntxdump dbfview datest memtest itest pr
BASES = *.ntx test.dbf test.dbt


all:	$(LIB) $(PROGS)

depend:
	makedepend -Y $(SRCS)

clean:
	rm -f *.o *.a $(PROGS) *.b *.bak *.BAK core $(BASES)

$(LIB): $(OBJS)
	rm -f $(LIB)
	ar q $(LIB) $(OBJS) && ranlib $(LIB)

pr:	pr.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o pr pr.o $(LIB) $(MLIB) -lm
	rm -f  $(BASES)

dtest:	dtest.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o dtest dtest.o $(LIB) $(MLIB) -lm
	rm -f  $(BASES)

itest:	itest.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o itest itest.o $(LIB) $(MLIB) -lm
	rm -f  $(BASES)

itest2:	itest2.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o itest2 itest2.o $(LIB) $(MLIB) -lm
	rm -f  $(BASES)

datest:	datest.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o datest datest.o $(LIB) $(MLIB) -lm

memtest: memtest.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o memtest memtest.o $(LIB) $(MLIB) -lm

ntxdump: ntxdump.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o ntxdump ntxdump.o $(LIB) $(MLIB)

idxdump: idxdump.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o idxdump idxdump.o $(LIB) $(MLIB)

dbfview: dbfview.o $(LIB) $(MLIB)
	$(CC) $(CFLAGS) -o dbfview dbfview.o $(LIB) $(MLIB) -lm

.SUFFIXES: .c

.c.o:
	$(CC) -fpic $(CFLAGS) -c $<

dbfrt.tab.c: dbfrt.y dbf.h dbfpriv.h
	$(YACC) -bdbfrt -pdbf -d dbfrt.y

# DO NOT DELETE

dbf.o: mapfile.h dbfpriv.h dbf.h
ntx.o: dbfpriv.h dbf.h mapfile.h ntx.h
mem.o: dbf.h
dbt.o: dbfpriv.h dbf.h mapfile.h
