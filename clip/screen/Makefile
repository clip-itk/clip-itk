#CC=gcc
CFLAGS=-Wall -O -g #-pg -DMEMDBG

SCRLIB = ./libscr.a
SCROBJS = tcaps.o termgoto.o screen.o scankey.o keymap.o
# charset.o

PROGS = testscr kbd cmap

all: $(SCRLIB) $(PROGS)

KBDOBJS = scankey.o keymap.o kbd.o

kbd: $(KBDOBJS)
	$(CC) $(CFLAGS) -o kbd $(KBDOBJS)

CMAPOBJS = charset.o cmap.o

cmap:	$(CMAPOBJS)
	$(CC) $(CFLAGS) -o cmap $(CMAPOBJS)

clean:
	rm -f *.o *.bak *.b *.BAK *.a $(PROGS) $(SCRLIB)

testscr: testscr.o  Makefile $(SCRLIB) charset.o
	$(CC) $(CFLAGS) -o testscr testscr.o $(SCRLIB) charset.o -lgpm



$(SCRLIB): $(SCROBJS)
	rm -f $(SCRLIB)
	ar -q $(SCRLIB) $(SCROBJS) && ranlib $(SCRLIB)

