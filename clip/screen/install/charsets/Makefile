all: gen_tbl
CFLAGS=-g

gen_tbl: gen_tbl.o
	$(CC) $(CFLAGS) -o gen_tbl gen_tbl.o

gen_tbl.o: gen_tbl.c


clean:
	rm -f gen_tbl *.o *.b *.bak *.BAK
