CLIPROOT = ..
CLIP	= ../clip
CLIPFLAGS = -a -l -O -n -I .. -I ../include
CLIPFLAGS2 = -a -O -n -I .. -I ../include
CLIPLIBS  =
OBJS  = _prompt.o a2edit.o achoice.o bl_func.o blank.o box.o browse.o \
	db_func.o dbedit.o dbeval.o dtools.o dummy.o errorsys.o fdummy.o \
	filed.o filedd.o frmback.o frmrun.o ftools.o \
	getcolor.o getsys.o hotkeys.o htools.o imenu.o \
	lblback.o map_func.o memoedit.o menusys.o mset.o nation.o \
	p_func.o p_imode.o p_ourget.o p_secret.o rtcompil.o \
	sets.o str_func.o sys_init.o sys_exit.o timefunc.o var_func.o \
	hbrowse.o ct_shtm.o dbtotal.o browsys.o sqlbrows.o \
	foxsel.o foxsql.o foxscope.o foxdbfunc.o foxkey.o foxsys.o foxwin.o\
	hbrowtbl.o sys_prn.o scr_func.o scr_tools.o pv_fv.o ft_ontick.o \
	mimetype.o print_funcs.o

OBJS2 =  key_func.o key_func2.o

.SUFFIXES: .prg .o

all:    $(OBJS) $(OBJS2)
#	ar -r libclipfuncs.a *.o
	../clip_makelib libclipfuncs.a *.o
	rm -rf *.c

clean:
	rm -rf *.o *.c *.s *.a *.so *.b *.BAK *.bak *~ core* *core
	rm -f *.ex *.nm

key_func.o: key_func.prg
	$(CLIP) $(CLIPFLAGS2) key_func.prg

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

