ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
#CLIP	= clip
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b -l
CLIPLIBS  =
OBJS  = init.o cld_obj.o menu.o command.o source.o values.o viewset.o viewali.o monitor.o
POBJS  = init.o cld_obj.po menu.po command.po source.po values.po viewset.po viewali.po monitor.po
.SUFFIXES: .prg .o .po

all: clip_cld

clean:
	rm -rf *.exe *.o *.c *.a *.so *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core clip_cld test
	rm -rf *.ex *.nm

clip_cld:$(OBJS)
	$(CLIP) $(CLIPFLAGS) -s -e -M clip_cld.prg $(OBJS) $(CLIPLIBS)

install:
	cp clip_cld$(EXESUFF) $(CLIPROOT)/bin

test:
	$(CLIP) $(CLIPFLAGS) -s -e -M test.prg

cld_obj.o: cld_obj.prg
	$(CLIP) $(CLIPFLAGS)  cld_obj.prg

cld_obj.po: cld_obj.prg
	$(CLIP) $(CLIPFLAGS) -p cld_obj.prg

init.o: init.prg
	$(CLIP) $(CLIPFLAGS)  init.prg

init.po: init.prg
	$(CLIP) $(CLIPFLAGS) -p init.prg

menu.o: menu.prg
	$(CLIP) $(CLIPFLAGS)  menu.prg

menu.po: menu.prg
	$(CLIP) $(CLIPFLAGS) -p menu.prg

source.o: source.prg
	$(CLIP) $(CLIPFLAGS)  source.prg

source.po: source.prg
	$(CLIP) $(CLIPFLAGS) -p source.prg

command.o: command.prg
	$(CLIP) $(CLIPFLAGS)  command.prg

command.po: command.prg
	$(CLIP) $(CLIPFLAGS) -p command.prg

values.o: values.prg
	$(CLIP) $(CLIPFLAGS)  values.prg

values.po: values.prg
	$(CLIP) $(CLIPFLAGS) -p values.prg

viewset.o: viewset.prg
	$(CLIP) $(CLIPFLAGS)  viewset.prg

viewset.po: viewset.prg
	$(CLIP) $(CLIPFLAGS) -p viewset.prg

viewali.o: viewali.prg
	$(CLIP) $(CLIPFLAGS)  viewali.prg

viewali.po: viewali.prg
	$(CLIP) $(CLIPFLAGS) -p viewali.prg

monitor.o: monitor.prg
	$(CLIP) $(CLIPFLAGS)  monitor.prg

monitor.po: monitor.prg
	$(CLIP) $(CLIPFLAGS) -p monitor.prg

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

