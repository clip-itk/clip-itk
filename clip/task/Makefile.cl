CC = gcc
OBJS = ../coll.o ../list.o ../hash.o
LIBOBJS = cl_task.o
LIB = task.a
PROGS = cl_tst
CFLAGS = -O -g -Wall -fPIC 
LINKS = coll.h coll.c list.h list.c hash.h hash.c

all: $(LIB)

lib: $(LIB)
$(LIB): $(LIBOBJS)
	rm -f $(LIB)
	ar -r $(LIB) $(LIBOBJS)
	ranlib $(LIB)

std_test: test
test: $(PROGS)

cl_task.c: task.h cl_cfg.h

cl_cfg.h:
	./configure

cl_tst: $(OBJS) cl_tst.o $(LIB)
	$(CC) $(CFLAGS) -o cl_tst cl_tst.o $(OBJS) $(LIB)
	
task_tst: $(OBJS) $(LIB) task_tst.c
	$(CC) $(CFLAGS)task_tst.c  -o task_tst $(OBJS) $(LIB)	

links:
	for i in $(LINKS) ; do ln -sf ../$$i . ; done

clean:
	cp Makefile.empty Makefile
	rm -f $(LIB) $(PROGS) task_tst *.o core *.bak *.BAK *.a
	rm -f USE*
	rm -f cl_cfg.h
	rm -f $(LINKS)

distclean: clean

