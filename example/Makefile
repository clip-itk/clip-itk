
PROGS=hello test_dbf pg task task_msg mouse testlock reclock inkey \
	tcpserv tcpclient


all: $(PROGS)

clean:
	rm -f $(PROGS) *.a *.so *.dll *.o *.c *.exe *.dbf *.dbt *.ntx *.cdx *.ndx *.nm *.ex *.bak *.log

strip:
	strip $(PROGS)

test.dbf: test.dbf.orig
	cp test.dbf.orig test.dbf

hello: hello.prg test.dbf
	clip -eslM hello.prg

test_dbf: test_dbf.prg
	clip -eslM test_dbf.prg

pg: pg.prg
	clip -eslM pg.prg

task: task.prg
	clip -eslM task.prg

task_msg: task_msg.prg
	clip -eslM task_msg.prg

mouse: mouse.prg
	clip -eslM mouse.prg

testlock: testlock.prg
	clip -eslM testlock.prg

reclock: reclock.prg test.dbf
	clip -eslM reclock.prg

inkey: inkey.prg
	clip -eslM inkey.prg

tcpserv: tcpserv.prg
	clip -esl tcpserv.prg

tcpclient: tcpclient.prg
	clip -esl tcpclient.prg


