CC = gcc
CFLAGS += -I.. -I../include
LIB = librdd.a
OBJS = rddclip.o rdd.o dbf.o ntx.o cdx.o dbt.o fpt.o rushmore.o btree.o six.o hiper.o

all:	$(LIB)

clean:
	rm -f *.o *.a *.b *.bak *.BAK *.tmp \
	test_ref.c test.c test.log \
	*.dbf *.ntx *.cdx *.dbt *.fpt \
	$(LIB) test

$(LIB): $(OBJS)
	rm -f $(LIB)
	../clip_makelib $(LIB) $(OBJS) && ranlib $(LIB)

rddclip.o:	rddclip.c ../rdd.h
rdd.o:		rdd.c ../rdd.h
dbf.o:		dbf.c ../rdd.h
ntx.o:		ntx.c ../rdd.h
cdx.o:		cdx.c ../rdd.h
dbt.o:		dbt.c ../rdd.h
fpt.o:		fpt.c ../rdd.h
rushmore.o:	rushmore.c ../rdd.h
btree.o:	btree.c btree.h
six.o:		six.c ../rdd.h ../include/six.ch
hiper.o:	hiper.c ../rdd.h btree.h

test: test.prg rddclip.o rdd.o dbf.o ntx.o cdx.o dbt.o fpt.o rushmore.o btree.o six.o hiper.o ../clipbase.h ../clipbase.c ../libclip.a
	clip -e -R test.prg
