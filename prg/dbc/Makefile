ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

all:
	cd procs && $(MAKE)
	cd dbc && $(MAKE)
clean:
	cd procs && $(MAKE) clean
	cd dbc  && $(MAKE) clean
	rm -rf *.bak *.ex *.nm *.a
install:
	cd dbc  && $(MAKE) install
