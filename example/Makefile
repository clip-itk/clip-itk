
PROGS=hello test_dbf pg task task_msg mouse testlock reclock inkey


all: $(PROGS)

clean:
	rm -f $(PROGS) *.a *.so *.dll *.o *.c *.exe *.dbf *.dbt *.ntx *.cdx *.ndx

strip:
	strip $(PROGS)

test.dbf: test.dbf.orig
	cp test.dbf.orig test.dbf

hello: hello.prg test.dbf
	clip -e -M hello.prg

test_dbf: test_dbf.prg
	clip -e -M test_dbf.prg

pg: pg.prg
	clip -e -M pg.prg

task: task.prg
	clip -e -M task.prg

task_msg: task_msg.prg
	clip -e -M task_msg.prg

mouse: mouse.prg
	clip -e -M mouse.prg

testlock: testlock.prg
	clip -e -M testlock.prg

reclock: reclock.prg test.dbf
	clip -e -M reclock.prg

inkey: inkey.prg
	clip -e -M inkey.prg


