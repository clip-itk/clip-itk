CC = gcc
OBJS = coll.o list.o hash.o
LIBOBJS = task.o
LIB = task.a
PROGS = task_tst
CFLAGS = -O -g -Wall -I..
LINKS = coll.h coll.c list.h list.c hash.h hash.c

all: $(LIB)

$(LIB): $(LIBOBJS)
	rm -f $(LIB)
	ar -r $(LIB) $(LIBOBJS)
	ranlib $(LIB)

test: $(PROGS)

task.c: task.h taskcfg.h

taskcfg.h:
	./configure

task_tst: $(OBJS) task_tst.o $(LIB)
	$(CC) $(CFLAGS) -o task_tst task_tst.o $(OBJS) $(LIB)

links:
	for i in $(LINKS) ; do ln -sf ../$$i . ; done

clean:
	rm -f $(PROGS) *.o core *.bak *.BAK *.a
	rm -f taskcfg.h
	rm -f $(LINKS)

distclean: clean

