#CC = gcc
CFLAGS += -g -Wimplicit-decl -Wall -O2
LIB = libmapbase.a
OBJS = mapfile.o btree.o listfile.o

all:	$(LIB) mtest

clean:
	rm -f *.o *.a mtest *.b *.bak *.BAK core *.db *.btree

$(LIB): $(OBJS)
	rm -f $(LIB)
	ar q $(LIB) $(OBJS) && ranlib $(LIB)

mtest:	mtest.o $(LIB)
	$(CC) $(CFLAGS) -o mtest mtest.o $(LIB)

.SUFFIXES: .c

.c.o:
	$(CC) -fpic $(CFLAGS) -c $<

