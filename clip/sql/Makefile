# set appropriate paths between comments
########

CC = gcc
CLIP = ../clip -I../include -I..

CFLAGS += -I./.. -Wall -Wextra -I../rdd -I../include

DBFSQLLIB = libdbfsql.a

all: $(DBFSQLLIB)

clean:
	rm -f *.o *.a *.b *.bak *.BAK *.tmp \
	dbfsql_prg_ref.c dbfsql_prg.c dbfsql_prg.log \
	$(DBFSQLLIB)
	rm -rf *.ex *.nm

dbfsql_c.o: dbfsql_c.c

dbfsql_prg.o: dbfsql_prg.prg
	$(CLIP) -l dbfsql_prg.prg

$(DBFSQLLIB): dbfsql_c.o dbfsql_prg.o
	rm -f $(DBFSQLLIB)
	../clip_makelib $(DBFSQLLIB) dbfsql_c.o dbfsql_prg.o && ranlib $(DBFSQLLIB)

