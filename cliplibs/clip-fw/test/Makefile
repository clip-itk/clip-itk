ifdef CLIPROOT
	CLIP	= $(CLIPROOT)/bin/clip
else
	CLIP = clip
endif
CLIPFLAGS = -g -l
CLIPLIBS  =
OBJS  =
BINS = atest bmp combos dlgtest gettest lines test testbar testbrw testlbx \
	testscrl testwsty tooltip

.SUFFIXES: .prg .o .po

all:	$(BINS)

al:	al.prg
	$(CLIP) $(CLIPFLAGS) -e -s -M al.prg -lclip-fw -lclip-gtk

atest:	atest.prg
	$(CLIP) $(CLIPFLAGS) -e -s atest.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e atest.prg -lclip-fw $(CLIPROOT)/lib/libclip-gtk.a -lgtk -lgdk

bmp:	bmp.prg
	$(CLIP) $(CLIPFLAGS) -e -s bmp.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s bmp.prg ./libclip-fw.a -lclip-gtk

combos:	combos.prg
	$(CLIP) $(CLIPFLAGS) -e -s combos.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -P combos.prg -lclip-fw -lclip-gtk

customer: customer.prg
	$(CLIP) $(CLIPFLAGS) -e -s customer.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s customer.prg libclip-gtk.a -lclip-fw -lgtk -lgdk #-lclip-gtk

dlgtest:dlgtest.prg
	$(CLIP) $(CLIPFLAGS) -e -s dlgtest.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -P dlgtest.prg -lclip-fw -lclip-gtk

gettest:gettest.prg
	$(CLIP) $(CLIPFLAGS) -e -s gettest.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -P gettest.prg -lclip-fw -lclip-gtk

gettest2:gettest2.prg
#	$(CLIP) $(CLIPFLAGS) -e -s gettest2.prg -lclip-fw -lclip-gtk -lclip-cti
	$(CLIP) $(CLIPFLAGS) -e -s gettest2.prg -lclip-fw -lclip-gtk
#	$(CLIP) $(CLIPFLAGS) -P gettest2.prg -lclip-fw -lclip-gtk

lines:	lines.prg
	$(CLIP) $(CLIPFLAGS) -e -s lines.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s lines.prg libclip-gtk.a -lclip-fw -lgtk -lgdk #-lclip-gtk

test:	test.prg
	$(CLIP) $(CLIPFLAGS) -e -s test.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s test.prg -lclip-gtk ./libclip-fw.a -lgtk -lgdk
#	$(CLIP) $(CLIPFLAGS) -e -s test.prg ./libclip-gtk.a -lclip-fw -lgtk -lgdk

testbar: testbar.prg
	$(CLIP) $(CLIPFLAGS) -e -s testbar.prg -lclip-fw -lclip-gtk -lclip-cti

testbrw: testbrw.prg
	$(CLIP) $(CLIPFLAGS) -e -s testbrw.prg -lclip-fw -lclip-gtk -lclip-cti

testlbx: testlbx.prg
	$(CLIP) $(CLIPFLAGS) -e -s testlbx.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s testlbx.prg ./libclip-fw.a ./libclip-gtk.a -lgtk -lgdk


testscrl: testscrl.prg
#	$(CLIP) $(CLIPFLAGS) -P testscrl.prg -lclip-fw -lclip-gtk
	$(CLIP) $(CLIPFLAGS) -e -s testscrl.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s testscrl.prg ./libclip-fw.a ./libclip-gtk.a -lgtk -lgdk

testtabs: testtabs.prg
#	$(CLIP) $(CLIPFLAGS) -P testtabs.prg -lclip-fw -lclip-gtk
	$(CLIP) $(CLIPFLAGS) -e -s testtabs.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s testtabs.prg ./libclip-fw.a ./libclip-gtk.a -lgtk -lgdk

testwsty: testwsty.prg
#	$(CLIP) $(CLIPFLAGS) -P testwsty.prg -lclip-fw -lclip-gtk
	$(CLIP) $(CLIPFLAGS) -e -s testwsty.prg -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s testwsty.prg ./libclip-fw.a ./libclip-gtk.a -lgtk -lgdk

tooltip: tooltip.prg
	$(CLIP) $(CLIPFLAGS) -e -s tooltip.prg -lclip-fw -lclip-gtk  -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s tooltip.prg ./libclip-fw.a ./libclip-gtk.a -lgtk -lgdk

t:	t.prg
	$(CLIP) $(CLIPFLAGS) -e -s -M t.prg   -lclip-gtk
#	$(CLIP) $(CLIPFLAGS) -e -s -M t.prg libclip-gtk.a -lclip-fw -lgtk -lgdk #-lclip-gtk

tt:	tt.prg
	$(CLIP) $(CLIPFLAGS) -e -s -M tt.prg  -lclip-fw -lclip-gtk -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s -M tt.prg  -lclip-cti
#	$(CLIP) $(CLIPFLAGS) -e -s -M tt.prg libclip-gtk.a -lclip-fw -lgtk -lgdk #-lclip-gtk

gtktest: gtktest.prg
	$(CLIP) $(CLIPFLAGS) -e -s -M gtktest.prg  -lclip-gtk
log:
	rm -f *.log
	date

clean:
	rm -f *.exe *.c *.o *.po *.log *.bak $(BINS) *.ex *.nm

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

