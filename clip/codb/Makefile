include ../Makefile.inc
CLIP	= ../clip
CLIPFLAGS = -l -a -w -O -n -I . -I .. -I ../include
CLIPFLAGS2 =
CFLAGS = -I.. -I../include -I$(CLIPROOT)
CLIPLIBS  =
OBJS  = codb_list.o dict_dbf.o dep_dbf.o ext_dbf.o list_id.o codb_funcs.o \
	count_dbf.o codb_dep.o codb_dict.o codb.o codb_oql.o codb_install.o \
	codb_err.o codb_cache.o
.SUFFIXES: .prg .o .po

LIB = libclip-codb.a
SLIB = libclip-codb$(DLLSUFF)

export CFLAGS

all:    $(OBJS) $(LIB) $(SLIB)
#	../clip_makelib libclip-codb.a $(OBJS)
#	../clip_makeslib libclip-codb $(OBJS)
#	rm -rf *.c

clean:
	rm -rf *.exe *.o *.c *.s *.a *.so *.po *.ppo *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core codb_mk clip_ab test
	rm -rf *.ex *.nm

install: all
	clip_cp libclip-codb $(CLIPROOT)/lib

codb.o: codb.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) codb.prg

codb_list.o: codb_list.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) codb_list.prg

codb_dep.o: codb_dep.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) codb_dep.prg

codb_dict.o: codb_dict.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) codb_dict.prg

codb_funcs.o: codb_funcs.prg
	$(CLIP) $(CLIPFLAGS) codb_funcs.prg

codb_err.o: codb_err.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) codb_err.prg

codb_cache.o: codb_cache.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) codb_cache.prg

dict_dbf.o: dict_dbf.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) dict_dbf.prg

dep_dbf.o: dep_dbf.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) dep_dbf.prg

ext_dbf.o: ext_dbf.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) ext_dbf.prg

count_dbf.o: count_dbf.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) count_dbf.prg

list_id.o: list_id.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) list_id.prg

$(LIB): $(OBJS)
	rm -f $(LIB)
	../clip_makelib $(LIB) $(OBJS)

$(SLIB): $(LIB)
	../clip_makeslib $(SLIB) $(LIB)

.prg.o:
	$(CLIP) $(CLIPFLAGS) $(CLIPFLAGS2) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

