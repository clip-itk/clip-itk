CLIPROOT = ..
CLIP	= ../clip
CLIPFLAGS = -a -O -n -I .. -I ../include
CLIPLIBS  =
OBJS  = block.o checkbox.o database.o dbm.o dialbox.o dt_obj.o edit.o \
	err_obj.o field.o fw_time.o get_obj.o history.o hparser.o html_obj.o \
	listbox.o listitem.o menuitem.o pp_tb.o pushbutt.o queue.o radiobut.o \
	radiogrp.o rdd_obj.o scrolbar.o smtp_obj.o stack.o htag_obj.o tb_obj.o \
	tcol_obj.o te_find.o tedit_obj.o tfile.o tget_obj.o url_obj.o \
	sarray.o inifile.o cobra_service.o cobra_info.o

.SUFFIXES: .prg .o

all:    $(OBJS)
	#ar -r libclipclasses.a *.o
	../clip_makelib libclipclasses.a *.o
	rm -rf *.c

clean:
	rm -rf *.o *.c *.s *.a *.so *.b *.BAK *.bak *~ core* *core
	rm -f *.ex *.nm


.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<


