ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b -w -n -l
OBJS = cgi_funcs.o an_funcs.o \
	classes_xml.o classes_rdf.o addinfo.o \
	acc_log.o balance.o \
	connect.o delobj.o memo.o getfile.o obj_arr.o \
	obj_rass.o print.o rdfinfo3.o \
	an_rdf3.o odfreport.o \
	rdf_sell.o rdfarr.o bind2.o \
	report1.o report3.o report4.o report5.o report6.o \
	report7.o report8.o

#rdfinfo2.o  balance2.o

OBJS2 = accpost.o bind.o

R2D2LIB = libclip-r2d2.a
R2D2FLIB = libclip-r2d2$(DLLSUFF)
R2D2FLIBREAL = libclip-r2d2$(DLLREALSUFF)

.SUFFIXES: .prg .o .po

all:    $(R2D2FLIB)

$(R2D2FLIB): $(OBJS)
	$(CLIPROOT)/bin/clip_makelib $(R2D2LIB) $(OBJS)
#	$(CLIPROOT)/bin/clip_makeslib $(R2D2FLIB) $(R2D2LIB) $(C_LIBS)
	$(CLIPROOT)/bin/clip_makeslib $(R2D2FLIB)  $(OBJS)

clean:
	rm -f *.c *.s *.o *.po *.log *.bak *.a *.so *.ex *.nm

install: $(R2D2FLIB)
	$(CLIPROOT)/bin/clip_cp $(R2D2LIB) $(DESTDIR)$(CLIPROOT)/lib
	$(CLIPROOT)/bin/clip_cp $(R2D2FLIB) $(DESTDIR)$(CLIPROOT)/lib
	chmod 0755 $(DESTDIR)$(CLIPROOT)/lib/$(R2D2FLIB)
	cp ./r2d2lib.ch $(DESTDIR)$(CLIPROOT)/include

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<


