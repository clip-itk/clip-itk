LIBS = -lwrap
CC = gcc
CFLAGS = -O

all: tcp-wrap

tcp-wrap: tcp-wrap.c
	$(CC) $(CFLAGS) -o tcp-wrap tcp-wrap.c $(LIBS)

clean:
	rm -f tcp-wrap *.bak *.o

