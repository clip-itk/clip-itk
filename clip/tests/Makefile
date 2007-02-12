TESTS = test.dbf mathtest type_field obj obj_p ttt_p ttt param set_t err \
	macro1 param1 loop mem_file mainp.pa main a_flag replace memo_t \
	run dutil wind wind2 wind3 key  mouse tbldec pload a dbg pg testlock \
	dispbox inkey memoline hparse transform attoken task1 task2 task3
	#loadso

#CLIP = $(CLIPROOT)/bin/clip
CLIP = clip
#CLPFLAGS = $(CLIPFLAGS)
CLPFLAGS = -v2 -g -l
SF = -s
DBFS = test.dbf ttt.dbf ttt.dbt

all: dbfs $(TESTS)

clean:
	rm -rf *.o *.a *.so *.po *.pa *.b *.BAK *.bak *~ core* *core *.tab.c *.tab.h lex.*.c *.output
	rm -f *.c *.s *.log *.mlog *.pid $(TESTS) $(DBFS) x *.exe *.ex *.nm *.s

dbfs: $(DBFS)

test.dbf: test.dbf.orig
	cp test.dbf.orig test.dbf

ttt.dbf: ttt.dbf.orig
	cp ttt.dbf.orig ttt.dbf

ttt.dbt: ttt.dbt.orig
	cp ttt.dbt.orig ttt.dbt

mathtest: mathtest.prg
	$(CLIP) $(CLPFLAGS) $(SF) -e -M mathtest.prg

type_field: type_field.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M type_field.prg

obj: obj.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M obj.prg

pload: pload.prg $(CLIPLIB) obj.po
	$(CLIP) $(CLPFLAGS) $(SF) -e -M pload.prg

loadso: loadso.prg $(CLIPLIB) obj.so
	$(CLIP) $(CLPFLAGS) $(SF) -e -M loadso.prg

obj_p: obj_p.prg obj.po
	$(CLIP) $(CLPFLAGS) $(SF) -e -M obj_p.prg obj.po

obj.po: obj.prg
	$(CLIP) $(CLPFLAGS) -p obj.prg

obj.so: obj.prg
	$(CLIP) $(CLPFLAGS) -s obj.prg

ttt: ttt.prg $(CLIPLIB) test.dbf
	$(CLIP) $(CLPFLAGS) $(SF) -e -M ttt.prg

ttt_p: ttt_p.prg ttt.po
	$(CLIP) $(CLPFLAGS) $(SF) -e -M ttt_p.prg ttt.po

ttt.po: ttt.prg
	$(CLIP) $(CLPFLAGS) -p ttt.prg

param: param.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M param.prg

param1: param1.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M param1.prg

macro1: macro1.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M macro1.prg


set_t: set_t.prg set_p.po
	$(CLIP) $(CLPFLAGS) $(SF) -e -M set_t.prg set_p.po

set_p.po: set_p.prg
	$(CLIP) $(CLPFLAGS) -p set_p.prg

err: err.prg $(CLIPLIB) errorsys.o
	$(CLIP) $(CLPFLAGS) $(SF) -e -M err.prg errorsys.o

errorsys.o: errorsys.prg
	$(CLIP) $(CLPFLAGS) errorsys.prg

loop: loop.prg $(CLIPLIB) loop_p.po
	$(CLIP) $(CLPFLAGS) $(SF) -e -M loop.prg loop_p.po

loop_p.po: loop_p.prg
	$(CLIP) $(CLPFLAGS) -p loop_p.prg

mem_file: mem_file.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M mem_file.prg

mainp.po: mainp.prg
	$(CLIP) $(CLPFLAGS) -p mainp.prg

mem_file.po: mem_file.prg
	$(CLIP) $(CLPFLAGS) -p mem_file.prg

mainp.pa: mainp.po set_p.po mem_file.po
	../clipar mainp.pa mainp.po set_p.po mem_file.po

main: $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -o main mainp.pa

a_flag: a_flag.prg $(CLIPLIB) #a1.a
	$(CLIP) $(CLPFLAGS) $(SF) -e -M -a a_flag.prg #a1.a

a: a.prg $(CLIPLIB) dbfs
	$(CLIP) $(CLPFLAGS) $(SF) -I. -e -M a.prg #aa.o #../a.a

task1: task1.prg $(CLIPLIB) 
	$(CLIP) $(CLPFLAGS) $(SF) -I. -e -M task1.prg 

task2: task2.prg $(CLIPLIB) 
	$(CLIP) $(CLPFLAGS) $(SF) -I. -e -M task2.prg 

task3: task3.prg $(CLIPLIB) 
	$(CLIP) $(CLPFLAGS) $(SF) -I. -e -M task3.prg 

testlock: testlock.prg
	$(CLIP) $(CLPFLAGS) -I. -e -M testlock.prg

reclock: reclock.prg dbfs
	$(CLIP) $(CLPFLAGS) -I. -e -M reclock.prg

dispbox: dispbox.prg
	$(CLIP) $(CLPFLAGS) -I. -e -M dispbox.prg

inkey: inkey.prg
	$(CLIP) $(CLPFLAGS) -I. -e -l -s -n inkey.prg

memoline: memoline.prg
	$(CLIP) $(CLPFLAGS) -I. -e -l -s -M memoline.prg

hparse: hparse.prg
	$(CLIP) $(CLPFLAGS) -I. -e -l -s -M hparse.prg

transform: transform.prg
	$(CLIP) $(CLPFLAGS) -I. -e -l -s -M transform.prg

dbg: dbg.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M dbg.prg

key: key.prg
	$(CLIP) $(CLPFLAGS) $(SF) -e -M key.prg

mouse: mouse.prg
	$(CLIP) $(CLPFLAGS) $(SF) -e -M mouse.prg

tbldec: tbldec.prg
	$(CLIP) $(CLPFLAGS) $(SF) -e -M tbldec.prg

a1.o:   a1.prg
	$(CLIP) $(CLPFLAGS) a1.prg

a1.a:   a1.o
	rm -f a1.a
	ar q a1.a a1.o

replace: replace.prg replacep.po $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M replace.prg replacep.po

replacep.po: replacep.prg
	$(CLIP) $(CLPFLAGS) -p replacep.prg


memo_t: memo_t.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M memo_t.prg

run: run.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M run.prg

dutil: dutil.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) -e -M dutil.prg -lz

wind: wind.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M wind.prg

wind2: wind2.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M wind2.prg

wind3: wind3.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M wind3.prg

attoken: attoken.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -eslM attoken.prg

pg: pg.prg $(CLIPLIB)
	$(CLIP) $(CLPFLAGS) $(SF) -e -M pg.prg

x: x.prg $(CLIPLIB)
#	$(CLIP) $(CLPFLAGS) -e -M x.prg ../libxclip.a `gtk-config --libs` -lz
	$(CLIP) $(CLPFLAGS) -e -M x.prg -lxclip -lz  `gtk-config --libs`
